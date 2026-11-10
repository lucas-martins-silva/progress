/*
**  BOIN111a.i
**
**  estrutura - Arquivo de Estrutura temporaria para BO específica.
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} 
    field r-rowid  as rowid
    field seq as integer
    field nivel as char format "X(16)"
    field it-codigo    like estrutura.it-codigo
    field refer like ref-item.cod-refer
    field quant-usada  like estrutura.quant-usada     
    field quant-liquid like estrutura.quant-liquid
    field quantidade   like estrutura.quant-usada
    field aux as char format "X(4)" 
    field proporcao like estrutura.proporcao
    field fator-perda like estrutura.fator-perda
    field data-inicio like estrutura.data-inicio
    field data-termino like estrutura.data-termino
    INDEX seq IS primary seq ASCENDING.
 
