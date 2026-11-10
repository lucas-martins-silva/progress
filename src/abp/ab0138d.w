&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttHist NO-UNDO LIKE mab-histor-ativid
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
{include/i-prgvrs.i AB0138D 2.00.00.052 } /*** "010052" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138d MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i} /** l-usa-unid-negoc **/
{cdp/cd0031.i "MAB":U} /** Trigger on-fin da tabela estabelec **/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0138D
&GLOBAL-DEFINE Version        2.00.00.050

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttHist
&GLOBAL-DEFINE hDBOTable         hDBOAtividade
&GLOBAL-DEFINE DBOTable          mab-histor-ativid

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttHist.dat-cadastro
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttHist.cod-ativid ttHist.cod-estabel ~
                                 ttHist.cod-grp-eqpto ttHist.cd-tag ~
                                 c-cod-unid-negoc ttHist.cod-ccusto-alter  ~
                                 ttEqpto.cod-placa ttHist.cod-cidade ttHist.cod-estado ttHist.cod-pais ~
                                 fiCodContaLub fiCodCCustoLub

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cFConta AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFSub   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-habilita-un AS LOGICAL NO-UNDO.
/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo        AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtiv          AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOGrupo         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTag           AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOUnNegoc       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOUnidNegocHist AS HANDLE NO-UNDO.
define variable h-ab0138d1        as handle no-undo.
/*define variable h-bofr122         as handle no-undo. /** DBO mab-param-integr **/*/
define variable cAux              as char   no-undo.
/*define variable cParam            as char   no-undo. */
define variable cRetornoApi       as char   no-undo.
define variable cDesMsgApi        as char   no-undo.
define variable i-cont            as inte   no-undo.
define variable lMostraBem        as log    no-undo.
define variable l-integra         as log    no-undo.
define variable l-ems5            as log    no-undo.
DEFINE VARIABLE lGerouTransf      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-mgs-aux         AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-exibe-msg-implento AS LOGICAL NO-UNDO.
DEFINE VARIABLE cEmpAux LIKE ttHist.ep-codigo NO-UNDO.
DEFINE VARIABLE cEqptoAux LIKE ttHist.cod-eqpto NO-UNDO.
DEFINE VARIABLE cDatCadastroAux LIKE ttHist.dat-cadastro NO-UNDO.
DEFINE VARIABLE cCodEstabel LIKE ttHist.cod-estabel NO-UNDO.
DEFINE VARIABLE cCodUnidNegoc LIKE ttHist.cod-unid-negoc NO-UNDO.
define variable lBgcaux        as log    no-undo.
    
DEFINE BUFFER bfMgf-eqpto-implto FOR mgf-eqpto-implto.
DEFINE BUFFER bfMab-histor-ativid FOR mab-histor-ativid.

DEFINE TEMP-TABLE ttImptoAtualizados
    FIELD ep-codigo-implto LIKE mab-eqpto.ep-codigo
    FIELD cod-eqpto-implto LIKE mab-eqpto.cod-eqpto.

DEFINE TEMP-TABLE RowErrorsImpto NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

DEFINE BUFFER bf-mab-histor-ativid FOR mab-histor-ativid.
{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dCadEquipto   AS DATE        NO-UNDO.

/** Vari†veis Compartilhadas entre programas pais e filhos **/
define new global shared variable lAtividade as logical no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE  evento    AS CHAR NO-UNDO.

&if '{&mguni_version}' >= '2.06b' or '{&aplica_facelift}' = 'YES' &then
    def new global shared var h-facelift as handle no-undo.
&endif

{frbo/bofr013.i2 shared}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttHist.dat-cadastro 
&Scoped-define ENABLED-TABLES ttEqpto ttHist
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttHist
&Scoped-Define ENABLED-OBJECTS fiDescModelo btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttHist.dat-cadastro 
&Scoped-define DISPLAYED-TABLES ttEqpto ttHist
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttHist
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

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

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btBemPatri 
     IMAGE-UP FILE "image/im-emp.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-emp.bmp":U
     LABEL "" 
     SIZE 3.57 BY 1.17 TOOLTIP "Inclus∆o Bem Patrimonial".

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fiCodCCustoLub AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 TOOLTIP "C¢digo Centro Custo Lubrificaá∆o".

DEFINE VARIABLE fiCodConta AS CHARACTER FORMAT "X(20)" 
     LABEL "Conta":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiCodContaLub AS CHARACTER FORMAT "X(20)" 
     LABEL "Conta Lubrificaá∆o":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 TOOLTIP "C¢digo Conta Lubrificaá∆o".

DEFINE VARIABLE fiCodSub AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiDescAtividade AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEstab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescGrupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Emplacamento" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEqpto.ep-codigo AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 2.25 COL 43.57 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     ttHist.dat-cadastro AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btOK AT ROW 17.92 COL 2
     btSave AT ROW 17.92 COL 13
     btCancel AT ROW 17.92 COL 24
     btHelp AT ROW 17.92 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.21
         FONT 1.

DEFINE FRAME fPage1
     ttHist.cod-estabel AT ROW 1.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescEstab AT ROW 1.54 COL 27.57 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     ttHist.cod-grp-eqpto AT ROW 2.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescGrupo AT ROW 2.54 COL 28.14 COLON-ALIGNED NO-LABEL
     ttHist.cod-ativid AT ROW 3.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescAtividade AT ROW 3.54 COL 28.14 COLON-ALIGNED NO-LABEL
     fiCodConta AT ROW 4.54 COL 20 COLON-ALIGNED
     fiCodSub AT ROW 4.54 COL 40.14 COLON-ALIGNED NO-LABEL
     fiCodContaLub AT ROW 5.54 COL 20 COLON-ALIGNED WIDGET-ID 2
     fiCodCCustoLub AT ROW 5.54 COL 40.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     ttHist.cod-ccusto-alter AT ROW 6.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-cod-unid-negoc AT ROW 6.54 COL 53.86 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     ttHist.cd-tag AT ROW 7.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescTag AT ROW 7.54 COL 36.14 COLON-ALIGNED NO-LABEL
     ttEqpto.cod-placa AT ROW 9.46 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttHist.cod-cidade AT ROW 9.46 COL 45.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     btBemPatri AT ROW 10.33 COL 76
     ttHist.cod-estado AT ROW 10.46 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttHist.cod-pais AT ROW 10.46 COL 45.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiTexto1 AT ROW 8.71 COL 21.57 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 9 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 11.3
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
      TABLE: ttHist T "?" NO-UNDO mgfro mab-histor-ativid
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
         HEIGHT             = 18.21
         WIDTH              = 90
         MAX-HEIGHT         = 38.29
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.29
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
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttHist.dat-cadastro:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
   L-To-R                                                               */
ASSIGN 
       btBemPatri:HIDDEN IN FRAME fPage1           = TRUE.

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
ON RETURN OF wMaintenanceNoNavigation
DO:
  apply "CHOOSE":U to btOK in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  if lAtividade then return no-apply.
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenanceNoNavigation
ON RETURN OF FRAME fpage0
DO:
  apply "CHOOSE":U to btOK in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btBemPatri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBemPatri wMaintenanceNoNavigation
ON CHOOSE OF btBemPatri IN FRAME fPage1
DO:
    run pi-ab0138d.
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
        c-nom-prog-upc-mg97 <> ?  THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BOTAO-OK":U, 
                                        INPUT "BUTTON":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage0:HANDLE,
                                        INPUT "":U,
                                        INPUT ?).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN NO-APPLY.        
    END.

    IF INPUT FRAME fPage0 ttHist.dat-cadastro > TODAY THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2555,
                           INPUT "").
        RETURN "NOK":U.
    END.

    IF pcAction <> "UPDATE":U THEN
        ASSIGN cEmpAux         = {&ttParent}.ep-codigo
               cEqptoAux       = {&ttParent}.cod-eqpto
               cDatCadastroAux = DATE(ttHist.dat-cadastro:SCREEN-VALUE IN FRAME fPage0)
               cCodEstabel     = ttHist.cod-estabel:SCREEN-VALUE IN FRAME fPage1
               cCodUnidNegoc   = c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1.

        RUN saveRecord IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "OK":U THEN do:

            RUN piValidaImplementos IN THIS-PROCEDURE (INPUT cEmpAux,
                                                       INPUT cEqptoAux,
                                                       INPUT cDatCadastroAux,
                                                       INPUT cCodEstabel,
                                                       INPUT cCodUnidNegoc).

            IF  RETURN-VALUE = "OK":U THEN DO:
                assign lAtividade = no.
                APPLY "CLOSE":U TO THIS-PROCEDURE.
            END.
        end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF INPUT FRAME fPage0 ttHist.dat-cadastro > TODAY THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2555,
                           INPUT ""). 
        RETURN "NOK":U.
    END.

    IF pcAction <> "UPDATE":U THEN
        ASSIGN cEmpAux         = {&ttParent}.ep-codigo
               cEqptoAux       = {&ttParent}.cod-eqpto
               cDatCadastroAux = DATE(ttHist.dat-cadastro:SCREEN-VALUE IN FRAME fPage0)
               cCodEstabel     = ttHist.cod-estabel:SCREEN-VALUE IN FRAME fPage1
               cCodUnidNegoc   = c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1.


        RUN saveRecord IN THIS-PROCEDURE.

        IF RETURN-VALUE = "OK":U THEN do:

            RUN piValidaImplementos IN THIS-PROCEDURE (INPUT cEmpAux,
                                                       INPUT cEqptoAux,
                                                       INPUT cDatCadastroAux,
                                                       INPUT cCodEstabel,
                                                       INPUT cCodUnidNegoc).

            IF  RETURN-VALUE = "OK":U THEN DO:
                assign lAtividade = NO
                       btBemPatri:hidden in frame fPage1 = yes.
            END.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF c-cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:
    IF l-usa-unid-negoc THEN
        &IF DEFINED(bf_mnt_ems206b) &THEN
            {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                                 &FieldZoom1=cod-unid-negoc
                                 &FieldScreen1=c-cod-unid-negoc
                                 &Frame1=fPage1}
        &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cd-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cd-tag wMaintenanceNoNavigation
ON F5 OF ttHist.cd-tag IN FRAME fPage1 /* TAG */
DO:
        {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn152.w"
           &FieldZoom1="cd-tag"
           &FieldScreen1="ttHist.cd-tag"
           &Frame1="fPage1"
           &FieldZoom2="descricao"
           &FieldScreen2="fiDescTag"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cd-tag wMaintenanceNoNavigation
ON LEAVE OF ttHist.cd-tag IN FRAME fPage1 /* TAG */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOTag"
        &KeyValue1="ttHist.cd-tag:screen-value in frame fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fiDescTag"
        &Frame1="fPage1"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cd-tag wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cd-tag IN FRAME fPage1 /* TAG */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ativid wMaintenanceNoNavigation
ON F5 OF ttHist.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr001.w"
           &FieldZoom1="cod-ativid"
           &FieldScreen1="ttHist.cod-ativid"
           &Frame1="fPage1"
           &FieldZoom2="des-ativid"
           &FieldScreen2="fiDescAtividade"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ativid wMaintenanceNoNavigation
ON LEAVE OF ttHist.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOAtiv"
        &KeyValue1="ttHist.cod-ativid:screen-value in frame fPage1"
        &FieldName1="des-ativid"
        &FieldScreen1="fiDescAtividade"
        &Frame1="fPage1"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ativid wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-ccusto-alter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ccusto-alter wMaintenanceNoNavigation
ON ENTRY OF ttHist.cod-ccusto-alter IN FRAME fPage1 /* CC Manutená∆o */
DO:
   ASSIGN ttHist.cod-ccusto-alter:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ccusto-alter wMaintenanceNoNavigation
ON LEAVE OF ttHist.cod-ccusto-alter IN FRAME fPage1 /* CC Manutená∆o */
DO:
  IF ttHist.cod-ccusto-alter:SCREEN-VALUE <> "" THEN
        ASSIGN ttHist.cod-ccusto-alter:FORMAT IN FRAME fPage1 = p_cod_format_ccusto NO-ERROR.

/*  {cdp/cdunif001a.i  fiCodConta ttHist.cod-ccusto-alter fPage1 dCadEquipto cEmpresaEstab """" }*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-ccusto-alter wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-ccusto-alter IN FRAME fPage1 /* CC Manutená∆o */
OR "F5":U OF {&ttTable}.cod-ccusto-alter IN FRAME fPage1 DO:

    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE "" NO-ERROR.

    RUN piRetornaData (OUTPUT dCadEquipto).

    RUN pi_zoom_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,       /* EMPRESA EMS2 */
                                        INPUT "",                  /* CODIGO DO PLANO CCUSTO */
                                        INPUT "",                  /* UNIDADE DE NEGOCIO */
                                        INPUT dCadEquipto,         /* DATA DE TRANSACAO */
                                        OUTPUT v_cod_ccusto,       /* CODIGO CCUSTO */
                                        OUTPUT v_des_ccusto,       /* DESCRICAO CCUSTO */
                                        OUTPUT TABLE tt_log_erro). /* ERROS */

    ASSIGN ttHist.cod-ccusto-alter:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto NO-ERROR.

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/

    
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-cidade wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-cidade IN FRAME fPage1 /* Cidade */
OR F5 OF {&ttTable}.cod-cidade IN FRAME fPage1 DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                                 &FieldZoom1="cidade"
                                 &FieldScreen1="{&ttTable}.cod-cidade"
                                 &Frame1="fPage1"
                                 &FieldZoom2="estado"
                                 &FieldScreen2="{&ttTable}.cod-estado"
                                 &Frame2="fPage1"
                                 &FieldZoom3="pais"
                                 &FieldScreen3="{&ttTable}.cod-pais"
                                 &Frame3="fPage1"
                                 &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="ttEqpto.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttHist.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-estabel wMaintenanceNoNavigation
ON F5 OF ttHist.cod-estabel IN FRAME fPage1 /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=ttHist.cod-estabel
                     &campozoom=cod-estabel
                     &frame=fPage1
                     &campo2=fiDescEstab
                     &campozoom2=nome
                     &frame2=fPage1}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF ttHist.cod-estabel IN FRAME fPage1 /* Estabelecimento */
DO:
    /** Busca Descriá∆o do estabelecimento **/
    assign fiDescEstab:screen-value in frame fPage1 = "".
    for first estabelec fields(nome)
        where estabelec.cod-estabel = ttHist.cod-estabel:screen-value in frame fPage1 no-lock:
        assign fiDescEstab:screen-value in frame fPage1 = estabelec.nome.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-estabel IN FRAME fPage1 /* Estabelecimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-estado wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-estado IN FRAME fPage1 /* UF */
OR F5 OF {&ttTable}.cod-estado IN FRAME fPage1 DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                                 &FieldZoom1="cidade"
                                 &FieldScreen1="{&ttTable}.cod-cidade"
                                 &Frame1="fPage1"
                                 &FieldZoom2="estado"
                                 &FieldScreen2="{&ttTable}.cod-estado"
                                 &Frame2="fPage1"
                                 &FieldZoom3="pais"
                                 &FieldScreen3="{&ttTable}.cod-pais"
                                 &Frame3="fPage1"
                                 &EnableImplant="YES"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-grp-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-grp-eqpto wMaintenanceNoNavigation
ON F5 OF ttHist.cod-grp-eqpto IN FRAME fPage1 /* Grupo Equipamento */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr011.w"
           &FieldZoom1="cod-grp-eqpto"
           &FieldScreen1="ttHist.cod-grp-eqpto"
           &Frame1="fPage1"
           &FieldZoom2="des-grp-eqpto"
           &FieldScreen2="fiDescGrupo"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-grp-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttHist.cod-grp-eqpto IN FRAME fPage1 /* Grupo Equipamento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOGrupo"
        &KeyValue1="ttHist.cod-grp-eqpto:screen-value in frame fPage1"
        &FieldName1="des-grp-eqpto"
        &FieldScreen1="fiDescGrupo"
        &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-grp-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-grp-eqpto IN FRAME fPage1 /* Grupo Equipamento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttHist.cod-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttHist.cod-pais wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttHist.cod-pais IN FRAME fPage1 /* Pa°s */
OR F5 OF {&ttTable}.cod-pais IN FRAME fPage1 DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                                 &FieldZoom1="cidade"
                                 &FieldScreen1="{&ttTable}.cod-cidade"
                                 &Frame1="fPage1"
                                 &FieldZoom2="estado"
                                 &FieldScreen2="{&ttTable}.cod-estado"
                                 &Frame2="fPage1"
                                 &FieldZoom3="pais"
                                 &FieldScreen3="{&ttTable}.cod-pais"
                                 &Frame3="fPage1"
                                 &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodCCustoLub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodCCustoLub wMaintenanceNoNavigation
ON ENTRY OF fiCodCCustoLub IN FRAME fPage1
DO:
    ASSIGN fiCodCCustoLub:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodCCustoLub wMaintenanceNoNavigation
ON F5 OF fiCodCCustoLub IN FRAME fPage1
DO:
    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE ""
           v_cod_cta_ctbl = INPUT FRAME fPage1 fiCodContaLub NO-ERROR.

    RUN piRetornaData (OUTPUT dCadEquipto).

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dCadEquipto,           /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    IF v_cod_ccusto <> "" THEN
        ASSIGN fiCodCCustoLub:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto NO-ERROR.

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
   
    
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodCCustoLub wMaintenanceNoNavigation
ON LEAVE OF fiCodCCustoLub IN FRAME fPage1
DO:
    IF (c-nom-prog-upc-mg97 <> "" and
        c-nom-prog-upc-mg97 <> ? ) THEN DO:
        /*chamada upc*/
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "LEAVE-SUBCONTA-LUBRIFIC",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage1:HANDLE,
                                        INPUT "",
                                        INPUT ?).
    END.

    IF fiCodCCustoLub:SCREEN-VALUE <> "" THEN
        ASSIGN fiCodCCustoLub:FORMAT IN FRAME fPage1 = p_cod_format_ccusto NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodCCustoLub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiCodCCustoLub IN FRAME fPage1
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodConta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodConta wMaintenanceNoNavigation
ON ENTRY OF fiCodConta IN FRAME fPage1 /* Conta */
DO:
    ASSIGN fiCodConta:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodConta wMaintenanceNoNavigation
ON F5 OF fiCodConta IN FRAME fPage1 /* Conta */
DO: 

    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE "".

    RUN piRetornaData (OUTPUT dCadEquipto).

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dCadEquipto,         /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fiCodConta:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl NO-ERROR .

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
  

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodConta wMaintenanceNoNavigation
ON LEAVE OF fiCodConta IN FRAME fPage1 /* Conta */
DO:
    IF (c-nom-prog-upc-mg97 <> "" and
        c-nom-prog-upc-mg97 <> ? ) THEN DO:

        /*chamada upc*/
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "LEAVE-CONTA",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage1:HANDLE,
                                        INPUT "",
                                        INPUT ?).
    END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE "".

    RUN piRetornaData (OUTPUT dCadEquipto).

    {cdp/cdunif001a.i  fiCodConta fiCodSub fPage1 dCadEquipto cEmpresaEstab ttHist.cod-estabel:SCREEN-VALUE }

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
    {cdp/cdunif001b.i}             
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.

    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF mab-param.des-valor = "1":U THEN DO:
            IF pcAction = "ADD":U THEN
                ASSIGN fiCodContaLub:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 fiCodConta.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodConta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiCodConta IN FRAME fPage1 /* Conta */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodContaLub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodContaLub wMaintenanceNoNavigation
ON ENTRY OF fiCodContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
    ASSIGN fiCodContaLub:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodContaLub wMaintenanceNoNavigation
ON F5 OF fiCodContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO: 

    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE "".

    RUN piRetornaData (OUTPUT dCadEquipto).

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dCadEquipto,         /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fiCodContaLub:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl NO-ERROR .

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
  

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodContaLub wMaintenanceNoNavigation
ON LEAVE OF fiCodContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
    IF (c-nom-prog-upc-mg97 <> "" and
        c-nom-prog-upc-mg97 <> ? ) THEN DO:

        /*chamada upc*/
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "LEAVE-CONTA-LUBRIFIC",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage1:HANDLE,
                                        INPUT "",
                                        INPUT ?).
    END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE "".

    RUN piRetornaData (OUTPUT dCadEquipto).

    {cdp/cdunif001a.i  fiCodContaLub fiCodCCustoLub fPage1 dCadEquipto cEmpresaEstab ttHist.cod-estabel:SCREEN-VALUE }

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
    {cdp/cdunif001b.i}             
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodContaLub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiCodContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodSub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodSub wMaintenanceNoNavigation
ON ENTRY OF fiCodSub IN FRAME fPage1
DO:
  ASSIGN fiCodSub:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodSub wMaintenanceNoNavigation
ON F5 OF fiCodSub IN FRAME fPage1
DO:
    FOR FIRST estabelec WHERE estabelec.cod-estabel = ttHist.cod-estabel:SCREEN-VALUE NO-LOCK: END.

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN cEmpresaEstab = IF AVAIL (estabelec) THEN estabelec.ep-codigo ELSE ""
           v_cod_cta_ctbl = INPUT FRAME fPage1 fiCodConta NO-ERROR.

    RUN piRetornaData (OUTPUT dCadEquipto).

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dCadEquipto,           /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    IF v_cod_ccusto <> "" THEN
        ASSIGN fiCodSub:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto NO-ERROR.

    IF {&ttTable}.cod-ccusto-alter:SCREEN-VALUE IN FRAME fPage1 = "":U THEN DO:
        ASSIGN {&ttTable}.cod-ccusto-alter:SCREEN-VALUE IN FRAME fPage1 = fiCodSub:SCREEN-VALUE IN FRAME fpage1 NO-ERROR.
    END.

    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
   
    
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodSub wMaintenanceNoNavigation
ON LEAVE OF fiCodSub IN FRAME fPage1
DO:
    if {&ttTable}.cod-ccusto-alter:screen-value in frame fPage1 = "":U then do:
        assign {&ttTable}.cod-ccusto-alter:screen-value in frame fPage1 = fiCodSub:screen-value in frame fpage1 NO-ERROR.
    end.
    
    IF (c-nom-prog-upc-mg97 <> "" and
        c-nom-prog-upc-mg97 <> ? ) THEN DO:
        /*chamada upc*/
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "LEAVE-SUBCONTA",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage1:HANDLE,
                                        INPUT "",
                                        INPUT ?).
    END.

    IF fiCodSub:SCREEN-VALUE <> "" THEN
        ASSIGN fiCodSub:FORMAT IN FRAME fPage1 = p_cod_format_ccusto NO-ERROR.

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodSub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiCodSub IN FRAME fPage1
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.
{&ttTable}.cod-grp-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)    in frame fPage1.
{&ttTable}.cod-ativid:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
{&ttTable}.cd-tag:LOAD-MOUSE-POINTER("image/lupa.cur":U)           in frame fPage1.
fiCodSub:LOAD-MOUSE-POINTER("image/lupa.cur":U)                    in frame fPage1.
fiCodConta:LOAD-MOUSE-POINTER("image/lupa.cur":U)                  IN FRAME fPage1.
{&ttTable}.cod-cidade:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fPage1.  
{&ttTable}.cod-estado:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fPage1.
{&ttTable}.cod-pais:LOAD-MOUSE-POINTER("image/lupa.cur":U)         IN FRAME fPage1.
{&ttTable}.cod-ccusto-alter:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fiCodContaLub:LOAD-MOUSE-POINTER("image/lupa.cur":U)               in frame fPage1.
fiCodCCustoLub:LOAD-MOUSE-POINTER("image/lupa.cur":U)              IN FRAME fPage1.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN
        c-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
&ENDIF

ON RETURN OF FRAME fPage0 ANYWHERE DO:
    if lAtividade then
        apply "CHOOSE":U to btOK in frame fPage0.
    else 
        RUN applyReturn IN THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** DBO Modelo **/
if valid-handle (hDBOModelo) then
    run destroy in hDBOModelo.
/** DBO Atividade **/
if valid-handle (hDBOAtiv) then
    run destroy in hDBOAtiv.
/** DBO Grupo **/
if valid-handle (hDBOGrupo) then
    run destroy in hDBOGrupo.
/** DBO Tag **/
if valid-handle (hDBOTag) then
    run destroy in hDBOTag.
/** DBO Eqpto **/
if valid-handle (hDBOEqpto) then
    run destroy in hDBOEqpto.

/** DBO Unidade Negocio **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    if valid-handle (hDBOUnNegoc) then
        run destroy in hDBOUnNegoc.
    if valid-handle (hDBOUnidNegocHist) then
        run destroy in hDBOUnidNegocHist.    
&ENDIF

/** DBO mab-param-integr **/
/* if  valid-handle (h-bofr122) then  */
/*     run destroy in h-bofr122.      */

&if integer(entry(1,proversion,".")) >= 9 &then
    empty temp-table tt_criacao_bem_pat_api_5.
    empty temp-table tt_erros_criacao_bem_pat_api.
&else
    for each tt_criacao_bem_pat_api_5:
        delete tt_criacao_bem_pat_api_5.
    end.
    for each tt_erros_criacao_bem_pat_api:
        delete tt_erros_criacao_bem_pat_api.
    end.
&endif 

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display campos em tela
------------------------------------------------------------------------------*/
    /** Descriá‰es de campos **/
    apply "LEAVE":U to {&ttParent}.cod-eqpto    in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-estabel   in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-grp-eqpto in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-ativid    in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cd-tag        in frame fPage1.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN
            APPLY "LEAVE":U TO c-cod-unid-negoc IN FRAME fPage1.
    &ENDIF.
    
    
    /** Coloca informaá‰es da conta cont†bil nos campos em tela **/
    IF pcAction <> "ADD":U THEN DO:

        ASSIGN fiCodConta     = ttHist.ct-codigo
               fiCodSub       = ttHist.cc-codigo.

        FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
            IF mab-param.des-valor = "1":U THEN DO:
                ASSIGN fiCodContaLub  = ttHist.cod-cta-ctbl-lubrific
                       fiCodCCustoLub = ttHist.cod-ccusto-lubrific.
            END.
        END.
    END.

    {utp/ut-liter.i Emplacamento }
    assign fiTexto1 = trim(return-value).
    
    display fiCodConta 
            fiCodSub
            fiTexto1
            fiCodContaLub
            fiCodCCustoLub
        with frame fPage1.
    
    assign {&ttParent}.cod-placa:sensitive in frame fPage1 = no.
    RUN piRetornaData (OUTPUT dCadEquipto).
    
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT ttHist.ep-codigo,       /* EMPRESA EMS2 */
                                                   INPUT "",                     /* PLANO CCUSTO */
                                                   INPUT dCadEquipto,            /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto,   /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).    /* ERROS */
                                                                                               
    
      IF VALID-HANDLE(h_api_ccusto) THEN DO:
              DELETE OBJECT h_api_ccusto.
      END.    
    
    ASSIGN {&ttTable}.cod-ccusto-alter:format in frame fPage1 = IF {&ttTable}.cod-ccusto-alter:SCREEN-VALUE IN FRAME fPage1 = "" THEN "X(20)" ELSE p_cod_format_ccusto NO-ERROR.
           fiCodSub:format in frame fPage1 = IF fiCodSub:SCREEN-VALUE IN FRAME fPage1 = "" THEN "X(20)" ELSE p_cod_format_ccusto NO-ERROR.
           fiCodCCustoLub:format in frame fPage1 = IF fiCodCCustoLub:SCREEN-VALUE IN FRAME fPage1 = "" THEN "X(20)" ELSE p_cod_format_ccusto NO-ERROR.
    
    IF {&ttParent}.idi-tip-propriet = 1 THEN
         RUN piEMS5 IN THIS-PROCEDURE.
    
    /** Seta foco no campo correto **/
    run piFocoInicial in this-procedure.
    
    IF pcAction = "UPDATE":U THEN
        ASSIGN cEmpAux         = {&ttParent}.ep-codigo
               cEqptoAux       = {&ttParent}.cod-eqpto
               cDatCadastroAux = DATE(ttHist.dat-cadastro:SCREEN-VALUE IN FRAME fPage0)
               cCodEstabel     = ttHist.cod-estabel:SCREEN-VALUE IN FRAME fPage1
               cCodUnidNegoc   = c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1.

    APPLY "ENTRY":U TO fiCodCCustoLub IN FRAME fPage1.
    APPLY "LEAVE":U TO fiCodContaLub  IN FRAME fPage1.
    APPLY "LEAVE":U TO fiCodCCustoLub IN FRAME fPage1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o da tela
------------------------------------------------------------------------------*/
    run habilitaCampos in hDBOEqpto (output l-integra,
                                     output l-ems5).
    if  l-integra and
        l-ems5    then do:
        if  pcAction    = "ADD" then do:
            run pi-mostraBem in phCaller (output lMostraBem).
            if  lMostraBem then do:
                assign btBemPatri:hidden    in frame fPage1 = no
                       btBemPatri:sensitive in frame fPage1 = yes
                       /*btBemPatri:row       in frame fpage1 = rtToolBar:row in frame fPage0 + 0.13*/ .
    
                &if '{&mguni_version}' >= '2.06b' or '{&aplica_facelift}' = 'yes' &then
                    if  not valid-handle(h-facelift) then
                        run btb/btb901zo.p persistent set h-facelift.
                    run pi_altera_toolbar_button in h-facelift(input btBemPatri:handle,
                                                               input yes /*chamada externa?*/).
                &endif
            end.
        end.
    end.
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo        */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem Serviáo  */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - M∆o de Obra    */
    
    
    IF ttEqpto.idi-tip-propriet = 2 THEN DO:
    
        assign btBemPatri:hidden    in frame fPage1 = YES
               btBemPatri:sensitive in frame fPage1 = NO.
    END.
    
    RUN cdp/cd9902.p (INPUT 7).
    IF RETURN-VALUE = "NOK":U THEN DO WITH FRAME fPage1:
        /*Se modulo de doctos nao estiver implantado, esconde campos relativos ao mesmo da tela*/
        ASSIGN ttEqpto.cod-placa:HIDDEN = YES
               ttHist.cod-estado:HIDDEN = YES
               ttHist.cod-cidade:HIDDEN = YES
               ttHist.cod-pais:HIDDEN   = YES
               fiTexto1:HIDDEN          = YES.
        HIDE rect-8.
    END.
        
    if pcAction = "ADD":U then do:
        /** Busca data correta para cadastro **/
        run buscaDataCadastro in {&hDBOTable} (input  {&ttParent}.ep-codigo,
                                               input  {&ttParent}.cod-eqpto,
                                               input  no, /** N∆o valida **/
                                               output {&ttTable}.dat-cadastro).
        display {&ttTable}.dat-cadastro
            with frame fPage0.
    end.
    
    /** Busca os formatos da conta e sub-conta **/
    EMPTY TEMP-TABLE tt_log_erro.
    
    RUN piRetornaData (OUTPUT dCadEquipto).
    
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
        
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT ttHist.ep-codigo,     /* EMPRESA EMS2 */
                                                   INPUT "",                   /* PLANO CCUSTO */
                                                   INPUT dCadEquipto,          /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT "",
                                                       INPUT "",
                                                       INPUT dCadEquipto,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    assign fiCodConta:format in frame fPage1     = IF fiCodConta:SCREEN-VALUE <> "" THEN p_cod_format_cta_ctbl ELSE "X(20)"
           fiCodSub:format in frame fPage1       = IF fiCodSub:SCREEN-VALUE <> "" THEN p_cod_format_ccusto   ELSE "X(20)"
           ttHist.cod-ccusto-alter:format in frame fPage1 = IF ttHist.cod-ccusto-alter:SCREEN-VALUE <> "" THEN p_cod_format_ccusto ELSE "X(20)"
           fiCodConta:sensitive in frame fPage1  = yes
           fiCodSub:sensitive in frame fPage1    = YES
           fiCodContaLub:format in frame fPage1  = IF fiCodContaLub:SCREEN-VALUE <> "" THEN p_cod_format_cta_ctbl ELSE "X(20)"
           fiCodCCustoLub:format in frame fPage1 = IF fiCodCCustoLub:SCREEN-VALUE <> "" THEN p_cod_format_ccusto   ELSE "X(20)".
            
           
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
    
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
    
    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
    EMPTY TEMP-TABLE RowErrors.
    /*tratamento de erros*/
    {cdp/cdunif001b.i}
    
    /** Seta foco no campo correto **/
    run piFocoInicial in this-procedure.
    
    assign {&ttParent}.cod-placa:sensitive in frame fPage1 = no.
    
    &IF DEFINED(bf_mnt_ems206b) &THEN
        ASSIGN c-cod-unid-negoc:VISIBLE   IN FRAME fPage1 = l-usa-unid-negoc
               c-cod-unid-negoc:SENSITIVE IN FRAME fPage1 = l-usa-unid-negoc.
    
        IF l-usa-unid-negoc THEN DO:
            ASSIGN c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.cod-unid-negoc.
    
            IF pcAction = "UPDATE":U THEN DO:            
                /** Verifica se hist¢rico selecionado, Ç o mais recente do equipamento. **/
                RUN validaUltimoHistorico IN hDBOUnidNegocHist (INPUT {&ttParent}.ep-codigo,
                                                                INPUT {&ttParent}.cod-eqpto,
                                                                INPUT {&ttTable}.dat-cadastro,
                                                                OUTPUT l-habilita-un).
                /** Unidade de Neg¢cio edit†vel somente no £ltimo hist¢rico. **/
                ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME fPage1 = l-habilita-un.
            END.
            APPLY "LEAVE":U TO c-cod-unid-negoc IN FRAME fPage1.
        END.    
    &ELSE
        ASSIGN c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.cod_unid_negoc.
    &ENDIF
    
     run verificaBgc in phCaller (output lBgcaux).
     IF lBgcaux AND l-habilita-un THEN
          ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME fPage1 = NO
                 ttHist.cod-estabel:SENSITIVE IN FRAME fPage1 = NO.
                 
     ELSE 
         ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME fPage1 = YES
                ttHist.cod-estabel:SENSITIVE IN FRAME fPage1 = YES.

    FOR FIRST mab-param
        WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF mab-param.des-valor = "2" THEN DO:
            ASSIGN fiCodContaLub:SENSITIVE  IN FRAME fPage1 = NO.
            ASSIGN fiCodCCustoLub:SENSITIVE IN FRAME fPage1 = NO.
        END.
    END.
    IF NOT AVAIL mab-param THEN DO:
        ASSIGN fiCodContaLub:SENSITIVE  IN FRAME fPage1 = NO.
        ASSIGN fiCodCCustoLub:SENSITIVE IN FRAME fPage1 = NO.
    END.
    
    APPLY "leave" TO fiCodConta         IN FRAME fPage1.
    APPLY "leave" TO fiCodContaLub      IN FRAME fPage1.
    APPLY "ENTRY" TO ttHist.cod-estabel IN FRAME fPage1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializaá∆o de tela
------------------------------------------------------------------------------*/





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override (antes) de salvar os dados
------------------------------------------------------------------------------*/

    ASSIGN {&ttTable}.ct-codigo              = INPUT FRAME fPage1 fiCodConta 
           {&ttTable}.cc-codigo              = INPUT FRAME fPage1 fiCodSub.

    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF  mab-param.des-valor = "1":U THEN DO:
            ASSIGN {&ttTable}.cod-cta-ctbl-lubrific  = INPUT FRAME fPage1 fiCodContaLub
                   {&ttTable}.cod-ccusto-lubrific    = INPUT FRAME fPage1 fiCodCCustoLub.
        END.
    END.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        ASSIGN {&ttTable}.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1.
    &ELSE
        ASSIGN {&ttTable}.cod_unid_negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1.
    &ENDIF.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs para chaves estrangeiras
------------------------------------------------------------------------------*/

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Atividade ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo~\bofr001.p":U THEN DO:
        run frbo/bofr001.p persistent set  hDBOAtiv.
    END.
    
    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

    /*--- DBO Grupo ---*/
    IF NOT VALID-HANDLE(hDBOGrupo) OR
       hDBOGrupo:TYPE <> "PROCEDURE":U OR
       hDBOGrupo:FILE-NAME <> "frbo~\bofr011.p":U THEN DO:
        run frbo/bofr011.p persistent set  hDBOGrupo.
    END.
    
    RUN openQueryStatic IN hDBOGrupo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Tag ---*/
    IF NOT VALID-HANDLE(hDBOTag) OR
       hDBOTag:TYPE <> "PROCEDURE":U OR
       hDBOTag:FILE-NAME <> "mnbo~\bomn152.p":U THEN DO:
        run mnbo/bomn152.p persistent set  hDBOTag.
    END.
    
    RUN openQueryStatic IN hDBOTag (INPUT "Default":U) NO-ERROR.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.

    /* if  not valid-handle(h-bofr122) then                      */
    /*     run frbo/bofr122.p persistent set h-bofr122 no-error. */

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF NOT VALID-HANDLE(hDBOUnNegoc) OR
            hDBOUnNegoc:TYPE      <> "PROCEDURE":U OR
            hDBOUnNegoc:FILE-NAME <> "inbo/boin745.p":U THEN DO:
            RUN inbo/boin745.p PERSISTENT SET hDBOUnNegoc.
        END.

        RUN openQueryStatic IN hDBOUnNegoc (INPUT "Main":U) NO-ERROR.

        IF NOT VALID-HANDLE(hDBOUnidNegocHist) OR
            hDBOUnidNegocHist:TYPE      <> "PROCEDURE":U OR
            hDBOUnidNegocHist:FILE-NAME <> "frbo/bofr133.p":U THEN DO:
            RUN frbo/bofr133.p PERSISTENT SET hDBOUnidNegocHist.
        END.
    &ENDIF
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ab0138d wMaintenanceNoNavigation 
PROCEDURE pi-ab0138d :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign current-window:sensitive = no.
    run abp/ab0138d1.w persistent set h-ab0138d1 (input input frame fPage0 ttEqpto.ep-codigo,
                                                  input input frame fPage0 ttEqpto.cod-eqpto,
                                                  input input frame fPage0 ttHist.dat-cadastro,
                                                  input input frame fPage1 fiCodSub,
                                                  input {&hDBOTable}:handle).

    run InitializeInterface in h-ab0138d1.
    
    assign current-window:sensitive = yes.

    session:set-wait-state("").

    wait-for "close" of h-ab0138d1.
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-bem wMaintenanceNoNavigation 
PROCEDURE pi-cria-bem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ind-opcao as integer no-undo.
    /* 1- Altera temp-table e chama API */
    /* 2- Altera temp-table             */
    /* 3- Chama API                     */
    
    if  pcAction <> "ADD"  and
        pcAction <> "Copy" then
        return "ok".
    /*
    &if integer(entry(1,proversion,".")) >= 9 &then
        empty temp-table tt_erros_criacao_bem_pat_api.
        empty temp-table rowErrors.
    &else
        for each tt_erros_criacao_bem_pat_api:
            delete tt_erros_criacao_bem_pat_api.
        end.
        for each rowErrors:
            delete rowErrors.
        end.
    &endif 
    
    find first tt_criacao_bem_pat_api_5 no-error.

    if  not avail tt_criacao_bem_pat_api_5 then
        return "ok".

    if  p-ind-opcao <> 3 then do:
        assign cAux = "".
    
        if  entry(4,cParam) = "1" then do: /*modelo do Equipamento */
            run goToKey in hDBOModelo (input ttEqpto.cod-model).
            if  return-value = "ok" then
                run getCharField in hDBOModelo(input  "des-model",
                                               output cAux).
        end.
        else  /*chassi*/
            assign cAux = ttEqpto.cod-chassi.
    
        assign tt_criacao_bem_pat_api_5.tta_des_bem_pat          = cAux
               tt_criacao_bem_pat_api_5.tta_cod_estab_ext        = input frame fPage1 ttHist.cod-estabel
               tt_criacao_bem_pat_api_5.ttv_val_aquis_bem_pat    = ttEqpto.val-compra - tt_criacao_bem_pat_api_5.ttv_val_aquis_bem_pat
               tt_criacao_bem_pat_api_5.tta_dat_aquis_bem_pat    = ttEqpto.dat-inicial
               tt_criacao_bem_pat_api_5.tta_cod_unid_negoc_ext   = input frame fPage1 fi-cod-unid-negoc
               tt_criacao_bem_pat_api_5.tta_cod_ccusto_ext       = ttHist.cc-codigo
               tt_criacao_bem_pat_api_5.tta_cdn_fornecedor       = ttEqpto.cdn-fornecedor
               tt_criacao_bem_pat_api_5.tta_log_bem_imptdo       = no
               tt_criacao_bem_pat_api_5.tta_qtd_bem_pat_represen = 1
               tt_criacao_bem_pat_api_5.tta_des_narrat_bem_pat   = tt_criacao_bem_pat_api_5.tta_des_narrat_bem_pat + ". " + cAux.
    end.
    if  p-ind-opcao <> 2 then do:
        /* Depois retirar esse find. */
        FIND FIRST trad_org_ext
             WHERE trad_org_ext.cod_matriz_trad_org_ext = entry(3,cParam)
               AND trad_org_ext.cod_unid_organ_ext      = input frame fPage1 ttHist.cod-estabel NO-LOCK NO-ERROR.
    
        run prgfin/fas/fas735zf.py (input  1, 
                                    input  entry(3,cParam),
                                    input  if avail trad_org_ext then trad_org_ext.cod_matriz_trad_ccusto_ext  else ?,
                                    input  if avail trad_org_ext then trad_org_ext.cod_matriz_trad_finalid_ext else ?,
                                    input  no,
                                    output cRetornoApi,
                                    output cDesMsgApi).
    
        find first tt_criacao_bem_pat_api_5.
    
        if  cRetornoApi <> "ok" then do:
            assign i-cont = 1.
            if  can-find(first tt_erros_criacao_bem_pat_api) then do:
                for each tt_erros_criacao_bem_pat_api:
                    create rowErrors.
                    assign rowErrors.errorSequence    = i-cont
                           rowErrors.errorNumber      = 17006
                           rowErrors.errorDescription = tt_erros_criacao_bem_pat_api.ttv_des_mensagem
                           rowErrors.errorHelp        = tt_erros_criacao_bem_pat_api.ttv_des_mensagem
                           RowErrors.ErrorType        = "EMS":U
                           RowErrors.ErrorSubType     = "ERROR":U         
                           i-cont                     = i-cont + 1.
                end.
            end.
            else do:
                create rowErrors.
                assign rowErrors.errorSequence    = i-cont
                       rowErrors.errorNumber      = 17006
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U         
                       rowErrors.errorDescription = cDesMsgApi
                       rowErrors.errorHelp        = cDesMsgApi.
            end.
    
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
    
            return "nok".
        end.
    end.
    */
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEMS5 wMaintenanceNoNavigation 
PROCEDURE piEMS5 :
/*------------------------------------------------------------------------------
  Purpose:     piEMS5
  Parameters:  <none>
  Notes:       Busca Estabelecimento e Centro de Custo do EMS5
------------------------------------------------------------------------------*/
DEFINE VARIABLE cod_finalid_econ AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cod_plano_ccusto AS CHARACTER  NO-UNDO.
DEFINE VARIABLE val_dpr          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE h-fas764za       AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-habilita       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-zoom-ems5      AS LOGICAL    NO-UNDO.

run habilitaCampos in hDBOEqpto (output l-habilita,
                                 OUTPUT l-zoom-ems5).

IF l-zoom-ems5 AND pcAction = "ADD":U THEN DO:
    /** Procura pelo programa e retorna mensagem de erro se n∆o o encontrar **/
    if  search("prgfin/fas/fas764za.r")  = ? then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 3984,
                           INPUT "prgfin/fas/fas764za.r":U).
        RETURN "NOK":U.
    END.
    ELSE DO:
        /*Integraá∆o com EMS 5 habilitada. Verificar bem no EMS 5.*/
        RUN prgfin/fas/fas764za.py PERSISTENT SET h-fas764za.                                     
        RUN pi_api_depreciacao_bem_pat IN h-fas764za (INPUT "":U,                     /* Empresa Traduzida*/
                                                      INPUT {&ttParent}.ep-codigo,    /* Empresa EMS2 (empresa externa). Se este valor estiver preenchido serˇ esse o utilizado */
                                                      INPUT TRIM(SUBSTRING({&ttParent}.cod-livre-1,1,18)),  /* Conta Patrimonial */
                                                      INPUT {&ttParent}.bm-codigo,    /* N£mero do Bem */
                                                      INPUT {&ttParent}.bm-indice,    /* SeqÅància do Bem */
                                                      INPUT TODAY,                    /* Data */
                                                      INPUT 2,                        /* Num Funcao -> 1 = Valida Bem; 2 = Retorna Estab/CCusto; 3 = Retorna Val Dpr */
                                                      OUTPUT val_dpr,
                                                      OUTPUT cod_finalid_econ,
                                                      OUTPUT cod_plano_ccusto,
                                                      OUTPUT fiCodSub,
                                                      OUTPUT {&ttTable}.cod-estabel,
                                                      OUTPUT TABLE tt_log_erro). 
        IF VALID-HANDLE(h-fas764za) THEN DO:
            DELETE PROCEDURE h-fas764za.
        END.
        ASSIGN {&ttTable}.cod-ccusto-alter = fiCodSub.
        DISPLAY fiCodSub 
                {&ttTable}.cod-estabel
                {&ttTable}.cod-ccusto-alter
            WITH FRAME fPage1.
    END.
END.

RETURN "OK":U.

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
    apply "ENTRY":U to {&ttTable}.dat-cadastro in frame fPage0.
else 
    apply "ENTRY":U to {&ttTable}.cod-estabel in frame fPage1.

if pcAction = "ADD":U then
    assign btCancel:sensitive in frame fPage0 = if lAtividade 
                                                   then no
                                                    else yes
           btSave:sensitive in frame fPage0   = if lAtividade 
                                                    then no
                                                    else yes.

if lAtividade then do:
    apply "ENTRY":U to {&WINDOW-NAME}.
    apply "ENTRY":U to {&ttTable}.cod-estabel in frame fPage1.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaData wMaintenanceNoNavigation 
PROCEDURE piRetornaData :
DEFINE OUTPUT PARAM pDataCadastro   AS DATE NO-UNDO.

    ASSIGN pDataCadastro = INPUT FRAME fPage0 ttHist.dat-cadastro.
    
    /*
    Caso seja o estabelecimento em vigor (ultimo registro), a data ser† alterada para "today", garantindo que ser† buscado o plano de contas correto.
    Caso seja outro estabelecimento da relaá∆o, a data assumida sera do proprio cadastro.
    */
    FOR LAST bf-mab-histor-ativid NO-LOCK
        WHERE bf-mab-histor-ativid.ep-codigo    = {&ttParent}.ep-codigo 
          AND bf-mab-histor-ativid.cod-eqpto    = {&ttParent}.cod-eqpto :
    
        IF  bf-mab-histor-ativid.dat-cadastro = pDataCadastro
        THEN DO:
            ASSIGN pDataCadastro = TODAY.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaImplementos wMaintenanceNoNavigation 
PROCEDURE piValidaImplementos :
DEFINE INPUT PARAMETER pcEpCodigo     LIKE mab-histor-ativid.ep-codigo.
    DEFINE INPUT PARAMETER pcCodEqpto     LIKE mab-histor-ativid.cod-eqpto.
    DEFINE INPUT PARAMETER pcDatCadastro  LIKE mab-histor-ativid.dat-cadastro.
    DEFINE INPUT PARAMETER pcCodEstabel   LIKE mab-histor-ativid.cod-estabel.
    DEFINE INPUT PARAMETER pcCodUnidNegoc LIKE mab-histor-ativid.cod-unid-negoc.

    ASSIGN lGerouTransf = NO.
    RUN piRetornaLatualiza IN hDBOAtividade (OUTPUT lGerouTransf).

    /********************************************************************************************
     lGerouTransf = yes, evidencia que foi alterado cod-estabel ou unid-nego 
       Se alterou cod-estabel ou unid-nego, dever† questionar se o Equipamento possui Implemento
    *********************************************************************************************/
    IF  lGerouTransf THEN DO:
        ASSIGN l-exibe-msg-implento = NO.

        /* Verifica se o Equipamento possui algum implemento na data da movimentaá∆o */
        FOR EACH bfMgf-eqpto-implto
            WHERE bfMgf-eqpto-implto.ep-codigo-eqpto = pcEpCodigo
              AND bfMgf-eqpto-implto.cod-eqpto       = pcCodEqpto
              AND (bfMgf-eqpto-implto.dat-inicial <= pcDatCadastro AND bfMgf-eqpto-implto.dat-final >= pcDatCadastro) NO-LOCK:
            ASSIGN l-exibe-msg-implento = YES.

            IF   pcAction = "ADD":U OR pcAction = "COPY":U THEN DO:
                /* quando for inclus∆o somente verifica se o implemento ja possui historico na data a ser criado o historico  */
                /* Verifica se o Implemente tem algum Hist¢rico a ser alterado */
                FOR FIRST bfMab-histor-ativid FIELDS(ep-codig cod-eqpto dat-cadastro cod-estabel cod-unid-negoc)
                    WHERE bfMab-histor-ativid.ep-codigo = bfMgf-eqpto-implto.ep-codigo-implto 
                      AND bfMab-histor-ativid.cod-eqpto = bfMgf-eqpto-implto.cod-implto 
                      AND bfMab-histor-ativid.dat-cadastro = pcDatCadastro NO-LOCK:

                    ASSIGN l-exibe-msg-implento = NO.

                END.
            END.
            ELSE DO:
                /* Verifica se o Implemente tem algum Hist¢rico a ser alterado */
                FOR FIRST bfMab-histor-ativid FIELDS(ep-codig cod-eqpto dat-cadastro cod-estabel cod-unid-negoc)
                    WHERE bfMab-histor-ativid.ep-codigo = bfMgf-eqpto-implto.ep-codigo-implto 
                      AND bfMab-histor-ativid.cod-eqpto = bfMgf-eqpto-implto.cod-implto 
                      AND bfMab-histor-ativid.dat-cadastro = pcDatCadastro 
                      AND bfMab-histor-ativid.cod-estabel <> pcCodEstabel NO-LOCK:

                    ASSIGN l-exibe-msg-implento = NO.
                    IF l-usa-unid-negoc AND bfMab-histor-ativid.cod-unid-negoc <> pcCodUnidNegoc THEN
                        ASSIGN l-exibe-msg-implento = NO.

                END.
            END.


            IF  l-exibe-msg-implento THEN
                LEAVE.
        END.

        IF  l-exibe-msg-implento THEN DO:
            ASSIGN c-mgs-aux = String(bfMgf-eqpto-implto.ep-codigo-eqpto) + '~~' + bfMgf-eqpto-implto.cod-eqpto.

            RUN utp/ut-msgs.p (INPUT "SHOW",
                                INPUT 53910,
                                INPUT c-mgs-aux).

            IF  RETURN-VALUE = 'YES':U THEN DO:
                EMPTY TEMP-TABLE ttImptoAtualizados.

                /*  passa as informaá‰es do equipamento */
                RUN piCriaMovtoImplto IN hDBOAtividade (INPUT pcEpCodigo,
                                                        INPUT pcCodEqpto,
                                                        INPUT pcDatCadastro,
                                                        INPUT pcAction,
                                                        OUTPUT TABLE ttImptoAtualizados,
                                                        OUTPUT TABLE RowErrorsImpto).

                IF CAN-FIND (FIRST RowErrorsImpto NO-LOCK) THEN DO:

                    /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
                    EMPTY TEMP-TABLE RowErrors.

                    FOR EACH RowErrorsImpto NO-LOCK:
                        CREATE RowErrors.
                        BUFFER-COPY RowErrorsImpto TO RowErrors.
                    END.

                    /*tratamento de erros*/
                    /*--- Inicializa tela de mensagens de erros ---*/
                    {method/ShowMessage.i1}                  
                    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                    {method/ShowMessage.i2 &Modal="YES"}
                    {method/ShowMessage.i3}

                    RETURN "OK":U.

                END.
                ELSE DO:               
                    ASSIGN c-mgs-aux = "".
                    FOR EACH ttImptoAtualizados NO-LOCK:
                        IF  c-mgs-aux = "" THEN
                            ASSIGN c-mgs-aux = STRING(ttImptoAtualizados.ep-codigo-implto) + "-" + ttImptoAtualizados.cod-eqpto-implto + ". ~r~n".
                        ELSE
                            ASSIGN c-mgs-aux = c-mgs-aux + STRING(ttImptoAtualizados.ep-codigo-implto) + "-" + ttImptoAtualizados.cod-eqpto-implto + ". ~r~n".
                    END.
                    IF CAN-FIND(FIRST ttImptoAtualizados NO-LOCK) THEN DO: 
                        IF pcAction = "COPY":U OR pcAction = "ADD":U THEN DO:
                            RUN utp/ut-msgs.p (INPUT "SHOW",
                                               INPUT 54008,
                                               INPUT c-mgs-aux).
                        END.
                        ELSE IF pcAction = "UPDATE":U THEN DO:
                            RUN utp/ut-msgs.p (INPUT "SHOW",
                                               INPUT 54018,
                                               INPUT c-mgs-aux).
                        END.
                        
                    END.

                    RETURN "OK":U.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

assign {&ttTable}.ep-codigo   = {&ttParent}.ep-codigo
       {&ttTable}.cod-eqpto   = {&ttParent}.cod-eqpto.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

