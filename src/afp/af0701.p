def input param p-cod-tip-doc as int no-undo.
def output param v-posicao-ini as int extent 10 no-undo.
def output param v-posicao-fim as int extent 10 no-undo.

def var v-cont        as int no-undo.

for each mla-chave-doc-aprov no-lock
   where mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc
      by mla-chave-doc-aprov.posicao-ini:
    
    assign v-cont = v-cont + 1
           v-posicao-ini[v-cont] = mla-chave-doc-aprov.posicao-ini
           v-posicao-fim[v-cont] = mla-chave-doc-aprov.posicao-fim.
end.

