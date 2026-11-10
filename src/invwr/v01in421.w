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
{include/i-prgvrs.i V01IN421 2.00.00.008}  /*** 010008 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN421 MUT}
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
{cdp/cdcfgmnt.i}

&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.
def new global shared var gr-mi-taref  as rowid no-undo.
                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-taref-esp for taref-esp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES taref-esp
&Scoped-define FIRST-EXTERNAL-TABLE taref-esp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR taref-esp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS taref-esp.nr-homens taref-esp.defasagem ~
taref-esp.nr-dias-dur taref-esp.tempo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-homens ~{&FP2}nr-homens ~{&FP3}~
 ~{&FP1}defasagem ~{&FP2}defasagem ~{&FP3}~
 ~{&FP1}nr-dias-dur ~{&FP2}nr-dias-dur ~{&FP3}~
 ~{&FP1}tempo ~{&FP2}tempo ~{&FP3}
&Scoped-define ENABLED-TABLES taref-esp
&Scoped-define FIRST-ENABLED-TABLE taref-esp
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold i-aloc-minima i-aloc-maxima ~
RECT-1 i-tipo-espec RECT-2 i-tipo-tempo 
&Scoped-Define DISPLAYED-FIELDS taref-esp.tp-especial taref-esp.nr-homens ~
taref-esp.defasagem taref-esp.nr-dias-dur taref-esp.tempo 
&Scoped-Define DISPLAYED-OBJECTS c-descricao i-aloc-minima i-aloc-maxima ~
i-tipo-espec i-tipo-tempo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS taref-esp.tp-especial 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-espec AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-tipo-tempo AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE i-aloc-maxima AS DECIMAL FORMAT "->>>>>,>>9.9999" INITIAL 0 
     LABEL "Aloca‡Æo M xima":R18 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE i-aloc-minima AS DECIMAL FORMAT "->>>>>,>>9.9999" INITIAL 0 
     LABEL "Aloca‡Æo M¡nima":R18 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88.

DEFINE VARIABLE i-tipo-espec AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Normal", 1,
"Apoio", 2
     SIZE 25.43 BY .83.

DEFINE VARIABLE i-tipo-tempo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Individual", 1,
"Total", 2
     SIZE 22.14 BY .83.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 10.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     taref-esp.tp-especial AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-descricao AT ROW 1.17 COL 34.57 COLON-ALIGNED NO-LABEL
     taref-esp.nr-homens AT ROW 2.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     taref-esp.defasagem AT ROW 3.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     taref-esp.nr-dias-dur AT ROW 4.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     taref-esp.tempo AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     i-aloc-minima AT ROW 6.5 COL 20 COLON-ALIGNED HELP
          "Aloca‡Æo m¡nima di ria da Especialidade"
     i-aloc-maxima AT ROW 7.5 COL 20 COLON-ALIGNED
     i-tipo-espec AT ROW 9.25 COL 23 NO-LABEL
     i-tipo-tempo AT ROW 11.17 COL 23.29 HELP
          "Tipo de Tempo da Especialidade" NO-LABEL
     c-tipo-espec AT ROW 8.5 COL 18 COLON-ALIGNED NO-LABEL
     c-tipo-tempo AT ROW 10.5 COL 18 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
     RECT-1 AT ROW 8.75 COL 18
     RECT-2 AT ROW 10.75 COL 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.taref-esp
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
         HEIGHT             = 11.5
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-espec IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-tipo-espec:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tipo-tempo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-tipo-tempo:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-aloc-maxima:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-aloc-minima:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-tipo-espec:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-tipo-tempo:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-1:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN taref-esp.tp-especial IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME taref-esp.tp-especial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-esp.tp-especial V-table-Win
ON F5 OF taref-esp.tp-especial IN FRAME f-main /* Especialidade */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in209.w
                       &campo=taref-esp.tp-especial
                       &campozoom=tp-especial}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-esp.tp-especial V-table-Win
ON LEAVE OF taref-esp.tp-especial IN FRAME f-main /* Especialidade */
DO:
  {include/leave.i &tabela=mi-espec
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao
                   &where="mi-espec.tp-especial = input frame {&frame-name} 
                                                  taref-esp.tp-especial"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-esp.tp-especial V-table-Win
ON MOUSE-SELECT-DBLCLICK OF taref-esp.tp-especial IN FRAME f-main /* Especialidade */
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
  
  if  taref-esp.tp-especial:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  
  &if defined (bf_mnt_ems203)  &then 
     {utp/ut-field.i mgind taref-esp aloc-minima 1}
     assign i-aloc-minima:label in frame {&FRAME-NAME} = trim(return-value).
  
     {utp/ut-field.i mgind taref-esp aloc-maxima 1}
     assign i-aloc-maxima:label in frame {&FRAME-NAME} = trim(return-value).

  &endif 
  
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
  {src/adm/template/row-list.i "taref-esp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "taref-esp"}

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

  &if defined (bf_mnt_ems203)  &then 
  
     assign i-aloc-minima = 0.25
            i-aloc-minima:screen-value in frame {&FRAME-NAME} = string(0.25)
            i-tipo-espec  = 1
            i-tipo-espec:screen-value  in frame {&FRAME-NAME} = "1"
            i-tipo-tempo  = 1
            i-tipo-tempo:screen-value  in frame {&FRAME-NAME} = "1".
            
     find mi-taref where rowid(mi-taref) = gr-mi-taref NO-LOCK no-error.
     if avail mi-taref then
        assign taref-esp.tempo:screen-value in frame {&FRAME-NAME} = string(mi-taref.tempo)
               i-aloc-maxima:screen-value in frame {&FRAME-NAME} = "24".
           
    {utp/ut-rtlbl.i mgind taref-esp tipo-espec c-tipo-espec}
    {utp/ut-rtlbl.i mgind taref-esp tipo-tempo c-tipo-tempo}
  &endif    



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
   {include/i-vldfrm.i}
  /* Ponha na pi-validate todas as valida‡äes */

  find mi-taref
      where rowid(mi-taref) = gr-mi-taref NO-LOCK no-error.

  if  taref-esp.tp-especial:sensitive in frame {&frame-name} = yes 
  and input frame {&frame-name} taref-esp.tp-especial = " "
  then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind taref-esp 1}
      run utp/ut-msgs.p( input "show",
                         input 164,
                         input return-value).
      apply 'entry' to taref-esp.tp-especial in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.  

  if  taref-esp.tp-especial:sensitive in frame {&frame-name} = yes 
  and can-find (b-taref-esp
                where b-taref-esp.cd-manut    = mi-taref.cd-manut
                and   b-taref-esp.cd-tarefa   = mi-taref.cd-tarefa
                and   b-taref-esp.tp-especial = input frame {&frame-name} taref-esp.tp-especial)
  then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind taref-esp 1}
      run utp/ut-msgs.p( input "show",
                         input 1,
                         input return-value).
      apply 'entry' to taref-esp.tp-especial in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.

  find mi-espec
      where mi-espec.tp-especial = input frame {&frame-name} taref-esp.tp-especial
      no-lock no-error.
  if  not avail mi-espec then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind mi-espec 1}
      run utp/ut-msgs.p( input "show",
                         input 3549,    /* Especialidade inexistente */
                         input return-value).
      apply 'entry' to taref-esp.tp-especial in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.

  if  input frame {&frame-name} taref-esp.nr-homens <= 0 then do: 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind taref-esp nr-homens 1}
      run utp/ut-msgs.p(input "show",
                        input 36,
                        input return-value).
      apply 'entry' to taref-esp.nr-homens.
      return 'ADM-ERROR'.
  end.

  if  input frame {&frame-name} taref-esp.defasagem < 0 then do: 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind taref-esp defasagem 1}
      run utp/ut-msgs.p(input "show",
                        input 36,
                        input return-value).
      apply 'entry' to taref-esp.defasagem.
      return 'ADM-ERROR'.
  end.

  if  input frame {&frame-name} taref-esp.nr-dias-dur <= 0 then do: 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind taref-esp nr-dias-dur 1}
      run utp/ut-msgs.p(input "show",
                        input 36,
                        input return-value).
      apply 'entry' to taref-esp.nr-dias-dur.
      return 'ADM-ERROR'.
  end.

  if  input frame {&frame-name} taref-esp.tempo <= 0 then do: 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind taref-esp tempo 1}
      run utp/ut-msgs.p(input "show",
                        input 36,
                        input return-value).
      apply 'entry' to taref-esp.tempo.
      return 'ADM-ERROR'.
  end.
  
  &if defined (bf_mnt_ems203)  &then
  
     if  input frame {&frame-name} i-aloc-minima <= 0 then do: 
         {include/i-vldprg.i}
         {utp/ut-field.i mgind taref-esp aloc-minima 1}
         run utp/ut-msgs.p(input "show",
                           input 36,
                           input return-value).
         apply 'entry' to i-aloc-minima.
         return 'ADM-ERROR'.
     end.
     
     if  input frame {&frame-name} i-aloc-minima > input frame {&frame-name} taref-esp.tempo then do: 
         {include/i-vldprg.i}
         {utp/ut-field.i mgind taref-esp aloc-minima 1}
         run utp/ut-msgs.p(input "show",
                           input 508,
                           input return-value + '~~' + taref-esp.tempo:label in frame {&FRAME-NAME}).
         apply 'entry' to i-aloc-minima.
         return 'ADM-ERROR'.
     end.
     
     if  input frame {&frame-name} i-aloc-maxima < input frame {&frame-name} i-aloc-minima then do: 
         {include/i-vldprg.i} 
         {utp/ut-field.i mgind taref-esp aloc-maxima 1}
         run utp/ut-msgs.p(input "show",
                           input 1207,
                           input return-value + '~~' + i-aloc-minima:label in frame {&FRAME-NAME}).
         apply 'entry' to i-aloc-maxima.
         return 'ADM-ERROR'.
     end.
     
     assign  input frame {&FRAME-NAME} i-aloc-minima
             input frame {&FRAME-NAME} i-aloc-maxima 
             input frame {&FRAME-NAME} i-tipo-espec
             input frame {&FRAME-NAME} i-tipo-tempo.

  &endif   
             
  /* Ponha aqui as demais valida‡äes */

  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */ 

  /* Code placed here will execute AFTER standard behavior.    */
  
  if  available  mi-taref  then do:
      assign taref-esp.cd-manut  = mi-taref.cd-manut
             taref-esp.cd-tarefa = mi-taref.cd-tarefa.
  end.
  
  &if defined (bf_mnt_ems203)  &then
     assign taref-esp.aloc-minima = input frame {&FRAME-NAME} i-aloc-minima
            taref-esp.aloc-maxima = input frame {&FRAME-NAME} i-aloc-maxima 
            taref-esp.tipo-espec  = input frame {&FRAME-NAME} i-tipo-espec
            taref-esp.tipo-tempo  = input frame {&FRAME-NAME} i-tipo-tempo .
  &endif



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

   
    if  available taref-esp then do:
        find mi-espec
            where mi-espec.tp-especial = taref-esp.tp-especial
            no-lock no-error.
        assign c-descricao = if avail mi-espec then mi-espec.descricao else "":U.
        disp c-descricao with frame {&frame-name}.
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
  
  &if defined (bf_mnt_ems203)  &then  
    
     assign i-aloc-minima:hidden in frame {&FRAME-NAME} = no
            i-aloc-maxima:hidden in frame {&FRAME-NAME} = no
            i-tipo-espec:hidden in frame {&FRAME-NAME}  = no
            c-tipo-espec:hidden in frame {&FRAME-NAME}  = no
            i-tipo-tempo:hidden in frame {&FRAME-NAME}  = no
            c-tipo-tempo:hidden in frame {&FRAME-NAME}  = no
            RECT-1:hidden in frame {&FRAME-NAME}        = no
            RECT-2:hidden in frame {&FRAME-NAME}        = no.
            
  &endif          
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined (bf_mnt_ems203)  &then  
     {utp/ut-rtlbl.i mgind taref-esp tipo-espec c-tipo-espec}
     assign i-tipo-espec:radio-buttons in frame {&frame-name} = {ininc/i01in421.i 07}.
     {utp/ut-rtlbl.i mgind taref-esp tipo-tempo c-tipo-tempo}
     assign i-tipo-tempo:radio-buttons in frame {&frame-name} = {ininc/i02in421.i 07}.
  &else
     assign rt-mold:height in frame {&FRAME-NAME} = 4.13.
  &endif
  

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
  
  &if defined (bf_mnt_ems203)  &then 
  
     if avail taref-esp then
        assign i-aloc-minima = taref-esp.aloc-minima
               i-aloc-maxima = taref-esp.aloc-maxima
               i-tipo-espec  = taref-esp.tipo-espec
               i-tipo-tempo  = taref-esp.tipo-tempo.
  
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  &endif 

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
  {src/adm/template/snd-list.i "taref-esp"}

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


