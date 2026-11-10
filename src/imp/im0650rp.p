/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0650RP 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0650rp MIM}
&ENDIF

/********************************************************************************
**
**  IM0650RP.P - Relat¢rio Importa‡Æo
**
**  Objetivo: Listagem Posi‡Æo Processo Importa‡Æo
**
*********************************************************************************/
{cdp/cdcfgmat.i}
/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio ***************/
def temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-param NO-UNDO
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field l-tipo               as logical                 
    field i-atraso             as integer
    field i-situacao           as integer
    field da-data-ini          as date
    field da-data-fim          as date
    field c-est-ini            as char
    field c-est-fim            as char
    field c-proc-ini           as char
    field c-proc-fim           as char
    field i-exp-ini            as integer
    field i-exp-fim            as integer
    field i-itiner-ini         as integer
    field i-itiner-fim         as integer
    field i-pto-emb-ini        as integer
    field i-pto-emb-fim        as integer
    field i-pto-des-ini        as integer
    field i-pto-des-fim        as integer
    field i-local              as integer
    field i-grupo-ini          as integer
    field i-grupo-fim          as integer
    field c-fam-ini            as char
    field c-fam-fim            as char
    field c-item-ini           as char
    field c-item-fim           as char
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    field pto-solicita-li-ini  as integer
    field pto-solicita-li-fim  as integer
    field li-ini               as char
    field li-fim               as char
    field detalha-itens        as logical
    FIELD c-via-transp-par     AS CHAR FORMAT "x(16)"
    &endif.

    def temp-table tt-historico NO-UNDO like historico-proc-imp 
      field r-rowid        as rowid 
      field cod-exportador as integer format ">>>>>>>>9" 
      field c-situacao     as char format "x(19)"
      &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
      field pto-li         like itinerario.cdn-pto-solic-licenciam-import
      FIELD c-via-transp   AS CHAR FORMAT "x(16)"
      &endif.

    def buffer b-historico-proc-imp for historico-proc-imp.      


/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/

{utp/ut-glob.i}

/****************** FIM INCLUDE COM VARIÁVEIS GLOBAIS *********************/

/****************** Defini‡Æo de Parƒmetros do Relat¢rio *********************/ 

/****************** Defini‡Æo de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

def var  l-tipo        as logical                init yes                no-undo. /*resumido = yes / detalhado = no*/ 
def var  i-atraso      as integer                init 3                  no-undo.
def var  i-situacao    as integer                init 5                  no-undo.
def var  da-data-ini   as date format 99/99/9999 init &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF         no-undo.
def var  da-data-fim   as date format 99/99/9999 init 12/31/9999         no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var  c-est-ini     as char    format "x(05)"  init ""                 no-undo.
&ELSE
def var  c-est-ini     as char    format "x(3)"  init ""                 no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def var  c-est-fim     as char    format "x(05)"  init "ZZZZZ"              no-undo.
&ELSE
def var  c-est-fim     as char    format "x(3)"  init "ZZZ"              no-undo.
&ENDIF
def var  c-proc-ini    as char    format "x(12)" init ""                 no-undo.
def var  c-proc-fim    as char    format "x(12)" init "ZZZZZZZZZZZZ"     no-undo.
def var  i-exp-ini     as integer format ">>>>>>>>9" init 0              no-undo.
def var  i-exp-fim     as integer format ">>>>>>>>9" init 999999999      no-undo.
def var  i-itiner-ini  as integer format ">>>>9"     init 0              no-undo.
def var  i-itiner-fim  as integer format ">>>>9"     init 99999          no-undo.
def var  i-pto-emb-ini as integer format ">>>>9"     init 0              no-undo.
def var  i-pto-emb-fim as integer format ">>>>9"     init 99999          no-undo.
def var  i-pto-des-ini as integer format ">>>>9"     init 0              no-undo.
def var  i-pto-des-fim as integer format ">>>>9"     init 99999          no-undo.
def var  i-local       as integer format ">>>>9"     init 0              no-undo.
def var  i-grupo-ini   as integer                init 0                  no-undo.
def var  i-grupo-fim   as integer                init 99                 no-undo.
def var  c-fam-ini     as char    format "x(8)"  init ""                 no-undo.
def var  c-fam-fim     as char    format "x(8)"  init "ZZZZZZZZ"         no-undo.
def var  c-item-ini    as char    format "x(16)" init ""                 no-undo.
def var  c-item-fim    as char    format "x(16)" init "ZZZZZZZZZZZZZZZZ" no-undo.
def var  i-pto-chegada like itinerario.pto-chegada                       no-undo.
DEF VAR  i-via-transp  AS INT NO-UNDO.

&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ep-codigo-usuario  LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-ep-codigo-usuario  as integer no-undo.
&ENDIF
def var c-pto-emb            as char format "x(30)"  no-undo.
def var c-pto-des            as char format "x(30)"  no-undo.
def var i-pto-des            like itinerario.pto-desembarque format ">>,>>9" no-undo.
def var i-diferenca          as integer no-undo.
def var c-nome-abrev         as char format "x(12)"  no-undo.
def var c-sel                as char format "x(8)"   no-undo.
def var c-par                as char format "x(10)"  no-undo.
def var c-imp                as char format "x(10)"  no-undo.
def var c-destino            as char format "x(8)"   no-undo.
def var c-atraso             as char format "x(10)"  no-undo.
def var c-situacao           as char format "x(20)"  no-undo.
def var c-descricao          as char format "x(30)"  no-undo.

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then

{cxbo/bocx351.i tt-licenciam-import-oc}

define temp-table tt-detalhe no-undo
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel      as character format "x(05)":U
&ELSE
    field cod-estabel      as character format "x(3)":U
&ENDIF
    field nr-proc-imp      like processo-imp.nr-proc-imp
    field numero-ordem     like ordem-compra.numero-ordem
    field parcela          like prazo-compra.parcela
    field situacao         as character format "x(16)":U
    field it-codigo        like item.it-codigo
    field class-fiscal     like item.class-fiscal
    field log-necessita-li like item.log-necessita-li
    field licenca-import   like licenciam-import-oc.licenca-import
    index codigo is primary unique
        cod-estabel
        nr-proc-imp
        numero-ordem
        parcela.

define variable i-pto-li             like itinerario.cdn-pto-solic-licenciam-import no-undo.
define variable i-pto-solic-li-ini   as integer format ">>>>9"     init 0           no-undo. 
define variable i-pto-solic-li-fim   as integer format ">>>>9"     init 99999       no-undo. 
define variable c-li-ini             like licenciam-import-oc.licenca-import        no-undo.
define variable c-li-fim             like licenciam-import-oc.licenca-import        no-undo.
define variable c-desc-pto-solic-li  as character format "x(30)":U                  no-undo.
define variable c-classif-fisc       like item.class-fiscal                         no-undo.
define variable l-detalha-itens      as logical                                     no-undo.
define variable l-ok                 as logical                                     no-undo.
define variable h-bocx351            as handle                                      no-undo.

&endif

/****************** Defini‡Æo de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

/****************** Defini‡Æo de Vari veis Campo do Layout do Relat¢rio **********************/ 
def var l-pto-desembarque as char format "x(20)" no-undo.

/****************** Defini‡Æo de Vari veis do Relat¢rio NÆo Pedidas em Tela ******************/ 

def var c-lit1 as char format "x(3)".
def var c-lit2 as char format "x(9)".
def var c-lit3 as char format "x(9)".
def var c-lit4 as char format "x(8)".
def var c-lit5 as char format "x(15)".
def var c-lit6 as char format "x(7)".
def var c-lit7 as char format "x(9)".
def var c-lit8 as char format "x(14)".
def VAR l-item          as logical no-undo.
def var l-grupo-item    as logical no-undo.
def var l-familia-item  as logical no-undo.
def var l-faixa-item    as logical no-undo.
def var l-faixa-grupo   as logical no-undo.
def var l-faixa-fam     as logical no-undo.

/****************** Defini‡Æo de Vari veis de Total do Relat¢rio *****************************/ 

/****************** Defini‡Æo de Vari veis dos C lculos do Relat¢rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini‡Æo de Vari veis de Processamento do Relat¢rio *********************/

def var h-acomp              as handle no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.
def var v-num-linha          as int    no-undo.


/****************** Defini‡Æo de Forms do Relat¢rio 132 Colunas ***************************************/ 

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then

form
    tt-detalhe.numero-ordem         at  1 format "zzzzz9,99":U
    tt-detalhe.parcela              at 11 format ">>>>9":U
    tt-detalhe.situacao             at 17 format "x(19)":U      column-label "Situa‡Æo da Parcela"
    tt-detalhe.it-codigo            at 37 format "x(16)":U
    tt-detalhe.class-fiscal         at 54 format "9999.99.99":U column-label "Class Fiscal"
    tt-detalhe.log-necessita-li     at 67 format "Sim/NÆo"
    tt-detalhe.licenca-import       at 80 format "x(20)":U      column-label "Nr LI"
    with stream-io no-box width 132 64 down frame f-detalhe.

run utp/ut-trfrrp.p (input frame f-detalhe:handle).

&endif

form 
     skip(5)
     tt-historico.cod-estabel    colon 25 
     tt-historico.nr-proc-imp     
     tt-historico.c-situacao     colon 85 skip
     tt-historico.cod-exportador colon 25
     " - " c-nome-abrev          no-label 
     tt-historico.cod-itiner     colon 85
     " - " itinerario.descricao  no-label skip
     tt-historico.c-via-transp   COLON 25 SKIP
     &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
     
     tt-historico.pto-li         colon 25 
     " - ":U c-desc-pto-solic-li no-label
     itinerario.pto-embarque     colon 85
     " - ":U c-pto-emb           no-label skip
     i-pto-des                   colon 25 
     " - ":U c-pto-des           no-label  skip(3)

     &else
     
     itinerario.pto-embarque     colon 25
     " - " c-pto-emb             no-label 
     i-pto-des                   colon 85 
     " - " c-pto-des             no-label  skip(3)

     &endif
     with side-labels width 132 no-box stream-io frame f-relat1.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relat1:HANDLE).


DO:
form 
     historico-proc-imp.sequencia       at 1
     historico-proc-imp.cod-pto-contr   at 5
     c-descricao                        at 15
     historico-proc-imp.dt-previsao     at 46 
     historico-proc-imp.dt-ult-previsao at 57
     historico-proc-imp.dt-efetiva      at 68
     i-diferenca                        at 79
     historico-proc-imp.id-meio-transp  at 91  
     with down width 132 no-box stream-io frame f-relat2.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relat2:HANDLE).

END. 

form
    tt-historico.cod-estabel    at 1
    tt-historico.nr-proc-imp    space(1)
    tt-historico.cod-exportador space(1)
    tt-historico.cod-itiner     space(1)
    itinerario.descricao        space(1) 
    tt-historico.c-via-transp   space(1)
    itinerario.pto-embarque     space(1)
    itinerario.pto-desembarque  space(1)
    tt-historico.c-situacao     space(1)
    with stream-io no-box width 132 64 down frame f-relat3.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relat3:HANDLE).


form 
/*Sele‡Æo*/
     skip(1)                                   
     c-sel                                     no-label
     skip(1)
     i-local                                   colon 30
     skip
     da-data-ini                               colon 30
     "|< >|"                                      at 55
     da-data-fim                               no-label
     c-est-ini                                 colon 30
     "|< >|"                                      at 55
     c-est-fim                                 no-label
     c-proc-ini                                colon 30
     "|< >|"                                      at 55
     c-proc-fim                                no-label 
     i-exp-ini                                 colon 30
     "|< >|"                                      at 55
     i-exp-fim                                 no-label
     i-itiner-ini                              colon 30
     "|< >|"                                      at 55
     i-itiner-fim                              no-label
     &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
     i-pto-solic-li-ini                        colon 30
     "|< >|":U                                    at 55
     i-pto-solic-li-fim                        no-label
     &endif
     i-pto-emb-ini                             colon 30
     "|< >|"                                      at 55
     i-pto-emb-fim                             no-label
     i-pto-des-ini                             colon 30
     "|< >|"                                      at 55
     i-pto-des-fim                             no-label
     i-grupo-ini                               colon 30
     "|< >|"                                      at 55
     i-grupo-fim                               no-label
     c-fam-ini                                 colon 30
     "|< >|"                                      at 55
     c-fam-fim                                 no-label
     c-item-ini                                colon 30
     "|< >|"                                      at 55
     c-item-fim                                no-label
     &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
     c-li-ini                                  colon 30
     "|< >|":U                                    at 55
     c-li-fim                                  no-label
     &endif
/*parƒmetros*/
     skip(1)      
     c-par                                    no-label   
     skip(1)
     c-situacao                               colon 30 skip
     c-atraso                                 colon 30 skip
     l-tipo                                   colon 30 skip
     c-via-transp-par                         colon 30
     &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
     skip
     l-detalha-itens                          colon 30
     &endif
/*impressÆo*/
     skip(1)
     c-imp                                     no-label
     skip(1)
     c-destino                                colon 30 "-"
     tt-param.arquivo no-label
     tt-param.usuario
     skip(1)
     with width 132 side-labels frame f-param stream-io. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).
   

/************************* Definições de Labels ****************************/

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then

{utp/ut-liter.i Ponto_Solicita_LI * r}
assign i-pto-solic-li-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Licenciamento_Importa‡Æo * r}
assign c-li-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Detalha_Itens_do_Processo * r}
assign l-detalha-itens:label in frame f-param = trim(return-value).   

{utp/ut-liter.i Sim/NÆo * r}
assign l-detalha-itens:format in frame f-param = trim(return-value).   

{utp/ut-liter.i Sim/NÆo * r}
assign tt-detalhe.log-necessita-li:format in frame f-detalhe = trim(return-value).   

&endif

{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-param = trim(return-value).
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-param = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
assign c-sel = return-value.
{utp/ut-liter.i PAR¶METROS * r}
assign c-par = return-value.
{utp/ut-liter.i IMPRESSÇO * r}  
assign c-imp = return-value.
{utp/ut-liter.i Data_Chegada * r}
assign da-data-ini:label in frame f-param = trim(return-value).
{utp/ut-liter.i Via_Transporte * r}
assign c-via-transp-par:label in frame f-param = trim(return-value).
{utp/ut-field.i mgcex historico-proc-imp cod-estabel 1}
assign c-est-ini:label in frame f-param = trim(return-value).
{utp/ut-field.i mgcex historico-proc-imp nr-proc-imp 1}
assign c-proc-ini:label in frame f-param = trim(return-value).
{utp/ut-liter.i Fornecedor * r}
assign i-exp-ini:label in frame f-param = trim(return-value).
{utp/ut-field.i mgcex itinerario cod-itiner 1}
assign i-itiner-ini:label in frame f-param = trim(return-value).
{utp/ut-field.i mgcex itinerario pto-embarque 1}
assign i-pto-emb-ini:label in frame f-param = trim(return-value).
/*{utp/ut-field.i mgcex itinerario pto-desembarque 1}*/
{utp/ut-liter.i Ponto_Nacionaliza‡Æo * r}
assign i-pto-des-ini:label in frame f-param = trim(return-value).
{utp/ut-liter.i Localiza‡Æo * r}
assign i-local:label in frame f-param = trim(return-value).
{utp/ut-field.i mgind item ge-codigo 1}
assign i-grupo-ini:label in frame f-param = trim(return-value).
{utp/ut-field.i mgind item fm-codigo 1}
assign c-fam-ini:label in frame f-param = trim(return-value).
{utp/ut-field.i mgind item it-codigo 1}
assign c-item-ini:label in frame f-param = trim(return-value).
{utp/ut-liter.i Op‡Æo * r}
assign l-tipo:label in frame f-param = trim(return-value).
{utp/ut-liter.i Processos * r}
assign c-atraso:label in frame f-param = trim(return-value).
{utp/ut-liter.i Situa‡Æo * r}
assign c-situacao:label in frame f-param = trim(return-value).
/*{utp/ut-liter.i Estabel * r}
assign historico-proc-imp.cod-estabel:label in frame f-relat1 = trim(return-value).*/
{utp/ut-liter.i Nr_Processo * r}
assign tt-historico.nr-proc-imp:label in frame f-relat1 = trim(return-value).
{utp/ut-liter.i Fornecedor * r}
assign tt-historico.cod-exportador:label in frame f-relat1 = trim(return-value).
{utp/ut-liter.i Fornecedor * r}
assign tt-historico.cod-exportador:label in frame f-relat3 = trim(return-value).
{utp/ut-liter.i Situa‡Æo * r}
assign tt-historico.c-situacao:label in frame f-relat1 = trim(return-value).
{utp/ut-liter.i Diferen‡a * r}
assign i-diferenca:label in frame f-relat2 = trim(return-value).
{utp/ut-liter.i Situa‡Æo * r}
assign tt-historico.c-situacao:label in frame f-relat3 = trim(return-value).
{utp/ut-liter.i Via_Transporte * r}
assign tt-historico.c-via-transp:label in frame f-relat1 = trim(return-value).
{utp/ut-liter.i Via_Transporte * r}
assign tt-historico.c-via-transp:label in frame f-relat3 = trim(return-value).
{utp/ut-liter.i Descri‡Æo * r}
assign c-descricao:label in frame f-relat2 = trim(return-value).
{utp/ut-liter.i Ponto_Nacionaliza‡Æo * r}
assign i-pto-des:label in frame f-relat1 = trim(return-value).

create tt-param.
raw-transfer raw-param to tt-param.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

{include/i-rpvar.i}

assign c-programa     = "im0650"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Listagem Posi‡äes Processo Importa‡Æo"
       c-sistema      = "Com‚rcio Exterior".

{include/i-rpcab.i}

{cdp/cd-rpout.i}   /* include customizada Comex */
view frame f-cabec.
view frame f-rodape.

    assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.

    assign l-tipo          = tt-param.l-tipo
           i-atraso        = tt-param.i-atraso
           i-situacao      = tt-param.i-situacao
           da-data-ini     = tt-param.da-data-ini
           da-data-fim     = tt-param.da-data-fim
           c-est-ini       = tt-param.c-est-ini
           c-est-fim       = tt-param.c-est-fim
           c-proc-ini      = tt-param.c-proc-ini
           c-proc-fim      = tt-param.c-proc-fim
           i-exp-ini       = tt-param.i-exp-ini
           i-exp-fim       = tt-param.i-exp-fim
           i-itiner-ini    = tt-param.i-itiner-ini
           i-itiner-fim    = tt-param.i-itiner-fim
           i-pto-emb-ini   = tt-param.i-pto-emb-ini
           i-pto-emb-fim   = tt-param.i-pto-emb-fim
           i-pto-des-ini   = tt-param.i-pto-des-ini
           i-pto-des-fim   = tt-param.i-pto-des-fim
           i-local         = tt-param.i-local
           i-grupo-ini     = tt-param.i-grupo-ini
           i-grupo-fim     = tt-param.i-grupo-fim
           c-fam-ini       = tt-param.c-fam-ini
           c-fam-fim       = tt-param.c-fam-fim
           c-item-ini      = tt-param.c-item-ini
           c-item-fim      = tt-param.c-item-fim
           c-destino       = {varinc/var00002.i 04 tt-param.destino}
           &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
           i-pto-solic-li-ini = tt-param.pto-solicita-li-ini
           i-pto-solic-li-fim = tt-param.pto-solicita-li-fim
           c-li-ini           = tt-param.li-ini             
           c-li-fim           = tt-param.li-fim             
           l-detalha-itens    = tt-param.detalha-itens      
           i-via-transp       = {adinc/i01ad268.i 06 tt-param.c-via-transp-par}
           &endif.

           if   tt-param.i-situacao <> 5 then
                assign c-situacao      = {cxinc/i01cx140.i 04 i-situacao}.
           else do:
                {utp/ut-liter.i Todos * r}
                assign c-situacao = trim(return-value).
           end.

if  i-atraso = 1 then do:
    {utp/ut-liter.i Atrasados}
    assign c-atraso = trim(return-value).
end.    
else if i-atraso = 2 then do:    
        {utp/ut-liter.i Adiantados}
        assign c-atraso = trim(return-value).
     end.
     else do:
          {utp/ut-liter.i Todos}
          assign c-atraso = trim(return-value).
     end.     

{utp/ut-liter.i Resumido/Detalhado * r}
assign l-tipo:format in frame f-param = trim(return-value).    

/*run utp/ut-acomp.p persistent set h-acomp.*/

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

/*run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp(input "Acompanhamento Relat¢rio").*/

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
if  not valid-handle (h-bocx351) then 
    run cxbo/bocx351.p persistent set h-bocx351.
&endif

assign v-num-reg-lidos = 0.

for each processo-imp where 
         processo-imp.cod-estabel    >= c-est-ini    and
         processo-imp.cod-estabel    <= c-est-fim    and
         processo-imp.nr-proc-imp    >= c-proc-ini   and
         processo-imp.nr-proc-imp    <= c-proc-fim   no-lock:

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    assign l-ok = no.
    &endif
    
    if   i-itiner-ini <> 0 or i-itiner-fim <> 99999 then do:
         if   processo-imp.cod-itiner     < i-itiner-ini or
              processo-imp.cod-itiner     > i-itiner-fim then
              next.
    end.          
    if   i-exp-ini <> 0 or i-exp-fim <> 999999999 then do:
         if   processo-imp.cod-exportador < i-exp-ini or
              processo-imp.cod-exportador > i-exp-fim then
              next.
    end.

    if   i-situacao <> 5 then do: /* sujeito a mudanças */
         if   processo-imp.situacao <> i-situacao then
              next.
    end.          

    /*Via Transporte*/
    IF i-via-transp >= 1 THEN DO:
        IF processo-imp.via-transp <> i-via-transp THEN
            NEXT.
    END.

    assign i-pto-chegada = 0
           &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
           i-pto-li      = 0
           &endif.
           
    find itinerario where 
         itinerario.cod-itiner = processo-imp.cod-itiner no-lock no-error.
    if   avail itinerario then
         assign i-pto-chegada = itinerario.pto-chegada
                &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
                i-pto-li      = itinerario.cdn-pto-solic-licenciam-import
                &endif.

    if  i-pto-emb-ini <> 0     
    or  i-pto-emb-fim <> 99999 
    or  i-pto-des-ini <> 0     
    or  i-pto-des-fim <> 99999
    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
    or  i-pto-solic-li-ini <> 0
    or  i-pto-solic-li-fim <> 99999
    &endif then do:
        if   avail itinerario then do:     
            
             assign i-pto-chegada = itinerario.pto-chegada.

             if  itinerario.pto-embarque < i-pto-emb-ini
             or  itinerario.pto-embarque > i-pto-emb-fim then
                 next.
             
             if  itinerario.pto-desembarque < i-pto-des-ini
             or  itinerario.pto-desembarque > i-pto-des-fim then
                 next.

             /* Licenciamento Importacao */
             &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
             if  itinerario.cdn-pto-solic-licenciam-import < i-pto-solic-li-ini
             or  itinerario.cdn-pto-solic-licenciam-import > i-pto-solic-li-fim then
                 next.
             &endif.
        end.
    end.            

    find first historico-proc-imp where 
               historico-proc-imp.cod-estabel = processo-imp.cod-estabel and
               historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp and 
               historico-proc-imp.cod-itiner  = processo-imp.cod-itiner  no-lock no-error.
    if   avail historico-proc-imp then do:           

         /* Licenciamento Importacao */
         &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
            
         find first b-historico-proc-imp
             where b-historico-proc-imp.cod-estabel   = historico-proc-imp.cod-estabel 
             and   b-historico-proc-imp.nr-proc-imp   = historico-proc-imp.nr-proc-imp 
             and   b-historico-proc-imp.cod-itiner    = historico-proc-imp.cod-itiner  
             and   b-historico-proc-imp.cod-pto-contr = i-pto-li no-lock no-error.
         
         if  not avail b-historico-proc-imp then do:

             assign i-pto-li = 0.

             if  i-pto-solic-li-ini <> 0
             or  i-pto-solic-li-fim <> 99999 then
                next.
         end.

         &endif

        find first  b-historico-proc-imp where 
                    b-historico-proc-imp.cod-estabel   = historico-proc-imp.cod-estabel and
                    b-historico-proc-imp.nr-proc-imp   = historico-proc-imp.nr-proc-imp and
                    b-historico-proc-imp.cod-itiner    = historico-proc-imp.cod-itiner  and
                    b-historico-proc-imp.cod-pto-contr = i-pto-chegada no-lock no-error.

        if not avail b-historico-proc-imp then next.

        if  b-historico-proc-imp.dt-efetiva <> ? then do: 
              if   b-historico-proc-imp.dt-efetiva < da-data-ini or
                   b-historico-proc-imp.dt-efetiva > da-data-fim then
                   next.
              if   i-atraso = 1 and
                   b-historico-proc-imp.dt-efetiva <= b-historico-proc-imp.dt-previsao then
                   next.
              else if  i-atraso = 2  and
                       b-historico-proc-imp.dt-efetiva >= b-historico-proc-imp.dt-previsao then
                       next.       
        end.
        else do:
             if   b-historico-proc-imp.dt-ult-previsao < da-data-ini or
                  b-historico-proc-imp.dt-ult-previsao > da-data-fim then 
                  next.
                  if   i-atraso = 1 and
                       b-historico-proc-imp.dt-ult-previsao <= b-historico-proc-imp.dt-previsao then
                       next.
                  else if  i-atraso = 2 and
                       b-historico-proc-imp.dt-ult-previsao >= b-historico-proc-imp.dt-previsao then
                       next.      
        end.
        if  i-local <> 0 then do:     
            find last b-historico-proc-imp where 
                      b-historico-proc-imp.cod-estabel = historico-proc-imp.cod-estabel and
                      b-historico-proc-imp.nr-proc-imp = historico-proc-imp.nr-proc-imp and
                      b-historico-proc-imp.cod-itiner  = historico-proc-imp.cod-itiner  and
                      b-historico-proc-imp.dt-efetiva  <> ?                                                    
                      no-lock no-error.
            if  avail b-historico-proc-imp then do:
                if    b-historico-proc-imp.cod-pto-contr <> i-local then 
                      next.
            end.
        end.

        ASSIGN l-item          =  NO
               l-grupo-item    =  NO
               l-familia-item  =  NO.

        FOR EACH ordem-compra FIELDS(num-pedido numero-ordem it-codigo)
            where ordem-compra.num-pedido  = processo-imp.num-pedido NO-LOCK:

            FOR FIRST ITEM FIELDS(it-codigo ge-codigo fm-codigo descricao-1 un tipo-contr class-fiscal
                                  &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
                                  log-necessita-li
                                  &endif)
                WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

            if  c-item-ini <> "" or
                c-item-fim <> "zzzzzzzzzzzzzzzz" then do:
                ASSIGN l-faixa-item = YES.
                IF AVAIL ITEM THEN DO:
                    IF ITEM.it-codigo >= c-item-ini AND
                       ITEM.it-codigo <= c-item-fim THEN
                    ASSIGN l-item = YES.
                END.
            end.

            if  i-grupo-ini <> 0  or
                i-grupo-fim <> 99 THEN DO:
                ASSIGN l-faixa-grupo = YES.
                if avail item then do:
                   if item.ge-codigo >= i-grupo-ini AND
                      item.ge-codigo <= i-grupo-fim then 
                      ASSIGN l-grupo-item = YES.
                end.
            end.

            IF c-fam-ini <> ""   or
               c-fam-fim <> "zzzzzzzz" then do:
                ASSIGN l-faixa-fam = YES.
                IF AVAIL ITEM THEN DO:
                    if item.fm-codigo >= c-fam-ini AND
                       item.fm-codigo <= c-fam-fim then
                       ASSIGN l-familia-item = YES.
                END.
            END.

            /* Licenciamento Importacao */
            &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
            
            if  c-li-ini <> "":U
            or  c-li-fim <> "ZZZZZZZZZZZZZZZZZZZZ":U then do:

                run piRetornaLI in h-bocx351 (input 1,
                                              input yes,
                                              input ordem-compra.num-pedido,
                                              input ?,
                                              input ?,
                                              input ?,
                                              input yes,
                                              input yes,
                                              input ordem-compra.numero-ordem,
                                              input ordem-compra.numero-ordem,
                                              input ordem-compra.it-codigo,
                                              input ordem-compra.it-codigo,
                                              input " ":U,
                                              input "ZZZZZZZZ":U,
                                              input " ":U,
                                              input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                              output table tt-licenciam-import-oc).

                if  can-find (first tt-licenciam-import-oc
                              where tt-licenciam-import-oc.licenca-import >= c-li-ini
                              and   tt-licenciam-import-oc.licenca-import <= c-li-fim) then
                    assign l-ok = yes.
            end.
            else
                assign l-ok = yes.

            if  l-detalha-itens 
            and l-ok then do:
            
                assign c-classif-fisc = "".

                for first cotacao-item fields (char-1)
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    and   cotacao-item.cod-emitente = processo-imp.cod-exportador
                    and   cotacao-item.it-codigo    = item.it-codigo
                    and   cotacao-item.cot-aprovada no-lock: end.
                if  avail cotacao-item then do:

                    if  item.tipo-contr = 4 then /* debito direto */
                        assign c-classif-fisc = substr(cotacao-item.char-1,81,20).
                    else
                        assign c-classif-fisc = item.class-fiscal.
                end.
            
                for each prazo-compra fields (parcela situacao)
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
    
                    if  (    c-li-ini <> "":U                     
                         or  c-li-fim <> "ZZZZZZZZZZZZZZZZZZZZ":U
                         and can-find (first tt-licenciam-import-oc
                                       where tt-licenciam-import-oc.licenca-import >= c-li-ini
                                       and   tt-licenciam-import-oc.licenca-import <= c-li-fim))
                    or  (    c-li-ini = "":U
                         and c-li-fim = "ZZZZZZZZZZZZZZZZZZZZ":U) then do:

                        for first licenciam-import-oc fields (licenca-import)
                            where licenciam-import-oc.numero-ordem = ordem-compra.numero-ordem
                            and   licenciam-import-oc.parcela      = prazo-compra.parcela no-lock: end.

                        create tt-detalhe.
                        assign tt-detalhe.cod-estabel      = processo-imp.cod-estabel
                               tt-detalhe.nr-proc-imp      = processo-imp.nr-proc-imp
                               tt-detalhe.numero-ordem     = ordem-compra.numero-ordem
                               tt-detalhe.parcela          = prazo-compra.parcela
                               tt-detalhe.it-codigo        = ordem-compra.it-codigo
                               tt-detalhe.log-necessita-li = item.log-necessita-li
                               tt-detalhe.class-fiscal     = c-classif-fisc
                               tt-detalhe.licenca-import   = if  not avail licenciam-import-oc then ""
                                                             else licenciam-import-oc.licenca-import.
        
                        run utp/ut-liter.p (input {ininc/i02in274.i 04 prazo-compra.situacao},
                                            input "",
                                            input "").
                        assign tt-detalhe.situacao = return-value.
                    end.
                end.
            end.

            &endif
            
        END.

        IF (l-faixa-item = YES OR l-faixa-grupo = YES OR l-faixa-fam = YES) THEN
            IF (l-item = NO AND l-grupo-item = NO AND l-familia-item = NO) THEN NEXT.

        /* Licenciamento Importacao */
        &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
        
        if  not l-ok then
            next.

        &endif

        create tt-historico.
        buffer-copy historico-proc-imp to tt-historico.
        assign tt-historico.r-rowid        = rowid(historico-proc-imp)
               tt-historico.c-situacao     = {cxinc/i01cx140.i 04 processo-imp.situacao}
               tt-historico.cod-exportador = processo-imp.cod-exportador
               &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
               tt-historico.pto-li         = i-pto-li
               &endif
               tt-historico.c-via-transp   = {adinc/i01ad268.i 04 processo-imp.via-transp}
               .
    end.
end.

/*run pi-acompanhar in h-acomp(input string(v-num-reg-lidos)).*/

if  l-tipo = yes then do:

    for each tt-historico break by tt-historico.cod-estabel
                                  by tt-historico.nr-proc-imp:
        disp  tt-historico.cod-estabel
              tt-historico.nr-proc-imp
              tt-historico.cod-exportador
              tt-historico.cod-itiner
              tt-historico.c-via-transp
              with frame f-relat3.
        find itinerario where 
              itinerario.cod-itiner = tt-historico.cod-itiner no-lock no-error.

        if    avail itinerario then do:
              disp  itinerario.descricao
                    itinerario.pto-embarque
                    itinerario.pto-desembarque  with frame f-relat3.
        end.      
        disp  tt-historico.c-situacao
              with frame f-relat3.
        down with frame f-relat3.     
     end.
     if line-counter >= 63 then
        page.
end.
else do:
     for  each tt-historico break by tt-historico.cod-estabel
                                  by tt-historico.nr-proc-imp:
          find itinerario where 
               itinerario.cod-itiner = tt-historico.cod-itiner no-lock no-error.
          if   avail itinerario then do:

               find pto-contr where 
                    pto-contr.cod-pto-contr = itinerario.pto-embarque no-lock no-error.
               if  avail pto-contr then 
                   assign c-pto-emb = pto-contr.descricao.

               find pto-contr where
                    pto-contr.cod-pto-contr = itinerario.pto-desembarque no-lock no-error.
               if  avail pto-contr then
                   assign c-pto-des = pto-contr.descricao.

               /* Licenciamento Importacao */
               &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
               
               find pto-contr
                   where pto-contr.cod-pto-contr = tt-historico.pto-li no-lock no-error.
               if  avail pto-contr then
                   assign c-desc-pto-solic-li = pto-contr.descricao.
               else
                   assign c-desc-pto-solic-li = "". 

               &endif

               find emitente where emitente.cod-emitente = tt-historico.cod-exportador no-lock no-error.
               if   avail emitente then 
                    assign c-nome-abrev = emitente.nome-abrev. 
               assign i-pto-des = itinerario.pto-desembarque.

               disp tt-historico.cod-estabel
                    tt-historico.nr-proc-imp
                    tt-historico.c-situacao
                    tt-historico.cod-exportador
                    c-nome-abrev
                    tt-historico.cod-itiner
                    itinerario.descricao
                    tt-historico.c-via-transp
                    itinerario.pto-embarque
                    c-pto-emb
                    i-pto-des
                    c-pto-des
                    &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
                    tt-historico.pto-li
                    c-desc-pto-solic-li
                    &endif
                    with frame f-relat1.
          end. 
          for each historico-proc-imp where
                   historico-proc-imp.cod-estabel = tt-historico.cod-estabel and 
                   historico-proc-imp.nr-proc-imp = tt-historico.nr-proc-imp and
                   historico-proc-imp.cod-itiner  = tt-historico.cod-itiner no-lock         
                   break by historico-proc-imp.sequencia:
              disp historico-proc-imp.sequencia
                   historico-proc-imp.cod-pto-contr 
                   with frame f-relat2.
              find pto-contr where
                   pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr no-lock no-error.
              if   avail pto-contr then
                   assign c-descricao = pto-contr.descricao.           
              disp historico-proc-imp.dt-previsao
                   historico-proc-imp.dt-ult-previsao
                   historico-proc-imp.dt-efetiva
                   with frame f-relat2.
              if   historico-proc-imp.dt-efetiva <> ? then 
                   assign i-diferenca = 
                          historico-proc-imp.dt-efetiva - historico-proc-imp.dt-previsao.     
              else assign i-diferenca =
                          historico-proc-imp.dt-ult-previsao - historico-proc-imp.dt-previsao.
              disp i-diferenca 
                   historico-proc-imp.id-meio-transp 
                   c-descricao with frame f-relat2.
              down with frame f-relat2.     
          end. 

          /* Licenciamento Importacao */ 
          &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
          
          if  first-of (tt-historico.cod-estabel) 
          or  first-of (tt-historico.nr-proc-imp) then 

              put skip (2).
              for each  tt-detalhe 
                  where tt-detalhe.cod-estabel = tt-historico.cod-estabel
                  and   tt-detalhe.nr-proc-imp = tt-historico.nr-proc-imp:

                  disp tt-detalhe.numero-ordem     
                       tt-detalhe.parcela          
                       tt-detalhe.situacao         
                       tt-detalhe.it-codigo        
                       tt-detalhe.class-fiscal     
                       tt-detalhe.log-necessita-li 
                       tt-detalhe.licenca-import with frame f-detalhe.
                  down with frame f-detalhe.
              end.

          &endif

          if  line-counter >= 63 then
              page.

     end.

end. 


page. 

disp c-sel  
     i-local
     da-data-ini
     da-data-fim
     c-est-ini
     c-est-fim
     c-proc-ini
     c-proc-fim
     i-exp-ini
     i-exp-fim
     i-itiner-ini
     i-itiner-fim
     i-pto-emb-ini
     i-pto-emb-fim
     i-pto-des-ini
     i-pto-des-fim
     i-grupo-ini
     i-grupo-fim
     c-fam-ini
     c-fam-fim
     c-item-ini
     c-item-fim
     c-par
     c-situacao
     c-atraso
     l-tipo
     c-imp 
     c-destino                           
     tt-param.arquivo
     tt-param.usuario
     &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
     i-pto-solic-li-ini 
     i-pto-solic-li-fim 
     c-li-ini           
     c-li-fim           
     l-detalha-itens    
     c-via-transp-par
     &endif
     with frame f-param.

&if '{&bf_mat_versao_ems}':U >= '2.062':U  &then

if  valid-handle (h-bocx351) then do:
    delete procedure h-bocx351.
    assign h-bocx351 = ?.
end.

&endif
/*run pi-finalizar in h-acomp.*/

{include/i-rpclo.i}

return 'OK'.

