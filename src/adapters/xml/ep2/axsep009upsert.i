
PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAMETER pTranAction     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttRetornaNotas_ENV.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/


    /*LOCAL VARIABLES - BEGIN*/
    DEFINE VARIABLE cVersaoLayoutNFe AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTpTrans         AS CHARACTER  NO-UNDO.
    /*LOCAL VARIABLES - END*/
    
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    FOR FIRST ttRetornaNotas_ENV:
    END.
    
    RUN cdp/cd0360b.p (INPUT ttRetornaNotas_ENV.CodEstabel,
                       INPUT "NF-e":U,
                       OUTPUT cTpTrans).

    IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN
        RUN pi-Retorna-Notas-TSS-Sincrono.
    ELSE
        RUN PIUpsert ( INPUT  pTranAction         , /* add / upd */
                       INPUT  pTranEvent          , /* Evento    */
                       INPUT  TABLE ttRetornaNotas_ENV,
                       OUTPUT TABLE tt_log_erro).
    

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

PROCEDURE pi-Retorna-Notas-TSS-Sincrono:
    
    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
    
    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica»’o com o TSS*/
    END.
    
    FIND FIRST ttRetornaNotas_ENV NO-LOCK NO-ERROR.

    IF NOT AVAIL param-nf-estab THEN
        FOR FIRST param-nf-estab NO-LOCK
            WHERE param-nf-estab.cod-estabel = ttRetornaNotas_ENV.CodEstabel: END.
    
    IF  NOT AVAIL param-nf-estab THEN
        RETURN "NOK":U.

    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                 TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                 TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif).
                               
    RUN setTSSAuthParam IN h-TSSAPI(INPUT 1,
                                    INPUT "*",
                                    INPUT param-nf-estab.cod-estabel,
                                    INPUT param-nf-estab.cod-url-ws-tss).
    
    /***** ENVIO DE EMAIL PARA VERSAO LAYOUT NFE 1.10 *****/
    ASSIGN c-serie = (IF SUBSTR(TRIM(ttRetornaNotas_ENV.ChaveNFe),23,3) <> "000":U
                      THEN STRING(INT(SUBSTR(TRIM(ttRetornaNotas_ENV.ChaveNFe),23,3)))
                      ELSE "":U).
					  
    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = param-nf-estab.cod-estabel: 
    END.
	
	
	FIND FIRST nota-fiscal NO-LOCK
		 WHERE nota-fiscal.cod-estabel = ttRetornaNotas_ENV.CodEstabel 
		   AND nota-fiscal.serie       = c-serie
		   AND nota-fiscal.nr-nota-fis = trim(string(int(substr(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999")) NO-ERROR. 

	IF  NOT AVAIL nota-fiscal
	AND c-serie = "" THEN
		FIND FIRST nota-fiscal NO-LOCK
			 WHERE nota-fiscal.cod-estabel = ttRetornaNotas_ENV.CodEstabel 
			   AND nota-fiscal.serie       = "0"
			   AND nota-fiscal.nr-nota-fis = trim(string(int(substr(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999")) NO-ERROR. 

    IF  AVAIL nota-fiscal
    AND &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
        nota-fiscal.idi-sit-nf-eletro   = 6
        &else
        CAN-FIND (FIRST sit-nf-eletro NO-LOCK
                  WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                    AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                    AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis
                    AND sit-nf-eletro.idi-sit-nf-eletro = 6) &ENDIF THEN
        RUN piCancelamento.
    ELSE
        RUN piAutorizacao.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF
       
END PROCEDURE.

PROCEDURE piAutorizacao:
    
    EMPTY TEMP-TABLE ttRetornaNotasTSS.
    EMPTY TEMP-TABLE ttNFES5.
    EMPTY TEMP-TABLE ttNFE.
    EMPTY TEMP-TABLE ttNFECANCELADA.
    
    CREATE ttRetornaNotasTSS.
    ASSIGN ttRetornaNotasTSS.ID  = ttRetornaNotas_ENV.ChaveNFe.
    
    RUN NFESBRA_RETORNANOTASNX IN h-TSSAPI (param-nf-estab.ind-empresa, 
                                            INPUT BUFFER ttRetornaNotasTSS:HANDLE, 
                                            0, /* DIAS PARA EXCLUSAVAO, FIXO = 0 */
                                            INPUT BUFFER ttNFES5:HANDLE,
                                            INPUT BUFFER ttDPEC:HANDLE,  /* Foi alterado para EPEC */
                                            INPUT BUFFER ttNFE:HANDLE,
                                            INPUT BUFFER ttNFECANCELADA:HANDLE,
                                            NO). /* Criptografa XML BASE64 - Yes/No */

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("NFESBRA":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
       CREATE TT_LOG_ERRO.
       ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
    
       /*Busca Mensagem*/
       RUN utp/ut-msgs.p (INPUT "MSG":U,
                          INPUT 36370,
                          INPUT "[TSS RETORNANOTAS]":U + "~~":U + cReturnValue).
       ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
    
       /*Busca Help */
       RUN utp/ut-msgs.p (INPUT "HELP":U,
                          INPUT 36370,
                          INPUT "[TSS RETORNANOTAS]":U + "~~":U + cReturnValue).
       ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:
       FOR FIRST ttNFES5:
           IF  TRIM(ttNFES5.ID) = TRIM(ttRetornaNotas_ENV.ChaveNFe) THEN
               ASSIGN lRetornaNotasTSSOK = YES.
       END.
       
       IF  lRetornaNotasTSSOK THEN DO:
            
           	IF OPSYS <> "WIN32" 
			AND CAN-FIND(FIRST funcao NO-LOCK
						 WHERE funcao.cd-funcao = "SPP-XML-OPSYS"
						   AND funcao.ativo) THEN DO:
					
				FIND FIRST ped-curva 
					 WHERE ped-curva.vl-aberto = 160616
					   AND ped-curva.codigo    = 160616 
					   AND ped-curva.nome      = param-nf-estab.cod-estabel NO-LOCK NO-ERROR.
						
				IF AVAIL ped-curva THEN
					ASSIGN cArquivoXML = TRIM(ped-curva.char-1).				
			END.
		    ELSE
                ASSIGN cArquivoXML = TRIM(param-nf-estab.cod-caminho-xml).
		   
           ASSIGN cArquivoXML = REPLACE(cArquivoXML,"~\","/").

           FIND FIRST para-ped NO-LOCK NO-ERROR.
           
           /*/* Portal de Clientes - Vipal */
           IF &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN 
                  para-ped.log-intgr-portal /* Integra com Pedidos de Penda */
              &ELSE 
                  SUBSTRING(para-ped.char-2,7,1) = "S" /* Integra com Pedidos de Penda */
              &ENDIF THEN DO:*/
               
              FIND FIRST portal-param
                   WHERE portal-param.cod-param = "portal-pasta-arquivos-xml-nfe" NO-LOCK NO-ERROR.
               
              IF AVAIL portal-param AND portal-param.cod-val-param <> "" THEN DO:
			  
				 FIND FIRST nota-fiscal NO-LOCK 
				      WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
				        AND nota-fiscal.serie       = c-serie
 				        AND nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES5.ID,26,9)),">>9999999")) NO-ERROR.
		 
				 IF AVAIL nota-fiscal 
					AND nota-fiscal.nr-pedcli <> "" THEN DO:
					  
					/*IF CAN-FIND(FIRST ped-venda 
			                    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
								  AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
								  AND ped-venda.data-2 <> ?) THEN*/			
								  
						 /****** GRAVA HISTORICO XML EM DIRETORIO PARAMETRIZADO NO PARAMETROS DO PORTAL DE VENDA ******/
					ASSIGN cArquivoXMLAux = portal-param.cod-val-param 
					   	cArquivoXMLAux = REPLACE(cArquivoXMLAux,"~\","/").


                    IF cArquivoXMLAux <> "" THEN DO:
        
                       IF NOT SUBSTR(cArquivoXMLAux,LENGTH(cArquivoXMLAux),LENGTH(cArquivoXMLAux) - 1) = "/"  THEN
                          ASSIGN cArquivoXMLAux = cArquivoXMLAux + "/".
                    
                       ASSIGN cArquivoXMLAux = cArquivoXMLAux + 
                                               param-nf-estab.cod-estabel + SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,23,3) + 
                                               TRIM(STRING(INTEGER(SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,26,9)),">>9999999")).
            
                       ASSIGN cArquivoXMLCancelAux = cArquivoXMLAux + "_Cancel":U + ".xml":U
                              cArquivoXMLAux       = cArquivoXMLAux + ".xml":U.
        
                    END.
                 END.

              END. 
           /*END.*/ 

           IF  cArquivoXML <> "" THEN DO:

               FOR FIRST estabelec NO-LOCK
                   WHERE estabelec.cod-estabel = param-nf-estab.cod-estabel: 
               END.
            
               IF  NOT SUBSTR(cArquivoXML,LENGTH(cArquivoXML),LENGTH(cArquivoXML) - 1) = "/"  THEN
                   ASSIGN cArquivoXML = cArquivoXML + "/".
               
               ASSIGN cArquivoXML = cArquivoXML + 
                                    param-nf-estab.cod-estabel + SUBSTR(ttNFES5.ID,23,3) + 
                                    TRIM(STRING(INTEGER(SUBSTR(ttNFES5.ID,26,9)),">>9999999")).
    
               ASSIGN cArquivoXMLCancel = cArquivoXML + "_Inut":U + ".xml":U
                      cArquivoXML       = cArquivoXML + ".xml":U.
               
               FOR FIRST ttNFE WHERE ttNFE.PROTOCOLO <> "": END.
               FOR FIRST ttDPEC: END.  /* Foi alterado para EPEC */
               FOR FIRST ttNFECANCELADA: END.
    
               ASSIGN cVersaoLayoutNFe = &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                                             Trim(estabelec.des-vers-layout)
                                         &else 
                                             TRIM(SUBSTRING(estabelec.char-1,173,10))
                                         &endif WHEN AVAIL estabelec NO-ERROR.               
               
               IF  AVAIL ttNFE AND
                   NOT AVAIL ttNFECANCELADA THEN DO: /* indica que tem que gravar o XML de autorizacao */
                   ASSIGN lcXmlNfe = ttNFE.XML
                          cXmlProt = ttNFE.XMLPROT.

                   ASSIGN lcXMLNFe = '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="':U + cVersaoLayoutNFe + '">':U + 
                                     lcXmlNfe + 
                                     cXmlProt + 
                                     '</nfeProc>':U.
        
                   CREATE X-DOCUMENT xDocXML.
                   xDocXML:LOAD ('LONGCHAR', lcXmlNfe, NO) NO-ERROR.
                   ASSIGN xDocXML:ENCODING = "UTF-8":U.
                   xDocXML:SAVE ('FILE', cArquivoXML) NO-ERROR.

                   IF cArquivoXMLAux <> "" THEN DO:
                      xDocXML:SAVE ('FILE', cArquivoXMLAux) NO-ERROR.
                   END.
			
		   /* Regras Específicas para Transmissão de Documentos Eletrônicos */	
                   IF estabelec.log-utiliza-docto-tag THEN DO:
                       IF NOT VALID-HANDLE(h-bodi01001) THEN
                           RUN dibo/bodi01001.p PERSISTENT SET h-bodi01001.

                       RUN saveHistorTagXmlNFe IN h-bodi01001 (INPUT ttRetornaNotas_ENV.ChaveNFe, INPUT lcXmlNfe).

                       IF VALID-HANDLE(h-bodi01001) THEN DO:
                           DELETE PROCEDURE h-bodi01001.
                           ASSIGN h-bodi01001 = ?.
                       END.
                   END.
               END.
               
               IF  AVAIL ttNFECANCELADA THEN DO:
                   ASSIGN lcXmlNfe = ttNFECANCELADA.XML.
                   
                   IF  INDEX(lcXMLNFe, "<inutNFe xmlns=":U) > 0 THEN
                       ASSIGN lcXMLNFe = SUBSTR(lcXMLNFe, INDEX(lcXMLNFe, "<inutNFe xmlns=":U)).

                   ASSIGN lcXMLNFe = '<ProcInutNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="':U + cVersaoLayoutNFe + '">':U + 
                                     lcXmlNfe + 
                                     ttNFECANCELADA.XMLPROT + 
                                     '</ProcInutNFe>':U.
        
                   CREATE X-DOCUMENT xDocXML.
                   xDocXML:LOAD ('LONGCHAR', lcXmlNfe, NO) NO-ERROR.
                   ASSIGN xDocXML:ENCODING = "UTF-8":U.
                   xDocXML:SAVE ('FILE', cArquivoXMLCancel) NO-ERROR.
               END.

           END. /* IF  cArquivoXML <> "" THEN DO: */
           /*** FIM - SALVA XML DE AUTORIZAO E CANCELAMENTO EM DIRETORIO ***/
           
           /****** ELIMINA HISTORICO XML EM DIRETORIO ******/
           IF      AVAIL ttNFE          AND
               NOT AVAIL ttNFECANCELADA AND /* eliminar quando ocorreu uso autorizado da nota */
               NOT &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                       param-nf-estab.log-mantem-histor-xml
                   &ELSE
                       param-nf-estab.log-livre-2
                   &ENDIF
               THEN DO:

				IF OPSYS <> "WIN32" 
				AND CAN-FIND(FIRST funcao NO-LOCK
							 WHERE funcao.cd-funcao = "SPP-XML-OPSYS"
							   AND funcao.ativo) THEN DO:
						
					FIND FIRST ped-curva 
						 WHERE ped-curva.vl-aberto = 160616
						   AND ped-curva.codigo    = 160616 
						   AND ped-curva.nome      = param-nf-estab.cod-estabel NO-LOCK NO-ERROR.
							
					IF AVAIL ped-curva THEN
						ASSIGN cArquivoHistoricoXML = TRIM(ped-curva.char-2).					
				END.
			    ELSE
                    ASSIGN cArquivoHistoricoXML = &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
													  TRIM(param-nf-estab.cod-dir-histor-xml)
												  &ELSE
													  TRIM(SUBSTR(param-nf-estab.cod-livre-1,116,100))
												  &ENDIF.
												 
			   ASSIGN cArquivoHistoricoXML = REPLACE(cArquivoHistoricoXML,"~\","/").
        
               IF  cArquivoHistoricoXML <> "":U THEN DO:
                   IF  NOT SUBSTR(cArquivoHistoricoXML,LENGTH(cArquivoHistoricoXML),LENGTH(cArquivoHistoricoXML) - 1) = "/":U  THEN
                       ASSIGN cArquivoHistoricoXML = cArquivoHistoricoXML + "/":U.
                   
                   ASSIGN cArquivoHistoricoXML =  cArquivoHistoricoXML 
                                                + param-nf-estab.cod-estabel + SUBSTR(ttRetornaNotas_ENV.ChaveNFe,23,3) + TRIM(STRING(INTEGER(SUBSTR(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999"))
                                                + "/":U.

                   OS-DELETE VALUE(cArquivoHistoricoXML) RECURSIVE. /* elimina o diretorio */
               END.

           END.
           /*** FIM - ELIMINA HISTORICO XML EM DIRETORIO ***/

           /***** ENVIO DE EMAIL PARA VERSAO LAYOUT NFE 1.10 *****/
           ASSIGN c-serie = (IF SUBSTR(TRIM(ttNFES5.ID),23,3) <> "000":U
                             THEN STRING(INT(SUBSTR(TRIM(ttNFES5.ID),23,3)))
                             ELSE "":U).

           IF  AVAIL estabelec AND
               &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                   trim(estabelec.des-vers-layout)
               &else 
                   TRIM(SUBSTRING(estabelec.char-1,173,10))
               &endif
               = "1.10":U AND
               AVAIL ttNFE THEN DO:
    
               FOR FIRST nota-fiscal NO-LOCK
                   WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
                   AND   nota-fiscal.serie       = c-serie
                   AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES5.ID,26,9)),">>9999999")):
                    
                   /* ENVIO DE EMAIL AO DESTINATARIO DA NOTA */
                   FOR FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
                
                        IF  (emitente.e-mail           <> "":U
                        AND INDEX(emitente.e-mail,"@")  > 0)
                        AND (param-nf-estab.cod-email           <> "":U
                        AND INDEX(param-nf-estab.cod-email,"@")  > 0) 
                        AND nota-fiscal.ind-tip-nota <> 8 THEN DO:

                            IF  AVAIL ttNFECANCELADA THEN. 
                            ELSE
                                ASSIGN cAssuntoEmail = "...: NF-e Autoriza‡Æo de Uso :...":U
                                       cArquivoAnexo = cArquivoXML.
                            
                            RUN piEnviaEmail (INPUT emitente.e-mail,            /* pc-destino   */
                                              INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                              INPUT cAssuntoEmail,              /* pc-assunto   */
                                              INPUT cArquivoAnexo).             /* pc-anexo     */
                        END.
                    END.
                    /* FIM - ENVIO DE EMAIL AO DESTINATARIO DA NOTA */

                    /* ENVIO DE EMAIL AO TRANSPORTADOR DA NOTA */
                    FOR FIRST transporte NO-LOCK
                        WHERE transporte.nome-abrev = nota-fiscal.nome-transp,
                        FIRST cont-tran NO-LOCK
                        WHERE cont-tran.cod-transp  = transporte.cod-transp
                        AND   &IF '{&bf_dis_versao_ems}' >= '2.09':U 
                              &THEN cont-tran.cdn-aplic-contat
                              &ELSE cont-tran.int-1 
                              &ENDIF = 2:
                
                        IF  (cont-tran.e-mail           <> "":U
                        AND INDEX(cont-tran.e-mail,"@")  > 0)
                        AND (param-nf-estab.cod-email           <> "":U
                        AND INDEX(param-nf-estab.cod-email,"@")  > 0) THEN DO:

                            IF  AVAIL ttNFECANCELADA THEN.
                            ELSE
                                ASSIGN cAssuntoEmail = "...: NF-e Autoriza‡Æo de Uso :...":U
                                       cArquivoAnexo = cArquivoXML.
                            
                            RUN piEnviaEmail (INPUT cont-tran.e-mail,           /* pc-destino   */
                                              INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                              INPUT cAssuntoEmail,              /* pc-assunto   */
                                              INPUT cArquivoAnexo).             /* pc-anexo     */
                        END.
                    END.
                    /* FIM - ENVIO DE EMAIL AO TRANSPORTADOR DA NOTA */

               END. 

           END.
           /** FIM - ENVIO DE EMAIL PARA VERSAO LAYOUT NFE 1.10 **/

            /*** Ponto UPC - Envia Email layout 2.0 Sincrono ***/
           IF  c-nom-prog-dpc-mg97  <> "" 
           OR  c-nom-prog-appc-mg97 <> "" 
           OR  c-nom-prog-upc-mg97  <> "" THEN DO:

               FOR EACH tt-epc: DELETE tt-epc. END.
                
               CREATE tt-epc.
               ASSIGN tt-epc.cod-event     = "EnviaEmail"
                      tt-epc.cod-parameter = "Chave"
                      tt-epc.val-parameter = ttNFES5.ID.

               /* somente quando for autoriza‡Æo de NFe */
               CREATE tt-epc.
               ASSIGN tt-epc.cod-event     = "EnviaEmail"
                      tt-epc.cod-parameter = "cArquivoXML"
                      tt-epc.val-parameter = cArquivoXML.

               {include/i-epc201.i "EnviaEmail"}
           
           END.
           /***********************************************/
           /** GRAVA O TIPO DO AMBIENTE (1-PRODU€ÇO/2-HOMOLOGA€ÇO) NA NOTA-FISCAL **/
           IF      AVAIL ttNFE          AND 
               NOT AVAIL ttNFECANCELADA THEN DO:  /* somente quando for autoriza‡Æo de NFe */

               FOR FIRST nota-fiscal EXCLUSIVE-LOCK
                   WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
                   AND   nota-fiscal.serie       = c-serie
                   AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES5.ID,26,9)),">>9999999")): 
    
                   RUN buscaTipEmisAmbSEFAZNotaFiscal (INPUT cXmlProt, OUTPUT iTpAmbSEFAZ, OUTPUT cdhRecbto).

                   IF  AVAIL nota-fiscal THEN
                       ASSIGN  &IF '{&bf_dis_versao_ems}' >= '2.09':U 
                               &THEN nota-fiscal.idi-tip-emis-amb-sefaz = INT(iTpAmbSEFAZ)
                               &ELSE OVERLAY(nota-fiscal.char-2,200,1)  = STRING(iTpAmbSEFAZ)
                               &ENDIF.
               END.
    
               FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

               IF  NUM-ENTRIES(cdhRecbto,"T") = 2 THEN
                   FOR LAST  ret-nf-eletro EXCLUSIVE-LOCK
                       WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                       AND   ret-nf-eletro.cod-serie   = nota-fiscal.serie      
                       AND   ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                       AND   ret-nf-eletro.cod-msg     = "100" /* Autoriza‡Æo */ :
                      /* SQL apresentava erro de duplicidade de chave */ 
                      &IF "{&ems_dbtype}" <> "PROGRESS" &THEN
                          IF NOT CAN-FIND(FIRST ret-nf-eletro NO-LOCK
                                          WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                                            AND ret-nf-eletro.cod-serie   = nota-fiscal.serie      
                                            AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                                            AND ret-nf-eletro.cod-msg     = "100" /* Autoriza‡Æo */ 
                                            AND ret-nf-eletro.dat-ret     = DATE ( INT(ENTRY(2,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                                   INT(ENTRY(3,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                                   INT(ENTRY(1,ENTRY(1,cdhRecbto,"T"),"-")) )
                                            AND ret-nf-eletro.hra-ret     = REPLACE(ENTRY(2,cdhRecbto,"T"),":","")) THEN
                      &ENDIF
                      ASSIGN ret-nf-eletro.dat-ret = DATE ( INT(ENTRY(2,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                    INT(ENTRY(3,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                    INT(ENTRY(1,ENTRY(1,cdhRecbto,"T"),"-")) )
                             ret-nf-eletro.hra-ret = REPLACE(ENTRY(2,cdhRecbto,"T"),":","") NO-ERROR.
                   END.
                   
                   
               /* C¢digo da Mensagem e Mensagem da SEFAZ para o emissor - NT2018.005 */
               RUN buscaValorTagSEFAZ (INPUT cXmlProt, INPUT "<cMsg>", INPUT "</cMsg>", OUTPUT cMsg).
               RUN buscaValorTagSEFAZ (INPUT cXmlProt, INPUT "<xMsg>", INPUT "</xMsg>", OUTPUT xMsg).
               
               IF INT(cMsg) > 0 THEN DO:
                   FOR FIRST nota-fisc-adc EXCLUSIVE-LOCK
                       WHERE nota-fisc-adc.cod-estab        = nota-fiscal.cod-estabel  
                         AND nota-fisc-adc.cod-serie        = nota-fiscal.serie        
                         AND nota-fisc-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis  
                         AND nota-fisc-adc.cdn-emitente     = nota-fiscal.cod-emitente 
                         AND nota-fisc-adc.cod-natur-operac = nota-fiscal.nat-operacao 
                         AND nota-fisc-adc.idi-tip-dado     = 31:  /* Mensagens do Protocolo de Recebimento */
                     ASSIGN nota-fisc-adc.num-livre-1 = INT(cMsg)
                            nota-fisc-adc.cod-livre-1 = xMsg.
                  END.
                  IF NOT AVAIL nota-fisc-adc THEN DO:
                     CREATE nota-fisc-adc.
                     ASSIGN nota-fisc-adc.cod-estab              = nota-fiscal.cod-estabel  
                            nota-fisc-adc.cod-serie              = nota-fiscal.serie        
                            nota-fisc-adc.cod-nota-fisc          = nota-fiscal.nr-nota-fis  
                            nota-fisc-adc.cdn-emitente           = nota-fiscal.cod-emitente 
                            nota-fisc-adc.cod-natur-operac       = nota-fiscal.nat-operacao 
                            nota-fisc-adc.idi-tip-dado           = 31 /* Mensagens do Protocolo de Recebimento */
                            nota-fisc-adc.cod-ser-docto-referado = nota-fiscal.serie
                            nota-fisc-adc.cod-docto-referado     = nota-fiscal.nr-nota-fis
                            nota-fisc-adc.num-livre-1            = INT(cMsg)
                            nota-fisc-adc.cod-livre-1            = xMsg.
                  END.      
               END.
                
               RELEASE nota-fiscal NO-ERROR.
           END.
           /** FIM - GRAVA O TIPO DO AMBIENTE (1-PRODU€ÇO/2-HOMOLOGA€ÇO) NA NOTA-FISCAL **/
    
           /** GRAVA PROTOCOLO DE AUTORIZA€ÇO DE DPEC **/ /* Foi alterado para EPEC */
           IF      AVAIL ttDPEC         AND
               NOT AVAIL ttNFE          AND
               NOT AVAIL ttNFECANCELADA THEN DO:  /* somente quando for autoriza‡Æo de DPEC */

               FOR FIRST nota-fiscal EXCLUSIVE-LOCK
                   WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
                   AND   nota-fiscal.serie       = c-serie
                   AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES5.ID,26,9)),">>9999999")): 
    
                   IF  AVAIL nota-fiscal THEN
                       ASSIGN &IF "{&bf_dis_versao_ems}":U < "2.07":U
                              &THEN OVERLAY(nota-fiscal.char-1,97,15)
                              &ELSE nota-fiscal.cod-protoc
                              &ENDIF
                              = ttDPEC.PROTOCOLO.  /* Foi alterado para EPEC */
               END.
    
               FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.
               RELEASE nota-fiscal NO-ERROR.

           END.
           /** FIM - GRAVA PROTOCOLO DE AUTORIZA€ÇO DE DPEC **/
    
       END.
    END.

END PROCEDURE.

PROCEDURE piCancelamento:

    DEF VAR c-data  AS CHAR NO-UNDO.
    DEF VAR c-data2 AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE ttNFERETORNAEVENTO.  
    ASSIGN cIdEvento = "ID110111" + TRIM(ttRetornaNotas_ENV.ChaveNFe) + "01".

    RUN NFESBRA_NFERETORNAEVENTO IN h-TSSAPI (param-nf-estab.ind-empresa, 
                                              cIdEvento,
                                              TRIM(ttRetornaNotas_ENV.ChaveNFe),
                                              INPUT (BUFFER ttNFERETORNAEVENTO:HANDLE)).

    ASSIGN cReturnValue = RETURN-VALUE.

    RUN disconnectTss IN h-TSSAPI ("NFESBRA":U).

    IF  cReturnValue <> "OK":U THEN DO:
       CREATE TT_LOG_ERRO.
       ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.

       /*Busca Mensagem*/
       RUN utp/ut-msgs.p (INPUT "MSG":U,
                          INPUT 36370,
                          INPUT "[TSS NFERETORNAEVENTO]":U + "~~":U + cReturnValue).
       ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.

       /*Busca Help */
       RUN utp/ut-msgs.p (INPUT "HELP":U,
                          INPUT 36370,
                          INPUT "[TSS NFERETORNAEVENTO]":U + "~~":U + cReturnValue).
       ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:
        FIND FIRST ttNFERETORNAEVENTO NO-LOCK NO-ERROR.
        IF  AVAIL ttNFERETORNAEVENTO THEN DO:
            ASSIGN lcXmlCanc     = ttNFERETORNAEVENTO.XML_SIG.
                   lcXmlCanc_Ret = ttNFERETORNAEVENTO.XML_RET.

            IF  lcXmlCanc <> ? THEN DO:

                ASSIGN cdhRecbto = "".
                RUN buscaDataHoraCancSEFAZ (INPUT lcXmlCanc_Ret, OUTPUT cdhRecbto).
                IF  cdhRecbto <> "" THEN DO:
                    ASSIGN c-data2 = "Data: ":U +  string(DATE ( INT(ENTRY(2,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                 INT(ENTRY(3,ENTRY(1,cdhRecbto,"T"),"-")) , 
                                                                 INT(ENTRY(1,ENTRY(1,cdhRecbto,"T"),"-")) ), "99/99/9999")
                           c-data2 = c-data2 + ". Hora: " + ENTRY(2,cdhRecbto,"T")  NO-ERROR.  
                    FOR FIRST nota-fiscal EXCLUSIVE-LOCK
                        WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
                        AND   nota-fiscal.serie       = c-serie
                        AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999")): 
                        
                        IF  INDEX(nota-fiscal.desc-cancela, "Data/Hora:") > 0 THEN
                            ASSIGN c-data                   = substring(nota-fiscal.desc-cancela, INDEX(nota-fiscal.desc-cancela, "Data/Hora:"),19)
                                   nota-fiscal.desc-cancela = REPLACE(nota-fiscal.desc-cancela, c-data, c-data2).

                    END.
                END.
                                                
				IF OPSYS <> "WIN32" 
				AND CAN-FIND(FIRST funcao NO-LOCK
							 WHERE funcao.cd-funcao = "SPP-XML-OPSYS"
							   AND funcao.ativo) THEN DO:
						
					FIND FIRST ped-curva 
						 WHERE ped-curva.vl-aberto = 160616
						   AND ped-curva.codigo    = 160616 
						   AND ped-curva.nome      = param-nf-estab.cod-estabel NO-LOCK NO-ERROR.
							
					IF AVAIL ped-curva THEN
						ASSIGN cArquivoXML = TRIM(ped-curva.char-1).					
				END.
				ELSE
					ASSIGN cArquivoXML = TRIM(param-nf-estab.cod-caminho-xml).					
				
                ASSIGN cArquivoXML = REPLACE(cArquivoXML,"~\","/").

                IF  cArquivoXML <> "" THEN DO:

                    IF  NOT SUBSTR(cArquivoXML,LENGTH(cArquivoXML),LENGTH(cArquivoXML) - 1) = "/"  THEN
                        ASSIGN cArquivoXML = cArquivoXML + "/".

                    ASSIGN cArquivoXML = cArquivoXML + 
                                         param-nf-estab.cod-estabel + SUBSTR(TRIM(ttRetornaNotas_ENV.ChaveNFe),23,3) + 
                                         TRIM(STRING(INTEGER(SUBSTR(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999")).

                    ASSIGN cArquivoXMLCancel = cArquivoXML + "_Cancel":U + ".xml":U.
                END.

                IF  INDEX(TRIM(lcXmlCanc),     "<Envevento")     > 0
                AND INDEX(TRIM(lcXmlCanc),     "</EnvEvento")    > 0
                AND INDEX(TRIM(lcXmlCanc_Ret), "<retEnvEvento")  > 0
                AND INDEX(TRIM(lcXmlCanc_Ret), "</retEnvEvento") > 0 THEN DO:     

                    OUTPUT TO VALUE (cArquivoXMLCancel).
                
                    /*formatacao xml */
                    PUT UNFORMATTED ('<?xml version="1.0" encoding="UTF-8" ?>').
                
                    /*Cabe‡alho pai procEventoNFe - abre  */
                    PUT UNFORMATTED ('<procEventoNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">').
                
                    /*conteudo tag <XML>     [ evento ] */
                    PUT UNFORMATTED REPLACE ( REPLACE( REPLACE( REPLACE(TRIM( SUBSTRING( fn-free-accent(STRING(lcXmlCanc)) ,     INDEX(TRIM(fn-free-accent(STRING(lcXmlCanc))),     "<evento") ,    INDEX(TRIM(fn-free-accent(STRING(lcXmlCanc))),     "</evento")) )       , "&lt;", '<') ,"&quot;", '"') ,"&gt;", '>') , "</envEvento>",    "").
                
                    /*conteudo tag <XMLPROT> [ retEvento ]*/
                    PUT UNFORMATTED REPLACE ( REPLACE( REPLACE( REPLACE(TRIM( SUBSTRING( fn-free-accent(STRING(lcXmlCanc_Ret)) , INDEX(TRIM(fn-free-accent(STRING(lcXmlCanc_Ret))), "<retEvento") , INDEX(TRIM(fn-free-accent(STRING(lcXmlCanc_Ret))), "</retEvento")) )    , "&lt;", '<') ,"&quot;", '"') ,"&gt;", '>') , "</retEnvEvento>", "").
                    
                    /*Cabe‡alho pai procEventoNFe - fecha  */
                    PUT UNFORMATTED ('</procEventoNFe>').
            
                    OUTPUT CLOSE.

                   /*ASSIGN lcXMLNFe = '<procEventoNFe versao="1.00" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><evento>' + 
                                     lcXmlCanc + '</evento><retEvento versao="1.00">' +
                                     lcXmlCanc_Ret + 
                                     '</retEvento></procEventoNFe>':U.

                   CREATE X-DOCUMENT xDocXML.
                   xDocXML:LOAD ('LONGCHAR', lcXmlNfe, NO) NO-ERROR.
                   ASSIGN xDocXML:ENCODING = "UTF-8":U.
                   xDocXML:SAVE ('FILE', cArquivoXMLCancel) NO-ERROR.*/

                END.

                /***** ENVIO DE EMAIL PARA VERSAO LAYOUT NFE 1.10 *****/
                ASSIGN c-serie = (IF SUBSTR(TRIM(ttRetornaNotas_ENV.ChaveNFe),23,3) <> "000":U
                                  THEN STRING(INT(SUBSTR(TRIM(ttRetornaNotas_ENV.ChaveNFe),23,3)))
                                  ELSE "":U).

               IF  AVAIL estabelec AND
                   &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                       trim(estabelec.des-vers-layout)
                   &else 
                       TRIM(SUBSTRING(estabelec.char-1,173,10))
                   &endif
                   = "1.10":U AND
                   AVAIL ttNFE THEN DO:

                   FOR FIRST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
                       AND   nota-fiscal.serie       = c-serie
                       AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttRetornaNotas_ENV.ChaveNFe,26,9)),">>9999999")):

                       /* ENVIO DE EMAIL AO DESTINATARIO DA NOTA */
                       FOR FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:

                            IF  (emitente.e-mail           <> "":U
                            AND INDEX(emitente.e-mail,"@")  > 0)
                            AND (param-nf-estab.cod-email           <> "":U
                            AND INDEX(param-nf-estab.cod-email,"@")  > 0) 
                            AND nota-fiscal.ind-tip-nota <> 8 THEN DO:

                                /* Email de cancelamento de nota */
                                ASSIGN cAssuntoEmail = "...: Cancelamento de NF-e :...":U
                                       cArquivoAnexo = cArquivoXMLCancel.

                                RUN piEnviaEmail (INPUT emitente.e-mail,            /* pc-destino   */
                                                  INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                                  INPUT cAssuntoEmail,              /* pc-assunto   */
                                                  INPUT cArquivoAnexo).             /* pc-anexo     */
                            END.
                        END.
                        /* FIM - ENVIO DE EMAIL AO DESTINATARIO DA NOTA */

                        /* ENVIO DE EMAIL AO TRANSPORTADOR DA NOTA */
                        FOR FIRST transporte NO-LOCK
                            WHERE transporte.nome-abrev = nota-fiscal.nome-transp,
                            FIRST cont-tran NO-LOCK
                            WHERE cont-tran.cod-transp  = transporte.cod-transp
                            AND   &IF '{&bf_dis_versao_ems}' >= '2.09':U 
                                  &THEN cont-tran.cdn-aplic-contat
                                  &ELSE cont-tran.int-1 
                                  &ENDIF = 2:

                            IF  (cont-tran.e-mail           <> "":U
                            AND INDEX(cont-tran.e-mail,"@")  > 0)
                            AND (param-nf-estab.cod-email           <> "":U
                            AND INDEX(param-nf-estab.cod-email,"@")  > 0) THEN DO:

                                /* Email de cancelamento de nota */
                                ASSIGN cAssuntoEmail = "...: Cancelamento de NF-e :...":U
                                       cArquivoAnexo = cArquivoXMLCancel.

                                RUN piEnviaEmail (INPUT cont-tran.e-mail,           /* pc-destino   */
                                                  INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                                  INPUT cAssuntoEmail,              /* pc-assunto   */
                                                  INPUT cArquivoAnexo).             /* pc-anexo     */
                            END.
                        END.
                        /* FIM - ENVIO DE EMAIL AO TRANSPORTADOR DA NOTA */

                   END. 

               END.
               /** FIM - ENVIO DE EMAIL PARA VERSAO LAYOUT NFE 1.10 **/

                /*** Ponto UPC - Envia Email layout 2.0 Sincrono ***/
               IF  c-nom-prog-dpc-mg97  <> "" 
               OR  c-nom-prog-appc-mg97 <> "" 
               OR  c-nom-prog-upc-mg97  <> "" THEN DO:

                   FOR EACH tt-epc: DELETE tt-epc. END.

                   CREATE tt-epc.
                   ASSIGN tt-epc.cod-event     = "EnviaEmail"
                          tt-epc.cod-parameter = "Chave"
                          tt-epc.val-parameter = ttRetornaNotas_ENV.ChaveNFe.

                   /* somente quando for cancelamento de NFe */
                   CREATE tt-epc.
                   ASSIGN tt-epc.cod-event     = "EnviaEmail"
                          tt-epc.cod-parameter = "cArquivoXMLCancel"
                          tt-epc.val-parameter = cArquivoXMLCancel.

                   {include/i-epc201.i "EnviaEmail"}

               END.
               /***********************************************/
            END.
        END.

    END.

END PROCEDURE.
