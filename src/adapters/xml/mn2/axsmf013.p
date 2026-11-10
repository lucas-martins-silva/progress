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
{include/i-prgvrs.i AXSMF013 2.00.00.001}  /*** 010001 ***/


/*****************************************************************************
**
**       PROGRAMA: AXSMF013
**
**       DATA....: 20/09/2007
**
**       AUTOR...: Andr‚ Lu¡s Oliveira Pereira - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Sender de Motorista p/ Programa CTVoicer
**
*****************************************************************************/
/* ***************************  Definitions  ************************** */
{adapters/xml/mn2/axmf.i 'out':U}
{frbo/bofr017.i tt-driver}

/** Parametros **/
define input parameter table for tt-driver.
define input param changecodeDriver as character no-undo.
/****************/

define variable c-root              as character no-undo.
define variable c-campo             as character no-undo.
define variable c-message           as character no-undo.
define variable c-Driver            as character no-undo.
define variable c-output-dir        as character no-undo.
DEFINE VARIABLE dir_name AS CHARACTER.

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
         HEIGHT             = 5.13
         WIDTH              = 31.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


for first tt-driver no-lock:
end.
if not avail tt-driver then return.

/** Busca descricao Empresa **/
for first empresa
    where empresa.ep-codigo = tt-driver.ep-codigo no-lock:
end.
if not avail empresa then return.

/** Busca descricao Estabelecimento **/
for first estabelec
    where estabelec.cod-estabel = tt-driver.cod-estabel no-lock:
end.
if not avail estabelec then return.

assign c-root = CreateDatasulDoc("Driver":U,"1.01.000":U,estabelec.cod-estabel).

/** Cria estrutura do Equipamento **/
run pi-cria-motorista.

/** Cria XML **/
run WriteXML.

/** Verifica parametro de integracao do AB0116 **/
{utp/ut-liter.i Sim}
for first mab-param-integr
    where mab-param-integr.cdn-param = 10
      and trim(entry(3,mab-param-integr.des-valor)) = trim(return-value) no-lock:
end.
if not avail mab-param-integr then return.

/** Busca catalogo de Documentos **/
for first catal_docto_anexo
    where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
end.
if not avail catal_docto_anexo then return.

ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\EXP".
        
if not avail catal_docto_anexo then return.

FILE-INFO:FILE-NAME = dir_name.

IF FILE-INFO:full-pathname = ? THEN DO: 
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Arquivo(s)_nÆo_podem_ser_gerado(s)_verifique_o_catalogo" *}
    MESSAGE RETURN-VALUE
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "NOK":U.
END.


/** Busca diretorio de saida conforme parametros de integracao com CTVoicer no AB0116 **/
assign c-output-dir = trim(catal_docto_anexo.cod_path_catal)
                    + "~\EXP~\":U + "driver":U
                    + string(year(today),"9999":U)
                    + string(month(today),"99":U)
                    + string(day(today),"99":U)
                    + replace(STRING(TIME, "HH:MM:SS"),":","")
                    + ".xml".

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

&IF DEFINED(EXCLUDE-pi-cria-motorista) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-motorista Procedure 
PROCEDURE pi-cria-motorista :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    assign
    c-driver = AddElement(c-root,"Driver":U)
        c-campo = AddEleChar(c-driver, "DriverChangeCode":U,             changecodeDriver)
        c-campo = AddEleInt(c-driver,  "DriverCompanyIdentifier":U,      &IF "{&mguni_version}" >= "2.071" &THEN int(empresa.ep-codigo) &ELSE empresa.ep-codigo &ENDIF )
        c-campo = AddEleChar(c-driver, "DriverCompanyName":U,            empresa.razao-social)
        c-campo = AddEleChar(c-driver, "DriverSiteIdentifier":U,         tt-driver.cod-estabel)
        c-campo = AddEleChar(c-driver, "DriverSiteName":U,               estabelec.nome)
        c-campo = AddEleChar(c-driver, "DriverDriverIdentifier":U,       tt-driver.cod-matr)
        c-campo = AddEleChar(c-driver, "DriverDriverName":U,             tt-driver.nom-motoris)
        c-campo = AddEleChar(c-driver, "DriverLicenseIdentifier":U,      tt-driver.cod-habilit)
        c-campo = AddEleChar(c-driver, "DriverIssuerAgencyIdentifier":U, tt-driver.cod-orgao-emissor)
        c-campo = AddEleChar(c-driver, "DriverCategoryIdentifier":U,     tt-driver.cod-livre-1).

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

