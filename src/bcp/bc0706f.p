/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0706F 2.00.00.003 } /*** 010003 ***/
&IF INTEGER(ENTRY(1, PROVERSION, ".")) >= 10 
    OR (INTEGER(ENTRY(1, PROVERSION, ".")) = 9 AND 
    ENTRY(2, PROVERSION, ".") > "1C":U) &THEN
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0706f MBC}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName    BC0706F
&GLOBAL-DEFINE DBOVersion 1.00.00.000

{bcp/bc0706.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER ipiStatus AS INTEGER    NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-var-equip.

DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hTTServerError.

{bcp/bc0706.i1}

/* Local Variable Definitions ---                                       */
DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 11.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

CASE ipiStatus:
    WHEN 1 THEN
        RUN piGetSenderVariables IN THIS-PROCEDURE.

    WHEN 2 THEN
        RUN piGetReceiverVariables IN THIS-PROCEDURE.

END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGetReceiverVariables DBOFunction 
PROCEDURE piGetReceiverVariables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-cd-trans     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-eqpto     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-var-eqpto AS CHARACTER  NO-UNDO.

    FIND FIRST tt-var-equip EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-var-equip THEN RETURN "NOK":U.
    
    REPEAT:
        IF NOT AVAIL tt-var-equip THEN LEAVE. /* Sair do looping pois acabaram os registros */

        IF c-cd-trans     <> tt-var-equip.cd-trans      OR
           c-cd-eqpto     <> tt-var-equip.cod-eqpto     OR
           c-cd-var-eqpto <> tt-var-equip.cod-var-eqpto THEN DO:

            ASSIGN c-cd-trans     = tt-var-equip.cd-trans
                   c-cd-eqpto     = tt-var-equip.cod-eqpto
                   c-cd-var-eqpto = tt-var-equip.cod-var-eqpto.

            FIND FIRST bfBCTipoTransEquipVar NO-LOCK
                 WHERE bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans
                 AND   bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto
                 AND   bfBCTipoTransEquipVar.cod-var-eqpto = tt-var-equip.cod-var-eqpto NO-ERROR.
            IF NOT AVAIL bfBCTipoTransEquipVar THEN NEXT.

            ASSIGN tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul.

            FIND NEXT tt-var-equip NO-ERROR.
        END. ELSE DO:
            FIND NEXT bfBCTipoTransEquipVar NO-LOCK NO-ERROR.
            IF NOT AVAIL bfBCTipoTransEquipVar THEN NEXT.

            ASSIGN tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul.

            FIND NEXT tt-var-equip NO-ERROR.
        END.
    END.

/*    
    FOR EACH tt-var-equip EXCLUSIVE-LOCK:
        FOR EACH bfBCTipoTransEquipVar
           WHERE bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans
             AND bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto
             AND bfBCTipoTransEquipVar.cod-var-eqpto = tt-var-equip.cod-var-eqpto NO-LOCK NO-ERROR.

        IF AVAIL bfBCTipoTransEquipVar THEN
            ASSIGN tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul.
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGetSenderVariables DBOFunction 
PROCEDURE piGetSenderVariables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-cd-trans     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-eqpto     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-var-dtsul AS CHARACTER  NO-UNDO.

    FIND FIRST tt-var-equip EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-var-equip THEN RETURN "NOK":U.
    
    REPEAT:
        IF NOT AVAIL tt-var-equip THEN LEAVE. /* Sair do looping pois acabaram os registros */

        IF c-cd-trans     <> tt-var-equip.cd-trans      OR
           c-cd-eqpto     <> tt-var-equip.cod-eqpto     OR
           c-cd-var-dtsul <> tt-var-equip.cod-var-dtsul THEN DO:

            ASSIGN c-cd-trans     = tt-var-equip.cd-trans
                   c-cd-eqpto     = tt-var-equip.cod-eqpto
                   c-cd-var-dtsul = tt-var-equip.cod-var-dtsul.

            FIND FIRST bfBCTipoTransEquipVar NO-LOCK
                 WHERE bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans
                 AND   bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto
                 AND   bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul NO-ERROR.
            IF NOT AVAIL bfBCTipoTransEquipVar THEN NEXT.

            ASSIGN tt-var-equip.cod-var-eqpto = bfBCTipoTransEquipVar.cod-var-eqpto.

            FIND NEXT tt-var-equip NO-ERROR.
        END. ELSE DO:
            FIND NEXT bfBCTipoTransEquipVar NO-LOCK NO-ERROR.
            IF NOT AVAIL bfBCTipoTransEquipVar THEN NEXT.

            ASSIGN tt-var-equip.cod-var-eqpto = bfBCTipoTransEquipVar.cod-var-eqpto.

            FIND NEXT tt-var-equip NO-ERROR.
        END.
    END.
    
/*
    FOR EACH tt-var-equip EXCLUSIVE-LOCK:
        FIND FIRST bfBCTipoTransEquipVar NO-LOCK
             WHERE bfBCTipoTransEquipVar.cd-trans = tt-var-equip.cd-trans
             AND   bfBCTipoTransEquipVar.cod-eqpto = tt-var-equip.cod-eqpto
             AND   bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul NO-ERROR.

        IF AVAIL bfBCTipoTransEquipVar THEN
            ASSIGN tt-var-equip.cod-var-eqpto = bfBCTipoTransEquipVar.cod-var-eqpto.
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&endif
