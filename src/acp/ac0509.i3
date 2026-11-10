/*******************************************************************************
**
** ac0509.i3  : Include para somar quantidades.
** Parƒmetros : {1} e {2} Qtde/Valor Cotas pedida, faturada
********************************************************************************/
 de-qtde-tot-realiz = de-qtde-tot-realiz +
               if par-cota.tipo-controle = 2 then {2}
                                                else {1}.  
                                                                                        
 
/*acp/ac0509.i3*/ 
