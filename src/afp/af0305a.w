&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-excecao NO-UNDO LIKE af-excecao
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0305A 2.00.00.004 } /*** 010004 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AF0305A
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-af-excecao
&GLOBAL-DEFINE hDBOTable         h-boaf014
&GLOBAL-DEFINE DBOTable          af-excecao

&GLOBAL-DEFINE ttParent          tt-emitente
&GLOBAL-DEFINE DBOParentTable    h-boad098-af

&GLOBAL-DEFINE page0KeyFields   
&GLOBAL-DEFINE page0Fields       tt-af-excecao.dt-implantacao ~
                                 tt-af-excecao.numero-ordem ~
                                 tt-af-excecao.num-pedido ~
                                 tt-af-excecao.parcela ~
                                 tt-af-excecao.nro-docto ~
                                 tt-af-excecao.serie-docto ~
                                 tt-af-excecao.nat-operacao ~
                                 tt-af-excecao.sequencia ~
                                 tt-af-excecao.nr-seq-fat ~
                                 tt-af-excecao.motivo ~
                                 tt-af-excecao.nr-ficha ~
                                 tt-af-excecao.cod-estabel ~
                                 tt-af-excecao.usuar-alter ~
                                 tt-af-excecao.dt-alter ~
                                 tt-af-excecao.hora-alter tt-af-excecao.ind-tipo-doc 

&GLOBAL-DEFINE page0ParentFields tt-emitente.cod-emitente tt-emitente.nome-emit tt-emitente.nome-abrev tt-emitente.cgc
   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

define new shared variable i-IntNac as integer no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

{utp/ut-glob.i}

/*--- Vari veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.nome-abrev tt-emitente.cgc ~
tt-af-excecao.ind-tipo-doc tt-af-excecao.dt-implantacao ~
tt-af-excecao.num-pedido tt-af-excecao.numero-ordem tt-af-excecao.parcela ~
tt-af-excecao.nro-docto tt-af-excecao.serie-docto ~
tt-af-excecao.nat-operacao tt-af-excecao.sequencia ~
tt-af-excecao.cod-estabel tt-af-excecao.nr-seq-fat tt-af-excecao.nr-ficha ~
tt-af-excecao.motivo tt-af-excecao.usuar-alter tt-af-excecao.dt-alter ~
tt-af-excecao.hora-alter 
&Scoped-define ENABLED-TABLES tt-emitente tt-af-excecao
&Scoped-define FIRST-ENABLED-TABLE tt-emitente
&Scoped-define SECOND-ENABLED-TABLE tt-af-excecao
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp RECT-17 RECT-19 ~
RECT-20 RECT-21 RECT-22 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.nome-abrev tt-emitente.cgc ~
tt-af-excecao.ind-tipo-doc tt-af-excecao.dt-implantacao ~
tt-af-excecao.num-pedido tt-af-excecao.numero-ordem tt-af-excecao.parcela ~
tt-af-excecao.nro-docto tt-af-excecao.serie-docto ~
tt-af-excecao.nat-operacao tt-af-excecao.sequencia ~
tt-af-excecao.cod-estabel tt-af-excecao.nr-seq-fat tt-af-excecao.nr-ficha ~
tt-af-excecao.motivo tt-af-excecao.usuar-alter tt-af-excecao.dt-alter ~
tt-af-excecao.hora-alter 
&Scoped-define DISPLAYED-TABLES tt-emitente tt-af-excecao
&Scoped-define FIRST-DISPLAYED-TABLE tt-emitente
&Scoped-define SECOND-DISPLAYED-TABLE tt-af-excecao


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

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 4.25.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.5.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 4.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 16.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-emitente.cod-emitente AT ROW 1.75 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-emitente.nome-emit AT ROW 1.75 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 61 BY .88
     tt-emitente.nome-abrev AT ROW 2.75 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-emitente.cgc AT ROW 2.75 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-af-excecao.ind-tipo-doc AT ROW 4.58 COL 3 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pedido Compra", 1,
"Nota Fiscal Entrada", 2,
"Ficha Inspe‡Æo", 3,
"Nota Fiscal Devolu‡Æo", 4
          SIZE 86 BY .88
     tt-af-excecao.dt-implantacao AT ROW 6.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-af-excecao.num-pedido AT ROW 7.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-excecao.numero-ordem AT ROW 7.25 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-af-excecao.parcela AT ROW 7.25 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-af-excecao.nro-docto AT ROW 8.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-excecao.serie-docto AT ROW 8.25 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-af-excecao.nat-operacao AT ROW 8.25 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-af-excecao.sequencia AT ROW 8.25 COL 76 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-af-excecao.cod-estabel AT ROW 9.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-af-excecao.nr-seq-fat AT ROW 9.25 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-af-excecao.nr-ficha AT ROW 9.25 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-af-excecao.motivo AT ROW 11 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 86 BY 3.75
     tt-af-excecao.usuar-alter AT ROW 15.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-af-excecao.dt-alter AT ROW 15.5 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-excecao.hora-alter AT ROW 15.5 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     btOK AT ROW 17.5 COL 2
     btSave AT ROW 17.5 COL 13
     btCancel AT ROW 17.5 COL 24
     btHelp AT ROW 17.5 COL 80
     RECT-17 AT ROW 1.25 COL 2
     RECT-19 AT ROW 4.25 COL 2
     RECT-20 AT ROW 10.75 COL 2
     RECT-21 AT ROW 15.25 COL 2
     RECT-22 AT ROW 6 COL 2
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-excecao T "?" NO-UNDO emscda af-excecao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-emitente T "?" NO-UNDO mgadm emitente
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
         HEIGHT             = 17.92
         WIDTH              = 90
         MAX-HEIGHT         = 17.92
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 17.92
         VIRTUAL-WIDTH      = 90.43
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
   FRAME-NAME                                                           */
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
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    run afterSaveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  RUN pi-zoom-nf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
   apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.ind-tipo-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.ind-tipo-doc wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-af-excecao.ind-tipo-doc IN FRAME fpage0
DO:
  RUN pi-habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nat-operacao wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.nat-operacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
   RUN pi-zoom-nf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nat-operacao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.nat-operacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.nr-ficha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nr-ficha wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.nr-ficha IN FRAME fpage0 /* Roteiro Inspe‡Æo */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z80in124.w
                       &campo=tt-af-excecao.nr-ficha
                       &campozoom=nr-ficha}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nr-ficha wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.nr-ficha IN FRAME fpage0 /* Roteiro Inspe‡Æo */
DO:
     apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nro-docto wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.nro-docto IN FRAME fpage0 /* Documento */
DO:
   RUN pi-zoom-nf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.nro-docto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.nro-docto IN FRAME fpage0 /* Documento */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.num-pedido wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.num-pedido IN FRAME fpage0 /* Pedido */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z80in274.w
                       &campo=tt-af-excecao.numero-ordem
                       &campo2=tt-af-excecao.num-pedido   
                       &campo3=tt-af-excecao.parcela
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &campozoom3=parcela
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input tt-emitente.cod-emitente, 
                                         input 2,
                                         input '')."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.num-pedido wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.num-pedido IN FRAME fpage0 /* Pedido */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.numero-ordem wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.numero-ordem IN FRAME fpage0 /* Ordem */
DO:
        {include/zoomvar.i &prog-zoom=inzoom/z80in274.w
                       &campo=tt-af-excecao.numero-ordem
                       &campo2=tt-af-excecao.num-pedido   
                       &campo3=tt-af-excecao.parcela
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &campozoom3=parcela
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input tt-emitente.cod-emitente, 
                                         input 2,
                                         input '')."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.numero-ordem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.numero-ordem IN FRAME fpage0 /* Ordem */
DO:
      apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.parcela wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.parcela IN FRAME fpage0 /* Parcela */
DO:
        {include/zoomvar.i &prog-zoom=inzoom/z80in274.w
                       &campo=tt-af-excecao.numero-ordem
                       &campo2=tt-af-excecao.num-pedido   
                       &campo3=tt-af-excecao.parcela
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &campozoom3=parcela
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input tt-emitente.cod-emitente, 
                                         input 2,
                                         input '')."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.parcela wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.parcela IN FRAME fpage0 /* Parcela */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-excecao.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.serie-docto wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.serie-docto IN FRAME fpage0 /* S‚rie */
DO:
   RUN pi-zoom-nf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-excecao.serie-docto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-af-excecao.serie-docto IN FRAME fpage0 /* S‚rie */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&scoped-define SELF-NAME tt-af-excecao.sequencia
&analyze-suspend UIB_CODE_BLOCK _CONTROL tt-af-excecao.sequencia wMaintenanceNoNavigation
ON F5 OF tt-af-excecao.sequencia in frame fPage0 /*SEQ*/
DO:
     {method/zoomFields.i &programZoom="inzoom/z15in176.w"
                          &FieldZoom1="nro-docto"
                          &FieldScreen1="tt-af-excecao.nro-docto"
                          &frame1="fPage0"
                          &FieldZoom2="serie-docto"
                          &FieldScreen2="tt-af-excecao.serie-docto"
                          &frame2="fPage0"
                          &FieldZoom3="nat-operacao"
                          &FieldScreen3="tt-af-excecao.nat-operacao"
                          &frame3="fPage0"
                          &FieldZoom4="sequencia"
                          &FieldScreen4="tt-af-excecao.sequencia"
                          &frame4="fpage0"}
END.

/* _UIB-CODE-BLOCK-END*/
&analyze-resume


&analyze-suspend _UIB-CODE-BLOCK _CONTROL tt-af-excecao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK of tt-af-excecao.sequencia in frame fPage0 /*SEQ*/ 
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END*/
&analyze-resume

&scoped-define SELF-NAME tt-af-excecao.sr-seq-fat
&analyze-suspend UIB_CODE-BLOCK _CONTROL tt-af-excecao.nr-seq-fat wMaintenanceNoNavigation
ON F5 of tt-af-excecao.nr-seq-fat in frame fPage0 /*SEQUENCIA*/ 
DO:
    {include/zoomvar.i &prog-zoom=dizoom/z04di088.w
                       &campo=tt-af-excecao.nro-docto
                       &campozoom=nr-nota-fis
                       &campo2=tt-af-excecao.serie-docto
                       &campozoom2=serie
                       &campo3=tt-af-excecao.cod-estabel
                       &campozoom3=cod-estabel
                       &campo4=tt-af-excecao.nr-seq-fat
                       &campozoom4=nr-seq-fat
                       &frame="fpage0"}
END.

/* _UIB-CODE-BLOCK-END*/
&analyze-resume

&analyze-suspend _UIB-CODE-BLOCK _CONTROL tt-af-excecao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK of tt-af-excecao.nr-seq-fat in frame fPage0 /*SEQUENCIA*/ 
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END*/
&analyze-resume

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

 if tt-af-excecao.num-pedido:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.numero-ordem:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.parcela:load-mouse-pointer("image/lupa.cur") then .

 if tt-af-excecao.nro-docto:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.serie-docto:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.sequencia:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.nr-seq-fat:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.cod-estabel:load-mouse-pointer("image/lupa.cur") then .
 if tt-af-excecao.nat-operacao:load-mouse-pointer("image/lupa.cur") then .

 if tt-af-excecao.nr-ficha:load-mouse-pointer("image/lupa.cur") then .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-habilita.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveRecord wMaintenanceNoNavigation 
PROCEDURE afterSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-habilita.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Habilita wMaintenanceNoNavigation 
PROCEDURE pi-Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE {&page0Fields}
    WITH FRAME fpage0.

ENABLE tt-af-excecao.dt-implantacao
       tt-af-excecao.ind-tipo-doc
       tt-af-excecao.motivo 
    WITH FRAME fpage0.

CASE INPUT FRAME fpage0 tt-af-excecao.ind-tipo-doc:
    WHEN 1 THEN DO:
        ENABLE tt-af-excecao.numero-ordem
               tt-af-excecao.num-pedido
               tt-af-excecao.parcela
               WITH FRAME fpage0.
        ASSIGN tt-af-excecao.nro-docto:SCREEN-VALUE = ""
               tt-af-excecao.serie-docto:SCREEN-VALUE = ""
               tt-af-excecao.nat-operacao:SCREEN-VALUE = ""
               tt-af-excecao.sequencia:SCREEN-VALUE = "0"
               tt-af-excecao.nr-ficha:SCREEN-VALUE = "0"
               tt-af-excecao.cod-estabel:SCREEN-VALUE = ""
               tt-af-excecao.nr-seq-fat:SCREEN-VALUE = "0".
        
    END.
    WHEN 2 THEN DO:
        ENABLE tt-af-excecao.nro-docto
               tt-af-excecao.serie-docto
               tt-af-excecao.nat-operacao
               tt-af-excecao.sequencia
               WITH FRAME fpage0.

        ASSIGN tt-af-excecao.num-pedido:SCREEN-VALUE = "0"
               tt-af-excecao.numero-ordem:SCREEN-VALUE = "0"
               tt-af-excecao.parcela:SCREEN-VALUE = "0"
               tt-af-excecao.nr-ficha:SCREEN-VALUE = "0"
               tt-af-excecao.cod-estabel:SCREEN-VALUE = ""
               tt-af-excecao.nr-seq-fat:SCREEN-VALUE = "0".
    END.
    WHEN 3 THEN DO:
        ENABLE tt-af-excecao.nr-ficha
               WITH FRAME fpage0.
        ASSIGN tt-af-excecao.num-pedido:SCREEN-VALUE = "0"
               tt-af-excecao.numero-ordem:SCREEN-VALUE = "0"
               tt-af-excecao.parcela:SCREEN-VALUE = "0"
               tt-af-excecao.nro-docto:SCREEN-VALUE = ""
               tt-af-excecao.serie-docto:SCREEN-VALUE = ""
               tt-af-excecao.nat-operacao:SCREEN-VALUE = ""
               tt-af-excecao.sequencia:SCREEN-VALUE = "0"
               tt-af-excecao.cod-estabel:SCREEN-VALUE = ""
               tt-af-excecao.nr-seq-fat:SCREEN-VALUE = "0".
    END.
    WHEN 4 THEN DO:
        ENABLE tt-af-excecao.nro-docto
               tt-af-excecao.serie-docto
               tt-af-excecao.cod-estabel
               tt-af-excecao.nr-seq-fat
               WITH FRAME fpage0.
        ASSIGN tt-af-excecao.num-pedido:SCREEN-VALUE = "0"
               tt-af-excecao.numero-ordem:SCREEN-VALUE = "0"
               tt-af-excecao.parcela:SCREEN-VALUE = "0"
               tt-af-excecao.nat-operacao:SCREEN-VALUE = ""
               tt-af-excecao.sequencia:SCREEN-VALUE = "0"
               tt-af-excecao.nr-ficha:SCREEN-VALUE = "0".
    END.
END.

APPLY 'entry' TO tt-af-excecao.ind-tipo-doc IN FRAME fpage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-nf wMaintenanceNoNavigation 
PROCEDURE pi-zoom-nf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF INPUT FRAME {&FRAME-NAME} tt-af-excecao.ind-tipo-doc = 2 THEN
     RUN pi-zoom-nfe.
  ELSE
     RUN pi-zoom-nfd.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-nfd wMaintenanceNoNavigation 
PROCEDURE pi-zoom-nfd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {include/zoomvar.i &prog-zoom=dizoom/z03di135.w
                       &campo=tt-af-excecao.nro-docto
                       &campo2=tt-af-excecao.serie-docto  
                       &campo3=tt-af-excecao.cod-estabel
                       &campozoom=nr-nota-fis
                       &campozoom2=serie
                       &campozoom3=cod-estabel}
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-nfe wMaintenanceNoNavigation 
PROCEDURE pi-zoom-nfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {include/zoomvar.i &prog-zoom=inzoom/z01in090.w
                       &campo=tt-af-excecao.nro-docto
                       &campo2=tt-af-excecao.serie-docto 
                       &campo3=tt-af-excecao.nat-operacao
                       &campozoom=nro-docto
                       &campozoom2=serie-docto
                       &campozoom3=nat-operacao}

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
    
     assign tt-af-excecao.ep-codigo = i-ep-codigo-usuario
             tt-af-excecao.cod-emitente = tt-emitente.cod-emitente.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
