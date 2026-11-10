&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
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
DEFINE TEMP-TABLE ttImptoAtualizados NO-UNDO
        FIELD ep-codigo-implto LIKE mab-eqpto.ep-codigo
        FIELD cod-eqpto-implto LIKE mab-eqpto.cod-eqpto.
DEFINE TEMP-TABLE RowErrorsImplto NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138 2.00.00.034 } /*** "010034" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138 MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cdp/cdcfgmnt.i} /*Vers‰es EMS MNT*/
{cdp/cd9911.i}   /*Unidade Neg¢cio*/
{cdp/cd1008.i1} /* Manutenªío Mec≥nica */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AB0138
&GLOBAL-DEFINE Version        2.00.00.030

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Combust°vel, Comp./Filtr, Hist.Estabel, Prog.Eventos, Planos Prev., Eixos Eq., Layout Pos., Caracter°stica

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         yes
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE AddSon4          YES
&GLOBAL-DEFINE CopySon4         NO
&GLOBAL-DEFINE UpdateSon4       YES
&GLOBAL-DEFINE DeleteSon4       YES

&GLOBAL-DEFINE AddSon5          YES
&GLOBAL-DEFINE CopySon5         NO
&GLOBAL-DEFINE UpdateSon5       YES
&GLOBAL-DEFINE DeleteSon5       YES

&GLOBAL-DEFINE AddSon6          YES
&GLOBAL-DEFINE CopySon6         NO
&GLOBAL-DEFINE UpdateSon6       YES
&GLOBAL-DEFINE DeleteSon6       YES

&GLOBAL-DEFINE AddSon7          YES
&GLOBAL-DEFINE CopySon7         NO
&GLOBAL-DEFINE UpdateSon7       YES
&GLOBAL-DEFINE DeleteSon7       YES

&GLOBAL-DEFINE AddSon8          YES
&GLOBAL-DEFINE CopySon8         NO
&GLOBAL-DEFINE UpdateSon8       YES
&GLOBAL-DEFINE DeleteSon8       YES

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
&GLOBAL-DEFINE hDBOSon8         hDBOMab-eqpto-caract
&GLOBAL-DEFINE DBOSon8Table     Mab-eqpto-caract
&GLOBAL-DEFINE DBOSon8Destroy   YES 

&GLOBAL-DEFINE page0Fields      ttEqpto.ep-codigo ttEqpto.cod-eqpto fi-usuario

&GLOBAL-DEFINE page0Widgets     btIntegraXML

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
DEFINE VARIABLE cDescCampo4         AS CHARACTER  format "x(30)" NO-UNDO.
DEFINE VARIABLE lCopia              AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE cDesAbrev           AS CHARACTER  format "x(35)" NO-UNDO.
DEFINE VARIABLE iTipo               AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-create            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-erro-conecta      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-exibe-msg-implento AS LOGICAL NO-UNDO.
DEFINE VARIABLE cEmpAux         LIKE ttHistorico.ep-codigo NO-UNDO.            
DEFINE VARIABLE cEqptoAux       LIKE ttHistorico.cod-eqpto NO-UNDO.          
DEFINE VARIABLE cDatCadastroAux LIKE ttHistorico.dat-cadastro NO-UNDO. 
DEFINE VARIABLE cCodEstabel     LIKE ttHistorico.cod-estabel NO-UNDO.      
DEFINE VARIABLE cCodUnidNegoc   LIKE ttHistorico.cod-unid-negoc NO-UNDO. 

/* Buffer's */

DEFINE BUFFER bfMgf-eqpto-implto FOR mgf-eqpto-implto.
DEFINE BUFFER bfMab-histor-ativid FOR mab-histor-ativid.
DEFINE BUFFER bfTtHistorico FOR ttHistorico.

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
DEFINE VARIABLE hProgFunc     AS HANDLE NO-UNDO.
DEFINE VARIABLE hbofr057      AS HANDLE NO-UNDO.
DEFINE VARIABLE hbofr074      AS HANDLE NO-UNDO.
DEFINE VARIABLE lbgc          AS LOGICAL NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN
    DEFINE VARIABLE c-unid-negoc  LIKE unid-negoc.cod-unid-negoc NO-UNDO.
&ELSE
    DEFINE VARIABLE c-unid-negoc  LIKE mab-histor-ativid.cod_unid_negoc NO-UNDO.
&ENDIF
    
/** Vari†veis Compartilhadas entre programas pais e filhos **/
define new global shared variable lAtividade    as logical                no-undo.

{frbo~/bofr007.i tt-equipment}
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
fnDescricao(ttCombustivel.cod-tip-mater,3,0) @ cDescCampo ~
ttCombustivel.val-capac-tanque ~
fnDescricao(string(ttCombustivel.idi-tip-consu),7,0) @ cDescTipoConsumo ~
ttCombustivel.val-consu-padr ~
fnDescricao(string(ttCombustivel.num-livre-1),7,0) @ cDescTipoConsumoSec ~
ttCombustivel.val-livre-1 ttCombustivel.dat-desativ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttCombustivel NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttCombustivel NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttCombustivel
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttCombustivel


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttComplemento.cod-comptmento ~
fnDescricao(ttComplemento.cod-comptmento,8,1) @ cDescCampo ~
fnDescricao(ttComplemento.cod-comptmento,8,2) @ cDescCampo2 ~
ttComplemento.cod-sub-sist ~
fnDescricao(ttComplemento.cod-sub-sist,5,0) @ cDescCampo3 ~
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
fnDescricao(ttEvento.cod-evento,1,0) @ cDescCampo ~
ttEvento.cod-dia-mes-vencto ttEvento.dat-inicial ttEvento.dat-final ~
ttEvento.num-dia ttEvento.num-parcela 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 
&Scoped-define QUERY-STRING-brSon4 FOR EACH ttEvento NO-LOCK
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY brSon4 FOR EACH ttEvento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon4 ttEvento
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 ttEvento


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 ttPlano.cod-plano ~
fnDescricao(ttPlano.cod-Plano,4,0) @ cDescCampo4 ttPlano.dat-inicial ~
ttPlano.dat-final ttPlano.val-km-inicial ttPlano.val-km-real 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 
&Scoped-define QUERY-STRING-brSon5 FOR EACH ttPlano NO-LOCK
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY brSon5 FOR EACH ttPlano NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon5 ttPlano
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 ttPlano


/* Definitions for BROWSE brSon6                                        */
&Scoped-define FIELDS-IN-QUERY-brSon6 ttEixo.num-eixo ttEixo.val-percent-suspen /*ttEixo.log-eixo-dpl */ fntraducao(ttEixo.log-eixo-dpl) @ ttEixo.log-eixo-dpl /*ttEixo.log-eixo-tracao */ fntraducao(ttEixo.log-eixo-tracao) @ ttEixo.log-eixo-tracao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon6   
&Scoped-define SELF-NAME brSon6
&Scoped-define QUERY-STRING-brSon6 FOR EACH ttEixo NO-LOCK
&Scoped-define OPEN-QUERY-brSon6 OPEN QUERY {&SELF-NAME} FOR EACH ttEixo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon6 ttEixo
&Scoped-define FIRST-TABLE-IN-QUERY-brSon6 ttEixo


/* Definitions for BROWSE brSon7                                        */
&Scoped-define FIELDS-IN-QUERY-brSon7 ttLayout.cod-layout fnDescricao(ttLayout.cod-layout,2,0) @ cDescCampo ttLayout.dat-inicial /* ttLayout.log-usa-estepe */ fntraducao(ttLayout.log-usa-estepe) @ ttLayout.log-usa-estepe   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon7   
&Scoped-define SELF-NAME brSon7
&Scoped-define QUERY-STRING-brSon7 FOR EACH ttLayout NO-LOCK
&Scoped-define OPEN-QUERY-brSon7 OPEN QUERY {&SELF-NAME} FOR EACH ttLayout NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon7 ttLayout
&Scoped-define FIRST-TABLE-IN-QUERY-brSon7 ttLayout


/* Definitions for BROWSE brSon8                                        */
&Scoped-define FIELDS-IN-QUERY-brSon8 ttMab-eqpto-caract.cod-caract fnDescricao(ttMab-eqpto-caract.cod-caract,6,0) @ cDesAbrev ttMab-eqpto-caract.des-caract ttMab-eqpto-caract.des-arquivo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon8   
&Scoped-define SELF-NAME brSon8
&Scoped-define QUERY-STRING-brSon8 FOR EACH ttMab-eqpto-caract NO-LOCK
&Scoped-define OPEN-QUERY-brSon8 OPEN QUERY {&SELF-NAME} FOR EACH ttMab-eqpto-caract NO-LOCK.
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
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto 
&Scoped-define ENABLED-TABLES ttEqpto
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btMatriz btIntegraXML ~
btQueryJoins btReportsJoins btExit btHelp fi-usuario fiDescModelo 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto 
&Scoped-define DISPLAYED-TABLES ttEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-Define DISPLAYED-OBJECTS fi-usuario fiDescModelo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (pCodigo AS CHAR, piDesc AS INT, iTipo AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fntraducao wMasterDetail 
FUNCTION fntraducao RETURNS CHARACTER
  ( l-traducao AS LOG)  FORWARD.

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
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btIntegraXML 
     IMAGE-UP FILE "image/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-exp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exportaá∆o XML".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btManut2 
     LABEL "&Manutená∆o" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon3 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon3 
     LABEL "&Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUnidNegoc 
     LABEL "Unid Negoc" 
     SIZE 10 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btUpdateSon3 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon4 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon4 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon4 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon5 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon5 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon5 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon6 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon6 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon6 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon7 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon7 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon7 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon8 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon8 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon8 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

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
      ttCombustivel.cod-tip-mater FORMAT "x(8)":U
      fnDescricao(ttCombustivel.cod-tip-mater,3,0) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttCombustivel.val-capac-tanque COLUMN-LABEL "Capacidade Tanque" FORMAT ">>,>>9.9":U
      fnDescricao(string(ttCombustivel.idi-tip-consu),7,0) @ cDescTipoConsumo COLUMN-LABEL "Tipo Consumo" FORMAT "x(12)":U
      ttCombustivel.val-consu-padr COLUMN-LABEL "Consumo Padr∆o" FORMAT ">>>,>>9.99":U
      fnDescricao(string(ttCombustivel.num-livre-1),7,0) @ cDescTipoConsumoSec COLUMN-LABEL "Tipo Consumo Sec." FORMAT "x(12)":U
            WIDTH 18
      ttCombustivel.val-livre-1 COLUMN-LABEL "Consumo Sec." FORMAT ">>>,>>9.99":U
            WIDTH 13
      ttCombustivel.dat-desativ FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttComplemento.cod-comptmento FORMAT "x(8)":U
      fnDescricao(ttComplemento.cod-comptmento,8,1) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      fnDescricao(ttComplemento.cod-comptmento,8,2) @ cDescCampo2 COLUMN-LABEL "Tipo" FORMAT "x(12)":U
            WIDTH 10
      ttComplemento.cod-sub-sist FORMAT "x(8)":U
      fnDescricao(ttComplemento.cod-sub-sist,5,0) @ cDescCampo3 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttComplemento.idi-remonta FORMAT "9":U
      ttComplemento.qtd-capac FORMAT ">>,>>9.99":U
      ttComplemento.val-perc-remon FORMAT ">>9.99":U
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
      ttHistorico.cod-grp-eqpto FORMAT "x(8)":U
      ttHistorico.cod-ativid FORMAT "x(8)":U
      ttHistorico.ct-codigo FORMAT "x(20)":U WIDTH 20
      ttHistorico.cc-codigo FORMAT "x(20)":U WIDTH 20
      ttHistorico.cod-cta-ctbl-lubrific COLUMN-LABEL "Conta Lubrificaá∆o" FORMAT "x(20)":U
      ttHistorico.cod-ccusto-lubrific COLUMN-LABEL "Centro Custo Lubrificaá∆o" FORMAT "x(20)":U
            WIDTH 26.29
      ttHistorico.cod-ccusto-alter FORMAT "x(20)":U WIDTH 20
      &IF DEFINED(bf_mnt_ems206b) &THEN ttHistorico.cod-unid-negoc &ELSE ttHistorico.cod_unid_negoc &ENDIF COLUMN-LABEL "Unid Neg¢cio" FORMAT "x(8)":U
      ttHistorico.cd-tag FORMAT "x(16)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _STRUCTURED
  QUERY brSon4 NO-LOCK DISPLAY
      ttEvento.cod-evento FORMAT "x(08)":U
      fnDescricao(ttEvento.cod-evento,1,0) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(35)":U
            WIDTH 30
      ttEvento.cod-dia-mes-vencto COLUMN-LABEL "Vencimento" FORMAT "99/99":U
      ttEvento.dat-inicial FORMAT "99/99/9999":U
      ttEvento.dat-final FORMAT "99/99/9999":U
      ttEvento.num-dia COLUMN-LABEL "Antecipaá∆o" FORMAT ">>>>>":U
      ttEvento.num-parcela FORMAT ">9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _STRUCTURED
  QUERY brSon5 NO-LOCK DISPLAY
      ttPlano.cod-plano COLUMN-LABEL "Plano" FORMAT "x(16)":U WIDTH 10
      fnDescricao(ttPlano.cod-Plano,4,0) @ cDescCampo4 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 25
      ttPlano.dat-inicial FORMAT "99/99/9999":U
      ttPlano.dat-final COLUMN-LABEL "Validade" FORMAT "99/99/9999":U
      ttPlano.val-km-inicial FORMAT ">>,>>>,>>9.9":U
      ttPlano.val-km-real FORMAT ">>,>>>,>>9.9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon6 wMasterDetail _FREEFORM
  QUERY brSon6 NO-LOCK DISPLAY
      ttEixo.num-eixo FORMAT "999":U
      ttEixo.val-percent-suspen FORMAT ">>9.99":U
      /*ttEixo.log-eixo-dpl FORMAT "Sim/N∆o":U    */
      fntraducao(ttEixo.log-eixo-dpl) @ ttEixo.log-eixo-dpl
      /*ttEixo.log-eixo-tracao FORMAT "Sim/N∆o":U */
      fntraducao(ttEixo.log-eixo-tracao) @ ttEixo.log-eixo-tracao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon7 wMasterDetail _FREEFORM
  QUERY brSon7 NO-LOCK DISPLAY
      ttLayout.cod-layout FORMAT "x(3)":U
      fnDescricao(ttLayout.cod-layout,2,0) @ cDescCampo COLUMN-LABEL "Descriá∆o" FORMAT "x(35)":U
            WIDTH 30
      ttLayout.dat-inicial COLUMN-LABEL "In°cio Controle" FORMAT "99/99/9999":U
      /* ttLayout.log-usa-estepe COLUMN-LABEL "Estepe" FORMAT "Sim/N∆o":U */
      fntraducao(ttLayout.log-usa-estepe) @ ttLayout.log-usa-estepe COLUMN-LABEL "Estepe" FORMAT "Sim/N∆o":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon8 wMasterDetail _FREEFORM
  QUERY brSon8 NO-LOCK DISPLAY
      ttMab-eqpto-caract.cod-caract FORMAT "x(8)":U
      fnDescricao(ttMab-eqpto-caract.cod-caract,6,0) @ cDesAbrev COLUMN-LABEL "Abreviatura"
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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btMatriz AT ROW 1.13 COL 56.14
     btIntegraXML AT ROW 1.13 COL 61.86
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttEqpto.ep-codigo AT ROW 2.83 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fi-usuario AT ROW 2.83 COL 66.57 COLON-ALIGNED
     ttEqpto.cod-eqpto AT ROW 3.83 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 3.83 COL 40.57 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.92
         FONT 1.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 2
     btAddSon3 AT ROW 10.33 COL 2
     btCopySon3 AT ROW 10.33 COL 12
     btUpdateSon3 AT ROW 10.33 COL 22
     btDeleteSon3 AT ROW 10.33 COL 32
     btUnidNegoc AT ROW 10.33 COL 74
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage5
     brSon5 AT ROW 1.17 COL 2
     btAddSon5 AT ROW 10.33 COL 2
     btUpdateSon5 AT ROW 10.33 COL 12
     btDeleteSon5 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btManut2 AT ROW 10.33 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage6
     brSon6 AT ROW 1.17 COL 2
     btAddSon6 AT ROW 10.33 COL 2
     btUpdateSon6 AT ROW 10.33 COL 12
     btDeleteSon6 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage7
     brSon7 AT ROW 1.17 COL 2
     btAddSon7 AT ROW 10.33 COL 2
     btUpdateSon7 AT ROW 10.33 COL 12
     btDeleteSon7 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage8
     brSon8 AT ROW 1.17 COL 2
     btAddSon8 AT ROW 10.33 COL 2
     btUpdateSon8 AT ROW 10.33 COL 12
     btDeleteSon8 AT ROW 10.33 COL 22
     btVisSon8 AT ROW 10.33 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage4
     brSon4 AT ROW 1.17 COL 2
     btAddSon4 AT ROW 10.33 COL 2
     btUpdateSon4 AT ROW 10.33 COL 12
     btDeleteSon4 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
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
         HEIGHT             = 16.92
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
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
ASSIGN 
       brSon3:COLUMN-MOVABLE IN FRAME fPage3         = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brSon4 1 fPage4 */
ASSIGN 
       brSon4:COLUMN-MOVABLE IN FRAME fPage4         = TRUE.

/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brSon5 1 fPage5 */
ASSIGN 
       brSon5:COLUMN-MOVABLE IN FRAME fPage5         = TRUE.

/* SETTINGS FOR FRAME fPage6
                                                                        */
/* BROWSE-TAB brSon6 1 fPage6 */
ASSIGN 
       brSon6:COLUMN-MOVABLE IN FRAME fPage6         = TRUE.

/* SETTINGS FOR FRAME fPage7
                                                                        */
/* BROWSE-TAB brSon7 1 fPage7 */
ASSIGN 
       brSon7:COLUMN-MOVABLE IN FRAME fPage7         = TRUE.

/* SETTINGS FOR FRAME fPage8
                                                                        */
/* BROWSE-TAB brSon8 1 fPage8 */
ASSIGN 
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
     _FldNameList[2]   = Temp-Tables.ttCombustivel.cod-tip-mater
     _FldNameList[3]   > "_<CALC>"
"fnDescricao(ttCombustivel.cod-tip-mater,3,0) @ cDescCampo" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttCombustivel.val-capac-tanque
"ttCombustivel.val-capac-tanque" "Capacidade Tanque" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnDescricao(string(ttCombustivel.idi-tip-consu),7,0) @ cDescTipoConsumo" "Tipo Consumo" "x(12)" ? ? ? ? ? ? ? no "Indicador - Tipo Consumo" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttCombustivel.val-consu-padr
"ttCombustivel.val-consu-padr" "Consumo Padr∆o" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnDescricao(string(ttCombustivel.num-livre-1),7,0) @ cDescTipoConsumoSec" "Tipo Consumo Sec." "x(12)" ? ? ? ? ? ? ? no "Indicador - Tipo Consumo" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttCombustivel.val-livre-1
"ttCombustivel.val-livre-1" "Consumo Sec." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "Valor Consumo Secund†rio" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ttCombustivel.dat-desativ
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttComplemento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttComplemento.cod-comptmento
     _FldNameList[2]   > "_<CALC>"
"fnDescricao(ttComplemento.cod-comptmento,8,1) @ cDescCampo" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescricao(ttComplemento.cod-comptmento,8,2) @ cDescCampo2" "Tipo" "x(12)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttComplemento.cod-sub-sist
     _FldNameList[5]   > "_<CALC>"
"fnDescricao(ttComplemento.cod-sub-sist,5,0) @ cDescCampo3" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.ttComplemento.idi-remonta
     _FldNameList[7]   = Temp-Tables.ttComplemento.qtd-capac
     _FldNameList[8]   = Temp-Tables.ttComplemento.val-perc-remon
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
"cod-estabel" "Estabel" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttHistorico.cod-grp-eqpto
     _FldNameList[4]   = Temp-Tables.ttHistorico.cod-ativid
     _FldNameList[5]   > Temp-Tables.ttHistorico.ct-codigo
"ct-codigo" ? ? "character" ? ? ? ? ? ? no "Conta" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttHistorico.cc-codigo
"cc-codigo" ? ? "character" ? ? ? ? ? ? no "C Custo" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttHistorico.cod-cta-ctbl-lubrific
"cod-cta-ctbl-lubrific" "Conta Lubrificaá∆o" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttHistorico.cod-ccusto-lubrific
"cod-ccusto-lubrific" "Centro Custo Lubrificaá∆o" ? "character" ? ? ? ? ? ? no ? no no "26.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttHistorico.cod-ccusto-alter
"cod-ccusto-alter" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"&IF DEFINED(bf_mnt_ems206b) &THEN ttHistorico.cod-unid-negoc &ELSE ttHistorico.cod_unid_negoc &ENDIF" "Unid Neg¢cio" "x(8)" ? ? ? ? ? ? ? no "C¢digo da Unidade de Neg¢cio
" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.ttHistorico.cd-tag
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _TblList          = "Temp-Tables.ttEvento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttEvento.cod-evento
     _FldNameList[2]   > "_<CALC>"
"fnDescricao(ttEvento.cod-evento,1,0) @ cDescCampo" "Descriá∆o" "x(35)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttEvento.cod-dia-mes-vencto
"ttEvento.cod-dia-mes-vencto" "Vencimento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttEvento.dat-inicial
     _FldNameList[5]   = Temp-Tables.ttEvento.dat-final
     _FldNameList[6]   > Temp-Tables.ttEvento.num-dia
"ttEvento.num-dia" "Antecipaá∆o" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.ttEvento.num-parcela
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _TblList          = "Temp-Tables.ttPlano"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttPlano.cod-plano
"ttPlano.cod-plano" "Plano" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescricao(ttPlano.cod-Plano,4,0) @ cDescCampo4" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttPlano.dat-inicial
     _FldNameList[4]   > Temp-Tables.ttPlano.dat-final
"ttPlano.dat-final" "Validade" ? "date" ? ? ? ? ? ? no "Data de Validade do plano no equipamento" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttPlano.val-km-inicial
     _FldNameList[6]   = Temp-Tables.ttPlano.val-km-real
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
OPEN QUERY {&SELF-NAME} FOR EACH ttMab-eqpto-caract NO-LOCK.
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
  if num-entries("brSon8":u) > 0 THEN
      if avail ttMab-eqpto-caract then do:
          get Current brSon8 no-lock.
          run buscaCatalogo in {&hDBOSon8} (input ttMab-eqpto-caract.cod-caract,
                                            output l-ok).
          if l-ok  then
              assign btVisSon8:sensitive in frame fPage8 = yes.
          else
        
              assign btVisSon8:sensitive in frame fPage8 = no.
      end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:

    RUN addRecord IN THIS-PROCEDURE (INPUT "abp/ab0138a.w":U). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    RUN pi-browse1 IN THIS-PROCEDURE(INPUT 1).

/*     IF RETURN-VALUE = "NOK":U THEN */
/*         RETURN NO-APPLY.           */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    RUN pi-browse3 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon4 wMasterDetail
ON CHOOSE OF btAddSon4 IN FRAME fPage4 /* Incluir */
DO:
    RUN pi-browse4 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAddSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon5 wMasterDetail
ON CHOOSE OF btAddSon5 IN FRAME fPage5 /* Incluir */
DO:
    RUN pi-browse5 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btAddSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon6 wMasterDetail
ON CHOOSE OF btAddSon6 IN FRAME fPage6 /* Incluir */
DO:
    RUN pi-browse6 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btAddSon7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon7 wMasterDetail
ON CHOOSE OF btAddSon7 IN FRAME fPage7 /* Incluir */
DO:
    RUN pi-browse7 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btAddSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon8 wMasterDetail
ON CHOOSE OF btAddSon8 IN FRAME fPage8 /* Incluir */
DO:
    RUN pi-browse8 IN THIS-PROCEDURE(INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    assign lCopia = yes.
        
    RUN copyRecord (INPUT "abp/ab0138a.w":U).    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCopySon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon3 wMasterDetail
ON CHOOSE OF btCopySon3 IN FRAME fPage3 /* Copiar */
DO:
    RUN pi-browse3 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    /** Customizaá∆o do delete record **/
    run piElimina in this-procedure.
/*     if return-value = "NOK":U then */
/*         return no-apply.           */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    RUN pi-browse1 IN THIS-PROCEDURE(INPUT 3). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    RUN pi-browse3 IN THIS-PROCEDURE(INPUT 4).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDeleteSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon4 wMasterDetail
ON CHOOSE OF btDeleteSon4 IN FRAME fPage4 /* Eliminar */
DO:
    RUN btDeleteSon4 IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDeleteSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon5 wMasterDetail
ON CHOOSE OF btDeleteSon5 IN FRAME fPage5 /* Eliminar */
DO:
    RUN pi-browse5 IN THIS-PROCEDURE(INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btDeleteSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon6 wMasterDetail
ON CHOOSE OF btDeleteSon6 IN FRAME fPage6 /* Eliminar */
DO:
    RUN pi-browse6 IN THIS-PROCEDURE(INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btDeleteSon7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon7 wMasterDetail
ON CHOOSE OF btDeleteSon7 IN FRAME fPage7 /* Eliminar */
DO:
    RUN pi-browse7 IN THIS-PROCEDURE(INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btDeleteSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon8 wMasterDetail
ON CHOOSE OF btDeleteSon8 IN FRAME fPage8 /* Eliminar */
DO:
    RUN pi-browse8 IN THIS-PROCEDURE(INPUT 3).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
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
   RUN pi-btHelp IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIntegraXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegraXML wMasterDetail
ON CHOOSE OF btIntegraXML IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).
    assign {&window-name}:sensitive = no.

    /*--- Executa programa de manutená∆o de filho ---*/
    run abp/ab0138j.w (input input frame fPage0 ttEqpto.ep-codigo,
                       input input frame fPage0 ttEqpto.cod-eqpto).

    assign {&window-name}:sensitive = yes.
    /*--- Seta cursor do mouse para normal ---*/
    session:set-wait-state("":U).
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btManut2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btManut2 wMasterDetail
ON CHOOSE OF btManut2 IN FRAME fPage2 /* Manutená∆o */
DO:
    RUN btManut2 IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMasterDetail
ON CHOOSE OF btMatriz IN FRAME fPage0
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

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage0.
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
    RUN pi-btSearch IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUnidNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUnidNegoc wMasterDetail
ON CHOOSE OF btUnidNegoc IN FRAME fPage3 /* Unid Negoc */
DO:
    IF AVAIL ttHistorico THEN DO:
        /*--- Seta cursor do mouse para espera ---*/
        SESSION:SET-WAIT-STATE("GENERAL":U).
    
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        IF lbgc  THEN DO:
            RUN abp/ab0138n.w (INPUT INPUT FRAME fPage0 ttEqpto.ep-codigo,
                               INPUT INPUT FRAME fPage0 ttEqpto.cod-eqpto).
        END.
        ELSE DO:
            RUN abp/ab0138l.w (INPUT INPUT FRAME fPage0 ttEqpto.ep-codigo,
                               INPUT INPUT FRAME fPage0 ttEqpto.cod-eqpto,
                               INPUT ttHistorico.dat-cadastro).
        END.
        /*--- Executa programa de manutená∆o de filho ---*/
      
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        /*--- Seta cursor do mouse para normal ---*/
        SESSION:SET-WAIT-STATE("":U).

        /** Habilita/Desabilita Botoes Unidade Negocio **/
        RUN piUnidNegoc IN THIS-PROCEDURE.

        APPLY "ENTRY":U TO btUnidNegoc IN FRAME fPage3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
        
    RUN updateRecord IN THIS-PROCEDURE (INPUT "abp/ab0138a.w":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
  RUN pi-browse1 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    RUN pi-browse3 IN THIS-PROCEDURE(INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btUpdateSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon4 wMasterDetail
ON CHOOSE OF btUpdateSon4 IN FRAME fPage4 /* Alterar */
DO:
    RUN pi-browse4 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdateSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon5 wMasterDetail
ON CHOOSE OF btUpdateSon5 IN FRAME fPage5 /* Alterar */
DO:
    RUN pi-browse5 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btUpdateSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon6 wMasterDetail
ON CHOOSE OF btUpdateSon6 IN FRAME fPage6 /* Alterar */
DO:
    RUN pi-browse6 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btUpdateSon7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon7 wMasterDetail
ON CHOOSE OF btUpdateSon7 IN FRAME fPage7 /* Alterar */
DO:
    RUN pi-browse7 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btUpdateSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon8 wMasterDetail
ON CHOOSE OF btUpdateSon8 IN FRAME fPage8 /* Alterar */
DO:
    RUN pi-browse8 IN THIS-PROCEDURE(INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisSon8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisSon8 wMasterDetail
ON CHOOSE OF btVisSon8 IN FRAME fPage8 /* Visualizar */
DO:
    RUN pi-btVisSon8 IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMasterDetail
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fPage0 /* Equipamento */
DO:
   RUN pi-Leave-cod-eqpto IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

RUN abp/ab01381.p PERSISTENT SET hprogFunc.

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
IF valid-handle(hprogFunc) THEN
    DELETE PROCEDURE hprogFunc.

IF VALID-HANDLE(hbofr057) THEN
    DELETE PROCEDURE hbofr057.

IF VALID-HANDLE(hbofr074) THEN
    DELETE PROCEDURE hbofr074.

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
    IF  AVAIL {&ttParent} THEN DO:
        IF  ttEqpto.cod-livre-2 <> "" THEN
            ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fPage0 = ttEqpto.cod-livre-2.
        ELSE
            ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fPage0 = "":U.

        /** Descriá∆o Modelo **/
        APPLY "LEAVE":U TO {&ttParent}.cod-eqpto IN FRAME fPage0.
    END.

    /** Habilita/ Desabilita Bot‰es de inclus∆o dos browses **/
    RUN piBotoes IN THIS-PROCEDURE.

    /** Verifica tipo do equipamento para combust°veis **/
    RUN piMotor IN THIS-PROCEDURE.

    ASSIGN lAtividade = NO.

    /** Verifica se foi cadastrado hist¢rico atividade **/
    IF  AVAIL {&ttParent} AND NOT AVAIL {&ttSon3} AND NOT(lCopia) THEN DO:
        ASSIGN lAtividade = YES.
        RUN setFolder IN hFolder (INPUT 3).
        APPLY "CHOOSE":U TO btAddSon3 IN FRAME fPage3.
    END.
    IF  lCopia THEN
        ASSIGN lCopia = NO.

    /** Habilita/Desabilita Botoes Unidade Negocio **/
    IF l-usa-unid-negoc THEN DO:
        RUN piUnidNegoc IN THIS-PROCEDURE.
    END.

    IF AVAIL {&ttParent} THEN 
        RUN piValidaSituacao IN THIS-PROCEDURE.

    RETURN "OK":U.
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
ASSIGN btUnidNegoc:SENSITIVE IN FRAME fPage3 = l-usa-unid-negoc
       btUnidNegoc:VISIBLE   IN FRAME fPage3 = l-usa-unid-negoc
       btMatriz:SENSITIVE    IN FRAME fPage0 = l-usa-unid-negoc
       btMatriz:VISIBLE      IN FRAME fPage0 = l-usa-unid-negoc.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN ttHistorico.cod-unid-negoc:VISIBLE IN BROWSE brSon3 = l-usa-unid-negoc.
&ENDIF

/** Habilita/Desabilita Botoes Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piUnidNegoc IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatriz:TOOLTIP    IN FRAME fPage0 = "":U
           btUnidNegoc:TOOLTIP IN FRAME fPage3 = "":U.

/** Habilita / Desabilita p†ginas do programa **/
IF  NOT CONNECTED("emsbas") OR 
    NOT CONNECTED("emsfin") OR 
    NOT CONNECTED("emsuni") THEN
    RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
ELSE
    RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).

run piPagina in this-procedure.

/** Verifica tipo do equipamento para combust°veis **/
run piMotor in this-procedure.

for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
    {utp/ut-liter.i Sim}
    if entry(2,mab-param-integr.des-valor) = return-value then do:
        assign btIntegraXML:visible in frame fPage0   = yes
               btIntegraXML:sensitive in frame fPage0 = yes.
    end.
    else do:
        assign btIntegraXML:visible in frame fPage0   = no
               btIntegraXML:sensitive in frame fPage0 = no.
    end.
end.

if not avail mab-param-integr then do:
    assign btIntegraXML:visible in frame fPage0   = no
           btIntegraXML:sensitive in frame fPage0 = no.
end.

IF AVAIL {&ttParent} THEN 
    RUN piValidaSituacao IN THIS-PROCEDURE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btDeleteSon4 wMasterDetail 
PROCEDURE btDeleteSon4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Verifica existància de apontamentos de eventos para programaá∆o do evento **/
get current brSon4.
run repositionRecord in {&hDBOSon4} (input {&ttSon4}.r-rowid).
run consisteEventos in {&hDBOSon4}.
if return-value = "WAR":U then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Busca erros na BO **/
    run getRowErrors in {&hDBOSon4} (output table RowErrors).
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in {&hDBOSon4}.
    empty temp-table RowErrors.
end.

/** MÇtodo padr∆o de eliminaá∆o **/
RUN pi-browse4 IN THIS-PROCEDURE(INPUT 3).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btManut2 wMasterDetail 
PROCEDURE btManut2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
assign {&window-name}:sensitive = no.

if avail {&ttSon2} then do:
    get current brSon2.
    assign rSon = {&ttSon2}.r-rowid.
end.

/*--- Executa programa de manutená∆o de filho ---*/
RUN abp/ab0138c.w (INPUT rSon,INPUT rCurrentParent,INPUT THIS-PROCEDURE).

assign {&window-name}:sensitive = yes.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

run piAtualizaCompartimento in this-procedure.

RETURN "OK":U.

END procedure.

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
         THREE-D SCROLLABLE TITLE "" FONT 1
         DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
{utp/ut-liter.i V†_Para_Equipamento *}
ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
    ASSIGN cep-codigo ccod-eqpto.
    
    /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
    RUN goToKey IN {&hDBOParent} (INPUT cep-codigo,
                                  input ccod-eqpto).
    IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-liter.i "Equipamento"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value). /**andre**/
        
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
/*--- Ab01381.p Inicializa as Procedures ---*/
IF NOT VALID-HANDLE(hprogFunc) OR
    hprogFunc:TYPE <> "PROCEDURE":U OR
    hprogFunc:FILE-NAME <> "abp/ab01381.p":U THEN DO:
    run abp/ab01381.p persistent set  hprogFunc.
end.

RUN openQueryStatic IN hprogFunc (INPUT "Main":U) NO-ERROR.

/*:T--- Verifica se o DBO j† est† inicializado ---*/
IF NOT VALID-HANDLE({&hDBOParent}) OR
    {&hDBOParent}:TYPE <> "PROCEDURE":U OR
    {&hDBOParent}:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
    run frbo/bofr007.p persistent set {&hDBOParent}.
end.

run openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

/*:T--- Verifica se o DBO j† est† inicializado Combust°vel ---*/
IF NOT VALID-HANDLE({&hDBOSon1}) OR 
    {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon1}:FILE-NAME <> "frbo/bofr014.p":U THEN DO:
    run frbo/bofr014.p persistent set {&hDBOSon1}.
end.

/*:T--- Verifica se o DBO j† est† inicializado Complemento ---*/
IF NOT VALID-HANDLE({&hDBOSon2}) OR
    {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon2}:FILE-NAME <> "frbo/bofr004.p":U THEN DO:
    run frbo/bofr004.p persistent set {&hDBOSon2}. 
end.

/*:T--- Verifica se o DBO j† est† inicializado Hist¢rico ---*/
IF NOT VALID-HANDLE({&hDBOSon3}) OR
    {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon3}:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
    run frbo/bofr013.p persistent set {&hDBOSon3}. 
end.

/*:T--- Verifica se o DBO j† est† inicializado Evento ---*/
if NOT VALID-HANDLE({&hDBOSon4}) OR
    {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon4}:FILE-NAME <> "frbo/bofr022.p":U THEN DO:
    run frbo/bofr022.p persistent set {&hDBOSon4}. 
end.

/*:T--- Verifica se o DBO j† est† inicializado Plano ---*/
IF NOT VALID-HANDLE({&hDBOSon5}) OR
    {&hDBOSon5}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon5}:FILE-NAME <> "frbo/bofr031.p":U THEN DO:
    run frbo/bofr031.p persistent set {&hDBOSon5}.
end.

/*:T--- Verifica se o DBO j† est† inicializado Eixo ---*/
IF NOT VALID-HANDLE({&hDBOSon6}) OR
    {&hDBOSon6}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon6}:FILE-NAME <> "frbo/bofr005.p":U THEN DO:
    run frbo/bofr005.p persistent set {&hDBOSon6}. 
end.

/*:T--- Verifica se o DBO j† est† inicializado Layout ---*/
IF NOT VALID-HANDLE({&hDBOSon7}) OR
    {&hDBOSon7}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon7}:FILE-NAME <> "frbo/bofr044.p":U THEN DO:
    run frbo/bofr044.p persistent set {&hDBOSon7}. 
end.

/*:T--- Verifica se o DBO j† est† inicializado Layout ---*/
IF NOT VALID-HANDLE({&hDBOSon8}) OR
    {&hDBOSon8}:TYPE <> "PROCEDURE":U OR
    {&hDBOSon8}:FILE-NAME <> "frbo/bofr097.p":U THEN DO:
    run frbo/bofr097.p persistent set {&hDBOSon8}. 
end.

/*--- DBO Modelo ---*/
IF NOT VALID-HANDLE(hDBOModelo) OR
    hDBOModelo:TYPE <> "PROCEDURE":U OR
    hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
    run frbo/bofr016.p persistent set  hDBOModelo.
end.

RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

IF NOT VALID-HANDLE (hbofr057) OR
    hbofr057:TYPE <> "PROCEDURE":U OR
    hbofr057:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
    run frbo/bofr057.p persistent set  hbofr057.
END.

IF NOT VALID-HANDLE (hbofr074) OR
    hbofr074:TYPE <> "PROCEDURE":U OR
    hbofr074:FILE-NAME <> "frbo/bofr074.p":U THEN DO:
    run frbo/bofr074.p persistent set  hbofr074.
END.

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

/** P†gina 2 **/
run piAtualizaCompartimento in this-procedure.

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
                               
/** Habilita/Desabilita Botoes Unidade Negocio **/
IF l-usa-unid-negoc THEN DO:
    RUN piUnidNegoc IN THIS-PROCEDURE.
END.
RUN verificarIntegracaoBgc IN THIS-PROCEDURE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse1 wMasterDetail 
PROCEDURE pi-browse1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        if {&ttparent}.idi-tip-eqpto = 1 then do:
            {masterdetail/addson.i &ProgramSon="abp/ab0138b.w"
                                   &PageNumber="1"}
        end.
        else do:
            run utp/ut-msgs.p (input "Show":U,
                               input 28502,
                               input {&ttParent}.cod-eqpto + '~~' + 
                                     string({&ttParent}.ep-codigo)).
            return "NOK":U.
        end.
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138b.w"
                                  &PageNumber="1"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="1"}
    END.
    

END CASE.

/* RETURN "OK":U. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse3 wMasterDetail 
PROCEDURE pi-browse3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = copiar, 3 = alterar, 4 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138d.w"
                               &PageNumber="3"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/copyson.i &ProgramSon="abp/ab0138d.w"
                                &PageNumber="3"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138d.w"
                                  &PageNumber="3"}
    END.
    WHEN 4 THEN DO:

        IF NUM-ENTRIES("brSon3":u) > 0 THEN DO:
            IF AVAIL ttHistorico THEN DO:
                GET CURRENT brSon3 NO-LOCK.

                ASSIGN cEmpAux         = ttHistorico.ep-codigo
                       cEqptoAux       = ttHistorico.cod-eqpto
                       cDatCadastroAux = DATE(ttHistorico.dat-cadastro)
                       cCodEstabel     = ttHistorico.cod-estabel
                       cCodUnidNegoc   = ttHistorico.cod-unid-negoc.

            END.
        END.

        run emptyRowErrors in {&hDBOSon3}.
        {masterdetail/deleteson.i &PageNumber="3"}
        /** Busca erros na BO **/
        run getRowErrors in {&hDBOSon3} (output table RowErrors).
        FOR EACH  RowErrors
            WHERE RowErrors.ErrorType = "INTERNAL":U EXCLUSIVE-LOCK:
            DELETE RowErrors.
        END.
        IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:

            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
        END.
        ELSE DO:

            FIND FIRST bfTtHistorico WHERE ttHistorico.ep-codigo        = cEmpAux
                                     AND ttHistorico.cod-eqpto          = cEqptoAux
                                     AND DATE(ttHistorico.dat-cadastro) = cDatCadastroAux
                                     AND ttHistorico.cod-estabel        = cCodEstabel       
                                     AND ttHistorico.cod-unid-negoc     = cCodUnidNegoc NO-ERROR.


            IF NOT AVAIL bfTtHistorico THEN DO: 

                RUN piValidaImplementos IN THIS-PROCEDURE (INPUT cEmpAux,
                                                           INPUT cEqptoAux,
                                                           INPUT cDatCadastroAux,
                                                           INPUT cCodEstabel,    
                                                           INPUT cCodUnidNegoc).
            END.
                                                  

        END.  
        
    END.

END CASE.

/** Habilita/Desabilita Botoes Unidade Negocio **/
IF l-usa-unid-negoc THEN DO:
    RUN piUnidNegoc IN THIS-PROCEDURE.
END.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse4 wMasterDetail 
PROCEDURE pi-browse4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138e.w"
                               &PageNumber="4"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138e.w"
                                  &PageNumber="4"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="4"}
    END.

END CASE.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse5 wMasterDetail 
PROCEDURE pi-browse5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138f.w"
                               &PageNumber="5"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138f.w"
                                  &PageNumber="5"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="5"}
    END.

END CASE.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse6 wMasterDetail 
PROCEDURE pi-browse6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138g.w"
                               &PageNumber="6"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138g.w"
                                  &PageNumber="6"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="6"}
    END.

END CASE.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse7 wMasterDetail 
PROCEDURE pi-browse7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138h.w"
                               &PageNumber="7"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138h.w"
                                  &PageNumber="7"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="7"}
    END.

END CASE.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-browse8 wMasterDetail 
PROCEDURE pi-browse8 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-acao as int (1 = incluir, 2 = alterar, 3 = eliminar)
  Notes:       criado para eliminar erros de compilacao em oracle.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

CASE p-acao:
    WHEN 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="abp/ab0138i.w"
                               &PageNumber="8"}
    END.
    WHEN 2 THEN DO:
        {masterdetail/updateson.i &ProgramSon="abp/ab0138i.w"
                                  &PageNumber="8"}
    END.
    WHEN 3 THEN DO:
        {masterdetail/deleteson.i &PageNumber="8"}
    END.

END CASE.

/* RETURN "OK":U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-btHelp wMasterDetail 
PROCEDURE pi-btHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 {include/ajuda.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-btSearch wMasterDetail 
PROCEDURE pi-btSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{method/zoomreposition.i &ProgramZoom="frzoom/z01fr007.w"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-btVisSon8 wMasterDetail 
PROCEDURE pi-btVisSon8 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if num-entries("brSon8":u) > 0 then do:
    get Current brSon8 no-lock.
    run visualizaDocto in {&hDBOSon8} (input ttMab-eqpto-caract.cod-caract,input ttMab-eqpto-caract.des-arquivo).
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Leave-cod-eqpto wMasterDetail 
PROCEDURE pi-Leave-cod-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign fiDescModelo:screen-value in frame fPage0 = "".

if avail ttEqpto then do:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="ttEqpto.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}
END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostraBem wMasterDetail 
PROCEDURE pi-mostraBem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pMostraBem as log no-undo.

    assign pMostraBem = not can-find(first ttHistorico).

    return "ok".
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
if can-find(first ttEqpto) then
    assign btAddSon1:sensitive in frame fPage1 = yes
           btManut2:sensitive  in frame fPage2 = yes
           btAddSon3:sensitive in frame fPage3 = yes
           btAddSon4:sensitive in frame fPage4 = yes
           btAddSon5:sensitive in frame fPage5 = yes
           btAddSon6:sensitive in frame fPage6 = yes
           btAddSon7:sensitive in frame fPage7 = yes
           btAddSon8:sensitive in frame fPage8 = yes.
else
    assign btAddSon1:sensitive in frame fPage1 = no
           btManut2:sensitive  in frame fPage2 = no
           btAddSon3:sensitive in frame fPage3 = no
           btAddSon4:sensitive in frame fPage4 = no
           btAddSon5:sensitive in frame fPage5 = no
           btAddSon6:sensitive in frame fPage6 = no
           btAddSon7:sensitive in frame fPage7 = no
           btAddSon8:sensitive in frame fPage8 = no.
    assign btVisSon8:sensitive in frame fPage8 = no.

    IF lBgc  THEN
        DISABLE btAddSon3 btCopySon3 btDeleteSon3 WITH FRAME fPage3.
    ELSE
        ENABLE btAddSon3 btCopySon3 btDeleteSon3 WITH FRAME fPage3.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescricao wMasterDetail 
PROCEDURE piDescricao :
/*------------------------------------------------------------------------------
  Purpose:     piReposiciona
  Parameters:  <none>
  Notes:       Reposiciona o programa utilizando o rowid corrente 
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodigo AS CHAR NO-UNDO.
DEF INPUT PARAM piDesc AS INT NO-UNDO.
DEF INPUT PARAM iTipo AS INT NO-UNDO.
DEF OUTPUT PARAM c-retorno AS CHAR NO-UNDO.

CASE piDesc:
    WHEN 1 THEN
        RUN pi-fnDescEvento IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 2 THEN
        RUN pi-fnDesLayout IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 3 THEN
        RUN pi-fnDescMaterial IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).        
    WHEN 4 THEN
        run pi-fnDescPlano IN hprogFunc (INPUT pCodigo, INPUT {&ttParent}.cod-model, output c-retorno).       
    WHEN 5 THEN
        RUN pi-fnDescSub IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 6 THEN
        RUN pi-fnRetorno IN hprogFunc (INPUT pCodigo, INPUT 1, INPUT-OUTPUT c-retorno).
    WHEN 7 THEN DO:
        IF  INT(pCodigo) = 0 THEN
            ASSIGN pCodigo = "1".
        run pi-fnDescConsumo IN hprogFunc (INPUT INT(pCodigo),OUTPUT c-retorno).
    END.
    WHEN 8 THEN
        run pi-fnDescComp IN hprogFunc (INPUT pCodigo,input iTipo,INPUT-OUTPUT c-retorno).
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piElimina wMasterDetail 
PROCEDURE piElimina :
/*------------------------------------------------------------------------------
  Purpose:     piElimina
  Parameters:  <none>
  Notes:       Substitui o deleteRecord padr∆o
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

/** Bloco de eliminaá∆o **/
equipamento:
    do transaction on error undo ,return "NOK":U on stop  undo ,return "NOK":U:
        run deleteRecord in this-procedure.
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
            undo equipamento, return "NOK":U.
        end.
end.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMasterDetail 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOParent} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOParent}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMotor wMasterDetail 
PROCEDURE piMotor :
/*------------------------------------------------------------------------------
  Purpose:     piMotor
  Parameters:  <none>
  Notes:       Verifica o tipo de equipamento para habilitar/desabilitar o 
               folder de combust°veis
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFolder AS INTEGER    NO-UNDO.

/** Verifica tipo de equipamento **/
if avail {&ttParent} then do:
    if {&ttparent}.idi-tip-eqpto = 2 then do:
        run getCurrentFolder in hFolder (output iFolder).
        if iFolder = 1 then
            run setFolder in hFolder (input 2).
        run setEnabled in hFolder (input 1,input false).
    end.
    ELSE
        run setEnabled in hFolder (input 1,input true).
end.
ELSE
    run setEnabled in hFolder (input 1,input true).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPagina wMasterDetail 
PROCEDURE piPagina :
/*------------------------------------------------------------------------------
  Purpose:     piPagina
  Parameters:  <none>
  Notes:       Habilita / Desabilita p†ginas do programa
------------------------------------------------------------------------------*/
/** Manutená∆o MecÉnica **/
run cdp/cd9902.p (input 3).
if return-value = "NOK":U then
   run setEnabled in hFolder (input 5, false).
else
   run setEnabled in hFolder (input 5, true).

/** Pneus **/
run cdp/cd9902.p (input 2).
if return-value = "NOK":U then
   run setEnabled in hFolder (input 7, false).
else
   run setEnabled in hFolder (input 7, true).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReposiciona wMasterDetail 
PROCEDURE piReposiciona :
/*------------------------------------------------------------------------------
  Purpose:     piReposiciona
  Parameters:  <none>
  Notes:       Reposiciona o programa utilizando o rowid corrente 
------------------------------------------------------------------------------*/
RUN repositionRecord IN THIS-PROCEDURE (INPUT {&ttParent}.r-rowid).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piUnidNegoc wMasterDetail 
PROCEDURE piUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF NUM-RESULTS("brSon3":U) = 0 THEN
            ASSIGN btUnidNegoc:SENSITIVE IN FRAME fPage3 = NO.
        ELSE
            ASSIGN btUnidNegoc:SENSITIVE IN FRAME fPage3 = YES.

        ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = CAN-FIND(FIRST mab-unid-negoc-eqpto
                                                             WHERE mab-unid-negoc-eqpto.ep-codigo = {&ttParent}.ep-codigo
                                                             AND   mab-unid-negoc-eqpto.cod-eqpto = {&ttParent}.cod-eqpto NO-LOCK).
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaImplementos wMasterDetail 
PROCEDURE piValidaImplementos :
/*------------------------------------------------------------------------------
  Purpose:     piValidaImplementos
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcEpCodigo     LIKE ttHistorico.ep-codigo.
    DEFINE INPUT PARAMETER pcCodEqpto     LIKE ttHistorico.cod-eqpto.
    DEFINE INPUT PARAMETER pcDatCadastro  LIKE ttHistorico.dat-cadastro.
    DEFINE INPUT PARAMETER pcCodEstabel   LIKE ttHistorico.cod-estabel.
    DEFINE INPUT PARAMETER pcCodUnidNegoc LIKE ttHistorico.cod-unid-negoc.

    DEFINE VARIABLE c-mgs-aux AS CHARACTER NO-UNDO.
    ASSIGN l-exibe-msg-implento = NO.

    /* Verifica se o Equipamento possui algum implemento na data da movimentaá∆o */
    FOR EACH bfMgf-eqpto-implto
        WHERE bfMgf-eqpto-implto.ep-codigo-eqpto = pcEpCodigo
          AND bfMgf-eqpto-implto.cod-eqpto       = pcCodEqpto
          AND (bfMgf-eqpto-implto.dat-inicial <= pcDatCadastro AND bfMgf-eqpto-implto.dat-final >= pcDatCadastro) NO-LOCK:
        ASSIGN l-exibe-msg-implento = YES.

        /* Verifica se o Implemente tem algum Hist¢rico a ser excluido */
        FOR FIRST bfMab-histor-ativid FIELDS(ep-codig cod-eqpto dat-cadastro cod-estabel cod-unid-negoc)
            WHERE bfMab-histor-ativid.ep-codigo = bfMgf-eqpto-implto.ep-codigo-implto 
              AND bfMab-histor-ativid.cod-eqpto = bfMgf-eqpto-implto.cod-implto 
              AND bfMab-histor-ativid.dat-cadastro = pcDatCadastro NO-LOCK:

            IF bfMab-histor-ativid.cod-estabel <> pcCodEstabel THEN DO:
                IF l-usa-unid-negoc AND bfMab-histor-ativid.cod-unid-negoc <> pcCodUnidNegoc THEN
                    ASSIGN l-exibe-msg-implento = NO.

                ASSIGN l-exibe-msg-implento = NO.
            END.
        END.
        IF NOT AVAIL bfMab-histor-ativid THEN
            ASSIGN l-exibe-msg-implento = NO.
                                              

        IF l-exibe-msg-implento THEN
            LEAVE.

    END. 

    IF  l-exibe-msg-implento THEN DO:
        ASSIGN c-mgs-aux = String(bfMgf-eqpto-implto.ep-codigo-eqpto) + '~~' + bfMgf-eqpto-implto.cod-eqpto. 

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 54010,
                           INPUT c-mgs-aux).

        IF  RETURN-VALUE = 'yes':U THEN DO:
            EMPTY TEMP-TABLE ttImptoAtualizados.

            RUN piExcluiMovtoImplto IN hDBOHistorico (INPUT pcEpCodigo,
                                                      INPUT pcCodEqpto,
                                                      INPUT pcDatCadastro,
                                                      INPUT pcCodEstabel,
                                                      INPUT pcCodUnidNegoc,
                                                      OUTPUT TABLE ttImptoAtualizados,
                                                      OUTPUT TABLE RowErrorsImplto).

            IF CAN-FIND (FIRST RowErrorsImplto NO-LOCK) THEN DO:

                /*limpa RowErrors para que n∆o haja lixo na proxima vez que executar*/
                EMPTY TEMP-TABLE RowErrors.

                FOR EACH RowErrorsImplto NO-LOCK:
                    CREATE RowErrors.
                    BUFFER-COPY RowErrorsImplto TO RowErrors.
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
                RUN utp/ut-msgs.p (INPUT "SHOW",
                        INPUT 54017,
                        INPUT c-mgs-aux).

                RETURN "OK":U.

            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSituacao wMasterDetail 
PROCEDURE piValidaSituacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-mab-sit-eqpto FOR mab-sit-eqpto.
    FOR FIRST bf-mab-sit-eqpto NO-LOCK where bf-mab-sit-eqpto.cod-sit-eqpto = {&ttParent}.cod-sit-eqpto:
        IF bf-mab-sit-eqpto.idi-tip = 2 THEN DO:
            ASSIGN btAddSon3:sensitive    in frame fPage3 = NO
                   btCopySon3:sensitive   in frame fPage3 = NO
                   btUpdateSon3:sensitive in frame fPage3 = NO
                   btDeleteSon3:sensitive in frame fPage3 = NO
                   btUnidNegoc:sensitive  in frame fPage3 = NO.
        END.
    END.	
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (pCodigo AS CHAR, piDesc AS INT, iTipo AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS CHARACTER  NO-UNDO.

ASSIGN c-retorno = "":U.

RUN piDescricao IN THIS-PROCEDURE (INPUT pCodigo, INPUT piDesc, INPUT iTipo, OUTPUT c-retorno).
/*Rafael
CASE piDesc:
    WHEN 1 THEN
        RUN pi-fnDescEvento IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 2 THEN
        RUN pi-fnDesLayout IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 3 THEN
        RUN pi-fnDescMaterial IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 4 THEN
        run pi-fnDescPlano IN hprogFunc (INPUT pCodigo, INPUT {&ttParent}.cod-model, output c-retorno).
    WHEN 5 THEN
        RUN pi-fnDescSub IN hprogFunc (INPUT pCodigo, INPUT-OUTPUT c-retorno).
    WHEN 6 THEN
        RUN pi-fnRetorno IN hprogFunc (INPUT pCodigo, INPUT 1, INPUT-OUTPUT c-retorno).
    WHEN 7 THEN
        run pi-fnDescConsumo IN hprogFunc (INPUT INT(pCodigo),OUTPUT c-retorno).
    WHEN 8 THEN
        run pi-fnDescComp IN hprogFunc (INPUT pCodigo,input iTipo,INPUT-OUTPUT c-retorno).
END CASE.
*/

RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fntraducao wMasterDetail 
FUNCTION fntraducao RETURNS CHARACTER
  ( l-traducao AS LOG) :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaBgc wMasterDetail 
PROCEDURE verificaBgc:
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  <none>
  Notes:utilizada pelo ab0138d para habilitar desabiltar Unidade 
  de negocio ao modificar um registro.   
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER lBgcAux          AS LOG INIT NO NO-UNDO.

    ASSIGN lBgcAux = lBgc.

    RETURN "OK":U.
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificarIntegracaoBgc wMasterDetail 
PROCEDURE verificarIntegracaoBgc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-bgc-ems-5.00" AND funcao.ativo)THEN DO:

         FIND LAST ttHistorico NO-LOCK NO-ERROR.
         IF l-integra-mab THEN DO:
              RUN verificarIntegracaoBgc IN hbofr057 (INPUT ttEqpto.ep-codigo,
                                                      INPUT IF AVAIL ttHistorico THEN ttHistorico.cod-estabel ELSE "",
                                                      INPUT ttEqpto.cod-eqpto,
                                                      OUTPUT lBgc).
         END.
    
         IF l-integra-mpn AND lBgc = NO THEN DO:
              RUN verificarIntegracaoBgc IN hbofr074 (INPUT ttEqpto.ep-codigo,
                                                      INPUT IF AVAIL ttHistorico THEN ttHistorico.cod-estabel ELSE "",
                                                      INPUT ttEqpto.cod-eqpto,
                                                      OUTPUT lBgc).
         END.
    END.

    IF lBgc  THEN
        DISABLE btAddSon3 btCopySon3 btDeleteSon3 WITH FRAME fPage3.
    ELSE
        ENABLE btAddSon3 btCopySon3 btDeleteSon3 WITH FRAME fPage3.

return "OK":U.

END PROCEDURE.
