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
{include/i-prgvrs.i V01IN673 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN673 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/10/01 -  9:50 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var h_v03in598 as handle no-undo.
def var h_v04in598 as handle no-undo.
def var h_v05in598 as handle no-undo.

def var l-recebe as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-mat-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-mat-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-mat-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-mat-estab.it-codigo ~
item-mat-estab.cod-estabel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}
&Scoped-define ENABLED-TABLES item-mat-estab
&Scoped-define FIRST-ENABLED-TABLE item-mat-estab
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item-mat-estab.it-codigo ~
item-mat-estab.cod-estabel 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-est cb-tp-ressup ~
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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
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

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.38.

DEFINE VARIABLE l-emite-curva AS LOGICAL INITIAL yes 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-mat-estab.it-codigo AT ROW 1.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 1.21 COL 36.86 COLON-ALIGNED NO-LABEL
     item-mat-estab.cod-estabel AT ROW 2.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-est AT ROW 2.17 COL 26.72 COLON-ALIGNED NO-LABEL
     cb-tp-ressup AT ROW 3.21 COL 19.14 COLON-ALIGNED
     l-emite-curva AT ROW 3.25 COL 51.72
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-mat-estab
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
         HEIGHT             = 3.46
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
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
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
ON LEAVE OF cb-tp-ressup IN FRAME f-main
DO:
  run pi-desabilita in h_v04in598 (input frame {&frame-name} cb-tp-ressup).
  run pi-desabilita in h_v05in598 (input frame {&frame-name} cb-tp-ressup).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estabel V-table-Win
ON F5 OF item-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=item-mat-estab.cod-estabel
                     &campo2=c-desc-est
                     &campozoom=cod-estabel
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estabel V-table-Win
ON LEAVE OF item-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name} 
                           item-mat-estab.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.it-codigo V-table-Win
ON ENTRY OF item-mat-estab.it-codigo IN FRAME f-main /* Item */
DO:
  run pi-desabilita in h_v04in598 (input frame {&frame-name} cb-tp-ressup).
  run pi-desabilita in h_v05in598 (input frame {&frame-name} cb-tp-ressup).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.it-codigo V-table-Win
ON F5 OF item-mat-estab.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=item-mat-estab
                   &atributo=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.it-codigo V-table-Win
ON LEAVE OF item-mat-estab.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name}
                                                  item-mat-estab.it-codigo"}
  if avail item and adm-new-record 
      then run pi-mostra-item in h_v03in598 (rowid(item)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.it-codigo IN FRAME f-main /* Item */
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
  if item-mat-estab.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if item-mat-estab.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "item-mat-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-mat-estab"}

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
    assign input frame {&frame-name} cb-tp-ressup.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida»„es */
    /* N’o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    assign item-mat-estab.tp-ressup = {ininc/i01in598.i 06 cb-tp-ressup}
           item-mat-estab.curva-abc =  l-emite-curva /*:checked in frame {&frame-name} /*l-recebe*/*/ .

    /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
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

   if Adm-new-record = yes then
      assign l-recebe = input frame {&FRAME-NAME} l-emite-curva.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  if avail item-mat-estab then do:
      for first item fields (it-codigo desc-item) where
          item.it-codigo = item-mat-estab.it-codigo no-lock: end.
      if avail item then 
          assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item.
      for first estabelec fields (cod-estabel nome) where
          estabelec.cod-estabel = item-mat-estab.cod-estabel no-lock: end.          
      if avail estabelec then 
         assign c-desc-est:screen-value in frame {&frame-name} = estabelec.nome.

      assign cb-tp-ressup:screen-value in frame {&frame-name} = {ininc/i01in598.i 04 item-mat-estab.tp-ressup}
             l-emite-curva:checked in frame {&frame-name} = item-mat-estab.curva-abc.

  end.
  else 
      assign c-desc-item:screen-value in frame {&frame-name} = " "
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
    /* Code placed here will execute AFTER standard behavior.    */
    enable cb-tp-ressup 
           l-emite-curva
           with frame {&frame-name}.
    if adm-new-record then do:
        enable item-mat-estab.cod-estabel
               item-mat-estab.it-codigo
               with frame {&frame-name}.
        assign l-emite-curva:checked in frame {&frame-name} = yes.
    end.
    else 
        disable item-mat-estab.cod-estabel
                item-mat-estab.it-codigo
                with frame {&frame-name}.
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

assign h_v03in598 = h-handle
       h_v04in598 = h-handle1
       h_v05in598 = h-handle2.

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
  if not can-find (item where
     item.it-codigo = input frame {&frame-name} item-mat-estab.it-codigo) then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, input 166, input return-value).
     apply "entry" to item-mat-estab.it-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.
  if not can-find (estabelec where
     estabelec.cod-estabel = input frame {&frame-name} item-mat-estab.cod-estabel) then do:
     {include/i-vldprg.i}
     {utp/ut-table.i mgadm estabelec 1}
     run utp/ut-msgs.p (input "show":U, input 56, input return-value).
     apply "entry" to item-mat-estab.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.
  if adm-new-record and     
     can-find(first item-mat-estab where
                    item-mat-estab.it-codigo   = input frame {&frame-name} item-mat-estab.it-codigo and
                    item-mat-estab.cod-estabel = input frame {&frame-name} item-mat-estab.cod-estabel) then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind item-mat-estab 1}
      run utp/ut-msgs.p (input "show":U, input 1, input return-value).
      apply "entry" to item-mat-estab.it-codigo in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "item-mat-estab"}

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


