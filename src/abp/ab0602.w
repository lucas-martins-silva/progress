&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-caract NO-UNDO LIKE mab-eqpto-caract
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttCombustivel NO-UNDO LIKE mab-histor-combust
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttComplemento NO-UNDO LIKE mab-comptmento-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEixo NO-UNDO LIKE mab-configur-eixo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEvento NO-UNDO LIKE mab-programac-event
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttHistorico NO-UNDO LIKE mab-histor-ativid
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLayout NO-UNDO LIKE mpn-histor-layout-eixo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttMab-eqpto-caract NO-UNDO LIKE mab-eqpto-caract
       fields r-rowid as rowid.
DEFINE TEMP-TABLE ttPlano NO-UNDO LIKE mmv-eqpto-plano
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0602 2.00.00.015 } /*** "010015" 22/11/2024 15:42:24 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602 MAB}
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
{cdp/cd9911.i}   /*Unidade Neg¢cio*/
{include/i_fncrowid.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AB0602
&GLOBAL-DEFINE Version        2.00.00.015

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Combust°vel, Comp./Filtr, Hist.Estabel, Prog.Eventos, Planos Prev., Eixos Eq., Layout Pos., Caracter°stica

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        no
&GLOBAL-DEFINE CopyParent       no
&GLOBAL-DEFINE UpdateParent     no
&GLOBAL-DEFINE DeleteParent     no

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       no
&GLOBAL-DEFINE DeleteSon1       no

&GLOBAL-DEFINE AddSon2          no
&GLOBAL-DEFINE CopySon2         no
&GLOBAL-DEFINE UpdateSon2       no
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE AddSon3          no
&GLOBAL-DEFINE CopySon3         no
&GLOBAL-DEFINE UpdateSon3       no
&GLOBAL-DEFINE DeleteSon3       no

&GLOBAL-DEFINE AddSon4          no
&GLOBAL-DEFINE CopySon4         no
&GLOBAL-DEFINE UpdateSon4       no
&GLOBAL-DEFINE DeleteSon4       no

&GLOBAL-DEFINE AddSon4          no
&GLOBAL-DEFINE CopySon4         no
&GLOBAL-DEFINE UpdateSon4       no
&GLOBAL-DEFINE DeleteSon4       no

&GLOBAL-DEFINE AddSon5          no
&GLOBAL-DEFINE CopySon5         no
&GLOBAL-DEFINE UpdateSon5       no
&GLOBAL-DEFINE DeleteSon5       no

&GLOBAL-DEFINE AddSon6          no
&GLOBAL-DEFINE CopySon6         no
&GLOBAL-DEFINE UpdateSon6       no
&GLOBAL-DEFINE DeleteSon6       no

&GLOBAL-DEFINE AddSon7          no
&GLOBAL-DEFINE CopySon7         no
&GLOBAL-DEFINE UpdateSon7       no
&GLOBAL-DEFINE DeleteSon7       no

&GLOBAL-DEFINE AddSon8          no
&GLOBAL-DEFINE CopySon8         no
&GLOBAL-DEFINE UpdateSon8       no
&GLOBAL-DEFINE DeleteSon8       no

&GLOBAL-DEFINE ttParent         ttEqpto
&GLOBAL-DEFINE hDBOParent       hDboEqpto
&GLOBAL-DEFINE DBOParentTable   mab-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttCombustivel
&GLOBAL-DEFINE hDBOSon1         hDBOCombustivel
&GLOBAL-DEFINE DBOSon1Table     mab-histor-combust
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttComplemento
&GLOBAL-DEFINE hDBOSon2         hDBOComplemento
&GLOBAL-DEFINE DBOSon2Table     mab-comptmento-eqpto
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE ttSon3           ttHistorico
&GLOBAL-DEFINE hDBOSon3         hDBOHistorico
&GLOBAL-DEFINE DBOSon3Table     mab-histor-ativid
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE ttSon4           ttEvento
&GLOBAL-DEFINE hDBOSon4         hDBOEvento
&GLOBAL-DEFINE DBOSon4Table     mab-programac-event
&GLOBAL-DEFINE DBOSon4Destroy   YES

&GLOBAL-DEFINE ttSon5           ttPlano
&GLOBAL-DEFINE hDBOSon5         hDBOPlano
&GLOBAL-DEFINE DBOSon5Table     mmv-eqpto-plano
&GLOBAL-DEFINE DBOSon5Destroy   YES

&GLOBAL-DEFINE ttSon6           ttEixo
&GLOBAL-DEFINE hDBOSon6         hDBOEixo
&GLOBAL-DEFINE DBOSon6Table     mfo-configur-eix
&GLOBAL-DEFINE DBOSon6Destroy   YES

&GLOBAL-DEFINE ttSon7           ttLayout
&GLOBAL-DEFINE hDBOSon7         hDBOLayout
&GLOBAL-DEFINE DBOSon7Table     mpn-histor-layout-eixo
&GLOBAL-DEFINE DBOSon7Destroy   YES


&GLOBAL-DEFINE ttSon8           ttMab-eqpto-caract
&GLOBAL-DEFINE hDBOSon8         hDBOMabEqptoCaract
&GLOBAL-DEFINE DBOSon8Table     mab-eqpto-caract
&GLOBAL-DEFINE DBOSon8Destroy   yes

&GLOBAL-DEFINE page0Fields      ttEqpto.ep-codigo ttEqpto.cod-eqpto ttEqpto.idi-tip-eqpto fi-usuario

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2
&GLOBAL-DEFINE page3Browse      brSon3
&GLOBAL-DEFINE page4Browse      brSon4
&GLOBAL-DEFINE page5Browse      brSon5
&GLOBAL-DEFINE page6Browse      brSon6
&GLOBAL-DEFINE page7Browse      brSon7
&GLOBAL-DEFINE page8Browse      brSon8

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescTipoConsumo    AS CHARACTER  format "x(12)" NO-UNDO.
DEFINE VARIABLE cDescTipoConsumoSec AS CHARACTER  format "x(12)" NO-UNDO.
DEFINE VARIABLE cDescCampo          AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cDescCampo2         AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cDescCampo3         AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cDescCampo5         AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cDesAbrev           AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cDesCaract          AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE cValCampo           LIKE mmv-ord-manut.nr-ord-produ NO-UNDO.
DEFINE VARIABLE iTipo               AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-erro-conecta      AS LOGICAL     NO-UNDO.
define variable h-bofr122           as handle      no-undo.
define variable cParam              as char        no-undo.
define variable c-ct-patri          as char        no-undo.
define variable cod_empresa         as char        no-undo.
define variable cAux                as char        no-undo.
define variable h-bofr097           as handle      no-undo.
define variable l-ems5              as logical     no-undo.
define variable l-integra           as logical     no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon4}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon5}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon6}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon7}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon8}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.

DEFINE new global shared VARIABLE gr-mab-eqpto       as rowid               no-undo.

&IF {&ROWID_READY} = YES &THEN
    define new global shared variable v_rec_bem_pat  as rowid               no-undo.
&ELSE
    define new global shared variable v_rec_bem_pat  as recid               no-undo.
&ENDIF

{btb/btb009za.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCombustivel ttComplemento ttHistorico ~
ttEvento ttPlano ttEixo ttLayout ttMab-eqpto-caract

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttCombustivel.dat-inicial ~
ttCombustivel.cod-tip-mater ~
fnDescTpMaterial(ttCombustivel.cod-tip-mater ) @ cDescCampo ~
ttCombustivel.val-capac-tanque ~
fnDescConsumo(ttCombustivel.idi-tip-consu) @ cDescTipoConsumo ~
ttCombustivel.val-consu-padr ~
fnDescConsumo(ttCombustivel.num-livre-1) @ cDescTipoConsumoSec ~
ttCombustivel.val-livre-1 ttCombustivel.dat-desativ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttCombustivel NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttCombustivel NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttCombustivel
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttCombustivel


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttComplemento.cod-comptmento ~
fnDescCompte ( ttComplemento.cod-comptmento,1) @ cDescCampo ~
fnDescCompte(ttComplemento.cod-comptmento, 2) @ cDescCampo2 ~
ttComplemento.cod-sub-sist ~
fnDescSub(ttComplemento.cod-sub-sist) @ cDescCampo3 ~
ttComplemento.idi-remonta ttComplemento.qtd-capac ~
ttComplemento.val-perc-remon ttComplemento.val-km-inicial 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttComplemento NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttComplemento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 ttComplemento
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttComplemento


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 ttHistorico.dat-cadastro ~
ttHistorico.cod-estabel ttHistorico.cod-grp-eqpto ttHistorico.cod-ativid ~
ttHistorico.ct-codigo ttHistorico.cc-codigo ~
ttHistorico.cod-cta-ctbl-lubrific ttHistorico.cod-ccusto-lubrific ~
ttHistorico.cod-ccusto-alter ~
&IF DEFINED(bf_mnt_ems206b) &THEN ttHistorico.cod-unid-negoc &ELSE ttHistorico.cod_unid_negoc &ENDIF ~
ttHistorico.cd-tag 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH ttHistorico NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH ttHistorico NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 ttHistorico
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 ttHistorico


/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 ttEvento.cod-evento ~
fnDescEvento(ttEvento.cod-evento) @ cDescCampo ttEvento.cod-dia-mes-vencto ~
ttEvento.dat-inicial ttEvento.dat-final ttEvento.num-dia ~
ttEvento.num-parcela 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 
&Scoped-define QUERY-STRING-brSon4 FOR EACH ttEvento NO-LOCK
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY brSon4 FOR EACH ttEvento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon4 ttEvento
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 ttEvento


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 ttPlano.cod-plano ~
fnDescPlano(ttPlano.cod-plano) @ cDescCampo5 ttPlano.val-km-real ~
ttPlano.val-km-inicial ttPlano.dat-inicial ttPlano.dat-final ~
ttPlano.dat-atualiz ~
fnOrdemManut(ttPlano.ep-codigo, ttPlano.cod-eqpto, ttPlano.cod-plano) @ cValCampo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 
&Scoped-define QUERY-STRING-brSon5 FOR EACH ttPlano NO-LOCK
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY brSon5 FOR EACH ttPlano NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon5 ttPlano
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 ttPlano


/* Definitions for BROWSE brSon6                                        */
&Scoped-define FIELDS-IN-QUERY-brSon6 ttEixo.num-eixo ttEixo.val-percent-suspen /* ttEixo.log-eixo-dpl */ fnTraducao(ttEixo.log-eixo-dpl) @ ttEixo.log-eixo-dpl /* ttEixo.log-eixo-tracao */ fnTraducao(ttEixo.log-eixo-tracao) @ ttEixo.log-eixo-tracao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon6   
&Scoped-define SELF-NAME brSon6
&Scoped-define QUERY-STRING-brSon6 FOR EACH ttEixo NO-LOCK
&Scoped-define OPEN-QUERY-brSon6 OPEN QUERY {&SELF-NAME} FOR EACH ttEixo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon6 ttEixo
&Scoped-define FIRST-TABLE-IN-QUERY-brSon6 ttEixo


/* Definitions for BROWSE brSon7                                        */
&Scoped-define FIELDS-IN-QUERY-brSon7 ttLayout.cod-layout fnDescLayout(ttLayout.cod-layout) @ cDescCampo ttLayout.dat-inicial /* ttLayout.log-usa-estepe */ fnTraducao(ttLayout.log-usa-estepe) @ ttLayout.log-usa-estepe "Sim/N∆o":U   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon7   
&Scoped-define SELF-NAME brSon7
&Scoped-define QUERY-STRING-brSon7 FOR EACH ttLayout NO-LOCK
&Scoped-define OPEN-QUERY-brSon7 OPEN QUERY {&SELF-NAME} FOR EACH ttLayout NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon7 ttLayout
&Scoped-define FIRST-TABLE-IN-QUERY-brSon7 ttLayout


/* Definitions for BROWSE brSon8                                        */
&Scoped-define FIELDS-IN-QUERY-brSon8 ttMab-eqpto-caract.cod-caract fnRetorno (ttMab-eqpto-caract.cod-caract, 1) @ cDesAbrev ttMab-eqpto-caract.des-caract ttMab-eqpto-caract.des-arquivo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon8   
&Scoped-define SELF-NAME brSon8
&Scoped-define QUERY-STRING-brSon8 FOR EACH ttMab-eqpto-caract WHERE     &IF DEFINED (bf_mnt_ems208) &THEN        ttmab-eqpto-caract.num-param-int = 0     &else        ttmab-eqpto-caract.num-livre-1 = 0     &endif     NO-LOCK
&Scoped-define OPEN-QUERY-brSon8 OPEN QUERY {&SELF-NAME} FOR EACH ttMab-eqpto-caract WHERE     &IF DEFINED (bf_mnt_ems208) &THEN        ttmab-eqpto-caract.num-param-int = 0     &else        ttmab-eqpto-caract.num-livre-1 = 0     &endif     NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon8 ttMab-eqpto-caract
&Scoped-define FIRST-TABLE-IN-QUERY-brSon8 ttMab-eqpto-caract


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brSon4}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brSon5}

/* Definitions for FRAME fPage6                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage6 ~
    ~{&OPEN-QUERY-brSon6}

/* Definitions for FRAME fPage7                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage7 ~
    ~{&OPEN-QUERY-brSon7}

/* Definitions for FRAME fPage8                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage8 ~
    ~{&OPEN-QUERY-brSon8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.idi-tip-eqpto 
&Scoped-define ENABLED-TABLES ttEqpto
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-Define ENABLED-OBJECTS RECT-5 rtParent rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btDetalhe btHistor btPneus btCompte ~
btHistManut btDetBemPatrim btMatrizEqpto btQueryJoins btReportsJoins btExit ~
btHelp fiDescModelo fi-usuario 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.idi-tip-eqpto 
&Scoped-define DISPLAYED-TABLES ttEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fi-usuario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescCompte wMasterDetail 
FUNCTION fnDescCompte RETURNS CHARACTER
  ( cComp as char ,
    iTipo as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescConsumo wMasterDetail 
FUNCTION fnDescConsumo RETURNS CHARACTER
  ( pTipo as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( cEvento as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescLayout wMasterDetail 
FUNCTION fnDescLayout RETURNS CHARACTER
  ( cLayout as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescPlano wMasterDetail 
FUNCTION fnDescPlano RETURNS CHARACTER
  ( cPlano as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescSub wMasterDetail 
FUNCTION fnDescSub RETURNS CHARACTER
  ( cSub as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescTpMaterial wMasterDetail 
FUNCTION fnDescTpMaterial RETURNS CHARACTER
  ( cMaterial as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnOrdemManut wMasterDetail 
FUNCTION fnOrdemManut RETURNS INTEGER
  ( cod-emp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
    cod-equip AS CHAR,
    cod-plan  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetorno wMasterDetail 
FUNCTION fnRetorno RETURNS CHARACTER
    (pCaract as char, 
   pTipo   as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTraducao wMasterDetail 
FUNCTION fnTraducao RETURNS CHARACTER
  (l-traducao AS LOG) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "P&r¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM m_Detalhe_Equipamento LABEL "Detalhe Equipamento" ACCELERATOR "CTRL-K"
       MENU-ITEM m_Histrico_das_Vidas LABEL "Hist¢rico das Vidas" ACCELERATOR "CTRL-D"
       MENU-ITEM m_Equipamento_e_Seus_Pneus LABEL "Equipamento e Seus Pneus" ACCELERATOR "CTRL-P"
       MENU-ITEM m_Equipamento_e_Seus_Componen LABEL "Equipto e Seus Componentes" ACCELERATOR "CTRL-A"
       MENU-ITEM m_Histrico_das_Manutenes_do_E LABEL "Hist¢rico Manut do Equipto" ACCELERATOR "CTRL-E"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCompte 
     IMAGE-UP FILE "image/im-battery.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-battery.bmp":U
     LABEL "Consulta Equipamento e Seus Componentes" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Equipamento e Seus Componentes"
     FONT 4.

DEFINE BUTTON btDetalhe 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Consulta Detalhes do Equipamento" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Detalhes do Equipamento"
     FONT 4.

DEFINE BUTTON btDetBemPatrim 
     IMAGE-UP FILE "image/im-emp.bmp":U
     LABEL "Consulta do Bem Patrimonial" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta do Bem Patrimonial".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHistManut 
     IMAGE-UP FILE "image/im-inisp.bmp":U
     LABEL "Consulta Hist¢rico das Manutená‰es do Equipamento" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Hist¢rico das Manutená‰es do Equipamento"
     FONT 4.

DEFINE BUTTON btHistor 
     IMAGE-UP FILE "image/im-hist.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-hist.bmp":U
     LABEL "Consulta Hist¢rico Vidas" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Hist¢rico Vidas"
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMatrizEqpto 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPneus 
     IMAGE-UP FILE "image/im-pneu.bmp":U
     LABEL "Consulta Equipamento e Seus Pneus" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Equipamento e Seus Pneus"
     FONT 4.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fi-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.29.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.29.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON BtDetalhe01 
     LABEL "&Detalhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Combust°veis".

DEFINE BUTTON btDetalhe02 
     LABEL "D&etalhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Comp/Filho".

DEFINE BUTTON btDetalhe03 
     LABEL "De&talhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Hist. Estab".

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btDetalhe04 
     LABEL "Det&alhar" 
     SIZE 10 BY 1 TOOLTIP "Detalha Consulta Prog. Evento".

DEFINE BUTTON btConsult 
     LABEL "&Consulta OM" 
     SIZE 10 BY 1.

DEFINE BUTTON btDetalhe05 
     LABEL "Detal&har" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Planos Prev".

DEFINE BUTTON btDetalhe06 
     LABEL "Deta&lhar" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Conf. Eixos".

DEFINE BUTTON BtDetalhe07 
     LABEL "Detalha&r" 
     SIZE 10 BY 1 TOOLTIP "Consulta Detalhe Layout Pos".

DEFINE BUTTON btVisSon8 
     LABEL "&Visualizar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttCombustivel SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttComplemento SCROLLING.

DEFINE QUERY brSon3 FOR 
      ttHistorico SCROLLING.

DEFINE QUERY brSon4 FOR 
      ttEvento SCROLLING.

DEFINE QUERY brSon5 FOR 
      ttPlano SCROLLING.

DEFINE QUERY brSon6 FOR 
      ttEixo SCROLLING.

DEFINE QUERY brSon7 FOR 
      ttLayout SCROLLING.

DEFINE QUERY brSon8 FOR 
      ttMab-eqpto-caract SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttCombustivel.dat-inicial FORMAT "99/99/9999":U
      ttCombustivel.cod-tip-mater FORMAT "x(8)":U WIDTH 15.57
      fnDescTpMaterial(ttCombustivel.cod-tip-mater ) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 35
      ttCombustivel.val-capac-tanque COLUMN-LABEL "Capacidade Tanque" FORMAT ">>,>>9.9":U
            WIDTH 18.43
      fnDescConsumo(ttCombustivel.idi-tip-consu) @ cDescTipoConsumo COLUMN-LABEL "Tipo Consumo" FORMAT "x(30)":U
            WIDTH 12
      ttCombustivel.val-consu-padr COLUMN-LABEL "Consumo Padr∆o" FORMAT ">>>,>>9.99":U
            WIDTH 14.14
      fnDescConsumo(ttCombustivel.num-livre-1) @ cDescTipoConsumoSec COLUMN-LABEL "Tipo Consumo Sec." FORMAT "x(30)":U
            WIDTH 18
      ttCombustivel.val-livre-1 COLUMN-LABEL "Consumo Sec." FORMAT "->>>>>>>>>>>9.99":U
            WIDTH 14
      ttCombustivel.dat-desativ FORMAT "99/99/9999":U WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttComplemento.cod-comptmento FORMAT "x(8)":U WIDTH 10.43
      fnDescCompte ( ttComplemento.cod-comptmento,1) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 35
      fnDescCompte(ttComplemento.cod-comptmento, 2) @ cDescCampo2 COLUMN-LABEL "Tipo" FORMAT "x(30)":U
            WIDTH 12
      ttComplemento.cod-sub-sist FORMAT "x(8)":U WIDTH 11.57
      fnDescSub(ttComplemento.cod-sub-sist) @ cDescCampo3 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 35
      ttComplemento.idi-remonta FORMAT "9":U WIDTH 8.14
      ttComplemento.qtd-capac FORMAT ">>,>>9.99":U WIDTH 12.43
      ttComplemento.val-perc-remon FORMAT ">>9.99":U WIDTH 11.72
      ttComplemento.val-km-inicial FORMAT ">>,>>>,>>9.9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      ttHistorico.dat-cadastro FORMAT "99/99/9999":U
      ttHistorico.cod-estabel COLUMN-LABEL "Estabel" FORMAT "x(5)":U
            WIDTH 7.57
      ttHistorico.cod-grp-eqpto FORMAT "x(8)":U WIDTH 12.43
      ttHistorico.cod-ativid FORMAT "x(8)":U WIDTH 11.43
      ttHistorico.ct-codigo FORMAT "x(20)":U
      ttHistorico.cc-codigo FORMAT "x(20)":U
      ttHistorico.cod-cta-ctbl-lubrific COLUMN-LABEL "Conta Lubrificaá∆o" FORMAT "x(20)":U
      ttHistorico.cod-ccusto-lubrific COLUMN-LABEL "Centro de Custo Lubrificaá∆o" FORMAT "x(20)":U
            WIDTH 17.14
      ttHistorico.cod-ccusto-alter FORMAT "x(20)":U
      &IF DEFINED(bf_mnt_ems206b) &THEN ttHistorico.cod-unid-negoc &ELSE ttHistorico.cod_unid_negoc &ENDIF COLUMN-LABEL "Unid Neg¢cio" FORMAT "x(8)":U
            WIDTH 13.43
      ttHistorico.cd-tag FORMAT "x(16)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _STRUCTURED
  QUERY brSon4 NO-LOCK DISPLAY
      ttEvento.cod-evento FORMAT "x(08)":U WIDTH 8.43
      fnDescEvento(ttEvento.cod-evento) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 35
      ttEvento.cod-dia-mes-vencto COLUMN-LABEL "Vencimento" FORMAT "99/99":U
            WIDTH 9.86
      ttEvento.dat-inicial FORMAT "99/99/9999":U
      ttEvento.dat-final FORMAT "99/99/9999":U
      ttEvento.num-dia COLUMN-LABEL "Antecipaá∆o" FORMAT ">>>>9":U
            WIDTH 11.14
      ttEvento.num-parcela FORMAT ">9":U WIDTH 8.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _STRUCTURED
  QUERY brSon5 NO-LOCK DISPLAY
      ttPlano.cod-plano FORMAT "x(16)":U
      fnDescPlano(ttPlano.cod-plano) @ cDescCampo5 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 20
      ttPlano.val-km-real FORMAT ">>,>>>,>>9.9":U
      ttPlano.val-km-inicial FORMAT ">>,>>>,>>9.9":U WIDTH 13.43
      ttPlano.dat-inicial COLUMN-LABEL "Data In°cio" FORMAT "99/99/9999":U
            WIDTH 12
      ttPlano.dat-final COLUMN-LABEL "Validade" FORMAT "99/99/9999":U
      ttPlano.dat-atualiz FORMAT "99/99/9999":U WIDTH 13.14
      fnOrdemManut(ttPlano.ep-codigo, ttPlano.cod-eqpto, ttPlano.cod-plano) @ cValCampo
            WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon6 wMasterDetail _FREEFORM
  QUERY brSon6 NO-LOCK DISPLAY
      ttEixo.num-eixo FORMAT "999":U
      ttEixo.val-percent-suspen FORMAT ">>9.99":U
      /* ttEixo.log-eixo-dpl FORMAT "Sim/N∆o":U */ 
      fnTraducao(ttEixo.log-eixo-dpl) @ ttEixo.log-eixo-dpl
      /* ttEixo.log-eixo-tracao FORMAT "Sim/N∆o":U */ 
      fnTraducao(ttEixo.log-eixo-tracao) @ ttEixo.log-eixo-tracao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon7 wMasterDetail _FREEFORM
  QUERY brSon7 NO-LOCK DISPLAY
      ttLayout.cod-layout FORMAT "x(3)":U WIDTH 7.43
      fnDescLayout(ttLayout.cod-layout) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 35
      ttLayout.dat-inicial COLUMN-LABEL "In°cio Controle" FORMAT "99/99/9999":U
            WIDTH 16.86
      /* ttLayout.log-usa-estepe COLUMN-LABEL "Estepe" FORMAT "Sim/N∆o":U
            WIDTH 10.43 */
      fnTraducao(ttLayout.log-usa-estepe) @ ttLayout.log-usa-estepe COLUMN-LABEL "Estepe" FORMAT
          "Sim/N∆o":U WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon8 wMasterDetail _FREEFORM
  QUERY brSon8 NO-LOCK DISPLAY
      ttMab-eqpto-caract.cod-caract FORMAT "x(8)":U
      fnRetorno (ttMab-eqpto-caract.cod-caract, 1) @ cDesAbrev COLUMN-LABEL "Abreviatura"
            WIDTH 11
      ttMab-eqpto-caract.des-caract  WIDTH 30
      ttMab-eqpto-caract.des-arquivo FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btDetalhe AT ROW 1.13 COL 29.14 HELP
          "Inclui nova ocorrància"
     btHistor AT ROW 1.13 COL 33 HELP
          "Inclui nova ocorrància"
     btPneus AT ROW 1.13 COL 36.86 HELP
          "Inclui nova ocorrància"
     btCompte AT ROW 1.13 COL 40.72 HELP
          "Inclui nova ocorrància"
     btHistManut AT ROW 1.13 COL 44.57 HELP
          "Inclui nova ocorrància"
     btDetBemPatrim AT ROW 1.13 COL 48.57
     btMatrizEqpto AT ROW 1.13 COL 59
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttEqpto.ep-codigo AT ROW 2.75 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttEqpto.cod-eqpto AT ROW 2.75 COL 21.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fiDescModelo AT ROW 2.75 COL 34.72 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     fi-usuario AT ROW 4.21 COL 66 COLON-ALIGNED
     ttEqpto.idi-tip-eqpto AT ROW 4.29 COL 19.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"N∆o Motorizado", 2
          SIZE 41.72 BY .71
     RECT-5 AT ROW 4 COL 1
     rtParent AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.88
         FONT 1.

DEFINE FRAME fPage5
     brSon5 AT ROW 1.17 COL 2
     btDetalhe05 AT ROW 10.42 COL 2
     btConsult AT ROW 10.42 COL 12.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage7
     brSon7 AT ROW 1.17 COL 2
     BtDetalhe07 AT ROW 10.38 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage6
     brSon6 AT ROW 1.17 COL 2
     btDetalhe06 AT ROW 10.38 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage4
     brSon4 AT ROW 1.17 COL 2
     btDetalhe04 AT ROW 10.38 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btDetalhe02 AT ROW 10.33 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage8
     brSon8 AT ROW 1.17 COL 2
     btVisSon8 AT ROW 10.38 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     BtDetalhe01 AT ROW 10.38 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 2
     btDetalhe03 AT ROW 10.38 COL 2.14
     btMatriz AT ROW 10.42 COL 80
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.8
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-caract T "?" NO-UNDO mgfro mab-eqpto-caract
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttCombustivel T "?" NO-UNDO mgfro mab-histor-combust
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttComplemento T "?" NO-UNDO mgfro mab-comptmento-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEixo T "?" NO-UNDO mgfro mab-configur-eixo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEvento T "?" NO-UNDO mgfro mab-programac-event
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttHistorico T "?" NO-UNDO mgfro mab-histor-ativid
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLayout T "?" NO-UNDO mgfro mpn-histor-layout-eixo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttMab-eqpto-caract T "?" NO-UNDO mgfro mab-eqpto-caract
      ADDITIONAL-FIELDS:
          fields r-rowid as rowid
      END-FIELDS.
      TABLE: ttPlano T "?" NO-UNDO mgfro mmv-eqpto-plano
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.88
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE
       FRAME fPage4:FRAME = FRAME fPage0:HANDLE
       FRAME fPage5:FRAME = FRAME fPage0:HANDLE
       FRAME fPage6:FRAME = FRAME fPage0:HANDLE
       FRAME fPage7:FRAME = FRAME fPage0:HANDLE
       FRAME fPage8:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
ASSIGN 
       btDetBemPatrim:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
ASSIGN 
       brSon3:COLUMN-RESIZABLE IN FRAME fPage3       = TRUE
       brSon3:COLUMN-MOVABLE IN FRAME fPage3         = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brSon4 1 fPage4 */
ASSIGN 
       brSon4:COLUMN-RESIZABLE IN FRAME fPage4       = TRUE
       brSon4:COLUMN-MOVABLE IN FRAME fPage4         = TRUE.

/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brSon5 1 fPage5 */
ASSIGN 
       brSon5:COLUMN-RESIZABLE IN FRAME fPage5       = TRUE
       brSon5:COLUMN-MOVABLE IN FRAME fPage5         = TRUE.

/* SETTINGS FOR FRAME fPage6
                                                                        */
/* BROWSE-TAB brSon6 1 fPage6 */
ASSIGN 
       brSon6:COLUMN-RESIZABLE IN FRAME fPage6       = TRUE
       brSon6:COLUMN-MOVABLE IN FRAME fPage6         = TRUE.

/* SETTINGS FOR FRAME fPage7
                                                                        */
/* BROWSE-TAB brSon7 1 fPage7 */
ASSIGN 
       brSon7:COLUMN-RESIZABLE IN FRAME fPage7       = TRUE
       brSon7:COLUMN-MOVABLE IN FRAME fPage7         = TRUE.

/* SETTINGS FOR FRAME fPage8
                                                                        */
/* BROWSE-TAB brSon8 1 fPage8 */
ASSIGN 
       brSon8:COLUMN-RESIZABLE IN FRAME fPage8       = TRUE
       brSon8:COLUMN-MOVABLE IN FRAME fPage8         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttCombustivel"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttCombustivel.dat-inicial
     _FldNameList[2]   > Temp-Tables.ttCombustivel.cod-tip-mater
"ttCombustivel.cod-tip-mater" ? ? "character" ? ? ? ? ? ? no ? no no "15.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescTpMaterial(ttCombustivel.cod-tip-mater ) @ cDescCampo" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttCombustivel.val-capac-tanque
"ttCombustivel.val-capac-tanque" "Capacidade Tanque" ? "decimal" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnDescConsumo(ttCombustivel.idi-tip-consu) @ cDescTipoConsumo" "Tipo Consumo" "x(30)" ? ? ? ? ? ? ? no "Indicador - Tipo Consumo" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttCombustivel.val-consu-padr
"ttCombustivel.val-consu-padr" "Consumo Padr∆o" ? "decimal" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnDescConsumo(ttCombustivel.num-livre-1) @ cDescTipoConsumoSec" "Tipo Consumo Sec." "x(30)" ? ? ? ? ? ? ? no "Indicador - Tipo Consumo Sec." no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttCombustivel.val-livre-1
"ttCombustivel.val-livre-1" "Consumo Sec." "->>>>>>>>>>>9.99" "decimal" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttCombustivel.dat-desativ
"ttCombustivel.dat-desativ" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttComplemento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttComplemento.cod-comptmento
"ttComplemento.cod-comptmento" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescCompte ( ttComplemento.cod-comptmento,1) @ cDescCampo" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescCompte(ttComplemento.cod-comptmento, 2) @ cDescCampo2" "Tipo" "x(30)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttComplemento.cod-sub-sist
"ttComplemento.cod-sub-sist" ? ? "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnDescSub(ttComplemento.cod-sub-sist) @ cDescCampo3" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttComplemento.idi-remonta
"ttComplemento.idi-remonta" ? ? "integer" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttComplemento.qtd-capac
"ttComplemento.qtd-capac" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttComplemento.val-perc-remon
"ttComplemento.val-perc-remon" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ttComplemento.val-km-inicial
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.ttHistorico"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttHistorico.dat-cadastro
     _FldNameList[2]   > Temp-Tables.ttHistorico.cod-estabel
"ttHistorico.cod-estabel" "Estabel" ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttHistorico.cod-grp-eqpto
"ttHistorico.cod-grp-eqpto" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttHistorico.cod-ativid
"ttHistorico.cod-ativid" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttHistorico.ct-codigo
"ttHistorico.ct-codigo" ? ? "character" ? ? ? ? ? ? no "Conta" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttHistorico.cc-codigo
"ttHistorico.cc-codigo" ? ? "character" ? ? ? ? ? ? no "C Custo" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttHistorico.cod-cta-ctbl-lubrific
"ttHistorico.cod-cta-ctbl-lubrific" "Conta Lubrificaá∆o" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttHistorico.cod-ccusto-lubrific
"ttHistorico.cod-ccusto-lubrific" "Centro de Custo Lubrificaá∆o" ? "character" ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ttHistorico.cod-ccusto-alter
     _FldNameList[10]   > "_<CALC>"
"&IF DEFINED(bf_mnt_ems206b) &THEN ttHistorico.cod-unid-negoc &ELSE ttHistorico.cod_unid_negoc &ENDIF" "Unid Neg¢cio" "x(8)" ? ? ? ? ? ? ? no "C¢digo da Unidade de Neg¢cio" no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.ttHistorico.cd-tag
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _TblList          = "Temp-Tables.ttEvento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttEvento.cod-evento
"ttEvento.cod-evento" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescEvento(ttEvento.cod-evento) @ cDescCampo" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttEvento.cod-dia-mes-vencto
"ttEvento.cod-dia-mes-vencto" "Vencimento" ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttEvento.dat-inicial
     _FldNameList[5]   = Temp-Tables.ttEvento.dat-final
     _FldNameList[6]   > Temp-Tables.ttEvento.num-dia
"ttEvento.num-dia" "Antecipaá∆o" ">>>>9" "integer" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttEvento.num-parcela
"ttEvento.num-parcela" ? ? "integer" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _TblList          = "Temp-Tables.ttPlano"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttPlano.cod-plano
     _FldNameList[2]   > "_<CALC>"
"fnDescPlano(ttPlano.cod-plano) @ cDescCampo5" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttPlano.val-km-real
     _FldNameList[4]   > Temp-Tables.ttPlano.val-km-inicial
"ttPlano.val-km-inicial" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttPlano.dat-inicial
"ttPlano.dat-inicial" "Data In°cio" ? "date" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttPlano.dat-final
"ttPlano.dat-final" "Validade" ? "date" ? ? ? ? ? ? no "Data de Validade do plano no equipamento" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttPlano.dat-atualiz
"ttPlano.dat-atualiz" ? ? "date" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fnOrdemManut(ttPlano.ep-codigo, ttPlano.cod-eqpto, ttPlano.cod-plano) @ cValCampo" ? ? ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon6
/* Query rebuild information for BROWSE brSon6
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttEixo NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon7
/* Query rebuild information for BROWSE brSon7
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttLayout NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon8
/* Query rebuild information for BROWSE brSon8
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttMab-eqpto-caract WHERE
    &IF DEFINED (bf_mnt_ems208) &THEN
       ttmab-eqpto-caract.num-param-int = 0
    &else
       ttmab-eqpto-caract.num-livre-1 = 0
    &endif
    NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon8 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage8
/* Query rebuild information for FRAME fPage8
     _Query            is NOT OPENED
*/  /* FRAME fPage8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon8
&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME brSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon8 wMasterDetail
ON MOUSE-SELECT-CLICK OF brSon8 IN FRAME fPage8
DO:
  DEFINE VARIABLE l-Ok AS LOGICAL    NO-UNDO.
  if num-entries("brSon8":u) > 0 then do:
      if avail ttMab-eqpto-caract then do:
      get Current brSon8 no-lock.
      run buscaCatalogo in {&hDBOSon8} (input ttMab-eqpto-caract.cod-caract,
                                        output l-ok).
      if l-ok  then
          assign btVisSon8:sensitive in frame fPage8 = yes.
      else
    
          assign btVisSon8:sensitive in frame fPage8 = no.

      end.

  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCompte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCompte wMasterDetail
ON CHOOSE OF btCompte IN FRAME fPage0 /* Consulta Equipamento e Seus Componentes */
OR CHOOSE OF MENU-ITEM m_Equipamento_e_Seus_Componen IN MENU mbMain DO:
   

    assign {&window-name}:sensitive = no.
     run buscaRowidEqpto in this-procedure.
         if return-value = "ok" THEN DO:
            run cop/co0604.w.
      
         END.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to btCompte in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btConsult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsult wMasterDetail
ON CHOOSE OF btConsult IN FRAME fPage5 /* Consulta OM */
DO:
    DEFINE VARIABLE hProgram AS HANDLE NO-UNDO.
    DEFINE VARIABLE fnOm AS INTEGER    NO-UNDO.

    assign {&WINDOW-NAME}:sensitive = no.
    
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    /*--- Executa programa de inclus∆o de filho ---*/
    RUN mvp/mv0606.w PERSISTENT SET hProgram.
    
    /** Validaá∆o do Handle **/
    IF VALID-HANDLE(hProgram) AND
        hProgram:Type = "PROCEDURE":U AND
        hProgram:FILE-NAME = "mvp/mv0606.w":U THEN do:
        /*--- Inicializa programa de inclus∆o de filho ---*/
        RUN initializeInterface IN hProgram.
        /*:T Reposiciona registro com base em um rowid */

        ASSIGN fnOm = fnOrdemManut(ttPlano.ep-codigo, ttPlano.cod-eqpto, ttPlano.cod-plano).

        FOR FIRST mmv-ord-manut 
            WHERE mmv-ord-manut.nr-ord-produ = fnOm NO-LOCK:
            RUN repositionRecord IN hProgram (INPUT ROWID(mmv-ord-manut)).
        END.
    END.

    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    
    wait-for "CLOSE":U of hProgram.
    if valid-handle (hProgram) then
        delete procedure hProgram.

    assign {&WINDOW-NAME}:sensitive = yes.  

    apply "ENTRY":U to btConsult in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wMasterDetail
ON CHOOSE OF btDetalhe IN FRAME fPage0 /* Consulta Detalhes do Equipamento */
OR CHOOSE OF MENU-ITEM m_Detalhe_Equipamento IN MENU mbMain DO:

  run abp/ab0602a.w (input int(ttEqpto.ep-codigo:screen-value in frame fPage0),
                     input ttEqpto.cod-eqpto:screen-value in frame fPage0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME BtDetalhe01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtDetalhe01 wMasterDetail
ON CHOOSE OF BtDetalhe01 IN FRAME fPage1 /* Detalhar */
DO:
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Executa programa de Detalhe de filho ---*/
 if INPUT FRAME fPage1 brSon1:num-selected-rows > 0  then do: 
        ASSIGN rSon = {&ttSon1}.r-Rowid.
        run abp/ab0602b.w (INPUT rSon,
                           INPUT rCurrentParent,
                           INPUT THIS-PROCEDURE).
 END.

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDetalhe02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe02 wMasterDetail
ON CHOOSE OF btDetalhe02 IN FRAME fPage2 /* Detalhar */
DO:
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

assign {&window-name}:sensitive = no.

/*--- Executa programa de manutená∆o de filho ---*/

 if INPUT FRAME fPage2 brSon2:num-selected-rows > 0  then do:
    
        ASSIGN rSon = {&ttSon2}.r-Rowid.
     
        RUN abp/ab0602c.w (INPUT rSon,
                           INPUT rCurrentParent,
                           INPUT THIS-PROCEDURE).
 END.
assign {&window-name}:sensitive = yes.

/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDetalhe03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe03 wMasterDetail
ON CHOOSE OF btDetalhe03 IN FRAME fPage3 /* Detalhar */
DO:
     run abp/ab0602d.w (input ttHistorico.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDetalhe04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe04 wMasterDetail
ON CHOOSE OF btDetalhe04 IN FRAME fPage4 /* Detalhar */
DO:
   run abp/ab0602e.w (INPUT ttEvento.r-rowid).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDetalhe05
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe05 wMasterDetail
ON CHOOSE OF btDetalhe05 IN FRAME fPage5 /* Detalhar */
DO:
  run abp/ab0602f.w (INPUT ttPlano.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btDetalhe06
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe06 wMasterDetail
ON CHOOSE OF btDetalhe06 IN FRAME fPage6 /* Detalhar */
DO:
  run abp/ab0602g.w (input ttEixo.r-rowid).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME BtDetalhe07
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtDetalhe07 wMasterDetail
ON CHOOSE OF BtDetalhe07 IN FRAME fPage7 /* Detalhar */
DO:
    run abp/ab0602h.w (input ttLayout.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDetBemPatrim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetBemPatrim wMasterDetail
ON CHOOSE OF btDetBemPatrim IN FRAME fPage0 /* Consulta do Bem Patrimonial */
DO:
    if  search("prgfin/fas/fas211aa.r") = ? and
        search("prgfin/fas/fas211aa.p") = ? then do:
        run utp/ut-msgs.p (input "Show",
                           input 3984,
                           input "prgfin/fas/fas211aa.p").

        return no-apply.
    END.
    else do trans:
        &IF {&ROWID_READY} = YES &THEN
        assign cAux = "rowid".
        &ELSE
        assign cAux = "recid".
        &ENDIF

        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
        run pi-caract-bem   (output c-ct-patri, output cod_empresa).
        run pi-busca-ems5   (input "bem_pat",
                             input "bem_pat.cod_empresa     = ~"" + cod_empresa               + "~"," +
                                   "bem_pat.cod_cta_pat     = ~"" + c-ct-patri                + "~"," +
                                   "bem_pat.num_bem_pat     =   " + string(ttEqpto.bm-codigo) +   "," + 
                                   "bem_pat.num_seq_bem_pat =   " + string(ttEqpto.bm-indice),
                             input-output cAux).
        &IF {&ROWID_READY} = YES &THEN
            ASSIGN v_rec_bem_pat = TO-ROWID(cAux).
        &ELSE
            ASSIGN v_rec_bem_pat = int(cAux).
        &ENDIF
        run prgfin/fas/fas211aa.p /*prg_bas_bem_pat_fin*/.
        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistManut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistManut wMasterDetail
ON CHOOSE OF btHistManut IN FRAME fPage0 /* Consulta Hist¢rico das Manutená‰es do Equipamento */
OR CHOOSE OF MENU-ITEM m_Histrico_das_Manutenes_do_E IN MENU mbMain DO:
    



     assign {&window-name}:sensitive = no.
     run buscaRowidEqpto in this-procedure.
         if return-value = "ok" THEN DO:
             run mvp/mv0609.w.
         END.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to btHistManut in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistor wMasterDetail
ON CHOOSE OF btHistor IN FRAME fPage0 /* Consulta Hist¢rico Vidas */
OR CHOOSE OF MENU-ITEM m_Histrico_das_Vidas IN MENU mbMain DO:
   
    assign {&window-name}:sensitive = no.
    run buscaRowidEqpto in this-procedure.
        if return-value = "ok":U THEN DO:
           run abp/ab0618.w.
        END.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to btHistor in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMasterDetail
ON CHOOSE OF btMatriz IN FRAME fPage3
DO:
    IF AVAIL {&ttSon3} THEN DO:
        /*--- Seta cursor do mouse para espera ---*/
        SESSION:SET-WAIT-STATE("GENERAL":U).

        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

        /*--- Executa programa de manutená∆o de filho ---*/
        RUN abp/ab0302e.w (INPUT INPUT FRAME fPage0 {&ttParent}.ep-codigo,
                           INPUT INPUT FRAME fPage0 {&ttParent}.cod-eqpto,
                           INPUT {&ttSon3}.dat-cadastro).

        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).

        APPLY "ENTRY":U TO btMatriz IN FRAME fPage3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btMatrizEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatrizEqpto wMasterDetail
ON CHOOSE OF btMatrizEqpto IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    /*--- Executa programa de manutená∆o de filho ---*/
    RUN abp/ab0138n.w (INPUT INPUT FRAME fPage0 ttEqpto.ep-codigo,
                       INPUT INPUT FRAME fPage0 ttEqpto.cod-eqpto).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatrizEqpto IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPneus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPneus wMasterDetail
ON CHOOSE OF btPneus IN FRAME fPage0 /* Consulta Equipamento e Seus Pneus */
OR CHOOSE OF MENU-ITEM m_Equipamento_e_Seus_Pneus IN MENU mbMain DO:
 
     assign {&window-name}:sensitive = no.
     run buscaRowidEqpto in this-procedure.
         if return-value = "ok" THEN DO:
            run pnp/pn0605.w.
         END.
    assign {&window-name}:sensitive = yes.
    apply "ENTRY":U to btPneus in frame fPage0.




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr007.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btVisSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisSon8 wMasterDetail
ON CHOOSE OF btVisSon8 IN FRAME fPage8 /* Visualizar */
DO:
     if num-entries("brSon8":u) > 0 then do:
      get Current brSon8 no-lock.
      run visualizaDocto in {&hDBOSon8} (input ttMab-eqpto-caract.cod-caract,
                                         input ttMab-eqpto-caract.des-arquivo).
     

  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMasterDetail
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    if avail ttEqpto then do:
        {method/referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="ttEqpto.cod-model"
            &FieldName1="des-model"
            &FieldScreen1="fiDescModelo"
            &Frame1="fPage0"}
    end.
    else
        assign fiDescModelo:screen-value in frame fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (Ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/

/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display dos campos em tela
------------------------------------------------------------------------------*/
/** Usu†rio de inclus∆o/alteraá∆o do registro **/
IF  NOT CONNECTED("emsbas") OR 
    NOT CONNECTED("emsfin") OR 
    NOT CONNECTED("emsuni") THEN
    RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
ELSE
    RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).

IF ttEqpto.cod-livre-2 <> "" THEN
    ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fPage0 = ttEqpto.cod-livre-2.
ELSE
    ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fPage0 = "":U.

/** Descriá∆o Modelo **/
apply "LEAVE":U to ttEqpto.cod-eqpto in frame fPage0.

/** Habilita/ Desabilita Bot‰es de inclus∆o dos browses **/
run piBotoes in this-procedure.

/** Habilita/Desabilita Botoes Unidade Negocio **/
IF l-usa-unid-negoc THEN DO:
    RUN piValidaMatriz IN THIS-PROCEDURE.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o da tela
------------------------------------------------------------------------------*/

{utp/ut-liter.i Descriá∆o *}
ASSIGN cDescCampo5:LABEL IN BROWSE brSon5 = RETURN-VALUE.

{utp/ut-liter.i Ordem *}
ASSIGN cValCampo:LABEL IN BROWSE brSon5 = RETURN-VALUE.

{utp/ut-liter.i Equipamento *}
ttEqpto.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.

RUN openQueryStatic IN {&hDBOParent} (INPUT "main") NO-ERROR.
RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-mab-eqpto).
if  return-value = "NOK":U then
    run getFirst in this-procedure.

/* run frbo/bofr122 persistent set h-bofr122.                 */
/* run openQueryStatic in h-bofr122 ("Main").                 */
/* run goToKey         in h-bofr122 (12).                     */
/* if  return-value = "ok" then                               */
/*     run getCharField in h-bofr122 (input  'des-valor',     */
/*                                    output cParam).         */
/* else                                                       */
/*     assign cParam = "".                                    */
/*                                                            */
/* {utp/ut-liter.i Sim}                                       */
/* if  entry(2,cParam) = return-value then                    */
/*     assign btDetBemPatrim:hidden    in frame fPage0 = no   */
/*            btDetBemPatrim:sensitive in frame fPage0 = yes. */
/* run destroy in h-bofr122.                                  */

run habilitaCampos in {&hDBOParent} (output l-integra,
                                     output l-ems5).

if  l-integra and 
    l-ems5    then
    assign btDetBemPatrim:hidden    in frame fPage0 = no  
           btDetBemPatrim:sensitive in frame fPage0 = yes.

ASSIGN btMatriz:SENSITIVE      IN FRAME fPage3 = l-usa-unid-negoc
       btMatriz:VISIBLE        IN FRAME fPage3 = l-usa-unid-negoc
       btMatrizEqpto:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       btMatrizEqpto:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN ttHistorico.cod-unid-negoc:VISIBLE IN BROWSE brSon3 = l-usa-unid-negoc.
&ENDIF

/** Habilita/Desabilita Botoes Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatrizEqpto:TOOLTIP IN FRAME fPage0 = "":U
           btMatriz:TOOLTIP      IN FRAME fPage3 = "":U.

RUN openQueryStatic IN {&hDBOParent} (INPUT "main") NO-ERROR.
RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-mab-eqpto).
IF RETURN-VALUE = "NOK":U THEN
    RUN getFirst IN THIS-PROCEDURE.

RUN setFolder IN hFolder (1).

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRowidEqpto wMasterDetail 
PROCEDURE buscaRowidEqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.071" &THEN
    find mab-eqpto where mab-eqpto.ep-codigo = ttEqpto.ep-codigo:SCREEN-VALUE IN FRAME fPage0
&ELSE
    find mab-eqpto where mab-eqpto.ep-codigo = int(ttEqpto.ep-codigo:SCREEN-VALUE IN FRAME fPage0) 
&ENDIF
            AND mab-eqpto.cod-eqpto = ttEqpto.cod-eqpto:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
    if avail mab-eqpto then do:
        ASSIGN gr-mab-eqpto =  rowid(mab-eqpto).
        return "ok":U.
    end.
    else
        return "NOK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cep-codigo   LIKE {&ttParent}.ep-codigo VIEW-AS FILL-IN SIZE 5.00 BY 0.88  NO-UNDO.
    DEFINE VARIABLE ccod-eqpto     LIKE {&ttParent}.cod-eqpto VIEW-AS FILL-IN SIZE 16.00 BY 0.88    NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cep-codigo      AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cep-codigo,
                                      input ccod-eqpto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Equipamento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cep-codigo  
           ccod-eqpto    
           btGoToOK 
           btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set {&hDBOParent}.
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado Combust°vel ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr014.p":U THEN DO:
        run frbo/bofr014.p persistent set {&hDBOSon1}.
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado Complemento ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo/bofr004.p":U THEN DO:
        run frbo/bofr004.p persistent set {&hDBOSon2}. 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Hist¢rico ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        run frbo/bofr013.p persistent set {&hDBOSon3}. 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Evento ---*/
    IF NOT VALID-HANDLE({&hDBOSon4}) OR
       {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon4}:FILE-NAME <> "frbo/bofr022.p":U THEN DO:
        run frbo/bofr022.p persistent set {&hDBOSon4}. 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Plano ---*/
    IF NOT VALID-HANDLE({&hDBOSon5}) OR
       {&hDBOSon5}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon5}:FILE-NAME <> "frbo/bofr031.p":U THEN DO:
        run frbo/bofr031.p persistent set {&hDBOSon5}. 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Eixo ---*/
    IF NOT VALID-HANDLE({&hDBOSon6}) OR
       {&hDBOSon6}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon6}:FILE-NAME <> "frbo/bofr005.p":U THEN DO:
        run frbo/bofr005.p persistent set {&hDBOSon6}. 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado Layout ---*/
    IF NOT VALID-HANDLE({&hDBOSon7}) OR
       {&hDBOSon7}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon7}:FILE-NAME <> "frbo/bofr044.p":U THEN DO:
        run frbo/bofr044.p persistent set {&hDBOSon7}. 
    END.
      /*:T--- Verifica se o DBO j† est† inicializado Combust°vel ---*/
    IF NOT VALID-HANDLE({&hDBOSon8}) OR 
       {&hDBOSon8}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon8}:FILE-NAME <> "frbo/bofr097.p":U THEN DO:
        run frbo/bofr097.p persistent set {&hDBOSon8}.
    END.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="2"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="3"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="4"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="5"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="6"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="7"}
                                   
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="8"}
                                   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-ems5 wMasterDetail 
PROCEDURE pi-busca-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input        param p-tabela  as char no-undo.
    def input        param p-where   as char no-undo.
    def input-output param p-retorna as char no-undo.

    def var hQuery  as widget-handle no-undo.
    def var hBuffer as widget-handle no-undo.
    def var hField  as widget-handle no-undo.
    def var cQuery  as char          no-undo.
    def var cReturn as char          no-undo.
    def var iCont   as integer       no-undo.

    assign cQuery    = "for each " + p-tabela + " no-lock where " + replace (p-where,","," and ")
           cReturn   = p-retorna
           p-retorna = "".

    create buffer hBuffer for table p-tabela no-error.
    create query  hQuery                     no-error.

    if  error-status:error then
        return "nok".

    hQuery:set-buffers(hBuffer)  no-error. 
    hQuery:query-prepare(cQuery) no-error.
    hQuery:query-open            no-error.

    if  not error-status:error   and 
        not hQuery:query-off-end then do:
        hQuery:get-first() no-error.
        
        if  hBuffer:avail then do:
            do  iCont = 1 to num-entries(cReturn):
                if  entry(iCont,cReturn) = "recid" then
                    assign p-retorna = if p-retorna = "" then string(hBuffer:recid) else p-retorna + "," + string(hBuffer:recid).
                else if entry(iCont,cReturn) = "rowid" then
                    assign p-retorna = if p-retorna = "" then string(hBuffer:rowid) else p-retorna + "," + string(hBuffer:rowid).
                else do:
                    hField = hBuffer:buffer-field(entry(iCont,cReturn)) no-error.
    
                    if  not error-status:error then
                        assign p-retorna = if p-retorna = "" then hField:buffer-value else p-retorna + "," + hField:buffer-value.
                    else
                        assign p-retorna = ",".
                end.
            end.
        end.
    end.
    else
        return "nok".

    return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-caract-bem wMasterDetail 
PROCEDURE pi-caract-bem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-ct-patri    as char no-undo.
    def output param p-cod_empresa as char no-undo.

    def var iAux as integer no-undo.

    run frbo/bofr097.p persistent set h-bofr097.
    run setConstraintEquipamento in h-bofr097(input ttEqpto.ep-codigo,
                                              input ttEqpto.cod-eqpto).
    run openQueryStatic in h-bofr097("Equipamento-2").
    
    run getBatchRecords in h-bofr097 (input  ?,
                                      input  ?,
                                      input  999,
                                      output iAux,
                                      output table tt-caract).
    run destroy in h-bofr097.

    for first tt-caract 
        where tt-caract.cod-caract = "ct_ems5":
        assign p-ct-patri = tt-caract.des-caract.
    end.
    for first tt-caract 
        where tt-caract.cod-caract = "cod_empresa":
        assign p-cod_empresa = tt-caract.des-caract.
    end.

    return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 wMasterDetail 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     pi-conecta-ems5
  Parameters:  Entrada l-conecta = Sim - Conecta Bancos
                                   N∆o - Desconecta Bancos
               Sa°da   i-erro-conecta = Se ocorreram erros de conex∆o
  Notes:       Conecta bancos do EMS5
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER l-conecta      as logical no-undo.
DEFINE OUTPUT PARAMETER l-erro-conecta as logical no-undo init no.
DEF VAR h-btb009za AS HANDLE NO-UNDO.
DEF VAR l-conectado AS LOGICAL NO-UNDO.

RUN btb/btb009za.p PERSISTENT SET h-btb009za.

for first param-global no-lock:
end.

if not avail param-global then do:
    /** ParÉmetros Globais n∆o Cadastrados **/
    run piCriaErro (input 16, 
                    input 'EMS':U, 
                    input "":U).

    assign l-erro-conecta = yes.

    return "NOK":U.

end.

/** Solicitaá∆o para Conectar bancos do Financeiro **/
if l-conecta then do:
    /** Verifica se bancos do Financeiro n∆o est∆o conectados **/
    if  not connected("emsbas") or 
        not connected("emsfin") or 
        not connected("emsuni") then do:
    /*    assign l-conectado = no.*/
/*         if  search("prgint/dcf/dcf903za.r")  = ? and       */
/*             search("prgint/dcf/dcf903za.py") = ? then do:  */
/*             /** Erro **/                                   */
/*             run piCriaErro (4, 'EMS':U, "dcf900za":U).     */
/*             assign l-erro-conecta = yes.                   */
/*         end.                                               */
/*         if  search("prgfin/acr/acr711zf.r ")  = ? and      */
/*             search("prgfin/acr/acr711zf.py ") = ? then do: */
/*             /** Erro **/                                   */
/*             run piCriaErro (4, 'EMS':U, "acr711zf":U).     */
/*             assign l-erro-conecta = yes.                   */
/*         end.                                               */
       /* else do:*/
            run pi-conecta-bco IN h-btb009za (Input 1,                          /*versao api */
                                              Input 1,                          /* 1 - conex∆o, 2 - desconex∆o - Envia o Status atual do banco */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).

            if return-value <> "OK":U then do:
                FOR EACH tt_erros_conexao no-lock:
                    /** Erro **/
                    run piCriaErro (INPUT tt_erros_conexao.cd-erro, 
                                    INPUT 'EMS':U, 
                                    INPUT tt_erros_conexao.param-1).
                    assign l-erro-conecta = yes.
                end.
           /* end.*/
        end.
    END.
    else do:
        assign l-conectado = yes.
    end.
end.
/** Solicitaá∆o para Desconectar bancos do Financeiro **/
if not l-conecta or l-erro-conecta then do:
    if not l-conectado then do:
        if  connected("emsbas") or 
            connected("emsfin") or 
            connected("emsuni") then do:
            run pi-conecta-bco IN h-btb009za (Input 1,          /*versao api */
                                              Input 2,          /* 1 - conex∆o, 2 - desconex∆o - Envia o Status atual do banco */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).

            if return-value <> "OK":U then do:
                FOR EACH tt_erros_conexao no-lock:
                    /** Erro **/
                    run piCriaErro (INPUT tt_erros_conexao.cd-erro,
                                    INPUT 'EMS':U,
                                    INPUT tt_erros_conexao.param-1).
                    assign l-erro-conecta = yes.
                end.
            end.
        end.
    end.
end.

IF VALID-HANDLE(h-btb009za) THEN
   DELETE PROCEDURE h-btb009za.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaCompartimento wMasterDetail 
PROCEDURE piAtualizaCompartimento :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaCompartimento
  Parameters:  <none>
  Notes:       Atualiza Browse P†gina 2
------------------------------------------------------------------------------*/
    {masterdetail/openqueriesson.i &Parent="Equipamento"
                                   &Query="Equipamento"
                                   &PageNumber="2"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBotoes wMasterDetail 
PROCEDURE piBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita Bot‰es de inclus∆o dos browses
------------------------------------------------------------------------------*/
assign btDetalhe01:sensitive in frame fPage1 = yes
       btDetalhe02:sensitive in frame fPage2 = yes
       btDetalhe03:sensitive in frame fPage3 = yes
       btDetalhe04:sensitive in frame fPage4 = yes
       btDetalhe05:sensitive in frame fPage5 = yes
       btDetalhe06:sensitive in frame fPage6 = yes
       btDetalhe07:sensitive in frame fPage7 = yes
       btDetalhe:sensitive in frame fPage0 = yes
       btHistor:sensitive in frame fPage0 = yes
       btPneus:sensitive in frame fPage0 = yes
       btHistManut:sensitive in frame fPage0 = yes
       btCompte:sensitive in frame fPage0 = yes
       btDetBemPatrim:sensitive in frame fPage0 = yes.


if num-results("brSon1":U) > 0 then
   assign btDetalhe01:sensitive in frame fPage1 = yes.
else    
   assign btDetalhe01:sensitive in frame fPage1 = no.

if num-results("brSon2":U) > 0 then
   assign btDetalhe02:sensitive in frame fPage2 = yes.
else    
   assign btDetalhe02:sensitive in frame fPage2 = no.

if num-results("brSon3":U) > 0 then
   assign btDetalhe03:sensitive in frame fPage3 = yes.
else    
   assign btDetalhe03:sensitive in frame fPage3 = no.

if num-results("brSon4":U) > 0 then
   assign btDetalhe04:sensitive in frame fPage4 = yes.
else    
   assign btDetalhe04:sensitive in frame fPage4 = no.
   
if num-results("brSon5":U) > 0 then
   assign btDetalhe05:sensitive in frame fPage5 = YES
          btConsult:SENSITIVE IN FRAME fPage5 = YES.
else    
   assign btDetalhe05:sensitive in frame fPage5 = no
          btConsult:SENSITIVE IN FRAME fPage5 = NO.

if num-results("brSon6":U) > 0 then
   assign btDetalhe06:sensitive in frame fPage6 = yes.
else
   assign btDetalhe06:sensitive in frame fPage6 = no.


if num-results("brSon7":U) > 0 then
   assign btDetalhe07:sensitive in frame fPage7 = yes.
else    
   assign btDetalhe07:sensitive in frame fPage7 = no.



 /*Pneus*/  
   run cdp/cd9902.p (input 2).
   if return-value = "NOK":U then
      assign btPneus:sensitive in frame fPage0 = false
             MENU-ITEM m_Equipamento_e_Seus_Pneus:SENSITIVE IN MENU mbMain    = FALSE.
   else
      assign btPneus:sensitive in frame fPage0 = true
             MENU-ITEM m_Equipamento_e_Seus_Pneus:SENSITIVE IN MENU mbMain    = TRUE.

   /*Componentes*/  
   run cdp/cd9902.p (input 4).
   if return-value = "NOK":U then
      assign btCompte:sensitive in frame fPage0 = FALSE
             MENU-ITEM m_Equipamento_e_Seus_Componen:SENSITIVE IN MENU mbMain = FALSE.
   else
      assign btCompte:sensitive in frame fPage0 = TRUE
             MENU-ITEM m_Equipamento_e_Seus_Componen:SENSITIVE IN MENU mbMain = TRUE.

   /*Hist.Manut.*/  
   run cdp/cd9902.p (input 3).
   if return-value = "NOK":U then
      assign btHistManut:sensitive in frame fPage0 = false
             MENU-ITEM m_Histrico_das_Manutenes_do_E:SENSITIVE IN MENU mbMain = FALSE.
   else
      assign btHistManut:sensitive in frame fPage0 = true
             MENU-ITEM m_Histrico_das_Manutenes_do_E:SENSITIVE IN MENU mbMain = TRUE.

   /*Man. Mecanica*/
   run cdp/cd9902.p (input 3).
   if return-value = "NOK":U then
      run setEnabled in hFolder (input 5, false).
   else
      run setEnabled in hFolder (input 5, true).

   /*Pneus*/  
   run cdp/cd9902.p (input 2).
   if return-value = "NOK":U then
      run setEnabled in hFolder (input 7, false).
   else
      run setEnabled in hFolder (input 7, true).
    





/*
if can-find(first ttEqpto) then
    assign btAddSon1:sensitive in frame fPage1 = yes
           btManut2:sensitive  in frame fPage2 = yes
           btAddSon3:sensitive in frame fPage3 = yes
           btAddSon4:sensitive in frame fPage4 = yes
           btAddSon5:sensitive in frame fPage5 = yes
           btAddSon6:sensitive in frame fPage6 = yes
           btAddSon7:sensitive in frame fPage7 = yes.
else
    assign btAddSon1:sensitive in frame fPage1 = no
           btManut2:sensitive  in frame fPage2 = no
           btAddSon3:sensitive in frame fPage3 = no
           btAddSon4:sensitive in frame fPage4 = no
           btAddSon5:sensitive in frame fPage5 = no
           btAddSon6:sensitive in frame fPage6 = no
           btAddSon7:sensitive in frame fPage7 = no.
*/
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMasterDetail 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF NUM-RESULTS("brSon3":U) = 0 THEN
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage3 = NO.
        ELSE
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage3 = YES.

        ASSIGN btMatrizEqpto:SENSITIVE IN FRAME fPage0 = CAN-FIND(FIRST mab-unid-negoc-eqpto
                                                                  WHERE mab-unid-negoc-eqpto.ep-codigo = {&ttParent}.ep-codigo
                                                                  AND   mab-unid-negoc-eqpto.cod-eqpto = {&ttParent}.cod-eqpto NO-LOCK).
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescCompte wMasterDetail 
FUNCTION fnDescCompte RETURNS CHARACTER
  ( cComp as char ,
    iTipo as int) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescComp
    Notes:  Busca Descriá∆o do campo Compartimento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mab-comptmento fields(des-comptmento idi-oleo-filtro) 
    where mab-comptmento.cod-comptmento = cComp no-lock:
    if iTipo = 1 then
        assign cRetorno = mab-comptmento.des-comptmento.
    else 
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {frinc/i00fr003.i 04 mab-comptmento.idi-oleo-filtro}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  cRetorno = RETURN-VALUE.
        &else
            ASSIGN cRetorno = {frinc/i00fr003.i 04 mab-comptmento.idi-oleo-filtro}.
        &endif
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescConsumo wMasterDetail 
FUNCTION fnDescConsumo RETURNS CHARACTER
  ( pTipo as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE pDesc AS CHARACTER  NO-UNDO.

IF  pTipo = 0 THEN
    ASSIGN pTipo = 1.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao002 = {frinc/i01fr014.i 04 pTipo}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  pDesc = RETURN-VALUE.
&else
    ASSIGN pDesc = {frinc/i01fr014.i 04 pTipo}.
&endif

  RETURN pDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( cEvento as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescEvento
    Notes:  Busca Descriá∆o do campo Evento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mab-event fields(des-evento) 
    where mab-event.cod-evento = cEvento no-lock:
    assign cRetorno = mab-event.des-evento.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescLayout wMasterDetail 
FUNCTION fnDescLayout RETURNS CHARACTER
  ( cLayout as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescLayout
    Notes:  Busca Descriá∆o do campo Layout
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mpn-layout fields(des-layout) 
    where mpn-layout.cod-layout = cLayout no-lock:
    assign cRetorno = mpn-layout.des-layout.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescPlano wMasterDetail 
FUNCTION fnDescPlano RETURNS CHARACTER
  ( cPlano as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescPlano
    Notes:  Busca Descriá∆o do campo Plano de Manutená∆o.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

if avail ttEqpto  then do:
   for first mmv-plano-prevent fields(des-plano-manut) 
       where mmv-plano-prevent.cod-plano = cPlano 
         and mmv-plano-prevent.cod-model = ttEqpto.cod-model no-lock:
       assign cRetorno = mmv-plano-prevent.des-plano-manut.
   end.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescSub wMasterDetail 
FUNCTION fnDescSub RETURNS CHARACTER
  ( cSub as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescSub
    Notes:  Busca Descriá∆o do campo Sub Sistema
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mab-sub-sist fields(des-sub-sist) 
    where mab-sub-sist.cod-sub-sist = cSub no-lock:
    assign cRetorno = mab-sub-sist.des-sub-sist.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescTpMaterial wMasterDetail 
FUNCTION fnDescTpMaterial RETURNS CHARACTER
  ( cMaterial as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescMaterial
    Notes:  Busca Descriá∆o do campo Tipo Material
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

for first mab-tip-mater fields(des-tip-mater) 
    where mab-tip-mater.cod-tip-mater = cMaterial no-lock:
    assign cRetorno = mab-tip-mater.des-tip-mater.
end.

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnOrdemManut wMasterDetail 
FUNCTION fnOrdemManut RETURNS INTEGER
  ( cod-emp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF,
    cod-equip AS CHAR,
    cod-plan  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: fnOrdemManut
    Notes: Busca Ordem de Manutená∆o
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno LIKE mmv-ord-manut.nr-ord-produ NO-UNDO.

ASSIGN cRetorno = 0.

FOR LAST mmv-tar-ord-manut WHERE
         mmv-tar-ord-manut.ep-codigo = cod-emp AND
         mmv-tar-ord-manut.cod-eqpto = cod-equip AND
         mmv-tar-ord-manut.cod-plano = cod-plan AND
         mmv-tar-ord-manut.estado = 4 NO-LOCK:
    ASSIGN cRetorno = mmv-tar-ord-manut.nr-ord-produ.
END.

RETURN cRetorno.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetorno wMasterDetail 
FUNCTION fnRetorno RETURNS CHARACTER
    (pCaract as char, 
   pTipo   as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.
  for first mab-caract fields(cod-caract des-abrev des-caract)
      where mab-caract.cod-caract = pCaract no-lock.
      if pTipo = 1 then do:
        assign cRetorno = mab-caract.des-abrev.
      end.
      else do:
        assign cRetorno = mab-caract.des-caract.
      end.

  end.
  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTraducao wMasterDetail 
FUNCTION fnTraducao RETURNS CHARACTER
  (l-traducao AS LOG):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF l-traducao THEN
        {utp/ut-liter.i Sim *}
    ELSE
        {utp/ut-liter.i N∆o *}

    RETURN RETURN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

