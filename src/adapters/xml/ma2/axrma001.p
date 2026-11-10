&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMA001 2.00.00.007}  /*** 010007 ***/



/*------------------------------------------------------------------------
    File        : axrma001.p
    Purpose     : Revebimento do Reporte po Item
    Syntax      :
    Description :
    Author(s)   : Ana Cristina Spieker (ksm15088)
    Created     : 08/03/2004
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlProdName EMS2
&GLOBAL-DEFINE XmlProdVersion 2.04
&GLOBAL-DEFINE XmlApp MA2 
&GLOBAL-DEFINE XmlTranName ItemProductionReport
&GLOBAL-DEFINE XmlMinTranVersion 200.000
&GLOBAL-DEFINE XmlMaxTranVersion 206.999
&GLOBAL-DEFINE XmlListOfAction add,upd

/* DEFINE AS VARAIVEIS PARA USO DO xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}

{cpp/cpapi009.i}


{cdp/cd0666.i}         /* Definiá∆o Temp-Table de Erros                */
{utp/ut-glob.i}        /* Vari†veis Globais                            */


/* TEMP-TABLE QUE ARMAZENA OS ERROS OCORRIDOS NA EFETIVACAO DA MENSAGEM */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.38
         WIDTH              = 35.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* DEFINE A PROCEDURE getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTINO
  Parameters: pInputXml, pOutputXml
  Notes:       
------------------------------------------------------------------------------*/

    /* PARAMENTROS DE ENTRADA E SAIDA */
    DEF INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.

    /* VARIAVEIS LOCAIS */
    DEF VAR hBusinessContent AS HANDLE NO-UNDO.
    DEF VAR lSuccessProcess  AS LOG    NO-UNDO.
    DEF VAR cValue           AS CHAR   NO-UNDO.
    DEF VAR cNodeName        AS CHAR   NO-UNDO.
    DEF VAR iIdList          AS INT    NO-UNDO.
    DEF VAR iIdLine          AS INT    NO-UNDO.
    DEF VAR iIdNext          AS INT    NO-UNDO.
    DEF VAR cTranEvent       AS CHAR   NO-UNDO.
    DEF VAR cTranVersion     AS CHAR   NO-UNDO.
    DEF VAR cErrorText       AS CHAR   NO-UNDO.
    DEF VAR iCount           AS INT    NO-UNDO.
    DEF VAR cListRootSon     AS CHAR   NO-UNDO.
    DEF VAR iContRootSon     AS INT    NO-UNDO.
    DEF VAR hGenXml          AS HANDLE NO-UNDO. 
    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO.
    DEF VAR cTranAction      AS CHAR   NO-UNDO.
    DEF VAR cCostCenter      AS CHAR   NO-UNDO.


    /* Definiá∆o de vari†veis*/
    DEFINE VARIABLE iItemId                         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iReferenceId                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iItemSerialInformationId        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iValuesId                       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iId                             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iQuantityId                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iScrapAccountId                 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iDocumentId                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iMaterialId                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iWarehouseId                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iMaterialIssueLocationId        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iReportsByProductionOrderId     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iListOfScrapProductionReportId  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iScrapItemId                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iScrapId                        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iRejectionId                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iOrderOperationId               AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iRouteId                        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iLocationId                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iParentItemId                   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iScrapTransactionId  AS INTEGER    NO-UNDO.



    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

    /* VERIFICA SE O MessageHandler FOI EXECUTADO CORRETAMENTE */
    /* Verifica se o MessageHandler foi executado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).


    /* FAZ A INTERPRETA∞ÄO E ALGUNS PROCESSOS NA MENSAGEM QUE RECEBE */
    RUN parseMessage IN hMessageHandler (INPUT  hInputXml,
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlMaxTranVersion}",
                                         INPUT "{&XmlMinTranVersion}",
                                         INPUT 
                                         &IF DEFINED(XmlListOfEvents) <> 0
                                         &THEN "{&XmlListOfEvents}",
                                         &ELSE "",
                                         &ENDIF
                                         OUTPUT lSuccessProcess,
                                         OUTPUT cTranAction,
                                         OUTPUT cTranEvent,
                                         OUTPUT cTranVersion,
                                         OUTPUT hOutputXML ).

    /* SE NÄO PROCESSOU CORRETAMENTE RETORNA ERRO */
    IF NOT lSuccessProcess OR
       RETURN-VALUE <> "OK" THEN DO:
       IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).
       END.
    END.
    ELSE DO:
        /* OBTEM A PARTE DA MENSAGEM QUE ESTµ ABAIXO DO ELEMENTO BusinessContent */
        RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).
        /* VERIFICA SE APIXML ESTA NA MEMORIA */
        {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}
        /* VERIFICA SE O ut-genxml FOI INICIADO CORRETAMENTE */
        IF  cReturnValue <> "OK":U THEN 
            IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
               DELETE OBJECT hBusinessContent NO-ERROR.
               RUN setError IN hMessageHandler (INPUT 0,
                                                INPUT "enviroment_error":U,
                                                INPUT cReturnValue).
            END.
        /* ****************** OBTEM OS VALORES DOS ELEMENTOS ABAIXO DO BusinessContent ****************** */
        /* LIMPA AS TEMP-TABLES INTERNAS DA API XML */
        RUN reset IN hGenXml.

        /* CARREGA A ESTRUTURA FILHA DE BusinessContent */
        RUN loadXml IN hGenXml (hBusinessContent).

        /* ELIMINA A MENSAGEM OBTIDA NO M‘TODO getBusinessContent */
        DELETE OBJECT hBusinessContent NO-ERROR.

        /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
        CREATE tt-rep-prod.
        ASSIGN tt-rep-prod.cod-versao-integracao = 003 /* versao da integraá∆o produto padr∆o */
               tt-rep-prod.l-emite-rel = no
               tt-rep-prod.rw-rep-prod = rowid(rep-prod)
               tt-rep-prod.time-out    = 30
               tt-rep-prod.tentativas  = 10
               tt-rep-prod.prog-seg    = "axrma001".


        /* Informaá‰es existentes na tag ProductionReporte */

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "ReportNumber":U, OUTPUT tt-rep-prod.nr-reporte).

        &if defined(bf_man_206b) &then  
            ASSIGN tt-rep-prod.nr-docto-integr = tt-rep-prod.nr-reporte.
        &else
            ASSIGN tt-rep-prod.dec-2 = tt-rep-prod.nr-reporte.
        &endif

        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ApplicationAccountNumber":U, OUTPUT tt-rep-prod.conta-aplicacao).
        RUN getSonDate IN hGenXml (INPUT 1, INPUT "ReportDate":U, OUTPUT tt-rep-prod.data).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ReportHour":U, OUTPUT tt-rep-prod.hora).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "UserId":U, OUTPUT tt-rep-prod.usuario).

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "ProductionReportType":U, OUTPUT tt-rep-prod.rep-prod).
        IF tt-rep-prod.rep-prod <> 1 AND
           tt-rep-prod.rep-prod <> 2 AND
           tt-rep-prod.rep-prod <> 3 AND
           tt-rep-prod.rep-prod <> 4 THEN
           ASSIGN tt-rep-prod.rep-prod = 4.


        /* Informaá‰es existentes na tag ProductionReporte */
        RUN searchTag IN hGenXml ("Item":U, 1, OUTPUT iItemId).               
        IF iItemId <> ? THEN DO:  
          /*  RUN getSonVal  IN hGenXml (INPUT iItemId, INPUT "ItemDescription":U, OUTPUT desc-item).*/
            RUN getSonVal  IN hGenXml (INPUT iItemId, INPUT "ItemCode":U, OUTPUT tt-rep-prod.it-codigo).     

           RUN searchTag IN hGenXml ("Reference":U, iItemId, OUTPUT iReferenceId).
           IF iReferenceId <> ? THEN 
              RUN getSonVal  IN hGenXml (INPUT iReferenceId, INPUT "ReferenceCode":U, OUTPUT tt-rep-prod.cod-refer).     

           RUN searchTag IN hGenXml ("ListOfItemSerialInformation":U, iItemId, OUTPUT iItemSerialInformationId).
           IF iItemSerialInformationId <> ? THEN DO:
              RUN getFirstSonId IN hGenXml (iItemSerialInformationId, OUTPUT iValuesId).
              ASSIGN iCount = 1.
              DO WHILE iValuesId <> ?:
                 CREATE tt-serie.
                 RUN getSonVal  IN hGenXml (INPUT iValuesId, INPUT "SerialNumber":U, OUTPUT tt-serie.nr-serie).
                 RUN getSonDec  IN hGenXml (INPUT iValuesId, INPUT "SerialSequenceNumber":U, OUTPUT tt-serie.sequencia).
                 IF  tt-serie.sequencia = ? THEN ASSIGN  tt-serie.sequencia = iCount.
                 RUN getSonLog  IN hGenXml (INPUT iValuesId, INPUT "IsScrapItemSerialNumber":U, OUTPUT tt-serie.refugo).
                 ASSIGN iId = iValuesId
                        iCount = iCount + 1.
                 RUN GetNextSonId IN hGenXml (iItemSerialInformationId, iId, OUTPUT iValuesId).
               END.
           END.
        END.

        /* Informaá‰es referente a Estabelecimento */
        RUN searchTag IN hGenXml ("Site":U, 1, OUTPUT iId).
        IF iId <> ? THEN
        RUN getSonVal IN hGenXml (INPUT iId, INPUT "SiteID":U, OUTPUT tt-rep-prod.cod-estabel).

       /* Informaá‰es referentes Ös Quantidades do Reporte de Produá∆o */  
       RUN searchTag IN hGenXml ("QuantityProductionReport":U, 1, OUTPUT iQuantityId).
       IF iQuantityId <> ? THEN DO:
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "QuantityOfReport":U, OUTPUT tt-rep-prod.qt-reporte).
          IF tt-rep-prod.qt-reporte = ? THEN ASSIGN tt-rep-prod.qt-reporte = 0.
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "QuantityOfScrap":U, OUTPUT tt-rep-prod.qt-refugo).
          IF tt-rep-prod.qt-refugo = ? THEN ASSIGN tt-rep-prod.qt-refugo = 0.
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "QuantityOfReserval":U, OUTPUT tt-rep-prod.qt-estorno).
          IF tt-rep-prod.qt-estorno = ? THEN ASSIGN tt-rep-prod.qt-estorno = 0.
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "QuantityApprovedConditionallyAndInvalidated":U, OUTPUT tt-rep-prod.qt-est-aprov).
          IF tt-rep-prod.qt-est-aprov = ? THEN ASSIGN tt-rep-prod.qt-est-aprov = 0.
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "QuantityOfInvalidatedScrap":U, OUTPUT tt-rep-prod.qt-est-refugo).
          IF tt-rep-prod.qt-est-refugo = ? THEN ASSIGN tt-rep-prod.qt-est-refugo = 0.
          RUN getSonDec  IN hGenXml (INPUT iQuantityId, INPUT "OrderQuantityApprovedConditionally":U, OUTPUT tt-rep-prod.qt-apr-cond).
          IF tt-rep-prod.qt-apr-cond = ? THEN ASSIGN tt-rep-prod.qt-apr-cond = 0.
       END.

       /* Informaá‰es referente as Contas de Refugo */
       RUN searchTag IN hGenXml ("ScrapAccount":U, 1, OUTPUT iScrapAccountId).  
       IF iScrapAccountId <> ? THEN DO:
          RUN getSonVal  IN hGenXml (INPUT iScrapAccountId, INPUT "AccountNumber":U, OUTPUT tt-rep-prod.ct-refugo). 
          RUN getSonVal  IN hGenXml (INPUT iScrapAccountId, INPUT "SubAccountNumber":U, OUTPUT tt-rep-prod.sc-refugo). 
          RUN getSonVal  IN hGenXml (INPUT iScrapAccountId, INPUT "ScrapAccountNumber":U, OUTPUT tt-rep-prod.conta-refugo). 
       END.


       /* Informaá‰es referente a Documentos */
       RUN searchTag IN hGenXml ("Document":U, 1, OUTPUT iDocumentId).  
       IF iDocumentId <> ? THEN DO:
          RUN getSonVal  IN hGenXml (INPUT iDocumentId, INPUT "DocumentNumber":U, OUTPUT tt-rep-prod.nro-docto). 
          RUN getSonVal  IN hGenXml (INPUT iDocumentId, INPUT "DocumentSeries":U, OUTPUT tt-rep-prod.serie-docto). 
       END.

       /* Informaá‰es referente a entrada de Materiais Acabados */
       RUN searchTag IN hGenXml ("MaterialEntranceLocation":U, 1, OUTPUT iMaterialId).  
       IF iMaterialId <> ? THEN DO:
          /* Informaá‰es referentes a dep¢sito de entrada */
          RUN searchTag IN hGenXml ("WareHouse":U, iMaterialId, OUTPUT iWarehouseId).    
          IF iWarehouseId <> ? THEN 
             RUN getSonVal  IN hGenXml (INPUT iWarehouseId, INPUT "WareHouseCode":U, OUTPUT tt-rep-prod.cod-depos). 

          /* Informaá‰es referente a Localizaá∆o */
          RUN searchTag IN hGenXml ("Location":U, iMaterialId, OUTPUT iLocationId).    
          IF iLocationId <> ? THEN 
             RUN getSonVal  IN hGenXml (INPUT iLocationId, INPUT "LocationCode":U, OUTPUT tt-rep-prod.cod-localiz). 

          RUN getSonDate IN hGenXml (INPUT iMaterialId, INPUT "LotValidityDate":U, OUTPUT tt-rep-prod.dt-vali-lote).
          RUN getSonVal  IN hGenXml (INPUT iMaterialId, INPUT "LotOrSerialNumber":U, OUTPUT tt-rep-prod.lote).
       END.

       /* Informaá‰es referente a sa°da de Materiais Acabados */
       RUN searchTag IN hGenXml ("MaterialIssueLocation":U, 1, OUTPUT iMaterialIssueLocationId).  
       IF iMaterialIssueLocationId <> ? THEN DO:
          /* Informaá‰es referentes a dep¢sito de sa°da */
          RUN searchTag IN hGenXml ("WareHouse":U, iMaterialIssueLocationId, OUTPUT iWarehouseId).    
          IF iWarehouseId <> ? THEN 
             RUN getSonVal  IN hGenXml (INPUT iWarehouseId, INPUT "WareHouseCode":U, OUTPUT tt-rep-prod.cod-depos-sai). 

          /* Informaá‰es referente a Localizaá∆o */
          RUN searchTag IN hGenXml ("Location":U, iMaterialIssueLocationId, OUTPUT iLocationId).    
          IF iLocationId <> ? THEN DO:
             RUN getSonVal  IN hGenXml (INPUT iLocationId, INPUT "LocationCode":U, OUTPUT tt-rep-prod.cod-local-sai). 
             RUN getSonLog  IN hGenXml (INPUT iLocationId, INPUT "IsComponentsExitLocalizationUnique":U, OUTPUT tt-rep-prod.loc-sai-unica).
          END.

       END.

       /*************** Informaá‰es referentes aos reportes da Ordem *******************/
       RUN searchTag IN hGenXml ("ListOfReportsByProductionOrder":U, 1, OUTPUT iReportsByProductionOrderId).
       IF iReportsByProductionOrderId <> ? THEN DO:
             RUN getFirstSonId IN hGenXml (iReportsByProductionOrderId, OUTPUT iScrapTransactionId).
             /* Lista que contÇm Ös raz‰es para o refugo dos itens, quando o reporte for de refugo ou aprovado condicionalmente. */
             RUN searchTag IN hGenXml ("ListOfScrapProductionReport":U, iScrapTransactionId, OUTPUT iListOfScrapProductionReportId).
             IF iListOfScrapProductionReportId <> ? THEN DO:
                RUN getFirstSonId IN hGenXml (iListOfScrapProductionReportId, OUTPUT iScrapId).
                DO WHILE iScrapId <> ?:
                   CREATE tt-ref-ordem.
                   RUN getSonDec  IN hGenXml (INPUT iScrapId, INPUT "ManufacturingOrderNumber":U, OUTPUT tt-ref-ordem.nr-ord-prod).
                   IF tt-ref-ordem.nr-ord-prod = ? THEN ASSIGN tt-ref-ordem.nr-ord-prod = 0.

                   RUN getSonDec  IN hGenXml (INPUT iScrapId, INPUT "OrderOperationSequenceNumber":U, OUTPUT tt-ref-ordem.op-seq).
                   IF tt-ref-ordem.op-seq = ? THEN ASSIGN tt-ref-ordem.op-seq = 0.

                   RUN getSonDec  IN hGenXml (INPUT iScrapId, INPUT "QuantityOfScrap":U, OUTPUT tt-ref-ordem.qt-refugo). 
                   IF tt-ref-ordem.qt-refugo = ? THEN ASSIGN tt-ref-ordem.qt-refugo = 0.

                   RUN getSonDate IN hGenXml (INPUT iScrapId, INPUT "ScrapDate":U, OUTPUT tt-ref-ordem.dt-refugo). 
                   RUN getSonVal  IN hGenXml (INPUT iScrapId, INPUT "Comments":U, OUTPUT tt-ref-ordem.observacao). 

                   /* Informaá‰es referente Ö Rejeiá∆o */
                   RUN searchTag  IN hGenXml ("Rejection":U, iScrapId, OUTPUT iRejectionId).
                   IF iRejectionId <> ? THEN DO:
                      RUN getSonDec  IN hGenXml (INPUT iRejectionId, INPUT "RejectionCode":U, OUTPUT tt-ref-ordem.codigo-rejei). 
                      IF tt-ref-ordem.codigo-rejei = ? THEN ASSIGN tt-ref-ordem.codigo-rejei = 0.
                      RUN getSonVal  IN hGenXml (INPUT iRejectionId, INPUT "RejectionDescription":U, OUTPUT tt-ref-ordem.descricao). 
                      RUN getSonDec  IN hGenXml (INPUT iRejectionId, INPUT "RejectionType":U, OUTPUT tt-ref-ordem.tipo-rejeicao).
                      IF tt-ref-ordem.tipo-rejeicao <> 1 AND 
                         tt-ref-ordem.tipo-rejeicao <> 2 THEN 
                         ASSIGN tt-ref-ordem.tipo-rejeicao = 1.
                   END.

                    ASSIGN iId = iScrapId.   
                    RUN GetNextSonId IN hGenXml (iListOfScrapProductionReportId, iId, OUTPUT iScrapId).
                 END.

               END. /* DO WHILE iScrapId <> ? */
       END. /*IF iReportsByProductionOrderId <> ? */
       /**** Busca o Centro de Custo ***/
       RUN getSonVal  IN hGenXml (INPUT 1, INPUT "CostCenterCode":U, OUTPUT cCostCenter).
       ASSIGN OVERLAY(tt-rep-prod.char-2,1,8) = SUBSTRING(cCostCenter,1,8).

  IF SEARCH("cpp/cpapi009.r":U) <> ? or
     SEARCH("cpp/cpapi009.p":U) <> ? THEN DO:

       /* Geracao do reporte */
       run cpp/cpapi009.p (input-output table tt-rep-prod,
                           input        table tt-serie,
                           input        table tt-ref-ordem,
                           input-output table tt-erro, 
                           output       table tt-relatorio,
                           input yes). 


       FOR EACH tt-erro:
           RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                            INPUT "business_error":U,  /* Erro de neg¢cio */
                                            INPUT tt-erro.mensagem).
       END.
  END.
  ELSE DO: /* Programa de efetivaá∆o n∆o localizado */
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cpp/cpapi009.p'_a_ser_executado_pelo_programa_adapters/xml/ma2/axrma001.p" *}
      RUN setError IN hMessageHandler (INPUT 0,
                                       INPUT "enviroment_error":U,
                                       INPUT RETURN-VALUE + '.').
  END.

  END.

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

