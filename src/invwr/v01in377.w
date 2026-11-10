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
{include/i-prgvrs.i V01IN377 2.00.00.029} /*** "010029" 18/07/2024 10:42:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in377 MUT}
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

def new global shared var gr-referencia as rowid no-undo.

DEF VAR hDBOproxy AS HANDLE NO-UNDO.
DEF VAR hShowMsg  AS HANDLE NO-UNDO.

define buffer b-referencia for referencia.

/***************************MULTIPLANTA**********************************/
def var i-tipo-movto as integer.
{cdp/cd7300.i1}
{cdp/cdapi224.i}
{mcinc/mcapi048.i}
{cdp/cdcfgdis.i}
def temp-table tt-dados-env-SMC   no-undo  like tt-dados-env.
def temp-table tt-replica-msg-SMC no-undo  like tt-replica-msg.
def temp-table tt-control-env-SMC no-undo  like tt-control-env.
def temp-table tt-integracao-SMC  no-undo  like tt-integracao.
/**************************FIM MULTIPLANTA*******************************/

{cdp/cdcfgmat.i}
{include/i_prdvers.i}


DEFINE VARIABLE h-cd0415-crm AS HANDLE NO-UNDO.
DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).


{bhp/bh9999.i1}
{method/dbotterr.i}

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
&Scoped-define EXTERNAL-TABLES referencia
&Scoped-define FIRST-EXTERNAL-TABLE referencia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR referencia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS referencia.texto 
&Scoped-define ENABLED-TABLES referencia
&Scoped-define FIRST-ENABLED-TABLE referencia
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS referencia.cod-refer referencia.descricao ~
referencia.subproduto referencia.texto 
&Scoped-define DISPLAYED-TABLES referencia
&Scoped-define FIRST-DISPLAYED-TABLE referencia


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS referencia.cod-refer referencia.descricao ~
referencia.subproduto referencia.texto 
&Scoped-define ADM-ASSIGN-FIELDS referencia.descricao referencia.subproduto ~
referencia.texto 
&Scoped-define ADM-MODIFY-FIELDS referencia.descricao referencia.subproduto ~
referencia.texto 

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
DEFINE VARIABLE c-desc-det AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 22.57 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 6.46.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 9.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     referencia.cod-refer AT ROW 1.25 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     referencia.descricao AT ROW 2.88 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY .88
     referencia.subproduto AT ROW 3.88 COL 34
          VIEW-AS TOGGLE-BOX
          SIZE 14.29 BY .88
     c-desc-det AT ROW 5.25 COL 3.86 COLON-ALIGNED NO-LABEL
     referencia.texto AT ROW 6.25 COL 5 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 80 BY 5.46
          FONT 2
     RECT-1 AT ROW 5.58 COL 3.57
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.referencia
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
         HEIGHT             = 11.38
         WIDTH              = 90.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-det IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN referencia.cod-refer IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN referencia.descricao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX referencia.subproduto IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR EDITOR referencia.texto IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME referencia.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL referencia.cod-refer V-table-Win
ON F5 OF referencia.cod-refer IN FRAME f-main /* Referància */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in377.w
                     &campo=referencia.cod-refer
                     &campozoom=cod-refer
                     &campo2=referencia.descricao
                     &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL referencia.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF referencia.cod-refer IN FRAME f-main /* Referància */
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


  if referencia.cod-refer:load-mouse-pointer("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "referencia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "referencia"}

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

  {utp/ut-rtlbl.i mgind referencia texto c-desc-det}
      
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.


  /* Code placed here will execute AFTER standard behavior.    */

/***************************MULTIPLANTA**********************************/
find first param-global no-lock no-error.
if avail param-global then do:
    if param-global.modulo-mp = yes then do:
    assign c-transacao = "MAN007".
    {cdp/cd7300.i5 "001" c-transacao}
    assign i-tipo-movto = if referencia.cod-refer:sensitive in frame {&frame-name}
                          then 1 else 2.
    run pi-cria-tt-dados (input i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao}
    end.
end.
/**************************FIM MULTIPLANTA*******************************/

/***************************MULTIPLANTA-SMC**********************************/
find first param-global no-lock no-error.
if avail param-global then do:
    if param-global.modulo-mp = yes then do:

    for each tt-smc-referencia:
      delete tt-smc-referencia.
    end.
    assign c-transacao = "SMC007".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign i-tipo-movto = if referencia.cod-refer:sensitive in frame {&frame-name}
                          then 1 else 2.
    run pi-cria-tt-dados-smc (input i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
    end.
end.
/**************************FIM MULTIPLANTA-SMC*******************************/

&IF '{&mgscm_version}' >= '2.06B' &THEN
IF CONNECTED('mgscm') THEN DO: 
    IF NOT VALID-HANDLE(hDBOproxy) THEN
        RUN wmp/wmprx052.p PERSISTENT SET hDBOproxy.
    RUN ReplicaReferencia IN hDBOproxy(INPUT input frame {&frame-name} referencia.cod-refer,
                                       INPUT input frame {&frame-name} referencia.descricao,
                                       INPUT input frame {&frame-name} referencia.texto,
                                       OUTPUT TABLE RowErrors).
    IF CAN-FIND (FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &modal="YES"}
        {method/showmessage.i3}
        RUN destroy IN hDBOproxy.
        undo, return "ADM-ERROR":U.
    END.
    RUN destroy IN hDBOproxy.
END.
&ENDIF


    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0415-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0415-crm.p PERSISTENT SET h-cd0415-crm.
        
        RUN sendToCRM IN h-cd0415-crm (INPUT referencia.cod-refer,
                                       OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0415-crm.
    END.


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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Referencia referencia.cod-refer '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.

/************************************************************************************************************/

/****[ Verifica se existe movimentaá‰es e saldo em estoque ]*************************************************/
def var l-fec-unico as logical no-undo.
def var l-var as logical no-undo.
def var data-medio like param-estoq.mensal-ate no-undo.

  find first param-estoq no-lock no-error.

  if not avail param-estoq then
     return "ADM-ERROR".

 assign l-fec-unico = no    
        l-var = no.    

 if can-find(first saldo-estoq 
             where saldo-estoq.cod-refer =  referencia.cod-refer:screen-value in frame {&FRAME-NAME} 
               and saldo-estoq.qtidade-atu > 0) then do:
                assign l-var = yes.
 end.
 else do:
      {cdp/cdcfgmat.i}
      &IF DEFINED (bf_mat_versao_ems) &THEN /*2.04*/
       IF param-estoq.tp-fech = 2 THEN DO:
          assign l-fec-unico = yes.
          FOR each estab-mat NO-LOCK:
              ASSIGN data-medio = estab-mat.mensal-ate.
            
              /* Alterada a consulta con fins de otimizacao de performance, FO 2028.858*/
              IF CAN-FIND(FIRST movto-estoq USE-INDEX estab-dep
                  where movto-estoq.cod-estabel = estab-mat.cod-estabel
                    AND movto-estoq.dt-trans    > data-medio    
                    AND movto-estoq.cod-refer   = referencia.cod-refer:screen-value in frame {&FRAME-NAME}) 
              then do:
                 assign l-var = yes.
                 leave.
              end.
          end.
       end.                                 
       ELSE ASSIGN data-medio = param-estoq.mensal-ate.
      &ELSE
       ASSIGN data-medio = param-estoq.mensal-ate.
      &ENDIF
 end. 

 if l-fec-unico = no then do:
   if can-find(first movto-estoq 
               where movto-estoq.cod-refer = referencia.cod-refer:screen-value in frame {&FRAME-NAME} 
                 and movto-estoq.dt-trans > data-medio) 
   then assign l-var = yes. 
 end.

 if l-var = yes then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-referencia AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Referància" *}
    ASSIGN c-lbl-liter-referencia = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-existe-saldo-em-estoque-ou-mov AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Existe_saldo_em_estoque_ou_Movimentaá‰es_para_esta_referància" *}
    ASSIGN c-lbl-liter-existe-saldo-em-estoque-ou-mov = TRIM(RETURN-VALUE).
    run utp/ut-msgs.p (input "show",
                       input 17, 
                       input c-lbl-liter-referencia + "~~" + c-lbl-liter-existe-saldo-em-estoque-ou-mov + ".").
    return "ADM-ERROR":U.
 end.
 run pi-valida-eliminacao.
 if  return-value <> "OK":U then
     return "ADM-ERROR".


    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0415-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0415-crm.p PERSISTENT SET h-cd0415-crm.
        
        RUN deleteFromCRM IN h-cd0415-crm (INPUT referencia.cod-refer,
                                           OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0415-crm.
    END.


 RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U).


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

{utp/ut-rtlbl.i mgind referencia texto c-desc-det} 

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
  if  avail referencia then  
      assign gr-referencia = rowid(referencia).


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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  if  input frame {&FRAME-NAME} referencia.cod-refer = "" then do:
      run utp/ut-msgs.p (input "show",
                         input 75,
                         input "").  

       return 'adm-error'.
  end.  

  /* Ponha aqui a validaá∆o de chave duplicada */
  if  referencia.cod-refer:sensitive in frame {&FRAME-NAME} = yes
  and can-find (b-referencia where b-referencia.cod-refer = input frame {&FRAME-NAME} referencia.cod-refer) then do:
     {utp/ut-field.i mgind referencia cod-refer 1}  
      run utp/ut-msgs.p (input "show",
                         input 1,
                         input return-value).  
      return 'adm-error'.
  end.

  /* Ponha aqui as demais validaá‰es */

   if  input frame {&FRAME-NAME} referencia.descricao= "" then do:
      run utp/ut-msgs.p (input "show",
                         input 75,
                         input "").  

     return 'adm-error'.
  end.  


  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param i-tipo-movto as integer.
    if tt-replica-msg.log-replica-msg = yes then do:
        create tt-referencia-aux.
        buffer-copy referencia to tt-referencia-aux.
        create tt-dados-env.    
        assign tt-dados-env.num-sequencia = i-seq
               tt-dados-env.cod-tipo-reg  = 48
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg = referencia.cod-refer.
        raw-transfer tt-referencia-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
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
def input param i-tipo-movto as integer.
    if tt-replica-msg-SMC.log-replica-msg = yes then do:
        create tt-smc-referencia.
        buffer-copy referencia to tt-smc-referencia.
        create tt-dados-env-SMC.    
        assign tt-dados-env-SMC.num-sequencia = i-seq
               tt-dados-env-SMC.cod-tipo-reg  = 48
               tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
               tt-dados-env-SMC.identif-msg = referencia.cod-refer.
        raw-transfer tt-smc-referencia to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao V-table-Win 
PROCEDURE pi-valida-eliminacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx052.p PERSISTENT SET hDBOproxy.
        RUN eliminaReferencia IN hDBOproxy(INPUT input frame {&frame-name} referencia.cod-refer,
                                           OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> 'INTERNAL':U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            RUN destroy IN hDBOproxy.
            UNDO, RETURN "ADM-ERROR":U.
        END.
        RUN destroy IN hDBOproxy.
    END.
&ENDIF


{database/tgin/tdp/tdin377.i 'show'}

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
  {src/adm/template/snd-list.i "referencia"}

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

