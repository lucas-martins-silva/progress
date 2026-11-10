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
{include/i-prgvrs.i V02IN431 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN431 MUT}
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
def new global shared var v-row-parent  as rowid no-undo.                                
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-rot-fabric as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-rede-pert for rede-pert.
def var rw-item as rowid no-undo.
def var i-num-id-operacao-sucess as integer no-undo.
def var i-num-id-operacao-predec as integer no-undo.

def var c-it-codigo              like item.it-codigo         no-undo.
def var c-cod-roteiro            like rot-fabric.cod-roteiro no-undo.
def var v-row-table              as rowid                    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES rede-pert
&Scoped-define FIRST-EXTERNAL-TABLE rede-pert


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rede-pert.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rede-pert.overlap rede-pert.transporte 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}overlap ~{&FP2}overlap ~{&FP3}~
 ~{&FP1}transporte ~{&FP2}transporte ~{&FP3}
&Scoped-define ENABLED-TABLES rede-pert
&Scoped-define FIRST-ENABLED-TABLE rede-pert
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS rede-pert.op-codigo rede-pert.op-predeces ~
rede-pert.overlap rede-pert.transporte 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-item-rot c-desc-op-codigo ~
c-desc-op-predec cb-un-med-tempo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rede-pert.op-codigo rede-pert.op-predeces ~
cb-un-med-tempo 
&Scoped-define ADM-ASSIGN-FIELDS cb-un-med-tempo 
&Scoped-define ADM-MODIFY-FIELDS cb-un-med-tempo 

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
DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-op-codigo AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-op-predec AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-rot AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-descricao AT ROW 1.25 COL 42 COLON-ALIGNED NO-LABEL
     c-item-rot AT ROW 1.25 COL 27 COLON-ALIGNED
     rede-pert.op-codigo AT ROW 2.17 COL 27.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-op-codigo AT ROW 2.17 COL 35.14 COLON-ALIGNED NO-LABEL
     rede-pert.op-predeces AT ROW 3.17 COL 27.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-op-predec AT ROW 3.17 COL 35.14 COLON-ALIGNED NO-LABEL
     rede-pert.overlap AT ROW 4.54 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     rede-pert.transporte AT ROW 5.54 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     cb-un-med-tempo AT ROW 5.5 COL 39.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.rede-pert
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
         HEIGHT             = 5.79
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-op-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-op-predec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-un-med-tempo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN rede-pert.op-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rede-pert.op-predeces IN FRAME f-main
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

&Scoped-define SELF-NAME rede-pert.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-codigo V-table-Win
ON F5 OF rede-pert.op-codigo IN FRAME f-main /* Opera‡Æo Sucessora */
DO:

  assign l-implanta = yes.

  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=rede-pert.op-codigo
                     &campozoom=op-codigo
                     &campo2=c-desc-op-codigo
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-codigo V-table-Win
ON LEAVE OF rede-pert.op-codigo IN FRAME f-main /* Opera‡Æo Sucessora */
DO:
   {include/leave.i &tabela=operacao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-op-codigo
                    &where="operacao.it-codigo   = c-it-codigo   and
                            operacao.cod-roteiro = c-cod-roteiro and 
                            operacao.op-codigo   = input frame {&frame-name} rede-pert.op-codigo"}  
   if not avail operacao then do:
      {utp/ut-field.i mgind rede-pert op-codigo 1}
      run utp/ut-msgs.p (input "show",
                     input 56,
                     input return-value).
      return NO-APPLY.
   end.                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rede-pert.op-codigo IN FRAME f-main /* Opera‡Æo Sucessora */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rede-pert.op-predeces
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-predeces V-table-Win
ON F5 OF rede-pert.op-predeces IN FRAME f-main /* Opera‡Æo Predecessora */
DO:

  assign l-implanta = yes.


  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=rede-pert.op-predeces
                     &campozoom=op-codigo
                     &campo2=c-desc-op-predec
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-predeces V-table-Win
ON LEAVE OF rede-pert.op-predeces IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
   {include/leave.i &tabela=operacao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-op-predec
                    &where="operacao.it-codigo   = c-it-codigo   and
                            operacao.cod-roteiro = c-cod-roteiro and 
                            operacao.op-codigo   = input frame {&frame-name} rede-pert.op-predeces"}  
   if not avail operacao then do:
      {utp/ut-field.i mgind rede-pert op-predeces 1}
      run utp/ut-msgs.p (input "show",
                     input 56,
                     input return-value).
      return NO-APPLY.
   end.                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rede-pert.op-predeces V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rede-pert.op-predeces IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if rede-pert.op-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if rede-pert.op-predeces:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "rede-pert"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rede-pert"}

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
  def var c-label-op-predeces as char format "X(30)" no-undo.
  def var c-label-op-codigo   as char format "X(30)" no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  find first operacao 
       where operacao.it-codigo   = c-it-codigo
       and   operacao.cod-roteiro = c-cod-roteiro
       and   operacao.op-codigo   = input frame {&frame-name} rede-pert.op-codigo 
       no-lock no-error.
  if not avail operacao then do:
     {utp/ut-field.i mgind rede-pert op-codigo 1}
     run utp/ut-msgs.p (input "show",
                    input 56,
                    input return-value).
     apply "entry" to rede-pert.op-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.                         
  assign i-num-id-operacao-sucess = operacao.num-id-operacao.
                  

  find first operacao 
       where operacao.it-codigo   = c-it-codigo
       and   operacao.cod-roteiro = c-cod-roteiro
       and   operacao.op-codigo   = input frame {&frame-name} rede-pert.op-predeces 
       no-lock no-error.
  if not avail operacao then do:
     {utp/ut-field.i mgind rede-pert op-predeces 1}
     run utp/ut-msgs.p (input "show",
                    input 56,
                    input return-value).
     apply "entry" to rede-pert.op-predeces in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.                         
  assign i-num-id-operacao-predec = operacao.num-id-operacao.
  
  if input frame {&frame-name} rede-pert.op-codigo = input frame {&frame-name} rede-pert.op-predeces then do:
     {utp/ut-field.i mgind rede-pert op-predeces 1}
     assign c-label-op-predeces = return-value.
     {utp/ut-field.i mgind rede-pert op-codigo 1}
     assign c-label-op-codigo = return-value.
     {utp/ut-table.i mgind rede-pert 1}
     run utp/ut-msgs.p (input "show",
                    input 1737,
                    input c-label-op-codigo   + "~~" +
                          c-label-op-predeces + "~~" +
                          return-value).
     apply "entry" to rede-pert.op-predeces in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  if rede-pert.op-codigo:sensitive in frame {&frame-name} 
  and can-find (b-rede-pert 
                where b-rede-pert.num-id-operacao-sucess = i-num-id-operacao-sucess
                and   b-rede-pert.num-id-operacao-predec = i-num-id-operacao-predec) then do:
     {utp/ut-table.i mgind rede-pert 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply "entry" to rede-pert.op-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.                   
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  

  /* Code placed here will execute AFTER standard behavior.    */
  assign rede-pert.un-med-tempo = {ininc/i02in261.i 06 cb-un-med-tempo:screen-value}.
  
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
  assign rede-pert.num-id-operacao-predec = i-num-id-operacao-predec
         rede-pert.num-id-operacao-sucess = i-num-id-operacao-sucess
         rede-pert.it-codigo              = c-it-codigo
         rede-pert.cod-roteiro            = c-cod-roteiro.

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
    
  if avail rede-pert then do:
     /* procurar descricao da operacao (op-codigo) */
     find operacao 
          where operacao.num-id-operacao = rede-pert.num-id-operacao-sucess
          no-lock no-error.
     assign c-desc-op-codigo = if avail operacao then operacao.descricao else "":U.

     /* procurar descricao da operacao predecessora (op-predeces) */
     find operacao 
          where operacao.num-id-operacao = rede-pert.num-id-operacao-predec
          no-lock no-error.
     assign c-desc-op-predec = if avail operacao then operacao.descricao else "":U.
     
     assign cb-un-med-tempo = {ininc/i02in261.i 04 rede-pert.un-med-tempo}.
  end.
  else do with frame {&frame-name}:   
     assign cb-un-med-tempo = {ininc/i02in261.i 04 1}.
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
   assign cb-un-med-tempo:list-items in frame {&frame-name} = {ininc/i02in261.i 03}.
    
  find rede-pert where rowid(rede-pert) = v-row-table no-lock no-error. 
  
  find operacao where operacao.num-id-operacao = rede-pert.num-id-operacao-predec no-lock no-error.
  if avail operacao then do: 
       if operacao.cod-roteiro <> "" then do:              
           find rot-fabric where rot-fabric.cod-roteiro = operacao.cod-roteiro no-lock.
           assign c-item-rot  = rot-fabric.cod-roteiro
                  c-descricao = rot-fabric.descricao.
           {utp/ut-field.i mgind rot-fabric cod-roteiro 1}
           assign c-item-rot:label in frame {&frame-name} = trim(return-value).
       end.
       else do:
           find item where item.it-codigo = rede-pert.it-codigo no-lock.
                assign c-item-rot  = item.it-codigo 
                       c-descricao = item.desc-item.
                {utp/ut-field.i mgind item it-codigo 1}
                assign c-item-rot:label in frame {&frame-name} = trim(return-value).
       end.          
  end.
   
  find item where rowid(item) = v-row-parent no-lock no-error.
  assign c-it-codigo = if avail item then item.it-codigo else "":U.
  if avail item then do:
     assign gr-item       = rowid(item)
            gr-rot-fabric = ?
            c-cod-roteiro = "".
  end.
  else do:
     find rot-fabric where rowid(rot-fabric) = v-row-parent no-lock no-error.
     assign c-cod-roteiro = if avail rot-fabric then rot-fabric.cod-roteiro else "":U.
     if avail rot-fabric then do:
        assign gr-item       = ?
               gr-rot-fabric = rowid(rot-fabric)
               c-it-codigo   = "".
     end.
  end.   
  assign rw-item = v-row-parent.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  
  if return-value = 'ADM-ERROR' then do:
     run utp/ut-msgs.p (input "show",
                        input 1741,
                        input "").
     apply "entry" to rede-pert.op-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.                   
  end.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-var V-table-Win 
PROCEDURE pi-inicializa-var :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter v-row-rede-pert as rowid no-undo.

assign v-row-table = v-row-rede-pert.


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
  {src/adm/template/snd-list.i "rede-pert"}

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


