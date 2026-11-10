&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V29IN176 2.00.00.036 } /*** "010036" 19/12/2025 17:13:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v29in176 MUT}
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

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cdcfgmat.i}

    def var v-row-parent         as rowid   no-undo.
    def var c-it-codigo          as char    no-undo.
    def var l-frete              as logical no-undo.
    DEF VAR c-nat-oper           AS CHAR    NO-UNDO.
    DEFINE VARIABLE h-cdapi995   AS HANDLE NO-UNDO.
    DEF VAR h-boin01091          AS HANDLE NO-UNDO. 
    DEF VAR h-re1001b2a          AS HANDLE NO-UNDO.
    DEF VAR de-pc-pis            AS DEC FORMAT ">9.9999":U      NO-UNDO.
    DEF VAR de-pc-cofins         AS DEC FORMAT ">9.9999":U      NO-UNDO.

    def new global shared var gr-documento  as rowid no-undo.
    def new global shared var i-programa-re as integer no-undo.
    /**
    ***  Recebimento     1 - Normal
    ***                  2 - F°sico
    ***                  3 - Internacional
    **/

    def buffer b-unid-estabel for unid-feder.
    def buffer b-unid-emit    for unid-feder.
    def buffer b-emit-estab   for emitente.

    {rep/re9800.i}
    {cdp/cd4305.i1}
    {rep/re1907.i02}
    {rep/re1907.i03}

    def buffer b-tt-docto    for tt-docto.
    def buffer b-tt-it-docto for tt-it-docto.

    def var h-boin176 as handle no-undo.

    DEFINE TEMP-TABLE tt-item-doc-est-icms NO-UNDO LIKE item-doc-est
           FIELD r-Rowid AS ROWID.
    DEFINE TEMP-TABLE tt-ext-item-doc-est-sn NO-UNDO LIKE ext-item-doc-est
           FIELD r-Rowid AS ROWID.
    DEFINE TEMP-TABLE tt-ext-item-doc-est-fcp NO-UNDO LIKE ext-item-doc-est
           FIELD r-Rowid AS ROWID.
    DEFINE TEMP-TABLE tt-ext-item-doc-est-sta NO-UNDO LIKE ext-item-doc-est
           FIELD r-Rowid AS ROWID.
    DEFINE TEMP-TABLE tt-item-doc-est-tribut NO-UNDO LIKE item-doc-est-tribut
       FIELD r-Rowid AS ROWID.

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
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.class-fiscal ~
item-doc-est.aliquota-icm item-doc-est.aliquota-ipi item-doc-est.log-2 ~
item-doc-est.ipi-ntrib[1] item-doc-est.ipi-outras[1] ~
item-doc-est.base-ipi[1] item-doc-est.valor-ipi[1] item-doc-est.base-pis ~
item-doc-est.val-base-calc-cofins item-doc-est.aliquota-iss ~
item-doc-est.valor-pis item-doc-est.val-cofins 
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-mold-6 rt-key-4 rt-key rt-key-2 rt-key-3 ~
de-base-st-antec de-vl-st-antec btTributos 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.class-fiscal ~
item-doc-est.aliquota-icm item-doc-est.aliquota-ipi item-doc-est.log-2 ~
item-doc-est.ipi-ntrib[1] item-doc-est.ipi-outras[1] ~
item-doc-est.base-ipi[1] item-doc-est.valor-ipi[1] item-doc-est.base-pis ~
item-doc-est.val-base-calc-cofins item-doc-est.aliquota-iss ~
item-doc-est.valor-pis item-doc-est.val-cofins 
&Scoped-define DISPLAYED-TABLES item-doc-est
&Scoped-define FIRST-DISPLAYED-TABLE item-doc-est
&Scoped-Define DISPLAYED-OBJECTS c-desc-class-fiscal cd-trib-icm ~
cd-trib-ipi c-sit-trib-icms c-sit-trib-ipi perc-red-icm perc-red-ipi ~
de-base-st-antec de-vl-st-antec cd-trib-pis cd-trib-cofins d-aliq-pis ~
c-sit-trib-pis d-aliq-cofins c-sit-trib-cofins cd-trib-iss 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cd-trib-icm cd-trib-ipi cd-trib-pis ~
cd-trib-cofins cd-trib-iss 

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
DEFINE BUTTON btTributos
     LABEL "&Tributos" 
     SIZE 10 BY 1.

DEFINE VARIABLE cd-trib-cofins AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o ICMS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o IPI" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-iss AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o ISS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-class-fiscal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.
     
DEFINE VARIABLE c-cod-nbs  AS CHARACTER FORMAT "x(20)":U LABEL "NBS"
     VIEW-AS FILL-IN SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nbs AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN SIZE 53 BY .88 NO-UNDO.     

DEFINE VARIABLE c-sit-trib-cofins AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-sit-trib-icms AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST ICMS" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-sit-trib-ipi AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST IPI" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-sit-trib-pis AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE d-aliq-cofins AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE d-aliq-pis AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliquota" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE de-base-st-antec AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Base ST Antec" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-st-antec AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor ST Antec" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE perc-red-icm AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "Perc Red ICMS":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE perc-red-ipi AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "Perc Red IPI":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 5.75.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 3.25.

DEFINE RECTANGLE rt-key-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 5.5.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 8.

DEFINE RECTANGLE rt-mold-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.class-fiscal AT ROW 1.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-class-fiscal AT ROW 1.33 COL 31 COLON-ALIGNED NO-LABEL     
     c-cod-nbs AT ROW 2.33 COL 18 COLON-ALIGNED WIDGET-ID 100
     c-desc-nbs AT ROW 2.33 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     cd-trib-icm AT ROW 4.05 COL 59 COLON-ALIGNED
     cd-trib-ipi AT ROW 4.30 COL 18.43 COLON-ALIGNED     
     item-doc-est.aliquota-icm AT ROW 5.30 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-sit-trib-icms AT ROW 5.30 COL 78.14 COLON-ALIGNED     
     item-doc-est.aliquota-ipi AT ROW 5.43 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-sit-trib-ipi AT ROW 5.43 COL 34.57 COLON-ALIGNED WIDGET-ID 30     
     perc-red-icm AT ROW 6.30 COL 59 COLON-ALIGNED
     perc-red-ipi AT ROW 6.43 COL 18.43 COLON-ALIGNED     
     item-doc-est.log-2 AT ROW 6.43 COL 74
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .88     
     de-base-st-antec AT ROW 7.30 COL 59 COLON-ALIGNED
     item-doc-est.ipi-ntrib[1] AT ROW 7.43 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88     
     de-vl-st-antec AT ROW 8.30 COL 59 COLON-ALIGNED
     btTributos AT ROW 8.30 COL 76.57 HELP "Detalhes Tributos"     
     item-doc-est.ipi-outras[1] AT ROW 8.43 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88     
     item-doc-est.base-ipi[1] AT ROW 9.43 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88          
     item-doc-est.valor-ipi[1] AT ROW 10.43 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88     
     cd-trib-pis AT ROW 10.59 COL 52 COLON-ALIGNED WIDGET-ID 22
     cd-trib-cofins AT ROW 10.59 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 24     
     d-aliq-pis AT ROW 11.72 COL 52 COLON-ALIGNED WIDGET-ID 10
     c-sit-trib-pis AT ROW 11.72 COL 63 COLON-ALIGNED WIDGET-ID 32
     d-aliq-cofins AT ROW 11.72 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-sit-trib-cofins AT ROW 11.72 COL 78.86 COLON-ALIGNED WIDGET-ID 34        
     cd-trib-iss AT ROW 12.05 COL 18 COLON-ALIGNED                              
     item-doc-est.base-pis AT ROW 12.72 COL 52 COLON-ALIGNED WIDGET-ID 6
          LABEL "Base Calc"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     item-doc-est.val-base-calc-cofins AT ROW 12.72 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 15 BY .88          
     item-doc-est.aliquota-iss AT ROW 13.22 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88           
     item-doc-est.valor-pis AT ROW 13.72 COL 52.14 COLON-ALIGNED WIDGET-ID 8
          LABEL "Valor"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     item-doc-est.val-cofins AT ROW 13.72 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 15 BY .88          
     "PIS" VIEW-AS TEXT
          SIZE 8 BY .88 AT ROW 9.72 COL 54 WIDGET-ID 26
     "COFINS" VIEW-AS TEXT
          SIZE 8 BY .88 AT ROW 9.72 COL 70 WIDGET-ID 28
     rt-mold-6 AT ROW 1 COL 1     
     rt-key-4 AT ROW 3.8 COL 1
     rt-key AT ROW 3.8 COL 43     
     rt-key-2 AT ROW 11.8 COL 1
     rt-key-3 AT ROW 9.55 COL 43 WIDGET-ID 2     
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-doc-est
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 16.00
         WIDTH              = 86.29.
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

/* SETTINGS FOR FILL-IN item-doc-est.base-pis IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN c-desc-class-fiscal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sit-trib-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sit-trib-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sit-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sit-trib-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cd-trib-cofins IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-icm IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-ipi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-iss IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-pis IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN d-aliq-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-aliq-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN perc-red-icm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN perc-red-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.val-base-calc-cofins IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.val-cofins IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.valor-pis IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME item-doc-est.aliquota-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-icm V-table-Win
ON LEAVE OF item-doc-est.aliquota-icm IN FRAME f-main /* Aliquota ICMS */
DO:
  
    assign tt-it-imposto.aliquota-icm = input frame {&frame-name} item-doc-est.aliquota-icm.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.aliquota-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-ipi V-table-Win
ON ENTRY OF item-doc-est.aliquota-ipi IN FRAME f-main /* Aliquota IPI */
DO:
    assign item-doc-est.aliquota-ipi:modified in frame {&FRAME-NAME} = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-ipi V-table-Win
ON LEAVE OF item-doc-est.aliquota-ipi IN FRAME f-main /* Aliquota IPI */
DO:

    assign tt-it-imposto.aliquota-ipi = input frame {&frame-name} item-doc-est.aliquota-ipi.
    assign tt-it-imposto.perc-red-ipi = natur-oper.perc-red-ipi.  
    if item-doc-est.aliquota-ipi:modified in frame {&FRAME-NAME} then      
        run pi-calc-ipi (input ?,
                         input ?,
                         input ?,
                         input ?).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.aliquota-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-iss V-table-Win
ON LEAVE OF item-doc-est.aliquota-iss IN FRAME f-main /* Aliquota ISS */
DO:
    assign tt-it-imposto.aliquota-iss = input frame {&frame-name} item-doc-est.aliquota-iss.
    run pi-calcula-iss.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTributos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTributos V-table-Win
ON CHOOSE OF btTributos IN FRAME f-main /* ICMS */
DO:
    IF AVAIL item-doc-est THEN DO:
        {&window-name}:sensitive = no.

        CREATE tt-item-doc-est-icms.
        BUFFER-COPY item-doc-est TO tt-item-doc-est-icms NO-ERROR. 
        
        IF NOT VALID-HANDLE(h-re1001b2a) THEN
            RUN rep/re1001b2a.w PERSISTENT SET h-re1001b2a (INPUT "RE0701b":U,
                                                            INPUT TABLE tt-item-doc-est-icms,
                                                            INPUT h-boin176,
                                                            INPUT INPUT FRAME {&frame-name} d-aliq-pis,
                                                            INPUT INPUT FRAME {&frame-name} d-aliq-cofins,
                                                            OUTPUT TABLE tt-item-doc-est-icms,
                                                            INPUT-OUTPUT TABLE tt-ext-item-doc-est-sn,
                                                            INPUT-OUTPUT TABLE tt-ext-item-doc-est-fcp,
                                                            INPUT-OUTPUT TABLE tt-ext-item-doc-est-sta).

        IF VALID-HANDLE(h-re1001b2a) THEN
            RUN initializeInterface IN h-re1001b2a.

        /** Aguardar o fechamento do programa **/
        WAIT-FOR "CLOSE":U of h-re1001b2a.        

        SESSION:IMMEDIATE-DISPLAY = TRUE.
        {&window-name}:sensitive  = YES.

        IF  VALID-HANDLE(h-re1001b2a) THEN DO:
            DELETE PROCEDURE h-re1001b2a.            
            ASSIGN h-re1001b2a = ?.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-cofins V-table-Win
ON ENTRY OF cd-trib-cofins IN FRAME f-main
DO:
    assign cd-trib-cofins:modified in frame {&FRAME-NAME} = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-cofins V-table-Win
ON VALUE-CHANGED OF cd-trib-cofins IN FRAME f-main
DO:
  ASSIGN cd-trib-cofins:SCREEN-VALUE = {ininc/i10in172.i 04 item-doc-est.idi-tributac-cofins}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-icm V-table-Win
ON VALUE-CHANGED OF cd-trib-icm IN FRAME f-main /* Tributaá∆o ICMS */
DO:
  
    assign input frame {&frame-name} cd-trib-icm.
    assign tt-it-imposto.cd-trib-icm = {ininc/i07in122.i 06 cd-trib-icm}.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-ipi V-table-Win
ON ENTRY OF cd-trib-ipi IN FRAME f-main /* Tributaá∆o IPI */
DO:
    assign cd-trib-ipi:modified in frame {&FRAME-NAME} = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-ipi V-table-Win
ON LEAVE OF cd-trib-ipi IN FRAME f-main /* Tributaá∆o IPI */
DO:
  
    assign input frame {&frame-name} cd-trib-ipi.
    assign tt-it-imposto.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}.
    if cd-trib-ipi:modified in frame {&FRAME-NAME} then
        run pi-calc-ipi (input ?,
                         input ?,
                         input ?,
                         input ?).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-iss V-table-Win
ON VALUE-CHANGED OF cd-trib-iss IN FRAME f-main /* Tributaá∆o ISS */
DO:
  
    assign input frame {&frame-name} cd-trib-iss.
    assign tt-it-imposto.cd-trib-iss = {ininc/i11in172.i 06 cd-trib-iss}.
    run pi-calcula-iss.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-pis V-table-Win
ON ENTRY OF cd-trib-pis IN FRAME f-main /* Tributaá∆o */
DO:
    assign cd-trib-pis:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-pis V-table-Win
ON VALUE-CHANGED OF cd-trib-pis IN FRAME f-main /* Tributaá∆o */
DO:
  ASSIGN cd-trib-pis:screen-value    = {ininc/i10in172.i 04 item-doc-est.idi-tributac-pis}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON F5 OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                       &campo=item-doc-est.class-fiscal
                       &campozoom=class-fiscal}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON LEAVE OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  
    {include/leave.i &tabela=classif-fisc
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-class-fiscal
                     &where="classif-fisc.class-fiscal = input frame {&frame-name}
                             item-doc-est.class-fiscal"}
  
    if cd-trib-ipi:sensitive in frame {&frame-name} = no and
        item-doc-est.aliquota-ipi:sensitive in frame {&frame-name} = no then
        run pi-calc-ipi.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
          apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.log-2 V-table-Win
ON VALUE-CHANGED OF item-doc-est.log-2 IN FRAME f-main /* log-2 */
DO:
  
    assign tt-it-imposto.ind-icm-ret = input frame {&frame-name} item-doc-est.log-2.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME perc-red-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL perc-red-icm V-table-Win
ON LEAVE OF perc-red-icm IN FRAME f-main /* Perc Red ICMS */
DO:
  
    assign tt-it-imposto.perc-red-icm = input frame {&frame-name} perc-red-icm.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME perc-red-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL perc-red-ipi V-table-Win
ON LEAVE OF perc-red-ipi IN FRAME f-main /* Perc Red IPI */
DO:
  
    assign tt-it-imposto.perc-red-ipi = input frame {&frame-name} perc-red-ipi.
  
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

    do with frame {&frame-name}:
        {utp/ut-liter.i Tributaá∆o_IPI * L}
        assign cd-trib-ipi:label = return-value.
        {utp/ut-liter.i Base_IPI_Isento * L}
        assign item-doc-est.ipi-ntrib[1]:label = return-value.
        {utp/ut-liter.i Base_IPI_Outros * L}
        assign item-doc-est.ipi-outras[1]:label = return-value.    
        {utp/ut-liter.i Base_IPI_Trib. * L}
        assign item-doc-est.base-ipi[1]:label = return-value.    
        {utp/ut-liter.i Valor_IPI * L}
        assign item-doc-est.valor-ipi[1]:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ICMS * L}
        assign cd-trib-icm:label in frame {&frame-name} = return-value.    
        {utp/ut-liter.i ICMS_Retido * R}
        assign item-doc-est.log-2:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ISS * L}
        assign cd-trib-iss:label = return-value.
        {utp/ut-liter.i Perc._Reduá∆o_ICMS * L}
        assign perc-red-icm:label = return-value.
        {utp/ut-liter.i Perc._Reduá∆o_IPI * L}
        assign perc-red-ipi:label = return-value.
    end.

    if item-doc-est.class-fiscal:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .

     find param-re where
          param-re.usuario = c-seg-usuario
            no-lock no-error.        
     find first param-global
            no-lock no-error.
     find first param-compra
            no-lock no-error.        

     find docum-est where
        rowid(docum-est) = gr-documento
        no-lock no-error.
     if avail docum-est then do:
        find emitente where
            emitente.cod-emitente = docum-est.cod-emitente
            no-lock no-error.
        find natur-oper where
            natur-oper.nat-operacao = docum-est.nat-operacao
            no-lock no-error.
        find estabelec where
            estabelec.cod-estabel = docum-est.cod-estabel
            no-lock no-error.
        find b-emit-estab where
            b-emit-estab.cod-emitente = estabelec.cod-emitente 
            no-lock no-error.
        find b-unid-emit where
            b-unid-emit.pais   = emitente.pais    and 
            b-unid-emit.estado = emitente.estado
            no-lock no-error.
        find b-unid-estabel where
            b-unid-estabel.pais   = estabelec.pais  and 
            b-unid-estabel.estado = estabelec.estado
            no-lock no-error.
        run pi-seta-flags-observacao (docum-est.cod-observa, 
                                      docum-est.nat-operacao).
    end.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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
   assign input frame {&frame-name} cd-trib-ipi
           input frame {&frame-name} cd-trib-icm
           input frame {&frame-name} cd-trib-iss.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

           
    assign item-doc-est.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}
           item-doc-est.cd-trib-iss = {ininc/i11in172.i 06 cd-trib-iss}
           item-doc-est.cd-trib-icm = {ininc/i07in122.i 06 cd-trib-icm}.

    if  item-doc-est.cd-trib-ipi = 0 then 
        assign item-doc-est.cd-trib-ipi = 2.
    if  item-doc-est.cd-trib-icm = 0 then 
        assign item-doc-est.cd-trib-icm = 2.
    if  item-doc-est.cd-trib-iss = 0 then 
        assign item-doc-est.cd-trib-iss = 2.
        
    find first tt-docto no-error.
    if available tt-docto then
        delete tt-docto.        
    find first tt-it-docto no-error.
    if available tt-it-docto then        
        delete tt-it-docto.        
    
    find first tt-it-imposto no-error.
    
    if  available tt-it-imposto then do:
        assign item-doc-est.base-iss    = tt-it-imposto.vl-biss-it
               item-doc-est.iss-ntrib   = tt-it-imposto.vl-issnt-it
               item-doc-est.iss-outras  = tt-it-imposto.vl-issou-it
               item-doc-est.valor-iss   = tt-it-imposto.vl-iss-it.

        delete tt-it-imposto.
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

 
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
  
    find first tt-docto no-error.
    if available tt-docto then
        delete tt-docto.        
    find first tt-it-docto no-error.
    if available tt-it-docto then        
        delete tt-it-docto.        
    find first tt-it-imposto no-error.
    if available tt-it-imposto then        
        delete tt-it-imposto.
  
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
  def var rCurrentRow    as rowid   no-undo.
  def var iRowsReturned  as integer no-undo.
  DEF VAR c-nbs-limpo    AS CHAR    NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if available item-doc-est then do with frame {&frame-name}:

      assign cd-trib-ipi:screen-value    = {ininc/i10in172.i 04 item-doc-est.cd-trib-ipi}.
      assign cd-trib-iss:screen-value    = {ininc/i11in172.i 04 item-doc-est.cd-trib-iss}.
      assign cd-trib-icm:screen-value    = {ininc/i07in122.i 04 item-doc-est.cd-trib-icm}.
      ASSIGN cd-trib-pis:screen-value    = {ininc/i10in172.i 04 item-doc-est.idi-tributac-pis}.
      ASSIGN cd-trib-cofins:SCREEN-VALUE = {ininc/i10in172.i 04 item-doc-est.idi-tributac-cofins}.
      
      assign de-base-st-antec:screen-value = STRING(item-doc-est.base-subs[1]).
      assign de-vl-st-antec:screen-value   = STRING(item-doc-est.vl-subs[1]).
      ASSIGN de-base-st-antec:SENSITIVE    = NO.
      ASSIGN de-vl-st-antec:SENSITIVE      = NO.

      assign perc-red-ipi:screen-value = STRING(item-doc-est.val-perc-rep-ipi)
             perc-red-icm:screen-value = STRING(item-doc-est.val-perc-red-icms).

      IF NOT VALID-HANDLE (h-boin01091) THEN
          RUN inbo/boin01091.p PERSISTENT SET h-boin01091.
      
      IF VALID-HANDLE(h-boin01091) THEN DO:
          RUN setConstraintOfItemDocEst IN h-boin01091 (INPUT item-doc-est.serie-docto,     
                                                        INPUT item-doc-est.nro-docto ,      
                                                        INPUT item-doc-est.cod-emitente,    
                                                        INPUT item-doc-est.nat-operacao,    
                                                        INPUT item-doc-est.sequencia).      
          RUN openQueryStatic IN h-boin01091 (INPUT "OfItemDocEst":U).

          RUN getRowid IN h-boin01091 (OUTPUT rCurrentRow).
          RUN getBatchRecords IN  h-boin01091 (INPUT rCurrentRow,
                                               INPUT NO,
                                               INPUT 9999,
                                               OUTPUT iRowsReturned,
                                               OUTPUT TABLE tt-item-doc-est-tribut).
          FOR EACH  tt-item-doc-est-tribut
              WHERE tt-item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto
              AND   tt-item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto       
              AND   tt-item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
              AND   tt-item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao     
              AND   tt-item-doc-est-tribut.num-seq          = item-doc-est.sequencia
              AND   tt-item-doc-est-tribut.cod-campo        = 'CST':U:       
              CASE tt-item-doc-est-tribut.nom-trib:
                  WHEN "IPI" THEN
                      ASSIGN c-sit-trib-ipi:SCREEN-VALUE = tt-item-doc-est-tribut.cod-conteudo.
                  WHEN "PIS" THEN
                      ASSIGN c-sit-trib-pis:SCREEN-VALUE = tt-item-doc-est-tribut.cod-conteudo.
                  WHEN "COFINS" THEN
                      ASSIGN c-sit-trib-cofins:SCREEN-VALUE = tt-item-doc-est-tribut.cod-conteudo.
                  WHEN "ICMS" THEN
                      ASSIGN c-sit-trib-icms:SCREEN-VALUE = tt-item-doc-est-tribut.cod-conteudo.
              END CASE.
          END.
      END.

      IF VALID-HANDLE(h-boin01091) THEN DO:
          DELETE PROCEDURE h-boin01091.
          ASSIGN h-boin01091 = ?.
      END.

      ASSIGN c-nat-oper = IF NOT item-doc-est.nat-of = ""
                          AND CAN-FIND(FIRST natur-oper 
                                       WHERE natur-oper.nat-operacao = item-doc-est.nat-of) 
                          THEN item-doc-est.nat-of 
                          ELSE item-doc-est.nat-operacao.

      IF  CAN-FIND (FIRST natur-oper 
                    WHERE natur-oper.nat-operacao = c-nat-oper
                    AND   natur-oper.terceiros    = NO
                    AND   natur-oper.transf       = NO
                    AND   (   natur-oper.log-contrib-st-antec 
                           or natur-oper.log-icms-substto-antec)) THEN DO:
               
          IF  CAN-FIND (FIRST docum-est
                        WHERE docum-est.serie-docto  = item-doc-est.serie-docto
                        AND   docum-est.nro-docto    = item-doc-est.nro-docto  
                        AND   docum-est.cod-emitente = item-doc-est.cod-emitente
                        AND   docum-est.nat-operacao = item-doc-est.nat-operacao
                        AND   docum-est.cod-observa <= 3) THEN 
              ASSIGN de-base-st-antec:HIDDEN = NO 
                     de-vl-st-antec:HIDDEN   = NO 
                     de-base-st-antec:LABEL  = "Base St Antec"
                     de-vl-st-antec:LABEL    = "Valor ST Antec".
          ELSE
              ASSIGN de-base-st-antec:HIDDEN = YES
                     de-vl-st-antec:HIDDEN   = YES.
      END.
      ELSE 
          ASSIGN de-base-st-antec:HIDDEN = YES
                 de-vl-st-antec:HIDDEN   = YES.
  end.
  else do:
      assign cd-trib-ipi:screen-value    = {ininc/i10in172.i 04 01}.
      assign cd-trib-iss:screen-value    = {ininc/i11in172.i 04 01}.
      assign cd-trib-icm:screen-value    = {ininc/i07in122.i 04 01}.
      ASSIGN cd-trib-pis:screen-value    = {ininc/i10in172.i 04 01}.
      ASSIGN cd-trib-cofins:SCREEN-VALUE = {ininc/i10in172.i 04 01}.

  end.

  FOR FIRST classif-fisc FIELDS(descricao)
      WHERE classif-fisc.class-fiscal = input frame {&frame-name} item-doc-est.class-fiscal NO-LOCK: 
  END.
  if available classif-fisc then
      assign c-desc-class-fiscal:screen-value in frame {&frame-name} = classif-fisc.descricao.
  else
      assign c-desc-class-fiscal:screen-value in frame {&frame-name} = "".
      
      
  /* NBS */
  ASSIGN c-cod-nbs:SCREEN-VALUE = SUBSTRING(item-doc-est.char-2,956,20)
         c-nbs-limpo = REPLACE(c-cod-nbs:SCREEN-VALUE in frame {&frame-name},".","").

  IF  REPLACE(c-cod-nbs:SCREEN-VALUE in frame {&frame-name},".","") <> "" AND 
      LENGTH(REPLACE(c-cod-nbs:SCREEN-VALUE in frame {&frame-name},".","")) >= 9 THEN
      ASSIGN c-cod-nbs:FORMAT in frame {&frame-name} = "9.9999.99.99" NO-ERROR.
  ELSE 
      ASSIGN c-cod-nbs:FORMAT in frame {&frame-name} = "x(9)" NO-ERROR.
        
  FIND FIRST cad-nbs NO-LOCK WHERE cad-nbs.cod-nbs = c-nbs-limpo NO-ERROR.
  IF AVAIL cad-nbs THEN 
     ASSIGN c-desc-nbs:SCREEN-VALUE in frame {&frame-name} = cad-nbs.desc-nbs.
  ELSE 
     ASSIGN c-desc-nbs:SCREEN-VALUE = "".    
    
  IF NOT VALID-HANDLE (h-cdapi995)  THEN
  RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

  RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                        INPUT item-doc-est.serie-docto + "/" + 
                                              item-doc-est.nro-docto + "/" + 
                                              string(item-doc-est.cod-emitente) + "/" + 
                                              item-doc-est.nat-operacao + "/" + 
                                              string(item-doc-est.sequencia), 
                                              output de-pc-pis, 
                                              output de-pc-cofins).

  IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = item-doc-est.val-aliq-pis.
  IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-doc-est.val-aliq-cofins.

  ASSIGN d-aliq-pis:screen-value    = string(de-pc-pis,">>9.9999":U)        /* aliquota pis */
         d-aliq-cofins:screen-value = string(de-pc-cofins,">>9.9999":U).    /* aliquota cofins */
        
  IF VALID-HANDLE(h-cdapi995) THEN DO:
     DELETE PROCEDURE h-cdapi995.
         ASSIGN h-cdapi995 = ?.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  disable item-doc-est.ipi-ntrib[1] 
          item-doc-est.ipi-outras[1]
          item-doc-est.base-ipi[1] 
          item-doc-est.valor-ipi[1] with frame {&frame-name}.        

  if  l-servicos then 
      disable item-doc-est.class-fiscal
              cd-trib-ipi
              item-doc-est.aliquota-ipi 
              cd-trib-icm
              item-doc-est.aliquota-icm
              item-doc-est.log-2 with frame {&frame-name}.
  else 
      disable cd-trib-iss
              item-doc-est.aliquota-iss with frame {&frame-name}.
            

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

    do with frame {&frame-name}:
        assign cd-trib-ipi:list-items    = {ininc/i10in172.i 03}.
        assign cd-trib-icm:LIST-ITEMS    = {ininc/i07in122.i 03}.
        assign cd-trib-iss:list-items    = {ininc/i11in172.i 03}.
        ASSIGN cd-trib-cofins:list-items = {ininc/i10in172.i 03}.
        ASSIGN cd-trib-pis:list-items = {ininc/i10in172.i 03}.
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    do with frame {&frame-name}:
        {utp/ut-liter.i Tributaá∆o_IPI * L}
        assign cd-trib-ipi:label = return-value.
        {utp/ut-liter.i Base_IPI_Isento * L}
        assign item-doc-est.ipi-ntrib[1]:label = return-value.
        {utp/ut-liter.i Base_IPI_Outros * L}
        assign item-doc-est.ipi-outras[1]:label = return-value.    
        {utp/ut-liter.i Base_IPI_Trib. * L}
        assign item-doc-est.base-ipi[1]:label = return-value.    
        {utp/ut-liter.i Valor_IPI * L}
        assign item-doc-est.valor-ipi[1]:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ICMS * L}
        assign cd-trib-icm:label in frame {&frame-name} = return-value.    
        {utp/ut-liter.i ICMS_Retido * R}
        assign item-doc-est.log-2:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ISS * L}
        assign cd-trib-iss:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Perc._Reduá∆o_ICMS * L}
        assign perc-red-icm:label = return-value.
        {utp/ut-liter.i Perc._Reduá∆o_IPI * L}
        assign perc-red-ipi:label = return-value.
    end.

    ASSIGN btTributos:SENSITIVE IN FRAME {&frame-name} = yes.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-ipi V-table-Win 
PROCEDURE pi-calc-ipi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param de-vl-merc-ori as decimal no-undo.
    def input param de-desconto    as decimal no-undo.
    def input param de-despesas    as decimal no-undo.
    def input param de-frete       as decimal no-undo.

    if de-vl-merc-ori <> ? then 
        assign tt-it-docto.vl-merc-ori = de-vl-merc-ori
               tt-it-docto.vl-merc-liq = tt-it-docto.vl-merc-ori - de-desconto
               tt-it-docto.vl-seguro   = if  de-despesas >= de-frete 
                                         then de-despesas - de-frete
                                         else 0
               tt-it-docto.vl-frete    = de-frete.                
        
    if  not l-servicos then do:
        assign tt-it-imposto.perc-red-ipi = natur-oper.perc-red-ipi.
        run pi-calcula-ipi.
    end.
    
    find first tt-docto no-error.
    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.

    if  not l-servicos then do:
        if l-comercio and
            {ininc/i10in172.i 06 cd-trib-ipi} = 4 then
            assign tt-it-imposto.cd-trib-ipi = 1
                   cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 01}.        
        
        assign item-doc-est.aliquota-ipi:screen-value in frame {&frame-name} =
            string(tt-it-imposto.aliquota-ipi).
            
        assign item-doc-est.ipi-ntrib[1]:screen-value in frame {&frame-name} =
            string(tt-it-imposto.vl-ipint).
            
        assign item-doc-est.ipi-outras[1]:screen-value in frame {&frame-name} =
            string(tt-it-imposto.vl-ipiou).
            
        assign item-doc-est.base-ipi[1]:screen-value in frame {&frame-name} =
            string(tt-it-imposto.vl-bipi-it).
            
        assign item-doc-est.valor-ipi[1]:screen-value in frame {&frame-name} =
            string(tt-it-imposto.vl-ipi-it).
            
        if  param-re.ped-imp-nota then do:            
            if tt-it-imposto.vl-ipint <> 0 then
                enable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
            else
                disable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
                
            if tt-it-imposto.vl-ipiou <> 0 then
                enable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
            else
                disable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
                
            if tt-it-imposto.vl-bipi-it <> 0 then
                enable item-doc-est.base-ipi[1] with frame {&frame-name}.
            else
                disable item-doc-est.base-ipi[1] with frame {&frame-name}.
                
            if tt-it-imposto.vl-ipi-it <> 0 then
                enable item-doc-est.valor-ipi[1] with frame {&frame-name}.
            else
                disable item-doc-est.valor-ipi[1] with frame {&frame-name}.        
        end.
            
        run cdp/cd4315.p (input tt-it-docto.seq-tt-it-docto,
                          input b-unid-estabel.nr-tb-pauta,
                          input b-unid-emit.nr-tb-pauta,
                          input tt-it-docto.cod-refer,
                          input natur-oper.venda-ativo,
                          input (if available b-emit-estab then b-emit-estab.natureza else 2),
                          input table tt-docto,
                          input table tt-it-docto,
                          input-output table tt-it-imposto).        
                          
        if natur-oper.subs-trib and 
            l-frete then do:
            assign item-doc-est.log-2:checked in frame {&frame-name} = yes.
            assign tt-it-imposto.ind-icm-ret = yes.
        end.

    end.
    else do:                
        if  not adm-new-record 
        and avail item-doc-est then 
            assign tt-it-imposto.aliquota-iss = item-doc-est.aliquota-iss.
        else 
            assign tt-it-imposto.aliquota-iss = item.aliquota-iss.
            
        assign item-doc-est.aliquota-iss:screen-value in frame {&frame-name} =
                                                string(tt-it-imposto.aliquota-iss).
        run pi-calcula-iss.                                                

    end.
    find first tt-docto no-error.
    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-iss V-table-Win 
PROCEDURE pi-calcula-iss :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run cdp/cd4307.p (input tt-it-docto.seq-tt-it-docto,
                      input 1,
                      input yes,
                      input table tt-it-docto,
                      input-output table tt-it-imposto).      

    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fisico V-table-Win 
PROCEDURE pi-fisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-imposto V-table-Win 
PROCEDURE pi-gera-imposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first tt-it-imposto no-error.
    if not available tt-it-imposto then do:
        /* Criaá∆o da tt-docto, tt-it-docto e tt-it-imposto */
        {rep/re1001.i08}
    end.
    find item where
        item.it-codigo = tt-it-docto.it-codigo
        no-lock no-error.
        
    if  l-servicos then do:
        if  not adm-new-record and avail item-doc-est then 
            assign tt-it-imposto.cd-trib-iss = item-doc-est.cd-trib-iss.
        else do:
            run cdp/cd4304.p (item.cd-trib-iss,
                              natur-oper.cd-trib-iss,
                              output tt-it-imposto.cd-trib-iss).
                          
            if  tt-it-imposto.cd-trib-iss = 1 
            or  tt-it-imposto.cd-trib-iss = 4 then                  
                assign tt-it-imposto.cd-trib-iss = 3.
        end.
        
        assign tt-it-imposto.cd-trib-ipi = 2
               tt-it-imposto.cd-trib-icm = 2.
           
        assign cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 tt-it-imposto.cd-trib-ipi}.
        assign cd-trib-iss:screen-value in frame {&frame-name} = {ininc/i11in172.i 04 tt-it-imposto.cd-trib-iss}.
        assign cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 tt-it-imposto.cd-trib-icm}.
    end.
    else do:
        if  adm-new-record then do:
            assign tt-it-docto.class-fiscal = item.class-fiscal.

            find classif-fisc 
                where classif-fisc.class-fiscal = tt-it-docto.class-fiscal
                no-lock no-error.
        
            run pi-tributa-ipi (output tt-it-imposto.cd-trib-ipi,
                                output tt-it-imposto.aliquota-ipi).
            run pi-tributa-icm (input c-it-codigo,
                                output tt-it-imposto.cd-trib-icm,
                                output tt-it-imposto.aliquota-icm).
        end.
        else do:
            if  avail item-doc-est then 
                assign tt-it-imposto.cd-trib-ipi  = item-doc-est.cd-trib-ipi
                       tt-it-imposto.cd-trib-icm  = item-doc-est.cd-trib-icm
                       tt-it-imposto.aliquota-ipi = item-doc-est.aliquota-ipi
                       tt-it-imposto.aliquota-icm = item-doc-est.aliquota-icm 
                       tt-it-docto.class-fiscal   = item-doc-est.class-fiscal.

            find classif-fisc 
                where classif-fisc.class-fiscal = tt-it-docto.class-fiscal
                no-lock no-error.

        end.

        assign cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 tt-it-imposto.cd-trib-ipi}
               cd-trib-iss:screen-value in frame {&frame-name} = {ininc/i11in172.i 04 tt-it-imposto.cd-trib-iss}
               cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 tt-it-imposto.cd-trib-icm}
               item-doc-est.aliquota-ipi:screen-value in frame {&frame-name} =
                                                string(tt-it-imposto.aliquota-ipi)
               item-doc-est.aliquota-icm:screen-value in frame {&frame-name} = 
                                                string(tt-it-imposto.aliquota-icm)
               item-doc-est.class-fiscal:screen-value in frame {&frame-name} = tt-it-docto.class-fiscal
               perc-red-icm:screen-value in frame {&frame-name} = string(natur-oper.perc-red-icm)
               tt-it-imposto.perc-red-icm                       = natur-oper.perc-red-icm
               perc-red-ipi:screen-value in frame {&frame-name} = string(natur-oper.perc-red-ipi)
               tt-it-imposto.perc-red-ipi                       = natur-oper.perc-red-ipi.

        if  available classif-fisc then
            assign c-desc-class-fiscal:screen-value in frame {&frame-name} = classif-fisc.descricao.
        else
            assign c-desc-class-fiscal:screen-value in frame {&frame-name} = "".
        
    end.
    
    if  not adm-new-record 
    and avail item-doc-est then do:
        assign tt-it-docto.vl-merc-ori    = item-doc-est.preco-total[1]
               tt-it-docto.vl-merc-liq    = tt-it-docto.vl-merc-ori 
                                          - item-doc-est.desconto[1]
               tt-it-docto.vl-seguro      = item-doc-est.despesas[1]
                                          - item-doc-est.pr-total-cmi
               tt-it-docto.vl-frete       = item-doc-est.pr-total-cmi
               tt-it-imposto.aliquota-ipi = item-doc-est.aliquota-ipi
               tt-it-imposto.cd-trib-ipi  = item-doc-est.cd-trib-ipi.
               
    
        run pi-calcula-ipi.
        find first tt-it-imposto no-error.
        
        if  param-re.ped-imp-nota then do:
            if  tt-it-imposto.vl-ipint <> 0 then
                enable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
                
            if  tt-it-imposto.vl-ipiou <> 0 then
                enable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
                
            if tt-it-imposto.vl-bipi-it <> 0 then
                enable item-doc-est.base-ipi[1] with frame {&frame-name}.
                
            if tt-it-imposto.vl-ipi-it <> 0 then
                enable item-doc-est.valor-ipi[1] with frame {&frame-name}.
        end.                
    end.    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input param p-sequencia like item-doc-est.sequencia.
 def input param p-it-codigo like item.it-codigo.
 
    assign c-it-codigo = p-it-codigo.    
    find item where
        item.it-codigo = c-it-codigo
        no-lock no-error.
    find familia where
        familia.fm-codigo = item.fm-codigo
        no-lock no-error.
    find item-fornec where
        item-fornec.cod-emitente = docum-est.cod-emitente and
        item-fornec.it-codigo    = c-it-codigo
        no-lock no-error.

    assign l-frete = can-do("16,26",substring(natur-oper.nat-operacao,1,2)).

    if l-servicos then do:
        disable item-doc-est.class-fiscal
                cd-trib-ipi
                item-doc-est.aliquota-ipi  with frame {&frame-name}.
        enable cd-trib-iss
               item-doc-est.aliquota-iss with frame {&frame-name}.
        disable cd-trib-icm
                item-doc-est.aliquota-icm
                item-doc-est.log-2 with frame {&frame-name}.
    end.
    else do:
        if param-re.pd-cf-item or 
            item.tipo-contr = 4 then
            enable item-doc-est.class-fiscal with frame {&frame-name}.
        else
            disable item-doc-est.class-fiscal with frame {&frame-name}.
        if param-re.pd-cd-ipi then
            enable cd-trib-ipi with frame {&frame-name}.
        else
            disable cd-trib-ipi with frame {&frame-name}.
        if param-re.pd-aliq-ipi then
            enable item-doc-est.aliquota-ipi with frame {&frame-name}.
        else
            disable item-doc-est.aliquota-ipi with frame {&frame-name}.
        disable cd-trib-iss
                item-doc-est.aliquota-iss with frame {&frame-name}.
        if param-re.pd-cd-icm then
            enable cd-trib-icm with frame {&frame-name}.
        else
            disable cd-trib-icm with frame {&frame-name}.
        if param-re.pd-aliq-icms then    
            enable item-doc-est.aliquota-icm with frame {&frame-name}.
        else     
            disable item-doc-est.aliquota-icm with frame {&frame-name}.
        if natur-oper.subs-trib then
            enable item-doc-est.log-2 with frame {&frame-name}.
        else
            disable item-doc-est.log-2 with frame {&frame-name}.
    end.

    find first tt-it-docto no-error.
    if available tt-it-docto then 
        assign tt-it-docto.it-codigo = item.it-codigo.

    run pi-gera-imposto.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  /* A l¢gica abaixo est† fora do padr∆o, mas funciona. Se for colocada a i-vldfrm.i
   no in°cio da procedure, o programa efetua a validaá∆o do dicion†rio, mas como 
   o atributo class-fiscal pode estar desabilitado, ele n∆o mostra a mensagem e fica parado.
   Esta foi a melhor alternativa encontrada para resolver o problema. */

 def var i-seq-item     like item-doc-est.sequencia no-undo.
 def var de-val-aux     as   decimal                no-undo.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "it-codigo":U).    
 assign c-it-codigo = return-value.    

 RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure, INPUT "sequencia":U). 
 assign i-seq-item = int(return-value).

 find item 
    where item.it-codigo = c-it-codigo no-lock no-error.

 find classif-fisc where
      classif-fisc.class-fiscal = input frame {&frame-name} 
      item-doc-est.class-fiscal no-lock no-error.

 if avail classif-fisc then do:
   {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
 end.
 else 
 if  docum-est.cod-observ <> 4 
 and ( param-re.pd-cf-item or item.tipo-contr = 4 ) then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgind classif-fisc 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to item-doc-est.class-fiscal in frame {&frame-name}.
      return 'ADM-ERROR':U.
 end.

 find first tt-it-imposto no-lock no-error.
        
 if not available tt-it-imposto then
    run pi-gera-imposto (yes).

 if input frame {&frame-name} item-doc-est.ipi-ntrib[1]   <> tt-it-imposto.vl-ipint-it 
 or input frame {&frame-name} item-doc-est.ipi-outras[1] <> tt-it-imposto.vl-ipiou-it 
 or input frame {&frame-name} item-doc-est.base-ipi[1]   <> tt-it-imposto.vl-bipi-it    
 or input frame {&frame-name} item-doc-est.valor-ipi[1]  <> tt-it-imposto.vl-ipi-it then do:   
        /* mensagem: Valor de IPI nao confere com o calculado. Confirma? */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,input 15199,input " ").
        if return-value <> "yes" then do:                           
            apply 'entry' to item-doc-est.ipi-ntrib[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
        else  do:
            if  input frame {&frame-name} item-doc-est.valor-ipi[1]  <> tt-it-imposto.vl-ipi-it then do:
                assign de-val-aux = abs( input frame {&frame-name} item-doc-est.valor-ipi[1] - tt-it-imposto.vl-ipi-it ).
                run rep/re9995.p (rowid(docum-est),
                                  tt-it-imposto.vl-ipi-it,
                                  input frame {&frame-name} item-doc-est.valor-ipi[1],
                                  5507,
                                  no,
                                  i-seq-item,
                                  ( if de-val-aux > param-re.dec-1 then 1 else 2)  ). 
            end.
                                              
            if  input frame {&frame-name} item-doc-est.ipi-ntrib[1]   <> tt-it-imposto.vl-ipint-it 
            or  input frame {&frame-name} item-doc-est.ipi-outras[1] <> tt-it-imposto.vl-ipiou-it 
            or  input frame {&frame-name} item-doc-est.base-ipi[1]   <> tt-it-imposto.vl-bipi-it  then do:
                assign de-val-aux = abs( input frame {&frame-name} item-doc-est.base-ipi[1] - tt-it-imposto.vl-bipi-it ).               
                run rep/re9995.p (rowid(docum-est),
                                  tt-it-imposto.vl-bipi-it,
                                  input frame {&frame-name} item-doc-est.base-ipi[1],
                                  5506,
                                  no,
                                  i-seq-item,
                                  ( if de-val-aux > param-re.dec-1 then 1 else 2)  ).
            end.                                  
        end.                              
    end.
    else do:

        run rep/re9995.p (rowid(docum-est),
                          0,
                          0,
                          5507,
                          yes,
                          i-seq-item,
                          2).
        run rep/re9995.p (rowid(docum-est),
                          0,
                          0,
                          5506,
                          yes,
                          i-seq-item,
                          2).

    end.

                                
    if l-servicos then do:
        if tt-it-imposto.cd-trib-iss <> 2 and
            tt-it-imposto.cd-trib-iss <> 3 then do:
            /* mensagem: C¢digo de tributaá∆o ISS inv†lido */
            {include/i-vldprg.i}
            {utp/ut-field.i mgind item-doc-est cd-trib-iss 01}
            run utp/ut-msgs.p (input "show":U,input 158,input return-value).
            apply 'entry' to cd-trib-iss in frame {&frame-name}.
            return 'adm-error':U.
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
  {src/adm/template/snd-list.i "item-doc-est"}

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

