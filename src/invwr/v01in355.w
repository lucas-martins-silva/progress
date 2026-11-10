&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V01IN355 2.00.00.010 } /*** 010010 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN355 MUT}
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
def new global shared var gr-pl-mest   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
 def var c-lista-tipo as char no-undo.
 define buffer b-pr-venda for pr-venda.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pr-venda.it-codigo pr-venda.cod-refer ~
pr-venda.nome-ab-reg pr-venda.nome-mic-reg pr-venda.cod-gr-cli 
&Scoped-define ENABLED-TABLES pr-venda
&Scoped-define FIRST-ENABLED-TABLE pr-venda
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-key c-cod-estabel 
&Scoped-Define DISPLAYED-FIELDS pl-mest.cd-plano pr-venda.it-codigo ~
pr-venda.cod-refer pr-venda.nome-ab-reg pr-venda.nome-mic-reg ~
pr-venda.cod-gr-cli pl-mest.descricao 
&Scoped-define DISPLAYED-TABLES pl-mest pr-venda
&Scoped-define FIRST-DISPLAYED-TABLE pl-mest
&Scoped-define SECOND-DISPLAYED-TABLE pr-venda
&Scoped-Define DISPLAYED-OBJECTS c-tipo-prev c-cod-estabel c-desc-grupo ~
c-nome c-desc-item c-desc-refer c-desc-reg c-desc-micro 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-cod-estabel pr-venda.it-codigo ~
pr-venda.nome-ab-reg pr-venda.nome-mic-reg pr-venda.cod-gr-cli 

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
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-grupo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88.

DEFINE VARIABLE c-desc-micro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-refer AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88.

DEFINE VARIABLE c-desc-reg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-prev AS CHARACTER FORMAT "X(35)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.29.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-mest.cd-plano AT ROW 1.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-tipo-prev AT ROW 2.17 COL 23.57 COLON-ALIGNED
     c-cod-estabel AT ROW 3.75 COL 23.57 COLON-ALIGNED
          LABEL "Estab":R7
     pr-venda.it-codigo AT ROW 4.75 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     pr-venda.cod-refer AT ROW 5.75 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     pr-venda.nome-ab-reg AT ROW 6.75 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     pr-venda.nome-mic-reg AT ROW 7.75 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     pr-venda.cod-gr-cli AT ROW 8.75 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.50 BY .88
     c-desc-grupo AT ROW 8.75 COL 27.86 COLON-ALIGNED NO-LABEL
     pl-mest.descricao AT ROW 1.17 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .88
     c-nome AT ROW 3.75 COL 31.29 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     c-desc-item AT ROW 4.75 COL 39.14 COLON-ALIGNED NO-LABEL
     c-desc-refer AT ROW 5.75 COL 39.14 COLON-ALIGNED NO-LABEL
     c-desc-reg AT ROW 6.75 COL 40.57 COLON-ALIGNED NO-LABEL
     c-desc-micro AT ROW 7.75 COL 40.57 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
     rt-key AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.83
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 8.85
       FRAME f-main:WIDTH            = 88.58.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   1 LIKE = mgcad.estabelec.cod-estabel EXP-LABEL                       */
/* SETTINGS FOR FILL-IN c-desc-grupo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-micro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-prev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pl-mest.cd-plano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pr-venda.cod-gr-cli IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN pl-mest.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pr-venda.it-codigo IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN pr-venda.nome-ab-reg IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN pr-venda.nome-mic-reg IN FRAME f-main
   1                                                                    */
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
ON F5 OF c-cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=c-cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-nome
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON LEAVE OF c-cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-nome
                   &where="estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel"}. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME f-main /* Estab */
DO:
    apply 'f5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pr-venda.cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-gr-cli V-table-Win
ON F5 OF pr-venda.cod-gr-cli IN FRAME f-main /* Grupo Cliente */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=adzoom/z01ad129.w
                     &campo=pr-venda.cod-gr-cli
                     &campozoom=cod-gr-cli
                     &campo2=c-desc-grupo
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-gr-cli V-table-Win
ON LEAVE OF pr-venda.cod-gr-cli IN FRAME f-main /* Grupo Cliente */
DO:
  {include/leave.i &tabela=gr-cli
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-grupo
                   &where="gr-cli.cod-gr-cli = input frame {&frame-name} pr-venda.cod-gr-cli"} 
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-gr-cli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pr-venda.cod-gr-cli IN FRAME f-main /* Grupo Cliente */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pr-venda.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-refer V-table-Win
ON F5 OF pr-venda.cod-refer IN FRAME f-main /* Referància */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=pr-venda.cod-refer
                     &campozoom=cod-refer
                     &campo2=c-desc-refer
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa (input pr-venda.it-codigo:screen-value)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-refer V-table-Win
ON LEAVE OF pr-venda.cod-refer IN FRAME f-main /* Referància */
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-refer
                   &where="referencia.cod-refer = input frame {&frame-name} pr-venda.cod-refer"}. 
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pr-venda.cod-refer IN FRAME f-main /* Referància */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pr-venda.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.it-codigo V-table-Win
ON F5 OF pr-venda.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in098.w
                     &campo=pr-venda.it-codigo
                     &campozoom=it-codigo
                     &campo2=c-desc-item
                     &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.it-codigo V-table-Win
ON LEAVE OF pr-venda.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=descricao-1 
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo  = input frame {&frame-name} pr-venda.it-codigo"}
  if avail  item then do:
     assign c-desc-item:screen-value  = item.desc-item
            pr-venda.cod-refer:sensitive in frame {&frame-name} = (item.tipo-con-est = 4).
  end. 
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pr-venda.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'f5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pr-venda.nome-ab-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-ab-reg V-table-Win
ON F5 OF pr-venda.nome-ab-reg IN FRAME f-main /* Regi∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad218.w
                     &campo=pr-venda.nome-ab-reg
                     &campozoom=nome-ab-reg
                     &campo2=c-desc-reg
                     &campozoom2=nome-regiao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-ab-reg V-table-Win
ON LEAVE OF pr-venda.nome-ab-reg IN FRAME f-main /* Regi∆o */
DO:
  {include/leave.i &tabela=regiao
                   &atributo-ref=nome-regiao
                   &variavel-ref=c-desc-reg
                   &where="regiao.nome-ab-reg = input frame {&frame-name} pr-venda.nome-ab-reg"}. 
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-ab-reg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pr-venda.nome-ab-reg IN FRAME f-main /* Regi∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pr-venda.nome-mic-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-mic-reg V-table-Win
ON F5 OF pr-venda.nome-mic-reg IN FRAME f-main /* Microrregi∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di107.w
                     &campo=pr-venda.nome-mic-reg
                     &campozoom=nome-mic-reg
                     &campo2=c-desc-micro
                     &campozoom2=desc-mic-reg}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-mic-reg V-table-Win
ON LEAVE OF pr-venda.nome-mic-reg IN FRAME f-main /* Microrregi∆o */
DO:
   {include/leave.i &tabela=micro-reg
                   &atributo-ref=desc-mic-reg
                   &variavel-ref=c-desc-micro
                   &where="micro-reg.nome-mic-reg = input frame {&frame-name} pr-venda.nome-mic-reg and micro-reg.nome-ab-reg  = input frame {&frame-name} pr-venda.nome-ab-reg"}                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pr-venda.nome-mic-reg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pr-venda.nome-mic-reg IN FRAME f-main /* Microrregi∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-field.i mgind pl-mest tipo-cl-prev 1}
  assign c-tipo-prev:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind pr-venda cod-estabel 1}
  assign c-cod-estabel:label in frame {&frame-name} = return-value.

  if c-cod-estabel:load-mouse-pointer         ("Image~\lupa.cur") in frame {&frame-name} then.
  if pr-venda.it-codigo:load-mouse-pointer    ("Image~\lupa.cur") in frame {&frame-name} then.
  if pr-venda.cod-refer:load-mouse-pointer    ("Image~\lupa.cur") in frame {&frame-name} then.
  if pr-venda.nome-ab-reg:load-mouse-pointer  ("Image~\lupa.cur") in frame {&frame-name} then.
  if pr-venda.nome-mic-reg:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then. 
  if pr-venda.cod-gr-cli:load-mouse-pointer   ("Image~\lupa.cur") in frame {&frame-name} then.

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
 
  disp c-tipo-prev 
       c-cod-estabel
       c-nome with frame {&frame-name}.
       
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
  if not frame {&frame-name}:validate() then
     return 'adm-error'. 

  /* Ponha na pi-validate todas as validaá‰es */
  
  RUN pi-validate.

  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  find pl-mest where rowid(pl-mest) = v-row-parent no-error.
   if available pl-mest then do:
      assign pr-venda.cd-plano    = pl-mest.cd-plano
             pr-venda.cod-estabel = c-cod-estabel.
   end.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */ 
  
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

  if avail pr-venda then do:
     find estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel no-lock no-error.
     assign c-nome = if avail estabelec then estabelec.nome else "":U.
 
     find item where item.it-codigo = pr-venda.it-codigo no-lock no-error.
     assign c-desc-item = if avail item then item.desc-item else "":U.

     if avail item and item.tipo-con-est <> 4 then do:
        assign pr-venda.cod-refer:sensitive in frame {&frame-name} = no.
        find referencia where referencia.cod-refer = pr-venda.cod-refer no-lock no-error.
        assign c-desc-refer = if avail referencia then referencia.descricao else "":U.
     end.    

     find regiao where regiao.nome-ab-reg = pr-venda.nome-ab-reg no-lock no-error.
     assign c-desc-reg = if avail regiao then regiao.nome-regiao else "":U.

     find micro-reg where micro-reg.nome-mic-reg = pr-venda.nome-mic-reg no-lock no-error.
     assign c-desc-micro = if avail micro-reg then micro-reg.nome-mic-reg else "":U.
      
     find gr-cli where gr-cli.cod-gr-cli = pr-venda.cod-gr-cli no-lock no-error.
     assign c-desc-grupo = if avail gr-cli then gr-cli.descricao else "":U.                
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
  
  if avail pr-venda then do:
     find item where item.it-codigo = pr-venda.it-codigo no-lock no-error.
     assign pr-venda.cod-refer:sensitive in frame {&frame-name} = (item.tipo-con-est <> 4).
  end.
     
  if pl-mest.tipo-cl-prev = 1 then do:
     disable pr-venda.nome-ab-reg
             c-desc-reg
             pr-venda.nome-mic-reg
             c-desc-micro
             pr-venda.cod-gr-cli
             c-desc-grupo
             with frame {&frame-name}.
  end.

  if pl-mest.tipo-cl-prev = 2 then do:
     disable pr-venda.nome-ab-reg
             c-desc-reg
             pr-venda.nome-mic-reg 
             c-desc-micro 
             with frame {&frame-name}.
  end.     

  if pl-mest.tipo-cl-prev = 3 then do:     
     disable pr-venda.cod-gr-cli
             c-desc-grupo with frame {&frame-name}.
  end.

 disp c-cod-estabel with frame {&frame-name}.
  
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

  find pl-mest where rowid(pl-mest) = gr-pl-mest no-lock.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {ininc/i02in313.i 03}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-lista-tipo = cAuxTraducao001.
&else
ASSIGN c-lista-tipo = {ininc/i02in313.i 03}.
&endif
ASSIGN 
         c-tipo-prev  = entry(pl-mest.tipo-cl-prev,c-lista-tipo).  
    
  disable pr-venda.cod-refer with frame {&frame-name}.
  
  find param-pm no-lock no-error.
  if avail param-pm then do:
     assign c-cod-estabel = param-pm.cod-estabel.
     find estabelec where 
          estabelec.cod-estabel = param-pm.cod-estabel no-lock no-error.
     assign c-nome = if avail estabelec then estabelec.nome else "":U.
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  disp c-tipo-prev 
       c-cod-estabel
       c-nome with frame {&frame-name}.
 
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
 /* {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */*/
   
/*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 

 /*********************************** Mensagens do sistema ***********************************/
 
    find pl-mest where rowid(pl-mest) = v-row-parent no-lock.

    if c-cod-estabel:sensitive in frame {&frame-name} = yes
    and can-find(b-pr-venda where b-pr-venda.cod-estabel  = input frame {&frame-name} c-cod-estabel
                          and   b-pr-venda.cd-plano     = pl-mest.cd-plano
                          and   b-pr-venda.it-codigo    = input frame {&frame-name} pr-venda.it-codigo
                          and   b-pr-venda.nome-ab-reg  = input frame {&frame-name} pr-venda.nome-ab-reg
                          and   b-pr-venda.nome-mic-reg = input frame {&frame-name} pr-venda.nome-mic-reg
                          and   b-pr-venda.cod-gr-cli   = input frame {&frame-name} pr-venda.cod-gr-cli
                          and   b-pr-venda.cod-refer    = input frame {&frame-name} pr-venda.cod-refer)
    then do:
      
      {utp/ut-table.i mgind pr-venda 1}
      run utp/ut-msgs.p (input "show",
                         input 1,  
                         input return-value).
      apply "entry" to c-cod-estabel in frame {&frame-name}.
      return 'ADM-ERROR':U.
    
    end.
    
    if pr-venda.it-codigo:sensitive in frame {&frame-name} = yes then do:
      find first est-prod where est-prod.it-codigo = input frame {&frame-name} pr-venda.it-codigo no-lock no-error.
      if not avail est-prod then do:
         run utp/ut-msgs.p (input "show",
                            input 6795,  
                            input "").
         apply "entry" to pr-venda.it-codigo in frame {&frame-name}.
         return 'ADM-ERROR':U.     
      end.
    end.

    /***************************     Validaá‰es para apresentar as mensagens do sistema    *********************/

    if pl-mest.tipo-cl-prev = 1 then do:
        
       if not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel) then do:
           run utp/ut-msgs.p(input "show",
                             input 4462, 
                             input input frame {&frame-name} c-cod-estabel).
           apply 'entry' to c-cod-estabel in frame {&frame-name}.
           return 'ADM-ERROR':U.
       end.
    end.
    else 
       if pl-mest.tipo-cl-prev = 2 then do:
          if not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel) then do:
              run utp/ut-msgs.p(input "show",
                                input 777, 
                                input input frame {&frame-name} c-cod-estabel).
              apply 'entry' to c-cod-estabel in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
          if not can-find(gr-cli where string(gr-cli.cod-gr-cli) = pr-venda.cod-gr-cli:screen-value in frame {&frame-name}) then do:
              run utp/ut-msgs.p(input "show",
                                input 4250, 
                                input return-value).
              apply 'entry' to pr-venda.cod-gr-cli in frame {&frame-name}.
              return 'ADM-ERROR':u.
          end.
       end.
       else 
          if pl-mest.tipo-cl-prev = 3 then do:
              if not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel) then do:
                  run utp/ut-msgs.p(input "show",
                                    input 777, 
                                    input input frame {&frame-name} c-cod-estabel).
                  apply 'entry' to c-cod-estabel in frame {&frame-name}.
                  return 'ADM-ERROR':u.
              end.
              IF NOT CAN-FIND(regiao WHERE regiao.nome-ab-reg = pr-venda.nome-ab-reg:screen-value in frame {&frame-name}) THEN DO:
                  run utp/ut-msgs.p (input "show",
                                     input 3886,  
                                     input return-value).
                  apply "entry" to pr-venda.nome-ab-reg in frame {&frame-name}.
                  return 'ADM-ERROR':u.
              END.
              ELSE      
                  IF NOT CAN-FIND(FIRST micro-reg where micro-reg.nome-mic-reg = pr-venda.nome-mic-reg:screen-value in frame {&frame-name}) THEN DO:
                     run utp/ut-msgs.p (input "show",
                                         input 15272,  
                                         input return-value).
                      apply "entry" to pr-venda.nome-mic-reg in frame {&frame-name}.
                      return 'ADM-ERROR':u.
                  END.
                   ELSE
                      IF NOT CAN-FIND(micro-reg where micro-reg.nome-mic-reg = pr-venda.nome-mic-reg:screen-value in frame {&frame-name}
                                  AND micro-reg.nome-ab-reg = pr-venda.nome-ab-reg:screen-value in frame {&frame-name}) THEN DO:
                          run utp/ut-msgs.p (input "show",
                                             input 15757,  
                                             input return-value).
                          apply "entry" to pr-venda.nome-mic-reg in frame {&frame-name}.
                          return 'ADM-ERROR':u.
                      END.
          end.
          else 
              if pl-mest.tipo-cl-prev = 4 then do:
                  if not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel) then do:
                      run utp/ut-msgs.p(input "show",
                                        input 777, 
                                        input input frame {&frame-name} c-cod-estabel).
                      apply 'entry' to c-cod-estabel in frame {&frame-name}.
                      return 'ADM-ERROR':u.
                  end.
                  IF NOT CAN-FIND(regiao WHERE regiao.nome-ab-reg = pr-venda.nome-ab-reg:screen-value in frame {&frame-name}) THEN DO:
                      run utp/ut-msgs.p (input "show",
                                         input 3886,  
                                         input return-value).
                      apply "entry" to pr-venda.nome-ab-reg in frame {&frame-name}.
                      return 'ADM-ERROR':u.
                  END.
                  ELSE      
                      IF NOT CAN-FIND(FIRST micro-reg where micro-reg.nome-mic-reg = pr-venda.nome-mic-reg:screen-value in frame {&frame-name}) THEN DO:
                         run utp/ut-msgs.p (input "show",
                                             input 15272,  
                                             input return-value).
                          apply "entry" to pr-venda.nome-mic-reg in frame {&frame-name}.
                          return 'ADM-ERROR':u.
                      END.
                       ELSE
                          IF NOT CAN-FIND(micro-reg where micro-reg.nome-mic-reg = pr-venda.nome-mic-reg:screen-value in frame {&frame-name}
                                      AND micro-reg.nome-ab-reg = pr-venda.nome-ab-reg:screen-value in frame {&frame-name}) THEN DO:
                              run utp/ut-msgs.p (input "show",
                                                 input 15757,  
                                                 input return-value).
                              apply "entry" to pr-venda.nome-mic-reg in frame {&frame-name}.
                              return 'ADM-ERROR':u.
                          END.
                 if not can-find(gr-cli where string(gr-cli.cod-gr-cli) = pr-venda.cod-gr-cli:screen-value in frame {&frame-name}) then do:
                     run utp/ut-msgs.p(input "show",
                                       input 4250, 
                                       input return-value).
                     apply 'entry' to pr-venda.cod-gr-cli in frame {&frame-name}.
                     return 'ADM-ERROR':u.
                 end.
              end.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

