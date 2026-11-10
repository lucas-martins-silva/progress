&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V02IN205 2.00.00.024} /*** "010024" 03/02/2026 16:21:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN205 MUT}
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
{cdp/cdcfgmnt.i}
/* global variable definitions */
def new global shared var  v-row-parent  as   rowid          no-undo.
def new global shared var  gr-manut      as   rowid          no-undo.
def new global shared var  gc-cd-manut   like manut.cd-manut no-undo.
def new global shared var gc-estado      as char  no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-tipo-manut    as rowid no-undo.
def new global shared var gr-causa-padrao  as rowid no-undo.
def new global shared var gr-sint-padrao   as rowid no-undo.
def new global shared var gr-interv-padrao as rowid no-undo.
def new global shared var gr-inspec        as rowid no-undo.

def var c-mot-suspensao like  manut.mot-suspensao.
def var l-flag          as log initial no.
def var i-cd-tipo-ant   like tipo-manut.cd-tipo no-undo.
def var c-tipo          as char.


DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES manut
&Scoped-define FIRST-EXTERNAL-TABLE manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS manut.cd-tipo manut.cd-causa-padr c-checklist ~
manut.cd-sint-padr manut.cd-interv-padr manut.cd-inspecao manut.tp-dia ~
manut.controle manut.faixa-utiliz manut.faixa-tempo manut.situacao ~
manut.possui-checklist manut.codigo-checklist
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-tipo ~{&FP2}cd-tipo ~{&FP3}~
 ~{&FP1}cd-causa-padr ~{&FP2}cd-causa-padr ~{&FP3}~
 ~{&FP1}cd-sint-padr ~{&FP2}cd-sint-padr ~{&FP3}~
 ~{&FP1}cd-interv-padr ~{&FP2}cd-interv-padr ~{&FP3}~
 ~{&FP1}cd-inspecao ~{&FP2}cd-inspecao ~{&FP3}~
 ~{&FP1}faixa-utiliz ~{&FP2}faixa-utiliz ~{&FP3}~
 ~{&FP1}faixa-tempo ~{&FP2}faixa-tempo ~{&FP3}
&Scoped-define ENABLED-TABLES manut
&Scoped-define FIRST-ENABLED-TABLE manut
&Scoped-Define ENABLED-OBJECTS RECT-59 rt-mold RECT-58 RECT-61 RECT-60 ~
RECT-62 
&Scoped-Define DISPLAYED-FIELDS manut.cd-tipo manut.cd-causa-padr ~
manut.cd-sint-padr manut.cd-interv-padr manut.cd-inspecao manut.tp-dia ~
manut.controle manut.faixa-utiliz manut.faixa-tempo manut.situacao ~
manut.possui-checklist manut.codigo-checklist c-checklist 
&Scoped-define DISPLAYED-TABLES manut
&Scoped-define FIRST-DISPLAYED-TABLE manut
&Scoped-Define DISPLAYED-OBJECTS c-descr-manut c-descr-causa c-descr-sint ~
c-descr-interv c-descr-inspec rs-urgencia c-descr-checklist c-tp-dia ~
c-controle c-situacao c-urgencia c-checklist 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS rs-urgencia 

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
DEFINE VARIABLE c-checklist AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .54 NO-UNDO.

DEFINE VARIABLE c-controle AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .54 NO-UNDO.

DEFINE VARIABLE c-descr-causa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-checklist AS CHARACTER FORMAT "X(200)":U 
     VIEW-AS FILL-IN 
     SIZE 63.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-inspec AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-interv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-sint AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 15.86 BY .54 NO-UNDO.

DEFINE VARIABLE c-tp-dia AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .54 NO-UNDO.

DEFINE VARIABLE c-urgencia AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 16.29 BY .54 NO-UNDO.

DEFINE VARIABLE rs-urgencia AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          " ", 1,
" ", 2,
" ", 3
     SIZE 57.43 BY 1.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.14 BY 3.08.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.75.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.29 BY 1.29.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.29.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 2.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 13.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     manut.cd-tipo AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-descr-manut AT ROW 1.17 COL 33 COLON-ALIGNED NO-LABEL
     manut.cd-causa-padr AT ROW 2.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-causa AT ROW 2.17 COL 33 COLON-ALIGNED NO-LABEL
     manut.cd-sint-padr AT ROW 3.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-sint AT ROW 3.17 COL 33 COLON-ALIGNED NO-LABEL
     manut.cd-interv-padr AT ROW 4.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-interv AT ROW 4.17 COL 33 COLON-ALIGNED NO-LABEL
     manut.cd-inspecao AT ROW 5.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-inspec AT ROW 5.17 COL 33 COLON-ALIGNED NO-LABEL
     manut.tp-dia AT ROW 6.63 COL 3.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Util", 1,
"Corrido", 2
          SIZE 18.57 BY .92
     manut.controle AT ROW 6.96 COL 26.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Faixa Tempo", 1,
"Utiliz Equipto", 2,
"Ambos", 3
          SIZE 57.14 BY .71
     manut.faixa-utiliz AT ROW 8 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     manut.faixa-tempo AT ROW 8.08 COL 38.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .83
     manut.situacao AT ROW 8.58 COL 3.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ativa", 1,
"Suspensa", 2,
"Eliminada", 3
          SIZE 16.29 BY 2.42
     rs-urgencia AT ROW 10 COL 27 NO-LABEL
     manut.possui-checklist AT ROW 12 COL 4.14 WIDGET-ID 6
          LABEL "Possui Checklist?"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     manut.codigo-checklist AT ROW 13 COL 8.43 COLON-ALIGNED WIDGET-ID 8
          LABEL "Checklist"
          FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-descr-checklist AT ROW 13 COL 19.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-tp-dia AT ROW 6.04 COL 1.57 COLON-ALIGNED NO-LABEL
     c-controle AT ROW 6.21 COL 26.29 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 7.71 COL 1.72 COLON-ALIGNED NO-LABEL
     c-urgencia AT ROW 9.54 COL 26 COLON-ALIGNED NO-LABEL
     c-checklist AT ROW 11.25 COL 1.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     RECT-59 AT ROW 6.38 COL 25.72
     rt-mold AT ROW 1 COL 1
     RECT-58 AT ROW 8 COL 2.57
     RECT-61 AT ROW 9.79 COL 25.86
     RECT-60 AT ROW 6.33 COL 2.43
     RECT-62 AT ROW 11.5 COL 2.57 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.manut
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 13.67
         WIDTH              = 85.72.
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




/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-checklist IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-controle IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-checklist IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-inspec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-interv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-sint IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-urgencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN manut.codigo-checklist IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX manut.possui-checklist IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       RECT-61:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-urgencia IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       rs-urgencia:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME manut.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-causa-padr V-table-Win
ON F5 OF manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                  &tabela=manut
                  &atributo=cd-causa-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-causa-padr V-table-Win
ON LEAVE OF manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} manut.cd-causa-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.cd-inspecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-inspecao V-table-Win
ON F5 OF manut.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in458.w"
                   &tabela=manut
                   &atributo=cd-inspecao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-inspecao V-table-Win
ON LEAVE OF manut.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
   {include/leave.i &tabela=inspec
                    &atributo-ref=descricao
                    &variavel-ref=c-descr-inspec
                    &where="inspec.cd-inspecao = input frame {&frame-name} 
                                                 manut.cd-inspecao"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-inspecao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-interv-padr V-table-Win
ON F5 OF manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                  &tabela=manut
                  &atributo=cd-interv-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-interv-padr V-table-Win
ON LEAVE OF manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name} manut.cd-interv-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-sint-padr V-table-Win
ON F5 OF manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                  &tabela=manut
                  &atributo=cd-sint-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-sint-padr V-table-Win
ON LEAVE OF manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
  {include/leave.i &tabela=sint-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-sint
                   &where="sint-padrao.cd-sint-padr = input frame {&frame-name} manut.cd-sint-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-tipo V-table-Win
ON ENTRY OF manut.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  &if defined (bf_mnt_ems204) &then 
      if adm-new-record = no then
            assign c-tipo = manut.cd-tipo:screen-value in frame {&frame-name}.   
  &endif


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-tipo V-table-Win
ON F5 OF manut.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in434.w"
                  &tabela=manut
                  &atributo=cd-tipo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-tipo V-table-Win
ON LEAVE OF manut.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  {include/leave.i 
      &tabela=tipo-manut
      &atributo-ref=descricao
      &variavel-ref=c-descr-manut
      &where="tipo-manut.cd-tipo = input frame {&frame-name} manut.cd-tipo"}

  &if defined (bf_mnt_ems204) &then 
      if adm-new-record or 
         c-tipo <> manut.cd-tipo:screen-value then
         if avail tipo-manut then
            assign rs-urgencia:screen-value = string(tipo-manut.urgencia).   
  &endif

  if  avail tipo-manut then do:
      assign i-cd-tipo-ant = int(manut.cd-tipo:screen-value in frame {&frame-name}).
      if  tipo-manut.tp-manut <> 10 then do:
          disable manut.cd-inspecao with frame {&frame-name}.
          assign  manut.cd-inspecao:screen-value in frame {&frame-name}  =  " " .
          assign  c-descr-inspec:screen-value in frame {&frame-name}  =  " " .
      end.
      else 
          enable manut.cd-inspecao with frame {&frame-name}.
  end.
  else do:
      assign  manut.cd-inspecao:screen-value in frame {&frame-name}  =  " " .
      assign  c-descr-inspec:screen-value in frame {&frame-name}  =  " " .
      disable manut.cd-inspecao with frame {&frame-name}.
  end.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-tipo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.controle V-table-Win
ON VALUE-CHANGED OF manut.controle IN FRAME f-main /* Ct */
DO:
  case input frame {&frame-name} manut.controle:
     when 1 then DO:
         disable manut.faixa-utiliz with frame {&frame-name}.
         enable  manut.tp-dia manut.faixa-tempo  with frame {&frame-name}.
         assign  manut.faixa-utiliz:screen-value = "0".
         apply 'entry' to manut.faixa-tempo.
     end.
     when 2 then DO:
         disable manut.faixa-tempo manut.tp-dia with frame {&frame-name}.     
         enable  manut.faixa-utiliz with frame {&frame-name}.
         assign  manut.faixa-tempo:screen-value = "0"
                 manut.tp-dia:screen-value      = "1".
         apply 'entry' to manut.faixa-utiliz.
     end.
     when 3 then DO:
         enable  manut.faixa-tempo manut.faixa-utiliz manut.tp-dia 
                 with frame {&frame-name}.
         apply 'entry' to manut.faixa-tempo.
     end. 
  end case.  
  /*if avail manut then
     disp manut.faixa-utiliz 
          manut.tp-dia               
          manut.faixa-tempo  
          with frame {&frame-name}. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.codigo-checklist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.codigo-checklist V-table-Win
ON F5 OF manut.codigo-checklist IN FRAME f-main /* Checklist */
DO:
    {method/zoomfields.i 
        &ProgramZoom="mnzoom/z01mn00321.w"  
        &FieldZoom1="codigo" 
        &FieldScreen1="manut.codigo-checklist"
        &Frame1="f-main"
        &EnableImplant="NO"}
                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.codigo-checklist V-table-Win
ON LEAVE OF manut.codigo-checklist IN FRAME f-main /* Checklist */
DO:
                    
   FOR EACH checklist-modelos NO-LOCK
       WHERE checklist-modelos.codigo = input frame {&frame-name} manut.codigo-checklist
          BY checklist-modelos.versao DESC:
          
          ASSIGN c-descr-checklist:SCREEN-VALUE IN frame {&frame-name} = checklist-modelos.descricao.
          LEAVE.
    END.
          
    IF NOT AVAIL checklist-modelos THEN
        ASSIGN c-descr-checklist:SCREEN-VALUE IN frame {&frame-name} = "".  

                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.codigo-checklist V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.codigo-checklist IN FRAME f-main /* Checklist */
DO:
  APPLY 'F5' TO SELF.
END.



&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if  manut.cd-tipo:load-mouse-pointer        ("image/lupa.cur") in frame {&frame-name} then.
  if  manut.cd-causa-padr:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  if  manut.cd-sint-padr:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if  manut.cd-interv-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if  manut.cd-inspecao:load-mouse-pointer    ("image/lupa.cur") in frame {&frame-name} then.      
  if  manut.codigo-checklist:load-mouse-pointer    ("image/lupa.cur") in frame {&frame-name} then.      

  { utp/ut-rtlbl.i mgind manut situacao c-situacao }
  { utp/ut-rtlbl.i mgind manut controle c-controle }
  { utp/ut-rtlbl.i mgind manut tp-dia   c-tp-dia }
  &if defined (bf_mnt_ems204)&then
  { utp/ut-rtlbl.i mgind manut urgencia c-urgencia }
  &endif.
  {utp/ut-liter.i "CheckList"}
  ASSIGN c-checklist = RETURN-VALUE.


  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.possui-checklist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.possui-checklist V-table-Win
ON VALUE-CHANGED OF manut.possui-checklist IN FRAME f-main /* Possui Checklist? */
DO:
  /* HABILITA /DESABILITA */
  IF  INPUT FRAME {&frame-name} manut.possui-checklist = NO THEN DO:
      ASSIGN manut.codigo-checklist:SCREEN-VALUE IN FRAME {&frame-name} = ""
             c-descr-checklist:SCREEN-VALUE IN FRAME {&frame-name} = "".
      DISABLE manut.codigo-checklist WITH FRAME {&frame-name}.
  END.
  ELSE DO:
      ENABLE manut.codigo-checklist WITH FRAME {&frame-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 



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
  {src/adm/template/row-list.i "manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "manut"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  { utp/ut-rtlbl.i mgind manut situacao c-situacao }
  { utp/ut-rtlbl.i mgind manut controle c-controle }
  { utp/ut-rtlbl.i mgind manut tp-dia   c-tp-dia } 
  &if defined (bf_mnt_ems204) &then
    { utp/ut-rtlbl.i mgind manut urgencia c-urgencia }
  &endif.
  {utp/ut-liter.i "CheckList"}
  ASSIGN c-checklist = RETURN-VALUE.
  
  CASE input frame {&frame-name}  manut.controle:
     when 1 then DO:
         disable manut.faixa-utiliz with frame {&frame-name}.
         enable  manut.tp-dia       
                 manut.faixa-tempo  with frame {&frame-name}.
     end.
     when 2 then DO:
         disable manut.faixa-tempo  
                 manut.tp-dia       with frame {&frame-name}.     
         enable  manut.faixa-utiliz with frame {&frame-name}.
     end.
     when 3 then DO:
         enable  manut.faixa-tempo  
                 manut.faixa-utiliz 
                 manut.tp-dia       with frame {&frame-name}.
    end. 
  END CASE.  
    
  /* HABILITA /DESABILITA */
  IF  INPUT FRAME {&frame-name} manut.possui-checklist = NO THEN DO:
      ASSIGN manut.codigo-checklist:SCREEN-VALUE   = ""
             c-descr-checklist:SCREEN-VALUE    = "".
      DISABLE manut.codigo-checklist WITH FRAME {&frame-name}.
  END.
  ELSE DO:
      ENABLE manut.codigo-checklist WITH FRAME {&frame-name}.
  END.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e nem na PI-validate. */

  /*testa se a situaá∆o sofreu alteraá∆o entre o registro anterior e o atual*/
  /*se sofreu e Ç suspensa entao pede o motivo, se n∆o Ç suspensa grava branco*/


  if  avail manut and manut.situacao <> int(manut.situacao:screen-value in frame {&frame-name}) then do:
     if  int(manut.situacao:screen-value in frame {&frame-name}) = 2 then do:
         run mip/mi0110b.w ( input-output  c-mot-suspensao ).
     end.
     else
        assign c-mot-suspensao = " ".
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if RETURN-VALUE = 'ADM-ERROR':U then 
    RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  if avail manut then do:
     ASSIGN  manut.mot-suspensao = c-mot-suspensao.   /* IMPORTANTE */
    &if defined (bf_mnt_ems204) &then 
            assign  manut.urgencia = input frame {&frame-name} rs-urgencia.
    &endif
  end.     

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
 &if  defined(ADM-MODIFY-FIELDS) &then
       &if defined(bf_mnt_ems204) &then
           disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &endif
  &endif

 RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

   if  available manut then do:
        find tipo-manut
            where tipo-manut.cd-tipo = manut.cd-tipo
            no-lock no-error.
        assign c-descr-manut = if avail tipo-manut then tipo-manut.descricao else "":U
               gr-tipo-manut = if avail tipo-manut then rowid(tipo-manut)    else ?
               i-cd-tipo-ant = if avail tipo-manut then tipo-manut.cd-tipo   else 0.

        find causa-padrao
            where causa-padrao.cd-causa-padr = manut.cd-causa-padr
            no-lock no-error.
        assign c-descr-causa   = if avail causa-padrao then causa-padrao.descricao else "":U
               gr-causa-padrao = if avail causa-padrao then rowid(causa-padrao)   else ?.
        find sint-padrao
            where sint-padrao.cd-sint-padr = manut.cd-sint-padr
            no-lock no-error.
        assign c-descr-sint   = if  avail sint-padrao then sint-padrao.descricao else "":U
               gr-sint-padrao = if avail sint-padrao then rowid(sint-padrao)     else ?.
        find interv-padrao
            where interv-padrao.cd-interv-padr = manut.cd-interv-padr
            no-lock no-error.
        assign c-descr-interv   = if avail interv-padrao then interv-padrao.descricao else "":U
               gr-interv-padrao = if avail interv-padrao then rowid(interv-padrao)    else ?.
        find inspec
            where inspec.cd-inspecao = manut.cd-inspecao
            no-lock no-error.
        assign c-descr-inspec = if avail inspec then inspec.descricao else "":U
               gr-inspec      = if avail inspec then rowid(inspec)    else ?.
               
        ASSIGN c-descr-checklist = "".
        FOR FIRST checklist-modelos FIELDS (id descricao)
            WHERE checklist-modelos.codigo = manut.codigo-checklist NO-LOCK:
            ASSIGN c-descr-checklist = checklist-modelos.descricao.
        END.
               
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
   &if  defined(ADM-MODIFY-FIELDS) &then
       &if defined(bf_mnt_ems204) &then
           enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &endif
  &endif
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if gc-estado = "Modifica"  then do:
     if can-find (first ord-manut where ord-manut.cd-manut = manut.cd-manut) then
        disable manut.controle  with frame {&frame-name}.   
     else
        enable  manut.cd-tipo
                manut.controle  with frame {&frame-name}.
  end.

  do with frame {&frame-name}:
    if manut.controle:screen-value = '1' then do:
           disable manut.faixa-utiliz with frame {&frame-name}.
           enable  manut.faixa-tempo  
                   manut.tp-dia       with frame {&frame-name}.         
    end.
    if manut.controle:screen-value = '2' then do:  
           disable manut.faixa-tempo 
                   manut.tp-dia       with frame {&frame-name}.     
           enable  manut.faixa-utiliz with frame {&frame-name}.    
    end.
    if manut.controle:screen-value = '3' then 
           enable  manut.faixa-tempo 
                   manut.faixa-utiliz 
                   manut.tp-dia       with frame {&frame-name}.       

  end.


  find first tipo-manut where tipo-manut.cd-tipo =  manut.cd-tipo no-lock no-error.

  if  avail tipo-manut then do:
      if  tipo-manut.tp-manut <> 10 then do:
          disable manut.cd-inspecao with frame {&frame-name}.
          assign manut.cd-inspecao:screen-value in frame {&frame-name}  =  " "
                 c-descr-inspec:screen-value    in frame {&frame-name}  =  " " .
      end.
  end.
  else do:
      disable manut.cd-inspecao with frame {&frame-name}.
      assign manut.cd-inspecao:screen-value in frame {&frame-name}  =  " "
             c-descr-inspec:screen-value    in frame {&frame-name}  =  " " .
  end.
  
  
  APPLY "VALUE-CHANGED" TO manut.possui-checklist.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if gr-manut <> ? then do:
     find manut where rowid(manut) = gr-manut no-lock  no-error.
     if not avail manut then
        find first manut no-lock  no-error.
     if avail manut then
        assign gr-manut     = rowid(manut)
               v-row-parent = rowid(manut).
     else
        assign gr-manut     = ?
               v-row-parent = ?.
   end.
   else do:
      find first manut no-lock  no-error.
      if avail manut then
         assign gr-manut     = rowid(manut)
                v-row-parent = rowid(manut).
      else
         assign gr-manut     = ?
                v-row-parent = ? .
   end.
  &if defined (bf_mnt_ems204) &then
   assign rs-urgencia:hidden in frame {&frame-name} = no
          rect-61:hidden in frame {&frame-name}     = no  
          rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  &endif.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

 /* Code placed here will execute AFTER standard behavior.    */
  assign c-mot-suspensao = if avail manut then manut.mot-suspensao else "":U.
  &if defined(bf_mnt_ems204) &then
  if avail manut then
      assign rs-urgencia:screen-value in frame {&frame-name} = 
             string(manut.urgencia).
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */



  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dado-inicial V-table-Win 
PROCEDURE pi-dado-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter r-grup-manut as rowid.
  find grup-manut where rowid (grup-manut) = r-grup-manut EXCLUSIVE-LOCK NO-ERROR.
  assign 
     manut.controle:screen-value      in frame {&frame-name} = string(grup-manut.controle)
     manut.cd-causa-padr:screen-value in frame {&frame-name} = string(grup-manut.cd-causa-padr) .

  IF gc-estado = "inclui" THEN DO:
      ASSIGN manut.faixa-tempo:screen-value   in frame {&frame-name} = string(grup-manut.faixa-tempo)
             manut.faixa-utiliz:screen-value  in frame {&frame-name} = string(grup-manut.faixa-utiliz).
  END.

  {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} 
                                                        manut.cd-causa-padr"}

  case input frame {&frame-name}  manut.controle:
     when 1 then DO:
         disable manut.faixa-utiliz with frame {&frame-name}.
         enable  manut.tp-dia       with frame {&frame-name}.         
         enable  manut.faixa-tempo  with frame {&frame-name}.
     end.

     when 2 then DO:
         disable manut.faixa-tempo  with frame {&frame-name}.
         disable manut.tp-dia       with frame {&frame-name}.     
         enable  manut.faixa-utiliz with frame {&frame-name}.
     end.

     when 3 then DO:
         enable  manut.faixa-tempo  with frame {&frame-name}.
         enable  manut.faixa-utiliz with frame {&frame-name}.
         enable  manut.tp-dia       with frame {&frame-name}.
     end. 
  end case.

  find first ord-manut where ord-manut.cd-manut = gc-cd-manut no-lock no-error.
  if avail ord-manut and gc-estado = "Modifica" then do:
     disable manut.cd-tipo  with frame {&frame-name}.
  end.
  else 
     enable  manut.cd-tipo  with frame {&frame-name} .

  find first tipo-manut where tipo-manut.cd-tipo =  manut.cd-tipo no-lock no-error.
  if  avail tipo-manut then do: 
      if  tipo-manut.tp-manut <> 10 then do:
          disable manut.cd-inspecao with frame {&frame-name}.
          assign manut.cd-inspecao:screen-value in frame {&frame-name}  =  " "
                 c-descr-inspec:screen-value    in frame {&frame-name}  =  " " .
      end.
      else 
          enable manut.cd-inspecao with frame {&frame-name}.
  end.
  else do:
      disable manut.cd-inspecao with frame {&frame-name}.
      assign manut.cd-inspecao:screen-value in frame {&frame-name}  =  " "
             c-descr-inspec:screen-value    in frame {&frame-name}  =  " " .
  end.

  if input frame {&frame-name} manut.cd-inspecao <> "" then do:

     {include/leave.i 
        &tabela=inspec
        &atributo-ref=descricao
        &variavel-ref=c-descr-inspec
        &where="inspec.cd-inspecao = input frame {&frame-name} manut.cd-inspecao"}

  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/


/*tipo-manut*/
  if  manut.cd-tipo:sensitive in frame {&frame-name} = yes  and
  not can-find ( tipo-manut where tipo-manut.cd-tipo = input frame {&frame-name} manut.cd-tipo )
  then do: 
      {utp/ut-table.i mgind tipo-manut 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to manut.cd-tipo.
      return 'ADM-ERROR'.
  end.


/*causa-padrao*/
  if  manut.cd-causa-padr:sensitive in frame {&frame-name} = yes 
  and input frame {&frame-name} manut.cd-causa-padr  <>  "" 
  and not can-find (first causa-padrao where causa-padrao.cd-causa-padr = input frame {&frame-name} manut.cd-causa-padr)
  then do: 
      {utp/ut-table.i mgind causa-padrao 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to manut.cd-causa-padr.
      return 'ADM-ERROR'.
  end.


/*sint-padrao*/
  if  manut.cd-sint-padr:sensitive in frame {&frame-name} = yes 
  and input frame {&frame-name} manut.cd-sint-padr <> "" 
  and not can-find (first sint-padrao where sint-padrao.cd-sint-padr = input frame {&frame-name} manut.cd-sint-padr)
  then do: 
      {utp/ut-table.i mgind sint-padrao 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to manut.cd-sint-padr.
      return 'ADM-ERROR'.
  end.


/*interv-padrao*/
  if  manut.cd-interv-padr:sensitive in frame {&frame-name} = yes 
  and input frame {&frame-name} manut.cd-interv-padr <> "" 
  and not can-find (first interv-padrao where interv-padrao.cd-interv-padr = input frame {&frame-name} manut.cd-interv-padr)
  then do: 
      {utp/ut-table.i mgind interv-padrao 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to manut.cd-interv-padr.
      return 'ADM-ERROR'.
  end.


/*inspecao*/
  find first tipo-manut where tipo-manut.cd-tipo =  input frame {&frame-name}
                                   manut.cd-tipo  no-lock  no-error.
  if avail tipo-manut and tipo-manut.tp-manut = 10 then do:
     if  manut.cd-inspecao:sensitive in frame {&frame-name} = yes 
     and input frame {&frame-name} manut.cd-inspecao = "" 
     and not can-find (first inspec where inspec.cd-inspecao = input frame {&frame-name} manut.cd-inspecao)
     then do: 
         {utp/ut-table.i mgind inspec 1}
         {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
         run utp/ut-msgs.p(input "show",
                           input 2,
                           input return-value).
         apply 'entry' to manut.cd-inspecao.
         return 'ADM-ERROR'.
     end.
  end.
  
/*Checklist*/
  IF  INPUT FRAME {&frame-name} manut.possui-checklist = YES THEN DO:
      IF  NOT CAN-FIND (FIRST checklist-modelos WHERE checklist-modelos.codigo = INPUT FRAME {&frame-name} manut.codigo-checklist) THEN DO: 
      /*    {utp/ut-table.i mgmnt checklist-modelos 1}*/
          {utp/ut-liter.i "CheckList"}
          {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 2,
                             INPUT RETURN-VALUE).
          APPLY 'entry' TO  manut.codigo-checklist.
          RETURN 'ADM-ERROR'.
      END.
  END.

/* Validaá∆o da Faixa de Tempo e da Faixa de utilizaá∆o */
  case input frame {&frame-name} manut.controle:
     when 1 then 
        if  input frame {&frame-name} manut.faixa-tempo = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19353,
                              input " ").

            apply 'entry' to manut.faixa-tempo.
            return 'ADM-ERROR'.
        end.
     when 2 then 
        if  input frame {&frame-name} manut.faixa-utiliz = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19354,
                              input " ").
            apply 'entry' to manut.faixa-utiliz.
            return 'ADM-ERROR'.
        end.        
     when 3 then DO:
        if  input frame {&frame-name} manut.faixa-tempo = 0 then do:
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19355,
                              input " ").
            apply 'entry' to manut.faixa-tempo.
            return 'ADM-ERROR'.
        end.
        if  input frame {&frame-name} manut.faixa-utiliz = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19355,
                              input " ").            
            apply 'entry' to manut.faixa-utiliz.
            return 'ADM-ERROR'.            
        end.     
     end.    
  end case.
  RUN set-attribute-list IN adm-broker-hdl('update-type = no').
  IF gc-estado = 'Modifica' then        
     if manut.cd-tipo <> i-cd-tipo-ant and
        can-find(first ord-manut where
        ord-manut.cd-manut = manut.cd-manut) then do:
        {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
        run utp/ut-msgs.p(input "show",
                          input 19361,
                          input " ").            
        if return-value = 'no' then do:
           RUN set-attribute-list IN adm-broker-hdl('update-type = no').
           apply 'entry' to manut.cd-tipo in frame {&frame-name}.
           return 'ADM-ERROR'.            
       end.
       else
          RUN set-attribute-list IN adm-broker-hdl('update-type = yes').

     end.   
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
  {src/adm/template/snd-list.i "manut"}

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




