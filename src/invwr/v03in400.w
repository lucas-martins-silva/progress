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
{include/i-prgvrs.i V03IN400 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN400 MUT}
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

/* Local Variable Definitions ---        
                               */
def var c-label-aux   as char   no-undo.
def var c-label-item as char format "X(30)" no-undo.
def buffer b-rot-item for rot-item.
DEFINE BUFFER bf-rot-fabric FOR rot-fabric.
DEFINE BUFFER bf-item       FOR item.


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
&Scoped-define EXTERNAL-TABLES rot-item
&Scoped-define FIRST-EXTERNAL-TABLE rot-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rot-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rot-item.data-inicio rot-item.data-termino ~
rot-item.proporcao 
&Scoped-define ENABLED-TABLES rot-item
&Scoped-define FIRST-ENABLED-TABLE rot-item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS rot-item.cod-roteiro rot-item.sequencia ~
rot-item.it-codigo rot-item.data-inicio rot-item.data-termino ~
rot-item.proporcao 
&Scoped-define DISPLAYED-TABLES rot-item
&Scoped-define FIRST-DISPLAYED-TABLE rot-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-rot c-desc-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rot-item.sequencia rot-item.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS rot-item.cod-roteiro rot-item.it-codigo 

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
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rot AS CHARACTER FORMAT "X(256)":U 
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
     rot-item.cod-roteiro AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-rot AT ROW 1.17 COL 37.86 COLON-ALIGNED NO-LABEL
     rot-item.sequencia AT ROW 2.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     rot-item.it-codigo AT ROW 3.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 3.17 COL 37.86 COLON-ALIGNED NO-LABEL
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
     rt-mold AT ROW 4.46 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.71
         WIDTH              = 88.57.
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rot-item.cod-roteiro IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN rot-item.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME rot-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.it-codigo V-table-Win
ON F5 OF rot-item.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=rot-item.it-codigo
                     &campozoom=it-codigo
                     &campo2=c-desc-item
                     &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.it-codigo V-table-Win
ON LEAVE OF rot-item.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name} rot-item.it-codigo"}


      if rot-fabric.data-liberacao <> ? then
         assign rot-item.data-inicio:screen-value in frame {&frame-name} = string(rot-fabric.data-liberacao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rot-item.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rot-item.it-codigo IN FRAME f-main /* Item */
DO:
    apply 'F5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if rot-item.it-codigo:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

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
  
  find rot-fabric where
       rowid (rot-fabric) = v-row-parent no-lock no-error.

  if avail rot-fabric then do:

     find last b-rot-item 
          where b-rot-item.cod-roteiro = rot-fabric.cod-roteiro 
          no-lock no-error.

     if avail b-rot-item then 
        for each  b-rot-item
            where b-rot-item.cod-roteiro = rot-fabric.cod-roteiro no-lock 
            break by b-rot-item.sequencia:
            if last-of(b-rot-item.sequencia) then do:
               assign rot-item.sequencia:screen-value in frame {&frame-name} = string(b-rot-item.sequencia + param-en.num-var-operacao).  
            end.
        end.
     else 
        assign rot-item.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-operacao).
                                                                                             
        assign rot-item.cod-roteiro:screen-value in frame {&frame-name} = rot-fabric.cod-roteiro 
               c-desc-rot:screen-value in frame {&frame-name} = rot-fabric.descricao.            
                
   



  end.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    


IF AVAIL rot-item THEN DO:
  FOR FIRST bf-rot-fabric FIELDS (descricao)
      WHERE bf-rot-fabric.cod-roteiro = rot-item.cod-roteiro NO-LOCK:
      ASSIGN c-desc-rot  = bf-rot-fabric.descricao.

        FOR FIRST bf-item FIELDS (desc-item)
            WHERE bf-item.it-codigo = rot-item.it-codigo NO-LOCK.
            ASSIGN c-desc-item = bf-item.desc-item.
        END.
        
    END.


END.
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if  not frame {&frame-name}:validate() then return 'ADM-ERROR':U.

   /* Valida»’o da data do roteiro */

   if input frame {&frame-name} rot-item.data-inicio > 
      input frame {&Frame-name} rot-item.data-termino then do:
      run utp/ut-msgs.p (input "show",
                         input 137,
                         input "").
      apply 'entry' to rot-item.data-termino in frame {&frame-name}.
      return "ADM-ERROR":U.               
   end.

   /* Ponha aqui a valida»’o de chave duplicada */
   if  ADM-NEW-RECORD = yes then do:
   IF CAN-FIND(FIRST b-rot-item WHERE b-rot-item.it-codigo = input frame {&frame-name} rot-item.it-codigo AND
                                          b-rot-item.cod-roteiro = input frame {&frame-name} rot-item.cod-roteiro) THEN DO:
             {utp/ut-table.i mgind item-roteiro 1}
             run utp/ut-msgs.p (input "show",
                                input 1,
                                input return-value).
             return 'ADM-ERROR':U. 

       END.
   end.

  find rot-fabric where rot-fabric.cod-roteiro = input frame {&FRAME-NAME} rot-item.cod-roteiro no-lock no-error.

  if avail rot-fabric then do:
      if rot-fabric.data-liberacao <> ? then do:
          if input frame {&FRAME-NAME} rot-item.data-inicio < rot-fabric.data-liberacao then do: 

              if rot-fabric.data-liberacao > 
                 input frame {&Frame-name} rot-item.data-termino then do:

                 {utp/ut-liter.i Liberacao *}
                 assign c-label-aux = return-value.              
                 {utp/ut-liter.i T²rmino *}  

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

                 {utp/ut-liter.i Implantacao *}
                 assign c-label-aux = return-value.              
                 {utp/ut-liter.i T²rmino *}              

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-item V-table-Win 
PROCEDURE pi-verifica-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*** Verifica que item n’o seja branco ***/
find item where item.it-codigo = input frame {&frame-name} rot-item.it-codigo no-lock no-error.

   if item.it-codigo = "" then do:
       {utp/ut-table.i mgind item 1}
       run utp/ut-msgs.p (input "show",
                          input 164,
                          input return-value).
       assign rot-item.it-codigo:screen-value in frame {&frame-name} = " ".
       assign c-desc-item:screen-value in frame {&frame-name} = " ".
       return 'adm-error'.                   
   end.

   /*** Verifica que item n’o seja obsoleto ***/
   if item.cod-obsoleto = 4 then do:
       {utp/ut-liter.i roteiro_fabricacao}
       run utp/ut-msgs.p (input "show",
                          input 2585,
                          input item.it-codigo + "~~" + return-value).
       assign rot-item.it-codigo:screen-value in frame {&frame-name} = " ".
       assign c-desc-item:screen-value in frame {&frame-name} = " ".
       return 'adm-error'.
   end.

   /*** Verifica que item n’o possua opera»„es ***/
   find first operacao 
        where operacao.it-codigo = item.it-codigo 
        no-lock no-error.
    if avail operacao then do:
       {utp/ut-table.i mgind item 1}
       assign c-label-item = return-value.
       {utp/ut-table.i mgind operacao 1}
       run utp/ut-msgs.p (input "show",
                          input 6,
                          input c-label-item + "~~" + return-value).
       assign rot-item.it-codigo:screen-value in frame {&frame-name} = " ".
       assign c-desc-item:screen-value in frame {&frame-name} = " ".       
       return 'adm-error'.
end.

return 'ok'.

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

