
/* Definicoes de temp-tables de uso geral */
      
def temp-table tt-docum-est NO-UNDO    
    LIKE docum-est 
    index documento is primary unique
    serie-docto
    nro-docto
    cod-emitente
    nat-operacao.

def temp-table tt-item-doc-est NO-UNDO
    LIKE  item-doc-est    
    index documento is primary unique
          serie-docto
	      nro-docto
	      cod-emitente
	      nat-operacao
          sequencia.

def temp-table tt-dupli-apagar NO-UNDO
    LIKE dupli-apagar
    index documento is primary unique
       serie-docto
	   nro-docto
	   cod-emitente
	   nat-operacao
	   parcela.
