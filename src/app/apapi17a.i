/*******************************************************************************
***
*** app/apapi17a.i - Gera Retorno Erro API Integra‡Æo Nota D‚bito/Cr‚dito.
***
*******************************************************************************/
        
PROCEDURE pi-gerar-erro-retorno:
            
    def input param p-cod-erro  as integer   no-undo.
    def input param p-desc-erro as character no-undo.
            
    create tt-retorno-erro.
    assign tt-retorno-erro.ep-codigo     = tt-nota-debito-credito.ep-codigo
           tt-retorno-erro.cod-estabel   = tt-nota-debito-credito.cod-estabel
           tt-retorno-erro.cod-esp       = tt-nota-debito-credito.cod-esp
           tt-retorno-erro.serie         = tt-nota-debito-credito.serie
           tt-retorno-erro.cod-fornec    = tt-nota-debito-credito.cod-fornec
           tt-retorno-erro.nr-docto      = tt-nota-debito-credito.nr-docto
           tt-retorno-erro.parcela       = tt-nota-debito-credito.parcela
           tt-retorno-erro.identificacao = c-identificacao
           tt-retorno-erro.cod-erro      = p-cod-erro
           tt-retorno-erro.desc-erro     = trim(p-desc-erro).
           
END PROCEDURE.    

/* Fim de Include */

