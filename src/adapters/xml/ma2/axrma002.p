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
{include/i-prgvrs.i AXRMA002 2.00.00.004}  /*** 010004 ***/


/*------------------------------------------------------------------------
    File        : axrma002.p
    Purpose     : Revebimento do Estorno de Reportes de Produáao
    Created     : 08/04/2004
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlProdName EMS2
&GLOBAL-DEFINE XmlProdVersion 2.04
&GLOBAL-DEFINE XmlApp MA2 
&GLOBAL-DEFINE XmlTranName ReportProductionReversal
&GLOBAL-DEFINE XmlMinTranVersion 000.000
&GLOBAL-DEFINE XmlMaxTranVersion 999.999
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
         HEIGHT             = 30.5
         WIDTH              = 58.86.
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
    DEFINE VARIABLE iLocationId                     AS INTEGER    NO-UNDO.

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
        ASSIGN tt-rep-prod.cod-versao-integracao = 001 /* versao da integracao produto padrao */
               tt-rep-prod.l-emite-rel = no
               tt-rep-prod.rw-rep-prod = rowid(rep-prod)
               tt-rep-prod.time-out    = 30
               tt-rep-prod.tentativas  = 10
               tt-rep-prod.prog-seg    = "axrma002".

        /* Informaá‰es existentes na tag ProductionReporte */
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "ReportNumber":U, OUTPUT tt-rep-prod.nr-reporte).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ApplicationAccountNumber":U, OUTPUT tt-rep-prod.cod-cta-unif).
		RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ApplicationSubAccountNumber":U, OUTPUT tt-rep-prod.cod-ccusto-unif).
        RUN getSonDate IN hGenXml (INPUT 1, INPUT "ReportDate":U, OUTPUT tt-rep-prod.data).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ReportHour":U, OUTPUT tt-rep-prod.hora).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "UserId":U, OUTPUT tt-rep-prod.usuario).
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "ProductionReportType":U, OUTPUT tt-rep-prod.rep-prod).

        /* Informaá‰es existentes na tag ProductionReporte */
        RUN searchTag IN hGenXml ("Item":U, 1, OUTPUT iItemId).               
        IF iItemId <> ? THEN DO:  
           RUN getSonVal  IN hGenXml (INPUT iItemId, INPUT "ItemCode":U, OUTPUT tt-rep-prod.it-codigo).     
           RUN searchTag IN hGenXml ("Reference":U, iItemId, OUTPUT iReferenceId).
           IF iReferenceId <> ? THEN 
              RUN getSonVal  IN hGenXml (INPUT iReferenceId, INPUT "ReferenceCode":U, OUTPUT tt-rep-prod.cod-refer).     
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

      IF SEARCH("cpp/cpapi011.p":U) <> ? or
         SEARCH("cpp/cpapi011.r":U) <> ?  THEN DO:

           /* Grava o numero do documento para que este seja buscado para realizaá∆o do estorno, pois a Proxima
              nao guarda o numero do Reporte - Feito para integracao Agroindustria */
           &if defined(bf_man_206b) &then  
               FIND FIRST rep-prod WHERE INT(rep-prod.nr-docto-integr) = tt-rep-prod.nr-reporte NO-LOCK NO-ERROR.
           &else
               FIND FIRST rep-prod WHERE INT(rep-prod.dec-2) = tt-rep-prod.nr-reporte NO-LOCK NO-ERROR.
           &endif
           
           IF AVAIL rep-prod THEN DO:
              ASSIGN tt-rep-prod.nr-reporte = rep-prod.nr-reporte.
              /* Realiza o estorno do reporte */
              run cpp/cpapi011.p ( input        table tt-rep-prod,
                                   input-output table tt-erro,    
                                   input        table tt-relatorio,
                                   input        YES ).       

               FOR EACH tt-erro:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Erro" *}
                   RUN setError IN hMessageHandler (INPUT 17006 ,
                                                    INPUT "business_error":U,  /* Erro de negocio */
                                                    INPUT tt-erro.mensagem + " (" + RETURN-VALUE + " " + STRING(tt-erro.cd-erro) + ")" ).
               END.
          END.   
      END.
      ELSE DO: /* Programa de efetivaá∆o n∆o localizado */
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cpp/cpapi011.p'_a_ser_executado_pelo_programa_adapters/xml/ma2/axrma002.p" *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE + '.').
      END.


  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF








