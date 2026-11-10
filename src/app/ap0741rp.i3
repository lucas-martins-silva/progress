/*******************************************************************************
***
*** app/ap0741rp.i3 - Literais.
***
*******************************************************************************/

{utp/ut-liter.i CONTAS_A_PAGAR}
assign c-sistema = trim(return-value).

{utp/ut-liter.i RazÆo_Movimentos}
assign c-titulo-relat = trim(return-value).  

{utp/ut-liter.i Registros}
assign c-acomp = trim(return-value).

{utp/ut-liter.i Trans}
assign c-trans:label in frame f-detalhe = trim(return-value).

{utp/ut-liter.i Fornecedor:}
assign c-fornecedor = trim(return-value).

{utp/ut-liter.i Esp‚cie:}
assign c-especie = trim(return-value).

{utp/ut-liter.i Grupo_Fornecedor:}
assign c-grupo = trim(return-value).

{utp/ut-liter.i Matriz:}
assign c-matriz = trim(return-value).

{utp/ut-liter.i Moeda:}
assign c-moeda = trim(return-value).

{utp/ut-liter.i Prazo_M‚dio_de_Compra * L}
assign i-prazo:label in frame f-medio   = trim(return-value)
       i-prazo:label in frame f-pmc-amp = trim(return-value).
    
{utp/ut-liter.i Atraso_M‚dio_de_Pagto * L}
assign i-atraso:label in frame f-medio   = trim(return-value)
       i-atraso:label in frame f-pmc-amp = trim(return-value).
    
{utp/ut-liter.i Saldo_Anterior * L}
assign de-tot-saldo:label in frame f-medio   = trim(return-value)
       de-tot-saldo:label in frame f-resumo  = trim(return-value)
       de-tot-saldo:label in frame f-resumo1 = trim(return-value).
    
{utp/ut-liter.i Saldo_Atual * L}
assign de-tot-atual:label in frame f-medio   = trim(return-value)
       de-tot-atual:label in frame f-resumo  = trim(return-value)
       de-tot-atual:label in frame f-resumo1 = trim(return-value).

{utp/ut-liter.i Total_D‚bito * L}
assign de-total-geral-db:label in frame f-geral = trim(return-value).

{utp/ut-liter.i Total_Saldo_Anterior * L}
assign de-ger-saldo:label in frame f-geral  = trim(return-value)
       de-ger-saldo:label in frame f-geral1 = trim(return-value).

{utp/ut-liter.i Total_Cr‚dito * L}
assign de-total-geral-cr:label in frame f-geral = trim(return-value).

{utp/ut-liter.i Total_Saldo_Atual * L}
assign de-ger-atual:label in frame f-geral  = trim(return-value)
       de-ger-atual:label in frame f-geral1 = trim(return-value).

{utp/ut-liter.i Total_PEF * L}
assign de-tot-pef:label in frame f-geral = trim(return-value).

{utp/ut-liter.i PMC * R}
assign i-prazo:label in frame f-resumo  = trim(return-value)
       i-prazo:label in frame f-resumo1 = trim(return-value).

{utp/ut-liter.i AMP * R}
assign i-atraso:label in frame f-resumo  = trim(return-value)
       i-atraso:label in frame f-resumo1 = trim(return-value).

/* Fim de Include */
