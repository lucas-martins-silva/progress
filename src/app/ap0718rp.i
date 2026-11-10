/*********************************************************************
***
*** app/ap0718.i1 - Defini‡Æo Variaveis, Form's ...
***
*********************************************************************/
/* y2kready */

def buffer b-tit-ap for tit-ap.

/*--------- Variaveis serÆo atualizados conforme tt-param ----------*/
def var i-for-ini       like emitente.cod-emit format "zzzzzzzz9" no-undo.
def var i-for-fim       like emitente.cod-emit format "zzzzzzzz9" init 999999999 no-undo.
def var i-ano-base      as integer format "9999"               no-undo.
def var c-estabel       like estabelec.cod-estabel             no-undo.
def var c-responsavel   as char format "x(40)"                 no-undo.
def var c-complemento1  as char format "x(110)"                no-undo.
def var l-natureza      as logical format "Sim/NÆo" init yes   no-undo.
def var da-entrega      as date format "99/99/9999" init today no-undo.
/*-------------------------------------------------------------------*/

def var c-meses         as character extent 12 init
    ["Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"].

def var c-cidade        like emitente.cidade                     no-undo.
def var c-moeda         as character format "x(14)" extent 10    no-undo.
def var c-nome-moeda    as character format "x(14)"              no-undo.
def var c-pos-cgc       as character format "x" extent 19        no-undo.
def var c-cgc-format    as character format "x" extent 19        no-undo.
def var c-cgc           like emitente.cgc                        no-undo.
def var c-mes           as character format "x(03)"              no-undo.
def var c-natur-rend    as character format "x(42)"              no-undo.
def var c-opcao         as character                             no-undo.

def var de-aliquota     as decimal decimals 2                    no-undo.
def var de-rend-bruto   as decimal                               no-undo.
def var de-irrf         as decimal                               no-undo.
def var de-rend-ano     as decimal                               no-undo.
def var de-rend-1994    as decimal                               no-undo.
def var de-irrf-ano     as decimal                               no-undo.
def var de-irrf-1994    as decimal                               no-undo.
def var de-cot-dest     as decimal init 1                        no-undo.
def var de-rend-mes     as decimal                               no-undo.
def var de-irrf-mes     as decimal                               no-undo.
def var da-ta-ini       as date format "99/99/9999"              no-undo.
def var da-ta-fim       as date format "99/99/9999"              no-undo.
def var da-ta-conv      as date                                  no-undo.
def var da-cotacao      as date                                  no-undo.

def var i-dia-mes       as integer                               no-undo.
def var i-moeda         as integer format "9" init 0             no-undo.
def var i-fornec        like emitente.cod-emit format "zzzzzzzz9" no-undo.
def var i-empresa       like empresa.ep-codigo                   no-undo.
def var i-cod-ir        as integer                               no-undo.
def var i-nr-docto      as integer format ">,>>>" init 1         no-undo.
def var i-posicao       as integer                               no-undo.
def var i-cont          as integer                               no-undo.
def var i-cont2         as integer                               no-undo.
def var i-cont-mes      as integer                               no-undo.
def var i-cod-rend      like dirf-ap.cod-retensao                no-undo.
DEF VAR i-tipo-emit     AS INTEGER                               NO-UNDO.
def var i-tipo          as integer                               no-undo.
def var i-ir-pis        as integer                               no-undo.

def var l-param    as logical                                    no-undo.
def var l-moeda    as logical format "(CR$-R$)/ - R$ -" init yes no-undo.
def var l-moeda2   as logical format "(CR$-R$)/ - R$ -" init yes no-undo.

DEF VAR c-ano-base AS CHAR FORMAT "x(21)" NO-UNDO. 


def var h-acomp as handle no-undo.

def temp-table wf-inf-rend
    field  wf-i-fornec      as integer
    field  wf-i-mes         as integer
    field  wf-i-cod-ir      as integer
    field  wf-de-rend-bruto as decimal
    field  wf-de-ir-retido  as decimal
    field  wf-de-aliquota   as decimal decimals 2.

form
   "+----------------------------------------------------------------" space(0)
   "+----------------------------------------------------------------+" skip
   "|  M I N I S T E R I O    D A    F A Z E N D A                   " space(0)
   "|     Comprovante Anual de Rendimentos Pagos ou Creditados e     |" skip
   "|  Secretaria da Receita Federal                                 " space(0)
   "|   de Retencao de Imposto de Renda na Fonte - Pessoa Juridica   |" skip
   "|                                                                " space(0)
   "|                     " c-ano-base "|" AT 131                      skip  
   "+----------------------------------------------------------------" space(0)
   "+----------------------------------------------------------------+" skip
   "1. FONTE PAGADORA                                                " space(0)
   "                                                                  " skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "| Nome Empresarial " empresa.razao-social
   "| CNPJ" AT 87 empresa.cgc "|" AT 131                               skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "2. PESSOA JURIDICA BENEFICIARIA DOS RENDIMENTOS                  " space(0)
   "                                                                  " skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "| Nome Empresarial " emitente.nome-emit FORMAT "x(66)"
   "| CNPJ" AT 87 emitente.cgc "|" AT 131                              skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "3. RENDIMENTO E IMPOSTO RETIDO NA FONTE" skip
   with no-labels no-box page-top width 132 stream-io frame f-cabecalho.   

form
   "+----------------------------------------------------------------" space(0)
   "+----------------------------------------------------------------+" skip
   "|  M I N I S T E R I O    D A    F A Z E N D A                   " space(0)
   "|                 Comprovante Anual de Retencao de               |" skip
   "|  Secretaria da Receita Federal                                 " space(0)
   "|                    CSLL, COFINS e PIS/PASEP                    |" skip
   "|                                                                " space(0)
   "|                     "c-ano-base          "                    |" skip  
   "+----------------------------------------------------------------" space(0)
   "+----------------------------------------------------------------+" skip
   "1. FONTE PAGADORA                                                " space(0)
   "                                                                  " skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "| Nome Empresarial " empresa.razao-social space(26)                       
                         "| CNPJ" empresa.cgc      "                 |" skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "2. PESSOA JURIDICA BENEFICIARIA DOS RENDIMENTOS                  " space(0)
   "                                                                  " skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "| Nome Empresarial " emitente.nome-emit FORMAT "x(66)"
   "| CNPJ" AT 87  emitente.cgc "|" AT 131                             skip
   "+----------------------------------------------------------------" space(0)
   "---------------------+-------------------------------------------+" skip
   "3. RELACAO DE PAGAMENTOS E RETENCOES" skip
   with no-labels no-box page-top width 132 stream-io frame f-cabecalho-pis.

assign empresa.cgc:format in frame f-cabecalho     = param-global.formato-id-federal
       empresa.cgc:format in frame f-cabecalho-pis = param-global.formato-id-federal.

form
    "+-----+---------+------------------------------------------------" space(0)
    "---------------+-------------------------+-----------------------+" skip    
    "| Mes |Codigo de| Descricao do Rendimento" space(0)
    "|       Rendimento        |     Imposto Retido    |" AT 81          skip
    "|     |Retencao |" space(0)
    "|       " AT 81   space(1)  l-moeda    space(1)
    "|       " AT 107 space(1)   l-moeda2   space(1) "|" AT 131          skip
    "+-----+---------+------------------------------------------------" space(0)
    "---------------+-------------------------+-----------------------+" skip
    with no-labels no-box page-top width 132 stream-io frame f-cab-movto.

form
    "|"
    c-mes    format "x(03)"
    "|  "
    i-cod-ir format 9999
    "|" AT 17                                 space(0)
    c-natur-rend format "x(63)"               space(0)
    "|" AT 81
    de-rend-bruto format ">>>,>>>,>>>,>>9.99"
    "|" AT 107
    de-irrf       format ">>>>>,>>>,>>9.99"
    "|" AT 131
    with no-box no-labels width 132 stream-io frame f-meses.

form
    "+-----+---------+------------------------------------------------" space(0)
    "---------------+-------------------------+-----------------------+" skip
    with no-box no-labels width 132 stream-io frame f-linha.

form
    "4. INFORMACOES COMPLEMENTARES                                    " space(0)
    "                                                                  " skip
    "+----------------------------------------------------------------" space(0)
    "-----------------------------------------------------------------+" skip
    "|"c-complemento1 space(18)                                          
    "|" AT 131                                                           skip
    "|" space(0)
    "|" AT 131                                                           skip
    "|" space(0)
    "|" AT 131                                                           skip
    "|" space(0)
    "|" AT 131                                                           skip
    "|" space(0)
    "|" AT 131                                                           skip
    "|" space(0)
    "|" AT 131                                                           skip
    "+----------------------------------------------------------------" space(0)
    "-----------------------------------------------------------------+" skip
      with no-box no-labels width 132 stream-io frame f-info.

form
    "|" AT 1 "|" AT 7 "|" AT 17      space(0)
    "|" AT 81 "|" AT 107 "|" AT 131  skip
    with no-labels no-box width 132 stream-io frame f-barra.

run utp/ut-trfrrp.p (input frame f-cabecalho:handle).
run utp/ut-trfrrp.p (input frame f-cab-movto:handle).
run utp/ut-trfrrp.p (input frame f-meses:handle).
run utp/ut-trfrrp.p (input frame f-linha:handle).
run utp/ut-trfrrp.p (input frame f-info:handle).
run utp/ut-trfrrp.p (input frame f-barra:handle).

form
    "5. RESPONSAVEL PELAS INFORMACOES                                 " space(0)
    "                                                                  " skip
    "+---------------------------------------------------+------------" space(0)
    "-------+---------------------------------------------------------+" skip
    "| Nome :" c-responsavel                   space(3) "| Data " space (0)
      da-entrega format  "99/99/9999" space(3) "| Assinatura " space (0)
    " DISPENSA ASSINATURA (IN - SRF 459/04)       |" skip
    "+---------------------------------------------------+------------" space(0)
    "-------+---------------------------------------------------------+" skip
    "Aprovado pela IN/SRF n.459/2004"
    with no-labels no-box width 132 stream-io frame f-rodape-dirf.

form
    "5. RESPONSAVEL PELAS INFORMACOES                                 " space(0)
    "                                                                  " skip
    "+---------------------------------------------------+------------" space(0)
    "-------+---------------------------------------------------------+" skip
    "| Nome :" c-responsavel                   space(3) "| Data " space (0)
      da-entrega format  "99/99/9999" space(3) "| Assinatura " space (0)
    " DISPENSA ASSINATURA (IN - SRF 459/04)       |" skip
    "+---------------------------------------------------+------------" space(0)
    "-------+---------------------------------------------------------+" skip
    "Aprovado pela IN/SRF n.119/2000"
    with no-labels no-box width 132 stream-io frame f-rodape.


/* Fim de Include */
