/*******************************************************************************************************
**
** PROCEDURE:  LiberarSucessoras
** OBJETIVO:   Libera‡Æo de relacionamentos pert de sucessoras da opera‡Æo da ordem
** PARAMETROS: buffer b-oper-ord, data e hora (segs) de libera‡Æo
**
*******************************************************************************************************/
PROCEDURE LiberarSucessoras:

    define parameter buffer b-oper-ord for oper-ord.
    define input parameter p-dat-liber      as date    no-undo.
    define input parameter p-qtd-segs-liber as integer no-undo.
    
    def buffer b2-oper-ord    for oper-ord.
    def buffer b-pert-ordem   for pert-ordem.
    def buffer b-grup-maquina for grup-maquina.
    
    def var v-lead-time       as decimal             no-undo.
    def var v-fator           as decimal             no-undo.
    def var v-dat-liber       as date                no-undo.
    def var v-qtd-segs-liber  as integer             no-undo.
    def var v-log-pto-control as logical initial yes no-undo.
    
    /*** Verifica‡Æo para saber se opera‡Æo ‚ reportada ***/
    if b-oper-ord.tipo-oper = 2 then 
       assign v-log-pto-control = no.
    else do: 
       find b-grup-maquina where
            b-grup-maquina.gm-codigo = b-oper-ord.gm-codigo no-lock no-error.
       if available grup-maquina and 
          not grup-maquina.log-pto-control then 
       assign v-log-pto-control = no.
    end.
    
    blk-b-pert-ordem:
    for each b-pert-ordem where 
             b-pert-ordem.nr-ord-produ      = b-oper-ord.nr-ord-produ   and
             b-pert-ordem.num-operac-predec = b-oper-ord.sequencia and
             b-pert-ordem.log-ativo exclusive-lock:
                
        if  b-oper-ord.val-perc-avanco >= (100 - b-pert-ordem.overlap) or 
            b-oper-ord.log-operac-finaliz or 
            not v-log-pto-control then do:
            assign b-pert-ordem.log-ativo = no
                   v-dat-liber          = p-dat-liber
                   v-qtd-segs-liber     = p-qtd-segs-liber.
                                      
            if  not can-find (first pert-ordem where
                                    pert-ordem.nr-ord-produ      = b-pert-ordem.nr-ord-produ     and
                                    pert-ordem.num-operac-suces  = b-pert-ordem.num-operac-suces and
                                    pert-ordem.log-ativo) then do:

                find b2-oper-ord where
                     b2-oper-ord.nr-ord-produ = b-pert-ordem.nr-ord-produ and
                     b2-oper-ord.sequencia    = b-pert-ordem.num-operac-suces exclusive-lock no-error.
                
                /*** Verificar como evitar no futuro esse find pelo grup-maquina ***/
                find grup-maquina where
                     grup-maquina.gm-codigo = b2-oper-ord.gm-codigo no-lock no-error.
 
                assign b2-oper-ord.log-restric-pert      = no 
                       b2-oper-ord.dat-liber-operac      = p-dat-liber
                       b2-oper-ord.qtd-segs-liber-operac = p-qtd-segs-liber.
 
                if b2-oper-ord.log-restric-operac then next blk-b-pert-ordem. 
                
                if  available grup-maquina
                          and grup-maquina.log-pto-control then
                    next.
                                 
                case b2-oper-ord.un-med-tempo:
                    when 1 then assign v-fator = 3600.
                    when 2 then assign v-fator = 60.
                    when 3 then assign v-fator = 1.
                    when 4 then assign v-fator = 86400.
                end case.
                
                assign v-lead-time = v-fator * (b2-oper-ord.tempo-prepar + 
                                                b2-oper-ord.tempo-maquin).
                
                if  available grup-maquina and b2-oper-ord.tipo-oper = 1 then 
                    assign v-lead-time = max(grup-maquina.qtd-lead-time * 3600 , v-lead-time).
                
                /*** OBS: Soma tempo de transporte da rede pert mais o tempo pos-processo ***/
                assign v-lead-time = (v-lead-time + 
                                     (b-pert-ordem.transporte * 3600) +
                                     (b2-oper-ord.qtd-tempo-pos-proces * v-fator)).

                run pi-corrige-data-tempo (input-output v-dat-liber, 
                                           input-output v-qtd-segs-liber, 
                                           Input v-lead-time).
                        
                run LiberarSucessoras(buffer b2-oper-ord,
                                      v-dat-liber,
                                      v-qtd-segs-liber).
            end.
        end.
      

    end.
END PROCEDURE.


/*******************************************************************************************************
**
** PROCEDURE:  BloquearSucessoras
** OBJETIVO:   Bloquear relacionamentos pert de sucessoras da opera‡Æo da ordem
** PARAMETROS: buffer b-oper-ord
**
*******************************************************************************************************/
PROCEDURE BloquearSucessoras:

    define parameter buffer b-oper-ord for oper-ord.
    
    def buffer b2-oper-ord   for oper-ord.
    def buffer b2-pert-ordem for pert-ordem.
    
    blk-b-pert-ordem:
    for each b2-pert-ordem where 
             b2-pert-ordem.nr-ord-produ      = b-oper-ord.nr-ord-produ   and
             b2-pert-ordem.num-operac-predec = b-oper-ord.num-operac-sfc and
             not b2-pert-ordem.log-ativo exclusive-lock:
        
        if b-oper-ord.val-perc-avanco < (100 - b2-pert-ordem.overlap) and 
           not b-oper-ord.log-operac-finaliz  then do:
           
            assign b2-pert-ordem.log-ativo = yes.
                
            find b2-oper-ord where
                 b2-oper-ord.nr-ord-produ = b2-pert-ordem.nr-ord-produ and
                 b2-oper-ord.sequencia    = b2-pert-ordem.num-operac-suces exclusive-lock no-error.
            
            if not b2-oper-ord.log-restric-pert then do:
                    
                assign b2-oper-ord.log-restric-pert      = yes 
                       b2-oper-ord.dat-liber-operac      = ?
                       b2-oper-ord.qtd-segs-liber-operac = 0.
                
                run BloquearSucessoras(buffer b2-oper-ord).
            end.          
        end.            
    end.             
END PROCEDURE.
