/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469A 2.00.00.005}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469A MUT}
&ENDIF

/*****************************************************************************
**
** PROGRAMA  BOIN469A - funcoes de tratamento de tempo 
** PARAMETROS: ENTRADA: grupo de maquina, calendario do grupo de maquina,
**             ENTRADA E SAIDA: 
**             tempo de processo: Em horas 
**             data de inicio 
**             hora de inicio:    Em segundos
**             data final 
**             hora final:        Em segundos
**
******************************************************************************/

def input        param p-cod-grp-maq      as char    format "x(9)"           no-undo.
def input        param p-cod-calend-sfc   as char    format "x(8)"           no-undo.
def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
def input-output param p-qtd-tempo-proces as decimal format ">,>>>,>>9.99"   decimals 2 no-undo.


def VAR p-qtd-tempo-extra as decimal format ">,>>>,>>9.99"   decimals 4 no-undo.
def VAR p-num-turno        as INTEGER no-undo.

def var h-boin469b  as handle no-undo.
def var v-cod-area  as char   no-undo.
def var v-cod-ctrab as char   no-undo.

assign v-cod-area  = ?
       v-cod-ctrab = ?.

run inbo/boin469b.p persistent set h-boin469b.

run CalcularTemposCtrab in h-boin469b (input-output v-cod-area,
                                       input-output p-cod-grp-maq,
                                       input        v-cod-ctrab,
                                       input-output p-cod-calend-sfc,
                                       Input-output p-dat-fim,
                                       Input-output p-qtd-segs-fim,
                                       Input-output p-dat-inic,
                                       Input-output p-qtd-segs-inic,
                                       Input-output p-qtd-tempo-proces).

RUN piRetornaDadosExtras IN h-boin469b (OUTPUT p-qtd-tempo-extra,
                                        OUTPUT p-num-turno).

ASSIGN p-qtd-tempo-proces = p-qtd-tempo-proces + p-qtd-tempo-extra.

delete procedure h-boin469b.

/* Fim do Programa */
