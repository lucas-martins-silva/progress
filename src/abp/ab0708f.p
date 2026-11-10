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
{include/i-prgvrs.i AB0708F 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708f MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas p g 5 (Equipamento)
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
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE h-handle AS HANDLE  NO-UNDO.

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
         HEIGHT             = 4.54
         WIDTH              = 23.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST tt-param NO-LOCK NO-ERROR.

IF NOT AVAIL tt-param THEN
    RETURN "NOK":U.
ELSE DO:
    RUN abp/api-ab0708f.i PERSISTENT SET h-handle (input table tt-param).

    IF tt-param.l-mab-eqpto then
        RUN pi-mab-eqpto IN h-handle (INPUT h-acomp).

    IF tt-param.l-mab-histor-ativid then
        RUN pi-mab-histor-ativid IN h-handle (INPUT h-acomp).

    IF tt-param.l-mab-histor-combust then
        RUN pi-mab-histor-combust IN h-handle (INPUT h-acomp).

    IF tt-param.l-mab-comptmento-eqpto then
        RUN pi-mab-comptmento-eqpto IN h-handle (INPUT h-acomp).

    IF tt-param.l-mab-period-manut then
        RUN pi-mab-period-manut IN h-handle (INPUT h-acomp).

    IF tt-param.l-mab-configur-eixo then
        RUN pi-mab-configur-eixo IN h-handle (INPUT h-acomp).

    IF tt-param.l-mmv-eqpto-plano then
        RUN pi-mmv-eqpto-plano  IN h-handle (INPUT h-acomp).

    IF tt-param.l-mpn-histor-layout-eixo then
        RUN pi-mpn-histor-layout-eixo IN h-handle (INPUT h-acomp).

    if tt-param.l-mab-eqpto-sub-sist then
        run pi-mab-relac-eqpto-sub-sist in h-handle (input h-acomp).

    if tt-param.l-mab-grp-eqpto-sub-sist then
        run pi-mab-eqpto-sub-sist in h-handle (input h-acomp).

    RUN pi-retorna-ttdados IN h-handle (OUTPUT TABLE tt-dados APPEND).

    return "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


