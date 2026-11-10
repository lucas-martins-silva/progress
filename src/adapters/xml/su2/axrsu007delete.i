    EMPTY TEMP-TABLE RowErrors   NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
    
    IF(RequisitionNumber <> 0 AND RequisitionNumber <> ?) AND 
      (Sequence <> 0 AND Sequence <> ?) AND 
      (ItemCode <> "" AND ItemCode <> ?)  THEN DO:
      
      FIND FIRST it-requisicao 
           WHERE it-requisicao.nr-requisicao = RequisitionNumber
             AND it-requisicao.it-codigo     = ItemCode
             AND it-requisicao.sequencia     = Sequence NO-LOCK NO-ERROR.
      IF NOT AVAIL it-requisicao THEN DO:

          CREATE tt_log_erro.
          ASSIGN ttv_num_cod_erro  = 2    
                 ttv_des_msg_ajuda = "business_error":U       
                 ttv_des_msg_erro  = "NÆo encontrada Item Requisi‡Æo para a chave informada.".
      END.
      ELSE DO:
          /*Bo valida‡Æo it-requisi‡Æo*/
            RUN inbo/boin168.p PERSISTENT SET h-boin168.
            RUN openQueryStatic IN h-boin168 (INPUT "Main").
            RUN goToKey IN h-boin168(INPUT RequisitionNumber,INPUT Sequence,INPUT ItemCode).
            run deleteRecord in h-boin168.
            RUN getRowErrors IN h-boin168(OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN
                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).

      END.
    END.
    ELSE DO:
        CREATE tt-requisicao.
        ASSIGN tt-requisicao.nr-requisicao = RequisitionNumber.
        
        FIND FIRST requisicao
             WHERE requisicao.nr-requisicao = RequisitionNumber NO-LOCK NO-ERROR.
        IF NOT AVAIL requisicao THEN DO:
             
            CREATE tt_log_erro.
            ASSIGN ttv_num_cod_erro  = 2    
                   ttv_des_msg_ajuda = "business_error":U       
                   ttv_des_msg_erro  = "NÆo encontrada Requisi‡Æo para a chave informada.".
        END.
        ELSE DO:
            
            /*Bo valida‡Æo requisi‡Æo*/
            RUN inbo/boin385.p PERSISTENT SET h-boin385.
            RUN openQueryStatic IN h-boin385 (INPUT "Main").
            RUN goToKeyRequisicao IN h-boin385(INPUT tt-requisicao.nr-requisicao).
            run deleteRecord in h-boin385.
            RUN getRowErrors IN h-boin385(OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN
                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
        
        END.
    END.
    
    /*IF CAN-FIND(FIRST tt_log_erro) THEN DO:
       FOR EACH tt_log_erro:

           RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                            INPUT tt_log_erro.ttv_des_msg_ajuda,  
                                            INPUT tt_log_erro.ttv_des_msg_erro).
       END.
    END.*/
