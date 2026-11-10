&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V04IN579 2.00.00.011} /*** "010011" 30/11/2023 16:03:26  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in579 MUT}
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

{cdp/cd0666.i} /* definicao da tt-erro */

/* global variable definitions */

def new global shared var v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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

def var i-seq-ordem           as   integer format "99".
def var i-sequencia           as   integer format "99".
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
def var l-gera                as logical.
def new shared var c-cod-estabel like estabelec.cod-estabel.


def buffer b-evento-ped for evento-ped.
def buffer b1-evento-ped for evento-ped.

def new global shared temp-table t-entrega
   field cod-freq        like frequencia.cd-freq /*cod. da frequencia de */
   field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
   field dat-entrega    as date.

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
&Scoped-Define ENABLED-FIELDS evento-ped.narrativa 
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.narrativa 
&Scoped-define DISPLAYED-TABLES evento-ped
&Scoped-define FIRST-DISPLAYED-TABLE evento-ped


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
nr-contrat||y|mgind.evento-ped.nr-contrat
numero-ordem||y|mgind.evento-ped.numero-ordem
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "nr-contrat,numero-ordem"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     evento-ped.narrativa AT ROW 1.29 COL 5.29 NO-LABEL
          VIEW-AS EDITOR
          SIZE 77.43 BY 5
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 5.67
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
   NOT-VISIBLE Size-to-Fit                                              */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

assign c-cod-estabel = evento-ped.cod-estabel.

if available evento-ped then do:
    if evento-ped.ind-sit-event = 1 
    then do:
        find first nar-evento-aber EXCLUSIVE-LOCK
        where nar-evento-aber.numero-ordem = evento-ped.numero-ordem
          and nar-evento-aber.seq-evento = evento-ped.seq-evento
        no-error.
        if not avail nar-evento-aber then
            create nar-evento-aber.
        assign nar-evento-aber.numero-ordem = evento-ped.numero-ordem
               nar-evento-aber.seq-evento = evento-ped.seq-evento
               nar-evento-aber.desc-linha = evento-ped.narrativa.
    end.
    else if evento-ped.ind-sit-event = 2 
    then do:
        find first nar-evento-fech EXCLUSIVE-LOCK 
        where nar-evento-fech.numero-ordem = evento-ped.numero-ordem
          and nar-evento-fech.seq-evento = evento-ped.seq-evento
        no-error.
        if not avail nar-evento-fech then
            create nar-evento-fech.
        assign nar-evento-fech.numero-ordem = evento-ped.numero-ordem
               nar-evento-fech.seq-evento = evento-ped.seq-evento
               nar-evento-fech.desc-linha = evento-ped.narrativa.
    end.
    
    run pi-gera.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera V-table-Win 
PROCEDURE pi-gera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if l-gera then do:

    run cnp/cn0202b.w (output i-cd-freq,
                       output i-num-periodos,
                       output l-realizado,
                       output l-cancela).
    if l-cancela = yes then 
        i-num-periodos = 1.
    assign i-num-periodos = i-num-periodos - 1.
    
    find first item-contrat where 
            item-contrat.num-seq-item = evento-ped.num-seq-item and
            item-contrat.nr-contrat = evento-ped.nr-contrato
            no-lock no-error.
    
    do i-cont = 1 to i-num-periodos:
        create b-evento-ped.
        
        assign b-evento-ped.nr-contrato  = evento-ped.nr-contrato
               b-evento-ped.num-seq-item = evento-ped.num-seq-item
               b-evento-ped.numero-ordem = evento-ped.numero-ordem
               evento-ped.frequencia     = evento-ped.frequencia
               b-evento-ped.cod-estabel  = evento-ped.cod-estabel
               b-evento-ped.dt-evento    = evento-ped.dt-evento.
        assign l-confirma = no.
        do while l-confirma = no:
            assign i-num-seq-event = i-num-seq-event + 1.
            find first b1-evento-ped NO-LOCK
                where b1-evento-ped.nr-contrato = evento-ped.nr-contrato and
                      b1-evento-ped.num-seq-item = evento-ped.num-seq-item and
                      b1-evento-ped.numero-ordem = evento-ped.numero-ordem and
                      b1-evento-ped.seq-event = i-num-seq-event
                      no-error.           
            if not avail b1-evento-ped then 
                assign l-confirma = yes.     
        end.
        assign b-evento-ped.seq-event = i-num-seq-event.
        if i-cont = 1 then do:
            assign da-data-prev = evento-ped.dat-prev-entr.
            if c-opcao = "Geracao" then do:
                assign i-prox-ent = 0.
                /* cria t-entrega */
                run cnp/cn9012.p (input i-cd-freq,
                                  input da-data-prev,
                                  input i-num-periodos).
            end.
        end.
        if c-opcao = "Geracao" then do:
            assign i-prox-ent = i-prox-ent + 1.
            find first t-entrega where 
                t-entrega.nr-sequencia = i-prox-ent no-error.
                if avail t-entrega then
                    assign da-data-prev = t-entrega.dat-entrega.
        end.
        assign b-evento-ped.log-liber-autom = evento-ped.log-liber-autom
               b-evento-ped.ind-dest-event = evento-ped.ind-dest-event.
        
        assign l-erro-co = no.
        assign de-valor-conver = 0.
        if item-contrat.mo-codigo <> 0 then 
            run cdp/cd0812.p (input  item-contrat.mo-codigo,
                              input  0,
                              input  evento-ped.val-realizado,
                              input  item-contrat.dat-cotac,
                              output de-valor-conver).
        if de-valor-conver = 0 or de-valor-conver = ? then 
            assign de-valor-conver = evento-ped.val-realizado.
        if l-realizado = no then do:
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input evento-ped.qtd-prevista *
                                integer(item-contrat.ind-tipo-control <> 2),
                                input de-valor-conver *
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
                                
            if l-erro-co = yes then
                return "adm-error".
        end.
        else do:
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input evento-ped.qtd-realizada *
                                     integer(item-contrat.ind-tipo-control <> 2),
                                input de-valor-conver * 
                                     integer(item-contrat.ind-tipo-control <> 2),
                                input evento-ped.qtd-realizada,
                                input de-valor-conver, 
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
                return "adm-error".
            assign b-evento-ped.ind-sit-event = 2.
        end. 
        assign b-evento-ped.observacao = evento-ped.observacao
               b-evento-ped.narrativa = evento-ped.narrativa.
        assign b-evento-ped.val-realizado = evento-ped.val-previsto
               b-evento-ped.qtd-realizada = evento-ped.qtd-prevista
               b-evento-ped.dat-realiz    = evento-ped.dat-nova-realiz.            
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-parametro V-table-Win 
PROCEDURE pi-passa-parametro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-gera as logical.
assign l-gera = p-gera.

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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nr-contrat" "evento-ped" "nr-contrat"}
  {src/adm/template/sndkycas.i "numero-ordem" "evento-ped" "numero-ordem"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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

