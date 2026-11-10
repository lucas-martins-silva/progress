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
{include/i-prgvrs.i V07IN263 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN263 MUT}
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

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS operacao.tempo-prepar operacao.tempo-maquin ~
operacao.tempo-homem 
&Scoped-define ENABLED-TABLES operacao
&Scoped-define FIRST-ENABLED-TABLE operacao
&Scoped-Define ENABLED-OBJECTS rt-mold7 
&Scoped-Define DISPLAYED-FIELDS operacao.tempo-prepar operacao.tempo-maquin ~
operacao.tempo-homem operacao.nr-op-simult operacao.numero-homem 
&Scoped-define DISPLAYED-TABLES operacao
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-ind-tempo-operac ~
c-un-med-tempo tg-tempo-sig 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-ind-tempo-operac AS CHARACTER FORMAT "X(14)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-med-tempo AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-unidades AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 8.46.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL no 
     LABEL "Tempo Significativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     v-unidades AT ROW 1.71 COL 21 COLON-ALIGNED
     operacao.tempo-prepar AT ROW 3.21 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     operacao.tempo-maquin AT ROW 4.21 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-ind-tempo-operac AT ROW 4.21 COL 57 COLON-ALIGNED
     operacao.tempo-homem AT ROW 5.21 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-un-med-tempo AT ROW 5.21 COL 57 COLON-ALIGNED
     operacao.nr-op-simult AT ROW 6.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     tg-tempo-sig AT ROW 6.71 COL 59
     operacao.numero-homem AT ROW 7.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     rt-mold7 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
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
         HEIGHT             = 8.46
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




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ind-tempo-operac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-med-tempo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.nr-op-simult IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.numero-homem IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-tempo-sig IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-unidades IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind operacao un-med-tempo 01}
assign c-un-med-tempo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind operacao nr-unidades 01}
assign v-unidades:label in frame {&frame-name} = return-value.

&if defined (bf_man_sfc_lc) &then
{utp/ut-field.i mgind grup-maquina ind-tempo-operac 01}
assign c-ind-tempo-operac:label in frame {&frame-name} = return-value.

&endif

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

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
  HIDE FRAME F-Main.
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

def var c-handle as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  if AVAIL operacao AND operacao.tipo-oper = 2 then do with frame {&frame-name}:
      {utp/ut-liter.i Tempo_Ressuprimento}
      assign operacao.tempo-maquin:label  = return-value
             operacao.numero-homem:hidden = TRUE
             operacao.tempo-homem:hidden  = TRUE.
  end.
  else do with frame {&frame-name}:
     {utp/ut-field.i mgind operacao tempo-maquin 1}
     assign operacao.tempo-maquin:label  = return-value
            operacao.numero-homem:hidden = FALSE
            operacao.tempo-homem:hidden  = FALSE.
  end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail operacao then do with frame {&frame-name}:
     assign c-un-med-tempo:screen-value = {ininc/i02in261.i 04 operacao.un-med-tempo}
            v-unidades                  = operacao.nr-unidades
            v-unidades:screen-value     = string(v-unidades).

     &if {&bf_man_204} &then
         &if {&bf_man_205} &then
             assign tg-tempo-sig = operacao.tempo-sig.
         &else
             assign tg-tempo-sig = if substr(operacao.char-1,41,1) = "S":U then true else false.
         &endif
     &endif
  end. 

  assign tg-tempo-sig:hidden in frame {&frame-name} = yes.

  &if {&bf_man_204} &then
      find first param-global no-lock no-error.
      if  param-global.modulo-sws = no then do:
          assign tg-tempo-sig:hidden in frame {&frame-name} = no.
          disp tg-tempo-sig with frame {&frame-name}.
      end.
  &endif

  &if defined (bf_man_sfc_lc) &then
      assign c-ind-tempo-operac:hidden in frame {&frame-name}      = no.
      if avail operacao then do:
         if operacao.tipo-oper = 2 then 
            assign c-ind-tempo-operac:hidden in frame {&frame-name}      = yes.
         else do with frame {&frame-name}:
             find first grup-maquina
                  where grup-maquina.gm-codigo = operacao.gm-codigo no-lock no-error.

             assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.
         end.
      end.

      RUN Who-Is-The-Container IN adm-broker-hdl 
          (INPUT this-procedure, OUTPUT c-handle).

      run pi-habilita-folder in widget-handle(c-handle) (input rowid(operacao)).
  &else
      assign c-ind-tempo-operac:hidden in frame {&frame-name}      = yes.
  &endif

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
  {src/adm/template/snd-list.i "operacao"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

