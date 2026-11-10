/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8003 2.00.00.012 } /*** 010012 ***/


/**********************************************************************************
** Programa............: BC8003.p
**
** Objetivo............: Cria Registro Tabela bc-ext-saldo-estoq
**
**********************************************************************************/
&IF "{&mguni_version}" >= "2.071" &THEN
def input param c-cod-estabel   as char format "x(05)" no-undo.
&ELSE
def input param c-cod-estabel   as char format "X(03)" no-undo.
&ENDIF
def input param c-cod-depos     as char format "X(03)" no-undo.
def input param c-cod-localiz   as char format "X(20)" no-undo.
def input param c-lote          as char format "X(40)" no-undo.
def input param c-it-codigo     as char format "X(16)" no-undo.
def input param c_nro           as char format "X(16)" no-undo.

{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

find first bc-ext-saldo-estoq 
     where bc-ext-saldo-estoq.cod-estabel = c-cod-estabel
       and bc-ext-saldo-estoq.cod-depos   = c-cod-depos
       and bc-ext-saldo-estoq.cod-localiz = c-cod-localiz
       and bc-ext-saldo-estoq.lote        = c-lote
       and bc-ext-saldo-estoq.it-codigo   = c-it-codigo
     no-lock no-error.

if  available bc-ext-saldo-estoq then do:
    leave.
end.

find first bc-ext-item
     where bc-ext-item.it-codigo = c-it-codigo
     no-lock no-error.
IF AVAIL bc-ext-item
THEN
    RUN pi-cria-bc-ext-saldo-estoq.
ELSE DO:
    run pi-verifica-item ( input c-it-codigo,
                           input c-it-codigo,
                           input 0,   /* Tipo de Acesso 0=Currente .... */
                           input 1).
    IF  NOT AVAIL ttReturnMessages
    THEN DO:
        FIND FIRST bc-ext-familia
             WHERE bc-ext-familia.fm-codigo = ttItem.fm-codigo
             NO-LOCK NO-ERROR.

        IF  AVAIL bc-ext-familia
        THEN
            RUN pi-cria-bc-ext-saldo-estoq.
    END.
END.

IF  ERROR-STATUS:ERROR
AND ERROR-STATUS:NUM-MESSAGES = 1
AND ERROR-STATUS:GET-NUMBER(1) = 565 THEN
    ASSIGN ERROR-STATUS:ERROR = NO.


/******************************************************************************************************************************************
*******************************************************************************************************************************************
******************************************************************************************************************************************/
PROCEDURE pi-cria-bc-ext-saldo-estoq:
    REPEAT:
        ASSIGN c_nro = STRING(NEXT-VALUE(seq-ext-saldo-estoq,mgCLD),"9999999999999999").
        FIND    FIRST bc-ext-saldo-estoq
                WHERE bc-ext-saldo-estoq.cod-unico = c_nro
                NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE bc-ext-saldo-estoq THEN DO:
            LEAVE.
        END.
    END.

    CREATE  bc-ext-saldo-estoq.
    ASSIGN  bc-ext-saldo-estoq.cod-unico   = c_nro
            bc-ext-saldo-estoq.cod-estabel = c-cod-estabel
            bc-ext-saldo-estoq.cod-depos   = c-cod-depos
            bc-ext-saldo-estoq.cod-localiz = c-cod-localiz
            bc-ext-saldo-estoq.lote        = c-lote
            bc-ext-saldo-estoq.it-codigo   = c-it-codigo.

END PROCEDURE.
