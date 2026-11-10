/*******************************************************************************
**
**  Include.: AP0513.I
**  Objetivo: ImpressÆo da parametriza‡Æo utilizada no relat¢rio
**
*******************************************************************************/

{utp/ut-liter.i SELE€ÇO * R}
assign c-text-1 = trim(return-value).
{utp/ut-liter.i PAR¶METROS * R}
assign c-text-2 = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * R}
assign c-text-3 = trim(return-value).

{utp/ut-field.i mgadm mov-ap cod-estabel 1}
assign tt-param.estab-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap cod-esp 1}
assign tt-param.espec-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap dt-transacao 1}
assign tt-param.dt-transac-ini:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap referencia 1}
assign tt-param.refer-ini:label in frame f-parametros = return-value.
/*{utp/ut-liter.i >| * L}
 * assign tt-param.estab-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.espec-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.dt-transac-fim:label in frame f-parametros = trim(return-value)
 *        tt-param.refer-fim:label in frame f-parametros = trim(return-value).*/

{utp/ut-liter.i Consistir_Contas_Cont beis * L}
assign tt-param.l-consist:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Listar_T¡tulos_Descontabilizados * L}
assign tt-param.l-lista:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Processo * L}
assign c-processo:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Tipo * L}
assign c-tipo-rel:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Referˆncia * L}
assign c-refer:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Arquivo_Exporta‡Æo * L}
assign tt-param.arq-export:label in frame f-parametros = trim(return-value).

if  tt-param.processo = 1
    then {utp/ut-liter.i Contabilizar * L}
    else {utp/ut-liter.i Descontabilizar * L}.
assign c-processo = trim(return-value).

if  tt-param.tipo = 1
    then {utp/ut-liter.i Resumido * L}
    else {utp/ut-liter.i Aberto * L}.
assign c-tipo-rel = trim(return-value).

if  tt-param.refer = 1
    then {utp/ut-liter.i Por_Dia * L}
    else {utp/ut-liter.i Por_Per¡odo * L}.
assign c-refer = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value)
       c-destino = {varinc/var00002.i 04 tt-param.destino}.

if  page-number > 0 then page.
display c-text-1
        tt-param.estab-ini
        tt-param.estab-fim
        tt-param.espec-ini
        tt-param.espec-fim
        tt-param.dt-transac-ini
        tt-param.dt-transac-fim
        tt-param.refer-ini
        tt-param.refer-fim
        c-text-2
        c-processo
        c-tipo-rel
        c-refer
        tt-param.arq-export
        c-text-3
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

do  with frame f-parametros:
    if  tt-param.l-consist = yes then {utp/ut-liter.i Sim * R} else {utp/ut-liter.i NÆo * R}.
    disp trim(return-value) @ tt-param.l-consist.
    if  tt-param.l-lista = yes then {utp/ut-liter.i Sim * R} else {utp/ut-liter.i NÆo * R}.
    disp trim(return-value) @ tt-param.l-lista.
end.

down with frame f-parametros.

/* AP0513.I */
