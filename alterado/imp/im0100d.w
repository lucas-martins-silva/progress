&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          mgcex            PROGRESS
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
{include/i-prgvrs.i IM0100D 2.00.00.058 } /*** "010058" 15/10/2026 10:28:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100d MIM}
&ENDIF


{cdp/cdcfgmat.i} /* Include pre-processadores */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0100D
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Impostos, Impostos 2

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
                                i-quantidade ~
                                i-classifica ~
                                btConfirm ~
                                btReload ~
                                btConfTrib

&GLOBAL-DEFINE page0Browse      brSon1 brSon2 brSon3 brSon4 brSon5 brSon6

&GLOBAL-DEFINE numRowsReturned  inumRowsReturned

&GLOBAL-DEFINE EXCLUDE-ApplyOffEnd
&GLOBAL-DEFINE ExcludeBtQueryJoins      YES
&GLOBAL-DEFINE ExcludeBtReportsJoins    YES


/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE NO-UNDO.


/* Global Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl         AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa            AS WIDGET-HANDLE NO-UNDO.
{utp/ut-glob.i}  /* Vari†veis de Sistema */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-item             AS   CHARACTER FORMAT "x(60)":U             NO-UNDO.
DEFINE VARIABLE c-trib-ii               AS   CHARACTER FORMAT "X(10)":U             NO-UNDO.
DEFINE VARIABLE c-trib-ipi              AS   CHARACTER FORMAT "X(10)":U             NO-UNDO.
DEFINE VARIABLE c-trib-icms             AS   CHARACTER FORMAT "X(10)":U             NO-UNDO.
DEFINE VARIABLE c-trib-pis              AS   CHARACTER FORMAT "X(10)":U             NO-UNDO.
DEFINE VARIABLE c-trib-cofins           AS   CHARACTER FORMAT "X(10)":U             NO-UNDO.
DEFINE VARIABLE c-desc-classif          AS   CHARACTER FORMAT "x(35)":U             NO-UNDO.
DEFINE VARIABLE c-erro                  AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-tax-siscomex          AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-nat-fiscal            AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-lista-campo           AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-tributacoes-tiro      AS   CHARACTER INITIAL "T,I,R,O":U          NO-UNDO.
DEFINE VARIABLE c-tributacoes-tio       AS   CHARACTER INITIAL "T,I,O":U            NO-UNDO.
DEFINE VARIABLE c-tributacoes-ti        AS   CHARACTER INITIAL "T,I":U              NO-UNDO.
DEFINE VARIABLE c-lbl-tiro              AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-lbl-liter             AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE de-peso-bruto           AS   DECIMAL FORMAT ">>>,>>>,>>9.9999":U    NO-UNDO.
DEFINE VARIABLE de-peso-liquido         AS   DECIMAL FORMAT ">>>,>>>,>>9.9999":U    NO-UNDO.
DEFINE VARIABLE de-tx-siscomex-acum     AS   DECIMAL                                NO-UNDO.
DEFINE VARIABLE de-tx-siscomex-ant      AS   DECIMAL                                NO-UNDO.
DEFINE VARIABLE h-boin245               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-boin292               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-boin046na             AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-bocx250               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-bocx310               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-boin178               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-boin274               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-coluna                AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-cd0763                AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE h-bocx225               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE i-trib-ii               AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-trib-ipi              AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-trib-icms             AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-trib-pis              AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-trib-cofins           AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE inumRowsReturned        AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-sequen                AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-classifica-ant        AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE iNrRegistro             AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-cdn-adicao-ant        AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE l-usuarionatureza       AS   LOGICAL                                NO-UNDO.
DEFINE VARIABLE l-im0045                AS   LOGICAL                                NO-UNDO.
DEFINE VARIABLE l-tax-siscomex          AS   LOGICAL                                NO-UNDO.
DEFINE VARIABLE l-atualizar-despesa     AS   LOGICAL INITIAL NO                     NO-UNDO.
DEFINE VARIABLE l-imp-import            AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-imp-prod-ind          AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-imp-circ-serv         AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-prg-integ-soc         AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-cont-segur-soc        AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-adicao                AS   LOGICAL                                NO-UNDO.
DEFINE VARIABLE l-multi-natur           AS   LOGICAL                                NO-UNDO.
DEFINE VARIABLE c-it-codigo             LIKE item.it-codigo                         NO-UNDO.
DEFINE VARIABLE c-un                    LIKE item.un                                NO-UNDO.
DEFINE VARIABLE de-quantidade           LIKE prazo-compra.quantidade                NO-UNDO.
DEFINE VARIABLE de-aliq-ii              AS DECIMAL FORMAT ">>9.9999"                NO-UNDO.
DEFINE VARIABLE de-aliq-ipi             LIKE item.aliquota-ipi                      NO-UNDO.
DEFINE VARIABLE de-aliq-icms            LIKE item.aliquota-ipi                      NO-UNDO.
DEFINE VARIABLE de-aliq-pis             LIKE item.aliquota-ipi                      NO-UNDO.
DEFINE VARIABLE de-aliq-cofins          LIKE item.aliquota-ipi                      NO-UNDO.
DEFINE VARIABLE c-item-char-2           LIKE item.char-2                            NO-UNDO.
DEFINE VARIABLE de-qtde-acum            LIKE prazo-compra.quantidade                NO-UNDO.
DEFINE VARIABLE de-qt-do-forn-acum      LIKE prazo-compra.quantidade                NO-UNDO.
DEFINE VARIABLE de-quantidade-acum      LIKE prazo-compra.quantidade                NO-UNDO.
DEFINE VARIABLE i-linha-zoom            AS   INTEGER INITIAL 0                      NO-UNDO.
DEFINE VARIABLE i-folder                AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE l-recarrega-IBSUF       AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-recarrega-IBSMun      AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-recarrega-CBS         AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-recarrega-IS          AS   LOGICAL INITIAL YES                    NO-UNDO.
DEFINE VARIABLE l-nt2024002             AS LOGICAL                                  NO-UNDO.
DEFINE VARIABLE i-cod-emitente-emb      LIKE ordem-compra.cod-emitente              NO-UNDO.
DEFINE VARIABLE plIsGovEntity           AS LOGICAL                                  NO-UNDO.
DEFINE VARIABLE plGovEntityType         AS INTEGER                                  NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

{imp/im0100.i1} /* l-fn-imp-adicao-un */


{utp/ut-liter.i Tributaá∆o_inv†lida.}
ASSIGN c-lbl-tiro = RETURN-VALUE + " Consulte a legenda do campo":U.

/* Local Temp-tables Definitions ---                                       */
{include/boerrtab.i} /* tt-bo-erro */
{cxbo/bocx225.i tt-ordens-embarque-aux}
{cxbo/bocx225.i tt-ordens-embarque-nat}

DEFINE TEMP-TABLE tt-nat-oper
       FIELD c-nat-fiscal-old      AS CHARACTER FORMAT "x(06)":U         LABEL "Natureza Fiscal"
       FIELD c-nat-fiscal-new      AS CHARACTER FORMAT "x(06)":U         LABEL "Natureza Fiscal"
       FIELD c-class-fiscal        AS CHARACTER FORMAT "9999.99.99"      LABEL "Class Fisc".

{cxbo/bocx225e.i tt-ordens-desemb}

DEFINE TEMP-TABLE tt-ordens-desemb-acum NO-UNDO LIKE tt-ordens-desemb
    FIELD c-desc-classif AS CHARACTER FORMAT "x(35)":U.

DEFINE TEMP-TABLE tt-ordens-desemb-acum-aux NO-UNDO LIKE tt-ordens-desemb
    FIELD c-desc-classif AS CHARACTER FORMAT "x(35)":U.

DEFINE TEMP-TABLE tt-ordens-desemb-acum-adicao NO-UNDO LIKE tt-ordens-desemb-acum.

DEFINE TEMP-TABLE tt-ordens-desemb-nat NO-UNDO LIKE tt-ordens-desemb.

/* Local Buffer's Definitions ---                                       */
DEFINE BUFFER b-tt-ordens-desemb FOR tt-ordens-desemb.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-cod-estabel   LIKE estabelec.cod-estabel          NO-UNDO.
DEFINE INPUT PARAMETER p-embarque      LIKE embarque-imp.embarque          NO-UNDO.
DEFINE INPUT PARAMETER p-usuario       LIKE param-re.usuario               NO-UNDO.
DEFINE INPUT PARAMETER p-nat-operacao  LIKE natur-oper.nat-operacao        NO-UNDO.
DEFINE INPUT PARAMETER p-icms-diferido AS   LOGICAL                        NO-UNDO.
DEFINE INPUT PARAMETER p-tp-nacionaliz AS   INTEGER                        NO-UNDO. /* 1 - Embarque | 2 - Declaraá∆o de Importaá∆o | 3 - DUIMP */
DEFINE INPUT PARAMETER p-num-di        LIKE embarque-imp.declaracao-import NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.numero-ordem tt-ordens-desemb.parcela tt-ordens-desemb.c-it-codigo tt-ordens-desemb.c-desc-item tt-ordens-desemb.c-class-fiscal tt-ordens-desemb.cod-nbs tt-ordens-desemb.c-nat-fiscal tt-ordens-desemb.c-un tt-ordens-desemb.de-quantidade tt-ordens-desemb.c-trib-ii tt-ordens-desemb.de-aliq-ii tt-ordens-desemb.l-suspensao-II tt-ordens-desemb.c-trib-ipi tt-ordens-desemb.de-aliq-ipi tt-ordens-desemb.l-suspensao-IPI tt-ordens-desemb.c-trib-icms tt-ordens-desemb.de-aliq-icms tt-ordens-desemb.l-aplica-desc-ICMS tt-ordens-desemb.c-trib-pis tt-ordens-desemb.de-aliq-pis tt-ordens-desemb.c-trib-cofins tt-ordens-desemb.de-aliq-cofins tt-ordens-desemb.cdn-adicao tt-ordens-desemb.seq-item
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.c-class-fiscal ~
tt-ordens-desemb.c-nat-fiscal ~
tt-ordens-desemb.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb.de-aliq-ii ~
 ~
tt-ordens-desemb.c-trib-ipi ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb.de-aliq-ipi ~
   tt-ordens-desemb.c-trib-icms ~
 ~
 ~
 ~
 ~
 ~
 VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb.de-aliq-icms ~
   tt-ordens-desemb.c-trib-pis ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb.l-aplica-desc-ICMS ~
tt-ordens-desemb.de-aliq-pis ~
   tt-ordens-desemb.c-trib-cofins ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb.de-aliq-cofins ~
  tt-ordens-desemb.l-suspensao-II ~
  tt-ordens-desemb.l-suspensao-IPI ~
 tt-ordens-desemb.cdn-adicao ~
 ~
tt-ordens-desemb.seq-item
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 tt-ordens-desemb ~
VALIDATE(LOOKUP(tt-ordens-desemb "Nr "Seq
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon1 VALIDATE(LOOKUP(tt-ordens-desemb
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-brSon1 "Nr
&Scoped-define FOURTH-ENABLED-TABLE-IN-QUERY-brSon1 "Seq
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-desemb NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-desemb


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.c-class-fiscal tt-ordens-desemb-acum.cod-nbs tt-ordens-desemb-acum.c-nat-fiscal tt-ordens-desemb-acum.c-un fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum.de-quantidade tt-ordens-desemb-acum.c-trib-ii tt-ordens-desemb-acum.de-aliq-ii tt-ordens-desemb-acum.l-suspensao-II tt-ordens-desemb-acum.c-trib-ipi tt-ordens-desemb-acum.de-aliq-ipi tt-ordens-desemb-acum.l-suspensao-IPI tt-ordens-desemb-acum.c-trib-icms tt-ordens-desemb-acum.de-aliq-icms tt-ordens-desemb-acum.l-aplica-desc-ICMS tt-ordens-desemb-acum.c-trib-pis tt-ordens-desemb-acum.de-aliq-pis tt-ordens-desemb-acum.c-trib-cofins tt-ordens-desemb-acum.de-aliq-cofins
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.c-nat-fiscal ~
tt-ordens-desemb-acum.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
 ~
 VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.de-aliq-ii ~
 ~
tt-ordens-desemb-acum.c-trib-ipi ~
 ~
 ~
 ~
 ~
 ~
 ~
 VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.de-aliq-ipi ~
   tt-ordens-desemb-acum.c-trib-icms ~
 ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.de-aliq-icms ~
   tt-ordens-desemb-acum.c-trib-pis ~
 ~
 ~
 ~
 ~
 ~
 ~
 VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.l-aplica-desc-ICMS ~
tt-ordens-desemb-acum.de-aliq-pis ~
   tt-ordens-desemb-acum.c-trib-cofins ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.de-aliq-cofins ~
  tt-ordens-desemb-acum.l-suspensao-II ~
  tt-ordens-desemb-acum.l-suspensao-IPI
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon2 VALIDATE(LOOKUP(tt-ordens-desemb-acum
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.cdn-adicao tt-ordens-desemb-acum-adicao.c-class-fiscal tt-ordens-desemb-acum-adicao.cod-nbs tt-ordens-desemb-acum-adicao.c-nat-fiscal tt-ordens-desemb-acum-adicao.c-un fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum-adicao.de-quantidade tt-ordens-desemb-acum-adicao.c-trib-ii tt-ordens-desemb-acum-adicao.de-aliq-ii tt-ordens-desemb-acum-adicao.l-suspensao-II tt-ordens-desemb-acum-adicao.c-trib-ipi tt-ordens-desemb-acum-adicao.de-aliq-ipi tt-ordens-desemb-acum-adicao.l-suspensao-IPI tt-ordens-desemb-acum-adicao.c-trib-icms tt-ordens-desemb-acum-adicao.de-aliq-icms tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS tt-ordens-desemb-acum-adicao.c-trib-pis tt-ordens-desemb-acum-adicao.de-aliq-pis tt-ordens-desemb-acum-adicao.c-trib-cofins tt-ordens-desemb-acum-adicao.de-aliq-cofins tt-ordens-desemb-acum-adicao.de-taxa-siscomex
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.c-nat-fiscal ~
tt-ordens-desemb-acum-adicao.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-ii ~
 ~
tt-ordens-desemb-acum-adicao.c-trib-ipi ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-ipi ~
   tt-ordens-desemb-acum-adicao.c-trib-icms ~
 ~
 ~
 ~
 ~
 ~
 ~
   VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-icms ~
   tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS ~
tt-ordens-desemb-acum-adicao.c-trib-pis ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-pis ~
   tt-ordens-desemb-acum-adicao.c-trib-cofins ~
 ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-cofins ~
  tt-ordens-desemb-acum-adicao.l-suspensao-II ~
  tt-ordens-desemb-acum-adicao.l-suspensao-IPI ~
 tt-ordens-desemb-acum-adicao.de-taxa-siscomex
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon3 VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK      BY tt-ordens-desemb-acum-adicao.cdn-adicao      BY tt-ordens-desemb-acum-adicao.c-class-fiscal      BY tt-ordens-desemb-acum-adicao.c-un
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK      BY tt-ordens-desemb-acum-adicao.cdn-adicao      BY tt-ordens-desemb-acum-adicao.c-class-fiscal      BY tt-ordens-desemb-acum-adicao.c-un.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao


/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 tt-ordens-desemb.numero-ordem tt-ordens-desemb.parcela tt-ordens-desemb.c-it-codigo tt-ordens-desemb.c-desc-item tt-ordens-desemb.c-class-fiscal tt-ordens-desemb.cod-nbs tt-ordens-desemb.c-nat-fiscal tt-ordens-desemb.c-un tt-ordens-desemb.de-quantidade tt-ordens-desemb.c-trib-ii tt-ordens-desemb.de-aliq-ii tt-ordens-desemb.l-suspensao-II tt-ordens-desemb.cClassTrib-IBSUF tt-ordens-desemb.cCST-IBSUF tt-ordens-desemb.c-trib-IBSUF tt-ordens-desemb.de-aliq-IBSUF tt-ordens-desemb.perc-red-gov-ibsuf tt-ordens-desemb.cClassTribReg-IBSUF tt-ordens-desemb.cCSTReg-IBSUF tt-ordens-desemb.de-aliq-Reg-IBSUF tt-ordens-desemb.cClassTrib-IBSMun tt-ordens-desemb.cCST-IBSMun tt-ordens-desemb.c-trib-IBSMun tt-ordens-desemb.de-aliq-IBSMun tt-ordens-desemb.perc-red-gov-ibsmun tt-ordens-desemb.cClassTribReg-IBSMun tt-ordens-desemb.cCSTReg-IBSMun tt-ordens-desemb.de-aliq-Reg-IBSMun tt-ordens-desemb.cClassTrib-CBS tt-ordens-desemb.cCST-CBS tt-ordens-desemb.c-trib-CBS tt-ordens-desemb.de-aliq-CBS tt-ordens-desemb.perc-red-gov-cbs tt-ordens-desemb.cClassTribReg-CBS tt-ordens-desemb.cCSTReg-CBS tt-ordens-desemb.de-aliq-Reg-CBS tt-ordens-desemb.cClassTrib-IS tt-ordens-desemb.cCST-IS tt-ordens-desemb.c-trib-IS tt-ordens-desemb.de-aliq-IS tt-ordens-desemb.de-aliq-espec-IS tt-ordens-desemb.de-qtde-trib-IS tt-ordens-desemb.c-un-trib-IS tt-ordens-desemb.cdn-adicao tt-ordens-desemb.seq-item
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 tt-ordens-desemb.c-class-fiscal ~
tt-ordens-desemb.c-nat-fiscal ~
tt-ordens-desemb.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
  VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb.de-aliq-ii ~
 ~
tt-ordens-desemb.cClassTrib-IBSUF ~
tt-ordens-desemb.cCST-IBSUF ~
tt-ordens-desemb.de-aliq-IBSUF ~
tt-ordens-desemb.perc-red-gov-ibsuf ~
  tt-ordens-desemb.cClassTribReg-IBSUF ~
tt-ordens-desemb.cCSTReg-IBSUF ~
tt-ordens-desemb.de-aliq-Reg-IBSUF ~
tt-ordens-desemb.cClassTrib-IBSMun ~
tt-ordens-desemb.cCST-IBSMun ~
tt-ordens-desemb.de-aliq-IBSMun ~
tt-ordens-desemb.perc-red-gov-ibsmun ~
  tt-ordens-desemb.cClassTribReg-IBSMun ~
tt-ordens-desemb.cCSTReg-IBSMun ~
tt-ordens-desemb.de-aliq-Reg-IBSMun ~
tt-ordens-desemb.cClassTrib-CBS ~
tt-ordens-desemb.cCST-CBS ~
tt-ordens-desemb.de-aliq-CBS ~
tt-ordens-desemb.perc-red-gov-cbs ~
   tt-ordens-desemb.cClassTribReg-CBS ~
tt-ordens-desemb.cCSTReg-CBS ~
tt-ordens-desemb.de-aliq-Reg-CBS ~
tt-ordens-desemb.cClassTrib-IS ~
tt-ordens-desemb.cCST-IS ~
tt-ordens-desemb.de-aliq-IS ~
tt-ordens-desemb.de-aliq-espec-IS ~
tt-ordens-desemb.de-qtde-trib-IS ~
tt-ordens-desemb.c-un-trib-IS ~
tt-ordens-desemb.l-suspensao-II ~
  tt-ordens-desemb.cdn-adicao ~
 ~
tt-ordens-desemb.seq-item
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon4 tt-ordens-desemb ~
VALIDATE(LOOKUP(tt-ordens-desemb "Nr "Seq
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon4 tt-ordens-desemb
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon4 VALIDATE(LOOKUP(tt-ordens-desemb
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-brSon4 "Nr
&Scoped-define FOURTH-ENABLED-TABLE-IN-QUERY-brSon4 "Seq
&Scoped-define SELF-NAME brSon4
&Scoped-define QUERY-STRING-brSon4 FOR EACH tt-ordens-desemb NO-LOCK
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon4 tt-ordens-desemb
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 tt-ordens-desemb


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 tt-ordens-desemb-acum.c-class-fiscal tt-ordens-desemb-acum.cod-nbs tt-ordens-desemb-acum.c-nat-fiscal tt-ordens-desemb-acum.c-un fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum.de-quantidade tt-ordens-desemb-acum.c-trib-ii tt-ordens-desemb-acum.de-aliq-ii tt-ordens-desemb-acum.l-suspensao-II tt-ordens-desemb-acum.cClassTrib-IBSUF tt-ordens-desemb-acum.cCST-IBSUF tt-ordens-desemb-acum.c-trib-IBSUF tt-ordens-desemb-acum.de-aliq-IBSUF tt-ordens-desemb-acum.perc-red-gov-ibsuf tt-ordens-desemb-acum.cClassTribReg-IBSUF tt-ordens-desemb-acum.cCSTReg-IBSUF tt-ordens-desemb-acum.de-aliq-Reg-IBSUF tt-ordens-desemb-acum.cClassTrib-IBSMun tt-ordens-desemb-acum.cCST-IBSMun tt-ordens-desemb-acum.c-trib-IBSMun tt-ordens-desemb-acum.de-aliq-IBSMun tt-ordens-desemb-acum.perc-red-gov-ibsmun tt-ordens-desemb-acum.cClassTribReg-IBSMun tt-ordens-desemb-acum.cCSTReg-IBSMun tt-ordens-desemb-acum.de-aliq-Reg-IBSMun tt-ordens-desemb-acum.cClassTrib-CBS tt-ordens-desemb-acum.cCST-CBS tt-ordens-desemb-acum.c-trib-CBS tt-ordens-desemb-acum.de-aliq-CBS tt-ordens-desemb-acum.perc-red-gov-cbs tt-ordens-desemb-acum.cClassTribReg-CBS tt-ordens-desemb-acum.cCSTReg-CBS tt-ordens-desemb-acum.de-aliq-Reg-CBS tt-ordens-desemb-acum.cClassTrib-IS tt-ordens-desemb-acum.cCST-IS tt-ordens-desemb-acum.c-trib-IS tt-ordens-desemb-acum.de-aliq-IS tt-ordens-desemb-acum.de-aliq-espec-IS tt-ordens-desemb-acum.de-qtde-trib-IS tt-ordens-desemb-acum.c-un-trib-IS
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 tt-ordens-desemb-acum.c-nat-fiscal ~
tt-ordens-desemb-acum.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
 ~
 VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum.de-aliq-ii ~
 ~
tt-ordens-desemb-acum.cClassTrib-IBSUF ~
tt-ordens-desemb-acum.cCST-IBSUF ~
tt-ordens-desemb-acum.de-aliq-IBSUF ~
tt-ordens-desemb-acum.perc-red-gov-ibsuf ~
  tt-ordens-desemb-acum.cClassTribReg-IBSUF ~
tt-ordens-desemb-acum.cCSTReg-IBSUF ~
tt-ordens-desemb-acum.de-aliq-Reg-IBSUF ~
tt-ordens-desemb-acum.cClassTrib-IBSMun ~
tt-ordens-desemb-acum.cCST-IBSMun ~
tt-ordens-desemb-acum.de-aliq-IBSMun ~
tt-ordens-desemb-acum.perc-red-gov-ibsmun ~
  tt-ordens-desemb-acum.cClassTribReg-IBSMun ~
tt-ordens-desemb-acum.cCSTReg-IBSMun ~
tt-ordens-desemb-acum.de-aliq-Reg-IBSMun ~
tt-ordens-desemb-acum.cClassTrib-CBS ~
tt-ordens-desemb-acum.cCST-CBS ~
tt-ordens-desemb-acum.de-aliq-CBS ~
tt-ordens-desemb-acum.perc-red-gov-cbs ~
   tt-ordens-desemb-acum.cClassTribReg-CBS ~
tt-ordens-desemb-acum.cCSTReg-CBS ~
tt-ordens-desemb-acum.de-aliq-Reg-CBS ~
tt-ordens-desemb-acum.cClassTrib-IS ~
tt-ordens-desemb-acum.cCST-IS ~
tt-ordens-desemb-acum.de-aliq-IS ~
tt-ordens-desemb-acum.de-aliq-espec-IS ~
tt-ordens-desemb-acum.de-qtde-trib-IS ~
tt-ordens-desemb-acum.c-un-trib-IS ~
tt-ordens-desemb-acum.l-suspensao-II
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon5 tt-ordens-desemb-acum ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon5 tt-ordens-desemb-acum
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon5 VALIDATE(LOOKUP(tt-ordens-desemb-acum
&Scoped-define SELF-NAME brSon5
&Scoped-define QUERY-STRING-brSon5 FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal.
&Scoped-define TABLES-IN-QUERY-brSon5 tt-ordens-desemb-acum
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 tt-ordens-desemb-acum


/* Definitions for BROWSE brSon6                                        */
&Scoped-define FIELDS-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao.cdn-adicao tt-ordens-desemb-acum-adicao.c-class-fiscal tt-ordens-desemb-acum-adicao.cod-nbs tt-ordens-desemb-acum-adicao.c-nat-fiscal tt-ordens-desemb-acum-adicao.c-un fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum-adicao.de-quantidade tt-ordens-desemb-acum-adicao.c-trib-ii tt-ordens-desemb-acum-adicao.de-aliq-ii tt-ordens-desemb-acum-adicao.l-suspensao-II tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF tt-ordens-desemb-acum-adicao.cCST-IBSUF tt-ordens-desemb-acum-adicao.c-trib-IBSUF tt-ordens-desemb-acum-adicao.de-aliq-IBSUF tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun tt-ordens-desemb-acum-adicao.cCST-IBSMun tt-ordens-desemb-acum-adicao.c-trib-IBSMun tt-ordens-desemb-acum-adicao.de-aliq-IBSMun tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun tt-ordens-desemb-acum-adicao.cClassTrib-CBS tt-ordens-desemb-acum-adicao.cCST-CBS tt-ordens-desemb-acum-adicao.c-trib-CBS tt-ordens-desemb-acum-adicao.de-aliq-CBS tt-ordens-desemb-acum-adicao.perc-red-gov-cbs tt-ordens-desemb-acum-adicao.cClassTribReg-CBS tt-ordens-desemb-acum-adicao.cCSTReg-CBS tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS tt-ordens-desemb-acum-adicao.cClassTrib-IS tt-ordens-desemb-acum-adicao.cCST-IS tt-ordens-desemb-acum-adicao.c-trib-IS tt-ordens-desemb-acum-adicao.de-aliq-IS tt-ordens-desemb-acum-adicao.de-aliq-espec-IS tt-ordens-desemb-acum-adicao.de-qtde-trib-IS tt-ordens-desemb-acum-adicao.c-un-trib-IS tt-ordens-desemb-acum-adicao.de-taxa-siscomex
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao.c-nat-fiscal ~
tt-ordens-desemb-acum-adicao.c-trib-ii ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro) ~
tt-ordens-desemb-acum-adicao.de-aliq-ii ~
 ~
tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF ~
tt-ordens-desemb-acum-adicao.cCST-IBSUF ~
tt-ordens-desemb-acum-adicao.de-aliq-IBSUF ~
tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf ~
  tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF ~
tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF ~
tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF ~
tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun ~
tt-ordens-desemb-acum-adicao.cCST-IBSMun ~
tt-ordens-desemb-acum-adicao.de-aliq-IBSMun ~
tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun ~
  tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun ~
tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun ~
tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun ~
tt-ordens-desemb-acum-adicao.cClassTrib-CBS ~
tt-ordens-desemb-acum-adicao.cCST-CBS ~
tt-ordens-desemb-acum-adicao.de-aliq-CBS ~
tt-ordens-desemb-acum-adicao.perc-red-gov-cbs ~
   tt-ordens-desemb-acum-adicao.cClassTribReg-CBS ~
tt-ordens-desemb-acum-adicao.cCSTReg-CBS ~
tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS ~
tt-ordens-desemb-acum-adicao.cClassTrib-IS ~
tt-ordens-desemb-acum-adicao.cCST-IS ~
tt-ordens-desemb-acum-adicao.de-aliq-IS ~
tt-ordens-desemb-acum-adicao.de-aliq-espec-IS ~
tt-ordens-desemb-acum-adicao.de-qtde-trib-IS ~
tt-ordens-desemb-acum-adicao.c-un-trib-IS ~
tt-ordens-desemb-acum-adicao.l-suspensao-II ~
  tt-ordens-desemb-acum-adicao.de-taxa-siscomex
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao ~
VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon6 VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao
&Scoped-define SELF-NAME brSon6
&Scoped-define QUERY-STRING-brSon6 FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK      BY tt-ordens-desemb-acum-adicao.cdn-adicao      BY tt-ordens-desemb-acum-adicao.c-class-fiscal      BY tt-ordens-desemb-acum-adicao.c-un
&Scoped-define OPEN-QUERY-brSon6 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK      BY tt-ordens-desemb-acum-adicao.cdn-adicao      BY tt-ordens-desemb-acum-adicao.c-class-fiscal      BY tt-ordens-desemb-acum-adicao.c-un.
&Scoped-define TABLES-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-TABLE-IN-QUERY-brSon6 tt-ordens-desemb-acum-adicao


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon4}~
    ~{&OPEN-QUERY-brSon5}~
    ~{&OPEN-QUERY-brSon6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS c-natur-oper i-quantidade i-classifica ~
btConfirm btReload btExit btHelp btNext btPrev btConfTrib RECT-1 rtParent ~
rtToolBar
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS c-natur-oper i-quantidade i-classifica

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
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
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
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Confirma alteraá‰es nos itens"
     FONT 4.

DEFINE BUTTON btConfTrib
     IMAGE-UP FILE "image/im-mov.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mov.bmp":U
     LABEL "Configurador de Tributos"
     SIZE 4 BY 1.25 TOOLTIP "Configurador de Tributos"
     FONT 4.

DEFINE BUTTON btExit
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btNext
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL ""
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL ""
     SIZE 4 BY 1.25.

DEFINE BUTTON btReload
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Recarrega informaá‰es do item"
     FONT 4.

DEFINE VARIABLE c-natur-oper AS CHARACTER FORMAT "x(6)":U
     LABEL "Natureza Operaá∆o"
     VIEW-AS FILL-IN
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-classifica AS INTEGER INITIAL 1
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Por Item", 1,
"Por Class Fiscal", 2,
"Por Adiá‰es do Embarque", 3
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE i-quantidade AS INTEGER INITIAL 1
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Qtde unidade interna", 1,
"Qtde unidade externa", 2
     SIZE 39 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE de-tx-siscomex AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99999":U INITIAL 0
     LABEL "Total Taxa Siscomex"
     VIEW-AS FILL-IN
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-tx-siscomex2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99999":U INITIAL 0
     LABEL "Total Taxa Siscomex"
     VIEW-AS FILL-IN
     SIZE 17.86 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR
      tt-ordens-desemb SCROLLING.

DEFINE QUERY brSon2 FOR
      tt-ordens-desemb-acum SCROLLING.

DEFINE QUERY brSon3 FOR
      tt-ordens-desemb-acum-adicao SCROLLING.

DEFINE QUERY brSon4 FOR
      tt-ordens-desemb SCROLLING.

DEFINE QUERY brSon5 FOR
      tt-ordens-desemb-acum SCROLLING.

DEFINE QUERY brSon6 FOR
      tt-ordens-desemb-acum-adicao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-ordens-desemb.numero-ordem                             FORMAT "zzzzz9,99":U
      tt-ordens-desemb.parcela                                  FORMAT ">>>>9":U
      tt-ordens-desemb.c-it-codigo      LABEL "Item"
      tt-ordens-desemb.c-desc-item      LABEL "Descriá∆o"
      tt-ordens-desemb.c-class-fiscal   LABEL "Class Fiscal"    FORMAT "9999.99.99":U
      tt-ordens-desemb.cod-nbs                                  FORMAT "9.9999.99.99":U
      tt-ordens-desemb.c-nat-fiscal     LABEL "Natureza Fiscal" FORMAT "x(06)":U
      tt-ordens-desemb.c-un             LABEL "Un"
      tt-ordens-desemb.de-quantidade    LABEL "Quantidade"      FORMAT ">>>>>,>>9.9999":U
      tt-ordens-desemb.c-trib-ii
      tt-ordens-desemb.de-aliq-ii
      tt-ordens-desemb.l-suspensao-II
      tt-ordens-desemb.c-trib-ipi
      tt-ordens-desemb.de-aliq-ipi
      tt-ordens-desemb.l-suspensao-IPI
      tt-ordens-desemb.c-trib-icms
      tt-ordens-desemb.de-aliq-icms
      tt-ordens-desemb.l-aplica-desc-ICMS
      tt-ordens-desemb.c-trib-pis
      tt-ordens-desemb.de-aliq-pis
      tt-ordens-desemb.c-trib-cofins
      tt-ordens-desemb.de-aliq-cofins
      tt-ordens-desemb.cdn-adicao
      tt-ordens-desemb.seq-item
  ENABLE
      tt-ordens-desemb.c-class-fiscal
      tt-ordens-desemb.c-nat-fiscal
      tt-ordens-desemb.c-trib-ii          HELP "T-Tributado I-Isento"
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb.c-trib-ipi         HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb.de-aliq-ipi        HELP "Al°quota IPI"
      tt-ordens-desemb.c-trib-icms        HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb.de-aliq-icms       HELP "Al°quota ICMS"
      tt-ordens-desemb.c-trib-pis         HELP "T-Tributado I-Isento O-Outros "
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb.l-aplica-desc-ICMS HELP "Aplica Desconto ICMS - Sim/N∆o"
      tt-ordens-desemb.de-aliq-pis        HELP "Aliquota PIS Externo"
      tt-ordens-desemb.c-trib-cofins      HELP "T-Tributado I-Isento O-Outros "
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb.de-aliq-cofins     HELP "Aliquota COFINS Externo"
      tt-ordens-desemb.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
      tt-ordens-desemb.l-suspensao-IPI    HELP "Suspens∆o IPI - Sim/N∆o"
      tt-ordens-desemb.cdn-adicao         HELP "Nr.Adiá∆o"
      tt-ordens-desemb.seq-item           HELP "Seq. Item Adiá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-ordens-desemb-acum.c-class-fiscal                                      LABEL "Class Fiscal"    FORMAT "9999.99.99":U
      tt-ordens-desemb-acum.cod-nbs                                                                     FORMAT "9.9999.99.99":U
      tt-ordens-desemb-acum.c-nat-fiscal                                        LABEL "Natureza Fiscal" FORMAT "X(06)":U
      tt-ordens-desemb-acum.c-un                                                LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif  LABEL "Descriá∆o"       FORMAT "x(35)":U
      tt-ordens-desemb-acum.de-quantidade                                       LABEL "Quantidade"      FORMAT ">>>>>>,>>9.9999":U
      tt-ordens-desemb-acum.c-trib-ii
      tt-ordens-desemb-acum.de-aliq-ii
      tt-ordens-desemb-acum.l-suspensao-II
      tt-ordens-desemb-acum.c-trib-ipi
      tt-ordens-desemb-acum.de-aliq-ipi
      tt-ordens-desemb-acum.l-suspensao-IPI
      tt-ordens-desemb-acum.c-trib-icms
      tt-ordens-desemb-acum.de-aliq-icms
      tt-ordens-desemb-acum.l-aplica-desc-ICMS
      tt-ordens-desemb-acum.c-trib-pis
      tt-ordens-desemb-acum.de-aliq-pis
      tt-ordens-desemb-acum.c-trib-cofins
      tt-ordens-desemb-acum.de-aliq-cofins
  ENABLE
      tt-ordens-desemb-acum.c-nat-fiscal
      tt-ordens-desemb-acum.c-trib-ii          HELP "T-Tributado I-Isento"
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb-acum.c-trib-ipi         HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.de-aliq-ipi        HELP "Al°quota IPI"
      tt-ordens-desemb-acum.c-trib-icms        HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.de-aliq-icms       HELP "Al°quota ICMS"
      tt-ordens-desemb-acum.c-trib-pis         HELP "T-Tributado I-Isento O-Outros "
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.l-aplica-desc-ICMS HELP "Aplica Desconto ICMS - Sim/N∆o"
      tt-ordens-desemb-acum.de-aliq-pis        HELP "Aliquota PIS Externo"
      tt-ordens-desemb-acum.c-trib-cofins      HELP "T-Tributado I-Isento O-Outros "
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.de-aliq-cofins     HELP "Aliquota COFINS Externo"
      tt-ordens-desemb-acum.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
      tt-ordens-desemb-acum.l-suspensao-IPI    HELP "Suspens∆o IPI - Sim/N∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      tt-ordens-desemb-acum-adicao.cdn-adicao
      tt-ordens-desemb-acum-adicao.c-class-fiscal                                                             FORMAT "9999.99.99":U
      tt-ordens-desemb-acum-adicao.cod-nbs                                                                    FORMAT "9.9999.99.99":U
      tt-ordens-desemb-acum-adicao.c-nat-fiscal                                       LABEL "Natureza Fiscal" FORMAT "X(06)":U
      tt-ordens-desemb-acum-adicao.c-un                                               LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif LABEL "Descriá∆o"       FORMAT "x(35)":U
      tt-ordens-desemb-acum-adicao.de-quantidade                                      LABEL "Quantidade"      FORMAT ">>>>>>,>>9.9999":U
      tt-ordens-desemb-acum-adicao.c-trib-ii
      tt-ordens-desemb-acum-adicao.de-aliq-ii
      tt-ordens-desemb-acum-adicao.l-suspensao-II
      tt-ordens-desemb-acum-adicao.c-trib-ipi
      tt-ordens-desemb-acum-adicao.de-aliq-ipi
      tt-ordens-desemb-acum-adicao.l-suspensao-IPI
      tt-ordens-desemb-acum-adicao.c-trib-icms
      tt-ordens-desemb-acum-adicao.de-aliq-icms
      tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS
      tt-ordens-desemb-acum-adicao.c-trib-pis
      tt-ordens-desemb-acum-adicao.de-aliq-pis
      tt-ordens-desemb-acum-adicao.c-trib-cofins
      tt-ordens-desemb-acum-adicao.de-aliq-cofins
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
  ENABLE
      tt-ordens-desemb-acum-adicao.c-nat-fiscal
      tt-ordens-desemb-acum-adicao.c-trib-ii          HELP "T-Tributado I-Isento"
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb-acum-adicao.c-trib-ipi         HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ipi, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-ipi        HELP "Al°quota IPI"
      tt-ordens-desemb-acum-adicao.c-trib-icms        HELP "T-Tributado I-Isento R-Reduzido O-Outros"
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-icms, c-tributacoes-tiro) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-icms       HELP "Al°quota ICMS"
      tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS HELP "Aplica Desconto ICMS - Sim/N∆o"
      tt-ordens-desemb-acum-adicao.c-trib-pis         HELP "T-Tributado I-Isento O-Outros "
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-pis, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-pis        HELP "Aliquota PIS Externo"
      tt-ordens-desemb-acum-adicao.c-trib-cofins      HELP "T-Tributado I-Isento O-Outros "
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-cofins, c-tributacoes-tio) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-cofins     HELP "Aliquota COFINS Externo"
      tt-ordens-desemb-acum-adicao.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
      tt-ordens-desemb-acum-adicao.l-suspensao-IPI    HELP "Suspens∆o IPI - Sim/N∆o"
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _FREEFORM
  QUERY brSon4 NO-LOCK DISPLAY
      tt-ordens-desemb.numero-ordem                             FORMAT "zzzzz9,99":U
      tt-ordens-desemb.parcela                                  FORMAT ">>>>9":U
      tt-ordens-desemb.c-it-codigo      LABEL "Item"
      tt-ordens-desemb.c-desc-item      LABEL "Descriá∆o"
      tt-ordens-desemb.c-class-fiscal   LABEL "Class Fiscal"    FORMAT "9999.99.99":U
      tt-ordens-desemb.cod-nbs                                  FORMAT "9.9999.99.99":U
      tt-ordens-desemb.c-nat-fiscal     LABEL "Natureza Fiscal" FORMAT "x(06)":U
      tt-ordens-desemb.c-un             LABEL "Un"
      tt-ordens-desemb.de-quantidade    LABEL "Quantidade"      FORMAT ">>>>>,>>9.9999":U
      tt-ordens-desemb.c-trib-ii
      tt-ordens-desemb.de-aliq-ii
      tt-ordens-desemb.l-suspensao-II
      tt-ordens-desemb.cClassTrib-IBSUF
      tt-ordens-desemb.cCST-IBSUF
      tt-ordens-desemb.c-trib-IBSUF
      tt-ordens-desemb.de-aliq-IBSUF
      tt-ordens-desemb.perc-red-gov-ibsuf
      tt-ordens-desemb.cClassTribReg-IBSUF
      tt-ordens-desemb.cCSTReg-IBSUF
      tt-ordens-desemb.de-aliq-Reg-IBSUF
      tt-ordens-desemb.cClassTrib-IBSMun
      tt-ordens-desemb.cCST-IBSMun
      tt-ordens-desemb.c-trib-IBSMun
      tt-ordens-desemb.de-aliq-IBSMun
      tt-ordens-desemb.perc-red-gov-ibsmun
      tt-ordens-desemb.cClassTribReg-IBSMun
      tt-ordens-desemb.cCSTReg-IBSMun
      tt-ordens-desemb.de-aliq-Reg-IBSMun
      tt-ordens-desemb.cClassTrib-CBS
      tt-ordens-desemb.cCST-CBS
      tt-ordens-desemb.c-trib-CBS
      tt-ordens-desemb.de-aliq-CBS
      tt-ordens-desemb.perc-red-gov-cbs
      tt-ordens-desemb.cClassTribReg-CBS
      tt-ordens-desemb.cCSTReg-CBS
      tt-ordens-desemb.de-aliq-Reg-CBS
      tt-ordens-desemb.cClassTrib-IS
      tt-ordens-desemb.cCST-IS
      tt-ordens-desemb.c-trib-IS
      tt-ordens-desemb.de-aliq-IS
      tt-ordens-desemb.de-aliq-espec-IS
      tt-ordens-desemb.de-qtde-trib-IS
      tt-ordens-desemb.c-un-trib-IS
      tt-ordens-desemb.cdn-adicao
      tt-ordens-desemb.seq-item
  ENABLE
      tt-ordens-desemb.c-class-fiscal
      tt-ordens-desemb.c-nat-fiscal
      tt-ordens-desemb.c-trib-ii          HELP "T-Tributado I-Isento"
                                          VALIDATE(LOOKUP(tt-ordens-desemb.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb.cClassTrib-IBSUF
      tt-ordens-desemb.cCST-IBSUF
      tt-ordens-desemb.de-aliq-IBSUF      HELP "Al°quota IBS UF"
      tt-ordens-desemb.perc-red-gov-ibsuf HELP "% Red Gov IBS UF"
      tt-ordens-desemb.cClassTribReg-IBSUF
      tt-ordens-desemb.cCSTReg-IBSUF
      tt-ordens-desemb.de-aliq-Reg-IBSUF
      tt-ordens-desemb.cClassTrib-IBSMun
      tt-ordens-desemb.cCST-IBSMun
      tt-ordens-desemb.de-aliq-IBSMun     HELP "Al°quota IBS Mun"
      tt-ordens-desemb.perc-red-gov-ibsmun HELP "% Red Gov IBS Mun"
      tt-ordens-desemb.cClassTribReg-IBSMun
      tt-ordens-desemb.cCSTReg-IBSMun
      tt-ordens-desemb.de-aliq-Reg-IBSMun
      tt-ordens-desemb.cClassTrib-CBS
      tt-ordens-desemb.cCST-CBS
      tt-ordens-desemb.de-aliq-CBS        HELP "Aliquota CBS Externo"
      tt-ordens-desemb.perc-red-gov-cbs   HELP "% Red Gov CBS"
      tt-ordens-desemb.cClassTribReg-CBS
      tt-ordens-desemb.cCSTReg-CBS
      tt-ordens-desemb.de-aliq-Reg-CBS
      tt-ordens-desemb.cClassTrib-IS
      tt-ordens-desemb.cCST-IS
      tt-ordens-desemb.de-aliq-IS
      tt-ordens-desemb.de-aliq-espec-IS
      tt-ordens-desemb.de-qtde-trib-IS
      tt-ordens-desemb.c-un-trib-IS
      tt-ordens-desemb.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
      tt-ordens-desemb.cdn-adicao         HELP "Nr.Adiá∆o"
      tt-ordens-desemb.seq-item           HELP "Seq. Item Adiá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _FREEFORM
  QUERY brSon5 NO-LOCK DISPLAY
      tt-ordens-desemb-acum.c-class-fiscal                                      LABEL "Class Fiscal"    FORMAT "9999.99.99":U
      tt-ordens-desemb-acum.cod-nbs                                                                     FORMAT "9.9999.99.99":U
      tt-ordens-desemb-acum.c-nat-fiscal                                        LABEL "Natureza Fiscal" FORMAT "X(06)":U
      tt-ordens-desemb-acum.c-un                                                LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif  LABEL "Descriá∆o"       FORMAT "x(35)":U
      tt-ordens-desemb-acum.de-quantidade                                       LABEL "Quantidade"      FORMAT ">>>>>>,>>9.9999":U
      tt-ordens-desemb-acum.c-trib-ii
      tt-ordens-desemb-acum.de-aliq-ii
      tt-ordens-desemb-acum.l-suspensao-II
      tt-ordens-desemb-acum.cClassTrib-IBSUF
      tt-ordens-desemb-acum.cCST-IBSUF
      tt-ordens-desemb-acum.c-trib-IBSUF
      tt-ordens-desemb-acum.de-aliq-IBSUF
      tt-ordens-desemb-acum.perc-red-gov-ibsuf
      tt-ordens-desemb-acum.cClassTribReg-IBSUF
      tt-ordens-desemb-acum.cCSTReg-IBSUF
      tt-ordens-desemb-acum.de-aliq-Reg-IBSUF
      tt-ordens-desemb-acum.cClassTrib-IBSMun
      tt-ordens-desemb-acum.cCST-IBSMun
      tt-ordens-desemb-acum.c-trib-IBSMun
      tt-ordens-desemb-acum.de-aliq-IBSMun
      tt-ordens-desemb-acum.perc-red-gov-ibsmun
      tt-ordens-desemb-acum.cClassTribReg-IBSMun
      tt-ordens-desemb-acum.cCSTReg-IBSMun
      tt-ordens-desemb-acum.de-aliq-Reg-IBSMun
      tt-ordens-desemb-acum.cClassTrib-CBS
      tt-ordens-desemb-acum.cCST-CBS
      tt-ordens-desemb-acum.c-trib-CBS
      tt-ordens-desemb-acum.de-aliq-CBS
      tt-ordens-desemb-acum.perc-red-gov-cbs
      tt-ordens-desemb-acum.cClassTribReg-CBS
      tt-ordens-desemb-acum.cCSTReg-CBS
      tt-ordens-desemb-acum.de-aliq-Reg-CBS
      tt-ordens-desemb-acum.cClassTrib-IS
      tt-ordens-desemb-acum.cCST-IS
      tt-ordens-desemb-acum.c-trib-IS
      tt-ordens-desemb-acum.de-aliq-IS
      tt-ordens-desemb-acum.de-aliq-espec-IS
      tt-ordens-desemb-acum.de-qtde-trib-IS
      tt-ordens-desemb-acum.c-un-trib-IS
  ENABLE
      tt-ordens-desemb-acum.c-nat-fiscal
      tt-ordens-desemb-acum.c-trib-ii          HELP "T-Tributado I-Isento"
                                               VALIDATE(LOOKUP(tt-ordens-desemb-acum.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb-acum.cClassTrib-IBSUF
      tt-ordens-desemb-acum.cCST-IBSUF
      tt-ordens-desemb-acum.de-aliq-IBSUF      HELP "Al°quota IBS UF"
      tt-ordens-desemb-acum.perc-red-gov-ibsuf HELP "% Red Gov IBS UF"
      tt-ordens-desemb-acum.cClassTribReg-IBSUF
      tt-ordens-desemb-acum.cCSTReg-IBSUF
      tt-ordens-desemb-acum.de-aliq-Reg-IBSUF
      tt-ordens-desemb-acum.cClassTrib-IBSMun
      tt-ordens-desemb-acum.cCST-IBSMun
      tt-ordens-desemb-acum.de-aliq-IBSMun     HELP "Al°quota IBS Mun"
      tt-ordens-desemb-acum.perc-red-gov-ibsmun HELP "% Red Gov IBS Mun"
      tt-ordens-desemb-acum.cClassTribReg-IBSMun
      tt-ordens-desemb-acum.cCSTReg-IBSMun
      tt-ordens-desemb-acum.de-aliq-Reg-IBSMun
      tt-ordens-desemb-acum.cClassTrib-CBS
      tt-ordens-desemb-acum.cCST-CBS
      tt-ordens-desemb-acum.de-aliq-CBS        HELP "Aliquota CBS Externo"
      tt-ordens-desemb-acum.perc-red-gov-cbs   HELP "% Red Gov CBS"
      tt-ordens-desemb-acum.cClassTribReg-CBS
      tt-ordens-desemb-acum.cCSTReg-CBS
      tt-ordens-desemb-acum.de-aliq-Reg-CBS
      tt-ordens-desemb-acum.cClassTrib-IS
      tt-ordens-desemb-acum.cCST-IS
      tt-ordens-desemb-acum.de-aliq-IS
      tt-ordens-desemb-acum.de-aliq-espec-IS
      tt-ordens-desemb-acum.de-qtde-trib-IS
      tt-ordens-desemb-acum.c-un-trib-IS
      tt-ordens-desemb-acum.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.

DEFINE BROWSE brSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon6 wMasterDetail _FREEFORM
  QUERY brSon6 NO-LOCK DISPLAY
      tt-ordens-desemb-acum-adicao.cdn-adicao
      tt-ordens-desemb-acum-adicao.c-class-fiscal                                                             FORMAT "9999.99.99":U
      tt-ordens-desemb-acum-adicao.cod-nbs                                                                    FORMAT "9.9999.99.99":U
      tt-ordens-desemb-acum-adicao.c-nat-fiscal                                       LABEL "Natureza Fiscal" FORMAT "X(06)":U
      tt-ordens-desemb-acum-adicao.c-un                                               LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif LABEL "Descriá∆o"       FORMAT "x(35)":U
      tt-ordens-desemb-acum-adicao.de-quantidade                                      LABEL "Quantidade"      FORMAT ">>>>>>,>>9.9999":U
      tt-ordens-desemb-acum-adicao.c-trib-ii
      tt-ordens-desemb-acum-adicao.de-aliq-ii
      tt-ordens-desemb-acum-adicao.l-suspensao-II
      tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF
      tt-ordens-desemb-acum-adicao.cCST-IBSUF
      tt-ordens-desemb-acum-adicao.c-trib-IBSUF
      tt-ordens-desemb-acum-adicao.de-aliq-IBSUF
      tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf
      tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF
      tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF
      tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun
      tt-ordens-desemb-acum-adicao.cCST-IBSMun
      tt-ordens-desemb-acum-adicao.c-trib-IBSMun
      tt-ordens-desemb-acum-adicao.de-aliq-IBSMun
      tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun
      tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun
      tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun
      tt-ordens-desemb-acum-adicao.cClassTrib-CBS
      tt-ordens-desemb-acum-adicao.cCST-CBS
      tt-ordens-desemb-acum-adicao.c-trib-CBS
      tt-ordens-desemb-acum-adicao.de-aliq-CBS
      tt-ordens-desemb-acum-adicao.perc-red-gov-cbs
      tt-ordens-desemb-acum-adicao.cClassTribReg-CBS
      tt-ordens-desemb-acum-adicao.cCSTReg-CBS
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS
      tt-ordens-desemb-acum-adicao.cClassTrib-IS
      tt-ordens-desemb-acum-adicao.cCST-IS
      tt-ordens-desemb-acum-adicao.c-trib-IS
      tt-ordens-desemb-acum-adicao.de-aliq-IS
      tt-ordens-desemb-acum-adicao.de-aliq-espec-IS
      tt-ordens-desemb-acum-adicao.de-qtde-trib-IS
      tt-ordens-desemb-acum-adicao.c-un-trib-IS
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
  ENABLE
      tt-ordens-desemb-acum-adicao.c-nat-fiscal
      tt-ordens-desemb-acum-adicao.c-trib-ii          HELP "T-Tributado I-Isento"
                                                      VALIDATE(LOOKUP(tt-ordens-desemb-acum-adicao.c-trib-ii, c-tributacoes-ti) > 0, c-lbl-tiro)
      tt-ordens-desemb-acum-adicao.de-aliq-ii         HELP "Al°quota II"
      tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF
      tt-ordens-desemb-acum-adicao.cCST-IBSUF
      tt-ordens-desemb-acum-adicao.de-aliq-IBSUF      HELP "Al°quota IBS UF"
      tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf HELP "% Red Gov IBS UF"
      tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF 
      tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF
      tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun
      tt-ordens-desemb-acum-adicao.cCST-IBSMun
      tt-ordens-desemb-acum-adicao.de-aliq-IBSMun     HELP "Al°quota IBS Mun"
      tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun HELP "% Red Gov IBS Mun"      
      tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun
      tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun
      tt-ordens-desemb-acum-adicao.cClassTrib-CBS
      tt-ordens-desemb-acum-adicao.cCST-CBS
      tt-ordens-desemb-acum-adicao.de-aliq-CBS        HELP "Aliquota CBS Externo"
      tt-ordens-desemb-acum-adicao.perc-red-gov-cbs   HELP "% Red Gov CBS"
      tt-ordens-desemb-acum-adicao.cClassTribReg-CBS
      tt-ordens-desemb-acum-adicao.cCSTReg-CBS
      tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS
      tt-ordens-desemb-acum-adicao.cClassTrib-IS
      tt-ordens-desemb-acum-adicao.cCST-IS
      tt-ordens-desemb-acum-adicao.de-aliq-IS
      tt-ordens-desemb-acum-adicao.de-aliq-espec-IS
      tt-ordens-desemb-acum-adicao.de-qtde-trib-IS
      tt-ordens-desemb-acum-adicao.c-un-trib-IS
      tt-ordens-desemb-acum-adicao.l-suspensao-II     HELP "Suspens∆o Imposto Importaá∆o - Sim/N∆o"
      tt-ordens-desemb-acum-adicao.de-taxa-siscomex
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86.72 BY 9.25
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-natur-oper AT ROW 2.92 COL 72 COLON-ALIGNED HELP
          "Natureza de Operaá∆o"
     tt-embarque-imp.cod-estabel AT ROW 2.92 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 6 BY .88
     tt-embarque-imp.embarque AT ROW 2.92 COL 37.57 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 17 BY .88
     i-quantidade AT ROW 4.75 COL 4 HELP
          "Visualizar a quantidade na unidade interna/externa" NO-LABEL
     i-classifica AT ROW 4.75 COL 41 HELP
          "Visualizar por Item, Class Fiscal ou Adiá‰es do Embarque" NO-LABEL
     btConfirm AT ROW 1.13 COL 1.57 HELP
          "Confirma as alteraá‰es"
     btReload AT ROW 1.13 COL 5.57 HELP
          "Recarrega informaá‰es dos itens"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btNext AT ROW 1.13 COL 46.57
     btPrev AT ROW 1.13 COL 42.29
     btConfTrib AT ROW 1.13 COL 11 HELP
          "Recarrega informaá‰es dos itens" WIDGET-ID 2
     "Visualizar:" VIEW-AS TEXT
          SIZE 7 BY .75 AT ROW 4.08 COL 41
     RECT-1 AT ROW 4.46 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 90 BY 16.79
         FONT 1.

DEFINE FRAME fPage1
     brSon3 AT ROW 1.08 COL 1
     brSon2 AT ROW 1.08 COL 1
     brSon1 AT ROW 1.08 COL 1
     de-tx-siscomex AT ROW 10.46 COL 65.57 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 2.5 ROW 7.25
         SIZE 87.25 BY 10.5
         FONT 1.

DEFINE FRAME fPage2
     brSon6 AT ROW 1.08 COL 1 WIDGET-ID 300
     brSon5 AT ROW 1.08 COL 1 WIDGET-ID 200
     brSon4 AT ROW 1.08 COL 1 WIDGET-ID 100
     de-tx-siscomex2 AT ROW 10.46 COL 65.57 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 2.5 ROW 7.25
         SIZE 87.25 BY 10.5
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
         HEIGHT             = 16.88
         WIDTH              = 90.14
         MAX-HEIGHT         = 24.96
         MAX-WIDTH          = 118
         VIRTUAL-HEIGHT     = 24.96
         VIRTUAL-WIDTH      = 118
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
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon3 1 fPage1 */
/* BROWSE-TAB brSon2 brSon3 fPage1 */
/* BROWSE-TAB brSon1 brSon2 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon6 1 fPage2 */
/* BROWSE-TAB brSon5 brSon6 fPage2 */
/* BROWSE-TAB brSon4 brSon5 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK
        BY tt-ordens-desemb-acum.c-class-fiscal.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK
     BY tt-ordens-desemb-acum-adicao.cdn-adicao
     BY tt-ordens-desemb-acum-adicao.c-class-fiscal
     BY tt-ordens-desemb-acum-adicao.c-un.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK
        BY tt-ordens-desemb-acum.c-class-fiscal.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon6
/* Query rebuild information for BROWSE brSon6
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK
     BY tt-ordens-desemb-acum-adicao.cdn-adicao
     BY tt-ordens-desemb-acum-adicao.c-class-fiscal
     BY tt-ordens-desemb-acum-adicao.c-un.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon6 */
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
  run pi-atualiza-trib-item.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfirm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirm wMasterDetail
ON CHOOSE OF btConfirm IN FRAME fPage0
DO:
    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    ASSIGN l-adicao = IF i-classifica = 3 AND (l-fn-imp-adicao-un OR param-imp.log-tax-siscomex) THEN YES
                      ELSE NO.

    APPLY "ENTRY":U TO i-classifica.

    IF l-tax-siscomex THEN DO:

        IF CAN-FIND(FIRST tt-ordens-desemb
                    WHERE tt-ordens-desemb.de-taxa-siscomex <> 0
                      AND tt-ordens-desemb.cdn-adicao = 0) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33799, INPUT "").
            RETURN NO-APPLY.
        END.
    END.

    IF AVAIL tt-ordens-desemb AND tt-ordens-desemb.seq-item > 0 AND tt-ordens-desemb.cdn-adicao <= 0 THEN DO:

        {utp/ut-liter.i "Nr_Adicao" *}
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 265, INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.

    IF INPUT FRAME fPage0 i-classifica <> 1 THEN DO:
        RUN updateOrdensDesemb2 IN THIS-PROCEDURE (INPUT YES).
    END.

    RUN updateOrdensEmbarque IN THIS-PROCEDURE.

    IF  RETURN-VALUE = "OK":U then
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    else
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfTrib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfTrib wMasterDetail
ON CHOOSE OF btConfTrib IN FRAME fPage0 /* Configurador de Tributos */
DO:
    IF NOT VALID-HANDLE(h-cd0763) THEN
        RUN cdp/cd0763.w PERSISTENT SET h-cd0763.

    RUN pi-set-chave-importacao IN h-cd0763   (INPUT YES,
                                               INPUT i-cod-emitente-emb,
                                               INPUT "", /*sÇrie do documento*/
                                               INPUT tt-embarque-imp.embarque,
                                               INPUT INPUT FRAME fPage0 c-natur-oper,
                                               INPUT tt-embarque-imp.cod-estabel,
                                               INPUT YES).

    RUN initializeInterface IN h-cd0763.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:

    run pi-atualiza-trib-item.
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


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReload
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReload wMasterDetail
ON CHOOSE OF btReload IN FRAME fPage0
DO:
    RUN imp/im0100e.w (INPUT-OUTPUT l-imp-import,
                       INPUT-OUTPUT l-imp-prod-ind,
                       INPUT-OUTPUT l-imp-circ-serv,
                       INPUT-OUTPUT l-prg-integ-soc,
                       INPUT-OUTPUT l-cont-segur-soc,
                       INPUT-OUTPUT l-recarrega-IBSUF,
                       INPUT-OUTPUT l-recarrega-IBSMun,
                       INPUT-OUTPUT l-recarrega-CBS,
                       INPUT-OUTPUT l-recarrega-IS).

    RUN createOrdensDesemb IN THIS-PROCEDURE (INPUT YES,
                                              INPUT l-imp-import,
                                              INPUT l-imp-prod-ind,
                                              INPUT l-imp-circ-serv,
                                              INPUT l-prg-integ-soc,
                                              INPUT l-cont-segur-soc,
                                              INPUT l-recarrega-IBSUF,
                                              INPUT l-recarrega-IBSMun,
                                              INPUT l-recarrega-CBS,
                                              INPUT l-recarrega-IS).

    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

        IF l-nt2024002 THEN DO:
            {&OPEN-QUERY-brSon4}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon4.
        END.
    END.
    ELSE DO:

        RUN updateOrdensDesemb IN THIS-PROCEDURE.
        RUN createOrdensDesembAcum IN THIS-PROCEDURE.

        IF  INPUT FRAME fPage0 i-classifica = 2 THEN DO:
            {&OPEN-QUERY-brSon2}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon2.

            IF l-nt2024002 THEN DO:
                {&OPEN-QUERY-brSon5}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon5.
            END.
        END.
        ELSE DO:
            ASSIGN de-tx-siscomex = 0
                   de-tx-siscomex2 = 0.
            FOR EACH b-tt-ordens-desemb EXCLUSIVE-LOCK
                BREAK BY b-tt-ordens-desemb.cdn-adicao:
                IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                   ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex
                          de-tx-siscomex2 = de-tx-siscomex2 + b-tt-ordens-desemb.de-taxa-siscomex.
            END.
            DISP de-tx-siscomex WITH FRAME fpage1.

            {&OPEN-QUERY-brSon3}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon3.

            IF l-nt2024002 THEN DO:
                DISP de-tx-siscomex2 WITH FRAME fpage2.
                {&OPEN-QUERY-brSon6}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon6.
            END.
        END.
    END.

    IF l-nt2024002 THEN DO:
        RUN pi-verifica-ente-governamental.
        RUN pi-habilita-campos-red-gov.
    END.
    ASSIGN l-atualizar-despesa = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-classifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-classifica wMasterDetail
ON VALUE-CHANGED OF i-classifica IN FRAME fPage0
DO:
    RUN GetCurrentFolder IN hFolder (OUTPUT i-folder).
    IF l-multi-natur AND p-tp-nacionaliz = 1 AND NOT l-im0045 THEN DO:
        ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE IN BROWSE brSon1             = TRUE
               tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE IN BROWSE brSon2        = TRUE
               tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon3 = TRUE.
        IF l-nt2024002 THEN
            ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE IN BROWSE brSon4             = TRUE
                   tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE IN BROWSE brSon5        = TRUE
                   tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon6 = TRUE.
    END.
    ELSE DO:
        ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE IN BROWSE brSon1             = FALSE
               tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE IN BROWSE brSon2        = FALSE
               tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon3 = FALSE.
        IF l-nt2024002 THEN
            ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE IN BROWSE brSon4             = FALSE
                   tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE IN BROWSE brSon5        = FALSE
                   tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon6 = FALSE.
    END.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    ASSIGN l-adicao = IF i-classifica = 3 AND (l-fn-imp-adicao-un OR param-imp.log-tax-siscomex) THEN YES
                      ELSE NO.

    ASSIGN INPUT FRAME fPage0 i-classifica.

    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        ASSIGN i-classifica-ant                        = 1
               de-tx-siscomex:VISIBLE IN FRAME fPage1  = NO
               brSon1:HIDDEN IN FRAME fPage1           = NO
               brSon2:HIDDEN IN FRAME fPage1           = YES
               brSon3:HIDDEN IN FRAME fPage1           = YES.

        ENABLE brSon1 WITH FRAME fPage1.

        RUN updateOrdensDesemb  IN THIS-PROCEDURE.
        RUN updateOrdensDesemb2 IN THIS-PROCEDURE (INPUT YES).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

        IF l-nt2024002 THEN DO:
            ASSIGN de-tx-siscomex2:VISIBLE IN FRAME fPage2 = NO
                   brSon4:HIDDEN IN FRAME fPage2           = NO
                   brSon5:HIDDEN IN FRAME fPage2           = YES
                   brSon6:HIDDEN IN FRAME fPage2           = YES.
            ENABLE brSon4 WITH FRAME fPage2.
            {&OPEN-QUERY-brSon4}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon4.
        END.
    END.
    ELSE DO:

        RUN updateOrdensDesemb2    IN THIS-PROCEDURE (INPUT NO).
        RUN createOrdensDesembAcum IN THIS-PROCEDURE.

        ASSIGN brSon1:HIDDEN IN FRAME fPage1 = YES
               i-classifica-ant              = 2.

        IF  INPUT FRAME fPage0 i-classifica = 2 THEN DO:

            ASSIGN brSon2:HIDDEN           IN FRAME fpage1 = NO
                   brSon3:HIDDEN           IN FRAME fPage1 = YES
                   de-tx-siscomex:VISIBLE  IN FRAME fPage1 = NO.

            ENABLE brSon2 WITH FRAME fPage1.

            {&OPEN-QUERY-brSon2}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon2.

            IF l-nt2024002 THEN DO:
                ASSIGN de-tx-siscomex2:VISIBLE IN FRAME fPage2 = NO
                       brSon4:HIDDEN           IN FRAME fPage2 = YES
                       brSon5:HIDDEN           IN FRAME fPage2 = NO
                       brSon6:HIDDEN           IN FRAME fPage2 = YES.
                ENABLE brSon5 WITH FRAME fPage2.
                {&OPEN-QUERY-brSon5}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon5.
            END.
        END.
        ELSE DO:

            ASSIGN brSon2:HIDDEN           IN FRAME fPage1 = YES
                   brSon3:HIDDEN           IN FRAME fPage1 = NO
                   de-tx-siscomex:VISIBLE  IN FRAME fPage1 = YES.

            ENABLE brSon3 WITH FRAME fPage1.

            ASSIGN de-tx-siscomex  = 0
                   de-tx-siscomex2 = 0.

            FOR EACH b-tt-ordens-desemb EXCLUSIVE-LOCK
                BREAK BY b-tt-ordens-desemb.cdn-adicao:

                IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                   ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex
                          de-tx-siscomex2 = de-tx-siscomex2 + b-tt-ordens-desemb.de-taxa-siscomex.
            END.

            DISP de-tx-siscomex WITH FRAME fpage1.

            {&OPEN-QUERY-brSon3}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon3.

            IF l-nt2024002 THEN DO:
                ASSIGN brSon4:HIDDEN           IN FRAME fPage2 = YES
                       brSon5:HIDDEN           IN FRAME fPage2 = YES
                       brSon6:HIDDEN           IN FRAME fPage2 = NO
                       de-tx-siscomex2:VISIBLE IN FRAME fPage2 = YES.
                ENABLE brSon6 WITH FRAME fPage2.
                DISP de-tx-siscomex2 WITH FRAME fpage2.
                {&OPEN-QUERY-brSon6}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon6.
            END.
        END.
    END.
    IF l-nt2024002 THEN RUN pi-habilita-campos-red-gov.
    RUN SetFolder IN hFolder (INPUT i-folder).
    CASE i-classifica:
        WHEN 1 THEN DO:
            APPLY "ENTRY":U TO tt-ordens-desemb.c-trib-ii IN BROWSE brSon1.
            APPLY "ENTRY":U TO tt-ordens-desemb.c-trib-ii IN BROWSE brson4.
        END.
        WHEN 2 THEN DO:
            APPLY "ENTRY":U TO tt-ordens-desemb-acum.c-trib-ii IN BROWSE brSon2.
            APPLY "ENTRY":U TO tt-ordens-desemb-acum.c-trib-ii IN BROWSE brson5.
        END.
        WHEN 3 THEN DO:
            APPLY "ENTRY":U TO tt-ordens-desemb-acum-adicao.c-trib-ii IN BROWSE brSon3.
            APPLY "ENTRY":U TO tt-ordens-desemb-acum-adicao.c-trib-ii IN BROWSE brson6.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-quantidade wMasterDetail
ON VALUE-CHANGED OF i-quantidade IN FRAME fPage0
DO:
    ASSIGN INPUT FRAME fPage0 i-quantidade.

    IF INPUT FRAME fPage0 i-classifica = 1 THEN
        RUN updateOrdensDesemb IN THIS-PROCEDURE.
    ELSE
        RUN updateOrdensDesembAcum IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail

tt-ordens-desemb.cClassTrib-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTrib-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.cClassTrib-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTrib-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.cClassTrib-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTrib-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTrib-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.cClassTrib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTrib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTrib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.c-un-trib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.c-un-trib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.c-un-trib-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U).

tt-ordens-desemb.cClassTribReg-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTribReg-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.cClassTribReg-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTribReg-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb.cClassTribReg-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum.cClassTribReg-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).
tt-ordens-desemb-acum-adicao.cClassTribReg-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U).

/* brSon1 */
ON ENTRY OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
   ASSIGN i-cdn-adicao-ant = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao.
END.

ON LEAVE OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
    RUN pi-leave-cdn-adicao-brSon1.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

ON f5 OF tt-ordens-desemb.c-nat-fiscal IN BROWSE brSon1
OR mouse-select-dblclick OF tt-ordens-desemb.c-nat-fiscal IN BROWSE brSon1 DO:
    /* guarda a linha que foi acionado o zoom para foráar as validaá‰es do leave do campo.
      Problema: quando acionava o zoom 2 vezes seguidas n∆o estava fazendo as validaá‰es do leave do campo */
    ASSIGN i-linha-zoom = brSon1:FOCUSED-ROW IN FRAME fPage1.
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=tt-ordens-desemb.c-nat-fiscal
                       &campozoom=nat-operacao
                       &ExcludeVar=yes
                       &browse=brSon1}.
END.

ON LEAVE OF tt-ordens-desemb.c-class-fiscal IN BROWSE brson1
DO:
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "leaveNcm":U,
                                        INPUT "":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fPage1:HANDLE,
                                        INPUT STRING(TEMP-TABLE tt-ordens-desemb:HANDLE) + ",":U
                                           + tt-ordens-desemb.numero-ordem  :SCREEN-VALUE IN BROWSE brson1 + ",":U
                                           + tt-ordens-desemb.parcela       :SCREEN-VALUE IN BROWSE brson1 + ",":U
                                           + tt-ordens-desemb.c-class-fiscal:SCREEN-VALUE IN BROWSE brson1,
                                        INPUT ?) NO-ERROR.
    END.
END.

ON LEAVE OF tt-ordens-desemb.c-nat-fiscal IN BROWSE brSon1
DO:
    RUN pi-leave-nat-fiscal-brSon1.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* brSon2 */
ON f5 OF tt-ordens-desemb-acum.c-nat-fiscal IN BROWSE brSon2
OR mouse-select-dblclick OF tt-ordens-desemb-acum.c-nat-fiscal IN BROWSE brSon2 DO:
    ASSIGN i-linha-zoom = brSon2:FOCUSED-ROW IN FRAME fpage1.
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=tt-ordens-desemb-acum.c-nat-fiscal
                       &campozoom=nat-operacao
                       &ExcludeVar=yes
                       &BROWSE=brSon2}.
END.

ON LEAVE OF tt-ordens-desemb-acum.c-nat-fiscal IN BROWSE brSon2
DO:
    RUN pi-leave-nat-fiscal-brSon2.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* brSon3 */
ON f5 OF tt-ordens-desemb-acum-adicao.c-nat-fiscal IN BROWSE brSon3
OR mouse-select-dblclick OF tt-ordens-desemb-acum-adicao.c-nat-fiscal IN BROWSE brSon3 DO:
    ASSIGN i-linha-zoom = brSon3:FOCUSED-ROW IN FRAME fPage1.
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=tt-ordens-desemb-acum-adicao.c-nat-fiscal
                       &campozoom=nat-operacao
                       &BROWSE=brSon3}.
END.

ON LEAVE OF tt-ordens-desemb-acum-adicao.c-nat-fiscal IN BROWSE brSon3
DO:
    RUN pi-leave-nat-fiscal-brSon3.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.


ON ENTRY OF tt-ordens-desemb-acum-adicao.de-taxa-siscomex IN BROWSE brSon3
DO:
   ASSIGN de-tx-siscomex-ant = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.
END.


ON LEAVE OF tt-ordens-desemb-acum-adicao.de-taxa-siscomex IN BROWSE brSon3
DO:
    IF INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex <> de-tx-siscomex-ant THEN
        ASSIGN l-atualizar-despesa = YES.

    ASSIGN de-tx-siscomex     = de-tx-siscomex + (INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex - de-tx-siscomex-ant)
           de-tx-siscomex-ant = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.

    DISP de-tx-siscomex WITH FRAME fpage1.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK
        WHERE tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum-adicao.cdn-adicao
          AND tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum-adicao.c-class-fiscal:
        ASSIGN tt-ordens-desemb.de-taxa-siscomex = INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.de-taxa-siscomex.
    END.
END.

{imp/im0100d.i4} /* brson4, brson5 e brson6 - o tratamento para esses browsers foi transferido para a include para conseguir abrir no appbuilder */

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

    IF VALID-HANDLE(h-boin178) THEN DO:
        DELETE PROCEDURE h-boin178.
        ASSIGN h-boin178 = ?.
    END.

    IF VALID-HANDLE(h-boin274) THEN DO:
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    IF VALID-HANDLE(h-bocx225) THEN DO:
        DELETE PROCEDURE h-bocx225.
        ASSIGN h-bocx225 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF NOT l-nt2024002 THEN
        RUN deleteFolder IN hFolder (INPUT 2).

    RUN pi-buscaByNacionaliz.
    RUN pi-verifica-ente-governamental.

    ASSIGN brSon1:HIDDEN             IN FRAME fPage1 = NO
           brSon2:HIDDEN             IN FRAME fPage1 = YES
           brSon3:HIDDEN             IN FRAME fPage1 = YES
           brSon1:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 3
           brSon2:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 1
           brSon3:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 2
           h-coluna  = ?.

    
    IF l-nt2024002 THEN
        ASSIGN brSon4:NUM-LOCKED-COLUMNS IN FRAME fPage2 = 3
               brSon5:NUM-LOCKED-COLUMNS IN FRAME fPage2 = 1
               brSon6:NUM-LOCKED-COLUMNS IN FRAME fPage2 = 2
               tt-ordens-desemb.de-aliq-reg-IBSUF :READ-ONLY IN BROWSE brSon4 = YES
               tt-ordens-desemb.de-aliq-reg-IBSMun:READ-ONLY IN BROWSE brSon4 = YES
               tt-ordens-desemb.de-aliq-reg-CBS   :READ-ONLY IN BROWSE brSon4 = YES
               tt-ordens-desemb-acum.de-aliq-reg-IBSUF :READ-ONLY IN BROWSE brSon5 = YES
               tt-ordens-desemb-acum.de-aliq-reg-IBSMun:READ-ONLY IN BROWSE brSon5 = YES
               tt-ordens-desemb-acum.de-aliq-reg-CBS   :READ-ONLY IN BROWSE brSon5 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-reg-IBSUF :READ-ONLY IN BROWSE brSon6 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-reg-IBSMun:READ-ONLY IN BROWSE brSon6 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-reg-CBS   :READ-ONLY IN BROWSE brSon6 = YES.

    IF l-nt2024002 THEN RUN pi-habilita-campos-red-gov.
    ENABLE i-quantidade
           i-classifica
           btConfirm
           btReload
           btConfTrib
           WITH FRAME fPage0.
    ENABLE brSon1 WITH FRAME fPage1.

    ASSIGN i-quantidade:VISIBLE IN FRAME fPage0 = NO
           i-classifica:COLUMN IN FRAME fPage0  = 30.

    RUN findCodigo  IN h-bocx250 (INPUT p-cod-estabel,        OUTPUT c-erro).
    RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex":U, OUTPUT l-tax-siscomex).

    APPLY "VALUE-CHANGED":U TO i-classifica IN FRAME fPage0.

    IF NOT l-tax-siscomex THEN
        i-classifica:DELETE("Por Adiá‰es do Embarque") IN FRAME fPage0.

    RUN pi-verifica-integracao-di.

    ASSIGN c-natur-oper:SCREEN-VALUE IN FRAME fPage0 = p-nat-operacao.

    FIND FIRST funcao WHERE funcao.cd-funcao = "USA-MULT-NAT-RECEB":U NO-LOCK NO-ERROR.

    IF AVAIL funcao THEN
        ASSIGN l-multi-natur = funcao.ativo.

    CASE p-tp-nacionaliz:
        WHEN 1 /* Embarque */ THEN DO:
            DISABLE btNext btPrev WITH FRAME fPage0.
            ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU mbMain = NO
                   MENU-ITEM miprev:SENSITIVE IN MENU mbMain = NO.
        END.
        WHEN 2 /* DI       */ OR
        WHEN 3 /* DUIMP */    THEN DO:
            DISABLE btNext btPrev WITH FRAME fPage0.
            ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU mbMain = YES
                   MENU-ITEM miprev:SENSITIVE IN MENU mbMain = YES.
        END.
        OTHERWISE DO:
            DISABLE btNext btPrev WITH FRAME fPage0.
            ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU mbMain = NO
                   MENU-ITEM miprev:SENSITIVE IN MENU mbMain = NO.
        END.
    END CASE.


    IF AVAIL tt-embarque-imp THEN DO:

        /* Quando o embarque j† est† encerrado, n∆o pode alterar nada em tela */
        IF tt-embarque-imp.situacao = 2 /* Encerrado */ THEN DO:

            DISABLE btConfirm btReload WITH FRAME fPage0.

            ASSIGN tt-ordens-desemb.c-class-fiscal:READ-ONLY      IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-nat-fiscal:READ-ONLY        IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-trib-ii:READ-ONLY           IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-aliq-ii:READ-ONLY          IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-trib-ipi:READ-ONLY          IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-aliq-ipi:READ-ONLY         IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-trib-icms:READ-ONLY         IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-aliq-icms:READ-ONLY        IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-trib-pis:READ-ONLY          IN BROWSE brSon1 = YES
                   tt-ordens-desemb.l-aplica-desc-ICMS:READ-ONLY  IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-aliq-pis:READ-ONLY         IN BROWSE brSon1 = YES
                   tt-ordens-desemb.c-trib-cofins:READ-ONLY       IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-aliq-cofins:READ-ONLY      IN BROWSE brSon1 = YES
                   tt-ordens-desemb.l-suspensao-II:READ-ONLY      IN BROWSE brSon1 = YES
                   tt-ordens-desemb.l-suspensao-IPI:READ-ONLY     IN BROWSE brSon1 = YES
                   tt-ordens-desemb.cdn-adicao:READ-ONLY          IN BROWSE brSon1 = YES
                   tt-ordens-desemb.seq-item:READ-ONLY            IN BROWSE brSon1 = YES.

            ASSIGN tt-ordens-desemb-acum.c-nat-fiscal:READ-ONLY        IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.c-trib-ii:READ-ONLY           IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-aliq-ii:READ-ONLY          IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.c-trib-ipi:READ-ONLY          IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-aliq-ipi:READ-ONLY         IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.c-trib-icms:READ-ONLY         IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-aliq-icms:READ-ONLY        IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.c-trib-pis:READ-ONLY          IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.l-aplica-desc-ICMS:READ-ONLY  IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-aliq-pis:READ-ONLY         IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.c-trib-cofins:READ-ONLY       IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-aliq-cofins:READ-ONLY      IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.l-suspensao-II:READ-ONLY      IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.l-suspensao-IPI:READ-ONLY     IN BROWSE brSon2 = YES.

            ASSIGN tt-ordens-desemb-acum-adicao.c-nat-fiscal:READ-ONLY        IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-ii:READ-ONLY           IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-ii:READ-ONLY          IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-ipi:READ-ONLY          IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-ipi:READ-ONLY         IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-icms:READ-ONLY         IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-icms:READ-ONLY        IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS:READ-ONLY  IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-pis:READ-ONLY          IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-pis:READ-ONLY         IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-cofins:READ-ONLY       IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-cofins:READ-ONLY      IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.l-suspensao-II:READ-ONLY      IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.l-suspensao-IPI:READ-ONLY     IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-taxa-siscomex:READ-ONLY    IN BROWSE brSon3 = YES.

            IF l-nt2024002 THEN
                ASSIGN tt-ordens-desemb.c-nat-fiscal        :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.c-trib-ii           :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-ii          :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.l-suspensao-II      :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCST-IBSUF          :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCST-IBSMun         :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCST-CBS            :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-CBS         :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cClassTrib-IS       :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cCST-IS             :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-IS          :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.c-un-trib-IS        :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.cdn-adicao          :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb.seq-item            :READ-ONLY IN BROWSE brSon4 = YES
                       tt-ordens-desemb-acum.c-nat-fiscal        :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.c-trib-ii           :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-ii          :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.l-suspensao-II      :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCST-IBSUF          :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCST-IBSMun         :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCST-CBS            :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-CBS         :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cClassTrib-IS       :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.cCST-IS             :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-IS          :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum.c-un-trib-IS        :READ-ONLY IN BROWSE brSon5 = YES
                       tt-ordens-desemb-acum-adicao.c-nat-fiscal        :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.c-trib-ii           :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-ii          :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.l-suspensao-II      :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCST-IBSUF          :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCST-IBSMun         :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCST-CBS            :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-CBS         :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cClassTrib-IS       :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.cCST-IS             :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-IS          :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.c-un-trib-IS        :READ-ONLY IN BROWSE brSon6 = YES
                       tt-ordens-desemb-acum-adicao.de-taxa-siscomex    :READ-ONLY IN BROWSE brSon6 = YES.
        END.

        IF l-multi-natur AND p-tp-nacionaliz = 1 AND NOT l-im0045 THEN DO:

            ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE             IN BROWSE brSon1 = TRUE
                   tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE        IN BROWSE brSon2 = TRUE
                   tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon3 = TRUE
                   h-coluna = brSon1:GET-BROWSE-COLUMN(6).

            IF l-nt2024002 THEN
                ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE             IN BROWSE brSon4 = TRUE
                       tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE        IN BROWSE brSon5 = TRUE
                       tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon6 = TRUE.

          IF VALID-HANDLE (h-coluna) THEN
              APPLY 'ENTRY' TO h-coluna.

        END.
        ELSE DO:

            ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE             IN BROWSE brSon1 = FALSE
                   tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE        IN BROWSE brSon2 = FALSE
                   tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon3 = FALSE.

            IF l-nt2024002 THEN
                ASSIGN tt-ordens-desemb.c-nat-fiscal:VISIBLE             IN BROWSE brSon4 = FALSE
                       tt-ordens-desemb-acum.c-nat-fiscal:VISIBLE        IN BROWSE brSon5 = FALSE
                       tt-ordens-desemb-acum-adicao.c-nat-fiscal:VISIBLE IN BROWSE brSon6 = FALSE.

        END.

        RUN piGetFornecedor IN THIS-PROCEDURE.

        
        
        RETURN "OK":U.
    END.

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
    IF p-usuario = "" OR p-nat-operacao = "" THEN
        RUN setUsuarioNatureza IN THIS-PROCEDURE.
    ELSE
        ASSIGN l-usuarionatureza = YES.

    IF VALID-HANDLE(h-boin245) THEN DELETE PROCEDURE h-boin245.
    IF VALID-HANDLE(h-boin292) THEN DELETE PROCEDURE h-boin292.

    IF NOT l-usuarionatureza THEN RETURN "NOK":U.

    ASSIGN tt-ordens-desemb.c-class-fiscal:READ-ONLY IN BROWSE brSon1 = TRUE.

    IF l-nt2024002 THEN
        ASSIGN tt-ordens-desemb.c-class-fiscal:READ-ONLY IN BROWSE brSon4 = TRUE.

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
    DEFINE INPUT PARAMETER p-recarrega        AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-imp-import       AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-imp-prod-ind     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-imp-circ-serv    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-prg-integ-soc    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-cont-segur-soc   AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IBSUF  AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IBSMun AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-CBS    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IS     AS LOGICAL NO-UNDO.

    RUN loadOrdensDesemb IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque,
                                         INPUT p-nat-operacao,
                                         INPUT p-usuario,
                                         INPUT p-recarrega,
                                         INPUT p-icms-diferido,
                                         INPUT NO,
                                         INPUT p-imp-import,
                                         INPUT p-imp-prod-ind,
                                         INPUT p-imp-circ-serv,
                                         INPUT p-prg-integ-soc,
                                         INPUT p-cont-segur-soc,
                                         INPUT p-recarrega-IBSUF,
                                         INPUT p-recarrega-IBSMun,
                                         INPUT p-recarrega-CBS,
                                         INPUT p-recarrega-IS,
                                         INPUT p-recarrega,   /* peso-bruto   */
                                         INPUT p-recarrega,   /* peso-liquido */
                                         INPUT p-recarrega,   /* cubagem      */
                                         OUTPUT TABLE tt-ordens-desemb,
                                         OUTPUT TABLE tt-bo-erro).

    FOR EACH tt-ordens-desemb:
        RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb":U).
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

    /* Criaá∆o da tt-ordens-desemb-acum (tt-ordens-desemb acumulada por classificaá∆o fiscal e unidade)*/
    EMPTY TEMP-TABLE tt-ordens-desemb-acum.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF INPUT FRAME fPage0 i-classifica = 3 THEN DO:


        IF NOT l-fn-imp-adicao-un OR NOT param-imp.log-tax-siscomex THEN DO:

            {imp/im0100d.i "BY tt-ordens-desemb.cdn-adicao"
                           "FIRST-OF(tt-ordens-desemb.cdn-adicao) OR"
                           "LAST-OF(tt-ordens-desemb.cdn-adicao) OR"}

            EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao.
            FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
                CREATE tt-ordens-desemb-acum-adicao.
                BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-desemb-acum-adicao.
            END.
        END.
        ELSE DO:

            EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao.
            {imp/im0100d.i3}
        END.
    END.
    ELSE DO:

        {imp/im0100d.i}
    END.

    RUN updateOrdensDesembAcum IN THIS-PROCEDURE.

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

    EMPTY TEMP-TABLE tt-ordens-desemb.

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
    DEFINE VARIABLE c-return AS CHARACTER NO-UNDO.

    /*--- Verifica se o DBO j† est† inicializado ---*/
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

    /*--- Verifica se o DBO j† est† inicializado ---*/
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

    IF NOT VALID-HANDLE(h-bocx250) OR
        h-bocx250:TYPE <> "PROCEDURE":U OR
        h-bocx250:FILE-NAME <> "cxbo/bocx250.p":U THEN DO:
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
        RUN openQuery IN h-bocx250 (INPUT "1":U).
    END.

    IF  NOT VALID-HANDLE(h-boin178) OR
        h-boin178:TYPE <> "PROCEDURE":U OR
        h-boin178:FILE-NAME <> "inbo/boin178":U THEN DO:
        RUN inbo/boin178.p PERSISTENT SET h-boin178.
        RUN openQuery IN h-boin178 (INPUT 1).
    END.

    IF  NOT VALID-HANDLE(h-boin274) OR
        h-boin274:TYPE <> "PROCEDURE":U OR
        h-boin274:FILE-NAME <> "inbo/boin274":U THEN DO:
        RUN inbo/boin274.p PERSISTENT SET h-boin274.
        RUN openQuery IN h-boin274 (INPUT 1).
    END.

    IF  NOT VALID-HANDLE(h-bocx225) OR
        h-bocx225:TYPE <> "PROCEDURE":U OR
        h-bocx225:FILE-NAME <> "cxbo/bocx225":U THEN DO:
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
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
        RUN serverSendRows  IN {&hDBOSon1} (INPUT  ?,
                                            INPUT  ?,
                                            INPUT  NO,
                                            INPUT  0,
                                            OUTPUT iNrRegistro,
                                            OUTPUT TABLE {&ttSon1}).

        RUN createOrdensDesemb IN THIS-PROCEDURE (INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO).

        FOR FIRST tt-ordens-desemb:
            IF tt-ordens-desemb.c-nat-fiscal <> p-nat-operacao THEN DO:
                {utp/ut-liter.i "Natureza de operaá∆o Ç diferente da informada anteriormente." *}
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "Para que as configuraá‰es dos impostos considerem a nova natureza de operaá∆o, deve ser utilizado o bot∆o 'Recarregar Informaá‰es'." *}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 15825,
                                   INPUT c-lbl-liter + "~~" + TRIM(RETURN-VALUE)).
            END.
        END.

        RUN updateOrdensDesemb  IN THIS-PROCEDURE.
        RUN updateOrdensDesemb2 IN THIS-PROCEDURE (INPUT YES).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

        IF l-nt2024002 THEN DO:
            {&OPEN-QUERY-brSon4}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon4.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-trib-item wMasterDetail
PROCEDURE pi-atualiza-trib-item :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-retorno AS LOGICAL  INITIAL NO NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    /* Verificar se o embarque est† vinculado a uma DI/DUIMP */
    RUN pi-valida-integracao-di IN h-bocx407(INPUT tt-embarque-imp.embarque,
                                             INPUT tt-embarque-imp.cod-estabel,
                                             OUTPUT l-retorno).

    IF  not can-find(first ordens-embarque-trib
                     WHERE ordens-embarque-trib.cod-estabel = tt-embarque-imp.cod-estabel
                     AND   ordens-embarque-trib.embarque    = tt-embarque-imp.embarque)
    AND NOT l-retorno THEN DO:

        FOR EACH ct-trib-item-doc-est EXCLUSIVE-LOCK
            WHERE ct-trib-item-doc-est.cod-embarq  = tt-embarque-imp.embarque
            AND   ct-trib-item-doc-est.cod-estab   = tt-embarque-imp.cod-estab:
            DELETE ct-trib-item-doc-est.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaByNacionaliz wMasterDetail
PROCEDURE pi-buscaByNacionaliz :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    CASE p-tp-nacionaliz:
        WHEN 1 /* Embarque */ THEN DO:
            RUN setConstraint2 IN {&hDBOParent} (INPUT p-cod-estabel, INPUT p-embarque).
            RUN openQuery      IN {&hDBOParent} (INPUT 2).
        END.
        WHEN 2 /* DI */ OR
        WHEN 3 /* DUIMP */ THEN DO:
            RUN setConstraint9 IN {&hDBOParent} (INPUT p-num-di).
            RUN openQuery      IN {&hDBOParent} (INPUT 9).
        END.
        OTHERWISE DO:
            RUN setConstraint2 IN {&hDBOParent} (INPUT p-cod-estabel, INPUT p-embarque).
            RUN openQuery      IN {&hDBOParent} (INPUT 2).
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-cdn-adicao-brSon1 wMasterDetail
PROCEDURE pi-leave-cdn-adicao-brSon1 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  (NOT l-fn-imp-adicao-un OR NOT param-imp.log-tax-siscomex)
    AND CAN-FIND(FIRST b-tt-ordens-desemb
                 WHERE ROWID(b-tt-ordens-desemb)     <> ROWID(tt-ordens-desemb)
                   AND b-tt-ordens-desemb.cdn-adicao  = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                   AND b-tt-ordens-desemb.cdn-adicao <> 0
                   AND b-tt-ordens-desemb.c-un <> tt-ordens-desemb.c-un) THEN DO:

        {utp/ut-liter.i "UN" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Unidade_de_Medida" *}

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33557, INPUT c-lbl-liter + "~~":U + TRIM(RETURN-VALUE)).
        RETURN "NOK":U.
    END.

    IF  CAN-FIND(FIRST b-tt-ordens-desemb
                 WHERE ROWID(b-tt-ordens-desemb)         <> ROWID(tt-ordens-desemb)
                   AND b-tt-ordens-desemb.cdn-adicao      = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                   AND b-tt-ordens-desemb.cdn-adicao     <> 0
                   AND b-tt-ordens-desemb.c-class-fiscal <> tt-ordens-desemb.c-class-fiscal) THEN DO:

        {utp/ut-liter.i "Classificaá∆o" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Classificaá∆o_Fiscal" *}

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33557, INPUT c-lbl-liter + "~~":U + TRIM(RETURN-VALUE)).
        RETURN "NOK":U.
    END.

    IF  i-cdn-adicao-ant <> INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao THEN DO:

        FIND FIRST b-tt-ordens-desemb
             WHERE ROWID(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
               AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL b-tt-ordens-desemb THEN DO:

            IF tt-ordens-desemb.de-taxa-siscomex <> b-tt-ordens-desemb.de-taxa-siscomex THEN
                ASSIGN l-atualizar-despesa = YES.

            ASSIGN tt-ordens-desemb.de-taxa-siscomex = b-tt-ordens-desemb.de-taxa-siscomex.
        END.
        ELSE DO:

            IF tt-ordens-desemb.de-taxa-siscomex <> 0 THEN
                ASSIGN l-atualizar-despesa = YES.

            ASSIGN tt-ordens-desemb.de-taxa-siscomex = 0.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-cdn-adicao-brSon4 wMasterDetail
PROCEDURE pi-leave-cdn-adicao-brSon4 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  (NOT l-fn-imp-adicao-un OR NOT param-imp.log-tax-siscomex)
    AND CAN-FIND(FIRST b-tt-ordens-desemb
                 WHERE ROWID(b-tt-ordens-desemb)     <> ROWID(tt-ordens-desemb)
                   AND b-tt-ordens-desemb.cdn-adicao  = INPUT BROWSE brSon4 tt-ordens-desemb.cdn-adicao
                   AND b-tt-ordens-desemb.cdn-adicao <> 0
                   AND b-tt-ordens-desemb.c-un <> tt-ordens-desemb.c-un) THEN DO:

        {utp/ut-liter.i "UN" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Unidade_de_Medida" *}

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33557, INPUT c-lbl-liter + "~~":U + TRIM(RETURN-VALUE)).
        RETURN "NOK":U.
    END.

    IF  CAN-FIND(FIRST b-tt-ordens-desemb
                 WHERE ROWID(b-tt-ordens-desemb)         <> ROWID(tt-ordens-desemb)
                   AND b-tt-ordens-desemb.cdn-adicao      = INPUT BROWSE brSon4 tt-ordens-desemb.cdn-adicao
                   AND b-tt-ordens-desemb.cdn-adicao     <> 0
                   AND b-tt-ordens-desemb.c-class-fiscal <> tt-ordens-desemb.c-class-fiscal) THEN DO:

        {utp/ut-liter.i "Classificaá∆o" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Classificaá∆o_Fiscal" *}

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33557, INPUT c-lbl-liter + "~~":U + TRIM(RETURN-VALUE)).
        RETURN "NOK":U.
    END.

    IF  i-cdn-adicao-ant <> INPUT BROWSE brSon4 tt-ordens-desemb.cdn-adicao THEN DO:

        FIND FIRST b-tt-ordens-desemb
             WHERE ROWID(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
               AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon4 tt-ordens-desemb.cdn-adicao EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL b-tt-ordens-desemb THEN DO:

            IF tt-ordens-desemb.de-taxa-siscomex <> b-tt-ordens-desemb.de-taxa-siscomex THEN
                ASSIGN l-atualizar-despesa = YES.

            ASSIGN tt-ordens-desemb.de-taxa-siscomex = b-tt-ordens-desemb.de-taxa-siscomex.
        END.
        ELSE DO:

            IF tt-ordens-desemb.de-taxa-siscomex <> 0 THEN
                ASSIGN l-atualizar-despesa = YES.

            ASSIGN tt-ordens-desemb.de-taxa-siscomex = 0.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon1 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon1 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  (tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson1 <> tt-ordens-desemb.c-nat-fiscal
         OR i-linha-zoom = brSon1:FOCUSED-ROW IN FRAME fpage1)
    AND (tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson1 <> "") THEN DO:

        RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                             INPUT tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson1,
                                             INPUT tt-ordens-desemb.c-it-codigo,
                                             INPUT 1,
                                             OUTPUT TABLE tt-bo-erro).

        FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
        IF AVAIL tt-bo-erro THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT tt-bo-erro.cd-erro,
                               INPUT tt-ordens-desemb.c-it-codigo + "~~":U + tt-bo-erro.parametros).
            RETURN "NOK":U.
        END.

        ASSIGN INPUT BROWSE brSon1 tt-ordens-desemb.c-nat-fiscal.
        DISPLAY tt-ordens-desemb.c-nat-fiscal WITH BROWSE brSon1.

        EMPTY TEMP-TABLE tt-ordens-embarque-nat.

        CREATE tt-ordens-embarque-nat.
        BUFFER-COPY tt-ordens-desemb TO tt-ordens-embarque-nat.

        RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                                INPUT tt-ordens-desemb.c-nat-fiscal,
                                                INPUT p-usuario,
                                                INPUT p-icms-diferido,
                                                OUTPUT TABLE tt-ordens-desemb-nat,
                                                OUTPUT TABLE tt-bo-erro).

        FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

        IF AVAIL tt-ordens-desemb-nat THEN DO:
            FIND FIRST tt-ordens-embarque NO-LOCK
                WHERE tt-ordens-embarque.cod-estabel   = tt-ordens-desemb-nat.cod-estabel
                AND   tt-ordens-embarque.embarque      = tt-ordens-desemb-nat.embarque
                AND   tt-ordens-embarque.numero-ordem  = tt-ordens-desemb-nat.numero-ordem
                AND   tt-ordens-embarque.parcela       = tt-ordens-desemb-nat.parcela NO-ERROR.

            ASSIGN tt-ordens-desemb.c-trib-ii          = tt-ordens-desemb-nat.c-trib-ii
                   tt-ordens-desemb.de-aliq-ii         = IF AVAIL tt-ordens-embarque AND tt-ordens-embarque.aliquota-ii <> tt-ordens-desemb.de-aliq-ii THEN tt-ordens-desemb.de-aliq-ii ELSE tt-ordens-desemb-nat.de-aliq-ii
                   tt-ordens-desemb.c-trib-ipi         = tt-ordens-desemb-nat.c-trib-ipi
                   tt-ordens-desemb.de-aliq-ipi        = tt-ordens-desemb-nat.de-aliq-ipi
                   tt-ordens-desemb.c-trib-icms        = tt-ordens-desemb-nat.c-trib-icms
                   tt-ordens-desemb.de-aliq-icms       = tt-ordens-desemb-nat.de-aliq-icms
                   tt-ordens-desemb.l-aplica-desc-icms = tt-ordens-desemb-nat.l-aplica-desc-icms
                   tt-ordens-desemb.c-trib-pis         = tt-ordens-desemb-nat.c-trib-pis
                   tt-ordens-desemb.de-aliq-pis        = tt-ordens-desemb-nat.de-aliq-pis
                   tt-ordens-desemb.c-trib-cofins      = tt-ordens-desemb-nat.c-trib-cofins
                   tt-ordens-desemb.de-aliq-cofins     = tt-ordens-desemb-nat.de-aliq-cofins.

            DISPLAY tt-ordens-desemb.c-trib-ii
                    tt-ordens-desemb.de-aliq-ii
                    tt-ordens-desemb.c-trib-ipi
                    tt-ordens-desemb.de-aliq-ipi
                    tt-ordens-desemb.c-trib-icms
                    tt-ordens-desemb.de-aliq-icms
                    tt-ordens-desemb.l-aplica-desc-icms
                    tt-ordens-desemb.c-trib-pis
                    tt-ordens-desemb.de-aliq-pis
                    tt-ordens-desemb.c-trib-cofins
                    tt-ordens-desemb.de-aliq-cofins WITH BROWSE brSon1.

            IF l-nt2024002 THEN DO:
                ASSIGN tt-ordens-desemb.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                       tt-ordens-desemb.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                       tt-ordens-desemb.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                       tt-ordens-desemb.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                       tt-ordens-desemb.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                       tt-ordens-desemb.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                       tt-ordens-desemb.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                       tt-ordens-desemb.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                       tt-ordens-desemb.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                       tt-ordens-desemb.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                       tt-ordens-desemb.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                       tt-ordens-desemb.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                       tt-ordens-desemb.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                       tt-ordens-desemb.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                       tt-ordens-desemb.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                       tt-ordens-desemb.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                       tt-ordens-desemb.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                       tt-ordens-desemb.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                       tt-ordens-desemb.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                       tt-ordens-desemb.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                       tt-ordens-desemb.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                       tt-ordens-desemb.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                       tt-ordens-desemb.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                       tt-ordens-desemb.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                       tt-ordens-desemb.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                       tt-ordens-desemb.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                       tt-ordens-desemb.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                       tt-ordens-desemb.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                       tt-ordens-desemb.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                       tt-ordens-desemb.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                       tt-ordens-desemb.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.

                RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb":U).

                DISPLAY tt-ordens-desemb.c-nat-fiscal
                        tt-ordens-desemb.c-trib-ii
                        tt-ordens-desemb.de-aliq-ii
                        tt-ordens-desemb.cClassTrib-IBSUF
                        tt-ordens-desemb.cCST-IBSUF
                        tt-ordens-desemb.c-trib-IBSUF
                        tt-ordens-desemb.de-aliq-IBSUF
                        tt-ordens-desemb.perc-red-gov-ibsuf
                        tt-ordens-desemb.cClassTribReg-IBSUF
                        tt-ordens-desemb.cCSTReg-IBSUF
                        tt-ordens-desemb.de-aliq-Reg-IBSUF
                        tt-ordens-desemb.cClassTrib-IBSMun
                        tt-ordens-desemb.cCST-IBSMun
                        tt-ordens-desemb.c-trib-IBSMun
                        tt-ordens-desemb.de-aliq-IBSMun
                        tt-ordens-desemb.perc-red-gov-ibsmun
                        tt-ordens-desemb.cClassTribReg-IBSMun
                        tt-ordens-desemb.cCSTReg-IBSMun
                        tt-ordens-desemb.de-aliq-Reg-IBSMun
                        tt-ordens-desemb.cClassTrib-CBS
                        tt-ordens-desemb.cCST-CBS
                        tt-ordens-desemb.c-trib-CBS
                        tt-ordens-desemb.de-aliq-CBS
                        tt-ordens-desemb.perc-red-gov-cbs
                        tt-ordens-desemb.cClassTribReg-CBS
                        tt-ordens-desemb.cCSTReg-CBS
                        tt-ordens-desemb.de-aliq-Reg-CBS
                        tt-ordens-desemb.cClassTrib-IS
                        tt-ordens-desemb.cCST-IS
                        tt-ordens-desemb.c-trib-IS
                        tt-ordens-desemb.de-aliq-IS
                        tt-ordens-desemb.de-aliq-espec-IS
                        tt-ordens-desemb.de-qtde-trib-IS
                        tt-ordens-desemb.c-un-trib-IS WITH BROWSE brSon4.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon2 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon2 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF AVAIL tt-ordens-desemb-acum THEN DO:

        IF  (tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson2 <> tt-ordens-desemb-acum.c-nat-fiscal
             OR i-linha-zoom = brSon2:FOCUSED-ROW IN FRAME fPage1)
        AND (tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson2 <> "") THEN DO:

            RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                                 INPUT tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson2,
                                                 INPUT tt-ordens-desemb-acum.c-it-codigo,
                                                 INPUT 2,
                                                 OUTPUT TABLE tt-bo-erro).

            FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.

            IF AVAIL tt-bo-erro THEN DO:

                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT tt-bo-erro.cd-erro,
                                   INPUT tt-ordens-desemb-acum.c-class-fiscal + "~~":U + tt-bo-erro.parametros).
                RETURN "NOK":U.
            END.

            FIND FIRST tt-nat-oper WHERE tt-nat-oper.c-nat-fiscal-old = tt-ordens-desemb-acum.c-nat-fiscal
                                   AND   tt-nat-oper.c-nat-fiscal-new = tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brSon2
                                   AND   tt-nat-oper.c-class-fiscal   = tt-ordens-desemb-acum.c-class-fiscal
                                   NO-ERROR.
            IF NOT AVAIL tt-nat-oper THEN DO:
                CREATE tt-nat-oper.
                ASSIGN tt-nat-oper.c-nat-fiscal-old = tt-ordens-desemb-acum.c-nat-fiscal
                       tt-nat-oper.c-nat-fiscal-new = tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brSon2
                       tt-nat-oper.c-class-fiscal   = tt-ordens-desemb-acum.c-class-fiscal.
            END.

            ASSIGN INPUT BROWSE brSon2 tt-ordens-desemb-acum.c-nat-fiscal.

            EMPTY TEMP-TABLE tt-ordens-embarque-nat.

            CREATE tt-ordens-embarque-nat.
            BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-embarque-nat.

            RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                                    INPUT tt-ordens-desemb-acum.c-nat-fiscal,
                                                    INPUT p-usuario,
                                                    INPUT p-icms-diferido,
                                                    OUTPUT TABLE tt-ordens-desemb-nat,
                                                    OUTPUT TABLE tt-bo-erro).

            FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

            IF AVAIL tt-ordens-desemb-nat THEN DO:

                ASSIGN tt-ordens-desemb-acum.c-trib-ii          = tt-ordens-desemb-nat.c-trib-ii
                       tt-ordens-desemb-acum.de-aliq-ii         = tt-ordens-desemb-nat.de-aliq-ii
                       tt-ordens-desemb-acum.c-trib-ipi         = tt-ordens-desemb-nat.c-trib-ipi
                       tt-ordens-desemb-acum.de-aliq-ipi        = tt-ordens-desemb-nat.de-aliq-ipi
                       tt-ordens-desemb-acum.c-trib-icms        = tt-ordens-desemb-nat.c-trib-icms
                       tt-ordens-desemb-acum.de-aliq-icms       = tt-ordens-desemb-nat.de-aliq-icms
                       tt-ordens-desemb-acum.l-aplica-desc-icms = tt-ordens-desemb-nat.l-aplica-desc-icms
                       tt-ordens-desemb-acum.c-trib-pis         = tt-ordens-desemb-nat.c-trib-pis
                       tt-ordens-desemb-acum.de-aliq-pis        = tt-ordens-desemb-nat.de-aliq-pis
                       tt-ordens-desemb-acum.c-trib-cofins      = tt-ordens-desemb-nat.c-trib-cofins
                       tt-ordens-desemb-acum.de-aliq-cofins     = tt-ordens-desemb-nat.de-aliq-cofins.

                DISPLAY tt-ordens-desemb-acum.c-trib-ii
                        tt-ordens-desemb-acum.de-aliq-ii
                        tt-ordens-desemb-acum.c-trib-ipi
                        tt-ordens-desemb-acum.de-aliq-ipi
                        tt-ordens-desemb-acum.c-trib-icms
                        tt-ordens-desemb-acum.de-aliq-icms
                        tt-ordens-desemb-acum.l-aplica-desc-icms
                        tt-ordens-desemb-acum.c-trib-pis
                        tt-ordens-desemb-acum.de-aliq-pis
                        tt-ordens-desemb-acum.c-trib-cofins
                        tt-ordens-desemb-acum.de-aliq-cofins WITH BROWSE brSon2.
                IF l-nt2024002 THEN DO:
                    ASSIGN tt-ordens-desemb-acum.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                           tt-ordens-desemb-acum.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                           tt-ordens-desemb-acum.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                           tt-ordens-desemb-acum.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                           tt-ordens-desemb-acum.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                           tt-ordens-desemb-acum.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                           tt-ordens-desemb-acum.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                           tt-ordens-desemb-acum.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                           tt-ordens-desemb-acum.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                           tt-ordens-desemb-acum.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                           tt-ordens-desemb-acum.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                           tt-ordens-desemb-acum.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                           tt-ordens-desemb-acum.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                           tt-ordens-desemb-acum.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                           tt-ordens-desemb-acum.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                           tt-ordens-desemb-acum.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                           tt-ordens-desemb-acum.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                           tt-ordens-desemb-acum.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                           tt-ordens-desemb-acum.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                           tt-ordens-desemb-acum.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                           tt-ordens-desemb-acum.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                           tt-ordens-desemb-acum.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                           tt-ordens-desemb-acum.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                           tt-ordens-desemb-acum.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                           tt-ordens-desemb-acum.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                           tt-ordens-desemb-acum.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                           tt-ordens-desemb-acum.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                           tt-ordens-desemb-acum.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                           tt-ordens-desemb-acum.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                           tt-ordens-desemb-acum.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                           tt-ordens-desemb-acum.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.

                    RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb-acum":U).

                    DISPLAY tt-ordens-desemb-acum.c-trib-ii
                            tt-ordens-desemb-acum.de-aliq-ii
                            tt-ordens-desemb-acum.cClassTrib-IBSUF
                            tt-ordens-desemb-acum.cCST-IBSUF
                            tt-ordens-desemb-acum.c-trib-IBSUF
                            tt-ordens-desemb-acum.de-aliq-IBSUF
                            tt-ordens-desemb-acum.perc-red-gov-ibsuf
                            tt-ordens-desemb-acum.cClassTribReg-IBSUF
                            tt-ordens-desemb-acum.cCSTReg-IBSUF
                            tt-ordens-desemb-acum.de-aliq-Reg-IBSUF
                            tt-ordens-desemb-acum.cClassTrib-IBSMun
                            tt-ordens-desemb-acum.cCST-IBSMun
                            tt-ordens-desemb-acum.c-trib-IBSMun
                            tt-ordens-desemb-acum.de-aliq-IBSMun
                            tt-ordens-desemb-acum.perc-red-gov-ibsmun
                            tt-ordens-desemb-acum.cClassTribReg-IBSMun
                            tt-ordens-desemb-acum.cCSTReg-IBSMun
                            tt-ordens-desemb-acum.de-aliq-Reg-IBSMun
                            tt-ordens-desemb-acum.cClassTrib-CBS
                            tt-ordens-desemb-acum.cCST-CBS
                            tt-ordens-desemb-acum.c-trib-CBS
                            tt-ordens-desemb-acum.de-aliq-CBS
                            tt-ordens-desemb-acum.perc-red-gov-cbs
                            tt-ordens-desemb-acum.cClassTribReg-CBS
                            tt-ordens-desemb-acum.cCSTReg-CBS
                            tt-ordens-desemb-acum.de-aliq-Reg-CBS
                            tt-ordens-desemb-acum.cClassTrib-IS
                            tt-ordens-desemb-acum.cCST-IS
                            tt-ordens-desemb-acum.c-trib-IS
                            tt-ordens-desemb-acum.de-aliq-IS
                            tt-ordens-desemb-acum.de-aliq-espec-IS
                            tt-ordens-desemb-acum.de-qtde-trib-IS
                            tt-ordens-desemb-acum.c-un-trib-IS WITH BROWSE brSon5.
                END.
            END.
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon3 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon3 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF  (tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson3 <> tt-ordens-desemb-acum-adicao.c-nat-fiscal
         OR i-linha-zoom = brSon3:FOCUSED-ROW IN FRAME fpage1)
    AND (tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson3 <> "") THEN DO:

       RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                            INPUT tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson3,
                                            INPUT tt-ordens-desemb-acum-adicao.c-it-codigo,
                                            INPUT 3,
                                            OUTPUT TABLE tt-bo-erro).

       FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.

       IF AVAIL tt-bo-erro THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT tt-bo-erro.cd-erro,
                               INPUT STRING(tt-ordens-desemb-acum-adicao.cdn-adicao) + "~~":U + tt-bo-erro.parametros).
           RETURN "NOK":U.
       END.

       ASSIGN INPUT BROWSE brSon3 tt-ordens-desemb-acum-adicao.c-nat-fiscal.

       EMPTY TEMP-TABLE tt-ordens-embarque-nat.

       CREATE tt-ordens-embarque-nat.
       BUFFER-COPY tt-ordens-desemb-acum-adicao TO tt-ordens-embarque-nat.

       RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                               INPUT tt-ordens-desemb-acum-adicao.c-nat-fiscal,
                                               INPUT p-usuario,
                                               INPUT p-icms-diferido,
                                               OUTPUT TABLE tt-ordens-desemb-nat,
                                               OUTPUT TABLE tt-bo-erro).

       FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

       IF AVAIL tt-ordens-desemb-nat THEN DO:

            ASSIGN tt-ordens-desemb-acum-adicao.c-trib-ii          = tt-ordens-desemb-nat.c-trib-ii
                   tt-ordens-desemb-acum-adicao.de-aliq-ii         = tt-ordens-desemb-nat.de-aliq-ii
                   tt-ordens-desemb-acum-adicao.c-trib-ipi         = tt-ordens-desemb-nat.c-trib-ipi
                   tt-ordens-desemb-acum-adicao.de-aliq-ipi        = tt-ordens-desemb-nat.de-aliq-ipi
                   tt-ordens-desemb-acum-adicao.c-trib-icms        = tt-ordens-desemb-nat.c-trib-icms
                   tt-ordens-desemb-acum-adicao.de-aliq-icms       = tt-ordens-desemb-nat.de-aliq-icms
                   tt-ordens-desemb-acum-adicao.l-aplica-desc-icms = tt-ordens-desemb-nat.l-aplica-desc-icms
                   tt-ordens-desemb-acum-adicao.c-trib-pis         = tt-ordens-desemb-nat.c-trib-pis
                   tt-ordens-desemb-acum-adicao.de-aliq-pis        = tt-ordens-desemb-nat.de-aliq-pis
                   tt-ordens-desemb-acum-adicao.c-trib-cofins      = tt-ordens-desemb-nat.c-trib-cofins
                   tt-ordens-desemb-acum-adicao.de-aliq-cofins     = tt-ordens-desemb-nat.de-aliq-cofins.

            DISPLAY tt-ordens-desemb-acum-adicao.c-trib-ii
                    tt-ordens-desemb-acum-adicao.de-aliq-ii
                    tt-ordens-desemb-acum-adicao.c-trib-ipi
                    tt-ordens-desemb-acum-adicao.de-aliq-ipi
                    tt-ordens-desemb-acum-adicao.c-trib-icms
                    tt-ordens-desemb-acum-adicao.de-aliq-icms
                    tt-ordens-desemb-acum-adicao.l-aplica-desc-icms
                    tt-ordens-desemb-acum-adicao.c-trib-pis
                    tt-ordens-desemb-acum-adicao.de-aliq-pis
                    tt-ordens-desemb-acum-adicao.c-trib-cofins
                    tt-ordens-desemb-acum-adicao.de-aliq-cofins    WITH BROWSE brSon3.

            IF l-nt2024002 THEN DO:
                ASSIGN tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                       tt-ordens-desemb-acum-adicao.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                       tt-ordens-desemb-acum-adicao.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                       tt-ordens-desemb-acum-adicao.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                       tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                       tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                       tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                       tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                       tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                       tt-ordens-desemb-acum-adicao.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                       tt-ordens-desemb-acum-adicao.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                       tt-ordens-desemb-acum-adicao.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                       tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                       tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                       tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                       tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                       tt-ordens-desemb-acum-adicao.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                       tt-ordens-desemb-acum-adicao.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                       tt-ordens-desemb-acum-adicao.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                       tt-ordens-desemb-acum-adicao.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                       tt-ordens-desemb-acum-adicao.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                       tt-ordens-desemb-acum-adicao.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                       tt-ordens-desemb-acum-adicao.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                       tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                       tt-ordens-desemb-acum-adicao.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                       tt-ordens-desemb-acum-adicao.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                       tt-ordens-desemb-acum-adicao.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                       tt-ordens-desemb-acum-adicao.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                       tt-ordens-desemb-acum-adicao.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                       tt-ordens-desemb-acum-adicao.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                       tt-ordens-desemb-acum-adicao.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.

                RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb-acum-adicao":U).

                DISPLAY tt-ordens-desemb-acum-adicao.c-trib-ii
                        tt-ordens-desemb-acum-adicao.de-aliq-ii
                        tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF
                        tt-ordens-desemb-acum-adicao.cCST-IBSUF
                        tt-ordens-desemb-acum-adicao.c-trib-IBSUF
                        tt-ordens-desemb-acum-adicao.de-aliq-IBSUF
                        tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf
                        tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF
                        tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF
                        tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF
                        tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun
                        tt-ordens-desemb-acum-adicao.cCST-IBSMun
                        tt-ordens-desemb-acum-adicao.c-trib-IBSMun
                        tt-ordens-desemb-acum-adicao.de-aliq-IBSMun
                        tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun
                        tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun
                        tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun
                        tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun
                        tt-ordens-desemb-acum-adicao.cClassTrib-CBS
                        tt-ordens-desemb-acum-adicao.cCST-CBS
                        tt-ordens-desemb-acum-adicao.c-trib-CBS
                        tt-ordens-desemb-acum-adicao.de-aliq-CBS
                        tt-ordens-desemb-acum-adicao.perc-red-gov-cbs
                        tt-ordens-desemb-acum-adicao.cClassTribReg-CBS
                        tt-ordens-desemb-acum-adicao.cCSTReg-CBS
                        tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS
                        tt-ordens-desemb-acum-adicao.cClassTrib-IS
                        tt-ordens-desemb-acum-adicao.cCST-IS
                        tt-ordens-desemb-acum-adicao.c-trib-IS
                        tt-ordens-desemb-acum-adicao.de-aliq-IS
                        tt-ordens-desemb-acum-adicao.de-aliq-espec-IS
                        tt-ordens-desemb-acum-adicao.de-qtde-trib-IS
                        tt-ordens-desemb-acum-adicao.c-un-trib-IS WITH BROWSE brSon6.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon4 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon4 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  (tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson4 <> tt-ordens-desemb.c-nat-fiscal
         OR i-linha-zoom = brSon4:FOCUSED-ROW IN FRAME fpage2)
    AND (tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson4 <> "") THEN DO:

        RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                             INPUT tt-ordens-desemb.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson4,
                                             INPUT tt-ordens-desemb.c-it-codigo,
                                             INPUT 1,
                                             OUTPUT TABLE tt-bo-erro).
        FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
        IF AVAIL tt-bo-erro THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT tt-bo-erro.cd-erro,
                               INPUT tt-ordens-desemb.c-it-codigo + "~~":U + tt-bo-erro.parametros).
            RETURN "NOK":U.
        END.

        ASSIGN INPUT BROWSE brSon4 tt-ordens-desemb.c-nat-fiscal.

        EMPTY TEMP-TABLE tt-ordens-embarque-nat.

        CREATE tt-ordens-embarque-nat.
        BUFFER-COPY tt-ordens-desemb TO tt-ordens-embarque-nat.

        RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                                INPUT tt-ordens-desemb.c-nat-fiscal,
                                                INPUT p-usuario,
                                                INPUT p-icms-diferido,
                                                OUTPUT TABLE tt-ordens-desemb-nat,
                                                OUTPUT TABLE tt-bo-erro).

        FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

        IF AVAIL tt-ordens-desemb-nat THEN DO:

            FIND FIRST tt-ordens-embarque NO-LOCK
                 WHERE tt-ordens-embarque.cod-estabel   = tt-ordens-desemb-nat.cod-estabel
                 AND   tt-ordens-embarque.embarque      = tt-ordens-desemb-nat.embarque
                 AND   tt-ordens-embarque.numero-ordem  = tt-ordens-desemb-nat.numero-ordem
                 AND   tt-ordens-embarque.parcela       = tt-ordens-desemb-nat.parcela NO-ERROR.

            ASSIGN tt-ordens-desemb.c-trib-ii            = tt-ordens-desemb-nat.c-trib-ii
                   tt-ordens-desemb.de-aliq-ii           = IF AVAIL tt-ordens-embarque AND tt-ordens-embarque.aliquota-ii <> tt-ordens-desemb.de-aliq-ii THEN tt-ordens-desemb.de-aliq-ii ELSE tt-ordens-desemb-nat.de-aliq-ii
                   tt-ordens-desemb.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                   tt-ordens-desemb.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                   tt-ordens-desemb.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                   tt-ordens-desemb.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                   tt-ordens-desemb.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                   tt-ordens-desemb.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                   tt-ordens-desemb.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                   tt-ordens-desemb.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                   tt-ordens-desemb.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                   tt-ordens-desemb.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                   tt-ordens-desemb.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                   tt-ordens-desemb.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                   tt-ordens-desemb.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                   tt-ordens-desemb.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                   tt-ordens-desemb.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                   tt-ordens-desemb.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                   tt-ordens-desemb.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                   tt-ordens-desemb.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                   tt-ordens-desemb.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                   tt-ordens-desemb.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                   tt-ordens-desemb.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                   tt-ordens-desemb.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                   tt-ordens-desemb.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                   tt-ordens-desemb.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                   tt-ordens-desemb.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                   tt-ordens-desemb.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                   tt-ordens-desemb.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                   tt-ordens-desemb.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                   tt-ordens-desemb.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                   tt-ordens-desemb.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                   tt-ordens-desemb.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.

            RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb":U).

            DISPLAY tt-ordens-desemb.c-trib-ii
                    tt-ordens-desemb.de-aliq-ii
                    tt-ordens-desemb.cClassTrib-IBSUF
                    tt-ordens-desemb.cCST-IBSUF
                    tt-ordens-desemb.c-trib-IBSUF
                    tt-ordens-desemb.de-aliq-IBSUF
                    tt-ordens-desemb.perc-red-gov-ibsuf
                    tt-ordens-desemb.cClassTribReg-IBSUF
                    tt-ordens-desemb.cCSTReg-IBSUF
                    tt-ordens-desemb.de-aliq-Reg-IBSUF
                    tt-ordens-desemb.cClassTrib-IBSMun
                    tt-ordens-desemb.cCST-IBSMun
                    tt-ordens-desemb.c-trib-IBSMun
                    tt-ordens-desemb.de-aliq-IBSMun
                    tt-ordens-desemb.perc-red-gov-ibsmun
                    tt-ordens-desemb.cClassTribReg-IBSMun
                    tt-ordens-desemb.cCSTReg-IBSMun
                    tt-ordens-desemb.de-aliq-Reg-IBSMun
                    tt-ordens-desemb.cClassTrib-CBS
                    tt-ordens-desemb.cCST-CBS
                    tt-ordens-desemb.c-trib-CBS
                    tt-ordens-desemb.de-aliq-CBS
                    tt-ordens-desemb.perc-red-gov-cbs
                    tt-ordens-desemb.cClassTribReg-CBS
                    tt-ordens-desemb.cCSTReg-CBS
                    tt-ordens-desemb.de-aliq-Reg-CBS
                    tt-ordens-desemb.cClassTrib-IS
                    tt-ordens-desemb.cCST-IS
                    tt-ordens-desemb.c-trib-IS
                    tt-ordens-desemb.de-aliq-IS
                    tt-ordens-desemb.de-aliq-espec-IS
                    tt-ordens-desemb.de-qtde-trib-IS
                    tt-ordens-desemb.c-un-trib-IS WITH BROWSE brSon4.
        END.
    END.
    IF l-nt2024002 THEN RUN pi-habilita-campos-red-gov.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon5 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon5 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF AVAIL tt-ordens-desemb-acum THEN DO:

        IF  (tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson5 <> tt-ordens-desemb-acum.c-nat-fiscal
             OR i-linha-zoom = brSon5:FOCUSED-ROW IN FRAME fPage2)
        AND (tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson5 <> "") THEN DO:

            RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                                 INPUT tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson5,
                                                 INPUT tt-ordens-desemb-acum.c-it-codigo,
                                                 INPUT 2,
                                                 OUTPUT TABLE tt-bo-erro).
            FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.

            IF AVAIL tt-bo-erro THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT tt-bo-erro.cd-erro,
                                   INPUT tt-ordens-desemb-acum.c-class-fiscal + "~~":U + tt-bo-erro.parametros).
                RETURN "NOK":U.
            END.

            FIND FIRST tt-nat-oper
                 WHERE tt-nat-oper.c-nat-fiscal-old = tt-ordens-desemb-acum.c-nat-fiscal
                 AND   tt-nat-oper.c-nat-fiscal-new = tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brSon5
                 AND   tt-nat-oper.c-class-fiscal   = tt-ordens-desemb-acum.c-class-fiscal NO-ERROR.
            IF NOT AVAIL tt-nat-oper THEN DO:
                CREATE tt-nat-oper.
                ASSIGN tt-nat-oper.c-nat-fiscal-old = tt-ordens-desemb-acum.c-nat-fiscal
                       tt-nat-oper.c-nat-fiscal-new = tt-ordens-desemb-acum.c-nat-fiscal:SCREEN-VALUE IN BROWSE brSon5
                       tt-nat-oper.c-class-fiscal   = tt-ordens-desemb-acum.c-class-fiscal.
            END.

            ASSIGN INPUT BROWSE brSon5 tt-ordens-desemb-acum.c-nat-fiscal.

            EMPTY TEMP-TABLE tt-ordens-embarque-nat.

            CREATE tt-ordens-embarque-nat.
            BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-embarque-nat.

            RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                                    INPUT tt-ordens-desemb-acum.c-nat-fiscal,
                                                    INPUT p-usuario,
                                                    INPUT p-icms-diferido,
                                                    OUTPUT TABLE tt-ordens-desemb-nat,
                                                    OUTPUT TABLE tt-bo-erro).

            FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

            IF AVAIL tt-ordens-desemb-nat THEN DO:

                ASSIGN tt-ordens-desemb-acum.c-trib-ii            = tt-ordens-desemb-nat.c-trib-ii
                       tt-ordens-desemb-acum.de-aliq-ii           = tt-ordens-desemb-nat.de-aliq-ii
                       tt-ordens-desemb-acum.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                       tt-ordens-desemb-acum.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                       tt-ordens-desemb-acum.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                       tt-ordens-desemb-acum.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                       tt-ordens-desemb-acum.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                       tt-ordens-desemb-acum.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                       tt-ordens-desemb-acum.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                       tt-ordens-desemb-acum.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                       tt-ordens-desemb-acum.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                       tt-ordens-desemb-acum.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                       tt-ordens-desemb-acum.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                       tt-ordens-desemb-acum.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                       tt-ordens-desemb-acum.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                       tt-ordens-desemb-acum.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                       tt-ordens-desemb-acum.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                       tt-ordens-desemb-acum.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                       tt-ordens-desemb-acum.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                       tt-ordens-desemb-acum.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                       tt-ordens-desemb-acum.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                       tt-ordens-desemb-acum.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                       tt-ordens-desemb-acum.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                       tt-ordens-desemb-acum.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                       tt-ordens-desemb-acum.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                       tt-ordens-desemb-acum.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                       tt-ordens-desemb-acum.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                       tt-ordens-desemb-acum.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                       tt-ordens-desemb-acum.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                       tt-ordens-desemb-acum.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                       tt-ordens-desemb-acum.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                       tt-ordens-desemb-acum.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                       tt-ordens-desemb-acum.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.

                RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb-acum":U).

                DISPLAY tt-ordens-desemb-acum.c-trib-ii
                        tt-ordens-desemb-acum.de-aliq-ii
                        tt-ordens-desemb-acum.cClassTrib-IBSUF
                        tt-ordens-desemb-acum.cCST-IBSUF
                        tt-ordens-desemb-acum.c-trib-IBSUF
                        tt-ordens-desemb-acum.de-aliq-IBSUF
                        tt-ordens-desemb-acum.perc-red-gov-ibsuf
                        tt-ordens-desemb-acum.cClassTribReg-IBSUF
                        tt-ordens-desemb-acum.cCSTReg-IBSUF
                        tt-ordens-desemb-acum.de-aliq-Reg-IBSUF
                        tt-ordens-desemb-acum.cClassTrib-IBSMun
                        tt-ordens-desemb-acum.cCST-IBSMun
                        tt-ordens-desemb-acum.c-trib-IBSMun
                        tt-ordens-desemb-acum.de-aliq-IBSMun
                        tt-ordens-desemb-acum.perc-red-gov-ibsmun
                        tt-ordens-desemb-acum.cClassTribReg-IBSMun
                        tt-ordens-desemb-acum.cCSTReg-IBSMun
                        tt-ordens-desemb-acum.de-aliq-Reg-IBSMun
                        tt-ordens-desemb-acum.cClassTrib-CBS
                        tt-ordens-desemb-acum.cCST-CBS
                        tt-ordens-desemb-acum.c-trib-CBS
                        tt-ordens-desemb-acum.de-aliq-CBS
                        tt-ordens-desemb-acum.perc-red-gov-cbs
                        tt-ordens-desemb-acum.cClassTribReg-CBS
                        tt-ordens-desemb-acum.cCSTReg-CBS
                        tt-ordens-desemb-acum.de-aliq-Reg-CBS
                        tt-ordens-desemb-acum.cClassTrib-IS
                        tt-ordens-desemb-acum.cCST-IS
                        tt-ordens-desemb-acum.c-trib-IS
                        tt-ordens-desemb-acum.de-aliq-IS
                        tt-ordens-desemb-acum.de-aliq-espec-IS
                        tt-ordens-desemb-acum.de-qtde-trib-IS
                        tt-ordens-desemb-acum.c-un-trib-IS WITH BROWSE brSon5.
            END.
        END.
    END.
    IF l-nt2024002 THEN RUN pi-habilita-campos-red-gov.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-nat-fiscal-brSon6 wMasterDetail
PROCEDURE pi-leave-nat-fiscal-brSon6 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  (tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson6 <> tt-ordens-desemb-acum-adicao.c-nat-fiscal
         OR i-linha-zoom = brSon6:FOCUSED-ROW IN FRAME fpage2)
    AND (tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson6 <> "") THEN DO:

       RUN validaNatOperItem IN h-bocx225e (INPUT p-nat-operacao,
                                            INPUT tt-ordens-desemb-acum-adicao.c-nat-fiscal:SCREEN-VALUE IN BROWSE brson6,
                                            INPUT tt-ordens-desemb-acum-adicao.c-it-codigo,
                                            INPUT 3,
                                            OUTPUT TABLE tt-bo-erro).
       FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.

       IF AVAIL tt-bo-erro THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT tt-bo-erro.cd-erro,
                               INPUT STRING(tt-ordens-desemb-acum-adicao.cdn-adicao) + "~~":U + tt-bo-erro.parametros).
           RETURN "NOK":U.
       END.

       ASSIGN INPUT BROWSE brSon6 tt-ordens-desemb-acum-adicao.c-nat-fiscal.

       EMPTY TEMP-TABLE tt-ordens-embarque-nat.

       CREATE tt-ordens-embarque-nat.
       BUFFER-COPY tt-ordens-desemb-acum-adicao TO tt-ordens-embarque-nat.

       RUN loadOrdensNatFiscal IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque-nat,
                                               INPUT tt-ordens-desemb-acum-adicao.c-nat-fiscal,
                                               INPUT p-usuario,
                                               INPUT p-icms-diferido,
                                               OUTPUT TABLE tt-ordens-desemb-nat,
                                               OUTPUT TABLE tt-bo-erro).

        FIND FIRST tt-ordens-desemb-nat NO-LOCK NO-ERROR.

        IF AVAIL tt-ordens-desemb-nat THEN DO:

            ASSIGN tt-ordens-desemb-acum-adicao.c-trib-ii            = tt-ordens-desemb-nat.c-trib-ii
                   tt-ordens-desemb-acum-adicao.de-aliq-ii           = tt-ordens-desemb-nat.de-aliq-ii
                   tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF     = tt-ordens-desemb-nat.cClassTrib-IBSUF
                   tt-ordens-desemb-acum-adicao.cCST-IBSUF           = tt-ordens-desemb-nat.cCST-IBSUF
                   tt-ordens-desemb-acum-adicao.c-trib-IBSUF         = tt-ordens-desemb-nat.c-trib-IBSUF
                   tt-ordens-desemb-acum-adicao.de-aliq-IBSUF        = tt-ordens-desemb-nat.de-aliq-IBSUF
                   tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf   = tt-ordens-desemb-nat.perc-red-gov-ibsuf
                   tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF  = tt-ordens-desemb-nat.cClassTribReg-IBSUF
                   tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF        = tt-ordens-desemb-nat.cCSTReg-IBSUF
                   tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF    = tt-ordens-desemb-nat.de-aliq-Reg-IBSUF
                   tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun    = tt-ordens-desemb-nat.cClassTrib-IBSMun
                   tt-ordens-desemb-acum-adicao.cCST-IBSMun          = tt-ordens-desemb-nat.cCST-IBSMun
                   tt-ordens-desemb-acum-adicao.c-trib-IBSMun        = tt-ordens-desemb-nat.c-trib-IBSMun
                   tt-ordens-desemb-acum-adicao.de-aliq-IBSMun       = tt-ordens-desemb-nat.de-aliq-IBSMun
                   tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun  = tt-ordens-desemb-nat.perc-red-gov-ibsmun
                   tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun = tt-ordens-desemb-nat.cClassTribReg-IBSMun
                   tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun       = tt-ordens-desemb-nat.cCSTReg-IBSMun
                   tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun   = tt-ordens-desemb-nat.de-aliq-Reg-IBSMun
                   tt-ordens-desemb-acum-adicao.cClassTrib-CBS       = tt-ordens-desemb-nat.cClassTrib-CBS
                   tt-ordens-desemb-acum-adicao.cCST-CBS             = tt-ordens-desemb-nat.cCST-CBS
                   tt-ordens-desemb-acum-adicao.c-trib-CBS           = tt-ordens-desemb-nat.c-trib-CBS
                   tt-ordens-desemb-acum-adicao.de-aliq-CBS          = tt-ordens-desemb-nat.de-aliq-CBS
                   tt-ordens-desemb-acum-adicao.perc-red-gov-cbs     = tt-ordens-desemb-nat.perc-red-gov-cbs
                   tt-ordens-desemb-acum-adicao.cClassTribReg-CBS    = tt-ordens-desemb-nat.cClassTribReg-CBS
                   tt-ordens-desemb-acum-adicao.cCSTReg-CBS          = tt-ordens-desemb-nat.cCSTReg-CBS
                   tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS      = tt-ordens-desemb-nat.de-aliq-Reg-CBS
                   tt-ordens-desemb-acum-adicao.cClassTrib-IS        = tt-ordens-desemb-nat.cClassTrib-IS
                   tt-ordens-desemb-acum-adicao.cCST-IS              = tt-ordens-desemb-nat.cCST-IS
                   tt-ordens-desemb-acum-adicao.c-trib-IS            = tt-ordens-desemb-nat.c-trib-IS
                   tt-ordens-desemb-acum-adicao.de-aliq-IS           = tt-ordens-desemb-nat.de-aliq-IS
                   tt-ordens-desemb-acum-adicao.de-aliq-espec-IS     = tt-ordens-desemb-nat.de-aliq-espec-IS
                   tt-ordens-desemb-acum-adicao.de-qtde-trib-IS      = tt-ordens-desemb-nat.de-qtde-trib-IS
                   tt-ordens-desemb-acum-adicao.c-un-trib-IS         = tt-ordens-desemb-nat.c-un-trib-IS.
                   .

            RUN piTrataCodTrib(INPUT "display":U, INPUT "tt-ordens-desemb-acum-adicao":U).

            DISPLAY tt-ordens-desemb-acum-adicao.c-trib-ii
                    tt-ordens-desemb-acum-adicao.de-aliq-ii
                    tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF
                    tt-ordens-desemb-acum-adicao.cCST-IBSUF
                    tt-ordens-desemb-acum-adicao.c-trib-IBSUF
                    tt-ordens-desemb-acum-adicao.de-aliq-IBSUF
                    tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf
                    tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF
                    tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF
                    tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF
                    tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun
                    tt-ordens-desemb-acum-adicao.cCST-IBSMun
                    tt-ordens-desemb-acum-adicao.c-trib-IBSMun
                    tt-ordens-desemb-acum-adicao.de-aliq-IBSMun
                    tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun
                    tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun
                    tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun
                    tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun
                    tt-ordens-desemb-acum-adicao.cClassTrib-CBS
                    tt-ordens-desemb-acum-adicao.cCST-CBS
                    tt-ordens-desemb-acum-adicao.c-trib-CBS
                    tt-ordens-desemb-acum-adicao.de-aliq-CBS
                    tt-ordens-desemb-acum-adicao.perc-red-gov-cbs
                    tt-ordens-desemb-acum-adicao.cClassTribReg-CBS
                    tt-ordens-desemb-acum-adicao.cCSTReg-CBS
                    tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS
                    tt-ordens-desemb-acum-adicao.cClassTrib-IS
                    tt-ordens-desemb-acum-adicao.cCST-IS
                    tt-ordens-desemb-acum-adicao.c-trib-IS
                    tt-ordens-desemb-acum-adicao.de-aliq-IS
                    tt-ordens-desemb-acum-adicao.de-aliq-espec-IS
                    tt-ordens-desemb-acum-adicao.de-qtde-trib-IS
                    tt-ordens-desemb-acum-adicao.c-un-trib-IS WITH BROWSE brSon6.
        END.
    END.
    IF l-nt2024002 THEN RUN pi-habilita-campos-red-gov.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-integracao-di wMasterDetail
PROCEDURE pi-verifica-integracao-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-retorno AS LOGICAL  INITIAL NO NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    RUN pi-valida-integracao-di IN h-bocx407(INPUT INPUT FRAME fPage0 tt-embarque-imp.embarque,
                                             INPUT INPUT FRAME fPage0 tt-embarque-imp.cod-estabel,
                                             OUTPUT l-retorno).
    IF l-retorno THEN DO:

        DISABLE btConfirm btReload WITH FRAME fPage0.


        ASSIGN tt-ordens-desemb.c-nat-fiscal                    :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.c-trib-ii                       :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.de-aliq-ii                      :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.c-trib-ipi                      :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.de-aliq-ipi                     :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.c-trib-icms                     :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.de-aliq-icms                    :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.c-trib-pis                      :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.de-aliq-pis                     :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.c-trib-cofins                   :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.de-aliq-cofins                  :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.l-suspensao-II                  :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.l-suspensao-IPI                 :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.cdn-adicao                      :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb.seq-item                        :READ-ONLY IN BROWSE brSon1 = YES
               tt-ordens-desemb-acum.c-nat-fiscal               :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.c-trib-ii                  :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.de-aliq-ii                 :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.c-trib-ipi                 :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.de-aliq-ipi                :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.c-trib-icms                :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.de-aliq-icms               :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.l-aplica-desc-ICMS         :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.c-trib-pis                 :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.de-aliq-pis                :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.c-trib-cofins              :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.de-aliq-cofins             :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.l-suspensao-II             :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum.l-suspensao-IPI            :READ-ONLY IN BROWSE brSon2 = YES
               tt-ordens-desemb-acum-adicao.c-nat-fiscal        :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.c-trib-ii           :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-ii          :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.c-trib-ipi          :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-ipi         :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.c-trib-icms         :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-icms        :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS  :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.c-trib-pis          :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-pis         :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.c-trib-cofins       :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-aliq-cofins      :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.l-suspensao-II      :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.l-suspensao-IPI     :READ-ONLY IN BROWSE brSon3 = YES
               tt-ordens-desemb-acum-adicao.de-taxa-siscomex    :READ-ONLY IN BROWSE brSon3 = YES.

        IF l-nt2024002 THEN
            ASSIGN tt-ordens-desemb.c-nat-fiscal        :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.c-trib-ii           :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-ii          :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.l-suspensao-II      :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCST-IBSUF          :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCST-IBSMun         :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCST-CBS            :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-CBS         :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cClassTrib-IS       :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cCST-IS             :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-IS          :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.c-un-trib-IS        :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.cdn-adicao          :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb.seq-item            :READ-ONLY IN BROWSE brSon4 = YES
                   tt-ordens-desemb-acum.c-nat-fiscal        :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.c-trib-ii           :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-ii          :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.l-suspensao-II      :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCST-IBSUF          :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCST-IBSMun         :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCST-CBS            :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-CBS         :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cClassTrib-IS       :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.cCST-IS             :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-IS          :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum.c-un-trib-IS        :READ-ONLY IN BROWSE brSon5 = YES
                   tt-ordens-desemb-acum-adicao.c-nat-fiscal        :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.c-trib-ii           :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-ii          :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.l-suspensao-II      :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF    :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCST-IBSUF          :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-IBSUF       :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf  :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF       :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun   :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCST-IBSMun         :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-IBSMun      :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun:READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun      :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTrib-CBS      :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCST-CBS            :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-CBS         :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.perc-red-gov-cbs    :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTribReg-CBS   :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCSTReg-CBS         :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cClassTrib-IS       :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.cCST-IS             :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-IS          :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-aliq-espec-IS    :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-qtde-trib-IS     :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.c-un-trib-IS        :READ-ONLY IN BROWSE brSon6 = YES
                   tt-ordens-desemb-acum-adicao.de-taxa-siscomex    :READ-ONLY IN BROWSE brSon6 = YES.
    END.

    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGetFornecedor wMasterDetail
PROCEDURE piGetFornecedor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
     DEF VAR c-return-ordens-emb  AS CHAR NO-UNDO.
     DEF VAR c-return-ordem-compr AS CHAR NO-UNDO.
     DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.

     ASSIGN i-cod-emitente-emb = 0.
     IF AVAIL tt-embarque-imp THEN DO:
         RUN findEmbarque IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                        INPUT tt-embarque-imp.embarque,
                                        OUTPUT c-return-ordens-emb).
         IF c-return-ordens-emb = "" THEN DO:
             RUN getintfield IN h-bocx225 ("numero-ordem", OUTPUT i-numero-ordem).

             RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                         OUTPUT c-return-ordem-compr).
             IF c-return-ordem-compr = "" THEN
                 RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente-emb).
         END.
     END.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataCodTrib wMasterDetail
PROCEDURE piTrataCodTrib :
/*------------------------------------------------------------------------------
  Purpose:     Ajusta c-trib-CBS e c-trib-IBSUF recebe numero (1,2,3,4,5) converte para letra (T,I,O,R,D)
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-acao            AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-tabela          AS CHARACTER NO-UNDO.

    IF p-acao = "display":U THEN DO:
        CASE p-tabela:
            WHEN "tt-ordens-desemb":U THEN
                ASSIGN tt-ordens-desemb.c-trib-CBS    = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-CBS)},1,1)
                       tt-ordens-desemb.c-trib-IBSUF  = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IBSUF)},1,1)
                       tt-ordens-desemb.c-trib-IBSMun = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IBSMun)},1,1)
                       tt-ordens-desemb.c-trib-IS     = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IS)},1,1).
            WHEN "tt-ordens-desemb-acum":U THEN
                ASSIGN tt-ordens-desemb-acum.c-trib-CBS    = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum.c-trib-CBS)},1,1)
                       tt-ordens-desemb-acum.c-trib-IBSUF  = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum.c-trib-IBSUF)},1,1)
                       tt-ordens-desemb-acum.c-trib-IBSMun = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum.c-trib-IBSMun)},1,1)
                       tt-ordens-desemb-acum.c-trib-IS     = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum.c-trib-IS)},1,1).
            WHEN "tt-ordens-desemb-acum-adicao":U THEN
                ASSIGN tt-ordens-desemb-acum-adicao.c-trib-CBS    = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum-adicao.c-trib-CBS)},1,1)
                       tt-ordens-desemb-acum-adicao.c-trib-IBSUF  = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum-adicao.c-trib-IBSUF)},1,1)
                       tt-ordens-desemb-acum-adicao.c-trib-IBSMun = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum-adicao.c-trib-IBSMun)},1,1)
                       tt-ordens-desemb-acum-adicao.c-trib-IS     = SUBSTRING({diinc/i01di628.i 04 INT(tt-ordens-desemb-acum-adicao.c-trib-IS)},1,1).
        END CASE.
    END.
    ELSE
        IF p-acao = "write":U THEN DO:
            FOR EACH tt-ordens-desemb:
                ASSIGN tt-ordens-desemb.c-trib-CBS   = IF tt-ordens-desemb.c-trib-CBS = "T" THEN "1" ELSE
                                                           IF tt-ordens-desemb.c-trib-CBS = "I" THEN "2" ELSE
                                                               IF tt-ordens-desemb.c-trib-CBS = "O" THEN "3" ELSE
                                                                   IF tt-ordens-desemb.c-trib-CBS = "R" THEN "4" ELSE
                                                                       IF tt-ordens-desemb.c-trib-CBS = "S" THEN "5" ELSE
                                                                           "?".
                ASSIGN tt-ordens-desemb.c-trib-IBSUF = IF tt-ordens-desemb.c-trib-IBSUF = "T" THEN "1" ELSE
                                                           IF tt-ordens-desemb.c-trib-IBSUF = "I" THEN "2" ELSE
                                                               IF tt-ordens-desemb.c-trib-IBSUF = "O" THEN "3" ELSE
                                                                   IF tt-ordens-desemb.c-trib-IBSUF = "R" THEN "4" ELSE
                                                                       IF tt-ordens-desemb.c-trib-IBSUF = "S" THEN "5" ELSE
                                                                           "?".
                ASSIGN tt-ordens-desemb.c-trib-IBSMun = IF tt-ordens-desemb.c-trib-IBSMun = "T" THEN "1" ELSE
                                                           IF tt-ordens-desemb.c-trib-IBSMun = "I" THEN "2" ELSE
                                                               IF tt-ordens-desemb.c-trib-IBSMun = "O" THEN "3" ELSE
                                                                   IF tt-ordens-desemb.c-trib-IBSMun = "R" THEN "4" ELSE
                                                                       IF tt-ordens-desemb.c-trib-IBSMun = "S" THEN "5" ELSE
                                                                           "?".
                ASSIGN tt-ordens-desemb.c-trib-IS = IF tt-ordens-desemb.c-trib-IS = "T" THEN "1" ELSE
                                                        IF tt-ordens-desemb.c-trib-IS = "I" THEN "2" ELSE
                                                            IF tt-ordens-desemb.c-trib-IS = "O" THEN "3" ELSE
                                                                IF tt-ordens-desemb.c-trib-IS = "R" THEN "4" ELSE
                                                                    IF tt-ordens-desemb.c-trib-IS = "S" THEN "5" ELSE
                                                                        "?".
            END.
        END.

    RETURN "OK":U.

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
    ASSIGN l-usuarionatureza = YES
           l-im0045          = YES.

    IF NOT VALID-HANDLE(h-boin245) THEN
       RUN inbo/boin245.p PERSISTENT SET h-boin245.

    RUN openQueryStatic IN h-boin245 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin292) THEN
       RUN inbo/boin292.p PERSISTENT SET h-boin292.

    RUN openQueryStatic IN h-boin292 (INPUT "Main":U).

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
    DEFINE VARIABLE cnatureza LIKE natur-oper.nat-operacao  NO-UNDO.

    DEFINE FRAME fGoToRecord
        cusuario   LABEL "Usu†rio" AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cnatureza  LABEL "Natureza de Operaá∆o" AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "Informa Usu†rio/Natureza" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).

    {utp/ut-liter.i "Informa_Usu†rio/Natureza"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ASSIGN cusuario:WIDTH IN FRAME fGoToRecord = 15.00
           cusuario:HEIGHT IN FRAME fGoToRecord = 0.88
           cnatureza:WIDTH IN FRAME fGoToRecord = 9.00
           cnatureza:HEIGHT IN FRAME fGoToRecord = 0.88.

    ASSIGN cusuario:SCREEN-VALUE IN FRAME fGoToRecord = c-seg-usuario.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN cusuario cnatureza.

        IF cusuario = "" THEN DO:

            {utp/ut-liter.i "Usu†rio" *}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 265, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        ELSE DO:

            RUN gotoKey IN h-boin292 (INPUT cusuario).
            IF RETURN-VALUE = "NOK":U THEN DO:

               {utp/ut-liter.i "Usu†rio_do_Recebimento" *}
               RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
               RETURN NO-APPLY.
            END.
        END.

        IF cnatureza = "" THEN DO:

           {utp/ut-liter.i "Natureza_de_operaá∆o" *}
           RUN utp/ut-msgs.p (INPUT "show":U, INPUT 265, INPUT RETURN-VALUE).
           RETURN NO-APPLY.
        END.
        ELSE DO:

            RUN gotokey IN h-boin245 (INPUT cnatureza).
            IF RETURN-VALUE = "NOK":U THEN DO:

               {utp/ut-liter.i "Natureza_de_operaá∆o" *}
               RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
               RETURN NO-APPLY.
            END.
        END.

        ASSIGN p-usuario      = cusuario
               p-nat-operacao = cnatureza.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ON "CHOOSE":U OF btGoToCancel IN FRAME fGotoRecord DO:

        ASSIGN l-usuarionatureza = NO.
        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE cusuario cnatureza btGoToOK btGoToCancel
        WITH FRAME fGoToRecord.

    APPLY "ENTRY":U TO cnatureza IN FRAME fGotoRecord.

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

    DEFINE VARIABLE i-cod-emitente AS INTEGER NO-UNDO.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:

        RUN gotokey IN h-boin274 (INPUT tt-ordens-desemb.numero-ordem).

        IF RETURN-VALUE = "OK":U THEN
            RUN getIntField IN h-boin274 (INPUT "cod-emitente":U, OUTPUT i-cod-emitente).

        RUN gotokey IN h-boin178(INPUT tt-ordens-desemb.c-it-codigo, INPUT i-cod-emitente).

        IF RETURN-VALUE = "OK":U THEN
            ASSIGN tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-fornec.
        ELSE
            ASSIGN tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-item.
        /* fornecedor */
        ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.qt-do-forn.
    END.

    CASE INPUT FRAME fPage0 i-classifica:
        WHEN 1 THEN DO:
            {&OPEN-QUERY-brSon1}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

            IF l-nt2024002 THEN DO:
                {&OPEN-QUERY-brSon4}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon4.
            END.
        END.
        WHEN 2 THEN DO:
            {&OPEN-QUERY-brSon2}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon2.

            IF l-nt2024002 THEN DO:
                {&OPEN-QUERY-brSon5}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon5.
            END.
        END.
        WHEN 3 THEN DO:
            {&OPEN-QUERY-brSon3}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon3.

            IF l-nt2024002 THEN DO:
                {&OPEN-QUERY-brSon6}
                APPLY "VALUE-CHANGED":U TO BROWSE brSon6.
            END.
        END.
    END CASE.

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
  DEFINE INPUT PARAMETER p-cria-acum-aux AS LOGICAL NO-UNDO.

  IF p-cria-acum-aux THEN
      EMPTY TEMP-TABLE tt-ordens-desemb-acum-aux.

  FIND FIRST param-imp NO-LOCK
       WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

  IF (l-fn-imp-adicao-un OR param-imp.log-tax-siscomex) AND l-adicao THEN DO:

      FOR EACH tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK:

          FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK
              WHERE tt-ordens-desemb.cdn-adicao   = tt-ordens-desemb-acum-adicao.cdn-adicao:

              ASSIGN tt-ordens-desemb.c-trib-ii          = tt-ordens-desemb-acum-adicao.c-trib-ii
                     tt-ordens-desemb.de-aliq-ii         = tt-ordens-desemb-acum-adicao.de-aliq-ii
                     tt-ordens-desemb.c-nat-fiscal       = tt-ordens-desemb-acum-adicao.c-nat-fiscal
                     tt-ordens-desemb.l-suspensao-II     = tt-ordens-desemb-acum-adicao.l-suspensao-II
                     tt-ordens-desemb.c-trib-ipi         = tt-ordens-desemb-acum-adicao.c-trib-ipi
                     tt-ordens-desemb.de-aliq-ipi        = tt-ordens-desemb-acum-adicao.de-aliq-ipi
                     tt-ordens-desemb.l-suspensao-IPI    = tt-ordens-desemb-acum-adicao.l-suspensao-IPI
                     tt-ordens-desemb.c-trib-icms        = tt-ordens-desemb-acum-adicao.c-trib-icms
                     tt-ordens-desemb.de-aliq-icms       = tt-ordens-desemb-acum-adicao.de-aliq-icms
                     tt-ordens-desemb.l-aplica-desc-ICMS = tt-ordens-desemb-acum-adicao.l-aplica-desc-ICMS
                     tt-ordens-desemb.c-trib-pis         = tt-ordens-desemb-acum-adicao.c-trib-pis
                     tt-ordens-desemb.de-aliq-pis        = tt-ordens-desemb-acum-adicao.de-aliq-pis
                     tt-ordens-desemb.c-trib-cofins      = tt-ordens-desemb-acum-adicao.c-trib-cofins
                     tt-ordens-desemb.de-aliq-cofins     = tt-ordens-desemb-acum-adicao.de-aliq-cofins
                     tt-ordens-desemb.cClassTrib-IBSUF     = tt-ordens-desemb-acum-adicao.cClassTrib-IBSUF
                     tt-ordens-desemb.cCST-IBSUF           = tt-ordens-desemb-acum-adicao.cCST-IBSUF
                     tt-ordens-desemb.c-trib-IBSUF         = tt-ordens-desemb-acum-adicao.c-trib-IBSUF
                     tt-ordens-desemb.de-aliq-IBSUF        = tt-ordens-desemb-acum-adicao.de-aliq-IBSUF
                     tt-ordens-desemb.perc-red-gov-ibsuf   = tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf
                     tt-ordens-desemb.cClassTribReg-IBSUF  = tt-ordens-desemb-acum-adicao.cClassTribReg-IBSUF
                     tt-ordens-desemb.cCSTReg-IBSUF        = tt-ordens-desemb-acum-adicao.cCSTReg-IBSUF
                     tt-ordens-desemb.de-aliq-Reg-IBSUF    = tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSUF
                     tt-ordens-desemb.cClassTrib-IBSMun    = tt-ordens-desemb-acum-adicao.cClassTrib-IBSMun
                     tt-ordens-desemb.cCST-IBSMun          = tt-ordens-desemb-acum-adicao.cCST-IBSMun
                     tt-ordens-desemb.c-trib-IBSMun        = tt-ordens-desemb-acum-adicao.c-trib-IBSMun
                     tt-ordens-desemb.de-aliq-IBSMun       = tt-ordens-desemb-acum-adicao.de-aliq-IBSMun
                     tt-ordens-desemb.perc-red-gov-ibsmun  = tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun
                     tt-ordens-desemb.cClassTribReg-IBSMun = tt-ordens-desemb-acum-adicao.cClassTribReg-IBSMun
                     tt-ordens-desemb.cCSTReg-IBSMun       = tt-ordens-desemb-acum-adicao.cCSTReg-IBSMun
                     tt-ordens-desemb.de-aliq-Reg-IBSMun   = tt-ordens-desemb-acum-adicao.de-aliq-Reg-IBSMun
                     tt-ordens-desemb.cClassTrib-CBS       = tt-ordens-desemb-acum-adicao.cClassTrib-CBS
                     tt-ordens-desemb.cCST-CBS             = tt-ordens-desemb-acum-adicao.cCST-CBS
                     tt-ordens-desemb.c-trib-CBS           = tt-ordens-desemb-acum-adicao.c-trib-CBS
                     tt-ordens-desemb.de-aliq-CBS          = tt-ordens-desemb-acum-adicao.de-aliq-CBS
                     tt-ordens-desemb.perc-red-gov-cbs     = tt-ordens-desemb-acum-adicao.perc-red-gov-cbs
                     tt-ordens-desemb.cClassTribReg-CBS    = tt-ordens-desemb-acum-adicao.cClassTribReg-CBS
                     tt-ordens-desemb.cCSTReg-CBS          = tt-ordens-desemb-acum-adicao.cCSTReg-CBS
                     tt-ordens-desemb.de-aliq-Reg-CBS      = tt-ordens-desemb-acum-adicao.de-aliq-Reg-CBS
                     tt-ordens-desemb.cClassTrib-IS        = tt-ordens-desemb-acum-adicao.cClassTrib-IS
                     tt-ordens-desemb.cCST-IS              = tt-ordens-desemb-acum-adicao.cCST-IS
                     tt-ordens-desemb.c-trib-IS            = tt-ordens-desemb-acum-adicao.c-trib-IS
                     tt-ordens-desemb.de-aliq-IS           = tt-ordens-desemb-acum-adicao.de-aliq-IS
                     tt-ordens-desemb.de-aliq-espec-IS     = tt-ordens-desemb-acum-adicao.de-aliq-espec-IS
                     tt-ordens-desemb.de-qtde-trib-IS      = tt-ordens-desemb-acum-adicao.de-qtde-trib-IS
                     tt-ordens-desemb.c-un-trib-IS         = tt-ordens-desemb-acum-adicao.c-un-trib-IS.

              IF p-cria-acum-aux THEN DO:

                  IF NOT CAN-FIND(FIRST tt-ordens-desemb-acum-aux
                                  WHERE tt-ordens-desemb-acum-aux.cod-estabel  = tt-ordens-desemb.cod-estabel
                                    AND tt-ordens-desemb-acum-aux.embarque     = tt-ordens-desemb.embarque
                                    AND tt-ordens-desemb-acum-aux.numero-ordem = tt-ordens-desemb.numero-ordem
                                    AND tt-ordens-desemb-acum-aux.parcela      = tt-ordens-desemb.parcela) THEN DO:
                      CREATE tt-ordens-desemb-acum-aux.
                      BUFFER-COPY tt-ordens-desemb TO tt-ordens-desemb-acum-aux.
                  END.
              END.
          END.
      END.
  END.
  ELSE DO:

      FOR EACH tt-nat-oper:
          FOR EACH tt-ordens-desemb
             WHERE tt-ordens-desemb.c-nat-fiscal   = tt-nat-oper.c-nat-fiscal-old
               AND tt-ordens-desemb.c-class-fiscal = tt-nat-oper.c-class-fiscal:
             ASSIGN tt-ordens-desemb.c-nat-fiscal = tt-nat-oper.c-nat-fiscal-new.
          END.
      END.
      EMPTY TEMP-TABLE tt-nat-oper.

      FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:

          IF  i-classifica = 2 THEN DO:
              {imp/im0100d.i2}
          END.
          ELSE DO:
              {imp/im0100d.i2 "tt-ordens-desemb.cdn-adicao = tt-ordens-desemb-acum.cdn-adicao AND"}
          END.
      END.
  END.

  IF p-cria-acum-aux THEN DO:

      EMPTY TEMP-TABLE tt-ordens-desemb-acum.

      FOR EACH tt-ordens-desemb-acum-aux EXCLUSIVE-LOCK:
          CREATE tt-ordens-desemb-acum.
          BUFFER-COPY tt-ordens-desemb-acum-aux TO tt-ordens-desemb-acum.
      END.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensDesembAcum wMasterDetail
PROCEDURE updateOrdensDesembAcum :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
        /* fornecedor */
        ASSIGN tt-ordens-desemb-acum.de-quantidade = tt-ordens-desemb-acum.qt-do-forn
               tt-ordens-desemb-acum.c-un          = tt-ordens-desemb-acum.c-un-fornec.
    END.

    IF INPUT FRAME fPage0 i-classifica = 2 THEN DO:
        {&OPEN-QUERY-brSon2}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon2.

        IF l-nt2024002 THEN DO:
            {&OPEN-QUERY-brSon5}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon5.
        END.
    END.
    ELSE DO:
        {&OPEN-QUERY-brSon3}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon3.

        IF l-nt2024002 THEN DO:
            {&OPEN-QUERY-brSon6}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon6.
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

    IF l-atualizar-despesa THEN DO:

        ASSIGN de-tx-siscomex = 0.

        FOR EACH b-tt-ordens-desemb EXCLUSIVE-LOCK BREAK BY b-tt-ordens-desemb.cdn-adicao:

            IF FIRST-OF(b-tt-ordens-desemb.cdn-adicao) THEN
                ASSIGN de-tx-siscomex = de-tx-siscomex + b-tt-ordens-desemb.de-taxa-siscomex.
        END.

        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

        RUN atzDespesaEmbarque IN h-bocx310 (INPUT INPUT FRAME {&FRAME-NAME} tt-embarque-imp.cod-estabel,
                                             INPUT INPUT FRAME {&FRAME-NAME} tt-embarque-imp.embarque,
                                             INPUT de-tx-siscomex,
                                             OUTPUT TABLE tt-bo-erro).

        IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
           IF NOT VALID-HANDLE(hShowMsg) THEN
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

    RUN piTrataCodTrib(INPUT "write":U, INPUT "").

    RUN updateOrdensEmbarque IN h-bocx225e (INPUT TABLE tt-ordens-desemb,
                                            INPUT 1,
                                            INPUT "",
                                            INPUT p-usuario,
                                            OUTPUT TABLE tt-bo-erro).

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AfterupdateOrdensEmbarque":U,
                                        INPUT "":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fPage0:HANDLE,
                                        INPUT "":U,
                                        INPUT ?) NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-ente-governamental wMasterDetail
PROCEDURE pi-verifica-ente-governamental:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = p-cod-estabel
         NO-ERROR.

    IF AVAILABLE estabelec AND
       LENGTH(estabelec.char-1) >= 400 AND
       SUBSTRING(estabelec.char-1,400,1) >= "1" AND
       SUBSTRING(estabelec.char-1,400,1) <= "9" THEN
        ASSIGN plIsGovEntity   = YES
               plGovEntityType = INT(SUBSTRING(estabelec.char-1,400,1)).
    ELSE
        ASSIGN plIsGovEntity   = NO
               plGovEntityType = 0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos-red-gov wMasterDetail
PROCEDURE pi-habilita-campos-red-gov:

    DEFINE VARIABLE l-read-only AS LOGICAL NO-UNDO.

    ASSIGN l-read-only = NOT plIsGovEntity.

    ASSIGN
        tt-ordens-desemb.perc-red-gov-ibsuf:READ-ONLY
            IN BROWSE brSon4 = l-read-only
        tt-ordens-desemb.perc-red-gov-ibsmun:READ-ONLY
            IN BROWSE brSon4 = l-read-only
        tt-ordens-desemb.perc-red-gov-cbs:READ-ONLY
            IN BROWSE brSon4 = l-read-only

        tt-ordens-desemb-acum.perc-red-gov-ibsuf:READ-ONLY
            IN BROWSE brSon5 = l-read-only
        tt-ordens-desemb-acum.perc-red-gov-ibsmun:READ-ONLY
            IN BROWSE brSon5 = l-read-only
        tt-ordens-desemb-acum.perc-red-gov-cbs:READ-ONLY
            IN BROWSE brSon5 = l-read-only

        tt-ordens-desemb-acum-adicao.perc-red-gov-ibsuf:READ-ONLY
            IN BROWSE brSon6 = l-read-only
        tt-ordens-desemb-acum-adicao.perc-red-gov-ibsmun:READ-ONLY
            IN BROWSE brSon6 = l-read-only
        tt-ordens-desemb-acum-adicao.perc-red-gov-cbs:READ-ONLY
            IN BROWSE brSon6 = l-read-only.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescClassFiscal wMasterDetail
FUNCTION fnDescClassFiscal RETURNS CHARACTER
  ( c-class-fiscal AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(h-boin046na) THEN DO:
      RUN goToKey IN h-boin046na (INPUT c-class-fiscal).
      IF RETURN-VALUE = "OK":U THEN
          RUN getCharField IN h-boin046na (INPUT "descricao":U,
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

    RETURN c-it-codigo.   /* Function return value. */
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

  &IF "{&FNC_MULTI_IDIOMA}" = "Yes":U &THEN
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {ininc/i07in122.i 04 i-trib-icms}.

      RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-icms = RETURN-VALUE.
  &ELSE
      ASSIGN c-trib-icms = {ininc/i07in122.i 04 i-trib-icms}.
  &ENDIF

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

  &IF "{&FNC_MULTI_IDIOMA}" = "Yes":U &THEN
      DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao002 = {ininc/i10in172.i 04 i-trib-ii}.

      RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-ii = RETURN-VALUE.
  &ELSE
      ASSIGN c-trib-ii = {ininc/i10in172.i 04 i-trib-ii}.
  &ENDIF

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

  &IF "{&FNC_MULTI_IDIOMA}" = "Yes":U &THEN
      DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao003 = {ininc/i10in172.i 04 i-trib-ipi}.

      RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  c-trib-ipi = RETURN-VALUE.
  &ELSE
      ASSIGN c-trib-ipi = {ininc/i10in172.i 04 i-trib-ipi}.
  &ENDIF

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

