/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**     Include: boin681.i - Definicao de Temp-Table
*******************************************************************************/

DEFINE TEMP-TABLE {1} NO-UNDO LIKE controle-preco
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-precos
       field cod-estabel      like controle-preco.cod-estabel
       field it-codigo        like controle-preco.it-codigo  
       field cod-emitente     like emitente.cod-emitente
       field data-cotacao     like controle-preco.data-cotacao 
       field inicio-calculo   as date format "99/99/9999"  label "Data In¡cio C lculo"
       field cod-cond-pag     like cond-pagto.cod-cond-pag
       field valor-taxa       as decimal format "->>9.99"
       field preco-unit-vista as decimal format "->>>,>>9.9999"
       field preco-unit-prazo as decimal format "->>>,>>9.9999"
       field perc-ant         as decimal extent 3 format "->>9.99"
       field perc-acum        as decimal extent 3 format "->>9.99"
       field aliquota-ipi     as decimal format "->>9.99"  
       field nome-emit        like emitente.nome-emit 
       field preco-moeda      as decimal extent 3 format "->>>,>>9.9999"
       field manual-autom     as char
       field sequencia        as integer 
       field r-rowid          as rowid.

