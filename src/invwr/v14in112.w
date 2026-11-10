&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V14IN112 2.00.00.059 } /*** "010059" 20/11/2023 14:24:03  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v14in112 MUT}
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
{method/dbotterr.i}  /* rowerrors                              */
{cdp/cd0666.i}   /* defini‡Æo da tt-erro */
{cdp/cdcfgmat.i} /* pre-processadores    */
{cdp/cd9731.i2}  /* defini‡Æo da spp-matriz-medicao */

/* Multiplanta */
def var l-erro as logical no-undo.
def var i-tipo-movto as integer no-undo.
def var c-msg as char no-undo.
/* ----------- */

/* global variable definitions */

def new global shared var gr-evento-ped as rowid no-undo.
def var rw-evento-ped as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var r-evento as rowid no-undo.
def var de-total-qtd like evento-ped.qtd-prevista.
def var de-total-val like evento-ped.val-previsto.
def var de-qtd-medicao    like medicao-contrat.qtd-prevista no-undo.
def var de-val-realizado  like evento-ped.val-realizado.
def var de-perc-medicao   like medicao-contrat.perc-medicao.
def var i-num-seq-medicao like medicao-contrat.num-seq-medicao.
def var l-erro-co  as logical.
def var l-erro-in  as logical.
def var l-msg-tela as logical.
def var sit-anterior as integer.
def buffer b-evento-ped for evento-ped.
def var v-dt-evento as char.
def var v-dt-real as char.
def new shared var c-cod-estabel like estabelec.cod-estabel.

{cep/ce1234.i}  /* Valida»’o Decimais */

def var de-qtd-medicao-t  like medicao-contrat.qtd-prevista no-undo.
def var de-val-medicao-t  like medicao-contrat.val-medicao no-undo.
def var de-perc-medicao-t like medicao-contrat.perc-medicao no-undo.

DEF VAR l-log-portal-paradigma AS LOG NO-UNDO INITIAL NO.
def var l-erro-prov as logical no-undo.

DEFINE VARIABLE l-hab-val-realizado AS LOGICAL NO-UNDO.

/* Integracao Contratos - declaracao temp-tables */
{cnp/cnapi020.i3}

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
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS evento-ped.ind-sit-event ~
evento-ped.dat-realiz evento-ped.perc-lib-previst evento-ped.val-previsto ~
evento-ped.qtd-prevista
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-mold
&Scoped-Define DISPLAYED-FIELDS evento-ped.ind-sit-event ~
evento-ped.dat-realiz evento-ped.dt-evento evento-ped.perc-lib-previst ~
evento-ped.perc-lib-realizado evento-ped.ind-dest-event ~
evento-ped.val-previsto evento-ped.val-realizado evento-ped.cod-cond-pag ~
evento-ped.qtd-prevista evento-ped.qtd-realizada
&Scoped-define DISPLAYED-TABLES evento-ped
&Scoped-define FIRST-DISPLAYED-TABLE evento-ped


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS evento-ped.ind-sit-event ~
evento-ped.dt-evento evento-ped.perc-lib-previst ~
evento-ped.perc-lib-realizado evento-ped.ind-dest-event ~
evento-ped.val-previsto evento-ped.val-realizado evento-ped.cod-cond-pag ~
evento-ped.qtd-prevista evento-ped.qtd-realizada

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 87.14 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     evento-ped.ind-sit-event AT ROW 1.38 COL 24.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS
                    "Pendente", 1,
"Realizado", 2,
"Cancelado", 3,
"Atendido", 4
          SIZE 50.14 BY .83
     evento-ped.dat-realiz AT ROW 2.38 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12.57 BY .88
     evento-ped.dt-evento AT ROW 2.5 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12.57 BY .88
     evento-ped.perc-lib-previst AT ROW 3.38 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     evento-ped.perc-lib-realizado AT ROW 3.38 COL 71 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     evento-ped.ind-dest-event AT ROW 3.5 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 2.29 BY .88
     evento-ped.val-previsto AT ROW 4.38 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     evento-ped.val-realizado AT ROW 4.38 COL 71 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     evento-ped.cod-cond-pag AT ROW 4.5 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 4.57 BY .88
     evento-ped.qtd-prevista AT ROW 5.38 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     evento-ped.qtd-realizada AT ROW 5.38 COL 71 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 12.14 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.evento-ped
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
         HEIGHT             = 5.58
         WIDTH              = 87.14.
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

/* SETTINGS FOR FILL-IN evento-ped.cod-cond-pag IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN evento-ped.dt-evento IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN evento-ped.ind-dest-event IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET evento-ped.ind-sit-event IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN evento-ped.perc-lib-previst IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN evento-ped.perc-lib-realizado IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN evento-ped.qtd-prevista IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN evento-ped.qtd-realizada IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN evento-ped.val-previsto IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN evento-ped.val-realizado IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME evento-ped.dat-realiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.dat-realiz V-table-Win
ON LEAVE OF evento-ped.dat-realiz IN FRAME f-main /* Realiza‡Æo Evento */
DO:
    if input frame {&frame-name} evento-ped.dat-realiz <
     input frame {&frame-name} evento-ped.dt-evento then do:
      run utp/ut-msgs.p (input "show",
                         input 89,
                         input v-dt-real + "~~" + v-dt-evento).
      return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.ind-sit-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.ind-sit-event V-table-Win
ON VALUE-CHANGED OF evento-ped.ind-sit-event IN FRAME f-main /* Situa‡Æo */
DO:
    IF  INPUT FRAME {&frame-name} evento-ped.ind-sit-event = 2 /* Realizado */ OR
        INPUT FRAME {&frame-name} evento-ped.ind-sit-event = 3 /* Cancelado */ OR
        INPUT FRAME {&frame-name} evento-ped.ind-sit-event = 4 /* Atendido  */ THEN DO:
        ASSIGN evento-ped.dat-realiz:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               evento-ped.val-realizado:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE DO:
        ASSIGN evento-ped.dat-realiz:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
               evento-ped.val-realizado:SENSITIVE IN FRAME {&FRAME-NAME} = l-hab-val-realizado.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.perc-lib-realizado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.perc-lib-realizado V-table-Win
ON LEAVE OF evento-ped.perc-lib-realizado IN FRAME f-main /* Real % */
DO:

run pi-leave.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.qtd-realizada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.qtd-realizada V-table-Win
ON LEAVE OF evento-ped.qtd-realizada IN FRAME f-main /* Qtd Realizada */
DO:

run pi-leave.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.val-realizado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.val-realizado V-table-Win
ON LEAVE OF evento-ped.val-realizado IN FRAME f-main /* Valor Realizado */
DO:

run pi-leave.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

  FIND FIRST param-compra NO-LOCK NO-ERROR.
  IF CAN-FIND(FIRST funcao NO-LOCK
              WHERE funcao.cd-funcao = "SPP-PORTAL-PARADIGMA":U
                AND funcao.ativo) THEN DO:
      IF &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
             (AVAIL param-compra AND substring(param-compra.char-2,103, 1) = "S":U)
         &ELSE
             (AVAIL param-compra AND param.compra.log-portal-paradigma)
         &ENDIF
      THEN DO:
          ASSIGN l-log-portal-paradigma = YES.
      END.
  END.

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "evento-ped"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "evento-ped"}

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

/*  if input frame {&frame-name} evento-ped.dat-realiz <
 *    input frame {&frame-name} evento-ped.dt-evento then do:
 *     run utp/ut-msgs.p (input "show",
 *                        input 89,
 *                        input v-dt-real + "~~" + v-dt-evento).
 *     apply 'entry' to evento-ped.dat-realiz in frame {&frame-name}.
 *     return 'ADM-ERROR':U.
 *   end.*/

for each tt-erro:
    delete tt-erro.
end.

if  avail evento-ped then
    assign sit-anterior = evento-ped.ind-sit-event.

if  avail evento-ped then do with frame {&frame-name}:
    find ordem-compra where ordem-compra.numero-ordem = evento-ped.numero-ordem
        no-lock no-error.
    if  avail ordem-compra then do:
        assign l-rejeita-dec  = no.
        assign evento-ped.val-previsto:screen-value = string(fn_vld_ajust_dec(input (input evento-ped.val-previsto),input ordem-compra.mo-codigo)).
        assign evento-ped.val-realizado:screen-value = string(fn_vld_ajust_dec(input (input evento-ped.val-realizado),input ordem-compra.mo-codigo)).
        if  l-rejeita-dec then do:
            run utp/ut-msgs.p("show",18100,"").
            return "ADM-ERROR":U.
        end.
    end.
end.

if  not avail param-global then
    find first param-global no-lock no-error.

if  avail evento-ped and
    &if defined(bf_mat_contratos) &then
    evento-ped.nr-contrato <> 0
    &else
    evento-ped.nr-contrato <> "" &endif
    then do with frame {&frame-name}:
    find item-contrat where item-contrat.num-seq-item   = evento-ped.num-seq-item
                            and item-contrat.nr-contrato = evento-ped.nr-contrato
                            no-lock no-error.
    if not avail item-contrat then do:
        {utp/ut-table.i mgind item-contrat 1}
        run utp/ut-msgs.p ("show",47,trim(return-value)).
        return "adm-error".
    end.

    if  not avail contrato-for then
        find contrato-for where contrato-for.nr-contrato = evento-ped.nr-contrato no-lock no-error.

    if  avail contrato-for and
        contrato-for.ind-control-rec = 1 then
        assign evento-ped.it-codigo = item-contrat.it-codigo.

    if  sit-anterior <> 1 and input frame {&frame-name} evento-ped.ind-sit-event = 1 then do:
        find first medicao-contrat where medicao-contrat.numero-ordem  = evento-ped.numero-ordem
                                     and medicao-contrat.num-seq-event = evento-ped.seq-evento
                                     and medicao-contrat.log-rec-medicao = yes no-lock no-error.
        if avail medicao-contrat then do:
            run utp/ut-msgs.p (input "show",
                               input 8475,
                               input "").
            apply 'entry' to evento-ped.ind-sit-event.
            return "adm-error".
        end.
    end.

    if  input evento-ped.ind-sit-event = 2
        and sit-anterior = 2 then do:
        run utp/ut-msgs.p ("show",8476,"").
        apply 'entry' to evento-ped.ind-sit-event.
        return "adm-error".
    end.

    if  item-contrat.ind-tipo-control = 1  and
        can-find(first medicao-contrat where
                       medicao-contrat.nr-contrat    = evento-ped.nr-contrato  and
                       medicao-contrat.numero-ordem  = evento-ped.numero-ordem and
                       medicao-contrat.num-seq-event = evento-ped.seq-evento ) and
      ( (evento-ped.val-realizado:sensitive   and input evento-ped.val-realizado   < evento-ped.val-realizado)   OR
        (evento-ped.perc-lib-realiz:sensitive and input evento-ped.perc-lib-realiz < evento-ped.perc-lib-realiz) OR
        (evento-ped.qtd-realizada:sensitive   and input evento-ped.qtd-realizada   < evento-ped.qtd-realizada ) )
    then do:
          /** Quantidade/valor/percentual menor que anterior*/
          if  evento-ped.val-realizado:sensitive then
              {utp/ut-liter.i Valor}
          if  evento-ped.qtd-realizada:sensitive then
              {utp/ut-liter.i Quantidade}
          if  evento-ped.perc-lib-realiz:sensitive then
              {utp/ut-liter.i Percentual}
          run utp/ut-msgs.p ("show",18415,trim(return-value)).
          return "adm-error".
    end.

    assign de-val-realizado = 0
           de-qtd-medicao   = 0
           de-perc-medicao  = 0.

    if  input frame {&frame-name} evento-ped.ind-sit-event = 2 and sit-anterior <> 2 then do:
        if  item-contrat.ind-tipo-control = 1 then do:
            for each medicao-contrat where medicao-contrat.nr-contrato   = evento-ped.nr-contrato
                                       and medicao-contrat.num-seq-item  = evento-ped.num-seq-item
                                       AND medicao-contrat.numero-ordem  = evento-ped.numero-ordem
                                       and medicao-contrat.num-seq-event = evento-ped.seq-evento no-lock:
                assign de-val-realizado = de-val-realizado + medicao-contrat.val-medicao
                       de-perc-medicao  = de-perc-medicao  + medicao-contrat.perc-medicao
                       de-qtd-medicao   = de-qtd-medicao   + medicao-contrat.qtd-medicao.
            end.
        end.
        if  de-val-realizado <> input frame {&frame-name} evento-ped.val-realizado /*AND item-contrat.ind-tipo-control = 1*/ then do:
            find last medicao-contrat where medicao-contrat.nr-contrato   = evento-ped.nr-contrato
                                        and medicao-contrat.num-seq-item  = evento-ped.num-seq-item
                                        and medicao-contrat.numero-ordem  = evento-ped.numero-ordem
                                        and medicao-contrat.num-seq-event = evento-ped.seq-evento
                                        no-lock no-error.
            if  avail medicao-contrat then do:
                if  item-contrat.ind-tipo-control = 1 then do:
                    if  de-val-realizado < input evento-ped.val-realizado then do:
                        assign de-val-realizado  = input evento-ped.val-realizado - de-val-realizado
                               de-qtd-medicao    = input evento-ped.qtd-realizada - de-qtd-medicao
                               /*de-perc-medicao   = input evento-ped.perc-lib-realiz - de-perc-medicao*/
                               de-perc-medicao   = ((de-qtd-medicao * 100) / INPUT evento-ped.qtd-prevista) /*input evento-ped.perc-lib-realiz - de-perc-medicao*/
                               i-num-seq-medicao = medicao-contrat.num-seq-medicao + 1
                               input evento-ped.ind-sit-event. /* dentro da include e usado */
                        {cnp/cn0303.i3}
                        /*  Matriz rateio Medi‡Æo  */
                        IF  l-matriz-medicao THEN DO:
                            RUN cnp/cnapi014.p (INPUT ROWID(medicao-contrat),
                                                INPUT item-contrat.ind-tipo-control,
                                                INPUT contrato-for.ind-control-rec).

                            IF  RETURN-VALUE = "NOK":U THEN
                                undo,return "adm-error".

                            RUN cnp/cnapi011.p (INPUT ROWID(medicao-contrat),
                                                INPUT-OUTPUT TABLE tt-erro,
                                                OUTPUT l-erro-in).

                            IF  l-erro-in THEN DO:
                                run cdp/cd0666.w (input table tt-erro).
                                apply "entry":U to frame {&frame-name}.
                                undo, return "adm-error".
                            END.
                        END.
                        /* Fim Rateio */

                        /* Integracao Contratos - limpa registros temp-table integra‡Æo */
                        {cnp/cnapi020.i4}

                         /** Integracao Contratos - criar registro para inclusao **/
                        {cnp/cnapi020.i1 2 1 CD0115 " " medicao-contrat medicao-contrat}

                        /* Integracao Contratos - executa API integra‡Æo e valida erros */
                        {cnp/cnapi020.i2 ADM-ERROR yes}

                        find first tt-erro no-lock no-error.
                        if  avail tt-erro then do:
                            run cdp/cd0666.w (input table tt-erro).
                            apply "entry":U to frame {&frame-name}.
                            undo,return "adm-error".
                        end.
                    end.
                end.
                else do:
                    assign de-val-realizado  = input evento-ped.val-realizado
                           i-num-seq-medicao = 1
                           de-qtd-medicao    = input evento-ped.qtd-realizada
                           input evento-ped.ind-sit-event. /* dentro da include e usado */

                    {cnp/cn0303.i3}
                    /* Matriz rateio Medi‡Æo */
                    IF  l-matriz-medicao THEN DO:
                        RUN cnp/cnapi014.p (INPUT ROWID(medicao-contrat),
                                            INPUT item-contrat.ind-tipo-control,
                                            INPUT contrato-for.ind-control-rec).

                        IF  RETURN-VALUE = "NOK":U THEN
                            undo,return "adm-error".


                        RUN cnp/cnapi011.p (INPUT ROWID(medicao-contrat),
                                            INPUT-OUTPUT TABLE tt-erro,
                                            OUTPUT l-erro-in).

                        IF  l-erro-in THEN DO:
                            run cdp/cd0666.w (input table tt-erro).
                            apply "entry":U to frame {&frame-name}.
                            undo, return "adm-error".
                        END.
                    END.
                    /* Fim Rateio */

                    /* Integracao Contratos - limpa registros temp-table integra‡Æo */
                    {cnp/cnapi020.i4}

                     /** Integracao Contratos - criar registro para inclusao **/
                    {cnp/cnapi020.i1 2 1 CD0115 " " medicao-contrat medicao-contrat}

                    /* Integracao Contratos - executa API integra‡Æo e valida erros */
                    {cnp/cnapi020.i2 ADM-ERROR yes}


                    find first tt-erro no-lock no-error.
                    if  avail tt-erro then do:
                        run cdp/cd0666.w (input table tt-erro).
                        apply "entry":U to frame {&frame-name}.
                        undo,return "adm-error".
                    end.
                end.
            end.
            else do:
                assign de-val-realizado  = input evento-ped.val-realizado
                       i-num-seq-medicao = 1
                       de-qtd-medicao    = input evento-ped.qtd-realizada
                       input evento-ped.ind-sit-event. /* dentro da include e usado */

                {cnp/cn0303.i3}
                /* Matriz rateio Medi‡Æo */
                IF  l-matriz-medicao THEN DO:
                    RUN cnp/cnapi014.p (INPUT ROWID(medicao-contrat),
                                        INPUT item-contrat.ind-tipo-control,
                                        INPUT contrato-for.ind-control-rec).

                    IF  RETURN-VALUE = "NOK":U THEN
                        undo,return "adm-error".

                    RUN cnp/cnapi011.p (INPUT ROWID(medicao-contrat),
                                        INPUT-OUTPUT TABLE tt-erro,
                                        OUTPUT l-erro-in).

                    IF  l-erro-in THEN DO:
                        run cdp/cd0666.w (input table tt-erro).
                        apply "entry":U to frame {&frame-name}.
                        undo, return "adm-error".
                    END.
                END.

                 /* Integracao Contratos - limpa registros temp-table integra‡Æo */
                {cnp/cnapi020.i4}

                 /** Integracao Contratos - criar registro para inclusao **/
                {cnp/cnapi020.i1 2 1 CD0115 " " medicao-contrat medicao-contrat}

                /* Integracao Contratos - executa API integra‡Æo e valida erros */
                {cnp/cnapi020.i2 ADM-ERROR yes}

                /* Fim Rateio */

                find first tt-erro no-lock no-error.
                if  avail tt-erro then do:
                    run cdp/cd0666.w (input table tt-erro).
                    apply "entry":U to frame {&frame-name}.
                    undo,return "adm-error".
                end.
            end.
        end.
        else do:
            assign l-erro-co = no.
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input 0, input 0,
                                input (input evento-ped.qtd-realizada - de-qtd-medicao),
                                input (input evento-ped.val-realizado - de-val-realizado),
                                input 0, input 0,
                                input c-cod-estabel,
                                output l-msg-tela,
                                output l-erro-co,
                                input-output table tt-erro).
            find first tt-erro no-lock no-error.
            if  avail tt-erro then do:
                run cdp/cd0666.w (input table tt-erro).
                undo,return "adm-error".
            end.
        end.
    end.

    find first medicao-contrat where medicao-contrat.nr-contrat      = evento-ped.nr-contrat
                                 and medicao-contrat.num-seq-item    = evento-ped.num-seq-item
                                 and medicao-contrat.numero-ordem    = evento-ped.numero-ordem
                                 and medicao-contrat.num-seq-event   = evento-ped.seq-evento
                                 and medicao-contrat.num-seq-medicao = i-num-seq-medicao exclusive-lock no-error.
    if avail medicao-contrat THEN DO:
        assign medicao-contrat.dat-medicao = evento-ped.dt-evento.
    end.

    /* Atualizar valor movimentado quando diminuida
       a quantidade ou o valor na realiza‡Æo do evento */
    if  item-contrat.ind-tipo-control = 1 AND evento-ped.val-previsto > input evento-ped.val-realizado and
        evento-ped.ind-sit-event = 2 and sit-anterior <> 2 then do with frame {&frame-name}:
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (evento-ped.qtd-prevista - input evento-ped.qtd-realizada) * (-1),
                            input (evento-ped.val-previsto - input evento-ped.val-realizado) * (-1),
                            input 0,
                            input 0,
                            input 0,
                            input 0,
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro).
    end.
    /* Atualizar valor movimentado quando aumentado
       a quantidade ou o valor na realiza‡Æo do evento */
    if  item-contrat.ind-tipo-control = 1 AND evento-ped.val-previsto < input evento-ped.val-realizado and
        evento-ped.ind-sit-event = 2 and sit-anterior <> 2 then do with frame {&frame-name}:
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (input evento-ped.qtd-realizada - evento-ped.qtd-prevista) * (1),
                            input (input evento-ped.val-realizado - evento-ped.val-realizado) * (1),
                            input 0,
                            input 0,
                            input 0,
                            input 0,
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro).
    end.
    if (item-contrat.ind-tipo-control-val = 1 or
        item-contrat.ind-tipo-control-val = 2) and
        contrato-for.variacao-qtd >= 0 then do:
        if  item-contrat.log-control-event then
        if input frame {&frame-name} evento-ped.qtd-realizada >
          (input frame {&frame-name} evento-ped.qtd-prevista +
          (input frame {&frame-name} evento-ped.qtd-prevista *
           contrato-for.variacao-qtd / 100)) then do:
            run utp/ut-msgs.p (input "show", input 7344, input "").
            apply 'entry' to evento-ped.qtd-realizada in frame {&frame-name}.
            undo,return "adm-error".
       end.
    end.
    else
    if  item-contrat.ind-tipo-control-val = 3 and
        contrato-for.variacao-preco >= 0 then do:
        if  item-contrat.log-control-event then
        if  input frame {&frame-name} evento-ped.val-realizado >
           (input frame {&frame-name} evento-ped.val-previsto +
           (input frame {&frame-name} evento-ped.val-previsto *
            contrato-for.variacao-preco / 100)) then do:
            run utp/ut-msgs.p (input "show", input 7347, input "").
            apply 'entry' to evento-ped.val-realizado in frame {&frame-name}.
            undo,return "adm-error".
        end.
    end.

    if  item-contrat.ind-tipo-control-val = 1 or
        item-contrat.ind-tipo-control-val = 2 then do:
        if  contrato-for.qtd-total <> 0 then do:
            if  item-contrat.log-control-event then
                assign de-total-qtd = de-total-qtd + input frame {&frame-name} evento-ped.qtd-realizada.
        end.
    end.
    else if item-contrat.ind-tipo-control-val = 3 then do:
        if  contrato-for.val-total <> 0 then do:
            if  item-contrat.log-control-event then
                assign de-total-val = de-total-val + input frame {&frame-name} evento-ped.val-realizado.
        end.
    end.

    /**Valida Contratos controlados por ordem p/
     nÆo ultrapassar saldo definido para a ordem **/
    if item-contrat.ind-tipo-control = 2 then do:
        if (input frame {&frame-name} evento-ped.qtd-realizada > de-total-qtd) or
           (input frame {&frame-name} evento-ped.val-realizado > de-total-val) then do:
            run utp/ut-msgs.p("show",7842,""). /* Total de eventos ultrapassa saldo da Ordem */
            apply 'entry' to evento-ped.qtd-realizada.
            undo,return "adm-error".
        end.
    end.

    if  sit-anterior = 2 and input frame {&frame-name} evento-ped.ind-sit-event <> 2 then do:
        assign l-erro-co = no.
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (evento-ped.qtd-realizada * (-1) *
                              integer(evento-ped.ind-sit-event = 3)),
                            input (evento-ped.val-realizado * (-1) *
                              integer(evento-ped.ind-sit-event = 3)),
                            input (evento-ped.qtd-realizada * (-1) *
                              integer(evento-ped.ind-sit-event <> 3)),
                            input (evento-ped.val-realizado * (-1) *
                              integer(evento-ped.ind-sit-event <> 3)),
                            input 0,
                            input 0,
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro).

        find first tt-erro no-lock no-error.
        if  avail tt-erro then
            run cdp/cd0666.w (input table tt-erro).
        /*if  l-erro-co then
            return "adm-error".*/
    end.

    if  sit-anterior = 1 and evento-ped.ind-sit-event = 3 then do:
        assign l-erro-co = no.
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (evento-ped.qtd-realizada * (-1)),
                            input (evento-ped.val-realizado * (-1)),
                            input (de-qtd-medicao * (-1) *
                               integer(evento-ped.log-liber-autom)),
                            input (de-val-realizado * (-1) *
                               integer(evento-ped.log-liber-autom)),
                            input 0,
                            input 0,
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro).
        find first tt-erro no-lock no-error.
        if  avail tt-erro then
            run cdp/cd0666.w (input table tt-erro).
        /*if  l-erro-co then
            return "adm-error". */
    end.

    /** Altera‡Æo para integra‡Æo com a Paradigma - Jucinei */
    IF l-log-portal-paradigma THEN DO:
        RUN ccp/ccapi342.p (INPUT  "evento-ped":U,
                            INPUT  ROWID(evento-ped),
                            OUTPUT TABLE RowErrors).

        FIND FIRST tt-erro NO-LOCK NO-ERROR.
        IF AVAIL tt-erro THEN
            run cdp/cd0666.w (INPUT TABLE RowErrors).
    END.

    assign i-num-seq-medicao = 0
           de-val-realizado  = 0.

    if  de-val-realizado <> 0 or
        de-perc-medicao  <> 0 or
        de-qtd-medicao   <> 0 then do:
        assign evento-ped.val-realizado   = de-val-realizado
               evento-ped.perc-lib-realiz = de-perc-medicao
               evento-ped.qtd-realizada   = de-qtd-medicao.
    end.

end.

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
 if RETURN-VALUE = 'ADM-ERROR':U then
    RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */
  /* Code placed here will execute AFTER standard behavior.    */

&if defined(bf_mat_contratos) &then
    if  avail evento-ped
        and param-global.modulo-mp
        and evento-ped.nr-contrato <> 0 then do:
        run ccp/ccapi200.p(input "evento-ped":U, input rowid(evento-ped),
                           input 2, input-output table tt-erro).
    end.
&endif

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

  if adm-new-record = yes then
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

{utp/ut-liter.i Evento *}
assign v-dt-evento = return-value.

{utp/ut-field.i mgind evento-ped dt-real 1}
assign v-dt-real = return-value.

assign de-total-qtd  = 0
       de-total-val  = 0
       rw-evento-ped = gr-evento-ped.

find evento-ped where rowid(evento-ped) = rw-evento-ped exclusive-lock no-error.
if avail evento-ped then do:
    assign evento-ped.ind-sit-event:sensitive in frame {&frame-name} = yes
           evento-ped.dat-realiz:sensitive in frame {&frame-name} = yes.
    if  evento-ped.dat-realiz = ? then
        assign evento-ped.dat-realiz:screen-value in frame {&frame-name} = string(today).

    disp evento-ped.ind-sit-event
         evento-ped.dat-realiz
         evento-ped.dt-evento
         evento-ped.cod-cond-pag
         evento-ped.ind-dest-event
         evento-ped.val-previsto
         evento-ped.val-realizado
         evento-ped.perc-lib-previst
         evento-ped.perc-lib-realizado
         evento-ped.qtd-prevista
         evento-ped.qtd-realizada with frame {&frame-name}.

    if  evento-ped.ind-sit-event <> 2 and
        &if defined(bf_mat_contratos) &then
        evento-ped.nr-contrato <> 0 then
        &else
        evento-ped.nr-contrato <> "" then
        &endif
        disp evento-ped.dat-prev-event @ evento-ped.dat-realiz with frame {&frame-name}.

    assign evento-ped.ind-sit-event:sensitive in frame {&frame-name} = evento-ped.ind-sit-event <> 2.

    find contrato-for where contrato-for.nr-contrato = evento-ped.nr-contrato no-lock no-error.

    assign de-total-qtd = 0
           de-total-val = 0.

    for each b-evento-ped where b-evento-ped.nr-contrato   = evento-ped.nr-contrato
                            and b-evento-ped.num-seq-item  = evento-ped.num-seq-item
                            and b-evento-ped.numero-ordem  = evento-ped.numero-ordem
                            and b-evento-ped.seq-evento    = evento-ped.seq-evento
                          NO-LOCK:
        assign de-total-qtd = de-total-qtd + evento-ped.qtd-prevista
               de-total-val = de-total-val + evento-ped.val-previsto.
    end.
    find b-evento-ped where rowid(b-evento-ped)= rw-evento-ped no-lock no-error.
    if  avail b-evento-ped then
        assign sit-anterior = b-evento-ped.ind-sit-event.

    &if defined(bf_mat_contratos) &then
    if evento-ped.nr-contrato <> 0 then do:
    &else
    if evento-ped.nr-contrato <> "" then do:
    &endif
        find item-contrat where item-contrat.num-seq-item   = evento-ped.num-seq-item
                                and item-contrat.nr-contrato = evento-ped.nr-contrato
                                no-lock no-error.
        if  avail item-contrat then do:
            assign de-qtd-medicao-t  = 0
                   de-val-medicao-t  = 0
                   de-perc-medicao-t = 0.
            for each medicao-contrat
                where medicao-contrat.nr-contrato   = item-contrat.nr-contrato
                and   medicao-contrat.num-seq-item  = item-contrat.num-seq-item
                and   medicao-contrat.num-seq-event = evento-ped.seq-evento
                no-lock:
                assign de-qtd-medicao-t  = de-qtd-medicao-t  + medicao-contrat.qtd-medicao
                       de-val-medicao-t  = de-val-medicao-t  + medicao-contrat.val-medicao
                       de-perc-medicao-t = de-perc-medicao-t + medicao-contrat.perc-medicao.
            end.

            if  de-qtd-medicao-t  <> 0
            and de-val-medicao-t  <> 0
            and de-perc-medicao-t <> 0 then
            assign evento-ped.qtd-realizada:screen-value in frame {&frame-name}      = string(de-qtd-medicao-t)
                   evento-ped.val-realizado:screen-value in frame {&frame-name}      = string(de-val-medicao-t)
                   evento-ped.perc-lib-realizado:screen-value in frame {&frame-name} = string(de-perc-medicao-t).
            if  item-contrat.ind-tipo-control-val = 1 then do:
                if  item-contrat.ind-un-contrato = 1 or item-contrat.qtd-total = 0 then
                    assign evento-ped.qtd-realizada:sensitive in frame {&frame-name} = yes.
                if  item-contrat.ind-un-contrato = 2 and item-contrat.qtd-total > 0 then
                    assign evento-ped.perc-lib-realizado:sensitive in frame {&frame-name} = yes.
            end.
            if  item-contrat.ind-tipo-control-val = 2 then do:
                if  item-contrat.ind-un-contrato = 1 or
                    item-contrat.qtd-total = 0 then
                    assign evento-ped.qtd-realizada:sensitive in frame {&frame-name} = yes.
                else
                if  item-contrat.ind-un-contrato = 2 and item-contrat.qtd-total > 0 then
                    assign evento-ped.perc-lib-realizado:sensitive in frame {&frame-name} = yes.
            end.
            if  item-contrat.ind-tipo-control-val = 3 then do:
                if  item-contrat.ind-un-contrato = 1 or item-contrat.val-total = 0 then
                    assign evento-ped.val-realizado:sensitive in frame {&frame-name} = yes.
                if  item-contrat.ind-un-contrato = 2 and item-contrat.qtd-total > 0 then
                    assign evento-ped.perc-lib-realizado:sensitive in frame {&frame-name} = yes.
            end.
        end.
    end.
end.

ASSIGN l-hab-val-realizado = evento-ped.val-realizado:SENSITIVE IN FRAME {&FRAME-NAME}.

APPLY "value-changed":U TO evento-ped.ind-sit-event.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave V-table-Win
PROCEDURE pi-leave :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

if  avail item-contrat then do with frame {&frame-name}:

    /* Qtd/Pre‡o fixo */
    if  item-contrat.ind-tipo-control-val = 1 then do:
        if  item-contrat.ind-un-contrato = 1 or item-contrat.qtd-total = 0 then do:
            assign evento-ped.val-realizado:screen-value = string((input evento-ped.qtd-realizada
                                                         * item-contrat.pre-unit-for)).
            if  item-contrat.qtd-total > 0 then
                assign evento-ped.perc-lib-realizado:screen-value = string((input frame {&frame-name} evento-ped.qtd-realizada
                                                                  * 100 / item-contrat.qtd-total)).
            else
                assign evento-ped.perc-lib-realizado:screen-value = "100".
        end.
        else
        if  item-contrat.ind-un-contrato = 2 and
            item-contrat.qtd-total > 0 then do:
            assign evento-ped.qtd-realizada:screen-value = string(((input evento-ped.perc-lib-realizado
                                                         * item-contrat.qtd-total) / 100)).
            assign evento-ped.val-realizado:screen-value = string((input evento-ped.qtd-realizada
                                                         * item-contrat.pre-unit-for)).
        end.
    end.

    /* Qtd aberta/pre‡o fixo */
    if  item-contrat.ind-tipo-control-val = 2 then do:
        if  item-contrat.ind-un-contrato = 1 or item-contrat.qtd-total = 0 then do:
            assign evento-ped.val-realizado:screen-value = string((input evento-ped.qtd-realizada
                                                         * item-contrat.pre-unit-for)).
            if  item-contrat.qtd-total > 0 then
                assign evento-ped.perc-lib-realizado:screen-value = string((input evento-ped.qtd-realizada
                                                                  * 100 / item-contrat.qtd-total)).
            else
                assign evento-ped.perc-lib-realizado:screen-value = "100".
        end.
        else
        if  item-contrat.ind-un-contrato = 2 AND item-contrat.qtd-total > 0 then do:
            assign evento-ped.qtd-realizada:screen-value = string(((input evento-ped.perc-lib-realizado
                                                         * item-contrat.qtd-total) / 100)).
            assign evento-ped.val-realizado:screen-value = string((input evento-ped.qtd-realizada
                                                         * item-contrat.pre-unit-for)).
        end.
    end.

    /* Limite Custo */
    if  item-contrat.ind-tipo-control-val = 3 then do:
        if  item-contrat.ind-un-contrato = 1 or item-contrat.qtd-total = 0 then do:
            assign evento-ped.qtd-realizada:screen-value = string(input evento-ped.val-realizado
                                                         / item-contrat.pre-unit-for).
            if  item-contrat.qtd-total > 0 then
                assign evento-ped.perc-lib-realizado:screen-value = string((input frame {&frame-name} evento-ped.qtd-realizada
                                                                  * 100 / item-contrat.qtd-total)).
            else
                assign evento-ped.perc-lib-realizado:screen-value = "100".
        end.
        else
        if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0 then do:
            assign evento-ped.val-realizado:screen-value = string ((input frame {&frame-name} evento-ped.perc-lib-realizado
                                                         * item-contrat.val-total) / 100).
            assign evento-ped.qtd-realizada:screen-value = string(evento-ped.val-realizado
                                                         / item-contrat.pre-unit-for).
        end.
    end.

    if  not avail ordem-compra and avail evento-ped then
        find ordem-compra where ordem-compra.numero-ordem = evento-ped.numero-ordem
            no-lock no-error.
    if  avail ordem-compra then do:
        assign evento-ped.val-previsto:screen-value = string(fn_vld_ajust_dec(input (input evento-ped.val-previsto),input ordem-compra.mo-codigo)).
        assign evento-ped.val-realizado:screen-value = string(fn_vld_ajust_dec(input (input evento-ped.val-realizado),input ordem-compra.mo-codigo)).
    end.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "evento-ped"}

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

