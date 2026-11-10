&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases  
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
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
{include/i-prgvrs.i IM0100B 2.00.00.027} /*** "010027" 09/10/2025 11:29:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100b MIM}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0100B
&GLOBAL-DEFINE Version          2.00.00.027
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      0
&GLOBAL-DEFINE FolderLabels     

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225e
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque ~
                                i-peso ~
                                i-quantidade ~
                                i-classifica ~
                                btConfirm ~
                                btReload

&GLOBAL-DEFINE page0Browse      brSon1 brSon2 brSon3

&GLOBAL-DEFINE numRowsReturned  inumRowsReturned

&GLOBAL-DEFINE EXCLUDE-ApplyOffEnd
&GLOBAL-DEFINE ExcludeBtQueryJoins      YES
&GLOBAL-DEFINE ExcludeBtReportsJoins    YES

/* Include pre-processadores */
{cdp/cdcfgmat.i}
/* Vari veis de Sistema */
{utp/ut-glob.i}

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER p-cod-estabel   LIKE estabelec.cod-estabel   NO-UNDO.
DEF INPUT PARAMETER p-embarque      LIKE embarque-imp.embarque   NO-UNDO.
DEF INPUT PARAMETER p-usuario       LIKE param-re.usuario        NO-UNDO.
DEF INPUT PARAMETER p-nat-operacao  LIKE natur-oper.nat-operacao NO-UNDO.
DEF INPUT PARAMETER p-icms-diferido AS   LOGICAL                 NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEF VAR h-boin245 AS HANDLE NO-UNDO.
DEF VAR h-boin292 AS HANDLE NO-UNDO.
DEF VAR h-bocx310 AS HANDLE NO-UNDO.

DEF VAR c-it-codigo        LIKE ITEM.it-codigo      NO-UNDO.
DEF VAR c-desc-item        AS   CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR c-un               LIKE ITEM.un             NO-UNDO.
DEF VAR de-quantidade      LIKE prazo-compra.quantidade                 NO-UNDO.
DEF VAR de-peso-bruto      AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido    AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR i-trib-ii          AS   INTEGER             NO-UNDO.
DEF VAR c-trib-ii          AS   CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR i-trib-ipi         AS   INTEGER             NO-UNDO.
DEF VAR c-trib-ipi         AS   CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR i-trib-icms        AS   INTEGER             NO-UNDO.
DEF VAR c-trib-icms        AS   CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR i-trib-pis         AS   INTEGER             NO-UNDO.
DEF VAR c-trib-pis         AS   CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR i-trib-cofins      AS   INTEGER             NO-UNDO.
DEF VAR c-trib-cofins      AS   CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR de-aliq-ii         LIKE ITEM.aliquota-ipi   NO-UNDO.
DEF VAR de-aliq-ipi        LIKE ITEM.aliquota-ipi   NO-UNDO.
DEF VAR de-aliq-icms       LIKE ITEM.aliquota-ipi   NO-UNDO.
DEF VAR de-aliq-pis        LIKE ITEM.aliquota-ipi   NO-UNDO.
DEF VAR de-aliq-cofins     LIKE ITEM.aliquota-ipi   NO-UNDO.
DEF VAR c-item-char-2      LIKE ITEM.char-2         NO-UNDO.
DEF VAR l-usuarionatureza  AS   LOGICAL             NO-UNDO.
DEF VAR inumRowsReturned   AS   INTEGER             NO-UNDO.
DEF VAR i-peso-ant         AS   INTEGER             NO-UNDO.
DEF VAR i-sequen           AS   INTEGER             NO-UNDO.
DEF VAR l-ok               AS   LOGICAL             NO-UNDO.
DEF VAR i-numero-ordem-ini AS   INTEGER             NO-UNDO.
DEF VAR i-numero-ordem-fim AS   INTEGER             NO-UNDO.
DEF VAR c-item-ini         AS   CHARACTER           NO-UNDO.
DEF VAR c-item-fim         AS   CHARACTER           NO-UNDO.
DEF VAR c-class-fiscal     AS   CHARACTER           NO-UNDO.
DEF VAR c-class-fiscal-ini AS   CHARACTER           NO-UNDO.
DEF VAR c-class-fiscal-fim AS   CHARACTER           NO-UNDO.
DEF VAR h-Query            AS   HANDLE              NO-UNDO.

DEF VAR i-classifica-ant            AS   INTEGER                            NO-UNDO.
DEF VAR c-desc-classif              AS   CHARACTER FORMAT "x(35)"           NO-UNDO.
DEF VAR de-qtde-acum                LIKE prazo-compra.quantidade            NO-UNDO.
DEF VAR de-qt-do-forn-acum          LIKE prazo-compra.quantidade            NO-UNDO.
DEF VAR de-quantidade-acum          LIKE prazo-compra.quantidade            NO-UNDO.
DEF VAR de-peso-bruto-unit-acum     AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-bruto-acum          AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido-unit-acum   AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido-acum        AS   DECIMAL FORMAT ">>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-tx-siscomex-ant          AS   DECIMAL                            NO-UNDO.
DEF VAR h-boin046na                 AS   HANDLE                             NO-UNDO.
DEF VAR h-bocx250                   AS   HANDLE                             NO-UNDO.
DEF VAR iNrRegistro                 AS   INTEGER                            NO-UNDO.
DEF VAR l-atualiza-pesos            AS   LOGICAL                            NO-UNDO.
DEF VAR i-peso-aux                  AS   INTEGER                            NO-UNDO.
DEF VAR i-cdn-adicao-ant            AS   INTEGER                            NO-UNDO.
DEF VAR l-tax-siscomex              AS   LOGICAL                            NO-UNDO.
DEF VAR l-atualizar-despesa         AS   LOGICAL INIT NO                    NO-UNDO.
DEF VAR c-tax-siscomex              AS   CHARACTER                          NO-UNDO.
DEF VAR c-erro                      AS   CHARACTER                          NO-UNDO.

{imp/im0100.i1}

/* Temp-tables                                                          */
{cxbo/bocx225e.i tt-ordens-desemb}
{cxbo/bocx225.i tt-ordens-embarque-aux}
{include/boerrtab.i}

define temp-table tt-ordens-desemb-aux no-undo
    field numero-ordem     as INTEGER FORMAT "zzzzz9,99"
    field parcela          as INTEGER FORMAT ">>>>9"
    field it-codigo        as CHAR    FORMAT "X(16)"
    field un               as CHAR    FORMAT "X(2)"
    field quantidade       as DECIMAL FORMAT ">>>>>,>>9.9999"
    field peso-bruto       as DECIMAL FORMAT ">>>>,>>9.9999999999"
    field peso-liquido     as DECIMAL FORMAT ">>>>,>>9.9999999999"
    field trib-II          AS CHAR    FORMAT "X(1)"
    field aliq-II          AS DECIMAL FORMAT ">>>9.99"
    field trib-IPI         AS CHAR    FORMAT "X(1)"
    field aliq-IPI         AS DECIMAL FORMAT ">>>9.99"
    field trib-ICMS        AS CHAR    FORMAT "X(1)"
    field aliq-ICMS        AS DECIMAL FORMAT ">>>9.99"
    FIELD trib-PIS         AS CHAR    FORMAT  "X(1)"
    field aliq-pis         AS DECIMAL FORMAT ">>>9.99"
    FIELD trib-COFINS      AS CHAR    FORMAT  "X(1)"
    field aliq-cofins      AS DECIMAL FORMAT ">>>9.99"
    FIELD c-class-fiscal   AS CHAR    FORMAT "9999.99.99".

DEFINE TEMP-TABLE tt-ordens-desemb-param NO-UNDO LIKE tt-ordens-desemb.
DEFINE TEMP-TABLE tt-ordens-desemb-aux-2 NO-UNDO LIKE tt-ordens-desemb.

DEFINE TEMP-TABLE tt-ordens-desemb-acum NO-UNDO LIKE tt-ordens-desemb
    FIELD c-desc-classif AS CHAR FORMAT "x(35)".

DEFINE TEMP-TABLE tt-ordens-desemb-acum-adicao NO-UNDO LIKE tt-ordens-desemb-acum.

DEFINE TEMP-TABLE tt-ordens-desemb-acum-aux NO-UNDO LIKE tt-ordens-desemb-acum.
DEFINE TEMP-TABLE tt-ordens-desemb-acum-adicao-aux NO-UNDO LIKE tt-ordens-desemb-acum-adicao.

DEFINE BUFFER b-tt-ordens-desemb FOR tt-ordens-desemb.

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
&Scoped-define INTERNAL-TABLES tt-ordens-desemb tt-ordens-desemb-acum ~
tt-ordens-desemb-acum-adicao

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.numero-ordem tt-ordens-desemb.parcela tt-ordens-desemb.c-it-codigo tt-ordens-desemb.c-desc-item tt-ordens-desemb.c-class-fiscal tt-ordens-desemb.c-un tt-ordens-desemb.de-quantidade tt-ordens-desemb.de-peso-bruto tt-ordens-desemb.de-peso-liquido tt-ordens-desemb.c-trib-ii tt-ordens-desemb.de-aliq-ii /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb.l-suspensao-II &ENDIF tt-ordens-desemb.c-trib-ipi tt-ordens-desemb.de-aliq-ipi /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb.l-suspensao-IPI &ENDIF tt-ordens-desemb.c-trib-icms tt-ordens-desemb.de-aliq-icms tt-ordens-desemb.c-trib-pis tt-ordens-desemb.de-aliq-pis tt-ordens-desemb.c-trib-cofins tt-ordens-desemb.de-aliq-cofins tt-ordens-desemb.cdn-adicao tt-ordens-desemb.seq-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.de-peso-bruto ~
tt-ordens-desemb.de-peso-liquido ~
tt-ordens-desemb.c-trib-ii VALIDATE(tt-ordens-desemb.c-trib-ii = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
tt-ordens-desemb.c-trib-ii = "T", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
"Tributa‡Æo ser T ou I") ~
tt-ordens-desemb.de-aliq-ii ~
tt-ordens-desemb.c-trib-ipi VALIDATE(tt-ordens-desemb.c-trib-ipi = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb.c-trib-ipi = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-ipi = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-ipi = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O") ~
tt-ordens-desemb.de-aliq-ipi ~
tt-ordens-desemb.c-trib-icms VALIDATE(tt-ordens-desemb.c-trib-icms = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb.c-trib-icms = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-icms = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-icms = "O" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-icms = "D", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O ou D") ~
tt-ordens-desemb.de-aliq-icms ~
tt-ordens-desemb.c-trib-pis VALIDATE(tt-ordens-desemb.c-trib-pis = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-pis = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb.c-trib-pis = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb.de-aliq-pis ~
tt-ordens-desemb.c-trib-cofins VALIDATE(tt-ordens-desemb.c-trib-cofins = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb.c-trib-cofins = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb.c-trib-cofins = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb.de-aliq-cofins ~
/****************************************************** ~
* Engenharia IPI Suspensao Incorporar Base PIS COFINS * ~
******************************************************/ ~
&IF DEFINED(bf-mat-comex) &THEN ~
&ELSE ~
  tt-ordens-desemb.l-suspensao-II ~
  tt-ordens-desemb.l-suspensao-IPI ~
&ENDIF ~
tt-ordens-desemb.cdn-adicao ~
tt-ordens-desemb.seq-item   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 tt-ordens-desemb ~
VALIDATE(tt-ordens-desemb "Nr "Seq
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon1 VALIDATE(tt-ordens-desemb
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-brSon1 "Nr
&Scoped-define FOURTH-ENABLED-TABLE-IN-QUERY-brSon1 "Seq
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-desemb


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.c-class-fiscal tt-ordens-desemb-acum.c-un fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum.de-quantidade tt-ordens-desemb-acum.de-peso-bruto tt-ordens-desemb-acum.de-peso-liquido tt-ordens-desemb-acum.c-trib-ii tt-ordens-desemb-acum.de-aliq-ii /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb-acum.l-suspensao-II &ENDIF tt-ordens-desemb-acum.c-trib-ipi tt-ordens-desemb-acum.de-aliq-ipi /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb-acum.l-suspensao-IPI &ENDIF tt-ordens-desemb-acum.c-trib-icms tt-ordens-desemb-acum.de-aliq-icms tt-ordens-desemb-acum.c-trib-pis tt-ordens-desemb-acum.de-aliq-pis tt-ordens-desemb-acum.c-trib-cofins tt-ordens-desemb-acum.de-aliq-cofins   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.de-peso-bruto ~
tt-ordens-desemb-acum.de-peso-liquido ~
tt-ordens-desemb-acum.c-trib-ii VALIDATE(tt-ordens-desemb-acum.c-trib-ii = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
tt-ordens-desemb-acum.c-trib-ii = "T", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
"Tributa‡Æo ser T ou I") ~
tt-ordens-desemb-acum.de-aliq-ii ~
tt-ordens-desemb-acum.c-trib-ipi VALIDATE(tt-ordens-desemb-acum.c-trib-ipi = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb-acum.c-trib-ipi = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-ipi = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-ipi = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O") ~
tt-ordens-desemb-acum.de-aliq-ipi ~
tt-ordens-desemb-acum.c-trib-icms VALIDATE(tt-ordens-desemb-acum.c-trib-icms = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb-acum.c-trib-icms = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-icms = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-icms = "O" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-icms = "D", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O ou D") ~
tt-ordens-desemb-acum.de-aliq-icms ~
tt-ordens-desemb-acum.c-trib-pis VALIDATE(tt-ordens-desemb-acum.c-trib-pis = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-pis = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb-acum.c-trib-pis = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb-acum.de-aliq-pis ~
tt-ordens-desemb-acum.c-trib-cofins VALIDATE(tt-ordens-desemb-acum.c-trib-cofins = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum.c-trib-cofins = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb-acum.c-trib-cofins = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb-acum.de-aliq-cofins ~
/****************************************************** ~
* Engenharia IPI Suspensao Incorporar Base PIS COFINS * ~
******************************************************/ ~
&IF DEFINED(bf-mat-comex) &THEN ~
&ELSE ~
  tt-ordens-desemb-acum.l-suspensao-II ~
  tt-ordens-desemb-acum.l-suspensao-IPI ~
&ENDIF   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum ~
VALIDATE(tt-ordens-desemb-acum
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon2 VALIDATE(tt-ordens-desemb-acum
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-desemb-acum NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.cdn-adicao tt-ordens-desemb-acum-adicao.c-class-fiscal tt-ordens-desemb-acum-adicao.c-un fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum-adicao.de-quantidade tt-ordens-desemb-acum-adicao.de-peso-bruto tt-ordens-desemb-acum-adicao.de-peso-liquido tt-ordens-desemb-acum-adicao.c-trib-ii tt-ordens-desemb-acum-adicao.de-aliq-ii /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb-acum-adicao.l-suspensao-II &ENDIF tt-ordens-desemb-acum-adicao.c-trib-ipi tt-ordens-desemb-acum-adicao.de-aliq-ipi /****************************************************** * Engenharia IPI Suspensao Incorporar Base PIS COFINS * ******************************************************/ &IF DEFINED(bf-mat-comex) &THEN &ELSE tt-ordens-desemb-acum-adicao.l-suspensao-IPI &ENDIF tt-ordens-desemb-acum-adicao.c-trib-icms tt-ordens-desemb-acum-adicao.de-aliq-icms tt-ordens-desemb-acum-adicao.c-trib-pis tt-ordens-desemb-acum-adicao.de-aliq-pis tt-ordens-desemb-acum-adicao.c-trib-cofins tt-ordens-desemb-acum-adicao.de-aliq-cofins tt-ordens-desemb-acum-adicao.de-taxa-siscomex   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.de-peso-bruto ~
tt-ordens-desemb-acum-adicao.de-peso-liquido ~
tt-ordens-desemb-acum-adicao.c-trib-ii VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-ii = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
tt-ordens-desemb-acum-adicao.c-trib-ii = "T", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
"Tributa‡Æo ser T ou I") ~
tt-ordens-desemb-acum-adicao.de-aliq-ii ~
tt-ordens-desemb-acum-adicao.c-trib-ipi VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-ipi = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb-acum-adicao.c-trib-ipi = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-ipi = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-ipi = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O") ~
tt-ordens-desemb-acum-adicao.de-aliq-ipi ~
tt-ordens-desemb-acum-adicao.c-trib-icms VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-icms = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-ordens-desemb-acum-adicao.c-trib-icms = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-icms = "R" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-icms = "O" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-icms = "D", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  "Tributa‡Æo ser T ou I ou R ou O ou D") ~
tt-ordens-desemb-acum-adicao.de-aliq-icms ~
tt-ordens-desemb-acum-adicao.c-trib-pis VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-pis = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-pis = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb-acum-adicao.c-trib-pis = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb-acum-adicao.de-aliq-pis ~
tt-ordens-desemb-acum-adicao.c-trib-cofins VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-cofins = "T" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-ordens-desemb-acum-adicao.c-trib-cofins = "I" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 tt-ordens-desemb-acum-adicao.c-trib-cofins = "O", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tributa‡Æo ser T ou I ou O") ~
tt-ordens-desemb-acum-adicao.de-aliq-cofins ~
/****************************************************** ~
* Engenharia IPI Suspensao Incorporar Base PIS COFINS * ~
******************************************************/ ~
&IF DEFINED(bf-mat-comex) &THEN ~
&ELSE ~
  tt-ordens-desemb-acum-adicao.l-suspensao-II ~
  tt-ordens-desemb-acum-adicao.l-suspensao-IPI ~
&ENDIF ~
tt-ordens-desemb-acum-adicao.de-taxa-siscomex   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao ~
VALIDATE(tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon3 VALIDATE(tt-ordens-desemb-acum-adicao
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS i-peso TEXT-2 i-quantidade i-classifica ~
rs-ordena brSon1 brSon2 btParam btConfirm btReload btExit btHelp RECT-1 ~
RECT-3 RECT-4 rtParent rtToolBar brSon3 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS de-tx-siscomex i-peso TEXT-2 i-quantidade ~
i-classifica rs-ordena 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAliqIcms wMasterDetail 
FUNCTION fnAliqIcms RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAliqIi wMasterDetail 
FUNCTION fnAliqIi RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAliqIpi wMasterDetail 
FUNCTION fnAliqIpi RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClassFiscal wMasterDetail 
FUNCTION fnClassFiscal RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescClassFiscal wMasterDetail 
FUNCTION fnDescClassFiscal RETURNS CHARACTER
  ( c-class-fiscal AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  ( INPUT p-numero-ordem AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoLiquido wMasterDetail 
FUNCTION fnPesoLiquido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTribIcms wMasterDetail 
FUNCTION fnTribIcms RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTribIi wMasterDetail 
FUNCTION fnTribIi RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTribIpi wMasterDetail 
FUNCTION fnTribIpi RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnidade wMasterDetail 
FUNCTION fnUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btConfirm 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma altera‡äes nos itens"
     FONT 4.

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

DEFINE BUTTON btParam 
     LABEL "&Sele‡Æo" 
     SIZE 15 BY 1.

DEFINE BUTTON btReload 
     IMAGE-UP FILE "image~\im-undo":U
     IMAGE-INSENSITIVE FILE "image~\ii-undo":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Recarrega informa‡äes do item"
     FONT 4.

DEFINE VARIABLE de-tx-siscomex AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Total Taxa Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE TEXT-2 AS CHARACTER FORMAT "X(27)":U INITIAL " Ordena‡Æo das Informa‡äes" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE i-classifica AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Item", 1,
"Por Class Fiscal", 2,
"Por Adi‡äes do Embarque", 3
     SIZE 28 BY 2.63 NO-UNDO.

DEFINE VARIABLE i-peso AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Peso Unit rio", 1,
"Peso Total", 2
     SIZE 12 BY 1.75 NO-UNDO.

DEFINE VARIABLE i-quantidade AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Qtde Unidade Interna", 1,
"Qtde Unidade Externa", 2
     SIZE 19 BY 1.75 NO-UNDO.

DEFINE VARIABLE rs-ordena AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL EXPAND 
     RADIO-BUTTONS 
          "Ordem Compra", 1,
"Item", 2,
"Class Fiscal", 3,
"Adi‡äes do Embarque", 4
     SIZE 71.43 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 3.21.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.79.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 3.21.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-desemb SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-ordens-desemb-acum SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-ordens-desemb-acum-adicao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-ordens-desemb.numero-ordem FORMAT "zzzzz9,99":U
      tt-ordens-desemb.parcela FORMAT ">>>>9":U
      tt-ordens-desemb.c-it-codigo LABEL "Item"
      tt-ordens-desemb.c-desc-item LABEL "Descri‡Æo"
      tt-ordens-desemb.c-class-fiscal FORMAT "9999.99.99":U
      tt-ordens-desemb.c-un LABEL "Un"
      tt-ordens-desemb.de-quantidade FORMAT ">>>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb.de-peso-bruto LABEL "Peso Bruto"
      tt-ordens-desemb.de-peso-liquido LABEL "Peso L¡quido"
      tt-ordens-desemb.c-trib-ii
      tt-ordens-desemb.de-aliq-ii

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb.l-suspensao-II
      &ENDIF
      
      tt-ordens-desemb.c-trib-ipi
      tt-ordens-desemb.de-aliq-ipi

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb.l-suspensao-IPI
      &ENDIF
      
      tt-ordens-desemb.c-trib-icms
      tt-ordens-desemb.de-aliq-icms
      tt-ordens-desemb.c-trib-pis
      tt-ordens-desemb.de-aliq-pis
      tt-ordens-desemb.c-trib-cofins
      tt-ordens-desemb.de-aliq-cofins
      tt-ordens-desemb.cdn-adicao
      tt-ordens-desemb.seq-item
  ENABLE
      tt-ordens-desemb.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb.de-peso-liquido HELP "Peso L¡quido"
      tt-ordens-desemb.c-trib-ii HELP "T-Tributado I-Isento" VALIDATE(tt-ordens-desemb.c-trib-ii = "I" OR 
                                                                      tt-ordens-desemb.c-trib-ii = "T",
                                                                      "Tributa‡Æo ser T ou I")
      tt-ordens-desemb.de-aliq-ii HELP "Al¡quota II"
      tt-ordens-desemb.c-trib-ipi HELP "T-Tributado I-Isento R-Reduzido O-Outros" VALIDATE(tt-ordens-desemb.c-trib-ipi = "T" OR 
                                                                                           tt-ordens-desemb.c-trib-ipi = "I" OR
                                                                                           tt-ordens-desemb.c-trib-ipi = "R" OR
                                                                                           tt-ordens-desemb.c-trib-ipi = "O",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O")
      tt-ordens-desemb.de-aliq-ipi HELP "Al¡quota IPI"
      tt-ordens-desemb.c-trib-icms HELP "T-Tributado I-Isento R-Reduzido O-Outros D-Diferido" VALIDATE(tt-ordens-desemb.c-trib-icms = "T" OR 
                                                                                           tt-ordens-desemb.c-trib-icms = "I" OR
                                                                                           tt-ordens-desemb.c-trib-icms = "R" OR
                                                                                           tt-ordens-desemb.c-trib-icms = "O" OR
                                                                                           tt-ordens-desemb.c-trib-icms = "D",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O ou D")
      tt-ordens-desemb.de-aliq-icms HELP "Al¡quota ICMS"
      tt-ordens-desemb.c-trib-pis HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb.c-trib-pis = "T" OR 
                                                                                 tt-ordens-desemb.c-trib-pis = "I" OR
                                                                                 tt-ordens-desemb.c-trib-pis = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb.de-aliq-pis HELP "Aliquota PIS Externo"
      tt-ordens-desemb.c-trib-cofins HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb.c-trib-cofins = "T" OR 
                                                                                 tt-ordens-desemb.c-trib-cofins = "I" OR
                                                                                 tt-ordens-desemb.c-trib-cofins = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb.de-aliq-cofins HELP "Aliquota COFINS Externo"

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb.l-suspensao-II  HELP "SuspensÆo Imposto Importa‡Æo - Sim/NÆo"
          tt-ordens-desemb.l-suspensao-IPI HELP "SuspensÆo IPI - Sim/NÆo"
      &ENDIF
      tt-ordens-desemb.cdn-adicao HELP "Nr.Adi‡Æo"
      tt-ordens-desemb.seq-item HELP "Seq. Item Adi‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 9.75
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-ordens-desemb-acum.c-class-fiscal FORMAT "9999.99.99":U
      tt-ordens-desemb-acum.c-un LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif LABEL "Descri‡Æo" FORMAT "x(35)"
      tt-ordens-desemb-acum.de-quantidade FORMAT ">>>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb-acum.de-peso-bruto LABEL "Peso Bruto"
      tt-ordens-desemb-acum.de-peso-liquido LABEL "Peso L¡quido"
      tt-ordens-desemb-acum.c-trib-ii
      tt-ordens-desemb-acum.de-aliq-ii

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum.l-suspensao-II
      &ENDIF
      
      tt-ordens-desemb-acum.c-trib-ipi
      tt-ordens-desemb-acum.de-aliq-ipi

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum.l-suspensao-IPI
      &ENDIF
      
      tt-ordens-desemb-acum.c-trib-icms
      tt-ordens-desemb-acum.de-aliq-icms
      tt-ordens-desemb-acum.c-trib-pis
      tt-ordens-desemb-acum.de-aliq-pis
      tt-ordens-desemb-acum.c-trib-cofins
      tt-ordens-desemb-acum.de-aliq-cofins
  ENABLE
      tt-ordens-desemb-acum.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb-acum.de-peso-liquido HELP "Peso L¡quido"
      tt-ordens-desemb-acum.c-trib-ii HELP "T-Tributado I-Isento" VALIDATE(tt-ordens-desemb-acum.c-trib-ii = "I" OR 
                                                                      tt-ordens-desemb-acum.c-trib-ii = "T",
                                                                      "Tributa‡Æo ser T ou I")
      tt-ordens-desemb-acum.de-aliq-ii HELP "Al¡quota II"
      tt-ordens-desemb-acum.c-trib-ipi HELP "T-Tributado I-Isento R-Reduzido O-Outros" VALIDATE(tt-ordens-desemb-acum.c-trib-ipi = "T" OR 
                                                                                           tt-ordens-desemb-acum.c-trib-ipi = "I" OR
                                                                                           tt-ordens-desemb-acum.c-trib-ipi = "R" OR
                                                                                           tt-ordens-desemb-acum.c-trib-ipi = "O",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O")
      tt-ordens-desemb-acum.de-aliq-ipi HELP "Al¡quota IPI"
      tt-ordens-desemb-acum.c-trib-icms HELP "T-Tributado I-Isento R-Reduzido O-Outros D-Diferido" VALIDATE(tt-ordens-desemb-acum.c-trib-icms = "T" OR 
                                                                                           tt-ordens-desemb-acum.c-trib-icms = "I" OR
                                                                                           tt-ordens-desemb-acum.c-trib-icms = "R" OR
                                                                                           tt-ordens-desemb-acum.c-trib-icms = "O" OR
                                                                                           tt-ordens-desemb-acum.c-trib-icms = "D",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O ou D")
      tt-ordens-desemb-acum.de-aliq-icms HELP "Al¡quota ICMS"
      tt-ordens-desemb-acum.c-trib-pis HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb-acum.c-trib-pis = "T" OR 
                                                                                 tt-ordens-desemb-acum.c-trib-pis = "I" OR
                                                                                 tt-ordens-desemb-acum.c-trib-pis = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb-acum.de-aliq-pis HELP "Aliquota PIS Externo"
      tt-ordens-desemb-acum.c-trib-cofins HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb-acum.c-trib-cofins = "T" OR 
                                                                                 tt-ordens-desemb-acum.c-trib-cofins = "I" OR
                                                                                 tt-ordens-desemb-acum.c-trib-cofins = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb-acum.de-aliq-cofins HELP "Aliquota COFINS Externo"

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum.l-suspensao-II  HELP "SuspensÆo Imposto Importa‡Æo - Sim/NÆo"
          tt-ordens-desemb-acum.l-suspensao-IPI HELP "SuspensÆo IPI - Sim/NÆo"
      &ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 9.75
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      tt-ordens-desemb-acum-adicao.cdn-adicao
      tt-ordens-desemb-acum-adicao.c-class-fiscal FORMAT "9999.99.99":U
      tt-ordens-desemb-acum-adicao.c-un LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif LABEL "Descri‡Æo" FORMAT "x(35)"
      tt-ordens-desemb-acum-adicao.de-quantidade FORMAT ">>>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb-acum-adicao.de-peso-bruto LABEL "Peso Bruto"
      tt-ordens-desemb-acum-adicao.de-peso-liquido LABEL "Peso L¡quido"
      tt-ordens-desemb-acum-adicao.c-trib-ii
      tt-ordens-desemb-acum-adicao.de-aliq-ii

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum-adicao.l-suspensao-II
      &ENDIF
      
      tt-ordens-desemb-acum-adicao.c-trib-ipi
      tt-ordens-desemb-acum-adicao.de-aliq-ipi

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum-adicao.l-suspensao-IPI
      &ENDIF
      
      tt-ordens-desemb-acum-adicao.c-trib-icms
      tt-ordens-desemb-acum-adicao.de-aliq-icms
      tt-ordens-desemb-acum-adicao.c-trib-pis
      tt-ordens-desemb-acum-adicao.de-aliq-pis
      tt-ordens-desemb-acum-adicao.c-trib-cofins
      tt-ordens-desemb-acum-adicao.de-aliq-cofins
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
  ENABLE
      tt-ordens-desemb-acum-adicao.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb-acum-adicao.de-peso-liquido HELP "Peso L¡quido"
      tt-ordens-desemb-acum-adicao.c-trib-ii HELP "T-Tributado I-Isento" VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-ii = "I" OR 
                                                                      tt-ordens-desemb-acum-adicao.c-trib-ii = "T",
                                                                      "Tributa‡Æo ser T ou I")
      tt-ordens-desemb-acum-adicao.de-aliq-ii HELP "Al¡quota II"
      tt-ordens-desemb-acum-adicao.c-trib-ipi HELP "T-Tributado I-Isento R-Reduzido O-Outros" VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-ipi = "T" OR 
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-ipi = "I" OR
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-ipi = "R" OR
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-ipi = "O",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O")
      tt-ordens-desemb-acum-adicao.de-aliq-ipi HELP "Al¡quota IPI"
      tt-ordens-desemb-acum-adicao.c-trib-icms HELP "T-Tributado I-Isento R-Reduzido O-Outros D-Diferido" VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-icms = "T" OR 
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-icms = "I" OR
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-icms = "R" OR
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-icms = "O" OR
                                                                                           tt-ordens-desemb-acum-adicao.c-trib-icms = "D",
                                                                                           "Tributa‡Æo ser T ou I ou R ou O ou D")
      tt-ordens-desemb-acum-adicao.de-aliq-icms HELP "Al¡quota ICMS"
      tt-ordens-desemb-acum-adicao.c-trib-pis HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-pis = "T" OR 
                                                                                 tt-ordens-desemb-acum-adicao.c-trib-pis = "I" OR
                                                                                 tt-ordens-desemb-acum-adicao.c-trib-pis = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb-acum-adicao.de-aliq-pis HELP "Aliquota PIS Externo"
      tt-ordens-desemb-acum-adicao.c-trib-cofins HELP "T-Tributado I-Isento O-Outros " VALIDATE(tt-ordens-desemb-acum-adicao.c-trib-cofins = "T" OR 
                                                                                 tt-ordens-desemb-acum-adicao.c-trib-cofins = "I" OR
                                                                                 tt-ordens-desemb-acum-adicao.c-trib-cofins = "O",
                                                                                 "Tributa‡Æo ser T ou I ou O")
      tt-ordens-desemb-acum-adicao.de-aliq-cofins HELP "Aliquota COFINS Externo"

      /******************************************************
      * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
      ******************************************************/
      &IF DEFINED(bf-mat-comex) &THEN
      &ELSE
          tt-ordens-desemb-acum-adicao.l-suspensao-II  HELP "SuspensÆo Imposto Importa‡Æo - Sim/NÆo"
          tt-ordens-desemb-acum-adicao.l-suspensao-IPI HELP "SuspensÆo IPI - Sim/NÆo"
      &ENDIF
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 9.75
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     de-tx-siscomex AT ROW 20.04 COL 70.14 COLON-ALIGNED
     i-peso AT ROW 5.42 COL 3.43 HELP
          "Informar Peso Unit rio ou Peso Total" NO-LABEL
     TEXT-2 AT ROW 7.83 COL 32 COLON-ALIGNED NO-LABEL
     i-quantidade AT ROW 4.88 COL 24 HELP
          "Visualizar a quantidade na unidade interna/externa" NO-LABEL
     i-classifica AT ROW 4.88 COL 59 HELP
          "Visualizar por Item ou Classifica‡Æo Fiscal" NO-LABEL
     rs-ordena AT ROW 8.58 COL 10.57 HELP
          "Ordenar Informa‡äes por Ordem Compra/Item/Class Fiscal/Adi‡äes" NO-LABEL
     brSon1 AT ROW 10.25 COL 1.57
     brSon2 AT ROW 10.25 COL 1.57
     btParam AT ROW 20.04 COL 1.57 HELP
          "Filtro"
     btConfirm AT ROW 1.13 COL 1.57 HELP
          "Confirma as altera‡äes"
     btReload AT ROW 1.13 COL 5.57 HELP
          "Recarrega informa‡äes dos itens"
     tt-embarque-imp.cod-estabel AT ROW 3 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-embarque-imp.embarque AT ROW 3 COL 57.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     brSon3 AT ROW 10.25 COL 1.57
     "  Informa:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.25 COL 2
     "Visualiza‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 4.25 COL 21.72
     RECT-1 AT ROW 4.54 COL 1
     RECT-3 AT ROW 8.17 COL 1
     RECT-4 AT ROW 4.54 COL 20
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 20.33
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-desemb T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field c-it-codigo like item.it-codigo
          field c-desc-item AS CHAR FORMAT "x(60)"
          field c-un like item.un
          FIELD c-un-item LIKE item.un
          FIELD c-un-fornec LIKE item.un
          field de-quantidade like ordens-embarque.quantidade
          field de-peso-bruto AS DECIMAL FORMAT '>>>>,>>9.9999999999' /*like item.peso-bruto*/
          field de-peso-bruto-unit AS DECIMAL FORMAT '>>>>,>>9.9999999999' /*like item.peso-bruto*/
          field de-peso-liquido AS DECIMAL FORMAT '>>>>,>>9.9999999999' /*like item.peso-liquido*/
          field de-peso-liquido-unit AS DECIMAL FORMAT '>>>>,>>9.9999999999' /*like item.peso-liquido*/
          field i-trib-ii as integer
          field c-trib-ii as char format "!" label "Tributa‡Æo II"
          field c-desc-ii as char format "x(10)" label "Tributa‡Æo II"
          field i-trib-ipi as integer
          field c-trib-ipi as char format "!" label "Tributa‡Æo IPI"
          field c-desc-ipi as char format "x(10)" label "Tributa‡Æo IPI"
          field i-trib-icms as integer
          field c-trib-icms as char format "!" label "Tributa‡Æo ICMS"
          field c-desc-icms as char format "x(10)" label "Tributa‡Æo ICMS"
          field i-trib-pis as integer
          field c-trib-pis as char format "!" label "Tributa‡Æo PIS"
          field c-desc-pis as char format "x(10)" label "Tributa‡Æo PIS"
          field i-trib-cofins as integer
          field c-trib-cofins as char format "!" label "Tributa‡Æo COFINS"
          field c-desc-cofins as char format "x(10)" label "Tributa‡Æo COFINS"
          field de-aliq-ii     AS DECIMAL FORMAT ">>>9.99" label "% II"
          field de-aliq-ipi    AS DECIMAL FORMAT ">>>9.99" label "% IPI"
          field de-aliq-icms   AS DECIMAL FORMAT ">>>9.99" label "% ICMS"
          FIELD de-aliq-pis    AS DECIMAL FORMAT ">>>9.99" label "% EXTERNO PIS"
          FIELD de-aliq-cofins AS DECIMAL FORMAT ">>>9.99" label "% EXTERNO COFINS"
          FIELD c-class-fiscal AS CHAR FORMAT "9999.99.99" LABEL "Class Fisc"
          /******************************************************
          * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
          ******************************************************/
          &IF DEFINED(bf-mat-comex) &THEN
          &ELSE
              FIELD l-suspensao-II  AS LOGICAL FORMAT "Sim/NÆo" LABEL "Susp II"
              FIELD l-suspensao-IPI AS LOGICAL FORMAT "Sim/NÆo" LABEL "Susp IPI"
          &ENDIF
          &if "{&bf_mat_versao_ems}" >= "2.05" &then
              &if "{&bf_mat_versao_ems}" >= "2.062" &then
                  field de-cubagem like ordens-embarque.val-cub-tot
                  field de-cubagem-tot like ordens-embarque.val-cub-tot
                  FIELD de-peso-embal LIKE ordens-embarque.val-peso-embal
              &else
                  field de-cubagem like ordens-embarque.val-cub-uni
                  field de-cubagem-unit like ordens-embarque.val-cub-uni
              &endif
          &endif
          FIELD cdn-adicao AS INTEGER FORMAT ">>>9" LABEL "Nr.Adi‡Æo"
          FIELD de-taxa-siscomex AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" LABEL "Taxa Siscomex"
          FIELD seq-item   AS CHAR FORMAT "x(4)" LABEL "Seq. Item Adi‡Æo"
          FIELD r-rowid    AS ROWID
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
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
         HEIGHT             = 20.38
         WIDTH              = 90.29
         MAX-HEIGHT         = 21
         MAX-WIDTH          = 90.57
         VIRTUAL-HEIGHT     = 21
         VIRTUAL-WIDTH      = 90.57
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brSon1 rs-ordena fPage0 */
/* BROWSE-TAB brSon2 brSon1 fPage0 */
/* BROWSE-TAB brSon3 rtToolBar fPage0 */
/* SETTINGS FOR FILL-IN de-tx-siscomex IN FRAME fPage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage0
DO:
    IF  INPUT FRAME fPage0 i-peso = 1 THEN /* unitario */
        ASSIGN tt-ordens-desemb.de-peso-bruto  :FORMAT IN BROWSE brSon1 = '>>>>>>>,>>9.9999999999'
               tt-ordens-desemb.de-peso-liquido:FORMAT IN BROWSE brSon1 = '>>>>>>>,>>9.9999999999'.
    ELSE
        ASSIGN tt-ordens-desemb.de-peso-bruto  :FORMAT IN BROWSE brSon1 = '>>>>>>>,>>9.99999'
               tt-ordens-desemb.de-peso-liquido:FORMAT IN BROWSE brSon1 = '>>>>>>>,>>9.99999'.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON ROW-DISPLAY OF brSon2 IN FRAME fPage0
DO:
    ASSIGN tt-ordens-desemb-acum.de-peso-bruto  :FORMAT IN BROWSE brSon2 = '>>>>>>>,>>9.99999'
           tt-ordens-desemb-acum.de-peso-liquido:FORMAT IN BROWSE brSon2 = '>>>>>>>,>>9.99999'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon3
&Scoped-define SELF-NAME brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon3 wMasterDetail
ON ROW-DISPLAY OF brSon3 IN FRAME fPage0
DO:
    ASSIGN tt-ordens-desemb-acum-adicao.de-peso-bruto  :FORMAT IN BROWSE brSon3 = '>>>>>>>,>>9.99999'
           tt-ordens-desemb-acum-adicao.de-peso-liquido:FORMAT IN BROWSE brSon3 = '>>>>>>>,>>9.99999'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfirm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirm wMasterDetail
ON CHOOSE OF btConfirm IN FRAME fPage0
DO:
    IF  l-tax-siscomex THEN DO:
        /*IF  CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE b-tt-ordens-desemb.cdn-adicao = 0)
        AND CAN-FIND(FIRST tt-ordens-desemb
                     WHERE tt-ordens-desemb.cdn-adicao <> 0) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 33778,
                               INPUT "").
            RETURN NO-APPLY.
        END.*/
        
        /*IF  CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE b-tt-ordens-desemb.de-taxa-siscomex = 0)
        AND CAN-FIND(FIRST tt-ordens-desemb
                     WHERE tt-ordens-desemb.de-taxa-siscomex <> 0) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 33684,
                               INPUT "").
            RETURN NO-APPLY.
        END.*/
        
        IF  CAN-FIND(FIRST tt-ordens-desemb
                     WHERE tt-ordens-desemb.de-taxa-siscomex <> 0
                       AND tt-ordens-desemb.cdn-adicao = 0) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 33799,
                               INPUT "").
            RETURN NO-APPLY.
        END.
    END.
    
    IF  AVAIL tt-ordens-desemb
        AND   tt-ordens-desemb.seq-item    > 0 
        AND   tt-ordens-desemb.cdn-adicao <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Nr_Adicao" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 265,
                               INPUT RETURN-VALUE).
            RETURN NO-APPLY.
    END.

    IF INPUT FRAME fPage0 i-classifica <> 1 THEN DO:
        RUN updateOrdensDesemb2 IN THIS-PROCEDURE.
        ASSIGN i-peso = 2.
    END.

    RUN updateOrdensEmbarque IN THIS-PROCEDURE.

    IF  RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    ELSE
        RETURN NO-APPLY.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wMasterDetail
ON CHOOSE OF btParam IN FRAME fPage0 /* Sele‡Æo */
DO:
  IF INPUT FRAME fPage0 i-classifica <> 1 THEN
      RUN updateOrdensDesemb2 IN THIS-PROCEDURE.

  FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
      FIND FIRST tt-ordens-desemb-aux-2 
           WHERE tt-ordens-desemb-aux-2.cod-estabel  = tt-ordens-desemb.cod-estabel
             AND tt-ordens-desemb-aux-2.embarque     = tt-ordens-desemb.embarque
             AND tt-ordens-desemb-aux-2.numero-ordem = tt-ordens-desemb.numero-ordem
             AND tt-ordens-desemb-aux-2.parcela      = tt-ordens-desemb.parcela NO-LOCK NO-ERROR.

      IF AVAIL tt-ordens-desemb-aux-2 THEN DO:
         ASSIGN tt-ordens-desemb-aux-2.de-peso-bruto   =  tt-ordens-desemb.de-peso-bruto  
                tt-ordens-desemb-aux-2.de-peso-liquido =  tt-ordens-desemb.de-peso-liquido
                tt-ordens-desemb-aux-2.c-trib-ii       =  tt-ordens-desemb.c-trib-ii      
                tt-ordens-desemb-aux-2.de-aliq-ii      =  tt-ordens-desemb.de-aliq-ii     
                tt-ordens-desemb-aux-2.c-trib-ipi      =  tt-ordens-desemb.c-trib-ipi     
                tt-ordens-desemb-aux-2.de-aliq-ipi     =  tt-ordens-desemb.de-aliq-ipi    
                tt-ordens-desemb-aux-2.c-trib-icms     =  tt-ordens-desemb.c-trib-icms    
                tt-ordens-desemb-aux-2.de-aliq-icms    =  tt-ordens-desemb.de-aliq-icms   
                tt-ordens-desemb-aux-2.c-trib-pis      =  tt-ordens-desemb.c-trib-pis     
                tt-ordens-desemb-aux-2.de-aliq-pis     =  tt-ordens-desemb.de-aliq-pis    
                tt-ordens-desemb-aux-2.c-trib-cofins   =  tt-ordens-desemb.c-trib-cofins  
                tt-ordens-desemb-aux-2.de-aliq-cofins  =  tt-ordens-desemb.de-aliq-cofins.
      END.
  END.

  RUN cxbo/bocx225e.p PERSISTENT SET h-bocx225e.
  ASSIGN l-ok = NO.
  RUN imp/im0100b1.w (INPUT tt-embarque-imp.cod-estabel,
                      INPUT tt-embarque-imp.embarque,
                      INPUT-OUTPUT i-numero-ordem-ini, 
                      INPUT-OUTPUT i-numero-ordem-fim, 
                      INPUT-OUTPUT c-item-ini,
                      INPUT-OUTPUT c-item-fim,
                      INPUT-OUTPUT c-class-fiscal-ini,
                      INPUT-OUTPUT c-class-fiscal-fim,
                      INPUT INPUT FRAME fPage0 i-classifica,
                      OUTPUT l-ok).
  
  IF l-ok = YES THEN DO:
     
     run setConstraintParam in h-bocx225e (INPUT i-numero-ordem-ini,
                                           INPUT i-numero-ordem-fim,
                                           INPUT c-item-ini,
                                           INPUT c-item-fim,
                                           INPUT c-class-fiscal-ini,
                                           INPUT c-class-fiscal-fim).

     RUN cria-tt-ordens-desemb-param IN h-bocx225e (INPUT TABLE tt-ordens-desemb-aux-2,
                                                    INPUT-OUTPUT TABLE tt-ordens-desemb).

     IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
         {&OPEN-QUERY-brSon1}
         APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
     END.
     ELSE DO:
         RUN createOrdensDesembAcum IN THIS-PROCEDURE.
         APPLY "VALUE-CHANGED":U TO rs-ordena IN FRAME fPage0.
     END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReload
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReload wMasterDetail
ON CHOOSE OF btReload IN FRAME fPage0
DO:

    RUN createOrdensDesemb     IN THIS-PROCEDURE (INPUT YES).

    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
        ASSIGN i-peso = 1.
    END.
    ELSE DO:
        ASSIGN i-peso:SCREEN-VALUE IN FRAME fPage0 = "2".
        RUN updateOrdensDesemb IN THIS-PROCEDURE.
        RUN createOrdensDesembAcum IN THIS-PROCEDURE.
        APPLY "VALUE-CHANGED":U TO rs-ordena IN FRAME fPage0.
    END.
    
    IF  INPUT FRAME fPage0 i-classifica = 3 THEN DO:
        ASSIGN de-tx-siscomex = 0.
        FOR EACH b-tt-ordens-desemb NO-LOCK
            BREAK BY b-tt-ordens-desemb.cdn-adicao:
            IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex.
        END.
        
        DISP de-tx-siscomex WITH FRAME fpage0.
    END.
    
    ASSIGN i-quantidade = 1
           l-atualizar-despesa = NO.

    DISP i-peso
         i-quantidade WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-classifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-classifica wMasterDetail
ON VALUE-CHANGED OF i-classifica IN FRAME fPage0
DO:
    ASSIGN INPUT FRAME fPage0 i-classifica.
    DO WITH FRAME fPage0:
        IF i-classifica = 1 THEN DO:
            ENABLE rs-ordena i-peso.
            ASSIGN i-classifica-ant = 1
                   rs-ordena:SCREEN-VALUE = "1"
                   de-tx-siscomex:VISIBLE = NO
                   de-tx-siscomex         = 0
                   brSon1:HIDDEN          = NO
                   brSon2:HIDDEN          = YES
                   brSon3:HIDDEN          = YES.
            RUN updateOrdensDesemb2 IN THIS-PROCEDURE.
            IF i-peso-aux = 1 THEN DO:
                ASSIGN i-peso:SCREEN-VALUE = "1"
                       i-peso     = 1
                       i-peso-ant = 2.
                RUN updateOrdensDesemb IN THIS-PROCEDURE.
            END.
            
            {&OPEN-QUERY-brSon1}  
            APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
        END.
        ELSE DO:
            IF  i-classifica-ant = 2 THEN
                RUN updateOrdensDesemb2 IN THIS-PROCEDURE.
            
            ASSIGN brSon1:HIDDEN          = YES
                   i-classifica-ant       = 2.
            DISABLE rs-ordena i-peso.
            
            IF i-peso = 1 THEN DO:
                ASSIGN i-peso-aux = 1
                       i-peso-ant = 1
                       i-peso     = 2
                       i-peso:SCREEN-VALUE = "2".
                RUN updateOrdensDesemb IN THIS-PROCEDURE.
            END.
            ELSE
                ASSIGN i-peso-aux = 1.
            
            IF  i-classifica = 2 THEN DO:
                ASSIGN rs-ordena:SCREEN-VALUE = "3"
                       de-tx-siscomex:VISIBLE = NO
                       brSon2:HIDDEN = NO
                       brSon3:HIDDEN = YES.
                ENABLE brSon2.
            END.
            ELSE DO:
                ASSIGN rs-ordena:SCREEN-VALUE = "4"
                       de-tx-siscomex:VISIBLE = YES
                       brSon2:HIDDEN = YES
                       brSon3:HIDDEN = NO.
                ENABLE brSon3.
                
                ASSIGN de-tx-siscomex = 0.
                FOR EACH b-tt-ordens-desemb NO-LOCK
                    BREAK BY b-tt-ordens-desemb.cdn-adicao:
                    IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                       ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex.
                END.
                
                DISP de-tx-siscomex WITH FRAME fpage0.
            END.
            
            RUN createOrdensDesembAcum IN THIS-PROCEDURE.
            APPLY "VALUE-CHANGED":U TO rs-ordena.    
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-peso wMasterDetail
ON VALUE-CHANGED OF i-peso IN FRAME fPage0
DO:
    ASSIGN i-peso-ant = i-peso
           INPUT FRAME fPage0 i-peso.
    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        RUN updateOrdensDesemb IN THIS-PROCEDURE.
        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-quantidade wMasterDetail
ON VALUE-CHANGED OF i-quantidade IN FRAME fPage0
DO:
    ASSIGN INPUT FRAME fPage0 i-quantidade.     
    RUN updateQtdeUnidade IN THIS-PROCEDURE.
    IF INPUT FRAME fPage0 i-classifica = 1 /* Por Item */ THEN DO:
        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
    ELSE /* Por Class Fiscal */
        APPLY "VALUE-CHANGED":U TO rs-ordena IN FRAME fPage0.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-ordena
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-ordena wMasterDetail
ON VALUE-CHANGED OF rs-ordena IN FRAME fPage0
DO:
   IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
       ASSIGN h-Query = BROWSE brson1:QUERY
              INPUT FRAME {&FRAME-NAME} rs-ordena.
       CASE rs-ordena:
          WHEN 1 THEN DO:
                 h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb NO-LOCK BY tt-ordens-desemb.numero-ordem").
                 h-Query:QUERY-OPEN().
          END.
               
          WHEN 2 THEN DO:
              h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb NO-LOCK BY tt-ordens-desemb.c-it-codigo").
              h-Query:QUERY-OPEN().
          END.
    
          WHEN 3 THEN DO:
              h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb NO-LOCK BY tt-ordens-desemb.c-class-fiscal").
              h-Query:QUERY-OPEN().
          END.
          WHEN 4 THEN DO:
              h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb NO-LOCK BY tt-ordens-desemb.cdn-adicao").
              h-Query:QUERY-OPEN().
          END.
       END CASE.
   END.
   IF INPUT FRAME fPage0 i-classifica = 2 THEN DO:
       ASSIGN h-Query = BROWSE brson2:QUERY
              INPUT FRAME {&FRAME-NAME} rs-ordena.
       h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb-acum NO-LOCK BY tt-ordens-desemb-acum.c-class-fiscal").
       h-Query:QUERY-OPEN().
   END.
   IF INPUT FRAME fPage0 i-classifica = 3 THEN DO:
       ASSIGN h-Query = BROWSE brson3:QUERY
              INPUT FRAME {&FRAME-NAME} rs-ordena.
       h-Query:QUERY-PREPARE("FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK BY tt-ordens-desemb-acum-adicao.cdn-adicao").
       h-Query:QUERY-OPEN().
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 

{imp/im0100b.i3 ERROR}

/*--- L¢gica para inicializa‡Æo do programam ---*/
ON ENTRY OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
   ASSIGN i-cdn-adicao-ant = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao.
END.

ON LEAVE OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
    BROWSE brson1:FETCH-SELECTED-ROW(1).
    brSon1:FETCH-SELECTED-ROW(brSon1:FOCUSED-ROW IN FRAME fPage0) IN FRAME fPage0 NO-ERROR.

    FIND FIRST param-imp NO-LOCK
      WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  (NOT l-fn-imp-adicao-un OR
         &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
             SUBSTR(param-imp.char-1,105,1) = '0'
         &ELSE
             NOT param-imp.log-tax-siscomex
         &ENDIF) AND 
        CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
                       AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                       AND b-tt-ordens-desemb.cdn-adicao <> 0
                       AND b-tt-ordens-desemb.c-un <> tt-ordens-desemb.c-un) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-un AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "UN" *}
        ASSIGN c-lbl-liter-un = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Unidade_de_Medida" *}
        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 33557,
                           INPUT c-lbl-liter-un + "~~" +
                                 c-lbl-liter-unidade-de-medida).
        RETURN NO-APPLY.
    END.
    
    IF  CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
                       AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                       AND b-tt-ordens-desemb.cdn-adicao <> 0
                       AND b-tt-ordens-desemb.c-class-fiscal <> tt-ordens-desemb.c-class-fiscal) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-classificacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classifica‡Æo" *}
        ASSIGN c-lbl-liter-classificacao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classifica‡Æo_Fiscal" *}
        ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 33557,
                           INPUT c-lbl-liter-classificacao + "~~" +
                                 c-lbl-liter-classificacao-fiscal).
        RETURN NO-APPLY.
    END.

    IF  i-cdn-adicao-ant <> INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao THEN DO:
        FIND FIRST b-tt-ordens-desemb EXCLUSIVE-LOCK
             WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
               AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao NO-ERROR.
        IF  AVAIL b-tt-ordens-desemb THEN DO:
            IF  tt-ordens-desemb.de-taxa-siscomex <> b-tt-ordens-desemb.de-taxa-siscomex THEN
                ASSIGN l-atualizar-despesa = YES.
            
            ASSIGN tt-ordens-desemb.de-taxa-siscomex = b-tt-ordens-desemb.de-taxa-siscomex.
        END.
        ELSE DO:
            IF  tt-ordens-desemb.de-taxa-siscomex <> 0 THEN
                ASSIGN l-atualizar-despesa = YES.
            
            ASSIGN tt-ordens-desemb.de-taxa-siscomex = 0.
        END.
    END.
END.

ON ENTRY OF tt-ordens-desemb-acum-adicao.de-taxa-siscomex IN BROWSE brSon3
DO:
   ASSIGN de-tx-siscomex-ant = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.
END.

ON LEAVE OF tt-ordens-desemb-acum-adicao.de-taxa-siscomex IN BROWSE brSon3
DO:
   IF  INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex <> de-tx-siscomex-ant THEN
       ASSIGN l-atualizar-despesa = YES.
   
   ASSIGN de-tx-siscomex = de-tx-siscomex +
          (INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex - de-tx-siscomex-ant)
          de-tx-siscomex-ant = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.
   DISP de-tx-siscomex WITH FRAME fpage0.
   
   FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK
       WHERE tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum-adicao.cdn-adicao
         AND tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum-adicao.c-class-fiscal:
       ASSIGN tt-ordens-desemb.de-taxa-siscomex = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.
   END.
END.

{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin245) THEN DO:
        DELETE PROCEDURE h-boin245.
        ASSIGN h-boin245 = ?.
    END.

    IF VALID-HANDLE(h-boin292) THEN DO:
        DELETE PROCEDURE h-boin292.
        ASSIGN h-boin292 = ?.
    END.

    IF VALID-HANDLE(h-boin046na) THEN DO:
        DELETE PROCEDURE h-boin046na.
        ASSIGN h-boin046na = ?.
    END.
    
    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wMasterDetail 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN brSon1:HIDDEN IN FRAME fPage0 = NO
           brSon2:HIDDEN IN FRAME fPage0 = YES
           brSon3:HIDDEN IN FRAME fPage0 = YES
           brSon1:NUM-LOCKED-COLUMNS IN FRAME fPage0 = 3
           brSon2:NUM-LOCKED-COLUMNS IN FRAME fPage0 = 2.

    ENABLE i-peso
           i-quantidade 
           i-classifica
           rs-ordena
           btConfirm
           btReload
           btParam
           brSon1
           WITH FRAME fPage0.

    DISP TEXT-2 WITH FRAME fpage0.
    
    RUN findCodigo IN h-bocx250 (INPUT p-cod-estabel, OUTPUT c-erro).
    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
        RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex",
                                      OUTPUT l-tax-siscomex).
    &ELSE
        RUN getCharField IN h-bocx250 (INPUT "char-1",
                                       OUTPUT c-tax-siscomex).
        ASSIGN l-tax-siscomex = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO.
    &ENDIF
    
    IF  NOT l-tax-siscomex THEN
        i-classifica:DISABLE("Por Adi‡äes do Embarque") IN FRAME fPage0.
    
    APPLY "VALUE-CHANGED":U TO i-classifica IN FRAME fPage0.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wMasterDetail 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF p-usuario  = "" OR
       p-nat-operacao = "" THEN
        RUN setUsuarioNatureza IN THIS-PROCEDURE.
    ELSE
        ASSIGN l-usuarionatureza = YES.

    IF NOT l-usuarionatureza THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countNumOrdensEmbarque wMasterDetail 
PROCEDURE countNumOrdensEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN inumRowsReturned = 0.

    RUN countNumOrdensEmbarque IN {&hDBOSon1} (INPUT tt-embarque-imp.cod-estabel,
                                               INPUT tt-embarque-imp.embarque,
                                               OUTPUT inumRowsReturned).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOrdensDesemb wMasterDetail 
PROCEDURE createOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-recarrega AS LOGICAL NO-UNDO.

    RUN loadOrdensDesemb IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque,
                                         INPUT p-nat-operacao,
                                         INPUT p-usuario,
                                         INPUT p-recarrega,
                                         INPUT p-icms-diferido,
                                         INPUT (i-peso = 2),
                                         INPUT p-recarrega, /* p-imp-import     */
                                         INPUT p-recarrega, /* p-imp-prod-ind   */
                                         INPUT p-recarrega, /* p-imp-circ-serv  */
                                         INPUT p-recarrega, /* p-prg-integ-soc  */
                                         INPUT p-recarrega, /* p-cont-segur-soc */
                                         INPUT p-recarrega, /* IBS UF */
                                         INPUT p-recarrega, /* IBS Mun */
                                         INPUT p-recarrega, /* CBS */
                                         INPUT p-recarrega, /* p-peso-bruto     */
                                         INPUT p-recarrega, /* p-peso-liquido   */
                                         INPUT p-recarrega, /* p-cubagem        */
                                         OUTPUT TABLE tt-ordens-desemb,
                                         OUTPUT TABLE tt-bo-erro).

    /* 
    ** Cria‡Æo da tt-ordens-desemb-aux-2 para no caso do usu rio nao informar nenhum 
    ** dado no programa de Sele‡Æo (IM0100B1), solicitando para que sejam carregadas 
    ** todas as ordens-embarque do embarque, o browser seja carregado com todas as 
    ** informa‡äes referentes ao mesmo
    */
    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:   
        FIND FIRST tt-ordens-desemb-aux-2
             WHERE tt-ordens-desemb-aux-2.cod-estabel  = tt-ordens-desemb.cod-estabel
               AND tt-ordens-desemb-aux-2.embarque     = tt-ordens-desemb.embarque
               AND tt-ordens-desemb-aux-2.numero-ordem = tt-ordens-desemb.numero-ordem
               AND tt-ordens-desemb-aux-2.parcela      = tt-ordens-desemb.parcela NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-ordens-desemb-aux-2 THEN DO:
            CREATE tt-ordens-desemb-aux-2.
            BUFFER-COPY tt-ordens-desemb TO tt-ordens-desemb-aux-2.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOrdensDesembAcum wMasterDetail 
PROCEDURE createOrdensDesembAcum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Cria‡Æo da tt-ordens-desemb-acum (tt-ordens-desemb acumulada por classifica‡Æo fiscal e unidade)*/
    EMPTY TEMP-TABLE tt-ordens-desemb-acum.
    EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao.

    FIND FIRST param-imp NO-LOCK
      WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  i-classifica = 2 THEN DO:
        {imp/im0100b.i}
    END.
    ELSE DO:
        IF NOT l-fn-imp-adicao-un OR
           &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
               SUBSTR(param-imp.char-1,105,1) = '0'
           &ELSE
               NOT param-imp.log-tax-siscomex
           &ENDIF THEN DO:
            {imp/im0100b.i "BY tt-ordens-desemb.cdn-adicao" 
                           "FIRST-OF(tt-ordens-desemb.cdn-adicao) OR"
                           "LAST-OF(tt-ordens-desemb.cdn-adicao) OR"}

            FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
                CREATE tt-ordens-desemb-acum-adicao.
                BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-desemb-acum-adicao.
            END.
        END.
        ELSE DO:
            {imp/im0100b.i4}
        END.
    END.
    
    EMPTY TEMP-TABLE tt-ordens-desemb-acum-aux.
    FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
        CREATE tt-ordens-desemb-acum-aux.
        BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-desemb-acum-aux.
    END.

    IF l-fn-imp-adicao-un OR
      &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
          SUBSTR(param-imp.char-1,105,1) = '1'
      &ELSE
          param-imp.log-tax-siscomex
      &ENDIF THEN DO:
        EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao-aux.
        FOR EACH tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK:
            CREATE tt-ordens-desemb-acum-adicao-aux.
            BUFFER-COPY tt-ordens-desemb-acum-adicao TO tt-ordens-desemb-acum-adicao-aux.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteOrdensDesemb wMasterDetail 
PROCEDURE deleteOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        DELETE tt-ordens-desemb.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-return AS CHAR NO-UNDO.
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx220.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220.p YES}
        {btb/btb008za.i2 cxbo/bocx220.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraint1 IN {&hDBOParent} NO-ERROR.
    RUN openQuery      IN {&hDBOParent} (INPUT 1) NO-ERROR.
    RUN findPk_Codigo  IN {&hDBOParent} (INPUT p-cod-estabel,
                                         INPUT p-embarque,
                                         OUTPUT c-return).
    IF c-return = "" THEN
        RUN getRowid IN {&hDBOParent} (OUTPUT gr-embarque-imp).
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "cxbo/bocx225e.p":U THEN DO:
        RUN cxbo/bocx225e.p PERSISTENT SET {&hDBOSon1}.
    END.

    IF NOT VALID-HANDLE(h-boin046na) OR
       h-boin046na:TYPE <> "PROCEDURE":U OR
       h-boin046na:FILE-NAME <> "inbo/boin046na.p":U THEN DO:
        RUN inbo/boin046na.p PERSISTENT SET h-boin046na.
        RUN openQueryStatic IN h-boin046na (INPUT "Main":U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN countNumOrdensEmbarque IN THIS-PROCEDURE.

    RUN deleteOrdensDesemb IN THIS-PROCEDURE.

    IF VALID-HANDLE({&hDBOSon1}) THEN DO:
        RUN setConstraint2  IN {&hDBOSon1} (INPUT tt-embarque-imp.cod-estabel,
                                            INPUT tt-embarque-imp.embarque).
        RUN openQuery       IN {&hDBOSon1} (INPUT 2) NO-ERROR.
        RUN findFirst       IN {&hDBOSon1}.
        RUN serverSendRows  IN {&hDBOSon1} (input  ?,                      
                                            input  ?,                     
                                            input  NO,                      
                                            input  0,     
                                            output iNrRegistro,
                                            output table {&ttSon1}).
                
        RUN createOrdensDesemb IN THIS-PROCEDURE (INPUT NO).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reloadOrdensDesemb wMasterDetail 
PROCEDURE reloadOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR tt-ordens-desemb-aux.

FOR EACH tt-ordens-desemb-aux EXCLUSIVE-LOCK:

    FIND FIRST tt-ordens-desemb EXCLUSIVE-LOCK WHERE
               tt-ordens-desemb.cod-estabel  = input frame {&frame-name} tt-embarque-imp.cod-estabel AND
               tt-ordens-desemb.embarque     = input frame {&frame-name} tt-embarque-imp.embarque    AND
               tt-ordens-desemb.numero-ordem = tt-ordens-desemb-aux.numero-ordem                     AND
               tt-ordens-desemb.parcela      = tt-ordens-desemb-aux.parcela NO-ERROR.
    IF AVAIL tt-ordens-desemb THEN DO:
        
        ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb-aux.peso-bruto
               tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb-aux.peso-liquido
               tt-ordens-desemb.c-trib-ii       = tt-ordens-desemb-aux.trib-II
               tt-ordens-desemb.de-aliq-ii      = tt-ordens-desemb-aux.aliq-II
               tt-ordens-desemb.c-trib-ipi      = tt-ordens-desemb-aux.trib-IPI
               tt-ordens-desemb.de-aliq-ipi     = tt-ordens-desemb-aux.aliq-IPI
               tt-ordens-desemb.c-trib-icms     = tt-ordens-desemb-aux.trib-ICMS
               tt-ordens-desemb.de-aliq-icms    = tt-ordens-desemb-aux.aliq-ICMS       
               tt-ordens-desemb.c-trib-pis      = tt-ordens-desemb-aux.trib-PIS
               tt-ordens-desemb.de-aliq-pis     = tt-ordens-desemb-aux.aliq-pis
               tt-ordens-desemb.c-trib-cofins   = tt-ordens-desemb-aux.trib-cofins
               tt-ordens-desemb.de-aliq-cofins  = tt-ordens-desemb-aux.aliq-cofins.       
    END.
 
END.

{&open-query-brSon1}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsuarioNatureza wMasterDetail 
PROCEDURE setUsuarioNatureza :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-usuarionatureza = YES.

    &IF DEFINED(bf-mat-comex) &THEN
    &ELSE
        IF NOT VALID-HANDLE(h-boin245) THEN
            RUN inbo/boin245.p PERSISTENT SET h-boin245.
        RUN openQueryStatic IN h-boin245 (INPUT "Main":U).    
    &ENDIF
    
    &IF DEFINED(bf-mat-comex) &THEN
    &ELSE
        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            IF NOT VALID-HANDLE(h-boin292) THEN
                RUN inbo/boin292.p PERSISTENT SET h-boin292.
            RUN openQueryStatic IN h-boin292 (INPUT "Main":U).
        &ENDIF
    &ENDIF
    
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
    
    DEFINE VARIABLE cusuario  LIKE param-re.usuario NO-UNDO.
    DEFINE VARIABLE cnatureza AS CHAR FORMAT "x(6)"/*LIKE natur-oper.nat-operacao*/  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cusuario   LABEL "Usu rio" AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cnatureza  LABEL "Natureza de Opera‡Æo" AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informa Usu rio/Natureza" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "Informa_Usu rio/Natureza"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ASSIGN cusuario:WIDTH IN FRAME fGoToRecord = 15.00
           cusuario:HEIGHT IN FRAME fGoToRecord = 0.88
           cnatureza:WIDTH IN FRAME fGoToRecord = 9.00
           cnatureza:HEIGHT IN FRAME fGoToRecord = 0.88.

    ASSIGN cusuario:SCREEN-VALUE IN FRAME fGoToRecord = c-seg-usuario.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cusuario cnatureza.
        IF cusuario = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Usu rio" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 265,
                               INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        ELSE DO:
            
            &IF DEFINED(bf-mat-comex) &THEN
                FIND param-re
                    WHERE param-re.usuario = cusuario NO-LOCK NO-ERROR.
                IF NOT AVAIL param-re THEN DO:
            &ELSE
                &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
                    RUN gotoKey IN h-boin292 (INPUT cusuario).
                    IF RETURN-VALUE = "NOK":U THEN DO:
                &ENDIF
            &ENDIF
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Usu rio_do_Recebimento" *}
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 2,
                                       INPUT RETURN-VALUE).
                    RETURN NO-APPLY.
                END.
        END.
        
        IF cnatureza = "" THEN DO:
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Natureza_de_opera‡Æo" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 265,
                               INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        ELSE DO:
            &IF DEFINED(bf-mat-comex) &THEN
                FIND natur-oper
                    WHERE natur-oper.nat-operacao = cnatureza NO-LOCK NO-ERROR.
                IF NOT AVAIL natur-oper THEN DO:
            &ELSE
                RUN gotokey IN h-boin245 (INPUT cnatureza).
                IF RETURN-VALUE = "NOK":U THEN DO:            
            &ENDIF
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Natureza_de_opera‡Æo" *}
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 2,
                                       INPUT RETURN-VALUE).
                    RETURN NO-APPLY.
                END.
        END.

        ASSIGN p-usuario      = cusuario
               p-nat-operacao = cnatureza.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ON "choose":U OF btGoToCancel IN FRAME fGotoRecord DO:
        ASSIGN l-usuarionatureza = NO.
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cusuario cnatureza btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord.
    
    APPLY "entry":U TO cnatureza IN FRAME fGotoRecord.
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensDesemb wMasterDetail 
PROCEDURE updateOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF i-peso-ant = 2 THEN
            ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   / tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido / tt-ordens-desemb.quantidade.
        IF i-peso-ant = 1 THEN
            ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto  
                   tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido.
    END.
    ASSIGN i-peso-ant = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:

        IF INPUT FRAME fPage0 i-quantidade = 1 THEN /* interna */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.quantidade
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-item.
        ELSE /* fornecedor */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.qt-do-forn
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-fornec.

        IF INPUT FRAME fPage0 i-peso = 1 THEN /* unitario */
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit.
        ELSE /* total */
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit   * tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit * tt-ordens-desemb.quantidade.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensDesemb2 wMasterDetail 
PROCEDURE updateOrdensDesemb2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-diferenca-peso-bruto   AS DECIMAL FORMAT ">>>,>>>,>>9.99999"   NO-UNDO.
DEFINE VARIABLE de-diferenca-peso-liq     AS DECIMAL FORMAT ">>>,>>>,>>9.99999"   NO-UNDO.
DEFINE VARIABLE de-tot-peso-bruto-rateado AS DECIMAL FORMAT ">>>,>>>,>>9.99999"   NO-UNDO.
DEFINE VARIABLE de-tot-peso-liq-rateado   AS DECIMAL FORMAT ">>>,>>>,>>9.99999"   NO-UNDO.

  ASSIGN l-atualiza-pesos = NO.
  FOR EACH tt-ordens-desemb-acum-aux EXCLUSIVE-LOCK:
      IF CAN-FIND(FIRST  tt-ordens-desemb-acum
                  WHERE  tt-ordens-desemb-acum.cdn-adicao       = tt-ordens-desemb-acum-aux.cdn-adicao
                    AND  tt-ordens-desemb-acum.c-class-fiscal   = tt-ordens-desemb-acum-aux.c-class-fiscal
                    AND  tt-ordens-desemb-acum.c-un             = tt-ordens-desemb-acum-aux.c-un
                    AND (tt-ordens-desemb-acum.de-peso-bruto   <> tt-ordens-desemb-acum-aux.de-peso-bruto
                     OR  tt-ordens-desemb-acum.de-peso-liquido <> tt-ordens-desemb-acum-aux.de-peso-liquido)) THEN
          ASSIGN l-atualiza-pesos = YES.
  END.

  FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:

      ASSIGN de-tot-peso-bruto-rateado = 0
             de-tot-peso-liq-rateado   = 0.
      
      IF INPUT FRAME fPage0 i-classifica = 3 THEN DO:
          IF NOT l-fn-imp-adicao-un THEN DO:
              {imp/im0100b.i2 "tt-ordens-desemb.cdn-adicao = tt-ordens-desemb-acum.cdn-adicao AND"}
          END.
      END.
      ELSE DO:
          {imp/im0100b.i2}
      END.
      
      IF l-atualiza-pesos THEN
          IF de-tot-peso-bruto-rateado <> tt-ordens-desemb-acum.de-peso-bruto OR 
             de-tot-peso-liq-rateado   <> tt-ordens-desemb-acum.de-peso-liquido THEN DO:
              ASSIGN de-diferenca-peso-bruto = tt-ordens-desemb-acum.de-peso-bruto   - de-tot-peso-bruto-rateado
                     de-diferenca-peso-liq   = tt-ordens-desemb-acum.de-peso-liquido - de-tot-peso-liq-rateado.
              FIND LAST tt-ordens-desemb
                  WHERE tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum.cdn-adicao
                    AND tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                    AND tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un EXCLUSIVE-LOCK NO-ERROR.
              IF AVAIL tt-ordens-desemb THEN
                  ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto   + de-diferenca-peso-bruto
                         tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido + de-diferenca-peso-liq.
          END.
  END.

  FIND FIRST param-imp NO-LOCK
      WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

  IF l-fn-imp-adicao-un OR 
      &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
          SUBSTR(param-imp.char-1,105,1) = '1'
      &ELSE
          param-imp.log-tax-siscomex
      &ENDIF THEN
      IF i-classifica     = 3
      OR i-classifica-ant = 3 THEN DO:
          FOR EACH tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK:

              IF INPUT FRAME fPage0 i-classifica = 3 THEN DO:
                  {imp/im0100b.i5}
              END.

              IF NOT CAN-FIND(FIRST  tt-ordens-desemb-acum-adicao-aux
                          WHERE  tt-ordens-desemb-acum-adicao-aux.cdn-adicao       = tt-ordens-desemb-acum-adicao.cdn-adicao
                            AND  tt-ordens-desemb-acum-adicao-aux.c-class-fiscal   = tt-ordens-desemb-acum-adicao.c-class-fiscal
                            AND  tt-ordens-desemb-acum-adicao-aux.c-un             = tt-ordens-desemb-acum-adicao.c-un
                            AND (tt-ordens-desemb-acum-adicao-aux.de-peso-bruto   <> tt-ordens-desemb-acum-adicao.de-peso-bruto
                             OR  tt-ordens-desemb-acum-adicao-aux.de-peso-liquido <> tt-ordens-desemb-acum-adicao.de-peso-liquido)) THEN NEXT.
              
              FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK
                 WHERE tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum-adicao.cdn-adicao
                   AND tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum-adicao.c-class-fiscal:
    
                  FIND FIRST item 
                      WHERE item.it-codigo = tt-ordens-desemb.c-it-codigo NO-LOCK NO-ERROR.
                  FIND FIRST classif-fisc
                      WHERE classif-fisc.class-fiscal = item.class-fiscal NO-LOCK NO-ERROR.
                  
                  IF tt-ordens-desemb.c-un <> classif-fisc.unidade THEN
                      ASSIGN tt-ordens-desemb.de-peso-bruto   = (tt-ordens-desemb-acum-adicao.de-peso-bruto   * tt-ordens-desemb.de-quantidade ) / (tt-ordens-desemb-acum-adicao.de-quantidade * item.fator-conver) 
                             tt-ordens-desemb.de-peso-liquido = (tt-ordens-desemb-acum-adicao.de-peso-liquido * tt-ordens-desemb.de-quantidade ) / (tt-ordens-desemb-acum-adicao.de-quantidade * item.fator-conver). 
                  ELSE
                      ASSIGN tt-ordens-desemb.de-peso-bruto   = (tt-ordens-desemb-acum-adicao.de-peso-bruto   * tt-ordens-desemb.de-quantidade ) /  tt-ordens-desemb-acum-adicao.de-quantidade 
                             tt-ordens-desemb.de-peso-liquido = (tt-ordens-desemb-acum-adicao.de-peso-liquido * tt-ordens-desemb.de-quantidade ) /  tt-ordens-desemb-acum-adicao.de-quantidade.
              END.
          END.
      END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensEmbarque wMasterDetail 
PROCEDURE updateOrdensEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  l-atualizar-despesa THEN DO:
        ASSIGN de-tx-siscomex = 0.
        FOR EACH b-tt-ordens-desemb NO-LOCK
            BREAK BY b-tt-ordens-desemb.cdn-adicao:
            IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex.
        END.
        
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.
        RUN atzDespesaEmbarque IN h-bocx310 (INPUT INPUT FRAME {&FRAME-NAME} tt-embarque-imp.cod-estabel,
                                             INPUT INPUT FRAME {&FRAME-NAME} tt-embarque-imp.embarque,
                                             INPUT de-tx-siscomex,
                                             OUTPUT TABLE tt-bo-erro).
        
        IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
            IF  NOT VALID-HANDLE(hShowMsg) THEN
                RUN utp/showmessage.w PERSISTENT SET hShowMsg.
            ELSE DO:
                DELETE PROCEDURE hShowMsg.        
                RUN utp/showmessage.w PERSISTENT SET hShowMsg.
            END.
            RUN setModal     IN hShowMsg (INPUT YES).
            RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).        
            RETURN "NOK":U.
        END.
    END.
    
    RUN updateOrdensEmbarque IN h-bocx225e (INPUT TABLE tt-ordens-desemb,
                                            INPUT i-peso,
                                            INPUT "",
                                            OUTPUT TABLE tt-bo-erro).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQtdeUnidade wMasterDetail 
PROCEDURE updateQtdeUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF i-quantidade = 1 THEN /* interna */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.quantidade
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-item.
        ELSE /* fornecedor */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.qt-do-forn
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-fornec.
    END.

    IF INPUT FRAME fPage0 i-classifica = 2 THEN
        FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
            IF i-quantidade = 1 THEN /* interna */
                ASSIGN tt-ordens-desemb-acum.de-quantidade = tt-ordens-desemb-acum.quantidade
                       tt-ordens-desemb-acum.c-un          = tt-ordens-desemb-acum.c-un-item.
            ELSE /* fornecedor */
                ASSIGN tt-ordens-desemb-acum.de-quantidade = tt-ordens-desemb-acum.qt-do-forn
                       tt-ordens-desemb-acum.c-un          = tt-ordens-desemb-acum.c-un-fornec.
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAliqIcms wMasterDetail 
FUNCTION fnAliqIcms RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN de-aliq-icms.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAliqIi wMasterDetail 
FUNCTION fnAliqIi RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN de-aliq-ii.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAliqIpi wMasterDetail 
FUNCTION fnAliqIpi RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN de-aliq-ipi.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClassFiscal wMasterDetail 
FUNCTION fnClassFiscal RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-class-fiscal AS CHAR NO-UNDO.
 
    RETURN c-class-fiscal.    /* Function return-value */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescClassFiscal wMasterDetail 
FUNCTION fnDescClassFiscal RETURNS CHARACTER
  ( c-class-fiscal AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(h-boin046na) THEN DO:
      RUN goToKey         IN h-boin046na (INPUT c-class-fiscal).
      IF RETURN-VALUE = "OK":U THEN
          RUN getCharField IN h-boin046na (INPUT "descricao",
                                           OUTPUT c-desc-classif).
  END.

  RETURN c-desc-classif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-desc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  ( INPUT p-numero-ordem AS INTEGER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
/*

    RUN gotokey IN h-boin274na (INPUT p-numero-ordem).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN  h-boin274na (INPUT "it-codigo":U,OUTPUT c-it-codigo).

        RUN gotoKey IN h-boin172na (INPUT c-it-codigo).
        RUN getCharField IN h-boin172na (INPUT "desc-item":U,OUTPUT c-desc-item).
        RUN getCharField IN h-boin172na (INPUT "un":U,OUTPUT c-un).
        RUN getDecField IN h-boin172na (INPUT "peso-bruto":U,OUTPUT de-peso-bruto).
        RUN getDecField IN h-boin172na (INPUT "peso-liquido":U,OUTPUT de-peso-liquido).
        RUN getDecField IN h-boin172na (INPUT "aliquota-ipi":U,OUTPUT de-aliq-ipi).
        RUN getDecField IN h-boin172na (INPUT "aliquota-icm":U,OUTPUT de-aliq-icms).
        RUN getIntField IN h-boin172na (INPUT "cd-trib-ipi":U,OUTPUT i-trib-ipi).
        RUN getIntField IN h-boin172na (INPUT "cd-trib-icm":U,OUTPUT i-trib-icms).
        RUN getCharfield IN h-boin172na (INPUT "char-2":U,OUTPUT c-item-char-2).
        ASSIGN i-trib-ii  = INTEGER(TRIM(SUBSTRING(c-item-char-2,20,2))).
        ASSIGN de-aliq-ii = DECIMAL(TRIM(SUBSTRING(c-item-char-2,22,6))).

    END. */

    RETURN c-it-codigo.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF i-peso = 2 THEN
      ASSIGN de-peso-bruto = de-peso-bruto * tt-ordens-embarque.quantidade.

  RETURN de-peso-bruto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoLiquido wMasterDetail 
FUNCTION fnPesoLiquido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF i-peso = 2 THEN
      ASSIGN de-peso-liquido = de-peso-liquido * tt-ordens-embarque.quantidade.

  RETURN de-peso-liquido.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF i-quantidade = 1 THEN /* Unidade Interna */
        RETURN tt-ordens-embarque.quantidade.
    ELSE /* 2 - Unidade Fornecedor */ 
        RETURN tt-ordens-embarque.qt-do-forn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTribIcms wMasterDetail 
FUNCTION fnTribIcms RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {ininc/i07in122.i 04 i-trib-icms}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-icms = RETURN-VALUE.
  &else
      ASSIGN c-trib-icms = {ininc/i07in122.i 04 i-trib-icms}.
  &endif

  RETURN c-trib-icms.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTribIi wMasterDetail 
FUNCTION fnTribIi RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao002 = {ininc/i10in172.i 04 i-trib-ii}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-ii = RETURN-VALUE.
  &else
      ASSIGN c-trib-ii = {ininc/i10in172.i 04 i-trib-ii}.
  &endif
    
  RETURN c-trib-ii.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTribIpi wMasterDetail 
FUNCTION fnTribIpi RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao003 = {ininc/i10in172.i 04 i-trib-ipi}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-ipi = RETURN-VALUE.
  &else
      ASSIGN c-trib-ipi = {ininc/i10in172.i 04 i-trib-ipi}.
  &endif

  RETURN c-trib-ipi.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnidade wMasterDetail 
FUNCTION fnUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

