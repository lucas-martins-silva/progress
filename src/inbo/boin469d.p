/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469D MUT}
&ENDIF

/*****************************************************************************
**
** PROGRAMA  BOIN469D - funcoes de tratamento de tempo 
** PARAMETROS: ENTRADA: grupo de maquina, calendario do grupo de maquina,
**             ENTRADA E SAIDA: 
**             tempo de processo: Em horas 
**             data de inicio 
**             hora de inicio:    Em segundos
**             data final 
**             hora final:        Em segundos
**
******************************************************************************/

def input-output param p-cod-area         as char    format "x(12)"          no-undo.
def input-output param p-cod-grp-maq      as char    format "x(9)"           no-undo.
def input        param p-cod-ctrab        as char    format "x(16)"          no-undo.
def input-output param p-cod-calend-sfc   as char    format "x(8)"           no-undo.
def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
def input-output param p-qtd-tempo        as decimal format ">,>>>,>>9.99"   decimals 2 no-undo.

def var h-boin469b as handle no-undo.

run inbo/boin469b.p persistent set h-boin469b.

run CalcularTemposCtrab in h-boin469b (input-output p-cod-area,
                                       input-output p-cod-grp-maq,
                                       input        p-cod-ctrab,
                                       input-output p-cod-calend-sfc,
                                       Input-output p-dat-fim,
                                       Input-output p-qtd-segs-fim,
                                       Input-output p-dat-inic,
                                       Input-output p-qtd-segs-inic,
                                       Input-output p-qtd-tempo).

delete procedure h-boin469b.

/* Fim do Programa */
