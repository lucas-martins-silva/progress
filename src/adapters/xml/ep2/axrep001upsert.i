EMPTY TEMP-TABLE RowErrors NO-ERROR.

IF ttReturnInvoiceDocument.cStat <> "104" THEN DO:

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-nfe"
                AND   funcao.ativo     ) THEN DO:
    
        ASSIGN c-serie = IF substr(ttReturnInvoiceDocument.chNFe,23,3) <> "000" then string(int(substr(ttReturnInvoiceDocument.chNFe,23,3))) else ""
               c-cgc   = substr(ttReturnInvoiceDocument.chNFe,7,14).

        /* TrataSerieNfe: EPC para trocar a s‚rie numerica pela alfanum‚rica do EMS */
        IF  INDEX(PROGRAM-NAME(1),"ft0909") = 0  /* evita que haja conflito de UPCs quando esta include estÙ definida em programas com interface */  
        AND (   c-nom-prog-dpc-mg97  <> "" 
             OR c-nom-prog-appc-mg97 <> "" 
             OR c-nom-prog-upc-mg97  <> "" ) THEN DO:

            FOR EACH  tt-epc
                WHERE tt-epc.cod-event = "TrataSerieNfe":U:
               DELETE tt-epc.
            END.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "TrataSerieNfe":U
                   tt-epc.cod-parameter = "cnpj":U
                   tt-epc.val-parameter =  substr(ttReturnInvoiceDocument.chNFe,7,14).
                   
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "TrataSerieNfe":U
                   tt-epc.cod-parameter = "rowid":U
                   tt-epc.val-parameter =  STRING(ROWID(nota-fiscal)).

            {include/i-epc201.i "TrataSerieNfe"}
            
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = "TrataSerieNfe":U AND 
                      tt-epc.cod-parameter = "serie-nfe":U :
                
                ASSIGN c-serie = tt-epc.val-parameter.
            END.

            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = "TrataSerieNfe":U AND 
                      tt-epc.cod-parameter = "cnpj":U :
              
                ASSIGN c-cgc = tt-epc.val-parameter.

            END.
        END.
        /* TrataSerieNfe */
    END.

    IF  num-entries(ttReturnInvoiceDocument.dhRecbto,"T") = 2 THEN
        ASSIGN d-dat-ret     = DATE ( INT(ENTRY(2,ENTRY(1,ttReturnInvoiceDocument.dhRecbto,"T"),"-")) , 
                                      INT(ENTRY(3,ENTRY(1,ttReturnInvoiceDocument.dhRecbto,"T"),"-")) , 
                                      INT(ENTRY(1,ENTRY(1,ttReturnInvoiceDocument.dhRecbto,"T"),"-")) )
               c-hra-ret     = replace(ENTRY(2,ttReturnInvoiceDocument.dhRecbto,"T"),":","") NO-ERROR.
    ELSE
        ASSIGN c-hra-ret = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
               d-dat-ret = TODAY.

    FOR EACH  estabelec NO-LOCK 
        WHERE estabelec.cgc = c-cgc /*substr(ttReturnInvoiceDocument.chNFe,7,14) */ 
        &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN
        and   estabelec.idi-tip-emis-nf-eletro > 1    
        &else
        AND   INT(SUBSTR(estabelec.char-1,168,1)) > 1
        &endif :
 
       FIND FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel 
              AND nota-fiscal.serie       = c-serie
              AND nota-fiscal.nr-nota-fis = trim(string(int(substr(ttReturnInvoiceDocument.chNFe,26,9)),">>9999999")) NO-ERROR. 

        IF  NOT AVAIL nota-fiscal
        AND c-serie = "" THEN
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel 
                   AND nota-fiscal.serie       = "0"
                   AND nota-fiscal.nr-nota-fis = trim(string(int(substr(ttReturnInvoiceDocument.chNFe,26,9)),">>9999999")) NO-ERROR. 
         IF AVAIL nota-fiscal THEN DO:

             FIND FIRST ret-nf-eletro WHERE
                 ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel       AND
                 ret-nf-eletro.cod-serie   = nota-fiscal.serie             AND 
                 ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis       AND
                 ret-nf-eletro.cod-msg     = ttReturnInvoiceDocument.cStat AND
                 ret-nf-eletro.dat-ret     = d-dat-ret                     AND
                 ret-nf-eletro.hra-ret     = c-hra-ret                     NO-LOCK NO-ERROR.
             IF  NOT AVAIL ret-nf-eletro THEN DO TRANS:
                 CREATE ret-nf-eletro.
                 ASSIGN ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                        ret-nf-eletro.cod-serie   = nota-fiscal.serie
                        ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                        ret-nf-eletro.cod-msg     = ttReturnInvoiceDocument.cStat
                        ret-nf-eletro.dat-ret     = d-dat-ret
                        ret-nf-eletro.hra-ret     = c-hra-ret
                        ret-nf-eletro.log-ativo   = YES
                        ret-nf-eletro.cod-livre-2 = IF   ttReturnInvoiceDocument.cStat = '100' THEN
                                                         ttReturnInvoiceDocument.xMotivo + " | " + "[Usuario:] " + c-seg-usuario
                                                    ELSE ttReturnInvoiceDocument.xMotivo
                        &IF "{&bf_dis_versao_ems}" >= "2.07" &THEN
                        ret-nf-eletro.cod-protoc  = ttReturnInvoiceDocument.nProt
                        &ELSE
                        ret-nf-eletro.cod-livre-1 = ttReturnInvoiceDocument.nProt
                        &ENDIF .

             END.
            IF nota-fiscal.ind-tip-nota = 8 AND
               nota-fiscal.dt-cancela = ?   THEN DO:  /* Desenvolvimento contigˆncia - Permitir cancelar notas em processamento */
               /* Tratamento p/ Nota Propria gerada no Recebimento */
               RUN inbo/boin090.p PERSISTENT SET h-boin090.
            
               RUN trataNotaFiscalEletronica IN  h-boin090 (INPUT ROWID(ret-nf-eletro),
                                                            INPUT TABLE ttReturnInvoiceDocument).
            
               DELETE PROCEDURE h-boin090.
               ASSIGN h-boin090 = ?.

               FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

               /*Tratamento Cancelamento Ass¡ncrono - se o documento retornou como Rejeitado, enviar solicita‡Æo de Inutiliza‡Æo, e nÆo continuar a atualiza‡Æo no bodi135.p - trataNotaFiscalEletronica*/
               IF &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
                    nota-fiscal.idi-sit-nf-eletro = 13 /*13 - NF-e em Processo de Inutiliza‡Æo*/
                  &else
                    CAN-FIND (FIRST sit-nf-eletro NO-LOCK
                              WHERE sit-nf-eletro.cod-estabel       = nota-fiscal.cod-estabel
                                AND sit-nf-eletro.cod-serie         = nota-fiscal.serie
                                AND sit-nf-eletro.cod-nota-fis      = nota-fiscal.nr-nota-fis
                                AND sit-nf-eletro.idi-sit-nf-eletro = 13)
                  &endif
               THEN RETURN "OK":U.
               /*fim Tratamento Cancelamento Ass¡ncrono*/
            END.
            
            RUN dibo/bodi135.p PERSISTENT SET h-bodi135.
            
            RUN trataNotaFiscalEletronica IN  h-bodi135 (INPUT ROWID(ret-nf-eletro),
                                                         INPUT TABLE ttReturnInvoiceDocument).
            
            DELETE PROCEDURE h-bodi135.
            ASSIGN h-bodi135 = ?.
         END.
   END.
END.

