/* ac9006.i - Leitura de cotas e monta quantidade prevista conforme parametros */

for each b-cotas {&cond-cotas}  no-lock.
    if par-cota.tipo-controle = 2 then
       assign de-valor-base = de-valor-base + b-cotas.vl-previsto.
    else 
       assign de-valor-base = de-valor-base + b-cotas.qt-prevista.
end.

