/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN084PA 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN084PA MUT}
&ENDIF


def temp-table tt-deposito
    field cod-depos    as char format "x(03)"
    field nome         as char format "x(40)"
    field cons-saldo   as log  format "Sim/NÆo"
    index deposito cod-depos.

PROCEDURE retornaDeposito:

    def output param table for tt-deposito.

    for each tt-deposito:
        delete tt-deposito.
    end.

    for each deposito:
        create tt-deposito.
        assign tt-deposito.cod-depos  = deposito.cod-depos
               tt-deposito.nome       = deposito.nome
               tt-deposito.cons-saldo = deposito.cons-saldo.
    end.
    
END PROCEDURE.
