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
USING com.totvs.framework.utp.treelist.*.

{include/i-prgvrs.i V08IN513 2.00.00.014 } /*** "010014" 26/12/2023 08:19:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN513 MUT}
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

{cdp/cdcfgman.i}

{sfc/sfapi003.i}  /** Temp-tables        **/

def temp-table tt-linha
    field sequencia        as integer
    field cod-motiv-refugo like motiv-refugo.cod-motiv-refugo
    field cod-ctrab        like ctrab.cod-ctrab
    field it-codigo        like item.it-codigo
    field cod-roteiro      like operacao.cod-roteiro
    field op-codigo        like operacao.op-codigo
    field i-tp-reg         as int
    index seq is unique primary sequencia.

def buffer b-tt-ref   for tt-ref-oper-ctrab.
def buffer b-tt-ref-1 for tt-ref-oper-ctrab.

def var da-dt-inicio         like area-produc-ctrab.dat-inic-valid no-undo.
def var da-dt-fim            like area-produc-ctrab.dat-fim-valid  no-undo.
def var c-cod-ctrab          like ctrab.cod-ctrab                  no-undo.
def var c-motiv-refugo       like motiv-refugo.cod-motiv-refugo    no-undo.
def var chTreeView           as com-handle.
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
def var c-desc-item          as char format 'x(30)' no-undo.
def var c-rot                as char format 'x(40)' no-undo.
def var c-perc-ref           as char format 'x(08)' no-undo.
def var c-perc-ret           as char format 'x(08)' no-undo.
def var c-qtd-refgda         as char format 'x(08)' no-undo.
def var c-qtd-retrab         as char format 'x(10)' no-undo.
def var c-val-ref            as char format 'x(10)' no-undo.
def var c-val-ret            as char format 'x(10)' no-undo.
def var c-ft-custo           as char format 'x(11)' no-undo.
def var c-preco              as char                no-undo.
def var des-motiv            like motiv-refugo.des-motiv-refugo.
DEF VAR oTreeList            AS TotvsTreeList NO-UNDO.
DEF VAR cNodeLabel           AS CHAR NO-UNDO.
DEF VAR cNodeId              AS CHAR NO-UNDO.

def var j                       as int    no-undo.
def var c-liter-titulo          as char   no-undo.
def var c-liter-cod-mot-refugo  as char   no-undo.
def var c-liter-descricao       as char   no-undo.
def var c-liter-item-roteiro    as char   no-undo.
def var c-liter-ctrab           as char   no-undo.

{utp/utapi013.i}
{cdg/cdg0666.i}

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
     SIZE 89 BY 10.79.


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


{utp/ut-liter.i %_Refugo                               * R} assign c-perc-ref   = trim(return-value).
{utp/ut-liter.i %_Retrab                               * R} assign c-perc-ret   = trim(return-value).
{utp/ut-field.i movind rep-oper-ctrab qtd-operac-refgda 02} assign c-qtd-refgda = return-value.
{utp/ut-field.i movind rep-oper-ctrab qtd-operac-retrab 02} assign c-qtd-retrab = return-value.
{utp/ut-liter.i Val_Refgdo * R}                             assign c-val-ref    = return-value.
{utp/ut-liter.i Val_Retrab * R}                             assign c-val-ret    = return-value.
{utp/ut-liter.i Fator_Custo * R}                            assign c-ft-custo   = return-value.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface V-table-Win 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DELETE OBJECT oTreeList NO-ERROR.
    
    return "OK":U.

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

  assign c-cod-ctrab    = "*"
         c-motiv-refugo = "*"
         da-dt-inicio   = today
         da-dt-fim      = today.

  IF NOT VALID-OBJECT(oTreeList) THEN DO:

    oTreeList = NEW TotvsTreeList().
    oTreeList:parentFrame = FRAME f-main:HANDLE.
    oTreeList:parentProg = THIS-PROCEDURE.
    oTreeList:setSize(1, 1, 88.57, 9.79).

    oTreeList:AddColumn("desc-item", "CHARACTER", 0, "x(40)", "", "Descriá∆o").
    oTreeList:AddColumn("val-refgdo", "CHARACTER", 0, "x(40)", "", "Val Refgdo").
    oTreeList:AddColumn("val-retrab", "DECIMAL", 0, "", "", "Val Retrab").
    oTreeList:AddColumn("refugo", "DECIMAL", 0, "", "", "%Refugo").
    oTreeList:AddColumn("fator-retrab", "DECIMAL", 0, "", "", "%Retrab").
    oTreeList:AddColumn("fator-custo", "DECIMAL", 0, "", "", "Fator Custo").

    oTreeList:initialize().

  END.

  oTreeList:setColumnLabel("cEstrutura", "C¢digo Motivo Refugo").  
  oTreeList:setColumnSize("cEstrutura", 20).   
  oTreeList:setColumnSize("val-refgdo", 9). 

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

  oTreeList:hideTreeList(TRUE).

  /* Code placed here will execute AFTER standard behavior.    */

    if session:set-wait-state ("general") then.


    for each tt-linha:
        delete tt-linha.
    end.

    oTreeList:emptyTreeList().

    if  avail area-produc then do:

        assign i-aux  = 1
               i-cont = 1.

        for each tt-motivo use-index refugo no-lock:

            find motiv-refugo
                where motiv-refugo.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock no-error.
            if avail motiv-refugo then 
                assign des-motiv = motiv-refugo.des-motiv-refugo.
            else assign des-motiv = "". 

                oTreeList:addNode(INPUT "",
                                  INPUT "e" + string (i-cont),
                                  INPUT tt-motivo.cod-motiv-refugo).

                oTreeList:setData("e" + string (i-cont), "cEstrutura", string(tt-motivo.cod-motiv-refugo,"x(8)")).
                oTreeList:setData("e" + string (i-cont), "desc-item",  string(des-motiv,"x(40)")).
                oTreeList:setData("e" + string (i-cont), "val-refgdo", string(tt-motivo.val-refgda,">,>>>,>>9.99")).
                oTreeList:setData("e" + string (i-cont), "val-retrab", string(tt-motivo.val-retrab,">,>>>,>>9.99")).
                oTreeList:setData("e" + string (i-cont), "refugo", string(IF tt-motivo.fator-refugo = ? THEN INT("")
                                                                          ELSE tt-motivo.fator-refugo,">>9.99")).
                oTreeList:setData("e" + string (i-cont), "fator-retrab", string(IF tt-motivo.fator-retrab = ? THEN INT("")
                                                                                ELSE tt-motivo.fator-retrab,">>9.99")).
                oTreeList:setData("e" + string (i-cont), "fator-custo", " - ").


            find tt-linha
                 where tt-linha.sequencia = i-cont no-error.
            if  not avail tt-linha then do:
                create tt-linha.
                assign tt-linha.sequencia        = i-cont
                       tt-linha.cod-motiv-refugo = tt-motivo.cod-motiv-refugo
                       tt-linha.i-tp-reg         = 1.
            end.

            IF  l-expande THEN
                oTreeList:expandAll().
            ELSE
                oTreeList:collapseAll().

            assign i-aux  = i-cont
                   i-cont = i-cont + 1.

            if i-class = 1 then do:
                for each tt-refugo-ctrab use-index ref-ctrab
                    where tt-refugo-ctrab.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock:
                    find ctrab
                        where ctrab.cod-ctrab = tt-refugo-ctrab.cod-ctrab no-lock no-error.

                    if avail ctrab then 
                        assign des-motiv = ctrab.des-ctrab.
                    else assign des-motiv = "". 

                    oTreeList:addNode(INPUT "e" + string(i-aux),
                                      INPUT "e" + string (i-cont),
                                      INPUT tt-refugo-ctrab.cod-ctrab).

                    oTreeList:setData("e" + string(i-cont), "cEstrutura", string(tt-motivo.cod-motiv-refugo,"x(8)")).
                    oTreeList:setData("e" + string(i-cont), "desc-item",  string(des-motiv,"x(40)")).
                    oTreeList:setData("e" + string(i-cont), "val-refgdo", string(tt-refugo-ctrab.val-refgda,">,>>>,>>9.99")).
                    oTreeList:setData("e" + string(i-cont), "val-retrab", string(tt-refugo-ctrab.val-retrab,">,>>>,>>9.99")).
                    oTreeList:setData("e" + string(i-cont), "refugo", string(IF tt-refugo-ctrab.fator-refugo = ? THEN 0
                                                                             ELSE tt-refugo-ctrab.fator-refugo,">>9.99")).
                    oTreeList:setData("e" + string (i-cont), "fator-retrab", string(IF tt-refugo-ctrab.fator-retrab = ? THEN 0
                                                                                    ELSE tt-refugo-ctrab.fator-retrab,">>9.99")).
                    oTreeList:setData("e" + string (i-cont), "fator-custo", " - ").


                    find tt-linha
                         where tt-linha.sequencia = i-cont no-error.
                    if  not avail tt-linha then do:
                        create tt-linha.
                        assign tt-linha.sequencia        = i-cont
                               tt-linha.i-tp-reg         = 2
                               tt-linha.cod-motiv-refugo = tt-refugo-ctrab.cod-motiv-refugo
                               tt-linha.cod-ctrab        = tt-refugo-ctrab.cod-ctrab.
                    end.

                    IF  l-expande THEN
                        oTreeList:expandAll().
                    ELSE
                        oTreeList:collapseAll().

                    assign i-aux1 = i-cont
                           i-cont = i-cont + 1.

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-ctrab.cod-motiv-refugo
                          and tt-ref-oper-ctrab.cod-ctrab        = tt-refugo-ctrab.cod-ctrab no-lock:

                        find first item
                             where item.it-codigo = tt-ref-oper-ctrab.it-codigo no-lock no-error.

                        find first tt-operac where
                                   tt-operac.it-codigo   = tt-ref-oper-ctrab.it-codigo and
                                   tt-operac.cod-roteiro = tt-ref-oper-ctrab.cod-roteiro and
                                   tt-operac.op-codigo   = tt-ref-oper-ctrab.op-codigo NO-ERROR.

                        assign c-desc-item = item.desc-item when avail item
                               c-rot =  tt-ref-oper-ctrab.it-codigo + "/" +
                                        if   tt-ref-oper-ctrab.cod-roteiro <> ""
                                        then tt-ref-oper-ctrab.cod-roteiro + "/" +
                                             string(tt-ref-oper-ctrab.op-codigo)
                                        else string(tt-ref-oper-ctrab.op-codigo).

                        if avail ctrab then 
                            assign des-motiv = ctrab.des-ctrab.
                        else assign des-motiv = "".

                        find first oper-ord where
                               oper-ord.it-codigo   = tt-operac.it-codigo   and
                               oper-ord.cod-roteiro = tt-operac.cod-roteiro and
                               oper-ord.op-codigo   = tt-operac.op-codigo NO-ERROR.

                        oTreeList:addNode(INPUT "e" + string(i-aux1),
                                          INPUT "e" + string (i-cont),
                                          INPUT string(c-rot,"x(25)")).

                        oTreeList:setData("e" + string(i-cont), "desc-item",    oper-ord.descricao).
                        oTreeList:setData("e" + string(i-cont), "val-refgdo",   string(tt-ref-oper-ctrab.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "val-retrab",   string(tt-ref-oper-ctrab.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "refugo",       string(IF tt-ref-oper-ctrab.fator-refugo = ? 
                                                                                       THEN 0
                                                                                       ELSE tt-ref-oper-ctrab.fator-refugo,">>9.99")).
                        oTreeList:setData("e" + string(i-cont), "fator-retrab", string(IF tt-ref-oper-ctrab.fator-retrab = ?
                                                                                       THEN 0
                                                                                       ELSE tt-ref-oper-ctrab.fator-retrab,">>9.99")).
                        oTreeList:setData("e" + string (i-cont), "fator-custo", string(IF tt-operac.fator-custo = ? THEN 0
                                                                                       ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999")).

                        
                        
                        IF  l-expande THEN
                            oTreeList:expandAll().
                        ELSE
                            oTreeList:collapseAll().

                        assign i-cont = i-cont + 1.
                    end.
                end.
            end.
            else do:
                for each tt-refugo-operac use-index ref-op
                    where tt-refugo-operac.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock:

                    find first item
                         where item.it-codigo = tt-refugo-operac.it-codigo no-lock no-error.


                    
                    find first tt-operac where
                               tt-operac.it-codigo   = tt-refugo-operac.it-codigo   and
                               tt-operac.cod-roteiro = tt-refugo-operac.cod-roteiro and
                               tt-operac.op-codigo   = tt-refugo-operac.op-codigo NO-ERROR.

                    assign c-desc-item = item.desc-item when avail item
                           c-rot = tt-refugo-operac.it-codigo + "/" +
                                   if   tt-refugo-operac.cod-roteiro <> ""
                                   then tt-refugo-operac.cod-roteiro + "/" +
                                        string(tt-refugo-operac.op-codigo)
                                   else string(tt-refugo-operac.op-codigo).    

                        find first oper-ord where
                                   oper-ord.it-codigo   = tt-operac.it-codigo   and
                                   oper-ord.cod-roteiro = tt-operac.cod-roteiro and
                                   oper-ord.op-codigo   = tt-operac.op-codigo NO-ERROR.

                        oTreeList:addNode(INPUT "e" + string(i-aux),
                                          INPUT "e" + string (i-cont),
                                          INPUT string(c-rot,"x(25)")).

                        oTreeList:setData("e" + string(i-cont), "cEstrutura", string(c-rot,"x(25)")).
                        oTreeList:setData("e" + string(i-cont), "desc-item",  oper-ord.descricao).
                        oTreeList:setData("e" + string(i-cont), "val-refgdo",  string(tt-refugo-operac.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "val-retrab", string(tt-refugo-operac.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "refugo", string(IF tt-refugo-operac.fator-refugo = ? THEN 0
                                                                                     ELSE tt-refugo-operac.fator-refugo,">>9.99")).
                        oTreeList:setData("e" + string(i-cont), "fator-retrab", string(IF tt-refugo-operac.fator-retrab = ? THEN 0
                                                                                 ELSE tt-refugo-operac.fator-retrab,">>9.99")).
                        oTreeList:setData("e" + string (i-cont), "fator-custo", string(IF tt-operac.fator-custo = ? THEN 0
                                                                                        ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999")).

                    find tt-linha
                         where tt-linha.sequencia = i-cont no-error.
                    if  not avail tt-linha then do:
                        create tt-linha.
                        assign tt-linha.sequencia        = i-cont
                               tt-linha.i-tp-reg         = 2
                               tt-linha.it-codigo        = tt-refugo-operac.it-codigo
                               tt-linha.cod-roteiro      = tt-refugo-operac.cod-roteiro
                               tt-linha.op-codigo        = tt-refugo-operac.op-codigo
                               tt-linha.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo.
                    end.

                    IF  l-expande THEN
                        oTreeList:expandAll().
                    ELSE
                        oTreeList:collapseAll().

                    assign i-aux1 = i-cont
                           i-cont = i-cont + 1.

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo
                          and tt-ref-oper-ctrab.it-codigo        = tt-refugo-operac.it-codigo
                          and tt-ref-oper-ctrab.cod-roteiro      = tt-refugo-operac.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo        = tt-refugo-operac.op-codigo no-lock:

                        find ctrab
                            where ctrab.cod-ctrab = tt-ref-oper-ctrab.cod-ctrab no-lock no-error.


                        oTreeList:addNode(INPUT "e" + string(i-aux1),
                                          INPUT "e" + string (i-cont),
                                          INPUT string(tt-ref-oper-ctrab.cod-ctrab,"x(16)")).
                        
                        oTreeList:setData("e" + string(i-cont), "cEstrutura",    string(tt-ref-oper-ctrab.cod-ctrab,"x(16)")).
                        oTreeList:setData("e" + string(i-cont), "desc-item",     string(ctrab.des-ctrab,"x(40)")).
                        oTreeList:setData("e" + string(i-cont), "val-refgdo",    string(tt-ref-oper-ctrab.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "val-retrab",    string(tt-ref-oper-ctrab.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99")).
                        oTreeList:setData("e" + string(i-cont), "refugo",        string(IF tt-ref-oper-ctrab.fator-refugo = ?
                                                                                        THEN 0
                                                                                        ELSE tt-ref-oper-ctrab.fator-refugo,">>9.99")).
                        oTreeList:setData("e" + string (i-cont), "fator-retrab", string(IF tt-ref-oper-ctrab.fator-retrab = ?
                                                                                        THEN 0
                                                                                        ELSE tt-ref-oper-ctrab.fator-retrab,">>9.99")).
                        oTreeList:setData("e" + string (i-cont), "fator-custo",  string(IF tt-operac.fator-custo = ? THEN 0
                                                                                        ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999")).

                        IF  l-expande THEN
                            oTreeList:expandAll().
                        ELSE
                            oTreeList:collapseAll().

                        assign i-cont = i-cont + 1.
                    end.
                end.                
            end.
        end.
  end.   

  IF oTreeList:hasNode() THEN
      run pi-habilita-expande in c-handle(input yes).
  else
      run pi-habilita-expande in c-handle(input no).       

  if session:set-wait-state ("") then.

  oTreeList:hideTreeList(FALSE).

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

    {utp/ut-liter.i Resumo_Refugo_-_Motivo * R}
    assign c-liter-titulo = trim(return-value).
    
    {utp/ut-liter.i C¢digo_Motivo_Refugo * R}
    assign c-liter-cod-mot-refugo = trim(return-value).
    
    {utp/ut-liter.i Descriá∆o * R}
    assign c-liter-descricao = trim(return-value).
    
    {utp/ut-liter.i Centro_de_Trabalho * R}
    assign c-liter-ctrab = trim(return-value).
    
    {utp/ut-liter.i Item_Roteiro_Operac * R}
    assign c-liter-item-roteiro = trim(return-value).
    
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
               tt-dados.celula-valor   = "SF0704 - " + c-liter-titulo.
    
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
               tt-dados.celula-formato       = "@"
               tt-dados.celula-valor         = c-liter-cod-mot-refugo.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 2
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-descricao.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = IF i-class = 1 THEN 3 ELSE 4
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-ctrab.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = IF i-class = 1 THEN 4 ELSE 3
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-liter-item-roteiro.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 5
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-val-ref.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 6
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-val-ret.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 7
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-perc-ref.
  
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 8
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-perc-ret.
               
        CREATE tt-dados.
        ASSIGN tt-dados.celula-coluna        = 9
               tt-dados.planilha-num         = 1
               tt-dados.celula-linha         = i-lin
               tt-dados.celula-valor         = c-ft-custo.

        for each tt-motivo use-index refugo no-lock:

            find motiv-refugo
                where motiv-refugo.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock no-error.
            if avail motiv-refugo then 
                assign des-motiv = motiv-refugo.des-motiv-refugo.
            else assign des-motiv = "".
            
            ASSIGN i-lin = i-lin + 1.
    
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 1
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-formato       = "@"
                   tt-dados.celula-valor         = string(tt-motivo.cod-motiv-refugo,"x(8)").
      
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 2
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-formato       = "@"
                   tt-dados.celula-valor         = string(des-motiv,"x(40)").
      
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 5
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-motivo.val-refgda,">,>>>,>>9.99").
      
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 6
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(tt-motivo.val-retrab,">,>>>,>>9.99").
      
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 7
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(IF tt-motivo.fator-refugo = ? THEN INT("") ELSE tt-motivo.fator-refugo,">>9.99").
      
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 8
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-valor         = string(IF tt-motivo.fator-retrab = ? THEN INT("") ELSE tt-motivo.fator-retrab,">>9.99").
                   
            CREATE tt-dados.
            ASSIGN tt-dados.celula-coluna        = 9
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-linha         = i-lin
                   tt-dados.celula-formato       = "@"
                   tt-dados.celula-valor         = " - ".

            if i-class = 1 then do:
                for each tt-refugo-ctrab use-index ref-ctrab
                    where tt-refugo-ctrab.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock:
                    find ctrab
                        where ctrab.cod-ctrab = tt-refugo-ctrab.cod-ctrab no-lock no-error.

                    if avail ctrab then 
                        assign des-motiv = ctrab.des-ctrab.
                    else assign des-motiv = "".
                    
                    ASSIGN i-lin = i-lin + 1.                   
    
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 3
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = "@"
                           tt-dados.celula-valor         = tt-refugo-ctrab.cod-ctrab + " - " + des-motiv.
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 5
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-refugo-ctrab.val-refgda,">,>>>,>>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 6
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-refugo-ctrab.val-retrab,">,>>>,>>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 7
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(IF tt-refugo-ctrab.fator-refugo = ? THEN 0 ELSE tt-refugo-ctrab.fator-refugo,">>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 8
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(IF tt-refugo-ctrab.fator-retrab = ? THEN 0 ELSE tt-refugo-ctrab.fator-retrab,">>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 9
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = "@"
                           tt-dados.celula-valor         = " - ".

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-ctrab.cod-motiv-refugo
                          and tt-ref-oper-ctrab.cod-ctrab        = tt-refugo-ctrab.cod-ctrab no-lock:

                        find first item
                             where item.it-codigo = tt-ref-oper-ctrab.it-codigo no-lock no-error.

                        find first tt-operac where
                                   tt-operac.it-codigo   = tt-ref-oper-ctrab.it-codigo and
                                   tt-operac.cod-roteiro = tt-ref-oper-ctrab.cod-roteiro and
                                   tt-operac.op-codigo   = tt-ref-oper-ctrab.op-codigo NO-ERROR.

                        assign c-desc-item = item.desc-item when avail item
                               c-rot =  tt-ref-oper-ctrab.it-codigo + "/" +
                                        if   tt-ref-oper-ctrab.cod-roteiro <> ""
                                        then tt-ref-oper-ctrab.cod-roteiro + "/" +
                                             string(tt-ref-oper-ctrab.op-codigo)
                                        else string(tt-ref-oper-ctrab.op-codigo).

                        if avail ctrab then 
                            assign des-motiv = ctrab.des-ctrab.
                        else assign des-motiv = "".

                        find first oper-ord where
                               oper-ord.it-codigo   = tt-operac.it-codigo   and
                               oper-ord.cod-roteiro = tt-operac.cod-roteiro and
                               oper-ord.op-codigo   = tt-operac.op-codigo NO-ERROR.
                               
                        ASSIGN i-lin = i-lin + 1.
        
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 4
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = "@"
                               tt-dados.celula-valor         = c-rot + " - " + oper-ord.descricao.
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 5
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-ref-oper-ctrab.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 6
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-ref-oper-ctrab.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 7
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(IF tt-ref-oper-ctrab.fator-refugo = ? THEN 0 ELSE tt-ref-oper-ctrab.fator-refugo,">>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 8
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(IF tt-ref-oper-ctrab.fator-retrab = ? THEN 0 ELSE tt-ref-oper-ctrab.fator-retrab,">>9.99").
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 9
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = "@"
                               tt-dados.celula-valor         = string(IF tt-operac.fator-custo = ? THEN 0 ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999").
                    end.
                end.
            end.
            else do:
                for each tt-refugo-operac use-index ref-op
                    where tt-refugo-operac.cod-motiv-refugo = tt-motivo.cod-motiv-refugo no-lock:

                    find first item
                         where item.it-codigo = tt-refugo-operac.it-codigo no-lock no-error.
                    
                    find first tt-operac where
                               tt-operac.it-codigo   = tt-refugo-operac.it-codigo   and
                               tt-operac.cod-roteiro = tt-refugo-operac.cod-roteiro and
                               tt-operac.op-codigo   = tt-refugo-operac.op-codigo NO-ERROR.

                    assign c-desc-item = item.desc-item when avail item
                           c-rot = tt-refugo-operac.it-codigo + "/" +
                                   if   tt-refugo-operac.cod-roteiro <> ""
                                   then tt-refugo-operac.cod-roteiro + "/" +
                                        string(tt-refugo-operac.op-codigo)
                                   else string(tt-refugo-operac.op-codigo).    

                    find first oper-ord where
                               oper-ord.it-codigo   = tt-operac.it-codigo   and
                               oper-ord.cod-roteiro = tt-operac.cod-roteiro and
                               oper-ord.op-codigo   = tt-operac.op-codigo NO-ERROR.
                               
                    ASSIGN i-lin = i-lin + 1.
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 3
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = "@"
                           tt-dados.celula-valor         = c-rot + " - " + oper-ord.descricao.
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 5
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-refugo-operac.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 6
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(tt-refugo-operac.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 7
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(IF tt-refugo-operac.fator-refugo = ? THEN 0 ELSE tt-refugo-operac.fator-refugo,">>9.99").
              
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 8
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-valor         = string(IF tt-refugo-operac.fator-retrab = ? THEN 0 ELSE tt-refugo-operac.fator-retrab,">>9.99").
                           
                    CREATE tt-dados.
                    ASSIGN tt-dados.celula-coluna        = 9
                           tt-dados.planilha-num         = 1
                           tt-dados.celula-linha         = i-lin
                           tt-dados.celula-formato       = "@"
                           tt-dados.celula-valor         = string(IF tt-operac.fator-custo = ? THEN 0 ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999").

                    for each tt-ref-oper-ctrab
                        where tt-ref-oper-ctrab.cod-motiv-refugo = tt-refugo-operac.cod-motiv-refugo
                          and tt-ref-oper-ctrab.it-codigo        = tt-refugo-operac.it-codigo
                          and tt-ref-oper-ctrab.cod-roteiro      = tt-refugo-operac.cod-roteiro
                          and tt-ref-oper-ctrab.op-codigo        = tt-refugo-operac.op-codigo no-lock:

                        find ctrab
                            where ctrab.cod-ctrab = tt-ref-oper-ctrab.cod-ctrab no-lock no-error.
                            
                        ASSIGN i-lin = i-lin + 1.
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 4
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = "@"
                               tt-dados.celula-valor         = tt-ref-oper-ctrab.cod-ctrab + " - " + ctrab.des-ctrab.
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 5
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-ref-oper-ctrab.qtd-refgda * tt-operac.fator-custo,">,>>>,>>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 6
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(tt-ref-oper-ctrab.qtd-retrab * tt-operac.fator-custo,">,>>>,>>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 7
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(IF tt-ref-oper-ctrab.fator-refugo = ? THEN 0 ELSE tt-ref-oper-ctrab.fator-refugo,">>9.99").
                  
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 8
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-valor         = string(IF tt-ref-oper-ctrab.fator-retrab = ? THEN 0 ELSE tt-ref-oper-ctrab.fator-retrab,">>9.99").
                               
                        CREATE tt-dados.
                        ASSIGN tt-dados.celula-coluna        = 9
                               tt-dados.planilha-num         = 1
                               tt-dados.celula-linha         = i-lin
                               tt-dados.celula-formato       = "@"
                               tt-dados.celula-valor         = string(IF tt-operac.fator-custo = ? THEN 0 ELSE tt-operac.fator-custo,">>>>>,>>>,>>9.9999").
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
    for each tt-refugo-ctrab:   delete tt-refugo-ctrab.   end.
    for each tt-refugo-operac:  delete tt-refugo-operac.  end.
    for each tt-operac:         delete tt-operac.         end.
    for each tt-motivo:         delete tt-motivo.         end.

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

    run UnirOpMotivo in h-sfapi003 (input table tt-operac,
                                    input table tt-ref-oper-ctrab,
                                    input-output table tt-refugo-operac).

     run CalcularResumoRefugoMotivo in h-sfapi003 (input c-preco,
                                                  input table tt-refugo-operac,
                                                  input-output table tt-operac,
                                                  input-output table tt-motivo).

    if i-class = 1 then do:
        run UnirCtrabMotivo in h-sfapi003 (input table tt-ctrab-rp,
                                           input table tt-ref-oper-ctrab,
                                           input-output table tt-refugo-ctrab).
        run AtualizarValorRefugoCtrab in h-sfapi003(input table tt-operac,
                                                    input table tt-ref-oper-ctrab,
                                                    input-output table tt-refugo-ctrab).
    end.


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
    def input param p-motiv-refugo   as char no-undo.
    def input param p-dat-inicio     as date no-undo.
    def input param p-dat-fim        as date no-undo.
    def input param p-preco          as char no-undo.

    assign da-dt-inicio   = p-dat-inicio
           da-dt-fim      = p-dat-fim
           c-cod-ctrab    = p-cod-ctrab
           c-motiv-refugo = p-motiv-refugo
           c-preco        = p-preco.

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

    for each tt-refugo-ctrab:  delete tt-refugo-ctrab.  end.
    for each tt-refugo-operac: delete tt-refugo-operac. end.
    for each tt-operac:        delete tt-operac.        end.
    for each tt-motivo:        delete tt-motivo.        end.

    def input param i-param      as int no-undo.
    def input param p-cod-ctrab  as char no-undo.
    def input param p-cod-motiv  as char no-undo.
    def input param p-dat-inicio as date no-undo.
    def input param p-dat-fim    as date no-undo.
    def input param p-preco      as char no-undo.

    assign i-class        = i-param
           c-cod-ctrab    = p-cod-ctrab
           c-motiv-refugo = p-cod-motiv
           da-dt-inicio   = p-dat-inicio
           da-dt-fim      = p-dat-fim
           c-preco        = p-preco.

    find first tt-ctrab-rp no-lock no-error.
	

    if  avail tt-ctrab-rp then do:
        run CalcularResumoRefugoOperac in h-sfapi003 (input table tt-operac-ctrab,
                                                      input-output table tt-operac).                                                          

        run UnirOpMotivo in h-sfapi003 (input table tt-operac,
                                        input table tt-ref-oper-ctrab,
                                        input-output table tt-refugo-operac).

        run CalcularResumoRefugoMotivo in h-sfapi003 (input c-preco,
                                                      input table tt-refugo-operac,
                                                      input-output table tt-operac,
                                                      input-output table tt-motivo).

        if i-class = 1 then do:
            run UnirCtrabMotivo in h-sfapi003 (input table tt-ctrab-rp,
                                               input table tt-ref-oper-ctrab,
                                               input-output table tt-refugo-ctrab).
            run AtualizarValorRefugoCtrab in h-sfapi003(input table tt-operac,
                                                        input table tt-ref-oper-ctrab,
                                                        input-output table tt-refugo-ctrab).
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



