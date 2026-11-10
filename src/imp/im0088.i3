/*******************************************************************************
**
**     IM0088.I3 - Imprime embarques contabilizados
**
*******************************************************************************/

assign i-aux = {1}.

CASE i-aux: 
     WHEN 1 then do: /* Embarques Contabilizados */
          IF FIRST-OF(tt-embarque-contab.embarque) THEN DO:
             if  line-counter < 9 then
                disp c-lb-estab   
                     c-lb-emb     
                     c-lb-fornec  
                     c-lb-nome    
                     c-lb-contab  
                     c-lb-pto-inc 
                     c-lb-dt-inc  
                     c-lb-pto-emb 
                     c-lb-dt-emb  
                     c-lb-emp     
                     c-lb-esp     
                     c-lb-ser     
                     c-lb-tit     
                     c-lb-par     
                     c-lb-dt-emis 
                     c-lb-dt-prev 
                     c-lb-moeda   
                     c-lb-vl-ori  
                     c-lb-vl-sal               
                     with stream-io frame f-cab-corpo1.
        
             PUT tt-embarque-contab.cod-estabel     at 1              
                 tt-embarque-contab.embarque        at 8   
                 tt-embarque-contab.cod-fornec      at 25
                 tt-embarque-contab.desc-emit       at 36 
                 tt-embarque-contab.contabilizado   at 52      
                 tt-embarque-contab.pto-incoterm    at 62       
                 tt-embarque-contab.data-incoterm   at 74       
                 tt-embarque-contab.pto-embarque    at 88       
                 tt-embarque-contab.data-embarque   at 100  SKIP
                 tt-embarque-contab.ep-codigo       at 22      
                 tt-embarque-contab.cod-esp         at 27     
                 tt-embarque-contab.serie           at 32     
                 tt-embarque-contab.nr-docto        at 39     
                 tt-embarque-contab.parcela         at 56     
                 tt-embarque-contab.data-emissao    at 60     
                 tt-embarque-contab.data-prev-pag   at 72     
                 tt-embarque-contab.desc-moeda      at 84     
                 tt-embarque-contab.de-vl-orig      at 96     
                 tt-embarque-contab.de-vl-saldo     at 118 SKIP.
          END.
          ELSE DO:      
              PUT tt-embarque-contab.ep-codigo       at 22        
                  tt-embarque-contab.cod-esp         at 27        
                  tt-embarque-contab.serie           at 32   
                  tt-embarque-contab.nr-docto        at 39  
                  tt-embarque-contab.parcela         at 56  
                  tt-embarque-contab.data-emissao    at 60  
                  tt-embarque-contab.data-prev-pag   at 72  
                  tt-embarque-contab.desc-moeda      at 84  
                  tt-embarque-contab.de-vl-orig      at 96  
                  tt-embarque-contab.de-vl-saldo     at 118 SKIP.   
                                      
          END.
          IF LAST-OF(tt-embarque-contab.embarque) THEN PUT SKIP(1).
        
     END.
     WHEN 2 THEN DO: /* Embarques Sem T¡tulo */

          if  line-counter < 8 then
              disp c-lb-estab   
                   c-lb-emb     
                   c-lb-fornec  
                   c-lb-nome    
                   c-lb-contab  
                   c-lb-pto-inc 
                   c-lb-dt-inc  
                   c-lb-pto-emb 
                   c-lb-dt-emb  
                   with stream-io frame f-cab-corpo2. 

          PUT tt-embarque-contab.cod-estabel     at 1              
              tt-embarque-contab.embarque        at 8   
              tt-embarque-contab.cod-fornec      at 25
              tt-embarque-contab.desc-emit       at 36 
              tt-embarque-contab.contabilizado   at 52      
              tt-embarque-contab.pto-incoterm    at 62       
              tt-embarque-contab.data-incoterm   at 74       
              tt-embarque-contab.pto-embarque    at 88       
              tt-embarque-contab.data-embarque   at 100  SKIP.
     
     END.
     WHEN 3 THEN DO: /* Embarques NÆo Contabilizados  */
       if (line-counter >= 60) or (line-counter < 7) then do: 
           page.
           disp c-lb-estab   
                c-lb-emb     
                c-lb-fornec  
                c-lb-nome    
                c-lb-contab  
                c-lb-pto-inc 
                c-lb-dt-inc  
                c-lb-pto-emb 
                c-lb-dt-emb  
                with stream-io frame f-cab-corpo2.
       END.

       PUT tt-embarque-contab.cod-estabel     at 1              
           tt-embarque-contab.embarque        at 8   
           tt-embarque-contab.cod-fornec      at 25
           tt-embarque-contab.desc-emit       at 36 
           tt-embarque-contab.contabilizado   at 52      
           tt-embarque-contab.pto-incoterm    at 62       
           tt-embarque-contab.data-incoterm   at 74       
           tt-embarque-contab.pto-embarque    at 88       
           tt-embarque-contab.data-embarque   at 100      SKIP.
     
     END.     
END CASE.


/* IM0088.I3  */
