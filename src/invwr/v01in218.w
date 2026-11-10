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
{include/i-prgvrs.i V01IN218 2.00.00.025 } /*** 010025 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in218 MUT}
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

/* ***** TECNICA SEGURANCA POR ESTABELECIMENTO ***** */
&scoped-define TTONLY YES
{include/i-estab-security.i}
/* ***** TECNICA SEGURANCA POR ESTABELECIMENTO ***** */

/* Local Variable Definitions ---                                       */

{include/i-vrtab.i item}
{include/i-vrtab.i referencia}
{include/i-vrtab.i tab-unidade}


/*def new global shared var gr-item as rowid no-undo.*/
def new global shared var c-lote as char  initial ? no-undo.
def new global shared var c-it-codigo like item.it-codigo no-undo.

def var c-cod-item as character no-undo.
def var c-cod-lote as character no-undo.
def var c-cod-refe as character no-undo.
def var l-mostra-informacoes as logical init no no-undo.

def new shared var da-data-ini as date initial &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF.
def new shared var da-data-fin as date initial "12/31/2999".
def new shared var c-depo-ini as character initial "".
def new shared var c-depo-fin as character initial "ZZZ".
def new shared var c-loca-ini as character initial "".
def new shared var c-loca-fin as character initial "ZZZZZZZZZZZZZZZZZZZZ". 
def new shared var c-estabelec as character initial "".
def new shared var i-espe-ini as integer initial 1.
def new shared var i-espe-fin as integer initial 37.
def new shared var c-seri-ini as character initial "".
def new shared var c-seri-fin as character initial "ZZZZZ".
def new shared var c-nume-ini as character initial "".
def new shared var c-nume-fin as character initial "ZZZZZZZZZZZZZZZZ".
def new shared var c-refer-ini as character initial "".
def new shared var c-refer-fim as character initial "ZZZZZZZZ".
def new shared var c-lot-ini as character initial "".
def new shared var c-lot-fim as character initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ".

DEF TEMP-TABLE tt-seg-estab NO-UNDO
    FIELD cod-estab AS CHAR.

/* Restringe a consulta a 30 dias para aumentar performance -----------------------*/
assign
    da-data-ini = today - 30
    da-data-fin = today.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item item.un ~
item.cod-refer item.cod-obsoleto 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS de-qtidade-ini de-qtidade-fin 

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
DEFINE VARIABLE de-qtidade-fin AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade Final" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtidade-ini AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade Inicial" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     item.desc-item AT ROW 1.25 COL 38.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39.43 BY .88
     item.un AT ROW 1.25 COL 79 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     item.cod-refer AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     item.cod-obsoleto AT ROW 2.25 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     de-qtidade-ini AT ROW 3.25 COL 20 COLON-ALIGNED
     de-qtidade-fin AT ROW 3.25 COL 61 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 3.5
         WIDTH              = 86.86.
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

/* SETTINGS FOR FILL-IN item.cod-obsoleto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtidade-fin IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtidade-ini IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-liter.i Quantidade_Inicial}
  assign de-qtidade-ini:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Quantidade_Final}
  assign de-qtidade-fin:label in frame {&FRAME-NAME} = trim(return-value).

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

if avail item and l-mostra-informacoes then do:

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 

    /* Procura item */
    if available item then do:
        if gr-item <> ? then do:
            assign c-cod-item = item.it-codigo.    
            assign c-cod-refe = item.cod-refer.        
            assign c-cod-lote = c-lote.
        end.
        else do:
            assign c-cod-item = item.it-codigo.
            assign c-cod-refe = ?.
            assign c-cod-lote = ?.
        end.

        assign c-it-codigo = item.it-codigo.
    end.    

    /* calcula o saldo inicial e final do item. */
    
    /* Segurança por Estabelecimento */
    IF  l-estab-security-active = YES THEN DO:
        RUN pi-limpa-qtde.
        FOR EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = c-estabelec NO-LOCK:
            RUN pi-calcula-saldo-ini-fin.
        END.           
    END.
    ELSE DO:
        RUN pi-calcula-saldo-ini-fin.
    END.
end.


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
   assign gr-item = rowid(item).
   find referencia where referencia.cod-refer = item.cod-refer no-lock no-error.
    if avail referencia then 
     assign gr-referencia = rowid(referencia).
   find tab-unidade where tab-unidade.un = item.un no-lock no-error.
    if avail tab-unidade then 
     assign gr-tab-unidade = rowid(tab-unidade).
  end.     
  if not l-mostra-informacoes then run pi-limpa-viewer.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-saldo-ini-fin V-table-Win 
PROCEDURE pi-calcula-saldo-ini-fin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign de-qtidade-ini = 0
       de-qtidade-fin = 0.
  if not l-mostra-informacoes then 
        run pi-limpa-viewer.
    else do:
    for each saldo-estoq fields (saldo-estoq.qtidade-atu)
            where saldo-estoq.it-codigo    = c-cod-item 
              and saldo-estoq.cod-estabel  = c-estabelec
              and saldo-estoq.cod-depos   >= c-depo-ini
              and saldo-estoq.cod-depos   <= c-depo-fin
              and saldo-estoq.lote   >= c-lot-ini
              and saldo-estoq.lote   <= c-lot-fim
              and saldo-estoq.cod-localiz >= c-loca-ini
              and saldo-estoq.cod-localiz <= c-loca-fin
              and saldo-estoq.cod-refer >= c-refer-ini
              and saldo-estoq.cod-refer <= c-refer-fim
            no-lock:       
            assign de-qtidade-ini = de-qtidade-ini + saldo-estoq.qtidade-atu
                   de-qtidade-fin = de-qtidade-fin + saldo-estoq.qtidade-atu.
        end.
        /* Calcula o saldo inicial e final -------------------------------------------*/
        find first saldo-estoq
            where saldo-estoq.it-codigo    = c-cod-item
              and saldo-estoq.cod-estabel = c-estabelec
              and saldo-estoq.cod-depos   >= c-depo-ini
              and saldo-estoq.cod-depos   <= c-depo-fin
              and saldo-estoq.lote   >= c-lot-ini
              and saldo-estoq.lote   <= c-lot-fim
              and saldo-estoq.cod-localiz >= c-loca-ini
              and saldo-estoq.cod-localiz <= c-loca-fin
              and saldo-estoq.cod-refer >= c-refer-ini
              and saldo-estoq.cod-refer <= c-refer-fim
            no-lock no-error.

        if not avail saldo-estoq then do:
           assign de-qtidade-ini = 0
                  de-qtidade-fin = 0.
        end.    
        else do:
            for each item-estab fields (cod-estabel)
                where item-estab.it-codigo = c-cod-item
                  and item-estab.cod-estabel = c-estabelec
                no-lock
                with 1 down:

                for each movto-estoq fields (movto-estoq.tipo-trans
                                             movto-estoq.dt-trans
                                             movto-estoq.quantidade) use-index item-data
                    where movto-estoq.cod-estabel  = c-estabelec
                      and movto-estoq.it-codigo    = c-cod-item
                      and movto-estoq.dt-trans    >= da-data-ini
                      and movto-estoq.cod-depos   >= c-depo-ini
                      and movto-estoq.cod-depos   <= c-depo-fin
                      and movto-estoq.lote   >= c-lot-ini
                      and movto-estoq.lote   <= c-lot-fim
                      and movto-estoq.cod-localiz >= c-loca-ini
                      and movto-estoq.cod-localiz <= c-loca-fin
                      and movto-estoq.cod-refer >= c-refer-ini
                      and movto-estoq.cod-refer <= c-refer-fim
                    no-lock:

                    if movto-estoq.tipo-trans = 1 then do:         /* Movimento de Entrada */
                        /* Se a data for maior que o per¡odo especificado pelo usu rio,
                           altera a quantidade do saldo inicial/final ---------------------*/
                        if movto-estoq.dt-trans > da-data-fin then
                            assign
                                de-qtidade-fin = de-qtidade-fin - movto-estoq.quantidade
                                de-qtidade-ini = de-qtidade-ini - movto-estoq.quantidade.
                        else
                            assign de-qtidade-ini = de-qtidade-ini - movto-estoq.quantidade.
                    end.
                    else do:
                        if movto-estoq.dt-trans > da-data-fin then
                           assign de-qtidade-fin = de-qtidade-fin + movto-estoq.quantidade
                                  de-qtidade-ini = de-qtidade-ini + movto-estoq.quantidade.
                        else
                          assign de-qtidade-ini = de-qtidade-ini + movto-estoq.quantidade.
                    end.
                end.
            end.
        end.
    end.

    display de-qtidade-ini
            with frame f-main.
    display de-qtidade-fin
            with frame f-main.


END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-qtde V-table-Win 
PROCEDURE pi-limpa-qtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  disp "0" @ de-qtidade-ini
       "0" @ de-qtidade-fin
       with frame {&frame-name}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-viewer V-table-Win 
PROCEDURE pi-limpa-viewer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  disp " " @ item.it-codigo
       " " @ item.desc-item
       " " @ item.un
       " " @ item.cod-refer
       " " @ item.cod-obsoleto
       "0" @ de-qtidade-ini
       "0" @ de-qtidade-fin
       with frame {&frame-name}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-dados V-table-Win 
PROCEDURE pi-mostra-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param l-param as logical no-undo.

assign l-mostra-informacoes = l-param.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-inicial V-table-Win 
PROCEDURE pi-seta-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-data-ini as date.
    def input parameter p-data-fin as date.
    def input parameter p-depo-ini as character.
    def input parameter p-depo-fin as character.
    def input parameter p-loca-ini as character.
    def input parameter p-loca-fin as character.
    def input parameter p-estabelec as character.
    def input parameter p-espe-ini as integer.
    def input parameter p-espe-fin as integer.
    def input parameter p-seri-ini as character.
    def input parameter p-seri-fin as character.
    def input parameter p-nume-ini as character.
    def input parameter p-nume-fin as character.
    def input parameter p-lot-ini as character.
    def input parameter p-lot-fim as character.
    def input parameter p-refer-ini as character.
    def input parameter p-refer-fim as character.
    
    assign da-data-ini = p-data-ini
           da-data-fin = p-data-fin
           c-depo-ini  = p-depo-ini
           c-depo-fin  = p-depo-fin
           c-lot-ini  = p-lot-ini
           c-lot-fim = p-lot-fim
           c-loca-ini  = p-loca-ini
           c-loca-fin  = p-loca-fin
           c-estabelec = p-estabelec
           i-espe-ini  = p-espe-ini
           i-espe-fin  = p-espe-fin
           c-seri-ini  = p-seri-ini
           c-seri-fin  = p-seri-fin
           c-nume-ini  = p-nume-ini
           c-nume-fin  = p-nume-fin
           c-refer-ini = p-refer-ini
           c-refer-fim = p-refer-fim.

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

