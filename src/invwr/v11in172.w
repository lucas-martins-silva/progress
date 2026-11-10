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
{include/i-prgvrs.i V11IN172 2.00.01.015 } /*** "010115" 18/07/2024 10:42:50 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v11in172 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgman.i}

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Definicao da tabela de erros RowErros */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-item-eai LIKE ITEM.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
&ENDIF


DEF BUFFER b-item FOR ITEM.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica    NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.log-refugo-preco-fisc ~
item.cod-item-refugo item.val-relac-refugo-item 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-refugo rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.log-control-estoq-refugo ~
item.log-refugo-preco-fisc item.cod-item-refugo item.val-relac-refugo-item 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS cb-proc-custos cb-tipo-requis ~
cb-reporte-mob cb-reporte-ggf cb-tipo-alocac cb-ind-refugo cb-classe-repr ~
cb-tipo-conest cb-tipo-contr cb-report-prod cb-demanda c-desc-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-proc-custos cb-tipo-requis ~
cb-reporte-mob cb-reporte-ggf cb-tipo-alocac cb-ind-refugo cb-classe-repr ~
cb-tipo-conest cb-tipo-contr cb-report-prod cb-demanda 
&Scoped-define ADM-ASSIGN-FIELDS cb-proc-custos cb-tipo-requis ~
cb-reporte-mob cb-reporte-ggf cb-tipo-alocac cb-ind-refugo cb-classe-repr ~
cb-tipo-conest cb-tipo-contr cb-report-prod cb-demanda ~
item.log-control-estoq-refugo item.log-refugo-preco-fisc ~
item.cod-item-refugo item.val-relac-refugo-item 
&Scoped-define ADM-MODIFY-FIELDS cb-proc-custos cb-tipo-requis ~
cb-reporte-mob cb-reporte-ggf cb-tipo-alocac cb-ind-refugo cb-classe-repr ~
cb-tipo-conest cb-tipo-contr cb-report-prod cb-demanda 

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
DEFINE VARIABLE cb-classe-repr AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "":R15 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

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

DEFINE VARIABLE cb-reporte-ggf AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reporte-mob AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-alocac AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-conest AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-contr AS CHARACTER FORMAT "X(256)":U 
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
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-refugo AS CHARACTER FORMAT "X(256)":U INITIAL "Refugo" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 TOOLTIP "Refugo" NO-UNDO.

DEFINE RECTANGLE RECT-refugo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 3.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.43 BY 9.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-proc-custos AT ROW 6.13 COL 22 COLON-ALIGNED
     cb-tipo-requis AT ROW 1.13 COL 22 COLON-ALIGNED
     cb-reporte-mob AT ROW 2.13 COL 22 COLON-ALIGNED
     cb-reporte-ggf AT ROW 3.13 COL 22 COLON-ALIGNED
     cb-tipo-alocac AT ROW 4.13 COL 22 COLON-ALIGNED
     cb-ind-refugo AT ROW 5.13 COL 22 COLON-ALIGNED
     cb-classe-repr AT ROW 1.13 COL 60 COLON-ALIGNED
     cb-tipo-conest AT ROW 2.13 COL 60 COLON-ALIGNED
     cb-tipo-contr AT ROW 3.13 COL 60 COLON-ALIGNED
     cb-report-prod AT ROW 4.13 COL 60 COLON-ALIGNED
     cb-demanda AT ROW 5.13 COL 60 COLON-ALIGNED
     c-text-refugo AT ROW 6.83 COL 2 NO-LABEL
     c-desc-item AT ROW 8.46 COL 37.57 COLON-ALIGNED NO-LABEL
     item.log-control-estoq-refugo AT ROW 7.5 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 23.14 BY .71
     item.log-refugo-preco-fisc AT ROW 7.54 COL 62
          VIEW-AS TOGGLE-BOX
          SIZE 17.29 BY .71
     item.cod-item-refugo AT ROW 8.46 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     item.val-relac-refugo-item AT ROW 9.42 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     RECT-refugo AT ROW 7.17 COL 1.57
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 9.75
         WIDTH              = 85.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-refugo IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       c-text-refugo:PRIVATE-DATA IN FRAME f-main     = 
                "Refugo".

/* SETTINGS FOR COMBO-BOX cb-classe-repr IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-demanda IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-ind-refugo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-proc-custos IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-report-prod IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-reporte-ggf IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-reporte-mob IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-alocac IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-conest IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-contr IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item.cod-item-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX item.log-control-estoq-refugo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX item.log-refugo-preco-fisc IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item.val-relac-refugo-item IN FRAME f-main
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


&Scoped-define SELF-NAME item.cod-item-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-item-refugo V-table-Win
ON F5 OF item.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=ITEM.cod-item-refugo
                       &campozoom=it-codigo
                       &campo2=c-desc-item
                       &campozoom2=desc-item}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-item-refugo V-table-Win
ON LEAVE OF item.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    find b-item
        where b-item.it-codigo = input frame {&frame-name} item.cod-item-refugo no-lock no-error.
    if  avail b-item then
        assign c-desc-item:screen-value in frame {&frame-name} = string(b-item.desc-item).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-item-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.log-control-estoq-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.log-control-estoq-refugo V-table-Win
ON VALUE-CHANGED OF item.log-control-estoq-refugo IN FRAME f-main /* Contr Est Refugo */
DO:
    IF  item.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN item.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               item.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
               item.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN item.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               item.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               item.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               item.log-refugo-preco-fisc:CHECKED   IN FRAME {&FRAME-NAME} = no
               item.cod-item-refugo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
               item.val-relac-refugo-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

{utp/ut-field.i mgind item tipo-requis       1} ASSIGN cb-tipo-requis:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item reporte-mob       1} ASSIGN cb-reporte-mob:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item reporte-ggf       1} ASSIGN cb-reporte-ggf:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item sit-aloc          1} ASSIGN cb-tipo-alocac:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item classe-repro      1} ASSIGN cb-classe-repr:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item tipo-con-est      1} ASSIGN cb-tipo-conest:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item tipo-contr        1} ASSIGN cb-tipo-contr:LABEL  IN FRAME {&frame-name} = RETURN-VALUE.  
{utp/ut-field.i mgind item rep-prod          1} ASSIGN cb-report-prod:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
{utp/ut-field.i mgind item demanda           1} ASSIGN cb-demanda:LABEL     IN FRAME {&frame-name} = RETURN-VALUE.
/* {utp/ut-field.i mgind item-man ind-refugo 1} ASSIGN cb-ind-refugo:LABEL  IN FRAME {&frame-name} = RETURN-VALUE.*//* ksm41081 FO 1562656 */
{utp/ut-field.i mgind ITEM ind-refugo        1} ASSIGN cb-ind-refugo:LABEL  IN FRAME {&frame-name} = RETURN-VALUE.  /* ksm41081 FO 1562656 */
{utp/ut-field.i mgind item-man ind-lista-csp 1} ASSIGN cb-proc-custos:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

ITEM.cod-item-refugo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

    IF  AVAIL item then DO:
        ASSIGN item.tipo-requis  = {ininc/i08in122.i 06 cb-tipo-requis}              
               item.reporte-mob  = {ininc/i06in172.i 06 cb-reporte-mob}                              
               item.reporte-ggf  = {ininc/i06in172.i 06 cb-reporte-ggf} 
               item.sit-aloc     = {ininc/i18in172.i 06 cb-tipo-alocac}          
               item.classe-repr  = {ininc/i06in122.i 06 cb-classe-repr}            
               item.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-conest}                        
               item.tipo-contr   = {ininc/i09in122.i 06 cb-tipo-contr}    
               item.rep-prod     = {ininc/i12in172.i 06 cb-report-prod}
               item.demanda      = {ininc/i02in122.i 06 cb-demanda}
               item.ind-refugo   = {ininc/i01in180.i 06 cb-ind-refugo}.

        IF item.tipo-requis = 3
            AND CAN-FIND(FIRST reservas
                          WHERE reservas.it-codigo = item.it-codigo
                            AND reservas.estado = 1) THEN DO:

             RUN utp/ut-msgs.p(INPUT "show",
                               INPUT 56145,
                               INPUT item.it-codigo).

             IF RETURN-VALUE = "YES":U THEN DO:
                 
                  RUN cpp/cp0204.w(INPUT ROWID(item),
                                   INPUT 2).
             END. 
        END.

        find item-man where 
             item-man.it-codigo = item.it-codigo EXCLUSIVE-LOCK no-error.
        if  not available(item-man) then
            create item-man.
        buffer-copy item to item-man.
        ASSIGN item-man.ind-lista-csp = {mfinc/i03mf172.i 06 cb-proc-custos}.
    END.

      /* Integraá∆o Neogrid */
    RUN utp/ut-neog.p.
    IF  RETURN-VALUE = "OK" THEN
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST emitente FIELDS (cod-emitente)
            WHERE emitente.cod-emitente        = estabelec.cod-emitente
            AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
        &ELSE
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST dist-emitente FIELDS (cod-emitente)
            WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
            AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
        &ENDIF
            RUN adapters/neogrid/enp/aneen005.p (INPUT ROWID(item),
                                                 INPUT estabelec.cod-estabel,
                                                 INPUT estabelec.cod-emitente,
                                                 INPUT "Update").
        END.

   /* Integracao EAI - Itens */
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:
        CREATE tt-item-eai.
        BUFFER-COPY ITEM TO tt-item-eai.
        RUN adapters/xml/ma2/axsma003.p (INPUT "upd",
                                         INPUT "cp0105.w",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT TABLE tt-item-eai,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-item-eai.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}

           empty temp-table RowErrors NO-ERROR.

           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF
    

    IF CONNECTED('mgscm') THEN DO:
        IF item.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = ITEM.it-codigo  
                   ttItemReplica.desc-item    = ITEM.desc-item
                   ttItemReplica.unid-med     = ITEM.un
                   ttItemReplica.peso-bruto   = ITEM.peso-bruto
                   ttItemReplica.largura      = ITEM.largura
                   ttItemReplica.comprimento  = ITEM.comprim
                   ttItemReplica.altura       = ITEM.altura
                   ttItemReplica.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-conest} /*ITEM.tipo-con-est*/
                   ttItemReplica.fm-cod-com   = ITEM.fm-cod-com
                   ttItemReplica.fm-codigo    = ITEM.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                END.
                RUN destroy IN hDBOproxy.
                RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
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
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &if  defined(ADM-ASSIGN-FIELDS) &then
      disable {&ADM-ASSIGN-FIELDS} with frame {&frame-name}.
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */


    if  avail item then do with frame {&frame-name}:
        assign cb-tipo-requis:screen-value = {ininc/i08in122.i 04 item.tipo-requis}
               cb-reporte-mob:screen-value = {ininc/i06in172.i 04 item.reporte-mob}
               cb-reporte-ggf:screen-value = {ininc/i06in172.i 04 item.reporte-ggf}
               cb-tipo-alocac:screen-value = {ininc/i18in172.i 04 item.sit-aloc}
               cb-classe-repr:screen-value = {ininc/i06in122.i 04 item.classe-repr}
               cb-tipo-conest:screen-value = {ininc/i01in122.i 04 item.tipo-con-est}
               cb-tipo-contr:screen-value  = {ininc/i09in122.i 04 item.tipo-contr}
               cb-report-prod:screen-value = {ininc/i12in172.i 04 item.rep-prod}
               cb-demanda:screen-value     = {ininc/i02in122.i 04 item.demanda}.
        find first item-man
             where item-man.it-codigo = item.it-codigo no-lock no-error.
        IF  avail item-man then
        /*  assign cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 item-man.ind-refugo}*/ /*Ksm41081 FO 1562656 */
            assign cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 item.ind-refugo}  /*Ksm41081 FO 1562656 */
                   cb-proc-custos:SCREEN-VALUE = {mfinc/i03mf172.i 04 item-man.ind-lista-csp}.
        else
            assign cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 01}
                   cb-proc-custos:SCREEN-VALUE = {mfinc/i03mf172.i 04 01}.

        IF  ITEM.cod-item-refugo <> " " THEN
            FOR FIRST b-ITEM FIELDS(it-codigo desc-item) 
                WHERE b-item.it-codigo = item.cod-item-refugo NO-LOCK:
                ASSIGN c-desc-item = b-ITEM.desc-item.
            END.
        ELSE
            ASSIGN c-desc-item = " ".

        &IF defined(bf_man_sfc_ref_oper) &THEN
        DISP c-text-refugo
             ITEM.log-control-estoq-refugo
             item.log-refugo-preco-fisc
             item.cod-item-refugo
             item.val-relac-refugo-item
             c-desc-item.
        &endif     


    end.
    else do:
      assign cb-tipo-requis:screen-value = {ininc/i08in122.i 04 01}      
             cb-reporte-mob:screen-value = {ininc/i06in172.i 04 01}
             cb-reporte-ggf:screen-value = {ininc/i06in172.i 04 01}
             cb-tipo-alocac:screen-value = {ininc/i18in172.i 04 01}
             cb-classe-repr:screen-value = {ininc/i06in122.i 04 01}
             cb-tipo-conest:screen-value = {ininc/i01in122.i 04 01}
             cb-tipo-contr:screen-value  = {ininc/i09in122.i 04 01}
             cb-report-prod:screen-value = {ininc/i12in172.i 04 01}
             cb-demanda:screen-value     = {ininc/i02in122.i 04 01}
             cb-ind-refugo:screen-value  = {ininc/i01in180.i 04 01}
             cb-proc-custos:SCREEN-VALUE = {mfinc/i03mf172.i 04 01}.

      &IF defined(bf_man_sfc_ref_oper) &THEN
      {utp/ut-liter.i Refugo *}
      ASSIGN item.log-control-estoq-refugo:CHECKED   = NO
             item.log-refugo-preco-fisc:CHECKED      = NO
             item.cod-item-refugo:SCREEN-VALUE       = " "
             c-desc-item:SCREEN-VALUE                = " "
             c-text-refugo:screen-value              = return-value
             item.val-relac-refugo-item:SCREEN-VALUE = "0".
      &endif       
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign cb-tipo-conest:sensitive = not can-find(first saldo-estoq 
                                                 WHERE saldo-estoq.it-codigo = item.it-codigo)
         cb-tipo-contr:sensitive  = not param-global.modulo-ce
         cb-ind-refugo:sensitive in frame {&frame-name} = yes.

    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    IF  param-global.modulo-ch THEN do:
        assign item.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = yes. 
        IF  item.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN item.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   item.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                   item.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN item.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   item.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                   item.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    end.
    ELSE
        ASSIGN item.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               item.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               item.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               item.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &endif           

    IF NOT param-global.modulo-cs THEN
        ASSIGN cb-proc-custos:SENSITIVE IN FRAME {&FRAME-NAME} = NO.


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

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&frame-name}:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      
          DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.

          assign c-lista = {ininc/i08in122.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-tipo-requis:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i06in172.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-reporte-mob:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i06in172.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-reporte-ggf:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i18in172.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-tipo-alocac:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i06in122.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-classe-repr:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i01in122.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-tipo-conest:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i09in122.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-tipo-contr:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i12in172.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-report-prod:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i02in122.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-demanda:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {ininc/i01in180.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-ind-refugo:LIST-ITEM-PAIRS = c-lista.

          assign c-lista = {mfinc/i03mf172.i 03}.
              run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-proc-custos:LIST-ITEM-PAIRS = c-lista.

      &else

          ASSIGN cb-tipo-requis:LIST-ITEMS = {ininc/i08in122.i 03}
                 cb-reporte-mob:LIST-ITEMS = {ininc/i06in172.i 03}
                 cb-reporte-ggf:LIST-ITEMS = {ininc/i06in172.i 03}
                 cb-tipo-alocac:LIST-ITEMS = {ininc/i18in172.i 03} 
                 cb-classe-repr:LIST-ITEMS = {ininc/i06in122.i 03}
                 cb-tipo-conest:LIST-ITEMS = {ininc/i01in122.i 03}
                 cb-tipo-contr:LIST-ITEMS  = {ininc/i09in122.i 03} 
                 cb-report-prod:LIST-ITEMS = {ininc/i12in172.i 03}
                 cb-demanda:LIST-ITEMS     = {ininc/i02in122.i 03}
                 cb-ind-refugo:LIST-ITEMS  = {ininc/i01in180.i 03}
                 cb-proc-custos:LIST-ITEMS = {mfinc/i03mf172.i 03}.
      &endif
  END.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF defined(bf_man_sfc_ref_oper) &THEN

      assign c-Text-Refugo:hidden in frame {&frame-name} = no
             rect-refugo:hidden in frame {&frame-name} = no
             item.log-control-estoq-refugo:hidden in frame {&frame-name} = no
             item.log-refugo-preco-fisc:hidden in frame {&frame-name} = no
             item.cod-item-refugo:hidden in frame {&frame-name} = no
             c-desc-item:hidden in frame {&frame-name} = no
             item.val-relac-refugo-item:hidden in frame {&frame-name} = no.
  &else

      assign c-Text-Refugo:hidden in frame {&frame-name} = yes
             rect-refugo:hidden in frame {&frame-name} = yes
             item.log-control-estoq-refugo:hidden in frame {&frame-name} = yes
             item.log-refugo-preco-fisc:hidden in frame {&frame-name} = yes
             item.cod-item-refugo:hidden in frame {&frame-name} = yes
             c-desc-item:hidden in frame {&frame-name} = yes
             item.val-relac-refugo-item:hidden in frame {&frame-name} = yes.
  &endif         


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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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


  if cb-tipo-contr:lookup(cb-tipo-contr:screen-value) <> 1 and 
     cb-tipo-contr:lookup(cb-tipo-contr:screen-value) <> 2 and
     cb-report-prod:lookup(cb-report-prod:screen-value  ) =  4 then do :
     /* Tipo de controle do item deve ser Fisico ou Total */
     run utp/ut-msgs.p (input "show",
                        input 1941  ,
                        input ""    ).
     apply "entry" to cb-tipo-contr in frame {&frame-name}.
     return "adm-error".
  end.                          

  if item.politica       <> 1 and 
     item.politica       <> 2 and
     cb-report-prod:lookup(cb-report-prod:screen-value) =  4 then do:
     /* Politica do Item deve ser Periodo Fixo ou Lote Economico */
     run utp/ut-msgs.p (input "show",
                        input 1942  ,
                        input ""    ).
     apply "entry" to cb-report-prod in frame {&frame-name}.
     return "adm-error".                                                     
  end.     

    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
      IF  item.log-control-estoq-refugo:CHECKED THEN DO:
          IF  item.cod-item-refugo:SCREEN-VALUE = " " THEN DO:
              {utp/ut-liter.i Item_refugo_n∆o_pode_ser_o_item_branco *}
              run utp/ut-msgs.p (input "show",
                                 input 29469 ,
                                 input  Return-value ).
              apply "entry" to item.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  item.cod-item-refugo:SCREEN-VALUE = ITEM.it-codigo THEN DO:
              {utp/ut-liter.i Item_refugo_n∆o_pode_ser_o_pr¢prio_item *}
              run utp/ut-msgs.p (input "show",
                                 input 29464 ,
                                 input  Return-value ).
              apply "entry" to item.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          FOR FIRST b-ITEM FIELDS(it-codigo tipo-contr tipo-con-est)
              WHERE b-ITEM.it-codigo = item.cod-item-refugo:SCREEN-VALUE NO-LOCK: END.
          IF  NOT AVAIL b-ITEM THEN DO:
              {utp/ut-liter.i Item_n∆o_cadastrado *}
              run utp/ut-msgs.p (input "show",
                                 input 17006 ,
                                 input  Return-value ).
              apply "entry" to item.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  b-ITEM.tipo-contr <> 2 THEN DO:
              {utp/ut-liter.i Item_deve_ser_de_controle_total *}
              run utp/ut-msgs.p (input "show",
                                 input 29462 ,
                                 input  Return-value ).
              apply "entry" to item.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  b-ITEM.tipo-con-est <> 1 THEN DO:
              {utp/ut-liter.i Item_deve_ter_tipo_de_controle_de_estoque_Serial *}
              run utp/ut-msgs.p (input "show",
                                 input 29463 ,
                                 input  Return-value ).
              apply "entry" to item.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  DEC(item.val-relac-refugo-item:SCREEN-VALUE) <= 0
          OR  DEC(item.val-relac-refugo-item:SCREEN-VALUE)  = ? THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 28174 ,
                                 input "").
              apply "entry" to item.val-relac-refugo-item in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "item"}

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

