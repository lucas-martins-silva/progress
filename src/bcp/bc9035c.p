/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9035C 2.00.00.002}  /*** 010002 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9035c MBC}
&ENDIF

/**********************************************************************************
**     Programa...: bc9035c.p
**
**     Finalidade.: Pre-api de Reporte Ppor Ordem, Por Opera‡Æo, Por Ponto Controle
**
**     Criado em..: Julho/2006
**
**     Versao.....: 1.00.00.000 Felipe Crescencio de Oliveira
**********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT  PARAMETER ipiTrans   AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER iprContent AS RAW        NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/
DEFINE VARIABLE cAdapterProgram AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDeviceCode AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNeededFields AS CHARACTER  NO-UNDO
    EXTENT 80
    INITIAL ["tipo":U,
             "nr-reporte":U,
             "nr-ord-produ":U, /*informar este*/
             "data":U, /* today */
             "qt-reporte":U, /*informar*/
             "qt-refugo":U,
             "qt-apr-cond":U,
             "it-codigo":U, /* r360br */
             "un":U,
             "nro-docto":U,
             "serie-docto":U,
             "cod-depos":U,
             "cod-localiz":U,
             "dep-refugo":U,
             "loc-refugo":U,
             "lote-serie":U,
             "cod-refer":U,
             "dt-vali-lote":U,
             "cod-depos-sai":U, /* alm */
             "cod-local-sai":U,
             "op-codigo":U,
             "cod-roteiro":U,
             "it-oper":U,
             "pto-controle":U,
             "sequencia":U,
             "baixa-reservas":U,
             "time-out":U,
             "tentativas":U,
             "procura-saldos":U,
             "carrega-reservas":U,
             "requis-automatica":U,
             "prog-seg":U,
             "finaliza-ordem":U,
             "finaliza-oper":U,
             "reserva":U,
             "nro-ord-seq":U,
             "linha":U,
             "cod-versao-integracao":U,
             "ct-refugo":U,
             "sc-refugo":U,
             "ct-codigo":U,
             "sc-codigo":U,
             "cod-cta-unif":U,
             "cod-ccusto-unif":U,            
             "estado":U,
             "data-transacao":U,
             "cod-unico":U,
             "cod-usuario":U,
             "tipo-movto":U,
             "cd-mob-dir":U,
             "gm-codigo":U,
             "tipo-relogio":U,
             "hora-ini":U,
             "min-ini":U,
             "hora-fim":U,
             "min-fim":U,
             "Tempo-ini":U,
             "Tempo-Fim":U,
             "Centesimal-ini":U,
             "Centesimal-Fim":U,
             "tempo":U,
             "minutos-report":U,
             "referencia":U,
             "matr-func":U,
             "op-final":U,
             "cod-livre-1":U,
             "cod-livre-2":U,
             "cod-livre-3":U,
             "num-livre-1":U,
             "num-livre-2":U,
             "num-livre-3":U,
             "dec-livre-1":U,
             "dec-livre-2":U,
             "dec-livre-3":U,
             "log-livre-1":U,
             "log-livre-2":U,
             "log-livre-3":U,
             "dat-livre-1":U,
             "dat-livre-2":U,
             "dat-livre-3":U].

DEFINE VARIABLE cNeededFieldsTypes AS CHARACTER  NO-UNDO
    EXTENT 80
    INITIAL ["Integer":U,
             "Integer":U,
             "Integer":U,
             "Date":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Date":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Logical":U,
             "Logical":U,
             "Logical":U,
             "Character":U,
             "Logical":U,
             "Logical":U,
             "Logical":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Date":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Integer":U,
             "Character":U,
             "Integer":U,
             "Logical":U,
             "Character":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Integer":U,
             "Integer":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Logical":U,
             "Logical":U,
             "Logical":U,
             "Date":U,
             "Date":U,
             "Date":U].

DEFINE VARIABLE cVarCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVarValue AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iProduct AS INTEGER    NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
DO:
    FIND LAST param-bc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE param-bc THEN
        RETURN "NOK":U.

    &IF '{&mgcld_version}' <= '2.04' &THEN
        ASSIGN iProduct = param-bc.int-2.
    &ELSE
        ASSIGN iProduct = param-bc.ind-sistema.
    &ENDIF

    CASE iProduct:
        WHEN 1 THEN
            ASSIGN cAdapterProgram = "bcp/bc9003d.p":U.
        WHEN 2 THEN
            ASSIGN cAdapterProgram = "bcp/bc9003e.p":U.
    END. /* Case */

    FIND FIRST bc-trans NO-LOCK
         WHERE bc-trans.nr-trans = ipiTrans NO-ERROR.

    IF AVAIL bc-trans THEN DO:
        FOR EACH  bc-trans-filho NO-LOCK
            WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans:

            ASSIGN cDeviceCode = ENTRY(1,bc-trans-filho.conteudo-trans,CHR(30))
                   cVarCode    = ENTRY(2,bc-trans-filho.conteudo-trans,CHR(30)) 
                   cVarValue   = ENTRY(3,bc-trans-filho.conteudo-trans,CHR(30)).

            FIND FIRST bc-eqpto NO-LOCK
                 WHERE bc-eqpto.cod-eqpto = cDeviceCode NO-ERROR.

            IF AVAIL bc-eqpto THEN DO:

                CASE cVarCode:
                    WHEN "cd-mob-dir":U OR
                    WHEN "cod-depos":U OR
                    WHEN "cod-depos-sai":U OR
                    WHEN "cod-livre-1":U OR
                    WHEN "cod-livre-2":U OR
                    WHEN "cod-livre-3":U OR
                    WHEN "cod-localiz":U OR
                    WHEN "cod-local-sai":U OR
                    WHEN "cod-refer":U OR
                    WHEN "cod-roteiro":U OR
                    WHEN "cod-unico":U OR
                    WHEN "cod-usuario":U OR
                    WHEN "ct-codigo":U OR
                    WHEN "sc-refugo":U OR
                    WHEN "ct-refugo":U OR
                    WHEN "ct-refugo":U OR
                    WHEN "cod-cta-unif":U OR
                    WHEN "cod-ccusto-unif":U OR
                    WHEN "dep-refugo":U OR
                    WHEN "estado":U OR
                    WHEN "gm-codigo":U OR
                    WHEN "it-codigo":U OR
                    WHEN "it-oper":U OR
                    WHEN "loc-refugo":U OR
                    WHEN "lote-serie":U OR
                    WHEN "nro-docto":U OR
                    WHEN "prog-seg":U OR
                    WHEN "referencia":U OR
                    WHEN "serie-docto":U OR
                    WHEN "un":U THEN

                        _AddField(cVarCode, cVarValue, "Character":U).

                    WHEN "data":U OR
                    WHEN "data-transacao":U OR
                    WHEN "dat-livre-1":U OR
                    WHEN "dat-livre-2":U OR
                    WHEN "dat-livre-3":U OR
                    WHEN "dt-vali-lote":U THEN

                        _AddField(cVarCode, cVarValue, "Date":U).

                    WHEN "Centesimal-Fim":U OR
                    WHEN "Centesimal-ini":U OR
                    WHEN "dec-livre-1":U OR
                    WHEN "dec-livre-2":U OR
                    WHEN "dec-livre-3":U OR
                    WHEN "qt-apr-cond":U OR
                    WHEN "qt-refugo":U OR
                    WHEN "qt-reporte":U OR
                    WHEN "tempo":U OR
                    WHEN "Tempo-Fim":U OR
                    WHEN "Tempo-ini":U THEN

                        _AddField(cVarCode, cVarValue, "Decimal":U).

                    WHEN "baixa-reservas":U OR
                    WHEN "cod-versao-integracao":U OR
                    WHEN "hora-fim":U OR
                    WHEN "hora-ini":U OR
                    WHEN "linha":U OR
                    WHEN "matr-func":U OR
                    WHEN "min-fim":U OR
                    WHEN "min-ini":U OR
                    WHEN "minutos-report":U OR
                    WHEN "nro-ord-seq":U OR
                    WHEN "nr-ord-produ":U OR
                    WHEN "nr-reporte":U OR
                    WHEN "num-livre-1":U OR
                    WHEN "num-livre-2":U OR
                    WHEN "num-livre-3":U OR
                    WHEN "op-codigo":U OR
                    WHEN "pto-controle":U OR
                    WHEN "sequencia":U OR
                    WHEN "tentativas":U OR
                    WHEN "time-out":U OR
                    WHEN "tipo":U OR
                    WHEN "tipo-movto":U OR
                    WHEN "tipo-relogio":U THEN

                        _AddField(cVarCode, cVarValue, "Integer":U).

                    WHEN "carrega-reservas":U OR
                    WHEN "finaliza-oper":U OR
                    WHEN "finaliza-ordem":U OR
                    WHEN "log-livre-1":U OR
                    WHEN "log-livre-2":U OR
                    WHEN "log-livre-3":U OR
                    WHEN "op-final":U OR
                    WHEN "procura-saldos":U OR
                    WHEN "requis-automatica":U OR
                    WHEN "reserva":U THEN

                        _AddField(cVarCode, cVarValue, "Logical":U).

                END CASE.
            END.
        END.
    END.

    RUN createInitialFields IN THIS-PROCEDURE.
    RUN createNeededFields  IN THIS-PROCEDURE.

    RUN VALUE(cAdapterProgram) (INPUT              ipiTrans,
                                INPUT        TABLE ttIntegracao,
                                INPUT-OUTPUT TABLE tt-erro).
END. /* Do Main */
/***********************************************************************************************************/

PROCEDURE createInitialFields:
    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "tipo":U) THEN
        _AddField("tipo":U, "1":U, "Integer":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "baixa-reservas":U) THEN
        _AddField("baixa-reservas":U, "1":U, "Integer":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "time-out":U) THEN
        _AddField("time-out":U, "30":U, "Integer":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "tentativas":U) THEN
        _AddField("tentativas":U, "10":U, "Integer":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "procura-saldos":U) THEN
        _AddField("procura-saldos":U, "yes":U, "Logical":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "carrega-reservas":U) THEN
        _AddField("carrega-reservas":U, "yes":U, "Logical":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "reserva":U) THEN
        _AddField("reserva":U, "yes":U, "Logical":U).

END PROCEDURE.

PROCEDURE createNeededFields:
    DEFINE VARIABLE cValueAux AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

    DO iCount = 1 TO EXTENT(cNeededFields):

        IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                        WHERE ttIntegracao.atributo = cNeededFields[iCount]) THEN DO:

            CASE cNeededFieldsTypes[iCount]:
                WHEN "Character":U THEN
                    ASSIGN cValueAux = "":U.
                WHEN "Date":U THEN
                    ASSIGN cValueAux = &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF .
                WHEN "Decimal":U THEN
                    ASSIGN cValueAux = "0":U.
                WHEN "Integer":U THEN
                    ASSIGN cValueAux = "0":U.
                WHEN "Logical":U THEN
                    ASSIGN cValueAux = "NO":U.

            END CASE.

            _AddField(cNeededFields[iCount], cValueAux, cNeededFieldsTypes[iCount]).
        END.
    END.

END PROCEDURE.
