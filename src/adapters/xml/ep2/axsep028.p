/***********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*************************************************************************************/
{include/i-prgvrs.i AXSEP028 2.00.00.028 } /* 16/10/2026 15:40:54 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsep028 MAX}
&ENDIF

   
{utp/ut-glob.i}     
{cdp/cdcfgdis.i}
{include/i_prdvers.i}
{include/i-epc200.i AXSEP028}

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            EP2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       InvoiceNFe
&GLOBAL-DEFINE XmlTranVersion    204.000

/* DEFINICAO DE PRE-PROCESSADORES - END */


/*LOCAL VARIABLES - BEGIN*/

{adapters/xml/ep2/axsep028.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep028extradeclarations.i} /* Outras Declaraá‰es             */

{cdp/cd0666.i}

DEFINE VARIABLE tp-integ          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter-Erro  AS CHARACTER NO-UNDO.


/*LOCAL VARIABLES - END*/   

/*PARAMETERS - BEGIN*/
/*DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.*/
/*PARAMETERS - END*/

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK" THEN DO:        
   
    {utp/ut-liter.i "Erro ao executar"}
     ASSIGN c-lbl-liter-Erro = TRIM(RETURN-VALUE).
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = trim(c-lbl-liter-Erro) + " " + c-lbl-liter-Erro + ":" + cReturnValue
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN cReturnValue.
END.


/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF cReturnValue <> "OK"
THEN DO:
    {utp/ut-liter.i "Erro ao carregar a"}
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          /* Inicio -- Projeto Internacional */
         
          ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-api-xml AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "API_XML" *}
          ASSIGN c-lbl-liter-api-xml = TRIM(RETURN-VALUE).
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = trim(c-lbl-liter) + " " + c-lbl-liter-api-xml + ": " + cReturnValue
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN cReturnValue.
END.

/****** INTERNAL PROCEDURES - BEGIN*/
PROCEDURE PIUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR ttAssinante      .
DEFINE INPUT  PARAM TABLE FOR ttDestNFCom      .
DEFINE INPUT  PARAM TABLE FOR ttDetNFCom       .
DEFINE INPUT  PARAM TABLE FOR ttEmitNFCom      .
DEFINE INPUT  PARAM TABLE FOR ttICMSTotNFCom   .
DEFINE INPUT  PARAM TABLE FOR ttIdeNFCom       .
DEFINE INPUT  PARAM TABLE FOR ttNFCom          .
DEFINE INPUT  PARAM TABLE FOR ttRetTribTotNFCom.
DEFINE INPUT  PARAM TABLE FOR ttFUST           .
DEFINE INPUT  PARAM TABLE FOR ttFUNTTEL        .
DEFINE INPUT  PARAM TABLE FOR ttICMSSN         .
DEFINE INPUT  PARAM TABLE FOR ttPISNFCom        .
DEFINE INPUT  PARAM TABLE FOR ttCOFINSNFCom     .
DEFINE INPUT  PARAM TABLE FOR ttTotal          .
DEFINE INPUT  PARAM TABLE FOR ttICMSUFDestNFCom.
DEFINE INPUT  PARAM TABLE FOR ttICMS00         .
DEFINE INPUT  PARAM TABLE FOR ttICMS20         .
DEFINE INPUT  PARAM TABLE FOR ttICMS40         .
DEFINE INPUT  PARAM TABLE FOR ttICMS51         .
DEFINE INPUT  PARAM TABLE FOR ttICMS90         .
DEFINE INPUT  PARAM TABLE FOR ttgFatNFCom      .
DEFINE INPUT  PARAM TABLE FOR ttRetTrib        .
DEFINE INPUT  PARAM TABLE FOR ttInfAdicNFCom   .
DEFINE INPUT  PARAM TABLE FOR ttgCompraGov     .
DEFINE INPUT  PARAM TABLE FOR ttgPagAntecipado .
DEFINE INPUT  PARAM TABLE FOR ttIBSCBS         .
DEFINE INPUT  PARAM TABLE FOR ttTribRT         .
DEFINE INPUT  PARAM TABLE FOR ttgTribRegular   .
DEFINE INPUT  PARAM TABLE FOR ttgCredPresOper  .
DEFINE INPUT  PARAM TABLE FOR ttgIBSCBSCredPres.
DEFINE INPUT  PARAM TABLE FOR ttgTribCompraGov .
DEFINE INPUT  PARAM TABLE FOR ttgIBSCBSMono    .
DEFINE INPUT  PARAM TABLE FOR ttgTransfCred    .
DEFINE INPUT  PARAM TABLE FOR ttgAjusteCompet  .
DEFINE INPUT  PARAM TABLE FOR ttgEstornoCred   .
DEFINE INPUT  PARAM TABLE FOR ttgCredPresIBSZFM.
DEFINE INPUT  PARAM TABLE FOR ttVB             .
DEFINE INPUT  PARAM TABLE FOR ttDFeReferenciado.
DEFINE INPUT  PARAM TABLE FOR ttTotIBSCBSIS    .
DEFINE INPUT  PARAM TABLE FOR ttgSub           .
DEFINE INPUT  PARAM TABLE FOR ttgALCZFMCBS     .
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro      .
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/


//DEFINE VAR pErrorId     AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR pErrorType   AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR lCreateMsg   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR cLiteral     AS CHARACTER               NO-UNDO.
DEFINE VAR pSendSuccess AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR iCount       AS INTEGER   INITIAL ?     NO-UNDO.

/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK" THEN DO:
   
    {utp/ut-liter.i "Erro ao executar"}
        ASSIGN c-lbl-liter-Erro = TRIM(RETURN-VALUE).
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = trim(c-lbl-liter-Erro) + " " + c-lbl-liter-Erro + ":" + cReturnValue
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN cReturnValue.
END.

RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
                                     "{&XmlApp}", 
                                     "{&XmlTranName}", 
                                     "{&XmlTranVersion}", 
                                     cEvent, 
                                     cTranAction, 
                                     OUTPUT lCreateMsg).

IF RETURN-VALUE <> "OK" THEN DO:

    ASSIGN cReturnValue = RETURN-VALUE.
    {utp/ut-liter.i "Erro ao executar"}
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          /* Inicio -- Projeto Internacional */
        
          ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-issubscribed-no-messagehandle AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "isSubscribed_no_MessageHandle" *}
          ASSIGN c-lbl-liter-issubscribed-no-messagehandle = TRIM(RETURN-VALUE).
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = trim(c-lbl-liter) + c-lbl-liter-issubscribed-no-messagehandle + ": "+ cReturnValue
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN RETURN-VALUE.
END.

/*IF NOT lCreateMsg THEN DO:

     {utp/ut-liter.i "A Transacao"}
     ASSIGN cLiteral = TRIM(RETURN-VALUE).
     {utp/ut-liter.i " nao e assinada."}
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = cLiteral +  '{&XmlTranName}':U  + TRIM(RETURN-VALUE)
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN "OK".
END.*/


/* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
RUN setTransInfoComment IN hMessageHandler ("Comment").

/* SETA SystemId */
RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").

/* SETA Chave Primaria */
IF  NOT AVAIL ttNFCom THEN
    FIND FIRST ttNFCom NO-LOCK NO-ERROR. 

RUN setKeyFields IN hMessageHandler ("nota-fiscal.cod-estabel":U, STRING(ttNFCom.CodEstabelNFCom)).
RUN setKeyFields IN hMessageHandler ("nota-fiscal.serie":U,       STRING(ttNFCom.SerieNFCom     )).
RUN setKeyFields IN hMessageHandler ("nota-fiscal.nr-nota-fis":U, STRING(ttNFCom.NrNotaFisNFCom )).


/*------------------------- INTEGRAÄ«O TSS [TOTVS] -------------------------*/

RUN cdp/cd0360b.p (INPUT ttNFCom.CodEstabelNFCom,
                   INPUT "NFCom",
                   OUTPUT tp-integ).
                   
IF  LOOKUP (tp-integ,"TSS,TC":U) > 0 THEN DO:

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = ttNFCom.CodEstabelNF
          AND (param-nf-estab.ind-empresa <> ""
          AND  param-nf-estab.ind-empresa <> ?):

        RUN setKeyFields IN hMessageHandler ("ID_ENT", param-nf-estab.ind-empresa).
    END.
END.
/*--------------------------------------------------------------------------*/

/* INFORMA A EMPRESA E O ESTABELECIMENTO */
RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), "").

     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8").

     RUN addNode IN hGenXml (getStack(), "Upsert", "", OUTPUT iId).
    
     addStack(iId).

         RUN adapters/xml/ep2/axsep028imprimexml.p (INPUT hGenXml                 , 
                                                    INPUT-OUTPUT TABLE ttStack    , 
                                                    INPUT  TABLE ttAssinante      ,
                                                    INPUT  TABLE ttDestNFCom      ,
                                                    INPUT  TABLE ttDetNFCom       ,
                                                    INPUT  TABLE ttEmitNFCom      ,
                                                    INPUT  TABLE ttICMSTotNFCom   ,
                                                    INPUT  TABLE ttIdeNFCom       ,
                                                    INPUT  TABLE ttNFCom          ,
                                                    INPUT  TABLE ttRetTribTotNFCom ,
                                                    INPUT  TABLE ttFUST           ,
                                                    INPUT  TABLE ttFUNTTEL        ,
                                                    INPUT  TABLE ttICMSSN         ,
                                                    INPUT  TABLE ttPISNFCom       ,   
                                                    INPUT  TABLE ttCOFINSNFCom    ,   
                                                    INPUT  TABLE ttTotal          ,
                                                    INPUT  TABLE ttICMSUFDestNFCom,
                                                    INPUT  TABLE ttICMS00         ,
                                                    INPUT  TABLE ttICMS20         ,
                                                    INPUT  TABLE ttICMS40         ,
                                                    INPUT  TABLE ttICMS51         ,
                                                    INPUT  TABLE ttICMS90         ,
                                                    INPUT  TABLE ttgFatNFCom      ,
	                                                INPUT  TABLE ttRetTrib        ,
                                                    INPUT  TABLE ttInfAdicNFCom   ,
                                                    INPUT  TABLE ttgCompraGov     ,
                                                    INPUT  TABLE ttgPagAntecipado ,
                                                    INPUT  TABLE ttIBSCBS         ,
                                                    INPUT  TABLE ttTribRT         ,
                                                    INPUT  TABLE ttgTribRegular   ,
                                                    INPUT  TABLE ttgCredPresOper  ,
                                                    INPUT  TABLE ttgIBSCBSCredPres,
                                                    INPUT  TABLE ttgTribCompraGov ,
                                                    INPUT  TABLE ttgIBSCBSMono    ,
                                                    INPUT  TABLE ttgTransfCred    ,
                                                    INPUT  TABLE ttgAjusteCompet  ,
                                                    INPUT  TABLE ttgEstornoCred   ,
                                                    INPUT  TABLE ttgCredPresIBSZFM,
                                                    INPUT  TABLE ttVB             ,
                                                    INPUT  TABLE ttDFeReferenciado,
                                                    INPUT  TABLE ttTotIBSCBSIS    ,                                                    
                                                    INPUT  TABLE ttgSub           ,                                                    
                                                    INPUT  TABLE ttgALCZFMCBS      ).                                                                                                                                                             
                                                    
                                                    
     delStack().

/* OBTEM O XML NUMA HANDLE */
RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

/* DEFINE O CONTEÈDO DO ELEMENTO BusinessContent */
RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

/* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
DELETE OBJECT hBusinessContent NO-ERROR.



/*------ BUSCAR SCHEMA CORRESPONDENTE ∑ VERS«O DE LAYOUT PARAMETRIZADA ------*/

DEFINE VARIABLE cArqSchema AS CHARACTER INITIAL ? NO-UNDO.

IF  NOT AVAIL ttNFCom THEN
    FIND FIRST ttNFCom NO-LOCK NO-ERROR. 


ASSIGN cArqSchema = "xmlschema/ep2/invoicenfe_204_000_v3.10.xsd". /*Lizi*/

/*---------------------------------------------------------------------------*/

/*CONTR‡I A MENSAGEM XML E ENVIA PARA O ControlBroker */

IF  SEARCH(cArqSchema) <> ?  THEN
    RUN sendMessage IN hMessageHandler (INPUT cArqSchema).
ELSE DO:         
    /*
    {utp/ut-liter.i "Schema para a vers∆o de layout"}
    ASSIGN cLiteral = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "n∆o encontrado."}
    CREATE TT_LOG_ERRO.
    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
    ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = cLiteral + " " + ttNFe.VersaoLayout +  " " + TRIM(RETURN-VALUE)
           tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
    RETURN RETURN-VALUE.
    */
END.

/* VERIFICA SE OCORREU ALGUM ERRO */
IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
          /* Inicio -- Projeto Internacional */
          
          ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-erro-no-envio-da-mensagem AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Erro_no_envio_da_Mensagem" *}
          ASSIGN c-lbl-liter-erro-no-envio-da-mensagem = TRIM(RETURN-VALUE).
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-erro-no-envio-da-mensagem + ": "+ c-lbl-liter
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN RETURN-VALUE.
END.

/* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

/* SE NAO ENVIO COM SUCESSO */
IF NOT pSendSuccess THEN DO:
     REPEAT iCount = 1 TO pTotalErrors:
          CREATE TT_LOG_ERRO.
          RUN getError IN hMessageHandler (iCount, OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, OUTPUT pErrorType, OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006
                 tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     END.
     RETURN "NOK".
END.
ELSE RETURN "OK".

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

/****** INTERNAL PROCEDURES - END**/

{adapters/xml/ep2/axsep028upsert.i}




