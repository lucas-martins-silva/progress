/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0301A 2.00.00.008} /*** "010008" 11/11/2025 11:26:20  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0301a MBH}
&ENDIF

/****************************************************************************
**
**    Programa: BH0301A.P
**
**    Data....: Abril de 1998
**
**    Autor...: DATASUL S.A.
**
**    Objetivo: Transferencia para Bancos Historicos - Modulos Industriais
**              (Produ‡Æo)
**
******************************************************************************/
{cdp/cdcfgmnt.i}    

def shared temp-table tt-estat-modul
    field i-sequencia as integer format 99
    field c-tabela    as char format "x(25)"
    field c-modulo    as char format "x(45)"
    field i-modulo    as integer
    index i-sequencia is unique i-sequencia ascending.

def shared var h-acomp     as handle no-undo.
def shared var i-empresa   like empresa.ep-codigo.
def shared var i-registro  as integer.
def shared var da-corte    as date format "99/99/9999".

def var i-cont             as integer.
def var c-periodo          as char    format "9999/99".
def var l-prim             as logical initial yes.

find first param-global
    no-lock no-error.

on create of movind.req-sum override do: end.

for each movind.ord-prod use-index estado
    where movind.ord-prod.estado = 8 EXCLUSIVE-LOCK TRANSACTION:
    
    
 IF CAN-FIND(FIRST hisind.ord-prod WHERE
                   hisind.ord-prod.nr-ord-produ = movind.ord-prod.nr-ord-produ) THEN
    NEXT.

    if  can-find(first movmnt.ord-manut where
                       movmnt.ord-manut.nr-ord-produ = movind.ord-prod.nr-ord-produ) THEN next.

    {cdp/cd9910.i i-cont}

    if  param-global.modulo-cs and NOT movind.ord-prod.valorizada  then
        next.

    if  movind.ord-prod.dt-inicio > da-corte then
        next.

    /**** Sem modulo de custo, nao e gerado movto-dir, movto-ggf e movto-mat *****/
    if  param-global.modulo-cs then do:

        find last movind.movto-mat use-index num-seq
            where movind.movto-mat.nr-ord-produ = movind.ord-prod.nr-ord-produ
            no-lock no-error.
        if  avail movind.movto-mat
        and movind.movto-mat.dt-trans > da-corte then
            next.

        find last movind.movto-dir use-index ordem
            where movind.movto-dir.nr-ord-produ = movind.ord-prod.nr-ord-produ
            no-lock no-error.
        if  avail movind.movto-dir
        and movind.movto-dir.dt-trans > da-corte then
            next.

        find last movind.movto-ggf use-index ordem
            where movind.movto-ggf.nr-ord-produ = movind.ord-prod.nr-ord-produ
            no-lock no-error.
        if  avail movind.movto-ggf
        and movind.movto-ggf.dt-trans > da-corte then
            next.
    end.

    if  movind.ord-prod.dt-termino > da-corte then
        next.

    
    find first tt-estat-modul where 
               tt-estat-modul.i-sequencia = 12 no-lock no-error.

    for each movind.pert-ordem
       where movind.pert-ordem.nr-ord-produ = movind.ord-prod.nr-ord-prod
       exclusive-lock:
        run bhp/bh0301b.p ("pert-ordem", rowid(pert-ordem)).
        on delete of movind.pert-ordem override do: end.
        delete movind.pert-ordem.
        assign tt-estat-modul.i-modulo = tt-estat-modul.i-modulo + 1.
    end.

    find first tt-estat-modul where 
               tt-estat-modul.i-sequencia = 13 no-lock no-error.     

    for each movind.rep-oper
       where movind.rep-oper.nr-ord-produ = movind.ord-prod.nr-ord-produ
       exclusive-lock:
        run bhp/bh0301b.p ("rep-oper", rowid(rep-oper)).
        delete movind.rep-oper.
        assign tt-estat-modul.i-modulo = tt-estat-modul.i-modulo + 1.
    end.

    run bhp/bh9000.p (input rowid(movind.ord-prod)).
    IF RETURN-VALUE = "Nok" THEN
         UNDO, NEXT.

     
end.

assign c-periodo = string(year(da-corte)) + string(month(da-corte)).

