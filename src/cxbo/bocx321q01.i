/*
**  BOCX215.i
**
**  proc-siscomex - 
**
**  Ultima altera‡Æo : 04/05/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} 
        field r-Rowid               as rowid
        field id                    as integer
        field cod-fabrican          like it-proc-siscomex.cod-fabrican[1]
        field nome-abrev            like emitente.nome-abrev
        field cgc                   like emitente.cgc
        field estado                like emitente.estado
        field class-fiscal-fabrican like it-proc-siscomex.class-fiscal-fabrican[1]
        field nr-ato-concessorio    like it-proc-siscomex.nr-ato-concessorio-fabrican[1]
        field qtd-fabrican          like it-proc-siscomex.qtd-fabrican[1]
        field valor-fabrican        like it-proc-siscomex.valor-fabrican[1].
 
