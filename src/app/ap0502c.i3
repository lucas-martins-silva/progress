/*********************************************************
**  Programa: ap0502c.i3
**  Objetivo: Cria movimento de AVA na Provisao para
**            vinculacao com o titulo com ou sem chave do
**            documento
**       {1} - Valor do AVA
**       {2} - Valor ME do AVA
**       {3} - Possui chave no documento
**       {4} - Contabiliza
*********************************************************/

create b-mov-ap-prev.

if "S" = {3} then
    assign b-mov-ap-prev.nr-docto       = b-tit-ap-prev.nr-docto
           b-mov-ap-prev.serie          = b-tit-ap-prev.serie
           b-mov-ap-prev.parcela        = b-tit-ap-prev.parcela
           b-mov-ap-prev.cod-fornec     = b-tit-ap-prev.cod-fornec
           b-mov-ap-prev.cod-esp        = b-tit-ap-prev.cod-esp
           b-mov-ap-prev.transacao      = 5 /* AVA */
           b-mov-ap-prev.lancamento     = 2.
else
    assign b-mov-ap-prev.nr-docto       = ""
           b-mov-ap-prev.serie          = ""
           b-mov-ap-prev.parcela        = ""
           b-mov-ap-prev.cod-fornec     = b-tit-ap-prev.cod-fornec
           b-mov-ap-prev.cod-esp        = ""
           b-mov-ap-prev.transacao      = 3. /* PEF */

if  {4} = "S" then
    assign b-mov-ap-prev.contabiliza    = yes
           b-mov-ap-prev.contabilizou   = no
           b-mov-ap-prev.flag-contab    = yes
           b-mov-ap-prev.conta-contabil = mov-pef-pend.conta-contabil
           b-mov-ap-prev.ct-conta       = mov-pef-pend.ct-conta
           b-mov-ap-prev.sc-conta       = mov-pef-pend.sc-conta.
           
else
    assign b-mov-ap-prev.contabiliza    = no
           b-mov-ap-prev.contabilizou   = no
           b-mov-ap-prev.flag-contab    = no
           b-mov-ap-prev.conta-contabil = ""
           b-mov-ap-prev.ct-conta       = ""
           b-mov-ap-prev.sc-conta       = "".
           
assign b-mov-ap-prev.ep-codigo      = b-tit-ap-prev.ep-codigo
       b-mov-ap-prev.cod-estabel    = b-tit-ap-prev.cod-estabel
       b-mov-ap-prev.esp-ant        = tit-ap.cod-esp
       b-mov-ap-prev.serie-ant      = tit-ap.serie
       b-mov-ap-prev.docto-ant      = tit-ap.nr-docto
       b-mov-ap-prev.parc-ant       = tit-ap.parcela
       b-mov-ap-prev.fornec-ant     = tit-ap.cod-fornec
       b-mov-ap-prev.referencia     = mov-pef-pend.referencia
       b-mov-ap-prev.portador       = mov-pef-pend.cod-portador
       b-mov-ap-prev.modalidade     = 1
       b-mov-ap-prev.origem         = 1
       b-mov-ap-prev.tipo           = b-tit-ap-prev.tipo
       b-mov-ap-prev.tp-codigo      = mov-pef-pend.tp-codigo
       b-mov-ap-prev.tp-recta-transf = mov-pef-pend.tp-receita
       b-mov-ap-prev.moeda          = b-tit-ap-prev.moeda
       b-mov-ap-prev.cotacao-dia    = b-tit-ap-prev.cotacao-dia
       b-mov-ap-prev.dt-emissao     = b-tit-ap-prev.dt-emissao
       b-mov-ap-prev.dt-vencimen    = b-tit-ap-prev.dt-vencimen
       b-mov-ap-prev.nr-cheque      = mov-pef-pend.nr-cheque
       b-mov-ap-prev.nr-docto-emp   = string(mov-pef-pend.nr-cheque)
       b-mov-ap-prev.valor-mov      = {1}
       b-mov-ap-prev.valor-mov-me   = {2}
       b-mov-ap-prev.usuario        = c-seg-usuario
       b-mov-ap-prev.dt-today       = today
       b-mov-ap-prev.c-time         = string(time, "HH:MM").

if mov-ap.dt-transacao < b-tit-ap-prev.dt-emissao then       
   assign b-mov-ap-prev.dt-transacao = b-tit-ap-prev.dt-emissao.
else
   assign b-mov-ap-prev.dt-transacao = mov-ap.dt-transacao.
  
&if defined(BF_FIN_RET_SALDO_PREV) &then 
    assign b-mov-ap-prev.mov-relac-prev = c-mov-relac-prev.
&else
    assign b-mov-ap-prev.char-2 = c-mov-relac-prev.
&endif    
  
/* Fim include */
