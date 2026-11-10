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
{include/i-prgvrs.i AB0708B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708b MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Abastecimento (2a metade)
  Parameters:  tt-param (entrada) = temp-table com os parametros do rp
               tt-dados (sa¡da)   = resultados da importa‡Æo para exibi‡Æo no rp.
  Notes:       chamada pelo programa de importa‡Æo de Cadastros Basicos Frotas - 
               ab0708rp.p - .
------------------------------------------------------------------------------*/     
/*variaveis*/
define variable iLinha         as integer    no-undo.
DEFINE VARIABLE c-liter1 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter2 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter3 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-teste AS CHARACTER  NO-UNDO.


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

/*parametros de entrada e saida*/
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados APPEND.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE h-mabl AS HANDLE NO-UNDO.

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
         HEIGHT             = 4.63
         WIDTH              = 28.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST tt-param NO-LOCK NO-ERROR.

if not avail tt-param then
    return "NOK":U.
else DO:
    RUN abp/api-ab0708b.i PERSISTENT SET h-mabl (input table tt-param).

    if tt-param.l-mab-bomba THEN
        RUN pi-mab-bomba IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-tip-mater THEN
        RUN pi-mab-tip-mater IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-tip-mater-item THEN
        RUN pi-mab-tip-mater-item IN h-mabl (INPUT h-acomp).
    
    IF tt-param.l-mab-grp-event THEN
        RUN pi-mab-grp-event IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-event THEN
        RUN pi-mab-event IN h-mabl (INPUT h-acomp).

    if tt-param.l-mab-marca THEN
        RUN pi-mab-marca IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-model THEN
        RUN pi-mab-model IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-consu-model THEN
        RUN pi-mab-consu-model IN h-mabl (input h-acomp).

    IF tt-param.l-mmv-tempo-padr then
        RUN pi-mmv-tempo-padr IN h-mabl (iNPUT h-acomp).

    IF tt-param.l-mab-motoris THEN
        RUN pi-mab-motoris IN h-mabl (INPUT h-acomp).

    IF tt-param.l-mab-motoris-model then
        RUN pi-mab-motoris-model IN h-mabl (INPUT h-acomp).

    RUN pi-retorna-ttdados IN h-mabl (OUTPUT TABLE tt-dados APPEND).

    if valid-handle(h-mabl) then
        DELETE PROCEDURE h-mabl.
end.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


