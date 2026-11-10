&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
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
{include/i-prgvrs.i IM0055DC 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0055dc MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0055DC
&GLOBAL-DEFINE Version        2.00.00.023
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FramesHandle      STRING(FRAME fPage1:HANDLE)

&GLOBAL-DEFINE FolderLabels      Despesas

&GLOBAL-DEFINE ttTable           tt-desp-embarque
&GLOBAL-DEFINE hDBOTable         h-bocx310
&GLOBAL-DEFINE DBOTable          desp-embarque

&GLOBAL-DEFINE ttParent          tt-historico-embarque
&GLOBAL-DEFINE hDBOParent        h-bocx230
&GLOBAL-DEFINE DBOParentTable    historico-embarque

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields  tt-historico-embarque.cod-estabel ~
                                  cDescEst ~
                                  tt-historico-embarque.embarque ~
                                  tt-historico-embarque.cod-itiner ~
                                  cDescItiner ~
                                  tt-historico-embarque.cod-pto-contr ~
                                  cDescPto

&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* New Shared Variable Definitions ---                                       */
def new shared var c-acao as char  no-undo.
def new shared var r-row  as rowid no-undo.
def new shared var r-row-hist as rowid no-undo.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
def var cDescricao like desp-imp.descricao  no-undo.
def var cNome      like emitente.nome-abrev no-undo.
def var cMoeda     like moeda.descricao     no-undo.
&IF DEFINED(bf_mat_versao_ems) &THEN
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        def var i-pto-desembarque as int            no-undo.
        def var i-seq-nacional    as int            no-undo.
    &ENDIF
&ENDIF
DEFINE VARIABLE h-bocx406    AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-integra-di AS LOGICAL     NO-UNDO.
def var h-bocx010            as handle         no-undo.
def var h-bocx110            as handle         no-undo.
def var h-boad098            as handle         no-undo.
def var h-boun005            as handle         no-undo.
def var h-bocx095            as handle         no-undo.
def var h-bocx115            as handle         no-undo.
def var h-boad107            as handle         no-undo.
DEF VAR h-bocx250            AS HANDLE         NO-UNDO.
DEF VAR h-bocx225e           AS HANDLE         NO-UNDO.
DEF VAR h-bocx407            AS HANDLE         NO-UNDO.
DEF VAR h-cdapi050           AS HANDLE         NO-UNDO.
DEF VAR l-st-zera-taxa       AS LOG            NO-UNDO.
DEF VAR l-tax-siscomex       AS LOG            NO-UNDO.
DEF VAR c-erro               AS CHAR           NO-UNDO.
DEF VAR c-tax-siscomex       AS CHAR           NO-UNDO.
DEF VAR i-desp-siscomex      AS INT            NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-desp-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-desp-embarque.cod-emitente-desp fnNomeAbrev(tt-desp-embarque.cod-emitente-desp) @ cNome tt-desp-embarque.cod-desp fnDescricao(tt-desp-embarque.cod-desp) @ cDescricao tt-desp-embarque.cod-cond-pag "{&bf_mat_versao_ems}" > "2.042" &then ">>>9":U &else ">>9":U &endif tt-desp-embarque.mo-codigo fnMoeda(tt-desp-embarque.mo-codigo) @ cMoeda tt-desp-embarque.val-desp &IF DEFINED(bf_mat_versao_ems) &THEN &IF "{&bf_mat_versao_ems}" >= "2.04" AND "{&bf_mat_versao_ems}" <= "2.05" &THEN tt-desp-embarque.log-1 &ELSEIF "{&bf_mat_versao_ems}" > "2.05" &THEN tt-desp-embarque.log-despes-ja-recbda &ENDIF &ENDIF fnIntegrDi(tt-desp-embarque.cod-desp) @ l-integra-di   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-desp-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-desp-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-desp-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner ~
tt-historico-embarque.cod-pto-contr 
&Scoped-define ENABLED-TABLES tt-historico-embarque
&Scoped-define FIRST-ENABLED-TABLE tt-historico-embarque
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar cDescEst cDescItiner ~
cDescPto btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner ~
tt-historico-embarque.cod-pto-contr 
&Scoped-define DISPLAYED-TABLES tt-historico-embarque
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-embarque
&Scoped-Define DISPLAYED-OBJECTS cDescEst cDescItiner cDescPto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMaintenanceNoNavigation 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-decl as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIntegrDi wMaintenanceNoNavigation 
FUNCTION fnIntegrDi RETURNS LOGICAL
  ( pCodDesp AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMaintenanceNoNavigation 
FUNCTION fnMoeda RETURNS CHARACTER
  (input pmo-codigo as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMaintenanceNoNavigation 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  (input pcod-emitente-desp as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cDescEst AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE cDescItiner AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .88 NO-UNDO.

DEFINE VARIABLE cDescPto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.54
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btMod 
     LABEL "Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-desp-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenanceNoNavigation _FREEFORM
  QUERY brSon1 DISPLAY
      tt-desp-embarque.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnNomeAbrev(tt-desp-embarque.cod-emitente-desp) @ cNome COLUMN-LABEL "Nome Abrev" FORMAT "x(12)":U
      tt-desp-embarque.cod-desp FORMAT ">>,>>9":U
      fnDescricao(tt-desp-embarque.cod-desp) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
      tt-desp-embarque.cod-cond-pag FORMAT &if "{&bf_mat_versao_ems}" > "2.042" &then ">>>9":U &else ">>9":U &endif
      tt-desp-embarque.mo-codigo FORMAT ">9":U
      fnMoeda(tt-desp-embarque.mo-codigo) @ cMoeda COLUMN-LABEL "Descri‡Æo" FORMAT "x(12)":U
      tt-desp-embarque.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
      &IF DEFINED(bf_mat_versao_ems) &THEN
          &IF "{&bf_mat_versao_ems}" >= "2.04" AND "{&bf_mat_versao_ems}" <= "2.05" &THEN
              tt-desp-embarque.log-1 COLUMN-LABEL "Recebida?"
          &ELSEIF "{&bf_mat_versao_ems}" > "2.05" &THEN
              tt-desp-embarque.log-despes-ja-recbda COLUMN-LABEL "Recebida?"
          &ENDIF
      &ENDIF
      fnIntegrDi(tt-desp-embarque.cod-desp) @ l-integra-di COLUMN-LABEL "Integrou DI" WIDTH 20 FORMAT "Sim/NÆo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.72 BY 4.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-historico-embarque.cod-estabel AT ROW 1.21 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescEst AT ROW 1.21 COL 36.29 COLON-ALIGNED NO-LABEL
     tt-historico-embarque.embarque AT ROW 2.21 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-historico-embarque.cod-itiner AT ROW 3.21 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     cDescItiner AT ROW 3.21 COL 37.86 COLON-ALIGNED NO-LABEL
     tt-historico-embarque.cod-pto-contr AT ROW 4.21 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     cDescPto AT ROW 4.21 COL 37.86 COLON-ALIGNED NO-LABEL
     btSave AT ROW 13.5 COL 12.86
     btOK AT ROW 13.54 COL 2
     btCancel AT ROW 13.54 COL 13
     btHelp AT ROW 13.54 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 13.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.21 COL 1.57
     btAddSon1 AT ROW 5.46 COL 1.57
     btMod AT ROW 5.46 COL 11.57
     btDeleteSon1 AT ROW 5.46 COL 21.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.72 ROW 7.17
         SIZE 87.57 BY 5.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
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
         HEIGHT             = 14.08
         WIDTH              = 90
         MAX-HEIGHT         = 39.5
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.5
         VIRTUAL-WIDTH      = 182.86
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenanceNoNavigation
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fPage1
DO:
  RUN pi-valida-integracao-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
  apply "choose":u to btMod in frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMaintenanceNoNavigation
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
 def var rPai as rowid no-undo.
 def var rFilho as rowid no-undo.
 assign rPai = prParent
        rFilho = ?
        c-acao = "ADD":u
         r-row-hist = tt-historico-embarque.r-rowid.
         
 RUN imp/im0055dd.w (input rPai, input THIS-PROCEDURE, input 1).
 APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMaintenanceNoNavigation
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    def var r-desp-emb as rowid no-undo.
    
    if  avail tt-desp-embarque then do:
        assign r-desp-emb = tt-desp-embarque.r-rowid.
        
       &IF DEFINED(bf_mat_versao_ems) &THEN
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
         &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
          IF tt-desp-embarque.log-forma-preco-compra THEN DO:
         &ELSE
          IF SUBSTRING(tt-desp-embarque.char-1,4,1) = "1" THEN DO:
         &ENDIF
        &ENDIF
             CREATE RowErrors.
             ASSIGN RowErrors.errorsubtype = "Question".
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31454,
                                INPUT "").
             
             IF  RETURN-VALUE = "NO" THEN DO:
                 SESSION:SET-WAIT-STATE("":U).
                 RETURN NO-APPLY.
             END.
             ELSE DO:
                 ASSIGN l-st-zera-taxa = NO.
                 IF  l-tax-siscomex AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
                     RUN utp/ut-msgs.p (INPUT "show":U,
                                        INPUT 33679,
                                        INPUT "").
                     IF  RETURN-VALUE = "NO" THEN
                         RETURN NO-APPLY.
                     
                     ASSIGN l-st-zera-taxa = YES.
                 END.
                 
                 RUN validateDelete in {&hDBOTable} (input-output r-desp-emb, 
                                                     output table rowErrors).
                 if  can-find(first rowErrors) then do:
                     IF  NOT VALID-HANDLE(hShowMsg) THEN
                         RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                     
                     RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
                 end.
                 else do:
                     IF l-st-zera-taxa THEN
                        RUN pi-zerar-taxa-siscomex IN h-bocx225e (INPUT tt-historico-embarque.cod-estabel,
                                                                  INPUT tt-historico-embarque.embarque).

                     
                     RUN pi-siscoserv-ativo IN h-cdapi050.
                     IF RETURN-VALUE = "OK":U THEN
                         RUN pi-apaga-despes-import-sis IN h-cdapi050 ( INPUT  tt-desp-embarque.cod-estabel,
                                                                        INPUT  tt-desp-embarque.embarque,
                                                                        INPUT  tt-desp-embarque.cod-itiner,
                                                                        INPUT  tt-desp-embarque.cod-pto-contr,
                                                                        INPUT  tt-desp-embarque.cod-desp,
                                                                        INPUT  tt-desp-embarque.cod-emitente-desp).

                     delete tt-desp-embarque.
                     browse brSon1:DELETE-CURRENT-ROW().
                     CREATE RowErrors.
                     ASSIGN RowErrors.errorsubtype = "WARNING".
                     RUN utp/ut-msgs.p (INPUT "show":U,
                                        INPUT 31453,
                                        INPUT "").
                 end.  
             END.
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
        
         END.
         ELSE DO:

        &ENDIF
       &ENDIF
      
             &if "{&bf_mat_versao_ems}":U >= "2.06":U &then
              FIND FIRST item-doc-est-cex
                   WHERE item-doc-est-cex.cod-estabel  = tt-desp-embarque.cod-estabel
                     AND item-doc-est-cex.embarque  = tt-desp-embarque.embarque   
                     AND item-doc-est-cex.cod-desp  = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
             &else   
                 FIND FIRST item-doc-est-cex
                      WHERE TRIM(SUBSTR(item-doc-est-cex.char-1,13,3)) = tt-desp-embarque.cod-estabel
                        AND TRIM(SUBSTR(item-doc-est-cex.char-1,1,12)) = tt-desp-embarque.embarque   
                        AND item-doc-est-cex.cod-desp                  = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
             &endif 
             
             IF  AVAIL item-doc-est-cex THEN DO:
                 RUN utp/ut-msgs.p (input "Show":U, 
                                    input 33661, 
                                    input item-doc-est-cex.nro-docto    + "~~" + 
                                          item-doc-est-cex.serie-docto  + "~~" + 
                                          item-doc-est-cex.nat-operacao + "~~" + 
                                          STRING(item-doc-est-cex.cod-emitente)).
             END.
             ELSE DO:
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Despesa" *}
                 RUN utp/ut-msgs.p (input "Show":U, input 550, input RETURN-VALUE).
             END.
             if  return-value = "yes" then do:
                 
                 ASSIGN l-st-zera-taxa = NO.
                 IF  l-tax-siscomex AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
                     RUN utp/ut-msgs.p (INPUT "show":U,
                                        INPUT 33679,
                                        INPUT "").
                     IF  RETURN-VALUE = "NO" THEN
                         RETURN NO-APPLY.
                     
                     ASSIGN l-st-zera-taxa = YES.
                 END.
                 
                 RUN validateDelete in {&hDBOTable} (input-output r-desp-emb, 
                                                     output table rowErrors).
                 if  can-find(first rowErrors) then do:
                     IF NOT VALID-HANDLE(hShowMsg) THEN
                        RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                     
                     RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
                 end.
                 else do:
                     IF l-st-zera-taxa THEN
                        RUN pi-zerar-taxa-siscomex IN h-bocx225e (INPUT tt-historico-embarque.cod-estabel,
                                                                  INPUT tt-historico-embarque.embarque).
                     
                     RUN pi-siscoserv-ativo IN h-cdapi050.
                     IF RETURN-VALUE = "OK":U THEN
                         RUN pi-apaga-despes-import-sis IN h-cdapi050 ( INPUT  tt-desp-embarque.cod-estabel,
                                                                        INPUT  tt-desp-embarque.embarque,
                                                                        INPUT  tt-desp-embarque.cod-itiner,
                                                                        INPUT  tt-desp-embarque.cod-pto-contr,
                                                                        INPUT  tt-desp-embarque.cod-desp,
                                                                        INPUT  tt-desp-embarque.cod-emitente-desp).
                     delete tt-desp-embarque.
                     browse brSon1:DELETE-CURRENT-ROW().
                 end.  
             end.
       &IF DEFINED(bf_mat_versao_ems) &THEN
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
         END.
        &ENDIF
       &ENDIF
    end.
    
    find first tt-desp-embarque no-error.
    if   avail tt-desp-embarque then do:
         enable btMod btDeleteSon1 with frame fpage1.
         
         brson1:SELECT-FOCUSED-ROW().
   
    end.
    else do:
        disable btMod btDeleteSon1 with frame fpage1.
    end.
    APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMod wMaintenanceNoNavigation
ON CHOOSE OF btMod IN FRAME fPage1 /* Modificar */
DO:
 def var rPai as rowid no-undo.
 def var rFilho as rowid no-undo.
 assign rPai = prParent
        rFilho = ?
        r-row  = tt-desp-embarque.r-rowid
        r-row-hist = tt-historico-embarque.r-rowid
        c-acao = "UPDATE":U.
               
 RUN imp/im0055dd.w (input rPai, input THIS-PROCEDURE, input 1).
 APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
           APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad107"
      &FindMethod="findCodigo"
      &KeyValue1="tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome"
      &FieldScreen1="cDescEst"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-itiner wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque.cod-itiner IN FRAME fpage0 /* C¢digo Itiner rio */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-bocx115"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="cDescItiner"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-pto-contr wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-bocx110"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-historico-embarque.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="cDescPto"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
tt-historico-embarque.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
{maintenancenonavigation/mainblock.i}

ON VALUE-CHANGED OF brSon1
DO:
    RUN pi-valida-integracao-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE(h-bocx406) THEN DO:
        DELETE PROCEDURE h-bocx406.
        ASSIGN h-bocx406 = ?.
    END.

    IF VALID-HANDLE(h-bocx010) THEN DO:
        DELETE PROCEDURE h-bocx010.
        ASSIGN h-bocx010 = ?.
    END.

    IF VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF VALID-HANDLE(h-bocx115) THEN DO:
        DELETE PROCEDURE h-bocx115.
        ASSIGN h-bocx115 = ?.
    END.

    IF VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    IF  VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.
    
    IF  VALID-HANDLE(h-bocx225e) THEN DO:
        DELETE PROCEDURE h-bocx225e.
        ASSIGN h-bocx225e = ?.
    END.
    
    /*** Siscoserv ***/
    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   APPLY "LEAVE":U TO tt-historico-embarque.cod-estabel   IN FRAME fPage0.
   APPLY "LEAVE":U TO tt-historico-embarque.cod-itiner    IN FRAME fPage0. 
   APPLY "LEAVE":U TO tt-historico-embarque.cod-pto-contr IN FRAME fPage0.

   DEFINE VARIABLE r-historico-embarque as rowid NO-UNDO.
   DEF VAR iRowsReturned AS INTEGER NO-UNDO.
   &IF DEFINED(bf_mat_versao_ems) &THEN
       &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
           DEF VAR cReturn       AS CHAR    NO-UNDO.
       &ENDIF
   &ENDIF
   
   IF AVAILABLE tt-historico-embarque THEN
       ASSIGN r-historico-embarque = tt-historico-embarque.r-rowid.
   ELSE
       ASSIGN r-historico-embarque = ?.
   
   RUN setConstraint4 IN {&hDBOTable} (input r-historico-embarque).
        
        /*--- Abre query do DBO filho ---*/
   RUN openQuery IN {&hDBOTable} (INPUT 4).
        
        /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
   RUN findFirst IN {&hDBOTable}.
        
        /*--- Retorna faixa de registro do DBO Filho ---*/
   RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                       INPUT ?,
                                       INPUT NO,
                                       INPUT ?,
                                       OUTPUT iRowsReturned,
                                       OUTPUT TABLE tt-desp-embarque).
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

    &IF DEFINED(bf_mat_versao_ems) &THEN
        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
    
            /*Busca o ponto de nacionalizacao*/
            IF VALID-HANDLE(h-bocx115) THEN DO:
                RUN findCodigo IN h-bocx115 (INPUT tt-historico-embarque.cod-itiner,
                                             OUTPUT cReturn).
                IF cReturn = "" THEN
                    RUN getIntField IN h-bocx115 (INPUT "pto-desembarque", OUTPUT i-pto-desembarque).
            END.
        
            /*Busca a sequencia do ponto de nacionalizacao*/
            IF VALID-HANDLE(h-bocx230) THEN DO:
                RUN findCh-itiner IN h-bocx230 (INPUT tt-historico-embarque.cod-estabel,
                                                INPUT tt-historico-embarque.embarque,
                                                INPUT tt-historico-embarque.cod-itiner,
                                                INPUT i-pto-desembarque,
                                                OUTPUT cReturn).
                IF cReturn = "" THEN
                    RUN getIntField IN h-bocx230(INPUT "sequencia", OUTPUT i-seq-nacional).
            END.
        
            IF tt-historico-embarque.sequencia <= i-seq-nacional THEN
                &IF "{&bf_mat_versao_ems}" <= "2.05" &THEN
                    ASSIGN tt-desp-embarque.log-1:VISIBLE IN BROWSE brSon1 = FALSE.
                &ELSE
                    ASSIGN tt-desp-embarque.log-despes-ja-recbda:VISIBLE IN BROWSE brSon1 = FALSE.
                &ENDIF
                
        &ENDIF        
    &ENDIF
    
    IF  VALID-HANDLE(h-bocx250) THEN DO:
        RUN findCodigo IN h-bocx250 (INPUT tt-historico-embarque.cod-estabel, OUTPUT c-erro).
        
        IF  c-erro <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,INPUT 17567, INPUT c-erro).
        END.
        ELSE DO:
            &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
             RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex",
                                           OUTPUT l-tax-siscomex).
             RUN getIntField IN h-bocx250 (INPUT "cdn-despes-siscomex",
                                           OUTPUT i-desp-siscomex).
            &ELSE
             RUN getCharField IN h-bocx250 (INPUT "char-1",
                                            OUTPUT c-tax-siscomex).
             ASSIGN l-tax-siscomex  = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO
                    i-desp-siscomex = INT(SUBSTR(c-tax-siscomex, 91, 5)).
            &ENDIF
        END.
    END.
    
    APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST tt-desp-embarque NO-ERROR.
    IF   AVAIL tt-desp-embarque THEN DO:
         ENABLE btMod btDeleteSon1 WITH FRAME fpage1.
    END.
    ELSE DO:
         DISABLE btMod btDeleteSon1 WITH FRAME fpage1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo\bocx407.p PERSISTENT SET h-bocx407.

RUN pi-valida-inclusao-despesa-integr-di IN h-bocx407(INPUT tt-historico-embarque.embarque,
                                                      INPUT tt-historico-embarque.cod-estabel,
                                                      INPUT tt-historico-embarque.cod-pto-contr,
                                                      OUTPUT l-integra-di).
IF l-integra-di THEN
    DISABLE btAddSon1 WITH FRAME fPage1.
ELSE
    ENABLE btAddSon1 WITH FRAME fPage1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    IF {&hdbotable}:FILE-NAME <> "cxbo/bocx310.p" THEN
        ASSIGN  {&hDBOTable} = ?.
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN cxbo/bocx310.p persistent set h-bocx310.
       enable btAddSon1 btMod btDeleteSon1 brSon1 with frame fPage1.
       disable btSave with frame fPage0.
       hide btSave.
       assign btCancel:column = 13.
  
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        /*RUN openQueryStatic IN {&hDBOTable} (INPUT "CodPtoContr":U).*/
    &ENDIF
    
    RUN cxbo/bocx230.p persistent set h-bocx230.
    RUN cxbo/bocx110.p persistent set h-bocx110.
    RUN adbo/boad098.p persistent set h-boad098.
    RUN adbo/boad107.p persistent set h-boad107.
    RUN unbo/boun005.p persistent set h-boun005.
    RUN cxbo/bocx115.p persistent set h-bocx115.
    RUN cxbo/bocx095.p persistent set h-bocx095.
    RUN cxbo/bocx225e.p persistent set h-bocx225e.
    
    IF NOT VALID-HANDLE(h-cdapi050) THEN DO:
        RUN cdp/cdapi050.p PERSISTEN SET h-cdapi050.
    END.
    
    IF  NOT VALID-HANDLE(h-bocx250) OR
        h-bocx250:TYPE <> "PROCEDURE":U OR
        h-bocx250:FILE-NAME <> "cxbo/bocx250.p":U THEN DO:
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
        RUN openQuery IN h-bocx250 (INPUT "1":U).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-integracao-di wMaintenanceNoNavigation 
PROCEDURE pi-valida-integracao-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-l-integra AS LOGICAL INITIAL NO    NO-UNDO.

ASSIGN p-l-integra = fnIntegrDi(INPUT INPUT BROWSE brSon1 tt-desp-embarque.cod-desp).
    
IF p-l-integra THEN
    DISABLE btMod
            btDeleteSon1 WITH FRAME fPage1.
ELSE
    ENABLE btMod
           btDeleteSon1 WITH FRAME fPage1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenanceNoNavigation 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter rchave as rowid no-undo.
  def input parameter pNumber as integer no-undo.
  
  def var iRowsReturned as integer no-undo.
  

  if pNumber = 1 then do:
    RUN setConstraint4 IN {&hDBOTable} (input rchave).
         
         /*--- Abre query do DBO filho ---*/
    RUN openQuery IN {&hDBOTable} (INPUT 4).
         
         /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
    RUN findFirst IN {&hDBOTable}.
         
         /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                         INPUT ?,
                                         INPUT NO,
                                         INPUT ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE tt-desp-embarque).
     {&OPEN-QUERY-brSon1}
     APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
     find first tt-desp-embarque no-error.
     if   avail tt-desp-embarque then do:
          enable btMod btDeleteSon1 with frame fpage1.
     end.
     else do:
          disable btMod btDeleteSon1 with frame fpage1.
     end.

  end.
    
  APPLY "MOUSE-SELECT-CLICK":U TO brSon1                 IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMaintenanceNoNavigation 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-decl as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cReturn as char no-undo.
  RUN findCodigo in h-bocx095 (input pcod-decl, output cReturn).
  if  cReturn = "" then
      RUN getCharField in h-bocx095 (input "descricao", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIntegrDi wMaintenanceNoNavigation 
FUNCTION fnIntegrDi RETURNS LOGICAL
  ( pCodDesp AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(h-bocx406) THEN
      RUN cxbo/bocx406.p PERSISTENT SET h-bocx406.

  RUN validaIntegraDespDi IN h-bocx406 (INPUT INPUT FRAME fPage0 tt-historico-embarque.embarque,
                                        INPUT INPUT FRAME fPage0 tt-historico-embarque.cod-estabel,
                                        INPUT pCodDesp,
                                        OUTPUT l-integra-di).


  RETURN l-integra-di.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMaintenanceNoNavigation 
FUNCTION fnMoeda RETURNS CHARACTER
  (input pmo-codigo as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cReturn as char no-undo.
  RUN findCodigo in h-boun005 (input pmo-codigo, output cReturn).
  if  cReturn = "" then
      RUN getCharField in h-boun005 (input "descricao", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMaintenanceNoNavigation 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  (input pcod-emitente-desp as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-nomeab as char no-undo.
  def var cReturn as char no-undo.
  RUN findCodigo in h-boad098 (input pcod-emitente-desp, output cReturn).
  if  cReturn = "" then
      RUN getCharField in h-boad098 (input "nome-abrev", output c-nomeab).

  RETURN c-nomeab.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

