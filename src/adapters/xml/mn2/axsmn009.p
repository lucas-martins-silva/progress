/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMN009 2.00.00.004 } /*** 010004 ***/


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&analyze-suspend _VERSION-NUMBER UIB_v9r12
&analyze-resume
&analyze-suspend _UIB-CODE-BLOCK _CUSTOM _DEFinITIONS procedure
/*------------------------------------------------------------------------
    File        : AXSMA009.p
    Description : ADAPTER DE ENVIO DE ORDEM DE MANUTENÄ«O
    Developer   : andRê LU÷S OLIVEIRA PEREIRA - DATASUL MANUFATURA
    CREATEd     : 11/2007
    notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
/* **********************  Definitions  *********************** */

/* PrÇ-Processadores*/
&global-define XmlTranName      MaintenanceOrder
&global-define XmlTranVersion   204.000
&global-define XmlProdName      ems2
&global-define XmlProdVersion   204
&global-define XmlApp           mn2
&global-define XmlMod           mip

/*define temp-table tt-ord-manut-api no-undo like ord-manut.*/
{cdp/cdcfgmnt.i}  /** PrÇ-processadores de vers‰es da Manutená∆o Industrial **/
{cdp/cdcfgmat.i}  /** PrÇ-processadores de vers‰es de Materias              **/
{cdp/cdcfgman.i}  /** PrÇ-processadores de vers‰es da Manufatura            **/
{mip/miapi004.i}  /** Definiá∆o da temp-table tt-ord-manut-api              **/

/* Definiá∆o temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*ParÉmetros de entrada*/
define input  parameter pTranAction  as character    no-undo.
define input  parameter pProgName    as character    no-undo.
define input  parameter pProgVersion as character    no-undo.
DEFINE INPUT  PARAMETER TABLE FOR tt-ord-manut-api.
define output parameter table for RowErrors.

/* Vari†veis Globais */
define variable hGenXml          as handle no-undo.

/* Handle do BusinessContent */
define variable hBusinessContent as handle no-undo.

/* Variaveis da construá∆o do BusinessContent Utilizando APIXML */
define variable iId                              as integer  no-undo.
define variable iFirstId                         as integer  no-undo.
define variable iIdorder                         as integer  no-undo.
define variable iIdPlannerAuxCode                as integer  no-undo.
define variable iIdTeaminCharge                  as integer  no-undo.
define variable iIdTechnnical                    as integer  no-undo.
define variable iIdProject                       as integer  no-undo.
define variable iIdMaintenance                   as integer  no-undo.
define variable iIdTagFunction                   as integer  no-undo.
define variable iIdCompany                       as integer  no-undo.
define variable iIdEquipment                     as integer  no-undo.
define variable iIdTargetSite                    as integer  no-undo.
define variable iIdProductionLine                as integer  no-undo.
define variable iIdEquipmentFamily               as integer  no-undo.
define variable iIdMaintenanceOrderFunction      as integer  no-undo.
define variable iIdPlanninginformationOrder      as integer  no-undo.
define variable iIdPlannerAux                    as integer  no-undo.
define variable iIdMainanceSpecialty             as integer  no-undo.
define variable iIdDateinformationOrder          as integer  no-undo.
define variable iIdStatusinformationOrder        as integer  no-undo.
define variable iIdStopPlaninformationOrder      as integer  no-undo.
define variable iIdStopPlan                      as integer  no-undo.
define variable iIdinspectioninformationOrder    as integer  no-undo.
define variable iIdWarning                       as integer  no-undo.
define variable iIdinspectionRouting             as integer  no-undo.
define variable iIdinspection                    as integer  no-undo.
define variable iIdLubrificationinformationOrder as integer  no-undo.
define variable iIddocumentinformationOrder      as integer  no-undo.
define variable iIdCostinformationOrder          as integer  no-undo.
define variable iIdReportinformationOrder        as integer  no-undo.
define variable iIdListofTaskofMaintenanceOrder  as integer  no-undo.
define variable iIdTaskofMaintenanceOrderType    as integer  no-undo.
define variable iIdBasicinformationTask          as integer  no-undo.
define variable iIdCalibrationinformationTask    as integer  no-undo.
define variable iIdLubrificationinformationTask  as integer  no-undo.
define variable iIdAcceptinformationTask         as integer  no-undo.
define variable iIddocumentsinformationTask      as integer  no-undo.
define variable iIdSummarizedorderTask           as integer  no-undo.
define variable iIdPlanninginformationTask       as integer  no-undo.
define variable iIdMaintenanceOrderMessageinf    as integer  no-undo.
define variable iIdListofindividualProtecEquip   as integer  no-undo.
define variable iIdindividualProtectionEquipCode as integer  no-undo.
define variable iIdindividualProtectionEquipment as integer  no-undo.
define variable iIdMaintenanceTask               as integer  no-undo.
define variable iIdListofSpecialtyTaskMaintOrder as integer  no-undo.
define variable iIdSpecialtyTaskofMaintOrderType as integer  no-undo.
define variable iIdSpeciality                    as integer  no-undo.
define variable iIdMaintenanceTaskAux            as integer  no-undo.
define variable iIdCalendarProduction            as integer  no-undo.
define variable iIdListofToolofTaskMainOrder     as integer  no-undo.
define variable iIdToolofTaskMainOrderType       as integer  no-undo.
define variable iIdMaintenanceTaskAux2           as integer  no-undo.
define variable iIdToolType                      as integer  no-undo.
define variable iIdListofProcessSheetMainOrder   as integer  no-undo.
define variable iIdProcessSheetofMainOrderType   as integer  no-undo.
define variable iIdMaintenanceTaskAux3           as integer  no-undo.
define variable iIdProcessSheet                  as integer  no-undo.
define variable iIdListofShiftofMainOrder        as integer  no-undo.
define variable iIdShiftofMainOrderType          as integer  no-undo.
define variable iIdMaintenanceTaskAux4           as integer  no-undo.
define variable iIdShift                         as integer  no-undo.
define variable iIdListofPertTaskMainOrder       as integer  no-undo.
define variable iIdListofReserveinformation      as integer  no-undo.
define variable iIdReserveinformation            as integer  no-undo.
define variable iIdReferenceAux                  as integer  no-undo.
define variable iIdoperationinformations         as integer  no-undo.
define variable iIdWareHouseAux                  as integer  no-undo.
define variable iIdUnitofMeasure                 as integer  no-undo.
define variable iIdQuantityofReservesinfo        as integer  no-undo.
DEFINE VARIABLE iIdPertTaskMaintenanceOrderType  AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdMaintenanceTask3              AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdPrecedingTask                 AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdBusinessUnit                  AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdFailInformationOrder          AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdCause                         AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdStandardSympton               AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdIntervencion                  AS INTEGER  NO-UNDO.
DEFINE VARIABLE iIdHoldover                      AS INTEGER  NO-UNDO.

/* Vari†veis para armazenar valores da inicializaá∆o do loalMessageHandler */
define variable hMessageHandler as handle      no-undo.
define variable creturnValue    as character   no-undo.

find first param-global no-lock no-error.

/*Vari†veis locais*/
define variable pSendSuccess  as logical initial yes no-undo.
define variable lCREATEMsg    as logical             no-undo.
define variable pTotalErrors  as integer             no-undo.
define variable pErrorNumber  as integer             no-undo.
define variable pErrorType    as character           no-undo.
define variable pErrorDesc    as character           no-undo.
define variable iCount        as integer             no-undo.
define variable i-cont-err    as integer             no-undo.
define variable l-logical     as logical             no-undo.

/* _UIB-CODE-BLOCK-end */
&analyze-resume

&analyze-suspend _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&scoped-define procedure-TYPE procedure
&scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-end */
&analyze-resume

/* ************************  Function Prototypes ********************** */

/* _UIB-CODE-BLOCK-end */
&analyze-resume

/* *********************** procedure Settings ************************ */

&analyze-suspend _procedure-SETTinGS
/* Settings for THIS-procedure
   Type: procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&analyze-resume _end-procedure-SETTinGS

/* *************************  CREATE Window  ************************** */

&analyze-suspend _CREATE-WindoW
/* DESIGN Window definition (used by the UIB) 
  CREATE WindoW procedure asSIGN
         HEIGHT             = 25.46
         WIDTH              = 36.57.
/* end WindoW DEFinITION */
                                                                        */
&analyze-resume

&analyze-suspend _UIB-CODE-BLOCK _CUSTOM _MAin-BLOCK procedure 

/* ***************************  Main Block  *************************** */
{utp/ut-glob.i}
{cdp/cdcfgman.i} 

/** Verifica se h† registros na temp-table **/
if not can-find(first tt-ord-manut-api) then do:

    {utp/ut-liter.i Ordem_de_Manutená∆o_para_integraá∆o_EAI * r}
    run piCriaErro (5561,
                    'EMS':U,
                    trim(return-value)).
     return "NOK":U.
     leave.
end.

for each tt-ord-manut-api NO-LOCK:
    /** Verifica se MessageHandler.p est·† na mem¢ria **/
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHreturnValue="creturnValue"}

    /** Verifica se o MessageHandler foi executado corretamente **/
    if creturnValue <> "OK":U then do:
         if creturnValue <> ? and creturnValue <> " " then do:
             run piCriaErro (17006,
                             'EMS':U,
                             creturnValue).
                 return "NOK":U.
                 leave.
         end.
    end.

    /** Verifica se h† programas inscritos **/
    run isSubscribed in hMessageHandler (input  "{&XmlProdName}",
                                         input  "{&XmlApp}",
                                         input  "{&XmlTranName}",
                                         input  "{&XmlTranVersion}",
                                         input  pTranAction,
                                         input  pTranAction,
                                         output lCREATEMsg).

    /** Verifica se a transaá∆o Ç assinada **/
    if not lCREATEMsg then
         return "OK":U.

    /** Preenche o valor do elemento Comment de TransactionId **/
    run setTransinfoComment in hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion).

    /** Seta SystemID **/
    run setSystemId in hMessageHandler ("{&pXmlMod}" ,        /** Nome do modulo     **/
                                        "{&XmlProdVersion}"). /** Versao do Programa **/

    /** indica valor da chave prim†ria da transaá∆o **/
    run setKeyFields in hMessageHandler ("tt-ord-manut-api.nr-ord-produ",
                                         string(tt-ord-manut-api.nr-ord-produ)).

    /** Seta a empresa e o estabelecimento **/
    run setCompanyId in hMessageHandler (string(v_cdn_empres_usuar), "").

    /** Verifica se API est† na mem¢ria **/
    {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXreturnValue="creturnValue"}

    /** Verifica se o ut-genxml foi executado corretamente **/
    if creturnValue <> "OK":U then do:
         if creturnValue <> ? and creturnValue <> "" then do:
             run piCriaErro (17006,
                             'EMS':U,
                             creturnValue).
          return "NOK":U.
          leave.
         end.
     end.

    /** Cria mensagem do BusinessContent atravÇs da API **/
    CREATE-BUSINESS-XML:
    do:
        /** RESETA OS VALORES **/
        run reset in hGenXml.

        /** SETA VALOR DE ENCODinG **/
        run setEncoding in hGenXml ("UTF-8":U).

        if pTranAction = "ADD":U or pTranAction = "UPD":U then do:

            /** N‡ PRinCIPAL UPSERT **/
            run addNode in hGenXml (0,
                                    "Upsert",
                                    "",
                                    output iFirstId).

            RUN piCriaXml-1 IN THIS-PROCEDURE.
            RUN piMaintenanceOrderFunction IN THIS-PROCEDURE.
            /***************************************/
            RUN piListofTaskofMaintenanceOrder IN THIS-PROCEDURE.
            /***************************************/
            RUN piCriaXml-2 IN THIS-PROCEDURE.
            RUN piCriaXml-3 IN THIS-PROCEDURE.
            /*****************************************/
            RUN piListofReserveinformation IN this-procedure.
            /*****************************************/
        end.
        else if pTranAction = "DEL":U then do:
            /** no principal delete **/
            run addNode in hGenXml (0, "Delete":U, "", output iFirstId).
            run addNode in hGenXml (iFirstId, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iId).
        end.
    end.

    /** ObtÇm XMl na variavel handle **/
    run generateXML in hGenXml (output hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\tmp~\Ordem.xml").*/

    /** Passa handle do BusinessContent **/
    run setBusinessContent in hMessageHandler (input hBusinessContent).

    /** Elimina handle **/
    delete object hBusinessContent no-error.

    /** Envia XML para ControlBroker **/
    
    &IF "{&mguni_version}" >= "2.071" &THEN
    run sendMessage in hMessageHandler (input "mn2/MaintenanceOrder_204_001.xsd").
    &ELSE
    run sendMessage in hMessageHandler (input "mn2/MaintenanceOrder_204_000.xsd").
    &ENDIF

    /** Verifica se a mensagem foi enviada com sucesso **/
    run getreturnStatus in hMessageHandler (output pSendSuccess,
                                            output pTotalErrors).

    if not pSendSuccess then do:
      repeat iCount = 1 to pTotalErrors:
          run getError in hMessageHandler (iCount,
                                           output pErrorNumber,
                                           output pErrorType,
                                           output pErrorDesc ).
          run piCriaErro (17006,
                          pErrorType, 
                          pErrorDesc).
      end.
     return "NOK":U.
     leave.
    end.
end.

/* _UIB-CODE-BLOCK-end */
&analyze-resume

PROCEDURE piCriaXml-1:
    run addNode in hGenXml (iFirstId,"MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iId).
    /** EVENTO **/
    /************/
    run addNode in hGenXml (iFirstId,"MaintenanceOrderEvent":U, 20, output iId).
    /************/
    /************/
    run addNode in hGenXml (iFirstId, "Order":U, "", output iId).
    /** Nodo Order **/
        run addNode in hGenXml (iId, "MaintenanceOrderNumber":U,      tt-ord-manut-api.nr-ord-produ, output iIdorder).
        run addNode in hGenXml (iId, "DescriptionMaintenanceOrder":U, tt-ord-manut-api.des-man-corr, output iIdorder).
    /****************/
    run addNode in hGenXml (iFirstId, "MaintenancePlanner":U, "", output iId).
    /** Nodo MaintenancePlanner **/
        run addNode in hGenXml (iId, "PlannerCode":U,        tt-ord-manut-api.cd-planejado, output iIdPlannerAuxCode).
        for first mnt-planejador
            where mnt-planejador.cd-planejado = tt-ord-manut-api.cd-planejado no-lock:
            run addNode in hGenXml (iId, "PlannerDescription":U, mnt-planejador.nome, output iIdPlannerAuxCode).
        end.
    /*****************************/
    run addNode in hGenXml (iFirstId, "PriorityofMaintenanceOrder":U,   tt-ord-manut-api.prioridade, output iId).
    run addNode in hGenXml (iFirstId, "MaintenanceType":U,              tt-ord-manut-api.tipo,       output iId).
    run addNode in hGenXml (iFirstId, "EquipmentStopTimeforTheOrder":U, tt-ord-manut-api.tempo-para, output iId).
    run addNode in hGenXml (iFirstId, "TeaminCharge":U, "", output iId).
    /** Nodo TeaminCharge **/
        run addNode in hGenXml (iId, "TeaminChargeCode":U, tt-ord-manut-api.cd-equip-res, output iIdTeaminCharge).
        for first equipe
            where equipe.cd-equip = tt-ord-manut-api.cd-equip-res no-lock:
            run addNode in hGenXml (iId, "TeamAcceptNameDescription":U, equipe.desc-equip, output iIdTeaminCharge).
        end.
    /***********************/
    run addNode in hGenXml (iFirstId, "Technnical":U, "", output iId).
    /** Nodo Technnical **/
        run addNode in hGenXml (iId, "TechnnicalCode":U, tt-ord-manut-api.cd-tecnico, output iIdTechnnical).
        for first tecn-mi
            where tecn-mi.cd-tecnico = tt-ord-manut-api.cd-tecnico no-lock:
            run addNode in hGenXml (iId, "TechnicalName":U, tecn-mi.nome-compl, output iIdTechnnical).
        end.
    /*********************/
    run addNode in hGenXml (iFirstId, "Project":U, "", output iId).
    /** Nodo Project **/
        run addNode in hGenXml (iId, "ProjectCode":U, tt-ord-manut-api.cd-projeto, output iIdProject).
        for first projeto
            where projeto.cd-projeto = tt-ord-manut-api.cd-projeto no-lock:
            run addNode in hGenXml (iId, "ProjectDescription":U, projeto.descricao, output iIdProject).
        end.
    /******************/
    run addNode in hGenXml (iFirstId, "TypeoforderUrgency":U, tt-ord-manut-api.urgencia, output iId).
    run addNode in hGenXml (iFirstId, "Maintenance":U, "", output iId).
    /** Nodo Maintenance **/
        run addNode in hGenXml (iId, "MaintenanceType":U, tt-ord-manut-api.cd-tipo, output iIdMaintenance).
        for first tipo-manut
            where tipo-manut.cd-tipo = tt-ord-manut-api.cd-tipo no-lock:
            run addNode in hGenXml (iId, "MaintenanceTypeDescription":U, tipo-manut.descricao, output iIdMaintenance).
        end.
    /**********************/
    run addNode in hGenXml (iFirstId, "TagFunction":U, "", output iId).
    /** Nodo TagFunction **/
        run addNode in hGenXml (iId, "FunctionalLocationTag":U, tt-ord-manut-api.cd-tag, output iIdTagFunction).
        for first tag
            where tag.cd-tag = tt-ord-manut-api.cd-tag no-lock:
            run addNode in hGenXml (iId, "FunctionalLocationTagDescription":U, tag.descricao, output iIdTagFunction).
        end.
    /**********************/
    run addNode in hGenXml (iFirstId, "BusinessUnit":U, "", output iId).
    /** Node BusinessUnit **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF  CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                       AND funcao.ativo     = YES) THEN DO:

            &IF DEFINED(bf_mnt_ems207) &THEN
                run addNode in hGenXml (iId, "FunctionalLocationBusinessUnit":U, tt-ord-manut-api.cod-unid-negoc, output iIdBusinessUnit).
                FOR FIRST unid-negoc
                    WHERE unid-negoc.cod-unid-negoc = tt-ord-manut-api.cod-unid-negoc NO-LOCK:
                    run addNode in hGenXml (iId, "FunctionalLocationBusinessUnitDescription":U, unid-negoc.des-unid-negoc, output iIdBusinessUnit).
                END.
            &ELSEIF DEFINED(bf_mnt_ems206b) &THEN
                run addNode in hGenXml (iId, "FunctionalLocationBusinessUnit":U, SUBSTRING(tt-ord-manut-api.char-1,19,3), output iIdBusinessUnit).
                FOR FIRST unid-negoc
                    WHERE unid-negoc.cod-unid-negoc = SUBSTRING(tt-ord-manut-api.char-1,19,3) NO-LOCK:
                    run addNode in hGenXml (iId, "FunctionalLocationBusinessUnitDescription":U, unid-negoc.des-unid-negoc, output iIdBusinessUnit).
                END.
            &ENDIF
        END.
    &ELSE
        run addNode in hGenXml (iId, "FunctionalLocationBusinessUnit":U, "", output iIdBusinessUnit).
        run addNode in hGenXml (iId, "FunctionalLocationBusinessUnitDescription":U, "", output iIdBusinessUnit).
    &ENDIF
    /***********************/
    run addNode in hGenXml (iFirstId, "ProjectControlOrderNumber":U, tt-ord-manut-api.num-ord-inv, output iId).
    run addNode in hGenXml (iFirstId, "Company":U, "", output iId).
    /** Novo Company **/
        run addNode in hGenXml (iId, "CompanyCode":U, tt-ord-manut-api.ep-codigo, output iIdCompany).
        for first empresa
            where empresa.ep-codigo = tt-ord-manut-api.ep-codigo no-lock:
            run addNode in hGenXml (iId, "CompanyName":U, empresa.razao-social, output iIdCompany).
        end.
    /******************/
    run addNode in hGenXml (iFirstId, "Equipment":U, "", output iId).
    /** Nodo Equipment **/
        run addNode in hGenXml (iId, "EquipmentCode":U, tt-ord-manut-api.cd-equipto, output iIdEquipment).
        for first equipto
            where equipto.cd-equipto = tt-ord-manut-api.cd-equipto no-lock:
            run addNode in hGenXml (iId, "EquipmentDescription":U, equipto.descricao, output iIdEquipment).
        end.
    /********************/
    run addNode in hGenXml (iFirstId, "MaintenanceDuration":U, tt-ord-manut-api.dur-man, output iId).
    run addNode in hGenXml (iFirstId, "TargetSite":U, "", output iId).
    /** Nodo TargetSite **/
        run addNode in hGenXml (iId, "TargetSiteCode":U, tt-ord-manut-api.cod-estabel, output iIdTargetSite).
        for first estabelec
            where estabelec.cod-estabel = tt-ord-manut-api.cod-estabel no-lock:
            run addNode in hGenXml (iId, "TargetSiteName":U, estabelec.nome, output iIdTargetSite).
        end.
    /*********************/
    run addNode in hGenXml (iFirstId, "UserLastAlterCode":U,     tt-ord-manut-api.usuario-alt, output iId).
    run addNode in hGenXml (iFirstId, "SummarizedorderNumber":U, tt-ord-manut-api.nr-ord-sum,  output iId).
    run addNode in hGenXml (iFirstId, "ProductionLine":U, "", output iId).
    /** Nodo ProductionLine **/
        run addNode in hGenXml (iId, "ProductionLineOrderCode":U, tt-ord-manut-api.nr-linha, output iIdProductionLine).
        for first lin-prod
            where lin-prod.nr-linha = tt-ord-manut-api.nr-linha no-lock:
            run addNode in hGenXml (iId, "ProductionLineOrderDescription":U, lin-prod.descricao, output iIdProductionLine).
        end.
    /*************************/
    run addNode in hGenXml (iFirstId, "EquipmentFamily":U, "", output iId).
    /** Nodo EquipmentFamily **/
        run addNode in hGenXml (iId, "EquipmentFamilyCode":U, tt-ord-manut-api.fm-equipto, output iIdEquipmentFamily).
        for first fam-equipto
            where fam-equipto.fm-equipto = tt-ord-manut-api.fm-equipto no-lock:
            run addNode in hGenXml (iId, "EquipmentFamilyDescription":U, fam-equipto.descricao, output iIdEquipmentFamily).
        end.
    /**************************/
END PROCEDURE.

PROCEDURE piCriaXml-2:
    run addNode in hGenXml (iFirstId, "MaintenanceOrderMessageinformationType":U, "", output iId).
    /** Node MaintenanceOrderMessageinformationType **/
        run addNode in hGenXml (iId, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdMaintenanceOrderMessageinf).
        for first msg-ord-man
            where msg-ord-man.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "MaintenanceOrderText":U, msg-ord-man.msg-exp, output iIdMaintenanceOrderMessageinf).
        end.
    /*************************************************/
    run addNode in hGenXml (iFirstId, "ListofindividualProtectionEquipment":U, "", output iId).
    /** Node ListofindividualProtectionEquipment **/
        for each ord-epi
            where ord-epi.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "individualProtectionEquipmentCode":U, "", output iIdListofindividualProtecEquip).
            /** Node individualProtectionEquipmentCode **/
                run addNode in hGenXml (iIdListofindividualProtecEquip, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdindividualProtectionEquipCode).
                run addNode in hGenXml (iIdListofindividualProtecEquip, "individualProtectionEquipment":U, "", output iIdindividualProtectionEquipCode).
                /** Nodo individualProtectionEquipment **/
                    run addNode in hGenXml (iIdindividualProtectionEquipCode, "individualProtectionEquipmentCode":U, ord-epi.cd-epi, output iIdindividualProtectionEquipment).
                    for first epi
                        where epi.cd-epi = ord-epi.cd-epi no-lock:
                        run addNode in hGenXml (iIdindividualProtectionEquipCode, "individualProtectionEquipmentDescription":U, epi.descricao, output iIdindividualProtectionEquipment).
                    end.
                /****************************************/
                run addNode in hGenXml (iIdListofindividualProtecEquip, "MaintenanceTask":U, "", output iIdindividualProtectionEquipCode).
                /** Node MaintenanceTask **/
                    run addNode in hGenXml (iIdindividualProtectionEquipCode, "MaintenanceTaskCode":U, ord-epi.cd-tarefa, output iIdMaintenanceTask).
                    for first ord-taref
                        where ord-taref.cd-tarefa = ord-epi.cd-tarefa no-lock:
                        run addNode in hGenXml (iIdindividualProtectionEquipCode, "MaintenanceTaskDescription":U, ord-taref.descricao, output iIdMaintenanceTask).
                    end.
                /**************************/
            /********************************************/
        end.
    /**********************************************/
    run addNode in hGenXml (iFirstId, "ListofSpecialtyTaskMaintenanceOrder":U, "", output iId).
    /** ListofSpecialtyTaskMaintenanceOrder **/
        for each ord-esp
            where ord-esp.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:           
            run addNode in hGenXml (iId, "SpecialtyTaskofMaintenanceOrderType":U, "", output iIdListofSpecialtyTaskMaintOrder).
            /** Node SpecialtyTaskofMaintenanceOrderType **/
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "Speciality":U, "", output iIdSpecialtyTaskofMaintOrderType).
                /** Node Speciality **/
                    run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "SpecialityCode":U, ord-esp.tp-especial, output iIdSpeciality).
                    for first mi-espec
                        where mi-espec.tp-especial = ord-esp.tp-especial no-lock:
                        run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "SpecialityDescription":U, mi-espec.descricao, output iIdSpeciality).
                    end.
                /*********************/
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "MaintenanceTask":U, "", output iIdSpecialtyTaskofMaintOrderType).
                /** Node MaintenanceTask **/
                    run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "MaintenanceTaskCode":U, ord-esp.cd-tarefa, output iIdMaintenanceTaskAux).
                    for first ord-taref
                        where ord-taref.cd-tarefa = ord-epi.cd-tarefa no-lock:
                        run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdMaintenanceTaskAux).
                    end.
                /***************************/
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "CrewSizeWorkingOnTask":U, ord-esp.nr-homens, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "NumberofDaysOutofPhaseFromendofPeriod":U, ord-esp.nr-dias-dur, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TotalTimeforExecutionofTask":U, ord-esp.tempo, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TaskTimeAlreadyReported":U, ord-esp.tempo-rep, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "isSpecialtyTaskClosed":U, ord-esp.encerrada, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TaskConclusionPercent":U, ord-esp.conclusao, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "MinimunDailyAllocationforSpecialty":U, ord-esp.aloc-minima, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "MaximumDailyAllocationforSpecialty":U, ord-esp.aloc-maxima, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TypeofSpecialtyforCalculation":U, ord-esp.tipo-espec, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TypeofSpecialtyTime":U, ord-esp.tipo-tempo, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "TextofSpecialtyofTask":U, ord-esp.msg-exp, output iIdSpecialtyTaskofMaintOrderType).
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "CalendarProduction":U, "", output iIdSpecialtyTaskofMaintOrderType).
                /** Node CalendarProduction **/
                    run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "CalendarofProductionCode":U, ord-esp.cd-calen, output iIdCalendarProduction).
                    for first calen-gener
                        where calen-gener.cd-calen = ord-esp.cd-calen no-lock:
                        run addNode in hGenXml (iIdSpecialtyTaskofMaintOrderType, "CalendarofProductionDescription":U, calen-gener.descricao, output iIdCalendarProduction).
                    end.
                /*****************************/
                run addNode in hGenXml (iIdListofSpecialtyTaskMaintOrder, "SpecialtyEfficiencyPercent":U, ord-esp.eficiencia, output iIdSpecialtyTaskofMaintOrderType).
            /**********************************************/
        end.
    /*****************************************/
END PROCEDURE.

PROCEDURE piCriaXml-3:
    run addNode in hGenXml (iFirstId, "ListofToolofTaskMaintenanceOrder":U, "", output iId).
    /** Node ListofToolofTaskMaintenanceOrder **/
    for each ord-ferr
        where ord-ferr.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
        run addNode in hGenXml (iId, "ToolofTaskMaintenanceOrderType":U, "", output iIdListofToolofTaskMainOrder).
        /** Node ToolofTaskMaintenanceOrderType **/
            run addNode in hGenXml (iIdListofToolofTaskMainOrder, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdToolofTaskMainOrderType).    
            run addNode in hGenXml (iIdListofToolofTaskMainOrder, "MaintenanceTask":U, "", output iIdToolofTaskMainOrderType).
            /** Node MaintenanceTask **/
                run addNode in hGenXml (iIdToolofTaskMainOrderType, "MaintenanceTaskCode":U, ord-ferr.cd-tarefa, output iIdMaintenanceTaskAux2).
                for first ord-taref
                    where ord-taref.cd-tarefa = ord-ferr.cd-tarefa no-lock:
                    run addNode in hGenXml (iIdToolofTaskMainOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdMaintenanceTaskAux2).
                end.                        
            /**************************/
            run addNode in hGenXml (iIdListofToolofTaskMainOrder, "ToolType":U, "", output iIdToolofTaskMainOrderType).
            /** Node ToolType **/
                run addNode in hGenXml (iIdToolofTaskMainOrderType, "ToolTypeTask":U, ord-ferr.cd-tp-ferr, output iIdToolType).
                for first tp-ferr
                    where tp-ferr.cd-tp-ferr = ord-ferr.cd-tp-ferr no-lock:
                    run addNode in hGenXml (iIdToolofTaskMainOrderType, "ToolDescription":U, tp-ferr.descricao, output iIdToolType).
                end.
            /*******************/
            run addNode in hGenXml (iIdListofToolofTaskMainOrder, "TimeDuringWhichToolWillBeUsed":U, ord-ferr.tempo, output iIdToolofTaskMainOrderType).
        /*****************************************/
    end.
    /*******************************************/
    run addNode in hGenXml (iFirstId, "ListofProcessSheetMaintenanceOrder":U, "", output iId).
    /** Nodo ListofProcessSheetMaintenanceOrder **/
        for each ord-fich-met
            where ord-fich-met.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "ProcessSheetofMaintenanceOrderType":U, "", output iIdListofProcessSheetMainOrder).
            /** Node ProcessSheetofMaintenanceOrderType **/
                run addNode in hGenXml (iIdListofProcessSheetMainOrder, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdProcessSheetofMainOrderType).
                run addNode in hGenXml (iIdListofProcessSheetMainOrder, "MaintenanceTask":U, "", output iIdProcessSheetofMainOrderType).
                /** Node MaintenanceTask **/
                    run addNode in hGenXml (iIdProcessSheetofMainOrderType, "MaintenanceTaskCode":U, ord-fich-met.cd-tarefa, output iIdMaintenanceTaskAux3).
                    for first ord-taref
                        where ord-taref.cd-tarefa = ord-fich-met.cd-tarefa no-lock:
                        run addNode in hGenXml (iIdProcessSheetofMainOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdMaintenanceTaskAux3).
                    end.
                /**************************/
                run addNode in hGenXml (iIdListofProcessSheetMainOrder, "ProcessSheet":U, "", output iIdProcessSheetofMainOrderType).
                /** Node ProcessSheet **/
                    run addNode in hGenXml (iIdProcessSheetofMainOrderType, "ProcessSheetCode":U, ord-fich-met.fi-codigo, output iIdProcessSheet).
                    for first mnt-ficha-metodo
                        where mnt-ficha-metodo.fi-codigo = ord-fich-met.fi-codigo no-lock:
                        run addNode in hGenXml (iIdProcessSheetofMainOrderType, "ProcessSheetDescription":U, mnt-ficha-metodo.descricao, output iIdProcessSheet).
                    end.
                /***********************/
            /*********************************************/
        end.
    /*********************************************/
    run addNode in hGenXml (iFirstId, "ListofShiftofMaintenanceOrder":U, "", output iId).
    /** Node ListofShiftofMaintenanceOrder **/
        for each ord-turno
            where ord-turno.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "ShiftofMaintenanceOrderType":U, "", output iIdListofShiftofMainOrder).
            /** Node ShiftofMaintenanceOrderType **/
                run addNode in hGenXml (iIdListofShiftofMainOrder, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdShiftofMainOrderType).
                run addNode in hGenXml (iIdListofShiftofMainOrder, "MaintenanceTask":U, "", output iIdShiftofMainOrderType).
                /** Node MaintenanceTask **/
                    run addNode in hGenXml (iIdShiftofMainOrderType, "MaintenanceTaskCode":U, ord-turno.cd-tarefa, output iIdMaintenanceTaskAux4).
                    for first ord-taref
                        where ord-taref.cd-tarefa = ord-turno.cd-tarefa no-lock:
                        run addNode in hGenXml (iIdShiftofMainOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdMaintenanceTaskAux4).
                    end.
                /**************************/
                run addNode in hGenXml (iIdListofShiftofMainOrder, "Shift":U, "", output iIdShiftofMainOrderType).
                /** Node Shift **/
                    run addNode in hGenXml (iIdShiftofMainOrderType, "ShiftCode":U, ord-turno.cd-turno, output iIdShift).
                    for first mi-turno
                        where mi-turno.cd-turno = ord-turno.cd-turno no-lock:
                        run addNode in hGenXml (iIdShiftofMainOrderType, "ShiftDescription":U, mi-turno.descricao, output iIdShift).
                    end.
                /****************/
            /**************************************/   
        end.
    /****************************************/
    run addNode in hGenXml (iFirstId, "ListofPertTaskMaintenanceOrder":U, "", output iId).
    /** Node ListofPertTaskMaintenanceOrder **/
        FOR EACH p-ord-esp
            WHERE p-ord-esp.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:                    
            run addNode in hGenXml (iId, "PertTaskMaintenanceOrderType":U, "", output iIdListofPertTaskMainOrder).
            /** Node PertTaskMaintenanceOrderType **/
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "MaintenanceTask":U, "", output iIdPertTaskMaintenanceOrderType).
                /** Node MaintenanceTask **/
                    run addNode in hGenXml (iIdPertTaskMaintenanceOrderType, "MaintenanceTaskCode":U, p-ord-esp.cd-tarefa, output iIdMaintenanceTask3).
                    FOR FIRST ord-taref
                        WHERE ord-taref.cd-tarefa = p-ord-esp.cd-tarefa NO-LOCK:
                        run addNode in hGenXml (iIdPertTaskMaintenanceOrderType, "MaintenanceDescriptionTask":U, ord-taref.descricao, output iIdMaintenanceTask3).
                    END.
                /**************************/
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "PrecedingTask":U, "", output iIdPertTaskMaintenanceOrderType).
                /** Node PrecedingTask **/
                    run addNode in hGenXml (iIdPertTaskMaintenanceOrderType, "PrecedingTaskCode":U, p-ord-esp.taref-pred, output iIdPrecedingTask).
                    FOR FIRST ord-taref
                        WHERE ord-taref.cd-tarefa = p-ord-esp.taref-pred NO-LOCK:
                        run addNode in hGenXml (iIdPertTaskMaintenanceOrderType, "PrecedingTaskDescription":U, ord-taref.descricao, output iIdPrecedingTask).
                    END.
                /************************/
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "OverlapTimeBetweenTask":U, p-ord-esp.overlap, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "OverlapType":U, p-ord-esp.tipo-overlap, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "TotalOverlapTime":U, p-ord-esp.tempo-overlap, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "MinimumWaitTime":U, p-ord-esp.tempo-espera-min, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "PrecedingOrderNumber":U, p-ord-esp.nr-ord-predec, output iIdPertTaskMaintenanceOrderType).
                run addNode in hGenXml (iIdListofPertTaskMainOrder, "SummarizedOrderNumber":U, p-ord-esp.nr-ord-sum, output iIdPertTaskMaintenanceOrderType).
            /***************************************/
        END.
        /***************************************/
END PROCEDURE.

PROCEDURE piMaintenanceOrderFunction:
    /**************************/
    run addNode in hGenXml (iFirstId, "MaintenanceOrderFunction":U, "", output iId).
    /** Nodo MaintenanceOrderFunction **/
        run addNode in hGenXml (iId, "PlanninginformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Nodo PlanninginformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "Planner":U, "", output iIdPlanninginformationOrder).
            /** Nodo Planner **/
                run addNode in hGenXml (iIdPlanninginformationOrder, "PlannerCode":U, tt-ord-manut-api.cd-manut, output iIdPlannerAux).
                for first manut
                    where manut.cd-manut = tt-ord-manut-api.cd-manut no-lock:
                    run addNode in hGenXml (iIdPlanninginformationOrder, "PlannerDescription":U, manut.descricao, output iIdPlannerAux).
                end.
            /******************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "AccountantValue":U,  tt-ord-manut-api.vl-contador,  output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "AlocateformOrder":U, tt-ord-manut-api.sit-aloc,     output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "TaskReleaseType":U,  tt-ord-manut-api.liber-tarefa, output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "MainanceSpecialty":U, "",                           output iIdPlanninginformationOrder).
            /** Nodo MainanceSpecialty **/
                run addNode in hGenXml (iIdPlanninginformationOrder, "MainanceSpecialtyCode":U, tt-ord-manut-api.tp-esp-prin, output iIdMainanceSpecialty).
                for first mi-espec
                    where mi-espec.tp-especial = tt-ord-manut-api.tp-esp-prin no-lock:
                    run addNode in hGenXml (iIdPlanninginformationOrder, "MainanceSpecialtyDescription":U, mi-espec.descricao, output iIdMainanceSpecialty).
                end.
            /***********************************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "SpecialityAllocationType":U,      tt-ord-manut-api.forma-aloc-esp,    output iIdPlanninginformationOrder). /** VERifICAR **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isHasMarkedTask":U,               tt-ord-manut-api.possui-taref-marc, output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ReallocationDate":U,              tt-ord-manut-api.dt-realoc,         output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "AmtofAccountAccumEquipment":U,    tt-ord-manut-api.vl-cont-acum,      output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "NumberofLastSequenceofTasks":U,   tt-ord-manut-api.nr-ult-seq,        output iIdPlanninginformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "PlanOriginatingScheduledorder":U, tt-ord-manut-api.plano-orig,        output iIdPlanninginformationOrder).
        /**************************************/
        run addNode in hGenXml (iId, "DateinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Nodo DateinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "MaintenanceDate":U,            tt-ord-manut-api.dt-manut,                output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "endDateOrder":U,               tt-ord-manut-api.dt-fecham,               output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "endforecastDate":U,            tt-ord-manut-api.dt-prev,                 output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "EarliestStartDate":U,          tt-ord-manut-api.dt-ini-cedo,             output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "LatestStartDate":U,            tt-ord-manut-api.dt-ini-tarde,            output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OriginalStartDate":U,          tt-ord-manut-api.dt-ini-orig,             output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OrderReopeningDate":U,         tt-ord-manut-api.dt-reabre,               output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ExpectativeMaintenanceDate":U, tt-ord-manut-api.dt-prev-manut,           output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "CreateDateMaintenanceOrder":U, substring(tt-ord-manut-api.char-1,1,10),  output iIdDateinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "CreateTimeMaintenanceOrder":U, substring(tt-ord-manut-api.char-1,11,16), output iIdDateinformationOrder).
        /*******************************/
        run addNode in hGenXml (iId, "StatusinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Nodo StatusinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isClosedOrderMaintenance":U,          tt-ord-manut-api.om-encerrada, output iIdStatusinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "SummarizedMaintenanceOrderState":U, tt-ord-manut-api.estado-om,    output iIdStatusinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "MaintenanceOrderState":U,           tt-ord-manut-api.estado,       output iIdStatusinformationOrder).
        /*********************************/
        run addNode in hGenXml (iId, "StopPlaninformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Nodo StopPlaninformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "StopPlanSequence":U, tt-ord-manut-api.sequencia, output iIdStopPlaninformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "StopPlan":U, "", output iIdStopPlaninformationOrder).
            /** Nodo StopPlan **/
                run addNode in hGenXml (iIdStopPlaninformationOrder, "StopPlanCode":U, tt-ord-manut-api.cd-parada, output iIdStopPlan).
                for first mi-parada
                    where mi-parada.cd-parada = tt-ord-manut-api.cd-parada no-lock:
                    run addNode in hGenXml (iIdStopPlaninformationOrder, "StopPlandescription":U, mi-parada.descricao, output iIdStopPlan).
                end.
            /*******************/
        /***********************************/
        run addNode in hGenXml (iId, "FailInformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Nodo StopPlaninformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "Cause":U, "", output iIdFailInformationOrder).
            /** Nodo Cause **/
                run addNode in hGenXml (iIdFailInformationOrder, "CauseCode":U, tt-ord-manut-api.cd-causa-padr, output iIdCause).
                FOR FIRST causa-padrao
                    WHERE causa-padrao.cd-causa-padr = tt-ord-manut-api.cd-causa-padr NO-LOCK:
                    run addNode in hGenXml (iIdFailInformationOrder, "CauseDescription":U, causa-padrao.descricao, output iIdCause).
                END.                        
            /****************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "StandardSympton":U, "", output iIdFailInformationOrder).
            /** StandardSympton **/
                run addNode in hGenXml (iIdFailInformationOrder, "StandardSymptonCode":U, tt-ord-manut-api.cd-sint-padr, output iIdStandardSympton).
                FOR FIRST sint-padrao
                    WHERE sint-padrao.cd-sint-padr = tt-ord-manut-api.cd-sint-padr NO-LOCK:
                    run addNode in hGenXml (iIdFailInformationOrder, "StandardSymptonDescription":U, sint-padrao.descricao, output iIdStandardSympton).
                END.
            /*********************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "Intervencion":U, "", output iIdFailInformationOrder).
            /** Intervencion **/
                run addNode in hGenXml (iIdFailInformationOrder, "IntervencionCode":U, tt-ord-manut-api.cd-interv-padr, output iIdIntervencion).
                FOR FIRST interv-padrao
                    WHERE interv-padrao.cd-interv-padr = tt-ord-manut-api.cd-interv-padr NO-LOCK:
                    run addNode in hGenXml (iIdFailInformationOrder, "IntervencionDescription":U, interv-padrao.descricao, output iIdIntervencion).
                END.
            /******************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "Holdover":U, "", output iIdFailInformationOrder).
            /** Node Holdover **/
                run addNode in hGenXml (iIdFailInformationOrder, "HoldoverCode":U, tt-ord-manut-api.cd-pend-padr, output iIdHoldover).
                FOR FIRST pend-padrao
                    WHERE pend-padrao.cd-pend-padr = tt-ord-manut-api.cd-pend-padr NO-LOCK:
                    run addNode in hGenXml (iIdFailInformationOrder, "HoldoverDescription":U, pend-padrao.descricao, output iIdHoldover).
                END.
            /*******************/
        /***********************************/
        run addNode in hGenXml (iId, "inspectioninformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Node inspectioninformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ReadingValue":U, tt-ord-manut-api.vl-leitura, output iIdinspectioninformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ReadingDate":U,  tt-ord-manut-api.dt-leitura,  output iIdinspectioninformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "Warning":U, "", output iIdinspectioninformationOrder).
            /** Node Warning **/
                run addNode in hGenXml (iIdinspectioninformationOrder, "WarningCode":U, tt-ord-manut-api.al-codigo, output iIdWarning).
                for first alerta
                    where alerta.al-codigo = tt-ord-manut-api.al-codigo no-lock:
                    run addNode in hGenXml (iIdinspectioninformationOrder, "WarningDescription":U, alerta.descricao, output iIdWarning).
                end.                        
            /******************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "inspectionRouting":U, "", output iIdinspectioninformationOrder).
            /** Node inspectionRouting **/
                run addNode in hGenXml (iIdinspectioninformationOrder, "inspectionRoutingNumber":U, tt-ord-manut-api.nr-rot-insp, output iIdinspectionRouting).
                for first rot-inspecao
                    where rot-inspecao.nr-rot-insp = tt-ord-manut-api.nr-rot-insp no-lock:
                    run addNode in hGenXml (iIdinspectioninformationOrder, "inspectionRoutingDescription":U, rot-inspecao.descricao, output iIdinspectionRouting).
                end.
            /****************************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "inspection":U, "", output iIdinspectioninformationOrder).
            /** Node inspection **/
                run addNode in hGenXml (iIdinspectioninformationOrder, "inspectionCode":U, tt-ord-manut-api.cd-inspecao, output iIdinspection).
                for first inspec
                    where inspec.cd-inspecao = tt-ord-manut-api.cd-inspecao no-lock:
                    run addNode in hGenXml (iIdinspectioninformationOrder, "inspectionDescription":U, inspec.descricao, output iIdinspection).
                end.
            /*********************/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isReadingLog":U, tt-ord-manut-api.apont-leit, output iIdinspectioninformationOrder).
        /*************************************/
        run addNode in hGenXml (iId, "LubrificationinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Node LubrificationinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "LubrificationRoutingNumber":U, tt-ord-manut-api.nr-rot-lubr, output iIdLubrificationinformationOrder).
            for first rot-lubrific
                where rot-lubrific.nr-rot-lubr = tt-ord-manut-api.nr-rot-lubr no-lock:
                run addNode in hGenXml (iIdMaintenanceOrderFunction, "LubrificationRoutingDescription":U, rot-lubrific.descricao, output iIdLubrificationinformationOrder).
            end.
        /****************************************/
        run addNode in hGenXml (iId, "documentinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Node documentinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "AttachmentdocumentCode":U, tt-ord-manut-api.cod-docto-anexo, output iIddocumentinformationOrder).
            for first docto_anexo
                where docto_anexo.cod_docto_anexo = tt-ord-manut-api.cod-docto-anexo no-lock:
                run addNode in hGenXml (iIdMaintenanceOrderFunction, "AttachmentdocumentDescription":U, docto_anexo.des_docto_anexo, output iIddocumentinformationOrder).
            end.
        /***********************************/
        run addNode in hGenXml (iId, "CostinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Node CostinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OrderAccount":U, tt-ord-manut-api.ct-codigo, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OrderSub-Account":U, tt-ord-manut-api.sc-codigo, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ExpenseOrderAccount":U, tt-ord-manut-api.ct-desp, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ExpenseOrderSub-Account":U, tt-ord-manut-api.sc-desp, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ReportLabor":U, tt-ord-manut-api.reporte-mob, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "ReportOverHead":U, tt-ord-manut-api.reporte-ggf, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "MaterialCostCalculationType":U, tt-ord-manut-api.calc-cs-mat, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "LaborCostCalculationProportionType":U, tt-ord-manut-api.calc-cs-mob, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OverHeadCostCalculationProportionType":U, tt-ord-manut-api.calc-cs-ggf, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "MaterialDisbursemntCalculationType":U, tt-ord-manut-api.custeio-prop-mat, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "LaborDisbursemntCalculationType":U, tt-ord-manut-api.custeio-prop-mob, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "OverHeadDisbursemntCalculationType":U, tt-ord-manut-api.custeio-prop-ggf, output iIdCostinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isValuedorder":U, tt-ord-manut-api.valorizada, output iIdCostinformationOrder).
        /*******************************/
        run addNode in hGenXml (iId, "ReportinformationOrder":U, "", output iIdMaintenanceOrderFunction).
        /** Node ReportinformationOrder **/
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isPrintRequisition":U, tt-ord-manut-api.emite-requis, output iIdReportinformationOrder).
            run addNode in hGenXml (iIdMaintenanceOrderFunction, "isPrintOrder":U, tt-ord-manut-api.emite-ordem, output iIdReportinformationOrder).
        /*********************************/
END PROCEDURE.

PROCEDURE piListofTaskofMaintenanceOrder:
    run addNode in hGenXml (iFirstId, "ListofTaskofMaintenanceOrder":U, "", output iId).
    /** Node ListofTaskofMaintenanceOrder **/
        for each ord-taref
            where ord-taref.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "TaskofMaintenanceOrderType":U, "", output iIdListofTaskofMaintenanceOrder).
            /** Node TaskofMaintenanceOrderType **/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "BasicinformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node BasicinformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MaintenanceOrderNumber":U, tt-ord-manut-api.nr-ord-produ, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MaintenanceTask":U, ord-taref.cd-tarefa, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TotalTimeforTaskExecutioninHours":U, ord-taref.tempo, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "RealTimeUsedonTask":U, ord-taref.tempo-real, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TextTaskOrder":U, ord-taref.narrativa, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "CrewNecessaryforThisMaintenance":U, ord-taref.nr-homem, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "isTaskClosed":U, ord-taref.encerrada, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "StandardMaintenanceTaskCode":U, ord-taref.cd-taref-padr, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "SequenceTask":U, ord-taref.sequencia, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskState":U, ord-taref.sequencia, output iIdBasicinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "isMandatoryTask":U, ord-taref.tar-obrigatoria, output iIdBasicinformationTask).
                /*******************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "CalibrationinformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node CalibrationinformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "VariableChecked":U, ord-taref.var-afer, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "isEnterGaugingStandard":U, ord-taref.inf-padrao, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "StandardAmount":U, ord-taref.vl-padrao, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "VariableType":U, ord-taref.tp-variavel, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "LowerVariance":U, ord-taref.var-menor, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "GreaterVariance":U, ord-taref.var-maior, output iIdCalibrationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "UnitofMeasureCode":U, ord-taref.un-medida, output iIdCalibrationinformationTask).
                    for first tab-unidade
                        where tab-unidade.un = ord-taref.un-medida no-lock:
                        run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "UnitofMeasureDescription":U, ord-taref.un-medida, output iIdBasicinformationTask).
                    end.
                /*************************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "LubrificationinformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node LubrificationinformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "NumberofLubrificationPoint":U, ord-taref.nr-pontos, output iIdLubrificationinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MaintenanceTaskTracing":U, ord-taref.local-taref, output iIdLubrificationinformationTask).
                /***************************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "AcceptinformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node AcceptinformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "isTaskAccepted":U, ord-taref.aceite, output iIdAcceptinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "isTaskAlreadyAccepted":U, ord-taref.sit-aceite, output iIdAcceptinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "Acceptancenotes":U, ord-taref.obs-aceite, output iIdAcceptinformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "ResponsibleAcceptCode":U, ord-taref.nome-abrev, output iIdAcceptinformationTask).
                    for first usuar-mater
                        where usuar-mater.cod-usuario = ord-taref.nome-abrev no-lock:
                        run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "ResponsibleAcceptName":U, usuar-mater.nome-usuar, output iIdAcceptinformationTask).
                    end.
                /********************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "documentsinformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node documentsinformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "VideoCode":U, ord-taref.cod-video, output iIddocumentsinformationTask).
                    for first video
                        where video.cod_video = ord-taref.cod-video no-lock:
                        run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "VideoDescription":U, video.des_video, output iIddocumentsinformationTask).
                    end.
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "ImageCode":U, ord-taref.cod-imagem, output iIddocumentsinformationTask).
                    for first imagem
                        where imagem.cod_imagem = ord-taref.cod-imagem no-lock:
                        run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "ImageDescription":U, imagem.des_imagem, output iIddocumentsinformationTask).
                    end.
                /***********************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "SummarizedorderTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node SummarizedorderTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "SummarizedorderNumber":U, ord-taref.nr-ord-sum, output iIdSummarizedorderTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "PrincipalSummarizedorderNumber":U, ord-taref.nr-ord-princ, output iIdSummarizedorderTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MaintenanceTaskPrincipal":U, ord-taref.cd-tarefa-princ, output iIdSummarizedorderTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "DescriptionTask":U, ord-taref.descricao, output iIdSummarizedorderTask).
                /******************************/
                run addNode in hGenXml (iIdListofTaskofMaintenanceOrder, "PlanninginformationTask":U, "", output iIdTaskofMaintenanceOrderType).
                /** Node PlanninginformationTask **/
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "AnticipationDays":U, ord-taref.dias-antec, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskReleaseState":U, ord-taref.est-liber, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MarkedStartDate":U, ord-taref.dt-inicio-marc, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "MarkedTermDate":U, ord-taref.dt-termino-marc, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskStartDate":U, ord-taref.dt-inicio, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskStartTime":U, ord-taref.hora-inicio, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskendDate":U, ord-taref.dt-termino, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskendTime":U, ord-taref.hora-termino, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "PERTNetworkTaskStartDate":U, ord-taref.dt-inic-pert, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskStartTimeofPERTNet":U, ord-taref.hora-inic-pert, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "IsSpecialtiesofTaskThatWorkSimultaneous":U, ord-taref.exec-simul, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskStartDateBaseline":U, ord-taref.bl-dt-inicio, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskStartTimeBaseline":U, ord-taref.bl-hora-inicio, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskendDateBaseline":U, ord-taref.bl-dt-termino, output iIdPlanninginformationTask).
                    run addNode in hGenXml (iIdTaskofMaintenanceOrderType, "TaskendTimeBaseline":U, ord-taref.bl-hora-termino, output iIdPlanninginformationTask).
                /**********************************/
            /*************************************/
    end.
END PROCEDURE.
PROCEDURE PiListofReserveinformation:
    /***********************************/
    run addNode in hGenXml (iFirstId, "ListofReserveinformation":U, "", output iId).
    /** Node ListofReserveinformation **/
        for each reservas
            where reservas.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
            run addNode in hGenXml (iId, "Reserveinformation":U, "", output iIdListofReserveinformation).
            /** Node Reserveinformation **/
                run addNode in hGenXml (iIdListofReserveinformation, "ReserveItemCode":U, reservas.it-codigo, output iIdReserveinformation).
                for first item
                    where item.it-codigo = reservas.it-codigo no-lock:
                    run addNode in hGenXml (iIdListofReserveinformation, "ReserveItemDescription":U, item.desc-item, output iIdReserveinformation).
                end.
                run addNode in hGenXml (iIdListofReserveinformation, "ReserveDate":U, reservas.dt-reserva, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "UpdateType":U, reservas.tp-atualiza, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "LotOrSerialNumber":U, reservas.lote-serie, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "isPrintRequisition":U, reservas.emite-requis, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "ReserveStatus":U, reservas.estado, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "ReserveSource":U, reservas.origem, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "RoutingCode":U, reservas.cod-roteiro, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "SurplusType":U, reservas.tipo-sobra, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "Reference":U, "", output iIdReserveinformation).
                /** Node Reference **/
                    run addNode in hGenXml (iIdReserveinformation, "ReferenceCode":U, reservas.cod-refer, output iIdReferenceAux).
                    for first referencia
                        where referencia.cod-refer = reservas.cod-refer no-lock:
                        run addNode in hGenXml (iIdReserveinformation, "ReferenceDescription":U, referencia.descricao, output iIdReferenceAux).
                    end.
                /********************/
                run addNode in hGenXml (iIdListofReserveinformation, "LubrificationType":U, reservas.cd-lubr, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "ReferenceOrder":U, reservas.nr-ord-refer, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "SummarizedRequisition":U, reservas.nr-req-sum, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "LocationCode":U, reservas.cod-localiz, output iIdReserveinformation).
                run addNode in hGenXml (iIdListofReserveinformation, "ComponentsList":U, reservas.cod-lista-compon, output iIdReserveinformation).
                &IF DEFINED(bf_mnt_ems205) &THEN
                    run addNode in hGenXml (iIdListofReserveinformation, "PartsforMilion":U, reservas.per-ppm, output iIdReserveinformation).
                    run addNode in hGenXml (iIdListofReserveinformation, "isVehicle":U, reservas.veiculo, output iIdReserveinformation).
                    run addNode in hGenXml (iIdListofReserveinformation, "Compositionformula":U, reservas.tipo-formula, output iIdReserveinformation).
                &ELSE
                    run addNode in hGenXml (iIdListofReserveinformation, "PartsforMilion":U, "", output iIdReserveinformation).
                    run addNode in hGenXml (iIdListofReserveinformation, "isVehicle":U, "", output iIdReserveinformation).
                    run addNode in hGenXml (iIdListofReserveinformation, "Compositionformula":U, "", output iIdReserveinformation).
                &ENDIF
                run addNode in hGenXml (iIdListofReserveinformation, "Operationinformations":U, "", output iIdReserveinformation).
                /** Node Operationinformations **/
                    run addNode in hGenXml (iIdReserveinformation, "OperationCode":U, reservas.op-codigo, output iIdoperationinformations).
                    for first oper-ord
                        where oper-ord.op-codigo = reservas.op-codigo no-lock:
                        run addNode in hGenXml (iIdReserveinformation, "OperationDescription":U, oper-ord.descricao, output iIdoperationinformations).                                
                    end.
                    for first ord-rep
                        where ord-rep.nr-ord-produ = tt-ord-manut-api.nr-ord-produ no-lock:
                        run addNode in hGenXml (iIdReserveinformation, "OrderOperationSequenceNumber":U, ord-rep.op-seq, output iIdoperationinformations).
                    end.
                /********************************/
                run addNode in hGenXml (iIdListofReserveinformation, "WareHouse":U, "", output iIdReserveinformation).
                /** WareHouse **/
                    run addNode in hGenXml (iIdReserveinformation, "WareHouseCode":U, reservas.cod-depos, output iIdWareHouseAux).
                    for first deposito
                        where deposito.cod-depos = reservas.cod-depos no-lock:
                        run addNode in hGenXml (iIdReserveinformation, "WareHouseDescription":U, deposito.nome, output iIdWareHouseAux).
                    end.
                /***************/
                run addNode in hGenXml (iIdListofReserveinformation, "UnitofMeasure":U, "", output iIdReserveinformation).
                /** Node UnitofMeasure **/
                    run addNode in hGenXml (iIdReserveinformation, "UnitofMeasureCode":U, reservas.un, output iIdUnitofMeasure).
                    for first tab-unidade
                        where tab-unidade.un = reservas.un no-lock:
                        run addNode in hGenXml (iIdReserveinformation, "UnitofMeasureDescription":U, tab-unidade.descricao, output iIdUnitofMeasure).
                    end.
                /************************/
                run addNode in hGenXml (iIdListofReserveinformation, "QuantityofReservesinformation":U, "", output iIdReserveinformation).
                /** Node QuantityofReservesinformation **/
                    run addNode in hGenXml (iIdReserveinformation, "QuantityofReserve":U, reservas.quant-orig,            output iIdQuantityofReservesinfo).
                    run addNode in hGenXml (iIdReserveinformation, "ProcessedQuantity":U, reservas.quant-atend,           output iIdQuantityofReservesinfo).
                    run addNode in hGenXml (iIdReserveinformation, "RequisitedQuantity":U, reservas.quant-requis,         output iIdQuantityofReservesinfo).
                    run addNode in hGenXml (iIdReserveinformation, "AllocationQuantity":U, reservas.quant-atend,          output iIdQuantityofReservesinfo).
                    run addNode in hGenXml (iIdReserveinformation, "ThirdQuantity":U, reservas.quant-terc,                output iIdQuantityofReservesinfo).
                    run addNode in hGenXml (iIdReserveinformation, "investedQuantity":U, reservas.quant-aplic,            output iIdQuantityofReservesinfo).
                    &IF DEFINED(bf_mnt_ems205) &THEN
                        run addNode in hGenXml (iIdReserveinformation, "PhysicalAllocationQuantity":U, reservas.qt-aloc-lote, output iIdQuantityofReservesinfo).
                        run addNode in hGenXml (iIdReserveinformation, "PhysicalProcessedQuantity":U, reservas.qt-atend-lote, output iIdQuantityofReservesinfo).
                    &ELSE
                        run addNode in hGenXml (iIdReserveinformation, "PhysicalAllocationQuantity":U, "", output iIdQuantityofReservesinfo).
                        run addNode in hGenXml (iIdReserveinformation, "PhysicalProcessedQuantity":U, "", output iIdQuantityofReservesinfo).
                    &ENDIF
                /****************************************/
            /*****************************/
        end.
    /***********************************/
END PROCEDURE.

