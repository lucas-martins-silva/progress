/*********************************************************
**  Programa: ap0501r.i
**  Objetivo: Cria movimento de AVA na Provisao para
**            vinculacao com o titulo
**       {1} - Valor do AVA
**       {2} - Valor ME do AVA
*********************************************************/

create b-mov-ap-prov.             
assign b-mov-ap-prov.ep-codigo      = b-tit-ap-prov.ep-codigo
       b-mov-ap-prov.cod-estabel    = b-tit-ap-prov.cod-estabel
       b-mov-ap-prov.cod-esp        = b-tit-ap-prov.cod-esp
       b-mov-ap-prov.serie          = b-tit-ap-prov.serie
       b-mov-ap-prov.nr-docto       = b-tit-ap-prov.nr-docto
       b-mov-ap-prov.parcela        = b-tit-ap-prov.parcela
       b-mov-ap-prov.cod-fornec     = b-tit-ap-prov.cod-fornec
       b-mov-ap-prov.referencia     = tit-ap.referencia
       b-mov-ap-prov.esp-ant        = tit-ap.cod-esp
       b-mov-ap-prov.serie-ant      = tit-ap.serie
       b-mov-ap-prov.docto-ant      = tit-ap.nr-docto
       b-mov-ap-prov.parc-ant       = tit-ap.parcela
       b-mov-ap-prov.fornec-ant     = tit-ap.cod-fornec
       b-mov-ap-prov.transacao      = 5 /* AVA */
       b-mov-ap-prov.lancamento     = 2     
       b-mov-ap-prov.portador       = 0
       b-mov-ap-prov.modalidade     = 1
       b-mov-ap-prov.contabiliza    = no
       b-mov-ap-prov.flag-contab    = no 
       b-mov-ap-prov.contabilizou   = no
       b-mov-ap-prov.conta-contabil = ""
       b-mov-ap-prov.ct-conta       = ""
       b-mov-ap-prov.sc-conta       = ""
       b-mov-ap-prov.origem         = tit-ap.origem
       b-mov-ap-prov.moeda          = b-tit-ap-prov.moeda
       b-mov-ap-prov.cotacao-dia    = b-tit-ap-prov.cotacao-dia
       b-mov-ap-prov.dt-emissao     = b-tit-ap-prov.dt-emissao
       b-mov-ap-prov.dt-vencimen    = b-tit-ap-prov.dt-vencimen
       b-mov-ap-prov.valor-mov      = {1}
       b-mov-ap-prov.valor-mov-me   = {2}
       b-mov-ap-prov.usuario        = c-seg-usuario
       b-mov-ap-prov.dt-today       = today
       b-mov-ap-prov.c-time         = string(time, "HH:MM")
       b-mov-ap-prov.tipo           = b-tit-ap-prov.tipo.

if mov-ap.dt-transacao < b-tit-ap-prov.dt-emissao then       
   assign b-mov-ap-prov.dt-transacao = b-tit-ap-prov.dt-emissao.
else
   assign b-mov-ap-prov.dt-transacao = mov-ap.dt-transacao.
  
&if defined(BF_FIN_RET_SALDO_PREV) &then 
    assign b-mov-ap-prov.mov-relac-prev = c-mov-relac-prev.
&else
    assign b-mov-ap-prov.char-2 = c-mov-relac-prev.
&endif    
  
/* Fim include */
