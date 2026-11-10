/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP019 2.00.00.017 } /*** "010017" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsep019 MAX}
&ENDIF

{utp/ut-glob.i}     
{cdp/cdcfgdis.i}
{cdp/cd0666.i}
{include/i-epc200.i AXSEP019}

DEFINE VARIABLE c-estabel            LIKE param-nf-estab.cod-estabel NO-UNDO.
DEFINE VARIABLE lCreateMsg           AS LOGICAL   INITIAL FALSE      NO-UNDO.
DEFINE VARIABLE pSendSuccess         AS LOGICAL   INITIAL TRUE       NO-UNDO.
DEFINE VARIABLE SIZE-XML             AS LONGCHAR                     NO-UNDO.
DEFINE VARIABLE hGenXmlRetorno       AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-TSSAPI             AS HANDLE                       NO-UNDO. 
DEFINE VARIABLE cArquivoHistoricoXML AS CHARACTER                    NO-UNDO.
                
/* DEFINICAO DE PRE-PROCESSADORES - END */

{adapters/xml/ep2/axsep019.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep019extradeclarations.i} /* Outras Declaraá‰es             */

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF cReturnValue <> "OK" THEN DO:
  CREATE TT_LOG_ERRO.
  ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
  /* Inicio -- Projeto Internacional */
  {utp/ut-liter.i "Erro_ao_carregar_a_API_XML" *}
  ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
         tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
  RETURN cReturnValue.
END.

PROCEDURE disconnecTss:

/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE(h-TSSAPI)        AND
       h-TSSAPI:TYPE = "PROCEDURE":U AND
       h-TSSAPI:FILE-NAME = "ftp/ftapi511.p":U THEN DO:
        RUN disconnectTss IN h-TSSAPI ("TSSTOTVSCOLABDOC":U).   
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.
    
END PROCEDURE.



PROCEDURE pi-configura-TSS:

/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/

    /*Instancia API de comunicaá∆o com o TSS*/
    IF NOT VALID-HANDLE(h-TSSAPI) 
    OR h-TSSAPI:TYPE      <> "PROCEDURE":U 
    OR h-TSSAPI:FILE-NAME <> "ftp/ftapi511.p":U THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. 
    END. 

    /* Verifica se URL do TSS foi informada */
    IF  NOT AVAIL param-nf-estab THEN
        FOR FIRST param-nf-estab NO-LOCK
            WHERE param-nf-estab.cod-estabel = c-estabel: END.
    IF AVAIL param-nf-estab THEN DO:
       
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
       
       IF cArquivoHistoricoXML <> "" THEN DO:
          IF  NOT SUBSTR(cArquivoHistoricoXML,LENGTH(cArquivoHistoricoXML),LENGTH(cArquivoHistoricoXML) - 1) = "/"  THEN
              ASSIGN cArquivoHistoricoXML = cArquivoHistoricoXML + "/".
          
          ASSIGN cArquivoHistoricoXML =  cArquivoHistoricoXML 
                                       + param-nf-estab.cod-estabel + SUBSTR(ttNFe.ChaveAcessoNFe,23,3) + TRIM(STRING(INTEGER(SUBSTR(ttNFe.ChaveAcessoNFe,26,9)),">>9999999"))
                                       + "/".
       
          ASSIGN FILE-INFO:FILE-NAME = cArquivoHistoricoXML.
          IF  FILE-INFO:FULL-PATHNAME = ? THEN 
              OS-CREATE-DIR value(cArquivoHistoricoXML) NO-ERROR. /* cria o diretorio caso nao exista */
       
          ASSIGN cArquivoHistoricoXML =   cArquivoHistoricoXML
                                        + STRING(YEAR(TODAY),"9999")              /* ex: 2010   (Ano)       */
                                        + STRING(MONTH(TODAY),"99")               /* ex: 05     (Mes Maio)  */
                                        + STRING(DAY(TODAY),"99")                 /* ex: 01     (Dia)       */
                                        + REPLACE(STRING(TIME,"HH:MM:SS"),":","") /* Ex: 140105 (14h01m05s) */
                                        + ".xml":U.
       
          hBusinessContent:SAVE ('FILE', cArquivoHistoricoXML) NO-ERROR.
       END.
    END.
    /*** FIM - GRAVA HISTORICO XML EM DIRETORIO ***/

   IF  NOT AVAIL param-nf-estab OR 
        &if "{&bf_dis_versao_ems}" >= "2.08" &then
            TRIM(param-nf-estab.cod-url-ws-tss) = "":U OR
            TRIM(param-nf-estab.cod-url-ws-tss) = "http://":U
        &else
            TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "":U OR
            TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "http://":U
        &endif
        THEN DO:

        CREATE tt_log_erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "A_URL_do_WebService_do_TSS_deve_ser_previamente_informada_nos_parÉmetros_de_integraá∆o_com_o_TSS._Estab" *}
        ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
               tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ". " + c-estabel.

        RETURN "NOK":U.
    END.
    ELSE DO:
       RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                       TRIM(param-nf-estab.cod-url-ws-tss)
                                   &else
                                       TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                                   &endif 
                                   ). /* Seta a URL do TSS na API de comunicaá∆o */
                                                                              
      RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                       INPUT "*",
                                       INPUT param-nf-estab.cod-estabel,
                                       INPUT param-nf-estab.cod-url-ws-tss).
    END.
    RETURN "OK":U.   
    
END PROCEDURE.



PROCEDURE pi-envia-TSS:

/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE xmlRetornoRemessa AS LONGCHAR NO-UNDO.

    RUN TOTVSColabRemessaDoc IN h-TSSAPI (INPUT param-nf-estab.ind-empresa,
                                          INPUT BUFFER ttRemessaColab:HANDLE,
                                          OUTPUT xmlRetornoRemessa). 
    ASSIGN cReturnValue = RETURN-VALUE.
    
    IF  cReturnValue <> "OK":U THEN DO:

        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro = 36370
               tt_log_erro.ttv_des_msg_erro = "[TSS REMESSADOCTOTVSCOLAB]":U + "~~":U + cReturnValue.

        RETURN "NOK":U.
    END.
    ELSE RUN pi-retorno-TSS(INPUT xmlRetornoRemessa).
           
    RETURN "OK":U.
     
END PROCEDURE.

PROCEDURE pi-retorno-TSS:

/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
   
    DEFINE INPUT PARAMETER xmlRetornoRemessa AS LONGCHAR NO-UNDO.
    
    DEFINE VARIABLE iId AS INTEGER NO-UNDO.
    DEFINE VARIABLE c-return AS CHARACTER EXTENT 2 NO-UNDO.

      IF xmlRetornoRemessa <> "":U THEN DO:
        
        DEFINE VARIABLE hDocXmlRetorno AS HANDLE NO-UNDO.
    
        RUN xmlutp/ut-genxml.p PERSISTENT SET hGenXmlRetorno.   
    
        EMPTY TEMP-TABLE ttStack.
        CREATE X-DOCUMENT hDocXmlRetorno.
    
        hDocXmlRetorno:LOAD("longchar":U, xmlRetornoRemessa, FALSE).
    
        RUN reset IN hGenXmlRetorno.
    
        RUN loadxml in hGenXmlRetorno (hDocXmlRetorno).

        RUN searchTag IN hGenXmlRetorno (INPUT "TOTVSCOLABREMESSADOCRESPONSE", INPUT getStack(), OUTPUT iId).
        IF (iId <> ?) THEN DO:
           addStack(iId).

            RUN searchTag IN hGenXmlRetorno (INPUT "TOTVSCOLABREMESSADOCRESULT", INPUT getStack(), OUTPUT iId).
            IF (iId <> ?) THEN DO:
               addStack(iId).

                RUN searchTag IN hGenXmlRetorno (INPUT "REMESSADOCRET", INPUT getStack(), OUTPUT iId).
                IF (iId <> ?) THEN DO:
                   addStack(iId).
    
                    RUN searchTag IN hGenXmlRetorno (INPUT "DOCUMENTORET", INPUT getStack(), OUTPUT iId).
                    IF (iId <> ?) THEN DO:
                       addStack(iId).
                       
                       ASSIGN c-return = "". 
                       
                       RUN getSonVal  IN hGenXmlRetorno (INPUT getStack(), INPUT "STATUS",     OUTPUT c-return[1]).
                       RUN getSonVal  IN hGenXmlRetorno (INPUT getStack(), INPUT "DESCRICAO",  OUTPUT c-return[2]).

                       IF c-return[1] <> "0" THEN DO:
                          CREATE tt_log_erro. 
                          ASSIGN tt_log_erro.ttv_num_cod_erro = 17006 
                                 tt_log_erro.ttv_des_msg_erro = "[TSS REMESSADOCTOTVSCOLAB] ":U + c-return[2].  
                       END.    
    
                    END.  
                    delStack().               
                END.  
                delStack().
            END.
            delStack().
        END.
        delStack().
    END.   
    ELSE DO:
        CREATE tt_log_erro. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "[TSS_REMESSADOCTOTVSCOLAB]_Erro_no_retorno,_sem_resposta_do_TSS" *}
        ASSIGN tt_log_erro.ttv_num_cod_erro = 17006
               tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ".".
    END.
    
    /* LIBERA MEM”RIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hDocXmlRetorno NO-ERROR.

    IF CAN-FIND(FIRST TT_LOG_ERRO) THEN
       RETURN "NOK":U.
    ELSE
    RETURN "OK":U.
    
END PROCEDURE.

/****** INTERNAL PROCEDURES - BEGIN*/
PROCEDURE PIUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR ttAdi.
DEFINE INPUT  PARAM TABLE FOR ttArma.
DEFINE INPUT  PARAM TABLE FOR ttAutXML.
DEFINE INPUT  PARAM TABLE FOR ttAvulsa.
DEFINE INPUT  PARAM TABLE FOR ttCobr.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSAliq.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSNT.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSOutr.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSQtde.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSST.
DEFINE INPUT  PARAM TABLE FOR ttComb.
DEFINE INPUT  PARAM TABLE FOR ttCompra.
DEFINE INPUT  PARAM TABLE FOR ttDest.
DEFINE INPUT  PARAM TABLE FOR ttDet.
DEFINE INPUT  PARAM TABLE FOR ttDetExport.
DEFINE INPUT  PARAM TABLE FOR ttDI.
DEFINE INPUT  PARAM TABLE FOR ttDup.
DEFINE INPUT  PARAM TABLE FOR ttEmit.
DEFINE INPUT  PARAM TABLE FOR ttEntrega.
DEFINE INPUT  PARAM TABLE FOR ttExporta.
DEFINE INPUT  PARAM TABLE FOR ttICMS00.
DEFINE INPUT  PARAM TABLE FOR ttICMS10.
DEFINE INPUT  PARAM TABLE FOR ttICMS20.
DEFINE INPUT  PARAM TABLE FOR ttICMS30.
DEFINE INPUT  PARAM TABLE FOR ttICMS40.
DEFINE INPUT  PARAM TABLE FOR ttICMS51.
DEFINE INPUT  PARAM TABLE FOR ttICMS60.
DEFINE INPUT  PARAM TABLE FOR ttICMS70.
DEFINE INPUT  PARAM TABLE FOR ttICMS90.
DEFINE INPUT  PARAM TABLE FOR ttICMSTot.
DEFINE INPUT  PARAM TABLE FOR ttIde.
DEFINE INPUT  PARAM TABLE FOR ttII.
DEFINE INPUT  PARAM TABLE FOR ttImpostoDevol.
DEFINE INPUT  PARAM TABLE FOR ttInfAdic.
DEFINE INPUT  PARAM TABLE FOR ttIPI.
DEFINE INPUT  PARAM TABLE FOR ttISSQN.
DEFINE INPUT  PARAM TABLE FOR ttISSQNtot.
DEFINE INPUT  PARAM TABLE FOR ttLacres.
DEFINE INPUT  PARAM TABLE FOR ttMed.
DEFINE INPUT  PARAM TABLE FOR ttNFe.
DEFINE INPUT  PARAM TABLE FOR ttrefNF.
DEFINE INPUT  PARAM TABLE FOR ttObsCont.
DEFINE INPUT  PARAM TABLE FOR ttObsFisco.
DEFINE INPUT  PARAM TABLE FOR ttPISAliq.
DEFINE INPUT  PARAM TABLE FOR ttPISNT.
DEFINE INPUT  PARAM TABLE FOR ttPISOutr.
DEFINE INPUT  PARAM TABLE FOR ttPISQtde.
DEFINE INPUT  PARAM TABLE FOR ttPISST.
DEFINE INPUT  PARAM TABLE FOR ttProcRef.
DEFINE INPUT  PARAM TABLE FOR ttReboque.
DEFINE INPUT  PARAM TABLE FOR ttRetirada.
DEFINE INPUT  PARAM TABLE FOR ttRetTrib.
DEFINE INPUT  PARAM TABLE FOR ttTransp.
DEFINE INPUT  PARAM TABLE FOR ttVeic.
DEFINE INPUT  PARAM TABLE FOR ttVol.
DEFINE INPUT  PARAM TABLE FOR ttrefNFP.
DEFINE INPUT  PARAM TABLE FOR ttrefCTe.
DEFINE INPUT  PARAM TABLE FOR ttrefECF. 
DEFINE INPUT  PARAM TABLE FOR ttICMSPart.
DEFINE INPUT  PARAM TABLE FOR ttICMSST.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN101.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN102.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN201.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN202.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN500.
DEFINE INPUT  PARAM TABLE FOR ttICMSSN900.
DEFINE INPUT  PARAM TABLE FOR ttCana.
DEFINE INPUT  PARAM TABLE FOR ttForDia.
DEFINE INPUT  PARAM TABLE FOR ttDeduc.
DEFINE INPUT  PARAM TABLE FOR ttHeader.
DEFINE INPUT  PARAM TABLE FOR ttConditionPay.
DEFINE INPUT  PARAM TABLE FOR ttItem.
DEFINE INPUT  PARAM TABLE FOR ttEtiqueta.
DEFINE INPUT  PARAM TABLE FOR ttCallKanban.
DEFINE INPUT  PARAM TABLE FOR ttInvoiceReferenced.
DEFINE INPUT  PARAM TABLE FOR ttSummary.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iCount       AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR pErrorId     AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR pErrorType   AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR lCreateMsg   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR c-tp-integ   AS CHARACTER               NO-UNDO.
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* SETA Chave Primaria */
IF NOT AVAIL ttNfe THEN
   FIND FIRST ttNfe NO-LOCK NO-ERROR. 
ASSIGN c-estabel = ttNFe.codestabelnf.

/* RESETA OS VALORES */
RUN reset IN hGenXml.

/* SETA VALOR DE ENCODING */
RUN setEncoding IN hGenXml ("UTF-8").

addStack(iId).

/* IMPRIME XML */
RUN adapters/xml/ep2/axsep019imprimexml.p (INPUT hGenXml                  ,       
                                           INPUT-OUTPUT TABLE ttStack     ,       
                                           INPUT TABLE ttAdi              ,
                                           INPUT TABLE ttArma             ,
                                           INPUT TABLE ttAutXML           ,
                                           INPUT TABLE ttAvulsa           ,
                                           INPUT TABLE ttCobr             ,
                                           INPUT TABLE ttCOFINSAliq       ,
                                           INPUT TABLE ttCOFINSNT         ,
                                           INPUT TABLE ttCOFINSOutr       ,
                                           INPUT TABLE ttCOFINSQtde       ,
                                           INPUT TABLE ttCOFINSST         ,
                                           INPUT TABLE ttComb             ,
                                           INPUT TABLE ttCompra           ,
                                           INPUT TABLE ttDest             ,
                                           INPUT TABLE ttDet              ,
                                           INPUT TABLE ttDetExport        ,
                                           INPUT TABLE ttDI               ,
                                           INPUT TABLE ttDup              ,
                                           INPUT TABLE ttEmit             ,
                                           INPUT TABLE ttEntrega          ,
                                           INPUT TABLE ttExporta          ,
                                           INPUT TABLE ttICMS00           ,
                                           INPUT TABLE ttICMS10           ,
                                           INPUT TABLE ttICMS20           ,
                                           INPUT TABLE ttICMS30           ,
                                           INPUT TABLE ttICMS40           ,
                                           INPUT TABLE ttICMS51           ,
                                           INPUT TABLE ttICMS60           ,
                                           INPUT TABLE ttICMS70           ,
                                           INPUT TABLE ttICMS90           ,
                                           INPUT TABLE ttICMSTot          ,
                                           INPUT TABLE ttIde              ,
                                           INPUT TABLE ttII               ,
                                           INPUT TABLE ttImpostoDevol     ,
                                           INPUT TABLE ttInfAdic          ,
                                           INPUT TABLE ttIPI              ,
                                           INPUT TABLE ttISSQN            ,
                                           INPUT TABLE ttISSQNtot         ,
                                           INPUT TABLE ttLacres           ,
                                           INPUT TABLE ttMed              ,
                                           INPUT TABLE ttNFe              ,
                                           INPUT TABLE ttrefNF            ,
                                           INPUT TABLE ttObsCont          ,
                                           INPUT TABLE ttObsFisco         ,
                                           INPUT TABLE ttPISAliq          ,
                                           INPUT TABLE ttPISNT            ,
                                           INPUT TABLE ttPISOutr          ,
                                           INPUT TABLE ttPISQtde          ,
                                           INPUT TABLE ttPISST            ,
                                           INPUT TABLE ttProcRef          ,
                                           INPUT TABLE ttReboque          ,
                                           INPUT TABLE ttRetirada         ,
                                           INPUT TABLE ttRetTrib          ,
                                           INPUT TABLE ttTransp           ,
                                           INPUT TABLE ttVeic             ,
                                           INPUT TABLE ttVol              ,
                                           INPUT TABLE ttrefNFP           ,
                                           INPUT TABLE ttrefCTe           ,
                                           INPUT TABLE ttrefECF           ,
                                           INPUT TABLE ttICMSPart         ,
                                           INPUT TABLE ttICMSST           ,
                                           INPUT TABLE ttICMSSN101        ,
                                           INPUT TABLE ttICMSSN102        ,
                                           INPUT TABLE ttICMSSN201        ,
                                           INPUT TABLE ttICMSSN202        ,
                                           INPUT TABLE ttICMSSN500        ,
                                           INPUT TABLE ttICMSSN900        ,
                                           INPUT TABLE ttCana             ,
                                           INPUT TABLE ttForDia           ,
                                           INPUT TABLE ttDeduc            ,
                                           INPUT TABLE ttHeader           ,       
                                           INPUT TABLE ttConditionPay     ,       
                                           INPUT TABLE ttItem             ,       
                                           INPUT TABLE ttEtiqueta         ,       
                                           INPUT TABLE ttCallKanban       ,       
                                           INPUT TABLE ttInvoiceReferenced,       
                                           INPUT TABLE ttSummary          ).      
delStack().

/* OBTEM O XML NUMA HANDLE */
RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

RUN cdp/cd0360b.p (INPUT c-estabel,
                   INPUT "AvisoEmb",
                   OUTPUT c-tp-integ).
CASE c-tp-integ:
    WHEN "TC2" THEN DO: /* TOTVS COLABORAÄ«O 2.00 */
        FOR FIRST ttHEADER NO-LOCK:
            EMPTY TEMP-TABLE tt-erro.
        
            RUN cdp/cdapi590.p (INPUT 6, /*Codigo Aviso de Embarque*/
                                INPUT hBusinessContent,
                                INPUT ttHEADER.CodEstabelNF + "-" + ttHEADER.SerieNF + "-" + ttHEADER.NrNotaFisNF /* Chave da Nota Fiscal */,
                                OUTPUT TABLE tt-erro).
            FOR EACH tt-erro:
                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
                       TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
                       TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
            END.
        END.
    END. /* FIM TOTVS COLABORAÄ«O 2.00 */
    WHEN "TC" THEN DO: /* TOTVS COLABORAÄ«O COM TSS */
        
        hBusinessContent:SAVE("LONGCHAR":U,SIZE-XML).
        IF (DEC(LENGTH(SIZE-XML)) / 1024) > 500 THEN DO:
           CREATE TT_LOG_ERRO. 
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Tamanho_do_XML_ultrapassou_limite_(500kb)._Tamanho_do_XML" *}
           ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006
                  TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + " = "  + STRING(DEC(LENGTH(SIZE-XML)) / 1024).  
        END.            
        ELSE DO: 
           RUN pi-configura-TSS.
           IF RETURN-VALUE = "OK":U THEN DO:
              FIND FIRST ttHEADER NO-LOCK NO-ERROR.
              IF AVAIL ttHEADER THEN DO:
                 EMPTY TEMP-TABLE ttRemessaColab.
                 CREATE ttRemessaColab.
                 ASSIGN ttRemessaColab.IDERP  = ttHEADER.CodEstabelNF + "-" + ttHEADER.SerieNF + "-" + ttHEADER.NrNotaFisNF /* Chave da Nota Fiscal */
                        ttRemessaColab.IDTSS  = ""
                        ttRemessaColab.MODELO = "1"
                        ttRemessaColab.XMLDOC = hBusinessContent.
                 RUN pi-envia-TSS. 
              END. /*  IF AVAIL ttHEADER THEN DO: */  
           END. /* IF RETURN-VALUE = "OK":U THEN DO: */
        END. /* ELSE DO: */
    END. /* ELSE DO - TOTVS COLAB COM TSS */
    OTHERWISE DO:
           CREATE TT_LOG_ERRO. 
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "O_parametro_da_soluá∆o_Totvs_Colaboraá∆o_n∆o_est†_ativado" *}
           ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006
                  TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE
                  TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.  
           RETURN "NOK".
    END.
END CASE.

/* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
DELETE OBJECT hBusinessContent NO-ERROR.

/* VERIFICA SE OCORREU ALGUM ERRO */
IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-erro-no-envio-da-mensagem AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Erro_no_envio_da_Mensagem" *}
          ASSIGN c-lbl-liter-erro-no-envio-da-mensagem = TRIM(RETURN-VALUE).
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-erro-no-envio-da-mensagem + ": "+ c-lbl-liter-2
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN RETURN-VALUE.
END.
ELSE RETURN "OK".

END PROCEDURE.

/****** INTERNAL PROCEDURES - END*/
{adapters/xml/ep2/axsep019upsert.i}
/*------------------------------------------ FIM axsep019.p ------------------------------------------*/

