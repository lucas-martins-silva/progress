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
{include/i-prgvrs.i V08IN201 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN201 MUT}
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
def new global shared var gr-man-eq-tag as rowid no-undo.

/*def new global shared var h-viewer2 as handle no-undo.*/                                
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
&Scoped-define EXTERNAL-TABLES man-eq-tag
&Scoped-define FIRST-EXTERNAL-TABLE man-eq-tag


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-eq-tag.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-eq-tag.cons-dur-man man-eq-tag.dt-inicio ~
man-eq-tag.dt-termino man-eq-tag.parada man-eq-tag.gera-parada ~
man-eq-tag.cd-parada man-eq-tag.gera-pred man-eq-tag.flexib-antec ~
man-eq-tag.flexib-prorr man-eq-tag.dur-man 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-inicio ~{&FP2}dt-inicio ~{&FP3}~
 ~{&FP1}dt-termino ~{&FP2}dt-termino ~{&FP3}~
 ~{&FP1}cd-parada ~{&FP2}cd-parada ~{&FP3}~
 ~{&FP1}flexib-antec ~{&FP2}flexib-antec ~{&FP3}~
 ~{&FP1}flexib-prorr ~{&FP2}flexib-prorr ~{&FP3}~
 ~{&FP1}dur-man ~{&FP2}dur-man ~{&FP3}
&Scoped-define ENABLED-TABLES man-eq-tag
&Scoped-define FIRST-ENABLED-TABLE man-eq-tag
&Scoped-Define ENABLED-OBJECTS RECT-24 RECT-25 RECT-26 rt-mold 
&Scoped-Define DISPLAYED-FIELDS man-eq-tag.cons-dur-man ~
man-eq-tag.dt-inicio man-eq-tag.dt-termino man-eq-tag.parada ~
man-eq-tag.gera-parada man-eq-tag.cd-parada man-eq-tag.gera-pred ~
man-eq-tag.flexib-antec man-eq-tag.flexib-prorr man-eq-tag.dur-man 
&Scoped-Define DISPLAYED-OBJECTS c-gera-parada c-descr-parada 

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
cd-causa-padr||y|mgind.man-eq-tag.cd-causa-padr
cd-equipto||y|mgind.man-eq-tag.cd-equipto
cd-interv-padr||y|mgind.man-eq-tag.cd-interv-padr
cd-manut||y|mgind.man-eq-tag.cd-manut
cd-parada||y|mgind.man-eq-tag.cd-parada
cd-pend-padr||y|mgind.man-eq-tag.cd-pend-padr
cd-sint-padr||y|mgind.man-eq-tag.cd-sint-padr
cd-tipo||y|mgind.man-eq-tag.cd-tipo
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
DEFINE VARIABLE c-descr-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88.

DEFINE VARIABLE c-gera-parada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 24 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 1.88.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 3.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 1.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-eq-tag.cons-dur-man AT ROW 9.5 COL 43.86
          VIEW-AS TOGGLE-BOX
          SIZE 36.29 BY .83
     man-eq-tag.dt-inicio AT ROW 1.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     man-eq-tag.dt-termino AT ROW 1.54 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     c-gera-parada AT ROW 3.17 COL 30 COLON-ALIGNED NO-LABEL
     man-eq-tag.parada AT ROW 3.96 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .75
     man-eq-tag.gera-parada AT ROW 3.96 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Antecipada", 1,
"Prorrogada", 2,
"Parada + Pr¢xima", 3
          SIZE 50 BY .75
     man-eq-tag.cd-parada AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-parada AT ROW 5.5 COL 33 COLON-ALIGNED NO-LABEL
     man-eq-tag.gera-pred AT ROW 9.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 26.72 BY .75
     man-eq-tag.flexib-antec AT ROW 7.38 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-eq-tag.flexib-prorr AT ROW 7.38 COL 41.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-eq-tag.dur-man AT ROW 7.38 COL 71.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     RECT-24 AT ROW 3.42 COL 30
     RECT-25 AT ROW 2.88 COL 3
     RECT-26 AT ROW 6.92 COL 2.86
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-eq-tag
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
         HEIGHT             = 10.25
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-descr-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-gera-parada IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME man-eq-tag.cd-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-parada V-table-Win
ON F5 OF man-eq-tag.cd-parada IN FRAME f-main /* Parada */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in211.w"
                    &tabela=man-eq-tag
                    &atributo=cd-parada}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-parada V-table-Win
ON LEAVE OF man-eq-tag.cd-parada IN FRAME f-main /* Parada */
DO:
  {include/leave.i &tabela=mi-parada
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-parada
                   &where="mi-parada.cd-parada = input frame {&frame-name} 
                                                 man-eq-tag.cd-parada"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-eq-tag.cd-parada IN FRAME f-main /* Parada */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-eq-tag.parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.parada V-table-Win
ON VALUE-CHANGED OF man-eq-tag.parada IN FRAME f-main /* Manuten‡Æo Parada */
DO:
   if  input frame {&frame-name} man-eq-tag.parada = no  then do:
       enable  man-eq-tag.cd-parada   with frame {&frame-name}.
       enable  man-eq-tag.gera-parada with frame {&frame-name}.
       assign  man-eq-tag.cd-parada:screen-value   = ""
               c-descr-parada                     = ""
               man-eq-tag.gera-parada:screen-value = "1".
       disable man-eq-tag.cd-parada   with frame {&frame-name}.
       disable man-eq-tag.gera-parada with frame {&frame-name}.
       display c-descr-parada        with frame {&frame-name}.        
   end.
   else do: 
       enable  man-eq-tag.cd-parada   with frame {&frame-name}.
       enable  man-eq-tag.gera-parada with frame {&frame-name}.
       display c-descr-parada        with frame {&frame-name}. 
   end.
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

  if  man-eq-tag.cd-parada:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  { utp/ut-rtlbl.i mgind man-eq-tag gera-parada c-gera-parada }

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
  {src/adm/template/row-list.i "man-eq-tag"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-eq-tag"}

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
    find man-eq-tag NO-LOCK
        where rowid(man-eq-tag) = gr-man-eq-tag
        no-error.
    if  available man-eq-tag then do:
        find mi-parada
            where mi-parada.cd-parada = man-eq-tag.cd-parada
            no-lock no-error.
        assign c-descr-parada = if avail mi-parada then mi-parada.descricao else "":U.
        disp c-descr-parada with frame {&frame-name}.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

    { utp/ut-rtlbl.i mgind man-eq-tag gera-parada c-gera-parada }

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
  
  if  input frame {&frame-name} man-eq-tag.parada = no  then do:
      disable man-eq-tag.cd-parada   with frame {&frame-name}.
      disable man-eq-tag.gera-parada with frame {&frame-name}.
  end.
  else do: 
      enable  man-eq-tag.cd-parada   with frame {&frame-name}.
      enable  man-eq-tag.gera-parada with frame {&frame-name}.
  end.
  
  find tipo-manut where tipo-manut.cd-tipo =  manut.cd-tipo no-lock no-error.
  if  avail tipo-manut and tipo-manut.tp-manut = 2 then
      enable  man-eq-tag.gera-pred with frame {&frame-name}. 
  else      
      disable man-eq-tag.gera-pred with frame {&frame-name}. 
     
  if  manut.dt-inicio =  tt-manut.dt-inicio                then
      disable man-eq-tag.dt-inicio      with frame {&frame-name}. 
  if  manut.dt-termino  =  tt-manut.dt-termino             then
      disable man-eq-tag.dt-termino     with frame {&frame-name}. 
  if  manut.parada     =  tt-manut.parada                  then
      disable man-eq-tag.parada         with frame {&frame-name}. 
  if  manut.gera-parada =  tt-manut.gera-parada            then
      disable man-eq-tag.gera-parada    with frame {&frame-name}. 
  if  manut.cd-parada =  tt-manut.cd-parada                then
      disable man-eq-tag.cd-parada     with frame {&frame-name}. 
  if  manut.gera-pred  =  tt-manut.gera-pred               then
      disable man-eq-tag.gera-pred      with frame {&frame-name}.
  if  manut.cons-dur-man  =  tt-manut.cons-dur-man         then
      disable man-eq-tag.cons-dur-man   with frame {&frame-name}. 
  if  manut.flexib-antec =  tt-manut.flexib-antec          then
      disable man-eq-tag.flexib-antec   with frame {&frame-name}. 
  if  manut.flexib-prorr  =  tt-manut.flexib-prorr         then
      disable man-eq-tag.flexib-prorr   with frame {&frame-name}. 
  if  manut.dur-man =  tt-manut.dur-man                    then
      disable man-eq-tag.dur-man        with frame {&frame-name}. 

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
    find first tt-manut
        no-lock no-error.
    find manut
        where manut.cd-manut = tt-manut.cd-manut
        no-lock no-error.
    find man-eq-tag
        where rowid(man-eq-tag) = gr-man-eq-tag
        no-lock no-error.

    { utp/ut-rtlbl.i mgind man-eq-tag gera-parada c-gera-parada }

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

    find man-eq-tag
        where rowid(man-eq-tag) = gr-man-eq-tag
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

   if manut.dt-inicio <>  tt-manut.dt-inicio                then
      assign man-eq-tag.dt-inicio:screen-value   in frame {&frame-name} = 
             string(manut.dt-inicio).
   
   if manut.dt-termino  <>  tt-manut.dt-termino             then
      assign man-eq-tag.dt-termino:screen-value   in frame {&frame-name} = 
             string(manut.dt-termino).
   
   if manut.parada <>  tt-manut.parada then 
      assign man-eq-tag.parada:checked  in frame {&frame-name} =
             manut.parada.   
   
   if manut.gera-parada <>  tt-manut.gera-parada                 then
      assign man-eq-tag.gera-parada:screen-value  in frame {&frame-name} = 
             string(manut.gera-parada).
        
   if manut.cd-parada <>  tt-manut.cd-parada                then
      assign man-eq-tag.cd-parada:screen-value   in frame {&frame-name} = 
             string(manut.cd-parada).
   
   if manut.flexib-antec <>  tt-manut.flexib-antec          then
      assign man-eq-tag.flexib-antec:screen-value   in frame {&frame-name} = 
             string(manut.flexib-antec).
   
   if manut.flexib-prorr  <>  tt-manut.flexib-prorr         then
      assign man-eq-tag.flexib-prorr:screen-value   in frame {&frame-name} = 
             string(manut.flexib-prorr).
    
   if manut.dur-man <>  tt-manut.dur-man                    then
      assign man-eq-tag.dur-man:screen-value   in frame {&frame-name} = 
             string(manut.dur-man).

   if manut.gera-pred  <>  tt-manut.gera-pred               then
      assign man-eq-tag.gera-pred:checked  in frame {&frame-name} = 
             manut.gera-pred.
       
   if manut.cons-dur-man  <>  tt-manut.cons-dur-man               then
      assign man-eq-tag.cons-dur-man:checked  in frame {&frame-name} = 
             manut.cons-dur-man.
       

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
 {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
 

  if  ( man-eq-tag.dt-inicio:sensitive in frame {&frame-name}  = yes 
  or    man-eq-tag.dt-termino:sensitive in frame {&frame-name} = yes )
  and ( input frame {&frame-name} man-eq-tag.dt-termino < 
        input frame {&frame-name} man-eq-tag.dt-inicio   )
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      run utp/ut-msgs.p(input "show",
                        input 137,
                        input "").
      apply 'entry' to man-eq-tag.dt-inicio.
      return 'ADM-ERROR'.
  end.    

 
  if  man-eq-tag.cd-parada:sensitive in frame {&frame-name} = yes 
      and (input frame {&frame-name} man-eq-tag.cd-parada = "" 
      or  not can-find (mi-parada where mi-parada.cd-parada = input frame {&frame-name} 
                                                 man-eq-tag.cd-parada))
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind mi-parada 1}
      run utp/ut-msgs.p(input "show",
                        input 1,
                        input return-value).
      apply 'entry' to man-eq-tag.cd-parada.
      return 'ADM-ERROR'.
  end.  

     
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/sndkycas.i "cd-causa-padr" "man-eq-tag" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "man-eq-tag" "cd-equipto"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "man-eq-tag" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "man-eq-tag" "cd-manut"}
  {src/adm/template/sndkycas.i "cd-parada" "man-eq-tag" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "man-eq-tag" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "man-eq-tag" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "man-eq-tag" "cd-tipo"}

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
  {src/adm/template/snd-list.i "man-eq-tag"}

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


