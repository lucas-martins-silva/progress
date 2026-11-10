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
{include/i-prgvrs.i V07IN253 2.00.00.003} /*** "010003" 26/10/2023 17:31:44 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN253 MUT}
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
def new global shared var v-row-parent as rowid no-undo. 

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_video as rowid  no-undo.
&ELSE
    def new global shared var v_rec_video as recid  no-undo.
&ENDIF


                               
/* Parameters Definitions ---                                           */

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
&Scoped-define EXTERNAL-TABLES op-altern
&Scoped-define FIRST-EXTERNAL-TABLE op-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-altern.nr-oper-pad op-altern.refugo-op ~
op-altern.tipo-oper op-altern.gm-codigo op-altern.fi-codigo ~
op-altern.cd-mob-dir 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-oper-pad ~{&FP2}nr-oper-pad ~{&FP3}~
 ~{&FP1}refugo-op ~{&FP2}refugo-op ~{&FP3}~
 ~{&FP1}gm-codigo ~{&FP2}gm-codigo ~{&FP3}~
 ~{&FP1}fi-codigo ~{&FP2}fi-codigo ~{&FP3}~
 ~{&FP1}cd-mob-dir ~{&FP2}cd-mob-dir ~{&FP3}
&Scoped-define ENABLED-TABLES op-altern
&Scoped-define FIRST-ENABLED-TABLE op-altern
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-2 RECT-3 rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS op-altern.nr-oper-pad op-altern.refugo-op ~
op-altern.tipo-oper op-altern.gm-codigo op-altern.fi-codigo ~
op-altern.cd-mob-dir 
&Scoped-Define DISPLAYED-OBJECTS c-desc-oper-pad c-grup-maquina-descricao ~
c-ficha-metodo-descricao c-desc-tab-mob-dir Fi-titulo-tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-desc-oper-pad AS CHARACTER FORMAT "x(34)" 
     VIEW-AS FILL-IN 
     SIZE 38.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tab-mob-dir AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ficha-metodo-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 7.14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 1.29.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.57 BY 1.29.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 1.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     op-altern.nr-oper-pad AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-oper-pad AT ROW 1.17 COL 28.57 COLON-ALIGNED NO-LABEL
     op-altern.refugo-op AT ROW 2.58 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     op-altern.tipo-oper AT ROW 2.79 COL 8.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 28.14 BY .83
     op-altern.gm-codigo AT ROW 4.04 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     c-grup-maquina-descricao AT ROW 4.04 COL 34.14 COLON-ALIGNED NO-LABEL
     op-altern.fi-codigo AT ROW 5.04 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-ficha-metodo-descricao AT ROW 5.08 COL 27.72 COLON-ALIGNED NO-LABEL
     op-altern.cd-mob-dir AT ROW 6.04 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-tab-mob-dir AT ROW 6.04 COL 29.72 COLON-ALIGNED HELP
          "Descriá∆o da m∆o-de-obra direta" NO-LABEL
     Fi-titulo-tipo AT ROW 2.33 COL 3 NO-LABEL
     RECT-5 AT ROW 1 COL 1
     RECT-2 AT ROW 2.42 COL 1
     RECT-3 AT ROW 2.42 COL 43.14
     rt-mold-2 AT ROW 3.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.op-altern
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 6.13
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

/* SETTINGS FOR FILL-IN c-desc-oper-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tab-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ficha-metodo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME op-altern.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.cd-mob-dir V-table-Win
ON LEAVE OF op-altern.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/leave.i &tabela=tab-mob-dir 
                   &atributo-ref=descricao 
                   &variavel-ref=c-desc-tab-mob-dir
                   &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON F5 OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in125.w" 
                     &campo=op-altern.fi-codigo
                     &campozoom=fi-codigo
                     &campo2=c-ficha-metodo-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON LEAVE OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  {include/leave.i &tabela=ficha-metodo 
                   &atributo-ref=descricao 
                   &variavel-ref=c-ficha-metodo-descricao
                   &where="ficha-metodo.fi-codigo = input frame {&frame-name} op-altern.fi-codigo"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON F5 OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=op-altern.gm-codigo
                     &campozoom=gm-codigo
                     &campo2=c-grup-maquina-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON LEAVE OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  {include/leave.i &tabela=grup-maquina 
                   &atributo-ref=descricao 
                   &variavel-ref=c-grup-maquina-descricao 
                   &where="grup-maquina.gm-codigo = input frame {&frame-name} op-altern.gm-codigo"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.nr-oper-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.nr-oper-pad V-table-Win
ON LEAVE OF op-altern.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
  {include/leave.i &tabela=oper-pad 
                   &atributo-ref=descricao 
                   &variavel-ref=c-desc-oper-pad
                   &where="oper-pad.nr-oper-pad = input frame {&frame-name} op-altern.nr-oper-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 {utp/ut-rtlbl.i mgind op-altern tipo-oper fi-titulo-tipo}


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
  {src/adm/template/row-list.i "op-altern"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-altern"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail op-altern then do with frame {&frame-name}:
     find grup-maquina where grup-maquina.gm-codigo = op-altern.gm-codigo   no-lock no-error.
     find ficha-metodo where ficha-metodo.fi-codigo = op-altern.fi-codigo   no-lock no-error.
     find oper-pad     where oper-pad.nr-oper-pad   = op-altern.nr-oper-pad no-lock no-error.
     find tab-mob-dir  where tab-mob-dir.cd-mob-dir = op-altern.cd-mob-dir  no-lock no-error.
     assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then grup-maquina.descricao else "":U
            c-ficha-metodo-descricao:screen-value = if avail ficha-metodo then ficha-metodo.descricao else "":U
            c-desc-oper-pad:screen-value          = if avail oper-pad     then oper-pad.descricao     else "":U
            c-desc-tab-mob-dir:screen-value       = if avail tab-mob-dir  then tab-mob-dir.descricao  else "":U.
  end.      
               
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
  {src/adm/template/snd-list.i "op-altern"}

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


