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
{include/i-prgvrs.i V03IN105 2.00.00.012 } /*** 010012 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in105 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-estr-modelo for estr-modelo.
def var rw-modelo as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estr-modelo
&Scoped-define FIRST-EXTERNAL-TABLE estr-modelo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estr-modelo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estr-modelo.quant-usada estr-modelo.Fantasma ~
estr-modelo.fator-perda estr-modelo.tempo-reserv estr-modelo.proporcao ~
estr-modelo.local-montag estr-modelo.observacao estr-modelo.log-quant-fix
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quant-usada ~{&FP2}quant-usada ~{&FP3}~
 ~{&FP1}fator-perda ~{&FP2}fator-perda ~{&FP3}~
 ~{&FP1}tempo-reserv ~{&FP2}tempo-reserv ~{&FP3}~
 ~{&FP1}proporcao ~{&FP2}proporcao ~{&FP3}~
 ~{&FP1}local-montag ~{&FP2}local-montag ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES estr-modelo
&Scoped-define FIRST-ENABLED-TABLE estr-modelo
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS modelo.mo-codigo modelo.descricao ~
estr-modelo.sequencia estr-modelo.it-codigo estr-modelo.quant-usada ~
estr-modelo.Fantasma estr-modelo.fator-perda estr-modelo.tempo-reserv ~
estr-modelo.proporcao estr-modelo.local-montag estr-modelo.observacao estr-modelo.log-quant-fix
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estr-modelo.sequencia ~
estr-modelo.it-codigo 

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
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88.

DEFINE VARIABLE cod-referencia AS CHARACTER FORMAT "X(40)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .88 NO-UNDO.

DEFINE VARIABLE des-referencia AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 27.72 BY .88 NO-UNDO.
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     modelo.mo-codigo AT ROW 1.17 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     modelo.descricao AT ROW 1.17 COL 37.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 47.72 BY .88
     estr-modelo.sequencia AT ROW 2.17 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estr-modelo.it-codigo AT ROW 3.17 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 3.17 COL 37.29 COLON-ALIGNED NO-LABEL
     cod-referencia AT ROW 4.71 COL 19.29 COLON-ALIGNED
     des-referencia AT ROW 4.71 COL 35.29 COLON-ALIGNED NO-LABEL
     estr-modelo.quant-usada AT ROW 5.71 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-un AT ROW 5.71 COL 41.86 COLON-ALIGNED NO-LABEL
     estr-modelo.Fantasma AT ROW 5.83 COL 62.72
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .75
     estr-modelo.fator-perda AT ROW 6.71 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estr-modelo.log-quant-fix AT ROW 6.83 COL 62.72
          VIEW-AS TOGGLE-BOX
          SIZE 17.72 BY .75
     estr-modelo.tempo-reserv AT ROW 7.71 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     estr-modelo.proporcao AT ROW 8.67 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     estr-modelo.local-montag AT ROW 9.67 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 56.43 BY .88
          
     estr-modelo.observacao AT ROW 10.67 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estr-modelo
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
         HEIGHT             = 10.75
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

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-referencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-referencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN modelo.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estr-modelo.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN modelo.mo-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estr-modelo.sequencia IN FRAME f-main
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

/* ************************  Control Triggers  ************************ */


&Scoped-define SELF-NAME cod-referencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-referencia V-table-Win
ON F5 OF cod-referencia IN FRAME f-main /* Referˆncia */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                      &campo=cod-referencia
                      &campozoom = cod-refer
                      &parametros= "run pi-seta-inicial in wh-pesquisa
                      (estr-modelo.it-codigo:screen-value)." }
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-referencia V-table-Win
ON LEAVE OF cod-referencia IN FRAME f-main /* Referˆncia */
DO:
    assign des-referencia = "".
    find ref-item use-index item
    where ref-item.it-codigo = input frame {&frame-name} estr-modelo.it-codigo
      and ref-item.cod-refer = input frame {&frame-name} cod-referencia no-lock no-error.
    if avail ref-item then do:
        find referencia of ref-item no-lock no-error.
            if avail referencia then
                assign des-referencia = referencia.descricao
                       des-referencia:screen-value in frame {&frame-name} = referencia.descricao.
            end. 
    display des-referencia with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-referencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-referencia IN FRAME f-main /* Referˆncia */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME estr-modelo.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-modelo.it-codigo V-table-Win
ON F5 OF estr-modelo.it-codigo IN FRAME f-main /* Item */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=estr-modelo.it-codigo
                     &campozoom=it-codigo
                     &campo2=c-desc-item
                     &campozoom2=desc-item
                     &campo3=c-un
                     &campozoom3=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME estr-modelo.log-quant-fix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-modelo.log-quant-fix V-table-Win
ON VALUE-CHANGED OF estr-modelo.log-quant-fix IN FRAME f-main /* D_MAN002 - Quantidade fixa para componentes de engenharia */
DO:
    if  estr-modelo.log-quant-fix:checked in frame {&frame-name} = YES THEN DO:
        assign  estr-modelo.proporcao:SENSITIVE = FALSE
                estr-modelo.proporcao:SCREEN-VALUE = "100"
                estr-modelo.fator-perda:SENSITIVE = FALSE
                estr-modelo.fator-perda:SCREEN-VALUE = "0".
        
    END.
    ELSE DO:
        assign  estr-modelo.proporcao:SENSITIVE = TRUE
                estr-modelo.fator-perda:SENSITIVE = TRUE.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-modelo.it-codigo V-table-Win
ON LEAVE OF estr-modelo.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i  &tabela=item
                    &atributo-ref=desc-item
                    &variavel-ref=c-desc-item
                    &where="item.it-codigo = input frame {&frame-name} estr-modelo.it-codigo"}

  if avail item then do: 
      /** habilita referencia **/
      if item.tipo-con-est = 4 then do:
          enable cod-referencia with frame {&frame-name}.
          IF cod-referencia:SCREEN-VALUE in frame {&frame-name} = "" THEN DO:
                apply "entry" to cod-referencia in frame {&frame-name}.
                return no-apply.
          END.
      end.
      else do:
           disable cod-referencia with frame {&frame-name}.
            assign cod-referencia:screen-value in frame {&frame-name} = ""
                   des-referencia:screen-value in frame {&frame-name} = "".
      end.
        
      assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item
                    c-un:screen-value in frame {&frame-name} = item.un.
   end.                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-modelo.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-modelo.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-modelo.quant-usada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-modelo.quant-usada V-table-Win
ON LEAVE OF estr-modelo.quant-usada IN FRAME f-main /* Quantidade */
DO:
    IF  estr-modelo.log-quant-fix:CHECKED IN FRAME {&frame-name} = YES THEN DO:
        ASSIGN  estr-modelo.proporcao:SENSITIVE = FALSE
                estr-modelo.proporcao:SCREEN-VALUE = "100"
                estr-modelo.fator-perda:SENSITIVE = FALSE
                estr-modelo.fator-perda:SCREEN-VALUE = "0".
        
    END.
    ELSE DO:
        ASSIGN  estr-modelo.proporcao:SENSITIVE = TRUE
                estr-modelo.fator-perda:SENSITIVE = TRUE.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
   if estr-modelo.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
   if cod-referencia:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "estr-modelo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estr-modelo"}

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

   
   find last param-en no-lock.
   find last b-estr-modelo 
       where b-estr-modelo.mo-codigo = modelo.mo-codigo no-lock no-error.
   if  avail b-estr-modelo then
       estr-modelo.sequencia:screen-value in frame {&frame-name} = string(b-estr-modelo.sequencia + param-en.num-var-estrutura).
   else
       estr-modelo.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-estrutura).

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
  def var c-cod-ref as char format "x(12)" no-undo.
  assign c-cod-ref = input frame {&frame-name} cod-referencia.
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  run pi-validate in this-procedure.
/** Valida referencia **/
    if item.tipo-con-est  = 4 and input frame {&frame-name} cod-referencia <> "" then do:
        if not can-find(first ref-item 
                        where ref-item.it-codigo = input frame {&frame-name} estr-modelo.it-codigo
                          and ref-item.cod-refer = input frame {&frame-name} cod-referencia no-lock) then do:
            {utp/ut-table.i mgind ref-item 1}
            run utp/ut-msgs.p( input "show",input 1947,input return-value).

            apply 'entry' to cod-referencia in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.                     
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
                        find current estr-modelo exclusive-lock no-error.
                        if avail estr-modelo then do:
                assign overlay(estr-modelo.char-2,1,12) = c-cod-ref.
                        end.
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
  
  
   if available modelo then do:
     assign estr-modelo.mo-codigo = modelo.mo-codigo.
   end.
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
  
  if available estr-modelo then do:
     find item where item.it-codigo = estr-modelo.it-codigo no-lock no-error.
     if avail item then
     assign c-desc-item = item.desc-item 
            c-un        = item.un.
     else assign c-desc-item = "":U c-un = "":U .
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
  find item where item.it-codigo = estr-modelo.it-codigo
       no-lock no-error.
    if avail item then do:
       if item.tipo-con-est = 4 then do:
           assign cod-referencia:screen-value in frame {&frame-name} = substring(estr-modelo.char-2,1,12).
           apply "leave" to cod-referencia in frame {&frame-name}.
           enable cod-referencia with frame {&frame-name}.
       end.
       else
           disable cod-referencia with frame {&frame-name}.
    end.
    
  IF AVAIL estr-modelo THEN
      IF  estr-modelo.log-quant-fix:CHECKED IN FRAME {&frame-name} = YES THEN
        ASSIGN  estr-modelo.proporcao:SENSITIVE = FALSE
                estr-modelo.fator-perda:SENSITIVE = FALSE.

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
  
  find modelo where rowid(modelo) = v-row-parent no-error.
  assign rw-modelo = v-row-parent.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply "entry" to estr-modelo.sequencia in frame {&frame-name}.

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
   find modelo where rowid(modelo) = rw-modelo no-lock.
  
   /*Ponha aqui a valida‡Æo de chave duplicada*/
  
   if  estr-modelo.sequencia:sensitive in frame {&frame-name} = yes
   and can-find(b-estr-modelo
          where b-estr-modelo.sequencia = input frame {&frame-name} estr-modelo.sequencia
          and b-estr-modelo.it-codigo = input frame {&frame-name} estr-modelo.it-codigo
          and b-estr-modelo.mo-codigo =                                modelo.mo-codigo) then do:
    {utp/ut-table.i mgind estr-modelo 1}
    run utp/ut-msgs.p( input "show",
                       input 8,
                       input return-value).
    apply 'entry' to estr-modelo.sequencia in frame {&frame-name}.
    return 'adm-error'.    
   end.
  
  
   /* Ponha aqui as demais valida‡äes */
   if input frame {&frame-name} estr-modelo.it-codigo = "" then do:
     {utp/ut-table.i mgind item 1}
      run utp/ut-msgs.p( input "show",
                         input 366,
                         input return-value).
      apply 'entry' to estr-modelo.it-codigo in frame {&frame-name}.
      return 'adm-error'.    
   end.
    
   /*** Verifica se componente da estrutura ‚ obsoleto ***/
   if item.cod-obsoleto >= 3 then do:
      {utp/ut-table.i mgind estr-modelo 1}
      run utp/ut-msgs.p (input "show", 
                         input 2585,
                         input item.it-codigo + "~~" + return-value).
      apply 'entry' to estr-modelo.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.  
   end.

   /*** Verifica se o componente ‚ fracionado ***/ 
   if  item.fraciona = no and 
       input frame {&frame-name} estr-modelo.quant-usada <> integer(input frame {&frame-name} estr-modelo.quant-usada) then do:
       run utp/ut-msgs.p (input 'show',
                         input 1255,
                         input "").
      apply 'entry' to estr-modelo.it-codigo  in frame {&frame-name}.      
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
  {src/adm/template/snd-list.i "estr-modelo"}

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


