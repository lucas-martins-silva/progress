/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0663RP 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0663rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: im0663rp.p
**
**       DATA....: Agosto DE 2001
**
**       Objetivo: Relat¢rio Controle de Nacionaliza‡Æo
**
**       VERSAO..: 2.00.00.000 - Rodrigo Frank
**
******************************************************************************/
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/i-rpvar.i} 

def var h-acomp           as handle  no-undo.
def var c-acompanha       as char format "x(08)" no-undo.
def var c-lb-est          as char format "x(03)" no-undo.
def var c-lb-item         as char format "x(04)" no-undo.
def var c-lb-descricao    as char format "x(09)" no-undo.
def var c-lb-quantidade   as char format "x(10)" no-undo.
def var c-lb-un           as char format "x(3)" no-undo.
def var c-lb-fornecedor   as char format "x(10)" no-undo.
def var c-lb-interno      as char format "x(10)" no-undo.
def var c-lb-embarque     as char format "x(08)" no-undo.
def var c-lb-embarque1    as char format "x(08)" no-undo.
def var c-lb-dt-prev-emb  as char format "x(08)" no-undo.
def var c-lb-dt-prev-des  as char format "x(08)" no-undo.
def var c-lb-dt-efet-emb  as char format "x(08)" no-undo.
def var c-lb-dt-efet-des  as char format "x(08)" no-undo.
def var c-lb-local        as char format "x(05)" no-undo.
def var c-lb-desembarque  as char format "x(10)" no-undo.
def var c-lb-parametros   as char format "x(10)" no-undo.
def var c-lb-impressao    as char format "x(09)" no-undo.
def var c-lb-destino      as char format "x(07)" no-undo.
def var c-lb-veiculo      as char format "x(15)" no-undo.
def var c-lb-selecao      as char format "x(07)" no-undo.
def var c-lb-estabel      as char format "x(15)" no-undo.
def var c-lb-desc         as char format "x(09)" no-undo.
def var c-lb-pto-desem    as char format "x(18)" no-undo.
def var c-lb-dt-desem     as char format "x(17)" no-undo.
def var c-lb-dt-entrad    as char format "x(10)" no-undo.
def var c-lb-veiculo-ch   as char format "x(07)" no-undo.
def var c-lb-considera    as char format "x(18)" no-undo.
def var c-lb-opcao          as char format "x(40)" no-undo.
def var c-temp-uni         as char format "x(3)" no-undo.
def var de-quant-total    as decimal format ">>>>>,>>9.9999" no-undo.

/*>>>>>>>9.99*/

{imp/im0663.i}  /** Defini‡Æo de temp table */
{imp/im0663.i1} /**Defini‡Æo de frames *****/

/***************************Defini‡Æo de Parƒmetros *****************************/

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def buffer b-historico-embarque for historico-embarque.
def buffer b1-historico-embarque for historico-embarque.

/****************************** L i t e r a i s **********************************/

{utp/ut-liter.i Item * R}
assign c-lb-item = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-acompanha = trim(return-value).

{utp/ut-liter.i Nacionaliza‡Æo * R}
assign c-lb-desembarque = trim(return-value).

{utp/ut-liter.i Est * R}
assign c-lb-est = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-lb-descricao = trim(return-value).

{utp/ut-liter.i Quantidade * R}
assign c-lb-quantidade = trim(return-value).

{utp/ut-liter.i Un * R}
assign c-lb-un = trim(return-value).

{utp/ut-liter.i Fornecedor * R}
assign c-lb-fornecedor = trim(return-value).

{utp/ut-liter.i Interno * R}
assign c-lb-interno = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-lb-embarque = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-lb-embarque1 = trim(return-value).

{utp/ut-liter.i Dt_Prev * R}
assign c-lb-dt-prev-emb = trim(return-value).

{utp/ut-liter.i Dt_Efet * R}
assign c-lb-dt-efet-emb = trim(return-value).

{utp/ut-liter.i Dt_Prev * R}
assign c-lb-dt-prev-des = trim(return-value).

{utp/ut-liter.i Dt_Efet * R}
assign c-lb-dt-efet-des = trim(return-value).
/*
{utp/ut-liter.i Ve¡culo_Transp * R}
assign c-lb-veiculo = trim(return-value).
*/
assign c-lb-veiculo = "Ve¡culo Transp":U.

{utp/ut-liter.i Local * R}
assign c-lb-local = trim(return-value).


/****************************** E X E C U € Ç O **********************************/
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa     = "im0663"
       c-versao       = "1.00"
       c-revisao      = "002"
       c-titulo-relat = "Relat¢rio Controle de Nacionaliza‡Æo"
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

/************************************* LOGICA PROPRIAMENTE DITA ***********************************/
for each ordens-embarque where
         ordens-embarque.cod-estabel >= tt-param.cod-estabel-ini and
         ordens-embarque.cod-estabel <= tt-param.cod-estabel-fim and
         ordens-embarque.embarque    >= tt-param.embarque-ini    and
         ordens-embarque.embarque    <= tt-param.embarque-fim    no-lock:

         find ordem-compra where
              ordem-compra.numero-ordem = ordens-embarque.numero-ordem and
              ordem-compra.it-codigo    >= tt-param.it-codigo-ini and
              ordem-compra.it-codigo    <= tt-param.it-codigo-fim no-lock no-error.

         if not avail ordem-compra then next.

         &IF "{&bf_mat_versao_ems}" >= "2.062" &then
             IF tt-param.veiculo-ini <> "":U             OR
                tt-param.veiculo-fim <> "ZZZZZZZZZZZZ":U OR
                tt-param.data-entrada-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF   OR
                tt-param.data-entrada-fim <> 12/31/9999 THEN DO:
                 IF param-global.log-modul-eq THEN DO:

                     FOR FIRST eq-param-embarq FIELDS(idi-veic)
                         WHERE eq-param-embarq.cod-estabel = ordens-embarque.cod-estabel NO-LOCK: END.
                     IF AVAILABLE eq-param-embarq AND
                        eq-param-embarq.idi-veic = 1 THEN
                         IF NOT CAN-FIND(eq-embarq-praz-compra WHERE
                                         eq-embarq-praz-compra.cod-estabel   = ordens-embarque.cod-estabel AND 
                                         eq-embarq-praz-compra.numero-ordem  = ordem-compra.numero-ordem   AND
                                         eq-embarq-praz-compra.cod-placa    >= tt-param.veiculo-ini        AND
                                         eq-embarq-praz-compra.cod-placa    <= tt-param.veiculo-fim        AND
                                         eq-embarq-praz-compra.dat-entr     >= tt-param.data-entrada-ini   AND
                                         eq-embarq-praz-compra.dat-entr     <= tt-param.data-entrada-fim) THEN NEXT.
                     ELSE DO:
                         FOR FIRST eq-embarq-praz-compra FIELDS(eq-embarq-praz-compra.cod-placa) NO-LOCK WHERE
                             eq-embarq-praz-compra.cod-estabel   = ordens-embarque.cod-estabel AND 
                             eq-embarq-praz-compra.numero-ordem  = ordem-compra.numero-ordem   AND
                             eq-embarq-praz-compra.dat-ent      >= tt-param.data-entrada-ini   AND
                             eq-embarq-praz-compra.dat-ent      <= tt-param.data-entrada-fim   AND
                             CAN-FIND(FIRST eq-veic WHERE eq-veic.cod-placa   = eq-embarq-praz-compra.cod-placa AND
                                                          eq-veic.cod-chassi >= tt-param.veiculo-ini AND
                                                          eq-veic.cod-chassi <= tt-param.veiculo-fim):
                         end.
                         IF NOT AVAILABLE eq-embarq-praz-compra THEN NEXT.
                     END.
                 END.
             END.
         &endif

         find item where
              item.it-codigo  = ordem-compra.it-codigo and
              &if defined(bf-mat-comex) &then
                  item.descricao-1  >= tt-param.desc-item-ini and
                  item.descricao-1  <= tt-param.desc-item-fim 
              &else    
                  item.desc-item >= tt-param.desc-item-ini and
                  item.desc-item <= tt-param.desc-item-fim 
              &endif
              no-lock no-error.

         if not avail item then next.

         find first processo-imp where
                    processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp no-lock no-error.

         if not avail processo-imp then next.
         find emitente where
              emitente.cod-emitente   = processo-imp.cod-exportador  and
              emitente.nome-abrev    >= tt-param.nome-fornecedor-ini and
              emitente.nome-abrev    <= tt-param.nome-fornecedor-fim no-lock no-error.

         if not avail emitente then next.

         FIND FIRST historico-embarque WHERE
                    historico-embarque.cod-estabel = ordens-embarque.cod-estabel AND
                    historico-embarque.embarque    = ordens-embarque.embarque    NO-LOCK NO-ERROR.

         IF NOT AVAIL historico-embarque THEN NEXT.

         find itinerario where
              itinerario.cod-itiner      = historico-embarque.cod-itiner no-lock no-error.

         for first embarque-imp fields(cdn-pto-chegad cdn-pto-embarq cdn-pto-desembar) no-lock
             where embarque-imp.cod-estab = ordens-embarque.cod-estabel
               and embarque-imp.embarque =  ordens-embarque.embarque:
         end.

         find historico-embarque where
              historico-embarque.cod-estabel    = ordens-embarque.cod-estabel and
              historico-embarque.embarque       = ordens-embarque.embarque    and
              historico-embarque.cod-itiner     = itinerario.cod-itiner       and
              historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar  no-lock no-error.

         if not avail historico-embarque then next.

         if historico-embarque.dt-efetiva = ? then do:
            release historico-embarque no-error.          
            find historico-embarque where
                 historico-embarque.cod-estabel    = ordens-embarque.cod-estabel    and
                 historico-embarque.embarque       = ordens-embarque.embarque       and
                 historico-embarque.cod-itiner     = itinerario.cod-itiner          and
                 historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar  and
                 historico-embarque.cod-pto-contr  >= tt-param.pto-desembarque-ini  and
                 historico-embarque.cod-pto-contr  <= tt-param.pto-desembarque-fim  and
                 historico-embarque.dt-previsao    >= tt-param.data-desembarque-ini and
                 historico-embarque.dt-previsao    <= tt-param.data-desembarque-fim no-lock no-error.
             if not avail historico-embarque then next.
         end.
         else do:
            release historico-embarque no-error.          
            find historico-embarque where
                 historico-embarque.cod-estabel    = ordens-embarque.cod-estabel    and
                 historico-embarque.embarque       = ordens-embarque.embarque       and
                 historico-embarque.cod-itiner     = itinerario.cod-itiner          AND
                 historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar  and
                 historico-embarque.cod-pto-contr  >= tt-param.pto-desembarque-ini  and
                 historico-embarque.cod-pto-contr  <= tt-param.pto-desembarque-fim  and
                 historico-embarque.dt-efetiva     >= tt-param.data-desembarque-ini and
                 historico-embarque.dt-efetiva     <= tt-param.data-desembarque-fim no-lock no-error.
            if not avail historico-embarque then next.         
         end. 

         release historico-embarque no-error.

         find historico-embarque where
              historico-embarque.cod-estabel    = ordens-embarque.cod-estabel and
              historico-embarque.embarque       = ordens-embarque.embarque    and
              historico-embarque.cod-itiner     = itinerario.cod-itiner       AND
              historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar  no-lock no-error.

         if not avail historico-embarque then next.

         find pto-contr where 
              pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr no-lock no-error.

         if tt-param.i-considera-nacionalizacao <> 3 then do:    
             if (historico-embarque.dt-efetiva = ?  and tt-param.i-considera-nacionalizacao = 1) or 
                (historico-embarque.dt-efetiva <> ? and tt-param.i-considera-nacionalizacao = 2) then do:
                next.      
             end.
         end.

         release historico-embarque no-error.

         find historico-embarque where
              historico-embarque.cod-estabel    = ordens-embarque.cod-estabel and
              historico-embarque.embarque       = ordens-embarque.embarque    and
              historico-embarque.cod-itiner     = itinerario.cod-itiner       AND
              historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-embarq  no-lock no-error.

         if not avail historico-embarque then next.

         /*Dados do Formecedor*/
         if tt-param.i-opcao = 2 then do:
             find cotacao-item where cotacao-item.numero-ordem = ordens-embarque.numero-ordem and
                                     cotacao-item.cot-aprovada no-lock no-error.
             assign c-temp-uni = if avail cotacao-item then cotacao-item.un else "".
         end.
         else
             assign c-temp-uni = item.un.

         run pi-acompanhar in h-acomp(input ordens-embarque.embarque).
         create tt-embarque.
         assign tt-embarque.embarque    = ordens-embarque.embarque
                tt-embarque.cod-estabel = ordens-embarque.cod-estabel
                tt-embarque.numero-ordem = ordens-embarque.numero-ordem
                tt-embarque.parcela      = ordens-embarque.parcela
                tt-embarque.it-codigo   = ordem-compra.it-codigo
                &if defined(bf-mat-comex) &then
                    tt-embarque.desc-item = string(item.descricao-1) + string(item.descricao-2)
                &else    
                    tt-embarque.desc-item = item.desc-item
                &endif
                tt-embarque.quantidade  = if tt-param.i-opcao = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-for
                tt-embarque.unidade     = c-temp-uni
                tt-embarque.nome-fornec = emitente.nome-abrev
                tt-embarque.dt-prev-emb = historico-embarque.dt-previsao
                tt-embarque.dt-efet-emb = historico-embarque.dt-efetiva.

         find b-historico-embarque where
              b-historico-embarque.cod-estabel    = ordens-embarque.cod-estabel and
              b-historico-embarque.embarque       = ordens-embarque.embarque    and
              b-historico-embarque.cod-itiner     = itinerario.cod-itiner       AND
              b-historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar  no-lock no-error.

         if avail b-historico-embarque then do:

                find pto-contr where 
                     pto-contr.cod-pto-contr = b-historico-embarque.cod-pto-contr no-lock no-error.

                assign tt-embarque.dt-prev-des = b-historico-embarque.dt-previsao
                       tt-embarque.dt-efet-des = b-historico-embarque.dt-efetiva
                       tt-embarque.local       = IF b-historico-embarque.descricao <> "":U THEN b-historico-embarque.descricao
                                                 ELSE if avail pto-contr then pto-contr.descricao else "".

                if b-historico-embarque.id-meio-transp = "" then do:
                      for each b1-historico-embarque 
                         where b1-historico-embarque.cod-estabel = b-historico-embarque.cod-estabel and
                               b1-historico-embarque.embarque    = b-historico-embarque.embarque    and
                               b1-historico-embarque.cod-itiner  = b-historico-embarque.cod-itiner  AND
                               b1-historico-embarque.sequencia   < b-historico-embarque.sequencia NO-LOCK
                               by b1-historico-embarque.sequencia descending:
                               if b1-historico-embarque.dt-efetiva <> ? then do:
                                   assign tt-embarque.veiculo-tra = b1-historico-embarque.id-meio-transp.
                                   leave.
                               end.
                      end.
                end.
                else do:
                     assign tt-embarque.veiculo-tra = b-historico-embarque.id-meio-transp.
                end.


         end.

end.

{imp/im0663.i2}


if tt-param.l-imprime-parametro then do:
    {utp/ut-liter.i SELE€ÇO * R}
    assign c-lb-selecao = trim(return-value).
    {utp/ut-liter.i Estabelecimento * R}
    assign c-lb-estabel = trim(return-value).    
    {utp/ut-liter.i Fornecedor * R}
    assign c-lb-fornecedor = trim(return-value).    
    {utp/ut-liter.i Item * R}
    assign c-lb-item = trim(return-value).    
    {utp/ut-liter.i Descri‡Æo * R}
    assign c-lb-desc = trim(return-value).    
    {utp/ut-liter.i PAR¶METROS * R}
    assign c-lb-parametros = trim(return-value).    
    {utp/ut-liter.i IMPRESSÇO * R}
    assign c-lb-impressao = trim(return-value).    
    {utp/ut-liter.i Destino * R}
    assign c-lb-destino = trim(return-value).    
    {utp/ut-liter.i Embarque * R}
    assign c-lb-embarque = trim(return-value).    
    {utp/ut-liter.i Pto_Nacionaliza‡Æo * R}
    assign c-lb-pto-desem = trim(return-value).    
    {utp/ut-liter.i Dt_Nacionaliza‡Æo * R}
    assign c-lb-dt-desem = trim(return-value).    
    {utp/ut-liter.i Considera_Embarque * R}
    assign c-lb-considera = trim(return-value).    
    {utp/ut-liter.i Dt_Entrada * R}
    assign c-lb-dt-entrad = trim(return-value).    
    {utp/ut-liter.i Ve¡culo * R}
    assign c-lb-veiculo-ch = trim(return-value).    
    {utp/ut-liter.i Imprime * R}
    assign c-lb-opcao = trim(return-value).
    {utp/ut-liter.i Unidade * R}
    assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
    {utp/ut-liter.i de * R}
    assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
    {utp/ut-liter.i Medida * R}
    assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
    {utp/ut-liter.i Quantidade * R}
    assign c-lb-opcao = c-lb-opcao + ", " + trim(return-value) + ".:".

    page.    

    put skip(2)
           c-lb-selecao     at 08 skip
           c-lb-estabel     at 08 "...: "  tt-param.cod-estabel-ini  " |<>| " at 64 tt-param.cod-estabel-fim skip
           c-lb-embarque    at 08 "..........: "  tt-param.embarque-ini     " |<>| " at 64 tt-param.embarque-fim    skip
           c-lb-fornecedor  at 08 "........: "  tt-param.nome-fornecedor-ini format "x(12)" " |<>| " at 64 tt-param.nome-fornecedor-fim format "x(12)" skip
           c-lb-pto-desem   at 08 ": "  tt-param.pto-desembarque-ini " |<>| " at 64 tt-param.pto-desembarque-fim format ">>,>>9" skip
           c-lb-item        at 08 "..............: "  tt-param.it-codigo-ini format "x(16)" " |<>| " at 64 tt-param.it-codigo-fim format "x(16)" skip
           c-lb-desc        at 08 ".........: "  tt-param.desc-item-ini format "x(36)" " |<>| " at 64 tt-param.desc-item-fim format "x(36)" skip
           c-lb-dt-desem    at 08 ".: "  tt-param.data-desembarque-ini " |<>| " at 64 tt-param.data-desembarque-fim SKIP.


    &IF "{&bf_mat_versao_ems}" >= "2.062" &then
        IF param-global.log-modul-eq THEN DO:
        PUT c-lb-veiculo-ch  AT 08 "...........: " tt-param.veiculo-ini " |<>| " at 64 tt-param.veiculo-fim SKIP
            c-lb-dt-entrad   at 08 "........: "  tt-param.data-entrada-ini " |<>| " at 64 tt-param.data-entrada-fim SKIP.
        END.
    &endif

   put skip(2) c-lb-parametros at 08 skip         
       c-lb-considera at 08 ": ".  

   if tt-param.i-considera-nacionalizacao = 1 then
       /* Inicio -- Projeto Internacional */
       DO:
       DEFINE VARIABLE c-lbl-liter-nacionalizados AS CHARACTER FORMAT "X(16)" NO-UNDO.
       {utp/ut-liter.i "Nacionalizados" *}
       ASSIGN c-lbl-liter-nacionalizados = TRIM(RETURN-VALUE).
       put c-lbl-liter-nacionalizados FORMAT "X(16)" skip.
       END. 
   else if tt-param.i-considera-nacionalizacao = 2 then
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-nao-nacionalizados AS CHARACTER FORMAT "X(20)" NO-UNDO.
            {utp/ut-liter.i "NÆo_Nacionalizados" *}
            ASSIGN c-lbl-liter-nao-nacionalizados = TRIM(RETURN-VALUE).
            put c-lbl-liter-nao-nacionalizados FORMAT "X(20)" skip.
            END. 
        else /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-todos AS CHARACTER FORMAT "X(7)" NO-UNDO.
     {utp/ut-liter.i "Todos" *}
     ASSIGN c-lbl-liter-todos = TRIM(RETURN-VALUE).
     put c-lbl-liter-todos FORMAT "X(7)" skip.
 END.  

   put c-lb-opcao at 08 if tt-param.i-opcao = 1 then c-lb-interno else c-lb-fornecedor format "x(15)". 

   put skip(2) c-lb-impressao at 08
       c-lb-destino at 08 ".............: " tt-param.destino format "9"
       " - " tt-param.arquivo format "x(30)".   


end.

/******** FIM DA LOGICA **********************************************/

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.

/*************************** Procedures Internas ********************/

/* FIM  */

