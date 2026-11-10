&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-invoice-emb-imp NO-UNDO LIKE invoice-emb-imp
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
{include/i-prgvrs.i IM0045E 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0045e MIM}
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
&GLOBAL-DEFINE Program           IM0045E
&GLOBAL-DEFINE Version        2.00.00.010
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           tt-invoice-emb-imp
&GLOBAL-DEFINE hDBOTable         h-bocx295
&GLOBAL-DEFINE DBOTable          invoice-emb-imp

&GLOBAL-DEFINE ttParent          tt-embarque-imp
&GLOBAL-DEFINE hDBOParent        h-bocx220
&GLOBAL-DEFINE DBOParentTable    embarque-imp

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-invoice-emb-imp.nr-invoice ~
                                 tt-invoice-emb-imp.parcela ~
                                 tt-invoice-emb-imp.dt-vencim ~
                                 tt-invoice-emb-imp.vl-invoice ~
                                 tt-invoice-emb-imp.mo-codigo
&GLOBAL-DEFINE page0ParentFields tt-embarque-imp.cod-estabel ~
                                 tt-embarque-imp.embarque

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
def var h-boun005 as handle no-undo.
def var c-return  as char no-undo.

{include/boerrtab.i} /* tt-bo-erro */

/* pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque tt-invoice-emb-imp.nr-invoice ~
tt-invoice-emb-imp.parcela tt-invoice-emb-imp.dt-vencim ~
tt-invoice-emb-imp.vl-invoice tt-invoice-emb-imp.mo-codigo 
&Scoped-define ENABLED-TABLES tt-embarque-imp tt-invoice-emb-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-define SECOND-ENABLED-TABLE tt-invoice-emb-imp
&Scoped-define DISPLAYED-TABLES tt-embarque-imp tt-invoice-emb-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-define SECOND-DISPLAYED-TABLE tt-invoice-emb-imp
&Scoped-Define ENABLED-OBJECTS FILL-IN-1 btOK btSave btCancel btHelp rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque tt-invoice-emb-imp.nr-invoice ~
tt-invoice-emb-imp.parcela tt-invoice-emb-imp.dt-vencim ~
tt-invoice-emb-imp.vl-invoice tt-invoice-emb-imp.mo-codigo 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

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

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 7.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-embarque-imp.cod-estabel AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 2.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-invoice-emb-imp.nr-invoice AT ROW 3.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     tt-invoice-emb-imp.parcela AT ROW 4.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-invoice-emb-imp.dt-vencim AT ROW 5.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-invoice-emb-imp.vl-invoice AT ROW 6.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-invoice-emb-imp.mo-codigo AT ROW 7.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     FILL-IN-1 AT ROW 7.17 COL 40.14 COLON-ALIGNED NO-LABEL
     btOK AT ROW 8.54 COL 2
     btSave AT ROW 8.54 COL 13
     btCancel AT ROW 8.54 COL 24
     btHelp AT ROW 8.54 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 8.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-invoice-emb-imp T "?" NO-UNDO mgcex invoice-emb-imp
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
         HEIGHT             = 8.79
         WIDTH              = 90
         MAX-HEIGHT         = 16.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16.33
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
    IF RETURN-VALUE = "OK":U THEN DO:
        run repositionRecord in phcaller(input prParent).
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
    IF RETURN-VALUE = "OK":U THEN DO:
        run repositionRecord in phcaller(input prParent).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-invoice-emb-imp.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-invoice-emb-imp.mo-codigo wMaintenanceNoNavigation
ON F5 OF tt-invoice-emb-imp.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                       &campo=tt-invoice-emb-imp.mo-codigo
                       &campozoom=mo-codigo
                       &campo2=fill-in-1
                       &campozoom2=descricao}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-invoice-emb-imp.mo-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-invoice-emb-imp.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
  {method/referencefields.i 
   &HandleDBOLeave="h-boun005"
   &FindMethod="findCodigo"
   &KeyValue1="integer(tt-invoice-emb-imp.mo-codigo:SCREEN-VALUE IN FRAME fPage0)"
   &FieldName1="descricao"
   &FieldScreen1="fill-in-1"
   &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-invoice-emb-imp.mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-invoice-emb-imp.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
 tt-invoice-emb-imp.mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    delete procedure h-boun005.
    
    RETURN "OK":U.
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
    if avail tt-invoice-emb-imp then do:
        APPLY "LEAVE":U TO tt-invoice-emb-imp.mo-codigo IN FRAME fPage0.
    end.
    
    RETURN "OK":U.
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

    case pcAction:
        when "UPDATE":U then do:
            disable tt-invoice-emb-imp.nr-invoice 
                    tt-invoice-emb-imp.parcela
                    with frame fPage0.
        end.
        when "ADD":U then do:
            run inicializarFaturaordem in {&hDBOTable} (input tt-embarque-imp.cod-estabel,
                                                        input tt-embarque-imp.embarque,
                                                        output tt-invoice-emb-imp.vl-invoice,
                                                        output tt-invoice-emb-imp.dt-vencim,
                                                        output tt-invoice-emb-imp.mo-codigo).
            disp tt-invoice-emb-imp.vl-invoice
                 tt-invoice-emb-imp.dt-vencim
                 tt-invoice-emb-imp.mo-codigo 
                 with frame fPage0.
            apply "leave":U to tt-invoice-emb-imp.mo-codigo in frame fPage0.                 
        end.
    end case.
    
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
       RUN cxbo/bocx295.p persistent set h-bocx295.
    END.
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.
    
    RUN unbo/boun005.p persistent set h-boun005.

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

    if avail tt-invoice-emb-imp then do:
        assign tt-invoice-emb-imp.cod-estabel = tt-embarque-imp.cod-estabel
               tt-invoice-emb-imp.embarque    = tt-embarque-imp.embarque.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

