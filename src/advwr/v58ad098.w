&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V58AD098 2.00.00.012 } /*** 010012 ***/


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
{cdp/cdcfgdis.i} /* Include para Pre-processadores */

/* Parameters Definitions ---                                           */
&IF '{&bf_dis_versao_ems}' >= "2.062":U &THEN
    {cdp/cd1022.i2 "new" "new global"}
&ELSE
    {pdp/pd0902.i2 "new" "new global"}
&ENDIF

/* Local Variable Definitions ---                                       */
def var i-pedmai        like ped-venda.nr-pedido no-undo.
def var i-pedatr        like ped-venda.nr-pedido no-undo.
def var de-limite       like emitente.lim-credito.

def var i-cont1         as integer initial 0 no-undo.
def var i-cont2         as integer initial 0 no-undo.
def var i-cont3         as integer initial 0 no-undo.
def var i-cont4         as integer initial 0 no-undo.
def var p6-vl-ap-abe-gp as decimal initial 0 no-undo.

def buffer b-emitente for emitente.

{cdp/cd1234.i}   /* Defini‡Æo da fun‡Æo fn_ajust_dec conforme engenharia "Ajustes de Casas Decimais"*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.cod-emitente emitente.nome-emit ~
emitente.cgc emitente.cod-gr-cli emitente.categoria emitente.dt-lim-cred ~
emitente.dt-fim-cred emitente.lim-credito 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 RECT-29 
&Scoped-Define DISPLAYED-FIELDS emitente.cod-emitente emitente.nome-emit ~
emitente.cgc emitente.cod-gr-cli emitente.categoria emitente.dt-lim-cred ~
emitente.dt-fim-cred emitente.lim-credito 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS c-desc-grupo c-ind-cred de-lim-cred-gp ~
c-moeda de-totvlap de-totvlap-gp de-vl-ped de-vl-ped-gp de-totvlre ~
de-totvlre-gp de-totvlaa de-totvlaa-gp de-vl-nota de-vl-nota-gp ~
p5-vl-cr-abe de-saldo-cr de-saldo-cr-gp p6-vl-ap-abe de-saldo-ap ~
de-saldo-ap-gp de-saldo de-saldo-gp i-totpdap i-totpdre i-totpdaa i-totpdcr ~
c-sinal 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-desc-grupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ind-cred AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-ind-cred" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-sinal AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.29 BY .67 NO-UNDO.

DEFINE VARIABLE de-lim-cred-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Atual" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-ap AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Sdo Credor AP/V1. MP" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-ap-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-cr AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Sdo Devedor CR/Vl. MP" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-cr-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlaa AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Tot. Pedidos a Aprovar" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlaa-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlap AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Tot. Ped. Aprov/Aval" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlap-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlre AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Tot. Pedidos Recusados" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlre-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-nota AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "NFïs nÆo atual no CR" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-nota-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ped AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Vl. Pedidos em An lise":R22 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ped-gp AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdaa AS INTEGER FORMAT "999":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 3.86 BY .67 NO-UNDO.

DEFINE VARIABLE i-totpdap AS INTEGER FORMAT "999":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 3.86 BY .67 NO-UNDO.

DEFINE VARIABLE i-totpdcr AS INTEGER FORMAT "999":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 3.86 BY .67 NO-UNDO.

DEFINE VARIABLE i-totpdre AS INTEGER FORMAT "999":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 3.86 BY .67 NO-UNDO.

DEFINE VARIABLE p5-vl-cr-abe AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE p6-vl-ap-abe AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.21.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 4.29.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     emitente.cod-emitente AT ROW 1.13 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     emitente.nome-emit AT ROW 1.13 COL 33.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     emitente.cgc AT ROW 2.54 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.14 BY .88
     emitente.cod-gr-cli AT ROW 3.54 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.50 BY .88
     c-desc-grupo AT ROW 3.54 COL 31 COLON-ALIGNED NO-LABEL
     c-ind-cred AT ROW 4.54 COL 25.29 COLON-ALIGNED
     emitente.categoria AT ROW 4.54 COL 70.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     emitente.dt-lim-cred AT ROW 5.54 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     emitente.dt-fim-cred AT ROW 5.54 COL 38.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     emitente.lim-credito AT ROW 7 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     de-lim-cred-gp AT ROW 7 COL 40.29 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 7 COL 55.29 COLON-ALIGNED NO-LABEL
     de-totvlap AT ROW 8 COL 25.29 COLON-ALIGNED
     de-totvlap-gp AT ROW 8 COL 40.29 COLON-ALIGNED NO-LABEL
     de-vl-ped AT ROW 9 COL 25.29 COLON-ALIGNED HELP
          "Valor da mercadoria em aberto + IPI do saldo aberto"
     de-vl-ped-gp AT ROW 9 COL 40.29 COLON-ALIGNED NO-LABEL
     de-totvlre AT ROW 10 COL 25.29 COLON-ALIGNED
     de-totvlre-gp AT ROW 10 COL 40.29 COLON-ALIGNED NO-LABEL
     de-totvlaa AT ROW 11 COL 25.29 COLON-ALIGNED
     de-totvlaa-gp AT ROW 11 COL 40.29 COLON-ALIGNED NO-LABEL
     de-vl-nota AT ROW 12 COL 25.29 COLON-ALIGNED
     de-vl-nota-gp AT ROW 12 COL 40.29 COLON-ALIGNED NO-LABEL
     p5-vl-cr-abe AT ROW 12.88 COL 72.29 COLON-ALIGNED NO-LABEL
     de-saldo-cr AT ROW 13 COL 25.29 COLON-ALIGNED
     de-saldo-cr-gp AT ROW 13 COL 40.29 COLON-ALIGNED NO-LABEL
     p6-vl-ap-abe AT ROW 13.88 COL 72.29 COLON-ALIGNED NO-LABEL
     de-saldo-ap AT ROW 14 COL 25.29 COLON-ALIGNED
     de-saldo-ap-gp AT ROW 14 COL 40.29 COLON-ALIGNED NO-LABEL
     de-saldo AT ROW 15 COL 25.29 COLON-ALIGNED
     de-saldo-gp AT ROW 15 COL 40.29 COLON-ALIGNED NO-LABEL
     i-totpdap AT ROW 8 COL 56.14 COLON-ALIGNED NO-LABEL
     i-totpdre AT ROW 10 COL 56.14 COLON-ALIGNED NO-LABEL
     i-totpdaa AT ROW 11 COL 56.14 COLON-ALIGNED NO-LABEL
     i-totpdcr AT ROW 12 COL 56.14 COLON-ALIGNED NO-LABEL
     c-sinal AT ROW 15 COL 55.29 COLON-ALIGNED NO-LABEL
     ")" VIEW-AS TEXT
          SIZE 1.29 BY .67 AT ROW 12 COL 62
     ")" VIEW-AS TEXT
          SIZE 1.29 BY .67 AT ROW 11 COL 62
     "(" VIEW-AS TEXT
          SIZE 1 BY .67 AT ROW 10 COL 57.29
     ")" VIEW-AS TEXT
          SIZE 1.29 BY .67 AT ROW 8 COL 62
     "(" VIEW-AS TEXT
          SIZE 1 BY .67 AT ROW 8 COL 57.29
     "(" VIEW-AS TEXT
          SIZE 1 BY .67 AT ROW 11 COL 57.29
     ")" VIEW-AS TEXT
          SIZE 1.29 BY .67 AT ROW 10 COL 62
     "(" VIEW-AS TEXT
          SIZE 1 BY .67 AT ROW 12 COL 57.29
     RECT-27 AT ROW 1 COL 1
     RECT-28 AT ROW 2.33 COL 1
     RECT-29 AT ROW 6.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 15.13
         WIDTH              = 88.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:HEIGHT           = 15.13
       FRAME F-Main:WIDTH            = 88.86.

/* SETTINGS FOR FILL-IN c-desc-grupo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ind-cred IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sinal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-lim-cred-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-ap IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-ap-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-cr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-cr-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlaa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlaa-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlap IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlap-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlre-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-nota IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-nota-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ped IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ped-gp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdaa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdap IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdcr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN p5-vl-cr-abe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN p6-vl-ap-abe IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  find first para-fat NO-LOCK no-error.
  find first param-global NO-LOCK no-error.
  assign emitente.cgc:label in frame {&FRAME-NAME} = param-global.label-cgc.

  find emitente where emitente.cod-emitente = input frame {&frame-name} emitente.cod-emitente NO-LOCK no-error.

  if avail emitente then do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao001 = {adinc/i10ad098.i 04 emitente.ind-cre-cli}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-ind-cred:screen-value = RETURN-VALUE.
     &else
         ASSIGN c-ind-cred:screen-value = {adinc/i10ad098.i 04 emitente.ind-cre-cli}.
     &endif
  end. 
  else assign c-ind-cred:screen-value in frame {&frame-name} = " ".


 if avail emitente then do:

   assign de-lim-cred-gp  = 0
          de-totvlap      = 0
          de-totvlap-gp   = 0
          de-vl-ped       = 0
          de-vl-ped-gp    = 0
          de-vl-ped       = 0
          de-vl-ped-gp    = 0
          de-totvlaa      = 0
          de-totvlaa-gp   = 0 
          de-vl-nota      = 0
          de-vl-nota-gp   = 0
          de-saldo-cr     = 0
          de-saldo-cr-gp  = 0
          de-saldo-ap     = 0
          de-saldo-ap-gp  = 0
          de-saldo        = 0
          de-saldo-gp     = 0
          de-valmai       = 0
          de-valmaiat     = 0
          de-totvlab      = 0
          i-totpdaa       = 0
          i-totpdre       = 0
          i-totpdap       = 0
          i-totpdcr       = 0
          i-pedmai        = 0
          i-diamai        = 0
          i-diamaiat      = 0
          i-pedatr        = 0
          i-cont1         = i-totpdap 
          i-cont2         = i-totpdre 
          i-cont3         = i-totpdaa 
          i-cont4         = i-totpdcr
          da-entmai       = today
          da-prvmai       = today
          da-dt-atr       = today
          da-dt-prv       = today
          l-atrasado      = no
          p5-vl-cr-abe    = 0
          p6-vl-ap-abe    = 0
          p6-vl-ap-abe-gp = 0.

    find b-emitente where rowid(b-emitente) = rowid(emitente) NO-LOCK no-error.
    for each emitente use-index ch-matriz
        where emitente.nome-matriz = b-emitente.nome-matriz no-lock:
        if emitente.dt-lim-cred > today then
           assign de-lim-cred-gp  = de-lim-cred-gp + (emitente.lim-credito 
                                    * de-indice2).
        if emitente.dt-fim-cred > today then 
           assign de-lim-cred-gp  = de-lim-cred-gp + (emitente.lim-adicional
                                    * de-indice2).

        for each  titulo use-index emitente
            where titulo.cod-emitente = emitente.cod-emitente
            and   titulo.vl-saldo > 0 no-lock:

            if  titulo.tipo = 2 then
                assign de-saldo-cr-gp = de-saldo-cr-gp -
                                     ( titulo.vl-saldo * de-indice ).
            else
                if  titulo.tipo = 3 and
                    titulo.mo-codigo > 0 then do:
                    find cotacao
                         where cotacao.mo-codigo   = titulo.mo-codigo
                           and cotacao.ano-periodo = string(year(today)) +
                                                     string(month(today),"99")
                           and cotacao.cotacao[int(day(today))] <> 0
                           no-lock no-error.
                    if  avail cotacao then
                        assign de-saldo-cr-gp = de-saldo-cr-gp +
                                    ((titulo.vl-saldo * de-indice ) *
                                     cotacao.cotacao[int(day(today))]).
                end.
            end.
           for each  tit-ap use-index fornec
               where tit-ap.cod-fornec = emitente.cod-emitente no-lock:
               if  tit-ap.tipo = 2 then
                   assign de-saldo-ap-gp = de-saldo-ap-gp -
                                   ( tit-ap.valor-saldo * de-indice ).
               else
                   if  tit-ap.tipo = 3 and
                       tit-ap.moeda > 0 then do:
                       find cotacao
                            where cotacao.mo-codigo   = tit-ap.moeda
                              and cotacao.ano-periodo = string(year(today)) +
                                                     string(month(today),"99")
                              and cotacao.cotacao[int(day(today))] <> 0
                              no-lock no-error.
                       if  avail cotacao then
                           assign de-saldo-ap-gp = de-saldo-ap-gp +
                                     (( tit-ap.valor-saldo * de-indice ) *
                                     cotacao.cotacao[int(day(today))]).
                   end.
                   else
                      assign de-saldo-ap-gp = de-saldo-ap-gp +
                                           ( tit-ap.valor-saldo * de-indice ).
           end.
        &IF '{&bf_dis_versao_ems}' >= "2.062":U &THEN
            {cdp/cd1022.i3}
        &ELSE
            {pdp/pd0902.i3}
        &ENDIF
    end.

    assign i-totpdap = i-cont1
           i-totpdre = i-cont2
           i-totpdaa = i-cont3
           i-totpdcr = i-cont4.

    find emitente where 
         rowid(emitente) = rowid (b-emitente) NO-LOCK no-error.

    assign de-totvlap-gp  = de-totvlap
           de-vl-ped-gp   = de-vl-ped
           de-totvlre-gp  = de-totvlre
           de-totvlaa-gp  = de-totvlaa
           de-totvlap     = 0 
           de-vl-ped-gp   = 0
           de-totvlre     = 0
           de-totvlaa     = 0.

    &IF '{&bf_dis_versao_ems}' >= "2.062":U &THEN
        {cdp/cd1022.i3}
    &ELSE
        {pdp/pd0902.i3}
    &ENDIF

/** CµLCULO DO TOTAL DE NFïS PENDENTES DE ATUALIZA€ÇO NO CONTAS A RECEBER **/

    assign de-indice = 1 / de-fator-2.

    if  not para-fat.ind-pro-fat then
        for each nota-fiscal use-index ch-atual-cr
            where nota-fiscal.dt-atual-cr = ?
            and nota-fiscal.cod-emitente  = emitente.cod-emitente
            and nota-fiscal.ind-sit-nota  < 3 no-lock
            break by nota-fiscal.nr-fatura:
            assign i-totpdcr = i-totpdcr + 1.
            if  last-of(nota-fiscal.nr-fatura) then do:
                for each fat-duplic no-lock use-index ch-fatura
                   where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                   and fat-duplic.serie         = nota-fiscal.serie
                   and fat-duplic.nr-fatura     = nota-fiscal.nr-fatura:
                   assign de-vl-nota = de-vl-nota +
                                        (fat-duplic.vl-parcela * de-indice).
                end.
            end.
        end.
    else
        for each nota-fiscal no-lock use-index ch-atual-cr
            where nota-fiscal.dt-atual-cr = ?
            and nota-fiscal.cod-emitente  = emitente.cod-emitente
            and nota-fiscal.ind-sit-nota  < 3:
            assign i-totpdcr = i-totpdcr + 1.
            for each fat-duplic no-lock use-index ch-fatura
               where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
               and   fat-duplic.serie         = nota-fiscal.serie
               and   fat-duplic.nr-fatura     = nota-fiscal.nr-fatura:
               assign de-vl-nota = de-vl-nota +
                                   (fat-duplic.vl-parcela * de-indice).
            end.
        end.

    assign i-cont4 = i-totpdcr.

    for each  b-emitente use-index ch-matriz
        where b-emitente.nome-matriz = emitente.nome-matriz no-lock,
        each  nota-fiscal use-index ch-atual-cr
        where nota-fiscal.dt-atual-cr  = ?
        and nota-fiscal.cod-emitente = b-emitente.cod-emitente
        and nota-fiscal.ind-sit-nota < 3 no-lock
        break by nota-fiscal.nr-fatura:
        assign i-totpdcr = i-totpdcr + 1.

        if  last-of(nota-fiscal.nr-fatura) then do:
            for each fat-duplic no-lock
                where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  and fat-duplic.serie       = nota-fiscal.serie
                  and fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                assign de-vl-nota-gp = de-vl-nota-gp +
                              (fat-duplic.vl-parcela * de-indice).

            end.
        end.
    end.

    assign de-indice = 1
           i-totpdcr = i-cont4.

/** FIM DO CµLCULO DO TORAL DE NFïS PENDENTES DE ATUALIZA€ÇO NO CR **/



    assign de-totvlaa    = if  avail ped-venda and
                               ped-venda.cod-sit-aval <> 3 then
                               de-totvlaa - de-vl-ped
                           else de-totvlaa.
    assign de-totvlaa-gp = if avail ped-venda and
                              ped-venda.cod-sit-aval <> 3 then 
                              de-totvlaa-gp - de-vl-ped-gp
                           else de-totvlaa-gp.

    if emitente.dt-lim-cred > today then assign de-saldo = emitente.lim-credito   * de-indice2 + de-saldo.
    if emitente.dt-fim-cred > today then assign de-saldo = emitente.lim-adicional * de-indice2 + de-saldo.

    assign de-saldo-gp  = (de-lim-cred-gp + de-saldo-ap-gp + p6-vl-ap-abe-gp -
                        (de-totvlap-gp + de-saldo-cr-gp + de-vl-ped-gp +
                         de-vl-nota-gp + p5-vl-cr-abe)) .

    assign de-saldo = de-saldo + de-saldo-ap + p6-vl-ap-abe -
                      (de-totvlap + de-saldo-cr + de-vl-ped + de-vl-nota + 
                       p5-vl-cr-abe).

    if  de-saldo < 0 then
        assign de-saldo = - (de-saldo)
               c-sinal  = "(-)".
    else
        c-sinal = "(+)".

    assign de-limite = 0.

    if emitente.dt-lim-cred > today then
       assign de-limite = emitente.lim-credito * de-indice2 + de-limite.
    if emitente.dt-fim-cred > today then
       assign de-limite = emitente.lim-adicional * de-indice2 + de-limite.
end.

 display de-lim-cred-gp
         de-totvlap
         de-totvlap-gp 
         de-vl-ped
         de-vl-ped-gp
         de-totvlre
         de-totvlre-gp
         de-totvlaa
         de-totvlaa-gp
         de-vl-nota
         de-vl-nota-gp
         de-saldo-cr
         de-saldo-cr-gp
         de-saldo-ap
         de-saldo-ap-gp
         de-saldo
         de-saldo-gp
         c-sinal
         i-totpdcr
         i-totpdaa
         i-totpdre
         i-totpdap
         c-moeda
         p5-vl-cr-abe
         p6-vl-ap-abe with frame {&frame-name}.

      if avail emitente then 
         find first gr-cli 
              where gr-cli.cod-gr-cli = emitente.cod-gr-cli no-lock no-error.

      assign c-desc-grupo:screen-value  in frame {&FRAME-NAME} = if avail gr-cli then gr-cli.descricao else "":U.

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

  {utp/ut-liter.i Cr‚dito * L}
  assign c-ind-cred:label in frame {&frame-name} = return-value.

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
  {src/adm/template/snd-list.i "emitente"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

