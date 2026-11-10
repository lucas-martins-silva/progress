/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0656RP 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0656rp MIM}
&ENDIF

/*****************************************************************************
**
**  IM0656rp.p - Relatorio Importacao
**
**  Objetivo: Demostrativo do Processo de Importa‡Æo.
**
******************************************************************************/

{utp/ut-glob.i}
{imp/im0656.i1}     /* Defini‡Æo tt-param   */
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

def var i-num-ocorren    as integer no-undo.
def var i-efetiva        as integer no-undo.
def var i-diferenca      as integer no-undo.
def var i-previsao       as integer no-undo.
def var i-percentual     as integer no-undo.
def var pto-maior        as integer no-undo.
def var pto-menor        as integer no-undo.
def var i-ordem-embarque as integer no-undo.
def var i-ordem-compra   as integer no-undo.
def var dt-efetiva-ini   like historico-embarque.dt-efetiva.
def var dt-efetiva-fim   like historico-embarque.dt-efetiva.
def var dt-previsao-ini  like historico-embarque.dt-previsao.
def var dt-previsao-fim  like historico-embarque.dt-previsao.
def var i-ponto          like historico-embarque.cod-pto-contr.
def var i-pto-efetiva    as integer no-undo.  
def var i-pto-previsao   as integer no-undo.
def var i-pto-diferenca  as integer no-undo.
def var i-nr-dias        as integer no-undo.
def var i-num            as integer no-undo.
def var l-verifica       as logical no-undo initial no.

/* Vari veis para os labels */
def var lb-cod-itiner    as char format "x(10)".
def var lb-descricao     as char format "x(10)".
def var lb-num-ocorren   as char format "x(9)".
def var lb-previsao      as char format "x(5)".
def var lb-efetiva       as char format "x(5)".
def var lb-diferenca     as char format "x(6)".
def var lb-percentual    as char format "x(5)".
def var lb-ponto-critico as char format "x(12)".

{imp/im0656.i2} /* Defini‡Æo frames */

def temp-table tt-raw-digita
    field raw-digita as raw.
    

def temp-table tt-ponto-critico NO-UNDO
    field cod-estabel like historico-embarque.cod-estabel
    field embarque    like historico-embarque.embarque.    

define buffer b-historico-embarque for historico-embarque.
define buffer b-historico-embarque2 for historico-embarque.

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

{utp/ut-liter.i Per¡odo_…_Avaliar * L}
assign tt-param.d-data-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Itiner rio * L}
assign tt-param.i-cod-itiner-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Fornecedor * L}
assign tt-param.c-nome-abrev-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Itiner rio * L}
assign lb-cod-itiner = trim(return-value).

{utp/ut-liter.i Descricao * L}
assign lb-descricao = trim(return-value).

{utp/ut-liter.i Num_Ocor * L}
assign lb-num-ocorren = trim(return-value).
       
{utp/ut-liter.i Prev * L}
assign lb-previsao = trim(return-value).       
   
{utp/ut-liter.i Efet * L}
assign lb-efetiva = trim(return-value).

{utp/ut-liter.i Difer * L}
assign lb-diferenca = trim(return-value).   
  
{utp/ut-liter.i Perc * L}
assign lb-percentual = trim(return-value).

{utp/ut-liter.i Pto_Cr¡tico * L}
assign lb-ponto-critico = trim(return-value).      

{utp/ut-liter.i Percentual_de_Erro * L}
assign tt-param.i-percentual:label in frame f-param = trim(return-value).

assign c-programa     = "im0656"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Demonstrativo Tempo Itiner rios"
       c-sistema      = "Com‚rcio Exterior"
       c-destino      = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpcb80.i}

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
    
for each historico-embarque no-lock 
   where historico-embarque.cod-itiner >= i-cod-itiner-ini and
        historico-embarque.cod-itiner <= i-cod-itiner-fim
        break by historico-embarque.cod-itiner:
    if last-of(historico-embarque.cod-itiner) then do:
        for each b-historico-embarque
             where b-historico-embarque.cod-itiner = historico-embarque.cod-itiner NO-LOCK 
             break by b-historico-embarque.cod-estabel
                   by b-historico-embarque.embarque
                   by b-historico-embarque.sequencia:
            if last-of(b-historico-embarque.embarque) then do:
                if (b-historico-embarque.dt-efetiva <> ?) and (b-historico-embarque.dt-efetiva >= tt-param.d-data-ini) and (b-historico-embarque.dt-efetiva <= tt-param.d-data-fim) then do:
                    for each ordens-embarque no-lock
                        where ordens-embarque.cod-estabel = b-historico-embarque.cod-estabel and
                              ordens-embarque.embarque    = b-historico-embarque.embarque
                              break by ordens-embarque.cod-estabel
                                    by ordens-embarque.embarque
                                    by ordens-embarque.numero-ordem
                                    by ordens-embarque.parcela:
                         if last-of(ordens-embarque.parcela) then do:
                             assign i-ordem-embarque = i-ordem-embarque + 1.
                             find ordem-compra 
                                where ordem-compra.numero-ordem = ordens-embarque.numero-ordem /*and
                                      ordem-compra.cod-emitente >= i-cod-fornec-ini            and 
                                      ordem-compra.cod-emitente <= i-cod-fornec-fim */         and
                                      ordem-compra.it-codigo    >= c-it-codigo-ini             and
                                      ordem-compra.it-codigo    <= c-it-codigo-fim 
                                      no-lock no-error.
                             if avail ordem-compra then 
                                 find emitente
                                      where emitente.cod-emitente = ordem-compra.cod-emitente
                                      no-lock no-error.
                                 if avail emitente and emitente.nome-abrev >= tt-param.c-nome-abrev-ini and
                                                       emitente.nome-abrev <= tt-param.c-nome-abrev-fim then 
                                     assign i-ordem-compra = i-ordem-compra + 1.
                         end.
                    end.
                    if i-ordem-embarque = i-ordem-compra and i-ordem-embarque <> 0 then do:
                        create tt-ponto-critico.
                        assign tt-ponto-critico.cod-estabel = b-historico-embarque.cod-estabel
                               tt-ponto-critico.embarque    = b-historico-embarque.embarque.
                        
                        assign i-ordem-embarque = 0
                               i-ordem-compra   = 0
                               i-num-ocorren    = i-num-ocorren + 1.
                               
                        find last b-historico-embarque2 
                            where b-historico-embarque2.cod-estabel = b-historico-embarque.cod-estabel and
                                  b-historico-embarque2.embarque = b-historico-embarque.embarque
                                  NO-LOCK no-error.
                        if avail b-historico-embarque2 then
                           assign dt-efetiva-fim = b-historico-embarque2.dt-efetiva
                                  dt-previsao-fim = b-historico-embarque2.dt-previsao.
                        find first b-historico-embarque2 
                            where b-historico-embarque2.cod-estabel = b-historico-embarque.cod-estabel and
                                  b-historico-embarque2.embarque = b-historico-embarque.embarque
                                  NO-LOCK no-error.
                        if avail b-historico-embarque2 then do:
                            find pto-itiner 
                                 where pto-itiner.cod-itiner = b-historico-embarque2.cod-itiner and
                                       pto-itiner.cod-pto-contr = b-historico-embarque2.cod-pto-contr 
                                 no-lock no-error.
                            if avail pto-itiner then 
                               assign i-nr-dias = pto-itiner.nr-dias.
                            else assign i-nr-dias = 0.
                                
                            assign dt-efetiva-ini  = b-historico-embarque2.dt-efetiva
                                   dt-previsao-ini = b-historico-embarque2.dt-previsao
                                   i-efetiva       = i-efetiva + ((dt-efetiva-fim - dt-efetiva-ini) + i-nr-dias + (b-historico-embarque2.dt-efetiva - b-historico-embarque2.dt-previsao))  
                                   i-previsao      = i-previsao + ((dt-previsao-fim - dt-previsao-ini)) + i-nr-dias.
                            find itinerario 
                                where itinerario.cod-itiner = b-historico-embarque2.cod-itiner
                                no-lock no-error.
                            if avail itinerario then
                               assign l-verifica = yes.
                        end.
                    end. /* if i-ordem-embarque */
                    assign i-ordem-embarque = 0
                           i-ordem-compra   = 0.
                end. /* if b-historico-embarque */
    
            end. /* last-of b-historico-embarque */
        end. /* for each b-historico-embarque */
        
    end. /* last-of historico-embarque */
    if avail itinerario and l-verifica = yes then do:
        assign  l-verifica = no.
        assign  i-efetiva = (i-efetiva / i-num-ocorren)
                i-previsao = (i-previsao / i-num-ocorren)
                i-diferenca  = i-efetiva - i-previsao
                i-percentual = i-percentual + ((i-diferenca / i-previsao) * 100).
        if i-percentual < 0   then i-percentual = (i-percentual * (-1)).
        
        /* Calcula ponto de controle cr¡tico */
        for each pto-itiner 
            where pto-itiner.cod-itiner = itinerario.cod-itiner
            no-lock:
            for each b-historico-embarque2 
              where b-historico-embarque2.cod-pto-contr = pto-itiner.cod-pto-contr NO-LOCK:
                find first tt-ponto-critico 
                       where tt-ponto-critico.cod-estabel = b-historico-embarque2.cod-estabel and
                             tt-ponto-critico.embarque    = b-historico-embarque2.embarque
                             no-error.
                if avail tt-ponto-critico then do:
                    assign i-num = i-num + 1.
                    find b-historico-embarque 
                        where b-historico-embarque.cod-estabel = tt-ponto-critico.cod-estabel and
                              b-historico-embarque.embarque    = tt-ponto-critico.embarque    and
                              b-historico-embarque.cod-pto-contr = b-historico-embarque2.cod-pto-contr
                              NO-LOCK no-error.
                    if avail b-historico-embarque then 
                        find prev b-historico-embarque 
                              where b-historico-embarque.cod-estabel = tt-ponto-critico.cod-estabel and
                                    b-historico-embarque.embarque    = tt-ponto-critico.embarque    
                                    NO-LOCK no-error.
                        if avail b-historico-embarque then
                           assign i-pto-efetiva  = i-pto-efetiva + (b-historico-embarque2.dt-efetiva - b-historico-embarque.dt-efetiva).
                        else 
                           assign i-pto-efetiva = i-pto-efetiva + (pto-itiner.nr-dias + INT(b-historico-embarque2.dt-efetiva - b-historico-embarque2.dt-previsao)).

                        assign i-pto-previsao = i-pto-previsao + pto-itiner.nr-dias.                           
                                  
                end.
            end.

            if i-num <> 0 then 
                assign i-pto-efetiva   = (i-pto-efetiva / i-num)
                       i-pto-previsao  = (i-pto-previsao / i-num)
                       i-pto-diferenca = i-pto-efetiva - i-pto-previsao
                       i-pto-diferenca = ((i-pto-diferenca / i-pto-previsao) * 100)
                       i-pto-efetiva   = 0
                       i-pto-previsao  = 0
                       i-num           = 0.
           
            if i-pto-diferenca < 0 then assign i-pto-diferenca = (i-pto-diferenca * (-1)).
            if pto-maior = 0 then assign pto-maior = i-pto-diferenca
                                         i-ponto   = pto-itiner.cod-pto-contr.
            
            assign pto-menor = i-pto-diferenca.
            if pto-maior < pto-menor then
               assign pto-maior = pto-menor
                      i-ponto  = pto-itiner.cod-pto-contr.
        end.

        for each tt-ponto-critico:
           delete tt-ponto-critico.
        end.
                           
        find first tt-itiner 
           where tt-itiner.cod-itiner = itinerario.cod-itiner
           no-error.
        if not avail tt-itiner then do:
           create tt-itiner.
           assign tt-itiner.cod-itiner    = itinerario.cod-itiner 
                  tt-itiner.descricao     = trim(itinerario.descricao)
                  tt-itiner.num-ocorren   = i-num-ocorren 
                  tt-itiner.previsao      = i-previsao 
                  tt-itiner.efetiva       = i-efetiva 
                  tt-itiner.diferenca     = i-diferenca 
                  tt-itiner.percentual    = i-percentual 
                  tt-itiner.ponto-critico = i-ponto.
   
           assign i-num-ocorren  = 0
                  i-efetiva      = 0
                  i-diferenca    = 0
                  i-previsao     = 0
                  i-percentual   = 0
                  dt-efetiva-ini = ?
                  dt-efetiva-fim = ?
                  pto-maior      = 0
                  pto-menor      = 0
                  i-ponto        = 0
                  i-ordem-compra = 0
                  i-ordem-embarque = 0.                       
        end.
    end.
end. /* for each historico-embarque */


for each tt-itiner 
    where tt-itiner.percentual >= tt-param.i-percentual 
    by tt-itiner.percentual descending:

    if (line-counter >= 60) or (line-counter = 1) then do:
        page.
        put skip(1).
        disp  lb-cod-itiner 
              lb-descricao     
              lb-num-ocorren  
              lb-previsao
              lb-efetiva
              lb-diferenca  
              lb-percentual
              lb-ponto-critico
              "    ----------"
              " -------------------------------"
              " -------- "
              "---- "
              "---- "
              "----- "
              "---- "
              "-----------  "
              with frame f-itiner-label.
    end.
   disp tt-itiner.cod-itiner
        tt-itiner.descricao 
        tt-itiner.num-ocorren
        tt-itiner.previsao
        tt-itiner.efetiva 
        tt-itiner.diferenca
        tt-itiner.percentual
        tt-itiner.ponto-critico 
        with frame f-itiner.
   down with frame f-itiner.
end.
page.

if tt-param.l-imprime = yes then do:
    disp c-lb-tit-sel
         tt-param.i-cod-itiner-ini
         tt-param.i-cod-itiner-fim
         tt-param.c-nome-abrev-ini
         tt-param.c-nome-abrev-fim
         tt-param.c-it-codigo-ini
         tt-param.c-it-codigo-fim
         tt-param.d-data-ini
         tt-param.d-data-fim
         c-lb-tit-par
         tt-param.i-percentual
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

