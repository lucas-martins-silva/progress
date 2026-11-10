
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERS«O ADEQUADO! */

     /* ********* EXECUÄ«O DAS PI - BEGIN ********* */
     IF (cTranAction = "qry") THEN DO:
          /*CHAMADA A PI DE LEITURA DA MENSAGEM */
          RUN PIQuery.

          /*  Caso seja enviado algum filtro que n∆o seja obrigat¢rio ser† setado      */
          /* as faixas inicial e final dos filtros que n∆o foram enviados e em seguida */
          /* ser† efetuada a pesquisa                                                  */

		  IF InitialWarehouseID <> ? 
		  OR InitialBinLocationID <> ?
		  OR InitialLot <> ?
		  OR InitialItemCode <> ?
		  OR InitialCountingSheetNumber <> ? THEN DO:
              IF InitialWarehouseID = ? then
		  	    ASSIGN InitialWarehouseID = ""
                         FinalWarehouseID = "ZZZ".
              IF InitialBinLocationID = ? THEN
                  ASSIGN InitialBinLocationID = ""
                         FinalBinLocationID = "ZZZZZZZZZZ".
              IF InitialLot = ? THEN
                  ASSIGN InitialLot = ""
                         FinalLot = "ZZZZZZZZZZ".
              IF InitialItemCode = ? THEN
                  ASSIGN InitialItemCode = ""
                         FinalItemCode = "ZZZZZZZZZZZZZZZZ".
              IF InitialCountingSheetNumber = ? THEN
                  ASSIGN InitialCountingSheetNumber = 0
                         FinalCountingSheetNumber = 9999999.

              ASSIGN lSelectedRange = YES.
		  END.                                              
		  
		  IF lSelectedRange THEN DO:
              FOR EACH  inventario
                  WHERE inventario.cod-estabel = Site
                    AND inventario.dt-saldo = InventoryDate
                    AND inventario.cod-depos >= InitialWarehouseID
                    AND inventario.cod-depos <= FinalWarehouseID
                    AND inventario.cod-localiz >= InitialBinLocationID
                    AND inventario.cod-localiz <= FinalBinLocationID
                    AND inventario.lote >= InitialLot
                    AND inventario.lote >= FinalLot
                    AND inventario.it-codigo >= InitialItemCode
                    AND inventario.it-codigo <= FinalItemCode
                    AND inventario.nr-ficha >= InitialCountingSheetNumber
                    AND inventario.nr-ficha <= FinalCountingSheetNumber NO-LOCK:
                  
                  IF inventario.situacao <> 2 
		    	  AND inventario.situacao <> 4 THEN NEXT.
                 
		    	  IF LecturerUser <> ? 
		    	  AND LecturerUser <> inventario.cod-confte-contag-1 
                  AND LecturerUser <> inventario.cod-confte-contag-2
                  AND LecturerUser <> inventario.cod-confte-contag-3 THEN NEXT.
                                       
		    	  RUN createReturnTables.
		      END.
		  END.
		  ELSE DO:		  
              FOR EACH  inventario
                  WHERE inventario.cod-estabel = Site
                    AND inventario.dt-saldo = InventoryDate NO-LOCK:
                  
                  IF inventario.situacao <> 2 
                  AND inventario.situacao <> 4 THEN NEXT.
            
                  IF LecturerUser <> ? 
                     AND LecturerUser <> inventario.cod-confte-contag-1 
                     AND LecturerUser <> inventario.cod-confte-contag-2
                     AND LecturerUser <> inventario.cod-confte-contag-3 THEN NEXT.
                                         
                  RUN createReturnTables.
              END.
		  END.
          /*CHAMADA A PI DE MONTAGEM DO ENVIO DA MENSAGEM */
          RUN PIQueryReturnType
          (
               INPUT TABLE ttBatchValues,
               INPUT TABLE ttCount,
               INPUT TABLE ttCountingSheets,
               INPUT TABLE ttOnLineValues,
               INPUT TABLE ttStandardValues
           ).

          /*ENVIO DO RETORNO DA CONSULTA */
          RUN setQueryReturnContent IN hMessageHandler (INPUT hQueryReturnContent).
     END.

     /*ALIMENTAÄ«O DOS ERROS OCORRIDOS NA EFETIVAÄ«O*/
     /*FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, INPUT "business_error", INPUT tt_log_erro.ttv_des_msg_erro).
     END.*/


     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMAÄ«O */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECUÄ«O DAS PI - END ********* */


