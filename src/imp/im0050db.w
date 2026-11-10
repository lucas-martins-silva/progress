&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decl-hist-proc-imp NO-UNDO LIKE mgcex.decl-hist-proc-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-proc-imp NO-UNDO LIKE mgcex.historico-proc-imp
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
{include/i-prgvrs.i IM0050DB 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0050DB MIM}
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
&GLOBAL-DEFINE Program           IM0050DB
&GLOBAL-DEFINE Version           2.00.00.003
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FramesHandle      STRING(FRAME fPage1:HANDLE)

&GLOBAL-DEFINE FolderLabels      Comunica‡Æo

&GLOBAL-DEFINE ttTable           tt-decl-hist-proc-imp
&GLOBAL-DEFINE hDBOTable         h-bocx275
&GLOBAL-DEFINE DBOTable          decl-hist-proc-imp

&GLOBAL-DEFINE ttParent          tt-historico-proc-imp
&GLOBAL-DEFINE hDBOParent        h-bocx150
&GLOBAL-DEFINE DBOParentTable    historico-proc-imp

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-historico-proc-imp.cod-pto-contr ~
                                  fill-in-1

&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* New Shared Variable Definitions ---                                       */
def new shared var c-acao as char  no-undo.
def new shared var r-row  as rowid no-undo.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
def var cDescricao like decl-padrao.descricao no-undo.
def var h-bocx010 as handle no-undo.
def var h-bocx110 as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-decl-hist-proc-imp

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-decl-hist-proc-imp.de-codigo ~
fnDescricao(tt-decl-hist-proc-imp.de-codigo) @ cDescricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define FIELD-PAIRS-IN-QUERY-brSon1
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-decl-hist-proc-imp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-decl-hist-proc-imp
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-decl-hist-proc-imp


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-proc-imp.cod-pto-contr 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-pto-contr ~{&FP2}cod-pto-contr ~{&FP3}
&Scoped-define ENABLED-TABLES tt-historico-proc-imp
&Scoped-define FIRST-ENABLED-TABLE tt-historico-proc-imp
&Scoped-Define ENABLED-OBJECTS rtKeys FILL-IN-1 rtToolBar btOK btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-historico-proc-imp.cod-pto-contr 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMaintenanceNoNavigation 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-decl as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Sair" 
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
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btMod 
     LABEL "Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-decl-hist-proc-imp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenanceNoNavigation _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-decl-hist-proc-imp.de-codigo
      fnDescricao(tt-decl-hist-proc-imp.de-codigo) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 3.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-historico-proc-imp.cod-pto-contr AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     FILL-IN-1 AT ROW 1.17 COL 41.86 COLON-ALIGNED NO-LABEL
     btOK AT ROW 9.92 COL 2
     btSave AT ROW 9.92 COL 13
     btCancel AT ROW 9.92 COL 13
     btHelp AT ROW 9.92 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 9.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 4.92 COL 2
     btDeleteSon1 AT ROW 4.92 COL 22
     btMod AT ROW 4.96 COL 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.71
         SIZE 84.43 BY 5.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decl-hist-proc-imp T "?" NO-UNDO mgcex decl-hist-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-proc-imp T "?" NO-UNDO mgcex historico-proc-imp
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
         HEIGHT             = 10.25
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
     _TblList          = "Temp-Tables.tt-decl-hist-proc-imp"
     _FldNameList[1]   = Temp-Tables.tt-decl-hist-proc-imp.de-codigo
     _FldNameList[2]   > "_<CALC>"
"fnDescricao(tt-decl-hist-proc-imp.de-codigo) @ cDescricao" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no "Descri‡Æo da Despesa"
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
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
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
 apply "choose":u to btMod in frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMaintenanceNoNavigation
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
 def var rPai as rowid no-undo.
 def var rFilho as rowid no-undo.
 assign rPai = prParent
        rFilho = ?
        c-acao = "ADD":u.
 RUN imp/im0050dc.w (input rPai, input THIS-PROCEDURE, input 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMaintenanceNoNavigation
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    def var r-decl-hist-proc-imp as rowid no-undo.

    if avail tt-decl-hist-proc-imp then do:
        assign r-decl-hist-proc-imp = tt-decl-hist-proc-imp.r-rowid.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Declara‡Æo" *}
        RUN utp/ut-msgs.p (input "Show", input 550, input RETURN-VALUE).
        if return-value = "yes" then do:
            RUN validateDelete in {&hDBOTable} (input-output r-decl-hist-proc-imp, 
                                                output table rowErrors).
            if can-find(first rowErrors) then do:
                IF NOT VALID-HANDLE(hShowMsg) THEN
                    RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.              
              RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
            end.
            else do:
                delete tt-decl-hist-proc-imp.
                browse brSon1:DELETE-CURRENT-ROW().
            end.  
        end.
    end.
    find first tt-decl-hist-proc-imp no-error.
    if   avail tt-decl-hist-proc-imp then do:
      enable btMod btDeleteSon1 with frame fpage1.
    end.
   else do:
        disable btMod btDeleteSon1 with frame fpage1.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMod wMaintenanceNoNavigation
ON CHOOSE OF btMod IN FRAME fPage1 /* Modificar */
DO:
 def var rPai as rowid no-undo.
 def var rFilho as rowid no-undo.
 assign rPai = prParent
        rFilho = ?
        r-row  = tt-decl-hist-proc-imp.r-rowid
        c-acao = "UPDATE":u.
 RUN imp/im0050dc.w (input rPai, input THIS-PROCEDURE, input 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
           APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-proc-imp.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp.cod-pto-contr wMaintenanceNoNavigation
ON LEAVE OF tt-historico-proc-imp.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/ReferenceFields.i 
      &HandleDBOLeave="h-bocx110"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-historico-proc-imp.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="fill-in-1"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-proc-imp.cod-pto-contr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-historico-proc-imp.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    {method/ZoomFields.i 
     &ProgramZoom="cxzoom/z10cx110.w"
     &FieldZoom1="cod-pto-contr"
     &FieldScreen1="tt-historico-proc-imp.cod-pto-contr"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="fill-in-1"
     &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
tt-historico-proc-imp.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
{maintenancenonavigation/MainBlock.i}

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
    
   APPLY "LEAVE":U TO tt-historico-proc-imp.cod-pto-contr IN FRAME fPage0.

   DEFINE VARIABLE r-historico-proc-imp as rowid NO-UNDO.
   def var iRowsReturned as integer no-undo.
   
   IF AVAILABLE tt-historico-proc-imp THEN
       ASSIGN r-historico-proc-imp = tt-historico-proc-imp.r-rowid.
   ELSE
       ASSIGN r-historico-proc-imp = ?.
   enable btMod with frame fpage1.
   RUN setConstraint2 IN {&hDBOTable} (input r-historico-proc-imp).
        
        /*--- Abre query do DBO filho ---*/
   RUN openQuery IN {&hDBOTable} (INPUT 2).
        
        /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
   RUN findFirst IN {&hDBOTable}.
        
        /*--- Retorna faixa de registro do DBO Filho ---*/
   RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                        INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-decl-hist-proc-imp).
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
   
                                           
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
find first tt-decl-hist-proc-imp no-error.
if   avail tt-decl-hist-proc-imp then do:
     enable btMod btDeleteSon1 with frame fpage1.
end.
else do:
     disable btMod btDeleteSon1 with frame fpage1.
end.


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
       RUN cxbo/bocx275.p persistent set h-bocx275.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "CodPtoContr":U).
    &ENDIF
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx150.p persistent set h-bocx150.
    END.
    
    RUN cxbo/bocx110.p persistent set h-bocx110.
    RUN cxbo/bocx010.p persistent set h-bocx010.
    enable btAddSon1 btDeleteSon1 brSon1 with frame fPage1.
    disable btSave with frame fPage0.
    hide btSave.
    assign btCancel:column = 13.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenanceNoNavigation 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter rchave as rowid no-undo.
  def input parameter pNumber as integer no-undo.
  
  def var iRowsReturned as integer no-undo.
  

  if pNumber = 1 then do:
    RUN setConstraint2 IN {&hDBOTable} (input rchave).
         
         /*--- Abre query do DBO filho ---*/
    RUN openQuery IN {&hDBOTable} (INPUT 2).
         
         /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
    RUN findFirst IN {&hDBOTable}.
         
         /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                         INPUT ?,
                                         INPUT NO,
                                         INPUT ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE tt-decl-hist-proc-imp).
     {&OPEN-QUERY-brSon1}
     APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
     find first tt-decl-hist-proc-imp no-error.
     if   avail tt-decl-hist-proc-imp then do:
          enable btMod btDeleteSon1 with frame fpage1.
     end.
     else do:
          disable btMod btDeleteSon1 with frame fpage1.
     end.

  end.
    
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMaintenanceNoNavigation 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-decl as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cStatus as char no-undo.
  RUN findPk_de_codigo in h-bocx010 (input pcod-decl, output cStatus).
  
  RUN getCharField in h-bocx010 (input "descricao", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


