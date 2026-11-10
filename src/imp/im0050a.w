&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-proc-imp NO-UNDO LIKE historico-proc-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-proc-imp2 NO-UNDO LIKE historico-proc-imp
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
{include/i-prgvrs.i IM0050A 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0050a MIM}
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
&GLOBAL-DEFINE Program           IM0050A
&GLOBAL-DEFINE Version           2.00.00.011
&GLOBAL-DEFINE DBOVersion        1.1


&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           tt-historico-proc-imp2
&GLOBAL-DEFINE hDBOTable         h-bocx150a2
&GLOBAL-DEFINE DBOTable          historico-proc-imp

&GLOBAL-DEFINE ttParent          tt-historico-proc-imp
&GLOBAL-DEFINE hDBOParent        h-bocx150a
&GLOBAL-DEFINE DBOParentTable    historico-proc-imp

&GLOBAL-DEFINE page0KeyFields    tt-historico-proc-imp2.sequencia ~
                                 tt-historico-proc-imp2.cod-pto-contr ~
                                 tt-historico-proc-imp2.dt-previsao
&GLOBAL-DEFINE page0Fields       tt-historico-proc-imp2.dt-efetiva ~
                                 tt-historico-proc-imp2.id-meio-transp ~
                                 tt-historico-proc-imp2.observacao
&GLOBAL-DEFINE page0ParentFields tt-historico-proc-imp.cod-estabel ~
                                 tt-historico-proc-imp.nr-proc-imp ~
                                 tt-historico-proc-imp.cod-itiner
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/*                                  tt-historico-proc-imp2.dt-previsao ~ */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions --- */
def var c-meio-transp like tt-historico-proc-imp2.id-meio-transp.  

{cdp/cdcfgmat.i}

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then

{cxbo/bocx351.i tt-licenciam-import-oc}

define variable iNumPedido    like processo-imp.num-pedido no-undo.
define variable iPtoEmbarque  like itinerario.pto-embarque no-undo.
define variable cReturn       as character                 no-undo.
define variable h-bocx351     as handle                    no-undo.
define variable cOrdensSemLI  as character                 no-undo.

&endif

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
def var h-bocx110 as handle no-undo.
def var h-boad107 as handle no-undo.
def var h-bocx115 as handle no-undo.
def var h-bocx140 as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp tt-historico-proc-imp.cod-itiner ~
tt-historico-proc-imp2.sequencia tt-historico-proc-imp2.cod-pto-contr ~
tt-historico-proc-imp2.dt-previsao tt-historico-proc-imp2.dt-efetiva ~
tt-historico-proc-imp2.id-meio-transp tt-historico-proc-imp2.observacao 
&Scoped-define ENABLED-TABLES tt-historico-proc-imp tt-historico-proc-imp2
&Scoped-define FIRST-ENABLED-TABLE tt-historico-proc-imp
&Scoped-define SECOND-ENABLED-TABLE tt-historico-proc-imp2
&Scoped-Define ENABLED-OBJECTS desc-est desc-itiner desc-pto btOK btCancel ~
btHelp btDecl rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp tt-historico-proc-imp.cod-itiner ~
tt-historico-proc-imp2.sequencia tt-historico-proc-imp2.cod-pto-contr ~
tt-historico-proc-imp2.dt-previsao tt-historico-proc-imp2.dt-efetiva ~
tt-historico-proc-imp2.id-meio-transp tt-historico-proc-imp2.observacao 
&Scoped-define DISPLAYED-TABLES tt-historico-proc-imp ~
tt-historico-proc-imp2
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-proc-imp
&Scoped-define SECOND-DISPLAYED-TABLE tt-historico-proc-imp2
&Scoped-Define DISPLAYED-OBJECTS desc-est desc-itiner desc-pto 

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

DEFINE BUTTON btDecl 
     LABEL "Comunica‡äes" 
     SIZE 11.29 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE desc-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88 NO-UNDO.

DEFINE VARIABLE desc-itiner AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE desc-pto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 14.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-historico-proc-imp.cod-estabel AT ROW 2.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     desc-est AT ROW 2.25 COL 39.43 COLON-ALIGNED NO-LABEL
     tt-historico-proc-imp.nr-proc-imp AT ROW 3.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-historico-proc-imp.cod-itiner AT ROW 4.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     desc-itiner AT ROW 4.25 COL 39.43 COLON-ALIGNED NO-LABEL
     tt-historico-proc-imp2.sequencia AT ROW 5.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-historico-proc-imp2.cod-pto-contr AT ROW 6.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     desc-pto AT ROW 6.25 COL 41.14 COLON-ALIGNED NO-LABEL
     tt-historico-proc-imp2.dt-previsao AT ROW 7.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-historico-proc-imp2.dt-efetiva AT ROW 8.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-historico-proc-imp2.id-meio-transp AT ROW 9.25 COL 34.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-historico-proc-imp2.observacao AT ROW 10.25 COL 36.29 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     btOK AT ROW 16.21 COL 2
     btSave AT ROW 16.21 COL 13
     btCancel AT ROW 16.21 COL 24
     btHelp AT ROW 16.21 COL 80
     btDecl AT ROW 16.33 COL 35.29
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16 COL 1
     "Obs:" VIEW-AS TEXT
          SIZE 3.57 BY .88 AT ROW 10.21 COL 32.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-proc-imp T "?" NO-UNDO mgcex historico-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-proc-imp2 T "?" NO-UNDO mgcex historico-proc-imp
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
         HEIGHT             = 16.83
         WIDTH              = 90
         MAX-HEIGHT         = 20.96
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.96
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

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


&Scoped-define SELF-NAME btDecl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDecl wMaintenanceNoNavigation
ON CHOOSE OF btDecl IN FRAME fpage0 /* Comunica‡äes */
DO:
    def var h-prog1 as handle no-undo.
    
    RUN imp/im0050db.w persistent set h-prog1 
                       (input ?,
                        input tt-historico-proc-imp2.r-rowid,
                        input "ADD":U,
                        input this-procedure,
                        input 1).
    run initializeinterface in h-prog1.
    wait-for close of h-prog1 focus current-window.
  
    {&WINDOW-NAME}:sensitive = yes.
    apply 'entry' to {&WINDOW-NAME}.                        
                        
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

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    
    run piValidaEfetivacaoEmbarque in this-procedure.
    if  return-value = "NOK":U then
        return no-apply.

    &endif

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN OpenQueriesSon in phCaller.
        run openQuery in h-bocx150a2 (input 1).
        run repositionRecord in phcaller (input prtable).   
        RUN bringParent IN phCaller.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.        
    ELSE
        return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    
    run piValidaEfetivacaoEmbarque in this-procedure.
    if  return-value = "NOK":U then
        return no-apply.

    &endif
    
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        run openQuery in h-bocx150a2 (input 1).
        run repositionRecord in phcaller (input prtable).   
        RUN bringParent IN phCaller.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-proc-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-historico-proc-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-boad107"
      &FindMethod="findCodigo"
      &KeyValue1="tt-historico-proc-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome"
      &FieldScreen1="desc-est"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-proc-imp.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp.cod-itiner wMaintenanceNoNavigation
ON LEAVE OF tt-historico-proc-imp.cod-itiner IN FRAME fpage0 /* C¢digo Itiner rio */
DO:
  {method/referencefields.i 
   &HandleDBOLeave="h-bocx115"
   &FindMethod="findCodigo"
   &KeyValue1="integer(tt-historico-proc-imp.cod-itiner:SCREEN-VALUE IN FRAME fPage0)"
   &FieldName1="descricao"
   &FieldScreen1="desc-itiner"
   &Frame1="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-proc-imp2.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp2.cod-pto-contr wMaintenanceNoNavigation
ON F5 OF tt-historico-proc-imp2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx110.w"
     &FieldZoom1="cod-pto-contr"
     &FieldScreen1="tt-historico-proc-imp2.cod-pto-contr"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="desc-pto"
     &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp2.cod-pto-contr wMaintenanceNoNavigation
ON LEAVE OF tt-historico-proc-imp2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-bocx110"
      &FindMethod="findCodigo"
      &KeyValue1="tt-historico-proc-imp2.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="descricao"
      &FieldScreen1="desc-pto"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp2.cod-pto-contr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-historico-proc-imp2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-proc-imp2.sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp2.sequencia wMaintenanceNoNavigation
ON LEAVE OF tt-historico-proc-imp2.sequencia IN FRAME fpage0 /* Seq */
DO:
  run retornaTransportePtoAnterior in h-bocx150a2(input tt-historico-proc-imp.cod-estabel:screen-value in frame fpage0,
                                                  input tt-historico-proc-imp.nr-proc-imp:screen-value in frame fpage0,
                                                  input tt-historico-proc-imp.cod-itiner:screen-value in frame fpage0,
                                                  input tt-historico-proc-imp2.sequencia:screen-value in frame fpage0,
                                                  output c-meio-transp).
  if (tt-historico-proc-imp2.id-meio-transp:screen-value in frame fpage0 = " ") or (tt-historico-proc-imp2.sequencia:sensitive in frame fpage0 = yes) then
     assign tt-historico-proc-imp2.id-meio-transp:screen-value in frame fpage0 = c-meio-transp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
tt-historico-proc-imp2.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    if  valid-handle (h-bocx351) then do:
        delete procedure h-bocx351.
        assign h-bocx351 = ?.
    end.
    &endif
    
    if  valid-handle (h-bocx140) then do:
        delete procedure h-bocx140.
        assign h-bocx140 = ?.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "LEAVE":U TO tt-historico-proc-imp.cod-itiner     IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-proc-imp.cod-estabel    IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-proc-imp2.cod-pto-contr IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-proc-imp2.sequencia     IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if pcAction = "UPDATE":u then 
       enable btDecl with frame fPage0.

    
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenanceNoNavigation 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input   parameter i-pag    as integer no-undo.
def output  parameter h-handle as handle  no-undo.

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
       RUN cxbo/bocx150a.p persistent set h-bocx150a2.
    END.
    
    RUN cxbo/bocx110.p persistent set h-bocx110.
    RUN adbo/boad107.p persistent set h-boad107.

    RUN cxbo/bocx115.p persistent set h-bocx115.

    run openQuery in h-bocx115 (input 1).

    if  not valid-handle (h-bocx140) then
        run cxbo/bocx140.p persistent set h-bocx140.

    run openQuery in h-bocx140 (input 1).

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    
    if  not valid-handle (h-bocx351) then 
        run cxbo/bocx351.p persistent set h-bocx351.

    run openQueryStatic in h-bocx351 (input "Main":U).
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEfetivacaoEmbarque wMaintenanceNoNavigation 
PROCEDURE piValidaEfetivacaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    
    if  valid-handle (h-bocx115) then do:

        assign iPtoEmbarque = 0.

        run findCodigo in h-bocx115 (input tt-historico-proc-imp2.cod-itiner,
                                     output cReturn).
        if  cReturn = "":U then 
            run getIntField in h-bocx115 (input "pto-embarque":U,
                                          output iPtoEmbarque).
    end.

    if  iPtoEmbarque = input frame fPage0 tt-historico-proc-imp2.cod-pto-contr
    and input frame fPage0 tt-historico-proc-imp2.dt-efetiva <> ? then do:
        
        assign iNumPedido = 0.
        
        if  valid-handle (h-bocx140) then do:
            run findProcessoImp in h-bocx140 (input tt-historico-proc-imp2.cod-estabel,
                                              input tt-historico-proc-imp2.nr-proc-imp,
                                              output cReturn).
            if  cReturn = "":U then
                run getIntField in h-bocx140 (input "num-pedido":U,
                                              output iNumPedido).
        end.
    
        if  valid-handle (h-bocx351) then do:
    
            assign cOrdensSemLI = "":U.
            
            run piRetornaLI in h-bocx351 (input 1,
                                          input yes,
                                          input iNumPedido,
                                          input ?,
                                          input ?,
                                          input ?,
                                          input no,
                                          input yes,
                                          input 0,
                                          input 99999999,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                          output table tt-licenciam-import-oc). 
        end.
    
        for each  tt-licenciam-import-oc
            where tt-licenciam-import-oc.licenca-import = "":U
            break by tt-licenciam-import-oc.numero-ordem
                    by tt-licenciam-import-oc.parcela:
    
            if  first-of (tt-licenciam-import-oc.numero-ordem) then do:
                if  cOrdensSemLI = "":U then
                    assign cOrdensSemLI = string(tt-licenciam-import-oc.numero-ordem).
                else
                    assign cOrdensSemLI = cOrdensSemLI + ", ":U + string(tt-licenciam-import-oc.numero-ordem).
            end.
        end.
    
        if  cOrdensSemLi <> "":U then do:
        
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Processo" *}
            run utp/ut-msgs.p (input "Show":U,
                               input 30446,
                               input RETURN-VALUE + "~~":U + cOrdensSemLI).
            if  return-value = "no":U then
                return "NOK":U.
        end.
        
    end.

    return "OK":U.

    &endif
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
    assign tt-historico-proc-imp2.cod-estabel = tt-historico-proc-imp.cod-estabel
           tt-historico-proc-imp2.nr-proc-imp = tt-historico-proc-imp.nr-proc-imp
           tt-historico-proc-imp2.cod-itiner  = tt-historico-proc-imp.cod-itiner.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

