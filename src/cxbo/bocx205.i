/*
**  BOCX205.i
**
**  proc-desp-itiner - Despesas do Ponto de Itiner rio, no Processo de Exporta‡Æo
**
**  Ultima altera‡Æo : 04/05/99 - GeraBO
*/

&if defined(bf-dis-comex) &then
 
    DEFINE TEMP-TABLE {1} NO-UNDO /*like proc-desp-itiner. */
        field  char-1            like proc-desp-itiner.char-1  
        field  char-2            like proc-desp-itiner.char-2  
        field  check-sum         like proc-desp-itiner.check-sum    
        field  cod-cond-pag      like proc-desp-itiner.cod-cond-pag  
        field  cod-desp          like proc-desp-itiner.cod-desp  
        field  cod-emitente-desp like proc-desp-itiner.cod-emitente-desp  
        field  cod-estabel       like proc-desp-itiner.cod-estabel  
        field  cod-itiner        like proc-desp-itiner.cod-itiner  
        field  cod-pto-contr     like proc-desp-itiner.cod-pto-contr  
        field  confirmada        like proc-desp-itiner.confirmada  
        field  contato           like proc-desp-itiner.contato  
        field  data-1            like proc-desp-itiner.data-1  
        field  data-2            like proc-desp-itiner.data-2  
        field  data-cotacao-desp like proc-desp-itiner.data-cotacao-desp  
        field  dec-1             like proc-desp-itiner.dec-1  
        field  dec-2             like proc-desp-itiner.dec-2  
        field  int-1             like proc-desp-itiner.int-1  
        field  int-2             like proc-desp-itiner.int-2  
        field  l-forma-preco     like proc-desp-itiner.l-forma-preco  
        field  log-1             like proc-desp-itiner.log-1  
        field  log-2             like proc-desp-itiner.log-2  
        field  mo-codigo         like proc-desp-itiner.mo-codigo  
        field  nr-dias-taxa      like proc-desp-itiner.nr-dias-taxa  
        field  nr-proc-exp       like proc-desp-itiner.nr-proc-exp  
        field  nr-tab            like proc-desp-itiner.nr-tab  
        field  perc-descto       like proc-desp-itiner.perc-descto  
        field  perc-taxa         like proc-desp-itiner.perc-taxa  
        field  sequencia         like proc-desp-itiner.sequencia  
        field  taxa-financ       like proc-desp-itiner.taxa-financ  
        field  val-desp          like proc-desp-itiner.val-desp  
        field  val-min           like proc-desp-itiner.val-min  
        field  val-min-desp      like proc-desp-itiner.val-min-desp     
        field  classif-despesa   as integer
        field  r-rowid           as rowid.
        
&else

    define temp-table {1} no-undo like proc-desp-itiner
        field r-rowid as rowid.

&endif        
 
