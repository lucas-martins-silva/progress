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
{include/i-prgvrs.i V02IN575 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN575 MUT}
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

{include/i-vrtab.i contrat-modelo}
{include/i-vrtab.i clausula-mod}
{include/i-vrtab.i anexo-mod}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo. 
def new global shared var gr-contrato as rowid no-undo.
                               
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-contrato for contrat-modelo.

def var i-contrato as integer.
def var c-incluir as char.
def var i-opcao as integer initial 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES contrat-modelo
&Scoped-define FIRST-EXTERNAL-TABLE contrat-modelo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR contrat-modelo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS contrat-modelo.des-contrat ~
contrat-modelo.cod-tipo-contrat 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}des-contrat ~{&FP2}des-contrat ~{&FP3}~
 ~{&FP1}cod-tipo-contrat ~{&FP2}cod-tipo-contrat ~{&FP3}
&Scoped-define ENABLED-TABLES contrat-modelo
&Scoped-define FIRST-ENABLED-TABLE contrat-modelo
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS contrat-modelo.nr-contrato ~
contrat-modelo.des-contrat contrat-modelo.cod-tipo-contrat 
&Scoped-Define DISPLAYED-OBJECTS c-tipo c-contrato c-tipo-desc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS contrat-modelo.nr-contrato 
&Scoped-define ADM-ASSIGN-FIELDS contrat-modelo.nr-contrato 

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
DEFINE VARIABLE c-contrato AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.57 BY 2.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-tipo AT ROW 2.75 COL 8.57 COLON-ALIGNED NO-LABEL
     c-contrato AT ROW 1.75 COL 6 NO-LABEL
     contrat-modelo.nr-contrato AT ROW 1.63 COL 18 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     contrat-modelo.des-contrat AT ROW 1.63 COL 28 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     contrat-modelo.cod-tipo-contrat AT ROW 2.63 COL 18 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-tipo-desc AT ROW 2.63 COL 22 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.contrat-modelo
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
         HEIGHT             = 3.04
         WIDTH              = 81.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-contrato IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contrat-modelo.nr-contrato IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME contrat-modelo.cod-tipo-contrat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON F5 OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in588.w
                     &campo=contrat-modelo.cod-tipo-contrat
                     &campozoom=cod-tipo-contr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON LEAVE OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  {include/leave.i &tabela=tipo-contrat
                   &atributo-ref=des-tipo-contrat
                   &variavel-ref=c-tipo-desc
                   &where="tipo-contrat.cod-tipo-contr = input frame {&frame-name} contrat-modelo.cod-tipo-contrat"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contrat-modelo.nr-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.nr-contrato V-table-Win
ON F5 OF contrat-modelo.nr-contrato IN FRAME f-main /* Nr Contrato */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in575.w
                     &campo=contrat-modelo.nr-contrato
                     &campozoom=nr-contrato}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.nr-contrato V-table-Win
ON LEAVE OF contrat-modelo.nr-contrato IN FRAME f-main /* Nr Contrato */
DO:
  {include/leave.i &tabela=contrat-modelo
                   &atributo-ref=des-contrat
                   &variavel-ref=contrat-modelo.des-contrat
                   &where="contrat-modelo.nr-contrato = input frame {&frame-name} contrat-modelo.nr-contrato"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.nr-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contrat-modelo.nr-contrato IN FRAME f-main /* Nr Contrato */
DO:
  apply 'F5' to self.
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
  {src/adm/template/row-list.i "contrat-modelo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "contrat-modelo"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  find first clausula-mod where 
       clausula-mod.nr-contrato = contrat-modelo.nr-contrato no-lock no-error.
  if avail clausula-mod then do:
     /* Inicio -- Projeto Internacional */
     {utp/ut-table.i mgind clausula-mod 1} /* Busca o label da tabela */
     run utp/ut-msgs.p (input "show",
                        input 7832, 
                        input TRIM(RETURN-VALUE)).
     return 'adm-error':U.
  end.
  
  find first anexo-mod where
       anexo-mod.nr-contrato = contrat-modelo.nr-contrato no-lock no-error.
  if avail anexo-mod then do:
     /* Inicio -- Projeto Internacional */
     {utp/ut-table.i mgind anexo-mod 1} /* Busca o label da tabela */
     run utp/ut-msgs.p (input "show",
                        input 7832,
                        input TRIM(RETURN-VALUE)).
     return 'adm-error':U.
  end.          
                               
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

  if avail contrat-modelo then do: 
     find first tipo-contrat where
        tipo-contrat.cod-tipo-contr = contrat-modelo.cod-tipo-contrat no-lock no-error.
     assign c-tipo-desc = if avail tipo-contrat then tipo-contrat.des-tipo-contrat else " ":U.
  end.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .


  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   {utp/ut-liter.i N£mero_do_Modelo: * R}
   assign c-contrato = return-value.
   disp c-contrato with frame {&frame-name}.
   
   {utp/ut-liter.i Modalidade: * R}
   assign c-tipo = return-value.
   disp c-tipo with frame {&frame-name}.   
   
   find first b-contrato no-lock no-error.
   assign gr-contrato = rowid(b-contrato).
   
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

  if avail contrat-modelo then
     assign gr-contrato = rowid(contrat-modelo).    

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "contrat-modelo"}

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


