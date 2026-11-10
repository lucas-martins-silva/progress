/****************************************************************************
***
*** app/ap0706rp.i3 - Tradu‡äes Form's.
***
****************************************************************************/

{utp/ut-field.i mgadm mov-ap transacao 2}
assign c-trans:label in frame f-detalhe = return-value.
{utp/ut-liter.i Tp * L}
assign c-tipo:label in frame f-detalhe = trim(return-value).

{utp/ut-liter.i Prazo_M‚dio_de_Compra * L}
assign i-prazo:label in frame f-medio   = trim(return-value)
       i-prazo:label in frame f-pmc-amp = trim(return-value).
{utp/ut-liter.i Atraso_M‚dio_de_Pagto * L}
assign i-atraso:label in frame f-medio   = trim(return-value)
       i-atraso:label in frame f-pmc-amp = trim(return-value).

{utp/ut-liter.i Saldo_Anterior * L}
assign de-tot-saldo:label in frame f-medio  = trim(return-value)
       de-tot-saldo:label in frame f-resumo = trim(return-value).
{utp/ut-liter.i Saldo_Atual * L}
assign de-tot-atual:label in frame f-medio  = trim(return-value)
       de-tot-atual:label in frame f-resumo = trim(return-value).

{utp/ut-liter.i Total_D‚bito * L}
assign de-total-geral-db:label in frame f-geral = trim(return-value).
{utp/ut-liter.i Total_Saldo_Anterior * L}
assign de-ger-saldo:label in frame f-geral = trim(return-value).
{utp/ut-liter.i Total_Cr‚dito * L}
assign de-total-geral-cr:label in frame f-geral = trim(return-value).
{utp/ut-liter.i Total_Saldo_Atual * L}
assign de-ger-atual:label in frame f-geral = trim(return-value).
{utp/ut-liter.i Total_PEF * L}
assign de-tot-pef:label in frame f-geral = trim(return-value).

{utp/ut-liter.i Saldo_Anterior_Esp‚cie * L}
assign de-sal-esp:label in frame f-tot-espec = trim(return-value).
{utp/ut-liter.i Saldo_Atual_Esp‚cie * L}
assign de-tot-esp:label in frame f-tot-espec = trim(return-value).
{utp/ut-liter.i Total_Fornecedor * L}
assign de-tot-fornec:label in frame f-tot-fornec = trim(return-value).

{utp/ut-liter.i Total_Prazo_M‚dio_de_Compra * L}
assign i-tot-gr-prazo:label in frame f-total-grupo = trim(return-value).
{utp/ut-liter.i Total_Atraso_M‚dio_de_Pagto * L}
assign i-tot-gr-atraso:label in frame f-total-grupo = trim(return-value).
{utp/ut-liter.i Total_Saldo_Anterior_do_Grupo * L}
assign de-tot-gr-saldo:label in frame f-total-grupo = trim(return-value).
{utp/ut-liter.i Total_Saldo_Atual_do_Grupo * L}
assign de-tot-gr-atual:label in frame f-total-grupo = trim(return-value).

{utp/ut-liter.i PMC * R}
assign i-prazo:label in frame f-resumo = trim(return-value).
{utp/ut-liter.i AMP * R}
assign i-atraso:label in frame f-resumo = trim(return-value).
{utp/ut-field.i mgadm tit-ap matriz 2}
assign b-emitente.cod-emitente:label in frame f-matriz = return-value.

/* Fim de Include */
