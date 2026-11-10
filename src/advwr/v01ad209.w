&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD209 2.00.00.053} /*** "010053" 25/06/2025 16:21:12  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad209 MUT}
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

define new global shared var i-cod-portador as integer format ">>>>9" no-undo.
define new global shared var i-modalidade-port as integer format "9" no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-mod           as character      no-undo.
def var c-modal         as character      no-undo.
def var i-modalidade    as integer init 1 no-undo.
def var l-bancario-ant  as log init yes   no-undo.

def var c-mod-atu           as character      no-undo.
def var i-modalidade-atu    as integer init 1 no-undo.
def var l-habilita-relat-portad as logical    no-undo.

DEF VAR l-funcao-portador-ap AS LOGICAL NO-UNDO.


/*********************************************/
/****** Integracao EMS 2 FIN x MG *******/
{cdp/cd0001i1.i} /* Definiá∆o tt-erros-mg */
{cdp/cd0901i1.i} /* Definiá∆o tt-portdor-mg */
{cdp/cdcfgdis.i} 
{cdp/cdcfgfin.i} /* Definiá∆o de vari†veis */
{include/i_dbvers.i}
{include/i_prdvers.i}

def var i-ind-tipo-movto as integer no-undo.


DEFINE VARIABLE h-cd0901-crm AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

{method/dbotterr.i}   /** temp-table RowErrors **/
DEF VAR hShowMsg   AS HANDLE NO-UNDO.


/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.
def var teste        as char no-undo.
def var h_v04ad209   as handle no-undo.
def var h_v05ad209   as handle no-undo.
def var h_q01ad209   as handle  no-undo.
def var h_v08ad209   as handle  no-undo.

{cdp/cd7300.i1}
{cdp/cdapi241.i}

/************Fim*****************************/

{bhp/bh9999.i1}

/* Verifica funá∆o */
{include/getdefinedfunction.i}
assign l-funcao-portador-ap = &if defined(BF_FIN_PORTADOR_AP) &then yes &else GetDefinedFunction("SPP-PORTADOR-AP") &endif.


/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.
def var h-handle            as handle no-undo.
def var c-handle            as char   no-undo.

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
&Scoped-define EXTERNAL-TABLES portador
&Scoped-define FIRST-EXTERNAL-TABLE portador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR portador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS portador.nome 
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS portador.cod-portador portador.nome 
&Scoped-define DISPLAYED-TABLES portador
&Scoped-define FIRST-DISPLAYED-TABLE portador
&Scoped-Define DISPLAYED-OBJECTS c-modalidade 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS portador.cod-portador c-modalidade 

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
DEFINE VARIABLE c-modalidade AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 24 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     portador.cod-portador AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-modalidade AT ROW 1.17 COL 59 COLON-ALIGNED
     portador.nome AT ROW 2.21 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.portador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  if index(proversion,"webspeed") = 0 THEN 
     MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 88.29.
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

/* SETTINGS FOR COMBO-BOX c-modalidade IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN portador.cod-portador IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME c-modalidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-modalidade V-table-Win
ON VALUE-CHANGED OF c-modalidade IN FRAME f-main
DO:          
    if  i-modalidade = 6 or 
        i-modalidade = 8 or
        i-modalidade = 9 then
        assign l-bancario-ant = no.

    assign input frame {&frame-name} c-modalidade i-modalidade = {adinc/i03ad209.i 06 c-modalidade}.
    if  portador.cod-portador:sensitive in frame {&FRAME-NAME} = yes then do:
        if  h_v04ad209 <> ? then
            run pi-portador-bancario in h_v04ad209 (input i-modalidade).
    end. 

    run get-attribute('adm-new-record').
    if  return-value = "yes" then do:
        if  i-modalidade = 6 or 
            i-modalidade = 8 or
            i-modalidade = 9 then
            if l-bancario-ant then run notify in this-procedure ('pi-desabilita,link_1-target').
        else if  not l-bancario-ant then
                 run notify in this-procedure ('pi-habilita,link_1-target').
        if  i-modalidade = 7 then
            run notify in this-procedure ('pi-consiste-vendor,link_1-target').
    end.
   if h-handle = ? then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                  OUTPUT c-handle).

      run pi-busca-handle-aux in widget-handle(c-handle) (output h-handle).                    
   end.      
   if valid-handle(h-handle) then do:  
      if input frame {&frame-name} c-modalidade:sensitive = yes then
         run pi-verif-vendor in  h-handle (input "vendor").          
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  /****** Integraá∆o EMS 2 FIN x MG *******/
  {btb/btb008za.i0}
  {include/i-freeac.i} /* include para tirar acentuaá∆o */



  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF       

assign l-habilita-relat-portad = no.

&if defined(BF_FIN_RELAT_PORTAD) &then
    assign l-habilita-relat-portad = yes.
&else
    if can-find(first funcao
                where funcao.cd-funcao = "spp-relat-portad" no-lock) then do:
        assign l-habilita-relat-portad = yes.
    end.
&endif

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
  {src/adm/template/row-list.i "portador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "portador"}

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

  do with frame {&frame-name}:
     assign c-modalidade:screen-value = {adinc/i03ad209.i 04 1}.
     apply 'value-changed':U to c-modalidade in frame {&FRAME-NAME}.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ).

  if avail portador then do with frame {&frame-name}:
     assign c-modalidade:screen-value = {adinc/i03ad209.i 04 portador.modalidade}.
     apply 'value-changed':U to c-modalidade in frame {&FRAME-NAME}.
  end. 
  else do:
     assign c-modalidade:screen-value = {adinc/i03ad209.i 04 1}.
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

  {include/i-valid.i}

  assign c-mod        = input frame {&frame-name} c-modalidade
         i-modalidade = {adinc/i03ad209.i 06 c-mod}.

  if  return-value = "adm-error":U THEN
      RETURN 'ADM-ERROR':U.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

    assign portador.modalidade = i-modalidade.
    assign  c-modalidade:screen-value = c-mod.

  if  avail portador then do:
      assign portador.modalidade = i-modalidade
             portador.ep-codigo  = i-ep-codigo-usuario.            
         
      if  portador.modalidade = 6 or
          portador.modalidade = 8 or
          portador.modalidade = 9 then
          assign portador.bancario = no.
      else
          assign portador.bancario = yes.
  end.

  IF lIntCRM11 THEN DO:
    IF NOT VALID-HANDLE(h-cd0901-crm) THEN DO:
        RUN integracoes/adapters/emstocrm/cd0901-crm.p PERSISTENT SET h-cd0901-crm.
        RUN sendToCRM IN h-cd0901-crm (INPUT portador.cod-portador, INPUT portador.modalidade, OUTPUT TABLE RowErrors).
    END.

    IF CAN-FIND (FIRST RowErrors WHERE 
                 RowErrors.ErrorSubType = "ERROR":U) THEN DO:
          {method/ShowMessage.i1}
        {method/ShowMessage.i2 &Modal="YES"}
        UNDO, RETURN "ADM-ERROR":U.
    END.
    DELETE PROCEDURE h-cd0901-crm.
  END.

  /****** Integraá∆o EMS 2 FIN x MG *******/
  {cdp/cd0002i1.i "portador"}

    if  l-ok-mmf = yes then do:  
        /********************Multiplanta***********************/

           assign c-transacao = "ADM039".
          {cdp/cd7300.i5 "001" c-transacao}

          assign i-tipo-movto = if portador.cod-portador:sensitive in frame {&frame-name} = yes 
                                   then 1 else 2.
            run pi-cria-tt-dados (input i-tipo-movto).

          {cdp/cd7300.i6 "001" c-transacao " "}

        /******************Fim-Multiplanta********************/ 
    end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-global no-lock no-error.

  if avail portador THEN do:
      find first  emitente 
           where (emitente.portador    = portador.cod-portador
             and emitente.modalidade   = portador.modalidade) 
             or  (emitente.port-prefer = portador.cod-portador 
             and emitente.mod-prefer   = portador.modalidade)  no-lock no-error.
      if avail emitente then do:
          run utp/ut-msgs.p (input "show", input 29567, input "").             
          return "adm-error":U.
      end.
      IF l-funcao-portador-ap THEN DO:
          find first  emitente 
               where ( &if "{&mgadm_version}" >= "2.06b" &then
                             emitente.portador-ap &else
                       int(SUBSTR(emitente.char-1,31,5)) &endif = portador.cod-portador
                 and   &if "{&mgadm_version}" >= "2.06b" &then
                       emitente.modalidade-ap &else 
                       INT(SUBSTR(emitente.char-1,36,2)) &endif = portador.modalidade) no-lock no-error.
          if avail emitente then do:
              run utp/ut-msgs.p (input "show", input 29567, input "").                  
              return "adm-error":U.     
          end.
      END.
  END.
  if  avail portador and avail param-global and portador.ep-codigo = param-global.empresa-prin then do:
      find first ped-venda
           where ped-venda.cod-portador = portador.cod-portador
           and   ped-venda.modalidade   = portador.modalidade no-lock no-error.
      if  avail ped-venda then do:
          run utp/ut-msgs.p (input "show", input 278, input "").
          return "adm-error":U.       
      end.

      find first nota-fiscal
           where nota-fiscal.cod-portador = portador.cod-portador
           and   nota-fiscal.modalidade   = portador.modalidade no-lock no-error.
      if  avail nota-fiscal then do:
          run utp/ut-msgs.p (input "show", input 279, input "").
          return "adm-error":U.
      end.

      find first nota-fiscal
           where nota-fiscal.cod-portador = portador.cod-portador
           and   nota-fiscal.modalidade   = portador.modalidade
           and   nota-fiscal.emite-duplic = yes
           and  (nota-fiscal.ind-sit-nota = 0
           or    nota-fiscal.ind-sit-nota = 1
           or    nota-fiscal.ind-sit-nota = 2) no-lock no-error.
      if  avail nota-fiscal then do:
          run utp/ut-msgs.p (input "show", input 280, input "").
          return "adm-error":U.       
      end.
  end.
  if  avail portador then
  find first tit-ap 
       where tit-ap.ep-codigo  = i-ep-codigo-usuario
       and   tit-ap.portador   = portador.cod-portador
       and   tit-ap.modalidade = portador.modalidade no-lock no-error.
  if  avail tit-ap then do:
      run utp/ut-msgs.p (input "show", input 284, input "").
      return "adm-error":U.       
  end.
  if  avail portador then                  
  find first mov-ap
       where mov-ap.ep-codigo  = i-ep-codigo-usuario
       and   mov-ap.portador   = portador.cod-portador
       and   mov-ap.modalidade = portador.modalidade no-lock no-error.
  if  avail mov-ap then  do:
      run utp/ut-msgs.p (input "show", input 284, input "").
      return "adm-error":U.
  end.

  if  avail portador then
  find first titulo
       where titulo.ep-codigo  = i-ep-codigo-usuario
       and   titulo.cod-port   = portador.cod-portador
       and   titulo.modalidade = portador.modalidade no-lock no-error.
  if  avail titulo then do:
      run utp/ut-msgs.p (input "show", input 283, input "").
      return "adm-error":U.       
  end.

  if  avail portador then                    
  find first mov-tit
       where mov-tit.ep-codigo  = i-ep-codigo-usuario
       and   mov-tit.cod-portador   = portador.cod-portador
       and   mov-tit.modalidade = portador.modalidade no-lock no-error.
  if  avail mov-tit then  do:
      run utp/ut-msgs.p (input "show", input 283, input "").
      return "adm-error":U.    
  end.

    &if "{&mgadm_version}" >= "2.03" &then
        if  avail portador then
            find first config-nome-arq exclusive-lock
                where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
                and   config-nome-arq.cod-portador = portador.cod-portador
                and   config-nome-arq.modalidade   = portador.modalidade
                and   config-nome-arq.modulo       = 1 /* APP */ no-error.
            if  avail config-nome-arq then
                delete config-nome-arq.
    &endif     

   IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0901-crm) THEN
          RUN integracoes/adapters/emstocrm/cd0901-crm.p PERSISTENT SET h-cd0901-crm.
        
        RUN deleteFromCRM IN h-cd0901-crm (INPUT portador.cod-portador, INPUT portador.modalidade,
                                           OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0901-crm.
    END.


/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if avail param-global and param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Portador portador.cod-portador portador.modalidade portador.ep-codigo '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

   {cdp/cd0002i1.i1 "portador" "no"} /****** Integraá∆o EMS 2 FIN x MG *******/

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

   {cdp/cd0002i1.i1 "portador" "yes"} /****** Integraá∆o EMS 2 FIN x MG *******/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if avail portador then do with frame {&frame-name}:
     assign c-modalidade:screen-value = {adinc/i03ad209.i 04 portador.modalidade}.
  end. 
  else do:
     assign c-modalidade:screen-value = {adinc/i03ad209.i 04 1}.
  end.
   
  if l-habilita-relat-portad THEN DO:
     IF AVAIL portador THEN       
         ASSIGN i-cod-portador = portador.cod-portador
                i-modalidade-port = portador.modalidade.
     ELSE 
        ASSIGN i-cod-portador =  input frame {&frame-name} portador.cod-portador
               i-modalidade-port = i-modalidade.       
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign c-mod        = input frame {&frame-name} c-modalidade
         i-modalidade = {adinc/i03ad209.i 06 c-mod}.

  apply 'value-changed':U to c-modalidade in frame {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  find first param-global no-lock no-error.

  {utp/ut-field.i mgadm portador modalidade 1}

  assign c-modalidade:label in frame f-main = return-value. 

  do  with frame {&frame-name}:
      assign c-modalidade:list-items = {adinc/i03ad209.i 03}.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /*---  Modulo Multiplanta Financeiro (MMF) ---*/
    {cdp/cdapi531.i1 "ADM039" "NO"}


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
    /****** Integraá∆o EMS 2 FIN x MG *******/

    {cdp/cd0003i1.i "portador" "cdp/cd0901i1.p"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores V-table-Win 
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-portad as int.
def output param p-nome   as char.
def output param p-modal  as char.

assign p-portad = input frame {&frame-name} portador.cod-portador
       p-nome   = input frame {&frame-name} portador.nome
       p-modal  = input frame {&frame-name} c-modalidade.

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
 def input parameter i-tipo-movto as integer.

     if  avail param-global and param-global.modulo-mp and
         tt-replica-msg.log-replica-msg  = yes then do: 
         create tt-portador-aux.
         buffer-copy portador to tt-portador-aux.
         create tt-dados-env.                  
         assign tt-dados-env.num-sequencia  = i-seq 
                tt-dados-env.cod-tipo-reg   = 89
                tt-dados-env.ind-tipo-movto = i-tipo-movto
                tt-dados-env.identif-msg    = string(portador.ep-codigo)    + " , " + 
                                              string(portador.cod-portador) + " , " + 
                                              string(portador.modalidade).
         raw-transfer tt-portador-aux to tt-dados-env.conteudo-msg.                                    
         assign i-seq = i-seq + 1.                                     
     end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-portador-mg V-table-Win 
PROCEDURE pi-cria-tt-portador-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /****** Integraá∆o EMS 2 FIN x MG *******/
    def input param p-ind-tipo-movto as int  no-undo.
    def input param p-atualiza       as log  no-undo.

    for each tt-portador-mg:
        delete tt-portador-mg.
    end.

    create tt-portador-mg.

    assign tt-portador-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-portador-mg.l-atualiza     = p-atualiza.


    /* campos iguais */
    assign  tt-portador-mg.ep-codigo        = portador.ep-codigo
            tt-portador-mg.cod-portador     = portador.cod-portador
            tt-portador-mg.esp-cob-esc      = portador.esp-cob-esc
            tt-portador-mg.valor-saldo      = portador.valor-saldo
            tt-portador-mg.telefone         = portador.telefone
            tt-portador-mg.ramal            = portador.ramal
            tt-portador-mg.telefax          = portador.telefax
            tt-portador-mg.ramal-fax        = portador.ramal-fax
            tt-portador-mg.telex            = portador.telex
            tt-portador-mg.pr-lib-tit       = portador.pr-lib-tit
            tt-portador-mg.usa-cob-esc      = portador.usa-cob-esc
            tt-portador-mg.carteira[1]      = portador.carteira[1]
            tt-portador-mg.carteira[2]      = portador.carteira[2]
            tt-portador-mg.carteira[3]      = portador.carteira[3]
            tt-portador-mg.carteira[4]      = portador.carteira[4]
            tt-portador-mg.carteira[5]      = portador.carteira[5]
            tt-portador-mg.carteira[6]      = portador.carteira[6]
            tt-portador-mg.cod-resp         = portador.cod-resp
            tt-portador-mg.prazo-max        = portador.prazo-max
            tt-portador-mg.prazo-min        = portador.prazo-min
            tt-portador-mg.cod-banco        = portador.cod-banco
            tt-portador-mg.convenio         = portador.convenio
            tt-portador-mg.prox-remessa-ap  = portador.prox-remessa-ap
            tt-portador-mg.contr-garant     = portador.contr-garant
            tt-portador-mg.pr-env-pag       = portador.pr-env-pag
            tt-portador-mg.ind-dt-cred-ret  = portador.ind-dt-cred-ret
            tt-portador-mg.prox-remessa-cr  = portador.prox-remessa-cr
            tt-portador-mg.prazo-max-ap     = portador.prazo-max-ap
            tt-portador-mg.prazo-min-ap     = portador.prazo-min-ap
            tt-portador-mg.usa-inter        = portador.usa-inter
            tt-portador-mg.perc-part-dest   = portador.perc-part-dest
            tt-portador-mg.cod-carteira     = portador.cod-carteira
            tt-portador-mg.exige-aceite     = portador.exige-aceite
            tt-portador-mg.dec-2            = portador.dec-2
            tt-portador-mg.int-1            = portador.int-1
            tt-portador-mg.int-2            = portador.int-2.

    assign  tt-portador-mg.nome             = fn-free-accent(portador.nome).
    assign  tt-portador-mg.nome-abrev       = fn-free-accent(portador.nome-abrev).
    assign  tt-portador-mg.nome-agencia     = fn-free-accent(portador.nome-agencia).
    assign  tt-portador-mg.intervalo-head   = fn-free-accent(portador.intervalo-head).
    assign  tt-portador-mg.intervalo-det    = fn-free-accent(portador.intervalo-det).
    assign  tt-portador-mg.complemento      = fn-free-accent(portador.complemento).

    /* campos diferentes */
    case portador.modalidade:
        when 1 then assign tt-portador-mg.modalidade = 0.
        when 2 then assign tt-portador-mg.modalidade = 1.
        when 3 then assign tt-portador-mg.modalidade = 2.
        when 4 then assign tt-portador-mg.modalidade = 3.
        when 5 then assign tt-portador-mg.modalidade = 4.
        when 6 then assign tt-portador-mg.modalidade = 5.
        when 7 then assign tt-portador-mg.modalidade = 6.
    end case.

    case portador.emissao-oc:
        when 1 then assign tt-portador-mg.emissao-oc = "C".
        when 2 then assign tt-portador-mg.emissao-oc = "M".
        when 3 then assign tt-portador-mg.emissao-oc = "T".
    end case.

    assign  tt-portador-mg.agencia          = portador.agencia
            tt-portador-mg.ct-deb-princ     = integer(portador.ct-deb-princ)
            tt-portador-mg.sc-deb-princ     = integer(portador.sc-deb-princ)
            tt-portador-mg.ct-juros-rec     = integer(portador.ct-juros-rec)
            tt-portador-mg.sc-juros-rec     = integer(portador.sc-juros-rec)
            tt-portador-mg.ct-despesas      = integer(portador.ct-despesas)
            tt-portador-mg.sc-despesas      = integer(portador.sc-despesas)
            tt-portador-mg.ct-tit-desc      = integer(portador.ct-tit-desc)
            tt-portador-mg.sc-tit-desc      = integer(portador.sc-tit-desc)
            tt-portador-mg.conta-corren     = portador.conta-corren
            tt-portador-mg.pref-agencia     = portador.pref-agencia
            tt-portador-mg.cod-febraban     = portador.cod-febraban
            tt-portador-mg.char-1           = portador.char-1
            tt-portador-mg.envia-vencidos   = portador.log-2.


    if  portador.considera-fluxo-cr then
        assign tt-portador-mg.log-1 = no.
    else
        assign tt-portador-mg.log-1 = yes.

    if  portador.considera-fluxo-ap then
        assign tt-portador-mg.log-2 = no.
    else
        assign tt-portador-mg.log-2 = yes.

    if  portador.emite-bloq = 1 then
        assign tt-portador-mg.emite-bloq = yes.
    else
        assign tt-portador-mg.emite-bloq = no.


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
   /****** Integraá∆o EMS 2 FIN x MG *******/

    {cdp/cd0004i1.i "CD0901"
                    "portador"
                    "portador.cod-portador"
                    "tt-portador-mg.ind-tipo-movto"
                    "tt-erros-mg.help-msg"}
    if return-value = "NOK" then
       return.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle V-table-Win 
PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param p-handle as handle no-undo.

  if  p-handle <> ? then 
      assign h_v04ad209 = p-handle.

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
def input parameter h-handle  as handle no-undo.

 assign h_q01ad209 = h-handle.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-modalidade V-table-Win 
PROCEDURE pi-passa-modalidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-modalidade as int.

assign c-modal      =  input frame {&frame-name} c-modalidade
       i-modalidade = {adinc/i03ad209.i 06 c-modal}
       p-modalidade = i-modalidade.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-portador V-table-Win 
PROCEDURE pi-passa-portador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-portador like portador.cod-portador.
    assign p-portador = input frame {&FRAME-NAME} portador.cod-portador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-portador-mg V-table-Win 
PROCEDURE pi-valida-portador-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param p-ind-tipo-movto as int no-undo.

    /*--- Se tipo da Modalidade for Cheque ou Nota Promissoria, n∆o deve ser
          integrado com o Magnus, pois nao e tratado por ele. ---*/

      assign c-mod-atu        = input frame {&frame-name} c-modalidade
             i-modalidade-atu = {adinc/i03ad209.i 06 c-mod-atu}.

    if  i-modalidade-atu = 8 or 
        i-modalidade-atu = 9 then do:

        if p-ind-tipo-movto = 3 then 
           assign p-ind-tipo-movto = 0.

        if p-ind-tipo-movto = 1 then do:     
           run utp/ut-msgs.p (input "show",
                              input 19446,
                              input c-mod-atu).    
           assign p-ind-tipo-movto = 0.       
        end.   

        if p-ind-tipo-movto = 2 then do:

           if i-modalidade-atu <> i-modalidade then do:       

              assign c-mod = {adinc/i01ad103.i 4 i-modalidade}.
              if  index(proversion,"webspeed") = 0 then 
                 run utp/ut-msgs.p (input "show",
                                    input 19485,
                                    input c-mod-atu + "~~" + c-mod).
              if return-value = "yes" then
                 assign p-ind-tipo-movto = 3.
              else
                 return "NOK".   
           end.      
           else
              assign p-ind-tipo-movto = 0.
        end.   

    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  assign c-mod        = input frame {&frame-name} c-modalidade
         i-modalidade = {adinc/i03ad209.i 06 c-mod}.  
  if  portador.cod-portador:sensitive in frame {&frame-name} = yes and
  can-find(first portador where
                 portador.ep-codigo    = i-ep-codigo-usuario and
                 portador.cod-portador = input frame {&frame-name} portador.cod-portador and
                 portador.modalidade   = i-modalidade) then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgadm portador cod-portador 1}
      if  index(proversion,"webspeed") = 0 then
         run utp/ut-msgs.p (input "show":U,
                            input 1, 
                            input return-value).
      apply "entry" to portador.cod-portador in frame {&frame-name}.
      return "adm-error":U.
  end.
  if  input frame {&frame-name} portador.cod-portador = 0 then do:
      {include/i-vldprg.i}
      if  index(proversion,"webspeed") = 0 then 
         run utp/ut-msgs.p (input "show":U, input 3277, input "").
      apply "entry" to portador.cod-portador.
      return "adm-error":U.
  end.
  if  input frame {&frame-name} portador.nome = "" then do:
      {include/i-vldprg.i}
      if  index(proversion,"webspeed") = 0 then 
         run utp/ut-msgs.p (input "show":U, input 236, input "").
      apply "entry" to portador.nome.
      return "adm-error":U.
  end. 

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (input this-procedure,
      input "bancario"). 

  if  c-modalidade:screen-value in frame {&frame-name} = {adinc/i03ad209.i 04 08} then do:
      find first param-global no-lock no-error.
      if  avail param-global then do:
          if  param-global.modulo-cb = no then do: 
              {include/i-vldprg.i}
              if  index(proversion,"webspeed") = 0 then 
                 run utp/ut-msgs.p (input "show":U,
                                    input 7335, 
                                    input "").
              apply "entry" to c-modalidade in frame {&frame-name}.
              return "adm-error":U.
          end.
      end.         
  end.    

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
  {src/adm/template/snd-list.i "portador"}

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

