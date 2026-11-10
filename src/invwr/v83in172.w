&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V83IN172 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V83IN172 MUT}
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

 def var i-cod-emitente as integer.
 def var de-soma        as decimal.

/********* Multi-Planta ***********/
def var i-tipo-movto as integer no-undo.
def var l-cria as logical no-undo.

{cdp/cd7300.i1}
{cdp/cd0669.i}
/************* Fim ****************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-fornec
&Scoped-define FIRST-EXTERNAL-TABLE item-fornec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-fornec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-4 RECT-3 RECT-2 RECT-1 ~
c-item-do-forn i-tempo-ressup i-lote-mul-for c-unid-med-for i-lote-minimo ~
i-fator-conver i-cod-cond-pag i-num-casa-dec i-perc-compra i-horiz-fixo ~
l-cot-aut l-ativo l-contr-forn R-SET-classe-repro c-narrativa 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-desc-item c-item-do-forn ~
i-tempo-ressup i-lote-mul-for c-unid-med-for c-desc-un i-lote-minimo ~
i-fator-conver i-cod-cond-pag c-desc-pgto i-num-casa-dec i-perc-compra ~
i-horiz-fixo l-cot-aut l-ativo l-contr-forn R-SET-classe-repro c-narrativa 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 53 BY 3.25.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 56.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pgto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-item-do-forn AS CHARACTER FORMAT "X(60)" 
     LABEL "Item Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88.

DEFINE VARIABLE c-unid-med-for AS CHARACTER FORMAT "X(4)":U 
     LABEL "Unid Medida" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Condi‡Æo Pagamento":R22 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-fator-conver AS DECIMAL FORMAT ">>>>>>>>>9" INITIAL 1 
     LABEL "Fator ConversÆo":R18 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-horiz-fixo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Horizonte Fixo":R17 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-lote-minimo AS DECIMAL FORMAT "->>,>>9.99" INITIAL 1 
     LABEL "Lote M¡nimo":R14 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-lote-mul-for AS DECIMAL FORMAT "->>,>>9.99" INITIAL 1 
     LABEL "Lote M£ltiplo":R16 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-num-casa-dec AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Casas Decimais":R17 
     VIEW-AS FILL-IN 
     SIZE 2.29 BY .88.

DEFINE VARIABLE i-perc-compra AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "% Compra":R10 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-tempo-ressup AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Tempo Ressupr":R16 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE VARIABLE R-SET-classe-repro AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Antecipa/Prorroga", 1,
"Prorroga", 2,
"Antecipa", 3,
"NÆo Reprograma", 4
     SIZE 20.14 BY 3.33.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 4.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 4.25.

DEFINE VARIABLE l-ativo AS LOGICAL INITIAL yes 
     LABEL "Ativo":L7 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .88.

DEFINE VARIABLE l-contr-forn AS LOGICAL INITIAL no 
     LABEL "Contrato Fornecimento":L25 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .88.

DEFINE VARIABLE l-cot-aut AS LOGICAL INITIAL no 
     LABEL "Cota‡Æo Autom tica":L22 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-it-codigo AT ROW 1.33 COL 5.86 COLON-ALIGNED
     c-desc-item AT ROW 1.33 COL 23.43 COLON-ALIGNED NO-LABEL
     c-item-do-forn AT ROW 3 COL 18 COLON-ALIGNED
     i-tempo-ressup AT ROW 4 COL 18 COLON-ALIGNED
     i-lote-mul-for AT ROW 4 COL 54 COLON-ALIGNED
     c-unid-med-for AT ROW 5 COL 18 COLON-ALIGNED
     c-desc-un AT ROW 5 COL 22 COLON-ALIGNED NO-LABEL
     i-lote-minimo AT ROW 5 COL 54 COLON-ALIGNED
     i-fator-conver AT ROW 6 COL 18 COLON-ALIGNED
     i-cod-cond-pag AT ROW 6 COL 54 COLON-ALIGNED
     c-desc-pgto AT ROW 6 COL 59 COLON-ALIGNED NO-LABEL
     i-num-casa-dec AT ROW 7 COL 18 COLON-ALIGNED
     i-perc-compra AT ROW 7 COL 54 COLON-ALIGNED
     i-horiz-fixo AT ROW 7 COL 73.43 COLON-ALIGNED
     l-cot-aut AT ROW 8.75 COL 2
     l-ativo AT ROW 8.75 COL 35
     l-contr-forn AT ROW 8.75 COL 55
     R-SET-classe-repro AT ROW 10.5 COL 3 NO-LABEL
     c-narrativa AT ROW 10.5 COL 28 NO-LABEL
     RECT-5 AT ROW 10 COL 26
     RECT-4 AT ROW 10 COL 1
     RECT-3 AT ROW 8.5 COL 1
     RECT-2 AT ROW 2.75 COL 1
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-fornec
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
         HEIGHT             = 13.25
         WIDTH              = 82.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-pgto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON LEAVE OF c-it-codigo IN FRAME f-main /* Item */
DO:
  assign c-desc-item = item.desc-item. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-med-for
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-for V-table-Win
ON F5 OF c-unid-med-for IN FRAME f-main /* Unid Medida */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                     &campo=c-unid-med-for
                     &campozoom=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-for V-table-Win
ON LEAVE OF c-unid-med-for IN FRAME f-main /* Unid Medida */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-un
                   &where="tab-unidade.un = input frame {&frame-name} c-unid-med-for"}

find item where item.it-codigo = input frame {&frame-name} c-it-codigo
    no-lock no-error.
if avail item then do:
  find first tab-conv-un 
        where tab-conv-un.unid-med-for = input frame {&frame-name} c-unid-med-for 
        and   tab-conv-un.un = item.un
  no-lock no-error.
  
  if available tab-conv-un then do:
    assign i-fator-conver = tab-conv-un.fator-conver.
           i-num-casa-dec = tab-conv-un.num-casa-dec.
    disp i-fator-conver 
         i-num-casa-dec with frame {&frame-name}.
  end.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-for V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-unid-med-for IN FRAME f-main /* Unid Medida */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON F5 OF i-cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  {include/zoomvar.i &prog-zoom = adzoom/z01ad039.w
                     &campo     = i-cod-cond-pag
                     &campozoom = cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON LEAVE OF i-cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
    {include/leave.i &tabela      =cond-pagto
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-pgto
                     &where       ="cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag"}
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
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
  
  /************************ INTERNAL PROCEDURES ********************/

  if c-unid-med-for:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if i-cod-cond-pag:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "item-fornec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-fornec"}

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
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
  
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

  /* Dispatch standard ADM method.                             */

  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/    
 
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
  
  {utp/ut-field.i mgind item it-codigo 1}
  assign c-it-codigo:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-field.i mgind item-fornec item-do-forn 1}
  assign c-item-do-forn:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-field.i mgind item-fornec tempo-ressup 1}
  assign i-tempo-ressup:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec unid-med-for 1}
  assign c-unid-med-for:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec fator-conver 1}
  assign i-fator-conver:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec num-casa-dec 1}
  assign i-num-casa-dec:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec lote-mul-for 1}
  assign i-lote-mul-for:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec lote-minimo 1}
  assign i-lote-minimo:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec cod-cond-pag 1}
  assign i-cod-cond-pag:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec perc-compra 1}
  assign i-perc-compra:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec horiz-fixo 1}
  assign i-horiz-fixo:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec cot-aut 1}
  assign l-cot-aut:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec ativo 1}
  assign l-ativo:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-field.i mgind item-fornec contr-forn 1}
  assign l-contr-forn:label in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-rdset.i R-SET-classe-repro}

  
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-relacionamento V-table-Win 
PROCEDURE pi-cria-relacionamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-item     as char.
def input param p-emitente as integer.

find emitente where emitente.cod-emitente = p-emitente  no-lock no-error.

find item     where item.it-codigo = p-item             no-lock no-error.

de-soma = 0.
for each item-fornec where item-fornec.it-codigo = item.it-codigo and
                             item-fornec.ativo   = yes no-lock:
    assign de-soma = de-soma + item-fornec.perc-compra.
end.      

assign i-cod-cond-pag = input frame {&frame-name} i-cod-cond-pag
       c-desc-pgto    = input frame {&frame-name} c-desc-pgto.

display item.it-codigo                      @ c-it-codigo    
        item.desc-item                      @ c-desc-item    
        item.lote-multipl                   @ i-lote-mul-for 
        item.lote-minimo                    @ i-lote-minimo  
        item.fator-conver                   @ i-fator-conver 
        item.un                             @ c-unid-med-for 
        item.horiz-fixo                     @ i-horiz-fixo 
        item.it-codigo                      @ c-item-do-forn
        i-tempo-ressup
        i-num-casa-dec
        i-perc-compra
        i-cod-cond-pag
        c-desc-pgto
        l-cot-aut
        l-ativo
        l-contr-forn
        r-set-classe-repro
        c-narrativa                        with frame {&frame-name}.
        
release item-fornec.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

find first param-global no-lock no-error.

if  param-global.modulo-mp then do:
    run cdp/cdapi150.p (input "item-fornec",
                    input rowid(item-fornec),
                    input i-tipo-movto,
                    input c-transacao,
                    input-output table tt-erro).                         
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-item-relacionado V-table-Win 
PROCEDURE pi-gera-item-relacionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input param p-item     as char.
 def input param p-emitente as integer.
 
 assign i-perc-compra  = input frame {&frame-name} i-perc-compra
        i-cod-cond-pag = input frame {&frame-name} i-cod-cond-pag.

 if i-cod-cond-pag = 0 then do: 
    run utp/ut-msgs.p (input "show", input 4337, input i-cod-cond-pag).
   apply "entry" to i-cod-cond-pag in frame {&frame-name}.
   return error.
 end.

 if (i-perc-compra + de-soma) > 100 then do: 
    run utp/ut-msgs.p (input "show", input 4326, input string(i-perc-compra)).
   apply "entry" to i-perc-compra in frame {&frame-name}.
   return error.
 end.

 create item-fornec.
 assign item-fornec.cod-emitente = emitente.cod-emitente
        item-fornec.it-codigo    = input frame {&frame-name} c-it-codigo   
        item-fornec.item-do-forn = input frame {&frame-name} c-item-do-forn 
        item-fornec.lote-mul-for = input frame {&frame-name} i-lote-mul-for 
        item-fornec.lote-minimo  = input frame {&frame-name} i-lote-minimo  
        item-fornec.unid-med-for = input frame {&frame-name} c-unid-med-for
        item-fornec.fator-conver = input frame {&frame-name} i-fator-conver
        item-fornec.perc-compra  = input frame {&frame-name} i-perc-compra
        item-fornec.tempo-ressup = input frame {&frame-name} i-tempo-ressup
        item-fornec.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag
        item-fornec.classe-repro = input frame {&frame-name} r-set-classe-repro
        item-fornec.horiz-fixo   = input frame {&frame-name} i-horiz-fixo
        item-fornec.num-casa-dec = input frame {&frame-name} i-num-casa-dec
        item-fornec.ativo        = input frame {&frame-name} l-ativo
        item-fornec.cot-aut      = input frame {&frame-name} l-cot-aut
        item-fornec.contr-forn   = input frame {&frame-name} l-contr-forn
        item-fornec.narrativa    = input frame {&frame-name} c-narrativa.

 /********* Multi-Planta ************/
 assign c-transacao = "MAT001".
 assign i-tipo-movto = 1.
 run pi-cria-tt-dados (input i-tipo-movto). 
 /************** Fim ****************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-termina-programa V-table-Win 
PROCEDURE pi-termina-programa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

disable all with frame {&frame-name}.

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
  {src/adm/template/snd-list.i "item-fornec"}

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

