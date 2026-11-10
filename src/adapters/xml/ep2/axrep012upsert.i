/* Gravar erros de valida‡Æo de schema feitos pelo TSS, e deixar nota como Rejeitada */

DEFINE VARIABLE c-serie             AS CHARACTER               NO-UNDO.
DEFINE VARIABLE h-axsep003          AS HANDLE                  NO-UNDO.
DEFINE VARIABLE i-tipo-transacao    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE cMotivoInutilizacao AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cgc               AS CHARACTER               NO-UNDO.

DEFINE VARIABLE cTpTrans AS CHARACTER NO-UNDO.
FOR EACH ttNFES4 NO-LOCK:

    /*** Tratamento Troca CNPJ - Protege ***/
    ASSIGN c-cgc = substr(ttNFES4.ID,7,14).
    
    if  c-nom-prog-dpc-mg97  <> "" 
    or  c-nom-prog-appc-mg97 <> "" 
    or  c-nom-prog-upc-mg97  <> "" then do:

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataChaveNFe":U
               tt-epc.cod-parameter = "ChaveNFe":U
               tt-epc.val-parameter = TRIM(ttNFES4.ID).
        
        {include/i-epc201.i "TrataChaveNFe"}
        
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "TrataChaveNFe":U AND 
                  tt-epc.cod-parameter = "RetornoCNPJ":U :
               
             ASSIGN c-cgc = tt-epc.val-parameter.
        END.

    END.
    /*** FIM - Tratamento Troca CNPJ - Protege ***/

    FOR EACH estabelec NO-LOCK
        WHERE estabelec.cgc = c-cgc
        &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN
        and   estabelec.idi-tip-emis-nf-eletro > 1    
        &else
        AND   INT(SUBSTR(estabelec.char-1,168,1)) > 1
        &endif  :
    
        ASSIGN c-serie = (IF SUBSTR(TRIM(ttNFES4.ID),23,3) <> "000":U
                          THEN STRING(INT(SUBSTR(TRIM(ttNFES4.ID),23,3)))
                          ELSE "").

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel
            AND   nota-fiscal.serie       = c-serie
            AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES4.ID,26,9)),">>9999999")) :
        END.

        IF  NOT AVAIL nota-fiscal THEN
            NEXT.

        RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                           INPUT "NF-e":U,
                           OUTPUT cTpTrans).
        /*Notas que ainda estÆo pendentes de retorno do TSS   */
        /*  2 - Em processamento no EAI                       */
        /*  8 - Em processamento no aplicativo de transmissÆo */
        IF &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
            (nota-fiscal.idi-sit-nf-eletro   = 1 OR /* No TSS Sincrono a situacao ‚ 1 - Nao gerada */
             nota-fiscal.idi-sit-nf-eletro   = 2 OR 
             nota-fiscal.idi-sit-nf-eletro   = 8)
           &else
            CAN-FIND (FIRST sit-nf-eletro NO-LOCK
                      WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                        AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                        AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis
                        AND (sit-nf-eletro.idi-sit-nf-eletro = 1 /* No TSS Sincrono a situacao ‚ 1 - Nao gerada */
                        OR   sit-nf-eletro.idi-sit-nf-eletro = 2
                        OR   sit-nf-eletro.idi-sit-nf-eletro = 8))
           &endif
        AND ttNFES4.Mensagem <> "":U
        THEN DO:
            
            IF  NOT cTpTrans = "TSS":U THEN DO:
                /* Gravar na ret-nf-eletro somente quando nao for TSS Sincrono    */
                /* pois quando ‚ Sincrono a ret-nf-eletro ‚ gravada pelo programa */
                /* chamador do axsep006                                           */
                CREATE ret-nf-eletro.
                ASSIGN ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                       ret-nf-eletro.cod-serie   = nota-fiscal.serie
                       ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                       ret-nf-eletro.cod-msg     = "0":U
                       ret-nf-eletro.dat-ret     = TODAY
                       ret-nf-eletro.hra-ret     = REPLACE(STRING(TIME, "HH:MM:SS"),":","")
                       ret-nf-eletro.log-ativo   = YES
                       ret-nf-eletro.cod-livre-2 = "[TSS Schema] ":U + TRIM(ttNFES4.Mensagem).
            END.
    
            /* Atualiza para Documento Rejeitado, para ser poss¡vel o reenvio das notas */
            &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
                
                FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
    
                ASSIGN nota-fiscal.idi-sit-nf-eletro = 5.
            &else
           
                FOR FIRST sit-nf-eletro EXCLUSIVE-LOCK
                    WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                      AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                      AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis:
    
                    ASSIGN sit-nf-eletro.idi-sit-nf-eletro = 5.
                END.
            &endif
            
            /*--- Nota Gerada no RE, inutilizar nota rejeitada ---*/
            IF  nota-fiscal.ind-tip-nota = 8 THEN DO:
                FOR FIRST docum-est EXCLUSIVE-LOCK
                    WHERE docum-est.serie-docto  = nota-fiscal.serie
                      AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                      AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                      AND docum-est.nat-operacao = nota-fiscal.nat-operacao:
                END.

                {utp/ut-liter.i "Nota_fiscal_eletr“nica_inutilizada_automaticamente_ap¢s_rejei‡Æo"}
                ASSIGN cMotivoInutilizacao = RETURN-VALUE.

                IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN DO:

                    RUN ftp/ftapi512.p (INPUT "Inutiliza‡Æo",
                                        INPUT ROWID(nota-fiscal),
                                        INPUT cMotivoInutilizacao,
                                        OUTPUT i-tipo-transacao).

                END.
                ELSE DO:
                    IF  NOT VALID-HANDLE(h-axsep003) THEN 
                        RUN adapters/xml/ep2/axsep003.p PERSISTENT SET h-axsep003(OUTPUT TABLE tt_log_erro).
                    
                    RUN PITransUpsert IN h-axsep003 (INPUT estabelec.estado,
                                                     INPUT YEAR(TODAY),
                                                     INPUT estabelec.cgc,
                                                     INPUT "55",
                                                     INPUT nota-fiscal.serie,
                                                     INPUT nota-fiscal.nr-nota-fis,
                                                     INPUT nota-fiscal.nr-nota-fis,
                                                     INPUT cMotivoInutilizacao,
                                                     INPUT "upd":U,
                                                     INPUT "",
                                                     INPUT ROWID(nota-fiscal),
                                                     OUTPUT i-tipo-transacao, /* 1 - Sincrona | 2 - Assincrona */
                                                     OUTPUT TABLE tt_log_erro,
                                                     OUTPUT TABLE tt_nfe_erro).
                END.
                                                 
                /*--- ASSÖNCRONA ---*/
                IF  i-tipo-transacao = 2 THEN DO:

                    /*RE - Atualiza‡Æo Situa‡Æo*/
                    IF  AVAIL docum-est THEN DO:
                        &if "{&bf_dis_versao_ems}":U >= "2.071":U &then
                            ASSIGN docum-est.idi-sit-nf-eletro     = 13.        /*13 - NF-e em processo de Inutiliza‡Æo*/
                        &else
                            ASSIGN OVERLAY(docum-est.char-1,154,2) = '13'.
                        &endif
                    END.
                    
                    /*FT - Atualiza‡Æo Situa‡Æo*/
                    &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
                     
                        FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
                
                        ASSIGN nota-fiscal.idi-sit-nf-eletro = 13.
                    &else
                    
                        FOR FIRST sit-nf-eletro EXCLUSIVE-LOCK
                            WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                              AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                              AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis:
                
                            ASSIGN sit-nf-eletro.idi-sit-nf-eletro = 13.
                        END.
                    &endif
                END.
    
                IF  VALID-HANDLE(h-axsep003) THEN DO:
                    DELETE PROCEDURE h-axsep003.
                    ASSIGN h-axsep003 = ?.
                END.
            END.
            /*--- fim RE*/
        END.

        IF  AVAIL nota-fiscal THEN LEAVE. /*para sair do for each estabelec*/

    END. /*fim FOR EACH estabelec*/
END.

/* o RELEASE estava deixando o registro nota-fiscal "not avail" */
/*RELEASE nota-fiscal   NO-ERROR. */
FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

RELEASE docum-est     NO-ERROR.
RELEASE sit-nf-eletro NO-ERROR.
