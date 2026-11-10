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
{include/i-prgvrs.i V63IN172 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V63IN172 MUT}
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

def new global shared temp-table tt-deposito no-undo
   field cod-depos  like deposito.cod-depos
   field nome       like deposito.nome
   field cons-saldo like deposito.cons-saldo
   field lista      as logical format "Sim/NÆo" init yes label "Consid". 
   
/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE de-qt-saldo AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE de-qtd-ord AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.it-codigo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un item.tempo-segur ~
item.data-ult-ent item.quant-segur item.lote-economi item.consumo-aad ~
item.data-ult-sai item.quant-perda item.lote-minimo item.consumo-prev ~
item.lote-multipl item.fator-refugo 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-compr-fabric ~
c-tipo-controle-estoque-segur de-pto-enc c-emissao-ordens de-tmp-ressup ~
de-est-seg c-demanda de-qt-saldo1 de-qtd-ord1 c-obs 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item.it-codigo item.un item.tempo-segur ~
item.data-ult-ent item.quant-segur item.lote-economi item.consumo-aad ~
item.data-ult-sai item.quant-perda item.lote-minimo item.consumo-prev ~
item.lote-multipl item.fator-refugo 

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
DEFINE VARIABLE c-compr-fabric AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-demanda AS CHARACTER FORMAT "X(15)":U 
     LABEL "Fill 10" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-emissao-ordens AS CHARACTER FORMAT "X(13)":U 
     LABEL "Fill 6" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-obs AS CHARACTER FORMAT "X(12)":U 
     LABEL "Observa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-controle-estoque-segur AS CHARACTER FORMAT "X(13)":U 
     LABEL "Fill 4" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Estoque Seguran‡a" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-pto-enc AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Ponto Encomenda" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-qt-saldo1 AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-ord1 AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade Ordens" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-tmp-ressup AS DECIMAL FORMAT ">>>9":U INITIAL 0 
     LABEL "Tempo Ressuprimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.17 COL 23 COLON-ALIGNED NO-LABEL
     item.un AT ROW 1.17 COL 71.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-compr-fabric AT ROW 1.17 COL 76 COLON-ALIGNED NO-LABEL
     c-tipo-controle-estoque-segur AT ROW 2.67 COL 24.57 COLON-ALIGNED
     item.tempo-segur AT ROW 2.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     de-pto-enc AT ROW 3.67 COL 24.57 COLON-ALIGNED
     item.data-ult-ent AT ROW 3.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.quant-segur AT ROW 4.67 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-economi AT ROW 4.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.consumo-aad AT ROW 5.67 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-emissao-ordens AT ROW 5.67 COL 67 COLON-ALIGNED
     de-tmp-ressup AT ROW 6.67 COL 24.57 COLON-ALIGNED
     de-est-seg AT ROW 6.67 COL 67 COLON-ALIGNED
     item.data-ult-sai AT ROW 7.67 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.quant-perda AT ROW 7.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-minimo AT ROW 8.67 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.consumo-prev AT ROW 8.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     c-demanda AT ROW 9.67 COL 24.57 COLON-ALIGNED
     de-qt-saldo1 AT ROW 9.67 COL 67 COLON-ALIGNED
     de-qtd-ord1 AT ROW 10.67 COL 24.57 COLON-ALIGNED
     item.lote-multipl AT ROW 10.67 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.fator-refugo AT ROW 11.67 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-obs AT ROW 11.67 COL 67 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
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
         HEIGHT             = 11.75
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-compr-fabric IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-demanda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emissao-ordens IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-obs IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-controle-estoque-segur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.consumo-aad IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.consumo-prev IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.data-ult-ent IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.data-ult-sai IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-est-seg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pto-enc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qt-saldo1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-ord1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tmp-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.fator-refugo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN item.lote-economi IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.lote-minimo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.lote-multipl IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.quant-perda IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.quant-segur IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.tempo-segur IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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

if avail item then do:
  
  assign c-descricao = item.desc-item.
                       
  assign de-pto-enc  = 0
         de-est-seg  = (if item.tipo-est-seg = 1
                           then item.quant-segur
                           else item.consumo-prev / 30 * item.tempo-segur)
         de-pto-enc  = de-est-seg + 
                       ((item.res-int-comp + 
                       item.res-for-comp +
                       item.res-cq-comp)
                       * item.consumo-prev / 30)
         de-qt-saldo = 0 
         de-qtd-ord  = 0.

                       
  for each saldo-estoq use-index item where
     saldo-estoq.it-codigo = item.it-codigo no-lock:
     find first tt-deposito where
          tt-deposito.cod-depos = saldo-estoq.cod-depos no-lock no-error.
          
     if not avail tt-deposito or 
        not tt-deposito.lista or 
        not tt-deposito.cons-saldo then
        next. 

     assign de-qt-saldo = de-qt-saldo + saldo-estoq.qtidade-atu.
  end.
  
  for each prazo-compra use-index ch-saldo where
     prazo-compra.it-codigo = item.it-codigo and
     prazo-compra.quant-saldo > 0 no-lock:
     find first ordem-compra where
        ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock no-error.
     if not avail ordem-compra then 
        next.
     if ordem-compra.dep-almoxar <> "" then do:
        find first tt-deposito where
           tt-deposito.cod-depos = ordem-compra.dep-almoxar no-lock no-error.
        if not avail tt-deposito or
           not tt-deposito.lista or 
           not tt-deposito.cons-saldo then 
           next.
     end.
     if prazo-compra.situacao <> 6 and
        prazo-compra.situacao <> 4 then
        assign de-qtd-ord = de-qtd-ord + prazo-compra.quant-saldo.
  end.

  for each ord-prod use-index item no-lock where
     ord-prod.it-codigo = item.it-codigo and
     ord-prod.qt-ordem - ord-prod.qt-produzida > 0 and
     ord-prod.estado <> 8:
     assign de-qtd-ord = de-qtd-ord + ord-prod.qt-ordem - ord-prod.qt-produzida.
  end.
         
  assign c-obs = (if de-qt-saldo + de-qtd-ord < de-est-seg then
                     "Abaixo Seg" else
                  if de-qt-saldo + de-qtd-ord < de-pto-enc then
                     "Abaixo Enc" else "")
         de-tmp-ressup = (if item.compr-fabric = 1 then
                             item.res-int-comp + item.res-for-comp + item.res-cq-comp
                          else item.ressup-fabri + item.res-cq-fabri).
   
  assign de-qt-saldo1 = de-qt-saldo
         de-qtd-ord1  = de-qtd-ord.
          
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   
  /* Code placed here will execute AFTER standard behavior.    */
  
  if item.compr-fabric = 1 then do:
     {utp/ut-liter.i Comprado MCE} 
     assign c-compr-fabric:screen-value in frame {&frame-name} = trim(return-value).
  end.   
  if item.compr-fabric = 2 then do:
     {utp/ut-liter.i Fabricado MCE}
     assign c-compr-fabric:screen-value in frame {&frame-name} = trim(return-value).
  end.   
     
  if item.tipo-est-seg = 1 then do:
     {utp/ut-liter.i Quantidade MCE}
     assign c-tipo-controle-estoque-segur:screen-value in frame {&frame-name} = trim(return-value).
  end.   
  if item.tipo-est-seg = 2 then do:
     {utp/ut-liter.i Tempo MCE} 
     assign c-tipo-controle-estoque-segur:screen-value in frame {&frame-name} = trim(return-value).
  end.
     
  if item.emissao-ord = 1 then do:
     {utp/ut-liter.i Autom tica MCE}
     assign c-emissao-ordens:screen-value in frame {&frame-name} = trim(return-value).
  end.   
  if item.emissao-ord = 2 then do:
     {utp/ut-liter.i Manual MCE}
     assign c-emissao-ordens:screen-value in frame {&frame-name} = trim(return-value).
  end.   
     
  if item.demanda = 1 then do:
     {utp/ut-liter.i Dependente MCE}
     assign c-demanda:screen-value in frame {&frame-name} = trim(return-value).
  end.   
  if item.demanda = 2 then do:
     {utp/ut-liter.i Independente MCE}
     assign c-demanda:screen-value in frame {&frame-name} = trim(return-value).
  end.   

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
  
  {utp/ut-liter.i Quantidade_Ordens * L}
  assign de-qtd-ord1:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Saldo * L}
  assign de-qt-saldo1:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item compr-fabric 1}
  assign c-compr-fabric = return-value.
  
  {utp/ut-field.i mgind item tipo-est-seg 1}
  assign c-tipo-controle-estoque-segur:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item emissao-ord 1}
  assign c-emissao-ordens:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item demanda 1}
  assign c-demanda:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Ponto_Encomenda MCE} 
  assign de-pto-enc:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Tempo_Ressuprimento MCE} 
  assign de-tmp-ressup:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Estoque_Seguran‡a MCE} 
  assign de-est-seg:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Observa‡Æo} 
  assign c-obs:label in frame {&FRAME-NAME} = trim(return-value).
 
                             
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  for each tt-deposito:
      delete tt-deposito.
  end.
  for each deposito no-lock:
      create tt-deposito.
      assign tt-deposito.cod-depos  = deposito.cod-depos
             tt-deposito.nome       = deposito.nome
             tt-deposito.cons-saldo = deposito.cons-saldo
             tt-deposito.lista      = yes.
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
   
   /*Segue um exemplo de valida‡Æo de programa 
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


