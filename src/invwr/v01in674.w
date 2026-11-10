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
{include/i-prgvrs.i V01IN674 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN674 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var h_v04in597 as handle no-undo.
def var h_v05in597 as handle no-undo.
def var h_v06in597 as handle no-undo.

def var cb-tp-ressup-aux as char.
def var cb-tp-ressup-aux-2 as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES fam-mat-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-mat-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-mat-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-mat-estab.fm-codigo ~
fam-mat-estab.cod-estabel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}fm-codigo ~{&FP2}fm-codigo ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}
&Scoped-define ENABLED-TABLES fam-mat-estab
&Scoped-define FIRST-ENABLED-TABLE fam-mat-estab
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS fam-mat-estab.fm-codigo ~
fam-mat-estab.cod-estabel 
&Scoped-Define DISPLAYED-OBJECTS c-desc-familia c-desc-est cb-tp-ressup ~
l-emite-curva 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS l-emite-curva 

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
DEFINE VARIABLE cb-tp-ressup AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS " "
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-familia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.38.

DEFINE VARIABLE l-emite-curva AS LOGICAL INITIAL yes 
     LABEL "Toggle 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fam-mat-estab.fm-codigo AT ROW 1.21 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-familia AT ROW 1.21 COL 31.57 COLON-ALIGNED NO-LABEL
     c-desc-est AT ROW 2.17 COL 27 COLON-ALIGNED NO-LABEL
     fam-mat-estab.cod-estabel AT ROW 2.21 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cb-tp-ressup AT ROW 3.21 COL 19 COLON-ALIGNED
     l-emite-curva AT ROW 3.29 COL 53.86
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-mat-estab
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
         HEIGHT             = 3.38
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

/* SETTINGS FOR FILL-IN c-desc-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-familia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-emite-curva IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME cb-tp-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-ressup V-table-Win
ON VALUE-CHANGED OF cb-tp-ressup IN FRAME f-main
DO:
  run pi-desabilita in h_v06in597 (input frame {&frame-name} cb-tp-ressup).
  run pi-desabilita in h_v05in597 (input frame {&frame-name} cb-tp-ressup).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-estabel V-table-Win
ON F5 OF fam-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fam-mat-estab.cod-estabel
                     &campo2=c-desc-est
                     &campozoom=cod-estabel
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-estabel V-table-Win
ON LEAVE OF fam-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name} 
                           fam-mat-estab.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.fm-codigo V-table-Win
ON ENTRY OF fam-mat-estab.fm-codigo IN FRAME f-main /* Fam¡lia */
DO:
  run pi-desabilita in h_v06in597 (input frame {&frame-name} cb-tp-ressup).
  run pi-desabilita in h_v05in597 (input frame {&frame-name} cb-tp-ressup).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.fm-codigo V-table-Win
ON F5 OF fam-mat-estab.fm-codigo IN FRAME f-main /* Fam¡lia */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in122.w"
                   &tabela=fam-mat-estab
                   &atributo=fm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.fm-codigo V-table-Win
ON LEAVE OF fam-mat-estab.fm-codigo IN FRAME f-main /* Fam¡lia */
DO:
  {include/leave.i &tabela=familia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-familia
                   &where="familia.fm-codigo = input frame {&frame-name}
                                                  fam-mat-estab.fm-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.fm-codigo IN FRAME f-main /* Fam¡lia */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  if fam-mat-estab.fm-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.       
  if fam-mat-estab.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "fam-mat-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-mat-estab"}

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
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

     if Adm-new-record = no then do:   
        assign cb-tp-ressup-aux = input frame {&FRAME-NAME} cb-tp-ressup
               cb-tp-ressup-aux-2 = cb-tp-ressup-aux.
     end. 

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida»„es */
    /* N’o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    assign fam-mat-estab.tp-ressup = {ininc/i01in598.i 06 cb-tp-ressup-aux}
           fam-mat-estab.curva-abc = l-emite-curva:checked in frame {&frame-name}.    

    /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    if Adm-new-record = no then do:      
       assign cb-tp-ressup-aux-2 = cb-tp-ressup-aux
              cb-tp-ressup = cb-tp-ressup-aux-2.

       disp cb-tp-ressup with frame {&FRAME-NAME}.
    end.   

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

  find first item-mat-estab 
       where item-mat-estab.cod-estabel = fam-mat-estab.cod-estabel
       and   item-mat-estab.fm-codigo   = fam-mat-estab.fm-codigo  no-lock no-error.
  if   avail item-mat-estab then do:
       {utp/ut-field.i mgind fam-mat-estab fm-codigo 1}
        run utp/ut-msgs.p (input "show",
                           input 3,
                           input return-value).   
  end.
  else do:
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
  end.

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
    disable cb-tp-ressup 
            l-emite-curva
            with frame {&frame-name}.
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

   /*if Adm-new-record = yes then*/
      assign cb-tp-ressup-aux = input frame {&FRAME-NAME} cb-tp-ressup.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  if avail fam-mat-estab then do:
      for first familia fields (fm-codigo descricao) where
          familia.fm-codigo = fam-mat-estab.fm-codigo no-lock: end.
      if avail familia then 
          assign c-desc-familia:screen-value in frame {&frame-name} = familia.descricao.
      for first estabelec fields (cod-estabel nome) where
          estabelec.cod-estabel = fam-mat-estab.cod-estabel no-lock: end.          
      if avail estabelec then 
          assign c-desc-est:screen-value in frame {&frame-name} = estabelec.nome.
      
      assign cb-tp-ressup = {ininc/i01in598.i 04 fam-mat-estab.tp-ressup}
             l-emite-curva:checked in frame {&frame-name} = fam-mat-estab.curva-abc.
             
      disp cb-tp-ressup with frame {&FRAME-NAME}.
  end.
  else 
      assign c-desc-familia:screen-value in frame {&frame-name} = " "
             c-desc-est:screen-value in frame {&frame-name} = " "
             cb-tp-ressup:screen-value in frame {&frame-name} = {ininc/i01in598.i 04 1}.
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    enable cb-tp-ressup 
           l-emite-curva
           with frame {&frame-name}.
    if adm-new-record then do:
        enable fam-mat-estab.cod-estabel
               fam-mat-estab.fm-codigo
               with frame {&frame-name}.
        assign l-emite-curva:checked in frame {&frame-name} = yes.
    end.
    else 
        disable fam-mat-estab.cod-estabel
                fam-mat-estab.fm-codigo
                with frame {&frame-name}.
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

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
  {utp/ut-field.i mgind item-mat-estab tp-ressup 1}
  assign cb-tp-ressup:label in frame {&frame-name} = trim(return-value)
         cb-tp-ressup:list-items in frame {&frame-name} = {ininc/i01in598.i 03}.
  {utp/ut-liter.i Emite_Curva_ABC * L}
  assign l-emite-curva:label in frame {&frame-name} = return-value.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-handle  as handle no-undo.
def input parameter h-handle1 as handle no-undo.
def input parameter h-handle2 as handle no-undo.

assign h_v04in597 = h-handle
       h_v05in597 = h-handle1
       h_v06in597 = h-handle2.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */
    
/*/*    Segue um exemplo de valida»’o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/
 if adm-new-record and     
     can-find(first fam-mat-estab where
                    fam-mat-estab.fm-codigo   = input frame {&frame-name} fam-mat-estab.fm-codigo and
                    fam-mat-estab.cod-estabel = input frame {&frame-name} fam-mat-estab.cod-estabel) then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm fam-mat-estab 1}
      run utp/ut-msgs.p (input "show":U, input 8, input return-value).
      apply "entry" to fam-mat-estab.fm-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
 if not can-find (familia where
     familia.fm-codigo = input frame {&frame-name} fam-mat-estab.fm-codigo) then do:
     {include/i-vldprg.i}
     {utp/ut-table.i mgind familia 1}
     run utp/ut-msgs.p (input "show":U, input 56, input return-value).
     apply "entry" to fam-mat-estab.fm-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if not can-find (estabelec where
     estabelec.cod-estabel = input frame {&frame-name} fam-mat-estab.cod-estabel) then do:
     {include/i-vldprg.i}
     {utp/ut-table.i mgadm estabelec 1}
     run utp/ut-msgs.p (input "show":U, input 56, input return-value).
     apply "entry" to fam-mat-estab.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "fam-mat-estab"}

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


