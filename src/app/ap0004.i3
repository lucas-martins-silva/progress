/******************************************************************************
***                         
*** app/ap0004.i3 - Gera‡Æo Autom tica de Impostos - AP.
***                             
******************************************************************************/

assign i-sequencia = 10.

find last b-{1} where b-{1}.ep-codigo     = {2}.ep-codigo
                and   b-{1}.cod-estabel   = {2}.cod-estabel
                and   b-{1}.cod-fornec    = {2}.cod-fornec
                and   b-{1}.cod-esp       = {2}.cod-esp
                and   b-{1}.serie         = {2}.serie
                and   b-{1}.nr-docto      = {2}.nr-docto
                and   b-{1}.parcela       = {2}.parcela
                and   b-{1}.cod-imposto   = {2}.cod-imposto no-error.
                        
if  avail b-{1} then
    assign i-sequencia = b-{1}.num-seq-impto + 10.
                    
create b-{1}.
assign b-{1}.ep-codigo           = tt-{2}.ep-codigo
       b-{1}.cod-est             = tt-{2}.cod-est
       b-{1}.cod-fornec          = tt-{2}.cod-fornec
       b-{1}.cod-esp             = tt-{2}.cod-esp
       b-{1}.serie               = tt-{2}.serie
       b-{1}.nr-docto            = tt-{2}.nr-docto
       b-{1}.parcela             = tt-{2}.parcela
       b-{1}.origem-impto        = tt-{2}.origem-impto
       b-{1}.lancamento          = tt-{2}.lancamento
       b-{1}.trans-impto-ap      = tt-{2}.trans-impto-ap
       b-{1}.dt-emissao          = tt-{2}.dt-emissao
       b-{1}.dt-transacao        = tt-{2}.dt-transacao
       b-{1}.dt-vencimen         = {2}.dt-vencimen
       b-{1}.ind-data-base       = {2}.ind-data-base
       b-{1}.nat-operacao        = {2}.nat-operacao
       b-{1}.cod-classificacao   = {2}.cod-classificacao
       b-{1}.ind-tipo-imposto    = {2}.ind-tipo-imposto
       b-{1}.tp-codigo           = {2}.tp-codigo
       b-{1}.hp-codigo           = {2}.hp-codigo
       b-{1}.historico           = {2}.historico
       b-{1}.cod-retencao        = {2}.cod-retencao
       b-{1}.conta-imposto       = {2}.conta-imposto
       b-{1}.ct-imposto          = {2}.ct-imposto
       b-{1}.sc-imposto          = {2}.sc-imposto
       b-{1}.conta-percepcao     = {2}.conta-percepcao
       b-{1}.ct-percepcao        = {2}.ct-percepcao
       b-{1}.sc-percepcao        = {2}.sc-percepcao
       b-{1}.conta-retencao      = {2}.conta-retencao
       b-{1}.ct-retencao         = {2}.ct-retencao
       b-{1}.sc-retencao         = {2}.sc-retencao
       b-{1}.conta-iva-liberado  = {2}.conta-iva-liberado
       b-{1}.ct-iva-liberado     = {2}.ct-iva-liberado
       b-{1}.sc-iva-liberado     = {2}.sc-iva-liberado
       b-{1}.conta-saldo-credito = {2}.conta-saldo-credito
       b-{1}.ct-saldo-credito    = {2}.ct-saldo-credito
       b-{1}.sc-saldo-credito    = {2}.sc-saldo-credito
       b-{1}.num-seq-impto       = i-sequencia
       b-{1}.contabilizou        = no
       b-{1}.tipo                = 2
       b-{1}.vl-base             = {3}.
                        
if (b-{1}.trans-impto-ap = 17  or
    b-{1}.trans-impto-ap = 18) then do:
        
    {utp/ut-liter.i Imposto_Gerado_Devido_Varia‡Æo_Monet ria_do_T¡tulo}
    assign b-{1}.obs = trim(return-value).
            
end.
else do:    
    assign b-{1}.obs = {adinc/i01ad290.i 04 b-{1}.origem-impto}.
end.
    
assign b-{1}.mo-codigo           = 0
       b-{1}.cotacao-dia         = 1
       b-{1}.cod-imposto         = {2}.cod-imposto
       b-{1}.perc-imposto        = {2}.perc-imposto
       b-{1}.perc-percepcao      = {2}.perc-percepcao
       b-{1}.perc-retencao       = {2}.perc-retencao
       b-{1}.perc-iva-liberado   = {2}.perc-iva-liberado.
       
assign b-{1}.vl-imposto          = fn_ajust_dec((b-{1}.vl-base * (b-{1}.perc-imposto   / 100)),0).
assign b-{1}.vl-percepcao        = fn_ajust_dec((b-{1}.vl-base * (b-{1}.perc-percepcao / 100)),0).
assign b-{1}.vl-retencao         = fn_ajust_dec((b-{1}.vl-base * (b-{1}.perc-retencao  / 100)),0).
assign b-{1}.vl-saldo-imposto    = b-{1}.vl-imposto
       b-{1}.vl-base-me          = b-{1}.vl-base
       b-{1}.vl-imposto-me       = b-{1}.vl-imposto
       b-{1}.vl-saldo-imposto-me = b-{1}.vl-saldo-imposto
       b-{1}.vl-percepcao-me     = b-{1}.vl-percepcao
       b-{1}.vl-retencao-me      = b-{1}.vl-retencao.
        
if  b-{1}.vl-imposto   = 0 and
    b-{1}.vl-percepcao = 0 and
    b-{1}.vl-retencao  = 0 then do:
    delete b-{1}.
end.
            
/* Fim de Include */
