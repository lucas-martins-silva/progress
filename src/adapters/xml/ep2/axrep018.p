/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXREP018 2.00.00.003 } /*** 010003 ***/
    
      

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axrep018 MAX}
&ENDIF

{utp/ut-glob.i}     
{cdp/cdcfgdis.i}

&GLOBAL-DEFINE XmlApp            EP2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       CartaCorrecaoEletronicaRet
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 209.999
&GLOBAL-DEFINE XmlListOfAction   add,upd

{adapters/xml/ep2/axrep018ExtraDeclarations.i}

{xmlinc/xmlLoadMessageHandlerRecDef.i}

{xmlinc/xmlLoadGenXmlRecDef.i}

{xmlinc/xmlgettranssubsinfo.i}

PROCEDURE PIUpsert:

    DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
         
    RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).
    RUN reset   IN hGenXml.
    RUN loadXml IN hGenXml (hBusinessContent).
    DELETE OBJECT hBusinessContent NO-ERROR.

    addStack(1).

    EMPTY TEMP-TABLE ttretEvento NO-ERROR.
    CREATE ttretEvento.

        RUN searchTag IN hGenXml (INPUT "retEnvEvento", INPUT getStack(),     OUTPUT iId).
        addStack(iId).

            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "idLote",   OUTPUT idLote  ).
            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "tpAmb",    OUTPUT tpAmb   ).
            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "verAplic", OUTPUT verAplic).
            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "cOrgao",   OUTPUT cOrgao  ).
            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "cStat",    OUTPUT cStat   ).
            RUN getSonVal     IN hGenXml (INPUT getStack(), INPUT "xMotivo",  OUTPUT xMotivo ).
            RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).

            DO WHILE iId <> ?:
            addStack(iId).

                CREATE ttretEvento.
                ASSIGN ttretEvento.ttretEventoID = iId.

                RUN searchTag IN hGenXml (INPUT "infEvento", INPUT getStack(), OUTPUT iId).
                addStack(iId).

                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "tpAmb",       OUTPUT ttretEvento.tpAmb      ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "verAplic",    OUTPUT ttretEvento.verAplic   ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "cOrgao",      OUTPUT ttretEvento.cOrgao     ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "cStat",       OUTPUT ttretEvento.cStat      ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "xMotivo",     OUTPUT ttretEvento.xMotivo    ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "chNFe",       OUTPUT ttretEvento.chNFe      ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "tpEvento",    OUTPUT ttretEvento.tpEvento   ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "xEvento",     OUTPUT ttretEvento.xEvento    ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "nSeqEvento",  OUTPUT ttretEvento.nSeqEvento ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "emailDest",   OUTPUT ttretEvento.emailDest  ).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "dhRegEvento", OUTPUT ttretEvento.dhRegEvento).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "nProt",       OUTPUT ttretEvento.nProt      ).
                
                delStack().

                ASSIGN iId = getStack().

            delStack().

                RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
    
            END.

        delStack().

    delStack().

    {adapters/xml/ep2/axrep018Upsert.i}

END PROCEDURE.


PROCEDURE receiveMessage:

    DEFINE INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.

    {xmlinc/xmlLoadMessageHandlerRec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}
    
    IF  cReturnValue <> "OK" THEN DO:
        RETURN cReturnValue.
    END.

    RUN parseMessage IN hMessageHandler (INPUT  hInputXml,       INPUT "{&XmlTranName}", INPUT "{&XmlMaxTranVersion}", INPUT "{&XmlMinTranVersion}", INPUT "{&XmlListOfEvents}",
                                         OUTPUT lSuccessProcess, OUTPUT cTranAction,     OUTPUT cTranEvent,            OUTPUT cTranVersion,          OUTPUT hOutputXML).
    
    IF  NOT lSuccessProcess OR RETURN-VALUE <> "OK" THEN 
        RETURN RETURN-VALUE.
    
    {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}
    
    IF  cReturnValue <> "OK" THEN DO:
        DELETE OBJECT hBusinessContent NO-ERROR.
        RETURN cReturnValue.
    END.

    {adapters/xml/ep2/axrep018VersionControl.i}

END PROCEDURE.



