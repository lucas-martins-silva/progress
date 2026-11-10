/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMN009 2.00.00.004 } /*** 010004 ***/



/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXRMN003.p
    Purpose     : RECEBIMENTO ORDEM DE MANUTENÄ«O

    Syntax      :

    Description : ADAPTER DE RECEBIMENTO DE ORDENS DE MANUTENÄ«O
    Author(s)   : AndrÇ Lu°s Oliveira Pereira
    CREATED     : 11/2007
    Notes       :
----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */
/* PrÇ-Processadores*/
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlApp            MN2
&GLOBAL-DEFINE XmlMod            MIP
&GLOBAL-DEFINE XmlTranName       Ordem
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   add,upd,DEL


{cdp/cdcfgmnt.i}
{utp/ut-glob.i}

/* Variaveis para uso do xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* Variaveis para uso do xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}

/* Variavies locais */
DEF VAR l-erro        AS LOG           NO-UNDO.
DEF VAR hGenXml       AS HANDLE        NO-UNDO. 
DEF VAR cTranAction   AS CHAR          NO-UNDO.


/* Temp-table's */
{cdp/cd0666.i}   /* tt-erro                           */
{cdp/cd0666.i1}  /* pi-gera-temp-erro                 */
{mip/miapi004.i} /* tt-ord-manut-api / tt-msg-ord-man */
{mip/miapi012.i "tt-ord-taref"    "ord-taref"}
{mip/miapi012.i "tt-ord-esp"      "ord-esp"}
{mip/miapi012.i "tt-p-ord-esp"    "p-ord-esp"}
{mip/miapi012.i "tt-ord-ferr"     "ord-ferr"}
{mip/miapi012.i "tt-ord-turno"    "ord-turno"}
{mip/miapi012.i "tt-ord-epi"      "ord-epi"}
{mip/miapi012.i "tt-ord-fich-met" "ord-fich-met"}
/*{mip/miapi012.i "tt-reservas"     "reservas"}*/
define TEMP-TABLE tt-reservas NO-UNDO LIKE reservas.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

{xmlinc/xmlgettranssubsinfo.i} /* Procedure getTransSubsInfo  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: Recebe mensagem do ControlBroker, processa e entrega ao destino
  Parameters: pINPUTXml, pOUTPUTXml
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT  PARAM hINPUTXML  AS HANDLE           NO-UNDO.
 DEF OUTPUT PARAM hOUTPUTXML AS HANDLE           NO-UNDO.

 DEF VAR hMessageHandler     AS HANDLE           NO-UNDO.
 DEF VAR hBusinessContent    AS HANDLE           NO-UNDO.
 DEF VAR lSuccessProcess     AS LOG              NO-UNDO.
 DEF VAR iCount              AS INT              NO-UNDO.
 DEF VAR cReturnValue        AS CHAR             NO-UNDO.
 DEF VAR cTranEvent          AS CHAR             NO-UNDO.
 DEF VAR cTranVersion        AS CHAR             NO-UNDO.
 DEF VAR cErrorText          AS CHAR             NO-UNDO.

 DEF VAR c-hora         AS CHAR                  NO-UNDO.
 DEF VAR d-data         AS DATE                  NO-UNDO.
 DEF VAR i-tipo-evento  AS INT FORMAT 99         NO-UNDO.
 DEF VAR i-tipo-trans   AS INT FORMAT 99         NO-UNDO.
 DEF VAR i-cd-tarefa    LIKE ord-taref.cd-tarefa NO-UNDO.

 DEF VAR iCauseId                         AS INT NO-UNDO.
 &IF "{&mguni_version}" >= "2.071" &THEN
 DEF VAR iCompanyId                       LIKE empresa.ep-codigo.
 &ELSE
 DEF VAR iCompanyId                       AS INT NO-UNDO.
 &ENDIF
 DEF VAR iCostInformationOrderId          AS INT NO-UNDO.
 DEF VAR iDateInformationOrderId          AS INT NO-UNDO.
 DEF VAR iEquipmentId                     AS INT NO-UNDO.
 DEF VAR iEquipmentFamilyId               AS INT NO-UNDO.
 DEF VAR iFailInformationOrderId          AS INT NO-UNDO.
 DEF VAR iHoldoverId                      AS INT NO-UNDO.
 DEF VAR iInspectionInformationOrderId    AS INT NO-UNDO.
 DEF VAR iInspectionRoutingId             AS INT NO-UNDO.
 DEF VAR iInspectionId                    AS INT NO-UNDO.
 DEF VAR iIntervencionId                  AS INT NO-UNDO.
 DEF VAR iLubrificationInformationOrderId AS INT NO-UNDO.
 DEF VAR iDocumentInformationOrderId      AS INT NO-UNDO.
 DEF VAR iMaintenanceId                   AS INT NO-UNDO.
 DEF VAR iMaintenanceOrderFunctionId      AS INT NO-UNDO.
 DEF VAR iMaintOrderMessageInfoTypeId     AS INT NO-UNDO.
 DEF VAR iMaintenancePlannerId            AS INT NO-UNDO.
 DEF VAR iMainanceSpecialtyId             AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iOrderId                         AS INT NO-UNDO.
 DEF VAR iPlannerId                       AS INT NO-UNDO.
 DEF VAR iPlanningInformationOrderId      AS INT NO-UNDO.
 DEF VAR iProductionLineId                AS INT NO-UNDO.
 DEF VAR iProjectId                       AS INT NO-UNDO.
 DEF VAR iReportInformationOrderId        AS INT NO-UNDO.
 DEF VAR iStandardSymptomId               AS INT NO-UNDO.
 DEF VAR iStatusInformationOrderId        AS INT NO-UNDO.
 DEF VAR iStopPlanId                      AS INT NO-UNDO.
 DEF VAR iStopPlanInformationOrderId      AS INT NO-UNDO.
 DEF VAR iTagFunctionId                   AS INT NO-UNDO.
 DEF VAR iBusinessUnitId                  AS INT NO-UNDO.
 DEF VAR iTargetSiteId                    AS INT NO-UNDO.
 DEF VAR iTeamInChargeId                  AS INT NO-UNDO.
 DEF VAR iTechnnicalId                    AS INT NO-UNDO.
 DEF VAR iWarningId                       AS INT NO-UNDO.
 DEF VAR c-char-1-aux                     LIKE ord-manut.char-1 NO-UNDO.

/* Verfica se MessageHandler.p est† na mem¢ria */
 {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOUTPUTXML"}

 /* Verifica se o MessageHandler foi executado corretamente */
 IF  cReturnValue <> "OK":U then
  IF cReturnValue <> ? AND cReturnValue <> "":U then
     RUN setError IN hMessageHandler (INPUT 0,
                                      INPUT "enviroment_error":U,
                                      INPUT cReturnValue).
 
 /* Armazena e valida a mensagem */
 RUN parseMessage IN hMessageHandler (INPUT  hINPUTXml,
                                       INPUT "{&XmlTranName}":U,
                                       INPUT "{&XmlMaxTranVersion}":U,
                                       INPUT "{&XmlMinTranVersion}":U,
                                       input
                                       &IF DEFINED(XmlListOfEvents) <> 0
                                        &THEN "{&XmlListOfEvents}":U,
                                       &ELSE "":U,
                                       &ENDIF
                                       OUTPUT lSuccessProcess,
                                       OUTPUT cTranAction,
                                       OUTPUT cTranEvent,
                                       OUTPUT cTranVersion,
                                       OUTPUT hOUTPUTXML ).


 IF NOT lSuccessProcess THEN 
    RETURN "NOK":U.

 RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

 /* Verifica se APIXml est† na mem¢ria */
 {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOUTPUTXML"}


 /* Verifica se o ut-genxml foi iniciado corretamente */
 IF  cReturnValue <> "OK":U THEN 
  IF cReturnValue <> ? AND cReturnValue <> "":U THEN DO:
     DELETE OBJECT hBusinessContent NO-ERROR.
     RUN setError IN hMessageHandler (INPUT 0,
                                      INPUT "enviroment_error":U,
                                       INPUT cReturnValue).
  END.

 RUN reset   IN hGenXml.
 RUN loadXml IN hGenXml (hBusinessContent).


 DELETE OBJECT hBusinessContent    NO-ERROR.

 EMPTY TEMP-TABLE tt-ord-manut-api NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-esp       NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-epi       NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-ferr      NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-fich-met  NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-taref     NO-ERROR.
 EMPTY TEMP-TABLE tt-ord-turno     NO-ERROR.
 EMPTY TEMP-TABLE tt-reservas      NO-ERROR.
 EMPTY TEMP-TABLE tt-msg-ord-man   NO-ERROR.
 EMPTY TEMP-TABLE tt-p-ord-esp     NO-ERROR.
 EMPTY TEMP-TABLE tt-erro          NO-ERROR.

 FIND FIRST param-mi      NO-LOCK  NO-ERROR.
 FIND FIRST param-global  NO-LOCK  NO-ERROR.
 
 CREATE tt-ord-manut-api.

 ASSIGN tt-ord-manut-api.cod-versao-integracao = 001
        tt-ord-manut-api.ind-tipo-movto        = IF cTranAction = "ADD":U THEN 1
                                                 ELSE IF cTranAction = "UPD":U THEN 2
                                                 ELSE 3
        i-tipo-trans                           = tt-ord-manut-api.ind-tipo-movto
        i-tipo-evento                          = IF (i-tipo-trans = 1 OR i-tipo-trans = 3) THEN 0 ELSE 20.

    /* Order */
    /* RUN searchTag IN hGenXml ("Order":U, 1, OUTPUT iOrderId). */
        RUN getSonDec IN hGenXml (INPUT 1, INPUT "MaintenanceOrderNumber":U, OUTPUT tt-ord-manut-api.nr-ord-produ).
         IF tt-ord-manut-api.nr-ord-produ = ? THEN ASSIGN tt-ord-manut-api.nr-ord-produ = 1.

        RUN getSonVal IN hGenXml (INPUT 1, INPUT "DescriptionMaintenanceOrder":U, OUTPUT tt-ord-manut-api.des-man-corr).
         IF tt-ord-manut-api.des-man-corr = ? THEN ASSIGN tt-ord-manut-api.des-man-corr = "".

    /* MaintenancePlanner */
    RUN searchTag IN hGenXml ("MaintenancePlanner":U, 1, OUTPUT iMaintenancePlannerId).
        RUN getSonVal IN hGenXml (INPUT iMaintenancePlannerId, INPUT "PlannerCode":U, OUTPUT tt-ord-manut-api.cd-planejado).

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "PriorityOfMaintenanceOrder":U, OUTPUT tt-ord-manut-api.prioridade).
     IF tt-ord-manut-api.prioridade = ? THEN ASSIGN tt-ord-manut-api.prioridade = 1.

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "MaintenanceType":U, OUTPUT tt-ord-manut-api.tipo).
     IF  tt-ord-manut-api.tipo = ? OR tt-ord-manut-api.tipo < 1 OR tt-ord-manut-api.tipo > 10 then
        ASSIGN tt-ord-manut-api.tipo = 1. /* Sistem†tica - ininc/i01in434.i */

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "EquipmentStopTimeForTheOrder":U, OUTPUT tt-ord-manut-api.tempo-para).
     IF tt-ord-manut-api.tempo-para = ? THEN ASSIGN tt-ord-manut-api.tempo-para = 1. 

    /* TeamInCharge */
    RUN searchTag IN hGenXml ("TeamInCharge":U, 1, OUTPUT iTeamInChargeId).
        RUN getSonVal IN hGenXml (INPUT iTeamInChargeId, INPUT "TeamInChargeCode":U, OUTPUT tt-ord-manut-api.cd-equip-res).

    /* Technnical */
    RUN searchTag IN hGenXml ("Technnical":U, 1, OUTPUT iTechnnicalId).
        RUN getSonVal IN hGenXml (INPUT iTechnnicalId, INPUT "TechnnicalCode":U, OUTPUT tt-ord-manut-api.cd-tecnico).
        IF tt-ord-manut-api.cd-tecnico = ? THEN ASSIGN tt-ord-manut-api.cd-tecnico = "".

    /* Project */
    RUN searchTag IN hGenXml ("Project":U, 1, OUTPUT iProjectId).
        RUN getSonVal IN hGenXml (INPUT iProjectId, INPUT "ProjectCode":U, OUTPUT tt-ord-manut-api.cd-projeto).
        IF tt-ord-manut-api.cd-projeto = ? THEN ASSIGN tt-ord-manut-api.cd-projeto = "".

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "TypeOfOrderUrgency":U, OUTPUT tt-ord-manut-api.urgencia).
     IF tt-ord-manut-api.urgencia = ? OR tt-ord-manut-api.urgencia < 1 OR tt-ord-manut-api.urgencia > 3 THEN
        ASSIGN tt-ord-manut-api.urgencia = 3. /* N∆o Urgente - ininc/i02in434.i */

    /* Maintenance */
    RUN searchTag IN hGenXml ("Maintenance":U, 1, OUTPUT iMaintenanceId).
        RUN getSonDec IN hGenXml (INPUT iMaintenanceId, INPUT "MaintenanceType":U, OUTPUT tt-ord-manut-api.cd-tipo).

    /* TagFunction */
    RUN searchTag IN hGenXml ("TagFunction":U, 1, OUTPUT iTagFunctionId).
        RUN getSonVal IN hGenXml (INPUT iTagFunctionId, INPUT "FunctionalLocationTag":U, OUTPUT tt-ord-manut-api.cd-tag).

    /* BusinessUnit */
    &IF DEFINED(bf_mnt_ems206b) &THEN
        &IF DEFINED(bf_mnt_ems207) &THEN
            RUN searchTag IN hGenXml ("BusinessUnit":U, 1, OUTPUT iBusinessUnitId).
                RUN getSonVal IN hGenXml (INPUT iBusinessUnitId, INPUT "FunctionalLocationBusinessUnit":U, OUTPUT tt-ord-manut-api.cod-unid-negoc).
        &ELSEIF DEFINED(bf_mnt_ems206b) &THEN
            RUN searchTag IN hGenXml ("BusinessUnit":U, 1, OUTPUT iBusinessUnitId).
                RUN getSonVal IN hGenXml (INPUT iBusinessUnitId, INPUT "FunctionalLocationBusinessUnit":U, OUTPUT c-char-1-aux).
                ASSIGN OVERLAY(tt-ord-manut-api.char-1,19,3) = c-char-1-aux.
        &ENDIF
    &ENDIF

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "ProjectControlOrderNumber":U, OUTPUT tt-ord-manut-api.num-ord-inv).
    IF tt-ord-manut-api.num-ord-inv = ? THEN ASSIGN tt-ord-manut-api.num-ord-inv = 0.

    /* Company */
    RUN searchTag IN hGenXml ("Company":U, 1, OUTPUT iCompanyId).
        RUN getSonDec IN hGenXml (INPUT iCompanyId, INPUT "CompanyCode":U, OUTPUT tt-ord-manut-api.ep-codigo).

    /* Equipment */
    RUN searchTag IN hGenXml ("Equipment":U, 1, OUTPUT iEquipmentId).
        RUN getSonVal IN hGenXml (INPUT iEquipmentId, INPUT "EquipmentCode":U, OUTPUT tt-ord-manut-api.cd-equipto).

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "MaintenanceDuration":U, OUTPUT tt-ord-manut-api.dur-man).

    /* TargetSite */
    RUN searchTag IN hGenXml ("TargetSite":U, 1, OUTPUT iTargetSiteId).
        RUN getSonVal IN hGenXml (INPUT iTargetSiteId, INPUT "TargetSiteCode":U, OUTPUT tt-ord-manut-api.cod-estabel).

    RUN getSonVal IN hGenXml (INPUT 1, INPUT "UserLastAlterCode":U, OUTPUT tt-ord-manut-api.usuario-alt).
    RUN getSonDec IN hGenXml (INPUT 1, INPUT "SummarizedOrderNumber":U, OUTPUT tt-ord-manut-api.nr-ord-sum).
     IF tt-ord-manut-api.nr-ord-sum = ? THEN ASSIGN tt-ord-manut-api.nr-ord-sum = 0.

    /* ProductionLine */
    RUN searchTag IN hGenXml ("ProductionLine":U, 1, OUTPUT iProductionLineId).
        RUN getSonDec IN hGenXml (INPUT iProductionLineId, INPUT "ProductionLineOrderCode":U, OUTPUT tt-ord-manut-api.nr-linha).

    /* EquipmentFamily */
    RUN searchTag IN hGenXml ("EquipmentFamily":U, 1, OUTPUT iEquipmentFamilyId).
        RUN getSonVal IN hGenXml (INPUT iEquipmentFamilyId, INPUT "EquipmentFamilyCode":U, OUTPUT tt-ord-manut-api.fm-equipto).

    /* INFORMAÄÂES DA ORDEM DE MANUTENÄ«O AGRUPADAS POR FUNÄ«O */
    RUN searchTag IN hGenXml ("MaintenanceOrderFunction":U, 1, OUTPUT iMaintenanceOrderFunctionId).

        /* PlanningInformationOrder */
        RUN searchTag IN hGenXml ("PlanningInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iPlanningInformationOrderId).
            /* Planner */
            RUN searchTag IN hGenXml ("Planner":U, iPlanningInformationOrderId, OUTPUT iPlannerId).
            RUN getSonVal IN hGenXml (INPUT iPlannerId, INPUT "PlannerCode":U, OUTPUT tt-ord-manut-api.cd-manut).
                     
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "AccountantValue":U, OUTPUT tt-ord-manut-api.vl-contador).
             IF tt-ord-manut-api.vl-contador = ? THEN ASSIGN tt-ord-manut-api.vl-contador = 1.
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "AlocateFormOrder":U, OUTPUT tt-ord-manut-api.sit-aloc).
             IF tt-ord-manut-api.sit-aloc = ? THEN ASSIGN tt-ord-manut-api.sit-aloc = 1.
            
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "TaskReleaseType":U, OUTPUT tt-ord-manut-api.liber-tarefa).
    
            /* MainanceSpecialty */
            RUN searchTag IN hGenXml ("MainanceSpecialty":U, iPlanningInformationOrderId, OUTPUT iMainanceSpecialtyId).
                RUN getSonVal IN hGenXml (INPUT iMainanceSpecialtyId, INPUT "MainanceSpecialtyCode":U, OUTPUT tt-ord-manut-api.tp-esp-prin).
                IF tt-ord-manut-api.tp-esp-prin = ? THEN ASSIGN tt-ord-manut-api.tp-esp-prin = "".
               
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "SpecialityAllocationType":U, OUTPUT tt-ord-manut-api.forma-aloc-esp).
             IF tt-ord-manut-api.forma-aloc-esp <> 1 AND tt-ord-manut-api.forma-aloc-esp <> 2 THEN
                ASSIGN tt-ord-manut-api.forma-aloc-esp = 1. /* Backward - ininc/in16in122.i */
            RUN getSonLog IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "HasMarkedTask":U, OUTPUT tt-ord-manut-api.possui-taref-marc).
             IF tt-ord-manut-api.possui-taref-marc = ? THEN ASSIGN tt-ord-manut-api.possui-taref-marc = FALSE.
            RUN getSonDate IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "ReallocationDate":U, OUTPUT tt-ord-manut-api.dt-realoc).
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "AmtOfAccountAccumOfEquipment":U, OUTPUT tt-ord-manut-api.vl-cont-acum).
             IF tt-ord-manut-api.vl-cont-acum = ? THEN ASSIGN tt-ord-manut-api.vl-cont-acum = 1.
            RUN getSonDec IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "NumberOfLastSequenceOfTasks":U, OUTPUT tt-ord-manut-api.nr-ult-seq).
            RUN getSonVal IN hGenXml (INPUT iPlanningInformationOrderId, INPUT "PlanOriginatingScheduledOrder":U, OUTPUT tt-ord-manut-api.plano-orig).

        /* DateInformationOrder */
        RUN searchTag IN hGenXml ("DateInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iDateInformationOrderId).
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "MaintenanceDate":U, OUTPUT tt-ord-manut-api.dt-manut).
         IF tt-ord-manut-api.dt-manut = ? THEN ASSIGN tt-ord-manut-api.dt-manut = TODAY.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "EndDateOrder":U, OUTPUT tt-ord-manut-api.dt-fecham).
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "EndForecastDate":U, OUTPUT tt-ord-manut-api.dt-prev).
         IF tt-ord-manut-api.dt-prev = ? THEN ASSIGN tt-ord-manut-api.dt-prev = tt-ord-manut-api.dt-manut /*01/01/0001 - AldÇrico*/.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "EarliestStartDate":U, OUTPUT tt-ord-manut-api.dt-ini-cedo).
         IF tt-ord-manut-api.dt-ini-cedo = ? THEN ASSIGN tt-ord-manut-api.dt-ini-cedo = tt-ord-manut-api.dt-manut /*01/01/0001 - AldÇrico*/.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "LatestStartDate":U, OUTPUT tt-ord-manut-api.dt-ini-tarde).
         IF tt-ord-manut-api.dt-ini-tarde = ? THEN ASSIGN tt-ord-manut-api.dt-ini-tarde = tt-ord-manut-api.dt-manut /*01/01/0001 - AldÇrico*/.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "OriginalStartDate":U, OUTPUT tt-ord-manut-api.dt-ini-orig).
         IF tt-ord-manut-api.dt-ini-orig = ? THEN ASSIGN tt-ord-manut-api.dt-ini-orig = TODAY.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "OrderReopeningDate":U, OUTPUT tt-ord-manut-api.dt-reabre).
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "ExpectativeMaintenanceDate":U, OUTPUT tt-ord-manut-api.dt-prev-manut).
         IF tt-ord-manut-api.dt-prev-manut = ? THEN ASSIGN tt-ord-manut-api.dt-prev-manut = TODAY.
        RUN getSonDate IN hGenXml (INPUT iDateInformationOrderId, INPUT "CreateDateMaintenanceOrder":U, OUTPUT d-data).
        RUN getSonVal  IN hGenXml (INPUT iDateInformationOrderId, INPUT "CreateTimeMaintenanceOrder":U, OUTPUT c-hora).
         IF SUBSTR(param-mi.char-2,1,3) = 'YES':U THEN  /* Altera Data Manutená∆o - mi0101 */
            ASSIGN SUBSTR(tt-ord-manut-api.char-1,1,10) = string(d-data).
         IF SUBSTR(param-mi.char-2,4,3) = 'YES':U THEN  /* Altera Hora Manutená∆o - mi0101 */
            ASSIGN SUBSTR(tt-ord-manut-api.char-1,11,6) = c-hora.

        /* StatusInformationOrder */
        RUN searchTag IN hGenXml ("StatusInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iStatusInformationOrderId).
            RUN getSonLog IN hGenXml (INPUT iStatusInformationOrderId, INPUT "IsClosedOrderMaintenance":U, OUTPUT tt-ord-manut-api.om-encerrada).
             IF tt-ord-manut-api.om-encerrada = ? THEN ASSIGN tt-ord-manut-api.om-encerrada = FALSE.
            RUN getSonDec IN hGenXml (INPUT iStatusInformationOrderId, INPUT "SummarizedMaintenanceOrderState":U, OUTPUT tt-ord-manut-api.estado-om).
             IF tt-ord-manut-api.estado-om = ? OR tt-ord-manut-api.estado-om < 1 OR tt-ord-manut-api.estado-om > 4 THEN 
                ASSIGN tt-ord-manut-api.estado-om = 1. /* N∆o Iniciada - ininc/i01in270.i */
            RUN getSonDec IN hGenXml (INPUT iStatusInformationOrderId, INPUT "MaintenanceOrderState":U, OUTPUT tt-ord-manut-api.estado). /* ininc/i01in271.i */
             IF tt-ord-manut-api.estado = 4 THEN DO:  /* Status 4 foi substitu°do pela concatenaá∆o entre os campos ESTADO-OM e ESTADO */
                IF tt-ord-manut-api.estado-om = 1 THEN
                   IF tt-ord-manut-api.estado < 1 OR tt-ord-manut-api.estado > 3 THEN
                      ASSIGN tt-ord-manut-api.estado = 0. 
                IF tt-ord-manut-api.estado-om = 2 THEN 
                   IF tt-ord-manut-api.estado <> 5 AND tt-ord-manut-api.estado <> 6 THEN
                      ASSIGN tt-ord-manut-api.estado = 0. 
                IF tt-ord-manut-api.estado-om = 3 THEN 
                   IF tt-ord-manut-api.estado < 1 OR tt-ord-manut-api.estado > 8 THEN
                      ASSIGN tt-ord-manut-api.estado = 0. 
                IF tt-ord-manut-api.estado-om = 4 THEN 
                   IF tt-ord-manut-api.estado <> 7 AND tt-ord-manut-api.estado <> 8 THEN
                      ASSIGN tt-ord-manut-api.estado = 0.
             END.
             ELSE IF tt-ord-manut-api.estado = ? OR tt-ord-manut-api.estado < 1 OR tt-ord-manut-api.estado > 8 THEN
                  ASSIGN tt-ord-manut-api.estado = 0.

        /* StopPlanInformationOrder */
        RUN searchTag IN hGenXml ("StopPlanInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iStopPlanInformationOrderId).
            RUN getSonDec IN hGenXml (INPUT iStopPlanInformationOrderId, INPUT "StopPlanSequence":U, OUTPUT tt-ord-manut-api.sequencia).
            IF tt-ord-manut-api.sequencia = ? THEN ASSIGN tt-ord-manut-api.sequencia = 0.
            
            /* StopPlan */
            RUN searchTag IN hGenXml ("StopPlan":U, iStopPlanInformationOrderId, OUTPUT iStopPlanId).
            RUN getSonVal IN hGenXml (INPUT iStopPlanId, INPUT "StopPlanCode":U, OUTPUT tt-ord-manut-api.cd-parada).
            IF tt-ord-manut-api.cd-parada = ? THEN ASSIGN tt-ord-manut-api.cd-parada = "".

        /* FailInformationOrder */
        RUN searchTag IN hGenXml ("FailInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iFailInformationOrderId).
            /* Cause */
            RUN searchTag IN hGenXml ("Cause":U, iFailInformationOrderId, OUTPUT iCauseId).
                RUN getSonVal IN hGenXml (INPUT iCauseId, INPUT "CauseCode":U, OUTPUT tt-ord-manut-api.cd-causa-padr).
                IF tt-ord-manut-api.cd-causa-padr = ? THEN ASSIGN tt-ord-manut-api.cd-causa-padr = "".
                
            /* StandardSymptom */
            RUN searchTag IN hGenXml ("StandardSymptom":U, iFailInformationOrderId, OUTPUT iStandardSymptomId).
                RUN getSonVal IN hGenXml (INPUT iStandardSymptomId, INPUT "StandardSymptomCode":U, OUTPUT tt-ord-manut-api.cd-sint-padr).
                IF tt-ord-manut-api.cd-sint-padr = ? THEN ASSIGN tt-ord-manut-api.cd-sint-padr = "".

            /* Intervencion */
            RUN searchTag IN hGenXml ("Intervencion":U, iFailInformationOrderId, OUTPUT iIntervencionId).
                RUN getSonVal IN hGenXml (INPUT iIntervencionId, INPUT "IntervencionCode":U, OUTPUT tt-ord-manut-api.cd-interv-padr).
                IF tt-ord-manut-api.cd-interv-padr = ? THEN ASSIGN tt-ord-manut-api.cd-interv-padr = "".

            /* Holdover */
            RUN searchTag IN hGenXml ("Holdover":U, iFailInformationOrderId, OUTPUT iHoldoverId).
                RUN getSonVal IN hGenXml (INPUT iHoldoverId, INPUT "HoldoverCode":U, OUTPUT tt-ord-manut-api.cd-pend-padr).
                IF tt-ord-manut-api.cd-pend-padr = ? THEN ASSIGN tt-ord-manut-api.cd-pend-padr = "".
                  
        /* InspectionInformationOrder */
        RUN searchTag IN hGenXml ("InspectionInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iInspectionInformationOrderId).
            RUN getSonDec IN hGenXml (INPUT iInspectionInformationOrderId, INPUT "ReadingValue":U, OUTPUT tt-ord-manut-api.vl-leitura).
             IF tt-ord-manut-api.vl-leitura = ? THEN ASSIGN tt-ord-manut-api.vl-leitura = 1.
            RUN getSonDate IN hGenXml (INPUT iInspectionInformationOrderId, INPUT "ReadingDate":U, OUTPUT tt-ord-manut-api.dt-leitura).
             IF tt-ord-manut-api.dt-leitura = ? THEN ASSIGN tt-ord-manut-api.dt-leitura = TODAY.
 
            /* Warning */
            RUN searchTag IN hGenXml ("Warning":U, iInspectionInformationOrderId, OUTPUT iWarningId).
                RUN getSonVal IN hGenXml (INPUT iWarningId, INPUT "WarningCode":U, OUTPUT tt-ord-manut-api.al-codigo).
                IF tt-ord-manut-api.al-codigo = ? THEN ASSIGN tt-ord-manut-api.al-codigo = "".
                
            /* InspectionRouting */
            RUN searchTag IN hGenXml ("InspectionRouting":U, iInspectionInformationOrderId, OUTPUT iInspectionRoutingId).
                RUN getSonDec IN hGenXml (INPUT iInspectionRoutingId, INPUT "InspectionRoutingNumber":U, OUTPUT tt-ord-manut-api.nr-rot-insp).
                IF tt-ord-manut-api.nr-rot-insp = ? THEN ASSIGN tt-ord-manut-api.nr-rot-insp = 0.
                
            /* Inspection */
            RUN searchTag IN hGenXml ("Inspection":U, iInspectionInformationOrderId, OUTPUT iInspectionId).
                RUN getSonVal IN hGenXml (INPUT iInspectionId, INPUT "InspectionCode":U, OUTPUT tt-ord-manut-api.cd-inspecao).
                IF tt-ord-manut-api.cd-inspecao = ? THEN ASSIGN tt-ord-manut-api.cd-inspecao = "".

            RUN getSonLog IN hGenXml (INPUT iInspectionInformationOrderId, INPUT "IsReadingLog":U, OUTPUT tt-ord-manut-api.apont-lei).
             IF tt-ord-manut-api.apont-lei = ? THEN ASSIGN tt-ord-manut-api.apont-lei = FALSE.

        /* LubrificationInformationOrder */
        RUN searchTag IN hGenXml ("LubrificationInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iLubrificationInformationOrderId).
            RUN getSonDec IN hGenXml (INPUT iLubrificationInformationOrderId, INPUT "LubricationRoutingNumber":U, OUTPUT tt-ord-manut-api.nr-rot-lubr).
            IF tt-ord-manut-api.nr-rot-lubr = ? THEN ASSIGN tt-ord-manut-api.nr-rot-lubr = 0.
        
        /* DocumentInformationOrder */
        RUN searchTag IN hGenXml ("DocumentInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iDocumentInformationOrderId).
            RUN getSonVal IN hGenXml (INPUT iDocumentInformationOrderId, INPUT "AttachmentDocumentCode":U, OUTPUT tt-ord-manut-api.cod-docto-anexo).

        /* CostInformationOrder */
        RUN searchTag IN hGenXml ("CostInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iCostInformationOrderId).
            RUN getSonVal IN hGenXml (INPUT iCostInformationOrderId, INPUT "OrderAccount":U, OUTPUT tt-ord-manut-api.ct-codigo).
             IF tt-ord-manut-api.ct-codigo = ? THEN ASSIGN tt-ord-manut-api.ct-codigo = "".
            RUN getSonVal IN hGenXml (INPUT iCostInformationOrderId, INPUT "OrderSub-Account":U, OUTPUT tt-ord-manut-api.sc-codigo).
             IF tt-ord-manut-api.sc-codigo = ? THEN ASSIGN tt-ord-manut-api.sc-codigo = "".
            RUN getSonVal IN hGenXml (INPUT iCostInformationOrderId, INPUT "ExpenseOrderAccount":U, OUTPUT tt-ord-manut-api.ct-desp).
             IF tt-ord-manut-api.ct-desp = ? THEN ASSIGN tt-ord-manut-api.ct-desp = "".
            RUN getSonVal IN hGenXml (INPUT iCostInformationOrderId, INPUT "ExpenseOrderSub-Account":U, OUTPUT tt-ord-manut-api.sc-desp).
             IF tt-ord-manut-api.sc-desp = ? THEN ASSIGN tt-ord-manut-api.sc-desp = "".
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "ReportLabor":U, OUTPUT tt-ord-manut-api.reporte-mob).
             IF tt-ord-manut-api.reporte-mob <> 1 AND tt-ord-manut-api.reporte-mob <> 2 THEN 
                ASSIGN tt-ord-manut-api.reporte-mob = 1. /* Real - ininc/i06in172.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "ReportOverHead":U, OUTPUT tt-ord-manut-api.reporte-ggf).
             IF tt-ord-manut-api.reporte-ggf <> 1 AND tt-ord-manut-api.reporte-ggf <> 2 THEN 
                ASSIGN tt-ord-manut-api.reporte-ggf = 1. /* Real - ininc/i06in172.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "MaterialCostCalculationType":U, OUTPUT tt-ord-manut-api.calc-cs-mat).
             IF tt-ord-manut-api.calc-cs-mat <> 1 AND tt-ord-manut-api.calc-cs-mat <> 2 THEN 
                ASSIGN tt-ord-manut-api.calc-cs-mat = 1. /* Proporcional a Requisiá∆o - ininc/i02in271.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "LaborCostCalculationProportionType":U, OUTPUT tt-ord-manut-api.calc-cs-mob).
             IF tt-ord-manut-api.calc-cs-mat <> 1 AND tt-ord-manut-api.calc-cs-mob <> 2 THEN 
                ASSIGN tt-ord-manut-api.calc-cs-mob = 1. /* Proporcional - ininc/i02in284.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "OverHeadCostCalculationProportionType":U, OUTPUT tt-ord-manut-api.calc-cs-ggf).
             IF tt-ord-manut-api.calc-cs-ggf <> 1 AND tt-ord-manut-api.calc-cs-ggf <> 2 THEN 
                ASSIGN tt-ord-manut-api.calc-cs-ggf = 1. /* Proporcional - ininc/i02in284.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "MaterialDisbursemntCalculationType":U, OUTPUT tt-ord-manut-api.custeio-prop-mat).
             IF  tt-ord-manut-api.custeio-prop-mat = ? OR tt-ord-manut-api.custeio-prop-mat < 1 OR tt-ord-manut-api.custeio-prop-mat > 3 THEN 
                ASSIGN tt-ord-manut-api.custeio-prop-mat = 1. /* Proporcional Qtd da Ordem - ininc/i03in271.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "LaborDisbursemntCalculationType":U, OUTPUT tt-ord-manut-api.custeio-prop-mob).
             IF tt-ord-manut-api.custeio-prop-mob = ? OR tt-ord-manut-api.custeio-prop-mob < 1 OR tt-ord-manut-api.custeio-prop-mob > 3 THEN 
                ASSIGN tt-ord-manut-api.custeio-prop-mob = 1. /* Proporcional Qtd da Ordem - ininc/i04in271.i */
            RUN getSonDec IN hGenXml (INPUT iCostInformationOrderId, INPUT "OverHeadDisbursemntCalculationType":U, OUTPUT tt-ord-manut-api.custeio-prop-ggf).
             IF tt-ord-manut-api.custeio-prop-ggf = ? OR tt-ord-manut-api.custeio-prop-ggf < 1 OR tt-ord-manut-api.custeio-prop-ggf > 3 THEN 
                ASSIGN tt-ord-manut-api.custeio-prop-ggf = 1. /* Proporcional Qtd da Ordem - ininc/i03in271.i */
            RUN getSonLog IN hGenXml (INPUT iCostInformationOrderId, INPUT "IsValuedOrder":U, OUTPUT tt-ord-manut-api.valorizada).
             IF tt-ord-manut-api.valorizada = ? THEN ASSIGN tt-ord-manut-api.valorizada = FALSE. 

        /* ReportInformationOrder */
        RUN searchTag IN hGenXml ("ReportInformationOrder":U, iMaintenanceOrderFunctionId, OUTPUT iReportInformationOrderId).
            RUN getSonLog IN hGenXml (INPUT iReportInformationOrderId, INPUT "IsPrintRequisition":U, OUTPUT tt-ord-manut-api.emite-requis).
            RUN getSonLog IN hGenXml (INPUT iReportInformationOrderId, INPUT "IsPrintOrder":U, OUTPUT tt-ord-manut-api.emite-ordem).


    /* INFORMAÄÂES REFERENTES ∑ NARRATIVA DA ORDEM DE MANUTENÄ«O */
    CREATE tt-msg-ord-man. 
    ASSIGN tt-msg-ord-man.nr-ord-produ = tt-ord-manut-api.nr-ord-produ. 

    RUN searchTag IN hGenXml ("MaintenanceOrderMessageInformationType":U, 1, OUTPUT iMaintOrderMessageInfoTypeId).
        RUN getSonVal IN hGenXml (INPUT iMaintOrderMessageInfoTypeId, INPUT "MaintenanceOrderText":U, OUTPUT tt-msg-ord-man.msg-exp).
         IF tt-msg-ord-man.msg-exp = ? THEN ASSIGN tt-msg-ord-man.msg-exp = "".

    RUN pi-cria-ord-taref.    /** TAREFA **/

    RUN pi-cria-ord-epi.      /** EQUIPAMENTO DE PROTEÄ«O INDIVIDUAL **/

    RUN pi-cria-ord-esp.      /** ESPECIALIDADE **/

    RUN pi-cria-ord-ferr.     /** FERRAMENTA  **/

    RUN pi-cria-ord-fich-met. /** FICHA DE MêTODO **/

    RUN pi-cria-ord-turno.    /** TURNO **/

    RUN pi-cria-p-ord-esp.    /** RED PERT **/

    RUN pi-cria-reservas.     /** RESERVA **/

    IF RETURN-VALUE = "NOK":U
       OR /* verifica se retornou erro ou a tempteble tem registros */
       CAN-FIND (FIRST tt-erro) THEN DO:

       FOR EACH tt-erro no-lock:
            RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                             INPUT "business_error":U,  /* Erro na criaá∆o das temp-table's */
                                             INPUT tt-erro.mensagem).
       END.

    END.
    ELSE DO: /* Executa API de efetivaá∆o */
      IF SEARCH("mip/miapi012.r":U) <> ? or SEARCH("mip/miapi012.p":U) <> ? THEN DO:

         RUN mip/miapi012.p (INPUT-OUTPUT TABLE tt-ord-manut-api,
                             INPUT-OUTPUT TABLE tt-msg-ord-man,
                             INPUT-OUTPUT TABLE tt-ord-taref,
                             INPUT-OUTPUT TABLE tt-ord-ferr,
                             INPUT-OUTPUT TABLE tt-ord-esp,
                             INPUT-OUTPUT TABLE tt-ord-epi,
                             INPUT-OUTPUT TABLE tt-p-ord-esp,
                             INPUT-OUTPUT TABLE tt-ord-turno,
                             INPUT-OUTPUT TABLE tt-ord-fich-met,
                             INPUT-OUTPUT TABLE tt-reservas,
                             INPUT-OUTPUT TABLE tt-erro,
                             INPUT-OUTPUT i-tipo-trans, /** 1- inclusao, 2 - alteracao, 3 - eliminacao **/
                             INPUT-OUTPUT i-tipo-evento) NO-ERROR.


         IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
              DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                 cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
              END.
              {utp/ut-liter.i Erro_de_integraá∆o_ao_executar_API_de_Implantaá∆o_da_Ordem_de_Manutená∆o_'mip/miapi012.p'_pelo_adapters/xml/mn2/axrmn009.p._Durante_sua_execuá∆o_ocorreu_o(s)_erro(s)_Progress:  *}           
              RUN setError IN hMessageHandler (INPUT 0,
                                               INPUT "enviroment_error":U,
                                               INPUT RETURN-VALUE + cErrorText).
         END.

         FOR EACH tt-erro: /* Erros ocorridos durante efetivaá∆o do registro */
              RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                               INPUT "business_error":U,
                                               INPUT tt-erro.mensagem).
         END.
      END.    /* mip/miapi012.r */
      ELSE DO:
          /* Programa de efetivaá∆o n∆o localizado */
          {utp/ut-liter.i Erro_de_integraá∆o_pois_n∆o_foi_poss°vel_localizar_mip/miapi012.p  *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE).
      END.
    END.

    /* ObtÇm mensagem de retorno (erro ou confirmaá∆o) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML).

END PROCEDURE.


PROCEDURE pi-cria-ord-taref: /* INFORMAÄÂES REFERENTES ∑S TAREFAS DA ORDEM DE MANUTENÄ«O */


 DEF VAR i-cd-tarefa LIKE ord-taref.cd-tarefa    NO-UNDO.

 DEF VAR iAcceptInformationTaskId         AS INT NO-UNDO.
 DEF VAR iBasicInformationTaskId          AS INT NO-UNDO.
 DEF VAR iCalendarProductionId            AS INT NO-UNDO.
 DEF VAR iCalibrationInformationTaskId    AS INT NO-UNDO.
 DEF VAR iDocumentsInformationTaskId      AS INT NO-UNDO.
 DEF VAR iListOfTaskMOId                  AS INT NO-UNDO.
 DEF VAR iLubrificationInformationTaskId  AS INT NO-UNDO.
 DEF VAR iNextTaskMOTypeId                AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iPlanningInformationTaskId       AS INT NO-UNDO.
 DEF VAR iSummarizedOrderTaskId           AS INT NO-UNDO.
 DEF VAR iTaskMOTypeId                    AS INT NO-UNDO.

    RUN searchTag IN hGenXml ("ListOfTaskOfMaintenanceOrder":U, 1, OUTPUT iListOfTaskMOId).
     IF iListOfTaskMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfTaskMOId, OUTPUT iTaskMOTypeId).
         DO WHILE iTaskMOTypeId <> ? :

            /** BasicInformationTask **/
            RUN searchTag IN hGenXml ("BasicInformationTask":U, iTaskMOTypeId, OUTPUT iBasicInformationTaskId).

            /** MaintenanceTask **/
            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "MaintenanceTask":U, OUTPUT i-cd-tarefa).

            IF CAN-FIND (FIRST tt-ord-taref where
                               tt-ord-taref.nr-ord-produ = tt-ord-manut-api.nr-ord-produ  AND
                               tt-ord-taref.cd-tarefa    = i-cd-tarefa) THEN DO:

                {utp/ut-liter.i Tarefa *}
                run pi-gera-tt-erro (input 7,
                                     input RETURN-VALUE).
                RETURN "NOK":U.
            END.

            CREATE tt-ord-taref.
            ASSIGN tt-ord-taref.nr-ord-produ = tt-ord-manut-api.nr-ord-produ
                   tt-ord-taref.cd-tarefa    = i-cd-tarefa.

            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "TotalTimeForTaskExecutionInHours":U, OUTPUT tt-ord-taref.tempo).

            /* ademar e Roberto - faltou a busca da descriá∆o */
            RUN getSonVal IN hGenXml (INPUT iBasicInformationTaskId, INPUT "DescriptionTask":U, OUTPUT tt-ord-taref.descricao).
            IF tt-ord-taref.descricao = ? THEN ASSIGN tt-ord-taref.descricao = "".

            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "RealTimeUsedOnTask":U, OUTPUT tt-ord-taref.tempo-real).
            RUN getSonVal IN hGenXml (INPUT iBasicInformationTaskId, INPUT "TextTaskOrder":U, OUTPUT tt-ord-taref.narrativa).
             IF tt-ord-taref.narrativa = ? THEN ASSIGN tt-ord-taref.narrativa = "".
            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "CrewNecessaryForThisMaintenance":U, OUTPUT tt-ord-taref.nr-homem).
             IF tt-ord-taref.nr-homem = ? THEN ASSIGN tt-ord-taref.nr-homem = 0.
            RUN getSonLog IN hGenXml (INPUT iBasicInformationTaskId, INPUT "IsTaskClosed":U, OUTPUT tt-ord-taref.encerrada).
             IF tt-ord-taref.encerrada = ? THEN ASSIGN tt-ord-taref.encerrada = FALSE.

            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "StandardMaintenanceTaskCode":U, OUTPUT tt-ord-taref.cd-taref-padr). 

            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "SequenceTask":U, OUTPUT tt-ord-taref.cd-taref-padr).
            RUN getSonDec IN hGenXml (INPUT iBasicInformationTaskId, INPUT "TaskState":U, OUTPUT tt-ord-taref.estado-taref).
             IF tt-ord-taref.estado-taref = ? OR tt-ord-taref.estado-taref < 1 OR tt-ord-taref.estado-taref > 5 THEN
                ASSIGN tt-ord-taref.estado-taref = 1 . /* N∆o iniciada - ininc~\i01in136.i) */
            RUN getSonLog IN hGenXml (INPUT iBasicInformationTaskId, INPUT "IsMandatoryTask":U, OUTPUT tt-ord-taref.tar-obrigatoria).
             IF tt-ord-taref.tar-obrigatoria = ? THEN ASSIGN tt-ord-taref.tar-obrigatoria = TRUE.

            IF AVAIL param-global AND
                &IF DEFINED (bf_mnt_ems205) &THEN
                  param-global.log-modul-calib = NO
                &ELSE
                  substr(param-global.char-2,100,1) <> "2"
                &ENDIF
             THEN DO:
                /* CalibrationInformationTask */
                RUN searchTag IN hGenXml ("CalibrationInformationTask":U, iTaskMOTypeId, OUTPUT iCalibrationInformationTaskId).
                    RUN getSonVal IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "VariableChecked":U, OUTPUT tt-ord-taref.var-afer).
                    RUN getSonLog IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "IsEnterGaugingStandard":U, OUTPUT tt-ord-taref.inf-padrao).
                     IF tt-ord-taref.inf-padrao = ? THEN ASSIGN tt-ord-taref.inf-padrao = FALSE.
                    RUN getSonDec IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "StandardAmount":U, OUTPUT tt-ord-taref.vl-padrao).
                    RUN getSonDec IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "VariableType":U, OUTPUT tt-ord-taref.tp-variavel).
                     IF tt-ord-taref.tp-variavel <> 1 AND tt-ord-taref.tp-variavel <> 2 THEN ASSIGN tt-ord-taref.tp-variavel = 1. /* Percentual -  mninc~\i01in273.i */
                    RUN getSonDec IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "LowerVariance":U, OUTPUT tt-ord-taref.var-menor).
                    RUN getSonDec IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "GreaterVariance":U, OUTPUT tt-ord-taref.var-maior).

                    /* UnitOfMeasure */
                    RUN getSonVal IN hGenXml (INPUT iCalibrationInformationTaskId, INPUT "UnitOfMeasureCode":U, OUTPUT tt-ord-taref.un-medida).
             END. /* CalibrationInformationTask  */

            /* LubrificationInformationTask */
            RUN searchTag IN hGenXml ("LubrificationInformationTask":U, iTaskMOTypeId, OUTPUT iLubrificationInformationTaskId).
                RUN getSonDec IN hGenXml (INPUT iLubrificationInformationTaskId, INPUT "NumberOfLubricationPoint":U, OUTPUT tt-ord-taref.nr-pontos).
                RUN getSonDec IN hGenXml (INPUT iLubrificationInformationTaskId, INPUT "MaintenanceTaskTracing":U, OUTPUT tt-ord-taref.local-taref).
                 IF tt-ord-taref.local-taref = ? OR tt-ord-taref.local-taref < 1 OR tt-ord-taref.local-taref > 3 THEN
                    ASSIGN tt-ord-taref.local-taref = 1. /* Durante a Manutená∆o - ininc/i01in215.i */

            /* AcceptInformationTask */
            RUN searchTag IN hGenXml ("AcceptInformationTask":U, iTaskMOTypeId, OUTPUT iAcceptInformationTaskId).
                RUN getSonLog IN hGenXml (INPUT iAcceptInformationTaskId, INPUT "IsTaskAccepted":U, OUTPUT tt-ord-taref.aceite).
                 IF tt-ord-taref.aceite = ? THEN ASSIGN tt-ord-taref.aceite = FALSE.
                RUN getSonLog IN hGenXml (INPUT iAcceptInformationTaskId, INPUT "IsTaskAlreadyAccepted":U, OUTPUT tt-ord-taref.sit-aceite).
                 IF tt-ord-taref.sit-aceite = ? THEN ASSIGN tt-ord-taref.sit-aceite = FALSE.
                RUN getSonVal IN hGenXml (INPUT iAcceptInformationTaskId, INPUT "AcceptanceNotes":U, OUTPUT tt-ord-taref.obs-aceite).
                RUN getSonVal IN hGenXml (INPUT iAcceptInformationTaskId, INPUT "ResponsibleAcceptCode":U, OUTPUT tt-ord-taref.nome-abrev). 

           /* DocumentsInformationTask */
            RUN searchTag IN hGenXml ("DocumentsInformationTask":U, iTaskMOTypeId, OUTPUT iDocumentsInformationTaskId).
                RUN getSonVal IN hGenXml (INPUT iDocumentsInformationTaskId, INPUT "VideoCode":U, OUTPUT tt-ord-taref.cod-video).
                 RUN getSonVal IN hGenXml (INPUT iDocumentsInformationTaskId, INPUT "ImageCode":U, OUTPUT tt-ord-taref.cod-imagem).

           /* SummarizedOrderTask */
            RUN searchTag IN hGenXml ("SummarizedOrderTask":U, iTaskMOTypeId, OUTPUT iSummarizedOrderTaskId).
                RUN getSonDec IN hGenXml (INPUT iSummarizedOrderTaskId, INPUT "SummarizedOrderNumber":U, OUTPUT tt-ord-taref.nr-ord-sum).
                 IF tt-ord-taref.nr-ord-sum = ? THEN ASSIGN tt-ord-taref.nr-ord-sum = 0.

                 RUN getSonDec IN hGenXml (INPUT iSummarizedOrderTaskId, INPUT "PrincipalSummarizedOrderNumber":U, OUTPUT tt-ord-taref.nr-ord-princ). 
                  IF tt-ord-taref.nr-ord-princ = ? THEN ASSIGN tt-ord-taref.nr-ord-princ = 0.
                 RUN getSonDec IN hGenXml (INPUT iSummarizedOrderTaskId, INPUT "MaintenanceTaskPrincipal":U, OUTPUT tt-ord-taref.cd-tarefa-princ). 

           /* PlanningInformationTask */
            RUN searchTag IN hGenXml ("PlanningInformationTask":U, iTaskMOTypeId, OUTPUT iPlanningInformationTaskId).
                RUN getSonDec IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "AnticipationDays":U, OUTPUT tt-ord-taref.dias-antec).      
                 IF tt-ord-taref.dias-antec = ? THEN ASSIGN tt-ord-taref.dias-antec = 1.
                RUN getSonDec IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskReleaseState":U, OUTPUT tt-ord-taref.est-liber).      
                 IF tt-ord-taref.est-liber = ? THEN ASSIGN tt-ord-taref.est-liber = 0.
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "MarkedStartDate":U, OUTPUT tt-ord-taref.dt-inicio-marc).      
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "MarkedTermDate":U, OUTPUT tt-ord-taref.dt-termino-marc).      
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskStartDate":U, OUTPUT tt-ord-taref.dt-inicio).      
                RUN getSonVal  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskStartTime":U, OUTPUT tt-ord-taref.hora-inicio).      
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskEndDate":U, OUTPUT tt-ord-taref.dt-termino).      
                RUN getSonVal  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskEndTime":U, OUTPUT tt-ord-taref.hora-termino).    
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "PERTNetworkTaskStartDate":U, OUTPUT tt-ord-taref.dt-inic-pert).
                RUN getSonVal  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskStartTimeOfPERTNet":U, OUTPUT tt-ord-taref.hora-inic-pert).
                RUN getSonLog  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "IsSpecialtiesOfTaskThatWorkSimultaneous":U, OUTPUT tt-ord-taref.exec-simul).
                 IF tt-ord-taref.exec-simul = ? THEN ASSIGN tt-ord-taref.exec-simul = FALSE.
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskStartDateBaseline":U, OUTPUT tt-ord-taref.bl-dt-inicio).      
                RUN getSonVal  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskStartTimeBaseline":U, OUTPUT tt-ord-taref.bl-hora-inicio).    
                RUN getSonDate IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskEndDateBaseline":U, OUTPUT tt-ord-taref.bl-dt-termino).      
                RUN getSonVal  IN hGenXml (INPUT iPlanningInformationTaskId, INPUT "TaskEndTimeBaseline":U, OUTPUT tt-ord-taref.bl-hora-termino).    

            ASSIGN iNextTaskMOTypeId = iTaskMOTypeId.
            /* Busca pr¢xima tarefa */
            RUN GetNextSonId IN hGenXml (iListOfTaskMOId, iNextTaskMOTypeId, OUTPUT iTaskMOTypeId).

         END. /* TaskOfMaintenanceOrder */
     END. /* ListOfTaskOfMaintenanceOrder */
     RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-ord-epi: /* INFORMAÄÂES REFERENTES AO EQUIPAMENTO DE PROTEÄ«O INDIVIDUAL */

 DEF VAR c-cd-epi    LIKE ord-epi.cd-epi         NO-UNDO.
 DEF VAR i-cd-tarefa LIKE ord-taref.cd-tarefa    NO-UNDO.

 DEF VAR iIndividualProtectEquipId        AS INT NO-UNDO.
 DEF VAR iIndividualProtectEquipTypeId    AS INT NO-UNDO.
 DEF VAR iListOfProtectEquipId            AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iNextIndividualProtectEquipId    AS INT NO-UNDO.
 DEF VAR deQtdProtectionEquipment         AS DEC NO-UNDO.

    
    RUN searchTag IN hGenXml ("ListOfIndividualProtectionEquipment":U, 1, OUTPUT iListOfProtectEquipId).
     IF iListOfProtectEquipId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfProtectEquipId, OUTPUT iIndividualProtectEquipTypeId).
         DO WHILE iIndividualProtectEquipTypeId <> ?:

            /* IndividualProtectionEquipment */
            RUN searchTag IN hGenXml ("IndividualProtectionEquipment":U, iIndividualProtectEquipTypeId, OUTPUT iIndividualProtectEquipId).
                RUN getSonVal IN hGenXml (INPUT iIndividualProtectEquipId, INPUT "IndividualProtectionEquipmentCode":U, OUTPUT c-cd-epi).

            /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iIndividualProtectEquipTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).
                  
                  IF CAN-FIND (FIRST tt-ord-epi WHERE
                                     tt-ord-epi.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND
                                     tt-ord-epi.cd-tarefa    = i-cd-tarefa                   AND
                                     tt-ord-epi.cd-epi       = c-cd-epi)                     THEN DO:
                      {utp/ut-liter.i EPI *}           
                      run pi-gera-tt-erro (input 7,
                                           input RETURN-VALUE).
                      RETURN "NOK":U.
                  END.

            CREATE tt-ord-epi.
            ASSIGN tt-ord-epi.nr-ord-produ = tt-ord-manut-api.nr-ord-produ 
                   tt-ord-epi.cd-tarefa    = i-cd-tarefa
                   tt-ord-epi.cd-epi       = c-cd-epi .

            ASSIGN deQtdProtectionEquipment = 0.

            RUN getSonDec IN hGenXml (INPUT iIndividualProtectEquipTypeId, INPUT "QuantityOfIndividualProtectionEquipment":U, OUTPUT deQtdProtectionEquipment).      

            IF deQtdProtectionEquipment = ? then
                  ASSIGN tt-ord-epi.qtde-epi = 1.
             ELSE ASSIGN tt-ord-epi.qtde-epi = deQtdProtectionEquipment.

            ASSIGN iNextIndividualProtectEquipId = iIndividualProtectEquipTypeId.
            /* Busca pr¢ximo equipamento */
            RUN GetNextSonId IN hGenXml (iListOfProtectEquipId, iNextIndividualProtectEquipId, OUTPUT iIndividualProtectEquipTypeId).

         END. /* IndividualProtectionEquipmentType */
     END. /* ListOfIndividualProtectionEquipment */
     RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-ord-esp: /* INFORMAÄÂES REFERENTES ∑S ESPECIALIDADES DA TAREFA DA O.M. */
                 
 DEF VAR i-cd-tarefa   LIKE ord-taref.cd-tarefa  NO-UNDO.
 DEF VAR c-tp-especial LIKE ord-esp.tp-especial  NO-UNDO.
 
 DEF VAR iCalendarProductionId            AS INT NO-UNDO.
 DEF VAR iListOfSpecialtyTaskMOId         AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iNextSpecialtyTaskMOTypeId       AS INT NO-UNDO.
 DEF VAR iSpecialityId                    AS INT NO-UNDO.
 DEF VAR iSpecialtyTaskMOTypeId           AS INT NO-UNDO.

    
    RUN searchTag IN hGenXml ("ListOfSpecialtyTaskMaintenanceOrder":U, 1, OUTPUT iListOfSpecialtyTaskMOId).
     IF iListOfSpecialtyTaskMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfSpecialtyTaskMOId, OUTPUT iSpecialtyTaskMOTypeId).
         DO WHILE iSpecialtyTaskMOTypeId <> ?:

            /* Speciality */
            RUN searchTag IN hGenXml ("Speciality":U, iSpecialtyTaskMOTypeId, OUTPUT iSpecialityId).
            RUN getSonVal IN hGenXml (INPUT iSpecialityId, INPUT "SpecialityCode":U, OUTPUT c-tp-especial).

             /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iSpecialtyTaskMOTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).

            IF CAN-FIND (FIRST tt-ord-esp WHERE
                               tt-ord-esp.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND
                               tt-ord-esp.cd-tarefa    = i-cd-tarefa                   AND
                               tt-ord-esp.tp-especial  = c-tp-especial)                THEN DO:

                {utp/ut-liter.i Especialidade_da_Tarefa *}           
                run pi-gera-tt-erro (input 7,
                                     input RETURN-VALUE).
                RETURN "NOK":U.
            END.

            CREATE tt-ord-esp.
            ASSIGN tt-ord-esp.nr-ord-produ = tt-ord-manut-api.nr-ord-produ  
                   tt-ord-esp.cd-tarefa    = i-cd-tarefa
                   tt-ord-esp.tp-especial  = c-tp-especial .

            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "CrewSizeWorkingOnTask":U, OUTPUT tt-ord-esp.nr-homens).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "NumberOfDaysOutOfPhaseFromEndOfPeriod":U, OUTPUT tt-ord-esp.nr-dias-dur).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TotalTimeForExecutionOfTask":U, OUTPUT tt-ord-esp.tempo).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TaskTimeAlreadyReported":U, OUTPUT tt-ord-esp.tempo-rep).
            RUN getSonLog IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "IsSpecialtyTaskClosed":U, OUTPUT tt-ord-esp.encerrada).
             IF tt-ord-esp.encerrada = ? THEN ASSIGN tt-ord-esp.encerrada = FALSE.
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TaskConclusionPercent":U, OUTPUT tt-ord-esp.conclusao).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "MinimunDailyAllocationForSpecialty":U, OUTPUT tt-ord-esp.aloc-minima).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "MaximumDailyAllocationForSpecialty":U, OUTPUT tt-ord-esp.aloc-maxima).
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TypeOfSpecialtyForCalculation":U, OUTPUT tt-ord-esp.tipo-espec).
             IF tt-ord-esp.tipo-espec <> 1 AND tt-ord-esp.tipo-espec <> 2 THEN
                ASSIGN tt-ord-esp.tipo-espec = 1. /* Normal - ininc/i01in421.i */
            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TypeOfSpecialtyTime":U, OUTPUT tt-ord-esp.tipo-tempo).
            RUN getSonVal IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "TextOfSpecialtyOfTask":U, OUTPUT tt-ord-esp.msg-exp).
             IF tt-ord-esp.msg-exp = ? THEN ASSIGN tt-ord-esp.msg-exp = "".

            /* CalendarProduction */
            RUN searchTag IN hGenXml ("CalendarProduction":U, iSpecialtyTaskMOTypeId, OUTPUT iCalendarProductionId).
                RUN getSonDec IN hGenXml (INPUT iCalendarProductionId, INPUT "CalendarOfProductionCode":U, OUTPUT tt-ord-esp.cd-calen).

            RUN getSonDec IN hGenXml (INPUT iSpecialtyTaskMOTypeId, INPUT "SpecialtyEfficiencyPercent":U, OUTPUT tt-ord-esp.eficiencia).

            ASSIGN iNextSpecialtyTaskMOTypeId = iSpecialtyTaskMOTypeId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfSpecialtyTaskMOId, iNextSpecialtyTaskMOTypeId, OUTPUT iSpecialtyTaskMOTypeId).

         END. /* ToolOfTaskOfMaintenanceOrderType */
     END. /* ListOfSpecialtyTaskMaintenanceOrder */
     RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-ord-ferr: /* INFORMAÄÂES REFERENTES ∑S FERRAMENTAS DA TAREFA DA O.M. */
                 

 DEF VAR i-cd-tarefa   LIKE ord-taref.cd-tarefa  NO-UNDO.
 DEF VAR c-cd-tp-ferr  LIKE ord-ferr.cd-tp-ferr  NO-UNDO.
 
 DEF VAR iListOfToolTaskMOId              AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iNextToolOfTaskMOTypeId          AS INT NO-UNDO.
 DEF VAR iToolTypeId                      AS INT NO-UNDO.
 DEF VAR iToolOfTaskMOTypeId              AS INT NO-UNDO.
 DEF VAR deTimeToolWillBeUsed             AS DEC NO-UNDO.


    RUN searchTag IN hGenXml ("ListOfToolOfTaskMaintenanceOrder":U, 1, OUTPUT iListOfToolTaskMOId).
     IF iListOfToolTaskMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfToolTaskMOId, OUTPUT iToolOfTaskMOTypeId).
         DO WHILE iToolOfTaskMOTypeId <> ?:

            /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iToolOfTaskMOTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).

            /* ToolType */
            RUN searchTag IN hGenXml ("ToolType ":U, iToolOfTaskMOTypeId, OUTPUT iToolTypeId).
                RUN getSonVal IN hGenXml (INPUT iToolTypeId, INPUT "ToolTypeTask":U, OUTPUT c-cd-tp-ferr).

            IF CAN-FIND (FIRST tt-ord-ferr WHERE 
                               tt-ord-ferr.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND
                               tt-ord-ferr.cd-tarefa    = i-cd-tarefa                   AND
                               tt-ord-ferr.cd-tp-ferr   = c-cd-tp-ferr)                 THEN DO:
                {utp/ut-liter.i Ferramenta_da_Tarefa *}           
                run pi-gera-tt-erro (input 7,
                                     input RETURN-VALUE).
                RETURN "NOK":U.
            END.

            CREATE tt-ord-ferr.
            ASSIGN tt-ord-ferr.nr-ord-produ = tt-ord-manut-api.nr-ord-produ  
                   tt-ord-ferr.cd-tarefa    = i-cd-tarefa
                   tt-ord-ferr.cd-tp-ferr   = c-cd-tp-ferr 
                   deTimeToolWillBeUsed     = 0.

            RUN getSonDec IN hGenXml (INPUT iToolOfTaskMOTypeId, INPUT "TimeDuringWhichToolWillBeUsed":U, OUTPUT deTimeToolWillBeUsed).

             IF deTimeToolWillBeUsed = ? THEN 
                  ASSIGN tt-ord-ferr.tempo = 1.
             ELSE ASSIGN tt-ord-ferr.tempo = deTimeToolWillBeUsed.

            ASSIGN iNextToolOfTaskMOTypeId = iToolOfTaskMOTypeId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfToolTaskMOId, iNextToolOfTaskMOTypeId, OUTPUT iToolOfTaskMOTypeId).

         END. /* ToolOfTaskOfMaintenanceOrderType */
     END. /* ListOfToolOfTaskMaintenanceOrder */
     RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-ord-fich-met: /* INFORMAÄÂES REFERENTES ∑S FICHAS DE MêTODOS DA TAREFA DA O.M. */
                 
    
 DEF VAR i-cd-tarefa LIKE ord-taref.cd-tarefa     NO-UNDO.
 DEF VAR i-fi-codigo LIKE ord-fich-met.fi-codigo  NO-UNDO.

 DEF VAR iListOfProcessSheetMOId          AS INT  NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT  NO-UNDO.
 DEF VAR iNextProcessSheetMOTypeId        AS INT  NO-UNDO.
 DEF VAR iProcessSheetId                  AS INT  NO-UNDO.
 DEF VAR iProcessSheetMOTypeId            AS INT  NO-UNDO.


    RUN searchTag IN hGenXml ("ListOfProcessSheetMaintenanceOrder":U, 1, OUTPUT iListOfProcessSheetMOId).
     IF iListOfProcessSheetMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfProcessSheetMOId, OUTPUT iProcessSheetMOTypeId).
         DO WHILE iProcessSheetMOTypeId <> ? :
            
            /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iProcessSheetMOTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).

            /* ProcessSheet */
            RUN searchTag IN hGenXml ("ProcessSheet ":U, iProcessSheetMOTypeId, OUTPUT iProcessSheetId).
                RUN getSonDec IN hGenXml (INPUT iProcessSheetId, INPUT "ProcessSheetCode":U, OUTPUT i-fi-codigo).

            IF CAN-FIND (FIRST tt-ord-fich-met WHERE 
                               tt-ord-fich-met.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND
                               tt-ord-fich-met.cd-tarefa    = i-cd-tarefa                   AND
                               tt-ord-fich-met.fi-codigo    = i-fi-codigo)                  THEN DO:
                {utp/ut-liter.i Ficha_de_Metodo_da_Tarefa *}           
                run pi-gera-tt-erro (input 7,
                                     input RETURN-VALUE).
                RETURN "NOK":U.
            END.

            CREATE tt-ord-fich-met.
            ASSIGN tt-ord-fich-met.nr-ord-produ = tt-ord-manut-api.nr-ord-produ
                   tt-ord-fich-met.cd-tarefa    = i-cd-tarefa
                   tt-ord-fich-met.fi-codigo    = i-fi-codigo . 
            
            ASSIGN iNextProcessSheetMOTypeId = iProcessSheetMOTypeId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfProcessSheetMOId, iNextProcessSheetMOTypeId, OUTPUT iProcessSheetMOTypeId).

         END. /* ProcessSheetMaintenanceOrderType */
     END. /* ListOfProcessSheetMaintenanceOrder */
     RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-ord-turno:  /* INFORMAÄÂES REFERENTES AOS TURNOS DA TAREFA DA O.M. */
                 

 DEF VAR i-cd-tarefa LIKE ord-taref.cd-tarefa     NO-UNDO.
 DEF VAR i-cd-turno  LIKE ord-turno.cd-turno      NO-UNDO.
 
 DEF VAR iListOfShiftOfMOId               AS INT NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT NO-UNDO.
 DEF VAR iNextShiftOfMOTypeId             AS INT NO-UNDO.
 DEF VAR iShiftId                         AS INT NO-UNDO.
 DEF VAR iShiftOfMOTypeId                 AS INT NO-UNDO.

   
    RUN searchTag IN hGenXml ("ListOfShiftOfMaintenanceOrder":U, 1, OUTPUT iListOfShiftOfMOId).
     IF iListOfShiftOfMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfShiftOfMOId, OUTPUT iShiftOfMOTypeId).
         DO WHILE iShiftOfMOTypeId <> ? :

            /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iShiftOfMOTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).
            /* Shift */
            RUN searchTag IN hGenXml ("Shift ":U, iShiftOfMOTypeId, OUTPUT iShiftId).
                RUN getSonDec IN hGenXml (INPUT iShiftId, INPUT "ShiftCode":U, OUTPUT i-cd-turno).

            IF CAN-FIND (FIRST tt-ord-turno WHERE 
                               tt-ord-turno.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND    
                               tt-ord-turno.cd-tarefa    = i-cd-tarefa                   AND
                               tt-ord-turno.cd-turno     = i-cd-turno)                   THEN DO:
                    CREATE tt-erro.
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "J†_existe_Turno_da_Tarefa_da_Ordem_de_Manutená∆o_com_a_chave_informada" *}
                    ASSIGN tt-erro.cd-erro  = 7
                           tt-erro.mensagem = RETURN-VALUE.

                    UNDO, LEAVE.
            END.

            CREATE tt-ord-turno.
            ASSIGN tt-ord-turno.nr-ord-produ = tt-ord-manut-api.nr-ord-produ  
                   tt-ord-turno.cd-tarefa    = i-cd-tarefa
                   tt-ord-turno.cd-turno     = i-cd-turno .

            ASSIGN iNextShiftOfMOTypeId = iShiftOfMOTypeId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfShiftOfMOId, iNextShiftOfMOTypeId, OUTPUT iShiftOfMOTypeId).

         END. /* ShiftOfMaintenanceOrderType */
     END. /* ListOfShiftOfMaintenanceOrder */

END PROCEDURE.


PROCEDURE pi-cria-p-ord-esp: /* INFORMAÄÂES REFERENTES ∑ RED PERT ENTRE AS TAREFAS DA O.M. */

 DEF VAR i-cd-tarefa     LIKE ord-taref.cd-tarefa     NO-UNDO.
 DEF VAR i-nr-ord-predec LIKE p-ord-esp.nr-ord-predec NO-UNDO.
 DEF VAR i-taref-pred    LIKE p-ord-esp.taref-pred    NO-UNDO.

 DEF VAR iListOfPertTaskMOId              AS INT      NO-UNDO.
 DEF VAR iMaintenanceTaskId               AS INT      NO-UNDO.
 DEF VAR iNextPertTaskMOTypeId            AS INT      NO-UNDO.
 DEF VAR iPertTaskMOTypeId                AS INT      NO-UNDO.
 DEF VAR iPrecedingTaskId                 AS INT      NO-UNDO.


    RUN searchTag IN hGenXml ("ListOfPertTaskMaintenanceOrder":U, 1, OUTPUT iListOfPertTaskMOId).
     IF iListOfPertTaskMOId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfPertTaskMOId, OUTPUT iPertTaskMOTypeId).
         DO WHILE iPertTaskMOTypeId <> ? :

            /* MaintenanceTask */
            RUN searchTag IN hGenXml ("MaintenanceTask":U, iPertTaskMOTypeId, OUTPUT iMaintenanceTaskId).
                RUN getSonDec IN hGenXml (INPUT iMaintenanceTaskId, INPUT "MaintenanceTaskCode":U, OUTPUT i-cd-tarefa).

            /* PrecedingTask */
            RUN searchTag IN hGenXml ("PrecedingTask":U, iPertTaskMOTypeId, OUTPUT iPrecedingTaskId).
                RUN getSonDec IN hGenXml (INPUT iPrecedingTaskId, INPUT "PrecedingTaskCode":U, OUTPUT i-taref-pred).
                RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "PrecedingOrderNumber":U, OUTPUT i-nr-ord-predec).

            IF CAN-FIND (FIRST tt-p-ord-esp WHERE 
                               tt-p-ord-esp.nr-ord-produ  = tt-ord-manut-api.nr-ord-produ AND
                               tt-p-ord-esp.cd-tarefa     = i-cd-tarefa                   AND
                               tt-p-ord-esp.taref-pred    = i-taref-pred                  AND
                               tt-p-ord-esp.nr-ord-predec = i-nr-ord-predec)              THEN DO:

                {utp/ut-liter.i Rede_Pert *}           
                run pi-gera-tt-erro (input 18464,
                                     input RETURN-VALUE).
                RETURN "NOK":U.
            END.

            CREATE tt-p-ord-esp.
            ASSIGN tt-p-ord-esp.nr-ord-produ  = tt-ord-manut-api.nr-ord-produ
                   tt-p-ord-esp.cd-tarefa     = i-cd-tarefa
                   tt-p-ord-esp.taref-pred    = i-taref-pred
                   tt-p-ord-esp.nr-ord-predec = i-nr-ord-predec.

            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "OverlapTimeBetweenTask":U, OUTPUT tt-p-ord-esp.overlap).
            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "OverlapType":U, OUTPUT tt-p-ord-esp.tipo-overlap).
             IF tt-p-ord-esp.tipo-overlap <> 1 AND tt-p-ord-esp.tipo-overlap <> 2 then
                ASSIGN tt-p-ord-esp.tipo-overlap = 1. /* Percentual - ininc/i01in279.i */
            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "TotalOverlapTime":U, OUTPUT tt-p-ord-esp.tempo-overlap).
            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "MinimumWaitTime":U, OUTPUT tt-p-ord-esp.tempo-espera-min).
            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "MaximumWaitTime":U, OUTPUT tt-p-ord-esp.tempo-espera-max).
            RUN getSonDec IN hGenXml (INPUT iPertTaskMOTypeId, INPUT "SummarizedOrderNumber":U, OUTPUT tt-p-ord-esp.nr-ord-sum).
             IF tt-p-ord-esp.nr-ord-sum = ? THEN ASSIGN tt-p-ord-esp.nr-ord-sum = 0.

            ASSIGN iNextPertTaskMOTypeId = iPertTaskMOTypeId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfPertTaskMOId, iNextPertTaskMOTypeId, OUTPUT iPertTaskMOTypeId).

         END. /* PertTaskMaintenanceOrderType */
     END. /* ListOfPertTaskMaintenanceOrder */

END PROCEDURE.


PROCEDURE pi-cria-reservas: /* INFORMAÄÂES REFERENTES ∑S RESERVAS DOS ITENS PREVISTOS PARA A O.M. */

 DEF VAR i-cd-tarefa     LIKE ord-taref.cd-tarefa NO-UNDO.
 DEF VAR c-it-codigo     LIKE reservas.it-codigo  NO-UNDO.
 DEF VAR i-op-codigo     LIKE reservas.op-codigo  NO-UNDO.

 DEF VAR iMaintenanceTaskId               AS INT  NO-UNDO.
 DEF VAR iListOfReserveInformationId      AS INT  NO-UNDO.
 DEF VAR iNextReserveInformationId        AS INT  NO-UNDO.
 DEF VAR iOperationInformationId          AS INT  NO-UNDO.
 DEF VAR iQuantityOfReservesInfoId        AS INT  NO-UNDO.
 DEF VAR iReferenceId                     AS INT  NO-UNDO.
 DEF VAR iReserveInformationId            AS INT  NO-UNDO.
 DEF VAR iUnitOfMeasureId                 AS INT  NO-UNDO.
 DEF VAR iWarehouseId                     AS INT  NO-UNDO.


    RUN searchTag IN hGenXml ("ListOfReserveInformation":U, 1, OUTPUT iListOfReserveInformationId).
     IF iListOfReserveInformationId <> ? THEN DO:

        RUN getFirstSonId IN hGenXml (iListOfReserveInformationId, OUTPUT iReserveInformationId).
         DO WHILE iReserveInformationId <> ? :

            RUN getSonVal IN hGenXml (INPUT iReserveInformationId, INPUT "ReserveItemCode":U, OUTPUT c-it-codigo).

             /* OperationInformation */
             RUN searchTag IN hGenXml ("OperationInformations":U, iReserveInformationId, OUTPUT iOperationInformationId).
              IF iOperationInformationId <> ? THEN DO:
                 RUN getSonDec IN hGenXml (INPUT iOperationInformationId, INPUT "OperationCode":U, OUTPUT i-op-codigo).
                  IF i-op-codigo = ? THEN ASSIGN i-op-codigo = 0.
              END.

             IF CAN-FIND (FIRST tt-reservas where
                                tt-reservas.nr-ord-produ = tt-ord-manut-api.nr-ord-produ AND
                                tt-reservas.it-codigo    = c-it-codigo                   AND
                                tt-reservas.op-codigo    = i-op-codigo)                  THEN DO:
                 {utp/ut-liter.i Reserva *}
                 run pi-gera-tt-erro (input 7,
                                      input RETURN-VALUE).
                 RETURN "NOK":U.
             END.

            CREATE tt-reservas.
            ASSIGN tt-reservas.nr-ord-produ = tt-ord-manut-api.nr-ord-produ
                   tt-reservas.it-codigo    = c-it-codigo
                   tt-reservas.op-codigo    = i-op-codigo
                   tt-reservas.item-pai     = param-mi.it-codigo.

            RUN getSonDate IN hGenXml (INPUT iReserveInformationId, INPUT "ReserveDate":U, OUTPUT tt-reservas.dt-reserva).
             IF tt-reservas.dt-reserva = ? THEN ASSIGN tt-reservas.dt-reserva = TODAY.
            RUN getSonDec IN hGenXml (INPUT iReserveInformationId, INPUT "UpdateType":U, OUTPUT tt-reservas.tp-atualiza).
             IF tt-reservas.tp-atualiza < 1 OR tt-reservas.tp-atualiza > 9 THEN
                ASSIGN tt-reservas.tp-atualiza = 1. /* Interna  - ininc/i10in271.i*/
            RUN getSonVal IN hGenXml (INPUT iReserveInformationId, INPUT "LotOrSerialNumber":U, OUTPUT tt-reservas.lote-serie).
            RUN getSonLog IN hGenXml (INPUT iReserveInformationId, INPUT "IsPrintRequisition":U, OUTPUT tt-reservas.emite-requis).
             IF tt-reservas.emite-requis = ? THEN ASSIGN tt-reservas.emite-requis = TRUE.
            RUN getSonDec IN hGenXml (INPUT iReserveInformationId, INPUT "ReserveStatus":U, OUTPUT tt-reservas.estado).
             IF tt-reservas.estado <> 1 AND tt-reservas.estado <> 2 THEN
                ASSIGN tt-reservas.estado = 1. /* Ativo - ininc/i01in390.i */
            RUN getSonVal IN hGenXml (INPUT iReserveInformationId, INPUT "RoutingCode":U, OUTPUT tt-reservas.cod-roteiro).
            RUN getSonDec IN hGenXml (INPUT iReserveInformationId, INPUT "ReserveSource":U, OUTPUT tt-reservas.origem).
             IF tt-reservas.origem <> 1 AND tt-reservas.origem <> 2 THEN
                ASSIGN tt-reservas.estado = 1 . /* Autom†tica - ininc/i03in390.i */
            RUN getSonDec IN hGenXml (INPUT iReserveInformationId, INPUT "SurplusType":U, OUTPUT tt-reservas.tipo-sobra).
             IF  tt-reservas.tipo-sobra = ? OR tt-reservas.tipo-sobra < 1 OR tt-reservas.tipo-sobra > 4 THEN
                ASSIGN tt-reservas.tipo-sobra = 1. /* Retorno de Requisiá∆o - ininc/i01in068.i */

            /* Reference */
            RUN searchTag IN hGenXml ("Reference":U, iReserveInformationId, OUTPUT iReferenceId).
             IF iReferenceId = ? THEN DO:
                RUN getSonVal IN hGenXml (INPUT iReferenceId, INPUT "ReferenceCode":U, OUTPUT tt-reservas.cod-refer).
                   IF tt-reservas.cod-refer <> ? AND tt-reservas.cod-refer <> "" then
                RUN getSonDec IN hGenXml (INPUT iReferenceId, INPUT "ReferenceOrder":U, OUTPUT tt-reservas.nr-ord-refer).
                 IF tt-reservas.nr-ord-refer = ? THEN ASSIGN tt-reservas.nr-ord-refer = 0.
                RUN getSonDec IN hGenXml (INPUT iReferenceId, INPUT "SummarizedRequisition":U, OUTPUT tt-reservas.nr-req-sum).
                RUN getSonVal IN hGenXml (INPUT iReferenceId, INPUT "LocationCode":U, OUTPUT tt-reservas.cod-localiz).
                RUN getSonVal IN hGenXml (INPUT iReferenceId, INPUT "ComponentsList":U, OUTPUT tt-reservas.cod-lista-compon).

                &IF '{&BF_MNT_VERSAO_EMS}' >= '2.05' &THEN
                  RUN getSonDec IN hGenXml (INPUT iReferenceId, INPUT "PartsForMilion":U, OUTPUT tt-reservas.per-ppm).
                  RUN getSonLog IN hGenXml (INPUT iReferenceId, INPUT "IsVehicle":U, OUTPUT tt-reservas.veiculo).
                   IF tt-reservas.veiculo = ? THEN ASSIGN tt-reservas.veiculo = false.
                  RUN getSonDec IN hGenXml (INPUT iReferenceId, INPUT "CompositionFormula":U, OUTPUT tt-reservas.tipo-formula).
                   IF tt-reservas.tipo-formula = ? OR tt-reservas.tipo-formula < 1 OR tt-reservas.tipo-formula > 4 THEN
                      ASSIGN tt-reservas.tipo-formula = 1 . /* N∆o utiliza - ininc/i25in172.i */
                &ENDIF
             END.

            /* Warehouse */
            RUN searchTag IN hGenXml ("Warehouse":U, iReserveInformationId, OUTPUT iWarehouseId).
                RUN getSonVal IN hGenXml (INPUT iWarehouseId, INPUT "WarehouseCode":U, OUTPUT tt-reservas.cod-depos).

            /* UnitOfMeasure */
            RUN searchTag IN hGenXml ("UnitOfMeasure":U, iReserveInformationId, OUTPUT iUnitOfMeasureId).
                RUN getSonVal IN hGenXml (INPUT iUnitOfMeasureId, INPUT "UnitOfMeasureCode":U, OUTPUT tt-reservas.un).

            /* QuantityOfReservesInformation */
            RUN searchTag IN hGenXml ("QuantityOfReservesInformation":U, iReserveInformationId, OUTPUT iQuantityOfReservesInfoId).
             IF iQuantityOfReservesInfoId <> ? THEN DO:
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "QuantityOfReserve":U, OUTPUT tt-reservas.quant-orig).
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "ProcessedQuantity":U, OUTPUT tt-reservas.quant-atend).
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "RequisitedQuantity":U, OUTPUT tt-reservas.quant-requis).
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "AllocationQuantity":U, OUTPUT tt-reservas.quant-aloc).
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "ThirdQuantity":U, OUTPUT tt-reservas.quant-terc).
                RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "InvestedQuantity":U, OUTPUT tt-reservas.quant-aplic).
                &IF '{&BF_MNT_VERSAO_EMS}' >= '2.05' &THEN
                 RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "PhysicalAllocationQuantity":U, OUTPUT tt-reservas.qt-aloc-lote).
                 RUN getSonDec IN hGenXml (INPUT iQuantityOfReservesInfoId, INPUT "PhysicalProcessedQuantity":U, OUTPUT tt-reservas.qt-atend-lote).
                &ENDIF
             END.

            ASSIGN iNextReserveInformationId = iReserveInformationId.
            /* Busca pr¢xima ferramenta da tarefa */
            RUN GetNextSonId IN hGenXml (iListOfReserveInformationId, iNextReserveInformationId, OUTPUT iReserveInformationId).

         END. /* ReservesInformationType */
     END. /* ListOfReserveInformationrmation */

END PROCEDURE.

&ENDIF


procedure pi-gera-tt-erro.

  def input  parameter i-msg      as integer no-undo.
  def input  parameter c-texto    as char format "x(255)" no-undo.

  run utp/ut-msgs.p (input "msg",
                     input i-msg,
                     input c-texto).
  create tt-erro.
  assign tt-erro.mensagem = return-value
         tt-erro.cd-erro  = i-msg
         l-erro           = yes.  

end procedure.
