&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-dupli-apagar-cex NO-UNDO LIKE dupli-apagar-cex
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM1001DM 2.00.00.004 } /*** 010004 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM1001DM
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1  

&GLOBAL-DEFINE FolderLabels      Dupl Desp,Observa‡Æo

&GLOBAL-DEFINE ttTable           tt-dupli-apagar-cex
&GLOBAL-DEFINE hDBOTable         h-bocx255
&GLOBAL-DEFINE DBOTable          dupli-apagar-cex

&GLOBAL-DEFINE ttParent          tt-docum-est
&GLOBAL-DEFINE DBOParentTable    docum-est

&GLOBAL-DEFINE page0KeyFields    tt-dupli-apagar-cex.cod-emitente-desp ~
                                 tt-dupli-apagar-cex.parcela~
 

&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page1Fields       tt-dupli-apagar-cex.cod-esp ~
                                 tt-dupli-apagar-cex.tp-despesa ~
                                 tt-dupli-apagar-cex.dt-emissao ~
                                 tt-dupli-apagar-cex.desconto ~
                                 tt-dupli-apagar-cex.dt-venc-desc ~
                                 tt-dupli-apagar-cex.dt-vencim ~
                                 tt-dupli-apagar-cex.vl-a-pagar ~
                                 tt-dupli-apagar-cex.mo-codigo ~
                                 tt-dupli-apagar-cex.vl-a-pagar-mo ~
                                 tt-dupli-apagar-cex.dt-trans

&GLOBAL-DEFINE page2Fields       tt-dupli-apagar-cex.observacao

{inbo/boin092.i tt-dupli-apagar}
{cdp/cd4300.i3}      /* Include tratamento atributo livre */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
def var c-retencao as character no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/*--- Vari veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin092                        AS HANDLE NO-UNDO.
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
&Scoped-Define ENABLED-FIELDS tt-dupli-apagar-cex.cod-emitente-desp ~
tt-dupli-apagar-cex.parcela 
&Scoped-define ENABLED-TABLES tt-dupli-apagar-cex
&Scoped-define FIRST-ENABLED-TABLE tt-dupli-apagar-cex
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp RECT-23 ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-dupli-apagar-cex.cod-emitente-desp ~
tt-dupli-apagar-cex.parcela 
&Scoped-define DISPLAYED-TABLES tt-dupli-apagar-cex
&Scoped-define FIRST-DISPLAYED-TABLE tt-dupli-apagar-cex
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev 

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

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.72 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-dupli-apagar-cex.cod-emitente-desp AT ROW 1.46 COL 25.29 COLON-ALIGNED
          LABEL "Fornecedor":R17
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     c-nome-abrev AT ROW 1.46 COL 33.29 COLON-ALIGNED NO-LABEL
     tt-dupli-apagar-cex.parcela AT ROW 2.46 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     btOK AT ROW 16.96 COL 2
     btSave AT ROW 16.96 COL 13
     btCancel AT ROW 16.96 COL 24
     btHelp AT ROW 16.96 COL 80
     RECT-23 AT ROW 1.17 COL 1.29
     rtToolBar AT ROW 16.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.5
         FONT 1.

DEFINE FRAME fPage2
     tt-dupli-apagar-cex.observacao AT ROW 4 COL 7.14 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 71 BY 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 5.04
         SIZE 84 BY 11.29
         FONT 1.

DEFINE FRAME fPage1
     tt-dupli-apagar-cex.cod-esp AT ROW 1.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     tt-dupli-apagar-cex.tp-despesa AT ROW 2.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     c-tp-despesa AT ROW 2.63 COL 32.29 COLON-ALIGNED NO-LABEL
     tt-dupli-apagar-cex.dt-emissao AT ROW 3.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tt-dupli-apagar-cex.desconto AT ROW 4.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .88
     tt-dupli-apagar-cex.dt-venc-desc AT ROW 5.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tt-dupli-apagar-cex.dt-vencim AT ROW 6.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tt-dupli-apagar-cex.vl-a-pagar AT ROW 7.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     tt-dupli-apagar-cex.mo-codigo AT ROW 8.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     c-desc-moeda AT ROW 8.63 COL 28.14 COLON-ALIGNED NO-LABEL
     tt-dupli-apagar-cex.vl-a-pagar-mo AT ROW 9.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     tt-dupli-apagar-cex.dt-trans AT ROW 10.63 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 5.04
         SIZE 84 BY 11.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-docum-est T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-dupli-apagar-cex T "?" NO-UNDO mgcex dupli-apagar-cex
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
         HEIGHT             = 17.42
         WIDTH              = 90
         MAX-HEIGHT         = 23.42
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 23.42
         VIRTUAL-WIDTH      = 114.29
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-dupli-apagar-cex.cod-emitente-desp IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-despesa IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
    
    IF pcAction = "update-Dupli-apagar" THEN
        RUN saveRecordDupliApagar IN THIS-PROCEDURE.    
    ELSE 
        RUN saveRecord IN THIS-PROCEDURE.    

    IF RETURN-VALUE = "OK":U THEN DO:    
        RUN habilitaBotoesDespesas IN phCaller.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        RUN habilitaBotoesDespesas IN phCaller.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dupli-apagar-cex.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.cod-emitente-desp wMaintenanceNoNavigation
ON F5 OF tt-dupli-apagar-cex.cod-emitente-desp IN FRAME fpage0 /* Fornecedor */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                       &campo=tt-dupli-apagar-cex.cod-emitente-desp
                       &campozoom=cod-emitente
                       &campo2=c-nome-abrev
                       &campozoom2=nome-abrev
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.cod-emitente-desp wMaintenanceNoNavigation
ON LEAVE OF tt-dupli-apagar-cex.cod-emitente-desp IN FRAME fpage0 /* Fornecedor */
DO:
    RUN displayEmitente(INPUT FRAME fpage0 tt-dupli-apagar-cex.cod-emitente-desp).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.cod-emitente-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-dupli-apagar-cex.cod-emitente-desp IN FRAME fpage0 /* Fornecedor */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-dupli-apagar-cex.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.cod-esp wMaintenanceNoNavigation
ON F5 OF tt-dupli-apagar-cex.cod-esp IN FRAME fPage1 /* Esp‚cie */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=tt-dupli-apagar-cex.cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.cod-esp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-dupli-apagar-cex.cod-esp IN FRAME fPage1 /* Esp‚cie */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dupli-apagar-cex.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.mo-codigo wMaintenanceNoNavigation
ON F5 OF tt-dupli-apagar-cex.mo-codigo IN FRAME fPage1 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                       &campo=tt-dupli-apagar-cex.mo-codigo
                       &campozoom=mo-codigo
                       &campo2=c-desc-moeda
                       &campozoom2=descricao
                       &frame="fPage1"}                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.mo-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-dupli-apagar-cex.mo-codigo IN FRAME fPage1 /* Moeda */
DO:
    RUN displaymoeda(INPUT FRAME fpage1 tt-dupli-apagar-cex.mo-codigo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-dupli-apagar-cex.mo-codigo IN FRAME fPage1 /* Moeda */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dupli-apagar-cex.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.tp-despesa wMaintenanceNoNavigation
ON F5 OF tt-dupli-apagar-cex.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=tt-dupli-apagar-cex.tp-despesa
                       &campozoom=tp-codigo
                       &campo2=c-tp-despesa
                       &campozoom2=descricao
                       &frame="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.tp-despesa wMaintenanceNoNavigation
ON LEAVE OF tt-dupli-apagar-cex.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    RUN displaytpdespesa(INPUT FRAME fpage1 tt-dupli-apagar-cex.tp-despesa).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dupli-apagar-cex.tp-despesa wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-dupli-apagar-cex.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

tt-dupli-apagar-cex.cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-dupli-apagar-cex.cod-esp          :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-dupli-apagar-cex.tp-despesa       :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-dupli-apagar-cex.mo-codigo        :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage0 = ""
           c-desc-moeda:SCREEN-VALUE IN FRAME fPage1 = ""
           c-tp-despesa:SCREEN-VALUE IN FRAME fPage1 = "".    

    IF pcAction = "UPDATE":U THEN DO:

        /* Mostra Informa‡äes do Emitente */
        RUN displayEmitente  ( tt-dupli-apagar-cex.cod-emitente-desp).
                
        /* Mostra Descri‡Æo da Natureza */
        RUN displaymoeda ( tt-dupli-apagar-cex.mo-codigo).
        
        /*Mostra Descri‡Æo do Tipo de Despesa*/
        RUN displaytpdespesa ( tt-dupli-apagar-cex.tp-despesa).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if pcAction = "update-Dupli-apagar" then do:
        find first tt-dupli-apagar-cex no-error.
        if avail tt-dupli-apagar-cex then do:

            disp tt-dupli-apagar-cex.cod-emitente-desp
                 tt-dupli-apagar-cex.parcela with frame fPage0.

            disp tt-dupli-apagar-cex.cod-esp          
                 tt-dupli-apagar-cex.tp-despesa 
                 tt-dupli-apagar-cex.dt-emissao 
                 tt-dupli-apagar-cex.desconto 
                 tt-dupli-apagar-cex.dt-venc-desc
                 tt-dupli-apagar-cex.dt-vencim 
                 tt-dupli-apagar-cex.vl-a-pagar
                 tt-dupli-apagar-cex.mo-codigo 
                 tt-dupli-apagar-cex.vl-a-pagar-mo 
                 tt-dupli-apagar-cex.dt-trans 
                 with frame fPage1.     

            disp tt-dupli-apagar-cex.observacao with frame fPage2.

            apply "leave":U to tt-dupli-apagar-cex.cod-emitente-desp in frame fPage0.
            apply "leave":U to tt-dupli-apagar-cex.tp-despesa        in frame fPage1.
            apply "leave":U to tt-dupli-apagar-cex.mo-codigo         in frame fPage1.

            enable tt-dupli-apagar-cex.cod-esp        
                   tt-dupli-apagar-cex.tp-despesa     
                   tt-dupli-apagar-cex.dt-emissao     
                   tt-dupli-apagar-cex.desconto       
                   tt-dupli-apagar-cex.dt-venc-desc   
                   tt-dupli-apagar-cex.dt-vencim      
                   tt-dupli-apagar-cex.vl-a-pagar     
                   tt-dupli-apagar-cex.mo-codigo      
                   tt-dupli-apagar-cex.vl-a-pagar-mo  
                   tt-dupli-apagar-cex.dt-trans       
                   with frame fPage1.                 

            enable tt-dupli-apagar-cex.observacao with frame fPage2.

        end.
    end.

    APPLY "ENTRY":U TO tt-dupli-apagar-cex.cod-emitente-desp IN FRAME fPage0.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if pcAction = "update-Dupli-apagar" then do:

        find first dupli-apagar exclusive-lock 
             where rowid(dupli-apagar) = prTable NO-ERROR.
        if avail dupli-apagar then do:

            create tt-dupli-apagar-cex.
            assign tt-dupli-apagar-cex.serie-docto       = dupli-apagar.serie-docto  
                   tt-dupli-apagar-cex.nro-docto         = dupli-apagar.nro-docto    
                   tt-dupli-apagar-cex.cod-emitente      = dupli-apagar.cod-emitente 
                   tt-dupli-apagar-cex.nat-operacao      = dupli-apagar.nat-operacao 
                   tt-dupli-apagar-cex.cod-emitente-desp = dupli-apagar.cod-emitente
                   tt-dupli-apagar-cex.parcela           = dupli-apagar.parcela
                   tt-dupli-apagar-cex.cod-esp           = dupli-apagar.cod-esp
                   tt-dupli-apagar-cex.vl-a-pagar        = dupli-apagar.vl-a-pagar
                   tt-dupli-apagar-cex.dt-emissao        = dupli-apagar.dt-emissao
                   tt-dupli-apagar-cex.vl-desconto       = dupli-apagar.vl-desconto
                   tt-dupli-apagar-cex.dt-venc-desc      = dupli-apagar.dt-venc-desc
                   tt-dupli-apagar-cex.tp-despesa        = dupli-apagar.tp-despesa
                   tt-dupli-apagar-cex.desconto          = dupli-apagar.desconto
                   tt-dupli-apagar-cex.dt-vencim         = dupli-apagar.dt-vencim
                   tt-dupli-apagar-cex.mo-codigo         = dupli-apagar.mo-codigo
                   tt-dupli-apagar-cex.vl-a-pagar-mo     = dupli-apagar.vl-a-pagar-mo
                   tt-dupli-apagar-cex.dt-trans          = dupli-apagar.dt-trans
                   tt-dupli-apagar-cex.observacao        = dupli-apagar.observacao.  

        end.
    end.                  
                  
    RETURN "OK":U.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayEmitente wMaintenanceNoNavigation 
PROCEDURE displayEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM piCodEmitente LIKE item-doc-est-cex.cod-emitente-desp NO-UNDO.

    DEF VAR c-return              AS CHAR   NO-UNDO.
    DEF VAR h-boad098             AS HANDLE NO-UNDO.
    DEF VAR c-desc-aux            AS CHAR   NO-UNDO.

    RUN adbo/boad098.p PERSISTENT SET h-boad098.

    RUN findCodigo IN h-boad098(INPUT picodemitente,
                                OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharfield IN h-boad098(INPUT "nome-abrev",
                                      OUTPUT c-desc-aux).  
        
    ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage0 = c-desc-aux.

    DELETE PROCEDURE h-boad098.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displaymoeda wMaintenanceNoNavigation 
PROCEDURE displaymoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEF INPUT PARAM piMoCodigo LIKE moeda.mo-codigo NO-UNDO.

    DEF VAR h-boin092          AS HANDLE NO-UNDO.
    DEF VAR c-desc-aux         AS char   NO-UNDO.
        
    RUN inbo/boin092.p PERSISTENT SET h-boin092.
        
    /* Acessa Moeda */
    RUN findMoeda IN h-boin092 (INPUT piMoCodigo). 

    IF RETURN-VALUE = "OK":U THEN DO:
        
        /* Mostra Descri‡Æo da Moeda*/
        RUN getDescriptionFields in h-boin092 (INPUT "desc-moeda":U,
                                               OUTPUT c-desc-aux ).
        ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fPage1 = c-desc-aux.

    END.
    ELSE 
        ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fPage1 = "":U.

    DELETE PROCEDURE h-boin092.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displaytpdespesa wMaintenanceNoNavigation 
PROCEDURE displaytpdespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pitpdespesa LIKE dupli-apagar-cex.tp-despesa NO-UNDO.

    DEF VAR c-return            AS CHAR   NO-UNDO.
    DEF VAR h-boad259           AS HANDLE NO-UNDO.
    DEF VAR c-desc-aux          AS CHAR   NO-UNDO.
    
    RUN adbo/boad259.p PERSISTENT SET h-boad259.

    RUN findCodigo IN h-boad259(INPUT pitpdespesa,
                                OUTPUT c-return).
    
    IF c-return = "" THEN
        RUN getCharfield IN h-boad259(INPUT "descricao",
                                      OUTPUT c-desc-aux).  

    ASSIGN c-tp-despesa:SCREEN-VALUE IN FRAME fPage1 = c-desc-aux.

    DELETE PROCEDURE h-boad259.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 inbo/bocx255.p}
        {btb/btb008za.i2 inbo/bocx255.p '' {&hDBOTable}}            
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN tt-dupli-apagar-cex.cod-emitente = tt-docum-est.cod-emitente
           tt-dupli-apagar-cex.serie-docto  = tt-docum-est.serie-docto
           tt-dupli-apagar-cex.nro-docto    = tt-docum-est.nro-docto
           tt-dupli-apagar-cex.nat-operacao = tt-docum-est.nat-operacao.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordDupliApagar wMaintenanceNoNavigation 
PROCEDURE saveRecordDupliApagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    empty temp-table tt-dupli-apagar.                                    
                                    
    if not valid-handle (h-boin092) then do:    
        run inbo/boin092.p persistent set h-boin092.
        run openQueryStatic in h-boin092 (input "Main":U).
    end.

    find first dupli-apagar no-lock
         where rowid(dupli-apagar) = prTable no-error.
    if avail dupli-apagar then do:
        create tt-dupli-apagar.
        buffer-copy dupli-apagar to tt-dupli-apagar.
        assign tt-dupli-apagar.r-rowid       = rowid(dupli-apagar)
               tt-dupli-apagar.cod-esp       = input frame fPage1 tt-dupli-apagar-cex.cod-esp      
               tt-dupli-apagar.tp-despesa    = input frame fPage1 tt-dupli-apagar-cex.tp-despesa   
               tt-dupli-apagar.dt-emissao    = input frame fPage1 tt-dupli-apagar-cex.dt-emissao   
               tt-dupli-apagar.desconto      = input frame fPage1 tt-dupli-apagar-cex.desconto     
               tt-dupli-apagar.dt-venc-desc  = input frame fPage1 tt-dupli-apagar-cex.dt-venc-desc 
               tt-dupli-apagar.dt-vencim     = input frame fPage1 tt-dupli-apagar-cex.dt-vencim    
               tt-dupli-apagar.vl-a-pagar    = input frame fPage1 tt-dupli-apagar-cex.vl-a-pagar   
               tt-dupli-apagar.mo-codigo     = input frame fPage1 tt-dupli-apagar-cex.mo-codigo    
               tt-dupli-apagar.vl-a-pagar-mo = input frame fPage1 tt-dupli-apagar-cex.vl-a-pagar-mo
               tt-dupli-apagar.dt-trans      = input frame fPage1 tt-dupli-apagar-cex.dt-trans
               tt-dupli-apagar.observacao    = input frame fPage2 tt-dupli-apagar-cex.observacao.
        
        {rep/re1001c.i50} /* vari veis e informa‡äes utilizadas pelo re1001c.i51 */
        assign de-vl-a-pagar-mo = INPUT FRAME fPage1 tt-dupli-apagar-cex.vl-a-pagar-mo.
        {rep/re1001c.i51 "no"}
        {cdp/cd4300.i4 "no" tt-dupli-apagar.char-1}

        find first docum-est no-lock
             where rowid(docum-est) = prParent no-error.
        if avail docum-est then do:
            if tt-dupli-apagar.mo-codigo <> docum-est.mo-codigo then do:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-moeda-da-duplicata-do-forneced AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Moeda_da_duplicata_do_fornecedor_principal_nÆo_pode_ser" *}
                ASSIGN c-lbl-liter-moeda-da-duplicata-do-forneced = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-da-moeda-do-documento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "da_moeda_do_documento" *}
                ASSIGN c-lbl-liter-da-moeda-do-documento = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg":U, input 33090, input c-lbl-liter-moeda-da-duplicata-do-forneced + "~~" + c-lbl-liter-da-moeda-do-documento).

                create RowErrors.
                assign RowErrors.ErrorNumber      = 33090
                       RowErrors.ErrorSubType     = "Error":U                       
                       RowErrors.ErrorHelp        = return-value
                       RowErrors.ErrorDescription = return-value.

            end.
            else do:
                run emptyRowErrors in h-boin092.
                run gotokey        in h-boin092 (input tt-dupli-apagar.serie-docto, 
                                                 input tt-dupli-apagar.nro-docto, 
                                                 input tt-dupli-apagar.cod-emitente,
                                                 input tt-dupli-apagar.nat-operacao, 
                                                 input tt-dupli-apagar.parcela).
                run setRecord      in h-boin092 (input table tt-dupli-apagar).
                run updateRecord   in h-boin092.
                run getRowErrors   in h-boin092 (output table RowErrors).            
            end.
        end.

        for each RowErrors where RowErrors.ErrorSubType <> "Error":U:
            delete RowErrors.
        end.

        if can-find (first RowErrors) then do:
            {method/showmessage.i1}
            {method/showmessage.i2}            
            RETURN "NOK".
        end.
    end.

    if valid-handle (h-boin092) then 
        run destroy in h-boin092.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

