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
{include/i-prgvrs.i AB0609A 2.00.00.003}  /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0609a MAB}
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
&GLOBAL-DEFINE Program        AB0609A
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-estab-ini fi-estab-fim fi-empresa-ini ~
                              fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-tag-ini fi-tag-fim ~
                              fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-estrut-ini ~
                              fi-estrut-fim fi-cc-cod-eqpto-ini fi-cc-cod-eqpto-fim fi-sit-ini fi-sit-fim fi-atividade-ini ~
                              fi-atividade-fim fi-periodo-ini fi-periodo-fim fi-trajeto-ini fi-trajeto-fim fi-cc-cod-docto-ini fi-cc-cod-docto-fim fi-propri-ini fi-propri-fim

{abp/ab0609.i} /** Defini‡Æo da ttSelecao **/

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
IMAGE-25 IMAGE-26 IMAGE-29 IMAGE-30 IMAGE-31 IMAGE-32 IMAGE-33 IMAGE-34 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 RECT-23 rtToolBar IMAGE-35 IMAGE-36 ~
IMAGE-37 IMAGE-38 fi-periodo-ini fi-periodo-fim fi-empresa-ini ~
fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-grupo-ini fi-grupo-fim ~
fi-modelo-ini fi-modelo-fim fi-estab-ini fi-estab-fim fi-tag-ini fi-tag-fim ~
fi-estrut-ini fi-estrut-fim fi-cc-cod-eqpto-ini fi-cc-cod-eqpto-fim ~
fi-sit-ini fi-sit-fim fi-atividade-ini fi-atividade-fim fi-trajeto-ini ~
fi-trajeto-fim fi-cc-cod-docto-ini fi-cc-cod-docto-fim fi-propri-ini ~
fi-propri-fim fi-unid-negoc-ini fi-unid-negoc-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-periodo-ini fi-periodo-fim ~
fi-empresa-ini fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-grupo-ini ~
fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-estab-ini fi-estab-fim ~
fi-tag-ini fi-tag-fim fi-estrut-ini fi-estrut-fim fi-cc-cod-eqpto-ini ~
fi-cc-cod-eqpto-fim fi-sit-ini fi-sit-fim fi-atividade-ini fi-atividade-fim ~
fi-trajeto-ini fi-trajeto-fim fi-cc-cod-docto-ini fi-cc-cod-docto-fim ~
fi-propri-ini fi-propri-fim fi-unid-negoc-ini fi-unid-negoc-fim 

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

DEFINE VARIABLE fi-atividade-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-atividade-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Atividade":R11 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-cod-docto-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-cod-docto-ini AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Docto":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-cod-eqpto-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-cod-eqpto-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo Eqpto" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estrut-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estrut-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Estrutura Mecƒnica" 
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

DEFINE VARIABLE fi-propri-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-propri-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Propriet rio":R20 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sit-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sit-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "TAG" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-trajeto-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-trajeto-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Trajeto":R9 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
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

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 15.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-periodo-ini AT ROW 1.25 COL 23 COLON-ALIGNED
     fi-periodo-fim AT ROW 1.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-empresa-ini AT ROW 2.25 COL 27 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 2.25 COL 45.43 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-equipto-ini AT ROW 3.25 COL 19 COLON-ALIGNED
     fi-equipto-fim AT ROW 3.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-grupo-ini AT ROW 4.25 COL 23 COLON-ALIGNED
     fi-grupo-fim AT ROW 4.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-modelo-ini AT ROW 5.25 COL 23 COLON-ALIGNED
     fi-modelo-fim AT ROW 5.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-estab-ini AT ROW 6.25 COL 28 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     fi-estab-fim AT ROW 6.25 COL 45.43 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-tag-ini AT ROW 7.25 COL 19 COLON-ALIGNED
     fi-tag-fim AT ROW 7.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-estrut-ini AT ROW 8.25 COL 23 COLON-ALIGNED
     fi-estrut-fim AT ROW 8.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-cc-cod-eqpto-ini AT ROW 9.25 COL 15 COLON-ALIGNED
     fi-cc-cod-eqpto-fim AT ROW 9.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-sit-ini AT ROW 10.25 COL 23 COLON-ALIGNED
     fi-sit-fim AT ROW 10.25 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-atividade-ini AT ROW 11.25 COL 23 COLON-ALIGNED HELP
          "C¢digo da Atividade"
     fi-atividade-fim AT ROW 11.25 COL 45.43 COLON-ALIGNED HELP
          "C¢digo da Atividade" NO-LABEL
     fi-trajeto-ini AT ROW 12.25 COL 21 COLON-ALIGNED HELP
          "C¢digo do Trajeto que o Equipamento est  percorrendo"
     fi-trajeto-fim AT ROW 12.25 COL 45.43 COLON-ALIGNED HELP
          "C¢digo do Trajeto que o Equipamento est  percorrendo" NO-LABEL
     fi-cc-cod-docto-ini AT ROW 13.25 COL 15 COLON-ALIGNED HELP
          "C¢digo do Trajeto que o Equipamento est  percorrendo"
     fi-cc-cod-docto-fim AT ROW 13.25 COL 45.43 COLON-ALIGNED HELP
          "C¢digo do Centro de Custo do Documento" NO-LABEL
     fi-propri-ini AT ROW 14.25 COL 23 COLON-ALIGNED HELP
          "C¢digo do Propriet rio"
     fi-propri-fim AT ROW 14.25 COL 45.43 COLON-ALIGNED HELP
          "C¢digo do Propriet rio" NO-LABEL
     fi-unid-negoc-ini AT ROW 15.25 COL 30 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-unid-negoc-fim AT ROW 15.25 COL 45.43 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     btOK AT ROW 16.96 COL 2
     btCancel AT ROW 16.96 COL 13
     btHelp2 AT ROW 17 COL 65
     IMAGE-10 AT ROW 4.25 COL 43.57
     IMAGE-11 AT ROW 5.25 COL 43.57
     IMAGE-12 AT ROW 5.25 COL 37.72
     IMAGE-13 AT ROW 7.25 COL 43.57
     IMAGE-14 AT ROW 7.25 COL 37.72
     IMAGE-15 AT ROW 8.25 COL 37.72
     IMAGE-16 AT ROW 8.25 COL 43.57
     IMAGE-19 AT ROW 9.25 COL 43.57
     IMAGE-20 AT ROW 9.25 COL 37.72
     IMAGE-21 AT ROW 6.25 COL 43.57
     IMAGE-22 AT ROW 6.25 COL 37.72
     IMAGE-23 AT ROW 10.25 COL 43.57
     IMAGE-24 AT ROW 10.25 COL 37.72
     IMAGE-25 AT ROW 11.25 COL 43.57
     IMAGE-26 AT ROW 11.25 COL 37.72
     IMAGE-29 AT ROW 1.25 COL 43.86
     IMAGE-30 AT ROW 1.25 COL 38
     IMAGE-31 AT ROW 12.25 COL 43.57
     IMAGE-32 AT ROW 12.25 COL 37.72
     IMAGE-33 AT ROW 13.25 COL 43.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.43 BY 17.21
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     IMAGE-34 AT ROW 13.25 COL 37.72
     IMAGE-5 AT ROW 2.25 COL 37.72
     IMAGE-6 AT ROW 2.25 COL 43.57
     IMAGE-7 AT ROW 3.29 COL 37.72
     IMAGE-8 AT ROW 3.29 COL 43.57
     IMAGE-9 AT ROW 4.25 COL 37.72
     RECT-23 AT ROW 1 COL 1
     rtToolBar AT ROW 16.75 COL 1
     IMAGE-35 AT ROW 14.21 COL 43.72
     IMAGE-36 AT ROW 14.21 COL 37.72
     IMAGE-37 AT ROW 15.21 COL 37.72
     IMAGE-38 AT ROW 15.21 COL 43.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.43 BY 17.21
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
         HEIGHT             = 17.25
         WIDTH              = 75.43
         MAX-HEIGHT         = 19.29
         MAX-WIDTH          = 75.43
         VIRTUAL-HEIGHT     = 19.29
         VIRTUAL-WIDTH      = 75.43
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
   LIKE = ems2cadempresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo                                     */
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


ASSIGN     fi-periodo-ini     = today
           fi-periodo-fim     = today.


ASSIGN fi-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-estab-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.
/*--- L¢gica para inicializa‡Æo do programam ---*/
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
       IMAGE-37:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-38:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:
    find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fi-empresa-ini:screen-value   = string(ttSelecao.empresa-ini)
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
               fi-cc-cod-eqpto-ini:screen-value    = ttSelecao.cc-cod-eqpto-ini     
               fi-cc-cod-eqpto-fim:screen-value    = ttSelecao.cc-cod-eqpto-fim     
               fi-sit-ini:screen-value       = ttSelecao.sit-ini        
               fi-sit-fim:screen-value       = ttSelecao.sit-fim        
               fi-atividade-ini:screen-value = ttSelecao.atividade-ini  
               fi-atividade-fim:screen-value = ttSelecao.atividade-fim  
               fi-periodo-ini:screen-value   = string(ttSelecao.periodo-ini)
               fi-periodo-fim:screen-value   = string(ttSelecao.periodo-fim)
               fi-trajeto-ini:screen-value   = ttSelecao.trajeto-ini    
               fi-trajeto-fim:screen-value   = ttSelecao.trajeto-fim
               fi-cc-cod-docto-ini:screen-value    = ttSelecao.cc-cod-docto-ini     
               fi-cc-cod-docto-fim:screen-value    = ttSelecao.cc-cod-docto-fim
               fi-propri-ini :screen-value   = string(ttSelecao.cod-emitente-ini)  
               fi-propri-fim :screen-value   = string(ttSelecao.cod-emitente-fim).  

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN fi-unid-negoc-ini:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-ini
                       fi-unid-negoc-fim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-fim.
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
           ttSelecao.cc-cod-eqpto-ini   =  fi-cc-cod-eqpto-ini:screen-value in frame fPage0
           ttSelecao.cc-cod-eqpto-fim   =  fi-cc-cod-eqpto-fim:screen-value in frame fPage0
           ttSelecao.sit-ini            =  fi-sit-ini:screen-value in frame fPage0        
           ttSelecao.sit-fim            =  fi-sit-fim:screen-value in frame fPage0        
           ttSelecao.atividade-ini      =  fi-atividade-ini:screen-value in frame fPage0
           ttSelecao.atividade-fim      =  fi-atividade-fim:screen-value in frame fPage0
           ttSelecao.periodo-ini        =  date(fi-periodo-ini:screen-value in frame fPage0)    
           ttSelecao.periodo-fim        =  date(fi-periodo-fim:screen-value in frame fPage0)
           ttSelecao.trajeto-ini        =  fi-trajeto-ini:screen-value in frame fPage0
           ttSelecao.trajeto-fim        =  fi-trajeto-fim:screen-value in frame fPage0
           ttSelecao.cc-cod-docto-ini   =  fi-cc-cod-docto-ini:screen-value in frame fPage0
           ttSelecao.cc-cod-docto-fim   =  fi-cc-cod-docto-fim:screen-value in frame fPage0
           ttSelecao.cod-emitente-ini   =  int(fi-propri-ini:screen-value in frame fPage0)
           ttSelecao.cod-emitente-fim   =  int(fi-propri-fim:screen-value in frame fPage0).

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN ttSelecao.cod-unid-negoc-ini = fi-unid-negoc-ini:screen-value in frame fPage0
                   ttSelecao.cod-unid-negoc-fim = fi-unid-negoc-fim:screen-value in frame fPage0.
        END.
    &ENDIF
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

