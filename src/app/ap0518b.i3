/********************************************************************************
***
*** app/ap0518b.i3 - Gera novo Documento de AN.
***
********************************************************************************/

{cdp/cd9600.i "b-tit-ap-orig.moeda" 
              "p-dat-transf" 
              "de-cotacao"}
              
create tit-ap.

assign tit-ap.ep-codigo       = b-tit-ap-orig.ep-codigo
       tit-ap.referencia      = p-referencia
       tit-ap.cod-esp         = b-tit-ap-orig.cod-esp
       tit-ap.cod-estabel     = p-est-transf
       tit-ap.serie           = b-tit-ap-orig.serie
       tit-ap.nr-docto        = p-nr-docto
       tit-ap.parcela         = p-parcela
       tit-ap.cod-fornec      = b-tit-ap-orig.cod-fornec
       tit-ap.nome-abrev      = b-tit-ap-orig.nome-abrev
       tit-ap.matriz          = b-tit-ap-orig.matriz
       tit-ap.transacao       = 1
       tit-ap.tipo            = 2
       tit-ap.dt-emissao      = p-dat-transf
       tit-ap.dt-vencimen     = p-dat-transf
       tit-ap.dt-transacao    = p-dat-transf
       tit-ap.dt-prev-pag     = p-dat-transf
       tit-ap.moeda           = b-tit-ap-orig.moeda
       tit-ap.cotacao-dia     = de-cotacao
       tit-ap.vl-orig-me      = p-val-transf.

/*** Divis∆o do assign  para evitar erros no Progress 9 ***/
assign tit-ap.vl-original     = fn_ajust_dec(fn_conv_moedas (
                                                tit-ap.vl-orig-me,
                                                tit-ap.cotacao-dia,
                                                tit-ap.moeda,
                                                0),0).

assign tit-ap.vl-saldo-me     = tit-ap.vl-orig-me
       tit-ap.valor-saldo     = tit-ap.vl-original
       tit-ap.portador        = 0
       tit-ap.modalidade      = 1
       tit-ap.nr-cheque       = b-tit-ap-orig.nr-cheque
       tit-ap.pedido          = b-tit-ap-orig.pedido
       tit-ap.taxa-emis-anbid = 1
       tit-ap.taxa-emis-cmi   = b-tit-ap-orig.taxa-emis-cmi
       tit-ap.tp-codigo       = b-tit-ap-orig.tp-codigo
       tit-ap.esp-ant         = b-tit-ap-orig.esp-ant
       tit-ap.serie-ant       = b-tit-ap-orig.serie-ant
       tit-ap.docto-ant       = b-tit-ap-orig.docto-ant
       tit-ap.parc-ant        = b-tit-ap-orig.parc-ant
       tit-ap.vl-ir-antec     = b-tit-ap-orig.vl-ir-antec
       tit-ap.valor-ir        = b-tit-ap-orig.valor-ir
       tit-ap.ir-antec        = b-tit-ap-orig.ir-antec
       tit-ap.conta-debito    = conta-contab.conta-contabil 
       tit-ap.ct-conta-db     = conta-contab.ct-codigo   
       tit-ap.sc-conta-db     = conta-contab.sc-codigo
       tit-ap.dt-vecto-orig   = if  b-tit-ap-orig.dt-vecto-orig <> ? then       
                                          b-tit-ap-orig.dt-vecto-orig
                                      else
                                          b-tit-ap-orig.dt-emissao
       tit-ap.observacao      = b-tit-ap-orig.observacao.                                          .

assign b-tit-ap-orig.char-1 = string(rowid(tit-ap)).

find first l-ant-ap exclusive-lock
     where rowid(l-ant-ap)       = r-l-ant-ap       
     and   l-ant-ap.ep-cod-ant   = b-tit-ap-orig.ep-codigo
     and   l-ant-ap.cod-est-ant  = b-tit-ap-orig.cod-estabel
     and   l-ant-ap.cod-esp-ant  = b-tit-ap-orig.cod-esp
     and   l-ant-ap.serie-ant    = b-tit-ap-orig.serie
     and   l-ant-ap.nr-docto-ant = b-tit-ap-orig.nr-docto
     and   l-ant-ap.parcela-ant  = b-tit-ap-orig.parcela
     and   l-ant-ap.fornec-ant   = b-tit-ap-orig.cod-fornec no-error.

if  avail l-ant-ap then do:
    assign l-ant-ap.char-1 = string(tit-ap.nr-docto, "x(16)")
           l-ant-ap.char-1 = l-ant-ap.char-1 + string(tit-ap.parcela, "x(02)").
end.
    
/********* Multiplanta ************/  
run pi-cria-tt-dados-tit-ap (input 1).     
/******* Fim-Multiplanta **********/   

/* Fim de Include */
