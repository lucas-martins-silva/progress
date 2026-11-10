/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8002 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" 
&THEN
{include/i-license-manager.i BC8002 MBC}
&ENDIF



/**********************************************************************************
** Programa............: BC8002.p
**
** Objetivo............: Elimina Registro Tabela bc-ext-saldo-estoq
**
**********************************************************************************/
&IF "{&mguni_version}" >= "2.071" &THEN
def input param c-cod-estabel   as char format "x(05)".
&ELSE
def input param c-cod-estabel   as char format "X(03)".
&ENDIF
def input param c-cod-depos     as char format "X(03)".
def input param c-cod-localiz   as char format "X(20)".
def input param c-lote          as char format "X(40)".
def input param c-it-codigo     as char format "X(16)".

find    first bc-ext-saldo-estoq 
        where bc-ext-saldo-estoq.cod-estabel   = c-cod-estabel
          and bc-ext-saldo-estoq.cod-depos     = c-cod-depos
          and bc-ext-saldo-estoq.cod-localiz   = c-cod-localiz
          and bc-ext-saldo-estoq.lote          = c-lote
          and bc-ext-saldo-estoq.it-codigo     = c-it-codigo
        exclusive-lock no-error.

if  available bc-ext-saldo-estoq then do:
    delete bc-ext-saldo-estoq.
end.
