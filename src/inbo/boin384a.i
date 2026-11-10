/*
**  BOIN384a.i - Espec¡fica p/ programa cp0514.w 
**
**  req-sum - Requisicoes Sumarizadas - 
**
**  Ultima alteração : 03/08/99 - GeraBO
***********************************************************************/

DEFINE TEMP-TABLE {1} like req-sum
            field nr-ordem            like ord-prod.nr-ord-produ
            field nr-req              like ord-prod.nr-req-sum
            field quant-orig          like reservas.quant-orig  format "->>>>>,>>9.9999"
            field quant-atend         like reservas.quant-atend format "->>>>>,>>9.9999"
            field saldo               as decimal                format "->>>>>,>>9.9999"
            field r-rowid             as rowid.
    
