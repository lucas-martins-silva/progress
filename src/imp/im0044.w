&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-embarques NO-UNDO LIKE historico-embarque
       FIELD r-rowid      AS   rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-new-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordem-embarque NO-UNDO LIKE ordens-embarque
       Field it-codigo    like item.it-codigo
       field r-rowid      as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-previsoes NO-UNDO LIKE historico-embarque
       field numero-ordem as int
       field num-pedido   as int
       field r-rowid as rowid
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0044 2.00.00.036 } /*** "010036" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0044 MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/10/03 -  4:33 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

    /* Include pre-processadores */
    {cdp/cdcfgmat.i}

    /* Local Variable Definitions ---                                       */
    DEFINE VARIABLE v-cod-estab-f           AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-estab-i           AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-proces-imp-f      AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-proces-imp-i      AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-incoterm-f        AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-incoterm-i        AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-item-f            AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE v-cod-item-i            AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE c-idiom-usuar           AS      CHARACTER    format "x(12)"      NO-UNDO.
    DEFINE VARIABLE cItem                   AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE c-descricao             AS      CHARACTER                        NO-UNDO.
    DEFINE VARIABLE c-embarque              LIKE    embarque-imp.embarque            NO-UNDO.
    DEFINE VARIABLE c-cod-estabel           AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-fornec-f          AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-cod-fornec-i          AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-num-ped-compra-f      AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-num-ped-compra-i      AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-num-ordem-compra-f    AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-num-ordem-compra-i    AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-dat-embarq-f          AS      DATE         format "99/99/9999" NO-UNDO.
    DEFINE VARIABLE v-dat-embarq-i          AS      DATE         format "99/99/9999" NO-UNDO.
    DEFINE VARIABLE v-cod-itinerario-i      AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-cod-itinerario-f      AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-rs-classif            AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-rs-sit-emb            AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-passou                AS      LOGICAL      initial no          NO-UNDO.
    DEFINE VARIABLE v-frame                 AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-new-embarque          LIKE    embarque-imp.embarque            NO-UNDO.
    DEFINE VARIABLE de-quantidade           AS      DECIMAL                          NO-UNDO.
    DEFINE VARIABLE v-frame1                AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-frame2                AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-embarque              like    embarque-imp.embarque            NO-UNDO.
    DEFINE VARIABLE v-estabelec             like    embarque-imp.cod-estabel         NO-UNDO.
    DEFINE VARIABLE v-data                  AS      DATE                             NO-UNDO.
    DEFINE VARIABLE v-num-ordem             LIKE    ordem-compra.numero-ordem        NO-UNDO.
    DEFINE VARIABLE v-parc                  LIKE    prazo-compra.parcela             NO-UNDO.
    DEFINE VARIABLE de-quant-disp           AS      DECIMAL                          NO-UNDO.
    DEFINE VARIABLE i-cont                  AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE iRowresturned           AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE rowsreturn              AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE cAntIdentificCont       AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE cAntTipoCont            AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE i-cont-2                AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE lprox                   AS      LOGICAL INITIAL yes              NO-UNDO.
    DEFINE VARIABLE lant                    AS      LOGICAL initial yes              NO-UNDO.
    DEFINE VARIABLE lSituacao               AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE lnovomod                AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE c-embar-ant             AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE c-cod-estab-ant         AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE pidentific              AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE ptipo                   AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE cReturn                 AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE r-rowid                 AS      ROWID                            NO-UNDO.
    DEFINE VARIABLE r-novo-emb              AS      ROWID                            NO-UNDO.
    DEFINE VARIABLE v-rowid                 AS      ROWID                            NO-UNDO.
    DEFINE VARIABLE r-prev-emb              AS      ROWID                            NO-UNDO.
    DEFINE VARIABLE lreturn                 AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE l-necessita-li          AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE l-li                    AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE l-cria                  AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE l-vincular              AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE l-active                AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE i-linha                 AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-help                  AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE v-cod-embarque          AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-estabel           AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-emb-emb           AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-est-emb           AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-emb-prev          AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-cod-est-prev          AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-nova-parcela          AS      INTEGER                          NO-UNDO.
    DEFINE VARIABLE l-bt-qtde               AS      LOGICAL                          NO-UNDO.
    DEFINE VARIABLE v-qtde-emb              LIKE    prazo-compra.quantidade          NO-UNDO.
    DEFINE VARIABLE v-qtde-n-emb            LIKE    prazo-compra.quantidade          NO-UNDO.
    DEFINE VARIABLE msg1                    AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE msg2                    AS      CHAR                             NO-UNDO.
    DEFINE VARIABLE v-nova-entrega          LIKE    prazo-compra.data-entrega        NO-UNDO.
    DEFINE VARIABLE cCodEstabel             LIKE estabelec.cod-estabel               NO-UNDO.
    DEFINE VARIABLE cEmbarque               LIKE embarque-imp.embarque               NO-UNDO.
    DEFINE VARIABLE v-embarque-imp          LIKE embarque-imp.embarque               NO-UNDO.
    DEFINE VARIABLE v-numero-ordem          LIKE ordem-compra.numero-ordem           NO-UNDO.
    DEFINE VARIABLE v-it-codigo             LIKE ordem-compra.it-codigo              NO-UNDO.
    DEFINE VARIABLE v-data-1                as   date format "99/99/9999"            NO-UNDO.
    DEFINE VARIABLE l-sel                   AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-emp-prev              AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-acompanha             AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-qtde                  AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-cria-emb              AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-relaciona             AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE l-procura-por-placa     AS LOGICAL                               NO-UNDO.
    DEFINE VARIABLE v-cod-placa-i           AS CHARACTER                             NO-UNDO.   
    DEFINE VARIABLE v-cod-placa-f           AS CHARACTER  INIT "ZZZZZZZZZZZZ"        NO-UNDO.
    DEFINE VARIABLE i-numero-ordem          LIKE ordem-compra.numero-ordem           NO-UNDO.
    DEFINE VARIABLE l-bt-qt                 AS LOGICAL INITIAL NO                    NO-UNDO.

    DEFINE VARIABLE v-dat-entreg-i          AS DATE FORMAT "99/99/9999" NO-UNDO INIT &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
    DEFINE VARIABLE v-dat-entreg-f          AS DATE FORMAT "99/99/9999" NO-UNDO INIT 12/31/9999.

    DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
        field d-data  as date format "99/99/9999"
        FIELD r-Rowid AS ROWID.

    {method/dbotterr.i}
     {cdp/cdcfgmat.i}

    /* Local Variable Definitions (DBOs Handles) --- */

    DEFINE VARIABLE h-bocx225    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx230    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx2302   AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx220    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin274    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx140    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin172    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx225a   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hShowMsg     AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-bocx250    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin356    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin287    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin356aa  AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin082    AS HANDLE NO-UNDO.
    
    def var h-bofn017 as handle no-undo.
    def var c-nr-proc-imp   like processo-imp.nr-proc-imp no-undo.
    def var cf-nr-proc-imp  like processo-imp.nr-proc-imp no-undo.
    def var c-return        as char    no-undo.
    def var c-it-codigo1    like ordem-compra.it-codigo no-undo.
    def var de-qt-do-forn   like ordens-embarque.qt-do-forn no-undo.
    def var c-un-nosso      like item.un no-undo.
    def var c-un-fornec     like item.un no-undo.
    def var i-return        like emitente.cod-emitente no-undo.

    /* Global Variable Definitions 
    def new global shared var i-num-pedido-imp as integer no-undo.*/
    DEFINE NEW GLOBAL SHARED VARIABLE gr-ccod-estabel AS CHAR    NO-UNDO.
    DEFINE NEW GLOBAL SHARED VARIABLE gl-im0044       AS LOGICAL NO-UNDO.

    def temp-table tt-ordem-quant no-undo
        field numero-ordem like ordem-compra.numero-ordem
        field quantidade   like prazo-compra.quantidade
        field it-codigo    like item.it-codigo
        field cod-fornec   like emitente.cod-emitente
        field un-fornec    like item.un
        field un-nosso     like item.un
        field r-rowid      as rowid
        index codigo is unique primary
            numero-ordem.

    DEFINE TEMP-TABLE tt-bo-erro NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.

    DEFINE TEMP-TABLE tt-bo-erros NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.    


    DEFINE TEMP-TABLE tt-selecionada NO-UNDO
        FIELD r-rowid          AS ROWID.

    DEFINE NEW GLOBAL SHARED VARIABLE gr-embarque-imp       AS ROWID NO-UNDO.
    DEFINE NEW GLOBAL SHARED VARIABLE gr-historico-embarque AS ROWID NO-UNDO.

    {fnbo/bofn017.i tt_usuar_mestre}

    {inbo/boin356aa.i tt-prazo-compra}

    {include/i_dbvers.i} /*Include de PrÇ-Processadores*/
    
    /*Tecnica para implementar validaÁ„o produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME bremb

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embarques tt-previsoes tt-ordem-compra ~
tt-ordem-embarque tt-prazo-compra

/* Definitions for BROWSE bremb                                         */
&Scoped-define FIELDS-IN-QUERY-bremb tt-embarques.embarque ~
tt-embarques.cod-itiner tt-embarques.dt-ult-previsao ~
tt-embarques.cod-pto-contr tt-embarques.dt-efetiva 
&Scoped-define ENABLED-FIELDS-IN-QUERY-bremb 
&Scoped-define QUERY-STRING-bremb FOR EACH tt-embarques ~
      WHERE (tt-embarques.cod-estabel    >= v-cod-estab-i      and ~
 tt-embarques.cod-estabel    <= v-cod-estab-f      or ~
 tt-embarques.cod-estabel     = ?)                 and ~
tt-embarques.dt-ult-previsao >= v-dat-embarq-i     and ~
tt-embarques.dt-ult-previsao <= v-dat-embarq-f     and  ~
tt-embarques.cod-itiner      >= v-cod-itinerario-i and ~
tt-embarques.cod-itiner      <= v-cod-itinerario-f  NO-LOCK ~
    BY tt-embarques.embarque
&Scoped-define OPEN-QUERY-bremb OPEN QUERY bremb FOR EACH tt-embarques ~
      WHERE (tt-embarques.cod-estabel    >= v-cod-estab-i      and ~
 tt-embarques.cod-estabel    <= v-cod-estab-f      or ~
 tt-embarques.cod-estabel     = ?)                 and ~
tt-embarques.dt-ult-previsao >= v-dat-embarq-i     and ~
tt-embarques.dt-ult-previsao <= v-dat-embarq-f     and  ~
tt-embarques.cod-itiner      >= v-cod-itinerario-i and ~
tt-embarques.cod-itiner      <= v-cod-itinerario-f  NO-LOCK ~
    BY tt-embarques.embarque.
&Scoped-define TABLES-IN-QUERY-bremb tt-embarques
&Scoped-define FIRST-TABLE-IN-QUERY-bremb tt-embarques


/* Definitions for BROWSE brprev                                        */
&Scoped-define FIELDS-IN-QUERY-brprev tt-previsoes.embarque ~
tt-previsoes.cod-itiner tt-previsoes.dt-ult-previsao ~
tt-previsoes.cod-pto-contr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brprev 
&Scoped-define QUERY-STRING-brprev FOR EACH tt-previsoes ~
      WHERE tt-previsoes.cod-estabel     >= v-cod-estab-i      and ~
tt-previsoes.cod-estabel     <= v-cod-estab-f      and  ~
(tt-previsoes.dt-ult-previsao >= v-dat-embarq-i    and  ~
 tt-previsoes.dt-ult-previsao <= v-dat-embarq-f    or   ~
 tt-previsoes.dt-ult-previsao  = ?)                and  ~
tt-previsoes.cod-itiner      >= v-cod-itinerario-i and ~
tt-previsoes.cod-itiner      <= v-cod-itinerario-f  NO-LOCK ~
    BY tt-previsoes.cod-estabel ~
       BY tt-previsoes.embarque
&Scoped-define OPEN-QUERY-brprev OPEN QUERY brprev FOR EACH tt-previsoes ~
      WHERE tt-previsoes.cod-estabel     >= v-cod-estab-i      and ~
tt-previsoes.cod-estabel     <= v-cod-estab-f      and  ~
(tt-previsoes.dt-ult-previsao >= v-dat-embarq-i    and  ~
 tt-previsoes.dt-ult-previsao <= v-dat-embarq-f    or   ~
 tt-previsoes.dt-ult-previsao  = ?)                and  ~
tt-previsoes.cod-itiner      >= v-cod-itinerario-i and ~
tt-previsoes.cod-itiner      <= v-cod-itinerario-f  NO-LOCK ~
    BY tt-previsoes.cod-estabel ~
       BY tt-previsoes.embarque.
&Scoped-define TABLES-IN-QUERY-brprev tt-previsoes
&Scoped-define FIRST-TABLE-IN-QUERY-brprev tt-previsoes


/* Definitions for BROWSE brson1                                        */
&Scoped-define FIELDS-IN-QUERY-brson1 tt-ordem-compra.numero-ordem tt-ordem-compra.it-codigo fnQtde() @ de-quantidade fnUnItem(tt-ordem-compra.it-codigo) @ c-un-nosso fnQtFornec() @ de-qt-do-forn fnUnFornec() @ c-un-fornec fnProcesso(tt-ordem-compra.num-pedido) @ c-nr-proc-imp tt-ordem-compra.d-data   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brson1   
&Scoped-define SELF-NAME brson1
&Scoped-define OPEN-QUERY-brson1 do:   if l-relaciona = no then   do:       case v-rs-classif:           when 1 then              OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK                                      by tt-ordem-compra.numero-ordem                                      by tt-ordem-compra.it-codigo                                      by tt-ordem-compra.d-data.           when 2 then              OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK                                      by tt-ordem-compra.it-codigo                                      by tt-ordem-compra.numero-ordem                                      by tt-ordem-compra.d-data.           when 3 then              OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK                                      by tt-ordem-compra.d-data                                      by tt-ordem-compra.numero-ordem                                      by tt-ordem-compra.it-codigo.           when 4 then              OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK                                      by tt-ordem-compra.it-codigo                                      by tt-ordem-compra.d-data                                      by tt-ordem-compra.numero-ordem.       end case.   end. end.
&Scoped-define TABLES-IN-QUERY-brson1 tt-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brson1 tt-ordem-compra


/* Definitions for BROWSE brson2                                        */
&Scoped-define FIELDS-IN-QUERY-brson2 tt-ordem-embarque.numero-ordem ~
tt-ordem-embarque.parcela tt-ordem-embarque.it-codigo ~
tt-ordem-embarque.quantidade ~
fnUnItem(tt-ordem-embarque.it-codigo) @ c-un-nosso ~
tt-ordem-embarque.qt-do-forn ~
fnUnFornec1(tt-ordem-embarque.numero-ordem) @ c-un-fornec ~
tt-ordem-embarque.data-1 ~
fnProcessoprazo(tt-ordem-embarque.numero-ordem) @ c-nr-proc-imp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brson2 
&Scoped-define QUERY-STRING-brson2 FOR EACH tt-ordem-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brson2 OPEN QUERY brson2 FOR EACH tt-ordem-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brson2 tt-ordem-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brson2 tt-ordem-embarque


/* Definitions for BROWSE brson3                                        */
&Scoped-define FIELDS-IN-QUERY-brson3 tt-prazo-compra.numero-ordem tt-prazo-compra.parcela tt-prazo-compra.it-codigo tt-prazo-compra.quant-saldo tt-prazo-compra.un tt-prazo-compra.qtd-do-forn fnUnFornec1(tt-prazo-compra.numero-ordem) @ c-un-fornec fnProcessoprazo(tt-prazo-compra.numero-ordem) @ c-nr-proc-imp tt-prazo-compra.data-entrega   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brson3   
&Scoped-define SELF-NAME brson3
&Scoped-define OPEN-QUERY-brson3 do:     RUN pi-openquerybrson3 (INPUT v-rs-classif). end.
&Scoped-define TABLES-IN-QUERY-brson3 tt-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brson3 tt-prazo-compra


/* Definitions for FRAME favinc                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-favinc ~
    ~{&OPEN-QUERY-brson1}~
    ~{&OPEN-QUERY-brson3}

/* Definitions for FRAME femb                                           */
&Scoped-define OPEN-BROWSERS-IN-QUERY-femb ~
    ~{&OPEN-QUERY-bremb}

/* Definitions for FRAME fprev                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fprev ~
    ~{&OPEN-QUERY-brprev}

/* Definitions for FRAME fvinc                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fvinc ~
    ~{&OPEN-QUERY-brson2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BT-SEL btExit btHelp bt-retirar bt-vinc ~
btQtde bt-emp-prev bt-cria-prev bt-acompanha im-a-vinc im-emb im-prev ~
im-vinc RECT-14 RECT-15 rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem w-livre 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProcesso w-livre 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnprocessoprazo w-livre 
FUNCTION fnprocessoprazo RETURNS CHARACTER
  ( input p-numero-ordem as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtde w-livre 
FUNCTION fnQtde RETURNS decimal
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtFornec w-livre 
FUNCTION fnQtFornec RETURNS DECIMAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec w-livre 
FUNCTION fnUnFornec RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec1 w-livre 
FUNCTION fnUnFornec1 RETURNS CHARACTER
  ( input pnum-ordem as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnItem w-livre 
FUNCTION fnUnItem RETURNS CHARACTER
  (input p-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM m_Seleo        LABEL "Se&leá∆o"      
       RULE
       MENU-ITEM miQueryJoins   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_%Opes 
       MENU-ITEM m_A_Vincular   LABEL "&A Vincular"   
       MENU-ITEM m_Vinculadas   LABEL "&Vinculadas"   
       MENU-ITEM m_Previses     LABEL "&Previs‰es"    
       MENU-ITEM m_Embarques    LABEL "&Embarques"    .

DEFINE SUB-MENU m_Comandos 
       MENU-ITEM m_Retirar      LABEL "&Retirar"      
       MENU-ITEM m_Vincular     LABEL "&Vincular"     
       MENU-ITEM m_Quantidade   LABEL "&Quantidade"   
       RULE
       MENU-ITEM m_EmbarquePreviso LABEL "&Embarque/Previs∆o"
       MENU-ITEM m_Cria_Previso LABEL "&Cria Previs∆o"
       MENU-ITEM m_Acompanhamento LABEL "&Acompanhamento".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM micontents     LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU mbmain MENUBAR
       SUB-MENU  mi-programa    LABEL "&Arquivo"      
       SUB-MENU  m_%Opes        LABEL "&Opá‰es"       
       SUB-MENU  m_Comandos     LABEL "&Comandos"     
       SUB-MENU  m_Ajuda        LABEL "A&juda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-acompanha 
     LABEL "Acom&panhamento" 
     SIZE 13.86 BY .88
     FONT 1.

DEFINE BUTTON bt-cria-prev 
     LABEL "Cria &Previs∆o" 
     SIZE 10.14 BY .88
     FONT 1.

DEFINE BUTTON bt-emp-prev 
     LABEL "&Embarque/Previs∆o" 
     SIZE 15.14 BY .88
     FONT 1.

DEFINE BUTTON bt-retirar 
     LABEL "&Desvincular" 
     SIZE 13 BY .88
     FONT 1.

DEFINE BUTTON BT-SEL 
     IMAGE-UP FILE "IMAGE~\im-ran":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21.

DEFINE BUTTON bt-vinc 
     LABEL "&Vincular" 
     SIZE 13 BY .88
     FONT 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQtde 
     LABEL "&Quantidade" 
     SIZE 13 BY .88
     FONT 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE IMAGE im-a-vinc
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-emb
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-prev
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-vinc
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.43 BY 1.33.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 0  NO-FILL   
     SIZE 87.57 BY 12.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 87.29 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.14 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.75
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-left-2
     EDGE-PIXELS 0    
     SIZE .43 BY 11.75
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.75
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 87.29 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY bremb FOR 
      tt-embarques SCROLLING.

DEFINE QUERY brprev FOR 
      tt-previsoes
    FIELDS(tt-previsoes.embarque
      tt-previsoes.cod-itiner
      tt-previsoes.dt-ult-previsao
      tt-previsoes.cod-pto-contr) SCROLLING.

DEFINE QUERY brson1 FOR 
      tt-ordem-compra SCROLLING.

DEFINE QUERY brson2 FOR 
      tt-ordem-embarque SCROLLING.

DEFINE QUERY brson3 FOR 
      tt-prazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE bremb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS bremb w-livre _STRUCTURED
  QUERY bremb NO-LOCK DISPLAY
      tt-embarques.embarque FORMAT "X(16)":U
      tt-embarques.cod-itiner COLUMN-LABEL "Itinerario" FORMAT ">>,>>9":U
      tt-embarques.dt-ult-previsao COLUMN-LABEL "Prev/Emb" FORMAT "99/99/9999":U
      tt-embarques.cod-pto-contr COLUMN-LABEL "Posiá∆o Atual" FORMAT ">>,>>9":U
      tt-embarques.dt-efetiva COLUMN-LABEL "Data Efetiva" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40.72 BY 9.42
         FONT 2.

DEFINE BROWSE brprev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brprev w-livre _STRUCTURED
  QUERY brprev NO-LOCK DISPLAY
      tt-previsoes.embarque FORMAT "X(16)":U
      tt-previsoes.cod-itiner COLUMN-LABEL "Itinerario" FORMAT ">>,>>9":U
      tt-previsoes.dt-ult-previsao COLUMN-LABEL "Prev/Emb" FORMAT "99/99/9999":U
      tt-previsoes.cod-pto-contr COLUMN-LABEL "Posiá∆o Atual" FORMAT ">>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40.72 BY 9.42
         FONT 2.

DEFINE BROWSE brson1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brson1 w-livre _FREEFORM
  QUERY brson1 NO-LOCK DISPLAY
      tt-ordem-compra.numero-ordem FORMAT ">>>>>>>9,99"
      tt-ordem-compra.it-codigo
      fnQtde() @ de-quantidade COLUMN-LABEL "Nossa Qtde Disp" FORMAT ">>>>>,>>9.9999"
      fnUnItem(tt-ordem-compra.it-codigo) @ c-un-nosso COLUMN-LABEL "Un" FORMAT "xx"
      fnQtFornec() @ de-qt-do-forn COLUMN-LABEL "Qtde Fornec Disp"
      fnUnFornec() @ c-un-fornec COLUMN-LABEL "Un Fornec"
      fnProcesso(tt-ordem-compra.num-pedido) @ c-nr-proc-imp COLUMN-LABEL "Proc Imp"
      tt-ordem-compra.d-data COLUMN-LABEL "Dt Entrega" FORMAT "99/99/9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40.72 BY 9.42
         FONT 2.

DEFINE BROWSE brson2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brson2 w-livre _STRUCTURED
  QUERY brson2 DISPLAY
      tt-ordem-embarque.numero-ordem FORMAT ">>>>>9,99":U
      tt-ordem-embarque.parcela FORMAT ">>>>9":U
      tt-ordem-embarque.it-codigo COLUMN-LABEL "Item" FORMAT "x(16)":U
      tt-ordem-embarque.quantidade FORMAT ">>>>>,>>9.9999":U
      fnUnItem(tt-ordem-embarque.it-codigo) @ c-un-nosso COLUMN-LABEL "Un" FORMAT "xx":U
      tt-ordem-embarque.qt-do-forn COLUMN-LABEL "Qtde Fornec" FORMAT ">>>>>,>>9.9999":U
      fnUnFornec1(tt-ordem-embarque.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx":U
      tt-ordem-embarque.data-1 COLUMN-LABEL "Dt Entrega" FORMAT "99/99/9999":U
      fnProcessoprazo(tt-ordem-embarque.numero-ordem) @ c-nr-proc-imp COLUMN-LABEL "Proc Imp" FORMAT "x(12)":U
            WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40.72 BY 9.42
         FONT 2.

DEFINE BROWSE brson3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brson3 w-livre _FREEFORM
  QUERY brson3 NO-LOCK DISPLAY
      tt-prazo-compra.numero-ordem format ">>>>>9,99"
      tt-prazo-compra.parcela
      tt-prazo-compra.it-codigo
      tt-prazo-compra.quant-saldo COLUMN-LABEL "Qtde Disp" FORMAT ">>>>>,>>9.9999"
      tt-prazo-compra.un COLUMN-LABEL "Un"
      tt-prazo-compra.qtd-do-forn COLUMN-LABEL "Qtde Fornec Disp"
      fnUnFornec1(tt-prazo-compra.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec"
      fnProcessoprazo(tt-prazo-compra.numero-ordem) @ c-nr-proc-imp COLUMN-LABEL "Proc Imp"
      tt-prazo-compra.data-entrega COLUMN-LABEL "Data Entrega" FORMAT "99/99/9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40.72 BY 9.42
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     BT-SEL AT ROW 1.13 COL 67.72 HELP
          "Seleá∆o"
     btQueryJoins AT ROW 1.13 COL 73.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 77.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 81.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 85.43 HELP
          "Ajuda"
     bt-retirar AT ROW 14.42 COL 3.86 HELP
          "Retira a parcela de compra da Previs∆o /Embarque."
     bt-vinc AT ROW 14.42 COL 17.14 HELP
          "Relaciona a parcela de compra Ö Previs∆o/Embarque."
     btQtde AT ROW 14.42 COL 30.43 HELP
          "Altera a quantidade da parcela de compra."
     bt-emp-prev AT ROW 14.42 COL 46.72 HELP
          "Acessa o programa de manutená∆o de embarque."
     bt-cria-prev AT ROW 14.42 COL 62.14 HELP
          "Cria previs∆o de embarque."
     bt-acompanha AT ROW 14.42 COL 72.57 HELP
          "Acessa o programa de Acompanhamento de Embarque."
     "∑ Vincular" VIEW-AS TEXT
          SIZE 11.14 BY .67 AT ROW 3.13 COL 3.14
          BGCOLOR 8 FONT 1
     " Vinculadas" VIEW-AS TEXT
          SIZE 13.72 BY .67 AT ROW 3.13 COL 18.43
          BGCOLOR 8 FONT 1
     "Previs‰es" VIEW-AS TEXT
          SIZE 13.72 BY .67 AT ROW 3.13 COL 47.29
          BGCOLOR 8 FONT 1
     "Embarques" VIEW-AS TEXT
          SIZE 13.72 BY .67 AT ROW 3.13 COL 63
          BGCOLOR 8 FONT 1
     RECT-6 AT ROW 15.79 COL 2.29
     rt-folder-left AT ROW 4.08 COL 2.14
     rt-folder-left-2 AT ROW 4.08 COL 2.14
     rt-folder-right AT ROW 4.04 COL 89
     rt-folder-top AT ROW 3.96 COL 2.14
     im-a-vinc AT ROW 2.88 COL 2
     im-emb AT ROW 2.88 COL 61.86
     im-prev AT ROW 2.88 COL 46.14
     im-vinc AT ROW 2.88 COL 17.72
     RECT-14 AT ROW 14.21 COL 3
     RECT-15 AT ROW 3.92 COL 2.14
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 15.5.

DEFINE FRAME favinc
     brson3 AT ROW 1.25 COL 1.29
     brson1 AT ROW 1.25 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4.13
         SIZE 41.57 BY 9.92.

DEFINE FRAME fvinc
     brson2 AT ROW 1.25 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4.13
         SIZE 41.14 BY 9.92.

DEFINE FRAME femb
     bremb AT ROW 1.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 46.14 ROW 4.13
         SIZE 42.14 BY 9.92.

DEFINE FRAME fprev
     brprev AT ROW 1.25 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 46.14 ROW 4.13
         SIZE 41.57 BY 9.92.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-embarques T "NEW GLOBAL SHARED" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          FIELD r-rowid      AS   rowid
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-new-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordem-embarque T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          Field it-codigo    like item.it-codigo
          field r-rowid      as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-previsoes T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field numero-ordem as int
          field num-pedido   as int
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
         TITLE              = ""
         HEIGHT             = 15.29
         WIDTH              = 89.72
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.17
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbmain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
/*{include/w-livre.i}*/
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME favinc:FRAME = FRAME f-cad:HANDLE
       FRAME femb:FRAME = FRAME f-cad:HANDLE
       FRAME fprev:FRAME = FRAME f-cad:HANDLE
       FRAME fvinc:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON btQueryJoins IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btReportsJoins IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left-2 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME favinc
                                                                        */
/* BROWSE-TAB brson3 1 favinc */
/* BROWSE-TAB brson1 brson3 favinc */
/* SETTINGS FOR FRAME femb
                                                                        */
/* BROWSE-TAB bremb 1 femb */
/* SETTINGS FOR FRAME fprev
                                                                        */
/* BROWSE-TAB brprev 1 fprev */
/* SETTINGS FOR FRAME fvinc
                                                                        */
/* BROWSE-TAB brson2 1 fvinc */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE bremb
/* Query rebuild information for BROWSE bremb
     _TblList          = "Temp-Tables.tt-embarques"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-embarques.embarque|yes"
     _Where[1]         = "(tt-embarques.cod-estabel    >= v-cod-estab-i      and
 tt-embarques.cod-estabel    <= v-cod-estab-f      or
 tt-embarques.cod-estabel     = ?)                 and
tt-embarques.dt-ult-previsao >= v-dat-embarq-i     and
tt-embarques.dt-ult-previsao <= v-dat-embarq-f     and 
tt-embarques.cod-itiner      >= v-cod-itinerario-i and
tt-embarques.cod-itiner      <= v-cod-itinerario-f "
     _FldNameList[1]   > Temp-Tables.tt-embarques.embarque
"tt-embarques.embarque" ? ? "character" ? ? ? ? ? ? no "C¢digo do Embarque" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-embarques.cod-itiner
"tt-embarques.cod-itiner" "Itinerario" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-embarques.dt-ult-previsao
"tt-embarques.dt-ult-previsao" "Prev/Emb" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-embarques.cod-pto-contr
"tt-embarques.cod-pto-contr" "Posiá∆o Atual" ? "integer" ? ? ? ? ? ? no "Posiá∆o Atual" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-embarques.dt-efetiva
"tt-embarques.dt-efetiva" "Data Efetiva" ? "date" ? ? ? ? ? ? no "Dta prevista para embarque" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE bremb */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brprev
/* Query rebuild information for BROWSE brprev
     _TblList          = "Temp-Tables.tt-previsoes"
     _Options          = "NO-LOCK"
     _TblOptList       = "USED"
     _OrdList          = "Temp-Tables.tt-previsoes.cod-estabel|yes,Temp-Tables.tt-previsoes.embarque|yes"
     _Where[1]         = "tt-previsoes.cod-estabel     >= v-cod-estab-i      and
tt-previsoes.cod-estabel     <= v-cod-estab-f      and 
(tt-previsoes.dt-ult-previsao >= v-dat-embarq-i    and 
 tt-previsoes.dt-ult-previsao <= v-dat-embarq-f    or  
 tt-previsoes.dt-ult-previsao  = ?)                and 
tt-previsoes.cod-itiner      >= v-cod-itinerario-i and
tt-previsoes.cod-itiner      <= v-cod-itinerario-f "
     _FldNameList[1]   > Temp-Tables.tt-previsoes.embarque
"tt-previsoes.embarque" ? ? "character" ? ? ? ? ? ? no "C¢digo do Embarque" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-previsoes.cod-itiner
"tt-previsoes.cod-itiner" "Itinerario" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-previsoes.dt-ult-previsao
"tt-previsoes.dt-ult-previsao" "Prev/Emb" ? "date" ? ? ? ? ? ? no "Previs∆o de Embarque" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-previsoes.cod-pto-contr
"tt-previsoes.cod-pto-contr" "Posiá∆o Atual" ? "integer" ? ? ? ? ? ? no "Posiá∆o Atual" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brprev */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brson1
/* Query rebuild information for BROWSE brson1
     _START_FREEFORM
do:
  if l-relaciona = no then
  do:
      case v-rs-classif:
          when 1 then
             OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
                                     by tt-ordem-compra.numero-ordem
                                     by tt-ordem-compra.it-codigo
                                     by tt-ordem-compra.d-data.
          when 2 then
             OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
                                     by tt-ordem-compra.it-codigo
                                     by tt-ordem-compra.numero-ordem
                                     by tt-ordem-compra.d-data.
          when 3 then
             OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
                                     by tt-ordem-compra.d-data
                                     by tt-ordem-compra.numero-ordem
                                     by tt-ordem-compra.it-codigo.
          when 4 then
             OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
                                     by tt-ordem-compra.it-codigo
                                     by tt-ordem-compra.d-data
                                     by tt-ordem-compra.numero-ordem.
      end case.
  end.
end.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _TblOptList       = "USED"
     _Query            is OPENED
*/  /* BROWSE brson1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brson2
/* Query rebuild information for BROWSE brson2
     _TblList          = "Temp-Tables.tt-ordem-embarque"
     _FldNameList[1]   > Temp-Tables.tt-ordem-embarque.numero-ordem
"tt-ordem-embarque.numero-ordem" ? ">>>>>9,99" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-ordem-embarque.parcela
     _FldNameList[3]   > "_<CALC>"
"tt-ordem-embarque.it-codigo" "Item" "x(16)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-ordem-embarque.quantidade
     _FldNameList[5]   > "_<CALC>"
"fnUnItem(tt-ordem-embarque.it-codigo) @ c-un-nosso" "Un" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-ordem-embarque.qt-do-forn
"tt-ordem-embarque.qt-do-forn" "Qtde Fornec" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnUnFornec1(tt-ordem-embarque.numero-ordem) @ c-un-fornec" "Un Fornec" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-ordem-embarque.data-1
"tt-ordem-embarque.data-1" "Dt Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fnProcessoprazo(tt-ordem-embarque.numero-ordem) @ c-nr-proc-imp" "Proc Imp" "x(12)" ? ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brson2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brson3
/* Query rebuild information for BROWSE brson3
     _START_FREEFORM
do:
    RUN pi-openquerybrson3 (INPUT v-rs-classif).
end.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _TblOptList       = "USED"
     _Query            is OPENED
*/  /* BROWSE brson3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
 /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  if l-active = yes then do:
    IF VALID-HANDLE(h-bocx225) THEN
       delete procedure h-bocx225.
    IF VALID-HANDLE(h-bocx230) THEN   
       delete procedure h-bocx230.
    IF VALID-HANDLE(h-bocx2302) THEN       
       delete procedure h-bocx2302.
    IF VALID-HANDLE(h-bocx220) THEN       
       delete procedure h-bocx220.
    IF VALID-HANDLE(h-boin274) THEN       
       delete procedure h-boin274.
    IF VALID-HANDLE(h-bocx140) THEN       
       delete procedure h-bocx140.
    &IF '{&mgdis_version}' >= '2.06f' &THEN
        IF VALID-HANDLE(h-bofn017) THEN 
           delete procedure h-bofn017.  
    &else
        IF VALID-HANDLE(h-boun178) THEN       
           delete procedure h-boun178.
    &endif
    IF VALID-HANDLE(h-boin172) THEN       
       delete procedure h-boin172.
    IF VALID-HANDLE(h-bocx225a) THEN
       delete procedure h-bocx225a.
    IF VALID-HANDLE(hShowMsg) THEN
        DELETE PROCEDURE hShowMsg.
    IF VALID-HANDLE(h-bocx250) THEN
        DELETE PROCEDURE h-bocx250. 
    IF VALID-HANDLE(h-boin356) THEN
        DELETE PROCEDURE h-boin356.
    IF VALID-HANDLE(h-boin287) THEN
        DELETE PROCEDURE h-boin287.
    IF VALID-HANDLE(h-boin356aa) THEN
        DELETE PROCEDURE h-boin356aa.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
  end.          
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  if l-active = yes then do:
    IF VALID-HANDLE(h-bocx225) THEN
       delete procedure h-bocx225.
    IF VALID-HANDLE(h-bocx230) THEN   
       delete procedure h-bocx230.
    IF VALID-HANDLE(h-bocx2302) THEN       
       delete procedure h-bocx2302.
    IF VALID-HANDLE(h-bocx220) THEN       
       delete procedure h-bocx220.
    IF VALID-HANDLE(h-boin274) THEN       
       delete procedure h-boin274.
    IF VALID-HANDLE(h-bocx140) THEN       
       delete procedure h-bocx140.
    &IF '{&mgdis_version}' >= '2.06f' &THEN
        IF VALID-HANDLE(h-bofn017) THEN 
           delete procedure h-bofn017.  
    &else    
        IF VALID-HANDLE(h-boun178) THEN       
           delete procedure h-boun178.
    &endif
    IF VALID-HANDLE(h-boin172) THEN       
       delete procedure h-boin172.
    IF VALID-HANDLE(h-bocx225a) THEN
       delete procedure h-bocx225a.
    IF VALID-HANDLE(hShowMsg) THEN
        DELETE PROCEDURE hShowMsg.
    IF VALID-HANDLE(h-bocx250) THEN
        DELETE PROCEDURE h-bocx250. 
    IF VALID-HANDLE(h-boin356) THEN
        DELETE PROCEDURE h-boin356.
    IF VALID-HANDLE(h-boin287) THEN
        DELETE PROCEDURE h-boin287.
    IF VALID-HANDLE(h-boin356aa) THEN
        DELETE PROCEDURE h-boin356aa.
    if valid-handle(h-boin082) then
        delete procedure h-boin082.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
  end.          
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME bremb
&Scoped-define FRAME-NAME femb
&Scoped-define SELF-NAME bremb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bremb w-livre
ON CURSOR-DOWN OF bremb IN FRAME femb
DO:
  SESSION:SET-WAIT-STATE("general":U).
  if can-find(first tt-embarques) then
  do:
    bremb:fetch-selected-row(1).

    ASSIGN r-prev-emb = rowid(tt-embarques).
  end.
  find first tt-embarques no-lock
       where rowid(tt-embarques) = r-prev-emb no-error.
  if avail tt-embarques then do:
    assign v-embarque   = tt-embarques.embarque
           v-estabelec  = tt-embarques.cod-estabel.
    run pi-cria-tt-vinculadas.
    if v-frame1 = 2 then
    do:
       {&OPEN-QUERY-brSon2}
    end.
  end.    
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bremb w-livre
ON CURSOR-UP OF bremb IN FRAME femb
DO:
  SESSION:SET-WAIT-STATE("general":U).
  bremb:select-prev-row().
  if can-find(first tt-embarques) then
  do:
    bremb:fetch-selected-row(1).

    ASSIGN r-prev-emb = rowid(tt-embarques).
  end.

  find first tt-embarques no-lock
       where rowid(tt-embarques) = r-prev-emb no-error.
  if avail tt-embarques then do:
    assign v-embarque   = tt-embarques.embarque
           v-estabelec  = tt-embarques.cod-estabel.
    run pi-cria-tt-vinculadas.
    if v-frame1 = 2 then
    do:
       {&OPEN-QUERY-brSon2}
    end.
  end.
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bremb w-livre
ON MOUSE-SELECT-CLICK OF bremb IN FRAME femb
DO:
  SESSION:SET-WAIT-STATE("general":U).
  if can-find(first tt-embarques) then
  do:
    bremb:fetch-selected-row(1).

    ASSIGN r-prev-emb = rowid(tt-embarques).
  end.

  find first tt-embarques no-lock
       where rowid(tt-embarques) = r-prev-emb no-error.
  if avail tt-embarques then
  do:
    assign v-embarque       = tt-embarques.embarque
           v-estabelec      = tt-embarques.cod-estabel
           v-cod-emb-emb    = tt-embarques.embarque
           v-cod-est-emb    = tt-embarques.cod-estabel.
    run pi-cria-tt-vinculadas.
  end.       

  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brprev
&Scoped-define FRAME-NAME fprev
&Scoped-define SELF-NAME brprev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brprev w-livre
ON CURSOR-DOWN OF brprev IN FRAME fprev
DO:
  SESSION:SET-WAIT-STATE("general":U).
  brprev:select-next-row().
  ASSIGN r-prev-emb = rowid(tt-previsoes).
  find first tt-previsoes no-lock
       where rowid(tt-previsoes) = r-prev-emb no-error.
  if avail tt-previsoes then do:   
    assign v-embarque   = tt-previsoes.embarque
           v-estabelec  = tt-previsoes.cod-estabel.
    run pi-cria-tt-vinculadas.
    if v-frame1 = 2 then
    do:
       {&OPEN-QUERY-brSon2}
    end.
  end.    
  SESSION:SET-WAIT-STATE("":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brprev w-livre
ON CURSOR-UP OF brprev IN FRAME fprev
DO:
  SESSION:SET-WAIT-STATE("general":U).
  brprev:select-prev-row().
  ASSIGN r-prev-emb = rowid(tt-previsoes).
  find first tt-previsoes no-lock
       where rowid(tt-previsoes) = r-prev-emb no-error.
  if avail tt-previsoes then do:    
    assign v-embarque   = tt-previsoes.embarque
           v-estabelec  = tt-previsoes.cod-estabel.
    run pi-cria-tt-vinculadas.
    if v-frame1 = 2 then
    do:
       {&OPEN-QUERY-brSon2}
    end.
  end.    
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brprev w-livre
ON MOUSE-SELECT-CLICK OF brprev IN FRAME fprev
DO:
  SESSION:SET-WAIT-STATE("general":U).

  if can-find(first tt-previsoes) then
  do:
    FIND FIRST tt-previsoes WHERE
               tt-previsoes.cod-itiner >= v-cod-itinerario-i and
               tt-previsoes.cod-itiner <= v-cod-itinerario-f NO-ERROR.
    IF AVAIL tt-previsoes THEN DO:
        brprev:fetch-selected-row(1).
        ASSIGN r-prev-emb = rowid(tt-previsoes).
    END.
  end.
  find first tt-previsoes no-lock
       where rowid(tt-previsoes) = r-prev-emb no-error.
  if avail tt-previsoes THEN DO:         
    assign v-embarque       = tt-previsoes.embarque
           v-estabelec      = tt-previsoes.cod-estabel
           v-cod-emb-prev   = tt-previsoes.embarque
           v-cod-est-prev   = tt-previsoes.cod-estabel.
    run pi-cria-tt-vinculadas.
  end.             
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brson1
&Scoped-define FRAME-NAME favinc
&Scoped-define SELF-NAME brson1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brson1 w-livre
ON MOUSE-SELECT-CLICK OF brson1 IN FRAME favinc
DO:
  SESSION:SET-WAIT-STATE("general":U).
  enable bt-vinc        with frame f-cad.
  assign MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = yes.
  IF CAN-FIND(FIRST tt-ordem-compra) and
     v-frame2 = 1 
  then do:
     enable bt-cria-prev   with frame f-cad.
     assign MENU-ITEM m_cria_previso:SENSITIVE IN MENU mbMain = yes.
  end.   
  assign MENU-ITEM m_cria_previso:SENSITIVE IN MENU mbMain = yes.
  if avail tt-ordem-compra then
     assign v-numero-ordem = tt-ordem-compra.numero-ordem
            v-it-codigo    = tt-ordem-compra.it-codigo
            v-data-1       = tt-ordem-compra.d-data
            v-cod-estabel  = tt-ordem-compra.cod-estabel.
  SESSION:SET-WAIT-STATE("":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brson1 w-livre
ON ROW-ENTRY OF brson1 IN FRAME favinc
DO:
  enable bt-vinc      with frame f-cad.
  assign MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brson3
&Scoped-define SELF-NAME brson3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brson3 w-livre
ON MOUSE-SELECT-CLICK OF brson3 IN FRAME favinc
DO:
    SESSION:SET-WAIT-STATE("general":U).

    ENABLE bt-vinc WITH FRAME f-cad.

    ASSIGN MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = YES.

    IF CAN-FIND(FIRST tt-prazo-compra) AND v-frame2 = 1 THEN
        ENABLE bt-cria-prev WITH FRAME f-cad.
    
    ASSIGN MENU-ITEM m_cria_previso:SENSITIVE IN MENU mbMain = YES.
  
    IF AVAIL tt-prazo-compra THEN DO:
        
        ASSIGN v-numero-ordem = tt-prazo-compra.numero-ordem
               v-it-codigo    = tt-prazo-compra.it-codigo
               v-data-1       = tt-prazo-compra.data-entrega.
        
        RUN findOrdem IN h-boin274 (INPUT tt-prazo-compra.numero-ordem, OUTPUT c-return).
    END.
    ELSE
        ASSIGN c-return = "NOK":U.


    IF c-return = "" THEN
        RUN getCharField IN h-boin274 (INPUT "cod-estabel", OUTPUT v-cod-estabel).

    SESSION:SET-WAIT-STATE("":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brson3 w-livre
ON ROW-ENTRY OF brson3 IN FRAME favinc
DO:
  enable bt-vinc      with frame f-cad.
  assign MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-acompanha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-acompanha w-livre
ON CHOOSE OF bt-acompanha IN FRAME f-cad /* Acompanhamento */
DO:
  SESSION:SET-WAIT-STATE("general":U).
  run pi-bt-acompanha in this-procedure.
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cria-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cria-prev w-livre
ON CHOOSE OF bt-cria-prev IN FRAME f-cad /* Cria Previs∆o */
DO:
    if l-relaciona = no then do:
       if brson1:NUM-SELECTED-ROWS in frame favinc > 1 
       then do: 
           RUN pi-validaSelecao.
           im-a-vinc:load-image("image/im-fldup") .    
           SESSION:SET-WAIT-STATE("":U).
           return no-apply.
       end.
    end.
    else do:
       if brson3:NUM-SELECTED-ROWS in frame favinc > 1 
       then do: 
           RUN pi-validaSelecao.
           im-a-vinc:load-image("image/im-fldup") .    
           SESSION:SET-WAIT-STATE("":U).
           return no-apply.
       end.
    end.
    SESSION:SET-WAIT-STATE("general":U).   
    IF VALID-HANDLE(hShowMsg) THEN
       DELETE PROCEDURE hShowMsg.    
    IF NOT VALID-HANDLE(hShowMsg) THEN
           RUN utp/showmessage.w PERSISTENT SET hShowMsg.        

    run pi-bt-cria-prev in this-procedure.
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-emp-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-emp-prev w-livre
ON CHOOSE OF bt-emp-prev IN FRAME f-cad /* Embarque/Previs∆o */
DO:
  SESSION:SET-WAIT-STATE("general":U).
  run pi-bt-emp-prev in this-procedure.
  SESSION:SET-WAIT-STATE("":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-livre
ON CHOOSE OF bt-retirar IN FRAME f-cad /* Desvincular */
DO:
   if brson2:NUM-SELECTED-ROWS in frame fvinc = 0 
   then do: 
       RUN pi-validaSelecao.
       im-vinc:load-image("image/im-fldup").
       SESSION:SET-WAIT-STATE("":U).
       return no-apply.
   end.        

   SESSION:SET-WAIT-STATE("general":U).
   run pi-bt-retirar in this-procedure.
   SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-SEL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-SEL w-livre
ON CHOOSE OF BT-SEL IN FRAME f-cad /* Sel */
DO:
  disable btexit with frame f-cad.
  assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain = no
         l-sel                                      = yes.

  /*SESSION:SET-WAIT-STATE("general":U).*/
  run pi-bt-sel in this-procedure.         
  /*SESSION:SET-WAIT-STATE("":U).    */
  assign l-sel = no.
  run pi-habilita in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vinc w-livre
ON CHOOSE OF bt-vinc IN FRAME f-cad /* Vincular */
DO:
def var v-estabel   like tt-previsoes.cod-estabel no-undo.
    def var v-embarque  like tt-previsoes.embarque    no-undo.
    def var l-contabilizado as log no-undo.

    ASSIGN l-bt-qt = NO.

    if l-relaciona = no then do:
       if brson1:NUM-SELECTED-ROWS in frame favinc = 0 
       then do: 
           RUN pi-validaSelecao.
           im-a-vinc:load-image("image/im-fldup") .    
           SESSION:SET-WAIT-STATE("":U).
           return no-apply.
       end.
    end.
    else do:
       if brson3:NUM-SELECTED-ROWS in frame favinc = 0 
       then do: 
           RUN pi-validaSelecao.
           im-a-vinc:load-image("image/im-fldup") .    
           SESSION:SET-WAIT-STATE("":U).
           return no-apply.
       end.
    end.        
    SESSION:SET-WAIT-STATE("general":U).

    if l-relaciona = no then do:
        if v-frame2 = 1 then do:
           ASSIGN r-prev-emb = rowid(tt-previsoes).
           find first tt-previsoes no-lock
                where rowid(tt-previsoes) = r-prev-emb no-error. 
           IF AVAIL tt-previsoes THEN DO:
               assign v-estabel   = tt-previsoes.cod-estabel 
                      v-embarque  = tt-previsoes.embarque.
               run pi-valida-embarque-contabilizado(input v-estabel,
                                                    input v-embarque,
                                                    output l-contabilizado). 
               if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                    SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                    return no-apply.
               end.
               RUN validavinculacaoordens IN h-bocx225 (INPUT tt-previsoes.embarque,
                                                        INPUT tt-previsoes.cod-estabel,
                                                        INPUT tt-ordem-compra.numero-ordem,
                                                        INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                        OUTPUT TABLE RowErrors).

               if tt-previsoes.cod-estabel <> tt-ordem-compra.cod-estabel then do:
                    assign msg1 = ""
                           msg1 = "Estabelecimento " 
                                + string(tt-ordem-compra.cod-estabel) 
                                + " da ordem " 
                                + string(tt-ordem-compra.numero-ordem)
                                + "~~"
                                + "Estabelecimento " 
                                + string(tt-previsoes.cod-estabel) 
                                + " do embarque " 
                                + string(tt-previsoes.embarque).

                    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                INPUT 5955, 
                                INPUT msg1).
                    im-a-vinc:load-image("image/im-fldup") .    
                    SESSION:SET-WAIT-STATE("":U).
                    return no-apply.
               end.
           END.
        end.         
        else do:     
           ASSIGN r-prev-emb = rowid(tt-embarques).
           find first tt-embarques no-lock
                where rowid(tt-embarques) = r-prev-emb no-error.        
           IF AVAIL tt-embarques THEN DO:
               assign v-estabel   = tt-embarques.cod-estabel 
                      v-embarque  = tt-embarques.embarque.                

               run pi-valida-embarque-contabilizado(input v-estabel,
                                                    input v-embarque,
                                                    output l-contabilizado). 
               if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                    SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                    return no-apply.
               end.

               RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarques.embarque,
                                                        INPUT tt-embarques.cod-estabel,
                                                        INPUT tt-ordem-compra.numero-ordem,
                                                        INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                        OUTPUT TABLE RowErrors).


               if tt-embarques.cod-estabel <> tt-ordem-compra.cod-estabel then do:        
                    assign msg1 = ""
                           msg1 = "Estabelecimento " 
                                + string(tt-ordem-compra.cod-estabel) 
                                + " da ordem " 
                                + string(tt-ordem-compra.numero-ordem)
                                + "~~"
                                + "Estabelecimento " 
                                + string(tt-embarques.cod-estabel) 
                                + " do embarque " 
                                + string(tt-embarques.embarque).
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                INPUT 5955, 
                                INPUT msg1).
                    im-a-vinc:load-image("image/im-fldup") .    
                    SESSION:SET-WAIT-STATE("":U).
                    return no-apply.
               end.                
           END.
        end.
    end.        
    else do:
        run retornaestabelecimentoprazocompra in h-boin356aa (input tt-prazo-compra.r-rowid,
                                                              output v-cod-estabel).

        if v-frame2 = 1 then do:

           ASSIGN r-prev-emb = rowid(tt-previsoes).
           find first tt-previsoes no-lock
                where rowid(tt-previsoes) = r-prev-emb no-error. 

           assign v-estabel   = tt-previsoes.cod-estabel 
                  v-embarque  = tt-previsoes.embarque.                 

           run pi-valida-embarque-contabilizado(input v-estabel,
                                                input v-embarque,
                                                output l-contabilizado). 
           if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.
           end.

           RUN validavinculacaoordens IN h-bocx225 (INPUT tt-previsoes.embarque,    
                                                    INPUT tt-previsoes.cod-estabel, 
                                                    INPUT tt-prazo-compra.numero-ordem,
                                                    INPUT tt-prazo-compra.parcela, 
                                                    OUTPUT TABLE RowErrors).

           if tt-previsoes.cod-estabel <> v-cod-estabel then do:
                assign msg1 = ""
                       msg1 = "Estabelecimento " 
                            + string(v-cod-estabel) 
                            + " da ordem " 
                            + string(tt-prazo-compra.numero-ordem)
                            + "~~"
                            + "Estabelecimento " 
                            + string(tt-previsoes.cod-estabel) 
                            + " do embarque " 
                            + string(tt-previsoes.embarque).

                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 5955, 
                            INPUT msg1).
                im-a-vinc:load-image("image/im-fldup") .    
                SESSION:SET-WAIT-STATE("":U).
                return no-apply.
           end.
        end.                                                                 
        else do:     

           ASSIGN r-prev-emb = rowid(tt-embarques).
           find first tt-embarques no-lock
                where rowid(tt-embarques) = r-prev-emb no-error.        

           assign v-estabel   = tt-embarques.cod-estabel 
                  v-embarque  = tt-embarques.embarque.                

           run pi-valida-embarque-contabilizado(input v-estabel,
                                                input v-embarque,
                                                output l-contabilizado). 
           if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.
           end.

           RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarques.embarque,    
                                                    INPUT tt-embarques.cod-estabel, 
                                                    INPUT tt-prazo-compra.numero-ordem,
                                                    INPUT tt-prazo-compra.parcela, 
                                                    OUTPUT TABLE RowErrors).

           if tt-embarques.cod-estabel <> v-cod-estabel then do:        
                assign msg1 = ""
                       msg1 = "Estabelecimento " 
                            + string(v-cod-estabel) 
                            + " da ordem " 
                            + string(tt-prazo-compra.numero-ordem)
                            + "~~"
                            + "Estabelecimento " 
                            + string(tt-embarques.cod-estabel) 
                            + " do embarque " 
                            + string(tt-embarques.embarque).

                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 5955, 
                            INPUT msg1).
                im-a-vinc:load-image("image/im-fldup") .    
                SESSION:SET-WAIT-STATE("":U).
                return no-apply.
            end.                
        end.    

        ASSIGN v-qtde-emb  = tt-prazo-compra.quantidade.

    end.

    if v-frame2 = 1 THEN do:

       assign r-prev-emb  = rowid(tt-previsoes).

       run pi-vincular-1.

       find first tt-previsoes no-lock 
            where tt-previsoes.cod-estabel = v-estabel 
            and   tt-previsoes.embarque    = v-embarque no-error.
       if avail tt-previsoes then do:

          run pi-cria-tt-previsoes.
          {&OPEN-QUERY-brprev}
          find first tt-previsoes where
                     tt-previsoes.cod-estabel = v-estabel and
                     tt-previsoes.embarque    = v-embarque no-lock no-error.                                
          REPOSITION brprev TO ROWID rowid(tt-previsoes).
       end.

    end.   
    else do:
       assign r-prev-emb  = rowid(tt-embarques).
       run pi-vincular-2.
       find first tt-embarques no-lock
            where tt-embarques.cod-estabel = v-estabel 
            and   tt-embarques.embarque    =  v-embarque no-error.
       if avail tt-embarques then do:
          run pi-cria-tt-embarque.
          {&OPEN-QUERY-bremb}
          find first tt-embarques where
                     tt-embarques.cod-estabel = v-estabel and
                     tt-embarques.embarque    = v-embarque no-lock no-error.                                

          REPOSITION bremb TO ROWID rowid(tt-embarques).
       end.

    end.   

    SESSION:SET-WAIT-STATE("general":U).
    run pi-cria-tt-vincular.
    SESSION:SET-WAIT-STATE("":U).
    if l-relaciona = no then do:
       {&OPEN-QUERY-brSon1}
    end.
    else do:
      {&OPEN-QUERY-brSon3}
    end.
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit w-livre
ON CHOOSE OF btExit IN FRAME f-cad /* Exit */
DO:
    IF VALID-HANDLE(h-bocx225) THEN
       delete procedure h-bocx225.
    IF VALID-HANDLE(h-bocx230) THEN   
       delete procedure h-bocx230.
    IF VALID-HANDLE(h-bocx2302) THEN       
       delete procedure h-bocx2302.
    IF VALID-HANDLE(h-bocx220) THEN       
       delete procedure h-bocx220.
    IF VALID-HANDLE(h-boin274) THEN       
       delete procedure h-boin274.
    IF VALID-HANDLE(h-bocx140) THEN       
       delete procedure h-bocx140.
    &IF '{&mgdis_version}' >= '2.06f' &THEN     
        IF VALID-HANDLE(h-bofn017) THEN 
           delete procedure h-bofn017.  
    &else    
        IF VALID-HANDLE(h-boun178) THEN       
           delete procedure h-boun178.
    &endif
    IF VALID-HANDLE(h-boin172) THEN       
       delete procedure h-boin172.
    IF VALID-HANDLE(h-bocx225a) THEN
       delete procedure h-bocx225a.
    IF VALID-HANDLE(hShowMsg) THEN
    DELETE PROCEDURE hShowMsg.
    IF VALID-HANDLE(h-bocx250) THEN
    DELETE PROCEDURE h-bocx250. 
    IF VALID-HANDLE(h-boin356) THEN
    DELETE PROCEDURE h-boin356.
    IF VALID-HANDLE(h-boin287) THEN
    DELETE PROCEDURE h-boin287.
    IF VALID-HANDLE(h-boin356aa) THEN
    DELETE PROCEDURE h-boin356aa.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp w-livre
ON CHOOSE OF btHelp IN FRAME f-cad /* Help */
DO:
  {include/ajuda.i}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQtde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQtde w-livre
ON CHOOSE OF btQtde IN FRAME f-cad /* Quantidade */
DO:
def var l-contabilizado as logical no-undo.
ASSIGN l-bt-qt = YES.

    if l-relaciona = no then do:

        if brson1:NUM-SELECTED-ROWS in frame favinc = 0 then do: 
          RUN pi-validaSelecao.
          im-a-vinc:load-image("image/im-fldup").
          SESSION:SET-WAIT-STATE("":U).
          return no-apply.
        end.
        if brson1:num-selected-rows in frame favinc > 1  THEN do:
            RUN pi-validaSelecao.
            im-a-vinc:load-image("image/im-fldup").
            SESSION:SET-WAIT-STATE("":U).
            return no-apply.
        end.
        if v-frame2 = 1 then do:
           ASSIGN r-prev-emb = rowid(tt-previsoes).
           find first tt-previsoes no-lock
                where rowid(tt-previsoes) = r-prev-emb no-error.
           IF AVAIL tt-previsoes THEN DO:
               run pi-valida-embarque-contabilizado(input tt-previsoes.cod-estabel,
                                                    input tt-previsoes.embarque,
                                                    output l-contabilizado). 

               if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                    SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                    return no-apply.
               end.

               if tt-previsoes.cod-estabel <> tt-ordem-compra.cod-estabel then do:
                    assign msg1 = ""
                           msg1 = "Estabelecimento " 
                                + string(tt-ordem-compra.cod-estabel) 
                                + " da ordem " 
                                + string(tt-ordem-compra.numero-ordem)
                                + "~~"
                                + "Estabelecimento " 
                                + string(tt-previsoes.cod-estabel) 
                                + " do embarque " 
                                + string(tt-previsoes.embarque).

                    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                INPUT 5955, 
                                INPUT msg1).
                    im-a-vinc:load-image("image/im-fldup").
                    SESSION:SET-WAIT-STATE("":U).
                    return no-apply.
               end.
           END.
        end.                       
        else do: 
           ASSIGN r-prev-emb = rowid(tt-embarques).
           find first tt-embarques no-lock
                where rowid(tt-embarques) = r-prev-emb no-error.        

           run pi-valida-embarque-contabilizado(input tt-embarques.cod-estabel,
                                                input tt-embarques.embarque,
                                                output l-contabilizado). 
           if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.
           end.


           if tt-embarques.cod-estabel <> tt-ordem-compra.cod-estabel
           then do:        
                assign msg1 = ""
                       msg1 = "Estabelecimento " 
                            + string(tt-ordem-compra.cod-estabel) 
                            + " da ordem " 
                            + string(tt-ordem-compra.numero-ordem)
                            + "~~"
                            + "Estabelecimento " 
                            + string(tt-embarques.cod-estabel) 
                            + " do embarque " 
                            + string(tt-embarques.embarque).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 5955, 
                            INPUT msg1).
                im-a-vinc:load-image("image/im-fldup").
                SESSION:SET-WAIT-STATE("":U).
                return no-apply.
            end.                
        end.        
        disable btexit 
                btQtde with frame f-cad.
        assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain       = no
               l-active                                         = no
               MENU-ITEM m_Quantidade:SENSITIVE IN MENU mbMain  = no.
        brson1:fetch-selected-row(1).
        run pi-bt-qtde.
    end. 
    else do:

        if brson3:NUM-SELECTED-ROWS in frame favinc = 0  then do: 
          RUN pi-validaSelecao.
          im-a-vinc:load-image("image/im-fldup") .    
          SESSION:SET-WAIT-STATE("":U).
          return no-apply.
        end.
        if brson3:num-selected-rows in frame favinc > 1  THEN do:
            RUN pi-validaSelecao.
            im-a-vinc:load-image("image/im-fldup") .    
            SESSION:SET-WAIT-STATE("":U).
            return no-apply.
        end.

        run retornaestabelecimentoprazocompra in h-boin356aa (input tt-prazo-compra.r-rowid,
                                                              output v-cod-estabel).
        if v-frame2 = 1 then do:
           ASSIGN r-prev-emb = rowid(tt-previsoes).
           find first tt-previsoes no-lock
                where rowid(tt-previsoes) = r-prev-emb no-error. 

           run pi-valida-embarque-contabilizado(input tt-previsoes.cod-estabel,
                                                input tt-previsoes.embarque,
                                                output l-contabilizado). 
           if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.
           end.

           if tt-previsoes.cod-estabel <> v-cod-estabel then do:
                assign msg1 = ""
                       msg1 = "Estabelecimento " 
                            + string(v-cod-estabel) 
                            + " da ordem " 
                            + string(tt-prazo-compra.numero-ordem)
                            + "~~"
                            + "Estabelecimento " 
                            + string(tt-previsoes.cod-estabel) 
                            + " do embarque " 
                            + string(tt-previsoes.embarque).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 5955, 
                            INPUT msg1).
                im-a-vinc:load-image("image/im-fldup") .    
                SESSION:SET-WAIT-STATE("":U).
                return no-apply.
           end.
        end.                                                                 
        else do:     

           ASSIGN r-prev-emb = rowid(tt-embarques).
           find first tt-embarques no-lock
                where rowid(tt-embarques) = r-prev-emb no-error.        

           run pi-valida-embarque-contabilizado(input tt-embarques.cod-estabel,
                                                input tt-embarques.embarque,
                                                output l-contabilizado). 
           if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.
           end.


           if tt-embarques.cod-estabel <> v-cod-estabel then do:        
                assign msg1 = ""
                       msg1 = "Estabelecimento " 
                            + string(v-cod-estabel) 
                            + " da ordem " 
                            + string(tt-prazo-compra.numero-ordem)
                            + "~~"
                            + "Estabelecimento " 
                            + string(tt-embarques.cod-estabel) 
                            + " do embarque " 
                            + string(tt-embarques.embarque).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 5955, 
                            INPUT msg1).
                im-a-vinc:load-image("image/im-fldup") .    
                SESSION:SET-WAIT-STATE("":U).
                return no-apply.
            end.                
        end.        
        disable btexit 
                btQtde with frame f-cad.
        assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain       = no
               l-active                                         = no
               MENU-ITEM m_Quantidade:SENSITIVE IN MENU mbMain  = no.

        run pi-bt-qtde.
    end.
    enable btqtde with frame f-cad.
    assign MENU-ITEM m_Quantidade:SENSITIVE IN MENU mbMain  = yes
           l-qtde                                           = no.
    run pi-habilita in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins w-livre
ON CHOOSE OF btQueryJoins IN FRAME f-cad /* Query Joins */
DO:
    /*RUN showQueryJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins w-livre
ON CHOOSE OF btReportsJoins IN FRAME f-cad /* Reports Joins */
DO:
    /*RUN showReportsJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-a-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-a-vinc w-livre
ON MOUSE-SELECT-CLICK OF im-a-vinc IN FRAME f-cad
DO:
   hide frame fvinc.
          im-vinc:load-image("image/im-flddn") .
          im-vinc:move-to-bottom() .
          im-vinc:load-image("image/im-flddn") .
   assign im-vinc:height = 1
          im-vinc:row    = 2.88.
   view frame favinc.
          im-a-vinc:load-image("image/im-fldup").
          im-a-vinc:move-to-top().
   assign im-a-vinc:height = 1.21
          im-a-vinc:row    = 2.88
          v-frame1         = 1.
          im-a-vinc:load-image("image/im-fldup") .

   if l-relaciona = no then do: 
      hide brson3 in frame favinc.
      view brson1 in frame favinc. 
      enable brson1 with frame favinc.
   end.
   else do:
      hide brson1 in frame favinc.
      view brson3 in frame favinc. 
      enable brson3 with frame favinc.   
   end.      

   disable bt-retirar   with frame f-cad.
   assign MENU-ITEM m_retirar:SENSITIVE          IN MENU mbMain = no.
   enable bt-vinc                                with frame f-cad.
   assign MENU-ITEM m_vincular:SENSITIVE         IN MENU mbMain = yes.
   enable btQtde                                 with frame f-cad.
   assign MENU-ITEM m_quantidade:SENSITIVE       IN MENU mbMain = yes.
   enable bt-vinc                                with frame f-cad.
   assign MENU-ITEM m_vincular:SENSITIVE         IN MENU mbMain = yes.

   IF CAN-FIND(FIRST tt-ordem-compra) and
      v-frame2 = 1 
   then do:
       enable bt-cria-prev                       with frame f-cad.
       assign MENU-ITEM m_cria_previso:SENSITIVE IN MENU mbMain = yes.
   end.  

   if l-vincular = no 
   then do:
       assign l-vincular = yes.
       SESSION:SET-WAIT-STATE("general":U).
       run pi-cria-tt-vincular.
       SESSION:SET-WAIT-STATE("general":U).
       SESSION:SET-WAIT-STATE("":U).
   end.


   if l-relaciona = no then do: 
      {&OPEN-QUERY-brSon1}
      find first tt-ordem-compra no-lock 
           where tt-ordem-compra.numero-ordem  = v-numero-ordem  
           and   tt-ordem-compra.it-codigo     = v-it-codigo    
           and   tt-ordem-compra.d-data        = v-data-1 no-error.
      if avail tt-ordem-compra then do:
         REPOSITION brson1 TO ROWID rowid(tt-ordem-compra).    
         brson1:SELECT-ROW(1).
      end.      
   end.
   else do: 
      {&OPEN-QUERY-brSon3}
      find first tt-prazo-compra no-lock 
           where tt-prazo-compra.numero-ordem  = v-numero-ordem  
           and   tt-prazo-compra.it-codigo     = v-it-codigo    
           and   tt-prazo-compra.data-entrega  = v-data-1 no-error.
      if avail tt-prazo-compra then do:
         REPOSITION brson3 TO ROWID rowid(tt-prazo-compra).    
         brson3:SELECT-ROW(1).
      end.
  end.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-emb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-emb w-livre
ON MOUSE-SELECT-CLICK OF im-emb IN FRAME f-cad
DO:
   SESSION:SET-WAIT-STATE("general":U).
   hide frame fprev.
          im-prev:load-image("image/im-flddn").
          im-prev:move-to-bottom() .
          im-prev:load-image("image/im-flddn").
   assign im-prev:height = 1
          im-prev:row    = 2.88.
   view frame femb.
          im-emb:load-image("image/im-fldup") .
          im-emb:move-to-top().
          im-emb:height = 1.21.
          im-emb:row    = 2.88.
          v-frame2      = 2.
          im-emb:load-image("image/im-fldup") .

   disable bt-cria-prev with frame f-cad.
   assign MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain       = no.

   for each  tt-ordem-embarque EXCLUSIVE-LOCK:
       delete tt-ordem-embarque.
   end.   

   {&OPEN-QUERY-bremb}

   find tt-embarques
        where tt-embarques.embarque  = v-cod-emb-emb no-error.
   if avail tt-embarques then do:
      REPOSITION bremb TO ROWID rowid(tt-embarques).
   end.
   ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.
   find first tt-embarques no-lock
       where tt-embarques.embarque = v-embarque-imp no-error.
   if avail tt-embarques then do:    
      assign v-embarque   = tt-embarques.embarque
             v-estabelec  = tt-embarques.cod-estabel.
      run pi-cria-tt-vinculadas.
      enable bt-emp-prev 
             bt-acompanha with frame f-cad.
      assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
      assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.               
   end.      
   else do:
       disable bt-emp-prev 
               bt-acompanha with frame f-cad.
       assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = no.
       assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = no.               
      run Pi-OpenBrSon2.        
   end.       

   SESSION:SET-WAIT-STATE("":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-prev w-livre
ON MOUSE-SELECT-CLICK OF im-prev IN FRAME f-cad
DO:
   SESSION:SET-WAIT-STATE("general":U).
   hide frame femb.
          im-emb:load-image("image/im-flddn") .
          im-emb:move-to-bottom() .
          im-emb:load-image("image/im-flddn") .
   assign im-emb:height = 1
          im-emb:row    = 2.88.
   view frame fprev.
          im-prev:load-image("image/im-fldup") .
          im-prev:move-to-top().
   assign im-prev:height = 1.21
          im-prev:row    = 2.88
          v-frame2       = 1.
          im-prev:load-image("image/im-fldup") .

   if v-frame1 = 1 then do:
      enable bt-cria-prev with frame f-cad.
      assign MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = yes.
   end.      

   for each  tt-ordem-embarque:
       delete tt-ordem-embarque.
   end.   
   {&OPEN-QUERY-brprev}

   find tt-previsoes where 
        tt-previsoes.embarque     = v-cod-emb-prev and
        tt-previsoes.cod-itiner   >= v-cod-itinerario-i and
        tt-previsoes.cod-itiner   <= v-cod-itinerario-f no-error.
   if avail tt-previsoes then
      REPOSITION brprev TO ROWID rowid(tt-previsoes).
   ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.
   find first tt-previsoes no-lock
        where  tt-previsoes.embarque = v-embarque-imp no-error.
   if avail tt-previsoes then do:
      assign v-embarque   = tt-previsoes.embarque
             v-estabelec  = tt-previsoes.cod-estabel.
      run pi-cria-tt-vinculadas.
      enable bt-emp-prev 
             bt-acompanha with frame f-cad.
      assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
      assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.             
   end.      
   else do:
      disable bt-emp-prev 
              bt-acompanha with frame f-cad.
      assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = no.
      assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = no.              
      run Pi-OpenBrSon2.      
   end.    

   SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-vinc w-livre
ON MOUSE-SELECT-CLICK OF im-vinc IN FRAME f-cad
DO:
   hide frame favinc.
          im-a-vinc:load-image("image/im-flddn") .
          im-a-vinc:move-to-bottom() .
          im-a-vinc:load-image("image/im-flddn") .
   assign im-a-vinc:height = 1
          im-a-vinc:row    = 2.88.
   view frame fvinc.
          im-vinc:load-image("image/im-fldup") .
          im-vinc:move-to-top().
   assign im-vinc:height = 1.21
          im-vinc:row    = 2.88
          v-frame1       = 2.
          im-vinc:load-image("image/im-fldup") .

   if can-find(first tt-ordens-embarque) or
      can-find(first tt-previsoes) 
   then do:
        enable bt-retirar   with frame f-cad.
        assign MENU-ITEM m_retirar:SENSITIVE IN MENU mbMain = yes.
   end.        
   else do:
        disable bt-retirar  with frame f-cad.   
        assign MENU-ITEM m_retirar:SENSITIVE IN MENU mbMain = no.        
   end.        

   disable btQtde           with frame f-cad.
   assign MENU-ITEM m_quantidade:SENSITIVE IN MENU mbMain = no.
   disable bt-vinc          with frame f-cad.
   assign MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = no.
   disable bt-cria-prev     with frame f-cad.
   assign MENU-ITEM m_cria_previso:SENSITIVE IN MENU mbMain = no.

   if v-frame2 = 1 then do:
      find first tt-previsoes where
                 tt-previsoes.cod-itiner >= v-cod-itinerario-i and
                 tt-previsoes.cod-itiner <= v-cod-itinerario-f no-error.
      if avail tt-previsoes then
          apply "mouse-select-click" to browse brprev .
   end.
   else do:
      find first tt-embarques where
                 tt-embarques.cod-itiner >= v-cod-itinerario-i and
                 tt-embarques.cod-itiner <= v-cod-itinerario-f no-error.
      if avail tt-embarques then
         apply "mouse-select-click" to browse bremb .
   end.        
   run Pi-OpenBrSon2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Arquivo */
DO:
  /*run pi-disable-menu.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  APPLY "CHOOSE":U TO btExit IN FRAME F-CAD.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Acompanhamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Acompanhamento w-livre
ON CHOOSE OF MENU-ITEM m_Acompanhamento /* Acompanhamento */
DO:
  APPLY "CHOOSE":U TO BT-ACOMPANHA IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ajuda w-livre
ON MENU-DROP OF MENU m_Ajuda /* Ajuda */
DO:
  /*{include/ajuda.i}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_A_Vincular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_A_Vincular w-livre
ON CHOOSE OF MENU-ITEM m_A_Vincular /* A Vincular */
DO:
  APPLY "CHOOSE":U TO BT-VINC IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cria_Previso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cria_Previso w-livre
ON CHOOSE OF MENU-ITEM m_Cria_Previso /* Cria Previs∆o */
DO:
  APPLY "CHOOSE":U TO BT-CRIA-PREV IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EmbarquePreviso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EmbarquePreviso w-livre
ON CHOOSE OF MENU-ITEM m_EmbarquePreviso /* Embarque/Previs∆o */
DO:
  APPLY "CHOOSE":U TO BT-EMP-PREV IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Embarques
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Embarques w-livre
ON CHOOSE OF MENU-ITEM m_Embarques /* Embarques */
DO:
  APPLY "CHOOSE":U TO IM-EMB IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Previses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Previses w-livre
ON CHOOSE OF MENU-ITEM m_Previses /* Previs‰es */
DO:
  APPLY "CHOOSE":U TO IM-PREV IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Quantidade w-livre
ON CHOOSE OF MENU-ITEM m_Quantidade /* Quantidade */
DO:
  APPLY "CHOOSE":U TO BTQTDE IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Retirar w-livre
ON CHOOSE OF MENU-ITEM m_Retirar /* Retirar */
DO:
  APPLY "CHOOSE":U TO BT-RETIRAR IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Seleo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Seleo w-livre
ON CHOOSE OF MENU-ITEM m_Seleo /* Seleá∆o */
DO:
  APPLY "CHOOSE":U TO BT-SEL IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Vinculadas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Vinculadas w-livre
ON CHOOSE OF MENU-ITEM m_Vinculadas /* Vinculadas */
DO:
  APPLY "CHOOSE":U TO IM-VINC IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Vincular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Vincular w-livre
ON CHOOSE OF MENU-ITEM m_Vincular /* Vincular */
DO:
  APPLY "CHOOSE":U TO IM-A-VINC IN FRAME F-CAD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME bremb
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineCodVeiculo w-livre 
PROCEDURE defineCodVeiculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pc-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM pl-mostra-placa AS LOG                     NO-UNDO.

    FOR FIRST eq-param-embarq FIELDS(idi-veic)
        WHERE eq-param-embarq.cod-estabel = pc-cod-estabel NO-LOCK: END.

    ASSIGN pl-mostra-placa =  AVAIL eq-param-embarq 
                              AND eq-param-embarq.idi-veic = 1.

    RETURN "OK":U.
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
  ENABLE BT-SEL btExit btHelp bt-retirar bt-vinc btQtde bt-emp-prev 
         bt-cria-prev bt-acompanha im-a-vinc im-emb im-prev im-vinc RECT-14 
         RECT-15 rt-button 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  ENABLE brson3 brson1 
      WITH FRAME favinc IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-favinc}
  ENABLE brson2 
      WITH FRAME fvinc IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-fvinc}
  ENABLE bremb 
      WITH FRAME femb IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-femb}
  ENABLE brprev 
      WITH FRAME fprev IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-fprev}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    def var v-estabelec     like param-estoq.estabel-pad.

    {include/win-size.i}
    IF NOT VALID-HANDLE(h-boin082) THEN
       RUN inbo/boin082.p PERSISTENT SET h-boin082.
    IF NOT VALID-HANDLE(h-bocx230) THEN 
       RUN cxbo/bocx230.p persistent set h-bocx230.
    IF NOT VALID-HANDLE(h-boin274) THEN
       RUN inbo/boin274.p      PERSISTENT SET h-boin274.
    IF NOT VALID-HANDLE(h-boin172) THEN
       RUN inbo/boin172.p      persistent set h-boin172.
    IF NOT VALID-HANDLE(h-bocx220) THEN 
       RUN cxbo/bocx220.p persistent set h-bocx220.        
    IF NOT VALID-HANDLE(h-bocx140) THEN 
       RUN cxbo/bocx140.p      persistent set h-bocx140.
    IF NOT VALID-HANDLE(h-bocx225a) THEN 
       RUN cxbo/bocx225a.p persistent set h-bocx225a.
    IF NOT VALID-HANDLE(h-boin356aa) THEN 
       RUN inbo/boin356aa.p persistent set h-boin356aa.    


    /*RUN inbo/boin356.p      persistent set h-boin356. */

    if not valid-handle(h-boin287) then
       RUN inbo/boin287.p      persistent set h-boin287.
    &if defined(bf-mat-comex) &then          
        run ReturnEstabPadr in h-boin287 ( output v-estabelec).
    &else
        run ReturnEstabPadr in h-boin287 ( output v-estabelec).    
    &endif.

    if not valid-handle(h-bocx250) then
        RUN cxbo/bocx250.p      persistent set h-bocx250.
    RUN findCodigo IN h-bocx250 (input  v-estabelec,
                                 output c-return).

    RUN retornarelaciona IN h-bocx250 (outPUT l-relaciona).   

    if l-relaciona = no then
    do:
       hide brson3 in frame favinc.
       view brson1 in frame favinc. 
       enable brson1 with frame favinc.
    end.
    else do:
       hide brson1 in frame favinc.
       view brson3 in frame favinc. 
       enable brson3 with frame favinc.
    end.

{utp/ut9000.i "IM0044" "2.00.00.036"}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx225) THEN DO:
       RUN cxbo/bocx225.p persistent set h-bocx225.
    END.

/*    IF NOT VALID-HANDLE(hShowMsg) THEN
 *        RUN utp/showmessage.w PERSISTENT SET hShowMsg.*/

    /* Busca idioma do usuario ********************************************/
    
    &IF '{&mgdis_version}' >= '2.06f' &THEN
        IF NOT VALID-HANDLE(h-bofn017) THEN
           RUN fnbo/bofn017.p persistent set h-bofn017.
        run goTokey in h-bofn017 (input v_cod_usuar_corren).
        IF RETURN-VALUE = "OK" THEN
            RUN getCharfield IN h-bofn017 (INPUT "cod_idiom_orig":U,
                                           OUTPUT c-idiom-usuar).
    &else
        IF NOT VALID-HANDLE(h-boun178) THEN
           RUN unbo/boun178.p persistent set h-boun178.
        run findSrmstr_id IN h-boun178 (input v_cod_usuar_corren,
                                        output c-return).
        IF c-return = "" THEN
            RUN getCharfield IN h-boun178 (INPUT "cod_idiom_orig":U,
                                           OUTPUT c-idiom-usuar).
    &endif
    
    RUN pi-recebe-idioma IN h-bocx225 (INPUT c-idiom-usuar).    

    run pi-cria-temp-tables.
    run pi-cria-tt-vinculadas.
    disable bt-emp-prev 
            bt-acompanha with frame f-cad.
    /*frank*/
    apply "choose":U to BT-SEL in frame f-cad.  /*executa o programa de parametros.*/

    assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = no.
    assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = no.            
    /* Code placed here will execute AFTER standard behavior.    */
    if can-find(first tt-embarques) then do:
       apply "mouse-select-click" to im-emb in frame f-cad. 
       im-emb:load-image("image/im-fldup").
       enable bt-emp-prev 
              bt-acompanha with frame f-cad.
       assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
       assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.               
    end.       
    else do:
        if can-find(first tt-previsoes) 
        then do:        
            apply "mouse-select-click" to im-prev in frame f-cad.           
            im-prev:load-image("image/im-fldup").
            enable bt-emp-prev 
                   bt-acompanha with frame f-cad.        
            assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
            assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.                   
        end.                   
    end.           
    if can-find(tt-ordens-embarque) 
    then do:
       apply "mouse-select-click" to im-vinc in frame f-cad.
       im-vinc:load-image("image/im-fldup").
    end.       
    else do:
        apply "mouse-select-click" to im-a-vinc in frame f-cad.
        im-a-vinc:load-image("image/im-fldup").    
    end.

    run pi-openqueries.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-acompanha w-livre 
PROCEDURE pi-bt-acompanha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-cod-emb-hist  AS CHAR NO-UNDO.
    DEFINE VARIABLE v-cod-est-hist  AS CHAR NO-UNDO.
    disable btexit 
            bt-acompanha 
            bt-emp-prev with frame f-cad.

    assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain           = no
           l-active                                             = no
           MENU-ITEM m_Acompanhamento:SENSITIVE IN MENU mbMain  = no
           MENU-ITEM m_EmbarquePreviso:SENSITIVE IN MENU mbMain = no
           l-acompanha                                          = yes.

    SESSION:SET-WAIT-STATE("general":U).

    if v-frame2      = 1 then
    do:
        ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.   
        find first tt-previsoes no-lock
             where tt-previsoes.embarque = v-embarque-imp no-error.
        if avail tt-previsoes then do:     
           run trazrowidhistemb in h-bocx230(input  tt-previsoes.cod-estabel,
                                             input  tt-previsoes.embarque,
                                             input  tt-previsoes.cod-itiner,
                                             output v-rowid).
        end.
    end.    
    SESSION:SET-WAIT-STATE("general":U).
    if v-frame2 = 2 then do:
        ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.   
        find first tt-embarques no-lock
             where tt-embarques.embarque = v-embarque-imp no-error. 
        if avail tt-embarques then do:         
           run trazrowidhistemb in h-bocx230(input  tt-embarques.cod-estabel,
                                             input  tt-embarques.embarque,
                                             input  tt-embarques.cod-itiner,
                                             output v-rowid).
        end.                                          
    end.    

    assign gr-historico-embarque = v-rowid.

    assign gl-im0044 = yes.
    run imp/im0055.w.
    assign v-rowid = gr-historico-embarque.

    if v-frame1 = 1 then do:  
         apply "MOUSE-SELECT-CLICK":U to im-a-vinc in frame f-cad.
    end.
    else do:
         apply "MOUSE-SELECT-CLICK":U to im-vinc   in frame f-cad.   
    end.
    SESSION:SET-WAIT-STATE("general":U).   
    run pi-cria-temp-tables.
    run pi-openqueries.
    SESSION:SET-WAIT-STATE("general":U).
    run Pi-OpenBrSon2.
    SESSION:SET-WAIT-STATE("general":U).  
    if v-frame2 = 1 then do:
        apply "MOUSE-SELECT-CLICK":U to im-prev   in frame f-cad.
        run trazembarque in h-bocx230 (input  v-rowid,
                                       output v-cod-emb-prev).
        find first tt-previsoes no-lock
             where tt-previsoes.embarque    = v-cod-embarque no-error.
        if avail tt-previsoes then
           REPOSITION brprev TO ROWID rowid(tt-previsoes).
    end.
    else do: 
        apply "MOUSE-SELECT-CLICK":U to im-emb    in frame f-cad.   
        run trazembarque in h-bocx230 (input  v-rowid,
                                       output v-cod-emb-prev).
        find first tt-embarques no-lock
             where tt-embarques.embarque    = v-cod-embarque no-error.
        if avail tt-embarques then
           REPOSITION bremb TO ROWID rowid(tt-embarques).
    end.

    if can-find(first tt-previsoes) or
       can-find(first tt-embarques) then
    do:
        enable bt-emp-prev 
               bt-acompanha with frame f-cad.
        assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
        assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.               
    end.
    assign l-acompanha                                         = no.
    run pi-habilita in this-procedure.         
    SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-cria-prev w-livre 
PROCEDURE pi-bt-cria-prev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   disable btexit 
           bt-cria-prev
           with frame f-cad.
   assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain        = no
          l-active                                          = no
          MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = no
          l-cria-emb                                        = yes.
   if l-relaciona = no then do:
        if brson1:NUM-SELECTED-ROWS in frame favinc = 0 
        then do: 
            im-a-vinc:load-image("image/im-fldup").
            RUN pi-validaSelecao.
            im-a-vinc:load-image("image/im-fldup").
            enable btexit 
                   bt-cria-prev
                   with frame f-cad.
            assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain        = yes
                   l-active                                          = yes
                   MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = yes.
            SESSION:SET-WAIT-STATE("":U).       
            return no-apply.
        end.
   end.
   else do:
        if brson3:NUM-SELECTED-ROWS in frame favinc = 0 
        then do: 
            im-a-vinc:load-image("image/im-fldup").
            RUN pi-validaSelecao.
            im-a-vinc:load-image("image/im-fldup").
            enable btexit 
                   bt-cria-prev
                   with frame f-cad.
            assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain        = yes
                   l-active                                          = yes
                   MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = yes.
            SESSION:SET-WAIT-STATE("":U).       
            return no-apply.
        end.
   end.         
   /* Inicio -- Projeto Internacional */
   {utp/ut-liter.i "Previs∆o_de_Embarque" *}
   RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                   INPUT 18951, 
                   INPUT RETURN-VALUE).
   if return-value = "yes" then
   DO:
      run pi-cria-previsao.
      SESSION:SET-WAIT-STATE("general":U).
      if v-new-embarque <> "" then do:
        if v-frame1 = 1 then 
           apply "MOUSE-SELECT-CLICK":U to im-a-vinc in frame f-cad.
        else 
           apply "MOUSE-SELECT-CLICK":U to im-vinc   in frame f-cad.   
        if v-frame2 = 1 then
           apply "MOUSE-SELECT-CLICK":U to im-prev   in frame f-cad.
        else 
           apply "MOUSE-SELECT-CLICK":U to im-emb    in frame f-cad.

        SESSION:SET-WAIT-STATE("general":U).   
        run pi-cria-tt-previsoes.
        SESSION:SET-WAIT-STATE("general":U).
        run pi-cria-tt-vincular.
        SESSION:SET-WAIT-STATE("general":U).
        if l-relaciona = no then do:
            {&OPEN-QUERY-brSon1}
        end.
        else do:
            {&OPEN-QUERY-brSon3}
        end.             
        SESSION:SET-WAIT-STATE("general":U).
        run pi-openqueries.
        SESSION:SET-WAIT-STATE("general":U).

        run trazembarque in h-bocx220 (input  r-novo-emb ,
                                       output v-cod-est-prev,
                                       output v-cod-emb-prev).

        {&OPEN-QUERY-brprev}
        find tt-previsoes
            where tt-previsoes.embarque     = v-cod-emb-prev no-error.
        if avail tt-previsoes then 
          REPOSITION brprev TO ROWID rowid(tt-previsoes).        
      end.
   END.
   Else do:
      if v-frame1 = 1 then do:
         apply "MOUSE-SELECT-CLICK":U to im-a-vinc in frame f-cad.
         SESSION:SET-WAIT-STATE("general":U).
      end.   
      else do:
         apply "MOUSE-SELECT-CLICK":U to im-vinc   in frame f-cad.   
         SESSION:SET-WAIT-STATE("general":U).
      end.         
      if v-frame2 = 1 then do:
         apply "MOUSE-SELECT-CLICK":U to im-prev   in frame f-cad.
         SESSION:SET-WAIT-STATE("general":U).
      end.   
      else do: 
         apply "MOUSE-SELECT-CLICK":U to im-emb    in frame f-cad.          
         SESSION:SET-WAIT-STATE("general":U).
      end.         
      enable btexit 
             bt-cria-prev with frame f-cad.
      assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain        = yes
             MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = yes
             l-active                                          = yes.
      SESSION:SET-WAIT-STATE("":U).             
      RETURN NO-APPLY.           
   END.
   enable bt-cria-prev with frame f-cad.
   assign MENU-ITEM m_Cria_Previso:SENSITIVE IN MENU mbMain = yes
          l-cria-emb                                        = no.
   assign l-vincular = no.           
   run pi-habilita in this-procedure.
   SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-emp-prev w-livre 
PROCEDURE pi-bt-emp-prev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      SESSION:SET-WAIT-STATE("general":U).
      disable btexit 
              bt-emp-prev 
              bt-acompanha 
              with frame f-cad.
      assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain = no
             l-active                                   = no
             MENU-ITEM m_EmbarquePreviso:SENSITIVE IN MENU mbMain = no
             MENU-ITEM m_Acompanhamento:SENSITIVE IN MENU mbMain  = no
             l-emp-prev                                           = yes.

      if v-frame2 = 1 then do:
         ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.
         find first tt-previsoes no-lock 
              where tt-previsoes.embarque = v-embarque-imp no-error.
         if avail tt-previsoes then do:
            run rowidembarque in h-bocx220 (input tt-previsoes.cod-estabel,
                                            input tt-previsoes.embarque,
                                            output v-rowid).
         end.                                            
      end.                                     
      if v-frame2 = 2 then do:
         ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.   
         find first tt-embarques no-lock 
              where tt-embarques.embarque = v-embarque-imp no-error.
         if avail tt-embarques then do:
            run rowidembarque in h-bocx220 (input tt-embarques.cod-estabel,
                                            input tt-embarques.embarque,
                                            output v-rowid).
         end.                                                                                 
      end.
      assign gr-embarque-imp = v-rowid.
      SESSION:SET-WAIT-STATE("general":U).
      run imp/im0045.w.
      SESSION:SET-WAIT-STATE("general":U).   
      for each tt-ordem-quant:
          delete tt-ordem-quant.
      end.
      run pi-cria-tt-vincular.
      run pi-cria-temp-tables.
      run pi-openqueries.
      SESSION:SET-WAIT-STATE("general":U).
      run Pi-OpenBrSon2.
      if v-frame1 = 1 
      then do:  
         apply "MOUSE-SELECT-CLICK":U to im-a-vinc in frame f-cad.
      end.
      else do:
         apply "MOUSE-SELECT-CLICK":U to im-vinc   in frame f-cad.   
      end.      
      SESSION:SET-WAIT-STATE("general":U).   
      if v-frame2 = 1 then do:
         apply "MOUSE-SELECT-CLICK":U to im-prev   in frame f-cad.
         run trazembarque in h-bocx220 (input  gr-embarque-imp ,
                                        output v-cod-estabel,
                                        output v-cod-embarque).
         find first tt-previsoes no-lock
              where tt-previsoes.embarque    = v-cod-embarque no-error.
         if avail tt-previsoes then
            REPOSITION brprev TO ROWID rowid(tt-previsoes).
      end.
      else do: 
         apply "MOUSE-SELECT-CLICK":U to im-emb    in frame f-cad.   
         run trazembarque in h-bocx220 (input  gr-embarque-imp ,
                                        output v-cod-estabel,
                                        output v-cod-embarque).
         find first tt-embarques no-lock
              where tt-embarques.embarque    = v-cod-embarque no-error.
         if avail tt-embarques then
            REPOSITION bremb TO ROWID rowid(tt-embarques).
      end.
      if can-find(first tt-previsoes) or
         can-find(first tt-embarques) then
      do:
          enable bt-emp-prev 
                 bt-acompanha with frame f-cad.
          assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
          assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.               
      end.
      assign l-emp-prev                                           = no.
      run pi-habilita in this-procedure.           
      SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-qtde w-livre 
PROCEDURE pi-bt-qtde :
def var de-quant-embarq like prazo-compra.quantidade    no-undo.

    def var v-retorno       as   char                       no-undo.
    def var v-rowid2        as   rowid                      no-undo.
    def var num-ord         like ordem-compra.numero-ordem  no-undo.
    def var num-par         like prazo-compra.parcela       no-undo.   
    def var d-entrega       as   date                       no-undo.
    def var dt-entrega      as   date                       no-undo.
    def var v-cod-estabel   as   char                       no-undo.
    def var de-quantid      like prazo-compra.quantidade    no-undo.
    def var v-num-ordem     like prazo-compra.numero-ordem  no-undo.

    assign i-cont = 0
           l-qtde = yes.

    for each RowErrors:
        delete RowErrors.
    end.

    if l-relaciona = no then do:

        assign num-ord = tt-ordem-compra.numero-ordem.
        find first tt-ordem-quant no-lock
             where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem  
             and   tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid no-error.

        if not avail tt-ordem-quant then leave.     

        IF v-frame2 = 1 THEN DO:
            IF AVAIL tt-previsoes THEN
                RUN validavinculacaoordens IN h-bocx225 (INPUT tt-previsoes.embarque,
                                                         INPUT tt-previsoes.cod-estabel,
                                                         INPUT tt-ordem-compra.numero-ordem,
                                                         INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                         OUTPUT TABLE RowErrors).
        END.
        ELSE DO:
            RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarques.embarque,
                                                     INPUT tt-embarques.cod-estabel,
                                                     INPUT tt-ordem-compra.numero-ordem,
                                                     INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                     OUTPUT TABLE RowErrors).

        END.

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:

                ASSIGN de-qt-do-forn = decimal(de-qt-do-forn:SCREEN-VALUE IN BROWSE brSon1).

                RUN imp/im0044aa.w (input tt-ordem-compra.numero-ordem,
                                    input tt-ordem-compra.it-codigo,
                                    input tt-ordem-quant.quantidade,
                                    INPUT de-qt-do-forn,
                                    input tt-ordem-quant.cod-fornec,
                                    input tt-ordem-quant.un-fornec,
                                    input tt-ordem-quant.un-nosso,
                                    output de-quant-embarq).

                im-a-vinc:load-image("image/im-fldup") in frame f-cad.
                if de-quant-embarq < tt-ordem-quant.quantidade and
                   de-quant-embarq > 0  then do:

                    assign  v-cod-estabel   = tt-ordem-compra.cod-estabel
                            v-qtde-emb      = de-quant-embarq
                            v-qtde-n-emb    = (tt-ordem-quant.quantidade - de-quant-embarq).

                    if v-frame2 = 1 then do:
                        run RetornaDataParcelaNaoEmbarcada in h-bocx225 (input  tt-previsoes.cod-estabel,
                                                                         input  tt-previsoes.embarque,
                                                                         input  tt-ordem-compra.numero-ordem,
                                                                         output dt-entrega).
                    end.
                    else
                        run RetornaDataParcelaNaoEmbarcada in h-bocx225 (input  tt-embarques.cod-estabel,
                                                                         input  tt-embarques.embarque,
                                                                         input  tt-ordem-compra.numero-ordem,
                                                                         output dt-entrega).
                    ASSIGN v-nova-entrega = ?.

                    RUN imp/im9997.p(INPUT  v-cod-estabel ,
                             INPUT  tt-ordem-quant.quantidade    , 
                             INPUT  v-qtde-n-emb  ,
                             INPUT  dt-entrega,
                             OUTPUT v-nova-entrega,
                             OUTPUT v-retorno).

                    if v-retorno = "NOK" or v-nova-entrega = ? then
                        assign de-quant-embarq = 0.
                    else do:

                         run RetornaDataEntregaNovaParcela in h-boin356aa (input  v-cod-estabel,
                                                                           input  tt-ordem-quant.numero-ordem,
                                                                           input  v-nova-entrega,
                                                                           output d-entrega).
                         if d-entrega = ? then.
                         else assign v-nova-entrega = d-entrega.
                         assign l-bt-qtde = yes
                                v-nova-parcela = 0.
                         assign de-quantid  = tt-ordem-quant.quantidade
                                v-num-ordem = tt-ordem-quant.numero-ordem.

                         if v-frame2 = 1 THEN do:

                            assign r-prev-emb  = rowid(tt-previsoes).
                            run pi-vincular-1.
                            if not can-find(first RowErrors) then do:

                                run cria-nova-parcela-by-ordem-2 in h-boin356aa (input v-cod-estabel  ,
                                                                                 input v-num-ordem    ,
                                                                                 input de-quantid     ,
                                                                                 input v-embarque     ,
                                                                                 input v-qtde-emb     ,
                                                                                 input v-qtde-n-emb   ,
                                                                                 input v-nova-entrega ,
                                                                                 output v-nova-parcela).                    
                            end.
                            find first tt-previsoes no-lock 
                                 where tt-previsoes.cod-estabel = v-cod-estabel 
                                 and   tt-previsoes.embarque    =  v-embarque  
                                 no-error.
                            if avail tt-previsoes then     
                                REPOSITION brprev TO ROWID rowid(tt-previsoes).
                         end.   
                         else do:
                            assign r-prev-emb  = rowid(tt-embarques).
                            run pi-vincular-2.
                            if not can-find(first RowErrors) then
                                run cria-nova-parcela-by-ordem-2 in h-boin356aa (input v-cod-estabel,
                                                                               input v-num-ordem,
                                                                               input de-quantid,
                                                                               input tt-embarques.embarque,
                                                                               input v-qtde-emb                 ,
                                                                               input v-qtde-n-emb               ,
                                                                               input v-nova-entrega             ,
                                                                               output v-nova-parcela            ).                    
                            find first tt-embarques no-lock
                                 where tt-embarques.cod-estabel = v-cod-estabel 
                                 and   tt-embarques.embarque    =  v-embarque  
                                 no-error.
                            if avail tt-embarques then      
                               REPOSITION bremb TO ROWID rowid(tt-embarques).
                         end.     

                         /*Chamada EPC.*/
                         if not can-find(first RowErrors) THEN DO:
                            if search("imp/im0044a.p") <> ? or
                               search("imp/im0044a.r") <> ? then do:
                                FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem
                                     WHERE prazo-compra.numero-ordem = v-num-ordem
                                     AND   prazo-compra.parcela      = v-nova-parcela NO-ERROR.
                                if avail prazo-compra then      
                                   run imp/im0044a.p (1, rowid(prazo-compra)).
                                if  return-value = "NOK":U then
                                    return "ERROR".
                            end.
                         END.

                    end.                
                end.        
                run pi-cria-tt-vincular.
                {&OPEN-QUERY-brson1}
                find first tt-ordem-compra 
                     where tt-ordem-compra.numero-ordem = num-ord no-error.
                if avail tt-ordem-compra then     
                   REPOSITION brson1 TO ROWID rowid(tt-ordem-compra).
                brson1:select-row(1) in frame favinc.    

        END.
        ELSE DO:
               IF NOT VALID-HANDLE(hShowMsg) THEN
                  RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
               ELSE
                  DELETE PROCEDURE hShowMsg.
               RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

               for each RowErrors:
                   delete RowErrors.
               end.                

               UNDO, RETURN NO-APPLY.
        END.
    end.
    else do:

        brson3:fetch-selected-row(1).

        assign num-ord = tt-prazo-compra.numero-ordem
               num-par = tt-prazo-compra.parcela.

        IF v-frame2 = 1 THEN DO:
            RUN validavinculacaoordens IN h-bocx225 (INPUT tt-previsoes.embarque,    
                                                     INPUT tt-previsoes.cod-estabel, 
                                                     INPUT tt-prazo-compra.numero-ordem,
                                                     INPUT tt-prazo-compra.parcela, 
                                                     OUTPUT TABLE RowErrors).
        END.
        ELSE DO:
            RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarques.embarque,    
                                                     INPUT tt-embarques.cod-estabel, 
                                                     INPUT tt-prazo-compra.numero-ordem,
                                                     INPUT tt-prazo-compra.parcela, 
                                                     OUTPUT TABLE RowErrors).
        END.

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:

                run pi-determina-fornec in this-procedure (input tt-prazo-compra.numero-ordem,
                                                           output i-return,
                                                           output c-return).

                RUN imp/im0044aa.w (input tt-prazo-compra.numero-ordem,
                                    input tt-prazo-compra.it-codigo,
                                    input tt-prazo-compra.quant-saldo, /*tt-prazo-compra.quantidade*/
                                    input tt-prazo-compra.qtd-do-forn,
                                    input i-return, /* C¢digo do Fornecedor */
                                    input c-return, /* Unidade do item no Fornecedor */
                                    input tt-prazo-compra.un,
                                    output de-quant-embarq).

                im-a-vinc:load-image("image/im-fldup") .
                if de-quant-embarq < tt-prazo-compra.quant-saldo /*tt-prazo-compra.quantidade*/ and
                   de-quant-embarq > 0  then do:

                    run retorna-estab-ordem in h-boin356aa (input  tt-prazo-compra.numero-ordem,
                                                               output v-cod-estabel).
                    if v-cod-estabel = "" then leave.

                    assign  v-qtde-emb      = de-quant-embarq
                            v-qtde-n-emb    = (tt-prazo-compra.quant-saldo /*tt-prazo-compra.quantidade*/ - de-quant-embarq).

                    RUN imp/im9997.p(INPUT  v-cod-estabel ,
                                     INPUT  tt-prazo-compra.quant-saldo , /*tt-prazo-compra.quantidade*/
                                     INPUT  v-qtde-n-emb  ,
                                     INPUT  tt-prazo-compra.data-entrega,
                                     OUTPUT v-nova-entrega,
                                     OUTPUT v-retorno).

                    if v-retorno = "NOK" or v-nova-entrega = ?
                    then 
                        assign de-quant-embarq = 0.
                    else do:

                         run RetornaDataEntregaNovaParcela in h-boin356aa (input  v-cod-estabel,
                                                                           input  tt-prazo-compra.numero-ordem,
                                                                           input  v-nova-entrega,
                                                                           output d-entrega).
                         if d-entrega = ? then.
                         else assign v-nova-entrega = d-entrega.

                         if v-frame2 = 1 then do:
                            assign r-prev-emb  = rowid(tt-previsoes).

                            run pi-vincular-1.
                            find first tt-previsoes no-lock 
                                 where tt-previsoes.cod-estabel = v-cod-estabel 
                                 and   tt-previsoes.embarque    =  v-embarque  
                                 no-error.
                            if avail tt-previsoes then     
                               REPOSITION brprev TO ROWID rowid(tt-previsoes).
                         end.   
                         else do:
                            assign r-prev-emb  = rowid(tt-embarques).

                            run pi-vincular-2.
                            find first tt-embarques no-lock
                                 where tt-embarques.cod-estabel = v-cod-estabel 
                                 and   tt-embarques.embarque    =  v-embarque  
                                 no-error.
                            if avail tt-embarques then      
                               REPOSITION bremb TO ROWID rowid(tt-embarques).
                         end.                 
                         if not can-find(first RowErrors) then DO:
                             assign tt-prazo-compra.quantidade = v-qtde-emb.
                             if v-frame2 = 1 then 
                                run cria-nova-parcela in h-boin356aa (input  v-cod-estabel,
                                                                      input  tt-prazo-compra.numero-ordem,
                                                                      input  tt-prazo-compra.parcela     ,
                                                                      input  v-embarque                  ,
                                                                      input  v-qtde-emb                  ,
                                                                      input  v-qtde-n-emb                ,
                                                                      input  v-nova-entrega              ,
                                                                      input "parcela"                    ).
                            else                                                                    
                                run cria-nova-parcela in h-boin356aa (input v-cod-estabel,
                                                                      input tt-prazo-compra.numero-ordem,
                                                                      input tt-prazo-compra.parcela     ,
                                                                      input v-embarque                  ,
                                                                      input v-qtde-emb                  ,
                                                                      input v-qtde-n-emb                ,
                                                                      input v-nova-entrega              ,
                                                                      input "parcela"                   ).

                            /*Chamada EPC, em coment†rio temporariamente.*/
                            if search("imp/im0044a.p") <> ? or
                               search("imp/im0044a.r") <> ? then do:

                                FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem
                                     WHERE prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                                     AND   prazo-compra.parcela      = tt-prazo-compra.parcela NO-ERROR.
                                if avail prazo-compra then      
                                   run imp/im0044a.p (1, rowid(prazo-compra)).
                                if  return-value = "NOK":U then
                                    return "ERROR".
                            end.

                        END. 
                        assign l-bt-qtde = yes.
                    end.                
                end.

                run pi-cria-tt-vincular.
                {&OPEN-QUERY-brson3}
                find last tt-prazo-compra 
                     where tt-prazo-compra.numero-ordem = num-ord no-error.
                if avail tt-prazo-compra then     
                   REPOSITION brson3 TO ROWID rowid(tt-prazo-compra).
                brson3:select-row(1) in frame favinc.    
        END.
        ELSE DO:
               IF NOT VALID-HANDLE(hShowMsg) THEN
                  RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
               ELSE
                  DELETE PROCEDURE hShowMsg.
               RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

               for each RowErrors:
                   delete RowErrors.
               end.                

               UNDO, RETURN NO-APPLY.
        END.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-retirar w-livre 
PROCEDURE pi-bt-retirar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>

  Notes:       
------------------------------------------------------------------------------*/
def var l-contabilizado as logical initial yes no-undo.
DEF VAR l-desvincula    AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR l-tax-siscomex  AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR c-tax-siscomex  AS CHAR                NO-UNDO.
def var i as int no-undo.

      if v-frame2 = 1 THEN do:
        IF  NOT VALID-HANDLE(h-bocx250) THEN
            RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
        RUN findCodigo IN h-bocx250 (INPUT tt-previsoes.cod-estabel, OUTPUT c-return).
        
        
        RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex", OUTPUT l-tax-siscomex).
        
        IF  l-tax-siscomex THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 33880, INPUT "").
            IF  RETURN-VALUE <> "yes" THEN DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
        
        assign v-cod-embarque = tt-previsoes.embarque.

        run pi-valida-embarque-contabilizado(input tt-previsoes.cod-estabel,
                                             input tt-previsoes.embarque,   
                                             output l-contabilizado). 
        if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
             assign l-contabilizado = yes.
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.
        end.

        RUN pi-valida-desvincula-ordem (INPUT tt-previsoes.cod-estabel, 
                                        INPUT tt-previsoes.embarque,    
                                        OUTPUT l-desvincula).

        IF NOT l-desvincula THEN DO:
            assign l-desvincula = yes.
            SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
            return no-apply.
        END.

        for each tt-ordem-embarque:
            assign i = i + 1.
        end.

        assign cCodEstabel = tt-previsoes.cod-estabel  
               cEmbarque   = tt-previsoes.embarque.

        run pi-retirar-1.

        /* Licenciamento Importacao */
        
        run  piNecessitaLiEmbarque in h-bocx225 (input cCodEstabel,       
                                                 input cEmbarque,         
                                                 output table rowErrors). 
        if  can-find (first rowErrors) then do:

            if  not valid-handle(hShowMsg) then
                run utp/ut-show-msgs.w persistent set hShowMsg.

            run showMessages in hShowMsg (input table RowErrors).
        end.
        

        {&OPEN-QUERY-brprev}
        find first tt-previsoes no-lock 
             where tt-previsoes.embarque = v-cod-embarque no-error.
        if avail tt-previsoes then     
           REPOSITION brprev TO ROWID rowid(tt-previsoes).
        apply "MOUSE-SELECT-CLICK":U to brprev in frame fprev.
      end.    
      else do:
        IF  NOT VALID-HANDLE(h-bocx250) THEN
            RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
        RUN findCodigo IN h-bocx250 (INPUT tt-embarques.cod-estabel, OUTPUT c-return).
        
        
        RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex", OUTPUT l-tax-siscomex).
        
        IF  l-tax-siscomex THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 33880, INPUT "").
            IF  RETURN-VALUE <> "yes" THEN DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
        
        assign v-cod-embarque = tt-embarques.embarque.

        run pi-valida-embarque-contabilizado(input tt-embarques.cod-estabel,
                                             input tt-embarques.embarque,
                                             output l-contabilizado). 
        if l-contabilizado = no then do: /*Porque o usuario responde que nao era para continuar, pois o */
             assign l-contabilizado = yes.
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.
        end.

        RUN pi-valida-desvincula-ordem (INPUT tt-embarques.cod-estabel,  
                                        INPUT tt-embarques.embarque,     
                                        OUTPUT l-desvincula).

        IF NOT l-desvincula THEN DO:
            assign l-desvincula = yes.
            SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
            return no-apply.
        END.

        assign cCodEstabel = tt-embarques.cod-estabel
               cEmbarque   = tt-embarques.embarque.

        run pi-retirar-2.

        /* Licenciamento Importacao */
        run  piNecessitaLiEmbarque in h-bocx225 (input cCodEstabel,       
                                                 input cEmbarque,         
                                                 output table rowErrors). 
        if  can-find (first rowErrors) then do:

            if  not valid-handle(hShowMsg) then
                run utp/ut-show-msgs.w persistent set hShowMsg.

            run showMessages in hShowMsg (input table RowErrors).
        end.

        {&OPEN-QUERY-bremb}
        find first tt-embarques no-lock
             where tt-embarques.embarque = v-cod-embarque no-error.
        if avail tt-embarques then      
           REPOSITION bremb TO ROWID rowid(tt-embarques).
        apply "MOUSE-SELECT-CLICK":U to bremb in frame femb.
        apply "mouse-select-click" to im-vinc IN FRAME f-cad.
      end. 
      
      SESSION:SET-WAIT-STATE("general":U).
      assign l-vincular = no.
      SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-sel w-livre 
PROCEDURE pi-bt-sel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if v-passou = no then 
      assign v-cod-estab-f        = "ZZZ"
             v-cod-estab-i        = ""
             v-cod-proces-imp-f   = "ZZZZZZZZZZZZ"
             v-cod-proces-imp-i   = ""
             v-cod-fornec-f       = 999999999
             v-cod-fornec-i       = 0
             v-num-ped-compra-f   = 99999999
             v-num-ped-compra-i   = 0
             v-num-ordem-compra-f = 99999999
             v-num-ordem-compra-i = 0
             v-cod-incoterm-f     = "ZZZ"
             v-cod-incoterm-i     = ""
             v-cod-item-f         = "ZZZZZZZZZZZZZZZZ"
             v-cod-item-i         = ""
             v-dat-embarq-f       = 12/31/9999
             v-dat-embarq-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
             v-cod-itinerario-i   = 0
             v-cod-itinerario-f   = 99999
             v-rs-classif         = 1
             v-rs-sit-emb         = 1
             v-cod-placa-i        = ""
             v-cod-placa-f        = "ZZZZZZZZZZZZ"
             v-dat-entreg-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
             v-dat-entreg-f       = 12/31/9999
             v-passou             = yes.

   assign l-cria = no.
   
   run imp/im0044pr.w( input-output v-cod-estab-f        ,
                       input-output v-cod-estab-i        ,
                       input-output v-cod-proces-imp-f   ,
                       input-output v-cod-proces-imp-i   ,
                       input-output v-cod-fornec-f       ,
                       input-output v-cod-fornec-i       ,
                       input-output v-num-ped-compra-f   ,
                       input-output v-num-ped-compra-i   ,
                       input-output v-num-ordem-compra-f ,
                       input-output v-num-ordem-compra-i ,
                       input-output v-cod-incoterm-f     ,
                       input-output v-cod-incoterm-i     ,
                       input-output v-cod-item-f         ,
                       input-output v-cod-item-i         ,
                       input-output v-dat-embarq-f       ,
                       input-output v-dat-embarq-i       ,
                       input-output v-cod-itinerario-i   ,
                       input-output v-cod-itinerario-f   ,
                       input-output v-rs-classif         ,
                       input-output v-rs-sit-emb         ,
                       input-output v-cod-placa-f        ,
                       input-output v-cod-placa-i        ,
                       input-output v-dat-entreg-f       ,
                       input-output v-dat-entreg-i       ,
                       output l-cria).           

   if l-cria = yes then do:
      for each tt-ordem-embarque:
          delete tt-ordem-embarque.
      end.
      run pi-cria-temp-tables.                        
      run pi-openqueries.

      if v-frame2 = 1 then do:

         find first tt-previsoes where
                    tt-previsoes.cod-itiner >= v-cod-itinerario-i and
                    tt-previsoes.cod-itiner <= v-cod-itinerario-f no-error.

         if avail tt-previsoes then do:

            apply "mouse-select-click" to browse brprev .

         end.

      end.
      
      if v-frame2 = 1 then do:

         apply "MOUSE-SELECT-CLICK":U to im-prev   in frame f-cad.

      end.
      else do: 

         apply "MOUSE-SELECT-CLICK":U to im-emb    in frame f-cad.

      end.

      if v-frame1 = 1 then do:

          assign l-vincular = no.

         apply "MOUSE-SELECT-CLICK":U to im-a-vinc in frame f-cad.

      end.           
      else do:

         apply "MOUSE-SELECT-CLICK":U to im-vinc   in frame f-cad.

      end.
   end.
   ELSE
       assign v-cod-estab-f        = ""
              v-cod-estab-i        = ""
              v-cod-proces-imp-f   = ""
              v-cod-proces-imp-i   = ""
              v-cod-fornec-f       = 0
              v-cod-fornec-i       = 0
              v-num-ped-compra-f   = 0
              v-num-ped-compra-i   = 0
              v-num-ordem-compra-f = 0
              v-num-ordem-compra-i = 0
              v-cod-incoterm-f     = ""
              v-cod-incoterm-i     = ""
              v-cod-item-f         = ""
              v-cod-item-i         = ""
              v-dat-embarq-f       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-dat-embarq-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-cod-itinerario-i   = 0
              v-cod-itinerario-f   = 0
              v-rs-classif         = 1
              v-rs-sit-emb         = 1
              v-cod-placa-i        = ""
              v-cod-placa-f        = ""
              v-dat-entreg-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-dat-entreg-f       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-passou             = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-previsao w-livre 
PROCEDURE pi-cria-previsao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var l-error  as logical no-undo.
    def var l-create as logical no-undo.

    if l-relaciona = no then do:
        if brson1:num-selected-rows in frame favinc = 0 then leave.
    end.        
    else do:
        if brson3:num-selected-rows in frame favinc = 0 then leave.            
    end.

    ASSIGN gr-ccod-estabel = v-cod-estabel.

    run imp/im0044c.w(output  v-new-embarque).

    for each tt-new-embarque-imp:
        delete tt-new-embarque-imp.
    end.
    for each tt-bo-erros:
        delete tt-bo-erros.
    end.
    if v-new-embarque <> "" THEN do:
        if l-relaciona = no THEN do:
            assign i-cont = 0.

            if not can-find(first tt-bo-erros) 
            then do:
                repeat:
                    assign  i-cont = i-cont + 1.

                    if i-cont >  brson1:num-selected-rows then leave.
                    brson1:fetch-selected-row(i-cont).

                    run trazrowidordemcompra IN h-bocx225a (INPUT  tt-ordem-compra.numero-ordem,
                                                            OUTPUT v-rowid).
                    assign l-error = no.

                    run crianovoembarque IN h-bocx220 (INPUT  v-new-embarque,
                                                       INPUT  v-rowid,
                                                       OUTPUT TABLE tt-new-embarque-imp,
                                                       OUTPUT TABLE tt-bo-erro,
                                                       OUTPUT r-rowid).                                                        

                    for each tt-bo-erro exclusive-lock:
                        assign l-error = yes.
                        create tt-bo-erros.
                        buffer-copy tt-bo-erro to tt-bo-erros.
                        delete tt-bo-erro.
                    end.

                    find first tt-ordem-quant no-lock
                         where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem no-error.

                    if not avail tt-ordem-quant then leave.

                    if l-error = no then
                    do:
                        RUN setCreatehist IN h-bocx225.

                        RUN createOrdensEmbarque IN h-bocx225 (INPUT r-rowid,
                                                               INPUT tt-ordem-compra.numero-ordem,
                                                               INPUT tt-ordem-quant.quantidade,
                                                               OUTPUT TABLE tt-bo-erro).   
                        if can-find(first tt-bo-erro) 
                        then assign l-create = no.
                        else assign l-create = yes.

                        for each tt-bo-erro exclusive-lock:
                            create tt-bo-erros.
                            buffer-copy tt-bo-erro to tt-bo-erros.
                            delete tt-bo-erro.
                        end.
                        assign r-novo-emb = r-rowid.
                    end.                    
                end.
            end.
        end.
        else do:
            assign i-cont = 0.

            if not can-find(first tt-bo-erros) 
            then do:
                repeat:
                    assign  i-cont = i-cont + 1.

                    if i-cont >  brson3:num-selected-rows then leave.

                    brson3:fetch-selected-row(i-cont).

                    run trazrowidordemcompra IN h-bocx225a (INPUT  tt-prazo-compra.numero-ordem,
                                                            OUTPUT v-rowid).
                    assign l-error = no.

                    run crianovoembarque IN h-bocx220 (INPUT  v-new-embarque,
                                                       INPUT  v-rowid,
                                                       OUTPUT TABLE tt-new-embarque-imp,
                                                       OUTPUT TABLE tt-bo-erro,
                                                       OUTPUT r-rowid).                                                        

                    for each tt-bo-erro exclusive-lock:
                        assign l-error = yes.
                        create tt-bo-erros.
                        buffer-copy tt-bo-erro to tt-bo-erros.
                        delete tt-bo-erro.
                    end.

                    if l-error = no then
                    do:
                        RUN setCreatehist IN h-bocx225.

                        RUN createOrdensEmbarquebyparcela IN h-bocx225 (INPUT r-rowid,
                                                                        INPUT tt-prazo-compra.numero-ordem,
                                                                        INPUT tt-prazo-compra.parcela,
                                                                        INPUT tt-prazo-compra.quantidade,
                                                                        OUTPUT TABLE tt-bo-erro).                                                               
                        if can-find(first tt-bo-erro) 
                        then assign l-create = no.
                        else assign l-create = yes.

                        for each tt-bo-erro exclusive-lock:
                            create tt-bo-erros.
                            buffer-copy tt-bo-erro to tt-bo-erros.
                            delete tt-bo-erro.
                        end.
                        assign r-novo-emb = r-rowid.
                    end.                    
                end.
            end.        
        end.                        
        if l-create = no 
        then do:
            run validateDelete IN h-bocx220 (input-output r-rowid,
                                             OUTPUT TABLE tt-bo-erro).
            for each tt-bo-erro exclusive-lock:
                create tt-bo-erros.
                buffer-copy tt-bo-erro to tt-bo-erros.
                delete tt-bo-erro.
            end.                                            
        end.

        if can-find(first tt-bo-erros) 
        then do:
            IF VALID-HANDLE(hShowMsg) THEN
               DELETE PROCEDURE hShowMsg.
            IF NOT VALID-HANDLE(hShowMsg) THEN
                   RUN utp/showmessage.w PERSISTENT SET hShowMsg.        
            RUN setModal IN hShowMsg (INPUT NO) NO-ERROR.
            RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erros).        
        end.        
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-temp-tables w-livre 
PROCEDURE pi-cria-temp-tables :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def var h-acomp       as handle    no-undo.
    def var c-acompanha   as char      no-undo.
    assign  c-acompanha = "".

    run pi-cria-tt-embarque.
    run pi-cria-tt-previsoes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-embarque w-livre 
PROCEDURE pi-cria-tt-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-embarques:
        delete tt-embarques.
    end.
    run pi-cria-tt-embarques in h-bocx230 (input v-cod-estab-i        ,  
                                           input v-cod-estab-f        ,  
                                           input v-cod-proces-imp-i   ,  
                                           input v-cod-proces-imp-f   ,  
                                           input v-cod-fornec-i       ,  
                                           input v-cod-fornec-f       ,  
                                           input v-num-ped-compra-i   ,  
                                           input v-num-ped-compra-f   ,  
                                           input v-num-ordem-compra-i ,  
                                           input v-num-ordem-compra-f ,  
                                           input v-cod-incoterm-i     ,  
                                           input v-cod-incoterm-f     ,  
                                           input v-cod-item-i         ,  
                                           input v-cod-item-f         ,  
                                           input v-dat-embarq-i       ,  
                                           input v-dat-embarq-f       ,  
                                           input v-cod-itinerario-i   ,  
                                           input v-cod-itinerario-f   ,  
                                           input v-rs-sit-emb         ,  
                                           output table tt-embarques).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-previsoes w-livre 
PROCEDURE pi-cria-tt-previsoes :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-previsoes:
        delete tt-previsoes.
    end.

    run pi-cria-tt-previsoes in h-bocx230 (input v-cod-estab-i        ,
                                           input v-cod-estab-f        ,
                                           input v-cod-proces-imp-i   ,
                                           input v-cod-proces-imp-f   ,
                                           input v-cod-fornec-i       ,
                                           input v-cod-fornec-f       ,
                                           input v-num-ped-compra-i   ,
                                           input v-num-ped-compra-f   ,
                                           input v-num-ordem-compra-i ,
                                           input v-num-ordem-compra-f ,
                                           input v-cod-incoterm-i     ,
                                           input v-cod-incoterm-f     ,
                                           input v-cod-item-i         ,
                                           input v-cod-item-f         ,
                                           input v-dat-embarq-i       ,
                                           input v-dat-embarq-f       ,
                                           input v-cod-itinerario-i   ,
                                           input v-cod-itinerario-f   ,
                                           input v-rs-sit-emb         ,
                                           output table tt-previsoes).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-vinculadas w-livre 
PROCEDURE pi-cria-tt-vinculadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each tt-ordens-embarque:
        delete tt-ordens-embarque.
    end.

    for each tt-ordem-embarque:
        delete tt-ordem-embarque.
    end.

    run setConstraint4 in h-bocx225 (input v-embarque,
                                     input v-estabelec).
    run OpenQuery in h-bocx225 (input 4).

    run findFirst in h-bocx225.
    run serverSendRows in h-bocx225 (input ?,
                                     input ?,
                                     input no,
                                     input ?,
                                     output rowsreturn,
                                     output table tt-ordens-embarque).

    FOR EACH  tt-ordens-embarque EXCLUSIVE-LOCK 
        WHERE tt-ordens-embarque.cod-estabel = v-estabelec
        AND   tt-ordens-embarque.embarque    = v-embarque:

        assign v-num-ordem  = tt-ordens-embarque.numero-ordem
               v-parc       = tt-ordens-embarque.parcela.
        run DataEntrega in h-bocx225 (input  v-num-ordem,
                                      input  v-parc,
                                      output v-data).
        assign tt-ordens-embarque.data-1 = v-data.
    end.

    for each  tt-ordem-embarque EXCLUSIVE-LOCK:
        delete tt-ordem-embarque.
    end.

    for each tt-ordens-embarque EXCLUSIVE-LOCK 
        WHERE tt-ordens-embarque.cod-estabel = v-estabelec
        AND   tt-ordens-embarque.embarque    = v-embarque:
        create tt-ordem-embarque.
        buffer-copy tt-ordens-embarque to tt-ordem-embarque.
        assign tt-ordem-embarque.it-codigo = fnItem(input tt-ordens-embarque.numero-ordem)
               tt-ordem-embarque.r-rowid   = tt-ordens-embarque.r-rowid. 
    end.

    run Pi-OpenBrSon2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-vincular w-livre 
PROCEDURE pi-cria-tt-vincular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF l-relaciona = NO THEN DO:

        EMPTY TEMP-TABLE tt-ordem-compra.
        
        RUN criaTTordem-compra IN h-bocx225a (INPUT v-cod-estab-i        ,  
                                              INPUT v-cod-estab-f        ,  
                                              INPUT v-cod-proces-imp-i   ,  
                                              INPUT v-cod-proces-imp-f   ,  
                                              INPUT v-cod-fornec-i       ,  
                                              INPUT v-cod-fornec-f       ,  
                                              INPUT v-num-ped-compra-i   ,  
                                              INPUT v-num-ped-compra-f   ,  
                                              INPUT v-num-ordem-compra-i ,  
                                              INPUT v-num-ordem-compra-f ,  
                                              INPUT v-cod-incoterm-i     ,  
                                              INPUT v-cod-incoterm-f     ,  
                                              INPUT v-cod-item-i         ,  
                                              INPUT v-cod-item-f         ,  
                                              OUTPUT TABLE tt-ordem-compra).
    END.
    ELSE DO:
        
        EMPTY TEMP-TABLE tt-prazo-compra.

        RUN criaTTprazo-compra IN h-boin356aa (INPUT v-cod-estab-i        ,
                                               INPUT v-cod-estab-f        ,
                                               INPUT v-cod-proces-imp-i   ,
                                               INPUT v-cod-proces-imp-f   ,
                                               INPUT v-cod-fornec-i       ,
                                               INPUT v-cod-fornec-f       ,
                                               INPUT v-num-ped-compra-i   ,
                                               INPUT v-num-ped-compra-f   ,
                                               INPUT v-num-ordem-compra-i ,
                                               INPUT v-num-ordem-compra-f ,
                                               INPUT v-cod-incoterm-i     ,
                                               INPUT v-cod-incoterm-f     ,
                                               INPUT v-cod-item-i         ,
                                               INPUT v-cod-item-f         ,
                                               OUTPUT TABLE tt-prazo-compra).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-determina-fornec w-livre 
PROCEDURE pi-determina-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter pnum-ordem like ordem-compra.numero-ordem no-undo.
def output parameter pcod-fornec like emitente.cod-emitente no-undo.
def output parameter pun-fornec like item.un no-undo.


run findCotacaoAprovada in h-boin082 (input pnum-ordem,
                                      output c-return).
if c-return = "" then do:
    run getIntfield in h-boin082(input "cod-emitente":U,output pcod-fornec).
    run getCharfield in h-boin082(input "un":U, output pun-fornec).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita w-livre 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if l-sel        = no and
       l-emp-prev   = no and
       l-acompanha  = no and
       l-qtde       = no and
       l-cria-emb   = no 
    then do:   
        enable btexit with frame f-cad.

        assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain       = yes
               l-active                                         = yes.
    end.               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-OpenBrSon2 w-livre 
PROCEDURE Pi-OpenBrSon2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  case v-rs-classif:
      when 1 then
           OPEN QUERY brSon2 FOR EACH  tt-ordem-embarque NO-LOCK
                                 by tt-ordem-embarque.numero-ordem
                                 by tt-ordem-embarque.parcela
                                 by tt-ordem-embarque.it-codigo
                                 by tt-ordem-embarque.data-1.
      when 2 then
           OPEN QUERY brSon2 FOR EACH tt-ordem-embarque NO-LOCK
                                 by tt-ordem-embarque.it-codigo
                                 by tt-ordem-embarque.numero-ordem
                                 by tt-ordem-embarque.parcela
                                 by tt-ordem-embarque.data-1.
      when 3 then
           OPEN QUERY brSon2 FOR EACH tt-ordem-embarque NO-LOCK
                                 by tt-ordem-embarque.data-1
                                 by tt-ordem-embarque.numero-ordem
                                 by tt-ordem-embarque.parcela
                                 by tt-ordem-embarque.it-codigo.
       when 4 then
            OPEN QUERY brSon2 FOR EACH tt-ordem-embarque NO-LOCK
                                  by tt-ordem-embarque.it-codigo
                                  by tt-ordem-embarque.data-1
                                  by tt-ordem-embarque.numero-ordem
                                  by tt-ordem-embarque.parcela.
   end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-openqueries w-livre 
PROCEDURE pi-openqueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if v-frame2 = 2 
  then do:
      run openQueryemb in h-bocx230.
    {&OPEN-QUERY-bremb}
  end.
  else do:      
    run openQueryprev in h-bocx230.
    {&OPEN-QUERY-brprev}
  end.        
  if can-find(first tt-previsoes) or
     can-find(first tt-embarques) then
  do:
      enable bt-emp-prev 
             bt-acompanha with frame f-cad.
      assign MENU-ITEM m_embarquePreviso:SENSITIVE IN MENU mbMain = yes.
      assign MENU-ITEM m_acompanhamento:SENSITIVE IN MENU mbMain = yes.               
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-openquerybrson3 w-livre 
PROCEDURE pi-openquerybrson3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER i-v-rs-classif AS INT NO-UNDO.

  case i-v-rs-classif:
      when 1 then
         OPEN QUERY brson3 FOR EACH tt-prazo-compra NO-LOCK
                                 by tt-prazo-compra.numero-ordem
                                 by tt-prazo-compra.parcela
                                 by tt-prazo-compra.it-codigo
                                 by tt-prazo-compra.data-entrega.
      when 2 then
         OPEN QUERY brson3 FOR EACH tt-prazo-compra NO-LOCK
                                 by tt-prazo-compra.it-codigo
                                 by tt-prazo-compra.numero-ordem
                                 by tt-prazo-compra.parcela
                                 by tt-prazo-compra.data-entrega.
      when 3 then
         OPEN QUERY brson3 FOR EACH tt-prazo-compra NO-LOCK
                                 by tt-prazo-compra.data-entrega
                                 by tt-prazo-compra.numero-ordem
                                 by tt-prazo-compra.parcela
                                 by tt-prazo-compra.it-codigo.
      when 4 then
         OPEN QUERY brson3 FOR EACH tt-prazo-compra NO-LOCK
                                 by tt-prazo-compra.it-codigo
                                 by tt-prazo-compra.data-entrega
                                 by tt-prazo-compra.numero-ordem
                                 by tt-prazo-compra.parcela.
  end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retirar-1 w-livre 
PROCEDURE pi-retirar-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if brson2:num-selected-rows IN FRAME fvinc = 0 then leave.

    ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.
    find first tt-previsoes 
         where tt-previsoes.embarque = v-embarque-imp no-error.
    if not avail tt-previsoes then leave.
    for each tt-selecionada:
        DELETE tt-selecionada.
    end.

    assign i-cont = 0.
    repeat:
        assign  i-cont = i-cont + 1.

        if i-cont > brson2:num-selected-rows then leave.

        brson2:fetch-selected-row(i-cont).

        if not avail tt-ordem-embarque then leave.        
        RUN validateDelete IN h-bocx225 (INPUT-OUTPUT tt-ordem-embarque.r-rowid,
                                         OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            assign i-cont = brson2:num-selected-rows + 1.        
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.            
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.                
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).        
            for each rowerrors:
                delete RowErrors.
            end.
            UNDO, RETURN NO-APPLY.
        END.
        ELSE DO:                                              
            IF AVAIL tt-ordem-embarque THEN DO:
                FIND tt-ordem-quant
                    WHERE tt-ordem-quant.numero-ordem = tt-ordem-embarque.numero-ordem 
                    NO-ERROR.
                IF AVAIL tt-ordem-quant THEN DO:
                    RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-quant.numero-ordem,
                                                               OUTPUT de-quant-disp).
                    ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
                END.
                create tt-selecionada.
                assign tt-selecionada.r-rowid = tt-ordem-embarque.r-rowid.
            END.            
        END.
    end.
    for each tt-selecionada:
        find first tt-ordem-embarque 
             where tt-ordem-embarque.r-rowid = tt-selecionada.r-rowid no-error.
        if avail tt-ordem-embarque then     
            DELETE tt-ordem-embarque.
    end.

    run pi-cria-temp-tables.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retirar-2 w-livre 
PROCEDURE pi-retirar-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if brson2:num-selected-rows IN FRAME fvinc = 0 then leave.

    ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.
    find first tt-embarques 
         where tt-embarques.embarque = v-embarque-imp no-error.
    if not avail tt-embarques then leave.

    for each tt-selecionada:
        delete tt-selecionada.
    end.

    assign i-cont = 0.
    repeat:
        assign  i-cont = i-cont + 1.

        if i-cont > brson2:num-selected-rows then leave.

        brson2:fetch-selected-row(i-cont).

        if not avail tt-ordem-embarque then leave.        
        RUN validateDelete IN h-bocx225 (INPUT-OUTPUT tt-ordem-embarque.r-rowid,
                                         OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            assign i-cont = brson2:num-selected-rows + 1.        
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.            
            IF NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).        
            UNDO, RETURN NO-APPLY.
        END.
        ELSE DO:                                              
            IF AVAIL tt-ordem-embarque THEN DO:
                FIND tt-ordem-quant
                    WHERE tt-ordem-quant.numero-ordem = tt-ordem-embarque.numero-ordem 
                    NO-ERROR.
                IF AVAIL tt-ordem-quant THEN DO:
                    RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-quant.numero-ordem,
                                                               OUTPUT de-quant-disp).
                    ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
                END.
                create tt-selecionada.
                assign tt-selecionada.r-rowid = tt-ordem-embarque.r-rowid.
            END.            
        END.
    end.
    for each tt-selecionada:
        find first tt-ordem-embarque 
             where tt-ordem-embarque.r-rowid = tt-selecionada.r-rowid no-error.
        if avail tt-ordem-embarque then     
            DELETE tt-ordem-embarque.
    end.        
    if not can-find(first RowErrors) 
    then run pi-cria-temp-tables.
    run pi-openqueries.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-desvincula-ordem w-livre 
PROCEDURE pi-valida-desvincula-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter p-cod-estabel as char no-undo.  
    def input  parameter p-embarque as char no-undo.     
    def output parameter l-desvincula as log no-undo.
    
    DEF VAR p-mensagem AS CHAR FORMAT "x(60)" NO-UNDO.
    
    DEF VAR l-embarque AS LOG NO-UNDO.
    def var i-seq-erro as int no-undo.
    DEF VAR h-bodi425 AS HANDLE NO-UNDO.
    
    RUN validateEliminacaoOrdem IN h-bocx225 (INPUT p-cod-estabel,
                                              INPUT p-embarque,
                                              OUTPUT p-mensagem).
    
    IF p-mensagem <> "" THEN DO:
    
        run utp/ut-msgs.p (input "show":U,
                           input 28547,
                           input string(p-embarque) + "~~" + p-mensagem).
    
        if return-value = "NO" then
           assign l-desvincula = no.
        else assign l-desvincula = yes.
    
    end.
    else
        assign l-desvincula = yes.

    IF l-desvincula THEN DO:
       RUN validateEmbarqueOrdem IN h-bocx225 (INPUT p-cod-estabel,
                                               INPUT p-embarque,
                                               OUTPUT l-embarque).
        IF l-embarque THEN DO:
            RUN utp/ut-msgs.p (input "show":U, input 30879, input "").
            IF RETURN-VALUE = "no" THEN
               ASSIGN l-desvincula = NO.
            ELSE DO:
                IF NOT VALID-HANDLE(h-bodi425) THEN
                     RUN dibo/bodi425.p PERSISTENT SET h-bodi425.
                RUN openQueryStatic IN h-bodi425(INPUT "Main":U).
                RUN loadByOrdem IN h-bodi425(INPUT tt-ordem-embarque.numero-ordem,
                                             INPUT tt-ordem-embarque.parcela).
                IF RETURN-VALUE <> "NOK":U THEN DO:
                    RUN deleteRecord IN h-bodi425.
                END.
             
                /*RUN eliminaEmbarquePrazCompra IN h-bocx225 (INPUT p-cod-estabel,
                                                            INPUT p-embarque).*/
                IF VALID-HANDLE(h-bodi425) THEN DO:
                    DELETE PROCEDURE h-bodi425.
                    ASSIGN h-bodi425 = ?.
                END.
           END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-embarque-contabilizado w-livre 
PROCEDURE pi-valida-embarque-contabilizado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter v-cod-estabel as char no-undo.
def input  parameter v-embarque as char no-undo.
def output parameter l-contabilizado as log no-undo.

def var i-seq-erro      as int     no-undo.

run findPk_codigo in h-bocx220 (input v-cod-estabel,
                                input v-embarque,
                                output c-return).
if c-return = "" then
   run getLogField in h-bocx220 ("contabilizado", output l-contabilizado).

if l-contabilizado then do:

    assign i-seq-erro = i-seq-erro + 1.
    create tt-bo-erro.
    assign tt-bo-erro.ErrorParameters = v-embarque
           tt-bo-erro.errorsubtype = "Question".

    run utp/ut-msgs.p (input "show":U,
                       input 27737,
                       input v-embarque).

    if return-value = "NO" then
       assign l-contabilizado = no.
    else assign l-contabilizado = yes.

end.
else assign l-contabilizado = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validaSelecao w-livre 
PROCEDURE pi-validaSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Procedure criada para evitar o estouro de compilaá∆o de 64KB
------------------------------------------------------------------------------*/

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "uma_Ordem" *}
    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                       INPUT 17197, 
                       INPUT RETURN-VALUE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincular-1 w-livre 
PROCEDURE pi-vincular-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable v-parcela    like prazo-compra.parcela       no-undo. 
    define variable v-ordem      like prazo-compra.numero-ordem  no-undo.

    run setCreatehist in h-bocx225.

    if l-relaciona = no then do:
        if brson1:num-selected-rows in frame favinc = 0 then leave.

        if avail tt-ordem-compra then do:  
           ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.
           FIND FIRST tt-previsoes 
                WHERE tt-previsoes.embarque = v-embarque-imp no-error.
           IF NOT AVAIL tt-previsoes THEN leave. 
           run rowidembarque in h-bocx220 (input tt-previsoes.cod-estabel,
                                           input tt-previsoes.embarque,
                                           output v-rowid).

           if return-value = "NOK" then leave.
           assign i-cont = 0.
           do i-cont = 1 to brson1:num-selected-rows:

              if i-cont > brson1:num-selected-rows then leave.

              brson1:fetch-selected-row(i-cont).

              find tt-ordem-quant
                   where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem no-error.              

              ASSIGN i-numero-ordem = tt-ordem-compra.numero-ordem.

              RUN ValidaNovaDataEntrega.
              if NOT can-find(first RowErrors) then do:
                  if l-bt-qtde = yes THEN do:
                     assign l-bt-qtde = no.
                     run createOrdensEmbarqueNovaParcela IN h-bocx225 (input v-rowid,
                                                                       input tt-ordem-compra.numero-ordem,
                                                                       input tt-ordem-quant.quantidade,
                                                                       input v-qtde-emb,
                                                                       input v-nova-entrega,
                                                                       output table RowErrors).

                  end.
                  else do:
                    run createOrdensEmbarque IN h-bocx225 (input v-rowid,
                                                           input tt-ordem-compra.numero-ordem,
                                                           input tt-ordem-quant.quantidade,
                                                           output table RowErrors).
                  end.                                                       
              END.
              if can-find(first RowErrors) then
                  assign i-cont = brson1:num-selected-rows + 1.
              ELSE
                  DELETE tt-ordem-quant.
           end.

           IF CAN-FIND(FIRST RowErrors) THEN DO:
              IF NOT VALID-HANDLE(hShowMsg) THEN
                  RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
              ELSE
                   DELETE PROCEDURE hShowMsg.
              IF NOT VALID-HANDLE(hShowMsg) THEN
                   RUN utp/showmessage.w PERSISTENT SET hShowMsg.                 
              RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
              UNDO, RETURN NO-APPLY.
           END.
        end.
    end.
    else do:
       if brson3:num-selected-rows in frame favinc = 0 then leave.

       if brson3:num-selected-rows = 1 then do:
           ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.

           FIND FIRST tt-previsoes 
                 WHERE tt-previsoes.embarque = v-embarque-imp no-error.
           IF NOT AVAIL tt-previsoes THEN leave. 
           run rowidembarque in h-bocx220 (input tt-previsoes.cod-estabel,
                                           input tt-previsoes.embarque,
                                           output v-rowid).

           if return-value = "NOK" then leave. 
           assign i-cont = 0.    
           do i-cont = 1 to brson3:num-selected-rows:
               if brson3:num-selected-rows = 0 then leave.

               brson3:fetch-selected-row(i-cont).

               ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.
               RUN ValidaNovaDataEntrega.
               if NOT can-find(first RowErrors) then do:
                   run createOrdensEmbarquebyparcela IN h-bocx225 (input v-rowid,
                                                                   input tt-prazo-compra.numero-ordem,
                                                                   input tt-prazo-compra.parcela,
                                                                   input v-qtde-emb,
                                                                   output table RowErrors).
               END.

               if can-find(first RowErrors) then do:
                  assign i-cont = brson3:num-selected-rows + 1.
               end.
           end.            
       end.
       else do: 
            if avail tt-prazo-compra then do:  

               ASSIGN v-embarque-imp = tt-previsoes.embarque:SCREEN-VALUE IN BROWSE brprev.
               FIND FIRST tt-previsoes 
                    WHERE tt-previsoes.embarque = v-embarque-imp no-error.
               IF NOT AVAIL tt-previsoes THEN leave. 
               run rowidembarque in h-bocx220 (input tt-previsoes.cod-estabel,
                                               input tt-previsoes.embarque,
                                               output v-rowid).

               if return-value = "NOK" then leave.
               assign i-cont = 0.

               assign v-data = 12/31/9999.
               do i-cont = 1 to brson3:num-selected-rows:

                  if brson3:num-selected-rows = 0 then leave.
                  if i-cont > brson3:num-selected-rows then leave.
                  brson3:fetch-selected-row(i-cont).
                  /*assign  i-cont = i-cont + 1.*/
                  if tt-prazo-compra.data-entrega < v-data then
                  do:
                     assign v-data     = tt-prazo-compra.data-entrega
                            v-parcela  = tt-prazo-compra.parcela
                            v-ordem    = tt-prazo-compra.numero-ordem.
                  end.               
               end.    
               if can-find(first RowErrors) then
                  assign i-cont = brson3:num-selected-rows + 1.  
               else do:               
                 assign i-cont = 0.

                 do i-cont = 1 to brson3:num-selected-rows:
                     if brson3:num-selected-rows = 0 then leave.
                     if i-cont > brson3:num-selected-rows then leave.
                     brson3:fetch-selected-row(i-cont).

                     ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.
                     RUN ValidaNovaDataEntrega.
                     if NOT can-find(first RowErrors) then do:
                         run createOrdensEmbarquebyparcela IN h-bocx225 (input v-rowid,
                                                                         input tt-prazo-compra.numero-ordem,
                                                                         input tt-prazo-compra.parcela,
                                                                         input tt-prazo-compra.quantidade /*v-qtde-emb*/,
                                                                         output table RowErrors).
                     end.
                     if can-find(first RowErrors) then do:
                        assign i-cont = brson3:num-selected-rows + 1.
                     end.
                 end.        
               end.
          end.                
       end.    
    end.       
    IF CAN-FIND(FIRST RowErrors) THEN DO:
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
       ELSE
          DELETE PROCEDURE hShowMsg.
       IF not VALID-HANDLE(hShowMsg) THEN
              RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.   
       RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
       UNDO, RETURN NO-APPLY.
    END.
    run pi-cria-temp-tables.
    run pi-openqueries.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincular-2 w-livre 
PROCEDURE pi-vincular-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-cont as integer no-undo.
    define variable v-parcela    like prazo-compra.parcela       no-undo. 
    define variable v-ordem      like prazo-compra.numero-ordem  no-undo.

    run setCreatehist in h-bocx225.

    if l-relaciona = no THEN do:  

        if brson1:num-selected-rows in frame favinc = 0 then leave.

        if avail tt-ordem-compra then do: 
           ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb. 
           FIND FIRST tt-embarques no-lock
                     WHERE tt-embarques.embarque = v-embarque-imp no-error.
           IF AVAIL tt-embarques 
           THEN DO:     
              run rowidembarque in h-bocx220 (input tt-embarques.cod-estabel,
                                              input tt-embarques.embarque,
                                              output v-rowid).

              if return-value = "NOK" then leave.

              assign i-cont = 0.

              do i-cont = 1 to brson1:num-selected-rows:

                 if i-cont > brson1:num-selected-rows then leave.

                 brson1:fetch-selected-row(i-cont).

                 find tt-ordem-quant
                     where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem no-error.              
                 ASSIGN i-numero-ordem = tt-ordem-compra.numero-ordem.
                 RUN ValidaNovaDataEntrega.

                 if NOT can-find(first RowErrors) then do:
                     if l-bt-qtde = yes THEN do:
                        assign l-bt-qtde = no.

                        run createOrdensEmbarqueNovaParcela IN h-bocx225 (input v-rowid,
                                                                          input tt-ordem-compra.numero-ordem,
                                                                          input tt-ordem-quant.quantidade,
                                                                          input v-qtde-emb,
                                                                          input v-nova-entrega,
                                                                          output table RowErrors).
                     end.
                     else do:

                       run createOrdensEmbarque IN h-bocx225 (input v-rowid,
                                                              input tt-ordem-compra.numero-ordem,
                                                              input tt-ordem-quant.quantidade,
                                                              output table RowErrors).
                     end.
                 END.
                 ELSE
                     if can-find(first RowErrors) then do:
                         assign i-cont = brson1:num-selected-rows + 1.
                     end.
                     else
                         DELETE tt-ordem-quant.
              end.

              IF CAN-FIND(FIRST RowErrors) THEN DO:
                 IF NOT VALID-HANDLE(hShowMsg) THEN
                    RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                 ELSE
                      DELETE PROCEDURE hShowMsg.
                 IF NOT VALID-HANDLE(hShowMsg) THEN
                     RUN utp/showmessage.w PERSISTENT SET hShowMsg.                
                 RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
                 UNDO, RETURN NO-APPLY.
             END.
           END.  
           run pi-cria-temp-tables.
        end.
        else do:
          disable bt-vinc with frame fPage1. 
          assign MENU-ITEM m_vincular:SENSITIVE IN MENU mbMain = no.
        end.
    end.
    else do:

       if brson3:num-selected-rows in frame favinc = 0 then leave.

       if brson3:num-selected-rows = 1 then do:
           ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.
           FIND FIRST tt-embarques 
                WHERE tt-embarques.embarque = v-embarque-imp no-error.
           IF NOT AVAIL tt-embarques THEN leave. 

           run rowidembarque in h-bocx220 (input tt-embarques.cod-estabel,
                                           input tt-embarques.embarque,
                                           output v-rowid).

           if return-value = "NOK" then leave. 
           assign i-cont = 0.    
           do i-cont = 1 to brson3:num-selected-rows:
               if brson3:num-selected-rows = 0 then leave.

               brson3:fetch-selected-row(i-cont).
               ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.

               RUN ValidaNovaDataEntrega.

               if NOT can-find(first RowErrors) then do:
                   run createOrdensEmbarquebyparcela IN h-bocx225 (input v-rowid,
                                                                   input tt-prazo-compra.numero-ordem,
                                                                   input tt-prazo-compra.parcela,
                                                                   input v-qtde-emb,
                                                                   output table RowErrors).                                                               
               END.
               ELSE
                 if can-find(first RowErrors) then do:
                    assign i-cont = brson3:num-selected-rows + 1.
                 end.
           end.            
       end.
       else do: 
            if avail tt-prazo-compra then do:  
               ASSIGN v-embarque-imp = tt-embarques.embarque:SCREEN-VALUE IN BROWSE bremb.
               FIND FIRST tt-embarques 
                    WHERE tt-embarques.embarque = v-embarque-imp no-error.
               IF NOT AVAIL tt-embarques THEN leave. 
               run rowidembarque in h-bocx220 (input tt-embarques.cod-estabel,
                                               input tt-embarques.embarque,
                                               output v-rowid).

               if return-value = "NOK" then leave.
               assign i-cont = 0.

               assign v-data = 12/31/9999.
               do i-cont = 1 to brson3:num-selected-rows:
                  if brson3:num-selected-rows = 0 then leave.
                  if i-cont > brson3:num-selected-rows then leave.
                  brson3:fetch-selected-row(i-cont).
                  /*assign  i-cont = i-cont + 1.*/
                  if tt-prazo-compra.data-entrega < v-data then
                  do:
                     assign v-data     = tt-prazo-compra.data-entrega
                            v-parcela  = tt-prazo-compra.parcela
                            v-ordem    = tt-prazo-compra.numero-ordem.
                  end.               
               end.    

               if brson3:num-selected-rows > 0 THEN do:

                 find first tt-prazo-compra no-lock
                      where tt-prazo-compra.numero-ordem = v-ordem
                        and tt-prazo-compra.parcela      = v-parcela no-error.
                 if avail tt-prazo-compra then do:
                    ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.

                    RUN ValidaNovaDataEntrega.

                    if NOT can-find(first RowErrors) then do:
                        run createOrdensEmbarquebyparcela IN h-bocx225 (input v-rowid,
                                                                        input tt-prazo-compra.numero-ordem,
                                                                        input tt-prazo-compra.parcela,
                                                                        input tt-prazo-compra.quantidade,
                                                                        output table RowErrors).

                    END.
                 end.                                                                    
               end.

               if can-find(first RowErrors) then
                  assign i-cont = brson3:num-selected-rows + 1.  
               else do:               
                 assign i-cont = 0.

                 do i-cont = 1 to brson3:num-selected-rows:
                    if brson3:num-selected-rows = 0 then leave.
                    if i-cont > brson3:num-selected-rows then leave.
                    brson3:fetch-selected-row(i-cont).
                    /*assign  i-cont = i-cont + 1.*/

                    if tt-prazo-compra.numero-ordem = v-ordem and 
                       tt-prazo-compra.parcela      = v-parcela then.

                    else do:
                         ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.

                         RUN ValidaNovaDataEntrega.

                         if NOT can-find(first RowErrors) then do:
                             run createOrdensEmbarquebyparcela IN h-bocx225 (input v-rowid,
                                                                             input tt-prazo-compra.numero-ordem,
                                                                             input tt-prazo-compra.parcela,
                                                                             input tt-prazo-compra.quantidade,
                                                                             output table RowErrors).

                         END.
                    end.
                    if can-find(first RowErrors) then do:
                       assign i-cont = brson3:num-selected-rows + 1.
                    end.
                 end.        
               end.

          end.                
       end.    
    end.    
    IF CAN-FIND(FIRST RowErrors) THEN DO:
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
       ELSE
          DELETE PROCEDURE hShowMsg.
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/showmessage.w PERSISTENT SET hShowMsg.                 
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.

       RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
       UNDO, RETURN NO-APPLY.
    END.

    run pi-cria-temp-tables.

    run pi-openqueries.    

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
  {src/adm/template/snd-list.i "tt-previsoes"}
  {src/adm/template/snd-list.i "tt-embarques"}
  {src/adm/template/snd-list.i "tt-ordem-embarque"}
  {src/adm/template/snd-list.i "tt-ordem-compra"}

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

  /*run pi-trata-state (p-issuer-hdl, p-state).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNovaDataEntrega w-livre 
PROCEDURE ValidaNovaDataEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF l-bt-qt THEN DO: /*somente ira executar esta procedure quando for executado pelo
                          botao quantidade, pois ira criar uma nova parcela de compra*/
        RUN validaNovaDataEntrega IN h-bocx225 (INPUT i-numero-ordem,
                                                INPUT v-nova-entrega,
                                                OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "INFORMATION":U) THEN DO:
            IF NOT VALID-HANDLE(hShowMsg) THEN
               RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
            ELSE
               DELETE PROCEDURE hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

            FOR EACH RowErrors:
                DELETE RowErrors.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem w-livre 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN findOrdem IN h-boin274 (INPUT pnum-ordem, 
                                OUTPUT c-return).

    RUN getCharField IN h-boin274 (INPUT "it-codigo":U, 
                                   OUTPUT c-descricao).

    RETURN c-descricao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProcesso w-livre 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer ) :

  assign cf-nr-proc-imp = "".
  run findPedido in h-bocx140 (input p-num-pedido,output c-return).
  if c-return = "" then
    run getCharfield in h-bocx140 (input "nr-proc-imp":U,output cf-nr-proc-imp).

  RETURN cf-nr-proc-imp.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnprocessoprazo w-livre 
FUNCTION fnprocessoprazo RETURNS CHARACTER
  ( input p-numero-ordem as integer ) :
  def var i-numero-ped as integer no-undo.

  assign cf-nr-proc-imp = "".

  run retornapedido in h-boin356aa (input  p-numero-ordem,
                                    output i-numero-ped).

  run findPedido in h-bocx140 (input i-numero-ped,output c-return).
  if c-return = "" then
    run getCharfield in h-bocx140 (input "nr-proc-imp":U,output cf-nr-proc-imp).

  RETURN cf-nr-proc-imp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtde w-livre 
FUNCTION fnQtde RETURNS decimal
    ():
/*------------------------------------------------------------------------------
**
** Retorna quantidade disponivel para embarque
**
------------------------------------------------------------------------------*/
    FIND tt-ordem-quant 
        WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
        NO-ERROR.

    IF NOT AVAIL tt-ordem-quant THEN DO:    
        CREATE tt-ordem-quant.
        ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
               tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.
        RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                   OUTPUT de-quant-disp).

        ASSIGN tt-ordem-quant.quantidade = de-quant-disp
               tt-ordem-quant.un-nosso  = fnUnItem(tt-ordem-compra.it-codigo).

    END.

    RETURN tt-ordem-quant.quantidade.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtFornec w-livre 
FUNCTION fnQtFornec RETURNS DECIMAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    assign de-qt-do-forn = 0.0.

    RUN pi-calculaQtdeDisponivelFornec IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                     OUTPUT de-qt-do-forn).


    FIND tt-ordem-quant 
        WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
        NO-ERROR.  

    if avail tt-ordem-quant then
    /* Determina o fornecedor e a unidade utilizada pelo fornecedor para o item */
    run pi-determina-fornec in this-procedure (input tt-ordem-compra.numero-ordem,
                                               output i-return,
                                               output c-return).

    assign tt-ordem-quant.cod-fornec = i-return /* c¢digo do fornecedor */
           tt-ordem-quant.un-fornec = c-return.  /* unidade utilizada pelo fornecedor */

    return de-qt-do-forn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec w-livre 
FUNCTION fnUnFornec RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND tt-ordem-quant 
      WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
      NO-ERROR.  

  if avail tt-ordem-quant then
     return tt-ordem-quant.un-fornec.

  return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec1 w-livre 
FUNCTION fnUnFornec1 RETURNS CHARACTER
  ( input pnum-ordem as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    run findCotacaoAprovada in h-boin082 (input pnum-ordem,
                                          output c-return).
    if c-return = "" then do:
        run getCharfield in h-boin082(input "un":U, output c-return).

        return c-return.
    end.

    return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnItem w-livre 
FUNCTION fnUnItem RETURNS CHARACTER
  (input p-it-codigo as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run findCodigo in h-boin172 (input p-it-codigo, output c-return).

  if c-return = "" then do:
      run getCharField in h-boin172 (input "un":U, output c-return).
      return c-return.
  end.
  RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

