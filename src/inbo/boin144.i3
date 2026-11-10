/**********************************************************************************
**
** AlterarAreaGM
** OBJETIVO: Altera‡Æo de area de produ‡Æo do grupo de m quina 
             Altera areas de centros de trabalho.
             Na versÆo 2.02 nÆo ser  p¢ssivel ter 2 centros de trabalho em 
             diferentes areas de produ‡Æo
**             
**********************************************************************************/
PROCEDURE AlterarAreaGM:

    define parameter buffer b-grup-maquina for grup-maquina.
    
    for each ctrab where
             ctrab.gm-codigo = b-grup-maquina.gm-codigo:
       
        for each area-produc-ctrab where
                 area-produc-ctrab.cod-ctrab       =  ctrab.cod-ctrab and
                 area-produc-ctrab.dat-fim-valid   >  today           and
                 area-produc-ctrab.cod-area-produc <> b-grup-maquina.cod-area-produc:
            
            assign area-produc-ctrab.cod-area-produc = b-grup-maquina.cod-area-produc.
    
        end.
        
        if not can-find 
            (first area-produc-ctrab where
                   area-produc-ctrab.cod-ctrab       =  ctrab.cod-ctrab) then do:
            create area-produc-ctrab.
            assign area-produc-ctrab.cod-ctrab       =  ctrab.cod-ctrab 
                   area-produc-ctrab.gm-codigo       =  ctrab.gm-codigo
                   area-produc-ctrab.cod-area-produc =  b-grup-maquina.cod-area-produc
                   area-produc-ctrab.dat-inic-valid  =  today
                   area-produc-ctrab.dat-fim-valid   =  date(12,31,9999).
        end.           
    
    end.        
        
END PROCEDURE. 
