/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBODI317VA 2.00.00.007 } /*** "010007" ***/


/* Include i-epc200.i: Defini»’o Temp-Table tt-epc */
{include/i-epc200.i}

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE r-wt-docto    AS ROWID       NO-UNDO.
DEFINE VARIABLE r-wt-it-docto AS ROWID       NO-UNDO.
DEF VAR hDBOdi317             AS HANDLE  NO-UNDO.

{include/boerrtab.i}
{method/dbotterr.i} /** Definicao temp-table rowErrors **/

IF  p-ind-event = "fim-validacoes" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event  
          AND tt-epc.cod-parameter = "OBJECT-HANDLE":U:
        ASSIGN hDBOdi317 = WIDGET-HANDLE(tt-epc.val-parameter).
    END.
        
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = 'beforeValidaSaldoDisponivel' 
          AND tt-epc.cod-parameter = "rowid(wt-it-docto)":
          ASSIGN r-wt-it-docto = TO-ROWID(tt-epc.val-parameter).
    END.
     
    FOR FIRST wt-it-docto NO-LOCK
        WHERE ROWID(wt-it-docto) = r-wt-it-docto: 

        IF  NOT CAN-FIND(FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao
              AND ((natur-oper.transf    AND  natur-oper.especie-doc = "NFT") /* Nota Fiscal Transferencia */
              OR  (natur-oper.terceiros  /*TERCEIRO*/  AND 
                   ( natur-oper.tp-oper-terc = 8 /*Rem. Deposito Fechado*/ OR natur-oper.tp-oper-terc = 1 /* Remessa Beneficiamento*/  OR natur-oper.tp-oper-terc = 10 /* Remessa ARM. gERAL*/ ))))  
        THEN DO:
            IF  wt-it-docto.nr-pedcli <> '' THEN DO:
                IF  CAN-FIND(FIRST gg-param-item
                             WHERE gg-param-item.it-codigo = wt-it-docto.it-codigo
                               AND gg-param-item.log-utiliza-caract-lote) THEN DO:
    
                    FOR EACH wt-fat-ser-lote NO-LOCK 
                        WHERE wt-fat-ser-lote.seq-wt-docto    = wt-it-docto.seq-wt-docto
                          AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto:
                        
                        FOR FIRST gg-lote NO-LOCK
                            WHERE gg-lote.cod-lote       = wt-fat-ser-lote.lote
                              AND gg-lote.it-codigo      = wt-fat-ser-lote.it-codigo  
                              AND gg-lote.cod-refer-item = wt-fat-ser-lote.cod-refer:
             
                            IF  gg-lote.nr-pedcli     <> wt-it-docto.nr-pedcli  THEN DO:
                                RUN utp/ut-msgs.p (INPUT "HELP":U,
                                                   INPUT 56913, //O Lote  ( &1 ) j  esta relacionado a outro pedido de venda.
                                                   INPUT wt-fat-ser-lote.lote).
                
                                RUN _insertErrorManual IN hDBOdi317 (INPUT 56913,
                                                                     INPUT "EMS":U,
                                                                     INPUT "ERROR":U,
                                                                     INPUT RETURN-VALUE,
                                                                     INPUT RETURN-VALUE,
                                                                     INPUT "":U).
                                CREATE tt-epc.
                                ASSIGN tt-epc.cod-event     = "ERROR":U
                                       tt-epc.cod-parameter = "EPC-ERROR":U 
                                       tt-epc.val-parameter = "Processo Abortado".
                                 
                                RETURN "NOK".
                            END. //pedido do lote diferente 
                            
                            IF gg-lote.num-instruc = 0 OR  gg-lote.num-instruc   = ?  OR gg-lote.cod-contrato = '' OR  gg-lote.num-seq-prod = 0 OR 
                               can-find(FIRST gg-libera-embarq NO-LOCK
                                        WHERE gg-libera-embarq.ep-codigo    = gg-lote.ep-codigo
                                          AND gg-libera-embarq.num-instruc  = gg-lote.num-instruc
                                          AND gg-libera-embarq.idi-status  <> 2 /*Aprovada*/ )  THEN DO:
    
                               RUN utp/ut-msgs.p (INPUT "MSG":U,
                                                  INPUT 56914, //O Lote deve possuir uma Instrucao de embarque valida.
                                                  INPUT wt-fat-ser-lote.lote).
                
                               RUN _insertErrorManual IN hDBOdi317 (INPUT 56914,
                                                                    INPUT "EMS":U,
                                                                    INPUT "ERROR":U,
                                                                    INPUT RETURN-VALUE,
                                                                    INPUT RETURN-VALUE,
                                                                    INPUT "":U).
                               CREATE tt-epc.
                               ASSIGN tt-epc.cod-event     = "ERROR":U
                                      tt-epc.cod-parameter = "EPC-ERROR":U 
                                      tt-epc.val-parameter = "Processo Abortado".
                               RETURN "NOK".
                            END.
                    
                        END. // gg-lote
    
                    END. // for each  wt-fat-ser-lote

                END. // controle ctl
    
            END. // nr-pedcli
            ELSE DO: // sem reserva e nao ‚ operacao com terceiro ou transferencia 

                IF  CAN-FIND(FIRST natur-oper NO-LOCK
                             WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao
                               AND natur-oper.baixa-estoq  = YES)
                AND CAN-FIND(FIRST gg-param-item
                        WHERE gg-param-item.it-codigo = wt-it-docto.it-codigo
                          AND gg-param-item.log-utiliza-caract-lote) THEN DO:

                    FOR EACH wt-fat-ser-lote NO-LOCK 
                        WHERE wt-fat-ser-lote.seq-wt-docto    = wt-it-docto.seq-wt-docto
                          AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto:
        
                        IF  CAN-FIND( FIRST gg-lote NO-LOCK
                                      WHERE gg-lote.cod-lote       = wt-fat-ser-lote.lote
                                        AND gg-lote.it-codigo      = wt-fat-ser-lote.it-codigo  
                                        AND gg-lote.cod-refer-item = wt-fat-ser-lote.cod-refer
                                        AND (gg-lote.num-instruc   = 0  OR 
                                             gg-lote.num-instruc   = ?  OR
                                             gg-lote.cod-contrato  = '' OR  
                                             gg-lote.num-seq-prod  = 0  OR 
                                             can-find(FIRST gg-libera-embarq NO-LOCK
                                                      WHERE gg-libera-embarq.ep-codigo    = gg-lote.ep-codigo
                                                        AND gg-libera-embarq.num-instruc  = gg-lote.num-instruc
                                                        AND gg-libera-embarq.idi-status  <> 2 /*Aprovada*/ )))  THEN DO:
        
                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 56914, //O Lote deve possuir uma Instrucao de embarque valida.
                                               INPUT wt-fat-ser-lote.lote).
        
                            RUN _insertErrorManual IN hDBOdi317 (INPUT 56914,
                                                                 INPUT "EMS":U,
                                                                 INPUT "ERROR":U,
                                                                 INPUT RETURN-VALUE,
                                                                 INPUT RETURN-VALUE,
                                                                 INPUT "":U).
                            CREATE  tt-epc.
                            ASSIGN  tt-epc.cod-event     = "ERROR":U
                                    tt-epc.cod-parameter = "EPC-ERROR":U 
                                    tt-epc.val-parameter = "Processo Abortado".
        
                            RETURN "NOK".
                        END.

                        IF CAN-FIND( FIRST gg-lote NO-LOCK
                                     WHERE gg-lote.cod-lote       = wt-fat-ser-lote.lote
                                       AND gg-lote.it-codigo      = wt-fat-ser-lote.it-codigo  
                                       AND gg-lote.cod-refer-item = wt-fat-ser-lote.cod-refer) THEN DO:

                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 56913, //O Lote  ( &1 ) j  esta relacionado a outro pedido de venda.
                                               INPUT wt-fat-ser-lote.lote).

                            RUN _insertErrorManual IN hDBOdi317 (INPUT 56913,  //O Lote  ( &1 ) j  esta relacionado a outro pedido de venda.
                                                                 INPUT "EMS":U,
                                                                 INPUT "ERROR":U,
                                                                 INPUT RETURN-VALUE,
                                                                 INPUT RETURN-VALUE + 'ggboin317va',
                                                                 INPUT "":U).
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "ERROR":U
                                   tt-epc.cod-parameter = "EPC-ERROR":U 
                                   tt-epc.val-parameter = "Processo Abortado".
    
                            RETURN "NOK".
                        END.

                    END. // for each  wt-fat-ser-lote
                END. // controle ctb
            END. // else

        END. // nao ‚ ope. terceiro ou remessa

    END. // wt-it-docto

    RETURN "OK":U.
END.

IF  p-ind-event = "BeforeValidaCGC" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "WT-DOCTO-ROWID":
         ASSIGN r-wt-docto = TO-ROWID(tt-epc.val-parameter).
    END.

    FIND FIRST wt-docto NO-LOCK
         WHERE ROWID(wt-docto) = r-wt-docto NO-ERROR.

    IF AVAIL wt-docto THEN DO:

        FIND FIRST gg-inscricao NO-LOCK
             WHERE gg-inscricao.cod-inscricao = int(wt-docto.cod-entrega)
             AND   gg-inscricao.cod-emitente  = wt-docto.cod-emitente NO-ERROR.

        IF AVAIL gg-inscricao THEN DO:

            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "BeforeValidaCGC"
                   tt-epc.cod-parameter = "PossuiInscricao"
                   tt-epc.val-parameter = "YES".

            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "BeforeValidaCGC"
                   tt-epc.cod-parameter = "MudaNaturezaValidacao".
            IF LENGTH (wt-docto.cgc) = 11 THEN  
                ASSIGN tt-epc.val-parameter = "1".
             ELSE 
                ASSIGN tt-epc.val-parameter = "2".
        END.
    END.
   RETURN "OK":U.
END.


