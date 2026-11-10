&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V02IN578 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN578 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-formula-reaj for formula-reaj.

def var dt-aux       as date                     no-undo.
def var l-inclui     as logical initial no       no-undo.
def var de-percent   as decimal                  no-undo.
def var de-perc-reaj like formula-reaj.perc-reaj no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES formula-reaj
&Scoped-define FIRST-EXTERNAL-TABLE formula-reaj


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR formula-reaj.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS formula-reaj.dat-preco-base ~
formula-reaj.log-reajuste formula-reaj.mo-codigo[1] ~
formula-reaj.mo-codigo[2] formula-reaj.mo-codigo[3] ~
formula-reaj.mo-codigo[4] formula-reaj.mo-codigo[5] 
&Scoped-define ENABLED-TABLES formula-reaj
&Scoped-define FIRST-ENABLED-TABLE formula-reaj
&Scoped-Define ENABLED-OBJECTS cb-per-reaj i-nr-dias RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS formula-reaj.nr-contrato ~
formula-reaj.num-seq-item formula-reaj.dat-preco-base ~
formula-reaj.dat-prox-reaj formula-reaj.log-reajuste ~
formula-reaj.mo-codigo[1] formula-reaj.dat-indice[1] ~
formula-reaj.perc-reaj[1] formula-reaj.mo-codigo[2] ~
formula-reaj.dat-indice[2] formula-reaj.perc-reaj[2] ~
formula-reaj.mo-codigo[3] formula-reaj.dat-indice[3] ~
formula-reaj.perc-reaj[3] formula-reaj.mo-codigo[4] ~
formula-reaj.dat-indice[4] formula-reaj.perc-reaj[4] ~
formula-reaj.mo-codigo[5] formula-reaj.dat-indice[5] ~
formula-reaj.perc-reaj[5] 
&Scoped-define DISPLAYED-TABLES formula-reaj
&Scoped-define FIRST-DISPLAYED-TABLE formula-reaj
&Scoped-Define DISPLAYED-OBJECTS c-desc-contrat c-it-codigo c-desc-item ~
cb-per-reaj i-nr-dias de-preco c-desc-mo1 c-desc-mo2 c-desc-mo3 c-desc-mo4 ~
c-desc-mo5 c-tit-reaj c-tit-indice c-tit-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS i-nr-dias formula-reaj.dat-indice[1] ~
formula-reaj.perc-reaj[1] formula-reaj.dat-indice[2] ~
formula-reaj.perc-reaj[2] formula-reaj.dat-indice[3] ~
formula-reaj.perc-reaj[3] formula-reaj.dat-indice[4] ~
formula-reaj.perc-reaj[4] formula-reaj.dat-indice[5] ~
formula-reaj.perc-reaj[5] 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-per-reaj AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-contrat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-indice AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-moeda AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-reaj AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.43 BY .67 NO-UNDO.

DEFINE VARIABLE de-preco AS DECIMAL FORMAT "->>>>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Pre‡o Fornecedor":R20 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dias AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Nr. Dias" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.43 BY 6.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 10.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     formula-reaj.nr-contrato AT ROW 1.21 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-contrat AT ROW 1.21 COL 40.29 COLON-ALIGNED NO-LABEL
     c-it-codigo AT ROW 2.21 COL 22.86 COLON-ALIGNED HELP
          "C¢digo do item"
     c-desc-item AT ROW 2.21 COL 39.14 COLON-ALIGNED NO-LABEL
     formula-reaj.num-seq-item AT ROW 3.21 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     formula-reaj.dat-preco-base AT ROW 4.54 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     cb-per-reaj AT ROW 5.5 COL 22.86 COLON-ALIGNED
     i-nr-dias AT ROW 6.54 COL 22.86 COLON-ALIGNED
     formula-reaj.dat-prox-reaj AT ROW 4.54 COL 62.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     de-preco AT ROW 5.54 COL 62.57 COLON-ALIGNED HELP
          "Pre‡o unit rio do Fornecedor."
     formula-reaj.log-reajuste AT ROW 6.67 COL 64.72
          VIEW-AS TOGGLE-BOX
          SIZE 23.86 BY .83
     formula-reaj.mo-codigo[1] AT ROW 9.08 COL 18.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-desc-mo1 AT ROW 9.08 COL 21.86 COLON-ALIGNED NO-LABEL
     formula-reaj.dat-indice[1] AT ROW 9.08 COL 42.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[1] AT ROW 9.08 COL 61.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[2] AT ROW 10.08 COL 18.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-desc-mo2 AT ROW 10.08 COL 21.86 COLON-ALIGNED NO-LABEL
     formula-reaj.dat-indice[2] AT ROW 10.08 COL 42.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[2] AT ROW 10.08 COL 61.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[3] AT ROW 11.08 COL 18.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-desc-mo3 AT ROW 11.08 COL 21.86 COLON-ALIGNED NO-LABEL
     formula-reaj.dat-indice[3] AT ROW 11.08 COL 42.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[3] AT ROW 11.08 COL 61.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[4] AT ROW 12.08 COL 18.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-desc-mo4 AT ROW 12.08 COL 21.86 COLON-ALIGNED NO-LABEL
     formula-reaj.dat-indice[4] AT ROW 12.08 COL 42.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[4] AT ROW 12.08 COL 61.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[5] AT ROW 13.08 COL 18.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-desc-mo5 AT ROW 13.08 COL 21.86 COLON-ALIGNED NO-LABEL
     formula-reaj.dat-indice[5] AT ROW 13.08 COL 42.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[5] AT ROW 13.08 COL 61.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     c-tit-reaj AT ROW 8.29 COL 60.86 COLON-ALIGNED NO-LABEL
     c-tit-indice AT ROW 8.29 COL 43.72 COLON-ALIGNED NO-LABEL
     c-tit-moeda AT ROW 8.29 COL 24.29 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 8 COL 7.72
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.formula-reaj
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 13.71
         WIDTH              = 88.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mo1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mo2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mo3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mo4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mo5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-indice IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-reaj IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[1] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[2] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[3] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[4] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[5] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.dat-prox-reaj IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-dias IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN formula-reaj.nr-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.num-seq-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[1] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[2] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[3] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[4] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[5] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-per-reaj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-per-reaj V-table-Win
ON VALUE-CHANGED OF cb-per-reaj IN FRAME f-main
DO:
   if avail formula-reaj then do:
      if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 6 then do:
         display formula-reaj.dat-prox-reaj - formula-reaj.dat-preco-base @ i-nr-dias with frame {&frame-name}.
      end.
   end.

   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 1 then do:
      assign i-nr-dias = 30.
      display i-nr-dias with frame {&frame-name}.
      disable i-nr-dias with frame {&frame-name}.
   end.

   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 2 then do:

      assign i-nr-dias = 60.
      display i-nr-dias with frame {&frame-name}.
      disable i-nr-dias with frame {&frame-name}.
   end.
      
   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 3 then do:
      assign i-nr-dias = 90.
      display i-nr-dias with frame {&frame-name}.
      disable i-nr-dias with frame {&frame-name}.
   end.
      
   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 4 then do:
      assign i-nr-dias = 180.
      display i-nr-dias with frame {&frame-name}.
      disable i-nr-dias with frame {&frame-name}.
   end.
      
   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 5 then do:
      assign i-nr-dias = 360.
      display i-nr-dias with frame {&frame-name}.
      disable i-nr-dias with frame {&frame-name}.
   end.
                          
   if {varinc/var00062.i 06 cb-per-reaj:screen-value in frame {&frame-name}} = 6 then do:
      enable i-nr-dias with frame {&frame-name}. 
   end. 
    
   display (input frame {&frame-name} i-nr-dias + input frame {&frame-name} formula-reaj.dat-preco-base) 
           @ formula-reaj.dat-prox-reaj with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.dat-preco-base
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.dat-preco-base V-table-Win
ON LEAVE OF formula-reaj.dat-preco-base IN FRAME f-main /* Data Base */
DO:
   apply 'value-changed' to cb-per-reaj in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-dias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-dias V-table-Win
ON LEAVE OF i-nr-dias IN FRAME f-main /* Nr. Dias */
DO:
     assign dt-aux = input frame {&frame-name} i-nr-dias + input frame {&frame-name} formula-reaj.dat-preco-base.
     display dt-aux @ formula-reaj.dat-prox-reaj with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.mo-codigo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[1] V-table-Win
ON F5 OF formula-reaj.mo-codigo[1] IN FRAME f-main /* Moeda[1] */
DO:
   
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad178.w"
                   &tabela=formula-reaj
                   &atributo=mo-codigo[1]}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[1] V-table-Win
ON LEAVE OF formula-reaj.mo-codigo[1] IN FRAME f-main /* Moeda[1] */
DO:
   /* DEFINE VARIABLE wh-wdg-leave AS WIDGET-HANDLE NO-UNDO.
 *     
 *     ASSIGN wh-wdg-leave = LAST-EVENT:WIDGET-ENTER.
 *     
 *     IF wh-wdg-leave:TYPE = "button":U THEN
 *         LEAVE.
 *     ELSE DO:*/

if input frame {&frame-name} formula-reaj.mo-codigo[1] <> 0 then do:
   {include/leave.i &tabela=moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mo1
                    &where="moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[1]"}
                
    if de-percent <> 100 then do:
       enable formula-reaj.dat-indice[1]
              formula-reaj.perc-reaj[1] with frame {&frame-name}.       
       apply "entry" to formula-reaj.dat-indice[1] in frame {&frame-name}.                   
       return no-apply. 
    end.           
    else
    assign formula-reaj.mo-codigo[1]:screen-value in frame {&frame-name} = "0".
end.
else do:
    disable formula-reaj.dat-indice[1]
            formula-reaj.perc-reaj[1] with frame {&frame-name}.
   
    assign c-desc-mo1:screen-value in frame {&frame-name} = " "
           formula-reaj.dat-indice[1]:screen-value in frame {&frame-name} = string(?)
           formula-reaj.perc-reaj[1]:screen-value in frame {&frame-name} = "0".    
end.  

/*END. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[1] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF formula-reaj.mo-codigo[1] IN FRAME f-main /* Moeda[1] */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.mo-codigo[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[2] V-table-Win
ON F5 OF formula-reaj.mo-codigo[2] IN FRAME f-main /* Moeda[2] */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad178.w"
                   &tabela=formula-reaj
                   &atributo=mo-codigo[2]}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[2] V-table-Win
ON LEAVE OF formula-reaj.mo-codigo[2] IN FRAME f-main /* Moeda[2] */
DO:

if input frame {&frame-name} formula-reaj.mo-codigo[2] <> 0 then do:
  {include/leave.i &tabela=moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mo2
                    &where="moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[2]"}
                    
    if de-percent <> 100 then do:
       enable formula-reaj.dat-indice[2]
              formula-reaj.perc-reaj[2] with frame {&frame-name}.
       apply "entry" to formula-reaj.dat-indice[2] in frame {&frame-name}.                   
       return no-apply. 
    end.
        
    else
    assign formula-reaj.mo-codigo[2]:screen-value in frame {&frame-name} = "0".
end.

else do:
    disable formula-reaj.dat-indice[2]
            formula-reaj.perc-reaj[2] with frame {&frame-name}.
    assign c-desc-mo2:screen-value in frame {&frame-name} = " "
           formula-reaj.dat-indice[2]:screen-value in frame {&frame-name} = string(?)
           formula-reaj.perc-reaj[2]:screen-value in frame {&frame-name} = "0".
end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[2] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF formula-reaj.mo-codigo[2] IN FRAME f-main /* Moeda[2] */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.mo-codigo[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[3] V-table-Win
ON F5 OF formula-reaj.mo-codigo[3] IN FRAME f-main /* Moeda[3] */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad178.w"
                   &tabela=formula-reaj
                   &atributo=mo-codigo[3]}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[3] V-table-Win
ON LEAVE OF formula-reaj.mo-codigo[3] IN FRAME f-main /* Moeda[3] */
DO:

if input frame {&frame-name} formula-reaj.mo-codigo[3] <> 0 then do:
  {include/leave.i &tabela=moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mo3
                    &where="moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[3]"}
                    
    if de-percent <> 100 then do:
       enable formula-reaj.dat-indice[3]
              formula-reaj.perc-reaj[3] with frame {&frame-name}.
       apply "entry" to formula-reaj.dat-indice[3] in frame {&frame-name}.                   
       return no-apply. 
    end. 
       
    else
    assign formula-reaj.mo-codigo[3]:screen-value in frame {&frame-name} = "0".
end.

else do:
    disable formula-reaj.dat-indice[3]
            formula-reaj.perc-reaj[3] with frame {&frame-name}.
    assign c-desc-mo3:screen-value in frame {&frame-name} = " "
           formula-reaj.dat-indice[3]:screen-value in frame {&frame-name} = string(?)
           formula-reaj.perc-reaj[3]:screen-value in frame {&frame-name} = "0".
end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[3] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF formula-reaj.mo-codigo[3] IN FRAME f-main /* Moeda[3] */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.mo-codigo[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[4] V-table-Win
ON F5 OF formula-reaj.mo-codigo[4] IN FRAME f-main /* Moeda[4] */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad178.w"
                   &tabela=formula-reaj
                   &atributo=mo-codigo[4]}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[4] V-table-Win
ON LEAVE OF formula-reaj.mo-codigo[4] IN FRAME f-main /* Moeda[4] */
DO:

if input frame {&frame-name} formula-reaj.mo-codigo[4] <> 0 then do:
  {include/leave.i &tabela=moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mo4
                    &where="moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[4]"}
                    
    if de-percent <> 100 then do:
       enable formula-reaj.dat-indice[4]
              formula-reaj.perc-reaj[4] with frame {&frame-name}.
       apply "entry" to formula-reaj.dat-indice[4] in frame {&frame-name}.                   
       return no-apply. 
    end. 
           
    else
    assign formula-reaj.mo-codigo[4]:screen-value in frame {&frame-name} = "0".
end.

else do:
    disable formula-reaj.dat-indice[4]
            formula-reaj.perc-reaj[4] with frame {&frame-name}.
    assign c-desc-mo4:screen-value in frame {&frame-name} = " "
           formula-reaj.dat-indice[4]:screen-value in frame {&frame-name} = string(?)
           formula-reaj.perc-reaj[4]:screen-value in frame {&frame-name} = "0".
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[4] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF formula-reaj.mo-codigo[4] IN FRAME f-main /* Moeda[4] */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.mo-codigo[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[5] V-table-Win
ON F5 OF formula-reaj.mo-codigo[5] IN FRAME f-main /* Moeda[5] */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad178.w"
                   &tabela=formula-reaj
                   &atributo=mo-codigo[5]}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[5] V-table-Win
ON LEAVE OF formula-reaj.mo-codigo[5] IN FRAME f-main /* Moeda[5] */
DO:

if input frame {&frame-name} formula-reaj.mo-codigo[5] <> 0 then do:
  {include/leave.i &tabela=moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mo5
                    &where="moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[5]"}
                    
    if de-percent <> 100 then do:
       enable formula-reaj.dat-indice[5]
              formula-reaj.perc-reaj[5] with frame {&frame-name}.
       apply "entry" to formula-reaj.dat-indice[5] in frame {&frame-name}.                   
       return no-apply. 
    end. 
        
    else
    assign formula-reaj.mo-codigo[5]:screen-value in frame {&frame-name} = "0".
end.

else do:
    disable formula-reaj.dat-indice[5]
            formula-reaj.perc-reaj[5] with frame {&frame-name}.
    assign c-desc-mo5:screen-value in frame {&frame-name} = " "
           formula-reaj.dat-indice[5]:screen-value in frame {&frame-name} = string(?)
           formula-reaj.perc-reaj[5]:screen-value in frame {&frame-name} = "0".
end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.mo-codigo[5] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF formula-reaj.mo-codigo[5] IN FRAME f-main /* Moeda[5] */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.perc-reaj[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.perc-reaj[1] V-table-Win
ON LEAVE OF formula-reaj.perc-reaj[1] IN FRAME f-main /* Reaj %[1] */
DO:
  assign de-perc-reaj[1] = input frame {&frame-name} formula-reaj.perc-reaj[1].
  run pi-calcula-percentual.
  run pi-habilita.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.perc-reaj[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.perc-reaj[2] V-table-Win
ON LEAVE OF formula-reaj.perc-reaj[2] IN FRAME f-main /* Reaj %[2] */
DO:
  assign de-perc-reaj[2] = input frame {&frame-name} formula-reaj.perc-reaj[2].
  run pi-calcula-percentual.
  run pi-habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.perc-reaj[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.perc-reaj[3] V-table-Win
ON LEAVE OF formula-reaj.perc-reaj[3] IN FRAME f-main /* Reaj %[3] */
DO:
  assign de-perc-reaj[3] = input frame {&frame-name} formula-reaj.perc-reaj[3].
  run pi-calcula-percentual.
  run pi-habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.perc-reaj[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.perc-reaj[4] V-table-Win
ON LEAVE OF formula-reaj.perc-reaj[4] IN FRAME f-main /* Reaj %[4] */
DO:
  assign de-perc-reaj[4] = input frame {&frame-name} formula-reaj.perc-reaj[4].
  run pi-calcula-percentual.
  run pi-habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME formula-reaj.perc-reaj[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL formula-reaj.perc-reaj[5] V-table-Win
ON LEAVE OF formula-reaj.perc-reaj[5] IN FRAME f-main /* Reaj %[5] */
DO:
  assign de-perc-reaj[5] = input frame {&frame-name} formula-reaj.perc-reaj[5].
  run pi-calcula-percentual.
  run pi-habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if formula-reaj.mo-codigo[1]:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if formula-reaj.mo-codigo[2]:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if formula-reaj.mo-codigo[3]:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if formula-reaj.mo-codigo[4]:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if formula-reaj.mo-codigo[5]:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "formula-reaj"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "formula-reaj"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  assign l-inclui = yes.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
   
  {utp/ut-liter.i Moeda * C}
  assign c-tit-moeda = return-value.
  display c-tit-moeda with frame {&frame-name}.
  
  {utp/ut-liter.i Data_Öndice * C}
  assign c-tit-indice = return-value.
  display c-tit-indice with frame {&frame-name}.

  {utp/ut-liter.i %_Reajuste * C}
  assign c-tit-reaj = return-value.
  display c-tit-reaj with frame {&frame-name}.
  
  {utp/ut-liter.i Reajuste_Autom tico * C}
  assign formula-reaj.log-reajuste:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Pre‡o_Atual * L}
  assign de-preco:label in frame {&frame-name} = return-value.

  assign cb-per-reaj:screen-value in frame {&frame-name} = {varinc/var00062.i 04 1}.

  find item-contrat where rowid(item-contrat) = v-row-parent no-lock no-error.
  if avail item-contrat then do:
     display item-contrat.nr-contrat   @ formula-reaj.nr-contrat with frame {&frame-name}.
     display item-contrat.it-codigo    @ c-it-codigo with frame {&frame-name}.
     display item-contrat.num-seq-item @ formula-reaj.num-seq-item with frame {&frame-name}.
     display item-contrat.preco-fornec @ de-preco with frame {&frame-name}.

     find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
     if avail contrato-for then do:
        display contrato-for.des-contrat @ c-desc-contrat with frame {&frame-name}.
     end.
     find item where item.it-codigo = item-contrat.it-codigo no-lock no-error.
     if avail item then do:
        display item.desc-item @ c-desc-item with frame {&frame-name}.  
     end.
 
     assign formula-reaj.dat-preco-base:screen-value 
            in frame {&frame-name} = string (item-contrat.dat-base).     
  end.  
  else assign formula-reaj.dat-preco-base:screen-value in frame {&frame-name} = string (today).
            
  apply 'value-changed' to cb-per-reaj in frame {&frame-name}.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-valid.i}  
    
 assign dt-aux = input frame {&frame-name} i-nr-dias + input frame {&frame-name} formula-reaj.dat-preco-base. 
   
 if input frame {&frame-name} i-nr-dias = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 17163,
                           input "").
        
        apply "entry" to i-nr-dias in frame {&frame-name}.
        
        return 'ADM-ERROR':U.
 end.
 
 if l-inclui = yes then do:
    find b-formula-reaj where b-formula-reaj.nr-contrat   = input frame {&frame-name} formula-reaj.nr-contrat and
                              b-formula-reaj.num-seq-item = input frame {&frame-name} formula-reaj.num-seq-item no-lock no-error.
    if avail b-formula-reaj then do:
       run utp/ut-msgs.p (input "show":U, 
                          input 8552, /* FORMULA DE REAJUSTE JA CADASTRADA */
                          input "").
       leave.
       apply 'close' to this-procedure.
    end.
 end.       

 run pi-calcula-percentual.
 
 if /*de-percent <> 0 and */ de-percent < 100 then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8553, 
                       input return-value).
     if return-value = "yes" then do:
        leave.
        apply 'close' to this-procedure.
     end.
     if return-value = "no" then do:
        return 'ADM-ERROR':U.
     end.
 end.
 
 if de-percent > 100 then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 374, 
                       input "").
     return 'ADM-ERROR':U.
 end.


 if input frame {&frame-name} formula-reaj.mo-codigo[1] = 0
    then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 8555, /* MOEDA DEVE SER DIFERENTE DA MOEDA CORRENTE */
                       input "").
    apply 'entry' to formula-reaj.mo-codigo[1] in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 
 if input frame {&frame-name} formula-reaj.mo-codigo[2] = 0 and
    de-percent <> 100 then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 8555, 
                       input "").
    apply 'entry' to formula-reaj.mo-codigo[2] in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} formula-reaj.mo-codigo[3] = 0 and
    de-percent <> 100 then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 8555, 
                       input "").
    apply 'entry' to formula-reaj.mo-codigo[3] in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} formula-reaj.mo-codigo[4] = 0 and
    de-percent <> 100 then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 8555, 
                       input "").
    apply 'entry' to formula-reaj.mo-codigo[4] in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} formula-reaj.mo-codigo[5] = 0 and
    de-percent <> 100 then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 8555, 
                       input "").
    apply 'entry' to formula-reaj.mo-codigo[5] in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.

 if  input frame {&frame-name} formula-reaj.mo-codigo[1] <> 0 and
    (input frame {&frame-name} formula-reaj.mo-codigo[1] = input frame {&frame-name} formula-reaj.mo-codigo[2] or
     input frame {&frame-name} formula-reaj.mo-codigo[1] = input frame {&frame-name} formula-reaj.mo-codigo[3] or
     input frame {&frame-name} formula-reaj.mo-codigo[1] = input frame {&frame-name} formula-reaj.mo-codigo[4] or
     input frame {&frame-name} formula-reaj.mo-codigo[1] = input frame {&frame-name} formula-reaj.mo-codigo[5]) then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8554, /* MOEDA JA CADASTRADA */
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[1] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if  input frame {&frame-name} formula-reaj.mo-codigo[2] <> 0 and
    (input frame {&frame-name} formula-reaj.mo-codigo[2] = input frame {&frame-name} formula-reaj.mo-codigo[1] or
     input frame {&frame-name} formula-reaj.mo-codigo[2] = input frame {&frame-name} formula-reaj.mo-codigo[3] or
     input frame {&frame-name} formula-reaj.mo-codigo[2] = input frame {&frame-name} formula-reaj.mo-codigo[4] or
     input frame {&frame-name} formula-reaj.mo-codigo[2] = input frame {&frame-name} formula-reaj.mo-codigo[5]) then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8554, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[2] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if  input frame {&frame-name} formula-reaj.mo-codigo[3] <> 0 and
    (input frame {&frame-name} formula-reaj.mo-codigo[3] = input frame {&frame-name} formula-reaj.mo-codigo[1] or
     input frame {&frame-name} formula-reaj.mo-codigo[3] = input frame {&frame-name} formula-reaj.mo-codigo[2] or
     input frame {&frame-name} formula-reaj.mo-codigo[3] = input frame {&frame-name} formula-reaj.mo-codigo[4] or
     input frame {&frame-name} formula-reaj.mo-codigo[3] = input frame {&frame-name} formula-reaj.mo-codigo[5]) then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8554, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[3] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if  input frame {&frame-name} formula-reaj.mo-codigo[4] <> 0 and
    (input frame {&frame-name} formula-reaj.mo-codigo[4] = input frame {&frame-name} formula-reaj.mo-codigo[1] or
     input frame {&frame-name} formula-reaj.mo-codigo[4] = input frame {&frame-name} formula-reaj.mo-codigo[2] or
     input frame {&frame-name} formula-reaj.mo-codigo[4] = input frame {&frame-name} formula-reaj.mo-codigo[3] or
     input frame {&frame-name} formula-reaj.mo-codigo[4] = input frame {&frame-name} formula-reaj.mo-codigo[5]) then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8554, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[4] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if  input frame {&frame-name} formula-reaj.mo-codigo[5] <> 0 and
    (input frame {&frame-name} formula-reaj.mo-codigo[5] = input frame {&frame-name} formula-reaj.mo-codigo[1] or
     input frame {&frame-name} formula-reaj.mo-codigo[5] = input frame {&frame-name} formula-reaj.mo-codigo[2] or
     input frame {&frame-name} formula-reaj.mo-codigo[5] = input frame {&frame-name} formula-reaj.mo-codigo[3] or
     input frame {&frame-name} formula-reaj.mo-codigo[5] = input frame {&frame-name} formula-reaj.mo-codigo[4]) then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 8554, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[5] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 
 find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[1] no-lock no-error.
 if  not avail moeda then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 495, /* MOEDA NAO CADASTRADA */
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[5] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[2] no-lock no-error.
 if  not avail moeda then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 495, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[2] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[3] no-lock no-error.
 if  not avail moeda then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 495, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[3] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[4] no-lock no-error.
 if  not avail moeda then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 495, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[4] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[5] no-lock no-error.
 if  not avail moeda then do:
     run utp/ut-msgs.p (input "show":U, 
                       input 495, 
                       input "").
     apply 'entry' to formula-reaj.mo-codigo[5] in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 
/* assign de-percent = 0.
 *  if input frame {&frame-name} formula-reaj.mo-codigo[1] <> 0 then do:
 *     assign de-percent = de-percent + input frame {&frame-name} formula-reaj.perc-reaj[1].
 *  end.
 *  if input frame {&frame-name} formula-reaj.mo-codigo[2] <> 0 then do:
 *     assign de-percent = de-percent + input frame {&frame-name} formula-reaj.perc-reaj[2].
 *  end.
 *  if input frame {&frame-name} formula-reaj.mo-codigo[3] <> 0 then do:
 *     assign de-percent = de-percent + input frame {&frame-name} formula-reaj.perc-reaj[3].
 *  end.
 *  if input frame {&frame-name} formula-reaj.mo-codigo[4] <> 0 then do:
 *     assign de-percent = de-percent + input frame {&frame-name} formula-reaj.perc-reaj[4].
 *  end.
 *  if input frame {&frame-name} formula-reaj.mo-codigo[5] <> 0 then do:
 *     assign de-percent = de-percent + input frame {&frame-name} formula-reaj.perc-reaj[5].
 *  end.
 * 
 *  if de-percent <> 0 and de-percent < 100 then do:
 *      run utp/ut-msgs.p (input "show":U, 
 *                        input 8553, 
 *                        input return-value).
 *      if return-value = "yes" then do:
 *         leave.
 *         apply 'close' to this-procedure.
 *      end.
 *      if return-value = "no" then do:
 *         return 'ADM-ERROR':U.
 *      end.
 *  end.
 *  
 *  if de-percent > 100 then do:
 *      run utp/ut-msgs.p (input "show":U, 
 *                        input 374, 
 *                        input "").
 *      return 'ADM-ERROR':U.
 *  end.*/
         
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
 assign formula-reaj.dat-reaj-ant  = dt-aux
        formula-reaj.dat-prox-reaj = dt-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  assign cb-per-reaj = input frame {&frame-name} cb-per-reaj.
  assign formula-reaj.periodo = {varinc/var00062.i 06 cb-per-reaj}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
 

  if l-inclui = yes then do:
     find item-contrat where rowid(item-contrat) = v-row-parent NO-LOCK no-error.
     if avail item-contrat then do:
        assign formula-reaj.nr-contrat   = item-contrat.nr-contrat
               formula-reaj.num-seq-item = item-contrat.num-seq-item.
     end.
  end.
  
   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  disable i-nr-dias with frame {&frame-name}.
  
  {utp/ut-liter.i Moeda * C}
  assign c-tit-moeda = return-value.
  display c-tit-moeda with frame {&frame-name}.
  
  {utp/ut-liter.i Data_Öndice * C}
  assign c-tit-indice = return-value.
  display c-tit-indice with frame {&frame-name}.

  {utp/ut-liter.i %_Reajuste * C}
  assign c-tit-reaj = return-value.
  display c-tit-reaj with frame {&frame-name}.
  
  {utp/ut-liter.i Reajuste_Autom tico * C}
  assign formula-reaj.log-reajuste:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Pre‡o_Atual * L}
  assign de-preco:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Per¡odo_Reajuste * L}
  assign cb-per-reaj:label in frame {&frame-name} = return-value.
  
  if avail formula-reaj then do with frame {&frame-name}:
     assign cb-per-reaj:screen-value = {varinc/var00062.i 04 formula-reaj.periodo}.
     apply 'value-changed' to cb-per-reaj in frame {&frame-name}.
  end.
  else do:
      assign cb-per-reaj:screen-value = {varinc/var00062.i 04 1}.
  end.
   
  find item-contrat where rowid(item-contrat) = v-row-parent no-lock no-error.
  if avail item-contrat then do:
     display item-contrat.nr-contrat   @ formula-reaj.nr-contrat with frame {&frame-name}.
     display item-contrat.it-codigo    @ c-it-codigo with frame {&frame-name}.
     display item-contrat.num-seq-item @ formula-reaj.num-seq-item with frame {&frame-name}.
     display item-contrat.preco-fornec @ de-preco with frame {&frame-name}.

     find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
     if avail contrato-for then do:
        display contrato-for.des-contrat @ c-desc-contrat with frame {&frame-name}.
     end.
     find item where item.it-codigo = item-contrat.it-codigo no-lock no-error.
     if avail item then do:
        display item.desc-item @ c-desc-item with frame {&frame-name}.  
     end.
  end.  
  

  if input frame {&frame-name} formula-reaj.mo-codigo[1] <> 0 then do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[1] no-lock no-error.
     if avail moeda then do:
        assign c-desc-mo1 = moeda.descricao.
        display c-desc-mo1 with frame {&frame-name}.
     end.
  end.
  
  if input frame {&frame-name} formula-reaj.mo-codigo[2] <> 0 then do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[2] no-lock no-error.
     if avail moeda then do:
        assign c-desc-mo2 = moeda.descricao.
        display c-desc-mo2 with frame {&frame-name}.
     end.
  end.

  if input frame {&frame-name} formula-reaj.mo-codigo[3] <> 0 then do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[3] no-lock no-error.
     if avail moeda then do:
        assign c-desc-mo3 = moeda.descricao.
        display c-desc-mo3 with frame {&frame-name}.
     end.
  end.

  if input frame {&frame-name} formula-reaj.mo-codigo[4] <> 0 then do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[4] no-lock no-error.
     if avail moeda then do:
        assign c-desc-mo4 = moeda.descricao.
        display c-desc-mo4 with frame {&frame-name}.
     end.
  end.

  if input frame {&frame-name} formula-reaj.mo-codigo[5] <> 0 then do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} formula-reaj.mo-codigo[5] no-lock no-error.
     if avail moeda then do:
        assign c-desc-mo5 = moeda.descricao.
        display c-desc-mo5 with frame {&frame-name}.
     end.
  end.
  
  apply 'value-changed' to cb-per-reaj in frame {&frame-name}.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  if l-inclui = no then do: 
    assign de-perc-reaj[1] = formula-reaj.perc-reaj[1]
           de-perc-reaj[2] = formula-reaj.perc-reaj[2]
           de-perc-reaj[3] = formula-reaj.perc-reaj[3]
           de-perc-reaj[4] = formula-reaj.perc-reaj[4]
           de-perc-reaj[5] = formula-reaj.perc-reaj[5].
          
    if input frame {&frame-name} formula-reaj.mo-codigo[1] = 0 then do:
       disable formula-reaj.mo-codigo[1] 
               formula-reaj.perc-reaj[1]
               formula-reaj.dat-indic[1] with frame {&frame-name}.
    end.
    else
       enable formula-reaj.mo-codigo[1] 
              formula-reaj.perc-reaj[1]
              formula-reaj.dat-indic[1] with frame {&frame-name}.
    
    if input frame {&frame-name} formula-reaj.mo-codigo[2] = 0 then do:
       disable formula-reaj.mo-codigo[2] 
               formula-reaj.perc-reaj[2]
               formula-reaj.dat-indic[2] with frame {&frame-name}.
    end.
    else
       enable formula-reaj.mo-codigo[2] 
              formula-reaj.perc-reaj[2]
              formula-reaj.dat-indic[2] with frame {&frame-name}.
    if input frame {&frame-name} formula-reaj.mo-codigo[3] = 0 then do:
       disable formula-reaj.mo-codigo[3] 
               formula-reaj.perc-reaj[3]
               formula-reaj.dat-indic[3] with frame {&frame-name}.
    end.
    else
       enable formula-reaj.mo-codigo[3] 
              formula-reaj.perc-reaj[3]
              formula-reaj.dat-indic[3] with frame {&frame-name}.
    if input frame {&frame-name} formula-reaj.mo-codigo[4] = 0 then do:
       disable formula-reaj.mo-codigo[4] 
               formula-reaj.perc-reaj[4]
               formula-reaj.dat-indic[4] with frame {&frame-name}.
    end.
    else
       enable formula-reaj.mo-codigo[4] 
              formula-reaj.perc-reaj[4]
              formula-reaj.dat-indic[4] with frame {&frame-name}.
    if input frame {&frame-name} formula-reaj.mo-codigo[5] = 0 then do:
       disable formula-reaj.mo-codigo[5] 
               formula-reaj.perc-reaj[5]
               formula-reaj.dat-indic[5] with frame {&frame-name}.
    end.  
    else  
       enable formula-reaj.mo-codigo[5] 
              formula-reaj.perc-reaj[5]
              formula-reaj.dat-indic[5] with frame {&frame-name}.
  end. 
    
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /*find first param-global  no-lock no-error.*/
  find first param-contrat no-lock no-error.
  find first param-compra  no-lock no-error.
  if not avail param-compra then do:
     run utp/ut-msgs.p (input "show":U, 
                          input 2587, 
                          input "").
     return 'adm-error'.
  end.

  do with frame {&frame-name}:
     assign cb-per-reaj:list-items = {varinc/var00062.i 03}.
  end.
     
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
  disable i-nr-dias with frame {&frame-name}.
    
  {utp/ut-liter.i Moeda * C}
  assign c-tit-moeda = return-value.
  display c-tit-moeda with frame {&frame-name}.
  
  {utp/ut-liter.i Data_Öndice * C}
  assign c-tit-indice = return-value.
  display c-tit-indice with frame {&frame-name}.

  {utp/ut-liter.i %_Reajuste * C}
  assign c-tit-reaj = return-value.
  display c-tit-reaj with frame {&frame-name}.
  
  {utp/ut-liter.i Reajuste_Autom tico * C}
  assign formula-reaj.log-reajuste:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Nr_Dias * L}
  assign i-nr-dias:label in frame {&frame-name} = return-value. 
    
  {utp/ut-liter.i Pre‡o_Atual * L}
  assign de-preco:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Per¡odo_Reajuste * L}
  assign cb-per-reaj:label in frame {&frame-name} = return-value.
 
  find item-contrat where rowid(item-contrat) = v-row-parent no-lock no-error.
  if avail item-contrat then do:
     display item-contrat.nr-contrat   @ formula-reaj.nr-contrat with frame {&frame-name}.
     display item-contrat.it-codigo    @ c-it-codigo with frame {&frame-name}.
     display item-contrat.num-seq-item @ formula-reaj.num-seq-item with frame {&frame-name}.
     display item-contrat.preco-fornec @ de-preco with frame {&frame-name}.
     
     find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
     if avail contrato-for then do:
        display contrato-for.des-contrat @ c-desc-contrat with frame {&frame-name}.
     end.
     find item where item.it-codigo = item-contrat.it-codigo no-lock no-error.
     if avail item then do:
        display item.desc-item @ c-desc-item with frame {&frame-name}.  
     end.
  end.  
  
  
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     
     assign v-row-parent = v-row-parent-externo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-percentual V-table-Win 
PROCEDURE pi-calcula-percentual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign de-percent = 0.
if input frame {&frame-name} formula-reaj.mo-codigo[1] <> 0 then
  assign de-percent = de-percent + de-perc-reaj[1].
if input frame {&frame-name} formula-reaj.mo-codigo[2] <> 0 then
  assign de-percent = de-percent + de-perc-reaj[2].
if input frame {&frame-name} formula-reaj.mo-codigo[3] <> 0 then
  assign de-percent = de-percent + de-perc-reaj[3].  
if input frame {&frame-name} formula-reaj.mo-codigo[4] <> 0 then
  assign de-percent = de-percent + de-perc-reaj[4].  
if input frame {&frame-name} formula-reaj.mo-codigo[5] <> 0 then
  assign de-percent = de-percent + de-perc-reaj[5].    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  if l-inclui = no then do:
  
     if de-percent = 100 then do:       
        if input frame {&frame-name} formula-reaj.mo-codigo[1] = 0 then do:
           disable formula-reaj.mo-codigo[1] 
                   formula-reaj.perc-reaj[1]
                   formula-reaj.dat-indic[1] with frame {&frame-name}.
        end.
        else
           enable formula-reaj.mo-codigo[1] 
                  formula-reaj.perc-reaj[1]
                  formula-reaj.dat-indic[1] with frame {&frame-name}.
        
        if input frame {&frame-name} formula-reaj.mo-codigo[2] = 0 then do:
           disable formula-reaj.mo-codigo[2] 
                   formula-reaj.perc-reaj[2]
                   formula-reaj.dat-indic[2] with frame {&frame-name}.
        end.
        else
           enable formula-reaj.mo-codigo[2] 
                  formula-reaj.perc-reaj[2]
                  formula-reaj.dat-indic[2] with frame {&frame-name}.
        if input frame {&frame-name} formula-reaj.mo-codigo[3] = 0 then do:
           disable formula-reaj.mo-codigo[3] 
                   formula-reaj.perc-reaj[3]
                   formula-reaj.dat-indic[3] with frame {&frame-name}.
        end.
        else
           enable formula-reaj.mo-codigo[3] 
                  formula-reaj.perc-reaj[3]
                  formula-reaj.dat-indic[3] with frame {&frame-name}.
        if input frame {&frame-name} formula-reaj.mo-codigo[4] = 0 then do:
           disable formula-reaj.mo-codigo[4] 
                   formula-reaj.perc-reaj[4]
                   formula-reaj.dat-indic[4] with frame {&frame-name}.
        end.
        else
           enable formula-reaj.mo-codigo[4] 
                  formula-reaj.perc-reaj[4]
                  formula-reaj.dat-indic[4] with frame {&frame-name}.
        if input frame {&frame-name} formula-reaj.mo-codigo[5] = 0 then do:
           disable formula-reaj.mo-codigo[5] 
                   formula-reaj.perc-reaj[5]
                   formula-reaj.dat-indic[5] with frame {&frame-name}.
        end.  
        else  
           enable formula-reaj.mo-codigo[5] 
                  formula-reaj.perc-reaj[5]
                  formula-reaj.dat-indic[5] with frame {&frame-name}.
     end.
     else do:
        enable formula-reaj.mo-codigo[1]  
               formula-reaj.mo-codigo[2]
               formula-reaj.mo-codigo[3]
               formula-reaj.mo-codigo[4]
               formula-reaj.mo-codigo[5] with frame {&frame-name}.
     end.          
  end.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "formula-reaj"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

