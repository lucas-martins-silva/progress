/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9011A 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9011a MIM}
&ENDIF

/*****************************************************************************
**
** im9011a - Integra‡Æo entre Importa‡Æo e Contas a Pagar (EMS)
**
** Objetivo: Atualizar o valor do t¡tulo apenas com a quantidade que foi nacionalizada
**
******************************************************************************/

{cdp/cdcfgmat.i} /* Pre-processador para execucao magnus */
{include/i-epc200.i IM9011A} /* definicao referente a UPC */
&if defined(bf-mat-comex) &then
&else

{utp/ut-glob.i} /* Defini‡Æo Vari veis Globais */
{include/boerrtab.i} /* Defini‡Æo Temp-table de Erros */

def input parameter p-cod-estabel   like estabelec.cod-estabel no-undo.
def input parameter p-embarque      like embarque-imp.embarque no-undo.
/*
** p-fator-atualiz: fator de atualiza‡Æo do valor do t¡tulo do embarque original  
                    p-fator-atualiz * valor do t¡tulo = valor do ava
*/
def input parameter p-fator-atualiz as   decimal               no-undo.
def output parameter table for tt-bo-erro.

/*
** Defini‡Æo da temp-table tt-erro 
*/
{cdp/cd0666.i} 

{app/ap9100.i}
{app/ap9100.i1}

def var c-conta-contab   like mov-ap.conta-contabil no-undo. 
def var c-ct-conta       like mov-ap.ct-conta       no-undo.
def var c-sc-conta       like mov-ap.sc-conta       no-undo.  

def var i-lancto        as   integer            no-undo.
def var de-valor-ava    like tit-ap.vl-original no-undo.
def var de-valor-ava-me like tit-ap.vl-original no-undo.

/*variavel epc c-esp-tit-tranist*/
DEF VAR c-esp-tit-transit LIKE param-imp.esp-tit-transit NO-UNDO.


find first param-global no-lock no-error.

find first param-imp 
    where param-imp.cod-estabel = p-cod-estabel no-lock no-error. 

for first conta-contab fields(ct-codigo sc-codigo)
    where conta-contab.ep-codigo      = param-global.empresa-prin 
      and conta-contab.conta-contabil = param-imp.conta-transit-import no-lock:
end.       

assign c-conta-contab = param-imp.conta-transit-import
       c-ct-conta     = conta-contab.ct-codigo
       c-sc-conta     = conta-contab.sc-codigo.
    
find embarque-imp 
    where embarque-imp.cod-estabel = p-cod-estabel 
      and embarque-imp.embarque    = p-embarque no-lock no-error.
      
if not avail embarque-imp or embarque-imp.contabilizado = no then
    next.
    
for first ordens-embarque fields(numero-ordem)
    where ordens-embarque.cod-estabel = p-cod-estabel
      and ordens-embarque.embarque    = p-embarque no-lock:
    for first ordem-compra fields(cod-emitente)
        where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock:
    end.      
end.         

ASSIGN c-esp-tit-transit = param-imp.esp-tit-transit.

{include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                     &CodParameter='"cod-estabel"'
                     &ValueParameter="p-cod-estabel"}

{include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                     &CodParameter='"embarque"'
                     &ValueParameter="p-embarque"}

{include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                     &CodParameter='"cod-fornec"'
                     &ValueParameter="string(ordem-compra.cod-emitente)"}

{include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                     &CodParameter='"esp-tit-transit"'
                     &ValueParameter="c-esp-tit-transit"}
/*Include i-epc201.i: Chamada do programa de EPC */
{include/i-epc201.i "AlteraEspecieTitulo"}

if c-nom-prog-dpc-mg97  <> "" or
   c-nom-prog-appc-mg97 <> "" or 
   c-nom-prog-upc-mg97  <> "" then do:

    find first tt-epc where 
               tt-epc.cod-event = "AlteraEspecieTitulo" and
               tt-epc.cod-parameter = "esp-tit-transit"
               no-error.
    if avail tt-epc then
       assign c-esp-tit-transit = tt-epc.val-parameter.

    for each tt-epc:
        delete tt-epc.
    end.
end.                                        

for each tit-ap 
    where tit-ap.ep-codigo   = i-ep-codigo-usuario
      and tit-ap.cod-fornec  = ordem-compra.cod-emitente
      and tit-ap.cod-estabel = p-cod-estabel
      and tit-ap.cod-esp     = c-esp-tit-transit
      and tit-ap.serie       = " "
      and tit-ap.nr-docto    = p-embarque exclusive-lock:
                       
    /* 
    ** 1 - debito 
    ** 2 - credito
    */
    assign i-lancto = 2.

    /* 
    ** cria‡Æo do AVA 
    */
    assign de-valor-ava    = tit-ap.vl-original * p-fator-atualiz
           de-valor-ava-me = tit-ap.vl-orig-me  * p-fator-atualiz.           
    
    create mov-ap.
    assign mov-ap.ep-codigo      = tit-ap.ep-codigo
           mov-ap.cod-estabel    = tit-ap.cod-estabel
           mov-ap.cod-esp        = tit-ap.cod-esp
           mov-ap.serie          = tit-ap.serie
           mov-ap.nr-docto       = tit-ap.nr-docto
           mov-ap.parcela        = tit-ap.parcela
           mov-ap.cod-fornec     = tit-ap.cod-fornec
           mov-ap.transacao      = 5 /* AVA */
           mov-ap.dt-today       = TODAY
           mov-ap.dt-transacao   = TODAY
           mov-ap.dt-emissao     = tit-ap.dt-emissao
           mov-ap.dt-vencimen    = tit-ap.dt-vencimen
           mov-ap.nome-abrev     = tit-ap.nome-abrev
           mov-ap.portador       = tit-ap.portador
           mov-ap.modalidade     = tit-ap.modalidade
           mov-ap.referencia     = tit-ap.referencia
           mov-ap.contabilizou   = no
           mov-ap.tipo           = tit-ap.tipo
           mov-ap.usuario        = c-seg-usuario
           mov-ap.c-time         = string(time, "HH:MM")
           mov-ap.conta-contabil = c-conta-contab
           mov-ap.ct-conta       = c-ct-conta
           mov-ap.sc-conta       = c-sc-conta
           mov-ap.vl-original    = tit-ap.vl-original
           mov-ap.valor-mov      = de-valor-ava
           mov-ap.impostos       = yes
           mov-ap.tp-codigo      = tit-ap.tp-codigo
           mov-ap.lancamento     = i-lancto.

    {utp/ut-liter.i Altera‡Æo_t¡tulo_gerado_pelo_desembarque_parcial. * R}
    assign mov-ap.historico = trim(return-value).
            
    /*-------------- Multi-Moeda ---------------*/
    
    find cotacao
        where cotacao.mo-codigo   = tit-ap.moeda
          and cotacao.ano-periodo = string(year(tit-ap.dt-emissao))
                                  + string(month(tit-ap.dt-emissao),"99")
          and cotacao.cotacao[int(day(tit-ap.dt-emissao))] <> 0 no-lock no-error.

    if avail cotacao then
        assign mov-ap.cotacao-dia = cotacao.cotacao[int(day(tit-ap.dt-emissao))].
    else
        assign mov-ap.cotacao-dia = 1.
    
    assign mov-ap.moeda          = tit-ap.moeda
           mov-ap.vl-orig-me     = tit-ap.vl-orig-me
           mov-ap.valor-mov-me   = de-valor-ava-me.
            
    /*--- Lote Gerado Pelo MultiPlanta ---*/
    
    find doc-i-ap 
        where doc-i-ap.ep-codigo  = tit-ap.ep-codigo
          and doc-i-ap.referencia = tit-ap.referencia no-lock no-error.
    
    if  avail doc-i-ap and doc-i-ap.log-2 = yes then do:
        assign mov-ap.flag-contab  = no 
               mov-ap.contabiliza  = no
               mov-ap.contabilizou = no
               mov-ap.origem       = 3.
    end.

    /*-------- INTEGRA°†ES ---------*/
    {app/ap9100.i2}
    assign tt-integ-ap.tt-row-tit-ap  = rowid(tit-ap)
           tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
           tt-integ-ap.tt-cb0201a     = yes
           tt-integ-ap.tt-ge0102b     = yes
           tt-integ-ap.tt-ge0102g     = yes
           tt-integ-ap.tt-cb1202a     = yes       
           tt-integ-ap.tt-op-cb0201a  = 16
           tt-integ-ap.tt-op-ge0102b  = 16
           tt-integ-ap.tt-op-ge0102g  = 16
           tt-integ-ap.tt-op-cb1202a  = 21.
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (Input raw-integracao, input-output table tt-erro).    

    assign tit-ap.valor-saldo = tit-ap.valor-saldo - de-valor-ava
           tit-ap.vl-saldo-me = tit-ap.vl-saldo-me - de-valor-ava-me.
           
end.           

&endif
