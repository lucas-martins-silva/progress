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
{include/i-prgvrs.i V31IN245 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V31IN245 MUT}
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

def var l-gera-dup      as logical no-undo. /*Vari vel Provis¢ria*/
def var c-tipo          as char    no-undo.
def var i-cod-mens-ant  as int     no-undo.

def var l-novo-reg      as logical initial no.
def var l-terceiros     as logical no-undo.
def var l-consum-final  as logical no-undo.
def var l-emite-duplic  as logical no-undo.
def var l-setou-campo   as logical no-undo.
def var l-entfut        as logical no-undo.
def var c-destino-icm   as char    no-undo.
def var i-destino-icm   as integer no-undo.
def var c-nat-oper      as char    no-undo.
def var c-tipo-nat      as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.cod-esp natur-oper.especie-doc ~
natur-oper.cod-mensagem natur-oper.tp-rec-desp natur-oper.cod-canal-venda 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-esp ~{&FP2}cod-esp ~{&FP3}~
 ~{&FP1}especie-doc ~{&FP2}especie-doc ~{&FP3}~
 ~{&FP1}cod-mensagem ~{&FP2}cod-mensagem ~{&FP3}~
 ~{&FP1}tp-rec-desp ~{&FP2}tp-rec-desp ~{&FP3}~
 ~{&FP1}cod-canal-venda ~{&FP2}cod-canal-venda ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS natur-oper.cod-esp natur-oper.especie-doc ~
natur-oper.cod-mensagem natur-oper.tp-rec-desp natur-oper.cod-canal-venda 
&Scoped-Define DISPLAYED-OBJECTS c-desc-cod-esp cb-mercado ~
c-desc-cod-mensagem c-desc-tp-rec-desp c-desc-canal-venda cb-uso ~
cb-tipo-trib 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-mercado cb-uso cb-tipo-trib 

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
DEFINE VARIABLE cb-mercado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 19 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-trib AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 19 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE cb-uso AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 19 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-desc-canal-venda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cod-esp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cod-mensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tp-rec-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71.14 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.cod-esp AT ROW 1.38 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc-cod-esp AT ROW 1.38 COL 29.57 COLON-ALIGNED NO-LABEL
     natur-oper.especie-doc AT ROW 2.38 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cb-mercado AT ROW 3.38 COL 24.14 COLON-ALIGNED
     natur-oper.cod-mensagem AT ROW 4.38 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-cod-mensagem AT ROW 4.38 COL 29 COLON-ALIGNED NO-LABEL
     natur-oper.tp-rec-desp AT ROW 5.38 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-tp-rec-desp AT ROW 5.38 COL 29 COLON-ALIGNED NO-LABEL
     natur-oper.cod-canal-venda AT ROW 6.38 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-canal-venda AT ROW 6.38 COL 29 COLON-ALIGNED NO-LABEL
     cb-uso AT ROW 7.38 COL 24.14 COLON-ALIGNED
     cb-tipo-trib AT ROW 8.38 COL 24.14 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 9
         WIDTH              = 71.14.
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

/* SETTINGS FOR FILL-IN c-desc-canal-venda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cod-esp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cod-mensagem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tp-rec-desp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-mercado IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-trib IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-uso IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME natur-oper.cod-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON F5 OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
    assign l-implanta = yes.

    {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                       &campo=natur-oper.cod-canal-venda
                       &campozoom=cod-canal-venda}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON LEAVE OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
    {include/leave.i &tabela=canal-venda
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-canal-venda
                     &where="canal-venda.cod-canal-venda = input frame {&frame-name} natur-oper.cod-canal-venda}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON F5 OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
  assign l-implanta = yes.

  {include/zoomvar.i &prog-zoom=adzoom/z01ad103.w
                     &campo=natur-oper.cod-esp
                     &campozoom=cod-esp}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON LEAVE OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
  
  if input frame {&frame-name} natur-oper.cod-esp = " " then
     assign c-desc-cod-esp:screen-value in frame {&frame-name} = " ".
  else do:
      find first esp-doc where
                 esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp no-lock no-error.
      if avail esp-doc then
         assign c-desc-cod-esp:screen-value in frame {&frame-name} = esp-doc.descricao.
      else
         assign c-desc-cod-esp:screen-value in frame {&frame-name} = " ".
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-mensagem V-table-Win
ON F5 OF natur-oper.cod-mensagem IN FRAME f-main /* Mensagem */
DO:
    assign l-implanta = yes.
    
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=natur-oper.cod-mensagem
                       &campozoom=cod-mensagem}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-mensagem V-table-Win
ON LEAVE OF natur-oper.cod-mensagem IN FRAME f-main /* Mensagem */
DO:
{include/leave.i &tabela=mensagem
                 &atributo-ref=descricao
                 &variavel-ref=c-desc-cod-mensagem
                 &where="mensagem.cod-mensagem = input frame {&frame-name} natur-oper.cod-mensagem"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-mensagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-mensagem IN FRAME f-main /* Mensagem */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.especie-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.especie-doc V-table-Win
ON LEAVE OF natur-oper.especie-doc IN FRAME f-main /* Esp‚cie Documento */
DO:
   assign natur-oper.especie-doc:screen-value in frame {&frame-name} = 
          caps(input frame {&frame-name} natur-oper.especie-doc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.tp-rec-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tp-rec-desp V-table-Win
ON F5 OF natur-oper.tp-rec-desp IN FRAME f-main /* Tipo Despesa/Receita */
DO:
    assign l-implanta = yes.
    
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=natur-oper.tp-rec-desp
                       &campozoom=tp-codigo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tp-rec-desp V-table-Win
ON LEAVE OF natur-oper.tp-rec-desp IN FRAME f-main /* Tipo Despesa/Receita */
DO:
    {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tp-rec-desp
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name} natur-oper.tp-rec-desp"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tp-rec-desp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.tp-rec-desp IN FRAME f-main /* Tipo Despesa/Receita */
DO:
  apply "F5" to self.
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

  if natur-oper.cod-canal-venda:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
  if natur-oper.cod-esp:load-mouse-pointer("image/lupa.cur")         in frame {&frame-name} then.
  if natur-oper.cod-mensagem:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then.
  if natur-oper.tp-rec-desp:load-mouse-pointer("image/lupa.cur")     in frame {&frame-name} then.
  
  {utp/ut-field.i mgind natur-oper mercado 1}
  assign cb-mercado:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-field.i mgind natur-oper uso 01}
  assign cb-uso:label in frame {&frame-name} = trim(return-value).
    
  {utp/ut-field.i mgind natur-oper tipo-trib 01}
  assign cb-tipo-trib:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    /***Verifica se a mensagem foi alterada e pergunta se deseja atualizar todos os pedidos
        com a natureza corrente para a nova mensagem***/

    if not adm-new-record and
       i-cod-mens-ant <> input frame {&frame-name} natur-oper.cod-mensagem then do:

       run utp/ut-msgs.p (input "show":U,
                          input 15078,
                          input return-value).

       if return-value = "yes" then do:
           RUN Get-Field-Screen-Value IN adm-broker-hdl
                 (INPUT THIS-PROCEDURE, INPUT "nat-operacao":U).

           for each ped-venda use-index ch-natoper where
                    ped-venda.cod-sit-ped < 2 and
                    ped-venda.nat-oper    = return-value exclusive-lock:
               assign ped-venda.cod-mensagem = input frame {&frame-name} natur-oper.cod-mensagem.
           end.
       end.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  assign input frame {&frame-name} cb-mercado
        natur-oper.mercado = {ininc/i02in245.i 06 cb-mercado}.
        
  assign input frame {&frame-name} cb-uso
        natur-oper.uso = {ininc/i08in245.i 06 cb-uso}.
        
  assign input frame {&frame-name} cb-tipo-trib
        natur-oper.tipo-trib = {ininc/i07in245.i 06 cb-tipo-trib}.

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /***Descri‡äes dos Campos***/
  find first esp-doc where
             esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp no-lock no-error.
  if avail esp-doc then
     assign c-desc-cod-esp:screen-value in frame {&frame-name} = esp-doc.descricao.

  {include/leave.i &tabela=canal-venda
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-canal-venda
                   &where="canal-venda.cod-canal-venda = input frame {&frame-name} natur-oper.cod-canal-venda}.

  {include/leave.i &tabela=mensagem
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-cod-mensagem
                   &where="mensagem.cod-mensagem = input frame {&frame-name} natur-oper.cod-mensagem"}

  {include/leave.i &tabela=tipo-rec-desp
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tp-rec-desp
                   &where="tipo-rec-desp.tp-codigo = input frame {&frame-name} natur-oper.tp-rec-desp"}
                   
  /***Mostra Combo-Box***/
  if avail natur-oper then do:
     assign cb-mercado:screen-value   in frame {&frame-name} = {ininc/i02in245.i 04 natur-oper.mercado}.
     assign cb-uso:screen-value       in frame {&frame-name} = {ininc/i08in245.i 04 natur-oper.uso}.
     assign cb-tipo-trib:screen-value in frame {&frame-name} = {ininc/i07in245.i 04 natur-oper.tipo-trib}.
  end.
  else do:
     assign cb-mercado:screen-value   in frame {&frame-name} = {ininc/i02in245.i 04 1}.
     assign cb-uso:screen-value       in frame {&frame-name} = {ininc/i08in245.i 04 1}.
     assign cb-tipo-trib:screen-value in frame {&frame-name} = {ininc/i07in245.i 04 1}.
  end.
  
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

/*    if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    assign i-cod-mens-ant = input frame {&frame-name} natur-oper.cod-mensagem.
    
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
  
  /***Prepara‡Æo dos Lists Items***/
  assign cb-uso:list-items       in frame {&frame-name} = {ininc/i08in245.i 03}.
  assign cb-mercado:list-items   in frame {&frame-name} = {ininc/i02in245.i 03}.
  assign cb-tipo-trib:list-items in frame {&frame-name} = {ininc/i07in245.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  find first param-global no-lock no-error.
  assign natur-oper.cod-esp:format in frame {&frame-name} = "x(2)".  

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-seta-campo as logical no-undo.

if l-novo-reg then do:
    
   RUN Get-Field-Screen-Value IN adm-broker-hdl 
       (INPUT THIS-PROCEDURE, INPUT "ind-entfut":U).
   assign l-entfut       = return-value = "yes" or return-value = "sim".
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl 
       (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper":U).
   assign c-tipo         = return-value.
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl 
       (INPUT THIS-PROCEDURE, INPUT "terceiros":U).
   assign l-terceiros    = return-value = "yes" or return-value = "sim".
  
   RUN Get-Field-Screen-Value IN adm-broker-hdl 
       (INPUT THIS-PROCEDURE, INPUT "consum-final":U).
   assign l-consum-final = return-value = "yes" or return-value = "sim".
   
   RUN Get-Field-Screen-Value IN adm-broker-hdl 
       (INPUT THIS-PROCEDURE, INPUT "emite-duplic":U).
   assign l-emite-duplic = return-value = "yes" or return-value = "sim".

   assign cb-mercado:sensitive in frame {&frame-name} = if param-global.modulo-ft
                                                           then yes
                                                           else no.
         
   if p-seta-campo   and
      adm-new-record and
      not l-setou-campo then do:

      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT THIS-PROCEDURE, INPUT "cb-destino-icm":U).
      assign c-destino-icm = return-value.

      assign i-destino-icm = {varinc/var00071.i 06 c-destino-icm}.
                
      do with frame {&frame-name}:
         assign cb-uso:screen-value = {ininc/i08in245.i 04 natur-oper.uso}.
      end.

      assign l-setou-campo = yes.
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
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

  RUN Get-Field-Screen-Value IN adm-broker-hdl 
      (INPUT THIS-PROCEDURE, INPUT "emite-duplic":U).
  assign l-emite-duplic = if return-value = "sim" then yes else no. 
     
  RUN Get-Field-Screen-Value IN adm-broker-hdl 
      (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper":U).
  assign c-tipo = return-value.

  find esp-doc where 
       esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp no-lock no-error.
  if avail esp-doc then do:
     if esp-doc.tipo = 1 or
        esp-doc.tipo = 4 or
        esp-doc.tipo = 5 then
        assign natur-oper.cod-esp:screen-value in frame {&frame-name} = caps(input frame {&frame-name} natur-oper.cod-esp).

     else do:

           {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 5921, 
                               input "").
            apply "entry" to natur-oper.cod-esp in frame {&frame-name}.
            return 'ADM-ERROR':U.
     end.
  end.       

  if {ininc/i06in245.i 06 c-tipo} = 2 or
     {ininc/i06in245.i 06 c-tipo} = 3 then do:

      if input frame {&frame-name} natur-oper.especie-doc <> {ininc/i03in218.i 04 20} and
         input frame {&frame-name} natur-oper.especie-doc <> {ininc/i03in218.i 04 22} and
         input frame {&frame-name} natur-oper.especie-doc <> {ininc/i03in218.i 04 23} then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U,
                            input "1002",
                            input "").
         apply "entry" to natur-oper.especie-doc in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.
  end.

/*** INÖCIO ***/

  find first tipo-rec-desp where
             tipo-rec-desp.tp-codigo = input frame {&frame-name} natur-oper.tp-rec-desp no-lock no-error.
  if not avail tipo-rec-desp then do:
     {include/i-vldprg.i} 
     {utp/ut-field.i mgind natur-oper tp-rec-desp 1}
     run utp/ut-msgs.p (input "show":U, input 56, input return-value).
     apply "entry" to natur-oper.tp-rec-desp in frame {&frame-name}.
     return 'ADM-ERROR':U.            
  end.

  if  tipo-rec-desp.tipo = 2
  and avail esp-doc
  and (esp-doc.tipo = 1 
   or  esp-doc.tipo = 4
   or  esp-doc.tipo = 5) then do:
     {include/i-vldprg.i} 
     {utp/ut-field.i mgind natur-oper tp-rec-desp 1}
     run utp/ut-msgs.p (input "show":U, input 4265, input return-value).
     apply "entry" to natur-oper.tp-rec-desp in frame {&frame-name}.
     return 'ADM-ERROR':U.            
  end.

/*** FIM ***/  

  if l-emite-duplic then do:
     
     if {ininc/i06in245.i 06 c-tipo} = 2  and
         avail tipo-rec-desp              and
         tipo-rec-desp.tipo          = 2  then do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 415, input "").
              apply "entry" to natur-oper.tp-rec-desp in frame {&frame-name}.
              return 'ADM-ERROR':U.
     end.
  end.

  if l-gera-dup then do:
     /*
     if  natur-oper.cod-esp:screen-value in frame {&frame-name} = "" then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U,
                            input 15986,
                            input "").
         apply "entry" to natur-oper.cod-esp in frame {&frame-name}.
         return 'ADM-ERROR':U.
     end.
     */
  end.
  
  
  if  natur-oper.cod-esp:screen-value in frame {&frame-name} <> " " then do:
      find first esp-doc where
                 esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp no-lock no-error.
      if not avail esp-doc then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p("show",1822,"").
          apply "entry" to natur-oper.cod-esp in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end. 

  /*if input frame {&frame-name} natur-oper.cd-situacao = 05 or       
     input frame {&frame-name} natur-oper.cd-situacao = 12 or
     input frame {&frame-name} natur-oper.cd-situacao = 19 or
     input frame {&frame-name} natur-oper.cd-situacao = 23 or
     input frame {&frame-name} natur-oper.cd-situacao > 25 then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U,
                        input 15962, 
                        input "").
     apply "entry" to natur-oper.cd-situacao in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.*/
    
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
  {src/adm/template/snd-list.i "natur-oper"}

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


