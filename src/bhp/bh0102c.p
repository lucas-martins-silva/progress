/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0102C 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Bh0102c MBH}
&ENDIF

/**************************************************************************
**
**  Programa: BH0102C.P
**
**  Data....: JULHO DE 1997
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Transferencia para Banco de Movimentos - Caixa e Bancos
**
******************************************************************************/

define temp-table w-per
    field i-emp  like empresa.ep-codigo
    field c-mod  as char format "x(02)"
    field da-per as date format "99/99/9999".

def new global shared var c-arqtrans as character no-undo.

def output parameter i-registro as int format ">>>,>>9".
def input parameter da-corte   as date format "99/99/9999".
def input parameter i-empresa  like empresa.ep-codigo.

def var h-acomp           as handle                  no-undo.
def var i-cont            as integer                 no-undo.
def var de-saldo-ini   like cta-corrente.saldo-ini   no-undo.
def var de-saldo-atual like cta-corrente.saldo-atual no-undo.


for each w-per exclusive-lock:
    delete w-per.
end.


run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Importando...").

/*----  Movimentos da Conta corrente e Extrato bancario -----*/

for each cta-corrente use-index empresa
    where cta-corrente.ep-codigo = i-empresa NO-LOCK:
    {cdp/cd9910.i i-cont}

    for each hisadm.movto-banco use-index nr-docto
       where hisadm.movto-banco.banco        = cta-corrente.cod-banco
       and   hisadm.movto-banco.agencia      = cta-corrente.agencia
       and   hisadm.movto-banco.cta-corrente = cta-corrente.conta-corren
       and   hisadm.movto-banco.dt-movto    >= da-corte exclusive-lock:
       


       {bhp/bh9801.i &area=adm &arqmov=movto-banco}

        /*-------------- Eliminacao da tabela de locks -----------------------*/
        find first his-movto-banco EXCLUSIVE-LOCK
             where his-movto-banco.banco        = hisadm.movto-banco.banco
             and   his-movto-banco.agencia      = hisadm.movto-banco.agencia
             and   his-movto-banco.cta-corrente = hisadm.movto-banco.cta-corrente
             and   his-movto-banco.cod-docto    = hisadm.movto-banco.cod-docto
             and   his-movto-banco.nr-docto-emp = hisadm.movto-banco.nr-docto-emp
             and   his-movto-banco.dt-movto   = hisadm.movto-banco.dt-movto
             no-error.

        if  avail his-movto-banco then
            delete his-movto-banco validate(true,"").
        /*--------------------------------------------------------------------*/

        {bhp/bh0102.i CB hisadm.movto-banco.dt-movto}
        delete hisadm.movto-banco.
        assign i-registro = i-registro + 1.
    end.

    for each extrato-banco EXCLUSIVE-LOCK
        where extrato-banco.banco        = cta-corrente.cod-banco
        and   extrato-banco.agencia      = cta-corrente.agencia
        and   extrato-banco.cta-corrente = cta-corrente.conta-corren :

        for each hisadm.movto-ext-banco EXCLUSIVE-LOCK use-index nr-docto
            where hisadm.movto-ext-banco.banco        = extrato-banco.banco
            and   hisadm.movto-ext-banco.agencia      = extrato-banco.agencia
            and   hisadm.movto-ext-banco.cta-corrente = extrato-banco.cta-corrente
            and   hisadm.movto-ext-banco.nr-extrato   = extrato-banco.nr-extrato
            and   hisadm.movto-ext-banco.dt-movto     >= da-corte
            :

            {bhp/bh9801.i &area=adm &arqmov=movto-ext-banco}
            {bhp/bh0102.i CB hisadm.movto-ext-banco.dt-movto}
            delete hisadm.movto-ext-banco.
            assign i-registro = i-registro + 1.
        end.
        assign extrato-banco.dt-inicio = da-corte.
    end.
end.


/*---   Aplicacoes, Emprestimos  e Extratos ------*/

for each hisadm.aplic-emprestimo use-index saldo
    where hisadm.aplic-emprestimo.ep-codigo    = i-empresa
    and   hisadm.aplic-emprestimo.vl-corrigido = 0
    no-lock:
    {cdp/cd9910.i i-cont}
    for each hisadm.movto-aplic-empr EXCLUSIVE-LOCK use-index data
        where hisadm.movto-aplic-empr.ep-codigo   = i-empresa
        and   hisadm.movto-aplic-empr.banco       = hisadm.aplic-emprestimo.banco
        and   hisadm.movto-aplic-empr.agencia     = hisadm.aplic-emprestimo.agencia
        and   hisadm.movto-aplic-empr.cod-mod     = hisadm.aplic-emprestimo.cod-mod
        and   hisadm.movto-aplic-empr.dt-movto    >= da-corte
        and   hisadm.movto-aplic-empr.nr-aplicacao = hisadm.aplic-emprestimo.nr-aplicacao:
        {bhp/bh9801.i &area=adm &arqmov=movto-aplic-empr}
        {bhp/bh0102.i CB hisadm.movto-aplic-empr.dt-movto}
        delete hisadm.movto-aplic-empr.
        assign i-registro = i-registro + 1.
    end.
    
    for each hisadm.movto-ext-aplic EXCLUSIVE-LOCK use-index data
        where hisadm.movto-ext-aplic.ep-codigo    = i-empresa
        and   hisadm.movto-ext-aplic.banco        = hisadm.aplic-emprestimo.banco
        and   hisadm.movto-ext-aplic.agencia      = hisadm.aplic-emprestimo.agencia
        and   hisadm.movto-ext-aplic.cod-mod      = hisadm.aplic-emprestimo.cod-mod
        and   hisadm.movto-ext-aplic.nr-aplicacao = hisadm.aplic-emprestimo.nr-aplicacao
        and   hisadm.movto-ext-aplic.dt-movto     >= da-corte:
        {bhp/bh9801.i &area=adm &arqmov=movto-ext-aplic}
        {bhp/bh0102.i CB hisadm.movto-ext-aplic.dt-movto}
        delete hisadm.movto-ext-aplic.
        assign i-registro = i-registro + 1.
    end.
end.

/*------  Previsoes de Aplicacoes e Emprestimos  ------*/

for each hisadm.movto-aplic-empr use-index dt-movto
    where hisadm.movto-aplic-empr.ep-codigo     = i-empresa
    and   hisadm.movto-aplic-empr.dt-movto     >= da-corte exclusive-lock:
    {cdp/cd9910.i i-cont}
    {bhp/bh9801.i &area=adm &arqmov=movto-aplic-empr}
    {bhp/bh0102.i CB hisadm.movto-aplic-empr.dt-movto}
    delete hisadm.movto-aplic-empr.
    assign i-registro = i-registro + 1.
end.

/*------ Atualiza‡Æo do Saldo da Conta Corrente -----*/
for each  cta-corrente
    where cta-corrente.ep-codigo = i-empresa
    exclusive-lock:

    assign de-saldo-ini = cta-corrente.saldo-ini.
    for each movadm.movto-banco use-index nr-docto
       where movadm.movto-banco.banco        = cta-corrente.cod-banco
       and   movadm.movto-banco.agencia      = cta-corrente.agencia
       and   movadm.movto-banco.cta-corrente = cta-corrente.conta-corren
       and   movadm.movto-banco.dt-movto    <= cta-corrente.data-saldo
       and   movadm.movto-banco.dt-movto    >= da-corte no-lock:
 
       /*--- Os valores na conta-corrente devem ser invertidos ----*/
       assign de-saldo-ini = de-saldo-ini
                           - movadm.movto-banco.valor-movto.
    end.

    for each  extrato-banco
        where extrato-banco.banco        = cta-corrente.cod-banco
        and   extrato-banco.agencia      = cta-corrente.agencia
        and   extrato-banco.cta-corrente = cta-corrente.conta-corren
        no-lock :
        for each  movadm.movto-ext-banco use-index nr-docto
            where movadm.movto-ext-banco.banco        = extrato-banco.banco
            and   movadm.movto-ext-banco.agencia      = extrato-banco.agencia
            and   movadm.movto-ext-banco.cta-corrente = extrato-banco.cta-corrente
            and   movadm.movto-ext-banco.nr-extrato   = extrato-banco.nr-extrato
            and   movadm.movto-ext-banco.dt-movto     <= cta-corrente.data-saldo
            and   movadm.movto-ext-banco.dt-movto     >= da-corte
            no-lock:
            /*--- Os valores na conta-corrente devem ser invertidos ----*/
            assign de-saldo-atual = de-saldo-atual
                                  - movadm.movto-ext-banco.vl-movto.
        end.
    end.
    assign cta-corrente.data-saldo  = da-corte
           cta-corrente.saldo-ini   = de-saldo-ini
           cta-corrente.saldo-atual = de-saldo-atual. 
end.

for each w-per:
    find first bh-periodos EXCLUSIVE-LOCK where
               bh-periodos.ep-codigo = w-per.i-emp and
               bh-periodos.modulos   = w-per.c-mod no-error.
    if  not avail bh-periodos then do:
        create bh-periodos.
        assign bh-periodos.ep-codigo = w-per.i-emp
               bh-periodos.modulos   = w-per.c-mod
               bh-periodos.area      = "A".
    end.
    assign bh-periodos.periodo = w-per.da-per - 1.
end.

if valid-handle(h-acomp) then
    run pi-finalizar in h-acomp.


/*  BH0102C.P  */

