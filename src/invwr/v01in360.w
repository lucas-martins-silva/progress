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
{include/i-prgvrs.i V01IN360 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in360 MUT}
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
def new global shared var gr-produto   as rowid no-undo.                                
def new global shared var gr-pl-mest   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-lista-tipo as char format "x(20)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES produto
&Scoped-define FIRST-EXTERNAL-TABLE produto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR produto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS produto.cd-produto 
&Scoped-define ENABLED-TABLES produto
&Scoped-define FIRST-ENABLED-TABLE produto
&Scoped-Define ENABLED-OBJECTS rt-key c-cod-estabel c-nome-ab-reg ~
c-nome-mic-reg c-cod-gr-cli 
&Scoped-Define DISPLAYED-FIELDS pl-mest.cd-plano pl-mest.descricao ~
produto.cd-produto produto.descricao 
&Scoped-define DISPLAYED-TABLES pl-mest produto
&Scoped-define FIRST-DISPLAYED-TABLE pl-mest
&Scoped-define SECOND-DISPLAYED-TABLE produto
&Scoped-Define DISPLAYED-OBJECTS c-tipo-produto c-cod-estabel c-nome ~
c-nome-ab-reg c-nome-mic-reg c-cod-gr-cli 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-tipo-produto 

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
DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-gr-cli AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "":R16 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 45.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ab-reg AS CHARACTER FORMAT "x(12)" 
     LABEL "":R8 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE c-nome-mic-reg AS CHARACTER FORMAT "x(12)" 
     LABEL "":R15 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE c-tipo-produto AS CHARACTER FORMAT "X(20)" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-mest.cd-plano AT ROW 1.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     pl-mest.descricao AT ROW 1.17 COL 19.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41 BY .88
     produto.cd-produto AT ROW 2.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     produto.descricao AT ROW 2.17 COL 31.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33 BY .88
     c-tipo-produto AT ROW 2.17 COL 65 COLON-ALIGNED NO-LABEL
     c-cod-estabel AT ROW 3.17 COL 14 COLON-ALIGNED HELP
          ""
          LABEL "":R7
     c-nome AT ROW 3.17 COL 24.43 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     c-nome-ab-reg AT ROW 4.17 COL 14 COLON-ALIGNED
     c-nome-mic-reg AT ROW 4.17 COL 46.57 COLON-ALIGNED
     c-cod-gr-cli AT ROW 4.17 COL 79 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   External Tables: mgind.produto
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.29
         WIDTH              = 88.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL                         */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-produto IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN pl-mest.cd-plano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pl-mest.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.descricao IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON F5 OF c-cod-estabel IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=c-cod-estabel
                     &campozoom=cod-estabel}
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON LEAVE OF c-cod-estabel IN FRAME f-main
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-nome
                   &where="estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-gr-cli V-table-Win
ON F5 OF c-cod-gr-cli IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad129.w
                     &campo=c-cod-gr-cli
                     &campozoom=cod-gr-cli}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-gr-cli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-gr-cli IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-ab-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg V-table-Win
ON F5 OF c-nome-ab-reg IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad218.w
                     &campo=c-nome-ab-reg
                     &campozoom=nome-ab-reg}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-ab-reg IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-mic-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg V-table-Win
ON F5 OF c-nome-mic-reg IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di107.w
                     &campo=c-nome-mic-reg
                     &campozoom=nome-mic-reg}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-mic-reg IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind pr-venda cod-estabel 1}
assign c-cod-estabel:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pr-venda nome-ab-reg 1}
assign c-nome-ab-reg:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pr-venda nome-mic-reg 1}
assign c-nome-mic-reg:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pr-venda cod-gr-cli 1}
assign c-cod-gr-cli:label in frame {&frame-name} = return-value.

if c-cod-estabel:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
if c-nome-ab-reg:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
if c-nome-mic-reg:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
if c-cod-gr-cli:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "produto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "produto"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  /* Ponha na pi-validate todas as valida‡äes */

  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
        
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

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
  
  if avail produto then do:
     assign c-tipo-produto = entry(produto.tipo-produto,c-lista-tipo).
     
     find estabelec where estabelec.cod-estabel = c-cod-estabel no-lock no-error.
     assign c-nome = if avail estabelec then estabelec.nome else "":U.
  end.        

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAIL produto THEN DO:
      disp pl-mest.cd-plano 
           pl-mest.descricao 
           produto.cd-produto 
           produto.descricao
           c-cod-estabel
           c-nome with frame {&frame-name}.
  END.
  
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
   def var c-handle as char no-undo.
   def var h-handle as handle no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  assign c-lista-tipo   = {ininc/i03in360.i 03}.
  
  find pl-mest where rowid(pl-mest) = gr-pl-mest no-lock.
  find produto where rowid(produto) = gr-produto no-lock.

  find param-pm no-lock no-error.
  if avail param-pm then do:
     assign c-cod-estabel = param-pm.cod-estabel.
     find estabelec where estabelec.cod-estabel = param-pm.cod-estabel no-lock no-error.
     assign c-nome = if avail estabelec then estabelec.nome else "":U.
  end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
     if pl-mest.tipo-cl-prev = 1 then do:
        disable c-nome-ab-reg
                c-nome-mic-reg
                c-cod-gr-cli
                with frame {&frame-name}.
     end. 

     if pl-mest.tipo-cl-prev = 2 then do:
        assign c-nome-ab-reg:sensitive  in frame {&frame-name} = no
               c-nome-mic-reg:sensitive in frame {&frame-name} = no.
     end.     

     if pl-mest.tipo-cl-prev = 3 then do:     
        disable c-cod-gr-cli with frame {&frame-name}.
     end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   def var c-handle as char no-undo.
   def var h-handle as handle no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ).

  /* Code placed here will execute AFTER standard behavior.    */

  if avail produto then do:
     assign gr-produto = rowid(produto).
     RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                            INPUT 'previsao-target',
                                            OUTPUT c-handle).
     if num-entries(c-handle) = 1 then do:
        assign h-handle = widget-handle(c-handle).
        if valid-handle(h-handle) then 
           run pi-le-previsao-produto in h-handle.
     end.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-variaveis V-table-Win 
PROCEDURE pi-retorna-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def output parameter p-cod-estabel  like estabelec.cod-estabel no-undo.
   def output parameter p-nome-ab-reg  like pr-venda.nome-ab-reg  no-undo.
   def output parameter p-nome-mic-reg like pr-venda.nome-mic-reg no-undo.
   def output parameter p-cod-gr-cli   like pr-venda.cod-gr-cli   no-undo.
   
   assign p-cod-estabel  = input frame {&frame-name} c-cod-estabel
          p-nome-ab-reg  = input frame {&frame-name} c-nome-ab-reg
          p-nome-mic-reg = input frame {&frame-name} c-nome-mic-reg
          p-cod-gr-cli   = input frame {&frame-name} c-cod-gr-cli.

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "produto"}

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

