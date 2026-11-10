/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9031D 2.00.00.003} /*** "010003" 27/08/2024 08:50:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9031d MBC}
&ENDIF


/**********************************************************************************
**     Programa...: bc9031d.p
**
**     Finalidade.: Adapter - Reporte por Ordem, Por Opera‡Æo, Por Ponto Controle
**
**     Criado em..: Junho/2006
**
**     Versao.....: 1.00.00.000 
**********************************************************************************/

/*********************************************************************************/
{cdp/cd0666.i}   /* temp-table de erros                                          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
{cdp/cdcfgman.i} /* Vari vel preprocessador bf_man_sfc_lc                        */
{sfc/sfapi009.i} /* temp-table tt-import-rep-oper                                */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT  PARAMETER pNumTrans    AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttIntegracao.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/
DO:
    FIND FIRST ttIntegracao NO-LOCK NO-ERROR.

    IF NOT AVAIL ttIntegracao THEN DO:
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 25346,
                           INPUT "bc9031d").
        CREATE  tt-erro.
        ASSIGN  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = TRIM(RETURN-VALUE).
        RETURN 'NOK'.
    END.

    CREATE tt-import-rep-oper.
    ASSIGN tt-import-rep-oper.tipo-rep         = _RetornaValInte("tipo-rep":U).
    ASSIGN tt-import-rep-oper.nr-ord-produ     = _RetornaValInte("nr-ord-produ":U).
    ASSIGN tt-import-rep-oper.num-operac-sfc   = _RetornaValInte("num-operac-sfc":U).
    ASSIGN tt-import-rep-oper.num-split-operac = _RetornaValInte("num-split-operac":U).
    ASSIGN tt-import-rep-oper.cod-roteiro      = _RetornaValChar("cod-roteiro":U).
    ASSIGN tt-import-rep-oper.op-codigo        = _RetornaValInte("op-codigo":U).
    ASSIGN tt-import-rep-oper.cod-ctrab        = _RetornaValChar("cod-ctrab":U).
    ASSIGN tt-import-rep-oper.it-codigo	       = _RetornaValChar("it-codigo":U).
    ASSIGN tt-import-rep-oper.cod-refer	       = _RetornaValChar("cod-refer":U).
    ASSIGN tt-import-rep-oper.lote-serie       = _RetornaValChar("lote-serie":U).
    ASSIGN tt-import-rep-oper.dat-valid-lote   = _RetornaValData("dat-valid-lote":U).
    ASSIGN tt-import-rep-oper.qtd-produzida    = _RetornaValDeci("qtd-produzida":U).
    ASSIGN tt-import-rep-oper.cod-motiv-refugo = _RetornaValChar("cod-motiv-refugo":U).
    ASSIGN tt-import-rep-oper.qtd-refugada     = _RetornaValDeci("qtd-refugada":U).
    ASSIGN tt-import-rep-oper.qtd-retrabalho   = _RetornaValDeci("qtd-retrabalho":U).
    ASSIGN tt-import-rep-oper.ct-refugo        = _RetornaValChar("ct-refugo":U).
    ASSIGN tt-import-rep-oper.sc-refugo        = _RetornaValChar("sc-refugo":U).
    ASSIGN tt-import-rep-oper.dat-inic-rep     = _RetornaValData("dat-inic-rep":U).
    ASSIGN tt-import-rep-oper.hr-inic-rep      = _RetornaValDeci("hr-inic-rep":U).
    ASSIGN tt-import-rep-oper.dat-fim-rep      = _RetornaValData("dat-fim-rep":U).
    ASSIGN tt-import-rep-oper.hr-fim-rep       = _RetornaValDeci("hr-fim-rep":U).
    ASSIGN tt-import-rep-oper.dat-inic-setup   = _RetornaValData("dat-inic-setup":U).
    ASSIGN tt-import-rep-oper.hr-inic-setup    = _RetornaValDeci("hr-inic-setup":U).
    ASSIGN tt-import-rep-oper.dat-fim-setup    = _RetornaValData("dat-fim-setup":U).
    ASSIGN tt-import-rep-oper.hr-fim-setup     = _RetornaValDeci("hr-fim-setup":U).
    ASSIGN tt-import-rep-oper.cod-equipe       = _RetornaValChar("cod-equipe":U).
    ASSIGN tt-import-rep-oper.cod-operador     = _RetornaValChar("cod-operador":U).
    ASSIGN tt-import-rep-oper.cod-ferramenta   = _RetornaValChar("cod-ferramenta":U).
    ASSIGN tt-import-rep-oper.finaliza	       = _RetornaValLogi("finaliza":U).
    ASSIGN tt-import-rep-oper.linha            = _RetornaValInte("linha":U).
    ASSIGN tt-import-rep-oper.erro             = _RetornaValLogi("erro":U).

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-erro THEN
        RETURN "NOK":U.

    &IF "{&mguni_version}" <= "2.04" &THEN
        RUN sfc/sfapi009.p (INPUT  204 /* p-versao-integ */,
                            INPUT  TABLE tt-import-rep-oper,
                            OUTPUT TABLE tt-erro).
    &ELSE
        RUN sfc/sfapi009.p (INPUT  205 /* p-versao-integ */,
                            INPUT  TABLE tt-import-rep-oper,
                            OUTPUT TABLE tt-erro).
    &ENDIF.
END.
