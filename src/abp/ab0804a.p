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
{include/i-prgvrs.i AB0804A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804a MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0804A.p
**
**       DATA....: Abril 2004
**
**       AUTor...: DATASUL S.A.
**
**       OBJETIVO: Valida‡Æo do item com tipo de material
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/** Parƒmetros **/
define input  parameter pi-emitente     as integer   no-undo.
define input  parameter pc-serie        as character no-undo.
define input  parameter pc-nota         as character no-undo.
define input  parameter pc-natureza     as character no-undo.
define input  parameter pi-sequencia    as integer   no-undo.
define input  parameter pc-item         as character no-undo.
define output parameter pde-qtde        as decimal   no-undo.
define output parameter pde-valor       as decimal   no-undo.
define output parameter pc-conta-contab as character no-undo.
define output parameter pr-rowid        as rowid     no-undo.
define output parameter pl-ok           as logical   no-undo.

/** Vari veis **/

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
         HEIGHT             = 4.29
         WIDTH              = 31.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Inicializa‡Æo do programa **/
run pi-inicial in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-inicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicial Procedure 
PROCEDURE pi-inicial :
/*------------------------------------------------------------------------------
  Purpose:     pi-inicial
  Parameters:  <none>
  Notes:       Valida se ir  executar tela de abastecimento.
------------------------------------------------------------------------------*/
/** Verifica se o item faz parte de algum tipo de material **/
if can-find(first mab-tip-mater-item
            where mab-tip-mater-item.it-codigo = pc-item no-lock) and
   /** Verifica se Emitente cont‚m algum posto cadastrado **/
   can-find(first mab-posto
            where mab-posto.cod-emitente = pi-emitente no-lock) then do:
    /** Executa o programa na mem¢ria **/
    run abp/ab0804.w (input  pi-emitente,
                      input  pc-serie,
                      input  pc-nota,
                      input  pc-natureza,
                      input  pi-sequencia,
                      input  pc-item,
                      output pde-qtde,
                      output pde-valor,
                      output pc-conta-contab,
                      output pr-rowid,
                      output pl-ok).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

