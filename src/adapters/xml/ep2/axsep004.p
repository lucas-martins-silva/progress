/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP004 2.00.00.040 } /*** "010040" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep004 MUT}
&ENDIF

{cdp/cdcfgdis.i}
{include/i-epc200.i AXSEP004}

/******************           INTEGRAÄ«O EAI:             *********************/
/*************  ADAPTER DE ENVIO NOTA FISCAL ELETRONICA - AXSEP004  ***********/
/* Criaá∆o: 13/03/2007                                            
   Samanta Rosalina Cunha                                                     */

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            VD2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ConsultationDocument
&GLOBAL-DEFINE XmlTranVersion    204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   upd

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue    AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg      AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess    AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors    AS INTEGER   INITIAL ?     NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS integer   INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro  AS character INITIAL ?.

DEFINE TEMP-TABLE ttConsProtNFe NO-UNDO
    FIELD k          AS ROWID
    FIELD CODRETNFE  AS CHAR
    FIELD MSGRETNFE  AS CHAR.

DEFINE TEMP-TABLE tt-retorno-eai NO-UNDO
    FIELD cod-retorno AS CHARACTER.

DEFINE VARIABLE c-estab LIKE docum-est.cod-estabel NO-UNDO.
DEFINE VARIABLE c-versao-nfe AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-caminho    AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont-progs AS INTEGER   NO-UNDO.

/*LOCAL VARIABLES - END*/


{utp/ut-glob.i}

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + ": "+ cReturnValue.
     RETURN cReturnValue.
END.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

DEF VAR hQueryResult AS HANDLE NO-UNDO.

DEF VAR h-filaeai AS HANDLE NO-UNDO.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}
IF cReturnValue <> "OK":U
THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_ao_carregar_a_API_XML" *}
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + ": "+ cReturnValue.
     RETURN cReturnValue.
END.

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.


FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.
     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.
END FUNCTION.

FUNCTION delStack RETURN INTEGER.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.
     FIND LAST ttStack NO-ERROR.
END FUNCTION.

FUNCTION getStack RETURN INTEGER.
     IF AVAIL(ttStack) THEN
          RETURN ttStack.ttPos.
     ELSE
          RETURN 0.
END FUNCTION.

/****** INTERNAL PROCEDURES - BEGIN*/
PROCEDURE PIUpsert:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM p-nfe       AS CHARACTER           NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE VAR iCount                    AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iId                       AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iIdDatasulMessage         AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iIdReturnContent          AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iIdListOfExtraInformation AS INTEGER   INITIAL ? NO-UNDO. 
    DEFINE VAR iIdExtraInformation       AS INTEGER   INITIAL ? NO-UNDO. 
    DEFINE VAR pErrorId                  AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorType                AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR pTotalErrors              AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR cKey                      AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR cStatus                   AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR cStatus2                  AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR hOutputXML                AS HANDLE              NO-UNDO.
    DEFINE VAR l-cStat                   AS LOGICAL             NO-UNDO.
    DEFINE VAR h-bodi486                 AS HANDLE              NO-UNDO.
    DEFINE VAR c-msg-aux                 AS CHARACTER           NO-UNDO.    
    DEFINE VAR cTpTrans                  AS CHARACTER           NO-UNDO.
    /*LOCAL VARIABLES - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    EMPTY TEMP-TABLE tt-retorno-eai.
    EMPTY TEMP-TABLE tt_log_erro.
    EMPTY TEMP-TABLE ttConsProtNFe.
    /* Integracao Totvs Colaboracao - parametro global - Caso tenha essa integracao sempre valida via TSS */
    DEFINE VARIABLE l-integr-totvs-colab AS LOGICAL INITIAL NO NO-UNDO.
    RUN cdp/cd0029a.p (output l-integr-totvs-colab).

    RUN cdp/cd0360b.p (INPUT c-estab,
                       INPUT "ConsChave":U,
                       OUTPUT cTpTrans).

    IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) = 0 THEN DO:

        /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
        {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}
        IF cReturnValue <> "OK":U THEN DO:
             CREATE TT_LOG_ERRO.
                  ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
                  ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + ": "+ cReturnValue.
             RETURN cReturnValue.
        END.
        
        /* VERIFICA SE Hµ PROGRAMAS INSCRITOS */
        RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",                                          
                                             INPUT "{&XmlApp}", 
                                             INPUT "{&XmlTranName}", 
                                             INPUT "{&XmlTranVersion}", 
                                             INPUT "", 
                                             INPUT cTranAction, 
                                             OUTPUT lCreateMsg).
        IF RETURN-VALUE <> "OK":U THEN DO:
             CREATE TT_LOG_ERRO.
                  ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                  ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-erro-ao-executar-issubscribed AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Erro_ao_executar_isSubscribed_no_MessageHandle" *}
                  ASSIGN c-lbl-liter-erro-ao-executar-issubscribed = TRIM(RETURN-VALUE).
                  ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-lbl-liter-erro-ao-executar-issubscribed + ": "+ c-lbl-liter.
             RETURN RETURN-VALUE.
        END.
    
        IF  NOT lCreateMsg THEN DO:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "A_Transacao_'{&XmlTranName}'_nao_e_assinada" *}
            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + '.'
                   tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
            RETURN "OK":U.
        END. 
        
        /* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
        RUN setTransInfoComment IN hMessageHandler ("Comment").
        
        /* SETA SystemId */
        RUN setSystemId IN hMessageHandler ("{&XmlMod}":U,  
                                            "{&XmlProdVersion}").
    
        /* SETA VALORES NA CHAVE PRIMARIA DA TRANSAÄ«O */
        RUN setKeyFields IN hMessageHandler ("Chave-NFe", p-nfe).
    END.
    /*------------------------- INTEGRAÄ«O TSS [TOTVS] -------------------------*/
    IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) > 0 THEN DO:

        /*Busca o estabelecimento para o qual est† sendo feita a entrada da NFe. Esse Ç o estabelecimento que ser† usado para buscar a parametrizaá∆o no CD0403*/
        FIND FIRST param-nf-estab NO-LOCK WHERE param-nf-estab.cod-estabel = c-estab NO-ERROR.
        IF AVAIL param-nf-estab AND 
           param-nf-estab.ind-empresa <> "" THEN DO:

           IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) > 0 THEN DO:
               RUN pi-Consulta-Situacao-NFe-TSS-Sincrono (INPUT p-nfe).
               RETURN "OK":U.
           END.
           ELSE
               RUN setKeyFields IN hMessageHandler ("ID_ENT", param-nf-estab.ind-empresa).

        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "N∆o_encontradas_as_parametrizaá‰es_necess†rias_ao_TSS_no_CD0403,_para_o_estabelecimento" *}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 17006,
                               INPUT STRING(RETURN-VALUE + ": " + c-estab)).
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE.  
            RETURN "NOK":U. /*Sair, para n∆o tentar consultar a nota*/
        END.
    END.
    /*--------------------------------------------------------------------------*/
    
    
    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), "").
    
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.
    
    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode IN hGenXml (getStack(), "Upsert":U, "":U, OUTPUT iId).

    addStack(iId).
        RUN addNode IN hGenXml (getStack(), "ConsSitNFe":U, "":U, OUTPUT iId).

        addStack(iId).
        
            RUN addNodeDec IN hGenXml (getStack(), "tpAmb":U, "1":U,  OUTPUT iId).
            RUN addNode    IN hGenXml (getStack(), "xServ":U, "",     OUTPUT iId).
            RUN addNode    IN hGenXml (getStack(), "chNFe":U, p-nfe,  OUTPUT iId).
        IF c-versao-nfe = "2.00":U OR c-versao-nfe = "" OR c-versao-nfe = ?  THEN 
            RUN addNode IN hGenXml (getStack(), "versao":U, "2.00":U, OUTPUT iId).
        ELSE IF c-versao-nfe = "1.10":U THEN
            RUN addNode IN hGenXml (getStack(), "versao":U, "1.06":U, OUTPUT iId).
        ELSE
            RUN addNode IN hGenXml (getStack(), "versao":U, c-versao-nfe, OUTPUT iId).

        
        delStack().
    delStack().
    
    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).


    /*----------------------------- UPC para Tratamento Espec°fico NF-e ----------------------------*/
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:
    
        DEFINE VARIABLE cConteudoNFe AS CHARACTER NO-UNDO.
    
        /* OBTEM O XML NUMA STRING */
        RUN generateXMLToString IN hGenXml (OUTPUT cConteudoNFe). /* Conte£do principal referente Ö nota fiscal eletrìnica <NF-e> atÇ </NFe> */
    
        /* TrataNFeEspec: EPC para tratamento espec°fico - vai chamar novo adapter na upc [SHV] */
        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "TrataNFeEspec":U:
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataNFeEspec":U
               tt-epc.cod-parameter = "ConteudoNFe":U
               tt-epc.val-parameter = cConteudoNFe.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataNFeEspec":U
               tt-epc.cod-parameter = "RowidNFe":U
               tt-epc.val-parameter = STRING(ROWID(nota-fiscal)) WHEN AVAIL nota-fiscal.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataNFeEspec":U
               tt-epc.cod-parameter = "Origem":U
               tt-epc.val-parameter = "CONSULTA":U.
    
        {include/i-epc201.i "TrataNFeEspec"}

        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "TrataNFeEspec":U
              AND tt-epc.cod-parameter = "RetornoErro":U:
            
            CREATE tt_log_erro.
            ASSIGN ttv_num_cod_erro  = INT(tt-epc.val-parameter)
                   ttv_des_msg_ajuda = ""
                   ttv_des_msg_erro  = "".
        END.
    
        IF  CAN-FIND (FIRST tt-epc
                      WHERE tt-epc.cod-event     = "TrataNFeEspec":U
                        AND tt-epc.cod-parameter = "XMLEspec":U) THEN
            RETURN "OK":U. /*chamou novo adapter na UPC, ent∆o n∆o gera XML, e retorna */
    END.
    /*----------------------------------------------------------------------------------------------*/

    
    /* DEFINE O CONTEUDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
    
    /* LIBERA MEMORIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.

    
    /*CONSTROI A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "ep2/ConsultInvoiceDocument_204_106.xsd":U). 
    
    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF RETURN-VALUE <> "OK":U THEN DO:
       CREATE TT_LOG_ERRO.
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
       ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
       DEFINE VARIABLE c-lbl-liter-erro-no-envio-da-mensagem AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Erro_no_envio_da_Mensagem" *}
       ASSIGN c-lbl-liter-erro-no-envio-da-mensagem = TRIM(RETURN-VALUE).
       ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006
              TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-lbl-liter-erro-no-envio-da-mensagem + ": "+ c-lbl-liter-2.
       RETURN RETURN-VALUE.
    END.
    

    /* Grava XML enviado ao integrador na fila do EAI [/* 1- Envio (SendXML.xml)  2- Retorno (ReturnXML.xml) */] */
    IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN DO:
        IF  CONNECTED("EAI")
        AND NOT VALID-HANDLE(h-filaeai) THEN
            RUN adapters/xml/ep2/axsep007writefilaeai.p PERSISTENT SET h-filaeai.

        IF  VALID-HANDLE(h-filaeai) THEN
            RUN piFilaEAI IN h-filaeai (INPUT 1,
                                        INPUT "Chave NFe: " + p-nfe).
    END.

    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, 
                                            OUTPUT pTotalErrors).

    
    /* SE NAO ENVIO COM SUCESSO */
    IF NOT pSendSuccess THEN DO:
       REPEAT iCount = 1 TO pTotalErrors:
            CREATE TT_LOG_ERRO.
            RUN getError IN hMessageHandler (iCount, 
                                             OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, 
                                             OUTPUT pErrorType, 
                                             OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.
       END.
       RETURN "NOK":U.
    END.
    ELSE DO: /* Là mensagem de retorno e verifica se a NF-e tem uso autorizado */
        
        RUN getCompleteReturnHandle IN hMessageHandler (OUTPUT hOutputXML).

        RUN reset              IN hGenXml.
        RUN loadXml            IN hGenXml (INPUT hOutputXML).
        
        RUN searchTag IN hGenXML ( INPUT "DatasulMessage":U, INPUT 0,  OUTPUT iIdDatasulMessage).
        IF iIdDatasulMessage <> ? THEN DO:
            addStack(iIdDatasulMessage). 
            RUN searchTag IN hGenXml (INPUT "ReturnContent":U, INPUT iIdDatasulMessage, OUTPUT iIdReturnContent). 
            IF iIdReturnContent <> ? THEN DO:
                
                addStack(iIdReturnContent). 
                RUN searchTag IN hGenXml (INPUT "ListOfExtraInformation":U, INPUT iIdReturnContent, OUTPUT iIdListOfExtraInformation). 
                IF iIdListOfExtraInformation <> ? THEN DO:
                    addStack(iIdListOfExtraInformation). 
                    
                    RUN getFirstSonId IN hGenXml (INPUT iIdListOfExtraInformation, OUTPUT iIdExtraInformation). 
                    ASSIGN cstatus2 = "".
                    DO WHILE iIdExtraInformation <> ?: /* tags ExtraInformation */
                        addStack(iIdExtraInformation).
                        
                        RUN getSonVal  IN hGenXml (INPUT iIdExtraInformation, INPUT "Key":U, OUTPUT cKey).
                        IF cKey = "cStat":U  THEN DO:
                            RUN getSonVal IN hGenXml (INPUT iIdExtraInformation, INPUT "Value":U, OUTPUT cStatus).
                            
                            /* ASSIGN cStatus2 = cStatus2 + "|" + cStatus. */
                            CREATE tt-retorno-eai.
                            ASSIGN tt-retorno-eai.cod-retorno = cStatus.
                        END.
                
                        ASSIGN iIdExtraInformation = getStack().
                        delStack().  
                        RUN getNextSonId in hGenXml (input iIdListOfExtraInformation, input iIdExtraInformation, output iIdExtraInformation).
                    END.
                    delStack().  
                END.
                delStack().
            END.
            delStack().
        END.
        
        FIND FIRST tt-retorno-eai
             WHERE tt-retorno-eai.cod-retorno = "101" /* Cancelamento de NF-e homologado */
                OR tt-retorno-eai.cod-retorno = "151" /* Cancelamento de NF-e homologado fora prazo */
                OR tt-retorno-eai.cod-retorno = "155" /* Cancelamento homologado fora de prazo (evento de Cancelamento - [NT2011.006]) */
             NO-LOCK NO-ERROR.
                
        IF  AVAIL tt-retorno-eai THEN DO:
            RUN utp/ut-msgs.p (INPUT 'msg':U, INPUT 52843, INPUT "").
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 52843
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO = "(" + tt-retorno-eai.cod-retorno + ") " + RETURN-VALUE. 
            RUN utp/ut-msgs.p (INPUT 'help':U, INPUT 52843, INPUT tt-retorno-eai.cod-retorno).
	        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
        END.
        ELSE DO: /* Nao esta cancelada */
            FIND FIRST tt-retorno-eai
                 WHERE tt-retorno-eai.cod-retorno = "100" /* Uso autorizado */
                    OR tt-retorno-eai.cod-retorno = "150" /* Uso Autorizado fora do prazo */
                 NO-LOCK NO-ERROR.
                    
            IF AVAIL tt-retorno-eai THEN DO:
                RUN utp/ut-msgs.p (INPUT 'msg':U, INPUT 52844, INPUT "").
                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 52844
                       TT_LOG_ERRO.TTV_DES_MSG_ERRO = "(" + tt-retorno-eai.cod-retorno + ") " + RETURN-VALUE. 
       	        RUN utp/ut-msgs.p (INPUT 'help':U, INPUT 52844, INPUT tt-retorno-eai.cod-retorno).
    	        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.					   
            END.
            ELSE DO: /* N∆o esta autorizada */
                FOR EACH tt-retorno-eai NO-LOCK:     
                    ASSIGN c-msg-aux = "".
                    
                    IF tt-retorno-eai.cod-retorno = "" THEN DO:
                        RUN utp/ut-msgs.p (INPUT 'msg':U, INPUT 33187, INPUT ''). /* N∆o foi possivel validar a chave de acesso da NFE */
                        CREATE TT_LOG_ERRO.
                        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 33187
                               TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE.
                    END.
                    ELSE IF tt-retorno-eai.cod-retorno = "217" THEN DO:
                        RUN utp/ut-msgs.p (INPUT 'msg':U, INPUT 53045, INPUT ''). /* NF-e ou CT-e n∆o consta da base da SEFAZ */
                        CREATE TT_LOG_ERRO.
                        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 53045
                               TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE.
                    END.
                    ELSE DO: /* Tem outro codigo de retorno (Rejeicao) */
                        /* Consulta descriá∆o da rejeiá∆o (tt-retorno-eai.cod-retorno) na bodi486 */
                        IF  NOT VALID-HANDLE(h-bodi486) THEN
                            RUN dibo/bodi486.p PERSISTENT SET h-bodi486.
    
                        RUN goToKey IN h-bodi486 (INPUT tt-retorno-eai.cod-retorno). 
                        IF  RETURN-VALUE = "OK":U THEN DO:
                            RUN getCharField IN h-bodi486 (INPUT "dsl-msg":U, OUTPUT c-msg-aux). /* Busca descriá∆o da msg */
                        END.
                        
                        CREATE TT_LOG_ERRO.
                        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 33140 /* Danfe inv†lido */
                               TT_LOG_ERRO.TTV_DES_MSG_ERRO = "(" + tt-retorno-eai.cod-retorno + ") " + c-msg-aux.    

                    END.    
                END. /* fim - for each tt-retorno-eai */
            END.    
        END.
    END.

    /* Grava XML de retorno na fila do EAI [/* 1- Envio (SendXML.xml)  2- Retorno (ReturnXML.xml) */] */
    IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN DO:
        IF  CONNECTED("EAI")
        AND NOT VALID-HANDLE(h-filaeai) THEN
            RUN adapters/xml/ep2/axsep007writefilaeai.p PERSISTENT SET h-filaeai.

        IF  VALID-HANDLE(h-filaeai) THEN
            RUN piFilaEAI IN h-filaeai (INPUT 2,
                                        INPUT "Chave NFe: " + p-nfe).
    END.

    IF  VALID-HANDLE(h-bodi486) THEN DO: /* Elimina Handle */
        DELETE PROCEDURE h-bodi486.
        ASSIGN h-bodi486 = ?.
    END.

    IF  VALID-HANDLE(h-filaeai) THEN DO: /* Elimina Handle */
        DELETE PROCEDURE h-filaeai.
        ASSIGN h-filaeai = ?.
    END.

    RETURN "OK":U.
   
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

PROCEDURE pi-Consulta-Situacao-NFe-TSS-Sincrono:
    DEFINE INPUT PARAMETER cChaveAcesso AS CHAR NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunicaá∆o com o TSS*/
    END.


    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                 TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                 TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif). 
                               
    RUN setTSSAuthParam IN h-TSSAPI(INPUT 1,
                                    INPUT "*",
                                    INPUT param-nf-estab.cod-estabel,
                                    INPUT param-nf-estab.cod-url-ws-tss).
    
    RUN NFESBRA_CONSULTAPROTOCOLONFE IN h-TSSAPI (INPUT param-nf-estab.ind-empresa,
                                                  INPUT cChaveAcesso,
                                                  INPUT BUFFER ttConsProtNFe:HANDLE).
    
    ASSIGN cReturnValue = RETURN-VALUE.

    RUN disconnectTss IN h-TSSAPI ("NFESBRA":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS CONSULTAPROTOCOLONFE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS CONSULTAPROTOCOLONFE]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:

        FOR FIRST ttConsProtNFe: END.
        IF AVAIL ttConsProtNFe AND ttConsProtNFe.CODRETNFE <> "" THEN DO:
            
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = "(" + ttConsProtNFe.CODRETNFE + ") " + ttConsProtNFe.MSGRETNFE.
        
            CASE ttConsProtNFe.CODRETNFE:
                WHEN "101" OR WHEN "151" OR WHEN "155" THEN
                    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 52843. /* NFe Cancelada */
                WHEN "100" OR WHEN "150" THEN
                    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 52844. /* NFe Autorizada */
                WHEN "217" THEN
                    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 53045. /* NF-e ou CT-e n∆o consta da base da SEFAZ */
                OTHERWISE
                    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 33140. /* Danfe invalido */
            END CASE.

	        RUN utp/ut-msgs.p (INPUT 'help':U, INPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, INPUT ttConsProtNFe.CODRETNFE).
	        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
			
         END.
         ELSE DO:
             RUN utp/ut-msgs.p (INPUT 'msg':U, INPUT 33187, INPUT ''). /* N∆o foi possivel validar a chave de acesso da NFE */
             CREATE TT_LOG_ERRO.
             ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 33187
                    TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE.
         END.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.

PROCEDURE pi-Recebe-Versao-Nfe:

    DEFINE INPUT PARAM p-versao AS CHARACTER NO-UNDO.
    ASSIGN c-versao-nfe = p-versao.

END PROCEDURE.

PROCEDURE pi-Recebe-Estab:

    DEFINE INPUT PARAM p-estab LIKE docum-est.cod-estabel NO-UNDO.
    ASSIGN c-estab = p-estab.

END PROCEDURE.
/****** INTERNAL PROCEDURES - END*/

{adapters/xml/ep2/axsep004upsert.i}


/* {adapters/xml/ep2/axsep007writefila.i} */
