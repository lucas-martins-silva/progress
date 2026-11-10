&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
          movmfg           PROGRESS
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
{include/i-prgvrs.i V02IN533 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN533 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.

def var i-num-secs as integer no-undo.
def var de-hra-imc as decimal no-undo.
def var de-hra-fmt as decimal no-undo.
def var c-hra      as char    no-undo.
def var c-texto    as char    no-undo.
def var c-estado1  as char    no-undo.
def var c-estado2  as char    no-undo.
def var c-estado3  as char    no-undo.
def var h-boin533  as handle  no-undo.

def buffer b-op-sfc for op-sfc.

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
&Scoped-define EXTERNAL-TABLES op-sfc
&Scoped-define FIRST-EXTERNAL-TABLE op-sfc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-sfc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-sfc.dat-imc op-sfc.dat-fmt ~
op-sfc.val-priorid-ext 
&Scoped-define ENABLED-TABLES op-sfc
&Scoped-define FIRST-ENABLED-TABLE op-sfc
&Scoped-Define ENABLED-OBJECTS c-hra-imc c-hra-fmt RECT-1 RECT-2 rt-key ~
rt-mold 
&Scoped-Define DISPLAYED-FIELDS op-sfc.nr-ord-produ op-sfc.it-codigo ~
op-sfc.cod-refer op-sfc.dat-inic-op-cp op-sfc.dat-fim-op-cp op-sfc.qtd-op ~
op-sfc.nome-abrev op-sfc.cod-ped-op op-sfc.dat-imc op-sfc.dat-fmt ~
op-sfc.val-priorid-ext 
&Scoped-define DISPLAYED-TABLES op-sfc
&Scoped-define FIRST-DISPLAYED-TABLE op-sfc
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-un-item c-tp-reporte ~
c-processo c-hra-imc c-hra-fmt 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS op-sfc.nr-ord-produ 
&Scoped-define ADM-ASSIGN-FIELDS op-sfc.it-codigo op-sfc.cod-refer ~
op-sfc.dat-inic-op-cp op-sfc.dat-fim-op-cp op-sfc.qtd-op op-sfc.nome-abrev ~
op-sfc.cod-ped-op c-hra-imc c-hra-fmt 
&Scoped-define ADM-MODIFY-FIELDS op-sfc.dat-imc op-sfc.dat-fmt ~
op-sfc.val-priorid-ext c-hra-imc c-hra-fmt 

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
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-fmt AS CHARACTER FORMAT "99:99":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-imc AS CHARACTER FORMAT "99:99":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-processo AS CHARACTER FORMAT "X(35)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-reporte AS CHARACTER FORMAT "X(17)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-item AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 2.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 3.42.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     op-sfc.nr-ord-produ AT ROW 1.17 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     op-sfc.it-codigo AT ROW 2.5 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 2.5 COL 33.86 COLON-ALIGNED NO-LABEL
     op-sfc.cod-refer AT ROW 2.5 COL 74.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     op-sfc.dat-inic-op-cp AT ROW 3.5 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     op-sfc.dat-fim-op-cp AT ROW 3.5 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     op-sfc.qtd-op AT ROW 4.5 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     c-un-item AT ROW 4.5 COL 32 COLON-ALIGNED NO-LABEL
     op-sfc.nome-abrev AT ROW 6.21 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     c-tp-reporte AT ROW 6.21 COL 58.43 COLON-ALIGNED
     op-sfc.cod-ped-op AT ROW 7.21 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-processo AT ROW 7.21 COL 58.43 COLON-ALIGNED
     op-sfc.dat-imc AT ROW 8.79 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     op-sfc.dat-fmt AT ROW 9.79 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     op-sfc.val-priorid-ext AT ROW 10.79 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     c-hra-imc AT ROW 8.79 COL 58.43 COLON-ALIGNED
     c-hra-fmt AT ROW 9.79 COL 58.43 COLON-ALIGNED
     RECT-1 AT ROW 5.83 COL 1.14
     RECT-2 AT ROW 8.54 COL 1.29
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.op-sfc
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
         HEIGHT             = 11.04
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hra-fmt IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN c-hra-imc IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN c-processo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-reporte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN op-sfc.cod-ped-op IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.cod-refer IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.dat-fim-op-cp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.dat-fmt IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN op-sfc.dat-imc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN op-sfc.dat-inic-op-cp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.it-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.nome-abrev IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.nr-ord-produ IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN op-sfc.qtd-op IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN op-sfc.val-priorid-ext IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME op-sfc.nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-sfc.nr-ord-produ V-table-Win
ON F5 OF op-sfc.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                       &campo=op-sfc.nr-ord-produ
                       &campozoom=nr-ord-produ}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-sfc.nr-ord-produ V-table-Win
ON LEAVE OF op-sfc.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
  find first ord-prod
       where ord-prod.nr-ord-produ = input frame {&frame-name} op-sfc.nr-ord-produ
  no-lock no-error.
  if avail ord-prod then do:
     assign op-sfc.it-codigo:screen-value in frame {&frame-name}      = ord-prod.it-codigo
            op-sfc.cod-refer:screen-value in frame {&frame-name}      = ord-prod.cod-refer
            op-sfc.dat-inic-op-cp:screen-value in frame {&frame-name} = string(ord-prod.dt-inicio)
            op-sfc.dat-fim-op-cp:screen-value in frame {&frame-name}  = string(ord-prod.dt-termino)
            op-sfc.qtd-op:screen-value in frame {&frame-name}         = string(ord-prod.qt-ordem)
            op-sfc.nome-abrev:screen-value in frame {&frame-name}     = ord-prod.nome-abrev
            op-sfc.cod-ped-op:screen-value in frame {&frame-name}     = string(ord-prod.nr-pedido)
            op-sfc.dat-imc:screen-value in frame {&frame-name}        = string(ord-prod.dt-inicio)
            op-sfc.dat-fmt:screen-value in frame {&frame-name}        = string(ord-prod.dt-termino)
            c-tp-reporte:screen-value in frame {&frame-name}          = {ininc/i07in271.i 04 ord-prod.rep-prod}
            c-processo:screen-value in frame {&frame-name}            = string(ord-prod.cod-roteiro + "/" +
                                                                               ord-prod.cod-lista-compon).
     find first item
          where item.it-codigo = ord-prod.it-codigo no-lock no-error.
     if avail item then 
        assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item
               c-un-item:screen-value in frame {&frame-name}   = item.un. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-sfc.nr-ord-produ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-sfc.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i movind ord-prod rep-prod 01}
assign c-tp-reporte:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Processo * R}
assign c-processo:label in frame {&frame-name} = return-value.

{utp/ut-field.i movind op-sfc qtd-segs-imc 01}
assign c-hra-imc:label in frame {&frame-name} = return-value.

{utp/ut-field.i movind op-sfc qtd-segs-fmt 01}
assign c-hra-fmt:label in frame {&frame-name} = return-value.

if op-sfc.nr-ord-produ:load-mouse-pointer ("image/lupa.cur") then.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

{sfc/sf9000.i}

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
  {src/adm/template/row-list.i "op-sfc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-sfc"}

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
    /*{include/i-valid.i}*/

    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.    

    if adm-new-record then do:
        find first ord-prod
             where ord-prod.nr-ord-produ = input frame {&frame-name} op-sfc.nr-ord-produ
        no-lock no-error.
        if not avail ord-prod then do:
            {utp/ut-table.i movind ord-prod 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to op-sfc.nr-ord-produ in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        else do:
            if ord-prod.estado >= 6 then do:
                assign c-estado1 = {ininc/i01in271.i 04 6}
                       c-estado2 = {ininc/i01in271.i 04 7}
                       c-estado3 = {ininc/i01in271.i 04 8}.
                run utp/ut-msgs.p (input 'show',
                                   input 17760,
                                   input c-estado1 + "~~" + c-estado2 + "~~" + c-estado3).
                apply 'entry' to op-sfc.nr-ord-produ in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.                                     
        end.

        if can-find(first b-op-sfc 
                    where b-op-sfc.nr-ord-produ = input frame {&frame-name} op-sfc.nr-ord-produ) then do:
           {utp/ut-table.i movind op-sfc 01}
           run utp/ut-msgs.p (input 'show',
                              input 1,
                              input return-value).
           apply 'entry' to op-sfc.nr-ord-produ in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.
    end.                    

    if input frame {&frame-name} op-sfc.dat-imc > input frame {&frame-name} op-sfc.dat-fmt
    then do:
        {utp/ut-field.i movind op-sfc dat-fmt 01}
        assign c-texto = return-value.
        {utp/ut-field.i movind op-sfc dat-imc 01}
        run utp/ut-msgs.p (input 'show',
                           input 7395,
                           input c-texto + "~~" + return-value).
        apply 'entry' to op-sfc.dat-imc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if input frame {&frame-name} c-hra-imc > "2400" or
       input frame {&frame-name} c-hra-fmt > "2400" then do:
        {utp/ut-liter.i Hora * R}
        run utp/ut-msgs.p (input 'show',
                           input 16445,
                           input return-value + "~~" + "24").
        apply 'entry' to op-sfc.dat-imc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    run pi-formatted-time-to-sec (input input frame {&frame-name} c-hra-imc, output i-num-secs).
    assign de-hra-imc = i-num-secs.

    run pi-formatted-time-to-sec (input input frame {&frame-name} c-hra-fmt, output i-num-secs).
    assign de-hra-fmt = i-num-secs.    

    IF NOT (adm-new-record    = YES AND 
             adm-adding-record = YES) THEN  DO:
             RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . 
             if RETURN-VALUE = 'ADM-ERROR':U then                       
             return 'ADM-ERROR':U.                                  
     END.

     if adm-new-record then
         run gerarOrdemSFC in h-boin533 (buffer ord-prod).

     find first op-sfc
          where op-sfc.nr-ord-produ = ord-prod.nr-ord-produ exclusive-lock no-error.
     if avail op-sfc then do:     
         run AlterarDatasOrdemSFC in h-boin533 (buffer op-sfc,
                                                input frame {&frame-name} op-sfc.dat-imc,
                                                de-hra-imc,
                                                input frame {&frame-name} op-sfc.dat-fmt,
                                                de-hra-fmt).

         run AlterarPriorOrdemSFC in h-boin533 (buffer op-sfc,
                                                input frame {&frame-name} op-sfc.val-priorid-ext).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if available op-sfc and not adm-new-record then do with frame {&frame-name}:
       find item where item.it-codigo = op-sfc.it-codigo no-lock no-error.
       assign c-desc-item:screen-value = if avail item then item.desc-item else "":U
              c-un-item:screen-value   = if avail item then item.un        else "":U.

       find first ord-prod  
            where ord-prod.nr-ord-produ = op-sfc.nr-ord-produ no-lock no-error.
       if avail ord-prod then
       assign c-tp-reporte:screen-value = {ininc/i07in271.i 04 ord-prod.rep-prod}
              c-processo:screen-value   = string(ord-prod.cod-roteiro + "/" + ord-prod.cod-lista-compon).     

       run pi-sec-to-formatted-time (op-sfc.qtd-segs-imc, output c-hra).
       assign c-hra-imc:screen-value = c-hra.

       run pi-sec-to-formatted-time (op-sfc.qtd-segs-fmt, output c-hra).
       assign c-hra-fmt:screen-value = c-hra.               

  end.


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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-hbo V-table-Win 
PROCEDURE pi-atualiza-hbo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-hbo as handle.

assign h-boin533 = p-hbo.

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

/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "op-sfc"}

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

