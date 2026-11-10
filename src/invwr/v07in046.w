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
{include/i-prgvrs.i V07IN046 2.00.00.009 } /*** "010009" 20/08/2026 16:06:09 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in046 MUT}
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
{cdp/cd9990.i1}
{cdp/cd4000.i}

{cdp/cdcfgdis.i} /* VersÆo */

define workfile w-pedido no-undo
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli.
define new global shared variable de-aliquota-ipi-old as decimal.
define VAR de-aliquota-pis-old    as decimal no-undo.
define VAR de-reducao-pis-old     as decimal no-undo.
define VAR de-aliquota-cofins-old as decimal no-undo.
define VAR de-reducao-cofins-old  as decimal no-undo.
define VAR l-susp-ipi-old         as logical no-undo.
define var wh-cd0603              as handle  no-undo.
define var c-cd0603               as char    no-undo.

define var h-acomp                as handle  no-undo.

DEFINE VARIABLE l-exp-ap-itens    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-exp-ap-it-doc   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE dt-exp-ap-ini     AS DATE               NO-UNDO.
DEFINE VARIABLE dt-exp-ap-fim     AS DATE               NO-UNDO.
DEFINE VARIABLE l-conf-exp-ap     AS LOGICAL            NO-UNDO.

/* Integracao Modulo Importacao */
def var l-modulo-imp   as logical                 no-undo.
def var de-aliq-ii-old as decimal format ">>9.9999" no-undo.
{cdp/cd4300.i3}  /* Include Tratamento Atributo Livre */
{cdp/cd0603.i50} /* Include Tratamento Atributo Livre */

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
&Scoped-define EXTERNAL-TABLES classif-fisc
&Scoped-define FIRST-EXTERNAL-TABLE classif-fisc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-fisc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-fisc.log-2
&Scoped-define ENABLED-TABLES classif-fisc
&Scoped-define FIRST-ENABLED-TABLE classif-fisc
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2
&Scoped-Define DISPLAYED-OBJECTS rs-apuracao rs-finalidade c-text1

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS rs-apuracao rs-finalidade

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
DEFINE VARIABLE c-text1 AS CHARACTER FORMAT "X(256)":U
      VIEW-AS TEXT
     SIZE 25.14 BY .63 NO-UNDO.

DEFINE VARIABLE c-text2 AS CHARACTER FORMAT "X(256)":U
      VIEW-AS TEXT
     SIZE 22 BY .63 NO-UNDO.

DEFINE VARIABLE rs-apuracao AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Decendial", 1,
"Mensal", 2
     SIZE 40 BY .92 NO-UNDO.

DEFINE VARIABLE rs-finalidade AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Entorpecentes", 1,
"Para Uso Militar", 2,
"Para Uso NÆo Militar", 3
     SIZE 65.14 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 70.57 BY 1.46.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 44 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rs-apuracao AT ROW 2.54 COL 7 NO-LABEL
     rs-finalidade AT ROW 4.75 COL 7 NO-LABEL
     classif-fisc.log-2 AT ROW 2 COL 65
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83
     c-text2 AT ROW 1.75 COL 3 COLON-ALIGNED NO-LABEL
     c-text1 AT ROW 4 COL 2.86 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.29 COL 4
     RECT-2 AT ROW 2.04 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-fisc
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
         HEIGHT             = 5.92
         WIDTH              = 76.43.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-text1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX classif-fisc.log-2 IN FRAME f-main
   NO-DISPLAY                                                           */
ASSIGN
       classif-fisc.log-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-apuracao IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-finalidade IN FRAME f-main
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME rs-apuracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-apuracao V-table-Win
ON VALUE-CHANGED OF rs-apuracao IN FRAME f-main
DO:

    IF NOT adm-new-record THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 29492,
                           INPUT "").

        ASSIGN l-exp-ap-itens = IF RETURN-VALUE = "yes" THEN YES ELSE NO.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 29493,
                           INPUT "").

        ASSIGN l-exp-ap-it-doc = IF RETURN-VALUE = "yes" THEN YES ELSE NO.

        IF l-exp-ap-it-doc THEN DO:
            RUN cdp/cd0603f.w (OUTPUT dt-exp-ap-ini,
                               OUTPUT dt-exp-ap-fim,
                               OUTPUT l-conf-exp-ap).

            IF l-conf-exp-ap = NO THEN
                ASSIGN l-exp-ap-it-doc = NO.

        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-finalidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-finalidade V-table-Win
ON VALUE-CHANGED OF rs-finalidade IN FRAME f-main
DO:
   RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

  IF i-pais-impto-usuario = 1 THEN DO:
      {utp/ut-rtlbl.i mgind classif-fisc finalidade c-text1}
      {utp/ut-rdset.i rs-finalidade}
      ASSIGN c-text2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Tipo Apura‡Æo de IPI".
  END.

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
  {src/adm/template/row-list.i "classif-fisc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-fisc"}

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

  if avail classif-fisc then do:
      if classif-fisc.finalidade = 100 then {utp/ut-liter.i Entorpecentes * R}.
      if classif-fisc.finalidade = 310 then {utp/ut-liter.i Para_uso_militar * R}.
      if classif-fisc.finalidade = 329 then {utp/ut-liter.i Para_uso_nÆo_militar * R}.
  end.
  display c-text1 with frame {&frame-name}.

  IF i-pais-impto-usuario = 1 THEN
      ASSIGN c-text2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Tipo Apura‡Æo de IPI".

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
  /*{include/i-valid.i} */
  DEF VAR i-tipo-apuracao AS INTEGER NO-UNDO.
  ASSIGN i-tipo-apuracao = INT(rs-apuracao:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then
    RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  if avail classif-fisc then do:
      if rs-finalidade:screen-value in frame {&frame-name}  = "1" then assign classif-fisc.finalidade = 100.
      if rs-finalidade:screen-value in frame {&frame-name}  = "2" then assign classif-fisc.finalidade = 310.
      if rs-finalidade:screen-value in frame {&frame-name}  = "3" then assign classif-fisc.finalidade = 329.
  end.

  if avail classif-fisc AND i-pais-impto-usuario = 1 then do:
      &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
           ASSIGN  classif-fisc.idi-tip-apurac-ipi = i-tipo-apuracao.
      &else
           assign SUBSTR(classif-fisc.char-2,1,1) = string(i-tipo-apuracao).
      &endif
  END.

  run utp/ut-acomp.p persistent set h-acomp.
  {utp/ut-liter.i Exporta‡Æo_do_tipo_apura‡Æo_do_IPI *}
  run pi-inicializar in h-acomp (input  Return-value ).

  IF  l-exp-ap-itens THEN DO:
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-disable-trigger-item" AND funcao.ativo = YES) THEN
          DISABLE TRIGGERS FOR LOAD OF ITEM.

      &if "{&bf_dis_versao_ems}" >= "2.06" &then
          FOR EACH item FIELDS(it-codigo) WHERE item.class-fiscal = classif-fisc.class-fiscal NO-LOCK:
              FIND FIRST item-dist WHERE item-dist.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
              IF  AVAIL item-dist THEN DO:
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Item" *}
                  run pi-acompanhar in h-acomp (RETURN-VALUE + ": " + item-dist.it-codigo).
                  ASSIGN item-dist.idi-tip-apurac-ipi = classif-fisc.idi-tip-apurac-ipi.
              END.
          END.
      &else
          FOR EACH item WHERE item.class-fiscal = classif-fisc.class-fiscal EXCLUSIVE-LOCK:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Item" *}
              run pi-acompanhar in h-acomp (RETURN-VALUE + ": " + item.it-codigo).
              ASSIGN SUBSTR(item.char-1,191,1) = SUBSTR(classif-fisc.char-2,1,1).
          END.
      &endif
  END.

  IF l-exp-ap-it-doc THEN DO:
      FOR EACH doc-fiscal WHERE doc-fiscal.dt-docto >= dt-exp-ap-ini AND
                                doc-fiscal.dt-docto <= dt-exp-ap-fim NO-LOCK:
          FOR EACH it-doc-fisc OF doc-fiscal WHERE it-doc-fisc.class-fiscal = classif-fisc.class-fiscal EXCLUSIVE-LOCK:
              {utp/ut-liter.i Documento:_ *}
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
              ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Item" *}
              ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
              run pi-acompanhar in h-acomp ( c-lbl-liter  + it-doc-fisc.nr-doc-fis + " - " + c-lbl-liter-item + ": " + it-doc-fisc.it-codigo).
              &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                  ASSIGN it-doc-fisc.idi-tip-apurac-ipi = classif-fisc.idi-tip-apurac-ipi.
              &else
                  ASSIGN SUBSTR(it-doc-fisc.char-2,21,1) = SUBSTR(classif-fisc.char-2,1,1).
              &ENDIF
          END.
      END.
  END.

  run pi-finalizar in h-acomp.


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

  assign rs-finalidade = integer(rs-finalidade:screen-value in frame {&frame-name}).

  if avail classif-fisc then do:
      if rs-finalidade:screen-value in frame {&frame-name}  = "1" then assign classif-fisc.finalidade = 100.
      if rs-finalidade:screen-value in frame {&frame-name}  = "2" then assign classif-fisc.finalidade = 310.
      if rs-finalidade:screen-value in frame {&frame-name}  = "3" then assign classif-fisc.finalidade = 329.
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

    DEF BUFFER bf-classif-fisc FOR classif-fisc.

  /* Code placed here will execute PRIOR to standard behavior. */

  if avail classif-fisc then do:
     if classif-fisc.finalidade = 100 then
          assign rs-finalidade = 1.
     if classif-fisc.finalidade = 310 then
          assign rs-finalidade = 2.
     if classif-fisc.finalidade = 329 then
         assign rs-finalidade = 3.
  end.

  IF AVAIL classif-fisc AND i-pais-impto-usuario = 1 THEN DO:
      &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
          ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&frame-name} = IF classif-fisc.idi-tip-apurac-ipi <> 0 THEN STRING(classif-fisc.idi-tip-apurac-ipi) ELSE "2".
      &ELSE
          ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF SUBSTR(classif-fisc.char-2,1,1) <> "0" THEN SUBSTR(classif-fisc.char-2,1,1) ELSE "2".
      &ENDIF

        FIND FIRST bf-classif-fisc EXCLUSIVE-LOCK WHERE bf-classif-fisc.class-fiscal = classif-fisc.class-fiscal NO-ERROR.
        IF AVAIL bf-classif-fisc THEN DO:
            &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                IF classif-fisc.idi-tip-apurac-ipi = 0 THEN
                    ASSIGN classif-fisc.idi-tip-apurac-ipi = 2.
            &ELSE
                IF SUBSTR(classif-fisc.char-2,1,1) = "0" THEN
                    OVERLAY(classif-fisc.char-2,1,1) = "2".
            &ENDIF
        END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mgind classif-fisc finalidade c-text1}

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
  /* Dispatch standard ADM method. */

  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record = yes then DO:
      ENABLE rs-finalidade WITH FRAME {&FRAME-NAME}.
      ASSIGN rs-apuracao:SCREEN-VALUE IN FRAME {&frame-name} = "2".
  END.

  IF i-pais-impto-usuario = 1 THEN
      ENABLE rs-apuracao WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  /*define buffer b-item     for item.
  define buffer b-ped-item for ped-item.

  define variable i-cont    as integer no-undo.
  define variable i-cont2   as integer no-undo.
  define variable i-exporta as integer no-undo.
  define variable l-aberto  as logical no-undo.
  define variable l-parcial as logical no-undo.
  define variable l-penden  as logical no-undo.

  define variable i-cont-inicio as integer no-undo.
  define variable i-cont-final  as integer no-undo.
  define variable h-acomp       as handle  no-undo.
  define variable i-time        as int no-undo.


  /* Code placed here will execute PRIOR to standard behavior. */
  RUN get-attribute ('ADM-NEW-RECORD').
  if return-value = "no" then do:
    if classif-fisc.aliquota-ipi <> de-aliquota-ipi-old then do:
        run cdp/cd0603a.w (output i-exporta, output l-aberto, output l-parcial).
        if i-exporta = 1 or i-exporta = 2 then do:
           if session:set-wait-state("general") then.

           run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Exporta‡Æo_dados_para_items *}
           run pi-inicializar in h-acomp (input  Return-value ).

           for each w-pedido exclusive-lock:
              delete w-pedido.
           end.

           if i-exporta = 1 then do:

              for each b-item use-index class-fiscal where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:

                 if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                     assign i-time = time.
                 end.

                 find item where rowid(item) = rowid(b-item) exclusive-lock.
                 assign item.aliquota-ipi = classif-fisc.aliquota-ipi.
                 if l-aberto or l-parcial  then do:
                    /* gravar aliquota de ipi nos pedidos */
                    {cdp/cd0603.i1 " "}
                 end.
              end.
              /* recalcular o valor dos pedidos */
              for each w-pedido exclusive-lock:
                 find ped-venda where ped-venda.nome-abrev = w-pedido.nome-abrev and
                                      ped-venda.nr-pedcli = w-pedido.nr-pedcli exclusive-lock.
                 if  time - i-time > 0 then do:
{utp/ut-liter.i Recalculando_Pedido.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + ped-venda.nome-abrev + "/":U + ped-venda.nr-pedcli).
                     assign i-time = time.
                 end.

                 run cdp/cd4323a.p (input rowid(ped-venda),
                                   input yes,
                                   input i-pais-impto-usuario).
                 delete w-pedido.
              end.
           end.
           if i-exporta = 2 then do:
              for each item use-index class-fiscal where item.class-fiscal = classif-fisc.class-fiscal and
                                                         item.aliquota-ipi = de-aliquota-ipi-old exclusive-lock:
                 if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + item.it-codigo).
                     assign i-time = time.
                 end.
                 assign item.aliquota-ipi = classif-fisc.aliquota-ipi.
                 if l-aberto or l-parcial then do:
                    {cdp/cd0603.i1 "and ped-item.aliquota-ipi = de-aliquota-ipi-old"}
                 end.
              end.
              /* recalcular o valor dos pedidos */
              for each w-pedido exclusive-lock:
                 find ped-venda where ped-venda.nome-abrev = w-pedido.nome-abrev and
                                      ped-venda.nr-pedcli  = w-pedido.nr-pedcli exclusive-lock.
                 if  time - i-time > 0 then do:
{utp/ut-liter.i Recalculando_Pedido.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + ped-venda.nome-abrev + "/":U + ped-venda.nr-pedcli).
                     assign i-time = time.
                 end.
                 run cdp/cd4323a.p (input rowid(ped-venda),
                                   input yes,
                                   input i-pais-impto-usuario).

                 delete w-pedido.
              end.
           end.
           run pi-finalizar in h-acomp.
           if session:set-wait-state("") then.
        end.
    end.

    /* Integracao Modulo Importacao */
    if l-modulo-imp then do:
        {cdp/cd4300.i4 "yes" classif-fisc.char-1}
        {cdp/cd0603.i51 "yes"}
        if de-aliq-ii-i50 <> de-aliq-ii-old then do:
            run cdp/cd0603b.w (output i-exporta).
            if session:set-wait-state("general") then.
            run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Exporta‡Æo_dados_para_items *}
            run pi-inicializar in h-acomp (input  Return-value ).

            case i-exporta:
                when 1 then do:
                    for each b-item use-index class-fiscal
                        where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                        if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                            run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                            assign i-time = time.
                        end.
                        find item where rowid(item) = rowid(b-item) exclusive-lock no-error.
                        ASSIGN overlay(ITEM.char-2,22,6) = STRING(DEC(de-aliq-ii-i50),">>9.99")
                               overlay(ITEM.char-2,278,8) = STRING(DEC(de-aliq-ii-i50),">>9.9999").
                    end.
                end.
                when 2 then do:
                    for each b-item use-index class-fiscal
                        where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                        if dec(substring(b-item.char-2,22,6)) = de-aliq-ii-old
                        or dec(substring(b-item.char-2,278,8)) = de-aliq-ii-old then do:
                            if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                                run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                                assign i-time = time.
                            end.
                            find item where rowid(item) = rowid(b-item) exclusive-lock no-error.
                            assign overlay(item.char-2,22,6)  = string(de-aliq-ii-i50, ">>9,99")
                                   overlay(item.char-2,278,8) = string(de-aliq-ii-i50, ">>9,9999").
                        end.
                    end.
                end.
            end case.
            run pi-finalizar in h-acomp.
            if session:set-wait-state("") then.
        end.
    end.

    IF de-aliquota-pis-old    <> classif-fisc.dec-1
    OR de-aliquota-cofins-old <> classif-fisc.dec-2
    OR de-reducao-pis-old     <> classif-fisc.int-1 / 100
    OR de-reducao-cofins-old  <> classif-fisc.int-2 / 100
    OR l-susp-ipi-old         <> classif-fisc.log-1 THEN DO:

        run cdp/cd0603c.w (output i-exporta).
        if i-exporta = 1 or i-exporta = 2 then do:
           if session:set-wait-state("general") then.
           run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Exporta‡Æo_dados_para_items *}
           run pi-inicializar in h-acomp (input  Return-value ).

           if i-exporta = 1 then do:
              for each b-item use-index class-fiscal where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                 if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                     assign i-time = time.
                 end.
                 find item where rowid(item) = rowid(b-item) exclusive-lock.
                 assign substr(item.char-2,31,5) = string(classif-fisc.dec-1,"99.99")
                        substr(item.char-2,36,5) = string(classif-fisc.dec-2,"99.99")
                        substr(item.char-2,41,5) = string(classif-fisc.int-1 / 100,"99.99")
                        substr(item.char-2,46,5) = string(classif-fisc.int-2 / 100,"99.99")
                        substr(item.char-2,51,1) = IF classif-fisc.log-1 THEN "2" ELSE "1".
              end.
           end.
           if i-exporta = 2 then do:

                for each b-item use-index class-fiscal
                    where b-item.class-fiscal = classif-fisc.class-fiscal
                    no-lock:

                    if  time - i-time > 0 then do:
{utp/ut-liter.i Item.: *}
                        run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                        assign i-time = time.
                    end.

                    if  dec(substr(b-item.char-2,31,5))  =  de-aliquota-pis-old    or
                        dec(substr(b-item.char-2,36,5))  =  de-aliquota-cofins-old or
                        dec(substr(b-item.char-2,41,5))  =  de-reducao-pis-old     or
                        dec(substr(b-item.char-2,46,5))  =  de-reducao-cofins-old  OR
                        (substr(b-item.char-2,51,1) = "2") =  l-susp-ipi-old
                    then do:
                        find item where recid(item) = recid(b-item)
                            exclusive-lock.
                        if dec(substr(b-item.char-2,31,5)) = de-aliquota-pis-old    then
                           assign substr(item.char-2,31,5) = string(classif-fisc.dec-1,"99.99").
                        if dec(substr(b-item.char-2,36,5)) = de-aliquota-cofins-old then
                           assign substr(item.char-2,36,5) = string(classif-fisc.dec-2,"99.99").
                        if dec(substr(b-item.char-2,41,5)) = de-reducao-pis-old     then
                           assign substr(item.char-2,41,5) = string(classif-fisc.int-1 / 100,"99.99").
                        if dec(substr(b-item.char-2,46,5)) = de-reducao-cofins-old  then
                           assign substr(item.char-2,46,5) = string(classif-fisc.int-2 / 100,"99.99").
                        IF (substr(b-item.char-2,51,1) = "2") =  l-susp-ipi-old THEN
                           ASSIGN substr(item.char-2,51,1) = IF classif-fisc.log-1 THEN "2" ELSE "1".

                    END.
                END.
           end.
           run pi-finalizar in h-acomp.
           if session:set-wait-state("") then.
        end.
    END.
  end.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  HIDE classif-fisc.log-2 IN FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-rtlbl.i mgind classif-fisc finalidade c-text1}

  IF i-pais-impto-usuario <> 1 THEN
      HIDE rs-apuracao c-text2 rect-2 IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "classif-fisc"}

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

