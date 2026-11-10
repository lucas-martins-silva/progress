/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0110C 2.00.00.003}  /*** 010003 ***/
/*------------------------------------------------------------------------
    File        : bc0110c.p
    Purpose     : Proxy para atualizar transaá∆o no EMS ou Magnus

    Syntax      : run bcp/bc0110c.p (nr-trans, conteudo, tt-erro)

    Description : Le os dados da transaá∆o e executa adapter do EMS
                  ou Magnus.

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : O segundo parametro (conteudo) n∆o Ç usado. ê definido
                  para manter compatibilidade com padr∆o antigo.
------------------------------------------------------------------------*/
                
/* ***************************  Definitions  ************************** */

{cdp/cd0666.i}                  /* Definicao da temp-table de erros  */
{bcp/bc1000.i &loca=BC0110C}    /* Procedure geraTTErro              */
{bcp/bcapi017.i}                /* Definicao da temp-table tt-xml    */
{bcp/bcapi019.i}                /* Definicao da temp-table tt-campos */


DEF INPUT PARAM p-nr-trans      LIKE bc-trans.nr-trans NO-UNDO.
DEF INPUT PARAM p-conteudo      LIKE bc-trans.conteudo-trans NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

/* ***************************  Main Block  *************************** */

DEF VAR h-bcapi017      AS HANDLE   NO-UNDO.

DEF VAR v-cod-layout    AS INTEGER  NO-UNDO.
DEF VAR v-log-datasul   AS LOGICAL  NO-UNDO.
DEF VAR v-num-versao    AS INTEGER  NO-UNDO.

/* obtem layout e tt-campos a partir da transaá∆o. */
RUN bcp/bcapi017.p PERSISTENT SET h-bcapi017.

RUN obtemTTCampos IN h-bcapi017 (p-nr-trans, OUTPUT TABLE tt-campos, INPUT-OUTPUT TABLE tt-erro).
IF  RETURN-VALUE = "NOK":U THEN DO:
    DELETE PROCEDURE h-bcapi017.
    RETURN "NOK":U.
END.

RUN obtemLayoutTransacao IN h-bcapi017 (p-nr-trans, 
                                        OUTPUT v-cod-layout, OUTPUT v-log-datasul, OUTPUT v-num-versao, 
                                        INPUT-OUTPUT TABLE tt-erro).
IF  RETURN-VALUE = "NOK":U THEN DO:
    DELETE PROCEDURE h-bcapi017.
    RETURN "NOK":U.
END.

DELETE PROCEDURE h-bcapi017.

/* executa prÇ-api do Magnus ou EMS */
FIND FIRST param-bc NO-LOCK NO-ERROR.
IF  NOT AVAIL param-bc THEN DO:
    {utp/ut-table.i mgcld param-bc 1}
    RUN geraTTErro (2, TRIM(RETURN-VALUE), "").
    RETURN "NOK":U.
END.
&if '{&mgcld_version}' <= '2.04' &then
    IF  param-bc.int-2 = 1 THEN /* ems */
&else
    IF  param-bc.ind-sistema = 1 THEN /* ems */
&endif
    RUN bcp/bc0110d.p (v-cod-layout, 
                       v-log-datasul, 
                       v-num-versao,
                       INPUT TABLE tt-campos, 
                       INPUT-OUTPUT TABLE tt-erro).
&if '{&mgcld_version}' <= '2.04' &then
    IF  param-bc.int-2 = 2 THEN /* magnus i */
&else
    IF  param-bc.ind-sistema = 2 THEN /* magnus i */
&endif
    RUN bcp/bc0110e.p (v-cod-layout, 
                       v-log-datasul, 
                       v-num-versao,
                       INPUT TABLE tt-campos, 
                       INPUT-OUTPUT TABLE tt-erro).

/* retorna status */
FIND FIRST tt-erro NO-ERROR.
RETURN (IF AVAIL tt-erro THEN "NOK":U ELSE "OK":U).

/* fim */
                                           

