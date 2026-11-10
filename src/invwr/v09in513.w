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
{include/i-prgvrs.i V09IN513 2.00.00.009} /*** "010009" 26/12/2023 08:19:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN513 MUT}
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

{sfc/sfapi003.i}  /** Temp-tables        **/


def temp-table tt-linha
    field sequencia        as integer
    field cod-motiv-refugo as char
    field it-codigo        as char
   &IF DEFINED(bf_man_204) &THEN         
        field cod-refer   like item.cod-refer   
   &ENDIF
    field cod-roteiro      as char
    field op-codigo        as int
    field cod-ctrab        as char
    field tipo-reg         as int
    index seq is unique primary sequencia.

def var da-dt-inicio         like area-produc-ctrab.dat-inic-valid no-undo.
def var da-dt-fim            like area-produc-ctrab.dat-fim-valid  no-undo.
def var c-cod-ctrab          like ctrab.cod-ctrab                  no-undo.
DEF VAR c-it-codigo          LIKE ITEM.it-codigo                   NO-UNDO.
&IF DEFINED(bf_man_204) &THEN         
DEF VAR c-cod-refer          LIKE ord-prod.cod-refer               NO-UNDO.
&ENDIF
def var h-sfapi003           as handle              no-undo.
def var c-handle             as handle              no-undo.
def var i-class              as int init 1          no-undo.
def var i-cont               as int                 no-undo.
def var i-aux                as int                 no-undo.
def var i-aux1               as int                 no-undo.
def var i-index              as int                 no-undo.
def var l-expande            as log init no         no-undo.
def var l-geral              as log init yes        no-undo.
def var c-aux                as char                no-undo.
def var c-perc-ref           as char format 'x(08)' no-undo.
def var c-perc-ret           as char format 'x(08)' no-undo.
def var c-qtd-refgda         as char format 'x(08)' no-undo.
def var c-qtd-retrab         as char format 'x(10)' no-undo.
def var c-qtd-reptda         as char format "x(10)" no-undo.
def var c-desc-op            like operacao.descricao no-undo.
def var c-rot                as char format "x(30)"  no-undo.
def var de-qtd-reptda        like rep-oper-ctrab.qtd-operac-reptda no-undo.

def var j                     as int    no-undo.
def var c-liter-titulo        as char   no-undo.
def var c-liter-op-rot-item   as char   no-undo.
def var c-liter-motivo-refugo as char   no-undo.
def var c-liter-ctrab         as char   no-undo.

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
&Scoped-Define ENABLED-OBJECTS RECT-17 

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
DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     RECT-17 AT ROW 1 COL 1 WIDGET-ID 2
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

{utp/ut-liter.i %_Refugo                               * R} assign c-perc-ref   = trim(return-value).
{utp/ut-liter.i %_Retrab                               * R} assign c-perc-ret   = trim(return-value).
{utp/ut-field.i movind rep-oper-ctrab qtd-operac-refgda 02} assign c-qtd-refgda = return-value.
{utp/ut-field.i movind rep-oper-ctrab qtd-operac-retrab 02} assign c-qtd-retrab = return-value.
{utp/ut-field.i movind rep-oper-ctrab qtd-operac-reptda 02} assign c-qtd-reptda = return-value.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if session:set-wait-state ("general") then.

    for each tt-linha:
        delete tt-linha.
    end.

    if  avail area-produc then do:

        EMPTY TEMP-TABLE tt-linha.

        RUN emptyTree IN h-4gltreeview.

        IF l-expande THEN
            ASSIGN cExpClp = "expanded".
        ELSE
            ASSIGN cExpClp = "collapsed".
            
        assign i-aux  = 1
               i-cont = 1.

        for each tt-operac use-index operacao no-lock:  

            assign c-rot = tt-operac.it-codigo + "/" +
                &IF DEFINED(bf_man_204) &THEN
                           string(tt-operac.cod-refer,"x(08)") + "/" +
                &ENDIF
                           if   tt-operac.cod-roteiro <> ""
                           then tt-operac.cod-roteiro + "/" +
                                string(tt-operac.op-codigo)
                           else string(tt-operac.op-codigo)
                   de-qtd-reptda = tt-operac.qtd-aprov + tt-operac.qtd-refgda + tt-operac.qtd-retrab.

            find first operacao
                  where operacao.op-codigo   = tt-operac.op-codigo
                    and operacao.cod-roteiro = tt-operac.cod-roteiro
                    and operacao.it-codigo   = tt-operac.it-codigo 
                &IF DEFINED(bf_man_204) &THEN
                    AND operacao.cod-refer   = tt-operac.cod-refer 
                &ENDIF
                no-lock no-error.
            assign c-desc-op = if avail operacao then operacao.descricao else "".

            RUN pi-create-node (INPUT "e" + string (i-cont),
                                INPUT "",
                                INPUT string(c-rot,"x(25)")     + " - " +
                                      string(c-desc-op,"x(25)") + " - " + 
                                      c-qtd-reptda + ": "  + string(de-qtd-reptda,"->,>>>,>>9.99")        + " - " +
                                      c-qtd-refgda + ": "  + string(tt-operac.qtd-refgda,"->,>>>,>>9.99") + " - " +
                                      c-qtd-retrab + ": "  + string(tt-operac.qtd-retrab,">,>>>,>>9.99")  + " - " +
                                      c-perc-ref   + ": "  + string(tt-operac.fator-refugo,">>9.99")      + " - " +
                                      c-perc-ret   + ": "  + string(tt-operac.fator-retrab,">>9.99"),
                                INPUT "image/treeview/tvpics/separator.bmp",
                                INPUT cExpClp + CHR(1) + "Font=2").

            find tt-linha
                 where tt-linha.sequencia = i-cont no-error.
            if  not avail tt-linha then do:
                create tt-linha.
                assign tt-linha.sequencia   = i-cont
                       tt-linha.it-codigo   = tt-operac.it-codigo
                    &IF DEFINED(bf_man_204) &THEN
                       tt-linha.cod-refer   = tt-operac.cod-refer
                    &ENDIF
                       tt-linha.cod-roteiro = tt-operac.cod-roteiro
                       tt-linha.op-codigo   = tt-operac.op-codigo
                       tt-linha.tipo-reg    = 1.
            end.

            assign i-aux  = i-cont
                   i-cont = i-cont + 1.

            if i-class = 1 then do:
                for each  tt-refugo-operac
                    where tt-refugo-operac.it-codigo   = tt-operac.it-codigo
                    &IF DEFINED(bf_man_204) &THEN
                      AND tt-refugo-operac.cod-refer   = tt-operac.cod-refer
                    &ENDIF
                      and tt-refugo-operac.cod-roteiro = tt-operac.cod-roteiro
                      and tt-refugo-operac.op-codigo   = tt-operac.op-codigo no-lock:

                    find motiv-refugo
                        where motiv-refugo.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo
                        no-lock no-error.

                    RUN pi-create-node (INPUT "e" + STRING(i-cont),
                                        INPUT "e" + STRING(i-aux),
                                        INPUT STRING(tt-refugo-operac.cod-motiv-refugo,"x(8)") + " - " +
                                              STRING(motiv-refugo.des-motiv-refugo,"x(40)")    + " - " +
                                              c-qtd-refgda + ": " + STRING(tt-refugo-operac.qtd-refgda,"->,>>>,>>9.99") + " - " +
                                              c-qtd-retrab + ": " + STRING(tt-refugo-operac.qtd-retrab,">,>>>,>>9.99")  + " - " +
                                              c-perc-ref   + ": " + STRING(tt-refugo-operac.fator-refugo,">>9.99")      + " - " +
                                              c-perc-ret   + ": " + STRING(tt-refugo-operac.fator-retrab,">>9.99"),
                                        INPUT "image/treeview/tvpics/separator.bmp",
                                        INPUT cExpClp + CHR(1) + "Font=2").

                    find tt-linha
                        where tt-linha.sequencia = i-cont no-error.
                    if  not avail tt-linha then do:
                        create tt-linha.
                        assign tt-linha.sequencia        = i-cont
                               tt-linha.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo
                               tt-linha.it-codigo        = tt-refugo-operac.it-codigo
                            &IF DEFINED(bf_man_204) &THEN
                               tt-linha.cod-refer        = tt-refugo-operac.cod-refer
                            &ENDIF                            
                               tt-linha.cod-roteiro      = tt-refugo-operac.cod-roteiro
                               tt-linha.op-codigo        = tt-refugo-operac.op-codigo
                               tt-linha.tipo-reg         = 2.
                    end.

                    assign i-aux1 = i-cont
                           i-cont = i-cont + 1.

                    for each tt-ref-oper-ctrab use-index operacao
                        where tt-ref-oper-ctrab.it-codigo        = tt-refugo-operac.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                          AND tt-ref-oper-ctrab.cod-refer        = tt-refugo-operac.cod-refer
                        &ENDIF
                          and tt-ref-oper-ctrab.cod-roteiro      = tt-refugo-operac.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo        = tt-refugo-operac.op-codigo
                          and tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo no-lock: 

                        find ctrab
                             where ctrab.cod-ctrab = tt-ref-oper-ctrab.cod-ctrab no-lock.

                        RUN pi-create-node (INPUT "e" + STRING(i-cont),
                                            INPUT "e" + STRING(i-aux1),
                                            INPUT STRING(tt-ref-oper-ctrab.cod-ctrab,"x(16)") + " - " + 
                                                  STRING(ctrab.des-ctrab,"x(40)")             + " - " +
                                                  c-qtd-refgda + ": " + STRING(tt-ref-oper-ctrab.qtd-refgda,"->,>>>,>>9.99") + " - " +
                                                  c-qtd-retrab + ": " + STRING(tt-ref-oper-ctrab.qtd-retrab,">,>>>,>>9.99")  + " - " +
                                                  c-perc-ref   + ": " + STRING(tt-ref-oper-ctrab.fator-refugo,">>9.99")      + " - " + 
                                                  c-perc-ret   + ": " + STRING(tt-ref-oper-ctrab.fator-retrab,">>9.99"),
                                            INPUT "image/treeview/tvpics/separator.bmp",
                                            INPUT cExpClp + CHR(1) + "Font=2").

                        assign i-cont = i-cont + 1.
                    end.
                end.
            end.
            else do:
                for each tt-operac-ctrab use-index op-ctrab
                    where tt-operac-ctrab.it-codigo   = tt-operac.it-codigo
                    &IF DEFINED(bf_man_204) &THEN
                      AND tt-operac-ctrab.cod-refer   = tt-operac.cod-refer
                    &ENDIF
                      and tt-operac-ctrab.cod-roteiro = tt-operac.cod-roteiro
                      and tt-operac-ctrab.op-codigo   = tt-operac.op-codigo no-lock: 

                    find first ctrab
                         where ctrab.cod-ctrab = tt-operac-ctrab.cod-ctrab no-lock no-error.

                    RUN pi-create-node (INPUT "e" + string(i-cont),
                                        INPUT "e" + string(i-aux),
                                        INPUT STRING(tt-operac-ctrab.cod-ctrab,"x(16)") + " - " + 
                                              STRING(ctrab.des-ctrab,"x(40)")           + " - " +
                                              c-qtd-reptda + ": " + STRING(tt-operac-ctrab.qtd-reptda,"->,>>>,>>9.99")   + " - " +
                                              c-qtd-refgda + ": " + STRING(tt-operac-ctrab.qtd-refgda,"->,>>>,>>9.99")  + " - " +
                                              c-qtd-retrab + ": " + STRING(tt-operac-ctrab.qtd-retrab,">,>>>,>>9.99") + " - " +
                                              c-perc-ref   + ": " + STRING(tt-operac-ctrab.fator-refugo,">>9.99")      + " - " +
                                              c-perc-ret   + ": " + STRING(tt-operac-ctrab.fator-retrab,">>9.99"),
                                        INPUT "image/treeview/tvpics/separator.bmp",
                                        INPUT cExpClp + CHR(1) + "Font=2").

                    find tt-linha
                        where tt-linha.sequencia = i-cont no-error.
                    if  not avail tt-linha then do:
                        create tt-linha.
                        assign tt-linha.sequencia   = i-cont
                               tt-linha.cod-ctrab   = tt-operac-ctrab.cod-ctrab
                               tt-linha.it-codigo   = tt-operac-ctrab.it-codigo
                            &IF DEFINED(bf_man_204) &THEN
                               tt-linha.cod-refer   = tt-operac-ctrab.cod-refer
                            &ENDIF
                               tt-linha.cod-roteiro = tt-operac-ctrab.cod-roteiro
                               tt-linha.op-codigo   = tt-operac-ctrab.op-codigo
                               tt-linha.tipo-reg    = 2.
                    end.

                    assign i-aux1 = i-cont
                           i-cont = i-cont + 1.

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.it-codigo   = tt-operac-ctrab.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                          AND tt-ref-oper-ctrab.cod-refer   = tt-operac-ctrab.cod-refer
                        &ENDIF
                          and tt-ref-oper-ctrab.cod-roteiro = tt-operac-ctrab.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo   = tt-operac-ctrab.op-codigo
                          and tt-ref-oper-ctrab.cod-ctrab   = tt-operac-ctrab.cod-ctrab no-lock: 

                        find motiv-refugo
                            where motiv-refugo.cod-motiv-refugo = tt-ref-oper-ctrab.cod-motiv-refugo
                            no-lock no-error.

                        RUN pi-create-node (INPUT "e" + string(i-cont),
                                            INPUT "e" + string(i-aux1),
                                            INPUT STRING(tt-ref-oper-ctrab.cod-motiv-refugo,"x(8)") + " - " +
                                                  STRING(motiv-refugo.des-motiv-refugo,"x(40)")     + " - " +
                                                  c-qtd-refgda + ": " + STRING(tt-ref-oper-ctrab.qtd-refgda,"->,>>>,>>9.99")  + " - " +
                                                  c-qtd-retrab + ": " + STRING(tt-ref-oper-ctrab.qtd-retrab,">,>>>,>>9.99") + " - " +
                                                  c-perc-ref   + ": " + STRING(tt-ref-oper-ctrab.fator-refugo,">>9.99")      + " - " +
                                                  c-perc-ret   + ": " + STRING(tt-ref-oper-ctrab.fator-retrab,">>9.99"),
                                            INPUT "image/treeview/tvpics/separator.bmp",
                                            INPUT cExpClp + CHR(1) + "Font=2").

                        assign i-cont = i-cont + 1.
                    end.
                end.                
            end.
        end.

        IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN
            ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, "e1").
    end.   

    if DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) then
        run pi-habilita-expande in c-handle(input yes).
    else
        run pi-habilita-expande in c-handle(input no).

    if  session:set-wait-state ("") then.

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
  and valid-handle(h-sfapi003) then
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

assign h-sfapi003 = p-handle.

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

    if substring (c-aux, 1, 1) = "p" then
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

    {utp/ut-liter.i Resumo_Refugo_-_Operaá∆o * R}
    assign c-liter-titulo = trim(return-value).
    
    {utp/ut-liter.i Op_Roteiro_Item * R}
    assign c-liter-op-rot-item = trim(return-value).
    
    {utp/ut-liter.i Motivo_Refugo * R}
    assign c-liter-motivo-refugo = trim(return-value).
    
    {utp/ut-liter.i Centro_Trabalho * R}
    ASSIGN c-liter-ctrab = trim(return-value).
    
    EMPTY TEMP-TABLE tt-configuracao2.
    EMPTY TEMP-TABLE tt-planilha2.
    EMPTY TEMP-TABLE tt-dados.
    EMPTY TEMP-TABLE tt-formatar.
    EMPTY TEMP-TABLE tt-grafico2.
    EMPTY TEMP-TABLE tt-erros.
    
    if  avail area-produc then do:

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
               tt-dados.celula-valor   = "SF0707 - " + c-liter-titulo.
    
        // Negrito linhas 1 a 2
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:H2"
               tt-formatar.atributo          = "Bold":U
               tt-formatar.valor             = "yes".
    
        // Primeira linha, vermelha
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:H1"
               tt-formatar.atributo          = "IColorIndex":U
               tt-formatar.valor             = "30".
    
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:H1"
               tt-formatar.atributo          = "FontSize":U
               tt-formatar.valor             = "13".
  
        CREATE tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A1:H1"
               tt-formatar.atributo          = "FColorIndex":U
               tt-formatar.valor             = "2".
  
        // Linha 2, azul  
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:H2"
               tt-formatar.atributo          = "IColorIndex":U
               tt-formatar.valor             = "25".
    
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:H2"
               tt-formatar.atributo          = "FColorIndex":U
               tt-formatar.valor             = "2".
  
        create tt-formatar.
        assign tt-formatar.arquivo-num       = 1
               tt-formatar.planilha-num      = 1
               tt-formatar.faixa             = "A2:H2"
               tt-formatar.atributo          = "FontSize":U
               tt-formatar.valor             = "10".
  
        ASSIGN i-lin = 2.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 1
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-liter-op-rot-item.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = IF i-class = 1 THEN 2 ELSE 3
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-liter-motivo-refugo.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = IF i-class = 1 THEN 3 ELSE 2
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-liter-ctrab.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 4
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-qtd-reptda.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 5
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-qtd-refgda.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 6
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-qtd-retrab.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 7
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-perc-ref.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 8
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-formato       = '@'
               tt-dados.celula-valor         = c-perc-ret.

        for each tt-operac use-index operacao no-lock:  

            assign c-rot = tt-operac.it-codigo + "/" +
                &IF DEFINED(bf_man_204) &THEN
                           string(tt-operac.cod-refer,"x(08)") + "/" +
                &ENDIF
                           if   tt-operac.cod-roteiro <> ""
                           then tt-operac.cod-roteiro + "/" +
                                string(tt-operac.op-codigo)
                           else string(tt-operac.op-codigo)
                   de-qtd-reptda = tt-operac.qtd-aprov + tt-operac.qtd-refgda + tt-operac.qtd-retrab.

            find first operacao
                  where operacao.op-codigo   = tt-operac.op-codigo
                    and operacao.cod-roteiro = tt-operac.cod-roteiro
                    and operacao.it-codigo   = tt-operac.it-codigo 
                &IF DEFINED(bf_man_204) &THEN
                    AND operacao.cod-refer   = tt-operac.cod-refer 
                &ENDIF
                no-lock no-error.
            assign c-desc-op = if avail operacao then operacao.descricao else "".
        
            ASSIGN i-lin = i-lin + 1.
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-formato       = '@'
                   tt-dados.celula-valor         = c-rot + " - " + c-desc-op.
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 4
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(de-qtd-reptda,"->,>>>,>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 5
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-operac.qtd-refgda,"->,>>>,>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 6
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-operac.qtd-retrab,">,>>>,>>9.99").
  
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 7
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-operac.fator-refugo,">>9.99").
                   
            CREATE tt-dados.
            ASSIGN tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = 8
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-operac.fator-retrab,">>9.99").

            if i-class = 1 then do:
                for each  tt-refugo-operac
                    where tt-refugo-operac.it-codigo   = tt-operac.it-codigo
                    &IF DEFINED(bf_man_204) &THEN
                      AND tt-refugo-operac.cod-refer   = tt-operac.cod-refer
                    &ENDIF
                      and tt-refugo-operac.cod-roteiro = tt-operac.cod-roteiro
                      and tt-refugo-operac.op-codigo   = tt-operac.op-codigo no-lock:

                    find motiv-refugo
                        where motiv-refugo.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo
                        no-lock no-error.
                        
                    ASSIGN i-lin = i-lin + 1.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 2
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = '@'
                           tt-dados.celula-valor         = tt-refugo-operac.cod-motiv-refugo + " - " + motiv-refugo.des-motiv-refugo.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 5
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-refugo-operac.qtd-refgda,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 6
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-refugo-operac.qtd-retrab,">,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 7
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-refugo-operac.fator-refugo,">>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 8
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-refugo-operac.fator-retrab,">>9.99").

                    for each tt-ref-oper-ctrab use-index operacao
                        where tt-ref-oper-ctrab.it-codigo        = tt-refugo-operac.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                          AND tt-ref-oper-ctrab.cod-refer        = tt-refugo-operac.cod-refer
                        &ENDIF
                          and tt-ref-oper-ctrab.cod-roteiro      = tt-refugo-operac.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo        = tt-refugo-operac.op-codigo
                          and tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo no-lock: 

                        find ctrab
                             where ctrab.cod-ctrab = tt-ref-oper-ctrab.cod-ctrab no-lock.
                             
                        ASSIGN i-lin = i-lin + 1.
  
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 3
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = '@'
                               tt-dados.celula-valor         = tt-ref-oper-ctrab.cod-ctrab + " - " + ctrab.des-ctrab.
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 5
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.qtd-refgda,"->,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 6
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.qtd-retrab,">,>>>,>>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 7
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.fator-refugo,">>9.99").
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 8
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.fator-retrab,">>9.99").
                    end.
                end.
            end.
            else do:
                for each tt-operac-ctrab use-index op-ctrab
                    where tt-operac-ctrab.it-codigo   = tt-operac.it-codigo
                    &IF DEFINED(bf_man_204) &THEN
                      AND tt-operac-ctrab.cod-refer   = tt-operac.cod-refer
                    &ENDIF
                      and tt-operac-ctrab.cod-roteiro = tt-operac.cod-roteiro
                      and tt-operac-ctrab.op-codigo   = tt-operac.op-codigo no-lock: 

                    find first ctrab
                         where ctrab.cod-ctrab = tt-operac-ctrab.cod-ctrab no-lock no-error.
                         
                    ASSIGN i-lin = i-lin + 1.
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 2
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = '@'
                           tt-dados.celula-valor         = tt-operac-ctrab.cod-ctrab + " - " + ctrab.des-ctrab.
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 4
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-operac-ctrab.qtd-reptda,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 5
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-operac-ctrab.qtd-refgda,"->,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 6
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-operac-ctrab.qtd-retrab,">,>>>,>>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 7
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-operac-ctrab.fator-refugo,">>9.99").
      
                    CREATE tt-dados.
                    ASSIGN tt-dados.planilha-num         = 1
                           tt-dados.celula-coluna        = 8
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = STRING(tt-operac-ctrab.fator-retrab,">>9.99").

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.it-codigo   = tt-operac-ctrab.it-codigo
                        &IF DEFINED(bf_man_204) &THEN
                          AND tt-ref-oper-ctrab.cod-refer   = tt-operac-ctrab.cod-refer
                        &ENDIF
                          and tt-ref-oper-ctrab.cod-roteiro = tt-operac-ctrab.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo   = tt-operac-ctrab.op-codigo
                          and tt-ref-oper-ctrab.cod-ctrab   = tt-operac-ctrab.cod-ctrab no-lock: 

                        find motiv-refugo
                            where motiv-refugo.cod-motiv-refugo = tt-ref-oper-ctrab.cod-motiv-refugo
                            no-lock no-error.
                            
                        ASSIGN i-lin = i-lin + 1.
      
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 3
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = '@'
                               tt-dados.celula-valor         = tt-ref-oper-ctrab.cod-motiv-refugo + " - " + motiv-refugo.des-motiv-refugo.
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 5
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.qtd-refgda,"->,>>>,>>9.99").
          
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 6
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.qtd-retrab,">,>>>,>>9.99").
          
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 7
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.fator-refugo,">>9.99").
          
                        CREATE tt-dados.
                        ASSIGN tt-dados.planilha-num         = 1
                               tt-dados.celula-coluna        = 8
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = STRING(tt-ref-oper-ctrab.fator-retrab,">>9.99").
                    end.
                end.                
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
                assign i-seq = i-seq + 1
                       tt-erro.i-sequen = i-seq
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro.
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    

    for each tt-ctrab-rp:       delete tt-ctrab-rp.       end.
    for each tt-ref-oper-ctrab: delete tt-ref-oper-ctrab. end.
    for each tt-refugo-operac:  delete tt-refugo-operac.  end.
    for each tt-operac-ctrab:   delete tt-operac-ctrab.   end.

    for each area-produc-ctrab
        where area-produc-ctrab.cod-area-produc = area-produc.cod-area-produc
          and area-produc-ctrab.dat-inic-valid <= da-dt-fim
          and area-produc-ctrab.dat-fim-valid  >  da-dt-inicio
          and (area-produc-ctrab.cod-ctrab      = c-cod-ctrab
               or c-cod-ctrab                   = "*") no-lock:

        find ctrab 
            where ctrab.cod-ctrab = area-produc-ctrab.cod-ctrab no-lock no-error.

        create tt-ctrab-rp.
        assign tt-ctrab-rp.gm-codigo       = ctrab.gm-codigo
               tt-ctrab-rp.cod-ctrab       = ctrab.cod-ctrab
               tt-ctrab-rp.descricao       = ctrab.des-ctrab
               tt-ctrab-rp.data-inicio     = max(da-dt-inicio, area-produc-ctrab.dat-inic-valid)
               tt-ctrab-rp.data-fim        = min(da-dt-fim,area-produc-ctrab.dat-fim-valid).
    end.  

    run CalcularResumoRefugo in h-sfapi003 (input-output table tt-ctrab-rp,
                                            input-output table tt-operac-ctrab,
                                            input-output table tt-ref-oper-ctrab).

    run CalcularResumoRefugoOperac in h-sfapi003 (input table tt-operac-ctrab,
                                                  input-output table tt-operac).

    if i-class = 1 then
        run UnirOpMotivo in h-sfapi003 (input table tt-operac,
                                        input table tt-ref-oper-ctrab,
                                        input-output table tt-refugo-operac).

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-param V-table-Win 
PROCEDURE pi-recebe-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    

    def input param p-cod-ctrab      as char no-undo.
    def input param p-it-codigo      as char no-undo.
    &IF DEFINED(bf_man_204) &THEN
        def input param p-cod-refer      as char no-undo.
    &ENDIF
    def input param p-dat-inicio     as date no-undo.
    def input param p-dat-fim        as date no-undo.

    assign da-dt-inicio = p-dat-inicio
           da-dt-fim    = p-dat-fim
           c-cod-ctrab  = p-cod-ctrab
           c-it-codigo  = p-it-codigo
        &IF DEFINED(bf_man_204) &THEN
           c-cod-refer  = p-cod-refer
        &ENDIF
        .

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

    for each tt-refugo-operac: delete tt-refugo-operac. end.

    find first tt-ctrab-rp no-lock no-error.

    if  avail tt-ctrab-rp then do:
        if i-class = 1 then do:
            run CalcularResumoRefugoOperac in h-sfapi003 (input table tt-operac-ctrab,
                                                          input-output table tt-operac).

            run UnirOpMotivo in h-sfapi003 (input table tt-operac,
                                            input table tt-ref-oper-ctrab,
                                            input-output table tt-refugo-operac).
        end.

        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    end.
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

