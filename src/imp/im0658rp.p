/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0658RP 2.00.00.020 } /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0658rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: im0658rp.p
**
**       DATA....: Junho DE 2001
**
**       Objetivo: Controle de Importa‡Æo
**
**       VERSAO..: 2.00.00.000 - Rodrigo Frank
**
******************************************************************************/
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

def var h-acomp           as handle  no-undo.
def var c-acompanha       as char    no-undo.
def var c-lb-ped-compr    as char format "x(09)" no-undo.
def var c-lb-proc-imp     as char format "x(08)" no-undo.
def var c-lb-dt-ped       as char format "x(06)" no-undo.
def var c-lb-item         as char format "x(04)" no-undo.
def var c-lb-descricao    as char format "x(09)" no-undo.
def var c-lb-quantidade   as char format "x(12)" no-undo.
def var c-lb-quantidade2  as char format "x(10)" no-undo.
def var c-lb-un           as char format "x(02)" no-undo.
def var c-lb-exportador   as char format "x(10)" no-undo.
def var c-lb-fabricante   as char format "x(10)" no-undo.
def var c-lb-n-fab        as char format "x(05)" no-undo.
def var c-lb-embarque     as char format "x(08)" no-undo.
def var c-lb-embarque2    as char format "x(08)" no-undo.
def var c-lb-dt-prev      as char format "x(08)" no-undo.
def var c-lb-dt-prev2     as char format "x(08)" no-undo.
def var c-lb-dt-prev3     as char format "x(08)" no-undo.
def var c-lb-dt-efet      as char format "x(08)" no-undo.
def var c-lb-dt-efet2     as char format "x(08)" no-undo.
def var c-lb-dt-efet3     as char format "x(08)" no-undo.
def var c-lb-dt-ult       as char format "x(08)" no-undo.
def var c-lb-dt-ult2      as char format "x(08)" no-undo.
def var c-lb-dt-ult3      as char format "x(08)" no-undo.
def var c-lb-local        as char format "x(05)" no-undo.
def var c-lb-desembarque  as char format "x(11)" no-undo.
def var c-lb-chegada      as char format "x(07)" no-undo.
def var d-quant-embar    like ordens-embarque.quantidade no-undo.
def var d-quant-prazo    like prazo-compra.quantidade no-undo.

{imp/im0658.i}  /** Defini‡Æo de temp table */
{imp/im0658.i1} /** Defini‡Æo de frames *****/

define temp-table tt-ordem-compra NO-UNDO
    field numero-ordem like prazo-compra.numero-ordem
    field quant-prazo  as   decimal format ">>>,>>>,>>>,>>.99999"
    index codigo is unique
        numero-ordem.

/***************************Defini‡Æo de Parƒmetros *****************************/

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************************** L i t e r a i s **********************************/

{utp/ut-liter.i Ped_Compr * R}
assign c-lb-ped-compr = trim(return-value).

{utp/ut-liter.i Proc_Imp * R}
assign c-lb-proc-imp = trim(return-value).

{utp/ut-liter.i DtPed * R}
assign c-lb-dt-ped = trim(return-value).

{utp/ut-liter.i Item * R}
assign c-lb-item = trim(return-value).


{utp/ut-liter.i Quant_Pedida * R}
assign c-lb-quantidade = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-lb-descricao = trim(return-value).


{utp/ut-liter.i Quantidade * R}
assign c-lb-quantidade2 = trim(return-value).

{utp/ut-liter.i Un * R}
assign c-lb-un = trim(return-value).

{utp/ut-liter.i Exportador * R}
assign c-lb-exportador = trim(return-value).

{utp/ut-liter.i Fabricante * R}
assign c-lb-fabricante = trim(return-value).

{utp/ut-liter.i N_Fab * R}
assign c-lb-n-fab = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-lb-embarque = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-lb-embarque2 = trim(return-value).

{utp/ut-liter.i Dt_Prev * R}
assign c-lb-dt-prev = trim(return-value).

{utp/ut-liter.i Dt_Prev * R}
assign c-lb-dt-prev2 = trim(return-value).

{utp/ut-liter.i Dt_Prev * R}
assign c-lb-dt-prev3 = trim(return-value).

{utp/ut-liter.i Dt_Efet * R}
assign c-lb-dt-efet = trim(return-value).

{utp/ut-liter.i Dt_Efet * R}
assign c-lb-dt-efet2 = trim(return-value).

{utp/ut-liter.i Dt_Efet * R}
assign c-lb-dt-efet3 = trim(return-value).

{utp/ut-liter.i Dt_Ult * R}
assign c-lb-dt-ult  = trim(return-value)
       c-lb-dt-ult2 = trim(return-value)
       c-lb-dt-ult3 = trim(return-value). 

{utp/ut-liter.i Local * R}
assign c-lb-local = trim(return-value).

{utp/ut-liter.i Nacion * R}
assign c-lb-desembarque = trim(return-value).

{utp/ut-liter.i Chegada * R}
assign c-lb-chegada = trim(return-value).

/****************************** E X E C U € Ç O **********************************/
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

{utp/ut-liter.i Quant_Pedida * R}
assign c-lb-quantidade = trim(return-value).

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa     = "im0658"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Controle de Importa‡Æo"
       c-sistema      = "Com‚rcio Exterior".      

&if defined(bf-mat-comex) &then
    {cdp/cd-rpout.i} /* include customizada Magnus */
&else    
    {include/i-rpout.i}
&endif

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-acompanha).

def buffer b-emitente for emitente.
def var c-un              like prazo-compra.un     no-undo.
def var c-nome-exportador like emitente.nome-abrev no-undo.
def var c-nome-fabricante like emitente.nome-abrev no-undo.

/******** LOGICA PROPRIAMENTE DITA ***********************************/

for each processo-imp
    where processo-imp.cod-estabel    >= tt-param.cod-estabel-ini
      and processo-imp.cod-estabel    <= tt-param.cod-estabel-fim no-lock:      
      
    find emitente use-index codigo
        where emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
        
    if not avail emitente then
        next.        
        
    if emitente.nome-abrev < tt-param.nome-exportador-ini or
       emitente.nome-abrev > tt-param.nome-exportador-fim then
        next.
        
    assign c-nome-exportador = emitente.nome-abrev.    
        
    find pedido-compr
        where pedido-compr.num-pedido = processo-imp.num-pedido no-lock no-error.
                          
    for each ordem-compra use-index pedido-item
        where ordem-compra.num-pedido =  processo-imp.num-pedido 
          and ordem-compra.it-codigo  >= tt-param.it-codigo-ini 
          and ordem-compra.it-codigo  <= tt-param.it-codigo-fim no-lock:          

        find item use-index codigo
            where item.it-codigo  = ordem-compra.it-codigo no-lock no-error.
            
        if not avail item then
            next.            
            
        &if defined(bf-mat-comex) &then
            if item.descricao-1 < tt-param.desc-item-ini or
               item.descricao-1 > tt-param.desc-item-fim then
                next.
        &else
            if item.desc-item < tt-param.desc-item-ini or
               item.desc-item > tt-param.desc-item-fim then
                next.
        &endif        

        for each prazo-compra
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                
            /*
            ** Eliminada
            */
            &if defined(bf-mat-comex) &then
               if prazo-compra.situacao = "E" then
            &else
               if prazo-compra.situacao = 4 then 
            &endif
                    next.
        
            find tt-ordem-compra
                where tt-ordem-compra.numero-ordem = prazo-compra.numero-ordem no-error.
            if not avail tt-ordem-compra then do:
            
                create tt-ordem-compra.
                assign tt-ordem-compra.numero-ordem = prazo-compra.numero-ordem.
                       
                if tt-param.i-un-quantidade = 2 then do: /*Fornecedor*/
                    find first cotacao-item where 
                         cotacao-item.numero-ordem = prazo-compra.numero-ordem and
                         cotacao-item.cot-aprovada = yes
                         no-lock no-error.
                    if avail cotacao-item then 
                        assign c-un = cotacao-item.un.    
                    end.
                else 
                    assign c-un = prazo-compra.un.

            end.
            
            assign tt-ordem-compra.quant-prazo = tt-ordem-compra.quant-prazo + if tt-param.i-un-quantidade = 1 then prazo-compra.quantidade else prazo-compra.qtd-do-forn.            

        end.
   
        for each ordens-embarque 
            where ordens-embarque.numero-ordem = ordem-compra.numero-ordem no-lock:
            
            find prazo-compra
                where prazo-compra.numero-ordem = ordens-embarque.numero-ordem
                  and prazo-compra.parcela      = ordens-embarque.parcela no-lock no-error.

            find first historico-embarque
                where historico-embarque.cod-estabel =  ordens-embarque.cod-estabel 
                  and historico-embarque.embarque    =  ordens-embarque.embarque no-lock no-error.
                  
            if not avail historico-embarque then
                next.                  
                  
            if historico-embarque.cod-itiner < tt-param.cod-itiner-ini or
               historico-embarque.cod-itiner > tt-param.cod-itiner-fim then
                next.                
            
            find itinerario
                where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock no-error.

            for first embarque-imp fields(cdn-pto-chegad cdn-pto-embarq cdn-pto-desembar) no-lock
                where embarque-imp.cod-estab = ordens-embarque.cod-estabel
                  and embarque-imp.embarque = ordens-embarque.embarque:
            end.
                
            find historico-embarque use-index pto-contr
                where historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                  and historico-embarque.embarque      = ordens-embarque.embarque
                  and historico-embarque.cod-itiner    = itinerario.cod-itiner
                  and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad no-lock no-error.
                  
            if not avail historico-embarque then
                next.

            if historico-embarque.dt-efetiva <> ? then do:
                if historico-embarque.dt-efetiva < tt-param.data-chegada-ini or
                   historico-embarque.dt-efetiva > tt-param.data-chegada-fim then
                    next.
            end.                    
            else do:
                if historico-embarque.dt-ult-prev < tt-param.data-chegada-ini or
                   historico-embarque.dt-ult-prev > tt-param.data-chegada-fim then
                    next.
            end.                    
                
            /*
            ** Situa‡Æo: 1 - Em Andamento 2 - Recebido 3 - Todas
            */                           
            if tt-param.i-sit-importacao <> 3 then do:    
                if (historico-embarque.dt-efetiva =  ? and tt-param.i-sit-importacao = 2) or 
                   (historico-embarque.dt-efetiva <> ? and tt-param.i-sit-importacao = 1) then
                    next.
            end.            
            
            find tt-ordem-compra
                where tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem no-error.
                            
            find b-emitente where
                 b-emitente.cod-emitente = processo-imp.cod-fabricante no-lock no-error.
            if avail b-emitente then
                assign c-nome-fabricante = b-emitente.nome-abrev.
            else
                assign c-nome-fabricante = "".                 
            
            /*if tt-param.i-un-quantidade = 1 then /*Interno*/
                assign tt-ordem-compra.quant-prazo = tt-ordem-compra.quant-prazo
                                                   + ordens-embarque.quantidade.
            else
                assign tt-ordem-compra.quant-prazo = tt-ordem-compra.quant-prazo
                                                   + ordens-embarque.qt-do-forn.*/
            
            find tt-imprime-registro
                where tt-imprime-registro.cod-estabel = ordens-embarque.cod-estabel
                  and tt-imprime-registro.embarque    = ordens-embarque.embarque
                  and tt-imprime-registro.proc-imp    = ordens-embarque.nr-proc-imp 
                  and tt-imprime-registro.it-codigo   = prazo-compra.it-codigo no-lock no-error.
            if not avail tt-imprime-registro then do:
                           
                run pi-acompanhar in h-acomp(input processo-imp.nr-proc-imp).
                           
                create tt-imprime-registro.
                assign tt-imprime-registro.cod-estabel     = processo-imp.cod-estabel
                       tt-imprime-registro.embarque        = ordens-embarque.embarque
                       tt-imprime-registro.ped-compr       = processo-imp.num-pedido
                       tt-imprime-registro.proc-imp        = processo-imp.nr-proc-imp
                       tt-imprime-registro.dt-ped          = pedido-compr.data-pedido /*string(day(pedido-compr.data-pedido),"99") + "/" 
                                                           + string(month(pedido-compr.data-pedido),"99")*/
                       
                       tt-imprime-registro.it-codigo       = ordem-compra.it-codigo
                       &if defined(bf-mat-comex) &then
                         tt-imprime-registro.desc-item       = item.descricao-1 + item.descricao-2 
                       &else
                         tt-imprime-registro.desc-item       = item.desc-item
                       &endif
                       tt-imprime-registro.quant-prazo     = IF AVAIL tt-ordem-compra THEN tt-ordem-compra.quant-prazo ELSE 0
                       tt-imprime-registro.un              = c-un
                       tt-imprime-registro.nome-exportador = c-nome-exportador
                       tt-imprime-registro.nome-fabricante = c-nome-fabricante
                       tt-imprime-registro.n-fab           = prazo-compra.data-orig /*string(day(prazo-compra.data-orig),"99") + "/"
                                                           + string(month(prazo-compra.data-orig),"99")*/
                       tt-imprime-registro.dt-prev-cheg   = historico-embarque.dt-previsao /*string(day(historico-embarque.dt-previsao),"99") + "/" 
                                                           + string(month(historico-embarque.dt-previsao),"99")*/
                       tt-imprime-registro.dt-efet-cheg   = historico-embarque.dt-efetiva /*string(day(historico-embarque.dt-efetiva),"99") + "/" 
                                                           + string(month(historico-embarque.dt-efetiva),"99")*/
                       tt-imprime-registro.dt-ult-cheg    = historico-embarque.dt-ult-prev /*string(day(historico-embarque.dt-ult-prev),"99") + "/" 
                                                           + string(month(historico-embarque.dt-ult-prev),"99")*/ .
                                                            
                find historico-embarque
                    where historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                      and historico-embarque.embarque      = ordens-embarque.embarque
                      and historico-embarque.cod-itiner    = itinerario.cod-itiner
                      and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq no-lock no-error.
                      
                if avail historico-embarque then                   
                    assign tt-imprime-registro.dt-prev-embar = historico-embarque.dt-previsao /*string(day(historico-embarque.dt-previsao),"99") + "/"  
                                                               + string(month(historico-embarque.dt-previsao),"99")*/
                           tt-imprime-registro.dt-efet-embar = historico-embarque.dt-efetiva /*string(day(historico-embarque.dt-efetiva),"99") + "/"
                                                               + string(month(historico-embarque.dt-efetiva),"99")*/
                           tt-imprime-registro.dt-ult-embar  = historico-embarque.dt-ult-prev /*string(day(historico-embarque.dt-ult-prev),"99") + "/"
                                                               + string(month(historico-embarque.dt-ult-prev),"99")*/ .
                        
                find historico-embarque 
                    where historico-embarque.cod-estabel   = ordens-embarque.cod-estabel 
                      and historico-embarque.embarque      = ordens-embarque.embarque    
                      and historico-embarque.cod-itiner    = itinerario.cod-itiner       
                      and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock no-error.
                if avail historico-embarque then do:
                    find pto-contr 
                        where pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr no-lock no-error.
                    assign tt-imprime-registro.dt-prev-desem = historico-embarque.dt-previsao /*string(day(historico-embarque.dt-previsao),"99") + "/"
                                                             + string(month(historico-embarque.dt-previsao),"99")*/
                           tt-imprime-registro.dt-efet-desem = historico-embarque.dt-efetiva /*string(day(historico-embarque.dt-efetiva),"99") + "/"  
                                                             + string(month(historico-embarque.dt-efetiva),"99")*/
                           tt-imprime-registro.dt-ult-desem  = historico-embarque.dt-ult-prev /*string(day(historico-embarque.dt-ult-prev),"99") + "/"
                                                             + string(month(historico-embarque.dt-ult-prev),"99")*/
                           tt-imprime-registro.local         = IF AVAIL historico-embarque AND historico-embarque.descricao <> "":U THEN historico-embarque.descricao 
                                                               ELSE if avail pto-contr then pto-contr.descricao else "".
                end.
                                                            
            end.                                                                            
            
            assign tt-imprime-registro.quant-embarque = tt-imprime-registro.quant-embarque + if tt-param.i-un-quantidade = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-forn.
            
        end.
    end.
end.

if tt-param.i-classificacao = 1 then
    {imp/im0658.i2 tt-imprime-registro.it-codigo}
else 
    if tt-param.i-classificacao = 2 then
        {imp/im0658.i2 tt-imprime-registro.desc-item}
    else
        if tt-param.i-classificacao = 3 then
            {imp/im0658.i2 tt-imprime-registro.dt-prev-cheg}
        else {imp/im0658.i2 tt-imprime-registro.proc-imp}

if tt-param.l-parametro then do:

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-selecao AS CHARACTER FORMAT "X(9)" NO-UNDO.
{utp/ut-liter.i "SELE€ÇO" *}
ASSIGN c-lbl-liter-selecao = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER FORMAT "X(19)" NO-UNDO.
{utp/ut-liter.i "Estabelecimento" *}
ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-exportador AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "Exportador" *}
ASSIGN c-lbl-liter-exportador = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-item AS CHARACTER FORMAT "X(8)" NO-UNDO.
{utp/ut-liter.i "Item" *}
ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-descricao-item AS CHARACTER FORMAT "X(18)" NO-UNDO.
{utp/ut-liter.i "Descri‡Æo_Item" *}
ASSIGN c-lbl-liter-descricao-item = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-data-chegada AS CHARACTER FORMAT "X(16)" NO-UNDO.
{utp/ut-liter.i "Data_Chegada" *}
ASSIGN c-lbl-liter-data-chegada = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-itinerario AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "Itiner rio" *}
ASSIGN c-lbl-liter-itinerario = TRIM(RETURN-VALUE).
put Skip(3) 
    c-lbl-liter-selecao at 30 SKIP
    c-lbl-liter-estabelecimento + ": " at 20 tt-param.cod-estabel-ini                " <> " at 45 tt-param.cod-estabel-fim     skip          
    c-lbl-liter-exportador + ": "      at 20 tt-param.nome-exportador-ini format "x(12)" " <> " at 45 tt-param.nome-exportador-fim format "x(12)" skip
    c-lbl-liter-item + ": "            at 20 tt-param.it-codigo-ini   format "x(16)" " <> " at 45 tt-param.it-codigo-fim    format "x(16)" skip
    c-lbl-liter-descricao-item + ": "  at 20 tt-param.desc-item-ini   format "x(40)" " <> "  tt-param.desc-item-fim         format "x(40)" skip
    c-lbl-liter-data-chegada + ": "    at 20 tt-param.data-chegada-ini               " <> " at 45 tt-param.data-chegada-fim     skip 
    c-lbl-liter-itinerario + ": "      at 20 tt-param.cod-itiner-ini      " <> " at 45 tt-param.cod-itiner-fim skip.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-classificacao AS CHARACTER FORMAT "X(16)" NO-UNDO.
{utp/ut-liter.i "Classifica‡Æo" *}
ASSIGN c-lbl-liter-classificacao = TRIM(RETURN-VALUE).
put skip(1)
    c-lbl-liter-classificacao + ":" at 20 skip.
    if tt-param.i-classificacao = 1 then
       /* Inicio -- Projeto Internacional */
       DO:
       DEFINE VARIABLE c-lbl-liter-por-item AS CHARACTER FORMAT "X(10)" NO-UNDO.
       {utp/ut-liter.i "Por_Item" *}
       ASSIGN c-lbl-liter-por-item = TRIM(RETURN-VALUE).
       put c-lbl-liter-por-item at 30.
       END.     
    else 
       if tt-param.i-classificacao = 2 then
         /* Inicio -- Projeto Internacional */
         DO:
         DEFINE VARIABLE c-lbl-liter-por-descricao-do-item AS CHARACTER FORMAT "X(23)" NO-UNDO.
         {utp/ut-liter.i "Por_Descri‡Æo_do_Item" *}
         ASSIGN c-lbl-liter-por-descricao-do-item = TRIM(RETURN-VALUE).
         put c-lbl-liter-por-descricao-do-item at 30.
         END. 
       else
           if tt-param.i-classificacao = 3 then
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-por-data-de-chegado-do-item-na AS CHARACTER FORMAT "X(40)" NO-UNDO.
                {utp/ut-liter.i "Por_Data_de_Chegado_do_Item_na_F brica" *}
                ASSIGN c-lbl-liter-por-data-de-chegado-do-item-na = TRIM(RETURN-VALUE).
                put c-lbl-liter-por-data-de-chegado-do-item-na at 30.
                END.    
           else /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-por-processo-de-importacao AS CHARACTER FORMAT "X(28)" NO-UNDO.
     {utp/ut-liter.i "Por_Processo_de_Importa‡Æo" *}
     ASSIGN c-lbl-liter-por-processo-de-importacao = TRIM(RETURN-VALUE).
     put c-lbl-liter-por-processo-de-importacao at 30.
 END. 
    
/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-parametros AS CHARACTER FORMAT "X(13)" NO-UNDO.
{utp/ut-liter.i "Parƒmetros" *}
ASSIGN c-lbl-liter-parametros = TRIM(RETURN-VALUE).
put skip(2)
    c-lbl-liter-parametros + ":" at 20 skip.
    if tt-param.i-sit-importacao = 1 then
       /* Inicio -- Projeto Internacional */
       DO:
       DEFINE VARIABLE c-lbl-liter-situacao-das-importacoes-em-a AS CHARACTER FORMAT "X(43)" NO-UNDO.
       {utp/ut-liter.i "Situa‡Æo_das_Importa‡äes___:_Em_Andamento" *}
       ASSIGN c-lbl-liter-situacao-das-importacoes-em-a = TRIM(RETURN-VALUE).
       put c-lbl-liter-situacao-das-importacoes-em-a at 30.
       END.       /**/
    else
       if tt-param.i-sit-importacao = 2 then
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-situacao-das-importacoes-rece AS CHARACTER FORMAT "X(40)" NO-UNDO.
           {utp/ut-liter.i "Situa‡Æo_das_Importa‡äes___:_Recebidas" *}
           ASSIGN c-lbl-liter-situacao-das-importacoes-rece = TRIM(RETURN-VALUE).
           put c-lbl-liter-situacao-das-importacoes-rece at 30.
           END.  
       else
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-situacao-das-importacoes-toda AS CHARACTER FORMAT "X(36)" NO-UNDO.
           {utp/ut-liter.i "Situa‡Æo_das_Importa‡äes___:_Todas" *}
           ASSIGN c-lbl-liter-situacao-das-importacoes-toda = TRIM(RETURN-VALUE).
           put c-lbl-liter-situacao-das-importacoes-toda at 30.
           END. 
    
    if tt-param.i-un-quantidade = 2 then /*Fornecedor*/
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-unidade-medida-e-quantidade-fo AS CHARACTER FORMAT "X(41)" NO-UNDO.
        {utp/ut-liter.i "Unidade_Medida_e_Quantidade:_Fornecedor" *}
        ASSIGN c-lbl-liter-unidade-medida-e-quantidade-fo = TRIM(RETURN-VALUE).
        put c-lbl-liter-unidade-medida-e-quantidade-fo at 30.
        END. 
    else
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-unidade-medida-e-quantidade-in AS CHARACTER FORMAT "X(38)" NO-UNDO.
        {utp/ut-liter.i "Unidade_Medida_e_Quantidade:_Interno" *}
        ASSIGN c-lbl-liter-unidade-medida-e-quantidade-in = TRIM(RETURN-VALUE).
        put c-lbl-liter-unidade-medida-e-quantidade-in at 30.
        END. 
    
/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-impressao AS CHARACTER FORMAT "X(12)" NO-UNDO.
{utp/ut-liter.i "ImpressÆo" *}
ASSIGN c-lbl-liter-impressao = TRIM(RETURN-VALUE).
put skip(2)
    c-lbl-liter-impressao + ":" at 20 skip.
    if tt-param.destino = 1 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-impressora AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "Impressora" *}
        ASSIGN c-lbl-liter-impressora = TRIM(RETURN-VALUE).
        put c-lbl-liter-impressora + ": " at 30 tt-param.arquivo.
        END. 
    else
       if tt-param.destino = 2 then    
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-arquivo AS CHARACTER FORMAT "X(11)" NO-UNDO.
          {utp/ut-liter.i "Arquivo" *}
          ASSIGN c-lbl-liter-arquivo = TRIM(RETURN-VALUE).
          put c-lbl-liter-arquivo + ": "  at 30 tt-param.arquivo .
          END. 
       else /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-terminal AS CHARACTER FORMAT "X(10)" NO-UNDO.
     {utp/ut-liter.i "Terminal" *}
     ASSIGN c-lbl-liter-terminal = TRIM(RETURN-VALUE).
     put c-lbl-liter-terminal at 30.
 END. 
    
end.

for each tt-imprime-registro:
   delete tt-imprime-registro.
end.

/******** FIM DA LOGICA **********************************************/

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.

/* FIM  */
