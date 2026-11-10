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
{include/i-prgvrs.i V01AD018 2.00.00.056} /*** "010056" 07/11/2023 11:01:39 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad018 MUT}
&ENDIF

{include/i_fncrowid.i}


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


/* miniflexibilizaªío */
{include/i_dbvers.i}  
{cdp/cdcfgfin.i}

def new global shared var v-row-parent as rowid no-undo.
&IF {&ROWID_READY} = YES &THEN
  def new global shared var v_rec_imagem as rowid no-undo.
&ELSE
  def new global shared var v_rec_imagem as recid no-undo.
&ENDIF

def var c-instrucao as char no-undo.
def var c-nome       as char no-undo.

def var i-banc1                as integer no-undo.
def var i-banc2                as integer no-undo.
def var i-cont-febraban        as integer no-undo.
def var i-agencia-ini-atz      as integer no-undo.
def var i-agencia-fim-atz      as integer no-undo.
def var i-conta-ini-atz        as integer no-undo.
def var i-conta-fim-atz        as integer no-undo.
def var i-nosso-num1-ini-atz   as integer no-undo.
def var i-nosso-num1-fim-atz   as integer no-undo.
def var i-nosso-num2-ini-atz   as integer no-undo.
def var i-nosso-num2-fim-atz   as integer no-undo.
def var i-valor-titulo-ini-atz as integer no-undo.
def var i-valor-titulo-fim-atz as integer no-undo.
def var i-ind-tipo-movto       as integer no-undo.
def var c-ag-padrao            as char    no-undo.
def var c-catalogo             as char    no-undo.
define var l-funcionou as logical no-undo initial no.

def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var l-origem-int        as logical init yes no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
    /* ** 5 => Quando parÉmetro "nao-integra" e o registro j† est† integrado **
       ** 6 => Erro de integraá∆o no SISDOC                                  **
       ** 7 => Erro de integraá∆o no EMS                                   ** */

def var c-agencia-ini-aux      as char format "999" no-undo.
def var c-agencia-fim-aux      as char format "999" no-undo.
def var c-conta-ini-aux        as char format "999" no-undo.
def var c-conta-fim-aux        as char format "999" no-undo.
def var c-nosso-num1-ini-aux   as char format "999" no-undo.
def var c-nosso-num1-fim-aux   as char format "999" no-undo.
def var c-nosso-num2-ini-aux   as char format "999" no-undo.
def var c-nosso-num2-fim-aux   as char format "999" no-undo.
def var c-valor-titulo-ini-aux as char format "999" no-undo.
def var c-valor-titulo-fim-aux as char format "999" no-undo.

/* Banking Connect - fut36887 - atividade 143442 */ 
{include/getdefinedfunction.i} /*** Verificar se a funcao especial estòŸ habilitada ***/ 
def var l-banking-connect as logical initial no no-undo.
DEF VAR c-integra-banking-connect-aux AS LOG NO-UNDO.
DEF VAR v_hdl_reg_produt  AS HANDLE NO-UNDO.             /* Handle para o controle de registro - cdp/cd4210b.p */
DEF VAR l-registro-ok     AS LOGICAL INITIAL NO NO-UNDO. /* Variavel auxiliar para verificaá∆o do Registro */
DEF VAR d-limite          AS DATE NO-UNDO.               /* Data limite do registro */
DEF VAR c-empresa-banking AS CHAR NO-UNDO.               /* Empresa do registro encontrado */

/* Banking Connect - Verificaá∆o do Registro - Inicializando Handle */
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    IF NOT VALID-HANDLE(v_hdl_reg_produt)
            OR  v_hdl_reg_produt:TYPE       <> "procedure":U
            OR  v_hdl_reg_produt:FILE-NAME  <>  "cdp/cd4210b.p":U
           THEN run cdp/cd4210b.p PERSISTENT SET v_hdl_reg_produt.
&ENDIF
/*--------*/

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}
{cdp/cdapi222.i}
/*********************************************/

/********** Bancos Historicos ADM ***************/
/*-- Definicao da tt-tabela ---*/
{bhp/bh9999.i1}

/******  BANCOS HIST‡RICOS ******/
{cdp/cd1000.i}
/********************************/

def buffer b-banco for banco.

/* Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) */
{cdp/cd0001i1.i} /* Definiá∆o tt-erros-mg */
{cdp/cd1101i1.i} /* Definiá∆o tt-banco-mg */

{include/i-freeac.i} /*Include para retirar acentuaá∆o */

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
&Scoped-define EXTERNAL-TABLES banco
&Scoped-define FIRST-EXTERNAL-TABLE banco


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR banco.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS banco.nome-banco banco.ag-padrao ~
banco.cod-febraban banco.int-1 banco.usa-cob-esc banco.cod-imagem ~
banco.emis-extrato 
&Scoped-define ENABLED-TABLES banco
&Scoped-define FIRST-ENABLED-TABLE banco
&Scoped-Define ENABLED-OBJECTS l-integra-banking-connect RECT-8 RECT-7 ~
im-banco RECT-9 RECT-28 IMAGE-1 IMAGE-2 IMAGE-29 IMAGE-32 IMAGE-30 IMAGE-33 ~
IMAGE-31 IMAGE-34 IMAGE-35 IMAGE-36 
&Scoped-Define DISPLAYED-FIELDS banco.cod-banco banco.nome-banco ~
banco.ag-padrao banco.cod-febraban banco.int-1 banco.int-2 ~
banco.usa-cob-esc banco.ins-banc[1] banco.ins-banc[2] banco.cod-imagem ~
banco.emis-extrato 
&Scoped-define DISPLAYED-TABLES banco
&Scoped-define FIRST-DISPLAYED-TABLE banco
&Scoped-Define DISPLAYED-OBJECTS l-integra-banking-connect de-ultima-gps ~
c-desc c-desc2 i-agencia-ini i-agencia-fim i-conta-ini i-conta-fim ~
i-nosso-num1-ini i-nosso-num1-fim i-nosso-num2-ini i-nosso-num2-fim ~
i-valor-titulo-ini i-valor-titulo-fim c-emis-extrato c-codigo-barras 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS banco.cod-banco banco.int-1 banco.int-2 ~
de-ultima-gps i-agencia-ini i-agencia-fim i-conta-ini i-conta-fim ~
i-nosso-num1-ini i-nosso-num1-fim i-nosso-num2-ini i-nosso-num2-fim 
&Scoped-define ADM-ASSIGN-FIELDS banco.int-1 banco.int-2 de-ultima-gps ~
i-agencia-ini i-agencia-fim i-conta-ini i-conta-fim i-nosso-num1-ini ~
i-nosso-num1-fim i-nosso-num2-ini i-nosso-num2-fim 
&Scoped-define ADM-MODIFY-FIELDS banco.int-1 banco.int-2 de-ultima-gps ~
i-agencia-ini i-agencia-fim i-conta-ini i-conta-fim i-nosso-num1-ini ~
i-nosso-num1-fim i-nosso-num2-ini i-nosso-num2-fim 
&Scoped-define List-4 banco.ins-banc[1] banco.ins-banc[2] 

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
DEFINE VARIABLE c-codigo-barras AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 18.29 BY .58 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-emis-extrato AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 12.14 BY .67 NO-UNDO.

DEFINE VARIABLE de-ultima-gps AS DECIMAL FORMAT ">>>>9":U INITIAL 0 
     LABEL "Nr. Èltima GPS" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-agencia-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-agencia-ini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-conta-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-conta-ini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-nosso-num1-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-nosso-num1-ini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-nosso-num2-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-nosso-num2-ini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-valor-titulo-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-valor-titulo-ini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE IMAGE im-banco
     SIZE 12.86 BY 3.17.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY 1.08.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 5.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 14.17.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 1.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.14 BY 2.71.

DEFINE VARIABLE l-integra-banking-connect AS LOGICAL INITIAL no 
     LABEL "Integraá∆o Banking Connect" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-integra-banking-connect AT ROW 5.08 COL 47
     banco.cod-banco AT ROW 1.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     banco.nome-banco AT ROW 1.17 COL 34.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     banco.ag-padrao AT ROW 2.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     banco.cod-febraban AT ROW 3.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     banco.int-1 AT ROW 4.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     banco.int-2 AT ROW 5.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.86 BY .88
     banco.usa-cob-esc AT ROW 6 COL 67.86 RIGHT-ALIGNED
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .63
     de-ultima-gps AT ROW 6.67 COL 29 COLON-ALIGNED
     banco.ins-banc[1] AT ROW 7.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc AT ROW 7.67 COL 34.43 COLON-ALIGNED NO-LABEL
     banco.ins-banc[2] AT ROW 8.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc2 AT ROW 8.67 COL 34.43 COLON-ALIGNED NO-LABEL
     banco.cod-imagem AT ROW 9.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     banco.emis-extrato AT ROW 11.38 COL 8.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ficha Dep¢sito", 1,
"Cheque", 2
          SIZE 27.57 BY 1.88
     i-agencia-ini AT ROW 11.25 COL 66 COLON-ALIGNED
     i-agencia-fim AT ROW 11.25 COL 78 COLON-ALIGNED NO-LABEL
     i-conta-ini AT ROW 12.25 COL 66 COLON-ALIGNED
     i-conta-fim AT ROW 12.25 COL 78 COLON-ALIGNED NO-LABEL
     i-nosso-num1-ini AT ROW 13.25 COL 66 COLON-ALIGNED
     i-nosso-num1-fim AT ROW 13.25 COL 78 COLON-ALIGNED NO-LABEL
     i-nosso-num2-ini AT ROW 14.25 COL 66 COLON-ALIGNED
     i-nosso-num2-fim AT ROW 14.25 COL 78 COLON-ALIGNED NO-LABEL
     i-valor-titulo-ini AT ROW 15.25 COL 66 COLON-ALIGNED
     i-valor-titulo-fim AT ROW 15.25 COL 78 COLON-ALIGNED NO-LABEL
     c-emis-extrato AT ROW 10.5 COL 5.43 NO-LABEL
     c-codigo-barras AT ROW 10.71 COL 46.57 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 1 COL 1.14
     RECT-7 AT ROW 2.38 COL 1.14
     im-banco AT ROW 2.67 COL 87.43 RIGHT-ALIGNED
     RECT-9 AT ROW 10.83 COL 3.86
     RECT-28 AT ROW 10.83 COL 47.29
     IMAGE-1 AT ROW 11.21 COL 72
     IMAGE-2 AT ROW 11.21 COL 74.86
     IMAGE-29 AT ROW 12.21 COL 72
     IMAGE-32 AT ROW 12.21 COL 75
     IMAGE-30 AT ROW 13.21 COL 72
     IMAGE-33 AT ROW 13.21 COL 74.86
     IMAGE-31 AT ROW 14.21 COL 71.86
     IMAGE-34 AT ROW 14.21 COL 74.86
     IMAGE-35 AT ROW 15.21 COL 71.86
     IMAGE-36 AT ROW 15.21 COL 74.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.banco
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
         HEIGHT             = 15.67
         WIDTH              = 89.57.
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

/* SETTINGS FOR FILL-IN c-codigo-barras IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emis-extrato IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN banco.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-ultima-gps IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-agencia-fim IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-agencia-ini IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-conta-fim IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-conta-ini IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-nosso-num1-fim IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-nosso-num1-ini IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-nosso-num2-fim IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-nosso-num2-ini IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-valor-titulo-fim IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-valor-titulo-fim:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN i-valor-titulo-ini IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-valor-titulo-ini:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR IMAGE im-banco IN FRAME f-main
   ALIGN-R                                                              */
ASSIGN 
       IMAGE-35:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       IMAGE-36:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN banco.ins-banc[1] IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN banco.ins-banc[2] IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN banco.int-1 IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN banco.int-2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX banco.usa-cob-esc IN FRAME f-main
   ALIGN-R                                                              */
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

&Scoped-define SELF-NAME banco.ag-padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ag-padrao V-table-Win
ON ENTRY OF banco.ag-padrao IN FRAME f-main /* Agància Padr∆o */
DO:
  &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
      find funcao 
        where funcao.cd-funcao = "spp-ems2fin-x-mg" 
        and   funcao.ativo     = yes no-lock no-error.
      if  avail funcao then
          assign banco.ag-padrao:format in frame {&FRAME-NAME} = "999999-X".                           
  &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ag-padrao V-table-Win
ON F5 OF banco.ag-padrao IN FRAME f-main /* Agància Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad009.w
                   &campo=banco.ag-padrao
                   &campozoom=agencia}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ag-padrao V-table-Win
ON LEAVE OF banco.ag-padrao IN FRAME f-main /* Agància Padr∆o */
DO:
  &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
      find funcao 
        where funcao.cd-funcao = "spp-ems2fin-x-mg" 
        and   funcao.ativo     = yes no-lock no-error.
      if  avail funcao then do:
          assign c-ag-padrao = input frame {&FRAME-NAME} banco.ag-padrao no-error.
          if  error-status:get-number(1) <> 0 then
              assign banco.ag-padrao:format in frame {&FRAME-NAME} = "x(08)".
      end.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ag-padrao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF banco.ag-padrao IN FRAME f-main /* Agància Padr∆o */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME banco.cod-imagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.cod-imagem V-table-Win
ON F5 OF banco.cod-imagem IN FRAME f-main /* Imagem */
DO:
  assign c-catalogo = "".
  find first param-global no-lock no-error.
  if avail param-global then assign c-catalogo = param-global.cod-catal-img-banco.

  run btb/btb104ka.p (c-catalogo).
  find imagem no-lock where
  &IF {&ROWID_READY} = YES &THEN rowid(imagem) &ELSE recid(imagem) &ENDIF  = v_rec_imagem no-error.
  if avail imagem then
     assign banco.cod-imagem:screen-value = string(imagem.cod_imagem).  
  apply 'leave' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.cod-imagem V-table-Win
ON LEAVE OF banco.cod-imagem IN FRAME f-main /* Imagem */
DO:
  if im-banco:load-image("") in frame {&frame-name} then.
  if banco.cod-imagem:screen-value in frame {&frame-name} <> "" then do:
      find imagem no-lock where
              imagem.cod_imagem = banco.cod-imagem:screen-value in frame {&frame-name} no-error.
      if avail imagem then do:
         find catal_img of imagem no-lock no-error.
         if avail catal_img then do:
            assign c-nome = string(catal_img.cod_path_catal + "/" + imagem.img_imagem).
            assign l-funcionou = im-banco:load-image(c-nome) in frame {&frame-name} no-error.
         end.
      end.
  end.            

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.cod-imagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF banco.cod-imagem IN FRAME f-main /* Imagem */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME banco.ins-banc[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[1] V-table-Win
ON F5 OF banco.ins-banc[1] IN FRAME f-main /* Instruá∆o Banc†ria[1] */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad152.w
                   &campo=banco.ins-banc[1]
                   &campozoom=cod-instr}

  /*RUN adzoom/z02ad999.w (output c-instrucao).
 *   IF c-instrucao <> "" THEN
 *      ASSIGN banco.ins-banc[1]:SCREEN-VALUE = c-instrucao.*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[1] V-table-Win
ON LEAVE OF banco.ins-banc[1] IN FRAME f-main /* Instruá∆o Banc†ria[1] */
DO:
  find instrucao where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[1] no-error.
  if avail instrucao
   then assign c-desc:screen-value = instrucao.descricao.
   else assign c-desc:screen-value = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[1] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF banco.ins-banc[1] IN FRAME f-main /* Instruá∆o Banc†ria[1] */
DO:
 APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME banco.ins-banc[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[2] V-table-Win
ON F5 OF banco.ins-banc[2] IN FRAME f-main /* Instruá∆o Banc†ria[2] */
DO:
 assign l-implanta = yes.
 {include/zoomvar.i &prog-zoom=adzoom/z01ad152.w
                   &campo=banco.ins-banc[2]
                   &campozoom=cod-instr}

 /* RUN adzoom/z02ad999.w (output c-instrucao).
 *   IF c-instrucao <> "" THEN
 *      ASSIGN banco.ins-banc[2]:SCREEN-VALUE = c-instrucao. */ 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[2] V-table-Win
ON LEAVE OF banco.ins-banc[2] IN FRAME f-main /* Instruá∆o Banc†ria[2] */
DO:
 find instrucao where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[2] no-error.
    if avail instrucao
       then assign c-desc2:screen-value = instrucao.descricao.
       else assign c-desc2:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.ins-banc[2] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF banco.ins-banc[2] IN FRAME f-main /* Instruá∆o Banc†ria[2] */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-integra-banking-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-integra-banking-connect V-table-Win
ON VALUE-CHANGED OF l-integra-banking-connect IN FRAME f-main /* Integraá∆o Banking Connect */
DO:
    if l-banking-connect then do:
        /* Banking connect */
        if l-integra-banking-connect:checked = yes then
        DO:
            FIND FIRST  
                b-banco 
            where 
                b-banco.cod-banco <> banco.cod-banco AND
                b-banco.log-2 = YES
            NO-LOCK NO-ERROR.
            IF AVAIL b-banco 
            then do:
                run utp/ut-msgs.p (input "show",
                                   31389,
                                   string(b-banco.cod-banco) + "~~" + string(b-banco.nome-banco)).
                assign l-integra-banking-connect:CHECKED IN FRAME {&FRAME-NAME} = no.
                leave.
            end.
        END.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME banco.usa-cob-esc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL banco.usa-cob-esc V-table-Win
ON VALUE-CHANGED OF banco.usa-cob-esc IN FRAME f-main /* Cobranáa Escritural */
DO:

   run pi-cobranca-escritural.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

IF banco.ag-padrao:LOAD-MOUSE-POINTER   ("image/lupa.cur") THEN.
IF banco.ins-banc[1]:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
IF banco.ins-banc[2]:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
IF banco.cod-imagem:LOAD-MOUSE-POINTER  ("image/lupa.cur") THEN.  

{utp/ut-liter.i Agància}
assign i-agencia-ini:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Nr_Ultima_Remessa}
assign banco.int-2:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Cta_Corrente}
assign i-conta-ini:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Nosso_N£mero[1]}
assign i-nosso-num1-ini:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Nosso_N£mero[2]}
assign i-nosso-num2-ini:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Valor_T°tulo}
assign i-valor-titulo-ini:label in frame {&FRAME-NAME} = trim(return-value).

assign banco.int-2:format in frame {&frame-name} = "99999".

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF    

/* Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) */
{btb/btb008za.i0} /*Definiá∆o vari†veis RPC*/  


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
  {src/adm/template/row-list.i "banco"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "banco"}

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
  run pi-versao (input 6).
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-rtlbl.i mgadm banco emis-extrato c-emis-extrato}

  {utp/ut-liter.i Posiá‰es_C¢digo_Barras}
  assign c-codigo-barras:screen-value in frame {&FRAME-NAME} = trim(return-value).

  apply 'value-changed' to banco.usa-cob-esc in frame {&frame-name}.
  apply 'leave' to banco.cod-imagem  in frame {&frame-name}.
  apply 'entry' to banco.cod-banco  in frame {&frame-name}. /* para retornar o help do c¢digo do banco Ö barra de status */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    do  transaction:

        {include/i-valid.i}

        run pi-versao (input 2).        

        DO  WITH FRAME {&FRAME-NAME}:
            if  adm-new-record then do:
                find first b-banco no-lock
                    where b-banco.cod-banco = input frame {&FRAME-NAME} banco.cod-banco no-error.
                if  avail b-banco then do:
                    {utp/ut-liter.i Banco}
                    run utp/ut-msgs.p (input "show",
                                       input 11,
                                       input trim(return-value)).
                    APPLY "ENTRY" TO banco.cod-banco IN FRAME {&FRAME-NAME}.
                    RETURN "ADM-ERROR":U.
                end.
            END.           
        END.     

        if  input frame {&FRAME-NAME} banco.cod-banco = 0 then do:
            run utp/ut-msgs.p (input "show",
                               input 9002,
                               input "").
            APPLY "Entry" TO banco.cod-banco IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U. 
        end. 

        if input frame {&FRAME-NAME} banco.nome-banco = "" then do:
           run utp/ut-msgs.p (input "show",
                              input 19445,
                              input "").
           APPLY "Entry" TO banco.nome-banco IN FRAME {&FRAME-NAME}.
           RETURN "ADM-ERROR":U.
        end.

        IF  input frame {&FRAME-NAME} mgadm.banco.usa-cob-esc = yes then do: 
            find first instrucao 
                 where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[1] no-lock no-error.
            if  not avail instrucao and 
                input frame {&frame-name} banco.ins-banc[1] <> 0 then do:
                run utp/ut-msgs.p (input "show",
                                   input 77,
                                   input string(input frame {&frame-name} banco.ins-banc[1])).
                APPLY "Entry" TO banco.ins-banc[1] IN FRAME {&frame-name}.
                RETURN "ADM-ERROR":U. 
            end.

            find first instrucao 
                 where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[2] no-lock no-error.
            if  not avail instrucao and
                input frame {&frame-name} banco.ins-banc[2] <> 0 then do:
                run utp/ut-msgs.p (input "show",
                                   input 77,
                                   input string(input frame {&frame-name} banco.ins-banc[2])).
                APPLY "Entry" TO banco.ins-banc[2] IN FRAME {&frame-name}.
                RETURN "ADM-ERROR":U. 
            END.
        end.

        if  banco.cod-imagem:screen-value in frame {&frame-name} <> "" then do:
            find imagem no-lock where
                    imagem.cod_imagem = banco.cod-imagem:screen-value in frame {&frame-name} no-error.
            if not avail imagem then do:
               run utp/ut-msgs.p (input "show":U, input 3154, input "").
               apply 'entry' to banco.cod-imagem.
               RETURN "ADM-ERROR":U. 
            end.
        end.            

        if  i-agencia-ini-atz > i-agencia-fim-atz then do:
            run utp/ut-msgs.p (input "show",
                               input 252,
                               input "").
            apply 'entry' to i-agencia-fim in frame {&FRAME-NAME}.
            RETURN "ADM-ERROR":U. 
        end.

        if  i-conta-ini-atz > i-conta-fim-atz then do:
            run utp/ut-msgs.p (input "show",
                               input 252,
                               input "").
            apply 'entry' to i-conta-fim in frame {&FRAME-NAME}.
            RETURN "ADM-ERROR":U. 
        end.

        if  i-nosso-num1-ini-atz > i-nosso-num1-fim-atz then do:
            run utp/ut-msgs.p (input "show",
                               input 252,
                               input "").
            apply 'entry' to i-nosso-num1-fim in frame {&FRAME-NAME}.
            RETURN "ADM-ERROR":U. 
        end.

        if  i-nosso-num2-ini-atz > i-nosso-num2-fim-atz then do:
            run utp/ut-msgs.p (input "show",
                               input 252,
                               input "").
            apply 'entry' to i-nosso-num2-fim in frame {&FRAME-NAME}.
            RETURN "ADM-ERROR":U. 
        end.

        /*fut36887 - atividade 142255*/
        if  adm-new-record AND l-integra-banking-connect:CHECKED AND l-banking-connect then do:
            FIND FIRST  
                b-banco 
            where 
                b-banco.cod-banco <> banco.cod-banco AND
                b-banco.log-2 = YES
            NO-LOCK NO-ERROR.
            IF AVAIL b-banco 
            then do:
                run utp/ut-msgs.p (input "show",
                                   31389,
                                   string(b-banco.cod-banco) + "~~" + string(b-banco.nome-banco)).
                assign l-integra-banking-connect:CHECKED IN FRAME {&FRAME-NAME} = no.
                RETURN "ADM-ERROR":U.
            end.
        END.           

        &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
            find funcao 
               where funcao.cd-funcao = "spp-ems2fin-x-mg" 
               and   funcao.ativo     = yes no-lock no-error.
            if  avail funcao then do:

                if  banco.ag-padrao:sensitive in frame {&FRAME-NAME} = yes then do:
                    assign c-ag-padrao = input frame {&FRAME-NAME} banco.ag-padrao no-error.
                    if  error-status:get-number(1) <> 0 then do:
                        assign banco.ag-padrao:format in frame {&FRAME-NAME} = "x(08)".
                    end.

                    if  input frame {&FRAME-NAME} banco.ag-padrao <> "" then do:
                        assign banco.ag-padrao:format in frame {&FRAME-NAME} = "999999-X"
                               c-ag-padrao = input frame {&FRAME-NAME} banco.ag-padrao no-error.
                        if  error-status:get-number(1) <> 0 then do:
                            run utp/ut-msgs.p (input "show",
                                               input 25077,
                                               input " ").
                            apply 'entry':U to banco.ag-padrao in frame {&FRAME-NAME}.
                            return 'ADM-ERROR':U.
                        end.       
                    end.            
                end.
            end.  
        &ENDIF

        assign c-agencia-ini-aux      = i-agencia-ini:screen-value in frame {&FRAME-NAME}
               c-agencia-fim-aux      = i-agencia-fim :screen-value in frame {&FRAME-NAME}
               c-conta-ini-aux        = i-conta-ini:screen-value in frame {&FRAME-NAME}
               c-conta-fim-aux        = i-conta-fim:screen-value in frame {&FRAME-NAME}
               c-nosso-num1-ini-aux   = i-nosso-num1-ini:screen-value in frame {&FRAME-NAME}
               c-nosso-num1-fim-aux   = i-nosso-num1-fim:screen-value in frame {&FRAME-NAME}
               c-nosso-num2-ini-aux   = i-nosso-num2-ini:screen-value in frame {&FRAME-NAME}
               c-nosso-num2-fim-aux   = i-nosso-num2-fim:screen-value in frame {&FRAME-NAME}
               c-valor-titulo-ini-aux = i-valor-titulo-ini:screen-value in frame {&FRAME-NAME}
               c-valor-titulo-fim-aux = i-valor-titulo-fim:screen-value in frame {&FRAME-NAME}.
               c-integra-banking-connect-aux = l-integra-banking-connect:CHECKED in frame {&FRAME-NAME}.
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

        if  return-value <> "ADM-ERROR" then do:
            assign banco.char-1 = c-agencia-ini-aux + 
                                  c-agencia-fim-aux + 
                                  c-conta-ini-aux +
                                  c-conta-fim-aux +
                                  c-nosso-num1-ini-aux +
                                  c-nosso-num1-fim-aux +
                                  c-nosso-num2-ini-aux +
                                  c-nosso-num2-fim-aux +
                                  c-valor-titulo-ini-aux +
                                  c-valor-titulo-fim-aux.
        end.

        /*---- Rotina Usada para C¢digo Barras Contas a Pagar ----*/
        assign i-cont-febraban = 0.
        for each  b-banco no-lock
            where b-banco.cod-febraban = input frame {&FRAME-NAME} banco.cod-febraban:
            assign i-cont-febraban = i-cont-febraban + 1.
        end.

        assign i-agencia-ini:screen-value in frame {&FRAME-NAME} = c-agencia-ini-aux
               i-agencia-fim :screen-value in frame {&FRAME-NAME} = c-agencia-fim-aux
               i-conta-ini:screen-value in frame {&FRAME-NAME} = c-conta-ini-aux
               i-conta-fim:screen-value in frame {&FRAME-NAME} = c-conta-fim-aux
               i-nosso-num1-ini:screen-value in frame {&FRAME-NAME} = c-nosso-num1-ini-aux
               i-nosso-num1-fim:screen-value in frame {&FRAME-NAME} = c-nosso-num1-fim-aux
               i-nosso-num2-ini:screen-value in frame {&FRAME-NAME} = c-nosso-num2-ini-aux
               i-nosso-num2-fim:screen-value in frame {&FRAME-NAME} = c-nosso-num2-fim-aux
               i-valor-titulo-ini:screen-value in frame {&FRAME-NAME} = c-valor-titulo-ini-aux
               i-valor-titulo-fim:screen-value in frame {&FRAME-NAME} = c-valor-titulo-fim-aux
               l-integra-banking-connect:checked in frame {&FRAME-NAME} = c-integra-banking-connect-aux.


        if input frame {&FRAME-NAME} banco.cod-febraban > 0 then do:     
            if  i-cont-febraban > 1 then do:    
                run utp/ut-msgs.p (input "show",
                                   input 16124,
                                   input "").           
                if  return-value <> 'yes' then do:
                    apply 'entry' to i-agencia-ini in frame {&FRAME-NAME}.
                    UNDO, RETURN "ADM-ERROR":U. 
                end.
            end.
        end.

        /********** Integraá∆o EMS 2.04 x Magnus I.01(Replicaá∆o) **********/
        {cdp/cd0002i1.i banco}
        /********** Fim Integraá∆o EMS 2.04 x Magnus I.01(Replicaá∆o) **********/

        assign banco.ins-banc[1] = i-banc1
               banco.ins-banc[2] = i-banc2.

        run pi-versao (input 3).         

        /* Banking Connect - fut36887 - atividade 143442 */ 
        if l-banking-connect then
          assign banco.log-2 = l-integra-banking-connect:checked in frame {&FRAME-NAME}.
        /*-----------------*/

        /********************Multiplanta***********************/
        assign c-transacao = "ADM018".
        {cdp/cd7300.i5 "001" c-transacao}
        assign i-tipo-movto = if  banco.cod-banco:sensitive in frame {&frame-name} = yes then 1 else 2.
        run pi-cria-tt-dados (input i-tipo-movto).
        {cdp/cd7300.i6 "001" c-transacao}
        /******************Fim-Multiplanta********************/  
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /*********** BANCOS HISTORICOS ************/
  if  not available(param-global) then
       find first param-global no-lock no-error.

  if  l-funcao-banc-hist-adm then do:
      {bhp/bh9999.i 1 banco banco.cod-banco '' '' '' '' ''}
      if  return-value <> "OK" then return error.
  end.
  /******************************************/

  find first apl-empr-banco use-index banco
     where apl-empr-banco.banco = input frame {&FRAME-NAME} banco.cod-banco no-error.
  if  avail apl-empr-banco then do:
      run utp/ut-msgs.p (input 'show',
                         input 6831,
                         input input frame {&FRAME-NAME} banco.cod-banco).
      return no-apply.
  end.

  /************ Integraá∆o EMS 2.04 x Magnus I.01(Replicaá∆o) - Somente validaá∆o **************/  
  {cdp/cd0002i1.i1 banco "no"}   
  /*********** Fim Integraá∆o EMS 2.04 x Magnus I.01(Replicaá∆o) - Somente validaá∆o ***********/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  if return-value = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  /************ Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) - Atualiza Registro **************/  
  {cdp/cd0002i1.i1 banco "yes"}
  /*********** Fim Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) - Atualiza Registro ***********/  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VALID-HANDLE(v_hdl_reg_produt) THEN
      DELETE PROCEDURE v_hdl_reg_produt.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  run pi-versao (input 5).
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Banking Connect - fut36887 - atividade 143442 */ 
  assign l-integra-banking-connect:sensitive in frame {&FRAME-NAME} = (NOT l-banking-connect).
  /*-----------------*/

  disable {&list-4} with frame {&frame-name}.

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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
  if im-banco:load-image("") in frame {&frame-name} then.
  if avail banco and banco.cod-imagem <> "" then do:
      find imagem no-lock where
              imagem.cod_imagem = banco.cod-imagem no-error.
      if avail imagem then do:
         find catal_img of imagem no-lock no-error.
         if avail catal_img then do:
            assign c-nome = string(catal_img.cod_path_catal + "/" + imagem.img_imagem).
            assign l-funcionou = im-banco:load-image(c-nome) in frame {&frame-name} no-error.
         end.
      end.
  end.            
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mgadm banco emis-extrato c-emis-extrato}

  {utp/ut-liter.i Posiá‰es_C¢digo_Barras}
  assign c-codigo-barras:screen-value in frame {&FRAME-NAME} = trim(return-value).
  assign l-integra-banking-connect:VISIBLE in frame {&FRAME-NAME} = l-banking-connect.
  assign l-integra-banking-connect:sensitive in frame {&FRAME-NAME} = (l-banking-connect AND adm-new-record).
  if  avail banco then do:
      /* Banking Connect - fut36887 - atividade 143442 */ 
      if l-banking-connect then
        assign l-integra-banking-connect:checked in frame {&FRAME-NAME} = banco.log-2.

      /*-----------------*/
      find instrucao 
          where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[1] no-lock no-error.

      if  avail instrucao then
          assign c-desc:screen-value = instrucao.descricao.
      else 
          assign c-desc:screen-value = "".

      find instrucao 
          where instrucao.cod-instr = input frame {&frame-name} banco.ins-banc[2] no-lock no-error.

      if  avail instrucao then
          assign c-desc2:screen-value = instrucao.descricao.
      else 
         assign c-desc2:screen-value = "".

      /*---- Rotina Usada para C¢digo Barras Contas a Pagar ----*/
      assign i-agencia-ini:screen-value    in frame {&FRAME-NAME} = substring(banco.char-1, 01,03)
             i-agencia-fim:screen-value    in frame {&FRAME-NAME} = substring(banco.char-1, 04,03)
             i-conta-ini:screen-value      in frame {&FRAME-NAME} = substring(banco.char-1, 07,03)
             i-conta-fim:screen-value      in frame {&FRAME-NAME} = substring(banco.char-1, 10,03)
             i-nosso-num1-ini:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 13,03)
             i-nosso-num1-fim:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 16,03)
             i-nosso-num2-ini:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 19,03)
             i-nosso-num2-fim:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 22,03).

      run pi-versao (input 4).

  end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /******* Integraá∆o EMS x SISDOC ******/
  /* Banking Connect - fut36887 - atividade 143442 */ 
  assign l-integra-banking-connect:sensitive in frame {&FRAME-NAME} = l-banking-connect.
  /*-----------------*/

  run pi-versao (input 7).

  /***** Fim Integraá∆o EMS x SISDOC ****/
  if adm-new-record then do:
      IF l-banking-connect THEN
      DO:
          ASSIGN l-integra-banking-connect = NO.
          DISP l-integra-banking-connect WITH FRAME {&FRAME-NAME}.
      END.
  END.

  run get-attribute ('adm-new-record').



  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  run pi-cobranca-escritural.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit V-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VALID-HANDLE(v_hdl_reg_produt) THEN
      DELETE PROCEDURE v_hdl_reg_produt.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run pi-versao (input 1).
  /* Banking Connect */ 
  /* Verifica se o usu†ri otem persmiss∆o para usar o Banking Connect */
  &if "{&mgadm_version}" >= "2.04" &then
      &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
          /* Procura o registro */
          run find_registro in v_hdl_reg_produt (OUTPUT l-registro-ok, OUTPUT c-empresa-banking).
    
          /* Se encontrar verifica a data limite */
          IF l-registro-ok then do:
              RUN retorna_data_limite IN v_hdl_reg_produt (OUTPUT d-limite).
    
              /* Se a data Limite Ç valida */
              assign l-banking-connect = TODAY <= d-limite.
    
              /* Mensagem 30 dias antes do prazo do termino da licenáa */
              IF ((d-limite - 30) <= TODAY) and (today <= d-limite) then do:
                  run utp/ut-msgs.p (input "show",
                                     input 31436,
                                     input STRING(d-limite - TODAY)).
              end.
             
              /* Mensagem de vencimento do Banking */
              if (today > d-limite) then do:
                  run utp/ut-msgs.p (input "show",
                                     input 31456,
                                     input STRING(d-limite - TODAY)).
              end.
          end.
      &ELSE
          assign  l-banking-connect = no.
      &ENDIF
  &else
       assign  l-banking-connect = no.
  &endif.  
  assign l-integra-banking-connect:visible in frame {&FRAME-NAME} = l-banking-connect.
  /*-----------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-rtlbl.i mgadm banco emis-extrato c-emis-extrato}

  {utp/ut-liter.i Posiá‰es_C¢digo_Barras}
  assign c-codigo-barras:screen-value in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Parceiro_EDI}
  assign banco.int-1:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Parceiro_EDI_para_Importaá∆o_de_Extratos}
  assign banco.int-1:help in frame {&frame-name} = trim(return-value).

  banco.int-1:format in frame {&frame-name} = "999999".

  &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
      find funcao 
        where funcao.cd-funcao = "spp-ems2fin-x-mg" 
        and   funcao.ativo     = yes no-lock no-error.
      if  avail funcao then do:
          assign banco.ag-padrao:format    in frame {&FRAME-NAME} = "999999-X"
                 banco.cod-febraban:format in frame {&FRAME-NAME} = ">>9"
                 i-agencia-ini:format      in frame {&FRAME-NAME} = ">9"
                 i-agencia-fim:format      in frame {&FRAME-NAME} = ">9"
                 i-conta-ini:format        in frame {&FRAME-NAME} = ">9"
                 i-conta-fim:format        in frame {&FRAME-NAME} = ">9"
                 i-nosso-num1-ini:format   in frame {&FRAME-NAME} = ">9"
                 i-nosso-num1-fim:format   in frame {&FRAME-NAME} = ">9"
                 i-nosso-num2-ini:format   in frame {&FRAME-NAME} = ">9"
                 i-nosso-num2-fim:format   in frame {&FRAME-NAME} = ">9".
      end.
  &ENDIF

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Executar o RPC na integraá∆o EMS 2.04 com o Magnus I.01      
------------------------------------------------------------------------------*/

/********* Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) **********/
{cdp/cd0003i1.i banco "cdp/cd1101i1.p"}
/******* Fim Integraá∆o EMS 2.04 x Magnus I.01 (Replicaá∆o) ********/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cobranca-escritural V-table-Win 
PROCEDURE pi-cobranca-escritural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME} :
     IF input frame {&FRAME-NAME} banco.usa-cob-esc THEN DO:
        ENABLE {&List-4}.
     END.
     ELSE DO:
        DISABLE {&List-4}. 
        assign banco.ins-banc[1]:screen-value in frame {&frame-name} = string(0)
               banco.ins-banc[2]:screen-value in frame {&frame-name} = string(0)
               c-desc:screen-value            in frame {&FRAME-NAME} = ""
               c-desc2:screen-value           in frame {&FRAME-NAME} = "".
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-banco-mg V-table-Win 
PROCEDURE pi-cria-tt-banco-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-ind-tipo-movto /* 1-Inclus∆o 2-Alteraá∆o 3-Exclus∆o */
               p-atualiza /* Indica se ser† atualizado registro ou n∆o */
  Notes: Integraá∆o EMS 2.04 x Magnus I.01      
------------------------------------------------------------------------------*/

def input param p-ind-tipo-movto as int no-undo.
def input param p-atualiza       as log no-undo.

    for each tt-banco-mg:
        delete tt-banco-mg.
    end.

    create tt-banco-mg.
    assign tt-banco-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-banco-mg.cod-banco      = banco.cod-banco.
    assign tt-banco-mg.nome-banco     = fn-free-accent(banco.nome-banco)
           tt-banco-mg.usa-cob-esc    = banco.usa-cob-esc
           tt-banco-mg.vl-lim-aplic   = banco.vl-lim-aplic
           tt-banco-mg.lim-emprest    = banco.lim-emprest.
    assign tt-banco-mg.nome-abrev     = fn-free-accent(banco.nome-abrev)
           tt-banco-mg.ag-padrao      = fn-free-accent(banco.ag-padrao)
           tt-banco-mg.cod-resp       = fn-free-accent(banco.cod-resp).
    assign tt-banco-mg.cod-febraban   = banco.cod-febraban.
    assign tt-banco-mg.agencia-ini    = int(string(i-agencia-ini-atz, "999"))
           tt-banco-mg.agencia-fim    = int(string(i-agencia-fim-atz, "999"))
           tt-banco-mg.cta-corr-ini   = int(string(i-conta-ini-atz, "999"))
           tt-banco-mg.cta-corr-fim   = int(string(i-conta-fim-atz, "999"))
           tt-banco-mg.num-tit-1-ini  = int(string(i-nosso-num1-ini-atz, "999"))
           tt-banco-mg.num-tit-1-fim  = int(string(i-nosso-num1-fim-atz, "999"))
           tt-banco-mg.num-tit-2-ini  = int(string(i-nosso-num2-ini-atz, "999"))
           tt-banco-mg.num-tit-2-fim  = int(string(i-nosso-num2-fim-atz, "999"))
           tt-banco-mg.num-seq-pag    = banco.int-2
           tt-banco-mg.l-atualiza     = p-atualiza.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-banco-aux.
    buffer-copy banco to tt-banco-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 49
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(banco.cod-banco).
    raw-transfer tt-banco-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{cdp/cd0004i1.i "cd1101" "banco" "tt-banco-mg.cod-banco" "tt-banco-mg.ind-tipo-movto" "tt-erros-mg.help-msg"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-banco-mg V-table-Win 
PROCEDURE pi-valida-banco-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: p-ind-tipo-movto
  Notes:       
------------------------------------------------------------------------------*/
def input-output param p-ind-tipo-movto as int no-undo.

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-versao V-table-Win 
PROCEDURE pi-versao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ind as int no-undo.

    &if "{&mgadm_version}" >= "2.02" &then    
        case p-ind:
            when 1 then do: /* initialize */
                assign i-valor-titulo-ini:visible    in frame {&FRAME-NAME} = yes 
                       i-valor-titulo-fim:visible    in frame {&FRAME-NAME} = yes
                       image-35          :visible    in frame {&FRAME-NAME} = yes
                       image-36          :visible    in frame {&FRAME-NAME} = yes
                       i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                       i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
            end.

            when 2 then do: /* assign */
                assign i-banc1              = input frame {&frame-name} banco.ins-banc[1]
                       i-banc2              = input frame {&frame-name} banco.ins-banc[2]
                       i-agencia-ini-atz    = input frame {&FRAME-NAME} i-agencia-ini
                       i-agencia-fim-atz    = input frame {&FRAME-NAME} i-agencia-fim
                       i-conta-ini-atz      = input frame {&FRAME-NAME} i-conta-ini
                       i-conta-fim-atz      = input frame {&FRAME-NAME} i-conta-fim
                       i-nosso-num1-ini-atz = input frame {&FRAME-NAME} i-nosso-num1-ini
                       i-nosso-num1-fim-atz = input frame {&FRAME-NAME} i-nosso-num1-fim
                       i-nosso-num2-ini-atz = input frame {&FRAME-NAME} i-nosso-num2-ini
                       i-nosso-num2-fim-atz = input frame {&FRAME-NAME} i-nosso-num2-fim
                       i-valor-titulo-ini-atz = input frame {&FRAME-NAME} i-valor-titulo-ini
                       i-valor-titulo-fim-atz = input frame {&FRAME-NAME} i-valor-titulo-fim.

                if  i-valor-titulo-ini-atz > i-valor-titulo-fim-atz then 
                    do:
                      run utp/ut-msgs.p (input "show",
                                         input 252,
                                         input "").
                      apply 'entry' to i-valor-titulo-fim in frame {&FRAME-NAME}.
                      RETURN "ADM-ERROR":U. 
                    end.

            end.        

            when 3 then do: /* assign */
                &if defined(BF_FIN_GPS) &then
                    assign banco.nr-ultima-gps = input frame {&FRAME-NAME} de-ultima-gps.
                &else
                    assign banco.dec-1 = input frame {&FRAME-NAME} de-ultima-gps.
                &endif    

                 /*---- Rotina Usada para C¢digo Barras Contas a Pagar ----*/
                for each  b-banco exclusive-lock
                    where b-banco.cod-febraban = banco.cod-febraban:
                        assign b-banco.char-1 =                  string(i-agencia-ini-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-agencia-fim-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-conta-ini-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-conta-fim-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-nosso-num1-ini-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-nosso-num1-fim-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-nosso-num2-ini-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-nosso-num2-fim-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-valor-titulo-ini-atz, "999")
                               b-banco.char-1 = b-banco.char-1 + string(i-valor-titulo-fim-atz, "999").
                end.
            end.
            when 4 then do: /* display */

                /*---- Rotina Usada para C¢digo Barras Contas a Pagar ----*/
                assign i-valor-titulo-ini:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 25,03)
                       i-valor-titulo-fim:screen-value in frame {&FRAME-NAME} = substring(banco.char-1, 28,03).

                if  adm-new-record    = YES 
                and adm-adding-record = NO then 
                    assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(de-ultima-gps).
                else do:
                   &if defined(BF_FIN_GPS) &then
                       assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(banco.nr-ultima-gps).
                   &else
                       assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(banco.dec-1).
                   &endif  
                end.  
            end.        

           when 5 then do: /* disable */
             assign i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
             end.          

         when 6 then do: /* add-record */
             assign i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = yes
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = yes.
             end.          

         when 7 then do: /* enable */
             assign i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = yes
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = yes.
             end.          

      end case.    
    &endif.


    &if "{&mgadm_version}" < "2.02" &then    
        case p-ind:
            when 1 then do: /* initialize */
                assign i-valor-titulo-ini:visible    in frame {&FRAME-NAME} = no 
                       i-valor-titulo-fim:visible    in frame {&FRAME-NAME} = no
                       image-35          :visible    in frame {&FRAME-NAME} = no
                       image-36          :visible    in frame {&FRAME-NAME} = no
                       i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                       i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
            end.

            when 2 then do: /* assign */
                assign i-banc1              = input frame {&frame-name} banco.ins-banc[1]
                       i-banc2              = input frame {&frame-name} banco.ins-banc[2]
                       i-agencia-ini-atz    = input frame {&FRAME-NAME} i-agencia-ini
                       i-agencia-fim-atz    = input frame {&FRAME-NAME} i-agencia-fim
                       i-conta-ini-atz      = input frame {&FRAME-NAME} i-conta-ini
                       i-conta-fim-atz      = input frame {&FRAME-NAME} i-conta-fim
                       i-nosso-num1-ini-atz = input frame {&FRAME-NAME} i-nosso-num1-ini
                       i-nosso-num1-fim-atz = input frame {&FRAME-NAME} i-nosso-num1-fim
                       i-nosso-num2-ini-atz = input frame {&FRAME-NAME} i-nosso-num2-ini
                       i-nosso-num2-fim-atz = input frame {&FRAME-NAME} i-nosso-num2-fim.

            end.        

        when 3 then do: /* assign */

            &if defined(BF_FIN_GPS) &then
                assign banco.nr-ultima-gps = input frame {&FRAME-NAME} de-ultima-gps.
            &else
                assign banco.dec-1 = input frame {&FRAME-NAME} de-ultima-gps.
            &endif    

            /*---- Rotina Usada para C¢digo Barras Contas a Pagar ----*/
            for each  b-banco exclusive-lock
                where b-banco.cod-febraban = banco.cod-febraban:
                    assign b-banco.char-1 =                  string(i-agencia-ini-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-agencia-fim-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-conta-ini-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-conta-fim-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-nosso-num1-ini-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-nosso-num1-fim-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-nosso-num2-ini-atz, "999")
                           b-banco.char-1 = b-banco.char-1 + string(i-nosso-num2-fim-atz, "999").
            end.
        end.

         when 4 then do:
             if  adm-new-record    = YES 
             and adm-adding-record = NO then 
                 assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(de-ultima-gps).
             else do:
                &if defined(BF_FIN_GPS) &then
                    assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(banco.nr-ultima-gps).
                &else
                    assign de-ultima-gps:screen-value in frame {&FRAME-NAME} = string(banco.dec-1).
                &endif  
             end.  
         end.        
         when 5 then do: /* disable */
             assign i-valor-titulo-ini:visible    in frame {&FRAME-NAME} = no 
                    i-valor-titulo-fim:visible    in frame {&FRAME-NAME} = no
                    image-35          :visible    in frame {&FRAME-NAME} = no
                    image-36          :visible    in frame {&FRAME-NAME} = no
                    i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
             end.          

         when 6 then do: /* add-record */
             assign i-valor-titulo-ini:visible    in frame {&FRAME-NAME} = no 
                    i-valor-titulo-fim:visible    in frame {&FRAME-NAME} = no
                    image-35          :visible    in frame {&FRAME-NAME} = no
                    image-36          :visible    in frame {&FRAME-NAME} = no
                    i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
             end.          

         when 7 then do: /* enable */
             assign i-valor-titulo-ini:visible    in frame {&FRAME-NAME} = no 
                    i-valor-titulo-fim:visible    in frame {&FRAME-NAME} = no
                    image-35          :visible    in frame {&FRAME-NAME} = no
                    image-36          :visible    in frame {&FRAME-NAME} = no
                    i-valor-titulo-ini:sensitive  in frame {&FRAME-NAME} = no
                    i-valor-titulo-fim:sensitive  in frame {&FRAME-NAME} = no.
             end.          
        end case.    
    &endif.



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
  {src/adm/template/snd-list.i "banco"}

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

