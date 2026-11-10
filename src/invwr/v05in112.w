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
{include/i-prgvrs.i V05IN112 2.00.00.019} /*** "010019" 30/11/2023 16:03:26  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN112 MUT}
&ENDIF

{include/i_fncrowid.i}

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

{cdp/cd0666.i} /* defini‡Æo da tt-erro */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

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
def var l-realizado           as   logical initial no no-undo.
def var i-total-perc          as   integer   no-undo.
def var i-conta-a             as   integer   no-undo.
def var r-registro-2          as &IF {&ROWID_READY} = YES &THEN
                                    ROWID
                                 &ELSE
                                    RECID initial ?
                                 &ENDIF.
def var da-dt-ini             as   date label "Data Inical" format "99/99/9999".
def var l-message1            as   logical.
def var l-message2            as   logical.

def var c-nr-contrato like evento-ped.nr-contrato no-undo.
def var i-num-seq-item as integer no-undo.

def new shared var c-cod-estabel like estabelec.cod-estabel.

def buffer b-evento-ped for evento-ped.
def buffer b1-evento-ped for evento-ped.

def new global shared temp-table t-entrega
   field cod-freq        like frequencia.cd-freq /*cod. da frequencia de */
   field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
   field dat-entrega    as date.

def var h_v01in579 as handle no-undo.

def var de-perc-lib-previst as decimal no-undo.
def var de-val-previsto     as decimal no-undo.
def var de-qtd-prevista     as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS evento-ped.des-event evento-ped.dat-prev-entr ~
evento-ped.cod-cond-pag evento-ped.log-liber-autom 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}des-event ~{&FP2}des-event ~{&FP3}~
 ~{&FP1}dat-prev-entr ~{&FP2}dat-prev-entr ~{&FP3}~
 ~{&FP1}cod-cond-pag ~{&FP2}cod-cond-pag ~{&FP3}
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.des-event ~
evento-ped.dat-prev-entr evento-ped.cod-cond-pag evento-ped.log-liber-autom 
&Scoped-Define DISPLAYED-OBJECTS cb-destino fi-perc-lib-previst ~
fi-val-previsto fi-qtd-prevista 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-destino fi-perc-lib-previst ~
fi-val-previsto fi-qtd-prevista 
&Scoped-define ADM-ASSIGN-FIELDS cb-destino fi-perc-lib-previst ~
fi-val-previsto fi-qtd-prevista 
&Scoped-define ADM-MODIFY-FIELDS cb-destino 

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
     LIST-ITEMS "Recebimento","Antecipa‡Æo" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-perc-lib-previst AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-qtd-prevista AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R23 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .88.

DEFINE VARIABLE fi-val-previsto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     evento-ped.des-event AT ROW 1.25 COL 1.43
          VIEW-AS FILL-IN 
          SIZE 72 BY .88
     evento-ped.dat-prev-entr AT ROW 2.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     cb-destino AT ROW 2.25 COL 60 COLON-ALIGNED
     evento-ped.cod-cond-pag AT ROW 3.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-perc-lib-previst AT ROW 3.33 COL 60.14 COLON-ALIGNED
     fi-val-previsto AT ROW 4.33 COL 60.14 COLON-ALIGNED
     evento-ped.log-liber-autom AT ROW 4.5 COL 25
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .83
     fi-qtd-prevista AT ROW 5.33 COL 60.14 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.evento-ped
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
         HEIGHT             = 5.58
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

/* SETTINGS FOR COMBO-BOX cb-destino IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN evento-ped.des-event IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-perc-lib-previst IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-qtd-prevista IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-val-previsto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME cb-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-destino V-table-Win
ON VALUE-CHANGED OF cb-destino IN FRAME f-main
DO:
  if cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 1} then
     assign i-destino = 1.
  if cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 2} then
     assign i-destino = 2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-cond-pag V-table-Win
ON F5 OF evento-ped.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=evento-ped.cod-cond-pag
                     &campozoom=cod-cond-pag}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-cond-pag V-table-Win
ON LEAVE OF evento-ped.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  
  find cond-pagto where cond-pagto.cod-cond-pag = 
        input frame {&frame-name} evento-ped.cod-cond-pag no-lock no-error.
  
 /* Condi‡Æo de Pagamento nÆo esta cadastrada */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  apply "F5" to self.
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
  /*/* if c-opcao = "Inclui" or c-opcao = "Modifica" or i-cont = 1 then do: */
 * /*   if c-opcao = "Modifica" then do: */
 * 
 *    if avail item-contrat then do with frame {&frame-name}:
 *    if adm-new-record = no then do:
 *       assign de-total-qtd = de-total-qtd - fi-qtd-prevista
 *              de-total-val = de-total-val - fi-val-previsto.
 *    end.
 *    if item-contrat.ind-tipo-control = 1 then do:
 *       if item-contrat.qtd-total > 0 then
 *          assign de-variacao-qtd = item-contrat.qtd-total + 
 *                                  (item-contrat.qtd-total *
 *                                  (contrato-for.variacao-qtd / 100)).
 *       else assign de-variacao-qtd = 0.
 *       if item-contrat.val-total > 0 then
 *          assign de-variacao-val = item-contrat.val-total +
 *                                  (item-contrat.val-total *
 *                                  (contrato-for.variacao-preco / 100)).
 *       else assign de-variacao-val = 0.
 *    end.
 *    else do:
 *           assign de-variacao-qtd = de-qtd-ordem + (de-qtd-ordem *
 *                 (if contrato-for.variacao-qtd > 0 
 *                   then (contrato-for.variacao-qtd / 100 ) else 0)).
 *           assign de-variacao-val = de-val-ordem + (de-val-ordem *
 *                 (if contrato-for.variacao-preco > 0 then
 *                     (contrato-for.variacao-preco / 100) else 0)).
 *    end.
 *    
 *    if  item-contrat.ind-tipo-control-val = 1 then do:
 *        if  item-contrat.ind-un-contrato = 1 or
 *            (de-qtd-ordem = 0 and item-contrat.qtd-total =  0) then do:
 * 
 *            /* update fi-qtd-prevista with frame {&frame-name}. */
 *            
 *            assign fi-qtd-prevista =
 *                   input frame {&frame-name} fi-qtd-prevista.
 *            assign fi-val-previsto = (input frame {&frame-name}
 *                   fi-qtd-prevista * item-contrat.pre-unit-for).
 * 
 *            assign fi-perc-lib-previst = if de-qtd-ordem > 0 then
 *                     (input frame {&frame-name} fi-qtd-prevista * 100 /
 *                      de-qtd-ordem) 
 *                   else if item-contrat.qtd-total > 0 then
 *                     (input frame {&frame-name} fi-qtd-prevista * 100 /
 *                      item-contrat.qtd-total) 
 *                   else 100.
 *            disp fi-val-previsto 
 *                 fi-perc-lib-previst with frame {&frame-name}.
 *        end.
 *        else
 *        if  item-contrat.ind-un-contrato = 2 then  do:
 *            /* update fi-perc-lib-previst  with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 * 
 *            assign fi-qtd-prevista = 
 *                  input frame {&frame-name} fi-perc-lib-previst *
 *                  if de-qtd-ordem > 0 then
 *                     (de-qtd-ordem / 100) 
 *                  else if item-contrat.qtd-total > 0 then
 *                     (item-contrat.qtd-total / 100)
 *                   else 1.
 *            assign fi-val-previsto = fi-qtd-prevista * 
 *                                                 item-contrat.pre-unit-for.
 *            disp  fi-qtd-prevista
 *                  fi-val-previsto
 *                  with frame {&frame-name}. pause 0.
 *        end. 
 *    end.
 * 
 *    if  item-contrat.ind-tipo-control-val = 2 then do:
 *        if  item-contrat.ind-un-contrato = 1 or 
 *            item-contrat.qtd-total = 0 then do:
 *            /* update fi-qtd-prevista with frame {&frame-name}. */
 *            assign fi-qtd-prevista =
 *                   input frame {&frame-name} fi-qtd-prevista.
 *                                                                                
 *            assign fi-val-previsto =
 *                     (input frame {&frame-name} fi-qtd-prevista
 *                    * item-contrat.pre-unit-for)
 *                   fi-perc-lib-previst = if 
 *                      item-contrat.qtd-total > 0
 *                      then (input frame {&frame-name} fi-qtd-prevista
 *                    * 100 / item-contrat.qtd-total) 
 *                   else 100.
 *            disp fi-val-previsto
 *                 fi-perc-lib-previst
 *                 with frame {&frame-name}. pause 0.
 *        end.
 *        else
 *        if  item-contrat.ind-un-contrato = 2 then  do:
 *            /* update fi-perc-lib-previst  with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 * 
 *            assign fi-qtd-prevista = 
 *                  input frame {&frame-name} fi-perc-lib-previst *
 *                   if item-contrat.qtd-total > 0 then
 *                   (item-contrat.qtd-total / 100)
 *                   else 1.
 *            assign fi-val-previsto = fi-qtd-prevista * 
 *                                                 item-contrat.pre-unit-for.
 *            disp  fi-qtd-prevista
 *                  fi-val-previsto
 *                  with frame {&frame-name}. pause 0.
 *        end. 
 *    end.
 *    if  item-contrat.ind-tipo-control-val = 3 then do: 
 *        if  item-contrat.ind-un-contrato = 1 or
 *            item-contrat.val-total <= 0 then do: 
 *            /* update fi-val-previsto with frame {&frame-name}. */
 *            assign fi-val-previsto =
 *                   input frame {&frame-name} fi-val-previsto.
 *            
 *            assign fi-perc-lib-previst = 
 *                   if item-contrat.val-total > 0 then   
 *                   ((input frame {&frame-name}
 *                     fi-val-previsto * 100) / item-contrat.val-total)
 *                   else 100. 
 *            assign fi-qtd-prevista = input frame {&frame-name}
 *                   fi-val-previsto / item-contrat.pre-unit-for.
 *            disp fi-perc-lib-previst
 *                 fi-qtd-prevista with frame {&frame-name}.
 *            pause 0.
 *        end.
 * 
 *        if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0
 *        then do: 
 *            /* update fi-perc-lib-previst with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 *            
 *            assign fi-val-previsto = (input frame {&frame-name} 
 *                   fi-perc-lib-previst * item-contrat.val-total) /
 *                   100. 
 *            assign fi-qtd-prevista = fi-val-previsto /
 *                                                 item-contrat.pre-unit-for.
 *            disp fi-qtd-prevista
 *                 fi-val-previsto with frame {&frame-name}.
 *                 pause 0.
 *        end. 
 *    end.
 * 
 * assign l-message1 = no
 *        l-message2 = no.
 * if  (item-contrat.ind-tipo-control-val = 1 or
 *      item-contrat.ind-tipo-control-val = 2) and
 *     (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
 *     if  item-contrat.ind-tipo-control = 1 then do:
 *         if de-variacao-qtd > 0 and
 *            input frame {&frame-name} 
 *            fi-qtd-prevista + de-total-qtd >
 *            de-variacao-qtd then 
 *            assign l-message1 = yes.
 *         else
 *         if de-variacao-val > 0 and
 *            input frame {&frame-name} 
 *            fi-val-previsto + de-total-val >
 *            de-variacao-val then
 *            assign l-message2 = yes.
 *     end.
 *     else do:
 *          if de-variacao-qtd > 0 and
 *             input frame {&frame-name} 
 *             fi-qtd-prevista + de-total-qtd > de-variacao-qtd then
 *             assign l-message1 = yes.
 *          else
 *          if de-variacao-val > 0 and
 *             input frame {&frame-name} 
 *             fi-val-previsto + de-total-val >
 *             de-variacao-val then 
 *             assign l-message2 = yes.
 *     end.
 * end.
 * else 
 *    if item-contrat.ind-tipo-control-val = 3 and
 *      (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
 *      if de-variacao-val > 0 and
 *         fi-val-previsto + item-contrat.sld-val-liber >
 *         de-variacao-val then
 *         assign l-message2 = yes.
 *      else
 *      if de-variacao-qtd > 0 and
 *         fi-qtd-prevista + item-contrat.sld-qtd-liber >
 *         de-variacao-qtd then
 *         assign l-message1 = yes.
 * end.
 * 
 * if l-message1 then do:
 *    run utp/ut-msgs.p (input "show" ,
 *                       input 8403   ,
 *                       input "" ).
 *    /* Quantidade ultrapassa saldo disponivel no Contrato. */
 *    return no-apply.
 * end.
 * 
 * if l-message2 then do:
 *    run utp/ut-msgs.p (input "show" ,
 *                       input 8404   ,
 *                       input "" ).
 *    /* Valor ultrapassa saldo disponivel no Contrato. */
 *    return no-apply.
 * end.
 * 
 * assign de-total-val = de-total-val + input frame {&frame-name}
 *        fi-val-previsto.
 *        de-total-qtd = de-total-qtd + input frame {&frame-name}
 *        fi-qtd-prevista.
 *        
 * end.       */
 run pi-leave.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-val-previsto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-val-previsto V-table-Win
ON LEAVE OF fi-val-previsto IN FRAME f-main
DO:
   /*if avail item-contrat then do with frame {&frame-name}:
 *    if adm-new-record = no then do:
 *       assign de-total-qtd = de-total-qtd - fi-qtd-prevista
 *              de-total-val = de-total-val - fi-val-previsto.
 *    end.
 *    if item-contrat.ind-tipo-control = 1 then do:
 *       if item-contrat.qtd-total > 0 then
 *          assign de-variacao-qtd = item-contrat.qtd-total + 
 *                                  (item-contrat.qtd-total *
 *                                  (contrato-for.variacao-qtd / 100)).
 *       else assign de-variacao-qtd = 0.
 *       if item-contrat.val-total > 0 then
 *          assign de-variacao-val = item-contrat.val-total +
 *                                  (item-contrat.val-total *
 *                                  (contrato-for.variacao-preco / 100)).
 *       else assign de-variacao-val = 0.
 *    end.
 *    else do:
 *           assign de-variacao-qtd = de-qtd-ordem + (de-qtd-ordem *
 *                 (if contrato-for.variacao-qtd > 0 
 *                   then (contrato-for.variacao-qtd / 100 ) else 0)).
 *           assign de-variacao-val = de-val-ordem + (de-val-ordem *
 *                 (if contrato-for.variacao-preco > 0 then
 *                     (contrato-for.variacao-preco / 100) else 0)).
 *    end.
 *    
 *    if  item-contrat.ind-tipo-control-val = 1 then do:
 *        if  item-contrat.ind-un-contrato = 1 or
 *            (de-qtd-ordem = 0 and item-contrat.qtd-total =  0) then do:
 * 
 *            /* update fi-qtd-prevista with frame {&frame-name}. */
 *            
 *            assign fi-qtd-prevista =
 *                   input frame {&frame-name} fi-qtd-prevista.
 *            assign fi-val-previsto = (input frame {&frame-name}
 *                   fi-qtd-prevista * item-contrat.pre-unit-for).
 * 
 *            assign fi-perc-lib-previst = if de-qtd-ordem > 0 then
 *                     (input frame {&frame-name} fi-qtd-prevista * 100 /
 *                      de-qtd-ordem) 
 *                   else if item-contrat.qtd-total > 0 then
 *                     (input frame {&frame-name} fi-qtd-prevista * 100 /
 *                      item-contrat.qtd-total) 
 *                   else 100.
 *            disp fi-val-previsto 
 *                 fi-perc-lib-previst with frame {&frame-name}.
 *        end.
 *        else
 *        if  item-contrat.ind-un-contrato = 2 then  do:
 *            /* update fi-perc-lib-previst  with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 * 
 *            assign fi-qtd-prevista = 
 *                  input frame {&frame-name} fi-perc-lib-previst *
 *                  if de-qtd-ordem > 0 then
 *                     (de-qtd-ordem / 100) 
 *                  else if item-contrat.qtd-total > 0 then
 *                     (item-contrat.qtd-total / 100)
 *                   else 1.
 *            assign fi-val-previsto = fi-qtd-prevista * 
 *                                                 item-contrat.pre-unit-for.
 *            disp  fi-qtd-prevista
 *                  fi-val-previsto
 *                  with frame {&frame-name}. pause 0.
 *        end. 
 *    end.
 * 
 *    if  item-contrat.ind-tipo-control-val = 2 then do:
 *        if  item-contrat.ind-un-contrato = 1 or 
 *            item-contrat.qtd-total = 0 then do:
 *            /* update fi-qtd-prevista with frame {&frame-name}. */
 *            assign fi-qtd-prevista =
 *                   input frame {&frame-name} fi-qtd-prevista.
 *                                                                                
 *            assign fi-val-previsto =
 *                     (input frame {&frame-name} fi-qtd-prevista
 *                    * item-contrat.pre-unit-for)
 *                   fi-perc-lib-previst = if 
 *                      item-contrat.qtd-total > 0
 *                      then (input frame {&frame-name} fi-qtd-prevista
 *                    * 100 / item-contrat.qtd-total) 
 *                   else 100.
 *            disp fi-val-previsto
 *                 fi-perc-lib-previst
 *                 with frame {&frame-name}. pause 0.
 *        end.
 *        else
 *        if  item-contrat.ind-un-contrato = 2 then  do:
 *            /* update fi-perc-lib-previst  with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 * 
 *            assign fi-qtd-prevista = 
 *                  input frame {&frame-name} fi-perc-lib-previst *
 *                   if item-contrat.qtd-total > 0 then
 *                   (item-contrat.qtd-total / 100)
 *                   else 1.
 *            assign fi-val-previsto = fi-qtd-prevista * 
 *                                                 item-contrat.pre-unit-for.
 *            disp  fi-qtd-prevista
 *                  fi-val-previsto
 *                  with frame {&frame-name}. pause 0.
 *        end. 
 *    end.
 *    if  item-contrat.ind-tipo-control-val = 3 then do: 
 *        if  item-contrat.ind-un-contrato = 1 or
 *            item-contrat.val-total <= 0 then do: 
 *            /* update fi-val-previsto with frame {&frame-name}. */
 *            assign fi-val-previsto =
 *                   input frame {&frame-name} fi-val-previsto.
 *            
 *            assign fi-perc-lib-previst = 
 *                   if item-contrat.val-total > 0 then   
 *                   ((input frame {&frame-name}
 *                     fi-val-previsto * 100) / item-contrat.val-total)
 *                   else 100. 
 *            assign fi-qtd-prevista = input frame {&frame-name}
 *                   fi-val-previsto / item-contrat.pre-unit-for.
 *            disp fi-perc-lib-previst
 *                 fi-qtd-prevista with frame {&frame-name}.
 *            pause 0.
 *        end.
 * 
 *        if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0
 *        then do: 
 *            /* update fi-perc-lib-previst with frame {&frame-name}. */
 *            assign fi-perc-lib-previst =
 *                   input frame {&frame-name} fi-perc-lib-previst.
 *            
 *            assign fi-val-previsto = (input frame {&frame-name} 
 *                   fi-perc-lib-previst * item-contrat.val-total) /
 *                   100. 
 *            assign fi-qtd-prevista = fi-val-previsto /
 *                                                 item-contrat.pre-unit-for.
 *            disp fi-qtd-prevista
 *                 fi-val-previsto with frame {&frame-name}.
 *                 pause 0.
 *        end. 
 *    end.
 * assign l-message1 = no
 *        l-message2 = no.
 * if  (item-contrat.ind-tipo-control-val = 1 or
 *      item-contrat.ind-tipo-control-val = 2) and
 *     (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
 *     if  item-contrat.ind-tipo-control = 1 then do:
 *         if de-variacao-qtd > 0 and
 *            input frame {&frame-name} 
 *            fi-qtd-prevista + de-total-qtd >
 *            de-variacao-qtd then 
 *            assign l-message1 = yes.
 *         else
 *         if de-variacao-val > 0 and
 *            input frame {&frame-name} 
 *            fi-val-previsto + de-total-val >
 *            de-variacao-val then
 *            assign l-message2 = yes.
 *     end.
 *     else do:
 *          if de-variacao-qtd > 0 and
 *             input frame {&frame-name} 
 *             fi-qtd-prevista + de-total-qtd > de-variacao-qtd then
 *             assign l-message1 = yes.
 *          else
 *          if de-variacao-val > 0 and
 *             input frame {&frame-name} 
 *             fi-val-previsto + de-total-val >
 *             de-variacao-val then 
 *             assign l-message2 = yes.
 *     end.
 * end.
 * else 
 *    if item-contrat.ind-tipo-control-val = 3 and
 *      (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
 *      if de-variacao-val > 0 and
 *         fi-val-previsto + item-contrat.sld-val-liber >
 *         de-variacao-val then
 *         assign l-message2 = yes.
 *      else
 *      if de-variacao-qtd > 0 and
 *         fi-qtd-prevista + item-contrat.sld-qtd-liber >
 *         de-variacao-qtd then
 *         assign l-message1 = yes.
 * end.
 * 
 * if l-message1 then do:
 *    message "Quantidade ultrapassa saldo disponivel no Contrato.".
 *    return no-apply.
 * end.
 * 
 * if l-message2 then do:
 *    message "Valor ultrapassa saldo disponivel no Contrato.".
 *    return no-apply.
 * end.
 * 
 * assign de-total-val = de-total-val + input frame {&frame-name}
 *        fi-val-previsto.
 *        de-total-qtd = de-total-qtd + input frame {&frame-name}
 *        fi-qtd-prevista.
 * end.*/
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
  
  /************************ INTERNAL PROCEDURES ********************/

 if evento-ped.cod-cond-pag:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

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
  
  assign evento-ped.dat-prev-entr:screen-value in frame {&frame-name} = string (today).
  

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

  assign de-perc-lib-previst = input frame {&frame-name} fi-perc-lib-previst
         de-val-previsto     = input frame {&frame-name} fi-val-previsto
         de-qtd-prevista     = input frame {&frame-name} fi-qtd-prevista.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

do with frame {&frame-name}:
    assign evento-ped.perc-lib-previst = input fi-perc-lib-previst 
           evento-ped.val-previsto     = input fi-val-previsto
           evento-ped.qtd-prevista     = input fi-qtd-prevista.
end.

assign evento-ped.ind-dest-event = i-destino.
assign evento-ped.dat-prev-event = input frame {&frame-name}
                                       evento-ped.dat-prev-entr.

assign de-qtd-anterior = evento-ped.qtd-realizada
       de-val-anterior = evento-ped.val-realizado.

assign evento-ped.val-realizado  = fi-val-previsto
       evento-ped.qtd-realizada  = evento-ped.qtd-prevista
       evento-ped.dat-realiz     = evento-ped.dat-nova-realiz.

if adm-new-record then do:
    l-erro-co = no.
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
else do:
    l-erro-co = no.
    run cnp/cnapi003.p (input rowid(item-contrat),
                        input (evento-ped.qtd-realizada * (-1) *
                               integer(item-contrat.ind-tipo-control <> 2)),
                        input (evento-ped.val-realizado * (-1) *
                              integer(item-contrat.ind-tipo-control <> 2)),
                        input (evento-ped.qtd-realizada * (-1)) *
                              integer(evento-ped.ind-sit-event = 2),
                        input (evento-ped.val-realizado * (-1)) *
                              integer(evento-ped.ind-sit-event = 2),
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
  
  if avail evento-ped then
     assign fi-perc-lib-previst = evento-ped.perc-lib-previst
            fi-val-previsto     = evento-ped.val-previsto
            fi-qtd-prevista     = evento-ped.qtd-prevista.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

if avail evento-ped then do:
    if evento-ped.ind-dest-event <> 0 then do:
        assign cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 evento-ped.ind-dest-event}
                i-destino = evento-ped.ind-dest-event. 
    end.
    else do: 
        assign cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 1}
               i-destino = 1.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
if avail evento-ped then do:
    find item-contrat 
        where item-contrat.nr-contrato = evento-ped.nr-contrato
          and item-contrat.num-seq-item = evento-ped.num-seq-item
        no-lock no-error.
    
    if avail item-contrat then do:
        if  item-contrat.ind-tipo-control-val = 1 then do:
            if  item-contrat.ind-un-contrato = 1 then do:
               enable fi-qtd-prevista with frame {&frame-name}.
            end.
            else
            if  item-contrat.ind-un-contrato = 2 then  do:
                enable fi-perc-lib-previst with frame {&frame-name}.
            end. 
        end.
        if  item-contrat.ind-tipo-control-val = 2 then do:
            if  item-contrat.ind-un-contrato = 1 then do:
               enable fi-qtd-prevista with frame {&frame-name}.
            end.
            else
            if  item-contrat.ind-un-contrato = 2 then  do:
                enable fi-perc-lib-previst with frame {&frame-name}.
            end. 
        end.
        if  item-contrat.ind-tipo-control-val = 3 then do: 
            if  item-contrat.ind-un-contrato = 1 then do: 
                enable fi-val-previsto with frame {&frame-name}.
            end.
        end.
    end.
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
  
  {utp/ut-field.i mgind evento-ped perc-lib-previst 1}
  assign fi-perc-lib-previst:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind evento-ped val-previsto 1}
  assign fi-val-previsto:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind evento-ped qtd-prevista 1}
  assign fi-qtd-prevista:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind evento-ped ind-dest-event 1}
  assign cb-destino:label in frame {&frame-name} = return-value.
  
  assign cb-destino:list-items in frame {&frame-name}   = {varinc/var00066.i 03}.
  assign cb-destino:screen-value in frame {&frame-name} = {varinc/var00066.i 04 1}.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
 if avail item-contrat then do with frame {&frame-name}:
  if adm-new-record = no then do:
     assign de-total-qtd = de-total-qtd - input fi-qtd-prevista
             de-total-val = de-total-val - input fi-val-previsto.
   end.
   if item-contrat.ind-tipo-control = 1 then do:
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

           /* update fi-qtd-prevista with frame {&frame-name}. */
           
           assign fi-val-previsto:screen-value = string (input fi-qtd-prevista * 
                                                 item-contrat.pre-unit-for).

           assign fi-perc-lib-previst:screen-value = string (if de-qtd-ordem > 0 then
                 (input fi-qtd-prevista * 100 / de-qtd-ordem) 
                  else if item-contrat.qtd-total > 0 then
                 (input fi-qtd-prevista * 100 / item-contrat.qtd-total) 
                  else 100).
       end.
       else
       if  item-contrat.ind-un-contrato = 2 then  do:
           /* update fi-perc-lib-previst  with frame {&frame-name}. */

           assign fi-qtd-prevista:screen-value = string (input fi-perc-lib-previst *
                  if de-qtd-ordem > 0 then
                    (de-qtd-ordem / 100) 
                  else if item-contrat.qtd-total > 0 then
                      (item-contrat.qtd-total / 100)
                  else 1).
           assign fi-val-previsto:screen-value = string (input fi-qtd-prevista * 
                                                         item-contrat.pre-unit-for).
       end. 
   end.

   if  item-contrat.ind-tipo-control-val = 2 then do:
       if  item-contrat.ind-un-contrato = 1 or 
           item-contrat.qtd-total = 0 then do:
           /* update fi-qtd-prevista with frame {&frame-name}. */                                                                               
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
           assign fi-perc-lib-previst:screen-value = string (if item-contrat.val-total > 0 then   
                  ((input fi-val-previsto * 100) / item-contrat.val-total)
                  else 100). 
           assign fi-qtd-prevista:screen-value = string (input fi-val-previsto / 
                                                 item-contrat.pre-unit-for).
       end.

       if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0
       then do: 
           /* update fi-perc-lib-previst with frame {&frame-name}. */           
           assign fi-val-previsto:screen-value = string ((input fi-perc-lib-previst * 
                  item-contrat.val-total) / 100). 
           assign fi-qtd-prevista:screen-value = string (input fi-val-previsto /
                                                 item-contrat.pre-unit-for).
       end. 
   end.

assign l-message1 = no
       l-message2 = no.
if  (item-contrat.ind-tipo-control-val = 1 or
     item-contrat.ind-tipo-control-val = 2) and
    (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
    if  item-contrat.ind-tipo-control = 1 then do:
        if de-variacao-qtd > 0 and
           input frame {&frame-name} 
           fi-qtd-prevista + de-total-qtd >
           de-variacao-qtd then 
           assign l-message1 = yes.
        else
        if de-variacao-val > 0 and
           input frame {&frame-name} 
           fi-val-previsto + de-total-val >
           de-variacao-val then
           assign l-message2 = yes.
    end.
    else do:
         if de-variacao-qtd > 0 and
            input frame {&frame-name} 
            fi-qtd-prevista + de-total-qtd > de-variacao-qtd then
            assign l-message1 = yes.
         else
         if de-variacao-val > 0 and
            input frame {&frame-name} 
            fi-val-previsto + de-total-val >
            de-variacao-val then 
            assign l-message2 = yes.
    end.
end.
else 
   if item-contrat.ind-tipo-control-val = 3 and
     (de-variacao-qtd > 0 or de-variacao-val > 0) then do:
     if de-variacao-val > 0 and
        fi-val-previsto + item-contrat.sld-val-liber >
        de-variacao-val then
        assign l-message2 = yes.
     else
     if de-variacao-qtd > 0 and
        fi-qtd-prevista + item-contrat.sld-qtd-liber >
        de-variacao-qtd then
        assign l-message1 = yes.
end.

if l-message1 then do:
   run utp/ut-msgs.p (input "show",
                      input 8403  ,
                      input "").
   /* Quantidade ultrapassa saldo disponivel no Contrato. */
   return no-apply.
end.

if l-message2 then do:
      run utp/ut-msgs.p (input "show",
                         input 8404  ,
                         input "").
   /* Valor ultrapassa saldo disponivel no Contrato. */
   return no-apply.
end.

assign de-total-val = de-total-val + input frame {&frame-name}
       fi-val-previsto.
       de-total-qtd = de-total-qtd + input frame {&frame-name}
       fi-qtd-prevista.
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
def input parameter p-handle as handle.

assign h_v01in579 = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-item V-table-Win 
PROCEDURE pi-recebe-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if valid-handle(h_v01in579) then 
    run pi-passa-contrato in h_v01in579 (output c-nr-contrato).


RUN Get-Field-Screen-Value IN adm-broker-hdl
   (INPUT this-procedure,
    INPUT "num-seq-item").
    
assign i-num-seq-item = int (return-value).

RUN Get-Field-Screen-Value IN adm-broker-hdl
   (INPUT this-procedure,
    INPUT "numero-ordem").
    
assign i-ordem = int (return-value).

find contrato-for where contrato-for.nr-contrato = c-nr-contrato no-lock no-error.

find item-contrat where 
     item-contrat.num-seq-item = i-num-seq-item and
     item-contrat.nr-contrato   = c-nr-contrato no-lock no-error.
     
assign de-qtd-ordem = 0
       de-val-ordem = 0.
/*   if (de-total-qtd >= de-qtd-ordem) or 
 *       (de-total-val >= de-val-ordem) then do:
 *       
 *       {cdp/cd9999.i "Total de eventos ultrapassa saldo da Ordem"}*/  
     
if avail item-contrat then do with frame {&frame-name}:
   case item-contrat.ind-tipo-control-val:
        when 1 then 
             assign fi-qtd-prevista:sensitive = (item-contrat.ind-un-contrato = 1 or
                                                (de-qtd-ordem = 0 and item-contrat.qtd-total =  0))
                                      
                    fi-perc-lib-previst:sensitive = (item-contrat.ind-un-contrato = 2).
        
        when 2 then do:
             for each  prazo-compra 
                 where prazo-compra.numero-ordem = i-ordem 
                   and prazo-compra.situacao = 2 no-lock:
                 assign de-qtd-ordem = prazo-compra.qtd-do-forn +
                                       de-qtd-ordem             
                        de-val-ordem = de-val-ordem +
                                      (prazo-compra.qtd-do-forn *
                                       item-contrat.pre-unit-for).
             end.     
             assign fi-qtd-prevista:sensitive = (item-contrat.ind-un-contrato = 1 or 
                                                 item-contrat.qtd-total = 0)
                                       
                    fi-perc-lib-previst:sensitive = item-contrat.ind-un-contrato = 2.
        end.
                    
        when 3 then
             assign fi-val-previsto:sensitive = (item-contrat.ind-un-contrato = 1 or
                                                 item-contrat.val-total <= 0)
                                                                                          
                    fi-perc-lib-previst:sensitive = (item-contrat.ind-un-contrat = 2 and 
                                                      item-contrat.val-total > 0).
   end case.
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

{utp/ut-field.i mgind evento-ped des-event 1}
if  input frame {&frame-name} evento-ped.des-event = "" then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show"       ,
                       input 247          ,
                       input return-value ).
    /* Descricao deve ser diferente de branco. */
    return "adm-error".
end.

if  input frame {&frame-name} evento-ped.dat-prev-entr < today then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 8313  ,
                       input ""    ).
    /*Data de previsao de Entrega deve ser maior ou igual a data atual*/
    return "adm-error".
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


