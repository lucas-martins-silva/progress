/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0661RP 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0661rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: im0661rp.p
**
**       DATA....: Julho DE 2001
**
**       Objetivo: Relat¢rio por Produto e Exportador
**
**       VERSAO..: 2.00.00.000 - Rodrigo Frank
**
******************************************************************************/
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/i-rpvar.i} 

def var h-acomp             as handle  no-undo.
def var c-acompanha         as char    no-undo.
def var c-lb-item           as char format "x(04)" no-undo.
def var c-lb-descr          as char format "x(09)" no-undo.
def var c-lb-un             as char format "x(06)" no-undo.
def var c-lb-fornecedor     as char format "x(10)" no-undo.
def var c-lb-interno        as char format "x(10)" no-undo.
def var c-lb-moeda          as char format "x(05)" no-undo.
def var c-lb-totais         as char format "x(06)" no-undo.
def var c-lb-selecao        as char format "x(07)" no-undo.
def var c-lb-estabel        as char format "x(15)" no-undo.
def var c-lb-exportador     as char format "x(10)" no-undo.
def var c-lb-desc           as char format "x(09)" no-undo.
def var c-lb-periodo        as char format "x(07)" no-undo.
def var c-lb-cotacao        as char format "x(12)" no-undo.
def var c-lb-parametros     as char format "x(10)" no-undo.
def var c-lb-impressao      as char format "x(09)" no-undo.
def var c-lb-destino        as char format "x(07)" no-undo.
def var c-lb-opcao          as char format "x(40)" no-undo.
def var i-mes               as int                 no-undo.
def var i-mes-faixa         as int                 no-undo.
def var i-mes-faixa-bck     as int                 no-undo.
def var i-cont              as int                 no-undo.
def var c-lb-mes            as char format "x(03)" extent 12.
def var c-mo-sigla          like moeda.sigla       no-undo.
def var i-cont-1            as int                 no-undo.
def var de-quant-mes        as int format ">>>>>>9" extent 12 no-undo.
def var de-quant            as int format ">>>>>>9" no-undo.
def var de-total-quant      as int format ">>>>>>>>>9" no-undo.
def var de-total-preco      as int format ">>>>>>>>>9" no-undo.
def var de-preco-total      as int format ">>>>>>9" no-undo.
def var de-preco-total-mes  as int format ">>>>>>9" extent 12 no-undo.
def var aux                 as int                 no-undo.
def var de-preco-convertido as int format ">>>>>>9" no-undo.

{cdp/cd4300.i3}
{rep/re1001a.i50}  /* variaveis e informacoes utilizadas pelo re1001a.i51 */    

/*>>>>>>>9.99*/

{imp/im0661.i}  /** Defini‡Æo de temp table */
{imp/im0661.i1} /**Defini‡Æo de frames *****/

/***************************Defini‡Æo de Parƒmetros *****************************/

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def buffer b-emitente for emitente.
def buffer b1-emitente for emitente.
def buffer b-historico-w for historico-embarque.
def buffer b1-historico-embarque for historico-embarque.
def buffer b2-historico-embarque for historico-embarque.

/****************************** L i t e r a i s **********************************/

{utp/ut-liter.i Item * R}
assign c-lb-item = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-lb-descr = trim(return-value).

{utp/ut-liter.i Moeda * R}
assign c-lb-moeda = trim(return-value).

{utp/ut-liter.i Imprime * R}
assign c-lb-opcao = trim(return-value).
{utp/ut-liter.i Unidade * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i de * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i Medida * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i Quantidade * R}
assign c-lb-opcao = c-lb-opcao + ", " + trim(return-value) + ":".

{utp/ut-liter.i Fornecedor * R}
assign c-lb-fornecedor = trim(return-value).

{utp/ut-liter.i Internos * R}
assign c-lb-interno = trim(return-value).

{utp/ut-liter.i Un * R}
assign c-lb-un = trim(return-value).

{utp/ut-liter.i Totais * R}
assign c-lb-totais = trim(return-value).

/****************************** E X E C U € Ç O **********************************/
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa     = "im0661"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Relat¢rio por Produto e Exportador"
       c-sistema      = "Com‚rcio Exterior".      

&if defined(bf-mat-comex) &then
    {cdp/cd-rpout.i} /* include customizada Magnus */
&else    
    {include/i-rpout.i}
&endif

assign i-cont = 1
       i-mes-faixa = month(tt-param.data-periodo-ini)
       i-mes-faixa-bck = month(tt-param.data-periodo-ini).  
       
do i-mes = month(tt-param.data-periodo-ini) to (12 + month(tt-param.data-periodo-fim)):
    
   if i-mes = 1 then do:
      {utp/ut-liter.i jan * R}   
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 2 then do:
      {utp/ut-liter.i Fev * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 3 then do:
      {utp/ut-liter.i Mar * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 4 then do:
      {utp/ut-liter.i Abr * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end. 
   if i-mes = 5 then do:
      {utp/ut-liter.i Mai * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 6 then do:
      {utp/ut-liter.i Jun * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 7 then do:
      {utp/ut-liter.i Jul * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 8 then do:
      {utp/ut-liter.i Ago * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 9 then do:
      {utp/ut-liter.i Set * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 10 then do:
      {utp/ut-liter.i Out * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.
   if i-mes = 11 then do:
      {utp/ut-liter.i Nov * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end. 
   if i-mes = 12 then do:
      {utp/ut-liter.i Dez * R}
      assign c-lb-mes[i-cont] = trim(return-value).
   end.   

   if i-mes = month(tt-param.data-periodo-fim) then do:
      leave.
   end.

   if i-mes = 12 then do:
      i-mes = 0.
   end.
       
   assign i-cont = i-cont + 1.   
end.

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-acompanha).


/************************************* LOGICA PROPRIAMENTE DITA ***********************************/


for each docum-est where
         docum-est.cod-estabel    >= tt-param.cod-estabel-ini  and
         docum-est.cod-estabel    <= tt-param.cod-estabel-fim  and
         docum-est.dt-emissao     >= tt-param.data-periodo-ini and
         docum-est.dt-emissao     <= tt-param.data-periodo-fim no-lock:
         
         &if defined(bf-mat-comex) &then
             IF SUBSTRING(docum-est.char-1,2,12) = "" THEN NEXT.
             ASSIGN c-embarque = SUBSTRING(docum-est.char-1,2,12).
         &else
             {cdp/cd4300.i4   "yes" docum-est.char-1}
             {rep/re1001a.i51 "yes"}
              IF c-embarque = "" THEN NEXT.
         &endif

         find emitente where
              emitente.cod-emitente   = docum-est.cod-emitente  and
              emitente.nome-abrev    >= tt-param.nome-exportador-ini and
              emitente.nome-abrev    <= tt-param.nome-exportador-fim no-lock no-error.
         
         if not avail emitente then next.
         run pi-acompanhar in h-acomp(input docum-est.nro-docto).

            find moeda where
                 moeda.mo-codigo = tt-param.mo-codigo no-lock no-error.

            assign c-mo-sigla = if avail moeda then moeda.sigla else "".
            
         for each item-doc-est where
                  item-doc-est.serie-docto  =  docum-est.serie-docto  and
                  item-doc-est.nro-docto    =  docum-est.nro-docto    and
                  item-doc-est.cod-emitente =  docum-est.cod-emitente and
                  item-doc-est.nat-operacao =  docum-est.nat-operacao and
                  item-doc-est.it-codigo    >= tt-param.it-codigo-ini and
                  item-doc-est.it-codigo    <= tt-param.it-codigo-fim and
                  ((item-doc-est.quantidade > 0 and tt-param.i-opcao = 1) or
                  (item-doc-est.qt-do-forn > 0 and tt-param.i-opcao = 2)) NO-LOCK
                  break by item-doc-est.it-codigo:    
                       
                  find item where
                       item.it-codigo  = item-doc-est.it-codigo and
                       &if defined(bf-mat-comex) &then
                           item.descricao-1  >= tt-param.desc-item-ini and
                           item.descricao-1  <= tt-param.desc-item-fim 
                       &else    
                           item.desc-item >= tt-param.desc-item-ini and
                           item.desc-item <= tt-param.desc-item-fim 
                       &endif
                       no-lock no-error.      
                  
                  if not avail item then next.

                  create tt-item.
                  assign tt-item.embarque      = c-embarque
                         tt-item.cod-estabel   = docum-est.cod-estabel
                         tt-item.nro-docto     = item-doc-est.nro-docto
                         tt-item.it-codigo     = item-doc-est.it-codigo
                         tt-item.cod-emitente  = item-doc-est.cod-emitente
                         tt-item.quantidade    = if tt-param.i-opcao = 1 then item-doc-est.quantidade else item-doc-est.qt-do-forn
                         tt-item.dt-emissao    = docum-est.dt-emissao
                         tt-item.preco         = item-doc-est.preco-total[1]
                         tt-item.sigla         = c-mo-sigla
                         tt-item.nome-abrev    = emitente.nome-abrev
                         tt-item.un            = item-doc-est.un
                         &if defined(bf-mat-comex) &then
                             tt-item.desc-item = item.descricao-1 + item.descricao-2
                             tt-item.mo-codigo = 0.
                         &else
                             tt-item.desc-item = item.desc-item                         
                             tt-item.mo-codigo = docum-est.mo-codigo.
                         &endif
                         
                  end.
end.


{imp/im0661.i2}

if tt-param.l-imprime-parametro then do:
    {utp/ut-liter.i SELE€ÇO * R}
    assign c-lb-selecao = trim(return-value).
    {utp/ut-liter.i Estabelecimento * R}
    assign c-lb-estabel = trim(return-value).    
    {utp/ut-liter.i Exportador * R}
    assign c-lb-exportador = trim(return-value).    
    {utp/ut-liter.i Item * R}
    assign c-lb-item = trim(return-value).    
    {utp/ut-liter.i Per¡odo * R}
    assign c-lb-periodo = trim(return-value).    
    {utp/ut-liter.i Descri‡Æo * R}
    assign c-lb-desc = trim(return-value).    
    {utp/ut-liter.i PARÇMETROS * R}
    assign c-lb-parametros = trim(return-value).    
    {utp/ut-liter.i Data_Cota‡Æo * R}
    assign c-lb-cotacao = trim(return-value).    
    {utp/ut-liter.i Data_Cota‡Æo * R}
    assign c-lb-cotacao = trim(return-value).    
    {utp/ut-liter.i IMPRESSÇO * R}
    assign c-lb-impressao = trim(return-value).    
    {utp/ut-liter.i Destino * R}
    assign c-lb-destino = trim(return-value).    
    
    page.    

    put skip(2)
        c-lb-selecao at 05 skip
        c-lb-estabel    at 05 ": "  tt-param.cod-estabel-ini  " |<>| " at 58 tt-param.cod-estabel-fim skip
        c-lb-exportador at 05 ".....: "  tt-param.nome-exportador-ini format "x(12)" " |<>| " at 58 tt-param.nome-exportador-fim format "x(12)" skip
        c-lb-item       at 05 "...........: "  tt-param.it-codigo-ini format "x(16)" " |<>| " at 58 tt-param.it-codigo-fim format "x(16)" skip
        c-lb-desc       at 05 "......: "  tt-param.desc-item-ini format "x(36)" " |<>| " tt-param.desc-item-fim format "x(36)" skip
        c-lb-periodo    at 05 "........: "  tt-param.data-periodo-ini " |<>| " at 58 tt-param.data-periodo-fim skip.
         
   put skip(2) c-lb-parametros at 05 skip         
       c-lb-moeda at 05 "..........: " tt-param.mo-codigo format "99" skip
       c-lb-cotacao at 05 "...: " tt-param.data-cotacao skip
       c-lb-opcao at 05 if tt-param.i-opcao = 1 then c-lb-interno else c-lb-fornecedor format "x(15)".  
   
   put skip(2) c-lb-impressao at 05
       c-lb-destino at 05 "........: " tt-param.destino format "9"
       " - " tt-param.arquivo format "x(30)".   
   

end.

/******** FIM DA LOGICA **********************************************/

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.

/*************************** Procedures Internas ********************/

/* FIM  */

