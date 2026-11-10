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
{include/i-prgvrs.i AXSMF009 2.00.00.005 } /*** "010005" ***/


/*------------------------------------------------------------------------
    File        : axSmf001.p
    Purpose     :   Envio do Equipamento
    Syntax      :
    Description :
    Author(s)   : Carlos Alberto Valentini
    Created     : 14/02/2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
{cdp/cdcfgmnt.i}
/* ***************************  Definitions  ************************** */

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */

/* &GLOBAL-DEFINE XmlApp            CT5               */
/* &GLOBAL-DEFINE XmlMod            FAS               */
/* &GLOBAL-DEFINE XmlProdName       EMS5              */
/* &GLOBAL-DEFINE XmlProdVersion    504               */
/* &GLOBAL-DEFINE XmlTranName       AssetDepreciation */
/* &GLOBAL-DEFINE XmlTranVersion    504.000           */

/* DEFINICAO DE PRE-PROCESSADORES - END */   

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName       Equipments
/* &GLOBAL-DEFINE XmlMinTranVersion 504.000 */
/* &GLOBAL-DEFINE XmlMaxTranVersion 506.999 */
&GLOBAL-DEFINE XmlTranVersion    504.000
&GLOBAL-DEFINE XmlProdName       EMS5
&GLOBAL-DEFINE XmlProdVersion    504
&GLOBAL-DEFINE XmlApp            MN2 
&GLOBAL-DEFINE XmlMod            MFO

/* Defini‡Æo das temp-table do Equipamento */
def temp-table tt-eqpto no-undo like mab-eqpto
    field r-rowid as rowid.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*** Bibliotecas padräes ***/
{utp/ut-glob.i}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-eqpto.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId                 AS INT  NO-UNDO.
DEF VAR iFirstId            AS INT  NO-UNDO. 
DEF VAR iIdGrpEqpto         AS INT  NO-UNDO. 
DEF VAR iIdModel            AS INT  NO-UNDO. 
DEF VAR iIdEstrut           AS INT  NO-UNDO. 
DEF VAR iIdSitEqpto         AS INT  NO-UNDO. 
DEF VAR iIdSite             AS INT  NO-UNDO. 
DEF VAR iIdTag              AS INT  NO-UNDO. 
DEF VAR iIdAsset            AS INT  NO-UNDO. 
DEF VAR iIdEqptoInformation AS INT  NO-UNDO. 
DEF VAR iIdDoc              AS INT  NO-UNDO. 
DEF VAR iIdPinfo            AS INT  NO-UNDO. 
DEF VAR iIdEmp              AS INT  NO-UNDO. 
DEF VAR dDateMovEqpto       LIKE mab-histor-ativid.dat-cadastro NO-UNDO.
DEF VAR cBackup             AS CHAR NO-UNDO.
DEF VAR iIdPurchase         AS INT  NO-UNDO. 
DEF VAR iIdCustomerVendor   AS INT  NO-UNDO.
DEF VAR iIdMark             AS INT  NO-UNDO.
DEF VAR iIdActivity         AS INT  NO-UNDO.
DEF VAR iIdMarkSon          AS INT  NO-UNDO.

DEFINE VARIABLE iIdEqStartInf AS INTEGER    NO-UNDO.
/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR   NO-UNDO.

/*Vari veis locais*/
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
DEF VAR iCount        AS INT             NO-UNDO.
DEF VAR l-logical     AS LOG             NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.92
         WIDTH              = 35.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */



/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST tt-eqpto) THEN DO:
    {utp/ut-liter.i Equipamentos_da_frota_para_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.
FOR EACH tt-eqpto NO-LOCK:
     /* Verifica se MessageHandler.p está  na mem¢ria */
     {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}
     /* Verifica se o MessageHandler foi executado corretamente */
     IF cReturnValue <> "OK":U THEN DO:
          IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
    
              run piCriaErro (17006,
                              'EMS':U, 
                              cReturnValue).
                  RETURN "NOK":U.
                  LEAVE.
          END.
     END.
     /* Verifica se h  programas inscritos */
     RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                          INPUT "{&XmlApp}",
                                          INPUT "{&XmlTranName}",
                                          INPUT "{&XmlTranVersion}",
                                          INPUT "Equipments",
                                          INPUT  pTranAction,
                                          OUTPUT lCREATEMsg).
     /*Verifica se a transa‡Æo ‚ assinada*/
       IF NOT lCREATEMsg THEN
          RETURN "OK":U.

     /* Preenche o valor do elemento Comment de TransactionId */
     RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                 "Version:" + pProgVersion). 
     /*Seta SystemID*/
     RUN setSystemId IN hMessageHandler ("{&XmlMod}",          /* Nome do modulo */
                                         "{&XmlProdVersion}"). /* Versao do Programa */
     /* Indica valor da chave prim ria da transa‡Æo */
     RUN setKeyFields IN hMessageHandler ("mab-eqpto.ep-codigo":U,
                                          STRING(tt-eqpto.ep-codigo)). 
     /* Indica valor da chave prim ria da transa‡Æo */
     RUN setKeyFields IN hMessageHandler ("mab-eqpto.cod-eqpto":U,
                                          string(tt-eqpto.cod-eqpto)). 
     /* Seta a empresa e o estabelecimento */
     RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 
     /* Verifica se API est  na mem¢ria */
     {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}
     /* Verifica se o ut-genxml foi executado corretamente */
     IF cReturnValue <> "OK":U THEN DO:
          IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
              run piCriaErro (17006,
                              'EMS':U, 
                              cReturnValue).
           RETURN "NOK":U.
           LEAVE.
          END.
      END.
     /* Cria mensagem do BusinessContent atrav‚s da API*/
     CREATE-BUSINESS-XML:
     DO:
         /* RESETA OS VALORES */
         RUN reset IN hGenXml.
         /* SETA VALOR DE ENCODING */
         RUN setEncoding IN hGenXml ("UTF-8").
         IF pTranAction = "add":U OR pTranAction = "upd":U THEN DO:
             /* Nà PRINCIPAL UPSERT */
             RUN addNode IN hGenXml (0, "Upsert" , "", OUTPUT iFirstId).
             /* Adiciona informa‡äes do Equipamento */
             if iFirstId <> ? then do:
                     RUN addNodeDec  IN hGenXml (iFirstId, "CompanyCode", tt-eqpto.ep-codigo, OUTPUT iId).
                       /*** Descri‡Æo da Empresa *****/
                       FOR FIRST empresa FIELDS (ep-codigo nome) WHERE empresa.ep-codigo = tt-eqpto.ep-codigo  NO-LOCK:
                       END. 
                       IF AVAIL empresa then
                          RUN addNode IN hGenXml (iFirstId, "CompanyName", empresa.nome , OUTPUT iId).
                       ELSE
                          RUN addNode IN hGenXml (iFirstId, "CompanyName", "" , OUTPUT iId).
                     RUN addNode     IN hGenXml (iFirstId, "EquipmentCode",        tt-eqpto.cod-eqpto, OUTPUT iId).
                     IF tt-eqpto.idi-tip-eqpto >= 1 AND tt-eqpto.idi-tip-eqpto <= 2  AND  tt-eqpto.idi-tip-eqpto <> ? THEN
                        RUN addNodeDec  IN hGenXml (iFirstId, "EquipmentType",     tt-eqpto.idi-tip-eqpto, OUTPUT iId).
                     ELSE
                        RUN addNodeDec  IN hGenXml (iFirstId, "EquipmentType",     1 , OUTPUT iId).

                     CASE tt-eqpto.idi-tip-propriet:
                         WHEN 1 THEN DO:
                             RUN addNodeDec  IN hGenXml (iFirstId, "PropertyEquipmentType", tt-eqpto.idi-tip-propriet, OUTPUT iId).
                         END.
                         WHEN 2 THEN DO:
                             IF  tt-eqpto.log-alugdo = YES THEN DO:
                                 /* Ir  passar o valor 3 informando que ‚ Alugado */
                                 RUN addNodeDec  IN hGenXml (iFirstId, "PropertyEquipmentType", 3, OUTPUT iId).
                             END.
                             ELSE DO:
                                 /* Ir  passar o proprio campo que ‚ o valor 2 - Terceiro */
                                 RUN addNodeDec  IN hGenXml (iFirstId, "PropertyEquipmentType", tt-eqpto.idi-tip-propriet, OUTPUT iId).
                             END.
                         END.
                         OTHERWISE DO:
                             RUN addNodeDec  IN hGenXml (iFirstId, "PropertyEquipmentType", 1, OUTPUT iId).
                         END.
                     END CASE.

                     /* Adiciona informacoes do Emitente */
                     RUN addNode     IN hGenXml (iFirstId, "CustomerVendor", "", OUTPUT iId).
                     if iId <> ? then do:
                        RUN addNodeDec  IN hGenXml (iId, "CustomerVendorCode", tt-eqpto.cod-emitente,  OUTPUT iIdCustomerVendor).
                        FOR FIRST emitente FIELDS (cod-emitente cgc) 
                             WHERE emitente.cod-emitente = tt-eqpto.cod-emitente  NO-LOCK: 
                        END. 
                        IF AVAIL emitente THEN
                            RUN addNode IN hGenXml (iId, "TaxID", emitente.cgc,  OUTPUT iIdCustomerVendor).
                     END.                              

                     /* Adiciona informacoes do Grupo de Equipamentos */
                     RUN addNode     IN hGenXml (iFirstId, "EquipmentGroup", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId, "EquipmentGroupCode", tt-eqpto.cod-grp-eqpto, OUTPUT iIdGrpEqpto).
                           /***descri‡Æo do grupo**/
                           FOR FIRST mab-grp-eqpto FIELDS (cod-grp-eqpto des-grp-eqpto) 
                                WHERE mab-grp-eqpto.cod-grp-eqpto = tt-eqpto.cod-grp-eqpto  NO-LOCK: 
                           END. 
                           IF AVAIL mab-grp-eqpto THEN
                              RUN addNode IN hGenXml (iId, "EquipmentGroupDescription", SUBSTRING(mab-grp-eqpto.des-grp-eqpto,1,30), OUTPUT iIdGrpEqpto).
                           ELSE
                              RUN addNode IN hGenXml (iId, "EquipmentGroupDescription", "", OUTPUT iIdGrpEqpto).

                     end.
                     /*** Adiciona as informa‡äes refentes ao Modelo ****/
                     RUN addNode     IN hGenXml (iFirstId, "Model", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId, "ModelCode", tt-eqpto.cod-model, OUTPUT iIdModel).
                           /***descri‡Æo/unidade medida do modelo**/
                           FOR FIRST mab-model FIELDS (cod-model des-model un cod-marca) 
                                WHERE mab-model.cod-model = tt-eqpto.cod-model  NO-LOCK: 
                           END. 
                           IF AVAIL mab-model then do:
                              RUN addNode IN hGenXml (iId, "ModelDescription", SUBSTRING(mab-model.des-model,1,30), OUTPUT iIdModel).
                              RUN addNode IN hGenXml (iId, "UnitOfMeasureCode",   SUBSTRING(mab-model.un,1,2), OUTPUT iIdModel).
                              /*** Adiciona as informa‡äes refentes a Marca ****/
                              RUN addNode IN hGenXml (iId, "Mark", "", OUTPUT iIdModel).
                                   RUN addNode IN hGenXml (iIdModel, "MarkCode", mab-model.cod-marca, OUTPUT iIdMarkSon).
                                   FOR FIRST mab-marca FIELDS (cod-marca nom-marca) 
                                        WHERE mab-marca.cod-marca = mab-model.cod-marca  NO-LOCK: 
                                   END. 
                                   IF AVAIL mab-marca then do:
                                       RUN addNode IN hGenXml (iIdModel, "MarkName", mab-marca.nom-marca, OUTPUT iIdMarkSon).
                                   end.
                           END.
                     end.
                     /*** Adiciona as informa‡äes refentes a Estrutura Mecanica do Equipamento ****/
                     RUN addNode     IN hGenXml (iFirstId, "MecanicsStructure", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId, "MecanicsStructureCode", tt-eqpto.cod-estrut-mec, OUTPUT iIdEstrut).
                           /***descri‡Æo estrutura mecanica**/
                           FOR FIRST mab-estrut-mec FIELDS (cod-estrut-mec des-estrut-mec) 
                                WHERE mab-estrut-mec.cod-estrut-mec = tt-eqpto.cod-estrut-mec  NO-LOCK: 
                           END. 
                           IF AVAIL mab-estrut-mec then do:
                              RUN addNode IN hGenXml (iId, "MecanicsStructureDescription", SUBSTRING(mab-estrut-mec.des-estrut-mec,1,30), OUTPUT iIdEstrut).
                           end.
                     end.
                     /*** Adiciona as informa‡äes refentes a Situa‡Æo do Equipamento ****/
                     RUN addNode     IN hGenXml (iFirstId, "EquipmentSituation", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId, "SituationCode",   tt-eqpto.cod-sit-eqpto, OUTPUT iIdSitEqpto).
                         /***descri‡Æo da situa‡Æo mecanica**/
                           FOR FIRST mab-sit-eqpto FIELDS (cod-sit-eqpto des-sit-eqpto) 
                                WHERE mab-sit-eqpto.cod-sit-eqpto = tt-eqpto.cod-sit-eqpto  NO-LOCK: 
                           END. 
                           IF AVAIL mab-sit-eqpto then do:
                              RUN addNodeDec  IN hGenXml (iId, "SituationStatus", mab-sit-eqpto.idi-tip, OUTPUT iIdSitEqpto).
                              RUN addNode IN hGenXml (iId, "SituationDescription", SUBSTRING(mab-sit-eqpto.des-sit-eqpto,1,30), OUTPUT iIdSitEqpto).
                           end.
                         IF tt-eqpto.dat-situacao <> ? THEN
                            RUN addNodeDate IN hGenXml (iId,   "SituationDate", tt-eqpto.dat-situacao, OUTPUT iIdSitEqpto).
                     end.
                     /*** Adiciona as informa‡äes referentes ao Estabelecimento ****/
                     RUN addNode     IN hGenXml (iFirstId, "Site", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId, "DefaultSiteCode", tt-eqpto.cod-estabel , OUTPUT iIdSite).
                           /***Informa‡äes do Estabelecimento**/
                           FOR FIRST estabelec FIELDS (cod-estabel nome ) 
                                WHERE estabelec.cod-estabel = tt-eqpto.cod-estabel  NO-LOCK: 
                           END. 
                           IF AVAIL estabelec then do:
                              RUN addNode IN hGenXml (iId, "DefaultSiteDescription", SUBSTRING(estabelec.nome,1,40), OUTPUT iIdSite).
                           end.
                     end.
                     RUN addNode     in hGenXml (iFirstId, "CostCenterCode", tt-eqpto.cc-codigo, OUTPUT iId).
                     RUN addNode     IN hGenXml (iFirstId, "AccountCode",    tt-eqpto.ct-codigo, OUTPUT iId).
                     RUN addNode     IN hGenXml (iFirstId, "CostCenterAlternativeCode", tt-eqpto.cod-ccusto-alter, OUTPUT iId).
                 &IF DEFINED(bf_mnt_ems206b) &THEN
                     RUN addNode     IN hGenXml (iFirstId, "BusinessUnit",   tt-eqpto.cod-unid-negoc, OUTPUT iId).
                 &ELSE
                     RUN addNode     IN hGenXml (iFirstId, "BusinessUnit",   tt-eqpto.cod_unid_negoc, OUTPUT iId).
                 &ENDIF
                     /*** Adiciona as informa‡äes refentes a Tag ****/
                     RUN addNode     IN hGenXml (iFirstId, "Tag", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNode     IN hGenXml (iId,      "TagCode", tt-eqpto.cd-tag , OUTPUT iIdTag).
                           /***Informa‡äes da Tag**/
                           FOR FIRST tag FIELDS (cd-tag descricao) 
                                WHERE tag.cd-tag = tt-eqpto.cd-tag  NO-LOCK: 
                           END. 
                           IF AVAIL tag then do:
                              RUN addNode IN hGenXml (iId, "TagDescription", SUBSTRING(tag.descricao,1,40), OUTPUT iIdTag).
                           end.
                     end.
                      /**** Informa‡äe do Bem ***/
                     RUN addNode     IN hGenXml (iFirstId, "AssetInformations", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNodeDec     IN hGenXml (iId, "AssetCode",  tt-eqpto.bm-codigo , OUTPUT iIdAsset).
                         RUN addNodeDec     IN hGenXml (iId, "AssetIndex", tt-eqpto.bm-indice,  OUTPUT iIdAsset).
                     end.
                     /**** Informa‡äes da Atividade ****/
                     RUN addNode     IN hGenXml (iFirstId, "Activity", "", OUTPUT iId).
                     if iId <> ? then do:
                         /*busca pelo £ltimo hist¢rico da atividade do Equipamento*/
                         for last mab-histor-ativid fields (ep-codigo cod-eqpto dat-cadastro cod-ativid)
                             where mab-histor-ativid.ep-codigo      =  tt-eqpto.ep-codigo
                             and   mab-histor-ativid.cod-eqpto      =  tt-eqpto.cod-eqpto
                             and   mab-histor-ativid.dat-cadastro  <= today no-lock:

                             ASSIGN dDateMovEqpto = mab-histor-ativid.dat-cadastro.

                             RUN addNode     IN hGenXml (iId, "ActivityCode", mab-histor-ativid.cod-ativi , OUTPUT iIdActivity).
                              /**** busca a atividade relativa ao hist¢rico encontrado *********/
                             for first mab-ativid fields (cod-ativid des-ativid log-area-agro )
                                 where mab-ativid.cod-ativid  = mab-histor-ativid.cod-ativid no-lock:
                                RUN addNode     IN hGenXml (iId, "ActivityDescription", mab-ativid.des-ativid , OUTPUT iIdActivity).
                                RUN addNodeLog  IN hGenXml (iId, "IsAgriculturistOperation", mab-ativid.log-area-agro , OUTPUT iIdActivity).
                             END. /*for first mab-ativid*/
                         END. /*for last mab-histor-ativid*/
                     END.
                     /**** Informa‡äes atualizadas do Equipamento na cria‡Æo ou movimenta‡Æo ****/
                     RUN addNode     IN hGenXml (iFirstId, "EquipmentStartInformations", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNodeDec  IN hGenXml (iId, "InitialAccountant",  tt-eqpto.val-hodom-horim-inicial, OUTPUT iIdEqptoInformation).
                         RUN addNodeDec  IN hGenXml (iId, "InitialKilometer",  tt-eqpto.val-km-inicial, OUTPUT iIdEqptoInformation).
                         RUN addNodeDate IN hGenXml (iId, "ControlInitialDate", tt-eqpto.dat-inicial, OUTPUT iIdEqptoInformation).
                     end.
                     /*** Informa‡äes Documentacionais ***/
                     RUN addNode     IN hGenXml (iFirstId, "Documents", "", OUTPUT iId).
                     if iId <> ? then do:
                         RUN addNodeDec  IN hGenXml (iId, "ManufatureYear",  tt-eqpto.vli-ano-fabric, OUTPUT iIdDoc).
                         RUN addNodeDec  IN hGenXml (iId, "ModelYear",       tt-eqpto.vli-ano-model, OUTPUT iIdDoc).
                         RUN addNode     IN hGenXml (iId, "EquipmentPlate", tt-eqpto.cod-placa, OUTPUT iIdDoc).
                         RUN addNode     IN hGenXml (iId, "PurchaseInformations", "" , OUTPUT iIdPurchase).
                         if iIdPurchase <> ? then do:
                             RUN addNodeDate IN hGenXml (iIdPurchase, "PurchaseDate",    tt-eqpto.dat-compra, OUTPUT iIdPinfo).
                             RUN addNodeDec  IN hGenXml (iIdPurchase, "PurchaseValue",   tt-eqpto.val-compra, OUTPUT iIdPinfo).
                         end.
                         RUN addNode     IN hGenXml (iId, "ChassisCode",      tt-eqpto.cod-chassi , OUTPUT iIdDoc).
                         RUN addNode     IN hGenXml (iId, "RenavamNumber",    tt-eqpto.cod-renavam, OUTPUT iIdDoc).
                     end.

                     /* Muda o formato de data para o padrÊo americano */
                     ASSIGN cBackup = SESSION:DATE-FORMAT
                            SESSION:DATE-FORMAT = "ymd".

                     RUN addNode IN hGenXml (iFirstId, "SiteHistoryDate", string(dDateMovEqpto, "9999-99-99"), OUTPUT iId).

                     /* Retorna a sessÊo para o padrÊo original */
                     SESSION:DATE-FORMAT = cBackup.

             end. /*** if iFirstId <> ? ***/
         END.
         ELSE IF pTranAction = "DEL":U THEN DO:
                 /* n¢ principal delete */
                 RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).
                 RUN addNodeDec IN hGenXml (iFirstId, "CompanyCode", tt-eqpto.ep-codigo, OUTPUT iId).
                 /*** Descri‡Æo da Empresa *****/
                 FOR FIRST empresa FIELDS (ep-codigo nome) WHERE empresa.ep-codigo = tt-eqpto.ep-codigo  NO-LOCK:
                 END.
                 IF AVAIL empresa THEN
                     RUN addNode IN hGenXml (iFirstId, "CompanyName", empresa.nome, OUTPUT iId).
                 RUN addNode IN hGenXml (iFirstId, "EquipmentCode", tt-eqpto.cod-eqpto , OUTPUT iId).
         END.
     END.
     /* Obt‚m XMl na variavel handle */
     RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
     /* Passa handle do BusinessContent */
     RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
     /* Elimina handle */
     DELETE OBJECT hBusinessContent NO-ERROR.
     /* Envia XML para ControlBroker */                                       
     RUN sendMessage IN hMessageHandler (INPUT "mn2/Equipments_204_000.xsd":U).
     /*Verifica se a mensagem foi enviada com sucesso */
     RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                             OUTPUT pTotalErrors).
     
     IF NOT pSendSuccess THEN DO:
       REPEAT iCount = 1 TO pTotalErrors:
           RUN getError IN hMessageHandler (iCount,
                                            OUTPUT pErrorNumber,
                                            OUTPUT pErrorType,
                                            OUTPUT pErrorDesc).

           IF pErrorType <> "business_error" THEN ASSIGN pErrorNumber = 17006.
           run piCriaErro (pErrorNumber,
                           pErrorType, 
                           substring(pErrorDesc,1,800)).
           
       END.
       IF CAN-FIND(FIRST rowerrors WHERE rowerrors.errortype = "business_error":U) THEN DO:
           RETURN "NOK":U.
           LEAVE.
       END.
     end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


