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
{include/i-prgvrs.i V14IN582 2.00.01.061 } /*** "010161" 11/04/2025 12:07:38  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v14in582 MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cd0666.i}  /* definiÁ„o da tt-erro    */
{cdp/cd9731.i1} /* l-integra-cn-in-medicao */
{cdp/cd9731.i2} /* l-matriz-medicao        */
{method/dbotterr.i} /*rowErrors*/
   
{cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-num-seq           AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-result            AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-msg               AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-mens              AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-msg-item          AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-msg-lim-val       AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-msg-lim-qtde      AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-trad-liter        AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-permissao-1       AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-permissao-2       AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE de-qtd-total        AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-val-total        AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-sld-qtd          AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-sld-val          AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-variacao-qtd     AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-variacao-val     AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-qtd-realizada    AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-val-realizado    AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-qtd-tot          AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-val-tot          AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-qtd-tot-item     AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-val-tot-item     AS   DECIMAL                      NO-UNDO.
DEFINE VARIABLE i-num-periodos      AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-sit-anterior      AS   INTEGER                      NO-UNDO.    
DEFINE VARIABLE i-periodos          AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-num-seq           AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-seq-aux-med       AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-seq-aux-eve       AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-numero-ordem-aux  AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-num-seq-item-aux  AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-nr-periodos       AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-frequencia-aux    AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-ind-sit-aux       AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont              AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-ord-manut         AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-ord-manut-ant     AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-num-ord-inv-ant   AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE l-erro-co           AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-msg-tela          AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-cria-rat-med      AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-arredonda-qtde    AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-arredonda-val     AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-matriz            AS   LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-atu-sld-lib       AS   LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-apr-tip-doc       AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-lib-medicao       AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-gera-pendencia    AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE tb-liberada-aux     AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-cn9000            AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-permissao         AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-integra-paradigma AS   LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-pendente          AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-envio             AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-integra-mla       AS   LOGICAL                      NO-UNDO.   
DEFINE VARIABLE hshowmsg            AS   HANDLE                       NO-UNDO.
DEFINE VARIABLE h-cnapi003          AS   HANDLE                       NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl      AS   HANDLE                       NO-UNDO.
DEFINE VARIABLE v-row-parent        AS   ROWID                        NO-UNDO.
DEFINE VARIABLE r-rowid-oracle      AS   ROWID                        NO-UNDO.
DEFINE VARIABLE c-nr-contrato-aux   LIKE contrato-for.nr-contrato     NO-UNDO.
DEFINE VARIABLE v-qtd-prevista      LIKE medicao-contrat.qtd-prevista NO-UNDO.
DEFINE VARIABLE v-val-previsto      LIKE medicao-contrat.val-previsto NO-UNDO.
DEFINE VARIABLE v-perc-previsto     LIKE medicao-contrat.perc-medicao NO-UNDO.
DEFINE VARIABLE i-empresa           LIKE empresa.ep-codigo            NO-UNDO.

/* Global variable definitions ---                                       */
DEFINE NEW SHARED VARIABLE c-cod-estabel              LIKE estabelec.cod-estabel.
DEFINE NEW GLOBAL SHARED VARIABLE gr-nr-contrato      LIKE evento-ped.nr-contrato                NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-motivo-alter      LIKE hist-alter.des-motivo-alter           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-texto-orig        LIKE hist-tex-ori.alter-texto-origem       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-texto             LIKE hist-tex-des.alter-texto-destino      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-alterado          AS   CHARACTER FORMAT "x(76)":U            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-tipo-alter        AS   CHARACTER FORMAT "!":U INITIAL "C":U  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-alter-origem      AS   CHARACTER FORMAT "x(76)":U            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-gera-cn0302       AS   LOGICAL                               NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-replica           AS   LOGICAL INITIAL NO                    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE lg-nao-altera-preco AS   LOGICAL INITIAL NO                    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-contrato-for     AS   ROWID                                 NO-UNDO.

/* Temp Table Definitions ---                                       */

{include/boerrtab.i} /* tt-bo-erro                                    */
{utp/utapi009.i}     /* tt-envio, tt-erros                            */
{cnp/cnapi020.i3}    /* Integracao Contratos - declaracao temp-tables */

IF l-integra-cn-in-medicao THEN DO:
    {inp/inapi402.i}     /* tt-mat-rat-med-inv */
END.

DEFINE TEMP-TABLE tt-entrega NO-UNDO
    FIELD cd-freq        LIKE frequencia.cd-freq 
    FIELD nr-sequencia   AS INTEGER 
    FIELD dat-entrega    AS DATE.

DEFINE TEMP-TABLE tt-erro-aed NO-UNDO
    FIELD i-sequen AS INTEGER             
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U
    FIELD c-param  AS CHARACTER.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistencia".

DEFINE TEMP-TABLE tt-item-contrat    NO-UNDO LIKE item-contrat.
DEFINE TEMP-TABLE tt-contrato-for    NO-UNDO LIKE contrato-for.
DEFINE TEMP-TABLE tt-medicao-contrat NO-UNDO LIKE medicao-contrat.

/* Buffers Definitions ---                                       */
DEFINE BUFFER b-medicao-contrat FOR medicao-contrat.
DEFINE BUFFER b-item-contrat    FOR item-contrat.
DEFINE BUFFER b-doc-pend-aprov  FOR doc-pend-aprov.
DEFINE BUFFER b-ordem-inv       FOR ordem-inv.

{cnp/cn0201.i} /* function f-retorna-campo-temp-table */
{cep/ce1234.i} /* Validaá∆o Decimais - FN_AJUST_DEC_ANT, FN_VLD_AJUST_DEC_ANT */

ASSIGN l-integra-mla = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "Integra_MLA_EMS":U AND funcao.ativo).


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE SmartViewer
&SCOPED-DEFINE DB-AWARE NO

&SCOPED-DEFINE ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&SCOPED-DEFINE FRAME-NAME f-main

/* External Tables                                                      */
&SCOPED-DEFINE EXTERNAL-TABLES medicao-contrat
&SCOPED-DEFINE FIRST-EXTERNAL-TABLE medicao-contrat

/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR medicao-contrat.
/* Standard List Definitions                                            */
&SCOPED-DEFINE ENABLED-FIELDS medicao-contrat.dat-prev-medicao ~
medicao-contrat.un medicao-contrat.qtd-prevista medicao-contrat.responsavel ~
medicao-contrat.val-previsto medicao-contrat.perc-medicao ~
medicao-contrat.observacao 
&SCOPED-DEFINE ENABLED-TABLES medicao-contrat
&SCOPED-DEFINE FIRST-ENABLED-TABLE medicao-contrat
&SCOPED-DEFINE ENABLED-OBJECTS fi-frequencia fi-periodos tb-liberada ~
i-ind-sit-medicao fi-ord-manut rt-mold rt-mold-2 rt-mold-3 rt-mold-4 
&SCOPED-DEFINE DISPLAYED-FIELDS medicao-contrat.num-seq-event ~
medicao-contrat.num-seq-medicao medicao-contrat.dat-prev-medicao ~
medicao-contrat.un medicao-contrat.qtd-prevista medicao-contrat.responsavel ~
medicao-contrat.val-previsto medicao-contrat.perc-medicao ~
medicao-contrat.observacao 
&SCOPED-DEFINE DISPLAYED-TABLES medicao-contrat
&SCOPED-DEFINE FIRST-DISPLAYED-TABLE medicao-contrat
&SCOPED-DEFINE DISPLAYED-OBJECTS i-nr-contrato c-desc-contrat ~
c-cod-estabelec c-desc-estabelec i-numero-ordem i-num-seq-item ~
fi-frequencia c-descricao fi-periodos tb-liberada i-ind-sit-medicao ~
fi-ord-manut i-num-ord-inv 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-cod-estabelec LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-contrat AS CHARACTER FORMAT "x(32)":U 
     VIEW-AS FILL-IN 
     SIZE 49.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabelec AS CHARACTER FORMAT "x(32)":U  
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U  
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88.

DEFINE VARIABLE c-narrat-compra AS CHARACTER FORMAT "x(76)":U  
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-frequencia AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ord-manut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ord Manut" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodos AS INTEGER FORMAT ">>9":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-contrato AS INTEGER FORMAT ">>>,>>>,>>9":U  INITIAL 0 
     LABEL "N£mero Contrato":R18 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE i-num-ord-inv AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Ordem Invest" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-item AS INTEGER FORMAT ">>,>>9":U  INITIAL 0 
     LABEL "Sequància Item":R17 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT "zzzzz9,99":U  INITIAL 0 
     LABEL "Ordem":R7 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE VARIABLE i-ind-sit-medicao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendente", 1,
          "Liberada", 2
     SIZE 24.29 BY .75 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.38.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.38.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.17.

DEFINE RECTANGLE rt-mold-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.38.

DEFINE VARIABLE tb-liberada AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-nr-contrato AT ROW 1.29 COL 19.72 COLON-ALIGNED
     c-desc-contrat AT ROW 1.29 COL 37.29 COLON-ALIGNED HELP
          "DescriÁ„o do contrato modelo" NO-LABEL
     c-cod-estabelec AT ROW 2.29 COL 19.72 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     c-desc-estabelec AT ROW 2.29 COL 27.43 COLON-ALIGNED HELP
          "DescriÁ„o do contrato modelo" NO-LABEL
     i-numero-ordem AT ROW 2.29 COL 75 COLON-ALIGNED
     i-num-seq-item AT ROW 3.29 COL 19.72 COLON-ALIGNED
     c-it-codigo AT ROW 3.29 COL 28.43 COLON-ALIGNED NO-LABEL
     c-narrat-compra AT ROW 3.29 COL 45.57 COLON-ALIGNED HELP
          "Narrativa do material ou serviÁo a ser contratdo." NO-LABEL
     medicao-contrat.num-seq-event AT ROW 4.29 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     medicao-contrat.num-seq-medicao AT ROW 4.29 COL 62.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     fi-frequencia AT ROW 5.83 COL 19.72 COLON-ALIGNED
     c-descricao AT ROW 5.83 COL 27 COLON-ALIGNED NO-LABEL
     fi-periodos AT ROW 6.83 COL 19.72 COLON-ALIGNED
     tb-liberada AT ROW 6.88 COL 36.86
     medicao-contrat.dat-prev-medicao AT ROW 8.29 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     medicao-contrat.un AT ROW 8.29 COL 62.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     medicao-contrat.qtd-prevista AT ROW 9.29 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     medicao-contrat.responsavel AT ROW 9.29 COL 62.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     medicao-contrat.val-previsto AT ROW 10.29 COL 19.72 COLON-ALIGNED
          LABEL "Vl Previsto":R17
          VIEW-AS FILL-IN 
          SIZE 20 BY .88 FORMAT "->>>,>>>,>>>,>>9.9999":U
     i-ind-sit-medicao AT ROW 10.38 COL 64.43 NO-LABEL
     medicao-contrat.perc-medicao AT ROW 11.29 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-ord-manut AT ROW 11.29 COL 62.57 COLON-ALIGNED
     i-num-ord-inv AT ROW 12.29 COL 62.57 COLON-ALIGNED
     medicao-contrat.observacao AT ROW 13.67 COL 1.86 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 87 BY 1.75
     rt-mold AT ROW 1 COL 1
     rt-mold-2 AT ROW 8 COL 1
     rt-mold-3 AT ROW 13.5 COL 1
     rt-mold-4 AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.medicao-contrat
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
         HEIGHT             = 14.67
         WIDTH              = 88.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabelec IN FRAME f-main
   NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-desc-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-narrat-compra IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN i-nr-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-num-ord-inv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-num-seq-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-numero-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN medicao-contrat.num-seq-event IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN medicao-contrat.num-seq-medicao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN medicao-contrat.val-previsto IN FRAME f-main
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

&Scoped-define SELF-NAME medicao-contrat.dat-prev-medicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.dat-prev-medicao V-table-Win
ON ENTRY OF medicao-contrat.dat-prev-medicao IN FRAME f-main /* Data Previs∆o */
DO:
    IF  AVAILABLE item-contrat 
    AND item-contrat.log-control-event AND adm-new-record AND INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event = 0 THEN DO:

        APPLY "entry":U TO medicao-contrat.num-seq-event IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON ENTRY OF fi-frequencia IN FRAME f-main
DO:
    IF  AVAILABLE item-contrat 
    AND item-contrat.log-control-event AND adm-new-record AND INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event = 0 THEN DO:

        APPLY "entry":U TO medicao-contrat.num-seq-event IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON F5 OF fi-frequencia IN FRAME f-main
DO:
   ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=fi-frequencia
                     &campozoom=cd-freq
                     &campo2=c-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON LEAVE OF fi-frequencia IN FRAME f-main
DO:
    IF INPUT FRAME {&FRAME-NAME} fi-frequencia = 0 THEN
       ASSIGN fi-frequencia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
    ELSE DO:

        FIND FIRST frequencia
             WHERE frequencia.cd-freq = INPUT FRAME {&FRAME-NAME} fi-frequencia NO-LOCK NO-ERROR.

        IF AVAIL frequencia THEN DO:

            ASSIGN c-descricao:SCREEN-VALUE = frequencia.descricao.

            IF l-gera-cn0302 AND frequencia.tp-freq = 1 THEN
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 19666, INPUT "").
        END.
        ELSE DO:

            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6070, INPUT "").

            ASSIGN c-descricao:SCREEN-VALUE = "".
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-frequencia IN FRAME f-main
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ord-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON F5 OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                       &campo=fi-ord-manut
                       &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON LEAVE OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
    FIND FIRST ord-manut NO-LOCK
         WHERE ord-manut.nr-ord-produ = INPUT FRAME {&FRAME-NAME} fi-ord-manut NO-ERROR.
      
    IF AVAIL ord-manut THEN
        ASSIGN i-num-ord-inv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ord-manut.num-ord-inv). 
    ELSE IF AVAIL medicao-contrat THEN
        ASSIGN i-num-ord-inv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(medicao-contrat.num-ord-inv).
    ELSE
        ASSIGN i-num-ord-inv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-seq-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-seq-item V-table-Win
ON F5 OF i-num-seq-item IN FRAME f-main /* Sequància Item */
DO:
    ASSIGN l-implanta = YES.
   {include/zoomvar.i &prog-zoom=inzoom/z01in582.w
                      &campo=i-num-seq-item
                      &campozoom=num-seq-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-seq-item V-table-Win
ON LEAVE OF i-num-seq-item IN FRAME f-main /* Sequància Item */
DO:
    RUN pi-habilita-om.

    FIND FIRST item-contrat 
         WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato 
           AND item-contrat.num-seq-item = INPUT FRAME {&FRAME-NAME} i-num-seq-item NO-LOCK NO-ERROR.

    IF AVAILABLE item-contrat THEN DO:

        ASSIGN c-narrat-compra:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE item-contrat THEN item-contrat.narrat-compra ELSE "":U
               c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = IF AVAILABLE item-contrat THEN item-contrat.it-codigo ELSE "":U.    

        RUN pi-mostra-item-contrat.        
    END.

    IF i-num-seq-item-aux = 0 OR (i-seq-aux-med > 1 AND i-num-seq-item = 0) THEN DO: 
        
        IF NOT AVAILABLE item-contrat OR (AVAILABLE item-contrat AND item-contrat.ind-sit-item = 3) THEN DO:
            
            {utp/ut-table.i mgind item-contrat 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56, INPUT RETURN-VALUE).

            APPLY "entry":U TO i-num-seq-item IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END.

    RUN pi-val-inclusao-medicao.
    IF RETURN-VALUE = "NOK":U THEN DO:
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-seq-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-num-seq-item IN FRAME f-main /* Sequància Item */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.num-seq-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.num-seq-event V-table-Win
ON F5 OF medicao-contrat.num-seq-event IN FRAME f-main /* Sequància */
DO:
    ASSIGN gr-nr-contrato = INPUT FRAME {&FRAME-NAME} i-nr-contrato
           l-implanta     = yes.
    
    {include/zoomvar.i &prog-zoom=inzoom/z01in112.w
                       &campo=medicao-contrat.num-seq-event
                       &campozoom=seq-evento}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.num-seq-event V-table-Win
ON LEAVE OF medicao-contrat.num-seq-event IN FRAME f-main /* Sequància */
DO:
    RUN pi-calcula-quantidade.  
    RUN pi-mostra-om.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.num-seq-event V-table-Win
ON MOUSE-SELECT-DBLCLICK OF medicao-contrat.num-seq-event IN FRAME f-main /* Sequància */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.perc-medicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.perc-medicao V-table-Win
ON LEAVE OF medicao-contrat.perc-medicao IN FRAME f-main /* Perc. Mediá∆o */
DO:
    IF AVAIL item-contrat THEN DO:

        IF item-contrat.ind-tipo-control-val < 3 THEN DO:
            
            ASSIGN medicao-contrat.qtd-prevista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                      INPUT FRAME {&FRAME-NAME} medicao-contrat.perc-medicao * de-qtd-total / 100)
                   medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                      INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * item-contrat.pre-unit-for).
        END.
        ELSE DO:
            
            ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                      INPUT FRAME {&FRAME-NAME} medicao-contrat.perc-medicao * de-val-total / 100 )
                   medicao-contrat.qtd-prevista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                      INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto / item-contrat.pre-unit-for).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.qtd-prevista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.qtd-prevista V-table-Win
ON LEAVE OF medicao-contrat.qtd-prevista IN FRAME f-main /* Qtde Prevista */
DO:
    IF AVAIL item-contrat THEN DO:

        ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * item-contrat.pre-unit-for).

        IF item-contrat.ind-tipo-control-val = 1 THEN DO:

            IF de-qtd-total <> 0 THEN DO:

                IF (INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * 100 / de-qtd-total ) <= 999 THEN
                    ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                              INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * 100 / de-qtd-total).
                ELSE
                    ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "999,99":U.
            END.
            ELSE
                IF de-val-total <> 0 THEN DO:
                    IF(INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto * 100 / de-val-total ) <= 999 THEN
                        ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                                  INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto * 100 / de-val-total).
                    ELSE
                        ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "999,99":U.
                END.
                ELSE
                    ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "100":U.
        END.
        ELSE DO:

            IF de-qtd-total <> 0 THEN DO:

                IF(INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * 100 / de-qtd-total ) <= 999 THEN
                    ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(
                                                                                              INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista * 100 / de-qtd-total).
                ELSE
                    ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "999,99":U.
            END.
            ELSE
                ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "100":U.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.responsavel V-table-Win
ON F5 OF medicao-contrat.responsavel IN FRAME f-main /* Respons†vel */
DO:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabelec NO-ERROR.

    IF AVAIL estabelec THEN
        RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).
    ELSE
        ASSIGN i-empresa = "".

    IF l-integra-mla
    AND CAN-FIND(FIRST mla-tipo-doc-aprov NO-LOCK 
                 WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                   AND mla-tipo-doc-aprov.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabelec
                   AND mla-tipo-doc-aprov.cod-tip-doc = 14
                   AND mla-tipo-doc-aprov.apr-tip-doc)  THEN DO:
        RUN pi-zoom-z04in785.
    END.
    ELSE DO:
        RUN pi-zoom-z01in627.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.responsavel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF medicao-contrat.responsavel IN FRAME f-main /* Respons†vel */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.un V-table-Win
ON F5 OF medicao-contrat.un IN FRAME f-main /* Unidade Medida */
DO:
    {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                    &tabela=medicao-contrat
                    &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF medicao-contrat.un IN FRAME f-main /* Unidade Medida */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medicao-contrat.val-previsto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medicao-contrat.val-previsto V-table-Win
ON LEAVE OF medicao-contrat.val-previsto IN FRAME f-main /* Vl Previsto */
DO:
    IF de-val-total <> 0 THEN DO:

        IF INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto * 100 / de-val-total <= 999 THEN
            ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto * 100 / de-val-total).
        ELSE
            ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "999,99":U.
    END.
    ELSE
        ASSIGN medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "100":U.

    IF AVAIL item-contrat THEN
        ASSIGN medicao-contrat.qtd-prevista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto / item-contrat.pre-unit-for).
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

{utp/ut-rdset.i i-ind-sit-medicao *}

{utp/ut-liter.i Numero_Contrato * r} 
ASSIGN i-nr-contrato:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

{utp/ut-liter.i Estabelecimento * r}
ASSIGN c-cod-estabelec:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

{utp/ut-liter.i Ordem * r}
ASSIGN i-numero-ordem:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

{utp/ut-liter.i Sequància_Item * r}
ASSIGN i-num-seq-item:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

{utp/ut-liter.i Seq_Evento * r}
ASSIGN medicao-contrat.num-seq-event:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

{utp/ut-field.i mgadm frequencia cd-freq 1}
ASSIGN fi-frequencia:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Nr_Per°odos MCC l}
ASSIGN fi-periodos:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Mediá‰es_Liberadas MCC l}
ASSIGN tb-liberada:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Seq_Evento * r}
ASSIGN medicao-contrat.num-seq-event:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

medicao-contrat.responsavel:LOAD-MOUSE-POINTER ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME}.
medicao-contrat.un:LOAD-MOUSE-POINTER ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME}.

{utp/ut-liter.i Ord_Manut *}
ASSIGN fi-ord-manut:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

IF fi-frequencia:LOAD-MOUSE-POINTER  ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME} THEN.
IF i-num-seq-item:LOAD-MOUSE-POINTER ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME} THEN.
IF fi-ord-manut:LOAD-MOUSE-POINTER   ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME} THEN.

IF medicao-contrat.num-seq-event:LOAD-MOUSE-POINTER ("Image~/lupa.cur":U) IN FRAME {&FRAME-NAME} THEN.

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
  {src/adm/template/row-list.i "medicao-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "medicao-contrat"}

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
    RUN pi-habilita-om.

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    ASSIGN i-sit-anterior = 0.
    RUN pi-mostra-ordem.

    IF adm-new-record THEN DO:

        ASSIGN medicao-contrat.dat-prev-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY)
               i-num-ord-inv:SCREEN-VALUE IN FRAME {&FRAME-NAME}                    =  STRING(0).

        IF contrato-for.ind-control-rec = 1 THEN 
            ASSIGN i-num-seq-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}                  = STRING(i-num-seq-item-aux)
                   medicao-contrat.num-seq-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-seq-aux-med)
                   i-seq-aux-med                                                       = i-seq-aux-med + 1.
    END.

    APPLY "entry":U TO medicao-contrat.dat-prev-medicao.
    
    RUN lap/mlaapi099.p (INPUT 0).

    IF l-integra-mla AND RETURN-VALUE <> "NOK":U THEN
        RUN pi-desab-respons. 
    ELSE DO:

        RUN pi-desab-respons. 

        IF adm-new-record THEN
            ASSIGN medicao-contrat.responsavel:SCREEN-VALUE IN FRAME {&frame-name} = c-seg-usuario.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont               AS   INTEGER                      NO-UNDO.
    DEFINE VARIABLE l-erro-in            AS   LOGICAL                      NO-UNDO.
    DEFINE VARIABLE vl-erro-ct-contabil  AS   LOGICAL   INITIAL NO         NO-UNDO.
    DEFINE VARIABLE de-val-previsto      LIKE medicao-contrat.val-previsto NO-UNDO.

    
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE RowErrors.
    
    IF AVAIL medicao-contrat AND NOT adm-new-record THEN DO:

        IF medicao-contrat.ind-sit-medicao = 2 THEN DO:    
            
            {utp/ut-liter.i "mediá∆o_j†_esta_liberada._modificaá∆o_n∆o_permitida" *}
            RUN utp/ut-msgs.p("show":U, 15825, RETURN-VALUE + ".":U).

            RETURN "ADM-ERROR":U.
        END.
    END.

    IF  adm-new-record 
    AND INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event > 0
    AND NOT CAN-FIND (FIRST evento-ped 
                      WHERE evento-ped.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato
                        AND evento-ped.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item
                        AND evento-ped.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem
                        AND evento-ped.seq-evento    = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event
                        AND evento-ped.log-liber-autom) THEN DO:
        
        {utp/ut-liter.i "evento_n∆o_permite_liberaá‰es_parciais" *}
        ASSIGN c-trad-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "caso_queira_efetuar_liberaá‰es_parciais_para_o_evento,_a_flag_libera_mediá‰es_parciais_dever†_estar_marcada_no_programa_cd0115" *}

        RUN utp/ut-msgs.p("show":U, 15825, c-trad-liter + ". ":U + "~~":U + TRIM(RETURN-VALUE) + ".":U).
        RETURN "ADM-ERROR":U.
    END.    

    /** ValidaÁıes **/ 
    RUN pi-validacoes.

    IF RETURN-VALUE = 'ADM-ERROR':U THEN 
        RETURN 'ADM-ERROR':U.

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.

    IF AVAIL estabelec THEN
        RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).
    ELSE
        ASSIGN i-empresa = "".

    /* Valida se o documento est† parametrizado para ser aprovado */
    ASSIGN l-gera-pendencia = YES.

    RUN lap/mlaapi099.p (INPUT 0).

    IF l-integra-mla AND RETURN-VALUE <> "NOK":U THEN DO:
        
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov NO-LOCK
                        WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa 
                          AND mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel 
                          AND mla-tipo-doc-aprov.cod-tip-doc = 14 
                          AND mla-tipo-doc-aprov.apr-tip-doc = YES) THEN 
            ASSIGN l-gera-pendencia = NO.
    END.

    /* Integracao Contratos - limpa registros temp-table integraá∆o */
    {cnp/cnapi020.i4}

    IF NOT adm-new-record THEN DO:
        /** Integracao contratos - cria registro inclusao - conteudo inicial **/ 
        {cnp/cnapi020.i1 1 2 CN0302A " " medicao-contrat medicao-contrat}
    END.

    ASSIGN l-pendente = NO.

    FIND FIRST contrato-for 
         WHERE contrato-for.nr-contrato = INPUT FRAME {&FRAME-NAME} i-nr-contrato NO-LOCK NO-ERROR.

    RUN cdp/cdapi172.p (10, ROWID(contrato-for), OUTPUT l-pendente).

    IF l-pendente THEN DO:
        
        /*Imposs°vel cadastrar mediá‰ess. Contrato esta pendente de aprovaá∆o!*/
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 26047, INPUT "").
        RETURN "adm-error":U.            
    END.

    ASSIGN INPUT FRAME {&FRAME-NAME} i-ind-sit-medicao.

    IF l-gera-cn0302 THEN DO:

        IF tb-liberada:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
            
            ASSIGN i-ind-sit-medicao = 2
                   i-sit-anterior    = 1.

            RUN cdp/cdapi181.p (INPUT  c-seg-usuario,
                                INPUT  3,
                                INPUT  4,
                                OUTPUT l-permissao).

            IF NOT l-permissao THEN DO:
                {utp/ut-liter.i Liberar * r}
                ASSIGN c-permissao-1 = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Mediá‰es * r}
                ASSIGN c-permissao-2 = TRIM(RETURN-VALUE).

                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 18728, INPUT c-permissao-1 + "~~":U + c-permissao-2).
                RETURN "adm-error":U.
            END.
        END.
        ELSE
            ASSIGN i-ind-sit-medicao = 1 /*pendente*/
                   i-sit-anterior    = 2.
    END.

    IF NOT adm-new-record THEN DO:

        EMPTY TEMP-TABLE tt-medicao-contrat.
    
        CREATE tt-medicao-contrat.
        BUFFER-COPY medicao-contrat TO tt-medicao-contrat.
    END.

    FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = INPUT FRAME {&FRAME-NAME} i-numero-ordem NO-LOCK NO-ERROR.
    
    IF AVAIL ordem-compra THEN DO:

        ASSIGN de-val-previsto = INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto
               l-rejeita-dec   = NO.

        ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(fn_vld_ajust_dec(de-val-previsto,ordem-compra.mo-codigo)).

        IF l-rejeita-dec THEN DO:
            {utp/ut-field.i mgind medicao-contrat val-previsto 1}

            RUN utp/ut-msgs.p("show":U, 18130, TRIM(RETURN-VALUE)).

            APPLY "entry":U TO medicao-contrat.val-previsto IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
    END.

    IF AVAIL ordem-compra THEN
        FIND FIRST item-contrat 
             WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato 
               AND item-contrat.num-seq-item = INPUT FRAME {&FRAME-NAME} i-num-seq-item NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE item-contrat THEN DO:

        {utp/ut-table.i mgind item-contrat 1}
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56, INPUT RETURN-VALUE).

        APPLY "entry":U TO i-num-seq-item IN FRAME {&FRAME-NAME}.
        RETURN "adm-error":U.
    END.
    ELSE
        IF NOT AVAIL ordem-compra THEN DO:
            
            {utp/ut-table.i mgind ordem-compra 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56, INPUT RETURN-VALUE).

            RETURN "adm-error":U.
        END.

    IF item-contrat.ind-sit-item = 3 THEN DO:

        {utp/ut-table.i mgind item-contrat 1}
        ASSIGN c-msg = TRIM(RETURN-VALUE).
        {utp/ut-liter.i est·_cancelado}
        ASSIGN c-msg = c-msg + " " + trim(return-value) + ".".

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT c-msg). 

        APPLY "entry" TO i-num-seq-item IN FRAME {&FRAME-NAME}.
        RETURN "adm-error":U.
    END.

    ASSIGN l-erro-co = NO.

    FIND FIRST tab-unidade 
         WHERE tab-unidade.un = INPUT FRAME {&FRAME-NAME} medicao-contrat.un NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tab-unidade THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 846, INPUT "").

        APPLY "entry":U TO medicao-contrat.un.
        RETURN "adm-error":U. 
    END.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    IF item-contrat.log-control-event THEN
        FIND FIRST evento-ped
             WHERE evento-ped.seq-evento    = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event
               AND evento-ped.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato
               AND evento-ped.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item
               AND evento-ped.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem NO-LOCK NO-ERROR.

    IF NOT item-contrat.log-control-event OR (AVAILABLE evento-ped and evento-ped.log-liber-autom) THEN DO:

        IF l-gera-cn0302 THEN DO:

            IF tb-liberada:CHECKED IN FRAME {&FRAME-NAME} THEN DO:

                ASSIGN i-ind-sit-medicao = 2 /*liberada*/
                       i-sit-anterior    = 1.

                RUN cdp/cdapi181.p (INPUT  c-seg-usuario,
                                    INPUT  3,
                                    INPUT  4,
                                    OUTPUT l-permissao).

                IF NOT l-permissao THEN DO:

                    {utp/ut-liter.i Liberar * r}
                    ASSIGN c-permissao-1 = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Mediá‰es * r}
                    ASSIGN c-permissao-2 = TRIM(RETURN-VALUE).

                    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 18728, INPUT c-permissao-1 + "~~":U + c-permissao-2).
                    RETURN "adm-error":U.
                END.

                IF l-matriz-medicao THEN DO:

                    FIND FIRST matriz-rat-item 
                         WHERE matriz-rat-item.nr-contrato  = INPUT FRAME {&FRAME-NAME} i-nr-contrato 
                           AND matriz-rat-item.num-seq-item = INPUT FRAME {&FRAME-NAME} i-num-seq-item NO-LOCK NO-ERROR.

                    IF NOT AVAIL matriz-rat-item THEN DO:
                        
                        ASSIGN l-matriz = YES.

                        FIND FIRST matriz-rat-contr
                             WHERE matriz-rat-contr.nr-contrato = INPUT FRAME {&FRAME-NAME} i-nr-contrato NO-LOCK NO-ERROR.

                       IF NOT AVAIL matriz-rat-contr THEN
                           ASSIGN l-matriz = YES.
                       ELSE
                           ASSIGN l-matriz = NO.
                    END.
                    ELSE
                        ASSIGN l-matriz = NO.

                    /* se nao foi encontrado matriz-rat-contr ou matriz-rat-item **
                    ** e nos parametros do contrato nao estiver parametrizado    **
                    ** para liberar sem matriz, apresenta mensagem e nao cria    */

                    IF NOT l-lib-sem-matriz  
                    AND l-matriz 
                    AND (   (l-rat-contr-tot AND contrato-for.ind-control-rec = 1 )                                /* Contrato com controle total nota e rateio total nota */ 
                         OR (l-rat-med AND item-contrat.ind-tipo-control = 1 AND contrato-for.ind-control-rec = 2) /* Contrato por mediá∆o e controle rateio por mediá∆o */   
                        ) THEN DO:

                        ASSIGN i-ind-sit-medicao = 1 /*pendente*/
                               i-sit-anterior    = 2.

                        RUN utp/ut-msgs.p(INPUT "show":U, 
                                          INPUT 28385,
                                          INPUT STRING(INPUT FRAME {&FRAME-NAME} i-nr-contrato)  + '~~':U +
                                          STRING(INPUT FRAME {&FRAME-NAME} i-num-seq-item) + '~~':U +
                                          STRING(INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-medicao) ).

                        UNDO,RETURN 'ADM-ERROR':U.
                    END.
                    ELSE
                        ASSIGN i-ind-sit-medicao = 2 /*liberada*/
                               i-sit-anterior    = 1.
                END.
            END.
            ELSE
                ASSIGN i-ind-sit-medicao = 1 /*pendente*/
                       i-sit-anterior    = 2.
        END.
    END.

    ASSIGN INPUT FRAME {&FRAME-NAME} c-desc-contrat    
           INPUT FRAME {&FRAME-NAME} c-cod-estabelec   
           INPUT FRAME {&FRAME-NAME} c-desc-estabelec. 

    ASSIGN i-seq-aux-med      = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-medicao
           i-seq-aux-eve      = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event
           c-nr-contrato-aux  = INPUT FRAME {&FRAME-NAME} i-nr-contrato
           i-numero-ordem-aux = INPUT FRAME {&FRAME-NAME} i-numero-ordem
           i-num-seq-item-aux = INPUT FRAME {&FRAME-NAME} i-num-seq-item
           i-nr-periodos      = INPUT FRAME {&FRAME-NAME} fi-periodos
           i-frequencia-aux   = INPUT FRAME {&FRAME-NAME} fi-frequencia
           i-ind-sit-aux      = INTEGER(i-ind-sit-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           l-lib-medicao      = YES. 

     ASSIGN l-arredonda-qtde = NO
            l-arredonda-val  = NO.

    IF NOT adm-new-record AND NOT l-gera-cn0302 THEN DO:
        
        IF NOT item-contrat.log-control-event OR (AVAILABLE evento-ped AND evento-ped.log-liber-autom) THEN DO:

            ASSIGN l-erro-co = NO.

            IF medicao-contrat.ind-sit-medicao = 2 /* Liberada */ THEN DO:

                IF  AVAIL item-contrat AND item-contrat.ind-un-contrato = 1 /* Valor */ 
                AND (INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto > 0 OR INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista > 0) THEN
                    RUN pi-arredondamento(INPUT (INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista),
                                          INPUT (INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto)).

                IF l-arredonda-qtde THEN
                    ASSIGN medicao-contrat.qtd-prevista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-qtd-prevista)
                           medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-perc-previsto).

                IF l-arredonda-val THEN
                    ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-val-previsto).

                RUN cnp/cnapi003.p (INPUT  ROWID(item-contrat),    
                                    INPUT  (medicao-contrat.qtd-prevista - INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista),
                                    INPUT  (medicao-contrat.val-previsto - INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto),
                                    INPUT  (medicao-contrat.qtd-prevista - INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista),
                                    INPUT  (medicao-contrat.val-previsto - INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto),
                                    INPUT  0,
                                    INPUT  0,
                                    INPUT  c-cod-estabel,
                                    OUTPUT l-msg-tela,
                                    OUTPUT l-erro-co,
                                    INPUT-OUTPUT TABLE tt-erro).

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF AVAIL tt-erro THEN
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                IF l-erro-co THEN DO:
                    UNDO,RETURN 'ADM-ERROR':U.
                END.
            END.

            IF medicao-contrat.num-seq-event = 0 AND medicao-contrat.ind-sit-medicao = 1 THEN DO:
                
                IF  AVAIL item-contrat AND item-contrat.ind-un-contrato = 1 /* Valor */ 
                AND (INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto > 0 OR INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista > 0) THEN
                    RUN pi-arredondamento(INPUT (INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista),
                                          INPUT (INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto)).

                IF l-arredonda-qtde THEN
                    ASSIGN medicao-contrat.qtd-prevista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-qtd-prevista)
                           medicao-contrat.perc-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-perc-previsto).

                IF l-arredonda-val THEN
                    ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(v-val-previsto).
                ELSE 
                    ASSIGN medicao-contrat.val-previsto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TRUNCATE(INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto,2)).

                RUN cnp/cnapi003.p (INPUT  ROWID(item-contrat),
                                    INPUT  (INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista - medicao-contrat.qtd-prevista),                                       
                                    INPUT  (INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto - medicao-contrat.val-previsto),
                                    INPUT  0,
                                    INPUT  0,
                                    INPUT  0,
                                    INPUT  0,
                                    INPUT  c-cod-estabel, 
                                    OUTPUT l-msg-tela,
                                    OUTPUT l-erro-co,
                                    INPUT-OUTPUT TABLE tt-erro).

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF AVAIL tt-erro THEN
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                IF l-erro-co THEN DO:
                    UNDO,RETURN 'ADM-ERROR':U.
                END.
            END.

            IF l-erro-co THEN
                UNDO, RETURN.
        END.
    END.

    /* Dispatch standard ADM method.                             */

    ASSIGN tb-liberada-aux = tb-liberada:CHECKED IN FRAME {&FRAME-NAME}.
   
    ASSIGN INPUT FRAME {&FRAME-NAME} i-num-ord-inv.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        UNDO, RETURN 'ADM-ERROR':U.

    RUN pi-assign.

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        UNDO, RETURN 'ADM-ERROR':U.

    ASSIGN medicao-contrat.ind-sit-medicao = 1.
   
    IF l-integra-paradigma THEN DO:

        RUN ccp/ccapi342.p (INPUT  "medicao-contrat":U,
                            INPUT  ROWID(medicao-contrat),
                            OUTPUT TABLE RowErrors).

        IF RETURN-VALUE = "NOK":U THEN
            UNDO, RETURN 'ADM-ERROR':U.
    END.

    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    IF param-aprov.aprova-total-medic AND NOT l-integra-mla THEN DO:

        FIND FIRST doc-pend-aprov 
             WHERE INTEGER(SUBSTRING(doc-pend-aprov.char-1,1,16)) = INTEGER(medicao-contrat.nr-contrato) 
               AND  doc-pend-aprov.ind-tip-doc                    = 12 
               AND  doc-pend-aprov.ind-situacao                   = 1 NO-LOCK NO-ERROR.

        FIND FIRST b-doc-pend-aprov 
             WHERE INTEGER(SUBSTRING(b-doc-pend-aprov.char-1,1,16)) = INTEGER(medicao-contrat.nr-contrato) 
               AND b-doc-pend-aprov.ind-tip-doc                     = 12 
               AND b-doc-pend-aprov.ind-situacao                    = 2 NO-LOCK NO-ERROR.
        
        IF AVAILABLE doc-pend-aprov AND AVAILABLE b-doc-pend-aprov THEN DO: 

            /*As aprovaá‰es realizadas para mediá∆o deste contrato ser∆o eliminadas, confirma ?*/
            RUN utp/ut-msgs.p (input "show":U, input 26048, input "").

            IF RETURN-VALUE = "no":U THEN DO:
                UNDO, RETURN 'ADM-ERROR':U.    
            END.
        END.
    END.

    IF RETURN-VALUE = 'ADM-ERROR':U OR l-erro-co THEN 
        UNDO, RETURN 'ADM-ERROR':U. 

    ASSIGN l-cria-rat-med = YES.
    
    /* PONTO UPC HAZTEC */
    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "CRIA-MATRIZ-MEDICAO":U,
                                        INPUT "VIEWER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "Medicao-Contrat":U,
                                        INPUT rowid(medicao-contrat)).
        IF RETURN-VALUE = "NOK":U THEN
            ASSIGN l-cria-rat-med = NO.
    END.
    /* PONTO UPC HAZTEC */

    /* Verifica se o documento Mediá∆o est† parametrizado para aprovaá∆o no MLA */
    FIND FIRST mla-tipo-doc-aprov 
         WHERE mla-tipo-doc-aprov.ep-codigo   = estabelec.ep-codigo 
           AND mla-tipo-doc-aprov.cod-estabel = estabelec.cod-estabel 
           AND mla-tipo-doc-aprov.cod-tip-doc = 14 
           AND mla-tipo-doc-aprov.apr-tip-doc NO-LOCK NO-ERROR.

    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-apr-tip-doc = YES.
    ELSE 
        ASSIGN l-apr-tip-doc = NO.
               
    RUN lap/mlaapi099.p (INPUT 0).

    IF NOT l-integra-mla AND RETURN-VALUE <> "NOK":U THEN
        ASSIGN l-apr-tip-doc = NO.

    IF l-gera-cn0302 THEN DO:
        
        IF NOT l-pendente AND tb-liberada-aux = YES THEN
            ASSIGN medicao-contrat.ind-sit-medicao = 2.

        IF i-nr-periodos > 1 THEN DO:
            
            EMPTY TEMP-TABLE tt-entrega.
            
            ASSIGN i-num-seq = medicao-contrat.num-seq-medicao.

            RUN cnp/cn9012.p (i-frequencia-aux, medicao-contrat.dat-prev-medicao, i-nr-periodos, INPUT-OUTPUT TABLE tt-entrega).
            
            FIND FIRST tt-entrega NO-LOCK NO-ERROR.

            IF AVAIL tt-entrega THEN
               ASSIGN medicao-contrat.dat-prev-medicao = tt-entrega.dat-entrega.
            ELSE
               ASSIGN medicao-contrat.dat-prev-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).

            leitura:
            DO i-periodos = 1 TO (i-nr-periodos - 1):

                ASSIGN i-num-seq = i-num-seq + 1.

                FIND NEXT tt-entrega NO-LOCK NO-ERROR.

                IF tt-entrega.dat-entrega <= contrato-for.dt-ter-validade THEN DO:

                    CREATE b-medicao-contrat.
                    BUFFER-COPY medicao-contrat 
                        EXCEPT medicao-contrat.num-seq-medicao
                               medicao-contrat.dat-prev-medicao
                               TO b-medicao-contrat.

                    ASSIGN b-medicao-contrat.num-seq-medicao  = i-num-seq
                           b-medicao-contrat.dat-prev-medicao = tt-entrega.dat-entrega.

                    IF l-matriz-medicao THEN DO:

                        /********** TRATAMENTO ORACLE **********/
                        &IF "{&ems_dbtype}":U <> "progress":U &THEN 
                            ASSIGN r-rowid-oracle = ROWID(b-medicao-contrat).
                            RELEASE b-medicao-contrat.
                            FIND b-medicao-contrat WHERE ROWID(b-medicao-contrat) = r-rowid-oracle EXCLUSIVE-LOCK NO-ERROR.
                        &ENDIF
                        /********** TRATAMENTO ORACLE **********/

                        /* Matriz rateio Mediá∆o */
                        IF l-matriz-medicao = YES AND l-cria-rat-med   = YES THEN DO:

                            RUN cnp/cnapi014.p (INPUT ROWID(b-medicao-contrat),
                                                INPUT item-contrat.ind-tipo-control,
                                                INPUT contrato-for.ind-control-rec).

                            IF  RETURN-VALUE = "NOK":U THEN
                                UNDO,RETURN "adm-error":U.
                        END.
                    END.

                    /** Integracao Contratos - criar registro para inclusao **/
                    {cnp/cnapi020.i1 2 1 CN0302A "Geracao" medicao-contrat b-medicao-contrat}

                    /*----------------------*/
                    /* Aprovaá∆o Eletrìncia */
                    /*----------------------*/
                    FIND FIRST tt-erro NO-ERROR.
                    IF AVAIL param-aprov AND param-aprov.aprova-total-medic AND NOT AVAIL tt-erro THEN DO:

                        IF NOT l-pendente AND NOT l-apr-tip-doc AND tb-liberada-aux = YES THEN
                            ASSIGN l-atu-sld-lib = YES.
                        ELSE 
                            ASSIGN l-atu-sld-lib = NO.

                        RUN pi-atualiza-saldo (INPUT YES).

                        IF RETURN-VALUE = 'ADM-ERROR':U OR l-erro-co THEN 
                            UNDO, RETURN 'ADM-ERROR':U.

                        /* cria pendància */
                        IF l-gera-pendencia THEN DO:

                            RUN cdp/cdapi171.p (12, 2, ROWID(b-medicao-contrat)).

                            IF RETURN-VALUE = 'ADM-ERROR':U THEN
                                ASSIGN l-lib-medicao = NO.
                        END.

                        /* verifica se a mediá∆o est† pendente */
                        RUN cdp/cdapi172.p (12, ROWID(b-medicao-contrat), OUTPUT l-pendente).
                        
                        IF NOT l-pendente AND tb-liberada-aux THEN /* Mediá‰es LIberadas setado */
                            ASSIGN b-medicao-contrat.ind-sit-medicao = 2. /* liberada */
                        ELSE
                            IF l-pendente THEN DO:
                                ASSIGN b-medicao-contrat.ind-sit-medicao = 1. /* pendente */

                                {utp/ut-liter.i Mediá∆o * r}
                                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56725, INPUT RETURN-VALUE).
                            END.
                    END.
                    ELSE 
                        ASSIGN l-atu-sld-lib = YES.

                    RUN pi-atualiza-saldo (INPUT NO).
                END.
                ELSE DO:
                    ASSIGN c-num-seq = IF c-num-seq = "" THEN STRING(i-num-seq)
                                       ELSE c-num-seq + "," + STRING(i-num-seq).
                END.

                if  RETURN-VALUE = 'ADM-ERROR':U OR l-erro-co THEN
                    UNDO, RETURN 'ADM-ERROR':U.
            END.
        END.
    END.

    IF l-matriz-medicao THEN DO:

        IF adm-new-record OR i-ord-manut-ant <> medicao-contrat.nr-ord-produ THEN DO:
            
            IF i-ord-manut-ant <> medicao-contrat.nr-ord-produ THEN DO:
                FOR EACH matriz-rat-med
                   WHERE matriz-rat-med.nr-contrato     = medicao-contrat.nr-contrato
                     AND matriz-rat-med.num-seq-item    = medicao-contrat.num-seq-item
                     AND matriz-rat-med.numero-ordem    = medicao-contrat.numero-ordem
                     AND matriz-rat-med.num-seq-event   = medicao-contrat.num-seq-event
                     AND matriz-rat-med.num-seq-medicao = medicao-contrat.num-seq-medicao EXCLUSIVE-LOCK:
                    DELETE matriz-rat-med.
                END.
                
                /* Na cnapi014 sao criados os movimentos de investimentos para a nova ordem caso existir */
                IF NOT adm-new-record AND i-num-ord-inv-ant <> 0 THEN
                    RUN inp/inapi403.p (INPUT 2, /*exclus∆o*/
                                        INPUT ROWID(medicao-contrat),
                                        INPUT-OUTPUT TABLE rowerrors).
            END.

            /********** TRATAMENTO ORACLE **********/
            &IF "{&ems_dbtype}":U <> "progress":U &THEN 
                ASSIGN r-rowid-oracle = ROWID(medicao-contrat).
                RELEASE medicao-contrat.
                FIND medicao-contrat WHERE ROWID(medicao-contrat) = r-rowid-oracle EXCLUSIVE-LOCK NO-ERROR.
            &ENDIF
            /********** TRATAMENTO ORACLE **********/
            
            /* Matriz rateio Mediá∆o */
            IF l-matriz-medicao = YES AND l-cria-rat-med   = YES THEN DO:

                RUN cnp/cnapi014.p (INPUT ROWID(medicao-contrat), INPUT item-contrat.ind-tipo-control, INPUT contrato-for.ind-control-rec).

                IF RETURN-VALUE = "NOK":U THEN
                    UNDO,RETURN "adm-error":U.
            END.
        END.
    END.
    
    FOR EACH matriz-rat-med WHERE matriz-rat-med.nr-contrato     = medicao-contrat.nr-contrato
                            AND   matriz-rat-med.num-seq-item    = medicao-contrat.num-seq-item
                            AND   matriz-rat-med.numero-ordem    = medicao-contrat.numero-ordem
                            AND   matriz-rat-med.num-seq-event   = medicao-contrat.num-seq-event
                            AND   matriz-rat-med.num-seq-medicao = medicao-contrat.num-seq-medicao
                            NO-LOCK:
        RUN pi_valida_conta_contabil IN h_api_cta_ctbl(INPUT  i-empresa,                                         /* EMPRESA EMS2 */
                                                       INPUT  c-cod-estabel,                                     /* ESTABELECIMENTO EMS2 */
                                                       INPUT  matriz-rat-med.cod-unid-negoc,                     /* UNIDADE NEGOCIO */
                                                       INPUT  "",                                                /* PLANO CONTAS */ 
                                                       INPUT  matriz-rat-med.ct-codigo,                          /* CONTA */
                                                       INPUT  "",                                                /* PLANO CCUSTO */ 
                                                       INPUT  matriz-rat-med.sc-codigo,                          /* CCUSTO */
                                                       INPUT  TODAY,                                             /* DATA TRANSACAO */
                                                       OUTPUT TABLE tt_log_erro).
        IF CAN-FIND(FIRST tt_log_erro) THEN DO:
            ASSIGN vl-erro-ct-contabil = YES.
            RUN pi-msg-erro.
        END.
    END.
    
    IF vl-erro-ct-contabil THEN DO:
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            UNDO, RETURN "ADM-ERROR":U.
        END.
    END.

    IF c-num-seq <> "" THEN DO:
        
        DO i-cont = 1 TO NUM-ENTRIES(c-num-seq):
            
            RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 25924, INPUT ENTRY(i-cont,c-num-seq)).

            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro = 25924
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
       END.

       FIND FIRST tt-erro NO-ERROR.
       IF AVAIL tt-erro THEN DO:
           
           RUN cdp/cd0666.w (INPUT TABLE tt-erro).
           EMPTY TEMP-TABLE tt-erro.
       END.
    END.

    IF l-erro-co THEN
        UNDO, RETURN "adm-error":U.

    /* tratamento modificacao */ 
    IF NOT adm-new-record THEN DO:

        /********** TRATAMENTO ORACLE **********/
        &IF "{&ems_dbtype}":U <> "progress":U &THEN 
            ASSIGN r-rowid-oracle = ROWID(medicao-contrat).
            RELEASE medicao-contrat.
            FIND medicao-contrat WHERE ROWID(medicao-contrat) = r-rowid-oracle EXCLUSIVE-LOCK NO-ERROR.
        &ENDIF
        /********** TRATAMENTO ORACLE **********/

        IF i-num-ord-inv-ant <> 0 AND medicao-contrat.num-ord-inv = 0 THEN DO:
            RUN inp/inapi403.p (INPUT 2, /*exclus∆o*/
                                INPUT ROWID(medicao-contrat),
                                INPUT-OUTPUT TABLE rowerrors).
        END.
        ELSE IF medicao-contrat.num-ord-inv <> 0 THEN DO:
            RUN inp/inapi403.p (INPUT 2, /*exclus∆o*/
                                INPUT ROWID(medicao-contrat),
                                INPUT-OUTPUT TABLE rowerrors).
            RUN inp/inapi403.p (INPUT 4, /*modificaá∆o*/
                                INPUT ROWID(medicao-contrat),
                                INPUT-OUTPUT TABLE rowerrors).
        END.

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            UNDO, RETURN "ADM-ERROR":U.
        END.
    END.

    IF adm-new-record THEN DO:
        /* Integracao Contratos - criar registro para inclus∆o */
        {cnp/cnapi020.i1 2 1 CN0302A " " medicao-contrat medicao-contrat}
    END.
    ELSE DO:
        /* Integracao Contratos - criar registro para alteraá∆o - conteudo final*/
        {cnp/cnapi020.i1 2 2 CN0302A " " medicao-contrat medicao-contrat}
    END.

    /* Integracao Contratos - executa API integraá∆o e valida erros */  
    {cnp/cnapi020.i2 ADM-ERROR yes}

    FIND FIRST param-aprov NO-LOCK NO-ERROR.
    IF AVAIL param-aprov AND param-aprov.aprova-total-medic THEN DO:
        
        IF adm-new-record THEN
            RUN pi-atualiza-saldo (INPUT YES).

        IF RETURN-VALUE = 'ADM-ERROR':U OR l-erro-co THEN
            UNDO, RETURN 'ADM-ERROR':U.

        IF l-gera-pendencia THEN DO:

            RUN cdp/cdapi171.p (12, 2, ROWID(medicao-contrat)).
            
            IF RETURN-VALUE = 'ADM-ERROR':U THEN
                ASSIGN l-lib-medicao = NO.
        END.

        RUN cdp/cdapi172.p (12, ROWID(medicao-contrat), OUTPUT l-pendente).

        IF NOT l-pendente AND NOT l-apr-tip-doc AND tb-liberada-aux THEN
            ASSIGN l-atu-sld-lib = YES.
        ELSE 
            ASSIGN l-atu-sld-lib = NO.

        IF NOT l-pendente AND tb-liberada-aux THEN /* Mediá‰es LIberadas setado */
            ASSIGN medicao-contrat.ind-sit-medicao = 2. /* liberada */
        ELSE
            IF l-pendente THEN DO:
                
                ASSIGN medicao-contrat.ind-sit-medicao = 1. /* pendente */
                
                {utp/ut-liter.i Mediá∆o * r}
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 57648, INPUT RETURN-VALUE).
        END.
    END.
    ELSE 
        ASSIGN l-atu-sld-lib = YES.

    IF adm-new-record THEN DO:

        RUN pi-atualiza-saldo (INPUT NO).

        IF RETURN-VALUE = 'ADM-ERROR':U OR l-erro-co THEN 
            UNDO, RETURN 'ADM-ERROR':U.
    END.

    /* Central de Contratos - Multiplanta */
    IF param-global.modulo-mp THEN DO:

        IF adm-new-record THEN
            RUN ccp/ccapi200.p (INPUT "medicao-contrat":U,
                                INPUT ROWID(medicao-contrat),
                                INPUT 1,
                                INPUT-OUTPUT TABLE tt-erro).
        ELSE
            RUN ccp/ccapi200.p (INPUT "medicao-contrat":U,
                                INPUT ROWID(medicao-contrat),
                                INPUT 2, 
                                INPUT-OUTPUT TABLE tt-erro).
    END.
    
    /* PONTO UPC COFCO */
    IF c-nom-prog-upc-mg97 <> "":U THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-ASSIGN-RECORD":U,
                                        INPUT "VIEWER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "Medicao-Contrat":U,
                                        INPUT ROWID(medicao-contrat)).

        IF RETURN-VALUE = "CANCELAR":U THEN
            UNDO, RETURN 'ADM-ERROR':U.
    END.
    /* PONTO UPC COFCO */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  FIND FIRST ordem-compra 
       WHERE ROWID(ordem-compra) = v-row-parent NO-LOCK NO-ERROR.

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
    IF VALID-HANDLE(h-cnapi003) THEN DO:
        DELETE PROCEDURE h-cnapi003.
        ASSIGN h-cnapi003 = ?.
    END.

    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.
    
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

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  IF param-global.modulo-mi AND AVAILABLE medicao-contrat THEN 
      ASSIGN fi-ord-manut = medicao-contrat.nr-ord-produ.
      
  IF param-global.modulo-mi THEN
      DISP fi-ord-manut WITH FRAME {&FRAME-NAME}.
  
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
    IF adm-new-record = YES THEN
    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF

    IF NOT adm-new-record THEN DO:

        IF AVAILABLE medicao-contrat THEN DO:

            ASSIGN i-ind-sit-medicao = medicao-contrat.ind-sit-medicao.
            DISPLAY i-ind-sit-medicao WITH FRAME {&FRAME-NAME}.
            ASSIGN i-num-seq-item = medicao-contrat.num-seq-item.
            DISPLAY i-num-seq-item WITH FRAME {&FRAME-NAME}.
        END.
    END.

    IF NOT l-gera-cn0302 THEN DO:

        ASSIGN fi-frequencia:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-periodos:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
               tb-liberada:SENSITIVE   IN FRAME {&FRAME-NAME} = NO.
    END.

    IF NOT adm-new-record THEN
        RUN pi-mostra-ordem.

    RUN pi-habilita-om.

    /**  MLA    **/
    RUN lap/mlaapi099.p (INPUT 0).

    IF RETURN-VALUE <> "NOK":U THEN DO:

        IF l-integra-mla THEN DO:

            FIND FIRST param-aprov NO-LOCK NO-ERROR.
    
            IF SUBSTRING(param-aprov.char-1,2,1) = "Y":U THEN DO:
                DISABLE i-ind-sit-medicao WITH FRAME {&FRAME-NAME}.
            END.
        END.
        
        RUN pi-desab-respons.
    END.

    DISABLE medicao-contrat.un WITH FRAME {&FRAME-NAME}.
    
    RETURN "OK":U.
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
    /* Dispatch standard ADM method.*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.

    APPLY 'entry':U TO fi-ord-manut IN FRAME {&FRAME-NAME}.
    
    ASSIGN i-ind-sit-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF adm-new-record THEN
        ASSIGN i-sit-anterior = 0
               l-gera-cn0302  = YES.
    ELSE DO:
        IF AVAILABLE medicao-contrat THEN
            ASSIGN i-sit-anterior = medicao-contrat.ind-sit-medicao.
    END.
    
    IF param-global.modulo-mi THEN
       ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    ELSE
       ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = NO.
    
    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "spp-portal-paradigma":U
           AND funcao.ativo NO-ERROR.
    
    IF AVAIL funcao THEN DO:
    
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.
    
        IF &if "{&bf_mat_versao_ems}" < "2.09" &then
               SUBSTRING(param-compra.char-2,103,1) = "S":U
           &ELSE
               param-compra.log-portal-paradigma
           &ENDIF
        THEN DO:
            ASSIGN l-integra-paradigma = YES.
        END.
    END.

    IF NOT VALID-HANDLE(h-cnapi003) THEN DO:
        /* A passagem de parÉmetros neste ponto Ç apenas para poder executar persistente, 
           eles n∆o s∆o considerados */
        RUN cnp/cnapi003.p PERSISTENT SET h-cnapi003 (INPUT ?,
                                                      INPUT 0,
                                                      INPUT 0,
                                                      INPUT 0,
                                                      INPUT 0,
                                                      INPUT 0,
                                                      INPUT 0,
                                                      INPUT "":U,
                                                      OUTPUT l-msg-tela,
                                                      OUTPUT l-erro-co,
                                                      INPUT-OUTPUT TABLE tt-erro).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign V-table-Win 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tb-liberada = tb-liberada-aux.

    DISP  i-seq-aux-med      @ medicao-contrat.num-seq-medicao 
          i-seq-aux-eve      @ medicao-contrat.num-seq-event 
          INT(c-nr-contrato-aux)  @ i-nr-contrato 
          i-numero-ordem-aux @ i-numero-ordem 
          i-num-seq-item-aux @ i-num-seq-item 
          i-nr-periodos      @ fi-periodos 
          i-frequencia-aux   @ fi-frequencia WITH FRAME {&FRAME-NAME}.

    ASSIGN i-ind-sit-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-ind-sit-aux).
    
    ASSIGN medicao-contrat.num-seq-medicao   = i-seq-aux-med
           medicao-contrat.num-seq-event     = i-seq-aux-eve
           medicao-contrat.nr-contrato       = c-nr-contrato-aux
           medicao-contrat.num-seq-item      = i-num-seq-item-aux
           medicao-contrat.numero-ordem      = i-numero-ordem-aux
           medicao-contrat.ind-sit-medicao   = i-ind-sit-aux
           medicao-contrat.dat-medicao       = TODAY
           medicao-contrat.hra-medicao       = STRING(TIME, "HH:MM:SS":U)
           medicao-contrat.perc-lib-prev     = medicao-contrat.perc-medicao
           medicao-contrat.qtd-medicao       = medicao-contrat.qtd-prevista
           medicao-contrat.val-medicao       = medicao-contrat.val-previsto
           medicao-contrat.sld-rec-medicao   = 0
           medicao-contrat.sld-val-medicao   = medicao-contrat.val-previsto.    

    IF  (NOT item-contrat.log-control-event OR (available evento-ped and evento-ped.log-liber-autom))
    AND (l-gera-cn0302 OR (i-sit-anterior = 0 and not adm-new-record) OR i-sit-anterior = 0) THEN DO:
        
        IF  AVAIL item-contrat
        AND item-contrat.ind-un-contrato = 1 /* Valor */ 
        AND (medicao-contrat.val-previsto > 0 
        OR   medicao-contrat.qtd-prevista > 0) THEN
            RUN pi-arredondamento(INPUT medicao-contrat.qtd-prevista * INTEGER(NOT AVAIL evento-ped),
                                  INPUT medicao-contrat.val-previsto * INTEGER(NOT AVAIL evento-ped)).

        ASSIGN medicao-contrat.qtd-prevista    = IF l-arredonda-qtde THEN v-qtd-prevista  ELSE medicao-contrat.qtd-prevista
               medicao-contrat.perc-medicao    = IF l-arredonda-qtde THEN v-perc-previsto ELSE medicao-contrat.perc-medicao
               medicao-contrat.qtd-medicao     = medicao-contrat.qtd-prevista
               medicao-contrat.perc-lib-prev   = medicao-contrat.perc-medicao
               medicao-contrat.val-previsto    = IF l-arredonda-val THEN v-val-previsto ELSE truncate(medicao-contrat.val-previsto,2) 
               medicao-contrat.val-medicao     = medicao-contrat.val-previsto
               medicao-contrat.sld-val-medicao = medicao-contrat.val-previsto.
    END.

    IF AVAIL item-contrat AND item-contrat.ind-tipo-control = 1 AND param-global.modulo-mi THEN
        IF medicao-contrat.nr-ord-produ <> i-ord-manut THEN /*Grava a OM anterior, antes de efetivar a alteraªío no banco*/
            ASSIGN i-ord-manut-ant              = medicao-contrat.nr-ord-produ
                   medicao-contrat.nr-ord-produ = i-ord-manut.
    
    ASSIGN i-num-ord-inv-ant           = medicao-contrat.num-ord-inv
           medicao-contrat.num-ord-inv = i-num-ord-inv.
    
    DISP i-ord-manut @ fi-ord-manut WITH FRAME {&FRAME-NAME}.
    
    RUN lap/mlaapi099.p (INPUT 0).

    IF l-integra-mla AND RETURN-VALUE <> "NOK":U AND l-gera-pendencia THEN DO:

        RUN lap/mlaapi173.p (INPUT 12,  
                             INPUT INPUT FRAME {&FRAME-NAME} c-it-codigo,
                             INPUT medicao-contrat.responsavel,
                             INPUT contrato-for.cod-emitente,
                             INPUT contrato-for.cod-emitente,
                             INPUT "",
                             INPUT medicao-contrat.val-previsto,
                             INPUT medicao-contrat.val-previsto,
                             INPUT c-cod-estabel, 
                             OUTPUT TABLE tt-erro-aed).

        IF RETURN-VALUE = "NOK":U THEN DO:

            FIND FIRST tt-erro-aed NO-ERROR.
            IF AVAIL tt-erro-aed THEN DO:

                RUN cdp/cd0669.w (INPUT TABLE tt-erro-aed).
                RETURN 'ADM-ERROR':U.  
            END.
        END.
    END.

    RETURN "OK":U.
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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.

    ASSIGN v-row-parent = v-row-parent-externo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo V-table-Win 
PROCEDURE pi-atualiza-saldo :
/*------------------------------------------------------------------------------
  Purpose: Valida e atualiza saldo do contrato    
  Parameters: l-somente-valida (INPUT - Logical): Indica que deve fazer apenas a validaá∆o e 
                                                  n∆o atualizar o saldo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER l-somente-valida AS LOGICAL NO-UNDO.

    ASSIGN de-qtd-realizada = de-qtd-realizada - medicao-contrat.qtd-prevista
           de-val-realizado = de-val-realizado - medicao-contrat.val-previsto.           

    IF NOT item-contrat.log-control-event OR (AVAILABLE evento-ped AND evento-ped.log-liber-autom) THEN DO:
        
        IF l-gera-cn0302 THEN DO:

            ASSIGN l-erro-co = NO.

            IF tb-liberada THEN DO:

                RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).

                RUN pi-executa IN h-cnapi003 (INPUT ROWID(item-contrat),
                                              INPUT medicao-contrat.qtd-prevista * INTEGER(NOT AVAILABLE evento-ped),
                                              INPUT medicao-contrat.val-previsto * INTEGER(NOT AVAILABLE evento-ped),
                                              INPUT medicao-contrat.qtd-prevista * INTEGER(l-atu-sld-lib = YES),
                                              INPUT medicao-contrat.val-previsto * INTEGER(l-atu-sld-lib = YES),
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT c-cod-estabel, 
                                              OUTPUT l-msg-tela,
                                              OUTPUT l-erro-co,
                                              INPUT-OUTPUT TABLE tt-erro).                                

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF AVAIL tt-erro THEN 
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                IF l-erro-co THEN DO:
                    UNDO,RETURN 'ADM-ERROR':U.
                END.
            END.
            ELSE DO:

                RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).
                RUN pi-executa IN h-cnapi003 (INPUT ROWID(item-contrat),
                                              INPUT medicao-contrat.qtd-prevista * INTEGER(NOT AVAILABLE evento-ped),
                                              INPUT medicao-contrat.val-previsto * INTEGER(NOT AVAILABLE evento-ped),
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT c-cod-estabel,
                                              OUTPUT l-msg-tela,
                                              OUTPUT l-erro-co,
                                              INPUT-OUTPUT TABLE tt-erro).

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF AVAIL tt-erro THEN
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                IF l-erro-co THEN DO:
                    UNDO,RETURN 'ADM-ERROR':U.
                END.
            END.
            IF l-erro-co THEN
                UNDO, RETURN "adm-error":U.
        END.
        ELSE DO:

            IF i-sit-anterior <> 0 THEN DO:

                IF i-sit-anterior <> 0 AND i-sit-anterior <> medicao-contrat.ind-sit-medicao 
                OR (AVAILABLE evento-ped) THEN DO:
                    
                    ASSIGN l-erro-co = NO.

                    IF medicao-contrat.ind-sit-medicao = 1 THEN DO:

                        RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).

                        RUN pi-executa IN h-cnapi003(INPUT ROWID(item-contrat),
                                                     INPUT 0,
                                                     INPUT 0,
                                                     INPUT (medicao-contrat.qtd-prevista * (-1)),
                                                     INPUT (medicao-contrat.val-previsto  * (-1)),
                                                     INPUT 0,
                                                     INPUT 0,
                                                     INPUT c-cod-estabel,
                                                     OUTPUT l-msg-tela,
                                                     OUTPUT l-erro-co,
                                                     INPUT-OUTPUT TABLE tt-erro).                                        

                        FIND FIRST tt-erro NO-LOCK NO-ERROR. 
                        IF AVAIL tt-erro THEN
                            RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                        IF l-erro-co THEN DO:
                           UNDO,RETURN 'ADM-ERROR':U.
                        END.
                    END.
                    ELSE
                        IF medicao-contrat.ind-sit-medicao = 2 THEN DO:
                            
                            RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).

                            RUN pi-executa IN h-cnapi003 (INPUT ROWID(item-contrat),
                                                          INPUT 0,
                                                          INPUT 0,
                                                          INPUT medicao-contrat.qtd-prevista,
                                                          INPUT medicao-contrat.val-previsto,
                                                          INPUT 0,
                                                          INPUT 0,
                                                          INPUT c-cod-estabel,
                                                          OUTPUT l-msg-tela, 
                                                          OUTPUT l-erro-co,
                                                          INPUT-OUTPUT TABLE tt-erro).                                       
                                                         
                        FIND FIRST tt-erro NO-LOCK NO-ERROR.
                        IF AVAIL tt-erro THEN
                            RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                        IF l-erro-co THEN DO:
                            UNDO,RETURN 'ADM-ERROR':U.
                        END.
                    END.
                    IF l-erro-co THEN
                        UNDO, RETURN "adm-error":U.
                END.
            END.

            ASSIGN l-erro-co = NO.

            IF i-sit-anterior = 0 AND NOT adm-new-record THEN DO:

               RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).

               RUN pi-executa IN h-cnapi003 (INPUT ROWID(item-contrat),
                                             INPUT medicao-contrat.qtd-prevista * INTEGER(NOT AVAILABLE evento-ped),
                                             INPUT medicao-contrat.val-previsto * INTEGER(NOT AVAILABLE evento-ped),
                                             INPUT medicao-contrat.qtd-prevista * INTEGER(medicao-contrat.ind-sit-medicao = 2),
                                             INPUT medicao-contrat.val-previsto * INTEGER(medicao-contrat.ind-sit-medicao = 2),
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT c-cod-estabel,
                                             OUTPUT l-msg-tela, 
                                             OUTPUT l-erro-co,
                                             INPUT-OUTPUT TABLE tt-erro).                                

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF AVAIL tt-erro THEN
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

            END.

            IF l-erro-co THEN DO:
                UNDO,RETURN 'ADM-ERROR':U.
            END.
        END.

        ASSIGN l-erro-co = NO.

        IF i-sit-anterior = 0 THEN DO:
            
            RUN pi-somente-valida-saldo IN h-cnapi003 (INPUT l-somente-valida).
            
            RUN pi-executa IN h-cnapi003 (INPUT ROWID(item-contrat),
                                          INPUT medicao-contrat.qtd-prevista * INTEGER(NOT AVAIL evento-ped),
                                          INPUT medicao-contrat.val-previsto * INTEGER(NOT AVAIL evento-ped),
                                          INPUT medicao-contrat.qtd-prevista * INTEGER(medicao-contrat.ind-sit-medicao = 2) * INTEGER(l-atu-sld-lib = YES),
                                          INPUT medicao-contrat.val-previsto * INTEGER(medicao-contrat.ind-sit-medicao = 2) * INTEGER(l-atu-sld-lib = YES),
                                          INPUT IF l-somente-valida THEN medicao-contrat.qtd-prevista ELSE 0,
                                          INPUT 0,
                                          INPUT c-cod-estabel,
                                          OUTPUT l-msg-tela,
                                          OUTPUT l-erro-co,
                                          INPUT-OUTPUT TABLE tt-erro).                              

              FIND FIRST tt-erro NO-LOCK NO-ERROR. 
              IF AVAIL tt-erro THEN
                  RUN cdp/cd0666.w (INPUT TABLE tt-erro).

           IF l-erro-co THEN
               UNDO, RETURN "adm-error":U.
        END.
    END.
    ELSE DO:
        
        IF NOT l-somente-valida THEN DO:

            IF AVAILABLE evento-ped AND evento-ped.log-liber-autom = NO THEN DO:
                
                IF NOT l-pendente THEN DO:
                    ASSIGN medicao-contrat.ind-sit-medicao = 2
                           i-ind-sit-medicao               = 2.

                    DISPLAY i-ind-sit-medicao WITH FRAME {&FRAME-NAME}.
                END.
            END.

            IF AVAILABLE evento-ped THEN DO:

                IF NOT evento-ped.log-liber-autom THEN
                    ASSIGN medicao-contrat.dat-prev-medicao = evento-ped.dat-prev-entr.

                DISPLAY medicao-contrat.dat-prev-medicao WITH FRAME {&FRAME-NAME}.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-quantidade V-table-Win 
PROCEDURE pi-calcula-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST evento-ped 
         WHERE evento-ped.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato  
           AND evento-ped.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item 
           AND evento-ped.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem 
           AND evento-ped.seq-evento    = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE evento-ped THEN 
        ASSIGN de-qtd-total = evento-ped.qtd-prevista
               de-val-total = evento-ped.val-previsto.
    ELSE DO:

        IF item-contrat.qtd-total <> 0 THEN
            ASSIGN de-qtd-total = item-contrat.qtd-total.
        ELSE
            ASSIGN de-qtd-total = contrato-for.dec-1.

        IF item-contrat.val-total <> 0 THEN
            ASSIGN de-val-total = item-contrat.val-total.
        ELSE
            ASSIGN de-val-total = contrato-for.dec-2.
    END.

    ASSIGN de-sld-qtd = 0
           de-sld-val = 0.

    FOR EACH b-medicao-contrat 
       WHERE b-medicao-contrat.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato  
         AND b-medicao-contrat.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item 
         AND b-medicao-contrat.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem 
         AND b-medicao-contrat.num-seq-event = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event NO-LOCK:

        IF NOT adm-new-record AND b-medicao-contrat.num-seq-medicao = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-medicao THEN
            NEXT.

        ASSIGN de-sld-qtd = de-sld-qtd + b-medicao-contrat.qtd-prevista.

        FIND FIRST b-item-contrat 
             WHERE b-item-contrat.nr-contrato  = b-medicao-contrat.nr-contrato 
               AND b-item-contrat.num-seq-item = b-medicao-contrat.num-seq-item NO-LOCK NO-ERROR.

        ASSIGN de-sld-val = de-sld-val + b-medicao-contrat.val-medicao.
    END.

    ASSIGN i-num-periodos = 1.

    IF adm-new-record THEN DO:

        FIND LAST b-medicao-contrat USE-INDEX medicao 
            WHERE b-medicao-contrat.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato  
              AND b-medicao-contrat.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item 
              AND b-medicao-contrat.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem 
              AND b-medicao-contrat.num-seq-event = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event NO-LOCK NO-ERROR.

        IF AVAILABLE b-medicao-contrat THEN DO:
            IF b-medicao-contrat.num-seq-medicao < 999999 THEN
                ASSIGN medicao-contrat.num-seq-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING((b-medicao-contrat.num-seq-medicao + 1)).
            ELSE
                ASSIGN medicao-contrat.num-seq-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
        END.
        ELSE DO:  

            ASSIGN medicao-contrat.num-seq-medicao:screen-value in frame {&frame-name} = "1":U.
            
            IF param-global.modulo-bh THEN
                FOR LAST his-medicao-contrat FIELDS(num-seq-medicao) USE-INDEX medicao 
                   WHERE his-medicao-contrat.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato  
                     AND his-medicao-contrat.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item 
                     AND his-medicao-contrat.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem 
                     AND his-medicao-contrat.num-seq-event = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event NO-LOCK:

                    ASSIGN medicao-contrat.num-seq-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(his-medicao-contrat.num-seq-medicao + 1).
                END.
        END.
    END.

    ASSIGN de-variacao-qtd = IF contrato-for.variacao-qtd > 0 THEN de-qtd-total + (de-qtd-total * contrato-for.variacao-qtd / 100)
                             ELSE 0.

    ASSIGN de-variacao-val = IF contrato-for.variacao-preco > 0 THEN de-val-total + (de-val-total * contrato-for.variacao-preco / 100)
                             ELSE 0.

    RUN pi-habilita-quantidade.                                                          

    IF NOT AVAILABLE evento-ped OR (AVAILABLE evento-ped AND evento-ped.log-liber-autom) THEN DO:

        IF l-gera-cn0302 THEN
            ASSIGN tb-liberada:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

        ASSIGN medicao-contrat.dat-prev-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    ELSE DO:

        ASSIGN tb-liberada:SENSITIVE IN FRAME {&FRAME-NAME}                      = NO
               medicao-contrat.dat-prev-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

        IF NOT evento-ped.log-liber-autom THEN
            ASSIGN medicao-contrat.dat-prev-medicao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(evento-ped.dat-prev-entr).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desab-respons V-table-Win 
PROCEDURE pi-desab-respons :
/*------------------------------------------------------------------------------
  Purpose: Se o parametro "Permite Alterar ResponsavÇl" n∆o estiver marcado 
           no CD1800, o mesmo n∆o permitir† informar o responsavel na 
           inclus∆o de uma mediá∆o. Isso se a funá∆o MLA estiver ativa.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST perm-usuar
                WHERE perm-usuar.cod-usuar             = c-seg-usuario
                  AND perm-usuar.tipo-docum            = 3 /* Mediá∆o */
                  AND SUBSTRING(perm-usuar.char-1,1,1) = "N":U ) THEN DO:

        DISABLE medicao-contrat.responsavel WITH FRAME {&frame-name}.

        IF adm-new-record THEN
            ASSIGN medicao-contrat.responsavel:SCREEN-VALUE IN FRAME {&frame-name} = c-seg-usuario.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-om V-table-Win 
PROCEDURE pi-habilita-om :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  INPUT FRAME {&FRAME-NAME} i-nr-contrato = 0 THEN DO:

        IF NOT AVAIL ordem-compra THEN
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ROWID(ordem-compra) = v-row-parent NO-ERROR.

        FIND FIRST item-contrat NO-LOCK 
             WHERE item-contrat.nr-contrat   = ordem-compra.nr-contrato
               AND item-contrat.num-seq-item = ordem-compra.num-seq-item NO-ERROR.
    END.
    ELSE
        FIND FIRST item-contrat NO-LOCK 
             WHERE item-contrat.nr-contrat   = INPUT FRAME {&FRAME-NAME} i-nr-contrato
               AND item-contrat.num-seq-item = INPUT FRAME {&FRAME-NAME} i-num-seq-item NO-ERROR.

    IF AVAIL item-contrat AND item-contrat.ind-tipo-control = 1 AND param-global.modulo-mi THEN
        ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME}    = NO
               fi-ord-manut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-quantidade V-table-Win 
PROCEDURE pi-habilita-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE item-contrat.ind-tipo-control-val:

        WHEN 1 THEN DO:
            IF item-contrat.ind-un-contrato = 1 THEN
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END.
        WHEN 2 THEN DO:

            IF item-contrat.ind-un-contrato = 1 THEN
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END.
        WHEN 3 THEN DO:

            IF item-contrat.ind-un-contrato = 1 THEN
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            ELSE
                ASSIGN medicao-contrat.qtd-prevista:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       medicao-contrat.perc-medicao:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       medicao-contrat.val-previsto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-item-contrat V-table-Win 
PROCEDURE pi-mostra-item-contrat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT adm-new-record THEN DO:

        IF AVAILABLE medicao-contrat THEN DO:

            ASSIGN i-ind-sit-medicao = medicao-contrat.ind-sit-medicao.
            DISPLAY i-ind-sit-medicao WITH FRAME {&FRAME-NAME}.
            ASSIGN i-num-seq-item = medicao-contrat.num-seq-item.
            DISPLAY i-num-seq-item WITH FRAME {&FRAME-NAME}.
        END.
    END.

    IF AVAILABLE ordem-compra THEN DO:

        FIND FIRST item-contrat 
             WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato 
               AND item-contrat.num-seq-item = INPUT FRAME {&FRAME-NAME} i-num-seq-item NO-LOCK NO-ERROR.

        ASSIGN c-narrat-compra:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE item-contrat THEN item-contrat.narrat-compra ELSE "":U.

        IF item-contrat.log-control-event AND adm-new-record THEN 
            ASSIGN medicao-contrat.num-seq-event:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

        ASSIGN medicao-contrat.un:SCREEN-VALUE IN FRAME {&FRAME-NAME} = item-contrat.un.
    END.

    IF medicao-contrat.num-seq-event:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        RUN pi-calcula-quantidade.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-om V-table-Win 
PROCEDURE pi-mostra-om :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER b-evento-ped FOR evento-ped.
    
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FIND FIRST b-evento-ped
         WHERE b-evento-ped.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato
           and b-evento-ped.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item
           and b-evento-ped.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem
           and b-evento-ped.seq-evento    = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event NO-LOCK NO-ERROR.
    
    IF AVAIL b-evento-ped AND  param-global.modulo-mi THEN DO:

       ASSIGN fi-ord-manut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(b-evento-ped.nr-ord-produ).
       APPLY "LEAVE":U TO fi-ord-manut IN FRAME {&FRAME-NAME}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-ordem V-table-Win 
PROCEDURE pi-mostra-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST ordem-compra 
         WHERE ROWID(ordem-compra) = v-row-parent NO-LOCK NO-ERROR.

    IF AVAILABLE ordem-compra THEN DO:

        DISPLAY INT(ordem-compra.nr-contrato) @ i-nr-contrato WITH FRAME {&FRAME-NAME}.

        ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
        ASSIGN i-nr-contrato:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = STRING(ordem-compra.nr-contrato)
               c-cod-estabelec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ordem-compra.cod-estabel
               i-numero-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(ordem-compra.numero-ordem)
               i-num-seq-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(ordem-compra.num-seq-item)
               c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = ordem-compra.it-codigo.
         
        FIND FIRST contrato-for 
             WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK NO-ERROR.

        ASSIGN c-desc-contrat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE contrato-for THEN contrato-for.des-contrat ELSE "":U.

        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN c-desc-estabelec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

        IF contrato-for.ind-control-rec = 1 AND adm-new-record THEN DO:

            ASSIGN i-num-seq-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            RETURN "adm-error":U.
        END.
        ELSE
            RUN pi-mostra-item-contrat.
    END.

    IF medicao-contrat.num-seq-event:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        RUN pi-calcula-quantidade.  

    /* PONTO UPC MITSUI */
    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-LOADING-FIELDS":U,
                                        INPUT "VIEWER":U,
                                        INPUT THIS-PROCEDURE,    
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "Medicao-Contrat":U,  
                                        INPUT ROWID(medicao-contrat)).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-val-inclusao-medicao V-table-Win 
PROCEDURE pi-val-inclusao-medicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-inc        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE de-qtd-total AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-val-total AS DECIMAL    NO-UNDO.

    FIND FIRST evento-ped 
         WHERE evento-ped.nr-contrat    = ordem-compra.nr-contrato  
           AND evento-ped.num-seq-item  = ordem-compra.num-seq-item 
           AND evento-ped.numero-ordem  = ordem-compra.numero-ordem NO-LOCK NO-ERROR.

    IF AVAILABLE evento-ped THEN
        ASSIGN de-qtd-total = evento-ped.qtd-prevista
               de-val-total = evento-ped.val-previsto.
    ELSE DO:
        IF item-contrat.qtd-total <> 0 THEN
            assign de-qtd-total = item-contrat.qtd-total.
        IF item-contrat.val-total <> 0 THEN
            ASSIGN de-val-total = item-contrat.val-total.
    END.

    /*** ValidaáÑes ***/

    ASSIGN l-inc = YES.

    /**  Nao existe quantidade base para informar medicao em percentual **/
    IF  item-contrat.ind-tipo-control-val <> 3
    AND de-qtd-total = 0 
    AND item-contrat.ind-un-contrat = 2 THEN DO:

       RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8736, INPUT "").
       ASSIGN l-inc = NO.
    END.

    /**  Nao existe valor base para informar medicao em percentual **/
    IF  item-contrat.ind-tipo-control-val = 3
    AND de-val-total = 0 
    AND item-contrat.ind-un-contrat = 2 THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8737, INPUT "").
        ASSIGN l-inc = NO.
    END.

    IF NOT l-inc THEN DO:
        APPLY 'ENTRY':U TO i-num-seq-item IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validacoes V-table-Win 
PROCEDURE pi-validacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE da-data           AS DATE                              NO-UNDO.
    DEFINE VARIABLE de-qtde-prev      AS DECIMAL                           NO-UNDO.
    DEFINE VARIABLE de-val-prev       AS DECIMAL                           NO-UNDO.
    
    IF NOT AVAIL item-contrat THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17679, INPUT "").
        RETURN "adm-error":U.
    END.
    ELSE DO:   
    
        FIND FIRST item
             WHERE item.it-codigo = item-contrat.it-codigo NO-LOCK NO-ERROR.
        
        IF AVAIL item AND item.cod-obsoleto = 4 THEN DO:
            
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 563, INPUT item-contrat.it-codigo).
            RETURN "adm-error":U.
        END.
    
        FIND FIRST contrato-for WHERE contrato-for.nr-contrato = item-contrat.nr-contrato NO-LOCK NO-ERROR.
    
        IF  AVAIL contrato-for AND
        (   contrato-for.ind-sit-contrat <> 2 OR item-contrat.ind-sit-item <> 2
         OR INPUT FRAME {&FRAME-NAME} medicao-contrat.dat-prev-medicao < contrato-for.dt-ini-validade
         OR INPUT FRAME {&FRAME-NAME} medicao-contrat.dat-prev-medicao > contrato-for.dt-ter-validade ) THEN DO:
            
            ASSIGN da-data = contrato-for.dt-ini-validade.
            
            IF contrato-for.dt-ter-validade < TODAY THEN 
                ASSIGN da-data = ?.
    
            
            IF da-data = ? OR contrato-for.ind-sit-contrat <> 2 OR item-contrat.ind-sit-item <> 2 THEN
                RUN utp/ut-msgs.p ("show":U, 15208, "").
            ELSE 
                RUN utp/ut-msgs.p ("show":U, 314, STRING(da-data,'99/99/9999':U) + "~~":U + STRING(contrato-for.dt-ter-validade,'99/99/9999':U)).
            
            APPLY 'entry':U TO medicao-contrat.dat-prev-medicao IN FRAME {&FRAME-NAME}.
            RETURN "adm-error":U.
        END.
    
        IF item-contrat.ind-tipo-control = 3 THEN DO:
            /** Sequencia de Evento nao Cadastrada. **/
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17679, INPUT "").
            RETURN "adm-error":U.
        END.
    
        IF l-gera-cn0302 THEN DO:
            
            IF NOT AVAIL frequencia THEN DO:

                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6070, INPUT "").
    
                APPLY "entry":U TO fi-frequencia IN FRAME {&FRAME-NAME}.
                RETURN "adm-error":U.
            END.
    
            IF frequencia.tp-freq = 1 THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 19666, INPUT "").
                RETURN "adm-error":U.
            END.
        END.
    
        FIND FIRST usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = INPUT FRAME {&FRAME-NAME} medicao-contrat.responsavel NO-ERROR.

        IF NOT AVAIL usuar-mater THEN DO:

            {utp/ut-liter.i Usu†rio_Respons†vel * r}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56, INPUT STRING(RETURN-VALUE + "~~":U + "CD1700":U)).
            RETURN "adm-error":U.
        END.
    
        IF item-contrat.log-control-event THEN DO:
    
           FIND FIRST evento-ped 
                WHERE evento-ped.nr-contrato   = INPUT FRAME {&FRAME-NAME} i-nr-contrato  
                  AND evento-ped.num-seq-item  = INPUT FRAME {&FRAME-NAME} i-num-seq-item 
                  AND evento-ped.numero-ordem  = INPUT FRAME {&FRAME-NAME} i-numero-ordem 
                  AND evento-ped.seq-evento    = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event NO-LOCK NO-ERROR.
    
           IF NOT AVAILABLE evento-ped THEN DO:
              /** Sequencia de Evento nao Cadastrada. **/
              RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8731, INPUT "").
              APPLY 'entry':U TO medicao-contrat.num-seq-event.
              RETURN "adm-error":U.
           END.
    
           IF evento-ped.ind-sit-event <> 1 THEN DO:
              /** Evento ja Realizado ou Cancelado. **/
              RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8732, INPUT "").
              APPLY 'entry':U TO medicao-contrat.num-seq-event.
              RETURN "adm-error":U.
           END.
        END.
    
        IF item-contrat.ind-tipo-control-val < 3 THEN DO:
            
            ASSIGN de-sld-qtd = de-sld-qtd + INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista.
    
            IF de-variacao-qtd > 0 THEN DO:
                IF NOT item-contrat.log-control-event THEN DO:
                    
                    /** Quantidade ultrapassa saldo disponÌvel. **/
                    IF de-sld-qtd > de-variacao-qtd THEN DO:
                        ASSIGN de-sld-qtd = de-sld-qtd - INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista.
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8403, INPUT "").
                        APPLY 'entry' to medicao-contrat.qtd-prevista.
                        RETURN "adm-error".
                    END.
                END.
                ELSE DO:
                    /**Quantidade ultrapassa saldo disponÌvel no evento. **/
                    IF de-sld-qtd > de-variacao-qtd THEN DO:
                        
                        ASSIGN de-sld-qtd = de-sld-qtd - INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista.
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 16789, INPUT "").
                        APPLY 'entry':U TO medicao-contrat.qtd-prevista.
                        RETURN "adm-error":U.
                    END.
                END.
            END.
            ELSE
                IF de-variacao-qtd = 0 AND item-contrat.log-control-event THEN DO:
                    /** Quantidade ultrapassa saldo disponÌvel no evento. **/
                    IF de-qtd-total < de-sld-qtd THEN DO:
                        
                        ASSIGN de-sld-qtd = de-sld-qtd - INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista.
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 16789, INPUT "").
                        APPLY 'entry' TO medicao-contrat.qtd-prevista.
                        RETURN "adm-error":U.
                    END.
                END.
        END.
        ELSE DO:
            ASSIGN de-sld-val = de-sld-val + INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto.
    
            IF de-variacao-val > 0 THEN DO:
                
                IF NOT item-contrat.log-control-event THEN DO:

                    IF de-sld-val > de-variacao-val THEN DO:

                        ASSIGN de-sld-val = de-sld-val - INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto.
                        /** Valor ultrapassa saldo disponÌvel **/
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 8404, INPUT "").
                        APPLY 'entry':U TO medicao-contrat.val-previsto.
                        RETURN "adm-error":U.
                    END.
                END.
                ELSE DO:
                    /** Valor ultrapassa variacao permitida no evento. **/
                    IF de-sld-val > de-variacao-val then DO:

                        ASSIGN de-sld-val = de-sld-val - INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto.
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 16791, INPUT "").
                        APPLY 'entry':U TO medicao-contrat.val-previsto.
                        RETURN "adm-error":U.
                    END.
                END.
            END.
            ELSE
                IF de-variacao-val = 0 AND item-contrat.log-control-event THEN DO:
                    /** Valor ultrapassa saldo disponÌvel no evento. **/
                    IF de-val-total < de-sld-val THEN DO:
    
                        ASSIGN de-sld-val = de-sld-val - INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto.
                        
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 16790, INPUT "").
                        APPLY 'entry':U TO medicao-contrat.val-previsto.
                        RETURN "adm-error":U.
                    END.
                END.
        END.
    
        ASSIGN de-qtde-prev = INPUT FRAME {&FRAME-NAME} medicao-contrat.qtd-prevista.
        ASSIGN de-val-prev  = INPUT FRAME {&FRAME-NAME} medicao-contrat.val-previsto.
     
        IF de-qtde-prev <= 0 THEN DO:
            
            {utp/ut-liter.i Quantidade_prevista * r} 
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 4700, INPUT RETURN-VALUE).
            APPLY 'entry':U TO medicao-contrat.qtd-prevista.
            RETURN "adm-error":U.
        END.
    
        IF de-val-prev <= 0 THEN DO:
            
            {utp/ut-liter.i Valor_previsto * r}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 4700, INPUT RETURN-VALUE).
            APPLY 'entry' TO medicao-contrat.val-previsto.
            RETURN "adm-error":U.
        END.
        
        /********************************MATRIZ UNIDADE NEG‡CIO*******************************/
        IF param-global.modulo-mi AND INPUT FRAME {&FRAME-NAME} fi-ord-manut <> 0 THEN DO:
            FIND FIRST ord-prod 
                 WHERE ord-prod.nr-ord-produ = input frame {&frame-name} fi-ord-manut no-lock no-error.
            IF NOT AVAIL ord-prod THEN DO:
               RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1879, INPUT "").
               APPLY 'entry':U TO fi-ord-manut.
               RETURN 'adm-error':U.
            END.
            ELSE
                IF ord-prod.origem = "MI":U THEN DO:
                    IF ord-prod.estado = 8 THEN DO:
                        /* Ordem de Produá∆o terminada */
                        RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1882, INPUT "").
                        APPLY 'entry' to fi-ord-manut.
                        RETURN 'adm-error'.
                    END.
                    IF CAN-FIND(FIRST unid-negoc-om /* Sera assumida matriz de UN da OM */
                                WHERE unid-negoc-om.num-ord-manut = ord-prod.nr-ord-produ) AND l-unidade-negocio THEN
                        RUN utp/ut-msgs.p(INPUT "show":U, INPUT 34511, INPUT ""). 
                END.
        END.
    
    END. /*Avail item-contrat*/
    
    ASSIGN i-ord-manut = INPUT FRAME {&FRAME-NAME} fi-ord-manut.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N„o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaÁıes, pois neste ponto do programa o registro 
  ainda n„o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* ValidaÁ„o de dicion·rio */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:    Salvar os campos chave para n„o ocorrer problema de lock
              em base Oracle/MSSQL. Essa procedure È executada no create-record
              da template.
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    
  FIND FIRST ordem-compra
       WHERE ROWID(ordem-compra) = v-row-parent NO-LOCK NO-ERROR.
       
  IF AVAIL ordem-compra THEN DO:
     ASSIGN medicao-contrat.numero-ordem = ordem-compra.numero-ordem
            medicao-contrat.nr-contrato  = ordem-compra.nr-contrato
            medicao-contrat.num-seq-item = ordem-compra.num-seq-item
            medicao-contrat.num-seq-medicao = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-medicao
            medicao-contrat.num-seq-event = INPUT FRAME {&FRAME-NAME} medicao-contrat.num-seq-event.
  END.
     
   RETURN "OK".
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
  {src/adm/template/snd-list.i "medicao-contrat"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-arredondamento V-table-Win 
PROCEDURE pi-arredondamento :
/* ---------------------------------------------------------------------------------------------
  Purpose: Realiza o arredondamento ou do valor previsto ou da quantidade prevista
  Parameters:  input p-qtd-prevista, input p-val-previsto
  Notes: Quando o tipo do controle do item por Limite Custo e a soma do valor das mediá‰es atingir o 
         Valor Limite do Item/Contrato, a quantidade ir† receber a diferenáa entre o o Limite Quantidade 
         e a quantidade total das mediá‰es j† realizadas.
         Quando o tipo do controle do item por Qtd Aberta e Preáo Fixo e a soma da quantidade das mediá‰es
         atingir a Quantidade Limite do Item/Contrato, o valor ir† receber a diferenáa entre o Valor Limite 
         e o valor total das mediá‰es j† realizadas.
-----------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-qtd-prevista LIKE medicao-contrat.qtd-prevista NO-UNDO.
    DEFINE INPUT PARAMETER p-val-previsto LIKE medicao-contrat.val-previsto NO-UNDO.

    DEFINE VARIABLE de-saldo-val   LIKE item-contrat.sld-val   NO-UNDO.
    DEFINE VARIABLE de-saldo-qtd   LIKE item-contrat.sld-qtd   NO-UNDO.
    DEFINE VARIABLE de-val-total   LIKE item-contrat.val-total NO-UNDO.
    DEFINE VARIABLE de-qtd-total   LIKE item-contrat.qtd-total NO-UNDO.

    IF item-contrat.val-total > 0 THEN
        ASSIGN de-val-total = item-contrat.val-total
               de-saldo-val = item-contrat.sld-val.
    ELSE DO:

        ASSIGN de-val-total = contrato-for.dec-2. /* Valor Limite */

        FOR EACH b-item-contrat FIELDS (nr-contrato ind-caract-item sld-val)
           WHERE b-item-contrat.nr-contrato     = contrato-for.nr-contrato 
             AND b-item-contrat.ind-caract-item = 1   NO-LOCK: /* considera apenas itens aditivos para calculo do saldo do contrato */

            ASSIGN de-saldo-val = de-saldo-val + b-item-contrat.sld-val.
        END.
    END.

    IF item-contrat.qtd-total > 0 THEN
        ASSIGN de-qtd-total = item-contrat.qtd-total
               de-saldo-qtd = item-contrat.sld-qtd.
    ELSE DO:

        ASSIGN de-qtd-total = contrato-for.dec-1. /* Quantidade Limite */

        FOR EACH b-item-contrat FIELD (nr-contrato sld-qtd)
           WHERE b-item-contrat.nr-contrato     = contrato-for.nr-contrato 
             AND b-item-contrat.ind-caract-item = 1  NO-LOCK: /* considera apenas itens aditivos para calculo do saldo do contrato */

            ASSIGN de-saldo-qtd = de-saldo-qtd + b-item-contrat.sld-qtd.
        END.
    END.

    IF NOT adm-new-record THEN
        ASSIGN de-saldo-qtd = de-saldo-qtd - medicao-contrat.qtd-prevista
               de-saldo-val = de-saldo-val - medicao-contrat.val-previsto.

    IF item-contrat.ind-tipo-control-val = 3 /* Limite Custo */ THEN DO:
        
        /* Verificar se a soma das mediá‰es atingiu o valor limite do Item/Contrato e se h† variaá∆o na quantidade */
        IF p-val-previsto + de-saldo-val = (de-val-total + (de-val-total * contrato-for.variacao-preco / 100)) THEN DO:

            IF p-qtd-prevista + de-saldo-qtd <> (de-qtd-total + (de-qtd-total * contrato-for.variacao-qtd / 100)) THEN DO:
                
                ASSIGN v-qtd-prevista   = IF de-qtd-total > 0 THEN de-qtd-total - de-saldo-qtd
                                          ELSE p-val-previsto / item-contrat.pre-unit-for
                       v-perc-previsto  = IF de-val-total = 0 THEN 100
                                          ELSE IF (p-val-previsto * 100 / de-val-total) <= 999 THEN p-val-previsto * 100 / de-val-total
                                               ELSE 999.99
                       l-arredonda-qtde = YES.
            END.
        END.
        ELSE DO:
            IF  de-val-total > 0 /* com limite de valor */
            AND ABSOLUTE((p-val-previsto + de-saldo-val) - (de-val-total + (de-val-total * contrato-for.variacao-preco / 100))) < 0.01 THEN DO:

                ASSIGN v-val-previsto   = de-val-total - de-saldo-val
                       v-perc-previsto  = IF (p-val-previsto * 100 / de-val-total) <= 999 THEN p-val-previsto * 100 / de-val-total
                                          ELSE 999.99
                       v-qtd-prevista   = IF de-qtd-total > 0 THEN de-qtd-total - de-saldo-qtd
                                          ELSE v-val-previsto / item-contrat.pre-unit-for
                       l-arredonda-val  = YES
                       l-arredonda-qtde = YES.
            END.
        END.
    END.

    IF item-contrat.ind-tipo-control-val = 2 /* Qtd Aberta e Preáo Fixo */ THEN DO:
        
        /* Verificar se atingiu a quantidade limite do Item/Contrado e se h† variaá∆o no valor */

        IF p-qtd-prevista + de-saldo-qtd = (de-qtd-total + (de-qtd-total * contrato-for.variacao-qtd / 100)) THEN DO:

            IF de-val-total = 0 THEN /*sem limite de valor */
                 ASSIGN v-val-previsto = de-saldo-val.
          
            IF  p-val-previsto + de-saldo-val <> (de-val-total + (de-val-total * contrato-for.variacao-preco / 100)) AND  de-val-total > 0 THEN DO:
                
                ASSIGN v-val-previsto  = p-val-previsto /*de-val-total - de-saldo-val*/
                       v-perc-previsto = if de-qtd-total = 0 THEN 100
                                         ELSE 
                                         IF (v-qtd-prevista * 100 / de-qtd-total) <= 999 THEN (p-qtd-prevista * 100 / de-qtd-total)
                                         ELSE 999.99
                       l-arredonda-val = YES.
            END.
        END.
        ELSE DO:
            
            ASSIGN l-arredonda-val = YES
                   v-val-previsto  =  p-val-previsto. /*caso n∆o seja a ultima mediá∆o, n∆o deve truncar e continuar arredondando */
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-msg-erro wMaintenanceNoNavigation 
PROCEDURE pi-msg-erro :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  for each tt_log_erro:
      CREATE RowErrors.
      ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
             RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
             RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
             RowErrors.ErrorSubType     = "ERROR":U.
  end.
  
  empty temp-table tt_log_erro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-z01in627 V-table-Win 
PROCEDURE pi-zoom-z01in627 :
/* -----------------------------------------------------------
  Purpose: Chamar o zoom z01in627    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    {include/zoomvar.i &prog-zoom="inzoom/z01in627.w"
                       &campo=medicao-contrat.responsavel
                       &campozoom=cod-usuario}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-z04in785 V-table-Win 
PROCEDURE pi-zoom-z04in785 :
/* -----------------------------------------------------------
  Purpose: Chamar o zoom z04in785
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
                       
    {include/zoomvar.i &prog-zoom=inzoom/z02in785.w
                       &campo=medicao-contrat.responsavel
                       &campozoom=cod-usuar}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
