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
{include/i-prgvrs.i V16IN112 2.00.00.039 } /*** "010039" 09/04/2026 11:06:25 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v16in112 MUT}
&ENDIF

{include/i_fncrowid.i}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
{cdp/cdcfgmat.i}

{cdp/cd0666.i} /* Definiá∆o da tt-erro */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def new global shared var gr-it-codigo   like evento-ped.it-codigo  no-undo.

def var c-contrato      like evento-ped.nr-contrat     no-undo.
def var i-num-seq-item  like evento-ped.num-seq-item   no-undo.
def var l-contrato        as logical                   no-undo.
def var h_v15in112        as handle                    no-undo.

def var i-cd-freq      as integer format ">>9".
def var i-num-periodos as integer.
def var l-cancela      as logical init yes.
def var da-data-prev   like evento-ped.dat-prev-entr.
def var c-opcao        as char.
def var i-cont         as integer init 1.
def var l-confirma     as logical.
def var i-prox-ent     as integer.
def var i-num-seq-event as integer.
def var l-erro-co      as logical.
def var l-msg-tela     as logical.
def var i-destino      as integer initial 1.

def var i-seq-ordem           as   integer format "99".
def var i-sequencia           as   integer format "99".
def var i-ordem               like evento-ped.numero-ordem.
def var i-ordem-ini           like evento-ped.numero-ordem.
def var i-ordem-fim           like evento-ped.numero-ordem.
def var c-event-codigo        like evento-ped.seq-evento.
def var c-event-desc          like evento-ped.des-event.
def var de-valor-conver       as dec format "->>>>,>>>,>>9.9999".
def var de-variacao-qtd       like evento-ped.qtd-prevista.
def var de-variacao-val       like evento-ped.val-previsto.
def var de-total-qtd          as dec format "->>>>,>>>,>>9.9999".
def var de-qtd-ordem          like de-total-qtd.
def var de-total-val          like evento-ped.val-previsto.
def var de-val-ordem          like de-total-val.
def var de-val-anterior       like evento-ped.val-realizado.
def var de-qtd-anterior       like evento-ped.qtd-realizada.
def var c-desc-1              as   character format "x(38)".
def var c-desc-2              as   character format "x(38)".
def var i-conta               as   integer   no-undo.
def var i-total-perc          as   integer   no-undo.
def var i-conta-a             as   integer   no-undo.
def var r-registro-2          as &IF {&ROWID_READY} = YES &THEN 
                                    ROWID
                                 &ELSE 
                                    RECID initial ?
                                 &ENDIF.
def var da-dt-ini             as   date label "Data Inical" format "99/99/9999".
def var i-num-seq-medicao     like medicao-contrat.num-seq-medicao. 
def var de-val-realizado      like evento-ped.val-realizado.
def var de-qtd-medicao        like medicao-contrat.qtd-medicao.
def var de-perc-medicao       like medicao-contrat.perc-medicao.
def var de-val-medicao        like medicao-contrat.val-medicao.
def var sit-anterior        like evento-ped.ind-sit-event.
def var c-nr-contrato like evento-ped.nr-contrato no-undo.

def var l-message1            as logical init no no-undo.
def var l-message2            as logical init no no-undo.

def buffer b-evento-ped for evento-ped.
def buffer b1-evento-ped for evento-ped.

def new global shared temp-table t-entrega
   field cod-freq        like frequencia.cd-freq /*cod. da frequencia de */
   field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
   field dat-entrega    as date.

def new shared var c-cod-estabel like estabelec.cod-estabel.

{cep/ce1234.i}  /* Validaá∆o Decimais */

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
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS evento-ped.log-liber-autom ~
evento-ped.log-antecip-gerad evento-ped.log-1 
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-define DISPLAYED-TABLES evento-ped
&Scoped-define FIRST-DISPLAYED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.log-antecip-gerad ~
evento-ped.log-1 
&Scoped-Define DISPLAYED-OBJECTS i-cod-tipo-contr c-tipo da-dat-prev-entr ~
cb-destino fi-perc-lib-previst fi-val-previsto fi-qtd-prevista 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS i-cod-tipo-contr da-dat-prev-entr ~
cb-destino fi-perc-lib-previst evento-ped.log-liber-autom fi-val-previsto ~
fi-qtd-prevista 
&Scoped-define ADM-MODIFY-FIELDS da-dat-prev-entr cb-destino 

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
DEFINE VARIABLE cb-destino AS CHARACTER FORMAT "X(256)":U INITIAL "Recebimento" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE da-dat-prev-entr AS DATE FORMAT "99/99/9999":U 
     LABEL "Previs∆o Entreg" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-lib-previst AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-qtd-prevista AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R23 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .88.

DEFINE VARIABLE fi-val-previsto AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .88.

DEFINE VARIABLE i-cod-tipo-contr AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Tipo Contrato" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 5.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-tipo-contr AT ROW 1.33 COL 23 COLON-ALIGNED HELP
          "Tipo de Contrato"
     c-tipo AT ROW 1.33 COL 32.14 COLON-ALIGNED NO-LABEL
     da-dat-prev-entr AT ROW 2.33 COL 23 COLON-ALIGNED
     cb-destino AT ROW 2.33 COL 57.86 COLON-ALIGNED
     fi-perc-lib-previst AT ROW 3.33 COL 23 COLON-ALIGNED
     evento-ped.log-liber-autom AT ROW 3.5 COL 59.86
          LABEL "Libera Mediá‰es Parciais":L16
          VIEW-AS TOGGLE-BOX
          SIZE 23.86 BY .83
     fi-val-previsto AT ROW 4.33 COL 23 COLON-ALIGNED
     evento-ped.log-antecip-gerad AT ROW 4.5 COL 59.86
          LABEL "Antecipaá∆o Gerada":L23
          VIEW-AS TOGGLE-BOX
          SIZE 25.43 BY .83
     fi-qtd-prevista AT ROW 5.33 COL 23 COLON-ALIGNED
     evento-ped.log-1 AT ROW 6 COL 84.43
          VIEW-AS TOGGLE-BOX
          SIZE 1.43 BY .5
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 5.88
         WIDTH              = 86.43.
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
ASSIGN        FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-destino IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-dat-prev-entr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-perc-lib-previst IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-qtd-prevista IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-val-previsto IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-cod-tipo-contr IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN        evento-ped.log-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX evento-ped.log-antecip-gerad IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX evento-ped.log-liber-autom IN FRAME f-main
   NO-DISPLAY 2 EXP-LABEL                                               */
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

&Scoped-define SELF-NAME cb-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-destino V-table-Win
ON VALUE-CHANGED OF cb-destino IN FRAME f-main
DO:
  if cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 1} then
     assign i-destino = 1.
  if cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 2} then
     assign i-destino = 2.

  /* Engenharia Geracao Antecipacao Base Evento Compra */
  IF  i-destino = 2 /* Antecipacao */ THEN
      ASSIGN log-antecip-gerad:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  ELSE
      ASSIGN log-antecip-gerad:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-perc-lib-previst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-perc-lib-previst V-table-Win
ON LEAVE OF fi-perc-lib-previst IN FRAME f-main
DO:
   run pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-prevista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-prevista V-table-Win
ON LEAVE OF fi-qtd-prevista IN FRAME f-main
DO:

    run pi-leave.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-val-previsto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-val-previsto V-table-Win
ON LEAVE OF fi-val-previsto IN FRAME f-main
DO:
    run pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-tipo-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON F5 OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in576.w
                   &campo=i-cod-tipo-contr
                   &campozoom=cod-tipo-contr}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON LEAVE OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
{include/leave.i &tabela=tipo-contrat  
                 &atributo-ref=des-tipo-contrat
                 &variavel-ref=c-tipo
                 &where="tipo-contrat.cod-tipo-contr =
                         input frame {&frame-name} i-cod-tipo-contr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
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

{utp/ut-liter.i Modalidade * R }
assign i-cod-tipo-contr:label in frame {&frame-name} = trim(return-value).

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

    assign da-dat-prev-entr:screen-value in frame {&frame-name} = string(today).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
for each tt-erro:
    delete tt-erro.
end.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    if  l-contrato and not adm-new-record 
        then do with frame {&frame-name}:
        assign de-qtd-anterior = evento-ped.qtd-realizada
               de-val-anterior = evento-ped.val-realizado.
    end.
    find  ordem-compra where ordem-compra.numero-ordem = i-ordem no-lock no-error.

    if  l-contrato and 
        avail ordem-compra then do:
        assign l-rejeita-dec  = no.
        assign fi-val-previsto:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} fi-val-previsto,ordem-compra.mo-codigo)).
        if  l-rejeita-dec then do:
            {utp/ut-field.i mgind evento-ped val-previsto 1}
            run utp/ut-msgs.p("show",18130,trim(return-value)).
            apply 'entry':U to fi-val-previsto in frame {&frame-name}.
            return "ADM-ERROR":U.
        end.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

if  l-contrato then do with frame {&frame-name}:
    if  input frame {&frame-name} fi-qtd-prevista = 0  then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Qtd_Prevista" *}
        run utp/ut-msgs.p (input "show",
                           input 265  ,
                           input RETURN-VALUE ).
       apply 'entry' to fi-qtd-prevista in frame {&frame-name}.
        return "adm-error".
    end.

    if  input frame {&frame-name} fi-val-previsto = 0  then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor_Previsto" *}
        run utp/ut-msgs.p (input "show",
                           input 265  ,
                           input RETURN-VALUE).
         apply 'entry' to fi-val-previsto in frame {&frame-name}.
        return "adm-error".
    end.

    IF item-contrat.qtd-total <= 0 AND item-contrat.val-total <= 0 THEN DO:
        if  input frame {&frame-name} fi-perc-lib-previst = 0  then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Percentual" *}
            run utp/ut-msgs.p (input "show",
                               input 265  ,
                               input RETURN-VALUE    ).
             apply 'entry' to fi-perc-lib-previst in frame {&frame-name}.
            return "adm-error".
        end.
    END.

    assign evento-ped.perc-lib-previst   = input fi-perc-lib-previst 
           evento-ped.perc-lib-realizado = input fi-perc-lib-previst 
           evento-ped.val-previsto       = input fi-val-previsto
           evento-ped.qtd-prevista       = input fi-qtd-prevista
           evento-ped.ind-dest-event     = i-destino
           evento-ped.dat-prev-entr      = input da-dat-prev-entr
           evento-ped.dat-prev-event     = evento-ped.dat-prev-entr
           evento-ped.val-realizado      = input fi-val-previsto
           evento-ped.qtd-realizada      = evento-ped.qtd-prevista
           /**** grava apenas no cd0541
           evento-ped.dat-realiz         = evento-ped.dat-nova-realiz
           *********/
           .

    find item-contrat where 
         item-contrat.nr-contrat   = evento-ped.nr-contrat and
         item-contrat.num-seq-item = evento-ped.num-seq-item no-lock no-error.
    if  avail item-contrat then do:
        l-erro-co = no.
        if  not adm-new-record then do: /* Modificacao*/
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input (evento-ped.qtd-realizada - de-qtd-anterior)
                                   * integer(item-contrat.ind-tipo-control <> 2),
                                input (evento-ped.val-realizado - de-val-anterior)
                                   * integer(item-contrat.ind-tipo-control <> 2),
                                input 0, 
                                input 0, 
                                input 0, 
                                input 0,
                                input c-cod-estabel,
                                output l-msg-tela,
                                output l-erro-co,
                                input-output table tt-erro).                                       
            find first tt-erro no-lock no-error. 
               if avail tt-erro then 
               run cdp/cd0666.w (input table tt-erro).                                          
            if l-erro-co then 
                undo, return "adm-error".
        end.
        else do: /* Inclusao */
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input evento-ped.qtd-prevista *
                                integer(item-contrat.ind-tipo-control <> 2),
                                input evento-ped.val-realizado *
                                integer(item-contrat.ind-tipo-control <> 2),
                                input 0, 
                                input 0, 
                                input 0, 
                                input 0,
                                input c-cod-estabel,
                                output l-msg-tela,
                                output l-erro-co,
                                input-output table tt-erro).                            
            find first tt-erro no-lock no-error. 
               if avail tt-erro then 
               run cdp/cd0666.w (input table tt-erro).                                         
            if  l-erro-co = yes then
                undo, return "adm-error".
        end.
    end.
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

    do with frame {&frame-name}:
    assign da-dat-prev-entr:sensitive           = no
           evento-ped.log-liber-autom:sensitive = no
           fi-perc-lib-previst:sensitive        = no
           fi-val-previsto:sensitive            = no
           fi-qtd-prevista:sensitive            = no
           cb-destino:sensitive                 = no.
    end.

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

    if  available evento-ped and
        adm-new-record = no  then
        do  with frame {&frame-name}:
        &if defined(bf_mat_contratos) &then
            if evento-ped.nr-contrat <> 0 then do:
        &else
            if evento-ped.nr-contrat <> "" then do:
        &endif
                assign cb-destino:hidden   = no
                       c-contrato          = evento-ped.nr-contrato
                       i-ordem             = evento-ped.numero-ordem
                       fi-perc-lib-previst = evento-ped.perc-lib-previst
                       fi-val-previsto     = evento-ped.val-previsto
                       fi-qtd-prevista     = evento-ped.qtd-prevista
                       da-dat-prev-entr    = evento-ped.dat-prev-entr.

                disp fi-perc-lib-previst
                     fi-val-previsto
                     fi-qtd-prevista
                     da-dat-prev-entr.

                if  evento-ped.ind-dest-event <> 0 then do:
                    assign cb-destino:screen-value = {varinc/var00066.i 04 evento-ped.ind-dest-event}
                           i-destino               = evento-ped.ind-dest-event.
                end.
                else do:
                    assign cb-destino:screen-value = {varinc/var00066.i 04 1}
                           i-destino               = 1.
                end.

                /* Engenharia Geracao Antecipacao Base Evento Compra */
                IF  evento-ped.ind-dest-event = 2 /* Antecipacao */ THEN DO:
                    ASSIGN  evento-ped.log-antecip-gerad:HIDDEN = NO.
                    DISPLAY evento-ped.log-antecip-gerad.
                END.
                ELSE
                    ASSIGN evento-ped.log-antecip-gerad:HIDDEN = YES.
            end.
            else do:
                disp 0 @ fi-perc-lib-previst 
                     0 @ fi-val-previsto
                     0 @ fi-qtd-prevista.

                ASSIGN cb-destino:HIDDEN        = YES
                       log-antecip-gerad:HIDDEN = YES.
            end.

            DISPLAY evento-ped.log-liber-autom WITH FRAME {&FRAME-NAME}.
        end.

    if  available evento-ped then
        do with frame {&frame-name}:
        &if defined(bf_mat_contratos) &then
            if evento-ped.nr-contrat <> 0 then do:
        &else
            if evento-ped.nr-contrat <> "" then do:
        &endif
                find contrato-for
                    where contrato-for.nr-contrato = c-contrato no-lock no-error.

                if  available contrato-for then do:
                    assign i-cod-tipo-contr = contrato-for.cod-tipo-contr.

                    find tipo-contrat
                        where tipo-contrat.cod-tipo-contr = i-cod-tipo-contr no-lock no-error.

                    if  available tipo-contrat then
                        assign c-tipo = tipo-contrat.des-tipo-contrat.
                end.
                else
                    assign i-cod-tipo-contr = 0
                           c-tipo = "".

                display i-cod-tipo-contr
                        c-tipo.
            end.
            else 
                disp 0  @ i-cod-tipo-contr
                     "" @ c-tipo .
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if  avail evento-ped and 
        not adm-new-record then do:
        &if defined(bf_mat_contratos) &then
        assign l-contrato                           = evento-ped.nr-contrat <> 0
        &else
        assign l-contrato                           = evento-ped.nr-contrat <> ""
        &endif
            da-dat-prev-entr:sensitive           = l-contrato
            evento-ped.log-liber-autom:sensitive = l-contrato
            fi-perc-lib-previst:sensitive        = l-contrato
            fi-val-previsto:sensitive            = l-contrato
            fi-qtd-prevista:sensitive            = l-contrato
            cb-destino:sensitive                 = l-contrato.

        find contrato-for where contrato-for.nr-contrato = evento-ped.nr-contrat
            no-lock no-error.

        find item-contrat where 
             item-contrat.nr-contrat   = evento-ped.nr-contrat and
             item-contrat.num-seq-item = evento-ped.num-seq-item no-lock no-error.

        run pi-leave.
    end.
    ELSE
        ASSIGN evento-ped.log-antecip-gerad:CHECKED IN FRAME {&FRAME-NAME} = NO.

    /* Engenharia Geracao Antecipacao Base Evento Compra */
    ASSIGN evento-ped.log-antecip-gerad:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {varinc/var00066.i 03}.
      RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
      ASSIGN  cb-destino:LIST-ITEM-PAIRS in frame {&frame-name}   = cAuxTraducao001.
  &else
      ASSIGN cb-destino:list-items in frame {&frame-name}   = {varinc/var00066.i 03}.
  &endif
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Libera_Mediá‰es_Parciais}
  assign evento-ped.log-liber-autom:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind evento-ped dat-prev-entr 1}
  assign da-dat-prev-entr:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind evento-ped perc-lib-previst 1}
  assign fi-perc-lib-previst:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind evento-ped val-previsto 1}
  assign fi-val-previsto:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind evento-ped qtd-prevista 1}
  assign fi-qtd-prevista:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind evento-ped ind-dest-event 1}
  assign cb-destino:label in frame {&frame-name} = return-value.

  assign cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 1}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados V-table-Win 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-contrato         like evento-ped.nr-contrato .
def input parameter p-cod-estabel      like evento-ped.cod-estabel .
def input parameter p-ordem            like evento-ped.numero-ordem .

find contrato-for where contrato-for.nr-contrato = p-contrato no-lock no-error.

if available contrato-for then do:
    assign i-cod-tipo-contr = contrato-for.cod-tipo-contr.
    find tipo-contrat where tipo-contrat.cod-tipo-contr = 
         input frame {&frame-name} i-cod-tipo-contr
         no-lock no-error.
    if available tipo-contrat then
       assign c-tipo = tipo-contrat.des-tipo-contrat.
    display i-cod-tipo-contr
            c-tipo with frame {&frame-name}.    
end.

/* Caso Controle por Evento e por Ordem */
find ordem-compra where ordem-compra.numero-ordem = p-ordem no-lock no-error.
if  avail ordem-compra then do:
    find item-contrat where
        item-contrat.nr-contrato = ordem-compra.nr-contrato and
        item-contrat.num-seq-item = ordem-compra.num-seq-item
        no-lock no-error.
    if  avail item-contrat then do:
        if  item-contrat.ind-tipo-control = 2 and
            item-contrat.log-control-event then do:
            assign de-qtd-ordem = 0.
            for each prazo-compra where 
                prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                assign de-qtd-ordem = de-qtd-ordem + prazo-compra.qtd-do-forn.
            end.
            if  de-qtd-ordem > 0 then
                assign de-val-ordem = de-qtd-ordem * ordem-compra.pre-unit-for.
            run pi-leave.
        end.
    end.
end.

assign c-contrato    = p-contrato
       c-cod-estabel = p-cod-estabel
       i-ordem       = p-ordem
       l-contrato    = avail contrato-for.

do with frame {&frame-name}:
    assign da-dat-prev-entr:sensitive           = l-contrato
           evento-ped.log-liber-autom:sensitive = l-contrato
           cb-destino:sensitive                 = l-contrato.

    /* Caso Controle por Evento e por Ordem este controle Ç feito na pi-leave */
    if  not (avail item-contrat and 
             item-contrat.ind-tipo-control = 2 and
             item-contrat.log-control-event )
    then 
ASSIGN            fi-perc-lib-previst:sensitive        = l-contrato and not (avail item-contrat and 
                                                  item-contrat.ind-tipo-control = 2 and
                                                  item-contrat.log-control-event )
           fi-val-previsto:sensitive            = l-contrato and not (avail item-contrat and 
                                                  item-contrat.ind-tipo-control = 2 and
                                                  item-contrat.log-control-event )
           fi-qtd-prevista:sensitive            = l-contrato and not (avail item-contrat and 
                                                  item-contrat.ind-tipo-control = 2 and
                                                  item-contrat.log-control-event ).
end.

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
if  avail item-contrat and 
    avail contrato-for then do with frame {&frame-name}:
    if adm-new-record = no then do:
        assign de-total-qtd = de-total-qtd - input fi-qtd-prevista
               de-total-val = de-total-val - input fi-val-previsto.
    end.
    if  item-contrat.ind-tipo-control = 1 then do:
        if item-contrat.qtd-total > 0 then
            assign de-variacao-qtd = item-contrat.qtd-total + 
                                    (item-contrat.qtd-total *
                                    (contrato-for.variacao-qtd / 100)).
        else assign de-variacao-qtd = 0.
        if item-contrat.val-total > 0 then
        assign de-variacao-val = item-contrat.val-total +
                                   (item-contrat.val-total *
                                   (contrato-for.variacao-preco / 100)).
        else assign de-variacao-val = 0.
    end.
    else do:
        assign de-variacao-qtd = de-qtd-ordem + (de-qtd-ordem *
              (if contrato-for.variacao-qtd > 0 
                then (contrato-for.variacao-qtd / 100 ) else 0)).
        assign de-variacao-val = de-val-ordem + (de-val-ordem *
              (if contrato-for.variacao-preco > 0 then
                  (contrato-for.variacao-preco / 100) else 0)).
    end.

    if  item-contrat.ind-tipo-control-val = 1 then do:
        if  item-contrat.ind-un-contrato = 1 or
           (de-qtd-ordem = 0 and item-contrat.qtd-total =  0) then do:
            assign fi-val-previsto:sensitive     = no
                   fi-perc-lib-previst:sensitive = no
                   fi-qtd-prevista:sensitive     = yes.
            assign fi-val-previsto:screen-value = string(input fi-qtd-prevista * item-contrat.pre-unit-for).
            if de-qtd-ordem > 0 then
                assign fi-perc-lib-previst:screen-value = IF (input fi-qtd-prevista * 100 / de-qtd-ordem) > 100 THEN string(100)
                                                              ELSE STRING(input fi-qtd-prevista * 100 / de-qtd-ordem).
            else if item-contrat.qtd-total > 0 then
                assign fi-perc-lib-previst:screen-value = string(input fi-qtd-prevista * 100 / item-contrat.qtd-total).
            else
                assign fi-perc-lib-previst:screen-value = string(100).
        end.
        else
        if  item-contrat.ind-un-contrato = 2 then  do:
            assign fi-val-previsto:sensitive     = no
                   fi-perc-lib-previst:sensitive = yes
                   fi-qtd-prevista:sensitive     = no.        

            if de-qtd-ordem > 0 then
                assign fi-qtd-prevista:screen-value = string(input fi-perc-lib-previst * (de-qtd-ordem / 100)).
            else if item-contrat.qtd-total > 0 then
                assign fi-qtd-prevista:screen-value = string(input fi-perc-lib-previst * (item-contrat.qtd-total / 100)).
            assign fi-val-previsto:screen-value = string(input fi-qtd-prevista * item-contrat.pre-unit-for).
        end. 
    end.

    if  item-contrat.ind-tipo-control-val = 2 then do:
        if  item-contrat.ind-un-contrato = 1 or 
            item-contrat.qtd-total = 0 then do:
            /* update fi-qtd-prevista with frame {&frame-name}. */
            assign fi-val-previsto:sensitive     = no
                   fi-perc-lib-previst:sensitive = no
                   fi-qtd-prevista:sensitive     = yes.            
            assign fi-val-previsto:screen-value = string (input fi-qtd-prevista
                    * item-contrat.pre-unit-for)
                   fi-perc-lib-previst:screen-value = string (if 
                      item-contrat.qtd-total > 0
                      then (input fi-qtd-prevista
                    * 100 / item-contrat.qtd-total) 
                   else 100).
        end.
        else
        if  item-contrat.ind-un-contrato = 2 then  do:
            /* update fi-perc-lib-previst  with frame {&frame-name}. */
            assign fi-val-previsto:sensitive     = no
                   fi-perc-lib-previst:sensitive = yes
                   fi-qtd-prevista:sensitive     = no.            
            assign fi-qtd-prevista:screen-value = string (input fi-perc-lib-previst *
                   if item-contrat.qtd-total > 0 then
                   (item-contrat.qtd-total / 100)
                   else 1).
            assign fi-val-previsto:screen-value = string (input fi-qtd-prevista * 
                                                  item-contrat.pre-unit-for).
        end. 
    end.
    if  item-contrat.ind-tipo-control-val = 3 then do: 
        if  item-contrat.ind-un-contrato = 1 or
            item-contrat.val-total <= 0 then do: 
            /* update evento-ped.val-previsto with frame {&frame-name}. */
            assign fi-val-previsto:sensitive     = yes
                   fi-perc-lib-previst:sensitive = no
                   fi-qtd-prevista:sensitive     = no.            
            assign fi-perc-lib-previst:screen-value = string (if item-contrat.val-total > 0 then   
                   ((input fi-val-previsto * 100) / item-contrat.val-total)
                   else 100). 
            assign fi-qtd-prevista:screen-value = string (input fi-val-previsto / 
                                                  item-contrat.pre-unit-for).
        end.

        if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0
        then do: 
            /* update fi-perc-lib-previst with frame {&frame-name}. */           
            assign fi-val-previsto:sensitive     = no
                   fi-perc-lib-previst:sensitive = yes
                   fi-qtd-prevista:sensitive     = no.
            assign fi-val-previsto:screen-value = string ((input fi-perc-lib-previst * 
                   item-contrat.val-total) / 100). 
            assign fi-qtd-prevista:screen-value = string (input fi-val-previsto /
                                                  item-contrat.pre-unit-for).
        end. 
    end.
end.


/** Permite modificar data do evento realizado **/
if  adm-new-record = no and
    avail evento-ped    and     
    evento-ped.ind-sit-event > 1
    then do:

    disable fi-perc-lib-previst
            fi-val-previsto
            fi-qtd-prevista with frame {&frame-name}.

end.

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
def input parameter p-handle as handle no-undo.

assign h_v15in112 = p-handle.


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
def input parameter p-num-seq-item like evento-ped.num-seq-item .

assign i-num-seq-item = p-num-seq-item.

find item-contrat where 
     item-contrat.num-seq-item = i-num-seq-item and 
     item-contrat.nr-contrat   = c-contrato no-lock no-error.
if avail item-contrat then do:
    find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat
        no-lock no-error.
    run pi-leave.
end.

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

if l-contrato then do:
    /* ------------ Validaá‰es Eventos para Contratos ------------ */

end.     /* Fim contratos */
else do: /* ------------ Validaá‰es Eventos para Compras ------------ */


end. /* Fim compras */

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

