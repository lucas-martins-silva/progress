/********************************************************************************
**
**  Include: abp~\ab0508.i3
**
**  Imprime Relat¢rio por Data e Hora de Sa¡da
**
********************************************************************************/
procedure pi-data-hora-saida:

{utp/ut-liter.i OBSERVA€ÇO: * R }
assign   cObservacao = trim(return-value).


FOR EACH ttRelatViagem NO-LOCK BREAK BY ttRelatViagem.ep-codigo
                                     BY ttRelatViagem.cod-eqpto   
                                     BY ttRelatViagem.dat-saida
                                     BY ttRelatViagem.hra-saida
                                     BY ttRelatViagem.num-viagem:
                            
   IF FIRST-OF(ttRelatViagem.dat-saida) THEN DO:
      DISPLAY c-data              
              ttRelatViagem.dat-saida
              WITH STREAM-IO FRAME f-data-saida.

      DISPLAY cHoraIni                                                         
              dFinal                                                          
              cHoraFim                                                        
              iNrViagem                                                       
              cLocOrig                                                        
              cContador-1                                                     
              Emp                                                            
              cEqpto                                                          
              cMotorista                                                      
              WITH FRAME f-cabecalho2.
   END.
   
   IF ttRelatViagem.dsl-obs <> "" AND tt-param.l-ImprimeObs THEN DO:
      RUN pi-print-editor ( ttRelatViagem.dsl-obs, 80).
      DISPLAY ttRelatViagem.hra-saida                     
              ttRelatViagem.dat-ret                   
              ttRelatViagem.hra-ret                   
              ttRelatViagem.num-viagem                
              ttRelatViagem.cod-rota                  
              ttRelatViagem.contador
              ttRelatViagem.ep-codigo               
              ttRelatViagem.cod-eqpto               
              ttRelatViagem.nom-motoris     
              WITH FRAME f-resumido2-1.
      DOWN WITH FRAME f-resumido2-1.
      
      FOR EACH tt-editor WHERE tt-editor.linha >= 1:
         PUT tt-editor.conteudo at 10.
      END.
   END. 
   ELSE DO:
                                
      DISPLAY ttRelatViagem.hra-saida                     
              ttRelatViagem.dat-ret                   
              ttRelatViagem.hra-ret                   
              ttRelatViagem.num-viagem                
              ttRelatViagem.cod-rota                  
              ttRelatViagem.contador
              ttRelatViagem.ep-codigo               
              ttRelatViagem.cod-eqpto               
              ttRelatViagem.nom-motoris                
              WITH FRAME f-resumido2.
      /*DOWN WITH FRAME f-resumido2.*/
      
   END. 
   
   FOR EACH tt-editor where tt-editor.linha > 1 NO-LOCK:  
       /*disp tt-editor.conteudo no-label when avail tt-editor 
       with frame f-obs.
       down with frame f-obs.    */  
   END.       
    
                   
        
   FOR EACH mab-viagem-implto FIELDS (cod-eqpto ep-codigo  num-viagem) 
      WHERE mab-viagem-implto.num-viagem = mab-viagem.num-viagem NO-LOCK,
         EACH bfeqpto FIELDS (cod-eqpto cod-model ep-codigo)
        WHERE bfeqpto.ep-codigo = mab-viagem-implto.ep-codigo
          AND bfeqpto.cod-eqpto = mab-viagem-implto.cod-eqpto NO-LOCK,
            EACH bfmodel FIELDS ( cod-model des-model)
           WHERE bfmodel.cod-model = bfeqpto.cod-model  NO-LOCK
           BREAK BY mab-viagem-implto.ep-codigo
                 BY mab-viagem-implto.cod-eqpto:
                    
      IF AVAIL mab-viagem-implto THEN DO:
         IF FIRST-OF(mab-viagem-implto.ep-codigo) AND FIRST-OF(mab-viagem-implto.cod-eqpto) THEN DO:
              DISPLAY c-implto         
                      WITH FRAME f-cab-implemento.
              DOWN WITH FRAME f-cab-implemento.
         END.         
       
         DISPLAY mab-viagem-implto.ep-codigo 
                 mab-viagem-implto.cod-eqpto 
                 bfmodel.des-model          
                 WITH FRAME f-implemento.
         DOWN WITH FRAME f-implemento.
      END.
   END.   
      
   PUT SKIP.
   
   IF LAST-OF(ttRelatViagem.num-viagem) THEN DO:
      IF tt-param.l-insere = YES THEN DO:
         PAGE.
      END. 
      ELSE DO:   
         PUT SKIP(1).          
      END.
   END.
END.     

RETURN 'OK':U.

END PROCEDURE.
/* FIM */    
