/********************************************************************************
**
**  Include: abp/ab0503.i3
**
**  Imprime Relat¢rio por Data e Hora
**
********************************************************************************/
procedure pi-data-hora:

for each  mab-control-bomba
    WHERE mab-control-bomba.num-docto      >=  tt-param.i-docto-ini
    and   mab-control-bomba.num-docto      <=  tt-param.i-docto-fim
    and   mab-control-bomba.dat-apont      >=  tt-param.d-data-ini
    and   mab-control-bomba.dat-apont      <=  tt-param.d-data-fim
    and   mab-control-bomba.hra-apont      >=  tt-param.c-hora-ini
    and   mab-control-bomba.hra-apont      <=  tt-param.c-hora-fim
    and   mab-control-bomba.cod-posto-orig >=   tt-param.c-posto-ini
    and   mab-control-bomba.cod-posto-orig <=   tt-param.c-posto-fim
    and ((mab-control-bomba.idi-tip-movto   = 1 and l-afericoes) 
      or (mab-control-bomba.idi-tip-movto   = 2 and l-transf)
      or (mab-control-bomba.idi-tip-movto   = 3 and l-leitura))no-lock
    break by mab-control-bomba.dat-apont
          by mab-control-bomba.hra-apont
          by mab-control-bomba.idi-tip-movto:

    for first mab-bomba
        where mab-bomba.cod-posto = mab-control-bomba.cod-posto-orig
        AND   mab-bomba.cod-bomba = mab-control-bomba.cod-bomba,
        first mab-tip-mater
        where mab-tip-mater.cod-tip-mater = mab-bomba.cod-tip-mater no-lock:
    END.
    
     if not avail mab-tip-mater then next.
        assign   cApont     = {frinc/i00fr056.i 4  mab-control-bomba.idi-tip-movto}.
               
          

    if  first-of(mab-control-bomba.dat-apont) then do:
                   disp    cData     AT 01   format "99/99/9999"               
                           cHora     AT 12                  
                           cTpApont  AT 18                  
                           cDocto    AT 35                  
                           cPstOrig  AT 45                  
                           cBomba    AT 56                  
                           cMaterial AT 65                  
                           cValIni-1 AT 82                  
                           cValFim-1 AT 96                 
                           cQtde-1   AT 110
                           cPstDest  AT 124   FORMAT "x(07)"
                           with frame f-cabecalho-2.
                                
                      
    end.   
    
    disp mab-control-bomba.dat-apont           NO-LABEL  AT 01    format "99/99/9999" when first-of(mab-control-bomba.dat-apont)
         mab-control-bomba.hra-apont           NO-LABEL  AT 12    FORMAT "99:99"       
         cApont                                NO-LABEL  AT 18    format "x(16)"       when first-of(mab-control-bomba.idi-tip-movt)
         mab-control-bomba.num-docto           NO-LABEL  AT 35    FORMAT ">>>>>>>>9" 
         mab-control-bomba.cod-posto-orig      NO-LABEL  AT 45                       
         mab-control-bomba.cod-bomba           NO-LABEL  AT 56    FORMAT "X(08)"     
         mab-tip-mater.des-tip-mater           NO-LABEL  AT 65    format "x(16)"     
         mab-control-bomba.val-leitura-inicial NO-LABEL  AT 82    FORMAT ">>,>>>,>>9.99"                   
         mab-control-bomba.val-leitura-final   NO-LABEL  AT 96    FORMAT ">>,>>>,>>9.99"                  
         mab-control-bomba.val-quant           NO-LABEL  AT 110   FORMAT ">>,>>>,>>9.99"
         mab-control-bomba.cod-posto-dest      NO-LABEL  AT 124   format "x(07)"                   
         with frame f-dados-2.              
             down with frame f-dados-2. 
            
    if  last-of(mab-control-bomba.dat-apont) then do:
         if tt-param.l-insere = yes then do:
            page.
         end. 
         else do:   
              put skip(1).          
         end.
    end.         


   
           
           
                   
end.   

return 'OK'.

end procedure.
/* FIM */
