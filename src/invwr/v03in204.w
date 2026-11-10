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
{include/i-prgvrs.i V03IN204 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN204 MUT}
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

  {cdp/cdcfgmnt.i}.
/* global variable definitions */
def new global shared var v-row-parent  as rowid no-undo.                                
def new global shared var gr-tipo-manut as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-tabela-1    as char format "x(40)" no-undo.
def var c-label-1     as char format "x(40)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-tag-fam
&Scoped-define FIRST-EXTERNAL-TABLE man-tag-fam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-tag-fam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-tag-fam.cd-causa-padr ~
man-tag-fam.cd-sint-padr man-tag-fam.cd-interv-padr man-tag-fam.tp-dia ~
man-tag-fam.faixa-tempo man-tag-fam.faixa-utiliz man-tag-fam.situacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-causa-padr ~{&FP2}cd-causa-padr ~{&FP3}~
 ~{&FP1}cd-sint-padr ~{&FP2}cd-sint-padr ~{&FP3}~
 ~{&FP1}cd-interv-padr ~{&FP2}cd-interv-padr ~{&FP3}~
 ~{&FP1}faixa-tempo ~{&FP2}faixa-tempo ~{&FP3}~
 ~{&FP1}faixa-utiliz ~{&FP2}faixa-utiliz ~{&FP3}
&Scoped-define ENABLED-TABLES man-tag-fam
&Scoped-define FIRST-ENABLED-TABLE man-tag-fam
&Scoped-Define ENABLED-OBJECTS RECT-23 p-urgencia RECT-22 RECT-24 rt-mold 
&Scoped-Define DISPLAYED-FIELDS man-tag-fam.cd-tipo ~
man-tag-fam.cd-causa-padr man-tag-fam.cd-sint-padr ~
man-tag-fam.cd-interv-padr man-tag-fam.tp-dia man-tag-fam.controle ~
man-tag-fam.faixa-tempo man-tag-fam.faixa-utiliz man-tag-fam.situacao 
&Scoped-Define DISPLAYED-OBJECTS c-desc-manut c-desc-causa c-desc-sint ~
c-desc-interv rs-urgencia c-tp-dia c-controle c-situacao c-urgencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS man-tag-fam.cd-tipo man-tag-fam.controle 
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
DEFINE VARIABLE c-controle AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 10.72 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-causa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-interv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sint AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-tp-dia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-urgencia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 10.72 BY .63 NO-UNDO.

DEFINE VARIABLE rs-urgencia AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          " ", 1,
" ", 2,
" ", 3
     SIZE 57.86 BY .71 NO-UNDO.

DEFINE RECTANGLE p-urgencia
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60.29 BY 1.33.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 3.08.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.86 BY 2.83.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 1.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-tag-fam.cd-tipo AT ROW 1.13 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-desc-manut AT ROW 1.17 COL 37 COLON-ALIGNED NO-LABEL
     man-tag-fam.cd-causa-padr AT ROW 2.13 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-causa AT ROW 2.17 COL 37 COLON-ALIGNED NO-LABEL
     man-tag-fam.cd-sint-padr AT ROW 3.13 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-sint AT ROW 3.17 COL 37 COLON-ALIGNED NO-LABEL
     man-tag-fam.cd-interv-padr AT ROW 4.13 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-interv AT ROW 4.17 COL 37 COLON-ALIGNED NO-LABEL
     man-tag-fam.tp-dia AT ROW 6 COL 3 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Util", 1,
"Corrido", 2
          SIZE 16.29 BY .63
     man-tag-fam.controle AT ROW 6.17 COL 26 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Faixa Tempo", 1,
"Utiliz Equipto", 2,
"Ambos", 3
          SIZE 56 BY .54
     man-tag-fam.faixa-tempo AT ROW 7.25 COL 37.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     man-tag-fam.faixa-utiliz AT ROW 7.25 COL 63.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY 1
     man-tag-fam.situacao AT ROW 7.63 COL 3 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ativa", 1,
"Suspensa", 2,
"Eliminada", 3
          SIZE 16.29 BY 2.42
     rs-urgencia AT ROW 9.46 COL 25.86 NO-LABEL
     c-tp-dia AT ROW 5.29 COL 1.29 COLON-ALIGNED NO-LABEL
     c-controle AT ROW 5.46 COL 24 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 6.83 COL 1.14 COLON-ALIGNED NO-LABEL
     c-urgencia AT ROW 8.63 COL 24 COLON-ALIGNED NO-LABEL
     RECT-23 AT ROW 5.63 COL 24
     p-urgencia AT ROW 8.96 COL 23.86
     RECT-22 AT ROW 7.21 COL 2.43
     RECT-24 AT ROW 5.54 COL 2.29
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-tag-fam
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
         HEIGHT             = 9.75
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
ASSIGN        FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-controle IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-interv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sint IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-urgencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-tag-fam.cd-tipo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET man-tag-fam.controle IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN        p-urgencia:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-urgencia IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN        rs-urgencia:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME man-tag-fam.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-causa-padr V-table-Win
ON F5 OF man-tag-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                   &tabela=man-tag-fam
                   &atributo=cd-causa-padr}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-causa-padr V-table-Win
ON LEAVE OF man-tag-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
    {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} 
                                                        man-tag-fam.cd-causa-padr"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-tag-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-tag-fam.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-interv-padr V-table-Win
ON F5 OF man-tag-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                    &tabela=man-tag-fam
                    &atributo=cd-interv-padr}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-interv-padr V-table-Win
ON LEAVE OF man-tag-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name}
                                                        man-tag-fam.cd-interv-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-tag-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-tag-fam.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-sint-padr V-table-Win
ON F5 OF man-tag-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                   &tabela=man-tag-fam
                   &atributo=cd-sint-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-sint-padr V-table-Win
ON LEAVE OF man-tag-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   {include/leave.i &tabela=sint-padrao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-sint
                    &where="sint-padrao.cd-sint-padr = input frame {&frame-name} 
                                                       man-tag-fam.cd-sint-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-tag-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-tag-fam.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-tipo V-table-Win
ON F5 OF man-tag-fam.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in434.w"
                   &tabela=man-tag-fam
                   &atributo=cd-tipo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-tipo V-table-Win
ON LEAVE OF man-tag-fam.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  {include/leave.i &tabela=tipo-manut
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-manut
                   &where="tipo-manut.cd-tipo = input frame {&frame-name} 
                                                man-tag-fam.cd-tipo"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-tipo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-tag-fam.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
    apply 'F5' to self .  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-tag-fam.controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.controle V-table-Win
ON VALUE-CHANGED OF man-tag-fam.controle IN FRAME f-main /* Ct */
DO:
  case input frame {&frame-name} man-tag-fam.controle:
     when 1 then DO:
         disable man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.         
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
         assign  man-tag-fam.faixa-utiliz:screen-value in frame {&frame-name} = "0".
         apply 'entry' to man-tag-fam.faixa-tempo.
     end.
     when 2 then DO:
         disable man-tag-fam.faixa-tempo  with frame {&frame-name}.
         disable man-tag-fam.tp-dia       with frame {&frame-name}.     
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
         assign  man-tag-fam.faixa-tempo:screen-value in frame {&frame-name} = "0"
                 man-tag-fam.tp-dia:screen-value      in frame {&frame-name} = "1".
         apply 'entry' to man-tag-fam.faixa-utiliz.
     end.
     when 3 then DO:
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.
         apply 'entry' to man-tag-fam.faixa-tempo.
     end. 
  end case.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  /* Efeito da M∆o do Ponteiro do Mouse */
  if  man-tag-fam.cd-tipo:load-mouse-pointer ("image/lupa.cur") in frame 
      {&frame-name}  then.
  if  man-tag-fam.cd-causa-padr:load-mouse-pointer ("image/lupa.cur") in frame 
      {&frame-name} then.
  if  man-tag-fam.cd-sint-padr:load-mouse-pointer ("image/lupa.cur") in frame 
      {&frame-name} then.
  if  man-tag-fam.cd-interv-padr:load-mouse-pointer ("image/lupa.cur") in frame 
      {&frame-name} then.

  /* Labels dos Radio-SetÔs */
  &if defined (bf_mnt_ems204) &then
      assign p-urgencia:hidden  in frame {&frame-name} = no
             rs-urgencia:hidden in frame {&frame-name} = no
             rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  &endif

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  {src/adm/template/row-list.i "man-tag-fam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-tag-fam"}

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
  &if defined (bf_mnt_ems204) &then
      assign p-urgencia:hidden  in frame {&frame-name} = no
             rs-urgencia:hidden in frame {&frame-name} = no
             rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  &endif

  { utp/ut-field.i mgind man-tag-fam situacao 1}
  assign c-situacao:screen-value in frame {&frame-name} = return-value.
  { utp/ut-field.i mgind man-tag-fam controle 1}
  assign c-controle:screen-value in frame {&frame-name} = return-value.
  { utp/ut-field.i mgind man-tag-fam tp-dia   1}  
  assign c-tp-dia:screen-value in frame {&frame-name} = return-value.
  &if defined (bf_mnt_ems204) &then
  { utp/ut-field.i mgind man-tag-fam urgencia 1}
  assign c-urgencia:screen-value in frame {&frame-name} = return-value.
  &endif

  do with frame {&frame-name}:
     if  man-tag-fam.controle:screen-value = '1' then do:
         disable man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.
     end.
     if  man-tag-fam.controle:screen-value = '2' then do:  
         disable man-tag-fam.faixa-tempo  with frame {&frame-name}.
         disable man-tag-fam.tp-dia       with frame {&frame-name}.
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
     end.
     if  man-tag-fam.controle:screen-value = '3' then do:
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.
     end.
  end.

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
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

 &if defined (bf_mnt_ems204) &then
     if avail man-tag-fam then
        if rs-urgencia:sensitive in frame {&frame-name} then
           assign man-tag-fam.urgencia = input frame {&frame-name} rs-urgencia.
 &endif

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
       &if defined(bf_mnt_ems204) &then
           disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &endif
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


  &if defined (bf_mnt_ems204) &then
      assign p-urgencia:hidden  in frame {&frame-name} = no
             rs-urgencia:hidden in frame {&frame-name} = no
             rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  &endif

  if  available man-tag-fam then do:
      find tipo-manut where tipo-manut.cd-tipo = man-tag-fam.cd-tipo no-lock no-error. 
      find causa-padrao where causa-padrao.cd-causa-padr = man-tag-fam.cd-causa-padr no-lock no-error.
      find sint-padrao where sint-padrao.cd-sint-padr = man-tag-fam.cd-sint-padr no-lock no-error. 
      find interv-padrao where interv-padrao.cd-interv-padr = man-tag-fam.cd-interv-padr no-lock no-error.

      assign gr-tipo-manut = rowid(tipo-manut)
             c-desc-manut = if  avail tipo-manut then tipo-manut.descricao else "":U
             c-desc-causa = if  avail causa-padrao then causa-padrao.descricao else "":U
             c-desc-sint = if  avail sint-padrao then sint-padrao.descricao else "":U
             c-desc-interv = if  avail interv-padrao then interv-padrao.descricao else "":U.  

      do with frame {&frame-name}:           
         disp c-desc-manut      
              c-desc-causa
              c-desc-sint
              c-desc-interv.
     end.
     &if defined (bf_mnt_ems204) &then
        if adm-new-record =  no then
           assign rs-urgencia:screen-value = string(man-tag-fam.urgencia).  
     &endif

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 

 { utp/ut-field.i mgind man-tag-fam situacao 1}
  assign c-situacao:screen-value in frame {&frame-name} = return-value.

  { utp/ut-field.i mgind man-tag-fam controle 1}
  assign c-controle:screen-value in frame {&frame-name} = return-value.

  { utp/ut-field.i mgind man-tag-fam tp-dia 1}  
  assign c-tp-dia:screen-value in frame {&frame-name} = return-value.

  &if defined (bf_mnt_ems204) &then
  { utp/ut-field.i mgind man-tag-fam urgencia 1}
  assign c-urgencia:screen-value in frame {&frame-name} = return-value.
  &endif

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


  /* Dispatch standard ADM method.*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  do with frame {&frame-name}:
    if man-tag-fam.controle:screen-value = '1' then do:
           disable man-tag-fam.faixa-utiliz with frame {&frame-name}.
           enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
           enable  man-tag-fam.tp-dia       with frame {&frame-name}.         
    end.
    if man-tag-fam.controle:screen-value = '2' then do:  
           disable man-tag-fam.faixa-tempo  with frame {&frame-name}.
           disable man-tag-fam.tp-dia       with frame {&frame-name}.     
           enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.    
    end.
    if man-tag-fam.controle:screen-value = '3' then do:
           enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
           enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
           enable  man-tag-fam.tp-dia       with frame {&frame-name}.       
    end.
  end.




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
  { utp/ut-field.i mgind man-tag-fam situacao 1}
  assign c-situacao:screen-value in frame {&frame-name} = return-value.

  { utp/ut-field.i mgind man-tag-fam controle 1}
  assign c-controle:screen-value in frame {&frame-name} = return-value.

  { utp/ut-field.i mgind man-tag-fam tp-dia   1}  
  assign c-tp-dia:screen-value in frame {&frame-name} = return-value.

  &if defined (bf_mnt_ems204) &then
  { utp/ut-field.i mgind man-tag-fam urgencia 1}
  assign c-urgencia:screen-value in frame {&frame-name} = return-value.
  &endif


  &if defined (bf_mnt_ems204) &then
      assign p-urgencia:hidden  in frame {&frame-name} = no
             rs-urgencia:hidden in frame {&frame-name} = no
             rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
  &endif

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
  define input parameter r-manut as rowid.
  find first manut where rowid (manut) = r-manut NO-LOCK NO-ERROR.
ASSIGN     man-tag-fam.situacao:screen-value       in frame {&frame-name} =  string(manut.situacao)
    man-tag-fam.controle:screen-value       in frame {&frame-name} =  string(manut.controle)
    man-tag-fam.tp-dia:screen-value         in frame {&frame-name} =  string(manut.tp-dia)
    man-tag-fam.faixa-tempo:screen-value    in frame {&frame-name} =  string(manut.faixa-tempo)
    man-tag-fam.faixa-utiliz:screen-value   in frame {&frame-name} =  string(manut.faixa-utiliz)
    man-tag-fam.cd-tipo:screen-value        in frame {&frame-name} =  string(manut.cd-tipo)
    man-tag-fam.cd-causa-padr:screen-value  in frame {&frame-name} =  manut.cd-causa-padr
    man-tag-fam.cd-sint-padr:screen-value   in frame {&frame-name} =  manut.cd-sint-padr
    man-tag-fam.cd-interv-padr:screen-value in frame {&frame-name} =  manut.cd-interv-padr.

   &if defined (bf_mnt_ems204) &then 
       if avail manut then
          assign rs-urgencia:screen-value = string(manut.urgencia).   
   &endif

  {include/leave.i &tabela=tipo-manut
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-manut
                   &where="tipo-manut.cd-tipo = input frame {&frame-name} 
                                                man-tag-fam.cd-tipo"}
  {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} 
                                                        man-tag-fam.cd-causa-padr"}
  {include/leave.i &tabela=sint-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-sint
                   &where="sint-padrao.cd-sint-padr = input frame {&frame-name} 
                                                      man-tag-fam.cd-sint-padr"}   
  {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name} 
                                                          man-tag-fam.cd-interv-padr"}

  case input frame {&frame-name}  man-tag-fam.controle:
     when 1 then DO:
         disable man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.         
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
     end.

     when 2 then DO:
         disable man-tag-fam.faixa-tempo  with frame {&frame-name}.
         disable man-tag-fam.tp-dia       with frame {&frame-name}.     
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
     end.

     when 3 then DO:
         enable  man-tag-fam.faixa-tempo  with frame {&frame-name}.
         enable  man-tag-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-tag-fam.tp-dia       with frame {&frame-name}.
     end. 
  end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    find tipo-manut
        where tipo-manut.cd-tipo = input frame {&frame-name} man-tag-fam.cd-tipo
        no-lock no-error.
    if  avail tipo-manut then do:
        if  tipo-manut.tp-manut = 10 then do:
            {utp/ut-table.i mgind man-tag-fam 1}
            assign c-tabela-1 = trim(return-value).
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao001 = {ininc/i01in434.i 04 10}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-label-1 = RETURN-VALUE.
            &else
                ASSIGN c-label-1 = {ininc/i01in434.i 04 10}.
            &endif
            {utp/ut-table.i mgind inspec 1}
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p (input "show",
                               input 7355,
                               input c-tabela-1 + "~~" + c-label-1).
            return 'ADM-ERROR'.
        end.
    end.



/* Validaá∆o da Faixa de Tempo e da Faixa de utilizaá∆o */
  case input frame {&frame-name} man-tag-fam.controle:
     when 1 then DO:
        if  input frame {&frame-name} man-tag-fam.faixa-tempo = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19353,
                              input " ").

            apply 'entry' to man-tag-fam.faixa-tempo.
            return 'ADM-ERROR'.
        end.
     end.
     when 2 then DO:
        if  input frame {&frame-name} man-tag-fam.faixa-utiliz = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19354,
                              input " ").
            apply 'entry' to man-tag-fam.faixa-utiliz.
            return 'ADM-ERROR'.
        end.        
     end.
     when 3 then DO:
        if  input frame {&frame-name} man-tag-fam.faixa-tempo = 0 then do:
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19355,
                              input " ").
            apply 'entry' to man-tag-fam.faixa-tempo.
            return 'ADM-ERROR'.
        end.
        if  input frame {&frame-name} man-tag-fam.faixa-utiliz = 0 then do: 
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
            run utp/ut-msgs.p(input "show",
                              input 19355,
                              input " ").            
            apply 'entry' to man-tag-fam.faixa-utiliz.
            return 'ADM-ERROR'.            
        end.     
    end.    

end.



   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "man-tag-fam"}

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


