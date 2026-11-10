&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0613A 2.00.00.003 } /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0613a MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0613A
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-estab-ini fi-estab-fim fi-empresa-ini ~
                              fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-tag-ini fi-tag-fim ~
                              fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-estrut-ini ~
                              fi-estrut-fim fi-gr-ev-ini fi-gr-ev-fim fi-evento-ini fi-evento-fim ~
                              fi-comp-ini fi-comp-fim fi-periodo-ini fi-periodo-fim fi-c-custo-ini fi-c-custo-fim ~
                              fi-causa-ini fi-causa-fim

{abp/ab0613.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 ~
IMAGE-15 IMAGE-16 IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 ~
IMAGE-29 IMAGE-30 IMAGE-33 IMAGE-34 IMAGE-47 IMAGE-48 IMAGE-5 IMAGE-6 ~
IMAGE-7 IMAGE-8 IMAGE-9 rtToolBar IMAGE-59 IMAGE-60 IMAGE-61 IMAGE-62 ~
fi-periodo-ini fi-periodo-fim fi-empresa-ini fi-empresa-fim fi-equipto-ini ~
fi-equipto-fim fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim ~
fi-estab-ini fi-estab-fim fi-tag-ini fi-tag-fim fi-c-custo-ini ~
fi-c-custo-fim fi-estrut-ini fi-estrut-fim fi-gr-ev-ini fi-gr-ev-fim ~
fi-evento-ini fi-evento-fim fi-comp-ini fi-comp-fim fi-causa-ini ~
fi-causa-fim fi-unid-negoc-ini fi-unid-negoc-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-periodo-ini fi-periodo-fim ~
fi-empresa-ini fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-grupo-ini ~
fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-estab-ini fi-estab-fim ~
fi-tag-ini fi-tag-fim fi-c-custo-ini fi-c-custo-fim fi-estrut-ini ~
fi-estrut-fim fi-gr-ev-ini fi-gr-ev-fim fi-evento-ini fi-evento-fim ~
fi-comp-ini fi-comp-fim fi-causa-ini fi-causa-fim fi-unid-negoc-ini ~
fi-unid-negoc-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-c-custo-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-custo-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-causa-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-causa-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Causa" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-comp-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-comp-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Compartimento / Filtro" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estrut-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estrut-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Estrutura Mecƒnica" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-evento-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-evento-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Evento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gr-ev-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gr-ev-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Grupo Evento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Modelo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Tag" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-48
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-59
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-60
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-61
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-62
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.29 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-periodo-ini AT ROW 1.33 COL 15.43 COLON-ALIGNED
     fi-periodo-fim AT ROW 1.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-empresa-ini AT ROW 2.33 COL 15.43 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 2.33 COL 46 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-equipto-ini AT ROW 3.33 COL 15.43 COLON-ALIGNED
     fi-equipto-fim AT ROW 3.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-grupo-ini AT ROW 4.33 COL 15.43 COLON-ALIGNED
     fi-grupo-fim AT ROW 4.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-modelo-ini AT ROW 5.33 COL 15.43 COLON-ALIGNED
     fi-modelo-fim AT ROW 5.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-estab-ini AT ROW 6.33 COL 15.43 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     fi-estab-fim AT ROW 6.33 COL 46 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-tag-ini AT ROW 7.33 COL 15.43 COLON-ALIGNED
     fi-tag-fim AT ROW 7.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-c-custo-ini AT ROW 8.33 COL 15.43 COLON-ALIGNED
     fi-c-custo-fim AT ROW 8.33 COL 46 COLON-ALIGNED HELP
          "C¢digo do Centro de Custo" NO-LABEL
     fi-estrut-ini AT ROW 9.33 COL 15.43 COLON-ALIGNED
     fi-estrut-fim AT ROW 9.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-gr-ev-ini AT ROW 10.33 COL 15.43 COLON-ALIGNED
     fi-gr-ev-fim AT ROW 10.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-evento-ini AT ROW 11.33 COL 15.43 COLON-ALIGNED
     fi-evento-fim AT ROW 11.33 COL 46 COLON-ALIGNED NO-LABEL
     fi-comp-ini AT ROW 12.33 COL 15.43 COLON-ALIGNED
     fi-comp-fim AT ROW 12.33 COL 46 COLON-ALIGNED HELP
          "C¢digo da Atividade" NO-LABEL
     fi-causa-ini AT ROW 13.33 COL 15.43 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-causa-fim AT ROW 13.33 COL 46 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     fi-unid-negoc-ini AT ROW 14.33 COL 15.43 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-unid-negoc-fim AT ROW 14.33 COL 46 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     btOK AT ROW 16.08 COL 2
     btCancel AT ROW 16.08 COL 13
     btHelp2 AT ROW 16.08 COL 58.43
     IMAGE-10 AT ROW 5.33 COL 44.29
     IMAGE-11 AT ROW 6.33 COL 44.29
     IMAGE-12 AT ROW 6.33 COL 38.29
     IMAGE-13 AT ROW 9.33 COL 44.29
     IMAGE-14 AT ROW 9.33 COL 38.29
     IMAGE-15 AT ROW 10.33 COL 38.29
     IMAGE-16 AT ROW 10.33 COL 44.29
     IMAGE-19 AT ROW 11.33 COL 44.29
     IMAGE-20 AT ROW 11.33 COL 38.29
     IMAGE-21 AT ROW 7.33 COL 44.29
     IMAGE-22 AT ROW 7.33 COL 38.29
     IMAGE-23 AT ROW 12.33 COL 44.29
     IMAGE-24 AT ROW 12.33 COL 38.29
     IMAGE-29 AT ROW 2.33 COL 44.29
     IMAGE-30 AT ROW 2.33 COL 38.29
     IMAGE-33 AT ROW 1.33 COL 44.29
     IMAGE-34 AT ROW 1.33 COL 38.29
     IMAGE-47 AT ROW 8.33 COL 44.29
     IMAGE-48 AT ROW 8.33 COL 38.29
     IMAGE-5 AT ROW 3.33 COL 38.29
     IMAGE-6 AT ROW 3.33 COL 44.29
     IMAGE-7 AT ROW 4.33 COL 38.29
     IMAGE-8 AT ROW 4.33 COL 44.29
     IMAGE-9 AT ROW 5.33 COL 38.29
     rtToolBar AT ROW 15.88 COL 1
     IMAGE-59 AT ROW 14.33 COL 38.29
     IMAGE-60 AT ROW 14.33 COL 44.29
     IMAGE-61 AT ROW 13.33 COL 38.29 WIDGET-ID 6
     IMAGE-62 AT ROW 13.33 COL 44.29 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.29 BY 16.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.29
         WIDTH              = 68.29
         MAX-HEIGHT         = 16.29
         MAX-WIDTH          = 68.29
         VIRTUAL-HEIGHT     = 16.29
         VIRTUAL-WIDTH      = 68.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-empresa-fim IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-estab-fim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    run piGrava in this-procedure.  
    apply "CLOSE":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN fi-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-estab-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN fi-unid-negoc-ini:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ini:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-59:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-60:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:
    find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fi-periodo-ini:screen-value   = string(ttSelecao.periodo-ini)
               fi-periodo-fim:screen-value   = string(ttSelecao.periodo-fim)
               fi-empresa-ini:screen-value   = string(ttSelecao.empresa-ini)
               fi-empresa-fim:screen-value   = string(ttSelecao.empresa-fim)
               fi-equipto-ini:screen-value   = ttSelecao.equipto-ini
               fi-equipto-fim:screen-value   = ttSelecao.equipto-fim
               fi-grupo-ini:screen-value     = ttSelecao.grupo-ini
               fi-grupo-fim:screen-value     = ttSelecao.grupo-fim
               fi-modelo-ini:screen-value    = ttSelecao.modelo-ini
               fi-modelo-fim:screen-value    = ttSelecao.modelo-fim
               fi-estab-ini:screen-value     = ttSelecao.estab-ini
               fi-estab-fim:screen-value     = ttSelecao.estab-fim
               fi-tag-ini:screen-value       = ttSelecao.tag-ini
               fi-tag-fim:screen-value       = ttSelecao.tag-fim
               fi-estrut-ini:screen-value    = ttSelecao.estrut-ini
               fi-estrut-fim:screen-value    = ttSelecao.estrut-fim
               fi-gr-ev-ini:screen-value     = ttSelecao.gr-ev-ini
               fi-gr-ev-fim:screen-value     = ttSelecao.gr-ev-fim
               fi-evento-ini:screen-value    = ttSelecao.evento-ini
               fi-evento-fim:screen-value    = ttSelecao.evento-fim
               fi-comp-ini:screen-value      = ttSelecao.comp-ini
               fi-comp-fim:screen-value      = ttSelecao.comp-fim
               fi-c-custo-ini:screen-value   = ttSelecao.c-custo-ini
               fi-c-custo-fim:screen-value   = ttSelecao.c-custo-fim
               fi-causa-ini:SCREEN-VALUE     = ttSelecao.causa-ini
               fi-causa-fim:SCREEN-VALUE     = ttSelecao.causa-fim.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN fi-unid-negoc-ini:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.unid-negoc-ini
                       fi-unid-negoc-fim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.unid-negoc-fim.
            END.
        &ENDIF
    end.
end.
           
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os dados de tela na temp-table 
------------------------------------------------------------------------------*/
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.empresa-ini        =  fi-empresa-ini:screen-value in frame fPage0
           ttSelecao.empresa-fim        =  fi-empresa-fim:screen-value in frame fPage0
           &ELSE
           ttSelecao.empresa-ini        =  int(fi-empresa-ini:screen-value in frame fPage0)    
           ttSelecao.empresa-fim        =  int(fi-empresa-fim:screen-value in frame fPage0)    
           &ENDIF
           ttSelecao.equipto-ini        =  fi-equipto-ini:screen-value in frame fPage0    
           ttSelecao.equipto-fim        =  fi-equipto-fim:screen-value in frame fPage0    
           ttSelecao.grupo-ini          =  fi-grupo-ini:screen-value in frame fPage0      
           ttSelecao.grupo-fim          =  fi-grupo-fim:screen-value in frame fPage0      
           ttSelecao.modelo-ini         =  fi-modelo-ini:screen-value in frame fPage0     
           ttSelecao.modelo-fim         =  fi-modelo-fim:screen-value in frame fPage0     
           ttSelecao.estab-ini          =  fi-estab-ini:screen-value in frame fPage0      
           ttSelecao.estab-fim          =  fi-estab-fim:screen-value in frame fPage0      
           ttSelecao.tag-ini            =  fi-tag-ini:screen-value in frame fPage0        
           ttSelecao.tag-fim            =  fi-tag-fim:screen-value in frame fPage0        
           ttSelecao.estrut-ini         =  fi-estrut-ini:screen-value in frame fPage0     
           ttSelecao.estrut-fim         =  fi-estrut-fim:screen-value in frame fPage0     
           ttSelecao.gr-ev-ini          =  fi-gr-ev-ini:screen-value in frame fPage0     
           ttSelecao.gr-ev-fim          =  fi-gr-ev-fim:screen-value in frame fPage0     
           ttSelecao.evento-ini         =  fi-evento-ini:screen-value in frame fPage0        
           ttSelecao.evento-fim         =  fi-evento-fim:screen-value in frame fPage0        
           ttSelecao.comp-ini           =  fi-comp-ini:screen-value in frame fPage0
           ttSelecao.comp-fim           =  fi-comp-fim:screen-value in frame fPage0
           ttSelecao.c-custo-ini        =  fi-c-custo-ini:screen-value in frame fPage0
           ttSelecao.c-custo-fim        =  fi-c-custo-fim:screen-value in frame fPage0
           ttSelecao.periodo-ini        =  input frame fPage0 fi-periodo-ini
           ttSelecao.periodo-fim        =  input frame fPage0 fi-periodo-fim
           ttSelecao.causa-ini          =  fi-causa-ini:SCREEN-VALUE IN FRAME fPage0
           ttSelecao.causa-fim          =  fi-causa-fim:SCREEN-VALUE IN FRAME fPage0.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN ttSelecao.unid-negoc-ini = fi-unid-negoc-ini:screen-value in frame fPage0
                   ttSelecao.unid-negoc-fim = fi-unid-negoc-fim:screen-value in frame fPage0.
        END.
    &ENDIF
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

