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
{include/i-prgvrs.i AB0804D 2.00.00.001} /*** "010001" 22/07/2024 10:40:31  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804d MAB}
&ENDIF


/*****************************************************************************
**
**       Programa: AB0804D
**
**       Objetivo: Seta vari veis globais para cria‡Æo dos registros de Abastec/Lubrific
**
*****************************************************************************/
/********************************************
** Defini‡Æo de Parƒmetros
********************************************/
define input parameter p-dt-movimento    as date      format "99/99/9999":U     no-undo.
define input parameter p-c-hr-inicial    as character format "99:99":U          no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define input parameter p-i-ep-codigo     LIKE empresa.ep-codigo   format "x(03)":U            no-undo.
&ELSE
define input parameter p-i-ep-codigo     as integer   format ">>9":U            no-undo.
&ENDIF
define input parameter p-c-cod-eqpto     as character format "x(16)":U          no-undo.
define input parameter p-de-contador     as decimal   format ">,>>>,>>9.9":U no-undo.
define input parameter p-de-contador-sec as decimal   format ">,>>>,>>9.9":U no-undo.
define input parameter p-c-posto         as character format "x(8)":U           no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE INPUT PARAMETER p-i-empresa-matr  LIKE empresa.ep-codigo   format "x(03)"              NO-UNDO.
&ELSE
DEFINE INPUT PARAMETER p-i-empresa-matr  AS INTEGER   FORMAT ">>9"              NO-UNDO.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE INPUT PARAMETER p-c-estabel-matr  AS CHARACTER format "x(05)"            NO-UNDO.
&ELSE
DEFINE INPUT PARAMETER p-c-estabel-matr  AS CHARACTER FORMAT "x(03)"            NO-UNDO.
&ENDIF
define input parameter p-c-cod-matr      as character format "x(10)":U          no-undo.
define input parameter p-c-cod-evento    as character format "x(8)":U           no-undo.
define input parameter p-c-cod-compart   as character format "x(8)":U           no-undo.
define input parameter p-c-cod-rota      as character format "x(12)":U          no-undo.
define input parameter p-c-cod-ativid    as character format "x(8)":U           no-undo.
define input parameter p-i-tipo          as integer                             no-undo.

/********************************************
** Defini‡Æo de Vari veis Globais
********************************************/
define new global shared variable dt-movimento    as date      format "99/99/9999":U     no-undo.
define new global shared variable c-hr-inicial    as character format "99:99":U          no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable i-ep-codigo     LIKE empresa.ep-codigo   format "x(03)":U            no-undo.
&ELSE
define new global shared variable i-ep-codigo     as integer   format ">>9":U            no-undo.
&ENDIF
define new global shared variable c-cod-eqpto     as character format "x(16)":U          no-undo.
define new global shared variable de-contador     as decimal   format ">,>>>,>>9.9":U no-undo.
define new global shared variable de-contador-sec as decimal   format ">,>>>,>>9.9":U no-undo.
define new global shared variable c-posto         as character format "x(8)":U           no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable i-empresa-matr  LIKE empresa.ep-codigo   format "x(03)"              NO-UNDO.
&ELSE
define new global shared variable i-empresa-matr  AS INTEGER   FORMAT ">>9"              NO-UNDO.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable c-estabel-matr  AS CHARACTER format "x(05)"            NO-UNDO.
&ELSE
define new global shared variable c-estabel-matr  AS CHARACTER FORMAT "x(03)"            NO-UNDO.
&ENDIF
define new global shared variable c-cod-matr      as character format "x(10)":U          no-undo.
define new global shared variable c-cod-evento    as character format "x(8)":U           no-undo.
define new global shared variable c-cod-compart   as character format "x(8)":U           no-undo.
define new global shared variable c-cod-rota      as character format "x(12)":U          no-undo.
define new global shared variable c-cod-ativid    as character format "x(8)":U           no-undo.
define new global shared variable i-tipo          as integer                             no-undo.

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
         HEIGHT             = 4.04
         WIDTH              = 27.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Seta os valores recebidos para manuten‡Æo de frotas **/
assign dt-movimento    = p-dt-movimento
       c-hr-inicial    = p-c-hr-inicial
       i-ep-codigo     = p-i-ep-codigo
       c-cod-eqpto     = p-c-cod-eqpto
       de-contador     = p-de-contador
       de-contador-sec = p-de-contador-sec
       c-posto         = p-c-posto
       i-empresa-matr  = p-i-empresa-matr
       c-estabel-matr  = p-c-estabel-matr
       c-cod-matr      = p-c-cod-matr
       c-cod-evento    = p-c-cod-evento
       c-cod-compart   = p-c-cod-compart
       c-cod-rota      = p-c-cod-rota
       c-cod-ativid    = p-c-cod-ativid
       i-tipo          = p-i-tipo.

return "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


