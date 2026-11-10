/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0657RP 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0657rp MIM}
&ENDIF

/*****************************************************************************
**
**  IM0657rp.p - Relatorio Importacao
**
**  Objetivo: Demostrativo do Processo de Importa‡Æo.
**
******************************************************************************/

{utp/ut-glob.i}
{imp/im0657.i1}     /* Defini‡Æo frames     */
{cdp/cdcfgmat.i}    /* Defini‡Æo pre-processador do magnus*/  
{cdp/cdcfgdis.i}
{include/i-rpvar.i}
{include/boerrtab.i}
   
define buffer b-historico-embarque for historico-embarque.
define buffer b-historico-embarque2 for historico-embarque.

def var l-imprime   as logical                no-undo.
def var l-continua  as logical                no-undo.
def var l-param     like param-global.exp-cep no-undo.
def var c-remetente as char format "x(40)"    no-undo.
def var i-arq       as integer init 0         no-undo.
def var h-acomp     as handle                 no-undo.
def var c-acompanha as char                   no-undo.
def var i-seq-erro  as integer                no-undo.
def var c-comprador as char                   no-undo.

def var i-ordem-embarque as integer                no-undo.
def var i-ordem-compra   as integer                no-undo.
def var i-num-ocorren    as integer format ">>>9"  no-undo.
def var i-previsao       as integer format "->>>9" no-undo.
def var i-efetiva        as integer format "->>>9" no-undo.
def var i-diferenca      as integer format "->>>9" no-undo.
def var i-percentual     as integer format ">>>>9" no-undo.
def var i-media-prev     as integer format "->>>9" no-undo.
def var i-media-efetiva  as integer format "->>>9" no-undo.

/* Vari veis para os labels */
def var lb-cod-pto-contr    as char format "x(10)".
def var lb-descricao        as char format "x(10)".
def var lb-i-num-ocorren    as char format "x(9)".
def var lb-i-media-prev     as char format "x(5)".
def var lb-i-media-efetiva  as char format "x(5)".
def var lb-i-diferenca      as char format "x(6)".
def var lb-i-percentual     as char format "x(5)".
def var lb-itiner           as char format "x(12)".

define temp-table tt-itiner NO-UNDO
    field cod-itiner  like itinerario.cod-itiner
    field descricao   like itinerario.descricao
    field cod-pto-contr like pto-contr.cod-pto-contr.

define temp-table tt-ponto NO-UNDO
    field cod-pto-contr like pto-contr.cod-pto-contr
    field descricao     like pto-contr.descricao
    field num-ocorren   as integer format ">>>9"
    field media-prev    as integer format "->>>9"
    field media-efetiva as integer format "->>>9"
    field diferenca     as integer format "->>>9"
    field percentual    as integer formaT ">>>>9".  
           
{imp/im0657.i2}     /* Defini‡Æo frames     */    


/*{cdp/cdapi523.i "h-prg523"}*/
/*---------------------------------------*/


def temp-table tt-raw-digita
    field raw-digita as raw.

/* Parametros */ 
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-liter.i Pto_Contr * L}
assign lb-cod-pto-contr = trim(return-value).

{utp/ut-liter.i Descri‡Æo * L}
assign lb-descricao = trim(return-value).

{utp/ut-liter.i Num_Ocor * L}
assign lb-i-num-ocorren = trim(return-value).

{utp/ut-liter.i Prev * L}
assign lb-i-media-prev = trim(return-value).

{utp/ut-liter.i Efet * L}
assign lb-i-media-efetiva = trim(return-value).

{utp/ut-liter.i Difer * L}
assign lb-i-diferenca = trim(return-value).

{utp/ut-liter.i Perc * L}
assign lb-i-percentual = trim(return-value).

{utp/ut-liter.i Itiner rios: * L}
assign lb-itiner = trim(return-value).

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

     
assign c-programa     = "im0657"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Demonstrativo Tempo Pto Controle"
       c-sistema      = "Com‚rcio Exterior"
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpcb80.i}

find first param-global no-lock no-error.

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
        
for each pto-contr 
   where pto-contr.cod-pto-contr >= tt-param.i-cod-pto-ini and
         pto-contr.cod-pto-contr <= tt-param.i-cod-pto-fim NO-LOCK
         by pto-contr.cod-pto-contr descending:
   FOR each historico-embarque no-lock
       where historico-embarque.cod-pto-contr = pto-contr.cod-pto-contr and
             historico-embarque.cod-itiner >= tt-param.i-cod-itiner-ini and
             historico-embarque.cod-itiner <= tt-param.i-cod-itiner-fim and
             historico-embarque.dt-efetiva <> ?                         and
             historico-embarque.dt-efetiva >= tt-param.d-data-ini       and
             historico-embarque.dt-efetiva <= tt-param.d-data-fim
             break by historico-embarque.cod-pto-contr:
        find first ordens-embarque  
             where ordens-embarque.cod-estabel = historico-embarque.cod-estabel and
                   ordens-embarque.embarque    = historico-embarque.embarque
                   no-lock no-error.
        if avail ordens-embarque then
            find ordem-compra 
               where ordem-compra.numero-ordem = ordens-embarque.numero-ordem /*and
                     ordem-compra.cod-emitente >= tt-param.i-cod-fornec-ini   and 
                     ordem-compra.cod-emitente <= tt-param.i-cod-fornec-fim*/  
                     no-lock no-error.
            if avail ordem-compra then do:
                find emitente
                     where emitente.cod-emitente = ordem-compra.cod-emitente
                     no-lock no-error.
                if avail emitente and emitente.nome-abrev >= tt-param.c-nome-abrev-ini and
                         emitente.nome-abrev <= tt-param.c-nome-abrev-fim then do:

                    assign i-num-ocorren = i-num-ocorren + 1.
                    find pto-itiner 
                        where pto-itiner.cod-itiner = historico-embarque.cod-itiner and
                              pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr
                              no-lock no-error.
                    if avail pto-itiner then do:
                          assign i-previsao = pto-itiner.nr-dias.
                          FIND b-historico-embarque2 
                               WHERE b-historico-embarque2.cod-estabel = historico-embarque.cod-estabel AND
                                     b-historico-embarque2.embarque    = historico-embarque.embarque    AND
                                     b-historico-embarque2.cod-pto-contr = historico-embarque.cod-pto-contr
                                     NO-LOCK NO-ERROR.
                          IF AVAIL b-historico-embarque2 THEN
                              find prev b-historico-embarque2 
                                 where b-historico-embarque2.cod-estabel = historico-embarque.cod-estabel and
                                       b-historico-embarque2.embarque    = historico-embarque.embarque 
                                       no-lock no-error.
                              if avail b-historico-embarque2 then do:
                                  assign i-efetiva = i-efetiva + INT(historico-embarque.dt-efetiva - b-historico-embarque2.dt-efetiva). 
                              end.
                              else 
                                  ASSIGN i-efetiva =  i-efetiva + (pto-itiner.nr-dias + INT(historico-embarque.dt-efetiva - historico-embarque.dt-previsao)).
                          find tt-itiner 
                               where tt-itiner.cod-itiner = historico-embarque.cod-itiner and
                                     tt-itiner.cod-pto-contr = pto-contr.cod-pto-contr 
                               no-error.
                          if not avail tt-itiner then do:
                              find itinerario 
                                   where itinerario.cod-itiner = historico-embarque.cod-itiner 
                                   NO-LOCK no-error.
                              if avail itinerario then do:
                                  create tt-itiner.
                                  assign tt-itiner.cod-itiner = itinerario.cod-itiner
                                         tt-itiner.descricao  = itinerario.descricao
                                         tt-itiner.cod-pto-contr = pto-contr.cod-pto-contr.
                              end.
                          end.
                    end.
                end.
            end.
            if last-of(historico-embarque.cod-pto-contr) and (i-num-ocorren <> 0) then 
               RUN calculaPontos.
   END.
END.

run imprimePontos. 
page.
    
if tt-param.l-imprime = yes then do:    
    disp c-lb-tit-sel
         tt-param.i-cod-pto-ini
         tt-param.i-cod-pto-fim
         tt-param.i-cod-itiner-ini
         tt-param.i-cod-itiner-fim
         tt-param.d-data-ini
         tt-param.d-data-fim
         tt-param.c-nome-abrev-ini
         tt-param.c-nome-abrev-fim
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


PROCEDURE CalculaPontos:
    assign i-media-efetiva = (i-efetiva / i-num-ocorren)
           i-media-prev    = i-previsao 
           i-diferenca     = (i-media-efetiva - i-media-prev).
    if i-media-prev <> 0 then do:
       assign i-percentual = (i-diferenca / i-media-prev) * 100.
       if i-percentual < 0 then assign i-percentual = (i-percentual * (-1)).
       create tt-ponto.
       assign tt-ponto.cod-pto-contr = pto-contr.cod-pto-contr 
              tt-ponto.descricao     = IF AVAIL historico-embarque AND historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao 
              tt-ponto.num-ocorren   = i-num-ocorren 
              tt-ponto.media-prev    = i-media-prev 
              tt-ponto.media-efetiva = i-media-efetiva 
              tt-ponto.diferenca     = i-diferenca 
              tt-ponto.percentual    = i-percentual.             

    end.
    else if tt-param.i-percentual = 0 then do:
       if i-percentual = ? then assign i-percentual = 0.
       create tt-ponto.
       assign tt-ponto.cod-pto-contr = pto-contr.cod-pto-contr 
              tt-ponto.descricao     = IF AVAIL historico-embarque AND historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao 
              tt-ponto.num-ocorren   = i-num-ocorren 
              tt-ponto.media-prev    = i-media-prev 
              tt-ponto.media-efetiva = i-media-efetiva 
              tt-ponto.diferenca     = i-diferenca 
              tt-ponto.percentual    = i-percentual.
    end.
    assign i-num-ocorren    = 0
           i-diferenca      = 0
           i-efetiva        = 0
           i-percentual     = 0
           i-media-prev     = 0
           i-media-efetiva  = 0
           i-previsao       = 0.                          
END.

Procedure imprimePontos:

  for each tt-ponto 
    where tt-ponto.percentual >= tt-param.i-percentual
           by tt-ponto.percentual descending
           by tt-ponto.cod-pto-contr descending:
      if (line-counter >= 60) or (line-counter = 1) then do:
        page.
        put skip(1).
        disp lb-cod-pto-contr 
             lb-descricao     
             lb-i-num-ocorren  
             lb-i-media-prev  
             lb-i-media-efetiva
             lb-i-diferenca  
             lb-i-percentual
             "    ---------"
             "-----------------------------"
             "-------- "
             "---- "
             "---- "
             "----- "
             "----  "
             with frame f-ponto-label.
         
      end.
      
      disp tt-ponto.cod-pto-contr
           tt-ponto.descricao     
           tt-ponto.num-ocorren   
           tt-ponto.media-prev
           tt-ponto.media-efetiva
           tt-ponto.diferenca
           tt-ponto.percentual
           with frame f-ponto.
      
      down with frame f-ponto.
      
      {utp/ut-liter.i Itiner rios: * L}
      assign lb-itiner = trim(return-value).

      for each tt-itiner 
          where tt-itiner.cod-pto-contr = tt-ponto.cod-pto-contr
          by tt-itiner.cod-itiner descending:
       
         disp lb-itiner
              tt-itiner.cod-itiner 
              tt-itiner.descricao
              with frame f-itiner.     
              down with frame f-itiner.
         assign lb-itiner = " ".
      end.
      put skip(1).

  end.
END.
