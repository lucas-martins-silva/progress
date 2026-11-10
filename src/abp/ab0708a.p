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
{include/i-prgvrs.i AB0708A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708a MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Abastecimento (1a metade)
  Parameters:  tt-param (entrada) = temp-table com os parametros do rp
               tt-dados (sa¡da)   = resultados da importa‡Æo para exibi‡Æo no rp.
  Notes:       chamada pelo programa de importa‡Æo de Cadastros Basicos Frotas - 
               ab0708rp.p - .
------------------------------------------------------------------------------*/     
/*variaveis*/
define variable iLinha         as integer    no-undo.
define variable c-liter1 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
define variable c-liter2 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
define variable c-liter3 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
define variable c-teste AS CHARACTER  NO-UNDO.

/** Temp-Table de Parƒmetros **/
{abp/ab0708.i1}

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    field ErrorDump        as character
    index seq ErrorSequence.

{abp/ab9004.i}            /* Temp-Table RowErrors */
{abp/ab0708.i3}


/** Parƒmetros de Entrada e Sa¡da **/
define input        parameter table for tt-param.
define input-output parameter table for tt-dados   append.
define input        parameter h-acomp as handle no-undo.

define variable h-mabl as handle no-undo.

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
         HEIGHT             = 3.67
         WIDTH              = 24.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST tt-param NO-LOCK NO-ERROR.

if not avail tt-param then
    return "NOK":U.
else do:
    RUN abp/api-ab0708a.i PERSISTENT SET h-mabl (input table tt-param).

    IF tt-param.l-mab-ativid then 
        RUN pi-mab-ativid IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-trajeto THEN
        RUN pi-mab-trajeto IN  h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-caract then
        RUN pi-mab-caract IN h-mabl (input h-acomp).

    IF tt-param.l-mab-comptmento then
        RUN pi-mab-comptmento IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-estrut-mec THEN
        RUN pi-mab-estrut-mec IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-sist THEN
        RUN pi-mab-sist IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-sub-sist THEN
        RUN pi-mab-sub-sist IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-sit-eqpto THEN
        RUN pi-mab-sit-eqpto IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-grp-eqpto  THEN
        RUN pi-mab-grp-eqpto IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-posto  THEN
        RUN pi-mab-posto IN h-mabl (input h-acomp).

    RUN pi-retorna-ttdados IN h-mabl (OUTPUT TABLE tt-dados APPEND).

    if valid-handle(h-mabl) then
        DELETE PROCEDURE h-mabl.

    RETURN "OK":U.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


