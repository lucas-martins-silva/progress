&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V03IN536 2.00.00.003} /*** "010003" 27/08/2024 08:50:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN536 MUT}
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

// Deficoes do treeview
{utp/ut-4gltreeview.i}

{sfc/sfapi004.i}  /** Temp-tables        **/

def temp-table tt-linha
    field sequencia as integer
    field cod-equipe as char
    index seq is unique primary sequencia.

def var h-sfapi004     as handle no-undo.
def var da-dt-inicio   like area-produc-ctrab.dat-inic-valid no-undo.
def var da-dt-fim      like area-produc-ctrab.dat-fim-valid no-undo.
def var c-cod-ctrab    like ctrab.cod-ctrab no-undo.
def var c-gm-codigo    like ctrab.gm-codigo no-undo.
def var log-parada-nef as logical no-undo.
def var log-parada-hex as logical no-undo.
def var rw-area-produc-ctrab as rowid   no-undo.

def var chTreeView           as com-handle.
def var c-handle             as handle no-undo.
def var i-cont               as int no-undo.
def var i-aux                as int no-undo.
def var i-index              as int no-undo.
def var l-expande            as log init no  no-undo.
def var l-geral              as log init yes no-undo.
def var c-aux                as char.
def var c-liter-ctrab        as char.
def var c-liter-tempo-reptdo as char.
def var c-liter-tempo-padrao as char.
def var c-liter-fator-refgdo as char.
def var c-liter-fator-retrab as char.
def var c-liter-fator-efic   as char.
def var c-liter-item         as char.
def var c-liter-op           as char.
def var c-liter-rot          as char.
def var c-liter-tempo-real   as char.
define variable cNodeId          as   character                 no-undo.
define variable cNodeIdPai       as   character                 no-undo.
define variable cNodeLabel       as   character                 no-undo.
define variable cNodeImage       as   character                 no-undo.
define variable cNodeOptn        as   character                 no-undo.
DEFINE VARIABLE cNode            AS   CHARACTER                 NO-UNDO.
DEFINE VARIABLE lOk              AS   LOGICAL                   NO-UNDO.
DEF VAR cTooltip  AS CHAR NO-UNDO.
/* Vari†veis para o Gr†fico */

{utp/utapi001.i}

def var i          as int                   no-undo.
def var j          as int                   no-undo.
def var c          as char   format "x(30)" no-undo.
def var h-aux      as handle                no-undo.
def var i-contador as int    init 0         no-undo.
def var c-liter-titulo as char              no-undo.

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
&Scoped-define EXTERNAL-TABLES equipe-prod
&Scoped-define FIRST-EXTERNAL-TABLE equipe-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR equipe-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 

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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 9.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.equipe-prod
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
         HEIGHT             = 9.92
         WIDTH              = 89.
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

{utp/ut-liter.i Centro_Trabalho *}
assign c-liter-ctrab = trim(return-value).

{utp/ut-liter.i Tempo_Reportado *}
assign c-liter-tempo-reptdo = trim(return-value).

{utp/ut-liter.i Tempo_Padrao *}
assign c-liter-tempo-padrao= trim(return-value).

{utp/ut-liter.i Fator_Refugo *}
assign c-liter-fator-refgdo = trim(return-value).

{utp/ut-liter.i Fator_Retrab *}
assign c-liter-fator-retrab = trim(return-value).

{utp/ut-liter.i Fator_Efic *}
assign c-liter-fator-efic = trim(return-value).

{utp/ut-field.i mgind item it-codigo 1}
assign c-liter-item = trim(return-value). 

{utp/ut-liter.i Operaá∆o *}
assign c-liter-op = trim(return-value).

{utp/ut-liter.i Roteiro *}
assign c-liter-rot = trim(return-value).

{utp/ut-liter.i Tempo_Real *}
assign c-liter-tempo-real = trim(return-value).

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
  {src/adm/template/row-list.i "equipe-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "equipe-prod"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields V-table-Win 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN carregaTreeView.
    RUN criaTreeView.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTreeView V-table-Win 
PROCEDURE criaTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    // Limpa o treeview
   RUN emptyTree IN h-4gltreeview.
   ASSIGN c-codigo-node = "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-controls V-table-Win 
PROCEDURE initialize-controls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Todos os assigns n∆o feitos pelo assign-record devem ser feitos aqui */  
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF VALID-HANDLE(h-4gltreeview) THEN
    RUN emptyTree IN h-4gltreeview.      

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN Who-Is-The-Container IN adm-broker-hdl
      (INPUT this-procedure,OUTPUT c-handle).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 

  assign i-aux   = 1
         i-cont  = 1
         l-geral = yes.

  IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      // Instancia o treeview
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
   
      // Indica a Frame "Pai" do componente
      RUN setParentFrame IN h-4gltreeview (INPUT FRAME f-main:HANDLE).

      // Inicializa o treeview
      RUN initializeObject IN h-4gltreeview.
   
      // Faz a subscricao dos eventos do treeview
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

      // Reposiciona o treeview 
      RUN repositionObject IN h-4gltreeview (1, 1).

      // Ajusta o tamanho do treeview 
      RUN resizeObject IN h-4gltreeview (9.79,88.57).
   END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if session:set-wait-state ("general") then.

  if avail equipe-prod then do:
      IF VALID-HANDLE(h-4gltreeview) THEN
            RUN emptyTree IN h-4gltreeview.

      assign i-aux  = 1
             i-cont = 1.

      for each tt-oper-ctrab where tt-oper-ctrab.cod-operador = equipe-prod.cod-equipe:

          if l-expande then   
              ASSIGN cExpClp = "expanded".
          ELSE 
              ASSIGN cExpClp = "collapsed".

          ASSIGN cNodeLabel = c-liter-ctrab + " : " +
                 tt-oper-ctrab.cod-ctrab + " - " +
                 c-liter-tempo-reptdo + " : " +
                 string(tt-oper-ctrab.qtd-tempo-reptdo,">>>9.99") + " - " + 
                 c-liter-tempo-padrao + " : " +
                 string(tt-oper-ctrab.qtd-tempo-padrao,">>>9.99") + " - " +
                 c-liter-fator-refgdo + " : " +
                 string(tt-oper-ctrab.fator-refugo,">>9.99") + " - " + 
                 c-liter-fator-retrab + " : " +
                 string(tt-oper-ctrab.fator-retrab,">>9.99") + " - " + 
                 c-liter-fator-efic + " : " +
                 string(tt-oper-ctrab.fator-eficienc,">>9.99").

          ASSIGN cTooltip  = "tooltip= " + cNodeLabel.
        
          RUN pi-create-node (INPUT "e" + STRING(i-cont), 
                              INPUT "",
                              INPUT cNodeLabel,
                              INPUT "image/treeview/tvpics/separator.bmp",
                              INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

          find tt-linha where tt-linha.sequencia = i-cont no-error.
          if  not avail tt-linha then do:
              create tt-linha.
              assign tt-linha.sequencia = i-cont
                     tt-linha.cod-equipe = tt-oper-ctrab.cod-operador.
          end.

          assign i-aux  = i-cont
                 i-cont = i-cont + 1.                                     
      end.

      IF VALID-HANDLE(h-4gltreeview) THEN DO:
            
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.
            
            RUN applyEntry IN h-4gltreeview (INPUT "").
            
            IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN
               ASSIGN lok = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, cNode).
        END. 
  end.    

  IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN
      run pi-habilita-expande in c-handle(input yes).
  else
      run pi-habilita-expande in c-handle(input no).       

  if session:set-wait-state ("") then.

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

  if  avail equipe-prod
  and valid-handle(h-sfapi004) then
      run pi-gera-tt.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-handle V-table-Win 
PROCEDURE pi-atualiza-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle as handle no-undo.

assign h-sfapi004 = p-handle.

if  avail equipe-prod then
    run pi-gera-tt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-expande V-table-Win 
PROCEDURE pi-expande :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign l-expande = not l-expande.

RUN local-open-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt V-table-Win 
PROCEDURE pi-gera-tt :
/**************************************/

    for each tt-ctrab-rp: delete tt-ctrab-rp. end.
    for each tt-oper-ctrab: delete tt-oper-ctrab. end.
    for each tt-oper-ctrab-operac: delete tt-oper-ctrab-operac. end.
    for each tt-operador: delete tt-operador. end.
    for each tt-operac-rp: delete tt-operac-rp. end.

    find tt-operador
          where tt-operador.cod-operador = equipe-prod.cod-equipe no-error.

    if  not avail tt-operador then do:        
        create tt-operador.
        assign tt-operador.cod-operador     = equipe-prod.cod-equipe
               tt-operador.cod-area-produc  = equipe-prod.cod-area-produc
               tt-operador.data-inicio      = da-dt-inicio
               tt-operador.data-fim         = da-dt-fim.     
    end.

    run calcularResumoEquipeCtrab in h-sfapi004   (input-output table tt-ctrab-rp,
                                                   input-output table tt-operador,
                                                   input-output table tt-operac-rp, 
                                                         output table tt-oper-ctrab,
                                                         output table tt-oper-ctrab-operac).


    find first tt-oper-ctrab no-lock no-error.             

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-param V-table-Win 
PROCEDURE pi-recebe-param :
def input param p-dat-inicio     as date no-undo.
def input param p-dat-fim        as date no-undo.

    assign da-dt-inicio   = p-dat-inicio
           da-dt-fim      = p-dat-fim.

    run pi-gera-tt.           

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
  {src/adm/template/snd-list.i "equipe-prod"}

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

