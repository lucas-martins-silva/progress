PROCEDURE geraEstruturaFilho:
    /*
    ** Procedimento auxiliar do procedimento montaEstrutura.
    ** Atraves de recursividade desce a estrutura de um item.
    */
    define input parameter v-row-item   as rowid   no-undo.
    define input parameter p-refer      as char    no-undo.
    define input parameter p-quantidade as decimal no-undo.
    define input parameter p-quant-liq  as decimal no-undo.
    define input parameter p-nivel      as integer no-undo.
    
    define buffer b1-item     for item.
    define buffer b2-item     for item.
    define buffer b-estrutura for estrutura.
    
    define var de-quant-usada as  decimal.
    define var i as integer.    
    
    for first b1-item fields ( it-codigo tipo-con-est) 
        where rowid(b1-item) = v-row-item no-lock:
    end.
    
    assign p-nivel = p-nivel + 1.
    
    for each  b-estrutura fields (data-inicio data-termino es-codigo quant-usada qtd-compon
                                  proporcao   fator-perda  it-codigo sequencia qtd-item dec-2
                                  fantasma) of b1-item no-lock:
                                 
        if (b-estrutura.data-inicio  <= da-data-corte and
            b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:
            
            for first b2-item fields (it-codigo tipo-con-est compr-fabric) where 
                 b2-item.it-codigo = b-estrutura.es-codigo no-lock: end.

            if not avail b2-item then 
                next.
            assign de-quant-usada =  b-estrutura.quant-usada * p-quantidade * 
                                    (b-estrutura.proporcao / 100)
                   de-quant-liq   = (b-estrutura.quant-usada * p-quantidade *  b-estrutura.proporcao / 100)
                                  * (1 - (b-estrutura.fator-perda / 100)).

            assign d-qtd-baixa-drb = 0.

            if l-baixa-drb-internac 
                and b-estrutura.dec-2 <> 0 then do:
                
                assign d-qtd-baixa-drb  = (p-quantidade * (b-estrutura.dec-2 / 100))          /*calcula o percentual para aplica‡Æo*/ .
                
                if d-qtd-baixa-drb <> 0 then
                    assign de-quant-usada = d-qtd-baixa-drb.

            end.                
                                  
           if b2-item.tipo-con-est = 4 or
              b1-item.tipo-con-est = 4 then do:
              
                if not can-find(first ref-estrut
                                    where ref-estrut.it-codigo  = estrutura.it-codigo
                                      and ref-estrut.sequencia  = estrutura.sequencia
                                      and ref-estrut.es-codigo  = estrutura.es-codigo) then
                     assign c-refer-es       = ""
                            l-refer-incluida = yes.
                else do:
                    find ref-estrut
                        where ref-estrut.it-codigo  = estrutura.it-codigo
                          and ref-estrut.sequencia  = estrutura.sequencia
                          and ref-estrut.es-codigo  = estrutura.es-codigo
                          and ref-estrut.cod-ref-it = c-refer no-lock no-error.
                    if available ref-estrut then
                        assign c-refer-es       = ref-estrut.cod-ref-es
                               l-refer-incluida = yes.
                    else
                        assign l-refer-incluida = no.
                end.

           end.
           else
               assign l-refer-incluida = yes
                      c-refer-es       = ''.
     
           if  l-refer-incluida then do:
                create tt-estrutura.
                assign c-rowid                    = "0x0" + string(i-seq,"9999999")
                       tt-estrutura.seq           = i-seq
                       tt-estrutura.refer         = c-refer-es
                       tt-estrutura.r-rowid       = to-rowid(c-rowid)
                       tt-estrutura.proporcao     = b-estrutura.proporcao
                       tt-estrutura.it-codigo     = b-estrutura.es-codigo
                       tt-estrutura.fator-perda   = b-estrutura.fator-perda
                       tt-estrutura.quant-usada   = de-quant-usada
                       tt-estrutura.quant-liquid  = de-quant-liq
                       tt-estrutura.quantidade    = b-estrutura.quant-usada
                       tt-estrutura.data-inicio   = b-estrutura.data-inicio
                       tt-estrutura.data-termino  = b-estrutura.data-termino
                       i-seq                      = i-seq + 1.
                        
                if b-estrutura.fantasma then 
                    assign tt-estrutura.aux = '#'.
                else
                    assign tt-estrutura.aux = ' '.
                
                if  b2-item.compr-fabric = 1 then           
                    assign tt-estrutura.aux = tt-estrutura.aux +  c-comp.
                else     
                    assign tt-estrutura.aux = tt-estrutura.aux +  c-fabr.
                    
                if can-find(first alternativo
                                where alternativo.it-codigo = b-estrutura.it-codigo
                                  and alternativo.sequencia = b-estrutura.sequencia
                                  and alternativo.es-codigo = b-estrutura.es-codigo) then
                    assign tt-estrutura.aux = tt-estrutura.aux + c-alt.
                else   
                    assign tt-estrutura.aux = tt-estrutura.aux + ' '.
             
                if today >= b-estrutura.data-termino or
                   today < b-estrutura.data-inicio then
                    assign tt-estrutura.aux = tt-estrutura.aux +  '?'.

                assign tt-estrutura.nivel = string(p-nivel,">9").
                do i = 3 to p-nivel:
                    assign tt-estrutura.nivel = ' ' + tt-estrutura.nivel.
                    if i = 10 then
                        leave.
                end.
                assign tt-estrutura.nivel = string(tt-estrutura.nivel, 'x(12)') + tt-estrutura.aux.

                if i-niveis > p-nivel then
                    run geraEstruturaFilho(rowid(b2-item), c-refer-es, de-quant-usada, de-quant-liq, p-nivel).

           end.
        end.
    end.
    
END PROCEDURE.
