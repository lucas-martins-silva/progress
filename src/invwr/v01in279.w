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
{include/i-prgvrs.i V01IN279 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN279 MUT}
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
def new global shared var gr-manut as rowid no-undo.

/* Parameters Definitions ---                                           */
def buffer b-p-taref-esp  for p-taref-esp.
def buffer b-mi-taref     for mi-taref.
def buffer b-manut        for manut.

/* Local Variable Definitions ---                                       */

def var c-label-1 as character format "x(40)" no-undo.
def var c-label-2 as character format "x(40)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES p-taref-esp
&Scoped-define FIRST-EXTERNAL-TABLE p-taref-esp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR p-taref-esp.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES taref-item

/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-QUERY-f-main OPEN QUERY f-main FOR EACH taref-item WHERE TRUE /* Join to al-res-op incomplete */ NO-LOCK.
&Scoped-define TABLES-IN-QUERY-f-main taref-item
&Scoped-define FIRST-TABLE-IN-QUERY-f-main taref-item


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS p-taref-esp.overlap 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}overlap ~{&FP2}overlap ~{&FP3}
&Scoped-define ENABLED-TABLES p-taref-esp
&Scoped-define FIRST-ENABLED-TABLE p-taref-esp
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS p-taref-esp.cd-tarefa ~
p-taref-esp.taref-pred p-taref-esp.overlap 
&Scoped-Define DISPLAYED-OBJECTS c-desc-tarefa c-desc-tar-pred 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS p-taref-esp.cd-tarefa ~
p-taref-esp.taref-pred 

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
DEFINE VARIABLE c-desc-tar-pred AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tarefa AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.17.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-main FOR 
      taref-item SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     p-taref-esp.cd-tarefa AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-tarefa AT ROW 1.17 COL 33 NO-LABEL
     p-taref-esp.taref-pred AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-tar-pred AT ROW 2.17 COL 33 NO-LABEL
     p-taref-esp.overlap AT ROW 3.67 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.p-taref-esp
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
         HEIGHT             = 3.75
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

/* SETTINGS FOR FILL-IN c-desc-tar-pred IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-desc-tarefa IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN p-taref-esp.cd-tarefa IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN p-taref-esp.taref-pred IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _TblList          = "mgind.taref-item Where mgind.al-res-op ..."
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

&Scoped-define SELF-NAME p-taref-esp.cd-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.cd-tarefa V-table-Win
ON F5 OF p-taref-esp.cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
   assign l-implanta = no.   
   {include/zoomvar.i &prog-zoom=inzoom/z01in215.w
                      &campo=p-taref-esp.cd-tarefa
                      &campozoom=cd-tarefa}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.cd-tarefa V-table-Win
ON LEAVE OF p-taref-esp.cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
      {include/leave.i &tabela=b-mi-taref
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tarefa
                     &where="b-mi-taref.cd-manut = b-manut.cd-manut
                             and b-mi-taref.cd-tarefa = input frame {&frame-name} p-taref-esp.cd-tarefa"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.cd-tarefa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF p-taref-esp.cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
   apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME p-taref-esp.taref-pred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.taref-pred V-table-Win
ON F5 OF p-taref-esp.taref-pred IN FRAME f-main /* Tarefa Predec */
DO:
   assign l-implanta = no.   
   {include/zoomvar.i &prog-zoom=inzoom/z01in215.w
                      &campo=p-taref-esp.taref-pred
                      &campozoom=cd-tarefa}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.taref-pred V-table-Win
ON LEAVE OF p-taref-esp.taref-pred IN FRAME f-main /* Tarefa Predec */
DO:
      {include/leave.i &tabela=b-mi-taref
                       &atributo-ref=descricao
                       &variavel-ref=c-desc-tar-pred
                       &where="b-mi-taref.cd-manut = b-manut.cd-manut
                               and b-mi-taref.cd-tarefa = input frame {&frame-name} p-taref-esp.taref-pred"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL p-taref-esp.taref-pred V-table-Win
ON MOUSE-SELECT-DBLCLICK OF p-taref-esp.taref-pred IN FRAME f-main /* Tarefa Predec */
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
  
  find first b-manut where rowid(b-manut) = gr-manut no-lock no-error.
  
  if  p-taref-esp.taref-pred:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if  p-taref-esp.cd-taref:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

  
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
  {src/adm/template/row-list.i "p-taref-esp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "p-taref-esp"}

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
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    if not avail b-manut then
       return 'ADM-ERROR':U.

    /* Ponha na pi-validate todas as validaá‰es se complexo */
    if  p-taref-esp.taref-pred:sensitive in frame {&frame-name} = yes
    and can-find (b-p-taref-esp
                  where b-p-taref-esp.cd-manut    =  b-manut.cd-manut
                  and   b-p-taref-esp.cd-tarefa   =  input frame {&FRAME-NAME} p-taref-esp.cd-tarefa
                  and   b-p-taref-esp.taref-pred  =  input frame {&frame-name} p-taref-esp.taref-pred)
    then do:
        {utp/ut-table.i mgind p-taref-esp 1}
        run utp/ut-msgs.p( input "show",
                           input 1,
                           input return-value).
        apply 'entry' to p-taref-esp.cd-tarefa in frame {&frame-name}.
        return 'ADM-ERROR'.
    end.  

    if  input frame {&frame-name} p-taref-esp.cd-tarefa = 
        input frame {&frame-name} p-taref-esp.taref-pred then do:
        {utp/ut-field.i mgind p-taref-esp taref-pred 1}
        assign c-label-1 = return-value.
        {utp/ut-field.i mgind p-taref-esp cd-tarefa 1}
        assign c-label-2 = return-value.
        run utp/ut-msgs.p (input "show",
                           input 6335,    /*Tarefa predecessora n∆o pode igual a tarefa sucessora*/
                           input c-label-1 + "~~" + c-label-2).
        apply 'entry' to p-taref-esp.taref-pred in frame {&frame-name}.
        return 'adm-error'.
    end. 

    find b-mi-taref
        where b-mi-taref.cd-manut  = b-manut.cd-manut
        and   b-mi-taref.cd-tarefa = input frame {&frame-name} p-taref-esp.taref-pred
        no-lock no-error.
    if  not avail b-mi-taref then do:
        {utp/ut-table.i mgind mi-taref 1}
        run utp/ut-msgs.p( input "show",
                           input 3549,    /* Tarefa inexistente */
                           input return-value).
        apply 'entry' to p-taref-esp.taref-pred in frame {&frame-name}.
        return 'ADM-ERROR'.
    end.

    find b-mi-taref
        where b-mi-taref.cd-manut  = b-manut.cd-manut
        and   b-mi-taref.cd-tarefa = input frame {&frame-name} p-taref-esp.cd-tarefa
        no-lock no-error.
    if  not avail b-mi-taref then do:
        {utp/ut-table.i mgind mi-taref 1}
        run utp/ut-msgs.p( input "show",
                           input 3549,    /* Tarefa inexistente */
                           input return-value).
        apply 'entry' to p-taref-esp.cd-tarefa in frame {&frame-name}.
        return 'ADM-ERROR'.
    end.
    
   
    /* Validaá∆o loop Rede PERT */
    
    if p-taref-esp.taref-pred:sensitive in frame {&frame-name} = yes then do:
       find b-mi-taref where 
            b-mi-taref.cd-tarefa = input frame {&FRAME-NAME} p-taref-esp.taref-pred and 
            b-mi-taref.cd-manut  = b-manut.cd-manut no-lock no-error.
       if  avail b-mi-taref then do:
           run pi-loop-rede-pert(rowid(b-mi-taref)).

           if  return-value = 'loop':U then do:
               {utp/ut-table.i mgind p-taref-esp 1}         
               run utp/ut-msgs.p( input "show",
                                  input 18152, /* Inclus∆o provoca loop */   
                                  input return-value + "~~" +
                                        input frame {&FRAME-NAME} p-taref-esp.cd-tarefa + "~~" +
                                        input frame {&FRAME-NAME} p-taref-esp.taref-pred).
             
               return 'ADM-ERROR'.   
           end.    
       end.
    end.
    

    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
    nem na PI-validate. */  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  

     if avail p-taref-esp then
        assign p-taref-esp.cd-manut = b-manut.cd-manut.

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
    if  avail p-taref-esp then DO:
        find mi-taref
            where mi-taref.cd-manut  = b-manut.cd-manut
            and   mi-taref.cd-tarefa = p-taref-esp.taref-pred
            no-lock no-error.
        assign c-desc-tar-pred = if avail mi-taref then mi-taref.descricao else "":U.
        
        find b-mi-taref
             where b-mi-taref.cd-manut  = b-manut.cd-manut
             and   b-mi-taref.cd-tarefa = p-taref-esp.cd-tarefa no-lock no-error.
        assign c-desc-tarefa = if avail b-mi-taref then b-mi-taref.descricao else "":U.
    END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter v-row-parent-externo as rowid no-undo.
  
  assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-loop-rede-pert V-table-Win 
PROCEDURE pi-loop-rede-pert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-rw-mi-taref as rowid no-undo.

    def buffer b2-mi-taref for mi-taref.
    def buffer b3-mi-taref for mi-taref.                   
    def buffer b-p-taref-esp for p-taref-esp.
 
 
    find b2-mi-taref where rowid(b2-mi-taref) = p-rw-mi-taref no-lock.
    for each b-p-taref-esp where b-p-taref-esp.cd-tarefa = b2-mi-taref.cd-tarefa and
                                 b-p-taref-esp.cd-manut  = b2-mi-taref.cd-manut  no-lock:
        /*** Teste de loop de rede-pert ***/
        if b-p-taref-esp.taref-pred = input frame {&FRAME-NAME} p-taref-esp.cd-tarefa then do:
             return 'loop'.
        end.   
        find b3-mi-taref where b3-mi-taref.cd-tarefa = b-p-taref-esp.taref-pred and 
                               b3-mi-taref.cd-manut  = b-p-taref-esp.cd-manut no-lock. 
 
        run pi-loop-rede-pert(rowid(b3-mi-taref)).
            if return-value = 'loop':U then do:
                 return 'loop'.
            end.
    end.


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
   
   /*Segue um exemplo de validaá∆o de programa 
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
  {src/adm/template/snd-list.i "p-taref-esp"}
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


