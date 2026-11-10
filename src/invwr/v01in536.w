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
{include/i-prgvrs.i V01IN536 2.00.00.011 } /*** "010011" 27/08/2024 08:50:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN536 MUT}
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

{sfc/sfapi004.i}  /** Temp-tables        **/

def temp-table tt-linha
    field sequencia as integer
    field cod-operador as char
    index seq is unique primary sequencia.

/*def buffer btt-ctrab-resumo for tt-ctrab-resumo.*/

def var h-sfapi004     as handle no-undo.
def var da-dt-inicio   like area-produc-ctrab.dat-inic-valid no-undo.
def var da-dt-fim      like area-produc-ctrab.dat-fim-valid no-undo.
def var c-cod-ctrab    like ctrab.cod-ctrab no-undo.
def var c-gm-codigo    like ctrab.gm-codigo no-undo.
def var log-parada-nef as logical no-undo.
def var log-parada-hex as logical no-undo.
def var rw-area-produc-ctrab as rowid   no-undo.

def var c-handle             as handle no-undo.
def var i-cont               as int no-undo.
def var i-aux                as int no-undo.
def var i-index              as int no-undo.
def var l-expande            as log init no  no-undo.
def var l-geral              as log init yes no-undo.
def var c-liter-operador     as char.
def var c-liter-tempo-reptdo as char.
def var c-liter-tempo-padrao as char.
def var c-liter-fator-refgdo as char.
def var c-liter-fator-retrab as char.
def var c-liter-fator-efic   as char.
def var c-liter-item         as char.
def var c-liter-rot          as char.
def var c-liter-tempo-real   as char.
def var c-liter-qtd-reptdo   as char.
def var c-liter-carga-reptda as char.
def var de-tempo-dispon      as dec.
def var i-cont-aux           as int.
def var de-fator-carga       as dec.
def var c-legenda            as char.
def var de-max-carga         as int init 0.
def var c-liter-op           as char format "x(10)". 
def var de-tot-op            as dec.
def var de-perc              as dec.
def var nom-operador         like operador.nom-operador.

def var j              as int    no-undo.
def var c-liter-titulo as char   no-undo.

{utp/utapi013.i}
{cdg/cdg0666.i}

{utp/ut-4gltreeview.i}
DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES area-produc-ctrab
&Scoped-define FIRST-EXTERNAL-TABLE area-produc-ctrab

/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR area-produc-ctrab.
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
     SIZE 88.57 BY 10.79.


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
   External Tables: mgind.area-produc-ctrab
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
         HEIGHT             = 10.79
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

 



/* ************************  Control Triggers  ************************ */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Operaá∆o *}
assign c-liter-op = trim(return-value).

{utp/ut-liter.i Tempo_Reportado *}
assign c-liter-tempo-reptdo = trim(return-value).

{utp/ut-liter.i Qtd_Reportada *}
assign c-liter-qtd-reptdo = trim(return-value).

{utp/ut-liter.i Tempo_Padrao *}
assign c-liter-tempo-padrao= trim(return-value).

{utp/ut-liter.i Fator_Refugo *}
assign c-liter-fator-refgdo = trim(return-value).

{utp/ut-liter.i Fator_Retrab *}
assign c-liter-fator-retrab = trim(return-value).

{utp/ut-liter.i Carga_Reptda *}
assign c-liter-carga-reptda = trim(return-value).

{utp/ut-liter.i Fator_Efic *}
assign c-liter-fator-efic = trim(return-value).

{utp/ut-liter.i Operacao *}
assign c-liter-item = trim(return-value). 

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
  {src/adm/template/row-list.i "area-produc-ctrab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "area-produc-ctrab"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-4gltreeview) THEN DO:
        RUN destroyObject IN h-4gltreeview.
        DELETE PROCEDURE h-4gltreeview.
    END.

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

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(h-4gltreeview) THEN
      RUN emptyTree IN h-4gltreeview.

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

  assign da-dt-inicio = date(month(today),01,year(today))
         da-dt-fim    = today.

  // Carregando o componente treeview
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
      RUN resizeObject IN h-4gltreeview (9.65, 88.57).
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
  DEF VAR cDescNode AS CHAR NO-UNDO.
  DEF VAR cFont     AS CHAR NO-UNDO INIT "Font=2".
  DEF VAR cTooltip  AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if session:set-wait-state ("general") then.

  if avail area-produc-ctrab then do:
      
      RUN emptyTree IN h-4gltreeview.

      IF l-expande THEN
          ASSIGN cExpClp = "expanded".
      ELSE
          ASSIGN cExpClp = "collapsed".

      {utp/ut-liter.i Operador *}
      assign c-liter-operador = trim(return-value).

      assign i-aux  = 1
             i-cont = 1.

      for each tt-linha:
        delete tt-linha.
      end.    

      for each tt-oper-ctrab:

          ASSIGN cDescNode = c-liter-operador + " : " +
                             tt-oper-ctrab.cod-operador + " - " +  
                             c-liter-tempo-reptdo + " : " +
                             string(tt-oper-ctrab.qtd-tempo-reptdo,">>>9.99") + " - " + 
                             c-liter-tempo-padrao + " : " +
                             string(tt-oper-ctrab.qtd-tempo-padrao,">>>9.99") + " - " +
                             c-liter-fator-refgdo + " : " +
                             string(tt-oper-ctrab.fator-refugo,">>>9.99") + " - " + 
                             c-liter-fator-retrab + " : " +
                             string(tt-oper-ctrab.fator-retrab,">>>9.99") + " - " + 
                             c-liter-fator-efic + " : " +
                             string(tt-oper-ctrab.fator-eficienc,">>>9.99") + " - " +                           
                             c-liter-carga-reptda + " : " +
                             string(trunc(tt-oper-ctrab.carga-reptda,2)).

            ASSIGN cTooltip  = "tooltip= " + cDescNode.

            RUN pi-create-node (INPUT "e" + string (i-cont),
                                INPUT "",
                                INPUT cDescNode,
                                INPUT "image/treeview/tvpics/separator.bmp",
                                INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

          find tt-linha where tt-linha.sequencia = i-cont no-error.
          if  not avail tt-linha then do:
              create tt-linha.
              assign tt-linha.sequencia = i-cont
                     tt-linha.cod-operador = tt-oper-ctrab.cod-operador.
          end.

          assign i-aux  = i-cont
                 i-cont = i-cont + 1.

          for each tt-oper-ctrab-operac
              where tt-oper-ctrab-operac.cod-ctrab    = tt-oper-ctrab.cod-ctrab 
                and tt-oper-ctrab-operac.cod-operador = tt-oper-ctrab.cod-operador no-lock:

              ASSIGN cDescNode = c-liter-item + " : " +
                                 tt-oper-ctrab-operac.it-codigo + " / " +
                                 string(tt-oper-ctrab-operac.op-codigo) + " / " + 
                                 tt-oper-ctrab-operac.cod-roteiro + " - " +                                   
                                 c-liter-tempo-real + " : "  +
                                 string(tt-oper-ctrab-operac.qtd-tempo-real, ">>>9.99") + " - " +
                                 c-liter-tempo-padrao + " : " +
                                 string(tt-oper-ctrab-operac.qtd-tempo-padrao, ">>>9.99") + " - " +
                                 c-liter-fator-refgdo + " : " +
                                 string(tt-oper-ctrab-operac.fator-refugo, ">>>9.99") + " - " +
                                 c-liter-fator-retrab + " : " +
                                 string(tt-oper-ctrab-operac.fator-retrab, ">>>9.99") + " - " + 
                                 c-liter-qtd-reptdo + " : "  +                    
                                 string(tt-oper-ctrab-operac.qtd-reptdo, ">>>>>>9.99" ).

              ASSIGN cTooltip  = "tooltip= " + cDescNode.

              RUN pi-create-node (INPUT "p" + string(i-cont),
                                  INPUT "e" + string(i-aux),
                                  INPUT cDescNode,
                                  INPUT "image/treeview/tvpics/separator.bmp",
                                  INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

              assign i-cont = i-cont + 1.
          end.        
      end.
  end.

  RUN pi-atualizaTreeview IN THIS-PROCEDURE.

  IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN
        ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, "e1").

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

  if  avail area-produc-ctrab 
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

if  avail area-produc-ctrab then
    run pi-gera-tt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-clickTreeview V-table-Win 
PROCEDURE pi-clickTreeview :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if  substring (c-codigo-node, 1, 1) = "p" then
        assign l-geral = no.
    else
        assign l-geral = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhar V-table-Win 
PROCEDURE pi-detalhar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

find first tt-ctrab-rp no-lock no-error.
if avail tt-ctrab-rp then do:    
    run sfc/sf0708b.w (input table tt-ctrab-rp).     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa-planilha V-table-Win 
PROCEDURE pi-executa-planilha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i           AS INT INIT 1 NO-UNDO.
    DEFINE VARIABLE i-lin       AS INT INIT 1 NO-UNDO.
    DEFINE VARIABLE c-novo      AS CHAR       NO-UNDO.
    DEFINE VARIABLE p-arq       AS CHAR       NO-UNDO.    
    DEFINE VARIABLE l-cancela   AS LOG        NO-UNDO.

    {utp/ut-liter.i Centro_Trabalho_X_Operador_-_Equipe * R}
    assign c-liter-titulo = trim(return-value).
    
    EMPTY TEMP-TABLE tt-configuracao2.
    EMPTY TEMP-TABLE tt-planilha2.
    EMPTY TEMP-TABLE tt-dados.
    EMPTY TEMP-TABLE tt-formatar.
    EMPTY TEMP-TABLE tt-grafico2.
    EMPTY TEMP-TABLE tt-erros.
    
    if avail area-produc-ctrab then do:  

        {utp/ut-liter.i "Novo" *}
        assign c-novo = trim(return-value).
        
           SYSTEM-DIALOG GET-FILE p-arq
               FILTERS "*.xls" "*.xls",
                       "*.*" "*.*"
               ASK-OVERWRITE 
               DEFAULT-EXTENSION "dat"
               INITIAL-DIR session:temp-directory
               RETURN-TO-START-DIR
               SAVE-AS
               title c-novo
               USE-FILENAME 
               UPDATE l-cancela.
               
        if not l-cancela then return.
        
        CREATE tt-configuracao2.
        ASSIGN tt-configuracao2.versao-integracao   = 1
               tt-configuracao2.arquivo-num         = 1
               tt-configuracao2.arquivo             = p-arq
               tt-configuracao2.total-planilhas      = 1
               tt-configuracao2.exibir-construcao   = NO
               tt-configuracao2.abrir-excel-termino = yes
               tt-configuracao2.imprimir            = NO
               tt-configuracao2.orientacao          = 2.
               
        CREATE tt-planilha2.
        ASSIGN tt-planilha2.arquivo-num       = 1
               tt-planilha2.planilha-num      = 1
               tt-planilha2.planilha-nome     = 'Dados ' + string(1)
               tt-planilha2.linhas-grade      = YES
               tt-planilha2.formatar-planilha = yes
               tt-planilha2.formatar-faixa    = YES.
        
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num    = 1
               tt-dados.planilha-num   = 1
               tt-dados.celula-coluna  = 1
               tt-dados.celula-linha   = 1
               tt-dados.celula-formato = "@"
               tt-dados.celula-valor   = "SF0708 - " + c-liter-titulo.
    
        // Negrito linhas 1 a 2
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:I2"
               tt-formatar.atributo          = "Bold":U
               tt-formatar.valor             = "yes".
    
        // Primeira linha, vermelha
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:I1"
               tt-formatar.atributo          = "IColorIndex":U
               tt-formatar.valor             = "30".
    
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:I1"
               tt-formatar.atributo          = "FontSize":U
               tt-formatar.valor             = "13".
  
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:I1"
               tt-formatar.atributo          = "FColorIndex":U
               tt-formatar.valor             = "2".
  
        // Linha 2, azul  
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:I2"
               tt-formatar.atributo          = "IColorIndex":U
               tt-formatar.valor             = "25".
    
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:I2"
               tt-formatar.atributo          = "FColorIndex":U
               tt-formatar.valor             = "2".
  
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:I2"
               tt-formatar.atributo          = "FontSize":U
               tt-formatar.valor             = "10".
  
        ASSIGN i-lin = 2.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 1
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-operador.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 2
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-item.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 3
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-tempo-reptdo.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 4
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-tempo-padrao.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 5
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-fator-refgdo.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 6
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-fator-retrab.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 7
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-fator-efic.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 8
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-carga-reptda.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 9
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-qtd-reptdo.

        for each tt-oper-ctrab:
      
            ASSIGN i-lin = i-lin + 1.
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-formato       = '@'
                   tt-dados.celula-valor         = tt-oper-ctrab.cod-operador.
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 3
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-oper-ctrab.qtd-tempo-reptdo,">>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 4
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-oper-ctrab.qtd-tempo-padrao,">>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 5
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-oper-ctrab.fator-refugo,">>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 6
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-oper-ctrab.fator-retrab,">>>9.99").
                   
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 7
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-oper-ctrab.fator-eficienc,">>>9.99").  
                   
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 8
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(trunc(tt-oper-ctrab.carga-reptda,2)).

          for each tt-oper-ctrab-operac
              where tt-oper-ctrab-operac.cod-ctrab    = tt-oper-ctrab.cod-ctrab 
                and tt-oper-ctrab-operac.cod-operador = tt-oper-ctrab.cod-operador no-lock:
                
                    ASSIGN i-lin = i-lin + 1.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 2
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = tt-oper-ctrab-operac.it-codigo + " / " + string(tt-oper-ctrab-operac.op-codigo) + " / " + tt-oper-ctrab-operac.cod-roteiro.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 3
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-oper-ctrab-operac.qtd-tempo-real, ">>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 4
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-oper-ctrab-operac.qtd-tempo-padrao, ">>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 5
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-oper-ctrab-operac.fator-refugo, ">>>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 6
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-oper-ctrab-operac.fator-retrab, ">>>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 9
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-oper-ctrab-operac.qtd-reptdo, ">>>>>>9.99" ).
          end.        
      end.
      
        run utp/utapi013.p persistent set h-utapi013.

        RUN pi-execute3 IN h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                       INPUT-OUTPUT TABLE tt-planilha2,
                                       INPUT-OUTPUT TABLE tt-dados,
                                       INPUT-OUTPUT TABLE tt-formatar,
                                       INPUT-OUTPUT TABLE tt-grafico2,
                                       INPUT-OUTPUT TABLE tt-erros).
                                       
        if return-value = "NOK":U then do:
            for each tt-erros:
                create tt-erro.
                assign i-sequen = i-sequen + 1
                       tt-erro.i-sequen = i-sequen
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-error.
            end.
            run cdp/cd0666.w (input table tt-erro).
        end. 
                                     
        delete procedure h-utapi013.      
      
    end.

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

    find tt-ctrab-rp
         where tt-ctrab-rp.cod-ctrab = area-produc-ctrab.cod-ctrab no-error.


    if  not avail tt-ctrab-rp then do:
        find ctrab where ctrab.cod-ctrab = area-produc-ctrab.cod-ctrab no-lock no-error.

        create tt-ctrab-rp.
        assign tt-ctrab-rp.cod-area-produc  = area-produc-ctrab.cod-area-produc
               tt-ctrab-rp.descricao        = ctrab.des-ctrab
               tt-ctrab-rp.cod-ctrab        = area-produc-ctrab.cod-ctrab
               tt-ctrab-rp.gm-codigo        = area-produc-ctrab.gm-codigo
               tt-ctrab-rp.data-inicio      = max(da-dt-inicio, area-produc-ctrab.dat-inic-valid)
               tt-ctrab-rp.data-fim         = min(da-dt-fim, area-produc-ctrab.dat-fim-valid).
    end.
    else
        assign tt-ctrab-rp.data-fim  = min(da-dt-fim,area-produc-ctrab.dat-fim-valid).

    run calcularResumoCtrabOperador in h-sfapi004 (input-output table tt-ctrab-rp,
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
  {src/adm/template/snd-list.i "area-produc-ctrab"}

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

