&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-adiant-despes NO-UNDO LIKE adiant-despes
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-parc NO-UNDO LIKE adiant-despes-parc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0720B 2.00.00.002 } /*** 010002 ***/
{utp/ut-glob.i} 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0720B MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0720B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           tt-adiant-despes-parc
&GLOBAL-DEFINE hDBOTable         h-bocx00443
&GLOBAL-DEFINE DBOTable          adiant-despes-parc

&GLOBAL-DEFINE ttParent          tt-adiant-despes
&GLOBAL-DEFINE DBOParentTable    h-bocx00442

&GLOBAL-DEFINE page0KeyFields    tt-adiant-despes-parc.cod-refer

&GLOBAL-DEFINE page0ParentFields tt-adiant-despes.cod-estabel tt-adiant-despes.cdd-adiant

&GLOBAL-DEFINE page0Fields       tt-adiant-despes-parc.cod-espec-docto ~
                                 tt-adiant-despes-parc.dat-emissao ~
                                 tt-adiant-despes-parc.cod-ser-docto ~
                                 tt-adiant-despes-parc.dat-vencto ~
                                 tt-adiant-despes-parc.cod-tit-ap ~
                                 tt-adiant-despes-parc.val-adiant-moed ~
                                 tt-adiant-despes-parc.cod-parcela ~
                                 tt-adiant-despes-parc.cdn-moeda ~
                                 tt-adiant-despes-parc.dat-prev-pagto

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto LIKE tt-adiant-despes-parc.cod-espec-docto NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto   LIKE tt-adiant-despes-parc.cod-ser-docto   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00442        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00443vl      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx250          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad104          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005          AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa        AS HANDLE      NO-UNDO.

{imp/im0720b.i} /*defini‡Æo temp-tables utilizadas pela API Finan‡as*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.cdd-adiant tt-adiant-despes-parc.cod-refer ~
tt-adiant-despes-parc.cod-espec-docto tt-adiant-despes-parc.cod-ser-docto ~
tt-adiant-despes-parc.cod-tit-ap tt-adiant-despes-parc.cod-parcela ~
tt-adiant-despes-parc.cdn-moeda tt-adiant-despes-parc.dat-emissao ~
tt-adiant-despes-parc.dat-prev-pagto tt-adiant-despes-parc.dat-vencto ~
tt-adiant-despes-parc.val-adiant-moed 
&Scoped-define ENABLED-TABLES tt-adiant-despes tt-adiant-despes-parc
&Scoped-define FIRST-ENABLED-TABLE tt-adiant-despes
&Scoped-define SECOND-ENABLED-TABLE tt-adiant-despes-parc
&Scoped-Define ENABLED-OBJECTS l-gerou-apb c-situacao c-desc-espec ~
c-desc-moeda c-observacao btOK btSave FILL-IN-6 btCancel btHelp rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.cdd-adiant tt-adiant-despes-parc.cod-refer ~
tt-adiant-despes-parc.cod-espec-docto tt-adiant-despes-parc.cod-ser-docto ~
tt-adiant-despes-parc.cod-tit-ap tt-adiant-despes-parc.cod-parcela ~
tt-adiant-despes-parc.cdn-moeda tt-adiant-despes-parc.dat-emissao ~
tt-adiant-despes-parc.dat-prev-pagto tt-adiant-despes-parc.dat-vencto ~
tt-adiant-despes-parc.val-adiant-moed 
&Scoped-define DISPLAYED-TABLES tt-adiant-despes tt-adiant-despes-parc
&Scoped-define FIRST-DISPLAYED-TABLE tt-adiant-despes
&Scoped-define SECOND-DISPLAYED-TABLE tt-adiant-despes-parc
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel l-gerou-apb c-situacao ~
c-desc-espec c-desc-moeda c-observacao FILL-IN-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 68 BY 5.88 NO-UNDO.

DEFINE VARIABLE c-desc-espec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Observa‡Æo:" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-gerou-apb AS LOGICAL INITIAL no 
     LABEL "Gerou T¡tulo APB?" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-adiant-despes.cod-estabel AT ROW 1.5 COL 14 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     c-desc-estabel AT ROW 1.5 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-adiant-despes.cdd-adiant AT ROW 2.5 COL 14 COLON-ALIGNED WIDGET-ID 30
          LABEL "Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     tt-adiant-despes-parc.cod-refer AT ROW 3.46 COL 14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     l-gerou-apb AT ROW 2.46 COL 66.29 WIDGET-ID 22
     c-situacao AT ROW 3.46 COL 64.72 COLON-ALIGNED WIDGET-ID 24
     tt-adiant-despes-parc.cod-espec-docto AT ROW 5.13 COL 14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Esp‚cie"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-espec AT ROW 5.13 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-adiant-despes-parc.cod-ser-docto AT ROW 6.13 COL 14 COLON-ALIGNED WIDGET-ID 10
          LABEL "S‚rie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-adiant-despes-parc.cod-tit-ap AT ROW 7.13 COL 14 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-adiant-despes-parc.cod-parcela AT ROW 8.13 COL 14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-adiant-despes-parc.cdn-moeda AT ROW 9.13 COL 14 COLON-ALIGNED WIDGET-ID 38
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-desc-moeda AT ROW 9.13 COL 17.29 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-adiant-despes-parc.dat-emissao AT ROW 5.13 COL 64.72 COLON-ALIGNED WIDGET-ID 14
          LABEL "Data EmissÆo"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-adiant-despes-parc.dat-prev-pagto AT ROW 6.13 COL 64.72 COLON-ALIGNED WIDGET-ID 34
          LABEL "Data Prev Pagto"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-adiant-despes-parc.dat-vencto AT ROW 7.13 COL 64.72 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-adiant-despes-parc.val-adiant-moed AT ROW 8.13 COL 64.72 COLON-ALIGNED WIDGET-ID 18
          LABEL "Valor Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-observacao AT ROW 10.25 COL 16.29 NO-LABEL WIDGET-ID 26
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13 WIDGET-ID 42
     FILL-IN-6 AT ROW 10.33 COL 5.14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.88
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-adiant-despes T "?" NO-UNDO mgcex adiant-despes
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-parc T "?" NO-UNDO mgcex adiant-despes-parc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.88
         WIDTH              = 90
         MAX-HEIGHT         = 17.42
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.42
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdd-adiant IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.cdn-moeda IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.cod-espec-docto IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.cod-ser-docto IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.dat-emissao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.dat-prev-pagto IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes-parc.val-adiant-moed IN FRAME fpage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    SAVE_block:
    DO TRANS ON ERROR UNDO SAVE_block, LEAVE SAVE_block:

        RUN saveRecord IN THIS-PROCEDURE.
        IF  return-value = "OK":U THEN DO:
          RUN piAtualizaValorAdiantamento IN h-bocx00442 (INPUT tt-adiant-despes.cod-estabel,
                                                          INPUT tt-adiant-despes.cdd-adiant).
          RUN bringParent   IN phCaller.
          RUN DisplayFields IN phCaller.

          APPLY "CLOSE":U TO THIS-PROCEDURE.          
       END.
       ELSE DO:
           UNDO SAVE_block, LEAVE SAVE_block.
       END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    SAVE_block:
    DO TRANS ON ERROR UNDO SAVE_block, LEAVE SAVE_block:
       RUN saveRecord IN THIS-PROCEDURE.
       IF CAN-FIND(FIRST RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           UNDO SAVE_block, LEAVE SAVE_block.
       END.
       ELSE DO:
           IF  RETURN-VALUE = "OK":U THEN DO:
              RUN piAtualizaValorAdiantamento IN h-bocx00442 (INPUT tt-adiant-despes.cod-estabel,
                                                              INPUT tt-adiant-despes.cdd-adiant).
              RUN bringParent   IN phCaller.
              RUN displayFields IN phCaller.
              APPLY "CLOSE":U TO THIS-PROCEDURE.          
           END.
       END.
       RUN afterInitializeInterface.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-parc.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cdn-moeda wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes-parc.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                      &campo=tt-adiant-despes-parc.cdn-moeda
                      &campozoom=mo-codigo
                      &campo2=c-desc-moeda
                      &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cdn-moeda wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes-parc.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-boun005"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-adiant-despes-parc.cdn-moeda:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-moeda"
      &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cdn-moeda wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes-parc.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-parc.cod-espec-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-espec-docto wMaintenanceNoNavigation
ON ENTRY OF tt-adiant-despes-parc.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
  IF SELF:SCREEN-VALUE = "":U OR 
     SELF:SCREEN-VALUE = ?    OR 
     SELF:SCREEN-VALUE = "  ":U THEN 
   ASSIGN SELF:FORMAT       = "X(2)":U
          SELF:SCREEN-VALUE = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-espec-docto wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes-parc.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad103.w
                         &campo=tt-adiant-despes-parc.cod-espec-docto
                         &campozoom=cod-esp
                         &frame=fPage0
                         &campo2=c-desc-espec
                         &campozoom2=descricao
                         &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-espec-docto wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes-parc.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
    IF  LENGTH(SELF:SCREEN-VALUE) <> 2 OR
        ERROR-STATUS:ERROR THEN 
        ASSIGN SELF:FORMAT = "X(2)":U.
    ELSE
        ASSIGN SELF:FORMAT = "!(2)":U.

    {method/referencefields.i  
          &HandleDBOLeave="h-boad104"
          &FindMethod="findEspecie"
          &KeyValue1="tt-adiant-despes-parc.cod-espec-docto:SCREEN-VALUE IN FRAME {&frame-name}"
          &FieldName1="descricao"
          &FieldScreen1="c-desc-espec"
          &Frame1="fPage0"}
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-espec-docto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes-parc.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
   APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
      {method/referencefields.i 
            &HandleDBOLeave="h-boad107"
            &FindMethod="findCodigo"
            &KeyValue1="tt-adiant-despes.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
            &FieldName1="nome"
            &FieldScreen1="c-desc-estabel"
            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-parc.cod-ser-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-ser-docto wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes-parc.cod-ser-docto IN FRAME fpage0 /* S‚rie */
DO:
      {include/zoomvar.i 
        &prog-zoom=dizoom/z01di182.w
        &campo=tt-adiant-despes-parc.cod-ser-docto
        &campozoom=serie
        &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-ser-docto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes-parc.cod-ser-docto IN FRAME fpage0 /* S‚rie */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-parc.cod-tit-ap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-parc.cod-tit-ap wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes-parc.cod-tit-ap IN FRAME fpage0 /* T¡tulo */
DO:
  RUN piSugereParcela IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-adiant-despes-parc.cod-espec-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-adiant-despes-parc.cod-ser-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-adiant-despes-parc.cdn-moeda:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os handles instanciados na abertura do programa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-boad104) THEN DO:
        DELETE PROCEDURE h-boad104.
        ASSIGN h-boad104 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     Mostrar informa‡äes dos campos em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "leave":U TO tt-adiant-despes.cod-estabel          IN FRAME {&FRAME-NAME}.
    APPLY "leave":U TO tt-adiant-despes-parc.cod-espec-docto IN FRAME {&FRAME-NAME}.
    APPLY "leave":U TO tt-adiant-despes-parc.cdn-moeda       IN FRAME {&FRAME-NAME}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     Realizar o controle dos campos que deverÆo ficar habilitados em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-adiant-despes.cod-estabel:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
           tt-adiant-despes.cdd-adiant:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
           tt-adiant-despes-parc.cod-refer:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           l-gerou-apb:SENSITIVE                     IN FRAME {&FRAME-NAME} = NO
           c-situacao:SENSITIVE                      IN FRAME {&FRAME-NAME} = NO.
        
    ENABLE c-observacao WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa‡Æo da interface: Handles instanciados e inicializa‡Æo de campos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx00443) OR
       h-bocx00443:TYPE <> "PROCEDURE":U OR
       h-bocx00443:FILE-NAME <> "cxbo/bocx00443.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00443.p NO}
        {btb/btb008za.i2 cxbo/bocx00443.p '' h-bocx00443} 
    END.

    IF NOT VALID-HANDLE({&DBOParentTable}) THEN DO:
       RUN cxbo/bocx00442.p PERSISTENT SET h-bocx00442.
    END.
    RUN openQueryStatic IN h-bocx00442 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boad107) THEN DO:
        RUN adbo/boad107.p PERSISTENT SET h-boad107.
    END.

    IF NOT VALID-HANDLE(h-bocx250) THEN DO:
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
    END.

    IF NOT VALID-HANDLE(h-boad104) THEN DO:
        RUN adbo/boad104.p PERSISTENT SET h-boad104.
    END.

    IF NOT VALID-HANDLE(h-boun005) THEN DO:
        RUN unbo/boun005.p PERSISTENT SET h-boun005.
    END.


    IF pcAction = "ADD":U THEN DO:
        RUN findCodigo IN h-bocx250 (INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes.cod-estabel,
                                     OUTPUT c-return).
        IF c-return = "" THEN DO:
            RUN getCharField IN h-bocx250 (INPUT "cod-espec-antecip", OUTPUT tt-adiant-despes-parc.cod-espec-docto).
            RUN getCharField IN h-bocx250 (INPUT "cod-ser-antecip",   OUTPUT tt-adiant-despes-parc.cod-ser-docto).
        END.

        RUN picriaReferencia    IN h-bocx00443 (INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes.cod-estabel, 
                                                OUTPUT tt-adiant-despes-parc.cod-refer).

        RUN goTokey IN h-bocx00442 (INPUT INPUT FRAME {&FRAME-NAME} tt-adiant-despes.cod-estabel,
                                    INPUT INPUT FRAME {&FRAME-NAME} tt-adiant-despes.cdd-adiant).
        IF RETURN-VALUE = "OK":U THEN
            RUN getIntField IN h-bocx00442 (INPUT "cdn-moeda":U, OUTPUT tt-adiant-despes-parc.cdn-moeda).

        {utp/ut-liter.i NÆo_Gerado * R}
        ASSIGN l-gerou-apb = NO
               c-situacao  = TRIM(RETURN-VALUE)
               tt-adiant-despes-parc.dat-emissao = TODAY.

    END.
    ELSE DO:
        RUN piRetornaSituacaoAPB IN h-bocx00443 (INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes.cod-estabel,
                                                 INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.cod-refer,
                                                 INPUT  tt-adiant-despes.cdn-emitente,
                                                 OUTPUT c-situacao,
                                                 OUTPUT l-gerou-apb,
                                                 OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                                 OUTPUT TABLE tt_log_erro).
    END.
    IF AVAIL tt-adiant-despes-parc THEN
        ASSIGN c-observacao = tt-adiant-despes-parc.observacao.

    IF l-gerou-apb THEN DO:
        ASSIGN tt-adiant-despes-parc.cod-espec-docto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.cod-ser-docto:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.cod-tit-ap:SENSITIVE      IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.cod-parcela:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.cdn-moeda:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.dat-emissao:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.dat-prev-pagto:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.dat-vencto:SENSITIVE      IN FRAME {&FRAME-NAME} = NO
               tt-adiant-despes-parc.val-adiant-moed:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.

    DISP tt-adiant-despes-parc.cod-refer
         tt-adiant-despes-parc.cod-espec-docto
         tt-adiant-despes-parc.cod-ser-docto
         tt-adiant-despes-parc.cod-parcela
         tt-adiant-despes-parc.dat-emissao
         tt-adiant-despes-parc.cdn-moeda
         c-observacao
         c-situacao 
         l-gerou-apb 
        WITH FRAME {&FRAME-NAME}.

    APPLY "leave":U TO tt-adiant-despes.cod-estabel          IN FRAME {&FRAME-NAME}.
    APPLY "leave":U TO tt-adiant-despes-parc.cod-espec-docto IN FRAME {&FRAME-NAME}.
    APPLY "leave":U TO tt-adiant-despes-parc.cdn-moeda       IN FRAME {&FRAME-NAME}.

    RETURN "OK":U.              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores padroes de usu rio e hor rio da cria‡Æo do registro
               bem como realizar atualiza‡Æo do valor original desta parcela de 
               adiantamento.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-adiant-despes-parc.val-adiant = INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.val-adiant-moed
           tt-adiant-despes-parc.observacao = INPUT FRAME {&FRAME-NAME} c-observacao.

    IF tt-adiant-despes.cdn-moeda <> 0 THEN DO:
        RUN cdp/cd0812.p (INPUT tt-adiant-despes.cdn-moeda,
                          INPUT 0,
                          INPUT INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.val-adiant-moed,
                          INPUT tt-adiant-despes.dat-implant,
                          OUTPUT tt-adiant-despes-parc.val-adiant).

    END.

    IF pcAction = "ADD":U THEN DO:
        ASSIGN tt-adiant-despes-parc.idi-valor        = 1
               tt-adiant-despes-parc.val-adiant-orig  = INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.val-adiant-moed
               tt-adiant-despes-parc.cod-usuar        = c-seg-usuario
               tt-adiant-despes-parc.dtm-criac        = DATETIME(TODAY,MTIME).
    END.

    RETURN "OK":U.              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSugereParcela wMaintenanceNoNavigation 
PROCEDURE piSugereParcela :
/*------------------------------------------------------------------------------
  Purpose:     Sugere a pr¢xima parcela de acordo com a chave do t¡tulo (independente 
               do adiantamento): Esp‚cie, S‚rie, T¡tulo, Emitente.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.cod-parcela = "" THEN
        RUN buscaProximaParcela IN h-bocx00443 (INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.cod-espec-docto,
                                                INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.cod-ser-docto,
                                                INPUT  INPUT FRAME {&FRAME-NAME} tt-adiant-despes-parc.cod-tit-ap,
                                                INPUT  tt-adiant-despes.cdn-emitente,
                                                OUTPUT tt-adiant-despes-parc.cod-parcela).
                                                
    DISP tt-adiant-despes-parc.cod-parcela
         WITH FRAME {&FRAME-NAME}.
                                                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN {&ttTable}.cod-estabel  = {&ttParent}.cod-estabel
           {&ttTable}.cdd-adiant   = {&ttParent}.cdd-adiant
           {&ttTable}.cdn-emitente = {&ttParent}.cdn-emitente.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

