/* Include que monta a temp-table dos registros que irao ser apresentados no WCC0526 */

/*BOIN168Q03.I3*/

            FOR FIRST ITEM FIELDS(cod-comprado
                                  it-codigo
                                  narrativa
                                  tipo-contr
                                  fm-codigo
                                  desc-item)
                WHERE item.it-codigo = it-requisicao.it-codigo NO-LOCK: END.

            IF SUBSTRING(it-requisicao.char-1,2,12) <> "" THEN DO:
                FOR FIRST comprador FIELDS(cod-comprado)
                    WHERE comprador.cod-comprado = SUBSTRING(it-requisicao.char-1,2,12) NO-LOCK: END.

                IF AVAIL comprador AND comprador.cod-comprado <> p-cod-comprado THEN
                    ASSIGN l-considera = NO.

                IF SUBSTRING(it-requisicao.char-1,2,12) <> p-cod-comprado THEN
                    ASSIGN l-considera = NO.

            END.
            ELSE DO:
                FIND FIRST item-uni-estab 
                     WHERE item-uni-estab.cod-estabel = requisicao.cod-estabel 
                     AND   item-uni-estab.it-codigo   = it-requisicao.it-codigo NO-LOCK NO-ERROR.

                IF AVAIL item-uni-estab THEN DO:
                    IF item-uni-estab.cod-comprado <> p-cod-comprado THEN
                        ASSIGN l-considera = NO.
                END. /* ê necess†rio - N∆o tirar */
                ELSE DO:
                    IF AVAIL item AND item.cod-comprado <> p-cod-comprado THEN
                        ASSIGN l-considera = NO.
                END. /* ê necess†rio - N∆o tirar */
            END.

            IF l-considera THEN
                IF NOT CAN-FIND(FIRST familia
                                WHERE familia.fm-codigo  = item.fm-codigo 
                                AND   familia.fm-codigo >= p-familia-ini
                                AND   familia.fm-codigo <= p-familia-fim) THEN
                    ASSIGN l-considera = NO.

            IF l-considera THEN DO:
                ASSIGN i-tp-ressup = 1.
                RUN cdp/cd1406a2.p (INPUT  it-requisicao.it-codigo,
                                    INPUT  requisicao.cod-estabel,
                                    OUTPUT i-tp-ressup).
    
                IF (it-requisicao.ct-codigo + it-requisicao.sc-codigo) = "" AND i-tp-ressup <> 2 THEN
                    ASSIGN l-considera = NO.
            END.

            IF l-considera THEN DO:
                /************** In°cio EPC Grendene ***************************************/
                FOR EACH  tt-epc 
                    WHERE tt-epc.cod-event = "ValidaRegistro":U:
                    DELETE tt-epc.
                END.
                /************** Chamada EPC ***********************************************/
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "ValidaRegistro":U
                       tt-epc.cod-parameter = "NrSolicitacao":U
                       tt-epc.val-parameter = STRING(it-requisicao.nr-requisicao).
    
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "ValidaRegistro":U
                       tt-epc.cod-parameter = "rowidItRequisicao":U
                       tt-epc.val-parameter = STRING(ROWID(it-requisicao)).
    
                {include/i-epc201.i "ValidaRegistro"}
    
                FIND FIRST tt-epc
                     WHERE tt-epc.cod-event     = "ValidaRegistro":U
                     AND   tt-epc.cod-parameter = "retornoValida":U NO-LOCK NO-ERROR.
    
                IF AVAIL tt-epc THEN DO:
                    IF tt-epc.val-parameter = "NO" THEN
                        ASSIGN l-considera = NO.
                END.
                /************** Fim EPC Grendene ******************************************/
            END.

            IF NOT CAN-FIND(FIRST tt-solicitacao
                            WHERE tt-solicitacao.nr-requisicao = it-requisicao.nr-requisicao
                            AND   tt-solicitacao.sequencia     = it-requisicao.sequencia
                            AND   tt-solicitacao.it-codigo     = it-requisicao.it-codigo) THEN DO:

                IF NOT l-considera THEN DO:
                    ASSIGN i-seq-aux = it-requisicao.sequencia
                           l-considera = YES.
                END.
                ELSE DO:
                    IF i-cont = 1 AND r-last = ? THEN ASSIGN r-last = ROWID(it-requisicao).

                    IF i-cont <= i-nrlinhas  THEN DO:

                        CREATE tt-solicitacao.
                        ASSIGN i-cont                        = i-cont + 1
                               tt-solicitacao.nr-requisicao  = it-requisicao.nr-requisicao
                               tt-solicitacao.cod-estabel    = requisicao.cod-estabel
                               tt-solicitacao.it-codigo      = it-requisicao.it-codigo
                               tt-solicitacao.sequencia      = it-requisicao.sequencia
                               tt-solicitacao.cod-depos      = it-requisicao.cod-depos
                               tt-solicitacao.loc-entrega    = requisicao.loc-entrega
                               tt-solicitacao.qt-requisitada = it-requisicao.qt-requisitada
                               tt-solicitacao.qt-atendida    = it-requisicao.qt-atendida
                               tt-solicitacao.qt-devolvida   = it-requisicao.qt-devolvida
                               tt-solicitacao.dt-requisicao  = requisicao.dt-requisicao
                               tt-solicitacao.dt-atend       = it-requisicao.dt-atend
                               tt-solicitacao.dt-devol       = requisicao.dt-devol
                               tt-solicitacao.narrativa      = it-requisicao.narrativa
                               tt-solicitacao.item-narrat    = item.narrativa
                               tt-solicitacao.r-it-requis    = ROWID(it-requisicao)
                               tt-solicitacao.r-rowid        = ROWID(it-requisicao)
                               i-seq-aux                     = tt-solicitacao.sequencia
                               r-first                       = ROWID(it-requisicao).

                        IF AVAIL item THEN
                            IF item.it-codigo = "" AND item.tipo-contr = 4 THEN
                                ASSIGN tt-solicitacao.desc-item = SUBSTRING(it-requisicao.narrativa,1,60).
                            ELSE ASSIGN tt-solicitacao.desc-item = item.desc-item.


/*BOIN168Q03.I3*/
