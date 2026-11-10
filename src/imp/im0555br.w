&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0555BR 2.00.00.023 } /*** 010023 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0555br MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i} /*Include de Pr‚-Processadores*/
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif

/* Local Variable Definitions ---                                       */
def var i-atraso      as integer no-undo.
def var i-situacao    as integer no-undo.
def var i-situcao-emb as integer no-undo.
def var d-data-ini    as date no-undo.
def var d-data-fim    as date no-undo.
def var c-est-ini     as char no-undo.
def var c-est-fim     as char no-undo.
def var c-proc-ini    as char no-undo.
def var c-proc-fim    as char no-undo.
def var i-exp-ini     AS integer FORMAT ">>>>>>>>9":U no-undo.
def var i-exp-fim     AS integer FORMAT ">>>>>>>>9":U no-undo.
def var i-itiner-ini  as integer no-undo.
def var i-itiner-fim  as integer no-undo.
def var i-pto-emb-ini as integer no-undo.
def var i-pto-emb-fim as integer no-undo.
def var i-pto-des-ini as integer no-undo.
def var i-pto-des-fim as integer no-undo.
def var i-local       as integer no-undo.
def var i-grupo-ini   as integer no-undo.
def var i-grupo-fim   as integer no-undo.
def var c-fam-ini     as char    no-undo.
def var c-fam-fim     as char    no-undo.
def var c-item-ini    as char no-undo.
def var c-item-fim    as char no-undo.
def var h-bocx230b    as handle no-undo.
def var h-bocx225     as handle no-undo.
def var h-bocx220     as handle no-undo.
def var h-bocx115     as handle no-undo.
def var h-bocx140     as handle no-undo.
def var h-boad098     as handle no-undo.
def var iEmitente     as int no-undo.
def var c-nome-abrev2 as char no-undo.
def var icod-fornecedor      as int no-undo.
def var c-veiculo-transp-ini as char no-undo.
def var c-veiculo-transp-fim as char no-undo.


def var iEmbarque      as int no-undo.
def var iDesembarque   as int no-undo.
def var cSituacao      as char no-undo.
def var c-decl-ini     as char no-undo.
def var c-decl-fim     as char no-undo.
def var c-fatura-ini   like invoice-emb-imp.nr-invoice no-undo.
def var c-fatura-fim   like invoice-emb-imp.nr-invoice initial "zzzzzzzzzzzz" no-undo. 
def var c-embarque-ini like embarque-imp.embarque no-undo.
def var c-embarque-fim like embarque-imp.embarque initial "zzzzzzzzzzzzzzzz" no-undo.
def var l-ok           as logical no-undo.

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        def var c-conhechouse-ini  as char no-undo.
        def var c-conhechouse-fim  as char no-undo.
        def var c-conhecmaster-ini as char no-undo.
        def var c-conhecmaster-fim as char no-undo.
        DEF VAR c-conhec-master    AS CHAR FORMAT "x(25)" NO-UNDO.
        DEF VAR c-conhec-house     AS CHAR FORMAT "x(25)" NO-UNDO.  
    &endif
&else    
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        def var c-conhechouse-ini  as char no-undo.
        def var c-conhechouse-fim  as char no-undo.
        def var c-conhecmaster-ini as char no-undo.
        def var c-conhecmaster-fim as char no-undo.
        DEF VAR c-conhec-master    AS CHAR FORMAT "x(25)" NO-UNDO.
        DEF VAR c-conhec-house     AS CHAR FORMAT "x(25)" NO-UNDO.  
    &ELSE
        def var c-conhec-ini as char no-undo.
        def var c-conhec-fim as char no-undo.
        DEF VAR c-conhec     LIKE embarque-imp.nr-conhecimento NO-UNDO.
    &ENDIF
&endif

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    DEFINE VARIABLE i-PtoSolicLiIni     LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE VARIABLE i-PtoSolicLiFim     LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE VARIABLE c-fiLicencImportIni LIKE licenciam-import-oc.licenca-import        NO-UNDO.
    DEFINE VARIABLE c-fiLicencImportFim LIKE licenciam-import-oc.licenca-import        NO-UNDO.
    DEFINE VARIABLE c-veiculo-ini AS CHAR NO-UNDO.
    DEFINE VARIABLE c-veiculo-fim AS CHAR  INITIAL "ZZZZZZZZZZZZZZZZ"  NO-UNDO.
    DEFINE VARIABLE dt-entrada-ini AS DATE  INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001  &ENDIF NO-UNDO.
    DEFINE VARIABLE dt-entrada-fim AS DATE  INITIAL 12/31/9999     NO-UNDO.
&ENDIF

def temp-table tt-ordens-embarque NO-UNDO like ordens-embarque
    field r-rowid as rowid.

def new global shared var gr-historico-embarque as rowid no-undo.
def new global shared var gr-par-processo-imp   as rowid no-undo.
def new global shared var gr-par-ordem-compra   as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-embarque-imp       AS ROWID NO-UNDO.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-historico

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-historico.cod-estabel ~
tt-historico.embarque ~
fnFornecedor(input tt-historico.cod-estabel, input tt-historico.embarque) @ iEmitente ~
fn-nome-abrev() @ c-nome-abrev2 tt-historico.cod-itiner ~
fnPtos(input tt-historico.cod-itiner, input "embarque") @ iEmbarque ~
fnPtos(input tt-historico.cod-itiner, input "desembarque") @ iDesembarque ~
fnConhecimento(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec ~
fnConhecimentoMaster(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-master ~
fnConhecimentoHouse(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-house ~
fnSituacao(input tt-historico.cod-estabel, input tt-historico.embarque) @ cSituacao
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1                          SUPER    
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-historico NO-LOCK ~
    BY tt-historico.cod-estabel ~
       BY tt-historico.embarque
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-historico NO-LOCK ~
    BY tt-historico.cod-estabel ~
       BY tt-historico.embarque.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-historico
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-historico


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btParametros rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-abrev w-livre 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnconhecimento w-livre

&IF "{&bf_dis_versao_ems}" < "2.05" &THEN
    FUNCTION fnconhecimento RETURNS CHARACTER
    ( input ccod-estabel as char, input cembarque as char )  FORWARD.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnconhecimentomaster w-livre

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        FUNCTION fnconhecimentomaster RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char )  FORWARD.
    &endif
&ELSE
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        FUNCTION fnconhecimentomaster RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char )  FORWARD.
    &ENDIF
&endif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnconhecimentohouse w-livre
&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        FUNCTION fnconhecimentohouse RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char )  FORWARD.
    &endif
&else    
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        FUNCTION fnconhecimentohouse RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char )  FORWARD.
    &ENDIF
&endif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFornecedor w-livre 
FUNCTION fnFornecedor RETURNS INTEGER
  (input ccod-estabel as char, input cembarque as char ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtos w-livre 
FUNCTION fnPtos RETURNS INTEGER
  ( input icod-itiner as integer, input cpto as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacao w-livre 
FUNCTION fnSituacao RETURNS CHARACTER
( input ccod-estabel as char, input cembarque as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btParametros 
     IMAGE-UP FILE "image~\im-brows":U
     LABEL "Sele‡Æo" 
     SIZE 4 BY 1.25 TOOLTIP "Sele‡Æo"
     FONT 4.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

DEFINE BUTTON bt_detalhe AUTO-GO DEFAULT 
     LABEL "Detalhe" 
     SIZE 10 BY 1
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-historico SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 w-livre _STRUCTURED

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        DEFINE BROWSE brSon1
        QUERY brSon1 DISPLAY
          tt-historico.cod-estabel format "x(05)":U
          tt-historico.embarque FORMAT "X(16)":U
          fnFornecedor(input tt-historico.cod-estabel, input tt-historico.embarque) @ iEmitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>>>>9":U
          fn-nome-abrev() @ c-nome-abrev2 COLUMN-LABEL "Nome Abrev" FORMAT "X(16)":U
          tt-historico.cod-itiner FORMAT ">>,>>9":U
          fnPtos(input tt-historico.cod-itiner, input "embarque") @ iEmbarque COLUMN-LABEL "Embarq" FORMAT ">>>>9":U
          fnPtos(input tt-historico.cod-itiner, input "desembarque") @ iDesembarque COLUMN-LABEL "Nacionaliz" FORMAT ">>>>9":U
          fnConhecimentoMaster(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-master COLUMN-LABEL "Conhecimento Master" FORMAT "x(25)":U
          fnConhecimentoHouse(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-house COLUMN-LABEL "Conhecimento House" FORMAT "x(25)":U
          fnSituacao(input tt-historico.cod-estabel, input tt-historico.embarque) @ cSituacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(20)":U
    &endif
&else    
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        DEFINE BROWSE brSon1
        QUERY brSon1 DISPLAY
          tt-historico.cod-estabel format "x(05)":U
          tt-historico.embarque FORMAT "X(16)":U
          fnFornecedor(input tt-historico.cod-estabel, input tt-historico.embarque) @ iEmitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>>>>9":U
          fn-nome-abrev() @ c-nome-abrev2 COLUMN-LABEL "Nome Abrev" FORMAT "X(16)":U
          tt-historico.cod-itiner FORMAT ">>,>>9":U
          fnPtos(input tt-historico.cod-itiner, input "embarque") @ iEmbarque COLUMN-LABEL "Embarq" FORMAT ">>>>9":U
          fnPtos(input tt-historico.cod-itiner, input "desembarque") @ iDesembarque COLUMN-LABEL "Nacionaliz" FORMAT ">>>>9":U
          fnConhecimentoMaster(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-master COLUMN-LABEL "Conhecimento Master" FORMAT "x(25)":U
          fnConhecimentoHouse(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec-house COLUMN-LABEL "Conhecimento House" FORMAT "x(25)":U
          fnSituacao(input tt-historico.cod-estabel, input tt-historico.embarque) @ cSituacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(20)":U
    &ELSE
        DEFINE BROWSE brSon1
        QUERY brSon1 DISPLAY
          tt-historico.cod-estabel format "x(05)":U
          tt-historico.embarque FORMAT "X(16)":U
          fnFornecedor(input tt-historico.cod-estabel, input tt-historico.embarque) @ iEmitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>>>>9":U
          fn-nome-abrev() @ c-nome-abrev2 COLUMN-LABEL "Nome Abrev" FORMAT "X(16)":U
          tt-historico.cod-itiner FORMAT ">>,>>9":U
          fnPtos(input tt-historico.cod-itiner, input "embarque") @ iEmbarque COLUMN-LABEL "Embarq" FORMAT ">>>>9":U
          fnPtos(input tt-historico.cod-itiner, input "desembarque") @ iDesembarque COLUMN-LABEL "Nacionaliz" FORMAT ">>>>9":U
          fnConhecimento(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec COLUMN-LABEL "Conhecimento Transp" FORMAT "x(18)":U
          fnSituacao(input tt-historico.cod-estabel, input tt-historico.embarque) @ cSituacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(20)":U
    &ENDIF
&endif    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83.57 BY 12.88
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btParametros AT ROW 1.17 COL 2 HELP
     "Sele‡Æo"
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.46.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     bt_detalhe AT ROW 14.13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 3
         SIZE 86 BY 15
         FONT 1
         DEFAULT-BUTTON bt_detalhe.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 17.46
         WIDTH              = 90
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.17
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
                                                                        */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-historico"
     _OrdList          = "Temp-Tables.tt-historico.cod-estabel|yes,Temp-Tables.tt-historico.embarque|yes"
     _FldNameList[1]   = Temp-Tables.tt-historico.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-historico.embarque
     _FldNameList[3]   > "_<CALC>"
"fnFornecedor(input tt-historico.cod-estabel, input tt-historico.embarque) @ iEmitente" "Fornecedor" ">>>>>>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"fn-nome-abrev() @ c-nome-abrev2" "Nome Abrev" "X(16)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.tt-historico.cod-itiner
     _FldNameList[6]   > "_<CALC>"
"fnPtos(input tt-historico.cod-itiner, input ""embarque"") @ iEmbarque" "Embarq" ">>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"fnPtos(input tt-historico.cod-itiner, input ""desembarque"") @ iDesembarque" "Nacionaliz" ">>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"fnConhecimento(input tt-historico.cod-estabel,input tt-historico.embarque) @ c-conhec" "Conhecimento Transp" "x(18)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"fnSituacao(input tt-historico.cod-estabel, input tt-historico.embarque) @ cSituacao" "Situa‡Æo" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 w-livre
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
    apply "choose" to bt_Detalhe in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME btParametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParametros w-livre
ON CHOOSE OF btParametros IN FRAME f-cad /* Sele‡Æo */
DO:
    RUN imp/im0555pr.w (output i-atraso, 
                        output i-situacao,
                        output i-situcao-emb, 
                        output d-data-ini,
                        output d-data-fim,
                        output c-est-ini, 
                        output c-est-fim, 
                        output c-proc-ini, 
                        output c-proc-fim, 
                        output i-exp-ini, 
                        output i-exp-fim, 
                        output i-itiner-ini,  
                        output i-itiner-fim,  
                        output i-pto-emb-ini, 
                        output i-pto-emb-fim, 
                        output i-pto-des-ini, 
                        output i-pto-des-fim, 
                        output i-local,       
                        output i-grupo-ini,   
                        output i-grupo-fim,   
                        output c-fam-ini,     
                        output c-fam-fim,     
                        output c-item-ini,    
                        output c-item-fim,
                        output c-decl-ini,
                        output c-decl-fim,
                        &if "{&bf_cex_versao_ems}" >= "2.062" &then
                            &if "{&bf_dis_versao_ems}" >= "2.04" &then
                                output c-conhechouse-ini,
                                output c-conhechouse-fim,
                                output c-conhecmaster-ini,
                                output c-conhecmaster-fim,
                            &endif
                        &else
                            &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                                output c-conhechouse-ini,
                                output c-conhechouse-fim,
                                output c-conhecmaster-ini,
                                output c-conhecmaster-fim,
                            &ELSE
                                output c-conhec-ini,
                                output c-conhec-fim,
                            &ENDIF
                        &endif
                        output c-fatura-ini,
                        output c-fatura-fim,
                        output c-embarque-ini,
                        output c-embarque-fim,
                        output c-veiculo-transp-ini,
                        output c-veiculo-transp-fim,
                        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                            OUTPUT i-PtoSolicLiIni,    
                            OUTPUT i-PtoSolicLiFim,  
                            OUTPUT c-fiLicencImportIni,
                            OUTPUT c-fiLicencImportFim,
                            OUTPUT c-veiculo-ini,
                            OUTPUT c-veiculo-fim,                    
                            OUTPUT dt-entrada-ini,
                            OUTPUT dt-entrada-fim,
                        &ENDIF
                        output l-ok).
                       

    run pi-atualiza-consulta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt_detalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_detalhe w-livre
ON CHOOSE OF bt_detalhe IN FRAME fPage1 /* Detalhe */
DO:
    def var cStatus as char no-undo.
    def var hProg as handle no-undo.
    if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then do:    
        ASSIGN gr-historico-embarque = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.r-rowid.
        RUN rowidembarque IN h-bocx220 (INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cod-estabel,
                                        INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.embarque,
                                        OUTPUT gr-embarque-imp).
        RUN imp/im0555.w.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             btParametros:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE btParametros rt-button 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  ENABLE brSon1 bt_detalhe 
      WITH FRAME fPage1 IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  delete procedure h-bocx225.
  delete procedure h-bocx220.
  delete procedure h-bocx115.
  delete procedure h-bocx140.
  delete procedure h-bocx230b.   
  delete procedure h-boad098. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    def var h-boin274 as handle no-undo.
    def var i-numero-ordem like ordem-compra.numero-ordem no-undo.

    /* Code placed here will execute PRIOR to standard behavior. */

    {include/win-size.i}

{utp/ut9000.i "IM0555BR" "2.00.00.021"}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    RUN cxbo/bocx225.p persistent  set h-bocx225.
    RUN cxbo/bocx220.p persistent  set h-bocx220.
    RUN cxbo/bocx115.p persistent  set h-bocx115.
    RUN cxbo/bocx140.p persistent  set h-bocx140.
    RUN cxbo/bocx230b.p persistent set h-bocx230b.    
    run adbo/boad098.p  persistent set h-boad098.

    if gr-par-processo-imp <> ? then do:

        run findRowid in h-bocx140(input gr-par-processo-imp).
        run getCharfield in h-bocx140(input "nr-proc-imp",output c-proc-ini).
        run getCharfield in h-bocx140(input "nr-proc-imp",output c-proc-fim).
        run getCharfield in h-bocx140(input "cod-estabel",output c-est-ini).
        run getCharfield in h-bocx140(input "cod-estabel",output c-est-fim).
        run getIntfield in h-bocx140(input "cod-exportador",output i-exp-ini).
        run getIntfield in h-bocx140(input "cod-exportador",output i-exp-fim).

        assign i-atraso   = 3
               i-situacao = 5
               i-situcao-emb = 3
               d-data-ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               d-data-fim = 12/31/9999          
               i-itiner-ini = 0 
               i-itiner-fim = 99999
               i-pto-emb-ini = 0
               i-pto-emb-fim = 99999
               i-pto-des-ini = 0
               i-pto-des-fim = 99999
               i-local       = 0
               i-grupo-ini   = 0
               i-grupo-fim   = 99
               c-fam-ini     = ""
               c-fam-fim     = "zzzzzzzz"
               c-item-ini    = ""
               c-item-fim    = "zzzzzzzzzzzzzzzz"    
               c-decl-ini    = ""
               c-decl-fim    = "zzzzzzzzzzzzzzzzzzzz"
               &if "{&bf_cex_versao_ems}" >= "2.062" &then
                   &if "{&bf_dis_versao_ems}" >= "2.04" &then
                        c-conhechouse-ini  = ""
                        c-conhechouse-fim  = "zzzzzzzzzzzzzzzzzz"
                        c-conhecmaster-ini  = ""
                        c-conhecmaster-fim  = "zzzzzzzzzzzzzzzzzz"
                   &endif
               &else
                   &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                       c-conhechouse-ini  = ""
                       c-conhechouse-fim  = "zzzzzzzzzzzzzzzzzz"
                       c-conhecmaster-ini  = ""
                       c-conhecmaster-fim  = "zzzzzzzzzzzzzzzzzz"
                   &ELSE
                       c-conhec-ini  = ""
                       c-conhec-fim  = "zzzzzzzzzzzzzzzzzz"
                   &ENDIF
               &endif
               l-ok          = yes
               c-fatura-ini  = ""
               c-fatura-fim  = "zzzzzzzzzzzz"
               c-embarque-ini = ""
               c-embarque-fim = "zzzzzzzzzzzzzzzz"
               c-veiculo-transp-ini = ""
               c-veiculo-transp-fim = "ZZZZZZZZZZZZZZZZZZZZ"
               &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN     
                   i-PtoSolicLiIni      = 0                       
                   i-PtoSolicLiFim      = 99999                   
                   c-fiLicencImportIni  = ""                      
                   c-fiLicencImportFim  = "ZZZZZZZZZZZZZZZZZZZZ"  
               &ENDIF
        .

        if gr-par-ordem-compra <> ? then do:
            run inbo/boin274.p persistent set h-boin274.
            run openquery in h-boin274 (input 1).
            run findRowid in h-boin274(input gr-par-ordem-compra).
            run getCharfield in h-boin274(input "it-codigo",output c-item-ini).
            run getCharfield in h-boin274(input "it-codigo",output c-item-fim).
            run getIntfield  in h-boin274(input "numero-ordem",output i-numero-ordem).
            run criarTTembarqueaux in h-bocx230b(input i-numero-ordem).
            delete procedure h-boin274.
        end.

        run pi-atualiza-consulta.

        assign gr-par-processo-imp = ?
               gr-par-ordem-compra = ?.
    end.    

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-consulta w-livre 
PROCEDURE pi-atualiza-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var iRowsReturned as integer no-undo.

    if l-ok then do:
        RUN criarTTembarque in h-bocx230b (input i-atraso,
                                           input i-situacao,
                                           input i-situcao-emb,
                                           input i-local,
                                           input d-data-ini,
                                           input d-data-fim,
                                           input c-est-ini,
                                           input c-est-fim,
                                           input c-proc-ini,
                                           input c-proc-fim,
                                           input i-exp-ini,
                                           input i-exp-fim,
                                           input i-itiner-ini,
                                           input i-itiner-fim,
                                           input i-pto-emb-ini,
                                           input i-pto-emb-fim,
                                           input i-pto-des-ini,
                                           input i-pto-des-fim,
                                           input i-grupo-ini,
                                           input i-grupo-fim,
                                           input c-fam-ini,
                                           input c-fam-fim,
                                           input c-item-ini,
                                           input c-item-fim,
                                           input c-decl-ini,
                                           input c-decl-fim,
                                           &if "{&bf_cex_versao_ems}" >= "2.062" &then
                                               &if "{&bf_dis_versao_ems}" >= "2.04" &then
                                                   input c-conhechouse-ini,
                                                   input c-conhechouse-fim,
                                                   input c-conhecmaster-ini,
                                                   input c-conhecmaster-fim,
                                               &endif                                                    
                                           &else
                                               &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                                                   input c-conhechouse-ini,
                                                   input c-conhechouse-fim,
                                                   input c-conhecmaster-ini,
                                                   input c-conhecmaster-fim,
                                               &ELSE
                                                    input c-conhec-ini,
                                                    input c-conhec-fim,
                                               &ENDIF
                                           &endif
                                           input c-fatura-ini,
                                           input c-fatura-fim,
                                           input c-embarque-ini,
                                           input c-embarque-fim,
                                           input c-veiculo-transp-ini,
                                           input c-veiculo-transp-fim
                                           &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                                               ,
                                               INPUT i-PtoSolicLiIni,    
                                               INPUT i-PtoSolicLiFim,  
                                               INPUT c-fiLicencImportIni,
                                               INPUT c-fiLicencImportFim,
                                               INPUT c-veiculo-ini,
                                               INPUT c-veiculo-fim,
                                               INPUT dt-entrada-ini,
                                               INPUT dt-entrada-fim
                                           &ENDIF).


        RUN openQuery IN h-bocx230b (INPUT 2).                

        RUN findFirst IN h-bocx230b.

        run retornaTThistorico IN h-bocx230b (OUTPUT TABLE tt-historico).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brson1.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-livre 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN panel/p-exihel.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-historico"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-abrev w-livre 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  (  ) :

  def var c-return as char no-undo.
  def var c-nome-abrev as char no-undo.
  run findCodigo in h-boad098 (input icod-fornecedor,
                               output c-return).
  if c-return = "" then
     run getcharfield in h-boad098 ("nome-abrev", output c-nome-abrev).

  RETURN c-nome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnconhecimentomaster w-livre 

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        FUNCTION fnconhecimentomaster RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char ) :
        
            def var cStatus as char no-undo.
            def var csituacao as char no-undo.
            def var cconhecmaster AS CHAR FORMAT "x(25)" no-undo.
        
            RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
            if cStatus = "" then 
                RUN getCharField in h-bocx220 (input "cod-conhecto-master", output cconhecmaster).
            RETURN cconhecmaster.
        
        END FUNCTION.
    &endif
&else    
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        FUNCTION fnconhecimentomaster RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char ) :
        
            def var cStatus as char no-undo.
            def var csituacao as char no-undo.
            def var cconhecmaster AS CHAR FORMAT "x(25)" no-undo.
        
            RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
            if cStatus = "" then 
                RUN getCharField in h-bocx220 (input "cod-conhecto-master", output cconhecmaster).
            RETURN cconhecmaster.
        
        END FUNCTION.
    &ENDIF
&endif    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnconhecimentohouse w-livre 

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        FUNCTION fnconhecimentohouse RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char ) :
    
            def var cStatus as char no-undo.
            def var csituacao as char no-undo.
            def var cconhechouse AS CHAR FORMAT "x(25)" no-undo.
    
            RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
            if cStatus = "" then 
                RUN getCharField in h-bocx220 (input "cod-conhecto-house", output cconhechouse).
            RETURN cconhechouse.
    
        END FUNCTION.
    &endif
&else
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        FUNCTION fnconhecimentohouse RETURNS CHARACTER
        ( input ccod-estabel as char, input cembarque as char ) :
        
            def var cStatus as char no-undo.
            def var csituacao as char no-undo.
            def var cconhechouse LIKE embarque-imp.cod-conhecto-house no-undo.
        
            RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
            if cStatus = "" then 
                RUN getCharField in h-bocx220 (input "cod-conhecto-house", output cconhechouse).
            RETURN cconhechouse.
        
        END FUNCTION.
    &ENDIF
&endif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnconhecimento w-livre 

&IF "{&bf_dis_versao_ems}" < "2.05" &THEN
    FUNCTION fnconhecimento RETURNS CHARACTER
    ( input ccod-estabel as char, input cembarque as char ) :

        def var cStatus as char no-undo.                                           
        def var csituacao as char no-undo.
        def var cconhec AS CHAR FORMAT "x(25)" no-undo.
    
        RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
        if cStatus = "" then 
            RUN getCharField in h-bocx220 (input "nr-conhecimento", output cconhec).
        RETURN cconhec.

    END FUNCTION.
&ENDIF
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFornecedor w-livre 
FUNCTION fnFornecedor RETURNS INTEGER
  (input ccod-estabel as char, input cembarque as char ):

    def var cStatus as char no-undo.
/*    def var icod-fornecedor as int no-undo.*/

    RUN findEmbarque in h-bocx225(input ccod-estabel,input cembarque, output cStatus).
        if  cStatus = "" then do:
            RUN getCurrent in h-bocx225(output table tt-ordens-embarque).
            find first tt-ordens-embarque no-lock no-error.
            if avail tt-ordens-embarque then do:
                RUN findprocessoImp in h-bocx140(input tt-ordens-embarque.cod-estabel, tt-ordens-embarque.nr-proc-imp,output cStatus).
                if  cStatus = "" then
                    RUN getIntField in h-bocx140 (input "cod-exportador", output icod-fornecedor).
            end.
        end. 
    RETURN icod-fornecedor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtos w-livre 
FUNCTION fnPtos RETURNS INTEGER
  ( input icod-itiner as integer, input cpto as char ) :

    def var cStatus as char no-undo.
    def var ipto as integer no-undo.

    RUN findCodigo in h-bocx115 (input icod-itiner, output cStatus).
    if cpto = "embarque" and cStatus = "" then
        RUN getIntField in h-bocx115 (input "pto-embarque", output ipto).
    if cpto = "desembarque" and cStatus = "" then
        RUN getIntField in h-bocx115 (input "pto-desembarque", output ipto).   

    RETURN ipto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacao w-livre 
FUNCTION fnSituacao RETURNS CHARACTER
( input ccod-estabel as char, input cembarque as char ) :

    def var cStatus as char no-undo.
    def var csituacao as char no-undo.
    def var isituacao as int no-undo.

    RUN findCh_embarque in h-bocx220 (input ccod-estabel, input cembarque, output cStatus).
    if cStatus = "" then 
        RUN getIntField in h-bocx220 (input "situacao", output isituacao).
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {cxinc/i01cx220.i 04 isituacao}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  csituacao = RETURN-VALUE.
    &else
        ASSIGN csituacao = {cxinc/i01cx220.i 04 isituacao}.
    &endif
    RETURN csituacao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


