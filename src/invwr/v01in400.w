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
{include/i-prgvrs.i V01IN400 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN400 MUT}
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
def new global shared var gr-rot-item  as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var rw-item as rowid no-undo.
def var c-label-aux    as char   no-undo.


def buffer b-rot-item for rot-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES rot-item
&Scoped-define FIRST-EXTERNAL-TABLE rot-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rot-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rot-item.data-inicio rot-item.data-termino ~
rot-item.proporcao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data-inicio ~{&FP2}data-inicio ~{&FP3}~
 ~{&FP1}data-termino ~{&FP2}data-termino ~{&FP3}~
 ~{&FP1}proporcao ~{&FP2}proporcao ~{&FP3}
&Scoped-define ENABLED-TABLES rot-item
&Scoped-define FIRST-ENABLED-TABLE rot-item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item ~
rot-item.sequencia rot-item.cod-roteiro rot-item.data-inicio ~
rot-item.data-termino rot-item.proporcao 
&Scoped-Define DISPLAYED-OBJECTS c-rot-fabric-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rot-item.sequencia rot-item.cod-roteiro 

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
DEFINE VARIABLE c-rot-fabric-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item.desc-item AT ROW 1.17 COL 37.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     rot-item.sequencia AT ROW 2.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     rot-item.cod-roteiro AT ROW 3.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-rot-fabric-descricao AT ROW 3.17 COL 37.86 COLON-ALIGNED NO-LABEL
     rot-item.data-inicio AT ROW 4.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     rot-item.data-termino AT ROW 5.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     rot-item.proporcao AT ROW 6.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.rot-item
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
         HEIGHT             = 6.75
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   Size-to-Fit L-To-R, COLUMNS                                          */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-rot-fabric-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rot-item.cod-roteiro IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rot-item.sequencia IN FRAME f-main
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

&Scoped-define SELF-NAME rot-item.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.cod-roteiro V-table-Win
ON F5 OF rot-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in398.w"
                     &campo=rot-item.cod-roteiro
                     &campozoom=cod-roteiro
                     &campo2=c-rot-fabric-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.cod-roteiro V-table-Win
ON LEAVE OF rot-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  {include/leave.i &tabela=rot-fabric
                 &atributo-ref=descricao
                 &variavel-ref=c-rot-fabric-descricao
                 &where="rot-fabric.cod-roteiro = input frame {&frame-name} rot-item.cod-roteiro"}
                 
                 
    find rot-fabric no-lock
        where rot-fabric.cod-roteiro = input frame {&frame-name} rot-item.cod-roteiro no-error.
    if avail rot-fabric and rot-fabric.data-liberacao <> ? then
        assign rot-item.data-inicio:screen-value in frame {&frame-name} = string(rot-fabric.data-libera‡Æo).
        
                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rot-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if rot-item.cod-roteiro:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "rot-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rot-item"}

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
  
  /* Inicializa sequencia do roteiro conforme o intervalo de variacao de */
  /* operacoes na tabela de parametros de engenharia                     */
  find last param-en no-lock no-error.
  if not avail param-en then do:
     run utp/ut-msgs.p (input 'show',
                        input 7597,
                        input '').
     return 'adm-error':U.
  end.

  display today @ rot-item.data-inicio with frame {&frame-name}.
  
  find last b-rot-item where b-rot-item.it-codigo = item.it-codigo no-lock no-error.
  if avail b-rot-item then
     assign rot-item.sequencia:screen-value in frame {&frame-name} = string(b-rot-item.sequencia + param-en.num-var-operacao).
  else
     assign rot-item.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-operacao).
  
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
  
  /*** Procura da tabela pai ***/
  find item where rowid(item) = rw-item no-lock no-error.
  if not avail item then do:
     {utp/ut-table.i mgind item 1}
     run utp/ut-msgs.p (input 'show',
                        input 56,
                        input return-value).
     return 'adm-error':U.
  end.
  
  run pi-validate.
  if return-value = 'ADM-ERROR':U then return 'ADM-ERROR':U.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign rot-item.it-codigo = item.it-codigo.
     
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
  if available rot-item then do:
     find rot-fabric where rot-fabric.cod-roteiro = rot-item.cod-roteiro no-lock no-error.
     assign c-rot-fabric-descricao = if avail rot-fabric then rot-fabric.descricao else "":U.
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
  
  assign rw-item = v-row-parent.
  find item where rowid(item) = rw-item no-lock no-error.
  if not avail item then do:
     {utp/ut-table.i mgind item 1}
     run utp/ut-msgs.p (input 'show',
                        input 56,
                        input return-value).
     return 'adm-error':U.
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
   if  not frame {&frame-name}:validate() then return 'ADM-ERROR':U.
      
   /* Valida‡Æo da data do roteiro */

   if input frame {&frame-name} rot-item.data-inicio > 
      input frame {&Frame-name} rot-item.data-termino then do:
      run utp/ut-msgs.p (input "show",
                         input 137,
                         input "").
      apply 'entry' to rot-item.data-termino in frame {&frame-name}.
      return "ADM-ERROR":U.               
   end.
   
   /*** Verifica se roteiro ‚ ativo ***/
   find rot-fabric no-lock
        where rot-fabric.cod-roteiro = input frame {&frame-name} rot-item.cod-roteiro.
   if rot-fabric.situacao = 2 then do:
      {utp/ut-table.i mgind rot-fabric 1}
      run utp/ut-msgs.p (input "show",
                         input 469,
                         input return-value).
      apply 'entry' to rot-item.cod-roteiro in frame {&frame-name}.    
      return 'ADM-ERROR':U.
   end.    
  
   /* Ponha aqui a valida‡Æo de chave duplicada */
   if  rot-item.sequencia:sensitive in frame {&frame-name} = yes 
   and can-find(b-rot-item where b-rot-item.it-codigo   = item.it-codigo                               
                           and   b-rot-item.cod-roteiro = input frame {&frame-name} rot-item.cod-roteiro) then do:
     {utp/ut-table.i mgind rot-item 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     return 'ADM-ERROR':U. 
  end.
  
  find rot-fabric where rot-fabric.cod-roteiro = input frame {&FRAME-NAME} rot-item.cod-roteiro no-lock no-error.
  
  if avail rot-fabric then do:
      if rot-fabric.data-liberacao <> ? then do:
          if input frame {&FRAME-NAME} rot-item.data-inicio < rot-fabric.data-liberacao then do: 

              if rot-fabric.data-liberacao > 
                 input frame {&Frame-name} rot-item.data-termino then do:
                 
                 {utp/ut-liter.i Libera‡Æo *}
                 assign c-label-aux = return-value.              
                 {utp/ut-liter.i T‚rmino *}  
                 
                 run utp/ut-msgs.p (input "show",
                                    input 89,
                                    input trim(return-value) + " " +
                                          input frame {&Frame-name} rot-item.data-termino + "~~" +
                                          trim(c-label-aux)  + " " + 
                                          string(rot-fabric.data-liberacao,"99/99/9999") ).
                                               
                 apply 'entry' to rot-item.data-termino in frame {&frame-name}.
                 return "ADM-ERROR":U.               
              end.
              else do:
                 {utp/ut-field.i mgind rot-fabric data-liberacao 1}
                 assign c-label-aux = return-value.              
                 {utp/ut-field.i mgind rot-item data-inicio 1}              
                 run utp/ut-msgs.p (input "show",
                                    input 8950,
                                    input return-value + "~~" + 
                                          string(rot-fabric.data-liberacao,"99/99/9999") + "~~" +
                                          c-label-aux).
              end.
          end.
      end.
      else do:
           if input frame {&FRAME-NAME} rot-item.data-inicio < rot-fabric.data-implant then do:

               if rot-fabric.data-implant > 
                  input frame {&Frame-name} rot-item.data-termino then do:

                 {utp/ut-liter.i Implanta‡Æo *}
                 assign c-label-aux = return-value.              
                 {utp/ut-liter.i T‚rmino *}              
                  
                 run utp/ut-msgs.p (input "show",
                                    input 89,
                                    input trim(return-value) + " " +
                                          input frame {&Frame-name} rot-item.data-termino + "~~" +
                                          trim(c-label-aux) + " " + 
                                          string(rot-fabric.data-implant,"99/99/9999")).
                                     
                  apply 'entry' to rot-item.data-termino in frame {&frame-name}.
                  return "ADM-ERROR":U.               
               end.
               else do:
                  {utp/ut-field.i mgind rot-fabric data-implant 1}
                  assign c-label-aux = return-value.
                  {utp/ut-field.i mgind rot-item data-inicio 1}
                  run utp/ut-msgs.p (input "show",
                                     input 8950,
                                     input return-value + "~~" + 
                                           string(rot-fabric.data-implant,"99/99/9999") + "~~" +
                                           c-label-aux).
               end.
           end.
      end.
  end.    
  
 
  return 'ok'.
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
  {src/adm/template/snd-list.i "rot-item"}

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


