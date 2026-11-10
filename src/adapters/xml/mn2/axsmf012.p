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
{include/i-prgvrs.i AXSMF012 2.00.00.002}  /*** 010002 ***/


/*****************************************************************************
**
**       PROGRAMA: AXSMF012
**
**       DATA....: 20/09/2007
**
**       AUTOR...: Andr‚ Lu¡s Oliveira Pereira - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Sender de Equipamento p/ Programa CTVoicer
**
*****************************************************************************/
/* ***************************  Definitions  ************************** */
{adapters/xml/mn2/axmf.i 'out':u}
{frbo~/bofr007.i tt-equipment}

/** Parametros **/
define input parameter table for tt-equipment.
define input param changecodeEquipment as character no-undo.

define variable c-root              as character no-undo.
define variable c-campo             as character no-undo.
define variable c-Equipment            as character no-undo.
define variable c-output-dir        as character no-undo.

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
         HEIGHT             = 15
         WIDTH              = 31.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/** Busca equipamento passado por parametro **/

for first tt-equipment no-lock:
end.
if not avail tt-equipment then NEXT.

/** Busca descricao Empresa **/
for first empresa
    where empresa.ep-codigo = tt-equipment.ep-codigo no-lock:
end.
if not avail empresa then NEXT.

/** Busca descricao Modelo **/
for first mab-model
    where mab-model.cod-model = tt-equipment.cod-model no-lock:
end.
if not avail mab-model then NEXT.

/** Busca ultimo Historico de Combustivel **/
/*for last mab-histor-combust
    where mab-histor-combust.ep-codigo = tt-equipment.ep-codigo
    /*and   mab-histor-combust.cod-eqpto = tt-equipment.cod-eqpto no-lock use-index mbhstrcm-id*/:
end.
if not avail mab-histor-combust then NEXT.*/


/** Busca ultimo Historico de Estabelecimento **/
for last mab-histor-ativid
    where mab-histor-ativid.ep-codigo = tt-equipment.ep-codigo
    and   mab-histor-ativid.cod-eqpto = tt-equipment.cod-eqpto no-lock use-index mbhstrtv-id:
end.
if not avail mab-histor-ativid then NEXT.

/** Busca descricao Estabelecimento **/
for first estabelec
    where estabelec.cod-estabel = mab-histor-ativid.cod-estabel no-lock:
end.
if not avail estabelec then NEXT.

/** Busca descricao Grupo Equipamento **/
for first mab-grp-eqpto
    where mab-grp-eqpto.cod-grp-eqpto = mab-histor-ativid.cod-grp-eqpto no-lock:
end.
if not avail mab-grp-eqpto then NEXT.

/** Busca descricao Estrutura Mecanica **/
for first mab-estrut-mec
    where mab-estrut-mec.cod-estrut-mec = tt-equipment.cod-estrut-mec no-lock:
end.
if not avail mab-estrut-mec then NEXT.

/** Busca descricao TAG **/
for first tag
    where tag.cd-tag = mab-histor-ativid.cd-tag no-lock:
end.
if not avail tag then NEXT.

assign c-root = CreateDatasulDoc("Equipment":U,"1.01.000":U,estabelec.cod-estabel).


/** Cria estrutura do Equipamento **/
run pi-cria-equipamento.

/** Cria XML **/
run WriteXML.

/** Verifica parametro de integracao do AB0116 **/
{utp/ut-liter.i Sim}
for first mab-param-integr
    where mab-param-integr.cdn-param = 10
      and trim(entry(2,mab-param-integr.des-valor)) = trim(return-value) no-lock:
end.
if not avail mab-param-integr then return.

/** Busca catalogo de Documentos **/
for first catal_docto_anexo
    where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
end.
if not avail catal_docto_anexo then return.


FILE-INFO:FILE-NAME = catal_docto_anexo.cod_path_catal + "~\EXP".
IF FILE-INFO:full-pathname <> ? THEN DO:
/** Busca diretorio de saida conforme parametros de integracao com CTVoicer no AB0116 **/
    assign c-output-dir = trim(catal_docto_anexo.cod_path_catal + "~\EXP")
                        + "~\" + string(year(today),"9999":U)
                        + string(month(today),"99":U)
                        + string(day(today),"99":U)
                        + REPLACE(STRING (TIME,"HH:MM:SS":U),":","")
                        + "-" + string(tt-equipment.ep-codigo)
                        + "-" + string(tt-equipment.cod-eqpto)
                        + ".xml".

output to value(c-output-dir) convert target "iso8859-1":U.
END.
ELSE DO:
    run utp/ut-msgs.p (input "show",
                           input 29146,
                           input "").        
END.


for each tt-xml-message
    by tt-xml-message.sequence:
    put unformatted tt-xml-message.XMLMessage.
end.
put unformatted skip.

output close.
pause 1 no-message.

return "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-cria-equipamento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-equipamento Procedure 
PROCEDURE pi-cria-equipamento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

assign
    c-Equipment = AddElement(c-root,"Equipment":U)
        c-campo = AddEleChar(c-Equipment,"EquipmentChangeCode":U,changecodeEquipment)
        c-campo = AddEleInt(c-Equipment,"EquipmentCompanyIdentifier":U,&IF "{&mguni_version}" >= "2.071" &THEN int(empresa.ep-codigo) &ELSE empresa.ep-codigo &ENDIF )
        c-campo = AddEleChar(c-Equipment,"EquipmentCompanyName":U,empresa.razao-social)
        c-campo = AddEleChar(c-Equipment,"EquipmentIdentifier":U,tt-equipment.cod-eqpto)
        c-campo = AddEleChar(c-Equipment,"EquipmentModelIdentifier":U,tt-equipment.cod-model)
        c-campo = AddEleChar(c-Equipment,"EquipmentModelName":U,mab-model.des-model)
        c-campo = AddEleChar(c-Equipment,"EquipmentSiteIdentifier":U,mab-histor-ativid.cod-estabel)
        c-campo = AddEleChar(c-Equipment,"EquipmentSiteName":U,estabelec.nome)
        c-campo = AddEleDate(c-Equipment,"EquipmentActivityDateIdentifier":U,mab-histor-ativid.dat-cadastro,"00:00:00")
        c-campo = AddEleChar(c-Equipment,"EquipmentChassisIdentifier":U,tt-equipment.cod-chassi)
        c-campo = AddEleChar(c-Equipment,"EquipmentCostCenterIdentifier":U,mab-histor-ativid.cc-codigo)
        c-campo = AddEleChar(c-Equipment,"EquipmentAccountIdentifier":U,mab-histor-ativid.ct-codigo)
        c-campo = AddEleChar(c-Equipment,"EquipmentVehiclePlateIdentifier":U,tt-equipment.cod-placa)
        c-campo = AddEleChar(c-Equipment,"EquipmentRenavamIdentifier":U,tt-equipment.cod-renavam)
        c-campo = AddEleChar(c-Equipment,"EquipmentTagIdentifier":U,mab-histor-ativid.cd-tag)
        c-campo = AddEleChar(c-Equipment,"EquipmentTagName":U,tag.descricao)
        c-campo = AddEleChar(c-Equipment,"EquipmentEquipmentGroupIdentifier":U,mab-histor-ativid.cod-grp-eqpto)
        c-campo = AddEleChar(c-Equipment,"EquipmentEquipmentGroupName":U,mab-grp-eqpto.des-grp-eqpto)
        c-campo = AddEleChar(c-Equipment,"EquipmentMechanicStructureIdentifier":U,tt-equipment.cod-estrut-mec)
        c-campo = AddEleChar(c-Equipment,"EquipmentMechanicStructureName":U,mab-estrut-mec.des-estrut-mec)
        c-campo = AddEleInt(c-Equipment,"EquipmentFabricationYearIdentifier":U,tt-equipment.vli-ano-fabric)
        c-campo = AddEleInt(c-Equipment,"EquipmentFabricationModelIdentifier":U,tt-equipment.vli-ano-model)
        c-campo = AddEleDate(c-Equipment,"EquipmentPurchaseDateIdentifier":U,tt-equipment.dat-compra,"00:00:00")
        c-campo = AddEleDeci(c-Equipment,"EquipmentPurchaseValueIdentifier":U,tt-equipment.val-compra)
        c-campo = AddEleDeci(c-Equipment,"EquipmentInitialCounterIdentifier":U,tt-equipment.val-hodom-horim-inicial)
        c-campo = AddEleDeci(c-Equipment,"EquipmentInitialKmIdentifier":U,tt-equipment.val-km-inicial)
        c-campo = AddEleDate(c-Equipment,"EquipmentInitialControlDateIdentifier":U,tt-equipment.dat-inicial,"00:00:00")
        c-campo = AddEleInt(c-Equipment,"EquipmentOwnerKindIdentifier":U,tt-equipment.idi-tip-propriet).
        if avail mab-histor-combust then
            assign 
                c-campo = AddEleDate(c-Equipment,"EquipmentGasInitialDate":U,mab-histor-combust.dat-inicial,"00:00:00")
                c-campo = AddEleChar(c-Equipment,"EquipmentKindOfGas":U,mab-histor-combust.cod-tip-mater)
                c-campo = AddEleDeci(c-Equipment,"EquipmentTankSize":U,mab-histor-combust.val-capac-tanque)
                c-campo = AddEleInt(c-Equipment,"EquipmentKindOfConsumption":U,mab-histor-combust.idi-tip-consu)
                c-campo = AddEleDeci(c-Equipment,"EquipmentDefaultConsumption":U,mab-histor-combust.val-consu-padr).
        else 
            assign 
                c-campo = AddEleDate(c-Equipment,"EquipmentGasInitialDate":U,?,?)
                c-campo = AddEleChar(c-Equipment,"EquipmentKindOfGas":U,?)
                c-campo = AddEleDeci(c-Equipment,"EquipmentTankSize":U,?)
                c-campo = AddEleInt(c-Equipment,"EquipmentKindOfConsumption":U,?)
                c-campo = AddEleDeci(c-Equipment,"EquipmentDefaultConsumption":U,?).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

