/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172F 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN172F MUT}
&ENDIF

/******************************************************************************
**
** BOIN172F - Eliminaá∆o das tabelas do banco mgmrp
**
*******************************************************************************/

def input param p-it-codigo as char format "x(16)" no-undo.
def input param p-modulo-pl as log                 no-undo.

{cdp/cdcfgman.i}

&IF DEFINED (bf_man_sfc_lc) &THEN

    for each carga-x-ref
        where carga-x-ref.it-codigo = p-it-codigo EXCLUSIVE-LOCK:
        delete carga-x-ref.
    end.

    for each crp-oper
        where crp-oper.it-codigo = p-it-codigo EXCLUSIVE-LOCK:
        delete crp-oper.
    end.

    for each crp-oper-ant
        where crp-oper-ant.it-codigo = p-it-codigo EXCLUSIVE-LOCK:
        delete crp-oper-ant.
    end.

    for each crp-ord-prod
        where crp-ord-prod.it-codigo = p-it-codigo EXCLUSIVE-LOCK:
        delete crp-ord-prod.
    end.

    for each it-carga-plan
        where it-carga-plan.it-codigo = p-it-codigo EXCLUSIVE-LOCK:
        delete it-carga-plan.
    end.

&ENDIF

/*** Se o item possui algum calculado pelo planejamento, altera flag de recalculo 
      do item (no seguinte recalculo ele desaparecer† caso o sistema possua planejamento  ***/

if  p-modulo-pl = yes then do:

    &IF DEFINED (bf_man_204) &THEN
        FOR EACH pl-prod NO-LOCK:

            FIND FIRST pl-it-calc USE-INDEX ITEM WHERE
                pl-it-calc.cd-plano  = pl-prod.cd-plano
            AND pl-it-calc.it-codigo = p-it-codigo EXCLUSIVE-LOCK NO-ERROR.

            if  avail pl-it-calc then do:
                FIND first it-periodo USE-INDEX codigo
                WHERE it-periodo.num-calc-plano = pl-prod.num-calc-plano
                AND   it-periodo.it-codigo = pl-it-calc.it-codigo no-lock no-error.

            /*** Se n∆o foi calculado nada para o item planejado pode ser eliminado **/
                if  not avail it-periodo then do:
                    if  available pl-it-calc then
                        delete pl-it-calc.  
                end.   
            end.



        END.
    &ELSE
        find pl-it-calc where pl-it-calc.it-codigo = p-it-codigo EXCLUSIVE-LOCK no-error.

        if  avail pl-it-calc then do:
            find first it-periodo
                 where it-periodo.it-codigo = pl-it-calc.it-codigo no-lock no-error.

            /*** Se n∆o foi calculado nada para o item planejado pode ser eliminado **/
            if  not avail it-periodo then do:
                if  available pl-it-calc then
                    delete pl-it-calc.  
            end.   
        end.
    &ENDIF.
end.

