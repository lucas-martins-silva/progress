/*************************************************************************************
**
** AP0994.i - Include para atualizar item-doc-est 
**
*************************************************************************************/

FOR EACH TT-ITEM-EST :
      find item-doc-est
           where rowid(item-doc-est) = tt-item-est.r-it-doc
           exclusive-lock no-error.
      if l-cancela = yes then do:
         
         if avail tt-item-est then      
            assign tt-item-est.cod-tax = if avail item-doc-est then item-doc-est.cod-tax else 0
                   tt-item-est.vl-taxa = if avail item-doc-est then item-doc-est.vl-taxa else 0.
         
      end.     
      else do:
          /*caso na tela de confirmaá∆o tenha sido selecionado o bot∆o OK e n∆o o Cancelar
            ir† atualizar o item-doc-est e o docum-est*/
          if tt-item-est.item-ap = no then do:
             if avail item-doc-est then 
                assign  item-doc-est.cod-tax     =  tt-item-est.cod-tax
                        item-doc-est.vl-taxa     =  tt-item-est.vl-taxa
                        item-doc-est.est-cob     =  c-cod-estabel
                        item-doc-est.nr-docto-ap =  i-nr-docto
                        item-doc-est.cod-esp     =  c-cod-esp
                        item-doc-est.data        =  today
                        item-doc-est.hora        =  string(time, "HH:MM:SS")
                        item-doc-est.usuario     =  c-seg-usuario
                        item-doc-est.preco-fatura = item-doc-est.preco-fatura
                                                  + tt-item-est.preco.
  
               if  (item-doc-est.qt-saldo - tt-item-est.qtde) < 0 then do:
                   create item-ap.
                   assign item-ap.ep-codigo   = i-ep-codigo-usuario
                          item-ap.cod-fornec  = input frame {&frame-name} i-cod-emit
                          item-ap.cod-estabel = input frame {&frame-name} c-cod-estabel
                          item-ap.cod-esp     = input frame {&frame-name} c-cod-esp
                          item-ap.serie       = input frame {&frame-name} c-serie
                          item-ap.nr-docto    = input frame {&frame-name} i-nr-docto
                          item-ap.quantidade  = (tt-item-est.qtde - item-doc-est.qt-saldo) 
                          item-ap.it-codigo   = tt-item-est.it-codigo
                          item-ap.preco       = tt-item-est.preco.
                   assign item-doc-est.qt-saldo  = 0 .
               end.
               else 
                  assign item-doc-est.qt-saldo = item-doc-est.qt-saldo - tt-item-est.qtde.
               
              /*se existir alguma diferenáa no preáo e o usu†rio tiver confirmado , grava
               3 no sit-item*/

               if  i-moeda <> 0 
               and tt-item-est.preco <> item-doc-est.preco-total-me  then 
                   assign item-doc-est.sit-item = 3.
                 
               if i-moeda = 0
               and tt-item-est.preco <> item-doc-est.preco-total[1] then
                   assign item-doc-est.sit-item = 3.    
             
              /*se o item n∆o tiver sido totalmente atendido, ou seja, se o usu†rio informou 
                uma quantidae menor que a quantidade total do item , o flag fica como parcialmente
               atendido*/
               
              if item-doc-est.qt-saldo <> 0 then do:
                 if  tt-item-est.preco = item-doc-est.preco-total[1] then
                     assign item-doc-est.sit-item = 4.                 
              end.              
              else 
                  assign item-doc-est.sit-item = 1.   
                
              find docum-est of item-doc-est no-error.
              for each item-doc-est of docum-est no-lock:
                  if item-doc-est.sit-item = 3 then do:
                     docum-est.sit-docum = 3.        
                     leave.
                  end.   
                  /*s¢ atualiza o docum-est.sit-docum com 1 se nao tiver encontrado
                    o item-doc-est com outro flag*/
                  assign docum-est.sit-docum = 1.
              end.      
          end.
          else do:
              find item-ap 
                   where item-ap.ep-codigo   = i-ep-codigo-usuario
                     and item-ap.cod-estabel = input frame {&frame-name} c-cod-estabel
                     and item-ap.cod-fornec  = input frame {&frame-name} i-cod-emit
                     and item-ap.cod-esp     = input frame {&frame-name} c-cod-esp
                     and item-ap.serie       = input frame {&frame-name} c-serie
                     and item-ap.nr-docto    = input frame {&frame-name} i-nr-docto
                     and item-ap.it-codigo   = tt-item-est.it-codigo no-error.
              if avail item-ap then
                 assign item-ap.quantidade = item-ap.quantidade + tt-item-est.qtde
                        item-ap.preco      = item-ap.preco      + tt-item-est.preco.
              else do:
                 create item-ap.
                 assign item-ap.ep-codigo   = i-ep-codigo-usuario
                        item-ap.cod-fornec  = input frame {&frame-name} i-cod-emit
                        item-ap.cod-estabel = input frame {&frame-name} c-cod-estabel
                        item-ap.cod-esp     = input frame {&frame-name} c-cod-esp
                        item-ap.serie       = input frame {&frame-name} c-serie
                        item-ap.nr-docto    = input frame {&frame-name} i-nr-docto
                        item-ap.quantidade  = tt-item-est.qtde
                        item-ap.it-codigo   = tt-item-est.it-codigo
                        item-ap.preco       = tt-item-est.preco.
              end.          
          end.     
      end.           
   END.                         
   
