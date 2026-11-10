DEFINE VARIABLE c-serie         AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-assunto-email AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-arq-anexo     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l-nfe-cancel    AS LOGICAL                 NO-UNDO.


FOR EACH estabelec NO-LOCK
    WHERE estabelec.cgc = substr(ttNFES3.ID,7,14)
      &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN
      and   estabelec.idi-tip-emis-nf-eletro > 1    
      &else
      AND   INT(SUBSTR(estabelec.char-1,168,1)) > 1
      &endif : 
   
    FIND FIRST param-nf-estab
         WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.

    IF  AVAIL param-nf-estab THEN DO:

        ASSIGN c-serie = (IF SUBSTR(TRIM(ttNFES3.ID),23,3) <> "000":U
                          THEN STRING(INT(SUBSTR(TRIM(ttNFES3.ID),23,3)))
                          ELSE "":U).

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = param-nf-estab.cod-estabel
            AND   nota-fiscal.serie       = c-serie
            AND   nota-fiscal.nr-nota-fis = TRIM(STRING(INTEGER(SUBSTR(ttNFES3.ID,26,9)),">>9999999")):

            /*Verifica se est  como Uso Autorizado[3] ou Documento Cancelado[6] para enviar XML correspondente*/
            IF &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
                (nota-fiscal.idi-sit-nf-eletro   = 3 OR nota-fiscal.idi-sit-nf-eletro   = 6)
               &else
                CAN-FIND (FIRST sit-nf-eletro NO-LOCK
                          WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                            AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                            AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis
                            AND (sit-nf-eletro.idi-sit-nf-eletro = 3
                            OR   sit-nf-eletro.idi-sit-nf-eletro = 6))
               &endif
            THEN DO:
            
                IF &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
                    nota-fiscal.idi-sit-nf-eletro   = 6
                   &else
                    CAN-FIND (FIRST sit-nf-eletro NO-LOCK
                              WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                                AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                                AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis
                                AND sit-nf-eletro.idi-sit-nf-eletro = 6)
                   &endif
                THEN
                    ASSIGN l-nfe-cancel = YES.

				DEFINE VARIABLE c-dir AS CHARACTER NO-UNDO.
				
				IF OPSYS <> "WIN32" 
				AND CAN-FIND(FIRST funcao NO-LOCK
							 WHERE funcao.cd-funcao = "SPP-XML-OPSYS"
							   AND funcao.ativo) THEN DO:
						
						FIND FIRST ped-curva 
						 	 WHERE ped-curva.vl-aberto = 160616
							   AND ped-curva.codigo    = 160616 
							   AND ped-curva.nome      = param-nf-estab.cod-estabel NO-LOCK NO-ERROR.
								
					    IF AVAIL ped-curva THEN DO:
						    ASSIGN c-dir = TRIM(ped-curva.char-1).
					    END.
					END.
				ELSE
                    ASSIGN c-dir = TRIM(param-nf-estab.cod-caminho-xml).

                IF  NOT SUBSTR(c-dir,LENGTH(c-dir),LENGTH(c-dir) - 1) = "~\"  THEN
                    ASSIGN c-arq-anexo = c-dir + "~\" + param-nf-estab.cod-estabel + SUBSTR(ttNFES3.ID,23,3) + TRIM(STRING(INTEGER(SUBSTR(ttNFES3.ID,26,9)),">>9999999")).
                ELSE
                    ASSIGN c-arq-anexo = c-dir + param-nf-estab.cod-estabel + SUBSTR(ttNFES3.ID,23,3) + TRIM(STRING(INTEGER(SUBSTR(ttNFES3.ID,26,9)),">>9999999")).

                /******** Inicio ponto epc ***************************************/  
                IF  c-nom-prog-dpc-mg97  <> "" OR  
                    c-nom-prog-appc-mg97 <> "" OR  
                    c-nom-prog-upc-mg97  <> "" THEN DO:
                    FOR EACH tt-epc WHERE tt-epc.cod-event = "Ret_Autorizacao_NF-e":
                        DELETE tt-epc.
                    END.

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "Ret_Autorizacao_NF-e"
                           tt-epc.cod-parameter = "Rowid(nota-fiscal)"
                           tt-epc.val-parameter = string(ROWID(nota-fiscal)).

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "Ret_Autorizacao_NF-e"
                           tt-epc.cod-parameter = "Arquivo_XML"
                           tt-epc.val-parameter = c-arq-anexo.

                    {include/i-epc201.i "Ret_Autorizacao_NF-e"}
                END. /* IF  c-nom-prog-dpc-mg97  <> "" OR */
                /******** Fim ponto epc ******************************************/  
                
                /*---
                Ajusta nome do arquivo conforme situa‡Æo [Uso Autorizado -> 10070000027.xml 
                                                          Cancel         -> 10070000027_Cancel.xml] 
                ---*/
                ASSIGN c-arq-anexo = ( IF l-nfe-cancel
                                       THEN (c-arq-anexo + "_Cancel":U + ".xml":U)
                                       ELSE (c-arq-anexo + ".xml":U) ).

                /*---
                Gera XML da NF-e com protocolo de autoriza‡Æo para ser enviado ao cliente, destinat rio da nota.
                ---*/

                /*--- LAYOUT XML DE PEDIDO DE CANCELAMENTO DA NF-e + PROTOCOLO DE CANCELAMENTO [procCancNFe_v2.02.xsd] ---*/
                IF  l-nfe-cancel THEN DO:
                    OUTPUT TO VALUE (c-arq-anexo).

                    /*formatacao xml */
                    PUT UNFORMATTED ('<?xml version="1.0" encoding="UTF-8" ?>').

                    /*Cabe‡alho pai procCancNFe - abre  */
                    PUT UNFORMATTED ('<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">').

                    /*conteudo tag <XML>     [ cancNFe ] */
                    PUT UNFORMATTED REPLACE( REPLACE( REPLACE( REPLACE(ttNFES3.XML_Canc,"&lt;",   '<') ,"&quot;", '"') ,"&gt;",   '>'), '<?xml version="1.0" encoding="UTF-8"?>', "") SKIP.

                    /*conteudo tag <XMLPROT> [ retCancNFe ]*/
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-protnfe AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "protNFe" *}
                    ASSIGN c-lbl-liter-protnfe = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-retcancnfe AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "retCancNFe" *}
                    ASSIGN c-lbl-liter-retcancnfe = TRIM(RETURN-VALUE).
                    PUT UNFORMATTED REPLACE ( REPLACE( REPLACE( REPLACE(ttNFES3.XMLPROT_Canc, "&lt;", '<') ,"&quot;", '"') ,"&gt;", '>'), c-lbl-liter-protnfe, c-lbl-liter-retcancnfe).
                    
                    /*Cabe‡alho pai procCancNFe - fecha  */
                    PUT UNFORMATTED ('</procCancNFe>').
                    OUTPUT CLOSE.
                END.
                ELSE /*--- LAYOUT XML NF-e + PROTOCOLO DE AUTORIZA€ÇO DE USO [procNFe_v2.02.xsd] ---*/
                    RUN salvaMensagemSEFAZ (c-arq-anexo, l-nfe-cancel).
                
                /* ENVIO DE EMAIL AO DESTINATARIO DA NOTA */
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
            
                    IF  (emitente.e-mail           <> ""
                    AND INDEX(emitente.e-mail,"@")  > 0)
                    AND (param-nf-estab.cod-email           <> ""
                    AND INDEX(param-nf-estab.cod-email,"@")  > 0) 
                    AND nota-fiscal.ind-tip-nota <> 8 THEN DO:
            
                        ASSIGN c-assunto-email = (IF l-nfe-cancel
                                                  THEN "...: Cancelamento de NF-e :...":U
                                                  ELSE "...: NF-e Autoriza‡Æo de Uso :...":U).

                        RUN piEnviaEmail (INPUT emitente.e-mail,            /* pc-destino   */
                                          INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                          INPUT c-assunto-email,            /* pc-assunto   */
                                          INPUT c-arq-anexo).               /* pc-anexo     */
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
                        
                        ASSIGN c-assunto-email = (IF l-nfe-cancel
                                                  THEN "...: Cancelamento de NF-e :...":U
                                                  ELSE "...: NF-e Autoriza‡Æo de Uso :...":U).
                        
                        RUN piEnviaEmail (INPUT cont-tran.e-mail,           /* pc-destino   */
                                          INPUT param-nf-estab.cod-email,   /* pc-remetente */
                                          INPUT c-assunto-email,            /* pc-assunto   */
                                          INPUT c-arq-anexo).               /* pc-anexo     */
                    END.
                END.
                /* FIM - ENVIO DE EMAIL AO TRANSPORTADOR DA NOTA */

            END. /*fim IF (nota-fiscal.idi-sit-nf-eletro   = 3 OR nota-fiscal.idi-sit-nf-eletro   = 6)*/

        END. /*fim FOR FIRST nota-fiscal*/

    END. /*fim IF  AVAIL param-nf-estab*/

    IF  AVAIL nota-fiscal THEN LEAVE. /*para sair do for each estabelec*/

END. /*fim FOR FIRST estabelec*/
