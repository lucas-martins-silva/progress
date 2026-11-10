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
{include/i-prgvrs.i V17IN112 2.00.00.018} /*** "010018" 13/05/2026 14:26:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v17in112 MUT}
&ENDIF
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    {cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/
&ENDIF


/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var de-percentual as decimal no-undo.
def var i-seq-evento as integer no-undo.
def var c-incmod as char.
def buffer buffer-evento for evento-ped.

def buffer b-ordem for ordem-compra.
def var l-contrato as log no-undo.

def var c-lista-ind-sit-event as char no-undo.
def var i as int no-undo.

DEF VAR i-ord-manut AS INTEGER NO-UNDO.
DEF VAR i-contrato  AS INTEGER NO-UNDO.
DEF VAR da-dat-event AS DATE FORMAT "99/99/9999":U NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.dt-evento 
&Scoped-define DISPLAYED-TABLES evento-ped
&Scoped-define FIRST-DISPLAYED-TABLE evento-ped
&Scoped-Define DISPLAYED-OBJECTS c-cod-comprado rs-ind-sit-event ~
da-dat-realiz da-dat-prev-event de-perc-lib-previst fi-ord-manut ~
da-dat-nova-realiz i-cod-cond-pag c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-cod-comprado da-dat-prev-event ~
de-perc-lib-previst da-dat-nova-realiz i-cod-cond-pag 
&Scoped-define ADM-ASSIGN-FIELDS c-cod-comprado rs-ind-sit-event ~
evento-ped.dt-evento da-dat-realiz da-dat-prev-event de-perc-lib-previst ~
da-dat-nova-realiz i-cod-cond-pag 
&Scoped-define ADM-MODIFY-FIELDS c-cod-comprado rs-ind-sit-event ~
evento-ped.dt-evento da-dat-realiz da-dat-prev-event da-dat-nova-realiz ~
i-cod-cond-pag 

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
DEFINE VARIABLE c-cod-comprado AS CHARACTER FORMAT "X(16)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE da-dat-nova-realiz AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova Re" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dat-prev-event AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Prev" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dat-realiz AS DATE FORMAT "99/99/9999":U 
     LABEL "Realizaá∆o Evento" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-lib-previst AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Perc. Previsto" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ord-manut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ord Manut" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Condiá∆o Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE rs-ind-sit-event AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendente", 1,
"Realizado", 2
     SIZE 25.57 BY .75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.29 BY 5.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-comprado AT ROW 1.33 COL 24.72 COLON-ALIGNED
     rs-ind-sit-event AT ROW 1.33 COL 59.29 NO-LABEL
     evento-ped.dt-evento AT ROW 2.33 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     da-dat-realiz AT ROW 2.33 COL 69.86 COLON-ALIGNED
     da-dat-prev-event AT ROW 3.33 COL 24.72 COLON-ALIGNED
     de-perc-lib-previst AT ROW 3.33 COL 69.86 COLON-ALIGNED
     fi-ord-manut AT ROW 4.25 COL 69.86 COLON-ALIGNED
     da-dat-nova-realiz AT ROW 4.33 COL 24.72 COLON-ALIGNED
     i-cod-cond-pag AT ROW 5.33 COL 24.72 COLON-ALIGNED
     c-descricao AT ROW 5.33 COL 29.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.evento-ped
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
         HEIGHT             = 5.75
         WIDTH              = 86.57.
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

/* SETTINGS FOR FILL-IN c-cod-comprado IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dat-nova-realiz IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN da-dat-prev-event IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN da-dat-realiz IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN de-perc-lib-previst IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN evento-ped.dt-evento IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-ord-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-cond-pag IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR RADIO-SET rs-ind-sit-event IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME c-cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-comprado V-table-Win
ON F5 OF c-cod-comprado IN FRAME f-main /* Comprador */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=c-cod-comprado
                       &campozoom=cod-comprado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME da-dat-prev-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dat-prev-event V-table-Win
ON LEAVE OF evento-ped.dt-evento IN FRAME f-main /* Data Evento */
DO:
   
do with frame {&frame-name}:
    assign da-dat-event = date(evento-ped.dt-evento:SCREEN-VALUE).
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME da-dat-prev-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dat-prev-event V-table-Win
ON LEAVE OF da-dat-prev-event IN FRAME f-main /* Data Prev */
DO:

do with frame {&frame-name}:
    assign evento-ped.dt-evento:screen-value = string(input da-dat-prev-event).
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ord-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON F5 OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=fi-ord-manut
                     &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON F5 OF i-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                      &campo=i-cod-cond-pag
                      &campozoom=cod-cond-pag}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON LEAVE OF i-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:                                   
   {include/leave.i &tabela=cond-pagto
                    &atributo-ref=descricao
                    &variavel-ref=c-descricao
                    &where="cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-ind-sit-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-ind-sit-event V-table-Win
ON VALUE-CHANGED OF rs-ind-sit-event IN FRAME f-main
DO:
    run get-attribute("adm-new-record").
    if return-value = "no" then do with frame {&frame-name}:
        assign da-dat-realiz:sensitive = input rs-ind-sit-event = 2.
        if not da-dat-realiz:sensitive then
            disp "" @ da-dat-realiz.
        else
            disp today @ da-dat-realiz.
    end.
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

/* {utp/ut-field.i mgind evento-ped cod-sit-eve 1}
 *   assign c-situacao=return-value.
 *   assign c-situacao = c-situacao + ":".
 *   display c-situacao with frame {&frame-name}.*/

IF i-cod-cond-pag:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if c-cod-comprado:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-field.i mgind evento-ped dat-prev-event 1}
assign da-dat-prev-event:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind evento-ped dat-nova-realiz 1}
assign da-dat-nova-realiz:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind evento-ped cod-comprado 1}
assign c-cod-comprado:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind evento-ped dat-realiz 1}
assign da-dat-realiz:label in frame {&frame-name} = trim(return-value).

assign c-lista-ind-sit-event = {ininc/i01in112.i 04 1} + ", 1," + {ininc/i01in112.i 04 2} + ", 2".

assign rs-ind-sit-event:radio-buttons in frame {&frame-name} = c-lista-ind-sit-event.

FIND FIRST param-global NO-LOCK NO-ERROR.
if fi-ord-manut:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

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
        assign da-dat-prev-event:screen-value  = string(today)
               da-dat-nova-realiz:screen-value = string(today)
               evento-ped.dt-evento:screen-value = string(today)
               rs-ind-sit-event:screen-value = "1".
    end.
    
    RETURN "OK":U.
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
       
    ASSIGN INPUT FRAME {&frame-name} da-dat-realiz
           INPUT FRAME {&frame-name} da-dat-prev-event
           INPUT FRAME {&frame-name} c-cod-comprado
           INPUT FRAME {&frame-name} da-dat-prev-event
           INPUT FRAME {&frame-name} da-dat-nova-realiz
           INPUT FRAME {&frame-name} i-cod-cond-pag.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        ASSIGN i-ord-manut = INPUT FRAME {&frame-name} fi-ord-manut.
       
        DEF VAR wh-container AS WIDGET-HANDLE NO-UNDO.
        DEF VAR i-pag-viewer AS INTEGER       NO-UNDO.
        DEF VAR i-pag-atual  AS INTEGER       NO-UNDO.

        RUN GET-ATTRIBUTE ("W-Page").
        ASSIGN i-pag-viewer = INT(RETURN-VALUE).
        RUN GET-ATTRIBUTE ("W-Container-Source").
        ASSIGN wh-container = WIDGET-HANDLE(RETURN-VALUE).
        RUN GET-ATTRIBUTE IN wh-container ("current-page").
        ASSIGN i-pag-atual = INT(RETURN-VALUE).

        
        /********************************MATRIZ UNIDADE NEG‡CIO*******************************/
        IF param-global.modulo-mi AND 
           INPUT FRAME {&FRAME-NAME} fi-ord-manut <> 0 AND 
           fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN DO:
            FIND FIRST ord-prod 
                 WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} fi-ord-manut 
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL ord-prod THEN DO:
               IF i-pag-atual <> i-pag-viewer THEN RUN select-page in wh-container (string (i-pag-viewer)).
               RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1879, INPUT "").
               APPLY "entry":U TO fi-ord-manut.
               RETURN 'adm-error'.
            END.
            ELSE DO:
               IF ord-prod.origem = "MI":U THEN DO:                           
                  IF ord-prod.estado = 8 THEN DO:
                     /* Ordem de Produá∆o finalizada ! */
                     IF i-pag-atual <> i-pag-viewer THEN RUN select-page in wh-container (string (i-pag-viewer)).
                     RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1882, INPUT "").
                     APPLY "entry":U TO fi-ord-manut.
                     RETURN 'adm-error'.
                  END.
                  IF CAN-FIND(FIRST unid-negoc-om 
                              WHERE unid-negoc-om.num-ord-manut = ord-prod.nr-ord-produ) AND l-unidade-negocio THEN DO:
                     /* Sera assumida matriz de UN da OM */
                     RUN utp/ut-msgs.p(INPUT "show":U, INPUT 34511, INPUT ""). 
                  END.
               END.
            END.
        END.
    &ENDIF
    
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.


    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */


    if da-dat-realiz:sensitive in frame {&frame-name} then
        assign evento-ped.dat-realiz = input frame {&frame-name} da-dat-realiz.
    else
        assign evento-ped.dat-realiz = input frame {&frame-name} da-dat-prev-event.

    assign evento-ped.cod-comprado = input frame {&frame-name} c-cod-comprado.

    if da-dat-prev-event:sensitive in frame {&frame-name} then
        assign evento-ped.dat-prev-event = input frame {&frame-name} da-dat-prev-event.

    if evento-ped.dt-evento:sensitive in frame {&frame-name} THEN DO:
        assign evento-ped.dt-evento = da-dat-event.
    END.
        
    if da-dat-nova-realiz:sensitive in frame {&frame-name} then
        assign evento-ped.dat-nova-realiz = input frame {&frame-name} da-dat-nova-realiz.

    if de-perc-lib-previst:sensitive in frame {&frame-name} then
        assign evento-ped.perc-lib-previst = input frame {&frame-name} de-perc-lib-previst.
        
    if i-cod-cond-pag:sensitive in frame {&frame-name} then
        assign evento-ped.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                      input "numero-ordem").
        find ordem-compra where ordem-compra.numero-ordem = int(trim(return-value)) NO-LOCK NO-ERROR.
        run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                      input "num-seq-item":U).
        FIND FIRST item-contrat NO-LOCK 
             WHERE item-contrat.nr-contrat   = ordem-compra.nr-contrato
               AND item-contrat.num-seq-item = int(trim(return-value)) NO-ERROR.
        IF AVAIL item-contrat AND 
           item-contrat.ind-tipo-control = 1 AND 
           item-contrat.log-control-event AND 
           param-global.modulo-mi AND 
           fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           THEN 
           &IF "{&bf_mat_versao_ems}" >= "2.08" &THEN
           ASSIGN evento-ped.nr-ord-produ = i-ord-manut.
           &ELSE
           ASSIGN evento-ped.int-1 = i-ord-manut.
           &ENDIF
        DISP i-ord-manut @ fi-ord-manut WITH FRAME {&FRAME-NAME}.
    &ENDIF
   
    RETURN "OK":U.
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

assign evento-ped.dat-realiz      = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
       evento-ped.dat-prev-event  = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
       evento-ped.dat-nova-realiz = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF.

if not l-contrato then do with frame {&frame-name}:
    assign evento-ped.dt-evento = input da-dat-prev-event.
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
    
    ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           de-perc-lib-previst:SENSITIVE IN FRAME {&frame-name} = NO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if  available evento-ped then do:
      find FIRST cond-pagto where cond-pagto.cod-cond-pag = evento-ped.cod-cond-pag no-lock no-error.
      assign c-descricao = if avail cond-pagto then cond-pagto.descricao else "":U.
      
      if  not adm-new-record then do:
          assign c-cod-comprado      = evento-ped.cod-comprado
                 &if defined(bf_mat_contratos) &then
                 l-contrato          = evento-ped.nr-contrato <> 0
                 &else
                 l-contrato          = evento-ped.nr-contrato <> ""
                 &endif
                 de-perc-lib-previst = evento-ped.perc-lib-previst
                 da-dat-prev-event   = if evento-ped.dat-prev-event  <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF then evento-ped.dat-prev-event else ?
                 da-dat-nova-realiz  = if evento-ped.dat-nova-realiz <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF then evento-ped.dat-nova-realiz else ?
                 da-dat-realiz       = if evento-ped.dat-realiz      <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF then evento-ped.dat-realiz else ?
                 rs-ind-sit-event    = evento-ped.ind-sit-event
                 i-cod-cond-pag      = evento-ped.cod-cond-pag.
      end.
  end.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
      &IF "{&bf_mat_versao_ems}" >= "2.08" &THEN
           ASSIGN fi-ord-manut = evento-ped.nr-ord-produ.
      &ELSE
           ASSIGN fi-ord-manut = evento-ped.int-1.
      &ENDIF
  
      IF param-global.modulo-mi THEN
         DISP fi-ord-manut WITH FRAME {&FRAME-NAME}.
  &ENDIF
  
  RETURN "OK":U.
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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    do  with frame {&frame-name}:
        run get-attribute("adm-new-record").
        if  return-value = "yes" then 
            assign rs-ind-sit-event:screen-value = "1".
        &if defined(bf_mat_contratos) &then
        if (avail evento-ped and evento-ped.nr-contrato <> 0) or
        &else
        if (avail evento-ped and evento-ped.nr-contrato <> "") or
        &endif
           return-value = "yes" then do:
            disable da-dat-realiz
                    rs-ind-sit-event.
        end.

        &if defined(bf_mat_contratos) &then
        if return-value = "no" then do:
            assign c-incmod = "modificar".
            if avail evento-ped AND evento-ped.nr-contrato = 0 then do:
                assign rs-ind-sit-event:sensitive = yes
                       da-dat-realiz:sensitive = rs-ind-sit-event = 2.
            end.
            IF avail evento-ped THEN
                assign evento-ped.dt-evento:sensitive = not (evento-ped.nr-contrato <> 0)
                       de-perc-lib-previst:sensitive = not (evento-ped.nr-contrato <> 0).
            disable da-dat-nova-realiz 
                    da-dat-prev-event .
        end.
        else assign c-incmod = "incluir".
        &else
        if return-value = "no" then do:
            assign c-incmod = "modificar".
            if avail evento-ped AND evento-ped.nr-contrato = "" then do:
                assign rs-ind-sit-event:sensitive = yes
                       da-dat-realiz:sensitive = rs-ind-sit-event = 2.
            end.
            IF avail evento-ped THEN
                assign evento-ped.dt-evento:sensitive = not (evento-ped.nr-contrato <> "")
                       de-perc-lib-previst:sensitive = not (evento-ped.nr-contrato <> "").
            disable da-dat-nova-realiz 
                    da-dat-prev-event .
        end.
        else assign c-incmod = "incluir".
        &endif        
    end.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    IF adm-new-record = NO THEN DO: 
        run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                      input "num-seq-item":U).
        FIND FIRST item-contrat NO-LOCK 
             WHERE item-contrat.nr-contrat   = evento-ped.nr-contrato
               AND item-contrat.num-seq-item = int(trim(return-value)) NO-ERROR.
        IF AVAIL item-contrat AND 
           item-contrat.ind-tipo-control = 1 AND 
           item-contrat.log-control-event AND 
           param-global.modulo-mi THEN 
           ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
           ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    &ENDIF
    
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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Ord_Manut *}
  ASSIGN fi-ord-manut:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
       IF param-global.modulo-mi = yes THEN 
          ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = YES.
       ELSE
          ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  &ELSE
       ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  &ENDIF

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados V-table-Win 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-contrato like contrato-for.nr-contrato.

&if defined(bf_mat_contratos) &then
assign l-contrato = p-contrato <> 0 and p-contrato <> ?.
&else
assign l-contrato = p-contrato <> "" and p-contrato <> ?.
&endif

do  with frame {&frame-name}:
    assign c-cod-comprado:sensitive              = not l-contrato
           de-perc-lib-previst:sensitive         = not l-contrato
           da-dat-prev-event:sensitive           = not l-contrato
           da-dat-nova-realiz:sensitive          = not l-contrato.
    if  l-contrato then
        assign da-dat-nova-realiz:screen-value = "".
    else
        assign da-dat-nova-realiz:screen-value = string(today).

    if adm-new-record then
        assign evento-ped.dt-evento:sensitive    = l-contrato.

    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                  input "numero-ordem").
    find ordem-compra where ordem-compra.numero-ordem = int(trim(return-value))
        no-lock no-error.
    if  avail ordem-compra then
    &if defined(bf_mat_contratos) &then
    if  ordem-compra.nr-contrato <> 0 then do:
    &else
    if  ordem-compra.nr-contrato <> "" then do:
    &endif
        assign c-cod-comprado:screen-value = ordem-compra.cod-comprado
               i-cod-cond-pag:screen-value = string(ordem-compra.cod-cond-pag).
    end.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                  input "num-seq-item":U).
    FIND FIRST item-contrat NO-LOCK 
         WHERE item-contrat.nr-contrat   = p-contrato
           AND item-contrat.num-seq-item = int(trim(return-value)) NO-ERROR.
    IF AVAIL item-contrat AND 
       item-contrat.ind-tipo-control = 1 AND 
       item-contrat.log-control-event AND 
       param-global.modulo-mi THEN 
       ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
       ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &ENDIF
end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-om V-table-Win 
PROCEDURE pi-busca-om :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER p-om AS INTEGER NO-UNDO.

ASSIGN p-om = INPUT FRAME {&FRAME-NAME} fi-ord-manut.

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

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

if  input frame {&frame-name} rs-ind-sit-event = 2 and
    da-dat-realiz:sensitive in frame {&frame-name} and
    input frame {&frame-name} da-dat-realiz = ? then do:
    {include/i-vldprg.i}
    {utp/ut-field.i mgind evento-ped dat-realiz 1}
    /* Data de realizaá∆o deve ser informada. */
    run utp/ut-msgs.p ("show",265,trim(return-value)).
    apply "entry" to da-dat-realiz in frame {&frame-name}.
    return "adm-error".
end.

if input frame {&frame-name} i-cod-cond-pag <> 0 then do:
find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag no-lock no-error.
    if  not available cond-pagto then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 1088,
                           input "").
        apply "entry" TO i-cod-cond-pag in frame {&frame-name}.        
        return "adm-error".                
    end.
end.

if not l-contrato then do:  /* Validaá‰es Eventos compras */
    if  da-dat-prev-event:sensitive in frame {&frame-name} and
       (input frame {&frame-name} da-dat-prev-event = "" or
        input frame {&frame-name} da-dat-prev-event = ?)
        then do:
        {include/i-vldprg.i}
        {utp/ut-field.i mgind evento-ped dt-prev-even 1}
        run utp/ut-msgs.p (input "show",
                           input 158,
                           input return-value).
        apply "entry" to da-dat-prev-event.
        return "adm-error".
     end.


    /*    
    if input frame {&frame-name} da-dat-prev-event < 
       input frame {&frame-name} da-dat-prev-event
    then do:
       {utp/ut-field.i mgind evento-ped dt-prev-even 1}
       run utp/ut-msgs.p (input "show",
                          input 8864,
                          input return-value).
       apply "entry" to da-dat-prev-event.
       return "adm-error".
    end.  
    */

    if  c-cod-comprado:sensitive in frame {&frame-name} and
        not can-find (comprador where comprador.cod-comprado = input frame {&frame-name} c-cod-comprado)
        then do:
        /* Comprador nao cadastrado */
        {include/i-vldprg.i}
        {utp/ut-field.i mgind evento-ped cod-comprado 1}
        run utp/ut-msgs.p (input "show",input 47, input trim(return-value)).
        apply "entry" to c-cod-comprado in frame {&frame-name}.
        return "adm-error".
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

