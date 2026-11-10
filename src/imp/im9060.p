/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9060 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM9060 MIM}
&ENDIF

{include/i-epc200.i IM9060} /** UPC **/

{method/dbotterr.i} /*Definiá∆o RowErrors*/

DEFINE INPUT PARAMETER pr-rowid AS ROWID NO-UNDO.

DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
   field r-rowid as rowid.

DEFINE VARIABLE c-lit-usuario AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lit-hora    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-bocx230a    AS HANDLE      NO-UNDO.

RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.

FIND FIRST docum-est 
     WHERE ROWID(docum-est) = pr-rowid NO-LOCK NO-ERROR.

IF AVAIL docum-est THEN DO:
    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

    IF AVAIL natur-oper AND natur-oper.nota-rateio THEN NEXT. /*desconsidera notas de rateio*/

    /*Somente atualiza para notas fiscais que n∆o referem-se a notas de ajuste*/
    IF NOT CAN-FIND(FIRST item-doc-est
                    WHERE item-doc-est.cod-emitente  = docum-est.cod-emitente
                      AND item-doc-est.nat-operacao  = docum-est.nat-operacao
                      AND item-doc-est.nro-docto     = docum-est.nro-docto   
                      AND item-doc-est.serie-docto   = docum-est.serie-docto  
                      AND item-doc-est.log-nota-ajust-import) THEN DO:

        FOR EACH embarq-import-docto
            WHERE embarq-import-docto.cod-ser-docto      = docum-est.serie-docto  
              AND embarq-import-docto.cod-docto          = docum-est.nro-docto    
              AND embarq-import-docto.cdn-emitente       = docum-est.cod-emitente 
              AND embarq-import-docto.cod-natur-operac   = docum-est.nat-operacao NO-LOCK:

            FIND FIRST embarque-imp
                 WHERE embarque-imp.cod-estabel = embarq-import-docto.cod-estab
                   AND embarque-imp.embarque    = embarq-import-docto.cod-embarq NO-LOCK NO-ERROR.

            IF AVAIL embarque-imp 
            AND TRIM(SUBSTRING(embarque-imp.char-1,86,5)) <> "" THEN DO: /*Possui ponto de controle de Recebimento*/
                FOR EACH historico-embarque 
                   WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                     AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:

                        IF  historico-embarque.cod-pto-contr  = INT(SUBSTRING(embarque-imp.char-1,86,5))
                        AND historico-embarque.dt-efetiva = ? THEN DO: /*Somente efetiva o ponto de controle do recebimento caso ainda n∆o esteja efetivado*/
                            {utp/ut-liter.i Usu†rio * r}
                            ASSIGN c-lit-usuario = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i Dia/Hora: * r}
                            ASSIGN c-lit-hora = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i Ponto_Efetivado_Automaticamente_via_Atualizaá∆o_da_Nota_no_Recebimento. * R}

                            EMPTY TEMP-TABLE tt-historico-embarque.
                            CREATE tt-historico-embarque.
                            BUFFER-COPY historico-embarque TO tt-historico-embarque.
                            ASSIGN tt-historico-embarque.dt-efetiva      = TODAY
                                   tt-historico-embarque.observacao      = TRIM(RETURN-VALUE) + " " + c-lit-usuario + ": " + docum-est.usuario + " - " + c-lit-hora + ": " + STRING(DATETIME(TODAY,MTIME), "99/99/9999 HH:MM:SS":U).
                                   tt-historico-embarque.r-rowid         = ROWID(historico-embarque).

                            RUN validateUpdate IN h-bocx230a (INPUT TABLE tt-historico-embarque,
                                                              INPUT tt-historico-embarque.r-rowid,
                                                              OUTPUT TABLE RowErrors).

                    
                        END.
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.

    RETURN "OK":U.

END.
