&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i VA6IN172 2.00.00.017}  /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i VA6IN172 MUT}
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
def new global shared var gr-item      as rowid no-undo.

/* Parameters Definitions ---                                           */
def var h-label-cod-tax                as handle no-undo.
def var h-label-cod-tax-serv           as handle no-undo.
def var h-label-desc-tax                as handle no-undo.
def var h-label-desc-tax-serv           as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.tp-desp-padrao item.nat-despesa ~
item.aliquota-ipi item.aliquota-ISS item.fator-reaj-icms item.class-fiscal ~
item.cod-tax-serv 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.tp-desp-padrao item.nat-despesa ~
item.aliquota-ipi item.aliquota-ISS item.fator-reaj-icms item.class-fiscal ~
item.cod-tax-serv 
&Scoped-Define DISPLAYED-OBJECTS fi-desc-tipo fi-desc-nat-desp ~
cb-cd-trib-icm cb-cd-trib-ipi cb-cd-trib-iss fi-desc-class-fisc ~
fi-cod-tax fi-desc-impos cb-ind-tipo-item ~
fi-base-pis-subs fi-base-cofins-subs 

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
DEFINE VARIABLE cb-cd-trib-icm AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo ICMS":R26 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-trib-ipi AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo IPI":R25 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-trib-iss AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo ISS":R25 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-tipo-item AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "":R25 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-base-cofins-subs AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Base COFINS Subs" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-pis-subs AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Base PIS Subs" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-tax AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "C¢digo Imposto":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-desc-class-fisc AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-impos AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-nat-desp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 10.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.tp-desp-padrao AT ROW 1.17 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     fi-desc-tipo AT ROW 1.17 COL 30.43 COLON-ALIGNED NO-LABEL
     item.nat-despesa AT ROW 2.17 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-nat-desp AT ROW 2.17 COL 31.57 COLON-ALIGNED NO-LABEL
     cb-cd-trib-icm AT ROW 3.17 COL 25.29 COLON-ALIGNED
     item.aliquota-ipi AT ROW 3.17 COL 65.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-cd-trib-ipi AT ROW 4.17 COL 25.29 COLON-ALIGNED
     item.aliquota-ISS AT ROW 4.17 COL 65.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-cd-trib-iss AT ROW 5.17 COL 25.29 COLON-ALIGNED
     item.fator-reaj-icms AT ROW 5.17 COL 65.14 COLON-ALIGNED
          LABEL "Fator Reaj ICMS":R23
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     item.class-fiscal AT ROW 6.17 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-desc-class-fisc AT ROW 6.17 COL 38.57 COLON-ALIGNED NO-LABEL
     fi-cod-tax AT ROW 7.17 COL 25.29 COLON-ALIGNED
     fi-desc-impos AT ROW 7.17 COL 31.57 COLON-ALIGNED NO-LABEL
     cb-ind-tipo-item AT ROW 8.13 COL 65.14 COLON-ALIGNED
     item.cod-tax-serv AT ROW 8.17 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-base-pis-subs AT ROW 9.17 COL 25.29 COLON-ALIGNED
     fi-base-cofins-subs AT ROW 9.17 COL 65.14 COLON-ALIGNED
     rt-mold AT ROW 1.04 COL 1
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
         HEIGHT             = 10.63
         WIDTH              = 86.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       item.aliquota-ipi:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       item.aliquota-ISS:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-icm IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-icm:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-ipi:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-iss IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-iss:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-ind-tipo-item IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-ind-tipo-item:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       item.class-fiscal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN item.fator-reaj-icms IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       item.fator-reaj-icms:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-base-cofins-subs IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-base-cofins-subs:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-base-pis-subs IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-base-pis-subs:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-tax IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-cod-tax:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-class-fisc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-class-fisc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-impos IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-impos:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-nat-desp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-tipo IN FRAME f-main
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

&Scoped-define SELF-NAME item.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON F5 OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in046.w"
                  &tabela=item
                  &atributo=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON LEAVE OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
   find classif-fisc
        where classif-fisc.class-fiscal = input frame {&frame-name} item.class-fiscal 
        no-lock no-error.
   if  avail classif-fisc then
       assign fi-desc-class-fisc:screen-value = classif-fisc.descricao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-tax-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON F5 OF item.cod-tax-serv IN FRAME f-main /* C¢digo Imposto Servi‡o */
DO:
    l-implanta = yes.
 {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                    &campo=item.cod-tax-serv
                    &campozoom=cod-tax}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-tax-serv IN FRAME f-main /* C¢digo Imposto Servi‡o */
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


&Scoped-define SELF-NAME item.nat-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON F5 OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
DO:
  l-implanta = yes.
 {include/zoomvar.i &prog-zoom="inzoom/z01in246.w"
                    &campo=item.nat-despesa
                    &campozoom=nat-despesa}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON LEAVE OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
DO:
   find natureza-despesa
        where natureza-despesa.nat-despesa = input frame {&frame-name} item.nat-despesa 
        no-lock no-error.
   if  avail natureza-despesa then
       assign fi-desc-nat-desp:screen-value = natureza-despesa.descricao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.tp-desp-padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.tp-desp-padrao V-table-Win
ON F5 OF item.tp-desp-padrao IN FRAME f-main /* Tipo Despesa */
DO:
 l-implanta =yes.
 {include/zoomvar.i &prog-zoom="adzoom/z01ad259.w"
                    &campo=item.tp-desp-padrao
                    &campozoom=tp-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.tp-desp-padrao V-table-Win
ON LEAVE OF item.tp-desp-padrao IN FRAME f-main /* Tipo Despesa */
DO:
   find tipo-rec-desp
       where tipo-rec-desp.tp-codigo = input frame {&frame-name} item.tp-desp-padrao 
       no-lock no-error.
   if  avail tipo-rec-desp then
       assign fi-desc-tipo:screen-value = tipo-rec-desp.descricao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.tp-desp-padrao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.tp-desp-padrao IN FRAME f-main /* Tipo Despesa */
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

  if item.class-fiscal:load-mouse-pointer ("Image~\lupa.cur") in frame 
    {&frame-name} then.
  if item.tp-desp-padrao:load-mouse-pointer ("Image~\lupa.cur") in frame 
    {&frame-name} then.
  if item.nat-despesa:load-mouse-pointer ("Image~\lupa.cur") in frame 
    {&frame-name} then.
  if fi-cod-tax:load-mouse-pointer ("Image~\lupa.cur") in frame 
    {&frame-name} then.
  if item.cod-tax-serv:load-mouse-pointer ("Image~\lupa.cur") in frame 
    {&frame-name} then.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
do transaction:

   /* Code placed here will execute PRIOR to standard behavior. */
   {include/i-valid.i}

   do with frame {&FRAME-NAME}:
      assign cb-cd-trib-icm 
             cb-cd-trib-ipi 
             cb-cd-trib-iss
             fi-cod-tax.
   end.
   /* Ponha na pi-validate todas as valida‡äes */

   if item.class-fiscal:hidden in frame {&frame-name} = no then do:
      find first classif-fisc 
         where classif-fisc.class-fiscal = input frame {&frame-name} item.class-fiscal           
         no-lock no-error.
      if  not avail classif-fisc or 
          input frame {&frame-name} item.class-fiscal = "" then do:
          run utp/ut-msgs.p ( "show", 5670, " " ).
          apply 'entry' to item.class-fiscal in frame {&frame-name}.
          return "adm-error".
      end.
   end.
   find first tipo-rec-desp where
        input frame {&frame-name} item.tp-desp-padrao = tipo-rec-desp.tp-codigo
        no-lock no-error.
   if  not avail tipo-rec-desp then do:
       run utp/ut-msgs.p ( "show", 3299, " " ).
       apply 'entry' to item.tp-desp-padrao in frame {&frame-name}.
       return "adm-error".
   end.
   if  tipo-rec-desp.tipo = 1 then do:
       run utp/ut-msgs.p ( "show", 4268, " " ).
       apply 'entry' to item.tp-desp-padrao in frame {&frame-name}.
       return "adm-error".
   end. 

   if  input frame {&frame-name} item.fator-reaj-icms <= 0 
   and fator-reaj-icms:hidden = no then do:
       run utp/ut-msgs.p ( "show", 5757, " " ).
       apply 'entry' to item.fator-reaj-icms in frame {&frame-name}.
       return "adm-error".
   end. 

   find natureza-despesa where
        natureza-despesa.nat-despesa = input frame {&frame-name} item.nat-despesa 
        no-lock no-error.  
   if  not avail natureza-despesa then do:     
       run utp/ut-msgs.p ( "show", 8193, " " ).
       apply 'entry' to item.nat-despesa in frame {&frame-name}.
       return "adm-error".        
   end. 

   if  fi-cod-tax:hidden in frame {&frame-name} = no then do:
       find tipo-tax 
           where tipo-tax.cod-tax = input frame {&frame-name} fi-cod-tax
           no-lock no-error.
       if  not avail tipo-tax then do:
           run utp/ut-msgs.p ( "show", 
                               17509, 
                               string(input frame {&frame-name} fi-cod-tax) ).
           apply 'entry' to fi-cod-tax in frame {&frame-name}.
           return "adm-error".
       end.
   end.   

   /* NÆo gravar nada no registro antes do dispatch do assign-record e 
   nem na PI-validate. */  
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

   if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

   /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
   do on error undo, leave:
       validate item.             
   end.

   if return-value <> 'ok' and return-value <> '' then do:
      {database/tgin/twp/twin172.i 'show':U}
   end.

   assign item.cd-trib-icm = {ininc/i07in122.i 06 cb-cd-trib-icm}
          item.cd-trib-iss = {ininc/i11in172.i 06 cb-cd-trib-iss} 
          item.cd-trib-ipi = {ininc/i10in172.i 06 cb-cd-trib-ipi}.


   &if  defined(bf_mat_iva_compras) &then

         find item-mat
             where item-mat.it-codigo = item.it-codigo exclusive-lock no-error.           
         assign item-mat.cod-tax = int(fi-cod-tax:screen-value in frame {&frame-name}). 
   &else
         assign item.cod-tax = int(fi-cod-tax:screen-value in frame {&frame-name}).

   &endif      

    /* Code placed here will execute AFTER standard behavior.    */

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


/*Altera‡Æo do modo de habilitar os campos na tela para produto internacional*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  IF i-pais-impto-usuario = 1 THEN DO:
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
      /*&if  defined(ADM-MODIFY-FIELDS) &then
          disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif*/
  END.
  ELSE DO:
      assign fi-cod-tax:sensitive in frame {&frame-name} = NO
             fi-desc-impos:sensitive in frame {&FRAME-NAME} = NO.
      DISABLE ITEM.tp-desp-padrao
              ITEM.nat-despesa
              cb-ind-tipo-item
          WITH FRAME {&FRAME-NAME}.
  END.

/*Altera‡Æo do modo de habilitar os campos na tela para produto internacional*/

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

  /* Code placed here will execute AFTER standard behavior.    */

  do  with frame {&frame-name}:

    if  avail item then do:
        assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 item.cd-trib-icm}
               cb-cd-trib-iss:screen-value = {ininc/i11in172.i 04 item.cd-trib-iss}
               cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 item.cd-trib-ipi}.

        find tipo-rec-desp
            where tipo-rec-desp.tp-codigo = item.tp-desp-padrao no-lock no-error.
        if avail tipo-rec-desp then
            assign fi-desc-tipo:screen-value = tipo-rec-desp.descricao.

        find tipo-tax 
            where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
        if avail tipo-tax then
            assign fi-desc-impos:screen-value = tipo-tax.descricao.

        find natureza-despesa
            where natureza-despesa.nat-despesa = item.nat-despesa no-lock no-error.
        if avail natureza-despesa then
            assign fi-desc-nat-desp:screen-value = natureza-despesa.descricao.

        find classif-fisc
            where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.
        if avail classif-fisc then
            assign fi-desc-class-fisc:screen-value = classif-fisc.descricao.


        /*find tipo-tax 
 *             where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
 *         if avail tipo-tax then
 *             assign fi-desc-impos:screen-value = tipo-tax.descricao.*/


        if i-pais-impto-usuario <> 1 then do:    
            &if  defined(bf_mat_iva_compras) &then
                find item-mat
                    where item-mat.it-codigo = item.it-codigo  no-lock no-error.
                if  avail item-mat and item-mat.cod-tax <> 0 then          
                    assign fi-cod-tax:screen-value = string(item-mat.cod-tax).

                find tipo-tax 
                    where tipo-tax.cod-tax = item-mat.cod-tax no-lock no-error.
                if avail tipo-tax then
                    assign fi-desc-impos:screen-value = tipo-tax.descricao.
                else 
                    assign fi-desc-impos:screen-value = "".
            &else
                assign fi-cod-tax:screen-value = string(item.cod-tax).
            &endif
        end.

    end.
    else do:
        assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 1}
               cb-cd-trib-iss:screen-value = {ininc/i11in172.i 04 1}
               cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 1}.
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

/*Altera‡Æo do modo de habilitar os campos na tela para produto internacional*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  IF i-pais-impto-usuario = 1 THEN DO:
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
/*   &if  defined(ADM-MODIFY-FIELDS) &then                           */
/*       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.       */
/*   &endif                                                          */
  END.
  ELSE DO:
      assign fi-cod-tax:sensitive in frame {&frame-name} = yes
             fi-desc-impos:sensitive in frame {&FRAME-NAME} = YES.
      ENABLE ITEM.tp-desp-padrao
             ITEM.nat-despesa
             cb-ind-tipo-item
          WITH FRAME {&FRAME-NAME}.
  END.

/*Altera‡Æo do modo de habilitar os campos na tela para produto internacional*/

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

find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                        input 2314,
                        input "").
     return 'ADM-ERROR':U.
  end.                

  do with frame {&frame-name}:  

     assign cb-cd-trib-icm:list-items    = {ininc/i07in122.i 03}
            cb-cd-trib-iss:list-items    = {ininc/i11in172.i 03}
            cb-cd-trib-ipi:list-items    = {ininc/i10in172.i 03}
            cb-ind-tipo-item:list-items  = {varinc/var00087.i 03}.        

  end.


  do  with frame {&FRAME-NAME}:

      {utp/ut-liter.i Fator_Reaj_ICMS * L}
      assign item.fator-reaj-icms:label = return-value.

    /*  {utp/ut-liter.i Cod_Imp_Servi‡o * L}
      assign item.cod-tax-serv:label = return-value.*/

      {utp/ut-liter.i C¢digo_Imposto * L}
      assign fi-cod-tax:label = return-value.

      {utp/ut-liter.i Base_PIS_Substituto * L}
      assign fi-base-pis-subs:label = return-value.

      {utp/ut-liter.i Base_COFINS_Substituto * L}
      assign fi-base-cofins-subs:label = return-value.

      if  i-pais-impto-usuario = 2 then do:
          {utp/ut-field.i lcarg ext-item ind-tipo-item 1}
          assign cb-ind-tipo-item:label = return-value. 
      end.      

      if  i-pais-impto-usuario <> 1 then 
          assign fi-cod-tax:row           = cb-cd-trib-icm:row
                 fi-desc-impos:row        = cb-cd-trib-icm:row
                 h-label-cod-tax          = fi-cod-tax:side-label-handle
                 h-label-cod-tax:row      = fi-cod-tax:row
                 item.cod-tax-serv:row    = cb-cd-trib-ipi:row
                 h-label-cod-tax-serv     = item.cod-tax-serv:side-label-handle
                 h-label-cod-tax-serv:row = item.cod-tax-serv:row
                 fi-cod-tax:hidden        = no
                 fi-desc-impos:hidden     = no.
  end.


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

  /* Code placed here will execute AFTER standard behavior.    */

  assign gr-item = if  avail item then rowid(item) 
                   else ?.


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

