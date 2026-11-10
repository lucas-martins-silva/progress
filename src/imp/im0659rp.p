/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0659RP 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0659rp MIM}
&ENDIF

/*****************************************************************************
**
**  IM0659rp.p - Relatorio Importacao
**
**  Objetivo: Relat¢rio de Despesas por Grupo de Despesa.
**
******************************************************************************/

{utp/ut-glob.i}
{imp/im0659.i1}     /* Defini‡Æo tt-param   */
{cdp/cdcfgmat.i}    /* Defini‡Æo pre-processador do magnus*/  
{cdp/cdcfgdis.i}
{include/boerrtab.i}
{include/i-rpvar.i}
   

def var l-imprime   as logical             no-undo.
def var l-continua  as logical             no-undo.
def var c-remetente as char format "x(40)" no-undo.
def var i-arq       as integer init 0      no-undo.
def var h-acomp     as handle              no-undo.
def var c-acompanha as char                no-undo.
def var i-seq-erro  as integer             no-undo.
def var c-comprador as char                no-undo.
def var l-param     like param-global.exp-cep no-undo.

def var de-valor-desp-conv as decimal format ">>>>>,>>>,>>9.99999" no-undo.
def var de-tot-desp        as decimal format ">>>>>,>>>,>>9.99999" no-undo.
def var de-valor-desp-tot  as decimal no-undo.
def var i-seq-desp         as integer no-undo.
def var i-tot-nr-dias      as integer no-undo.
def var d-dt-fat-ger       like prazo-compra.data-entrega.
def var de-tot-desp-conv   as decimal format ">>>>>,>>>,>>9.99999" no-undo.
def var valor-grupo-tot    like desp-imp.val-desp no-undo.
def var c-cot              as char format "x(8)"  no-undo.
def var c-emb              as char format "x(10)" no-undo.
def var c-emb-cot          as char format "x(21)" no-undo.
def var c-considera        as char format "x(21)" no-undo.
def var d-dt-cotacao       as date format "99/99/9999" no-undo.
def var i-ordem-quant      as decimal format ">>>,>>>,>>9.9999" no-undo.
def var l-avail            as logical initial no no-undo.
def var i-quantidade       as decimal format ">>>,>>>,>>9.9999" no-undo.

/* Vari veis para os labels */
def var lb-cod-itiner    as char format "x(10)".
def var lb-descricao     as char format "x(10)".
def var lb-num-ocorren   as char format "x(9)".
def var lb-previsao      as char format "x(5)".
def var lb-efetiva       as char format "x(5)".
def var lb-diferenca     as char format "x(6)".
def var lb-percentual    as char format "x(5)".
def var lb-ponto-critico as char format "x(12)".
def var lb-cod-grup-desp as char format "x(17)".
def var lb-periodo       as char format "x(8)".
def var lb-literal       as char format "x(1)".
def var lb-tot-grup-desp as char format "x(15)".

{imp/im0659.i2} /* Defini‡Æo frames */

def temp-table tt-raw-digita
    field raw-digita as raw.
    
define buffer b-pto-itiner for pto-itiner.

/* Parametros */ 
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-liter.i Sele‡Æo * L}
assign c-lb-tit-sel = trim(return-value).

{utp/ut-liter.i ImpressÆo * L}
assign c-lb-tit-imp = trim(return-value).

{utp/ut-liter.i Parƒmetros * L}
assign c-lb-tit-par = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-lb-destino = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign c-lb-usuario = trim(return-value).

{utp/ut-liter.i Estabelecimento * L}
assign tt-param.i-cod-est-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Grupo_de_Despesa * L}
assign tt-param.i-cod-grup-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Dt_Fato_Gerador_Despesa * L}
assign tt-param.d-data-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Data_Cota‡Æo * L}
assign tt-param.dt-cotacao:label in frame f-param = trim(return-value).


{utp/ut-liter.i Moeda * L}
assign tt-param.i-moeda:label in frame f-param = trim(return-value).

{utp/ut-liter.i Considera_Ordens * L}
assign c-considera:label in frame f-param = trim(return-value).

{utp/ut-liter.i Grupo_de_Despesa: * L}
assign lb-cod-grup-desp = trim(return-value).

{utp/ut-liter.i Per¡odo: * L}
assign lb-periodo = trim(return-value).

{utp/ut-liter.i … * L}
assign lb-literal = trim(return-value).

{utp/ut-liter.i Total_do_Grupo: * L}
assign lb-tot-grup-desp = trim(return-value).

{utp/ut-liter.i Cotadas * L}
assign c-cot = trim(return-value).

{utp/ut-liter.i Embarcadas * L}
assign c-emb = trim(return-value).

{utp/ut-liter.i Embarcadas_e_Cotadas * L}
assign c-emb-cot = trim(return-value).




assign c-programa     = "im0659"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Despesa Importa‡Æo por Grupo de Despesa"
       c-sistema      = "Com‚rcio Exterior"
       c-destino      = {varinc/var00002.i 04 tt-param.destino}.


&if defined(bf-mat-comex) &then
    {cdp/cd-rpout.i}
&else    
    {include/i-rpout.i}
&endif 
view frame f-cabec.
view frame f-rodape.

assign i-ep-codigo-usuario = tt-param.ep-codigo
       v_cdn_empres_usuar  = i-ep-codigo-usuario.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

find first param-global no-lock no-error.
    

if (tt-param.ordem = 1) or (tt-param.ordem = 3) then do:
   for each grupo-desp
       where grupo-desp.cod-grup-desp >= tt-param.i-cod-grup-ini and
             grupo-desp.cod-grup-desp <= tt-param.i-cod-grup-fim
             no-lock:
       for each desp-imp no-lock
           where desp-imp.int-1 = grupo-desp.cod-grup-desp
           by desp-imp.cod-desp:
           for each desp-embarque  
               where desp-embarque.cod-desp = desp-imp.cod-desp          and
                     desp-embarque.cod-estabel >= tt-param.i-cod-est-ini and
                     desp-embarque.cod-estabel <= tt-param.i-cod-est-fim
                     no-lock:
               find historico-embarque
                   where historico-embarque.cod-estabel   = desp-embarque.cod-estabel and
                         historico-embarque.embarque      = desp-embarque.embarque    and
                         historico-embarque.cod-itiner    = desp-embarque.cod-itiner  and
                         historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr
                         no-lock no-error.
               if avail historico-embarque and historico-embarque.dt-efetiva <> ? then do:
                   if historico-embarque.dt-efetiva >= tt-param.d-data-ini and
                      historico-embarque.dt-efetiva <= tt-param.d-data-fim then do:
                        if tt-param.dt-cotacao <> ? then
                           assign d-dt-cotacao = tt-param.dt-cotacao.
                        else 
                           assign d-dt-cotacao = today.
                        
                        run cdp/cd0812.p (input desp-embarque.mo-codigo,
                                          input tt-param.i-moeda,
                                          input desp-embarque.val-desp,
                                          input d-dt-cotacao,
                                          output de-valor-desp-conv).
                        
                        find first tt-despesa
                           where tt-despesa.cod-desp = desp-embarque.cod-desp
                           no-error.
                        if not avail tt-despesa then do:
                             create tt-despesa.
                             assign tt-despesa.cod-grup-desp = grupo-desp.cod-grup-desp
                                    tt-despesa.desc-despesa  = grupo-desp.desc-despesa
                                    tt-despesa.cod-desp      = desp-embarque.cod-desp
                                    tt-despesa.descricao     = IF desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                                    tt-despesa.valor         = de-valor-desp-conv
                                    de-valor-desp-conv       = 0.    
                         end.
                         else do:
                             assign tt-despesa.valor = tt-despesa.valor + de-valor-desp-conv
                                    de-valor-desp-conv = 0.
                         end.
                   end.
               end.
               else if avail historico-embarque and historico-embarque.dt-ult-previsao <> ? then do:
                         if historico-embarque.dt-ult-previsao >= tt-param.d-data-ini and
                            historico-embarque.dt-ult-previsao <= tt-param.d-data-fim then do:
                                if tt-param.dt-cotacao <> ? then
                                    assign d-dt-cotacao = tt-param.dt-cotacao.
                                else 
                                    assign d-dt-cotacao = today.
                                run cdp/cd0812.p (input desp-embarque.mo-codigo,
                                                  input tt-param.i-moeda,
                                                  input desp-embarque.val-desp,
                                                  input d-dt-cotacao,
                                                  output de-valor-desp-conv).

                                find first tt-despesa
                                   where tt-despesa.cod-desp = desp-embarque.cod-desp
                                   no-error.
                                if not avail tt-despesa then do:
                                     create tt-despesa.
                                     assign tt-despesa.cod-grup-desp = grupo-desp.cod-grup-desp
                                            tt-despesa.desc-despesa  = grupo-desp.desc-despesa
                                            tt-despesa.cod-desp      = desp-embarque.cod-desp
                                            tt-despesa.descricao     = desp-imp.descricao
                                            tt-despesa.valor         = de-valor-desp-conv
                                            de-valor-desp-conv       = 0.  
                                 end.
                                 else do:
                                    assign tt-despesa.valor = tt-despesa.valor + de-valor-desp-conv
                                           de-valor-desp-conv = 0.
                                 end.
                         end. 
                    end.
           end.
       end.      
   end.
             
end.
if (tt-param.ordem = 2) or (tt-param.ordem = 3) then do:
   for each grupo-desp
       where grupo-desp.cod-grup-desp >= tt-param.i-cod-grup-ini and
             grupo-desp.cod-grup-desp <= tt-param.i-cod-grup-fim
             no-lock:
       for each desp-imp no-lock
           where desp-imp.int-1 = grupo-desp.cod-grup-desp
           by desp-imp.cod-desp:
           for each cotacao-item-cex 
                where cotacao-item-cex.cod-desp = desp-imp.cod-desp
                no-lock:
                find cotacao-item 
                     where cotacao-item.numero-ordem = cotacao-item-cex.numero-ordem and
                           cotacao-item.cod-emitente = cotacao-item-cex.cod-emitente and
                           cotacao-item.it-codigo    = cotacao-item-cex.it-codigo    and
                        &if defined(bf-mat-comex) &then
                        &else
                           cotacao-item.seq-cotac    = cotacao-item-cex.seq-cotac    and
                        &endif
                           cotacao-item.data-cotacao = cotacao-item-cex.data-cotacao
                           no-lock no-error.
                if avail cotacao-item and cotacao-item.cot-aprovada = yes then do:
                      find ordem-compra 
                          where ordem-compra.numero-ordem = cotacao-item.numero-ordem and
                                ordem-compra.cod-estabel >= tt-param.i-cod-est-ini and
                                ordem-compra.cod-estabel <= tt-param.i-cod-est-fim
                                no-lock no-error.
                      if avail ordem-compra then do:
                          find first ordens-embarque
                             where ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                             no-lock no-error.
                          if avail ordens-embarque then do:
                              assign l-avail = yes.
                               
                               for each ordens-embarque 
                                  where ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                                  no-lock:
                                   assign i-ordem-quant = i-ordem-quant + ordens-embarque.quantidade.
                               end.
                               
                               &if defined(bf-mat-comex) &then
                                  for each prazo-compra 
                                     where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                     no-lock:
                                       assign i-quantidade = i-quantidade + prazo-compra.quantidade.
                                  end.
                                  if i-ordem-quant = i-quantidade then 
                                      assign i-ordem-quant = 0.
                                   else 
                                       assign i-ordem-quant = i-quantidade - i-ordem-quant
                                              i-quantidade = 0.                                  
                               &else
                                 if i-ordem-quant = ordem-compra.qt-solic then 
                                     assign i-ordem-quant = 0.
                                  else 
                                      assign i-ordem-quant = ordem-compra.qt-solic - i-ordem-quant.
                               &endif
                          end.
                          else assign l-avail = no.
                          if l-avail = no or (i-ordem-quant <> 0) then do:
                                for each prazo-compra
                                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                    no-lock:
                                    find itinerario 
                                        where itinerario.cod-itiner = cotacao-item-cex.cod-itiner
                                        no-lock no-error.
                                    if avail itinerario then do:
                                       find pto-itiner 
                                           where pto-itiner.cod-itiner = itinerario.cod-itiner and
                                                 pto-itiner.cod-pto-contr = cotacao-item-cex.cod-pto-contr
                                                 no-lock no-error.
                                       if avail pto-itiner then 
                                            assign i-seq-desp = pto-itiner.sequencia.
                                       find pto-itiner 
                                           where pto-itiner.cod-itiner = itinerario.cod-itiner and
                                                 pto-itiner.cod-pto-contr = itinerario.pto-chegada
                                                 no-lock no-error.
                                       if avail pto-itiner then do:
                                            if i-seq-desp > pto-itiner.sequencia then do:
                                               for each b-pto-itiner 
                                                    where b-pto-itiner.cod-itiner = itinerario.cod-itiner and
                                                          b-pto-itiner.sequencia <= i-seq-desp and
                                                          b-pto-itiner.sequencia > pto-itiner.sequencia NO-LOCK:
                                                   assign i-tot-nr-dias = i-tot-nr-dias + b-pto-itiner.nr-dias.
                                               end.
                                               assign d-dt-fat-ger = prazo-compra.data-entrega + i-tot-nr-dias.
                                            end.
                                            else do:
                                               for each b-pto-itiner 
                                                  where b-pto-itiner.cod-itiner = itinerario.cod-itiner and
                                                        b-pto-itiner.sequencia > i-seq-desp and
                                                        b-pto-itiner.sequencia <= pto-itiner.sequencia NO-LOCK:
                                                   assign i-tot-nr-dias = i-tot-nr-dias + b-pto-itiner.nr-dias.
                                               end.
                                               assign d-dt-fat-ger = prazo-compra.data-entrega - i-tot-nr-dias.
                                            end. 
                                            assign i-tot-nr-dias = 0.
                                            if d-dt-fat-ger >= tt-param.d-data-ini and 
                                               d-dt-fat-ger <= tt-param.d-data-fim then do:
                                                if desp-imp.tipo <> 1 then 
                                                    assign de-tot-desp = (prazo-compra.quantidade - i-ordem-quant) * cotacao-item-cex.val-desp
                                                           i-ordem-quant = 0.                 
                                                else 
                                                    assign de-tot-desp = cotacao-item-cex.val-desp.
      
                                                if tt-param.dt-cotacao <> ? then
                                                   assign d-dt-cotacao = tt-param.dt-cotacao.
                                                else 
                                                   assign d-dt-cotacao = today.
                                                run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                                                  input tt-param.i-moeda,
                                                                  input de-tot-desp,
                                                                  input d-dt-cotacao,
                                                                  output de-valor-desp-conv).
                                                find first tt-despesa
                                                    where tt-despesa.cod-desp = cotacao-item-cex.cod-desp
                                                    no-error.
                                                if not avail tt-despesa then do:
                                                     create tt-despesa.
                                                     assign tt-despesa.cod-grup-desp = grupo-desp.cod-grup-desp
                                                            tt-despesa.desc-despesa  = grupo-desp.desc-despesa
                                                            tt-despesa.cod-desp      = desp-imp.cod-desp
                                                            tt-despesa.descricao     = desp-imp.descricao
                                                            tt-despesa.valor         = de-valor-desp-conv
                                                            de-valor-desp-conv       = 0.
                                                end.
                                                if avail tt-despesa then 
                                                     assign tt-despesa.valor = tt-despesa.valor + de-valor-desp-conv
                                                            de-valor-desp-conv = 0.
                                            end.
                                       end.
                                    end.
                                end. /*for each prazo-compra */
                          end.
                      end. /* if ordem-compra */
                end. /* if avail cotacao */
           end.
       end. /* for each desp-imp */
   end.
end.    

disp lb-periodo
     tt-param.d-data-ini
     lb-literal
     tt-param.d-data-fim
     with frame f-periodo.
down with frame f-periodo. 
    

for each tt-despesa
  break by tt-despesa.cod-grup-desp:
   
  if first-of(tt-despesa.cod-grup-desp) then do:
      put skip(1).
      disp lb-cod-grup-desp
           tt-despesa.cod-grup-desp 
           tt-despesa.desc-despesa
           with frame f-grupo.
      down with frame f-grupo.
      put skip(1).
  end.
  disp tt-despesa.cod-desp
       tt-despesa.descricao
       tt-despesa.valor
       with frame f-despesa.
  down with frame f-despesa.       
  
  assign valor-grupo-tot = valor-grupo-tot + tt-despesa.valor.
  
  if last-of(tt-despesa.cod-grup-desp) then do:
      put skip(1).
      disp lb-tot-grup-desp valor-grupo-tot
           valor-grupo-tot         
           with frame f-grupo-tot.
      down with frame f-grupo-tot.
      assign valor-grupo-tot = 0.
  end.
                  
end.


if tt-param.l-imprime = yes then do:
    if tt-param.ordem = 1 then assign c-considera = c-emb.
    if tt-param.ordem = 2 then assign c-considera = c-cot.
    if tt-param.ordem = 3 then assign c-considera = c-emb-cot.
    page.    
    disp c-lb-tit-sel
         tt-param.i-cod-est-ini
         tt-param.i-cod-est-fim
         tt-param.i-cod-grup-ini
         tt-param.i-cod-grup-fim
         tt-param.d-data-ini
         tt-param.d-data-fim
         c-lb-tit-par
         tt-param.i-moeda
         tt-param.dt-cotacao
         c-considera
         c-lb-tit-imp
         c-lb-destino
         tt-param.destino
         tt-param.arquivo
         c-lb-usuario 
         tt-param.usuario
         with frame f-param.
end.

output close.
 
return 'OK'.
