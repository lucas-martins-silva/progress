&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cot-ordem NO-UNDO LIKE cot-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-cot-ordem2 NO-UNDO LIKE cot-ordem
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
{include/i-prgvrs.i IM0015M 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0015M MIM}
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
&GLOBAL-DEFINE Program           IM0015M
&GLOBAL-DEFINE Version           2.00.00.008
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FramesHandle      STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels      Ordens

&GLOBAL-DEFINE ttTable           tt-cot-ordem2
&GLOBAL-DEFINE hDBOTable         h-bocx300a
&GLOBAL-DEFINE DBOTable          cot-ordem

&GLOBAL-DEFINE ttParent          tt-cot-ordem
&GLOBAL-DEFINE DBOParentTable    cot-ordem

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       fill-in-1
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

{cdp/cdcfgmat.i}  /* Pre-processadores */
{cxbo/bocx300a.i} /* Definicao temp-table tt-cotacao */

def temp-table tt-confirma no-undo
    field r-rowid as rowid
    field l-confirma as logical init no.
    
def temp-table tt-cot-rowid no-undo
    field r-rowid as rowid.
    
def var p-ordem-ini like ordem-compra.numero-ordem no-undo.
def var i-ordem-ini like ordem-compra.numero-ordem no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cotacao tt-confirma

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-confirma.l-confirma no-label tt-cotacao.numero-ordem tt-cotacao.cod-emitente tt-cotacao.it-codigo tt-cotacao.data-cotacao &if defined(bf-mat-comex) &then &else tt-cotacao.seq-cotac &endif tt-cotacao.quantidade tt-cotacao.un tt-cotacao.qtd-do-forn tt-cotacao.un-fornec tt-cotacao.preco-unit tt-cotacao.pre-unit-for tt-cotacao.cod-cond-pag tt-cotacao.mo-codigo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-cotacao NO-LOCK, ~
                                   EACH tt-confirma where tt-confirma.r-rowid = tt-cotacao.r-rowid NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-cotacao NO-LOCK, ~
                                   EACH tt-confirma where tt-confirma.r-rowid = tt-cotacao.r-rowid NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-cotacao tt-confirma
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-cotacao
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 tt-confirma


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-ordem fill-in-1 btOK btHelp rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fill-in-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ordem 
     IMAGE-UP FILE "image\gr-ent":U
     LABEL "Button 1" 
     SIZE 4 BY 1.

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

DEFINE VARIABLE fill-in-1 AS INTEGER FORMAT ">>>>>>,>9" INITIAL 0 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-cotacao, 
      tt-confirma SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenanceNoNavigation _FREEFORM
  QUERY brSon1 DISPLAY
      tt-confirma.l-confirma FORMAT "X/ " no-label
      tt-cotacao.numero-ordem FORMAT ">>>>>9,99"
      tt-cotacao.cod-emitente FORMAT ">>>>>>>>9"
      tt-cotacao.it-codigo
      tt-cotacao.data-cotacao
      &if defined(bf-mat-comex) &then      
      &else
      tt-cotacao.seq-cotac
      &endif      
      tt-cotacao.quantidade COLUMN-LABEL "Nossa Qtde" FORMAT ">>>>,>>9.9999"
      tt-cotacao.un column-label "UN" format "x(3)"
      tt-cotacao.qtd-do-forn column-label "Qtde Fornec" format ">>>>,>>9.9999"
      tt-cotacao.un-fornec   column-label "UN Fornec" format "x(3)"
      tt-cotacao.preco-unit COLUMN-LABEL "Pre‡o Unit Interno" FORMAT ">>>>>,>>>,>>9.99999"
      tt-cotacao.pre-unit-for column-label "Pre‡o Unit Fornec" format ">>>>>,>>>,>>9.99999"
      tt-cotacao.cod-cond-pag COLUMN-LABEL "Cond Pagto" FORMAT ">>9"
      tt-cotacao.mo-codigo COLUMN-LABEL "Moeda" FORMAT "99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 13.33
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-ordem AT ROW 1.13 COL 47.29 HELP
          "Ordem de Compra Inicial"
     fill-in-1 AT ROW 1.17 COL 35 COLON-ALIGNED HELP
          "Ordem Compra."
     btOK AT ROW 18.46 COL 2
     btSave AT ROW 18.46 COL 13
     btCancel AT ROW 18.46 COL 24.14
     btHelp AT ROW 18.46 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 18.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 18.83
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.83
         SIZE 84.43 BY 13.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-cot-ordem T "?" NO-UNDO mgcex cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-cot-ordem2 T "?" NO-UNDO mgcex cot-ordem
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
         HEIGHT             = 18.83
         WIDTH              = 90.43
         MAX-HEIGHT         = 18.83
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 18.83
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cotacao NO-LOCK,
                            EACH tt-confirma where tt-confirma.r-rowid = tt-cotacao.r-rowid NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenanceNoNavigation
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fPage1
DO:
    if avail tt-confirma then do:
        if tt-confirma.l-confirma = no then
            assign tt-confirma.l-confirma = yes
                   tt-confirma.l-confirma:screen-value in browse brSon1 = "X".
        else
            assign tt-confirma.l-confirma = no
                   tt-confirma.l-confirma:screen-value in browse brSon1 = " ".
    end.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ordem wMaintenanceNoNavigation
ON CHOOSE OF bt-ordem IN FRAME fpage0 /* Button 1 */
DO:
    run openQueryBrSon1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    RUN OpenQueriesSon in phCaller.
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
   do transaction on error undo, leave:
        for each tt-cot-rowid:
            delete tt-cot-rowid.
        end.
   
        for each tt-cotacao no-lock:
            find tt-confirma where tt-confirma.r-rowid = tt-cotacao.r-rowid no-error.
            if avail tt-confirma then do:
               if tt-confirma.l-confirma = yes then do:
                  create tt-cot-rowid.
                  assign tt-cot-rowid.r-rowid = tt-cotacao.r-rowid.
               end.
            end.
        end.
        IF NOT VALID-HANDLE(h-bocx300a) THEN DO:
           RUN cxbo/bocx300a.p persistent set h-bocx300a.
        END.   
        RUN createCotordem in h-bocx300a (input table tt-cot-rowid,
                                          input prParent,
                                          output table RowErrors).
        /*DELETE procedure h-bocx300a.*/                                  
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            for each tt-confirma /* where tt-confirma.l-confirma = yes*/:
                delete tt-confirma.
            end.        
            RUN OpenQueryBrSon1.
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).           
            leave.
        END.
        ELSE DO:
            for each tt-confirma /* where tt-confirma.l-confirma = yes*/:
                delete tt-confirma.
            end.
            RUN OpenQueriesSon in phCaller.
            APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.                
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fill-in-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fill-in-1 wMaintenanceNoNavigation
ON LEAVE OF fill-in-1 IN FRAME fpage0 /* Ordem Compra */
DO:
  assign fill-in-1   = input frame fPage0 fill-in-1
         i-ordem-ini = input frame fPage0 fill-in-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

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
    delete procedure h-bocx300a.

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
    END.
    
    RUN cxbo/bocx300a.p persistent set h-bocx300a.
     
    disable btSave with frame fPage0.
    hide btSave.
    assign btCancel:column = 13.
    enable brSon1 with frame fPage1.  
    assign p-ordem-ini = int(fill-in-1:screen-value in frame fPage0).  
    RUN setConstraint3 in h-bocx300a (input prParent,
                                      output p-ordem-ini).
    
    assign fill-in-1   = p-ordem-ini
           i-ordem-ini = p-ordem-ini.   
    
    RUN OpenQueryBrSon1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryBrSon1 wMaintenanceNoNavigation 
PROCEDURE OpenQueryBrSon1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Verifica se o DBO j  est  inicializado ---*/
    
    enable bt-ordem with frame fPage0.

    for each tt-cotacao:
        delete tt-cotacao.
    end.
    
    for each tt-confirma:
        delete tt-confirma.
    end.
    
    IF NOT VALID-HANDLE(h-bocx300a) THEN DO:
       RUN cxbo/bocx300a.p persistent set h-bocx300a.
    END.
     
    RUN setConstraint2 in h-bocx300a (input i-ordem-ini).
                                      
    RUN retornaTTCotacao in h-bocx300a (output table tt-cotacao).
       
    for each tt-cotacao no-lock:
        find first tt-confirma where tt-confirma.r-rowid = tt-cotacao.r-rowid no-error.
        if not avail tt-confirma then do:
           create tt-confirma.
           assign tt-confirma.r-rowid = tt-cotacao.r-rowid
                  tt-confirma.l-confirma = no.
        end.
    end.
    
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
        
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

