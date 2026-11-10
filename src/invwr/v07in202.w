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
{include/i-prgvrs.i V07IN202 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN202 MUT}
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
   def new global shared var v-row-parent as rowid  no-undo.
   def new global shared var gr-man-equip as rowid  no-undo.        
   

/* Parameters Definitions ---                                           */

def temp-table tt-manut like manut.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-equip
&Scoped-define FIRST-EXTERNAL-TABLE man-equip


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-equip.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-equip.cd-tipo man-equip.cd-causa-padr ~
man-equip.cd-sint-padr man-equip.cd-interv-padr man-equip.cd-inspecao ~
man-equip.controle man-equip.tp-dia man-equip.faixa-utiliz ~
man-equip.faixa-tempo man-equip.situacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-tipo ~{&FP2}cd-tipo ~{&FP3}~
 ~{&FP1}cd-causa-padr ~{&FP2}cd-causa-padr ~{&FP3}~
 ~{&FP1}cd-sint-padr ~{&FP2}cd-sint-padr ~{&FP3}~
 ~{&FP1}cd-interv-padr ~{&FP2}cd-interv-padr ~{&FP3}~
 ~{&FP1}cd-inspecao ~{&FP2}cd-inspecao ~{&FP3}~
 ~{&FP1}faixa-utiliz ~{&FP2}faixa-utiliz ~{&FP3}~
 ~{&FP1}faixa-tempo ~{&FP2}faixa-tempo ~{&FP3}
&Scoped-define ENABLED-TABLES man-equip
&Scoped-define FIRST-ENABLED-TABLE man-equip
&Scoped-Define ENABLED-OBJECTS RECT-21 p-urgencia RECT-19 rt-mold RECT-20 ~
rs-urgencia 
&Scoped-Define DISPLAYED-FIELDS man-equip.cd-tipo man-equip.cd-causa-padr ~
man-equip.cd-sint-padr man-equip.cd-interv-padr man-equip.cd-inspecao ~
man-equip.controle man-equip.tp-dia man-equip.faixa-utiliz ~
man-equip.faixa-tempo man-equip.situacao 
&Scoped-Define DISPLAYED-OBJECTS c-descr-manut c-descr-causa c-descr-sint ~
c-descr-interv c-descr-inspec rs-urgencia c-tp-dia c-tipo c-situacao ~
c-urgencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS man-equip.cd-tipo man-equip.cd-causa-padr ~
man-equip.cd-sint-padr man-equip.cd-interv-padr man-equip.cd-inspecao ~
man-equip.controle man-equip.tp-dia man-equip.faixa-utiliz ~
man-equip.faixa-tempo man-equip.situacao 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cd-causa-padr||y|mgind.man-equip.cd-causa-padr
cd-equipto||y|mgind.man-equip.cd-equipto
cd-interv-padr||y|mgind.man-equip.cd-interv-padr
cd-manut||y|mgind.man-equip.cd-manut
cd-parada||y|mgind.man-equip.cd-parada
cd-pend-padr||y|mgind.man-equip.cd-pend-padr
cd-sint-padr||y|mgind.man-equip.cd-sint-padr
cd-tipo||y|mgind.man-equip.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cd-causa-padr,cd-equipto,cd-interv-padr,cd-manut,cd-parada,cd-pend-padr,cd-sint-padr,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descr-causa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-inspec AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-interv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-sint AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 15.14 BY .63 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 29 BY .63 NO-UNDO.

DEFINE VARIABLE c-tp-dia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 14.57 BY .63 NO-UNDO.

DEFINE VARIABLE c-urgencia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .63 NO-UNDO.

DEFINE VARIABLE rs-urgencia AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          " ", 1,
" ", 2,
" ", 3
     SIZE 56.72 BY .96 NO-UNDO.

DEFINE RECTANGLE p-urgencia
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.86 BY 1.46.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.86 BY 3.04.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 2.71.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.57 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-equip.cd-tipo AT ROW 1.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-descr-manut AT ROW 1.17 COL 40 COLON-ALIGNED NO-LABEL
     man-equip.cd-causa-padr AT ROW 2.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-causa AT ROW 2.17 COL 40 COLON-ALIGNED NO-LABEL
     man-equip.cd-sint-padr AT ROW 3.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-sint AT ROW 3.17 COL 40 COLON-ALIGNED NO-LABEL
     man-equip.cd-interv-padr AT ROW 4.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-interv AT ROW 4.17 COL 40 COLON-ALIGNED NO-LABEL
     man-equip.cd-inspecao AT ROW 5.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-inspec AT ROW 5.17 COL 40 COLON-ALIGNED NO-LABEL
     man-equip.controle AT ROW 6.92 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Faixa Tempo", 1,
"Utiliz Equipto", 2,
"Ambos", 3
          SIZE 57 BY .79
     man-equip.tp-dia AT ROW 6.96 COL 4.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Util", 1,
"Corrido", 2
          SIZE 19.72 BY .75
     man-equip.faixa-utiliz AT ROW 8.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     man-equip.faixa-tempo AT ROW 8.25 COL 39.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     man-equip.situacao AT ROW 8.58 COL 2.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ativa", 1,
"Suspensa", 2,
"Eliminada", 3
          SIZE 20 BY 2.58
     rs-urgencia AT ROW 10.13 COL 27.43 NO-LABEL
     c-tp-dia AT ROW 6.38 COL 1.14 COLON-ALIGNED NO-LABEL
     c-tipo AT ROW 6.38 COL 26 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 8.08 COL 2.86 NO-LABEL
     c-urgencia AT ROW 9.5 COL 26 COLON-ALIGNED NO-LABEL
     RECT-21 AT ROW 6.71 COL 2.14
     p-urgencia AT ROW 9.83 COL 26.29
     RECT-19 AT ROW 8.29 COL 1.86
     rt-mold AT ROW 1 COL 1
     RECT-20 AT ROW 6.67 COL 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-equip
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.67
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
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

/* SETTINGS FOR FILL-IN c-descr-causa IN FRAME f-main
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
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-urgencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-equip.cd-causa-padr IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.cd-inspecao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.cd-interv-padr IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.cd-sint-padr IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.cd-tipo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR RADIO-SET man-equip.controle IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.faixa-tempo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN man-equip.faixa-utiliz IN FRAME f-main
   2                                                                    */
ASSIGN 
       p-urgencia:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       rs-urgencia:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET man-equip.situacao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR RADIO-SET man-equip.tp-dia IN FRAME f-main
   2                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME man-equip.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-causa-padr V-table-Win
ON F5 OF man-equip.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                   &tabela=man-equip
                   &atributo=cd-causa-padr}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-causa-padr V-table-Win
ON LEAVE OF man-equip.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} 
                                                        man-equip.cd-causa-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-causa-padr IN FRAME f-main /* Causa */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-inspecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-inspecao V-table-Win
ON F5 OF man-equip.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in458.w"
                   &tabela=man-equip
                   &atributo=cd-inspecao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-inspecao V-table-Win
ON LEAVE OF man-equip.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
   {include/leave.i &tabela=inspec
                    &atributo-ref=descricao
                    &variavel-ref=c-descr-inspec
                    &where="inspec.cd-inspecao = input frame {&frame-name} 
                                                 man-equip.cd-inspecao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-inspecao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-inspecao IN FRAME f-main /* Inspeá∆o */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-interv-padr V-table-Win
ON F5 OF man-equip.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                    &tabela=man-equip
                    &atributo=cd-interv-padr}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-interv-padr V-table-Win
ON LEAVE OF man-equip.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
   {include/leave.i &tabela=interv-padrao
                    &atributo-ref=descricao
                    &variavel-ref=c-descr-interv
                    &where="interv-padrao.cd-interv-padr = input frame {&frame-name} 
                                                           man-equip.cd-interv-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-sint-padr V-table-Win
ON F5 OF man-equip.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                   &tabela=man-equip
                   &atributo=cd-sint-padr}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-sint-padr V-table-Win
ON LEAVE OF man-equip.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   {include/leave.i &tabela=sint-padrao
                    &atributo-ref=descricao
                    &variavel-ref=c-descr-sint
                    &where="sint-padrao.cd-sint-padr = input frame {&frame-name} 
                                                       man-equip.cd-sint-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-tipo V-table-Win
ON LEAVE OF man-equip.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  {include/leave.i &tabela=tipo-manut
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-manut
                   &where="tipo-manut.cd-tipo = input frame {&frame-name} 
                                                man-equip.cd-tipo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  if  man-equip.cd-tipo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-equip.cd-causa-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-equip.cd-sint-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-equip.cd-interv-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-equip.cd-inspecao:load-mouse-pointer ("image/lupa.cur")  in frame {&frame-name} 
      then.      

  { utp/ut-rtlbl.i mgind man-equip situacao c-situacao }
  { utp/ut-rtlbl.i mgind man-equip controle c-tipo }
  { utp/ut-rtlbl.i mgind man-equip tp-dia c-tp-dia }
&if defined (bf_mnt_ems204) &then
  { utp/ut-rtlbl.i mgind man-equip urgencia c-urgencia }
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "man-equip"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-equip"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mnt_ems204) &then
assign input frame {&frame-name} rs-urgencia.
&endif

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  
  
  /* Ponha aqui as demais validaá‰es */
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Code placed here will execute AFTER standard behavior.    */

&if defined (bf_mnt_ems204) &then
assign man-equip.urgencia = input frame {&FRAME-NAME} rs-urgencia.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  find man-equip where rowid(man-equip)  =  gr-man-equip  no-lock  no-error. 
  
  if  available man-equip then do:
      find tipo-manut where tipo-manut.cd-tipo = man-equip.cd-tipo no-lock no-error.
      assign c-descr-manut = if  avail tipo-manut then tipo-manut.descricao else "":U.
      disp c-descr-manut with frame {&frame-name}.     
      
      find causa-padrao where causa-padrao.cd-causa-padr = man-equip.cd-causa-padr no-lock no-error.
      assign c-descr-causa = if  avail causa-padrao then causa-padrao.descricao else "":U.
      disp c-descr-causa with frame {&frame-name}.     
      
      find sint-padrao where sint-padrao.cd-sint-padr = man-equip.cd-sint-padr no-lock no-error.
      assign c-descr-sint = if  avail sint-padrao then sint-padrao.descricao else "":U.
      disp c-descr-sint with frame {&frame-name}.
  
      find interv-padrao where interv-padrao.cd-interv-padr = man-equip.cd-interv-padr no-lock no-error.
      assign c-descr-interv = if  avail interv-padrao then interv-padrao.descricao else "":U.
      disp c-descr-interv with frame {&frame-name}.
      
      find inspec where inspec.cd-inspecao = man-equip.cd-inspecao no-lock no-error.                    
      assign c-descr-inspec = if  avail inspec then inspec.descricao else "":U.
      disp c-descr-inspec with frame {&frame-name}.
  end.  



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 
  
  /* Code placed here will execute AFTER standard behavior.    */
  { utp/ut-rtlbl.i mgind man-equip situacao c-situacao }
  { utp/ut-rtlbl.i mgind man-equip controle c-tipo }
  { utp/ut-rtlbl.i mgind man-equip tp-dia c-tp-dia }
  

         
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif  

   case input frame {&frame-name}  man-equip.controle:
     when 1 then DO:
         disable man-equip.faixa-utiliz with frame {&frame-name}.
         enable  man-equip.tp-dia       with frame {&frame-name}.         
         enable  man-equip.faixa-tempo  with frame {&frame-name}.
     end.
     
     when 2 then DO:
         disable man-equip.faixa-tempo  with frame {&frame-name}.
         disable man-equip.tp-dia       with frame {&frame-name}.     
         enable  man-equip.faixa-utiliz with frame {&frame-name}.
     end.
     
     when 3 then DO:
         enable  man-equip.faixa-tempo  with frame {&frame-name}.
         enable  man-equip.faixa-utiliz with frame {&frame-name}.
         enable  man-equip.tp-dia       with frame {&frame-name}.
     end. 
  end case.

  find first tipo-manut where tipo-manut.cd-tipo = input frame {&frame-name} 
                                                    man-equip.cd-tipo no-lock no-error.
  if avail tipo-manut and tipo-manut.tp-manut <> 10 then do:
        disable man-equip.cd-inspecao with frame {&frame-name}.
        assign  man-equip.cd-inspecao:screen-value  in frame {&frame-name} = "" .
     end.
     else 
        enable  man-equip.cd-inspecao with frame {&frame-name}.

   if  manut.cd-tipo        =  tt-manut.cd-tipo        then
       disable  man-equip.cd-tipo        with frame {&frame-name}.
   
   if  manut.cd-sint-padr   =  tt-manut.cd-sint-padr   then
       disable  man-equip.cd-sint-padr   with frame {&frame-name}.
   
   if  manut.cd-causa-padr  =  tt-manut.cd-causa-padr  then
       disable  man-equip.cd-causa-padr  with frame {&frame-name}.

   if  manut.cd-interv-padr =  tt-manut.cd-interv-padr then
       disable  man-equip.cd-interv-padr with frame {&frame-name}.
   
   if  manut.cd-inspecao    =  tt-manut.cd-inspecao    then
       disable  man-equip.cd-inspecao    with frame {&frame-name}.

   if  manut.situacao       =  tt-manut.situacao       then
       disable  man-equip.situacao       with frame {&frame-name}.

   if  manut.controle       =  tt-manut.controle       then
       disable  man-equip.controle       with frame {&frame-name}.
   
   if  manut.faixa-tempo    =  tt-manut.faixa-tempo    then
       disable  man-equip.faixa-tempo    with frame {&frame-name}.

   if  manut.tp-dia         =  tt-manut.tp-dia         then
       disable  man-equip.tp-dia         with frame {&frame-name}.

   if  manut.faixa-utiliz   =  tt-manut.faixa-utiliz   then
         disable  man-equip.faixa-utiliz   with frame {&frame-name}.   

  &if defined (bf_mnt_ems204) &then
     if  manut.urgencia  =  tt-manut.urgencia   then
           disable rs-urgencia with frame {&frame-name}.
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
  /* Code placed here will execute PRIOR to standard behavior. */

  { utp/ut-rtlbl.i mgind man-equip situacao c-situacao}
  { utp/ut-rtlbl.i mgind man-equip controle c-tipo    }
  { utp/ut-rtlbl.i mgind man-equip tp-dia   c-tp-dia  }
&if defined (bf_mnt_ems204) &then
  { utp/ut-rtlbl.i mgind man-equip urgencia c-urgencia}
  rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  assign p-urgencia:hidden  in frame {&frame-name} = no
             rs-urgencia:hidden in frame {&frame-name} = no.
&endif


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


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
    def input param table for tt-manut.
    find first tt-manut
        no-lock no-error.

    find manut
        where manut.cd-manut = tt-manut.cd-manut
        no-lock no-error.

    find man-equip
        where rowid(man-equip) = gr-man-equip
        no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valor V-table-Win 
PROCEDURE pi-mostra-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                         
   if manut.cd-tipo        <>  tt-manut.cd-tipo        then
      assign man-equip.cd-tipo:screen-value        in frame {&frame-name} = 
          string(manut.cd-tipo).
      
   if manut.cd-sint-padr   <>  tt-manut.cd-sint-padr   then
      assign man-equip.cd-sint-padr:screen-value   in frame {&frame-name} =
          string(manut.cd-sint-padr).
      
   if manut.cd-causa-padr  <>  tt-manut.cd-causa-padr  then
      assign man-equip.cd-causa-padr:screen-value  in frame {&frame-name} = 
          string(manut.cd-causa-padr).
         
   if manut.cd-interv-padr <>  tt-manut.cd-interv-padr then
      assign man-equip.cd-interv-padr:screen-value in frame {&frame-name} = 
          string(manut.cd-interv-padr).
   
   if manut.cd-inspecao    <>  tt-manut.cd-inspecao    then
      assign man-equip.cd-inspecao:screen-value    in frame {&frame-name} = 
          string(manut.cd-inspecao).
  
   if manut.situacao       <>  tt-manut.situacao       then
      assign man-equip.situacao:screen-value       in frame {&frame-name} = 
          string(manut.situacao). 
 
   if manut.controle       <>  tt-manut.controle       then
      assign man-equip.controle:screen-value       in frame {&frame-name} = 
          string(manut.controle).
 
   if manut.faixa-tempo    <>  tt-manut.faixa-tempo    then
     assign man-equip.faixa-tempo:screen-value    in frame {&frame-name} = 
         string(manut.faixa-tempo).
    
   if manut.tp-dia         <>  tt-manut.tp-dia         then
      assign man-equip.tp-dia:screen-value        in frame {&frame-name} = 
          string(manut.tp-dia).
 
   if manut.faixa-utiliz   <>  tt-manut.faixa-utiliz   then
      assign man-equip.faixa-utiliz:screen-value   in frame {&frame-name} = 
          string(manut.faixa-utiliz).

   &if defined (bf_mnt_ems204) &then
   if manut.urgencia   <>  tt-manut.urgencia   then
      assign rs-urgencia:screen-value   in frame {&frame-name} = string(manut.urgencia).
   &endif
          
          
  if  available man-equip then do:
      find tipo-manut where tipo-manut.cd-tipo = man-equip.cd-tipo no-lock no-error.
      assign c-descr-manut = if  avail tipo-manut then tipo-manut.descricao else "":U.
      disp c-descr-manut with frame {&frame-name}.     
      
      find causa-padrao where causa-padrao.cd-causa-padr = man-equip.cd-causa-padr no-lock no-error.
      assign c-descr-causa = if  avail causa-padrao then causa-padrao.descricao else "":U.
      disp c-descr-causa with frame {&frame-name}.     
      
      find sint-padrao where sint-padrao.cd-sint-padr = man-equip.cd-sint-padr no-lock no-error.
      assign c-descr-sint = if  avail sint-padrao then sint-padrao.descricao else "":U.
      disp c-descr-sint with frame {&frame-name}.
  
      find interv-padrao where interv-padrao.cd-interv-padr = man-equip.cd-interv-padr no-lock no-error.
      assign c-descr-interv = if  avail interv-padrao then interv-padrao.descricao else "":U.
      disp c-descr-interv with frame {&frame-name}.
      
      find inspec where inspec.cd-inspecao = man-equip.cd-inspecao no-lock no-error.                    
      assign c-descr-inspec = if  avail inspec then inspec.descricao else "":U.
      disp c-descr-inspec with frame {&frame-name}.
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
  if  man-equip.cd-inspecao:sensitive in frame {&frame-name} = yes 
  and (input frame {&frame-name} man-equip.cd-inspecao = "" 
      or not can-find (inspec where inspec.cd-inspecao = input frame {&frame-name} 
                                                         man-equip.cd-inspecao))
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind inspec 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-equip.cd-inspecao.
      return 'ADM-ERROR'.
  end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cd-causa-padr" "man-equip" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "man-equip" "cd-equipto"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "man-equip" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "man-equip" "cd-manut"}
  {src/adm/template/sndkycas.i "cd-parada" "man-equip" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "man-equip" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "man-equip" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "man-equip" "cd-tipo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "man-equip"}

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


