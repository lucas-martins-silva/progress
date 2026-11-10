/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9034D 2.00.00.002} /*** "010002" 27/08/2024 08:50:25 ***/

/**********************************************************************************
**     Programa...: bc9034d.p
**
**     Finalidade.: Adapter - Parada de M quina
**
**     Criado em..: Junho/2006
**
**     Versao.....: 1.00.00.000 
**********************************************************************************/

/*********************************************************************************/
{cdp/cd0666.i}   /* temp-table de erros                                          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
{cdp/cdcfgman.i} /* Vari vel preprocessador bf_man_sfc_lc                        */
{sfc/sfapi010.i} /* temp-table tt-import-rep-parada                              */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT  PARAMETER pNumTrans AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttIntegracao.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/

DO:
    FIND FIRST ttIntegracao NO-LOCK NO-ERROR.

    IF NOT AVAIL ttIntegracao THEN DO:
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 25346,
                           INPUT "bc9003d").
        CREATE  tt-erro.
        ASSIGN  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = TRIM(RETURN-VALUE).
        RETURN 'NOK'.
    END.

    CREATE tt-import-rep-parada.
    ASSIGN tt-import-rep-parada.tipo-rep              = _RetornaValInte("tipo-rep":U).
    ASSIGN tt-import-rep-parada.cod-ctrab             = _RetornaValChar("cod-ctrab":U).
    ASSIGN tt-import-rep-parada.cod-parada            = _RetornaValChar("cod-parada":U).
    ASSIGN tt-import-rep-parada.num-om-progda         = _RetornaValInte("num-om-progda":U).
    ASSIGN tt-import-rep-parada.dat-inic-parada       = _RetornaValData("dat-inic-parada":U).
    ASSIGN tt-import-rep-parada.hr-inic-parada        = _RetornaValDeci("hr-inic-parada":U).
    ASSIGN tt-import-rep-parada.dat-fim-parada        = _RetornaValData("dat-fim-parada":U).
    ASSIGN tt-import-rep-parada.hr-fim-parada         = _RetornaValDeci("hr-fim-parada":U).
    ASSIGN tt-import-rep-parada.val-refer-inic-parada = _RetornaValDeci("val-refer-inic-parada":U).
    ASSIGN tt-import-rep-parada.val-refer-fim-parada  = _RetornaValDeci("val-refer-fim-parada":U).
    ASSIGN tt-import-rep-parada.cod-equipe            = _RetornaValChar("cod-equipe":U).
    ASSIGN tt-import-rep-parada.cod-operador          = _RetornaValChar("cod-operador":U).
    ASSIGN tt-import-rep-parada.linha                 = _RetornaValInte("tipo-rep":U).
    ASSIGN tt-import-rep-parada.erro                  = _RetornaValLogi("erro":U).

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-erro THEN
        RETURN "NOK":U.

    RUN sfc/sfapi010.p (INPUT  204 /* p-versao-integ */,
                        INPUT  TABLE tt-import-rep-parada,
                        OUTPUT TABLE tt-erro).
END.
