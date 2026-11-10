&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases
          mgadm            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V02AD178 2.00.00.044 } /*** "010044" 28/10/2026 11:37:14 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02ad178 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-char-1    like moeda.char-1 no-undo.
def var c-char-2    like moeda.char-2 no-undo.

def var c-desc-centavo-aux like moeda.char-2 no-undo.
def var c-desc-centavos-aux like moeda.char-2 no-undo.

def var l-add as logical initial no.

def var l-ems203 as logical initial no.
def var l-funcao as logical initial no.

def var v-decimais-old as char no-undo.
def var v-vl-inf-old   as char no-undo.
def var v-vl-calc-old  as char no-undo.
def var l-mostra       as logical initial yes no-undo.

def var c-arredonda    as char format "x(09)" no-undo.
def var c-trunca       as char format "x(06)" no-undo.
def var c-rejeita      as char format "x(07)" no-undo.

def var cLista         as char no-undo.

DEF VAR c-des-moeda AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR h-bomx2016 AS HANDLE NO-UNDO.

{utp/ut-glob.i}

/* MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}
{include/i_prdvers.i}
/***********************/

&if  defined(GLOBALS) &then
&else
     &glob GLOBALS ok
     def new global shared var i-ep-codigo-usuario like empresa.ep-codigo no-undo.
&endif

def buffer b-moeda for moeda.

{include/i_dbtype.i}

/*Miniflexibiliza‡Æo 2.03*/
{cdp/cdcfgfin.i}

/*Def TTs e Variaveis - Decimais Chile*/
{cdp/cd1234.i}

/*Para uso dos Decimais - Chile*/
&if defined(BF_FIN_203) &then
    assign l-ems203 = yes.
&endif
if can-find( funcao no-lock where funcao.cd-funcao = "spp_ajusta_dec") then
    assign l-funcao = yes.

{bhp/bh9999.i1}

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    {cdp/cdapi216.i}
&ENDIF
{mcinc/mcapi045.i}
def temp-table tt-dados-env-SMC    no-undo like tt-dados-env.
def temp-table tt-replica-msg-SMC  no-undo like tt-replica-msg.
def temp-table tt-control-env-SMC  no-undo like tt-control-env.
def temp-table tt-integracao-SMC   no-undo like tt-integracao.

/************Fim*****************************/

{cdp/cdcfgfin.i} /* Defini‡Æo de Fun‡äes */
{include/i-freeac.i}
/*-------------- Integra‡Æo Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var i-cont-mg        as inte no-undo.

{cdp/cd0914i1.i} /* Defini‡Æo da temp-table tt-moeda-mg */
{cdp/cd0001i1.i} /* Defini‡Æo da temp-table de erros tt-erro-mg */
/****************************************************************/
/*fut36887 - XML Adapters*/
&IF "{&mgadm_version}" >= "2.04" &THEN
    DEF VAR hShowMsg          AS HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOG NO-UNDO.
    DEF VAR h-adapter AS HANDLE.

    DEFINE TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER
        index seq ErrorSequence.

    DEFINE TEMP-TABLE tt_log_erro NO-UNDO
         FIELD ttv_num_cod_erro AS integer INITIAL ?
         FIELD ttv_des_msg_ajuda AS character INITIAL ?
         FIELD ttv_des_msg_erro AS character INITIAL ?.
&endif
/*fut36887 - XML Adapters*/


DEFINE VARIABLE h-cd0109-crm AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-maing

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES moeda
&Scoped-define FIRST-EXTERNAL-TABLE moeda


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR moeda.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS moeda.log-consid-dias-uteis moeda.descricao ~
moeda.sigla moeda.ind-variacao moeda.ind-reajuste moeda.cod-calend
&Scoped-define ENABLED-TABLES moeda
&Scoped-define FIRST-ENABLED-TABLE moeda
&Scoped-Define ENABLED-OBJECTS cb-decimais cb-vl-inf cb-vl-calc RECT-1 ~
RECT-2 RECT-3 rt-key rt-mold RECT-4
&Scoped-Define DISPLAYED-FIELDS moeda.log-consid-dias-uteis moeda.mo-codigo ~
moeda.descricao moeda.sigla moeda.ind-variacao moeda.ind-reajuste ~
moeda.cod-calend
&Scoped-define DISPLAYED-TABLES moeda
&Scoped-define FIRST-DISPLAYED-TABLE moeda
&Scoped-Define DISPLAYED-OBJECTS c-cod-calend c-moeda-plural c-desc-centavo ~
c-desc-centavos cb-decimais v-nom-moeda-reporte cb-vl-inf cb-vl-calc ~
texto-1 texto-2 texto-3 texto-4

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS moeda.mo-codigo c-moeda-plural ~
c-desc-centavo c-desc-centavos v-nom-moeda-reporte
&Scoped-define ADM-ASSIGN-FIELDS c-moeda-plural
&Scoped-define ADM-MODIFY-FIELDS moeda.descricao c-moeda-plural ~
c-desc-centavo c-desc-centavos

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
DEFINE VARIABLE cb-decimais AS CHARACTER FORMAT "9":U
     LABEL "Casas Decimais"
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "0","1","2"
     DROP-DOWN-LIST
     SIZE 6.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-vl-calc AS CHARACTER FORMAT "X(10)":U
     LABEL "Calculado"
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 13.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-vl-inf AS CHARACTER FORMAT "X(10)":U
     LABEL "Informado"
     VIEW-AS COMBO-BOX INNER-LINES 3
     DROP-DOWN-LIST
     SIZE 13.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-calend AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 42.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-centavo AS CHARACTER FORMAT "X(12)":U
     LABEL ""
     VIEW-AS FILL-IN
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-centavos AS CHARACTER FORMAT "X(12)":U
     LABEL ""
     VIEW-AS FILL-IN
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-plural AS CHARACTER FORMAT "X(12)"
     LABEL ""
     VIEW-AS FILL-IN
     SIZE 16.43 BY .88.

DEFINE VARIABLE texto-1 AS CHARACTER FORMAT "X(11)":U
      VIEW-AS TEXT
     SIZE 10.43 BY .67 NO-UNDO.

DEFINE VARIABLE texto-2 AS CHARACTER FORMAT "X(11)":U
      VIEW-AS TEXT
     SIZE 9.72 BY .67 NO-UNDO.

DEFINE VARIABLE texto-3 AS CHARACTER FORMAT "X(20)":U
      VIEW-AS TEXT
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE texto-4 AS CHARACTER FORMAT "X(20)":U
      VIEW-AS TEXT
     SIZE 10.86 BY .67 NO-UNDO.

DEFINE VARIABLE v-nom-moeda-reporte AS CHARACTER FORMAT "X(20)"
     LABEL "Descri‡Æo Fiscal"
     VIEW-AS FILL-IN
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 31.72 BY 1.63.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 31.72 BY 1.63.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 31.72 BY 3.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 75 BY 2.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 88.57 BY 12.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-maing
     moeda.mo-codigo AT ROW 1.17 COL 33.72 COLON-ALIGNED HELP
          "Informe o c¢digo da moeda"
          VIEW-AS FILL-IN
          SIZE 3.72 BY .88
     moeda.descricao AT ROW 3.83 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 16.43 BY .88
     c-moeda-plural AT ROW 4.83 COL 21.72
     moeda.sigla AT ROW 5.83 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 8.43 BY .88
     c-desc-centavo AT ROW 6.83 COL 20.86 COLON-ALIGNED
     c-desc-centavos AT ROW 7.83 COL 20.86 COLON-ALIGNED
     cb-decimais AT ROW 8.83 COL 20.86 COLON-ALIGNED
     v-nom-moeda-reporte AT ROW 10 COL 6.29 WIDGET-ID 2
     moeda.ind-variacao AT ROW 4.46 COL 56.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS
                    "Di rio", 1,
"Mensal", 2
          SIZE 19.57 BY .83
     moeda.ind-reajuste AT ROW 6.58 COL 56.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS
                    "Di rio", 1,
"Mensal", 2
          SIZE 19.57 BY .83
     cb-vl-inf AT ROW 8.79 COL 64 COLON-ALIGNED
     cb-vl-calc AT ROW 10 COL 64 COLON-ALIGNED
     texto-1 AT ROW 3.54 COL 60.43 RIGHT-ALIGNED NO-LABEL
     texto-2 AT ROW 5.75 COL 59.72 RIGHT-ALIGNED NO-LABEL
     texto-3 AT ROW 7.92 COL 65 RIGHT-ALIGNED NO-LABEL
     texto-4 AT ROW 11.17 COL 17.58 RIGHT-ALIGNED NO-LABEL WIDGET-ID 10
     c-cod-calend AT ROW 12.79 COL 77.57 RIGHT-ALIGNED NO-LABEL
     moeda.log-consid-dias-uteis AT ROW 11.79 COL 22.86 WIDGET-ID 4
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .83
     moeda.cod-calend AT ROW 12.79 COL 20.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     RECT-1 AT ROW 6.04 COL 49.29
     RECT-2 AT ROW 3.88 COL 49.29
     RECT-3 AT ROW 8.21 COL 49.29
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.29 COL 1
     RECT-4 AT ROW 11.5 COL 6 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.moeda
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 14.33
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-maing
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN
       FRAME f-maing:SCROLLABLE       = FALSE
       FRAME f-maing:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-calend IN FRAME f-maing
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-desc-centavo IN FRAME f-maing
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN c-desc-centavos IN FRAME f-maing
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN c-moeda-plural IN FRAME f-maing
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR FILL-IN moeda.descricao IN FRAME f-maing
   3                                                                    */
/* SETTINGS FOR FILL-IN moeda.mo-codigo IN FRAME f-maing
   NO-ENABLE 1 EXP-HELP                                                 */
/* SETTINGS FOR FILL-IN texto-1 IN FRAME f-maing
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN texto-2 IN FRAME f-maing
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN texto-3 IN FRAME f-maing
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN texto-4 IN FRAME f-maing
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN v-nom-moeda-reporte IN FRAME f-maing
   NO-ENABLE ALIGN-L 1                                                  */
ASSIGN
       v-nom-moeda-reporte:HIDDEN IN FRAME f-maing           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-maing
/* Query rebuild information for FRAME f-maing
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-maing */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME moeda.cod-calend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda.cod-calend V-table-Win
ON F5 OF moeda.cod-calend IN FRAME f-maing /* Calend rio */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
               &campo=moeda.cod-calend
               &campozoom=cd-calen
               &campo2=c-cod-calend
               &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda.cod-calend V-table-Win
ON LEAVE OF moeda.cod-calend IN FRAME f-maing /* Calend rio */
DO:
    {include/leave.i &tabela       = calen-gener
                   &atributo-ref = descricao
                   &variavel-ref = c-cod-calend
                   &where        = "calen-gener.cd-calen eq input frame {&frame-name}
                                    moeda.cod-calend"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda.cod-calend V-table-Win
ON MOUSE-SELECT-DBLCLICK OF moeda.cod-calend IN FRAME f-maing /* Calend rio */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moeda.ind-variacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda.ind-variacao V-table-Win
ON VALUE-CHANGED OF moeda.ind-variacao IN FRAME f-maing /* Varia‡Æo */
DO:
  if input frame {&frame-name} moeda.ind-variacao = 1 then
     assign moeda.ind-reajuste:sensitive in frame {&frame-name} = yes.
  else do:
      assign moeda.ind-reajuste:sensitive in frame {&frame-name} = no.
      assign moeda.ind-reajuste = 1 no-error.
      assign moeda.ind-reajuste:screen-value in frame {&frame-name} = "1".
  end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moeda.log-consid-dias-uteis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda.log-consid-dias-uteis V-table-Win
ON VALUE-CHANGED OF moeda.log-consid-dias-uteis IN FRAME f-maing /* Considera apenas dias £teis */
DO:
  if input frame {&frame-name} moeda.log-consid-dias-uteis = YES then
     assign moeda.cod-calend:sensitive in frame {&frame-name} = YES.
  else do:
      assign moeda.cod-calend:sensitive in frame {&frame-name} = NO.
      assign moeda.cod-calend:screen-value in frame {&frame-name} = "".
      assign c-cod-calend:screen-value in frame {&frame-name} = "".
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

  {btb/btb008za.i0} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */
  /************************ INTERNAL PROCEDURES ********************/

  IF moeda.cod-calend:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "moeda"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "moeda"}

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
  HIDE FRAME f-maing.
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

{utp/ut-field.i mguni moeda ind-variacao 1}
assign texto-1:screen-value in frame {&frame-name} = return-value + ":".

assign l-add = yes.

{utp/ut-field.i mguni moeda ind-reajuste 1}
assign texto-2:screen-value in frame {&frame-name} = return-value + ":".

{utp/ut-liter.i Tratamento_do_valor *}
assign texto-3:screen-value in frame {&frame-name} = trim(return-value) + ":".

{utp/ut-liter.i Cota‡Æo_m‚dia *}
assign texto-4:screen-value in frame {&frame-name} = trim(return-value) + ":".

if avail moeda then do:
    assign moeda.cod-calend:sensitive in frame {&frame-name} = no.
    if moeda.ind-variacao = 2 then
    do:
       assign moeda.ind-reajuste:sensitive in frame {&frame-name} = no.
    end.
    if moeda.ind-variacao = 1 then
    do:
       assign moeda.ind-reajuste:sensitive in frame {&frame-name} = yes.
    end.
end.

  /* Code placed here will execute AFTER standard behavior.    */

assign l-add = no.

  /*Decimais - Chile*/
if  l-ems203 or l-funcao then do:
    &IF "{&fnc_multi_idioma}" = "yes" &THEN

        if lookup(c-arredonda, cb-vl-inf:list-item-pairs,",") mod 2 <> 0 then
            assign cb-vl-inf:screen-value   in frame {&frame-name} = "Arredonda".

        if lookup(c-arredonda, cb-vl-calc:list-item-pairs,",") mod 2 <> 0 then
            assign cb-vl-calc:screen-value  in frame {&frame-name} = "Arredonda".

        assign cb-decimais:screen-value in frame {&frame-name} = "2".

    &ELSE
        assign cb-decimais:screen-value in frame {&frame-name} = "2"
               cb-vl-inf:screen-value   in frame {&frame-name} = c-arredonda
               cb-vl-calc:screen-value  in frame {&frame-name} = c-arredonda.
    &ENDIF
end.

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

  /* Ponha aqui a validacao de chave duplicada */

  find b-moeda no-lock
      where b-moeda.mo-codigo = input frame {&frame-name} moeda.mo-codigo no-error.

  if  moeda.mo-codigo:sensitive then do:
      if  avail b-moeda then do:
          {utp/ut-field.i mguni moeda mo-codigo 1}
          run utp/ut-msgs.p(input "show",
                            input 1,
                            input return-value).
           apply "entry" to moeda.mo-codigo in frame {&frame-name}.
          return 'adm-error':U.
      end.
  end.

  /* Ponha aqui as demais validacoes */

  if input frame {&FRAME-NAME} moeda.descricao = "" then do:
     {utp/ut-field.i mguni moeda descricao 1}
     run utp/ut-msgs.p(input "show",
                       input 164,
                       input return-value).
     apply "entry" to moeda.descricao in frame {&frame-name}.
     return 'adm-error':U.
  end.
  if input frame {&FRAME-NAME} moeda.log-consid-dias-uteis = YES then do:
    if input frame {&FRAME-NAME} moeda.cod-calend = "" THEN DO:
        {utp/ut-field.i mguni moeda cod-calend 1}
        run utp/ut-msgs.p(input "show",
                          input 164,
                          input return-value).
         apply "entry" to moeda.cod-calend in frame {&frame-name}.
         return 'adm-error':U.
    end.

    find calen-gener no-lock where
         calen-gener.cd-calen eq input frame {&frame-name} moeda.cod-calend no-error.
    if not avail(calen-gener) then do:
        {utp/ut-field.i mguni moeda cod-calend 1}
        run utp/ut-msgs.p(input "show",
                          INPUT 2,
                          input return-value).
         apply "entry" to moeda.cod-calend in frame {&frame-name}.
         return 'adm-error':U.
    end.
    ELSE DO:
        assign c-cod-calend:screen-value in frame {&frame-name} = calen-gener.descricao.
    END.
  end.

  /*** Decimais - Chile ***/
  if l-ems203 AND l-funcao  then do:

      /*-- Valida campos dos Decimais-Chile (MODIFICA) --*/
      if input frame {&frame-name} moeda.mo-codigo:sensitive = no
      and ( input frame {&frame-name} cb-decimais <> v-decimais-old
         or input frame {&frame-name} cb-vl-inf   <> v-vl-inf-old
         or input frame {&frame-name} cb-vl-calc  <> v-vl-calc-old )
      then do:
        {cdp/cd0109.i}

        &if "{&mguni_dbtype}" = "Progress" &then
        find first MGUNI._file no-lock
            where MGUNI._file._file-name = "_connect" no-error.

        if avail MGUNI._file then do:
        &else
        find first SHMGUNI._file no-lock
            where SHMGUNI._file._file-name = "_connect" no-error.

        if avail SHMGUNI._file then do:
        &endif
            run cdp/cd0109a.p.

            if return-value = 'NOK' then
                return 'adm-error':U.
        end.
        else do:
            run utp/ut-msgs.p (input "show":U,
                               input 18736,
                               input "").
            return 'adm-error':U.
        end.
      end.
      assign l-mostra = no.
  end.

  assign c-char-1 = input frame {&frame-name} c-moeda-plural
         c-char-2 = input frame {&frame-name} c-desc-centavo
            + ";" + input frame {&frame-name} c-desc-centavos.

  ASSIGN OVERLAY(c-char-2,42,1) = ";"
         OVERLAY(c-char-2,43,3) = IF AVAIL moeda THEN SUBSTRING(moeda.char-2,43,3) ELSE "".

  IF i-pais-impto-usuario = 7 /* Chile */ THEN
     ASSIGN OVERLAY(c-char-2,46,20) = v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
     ASSIGN OVERLAY(c-char-2,46,20) = v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  assign c-desc-centavo-aux  = "     "
         c-desc-centavos-aux = "     ".

  assign c-desc-centavos-aux = entry(2,c-char-2,";")
         c-desc-centavo-aux  = entry(1,c-char-2,";") no-error.

  /*fut36887 - XML Adapter*/
  DEF VAR i-num AS INT NO-UNDO INITIAL 0.
    &IF "{&mgadm_version}" >= "2.04" &THEN
        IF v_log_eai_habilit THEN
        DO:
            FOR EACH tt_log_erro:
                DELETE tt_log_erro.
            END.
            FOR EACH RowErrors:
                DELETE RowErrors.
            END.
            RUN PITransUpsert IN h-adapter (INPUT moeda.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT cb-decimais:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT moeda.descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME},
/*                                            (IF moeda.ind-reajuste = 1 THEN "Di rio" ELSE "Mensal"),*/
                                            INPUT moeda.ind-reajuste:SCREEN-VALUE IN FRAME {&frame-name},
                                            INPUT moeda.sigla:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT 0,
/*                                            (IF moeda.ind-variacao = 1 THEN "Di rio" ELSE "Mensal"),*/
                                            INPUT moeda.ind-variacao:SCREEN-VALUE IN FRAME {&frame-name},
                                            INPUT (if  adm-new-record THEN "add" ELSE "upd"),
                                            OUTPUT TABLE tt_log_erro).
            {method/showmessage.i1}
            ASSIGN i-num = 0.
            FOR EACH tt_log_erro:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-num + 1
                       RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorType        = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_erro.
            END.
            IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60) THEN DO:
                {method/showmessage.i2}
                RETURN 'ADM-ERROR'.
            END.
        END.
    &endif

    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN
        ASSIGN v-nom-moeda-reporte = v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /*fut36887 - XML Adapter*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  IF i-pais-impto-usuario = 7 /* Chile */ THEN
    ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(c-char-2,46,15).

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
    ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(c-char-2,46,20).

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0109-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0109-crm.p PERSISTENT SET h-cd0109-crm.

        RUN sendToCRM IN h-cd0109-crm (INPUT moeda.mo-codigo,
                                       OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0109-crm.
    END.

  assign moeda.char-1 = c-char-1
         moeda.char-2 = c-char-2.

  assign c-desc-centavo-aux  = "     "
         c-desc-centavos-aux = "     ".

  /*** Decimais - Chile ***/
  if l-ems203 or l-funcao  then do:

      /*-- Atualiza os campos da tabela --*/
      &IF "{&fnc_multi_idioma}" = "yes" &THEN
          &if '{&mguni_version}' < "2.02" &then
              assign moeda.int-1 = int(input frame {&frame-name} cb-decimais)
                     moeda.int-2 = if input frame {&frame-name} cb-vl-inf = "Arredonda"
                                      then 1
                                   else if input frame {&frame-name} cb-vl-inf = "Trunca"
                                           then 2
                                        else 3
                     moeda.dec-1 = if input frame {&frame-name} cb-vl-calc = "Arredonda"
                                      then 1
                                   else 2.
          &else
              assign moeda.qtd-dec       = int(input frame {&frame-name} cb-decimais)
                     moeda.ind-val-infor = if input frame {&frame-name} cb-vl-inf = "Arredonda"
                                              then 1
                                           else if input frame {&frame-name} cb-vl-inf = "Trunca"
                                                   then 2
                                                else 3
                     moeda.ind-val-calc  = if input frame {&frame-name} cb-vl-calc = "Arredonda"
                                              then 1
                                           else 2.
          &endif
      &ELSE
          &if '{&mguni_version}' < "2.02" &then
              assign moeda.int-1 = int(input frame {&frame-name} cb-decimais)
                     moeda.int-2 = if input frame {&frame-name} cb-vl-inf = c-arredonda
                                      then 1
                                   else if input frame {&frame-name} cb-vl-inf = c-trunca
                                           then 2
                                        else 3
                     moeda.dec-1 = if input frame {&frame-name} cb-vl-calc = c-arredonda
                                      then 1
                                   else 2.
          &else
              assign moeda.qtd-dec       = int(input frame {&frame-name} cb-decimais)
                     moeda.ind-val-infor = if input frame {&frame-name} cb-vl-inf = c-arredonda
                                              then 1
                                           else if input frame {&frame-name} cb-vl-inf = c-trunca
                                                   then 2
                                                else 3
                     moeda.ind-val-calc  = if input frame {&frame-name} cb-vl-calc = c-arredonda
                                              then 1
                                           else 2.
          &endif
      &ENDIF

        IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
            RUN pi-atualiza-moeda IN h-bomx2016 (INPUT input frame {&frame-name} moeda.mo-codigo,
                                                 INPUT v-nom-moeda-reporte).

            IF  adm-new-record THEN DO:
                IF  AVAIL moeda THEN DO:
                    ASSIGN c-des-moeda = "".
                    RUN goToKey IN h-bomx2016 (INPUT moeda.mo-codigo,
                                               INPUT i-ep-codigo-usuario).
                    IF  RETURN-VALUE = "OK":U THEN
                        RUN getCharField IN h-bomx2016 (INPUT "des-moed-faturam":U,
                                                        OUTPUT c-des-moeda).
                    ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-des-moeda.
                END.
                ELSE ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            END.
        END.


      /*-- Seta var como yes para poder atualizar os campos dos decimais - Chile --*/
      assign l-mostra = yes.

      /*-- Atualiza a temp-table de moedas com a moeda que foi Inclu¡da/Alterada --*/
      find tt-moedas exclusive-lock
          where tt-moedas.cod-moeda = input frame {&frame-name} moeda.mo-codigo no-error.
      if not avail tt-moedas then do:
          create tt-moedas.
          assign tt-moedas.cod-moeda = input frame {&frame-name} moeda.mo-codigo.
      end.

      &IF "{&fnc_multi_idioma}" = "yes" &THEN
          assign tt-moedas.qtd-decimais      = int(input frame {&frame-name} cb-decimais)
              tt-moedas.ind-tratamento-infor = if input frame {&frame-name} cb-vl-inf = "Arredonda"
                                                   then 1
                                               else if input frame {&frame-name} cb-vl-inf = "Trunca"
                                                       then 2
                                                   else 3
              tt-moedas.ind-tratamento-calc  = if input frame {&frame-name} cb-vl-calc = "Arredonda"
                                                   then 1
                                               else 2.
      &ELSE
          assign tt-moedas.qtd-decimais      = int(input frame {&frame-name} cb-decimais)
              tt-moedas.ind-tratamento-infor = if input frame {&frame-name} cb-vl-inf = c-arredonda
                                                   then 1
                                               else if input frame {&frame-name} cb-vl-inf = c-trunca
                                                       then 2
                                                   else 3
              tt-moedas.ind-tratamento-calc  = if input frame {&frame-name} cb-vl-calc = c-arredonda
                                                   then 1
                                               else 2.
      &ENDIF
  end.

  {cdp/cd0002i1.i moeda} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */

  /*****[ Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC ]******/
    for each tt-smc-moeda:
        delete tt-smc-moeda.
    end.

    assign  c-transacao = "SMC019".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign  i-tipo-movto = if moeda.mo-codigo:sensitive in frame {&frame-name}
                           then 1 else 2.
    run pi-cria-tt-dados-smc (i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}

  /***[Fim da Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC]***/

  //Envia o registro para API de integra‡Æo
  IF adm-new-record THEN
      RUN sendIntegration("CREATE").
  ELSE
      RUN sendIntegration("UPDATE").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /*Decimais - Chile*/
  if l-ems203 or l-funcao then
      assign cb-decimais:screen-value in frame {&frame-name} = v-decimais-old
             cb-vl-inf:screen-value   in frame {&frame-name} = v-vl-inf-old
             cb-vl-calc:screen-value  in frame {&frame-name} = v-vl-calc-old.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /*** Valida‡Æo para elimina‡Æo da moeda ***/
  {cdp/cd0109.i1}

  /******[ BANCOS HISTàRICOS ]********************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 moeda moeda.mo-codigo '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
  /**********************************************************/

  /*** Decimais - Chile ***/
  if l-ems203 or l-funcao  then do:

      /*-- Atualiza temp-table moeda eliminando registro --*/
      find tt-moedas exclusive-lock
          where tt-moedas.cod-moeda = input frame {&frame-name} moeda.mo-codigo no-error.
      if avail tt-moedas then
          delete tt-moedas.
  end.

/*****[ Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC ]******/
    for each tt-smc-moeda:
        delete tt-smc-moeda.
    end.
    assign c-transacao    = "SMC019"
           i-tipo-movto   = 3.
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    run pi-cria-tt-dados-smc(i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/***[Fim da Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC]***/

    {cdp/cd0002i1.i1 moeda "no"} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */

  /*fut36887 - XML Adapters*/
  DEF VAR i-num AS INT NO-UNDO.
    &IF "{&mgadm_version}" >= "2.04" &THEN
        IF v_log_eai_habilit = YES THEN DO:
            RUN PITransDelete IN h-adapter(INPUT moeda.mo-codigo,
                                           INPUT moeda.descricao,
                                           OUTPUT TABLE tt_log_erro).


            {method/showmessage.i1}
            ASSIGN i-num = 0.
            FOR EACH tt_log_erro:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-num + 1
                       RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorType        = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_erro.
             END.

            IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60) THEN DO:
               {method/showmessage.i2}
               RETURN 'ADM-ERROR'.
           END.
       END.
    &endif
  /*fut36887 - XML Adapters*/

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0109-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0109-crm.p PERSISTENT SET h-cd0109-crm.

        RUN deleteFromCRM IN h-cd0109-crm (INPUT moeda.mo-codigo,
                                           OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0109-crm.
    END.

    IF  i-pais-impto-usuario = 4 THEN DO:
        RUN goToKey IN h-bomx2016 (INPUT moeda.mo-codigo,
                                   INPUT i-ep-codigo-usuario).
        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-bomx2016.
    END.

    RUN sendIntegration("DELETE").

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then
       return 'ADM-ERROR':U.

    {cdp/cd0002i1.i1 moeda "yes"} /* Integra‡Æo EMS 2.04 Financeiro x Magnus I.01 */
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
  /*fut36887 - XML adapters*/
  &IF "{&mgadm_version}" >= "2.04" &THEN
      IF v_log_eai_habilit = YES THEN DO:
          if  valid-handle(h-adapter) then do:
              delete procedure h-adapter.
              ASSIGN h-adapter = ?.
          end.
          {method/showmessage.i3}
      END.
   &endif
  /*fut36887 - XML adapters*/
  /* Dispatch standard ADM method.                             */

  IF  VALID-HANDLE(h-bomx2016) THEN
      RUN destroy IN h-bomx2016.

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

  /*Decimais - Chile*/
  if l-ems203 or l-funcao then
      disable cb-decimais
              cb-vl-inf
              cb-vl-calc with frame {&frame-name}.

  ASSIGN v-nom-moeda-reporte:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

if  avail moeda then do:
    find b-moeda where b-moeda.mo-codigo = moeda.mo-codigo no-lock no-error.
    if  avail b-moeda then do:

        assign c-desc-centavo:screen-value  in frame {&frame-name} = "     "
               c-desc-centavos:screen-value in frame {&frame-name} = "     "
               c-moeda-plural:screen-value  in frame {&frame-name} = "     ".

        run get-attribute ('adm-new-record').
        if  return-value = "no":U then do:

            assign c-desc-centavos-aux = " "
                   c-desc-centavo-aux  = " "
                   c-moeda-plural      = " ".
        end.

        assign c-desc-centavos-aux = entry(2,b-moeda.char-2,";")
               c-desc-centavo-aux  = entry(1,b-moeda.char-2,";")
               c-moeda-plural      = moeda.char-1 no-error.

    end.
    else do:
        assign c-desc-centavos-aux = " "
               c-desc-centavo-aux  = " "
               c-moeda-plural      = " ".
    end.
    IF moeda.cod-calend <> "" AND moeda.cod-calend <> ? THEN DO:

        FIND calen-gener NO-LOCK WHERE
             calen-gener.cd-calen = moeda.cod-calend NO-ERROR.

        IF AVAIL calen-gener THEN DO:
            ASSIGN c-cod-calend = calen-gener.descricao.
        END.
        ELSE DO:
            ASSIGN c-cod-calend = "".
        END.
    END.
    ELSE DO:
        ASSIGN c-cod-calend = "".
    END.

  /*Decimais - Chile*/
  if ( l-ems203 or l-funcao ) and l-mostra then do:
       /*fut36887 - atividade 147602 - altera‡Æo do teste da versÆo de 2.03 para 2.02 quando houver a fun‡Æo de Decimais Chile*/
       &IF "{&fnc_multi_idioma}" = "yes" &THEN

            &if '{&mguni_version}' < "2.02" &then
                assign cb-decimais:screen-value in frame {&frame-name} = string(moeda.int-1).

                if lookup(c-arredonda, cb-vl-inf:list-item-pairs,",") mod 2 <> 0 and
                   lookup(c-rejeita, cb-vl-inf:list-item-pairs,",")   mod 2 <> 0 and
                   lookup(c-trunca, cb-vl-inf:list-item-pairs,",")    mod 2 <> 0 then
                    assign cb-vl-inf:screen-value   in frame {&frame-name} = (if moeda.int-2 = 0 or moeda.int-2 = 1
                                                                                  then "Arredonda"
                                                                              else if moeda.int-2 = 2
                                                                                       then "Trunca"
                                                                                  else "Rejeita").

                if lookup(c-arredonda, cb-vl-calc:list-item-pairs,",") mod 2 <> 0 and
                   lookup(c-trunca, cb-vl-calc:list-item-pairs,",")    mod 2 <> 0 then
                assign cb-vl-calc:screen-value  in frame {&frame-name} = (if moeda.dec-1 = 0 or moeda.dec-1 = 1
                                                                              then "Arredonda"
                                                                          else "Trunca").
             &else
                 assign cb-decimais:screen-value in frame {&frame-name} = string(moeda.qtd-dec).

                  if lookup(c-arredonda, cb-vl-inf:list-item-pairs,",") mod 2 <> 0 and
                     lookup(c-rejeita, cb-vl-inf:list-item-pairs,",")   mod 2 <> 0 and
                     lookup(c-trunca, cb-vl-inf:list-item-pairs,",")    mod 2 <> 0 then
                     assign cb-vl-inf:screen-value   in frame {&frame-name} = (if moeda.ind-val-infor = 0 or moeda.ind-val-infor = 1
                                                                                  then "Arredonda"
                                                                               else if moeda.ind-val-infor = 2
                                                                                       then "Trunca"
                                                                               else "Rejeita").

                 if lookup(c-arredonda, cb-vl-calc:list-item-pairs,",") mod 2 <> 0 and
                    lookup(c-trunca, cb-vl-calc:list-item-pairs,",")    mod 2 <> 0 then
                 assign cb-vl-calc:screen-value  in frame {&frame-name} = (if moeda.ind-val-calc = 0 or moeda.ind-val-calc = 1
                                                                              then "Arredonda"
                                                                          else "Trunca").
            &endif
       &ELSE
            &if '{&mguni_version}' < "2.02" &then
                assign cb-decimais:screen-value in frame {&frame-name} = string(moeda.int-1)
                       cb-vl-inf:screen-value   in frame {&frame-name} = (if moeda.int-2 = 0 or moeda.int-2 = 1
                                                                             then c-arredonda
                                                                         else if moeda.int-2 = 2
                                                                                  then c-trunca
                                                                              else c-rejeita)
                       cb-vl-calc:screen-value  in frame {&frame-name} = (if moeda.dec-1 = 0 or moeda.dec-1 = 1
                                                                           then c-arredonda
                                                                       else c-trunca).
            &else
                assign cb-decimais:screen-value in frame {&frame-name} = string(moeda.qtd-dec)
                       cb-vl-inf:screen-value   in frame {&frame-name} = (if moeda.ind-val-infor = 0 or moeda.ind-val-infor = 1
                                                                             then c-arredonda
                                                                         else if moeda.ind-val-infor = 2
                                                                                  then c-trunca
                                                                              else c-rejeita)
                       cb-vl-calc:screen-value  in frame {&frame-name} = (if moeda.ind-val-calc = 0 or moeda.ind-val-calc = 1
                                                                             then c-arredonda
                                                                         else c-trunca).
            &endif
       &ENDIF
  end.

end.


RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

{utp/ut-field.i mguni moeda ind-variacao 1}
assign texto-1:screen-value in frame {&frame-name} = return-value + ":".

{utp/ut-field.i mguni moeda ind-reajuste 1}
assign texto-2:screen-value in frame {&frame-name} = return-value + ":".

{utp/ut-liter.i Tratamento_do_valor *}
assign texto-3:screen-value in frame {&frame-name} = trim(return-value) + ":".

{utp/ut-liter.i Cota‡Æo_m‚dia *}
assign texto-4:screen-value in frame {&frame-name} = trim(return-value) + ":".

if  c-desc-centavos-aux <> " " then do:
    assign c-desc-centavos:screen-value in frame {&frame-name} = c-desc-centavos-aux.
end.
else do:
    assign c-desc-centavos:screen-value in frame {&frame-name} = " ".
end.

if  c-desc-centavo-aux <> " " then do:
    assign c-desc-centavo:screen-value in frame {&frame-name} = c-desc-centavo-aux.
end.
else do:
    assign c-desc-centavo:screen-value in frame {&frame-name} = " ".
end.

if  c-moeda-plural <> " " then do:
    assign c-moeda-plural:screen-value in frame {&frame-name} = c-moeda-plural.
end.
else do:
    assign c-moeda-plural:screen-value in frame {&frame-name} = " ".
end.

IF AVAIL moeda THEN DO:
    IF i-pais-impto-usuario = 4 /* M‚xico */ THEN DO:
      ASSIGN c-des-moeda = "".
      RUN goToKey IN h-bomx2016 (INPUT moeda.mo-codigo,
                                 INPUT i-ep-codigo-usuario).
      IF  RETURN-VALUE = "OK":U THEN
          RUN getCharField IN h-bomx2016 (INPUT "des-moed-faturam":U,
                                          OUTPUT c-des-moeda).
      ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-des-moeda.
    END.

    IF i-pais-impto-usuario = 7 /* Chile */ THEN
        ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(moeda.char-2,46,15).

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(moeda.char-2,46,20).
END.
ELSE
    ASSIGN v-nom-moeda-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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

    find first param-global no-lock no-error.
     if param-global.modulo-cn = no then
      assign moeda.ind-variacao:sensitive in frame {&frame-name} = no
             moeda.ind-reajuste:sensitive in frame {&frame-name} = no.


    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    if l-add = no then
    do:
        if moeda.ind-variacao = 2 then
        do:
            assign moeda.ind-reajuste:sensitive in frame {&frame-name} = no.
            disp moeda.ind-variacao
                 moeda.ind-reajuste with frame {&frame-name}.
        end.
        if moeda.ind-variacao = 1 then
        do:
            assign moeda.ind-reajuste:sensitive in frame {&frame-name} = yes.
            disp moeda.ind-variacao
                 moeda.ind-reajuste with frame {&frame-name}.
        end.
    end.

    IF moeda.log-consid-dias-uteis = NO THEN DO:
            ASSIGN moeda.cod-calend:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END.

    /*Decimais - Chile*/
    if l-ems203 AND l-funcao then do:
        enable cb-decimais
               cb-vl-inf
               cb-vl-calc with frame {&frame-name}.

        /*Guarda valores anteriores para poder desfazer*/
        assign v-decimais-old = input frame {&frame-name} cb-decimais
               v-vl-inf-old   = input frame {&frame-name} cb-vl-inf
               v-vl-calc-old  = input frame {&frame-name} cb-vl-calc.

        /*Seta valores iniciais*/
        if input frame {&frame-name} cb-decimais = "" then
            assign cb-decimais:screen-value in frame {&frame-name} = '2'
                   v-decimais-old = '2'.

        &IF "{&fnc_multi_idioma}" = "yes" &THEN
            if input frame {&frame-name} cb-vl-inf   = "" then do:
                if lookup(c-arredonda, cb-vl-inf:list-item-pairs,",") mod 2 <> 0 then
                    assign cb-vl-inf:screen-value in frame {&frame-name}   = "Arredonda"
                           v-vl-inf-old = "Arredonda".
            end.
            if input frame {&frame-name} cb-vl-calc  = "" then do:
                if lookup(c-arredonda, cb-vl-calc:list-item-pairs,",") mod 2 <> 0 then
                    assign cb-vl-calc:screen-value in frame {&frame-name}  = "Arredonda"
                           v-vl-calc-old = "Arredonda".
            end.
        &ELSE
            if input frame {&frame-name} cb-vl-inf   = "" then
                assign cb-vl-inf:screen-value in frame {&frame-name}   = c-arredonda
                       v-vl-inf-old = "Arredonda".
            if input frame {&frame-name} cb-vl-calc  = "" then
                assign cb-vl-calc:screen-value in frame {&frame-name}  = c-arredonda
                       v-vl-calc-old = "Arredonda".
        &ENDIF
    end.
    ELSE DO:

        &if '{&mguni_version}' > "2.02" &then
            assign cb-decimais:sensitive in frame {&frame-name} = false
                   cb-vl-inf:sensitive   in frame {&frame-name} = false
                   cb-vl-calc:sensitive  in frame {&frame-name} = false
                   texto-3:sensitive     in frame {&frame-name} = false
                   RECT-3:sensitive      in frame {&frame-name} = false.
        &endif

    END.

    ASSIGN v-nom-moeda-reporte:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  /*Decimais - Chile*/
  if not l-ems203 and not l-funcao  THEN
    assign cb-decimais:visible in frame {&frame-name} = false
           cb-vl-inf:visible   in frame {&frame-name} = false
           cb-vl-calc:visible  in frame {&frame-name} = false
           texto-3:visible     in frame {&frame-name} = false
           RECT-3:visible      in frame {&frame-name} = false.


  /* Carrega vari veis com valores que serÆo mostrados no combo-box do tratamento decimais */
  {utp/ut-liter.i Arredonda *}
  assign c-arredonda = trim(return-value).

  {utp/ut-liter.i Trunca *}
  assign c-trunca = trim(return-value).

  {utp/ut-liter.i Rejeita *}
  assign c-rejeita = trim(return-value).

  {utp/ut-liter.i Plural_descri‡Æo *}
  assign c-moeda-plural:label in frame {&frame-name} = trim(return-value)
         c-desc-centavos:label     in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Descri‡Æo_fra‡Æo *}
  assign c-desc-centavo:label in frame {&frame-name} = trim(return-value).

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      assign cLista = {adinc/i05ad099.i 03}.
      run utp/ut-lstit.p (input-output cLista).
      assign cb-vl-inf:list-item-pairs in frame {&FRAME-NAME} = cLista.

      assign cLista = {adinc/i05ad098.i 03}.
      run utp/ut-lstit.p (input-output cLista).
      assign cb-vl-calc:list-item-pairs in frame {&FRAME-NAME} = cLista.
  &else
      assign cb-vl-inf:LIST-ITEMS  in frame {&frame-name} = {adinc/i05ad099.i 03}
             cb-vl-calc:LIST-ITEMS in frame {&frame-name} = {adinc/i05ad098.i 03}.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    {utp/ut-field.i mguni moeda ind-variacao 1}
    assign texto-1:screen-value in frame {&frame-name} = trim(return-value).

    {utp/ut-field.i mguni moeda ind-reajuste 1}
    assign texto-2:screen-value in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Cota‡Æo_m‚dia *}
    assign texto-4:screen-value in frame {&frame-name} = trim(return-value).

    IF i-pais-impto-usuario = 7 /* Chile */ THEN
        ASSIGN v-nom-moeda-reporte:HIDDEN IN FRAME {&FRAME-NAME} = NO
               v-nom-moeda-reporte:FORMAT IN FRAME {&FRAME-NAME} = "x(15)".

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN v-nom-moeda-reporte:HIDDEN IN FRAME {&FRAME-NAME} = NO
               v-nom-moeda-reporte:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
        ASSIGN v-nom-moeda-reporte:HIDDEN IN FRAME {&FRAME-NAME} = NO.
        RUN local/mex/bomx2016.p PERSISTENT SET h-bomx2016.
        RUN openQueryStatic IN h-bomx2016 (INPUT "main":U).
    END.

  /*Decimais - Chile*/
  if l-ems203 or l-funcao then do:
      {utp/ut-liter.i Tratamento_do_valor *}
      assign texto-3:screen-value in frame {&frame-name} = trim(return-value).

      disable cb-decimais
              cb-vl-inf
              cb-vl-calc with frame {&frame-name}.
  end.


  /*fut36887 - XML adapters*/
    &IF "{&mgadm_version}" >= "2.04" &THEN
        IF v_log_eai_habilit THEN
            RUN adapters/xml/fi2/axsfi002.p PERSISTENT SET h-adapter (OUTPUT TABLE tt_log_erro).
    &endif
  /*fut36887 - XML adapters*/

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    {cdp/cd0003i1.i moeda cdp/cd0914i1.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input parameter i-tipo-movto as integer.

    if  param-global.modulo-mp
    and tt-replica-msg-SMC.log-replica-msg  = yes
    then do:
        create  tt-smc-moeda.
        buffer-copy moeda to tt-smc-moeda.
        create  tt-dados-env-SMC.
        assign  tt-dados-env-SMC.num-sequencia  = i-seq
                tt-dados-env-SMC.cod-tipo-reg   = 45
                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                tt-dados-env-SMC.identif-msg    = string(moeda.mo-codigo).
        raw-transfer tt-smc-moeda to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-moeda-mg V-table-Win
PROCEDURE pi-cria-tt-moeda-mg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-moeda-mg:
        delete tt-moeda-mg.
    end.

    create tt-moeda-mg.
    assign tt-moeda-mg.ind-tipo-movto     = p-ind-tipo-movto
           tt-moeda-mg.l-atualiza         = p-atualiza.

    /* Campos Iguais */
    assign tt-moeda-mg.mo-codigo          = moeda.mo-codigo
           tt-moeda-mg.descricao          = fn-free-accent(moeda.descricao)
           tt-moeda-mg.sigla              = moeda.sigla
           tt-moeda-mg.log-1              = moeda.log-1
           tt-moeda-mg.cod-decex          = moeda.cod-decex
           tt-moeda-mg.dec-2              = moeda.dec-2.

    if moeda.contab-estat = 1 then assign tt-moeda-mg.contab-estat = yes.
    if moeda.contab-estat = 2 then assign tt-moeda-mg.contab-estat = no.

    do i-cont-mg = 1 to 9:
       tt-moeda-mg.moeda-cacex[i-cont-mg] = moeda.moeda-cacex[i-cont-mg].
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    {cdp/cd0004i1.i "CD0914" "MOEDA" moeda.mo-codigo tt-moeda-mg.ind-tipo-movto tt-erros-mg.help-msg}

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-moeda-mg V-table-Win
PROCEDURE pi-valida-moeda-mg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.

    return "OK":U.

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
  {src/adm/template/snd-list.i "moeda"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendIntegration V-table-Win
PROCEDURE sendIntegration :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-type AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Currency",            /* Nome da transa»’o     */
                                                                                         INPUT ROWID(moeda),          /* Registro da transa‡Æo */
                                                                                         INPUT p-type,                /* Evento da transa‡Æo   */
                                                                                         OUTPUT TABLE RowErrors APPEND).  /* Erros da transa‡Æo    */

    DELETE PROCEDURE h-ut-integration.
    ASSIGN h-ut-integration = ?.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
                {method/showmessage.i2 &Modal="Yes"}

                RETURN "ADM-ERROR":U.
        END.

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

