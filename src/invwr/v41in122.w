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
{include/i-prgvrs.i V41IN122 2.00.01.004}  /*** 010104 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v41in122 MUT}
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

DEF NEW GLOBAL SHARED VAR gr-familia  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-planejad AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod AS rowid NO-UNDO.

DEF VAR i-reporte-ggf as integer no-undo.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
{method/dbotterr.i}
&ENDIF


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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.log-control-estoq-refugo ~
familia.log-refugo-preco-fisc familia.cod-item-refugo ~
familia.val-relac-refugo-item 
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS RECT-refugo 
&Scoped-Define DISPLAYED-FIELDS familia.log-control-estoq-refugo ~
familia.log-refugo-preco-fisc familia.cod-item-refugo ~
familia.val-relac-refugo-item 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS c-text-refugo c-desc-item cb-tipo-requis ~
cb-reporte-mob cb-reporte-ggf cb-tipo-aloc-fam cb-ind-refugo ~
cb-classe-repro cb-tipo-con-est cb-tipo-contr cb-rep-prod cb-demanda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-tipo-requis cb-reporte-mob ~
cb-reporte-ggf cb-tipo-aloc-fam cb-ind-refugo cb-classe-repro ~
cb-tipo-con-est cb-tipo-contr cb-rep-prod cb-demanda 
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-requis cb-reporte-mob ~
cb-reporte-ggf cb-tipo-aloc-fam cb-ind-refugo cb-classe-repro ~
cb-tipo-con-est cb-tipo-contr cb-rep-prod cb-demanda ~
familia.log-control-estoq-refugo familia.log-refugo-preco-fisc ~
familia.cod-item-refugo familia.val-relac-refugo-item 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-requis cb-reporte-mob ~
cb-reporte-ggf cb-tipo-aloc-fam cb-ind-refugo cb-classe-repro ~
cb-tipo-con-est cb-tipo-contr cb-rep-prod cb-demanda 

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
DEFINE VARIABLE cb-classe-repro AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-refugo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-rep-prod AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "":R16 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reporte-ggf AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reporte-mob AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-aloc-fam AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-contr AS CHARACTER FORMAT "X(256)" INITIAL "2" 
     LABEL "":R16 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-refugo AS CHARACTER FORMAT "X(256)":U INITIAL "Refugo" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 TOOLTIP "Refugo" NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 9.58.

DEFINE RECTANGLE RECT-refugo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.43 BY 3.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-text-refugo AT ROW 6.75 COL 2 NO-LABEL
     c-desc-item AT ROW 8.29 COL 37.57 COLON-ALIGNED NO-LABEL
     cb-tipo-requis AT ROW 1.25 COL 20 COLON-ALIGNED
     cb-reporte-mob AT ROW 2.38 COL 20 COLON-ALIGNED
     cb-reporte-ggf AT ROW 3.5 COL 20 COLON-ALIGNED
     cb-tipo-aloc-fam AT ROW 4.67 COL 20 COLON-ALIGNED
     cb-ind-refugo AT ROW 5.79 COL 20 COLON-ALIGNED
     cb-classe-repro AT ROW 1.25 COL 57 COLON-ALIGNED
     cb-tipo-con-est AT ROW 2.38 COL 57 COLON-ALIGNED
     cb-tipo-contr AT ROW 3.5 COL 57 COLON-ALIGNED
     cb-rep-prod AT ROW 4.67 COL 57 COLON-ALIGNED HELP
          "Informar como as ordens de produá∆o ser∆o reportadas"
     cb-demanda AT ROW 5.79 COL 57 COLON-ALIGNED
     familia.log-control-estoq-refugo AT ROW 7.29 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .83
     familia.log-refugo-preco-fisc AT ROW 7.29 COL 59
          VIEW-AS TOGGLE-BOX
          SIZE 19.43 BY .83
     familia.cod-item-refugo AT ROW 8.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
          FONT 2
     familia.val-relac-refugo-item AT ROW 9.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     RECT-8 AT ROW 1 COL 1
     RECT-refugo AT ROW 7 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 9.63
         WIDTH              = 87.
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
/* SETTINGS FOR FILL-IN c-text-refugo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       c-text-refugo:PRIVATE-DATA IN FRAME f-main     = 
                "Refugo".

/* SETTINGS FOR COMBO-BOX cb-classe-repro IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-demanda IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-ind-refugo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-rep-prod IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-reporte-ggf IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-reporte-mob IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-aloc-fam IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-contr IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN familia.cod-item-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX familia.log-control-estoq-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX familia.log-refugo-preco-fisc IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR RECTANGLE RECT-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.val-relac-refugo-item IN FRAME f-main
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


&Scoped-define SELF-NAME familia.cod-item-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-item-refugo V-table-Win
ON F5 OF familia.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                                   &campo=familia.cod-item-refugo
                                   &campozoom=it-codigo
                                   &campo2=c-desc-item
                                   &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-item-refugo V-table-Win
ON LEAVE OF familia.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    {include/leave.i &tabela=ITEM
                             &atributo-ref=desc-item
                             &variavel-ref=c-desc-item
                             &where="item.it-codigo = input frame {&frame-name} familia.cod-item-refugo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-item-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.log-control-estoq-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.log-control-estoq-refugo V-table-Win
ON VALUE-CHANGED OF familia.log-control-estoq-refugo IN FRAME f-main /* Contr Est Refugo */
DO:
    IF  familia.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN familia.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               familia.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
               familia.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN familia.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               familia.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               familia.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

{utp/ut-field.i mgind familia tipo-requis    1} assign cb-tipo-requis:label   = return-value.
{utp/ut-field.i mgind familia classe-repro   1} assign cb-classe-repro:label  = return-value.
{utp/ut-field.i mgind familia tipo-con-est   1} assign cb-tipo-con-est:LABEL  = return-value.
{utp/ut-field.i mgind familia reporte-mob    1} assign cb-reporte-mob:label   = return-value.
{utp/ut-field.i mgind item reporte-ggf       1} assign cb-reporte-ggf:label   = return-value.
{utp/ut-field.i mgind familia sit-aloc       1} assign cb-tipo-aloc-fam:label = return-value.
{utp/ut-field.i mgind familia demanda        1} assign cb-demanda:label       = return-value.
{utp/ut-field.i mgind familia tipo-contr     1} assign cb-tipo-contr:label    = return-value.
{utp/ut-field.i mgind familia rep-prod       1} assign cb-rep-prod:LABEL      = return-value.
{utp/ut-field.i mgind familia-man ind-refugo 1} ASSIGN cb-ind-refugo:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

familia.cod-item-refugo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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
  if  avail familia then do transaction:
      find current familia exclusive-lock.
      assign input frame {&frame-name} cb-tipo-requis
             input frame {&frame-name} cb-classe-repro
             input frame {&frame-name} cb-tipo-con-est
             input frame {&frame-name} cb-tipo-aloc-fam
             input frame {&frame-name} cb-demanda
             input frame {&frame-name} cb-reporte-mob
             input frame {&frame-name} cb-reporte-ggf
             input frame {&frame-name} cb-tipo-contr
             input frame {&frame-name} cb-rep-prod
             input frame {&frame-name} cb-ind-refugo
             familia.tipo-requis  = {ininc/i08in122.i 06 cb-tipo-requis}
             familia.classe-repro = {ininc/i06in122.i 06 cb-classe-repro}
             familia.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-con-est}
             familia.sit-aloc     = {ininc/i18in172.i 06 cb-tipo-aloc-fam}
             familia.demanda      = {ininc/i02in122.i 06 cb-demanda}
             familia.reporte-mob  = {ininc/i06in172.i 06 cb-reporte-mob}
             familia.log-1        = ({ininc/i06in172.i 06 cb-reporte-ggf} = 1)
             familia.tipo-contr   = {ininc/i09in122.i 06 cb-tipo-contr}
             familia.rep-prod     = {ininc/i12in172.i 06 cb-rep-prod}
             familia.ind-refugo   = {ininc/i01in180.i 06 cb-ind-refugo}
             familia.reporte-ggf  = {ininc/i06in172.i 06 cb-reporte-ggf}.

    IF familia.log-control-estoq-refugo:CHECKED = no then 
       assign familia.cod-item-refugo = ""
              familia.val-relac-refugo-item = 0 
              familia.log-refugo-preco-fisc  = no. 
    end.

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
            RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                            INPUT familia.fm-codigo, 
                                            INPUT familia.descricao,
                                            INPUT familia.un,
                                            INPUT familia.tipo-con-est,
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
    &ENDIF


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


  if  avail familia then do with frame {&frame-name}:

      assign i-reporte-ggf                 = (2 - int (familia.log-1))
             cb-tipo-requis:screen-value   = {ininc/i08in122.i 04 familia.tipo-requis}
             cb-classe-repro:screen-value  = {ininc/i06in122.i 04 familia.classe-repro}
             cb-tipo-con-est:screen-value  = {ininc/i01in122.i 04 familia.tipo-con-est}
             cb-tipo-aloc-fam:screen-value = {ininc/i18in172.i 04 familia.sit-aloc}
             cb-demanda:screen-value       = {ininc/i02in122.i 04 familia.demanda}
             cb-reporte-mob:screen-value   = {ininc/i06in172.i 04 familia.reporte-mob}
             cb-reporte-ggf:screen-value   = {ininc/i06in172.i 04 i-reporte-ggf}
             cb-tipo-contr:screen-value    = {ininc/i09in122.i 04 familia.tipo-contr}
             cb-rep-prod:screen-value      = {ininc/i12in172.i 04 familia.rep-prod}
             c-desc-item                   = " ".

      find first familia-man
           where familia-man.fm-codigo = familia-man.fm-codigo no-lock no-error.
      IF  avail familia-man then  
          assign cb-ind-refugo:screen-value = {ininc/i01in180.i 04 familia.ind-refugo}.
      else 
          assign cb-ind-refugo:screen-value = {ininc/i01in180.i 04 01}.

      IF  familia.cod-item-refugo <> " " THEN
          FOR FIRST ITEM FIELDS(it-codigo desc-item) WHERE item.it-codigo = familia.cod-item-refugo NO-LOCK:
              ASSIGN c-desc-item = ITEM.desc-item.
          END.

     &IF DEFINED (bf_man_sfc_ref_oper) &THEN    
      {utp/ut-liter.i Refugo *} 
      ASSIGN familia.log-control-estoq-refugo:CHECKED   = familia.log-control-estoq-refugo
             familia.log-refugo-preco-fisc:CHECKED      = familia.log-refugo-preco-fisc
             familia.cod-item-refugo:SCREEN-VALUE       = familia.cod-item-refugo
             c-desc-item:SCREEN-VALUE                   = c-desc-item
             c-text-refugo:SCREEN-VALUE                 = RETURN-VALUE
             familia.val-relac-refugo-item:SCREEN-VALUE = string(familia.val-relac-refugo-item).    
      &endif       

  end.
  else DO with frame {&frame-name}:
      assign cb-tipo-requis:screen-value   = {ininc/i08in122.i 04 1}
             cb-classe-repro:screen-value  = {ininc/i06in122.i 04 1}
             cb-tipo-con-est:screen-value  = {ininc/i01in122.i 04 1}
             cb-tipo-aloc-fam:screen-value = {ininc/i18in172.i 04 1}
             cb-demanda:screen-value       = {ininc/i02in122.i 04 1}
             cb-reporte-mob:screen-value   = {ininc/i06in172.i 04 1}
             cb-reporte-ggf:screen-value   = {ininc/i06in172.i 04 1}
             cb-tipo-contr:screen-value    = {ininc/i09in122.i 04 1}
             cb-rep-prod:screen-value      = {ininc/i12in172.i 04 1}
             cb-ind-refugo:SCREEN-VALUE    = {ininc/i01in180.i 04 01}.

      &IF DEFINED (bf_man_sfc_ref_oper) &THEN
      {utp/ut-liter.i Refugo *} 
      ASSIGN familia.log-control-estoq-refugo:CHECKED   = NO
             familia.log-refugo-preco-fisc:CHECKED      = NO
             familia.cod-item-refugo:SCREEN-VALUE       = " "
             c-desc-item:SCREEN-VALUE                   = " "
             c-text-refugo:SCREEN-VALUE                 = RETURN-VALUE
             familia.val-relac-refugo-item:SCREEN-VALUE = "0".
      &endif       
    end.
end.

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

  assign cb-tipo-contr:sensitive  = not param-global.modulo-ce.

    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    IF  param-global.modulo-ch THEN do:
        ASSIGN familia.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        IF  familia.log-control-estoq-refugo:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN familia.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   familia.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                   familia.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN familia.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   familia.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                   familia.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    end.
    ELSE
        ASSIGN familia.log-control-estoq-refugo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               familia.log-refugo-preco-fisc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               familia.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
               familia.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

  find first param-global no-lock no-error.

  do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
         
         assign c-lista = {ininc/i08in122.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-requis:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i06in122.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-classe-repro:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i01in122.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-con-est:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i18in172.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-aloc-fam:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i02in122.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-demanda:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i06in172.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-reporte-mob:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i06in172.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-reporte-ggf:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i09in122.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-contr:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i12in172.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-rep-prod:LIST-ITEM-PAIRS   = c-lista.

         assign c-lista = {ininc/i01in180.i 03}.
             run utp/ut-lstit.p (input-output c-lista).
         assign cb-ind-refugo:LIST-ITEM-PAIRS   = c-lista.
  
     &else
         assign cb-tipo-requis:list-items   = {ininc/i08in122.i 03}
                cb-classe-repro:list-items  = {ininc/i06in122.i 03}
                cb-tipo-con-est:list-items  = {ininc/i01in122.i 03}
                cb-tipo-aloc-fam:list-items = {ininc/i18in172.i 03}
                cb-demanda:list-items       = {ininc/i02in122.i 03}
                cb-reporte-mob:list-items   = {ininc/i06in172.i 03}
                cb-reporte-ggf:list-items   = {ininc/i06in172.i 03}
                cb-tipo-contr:list-items    = {ininc/i09in122.i 03}
                cb-rep-prod:list-items      = {ininc/i12in172.i 03}
                cb-ind-refugo:LIST-ITEMS    = {ininc/i01in180.i 03}.    
     &endif

  end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    &IF defined(bf_man_sfc_ref_oper) &THEN
      assign c-Text-Refugo:hidden in frame {&frame-name} = no
             rect-refugo:hidden in frame {&frame-name} = no
             familia.log-control-estoq-refugo:hidden in frame {&frame-name} = no
             familia.log-refugo-preco-fisc:hidden in frame {&frame-name} = no
             familia.cod-item-refugo:hidden in frame {&frame-name} = no
             c-desc-item:hidden in frame {&frame-name} = no
             familia.val-relac-refugo-item:hidden in frame {&frame-name} = no.
  &else
      assign c-Text-Refugo:hidden in frame {&frame-name} = yes
             rect-refugo:hidden in frame {&frame-name} = yes
             familia.log-control-estoq-refugo:hidden in frame {&frame-name} = yes
             familia.log-refugo-preco-fisc:hidden in frame {&frame-name} = yes
             familia.cod-item-refugo:hidden in frame {&frame-name} = yes
             c-desc-item:hidden in frame {&frame-name} = yes
             familia.val-relac-refugo-item:hidden in frame {&frame-name} = yes.
  &endif    

  /* Code placed here will execute AFTER standard behavior.    */

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
  IF  AVAIL familia THEN
      ASSIGN gr-familia = ROWID(familia).

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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

  Do with frame {&frame-name}:

      if cb-tipo-contr:lookup(cb-tipo-contr:screen-value ) <> 1 and 
         cb-tipo-contr:lookup(cb-tipo-contr:screen-value) <> 2 and
         cb-rep-prod:lookup(cb-rep-prod:screen-value ) =  4 then do :   
         run utp/ut-msgs.p (input "show",
                            input 8534 ,
                            input ""    ).
         apply "entry" to cb-tipo-contr in frame {&frame-name}.
         return "adm-error".
      end.                          

      if familia.politica       <> 1 and 
         familia.politica       <> 2 and
         cb-rep-prod:lookup(cb-rep-prod:screen-value ) =  4 then do:
         run utp/ut-msgs.p (input "show",
                            input 8533  ,
                            input ""    ).
         apply "entry" to cb-rep-prod in frame {&frame-name}.
         return "adm-error".                                                     
      end.

      &IF DEFINED (bf_man_sfc_ref_oper) &THEN
      IF  familia.log-control-estoq-refugo:CHECKED THEN DO:
          IF  familia.cod-item-refugo:SCREEN-VALUE = " " THEN DO:
              {utp/ut-liter.i Item_refugo_n∆o_pode_ser_o_item_branco *}
              run utp/ut-msgs.p (input "show",
                                 input 29469 ,
                                 input  Return-value ).
              apply "entry" to familia.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          FOR FIRST ITEM FIELDS(it-codigo tipo-contr tipo-con-est)
              WHERE ITEM.it-codigo = familia.cod-item-refugo:SCREEN-VALUE NO-LOCK: END.
          IF  NOT AVAIL ITEM THEN DO:
              {utp/ut-liter.i Item_n∆o_cadastrado *}
              run utp/ut-msgs.p (input "show",
                                 input 17006 ,
                                 input  Return-value ).
              apply "entry" to familia.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  ITEM.tipo-contr <> 2 THEN DO:
              {utp/ut-liter.i Item_deve_ser_de_controle_total *}
              run utp/ut-msgs.p (input "show",
                                 input 29462 ,
                                 input  Return-value ).
              apply "entry" to familia.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  ITEM.tipo-con-est <> 1 THEN DO:
              {utp/ut-liter.i Item_deve_ter_tipo_de_controle_de_estoque_Serial *}
              run utp/ut-msgs.p (input "show",
                                 input 29463 ,
                                 input  Return-value ).
              apply "entry" to familia.cod-item-refugo in frame {&frame-name}.
              return "adm-error".
          END.

          IF  DEC(familia.val-relac-refugo-item:SCREEN-VALUE) <= 0
          OR  DEC(familia.val-relac-refugo-item:SCREEN-VALUE)  = ? THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input 28174 ,
                                 input "").
              apply "entry" to familia.val-relac-refugo-item in frame {&frame-name}.
              return "adm-error".
          END.

      END.
      &ENDIF
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
  {src/adm/template/snd-list.i "familia"}

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

