/*
**
** IM7777.I - Defini‡äes temp-tables/vari veis IM7777.P 
** 
*/

{imp/im7777.i1}      /* Definicao das temp-tables de entrada */
{include/boerrtab.i} /* Definicao tt-bo-erro */
{imp/im0091.i}       /* Definicao temp-table para rateio de despesas */

def temp-table tt-retorno no-undo like tt-bo-erro.

def temp-table tt-dupli   no-undo
    field dt-vencim    as date
    field tp-despesa   as integer
    field vl-apagar    as decimal
    field vl-apagar-mo as decimal
    /*frank - 09/05/05*/
    &if '{&bf_dis_versao_ems}' >= '2.04' &then
       FIELD mo-codigo    AS INT
    &endif
    /*fim frank 09/05/05*/
    index data
        /*frank - 09/05/05*/
        &if '{&bf_dis_versao_ems}' >= '2.04' &then
           mo-codigo
        &endif
        /*fim frank 09/05/05*/
        dt-vencim.


def temp-table tt-dupli-apagar-cex no-undo
    field cod-emitente      like dupli-apagar-cex.cod-emitente
    field nat-operacao      like dupli-apagar-cex.nat-operacao
    field serie-docto       like dupli-apagar-cex.serie-docto
    field nro-docto         like dupli-apagar-cex.nro-docto
    field cod-emitente-desp like dupli-apagar-cex.cod-emitente-desp
    field cod-desp          like docum-est-cex.cod-desp /* nao existe cod-desp no dupli-apagar-cex no EMS 2.03 */
    field mo-codigo         like dupli-apagar-cex.mo-codigo
    field dt-vencim         like dupli-apagar-cex.dt-vencim
    field tp-despesa        like dupli-apagar-cex.tp-despesa
    field vl-a-pagar        like dupli-apagar-cex.vl-a-pagar
    field vl-a-pagar-mo     like dupli-apagar-cex.vl-a-pagar-mo
    FIELD cod-esp           LIKE dupli-apagar-cex.cod-esp
    index codigo
        serie-docto
        nro-docto
        cod-emitente
        nat-operacao
        cod-desp
        cod-emitente-desp
    index data
        cod-emitente-desp
        dt-vencim.
        
def temp-table tt-docum-est-cex    no-undo like docum-est-cex.

def temp-table tt-item-doc-est-cex no-undo like item-doc-est-cex.    


def new shared temp-table tt-item-doc-est-nova no-undo
    field registro              as   int
    field it-codigo             like item-doc-est.it-codigo 
    field cod-refer             like item-doc-est.cod-refer 
    field numero-ordem          like item-doc-est.numero-ordem 
    field parcela               like item-doc-est.parcela
    field encerra-pa            like item-doc-est.encerra-pa 
    field nr-ord-prod           like item-doc-est.nr-ord-prod 
    field cod-roteiro           like item-doc-est.cod-roteiro 
    field op-codigo             like item-doc-est.op-codigo 
    field item-pai              like item-doc-est.item-pai 
    field ct-codigo             like item-doc-est.ct-codigo
    field sc-codigo             like item-doc-est.sc-codigo 
    field baixa-ce              like item-doc-est.baixa-ce 
    field etiquetas             like item-doc-est.etiquetas 
    field qt-do-forn            like item-doc-est.qt-do-forn 
    field quantidade            like item-doc-est.quantidade
    field preco-total           like item-doc-est.preco-total extent 0
    field desconto              like item-doc-est.desconto extent 0
    FIELD preco-total-me        LIKE item-doc-est.preco-total-me   
    FIELD desconto-me           LIKE item-doc-est.desconto-me 
    field vl-frete-cons         like item-doc-est.pr-total-cmi
    field despesas              like item-doc-est.despesas extent 0
    field peso-liquido          like item-doc-est.peso-liquido 
    field cod-depos             like rat-lote.cod-depos             /* rat lote */
    field cod-localiz           like rat-lote.cod-localiz
    field lote                  like rat-lote.lote
    field dt-vali-lote          like rat-lote.dt-vali-lote

    field class-fiscal          like item-doc-est.class-fiscal 
    field aliquota-ipi          like item-doc-est.aliquota-ipi 
    field cd-trib-ipi           like item-doc-est.cd-trib-ipi 
    field base-ipi              like item-doc-est.base-ipi extent 0
    field valor-ipi             like item-doc-est.valor-ipi extent 0
    field aliquota-iss          like item-doc-est.aliquota-iss 
    field cd-trib-iss           like item-doc-est.cd-trib-iss 
    field base-iss              like item-doc-est.base-iss extent 0
    field valor-iss             like item-doc-est.valor-iss extent 0
    field base-pis              like item-doc-est.base-pis
    field valor-pis             like item-doc-est.valor-pis
    field cd-trib-pis           like item-doc-est.idi-tributac-pis
    field aliquota-pis          like item-doc-est.val-aliq-pis
    field base-cofins           like item-doc-est.val-base-calc-cofins
    field valor-cofins          like item-doc-est.val-cofins
    field cd-trib-cofins        like item-doc-est.idi-tributac-cofins
    field aliquota-cofins       like item-doc-est.val-aliq-cofins
    field aliquota-icm          like item-doc-est.aliquota-icm 
    field cd-trib-icm           like item-doc-est.cd-trib-icm 
    field base-icm              like item-doc-est.base-icm extent 0
    field valor-icm             like item-doc-est.valor-icm extent 0
    field base-subs             like item-doc-est.base-subs extent 0
    field valor-subs            like item-doc-est.vl-subs extent 0
    field icm-complem           like item-doc-est.icm-complem extent 0
    field ind-icm-ret           like item-doc-est.baixa-ce
    field narrativa             like item-doc-est.narrativa
    field serie-comp            like item-doc-est.serie-comp
    field nro-comp              like item-doc-est.nro-comp
    field nat-comp              like item-doc-est.nat-comp
    field seq-comp              like item-doc-est.seq-comp
    field data-comp             like item-doc-est.data-comp
    FIELD int-1                 LIKE item-doc-est.int-1
    field icm-outras            like item-doc-est.icm-outras extent 0
    field ipi-outras            like item-doc-est.ipi-outras extent 0
    field iss-outras            like item-doc-est.iss-outras extent 0
    field icm-ntrib             like item-doc-est.icm-ntrib extent 0
    field ipi-ntrib             like item-doc-est.ipi-ntrib extent 0
    field iss-ntrib             like item-doc-est.iss-ntrib extent 0
    field vl-taxa               like item-doc-est.vl-taxa
    field vl-taxa-me            like item-doc-est.vl-taxa-me   
    field num-pedido            like item-doc-est.num-pedido

    field val-perc-red-ipi      as   dec  format ">>9.9999"
    field val-perc-red-icm      as   dec  format ">>9.9999"

    field nr-proc-imp           as character format "x(12)"         /* Campo Integracao Modulo Importacao */
    field serie-docto           like item-doc-est.serie-docto       /* resgatado pelo item-doc-est */
    field nro-docto             like item-doc-est.nro-docto         /* resgatado pelo item-doc-est */
    field cod-emitente          like item-doc-est.cod-emitente      /* resgatado pelo item-doc-est */
    field nat-operacao          like item-doc-est.nat-operacao      /* resgatado pelo item-doc-est */
    field sequencia             like item-doc-est.sequencia         /* atribuido pelo i-seq */
    field nr-ato-concessorio    as character format "x(20)"         /*este campo esta sendo utilizado para a funcionalidade DRAWBACK*/
    field per-ppm               LIKE rat-lote.per-ppm               /*utilizado para alimentar o campo per-ppm da tabela rat-lote */
    field cod-unid-negoc        like item-doc-est.cod-unid-negoc
    field un                    like item-doc-est.un
    &if '{&bf_lote_avancado_liberado}' = 'yes' &then /*Campos Projeto FDA*/
        field cod-lote-fabrican             like item-doc-est.cod-lote-fabrican
        field dat-fabricc-lote              like item-doc-est.dat-fabricc-lote
        field dat-valid-lote-fabrican       like item-doc-est.dat-valid-lote-fabrican
        field nom-fabrican                  like item-doc-est.nom-fabrican
    &ENDIF
    field preco-unit-me         like item-doc-est.preco-unit-me
    FIELD nat-of                LIKE item-doc-est.nat-of /* Natureza fiscal do item */
    field cod-cfop-saida        like item-doc-est.cod-cfop-saida
    FIELD ind-bem-movel-usado   LIKE item-doc-est.ind-bem-movel-usado
    FIELD log-doacao            LIKE item-doc-est.log-doacao
    index documento is primary unique
          serie-docto
          nro-docto
          cod-emitente
          nat-operacao
          sequencia.


def temp-table tt-docum-est-nova no-undo
    field registro              as   int
    field serie-docto           like docum-est.serie-docto 
    field nro-docto             like docum-est.nro-docto 
    field cod-emitente          like docum-est.cod-emitente 
    field nat-operacao          like docum-est.nat-operacao 
    field cod-observa           like docum-est.cod-observa 
    field cod-estabel           like docum-est.cod-estabel 
    field estab-fisc            like docum-est.estab-fisc
    field ct-transit            like docum-est.ct-transit
    field sc-transit            like docum-est.sc-transit
    field dt-emissao            like docum-est.dt-emissao 
    field dt-trans              like docum-est.dt-trans 
    FIELD cod-rma               LIKE docum-est.cod-rma
    field usuario               like docum-est.usuario 
    field uf                    like docum-est.uf 
    field via-transp            like docum-est.via-transp
    field mod-frete             like docum-est.mod-frete 
    field nff                   like docum-est.nff 
    FIELD mo-codigo             LIKE docum-est.mo-codigo
    field tot-peso              like docum-est.tot-peso 
    field tot-desconto          like docum-est.tot-desconto 
    field valor-frete           like docum-est.valor-frete 
    field valor-seguro          like docum-est.valor-seguro 
    field valor-embal           like docum-est.valor-embal 
    field valor-outras          like docum-est.valor-outras 
    field valor-mercad          like docum-est.valor-mercad 
    field dt-venc-ipi           like docum-est.dt-venc-ipi 
    field dt-venc-icm           like docum-est.dt-venc-icm 
    field tot-valor             like docum-est.tot-valor
    field efetua-calculo        as   int  format "9"
    field observacao            like docum-est.observacao
    field cotacao-dia           like docum-est.cotacao-dia     /* Campo Integracao Modulo Importacao */
    FIELD despesa-nota-me       LIKE docum-est.despesa-nota-me
    FIELD valor-frete-me        LIKE docum-est.valor-frete-me 
    FIELD valor-seguro-me       LIKE docum-est.valor-seguro-me
    FIELD valor-embal-me        LIKE docum-est.valor-embal-me 
    FIELD valor-outras-me       LIKE docum-est.valor-outras-me
    field valor-mercad-me       like docum-est.valor-mercad-me
    field tipo-docto            like docum-est.tipo-docto
    field embarque              as character format "x(12)"    /* Campo Integracao Modulo Importacao */

    field sequencia             as   int  format "999999"
    field esp-docto             like docum-est.esp-docto   
    field rec-fisico            like docum-est.rec-fisico   /* atribui»’o direta = no       */
    field origem                like docum-est.origem       /* atribui»’o direta = "I"      */
    field pais-origem           like docum-est.pais-origem  /* atribui»’o direta = "RE1001" */  
    field gera-unid-neg         as   int format "9"  /* 0-N’o; 1-Gera */
    FIELD nome-transp           AS CHAR FORMAT "x(12)"
    FIELD cod-placa-1           AS CHAR FORMAT "x(07)"
    FIELD cod-placa-2           AS CHAR FORMAT "x(07)"
    FIELD cod-placa-3           AS CHAR FORMAT "x(07)"
    FIELD cod-uf-placa-1        AS CHAR FORMAT "x(02)"
    FIELD cod-uf-placa-2        AS CHAR FORMAT "x(02)"
    FIELD cod-uf-placa-3        AS CHAR FORMAT "x(02)"
    field char-1                like docum-est.char-1
    &if "{&bf_mat_versao_ems}" >= "2.07" &then
     FIELD cod-chave-aces-nf-eletro LIKE docum-est.cod-chave-aces-nf-eletro
     FIELD cdn-sit-nfe              LIKE docum-est.cdn-sit-nfe
    &endif
    field cod-modalid-frete     as char format "x(08)"
    FIELD cod-tipo-ente-gov     LIKE docum-est.cod-tipo-ente-gov
    FIELD cod-tipo-oper-gov     LIKE docum-est.cod-tipo-oper-gov
    index documento is primary 
          serie-docto
	      nro-docto
	      cod-emitente
	      nat-operacao

    index seq is unique
          sequencia.

def input  parameter table for tt-nota.
def input  parameter table for tt-itens.
def output parameter table for tt-erro.
def output parameter table for tt-retorno.

def var c-docto-aux      as character format "x(16)"      no-undo.
                                                                           
def var de-base-ipi      like docum-est.base-ipi          no-undo.
def var de-base-icm      like docum-est.base-icm          no-undo.
def var de-frete         like item-doc-est.pr-total-cmi   no-undo extent 0.
def var de-seguro        like docum-est.valor-seguro      no-undo extent 0.
def var de-embal         like docum-est.valor-embal       no-undo extent 0. 
def var de-outras        like docum-est.valor-outras      no-undo extent 0.
def var de-tot-seguro    like docum-est.valor-seguro      no-undo extent 0.
def var de-tot-embal     like docum-est.valor-embal       no-undo extent 0.
def var de-tot-outras    like docum-est.valor-outras      no-undo extent 0.
DEF VAR de-tot-desp-adu  LIKE docum-est.despesa-nota      NO-UNDO.
DEF VAR de-tot-desp-II   LIKE docum-est.despesa-nota      NO-UNDO.
DEF VAR de-base-II       LIKE docum-est.despesa-nota      NO-UNDO.

/* Arredondamento do valor das despesas para os itens */
def var de-tot-resto       like desp-embarque.val-desp no-undo.
def var de-tot-resto-frete like desp-embarque.val-desp no-undo.
def var de-tot-seguro-aux  like desp-embarque.val-desp no-undo.
def var de-tot-embal-aux   like desp-embarque.val-desp no-undo.
def var de-tot-outras-aux  like desp-embarque.val-desp no-undo.

def var i-parcela      as int     no-undo.
def var i-msg          as int     no-undo.
def var c-msg          as char    no-undo.
def var c-char         as char    no-undo.
def var i-seq          as int     no-undo init 0.
def var i-seq-aux      as int     no-undo init 0.
def var i-ind          as int     no-undo init 0.
def var i-seq-erro     as int     no-undo init 0.
def var i-avanco       as int     no-undo.
def var i-seq-item-doc-est as integer no-undo.
def var i-moeda-material   as integer no-undo.

def var l-acomp        as logical no-undo initial no.
def var h-acomp        as handle  no-undo.
DEF VAR h-reapi190b    AS HANDLE  NO-UNDO.
def var c-acomp        as char    no-undo.

/* Integra‡Æo Unidade de Neg¢cio/EMS 5 */
def var l-conecta-emsbas as logical no-undo.
def var l-conecta-emsuni as logical no-undo.

{cdp/cd4300.i3}  /* Include tratamento atributo livre                     */

{cxbo/bocx250.i50} /* Atributo livre parametros de importacao */

/*
** Magnus - tratamento condi‡Æo pagamento 
*/
&if defined(bf-mat-comex) &then
    def var da-inicio      as date format "99/99/9999" no-undo. 
    def var da-vencto-ant  as date format "99/99/9999" no-undo.   
&endif

/*
** Tratamento Fundap
*/ 
def var l-fornec-fundap as logical no-undo. /* Identifica se ‚ opera‡Æo de FUNDAP */
def var de-bicms-fundap  like tt-it-imposto.vl-icms-it no-undo.
def var de-vlicms-fundap like tt-it-imposto.vl-icms-it no-undo.
def temp-table tt-it-docto-aux   no-undo like tt-it-docto.
def temp-table tt-it-imposto-aux no-undo like tt-it-imposto.

DEF BUFFER b-emit-estab      FOR emitente.
DEF BUFFER b-item            FOR ITEM.
DEF BUFFER b-tt-dupli-apagar FOR tt-dupli-apagar.

&if defined(bf-mat-comex) &then
&else
   DEF VAR l-loc-unica   LIKE ITEM.loc-unica NO-UNDO.
   DEF VAR c-cod-localiz LIKE ITEM.cod-localiz NO-UNDO.
&endif

/*
** Tratametno PIS e COFINS
*/
DEF VAR l-calcula-pis         AS LOGICAL NO-UNDO.
DEF VAR l-calcula-cofins      AS LOGICAL NO-UNDO.
DEF VAR l-calcula-icms-im7777 AS LOGICAL NO-UNDO.

DEFINE VARIABLE c-cod-depos-cq LIKE item-doc-est.cod-depos NO-UNDO.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/*
** Tratamento nota Simples Remessa Mae com Primeira Remessa
*/
def temp-table tt-it-docto-remes-com-mae   no-undo like tt-it-docto.
def temp-table tt-it-imposto-remes-com-mae no-undo like tt-it-imposto.
def temp-table tt-it-docto-bkp             no-undo like tt-it-docto.
def temp-table tt-it-imposto-bkp           no-undo like tt-it-imposto.

def temp-table tt-totais-remes-com-mae no-undo
    field numero-ordem as integer 
    field it-codigo    as character
    field base-ipi     as decimal 
    field valor-ipi    as decimal 
    field ipi-ntib     as decimal 
    field ipi-outras   as decimal
        index ord is primary numero-ordem .

/* IM7777.I */
