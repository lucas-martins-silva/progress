RUN dibo/bodi601.p PERSISTENT SET h-bodi601. 
RUN openQueryStatic IN h-bodi601 ("Main").

FOR EACH estabelec NO-LOCK WHERE 
         estabelec.cgc = TRIM(SUBSTR(ttretEvento.chNFe,7,14))
         &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN AND   
         estabelec.idi-tip-emis-nf-eletro > 1    
         &ELSE AND   
         INT(SUBSTR(estabelec.char-1,168,1)) > 1
         &ENDIF: 
         
    IF  &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN 
            estabelec.log-emit-carta-correc
        &ELSE 
            LOGICAL(TRIM(SUBSTRING(estabelec.char-1,261,1)) = "S") 
        &ENDIF
    THEN DO:
         
        FOR EACH tt-carta-correc-eletro: DELETE tt-carta-correc-eletro. END.
    
        ASSIGN c-nota-fisc = TRIM(STRING(INT(SUBSTR(ttretEvento.chNFe,26,9)),">>9999999")).

        ASSIGN c-serie = IF  SUBSTR(ttretEvento.chNFe,23,3) <> "000" THEN  
                     STRING(INT(SUBSTR(ttretEvento.chNFe,23,3))) 
                 ELSE "" .
        
        ASSIGN c-hora = SUBSTRING(ttretEvento.dhRegEvento,12,8)
               c-dia  = SUBSTRING(ttretEvento.dhRegEvento,9,2)
               c-mes  = SUBSTRING(ttretEvento.dhRegEvento,6,2)
               c-ano  = SUBSTRING(ttretEvento.dhRegEvento,1,4).

        RUN goToKey        IN h-bodi601 (INPUT estabelec.cod-estabel, INPUT c-serie, INPUT c-nota-fisc, INPUT ttretEvento.nSeqEvento).

        IF  RETURN-VALUE = "OK" THEN DO:
            
            RUN getRecord  IN h-bodi601 (OUTPUT TABLE tt-carta-correc-eletro).
            
            FIND FIRST tt-carta-correc-eletro NO-ERROR.

            ASSIGN tt-carta-correc-eletro.cod-msg            = ttretEvento.cStat
                   tt-carta-correc-eletro.dsl-msg            = ttretEvento.xMotivo
                   tt-carta-correc-eletro.cod-protoc         = ttretEvento.nProt
                   tt-carta-correc-eletro.des-dat-hora-ret   = c-dia + "/" + c-mes + "/" + c-ano + " " + c-hora.

            IF  ttretEvento.cStat <> "0" THEN DO:
            
                IF  ttretEvento.cStat = "128" THEN
                    ASSIGN tt-carta-correc-eletro.idi-sit-event = 2.
                ELSE IF  ttretEvento.cStat = "135" THEN
                    ASSIGN tt-carta-correc-eletro.idi-sit-event = 3.
                ELSE IF  ttretEvento.cStat = "136" THEN
                    ASSIGN tt-carta-correc-eletro.idi-sit-event = 4.
                ELSE 
                    ASSIGN tt-carta-correc-eletro.idi-sit-event = 5.

            END.
            ELSE
                ASSIGN tt-carta-correc-eletro.idi-sit-event = 1.


            RUN setRecord      IN h-bodi601 (INPUT TABLE tt-carta-correc-eletro).
            RUN emptyRowErrors IN h-bodi601.
            RUN updateRecord   IN h-bodi601.
            RUN getRowErrors   IN h-bodi601 (OUTPUT TABLE rowErrors).
    
            FIND FIRST RowErrors WHERE 
                       RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.
            IF  AVAIL RowErrors THEN
                ASSIGN tt-carta-correc-eletro.cod-msg = STRING(ErrorNumber)
                       tt-carta-correc-eletro.dsl-msg = ErrorDescription.
        
        END.
        ELSE DO:
    
                CREATE tt-carta-correc-eletro.
                ASSIGN tt-carta-correc-eletro.cod-estab                = estabelec.cod-estabel 
                       tt-carta-correc-eletro.cod-nota-fisc            = c-nota-fisc
                       tt-carta-correc-eletro.cod-serie                = c-serie
                       tt-carta-correc-eletro.num-seq                  = INT(ttretEvento.nSeqEvento)
                       tt-carta-correc-eletro.cod-msg                  = ttretEvento.cStat
                       tt-carta-correc-eletro.cod-protoc               = ttretEvento.nProt
                       tt-carta-correc-eletro.cod-versao               = ttretEvento.verAplic
                       tt-carta-correc-eletro.des-dat-hora-event       = c-dia + "/" + c-mes + "/" + c-ano + " " + c-hora
                       tt-carta-correc-eletro.des-dat-hora-ret         = c-dia + "/" + c-mes + "/" + c-ano + " " + c-hora
                       tt-carta-correc-eletro.dsl-carta-correc-eletro  = "Carta de Corre‡Æo registrada no integrador. Favor verificar o texto de corre‡Æo no integrador." 
                       tt-carta-correc-eletro.dsl-msg                  = ttretEvento.xMotivo
                       tt-carta-correc-eletro.dsl-xml-armaz            = "Verificar XML no integrador".

                IF  ttretEvento.cStat <> "0" THEN DO:
            
                    IF  ttretEvento.cStat = "128" THEN
                        ASSIGN tt-carta-correc-eletro.idi-sit-event = 2.
                    ELSE IF  ttretEvento.cStat = "135" THEN
                        ASSIGN tt-carta-correc-eletro.idi-sit-event = 3.
                    ELSE IF  ttretEvento.cStat = "136" THEN
                        ASSIGN tt-carta-correc-eletro.idi-sit-event = 4.
                    ELSE 
                        ASSIGN tt-carta-correc-eletro.idi-sit-event = 5.
    
                END.
                ELSE
                    ASSIGN tt-carta-correc-eletro.idi-sit-event = 1.
                      
                RUN setRecord      IN h-bodi601 (INPUT TABLE tt-carta-correc-eletro).
                RUN emptyRowErrors IN h-bodi601.
                RUN createRecord   IN h-bodi601.
                RUN getRowErrors   IN h-bodi601 (OUTPUT TABLE rowErrors).
        
                FIND FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.
                IF  AVAIL RowErrors THEN
                    ASSIGN tt-carta-correc-eletro.cod-msg = STRING(ErrorNumber)
                           tt-carta-correc-eletro.dsl-msg = ErrorDescription.
    
        END.
    
    END.
    
END.

DELETE PROCEDURE h-bodi601.
ASSIGN h-bodi601 = ?.
