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
{include/i-prgvrs.i V53IN172 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V53IN172 MUT}
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

{cdp/cdcfgmat.i}        /* Release 2.02 - Materiais */

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.         

{include/i-vrtab.i grup-estoque}
{include/i-vrtab.i familia}
{include/i-vrtab.i deposito}
{include/i-vrtab.i natureza-despesa}
                       
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-FIELDS item.ge-codigo item.nat-despesa ~
item.fm-codigo item.cod-localiz item.peso-liquido item.loc-unica ~
item.preco-ul-ent item.preco-repos item.deposito-pad item.aliquota-ipi ~
item.data-ult-ent item.aliquota-ISS item.data-ult-sai item.cod-tax-serv 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ge-codigo ~{&FP2}ge-codigo ~{&FP3}~
 ~{&FP1}nat-despesa ~{&FP2}nat-despesa ~{&FP3}~
 ~{&FP1}fm-codigo ~{&FP2}fm-codigo ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}~
 ~{&FP1}peso-liquido ~{&FP2}peso-liquido ~{&FP3}~
 ~{&FP1}preco-ul-ent ~{&FP2}preco-ul-ent ~{&FP3}~
 ~{&FP1}preco-repos ~{&FP2}preco-repos ~{&FP3}~
 ~{&FP1}deposito-pad ~{&FP2}deposito-pad ~{&FP3}~
 ~{&FP1}aliquota-ipi ~{&FP2}aliquota-ipi ~{&FP3}~
 ~{&FP1}data-ult-ent ~{&FP2}data-ult-ent ~{&FP3}~
 ~{&FP1}aliquota-ISS ~{&FP2}aliquota-ISS ~{&FP3}~
 ~{&FP1}data-ult-sai ~{&FP2}data-ult-sai ~{&FP3}~
 ~{&FP1}cod-tax-serv ~{&FP2}cod-tax-serv ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.ge-codigo item.nat-despesa ~
item.fm-codigo item.codigo-orig item.cod-localiz item.peso-liquido ~
item.loc-unica item.preco-ul-ent item.preco-repos item.deposito-pad ~
item.aliquota-ipi item.data-ult-ent item.aliquota-ISS item.data-ult-sai ~
item.cod-tax-serv 
&Scoped-Define DISPLAYED-OBJECTS c-tipo-controle-estoque ~
c-codigo-tributacao-icms fi-cod-tax fi-desc-impos c-codigo-tributacao-ipi ~
fi-desc-impos-2 c-cd-imp-servico 

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
DEFINE VARIABLE c-cd-imp-servico AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE c-codigo-tributacao-icms AS CHARACTER FORMAT "X(12)":U 
     LABEL "Fill 2" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-codigo-tributacao-ipi AS CHARACTER FORMAT "X(12)":U 
     LABEL "Fill 3" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-controle-estoque AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-tax AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "C¢digo Imposto":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-desc-impos AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-impos-2 AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.ge-codigo AT ROW 1.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item.nat-despesa AT ROW 1.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     item.fm-codigo AT ROW 2.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     item.codigo-orig AT ROW 2.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item.cod-localiz AT ROW 3.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     item.peso-liquido AT ROW 3.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.loc-unica AT ROW 4.25 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .88
     item.preco-ul-ent AT ROW 4.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-tipo-controle-estoque AT ROW 5.25 COL 21 COLON-ALIGNED
     item.preco-repos AT ROW 5.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     item.deposito-pad AT ROW 6.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     item.aliquota-ipi AT ROW 6.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     item.data-ult-ent AT ROW 7.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.aliquota-ISS AT ROW 7.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     item.data-ult-sai AT ROW 8.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     c-codigo-tributacao-icms AT ROW 8.25 COL 62 COLON-ALIGNED
     fi-cod-tax AT ROW 9.25 COL 21 COLON-ALIGNED
     fi-desc-impos AT ROW 9.25 COL 27.14 COLON-ALIGNED NO-LABEL
     c-codigo-tributacao-ipi AT ROW 9.25 COL 62 COLON-ALIGNED
     item.cod-tax-serv AT ROW 10.25 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-impos-2 AT ROW 10.25 COL 27.14 COLON-ALIGNED NO-LABEL
     c-cd-imp-servico AT ROW 10.25 COL 11.14 NO-LABEL
     rt-mold AT ROW 1 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.5
         WIDTH              = 85.72.
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

ASSIGN 
       item.aliquota-ipi:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       item.aliquota-ISS:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cd-imp-servico IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-codigo-tributacao-icms IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-codigo-tributacao-icms:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-codigo-tributacao-ipi IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-codigo-tributacao-ipi:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tipo-controle-estoque IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.codigo-orig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-tax IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-impos IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-impos:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-impos-2 IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-impos-2:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME item.cod-tax-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON F5 OF item.cod-tax-serv IN FRAME f-main /* Cod Imposto Servi‡o */
DO:
    l-implanta = yes.
 {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                    &campo=item.cod-tax-serv
                    &campozoom=cod-tax}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON LEAVE OF item.cod-tax-serv IN FRAME f-main /* Cod Imposto Servi‡o */
DO:
   find tipo-tax where 
        tipo-tax.cod-tax = input frame {&frame-name} item.cod-tax-serv no-lock no-error.
           
    if avail tipo-tax then
        assign fi-desc-impos-2:screen-value = tipo-tax.descricao.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-tax-serv IN FRAME f-main /* Cod Imposto Servi‡o */
DO:
  apply 'F5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-tax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tax V-table-Win
ON F5 OF fi-cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  l-implanta = yes.
 {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                    &campo=fi-cod-tax
                    &campozoom=cod-tax}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tax V-table-Win
ON LEAVE OF fi-cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
   find tipo-tax where 
        tipo-tax.cod-tax = input frame {&frame-name} fi-cod-tax no-lock no-error.
   if avail tipo-tax then
       assign fi-desc-impos:screen-value = tipo-tax.descricao.
 
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tax V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-tax IN FRAME f-main /* C¢digo Imposto */
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
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

  if  i-pais-impto-usuario <> 1  then 
      assign fi-cod-tax:sensitive in frame {&frame-name} = no
             fi-desc-impos:sensitive in frame {&FRAME-NAME} = no.
  
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
 
  assign c-tipo-controle-estoque:screen-value in frame {&FRAME-NAME} = {ininc/i01in122.i 04 item.tipo-con-est}
         c-codigo-tributacao-icms:screen-value in frame {&FRAME-NAME} = {ininc/i01in245.i 04 item.cd-trib-icm}
         c-codigo-tributacao-ipi:screen-value in frame {&FRAME-NAME} = {ininc/i10in172.i 04 item.cd-trib-ipi}.
 
  find tipo-tax where 
       tipo-tax.cod-tax = item.cod-tax no-lock no-error.
  if avail tipo-tax then
       assign fi-desc-impos:screen-value = tipo-tax.descricao.
  
  find tipo-tax where 
       tipo-tax.cod-tax = item.cod-tax-serv no-lock no-error.
  if avail tipo-tax then
       assign fi-desc-impos-2:screen-value = tipo-tax.descricao.
       
              
                     
       
  
  &if  defined(bf_mat_iva_compras) &then
       find item-mat
           where item-mat.it-codigo = item.it-codigo no-lock no-error.
       if  avail item-mat and item-mat.cod-tax <> 0 then
           assign fi-cod-tax:screen-value = string(item-mat.cod-tax).
                  /*fi-desc-impos:screen-value = tipo-tax.descricao.*/
  &else
       assign fi-cod-tax:screen-value = string(item.cod-tax).
              /*fi-desc-impos:screen-value = tipo-tax.descricao.*/
  &endif  

  /* 
  if item.tipo-con-est = 1 then
     assign c-tipo-controle-estoque:screen-value in frame {&frame-name} = "Serial".
  if item.tipo-con-est = 2 then
     assign c-tipo-controle-estoque:screen-value in frame {&frame-name} = "N£mero S‚rie".
  if item.tipo-con-est = 3 then
     assign c-tipo-controle-estoque:screen-value in frame {&frame-name} = "Lote".
  if item.tipo-con-est = 4 then
     assign c-tipo-controle-estoque:screen-value in frame {&frame-name} = "Referˆncia".
     
  if item.cd-trib-icm = 1 then
     assign c-codigo-tributacao-icms:screen-value in frame {&frame-name} = "Tributado".
  if item.cd-trib-icm = 2 then
     assign c-codigo-tributacao-icms:screen-value in frame {&frame-name} = "Isento".
  if item.cd-trib-icm = 3 then
     assign c-codigo-tributacao-icms:screen-value in frame {&frame-name} = "Outros".
  if item.cd-trib-icm = 4 then
     assign c-codigo-tributacao-icms:screen-value in frame {&frame-name} = "Reduzido". 
     
  if item.cd-trib-ipi = 1 then
     assign c-codigo-tributacao-ipi:screen-value in frame {&frame-name} = "Tributado".
  if item.cd-trib-ipi = 2 then
     assign c-codigo-tributacao-ipi:screen-value in frame {&frame-name} = "Isento".
  if item.cd-trib-ipi = 3 then
     assign c-codigo-tributacao-ipi:screen-value in frame {&frame-name} = "Outros".
  if item.cd-trib-ipi = 4 then
     assign c-codigo-tributacao-ipi:screen-value in frame {&frame-name} = "Reduzido".          
*/
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

  if  i-pais-impto-usuario <> 1 then 
      assign fi-cod-tax:sensitive in frame {&frame-name} = yes
             fi-desc-impos:sensitive in frame {&FRAME-NAME} = yes.
  
  
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
  {utp/ut-field.i mgind item tipo-con-est 1}
  assign c-tipo-controle-estoque:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item cd-trib-icm 1}
  assign c-codigo-tributacao-icms:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item cd-trib-ipi 1}
  assign c-codigo-tributacao-ipi:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i C¢digo_Imposto * L}
  assign fi-cod-tax:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Cd_Imp_Servi‡o * L}
  assign c-cd-imp-servico = return-value + ":".
  
  if i-pais-impto-usuario <> 1 then 
       assign fi-desc-impos:hidden       = no
              fi-desc-impos-2:hidden     = no.
  

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
  
    if avail item then do:
     find grup-estoque where grup-estoque.ge-codigo = item.ge-codigo no-lock no-error.
      if avail grup-estoque then
       assign gr-grup-estoque = rowid(grup-estoque).
     find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
      if avail familia then 
       assign gr-familia = rowid(familia).
     find deposito where deposito.cod-depos = item.deposito-pad no-lock no-error.
      if avail deposito then
       assign gr-deposito = rowid(deposito).
     find natureza-despesa where natureza-despesa.nat-despesa = item.nat-despesa no-lock no-error.
      if avail natureza-despesa then 
       assign gr-natureza-despesa = rowid(natureza-despesa).  
    end.        

  /* Code placed here will execute AFTER standard behavior.    */

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


