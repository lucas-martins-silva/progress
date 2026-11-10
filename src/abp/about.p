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
{include/i-prgvrs.i ABOUT 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i about MAB}
&ENDIF


/*------------------------------------------------------------------------
    File        : abp/about.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : KSM35590 - Herc¡lio Werneck de Capistrano
    Created     :
    Notes       : Procedure que gera o SOBRE do Manuten‡Æo de Frotas
  ----------------------------------------------------------------------*/
  
/* ***************************  Definitions  ************************** */
DEFINE VARIABLE v_nom_prog     as character no-undo.
DEFINE VARIABLE v_nom_prog_ext as character no-undo.
DEFINE VARIABLE v_cod_release  as character no-undo.

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
assign v_nom_prog = substring(current-window:title, 1, max(1, length(current-window:title) - 10))
                    + chr(10)
                    + "AJUDA_MAN_FROTAS":U
       v_nom_prog_ext = "abp/sobre.r":U
       v_cod_release  = c-prg-vrs.

run abp/sobre.p (Input v_nom_prog,
                 Input v_nom_prog_ext,
                 Input v_cod_release) /*prg_fnc_about*/.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


