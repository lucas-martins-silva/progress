/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**   
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i IM0440B 2.00.00.019 } /*** "010019" 22/01/2026 14:18:20 ***/
/*****************************************************************************
**
**       Programa: im0440b
**
**       Data....: 03/01/2012
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Extrado da Declara‡Æo de Importa‡Æo, layout: por DI-EMS/Embarque/Item
**
**       VersÆo..: 1.00.000 - imp
**
**       OBS.....: 
**
*******************************************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dialet_corren AS CHARACTER    NO-UNDO.
FIND FIRST param-global NO-LOCK NO-ERROR.

/****************** Defini‡Æo de Tabelas Temporÿrias do Relat¢rio **********************/
/* 
 * a include im0440.i possui a defini‡Æo das vari veis e temp-tables usadas no relat¢rio em ambos os layout (por adi‡Æo / por embarque)
 * defini‡Æo dos frames usados pelos dois layouts.
 * cria‡Æo das temp-tables
*/
{imp/im0440.i}
{cxbo/bocx225.i tt-ordens-embarque}
{cxbo/bocx310.i tt-desp-embarque2}

DEFINE VARIABLE c-num-embarque      LIKE embarque-imp.embarque        NO-UNDO.
DEFINE VARIABLE c-cabec-embarque    AS CHAR FORMAT "X(132)"           NO-UNDO.
DEFINE VARIABLE c-emb-fornecedor    AS CHAR FORMAT "X(50)"            NO-UNDO.
DEFINE VARIABLE c-emb-pais          LIKE emitente.pais                NO-UNDO.
DEFINE VARIABLE de-tot-peso-bruto   LIKE ordens-embarque.peso-bruto   NO-UNDO.
DEFINE VARIABLE de-tot-peso-liquido LIKE ordens-embarque.peso-liquido NO-UNDO.

DEF VAR c-return-ordens-emb  AS CHAR                        NO-UNDO.
DEF VAR c-return-ordem-compr AS CHAR                        NO-UNDO.
DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
DEF VAR i-cod-emitente       LIKE ordem-compra.cod-emitente NO-UNDO.

/*variaveis itens do embarque*/
DEFINE VARIABLE c-item                     LIKE ITEM.it-codigo                                NO-UNDO.
DEFINE VARIABLE c-desc-item                LIKE ITEM.desc-item                                NO-UNDO.
DEFINE VARIABLE c-un                       LIKE ITEM.un                                       NO-UNDO.
DEFINE VARIABLE i-num-adic                 LIKE decla-import-ord.num-adic                     NO-UNDO.
DEFINE VARIABLE c-classif                  LIKE item.class-fiscal                             NO-UNDO.
DEFINE VARIABLE de-valor-material          AS DECIMAL                                         NO-UNDO.
DEFINE VARIABLE de-preco-total             AS DECIMAL                                         NO-UNDO.
DEFINE VARIABLE de-perc-reduc-pis          AS DECIMAL FORMAT ">>9.99"                         NO-UNDO.
DEFINE VARIABLE de-perc-reduc-icms         AS DECIMAL FORMAT ">>9.99"                         NO-UNDO.
DEFINE VARIABLE de-perc-reduc-cofins       AS DECIMAL FORMAT ">>9.99"                         NO-UNDO.
DEFINE VARIABLE de-perc-reduc-ipi          AS DECIMAL FORMAT ">>9.99"                         NO-UNDO.
DEFINE VARIABLE de-perc-reduc-impto-import AS DECIMAL FORMAT ">>9.99"                         NO-UNDO.

DEFINE VARIABLE c-tributac-pis             AS CHAR FORMAT "X(1)"                              NO-UNDO.
DEFINE VARIABLE de-val-base-pis            LIKE decla-import-adic-itens.val-base-pis          NO-UNDO.
DEFINE VARIABLE de-val-pis-db-cr           LIKE decla-import-adic-itens.val-pis-db-cr         NO-UNDO.
DEFINE VARIABLE c-tributac-icms            AS CHAR FORMAT "X(1)"                              NO-UNDO.
DEFINE VARIABLE de-val-base-icms           LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-icms-db-cr          LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.
DEFINE VARIABLE c-tributac-cofins          AS CHAR FORMAT "X(1)"                              NO-UNDO.
DEFINE VARIABLE de-val-base-cofins         LIKE decla-import-adic-itens.val-base-cofins       NO-UNDO.
DEFINE VARIABLE de-val-cofins-db-cr        LIKE decla-import-adic-itens.val-cofins-db-cr      NO-UNDO.
DEFINE VARIABLE c-tributac-ipi             AS CHAR FORMAT "X(1)"                              NO-UNDO.
DEFINE VARIABLE de-val-base-ipi            LIKE decla-import-adic-itens.val-base-ipi          NO-UNDO.
DEFINE VARIABLE de-val-ipi-db-cr           LIKE decla-import-adic-itens.val-ipi-db-cr         NO-UNDO.
DEFINE VARIABLE c-tributac-ii              AS CHAR FORMAT "X(1)"                              NO-UNDO.
DEFINE VARIABLE de-val-base-ii             LIKE decla-import-adic-itens.val-base-ii           NO-UNDO.
DEFINE VARIABLE de-val-ii-db-cr            LIKE decla-import-adic-itens.val-ii-db-cr          NO-UNDO.
DEFINE VARIABLE de-val-frete               LIKE decla-import-adic-itens.val-frete             NO-UNDO.
DEFINE VARIABLE de-val-seguro              LIKE decla-import-adic-itens.val-seguro            NO-UNDO.
DEFINE VARIABLE de-val-acresc              LIKE decla-import-adic-itens.val-acresc            NO-UNDO.

DEFINE VARIABLE c-trib-ibs-uf              AS CHARACTER  FORMAT "x(1)"                        NO-UNDO.
DEFINE VARIABLE de-perc-ibs-uf             AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-ibs-uf             LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-ibs-uf              LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.
DEFINE VARIABLE de-perc-ibs-uf-reg         AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-ibs-uf-reg         LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-ibs-uf-reg          LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.

DEFINE VARIABLE c-trib-ibs-mun             AS CHARACTER  FORMAT "x(1)"                        NO-UNDO.
DEFINE VARIABLE de-perc-ibs-mun            AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-ibs-mun            LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-ibs-mun             LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.
DEFINE VARIABLE de-perc-ibs-mun-reg        AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-ibs-mun-reg        LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-ibs-mun-reg         LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.

DEFINE VARIABLE c-trib-cbs                 AS CHARACTER  FORMAT "x(1)"                        NO-UNDO.
DEFINE VARIABLE de-perc-cbs                AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-cbs                LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-cbs                 LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.
DEFINE VARIABLE de-perc-cbs-reg            AS DECIMAL    FORMAT ">>9.99"                      NO-UNDO.
DEFINE VARIABLE de-base-cbs-reg            LIKE decla-import-adic-itens.val-base-icms         NO-UNDO.
DEFINE VARIABLE de-val-cbs-reg             LIKE decla-import-adic-itens.val-icms-db-cr        NO-UNDO.

DEFINE VARIABLE c-ie-vmle-moeda   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-ie-vmld-moeda   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-ie-vmcv-moeda   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-ie-frete-moeda  LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-ie-seguro-moeda LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-ie-acresc-moeda LIKE moeda.descricao NO-UNDO.

DEFINE VARIABLE d-ie-vmle-valor-me   LIKE decla-import-adic-itens.val-vmle         NO-UNDO.
DEFINE VARIABLE d-ie-vmle-valor-mn   LIKE decla-import-adic-itens.val-vmle-me[2]   NO-UNDO.
DEFINE VARIABLE d-ie-vmld-valor-me   LIKE decla-import-adic-itens.val-vmld         NO-UNDO.
DEFINE VARIABLE d-ie-vmld-valor-mn   LIKE decla-import-adic-itens.val-vmld-me[2]   NO-UNDO.
DEFINE VARIABLE d-ie-vmcv-valor-me   LIKE decla-import-adic-itens.val-vmcv         NO-UNDO.
DEFINE VARIABLE d-ie-vmcv-valor-mn   LIKE decla-import-adic-itens.val-vmcv-me[2]   NO-UNDO.
DEFINE VARIABLE d-ie-frete-valor-me  LIKE decla-import-adic-itens.val-frete        NO-UNDO.
DEFINE VARIABLE d-ie-frete-valor-mn  LIKE decla-import-adic-itens.val-frete-me[2]  NO-UNDO.
DEFINE VARIABLE d-ie-seguro-valor-me LIKE decla-import-adic-itens.val-seguro       NO-UNDO.
DEFINE VARIABLE d-ie-seguro-valor-mn LIKE decla-import-adic-itens.val-seguro-me[2] NO-UNDO.
DEFINE VARIABLE d-ie-acresc-valor-me LIKE decla-import-adic-itens.val-acresc       NO-UNDO.
DEFINE VARIABLE d-ie-acresc-valor-mn LIKE decla-import-adic-itens.val-acresc-me[2] NO-UNDO.
DEFINE VARIABLE l-first              AS LOGICAL INITIAL YES NO-UNDO.

DEFINE VARIABLE de-tot-ii          LIKE decla-import-adic-itens.val-ii-db-cr     NO-UNDO.
DEFINE VARIABLE de-tot-ipi         LIKE decla-import-adic-itens.val-ipi-db-cr    NO-UNDO.
DEFINE VARIABLE de-tot-pis         LIKE decla-import-adic-itens.val-pis-db-cr    NO-UNDO.
DEFINE VARIABLE de-tot-cofins      LIKE decla-import-adic-itens.val-cofins-db-cr NO-UNDO.
DEFINE VARIABLE de-tot-icms        LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-total-impostos  LIKE decla-import-adic-itens.val-ii-db-cr     NO-UNDO.
DEFINE VARIABLE de-tot-ibs-uf      LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-tot-ibs-mun     LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-tot-cbs         LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-tot-ibs-uf-reg  LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-tot-ibs-mun-reg LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEFINE VARIABLE de-tot-cbs-reg     LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.

/* variaveis do custo de nacionalizacao e internacao do embarque*/
DEFINE VARIABLE c-cne-frete-moeda                LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-frete-valor-me             LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-frete-valor-mn             LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-frete-perc-naci            AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-frete-perc-inte            AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-seguro-moeda               LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-seguro-valor-me            like decla-import.val-seguro                                          NO-UNDO.
DEFINE VARIABLE d-cne-seguro-valor-mn            like decla-import.val-seguro                                          NO-UNDO.
DEFINE VARIABLE d-cne-seguro-perc-naci           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-seguro-perc-inte           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-vmle-moeda                 LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-vmle-valor-me              like decla-import.val-vmle                                            NO-UNDO.
DEFINE VARIABLE d-cne-vmle-valor-mn              like decla-import.val-vmle                                            NO-UNDO.
DEFINE VARIABLE c-cne-vmld-moeda                 LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-vmld-valor-me              like decla-import.val-vmld                                            NO-UNDO.
DEFINE VARIABLE d-cne-vmld-valor-mn              like decla-import.val-vmld                                            NO-UNDO.
DEFINE VARIABLE d-cne-vmld-perc-naci             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-vmld-perc-inte             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-vmcv-moeda                 LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-vmcv-valor-me              like decla-import.val-vmcv                                            NO-UNDO.
DEFINE VARIABLE d-cne-vmcv-valor-mn              like decla-import.val-vmcv                                            NO-UNDO.
DEFINE VARIABLE d-cne-vmcv-perc-naci             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-vmcv-perc-inte             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-acresc-moeda               LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-acresc-valor-me            like decla-import.val-acresc                                          NO-UNDO.
DEFINE VARIABLE d-cne-acresc-valor-mn            like decla-import.val-acresc                                          NO-UNDO.
DEFINE VARIABLE d-cne-acresc-perc-naci           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-acresc-perc-inte           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-base-ii                LIKE decla-import.val-base-ii                                         NO-UNDO.
DEFINE VARIABLE d-cne-val-ii-nao-tribut          LIKE decla-import.val-ii-nao-tribut                                   NO-UNDO.
DEFINE VARIABLE d-cne-val-ii-db-cr               LIKE decla-import.val-ii-db-cr                                        NO-UNDO. /*‚ tamb‚m o valor mn*/
DEFINE VARIABLE d-cne-val-ii-outras              LIKE decla-import.val-ii-outras                                       NO-UNDO.
DEFINE VARIABLE c-cne-ii-moeda                   LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-ii-valor-me                LIKE decla-import.val-ii-db-cr                                        NO-UNDO.
DEFINE VARIABLE d-cne-ii-perc-naci               AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-ii-perc-inte               AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-base-ipi               LIKE decla-import.val-base-ipi                                        NO-UNDO.
DEFINE VARIABLE d-cne-val-ipi-nao-tributad       LIKE decla-import.val-ipi-nao-tributad                                NO-UNDO.
DEFINE VARIABLE d-cne-val-ipi-db-cr              LIKE decla-import.val-ipi-db-cr                                       NO-UNDO. /*‚ tamb‚m o valor mn*/
DEFINE VARIABLE d-cne-val-ipi-outras             LIKE decla-import.val-ipi-outras                                      NO-UNDO.
DEFINE VARIABLE c-cne-ipi-moeda                  LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-ipi-valor-me               LIKE decla-import.val-ipi-db-cr                                       NO-UNDO.
DEFINE VARIABLE d-cne-ipi-perc-naci              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-ipi-perc-inte              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-base-pis               LIKE decla-import.val-base-pis                                        NO-UNDO.
DEFINE VARIABLE d-cne-val-pis-nao-tributad       LIKE decla-import.val-pis-nao-tributad                                NO-UNDO.
DEFINE VARIABLE d-cne-val-pis-db-cr              LIKE decla-import.val-pis-db-cr                                       NO-UNDO. /*‚ tamb‚m o valor mn*/
DEFINE VARIABLE d-cne-val-pis-outras             LIKE decla-import.val-pis-outras                                      NO-UNDO.
DEFINE VARIABLE c-cne-pis-moeda                  LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-pis-valor-me               LIKE decla-import.val-pis-db-cr                                       NO-UNDO.
DEFINE VARIABLE d-cne-pis-perc-naci              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-pis-perc-inte              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-base-cofins            LIKE decla-import.val-base-cofins                                     NO-UNDO.
DEFINE VARIABLE d-cne-val-cofins-nao-tributad    LIKE decla-import.val-cofins-nao-tribut                               NO-UNDO.
DEFINE VARIABLE d-cne-val-cofins-db-cr           LIKE decla-import.val-cofins-db-cr                                    NO-UNDO. /*‚ tamb‚m o valor mn*/
DEFINE VARIABLE d-cne-val-cofins-outras          LIKE decla-import.val-cofins-outras                                   NO-UNDO.
DEFINE VARIABLE c-cne-cofins-moeda               LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-cofins-valor-me            LIKE decla-import.val-cofins-db-cr                                    NO-UNDO.
DEFINE VARIABLE d-cne-cofins-perc-naci           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-cofins-perc-inte           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-base-icms              LIKE decla-import.val-base-icms                                       NO-UNDO.
DEFINE VARIABLE d-cne-val-icms-nao-tributad      LIKE decla-import.val-icms-nao-tribut                                 NO-UNDO.
DEFINE VARIABLE d-cne-val-icms-db-cr             LIKE decla-import.val-icms-db-cr                                      NO-UNDO. /*‚ tamb‚m o valor mn*/
DEFINE VARIABLE d-cne-val-icms-outras            LIKE decla-import.val-icms-outras                                     NO-UNDO.
DEFINE VARIABLE c-cne-icms-moeda                 LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-icms-valor-me              LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-icms-perc-naci             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-icms-perc-inte             AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-tot-imp-me             LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-tot-imp-mn             LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-tot-imp-naci           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-tot-imp-inte           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-desp-n-incid-moeda         LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-desp-n-incid-valor-me      LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-desp-n-incid-valor-mn      LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-desp-n-incid-perc-naci     AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-desp-n-incid-perc-inte     AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-val-nac-moeda              LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-val-nac-valor-me           LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-val-nac-valor-mn           LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-val-nac-perc-naci          AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-val-nac-perc-inte          AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-desp-comp-moeda            LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-desp-comp-valor-me         LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-desp-comp-valor-mn         LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-desp-comp-perc-inte        AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-val-int-moeda              LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-val-int-valor-me           LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-val-int-valor-mn           LIKE decla-import.val-frete                                           NO-UNDO.
DEFINE VARIABLE d-cne-val-int-perc-inte          AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
/* FIM-variaveis do custo de nacionalizacao e internacao do embarque*/

DEFINE VARIABLE c-cne-ibs-uf-moeda               LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-ibs-uf-valor-me            LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-ibs-uf-db-cr           LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-ibs-uf-perc-naci           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-ibs-uf-perc-inte           AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-ibs-mun-moeda              LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-ibs-mun-valor-me           LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-ibs-mun-db-cr          LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-ibs-mun-perc-naci          AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-ibs-mun-perc-inte          AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-cbs-moeda                  LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-cbs-valor-me               LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-cbs-db-cr              LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-cbs-perc-naci              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-cbs-perc-inte              AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE c-cne-cbs-aduan-moeda            LIKE moeda.descricao                                                  NO-UNDO.
DEFINE VARIABLE d-cne-cbs-aduan-valor-me         LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-val-cbs-aduan-db-cr        LIKE decla-import.val-icms-db-cr                                      NO-UNDO.
DEFINE VARIABLE d-cne-cbs-aduan-perc-naci        AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE d-cne-cbs-aduan-perc-inte        AS DECIMAL                         FORMAT "zz9.99"                    NO-UNDO.
DEFINE VARIABLE i-trib-ibsuf                     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-trib-cbs                       AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-bocx225    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383a   AS HANDLE NO-UNDO.

IF NOT VALID-HANDLE(h-bocx225) THEN
    RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

IF NOT VALID-HANDLE(h-boin274) THEN
    RUN inbo/boin274.p PERSISTENT SET h-boin274.

IF NOT VALID-HANDLE(h-bocx383a) THEN
    RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.


/*defini‡Æo dos forms que s¢ serÆo utilizados por este layout (im0440a.p)*/
FORM HEADER 
        SKIP(2)
        "*" FILL("-",58) FORMAT "X(58)" "Embarques" FILL("-",59) FORMAT "X(59)" "*"
    WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecEmbarques.

FORM 
   SKIP(2)
    c-cabec-embarque        NO-LABEL                  AT 001
   SKIP(1)
    c-emb-fornecedor        LABEL "Fornecedor"        AT 012
    c-emb-pais              LABEL "Pa¡s"              AT 092
   SKIP(1)
    de-tot-peso-liquido     LABEL "Peso Liquido (Kg)" AT 005
    de-tot-peso-bruto       LABEL "Peso Bruto (Kg)"   AT 081
   SKIP
   WITH WIDTH 132 SIDE-LABEL NO-BOX STREAM-IO FRAME f-embarques.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-embarques:HANDLE).


/* itens do embarque */
FORM HEADER
    "*" FILL("-",45) FORMAT "X(45)"
    "ITENS DO EMBARQUE NR.:" 
    TRIM(c-num-embarque)
    FILL("-",46) FORMAT "X(46)" "*"    
   SKIP
    "Parc"                      AT 001
    "Item"                      AT 007
    "Descri‡Æo"                 AT 024
    "OrdCompra"                 AT 089
    "OrdProd"                   AT 104
    "Pedido"                    AT 113
    "Nr.Adic"                   AT 126
    SKIP
    "Classifica‡Æo"             AT 007
    "Un"                        AT 021
    "Quantidade"                AT 035
    "Pre‡o Unit rio"            AT 057
    "Valor Material"            AT 093
    "Pre‡o Total"               AT 121
    SKIP
    "PIS"                       AT 007
    "% PIS"                     AT 011
    "Base C lculo PIS"          AT 029
    "Valor PIS"                 AT 062
    "ICMS"                      AT 073
    "% ICMS"                    AT 078
    "Base C lculo ICMS"         AT 090
    "Valor ICMS"                AT 122
    SKIP
    "COF"                       AT 007
    "% COF"                     AT 011
    "Base C lculo COF"          AT 029
    "Valor COF"                 AT 062
    "IPI"                       AT 073
    "% IPI"                     AT 079
    "Base C lculo IPI"          AT 091
    "Valor IPI"                 AT 123
    SKIP
    "II"                        AT 007
    "% II"                      AT 011
    "Base C lculo II"           AT 030
    "Valor II"                  AT 063
    "Frete"                     AT 040
    "Seguro"                    AT 065
    "Acrescimos"                AT 097
   SKIP
    FILL("-",132) FORMAT "X(132)"
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecItensEmbarq.
   
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM HEADER
    "*" FILL("-",45) FORMAT "X(45)"
    "ITENS DO EMBARQUE NR.:" 
    TRIM(c-num-embarque)
    FILL("-",46) FORMAT "X(46)" "*"    
   SKIP
    "Parc"                      AT 001
    "Item"                      AT 007
    "Descri‡Æo"                 AT 024
    "OrdCompra"                 AT 089
    "OrdProd"                   AT 104
    "Pedido"                    AT 113
    "Nr.Adic"                   AT 126
    SKIP
    "Classifica‡Æo"             AT 007
    "Un"                        AT 021
    "Quantidade"                AT 035
    "Pre‡o Unit rio"            AT 057
    "Valor Material"            AT 093
    "Pre‡o Total"               AT 121
    SKIP
    "PIS"                       AT 007
    "% PIS"                     AT 011
    "Base C lculo PIS"          AT 029
    "Valor PIS"                 AT 062
    "ICMS"                      AT 073
    "% ICMS"                    AT 078
    "Base C lculo ICMS"         AT 090
    "Valor ICMS"                AT 122
    SKIP
    "COF"                       AT 007
    "% COF"                     AT 011
    "Base C lculo COF"          AT 029
    "Valor COF"                 AT 062
    "IPI"                       AT 073
    "% IPI"                     AT 079
    "Base C lculo IPI"          AT 091
    "Valor IPI"                 AT 123
    SKIP
    "II"                        AT 007
    "% II"                      AT 011
    "Base C lculo II"           AT 030
    "Valor II"                  AT 063
    
    SKIP
    "IBS UF"                    AT 004
    "% IBS UF"                  AT 011
    "Base C lc IBS UF"          AT 029
    "Valor IBS UF"              AT 059
    "%IBS UF Reg"               AT 073
    "Base IBS UF Reg"           AT 092
    "Valor IBS UF Reg"          AT 116
    SKIP
    "IBS Mun"                   AT 003
    "% IBS Mun"                 AT 011
    "Base C lc IBS Mun"         AT 028
    "Valor IBS Mun"             AT 058
    "%IBS Mun Reg"              AT 072
    "Base IBS Mun Reg"          AT 091
    "Valor IBS Mun Reg"         AT 115
    SKIP
    "CBS"                       AT 007
    "% CBS"                     AT 011
    "Base C lc CBS"             AT 032
    "Valor CBS"                 AT 062
    "%CBS Reg"                  AT 076
    "Base CBS Reg"              AT 095
    "Valor CBS Reg"             AT 119
    
    SKIP
    "Frete"                     AT 040
    "Seguro"                    AT 065
    "Acrescimos"                AT 097
   SKIP
    FILL("-",132) FORMAT "X(132)"
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecItensEmbarqCbsIbs.
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

FORM 
    tt-ordens-embarque.parcela                                      AT 001
    c-item                                                          AT 007
    c-desc-item                                                     AT 024
    ordem-compra.numero-ordem                                       AT 089
    ordem-compra.ordem-servic                                       AT 100
    ordem-compra.nr-pedcli                                          AT 113
    i-num-adic                                                      AT 129
                                                                    
    c-classif                                                       AT 007
    c-un                                                            AT 021 
    tt-ordens-embarque.quantidade                                   AT 028
    ordem-compra.preco-unit                                         AT 052
    de-valor-material                                               AT 097
    de-preco-total                                                  AT 122
                                                                    
    decla-import-adic-itens.idi-tributac-pis                        AT 007
    de-perc-reduc-pis                                               AT 011
    decla-import-adic-itens.val-base-pis                            AT 023
    decla-import-adic-itens.val-pis-db-cr                           AT 049
    decla-import-adic-itens.idi-tributac-icms                       AT 073
    de-perc-reduc-icms                                              AT 079

    decla-import-adic-itens.val-base-icms                           AT 085
    decla-import-adic-itens.val-icms-db-cr                          AT 110
                                                                  
    decla-import-adic-itens.idi-tributac-cofins                     AT 007
    de-perc-reduc-cofins                                            AT 011
    decla-import-adic-itens.val-base-cofins                         AT 023
    decla-import-adic-itens.val-cofins-db-cr                        AT 049
    decla-import-adic-itens.idi-tributac-ipi                        AT 073
    de-perc-reduc-ipi                                               AT 079
    decla-import-adic-itens.val-base-ipi                            AT 085
    decla-import-adic-itens.val-ipi-db-cr                           AT 110
                                                                   
    decla-import-adic-itens.idi-tributac-impto-import               AT 007
    de-perc-reduc-impto-import                                      AT 011
    decla-import-adic-itens.val-base-ii                             AT 023
    decla-import-adic-itens.val-ii-db-cr                            AT 049
                                                                  
    decla-import-adic-itens.val-frete                               AT 021
    decla-import-adic-itens.val-seguro                              AT 047
    decla-import-adic-itens.val-acresc                              AT 083
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-itensEmbarq.
   
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM 
    tt-ordens-embarque.parcela                                      AT 001
    c-item                                                          AT 007
    c-desc-item                                                     AT 024
    ordem-compra.numero-ordem                                       AT 089
    ordem-compra.ordem-servic                                       AT 100
    ordem-compra.nr-pedcli                                          AT 113
    i-num-adic                                                      AT 129
                                                                    
    c-classif                                                       AT 007
    c-un                                                            AT 021 
    tt-ordens-embarque.quantidade                                   AT 028
    ordem-compra.preco-unit                                         AT 052
    de-valor-material                                               AT 097
    de-preco-total                                                  AT 122
                                                                    
    decla-import-adic-itens.idi-tributac-pis                        AT 007
    de-perc-reduc-pis                                               AT 011
    decla-import-adic-itens.val-base-pis                            AT 023
    decla-import-adic-itens.val-pis-db-cr                           AT 049
    decla-import-adic-itens.idi-tributac-icms                       AT 073
    de-perc-reduc-icms                                              AT 079

    decla-import-adic-itens.val-base-icms                           AT 085
    decla-import-adic-itens.val-icms-db-cr                          AT 110
                                                                  
    decla-import-adic-itens.idi-tributac-cofins                     AT 007
    de-perc-reduc-cofins                                            AT 011
    decla-import-adic-itens.val-base-cofins                         AT 023
    decla-import-adic-itens.val-cofins-db-cr                        AT 049
    decla-import-adic-itens.idi-tributac-ipi                        AT 073
    de-perc-reduc-ipi                                               AT 079
    decla-import-adic-itens.val-base-ipi                            AT 085
    decla-import-adic-itens.val-ipi-db-cr                           AT 110
                                                                   
    decla-import-adic-itens.idi-tributac-impto-import               AT 007
    de-perc-reduc-impto-import                                      AT 011
    decla-import-adic-itens.val-base-ii                             AT 023
    decla-import-adic-itens.val-ii-db-cr                            AT 049
    
    c-trib-ibs-uf                                                   AT 007
    de-perc-ibs-uf                                                  AT 011
    de-base-ibs-uf                                                  AT 023
    de-val-ibs-uf                                                   AT 049
    de-perc-ibs-uf-reg                                              AT 079
    de-base-ibs-uf-reg                                              AT 085
    de-val-ibs-uf-reg                                               AT 110

    c-trib-ibs-mun                                                  AT 007
    de-perc-ibs-mun                                                 AT 011
    de-base-ibs-mun                                                 AT 023
    de-val-ibs-mun                                                  AT 049
    de-perc-ibs-mun-reg                                             AT 079
    de-base-ibs-mun-reg                                             AT 085
    de-val-ibs-mun-reg                                              AT 110

    c-trib-cbs                                                      AT 007
    de-perc-cbs                                                     AT 011
    de-base-cbs                                                     AT 023
    de-val-cbs                                                      AT 049
    de-perc-cbs-reg                                                 AT 079
    de-base-cbs-reg                                                 AT 085
    de-val-cbs-reg                                                  AT 110
                                                                  
    decla-import-adic-itens.val-frete                               AT 021
    decla-import-adic-itens.val-seguro                              AT 047
    decla-import-adic-itens.val-acresc                              AT 083
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-itensEmbarqCbsIbs.
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

FORM HEADER
   SKIP(3)
    "*" FILL("-",44) FORMAT "X(44)"
    "VALORES DO EMBARQUE NR.:" 
    TRIM(c-num-embarque)
    FILL("-",45) FORMAT "X(45)" "*"  
   SKIP
    "Moeda"                     AT 037
    "Valor MN"                  AT 075
    "Valor ME"                  AT 101
   SKIP
    "---------------------"     AT 037
    "------------------------"  AT 059
    "------------------------"  AT 085
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecValEmbarq.

FORM "VMLE:"                   AT 031              
     c-ie-vmle-moeda           AT 037              
     d-ie-vmle-valor-me        AT 059              
     d-ie-vmle-valor-mn        AT 085              
    SKIP                                                                 
     "VMLD:"                   AT 031              
     c-ie-vmld-moeda           AT 037              
     d-ie-vmld-valor-me        AT 059 
     d-ie-vmld-valor-mn        AT 085 
    SKIP
     "VMCV:"                   AT 031
     c-ie-vmcv-moeda           AT 037 
     d-ie-vmcv-valor-me        AT 059 
     d-ie-vmcv-valor-mn        AT 085 
    SKIP
     "Frete:"                  AT 030
     c-ie-frete-moeda          AT 037              
     d-ie-frete-valor-me       AT 059              
     d-ie-frete-valor-mn       AT 085              
    SKIP                                                              
     "Seguro:"                 AT 029              
     c-ie-seguro-moeda         AT 037             
     d-ie-seguro-valor-me      AT 059             
     d-ie-seguro-valor-mn      AT 085             
    SKIP      
     "Acr‚scimos:"             AT 025
     c-ie-acresc-moeda         AT 037 
     d-ie-acresc-valor-mn      AT 059 
     d-ie-acresc-valor-me      AT 085 
    WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-valEmbarq. 

/* impostos do embarque */
FORM HEADER 
   SKIP(3)
    "*" FILL("-",38) FORMAT "X(38)"
    "TOTAIS DOS IMPOSTOS DO EMBARQUE NR:. " 
    TRIM(c-num-embarque)
    FILL("-",38) FORMAT "X(38)" "*" 
   SKIP(1)
    "Valor"                   AT 077
   SKIP
    "----------------------"  AT 060
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecImpEmbarq.

FORM 
    "II:"                       AT 056
    de-tot-ii                   AT 060
   SKIP
    "IPI:"                      AT 055
    de-tot-ipi                  AT 060
   SKIP
    "PIS:"                      AT 055
    de-tot-pis                  AT 060
   SKIP
    "COFINS:"                   AT 052
    de-tot-cofins               AT 060
   SKIP
    "ICMS:"                     AT 054
    de-tot-icms                 AT 060
   SKIP(1)
    "Totais:"                   AT 052
    de-total-impostos           AT 060
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-impEmbarq.
   
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM 
    "II:"                       AT 056
    de-tot-ii                   AT 060
   SKIP
    "IPI:"                      AT 055
    de-tot-ipi                  AT 060
   SKIP
    "PIS:"                      AT 055
    de-tot-pis                  AT 060
   SKIP
    "COFINS:"                   AT 052
    de-tot-cofins               AT 060
   SKIP
    "ICMS:"                     AT 054
    de-tot-icms                 AT 060
   SKIP
    "IBS UF:"                   AT 052
    de-tot-ibs-uf               AT 060
   SKIP
    "IBS Mun:"                  AT 051
    de-tot-ibs-mun              AT 060
   SKIP
    "CBS:"                      AT 055
    de-tot-cbs                  AT 060
   SKIP
    "IBS UF Regular:"           AT 044
    de-tot-ibs-uf-reg           AT 060
   SKIP
    "IBS Mun Regular:"          AT 043
    de-tot-ibs-mun-reg          AT 060
   SKIP
    "CBS Regular:"              AT 047
    de-tot-cbs-reg              AT 060
   SKIP(1)
    "Totais:"                   AT 052
    de-total-impostos           AT 060
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-impEmbarqCbsIbs.   
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
/* fim - impostos do embarque */

FORM HEADER
    SKIP(2)
    "*" FILL("-",45) FORMAT "X(45)" 
    "DESPESAS EMBARQUE NR.: " TRIM(c-num-embarque)
    FILL("-",45) FORMAT "X(45)" "*"
   SKIP
    "Despesa"          at 007  
    "Moeda"            at 040  
    "Taxa Cambio"      at 059  
    "Forma Pre."       at 074  
    "Tipo Despesa"     at 086  
    "Incoterm"         at 110  
   SKIP                        
    "Fornecedor"       at 007  
    "Condi‡Æo Pagto"   at 040  
    "Dupl"             at 067  
    "II"               at 074  
    "IPI"              at 080  
    "ICMS"             at 086  
    "PIS-ADU"          at 093  
    "PIS-DESP"         at 102  
    "COFINS-ADU"       at 112  
   SKIP                       
    "COFINS-DESP"      at 007  
    "Valor-ME"         at 040  
    "Valor-MN"         at 072  
   FILL("-",130) FORMAT "X(130)" AT 002
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecDespesEmbarq.
   
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM HEADER
    SKIP(2)
    "*" FILL("-",45) FORMAT "X(45)" 
    "DESPESAS EMBARQUE NR.: " TRIM(c-num-embarque)
    FILL("-",45) FORMAT "X(45)" "*"
   SKIP
    "Despesa"          at 007  
    "Moeda"            at 040  
    "Taxa Cambio"      at 059  
    "Forma Pre."       at 074  
    "Tipo Despesa"     at 086  
    "Incoterm"         at 110  
   SKIP                        
    "Fornecedor"       at 007  
    "Condi‡Æo Pagto"   at 040  
    "Dupl"             at 067  
    "II"               at 074  
    "IPI"              at 080  
    "ICMS"             at 086  
    "PIS-ADU"          at 093  
    "PIS-DESP"         at 102  
    "COFINS-ADU"       at 112  
   SKIP                       
    "COFINS-DESP"      at 007
    "IBS UF"           at 024
    "IBS Mun"          at 035
    "CBS"              at 046
    "Valor-ME"         at 077
    "Valor-MN"         AT 109
   FILL("-",130) FORMAT "X(130)" AT 002
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecDespesEmbarqCbsIbs.
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

                            
FORM  tt-desp-embarque2.cod-desp                             AT 007      
      c-desc-desp                                            AT 013      
      c-desp-moeda                                           AT 040      
      d-taxa-camb                                            AT 053      
      tt-desp-embarque2.log-forma-preco-compra               AT 074      
      c-tipo-despes                                          AT 086      
      tt-desp-embarque2.cod-incoterm-rat                     AT 110      
     SKIP                                                                
      tt-desp-embarque2.cod-emitente-desp                    AT 007      
      c-desc-emitente                                        AT 016      
      tt-desp-embarque2.cod-cond-pag                         AT 040      
      c-desc-cond-pagto                                      AT 044      
      l-duplic                                               AT 067      
      l-ii                                                   AT 074      
      l-ipi                                                  AT 080      
      l-icms                                                 AT 086      
      l-pis-adu                                              AT 093      
      l-pis-desp                                             AT 102      
      l-cofins-adu                                           AT 113      
     SKIP                                                                
      l-cofins-desp                                          AT 007      
      d-valor-me                                             AT 024      
      d-valor-mn                                             AT 056
     SKIP(2)
    WITH DOWN WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-despesEmbarq.
    
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM  tt-desp-embarque2.cod-desp                             AT 007      
      c-desc-desp                                            AT 013      
      c-desp-moeda                                           AT 040      
      d-taxa-camb                                            AT 053      
      tt-desp-embarque2.log-forma-preco-compra               AT 074      
      c-tipo-despes                                          AT 086      
      tt-desp-embarque2.cod-incoterm-rat                     AT 110      
     SKIP                                                                
      tt-desp-embarque2.cod-emitente-desp                    AT 007      
      c-desc-emitente                                        AT 016      
      tt-desp-embarque2.cod-cond-pag                         AT 040      
      c-desc-cond-pagto                                      AT 044      
      l-duplic                                               AT 067      
      l-ii                                                   AT 074      
      l-ipi                                                  AT 080      
      l-icms                                                 AT 086      
      l-pis-adu                                              AT 093      
      l-pis-desp                                             AT 102      
      l-cofins-adu                                           AT 113      
     SKIP                                                                
      l-cofins-desp                                          AT 007      
      l-ibs-uf                                               AT 025
      l-ibs-mun                                              AT 035
      l-cbs                                                  AT 046
      d-valor-me                                             AT 063
      d-valor-mn                                             AT 095
     SKIP(2)
    WITH DOWN WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-despesEmbarqCbsIbs.
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

FORM HEADER
    SKIP(3)
    "*" FILL("-",39) FORMAT "X(39)"
    "Custos de Nacionalia‡Æo e Interna‡Æo do Embarque"
    FILL("-",39) FORMAT "X(39)" "*"
    SKIP(1)
    "Moeda"                                 AT 032
    "Valor MN"                              AT 070
    "Valor ME"                              AT 096
    "% Nac"                                 AT 108
    "% Interna‡Æo"                          AT 115
    SKIP
    FILL("-",20) FORMAT "X(20)"             AT 032
    FILL("-",24) FORMAT "X(24)"             AT 054
    FILL("-",24) FORMAT "X(24)"             AT 080
    FILL("-",6)  FORMAT "X(6)"              AT 107
    FILL("-",12) FORMAT "X(12)"             AT 115
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecCustNacEmbarq.

FORM 
    "Valor Mercadoria(VMCV) :"      AT 006
    c-cne-vmcv-moeda                AT 032
    d-cne-vmcv-valor-me             AT 054
    d-cne-vmcv-valor-mn             AT 080
    d-cne-vmcv-perc-naci            AT 107
    d-cne-vmcv-perc-inte            AT 121
   SKIP                                              
    "Frete :"                       AT 023
    c-cne-frete-moeda               AT 032
    d-cne-frete-valor-me            AT 054
    d-cne-frete-valor-mn            AT 080
    d-cne-frete-perc-naci           AT 107
    d-cne-frete-perc-inte           AT 121
   SKIP                                              
    "Seguro :"                      AT 022
    c-cne-seguro-moeda              AT 032
    d-cne-seguro-valor-me           AT 054
    d-cne-seguro-valor-mn           AT 080
    d-cne-seguro-perc-naci          AT 107
    d-cne-seguro-perc-inte          AT 121
   SKIP                                              
    "Acrescimos :"                  AT 018
    c-cne-acresc-moeda              AT 032
    d-cne-acresc-valor-me           AT 054
    d-cne-acresc-valor-mn           AT 080
    d-cne-acresc-perc-naci          AT 107
    d-cne-acresc-perc-inte          AT 121
   SKIP                                              
    "Valor Aduaneiro(VMLD) :"       AT 007
    c-cne-vmld-moeda                AT 032
    d-cne-vmld-valor-me             AT 054
    d-cne-vmld-valor-mn             AT 080
    d-cne-vmld-perc-naci            AT 107
    d-cne-vmld-perc-inte            AT 121
   SKIP(1)                                           
    "II :"                          AT 026
    c-cne-ii-moeda                  AT 032
    d-cne-ii-valor-me               AT 056
    d-cne-val-ii-db-cr              AT 082
    d-cne-ii-perc-naci              AT 107
    d-cne-ii-perc-inte              AT 121
   SKIP                                              
    "IPI :"                         AT 025
    c-cne-ipi-moeda                 AT 032
    d-cne-ipi-valor-me              AT 056
    d-cne-val-ipi-db-cr             AT 082
    d-cne-ipi-perc-naci             AT 107
    d-cne-ipi-perc-inte             AT 121
   SKIP                                              
    "PIS/PASEP :"                   AT 019
    c-cne-pis-moeda                 AT 032
    d-cne-pis-valor-me              AT 056
    d-cne-val-pis-db-cr             AT 082
    d-cne-pis-perc-naci             AT 107
    d-cne-pis-perc-inte             AT 121
   SKIP                                              
    "COFINS :"                      AT 022
    c-cne-cofins-moeda              AT 032
    d-cne-cofins-valor-me           AT 056
    d-cne-val-cofins-db-cr          AT 082
    d-cne-cofins-perc-naci          AT 107
    d-cne-cofins-perc-inte          AT 121
   SKIP                                              
    "ICMS :"                        AT 024
    c-cne-icms-moeda                AT 032
    d-cne-icms-valor-me             AT 056
    d-cne-val-icms-db-cr            AT 082
    d-cne-icms-perc-naci            AT 107
    d-cne-icms-perc-inte            AT 121
   SKIP(1)                                           
    "TOTAL Impostos :"              AT 014
    d-cne-val-tot-imp-me            AT 056
    d-cne-val-tot-imp-mn            AT 082
    d-cne-val-tot-imp-naci          AT 107
    d-cne-val-tot-imp-inte          AT 121
   SKIP(1)
    "VALOR NACIONALIZADO :"         AT 009                      
    c-cne-val-nac-moeda             AT 032 
    d-cne-val-nac-valor-me          AT 054
    d-cne-val-nac-valor-mn          AT 080
    d-cne-val-nac-perc-naci         AT 107
    d-cne-val-nac-perc-inte         AT 121
   SKIP(1)
    "Despesas Complementares :"     AT 005                      
    c-cne-desp-comp-moeda           AT 032 
    d-cne-desp-comp-valor-me        AT 054
    d-cne-desp-comp-valor-mn        AT 080
    d-cne-desp-comp-perc-inte       AT 121 
   SKIP                                             
    "VALOR INTERNALIZADO :"         AT 009
    c-cne-val-int-moeda             AT 032
    d-cne-val-int-valor-me          AT 054
    d-cne-val-int-valor-mn          AT 080
    d-cne-val-int-perc-inte         AT 121 
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-custNacEmbarq.
   
/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
FORM 
    "Valor Mercadoria(VMCV) :"      AT 006
    c-cne-vmcv-moeda                AT 032
    d-cne-vmcv-valor-me             AT 054
    d-cne-vmcv-valor-mn             AT 080
    d-cne-vmcv-perc-naci            AT 107
    d-cne-vmcv-perc-inte            AT 121
   SKIP                                              
    "Frete :"                       AT 023
    c-cne-frete-moeda               AT 032
    d-cne-frete-valor-me            AT 054
    d-cne-frete-valor-mn            AT 080
    d-cne-frete-perc-naci           AT 107
    d-cne-frete-perc-inte           AT 121
   SKIP                                              
    "Seguro :"                      AT 022
    c-cne-seguro-moeda              AT 032
    d-cne-seguro-valor-me           AT 054
    d-cne-seguro-valor-mn           AT 080
    d-cne-seguro-perc-naci          AT 107
    d-cne-seguro-perc-inte          AT 121
   SKIP                                              
    "Acrescimos :"                  AT 018
    c-cne-acresc-moeda              AT 032
    d-cne-acresc-valor-me           AT 054
    d-cne-acresc-valor-mn           AT 080
    d-cne-acresc-perc-naci          AT 107
    d-cne-acresc-perc-inte          AT 121
   SKIP                                              
    "Valor Aduaneiro(VMLD) :"       AT 007
    c-cne-vmld-moeda                AT 032
    d-cne-vmld-valor-me             AT 054
    d-cne-vmld-valor-mn             AT 080
    d-cne-vmld-perc-naci            AT 107
    d-cne-vmld-perc-inte            AT 121
   SKIP(1)                                           
    "II :"                          AT 026
    c-cne-ii-moeda                  AT 032
    d-cne-ii-valor-me               AT 056
    d-cne-val-ii-db-cr              AT 082
    d-cne-ii-perc-naci              AT 107
    d-cne-ii-perc-inte              AT 121
   SKIP                                              
    "IPI :"                         AT 025
    c-cne-ipi-moeda                 AT 032
    d-cne-ipi-valor-me              AT 056
    d-cne-val-ipi-db-cr             AT 082
    d-cne-ipi-perc-naci             AT 107
    d-cne-ipi-perc-inte             AT 121
   SKIP                                              
    "PIS/PASEP :"                   AT 019
    c-cne-pis-moeda                 AT 032
    d-cne-pis-valor-me              AT 056
    d-cne-val-pis-db-cr             AT 082
    d-cne-pis-perc-naci             AT 107
    d-cne-pis-perc-inte             AT 121
   SKIP                                              
    "COFINS :"                      AT 022
    c-cne-cofins-moeda              AT 032
    d-cne-cofins-valor-me           AT 056
    d-cne-val-cofins-db-cr          AT 082
    d-cne-cofins-perc-naci          AT 107
    d-cne-cofins-perc-inte          AT 121
   SKIP
    "ICMS :"                        AT 024
    c-cne-icms-moeda                AT 032
    d-cne-icms-valor-me             AT 056
    d-cne-val-icms-db-cr            AT 082
    d-cne-icms-perc-naci            AT 107
    d-cne-icms-perc-inte            AT 121
   SKIP
    "IBS UF :"                      AT 022
    c-cne-ibs-uf-moeda              AT 032
    d-cne-ibs-uf-valor-me           AT 056
    d-cne-val-ibs-uf-db-cr          AT 082
    d-cne-ibs-uf-perc-naci          AT 107
    d-cne-ibs-uf-perc-inte          AT 121
   SKIP
    "IBS Mun :"                     AT 021
    c-cne-ibs-mun-moeda             AT 032
    d-cne-ibs-mun-valor-me          AT 056
    d-cne-val-ibs-mun-db-cr         AT 082
    d-cne-ibs-mun-perc-naci         AT 107
    d-cne-ibs-mun-perc-inte         AT 121
   SKIP
    "CBS :"                         AT 025
    c-cne-cbs-moeda                 AT 032
    d-cne-cbs-valor-me              AT 056
    d-cne-val-cbs-db-cr             AT 082
    d-cne-cbs-perc-naci             AT 107
    d-cne-cbs-perc-inte             AT 121
   SKIP(1)                                           
    "TOTAL Impostos :"              AT 014
    d-cne-val-tot-imp-me            AT 056
    d-cne-val-tot-imp-mn            AT 082
    d-cne-val-tot-imp-naci          AT 107
    d-cne-val-tot-imp-inte          AT 121
   SKIP(1)
    "VALOR NACIONALIZADO :"         AT 009                      
    c-cne-val-nac-moeda             AT 032 
    d-cne-val-nac-valor-me          AT 054
    d-cne-val-nac-valor-mn          AT 080
    d-cne-val-nac-perc-naci         AT 107
    d-cne-val-nac-perc-inte         AT 121
   SKIP(1)
    "Despesas Complementares :"     AT 005                      
    c-cne-desp-comp-moeda           AT 032 
    d-cne-desp-comp-valor-me        AT 054
    d-cne-desp-comp-valor-mn        AT 080
    d-cne-desp-comp-perc-inte       AT 121 
   SKIP                                             
    "VALOR INTERNALIZADO :"         AT 009
    c-cne-val-int-moeda             AT 032
    d-cne-val-int-valor-me          AT 054
    d-cne-val-int-valor-mn          AT 080
    d-cne-val-int-perc-inte         AT 121 
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-custNacEmbarqCbsIbs.
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
/*############################################################################################################################################################*/


FOR EACH tt-decla-import,
        EACH decla-import-ord WHERE decla-import-ord.num-di-ems       = tt-decla-import.num-di-ems
                              AND   decla-import-ord.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                              NO-LOCK:
            
            FIND FIRST ordens-embarque NO-LOCK
                    WHERE ordens-embarque.embarque     = decla-import-ord.cod-embarq
                    AND   ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                    AND   ordens-embarque.parcela      = decla-import-ord.num-parcela
                    AND   ordens-embarque.cod-estabel  = decla-import-ord.cod-estab.
            
            IF NOT CAN-FIND(FIRST tt-ordens-embarque
                                WHERE tt-ordens-embarque.embarque     = ordens-embarque.embarque
                                AND   tt-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem  
                                AND   tt-ordens-embarque.parcela      = ordens-embarque.parcela
                                AND   tt-ordens-embarque.cod-estabel  = ordens-embarque.cod-estabel)  THEN DO:
                CREATE tt-ordens-embarque.
                BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
            END.
END.
DEFINE BUFFER bf-ordens-embarq FOR ordens-embarque.

/*tt-desp-embarque2*/
FOR EACH tt-decla-import,
        EACH decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-di-ems       = tt-decla-import.num-di-ems
            AND   decla-import-ord.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
    FOR EACH desp-embarque NO-LOCK
            WHERE desp-embarque.cod-estabel = decla-import-ord.cod-estab
            AND   desp-embarque.embarque    = decla-import-ord.cod-embarq:
        IF NOT CAN-FIND(FIRST tt-desp-embarque2
                                WHERE tt-desp-embarque2.cod-estabel       = desp-embarque.cod-estabel      
                                AND   tt-desp-embarque2.embarque          = desp-embarque.embarque         
                                AND   tt-desp-embarque2.cod-itiner        = desp-embarque.cod-itiner       
                                AND   tt-desp-embarque2.cod-pto-contr     = desp-embarque.cod-pto-contr    
                                AND   tt-desp-embarque2.cod-desp          = desp-embarque.cod-desp         
                                AND   tt-desp-embarque2.cod-emitente-desp = desp-embarque.cod-emitente-desp) THEN DO:
            CREATE tt-desp-embarque2.
            BUFFER-COPY desp-embarque TO tt-desp-embarque2.
        END.

    END.
END.
/* fim tt-desp-embarque2*/
/* fim - carregar as temp-tables */


/*##################### Disp dos forms #############################*/
FOR EACH tt-decla-import:
    {imp/im0440.i2} /*disp das frames comuns em ambos os layouts (im0440a e im0440b)*/

    FOR EACH decla-import-embarq
            WHERE decla-import-embarq.num-di-ems       = tt-decla-import.num-di-ems
            AND   decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
            NO-LOCK:
        
        FOR FIRST embarque-imp
                WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
                AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq NO-LOCK:

            /*l¢gica do im0545*/
            RUN findEmbarque IN h-bocx225 (INPUT embarque-imp.cod-estabel,
                                           INPUT embarque-imp.embarque,
                                           OUTPUT c-return-ordens-emb).
            IF c-return-ordens-emb = "" THEN DO:
                 RUN getintfield IN h-bocx225 ("numero-ordem":U, OUTPUT i-numero-ordem).
        
                 RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                             OUTPUT c-return-ordem-compr).
                 IF c-return-ordem-compr = "" THEN
                     RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).

                 
                 ASSIGN c-num-embarque    = embarque-imp.embarque
                        c-cabec-embarque  = "* " + FILL("-",50) + " Embarque Nr.: " + c-num-embarque + " " + FILL("-",50) + " *".

                 /*busca dados do fornecedor*/
                 FIND FIRST emitente
                         WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.
                 IF AVAIL emitente THEN
                     ASSIGN c-emb-fornecedor = string(emitente.cod-emitente) + "-" + emitente.nome-abrev
                            c-emb-pais       = emitente.pais.
                 
                 /* calculo dos pesos*/         
                 
                 ASSIGN de-tot-peso-bruto   = 0
                        de-tot-peso-liquido = 0.
                 FOR EACH bf-ordens-embarq
                    WHERE bf-ordens-embarq.cod-estabel = embarque-imp.cod-estabel
                    AND   bf-ordens-embarq.embarque    = embarque-imp.embarque:
                    ASSIGN de-tot-peso-bruto   = de-tot-peso-bruto   + bf-ordens-embarq.peso-bruto
                           de-tot-peso-liquido = de-tot-peso-liquido + bf-ordens-embarq.peso-liquido.
                 END.
                 /* fim - calculo dos pesos*/
                 

                 VIEW FRAME f-cabecEmbarques.
                 DISP
                     c-cabec-embarque
                     c-emb-fornecedor 
                     c-emb-pais       
                     de-tot-peso-liquido
                     de-tot-peso-bruto
                    WITH FRAME f-embarques.
                
                 
                 ASSIGN l-first = YES.
                 
                 /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                 IF  l-nt2024002 THEN DO:
                     VIEW FRAME f-cabecItensEmbarqCbsIbs.
                     
                     ASSIGN de-tot-ibs-uf      = 0
                            de-tot-ibs-mun     = 0
                            de-tot-cbs         = 0
                            de-tot-ibs-uf-reg  = 0
                            de-tot-ibs-mun-reg = 0
                            de-tot-cbs-reg     = 0.
                 END.
                 /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                 ELSE DO:
                     VIEW FRAME f-cabecItensEmbarq.
                 END.
                 
                 FOR EACH  decla-import-ord NO-LOCK
                     WHERE decla-import-ord.num-di-ems       = tt-decla-import.num-di-ems
                     AND   decla-import-ord.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:

                    /*zera as variaveis do frame custos de nacionaliza‡Æo do embarque (f-custNacEmbarq)*/
                    ASSIGN d-cne-val-ii-db-cr            = 0
                           d-cne-val-ipi-db-cr           = 0
                           d-cne-val-pis-db-cr           = 0
                           d-cne-val-cofins-db-cr        = 0
                           d-cne-val-icms-db-cr          = 0
                           d-cne-ii-valor-me             = 0
                           d-cne-ipi-valor-me            = 0
                           d-cne-pis-valor-me            = 0
                           d-cne-cofins-valor-me         = 0
                           d-cne-icms-valor-me           = 0
                           
                           d-cne-frete-perc-naci         = 0
                           d-cne-frete-perc-inte         = 0
                           d-cne-seguro-perc-naci        = 0
                           d-cne-seguro-perc-inte        = 0
                           d-cne-vmld-perc-naci          = 0
                           d-cne-vmld-perc-inte          = 0
                           d-cne-vmcv-perc-naci          = 0
                           d-cne-vmcv-perc-inte          = 0
                           d-cne-acresc-perc-naci        = 0
                           d-cne-acresc-perc-inte        = 0
                           d-cne-ii-perc-naci            = 0
                           d-cne-ii-perc-inte            = 0
                           d-cne-ipi-perc-naci           = 0
                           d-cne-ipi-perc-inte           = 0
                           d-cne-pis-perc-naci           = 0
                           d-cne-pis-perc-inte           = 0
                           d-cne-cofins-perc-naci        = 0
                           d-cne-cofins-perc-inte        = 0
                           d-cne-icms-perc-naci          = 0
                           d-cne-icms-perc-inte          = 0
                           d-cne-val-tot-imp-naci        = 0
                           d-cne-val-tot-imp-inte        = 0
            
                           d-cne-desp-n-incid-perc-naci  = 0
                           d-cne-desp-n-incid-perc-inte  = 0
                           d-cne-val-nac-perc-naci       = 0
                           d-cne-val-nac-perc-inte       = 0
                           d-cne-desp-comp-perc-inte     = 0
                           d-cne-val-int-perc-inte       = 0.
                           
                    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                    IF  l-nt2024002 THEN DO:
                        ASSIGN d-cne-ibs-uf-valor-me  = 0
                               d-cne-ibs-mun-valor-me = 0
                               d-cne-cbs-valor-me     = 0.
                    END.
                 
                    FOR EACH  tt-ordens-embarque
                        WHERE tt-ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                        AND   tt-ordens-embarque.embarque     = decla-import-ord.cod-embarq
                        AND   tt-ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                        AND   tt-ordens-embarque.parcela      = decla-import-ord.num-parcela:
    
                        FIND FIRST ordem-compra 
                            WHERE  ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
                        
                        FIND FIRST decla-import-adic-itens
                            WHERE  decla-import-adic-itens.num-di-ems       = decla-import-ord.num-di-ems
                            AND    decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                            AND    decla-import-adic-itens.num-adic         = decla-import-ord.num-adic
                            AND    decla-import-adic-itens.num-seq          = decla-import-ord.num-seq NO-LOCK NO-ERROR.
    
                        FIND FIRST ITEM NO-LOCK
                            WHERE  ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.
                        IF  AVAIL  ITEM THEN
                            ASSIGN c-item      = ITEM.it-codigo
                                   c-desc-item = ITEM.desc-item
                                   c-un        = ITEM.un
                                   c-classif   = ITEM.class-fiscal.
                        ELSE
                            ASSIGN c-item      = ""
                                   c-desc-item = ""
                                   c-un        = ""
                                   c-classif   = "".

                        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                        IF  l-nt2024002 THEN DO:
                            ASSIGN c-trib-ibs-uf   = ""
                                   c-trib-ibs-mun  = ""
                                   c-trib-cbs      = ""
                                   de-perc-ibs-uf  = 0
                                   de-perc-ibs-mun = 0
                                   de-perc-cbs     = 0
                                   de-base-ibs-uf  = 0
                                   de-base-ibs-mun = 0
                                   de-base-cbs     = 0
                                   de-val-ibs-uf   = 0
                                   de-val-ibs-mun  = 0
                                   de-val-cbs      = 0
                                   de-perc-ibs-uf-reg  = 0
                                   de-perc-ibs-mun-reg = 0
                                   de-perc-cbs-reg     = 0
                                   de-base-ibs-uf-reg  = 0
                                   de-base-ibs-mun-reg = 0
                                   de-base-cbs-reg     = 0
                                   de-val-ibs-uf-reg   = 0
                                   de-val-ibs-mun-reg  = 0
                                   de-val-cbs-reg      = 0.
                                   
                            FOR EACH  decla-import-adic-trib NO-LOCK
                                WHERE decla-import-adic-trib.num-di-ems       = decla-import-adic-itens.num-di-ems                                
                                AND   decla-import-adic-trib.num-adic         = decla-import-adic-itens.num-adic
                                AND   decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
                               
                                CASE decla-import-adic-trib.nom-trib:
                                    WHEN "IBSUF":U THEN DO:
                                        CASE decla-import-adic-trib.cod-campo:
                                            WHEN "COD-TRIB":U THEN DO:
                                                ASSIGN i-trib-ibsuf = INT(decla-import-adic-trib.cod-conteudo).
                                                ASSIGN c-trib-ibs-uf = {diinc/i01di628.i 04 i-trib-ibsuf}.
                                            END.
                                            WHEN "ALIQUOTA":U THEN DO:
                                                ASSIGN de-perc-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE":U THEN DO:
                                                ASSIGN de-base-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR":U THEN DO:
                                                ASSIGN de-val-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                                ASSIGN de-perc-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE-REG":U THEN DO:
                                                ASSIGN de-base-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR-REG":U THEN DO:
                                                ASSIGN de-val-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                        END CASE.
                                    END.
                                    WHEN "IBSMUN":U THEN DO:
                                        CASE decla-import-adic-trib.cod-campo:
                                            WHEN "COD-TRIB":U THEN DO:
                                                ASSIGN i-trib-ibsmun  = INT(decla-import-adic-trib.cod-conteudo).
                                                ASSIGN c-trib-ibs-mun = {diinc/i01di628.i 04 i-trib-ibsmun}.
                                            END.
                                            WHEN "ALIQUOTA":U THEN DO:
                                                ASSIGN de-perc-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE":U THEN DO:
                                                ASSIGN de-base-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR":U THEN DO:
                                                ASSIGN de-val-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                                ASSIGN de-perc-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE-REG":U THEN DO:
                                                ASSIGN de-base-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR-REG":U THEN DO:
                                                ASSIGN de-val-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                        END CASE.
                                    END.
                                    WHEN "CBS":U THEN DO:
                                        CASE decla-import-adic-trib.cod-campo:
                                            WHEN "COD-TRIB":U THEN DO:
                                                ASSIGN i-trib-cbs = INT(decla-import-adic-trib.cod-conteudo).
                                                ASSIGN c-trib-cbs = {diinc/i01di628.i 04 i-trib-cbs}.
                                            END.
                                            WHEN "ALIQUOTA":U THEN DO:
                                                ASSIGN de-perc-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE":U THEN DO:
                                                ASSIGN de-base-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR":U THEN DO:
                                                ASSIGN de-val-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                                ASSIGN de-perc-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "BASE-REG":U THEN DO:
                                                ASSIGN de-base-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                            WHEN "VALOR-REG":U THEN DO:
                                                ASSIGN de-val-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                                            END.
                                        END CASE.
                                    END.
                                END CASE.
                            END.
                            
                            ASSIGN d-cne-val-ibs-uf-db-cr  = de-val-ibs-uf
                                   d-cne-val-ibs-mun-db-cr = de-val-ibs-mun
                                   d-cne-val-cbs-db-cr     = de-val-cbs.
                        END.
                         
                         IF  AVAIL decla-import-adic-itens THEN DO:
                              /* calculos dos valores do embarque (f-valEmbarq) */
                             IF  l-first = YES THEN DO:
                                 RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moed-acresc,
                                                      OUTPUT c-ie-acresc-moeda).
                                 RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moed-frete,
                                                      OUTPUT c-ie-frete-moeda).
                                 RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moed-seguro,
                                                      OUTPUT c-ie-seguro-moeda).
                                 RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moeda,
                                                      OUTPUT c-ie-vmle-moeda).
                                 ASSIGN c-ie-vmld-moeda = c-ie-vmle-moeda
                                        c-ie-vmcv-moeda = c-ie-vmle-moeda. 
                                 ASSIGN l-first = NO.
                             END.
                             ASSIGN d-ie-vmle-valor-me        = d-ie-vmle-valor-me   + decla-import-adic-itens.val-vmle
                                    d-ie-vmle-valor-mn        = d-ie-vmle-valor-mn   + decla-import-adic-itens.val-vmle-me[2]
                                    d-ie-vmld-valor-me        = d-ie-vmld-valor-me   + decla-import-adic-itens.val-vmld
                                    d-ie-vmld-valor-mn        = d-ie-vmld-valor-mn   + decla-import-adic-itens.val-vmld-me[2]
                                    d-ie-vmcv-valor-me        = d-ie-vmcv-valor-me   + decla-import-adic-itens.val-vmcv
                                    d-ie-vmcv-valor-mn        = d-ie-vmcv-valor-mn   + decla-import-adic-itens.val-vmcv-me[2]
                                    d-ie-frete-valor-me       = d-ie-frete-valor-me  + decla-import-adic-itens.val-frete
                                    d-ie-frete-valor-mn       = d-ie-frete-valor-mn  + decla-import-adic-itens.val-frete-me[2]
                                    d-ie-seguro-valor-me      = d-ie-seguro-valor-me + decla-import-adic-itens.val-seguro
                                    d-ie-seguro-valor-mn      = d-ie-seguro-valor-mn + decla-import-adic-itens.val-seguro-me[2]
                                    d-ie-acresc-valor-mn      = d-ie-acresc-valor-mn + decla-import-adic-itens.val-acresc
                                    d-ie-acresc-valor-me      = d-ie-acresc-valor-me + decla-import-adic-itens.val-acresc-me[2]
                                    de-tot-ii                 = de-tot-ii            + decla-import-adic-itens.val-ii-db-cr
                                    de-tot-ipi                = de-tot-ipi           + decla-import-adic-itens.val-ipi-db-cr
                                    de-tot-pis                = de-tot-pis           + decla-import-adic-itens.val-pis-db-cr
                                    de-tot-cofins             = de-tot-cofins        + decla-import-adic-itens.val-cofins-db-cr
                                    de-tot-icms               = de-tot-icms          + decla-import-adic-itens.val-icms-db-cr
                                                            
                                    c-tributac-pis            = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-pis}
                                    de-val-base-pis           = decla-import-adic-itens.val-base-pis             
                                    de-val-pis-db-cr          = decla-import-adic-itens.val-pis-db-cr            
                                    c-tributac-icms           = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-icms}
                                    de-val-base-icms          = decla-import-adic-itens.val-base-icms            
                                    de-val-icms-db-cr         = decla-import-adic-itens.val-icms-db-cr           
                                    c-tributac-cofins         = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-cofins}
                                    de-val-base-cofins        = decla-import-adic-itens.val-base-cofins          
                                    de-val-cofins-db-cr       = decla-import-adic-itens.val-cofins-db-cr         
                                    c-tributac-ipi            = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-ipi}
                                    de-val-base-ipi           = decla-import-adic-itens.val-base-ipi             
                                    de-val-ipi-db-cr          = decla-import-adic-itens.val-ipi-db-cr            
                                    c-tributac-ii             = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-impto-import}
                                    de-val-base-ii            = decla-import-adic-itens.val-base-ii              
                                    de-val-ii-db-cr           = decla-import-adic-itens.val-ii-db-cr             
                                    de-val-frete              = decla-import-adic-itens.val-frete                
                                    de-val-seguro             = decla-import-adic-itens.val-seguro               
                                    de-val-acresc             = decla-import-adic-itens.val-acresc
                                                            
                                    d-cne-vmcv-valor-me       = d-cne-vmcv-valor-me    +  decla-import-adic-itens.val-vmcv
                                    d-cne-vmcv-valor-mn       = d-cne-vmcv-valor-mn    +  decla-import-adic-itens.val-vmcv-me[2]  
                                    d-cne-frete-valor-me      = d-cne-frete-valor-me   +  decla-import-adic-itens.val-frete       
                                    d-cne-frete-valor-mn      = d-cne-frete-valor-mn   +  decla-import-adic-itens.val-frete-me[2] 
                                    d-cne-seguro-valor-me     = d-cne-seguro-valor-me  +  decla-import-adic-itens.val-seguro      
                                    d-cne-seguro-valor-mn     = d-cne-seguro-valor-mn  +  decla-import-adic-itens.val-seguro-me[2]
                                    d-cne-acresc-valor-me     = d-cne-acresc-valor-me  +  decla-import-adic-itens.val-acresc      
                                    d-cne-acresc-valor-mn     = d-cne-acresc-valor-mn  +  decla-import-adic-itens.val-acresc-me[2]
                                    d-cne-vmld-valor-me       = d-cne-vmld-valor-me    +  decla-import-adic-itens.val-vmld        
                                    d-cne-vmld-valor-mn       = d-cne-vmld-valor-mn    +  decla-import-adic-itens.val-vmld-me[2]  

                                    d-cne-val-ii-db-cr        = d-cne-val-ii-db-cr     +  decla-import-adic-itens.val-ii-db-cr    
                                    d-cne-val-ipi-db-cr       = d-cne-val-ipi-db-cr    +  decla-import-adic-itens.val-ipi-db-cr   
                                    d-cne-val-pis-db-cr       = d-cne-val-pis-db-cr    +  decla-import-adic-itens.val-pis-db-cr   
                                    d-cne-val-cofins-db-cr    = d-cne-val-cofins-db-cr +  decla-import-adic-itens.val-cofins-db-cr
                                    d-cne-val-icms-db-cr      = d-cne-val-icms-db-cr   +  decla-import-adic-itens.val-icms-db-cr.
                            
                            /* valor ii cotado para moeda estrangeira*/
                            RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                             INPUT  tt-decla-import.cdd-siscomex-dts,
                                             INPUT  decla-import-adic-itens.cdn-moeda,
                                             INPUT  tt-decla-import.dat-di,
                                             INPUT  d-cne-val-ii-db-cr,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao). 
                            ASSIGN d-cne-ii-valor-me =  d-cne-ii-valor-me + d-valor-cotado.
                            
                            /* valor ipi cotado para moeda estrangeira*/
                            RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                             INPUT tt-decla-import.cdd-siscomex-dts,
                                             INPUT decla-import-adic-itens.cdn-moeda,
                                             INPUT tt-decla-import.dat-di,
                                             INPUT d-cne-val-ipi-db-cr,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao). 
                            ASSIGN d-cne-ipi-valor-me =  d-cne-ipi-valor-me + d-valor-cotado.
                
                            /* valor pis cotado para moeda estrangeira*/
                            RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                             INPUT tt-decla-import.cdd-siscomex-dts,
                                             INPUT decla-import-adic-itens.cdn-moeda,
                                             INPUT tt-decla-import.dat-di,
                                             INPUT d-cne-val-pis-db-cr,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao). 
                            ASSIGN d-cne-pis-valor-me = d-cne-pis-valor-me + d-valor-cotado.
                
                            /* valor cofins cotado para moeda estrangeira*/
                            RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                             INPUT tt-decla-import.cdd-siscomex-dts,
                                             INPUT decla-import-adic-itens.cdn-moeda,
                                             INPUT tt-decla-import.dat-di,
                                             INPUT d-cne-val-cofins-db-cr,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao). 
                            ASSIGN d-cne-cofins-valor-me = d-cne-cofins-valor-me + d-valor-cotado.
                
                            /* valor icms cotado para moeda estrangeira*/
                            RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                             INPUT tt-decla-import.cdd-siscomex-dts,
                                             INPUT decla-import-adic-itens.cdn-moeda,
                                             INPUT tt-decla-import.dat-di,
                                             INPUT d-cne-val-icms-db-cr,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao). 
                            ASSIGN d-cne-icms-valor-me = d-cne-icms-valor-me + d-valor-cotado.
                            /* fim - calculo dos percentuais de nacionalizacao e de internacao*/
                            
                            /* totais dos custos de nacionaliza‡Æo e interna‡Æo do embarque */    
                            ASSIGN d-cne-val-tot-imp-me = (d-cne-ii-valor-me     + 
                                                           d-cne-ipi-valor-me    + 
                                                           d-cne-pis-valor-me    + 
                                                           d-cne-cofins-valor-me + 
                                                           d-cne-icms-valor-me)

                                   d-cne-val-tot-imp-mn = (d-cne-val-ii-db-cr     + 
                                                           d-cne-val-ipi-db-cr    + 
                                                           d-cne-val-pis-db-cr    + 
                                                           d-cne-val-cofins-db-cr + 
                                                           d-cne-val-icms-db-cr).

                            ASSIGN c-cne-val-nac-moeda         =  c-moeda-vmld
                                   d-cne-val-nac-valor-me      =  (d-cne-vmld-valor-me  +       
                                                                   d-cne-val-tot-imp-me + 
                                                                   d-cne-desp-n-incid-valor-me) 
                                                                                       
                                   d-cne-val-nac-valor-mn      =  (d-cne-vmld-valor-mn  +
                                                                   d-cne-val-tot-imp-mn +
                                                                   d-cne-desp-n-incid-valor-mn)
                                                         
                                   c-cne-val-int-moeda         = c-moeda-vmld
                                   d-cne-val-int-valor-me      = d-cne-val-nac-valor-me + d-cne-desp-comp-valor-me
                                   d-cne-val-int-valor-mn      = d-cne-val-nac-valor-mn + d-cne-desp-comp-valor-mn.
                            /* fim totais*/
                            
                            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                            IF  l-nt2024002 THEN DO:
                                ASSIGN de-tot-ibs-uf      = de-tot-ibs-uf      + d-cne-val-ibs-uf-db-cr
                                       de-tot-ibs-mun     = de-tot-ibs-mun     + d-cne-val-ibs-mun-db-cr
                                       de-tot-cbs         = de-tot-cbs         + d-cne-val-cbs-db-cr
                                       de-tot-ibs-uf-reg  = de-tot-ibs-uf-reg  + de-val-ibs-uf-reg
                                       de-tot-ibs-mun-reg = de-tot-ibs-mun-reg + de-val-ibs-mun-reg
                                       de-tot-cbs-reg     = de-tot-cbs-reg     + de-val-cbs-reg.
                            
                                RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                                 INPUT  tt-decla-import.cdd-siscomex-dts,
                                                 INPUT  decla-import-adic-itens.cdn-moeda,
                                                 INPUT  tt-decla-import.dat-di,
                                                 INPUT  d-cne-val-ibs-uf-db-cr,
                                                 OUTPUT d-valor-cotado,
                                                 OUTPUT d-cotacao). 
                                ASSIGN d-cne-ibs-uf-valor-me = d-cne-ibs-uf-valor-me + d-valor-cotado.
                                
                                RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                                 INPUT  tt-decla-import.cdd-siscomex-dts,
                                                 INPUT  decla-import-adic-itens.cdn-moeda,
                                                 INPUT  tt-decla-import.dat-di,
                                                 INPUT  d-cne-val-ibs-mun-db-cr,
                                                 OUTPUT d-valor-cotado,
                                                 OUTPUT d-cotacao). 
                                ASSIGN d-cne-ibs-mun-valor-me = d-cne-ibs-mun-valor-me + d-valor-cotado.

                                RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                                 INPUT  tt-decla-import.cdd-siscomex-dts,
                                                 INPUT  decla-import-adic-itens.cdn-moeda,
                                                 INPUT  tt-decla-import.dat-di,
                                                 INPUT  d-cne-val-cbs-db-cr,
                                                 OUTPUT d-valor-cotado,
                                                 OUTPUT d-cotacao). 
                                ASSIGN d-cne-cbs-valor-me = d-cne-cbs-valor-me + d-valor-cotado.
                            END.
                            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

                            /* despesas complementares do embarque */
                            FOR EACH  despes-decla-import NO-LOCK
                                WHERE despes-decla-import.num-di-ems       = decla-import-ord.num-di-ems
                                AND   despes-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                                AND   despes-decla-import.idi-tip-incid-nf = 2,
                                FIRST desp-embarque NO-LOCK
                                WHERE desp-embarque.cod-desp          = despes-decla-import.cdn-despes
                                AND   desp-embarque.cod-emitente-desp = despes-decla-import.cdn-emit-desp:
                             
                                 IF  desp-embarque.mo-codigo = 0 THEN DO:
                                     RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moed-acresc,
                                                          OUTPUT c-cne-desp-comp-moeda).

                                     ASSIGN d-cne-desp-comp-valor-mn  = desp-embarque.val-desp
                                            d-cne-desp-comp-valor-me  = 0
                                            d-cne-desp-comp-perc-inte = (d-cne-desp-comp-valor-mn * 100) / d-cne-val-int-valor-mn.
                                 END.
                                 ELSE DO:
                                     RUN busca-desc-moeda(INPUT  decla-import-adic-itens.cdn-moed-acresc,
                                                         OUTPUT c-cne-desp-comp-moeda).
                                     
                                     ASSIGN d-cne-desp-comp-valor-me = desp-embarque.val-desp.

                                     RUN converteValorMoeda IN h-bocx383a (INPUT tt-decla-import.num-di-ems,
                                                                           INPUT tt-decla-import.cdd-siscomex-dts,
                                                                           INPUT desp-embarque.mo-codigo,
                                                                           INPUT 0,
                                                                           INPUT desp-embarque.val-desp,
                                                                           INPUT tt-decla-import.dat-di,
                                                                           OUTPUT d-cne-desp-comp-valor-mn).

                                     ASSIGN d-cne-desp-comp-perc-inte = (d-cne-desp-comp-valor-mn * 100) / d-cne-val-int-valor-mn.
                                 END.
                             END.

                            /*calculo dos percentuais de nacionalizacao e de internacao*/
                            ASSIGN d-cne-frete-perc-naci           = (d-cne-frete-valor-mn        * 100) / d-cne-val-nac-valor-mn
                                   d-cne-frete-perc-inte           = (d-cne-frete-valor-mn        * 100) / d-cne-val-int-valor-mn
                                   d-cne-seguro-perc-naci          = (d-cne-seguro-valor-mn       * 100) / d-cne-val-nac-valor-mn
                                   d-cne-seguro-perc-inte          = (d-cne-seguro-valor-mn       * 100) / d-cne-val-int-valor-mn
                                   d-cne-vmld-perc-naci            = (d-cne-vmld-valor-mn         * 100) / d-cne-val-nac-valor-mn
                                   d-cne-vmld-perc-inte            = (d-cne-vmld-valor-mn         * 100) / d-cne-val-int-valor-mn
                                   d-cne-vmcv-perc-naci            = (d-cne-vmcv-valor-mn         * 100) / d-cne-val-nac-valor-mn
                                   d-cne-vmcv-perc-inte            = (d-cne-vmcv-valor-mn         * 100) / d-cne-val-int-valor-mn
                                   d-cne-acresc-perc-naci          = (d-cne-acresc-valor-mn       * 100) / d-cne-val-nac-valor-mn
                                   d-cne-acresc-perc-inte          = (d-cne-acresc-valor-mn       * 100) / d-cne-val-int-valor-mn
                                   d-cne-ii-perc-naci              = (d-cne-val-ii-db-cr          * 100) / d-cne-val-nac-valor-mn
                                   d-cne-ii-perc-inte              = (d-cne-val-ii-db-cr          * 100) / d-cne-val-int-valor-mn
                                   d-cne-ipi-perc-naci             = (d-cne-val-ipi-db-cr         * 100) / d-cne-val-nac-valor-mn
                                   d-cne-ipi-perc-inte             = (d-cne-val-ipi-db-cr         * 100) / d-cne-val-int-valor-mn
                                   d-cne-pis-perc-naci             = (d-cne-val-pis-db-cr         * 100) / d-cne-val-nac-valor-mn 
                                   d-cne-pis-perc-inte             = (d-cne-val-pis-db-cr         * 100) / d-cne-val-int-valor-mn 
                                   d-cne-cofins-perc-naci          = (d-cne-val-cofins-db-cr      * 100) / d-cne-val-nac-valor-mn  
                                   d-cne-cofins-perc-inte          = (d-cne-val-cofins-db-cr      * 100) / d-cne-val-int-valor-mn  
                                   d-cne-icms-perc-naci            = (d-cne-val-icms-db-cr        * 100) / d-cne-val-nac-valor-mn  
                                   d-cne-icms-perc-inte            = (d-cne-val-icms-db-cr        * 100) / d-cne-val-int-valor-mn  
                                   d-cne-val-tot-imp-naci          = (d-cne-val-tot-imp-mn        * 100) / d-cne-val-nac-valor-mn
                                   d-cne-val-tot-imp-inte          = (d-cne-val-tot-imp-mn        * 100) / d-cne-val-int-valor-mn
                                   
                                   d-cne-desp-n-incid-perc-naci    = (d-cne-desp-n-incid-valor-mn * 100) / d-cne-val-nac-valor-mn
                                   d-cne-desp-n-incid-perc-inte    = (d-cne-desp-n-incid-valor-mn * 100) / d-cne-val-int-valor-mn
                                   d-cne-val-nac-perc-naci         = (d-cne-val-nac-valor-mn      * 100) / d-cne-val-nac-valor-mn
                                   d-cne-val-nac-perc-inte         = (d-cne-val-nac-valor-mn      * 100) / d-cne-val-int-valor-mn
                                   d-cne-desp-comp-perc-inte       = (d-cne-desp-comp-valor-mn    * 100) / d-cne-val-int-valor-mn
                                   d-cne-val-int-perc-inte         = (d-cne-val-int-valor-mn      * 100) / d-cne-val-int-valor-mn.
                         END.
                         ELSE DO:
                             ASSIGN d-ie-vmle-valor-me            = 0
                                    d-ie-vmle-valor-mn            = 0
                                    d-ie-vmld-valor-me            = 0
                                    d-ie-vmld-valor-mn            = 0
                                    d-ie-vmcv-valor-me            = 0
                                    d-ie-vmcv-valor-mn            = 0
                                    d-ie-frete-valor-me           = 0
                                    d-ie-frete-valor-mn           = 0
                                    d-ie-seguro-valor-me          = 0
                                    d-ie-seguro-valor-mn          = 0
                                    d-ie-acresc-valor-mn          = 0
                                    d-ie-acresc-valor-me          = 0
                                    de-tot-ii                     = 0
                                    de-tot-ipi                    = 0
                                    de-tot-pis                    = 0
                                    de-tot-cofins                 = 0
                                    de-tot-icms                   = 0
                                    c-ie-vmle-moeda               = ""
                                    c-ie-vmld-moeda               = ""
                                    c-ie-vmcv-moeda               = ""
                                    c-ie-acresc-moeda             = ""
                                    c-ie-frete-moeda              = ""
                                    c-ie-seguro-moeda             = ""
                                                                 
                                    c-tributac-pis                = ""
                                    de-val-base-pis               = 0
                                    de-val-pis-db-cr              = 0
                                    c-tributac-icms               = ""
                                    de-val-base-icms              = 0
                                    de-val-icms-db-cr             = 0
                                    c-tributac-cofins             = ""
                                    de-val-base-cofins            = 0
                                    de-val-cofins-db-cr           = 0
                                    c-tributac-ipi                = ""
                                    de-val-base-ipi               = 0
                                    de-val-ipi-db-cr              = 0
                                    c-tributac-ii                 = ""
                                    de-val-base-ii                = 0
                                    de-val-ii-db-cr               = 0
                                    de-val-frete                  = 0
                                    de-val-seguro                 = 0
                                    de-val-acresc                 = 0
                                                                 
                                    d-cne-val-ii-db-cr            = 0
                                    d-cne-val-ipi-db-cr           = 0
                                    d-cne-val-pis-db-cr           = 0
                                    d-cne-val-cofins-db-cr        = 0
                                    d-cne-val-icms-db-cr          = 0
                                    d-cne-ii-valor-me             = 0
                                    d-cne-ipi-valor-me            = 0
                                    d-cne-pis-valor-me            = 0
                                    d-cne-cofins-valor-me         = 0
                                    d-cne-icms-valor-me           = 0
                                    
                                    d-cne-frete-perc-naci         = 0
                                    d-cne-frete-perc-inte         = 0
                                    d-cne-seguro-perc-naci        = 0
                                    d-cne-seguro-perc-inte        = 0
                                    d-cne-vmld-perc-naci          = 0
                                    d-cne-vmld-perc-inte          = 0
                                    d-cne-vmcv-perc-naci          = 0
                                    d-cne-vmcv-perc-inte          = 0
                                    d-cne-acresc-perc-naci        = 0
                                    d-cne-acresc-perc-inte        = 0
                                    d-cne-ii-perc-naci            = 0
                                    d-cne-ii-perc-inte            = 0
                                    d-cne-ipi-perc-naci           = 0
                                    d-cne-ipi-perc-inte           = 0
                                    d-cne-pis-perc-naci           = 0
                                    d-cne-pis-perc-inte           = 0
                                    d-cne-cofins-perc-naci        = 0
                                    d-cne-cofins-perc-inte        = 0
                                    d-cne-icms-perc-naci          = 0
                                    d-cne-icms-perc-inte          = 0
                                    d-cne-val-tot-imp-naci        = 0
                                    d-cne-val-tot-imp-inte        = 0

                                    d-cne-desp-n-incid-perc-naci  = 0
                                    d-cne-desp-n-incid-perc-inte  = 0
                                    d-cne-val-nac-perc-naci       = 0
                                    d-cne-val-nac-perc-inte       = 0
                                    d-cne-desp-comp-perc-inte     = 0
                                    d-cne-val-int-perc-inte       = 0.
                            
                             /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                             IF  l-nt2024002 THEN DO:
                                 ASSIGN de-tot-ibs-uf      = 0
                                        de-tot-ibs-mun     = 0
                                        de-tot-cbs         = 0
                                        de-tot-ibs-uf-reg  = 0
                                        de-tot-ibs-mun-reg = 0
                                        de-tot-cbs-reg     = 0.
                             END.
                             /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                         END.

                         /* busca as moedas */
                         ASSIGN c-cne-vmcv-moeda         =  c-ie-vmcv-moeda
                                c-cne-frete-moeda        =  c-ie-frete-moeda
                                c-cne-seguro-moeda       =  c-ie-seguro-moeda
                                c-cne-acresc-moeda       =  c-ie-acresc-moeda
                                c-cne-vmld-moeda         =  c-ie-vmld-moeda
                                c-cne-ii-moeda           =  c-ie-vmld-moeda
                                c-cne-ipi-moeda          =  c-ie-vmld-moeda
                                c-cne-pis-moeda          =  c-ie-vmld-moeda
                                c-cne-cofins-moeda       =  c-ie-vmld-moeda
                                c-cne-icms-moeda         =  c-ie-vmld-moeda
                                c-cne-desp-n-incid-moeda =  c-ie-vmld-moeda
                                c-cne-val-nac-moeda      =  c-ie-vmld-moeda
                                /*c-cne-desp-comp-moeda    =  c-ie-vmld-moeda*/
                                c-cne-val-int-moeda      =  c-ie-vmld-moeda.
                         
                         /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                         IF  l-nt2024002 THEN DO:
                             ASSIGN c-cne-ibs-uf-moeda  = c-ie-vmld-moeda
                                    c-cne-ibs-mun-moeda = c-ie-vmld-moeda
                                    c-cne-cbs-moeda     = c-ie-vmld-moeda.

                             DISP
                                  tt-ordens-embarque.parcela                      
                                  c-item                                          
                                  c-desc-item                                     
                                  ordem-compra.numero-ordem                    
                                  ordem-compra.ordem-servic                   
                                  ordem-compra.nr-pedcli
                                  decla-import-adic-itens.num-adic @ i-num-adic
                                  
                                  c-classif
                                  c-un
                                  tt-ordens-embarque.quantidade                   
                                  ordem-compra.preco-unit                      
                                  ((DECIMAL(SUBSTRING(decla-import-adic-itens.cod-livre-1,4,20)) / 100000000) * decla-import-adic-itens.qtd-adic[1]) @ de-valor-material
                                  decla-import-adic-itens.val-vmcv-me[2] @ de-preco-total
                                                                                                                                                         
                                  c-tributac-pis                    @ decla-import-adic-itens.idi-tributac-pis                                           
                                  de-perc-reduc-pis                                                                                                      
                                  de-val-base-pis                   @ decla-import-adic-itens.val-base-pis                                               
                                  de-val-pis-db-cr                  @ decla-import-adic-itens.val-pis-db-cr                                              
                                  c-tributac-icms                   @ decla-import-adic-itens.idi-tributac-icms                                             
                                  de-perc-reduc-icms                                                                                                       
                                  de-val-base-icms                  @ decla-import-adic-itens.val-base-icms                                                                                    
                                  de-val-icms-db-cr                 @ decla-import-adic-itens.val-icms-db-cr                                                                                    
                                                                                                                                                              
                                  c-tributac-cofins                 @ decla-import-adic-itens.idi-tributac-cofins                                             
                                  de-perc-reduc-cofins                                                                                                            
                                  de-val-base-cofins                @ decla-import-adic-itens.val-base-cofins                                                                                      
                                  de-val-cofins-db-cr               @ decla-import-adic-itens.val-cofins-db-cr                                                                                     
                                  c-tributac-ipi                    @ decla-import-adic-itens.idi-tributac-ipi                                                  
                                  de-perc-reduc-ipi                                                                                                             
                                  de-val-base-ipi                   @ decla-import-adic-itens.val-base-ipi                                                                         
                                  de-val-ipi-db-cr                  @ decla-import-adic-itens.val-ipi-db-cr        
                                  
                                  c-tributac-ii                     @ decla-import-adic-itens.idi-tributac-impto-import
                                  de-perc-reduc-impto-import
                                  de-val-base-ii                    @ decla-import-adic-itens.val-base-ii  
                                  de-val-ii-db-cr                   @ decla-import-adic-itens.val-ii-db-cr 
                                  
                                  c-trib-ibs-uf
                                  de-perc-ibs-uf
                                  de-base-ibs-uf
                                  de-val-ibs-uf
                                  de-perc-ibs-uf-reg
                                  de-base-ibs-uf-reg
                                  de-val-ibs-uf-reg
                                  
                                  c-trib-ibs-mun
                                  de-perc-ibs-mun
                                  de-base-ibs-mun
                                  de-val-ibs-mun
                                  de-perc-ibs-mun-reg
                                  de-base-ibs-mun-reg
                                  de-val-ibs-mun-reg
                                  
                                  c-trib-cbs
                                  de-perc-cbs
                                  de-base-cbs
                                  de-val-cbs
                                  de-perc-cbs-reg
                                  de-base-cbs-reg
                                  de-val-cbs-reg
                                  
                                  de-val-frete                      @ decla-import-adic-itens.val-frete    
                                  de-val-seguro                     @ decla-import-adic-itens.val-seguro   
                                  de-val-acresc                     @ decla-import-adic-itens.val-acresc   
                                 with frame f-itensEmbarqCbsIbs.
                                 down with frame f-itensEmbarqCbsIbs.
                         END.
                         /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                         ELSE DO:
                             DISP
                                  tt-ordens-embarque.parcela                      
                                  c-item                                          
                                  c-desc-item                                     
                                  ordem-compra.numero-ordem                    
                                  ordem-compra.ordem-servic                   
                                  ordem-compra.nr-pedcli
                                  decla-import-adic-itens.num-adic @ i-num-adic
                                  
                                  c-classif
                                  c-un
                                  tt-ordens-embarque.quantidade                   
                                  ordem-compra.preco-unit                      
                                  ((DECIMAL(SUBSTRING(decla-import-adic-itens.cod-livre-1,4,20)) / 100000000) * decla-import-adic-itens.qtd-adic[1]) @ de-valor-material
                                  decla-import-adic-itens.val-vmcv-me[2] @ de-preco-total
                                                                                                                                                         
                                  c-tributac-pis                    @ decla-import-adic-itens.idi-tributac-pis                                           
                                  de-perc-reduc-pis                                                                                                      
                                  de-val-base-pis                   @ decla-import-adic-itens.val-base-pis                                               
                                  de-val-pis-db-cr                  @ decla-import-adic-itens.val-pis-db-cr                                              
                                  c-tributac-icms                   @ decla-import-adic-itens.idi-tributac-icms                                             
                                  de-perc-reduc-icms                                                                                                       
                                  de-val-base-icms                  @ decla-import-adic-itens.val-base-icms                                                                                    
                                  de-val-icms-db-cr                 @ decla-import-adic-itens.val-icms-db-cr                                                                                    
                                                                                                                                                              
                                  c-tributac-cofins                 @ decla-import-adic-itens.idi-tributac-cofins                                             
                                  de-perc-reduc-cofins                                                                                                            
                                  de-val-base-cofins                @ decla-import-adic-itens.val-base-cofins                                                                                      
                                  de-val-cofins-db-cr               @ decla-import-adic-itens.val-cofins-db-cr                                                                                     
                                  c-tributac-ipi                    @ decla-import-adic-itens.idi-tributac-ipi                                                  
                                  de-perc-reduc-ipi                                                                                                             
                                  de-val-base-ipi                   @ decla-import-adic-itens.val-base-ipi                                                                         
                                  de-val-ipi-db-cr                  @ decla-import-adic-itens.val-ipi-db-cr        
                                  
                                  c-tributac-ii                     @ decla-import-adic-itens.idi-tributac-impto-import
                                  de-perc-reduc-impto-import
                                  de-val-base-ii                    @ decla-import-adic-itens.val-base-ii  
                                  de-val-ii-db-cr                   @ decla-import-adic-itens.val-ii-db-cr 
                                  
                                  de-val-frete                      @ decla-import-adic-itens.val-frete    
                                  de-val-seguro                     @ decla-import-adic-itens.val-seguro   
                                  de-val-acresc                     @ decla-import-adic-itens.val-acresc   
                                 with frame f-itensEmbarq.
                                 down with frame f-itensEmbarq.
                         END.
                     END. /*for each tt-ordens-embarque*/
                 END. /*for each decla-import-ord*/

                VIEW FRAME f-cabecValEmbarq.
                DISP c-ie-vmle-moeda                  
                     d-ie-vmle-valor-me               
                     d-ie-vmle-valor-mn               
                    
                     c-ie-vmld-moeda                 
                     d-ie-vmld-valor-me  
                     d-ie-vmld-valor-mn  
                    
                     c-ie-vmcv-moeda     
                     d-ie-vmcv-valor-me  
                     d-ie-vmcv-valor-mn  
                    
                     c-ie-frete-moeda                 
                     d-ie-frete-valor-me              
                     d-ie-frete-valor-mn              
                    
                     c-ie-seguro-moeda                
                     d-ie-seguro-valor-me             
                     d-ie-seguro-valor-mn             
                    
                     c-ie-acresc-moeda   
                     d-ie-acresc-valor-mn
                     d-ie-acresc-valor-me
                WITH FRAME f-valEmbarq.


                /* total impostos embarque */
                ASSIGN de-total-impostos = de-tot-ii + de-tot-ipi + de-tot-pis + de-tot-cofins + de-tot-icms.
                VIEW FRAME f-cabecImpEmbarq.
                
                /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                IF  l-nt2024002 THEN DO:
                    ASSIGN de-total-impostos = de-total-impostos + (de-tot-ibs-uf + de-tot-ibs-mun + de-tot-cbs + 
                                                                    de-tot-ibs-uf-reg + de-tot-ibs-mun-reg + de-tot-cbs-reg).
                    DISP 
                        de-tot-ii    
                        de-tot-ipi   
                        de-tot-pis   
                        de-tot-cofins
                        de-tot-icms
                        de-tot-ibs-uf
                        de-tot-ibs-mun
                        de-tot-cbs
                        de-tot-ibs-uf-reg
                        de-tot-ibs-mun-reg
                        de-tot-cbs-reg
                        de-total-impostos
                       WITH FRAME f-impEmbarqCbsIbs.
                END.
                /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                ELSE DO:
                    DISP 
                        de-tot-ii    
                        de-tot-ipi   
                        de-tot-pis   
                        de-tot-cofins
                        de-tot-icms  
                        de-total-impostos
                       WITH FRAME f-impEmbarq.
                END.
                
                IF  CAN-FIND(FIRST tt-desp-embarque2
                             WHERE tt-desp-embarque2.cod-estabel = decla-import-embarq.cod-estab  
                             AND   tt-desp-embarque2.embarque    = decla-import-embarq.cod-embarq ) THEN DO:
                
                    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                    IF  l-nt2024002 THEN DO:
                        VIEW FRAME f-cabecDespesEmbarqCbsIbs.
                    END.
                    /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                    ELSE DO:
                        VIEW FRAME f-cabecDespesEmbarq.
                    END.

                    FOR EACH tt-desp-embarque2
                                WHERE tt-desp-embarque2.cod-estabel = decla-import-embarq.cod-estab  
                                AND   tt-desp-embarque2.embarque    = decla-import-embarq.cod-embarq:
                        FIND FIRST desp-imp NO-LOCK WHERE desp-imp.cod-desp = tt-desp-embarque2.cod-desp NO-ERROR.
                        IF AVAIL desp-imp THEN DO:
                            ASSIGN c-desc-desp   = "-" + IF tt-desp-embarque2.descricao <> "":U THEN tt-desp-embarque2.descricao ELSE desp-imp.descricao
                                   l-duplic      = desp-imp.inc-val-dupli
                                   l-ii          = desp-imp.log-2
                                   l-ipi         = desp-imp.inc-base-ipi
                                   l-icms        = desp-imp.inc-base-icms
                                   l-pis-adu     = desp-imp.log-incid-base-pis-val
                                   l-pis-desp    = desp-imp.log-incid-base-pis-despes
                                   l-cofins-adu  = desp-imp.log-incid-base-cofins-val
                                   l-cofins-desp = desp-imp.log-incid-base-cofins-despes.
                                   c-tipo-despes = {cxinc/i01cx010.i 04 desp-imp.tipo}. 
                
                                                                             
                        END.
                        
                        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                        IF  l-nt2024002 THEN DO:
                            DISP tt-desp-embarque2.cod-desp
                                 c-desc-desp
                                 c-desp-moeda
                                 d-taxa-camb
                                 tt-desp-embarque2.log-forma-preco-compra
                                 c-tipo-despes
                                 tt-desp-embarque2.cod-incoterm-rat
                                 
                                 tt-desp-embarque2.cod-emitente-desp
                                 c-desc-emitente
                                 tt-desp-embarque2.cod-cond-pag
                                 c-desc-cond-pagto
                                 l-duplic
                                 l-ii
                                 l-ipi
                                 l-icms
                                 l-pis-adu
                                 l-pis-desp
                                 l-cofins-adu

                                 l-cofins-desp
                                 l-ibs-uf
                                 l-ibs-mun
                                 l-cbs
                                 d-valor-me
                                 d-valor-mn
                                 SKIP(2)
                                WITH FRAME f-despesEmbarqCbsIbs.
                                DOWN WITH FRAME f-despesEmbarqCbsIbs.
                        END.
                        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                        ELSE DO:
                            DISP tt-desp-embarque2.cod-desp
                                 c-desc-desp                                                
                                 c-desp-moeda                                    
                                 d-taxa-camb                                     
                                 tt-desp-embarque2.log-forma-preco-compra            
                                 c-tipo-despes                                            
                                 tt-desp-embarque2.cod-incoterm-rat                  
                                                                                          
                                 tt-desp-embarque2.cod-emitente-desp
                                 c-desc-emitente                                          
                                 tt-desp-embarque2.cod-cond-pag
                                 c-desc-cond-pagto                                        
                                 l-duplic                                                 
                                 l-ii                                                     
                                 l-ipi                                                    
                                 l-icms                                                   
                                 l-pis-adu                                                
                                 l-pis-desp                                               
                                 l-cofins-adu                                             
                                                                                          
                                 l-cofins-desp                                            
                                 d-valor-me                                               
                                 d-valor-mn                                               
                                 SKIP(2)
                                WITH FRAME f-despesEmbarq.
                                DOWN WITH FRAME f-despesEmbarq.
                        END.
                    END.
                END.

                VIEW FRAME f-cabecCustNacEmbarq.
                
                /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                IF  l-nt2024002 THEN DO:
                    DISP 
                        c-cne-vmcv-moeda
                        d-cne-vmcv-valor-me
                        d-cne-vmcv-valor-mn
                        d-cne-vmcv-perc-naci
                        d-cne-vmcv-perc-inte
                       
                        c-cne-frete-moeda
                        d-cne-frete-valor-me
                        d-cne-frete-valor-mn
                        d-cne-frete-perc-naci
                        d-cne-frete-perc-inte
                       
                        c-cne-seguro-moeda
                        d-cne-seguro-valor-me
                        d-cne-seguro-valor-mn
                        d-cne-seguro-perc-naci
                        d-cne-seguro-perc-inte
                       
                        c-cne-acresc-moeda
                        d-cne-acresc-valor-me
                        d-cne-acresc-valor-mn
                        d-cne-acresc-perc-naci
                        d-cne-acresc-perc-inte
                       
                        c-cne-vmld-moeda
                        d-cne-vmld-valor-me
                        d-cne-vmld-valor-mn
                        d-cne-vmld-perc-naci
                        d-cne-vmld-perc-inte
                       
                        c-cne-ii-moeda
                        d-cne-ii-valor-me
                        d-cne-val-ii-db-cr
                        d-cne-ii-perc-naci
                        d-cne-ii-perc-inte
                       
                        c-cne-ipi-moeda
                        d-cne-ipi-valor-me
                        d-cne-val-ipi-db-cr
                        d-cne-ipi-perc-naci
                        d-cne-ipi-perc-inte
                       
                        c-cne-pis-moeda
                        d-cne-pis-valor-me
                        d-cne-val-pis-db-cr
                        d-cne-pis-perc-naci
                        d-cne-pis-perc-inte
                       
                        c-cne-cofins-moeda
                        d-cne-cofins-valor-me
                        d-cne-val-cofins-db-cr
                        d-cne-cofins-perc-naci
                        d-cne-cofins-perc-inte
                       
                        c-cne-icms-moeda
                        d-cne-icms-valor-me
                        d-cne-val-icms-db-cr
                        d-cne-icms-perc-naci
                        d-cne-icms-perc-inte
                        
                        c-cne-ibs-uf-moeda
                        d-cne-ibs-uf-valor-me
                        d-cne-val-ibs-uf-db-cr
                        d-cne-ibs-uf-perc-naci
                        d-cne-ibs-uf-perc-inte
                        c-cne-ibs-mun-moeda
                        d-cne-ibs-mun-valor-me
                        d-cne-val-ibs-mun-db-cr
                        d-cne-ibs-mun-perc-naci
                        d-cne-ibs-mun-perc-inte
                        c-cne-cbs-moeda
                        d-cne-cbs-valor-me
                        d-cne-val-cbs-db-cr
                        d-cne-cbs-perc-naci
                        d-cne-cbs-perc-inte
                       
                        d-cne-val-tot-imp-me
                        d-cne-val-tot-imp-mn
                        d-cne-val-tot-imp-naci
                        d-cne-val-tot-imp-inte
                       
                        c-cne-val-nac-moeda
                        d-cne-val-nac-valor-me
                        d-cne-val-nac-valor-mn
                        d-cne-val-nac-perc-naci
                        d-cne-val-nac-perc-inte
                       
                        c-cne-desp-comp-moeda
                        d-cne-desp-comp-valor-me
                        d-cne-desp-comp-valor-mn
                        d-cne-desp-comp-perc-inte
                       
                        c-cne-val-int-moeda
                        d-cne-val-int-valor-me
                        d-cne-val-int-valor-mn
                        d-cne-val-int-perc-inte
                       WITH FRAME f-custNacEmbarqCbsIbs.
                END.
                /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                ELSE DO:
                    DISP 
                        c-cne-vmcv-moeda
                        d-cne-vmcv-valor-me
                        d-cne-vmcv-valor-mn
                        d-cne-vmcv-perc-naci
                        d-cne-vmcv-perc-inte
                       
                        c-cne-frete-moeda
                        d-cne-frete-valor-me
                        d-cne-frete-valor-mn
                        d-cne-frete-perc-naci
                        d-cne-frete-perc-inte
                       
                        c-cne-seguro-moeda
                        d-cne-seguro-valor-me
                        d-cne-seguro-valor-mn
                        d-cne-seguro-perc-naci
                        d-cne-seguro-perc-inte
                       
                        c-cne-acresc-moeda
                        d-cne-acresc-valor-me
                        d-cne-acresc-valor-mn
                        d-cne-acresc-perc-naci
                        d-cne-acresc-perc-inte
                       
                        c-cne-vmld-moeda
                        d-cne-vmld-valor-me
                        d-cne-vmld-valor-mn
                        d-cne-vmld-perc-naci
                        d-cne-vmld-perc-inte
                       
                        c-cne-ii-moeda
                        d-cne-ii-valor-me
                        d-cne-val-ii-db-cr
                        d-cne-ii-perc-naci
                        d-cne-ii-perc-inte
                       
                        c-cne-ipi-moeda
                        d-cne-ipi-valor-me
                        d-cne-val-ipi-db-cr
                        d-cne-ipi-perc-naci
                        d-cne-ipi-perc-inte
                       
                        c-cne-pis-moeda
                        d-cne-pis-valor-me
                        d-cne-val-pis-db-cr
                        d-cne-pis-perc-naci
                        d-cne-pis-perc-inte
                       
                        c-cne-cofins-moeda
                        d-cne-cofins-valor-me
                        d-cne-val-cofins-db-cr
                        d-cne-cofins-perc-naci
                        d-cne-cofins-perc-inte
                       
                        c-cne-icms-moeda
                        d-cne-icms-valor-me
                        d-cne-val-icms-db-cr
                        d-cne-icms-perc-naci
                        d-cne-icms-perc-inte
                       
                        d-cne-val-tot-imp-me
                        d-cne-val-tot-imp-mn
                        d-cne-val-tot-imp-naci
                        d-cne-val-tot-imp-inte
                       
                        c-cne-val-nac-moeda
                        d-cne-val-nac-valor-me
                        d-cne-val-nac-valor-mn
                        d-cne-val-nac-perc-naci
                        d-cne-val-nac-perc-inte
                       
                        c-cne-desp-comp-moeda
                        d-cne-desp-comp-valor-me
                        d-cne-desp-comp-valor-mn
                        d-cne-desp-comp-perc-inte
                       
                        c-cne-val-int-moeda
                        d-cne-val-int-valor-me
                        d-cne-val-int-valor-mn
                        d-cne-val-int-perc-inte
                       WITH FRAME f-custNacEmbarq.
                END.   
            END.

        END.

    END.


    PAGE. /*quebra p gina no final de cada DI*/


END. /*for each tt-decla-import*/

{imp/im0440.i3} /*imprime os parametros da busca*/


/* elimina as handles utilizadas */
IF VALID-HANDLE(h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

IF VALID-HANDLE(h-boin274) THEN DO:
    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
END.
/* elimina as handles utilizadas */
    
return 'OK'.

 

