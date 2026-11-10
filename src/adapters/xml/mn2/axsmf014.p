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
{include/i-prgvrs.i AXSMF014 2.00.00.002}  /*** 010002 ***/


/*****************************************************************************
**
**       PROGRAMA: AXSMF014
**
**       DATA....: 20/09/2007
**
**       AUTOR...: Andr‚ Lu¡s Oliveira Pereira - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Sender de Abastecimento p/ Programa CTVoicer
**
*****************************************************************************/
/* ***************************  Definitions  ************************** */
{adapters/xml/mn2/axmf.i 'out':U}
{frbo/bofr055.i tt-abastec}

/** Parametros **/
DEFINE INPUT  PARAMETER TABLE FOR tt-abastec.
DEFINE INPUT  PARAMETER changeCodeDocument AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cLocalXmlGerado    AS CHARACTER FORMAT "x(200)" NO-UNDO.

/****************/

define variable c-root                as character  no-undo.
define variable c-campo               as character  no-undo.
define variable c-Abastec             as character  no-undo.
define variable c-ItemCollection      as character  no-undo.
define variable c-Item                as character  no-undo.
define variable c-output-dir          as character  no-undo.

define buffer bf-mab-item-abastec     for mab-item-abastec.

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
         HEIGHT             = 4.42
         WIDTH              = 31.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


for first tt-abastec no-lock:
end.
if not avail tt-abastec then RETURN "NOK":U.

/** Verifica o changecode do Item **/
IF changeCodeDocument <> "UPDE":U THEN DO:
    IF changeCodeDocument <> "DEL":U THEN DO:
        /** Valida se ‚ uma filha de abastecimento **/
        if not can-find(first bf-mab-item-abastec
                        where bf-mab-item-abastec.num-docto = tt-abastec.num-docto no-lock)
                        then RETURN "NOK":U.
    END.
END.
ELSE ASSIGN changeCodeDocument = "UPD":U.

/** Busca descricao Empresa **/
for first empresa
    where empresa.ep-codigo = tt-abastec.ep-codigo no-lock:
end.
if not avail empresa then RETURN "NOK":U.

/** Busca descricao Modelo **/
for first mab-eqpto
    where mab-eqpto.ep-codigo = tt-abastec.ep-codigo
    and   mab-eqpto.cod-eqpto = tt-abastec.cod-eqpto no-lock:
    for first mab-model
        where mab-model.cod-model = mab-eqpto.cod-model no-lock:
    end.
    if not avail mab-model then return "NOK":U.
end.
if not avail mab-eqpto then return "NOK":U.

/** Busca descricao Estabelecimento **/
for first estabelec
    where estabelec.cod-estabel = tt-abastec.cod-estabel no-lock:
end.
if not avail estabelec then return "NOK":U.

assign c-root = CreateDatasulDoc("Abastec":U,"1.01.000":U,estabelec.cod-estabel).

/** Cria estrutura do Equipamento **/
run pi-cria-abastecimento.

/** Cria XML **/
run WriteXML.

/** Verifica parametro de integracao do AB0116 **/
{utp/ut-liter.i Sim}
for first mab-param-integr
    where mab-param-integr.cdn-param = 10
      and trim(entry(4,mab-param-integr.des-valor)) = trim(return-value) no-lock:
end.
if not avail mab-param-integr then return "NOK":U.

/** Busca catalogo de Documentos **/
for first catal_docto_anexo
    where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
end.
if not avail catal_docto_anexo then return "NOK":U.

/** Busca diretorio de saida conforme parametros de integracao com CTVoicer no AB0116 **/
assign c-output-dir = trim(catal_docto_anexo.cod_path_catal)
                    + "~\EXP~\":U + "abastec":U
                    + string(year(today),"9999":U)
                    + string(month(today),"99":U)
                    + string(day(today),"99":U)
                    + replace(STRING(TIME, "HH:MM:SS"),":","")
                    + ".xml".
ASSIGN cLocalXmlGerado = c-output-dir.
output to value(c-output-dir) convert target "iso8859-1":U.
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

&IF DEFINED(EXCLUDE-pi-cria-abastecimento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-abastecimento Procedure 
PROCEDURE pi-cria-abastecimento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    assign
    c-Abastec   = AddElement(c-root,    "Document":U)
        c-campo = AddEleChar(c-abastec, "DocumentChangeCode":U,           changeCodeDocument)
        c-campo = AddEleInt(c-abastec,  "DocumentIdentifier":U,           tt-abastec.num-docto)
        c-campo = AddEleInt(c-abastec,  "DocumentCompanyIdentifier":U,    &IF "{&mguni_version}" >= "2.071" &THEN int(empresa.ep-codigo) &ELSE empresa.ep-codigo &ENDIF)
        c-campo = AddEleChar(c-abastec, "DocumentCompanyName":U,          empresa.razao-social)
        c-campo = AddEleChar(c-abastec, "DocumentEquipmentIdentifier":U,  tt-abastec.cod-eqpto)
        c-campo = AddEleChar(c-abastec, "DocumentEquipmentName":U,        mab-model.des-model)
        c-campo = AddEleChar(c-abastec, "DocumentSiteIdentifier":U,       tt-abastec.cod-estabel)
        c-campo = AddEleChar(c-abastec, "DocumentSiteName":U,             estabelec.nome).

    assign c-ItemCollection = AddElement(c-Abastec,"AbastecCollection":U).

    for each bf-mab-item-abastec
        where bf-mab-item-abastec.num-docto = tt-abastec.num-docto no-lock:
        
        /** Busca descricao Item **/
        for first item
            where item.it-codigo = bf-mab-item-abastec.it-codigo no-lock:
        end.
        if not avail item then next.

        /** Busca descricao Posto **/
        for first mab-posto
            where mab-posto.cod-posto = bf-mab-item-abastec.cod-posto no-lock:
        end.
        if not avail mab-posto then next.

        assign c-Item = AddElement(c-ItemCollection,"Abastec":U)              
               c-campo = AddEleChar(c-item,  "AbastecStationIdentifier":U,       bf-mab-item-abastec.cod-posto)
               c-campo = AddEleChar(c-item,  "AbastecStationName":U,             mab-posto.des-posto)
               c-campo = AddEleChar(c-item,  "AbastecPumpGasIdentifier":U,       bf-mab-item-abastec.cod-bomba)
               c-campo = AddEleChar(c-item,  "AbastecPumpGasName":U,             bf-mab-item-abastec.cod-bomba)
               c-campo = AddEleChar(c-item,  "AbastecItemIdentifier":U,          bf-mab-item-abastec.it-codigo)
               c-campo = AddEleChar(c-item,  "AbastecItemName":U,                item.descricao-1)
               c-campo = AddEleChar(c-item,  "AbastecKindOfIdentifier":U,        bf-mab-item-abastec.cod-tip-mater)
               c-campo = AddEleDeci(c-item,  "AbastecQuantAbastecIdentifier":U,  bf-mab-item-abastec.val-quant).
    end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

