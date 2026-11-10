&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decl-hist-proc-imp NO-UNDO LIKE mgcex.decl-hist-proc-imp
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0050DC 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0050dc MIM}
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
&GLOBAL-DEFINE Program        IM0050DC
&GLOBAL-DEFINE Version        2.00.00.005
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE page0Widgets   tt-decl-hist-proc-imp.int-2 ~
                              tt-decl-hist-proc-imp.decl-emitida ~
                              tt-decl-hist-proc-imp.int-1 ~
                              tt-decl-hist-proc-imp.e-mail-despachante ~
                              tt-decl-hist-proc-imp.e-mail-agente ~
                              tt-decl-hist-proc-imp.e-mail-emitente ~
                              tt-decl-hist-proc-imp.e-mail-fabricante ~
                              tt-decl-hist-proc-imp.e-mail-repres ~
                              tt-decl-hist-proc-imp.e-mail-outros ~
                              tt-decl-hist-proc-imp.texto ~
                              btOK btCancel btHelp
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets  

/* tt-decl-hist-proc-imp.de-codigo ~ */

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Shared Variable Definitions ---                                       */
def shared var c-acao as char  no-undo.
DEF shared var r-row  as rowid no-undo.

/* Local Variable Definitions ---                                       */
def var h-bocx275 as handle no-undo.
def var h-bocx010 as handle no-undo.
def var h-bocx150 as handle no-undo.
def var h-bocx140 as handle no-undo.

def var i-de-cod  as int    no-undo.
def var c-idiom-usuar   as char   no-undo.
def var c-return        as char   no-undo.
def var c-cod-estabel   as char   no-undo.
def var c-nr-proc-imp   as char   no-undo.
def var i-cod-emitente  as char   no-undo.

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017 as handle no-undo.
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    def var h-boun178 as handle no-undo.
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decl-hist-proc-imp.de-codigo ~
tt-decl-hist-proc-imp.int-2 tt-decl-hist-proc-imp.decl-emitida ~
tt-decl-hist-proc-imp.int-1 tt-decl-hist-proc-imp.e-mail-despachante ~
tt-decl-hist-proc-imp.e-mail-agente tt-decl-hist-proc-imp.e-mail-emitente ~
tt-decl-hist-proc-imp.e-mail-fabricante tt-decl-hist-proc-imp.e-mail-repres ~
tt-decl-hist-proc-imp.e-mail-outros tt-decl-hist-proc-imp.texto 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}de-codigo ~{&FP2}de-codigo ~{&FP3}~
 ~{&FP1}int-2 ~{&FP2}int-2 ~{&FP3}~
 ~{&FP1}e-mail-despachante ~{&FP2}e-mail-despachante ~{&FP3}~
 ~{&FP1}e-mail-agente ~{&FP2}e-mail-agente ~{&FP3}~
 ~{&FP1}e-mail-emitente ~{&FP2}e-mail-emitente ~{&FP3}~
 ~{&FP1}e-mail-fabricante ~{&FP2}e-mail-fabricante ~{&FP3}~
 ~{&FP1}e-mail-repres ~{&FP2}e-mail-repres ~{&FP3}~
 ~{&FP1}e-mail-outros ~{&FP2}e-mail-outros ~{&FP3}
&Scoped-define ENABLED-TABLES tt-decl-hist-proc-imp
&Scoped-define FIRST-ENABLED-TABLE tt-decl-hist-proc-imp
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar desc-decl btOK btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decl-hist-proc-imp.de-codigo ~
tt-decl-hist-proc-imp.int-2 tt-decl-hist-proc-imp.decl-emitida ~
tt-decl-hist-proc-imp.int-1 tt-decl-hist-proc-imp.e-mail-despachante ~
tt-decl-hist-proc-imp.e-mail-agente tt-decl-hist-proc-imp.e-mail-emitente ~
tt-decl-hist-proc-imp.e-mail-fabricante tt-decl-hist-proc-imp.e-mail-repres ~
tt-decl-hist-proc-imp.e-mail-outros tt-decl-hist-proc-imp.texto 
&Scoped-Define DISPLAYED-OBJECTS desc-decl 

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

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE desc-decl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.72 BY 6.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decl-hist-proc-imp.de-codigo AT ROW 1.38 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     desc-decl AT ROW 1.38 COL 24.3 COLON-ALIGNED NO-LABEL
     tt-decl-hist-proc-imp.int-2 AT ROW 3.25 COL 17.72 COLON-ALIGNED
          LABEL "Dias de Tolerƒncia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decl-hist-proc-imp.decl-emitida AT ROW 3.29 COL 26.57
          VIEW-AS TOGGLE-BOX
          SIZE 19.14 BY .83
     tt-decl-hist-proc-imp.int-1 AT ROW 4.46 COL 54 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Processo/Embarque Atrasado", 1,
"Processo/Embarque Adiantado", 2,
"Processo/Embarque Prazo", 3,
"Processo/Embarque Fora do Prazo", 4,
"Sempre Emite", 5
          SIZE 27 BY 4.63
     tt-decl-hist-proc-imp.e-mail-despachante AT ROW 4.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.e-mail-agente AT ROW 5.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.e-mail-emitente AT ROW 6.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.e-mail-fabricante AT ROW 7.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.e-mail-repres AT ROW 8.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.e-mail-outros AT ROW 9.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-proc-imp.texto AT ROW 11.17 COL 19.72 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 54.43 BY 5.92
     btOK AT ROW 18.13 COL 2
     btCancel AT ROW 18.13 COL 13
     btHelp AT ROW 18.13 COL 80
     RECT-1 AT ROW 3.54 COL 53
     rtToolBar AT ROW 17.92 COL 1
     "Emite Declara‡Æo:" VIEW-AS TEXT
          SIZE 12.86 BY .88 AT ROW 3.17 COL 53.86
     "Texto:" VIEW-AS TEXT
          SIZE 4.57 BY .88 AT ROW 11.04 COL 14.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 18.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decl-hist-proc-imp T "?" NO-UNDO mgcex decl-hist-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.5
         WIDTH              = 90.57
         MAX-HEIGHT         = 18.5
         MAX-WIDTH          = 90.57
         VIRTUAL-HEIGHT     = 18.5
         VIRTUAL-WIDTH      = 90.57
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
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-decl-hist-proc-imp.int-2 IN FRAME fpage0
   EXP-LABEL                                                            */
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

   for each RowErrors:
       delete RowErrors.
   end.     

   run findRowid in h-bocx150(input prParent).
   run getCharfield in h-bocx150(input "cod-estabel",output tt-decl-hist-proc-imp.cod-estabel).
   run getCharfield in h-bocx150(input "nr-proc-imp",output tt-decl-hist-proc-imp.nr-proc-imp).
   run getIntfield in h-bocx150 (input "cod-itiner" ,output tt-decl-hist-proc-imp.cod-itiner).
   run getIntfield in h-bocx150 (input "sequencia"  ,output tt-decl-hist-proc-imp.sequencia).            
   assign frame fPage0
          tt-decl-hist-proc-imp.de-codigo
          tt-decl-hist-proc-imp.int-2
          tt-decl-hist-proc-imp.decl-emitida
          tt-decl-hist-proc-imp.int-1
          tt-decl-hist-proc-imp.e-mail-despachante
          tt-decl-hist-proc-imp.e-mail-agente
          tt-decl-hist-proc-imp.e-mail-emitente
          tt-decl-hist-proc-imp.e-mail-fabricante
          tt-decl-hist-proc-imp.e-mail-repres
          tt-decl-hist-proc-imp.e-mail-outros
          tt-decl-hist-proc-imp.texto.

  if c-acao = "ADD":u then do:        

     run validaDeclaracao in h-bocx275 (input tt-decl-hist-proc-imp.cod-estabel,
                                        input tt-decl-hist-proc-imp.nr-proc-imp,
                                        input tt-decl-hist-proc-imp.cod-itiner,
                                        input tt-decl-hist-proc-imp.de-codigo,
                                        output table RowErrors).

     IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

        leave.
     end.
     else do:
          RUN validateCreate IN h-bocx275 (INPUT TABLE tt-decl-hist-proc-imp,
                                           OUTPUT TABLE RowErrors,
                                           OUTPUT tt-decl-hist-proc-imp.r-rowid).
     end.                                      
  end.
  else if  c-acao = "UPDATE":u then do:
           RUN validateUpdate IN h-bocx275 (INPUT  TABLE tt-decl-hist-proc-imp,
                                            input tt-decl-hist-proc-imp.r-rowid,
                                            OUTPUT TABLE RowErrors).

  end.                                   

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

        LEAVE.
    END.
    ELSE DO:
        RUN getRowid IN h-bocx275 (OUTPUT tt-decl-hist-proc-imp.r-rowid).
        /*RUN bringParent IN phCaller.*/
        RUN repositionRecordSon IN phCaller (INPUT prParent, INPUT piSonPageNumber).
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decl-hist-proc-imp.de-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-proc-imp.de-codigo wWindow
ON F5 OF tt-decl-hist-proc-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO:
  {method/zoomfields.i 
     &ProgramZoom="cxzoom/z01cx010.w"
     &FieldZoom1="de-codigo"
     &FieldScreen1="tt-decl-hist-proc-imp.de-codigo"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="desc-decl"
     &Frame2="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-proc-imp.de-codigo wWindow
ON LEAVE OF tt-decl-hist-proc-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO: 

    {method/referencefields.i 
      &HandleDBOLeave="h-bocx010"
      &FindMethod="findPk_de_codigo"
      &KeyValue1="tt-decl-hist-proc-imp.de-codigo:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="descricao"
      &FieldScreen1="desc-decl"
      &Frame1="fPage0"}

  if  c-acao = "ADD":u then do:
      &IF '{&mgdis_version}' >= '2.06f' &THEN
          run fnbo/bofn017.p persistent set h-bofn017.
          run goTokey in h-bofn017 (input v_cod_usuar_corren).
          IF RETURN-VALUE = "OK" THEN DO:
              run getCurrent in h-bofn017 (output table tt_usuar_mestre).
              find first tt_usuar_mestre no-error.
              if   avail tt_usuar_mestre then
                  assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
          end.
          delete procedure h-bofn017.
      &ELSE
          run unbo/boun178.p persistent set h-boun178.
          run findSrmstr_id in h-boun178 (input v_cod_usuar_corren, output c-return).
          if  c-return = "" then do:
              run getCurrent in h-boun178 (output table tt_usuar_mestre).
              find first tt_usuar_mestre no-error.
              if   avail tt_usuar_mestre then
                   assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
          end.
          delete procedure h-boun178.
      &ENDIF
      
      run findRowid in h-bocx150(input prParent).
      run getCharfield in h-bocx150(input "nr-proc-imp", output c-nr-proc-imp).

      RUN cxbo/bocx140.p persistent set h-bocx140.
      run findPk_nr_processo in h-bocx140(input c-nr-proc-imp,output c-return).        
      if c-return = "" then do:
         run getIntfield in h-bocx140 (input "cod-exportador",output i-cod-emitente).
         run getCharfield in h-bocx140(input "cod-estabel"   ,output c-cod-estabel).
      end.            
      delete procedure h-bocx140.

      run retornaTexto in h-bocx275 (input c-nr-proc-imp,
                                     input c-cod-estabel,
                                     input i-cod-emitente,  
                                     input "",
                                     input int(tt-decl-hist-proc-imp.de-codigo:screen-value in frame fpage0),    
                                     input c-idiom-usuar,
                                     output tt-decl-hist-proc-imp.e-mail-agente,
                                     output tt-decl-hist-proc-imp.e-mail-despachante,
                                     output tt-decl-hist-proc-imp.e-mail-emitente,
                                     output tt-decl-hist-proc-imp.e-mail-fabricante,
                                     output tt-decl-hist-proc-imp.e-mail-repres,
                                     output tt-decl-hist-proc-imp.texto).


    assign    tt-decl-hist-proc-imp.e-mail-despachante:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-despachante
              tt-decl-hist-proc-imp.e-mail-agente:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-agente
              tt-decl-hist-proc-imp.e-mail-emitente:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-emitente
              tt-decl-hist-proc-imp.e-mail-fabricante:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-fabricante
              tt-decl-hist-proc-imp.e-mail-repres:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-repres
              tt-decl-hist-proc-imp.e-mail-outros:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-outros
              tt-decl-hist-proc-imp.texto:screen-value in frame fpage0 = tt-decl-hist-proc-imp.texto.                                  

  end.                            

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-proc-imp.de-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-decl-hist-proc-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO:

apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

tt-decl-hist-proc-imp.de-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.

/*--- L¢gica para inicializa‡Æo do programam ---*/
RUN cxbo/bocx275.p persistent set h-bocx275.
RUN cxbo/bocx010.p persistent set h-bocx010.
RUN cxbo/bocx150.p persistent set h-bocx150.


{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdisplayWidgets wWindow 
PROCEDURE AfterdisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if c-acao = "UPDATE":u then do:
    run findRowid in h-bocx275 (input r-row).
    run getCurrent in h-bocx275 (output table tt-decl-hist-proc-imp).
    find first tt-decl-hist-proc-imp no-error.
    if   avail tt-decl-hist-proc-imp then do:
/*         run findPk_de_codigo in h-bocx010 (input tt-decl-hist-proc-imp.de-codigo, output desc-decl).
 *          message "-1-" desc-decl.*/
         assign  
              tt-decl-hist-proc-imp.de-codigo:screen-value in frame fpage0 = string(tt-decl-hist-proc-imp.de-codigo)
/*              desc-decl:screen-value in frame fpage0 = desc-decl*/
              tt-decl-hist-proc-imp.int-2:screen-value in frame fpage0 = string(tt-decl-hist-proc-imp.int-2)
              tt-decl-hist-proc-imp.decl-emitida:screen-value in frame fpage0 = string(tt-decl-hist-proc-imp.decl-emitida)
              tt-decl-hist-proc-imp.int-1:screen-value in frame fpage0 = string(tt-decl-hist-proc-imp.int-1)
              tt-decl-hist-proc-imp.e-mail-despachante:screen-value in frame fpage0 =  tt-decl-hist-proc-imp.e-mail-despachante
              tt-decl-hist-proc-imp.e-mail-agente:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-agente
              tt-decl-hist-proc-imp.e-mail-emitente:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-emitente
              tt-decl-hist-proc-imp.e-mail-fabricante:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-fabricante
              tt-decl-hist-proc-imp.e-mail-repres:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-repres
              tt-decl-hist-proc-imp.e-mail-outros:screen-value in frame fpage0 = tt-decl-hist-proc-imp.e-mail-outros
              tt-decl-hist-proc-imp.texto:screen-value in frame fpage0 = tt-decl-hist-proc-imp.texto.
        apply "leave":U to tt-decl-hist-proc-imp.de-codigo in frame fpage0.
        apply "entry":U to tt-decl-hist-proc-imp.int-2 in frame fpage0.              
        disable tt-decl-hist-proc-imp.de-codigo with frame fpage0.
    end.
end.    
else if c-acao = "ADD":u then 
     enable tt-decl-hist-proc-imp.de-codigo with frame fpage0.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedisplayWidgets wWindow 
PROCEDURE BeforedisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    create tt-decl-hist-proc-imp.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


