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
{include/i-prgvrs.i IM0010-V01 2.00.00.014 } /*** "010014" 10/07/2025 09:32:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0010-V01 MIM}
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
def new global shared var gr-cotacao-item-cex as rowid no-undo.
def new global shared var gi-numero-ordem-alt like ordem-compra.numero-ordem no-undo.
def new global shared var gr-im0010-cotacao-item-cex as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */ 
{include/boerrtab.i}
{cxbo/bocx085.i tt-cotacao-item-cex}
{adbo/boad098.i tt-emitente}
{cxbo/bocx115.i tt-itinerario}
   
def var h-boad098 as handle no-undo.
def var h-bocx115 as handle no-undo.
def var h-bocx085 as handle no-undo.
def var h-boin082 as handle no-undo.
def var h-boun005 as handle no-undo.

def var l-mapa-aprovado  as logical no-undo.
def var c-param          as char    no-undo.
def var r-chave          as rowid   no-undo.
def var h-b05cx085       as handle  no-undo.
def var de-total-despesa as decimal no-undo.
def var c-return         as char    no-undo.
def var c-nome-abrev     like emitente.nome-abrev  no-undo.
def var c-descricao      like itinerario.descricao no-undo.
def var c-moeda          like moeda.descricao      no-undo.
def var h_window         as handle  no-undo.
def var pi-mo-codigo     as integer no-undo.
def var h-mo-codigo      as handle  no-undo.
def var c-unidade        as char    no-undo.
def var de-tot-desp-trib as decimal no-undo.
DEF VAR l-nt2024002      AS LOGICAL NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key tt-numero-ordem tt-cod-emitente ~
c-desc-emitente c-it-codigo c-unid i-seq-cotac i-mo-codigo c-desc-moeda ~
d-data-cotacao c-cod-incoterm i-cod-itiner c-desc-itinerario i-mapa-cotacao ~
l-aprovado tt-preco-cotacao de-preco-cot-trib 
&Scoped-Define DISPLAYED-OBJECTS tt-numero-ordem tt-cod-emitente ~
c-desc-emitente c-it-codigo c-unid i-seq-cotac i-mo-codigo c-desc-moeda ~
d-data-cotacao c-cod-incoterm i-cod-itiner c-desc-itinerario i-mapa-cotacao ~
l-aprovado tt-preco-cotacao de-preco-cot-trib 

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
DEFINE VARIABLE c-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-itinerario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid AS CHARACTER FORMAT "xx" 
     LABEL "Un":R12 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-cotacao AS DATE FORMAT "99/99/9999":U 
     LABEL "data" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-cot-trib AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "cotacao-tributos" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "cod-itiner" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-mapa-cotacao AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "mapa" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "moeda" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-seq-cotac AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "seq-cotac" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE tt-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "cod-emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE tt-numero-ordem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "ordem" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE tt-preco-cotacao AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "cotacao" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.5.

DEFINE VARIABLE l-aprovado AS LOGICAL INITIAL no 
     LABEL "aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tt-numero-ordem AT ROW 1.25 COL 7.57 COLON-ALIGNED
     tt-cod-emitente AT ROW 1.25 COL 59.72 COLON-ALIGNED
     c-desc-emitente AT ROW 1.25 COL 70 COLON-ALIGNED NO-LABEL
     c-it-codigo AT ROW 2.25 COL 7.57 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-unid AT ROW 2.25 COL 35.72 COLON-ALIGNED HELP
          "Unidade de medida do item"
     i-seq-cotac AT ROW 2.25 COL 59.72 COLON-ALIGNED
     i-mo-codigo AT ROW 2.25 COL 73.57 COLON-ALIGNED HELP
          "Moeda."
     c-desc-moeda AT ROW 2.25 COL 77.86 COLON-ALIGNED NO-LABEL
     d-data-cotacao AT ROW 3.25 COL 7.57 COLON-ALIGNED
     c-cod-incoterm AT ROW 3.25 COL 35.72 COLON-ALIGNED
     i-cod-itiner AT ROW 3.25 COL 59.72 COLON-ALIGNED
     c-desc-itinerario AT ROW 3.25 COL 65.86 COLON-ALIGNED NO-LABEL
     i-mapa-cotacao AT ROW 4.25 COL 7.57 COLON-ALIGNED
     l-aprovado AT ROW 4.25 COL 14.57
     tt-preco-cotacao AT ROW 4.25 COL 35.72 COLON-ALIGNED
     de-preco-cot-trib AT ROW 4.25 COL 71.86 COLON-ALIGNED WIDGET-ID 2
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 4.5
         WIDTH              = 90.
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

&Scoped-define SELF-NAME tt-numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-numero-ordem V-table-Win
ON F5 OF tt-numero-ordem IN FRAME f-main /* ordem */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z17in274.w
                       &campo=tt-numero-ordem
                       &campozoom=tt-numero-ordem}
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
  
  {utp/ut-field.i mgcex cotacao-item-cex numero-ordem 1}
  assign tt-numero-ordem:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex cod-emitente 1}
  assign tt-cod-emitente:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex it-codigo 1}
  assign c-it-codigo:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex seq-cotac 1}
  assign i-seq-cotac:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex data-cotacao 1}
  assign d-data-cotacao:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex mapa-cotacao 1}
  assign i-mapa-cotacao:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Aprovado * L}
  assign l-aprovado:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex cod-incoterm 1}
  assign c-cod-incoterm:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex cod-itiner 1}
  assign i-cod-itiner:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Pre‡o_Cota‡Æo * L}
  assign tt-preco-cotacao:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind cotacao-item mo-codigo 1}
  assign i-mo-codigo:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Un * L}
  assign c-unid:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-liter.i Pre‡o_Cota‡Æo_Tributos * L}
  assign de-preco-cot-trib:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpa-temp-tables V-table-Win 
PROCEDURE limpa-temp-tables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  for each tt-cotacao-item-cex:
    delete tt-cotacao-item-cex.
  end.
  
  for each tt-bo-erro:
    delete tt-bo-erro.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  delete procedure h-bocx085.
  delete procedure h-boad098.
  delete procedure h-bocx115.
  delete procedure h-boin082.
  delete procedure h-boun005.

  assign gr-im0010-cotacao-item-cex = r-chave.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
    
    disable all with frame {&frame-name}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
find first tt-cotacao-item-cex no-error.

if avail tt-cotacao-item-cex then do with frame {&frame-name}:

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        RUN verifica-buttons IN h-b05cx085(INPUT NO).
        RUN pi-enable-panel in h_window.
    &ENDIF

    assign tt-numero-ordem:screen-value = string(tt-cotacao-item-cex.numero-ordem)
          tt-cod-emitente:screen-value = string(tt-cotacao-item-cex.cod-emitente)
          c-it-codigo:screen-value     = string(tt-cotacao-item-cex.it-codigo)
          i-seq-cotac:screen-value     = string(tt-cotacao-item-cex.seq-cotac)
          d-data-cotacao:screen-value  = string(tt-cotacao-item-cex.data-cotacao)
          i-mapa-cotacao:screen-value  = string(tt-cotacao-item-cex.mapa-cotacao)
          c-cod-incoterm:screen-value  = tt-cotacao-item-cex.cod-incoterm
          i-cod-itiner:screen-value    = string(tt-cotacao-item-cex.cod-itiner)
          r-chave                      = tt-cotacao-item-cex.r-rowid.

   /* Verifica se o mapa est  aprovado para a cota‡Æo do material */
   RUN verificaMapaAprovado in h-bocx085 (input r-chave,output l-mapa-aprovado).

   /* Calcula o preco de todas as despesas na moeda da cota‡Æo do material */
   RUN calculoPrecocotacao in h-bocx085 (input r-chave,output de-total-despesa).

   ASSIGN de-tot-desp-trib = 0.
   IF l-nt2024002 THEN DO:
       RUN calculoPrecoCotTrib in h-bocx085 (input r-chave,output de-tot-desp-trib).
       ASSIGN de-preco-cot-trib:SCREEN-VALUE = STRING(de-tot-desp-trib).
   END.
   ELSE
       ASSIGN de-preco-cot-trib:HIDDEN = YES.

   assign l-aprovado:checked             = l-mapa-aprovado
          tt-preco-cotacao:screen-value  = string(de-total-despesa).
       
   /* Se o mapa estiver aprovado desabilita as fun‡äes de modifica‡Æo e elimina‡Æo */
   RUN pi-disable-panel in h_window (input l-mapa-aprovado).
        
   /* Busca a moeda da cota‡Æo do material */
   run findCotacao in h-boin082(input tt-cotacao-item-cex.numero-ordem,
                                input tt-cotacao-item-cex.cod-emitente,
                                input tt-cotacao-item-cex.it-codigo,
                                &if defined(bf-mat-comex) &then
                                    input tt-cotacao-item-cex.data-cotacao,
                                &else
                                    input tt-cotacao-item-cex.seq-cotac,
                                &endif
                                output c-return).

   if c-return = "" then do:
      run getIntfield in h-boin082(input "mo-codigo", output pi-mo-codigo).
      assign i-mo-codigo:screen-value = string(pi-mo-codigo).
      run getcharfield in h-boin082(input "un", output c-unidade).
      assign c-unid:screen-value = c-unidade.
   end.

   /* Busca descri‡Æo de campos estrangeiros */
   run findCodigo in h-boad098(input tt-cotacao-item-cex.cod-emitente, output c-return).
   if c-return = "" then
      run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
   assign c-desc-emitente:screen-value = c-nome-abrev.

   run findCodigo in h-bocx115(input tt-cotacao-item-cex.cod-itiner, output c-return).
   if c-return = "" then
      run getCharfield in h-bocx115(input "descricao",output c-descricao).
   assign c-desc-itinerario:screen-value = c-descricao.

   run findCodigo in h-boun005(input pi-mo-codigo,output c-return).
   if c-return = "" then
      run getCharfield in h-boun005(input "descricao",output c-moeda).
   assign c-desc-moeda:screen-value = c-moeda.
   
   /* Abre a query para os registros do browser filho */
   if valid-handle(h-b05cx085) then do:
      RUN pi-set-constraint in h-b05cx085 (input tt-cotacao-item-cex.numero-ordem,
                                           input tt-cotacao-item-cex.cod-emitente,
                                           input tt-cotacao-item-cex.it-codigo,
                                           input tt-cotacao-item-cex.seq-cotac,
                                           input tt-cotacao-item-cex.data-cotacao,
                                           input tt-cotacao-item-cex.mapa-cotacao,
                                           input this-procedure).

   end.

   

end.
&if "{&bf_mat_versao_ems}" >= "2.062" &then
    ELSE DO:
        RUN verifica-buttons IN h-b05cx085(INPUT YES).
        RUN pi-disable-panel2 in h_window.
    END.
&ENDIF

RUN dispatch IN h-b05cx085 ('open-query':U).
RUN limpa-temp-tables.

/*/* Dispatch standard ADM method.                             */
 * RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).*/
  
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
    if adm-new-record = yes then
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
  run cxbo/bocx085.p persistent set h-bocx085.
  run adbo/boad098.p persistent set h-boad098.
  run cxbo/bocx115.p persistent set h-bocx115.
  run inbo/boin082.p persistent set h-boin082.
  run unbo/boun005.p persistent set h-boun005.
  
  &if defined(bf-mat-comex) &then
    assign h-mo-codigo = i-mo-codigo:side-label-handle in frame {&frame-name}
           i-seq-cotac:hidden  in frame {&frame-name} = yes
           i-mo-codigo:row     in frame {&frame-name} = 2.25
           i-mo-codigo:column  in frame {&frame-name} = 58
           h-mo-codigo:column = 52.50
           c-desc-moeda:column in frame {&frame-name} = 62.29.
  &else  
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
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo
           r-chave      = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-b05cx085 as handle no-undo.
  def input parameter p-window   as handle no-undo. /* handle da window que chama a viewer */

  assign h-b05cx085 = p-b05cx085
         h_window = p-window.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-principal V-table-Win 
PROCEDURE pi-principal :
/*
**
** Procedure respons vel pelas a‡äes do programa.    
**
*/
def input parameter p-param as char no-undo. 
    
run setConstraint1 in h-bocx085.
run openQuery in h-bocx085(input 1).

run limpa-temp-tables.    
assign c-param = p-param.

if gr-cotacao-item-cex <> ? then
    assign c-param             = "atualiza":U
           r-chave             = gr-cotacao-item-cex
           gr-cotacao-item-cex = ?.

if c-param = "pri":U and gr-im0010-cotacao-item-cex <> ? then
    assign c-param                    = "atualiza":U
           r-chave                    = gr-im0010-cotacao-item-cex
           gr-im0010-cotacao-item-cex = ?.
case c-param:
    when "pri":U then do:
        RUN findFirst in h-bocx085.
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    end.            
    when "ult":U then do:
        RUN findLast in h-bocx085.            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    end.
    when "pre":U then do:        
        RUN findRowid2 in h-bocx085 (input r-chave).
        RUN findPrev in h-bocx085 (output c-return).
        if c-return <> "" then
            RUN utp/ut-msgs.p(input "show":U,
                              input 7998,
                              input "").
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).                                  
    end.
    when "pos":U then do:
        RUN findRowid2 in h-bocx085 (input r-chave).
        RUN findNext in h-bocx085 (output c-return).
        if c-return <> "" then
            RUN utp/ut-msgs.p(input "show":U,
                              input 7999,
                              input "").
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).                                  
    end.
    when "add":U then do:
        RUN imp/im0010a.w (input-output r-chave,input "add":U).  
        RUN findRowid2 in h-bocx085 (input r-chave).            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    end.
    when "cop":U then do:
        RUN imp/im0010a.w (input-output r-chave,input "cop":U).
        RUN findRowid2 in h-bocx085 (input r-chave).            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).            
    end.
    when "del":U then do:
        {utp/ut-table.i mgcex cotacao-item-cex 1}
        run utp/ut-msgs.p (input "show":U,
                           input 4350,
                           input return-value).
        if return-value = "yes":U then do:
            if integer(tt-numero-ordem:screen-value in frame {&frame-name}) = gi-numero-ordem-alt then
                RUN validateDeletePaicc0308 in h-bocx085(input-output r-chave,output table tt-bo-erro).
            else        
                RUN validateDeletePai in h-bocx085(input-output r-chave,output table tt-bo-erro).
            find first tt-bo-erro no-error.
            if avail tt-bo-erro then do:
                run utp/ut-msgs.p (input "show":U,
                                   input tt-bo-erro.cd-erro,
                                   input tt-bo-erro.parametros).
                return "adm-error":U.                                       
            end.
            RUN findRowid2 in h-bocx085 (input r-chave).            
            RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).
        end.      
    end.
    when "go":U then do:
        RUN cxgo/g01cx085.w (output r-chave).
        RUN findRowid2 in h-bocx085 (input r-chave).            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).            
    end.
    when "atualiza":U then do:
        RUN findRowid2 in h-bocx085 (input r-chave).            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    end.            
    when "zoom":U then do:
        RUN cxzoom/z01cx085.w(output r-chave).
        RUN findRowid2 in h-bocx085 (input r-chave).            
        RUN getCurrent in h-bocx085(output table tt-cotacao-item-cex).            
    end.    
    when "aprova":U then do:
        if integer(tt-numero-ordem:screen-value in frame {&frame-name}) = gi-numero-ordem-alt then
            RUN aprovaMapacc0308 in h-bocx085(input r-chave, output table tt-bo-erro).
        else
            RUN aprovaMapa in h-bocx085(input r-chave,output table tt-bo-erro).
        find first tt-bo-erro no-error.
        if avail tt-bo-erro then
            run utp/ut-msgs.p (input "show":U,
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
    end.    
end case.

RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
RUN dispatch IN THIS-PROCEDURE ('disable-fields':U).
    
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
  {src/adm/template/snd-list.i "item"}

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

