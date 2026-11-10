&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmnt            PROGRESS
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
{include/i-prgvrs.i V01IN202 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN202 MUT}
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
def new global shared var v-row-parent as rowid  no-undo.
def new global shared var gr-man-equip as rowid  no-undo.
def new global shared var gr-equipto   as rowid  no-undo.
def new global shared var gr-manut     as rowid  no-undo.

/* Parameters Definitions ---                            */

/* Local Variable Definitions ---                        */
def buffer b-man-equip for man-equip.
def var c-query-hdl    as char    no-undo.
def var h-query-hdl    as handle  no-undo.
def var i-cont         as integer no-undo.
def var c-viewer-hdl   as char    no-undo.
def var h-viewer-hdl   as handle  no-undo.

def var l-copia        as logical no-undo.
def var c-equipto      like mi-eq-tar.cd-equipto.
def var c-manut        like mi-eq-tar.cd-manut.
def var c-resposta     as char.
def buffer b-mi-eq-tar for mi-eq-tar.

{cdp/cd0666.i} /* utilizado na trigger de delete */
{bhp/bh9999.i1} /*definiá∆o da tt-tabela*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-equip
&Scoped-define FIRST-EXTERNAL-TABLE man-equip


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-equip.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-equip.descricao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}
&Scoped-define ENABLED-TABLES man-equip
&Scoped-define FIRST-ENABLED-TABLE man-equip
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS man-equip.cd-equipto man-equip.cd-manut ~
man-equip.descricao 
&Scoped-Define DISPLAYED-OBJECTS c-descr-equipto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS man-equip.cd-equipto man-equip.cd-manut 

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
DEFINE VARIABLE c-descr-equipto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 2.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-equip.cd-equipto AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descr-equipto AT ROW 1.17 COL 43 COLON-ALIGNED NO-LABEL
     man-equip.cd-manut AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     man-equip.descricao AT ROW 2.17 COL 43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-equip
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
         HEIGHT             = 2.29
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

/* SETTINGS FOR FILL-IN c-descr-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-equip.cd-equipto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN man-equip.cd-manut IN FRAME f-main
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

&Scoped-define SELF-NAME man-equip.cd-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equipto V-table-Win
ON F5 OF man-equip.cd-equipto IN FRAME f-main /* Equipamento */
DO:
   assign l-implanta = yes.  /* para o botao implanta do Zoom */

   {include/zoomvar.i &prog-zoom=inzoom/z01in095.w
                      &campo=man-equip.cd-equipto
                      &campo2=c-descr-equipto
                      &campozoom=cd-equipto
                      &campozoom2=descricao}
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equipto V-table-Win
ON LEAVE OF man-equip.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  {include/leave.i &tabela=equipto
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-equipto
                   &where="equipto.cd-equipto = input frame {&frame-name} 
                                                man-equip.cd-equipto"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equipto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-equipto IN FRAME f-main /* Equipamento */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-manut V-table-Win
ON F5 OF man-equip.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
   assign l-implanta = yes.  /* para o botao implanta do Zoom */
   
   {include/zoom.i &prog-zoom="inzoom/z01in205.w"
                      &tabela=man-equip
                      &atributo=cd-manut}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-manut V-table-Win
ON LEAVE OF man-equip.cd-manut IN FRAME f-main /* Manutená∆o */
DO:         
  {include/leave.i &tabela=manut
                   &atributo-ref=descricao
                   &variavel-ref=man-equip.descricao
                   &where="manut.cd-manut = input frame {&frame-name} 
                                                        man-equip.cd-manut"}.
                                                        
  if avail manut then do:
      RUN get-link-handle IN adm-broker-hdl
         (INPUT this-procedure,
          INPUT "Record-source",
          OUTPUT c-query-hdl).
      RUN get-link-handle in adm-broker-hdl
         (INPUT widget-handle(c-query-hdl),
          INPUT "Record-target",
          OUTPUT c-viewer-hdl).
      DO i-cont = 1 To num-entries(c-viewer-hdl):
         assign h-viewer-hdl = widget-handle(entry (i-cont, c-viewer-hdl)).
         if h-viewer-hdl <> this-procedure then
            run pi-dado-inicial in h-viewer-hdl( input rowid(manut) ).
      end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
   APPLY 'F5' to self.
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
  if  man-equip.cd-manut:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-equip.cd-equipto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.

{database/tgin/tdp/tdin202.i}

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
  {src/adm/template/row-list.i "man-equip"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-equip"}

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
    {include/i-valid.i} 

    /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */

    RUN get-attribute IN adm-broker-hdl (INPUT 'adm-new-record').

    if adm-new-record then do:
        
        if can-find (first mi-taref where
                           mi-taref.cd-manut = input frame {&frame-name} man-equip.cd-manut) then do:
            
                /* copia as tarefas do plano padr∆o */
            for each mi-taref where
                     mi-taref.cd-manut   = input frame {&frame-name} man-equip.cd-manut   no-lock:

                create mi-eq-tar.
                assign mi-eq-tar.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                buffer-copy mi-taref to mi-eq-tar.

                /* copia as especialidades da tarefa do plano padr∆o */
                for each taref-esp of mi-taref no-lock:
                    create tar-esp-eq.
                    assign tar-esp-eq.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                    buffer-copy taref-esp to tar-esp-eq.
                end.
                
                /* copia os itens da tarefa do plano padr∆o */
                for each taref-item of mi-taref no-lock:
                    create tar-item-eq.
                    assign tar-item-eq.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                    buffer-copy taref-item to tar-item-eq.
                end.
               
                /* copia equipamento de proteá∆o da tarefa do plano padr∆o */
                for each mi-epi of mi-taref no-lock:
                
                    create mi-epi-eq.
                    assign mi-epi-eq.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                    buffer-copy mi-epi to mi-epi-eq.
                end.            
                           
                /* copia ferramentas da tarefa do plano padr∆o */
                for each taref-ferr of mi-taref no-lock:
                
                    create tar-ferr-eq.
                    assign tar-ferr-eq.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                    buffer-copy taref-ferr to tar-ferr-eq.
                end.
            
                /* copia rede-pert da tarefa do plano padr∆o */
                for each p-taref-esp of mi-taref no-lock:
                
                    create p-tar-esp-eq.
                    assign p-tar-esp-eq.cd-equipto = input frame {&frame-name} man-equip.cd-equipto.
                    buffer-copy p-taref-esp to p-tar-esp-eq.
                end.
            end.             
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  DISABLE  man-equip.cd-manut  with frame {&frame-name}. 
  assign l-copia = yes.
  
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
  
  run pi-valida-eliminacao-man-equip.
  if  return-value <> "ok" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
    if  avail man-equip then do:
        find equipto
            where equipto.cd-equipto = man-equip.cd-equipto
            no-lock no-error.
        assign c-descr-equipto = if avail equipto then equipto.descricao else "":U
               gr-equipto      = if avail equipto then rowid(equipto) else ?.
        disp c-descr-equipto with frame {&frame-name}.
        find manut
            where manut.cd-manut = man-equip.cd-manut
            no-lock no-error.
        assign man-equip.descricao:screen-value = if avail manut then manut.descricao  else "":U.
               gr-manut                         = if avail manut then rowid(manut) else ?.
        disp man-equip.descricao with frame {&frame-name}.         
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    find first param-mi
        no-lock no-error.
    if  avail param-mi and param-mi.formato-cd-equipto <> " " then do:
        assign man-equip.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
    end.

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

    if  avail man-equip then
        assign gr-man-equip = rowid(man-equip)
               c-equipto    = input frame {&frame-name} man-equip.cd-equipto
               c-manut      = input frame {&frame-name} man-equip.cd-manut.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{database/tgin/tdp/tdin202.i1}
   
run cdp/cd0666.w (input table tt-erro).

for each tt-erro:
    delete tt-erro.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-manut V-table-Win 
PROCEDURE pi-passa-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param r-manut2 as rowid.

assign r-manut2 = gr-manut.


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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    /* Ponha aqui a validaá∆o de chave duplicada */
    if  man-equip.cd-equipto:sensitive in frame {&frame-name} = yes 
    and can-find (b-man-equip where b-man-equip.cd-equipto = 
                                    input frame {&frame-name} man-equip.cd-equipto
                              and   b-man-equip.cd-manut = 
                                    input frame {&frame-name} man-equip.cd-manut)
    then do: 
        {include/i-vldprg.i}  /* posiciona pagina */
        {utp/ut-table.i mgind man-equip 1}
        run utp/ut-msgs.p(input "show",
                          input 1,
                          input return-value).
        apply 'entry' to man-equip.cd-equipto.
        return 'ADM-ERROR'.
    end.  

    /* Ponha aqui as demais validaá‰es */

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
  {src/adm/template/snd-list.i "man-equip"}

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


