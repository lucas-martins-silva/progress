/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP002 2.00.00.034 } /*** 010034 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep002 MUT}
&ENDIF

{cdp/cdcfgdis.i}
{include/i-epc200.i AXSEP002}

&IF DEFINED(bf_dis_nfe) &THEN 

/******************           INTEGRA€ÇO EAI:             *********************/
/*************  ADAPTER DE ENVIO NOTA FISCAL ELETRONICA - AXSEP002  ***********/
/* Cria‡Æo: 12/03/2007                                            
   Samanta Rosalina Cunha                                                     */

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            VD2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       CancelDocument
&GLOBAL-DEFINE XmlTranVersion    204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add,upd

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue    AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg      AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess    AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors    AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR c-motivo        AS CHARACTER               NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
       FIELD ttv_num_cod_erro  AS integer   INITIAL ?
       FIELD ttv_des_msg_ajuda AS character INITIAL ?
       FIELD ttv_des_msg_erro  AS character INITIAL ?.

def temp-table tt_nfe_erro  no-undo
    field cStat     as CHAR    /* C¢digo do Status da resposta */
    field chNFe     as CHAR   /* Chave de acesso da Nota Fiscal Eletr“nica */
    field dhRecbto  as CHAR   /* Data/Hora da homologacao do cancelamento */
    field nProt     as CHAR.  /* N£mero do protocolo de aprovacao */


/*---------------------------------------------------------
             TRATAMENTO PARA ACENTUA€ÇO
---------------------------------------------------------*/

{include/i-freeac.i}

DEFINE VARIABLE c-string-com-acento AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-string-sem-acento AS CHARACTER   NO-UNDO.

/*-------------------------------------------------------*/



/*LOCAL VARIABLES - END*/
DEFINE VAR cProtocolo AS CHARACTER NO-UNDO.
DEFINE VAR cMotivo    AS CHARACTER NO-UNDO.

/*PARAMETERS - BEGIN*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

{utp/ut-glob.i}

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U THEN DO:
     CREATE TT_LOG_ERRO.
     ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
     ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
            tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
     RETURN cReturnValue.
END.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

DEF VAR hQueryResult AS HANDLE NO-UNDO.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}
IF cReturnValue <> "OK":U
THEN DO:
     CREATE TT_LOG_ERRO.
     ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Erro_ao_carregar_a_API_XML" *}
     ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
            tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
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
    DEFINE INPUT  PARAM p-motivo    AS CHARACTER           NO-UNDO.
    DEFINE INPUT  PARAM p-row-table AS ROWID               NO-UNDO. 
    DEFINE OUTPUT PARAM p-tipo-transacao AS INTEGER             NO-UNDO. /* 1 - Sincrona | 2 - Assincrona */
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
    DEFINE VAR cStatus                   AS CHARACTER           NO-UNDO.
    DEFINE VAR hOutputXML                AS HANDLE              NO-UNDO.
    DEFINE VAR cVersaoLayoutNFe          AS CHARACTER           NO-UNDO.
    DEFINE VAR cTpTrans                  AS CHARACTER           NO-UNDO.
   /*LOCAL VARIABLES - END*/
    
    ASSIGN c-motivo = p-motivo.

    /*--- Tratamento Acentuacao ---*/
    ASSIGN c-string-com-acento = c-motivo
           c-string-sem-acento = fn-free-accent(c-string-com-acento).

    ASSIGN c-motivo = c-string-sem-acento.
    /*--- FIM Tratamento Acentuacao ---*/


    

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}
    IF cReturnValue <> "OK":U THEN DO:
         CREATE TT_LOG_ERRO.
         ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
         ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
                tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
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
         ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
         ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-erro-ao-executar-issubscribed AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Erro_ao_executar_isSubscribed_no_MessageHandle" *}
         ASSIGN c-lbl-liter-erro-ao-executar-issubscribed = TRIM(RETURN-VALUE).
         ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-erro-ao-executar-issubscribed + ": "+ c-lbl-liter
                tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
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
    
    RUN setKeyFields IN hMessageHandler ("nota-fiscal.cod-estabel":U, nota-fiscal.cod-estabel).
    RUN setKeyFields IN hMessageHandler ("nota-fiscal.serie":U,       nota-fiscal.serie).
    RUN setKeyFields IN hMessageHandler ("nota-fiscal.nr-nota-fis":U, nota-fiscal.nr-nota-fis).

    /* SETA VALORES NA CHAVE PRIMARIA DA TRANSA€ÇO */
    &if "{&bf_dis_versao_ems}" < "2.07" &THEN
    RUN setKeyFields IN hMessageHandler ("Chave-NFe":U, TRIM(SUBSTRING(nota-fiscal.char-2,3,60))).
    &ELSEIF "{&bf_dis_versao_ems}" >= "2.07" &THEN
    RUN setKeyFields IN hMessageHandler ("Chave-NFe":U, TRIM(STRING   (nota-fiscal.cod-chave-aces-nf-eletro))).
    &ENDIF
    
    RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                   INPUT "NF-e":U,
                   OUTPUT cTpTrans).
    /*------------------------- INTEGRA€ÇO TSS [TOTVS] -------------------------*/
    IF  LOOKUP(cTpTrans, "TSS,TC":U) > 0 THEN DO:
    
        FOR FIRST param-nf-estab NO-LOCK
            WHERE param-nf-estab.cod-estabel = nota-fiscal.cod-estabel
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
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode IN hGenXml (getStack(), 
                            "Upsert":U, 
                            "":U, 
                            OUTPUT iId).
    addStack(iId).

    IF  NOT AVAIL estabelec
    OR (AVAIL estabelec
    AND estabelec.cod-estabel <> nota-fiscal.cod-estabel) THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel: 
        END.

    ASSIGN cVersaoLayoutNFe = &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                                 TRIM(estabelec.des-vers-layout)
                              &else 
                                 TRIM(SUBSTRING(estabelec.char-1,173,10))
                              &endif WHEN AVAIL estabelec NO-ERROR.
    
    RUN addNode IN hGenXml (getStack(), 
                            "cancNFe":U, 
                            "":U, 
                            OUTPUT iId).
    RUN setAttribute IN hGenXml (INPUT iId, "versao", (IF cVersaoLayoutNFe = "1.10":U THEN "1.07":U
                                                                                      ELSE "2.00":U)).

    addStack(iId).

    
    
    /* RUN addNode IN hGenXml (getStack(),  */
    /*                         "versao":U,  */
    /*                         "1.06",      */
    /*                         OUTPUT iId). */
    
    RUN addNode IN hGenXml (getStack(), 
                            "infCanc":U, 
                            "":U, 
                            OUTPUT iId).

    RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("NFe" + 
                                                       &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN TRIM(REPLACE(nota-fiscal.cod-chave-aces-nf-eletro," ",""))
						       &else TRIM(REPLACE(SUBSTRING(nota-fiscal.char-2,3,60)," ",""))
                                                       &endif  )).

    addStack(iId).
    
    &if "{&bf_dis_versao_ems}" < "2.07" &THEN
        RUN addNode IN hGenXml (getStack(), 
                                "Id":U, 
                                "ID" + REPLACE(SUBSTRING(nota-fiscal.char-2,3,60)," ",""), 
                                OUTPUT iId).
    &else
        RUN addNode IN hGenXml (getStack(), 
                                "Id":U, 
                                "ID" + REPLACE(STRING(nota-fiscal.cod-chave-aces-nf-eletro)," ",""), 
                                OUTPUT iId).
    &ENDIF
    
    &if "{&bf_dis_versao_ems}" < "2.07" &THEN
        RUN addNode IN hGenXml (getStack(), 
                                "chNFe":U, 
                                SUBSTRING(nota-fiscal.char-2,3,60), 
                                OUTPUT iId).

        RUN addNode IN hGenXml (getStack(), 
                                "nProt":U, 
                                SUBSTR(nota-fiscal.char-1,97,15), 
                                OUTPUT iId).
    &ELSE
        RUN addNode IN hGenXml (getStack(), 
                                "chNFe":U, 
                                STRING(nota-fiscal.cod-chave-aces-nf-eletro), 
                                OUTPUT iId).

        RUN addNode IN hGenXml (getStack(), 
                                "nProt":U, 
                                nota-fiscal.cod-protoc, 
                                OUTPUT iId).
    &ENDIF
    

    RUN addNode IN hGenXml (getStack(), 
                           "xJust":U, 
                            c-motivo, 
                            OUTPUT iId).
    
    delStack().
    delStack().
    delStack().
    delStack().
    
    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).


    /*----------------------------- UPC para Tratamento Espec¡fico NF-e ----------------------------*/
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:

        DEFINE VARIABLE cConteudoNFe AS CHARACTER NO-UNDO.

        ASSIGN p-tipo-transacao = 2.
    
        /* OBTEM O XML NUMA STRING */
        RUN generateXMLToString IN hGenXml (OUTPUT cConteudoNFe). /* Conte£do principal referente … nota fiscal eletr“nica <NF-e> at‚ </NFe> */
    
        /* TrataNFeEspec: EPC para tratamento espec¡fico - vai chamar novo adapter na upc [SHV] */
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
               tt-epc.val-parameter = "CANCELAMENTO":U.
    
        {include/i-epc201.i "TrataNFeEspec"}
    
        FOR FIRST tt-epc NO-LOCK
            WHERE tt-epc.cod-event     = "TrataNFeEspec":U
              AND tt-epc.cod-parameter = "GeraTT_LOG_ERRO":U :

            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = INT(ENTRY(1,tt-epc.val-parameter,"#"))
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO  =     ENTRY(2,tt-epc.val-parameter,"#")
                   TT_LOG_ERRO.TTV_DES_MSG_AJUDA =     ENTRY(3,tt-epc.val-parameter,"#").
        END.
    
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "TrataNFeEspec":U
              AND tt-epc.cod-parameter = "XMLEspec":U :

            IF  ENTRY(1,tt-epc.val-parameter,"#") = "CancelaNota":U THEN DO:

                /* Ao criar um registro na tt_nfe_erro, e retornar ao BO que executou este adapter, ira efetivar o cancelamento */
                
                CREATE tt_nfe_erro.
                ASSIGN tt_nfe_erro.chNFe    = &IF "{&bf_dis_versao_ems}" < "2.07" &THEN
                                                SUBSTRING(nota-fiscal.char-2,3,60)
                                              &ELSE
                                                STRING(nota-fiscal.cod-chave-aces-nf-eletro)
                                              &ENDIF
                       tt_nfe_erro.dhRecbto = STRING(TODAY)
                       tt_nfe_erro.cStat    = "101":U /* Cancelamento de NF-e homologado */
                       tt_nfe_erro.nProt    = ENTRY(2,tt-epc.val-parameter,"#").
            END.
        
            RETURN "OK":U. /*chamou novo adapter na UPC, entÆo nÆo gera XML padrÆo, e retorna */
        END.
    END.
    /*----------------------------------------------------------------------------------------------*/

    
    /* DEFINE O CONTEUDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
    
    /* LIBERA MEMÓRIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* OBTEM O RESULTADO DA CONSULTA */
    /*RUN getQueryReturnHandle IN hMessageHandler (OUTPUT hQueryResult).*/
  
    /*CONSTROI A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "ep2/CancelInvoiceDocument_204_106.xsd":U). 
    
    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF RETURN-VALUE <> "OK":U THEN DO:
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
    
    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, 
                                            OUTPUT pTotalErrors).

    
    ASSIGN p-tipo-transacao = ?.

    /* SE NAO ENVIO COM SUCESSO */
    IF NOT pSendSuccess THEN DO:
         REPEAT iCount = 1 TO pTotalErrors:
              CREATE TT_LOG_ERRO.
              RUN getError IN hMessageHandler (iCount, 
                                               OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, 
                                               OUTPUT pErrorType, 
                                               OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
              ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006
                     tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
         END.
         RETURN "NOK":U.
    END.
    ELSE DO: /* Lˆ mensagem de retorno e verifica se a NF-e tem uso autorizado */

         /* SETA TRANSA€ÇO COMO ASSÖNCRONA */
         ASSIGN p-tipo-transacao = 2.
         
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
                           ASSIGN p-tipo-transacao = 1. /*Tem retorno no ExtraInformation, entÆo ‚ transa‡Æo SÖNCRONA*/
                            addStack(iIdListOfExtraInformation).

                                RUN getFirstSonId IN hGenXml (INPUT iIdListOfExtraInformation, OUTPUT iIdExtraInformation).
                                DO WHILE iIdExtraInformation <> ?: /* tags ExtraInformation */
                                    addStack(iIdExtraInformation).
                                             
                                        RUN getSonVal  IN hGenXml (INPUT iIdExtraInformation, INPUT "Key":U, OUTPUT cKey).
                                        
                                        IF cKey = "cStat":U  THEN 
                                           RUN getSonVal IN hGenXml (INPUT iIdExtraInformation, INPUT "Value":U, OUTPUT cStatus).
                                        ELSE IF cKey = "nProt":U  THEN
                                           RUN getSonVal IN hGenXml (INPUT iIdExtraInformation, INPUT "Value":U, OUTPUT cProtocolo).
                                        ELSE IF cKey = "xMotivo":U  THEN
                                           RUN getSonVal IN hGenXml (INPUT iIdExtraInformation, INPUT "Value":U, OUTPUT cMotivo).
                                         
                                        ASSIGN iIdExtraInformation = getStack().
                                    
                                    delStack().
    
                                    RUN getNextSonId IN hGenXml (INPUT iIdListOfExtraInformation, INPUT iIdExtraInformation, OUTPUT iIdExtraInformation).

                                END.
                            delStack().
                        END.

                     delStack().
                 END.
             delStack().
         END.

        /*--- SÖNCRONA ---*/
        IF  p-tipo-transacao = 1 THEN DO:
        IF (cStatus = "101":U  OR  /*101 Cancelamento de NF-e homologado*/                                                
            cStatus = "151":U  OR  /*151 Cancelamento de NF-e homologado fora de prazo*/                                  
            cStatus = "155":U)     /*155 Cancelamento homologado fora de prazo (para Evento de Cancelamento [NT2011.006]*/
        THEN DO:
           CREATE TT_LOG_ERRO.
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Nota_fiscal_cancelada_com_sucesso" *}
           ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 27979
                  TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE
                  tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        END.
        ELSE DO:
             CREATE tt_log_erro.
             ASSIGN tt_log_erro.ttv_num_cod_erro  = 17006
                    tt_log_erro.ttv_des_msg_erro  = cMotivo
                    tt_log_erro.ttv_des_msg_ajuda = cMotivo.
        END.
        
        CREATE tt_nfe_erro.
        ASSIGN tt_nfe_erro.chNFe    = &IF "{&bf_dis_versao_ems}" < "2.07" &THEN
                                        SUBSTRING(nota-fiscal.char-2,3,60)
                                       &ELSE
                                        string(nota-fiscal.cod-chave-aces-nf-eletro)
                                       &ENDIF
               tt_nfe_erro.dhRecbto = string(TODAY)
               tt_nfe_erro.cStat    = cStatus
               tt_nfe_erro.nProt    = cProtocolo.
        END.
        /*--- ASSÖNCRONA ---*/
        ELSE DO:

            CREATE tt_log_erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nf-e-em-processo-de-cancelamen AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "NF-e_em_processo_de_Cancelamento" *}
            ASSIGN c-lbl-liter-nf-e-em-processo-de-cancelamen = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-nf AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "[NF" *}
            ASSIGN c-lbl-liter-nf = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-o-cancelamento-da-nf-e-se-dara AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_cancelamento_da_NF-e_se_dar _ap¢s_o_retorno_de_homologa‡Æo_da_Sefaz" *}
            ASSIGN c-lbl-liter-o-cancelamento-da-nf-e-se-dara = TRIM(RETURN-VALUE).
            ASSIGN tt_log_erro.ttv_num_cod_erro  = 17006
                   tt_log_erro.ttv_des_msg_erro  = c-lbl-liter-nf-e-em-processo-de-cancelamen + "!" + " " + c-lbl-liter-nf + " " + nota-fiscal.nr-nota-fis + "]"
                   tt_log_erro.ttv_des_msg_ajuda = c-lbl-liter-o-cancelamento-da-nf-e-se-dara + ".".
        END.
        
        RETURN "OK":U.
END.
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.


/****** INTERNAL PROCEDURES - END*/

{adapters/xml/ep2/axsep002upsert.i}
&endif 
