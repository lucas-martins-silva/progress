/******************************************************************
**
** im0710.i  Campo: via-transp (transporte) combo-box em tela de parÉmetros
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Consumo                                                                  
&glob val2  Admiss∆o em Entreposto Aduaneiro                                         
&glob val3  Admiss∆o em EIZOF - Entreposto Internacional da ZFM                      
&glob val4  Admiss∆o em Entreposto Industrial                                        
&glob val5  Admiss∆o Tempor†ria                                                      
&glob val6  Admiss∆o na ZFM - Zona Franca de Manaus                                  
&glob val7  Admiss∆o em Loja Franca                                                  
&glob val8  Admiss∆o em ALC - µrea de Livre ComÇrcio                                 
&glob val9  Admiss∆o em DAD - Dep¢sito Aduaneiro de Distribuiá∆o                     
&glob val10 Admiss∆o em DEA - Dep¢sito Especial Alfandegado                          
&glob val11 Admiss∆o em ZPE - Zona de Processamento de Exportaá∆o                    
&glob val12 Consumo e Admiss∆o Tempor†ria                                            
&glob val13 Nacionalizaá∆o de Admiss∆o Tempor†ria                                    
&glob val14 Nacionalizaá∆o de Entreposto Aduaneiro                                   
&glob val15 Sa°da de EIZOF - Entreposto Internacional da ZFM                         
&glob val16 Sa°da de Entreposto Industrial                                           
&glob val17 Nacionalizaá∆o de DEA - Dep¢sito Especial Alfandegado                    
&glob val18 Nacionalizaá∆o de DAD - Dep¢sito Aduaneiro de Distribuiá∆o               
&glob val19 Internaá∆o de ZFM-PI - Zona Franca de Manaus (Produto Industrializado)   
&glob val20 Internaá∆o de ZFM-PE - Zona Franca de Manaus (Produto Estrangeiro)       
&glob val21 Internaá∆o de ALC - µrea de Livre ComÇrcio                               
&glob val22 Internaá∆o da ZPE - Zona de Processamento de Exportaá∆o                  
&glob val23 Transferància da ZFM (produto industrial)  para ALC                      
&glob val24 Transferància da ZFM (produto estrangeiro) para ALC                      
&glob val25 Transferància da ZFM (produto industrial)  para ZPE                      
&glob val26 Transferància da ZFM (produto estrangeiro) para ZPE                      
&glob val27 Transferància da ALC (produto estrangeiro) para ZFM                      
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Consumo                                                                     
&glob val2  Admiss∆o em Entreposto Aduaneiro                                            
&glob val3  Admiss∆o em EIZOF - Entreposto Internacional da ZFM                         
&glob val4  Admiss∆o em Entreposto Industrial                                           
&glob val5  Admiss∆o Tempor†ria                                                         
&glob val6  Admiss∆o na ZFM - Zona Franca de Manaus                                     
&glob val7  Admiss∆o em Loja Franca                                                     
&glob val8  Admiss∆o em ALC - µrea de Livre ComÇrcio                                    
&glob val9  Admiss∆o em DAD - Dep¢sito Aduaneiro de Distribuiá∆o                        
&glob val10 Admiss∆o em DEA - Dep¢sito Especial Alfandegado                             
&glob val11 Admiss∆o em ZPE - Zona de Processamento de Exportaá∆o                       
&glob val12 Consumo e Admiss∆o Tempor†ria                                               
&glob val13 Nacionalizaá∆o de Admiss∆o Tempor†ria                                       
&glob val14 Nacionalizaá∆o de Entreposto Aduaneiro                                      
&glob val15 Sa°da de EIZOF - Entreposto Internacional da ZFM                            
&glob val16 Sa°da de Entreposto Industrial                                              
&glob val17 Nacionalizaá∆o de DEA - Dep¢sito Especial Alfandegado                       
&glob val18 Nacionalizaá∆o de DAD - Dep¢sito Aduaneiro de Distribuiá∆o                  
&glob val19 Internaá∆o de ZFM-PI - Zona Franca de Manaus (Produto Industrializado)      
&glob val20 Internaá∆o de ZFM-PE - Zona Franca de Manaus (Produto Estrangeiro)          
&glob val21 Internaá∆o de ALC - µrea de Livre ComÇrcio                                  
&glob val22 Internaá∆o da ZPE - Zona de Processamento de Exportaá∆o                     
&glob val23 Transferància da ZFM (produto industrial)  para ALC                         
&glob val24 Transferància da ZFM (produto estrangeiro) para ALC                         
&glob val25 Transferància da ZFM (produto industrial)  para ZPE                         
&glob val26 Transferància da ZFM (produto estrangeiro) para ZPE                         
&glob val27 Transferància da ALC (produto estrangeiro) para ZFM                         
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Consumo                                                                          
&glob val2  Admiss∆o em Entreposto Aduaneiro                                                 
&glob val3  Admiss∆o em EIZOF - Entreposto Internacional da ZFM                              
&glob val4  Admiss∆o em Entreposto Industrial                                                
&glob val5  Admiss∆o Tempor†ria                                                              
&glob val6  Admiss∆o na ZFM - Zona Franca de Manaus                                          
&glob val7  Admiss∆o em Loja Franca                                                          
&glob val8  Admiss∆o em ALC - µrea de Livre ComÇrcio                                         
&glob val9  Admiss∆o em DAD - Dep¢sito Aduaneiro de Distribuiá∆o                             
&glob val10 Admiss∆o em DEA - Dep¢sito Especial Alfandegado                                  
&glob val11 Admiss∆o em ZPE - Zona de Processamento de Exportaá∆o                            
&glob val12 Consumo e Admiss∆o Tempor†ria                                                    
&glob val13 Nacionalizaá∆o de Admiss∆o Tempor†ria                                            
&glob val14 Nacionalizaá∆o de Entreposto Aduaneiro                                           
&glob val15 Sa°da de EIZOF - Entreposto Internacional da ZFM                                 
&glob val16 Sa°da de Entreposto Industrial                                                   
&glob val17 Nacionalizaá∆o de DEA - Dep¢sito Especial Alfandegado                            
&glob val18 Nacionalizaá∆o de DAD - Dep¢sito Aduaneiro de Distribuiá∆o               o       
&glob val19 Internaá∆o de ZFM-PI - Zona Franca de Manaus (Produto Industrializado)           
&glob val20 Internaá∆o de ZFM-PE - Zona Franca de Manaus (Produto Estrangeiro)               
&glob val21 Internaá∆o de ALC - µrea de Livre ComÇrcio                                       
&glob val22 Internaá∆o da ZPE - Zona de Processamento de Exportaá∆o                          
&glob val23 Transferància da ZFM (produto industrial)  para ALC                              
&glob val24 Transferància da ZFM (produto estrangeiro) para ALC                              
&glob val25 Transferància da ZFM (produto industrial)  para ZPE                              
&glob val26 Transferància da ZFM (produto estrangeiro) para ZPE                              
&glob val27 Transferància da ALC (produto estrangeiro) para ZFM                              
&ENDIF

{include/ind11-50.i {1} {2}}
/*{include/ind01-10.i {1} {2}}*/
/* Fim */

