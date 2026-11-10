&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI018 2.00.00.003}  /*** 010003 ***/
/*------------------------------------------------------------------------
    File        : bcapi018.p
    Purpose     : Geraá∆o de Etiqueta 2D

    Syntax      : run bcp/bcapi018.p (nr-trans, conteudo, tt-erro)

    Description : Le os dados da transaá∆o e gera etiqueta
    
    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : O segundo parametro (conteudo) n∆o Ç usado. ê definido
                  para manter compatibilidade com chamada pelo bcapi001.
                  Prepara os dados e chama bcapi018a.p que efetivamente 
                  gera a etiqueta.
                  Obs: Para etiqueta 1D ser† necess†rio efetuar fatoraá∆o 
                  em tt-campos. A ser implementado.

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{include/i_dbvers.i}                /* Vers∆o do banco de dados */
{cdp/cd0666.i}                      /* Definicao da temp-table de erros  */
{bcp/bc1000.i &local=BCAPI018}      /* procedure geraTTErro */
{bcp/bcapi019.i}                    /* Temp-table tt-campos */

DEF INPUT PARAM p-nr-trans      LIKE bc-trans.nr-trans NO-UNDO.
DEF INPUT PARAM p-conteudo      LIKE bc-trans.conteudo-trans NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

DEF VAR h-bcapi017              AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    /* carrega bcapi017 para uso no programa */
    RUN bcp/bcapi017.p PERSISTENT SET h-bcapi017.

    RUN processaTransacao.

    DELETE PROCEDURE h-bcapi017.

    /* retorna status */
    FIND FIRST tt-erro NO-ERROR.
    RETURN (IF AVAIL tt-erro THEN "NOK":U ELSE "OK":U).

/* fim */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-processaTransacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaTransacao Procedure 
PROCEDURE processaTransacao :
/*------------------------------------------------------------------------------
  Purpose:     Logica principal da geracao da etiqueta
  Parameters:  <none>
  Notes:       Usa o campo bc-layout.ind-leitura-campo para geraá∆o dos dados.
------------------------------------------------------------------------------*/

    DEF VAR v-rel-arq           AS CHARACTER NO-UNDO.
    DEF VAR v-quant-registro    AS INTEGER   NO-UNDO.
    DEF VAR v-cont              AS INTEGER   NO-UNDO.
    DEF VAR v-valor-campo       AS CHARACTER NO-UNDO.

    /* obtem layout e tt-campos a partir da transaá∆o. */
    RUN obtemTTCampos IN h-bcapi017 (p-nr-trans, OUTPUT TABLE tt-campos, INPUT-OUTPUT TABLE tt-erro).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN.

    /* le bc-trans para obter tipo-etiq e num-versao */
    /* obs: para 2D o tipo-etiq e num-versao deveriam estar em bc-trans, 
            mas est† replicado nos bc-trans-filho */
    FIND FIRST bc-trans-filho
        WHERE bc-trans-filho.nr-trans = p-nr-trans
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-trans-filho THEN DO:
        {utp/ut-table.i mgcld bc-trans-filho 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-nr-trans)).
        RETURN.
    END.
    
    /* localiza o bc-trans para ter o cd-trans e quantidade de etiquetas */
    FIND bc-trans
        WHERE bc-trans.nr-trans = p-nr-trans
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-trans THEN DO:
        {utp/ut-table.i mgcld bc-trans 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-nr-trans)).
        RETURN.
    END.
    
    /* geraá∆o da etiqueta */
    RUN bcp/bcapi018a.p (bc-trans-filho.tipo-etiq, bc-trans-filho.num-versao, bc-trans.cd-trans, 
                        STRING(p-nr-trans) + "A.ETQ":U,
&IF "{&mgcld_version}" <= "2.04" &THEN
                        bc-trans.int-1,
&ELSE
                        bc-trans.qtd_etiqueta,
&ENDIF
                        INPUT TABLE tt-campos, INPUT-OUTPUT TABLE tt-erro).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

