&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
                    
/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0710 2.00.00.021 } /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0710 MIM}
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

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

&IF '{&mguni_version}' < '2.06f' &THEN
    /*Tecnica para implementar validaá∆o produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0710
&GLOBAL-DEFINE Version        2.00.00.021
&GLOBAL-DEFINE VersionLayout  001

     
&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Layout,ParÉmetros,Impress∆o

&GLOBAL-DEFINE PGLAY          YES
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE ttTable        tt-embarque-imp
&GLOBAL-DEFINE hDBOTable      h-bocx220
&GLOBAL-DEFINE DBOTable       embarque-imp

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2 ~
                              btIntegra 
/*                               btIntegra-2 */
&GLOBAL-DEFINE page1Widgets   edLayout ~
                              btEdit
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile
                              
&GLOBAL-DEFINE page5Widgets   
                              
                              
                              
                              
                              
&GLOBAL-DEFINE page6Widgets   
                              
                              
                              
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada 
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-destino text-modo


&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields     
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields   cIniEstab ~
                             cIniEmb   ~
                             i-tipo    ~
                             c-cd-via-transp ~
                             cInputFile ~
                             c-usuario ~
                             c-nat-operacao rs-tipo c-diretorio
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields   cDestinyFile

&GLOBAL-DEFINE DBOVersion 1.1

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    FIELD arq-entrada      AS CHAR FORMAT "x(35)"
    field arq-destino      as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD estab-ini        LIKE estabelec.cod-estabel 
    FIELD embarque         LIKE embarque-imp.embarque
    FIELD via-transporte   AS INTEGER 
    FIELD tipo-decl        AS INTEGER
    FIELD nat-operacao     LIKE natur-oper.nat-operacao
    FIELD tipo             AS INTEGER
    FIELD diretorio        AS CHAR FORMAT "x(60)".

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
def var h-bocx220a         as handle  no-undo.
def var h-bocx225          as handle  no-undo.

DEF VAR c-via-transp       AS CHAR FORMAT "x(15)" NO-UNDO.

DEFINE VARIABLE c-lista-itens AS CHARACTER FORMAT "x(100)" NO-UNDO.

DEFINE VARIABLE c-lista AS CHARACTER FORMAT "x(100)" EXTENT 10 
    INITIAL ["Mar°tima,Fluvial,Lacustre,AÇrea,Postal,Ferrovi†rio,Rodovi†rio,Tubo Conduto,Meios Pr¢prios,Entrada Ficta"].

DEFINE VARIABLE c-lista-declaracao AS CHARACTER FORMAT "x(100)" EXTENT 27 
INITIAL ["Consumo",
"Admiss∆o em Entreposto Aduaneiro",
"Admiss∆o em EIZOF - Entreposto Internacional da ZFM",
"Admiss∆o em Entreposto Industrial",
"Admiss∆o Tempor†ria",
"Admiss∆o na ZFM - Zona Franca de Manaus",
"Admiss∆o em Loja Franca",
"Admiss∆o em ALC - µrea de Livre ComÇrcio",
"Admiss∆o em DAD - Dep¢sito Aduaneiro de Distribuiá∆o",
"Admiss∆o em DEA - Dep¢sito Especial Alfandegado",
"Admiss∆o em ZPE - Zona de Processamento de Exportaá∆o",
"Consumo e Admiss∆o Tempor†ria",
"Nacionalizaá∆o de Admiss∆o Tempor†ria",
"Nacionalizaá∆o de Entreposto Aduaneiro",
"Sa°da de EIZOF - Entreposto Internacional da ZFM",
"Sa°da de Entreposto Industrial",
"Nacionalizaá∆o de DEA - Dep¢sito Especial Alfandegado",
"Nacionalizaá∆o de DAD - Dep¢sito Aduaneiro de Distribuiá∆o",
"Internaá∆o de ZFM-PI - Zona Franca de Manaus (Produto Industrializado)",
"Internaá∆o de ZFM-PE - Zona Franca de Manaus (Produto Estrangeiro)",
"Internaá∆o de ALC - µrea de Livre ComÇrcio",
"Internaá∆o da ZPE - Zona de Processamento de Exportaá∆o",
"Transferància da ZFM (produto industrial)  para ALC",
"Transferància da ZFM (produto estrangeiro) para ALC",
"Transferància da ZFM (produto industrial)  para ZPE",
"Transferància da ZFM (produto estrangeiro) para ZPE",
"Transferància da ALC (produto estrangeiro) para ZFM"].

def stream s-imp.

DEFINE VARIABLE h-boad107    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx220    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx220f   AS HANDLE NO-UNDO.
&IF '{&mgdis_version}' >= '2.06f' &THEN
    DEFINE VARIABLE h-bofn017 as handle no-undo.
&ELSE
    DEFINE VARIABLE h-boun178    AS HANDLE NO-UNDO.
&ENDIF
DEFINE VARIABLE h-boin245    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx230    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx230a   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin292    AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEF VAR i-seq AS INTEGER FORMAT "99" NO-UNDO.
DEF VAR i-dia AS INTEGER FORMAT "99" NO-UNDO.
DEF VAR i-mes AS INTEGER FORMAT "99" NO-UNDO.
DEF VAR i-ano AS INTEGER FORMAT "99" NO-UNDO.

DEF VAR i-cod-via-transp LIKE embarque-imp.cod-via-transp NO-UNDO.

DEF VAR c-return LIKE usuar_mestre.nom_dir_spool NO-UNDO.

DEF VAR i-cod-itinerario  AS INT     NO-UNDO.
DEF VAR i-pto-desembarque AS INT     NO-UNDO.
DEF VAR data-efetiva      AS DATE    NO-UNDO.
DEF VAR c-cod-estabel     AS CHAR    NO-UNDO.
DEF VAR c-usur            AS CHAR    NO-UNDO.
DEF VAR c-nat-oper        AS CHAR    NO-UNDO.
DEF VAR c-embarque        LIKE embarque-imp.embarque  NO-UNDO.
DEF VAR os-file           AS CHAR FORMAT "x(60)" LABEL "File" NO-UNDO.
DEF VAR c-erro1           AS CHAR    NO-UNDO.
DEF VAR c-erro2           AS CHAR    NO-UNDO.
def var c-pasta           as char    no-undo.
def var l-cancelado       as logical no-undo.

DEFINE VARIABLE positions AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE cBarra    AS CHARACTER FORMAT "x"     NO-UNDO.
DEFINE VARIABLE found     AS INTEGER                  NO-UNDO.
DEFINE VARIABLE loop      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE start     AS INTEGER                  NO-UNDO.

DEFINE VARIABLE i-position AS INTEGER  NO-UNDO.

&if "{&EMSFND_VERSION}" >= "1.00" &then
  &else
    &IF '{&mguni_version}' >= '2.06f' &THEN
        &GLOBAL-DEFINE USUAR_PREFER             usuar_prefer
        &GLOBAL-DEFINE USUAR_PREFER.COD_PREFER  usuar_prefer.cod_pref
        &GLOBAL-DEFINE USUAR_PREFER.COD_LIVRE_1 usuar_prefer.cod_livre_1
    &ELSE
        &GLOBAL-DEFINE USUAR_PREFER             usuar_pref
        &GLOBAL-DEFINE USUAR_PREFER.COD_PREFER  usuar_pref.cod_preference
        &GLOBAL-DEFINE USUAR_PREFER.COD_LIVRE_1 usuar_pref.char-1
    &ENDIF
&endif

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btIntegra btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btIntegra 
     LABEL "Integraá∆o" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btEdit 
     LABEL "Editar Layout" 
     SIZE 20 BY 1
     FONT 1.

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 11.33
     FONT 2 NO-UNDO.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-cd-via-transp AS CHARACTER FORMAT "X(256)" INITIAL "Mar°tima" 
     LABEL "Via Transp." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mar°tima","Fluvial","Lacustre","AÇrea","Postal","Ferrovi†rio","Rodovi†rio","Tubo Conduto","Meios Pr¢prios","Entrada Ficta" 
     DROP-DOWN-LIST
     SIZE 22 BY 1.

DEFINE VARIABLE i-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Consumo" 
     LABEL "Tipo Declaraá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Consumo","Admiss∆o em Entreposto Aduaneiro","Admiss∆o em EIZOF - Entreposto Internacional da ZFM","Admiss∆o em Entreposto Industrial","Admiss∆o Tempor†ria","Admiss∆o na ZFM - Zona Franca de Manaus","Admiss∆o em Loja Franca","Admiss∆o em ALC - µrea de Livre ComÇrcio","Admiss∆o em DAD - Dep¢sito Aduaneiro de Distribuiá∆o","Admiss∆o em DEA - Dep¢sito Especial Alfandegado","Admiss∆o em ZPE - Zona de Processamento de Exportaá∆o","Consumo e Admiss∆o Tempor†ria","Nacionalizaá∆o de Admiss∆o Tempor†ria","Nacionalizaá∆o de Entreposto Aduaneiro","Sa°da de EIZOF - Entreposto Internacional da ZFM","Sa°da de Entreposto Industrial","Nacionalizaá∆o de DEA - Dep¢sito Especial Alfandegado","Nacionalizaá∆o de DAD - Dep¢sito Aduaneiro de Distribuiá∆o","Internaá∆o de ZFM-PI - Zona Franca de Manaus (Produto Industrializado)","Internaá∆o de ZFM-PE - Zona Franca de Manaus (Produto Estrangeiro)","Internaá∆o de ALC - µrea de Livre ComÇrcio","Internaá∆o da ZPE - Zona de Processamento de Exportaá∆o","Transferància da ZFM (produto industrial)  para ALC","Transferància da ZFM (produto estrangeiro) para ALC","Transferància da ZFM (produto industrial)  para ZPE","Transferància da ZFM (produto estrangeiro) para ZPE","Transferància da ALC (produto estrangeiro) para ZFM" 
     DROP-DOWN-LIST
     SIZE 53.86 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-diretorio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Banco Access" 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Operaá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio Recebimento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE ciniEmb AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cIniEstab LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo Siscomex:" 
      VIEW-AS TEXT 
     SIZE 13 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ordem/Item", 1,
"NCM", 2,
"Adiá∆o", 3
     SIZE 33.72 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.72 BY 1.25.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE .14 BY .79
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 1.71.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 2.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btIntegra AT ROW 16.75 COL 12
     btCancel AT ROW 16.75 COL 22.14
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.13
         FONT 1.

DEFINE FRAME fPage4
     c-nome AT ROW 6.33 COL 29.86 COLON-ALIGNED NO-LABEL
     ciniEmb AT ROW 1.33 COL 16.57 COLON-ALIGNED HELP
          "Informe o embarque"
     cIniEstab AT ROW 2.33 COL 16.57 COLON-ALIGNED
          LABEL "Estabelecimento":R7
          FONT 1
     c-desc-estab AT ROW 2.33 COL 24 COLON-ALIGNED NO-LABEL
     i-tipo AT ROW 3.33 COL 16.57 COLON-ALIGNED HELP
          "Informe o tipo de declaraá∆o"
     c-cd-via-transp AT ROW 4.33 COL 16.57 COLON-ALIGNED HELP
          "Informe a via de transporte"
     cInputFile AT ROW 5.33 COL 18.57 HELP
          "Nome do arquivo que ser† importado no Siscomex" NO-LABEL
     btInputFile AT ROW 5.38 COL 58.86 HELP
          "Escolha do nome do arquivo"
     c-usuario AT ROW 6.33 COL 16.57 COLON-ALIGNED HELP
          "Informe o usu†rio do recebimento"
     c-nat-operacao AT ROW 7.33 COL 16.57 COLON-ALIGNED HELP
          "Informe a natureza da operaá∆o"
     c-desc-natur AT ROW 7.33 COL 23.86 COLON-ALIGNED NO-LABEL
     c-diretorio AT ROW 8.33 COL 16.57 COLON-ALIGNED HELP
          "Informe o caminho e no nome do banco access"
     rs-tipo AT ROW 9.58 COL 19.29 NO-LABEL
     text-entrada AT ROW 5.5 COL 5.57 NO-LABEL
     "Agrupar:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 9.38 COL 12.43
     RECT-12 AT ROW 9.33 COL 18.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1.

DEFINE FRAME fPage7
     rsDestiny AT ROW 2.42 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btDestinyFile AT ROW 3.63 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 3.67 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.79 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     rsAll AT ROW 5.96 COL 41 NO-LABEL
     text-destino AT ROW 1.67 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.04 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 5.33 COL 2
     RECT-8 AT ROW 1.96 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 NO-LABEL
     btEdit AT ROW 12.58 COL 1 HELP
          "Dispara a Impress∆o do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.13
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report~/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
ASSIGN 
       btInputFile:HIDDEN IN FRAME fPage4           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natur IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cIniEstab IN FRAME fPage4
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
ASSIGN 
       cInputFile:HIDDEN IN FRAME fPage4           = TRUE.

/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:HIDDEN IN FRAME fPage4           = TRUE
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo Siscomex:".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       rsAll:HIDDEN IN FRAME fPage7           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
   {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEdit wReport
ON CHOOSE OF btEdit IN FRAME fPage1 /* Editar Layout */
DO:
   {report/imedl.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
    run utp/ut-dir.p (input return-value, output c-pasta, output l-cancelado).

    if l-cancelado = no then do:
        assign cInputFile = c-pasta.
        disp cInputFile with frame fpage4.
    end.
    /*{report/imarq.i cInputFile fPage4}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btIntegra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegra wReport
ON CHOOSE OF btIntegra IN FRAME fpage0 /* Integraá∆o */
DO:
    DEFINE VARIABLE comm-line AS CHARACTER FORMAT "x(70)".
    DEFINE VARIABLE v-caminho AS CHARACTER FORMAT "x(70)".
    DEFINE VARIABLE v-docto AS CHARACTER FORMAT "x(70)".
    DEFINE VARIABLE i AS INTEGER NO-UNDO.    

    ASSIGN INPUT FRAME fpage4 cInputFile
           INPUT FRAME fpage4 c-diretorio.
   
    do on error undo, return no-apply:
       run piverificabanco.
    end.
  
    v-caminho = PROPATH.

    repeat i = 1 to 10:
        v-docto = ENTRY(i,v-caminho) + '~\imp~\im0711.exe' no-error.
        assign file-info:file-name = v-docto.
        if file-info:pathname <> ? then do:        
           ASSIGN comm-line = v-docto.
           leave.
        end.
    END.

    ASSIGN comm-line = comm-line + " " + cInputFile + " " + c-diretorio.
    OS-COMMAND SILENT VALUE (comm-line).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON F5 OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="c-nat-operacao"
                         &Frame1="fPage4"
                         &FieldZoom2="denominacao"
                         &FieldScreen2="c-desc-natur"
                         &Frame2="fPage4"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON LEAVE OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
  RUN gotokey IN h-boin245 (INPUT c-nat-operacao:SCREEN-VALUE IN FRAME fpage4 ).
  IF RETURN-VALUE = "OK" THEN DO:
     RUN getcharField IN h-boin245 (INPUT "denominacao", OUTPUT c-desc-natur).
  END.
  ELSE ASSIGN c-desc-natur = "".
  DISP c-desc-natur WITH FRAME fpage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON F5 OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
    
    {include/zoomvar.i &prog-zoom="inZoom/z01in292.w"
                         &campo=c-usuario
                         &campozoom=usuario
                         &campo2=c-nome
                         &campozoom=nome
                         &FRAME="fPage4"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON LEAVE OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
    /*VALIDAÄ«O USUµRIO*/ 
    RUN gotokey IN h-boin292 (INPUT INPUT FRAME fpage4 c-usuario).
    IF RETURN-VALUE = "OK" THEN 
    DO:
        RUN getcharField IN h-boin292 (INPUT "nome", OUTPUT c-nome).
        DISP c-nome WITH FRAME fpage4.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON MOUSE-SELECT-DBLCLICK OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ciniEmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ciniEmb wReport
ON F5 OF ciniEmb IN FRAME fPage4 /* Embarque */
DO:
  
        {method/zoomfields.i &ProgramZoom="cxzoom/z02cx220.w"
                             &FieldZoom1="embarque"
                             &FieldScreen1="ciniEmb"
                             &Frame1="fPage4"
                             &FieldZoom2="cod-estabel"
                             &FieldScreen2="ciniEstab"
                             &Frame2="fPage4"
                             &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ciniEmb wReport
ON LEAVE OF ciniEmb IN FRAME fPage4 /* Embarque */
DO:
    FIND FIRST embarque-imp NO-LOCK                                                   
         WHERE embarque-imp.embarque = cIniEmb:SCREEN-VALUE IN FRAME fpage4 NO-ERROR. 
    IF AVAIL embarque-imp THEN                                                        
       ASSIGN cIniestab:SCREEN-VALUE IN FRAME fpage4= embarque-imp.cod-estabel.       
    
    RUN pi-vld-siscomex.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ciniEmb wReport
ON MOUSE-SELECT-DBLCLICK OF ciniEmb IN FRAME fPage4 /* Embarque */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cIniEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cIniEstab wReport
ON F5 OF cIniEstab IN FRAME fPage4 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom="adZoom/z01ad107.w"
                       &campo="cIniEstab"
                       &campozoom="cod-estabel"
                       &campo2="c-desc-estab"
                       &campozoom2="nome"
                       &FRAME="fPage4"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cIniEstab wReport
ON LEAVE OF cIniEstab IN FRAME fPage4 /* Estabelecimento */
DO:
    RUN pi-output-campos.
    
    i-dia = DAY(TODAY).
    i-mes = MONTH(TODAY).
    i-ano = YEAR(TODAY).

    &IF '{&mgdis_version}' >= '2.06f' &THEN
        RUN gotokey IN h-bofn017 (INPUT c-seg-usuario).
        IF RETURN-VALUE = "OK" THEN DO:
           RUN getcharField IN h-bofn017 (INPUT "nom_dir_spool", OUTPUT c-return).
           IF c-return <> "" THEN DO:
              ASSIGN cinputfile = trim(c-return) + "/" + INPUT FRAME fpage4 cIniEmb + "_" + 
                                  STRING(i-dia,"99") + STRING(i-mes,"99") + STRING(i-ano,"9999") + ".txt".
    
           END.
        END.
    &ELSE
        RUN findsrmstr_id IN h-boun178 (INPUT c-seg-usuario, OUTPUT c-return).
        IF c-return = "" THEN DO:
           RUN getcharField IN h-boun178 (INPUT "nom_dir_spool", OUTPUT c-return).
           IF c-return <> "" THEN DO:
              ASSIGN cinputfile = trim(c-return) + "/" + INPUT FRAME fpage4 cIniEmb + "_" + 
                                  STRING(i-dia,"99") + STRING(i-mes,"99") + STRING(i-ano,"9999") + ".txt".
    
           END.
        END.
    &ENDIF

    DISP cinputfile WITH FRAME fpage4.
    RUN pi-vld-siscomex.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cIniEstab wReport
ON MOUSE-SELECT-DBLCLICK OF cIniEstab IN FRAME fPage4 /* Estabelecimento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2" then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/
cIniEstab:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
cIniEmb:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-nat-operacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-usuario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.

{imp/im0100b.i3 ERROR}

{report/mainblock.i}

ON "~\" OF cInputFile IN FRAME fPage4 DO:
    APPLY "/" TO cInputFile IN FRAME fPage4.
    RETURN NO-APPLY.
END.

ON "~\" OF c-diretorio IN FRAME fPage4 DO:
    APPLY "/" TO c-diretorio IN FRAME fPage4.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE (h-boad107) THEN
     DELETE PROCEDURE h-boad107.
  &IF '{&mgdis_version}' >= '2.06f' &THEN
      IF VALID-HANDLE (h-bofn017) THEN
         DELETE PROCEDURE h-bofn017.
  &ELSE
      IF VALID-HANDLE (h-boun178) THEN
         DELETE PROCEDURE h-boun178.
  &ENDIF
  IF VALID-HANDLE (h-bocx220) THEN
     DELETE PROCEDURE h-bocx220.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-boad107) OR
       h-boad107:TYPE <> "PROCEDURE":U OR
       h-boad107:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
      {btb/btb008za.i1 adbo/boad107na.p YES}
      {btb/btb008za.i2 adbo/boad107na.p '' h-boad107} 
    END.

    RUN openQueryStatic IN h-boad107 (INPUT "Main":U) NO-ERROR.
    
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx230) OR
       h-bocx230:TYPE <> "PROCEDURE":U OR
       h-bocx230:FILE-NAME <> "cxbo/bocx230.p":U THEN DO:
      {btb/btb008za.i1 cxbo/bocx230.p YES}
      {btb/btb008za.i2 cxbo/bocx230.p '' h-bocx230} 
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN h-bocx230 (INPUT 1).
    &ELSE
        RUN openQueryStatic IN h-bocx230 (INPUT "Main":U) NO-ERROR.
    &ENDIF
    
   IF NOT VALID-HANDLE(h-bocx230a) OR
       h-bocx230a:TYPE <> "PROCEDURE":U OR
       h-bocx230a:FILE-NAME <> "cxbo/bocx230a.p":U THEN DO:
      {btb/btb008za.i1 cxbo/bocx230a.p YES}
      {btb/btb008za.i2 cxbo/bocx230a.p '' h-bocx230a} 
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN h-bocx230a (INPUT 1).
    &ELSE
        RUN openQueryStatic IN h-bocx230a (INPUT "Main":U) NO-ERROR.
    &ENDIF
    
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx115) OR
       h-bocx115:TYPE <> "PROCEDURE":U OR
       h-bocx115:FILE-NAME <> "cxbo/bocx115.p":U THEN DO:
       {btb/btb008za.i1 cxbo/bocx115.p YES}
       {btb/btb008za.i2 cxbo/bocx115.p '' h-bocx115} 
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN h-bocx115 (INPUT 1).
    &ELSE
        RUN openQueryStatic IN h-bocx115 (INPUT "Main":U) NO-ERROR.
    &ENDIF


    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx220) OR
       h-bocx220:TYPE <> "PROCEDURE":U OR
       h-bocx220:FILE-NAME <> "cxbo/bocx220.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220.p YES}
        {btb/btb008za.i2 cxbo/bocx220.p '' h-bocx220} 
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN h-bocx220 (INPUT 1).
    &ELSE
        RUN openQueryStatic IN h-bocx220 (INPUT "Main":U) NO-ERROR.
    &ENDIF
    
      /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx220f) OR
       h-bocx220f:TYPE <> "PROCEDURE":U OR
       h-bocx220f:FILE-NAME <> "cxbo/bocx220f.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220f.p YES}
        {btb/btb008za.i2 cxbo/bocx220f.p '' h-bocx220f} 
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN h-bocx220f (INPUT 1).
    &ELSE
        RUN openQueryStatic IN h-bocx220f (INPUT "Main":U) NO-ERROR.
    &ENDIF


    /*--- Verifica se o DBO j† est† inicializado ---*/
    
    &IF '{&mgdis_version}' >= '2.06f' &THEN
        IF NOT VALID-HANDLE(h-bofn017) OR
           h-bofn017:TYPE <> "PROCEDURE":U OR
           h-bofn017:FILE-NAME <> "fnbo/bofn017.p":U THEN DO:
            {btb/btb008za.i1 fnbo/bofn017.p YES}
            {btb/btb008za.i2 fnbo/bofn017.p '' h-bofn017} 
        END.
    
        RUN openQueryStatic IN h-bofn017 (INPUT "Main":U).
       
     &ELSE
        IF NOT VALID-HANDLE(h-boun178) OR
           h-boun178:TYPE <> "PROCEDURE":U OR
           h-boun178:FILE-NAME <> "unbo/boun178.p":U THEN DO:
            {btb/btb008za.i1 unbo/boun178.p YES}
            {btb/btb008za.i2 unbo/boun178.p '' h-boun178} 
        END.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
            RUN openQuery IN h-boun178 (INPUT 1).
        &ELSE
            RUN openQueryStatic IN h-boun178 (INPUT "Main":U).
        &ENDIF
     &ENDIF
     
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-boin245) OR
       h-boin245:TYPE <> "PROCEDURE":U OR
       h-boin245:FILE-NAME <> "inbo/boin245na.p":U THEN DO:
      {btb/btb008za.i1 inbo/boin245na.p YES}
      {btb/btb008za.i2 inbo/boin245na.p '' h-boin245} 
    END.

    RUN openQueryStatic IN h-boin245 (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-boin292) OR
       h-boin292:TYPE <> "PROCEDURE":U OR
       h-boin292:FILE-NAME <> "inbo/boin292.p":U THEN DO:
      {btb/btb008za.i1 inbo/boin292.p YES}
      {btb/btb008za.i2 inbo/boin292.p '' h-boin292} 
    END.

    RUN openQueryStatic IN h-boin292 (INPUT "Main":U) NO-ERROR.

  &if "{&EMSFND_VERSION}" >= "1.00" &then
  &else
  
    FIND FIRST {&USUAR_PREFER} NO-LOCK
         WHERE {&USUAR_PREFER}.cod_usuario    = c-seg-usuario 
           AND {&USUAR_PREFER}.cod_prog_dtsul = c-programa-mg97
           AND {&USUAR_PREFER.COD_PREFER}     = "" NO-ERROR.

    IF AVAIL {&USUAR_PREFER} THEN DO:

       ASSIGN cIniEmb          =     ENTRY(1,{&USUAR_PREFER.COD_LIVRE_1})
              cIniEstab        =     ENTRY(2,{&USUAR_PREFER.COD_LIVRE_1})
              i-tipo           =     {imp/im0710i2.i 04 INT(ENTRY(3,{&USUAR_PREFER.COD_LIVRE_1}))}
              c-cd-via-transp  =     {imp/im0710.i 04 INT(ENTRY(4,{&USUAR_PREFER.COD_LIVRE_1}))}
              cInputFile       =     ENTRY(5,{&USUAR_PREFER.COD_LIVRE_1})
              c-usuario        =     ENTRY(6,{&USUAR_PREFER.COD_LIVRE_1})
              c-nat-operacao   =     ENTRY(7,{&USUAR_PREFER.COD_LIVRE_1})
              rs-tipo          =     INT(ENTRY(8,{&USUAR_PREFER.COD_LIVRE_1}))
              c-diretorio      =     ENTRY(9,{&USUAR_PREFER.COD_LIVRE_1}). 

  &endif

        display cIniEmb        
                cIniEstab      
                i-tipo         
                c-cd-via-transp
                cInputFile     
                c-usuario      
                c-nat-operacao 
                rs-tipo        
                c-diretorio    
                with frame fpage4.

        IF cIniEstab <> "" AND
           c-usuario <> "" AND
           c-nat-operacao <> "" THEN DO:
           APPLY "leave" TO cIniEstab IN FRAME fpage4.
           APPLY "leave" TO c-usuario IN FRAME fpage4.
           APPLY "leave" TO c-nat-operacao IN FRAME fpage4.
        END.

  &if "{&EMSFND_VERSION}" >= "1.00" &then
  &else
    END.
  &endif

    RUN setFolder IN hFolder (INPUT 2).



    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeinitializeinterface wReport 
PROCEDURE beforeinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-lista-itens = {imp/im0710.i 03}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-output-campos wReport 
PROCEDURE pi-output-campos PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
/*     FIND FIRST embarque-imp NO-LOCK                                                   */
/*          WHERE embarque-imp.embarque = cIniEmb:SCREEN-VALUE IN FRAME fpage4 NO-ERROR. */
/*     IF AVAIL embarque-imp THEN                                                        */
/*        ASSIGN cIniestab:SCREEN-VALUE IN FRAME fpage4= embarque-imp.cod-estabel.       */
/*                                                                                       */
    ASSIGN INPUT FRAME fpage4 cIniEstab.

    RUN gotokey IN h-boad107 (INPUT cIniEstab).
    IF RETURN-VALUE = "OK" THEN DO:
        RUN getcharField IN h-boad107 (INPUT "nome", OUTPUT c-desc-estab).
    END.
    ELSE
        ASSIGN c-desc-estab = "".

    DISP c-desc-estab WITH FRAME fpage4.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN findPk_Codigo IN h-bocx220 (INPUT INPUT FRAME fpage4 cIniEstab,
                                        INPUT INPUT FRAME fpage4 cIniEmb, OUTPUT c-return).
    &else
        RUN gotokey IN h-bocx220 (INPUT INPUT FRAME fpage4 cIniEstab,
                                  INPUT INPUT FRAME fpage4 cIniEmb).
    &endif
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
     IF c-return = "" THEN DO:
    &else
     IF RETURN-VALUE = "OK" THEN DO:
    &endif
        RUN getintField IN h-bocx220 (INPUT "cod-via-transp", OUTPUT i-cod-via-transp).
        IF i-cod-via-transp <> 0 THEN DO:
           ASSIGN c-via-transp = {adinc/i01ad268.i 04 i-cod-via-transp}.
           IF INDEX(c-lista-itens,c-via-transp) <> 0 THEN DO:
              ASSIGN c-cd-via-transp:SCREEN-VALUE IN FRAME fpage4 = c-via-transp.
           END.
        END.
        ELSE ASSIGN i-cod-via-transp = 0.
    &IF DEFINED(DBOVersion) <> 0 &THEN
     END.
    &endif

   /*VALIDAÄ«O EMBARQUE NACIONALIZAÄ«O*/

   RUN FindFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fpage4 cIniEstab ,            
                                       INPUT INPUT FRAME fpage4 cIniEmb,               
                                       OUTPUT c-return).                               
   IF c-return = "" THEN                                                               
      RUN getintfield IN h-bocx230 (INPUT "cod-itiner", OUTPUT i-cod-itinerario ).      
                                                                                        
                                                                                        
   RUN FindCodigo IN h-bocx115 (INPUT i-cod-itinerario ,                               
                                 OUTPUT c-return).                                      
   IF c-return = "" THEN                                                               
     RUN getintfield IN h-bocx115 (INPUT "pto-desembarque", OUTPUT i-pto-desembarque ). 
                                                                                        

   RUN findPto-Controle IN h-bocx230a (INPUT INPUT FRAME fpage4 cIniEstab,             
                                       INPUT i-cod-itinerario,               
                                       INPUT INPUT FRAME fpage4 cIniEmb,                         
                                       INPUT i-pto-desembarque,                        
                                       OUTPUT c-return).                               
    IF c-return = "" THEN DO:                                                              
       RUN getCurrent IN h-bocx230a (OUTPUT TABLE tt-historico-embarque).

       FIND FIRST tt-historico-embarque NO-LOCK NO-ERROR.

       IF AVAIL tt-historico-embarque THEN DO:
          ASSIGN data-efetiva = tt-historico-embarque.dt-efetiva.
       END.

    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-siscomex wReport 
PROCEDURE pi-vld-siscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   &if '{&bf_mat_versao_ems}' >= '2.07' &then
    IF  CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel = INPUT FRAME fpage4 cIniEstab
                   AND ordens-embarque.embarque    = INPUT FRAME fpage4 cIniEmb
                   AND ordens-embarque.num-adic   <> 0) THEN DO:
   &else
    IF  CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel = INPUT FRAME fpage4 cIniEstab
                   AND ordens-embarque.embarque    = INPUT FRAME fpage4 cIniEmb
                   AND INT(SUBSTR(ordens-embarque.char-1,60,4)) <> 0) THEN DO:
    &endif
        ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fPage4 = "3".
        {utp/ut-liter.i "Ordem/Item" *}
        rs-tipo:DISABLE(TRIM(RETURN-VALUE)) IN FRAME fPage4.
        rs-tipo:DISABLE("NCM":U) IN FRAME fPage4.
        {utp/ut-liter.i "Adiá∆o" *}
        rs-tipo:ENABLE(TRIM(RETURN-VALUE)) IN FRAME fPage4.
    END.
    ELSE DO:
        ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fPage4 = "1".
        {utp/ut-liter.i "Ordem/Item" *}
        rs-tipo:ENABLE(TRIM(RETURN-VALUE)) IN FRAME fPage4.
        rs-tipo:ENABLE("NCM":U) IN FRAME fPage4.
        {utp/ut-liter.i "Adiá∆o" *}
        rs-tipo:DISABLE(TRIM(RETURN-VALUE)) IN FRAME fPage4.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita  as rowid           no-undo.
define var ccod-estabel as char            no-undo.
define var cembarque    as char            no-undo.

ASSIGN ccod-estabel = INPUT FRAME fpage4 cIniEstab
       cembarque    = INPUT FRAME fpage4 cIniemb.

if valid-handle(h-bocx220a) then
    delete procedure h-bocx220a.
run cxbo/bocx220a.p persistent set h-bocx220a.

RUN validaNumAdicaoSiscomex IN h-bocx220a (INPUT ccod-estabel,
                                           INPUT cembarque).
IF  RETURN-VALUE = "NOK":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 33778,
                       INPUT "").
    RETURN NO-APPLY.
END.

if valid-handle(h-bocx225) then
    delete procedure h-bocx225.
run cxbo/bocx225.p persistent set h-bocx225.

RUN validaNumAdicao IN h-bocx225 (INPUT ccod-estabel,
                                  INPUT cembarque).  
IF  RETURN-VALUE = "NOK":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 33778,
                       INPUT "").
    RETURN NO-APPLY.
END.

RUN validateSiscomex IN h-bocx225 (INPUT ccod-estabel,
                                   INPUT cembarque).
IF RETURN-VALUE = "NOK":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 33684,
                       INPUT "").
    RETURN NO-APPLY.
END.

RUN validateSeqAdicao IN h-bocx225 (INPUT ccod-estabel,
                                    INPUT cembarque).
IF RETURN-VALUE = "NOK":U THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Sequencia_da_Adiá∆o" *}
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 265,
                       INPUT RETURN-VALUE + " ").
    RETURN NO-APPLY.
END.


&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*** Relatorio ***/
  
do on error undo, return error on stop  undo, return error:
    
    {report/rpexa.i}
  
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
   
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            
            run utp/ut-msgs.p (input "show", input 73, input "").
            
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
     
    end.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /* Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i imp/im0710rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}

    if valid-handle(h-bocx225) then
        delete procedure h-bocx225.
    if valid-handle(h-bocx220a) then
        delete procedure h-bocx220a.
end.
&ELSE
DEF VAR c-arq-conv AS CHAR NO-UNDO.
/*** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     
    
    {report/rpexa.i}

    FIND FIRST embarque-imp NO-LOCK 
         WHERE embarque-imp.cod-estabel = INPUT FRAME fpage4 cIniEstab 
           AND embarque-imp.embarque    = INPUT FRAME fpage4 cIniemb NO-ERROR.
    
    IF NOT AVAIL embarque-imp THEN DO:
       run utp/ut-msgs.p (input "show", input 17365, input "" ).
       apply "ENTRY":U to cIniEmb in frame fPage4.
       return error.
    END.
       
   /*VALIDAÄ«O ESTABELECIMENTO*/
    RUN gotokey IN h-boad107 (INPUT INPUT FRAME fpage4 cIniEstab).
    IF RETURN-VALUE <> "OK" THEN 
    DO:
       run utp/ut-msgs.p (input "show", input 537, input "").
       apply "ENTRY":U to cIniEmb in frame fPage4.
       return error.
    END.

    ASSIGN input frame fPage4 cInputFile.

    DO loop = 1 TO 2:
       positions = "".
       cBarra = SUBSTRING("~\/",loop,1).
       start  = 1.
       found  = INDEX(cInputFile,cBarra,start).
       DO WHILE found > 0:
          positions = positions + STRING(found).
          start = found + 1.
          found = INDEX(cInputFile,cBarra,start).
       END.
    END.

    assign c-arq-aux = input frame fpage4 cInputFile.
           c-arq-aux = replace(c-arq-aux, "/":U, "~\":U).

    if  r-index(c-arq-aux, "~\":U) > 0 then do:
        assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "~\":U)).
        if  file-info:pathname = ? 
        or substr(file-info:file-type,1,1) <> "D":U then do:
            run utp/ut-msgs.p (input "show":U,
                               input 19375,
                               input cInputFile).
            apply "ENTRY":U to cInputFile in frame fPage4.
            return error.
        end.
    end.
    assign file-info:file-name = c-arq-aux.

    /*VALIDAÄ«O USUµRIO*/ 
    RUN gotokey IN h-boin292 (INPUT INPUT FRAME fpage4 c-usuario).

    IF RETURN-VALUE <> "OK" THEN 
    DO:
       run utp/ut-msgs.p (input "show", input 6110, input "").
       apply "ENTRY":U to c-usuario in frame fPage4.
       return error.
    END.

    /*VALIDAÄ«O NATUREZA DE OPERAÄ«O*/
    RUN gotokey IN h-boin245 (INPUT INPUT FRAME fpage4 c-nat-operacao).
    IF RETURN-VALUE <> "OK" THEN                                                         
    DO:
       run utp/ut-msgs.p (input "show", input 2050, input "").
       apply "ENTRY":U to c-nat-operacao in frame fPage4.
       return error.
    END.

    /*VALIDAÄ«O DATA EFETIVAÄ«O*/
    IF data-efetiva <> ? THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "j†" *}
       run utp/ut-msgs.p (input "show", input 25742, input RETURN-VALUE).
       apply "ENTRY":U to cIniEmb in frame fPage4.
       return error.
    END.
    
    ASSIGN input frame fPage4 c-diretorio.
    /*if  search(c-diretorio)  = ? or
        search(c-diretorio) <> c-diretorio
    then do:
        run utp/ut-msgs.p (input "show":U,
                           input 19377,
                           input c-diretorio).
        apply "ENTRY":U to c-diretorio in frame fPage4.
        return error.
    end.*/
    
    ASSIGN INPUT FRAME fpage4 c-cd-via-transp
           INPUT FRAME fpage4 i-tipo.
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario                                  
           tt-param.destino         = input frame fPage7 rsDestiny                   
           tt-param.arq-entrada     = input frame fPage4 cInputFile                  
           tt-param.data-exec       = today                                          
           tt-param.hora-exec       = time                                           
           tt-param.estab-ini       = INPUT FRAME fpage4 cIniestab                   
           tt-param.embarque        = INPUT FRAME fpage4 cIniEmb                     
           tt-param.via-transporte  = {imp/im0710.i 06 c-cd-via-transp}              
           tt-param.tipo-decl       = {imp/im0710i2.i 06 i-tipo}                     
           tt-param.usuario         = INPUT FRAME fpage4 c-usuario                   
           tt-param.nat-operacao    = INPUT FRAME fpage4 c-nat-operacao              
           tt-param.tipo            = INPUT FRAME fpage4 rs-tipo
           tt-param.diretorio       = INPUT FRAME fpage4 c-diretorio.                    

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    assign i-seq = 0.

  &if "{&EMSFND_VERSION}" >= "1.00" &then
  &else

    FIND LAST {&USUAR_PREFER} NO-LOCK NO-ERROR.

    IF AVAIL {&USUAR_PREFER} THEN
       ASSIGN i-seq = {&USUAR_PREFER}.num_seq + 1.
    ELSE 
  &endif      
        ASSIGN i-seq = 1.

  &if "{&EMSFND_VERSION}" >= "1.00" &then
  &else
 
    REPEAT:     

       FIND FIRST {&USUAR_PREFER} EXCLUSIVE-LOCK
            WHERE {&USUAR_PREFER}.cod_usuario = c-seg-usuario
              AND {&USUAR_PREFER}.cod_prog_dtsul = c-programa-mg97
              AND {&USUAR_PREFER.COD_PREFER} = "" NO-ERROR NO-WAIT.
       
       IF NOT LOCKED ({&USUAR_PREFER}) THEN DO:

           IF NOT AVAIL {&USUAR_PREFER} THEN DO:
                  CREATE {&USUAR_PREFER}.
                  ASSIGN {&USUAR_PREFER}.cod_usuario = c-seg-usuario
                         {&USUAR_PREFER}.cod_prog_dtsul = c-programa-mg97
                         {&USUAR_PREFER.COD_PREFER} = ""
                         {&USUAR_PREFER}.num_seq = i-seq.
            END.

            ASSIGN {&USUAR_PREFER.COD_LIVRE_1} = tt-param.embarque    + "," +
                                                 tt-param.estab-ini   + "," +
                                          STRING(tt-param.tipo-decl)  + "," +
                                          STRING(tt-param.via-transporte)   + "," +
                                                 tt-param.arq-entrada  + "," +
                                                 tt-param.usuario  + "," +
                                                 tt-param.nat-operacao + "," +
                                          STRING(tt-param.tipo)   + "," +
                                                 tt-param.diretorio.

            LEAVE.

        END. 

    END.
  &endif

    {report/imexb.i}
    
    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i imp/im0710rp.p}

    {report/imexc.i}

    if  session:set-wait-state("") then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piverificabanco wReport 
PROCEDURE piverificabanco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Implementado a verificaá∆o do banco de dados Access. */

IF SEARCH(c-diretorio) = ? THEN DO:
   run utp/ut-msgs.p (input "show":U,
                      input 19377,
                      input c-diretorio).
   apply "ENTRY":U to c-diretorio in frame fPage4.
   return error.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

