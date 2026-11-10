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
{include/i-prgvrs.i AB0708C 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708c MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Manuten‡Æo Mecanica
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
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados append.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE h-mmvl AS HANDLE NO-UNDO.

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
         HEIGHT             = 3.71
         WIDTH              = 23.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST tt-param NO-LOCK NO-ERROR.

IF NOT AVAIL tt-param then
    RETURN  "NOK":U.
ELSE DO:
    RUN abp/api-ab0708c.i  PERSISTENT SET h-mmvl (input table tt-param).

    IF tt-param.l-mmv-ofici then
        RUN pi-mmv-ofici IN h-mmvl (INPUT h-acomp).

    IF tt-param.l-mmv-setor-ofici then
        RUN pi-mmv-setor-ofici IN h-mmvl (INPUT h-acomp).
    
    IF tt-param.l-mmv-func-ofici then
        RUN pi-mmv-func-ofici IN h-mmvl (INPUT h-acomp).

    IF tt-param.l-mmv-plano-prevent THEN
        RUN pi-mmv-plano-prevent IN h-mmvl (INPUT h-acomp).
    
    IF tt-param.l-mmv-tar-plano then
        RUN pi-mmv-tar-plano IN h-mmvl (INPUT h-acomp).

    IF tt-param.l-mmv-tar-plano-item then
        RUN pi-mmv-tar-plano-item IN h-mmvl (INPUT h-acomp).

    RUN pi-retorna-ttdados IN h-mmvl (OUTPUT TABLE tt-dados APPEND).

    IF VALID-HANDLE (h-mmvl) THEN
        DELETE PROCEDURE h-mmvl.

    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


