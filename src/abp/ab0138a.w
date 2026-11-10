&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138A 2.00.00.011 } /*** "010011" 28/01/2025 08:20:09 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138a MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0138A
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1


&GLOBAL-DEFINE FolderLabels      Dados, Inicial, Document

&GLOBAL-DEFINE ttTable           ttEqpto
&GLOBAL-DEFINE hDBOTable         hDBOEqpto
&GLOBAL-DEFINE DBOTable          mab-eqpto

&GLOBAL-DEFINE page0KeyFields    ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page1Fields       ttEqpto.idi-tip-eqpto ttEqpto.cod-model ~
                                 ttEqpto.cod-estrut-mec ttEqpto.cod-sit-eqpto ~
                                 ttEqpto.idi-tip-propriet ttEqpto.cod-emitente ~
                                 ttEqpto.dat-situacao ttEqpto.bm-codigo ttEqpto.bm-indice ~
                                 fi-cta-patrimonial fi-hra-situacao ttEqpto.log-alugdo
&GLOBAL-DEFINE page2Fields       ttEqpto.dat-inicial ~
                                 ttEqpto.val-hodom-horim-inicial ttEqpto.val-km-inicial ~
                                 ttEqpto.log-cont-sec ttEqpto.val-hodom-horim-sec ~
                                 ttEqpto.val-km-sec ttEqpto.log-bloq-informa-cont-ord
&GLOBAL-DEFINE page3Fields       ttEqpto.cod-placa ttEqpto.cod-chassi ~
                                 ttEqpto.cod-renavam ttEqpto.vli-ano-fabric ~
                                 ttEqpto.vli-ano-model ttEqpto.dat-compra ~
                                 ttEqpto.val-compra fiFornec ttEqpto.log-livre-1

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE    NO-UNDO.

DEFINE VARIABLE iSituacao        AS INTEGER   NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE iEmpOrig         LIKE empresa.ep-codigo NO-UNDO.
&else
DEFINE VARIABLE iEmpOrig         AS INTEGER   NO-UNDO.
&endif
DEFINE VARIABLE cEqptoOrig       AS CHARACTER NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE iEmpDest         LIKE empresa.ep-codigo NO-UNDO.
&else
DEFINE VARIABLE iEmpDest         AS INTEGER   NO-UNDO.
&endif
DEFINE VARIABLE cEqptoDest       AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-habilita       AS LOGICAL   INITIAL NO NO-UNDO.
DEFINE VARIABLE l-zoom-ems5      AS LOGICAL initial no   NO-UNDO.
DEFINE VARIABLE cUnModelSec      AS CHARACTER NO-UNDO.
/* Utilizada para a integracao com Ativo Fixo EMS 5 */
{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_bem_pat as ROWID no-undo. /* carregada no zoom prgfin/fas/fas701ka.p. */
&ELSE
    def new global shared var v_rec_bem_pat as RECID initial ? no-undo. /* carregada no zoom prgfin/fas/fas701ka.p. */
&ENDIF

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEstrutura    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSituacao     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOBem          AS HANDLE NO-UNDO.
define new global shared variable c-seg-usuario as char    format "x(12)" no-undo.
DEFINE VARIABLE hDBOParam        AS HANDLE NO-UNDO.
{include/i_fnctrad.i}
{abp/ab0138.i} /*** Temp-tables para integra�ﾆo com EMS5 ***/

define variable hDBOMovtoPneu          as handle      no-undo.
define variable hDBOMovtoCompon        as handle      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto 
&Scoped-define ENABLED-TABLES ttEqpto
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto 
&Scoped-define DISPLAYED-TABLES ttEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-cta-patrimonial AS CHARACTER FORMAT "X(18)":U 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .79 TOOLTIP "Conta Patrimonial" NO-UNDO.

DEFINE VARIABLE fi-hra-situacao AS CHARACTER FORMAT "99:99:99":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usurio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEmitente AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEstrut AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescSituacao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 1.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 1.25.

DEFINE VARIABLE fiUnModel AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnModelSec AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescFornecedor AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fiFornec AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEqpto.ep-codigo AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     btOK AT ROW 17.25 COL 2
     btSave AT ROW 17.25 COL 13
     btCancel AT ROW 17.25 COL 24
     btHelp AT ROW 17.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.42
         FONT 1.

DEFINE FRAME fPage1
     ttEqpto.idi-tip-eqpto AT ROW 2.96 COL 24.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"Nﾆo Motorizado", 2
          SIZE 35 BY .71
     ttEqpto.cod-model AT ROW 3.96 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescModelo AT ROW 3.96 COL 24.57 COLON-ALIGNED HELP
          "Descri�ﾆo Modelo Equipamento" NO-LABEL
     ttEqpto.cod-estrut-mec AT ROW 4.96 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescEstrut AT ROW 4.96 COL 24.57 COLON-ALIGNED HELP
          "Descri�ﾆo da Estrutura Mecハica" NO-LABEL
     ttEqpto.cod-sit-eqpto AT ROW 5.96 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescSituacao AT ROW 5.96 COL 24.57 COLON-ALIGNED HELP
          "Descri�ﾆo da Situa�ﾆo do Equipamento" NO-LABEL
     ttEqpto.dat-situacao AT ROW 5.96 COL 70.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-hra-situacao AT ROW 6.96 COL 70.57 COLON-ALIGNED
     ttEqpto.idi-tip-propriet AT ROW 7.46 COL 20 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Proprio", 1,
"Terceiro", 2
          SIZE 27 BY .88
     ttEqpto.log-alugdo AT ROW 7.46 COL 47.72 WIDGET-ID 10
          VIEW-AS TOGGLE-BOX
          SIZE 12.29 BY .83
     ttEqpto.cod-emitente AT ROW 8.71 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescEmitente AT ROW 8.71 COL 24.57 COLON-ALIGNED HELP
          "Nome do Proprietrio" NO-LABEL
     ttEqpto.bm-codigo AT ROW 9.71 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttEqpto.bm-indice AT ROW 9.71 COL 32.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-cta-patrimonial AT ROW 9.71 COL 52.86 COLON-ALIGNED
     fi-usuario AT ROW 10.71 COL 17 COLON-ALIGNED
     "Tipo Equipamento" VIEW-AS TEXT
          SIZE 13.57 BY .54 AT ROW 2.21 COL 21
     "Tipo Proprietrio" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 6.96 COL 21.14
     RECT-1 AT ROW 2.5 COL 19.14
     RECT-4 AT ROW 7.21 COL 19.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage2
     ttEqpto.dat-inicial AT ROW 2.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttEqpto.log-bloq-informa-cont-ord AT ROW 3.75 COL 23 WIDGET-ID 6
          LABEL "Bloqueia Informar Contador na OM"
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .71
     ttEqpto.val-hodom-horim-inicial AT ROW 4.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiUnModel AT ROW 4.75 COL 31.57 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     ttEqpto.val-km-inicial AT ROW 5.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttEqpto.log-cont-sec AT ROW 6.75 COL 23
          LABEL "Utiliza Contador Secundrio":L30
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .71
     ttEqpto.val-hodom-horim-sec AT ROW 7.63 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiUnModelSec AT ROW 7.63 COL 31.57 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     ttEqpto.val-km-sec AT ROW 8.63 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage3
     ttEqpto.cod-placa AT ROW 1.63 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttEqpto.cod-chassi AT ROW 2.63 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttEqpto.cod-renavam AT ROW 3.63 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ttEqpto.vli-ano-fabric AT ROW 4.63 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.vli-ano-model AT ROW 5.63 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.dat-compra AT ROW 7.38 COL 28.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttEqpto.val-compra AT ROW 8.38 COL 28.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescFornecedor AT ROW 10 COL 28.29 COLON-ALIGNED NO-LABEL
     fiFornec AT ROW 10.04 COL 19.14 COLON-ALIGNED
     "Compra" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 6.63 COL 21
     RECT-5 AT ROW 6.88 COL 19
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.42
         WIDTH              = 90
         MAX-HEIGHT         = 28.75
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.75
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttEqpto.cod-eqpto:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage3:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage2:MOVE-BEFORE-TAB-ITEM (FRAME fPage3:HANDLE)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (FRAME fPage2:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR TOGGLE-BOX ttEqpto.log-bloq-informa-cont-ord IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttEqpto.log-cont-sec IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttEqpto.val-km-sec IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN fiDescFornecedor IN FRAME fPage3
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttEqpto.bm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.bm-codigo wMaintenanceNoNavigation
ON F5 OF ttEqpto.bm-codigo IN FRAME fPage1 /* Bem */
DO:
    /**** EMS implantado**/
    if l-zoom-ems5 then do:
       RUN pi-ativo-ems5.
    end.
    else do:
         {include/zoomvar.i &prog-zoom=adzoom/z02ad019.w
                       &campo={&ttTable}.bm-codigo
                       &campozoom=bm-codigo
                       &frame=fPage1
                       &campo2={&ttTable}.bm-indice
                       &campozoom2=bm-indice
                       &frame2=fPage1} 
    end.
                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.bm-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.bm-codigo IN FRAME fPage1 /* Bem */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.bm-indice
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.bm-indice wMaintenanceNoNavigation
ON F5 OF ttEqpto.bm-indice IN FRAME fPage1 /* bm-indice */
DO:
    apply "F5":U to ttEqpto.bm-codigo IN FRAME fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.bm-indice wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.bm-indice IN FRAME fPage1 /* bm-indice */
DO:
    apply "F5":U to ttEqpto.bm-codigo IN FRAME fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF  c-nom-prog-upc-mg97 <> "" AND 
        c-nom-prog-upc-mg97 <> ? THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BOTAO-OK":U, 
                                        INPUT "BUTTON":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage0:HANDLE,
                                        INPUT "":U,
                                        INPUT ?).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN NO-APPLY.
    END.

    IF INPUT FRAME fPage2 ttEqpto.dat-inicial > TODAY THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2555,
                           INPUT ""). 
        RETURN "NOK":U.
    END.
    RUN piVerificaPartesEqpto IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN
        RUN saveRecord IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "OK":U THEN do:
        /** Fecha Programa **/
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN piVerificaPartesEqpto IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN
        RUN saveRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttEqpto.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-emitente wMaintenanceNoNavigation
ON F5 OF ttEqpto.cod-emitente IN FRAME fPage1 /* Proprietrio */
DO:
    assign l-implanta = yes.
      {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                     &campo=ttEqpto.cod-emitente
                     &campozoom=cod-emitente
                     &frame=fPage1
                     &campo2=fiDescEmitente
                     &campozoom2=nome-emit
                     &frame2=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-emitente wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-emitente IN FRAME fPage1 /* Proprietrio */
DO:
    {include/leave.i
             &tabela=emitente
             &atributo-ref=nome-emit
             &variavel-ref=fiDescEmitente
             &where="emitente.cod-emitente = input frame fPage1 ttEqpto.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.cod-emitente IN FRAME fPage1 /* Proprietrio */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.cod-estrut-mec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-estrut-mec wMaintenanceNoNavigation
ON F5 OF ttEqpto.cod-estrut-mec IN FRAME fPage1 /* Estrutura Mecハica */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr009.w"
           &FieldZoom1="cod-estrut-mec"
           &FieldScreen1="ttEqpto.cod-estrut-mec"
           &Frame1="fPage1"
           &FieldZoom2="des-estrut-mec"
           &FieldScreen2="fiDescEstrut"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-estrut-mec wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-estrut-mec IN FRAME fPage1 /* Estrutura Mecハica */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOEstrutura"
        &KeyValue1="ttEqpto.cod-estrut-mec:screen-value in frame fPage1"
        &FieldName1="des-estrut-mec"
        &FieldScreen1="fiDescEstrut"
        &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-estrut-mec wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.cod-estrut-mec IN FRAME fPage1 /* Estrutura Mecハica */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.cod-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-model wMaintenanceNoNavigation
ON F5 OF ttEqpto.cod-model IN FRAME fPage1 /* Modelo */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr016.w"
           &FieldZoom1="cod-model"
           &FieldScreen1="ttEqpto.cod-model"
           &Frame1="fPage1"
           &FieldZoom2="des-model"
           &FieldScreen2="fiDescModelo"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-model wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-model IN FRAME fPage1 /* Modelo */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="ttEqpto.cod-model:screen-value in frame fPage1"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage1"
        &FieldName2="un"
        &FieldScreen2="fiUnModel"
        &Frame2="fPage2"}
    RUN piVerificaContSec IN THIS-PROCEDURE.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-model wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.cod-model IN FRAME fPage1 /* Modelo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.cod-sit-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenanceNoNavigation
ON F5 OF ttEqpto.cod-sit-eqpto IN FRAME fPage1 /* Situa�ﾆo */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr024.w"
           &FieldZoom1="cod-sit-eqpto"
           &FieldScreen1="ttEqpto.cod-sit-eqpto"
           &Frame1="fPage1"
           &FieldZoom2="des-sit-eqpto"
           &FieldScreen2="fiDescSituacao"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-sit-eqpto IN FRAME fPage1 /* Situa�ﾆo */
DO:
    {method\ReferenceFields.i
        &HandleDBOLeave="hDBOSituacao"
        &KeyValue1="ttEqpto.cod-sit-eqpto:screen-value in frame fPage1"
        &FieldName1="des-sit-eqpto"
        &FieldScreen1="fiDescSituacao"
        &Frame1="fPage1"}

    /** Habilita/Desbilita Data Situa�ﾆo **/
    run piSituacao in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.cod-sit-eqpto IN FRAME fPage1 /* Situa�ﾆo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttEqpto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.ep-codigo wMaintenanceNoNavigation
ON F5 OF ttEqpto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
                     &campo=ttEqpto.ep-codigo
                     &campozoom=ep-codigo
                     &frame=fPage0}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cta-patrimonial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cta-patrimonial wMaintenanceNoNavigation
ON F5 OF fi-cta-patrimonial IN FRAME fPage1 /* Conta Patrimonial */
DO:
    apply "F5":U to ttEqpto.bm-codigo IN FRAME fPage1.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cta-patrimonial wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cta-patrimonial IN FRAME fPage1 /* Conta Patrimonial */
DO:
    apply "F5":U to ttEqpto.bm-codigo IN FRAME fPage1.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-situacao wMaintenanceNoNavigation
ON LEAVE OF fi-hra-situacao IN FRAME fPage1 /* Hora */
DO:
    DEFINE VARIABLE cHora AS CHARACTER FORMAT "99:99:99" NO-UNDO.
    /** Consiste o horrio **/
    assign cHora = fi-hra-situacao:screen-value in frame fPage1.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to fi-hra-situacao in frame fPage1.
        return no-apply.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fiFornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFornec wMaintenanceNoNavigation
ON F5 OF fiFornec IN FRAME fPage3 /* Fornecedor */
DO:
    assign l-implanta = yes.
      {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                     &campo=fiFornec
                     &campozoom=cod-emitente
                     &frame=fPage3
                     &campo2=fiDescFornecedor
                     &campozoom2=nome-emit
                     &frame2=fPage3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFornec wMaintenanceNoNavigation
ON LEAVE OF fiFornec IN FRAME fPage3 /* Fornecedor */
DO:
            {include/leave.i
             &tabela=emitente
             &atributo-ref=nome-emit
             &variavel-ref=fiDescFornecedor
             &where="emitente.cod-emitente = input frame fPage3 fiFornec"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFornec wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiFornec IN FRAME fPage3 /* Fornecedor */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttEqpto.idi-tip-propriet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.idi-tip-propriet wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttEqpto.idi-tip-propriet IN FRAME fPage1
DO:
    IF l-habilita AND ttEqpto.idi-tip-propriet:screen-value in frame fPage1 = "1":U THEN DO:
        ASSIGN ttEqpto.bm-codigo:SENSITIVE IN FRAME fPage1 = TRUE           
               ttEqpto.bm-indice:SENSITIVE IN FRAME fPage1 = TRUE.
        IF l-zoom-ems5 THEN
            ASSIGN fi-cta-patrimonial:SENSITIVE IN FRAME fPage1 = TRUE.
    END.
    ELSE DO: 
        ASSIGN ttEqpto.bm-codigo:SENSITIVE IN FRAME fPage1 = FALSE           
               ttEqpto.bm-indice:SENSITIVE IN FRAME fPage1 = FALSE
               ttEqpto.bm-codigo:SCREEN-VALUE IN FRAME fPage1 = "0":U
               ttEqpto.bm-indice:SCREEN-VALUE IN FRAME fPage1 = "0":U.
        IF l-zoom-ems5 THEN
            ASSIGN fi-cta-patrimonial:SENSITIVE IN FRAME fPage1    = FALSE
                   fi-cta-patrimonial:SCREEN-VALUE IN FRAME fPage1 = "":U.         
    END.

    IF  ttEqpto.idi-tip-propriet:SCREEN-VALUE IN FRAME fPage1 = "2":U THEN
        ASSIGN ttEqpto.log-alugdo:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE
        ASSIGN ttEqpto.log-alugdo:CHECKED   IN FRAME fPage1 = FALSE
               ttEqpto.log-alugdo:SENSITIVE IN FRAME fPage1 = FALSE.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ttEqpto.log-cont-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.log-cont-sec wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttEqpto.log-cont-sec IN FRAME fPage2 /* Utiliza Contador Secundrio */
DO:
    IF  ttEqpto.log-cont-sec:CHECKED IN FRAME fPage2 = YES THEN DO:
        IF  TRIM(ttEqpto.cod-model:SCREEN-VALUE IN FRAME fPage1) = "" THEN DO:
            {utp/ut-liter.i Modelo *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 17677, 
                               INPUT RETURN-VALUE).
            APPLY "ENTRY":U TO ttEqpto.cod-model IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
        ASSIGN ttEqpto.val-hodom-horim-sec:SENSITIVE IN FRAME fPage2 = YES
               fiUnModelSec:SCREEN-VALUE             IN FRAME fPage2 = SUBSTRIN(cUnModelSec,1,2)
               ttEqpto.val-km-sec:SENSITIVE          IN FRAME fPage2 = YES.
    END.
    ELSE
        ASSIGN fiUnModelSec:SCREEN-VALUE                IN FRAME fPage2 = ""
               ttEqpto.val-hodom-horim-sec:SCREEN-VALUE IN FRAME fPage2 = ""
               ttEqpto.val-km-sec:SCREEN-VALUE          IN FRAME fPage2 = ""
               ttEqpto.val-hodom-horim-sec:SENSITIVE    IN FRAME fPage2 = NO
               ttEqpto.val-km-sec:SENSITIVE             IN FRAME fPage2 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME ttEqpto.vli-ano-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.vli-ano-fabric wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.vli-ano-fabric IN FRAME fPage3 /* Ano Fabrica�ﾆo */
DO:
    /** Consiste Ano de Fabrica�ﾆo **/
    run consisteAno in {&hDBOTable} (input integer({&ttTable}.vli-ano-fabric:screen-value in frame fPage3),
                                     input 1 /** Fabrica�ﾆo **/ ).
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
        return no-apply.
    end.
    assign {&ttTable}.vli-ano-model = input frame fPage3 {&ttTable}.vli-ano-fabric.
    display {&ttTable}.vli-ano-model with frame fPage3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.vli-ano-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.vli-ano-model wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.vli-ano-model IN FRAME fPage3 /* Ano Modelo */
DO:
    /** Consiste Ano do Modelo **/
    run consisteAno in {&hDBOTable} (input integer(ttEqpto.vli-ano-model:screen-value in frame fPage3),
                                     input 2 /** Modelo **/ ).
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
        return no-apply.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L｢gica para inicializa�ﾆo do programam ---*/
{maintenancenonavigation/mainblock.i}
{abp/ab9000.i} /** Procedures controle de hora **/

ttEqpto.cod-model:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
ttEqpto.cod-estrut-mec:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage1.
ttEqpto.cod-sit-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
ttEqpto.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U)    in frame fPage1.
ttEqpto.ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage0.
ttEqpto.bm-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
ttEqpto.bm-indice:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
fi-cta-patrimonial:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.
fiFornec:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap｢s) a finaliza�ﾆo do programa
------------------------------------------------------------------------------*/
/** Modelo **/
if valid-handle (hDBOModelo) then
    run destroy in hDBOModelo.

/** Estrutura **/
if valid-handle (hDBOestrutura) then
    run destroy in hDBOestrutura.

/** Situa�ﾆo **/
if valid-handle (hDBOSituacao) then
    run destroy in hDBOSituacao.

if valid-handle (hDBOMovtoPneu) then
    run destroy in hDBOMovtoPneu.

if valid-handle (hDBOMovtoCompon) then
    run destroy in hDBOMovtoCompon.
/* Parametros */        
if valid-handle (hDBOParam) then
    run destroy in hDBOParam.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap｢s) do display dos campos em tela 
------------------------------------------------------------------------------*/
    /** Usurio de inclusﾆo ou ｣ltima altera�ﾆo do registro **/
    ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fpage1 = c-seg-usuario.
    
    /* /** Verifica tipo de proprietrio **/                                */
    /* apply "VALUE-CHANGED":U to ttEqpto.idi-tip-propriet in frame fPage1. */
    IF  l-habilita AND ttEqpto.idi-tip-propriet:SCREEN-VALUE IN FRAME fPage1 = "1":U THEN DO:
        ASSIGN ttEqpto.bm-codigo:SENSITIVE IN FRAME fPage1 = TRUE           
               ttEqpto.bm-indice:SENSITIVE IN FRAME fPage1 = TRUE.
        IF  l-zoom-ems5 THEN
            ASSIGN fi-cta-patrimonial:SENSITIVE IN FRAME fPage1 = TRUE.
    END.
    ELSE DO: 
        ASSIGN ttEqpto.bm-codigo:SENSITIVE IN FRAME fPage1 = FALSE           
               ttEqpto.bm-indice:SENSITIVE IN FRAME fPage1 = FALSE.
        IF  l-zoom-ems5 THEN
            ASSIGN fi-cta-patrimonial:SENSITIVE IN FRAME fPage1    = FALSE.     
    END.

    IF  ttEqpto.idi-tip-propriet:SCREEN-VALUE IN FRAME fPage1 = "2":U THEN
        ASSIGN ttEqpto.log-alugdo:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE
        ASSIGN ttEqpto.log-alugdo:SENSITIVE IN FRAME fPage1 = FALSE.

    
    ASSIGN fiFornec:SCREEN-VALUE IN FRAME fPage3 = STRING(ttEqpto.num-livre-2).
    
    /** Descri�臚s de campos **/
    APPLY "LEAVE":U TO ttEqpto.cod-model IN FRAME fPage1.
    APPLY "LEAVE":U TO ttEqpto.cod-estrut-mec  IN FRAME fPage1.
    APPLY "LEAVE":U TO ttEqpto.cod-sit-eqpto   IN FRAME fPage1.
    APPLY "LEAVE":U TO ttEqpto.cod-emitente    IN FRAME fPage1.
    APPLY "LEAVE":U TO fiFornec                IN FRAME fPage3.
    
    IF  l-habilita AND l-zoom-ems5 AND AVAIL ttEqpto THEN
        ASSIGN fi-cta-patrimonial:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING(ttEqpto.cod-livre-1,1,18).
    ELSE
        ASSIGN fi-cta-patrimonial:SCREEN-VALUE IN FRAME fPage1 = "":U.
    
    IF  pcAction = "UPDATE":U THEN DO:
        RUN piValidaLogSec IN hDBOModelo (INPUT 2 /*1 = consulta por Equipamento*/,
                                          INPUT ttEqpto.ep-codigo:SCREEN-VALUE IN FRAME fPage0 /*empresa*/,
                                          INPUT ttEqpto.cod-eqpto:SCREEN-VALUE IN FRAME fPage0).
        IF  RETURN-VALUE = "NOK":U THEN
            ASSIGN ttEqpto.log-cont-sec:SENSITIVE IN FRAME fPage2 = NO.
    END.

    RUN setfolder IN hFolder (INPUT 1).

    /** Seta foco no campo correto **/
    RUN piFocoInicial IN THIS-PROCEDURE.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (Ap｢s) inicializa�ﾆo da tela
------------------------------------------------------------------------------*/
for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
    {utp/ut-liter.i Sim}
    if entry(2,mab-param-integr.des-valor) = return-value then do:
        {utp/ut-liter.i "Integra Rastreamento"}
        ASSIGN ttEqpto.log-livre-1:LABEL IN FRAME fPage3 = RETURN-VALUE.
        assign ttEqpto.log-livre-1:visible in frame fPage3   = yes
               ttEqpto.log-livre-1:sensitive in frame fPage3 = yes.
    end.
    else do:
        assign ttEqpto.log-livre-1:visible in frame fPage3   = no
               ttEqpto.log-livre-1:sensitive in frame fPage3 = no.
    end.
end.
IF  not avail mab-param-integr then do:
    assign ttEqpto.log-livre-1:visible in frame fPage3   = no
           ttEqpto.log-livre-1:sensitive in frame fPage3 = no.
end.
 
{utp/ut-liter.i Chassi/SＳie}
assign ttEqpto.cod-chassi:label in frame fPage3 = return-value.

run setAction in {&hDBOtable} (INPUT pcAction,
                               input ?,
                               input ?,
                               input ?,
                               input ?).

run habilitaCampos in {&hDBOTable} (output l-habilita,
                                    OUTPUT l-zoom-ems5).

/** Seta foco no campo correto **/
run afterDisplayFields in this-procedure.

if pcAction = "COPY":U then do:
    assign iEmpOrig   = input frame fPage0 {&ttTable}.ep-codigo
           cEqptoOrig = input frame fPage0 {&ttTable}.cod-eqpto.
end.

if pcAction = "UPDATE":U then do:
    ASSIGN ttEqpto.dat-inicial:SENSITIVE IN FRAME fPage2 = NO.
END.

/*Caso integra�ﾆo com ems5 esteja implantado, mostrar campo Conta Patrimonial */
IF l-habilita AND l-zoom-ems5 THEN
    ASSIGN fi-cta-patrimonial:HIDDEN IN FRAME fPage1 = FALSE.
ELSE
    ASSIGN fi-cta-patrimonial:HIDDEN IN FRAME fPage1    = TRUE
           fi-cta-patrimonial:SENSITIVE IN FRAME fPage1 = FALSE.

assign btSave:SENSITIVE IN FRAME fPage0 = false.
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     afterSaveFields
  Parameters:  <none>
  Notes:       Override (ap｢s) a finaliza�ﾆo do programa
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-hra-situacao AS CHARACTER FORMAT "x(6)" NO-UNDO.

ASSIGN c-hra-situacao                       = REPLACE(fi-hra-situacao:SCREEN-VALUE IN FRAME fPage1,":","").
ASSIGN OVERLAY({&ttTable}.cod-livre-1,19,6) = c-hra-situacao.

if pcAction = "COPY":U and
   avail {&ttTable} then assign {&ttTable}.r-rowid = ?.

if pcAction = "COPY":U then do:
    assign iEmpDest   = input frame fPage0 {&ttTable}.ep-codigo
           cEqptoDest = input frame fPage0 {&ttTable}.cod-eqpto.

    RUN setAction IN {&hDBOtable} (INPUT pcAction,
                                   input  iEmpOrig,
                                   input  cEqptoOrig,
                                   input  iEmpDest,
                                   input  cEqptoDest).
END.

ASSIGN {&ttTable}.num-livre-2 = INPUT FRAME fPage3 fiFornec.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializa�ﾆo da tela
------------------------------------------------------------------------------*/

/** inicializa as DBOs **/

run initializeDBOs in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     antes de salvar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF l-habilita AND l-zoom-ems5 AND ttEqpto.idi-tip-propriet:screen-value in frame fPage1 = "1":U THEN
    ASSIGN OVERLAY(ttEqpto.cod-livre-1,1,18) = fi-cta-patrimonial:SCREEN-VALUE IN FRAME fPage1.
ELSE
    ASSIGN OVERLAY(ttEqpto.cod-livre-1,1,18) = "":U.

ASSIGN ttEqpto.cod-livre-2 = c-seg-usuario.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs no programa
------------------------------------------------------------------------------*/

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Estrutura ---*/
    IF NOT VALID-HANDLE(hDBOEstrutura) OR
       hDBOEstrutura:TYPE <> "PROCEDURE":U OR
       hDBOEstrutura:FILE-NAME <> "frbo/bofr009.p":U THEN DO:
        run frbo/bofr009.p persistent set  hDBOEstrutura.
    END.
    
    RUN openQueryStatic IN hDBOEstrutura (INPUT "Main":U) NO-ERROR.

    /*--- DBO Situa�ﾆo ---*/
    IF NOT VALID-HANDLE(hDBOSituacao) OR
       hDBOSituacao:TYPE <> "PROCEDURE":U OR
       hDBOSituacao:FILE-NAME <> "frbo/bofr024.p":U THEN DO:
        run frbo/bofr024.p persistent set  hDBOSituacao.
    END.
    
    RUN openQueryStatic IN hDBOSituacao (INPUT "Main":U) NO-ERROR.

    /*--- DBO Parametros ---*/
    IF  NOT VALID-HANDLE(hDBOParam) OR
        hDBOParam:TYPE <> "PROCEDURE":U OR
        hDBOParam:FILE-NAME <> "frbo/bofr019.p":U THEN DO:
        RUN frbo/bofr019.p PERSISTENT SET hDBOParam.
    END.

    RUN openQueryStatic IN hDBOParam (INPUT "Main":U) NO-ERROR.
    
    /*--- DBO Movimento Pneus ---*/
    IF NOT VALID-HANDLE(hDBOMovtoPneu)     OR
       hDBOMovtoPneu:TYPE <> "PROCEDURE":U OR
       hDBOMovtoPneu:FILE-NAME <> "frbo/bofr074.p":U THEN DO:
        run frbo/bofr074.p persistent set hDBOMovtoPneu.
    END.
    
    RUN openQueryStatic IN hDBOMovtoPneu (INPUT "Main":U) NO-ERROR.
    
    /*--- DBO Movimento Componentes ---*/
    IF NOT VALID-HANDLE(hDBOMovtoCompon)     OR
       hDBOMovtoCompon:TYPE <> "PROCEDURE":U OR
       hDBOMovtoCompon:FILE-NAME <> "frbo/bofr066.p":U THEN DO:
        run frbo/bofr066.p persistent set hDBOMovtoCompon.
    END.
    
    RUN openQueryStatic IN hDBOMovtoCompon (INPUT "Main":U) NO-ERROR.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ativo-ems5 wMaintenanceNoNavigation 
PROCEDURE pi-ativo-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iErro AS INTEGER    NO-UNDO.

/** Procura pelo programa e retorna mensagem de erro se nﾆo o encontrar **/
if  search("prgfin/fas/fas230za.r")  = ? then do:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 3984,
                       INPUT "prgfin/fas/fas230za.r":U).
    RETURN "NOK":U.
END.
/** Procura pelo programa e retorna mensagem de erro se nﾆo o encontrar **/
if  search("prgfin/fas/fas701ka.r")  = ? then do:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 3984,
                       INPUT "prgfin/fas/fas701ka.r":U).
    RETURN "NOK":U.
END.
RUN prgfin/fas/fas701ka.p.
IF v_rec_bem_pat <> ? THEN DO:
   run prgfin/fas/fas230za.py(INPUT  1,
                              INPUT  "EMS2",
                              INPUT  "",
                              INPUT  "",
                              INPUT  0,
                              INPUT  0,
                              INPUT  "",
                              INPUT  0,
                              INPUT  0,
                              INPUT  v_rec_bem_pat,
                              INPUT  0, //NUM_ID_BEM
                              OUTPUT TABLE tt_bem_pat_consulta_api,
                              OUTPUT TABLE tt_log_erro).

   /** Busca ｣ltimo erro criado na BO **/
   for last RowErrors no-lock:
       assign iErro = RowErrors.ErrorSequence.
   end.
   IF CAN-FIND(FIRST tt_log_erro) THEN DO:
      FOR EACH tt_log_erro NO-LOCK:
          create RowErrors.
          assign RowErrors.ErrorNumber       = tt_log_erro.ttv_num_cod_erro          
                 RowErrors.ErrorDescription  = tt_log_erro.ttv_des_msg_ajuda         
                 RowErrors.ErrorParameters   = "":U       
                 RowErrors.ErrorType         = "EMS":U         
                 RowErrors.ErrorHelp         = tt_log_erro.ttv_des_msg_ajuda         
                 RowErrors.ErrorSubType      = "ERROR":U         
                 RowErrors.ErrorSequence     = iErro + 1 
                 iErro = RowErrors.ErrorSequence.        
      END.
      IF CAN-FIND(FIRST RowErrors where RowErrors.ErrorSubType = "ERROR":U ) THEN  DO:
            RETURN "NOK":U.
      END.
   END.
   ELSE DO:
      FIND FIRST tt_bem_pat_consulta_api NO-LOCK NO-ERROR.
      IF AVAIL tt_bem_pat_consulta_api THEN DO:
         ASSIGN {&ttTable}.bm-codigo:SCREEN-VALUE IN FRAME fPage1 = string(tt_bem_pat_consulta_api.tta_num_bem_pat)
                {&ttTable}.bm-indice:SCREEN-VALUE IN FRAME fPage1 = string(tt_bem_pat_consulta_api.tta_num_seq_bem_pat)
                fi-cta-patrimonial:SCREEN-VALUE IN FRAME fPage1   = STRING(tt_bem_pat_consulta_api.tta_cod_cta_pat).
      END.
   END.
END. /*** IF v_rec_bem_pat <> ? THEN ***/


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFocoInicial wMaintenanceNoNavigation 
PROCEDURE piFocoInicial :
/*------------------------------------------------------------------------------
  Purpose:     piFocoInicial
  Parameters:  <none>
  Notes:       Coloca cursor no primeiro campo da tela habilitado
------------------------------------------------------------------------------*/

if pcAction = "ADD":U  or
   pcAction = "COPY":U then
    apply "ENTRY":U to ttEqpto.ep-codigo in frame fPage0.
else 
    apply "ENTRY":U to ttEqpto.idi-tip-eqpto in frame fPage1.
    
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenanceNoNavigation 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOTable} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSituacao wMaintenanceNoNavigation 
PROCEDURE piSituacao :
/*------------------------------------------------------------------------------
  Purpose:     piSituacao
  Parameters:  <none>
  Notes:       Leave do campo Situa�ﾆo Equipamento
------------------------------------------------------------------------------*/

run buscaSituacao in {&hDBOTable} (input  ttEqpto.cod-sit-eqpto:screen-value in frame fPage1,
                                   output iSituacao).
case iSituacao:
    when 1 then do:   /** Ativo **/
        assign ttEqpto.dat-situacao = ?
               ttEqpto.dat-situacao:sensitive in frame fPage1 = NO
               fi-hra-situacao:SENSITIVE      IN FRAME fPage1 = NO
               fi-hra-situacao:SCREEN-VALUE   IN FRAME fPage1 = "".
        disp ttEqpto.dat-situacao
            with frame fPage1.        
    end.
    otherwise do:     /** Inativo ou nﾆo encontrado **/
        IF ttEqpto.dat-situacao = ? THEN 
            assign ttEqpto.dat-situacao = today.
        ASSIGN ttEqpto.dat-situacao:sensitive in FRAME fPage1 = YES
               fi-hra-situacao:SENSITIVE      IN FRAME fPage1 = YES.
        DISPLAY ttEqpto.dat-situacao with frame fPage1.
        IF SUBSTRING({&ttTable}.cod-livre-1,19,24) <> "" THEN DO:
            ASSIGN fi-hra-situacao:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING({&ttTable}.cod-livre-1,19,24).
        END.
        ELSE DO:
            ASSIGN fi-hra-situacao:SCREEN-VALUE IN FRAME fPage1 = REPLACE(string(TIME,"HH:MM:SS"),":","").
        END.
    end.
end case.
        
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaContSec wMaintenanceNoNavigation 
PROCEDURE piVerificaContSec :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o modelo do equipamento controla secundrio     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lLogContSec AS LOGICAL NO-UNDO.

    IF  TRIM(ttEqpto.cod-model:SCREEN-VALUE IN FRAME fPage1) <> "" THEN DO:
        RUN gotokey       IN hDBOModelo (INPUT ttEqpto.cod-model:SCREEN-VALUE IN FRAME fPage1).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField  IN hDBOModelo (INPUT "cod-livre-1":U,
                                             OUTPUT cUnModelSec).
            RUN getLogField   IN hDBOModelo (INPUT "log-cont-sec":U,
                                             OUTPUT lLogContSec).
            ASSIGN ttEqpto.log-cont-sec:SENSITIVE IN FRAME fPage2 = lLogContSec
                   fiUnModelSec:SCREEN-VALUE      IN FRAME fPage2 = SUBSTRIN(cUnModelSec,1,2).
            IF  pcAction = "ADD":U THEN
                ASSIGN ttEqpto.log-cont-sec:CHECKED   IN FRAME fPage2 = lLogContSec.

            APPLY "VALUE-CHANGED":U TO ttEqpto.log-cont-sec IN FRAME fPage2.
        END.
        ELSE
            ASSIGN ttEqpto.val-hodom-horim-sec:SENSITIVE IN FRAME fPage2 = NO
                   fiUnModelSec:SCREEN-VALUE             IN FRAME fPage2 = ""
                   ttEqpto.val-km-sec:SENSITIVE          IN FRAME fPage2 = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaPartesEqpto wMaintenanceNoNavigation 
PROCEDURE piVerificaPartesEqpto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    {method/showmessage.i1}
    empty temp-table RowErrors.

    if  pcAction = "Update" then do:
        define variable iSituacao              as integer     no-undo.
        define variable iSituacaoAux           as integer     no-undo.
        define variable cDesValor              as character   no-undo.
        define variable cCodSitAnt             as character   no-undo.

        define variable c-cod-servico-pneu     as character   no-undo.
        define variable c-cd-causa-pneu        as character   no-undo.
        define variable c-cod-situacao-pneu    as character   no-undo.
        define variable c-cd-causa-compon      as character   no-undo.
        define variable c-cod-situacao-compon  as character   no-undo.
        define variable l-entra-media          as logical     no-undo.

        assign cDesValor = "".
        run goToKey in hDBOParam (input 47).
        if  return-value = "OK":U then do:
            run getCharField in hDBOParam (input "des-valor":U,
                                           output cDesValor).
        end.

        /** Busca registro do equipamento para obter a situacao anterior **/
        for first mab-eqpto
            where mab-eqpto.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN ttEqpto.ep-codigo:screen-value in frame fPage0 &else int(ttEqpto.ep-codigo:screen-value in frame fPage0) &ENDIF
            and   mab-eqpto.cod-eqpto = ttEqpto.cod-eqpto:screen-value  in frame fPage0 no-lock:
        end.

        /** Busca situacao anterior **/
        run buscaSituacao in {&hDBOTable} (input  if avail mab-eqpto then mab-eqpto.cod-sit-eqpto else "",
                                           output iSituacaoAux).

        /** Busca situacao nova **/
        run buscaSituacao in {&hDBOTable} (input  ttEqpto.cod-sit-eqpto:screen-value in frame fPage1,
                                           output iSituacao).

        /* quando o equipamento est inativo e o usurio deseja ativar o mesmo ir mostrar mensagem de alerta */
      
        if  iSituacaoAux = 2 and iSituacao = 1 then do:
        

            /** Movimentos de Pneus **/
            for each mpn-pneu
                where mpn-pneu.ep-codigo-atual = ttEqpto.ep-codigo
                and   mpn-pneu.cod-eqpto-atual = ttEqpto.cod-eqpto no-lock:
                for last mpn-movto-pneu
                    where mpn-movto-pneu.cod-pneu = mpn-pneu.cod-pneu no-lock use-index mpnmvtpn-03:
                    run goToKey in hDBOMovtoPneu (input mpn-movto-pneu.num-docto).
                    if return-value = "OK":U then do:
                        run deleteRecord in hDBOMovtoPneu.
                        if return-value = "NOK":U then do:
                            run getRowErrors in hDBOMovtoPneu (output table RowErrors).
                            /** Ignora erro progress de query posicionada no ultimo registro **/
                            for first RowErrors
                                where RowErrors.ErrorNumber = 10
                                and   RowErrors.ErrorType   = "INTERNAL":U exclusive-lock:
                                delete RowErrors.
                            end.
                            if can-find(RowErrors where RowErrors.ErrorSubType = "ERROR":U) then do:
                                {method/showmessage.i2 &Modal=YES}
                            end.
                            run emptyRowErrors in hDBOMovtoPneu.
                        end.
                    end.
                end.
            end.
            /** Movimentos de Componentes **/
           for each mco-compon
                where mco-compon.ep-codigo-atual = ttEqpto.ep-codigo
                and   mco-compon.cod-eqpto-atual = ttEqpto.cod-eqpto no-lock:
                for last mco-movto-compon
                    where mco-movto-compon.cod-compon = mco-compon.cod-compon no-lock by mco-movto-compon.dat-movto:
                    run goToKey in hDBOMovtoCompon (input mco-movto-compon.num-docto).
                    if return-value = "OK":U then do:
                        run deleteRecord in hDBOMovtoCompon.
                        if return-value = "NOK":U then do:
                            run getRowErrors in hDBOMovtoCompon (output table RowErrors).
                            /** Ignora erro progress de query posicionada no ultimo registro **/
                            for first RowErrors
                                where RowErrors.ErrorNumber = 10
                                and   RowErrors.ErrorType   = "INTERNAL":U exclusive-lock:
                                delete RowErrors.
                            end.
                            if can-find(RowErrors where RowErrors.ErrorSubType = "ERROR":U) then do:
                                {method/showmessage.i2 &Modal=YES}
                            end.
                            run emptyRowErrors in hDBOMovtoCompon.
                        end.
                    end.
                end.
            end.

            run verificaComponentes IN {&hDBOTable} (input ttEqpto.ep-codigo:screen-value in frame fPage0,
                                                     input ttEqpto.cod-eqpto:screen-value in frame fPage0,
                                                     input "",
                                                     input "",
                                                     input "",
                                                     input "",
                                                     input "",
                                                     input no,
                                                     input no).

            /*if  return-value = "OK":U then
                run utp/ut-msgs.p (input "SHOW":U,
                                   input 27979,
                                   input "Os Componentes/Pneus deste Equipamento devem ser Manutenidos! ~~ Os Componentes/Pneus deste Equipamento devem ser Manutenidos, pois os mesmos estﾆo inativos":U).*/
        end.

        if  int(cDesValor) = 1 then do:

            run buscaSituacao in {&hDBOTable} (input  ttEqpto.cod-sit-eqpto:screen-value in frame fPage1,
                                               output iSituacao).
          
            if  iSituacao = 2 then do:
                /** Busca existencia de pneus ou componentes instalados no equipamento **/
                if can-find(first mpn-pneu
                            where mpn-pneu.ep-codigo-atual = ttEqpto.ep-codigo
                            and   mpn-pneu.cod-eqpto-atual = ttEqpto.cod-eqpto)
                   or can-find(first mco-compon
                               where mco-compon.ep-codigo-atual = ttEqpto.ep-codigo
                               and   mco-compon.cod-eqpto-atual = ttEqpto.cod-eqpto) then do:

                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Deseja_realizar_a_inativa�ﾆo_dos_componentes_e_pneus_do_Equipamento?" *}
                    run utp/ut-msgs.p (input "SHOW":U,
                                       input 27100,
                                       input RETURN-VALUE).

                    if  return-value = "YES":U then do:
                        /** Chama tela de inativa�ﾆo de pneus e componentes **/
                        assign {&window-name}:sensitive = no.
                        run abp/ab0138t.w (input ttEqpto.ep-codigo,
                                           input ttEqpto.cod-eqpto,
                                           input ttEqpto.dat-situacao,
                                           input replace(fi-hra-situacao:screen-value in frame fPage1,":",""),
                                           output c-cod-servico-pneu,
                                           output c-cd-causa-pneu,
                                           output c-cod-situacao-pneu,
                                           output c-cd-causa-compon,
                                           output c-cod-situacao-compon,
                                           output l-entra-media).
                        assign {&window-name}:sensitive = yes.

                        if return-value = "OK":U then do:
                            run verificaComponentes in {&hDBOTable} (input ttEqpto.ep-codigo:screen-value in frame fPage0,
                                                                     input ttEqpto.cod-eqpto:screen-value in frame fPage0,
                                                                     input c-cod-servico-pneu,
                                                                     input c-cd-causa-pneu,
                                                                     input c-cod-situacao-pneu,
                                                                     input c-cd-causa-compon,
                                                                     input c-cod-situacao-compon,
                                                                     input l-entra-media,
                                                                     input yes).
                            return "OK":U.
                        end.
                        else do:
                            return "NOK":U.
                        end.
                    end.
                    else do:
                        return "NOK":U. /** return da mensagem **/
                    end.
                end.
                else do:
                    return "OK":U. /** return do if can-find **/
                end.
            end.
            else do:
             
                return "OK":U.
            end.
            
        end.
    end.


    {method/showmessage.i3}

    return "OK":U.
   

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

