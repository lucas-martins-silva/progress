/*******************************************************************************
**
**  Include.: AP0708.I
**  Objetivo: ImpressÆo da parametriza‡Æo utilizada no relat¢rio
**
*******************************************************************************/

{utp/ut-liter.i SELE€ÇO * R}
assign c-text-1 = trim(return-value).
{utp/ut-liter.i CLASSIFICA€ÇO * R}
assign c-text-2 = trim(return-value).
{utp/ut-liter.i PAR¶METROS * R}
assign c-text-3 = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * R}
assign c-text-4 = trim(return-value).

{utp/ut-field.i mgadm mov-ap cod-estabel 1}
assign tt-param.estab-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap cod-esp 1}
assign tt-param.espec-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap dt-transacao 1}
assign tt-param.dt-transac-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap conta-contabil 1}
assign tt-param.conta-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap referencia 1}
assign tt-param.refer-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap portador 1}
assign tt-param.portador-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap cod-fornec 1}
assign tt-param.forn-ini:label in frame f-parametros = return-value.
/*{utp/ut-liter.i … * L}
 * assign tt-param.estab-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.espec-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.dt-transac-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.conta-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.refer-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.portador-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.forn-fim:label in frame f-parametros = trim(return-value).*/

{utp/ut-liter.i Gerar_Dados_do_Demonstrativo * L}
assign tt-param.l-geracao:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Moeda * L}
assign c-moeda:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Tipo * L}
assign c-tipo-rel:label in frame f-parametros = trim(return-value).

if  tt-param.moeda = 1 then {utp/ut-liter.i Normal * L}
    else if  tt-param.moeda = 2 then {utp/ut-liter.i FASB * L}
        else {utp/ut-liter.i CMCAC * L}.
assign c-moeda = trim(return-value).

if  tt-param.tipo = 1
    then {utp/ut-liter.i Resumido * L}
    else {utp/ut-liter.i Detalhado * L}.
assign c-tipo-rel = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value)
       c-destino = {varinc/var00002.i 04 tt-param.destino}.
       
       
if tt-param.refer-fim = "}}}}}}}}}}" then
    assign tt-param.refer-fim = "ZZZZZZZZZZ".       

if  page-number > 0 then page.
display c-text-1
        tt-param.estab-ini
        tt-param.estab-fim
        tt-param.espec-ini
        tt-param.espec-fim
        tt-param.dt-transac-ini
        tt-param.dt-transac-fim
        tt-param.conta-ini
        tt-param.conta-fim
        tt-param.refer-ini
        tt-param.refer-fim
        tt-param.portador-ini
        tt-param.portador-fim
        tt-param.forn-ini
        tt-param.forn-fim
        c-text-2
        tt-param.text-classif
        c-text-3
        c-moeda
        c-tipo-rel
        c-text-4
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

if  tt-param.l-geracao = yes then {utp/ut-liter.i Sim * R} else {utp/ut-liter.i NÆo * R}.
disp trim(return-value) @ tt-param.l-geracao with frame f-parametros.

down with frame f-parametros.

/* AP0708.I */
