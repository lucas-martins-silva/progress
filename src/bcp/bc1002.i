&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : bc1002.i
    Purpose     : Procedimentos para leitura dos valores de campo da 
                  temp-table tt-campos

    Syntax      : {bcp/bcapi017.i} /* defini‡Æo tt-campos */
                  {bcp/bc1002.i}

    Description : obtemQuantRegistro - retorna a quantidade de registros
                  de um determinado segmento.
                  obtemValorCampo - retorna o valor do campo em um segmento
                  e registro.

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemQuantRegistro Include 
PROCEDURE obtemQuantRegistro :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o n£mero de registro para determinado segmento (tipo de 
               registro) em tt-campos
  Parameters:  bc-layout, tipo-registro, output numero-registros
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-segmento          AS INTEGER NO-UNDO. /*num-layout-registro*/
DEF OUTPUT PARAM p-quant-registro   AS INTEGER NO-UNDO.

    /* conta quantos registros existem para o segmento */
    FOR EACH tt-campos
        WHERE tt-campos.segmento = p-segmento
        BREAK BY tt-campos.registro:
        IF  FIRST-OF(tt-campos.registro) THEN
            p-quant-registro = p-quant-registro + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemValorCampo Include 
PROCEDURE obtemValorCampo :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o valor do campo na temp-table tt-campos
  Parameters:  p-segmento, num-registro, tabela.campo, output valor
  Notes:       Retorna "OK" ou "NOK"
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-segmento      AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-registro      AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-campo         AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-valor        AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-decimal      AS CHARACTER NO-UNDO.
DEF VAR c-aux AS CHAR.
         
    ASSIGN p-campo = TRIM(p-campo).

    FIND FIRST tt-campos
         WHERE tt-campos.segmento = p-segmento
           AND tt-campos.registro = p-registro
           AND tt-campos.campo    = p-campo
         NO-ERROR.
    IF  NOT AVAIL tt-campos THEN
        RETURN "NOK":U.
    ASSIGN 
          p-valor   = tt-campos.valor
          c-aux     = string(tt-campos.num-decimal)
          p-decimal = (IF c-aux = ? THEN "0":U ELSE c-aux).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

