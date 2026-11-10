&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ABAPI015 2.00.00.003 } /*** 010003 ***/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi015 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI015.p
**
**       DATA....: Julho de 2017
**
**       AUTOR...: 
**
**       OBJETIVO: Validar informacoes de Frotas
**
*****************************************************************************/

PROCEDURE pi-le-ordem-mv:
/*------------------------------------------------------------------------------
  Purpose:     pi-le-ordem-mv
  Parameters:  Numero ordem
  Notes:       Retorna o tipo da ordem, codigo do componente e seu sub-sistema
------------------------------------------------------------------------------*/

    define input  parameter pi-nr-ord-produ like req-ord-produc.nr-ord-produ no-undo.
    define output parameter pi-tip-ord      like mmv-ord-manut.idi-tip-ord   no-undo.
    define output parameter pc-cod-compon   like mmv-ord-manut.cod-compon    no-undo.
    define output parameter pc-cod-sub-sist like mmv-ord-manut.cod-sub-sist  no-undo.


    FOR FIRST mmv-ord-manut
        WHERE mmv-ord-manut.nr-ord-produ = pi-nr-ord-produ NO-LOCK:

        assign pi-tip-ord      = mmv-ord-manut.idi-tip-ord
               pc-cod-compon   = mmv-ord-manut.cod-compon
               pc-cod-sub-sist = mmv-ord-manut.cod-sub-sist.

    END.
    if not avail mmv-ord-manut then
        return "NOK":U.

    return "OK":U.

END PROCEDURE.

procedure pi-retorna-desc-modelo:
/*------------------------------------------------------------------------------
  Purpose:     pi-retorna-desc-modelo
  Parameters:  Codigo componente, codigo sub-sistema
  Notes:       Retorna a descricao do modelo
------------------------------------------------------------------------------*/
    define input parameter  pc-cod-compon   like mmv-ord-manut.cod-compon   no-undo.
    define input parameter  pc-cod-sub-sist like mmv-ord-manut.cod-sub-sist no-undo.
    define output parameter pi-desc-modelo  like mco-compon.des-model       no-undo.

    FIND FIRST mco-compon
         WHERE mco-compon.cod-compon   = pc-cod-compon
         AND   mco-compon.cod-sub-sist = pc-cod-sub-sist NO-LOCK NO-ERROR.
    
    IF AVAIL mco-compon THEN
        ASSIGN pi-desc-modelo = mco-compon.des-model.
    ELSE
        ASSIGN pi-desc-modelo = "".

    RETURN "OK":U.

end procedure.

procedure pi-verifica-parametro:
/*------------------------------------------------------------------------------
  Purpose:     pi-verifica-parametro
  Parameters:  Codigo parametro
  Notes:       Retorna o valor do parametro
------------------------------------------------------------------------------*/
    define input  parameter pi-cdn-param like mab-param.cdn-param no-undo.
    define output parameter pc-des-valor like mab-param.des-valor no-undo.

    find mab-param where mab-param.cdn-param = pi-cdn-param no-lock no-error.
    if avail mab-param then
        ASSIGN pc-des-valor = mab-param.des-valor.
    ELSE
        ASSIGN pc-des-valor = "".

    return "OK":U.

end procedure.

