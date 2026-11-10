/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400H 2.00.00.011 } /*** "010011" 14/11/2025 16:15:33 ***/
/* ---------------------[ VERSAO ]-------------------- */
/*****************************************************************************
**
**       Programa: cd0812.p
**
**       Data....: julho de 1990
**
**       Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**       Objetivo: conversao de moeda.
**                 deve ser executado da seguinte maneira.
**                 run imp/im0400.p (input i-mo-origem, input i-mo-destino,
**                                   input de-vl-origem, input da-dt-cotacao,
**                                   output de-vl-convertido).
**
**       Versao..: A.00 - MC
**                 A.01 - LAM
**
*****************************************************************************/
{cdp/cdcfgfin.i}
{cdp/cd1234.i}
{cdp/cd1234.i2}

def input parameter i-num-di-ems    like decla-import.num-di-ems NO-UNDO.
def input parameter de-cdd-siscomex-dts    like decla-import.cdd-siscomex-dts NO-UNDO.
def input parameter i-mo-origem     like cotacao.mo-codigo NO-UNDO.
def input parameter i-mo-destino    like cotacao.mo-codigo NO-UNDO.
def input parameter de-vl-origem      as DECIMAL NO-UNDO.
def input parameter da-dt-cotacao     as DATE NO-UNDO.
def output parameter de-vl-convertido as DECIMAL NO-UNDO.

def var i-dia         as integer.
def var c-periodo   like cotacao.ano-periodo.
def var de-ct-origem  as decimal init 0.
def var de-ct-destino as decimal init 0.
def var da-data-conv  as date no-undo.
def var de-fator      as decimal no-undo.
def var da-data-fator as date no-undo.

def var c-versao as character init "F.00" no-undo.


c-periodo = string(year(da-dt-cotacao),"9999") +
            string(month(da-dt-cotacao),"99").
i-dia = day(da-dt-cotacao).

assign da-data-conv  = 08/01/1993
       da-data-fator = 07/01/1994
       de-fator      = 2750.

if  i-mo-origem   = 0
and i-mo-destino <> 0
and da-dt-cotacao < da-data-fator then
    assign de-vl-origem = de-vl-origem * de-fator.

if  i-mo-origem   = 0
and i-mo-destino <> 0
and da-dt-cotacao < da-data-conv then
    assign de-vl-origem = de-vl-origem * 1000.

if  i-mo-origem <> 0 then do:
    find first decla-import-cotac
        where decla-import-cotac.num-di-ems = i-num-di-ems
        AND   decla-import-cotac.cdd-siscomex-dts = de-cdd-siscomex-dts
        and   decla-import-cotac.cdn-moeda  = i-mo-origem
        and   decla-import-cotac.val-cotac  > 0 no-lock no-error.
    if  avail decla-import-cotac then 
        de-ct-origem = decla-import-cotac.val-cotac.    

end.
else
    de-ct-origem = 1.
if  i-mo-destino <> 0 then do:
    find decla-import-cotac
        where decla-import-cotac.num-di-ems = i-num-di-ems
        AND   decla-import-cotac.cdd-siscomex = de-cdd-siscomex-dts
        and   decla-import-cotac.cdn-moeda  = i-mo-destino
        and   decla-import-cotac.val-cotac > 0 no-lock no-error.
    if  avail decla-import-cotac then 
        de-ct-destino = decla-import-cotac.val-cotac.
end.
else
    de-ct-destino = 1.

if  de-ct-origem = 0 or de-ct-destino = 0 then
    de-vl-convertido = ?.
else do:
    assign de-vl-convertido = fn_conv_moedas(de-vl-origem, 
                                      de-ct-origem,
                                      i-mo-origem,
                                      0).
    assign de-vl-convertido = fn_conv_moedas(de-vl-convertido,
                                      de-ct-destino,
                                      0,
                                      i-mo-destino).
end.                                      
if  i-mo-destino  = 0
and i-mo-origem  <> 0
and da-dt-cotacao < da-data-conv then
    assign de-vl-convertido = de-vl-convertido / 1000.

if  i-mo-destino  = 0
and i-mo-origem  <> 0
and da-dt-cotacao < da-data-fator then
    assign de-vl-convertido = de-vl-convertido / de-fator.
