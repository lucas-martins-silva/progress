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
{include/i-prgvrs.i V06IN513 2.00.00.014} /*** "010014" 26/12/2023 16:33:12 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v06in513 MUT}
&ENDIF

   

{cdp/cdcfgman.i}

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


{sfc/sfapi002.i}  /** Temp-tables        **/

def temp-table tt-linha
    field sequencia   as integer
    field it-codigo   like item.it-codigo
   &IF DEFINED(bf_man_204) &THEN         
        field cod-refer   like item.cod-refer   
   &ENDIF
    field cod-roteiro like rot-item.cod-roteiro
    field op-codigo   like operacao.op-codigo
    index seq is unique primary sequencia.

def var h-sfapi002     as handle no-undo.
def var da-dt-inicio   like area-produc-ctrab.dat-inic-valid no-undo.
def var da-dt-fim      like area-produc-ctrab.dat-fim-valid no-undo.
def var c-cod-ctrab    like ctrab.cod-ctrab no-undo.
def var c-it-codigo    like item.it-codigo  no-undo.
&IF DEFINED(bf_man_204) &THEN         
    def var c-cod-refer    like item.cod-refer  no-undo.
&ENDIF
def var log-parada-nef as logical no-undo.
def var rw-area-produc as rowid   no-undo.

def var c-liter-perc-parada  as char no-undo.
def var c-liter-qtd-aprov    as char no-undo.
def var c-liter-qtd-ret      as char no-undo.
def var c-liter-qtd-rep      as char no-undo.
def var c-liter-perc-refugo  as char no-undo.
def var c-liter-tp-real      as char no-undo.
def var c-liter-tp-padrao    as char no-undo.
def var c-liter-referencia   as char no-undo.
def var c-handle             as handle no-undo.
def var i-class              as int init 1 no-undo.
def var i-cont               as int no-undo.
def var i-aux                as int no-undo.
def var i-index              as int no-undo.
def var l-expande            as log init no  no-undo.
def var l-geral              as log init yes no-undo.
def var c-it-ferr            as char format "x(20)" no-undo.
def var c-ctrab-ferr         as char format "x(20)" no-undo.
def var c-it-desc            as char format "x(25)" no-undo.
def var de-fator-parada      as decimal format ">>9.99" no-undo.
def var de-fator-utiliz      as decimal format ">>9.99" no-undo.
def var de-ret-ref           like rep-oper-ctrab.qtd-operac-retrab no-undo.
def var de-reportada         like rep-oper-ctrab.qtd-operac-aprov no-undo.
def var de-perc-refugo       as decimal format ">>9.99" no-undo.

def var j              as int    no-undo.
def var c-liter-titulo as char   no-undo.
def var c-liter-ctrab  as char   no-undo.
def var c-liter-item   as char   no-undo.

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
&Scoped-define EXTERNAL-TABLES area-produc
&Scoped-define FIRST-EXTERNAL-TABLE area-produc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR area-produc.
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
   External Tables: mgind.area-produc
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

{utp/ut-liter.i Refugada * L}
assign c-liter-qtd-ret = trim(return-value).

{utp/ut-liter.i Reportada * R}
assign c-liter-qtd-rep = trim(return-value).

{utp/ut-liter.i Tp_Real * R}
assign c-liter-tp-real = trim(return-value).

{utp/ut-liter.i Tp_Padr∆o * R}
assign c-liter-tp-padrao = trim(return-value).

{utp/ut-liter.i Per_Refugo * R}
assign c-liter-perc-refugo = trim(return-value).

{utp/ut-field.i movind rep-oper-ctrab qtd-operac-aprov 02}
assign c-liter-qtd-aprov = trim(return-value).

{utp/ut-liter.i Referància *}
assign c-liter-referencia = trim(return-value).

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
  {src/adm/template/row-list.i "area-produc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "area-produc"}

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

  assign i-aux        = 1
         i-cont       = 1
         l-geral      = yes
         da-dt-inicio = TODAY
         da-dt-fim    = TODAY
         c-cod-ctrab  = "*"
       &IF DEFINED(bf_man_204) &THEN
         c-cod-refer  = "*"
       &ENDIF
         c-it-codigo  = "*".

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

  for each tt-linha:
      delete tt-linha.
  end.

  if avail area-produc then do:

      RUN emptyTree IN h-4gltreeview.

      IF l-expande THEN
          ASSIGN cExpClp = "expanded".
      ELSE
          ASSIGN cExpClp = "collapsed".

      assign i-aux  = 1
             i-cont = 1.

      case i-class:
          when 1 then do: 

              assign de-ret-ref     = 0
                     de-reportada   = 0
                     de-perc-refugo = 0.

              for each tt-operac-rp use-index ch-indice
                  where (tt-operac-rp.it-codigo = c-it-codigo
                         or c-it-codigo         = "*")
                  &IF DEFINED(bf_man_204) &THEN
                  AND (tt-operac-rp.cod-refer = c-cod-refer
                       or c-cod-refer         = "*")
                  &ENDIF
                  :

                  find first item
                      where item.it-codigo = tt-operac-rp.it-codigo no-lock no-error.

                  assign c-it-desc      = trim(tt-operac-rp.it-codigo)   + " - " + 
                                          trim(item.desc-item) 
                         de-ret-ref     = tt-operac-rp.qtd-retrab +
                                          tt-operac-rp.qtd-refgada
                         de-reportada   = tt-operac-rp.qtd-aprov +
                                          de-ret-ref
                         de-perc-refugo = de-ret-ref / de-reportada * 100.

                  IF tt-operac-rp.qtd-tempo-padrao = ? THEN
                      ASSIGN tt-operac-rp.qtd-tempo-padrao = 0.
                  IF tt-operac-rp.qtd-aprov = ? THEN
                      ASSIGN tt-operac-rp.qtd-aprov = 0.
                  IF tt-operac-rp.qtd-tempo-real = ? THEN
                      ASSIGN tt-operac-rp.qtd-tempo-real = 0.

                  ASSIGN cDescNode = string(c-it-desc,'x(25)') + " - " +
                                     &IF DEFINED(bf_man_204) &THEN
                                     c-liter-referencia + ": " +  string(tt-operac-rp.cod-refer,"x(08)") + " - " +
                                     &ENDIF
                                     c-liter-qtd-aprov + ": " +
                                     string(tt-operac-rp.qtd-aprov,"->,>>>,>>9.99") + " - " +
                                     c-liter-qtd-ret + ": " +
                                     string(de-ret-ref,">,>>>,>>9.99") + " - " +
                                     c-liter-qtd-rep + ": " +
                                     string(de-reportada,"->,>>>,>>9.99") + " - " +                                     
                                     c-liter-perc-refugo  + ": " +
                                     string(de-perc-refugo,">>9.99") + " - " +
                                     c-liter-tp-real  + ": " +
                                     string(tt-operac-rp.qtd-tempo-real,">>>9.99") + " - " +                                     
                                     c-liter-tp-padrao  + ": " +
                                     string(tt-operac-rp.qtd-tempo-padrao,"->>>9.99").

                  ASSIGN cTooltip  = "tooltip= " + cDescNode.

                  RUN pi-create-node (INPUT "e" + string (i-cont),
                                      INPUT "",
                                      INPUT cDescNode,
                                      INPUT "image/treeview/tvpics/separator.bmp",
                                      INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

                  find tt-linha
                      where tt-linha.sequencia = i-cont no-error.
                  if not avail tt-linha then do:
                      create tt-linha.
                      assign tt-linha.sequencia   = i-cont
                             tt-linha.it-codigo   = tt-operac-rp.it-codigo
                             &IF DEFINED(bf_man_204) &THEN
                             tt-linha.cod-refer   = tt-operac-rp.cod-refer
                             &ENDIF
                             tt-linha.cod-roteiro = tt-operac-rp.cod-roteiro
                             tt-linha.op-codigo   = tt-operac-rp.op-codigo.
                  END.

                  assign i-aux  = i-cont
                         i-cont = i-cont + 1.

                  assign de-ret-ref     = 0
                         de-reportada   = 0
                         de-perc-refugo = 0.

                  for each tt-operac-ctrab-rp
                      where tt-operac-ctrab-rp.it-codigo   = tt-operac-rp.it-codigo
                      &IF DEFINED(bf_man_204) &THEN
                      AND tt-operac-ctrab-rp.cod-refer   = tt-operac-rp.cod-refer
                      &ENDIF
                      and tt-operac-ctrab-rp.cod-roteiro = tt-operac-rp.cod-roteiro
                      and tt-operac-ctrab-rp.op-codigo   = tt-operac-rp.op-codigo:

                      IF tt-operac-ctrab-rp.qtd-tempo-padrao = ? THEN
                          ASSIGN tt-operac-ctrab-rp.qtd-tempo-padrao = 0.
                      IF tt-operac-ctrab-rp.qtd-aprov = ? THEN
                          ASSIGN tt-operac-ctrab-rp.qtd-aprov = 0.
                      IF tt-operac-ctrab-rp.qtd-tempo-real = ? THEN
                          ASSIGN tt-operac-ctrab-rp.qtd-tempo-real = 0.

                      assign c-ctrab-ferr   = trim(tt-operac-ctrab-rp.cod-ctrab)   + " - " + 
                                              trim(tt-operac-ctrab-rp.cod-ferr-prod)
                             de-ret-ref     = tt-operac-ctrab-rp.qtd-retrab +
                                              tt-operac-ctrab-rp.qtd-refgada
                             de-reportada   = tt-operac-ctrab-rp.qtd-aprov +
                                              de-ret-ref
                             de-perc-refugo = de-ret-ref / de-reportada * 100.

                      ASSIGN cDescNode = string(c-ctrab-ferr,'x(20)') + " - " + 
                                         c-liter-qtd-aprov + ": " +
                                         string(tt-operac-ctrab-rp.qtd-aprov,"->,>>>,>>9.99") + " - " +
                                         c-liter-qtd-ret + ": " +
                                         string(de-ret-ref,">,>>>,>>9.99") + " - " +
                                         c-liter-qtd-rep + ": " +
                                         string(de-reportada,"->,>>>,>>9.99") + " - " +
                                         c-liter-perc-refugo + ": " +
                                         string(de-perc-refugo,">>9.99") + " - " +
                                         c-liter-tp-real + ": " +
                                         string(tt-operac-ctrab-rp.qtd-tempo-real,">>>9.99") + " - " +                                                                                                                                                                    
                                         c-liter-tp-padrao    + ": " +
                                         string(tt-operac-ctrab-rp.qtd-tempo-padrao,"->>>9.99").
        
                      ASSIGN cTooltip  = "tooltip= " + cDescNode.

                      RUN pi-create-node (INPUT "p" + string(i-cont),
                                          INPUT "e" + string(i-aux),
                                          INPUT cDescNode,
                                          INPUT "image/treeview/tvpics/separator.bmp",
                                          INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

                      assign i-cont = i-cont + 1.
                  END.
              END.
          END.

          when 2 then do: 

              assign de-ret-ref     = 0
                     de-reportada   = 0
                     de-perc-refugo = 0.

              for each tt-operac-rp use-index ch-refugo
                  where (tt-operac-rp.it-codigo = c-it-codigo
                         or c-it-codigo         = "*")
                  &IF DEFINED(bf_man_204) &THEN
                  AND (tt-operac-rp.cod-refer = c-cod-refer
                       or c-cod-refer         = "*")
                  &ENDIF
                  :

                  find first item
                      where item.it-codigo = tt-operac-rp.it-codigo no-lock no-error.

                  assign c-it-desc      = trim(tt-operac-rp.it-codigo)   + " - " + 
                                          trim(item.desc-item) 
                                          &IF DEFINED(bf_man_204) &THEN
                                          + " - " +  TRIM(tt-operac-rp.cod-refer)   
                                          &ENDIF
                         de-ret-ref     = tt-operac-rp.qtd-retrab +
                                          tt-operac-rp.qtd-refgada
                         de-reportada   = tt-operac-rp.qtd-aprov +
                                          de-ret-ref
                         de-perc-refugo = de-ret-ref / de-reportada * 100.

                  
                  ASSIGN cDescNode = string(c-it-desc,'x(25)') + " - " +
                                     c-liter-qtd-aprov + ": " +
                                     string(tt-operac-rp.qtd-aprov,"->,>>>,>>9.99") + " - " +
                                     c-liter-qtd-ret + ": " +
                                     string(de-ret-ref,">,>>>,>>9.99") + " - " +
                                     c-liter-qtd-rep + ": " +
                                     string(de-reportada,"->,>>>,>>9.99") + " - " +                                     
                                     c-liter-perc-refugo  + ": " +
                                     string(de-perc-refugo,">>9.99") + " - " +
                                     c-liter-tp-real  + ": " +
                                     string(tt-operac-rp.qtd-tempo-real,">>>9.99") + " - " +                                     
                                     c-liter-tp-padrao  + ": " +
                                     string(tt-operac-rp.qtd-tempo-padrao,"->>>9.99").

                  ASSIGN cTooltip  = "tooltip= " + cDescNode.

                  RUN pi-create-node (INPUT "e" + string (i-cont),
                                      INPUT "",
                                      INPUT cDescNode,
                                      INPUT "image/treeview/tvpics/separator.bmp",
                                      INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

                  find tt-linha
                      where tt-linha.sequencia = i-cont no-error.

                  if not avail tt-linha then do:
                      create tt-linha.
                      assign tt-linha.sequencia   = i-cont
                             tt-linha.it-codigo   = tt-operac-rp.it-codigo
                             &IF DEFINED(bf_man_204) &THEN
                             tt-linha.cod-refer   = tt-operac-rp.cod-refer
                             &ENDIF
                             tt-linha.cod-roteiro = tt-operac-rp.cod-roteiro
                             tt-linha.op-codigo   = tt-operac-rp.op-codigo.
                  END.

                  assign i-aux  = i-cont
                         i-cont = i-cont + 1.

                  assign de-ret-ref     = 0
                         de-reportada   = 0
                         de-perc-refugo = 0.

                  for each tt-operac-ctrab-rp
                      where tt-operac-ctrab-rp.it-codigo   = tt-operac-rp.it-codigo
                      &IF DEFINED(bf_man_204) &THEN
                      AND tt-operac-ctrab-rp.cod-refer   = tt-operac-rp.cod-refer
                      &ENDIF
                      and tt-operac-ctrab-rp.cod-roteiro = tt-operac-rp.cod-roteiro
                      and tt-operac-ctrab-rp.op-codigo   = tt-operac-rp.op-codigo:

                      assign c-ctrab-ferr   = trim(tt-operac-ctrab-rp.cod-ctrab)   + " - " + 
                                              trim(tt-operac-ctrab-rp.cod-ferr-prod)
                             de-ret-ref     = tt-operac-ctrab-rp.qtd-retrab +
                                              tt-operac-ctrab-rp.qtd-refgada
                             de-reportada   = tt-operac-ctrab-rp.qtd-aprov +
                                              de-ret-ref
                             de-perc-refugo = de-ret-ref / de-reportada * 100.

                      ASSIGN cDescNode = string(c-ctrab-ferr,'x(20)') + " - " + 
                                         c-liter-qtd-aprov + ": " +
                                         string(tt-operac-ctrab-rp.qtd-aprov,"->,>>>,>>9.99") + " - " +
                                         c-liter-qtd-ret + ": " +
                                         string(de-ret-ref,">,>>>,>>9.99") + " - " +
                                         c-liter-qtd-rep + ": " +
                                         string(de-reportada,"->,>>>,>>9.99") + " - " +
                                         c-liter-perc-refugo + ": " +
                                         string(de-perc-refugo,">>9.99") + " - " +
                                         c-liter-tp-real + ": " +
                                         string(tt-operac-ctrab-rp.qtd-tempo-real,">>>9.99") + " - " +                                                                                                                                                                    
                                         c-liter-tp-padrao    + ": " +
                                         string(tt-operac-ctrab-rp.qtd-tempo-padrao,"->>>9.99").
        
                      ASSIGN cTooltip  = "tooltip= " + cDescNode.
        
                      RUN pi-create-node (INPUT "p" + string(i-cont),
                                          INPUT "e" + string(i-aux),
                                          INPUT cDescNode,
                                          INPUT "image/treeview/tvpics/separator.bmp",
                                          INPUT cExpClp + CHR(1) + cFont + CHR(1) + cTooltip).

                      
                      assign i-cont = i-cont + 1.
                  END.
              END.
          END.
      end case.
  END.

  RUN pi-atualizaTreeview IN THIS-PROCEDURE.

  IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN
      ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, "e1").

  if DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) then
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

  if  avail area-produc 
  and valid-handle(h-sfapi002) then
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

assign h-sfapi002 = p-handle.

if  avail area-produc then
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
    
    {utp/ut-liter.i Produá∆o_Por_Item * R}
    assign c-liter-titulo = trim(return-value).
    
    {utp/ut-liter.i Centro_Trabalho * R}
    assign c-liter-ctrab = trim(return-value).
    
    {utp/ut-liter.i Item * R}
    assign c-liter-item = trim(return-value).
    
    EMPTY TEMP-TABLE tt-configuracao2.
    EMPTY TEMP-TABLE tt-planilha2.
    EMPTY TEMP-TABLE tt-dados.
    EMPTY TEMP-TABLE tt-formatar.
    EMPTY TEMP-TABLE tt-grafico2.
    EMPTY TEMP-TABLE tt-erros.
    
    if avail area-produc then do:
    
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
               tt-configuracao2.total-planilha      = 1
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
               tt-dados.celula-valor   = "SF0706 - " + c-liter-titulo.
    
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
               tt-dados.celula-valor         = c-liter-item.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 2
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-ctrab.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 3
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         =  c-liter-referencia.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 4
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-qtd-aprov.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 5
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-qtd-ret.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 6
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-qtd-rep.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 7
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-perc-refugo.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 8
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-tp-real.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 9
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-tp-padrao.

        case i-class:
            when 1 then do:

                assign de-ret-ref     = 0
                       de-reportada   = 0
                       de-perc-refugo = 0.

                for each tt-operac-rp use-index ch-indice
                    where (tt-operac-rp.it-codigo = c-it-codigo
                           or c-it-codigo         = "*")
                    &IF DEFINED(bf_man_204) &THEN
                    AND (tt-operac-rp.cod-refer = c-cod-refer
                         or c-cod-refer         = "*")
                    &ENDIF
                    :

                    find first item
                        where item.it-codigo = tt-operac-rp.it-codigo no-lock no-error.
                    
                    assign c-it-desc      = trim(tt-operac-rp.it-codigo)   + " - " + 
                                            trim(item.desc-item) 
                           de-ret-ref     = tt-operac-rp.qtd-retrab +
                                            tt-operac-rp.qtd-refgada
                           de-reportada   = tt-operac-rp.qtd-aprov +
                                            de-ret-ref
                           de-perc-refugo = de-ret-ref / de-reportada * 100.
                    
                    IF tt-operac-rp.qtd-tempo-padrao = ? THEN
                        ASSIGN tt-operac-rp.qtd-tempo-padrao = 0.
                    IF tt-operac-rp.qtd-aprov = ? THEN
                        ASSIGN tt-operac-rp.qtd-aprov = 0.
                    IF tt-operac-rp.qtd-tempo-real = ? THEN
                        ASSIGN tt-operac-rp.qtd-tempo-real = 0.
                      
                    ASSIGN i-lin = i-lin + 1.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = '@'
                           tt-dados.celula-valor         = string(c-it-desc,'x(25)').
                           
                    &IF DEFINED(bf_man_204) &THEN      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 3
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = '@'
                               tt-dados.celula-valor         = string(tt-operac-rp.cod-refer,"x(08)").
                    &ENDIF
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 4
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-aprov,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 5
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-ret-ref,">,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 6
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-reportada,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 7
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-perc-refugo,">>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 8
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-tempo-real,">>>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 9
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-tempo-padrao,"->>>9.99").

                    assign de-ret-ref     = 0
                           de-reportada   = 0
                           de-perc-refugo = 0.

                    for each tt-operac-ctrab-rp
                        where tt-operac-ctrab-rp.it-codigo   = tt-operac-rp.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                        AND tt-operac-ctrab-rp.cod-refer   = tt-operac-rp.cod-refer
                        &ENDIF
                        and tt-operac-ctrab-rp.cod-roteiro = tt-operac-rp.cod-roteiro
                        and tt-operac-ctrab-rp.op-codigo   = tt-operac-rp.op-codigo:
  
                        IF tt-operac-ctrab-rp.qtd-tempo-padrao = ? THEN
                            ASSIGN tt-operac-ctrab-rp.qtd-tempo-padrao = 0.
                        IF tt-operac-ctrab-rp.qtd-aprov = ? THEN
                            ASSIGN tt-operac-ctrab-rp.qtd-aprov = 0.
                        IF tt-operac-ctrab-rp.qtd-tempo-real = ? THEN
                            ASSIGN tt-operac-ctrab-rp.qtd-tempo-real = 0.

                        assign c-ctrab-ferr   = trim(tt-operac-ctrab-rp.cod-ctrab)   + " - " + 
                                                trim(tt-operac-ctrab-rp.cod-ferr-prod)
                               de-ret-ref     = tt-operac-ctrab-rp.qtd-retrab +
                                                tt-operac-ctrab-rp.qtd-refgada
                               de-reportada   = tt-operac-ctrab-rp.qtd-aprov +
                                                de-ret-ref
                               de-perc-refugo = de-ret-ref / de-reportada * 100.
                               
                        ASSIGN i-lin = i-lin + 1.
  
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 2
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = '@'
                               tt-dados.celula-valor         = string(c-ctrab-ferr,'x(20)').
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 4
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-aprov,"->,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 5
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-ret-ref,">,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 6
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-reportada,"->,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 7
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-perc-refugo,">>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 8
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-tempo-real,">>>9.99").
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 9
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-tempo-padrao,"->>>9.99").
                    END.
                END.
            END.

            when 2 then do: 

                assign de-ret-ref     = 0
                       de-reportada   = 0
                       de-perc-refugo = 0.
                
                for each tt-operac-rp use-index ch-refugo
                    where (tt-operac-rp.it-codigo = c-it-codigo
                           or c-it-codigo         = "*")
                    &IF DEFINED(bf_man_204) &THEN
                    AND (tt-operac-rp.cod-refer = c-cod-refer
                         or c-cod-refer         = "*")
                    &ENDIF
                    :
            
                    find first item
                        where item.it-codigo = tt-operac-rp.it-codigo no-lock no-error.
                    
                    assign c-it-desc      = trim(tt-operac-rp.it-codigo)   + " - " + 
                                            trim(item.desc-item) 
                                            &IF DEFINED(bf_man_204) &THEN
                                            + " - " +  TRIM(tt-operac-rp.cod-refer)   
                                            &ENDIF
                           de-ret-ref     = tt-operac-rp.qtd-retrab +
                                            tt-operac-rp.qtd-refgada
                           de-reportada   = tt-operac-rp.qtd-aprov +
                                            de-ret-ref
                           de-perc-refugo = de-ret-ref / de-reportada * 100.
                             
                                          ASSIGN i-lin = i-lin + 1.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = '@'
                           tt-dados.celula-valor         = string(c-it-desc,'x(25)').
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 4
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-aprov,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 5
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-ret-ref,">,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 6
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-reportada,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 7
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(de-perc-refugo,">>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 8
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-tempo-real,">>>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 9
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-operac-rp.qtd-tempo-padrao,"->>>9.99").

                    assign de-ret-ref     = 0
                           de-reportada   = 0
                           de-perc-refugo = 0.
                    
                    for each tt-operac-ctrab-rp
                        where tt-operac-ctrab-rp.it-codigo   = tt-operac-rp.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                        AND tt-operac-ctrab-rp.cod-refer   = tt-operac-rp.cod-refer
                        &ENDIF
                        and tt-operac-ctrab-rp.cod-roteiro = tt-operac-rp.cod-roteiro
                        and tt-operac-ctrab-rp.op-codigo   = tt-operac-rp.op-codigo:
                    
                        assign c-ctrab-ferr   = trim(tt-operac-ctrab-rp.cod-ctrab)   + " - " + 
                                                trim(tt-operac-ctrab-rp.cod-ferr-prod)
                               de-ret-ref     = tt-operac-ctrab-rp.qtd-retrab +
                                                tt-operac-ctrab-rp.qtd-refgada
                               de-reportada   = tt-operac-ctrab-rp.qtd-aprov +
                                                de-ret-ref
                               de-perc-refugo = de-ret-ref / de-reportada * 100.
                               
                        ASSIGN i-lin = i-lin + 1.
  
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 2
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = '@'
                               tt-dados.celula-valor         = string(c-ctrab-ferr,'x(20)').
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 4
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-aprov,"->,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 5
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-ret-ref,">,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 6
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-reportada,"->,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 7
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(de-perc-refugo,">>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 8
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-tempo-real,">>>9.99").
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 9
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-operac-ctrab-rp.qtd-tempo-padrao,"->>>9.99").       

                  END.
              END.
          END.
      end case.
      
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
                assign i-seq = i-seq + 1
                       tt-erro.i-sequen = i-seq
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro.
            end.
            run cdp/cd0666.w (input table tt-erro).
        end. 
                                     
        delete procedure h-utapi013.
    END.

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
for each tt-ctrab-rp:
        delete tt-ctrab-rp.
    end.

    for each tt-operac-rp:
        delete tt-operac-rp.
    end.

    for each tt-operac-ctrab-rp:
        delete tt-operac-ctrab-rp.
    end.

    for each area-produc-ctrab
        where area-produc-ctrab.cod-area-produc = area-produc.cod-area-produc
          and area-produc-ctrab.dat-inic-valid <= da-dt-fim
          and area-produc-ctrab.dat-fim-valid  >  da-dt-inicio
          and (area-produc-ctrab.cod-ctrab      = c-cod-ctrab
               or c-cod-ctrab                   = "*") no-lock:

        find ctrab where ctrab.cod-ctrab = area-produc-ctrab.cod-ctrab no-lock.  

        create tt-ctrab-rp.
        assign tt-ctrab-rp.cod-area         = area-produc-ctrab.cod-area-produ
               tt-ctrab-rp.gm-codigo        = ctrab.gm-codigo
               tt-ctrab-rp.cod-ctrab        = ctrab.cod-ctrab
               tt-ctrab-rp.descricao        = ctrab.des-ctrab
               tt-ctrab-rp.data-inicio      = max(da-dt-inicio, area-produc-ctrab.dat-inic-valid)
               tt-ctrab-rp.data-fim         = min(da-dt-fim,area-produc-ctrab.dat-fim-valid)
               tt-ctrab-rp.qtd-capac-ctrab  = ctrab.qtd-capac-ctrab.
    end.  

    &IF DEFINED(bf_man_204) &THEN
    run RecebeReferencia in h-sfapi002 (INPUT c-cod-refer).
    &ENDIF

    run calcularResumoProducao in h-sfapi002 (input-output table tt-ctrab-rp,
                                              input-output table tt-operac-rp,
                                              input-output table tt-operac-ctrab-rp).
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-param V-table-Win 
PROCEDURE pi-recebe-param :
def input param p-cod-ctrab      as char no-undo.
    def input param p-it-codigo      as char no-undo.
    def input param p-dat-inicio     as date no-undo.
    def input param p-dat-fim        as date no-undo.
    &IF DEFINED(bf_man_204) &THEN
    def input param p-cod-refer      as CHAR no-undo.
    &ENDIF

    assign da-dt-inicio   = p-dat-inicio
           da-dt-fim      = p-dat-fim
           c-cod-ctrab    = p-cod-ctrab
          &IF DEFINED(bf_man_204) &THEN
           c-cod-refer    = p-cod-refer
          &ENDIF
           c-it-codigo    = p-it-codigo.


    run pi-gera-tt.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-class V-table-Win 
PROCEDURE pi-troca-class :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-param      as int no-undo.
    def input param p-cod-ctrab  as char no-undo.
    def input param p-dat-inicio as date no-undo.
    def input param p-dat-fim    as date no-undo.

    assign i-class      = i-param
           c-cod-ctrab  = p-cod-ctrab
           da-dt-inicio = p-dat-inicio
           da-dt-fim    = p-dat-fim.

    find first tt-operac-rp no-lock no-error.

    if  avail tt-operac-rp then 
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    else
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
  {src/adm/template/snd-list.i "area-produc"}

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

