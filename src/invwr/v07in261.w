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
{include/i-prgvrs.i V07IN261 2.00.00.028} /*** "010028" 26/10/2023 17:31:44 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN261 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_video  as rowid no-undo.
&ELSE
    def new global shared var v_rec_video  as recid no-undo.
&ENDIF


{cdp/cdcfgman.i}

def var p-unidades       like oper-pad.nr-unidades  no-undo.
def var p-tempo-sig      as log                     no-undo.
def var h_v10in261       as handle                  no-undo.

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
&Scoped-define EXTERNAL-TABLES oper-pad
&Scoped-define FIRST-EXTERNAL-TABLE oper-pad


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-pad.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-pad.cod-video oper-pad.tempo-prepar ~
oper-pad.tempo-maquin oper-pad.tempo-homem oper-pad.nr-op-simult ~
oper-pad.numero-homem 
&Scoped-define ENABLED-TABLES oper-pad
&Scoped-define FIRST-ENABLED-TABLE oper-pad
&Scoped-define DISPLAYED-TABLES oper-pad
&Scoped-define FIRST-DISPLAYED-TABLE oper-pad
&Scoped-Define ENABLED-OBJECTS v-unidades cb-un-med-tempo tg-tempo-sig ~
RECT-12 rt-mold7 
&Scoped-Define DISPLAYED-FIELDS oper-pad.cod-video oper-pad.tempo-prepar ~
oper-pad.tempo-maquin oper-pad.tempo-homem oper-pad.nr-op-simult ~
oper-pad.numero-homem 
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-ind-tempo-operac ~
cb-un-med-tempo tg-tempo-sig 

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
DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE c-ind-tempo-operac AS CHARACTER FORMAT "X(14)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-unidades AS INTEGER FORMAT ">>>>9":U INITIAL 100 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 1.25.

DEFINE RECTANGLE rt-mold7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 8.83.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL no 
     LABEL "Tempo Significativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-pad.cod-video AT ROW 1.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     v-unidades AT ROW 3 COL 24 COLON-ALIGNED
     oper-pad.tempo-prepar AT ROW 4.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     oper-pad.tempo-maquin AT ROW 5.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-ind-tempo-operac AT ROW 5.71 COL 60 COLON-ALIGNED
     oper-pad.tempo-homem AT ROW 6.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     cb-un-med-tempo AT ROW 6.71 COL 60 COLON-ALIGNED
     oper-pad.nr-op-simult AT ROW 8.5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     tg-tempo-sig AT ROW 8.5 COL 62
     oper-pad.numero-homem AT ROW 9.5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     RECT-12 AT ROW 1 COL 1
     rt-mold7 AT ROW 2.42 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 10.25.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-pad
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
         HEIGHT             = 10.25
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
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ind-tempo-operac IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME cb-un-med-tempo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-un-med-tempo V-table-Win
ON VALUE-CHANGED OF cb-un-med-tempo IN FRAME f-main
DO:
  &if defined (bf_man_sfc_lc) &then
  run pi-atualiza-dados in h_v10in261 (input v-unidades:screen-value,
                                       input cb-un-med-tempo:screen-value).

  &endif 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.cod-video
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cod-video V-table-Win
ON F5 OF oper-pad.cod-video IN FRAME f-main /* V°deo */
DO:
  run btb/btb020ka.p (param-global.cod-catal-video-op).
  
  &IF {&ROWID_READY} = YES &THEN
      find video where rowid(video)  = v_rec_video no-lock no-error.
  &ELSE
      find video where recid(video)  = v_rec_video no-lock no-error.
  &ENDIF
  assign oper-pad.cod-video:screen-value = 
             if avail video then string(video.cod_video) else "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cod-video V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.cod-video IN FRAME f-main /* V°deo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-unidades
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-unidades V-table-Win
ON LEAVE OF v-unidades IN FRAME f-main
DO:

&if defined (bf_man_sfc_lc) &then
    run pi-atualiza-dados in h_v10in261 (input v-unidades:screen-value,
                                         input cb-un-med-tempo:screen-value).

&endif 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind oper-pad un-med-tempo 01}
assign cb-un-med-tempo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-pad nr-unidades 01}
assign v-unidades:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina ind-tempo-operac 01}
assign c-ind-tempo-operac:label in frame {&frame-name} = return-value.


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
  {src/adm/template/row-list.i "oper-pad"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-pad"}

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

  do with frame {&frame-name}:
     {utp/ut-field.i mgind oper-pad tempo-maquin 1}. 
      assign oper-pad.tempo-maquin:label        = return-value
             v-unidades:hidden                  = false
             oper-pad.tempo-prepar:hidden       = false
             oper-pad.numero-homem:hidden       = false
             oper-pad.tempo-homem:hidden        = false
             v-unidades:screen-value            = string(100)
             oper-pad.tempo-prepar:screen-value = string(0)
             oper-pad.tempo-homem:screen-value  = string(0)
             oper-pad.numero-homem:screen-value = string(1).
      IF cb-un-med-tempo  = " " OR 
         cb-un-med-tempo  = "4" THEN DO:
         cb-un-med-tempo:screen-value       = {ininc/i02in261.i 04 1}.
      END.
       assign tg-tempo-sig:CHECKED IN frame {&frame-name} = NO.
  end.  

  run pi-verifica-tipo-oper (input 1).
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

  assign p-unidades = input frame {&frame-name} v-unidades.
  &if {&bf_man_204} &then
      assign p-tempo-sig = input frame {&frame-name} tg-tempo-sig.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  if oper-pad.tipo-oper = 2 then 
     assign oper-pad.numero-homem = 1
            oper-pad.tempo-homem  = 0.

  assign oper-pad.nr-unidades = p-unidades.

   &if {&bf_man_204} &then
       &if {&bf_man_206} &then
           assign oper-pad.tempo-sig = p-tempo-sig.
       &else
           assign substr(oper-pad.char-1,41,1) = if p-tempo-sig = true then "S":U else "N":U.
       &endif
   &endif

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

  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&frame-name}:
     assign oper-pad.un-med-tempo = {ininc/i02in261.i 06 cb-un-med-tempo:screen-value}.
  end.

  assign oper-pad.nr-unidades  = input frame {&frame-name} v-unidades.


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

  /* Code placed here will execute PRIOR to standard behavior. */

  if avail oper-pad and adm-new-record = no then do:
      assign v-unidades = oper-pad.nr-unidades.

      &if {&bf_man_204} &then
          if  avail oper-pad then do:
              &if {&bf_man_206} &then
                  assign tg-tempo-sig = oper-pad.tempo-sig.
              &else
                  assign tg-tempo-sig = if substr(oper-pad.char-1,41,1) = "S":U then true else false.
              &endif
          end.
      &endif
  end.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*********
  if avail oper-pad and adm-new-record = no then do: 
     assign v-unidades:screen-value in frame {&frame-name} = string(oper-pad.nr-unidades) 
            cb-un-med-tempo:screen-value    = {ininc/i02in261.i 04 oper-pad.un-med-tempo}.

     if oper-pad.tipo-oper = 2 then do with frame {&frame-name}:
        {utp/ut-liter.i Tempo_Ressuprimento}. 

        assign oper-pad.tempo-maquin:label     = return-value
               oper-pad.numero-homem:hidden    = yes
               oper-pad.tempo-homem:hidden     = yes.               
     end.
     else do:
        &if defined (bf_man_sfc_lc) &then 
        if valid-handle (h_v10in261) then   
           run pi-atualiza-dados in h_v10in261 (input v-unidades:screen-value,
                                                input cb-un-med-tempo:screen-value).
        &endif 

        if adm-new-record = yes then
           disp oper-pad.tempo-homem
                oper-pad.numero-homem.

     end.
  end.

  &if defined (bf_man_sfc_lc) &then  
      assign c-ind-tempo-operac:hidden in frame {&frame-name} = no.

      if avail oper-pad then do:
         if oper-pad.tipo-oper = 2 then 
              assign c-ind-tempo-operac:hidden in frame {&frame-name} = yes.
         else do with frame {&frame-name}:

             find first grup-maquina
                  where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.

             assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}
                    v-unidades                           = oper-pad.nr-unidades
                    v-unidades:screen-value              = string(v-unidades).
         end.
      end.
      else do:
          find first operacao
               where rowid(operacao) = v-row-parent no-lock no-error.
          find first item
               where item.it-codigo = operacao.it-codigo no-lock no-error.
      end.      
  &else
      assign c-ind-tempo-operac:hidden in frame {&frame-name} = yes.
  &endif 
****/
  assign tg-tempo-sig:hidden in frame {&frame-name} = yes.

  &if {&bf_man_204} &then
      if  param-global.modulo-sws = false then do:
          assign tg-tempo-sig:hidden in frame {&frame-name} = no.
          disp tg-tempo-sig with frame {&frame-name}.
      end.
  &endif

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

  if avail oper-pad and adm-new-record = no then do: 
     assign v-unidades:screen-value in frame {&frame-name} = string(oper-pad.nr-unidades) 
            cb-un-med-tempo:screen-value    = {ininc/i02in261.i 04 oper-pad.un-med-tempo}.

     if oper-pad.tipo-oper = 2 then do with frame {&frame-name}:
        {utp/ut-liter.i Tempo_Ressuprimento}. 

        assign oper-pad.tempo-maquin:label     = return-value
               oper-pad.numero-homem:hidden    = yes
               oper-pad.tempo-homem:hidden     = yes.               
     end.
     else do:
        &if defined (bf_man_sfc_lc) &then 
        if valid-handle (h_v10in261) then   
           run pi-atualiza-dados in h_v10in261 (input v-unidades:screen-value,
                                                input cb-un-med-tempo:screen-value).
        &endif 

        if adm-new-record = yes then
           disp oper-pad.tempo-homem
                oper-pad.numero-homem.
     end.
  end.

  &if defined (bf_man_sfc_lc) &then  
      assign c-ind-tempo-operac:hidden in frame {&frame-name} = no.

      if avail oper-pad then do:
         if oper-pad.tipo-oper = 2 then 
              assign c-ind-tempo-operac:hidden in frame {&frame-name} = yes.
         else do with frame {&frame-name}:

             find first grup-maquina
                  where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.

             assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}
                    v-unidades                           = oper-pad.nr-unidades
                    v-unidades:screen-value              = string(v-unidades).
         end.
      end.
      else do:
          find first operacao
               where rowid(operacao) = v-row-parent no-lock no-error.
          find first item
               where item.it-codigo = operacao.it-codigo no-lock no-error.
      end.      
  &else
      assign c-ind-tempo-operac:hidden in frame {&frame-name} = yes.
  &endif 


  /* Code placed here will execute AFTER standard behavior.    */
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

  find first param-global no-lock no-error.

  /* Code placed here will execute PRIOR to standard behavior. */

  assign cb-un-med-tempo:list-items in frame {&frame-name} = {ininc/i02in261.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  assign cb-un-med-tempo:screen-value  = {ininc/i02in261.i 04 1}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-handle V-table-Win 
PROCEDURE pi-atualiza-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-viewer as handle.

assign h_v10in261 = p-viewer.

&if defined (bf_man_sfc_lc) &then 
if valid-handle (h_v10in261) then   
   run pi-atualiza-dados in h_v10in261 (input input frame {&frame-name} v-unidades,
                                        input input frame {&frame-name} cb-un-med-tempo).
&endif 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grup-maquina V-table-Win 
PROCEDURE pi-grup-maquina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-grup-maquina like grup-maquina.gm-codigo.

&if defined (bf_man_sfc_lc) &then
    find first grup-maquina
         where grup-maquina.gm-codigo = p-grup-maquina no-lock no-error.

    assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.

&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  if input frame {&frame-name} oper-pad.cod-video <> "" then do:
     find first param-global no-lock no-error.
     if not avail param-global then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input 'show',
                           input 16,
                           input '').
        return 'ADM-ERROR':U.
     end.

     find video 
          where video.cod_video = input frame {&frame-name} oper-pad.cod-video 
          no-lock no-error.
     if avail video then do:
        if video.cod_catal_video <> param-global.cod-catal-video-op then do:
           {include/i-vldprg.i}
           /*** V°deo n∆o consta no cat†logo dos parÉmetros globais. ***/
           run utp/ut-msgs.p (input 'show',
                              input 7596,
                              input string(param-global.cod-catal-video-op)).
           apply 'entry' to oper-pad.cod-video in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.
     end.
     else do:
        {include/i-vldprg.i}
        /*** V°deo n∆o encontrado ***/
        run utp/ut-msgs.p (input 'show',
                           input 7174,
                           input '').
        apply 'entry' to oper-pad.cod-video in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
  end.


  do with frame {&frame-name}:
      if  not (input oper-pad.nr-op-simult > 0) then do:
          {utp/ut-field.i mgind oper-pad nr-op-simult 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to oper-pad.nr-op-simult.
          return 'ADM-ERROR'.
      end.
      if  oper-pad.numero-homem:hidden = no
      and not input v-unidades > 0 then do:
          {utp/ut-field.i mgind oper-pad nr-unidades 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to v-unidades.
          return 'adm-error'.
      end.
      if  oper-pad.numero-homem:hidden = no
      and not input oper-pad.numero-homem > 0 then do:
          {utp/ut-field.i mgind oper-pad numero-homem 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to oper-pad.numero-homem.
          return 'adm-error'.
      end.

      /* Verifica se Ç operac∆o interna pelo oper-pad.tempo-homem:hidden = false e
         se a unidade de tempo Ç Dias */

      if oper-pad.tempo-homem:hidden = false and 
         {ininc/i02in261.i 06 cb-un-med-tempo:screen-value} = 4 then do:
         {include/i-vldprg.i}
          run utp/ut-msgs.p (input 'show',
                             input 17641,
                             input "" ).
          apply 'entry' to cb-un-med-tempo.
          return 'adm-error'. 
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-oper V-table-Win 
PROCEDURE pi-verifica-tipo-oper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter i-tipo-oper like oper-pad.tipo-oper no-undo.

  if i-tipo-oper = 1 then do with frame {&frame-name}:
     {utp/ut-field.i mgind oper-pad tempo-maquin 1}. 

     assign oper-pad.tempo-maquin:label        = return-value
            v-unidades:hidden                  = no
            v-unidades:screen-value            = "100"
            oper-pad.tempo-prepar:hidden       = no
            oper-pad.numero-homem:hidden       = no
            oper-pad.numero-homem:screen-value = "1"
            oper-pad.tempo-homem:hidden        = no.

     enable oper-pad.tempo-maquin
            oper-pad.numero-homem
            oper-pad.tempo-homem
            oper-pad.nr-op-simult. 

     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden in frame {&frame-name}      = no.
     &endif 

  end.
  else do with frame {&frame-name}:
     {utp/ut-liter.i Tempo_Ressuprimento}. 
     assign oper-pad.tempo-maquin:label     = return-value
            oper-pad.numero-homem:hidden    = yes
            oper-pad.tempo-homem:hidden     = yes.
     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden in frame {&frame-name}      = yes.
     &endif                 
  end.   

  if adm-new-record = no then 
        assign cb-un-med-tempo:screen-value = {ininc/i02in261.i 04 oper-pad.un-med-tempo}.    
  ELSE DO: 
     IF cb-un-med-tempo = "1" THEN
        assign cb-un-med-tempo:screen-value = {ininc/i02in261.i 04 1}.
  END.

  &if defined (bf_man_sfc_lc) &then
      if valid-handle(h_v10in261) then     
         run pi-atualiza-dados in h_v10in261 (input v-unidades:screen-value,
                                              input cb-un-med-tempo:screen-value).
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
  {src/adm/template/snd-list.i "oper-pad"}

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

&if defined (bf_man_sfc_lc) &then 
if valid-handle (h_v10in261) then   
   run pi-atualiza-dados in h_v10in261 (input input frame {&frame-name} v-unidades,
                                        input input frame {&frame-name} cb-un-med-tempo).
&endif 

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

