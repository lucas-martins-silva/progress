/* pr‚-requisito para rodar o login dos produtos ‚ setar 07 parametros no atalho */
/* -param "TEC,MBC,,usuario,senha,linha,coluna */
if v_cod_usuar_corren = "" then do:
  if num-entries(session:parameter) = 7 then do:         
      find first param-bc no-lock no-error.
      if available param-bc then do:
          assign error-status:error = no. 
          assign i-linha  = integer(entry(6,session:parameter)) 
                 i-coluna = integer(entry(7,session:parameter)) no-error.            
          if error-status:error = yes then do:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Linha/Coluna_Invalidos._Erro" *}
              message RETURN-VALUE + ': ' + string(error-status:get-number(1)) view-as alert-box.
              quit.
          end. /* if */
          &if '{&mgcld_version}' <= '2.04' &then
              if param-bc.int-2 = 1 then do:
          &else
              if param-bc.ind-sistema = 1 then do:
          &endif
              run bcp/bc9112c.p.
          end. /* if */
          
          run btb/btb906za.p.
          
          if  return-value       <> "OK":U 
          and trim(return-value) <> "":U
          then do:                                
             quit.
          end.   
          
          /* verificacao p login no Magnus */
          
          &if '{&mgcld_version}' <= '2.04' &then
              if param-bc.int-2 = 2 then do:
          &else
              if param-bc.ind-sistema = 2 then do:
          &endif
              run bcp/bc9112a.p.
          end. /* if */
      end. /* if */
      else do:
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Coleta_Dados_Nao_Implantado(EMS)" *}
          message RETURN-VALUE view-as alert-box.
          quit.
      end. /* else */
  end. /* if */
end. /* if */  
