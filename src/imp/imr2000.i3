assign c-cod-estabel-tmp = ""
       c-serie-tmp       = ""
       c-nr-nota-fis-tmp = ""
       i-nr-seq-fat-tmp  = 0
       c-it-codigo-tmp   = "".

for each pedido-drb no-lock 
    where pedido-drb.nr-ato-concessorio = tt-param.nr-ato-concessorio 
      and pedido-drb.modalidade = 1 /* suspensao */:
   
    for each saldo-terc no-lock 
        where saldo-terc.nr-ato-concessorio = pedido-drb.nr-ato-concessorio:                
        
        for each componente no-lock 
            where componente.nr-ato-concessorio = saldo-terc.nr-ato-concessorio
              and componente.serie-comp         = saldo-terc.serie-docto
              and componente.nro-comp           = saldo-terc.nro-docto
              and componente.cod-emitente       = saldo-terc.cod-emitente
              and componente.nat-comp           = saldo-terc.nat-operacao
              and componente.it-codigo          = saldo-terc.it-codigo
              and componente.cod-refer          = saldo-terc.cod-refer
              and componente.componente         = 2 /* Saida */:
            /*
            ** Procura nota de sa°da
            */        
            find it-nota-fisc no-lock
                where it-nota-fisc.cod-estabel  = saldo-terc.cod-estabel
                  and it-nota-fisc.serie        = componente.serie-docto
                  and it-nota-fisc.nr-nota-fis  = componente.nro-docto
                  and it-nota-fisc.nr-seq-fat   = componente.sequencia no-error.
          
            if avail it-nota-fisc then do:
            
                if c-cod-estabel-tmp = "" and
                   c-serie-tmp       = "" and
                   c-nr-nota-fis-tmp = "" and
                   i-nr-seq-fat-tmp  = 0  and
                   c-it-codigo-tmp   = "" then do:
                    assign c-cod-estabel-tmp = it-nota-fisc.cod-estabel
                           c-serie-tmp       = it-nota-fisc.serie
                           c-nr-nota-fis-tmp = it-nota-fisc.nr-nota-fis
                           i-nr-seq-fat-tmp  = it-nota-fisc.nr-seq-fat
                           c-it-codigo-tmp   = it-nota-fisc.it-codigo. 
                end.                
            
                find nota-fiscal of it-nota-fisc no-lock.
                
                if nota-fiscal.dt-cancela <> ? then
                    next.
                    
                find ped-ent no-lock 
                    where ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli 
                      and ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli   
                      and ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped  
                      and ped-ent.it-codigo    = it-nota-fisc.it-codigo   
                      and ped-ent.cod-refer    = it-nota-fisc.cod-refer   
                      and ped-ent.nr-entrega   = it-nota-fisc.nr-entrega no-error.
                      
                if avail ped-ent then do:
                
                    find proc-ped-ent no-lock 
                        where proc-ped-ent.cod-estabel  = it-nota-fisc.cod-estabel 
                          and proc-ped-ent.nr-proc-exp  = ped-ent.nr-proc-exp 
                          and proc-ped-ent.nome-abrev   = ped-ent.nome-abrev  
                          and proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli   
                          and proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia 
                          and proc-ped-ent.it-codigo    = ped-ent.it-codigo    
                          and proc-ped-ent.cod-refer    = ped-ent.cod-refer    
                          and proc-ped-ent.nr-entrega   = ped-ent.nr-entrega no-error.
                    if avail proc-ped-ent then do:
                
                        find item no-lock 
                            where item.it-codigo = proc-ped-ent.it-codigo no-error.
                        if avail item then do:
                        
                            find classif-fisc no-lock 
                                where classif-fisc.class-fiscal = item.class-fiscal no-error.
       
                            if avail classif-fisc then do:
                            
                                find tt-unificado-re 
                                    where tt-unificado-re.nr-re       = proc-ped-ent.nr-re        
                                      and tt-unificado-re.nr-nota-fis = it-nota-fisc.nr-nota-fis  
                                      and tt-unificado-re.cod-ncm     = classif-fisc.cod-ncm no-error.
                                      
                                if not avail tt-unificado-re then do:                                                                        
                                    create tt-unificado-re.
                                    assign tt-unificado-re.nr-re       = proc-ped-ent.nr-re 
                                           tt-unificado-re.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                                           tt-unificado-re.data-nf     = nota-fiscal.dt-emis-nota
                                           tt-unificado-re.cod-ncm     = classif-fisc.cod-ncm
                                           tt-unificado-re.descricao   = item.descricao-1 + item.descricao-2
                                           tt-unificado-re.mo-codigo   = 0.
                                           
                                    /*
                                    ** Utiliza a sigla da moeda padr∆o - faturamento
                                    */                                               
                                    find moeda
                                        where moeda.mo-codigo = 0 no-lock.
                                    if avail moeda then
                                        assign tt-unificado-re.sigla = "(" + moeda.sigla + ")".
                                    release moeda.

                                    assign tt-unificado-re.peso  = it-nota-fisc.peso-liq
                                           tt-unificado-re.valor = it-nota-fisc.vl-merc-liq.
                                    
                                    if not it-nota-fisc.ind-fat-qtfam then 
                                        assign tt-unificado-re.quantidade = it-nota-fisc.qt-faturada[1]
                                               tt-unificado-re.un         = "(" + it-nota-fisc.un-fatur[1] + ")".
                                    else
                                        assign tt-unificado-re.quantidade = it-nota-fisc.qt-faturada[2]
                                               tt-unificado-re.un         = "(" + it-nota-fisc.un-fatur[2] + ")".
    
                                end. /* if not avail tt-unificado-re ... */
                                else do:
                                
                                    if c-cod-estabel-tmp <> it-nota-fisc.cod-estabel and
                                       c-serie-tmp       <> it-nota-fisc.serie and
                                       c-nr-nota-fis-tmp <> it-nota-fisc.nr-nota-fis and
                                       i-nr-seq-fat-tmp  <> it-nota-fisc.nr-seq-fat and
                                       c-it-codigo-tmp   <> it-nota-fisc.it-codigo then do:
                                       
                                        assign c-cod-estabel-tmp = it-nota-fisc.cod-estabel
                                               c-serie-tmp       = it-nota-fisc.serie
                                               c-nr-nota-fis-tmp = it-nota-fisc.nr-nota-fis
                                               i-nr-seq-fat-tmp  = it-nota-fisc.nr-seq-fat
                                               c-it-codigo-tmp   = it-nota-fisc.it-codigo.
                         
                                        assign tt-unificado-re.peso  = tt-unificado-re.peso  + it-nota-fisc.peso-liq
                                               tt-unificado-re.valor = tt-unificado-re.valor + it-nota-fisc.vl-merc-liq.
                                        
                                        if not it-nota-fisc.ind-fat-qtfam then 
                                            assign tt-unificado-re.quantidade = tt-unificado-re.quantidade + it-nota-fisc.qt-faturada[1]
                                                   tt-unificado-re.un         = "(" + it-nota-fisc.un-fatur[1] + ")".
                                        else
                                            assign tt-unificado-re.quantidade = tt-unificado-re.quantidade + it-nota-fisc.qt-faturada[2]
                                                   tt-unificado-re.un         = "(" + it-nota-fisc.un-fatur[2] + ")".
                                                   
                                    end.                                                   
                                               
                                end.                                               
                       
                            end. /* if avail classif-fisc ... */
                       
                        end. /* if avail item ... */
                 
                    end. /* if avail proc-ped-ent ... */
           
                end. /* if avail ped-ent */
                
            end. /* if avai it-nota-fisc ... */             
            release it-nota-fisc.
            
            /*
            ** Procura nota de entrada
            */        
            find it-nota-fisc no-lock
                where it-nota-fisc.cod-estabel  = saldo-terc.cod-estabel
                  and it-nota-fisc.serie        = componente.serie-comp
                  and it-nota-fisc.nr-nota-fis  = componente.nro-comp
                  and it-nota-fisc.nr-seq-fat   = componente.seq-comp no-error.
            find item-doc-est no-lock
                where item-doc-est.serie-docto  = componente.serie-comp
                  and item-doc-est.nro-docto    = componente.nro-comp
                  and item-doc-est.cod-emitente = componente.cod-emitente
                  and item-doc-est.nat-operacao = componente.nat-comp
                  and item-doc-est.sequencia    = componente.seq-comp no-error.
        
            if avail item-doc-est then 
                find docum-est no-lock
                    where docum-est.serie-docto  = item-doc-est.serie-docto
                      and docum-est.nro-docto    = item-doc-est.nro-docto
                      and docum-est.cod-emitente = item-doc-est.cod-emitente
                      and docum-est.nat-operacao = item-doc-est.nat-operacao no-error.
             
            if avail docum-est then do:            
                {cdp/cd4300.i4 "yes" docum-est.char-1}
                {rep/re1001a.i51 "yes"}
            
                find item no-lock 
                    where item.it-codigo = item-doc-est.it-codigo no-error.
            
                if avail item then do:
                
                    find classif-fisc no-lock 
                        where classif-fisc.class-fiscal = item.class-fiscal no-error.
                    
                    find embarque-imp no-lock 
                        where embarque-imp.cod-estabel = docum-est.cod-estabel
                          and embarque-imp.embarque    = c-embarque no-error.
                        
                    if avail embarque-imp then do:
                        
                        find tt-unificado-di 
                            where tt-unificado-di.declaracao-import = embarque-imp.declaracao-import  
                              and tt-unificado-di.nr-nota-fis       = docum-est.nro-docto  
                              and tt-unificado-di.cod-ncm           = classif-fisc.cod-ncm      
                              no-error.
                              
                        if not avail tt-unificado-di then do:
                            create tt-unificado-di.
                            assign tt-unificado-di.declaracao-import = embarque-imp.declaracao-import 
                                   tt-unificado-di.data-di           = embarque-imp.data-DI
                                   tt-unificado-di.nr-nota-fis       = docum-est.nro-docto 
                                   tt-unificado-di.data-nf           = docum-est.dt-trans                         
                                   tt-unificado-di.cod-ncm           = classif-fisc.cod-ncm
                                   tt-unificado-di.descricao         = item.descricao-1 + item.descricao-2.
                                   
                            find ordem-compra  
                                where ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
                            if avail ordem-compra then 
                                find moeda 
                                    where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error.
                            if not avail moeda then
                                find moeda 
                                    where moeda.mo-codigo = 0 no-lock no-error.
                            if avail moeda then                                    
                                assign tt-unificado-di.sigla     = "(" + moeda.sigla + ")"
                                       tt-unificado-di.mo-codigo = moeda.mo-codigo.
                            release moeda.
                                 
                        end. /*if not-avail tt-unificado-di*/
                        
                        assign tt-unificado-di.peso       = tt-unificado-di.peso       + componente.peso-liquido
                               tt-unificado-di.quantidade = tt-unificado-di.quantidade + componente.quantidade
                               tt-unificado-di.valor      = tt-unificado-di.valor      + componente.preco-total[1]
                               tt-unificado-di.un         = "(" + componente.un + ")".
                                   
                        if avail it-nota-fisc and it-nota-fisc.ind-fat-qtfam then
                            assign tt-unificado-di.quantidade = tt-unificado-di.quantidade
                                                              * (  item.ft-conversao / exp(10, item.dec-ftcon) )
                                   tt-unificado-di.un         = "(" + it-nota-fisc.un-fatur[2] + ")".                        
                        
                        if tt-unificado-di.mo-codigo <> 0 then do:
                            run cdp/cd0812.p (input 0,
                                              input tt-unificado-di.mo-codigo,
                                              input tt-unificado-di.valor,
                                              input embarque-imp.data-1,
                                              output tt-unificado-di.valor).
                        end.
                               
                    end. /*embarque-imp*/
                    
                end. /*if avail item*/
            
            end. /* if avail docum-est ... */
        
        end. /* for each componente ... */
        
    end. /* for each saldo-terc ... */
 
end. /* for each pedido-drb ... */

/* imr2000.i3 */
