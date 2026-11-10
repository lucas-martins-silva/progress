/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSDB003 2.00.00.005}  /*** 010005 ***/

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            CDP
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ShiftDBR
&GLOBAL-DEFINE XmlTranVersion    204.000

/* LOCAL VARIABLES - BEGIN */
DEFINE VAR cReturnValue    AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE                NO-UNDO.
DEFINE VAR lCreateMsg      AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess    AS LOGICAL INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors    AS INTEGER INITIAL ?     NO-UNDO.
DEFINE VAR iSeqErro        AS INTEGER               NO-UNDO.

/*** Variaveis globais ***/
{utp/ut-glob.i}

/* Defini‡Æo de temp-tables */
/*** tt-erro ***/
{cdg/cdg0666.i}

DEFINE TEMP-TABLE ttListOfDayShift NO-UNDO
     FIELD ttListOfDayShiftID   AS INTEGER 
     FIELD DayNumber            AS INTEGER  /*Número que corresponde ao dia da semana do modelo de turno. (Uso interno: campo=turno-dia.num-dia)*/
     FIELD SeqShift             AS INTEGER  /*Código da seqüência do modelo de turno.(Uso interno: campo=turno-dia.num-turno)*/
     FIELD EndTime              AS DECIMAL  /*Hora de término da seqüência de turno naquele dia da semana. (Uso interno: campo=turno-dia.qtd-hra-fim)*/     
     FIELD StartTime            AS DECIMAL  /*Hora de Início da seqüência de turno naquele dia da seman.(Uso interno: campo=turno-dia.qtd-hra-inicio*/
     FIELD StopTime             AS DECIMAL  /*Tempo de parada da seqüência do modelo de turno naquele dia da semana. (Uso interno: campo=turno-dia.qtd-tempo-interrup)*/     
     FIELD ttListOfShiftInformationID AS INTEGER INITIAL ?.

DEFINE TEMP-TABLE ttListOfShiftInformation NO-UNDO
     FIELD ttListOfShiftInformationID AS INTEGER        
     FIELD ShiftModelCode             AS CHARACTER            /*Código do modelo de turno. (Uso interno: campo=model-turno-semana.cod-model-turno)*/
     FIELD ShiftModelDescription      AS CHARACTER            /*Descrição do modelo de turno. (Uso interno: campo=model-turno-semana.des-model-turno)*/
     FIELD UsefulWeeklyTime           AS DECIMAL              /*Tempo útil do modelo de turno. (Uso interno: campo=model-turno-seman.qtd-tempo-util-sem)*/
     FIELD WeeklyInterruptionTime     AS DECIMAL              /*Tempo de parada do modelo de turno. (Uso interno: campo=model-tuno-semana.qtd-tempo-interrup-sem)*/
     FIELD QtdDayInterruptionTime     AS DECIMAL     EXTENT 7 /*Tempo Interrupção por Dia.(Uso interno: campo=mgind.model-turno-semana.qtd-tempo-interrup-dia)*/
     FIELD QtdUsefulDayTime           AS DECIMAL     EXTENT 7 /*Tempo Útil por Dia. (Uso interno: campo=mgind.model-turno-semana.qtd-tempo-util-dia)*/
     INDEX ixttListOfShiftInformationID IS PRIMARY UNIQUE ttListOfShiftInformationID ASCENDING.

DEFINE TEMP-TABLE tt-model-turno-dbr NO-UNDO
    FIELD cod-model-turno        AS CHARACTER
    FIELD des-model-turno        AS CHARACTER
    FIELD qtd-tempo-util-dia     AS DECIMAL EXTENT 7
    FIELD qtd-tempo-interrup-dia AS DECIMAL EXTENT 7 
    FIELD qtd-tempo-util-sem     AS DECIMAL
    FIELD qtd-tempo-interrup-sem AS DECIMAL
    INDEX codigo IS PRIMARY UNIQUE
          cod-model-turno.

DEFINE TEMP-TABLE tt-turno-dia-dbr NO-UNDO
   FIELD cod-model-turno      AS CHARACTER
   FIELD num-dia              AS INTEGER
   FIELD num-turno            AS INTEGER
   FIELD qtd-hra-fim          AS DECIMAL DECIMALS 4
   FIELD qtd-hra-inicio       AS DECIMAL DECIMALS 4
   FIELD qtd-tempo-interrup   AS DECIMAL DECIMALS 4
   INDEX id IS PRIMARY UNIQUE
         cod-model-turno
         num-dia 
         qtd-hra-inicio
   INDEX turno
         cod-model-turno
         num-turno.


DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

/* Defini‡Æo de functions */
FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
     ASSIGN ttStack.ttID = id
            ttStack.ttPos = val.
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

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}
    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 17006,
                      RETURN-VALUE + cReturnValue + "~~":U +
                      RETURN-VALUE + cReturnValue).
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE
           iSeqErro         = iSeqErro + 1.
           
    RETURN "NOK".
END.

/* Handle do BusinessContent */
DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VARIAVEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEFINE VAR hGenXml          AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_carregar_a_API_XML:_ *}
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE + cReturnValue
           iSeqErro         = iSeqErro + 1.
    RETURN "NOK".
END.

/* PROCEDURES INTERNAS */

PROCEDURE PIUpsert:
    DEFINE INPUT PARAM cTranAction          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM cProgName            AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM cProgVersion         AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR ttListOfShiftInformation.
    DEFINE INPUT PARAM TABLE FOR ttListOfDayShift.
    DEFINE INPUT PARAM de-val-refer-atualiz AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.    
    
    DEFINE VAR iCount               AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iId                  AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorId             AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorType           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR pTotalErrors         AS INTEGER   INITIAL ? NO-UNDO.    

    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF  cReturnValue <> "OK":U THEN DO:                      
        {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}  
        CREATE tt-erro.                                      
        ASSIGN tt-erro.i-sequen = iSeqErro                   
               tt-erro.cd-erro  = 17006                      
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.              
        RETURN "NOK".                                 
    END.                                                     

    RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
                                         "{&XmlApp}", 
                                         "{&XmlTranName}", 
                                         "{&XmlTranVersion}", 
                                         "":U, 
                                         cTranAction, 
                                         OUTPUT lCreateMsg).
    

    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_ao_executar_isSubscribed_no_MessageHandle:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = trim(RETURN-VALUE) + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK".
    END.

    IF  NOT lCreateMsg THEN DO:
        RETURN "OK":U.
    END.

    /* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Programa: " + cProgName + " - " + "VersÆo: " + cProgVersion).

    /* SETA SystemId */
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").
        
    FOR EACH ttListOfShiftInformation:
        RUN setKeyFields IN hMessageHandler ("tt-model-turno-dbr.cod-model-turno":U, ttListOfShiftInformation.ShiftModelCode).
    END.

    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler ( String(v_cdn_empres_usuar) , " " ).  

     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8":U).

     RUN addNode IN hGenXml (getStack(), "Upsert":U, "", OUTPUT iId).
     addStack(iId).

          RUN addNode IN hGenXml (getStack(), "ListOfShiftInformation":U, "", OUTPUT iId).
          addStack(iId).
          FOR EACH ttListOfShiftInformation:

              RUN addNode IN hGenXml (getStack(), "ShiftInformation":U, "", OUTPUT iId).
              addStack(iId).
                   
                        RUN addNode IN hGenXml (getStack(), "WeeklyShiftModel":U, "", OUTPUT iId).
                        addStack(iId).

                             RUN addNode    IN hGenXml (getStack(), "ShiftModelCode":U, ttListOfShiftInformation.ShiftModelCode, OUTPUT iId).
                             RUN addNode    IN hGenXml (getStack(), "ShiftModelDescription":U, ttListOfShiftInformation.ShiftModelDescription, OUTPUT iId).
                             RUN addNodeDec IN hGenXml (getStack(), "UsefulWeeklyTime":U, ttListOfShiftInformation.UsefulWeeklyTime, OUTPUT iId).
                             RUN addNodeDec IN hGenXml (getStack(), "WeeklyInterruptionTime":U, ttListOfShiftInformation.WeeklyInterruptionTime, OUTPUT iId).
                             RUN addNode    IN hGenXml (getStack(), "ListOfUsefulDayTime":U, "", OUTPUT iId).
                             addStack(iId).

                                  /* FOR EACH ttUsefulDayTime OF WeeklyShiftModel: END. */

                                  REPEAT iCount = 1 TO 7:
                                       RUN addNode IN hGenXml (getStack(), "UsefulDayTime":U, "", OUTPUT iId).
                                       addStack(iId).
                                       RUN addNodeDec IN hGenXml (getStack(), "QtdUsefulDayTime":U, ttListOfShiftInformation.QtdUsefulDayTime[iCount], OUTPUT iId).
                                       delStack().
                                  END.
                                  delStack().

                             RUN addNode IN hGenXml (getStack(), "ListOfDayInterruptionTime":U, "", OUTPUT iId).
                             addStack(iId).

                                  /* FOR EACH ttDayInterruptionTime OF WeeklyShiftModel: */

                                  REPEAT iCount = 1 TO 7:
                                       RUN addNode IN hGenXml (getStack(), "DayInterruptionTime":U, "", OUTPUT iId).
                                       addStack(iId).
                                       RUN addNodeDec IN hGenXml (getStack(), "QtdDayInterruptionTime":U, ttListOfShiftInformation.QtdDayInterruptionTime[iCount], OUTPUT iId).
                                       delStack().
                                  END.
                             delStack().

                        delStack().
      
                    IF  CAN-FIND (FIRST ttListOfDayShift 
                                  WHERE ttListOfDayShift.ttListOfShiftInformationID =  ttListOfShiftInformation.ttListOfShiftInformationID) THEN DO:
                       RUN addNode IN hGenXml (getStack(), "ListOfDayShift", "", OUTPUT iId).
                       addStack(iId).
    
                          FOR EACH ttListOfDayShift OF ttListOfShiftInformation:
                           
                                RUN addNode IN hGenXml (getStack(), "DayShift", "", OUTPUT iId).
                                addStack(iId).
    
                                     RUN addNodeDec IN hGenXml (getStack(), "SeqShift":U,  ttListOfDayShift.SeqShift, OUTPUT iId).
                                     RUN addNodeDec IN hGenXml (getStack(), "DayNumber":U, ttListOfDayShift.DayNumber, OUTPUT iId).                                                                                
                                     RUN addNodeDec IN hGenXml (getStack(), "StartTime":U, ttListOfDayShift.StartTime, OUTPUT iId).
                                     RUN addNodeDec IN hGenXml (getStack(), "EndTime":U,   ttListOfDayShift.EndTime, OUTPUT iId).
                                     RUN addNodeDec IN hGenXml (getStack(), "StopTime":U,  ttListOfDayShift.StopTime, OUTPUT iId).
    
                                delStack().
                          END.
                      delStack().                         
                   END.

              delStack().
          END.
          delStack().
          RUN addNodeDec IN hGenXml (getStack(), "ReferenceValue":U, de-val-refer-atualiz, OUTPUT iId).

     delStack().

    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    
    
    /* DEFINE O CONTEÚDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
    
    /* LIBERA MEMÓRIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.
    
    /*CONTRÓI A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "dbr/ShiftDBR_204_000.xsd":U). 
    
    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_no_envio_da_Mensagem:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK".
    END.
    
    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    /* SE NAO ENVIO COM SUCESSO */
    IF NOT pSendSuccess THEN DO:
       REPEAT iCount = 1 TO pTotalErrors:
           CREATE tt-erro.
           ASSIGN tt-erro.i-sequen = iSeqErro
                  iSeqErro         = iSeqErro + 1.
           RUN getError IN hMessageHandler (INPUT  iCount,
                                            OUTPUT tt-erro.cd-erro,
                                            OUTPUT pErrorType,
                                            OUTPUT tt-erro.mensagem).
       END.
       RETURN "NOK":U.
    END.
    ELSE
        RETURN "OK":U.

END PROCEDURE.


/****** INTERNAL PROCEDURES - END*/


{adapters/xml/dbr/axsdb003upsert.i}
/* EOF */
