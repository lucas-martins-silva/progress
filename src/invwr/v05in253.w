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
{include/i-prgvrs.i V05IN253 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN253 MUT}
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
def new global shared var gr-op-altern as rowid no-undo. 

{cdp/cdcfgman.i}

def var p-unidades             like oper-pad.nr-unidades      no-undo.
def var p-val-operac-item      as decimal format ">,>>9.9999" no-undo.
def var p-cod-un-operac        as char    format "x(2)"       no-undo.
def var p-qtd-tempo-pos-proces as decimal format ">,>>9.99"   no-undo.
def var p-qtd-capac-operac     as decimal format ">,>>>,>>9.9999" no-undo.
def var p-tempo-sig            as log    no-undo.
def var h_v09in253             as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES op-altern
&Scoped-define FIRST-EXTERNAL-TABLE op-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-altern.tempo-prepar op-altern.tempo-maquin ~
op-altern.tempo-homem op-altern.nr-op-simult op-altern.numero-homem 
&Scoped-define ENABLED-TABLES op-altern
&Scoped-define FIRST-ENABLED-TABLE op-altern
&Scoped-Define ENABLED-OBJECTS tg-tempo-sig v-unidades rt-mold-3 
&Scoped-Define DISPLAYED-FIELDS op-altern.tempo-prepar ~
op-altern.tempo-maquin op-altern.tempo-homem op-altern.nr-op-simult ~
op-altern.numero-homem 
&Scoped-define DISPLAYED-TABLES op-altern
&Scoped-define FIRST-DISPLAYED-TABLE op-altern
&Scoped-Define DISPLAYED-OBJECTS tg-tempo-sig v-unidades c-ind-tempo-operac ~
cb-un-med-tempo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-un-med-tempo 

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
DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-ind-tempo-operac AS CHARACTER FORMAT "X(14)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-unidades AS INTEGER FORMAT ">>>>9":U INITIAL 100 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 8.79.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL no 
     LABEL "Tempo Significativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-unidades AT ROW 1.71 COL 24 COLON-ALIGNED
     op-altern.tempo-prepar AT ROW 3.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     op-altern.tempo-maquin AT ROW 4.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-ind-tempo-operac AT ROW 4.42 COL 60 COLON-ALIGNED
     op-altern.tempo-homem AT ROW 5.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     cb-un-med-tempo AT ROW 5.42 COL 60 COLON-ALIGNED
     op-altern.nr-op-simult AT ROW 6.92 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     tg-tempo-sig AT ROW 6.92 COL 62
     op-altern.numero-homem AT ROW 7.92 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     rt-mold-3 AT ROW 1 COL 1
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
         HEIGHT             = 8.79
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-ind-tempo-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-un-med-tempo IN FRAME f-main
   NO-ENABLE 3                                                          */
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
  run pi-atualiza-dados in h_v09in253 (input v-unidades:screen-value,
                                       input cb-un-med-tempo:screen-value).

  &endif    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-unidades
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-unidades V-table-Win
ON LEAVE OF v-unidades IN FRAME f-main
DO:
  &if defined (bf_man_sfc_lc) &then
  run pi-atualiza-dados in h_v09in253 (input v-unidades:screen-value,
                                       input cb-un-med-tempo:screen-value).
  &endif    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind op-altern un-med-tempo 01}
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

  &if defined (bf_man_sfc_lc) &then
      find first operacao
           where rowid(operacao) = v-row-parent no-lock no-error.
      find first item
           where item.it-codigo = operacao.it-codigo no-lock no-error.
  &endif

  do with frame {&frame-name}:
     {utp/ut-field.i mgind operacao tempo-maquin 1}. 

     assign op-altern.tempo-maquin:label       = return-value
            v-unidades:hidden                  = false
            op-altern.tempo-prepar:hidden      = false
            op-altern.numero-homem:hidden      = false
            op-altern.tempo-homem:hidden       = false
            v-unidades:screen-value            = string(100)            
            cb-un-med-tempo:screen-value       = {ininc/i02in253.i 04 1} 
            op-altern.tempo-homem:screen-value = string(0).

  end.

  run pi-seta-tipo-operacao (input 1).
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

  assign p-unidades = input frame {&frame-name} v-unidades.
  &if {&bf_man_204} &then
    assign p-tempo-sig = input frame {&frame-name} tg-tempo-sig.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

  assign op-altern.nr-unidades = p-unidades.

  if op-altern.tipo-oper = 2 then
     assign op-altern.tempo-homem  = 0
            op-altern.numero-homem = 0.  

   &if {&bf_man_204} &then
       &if {&bf_man_205} &then
           assign op-altern.tempo-sig = p-tempo-sig.
       &else
           assign substr(op-altern.char-1,41,1) = if p-tempo-sig = true then "S":U else "N":U.
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
     assign op-altern.tempo-prepar = input frame {&frame-name} op-altern.tempo-prepar
            op-altern.un-med-tempo = {ininc/i02in253.i 06 cb-un-med-tempo:screen-value}.


      if  not (input op-altern.nr-op-simult > 0) then do:
          {utp/ut-field.i mgind op-altern nr-op-simult 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to op-altern.nr-op-simult.
          return 'ADM-ERROR'.
      end.
      if  op-altern.numero-homem:hidden = no
      and not input v-unidades > 0 then do:
          {utp/ut-field.i mgind op-altern nr-unidades 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to v-unidades.
          return 'adm-error'.
      end.
      if  op-altern.numero-homem:hidden = no
      and not input op-altern.numero-homem > 0 then do:
          {utp/ut-field.i mgind op-altern numero-homem 1}
          run utp/ut-msgs.p (input 'show',
                             input 6179,
                             input trim(return-value)).
          apply 'entry' to op-altern.numero-homem.
          return 'adm-error'.
      end.

      /* Verifica se Ç operac∆o interna pelo op-altern.tempo-homem:hidden = false e
         se a unidade de tempo Ç Dias */

      if op-altern.tempo-homem:hidden = false and 
         {ininc/i02in261.i 06 cb-un-med-tempo:screen-value} = 4 then do:
        /* {include/i-vldprg.i} */
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail op-altern and adm-new-record = no then do: 
     assign v-unidades:screen-value in frame {&frame-name} = string(op-altern.nr-unidades) 
            cb-un-med-tempo:screen-value    = {ininc/i02in253.i 04 op-altern.un-med-tempo}.

     if op-altern.tipo-oper = 2 then do with frame {&frame-name}:
        {utp/ut-liter.i Tempo_Ressuprimento}. 

        assign op-altern.tempo-maquin:label     = return-value
               op-altern.numero-homem:hidden    = yes
               op-altern.tempo-homem:hidden     = yes.               
     end.
     else do:
        if avail op-altern then
           disp op-altern.tempo-homem 
                op-altern.numero-homem with frame {&frame-name}.

        &if defined (bf_man_sfc_lc) &then 

        run pi-atualiza-dados in h_v09in253 (input v-unidades:screen-value,
                                             input cb-un-med-tempo:screen-value).
        &endif 
     end.
     &if {&bf_man_204} &then
         if  avail op-altern then do:
             &if {&bf_man_205} &then
                 assign tg-tempo-sig = op-altern.tempo-sig.
             &else
                 assign tg-tempo-sig = if substr(op-altern.char-1,41,1) = "S":U then true else false.
             &endif
         end.
     &endif
  end.

  &if defined (bf_man_sfc_lc) &then
      assign c-ind-tempo-operac:hidden in frame {&frame-name} = no.

      if avail op-altern then do:
         if op-altern.tipo-oper = 2 then 
              assign c-ind-tempo-operac:hidden in frame {&frame-name} = yes.
         else do with frame {&frame-name}:
             find first grup-maquina
                  where grup-maquina.gm-codigo = op-altern.gm-codigo no-lock no-error.

             assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.

             assign v-unidades              = op-altern.nr-unidades
                    v-unidades:screen-value = string(v-unidades).
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

  assign tg-tempo-sig:hidden in frame {&frame-name} = yes.

  &if {&bf_man_204} &then
      find first param-global no-lock no-error.
      if  param-global.modulo-sws = no then do:
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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . 

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

  /* Code placed here will execute PRIOR to standard behavior. */
  assign cb-un-med-tempo:list-items in frame {&frame-name} = {ininc/i02in253.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

assign h_v09in253 = p-viewer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-default-oper-pad V-table-Win 
PROCEDURE pi-default-oper-pad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param rw-oper-pad  as rowid  no-undo.

   do with frame {&frame-name}:
      find oper-pad where rowid(oper-pad) = rw-oper-pad no-lock no-error.
      assign op-altern.tempo-maquin:screen-value    = string(oper-pad.tempo-maquin)
             op-altern.tempo-prepar:screen-value    = string(oper-pad.tempo-prepar)
             op-altern.tempo-homem:screen-value     = string(oper-pad.tempo-homem)
             cb-un-med-tempo:screen-value           = {ininc/i02in253.i 04 oper-pad.un-med-tempo}
             v-unidades:screen-value                = string(oper-pad.nr-unidades)
             op-altern.numero-homem:screen-value    = string(oper-pad.numero-homem)
             op-altern.nr-op-simult:screen-value    = string(oper-pad.nr-op-simult).

      if  oper-pad.tipo-oper = 1 then do with frame {&frame-name}:
          {utp/ut-field.i mgind op-altern tempo-maquin 1}. 

          assign op-altern.tempo-maquin:label      = return-value
                 v-unidades:hidden                 = false
                 op-altern.tempo-prepar:hidden     = false
                 op-altern.numero-homem:hidden     = false
                 op-altern.tempo-homem:hidden      = false.

          enable op-altern.tempo-maquin
                 v-unidades
                 op-altern.tempo-prepar
                 op-altern.numero-homem
                 op-altern.tempo-homem
                 op-altern.nr-op-simult.

          &if defined (bf_man_sfc_lc) &then
              assign c-ind-tempo-operac:hidden in frame {&frame-name}      = no.
              run pi-atualiza-dados in h_v09in253 (input v-unidades:screen-value      in frame {&frame-name},
                                                   input cb-un-med-tempo:screen-value in frame {&frame-name}).
          &endif       
      end.
      else do with frame {&frame-name}:    
         {utp/ut-liter.i Tempo_Ressuprimento}. 
         assign op-altern.tempo-maquin:label     = return-value
                 op-altern.numero-homem:hidden    = true
                 op-altern.tempo-homem:hidden     = true.    
         /***    
         assign cb-un-med-tempo:screen-value = {ininc/i02in253.i 04 1}.
         **/
         &if defined (bf_man_sfc_lc) &then
             assign c-ind-tempo-operac:hidden in frame {&frame-name}      = yes.       
         &endif                       
      end.     
   end. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-oper-pad V-table-Win 
PROCEDURE pi-oper-pad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-nr-oper-pad like oper-pad.nr-oper-pad.

&if defined (bf_man_sfc_lc) &then
    find first oper-pad
         where oper-pad.nr-oper-pad = p-nr-oper-pad no-lock no-error.
       find first grup-maquina
            where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.
       assign c-ind-tempo-operac:screen-value in frame {&frame-name}      = if avail grup-maquina then {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}
                                                                            else {ininc/i06in144.i 04 1}       
              v-unidades:screen-value in frame {&frame-name}              = string(oper-pad.nr-unidades)
              v-unidades                                                  = oper-pad.nr-unidades.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-tipo-operacao V-table-Win 
PROCEDURE pi-seta-tipo-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-tipo-oper like op-altern.tipo-oper no-undo.

   if p-tipo-oper = 1 then do with frame {&frame-name}:
      {utp/ut-field.i mgind op-altern tempo-maquin 1}. 

      assign op-altern.tempo-maquin:label        = return-value
             v-unidades:hidden                   = false
             op-altern.tempo-prepar:hidden       = false
             op-altern.numero-homem:hidden       = false
             op-altern.numero-homem:screen-value = "1"
             op-altern.tempo-homem:hidden        = false.

      enable op-altern.tempo-maquin
             v-unidades
             op-altern.tempo-prepar
             op-altern.numero-homem
             op-altern.tempo-homem
             op-altern.nr-op-simult.

      if avail op-altern then 
         assign cb-un-med-tempo:screen-value = {ininc/i02in253.i 04 op-altern.un-med-tempo}.
      else 
        assign cb-un-med-tempo:screen-value = {ininc/i02in253.i 04 1}.

     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden in frame {&frame-name}      = no.
     &endif       

   end.
   else do with frame {&frame-name}:    
      {utp/ut-liter.i Tempo_Ressuprimento}. 
      assign op-altern.tempo-maquin:label     = return-value
             op-altern.numero-homem:hidden    = true
             op-altern.tempo-homem:hidden     = true.    

      /***       
      assign cb-un-med-tempo:screen-value = {ininc/i02in253.i 04 1}.
      ***/

     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden in frame {&frame-name}      = yes.       
     &endif                       
   end.     

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

