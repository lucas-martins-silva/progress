/***************************************************************************
**
** app/ap0532.i - Include Diferen‡a DIRF pessoa f¡sica - Acumula Estabel
**
***************************************************************************/
/* y2kready */

for each estabelec 
    where estabelec.cod-est >= tt-param.cod-est-ini 
    and   estabelec.cod-est <= tt-param.cod-est-fim
    no-lock on stop undo, leave:                                   
    for each dirf-apf
        where dirf-apf.ep-codigo    = tt-param.i-ep-codigo
        and   dirf-apf.cod-estabel  = estabelec.cod-est
        and   dirf-apf.cod-emitente >= tt-param.cod-emit-ini
        and   dirf-apf.cod-emitente <= tt-param.cod-emit-fim
        and   dirf-apf.cod-retencao >= tt-param.cod-retencao-ini
        and   dirf-apf.cod-retencao <= tt-param.cod-retencao-fim
        and   dirf-apf.ano-base     >= tt-param.ano-base-ini
        and   dirf-apf.ano-base     <= tt-param.ano-base-fim
        no-lock:  
    
        do  i-mes = tt-param.mes-ini to tt-param.mes-fim:
            assign c-erro = "".
            
            find first val-tab-prog-impto 
               where val-tab-prog-impto.nr-tab-progr  = i-nr-tab-progr 
                 and val-tab-prog-impto.dt-val-ini    <= p-data
                 and val-tab-prog-impto.dt-val-fim    >= p-data no-lock no-error.
            if  not avail val-tab-prog-impto then do:
                run utp/ut-msgs.p (input "msg",
                                   input 6804,
                                   input string(i-nr-tab-progr) + "~~" +
                                   string(p-data)).
                                   
                assign c-erro = return-value.                                   
            end.
        
            assign de-ir-calc = 0.
            if  avail val-tab-prog-impto then do:
                progr-block:
                for each tab-progres-ir
                   where tab-progres-ir.nr-tab-progr  = i-nr-tab-progr
                     and tab-progres-ir.seq-valid     = val-tab-prog-impto.seq-valid
                no-lock:            
                
                    if  dirf-apf.base-liquida[i-mes] >= tab-progres-ir.vl-faixa-ini
                    and dirf-apf.base-liquida[i-mes] <= tab-progres-ir.vl-faixa-fim then do:                
                        assign de-ir-calc = (dirf-apf.base-liquida[i-mes]
                                          * (tab-progres-ir.perc-faixa
                                          / 100))
                                          - tab-progres-ir.vl-deducao.
                        leave progr-block.
                    end.
                end.
            end.

            assign de-difer = dirf-apf.valor-irrf[i-mes] 
                            - de-ir-calc.

            if   de-difer <> 0 then do:
                 assign i-cod-rend = dirf-apf.cod-retencao.
                 if  i-cod-rend = 9991 then
                     assign i-cod-rend = 4424.
                 if c-erro <> "" then do:
                    assign de-ir-calc = 0 
                           de-difer   = 0 .
                    disp 0 @ dirf-apf.valor-irrf[i-mes] with frame f-detalhe.                                   
                 end.                               
                 else disp dirf-apf.valor-irrf[i-mes] with frame f-detalhe.
                 disp dirf-apf.cod-estabel     
                         dirf-apf.cod-emitente
                         i-cod-rend
                         dirf-apf.ano-base
                         i-mes                         
                         dirf-apf.base-liquida[i-mes]  
                         de-ir-calc                    
                         de-difer 
                         c-erro
                         with  frame f-detalhe.

                 down with frame f-detalhe.
                 if c-erro = "" then 
                    assign de-tot-inf = de-tot-inf 
                                   + dirf-apf.valor-irrf[i-mes].
                                   
                 assign de-tot-calc = de-tot-calc + de-ir-calc
                        de-tot-difer = de-tot-difer + de-difer.
            end.
        end.
        run pi-acompanhar in h-acomp (input string(c-ano + " " + string(dirf-apf.ano-base))).
    end.
end.                                                       

/*** Fim da Include ***/
