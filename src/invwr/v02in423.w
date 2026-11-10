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
{include/i-prgvrs.i V02IN423 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN423 MUT}
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
def new global shared var gr-mi-taref  as rowid no-undo.
                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-taref-item for taref-item.
def var c-desc-2 like item.desc-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES taref-item
&Scoped-define FIRST-EXTERNAL-TABLE taref-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR taref-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS taref-item.quantidade taref-item.cd-lubr 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}cd-lubr ~{&FP2}cd-lubr ~{&FP3}
&Scoped-define ENABLED-TABLES taref-item
&Scoped-define FIRST-ENABLED-TABLE taref-item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS taref-item.it-codigo taref-item.quantidade ~
taref-item.cd-lubr 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-un c-desc-lubr 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS taref-item.it-codigo 

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
DEFINE VARIABLE c-desc-lubr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "XX":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     taref-item.it-codigo AT ROW 1.13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-descricao AT ROW 1.13 COL 43 COLON-ALIGNED NO-LABEL
     taref-item.quantidade AT ROW 2.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-un AT ROW 3.5 COL 22 COLON-ALIGNED
     taref-item.cd-lubr AT ROW 4.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-desc-lubr AT ROW 4.5 COL 37.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.taref-item
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
         HEIGHT             = 4.75
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-lubr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN taref-item.it-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME taref-item.cd-lubr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.cd-lubr V-table-Win
ON F5 OF taref-item.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in136.w
                       &campo=taref-item.cd-lubr
                       &campozoom=cd-lubr}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.cd-lubr V-table-Win
ON LEAVE OF taref-item.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
  {include/leave.i &tabela=form-lubrif
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-lubr
                   &where="form-lubrif.cd-lubr = input frame {&frame-name} 
                                                  taref-item.cd-lubr"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.cd-lubr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF taref-item.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME taref-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.it-codigo V-table-Win
ON F5 OF taref-item.it-codigo IN FRAME f-main /* Item */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=taref-item.it-codigo
                       &campozoom=it-codigo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.it-codigo V-table-Win
ON LEAVE OF taref-item.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=descricao-2
                   &variavel-ref=c-descricao
                   &where="item.it-codigo = input frame {&frame-name} 
                                                  taref-item.it-codigo"} 
  assign c-desc-2    = c-descricao
         c-descricao = "" .
  
  {include/leave.i &tabela=item
                   &atributo-ref=descricao-1
                   &variavel-ref=c-descricao
                   &where="item.it-codigo = input frame {&frame-name} 
                                                  taref-item.it-codigo"}
  assign c-descricao = c-descricao + c-desc-2.

  {include/leave.i &tabela=item
                   &atributo-ref=un
                   &variavel-ref=c-un
                   &where="item.it-codigo = input frame {&frame-name} 
                                                  taref-item.it-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL taref-item.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF taref-item.it-codigo IN FRAME f-main /* Item */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rt-mold
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if  taref-item.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if  taref-item.cd-lubr:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
    
  {utp/ut-field.i mgind item un 1}
  assign c-un:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "taref-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "taref-item"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes se cadastro complexo........ */
  /* Ponha aqui a valida‡Æo de chave duplicada */

 if not(can-find(first item 
    where item.it-codigo = input frame {&frame-name} taref-item.it-codigo 
    no-lock )) then do:
   {utp/ut-table.i mgind item 1}
   run utp/ut-msgs.p(input "show",
                     input 56,
                     input return-value).
   apply 'entry' to taref-item.it-codigo in frame {&frame-name}.
   return "ADM-ERROR":U.                    
 end.

  find mi-taref
      where rowid(mi-taref) = v-row-parent
      no-error.
  
  if  taref-item.it-codigo:sensitive in frame {&frame-name} = yes 
  and can-find (b-taref-item
                where b-taref-item.cd-manut   =  mi-taref.cd-manut
                and   b-taref-item.cd-tarefa  =  mi-taref.cd-tarefa
                and   b-taref-item.it-codigo  =  input frame {&frame-name} taref-item.it-codigo)
  then do:
      {utp/ut-table.i mgind taref-item 1}
      run utp/ut-msgs.p( input "show",
                         input 1,
                         input return-value).
      apply 'entry' to taref-item.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.  
  
  if  input frame {&frame-name} taref-item.quantidade <= 0 
  then do: 
      {utp/ut-field.i mgind taref-item quantidade 1}
      run utp/ut-msgs.p(input "show",
                        input 36,
                        input return-value).
      apply 'entry' to taref-item.quantidade.
      return 'ADM-ERROR'.
  end.  

  if  taref-item.cd-lubr:sensitive in frame {&frame-name} = yes 
  and (input frame {&frame-name} taref-item.cd-lubr = "" 
      or not can-find (form-lubrif where form-lubrif.cd-lubr = 
                       input frame {&frame-name} taref-item.cd-lubr))
  then do: 
      {utp/ut-table.i mgind form-lubrif 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to taref-item.cd-lubr.
      return 'ADM-ERROR'.
  end.  

  if  taref-item.cd-lubr:sensitive in frame {&frame-name} = yes 
  and ( not can-find (form-lubrif where
                    form-lubrif.cd-lubr = input frame {&frame-name} 
                    taref-item.cd-lubr))
  then do:
      {utp/ut-table.i mgind form-lubrif 1}
      run utp/ut-msgs.p( input "show",
                         input 2,
                         input return-value).
      apply 'entry' to taref-item.cd-lubr in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.  
  
  
  /* Ponha aqui as demais valida‡äes */
  
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */ 
  
  find mi-taref
      where rowid(mi-taref) = v-row-parent
      no-error.
  if  avail mi-taref  then do:
      assign taref-item.cd-manut  = mi-taref.cd-manut
             taref-item.cd-tarefa = mi-taref.cd-tarefa.
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
  if  available taref-item then do:
      find item where item.it-codigo = taref-item.it-codigo no-lock no-error.
      assign c-descricao = if avail item then item.desc-item else "":U.
             c-un = if avail item then item.un else "":U.
      disp c-descricao
           c-un with frame {&frame-name}.
  
      find form-lubrif where form-lubrif.cd-lubr = taref-item.cd-lubr  no-lock no-error.
      assign c-desc-lubr = if avail form-lubrif then form-lubrif.descricao else "":U.
      disp c-desc-lubr with frame {&frame-name}.
      
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
  /* Dispatch standard ADM method.  
                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find tipo-manut where tipo-manut.cd-tipo = manut.cd-tipo no-lock no-error.
  if avail tipo-manut and tipo-manut.tp-manut = 4 then   /*LUBRIFICACAO*/
     enable taref-item.cd-lubr   with frame {&frame-name}.
  else do:
     assign  taref-item.cd-lubr:screen-value  in frame {&frame-name} = " ".
     disable taref-item.cd-lubr  with frame {&frame-name}.
  end.
  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  find first mi-taref where 
       rowid(mi-taref) = gr-mi-taref  no-lock no-error.
  find first manut 
        where manut.cd-manut = mi-taref.cd-manut no-lock no-error.
  find first tipo-manut where tipo-manut.cd-tipo = manut.cd-tipo no-lock no-error.
  if tipo-manut.tp-manut = 4 then
     enable taref-item.cd-lubr with frame {&frame-name}.
  else disable taref-item.cd-lubr with frame {&frame-name}.
 
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  /*{include/i-vldfrm.i} /* Valida‡Æo de dicion rio */*/
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
 
  
 if input frame {&frame-name} taref-item.quantidade <= 0 then do:
    run utp/ut-msgs.p(input "show",
                     input 6722,
                     input "").
    apply 'entry' to taref-item.quantidade in frame {&frame-name}.
    return "ADM-ERROR":U.                    
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
  {src/adm/template/snd-list.i "taref-item"}

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


