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
{include/i-prgvrs.i AB0708D 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708d MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Pneus
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

DEFINE VARIABLE h-mpnl AS HANDLE     NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST tt-param NO-LOCK NO-ERROR.

IF NOT AVAIL tt-param THEN
    RETURN "NOK":U.
else DO:
    RUN abp/api-ab0708d.i PERSISTENT SET h-mpnl (input table tt-param).

    IF tt-param.l-mpn-tip-borracha then
        RUN pi-mpn-tip-borracha IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-medid THEN
        RUN pi-mpn-medid IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-pos-pneu THEN
        RUN pi-mpn-pos-pneu IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-layout THEN
        RUN pi-mpn-layout IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-layout-eixo-pos THEN
        RUN pi-mpn-layout-eixo-pos IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-ambien-trab THEN
        RUN  pi-mpn-ambien-trab IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-serv THEN
        RUN pi-mpn-serv IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-desen THEN
        RUN pi-mpn-desen IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-km-esperad THEN
        RUN pi-mpn-km-esperad IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-model THEN
        RUN pi-mpn-model IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-pneu THEN
        RUN pi-mpn-pneu IN h-mpnl (INPUT h-acomp).

    IF tt-param.l-mpn-histor-vida THEN
        RUN pi-mpn-histor-vida IN h-mpnl (INPUT h-acomp).

    RUN pi-retorna-ttdados IN h-mpnl (OUTPUT TABLE tt-dados APPEND).

    IF VALID-HANDLE(h-mpnl) THEN 
        DELETE PROCEDURE h-mpnl.

    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


