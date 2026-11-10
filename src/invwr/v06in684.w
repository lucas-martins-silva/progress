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
{include/i-prgvrs.i V06IN684 2.00.00.015}  /*** "010015" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN684 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES item-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-uni-estab.reporte-mob ~
item-uni-estab.reporte-ggf item-uni-estab.log-control-estoq-refugo ~
item-uni-estab.log-refugo-preco-fisc item-uni-estab.cod-item-refugo ~
item-uni-estab.val-relac-refugo-item 
&Scoped-define ENABLED-TABLES item-uni-estab
&Scoped-define FIRST-ENABLED-TABLE item-uni-estab
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-refugo rt-mold fi-rep-mob ~
fi-rep-ggf 
&Scoped-Define DISPLAYED-FIELDS item-uni-estab.reporte-mob ~
item-uni-estab.reporte-ggf item-uni-estab.log-control-estoq-refugo ~
item-uni-estab.log-refugo-preco-fisc item-uni-estab.cod-item-refugo ~
item-uni-estab.val-relac-refugo-item 
&Scoped-define DISPLAYED-TABLES item-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-uni-estab
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-alocac cb-ind-refugo ~
cb-tipo-requis cb-report-prod cb-proc-custos c-desc-item fi-rep-mob ~
fi-rep-ggf cTextRefugo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-tipo-alocac cb-ind-refugo ~
cb-tipo-requis cb-report-prod cb-proc-custos 
&Scoped-define ADM-ASSIGN-FIELDS item-uni-estab.reporte-mob ~
item-uni-estab.reporte-ggf cb-tipo-alocac cb-ind-refugo cb-tipo-requis ~
cb-report-prod cb-proc-custos item-uni-estab.log-control-estoq-refugo ~
item-uni-estab.log-refugo-preco-fisc item-uni-estab.cod-item-refugo ~
item-uni-estab.val-relac-refugo-item 
&Scoped-define ADM-MODIFY-FIELDS item-uni-estab.reporte-mob ~
item-uni-estab.reporte-ggf cb-tipo-alocac cb-ind-refugo cb-tipo-requis ~
cb-report-prod cb-proc-custos 

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
DEFINE VARIABLE cb-ind-refugo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-proc-custos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE cb-report-prod AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-alocac AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE cTextRefugo AS CHARACTER FORMAT "X(256)":U INITIAL "Refugo" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-rep-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-rep-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26 BY 1.5.

DEFINE RECTANGLE RECT-refugo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 9.

DEF VAR i-aux AS INT NO-UNDO.
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-uni-estab.reporte-mob AT ROW 1.96 COL 18 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 21 BY .88
     item-uni-estab.reporte-ggf AT ROW 2.04 COL 59 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 22 BY .79
     cb-tipo-alocac AT ROW 3.21 COL 21 COLON-ALIGNED
     cb-ind-refugo AT ROW 3.21 COL 65 COLON-ALIGNED
     cb-tipo-requis AT ROW 4.21 COL 21 COLON-ALIGNED
     cb-report-prod AT ROW 4.21 COL 65 COLON-ALIGNED
     cb-proc-custos AT ROW 5.21 COL 21 COLON-ALIGNED
     item-uni-estab.log-control-estoq-refugo AT ROW 6.75 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .79
     item-uni-estab.log-refugo-preco-fisc AT ROW 6.75 COL 53
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .79
     item-uni-estab.cod-item-refugo AT ROW 7.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-item AT ROW 7.5 COL 34 COLON-ALIGNED NO-LABEL
     item-uni-estab.val-relac-refugo-item AT ROW 8.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     fi-rep-mob AT ROW 1.25 COL 15 COLON-ALIGNED NO-LABEL
     fi-rep-ggf AT ROW 1.25 COL 57 COLON-ALIGNED NO-LABEL
     cTextRefugo AT ROW 6.25 COL 2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.5 COL 15
     RECT-2 AT ROW 1.5 COL 57
     RECT-refugo AT ROW 6.5 COL 2
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-uni-estab
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
         HEIGHT             = 9
         WIDTH              = 84.14.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 9
       FRAME f-main:WIDTH            = 84.14.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-refugo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-proc-custos IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-report-prod IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-alocac IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item-uni-estab.cod-item-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN cTextRefugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX item-uni-estab.log-control-estoq-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX item-uni-estab.log-refugo-preco-fisc IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR RADIO-SET item-uni-estab.reporte-ggf IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET item-uni-estab.reporte-mob IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.val-relac-refugo-item IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME cb-ind-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ind-refugo V-table-Win
ON VALUE-CHANGED OF cb-ind-refugo IN FRAME f-main
DO:
   run notify ('pi-atualiza,state-source').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.cod-item-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-item-refugo V-table-Win
ON F5 OF item-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                         &campo=item-uni-estab.cod-item-refugo
                         &campozoom=it-codigo
                         &campo2=c-desc-item
                         &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-item-refugo V-table-Win
ON LEAVE OF item-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
      {include/leave.i &tabela=ITEM
                             &atributo-ref=desc-item
                             &variavel-ref=c-desc-item
                             &where="item.it-codigo = input frame {&frame-name} item-uni-estab.cod-item-refugo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-item-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.log-control-estoq-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.log-control-estoq-refugo V-table-Win
ON VALUE-CHANGED OF item-uni-estab.log-control-estoq-refugo IN FRAME f-main /* Contr Est Refugo */
DO:
    IF  item-uni-estab.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN item-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               item-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
               item-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN item-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               item-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               item-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    {utp/ut-field.i mgind item-uni-estab sit-aloc 1}
    ASSIGN cb-tipo-alocac:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    {utp/ut-field.i mgind item-uni-estab rep-prod 1}
    ASSIGN cb-report-prod:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    {utp/ut-field.i mgind item-uni-estab ind-refugo 01}
    ASSIGN cb-ind-refugo:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    {utp/ut-field.i mgind item-uni-estab tipo-requis 01}
    ASSIGN cb-tipo-requis:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    {utp/ut-field.i mgind item-uni-estab ind-lista-csp 01}
    ASSIGN cb-proc-custos:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    item-uni-estab.cod-item-refugo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "item-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-uni-estab"}

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
    {include/i-valid.i}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    IF  AVAIL item-uni-estab then DO :
        ASSIGN item-uni-estab.sit-aloc      = {ininc/i18in172.i 06 cb-tipo-alocac}
               item-uni-estab.rep-prod      = {ininc/i12in172.i 06 cb-report-prod}
               item-uni-estab.tipo-requis   = {ininc/i08in122.i 06 cb-tipo-requis}
               item-uni-estab.ind-lista-csp = {mfinc/i03mf172.i 06 cb-proc-custos}
               item-uni-estab.ind-refugo    = {ininc/i01in180.i 06 cb-ind-refugo}.

        IF item-uni-estab.tipo-requis = 3
            AND CAN-FIND(FIRST reservas
                          WHERE reservas.it-codigo = item-uni-estab.it-codigo
                            AND reservas.estado = 1) THEN DO:

             RUN utp/ut-msgs.p(INPUT "show",
                               INPUT 56145,
                               INPUT item-uni-estab.it-codigo).

             IF RETURN-VALUE = "YES":U THEN DO:
                 FIND FIRST ITEM 
                      WHERE ITEM.it-codigo = item-uni-estab.it-codigo.

                  RUN cpp/cp0204.w(INPUT ROWID(item),
                                   INPUT 2).
             END. 
        END.
    END.

    &IF defined(bf_man_sfc_ref_oper) &THEN
    IF item-uni-estab.log-control-estoq-refugo:CHECKED in frame {&frame-name} = no then 
       assign item-uni-estab.cod-item-refugo = ""
              item-uni-estab.val-relac-refugo-item = 0 
              item-uni-estab.log-refugo-preco-fisc  = no.
    &endif          

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail item-uni-estab then do with frame {&frame-name}:
      assign cb-tipo-alocac:screen-value = {ininc/i18in172.i 04 item-uni-estab.sit-aloc}
             cb-report-prod:screen-value = {ininc/i12in172.i 04 item-uni-estab.rep-prod}
             cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 item-uni-estab.ind-refugo}
             cb-tipo-requis:screen-value = {ininc/i08in122.i 04 item-uni-estab.tipo-requis}
             cb-proc-custos:SCREEN-VALUE = {mfinc/i03mf172.i 04 item-uni-estab.ind-lista-csp}.

      IF  item-uni-estab.cod-item-refugo <> " " THEN
          FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK:
              ASSIGN c-desc-item = ITEM.desc-item.
          END.

      &IF defined(bf_man_sfc_ref_oper) &THEN
      DISP item-uni-estab.log-control-estoq-refugo
           item-uni-estab.log-refugo-preco-fisc
           item-uni-estab.cod-item-refugo
           item-uni-estab.val-relac-refugo-item
           c-desc-item.             
      &endif     
      APPLY "leave":U TO item-uni-estab.cod-item-refugo IN FRAME {&FRAME-NAME}.
  end.
  else do:
      assign cb-tipo-alocac:screen-value = {ininc/i18in172.i 04 01}
             cb-report-prod:screen-value = {ininc/i12in172.i 04 01}
             cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 01}
             cb-tipo-requis:screen-value = {ininc/i08in122.i 04 01}
             cb-proc-custos:SCREEN-VALUE = {mfinc/i03mf172.i 04 01}.

      &IF defined(bf_man_sfc_ref_oper) &THEN       
      ASSIGN item-uni-estab.log-control-estoq-refugo:CHECKED   = NO
             item-uni-estab.log-refugo-preco-fisc:CHECKED      = NO
             item-uni-estab.cod-item-refugo:SCREEN-VALUE       = " "
             c-desc-item:SCREEN-VALUE                          = " "
             item-uni-estab.val-relac-refugo-item:SCREEN-VALUE = "0".             
      &endif       
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

  &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    IF  param-global.modulo-ch THEN DO:
        assign item-uni-estab.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        IF  item-uni-estab.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN item-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   item-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                   item-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN item-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   item-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                   item-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    end.
    ELSE
    ASSIGN item-uni-estab.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           item-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           item-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
           item-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  &endif          

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF NOT param-global.modulo-cs THEN
      ASSIGN cb-proc-custos:SENSITIVE = FALSE.

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

  DO WITH FRAME {&frame-name}:
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
   DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
   ASSIGN cAuxTraducao001 = {ininc/i18in172.i 03}.
   RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
   ASSIGN cb-tipo-alocac:LIST-ITEM-PAIRS = cAuxTraducao001 .
&else
   ASSIGN cb-tipo-alocac:LIST-ITEMS = {ininc/i18in172.i 03} .
&endif
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao002 = {ininc/i12in172.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
          ASSIGN cb-report-prod:LIST-ITEM-PAIRS = cAuxTraducao002.
      &else
          ASSIGN cb-report-prod:LIST-ITEMS = {ininc/i12in172.i 03}.
      &endif
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao003 = {ininc/i01in180.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
          ASSIGN cb-ind-refugo:LIST-ITEM-PAIRS  = cAuxTraducao003.
      &else
          ASSIGN cb-ind-refugo:LIST-ITEMS  = {ininc/i01in180.i 03}.
      &endif
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao004 = {ininc/i08in122.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
          ASSIGN cb-tipo-requis:LIST-ITEM-PAIRS  = cAuxTraducao004.
      &else
          ASSIGN cb-tipo-requis:LIST-ITEMS  = {ininc/i08in122.i 03}.
      &endif
      
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao005 = {mfinc/i03mf172.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
          ASSIGN cb-proc-custos:LIST-ITEM-PAIRS  = cAuxTraducao005.
      &else
          ASSIGN cb-proc-custos:LIST-ITEMS  = {mfinc/i03mf172.i 03}.
      &endif

      {utp/ut-field.i mgind item-uni-estab reporte-mob 1}
      ASSIGN fi-rep-mob = RETURN-VALUE
             fi-rep-mob:screen-value = RETURN-VALUE.

      {utp/ut-field.i mgind item-uni-estab reporte-ggf 1}
      ASSIGN fi-rep-ggf = RETURN-VALUE
             fi-rep-ggf:screen-value = RETURN-VALUE.             

  END. 

  &IF defined(bf_man_sfc_ref_oper) &THEN
      assign cTextRefugo:hidden in frame {&frame-name} = no
             rect-refugo:hidden in frame {&frame-name} = no
             item-uni-estab.log-control-estoq-refugo:hidden in frame {&frame-name} = no
             item-uni-estab.log-refugo-preco-fisc:hidden in frame {&frame-name} = no
             item-uni-estab.cod-item-refugo:hidden in frame {&frame-name} = no
             c-desc-item:hidden in frame {&frame-name} = no
             item-uni-estab.val-relac-refugo-item:hidden in frame {&frame-name} = no.
  &else
      assign cTextRefugo:hidden in frame {&frame-name} = yes
             rect-refugo:hidden in frame {&frame-name} = yes
             item-uni-estab.log-control-estoq-refugo:hidden in frame {&frame-name} = yes
             item-uni-estab.log-refugo-preco-fisc:hidden in frame {&frame-name} = yes
             item-uni-estab.cod-item-refugo:hidden in frame {&frame-name} = yes
             c-desc-item:hidden in frame {&frame-name} = yes
             item-uni-estab.val-relac-refugo-item:hidden in frame {&frame-name} = yes.
  &endif               
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

/*********
    if  cb-tipo-contr:lookup(cb-tipo-contr:screen-value)  <> 1 
    and cb-tipo-contr:lookup(cb-tipo-contr:screen-value)  <> 2 
    and cb-report-prod:lookup(cb-report-prod:screen-value) = 4 then do :
        /* Tipo de controle do item deve ser Fisico ou Total */
        run utp/ut-msgs.p (input "show",
                           input 1941  ,
                           input ""    ).
        apply "entry" to cb-tipo-contr in frame {&frame-name}.
        return "adm-error".
    end.
  *********/
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                  INPUT "cb-politica").
    ASSIGN i-aux = {ininc/i04in122.i 06 RETURN-VALUE}. 


    if  /*item-uni-estab.politica*/ i-aux <> 1 
    and /*item-uni-estab.politica*/ i-aux <> 2 
    and cb-report-prod:lookup(cb-report-prod:screen-value) =  4 then do:
        /* Politica do Item deve ser Periodo Fixo ou Lote Economico */
        run utp/ut-msgs.p (input "show",
                           input 1942  ,
                           input ""    ).
        apply "entry" to cb-report-prod in frame {&frame-name}.
        return "adm-error".
    end.

     &IF DEFINED (bf_man_sfc_ref_oper) &THEN
      IF  item-uni-estab.log-control-estoq-refugo:CHECKED THEN DO:

          /*Item refugo n∆o pode ser o item branco*/
          IF  item-uni-estab.cod-item-refugo:SCREEN-VALUE = " " THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 29469 ,
                                 input "").
              apply "entry" to item-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          /*Item Refugo n∆o pode ser o proprio item*/                                  
          IF  item-uni-estab.cod-item-refugo:SCREEN-VALUE in frame {&frame-name} = item-uni-estab.it-codigo
          THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 29464 ,
                                 input "").
              apply "entry" to item-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.


          FOR FIRST ITEM FIELDS(it-codigo tipo-contr tipo-con-est)
              WHERE ITEM.it-codigo = item-uni-estab.cod-item-refugo:SCREEN-VALUE NO-LOCK: END.
          IF  NOT AVAIL ITEM THEN DO:
              {utp/ut-field.i mgind item cod-item-refugo 1}
              run utp/ut-msgs.p (input "show",
                                 input 2 ,
                                 input return-value).
              apply "entry" to item-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          /*Item deve ser de controle total*/
          IF  ITEM.tipo-contr <> 2 THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 29462 ,
                                 input "").
              apply "entry" to item-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          /*Item deve ter tipo de controle de estoque Serial*/
          IF  ITEM.tipo-con-est <> 1 THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 29463 ,
                                 input "").
              apply "entry" to item-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  DEC(item-uni-estab.val-relac-refugo-item:SCREEN-VALUE) <= 0
          OR  DEC(item-uni-estab.val-relac-refugo-item:SCREEN-VALUE)  = ? THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 28174 ,
                                 input "").
              apply "entry" to item-uni-estab.val-relac-refugo-item in frame {&frame-name}.
              return "adm-error".
          END.

      END.
      &ENDIF    

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
  {src/adm/template/snd-list.i "item-uni-estab"}

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

