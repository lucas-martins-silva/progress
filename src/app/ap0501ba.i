/**********************************************************************
**
** app/ap0501ba.i - Include pesquisa faixa do IR
**
***********************************************************************/
if  i-nr-tab-progr <> 0 then do: /* Caso utilize tabela progressiva */    
    progr-block:
    for each tab-progres-ir
       where tab-progres-ir.nr-tab-progr  = i-nr-tab-progr
       and   tab-progres-ir.seq-valid     = val-tab-prog-impto.seq-valid
       no-lock:            
            
        if  tab-acum-emi.{1} >= tab-progres-ir.vl-faixa-ini
        and tab-acum-emi.{1} <= tab-progres-ir.vl-faixa-fim then do:                
            assign p-perc-faixa  = tab-progres-ir.perc-faixa
                   de-vl-deducao = tab-progres-ir.vl-deducao.
            leave progr-block.
        end.
    end.

    /** Bloco para as redu‡äes do IR pessoa f¡sica **/
    if  emitente.natureza = 1 then do:
        if  empresa-ir.ind-acum-estabel = yes then do:
            find dirf-apf
                 where dirf-apf.ep-codigo    = i-ep-codigo-usuario
                 and   dirf-apf.cod-estabel  = p-cod-estabel
                 and   dirf-apf.cod-emit     = p-emitente
                 and   dirf-apf.ano-base     = year(p-data)
                 and   dirf-apf.cod-retencao = p-cod-retencao 
                 no-lock no-error.
        end.
        else do:         
            find dirf-apf
                 where dirf-apf.ep-codigo    = i-ep-codigo-usuario
                 and   dirf-apf.cod-estabel  = "" 
                 and   dirf-apf.cod-emit     = p-emitente
                 and   dirf-apf.ano-base     = year(p-data)
                 and   dirf-apf.cod-retencao = p-cod-retencao 
                 no-lock no-error.
        end.
        if  avail dirf-apf then do:        
            assign de-deducoes   = fn_ajust_dec(( dirf-apf.nr-depend[i-mes-refer]
                                 * dirf-apf.ded-depend[i-mes-refer] ),0)
                                 + dirf-apf.ded-inss[i-mes-refer]
                                 + dirf-apf.ded-pensao[i-mes-refer].                                 
        end.               
    end.
    
    /*---------- Calcula valor do IR ----------*/
    if  p-perc-faixa <> 0 then do:
        assign p-valor-ir = fn_ajust_dec( ((tab-acum-emi.{1} - de-deducoes) * (p-perc-faixa / 100) ) ,0).
        assign p-valor-ir = p-valor-ir - de-vl-deducao.
           
        assign p-valor-ir = p-valor-ir - tab-acum-emi.vl-irrf.
        if  p-valor-ir < 0 or 
            p-valor-ir <= empresa-ir.vl-minimo-retencao then 
            p-valor-ir = 0.        
    end.        
    
end.

/* fim include */
