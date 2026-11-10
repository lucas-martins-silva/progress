/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP020 2.00.00.032 } /*** "010032" ***/
            
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsep020 MAX}
&ENDIF
 
 
{utp/ut-glob.i}     
{cdp/cdcfgdis.i}

&GLOBAL-DEFINE XmlApp            EP2
&GLOBAL-DEFINE XmlMod            MRE
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    206
&GLOBAL-DEFINE XmlTranName       RemessaEvento
&GLOBAL-DEFINE XmlTranVersion    206.000

{adapters/xml/ep2/axsep020ExtraDeclarations.i}
                                           
{cdp/cd0666.i}

{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF  cReturnValue <> "OK" THEN DO:
    CREATE TT_LOG_ERRO.
    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
    ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + ": "+ cReturnValue.
    RETURN cReturnValue.
END.
    
CREATE X-DOCUMENT hBusinessContent.

{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF  cReturnValue <> "OK" THEN DO:
    CREATE TT_LOG_ERRO.
    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Erro_ao_carregar_a_API_XML" *}
    ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = RETURN-VALUE + ": "+ cReturnValue.
    RETURN cReturnValue.
END.


PROCEDURE PIUpsert:

    DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR ttEvento.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF cReturnValue <> "OK" THEN DO:
         CREATE TT_LOG_ERRO.
              ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
              ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
                     tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
         RETURN cReturnValue.
    END.

    RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", "{&XmlApp}", "{&XmlTranName}", "{&XmlTranVersion}", cEvent, cTranAction, OUTPUT lCreateMsg).

    IF RETURN-VALUE <> "OK" THEN DO:
         CREATE TT_LOG_ERRO.
              ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
              ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-erro-ao-executar-iss AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Erro_ao_executar_isSubscribed_no_MessageHandle" *}
              ASSIGN c-lbl-liter-erro-ao-executar-iss = TRIM(RETURN-VALUE).
              ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-erro-ao-executar-iss + ": "+ c-lbl-liter
                     tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
         RETURN RETURN-VALUE.
    END.

    IF NOT lCreateMsg THEN DO:
         CREATE TT_LOG_ERRO.
              ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "A_transa‡Æo_'{&XmlTranName}'_nÆo_‚_assinada" *}
              ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + '.'
                     tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
         RETURN "OK".
    END.

    FIND FIRST ttEvento.

    RUN setTransInfoComment IN hMessageHandler ("Comment").
    RUN setSystemId         IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").
    RUN setKeyFields        IN hMessageHandler ("cod-chave-aces-nf-eletro", ttEvento.chNFe).

    /*------------------------- INTEGRA€ÇO TSS [TOTVS] -------------------------*/
    RUN cdp/cd0360b.p (INPUT ttEvento.codEstab,
                       INPUT IF tt-selec-docto.tp-evento = "110111"
                             OR tt-selec-docto.tp-evento = "110112"
                             OR tt-selec-docto.tp-evento = "110114"
                             OR tt-selec-docto.tp-evento = "110115"
                             OR tt-selec-docto.tp-evento = "110116" THEN "MDF-e":U ELSE "MD-e":U,
                       OUTPUT cTpTrans).

    IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) > 0 THEN DO:

        FOR FIRST param-nf-estab NO-LOCK WHERE
                  param-nf-estab.cod-estabel = ttEvento.codEstab AND
                 (param-nf-estab.ind-empresa <> ""               AND
                  param-nf-estab.ind-empresa <> ?):

            RUN setKeyFields IN hMessageHandler ("ID_ENT", param-nf-estab.ind-empresa).
        END.
    END.
    /*--------------------------------------------------------------------------*/

    RUN setCompanyId        IN hMessageHandler (STRING(v_cdn_empres_usuar), "").

    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8").
    RUN addNode     IN hGenXml (getStack(), "Upsert", "", OUTPUT iId).
    addStack(iId).
        RUN addNode      IN hGenXml (getStack(), "envEvento",    "", OUTPUT iId).
        /*RUN setAttribute IN hGenxml (iId, "xmlns", "http://www.portalfiscal.inf.br/nfe").*/
        addStack(iId).
            RUN addNode      IN hGenXml (getStack(), "eventos",        "", OUTPUT iId).
            addStack(iId).

            FOR EACH ttEvento: 
                RUN addNode      IN hGenXml (getStack(), "detEvento",    "", OUTPUT iId).
                addStack(iId).
                    RUN addNode      IN hGenXml (getStack(), "tpEvento", ttEvento.tpEvento, OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "chnfe"   , ttEvento.chNFe,    OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "ambiente", ttEvento.tpAmb,    OUTPUT iId).

                    IF ttEvento.tpEvento = "110112" THEN DO:
                        ASSIGN c-dt-enc       = SUBSTRING(ttEvento.dhEvento,1,8)     
                               c-uf           = SUBSTRING(ttEvento.xJust,1,2)
                               c-cod-mun-ibge = trim(SUBSTRING(ttEvento.xJust,4,7)).
                       
                        RUN addNode      IN hGenXml (getStack(), "dtEnc", c-dt-enc,          OUTPUT iId).
                        RUN addNode      IN hGenXml (getStack(), "cUF",   CAPS(c-uf),        OUTPUT iId).
                        RUN addNode      IN hGenXml (getStack(), "cMun",  c-cod-mun-ibge,    OUTPUT iId).
                    END.
                    ELSE IF ttEvento.tpEvento = "110114" THEN DO: /*Novo Evento MDF-e - Inclusão de condutor*/
                        RUN addNode  IN hGenXml (getStack(), "nomecondutor", TRIM(SUBSTRING(ttEvento.xJust,1,60)),  OUTPUT iId).
                        RUN addNode  IN hGenXml (getStack(), "cpfcondutor",  TRIM(SUBSTRING(ttEvento.xJust,61,11)), OUTPUT iId).
                    END.
                    ELSE
                        RUN addNode      IN hGenXml (getStack(), "xJust"   , ttEvento.xJust,    OUTPUT iId).
                delStack().
            END.
            delStack().
        delStack().
    delStack().

    RUN generateXML         IN hGenXml (OUTPUT hBusinessContent).

    RUN generateXMLToMemptr IN hGenXml (OUTPUT inPtr) NO-ERROR.
    COPY-LOB inPtr TO lcConteudo.

    IF RETURN-VALUE = "Leave" THEN RETURN "OK".

    RUN setBusinessContent IN hMessageHandler (INPUT  hBusinessContent).
    DELETE OBJECT hBusinessContent NO-ERROR.
    RUN sendMessage        IN hMessageHandler (INPUT "xmlschema/ep2/RemessaEvento_Env_204_000_v1.00.xsd").

    IF  RETURN-VALUE <> "OK" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-erro-no-envio-da-msg AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Erro_no_envio_da_Mensagem" *}
        ASSIGN c-lbl-liter-erro-no-envio-da-msg = TRIM(RETURN-VALUE).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-lbl-liter-erro-no-envio-da-msg + ": " + c-lbl-liter-2.
        RETURN RETURN-VALUE.
    END.

    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF  NOT pSendSuccess THEN DO:
        REPEAT iCount = 1 TO pTotalErrors:
            CREATE TT_LOG_ERRO.
            RUN getError IN hMessageHandler (iCount, OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, OUTPUT pErrorType, OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
        END.
        RETURN "NOK".
    END.

END PROCEDURE.

{adapters/xml/ep2/axsep020Upsert.i}
{adapters/xml/ep2/axsep020upc.i}
