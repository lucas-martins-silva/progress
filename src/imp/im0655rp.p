/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0655RP 2.00.00.070 } /*** "010070" 06/06/2024 14:37:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0655rp MIM}
&ENDIF

{include/i_fnctrad.i}
/********************************************************************************
**
**  IM0655RP.P - Relat¢rio Importa‡Æo
**
**  Objetivo: Listagem Posi‡Æo Processo Importa‡Æo (Embarques)
**
*********************************************************************************/

/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio ***************/
{include/i-epc200.i im0655rp}
{imp/im0655.i} /* tt-param */

define buffer b-desp-embarque      for desp-embarque.    
define buffer b-historico-embarque for historico-embarque.    

DEF TEMP-TABLE tt-ordens-embarq NO-UNDO
    FIELD nr-proc-imp        LIKE ordens-embarque.nr-proc-imp
    FIELD i-num-adic           AS INT FORMAT ">>>9"
    FIELD seq-item-ad          AS INT FORMAT ">>>9"
    FIELD numero-ordem       LIKE ordens-embarque.numero-ordem
    FIELD it-codigo          LIKE ordem-compra.it-codigo
    FIELD c-descricao        LIKE item.descricao-1
    FIELD quantidade         LIKE ordens-embarque.quantidade
    FIELD i-val-tax-siscomex   AS DEC FORMAT ">>>>>,>>>,>>9.99999".

def temp-table tt-historico no-undo like historico-embarque 
    field r-rowid        as rowid
    field cod-exportador as integer format ">>>>>>>>9"
    field c-situacao     as char format "x(15)"
    field prev-chegada   as date format "99/99/9999"
    field posicao        as char format "x(30)"
    field i-agente       like processo-imp.cod-agente
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
        field pto-li         like itinerario.cdn-pto-solic-licenciam-import
    &endif
    FIELD c-via-transp  AS CHAR FORMAT "x(16)"
    .

def temp-table tt-historico-tmp no-undo like historico-embarque
    field r-rowid        as rowid
    field cod-exportador as integer format ">>>>>>>>9"
    field c-situacao     as char format "x(15)"
    field prev-chegada   as date format "99/99/9999"
    field i-agente       like processo-imp.cod-agente.
    
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    {cxbo/bocx351.i tt-licenciam-import-oc}
    DEFINE TEMP-TABLE tt-licenc-import NO-UNDO
        FIELD parcela        LIKE prazo-compra.parcela
        FIELD sit-parcela    AS CHARACTER FORMAT "X(14)"
        FIELD licenca-import LIKE licenciam-import-oc.licenca-import.
&ENDIF

DEFINE BUFFER b-tt-ordens-emb      FOR tt-ordens-embarq.
DEFINE BUFFER bf-historico-embarque FOR historico-embarque.

/****************** INCLUDE COM VARIµVEIS GLOBAIS ****************************/
{utp/ut-glob.i}
/****************** FIM INCLUDE COM VARIµVEIS GLOBAIS ************************/

/****************** Defini‡Æo de Parƒmetros do Relat¢rio *********************/ 
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini‡Æo de Vari veis de Sele‡Æo do Relat¢rio ***********/
def var de-valor as decimal no-undo.
def var i-mo-cotacao like cotacao-item.mo-codigo no-undo.
def var de-preco-cotac-sem-ipi like cotacao-item.preco-unit no-undo.



def var  l-tipo              as logical         init yes                no-undo.
def var  l-observacao        as logical         init yes                no-undo.
def var  l-ordens            as logical         init yes                no-undo.
def var  l-desp              as logical         init yes                no-undo.
def var  l-adic-embarq       as logical         INIT YES                no-undo.
def var  l-detalha-desp      as logical                                 no-undo.
def var  da-data-ini         as date            format "99/99/9999"     no-undo.
def var  da-data-fim         as date            format "99/99/9999"     no-undo.
def var i-detalhe-desp       as integer                                 no-undo init 2.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ep-codigo-usuario  LIKE empresa.ep-codigo                                 no-undo.
&ELSE
def var i-ep-codigo-usuario  as integer                                 no-undo.
&ENDIF
def var c-pto-emb            as char            format "x(30)"          no-undo.
def var c-pto-des            as char            format "x(30)"          no-undo.
def var i-pto-desemb         like itinerario.pto-desembarque format ">>,>>9" no-undo.
def var i-diferenca          as integer                                  no-undo.
def var c-nome-abrev         as char                                     no-undo.
def var c-sel                as char            format "x(8)"            no-undo.
def var c-par                as char            format "x(10)"           no-undo.
def var c-imp                as char            format "x(10)"           no-undo.
def var c-destino            as char            format "x(8)"            no-undo.
def var c-atraso             as char            format "x(10)"           no-undo.
def var c-situacao           as char            format "x(20)"           no-undo.
def var c-sit-emb            as char            format "x(15)"           no-undo.
def var c-descricao          as char            format "x(30)"           no-undo.
def var c-agente             as char            format "x(09)"           no-undo. /* tempor rio */
def var c-fatura             as char            format "x(12)"  label "Fatura Comercial" no-undo. /* tempor rio */
def var i-aux                as integer                                  no-undo.
def var i-pto-cheg           as integer                                  no-undo.
def var l-existe-desp        as logical                                  no-undo.
def var c-nom-abrev-exp      as char                                     no-undo.
DEF VAR l-existe-ordens      AS LOGICAL  INITIAL NO                      NO-UNDO.

def var c-lb-processo        as char format "x(08)" no-undo.
def var c-lb-ordem           as char format "x(05)" no-undo.
def var c-lb-item            as char format "x(04)" no-undo.
def var c-lb-desc-item       as char format "x(09)" no-undo.
def var c-lb-parc            as char format "x(04)" no-undo.
def var c-lb-quantidade      as char format "x(11)" no-undo.
def var c-lb-moeda           as char format "x(02)" no-undo.
def var c-lb-preco-unit      as char format "x(14)" no-undo.
def var c-lb-mo-orig         as char format "x(08)" no-undo.
def var c-lb-preco-orig      as char format "x(10)" no-undo.
def var c-lb-identificacao   as char format "x(13)" no-undo.
def var c-lb-peso-liq        as char format "x(14)" no-undo.
def var c-lb-peso-bruto      as char format "x(16)" no-undo.
def var c-lb-cubagem         as char format "x(13)" no-undo.
def var c-lb-peso-cub        as char format "x(16)" no-undo.
def var c-lb-tit-tot         as char format "x(07)" no-undo.
def var c-lb-tipo-desp       as char format "x(14)" no-undo.
def var c-lb-incoterm-rat    as char format "x(20)" no-undo.
def var c-lb-un              as char format "x(03)" no-undo.

DEF VAR c-antecip            AS CHAR FORMAT "x(23)":U NO-UNDO.
DEF VAR c-lb-id              AS CHAR FORMAT "x(02)":U NO-UNDO.
DEF VAR c-lb-est-ap          AS CHAR FORMAT "x(06)":U NO-UNDO.
DEF VAR c-lb-espec-ap        AS CHAR FORMAT "x(08)":U NO-UNDO.
DEF VAR c-lb-serie-ap        AS CHAR FORMAT "x(08)":U NO-UNDO.
DEF VAR c-lb-titulo-ap       AS CHAR FORMAT "x(06)":U NO-UNDO.
DEF VAR c-lb-parc-ap         AS CHAR FORMAT "x(02)":U NO-UNDO.
DEF VAR c-lb-refer-ap        AS CHAR FORMAT "x(10)":U NO-UNDO.
DEF VAR c-lb-fornec-ap       AS CHAR FORMAT "x(10)":U NO-UNDO.
DEF VAR c-lb-nome-abrev-ap   AS CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-lb-moeda-ap        AS CHAR FORMAT "x(05)":U NO-UNDO.
DEF VAR c-lb-data-trans-ap   AS CHAR FORMAT "x(10)":U NO-UNDO.
DEF VAR c-lb-saldo-tit-ap    AS CHAR FORMAT "x(12)":U NO-UNDO.
DEF VAR c-lb-vl-orig-ap      AS CHAR FORMAT "x(17)":U NO-UNDO.
DEF VAR c-lb-cotac-tit-ap    AS CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-lb-vl-vinc-emb     AS CHAR FORMAT "x(19)":U NO-UNDO.
DEF VAR c-lb-dtm-criac       AS CHAR FORMAT "x(18)":U NO-UNDO.
DEF VAR c-lb-usuar-criac     AS CHAR FORMAT "x(15)":U NO-UNDO.
DEF VAR c-lb-serie-docto     AS CHAR FORMAT "x(05)":U NO-UNDO.
DEF VAR c-lb-nro-docto       AS CHAR FORMAT "x(09)":U NO-UNDO.
DEF VAR c-lb-emitente        AS CHAR FORMAT "x(08)":U NO-UNDO.
DEF VAR c-lb-nome-abrev      AS CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-lb-nat-oper        AS CHAR FORMAT "x(09)":U NO-UNDO.
DEF VAR c-lb-vl-cotac        AS CHAR FORMAT "x(07)":U NO-UNDO.
DEF VAR c-lb-dat-cotac       AS CHAR FORMAT "x(12)":U NO-UNDO.
DEF VAR c-lb-vl-ifric22      AS CHAR FORMAT "x(15)":U NO-UNDO.
DEF VAR c-nome-abrev-docto   LIKE emitente.nome-abrev NO-UNDO.
DEF VAR de-valor-ifric22     LIKE antecip-import.val-vinc-embarq NO-UNDO.

DEF VAR c-lb-adic-embarque   AS CHAR FORMAT "x(19)" NO-UNDO.
DEF VAR c-lb-num-adic        AS CHAR FORMAT "x(09)" NO-UNDO.
DEF VAR c-seq-item-ad        AS CHAR FORMAT "x(11)" NO-UNDO.
DEF VAR c-lb-val-tax-siscome AS CHAR FORMAT "x(13)" NO-UNDO.
DEF VAR c-lb-qtde            AS CHAR FORMAT "x(04)" NO-UNDO.
DEF VAR c-lb-tot-val-tax-sis AS CHAR FORMAT "x(19)" NO-UNDO.
DEF VAR c-lb-total           AS CHAR FORMAT "x(06)" NO-UNDO.

/****************** Defini‡Æo de Vari veis Campo do Layout do Relat¢rio **********************/ 
def var c-posicao            as char format "x(13)"  no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-estabel            as char format "x(05)"   no-undo.
&ELSE
def var c-estabel            as char format "x(3)"   no-undo.
&ENDIF
def var c-embarque           as char format "x(9)"   no-undo.
def var c-export             as char format "x(10)"  no-undo.
def var c-itiner             as char format "x(7)"   no-undo.
def var c-desc               as char format "x(10)"  no-undo.
def var c-pto-embarque       as char format "x(07)"  no-undo.
def var c-pto-desemb         as char format "x(09)"  no-undo.
def var c-situac             as char format "x(08)"   no-undo.
def var c-agent              as char format "x(09)"  no-undo.
def var c-prev-chegada       as char format "x(10)"  no-undo.
def var c-nr-fatura          as char format "x(100)" no-undo label "Fatura Comercial".
def var de-valor-desp-conv   as decimal   format ">>,>>>,>>>,>>9.99999" no-undo label "Valor Despesa".
def var tot-de-valor-desp-conv as decimal format ">>,>>>,>>>,>>9.99999" no-undo label "Total Despesas".
def var i                    as integer              no-undo initial 0.
def var c-cod-estabel        as char                 no-undo.
def var c-embarque-aux       as char                 no-undo.
def var l-tot-desp           as logical              no-undo.
DEF VAR c-tipo-desp          AS CHARACTER FORMAT "x(21)" NO-UNDO.
DEF VAR c-via-transp         AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEF VAR l-fn-antecipacao     AS LOGICAL                  NO-UNDO.

def var c-cod-emitente-desp  as char format "x(09)"  no-undo.
def var l-verifica           as logical              no-undo initial no.
def var c-fornecedor         as char format "x(09)"  no-undo.
def var c-nome-abrev-2       as char format "x(12)"  no-undo.
def var c-cod-pto            as char format "x(09)"  no-undo.
def var c-cod-desp           as char format "x(07)"  no-undo.
def var c-descricao-2        as char format "x(10)"  no-undo.
def var c-cod-pag            as char format "x(10)"  no-undo.
def var c-moeda              as char format "x(05)"  no-undo.
def var c-moeda-desc         like moeda.descricao    no-undo.
def var c-descricao-3        as char format "x(05)"  no-undo.
def var c-valor-desp         as char format "x(21)"  no-undo.
def var c-detalhe-desp       as char format "x(20)"  no-undo.
def var de-vl-invoice        like invoice-emb-imp.vl-invoice no-undo.
def var c-incoterm-rat       as char format "x(3)"   no-undo.
DEF VAR c-placa              AS CHAR                 NO-UNDO.
DEF VAR c-data-entrada       AS CHAR                 NO-UNDO.
DEF VAR c-via-transp-ini     AS CHAR FORMAT "x(20)"  NO-UNDO.
DEF VAR c-via-transp-fim     AS CHAR FORMAT "x(20)"  NO-UNDO.

&if "{&bf_dis_versao_ems}":U >= "2.04":U &then
    def var c-recebda            as char format "x(4)"     no-undo initial "Rec?".
    def var c-recebda2           as char format "x(4)"     no-undo.
    def var i-pto-nacionalizacao as int                    no-undo.
&endif

def var c-mo-desp-orig       as char format "x(07)"  no-undo.
def var c-valor-desp-orig    as char format "x(10)"  no-undo.
DEFINE VARIABLE de-peso-liq   AS DECIMAL  FORMAT ">>>>>>,>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-peso-bruto AS DECIMAL  FORMAT ">>>>>>,>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-cubagem    AS DECIMAL  FORMAT ">>>>>>,>>,>>9.999999" NO-UNDO.

DEFINE VARIABLE de-peso-liq-tot   AS DECIMAL  FORMAT ">>>>>>,>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-peso-bruto-tot AS DECIMAL  FORMAT ">>>>>>,>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-cubagem-tot    AS DECIMAL  FORMAT ">>>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE i-tot-val-tax-sis AS DECIMAL  FORMAT ">>>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE i-tot-por-embarq  AS DECIMAL  FORMAT ">>>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE i-qtde-tot-tax    AS INT                                    NO-UNDO.

DEFINE VARIABLE lImprime          AS LOGICAL                                NO-UNDO.

FIND param-global NO-LOCK NO-ERROR.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    

    DEFINE VARIABLE c-li              AS CHARACTER FORMAT "X(32)"                    NO-UNDO.
    DEFINE VARIABLE c-lb-sit-parc     AS CHARACTER FORMAT "X(19)"                    NO-UNDO.
    DEFINE VARIABLE c-lb-nec-li       AS CHARACTER FORMAT "X(12)"                    NO-UNDO.
    DEFINE VARIABLE c-lb-nr-li        AS CHARACTER FORMAT "X(05)"                    NO-UNDO.
    DEFINE VARIABLE c-lb-class-fiscal AS CHARACTER FORMAT "X(21)"                    NO-UNDO.
    DEFINE VARIABLE c-class-fiscal    LIKE ITEM.class-fiscal                         NO-UNDO.
    DEFINE VARIABLE c-pto-solic-li    AS CHARACTER FORMAT "x(30)"                    NO-UNDO.
    DEFINE VARIABLE i-pto-solic-li    LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.


    DEFINE VARIABLE h-bocx351 AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(h-bocx351) THEN
        RUN cxbo/bocx351.p PERSISTENT SET h-bocx351.
&ENDIF

/****************** Verifica Integracao do EMS5 ao modulo de Cambio 
                     para impressao de % Juros e % de IR            *********/
DEF VAR h-boad355 AS HANDLE.
DEF VAR c-pagar   AS CHAR    NO-UNDO.
DEF VAR c-receber AS CHAR    NO-UNDO.
DEF VAR l-integra AS LOGICAL NO-UNDO.
&IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
    FIND param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN
        IF param-global.modulo-mec = YES THEN DO:
            RUN adbo/boad355.p PERSISTENT SET h-boad355.
            RUN pi-verificar-produto IN h-boad355 (OUTPUT c-pagar, OUTPUT c-receber).
            DELETE PROCEDURE h-boad355.
            IF c-pagar = "EMS 5" AND c-receber = "EMS 5"  THEN
                l-integra = YES.
        END.
&ENDIF

ASSIGN l-fn-antecipacao = CAN-FIND(FIRST funcao
                                   WHERE funcao.cd-funcao = "spp-ifric22":U
                                     AND funcao.ativo).

/****************** Defini‡Æo de Forms do Relat¢rio 132 Colunas ***************************************/ 
{imp/im0655.i2}
form 
     skip(5)
     tt-historico.cod-estabel    colon 26
     tt-historico.embarque       space(10)   
     tt-historico.c-situacao     colon 85 skip
     tt-historico.cod-exportador colon 26
     " - " c-nome-abrev          no-label 
     tt-historico.cod-itiner     colon 85
     " - " itinerario.descricao  no-label skip
     &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
         tt-historico.pto-li                       COLON 26 
         "- " c-pto-solic-li     NO-LABEL               
         embarque-imp.cdn-pto-embarq               COLON 26
         "- " c-pto-emb          NO-LABEL 
     /*itinerario.pto-desembarque  colon 85*/
        i-pto-desemb                               COLON 26
         "- " c-pto-des          NO-LABEL  
     &ELSE
         embarque-imp.cdn-pto-embarq               COLON 26
         "- " c-pto-emb          NO-LABEL 
         /*itinerario.pto-desembarque  colon 85*/
         i-pto-desemb                              COLON 85
         " - " c-pto-des         NO-LABEL  
     &ENDIF
     tt-historico.c-via-transp COLON 26
     embarque-imp.declaracao-import colon 26

     &if "{&bf_cex_versao_ems}" >= "2.062" &then
         &if "{&bf_dis_versao_ems}" >= "2.04" &then
             embarque-imp.cod-conhecto-master colon 85 
         &endif
     &else
         &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            embarque-imp.cod-conhecto-master colon 85 
         &ELSE
            embarque-imp.nr-conhecimento colon 85 
         &ENDIF
     &endif
     with side-labels width 132 no-box stream-io frame f-cab-embarque.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-embarque:HANDLE).

DO:
form
     embarque-imp.data-di         colon 26 
     tt-historico.posicao         colon 85 
     embarque-imp.data-1          label "Data Cota‡Æo Nacionaliz" colon 26 
     with side-labels width 132 no-box stream-io frame f-cab-embarque2.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-embarque2:HANDLE).

END. 

form
    embarque-imp.data-di            colon 26 
    &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_dis_versao_ems}" >= "2.04" &then
            embarque-imp.cod-conhecto-house  colon 85
        &endif
    &else
        &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            embarque-imp.cod-conhecto-house  colon 85
        &ENDIF
    &endif
    tt-historico.posicao            colon 85
    embarque-imp.data-1             label "Data Cota‡Æo Nacionaliz" colon 26 
    with side-labels width 132 no-box stream-io frame f-cab-embarque3.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-embarque3:HANDLE).

DO:
form
    embarque-imp.data-di            colon 26 
    &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_dis_versao_ems}" >= "2.04" &then
            embarque-imp.cod-conhecto-house  colon 85
        &endif
    &else
        &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            embarque-imp.cod-conhecto-house  colon 85
        &ENDIF
    &endif
    embarque-imp.data-1             label "Data Cota‡Æo Nacionaliz" colon 26 
    tt-historico.posicao            colon 85
    with side-labels width 132 no-box stream-io frame f-cab-embarque4. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-embarque4:HANDLE).

END.  

DO:
form
      embarque-imp.log-embarq-transf-draw FORMAT "Sim/Nao" COLON 26 LABEL "Embarque Transf. Drawback"
     with side-labels width 132 no-box stream-io frame f-cab-embarque5.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-embarque5:HANDLE).
END.

/************************* Definições de Labels ****************************/
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-param         = trim(return-value).
assign tt-param.usuario:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-param         = trim(return-value).
assign c-destino:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
assign c-sel = return-value.
{utp/ut-liter.i PAR¶METROS * r}
assign c-par = return-value.
{utp/ut-liter.i IMPRESSÇO * r}  
assign c-imp = return-value.
{utp/ut-liter.i Data_Chegada * r}
assign tt-param.da-data-ini:label in frame f-param         = trim(return-value).
assign tt-param.da-data-ini:label in frame f-param-antecip = trim(return-value).
{utp/ut-field.i mgcex historico-proc-imp cod-estabel 1}
{utp/ut-liter.i Processos * r}
assign c-atraso:label in frame f-param         = trim(return-value).
assign c-atraso:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Situa‡Æo_Processo * r}
assign c-situacao:label in frame f-param          = trim(return-value).
assign c-situacao:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Situa‡Æo_Embarque * r}
assign c-sit-emb:label  in frame f-param         = trim(return-value).
assign c-sit-emb:label  in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Fornecedor * r}
assign tt-historico.cod-exportador:label in frame f-cab-embarque = trim(return-value).
{utp/ut-liter.i Situa‡Æo_Embarque * r}
assign tt-historico.c-situacao:label  in frame f-cab-embarque = trim(return-value).
{utp/ut-liter.i Diferen‡a * r}
assign i-diferenca:label in frame f-det-embarque = trim(return-value).
{utp/ut-liter.i Localiza‡Æo * R}
assign tt-param.i-local:label in frame f-param         = trim(return-value).
assign tt-param.i-local:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Descri‡Æo * r}
assign c-descricao:label in frame f-det-embarque = trim(return-value).
{utp/ut-field.i mgcex processo-exp cod-estabel 2}
assign c-estabel = return-value.
{utp/ut-field.i mgcex historico-embarque embarque 1}
assign c-embarque = return-value.
{utp/ut-liter.i Fornecedor * R}
assign c-export = return-value.
{utp/ut-liter.i Itiner * R}
assign c-itiner = return-value.
{utp/ut-liter.i Descri‡Æo * R}
assign c-desc = return-value.
{utp/ut-liter.i Pto_Emb * R} /*{utp/ut-liter.i Pto_Embarq * R}*/
assign c-pto-embarque = return-value.
{utp/ut-liter.i Pto_Naciona * R} /*{utp/ut-liter.i Pto_Desemb * R}*/
assign c-pto-desemb = return-value.
{utp/ut-liter.i Situa‡Æo * R}
assign c-situac = return-value.
{utp/ut-liter.i Ag_Carga * R} /*{utp/ut-liter.i Agente_Carga * R}*/
assign c-agent = return-value.
{utp/ut-liter.i Prev_Cheg * R} /*{utp/ut-liter.i Prev_Chegada * R}*/
assign c-prev-chegada = return-value.
{utp/ut-liter.i Nome * R}
assign c-nom-abrev-exp = return-value.
{utp/ut-liter.i Via_Transporte * R}
assign c-via-transp = return-value.
{utp/ut-liter.i Via_Transporte * R}
assign tt-historico.c-via-transp:label in frame f-cab-embarque = trim(return-value).

{utp/ut-liter.i Observa‡Æo * R}
assign tt-param.l-observacao:label in frame f-param         = trim(return-value).
assign tt-param.l-observacao:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Detalhes_Itiner rio * R}
assign tt-param.l-tipo:label in frame f-param         = trim(return-value).
assign tt-param.l-tipo:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Ordens_Embarque * R}
assign tt-param.l-ordens:label in frame f-param         = trim(return-value).
assign tt-param.l-ordens:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Despesas_Adicionais * R}
assign tt-param.l-desp:label in frame f-param         = trim(return-value).
assign tt-param.l-desp:label in frame f-param-antecip = trim(return-value).
{utp/ut-liter.i Adicoes_do_Embarque * R}
assign tt-param.l-adic-embarq:label in frame f-param         = trim(return-value).
assign tt-param.l-adic-embarq:label in frame f-param-antecip = trim(return-value).

IF l-fn-antecipacao THEN DO:
    {utp/ut-liter.i ANTECIPA€åES_VINCULADAS * R}
    ASSIGN c-antecip = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Antecipa‡äes * R}
    ASSIGN tt-param.lantecipacao:LABEL IN FRAME f-param-antecip = TRIM(RETURN-VALUE).
    {utp/ut-liter.i ID *}
    ASSIGN c-lb-id            = TRIM(RETURN-VALUE).
    {utp/ut-liter.i EstT¡t *}
    ASSIGN c-lb-est-ap        = TRIM(RETURN-VALUE).
    {utp/ut-liter.i EspecTit  *}
    ASSIGN c-lb-espec-ap      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i S‚rieT¡t *}
    ASSIGN c-lb-serie-ap      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i T¡tulo * }
    ASSIGN c-lb-titulo-ap    = TRIM(RETURN-VALUE).
    {utp/ut-liter.i /P *}
    ASSIGN c-lb-parc-ap       = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Referˆncia *}
    ASSIGN c-lb-refer-ap      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Fornecedor *}
    ASSIGN c-lb-fornec-ap     = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Nome_Abreviado *}
    ASSIGN c-lb-nome-abrev-ap = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Moeda *}
    ASSIGN c-lb-moeda-ap      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Data_Trans *}
    ASSIGN c-lb-data-trans-ap = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Saldo_T¡tulo *}
    ASSIGN c-lb-saldo-tit-ap  = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Valor_Orig_T¡tulo *}
    ASSIGN c-lb-vl-orig-ap    = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Cota‡Æo_T¡tulo *}
    ASSIGN c-lb-cotac-tit-ap  = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Valor_Vinc_Embarque *}
    ASSIGN c-lb-vl-vinc-emb   = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Data/Hora_Cria‡Æo *}
    ASSIGN c-lb-dtm-criac     = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Usu rio_Cria‡Æo *}
    ASSIGN c-lb-usuar-criac   = TRIM(RETURN-VALUE).
    {utp/ut-liter.i S‚rie *}
    ASSIGN c-lb-serie-docto   = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Nro_Docto *}
    ASSIGN c-lb-nro-docto     = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Emitente *}
    ASSIGN c-lb-emitente      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Nome_Abreviado *}
    ASSIGN c-lb-nome-abrev    = TRIM(RETURN-VALUE).
    {utp/ut-liter.i NaturOper *}
    ASSIGN c-lb-nat-oper      = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Cota‡Æo *}
    ASSIGN c-lb-vl-cotac      = TRIM(RETURN-VALUE).     
    {utp/ut-liter.i Data_Cota‡Æo *}
    ASSIGN c-lb-dat-cotac     = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Valor_IFRIC-22 *}
    ASSIGN c-lb-vl-ifric22    = TRIM(RETURN-VALUE).
END.

{utp/ut-liter.i Total: * R}
assign c-lb-total = trim(return-value).

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    {utp/ut-liter.i LICENCIAMENTO_DE_IMPORTA€ÇO * R}
    ASSIGN c-li = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Situa‡Æo_da_Parcela * R}
    ASSIGN c-lb-sit-parc = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Necessita_LI * R}
    ASSIGN c-lb-nec-li = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Nr_LI * R}
    ASSIGN c-lb-nr-li = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Classifica‡Æo_Fiscal * R}
    ASSIGN c-lb-class-fiscal = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ponto_Solicita_LI * R}
    ASSIGN tt-param.iPtoSolicLiIni:LABEL IN FRAME f-param-sel = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ponto_Embarque * R}
    ASSIGN tt-param.i-pto-emb-ini:LABEL IN FRAME f-param-sel = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ponto_Nacionaliza‡Æo * R}
    ASSIGN tt-param.i-pto-des-ini:LABEL IN FRAME f-param-sel = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Via_Transporte * R}
    ASSIGN c-via-transp-ini:LABEL IN FRAME f-param-sel = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Licenciamento_Importa‡Æo * R}
    ASSIGN tt-param.cLicencImportIni:LABEL IN FRAME f-param-sel = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Detalha_Licenciamentos_de_Importa‡Æo * R}
    ASSIGN tt-param.lDetalhaLi:LABEL IN FRAME f-param         = TRIM(RETURN-VALUE).
    ASSIGN tt-param.lDetalhaLi:LABEL IN FRAME f-param-antecip = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Ve¡culo * R}
    ASSIGN c-placa = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Data_Entrada * R}
    ASSIGN c-data-entrada = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Peso_e_Cubagem * R}
    ASSIGN tt-param.l-peso-cub:LABEL IN FRAME f-param         = TRIM(RETURN-VALUE).
    ASSIGN tt-param.l-peso-cub:LABEL IN FRAME f-param-antecip = TRIM(RETURN-VALUE).
&ELSE
    {utp/ut-liter.i Pto_Nacionaliza‡Æo * R}
    assign tt-param.i-pto-des-ini:label in frame f-param-sel = trim(return-value).
&ENDIF

{utp/ut-liter.i Ponto_Nacionaliza‡Æo * R}
assign i-pto-desemb:label in frame f-cab-embarque = trim(return-value).

{utp/ut-liter.i Mo_Desp * r}
assign c-mo-desp-orig = trim(return-value).

{utp/ut-liter.i Valor_Orig * r}
assign c-valor-desp-orig = trim(return-value).

&IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
    IF l-integra = YES THEN DO: 
        {utp/ut-liter.i Posi‡Æo_Atual * R}
        assign c-posicao = return-value
        tt-historico.posicao:label in frame f-cab-embarque3 = trim(return-value).
    END.
    ELSE DO:
        {utp/ut-liter.i Posi‡Æo_Atual * R}
        assign c-posicao = return-value
        tt-historico.posicao:label in frame f-cab-embarque4 = trim(return-value).
    END.
&ELSE
    {utp/ut-liter.i Posi‡Æo_Atual * R}
    assign c-posicao = return-value
    tt-historico.posicao:label in frame f-cab-embarque2 = trim(return-value).
&ENDIF

{utp/ut-liter.i Proc_Imp * r}
assign c-lb-processo = trim(return-value).
{utp/ut-liter.i Ordem * r}
assign c-lb-ordem = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-lb-item = trim(return-value).
{utp/ut-liter.i Descri‡Æo * r}
assign c-lb-desc-item = trim(return-value).
{utp/ut-liter.i Parc * r}
assign c-lb-parc = trim(return-value).

{utp/ut-liter.i Un * r}
assign c-lb-un = trim(return-value).

{utp/ut-liter.i Mo * r}
assign c-lb-moeda = trim(return-value).
{utp/ut-liter.i Pre‡o_Unit rio * r}
assign c-lb-preco-unit = trim(return-value).
{utp/ut-liter.i Identifica‡Æo * r}
assign c-lb-identificacao = trim(return-value).
{utp/ut-liter.i Mo_Cotac * r}
assign c-lb-mo-orig = trim(return-value).
{utp/ut-liter.i Pre‡o_Orig * r}
assign c-lb-preco-orig = trim(return-value).
{utp/ut-liter.i Peso_L¡q_Total * r}
assign c-lb-peso-liq = trim(return-value).
{utp/ut-liter.i Peso_Bruto_Total * r}
assign c-lb-peso-bruto = trim(return-value).
{utp/ut-liter.i Cubagem_Total * r}
assign c-lb-cubagem = trim(return-value).
{utp/ut-liter.i PESOS_E_CUBAGENS * r}
assign c-lb-peso-cub = trim(return-value).
{utp/ut-liter.i TOTAIS: * r}
assign c-lb-tit-tot = trim(return-value). 
{utp/ut-liter.i Tipo_Despesa:_ * r}
assign c-lb-tipo-desp = trim(return-value).
{utp/ut-liter.i Incoterm_de_Rateio:_ * r}
assign c-lb-incoterm-rat = trim(return-value).

{utp/ut-liter.i Nr_Adicao * r}
assign c-lb-num-adic = trim(return-value).
{utp/ut-liter.i Seq_Item_Ad * r}
assign c-seq-item-ad = trim(return-value).
{utp/ut-liter.i Taxa_Siscomex * r}
assign c-lb-val-tax-siscome = trim(return-value).
{utp/ut-liter.i Qtde * r}
assign c-lb-qtde = trim(return-value).
{utp/ut-liter.i Taxa_Siscomex_Ordem * r}
assign c-lb-tot-val-tax-sis = trim(return-value).
{utp/ut-liter.i Adicoes_do_Embarque * r}
assign c-lb-adic-embarque = trim(return-value).

create tt-param.
raw-transfer raw-param to tt-param.
find first tt-param no-error.

if tt-param.i-opcao = 1 then do: /*Internos*/
        {utp/ut-liter.i Nossa_Qtde * r}
        assign c-lb-quantidade = " " + trim(return-value).
        {utp/ut-liter.i Imprime_Unidade_de_Medida_e_Quantidade:_Internos * R}
        assign c-unqtd = return-value.
end.
else do:                         /*Fornecedor*/
        {utp/ut-liter.i Qtde_Fornec * r}
        assign c-lb-quantidade = trim(return-value).
        {utp/ut-liter.i Imprime_Unidade_de_Medida_e_Quantidade:_Fornecedor * R}
        assign c-unqtd = return-value.
end. 

{include/i-rpvar.i}

assign c-programa     = "im0655"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Listagem Posi‡äes Embarques"
       c-sistema      = "Com‚rcio Exterior".

{include/i-rpcab.i}

{cdp/cd-rpout.i}   /* include customizada Comex */

{include/tt-edit.i}

{include/pi-edit.i}

view frame f-cabec.
view frame f-rodape.

assign i-ep-codigo-usuario = tt-param.ep-codigo
       v_cdn_empres_usuar  = i-ep-codigo-usuario.

if tt-param.i-situacao <> 5 THEN DO:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao001 = {cxinc/i01cx140.i 04 tt-param.i-situacao}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-situacao = RETURN-VALUE.
     &else
         ASSIGN c-situacao = {cxinc/i01cx140.i 04 tt-param.i-situacao}.
     &endif
END.
else do:
     {utp/ut-liter.i Todos * r}
     assign c-situacao = trim(return-value).
end.
if  tt-param.i-sit-emb <> 3 then do:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {cxinc/i01cx220.i 04 tt-param.i-sit-emb}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-sit-emb = RETURN-VALUE.
    &else
        ASSIGN c-sit-emb = {cxinc/i01cx220.i 04 tt-param.i-sit-emb}.
    &endif
end.
else do:
    {utp/ut-liter.i Todos * r}
    assign c-sit-emb = trim(return-value).
end.           
if  tt-param.i-atraso = 1 then do:
    {utp/ut-liter.i Atrasados}
    assign c-atraso = trim(return-value).
end.    
else if tt-param.i-atraso = 2 then do:    
        {utp/ut-liter.i Adiantados}
        assign c-atraso = trim(return-value).
     end.
     else do:
          {utp/ut-liter.i Todos}
          assign c-atraso = trim(return-value).
     end.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".        

/*******************************************************************************************************/

def var p-atraso       as integer no-undo init 1.
def var p-situacao     as integer no-undo init 5. 
def var p-sit-emb      as integer no-undo init 5.
def var p-data-ini     as date    no-undo.
def var p-data-fim     as date    no-undo.
def var p-est-ini      as char    no-undo init "".
def var p-est-fim      as char    no-undo init "zzz".
def var p-proc-ini     as char    no-undo init "".
def var p-proc-fim     as char    no-undo init "zzzzzzzzzzzz".
def var p-exp-ini      as integer no-undo init 0.
def var p-exp-fim      as integer no-undo init 999999999.
def var p-itiner-ini   as integer no-undo init 0.
def var p-itiner-fim   as integer no-undo init 99999.
def var p-pto-emb-ini  as integer no-undo init 0.
def var p-pto-emb-fim  as integer no-undo init 99999.
def var p-pto-des-ini  as integer no-undo init 0.
def var p-pto-des-fim  as integer no-undo init 99999.
def var p-local        as integer no-undo init 0.
def var p-grupo-ini    as integer no-undo init 0.
def var p-grupo-fim    as integer no-undo init 99.
def var p-fam-ini      as char    no-undo init "".
def var p-fam-fim      as char no-undo init "zzzzzzzz".
def var p-item-ini     as char no-undo init "".
def var p-item-fim     as char no-undo init "zzzzzzzzzzzzzzzz".
def var p-decl-ini     as char no-undo init "".
def var p-decl-fim     as char no-undo init "zzzzzzzzzzzzzzzzzzzz".
def var p-conhec-ini   as char no-undo init "".
def var p-conhec-fim   as char no-undo init "zzzzzzzzzzzzzzz".
def var p-fatura-ini   like invoice-emb-imp.nr-invoice no-undo.
def var p-fatura-fim   like invoice-emb-imp.nr-invoice initial "zzzzzzzzzzzz" no-undo.
def var p-embarque-ini like embarque-imp.embarque no-undo.
def var p-embarque-fim like embarque-imp.embarque initial "zzzzzzzzzzzzzzzz" no-undo.    
def var i-cod-emitente like ordem-compra.cod-emitente no-undo.
def var i-cod-emitente-desp like desp-embarque.cod-emitente-desp no-undo.
DEF VAR i-via-transp-ini AS INT NO-UNDO.
DEF VAR i-via-transp-fim AS INT NO-UNDO.
DEF VAR l-antecipacao    AS LOGICAL NO-UNDO.

&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        DEF VAR p-nr-conhecto-master-ini AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-master-fim AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-house-ini  AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-house-fim  AS CHAR NO-UNDO.
    &endif
&else    
    &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
        DEF VAR p-nr-conhecto-master-ini AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-master-fim AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-house-ini  AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecto-house-fim  AS CHAR NO-UNDO.
    &ELSE
        DEF VAR p-nr-conhecimento-ini AS CHAR NO-UNDO.
        DEF VAR p-nr-conhecimento-fim AS CHAR NO-UNDO.
    &ENDIF
&endif    
DEF VAR p-declar-import-ini   AS CHAR NO-UNDO.
DEF VAR p-declar-import-fim   AS CHAR NO-UNDO.
DEF VAR p-veiculo-transp-ini  AS CHAR NO-UNDO.
DEF VAR p-veiculo-transp-fim  AS CHAR NO-UNDO.
DEF VAR l-sem-faixa           AS LOGICAL NO-UNDO.
DEF VAR l-peso-cubagem        AS LOGICAL NO-UNDO.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    DEFINE VARIABLE l-procura-por-placa  AS LOGICAL                                  NO-UNDO.
    DEFINE VARIABLE pPtoSolicLiIni   LIKE itinerario.cdn-pto-solic-licenciam-import  NO-UNDO.
    DEFINE VARIABLE pPtoSolicLiFim   LIKE itinerario.cdn-pto-solic-licenciam-import  NO-UNDO.
    DEFINE VARIABLE pLicencImportIni LIKE licenciam-import-oc.licenca-import         NO-UNDO.
    DEFINE VARIABLE pLicencImportFim LIKE licenciam-import-oc.licenca-import         NO-UNDO.
&ENDIF

if tt-param.detalhe-desp = 1 then do:
    {utp/ut-liter.i Despesas_Pagas * R}
    assign c-detalhe-desp = return-value.
end.    
else do:
    {utp/ut-liter.i Todas * R}
    assign c-detalhe-desp = return-value.
end.

assign l-tipo          = tt-param.l-tipo
       l-observacao    = tt-param.l-observacao
       l-ordens        = tt-param.l-ordens
       l-desp          = tt-param.l-desp
       l-detalha-desp  = tt-param.l-detalha-desp
       l-adic-embarq   = tt-param.l-adic-embarq
       &if "{&bf_cex_versao_ems}" >= "2.062" &then
            l-peso-cubagem  = tt-param.l-peso-cub
       &else
           &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN
               l-peso-cubagem  = tt-param.l-peso-cub
           &ENDIF
       &endif
       i-detalhe-desp  = tt-param.detalhe-desp
       p-atraso        = tt-param.i-atraso
       p-situacao      = tt-param.i-situacao
       p-sit-emb       = tt-param.i-sit-emb
       p-data-ini      = tt-param.da-data-ini
       p-data-fim      = tt-param.da-data-fim
       p-est-ini       = tt-param.c-est-ini
       p-est-fim       = tt-param.c-est-fim
       p-proc-ini      = tt-param.c-proc-ini
       p-proc-fim      = tt-param.c-proc-fim
       p-exp-ini       = tt-param.i-exp-ini
       p-exp-fim       = tt-param.i-exp-fim
       p-itiner-ini    = tt-param.i-itiner-ini
       p-itiner-fim    = tt-param.i-itiner-fim
       p-pto-emb-ini   = tt-param.i-pto-emb-ini
       p-pto-emb-fim   = tt-param.i-pto-emb-fim
       p-pto-des-ini   = tt-param.i-pto-des-ini
       p-pto-des-fim   = tt-param.i-pto-des-fim
       p-local         = tt-param.i-local
       p-grupo-ini     = tt-param.i-grupo-ini
       p-grupo-fim     = tt-param.i-grupo-fim
       p-fam-ini       = tt-param.c-fam-ini
       p-fam-fim       = tt-param.c-fam-fim
       p-item-ini      = tt-param.c-item-ini
       p-item-fim      = tt-param.c-item-fim
       &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
           pPtoSolicLiIni   = tt-param.iPtoSolicLiIni 
           pPtoSolicLiFim   = tt-param.iPtoSolicLiFim 
           pLicencImportIni = tt-param.cLicencImportIni
           pLicencImportFim = tt-param.cLicencImportFim
       &ENDIF
       i-via-transp-ini = tt-param.via-transp-ini
       i-via-transp-fim = tt-param.via-transp-fim.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao003 = {varinc/var00002.i 04 tt-param.destino}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino       = RETURN-VALUE.
&else
    ASSIGN c-destino       = {varinc/var00002.i 04 tt-param.destino}.
&endif
ASSIGN p-fatura-ini    = tt-param.c-fatura-ini
       p-fatura-fim    = tt-param.c-fatura-fim
       p-embarque-ini  = tt-param.c-embarque-ini
       p-embarque-fim  = tt-param.c-embarque-fim
       &if "{&bf_cex_versao_ems}" >= "2.062" &then
           &if "{&bf_dis_versao_ems}" >= "2.04" &then
                p-nr-conhecto-master-ini = tt-param.nr-conhecto-master-ini
                p-nr-conhecto-master-fim = tt-param.nr-conhecto-master-fim 
                p-nr-conhecto-house-ini  = tt-param.nr-conhecto-house-ini
                p-nr-conhecto-house-fim  = tt-param.nr-conhecto-house-fim  
           &endif
       &else
           &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
               p-nr-conhecto-master-ini = tt-param.nr-conhecto-master-ini
               p-nr-conhecto-master-fim = tt-param.nr-conhecto-master-fim 
               p-nr-conhecto-house-ini  = tt-param.nr-conhecto-house-ini
               p-nr-conhecto-house-fim  = tt-param.nr-conhecto-house-fim  
           &ELSE
               p-nr-conhecimento-ini = tt-param.nr-conhecimento-ini
               p-nr-conhecimento-fim = tt-param.nr-conhecimento-fim
           &ENDIF 
       &endif
       p-declar-import-ini   = tt-param.declar-import-ini
       p-declar-import-fim   = tt-param.declar-import-fim
       p-veiculo-transp-ini  = tt-param.veiculo-transp-ini
       p-veiculo-transp-fim  = tt-param.veiculo-transp-fim.

IF l-fn-antecipacao THEN
    ASSIGN l-antecipacao   = tt-param.lantecipacao.

/* Rotina de Filtro do Embarque, carrega tabela tt-historico */    
def var i-cod-itiner  like itinerario.cod-itiner   no-undo.       
def var i-pto-chegada like pto-contr.cod-pto-contr no-undo.
def var l-ok          as logical                   no-undo.
DEF VAR l-ok-adic     AS LOGICAL                   NO-UNDO.

ASSIGN l-sem-faixa = NO.
IF  p-est-ini              = ""                     AND
    p-est-fim              = "ZZZ"                  and
    p-proc-ini             = ""                     and
    p-proc-fim             = "ZZZZZZZZZZZZ"         and
    p-exp-ini              = 0                      and
    p-exp-fim              = 999999999              and
    p-itiner-ini           = 0                      and
    p-itiner-fim           = 99999                  and
    p-pto-emb-ini          = 0                      and
    p-pto-emb-fim          = 99999                  and
    p-pto-des-ini          = 0                      and
    p-pto-des-fim          = 99999                  and
    p-grupo-ini            = 0                      and
    p-grupo-fim            = 99                     and
    p-fam-ini              = ""                     and  
    p-fam-fim              = "ZZZZZZZZ"             and 
    p-item-ini             = ""                     and
    p-item-fim             = "ZZZZZZZZZZZZZZZZ"     and
    p-fatura-ini           = ""                     and
    p-fatura-fim           = "ZZZZZZZZZZZZ"         and
    p-embarque-ini         = ""                     and   
    p-embarque-fim         = "ZZZZZZZZZZZZ"         and
    p-declar-import-ini    = ""                     and
    p-declar-import-fim    = "ZZZZZZZZZZZZZZZZZZZZ" and
    p-veiculo-transp-ini   = ""                     AND
    p-veiculo-transp-fim   = "ZZZZZZZZZZZZZZZZZZZZ" AND
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        pPtoSolicLiIni     = 0                      AND  
        pPtoSolicLiFim     = 99999                  AND
        pLicencImportIni   = ""                     AND
        pLicencImportFim   = "ZZZZZZZZZZZZZZZZZZZZ" AND
    &ENDIF                                             
    &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_dis_versao_ems}" >= "2.04" &then
            p-nr-conhecto-master-ini = "" and
            p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZ" AND 
            p-nr-conhecto-house-ini = "" and
            p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZZZZ" 
        &endif
    &else
        &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            &IF DEFINED(BF-MAT-COMEX) &THEN
                p-nr-conhecto-master-ini = "" and
                p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZ" AND
                p-nr-conhecto-house-ini = "" and
                p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZZZZ" 
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                  &IF "{&ems_dbtype}" <> "progress":U &THEN
                      p-nr-conhecto-master-ini = "" and
                      p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZ" AND
                      p-nr-conhecto-house-ini = "" and
                      p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZ"   
                  &ELSE 
                        p-nr-conhecto-master-ini = "" and
                        p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZ" AND 
                        p-nr-conhecto-house-ini = "" and
                        p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZZZZ" 
                  &ENDIF       
                &ELSE
                    p-nr-conhecto-master-ini = "" and
                    p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZ" AND 
                    p-nr-conhecto-house-ini = "" and
                    p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZZZZ" 
                &ENDIF  
            &ENDIF 
        &ELSE
            &IF DEFINED(BF-MAT-COMEX) &THEN
                p-nr-conhecimento-ini = "" and
                p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZZZZ" 
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                  &IF {&BF_DIS_VERSAO_EMS} < 2.04 &THEN
                      &IF "{&ems_dbtype}" <> "progress":U &THEN
                          p-nr-conhecimento-ini = "" and
                          p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZ" 
                      &ELSE 
                            p-nr-conhecimento-ini = "" and
                            p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZZZZ" 
                      &ENDIF       
                  &ELSE
                        p-nr-conhecimento-ini = "" and
                        p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZZZZ" 
                  &ENDIF
                &ELSE
                    p-nr-conhecimento-ini = "" and
                    p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZZZZ" 
                &ENDIF  
            &ENDIF 
        &ENDIF
     &endif
     THEN DO:
     ASSIGN l-sem-faixa = YES.

END.

/* Embarque */
for each embarque-imp where 
         embarque-imp.cod-estabel >= p-est-ini and
         embarque-imp.cod-estabel <= p-est-fim AND
         embarque-imp.embarque    >= p-embarque-ini and
         embarque-imp.embarque    <= p-embarque-fim no-lock:

    assign l-ok = yes.               

    IF embarque-imp.cod-via-transp < i-via-transp-ini OR
       embarque-imp.cod-via-transp > i-via-transp-fim THEN
        NEXT.

    if p-sit-emb <> 3 then                                  
        if embarque-imp.situacao <> p-sit-emb then next.          

    &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_dis_versao_ems}" >= "2.04" &then
            IF  p-nr-conhecto-master-ini <> "" OR
                p-nr-conhecto-master-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                IF (p-nr-conhecto-master-ini > embarque-imp.cod-conhecto-master OR
                    p-nr-conhecto-master-fim < embarque-imp.cod-conhecto-master)THEN NEXT.
    
            IF  p-nr-conhecto-house-ini <> "" OR
                p-nr-conhecto-house-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                IF  (p-nr-conhecto-house-ini  > embarque-imp.cod-conhecto-house  OR
                     p-nr-conhecto-house-fim  < embarque-imp.cod-conhecto-house) THEN NEXT.
        &endif
    &else            
        &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            &IF DEFINED(BF-MAT-COMEX) &THEN
                IF p-nr-conhecto-master-ini <> "" OR
                   p-nr-conhecto-master-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                    IF (p-nr-conhecto-master-ini > embarque-imp.cod-conhecto-master OR
                        p-nr-conhecto-master-fim < embarque-imp.cod-conhecto-master) THEN NEXT.

                IF p-nr-conhecto-house-ini <> "" OR
                   p-nr-conhecto-house-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                   IF (p-nr-conhecto-house-ini  > embarque-imp.cod-conhecto-house  OR
                       p-nr-conhecto-house-fim  < embarque-imp.cod-conhecto-house) THEN NEXT.
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                    &IF "{&ems_dbtype}" <> "progress":U &THEN
                        IF p-nr-conhecto-master-ini <> "" OR
                           p-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZ" THEN
                            IF (p-nr-conhecto-master-ini > embarque-imp.cod-conhecto-master OR
                                p-nr-conhecto-master-fim < embarque-imp.cod-conhecto-master) THEN NEXT.

                        IF p-nr-conhecto-house-ini <> "" OR
                           p-nr-conhecto-house-fim = "ZZZZZZZZZZZZZZZ" THEN
                            IF (p-nr-conhecto-house-ini  > embarque-imp.cod-conhecto-house  OR
                                p-nr-conhecto-house-fim  < embarque-imp.cod-conhecto-house) THEN NEXT.

                  &ELSE
                        IF p-nr-conhecto-master-ini <> "" OR
                           p-nr-conhecto-master-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                            IF (p-nr-conhecto-master-ini > embarque-imp.cod-conhecto-master OR
                                p-nr-conhecto-master-fim < embarque-imp.cod-conhecto-master) THEN NEXT.

                        IF p-nr-conhecto-house-ini <> "" OR
                           p-nr-conhecto-house-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                            IF (p-nr-conhecto-house-ini  > embarque-imp.cod-conhecto-house  OR
                                p-nr-conhecto-house-fim  < embarque-imp.cod-conhecto-house) THEN NEXT.
                  &ENDIF       
                &ELSE
                    IF p-nr-conhecto-master-ini <> "" OR
                       p-nr-conhecto-master-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                        IF (p-nr-conhecto-master-ini > embarque-imp.cod-conhecto-master OR
                            p-nr-conhecto-master-fim < embarque-imp.cod-conhecto-master) THEN NEXT.

                    IF p-nr-conhecto-house-ini <> "" OR
                       p-nr-conhecto-house-fim <> "ZZZZZZZZZZZZZZZZZZ" THEN
                        IF (p-nr-conhecto-house-ini  > embarque-imp.cod-conhecto-house  OR
                            p-nr-conhecto-house-fim  < embarque-imp.cod-conhecto-house) THEN NEXT.

                &ENDIF  
            &ENDIF 
        &ELSE
            IF  
            &IF DEFINED(BF-MAT-COMEX) &THEN
                p-nr-conhecimento-ini <> "" OR
                p-nr-conhecimento-fim <> "ZZZZZZZZZZZZZZZZZZ" 
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                  &IF {&BF_DIS_VERSAO_EMS} < 2.04 &THEN
                      &IF "{&ems_dbtype}" <> "progress":U &THEN
                          p-nr-conhecimento-ini <> "" OR
                          p-nr-conhecimento-fim = "ZZZZZZZZZZZZZZZ" 
                      &ELSE
                            p-nr-conhecimento-ini <> "" OR
                            p-nr-conhecimento-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                      &ENDIF       
                  &ELSE
                        p-nr-conhecimento-ini <> "" OR
                        p-nr-conhecimento-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                  &ENDIF
                &ELSE
                    p-nr-conhecimento-ini <> "" OR
                    p-nr-conhecimento-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                &ENDIF  
            &ENDIF 
            THEN DO:
                IF p-nr-conhecimento-ini > embarque-imp.nr-conhecimento OR
                   p-nr-conhecimento-fim < embarque-imp.nr-conhecimento THEN NEXT.
            END.
        &ENDIF
    &endif
    IF p-declar-import-ini <> "" OR
       p-declar-import-fim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN
       IF p-declar-import-ini > embarque-imp.declaracao-import OR
          p-declar-import-fim < embarque-imp.declaracao-import THEN NEXT.

    if  p-veiculo-transp-ini <> "" or
        p-veiculo-transp-fim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN do:

        if substr(embarque-imp.char-1,1,20) < p-veiculo-transp-ini or
           substr(embarque-imp.char-1,1,20) > p-veiculo-transp-fim THEN DO:

            next.
        END.
    END.

    if  p-fatura-ini <> "" or
        p-fatura-fim <> "zzzzzzzzzzzz" THEN DO:
        if  not can-find(first invoice-emb-imp where
            invoice-emb-imp.embarque = embarque-imp.embarque and
            (invoice-emb-imp.nr-invoice >= p-fatura-ini and
             invoice-emb-imp.nr-invoice <= p-fatura-fim)) then
            next.           
    END.
    /* Historico */
    FOR last historico-embarque FIELDS(dt-ult-prev cod-itiner cod-estabel embarque dt-efetiva sequencia dt-previsao)
        where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
              historico-embarque.embarque      = embarque-imp.embarque
              NO-LOCK:
    END.
    if not avail historico-embarque then next.    

    /* Processos */                  
    if p-atraso = 1 then /* atrasados */
        if historico-embarque.dt-ult-prev <= historico-embarque.dt-previsao then next.
    if p-atraso = 2 then /* adiantados */
        if historico-embarque.dt-ult-prev >= historico-embarque.dt-previsao then next.        

    for each tt-historico-tmp:
        delete tt-historico-tmp.
    end.

    /* Itinerario */
    if historico-embarque.cod-itiner < p-itiner-ini or
       historico-embarque.cod-itiner > p-itiner-fim then next.
    find itinerario 
        where itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
    if not avail itinerario then next.
    else do:

        assign i-cod-itiner  = itinerario.cod-itiner
               i-pto-chegada = IF embarque-imp.cdn-pto-chegad > 0 THEN embarque-imp.cdn-pto-chegad ELSE itinerario.pto-chegada.

        if  embarque-imp.cdn-pto-embarq < p-pto-emb-ini 
        or  embarque-imp.cdn-pto-embarq > p-pto-emb-fim then 
            next.

        if  embarque-imp.cdn-pto-desembar < p-pto-des-ini 
        or  embarque-imp.cdn-pto-desembar > p-pto-des-fim then
            next.

        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN

        assign i-pto-solic-li = itinerario.cdn-pto-solic-licenciam-import.

        if  pPtoSolicLiIni <> 0
        or  pPtoSolicLiFim <> 99999 then do:

            if  itinerario.cdn-pto-solic-licenciam-import < pPtoSolicLiIni
            or  itinerario.cdn-pto-solic-licenciam-import > pPtoSolicLiFim then 
                next.
        end.

        &ENDIF 
    end.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN

    for first historico-embarque 
        where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
        and   historico-embarque.embarque      = embarque-imp.embarque 
        and   historico-embarque.cod-itiner    = i-cod-itiner 
        and   historico-embarque.cod-pto-contr = i-pto-solic-li no-lock: end.
    if  not avail historico-embarque then do:

        assign i-pto-solic-li = 0.

        if  pPtoSolicLiIni <> 0
        or  pPtoSolicLiFim <> 99999 then 
            next.
    end.

    &ENDIF 

    if p-local <> 0 then
        FOR FIRST historico-embarque 
            where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                  historico-embarque.embarque      = embarque-imp.embarque and 
                  historico-embarque.cod-itiner    = i-cod-itiner and
                  historico-embarque.cod-pto-contr = p-local              
                  no-lock :
        END.
    else 
        FOR FIRST historico-embarque 
            where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                  historico-embarque.embarque      = embarque-imp.embarque and 
                  historico-embarque.cod-itiner    = i-cod-itiner and
                  historico-embarque.cod-pto-contr = i-pto-chegada
                  NO-LOCK:
        END.
    if avail historico-embarque then do:

       create tt-historico-tmp.
       buffer-copy historico-embarque to tt-historico-tmp.
       assign tt-historico-tmp.r-rowid      = rowid(historico-embarque)
       .
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao004 = {cxinc/i01cx220.i 04 embarque-imp.situacao}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN tt-historico-tmp.c-situacao   = RETURN-VALUE.
       &else
           ASSIGN tt-historico-tmp.c-situacao   = {cxinc/i01cx220.i 04 embarque-imp.situacao}.
       &endif

       if historico-embarque.dt-efetiva <> ? then do:
          assign tt-historico-tmp.prev-chegada = historico-embarque.dt-efetiva.
          if historico-embarque.dt-efetiva < p-data-ini or
             historico-embarque.dt-efetiva > p-data-fim then
             next.
       end.                
       else 
          if historico-embarque.dt-ult-prev <> ? then do:
             assign tt-historico-tmp.prev-chegada = historico-embarque.dt-ult-prev.
             if historico-embarque.dt-ult-prev < p-data-ini or
                historico-embarque.dt-ult-prev > p-data-fim then
                next.
          end.
    end.
    else
       next.

    if p-item-ini <> "" or 
       p-item-fim <> "zzzzzzzzzzzzzzzz" or 
       p-proc-ini <> "" or 
       p-proc-fim <> "zzzzzzzzzzzz" then
       assign l-ok = no. 

    ASSIGN l-existe-ordens = NO.

    for each ordens-embarque FIELDS(nr-proc-imp cod-estabel numero-ordem embarque parcela) where 
             ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
             ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:

        IF l-sem-faixa = NO THEN
           ASSIGN l-existe-ordens = YES.

        if ordens-embarque.nr-proc-imp < p-proc-ini or
           ordens-embarque.nr-proc-imp > p-proc-fim then next.

        FOR FIRST ordem-compra FIELDS (numero-ordem cod-emitente it-codigo num-pedido) no-lock where 
             ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
        END.

        if not avail ordem-compra then do:
           assign l-ok = no.
           leave. 
        end.

        if ordem-compra.cod-emitente < p-exp-ini or
           ordem-compra.cod-emitente > p-exp-fim then do:
           assign l-ok = no.
           leave. 
        end.   

        assign tt-historico-tmp.cod-exportador = ordem-compra.cod-emitente.

        if ordem-compra.it-codigo < p-item-ini or
           ordem-compra.it-codigo > p-item-fim then do:
           assign l-ok = no.
           NEXT. 
        end.   
        FOR first item FIELDS(it-codigo fm-codigo descricao-1 ge-codigo un) no-lock 
             where item.it-codigo = ordem-compra.it-codigo:
        END.
        if not avail item then do:
           assign l-ok = no.
           leave. 
        end.

        IF p-fam-ini <> "" OR
           p-fam-fim <> "ZZZZZZZZ" THEN DO:
           if item.fm-codigo < p-fam-ini   or
              item.fm-codigo > p-fam-fim  THEN DO:
              ASSIGN l-ok = NO.
              NEXT.
           END.
        END.

        IF p-grupo-ini <> 0  OR
           p-grupo-fim <> 99 THEN
           IF item.ge-codigo < p-grupo-ini or
              item.ge-codigo > p-grupo-fim THEN DO:
              ASSIGN l-ok = NO.
              NEXT.
           END.

        FOR FIRST processo-imp FIELDS(situacao nr-proc-imp cod-agente) no-lock 
             where processo-imp.num-pedido = ordem-compra.num-pedido:
        END.
        if not avail processo-imp then do:        
           assign l-ok = no.
           leave. 
        end.

        assign tt-historico-tmp.i-agente = processo-imp.cod-agente.
        if p-situacao <> 5 then
            IF processo-imp.situacao <> p-situacao THEN DO: 
                ASSIGN l-ok = NO.                        
                NEXT.
            END.     

        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN     
            IF pLicencImportIni <> "" 
            OR pLicencImportFim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN DO:
                RUN piRetornaLi IN h-bocx351(INPUT 3,
                                             INPUT YES,
                                             INPUT ?,
                                             INPUT ?,
                                             INPUT ?,
                                             INPUT ordens-embarque.parcela,
                                             INPUT YES,
                                             INPUT YES,
                                             INPUT ordens-embarque.numero-ordem,
                                             INPUT ordens-embarque.numero-ordem,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             OUTPUT TABLE tt-licenciam-import-oc).
                FIND FIRST tt-licenciam-import-oc
                    WHERE tt-licenciam-import-oc.licenca-import >= pLicencImportIni
                    AND   tt-licenciam-import-oc.licenca-import <= pLicencImportFim NO-ERROR.
                IF NOT AVAIL tt-licenciam-import-oc THEN DO:
                    ASSIGN l-ok = NO.                        
                    NEXT.
                END.     
            END.
        &ENDIF

        assign l-ok = yes. 

        leave.               
    end.
    IF l-sem-faixa = NO THEN
       IF l-existe-ordens = NO THEN NEXT.

    if  l-ok = no then
        next.        

    create tt-historico.
    buffer-copy tt-historico-tmp to tt-historico.
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    assign tt-historico.pto-li = i-pto-solic-li.
    &endif
    
    ASSIGN tt-historico.c-via-transp = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}.

    for last historico-embarque FIELDS (cod-pto-contr sequencia descricao)
       where historico-embarque.cod-estabel  = embarque-imp.cod-estabel and
             historico-embarque.embarque     = embarque-imp.embarque and 
             historico-embarque.cod-itiner   = i-cod-itiner and
             (historico-embarque.dt-efetiva  <> ? or
              historico-embarque.dt-efetiva  <> date(""))
             no-lock : end.
    if avail historico-embarque then do:
       for first pto-contr FIELDS(descricao) no-lock 
           where pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr: end. 
        assign tt-historico.posicao = IF historico-embarque.descricao <> "":U  THEN historico-embarque.descricao
                                      ELSE IF AVAIL pto-contr THEN pto-contr.descricao ELSE "":U.
       
    end.              
end.

/*******************************************************************************************************/

if l-ordens = no and
   l-desp   = no and 
   l-tipo   = no and 
   l-adic-embarq = NO AND
   ("{&BF_DIS_VERSAO_EMS}" >= "2.05" AND l-peso-cubagem = NO) 
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        AND tt-param.lDetalhaLi = NO 
    &ENDIF 
   AND l-antecipacao = NO THEN DO:
   for each tt-historico
       break by tt-historico.cod-estabel:
       if first(tt-historico.cod-estabel) then do:
            /* Labels */
       &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN

            IF l-integra = YES THEN
                put                  
                c-situac        at 104 
                c-agent         at 119 skip
                c-estabel       at 01
                c-embarque      at 07
                c-export        at 24
                c-nom-abrev-exp at 35
                c-itiner        at 48
                c-desc          at 55
                c-pto-embarque  at 86
                c-pto-desemb    at 94
                c-via-transp    AT 86
                c-posicao       at 104                         
                c-prev-chegada  at 119 skip
                "-----"         at 01
                "----------------"  at 07
                "----------"    at 24
                "------------"  at 35
                "------"        at 48
                "------------------------------" at 55
                "-------"       at 86
                "---------"     at 94
                "-------------" at 104                
                "----------"    at 119.
            ELSE
                put  
                c-situac        at 104 
                c-agent         at 119 skip
                c-estabel       at 01
                c-embarque      at 07
                c-export        at 24
                c-nom-abrev-exp at 35
                c-itiner        at 48
                c-desc          at 55
                c-pto-embarque  at 86
                c-pto-desemb    at 94 
                c-via-transp    AT 86
                c-posicao       at 104                
                c-prev-chegada  at 119 SKIP
                "---"           at 01
                "------------"  at 07
                "----------"    at 24
                "------------"  at 35
                "------"        at 48
                "------------------------------" at 55
                "-------"       at 86
                "---------"     at 94
                "-------------" at 104
                "----------"    at 119.
       &ELSE
         put  
            c-situac        at 98 skip
            c-estabel       at 01
            c-embarque      at 05
            c-export        at 18
            c-nom-abrev-exp at 29
            c-itiner        at 42
            c-desc          at 49
            c-pto-embarque  at 80
            c-pto-desemb    at 88 
            c-via-transp    AT 80
            c-posicao       at 98
            c-agent         at 113
            c-prev-chegada  at 123
            "---"           at 01
            "------------"  at 05
            "----------"    at 18
            "------------"  at 29
            "------"        at 42
            "------------------------------" at 49
            "-------"       at 80
            "---------"     at 88
            "-------------" at 98
            "---------"     at 113
            "----------"    at 123.
         &ENDIF
       end.
       /* Embarque */
       put tt-historico.cod-estabel at 01
           tt-historico.embarque at 07
           tt-historico.cod-exportador TO 33.

       FOR first emitente FIELDS(nome-abrev) no-lock
          where emitente.cod-emitente = tt-historico.cod-exportador:
       END.
       if avail emitente then
          put emitente.nome-abrev at 35.

       put tt-historico.cod-itiner TO 53.

        FOR FIRST embarque-imp FIELDS(cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw) NO-LOCK
            WHERE embarque-imp.cod-estab = tt-historico.cod-estabel
              AND embarque-imp.embarque =  tt-historico.embarque:
        END.

       FOR FIRST itinerario FIELDS(descricao) where 
          itinerario.cod-itiner = tt-historico.cod-itiner no-lock :
       END.     

       put itinerario.descricao           at 55
           embarque-imp.cdn-pto-embarq    TO 92
           embarque-imp.cdn-pto-desembar  TO 102.

       &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
           IF l-integra = YES THEN
               put tt-historico.c-situacao     at 104
                   tt-historico.i-agente       at 119 SKIP 
                   tt-historico.c-via-transp   AT 86
                   tt-historico.posicao        at 104 FORMAT "x(13)"
                   tt-historico.prev-chegada   at 119.
           ELSE
               put tt-historico.c-situacao     at 104
                   tt-historico.i-agente       at 119 SKIP                    
                   tt-historico.c-via-transp   AT 86
                   tt-historico.posicao        at 104
                   tt-historico.prev-chegada   at 119.
       &ELSE
           put tt-historico.c-situacao     at 98
               tt-historico.i-agente       at 113 
               tt-historico.prev-chegada   at 123 skip 
               tt-historico.c-via-transp   AT 80
               tt-historico.posicao        at 98.
       &ENDIF

   end.

   if line-counter >= 63 then
        page.
end.
else do:
   for each tt-historico break by tt-historico.cod-estabel
                               by tt-historico.embarque:


        FOR FIRST itinerario FIELDS(pto-embarque pto-desembarque descricao cod-itiner) 
            where itinerario.cod-itiner = tt-historico.cod-itiner NO-LOCK:
        END.    

        FOR FIRST embarque-imp FIELDS(cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw) NO-LOCK
            WHERE embarque-imp.cod-estab = tt-historico.cod-estabel
              AND embarque-imp.embarque =  tt-historico.embarque:
        END.

       if avail itinerario then do:          
          FOR FIRST bf-historico-embarque FIELDS(descricao)
              WHERE bf-historico-embarque.cod-estabel   = tt-historico.cod-estabel
                AND bf-historico-embarque.embarque      = tt-historico.embarque
                AND bf-historico-embarque.cod-itiner    = itinerario.cod-itiner
                AND bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq:
              assign c-pto-emb = bf-historico-embarque.descricao.
          END.

          IF c-pto-emb = "":U THEN DO:
              FOR FIRST pto-contr FIELDS (descricao) 
                  WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK:
                  assign c-pto-emb = pto-contr.descricao.
              END.
          END.

          FOR FIRST bf-historico-embarque FIELDS(descricao)
              WHERE bf-historico-embarque.cod-estabel   = tt-historico.cod-estabel
                AND bf-historico-embarque.embarque      = tt-historico.embarque
                AND bf-historico-embarque.cod-itiner    = itinerario.cod-itiner
                AND bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar:
              assign c-pto-des = bf-historico-embarque.descricao.
          END.

          IF c-pto-des = "":U THEN DO:
              FOR FIRST pto-contr FIELDS (descricao) 
                  WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK:
                  assign c-pto-des = pto-contr.descricao.
              END.
          END.

          &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN 
              FOR FIRST bf-historico-embarque FIELDS(descricao)
                  WHERE bf-historico-embarque.cod-estabel   = tt-historico.cod-estabel
                    AND bf-historico-embarque.embarque      = tt-historico.embarque
                    AND bf-historico-embarque.cod-itiner    = itinerario.cod-itiner
                    AND bf-historico-embarque.cod-pto-contr = tt-historico.pto-li:
                  assign c-pto-solic-li = bf-historico-embarque.descricao.
              END.
                
              IF c-pto-solic-li = "":U THEN DO:
                  FOR FIRST pto-contr FIELDS (descricao) 
                      WHERE pto-contr.cod-pto-contr = tt-historico.pto-li NO-LOCK:
                      ASSIGN c-pto-solic-li = pto-contr.descricao.
                  END.
              END.
          &ENDIF

          FOR FIRST emitente FIELDS(cod-emitente nome-abrev) where 
                    emitente.cod-emitente = tt-historico.cod-exportador NO-LOCK:
          END.
          if avail emitente then 
             assign c-nome-abrev = emitente.nome-abrev.

          &if "{&bf_cex_versao_ems}" >= "2.062" &then
              &if "{&bf_dis_versao_ems}" >= "2.04" &then
                  FOR FIRST embarque-imp fields(cod-estabel embarque declaracao-import cod-conhecto-master cod-conhecto-house data-di data-1 cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw)
              &endif
          &else    
              &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                  FOR FIRST embarque-imp fields(cod-estabel embarque declaracao-import cod-conhecto-master cod-conhecto-house data-di data-1 cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw)
              &ELSE
                  FOR FIRST embarque-imp fields(cod-estabel embarque declaracao-import nr-conhecimento data-di data-1 cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw)
              &ENDIF
          &endif    
             where  embarque-imp.cod-estabel = tt-historico.cod-estabel and
                    embarque-imp.embarque = tt-historico.embarque no-lock :
          END.

          if avail  embarque-imp then do:
             assign i-pto-desemb = IF embarque-imp.cdn-pto-desembar > 0 THEN embarque-imp.cdn-pto-desembar ELSE itinerario.pto-desembarque.

             /* Cabe‡alho do embarque */
             disp tt-historico.cod-estabel
                  tt-historico.embarque
                  tt-historico.c-situacao
                  tt-historico.cod-exportador
                  c-nome-abrev
                  tt-historico.cod-itiner
                  itinerario.descricao
                  &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                        tt-historico.pto-li
                        c-pto-solic-li
                  &ENDIF
                  embarque-imp.cdn-pto-embarq
                  c-pto-emb
                  i-pto-desemb
                  c-pto-des
                  tt-historico.c-via-transp
                  embarque-imp.declaracao-import
                  &if "{&bf_cex_versao_ems}" >= "2.062" &then
                      &if "{&bf_dis_versao_ems}" >= "2.04" &then
                          embarque-imp.cod-conhecto-master
                      &endif
                  &else
                      &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                          embarque-imp.cod-conhecto-master
                      &ELSE
                          embarque-imp.nr-conhecimento
                      &ENDIF
                  &endif
                  with frame f-cab-embarque.

            &if "{&bf_cex_versao_ems}" >= "2.062" &then
                &if "{&bf_dis_versao_ems}" >= "2.04" &then
                     IF l-integra = YES THEN
                         disp
                             embarque-imp.data-di    
                             embarque-imp.cod-conhecto-house
                             tt-historico.posicao
                             embarque-imp.data-1
                             with frame f-cab-embarque3.
                     ELSE
                         disp
                             embarque-imp.data-di    
                             embarque-imp.cod-conhecto-house
                             embarque-imp.data-1
                             tt-historico.posicao
                             with frame f-cab-embarque4.
                &endif
            &else
                &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                    IF l-integra = YES THEN
                        disp
                            embarque-imp.data-di    
                            embarque-imp.cod-conhecto-house
                            tt-historico.posicao
                            embarque-imp.data-1
                            with frame f-cab-embarque3.
                    ELSE
                        disp
                            embarque-imp.data-di    
                            embarque-imp.cod-conhecto-house
                            embarque-imp.data-1
                            tt-historico.posicao
                            with frame f-cab-embarque4.

                &ELSE
                     disp
                            embarque-imp.data-di    
                            tt-historico.posicao   
                            embarque-imp.data-1
                            with frame f-cab-embarque2.    
                &ENDIF
            &endif
            
              IF i-pais-impto-usuario <> 1 THEN
                  DISP embarque-imp.log-embarq-transf-draw
                  WITH FRAME f-cab-embarque5.
          end.      

          if l-tipo = yes then do: /* Detalhes do itinerario */
             run pi-imprime-det-itiner.
          end.
          
          /* L¢gica - Relat¢rio Posi‡Æo de Embarque */
          IF  l-adic-embarq 
          AND CAN-FIND(FIRST ordens-embarque
                       WHERE ordens-embarque.cod-estabel = tt-historico.cod-estabel
                         AND ordens-embarque.embarque    = tt-historico.embarque) THEN DO:
              EMPTY TEMP-TABLE tt-ordens-embarq.
              
              FOR EACH ordens-embarque FIELDS (nr-proc-imp num-adic val-tax-siscomex char-1 numero-ordem quantidade cod-estabel) NO-LOCK
                  WHERE ordens-embarque.cod-estabel = tt-historico.cod-estabel
                    AND ordens-embarque.embarque    = tt-historico.embarque:
                  
                  FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo)
                      WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                  END.
                  
                  FOR FIRST ITEM FIELDS(it-codigo descricao-1)
                      WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
                  END.
                  
                  CREATE tt-ordens-embarq.
                  ASSIGN l-ok-adic = YES
                         tt-ordens-embarq.nr-proc-imp        = ordens-embarque.nr-proc-imp
                         tt-ordens-embarq.numero-ordem       = ordens-embarque.numero-ordem
                         tt-ordens-embarq.quantidade         = ordens-embarque.quantidade
                         tt-ordens-embarq.c-descricao        = ITEM.descricao-1
                         tt-ordens-embarq.it-codigo          = ordem-compra.it-codigo
                         tt-ordens-embarq.seq-item-ad        = INT(SUBSTRING(ordens-embarque.char-1,80,4))
                         &if "{&bf_mat_versao_ems}" >= "2.07" &then
                         tt-ordens-embarq.i-num-adic         =  ordens-embarque.num-adic         
                         tt-ordens-embarq.i-val-tax-siscomex =  ordens-embarque.val-tax-siscomex
                         &ELSE
                         tt-ordens-embarq.i-num-adic         =  INT(SUBSTRING(ordens-embarque.char-1,60,4))
                         tt-ordens-embarq.i-val-tax-siscomex =  DEC(SUBSTRING(ordens-embarque.char-1,64,16)) / 100000
                         &ENDIF.
              END.
              
              ASSIGN i-tot-por-embarq = 0.
              FOR EACH tt-ordens-embarq NO-LOCK
                 BREAK BY tt-ordens-embarq.i-num-adic:
                  
                  IF l-ok-adic = YES THEN DO:
                     ASSIGN l-ok-adic = NO.
                     DISP c-lb-adic-embarque
                          c-lb-num-adic
                          c-seq-item-ad
                          c-lb-val-tax-siscome
                          c-lb-processo
                          c-lb-ordem
                          c-lb-item
                          c-lb-desc-item
                          c-lb-qtde
                          c-lb-tot-val-tax-sis
                          WITH FRAME f-label-adicao.


                  END.
                  
                  IF  FIRST-OF(tt-ordens-embarq.i-num-adic) THEN DO:
                      ASSIGN i-qtde-tot-tax = 0.
                      
                      FOR EACH b-tt-ordens-emb
                         WHERE b-tt-ordens-emb.i-num-adic = tt-ordens-embarq.i-num-adic:
                          ASSIGN i-qtde-tot-tax = i-qtde-tot-tax + b-tt-ordens-emb.quantidade.
                      END.
                      
                      DISP tt-ordens-embarq.i-num-adic
                           tt-ordens-embarq.seq-item-ad
                           tt-ordens-embarq.i-val-tax-siscomex
                           WITH FRAME f-adic-embarque.
                  END.
                  
                  ASSIGN i-tot-val-tax-sis = (tt-ordens-embarq.i-val-tax-siscomex * tt-ordens-embarq.quantidade / i-qtde-tot-tax)
                         i-tot-por-embarq = i-tot-por-embarq + i-tot-val-tax-sis.
                  
                  DISP tt-ordens-embarq.nr-proc-imp
                       tt-ordens-embarq.numero-ordem
                       tt-ordens-embarq.it-codigo
                       tt-ordens-embarq.c-descricao
                       tt-ordens-embarq.quantidade
                       i-tot-val-tax-sis
                       WITH FRAME f-adic-embarque.
                  DOWN WITH FRAME f-adic-embarque.
              END.
              
              DISP c-lb-total i-tot-por-embarq
                   WITH FRAME f-adic-emb-total.
              DOWN WITH FRAME f-adic-emb-total.
          END.
          
          if l-ordens or
             l-peso-cubagem then do: /* Ordens do embarque */            
             put skip(1).
             assign i-aux = 1.
             for each ordens-embarque FIELDS(numero-ordem embarque cod-estabel parcela quantidade
                                             identific-container embarque nr-proc-imp qt-do-forn) no-lock
                 where ordens-embarque.cod-estabel = tt-historico.cod-estabel                  
                 break by ordens-embarque.nr-proc-imp
                       by ordens-embarque.embarque:

                 if ordens-embarque.embarque  <> tt-historico.embarque then 
                    next.

                 assign i-mo-codigo1   = 0
                        de-preco-unit1 = 0
                        i-mo-cotacao   = 0
                        de-preco-cotac-sem-ipi = 0
                        c-it-codigo1   = ""
                        c-descricao1   = "".                          

                 FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo) where 
                      ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                 END.
                 FOR FIRST cotacao-item FIELDS(numero-ordem mo-codigo preco-unit aliquota-ipi pre-unit-for un)
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                    cotacao-item.cot-aprovada NO-LOCK:
                 END.
                 if avail cotacao-item then do:
                    FOR FIRST ITEM FIELDS(un)
                        where item.it-codigo = ordem-compra.it-codigo NO-LOCK:
                    END.
                    if tt-param.i-opcao = 1 then do: /*Internos*/
                        assign i-mo-cotacao           = cotacao-item.mo-codigo
                               de-preco-cotac-sem-ipi = (cotacao-item.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
                               c-un                   = item.un.
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input tt-param.moeda,
                                          input ((cotacao-item.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)),
                                          input  tt-param.dt-cotacao,
                                          output de-preco-unit1).
                    end.
                    else do:                         /*Fornecedor*/
                        assign i-mo-cotacao           = cotacao-item.mo-codigo
                               de-preco-cotac-sem-ipi = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)
                               c-un                   = cotacao-item.un.
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input tt-param.moeda,
                                          input ((cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)),
                                          input  tt-param.dt-cotacao,
                                          output de-preco-unit1).
                    end.

                    assign i-mo-codigo1 = tt-param.moeda.
                 end.    
                 ASSIGN l-ok = YES.
                 FOR FIRST ITEM FIELDS(it-codigo ge-codigo fm-codigo descricao-1 un)
                    where item.it-codigo = ordem-compra.it-codigo NO-LOCK:
                 END.
                 if avail item THEN DO:
                    assign c-it-codigo1 = item.it-codigo
                           c-descricao1 = item.descricao-1.                              

                    IF p-fam-ini <> "" OR
                       p-fam-fim <> "ZZZZZZZZ" THEN DO:
                       if item.fm-codigo < p-fam-ini   or
                          item.fm-codigo > p-fam-fim  THEN DO:
                          ASSIGN l-ok = NO.
                       END.
                    END.
                    IF p-grupo-ini <> 0  OR
                       p-grupo-fim <> 99 THEN
                       IF item.ge-codigo < p-grupo-ini or
                          item.ge-codigo > p-grupo-fim THEN
                          ASSIGN l-ok = NO.

                 END.
                 ELSE ASSIGN l-ok = NO.

                 IF l-ordens THEN DO:
                 if first-of(ordens-embarque.embarque) then do:
                     IF l-ok = YES THEN
                         disp   c-lb-processo
                                c-lb-ordem
                                c-lb-item
                                c-lb-desc-item
                                c-lb-parc
                                c-lb-quantidade
                                c-lb-moeda
                                c-lb-un
                                c-lb-preco-unit
                                c-lb-mo-orig
                                c-lb-preco-orig
                                c-lb-identificacao
                                with frame f-label-ord-embarque.
                 end.
                 IF l-ok = YES THEN DO:
                     if tt-param.i-opcao = 1 then /*Internos*/
                         assign i-qtde = ordens-embarque.quantidade.
                     else                         /*Fornecedor*/
                         assign i-qtde = ordens-embarque.qt-do-forn.

                     disp ordens-embarque.nr-proc-imp
                          ordens-embarque.numero-ordem
                          c-it-codigo1
                          c-descricao1 format "x(14)"
                          ordens-embarque.parcela
                          i-qtde 
                          c-un           
                          i-mo-codigo1
                          de-preco-unit1
                          i-mo-cotacao
                          de-preco-cotac-sem-ipi 
                          with frame f-ord-embarque.
                     down with frame f-ord-embarque.
                 END.
                 IF l-ok = YES THEN
                     if  ordens-embarque.identific-container <> "" then do:
                         put ordens-embarque.identific-container at 01 skip.
                     end.
                 END.

                 /*********** Chamada EPC ***********/   

                 for each tt-epc:
                     delete tt-epc.
                 end.    

                 create tt-epc.
                 assign tt-epc.cod-event     = "imprime-ordens-embarque":U
                        tt-epc.cod-parameter = "rowid(ordens-embarque)"
                        tt-epc.val-parameter = string(rowid(ordens-embarque)). 

                 {include/i-epc201.i "imprime-ordens-embarque"}

                 find first tt-epc 
                       where tt-epc.cod-event     = "imprime-ordens-embarque"
                         and tt-epc.cod-parameter = "observacao" no-error.

                 if avail tt-epc then do:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-narrativa AS CHARACTER FORMAT "X(13)" NO-UNDO.
                     {utp/ut-liter.i "Narrativa" *}
                     ASSIGN c-lbl-liter-narrativa = TRIM(RETURN-VALUE).
                     put c-lbl-liter-narrativa + ": " skip.
                     run pi-imprime-observacao(tt-epc.val-parameter).
                     put skip(1).
                 end.
             end.                    

             &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN
                 RUN pi-ordens-embarque-205.     
             &ENDIF
          end.
          &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
            IF tt-param.lDetalhaLi THEN
                RUN piLicencImport.     
          &ENDIF                    

          if  l-desp then do: /* Despesas do embarque */

              put skip(1).

              for first ordens-embarque fields(numero-ordem nr-proc-imp cod-estabel)
                  where ordens-embarque.cod-estabel = tt-historico.cod-estabel
                  and   ordens-embarque.embarque    = tt-historico.embarque no-lock: end.

              for first ordem-compra fields (numero-ordem cod-emitente)
                  where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock: end.
              if  avail ordem-compra then 
                  assign i-cod-emitente = ordem-compra.cod-emitente.

              assign l-existe-desp           = no
                     tot-de-valor-desp-conv = 0.      

              FOR FIRST embarque-imp FIELDS(cdn-pto-embarq cdn-pto-desembar log-embarq-transf-draw) NO-LOCK
                  WHERE embarque-imp.cod-estab = tt-historico.cod-estabel
                    AND embarque-imp.embarque =  tt-historico.embarque:
              END.

              for each desp-embarque fields(cod-emitente-desp embarque mo-codigo cod-estabel cod-pto-contr 
                                            mo-codigo cod-cond-pag cod-desp val-desp char-1
                                            &if "{&bf_dis_versao_ems}" >= "2.04" and "{&bf_dis_versao_ems}" <= "2.05" &then
                                                log-1
                                            &elseif "{&bf_dis_versao_ems}" > "2.05" &then
                                                log-despes-ja-recbda
                                            &endif 
                                            &if "{&bf_dis_versao_ems}":U >= "2.062":U &then
                                                cod-incoterm-rat descricao
                                            &endif) 
                  where desp-embarque.cod-estabel = tt-historico.cod-estabel
                  and   desp-embarque.embarque    = tt-historico.embarque no-lock by desp-embarque.cod-emitente-desp:

                  if  i-detalhe-desp = 1 
                  and desp-embarque.cod-emitente-desp <> i-cod-emitente then
                      next.

                  assign c-nome-abrev  = ""
                         c-descricao2  = ""
                         l-existe-desp = yes.                          

                  for first emitente fields(cod-emitente nome-abrev)
                      where emitente.cod-emitente = desp-embarque.cod-emitente-desp no-lock: end.
                  if  avail emitente then 
                      assign c-nome-abrev2 = emitente.nome-abrev.                              

                  for first desp-imp fields(cod-desp descricao tipo)
                      where desp-imp.cod-desp = desp-embarque.cod-desp no-lock: end.
                  
                  assign c-descricao2 = IF desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE IF AVAIL desp-imp THEN desp-imp.descricao ELSE "":U.

                  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                      DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
                      ASSIGN cAuxTraducao005 = {cxinc/i01cx010.i 04 desp-imp.tipo}.
                      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                                          INPUT "",
                                          INPUT "").
                      ASSIGN  c-tipo-desp = RETURN-VALUE.
                  &else
                      ASSIGN c-tipo-desp = {cxinc/i01cx010.i 04 desp-imp.tipo}.
                  &endif

                  run cdp/cd0812.p (input desp-embarque.mo-codigo,
                                    input tt-param.moeda,
                                    input desp-embarque.val-desp,
                                    input /*today*/ tt-param.dt-cotacao,
                                    output de-valor-desp-conv).

                  if  c-cod-estabel = desp-embarque.cod-estabel
                  and c-embarque-aux = desp-embarque.embarque
                  and i-cod-emitente-desp <> desp-embarque.cod-emitente-desp then do:

                      assign i-cod-emitente-desp = desp-embarque.cod-emitente-desp
                             c-cod-emitente-desp = string(desp-embarque.cod-emitente-desp,">>>>>>>>9")
                             l-tot-desp          = yes.     
                  end.
                  else do:

                      assign c-cod-emitente-desp = ""
                             l-tot-desp          = no.
                  end.                         

                  if  c-cod-estabel  <> desp-embarque.cod-estabel
                  or  c-embarque-aux <> desp-embarque.embarque then do:

                      assign i-cod-emitente-desp = desp-embarque.cod-emitente-desp
                             c-cod-emitente-desp = string(desp-embarque.cod-emitente-desp,">>>>>>>>9":U)
                             c-cod-estabel       = desp-embarque.cod-estabel
                             c-embarque-aux      = desp-embarque.embarque.

                      {utp/ut-field.i mgcex desp-embarque cod-emitente-desp 2}
                      assign c-fornecedor = (return-value).
                      {utp/ut-liter.i Nome_Abrev * R}
                      assign c-nome-abrev-2 = (return-value).
                      {utp/ut-field.i mgcex desp-embarque cod-pto-contr 2}
                      assign c-cod-pto = (return-value).
                      {utp/ut-field.i mgcex desp-embarque cod-desp 2}
                      assign c-cod-desp = (return-value).
                      {utp/ut-field.i mgcex desp-imp descricao 2}
                      assign c-descricao-2 = (return-value).
                      &if "{&BF_DIS_VERSAO_EMS}":U >= "2.04":U &then
                          {utp/ut-liter.i Pgto * r}
                          assign c-cod-pag = trim(return-value).
                      &else
                          {utp/ut-field.i mgcex desp-embarque cod-cond-pag 2}
                          assign c-cod-pag = (return-value).
                      &endif
                      {utp/ut-field.i mgcex desp-embarque mo-codigo 1}
                      assign c-moeda = (return-value).
                      &if defined(bf-mat-comex) &then
                          {utp/ut-field.i mgadm moeda descricao 2}
                      &else
                          {utp/ut-field.i mguni moeda descricao 2}
                      &endif
                      assign c-descricao-3 = (return-value).
                      {utp/ut-field.i mgcex desp-embarque val-desp 2}
                      assign c-valor-desp = (return-value).

                      disp c-fornecedor 
                           c-nome-abrev-2
                           c-cod-pto 
                           c-cod-desp 
                           c-descricao-2
                           &if "{&BF_DIS_VERSAO_EMS}":U >= "2.04":U &then
                               c-recebda
                           &endif
                           c-cod-pag 
                           c-valor-desp
                           c-mo-desp-orig
                           c-valor-desp-orig
                           with frame f-label-embarque.
                  end.

                  &if "{&BF_DIS_VERSAO_EMS}":U >= "2.04":U &then

                  find first historico-embarque 
                     where  historico-embarque.embarque      = tt-historico.embarque
                     and    historico-embarque.cod-itiner    = tt-historico.cod-itiner
                     and    historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock no-error.

                  IF AVAIL historico-embarque THEN
                      assign i-pto-nacionalizacao = historico-embarque.sequencia.

                  find historico-embarque 
                      where historico-embarque.cod-estabel   = tt-historico.cod-estabel
                      and   historico-embarque.embarque      = tt-historico.embarque 
                      and   historico-embarque.cod-itiner    = tt-historico.cod-itiner
                      and   historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr no-lock no-error.

                  if AVAIL historico-embarque
                  AND historico-embarque.sequencia <= i-pto-nacionalizacao then
                      assign c-recebda2 = "---".
                  else
                      &if "{&bf_dis_versao_ems}":U <= "2.05":U &then
                          assign c-recebda2 = if desp-embarque.log-1 = yes then "Sim"
                                              else "NÆo".
                      &elseif "{&bf_dis_versao_ems}" > "2.05" &then
                          assign c-recebda2 = if  desp-embarque.log-despes-ja-recbda = yes then "Sim"
                                              else "NÆo".
                      &endif
                  &endif

                  disp c-cod-emitente-desp 
                       c-nome-abrev2 
                       desp-embarque.cod-pto-contr 
                       desp-embarque.cod-desp 
                       c-descricao2 
                       &if "{&BF_DIS_VERSAO_EMS}":U >= "2.04":U &then
                           c-recebda2
                       &endif
                       desp-embarque.cod-cond-pag 
                       de-valor-desp-conv 
                       desp-embarque.mo-codigo
                       desp-embarque.val-desp
                       with frame f-desp-embarque2.
                  down with frame f-desp-embarque2.

                  if  l-detalha-desp then do:

                      &if defined(bf-mat-comex) &then
                          assign c-incoterm-rat = substr(desp-embarque.char-1,1,3).
                      &else
                          &if '{&bf_mat_versao_ems}' < '2.062' &then
                              assign c-incoterm-rat = substr(desp-embarque.char-1,1,3).
                          &else
                              assign c-incoterm-rat = desp-embarque.cod-incoterm-rat.
                          &endif
                      &endif

                      disp c-lb-tipo-desp
                           c-tipo-desp
                           c-lb-incoterm-rat
                           c-incoterm-rat
                           with frame f-detalha-desp.
                      down with frame f-detalha-desp.
                  end.

                  assign tot-de-valor-desp-conv = tot-de-valor-desp-conv + de-valor-desp-conv.                    
              end. /* end for each desp-embarque */              

              if  l-existe-desp then do:

                  disp tot-de-valor-desp-conv
                       with frame f-tot-desp-embarque.
                  down with frame f-tot-desp-embarque.     
              end.                             
          end.
          else 
              put skip(1).
       end. /* itinerario */

       for each invoice-emb-imp FIELDS(nr-invoice mo-codigo vl-invoice parcela dt-vencim) where 
           invoice-emb-imp.cod-estabel = tt-historico.cod-estabel and
           invoice-emb-imp.embarque = tt-historico.embarque no-lock 
           break by invoice-emb-imp.nr-invoice:           


           if first-of(invoice-emb-imp.nr-invoice) then
              disp invoice-emb-imp.nr-invoice 
              with frame f-fat-embarque.

           run cdp/cd0812.p (input invoice-emb-imp.mo-codigo,
                             input tt-param.moeda,
                             input invoice-emb-imp.vl-invoice,
                             input  tt-param.dt-cotacao,
                             output de-vl-invoice).   

           FOR FIRST moeda FIELDS(mo-codigo descricao)
               where moeda.mo-codigo = invoice-emb-imp.mo-codigo no-lock:
           END.
           if avail moeda then
              assign c-moeda-desc = moeda.descricao.

           disp invoice-emb-imp.parcela
                invoice-emb-imp.dt-vencim
                de-vl-invoice
                invoice-emb-imp.mo-codigo
                invoice-emb-imp.vl-invoice
           with frame f-fat-embarque.
           down with frame f-fat-embarque.     
       end.

       IF  l-fn-antecipacao
       AND l-antecipacao THEN DO:
           RUN piImprimeAntecipacao.
       END.

       if line-counter >= 63 then
          page.
   end.     
end.

/* Pagina de parametros */
page.

FOR FIRST moeda FIELDS(descricao)
    where moeda.mo-codigo = tt-param.moeda NO-LOCK:
END.
if avail moeda then
    assign c-moeda-desc = moeda.descricao.    

disp c-sel
     tt-param.c-est-ini
     tt-param.c-est-fim
     tt-param.c-embarque-ini
     tt-param.c-embarque-fim
     tt-param.c-proc-ini
     tt-param.c-proc-fim
     tt-param.i-exp-ini
     tt-param.i-exp-fim
     tt-param.i-itiner-ini
     tt-param.i-itiner-fim
     &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
         tt-param.iPtoSolicLiIni
         tt-param.iPtoSolicLiFim
     &ENDIF
     tt-param.i-pto-emb-ini
     tt-param.i-pto-emb-fim
     tt-param.i-pto-des-ini
     tt-param.i-pto-des-fim
     tt-param.i-grupo-ini
     tt-param.i-grupo-fim
     tt-param.c-fam-ini
     tt-param.c-fam-fim
     tt-param.c-item-ini
     tt-param.c-item-fim
     tt-param.c-fatura-ini
     tt-param.c-fatura-fim
     &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_dis_versao_ems}" >= "2.04" &then
            tt-param.nr-conhecto-master-ini FORMAT "x(18)"
            tt-param.nr-conhecto-master-fim FORMAT "x(18)"
            tt-param.nr-conhecto-house-ini  FORMAT "x(18)"
            tt-param.nr-conhecto-house-fim  FORMAT "x(18)"
        &endif
     &else
         &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
             tt-param.nr-conhecto-master-ini FORMAT "x(18)"
             tt-param.nr-conhecto-master-fim FORMAT "x(18)"
             tt-param.nr-conhecto-house-ini  FORMAT "x(18)"
             tt-param.nr-conhecto-house-fim  FORMAT "x(18)"
         &ELSE
             tt-param.nr-conhecimento-ini FORMAT "x(18)"
             tt-param.nr-conhecimento-fim FORMAT "x(18)"
         &ENDIF
     &endif
     &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
         tt-param.veiculo-transp-ini  FORMAT "x(20)"
         tt-param.veiculo-transp-fim  FORMAT "x(20)"
         tt-param.declar-import-ini   FORMAT "x(20)"
         tt-param.declar-import-fim   FORMAT "x(20)"
         tt-param.cLicencImportIni    FORMAT "x(20)"
         tt-param.cLicencImportFim    FORMAT "x(20)"
     &ELSE
         tt-param.declar-import-ini   FORMAT "x(20)"
         tt-param.declar-import-fim   FORMAT "x(20)"
         tt-param.veiculo-transp-ini  FORMAT "x(20)"
         tt-param.veiculo-transp-fim  FORMAT "x(20)"
     &ENDIF
     string(tt-param.via-transp-ini) + "-" + {adinc/i01ad268.i 04 tt-param.via-transp-ini} @ c-via-transp-ini
     string(tt-param.via-transp-fim) + "-" + {adinc/i01ad268.i 04 tt-param.via-transp-fim} @ c-via-transp-fim
    WITH FRAME f-param-sel.


IF l-fn-antecipacao THEN DO:
    DISPLAY    
         c-par
         tt-param.i-local
         tt-param.moeda c-moeda-desc     
         tt-param.dt-cotacao
         tt-param.da-data-ini
         tt-param.da-data-fim     
         c-sit-emb     
         c-atraso     
         c-situacao
         c-imp
         c-destino
         tt-param.arquivo format "x(40)"
         tt-param.usuario
         tt-param.l-tipo      
    
         tt-param.l-observacao
         tt-param.l-ordens
         &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
             tt-param.l-peso-cub
             tt-param.lDetalhaLi
         &ENDIF
         tt-param.l-desp
         c-detalhe-desp
         tt-param.l-detalha-desp
         c-unqtd
         tt-param.l-adic-embarq
         tt-param.lantecipacao
         with frame f-param-antecip.
END.
ELSE DO:
    DISPLAY    
         c-par
         tt-param.i-local
         tt-param.moeda c-moeda-desc     
         tt-param.dt-cotacao
         tt-param.da-data-ini
         tt-param.da-data-fim     
         c-sit-emb     
         c-atraso     
         c-situacao
         c-imp
         c-destino
         tt-param.arquivo format "x(40)"
         tt-param.usuario
         tt-param.l-tipo      
    
         tt-param.l-observacao
         tt-param.l-ordens
         &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
             tt-param.l-peso-cub
             tt-param.lDetalhaLi
         &ENDIF
         tt-param.l-desp
         c-detalhe-desp
         tt-param.l-detalha-desp
         c-unqtd
         tt-param.l-adic-embarq
         with frame f-param.
END.

assign c-detalhe-desp = "".
{include/i-rpclo.i}

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    IF VALID-HANDLE(h-bocx351) THEN
        DELETE PROCEDURE h-bocx351.  
&ENDIF

Procedure pi-imprime-det-itiner:
/*************************************************
** Procedure que imprime detalhe do itinerario, **
** parametrizado na tela.                       **
**************************************************/

    put skip(1).
    for each historico-embarque FIELDS(cod-pto-contr dt-previsao dt-ult-previsao dt-efetiva observacao 
                                       sequencia id-meio-transp descricao)
        where historico-embarque.cod-estabel = tt-historico.cod-estabel and 
              historico-embarque.cod-itiner  = tt-historico.cod-itiner  and
              historico-embarque.embarque    = tt-historico.embarque no-lock         
              break by historico-embarque.sequencia:
        disp historico-embarque.sequencia
             historico-embarque.cod-pto-contr 
             with frame f-det-embarque.
        FOR FIRST pto-contr FIELDS(descricao) 
            WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-LOCK:
        END.
        assign c-descricao = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao
                             ELSE IF AVAIL pto-contr THEN pto-contr.descricao ELSE "":U.
        /* Diferenca */                        
        if historico-embarque.dt-efetiva <> ? then 
            assign i-diferenca = 
                   historico-embarque.dt-efetiva - historico-embarque.dt-previsao.     
        else assign i-diferenca =
            historico-embarque.dt-ult-previsao - historico-embarque.dt-previsao.
        /* Historico */                        
        disp c-descricao
             historico-embarque.dt-previsao
             historico-embarque.dt-ult-previsao
             historico-embarque.dt-efetiva
             i-diferenca
             historico-embarque.id-meio-transp 
             with frame f-det-embarque.
        down with frame f-det-embarque.
        if l-observacao = yes then do:
            run pi-imprime-observacao (input historico-embarque.observacao).
        end.    
    end. 
end procedure.

Procedure pi-imprime-observacao:
/******************************************************
** Procedure que imprime as observacoes do historico **
** embarque, parametrizado na tela.                  **
*******************************************************/

   def input parameter p-texto as char no-undo.

   run pi-print-editor(input p-texto, input 110).

   for each tt-editor: 
        put tt-editor.conteudo format "x(110)" at 05.
   end.

end procedure.

PROCEDURE pi-ordens-embarque-205:
    DISABLE TRIGGERS FOR LOAD OF ordens-embarque.
    DISABLE TRIGGERS FOR LOAD OF cotacao-item.

    for each ordens-embarque FIELDS(numero-ordem embarque cod-estabel parcela quantidade qt-do-forn
                                    identific-container embarque nr-proc-imp peso-liquido peso-bruto
                                    val-cub-tot) no-lock
       where ordens-embarque.cod-estabel = tt-historico.cod-estabel 
         and ordens-embarque.embarque  = tt-historico.embarque                  
       break by ordens-embarque.nr-proc-imp
             by ordens-embarque.embarque:
        
        assign c-it-codigo1   = ""
               c-descricao1   = "".                          

        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

            FOR FIRST cotacao-item FIELDS(numero-ordem mo-codigo preco-unit aliquota-ipi pre-unit-for un)
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cot-aprovada NO-LOCK:
            END.

            ASSIGN l-ok = YES.

            FOR FIRST ITEM FIELDS(it-codigo ge-codigo fm-codigo descricao-1 un)
                WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
            END.
        END.
        IF AVAIL item THEN DO:
            ASSIGN c-it-codigo1 = item.it-codigo
                   c-descricao1 = item.descricao-1.                              

            IF p-fam-ini <> "" OR p-fam-fim <> "ZZZZZZZZ" THEN
                 IF item.fm-codigo < p-fam-ini OR item.fm-codigo > p-fam-fim  THEN
                    ASSIGN l-ok = NO.

            IF p-grupo-ini <> 0 OR p-grupo-fim <> 99 THEN
                IF item.ge-codigo < p-grupo-ini OR item.ge-codigo > p-grupo-fim THEN
                    ASSIGN l-ok = NO.
        END.

        ELSE ASSIGN l-ok = NO.

        IF FIRST-OF(ordens-embarque.embarque) THEN DO:
            IF  l-peso-cubagem THEN DO:
                IF l-ok = YES THEN DO:
                    disp c-lb-peso-cub
                         c-lb-processo
                         c-lb-ordem
                         c-lb-item
                         c-lb-parc
                         c-lb-quantidade
                         c-lb-un
                         c-lb-peso-liq
                         c-lb-peso-bruto
                         c-lb-cubagem
                         with frame f-label-ord-embarque-pc.
                END.
            END.
        END.
        IF  l-peso-cubagem THEN DO:
            IF l-ok = YES THEN DO:

                if tt-param.i-opcao = 1 then do: /*Internos*/
                    assign i-qtde-pc = ordens-embarque.quantidade
                           c-un      = ITEM.un.
                    disp ordens-embarque.nr-proc-imp
                         ordens-embarque.numero-ordem
                         c-it-codigo1  
                         ordens-embarque.parcela  FORMAT ">>>9"
                         i-qtde-pc
                         c-un @ c-un-pc
                         &if '{&bf_mat_versao_ems}':U < '2.062':U  &then
                         ordens-embarque.quantidade * 
                         &endif
                         ordens-embarque.peso-liquido @ de-peso-liq
                         &if '{&bf_mat_versao_ems}':U < '2.062':U  &then
                         ordens-embarque.quantidade * 
                         &endif
                         ordens-embarque.peso-bruto @ de-peso-bruto
                         ordens-embarque.quantidade * &IF "{&bf_mat_versao_ems}" >= "2.062" &then ordens-embarque.val-cub-tot &else ordens-embarque.val-cub-uni &endif @ de-cubagem
                         with frame f-ord-embarque-pc.
                         down with frame f-ord-embarque-pc.
                end.
                else do:                        /*Fornecedor*/
                    assign i-qtde-pc = ordens-embarque.qt-do-forn
                           c-un      = cotacao-item.un.
                    disp ordens-embarque.nr-proc-imp
                         ordens-embarque.numero-ordem
                         c-it-codigo1  
                         ordens-embarque.parcela  FORMAT ">>>9"
                         i-qtde-pc
                         c-un @ c-un-pc
                         ordens-embarque.qt-do-forn * ordens-embarque.peso-liquido @ de-peso-liq
                         ordens-embarque.qt-do-forn * ordens-embarque.peso-bruto @ de-peso-bruto
                         ordens-embarque.qt-do-forn * &IF "{&bf_mat_versao_ems}" >= "2.062" &then ordens-embarque.val-cub-tot &else ordens-embarque.val-cub-uni &endif @ de-cubagem
                         with frame f-ord-embarque-pc.
                         down with frame f-ord-embarque-pc.
                end.
            END.
        END.

        if tt-param.i-opcao = 1 then /*Internos*/
            ASSIGN de-peso-liq-tot   = de-peso-liq-tot   + (&if '{&bf_mat_versao_ems}':U < '2.062':U  &then ordens-embarque.quantidade * &endif ordens-embarque.peso-liquido)    
                   de-peso-bruto-tot = de-peso-bruto-tot + (&if '{&bf_mat_versao_ems}':U < '2.062':U  &then ordens-embarque.quantidade * &endif ordens-embarque.peso-bruto)      
                   de-cubagem-tot    = de-cubagem-tot    + (ordens-embarque.quantidade * &IF "{&bf_mat_versao_ems}" >= "2.062" &then ordens-embarque.val-cub-tot &else ordens-embarque.val-cub-uni &endif).
        else                         /*Fornecedor*/
            ASSIGN de-peso-liq-tot   = de-peso-liq-tot   + (&if '{&bf_mat_versao_ems}':U < '2.062':U  &then ordens-embarque.qt-do-forn * &endif ordens-embarque.peso-liquido)    
                   de-peso-bruto-tot = de-peso-bruto-tot + (&if '{&bf_mat_versao_ems}':U < '2.062':U  &then ordens-embarque.qt-do-forn * &endif ordens-embarque.peso-bruto)      
                   de-cubagem-tot    = de-cubagem-tot    + (ordens-embarque.qt-do-forn * &IF "{&bf_mat_versao_ems}" >= "2.062" &then ordens-embarque.val-cub-tot &else ordens-embarque.val-cub-uni &endif).

        IF LAST-OF(ordens-embarque.embarque) then DO:
            IF  l-peso-cubagem THEN
                DISP c-lb-tit-tot
                     de-peso-liq-tot
                     de-peso-bruto-tot
                     de-cubagem-tot
                WITH FRAME f-ord-embarque-pc-tot.
        END.                        
    END.                    

    ASSIGN de-peso-liq-tot   = 0
           de-peso-bruto-tot = 0
           de-cubagem-tot    = 0.

END PROCEDURE.

PROCEDURE piLicencImport:

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    FOR EACH ordens-embarque FIELDS(numero-ordem embarque cod-estabel quantidade qt-do-forn parcela
                                    identific-container embarque nr-proc-imp peso-liquido peso-bruto &IF "{&bf_mat_versao_ems}" >= "2.062" &then val-cub-tot &else val-cub-uni &endif) NO-LOCK
        WHERE ordens-embarque.cod-estabel = tt-historico.cod-estabel                  
        AND   ordens-embarque.embarque    = tt-historico.embarque
        BREAK BY ordens-embarque.nr-proc-imp
              BY ordens-embarque.embarque:

        IF ordens-embarque.embarque  <> tt-historico.embarque THEN 
            NEXT.

        IF FIRST-OF(ordens-embarque.embarque) THEN DO:
            ASSIGN lImprime = YES
                   l-ok     = NO.
        END.

        ASSIGN c-it-codigo1   = "".                          

        IF  pLicencImportIni <> "" 
        OR  pLicencImportFim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN DO:
            RUN piRetornaLi IN h-bocx351(INPUT 3,
                                         INPUT YES,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT ordens-embarque.parcela,
                                         INPUT YES,
                                         INPUT YES,
                                         INPUT ordens-embarque.numero-ordem,
                                         INPUT ordens-embarque.numero-ordem,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         OUTPUT TABLE tt-licenciam-import-oc).
            FIND FIRST tt-licenciam-import-oc
                WHERE tt-licenciam-import-oc.licenca-import >= pLicencImportIni
                AND   tt-licenciam-import-oc.licenca-import <= pLicencImportFim NO-ERROR.
            IF  NOT AVAIL tt-licenciam-import-oc THEN 
                NEXT.
        END.

        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo cod-emitente) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

            FOR FIRST ITEM FIELDS(it-codigo ge-codigo fm-codigo descricao-1 un log-necessita-li ITEM.class-fiscal tipo-contr)
                WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
            END.
            IF AVAIL item THEN DO:
                ASSIGN c-it-codigo1 = item.it-codigo.

                IF p-fam-ini <> "" OR p-fam-fim <> "ZZZZZZZZ" THEN
                    IF item.fm-codigo < p-fam-ini OR item.fm-codigo > p-fam-fim  THEN
                        ASSIGN l-ok = NO.
                IF p-grupo-ini <> 0 OR p-grupo-fim <> 99 THEN
                    IF item.ge-codigo < p-grupo-ini OR item.ge-codigo > p-grupo-fim THEN
                        ASSIGN l-ok = NO.
                FOR FIRST cotacao-item FIELDS(cotacao-item.char-1)
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                      AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                      AND cotacao-item.cot-aprovada NO-LOCK:
                END.
                IF AVAIL cotacao-item THEN DO:
                    IF ITEM.tipo-contr = 4 THEN
                        ASSIGN c-class-fiscal = SUBSTRING(cotacao-item.char-1,81,20).
                    else
                        ASSIGN c-class-fiscal = ITEM.class-fiscal.
                END.    
                EMPTY TEMP-TABLE tt-licenc-import.

                FOR FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                    AND   prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK:


                    FIND FIRST licenciam-import-oc
                        WHERE licenciam-import-oc.numero-ordem = prazo-compra.numero-ordem
                        AND   licenciam-import-oc.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

                    CREATE tt-licenc-import.
                    ASSIGN tt-licenc-import.parcela        = prazo-compra.parcela
                    .
                    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                        ASSIGN cAuxTraducao001 = {ininc/i02in274.i 4 prazo-compra.situacao}.
                        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                            INPUT "",
                                            INPUT "").
                        ASSIGN tt-licenc-import.sit-parcela    = RETURN-VALUE.
                    &else
                        ASSIGN tt-licenc-import.sit-parcela    = {ininc/i02in274.i 4 prazo-compra.situacao}.
                    &endif
                    ASSIGN tt-licenc-import.licenca-import = IF AVAIL licenciam-import-oc THEN licenciam-import-oc.licenca-import
                                                             else "".
                    ASSIGN l-ok = YES.
                END.
            END.
        END.
        IF  tt-param.lDetalhaLi THEN DO:
            IF l-ok = YES 
            AND lImprime = YES THEN DO:
                disp c-li
                     c-lb-processo
                     c-lb-ordem   
                     c-lb-item    
                     c-lb-parc    
                     c-lb-sit-parc
                     c-lb-class-fiscal
                     c-lb-nec-li  
                     c-lb-nr-li   
                     with frame f-label-licenc-import.
                ASSIGN lImprime = NO.
            END.
        END.

        IF  tt-param.lDetalhaLi THEN DO:
            IF l-ok = YES THEN DO:
                FOR EACH tt-licenc-import:
                    PUT 
                        ordens-embarque.nr-proc-imp     AT 01
                        ordens-embarque.numero-ordem    AT 14
                        c-it-codigo1                    AT 24
                        tt-licenc-import.parcela        AT 41
                        tt-licenc-import.sit-parcela    AT 47
                        c-class-fiscal                  AT 67
                        item.log-necessita-li           AT 88
                        tt-licenc-import.licenca-import AT 101.
                END.                      
            END.
        END.

    END.                    
&ENDIF
END PROCEDURE.


PROCEDURE defineCodVeiculo :

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        DEF INPUT  PARAM pc-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
        DEF OUTPUT PARAM pl-mostra-placa AS LOG                     NO-UNDO.
    
        FOR FIRST eq-param-embarq FIELDS(idi-veic)
            WHERE eq-param-embarq.cod-estabel = pc-cod-estabel NO-LOCK: END.
    
        ASSIGN pl-mostra-placa =  AVAIL eq-param-embarq 
                                  AND eq-param-embarq.idi-veic = 1.
    
        RETURN "OK":U.

    &ENDIF

END PROCEDURE.

PROCEDURE piImprimeAntecipacao:
/*
** Procedure respons vel pela impressÆo das Antecipa‡äes vinculadas ao Embarque
*/
    IF CAN-FIND(FIRST antecip-import
                WHERE antecip-import.cod-estabel = tt-historico.cod-estabel
                  AND antecip-import.cod-embarq  = tt-historico.embarque) THEN
        DISP c-antecip
             c-lb-id           
             c-lb-est-ap       
             c-lb-espec-ap     
             c-lb-serie-ap     
             c-lb-titulo-ap
             c-lb-parc-ap      
             c-lb-refer-ap     
             c-lb-fornec-ap    
             c-lb-nome-abrev-ap
             c-lb-moeda-ap     
             c-lb-data-trans-ap
             c-lb-saldo-tit-ap 
             c-lb-vl-orig-ap   
             c-lb-cotac-tit-ap 
             c-lb-vl-vinc-emb  
             c-lb-dtm-criac    
             c-lb-usuar-criac  
             c-lb-serie-docto  
             c-lb-nro-docto    
             c-lb-emitente     
             c-lb-nome-abrev   
             c-lb-nat-oper     
             c-lb-vl-cotac     
             c-lb-dat-cotac    
             c-lb-vl-ifric22
        WITH FRAME f-lbl-antecip.

    FOR EACH antecip-import
       WHERE antecip-import.cod-estabel = tt-historico.cod-estabel 
         AND antecip-import.cod-embarq  = tt-historico.embarque    NO-LOCK
        BREAK BY antecip-import.cdd-id-antecip:

        FOR FIRST emitente FIELDS(nome-abrev)
            WHERE emitente.cod-emitente = antecip-import.cdn-emitente NO-LOCK:
        END.
        IF AVAIL emitente THEN
            ASSIGN c-nome-abrev-docto = emitente.nome-abrev.
        ELSE
            ASSIGN c-nome-abrev-docto = "":U.

            DISP antecip-import.cdd-id-antecip       
                 antecip-import.cod-estab-ap         
                 antecip-import.cod-espec-docto-ap   
                 antecip-import.cod-ser-docto-ap     
                 antecip-import.cod-tit-ap           
                 antecip-import.cod-parc-ap          
                 antecip-import.cod-refer-antecip-ap 
                 antecip-import.cdn-emitente-ap      
                 antecip-import.nom-abrev-ap         
                 antecip-import.cod-moed-ap          
                 antecip-import.dat-transacao        
                 antecip-import.val-sdo-tit-ap       
                 antecip-import.val-origin-tit-ap    
                 antecip-import.val-cotac-tit        
                 antecip-import.val-vinc-embarq      
                 antecip-import.dtm-criac            
                 antecip-import.cod-usuar-criac
                 WITH FRAME f-antecip.

            IF CAN-FIND(FIRST embarq-import-docto
                        WHERE embarq-import-docto.cod-estab        = antecip-import.cod-estabel
                          AND embarq-import-docto.cod-embarq       = antecip-import.cod-embarq
                          AND embarq-import-docto.cod-ser-docto    = antecip-import.serie-docto
                          AND embarq-import-docto.cod-docto        = antecip-import.nro-docto
                          AND embarq-import-docto.cdn-emitente     = antecip-import.cdn-emitente         
                          AND embarq-import-docto.cod-natur-operac = antecip-import.nat-operacao) THEN DO:
                /* Valor IFRIC-22 */
                ASSIGN de-valor-ifric22 = ((antecip-import.val-cotac-nacionaliz - antecip-import.val-cotac-tit) * antecip-import.val-vinc-embarq).
                DISP antecip-import.serie-docto          
                     antecip-import.nro-docto            
                     antecip-import.cdn-emitente         
                     c-nome-abrev-docto                  
                     antecip-import.nat-operacao         
                     antecip-import.val-cotac-nacionaliz 
                     antecip-import.dat-cotac-nacionaliz 
                     de-valor-ifric22
                    WITH FRAME f-antecip.
                
            END.
            DOWN WITH FRAME f-antecip.
    END.

    RETURN "OK":U.
END PROCEDURE.

RETURN 'OK'.






