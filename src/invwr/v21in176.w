&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V21IN176 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v21in176 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

    def var v-row-parent as rowid no-undo.

    def new global shared var gr-docum-est    as rowid no-undo.
    def new global shared var i-programa-re as integer no-undo.
    /**
    ***  Recebimento   1 - Normal
    ***                2 - F°sico
    ***                3 - Internacional
    **/

    {rep/re9800.i}
    {cdp/cd0666.i}
    def var de-preco-total      like item-doc-est.preco-total[1] no-undo.
    def var de-taxa             like item-doc-est.vl-taxa        no-undo.
    def var de-preco-unit       as decimal                       no-undo.
    def var de-desconto         as decimal                       no-undo.
    def var i-cod-tax-aux       like item-doc-est.cod-tax        no-undo.
    def var i-base-imposto      as integer                       no-undo. /* 1 = bruto 2 = liquido */
    def var i-tax-tip-calculo   as integer                       no-undo.
    def var i-isr-tip-calculo   as integer                       no-undo.


{cdp/cd4300.i3}  /*Vari†veis para o cd4300.i4 */
{rep/re1001b.i50} /*Vari†veis para o re1001b.i51*/
{cep/ce1234.i}    /* Validaá∆o Decimais */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.cod-tax item-doc-est.perc-vat ~
item-doc-est.vl-taxa-me 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-tax ~{&FP2}cod-tax ~{&FP3}~
 ~{&FP1}perc-vat ~{&FP2}perc-vat ~{&FP3}~
 ~{&FP1}vl-taxa-me ~{&FP2}vl-taxa-me ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key-2 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.cod-tax item-doc-est.perc-vat ~
item-doc-est.vl-taxa-me item-doc-est.cod-tax-isr item-doc-est.perc-isr 
&Scoped-Define DISPLAYED-OBJECTS c-desc-tax c-desc-isr fi-vl-isr-me 

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
DEFINE VARIABLE c-desc-isr AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tax AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-isr-me AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 9.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.cod-tax AT ROW 2.5 COL 32.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-tax AT ROW 2.5 COL 37.57 COLON-ALIGNED NO-LABEL
     item-doc-est.perc-vat AT ROW 3.5 COL 32.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-doc-est.vl-taxa-me AT ROW 4.5 COL 32.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     item-doc-est.cod-tax-isr AT ROW 5.5 COL 32.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-isr AT ROW 5.5 COL 37.86 COLON-ALIGNED NO-LABEL
     item-doc-est.perc-isr AT ROW 6.5 COL 32.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-vl-isr-me AT ROW 7.5 COL 32.43 COLON-ALIGNED
     rt-key-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-doc-est
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
         HEIGHT             = 9.17
         WIDTH              = 86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-isr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tax IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.cod-tax-isr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-isr-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.perc-isr IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME item-doc-est.cod-tax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax V-table-Win
ON ENTRY OF item-doc-est.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  assign i-cod-tax-aux = input frame {&frame-name} item-doc-est.cod-tax.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax V-table-Win
ON F5 OF item-doc-est.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:

    {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                       &campo=item-doc-est.cod-tax
                       &campozoom=cod-tax}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax V-table-Win
ON LEAVE OF item-doc-est.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:

    {include/leave.i &tabela=tipo-tax
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tax
                     &where="tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax"}

    if available tipo-tax then do:
       assign item-doc-est.perc-vat:sensitive in frame {&frame-name} = yes
              item-doc-est.vl-taxa-me:sensitive in frame {&frame-name} = yes.  
       if input frame {&frame-name} item-doc-est.cod-tax <> i-cod-tax-aux then do:
            assign item-doc-est.perc-vat:screen-value in frame  {&frame-name} = string(tipo-tax.tax-perc).
            run pi-calcula-tax.
       end.
       apply "entry" to item-doc-est.perc-vat in frame {&frame-name}.
       return no-apply.
    end.
    else
        assign item-doc-est.perc-vat:screen-value in frame {&frame-name} = "0" 
               item-doc-est.vl-taxa-me:screen-value in frame {&frame-name} = "0"
               item-doc-est.perc-vat:sensitive in frame {&frame-name} = no
               item-doc-est.vl-taxa-me:sensitive in frame {&frame-name} = no.  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:

        apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.cod-tax-isr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax-isr V-table-Win
ON ENTRY OF item-doc-est.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  assign i-cod-tax-aux = input frame {&frame-name} item-doc-est.cod-tax-isr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax-isr V-table-Win
ON F5 OF item-doc-est.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                     &campo=item-doc-est.cod-tax-isr
                     &campozoom=cod-tax-isr}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax-isr V-table-Win
ON LEAVE OF item-doc-est.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  {include/leave.i &tabela=tipo-tax
                 &atributo-ref=descricao
                 &variavel-ref=c-desc-isr
                 &where="tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax-isr"}

  if available tipo-tax then do:
      if input frame {&frame-name} item-doc-est.cod-tax-isr <> i-cod-tax-aux  then do:
        assign item-doc-est.perc-isr:screen-value in frame  {&frame-name} = string(tipo-tax.tax-perc).
        run pi-calcula-isr.
      end.        
  end.           
  else 
     assign item-doc-est.perc-isr:screen-value = "0" 
            fi-vl-isr-me:screen-value = "0" .  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-tax-isr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.perc-isr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.perc-isr V-table-Win
ON LEAVE OF item-doc-est.perc-isr IN FRAME f-main /* Taxa Serviáo */
DO:
  run pi-calcula-isr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.perc-vat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.perc-vat V-table-Win
ON LEAVE OF item-doc-est.perc-vat IN FRAME f-main /* Perc Taxa */
DO:
  run pi-calcula-tax. 
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

    if item-doc-est.cod-tax:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if item-doc-est.cod-tax-isr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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

  assign item-doc-est.vl-taxa-me:screen-value in frame {&frame-name} = "0"
         item-doc-est.vl-taxa-me:sensitive in frame {&frame-name} = no
         item-doc-est.perc-vat:sensitive in frame {&frame-name} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var de-taxa        as decimal no-undo.
  def var de-taxa-me     as decimal no-undo.
  def var de-isr         as decimal no-undo.
  def var de-isr-me      as decimal no-undo.


  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  if  adm-new-record = no then do:
    /*retira o valor do isr-me da vari†vel char-1 e joga na vari†ve de-vl-isr-me*/
    {cdp/cd4300.i4  "yes" item-doc-est.char-1}             
    {rep/re1001b.i51 "yes"}

    assign de-taxa        = if i-tax-tip-calculo = 1 then item-doc-est.vl-taxa    else 0
           de-taxa-me     = if i-tax-tip-calculo = 1 then item-doc-est.vl-taxa-me else 0
           de-isr         = if i-isr-tip-calculo = 1 then item-doc-est.vl-isr     else 0
           de-isr-me      = if i-isr-tip-calculo = 1 then de-vl-isr-me            else 0.
  end.           
  else 
    assign de-taxa        = 0
           de-taxa-me     = 0
           de-isr         = 0
           de-isr-me      = 0.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "de-cotacao").


        /*I-tax-tip-calculo/i-isr-tip-calculo indica se o imposto j† est† inclu°do no preáo 
          total do item. Se for igual a 2, o imposto j† est† inclu°do e desta forma ser† retirado
          na geraá∆o do movto estoque. Se for igual a 1, o imposto n∆o est† inclu°do e ser† somado
          na geraá∆o dos documentos no AP. */
      assign item-doc-est.vl-taxa    = fn_ajust_dec(item-doc-est.vl-taxa-me * dec(return-value), 0).
      assign de-vl-isr-me            = input frame {&FRAME-NAME} fi-vl-isr-me.
      assign item-doc-est.vl-isr     = fn_ajust_dec(de-vl-isr-me * dec(return-value), 0).
      assign de-tot-taxa-item        = if i-tax-tip-calculo = 1 then item-doc-est.vl-taxa    else 0
                                     + if i-isr-tip-calculo = 1 then item-doc-est.vl-isr     else 0
             de-tot-taxa-item-me     = if i-tax-tip-calculo = 1 then item-doc-est.vl-taxa-me else 0
                                     + if i-isr-tip-calculo = 1 then de-vl-isr-me            else 0
             de-taxa-inc-item        = if i-tax-tip-calculo = 2 then item-doc-est.vl-taxa    else 0
                                     + if i-isr-tip-calculo = 2 then item-doc-est.vl-isr     else 0
             de-taxa-inc-item-me     = if i-tax-tip-calculo = 2 then item-doc-est.vl-taxa-me else 0
                                     + if i-isr-tip-calculo = 2 then de-vl-isr-me            else 0.

  {rep/re1001b.i51 "no"}
  {cdp/cd4300.i4  "no" item-doc-est.char-1}

  assign docum-est.tot-taxa        = docum-est.tot-taxa
                                   + (de-tot-taxa-item - de-taxa - de-isr)
         docum-est.tot-taxa-me     = docum-est.tot-taxa-me
                                   + (de-tot-taxa-item-me - de-taxa-me - de-isr-me).

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

  if avail item-doc-est then do:
    /*retira o valor do isr-me da vari†vel char-1 e joga na vari†ve de-vl-isr-me*/
    {cdp/cd4300.i4  "yes" item-doc-est.char-1}             
    {rep/re1001b.i51 "yes"}
    assign fi-vl-isr-me:screen-value in frame {&FRAME-NAME} = string(de-vl-isr-me).
    find tipo-tax where
         tipo-tax.cod-tax = item-doc-est.cod-tax no-lock no-error.
    if avail tipo-tax then 
        assign c-desc-tax:screen-value in frame {&frame-name} = tipo-tax.descricao.
    if avail emitente and emitente.identific = 1 then do:
        find tipo-tax where
             tipo-tax.cod-tax = item-doc-est.cod-tax-isr no-lock no-error.
        if avail tipo-tax then 
            assign c-desc-isr:screen-value in frame {&frame-name} = tipo-tax.descricao.
    end.        
  end.

  {utp/ut-field.i mgind item-doc-est vl-isr 1}
  assign fi-vl-isr-me:label in frame {&FRAME-NAME} = return-value.

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record = yes then do:
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
  end.

  find tipo-tax where
       tipo-tax.cod-tax = item-doc-est.cod-tax no-lock no-error.
  if avail tipo-tax then 
     assign item-doc-est.perc-vat:sensitive in frame {&frame-name}   = yes
            item-doc-est.vl-taxa-me:sensitive in frame {&frame-name} = yes.  
  else
     assign item-doc-est.perc-vat:sensitive in frame {&frame-name}   = no
            item-doc-est.vl-taxa-me:sensitive in frame {&frame-name} = no.  

  do with frame {&FRAME-NAME}:
    assign item-doc-est.cod-tax:sensitive     = param-re.pd-cd-ipi    and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
           item-doc-est.perc-vat:sensitive    = param-re.pd-aliq-ipi  and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
           item-doc-est.vl-taxa-me:sensitive  = param-re.ped-imp-nota and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic)) 
           item-doc-est.cod-tax-isr:sensitive = emitente.identific = 1 and param-re.pd-cd-ipi    and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
           item-doc-est.perc-isr:sensitive    = emitente.identific = 1 and param-re.pd-aliq-ipi  and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
           fi-vl-isr-me:sensitive        = emitente.identific = 1 and param-re.ped-imp-nota and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic)).
  end.         

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
    find docum-est where
        rowid(docum-est) = gr-docum-est
        no-lock no-error.
    if avail docum-est then do:
        find emitente where
            emitente.cod-emitente = docum-est.cod-emitente
            no-lock no-error.
        find natur-oper where
            natur-oper.nat-operacao = docum-est.nat-operacao
            no-lock no-error.
        if avail natur-oper then do:            
            if trim(substring(natur-oper.char-2,11,1)) <> "" then
                assign i-base-imposto = int(substring(natur-oper.char-2,11,1)).
            else assign i-base-imposto = 1.  /*1=bruto 2=liquido*/          
        end.            
    end.
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.
    find first param-global
        no-lock no-error.
    find first param-compra
        no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-imposto V-table-Win 
PROCEDURE pi-atualiza-imposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run pi-calcula-tax.            
    if emitente.natureza = 1 then 
        run pi-calcula-isr.                                                    

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-isr V-table-Win 
PROCEDURE pi-calcula-isr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "preco-total-me").
  assign de-preco-total = dec(return-value).
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "desconto-me").
  assign de-desconto = dec(return-value).

  find tipo-tax where 
         tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax-isr
         no-lock no-error.
  if avail tipo-tax and tipo-tax.ind-tip-calculo = 1 then         /* Imposto -> Base 100% */
     assign de-preco-total = de-preco-total 
                           - if avail tipo-tax and tipo-tax.int-1 = 2 then de-desconto  /*indica que calcula o imposto pelo valor liquido*/
                                                             else 0.
  else if avail tipo-tax and tipo-tax.ind-tip-calculo = 2 then    /* Imposto -> Base 100% + IVA */
          assign de-preco-total = fn_ajust_dec((de-preco-total / (input frame {&frame-name} item-doc-est.perc-isr + 100) * 100), docum-est.mo-codigo) 
                                - if avail tipo-tax and tipo-tax.int-1 = 2 then de-desconto  /*indica que calcula o imposto pelo valor liquido*/
                                                                           else 0.

  assign fi-vl-isr-me:screen-value in frame {&frame-name} = string(fn_ajust_dec(de-preco-total * 
                                      (input frame {&frame-name} item-doc-est.perc-isr / 100), docum-est.mo-codigo)). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-tax V-table-Win 
PROCEDURE pi-calcula-tax :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "preco-total-me").
  assign de-preco-total = dec(return-value).
  RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "desconto-me").
  assign de-desconto = dec(return-value).

  find tipo-tax where 
         tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax
         no-lock no-error.
  if avail tipo-tax and tipo-tax.ind-tip-calculo = 1 then         /* Imposto -> Base 100% */
     assign de-preco-total = de-preco-total 
                           - if avail tipo-tax and tipo-tax.int-1 = 2 then de-desconto  /*indica que calcula o imposto pelo valor liquido*/
                                                                      else 0.
  else if avail tipo-tax and tipo-tax.ind-tip-calculo = 2 then    /* Imposto -> Base 100% + IVA */
          assign de-preco-total = fn_ajust_dec((de-preco-total / (input frame {&frame-name} item-doc-est.perc-vat + 100) * 100), docum-est.mo-codigo) 
                                - if avail tipo-tax and tipo-tax.int-1 = 2 then de-desconto  /*indica que calcula o imposto pelo valor liquido*/
                                                                           else 0.

  assign item-doc-est.vl-taxa-me:screen-value in frame {&frame-name} = string(fn_ajust_dec(de-preco-total * 
                                                        (input frame {&frame-name} item-doc-est.perc-vat / 100), docum-est.mo-codigo)). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param p-sequencia like item-doc-est.sequencia.
  def input param p-it-codigo like item.it-codigo.

  find item 
     where item.it-codigo = p-it-codigo no-lock no-error.

  find familia 
     where familia.fm-codigo = item.fm-codigo no-lock no-error.

  find estabelec 
     where estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.

  find pais 
     where pais.nome-pais = estabelec.pais no-lock no-error. 

  find emitente 
     where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.

  if  avail item 
  and adm-new-record 
  and (   docum-est.nff 
       or ( not docum-est.nff and natur-oper.emite-duplic )) then 
  do with frame {&frame-name}:

      &if  defined(bf_mat_iva_compras) &then
           find item-mat
               where item-mat.it-codigo = item.it-codigo no-lock no-error.
           if  avail item-mat then
               assign i-cod-tax-aux = item-mat.cod-tax.
      &else
           assign i-cod-tax-aux = item.cod-tax.
      &endif

      find tipo-tax 
          where tipo-tax.cod-tax = i-cod-tax-aux no-lock no-error.

      assign item-doc-est.cod-tax:screen-value  = if  avail tipo-tax 
                                                  then string(tipo-tax.cod-tax)
                                                  else "0"
             c-desc-tax:screen-value            = if  avail tipo-tax 
                                                  then tipo-tax.descricao
                                                  else ""  
             item-doc-est.perc-vat:screen-value = if avail tipo-tax 
                                                  then string(tipo-tax.tax-perc)
                                                  else "0".
      run pi-calcula-tax.            

      if  avail emitente and emitente.natureza = 1 then do:
          find tipo-tax 
              where tipo-tax.cod-tax = item.cod-tax-serv no-lock no-error.

          assign item-doc-est.cod-tax-isr:screen-value = string(item.cod-tax-serv)
                 c-desc-isr:screen-value               = if  avail tipo-tax 
                                                         then tipo-tax.descricao
                                                         else ""  
                 item-doc-est.perc-isr:screen-value    = if  avail tipo-tax 
                                                         then string(tipo-tax.tax-perc)
                                                         else "0".
          run pi-calcula-isr.                                                    
      end.            
  end.
  else
      if  not avail item then 
          assign item-doc-est.cod-tax:screen-value     = "0"
                 item-doc-est.perc-vat:screen-value    = "0" 
                 item-doc-est.vl-taxa-me:screen-value  = "0"            
                 item-doc-est.cod-tax-isr:screen-value = "0" 
                 item-doc-est.perc-isr:screen-value    = "0" 
                 fi-vl-isr-me:screen-value             = "0" .  


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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
  assign i-tax-tip-calculo = 1
         i-isr-tip-calculo = 1.

  if (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
  and   (input frame {&frame-name} item-doc-est.cod-tax  <> 0 
      or input frame {&frame-name} item-doc-est.perc-vat <> 0
      or input frame {&frame-name} item-doc-est.vl-taxa-me  <> 0) then do:   
    find tipo-tax where 
         tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax
         no-lock no-error.
    if not avail tipo-tax and 
       input frame {&frame-name} item-doc-est.cod-tax <> 0 then do:
        {include/i-vldprg.i}                   
        {utp/ut-table.i mgdis tipo-tax 1}
        run utp/ut-msgs.p (input "show", input 2, input return-value).
        apply 'entry' to item-doc-est.cod-tax in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    assign i-tax-tip-calculo = tipo-tax.ind-tip-calculo.
  end.    
  if  avail emitente and emitente.natureza = 1 
  and (docum-est.nff or (not docum-est.nff and natur-oper.emite-duplic))
  and   (input frame {&frame-name} item-doc-est.cod-tax-isr  <> 0 
      or input frame {&frame-name} item-doc-est.perc-isr     <> 0
      or input frame {&frame-name} fi-vl-isr-me       <> 0) then do:   

      find tipo-tax where 
           tipo-tax.cod-tax = input frame {&frame-name} item-doc-est.cod-tax-isr
           no-lock no-error.
      if not avail tipo-tax and 
          input frame {&frame-name} item-doc-est.cod-tax-isr  <> 0 then do:
          {include/i-vldprg.i}                   
          {utp/ut-table.i mgdis tipo-tax 1}
          run utp/ut-msgs.p (input "show", input 2, input return-value).
          apply 'entry' to item-doc-est.cod-tax-isr in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      assign i-isr-tip-calculo = tipo-tax.ind-tip-calculo.
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
  {src/adm/template/snd-list.i "item-doc-est"}

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


