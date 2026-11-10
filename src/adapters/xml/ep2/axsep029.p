/***********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*************************************************************************************/
{include/i-prgvrs.i AXSEP029 2.00.00.003 } /* 12/03/2026 17:31:23 */
               
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsep029 MAX}
&ENDIF 
  
{utp/ut-glob.i}     
{cdp/cdcfgdis.i}
{include/i_prdvers.i}
{include/i-epc200.i AXSEP029}

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */

&GLOBAL-DEFINE XmlApp            EP2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       InvoiceNFe
&GLOBAL-DEFINE XmlTranVersion    204.000

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/

{adapters/xml/ep2/axsep029.i}                  /* Definiá∆o tabela tempor†ria */
{adapters/xml/ep2/axsep029extradeclarations.i} /* Outras Declaraá‰es          */

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
DEFINE INPUT  PARAM TABLE FOR ttDCe          .
DEFINE INPUT  PARAM TABLE FOR ttIdeDCe       .
DEFINE INPUT  PARAM TABLE FOR ttEmitDCe      .
DEFINE INPUT  PARAM TABLE FOR ttIDEmitDCe    .
DEFINE INPUT  PARAM TABLE FOR ttDestDCe      .
DEFINE INPUT  PARAM TABLE FOR ttDetDCe       .
DEFINE INPUT  PARAM TABLE FOR ttTransp       .
DEFINE INPUT  PARAM TABLE FOR ttinfAdic      .
DEFINE INPUT  PARAM TABLE FOR ttinfDec       .
DEFINE INPUT  PARAM TABLE FOR ttinfDCeSupl   .    
DEFINE INPUT  PARAM TABLE FOR ttTotalDCe     .
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro    .
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
IF  NOT AVAIL ttDCe THEN
    FIND FIRST ttDCe NO-LOCK NO-ERROR. 

RUN setKeyFields IN hMessageHandler ("dce-documento.cod-estabel":U, STRING(ttDCe.CodEstabelDCe)).
RUN setKeyFields IN hMessageHandler ("dce-documento.serie":U,       STRING(ttDCe.SerieDCe     )).
RUN setKeyFields IN hMessageHandler ("dce-documento.nr-dce":U,      STRING(ttDCe.NrDCe        )).


/*------------------------- INTEGRAÄ«O TSS [TOTVS] -------------------------*/

RUN cdp/cd0360b.p (INPUT ttDCe.CodEstabelDCe,
                   INPUT "DCe",
                   OUTPUT tp-integ).
                   
IF  LOOKUP (tp-integ,"TSS,TC":U) > 0 THEN DO:

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = ttDCe.CodEstabelDCe
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

         RUN adapters/xml/ep2/axsep029imprimexml.p (INPUT hGenXml                 , 
                                                    INPUT-OUTPUT TABLE ttStack    , 
                                                    INPUT  TABLE ttDCe           ,
                                                    INPUT  TABLE ttIdeDCe        ,
                                                    INPUT  TABLE ttEmitDCe       ,
                                                    INPUT  TABLE ttIDEmitDCe     ,
                                                    INPUT  TABLE ttDestDCe       ,
                                                    INPUT  TABLE ttDetDCe        ,
                                                    INPUT  TABLE ttTransp        ,
                                                    INPUT  TABLE ttinfAdic       ,
                                                    INPUT  TABLE ttinfDec        ,
                                                    INPUT  TABLE ttinfDCeSupl    ,
                                                    INPUT  TABLE ttTotalDCe      ).
     delStack().
     
/* OBTEM O XML NUMA HANDLE */
RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

/* DEFINE O CONTEÈDO DO ELEMENTO BusinessContent */
RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

/* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
DELETE OBJECT hBusinessContent NO-ERROR.


/*------ BUSCAR SCHEMA CORRESPONDENTE ∑ VERS«O DE LAYOUT PARAMETRIZADA ------*/

DEFINE VARIABLE cArqSchema AS CHARACTER INITIAL ? NO-UNDO.

IF  NOT AVAIL ttDCe THEN
    FIND FIRST ttDCe NO-LOCK NO-ERROR. 

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

{adapters/xml/ep2/axsep029upsert.i}
