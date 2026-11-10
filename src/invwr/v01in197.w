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
{include/i-prgvrs.i V01IN197 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN197 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-lote-prod for lote-prod.

def new global shared var gr-lote-prod as rowid no-undo.
def new global shared var v-row-parent as rowid no-undo.

def var r-lote-prod as rowid no-undo.

def var c-item  as char    no-undo.
def var c-lote  as char    no-undo.
def var i-ordem as integer no-undo.
def var l-inc   as logical no-undo.
def var p-item  like lote-prod.it-codigo.
def var p-lote  like lote-prod.lote.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES lote-prod
&Scoped-define FIRST-EXTERNAL-TABLE lote-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lote-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lote-prod.dt-prim-uso lote-prod.dt-ult-uso ~
lote-prod.qt-produzida 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-prim-uso ~{&FP2}dt-prim-uso ~{&FP3}~
 ~{&FP1}dt-ult-uso ~{&FP2}dt-ult-uso ~{&FP3}~
 ~{&FP1}qt-produzida ~{&FP2}qt-produzida ~{&FP3}
&Scoped-define ENABLED-TABLES lote-prod
&Scoped-define FIRST-ENABLED-TABLE lote-prod
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS lote-prod.it-codigo lote-prod.lote ~
lote-prod.cod-refer lote-prod.nr-ord-produ lote-prod.dt-prim-uso ~
lote-prod.dt-ult-uso lote-prod.qt-produzida 
&Scoped-Define DISPLAYED-OBJECTS c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lote-prod.it-codigo lote-prod.lote ~
lote-prod.nr-ord-produ lote-prod.dt-prim-uso lote-prod.dt-ult-uso ~
lote-prod.qt-produzida 
&Scoped-define ADM-ASSIGN-FIELDS lote-prod.dt-prim-uso lote-prod.dt-ult-uso ~
lote-prod.qt-produzida 
&Scoped-define ADM-MODIFY-FIELDS lote-prod.dt-prim-uso lote-prod.dt-ult-uso ~
lote-prod.qt-produzida 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 38.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lote-prod.it-codigo AT ROW 1.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.17 COL 47.57 COLON-ALIGNED NO-LABEL
     lote-prod.lote AT ROW 2.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     lote-prod.cod-refer AT ROW 3.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     lote-prod.nr-ord-produ AT ROW 4.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     lote-prod.dt-prim-uso AT ROW 5.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     lote-prod.dt-ult-uso AT ROW 6.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     lote-prod.qt-produzida AT ROW 7.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.lote-prod
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
         HEIGHT             = 7.92
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
/* SETTINGS FOR FILL-IN lote-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lote-prod.dt-prim-uso IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-prod.dt-ult-uso IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-prod.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-prod.lote IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-prod.nr-ord-produ IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-prod.qt-produzida IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME lote-prod.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.it-codigo V-table-Win
ON F5 OF lote-prod.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "inzoom/z02in172.w"
                  &tabela    = lote-prod
                  &atributo  = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.it-codigo V-table-Win
ON LEAVE OF lote-prod.it-codigo IN FRAME f-main /* Item */
DO:
/*    find item
 *          where item.it-codigo = input frame {&frame-name} lote-prod.it-codigo 
 *          no-lock no-error.
 *     if  avail item then do:
 *         display item.desc-item @ c-descricao with frame {&frame-name}.
 *         if item.tipo-con-est = 4 then do:
 *            find first lote-prod
 *                 where lote-prod.it-codigo = input frame {&frame-name} lote-prod.it-codigo
 *                 and lote-prod.lote        = input frame {&frame-name} lote-prod.lote no-lock no-error.
 *            if avail lote-prod then do:
 *               display lote-prod.cod-refer with frame {&frame-name}.
 *                  disable lote-prod.cod-refer with frame {&frame-name}.
 *             end.
 *         end.   
 *         else do:
 *          find first saldo-estoq use-index lote 
 *               where saldo-estoq.it-codigo = input frame {&frame-name} lote-prod.it-codigo
 *               and saldo-estoq.lote        = input frame {&frame-name} lote-prod.lote no-lock no-error.
 *          if avail saldo-estoq then do: 
 *             disp saldo-estoq.cod-refer @ lote-prod.cod-refer with frame {&frame-name}.
 *             disable lote-prod.cod-refer with frame {&frame-name}.
 *          end.
 *          else do:
 *              enable lote-prod.cod-refer with frame {&frame-name}.  
 *              disp "" @ lote-prod.cod-refer with frame {&frame-name}.
 *          end.
 *         end.
 *     end.    
 *     else
 *         display "" @ c-descricao with frame {&frame-name}.*/
 
 {include/leave.i &tabela=item
                  &atributo-ref=desc-item
                  &variavel-ref=c-descricao
                  &where="item.it-codigo = input frame {&frame-name} lote-prod.it-codigo"}
 
    find item
          where item.it-codigo = input frame {&frame-name} lote-prod.it-codigo 
          no-lock no-error.
     if  avail item then do:
         if item.tipo-con-est = 4 then 
          assign lote-prod.cod-refer:sensitive in frame {&frame-name} = yes.
         else do:
          assign lote-prod.cod-refer:sensitive in frame {&frame-name} = no
                 lote-prod.cod-refer:screen-value in frame {&frame-name} = "".          
         end. 
     end.
    

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-prod.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-prod.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.lote V-table-Win
ON LEAVE OF lote-prod.lote IN FRAME f-main /* Lote */
DO:
  if avail item then do:
     if item.tipo-con-est = 4 then do:
        find first lote-prod
             where lote-prod.it-codigo = input frame {&frame-name} lote-prod.it-codigo
             and lote-prod.lote        = input frame {&frame-name} lote-prod.lote no-lock no-error.
        if avail lote-prod then do:
           display lote-prod.cod-refer with frame {&frame-name}.
           assign lote-prod.cod-refer:sensitive in frame {&frame-name} = no.
        end.   
        else do:
          find first saldo-estoq use-index lote 
               where saldo-estoq.it-codigo = input frame {&frame-name} lote-prod.it-codigo
               and saldo-estoq.lote        = input frame {&frame-name} lote-prod.lote no-lock no-error.
          if avail saldo-estoq then do: 
             assign lote-prod.cod-refer:screen-value in frame {&frame-name} = saldo-estoq.cod-refer.
             assign lote-prod.cod-refer:sensitive in frame {&frame-name} = no. 
          end.
          else assign lote-prod.cod-refer:sensitive in frame {&frame-name} = yes.
        end.  
     end.  
     else assign lote-prod.cod-refer:screen-value in frame {&frame-name} = ""
                 lote-prod.cod-refer:sensitive in frame {&frame-name} = no.   
  end.        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-prod.nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.nr-ord-produ V-table-Win
ON F5 OF lote-prod.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:
  assign p-item = input frame {&frame-name} lote-prod.it-codigo
         p-lote = input frame {&frame-name} lote-prod.lote.
         
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom  = inzoom/z05in271.w
                     &campo      = lote-prod.nr-ord-produ
                     &campozoom  = nr-ord-produ
                     &parametros = "run pi-seta-inicial in wh-pesquisa (input p-item, input p-lote)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-prod.nr-ord-produ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-prod.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
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
  
  if lote-prod.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if lote-prod.nr-ord-produ:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  
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
  {src/adm/template/row-list.i "lote-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lote-prod"}

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

  if  lote-prod.it-codigo:sensitive in frame {&frame-name} = yes
      then assign l-inc = yes.
  else assign l-inc = no.

  if  not frame {&frame-name}:validate() then
      return 'adm-error'.
   
  find first item where item.it-codigo = input frame {&frame-name} lote-prod.it-codigo no-lock no-error.     
  if not avail item then do: 
     {utp/ut-field.i mgind lote-vend it-codigo 1}
     run utp/ut-msgs.p (input "show", 
                        input 47, 
                        input return-value).
     return 'adm-error'.
  end.
     
  if item.tipo-con-est = 1 then do:
     run utp/ut-msgs.p (input "show", input 944, input "").
     return 'adm-error'.
  end.
  
  if l-inc = yes then do:  
     find first b-lote-prod
          where b-lote-prod.it-codigo    = input frame {&frame-name} lote-prod.it-codigo
            and b-lote-prod.lote         = input frame {&frame-name} lote-prod.lote
            and b-lote-prod.nr-ord-produ = input frame {&frame-name} lote-prod.nr-ord-produ no-lock no-error.
     if  avail b-lote-prod then do:
         run utp/ut-msgs.p (input "show", input 947, input "").
         return 'adm-error'.
      end.
  end.
   
  if input frame {&frame-name} lote-prod.dt-ult-uso < input frame {&frame-name} lote-prod.dt-prim-uso
     then do:
     run utp/ut-msgs.p (input "show", input 946, input "").
     return 'adm-error'.
  end.

  find first lote-comp where
     lote-comp.it-codigo = input frame {&frame-name} lote-prod.it-codigo and
     lote-comp.lote      = input frame {&frame-name} lote-prod.lote and
     lote-comp.cod-refer = input frame {&frame-name} lote-prod.cod-refer no-lock no-error.    
  if avail lote-comp then do:
      run utp/ut-msgs.p (input "show", input 1467, input "").
      return 'adm-error'.
  end.

  find first saldo-estoq where 
     saldo-estoq.it-codigo = input frame {&frame-name} lote-prod.it-codigo and
     saldo-estoq.lote      = input frame {&frame-name} lote-prod.lote
     no-lock no-error.
  if not avail saldo-estoq then do:
     run utp/ut-msgs.p (input "show", input 7549, input "").
     return 'adm-error'.
  end.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  assign r-lote-prod = rowid(lote-prod).
  assign v-row-parent = rowid(lote-prod).
  run cqp/cq9026.w (input r-lote-prod, input l-inc).
  
  assign lote-prod.cod-refer:sensitive in frame {&frame-name} = no.
  
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  assign lote-prod.cod-refer:sensitive in frame {&frame-name} = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  if avail lote-prod then do:
   for each lote-comp where lote-comp.it-codigo    = lote-prod.it-codigo
                        and lote-comp.lote         = lote-prod.lote
                        and lote-comp.nr-ord-produ = lote-prod.nr-ord-produ exclusive-lock:
    delete lote-prod.
   end.
  end.      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

  /* Dispatch standard ADM method.                             */
  
   if available lote-prod then do:
     find item where item.it-codigo = lote-prod.it-codigo
     no-lock no-error.
     if avail item then                                             
        assign c-descricao = if avail item then item.desc-item else "":U.
  end.                                                         
  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  


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
  
  if  avail lote-prod then
      assign gr-lote-prod = rowid(lote-prod).
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "lote-prod"}

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


