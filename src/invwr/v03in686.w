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
{include/i-prgvrs.i V03IN686 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN686 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

DEF NEW GLOBAL SHARED VAR gr-familia  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-planejad AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod AS rowid NO-UNDO.

DEF VAR i-reporte-ggf as integer no-undo.
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
&Scoped-define EXTERNAL-TABLES fam-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-uni-estab.reporte-mob ~
fam-uni-estab.reporte-ggf fam-uni-estab.log-control-estoq-refugo ~
fam-uni-estab.log-refugo-preco-fisc fam-uni-estab.cod-item-refugo ~
fam-uni-estab.val-relac-refugo-item 
&Scoped-define ENABLED-TABLES fam-uni-estab
&Scoped-define FIRST-ENABLED-TABLE fam-uni-estab
&Scoped-define DISPLAYED-TABLES fam-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE fam-uni-estab
&Scoped-Define ENABLED-OBJECTS fi-rep-mob fi-rep-ggf RECT-1 RECT-2 ~
RECT-refugo rt-mold 
&Scoped-Define DISPLAYED-FIELDS fam-uni-estab.reporte-mob ~
fam-uni-estab.reporte-ggf fam-uni-estab.log-control-estoq-refugo ~
fam-uni-estab.log-refugo-preco-fisc fam-uni-estab.cod-item-refugo ~
fam-uni-estab.val-relac-refugo-item 
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-aloc-fam cb-ind-refugo cb-rep-prod ~
c-desc-item fi-rep-mob fi-rep-ggf cTextRefugo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fam-uni-estab.reporte-mob ~
fam-uni-estab.reporte-ggf cb-tipo-aloc-fam cb-ind-refugo cb-rep-prod ~
fam-uni-estab.cod-item-refugo fam-uni-estab.val-relac-refugo-item 
&Scoped-define ADM-MODIFY-FIELDS fam-uni-estab.reporte-mob ~
fam-uni-estab.reporte-ggf cb-tipo-aloc-fam cb-ind-refugo cb-rep-prod 

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
/*      LIST-ITEMS "Item 1" */
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-rep-prod AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "":R16 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "Item 1" */
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-aloc-fam AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "Item 1" */
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE cTextRefugo AS CHARACTER FORMAT "X(256)":U INITIAL "Refugo" 
      VIEW-AS TEXT 
     SIZE 11 BY .65 NO-UNDO.

DEFINE VARIABLE fi-rep-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .65 NO-UNDO.

DEFINE VARIABLE fi-rep-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 1.5.

DEFINE RECTANGLE RECT-refugo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 3.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 7.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fam-uni-estab.reporte-mob AT ROW 2 COL 14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 25 BY .77
     fam-uni-estab.reporte-ggf AT ROW 2 COL 57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 21 BY .77
     cb-tipo-aloc-fam AT ROW 3.27 COL 22 COLON-ALIGNED
     cb-ind-refugo AT ROW 3.27 COL 66 COLON-ALIGNED
     cb-rep-prod AT ROW 4.27 COL 66 COLON-ALIGNED HELP
          "Informar como as ordens de produá∆o ser∆o reportadas"
     fam-uni-estab.log-control-estoq-refugo AT ROW 5.77 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     fam-uni-estab.log-refugo-preco-fisc AT ROW 5.77 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .81
     fam-uni-estab.cod-item-refugo AT ROW 6.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-item AT ROW 6.5 COL 34 COLON-ALIGNED NO-LABEL
     fam-uni-estab.val-relac-refugo-item AT ROW 7.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     fi-rep-mob AT ROW 1.27 COL 12 COLON-ALIGNED NO-LABEL
     fi-rep-ggf AT ROW 1.27 COL 55 COLON-ALIGNED NO-LABEL
     cTextRefugo AT ROW 5.27 COL 3 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.5 COL 12
     RECT-2 AT ROW 1.5 COL 54
     RECT-refugo AT ROW 5.5 COL 2
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-uni-estab
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
         HEIGHT             = 8
         WIDTH              = 86.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-ind-refugo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-rep-prod IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-aloc-fam IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fam-uni-estab.cod-item-refugo IN FRAME f-main
   2                                                                    */
ASSIGN 
       fam-uni-estab.cod-item-refugo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN cTextRefugo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fam-uni-estab.log-control-estoq-refugo:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fam-uni-estab.log-refugo-preco-fisc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-refugo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET fam-uni-estab.reporte-ggf IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET fam-uni-estab.reporte-mob IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN fam-uni-estab.val-relac-refugo-item IN FRAME f-main
   2                                                                    */
ASSIGN 
       fam-uni-estab.val-relac-refugo-item:HIDDEN IN FRAME f-main           = TRUE.

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


&Scoped-define SELF-NAME fam-uni-estab.cod-item-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cod-item-refugo V-table-Win
ON F5 OF fam-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                         &campo=fam-uni-estab.cod-item-refugo
                         &campozoom=it-codigo
                         &campo2=c-desc-item
                         &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cod-item-refugo V-table-Win
ON LEAVE OF fam-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
      {include/leave.i &tabela=ITEM
                             &atributo-ref=desc-item
                             &variavel-ref=c-desc-item
                             &where="item.it-codigo = input frame {&frame-name} fam-uni-estab.cod-item-refugo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cod-item-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-uni-estab.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-uni-estab.log-control-estoq-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.log-control-estoq-refugo V-table-Win
ON VALUE-CHANGED OF fam-uni-estab.log-control-estoq-refugo IN FRAME f-main /* Contr Est Refugo */
DO:
    
        IF  fam-uni-estab.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                   fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE DO:
            ASSIGN fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.cod-item-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fam-uni-estab.log-refugo-preco-fisc:CHECKED IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.val-relac-refugo-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(0.00) 
                   c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". 
        END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    {utp/ut-field.i mgind fam-uni-estab sit-aloc 1}
    assign cb-tipo-aloc-fam:label = return-value.

    {utp/ut-field.i mgind fam-uni-estab rep-prod 1}
    assign cb-rep-prod:label = return-value.

    {utp/ut-field.i mgind fam-uni-estab ind-refugo 01}
    ASSIGN cb-ind-refugo:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

    fam-uni-estab.cod-item-refugo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "fam-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-uni-estab"}

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

    {include/i-valid.i}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if  avail fam-uni-estab then do :
        find current fam-uni-estab exclusive-lock.
        assign input frame {&frame-name} cb-tipo-aloc-fam               
               input frame {&frame-name} cb-rep-prod
               input frame {&frame-name} cb-ind-refugo
               fam-uni-estab.sit-aloc    = {ininc/i18in172.i 06 cb-tipo-aloc-fam}.

        &IF defined(bf_man_sfc_ref_oper) &THEN
        assign fam-uni-estab.reporte-mob = input frame {&frame-name} fam-uni-estab.reporte-mob
               fam-uni-estab.reporte-ggf = input frame {&frame-name} fam-uni-estab.reporte-ggf               
               fam-uni-estab.rep-prod    = {ininc/i12in172.i 06 cb-rep-prod}
               fam-uni-estab.ind-refugo  = {ininc/i01in180.i 06 cb-ind-refugo}.
        &ENDIF       
    end.

    &IF defined(bf_man_sfc_ref_oper) &THEN                                          
    IF fam-uni-estab.log-control-estoq-refugo:CHECKED in frame {&frame-name} = no then 
       assign fam-uni-estab.cod-item-refugo = ""
              fam-uni-estab.val-relac-refugo-item = 0 
              fam-uni-estab.log-refugo-preco-fisc  = no.
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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    &IF defined(bf_man_sfc_ref_oper) &THEN
    ASSIGN fam-uni-estab.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

    if  avail fam-uni-estab then do with frame {&frame-name}:

        assign cb-tipo-aloc-fam = if  fam-uni-estab.sit-aloc > 0 
                                  then {ininc/i18in172.i 04 fam-uni-estab.sit-aloc}
                                  else {ininc/i18in172.i 04 1}
               cb-rep-prod      = if  fam-uni-estab.rep-prod > 0 
                                  then {ininc/i12in172.i 04 fam-uni-estab.rep-prod}
                                  else {ininc/i12in172.i 04 1}
               cb-ind-refugo    = if  fam-uni-estab.ind-refugo > 0 
                                  then {ininc/i01in180.i 04 fam-uni-estab.ind-refugo}
                                  else {ininc/i01in180.i 04 1}.

      IF  fam-uni-estab.cod-item-refugo <> " " THEN
          FOR FIRST ITEM FIELDS(it-codigo desc-item) WHERE ITEM.it-codigo = fam-uni-estab.cod-item-refugo NO-LOCK:
              ASSIGN c-desc-item = ITEM.desc-item.
          END.

      &IF defined(bf_man_sfc_ref_oper) &THEN
      DISP fam-uni-estab.log-control-estoq-refugo
           fam-uni-estab.log-refugo-preco-fisc
           fam-uni-estab.cod-item-refugo
           fam-uni-estab.val-relac-refugo-item
           c-desc-item.                     
      &endif                       
    end.
    else do:
        assign cb-tipo-aloc-fam = {ininc/i18in172.i 04 1}
               cb-rep-prod      = {ininc/i12in172.i 04 1}
               cb-ind-refugo    = {ininc/i01in180.i 04 1}.

          &IF defined(bf_man_sfc_ref_oper) &THEN   
          ASSIGN fam-uni-estab.log-control-estoq-refugo:CHECKED   = NO
                 fam-uni-estab.log-refugo-preco-fisc:CHECKED      = NO
                 fam-uni-estab.cod-item-refugo:SCREEN-VALUE       = " "
                 c-desc-item:SCREEN-VALUE                          = " "
                 fam-uni-estab.val-relac-refugo-item:SCREEN-VALUE = "0".                    
          &endif       
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    APPLY "leave":U TO fam-uni-estab.cod-item-refugo IN FRAME {&FRAME-NAME}.

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

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    IF  param-global.modulo-ch THEN do:
        assign fam-uni-estab.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        IF  fam-uni-estab.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                   fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                   fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    end.
    ELSE
    ASSIGN fam-uni-estab.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
           fam-uni-estab.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
  &ENDIF         

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

  find first param-global no-lock no-error.

  do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.

         assign c-lista = {ininc/i18in172.i 03}.
	     run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-aloc-fam:list-item-pairs = c-lista.

         assign c-lista = {ininc/i12in172.i 03}.
	     run utp/ut-lstit.p (input-output c-lista).
         assign cb-rep-prod:list-item-pairs = c-lista.

         assign c-lista = {ininc/i01in180.i 03}.
	     run utp/ut-lstit.p (input-output c-lista).
         assign cb-ind-refugo:list-item-pairs = c-lista.
     
     &else
         assign cb-tipo-aloc-fam:list-items = {ininc/i18in172.i 03}           
                cb-rep-prod:list-items      = {ininc/i12in172.i 03}
                cb-ind-refugo:LIST-ITEMS    = {ininc/i01in180.i 03}.
     &endif

     {utp/ut-field.i mgind fam-uni-estab reporte-mob 1}
     assign fi-rep-mob = return-value
            fi-rep-mob:screen-value = return-value.

     {utp/ut-field.i mgind item reporte-ggf 1}
     assign fi-rep-ggf = return-value
            fi-rep-ggf:screen-value = return-value.

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF defined(bf_man_sfc_ref_oper) &THEN
      assign cTextRefugo:hidden in frame {&frame-name} = no
             rect-refugo:hidden in frame {&frame-name} = no
             fam-uni-estab.log-control-estoq-refugo:hidden in frame {&frame-name} = no
             fam-uni-estab.log-refugo-preco-fisc:hidden in frame {&frame-name} = no
             fam-uni-estab.cod-item-refugo:hidden in frame {&frame-name} = no
             c-desc-item:hidden in frame {&frame-name} = no
             fam-uni-estab.val-relac-refugo-item:hidden in frame {&frame-name} = no.
  &else
      assign cTextRefugo:hidden in frame {&frame-name} = yes
             rect-refugo:hidden in frame {&frame-name} = yes
             fam-uni-estab.log-control-estoq-refugo:hidden in frame {&frame-name} = yes
             fam-uni-estab.log-refugo-preco-fisc:hidden in frame {&frame-name} = yes
             fam-uni-estab.cod-item-refugo:hidden in frame {&frame-name} = yes
             c-desc-item:hidden in frame {&frame-name} = yes
             fam-uni-estab.val-relac-refugo-item:hidden in frame {&frame-name} = yes.
  &endif             

  /* Code placed here will execute AFTER standard behavior.    */

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

    Do  with frame {&frame-name}:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            if  fam-uni-estab.politica       <> 1 
            and fam-uni-estab.politica       <> 2 
            and cb-rep-prod:lookup(cb-rep-prod:screen-value ) =  8 then do:
                run utp/ut-msgs.p (input "show",
                                   input 8533,
                                   input "").
                apply "entry" to cb-rep-prod in frame {&frame-name}.
                return "adm-error".
            end.
        &else
            if  fam-uni-estab.politica       <> 1 
            and fam-uni-estab.politica       <> 2 
            and cb-rep-prod:lookup(cb-rep-prod:screen-value ) =  4 then do:
                run utp/ut-msgs.p (input "show",
                                   input 8533,
                                   input "").
                apply "entry" to cb-rep-prod in frame {&frame-name}.
                return "adm-error".
            end.
        &endif
    end.

     &IF DEFINED (bf_man_sfc_ref_oper) &THEN
      IF  fam-uni-estab.log-control-estoq-refugo:CHECKED THEN DO:
          IF  fam-uni-estab.cod-item-refugo:SCREEN-VALUE = " " THEN DO:
              {utp/ut-liter.i Item_refugo_n∆o_pode_ser_o_item_branco *}
              run utp/ut-msgs.p (input "show",
                                 input 29469 ,
                                 input  Return-value ).
              apply "entry" to fam-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          FOR FIRST ITEM FIELDS(it-codigo tipo-contr tipo-con-est)
              WHERE ITEM.it-codigo = fam-uni-estab.cod-item-refugo:SCREEN-VALUE NO-LOCK: END.
          IF  NOT AVAIL ITEM THEN DO:
              {utp/ut-liter.i Item_n∆o_cadastrado *}
              run utp/ut-msgs.p (input "show",
                                 input 17006 ,
                                 input  Return-value ).
              apply "entry" to fam-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  ITEM.tipo-contr <> 2 THEN DO:
              {utp/ut-liter.i Item_deve_ser_de_controle_total *}
              run utp/ut-msgs.p (input "show",
                                 input 29462 ,
                                 input  Return-value ).
              apply "entry" to fam-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  ITEM.tipo-con-est <> 1 THEN DO:
              {utp/ut-liter.i Item_deve_ter_tipo_de_controle_de_estoque_Serial *}
              run utp/ut-msgs.p (input "show",
                                 input 29463 ,
                                 input  Return-value ).
              apply "entry" to fam-uni-estab.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  DEC(fam-uni-estab.val-relac-refugo-item:SCREEN-VALUE) <= 0
          OR  DEC(fam-uni-estab.val-relac-refugo-item:SCREEN-VALUE)  = ? THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 28174 ,
                                 input "").
              apply "entry" to fam-uni-estab.val-relac-refugo-item in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "fam-uni-estab"}

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

