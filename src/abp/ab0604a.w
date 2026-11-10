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
{include/i-prgvrs.i AB0604A 2.00.00.006 } /*** 010006 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0604a MAB}
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
&GLOBAL-DEFINE Program        AB0604A
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-estab-ini fi-estab-fim fi-empresa-ini ~
                              fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-tag-ini fi-tag-fim ~
                              fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-estrut-ini ~
                              fi-estrut-fim fi-ccusto-ini fi-ccusto-fim fi-sit-ini fi-sit-fim fi-ano-fabric-ini ~
                              fi-ano-fabric-fim fi-periodo-ini fi-periodo-fim fi-cod-emitente-ini fi-cod-emitente-fim ~
                              fi-placa-ini fi-placa-fim fi-dat-compra-ini fi-dat-compra-fim fi-val-compra-ini fi-val-compra-fim fi-tipo-mater-ini fi-tipo-mater-fim

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&IF "{&mguni_version}" >= "2.071" &THEN
def input-output param p-empresa-ini    LIKE empresa.ep-codigo no-undo.
&ELSE
def input-output param p-empresa-ini    as int no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def input-output param p-empresa-fim    LIKE empresa.ep-codigo no-undo.
&ELSE
def input-output param p-empresa-fim    as int no-undo.
&ENDIF
def input-output param p-equipto-ini    as char no-undo.
def input-output param p-equipto-fim    as char no-undo.
def input-output param p-grupo-ini      as char no-undo.
def input-output param p-grupo-fim      as char no-undo.
def input-output param p-modelo-ini     as char no-undo.
def input-output param p-modelo-fim     as char no-undo.
def input-output param p-estab-ini      as char no-undo.
def input-output param p-estab-fim      as char no-undo.
def input-output param p-tag-ini        as char no-undo.
def input-output param p-tag-fim        as char no-undo.
def input-output param p-estrut-ini     as char no-undo.
def input-output param p-estrut-fim     as char no-undo.
def input-output param p-ccusto-ini     as char no-undo.
def input-output param p-ccusto-fim     as char no-undo.
def input-output param p-sit-ini        as char no-undo.
def input-output param p-sit-fim        as char no-undo.
def input-output param p-ano-fabric-ini as int no-undo.  
def input-output param p-ano-fabric-fim as int no-undo.  
def input-output param p-periodo-ini    as date no-undo.
def input-output param p-periodo-fim    as date no-undo.
def input-output param p-emitente-ini   as int no-undo.
def input-output param p-emitente-fim   as int no-undo.
def input-output param p-placa-ini      as CHAR no-undo.
def input-output param p-placa-fim      as CHAR no-undo.
def input-output param p-dat-compra-ini as date no-undo.
def input-output param p-dat-compra-fim as date no-undo.
def input-output param p-val-compra-ini as dec  no-undo.
def input-output param p-val-compra-fim as dec  no-undo.
DEF INPUT-OUTPUT PARAM p-tipo-mater-ini AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM p-tipo-mater-fim AS CHAR NO-UNDO.
&IF DEFINED(bf_mnt_ems206b) &THEN
def input-output param p-unid-negoc-ini as char no-undo.
def input-output param p-unid-negoc-fim as char no-undo.
&ENDIF

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
IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 ~
rtToolBar IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 fi-empresa-ini fi-empresa-fim ~
fi-equipto-ini fi-equipto-fim fi-grupo-ini fi-grupo-fim fi-modelo-ini ~
fi-modelo-fim fi-estab-ini fi-estab-fim fi-tag-ini fi-tag-fim fi-estrut-ini ~
fi-estrut-fim fi-ccusto-ini fi-ccusto-fim fi-sit-ini fi-sit-fim ~
fi-ano-fabric-ini fi-ano-fabric-fim fi-periodo-ini fi-periodo-fim ~
fi-cod-emitente-ini fi-cod-emitente-fim fi-placa-ini fi-placa-fim ~
fi-dat-compra-ini fi-dat-compra-fim fi-val-compra-ini fi-val-compra-fim ~
fi-tipo-mater-ini fi-tipo-mater-fim fi-unid-negoc-ini fi-unid-negoc-fim ~
btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-empresa-ini fi-empresa-fim ~
fi-equipto-ini fi-equipto-fim fi-grupo-ini fi-grupo-fim fi-modelo-ini ~
fi-modelo-fim fi-estab-ini fi-estab-fim fi-tag-ini fi-tag-fim fi-estrut-ini ~
fi-estrut-fim fi-ccusto-ini fi-ccusto-fim fi-sit-ini fi-sit-fim ~
fi-ano-fabric-ini fi-ano-fabric-fim fi-periodo-ini fi-periodo-fim ~
fi-cod-emitente-ini fi-cod-emitente-fim fi-placa-ini fi-placa-fim ~
fi-dat-compra-ini fi-dat-compra-fim fi-val-compra-ini fi-val-compra-fim ~
fi-tipo-mater-ini fi-tipo-mater-fim fi-unid-negoc-ini fi-unid-negoc-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-ano-fabric-fim AS INTEGER FORMAT ">,>>9":U INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ano-fabric-ini AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Ano Fabrica‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-dat-compra-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-compra-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Compra":R8 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

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

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

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

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-placa-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-placa-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Placa" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

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

DEFINE VARIABLE fi-tipo-mater-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-mater-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Tipo Material" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-compra-fim AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 999999999.99 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-compra-ini AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Compra":R15 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

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
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-empresa-ini AT ROW 1.5 COL 14.29 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 1.5 COL 45.43 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-equipto-ini AT ROW 2.5 COL 14.29 COLON-ALIGNED
     fi-equipto-fim AT ROW 2.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-grupo-ini AT ROW 3.5 COL 14.29 COLON-ALIGNED
     fi-grupo-fim AT ROW 3.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-modelo-ini AT ROW 4.5 COL 14.29 COLON-ALIGNED
     fi-modelo-fim AT ROW 4.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-estab-ini AT ROW 5.5 COL 14.29 COLON-ALIGNED
     fi-estab-fim AT ROW 5.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-tag-ini AT ROW 6.5 COL 14.29 COLON-ALIGNED
     fi-tag-fim AT ROW 6.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-estrut-ini AT ROW 7.5 COL 14.57 COLON-ALIGNED
     fi-estrut-fim AT ROW 7.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-ccusto-ini AT ROW 8.5 COL 14.57 COLON-ALIGNED
     fi-ccusto-fim AT ROW 8.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-sit-ini AT ROW 9.5 COL 14.29 COLON-ALIGNED
     fi-sit-fim AT ROW 9.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-ano-fabric-ini AT ROW 10.5 COL 14.29 COLON-ALIGNED
     fi-ano-fabric-fim AT ROW 10.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-periodo-ini AT ROW 11.5 COL 14.29 COLON-ALIGNED
     fi-periodo-fim AT ROW 11.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-cod-emitente-ini AT ROW 12.5 COL 14.29 COLON-ALIGNED HELP
          "C¢digo do emitente"
     fi-cod-emitente-fim AT ROW 12.5 COL 45.43 COLON-ALIGNED HELP
          "C¢digo do emitente" NO-LABEL
     fi-placa-ini AT ROW 13.46 COL 14.14 COLON-ALIGNED
     fi-placa-fim AT ROW 13.5 COL 45.43 COLON-ALIGNED NO-LABEL
     fi-dat-compra-ini AT ROW 14.46 COL 14.14 COLON-ALIGNED HELP
          "Data Compra"
     fi-dat-compra-fim AT ROW 14.46 COL 45.29 COLON-ALIGNED HELP
          "Data Compra" NO-LABEL
     fi-val-compra-ini AT ROW 15.46 COL 14.14 COLON-ALIGNED HELP
          "Valor da Compra"
     fi-val-compra-fim AT ROW 15.46 COL 45.29 COLON-ALIGNED HELP
          "Valor da Compra" NO-LABEL
     fi-tipo-mater-ini AT ROW 16.46 COL 14.14 COLON-ALIGNED WIDGET-ID 10
     fi-tipo-mater-fim AT ROW 16.46 COL 45.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fi-unid-negoc-ini AT ROW 17.46 COL 14.14 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-unid-negoc-fim AT ROW 17.46 COL 45.29 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     btOK AT ROW 19.42 COL 2
     btCancel AT ROW 19.42 COL 13
     btHelp2 AT ROW 19.42 COL 59.29
     IMAGE-10 AT ROW 4.5 COL 43.72
     IMAGE-11 AT ROW 5.5 COL 43.72
     IMAGE-12 AT ROW 5.5 COL 37.72
     IMAGE-13 AT ROW 7.5 COL 43.72
     IMAGE-14 AT ROW 7.5 COL 37.72
     IMAGE-15 AT ROW 8.5 COL 37.72
     IMAGE-16 AT ROW 8.5 COL 43.72
     IMAGE-19 AT ROW 9.5 COL 43.72
     IMAGE-20 AT ROW 9.5 COL 37.72
     IMAGE-21 AT ROW 6.5 COL 43.72
     IMAGE-22 AT ROW 6.5 COL 37.72
     IMAGE-23 AT ROW 10.5 COL 43.72
     IMAGE-24 AT ROW 10.5 COL 37.72
     IMAGE-25 AT ROW 11.5 COL 43.72
     IMAGE-26 AT ROW 11.5 COL 37.72
     IMAGE-29 AT ROW 1.5 COL 43.72
     IMAGE-30 AT ROW 1.5 COL 37.86
     IMAGE-31 AT ROW 12.5 COL 43.72
     IMAGE-32 AT ROW 12.5 COL 37.72
     IMAGE-33 AT ROW 13.42 COL 43.72
     IMAGE-34 AT ROW 13.5 COL 37.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.14 BY 19.63
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     IMAGE-35 AT ROW 14.46 COL 37.72
     IMAGE-36 AT ROW 14.38 COL 43.72
     IMAGE-37 AT ROW 15.46 COL 37.72
     IMAGE-38 AT ROW 15.38 COL 43.72
     IMAGE-5 AT ROW 2.5 COL 37.72
     IMAGE-6 AT ROW 2.5 COL 43.72
     IMAGE-7 AT ROW 3.54 COL 37.72
     IMAGE-8 AT ROW 3.54 COL 43.72
     IMAGE-9 AT ROW 4.5 COL 37.72
     rtToolBar AT ROW 19.21 COL 1
     IMAGE-39 AT ROW 17.46 COL 37.72
     IMAGE-40 AT ROW 17.46 COL 43.72
     IMAGE-41 AT ROW 16.46 COL 37.72 WIDGET-ID 6
     IMAGE-42 AT ROW 16.46 COL 43.72 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.14 BY 19.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.75
         WIDTH              = 69.14
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
         MIN-BUTTON         = no
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
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
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

    do with frame fPage0:
        assign &IF "{&mguni_version}" >= "2.071" &THEN
               p-empresa-ini        =  fi-empresa-ini:screen-value
               p-empresa-fim        =  fi-empresa-fim:screen-value
               &ELSE
               p-empresa-ini        =  int(fi-empresa-ini:screen-value)    
               p-empresa-fim        =  int(fi-empresa-fim:screen-value)    
               &ENDIF
               p-equipto-ini        =  fi-equipto-ini:screen-value    
               p-equipto-fim        =  fi-equipto-fim:screen-value    
               p-grupo-ini          =  fi-grupo-ini:screen-value      
               p-grupo-fim          =  fi-grupo-fim:screen-value      
               p-modelo-ini         =  fi-modelo-ini:screen-value     
               p-modelo-fim         =  fi-modelo-fim:screen-value     
               p-estab-ini          =  fi-estab-ini:screen-value      
               p-estab-fim          =  fi-estab-fim:screen-value      
               p-tag-ini            =  fi-tag-ini:screen-value        
               p-tag-fim            =  fi-tag-fim:screen-value        
               p-estrut-ini         =  fi-estrut-ini:screen-value     
               p-estrut-fim         =  fi-estrut-fim:screen-value     
               p-ccusto-ini         =  fi-ccusto-ini:screen-value     
               p-ccusto-fim         =  fi-ccusto-fim:screen-value     
               p-sit-ini            =  fi-sit-ini:screen-value        
               p-sit-fim            =  fi-sit-fim:screen-value        
               p-ano-fabric-ini     =  int(fi-ano-fabric-ini:screen-value) 
               p-ano-fabric-fim     =  int(fi-ano-fabric-fim:screen-value) 
               p-periodo-ini        =  date(fi-periodo-ini:screen-value)    
               p-periodo-fim        =  date(fi-periodo-fim:screen-value)
               p-emitente-ini       =  int(fi-cod-emitente-ini:screen-value)
               p-emitente-fim       =  int(fi-cod-emitente-fim:screen-value)
               p-placa-ini          =  fi-placa-ini:SCREEN-VALUE
               p-placa-fim          =  fi-placa-fim:SCREEN-VALUE
               p-dat-compra-ini     =  date(fi-dat-compra-ini:screen-value)
               p-dat-compra-fim     =  date(fi-dat-compra-fim:screen-value)
               p-val-compra-ini     =  dec(fi-val-compra-ini:screen-value)
               p-val-compra-fim     =  dec(fi-val-compra-fim:screen-value)
               p-tipo-mater-ini     =  fi-tipo-mater-ini:SCREEN-VALUE
               p-tipo-mater-fim     =  fi-tipo-mater-fim:SCREEN-VALUE.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN p-unid-negoc-ini = fi-unid-negoc-ini:screen-value in frame fPage0
                       p-unid-negoc-fim = fi-unid-negoc-fim:screen-value in frame fPage0.
            END.
        &ENDIF
    end.

    apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


ASSIGN     fi-periodo-ini     = today
           fi-periodo-fim     = today.

ASSIGN p-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       p-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

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
ASSIGN fi-periodo-ini:SCREEN-VALUE IN FRAME fPage0 = string(today)  
       fi-periodo-fim:SCREEN-VALUE IN FRAME fPage0 = string(today).

ASSIGN fi-unid-negoc-ini:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ini:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-39:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-40:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:

    assign fi-empresa-ini:screen-value       =    string(p-empresa-ini)   
           fi-empresa-fim:screen-value       =    string(p-empresa-fim)   
           fi-equipto-ini:screen-value       =    p-equipto-ini   
           fi-equipto-fim:screen-value       =    p-equipto-fim   
           fi-grupo-ini:screen-value         =    p-grupo-ini     
           fi-grupo-fim:screen-value         =    p-grupo-fim     
           fi-modelo-ini:screen-value        =    p-modelo-ini    
           fi-modelo-fim:screen-value        =    p-modelo-fim    
           fi-estab-ini:screen-value         =    p-estab-ini     
           fi-estab-fim:screen-value         =    p-estab-fim     
           fi-tag-ini:screen-value           =    p-tag-ini       
           fi-tag-fim:screen-value           =    p-tag-fim       
           fi-estrut-ini:screen-value        =    p-estrut-ini    
           fi-estrut-fim:screen-value        =    p-estrut-fim    
           fi-ccusto-ini:screen-value        =    p-ccusto-ini    
           fi-ccusto-fim:screen-value        =    p-ccusto-fim    
           fi-sit-ini:screen-value           =    p-sit-ini       
           fi-sit-fim:screen-value           =    p-sit-fim       
           fi-ano-fabric-ini:screen-value    =    string(p-ano-fabric-ini)
           fi-ano-fabric-fim:screen-value    =    string(p-ano-fabric-fim)
           fi-periodo-ini:screen-value       =    string(p-periodo-ini)   
           fi-periodo-fim:screen-value       =    string(p-periodo-fim)
           fi-cod-emitente-ini:screen-value  =    string(p-emitente-ini)   
           fi-cod-emitente-fim:screen-value  =    string(p-emitente-fim)
           fi-placa-ini:SCREEN-VALUE         =    p-placa-ini
           fi-placa-fim:SCREEN-VALUE         =    p-placa-fim
           fi-dat-compra-ini:screen-value    =    string(p-dat-compra-ini)
           fi-dat-compra-fim:screen-value    =    string(p-dat-compra-fim)
           fi-val-compra-ini:screen-value    =    string(p-val-compra-ini)
           fi-val-compra-fim:screen-value    =    string(p-val-compra-fim)
           fi-tipo-mater-ini:SCREEN-VALUE    =    p-tipo-mater-ini
           fi-tipo-mater-fim:SCREEN-VALUE    =    p-tipo-mater-fim.

    {utp/ut-liter.i Data_Compra}
    assign fi-dat-compra-ini:label = return-value.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN fi-unid-negoc-ini:SCREEN-VALUE IN FRAME fPage0 = p-unid-negoc-ini
                   fi-unid-negoc-fim:SCREEN-VALUE IN FRAME fPage0 = p-unid-negoc-fim.
        END.
    &ENDIF
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

