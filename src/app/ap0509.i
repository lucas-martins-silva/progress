/***************************************************************************
**
** AP0509.I
** DISPLAY DOS VALORES
**
***************************************************************************/

 find empresa
      where empresa.ep-codigo  = tit-ap.ep-codigo no-lock no-error.
 find emitente
      where emitente.cod-emite = tit-ap.cod-fornec no-lock no-error.
 if  tit-ap.ct-conta-db <> ct-initial then do:
     assign c-conta-db = string(tit-ap.conta-debito,
                          param-global.formato-conta-contabil).
     disp c-conta-db with frame f-tela.
 end. 

 assign de-vl-urv  = tit-ap.valor-saldo
        de-vl-orig = tit-ap.valor-saldo.                    


 assign c-desc-est = {adinc/i03ad170.i 4 tit-ap.estado}
        c-docto    = fill(" ", 16 - length(emite-ap.nr-docto)) + emite-ap.nr-docto.

 assign c-nome-aux = substr(empresa.nome,1,35).

 disp c-prg-vrs
      c-nome-aux
      emite-ap.referencia
      tit-ap.dt-emissao
      emite-ap.cod-fornec
      tit-ap.dt-transacao
      emite-ap.cod-estabel
      emite-ap.cod-esp
      emite-ap.serie
      c-docto emite-ap.parcela
      tit-ap.dt-vencimen
      tit-ap.moeda
      de-vl-urv
      de-vl-orig
      tit-ap.dt-desconto
      tit-ap.vl-desconto
      c-desc-est
      with frame f-tela.

 if  available emitente then
     disp emitente.nome-emit
          emitente.telefone[1]
          emitente.endereco
          emitente.cidade
          emitente.estado
          with frame f-tela.
 find first mov-ap
     where mov-ap.ep-codigo = tit-ap.ep-codigo
     and   mov-ap.cod-forn  = tit-ap.cod-forn
     and   mov-ap.cod-est   = tit-ap.cod-est
     and   mov-ap.cod-esp   = tit-ap.cod-esp
     and   mov-ap.serie     = tit-ap.serie
     and   mov-ap.nr-docto  = tit-ap.nr-docto
     and   mov-ap.parcela   = tit-ap.parcela
     and  (mov-ap.transacao = 1
     or   (mov-ap.transacao = 6
     and   mov-ap.lancamento = 2)) no-lock no-error.

     assign c-historico = "HISTORICO: " + if avail mov-ap then mov-ap.historico
                                  else "".
 disp c-historico
      tit-ap.moeda
      with frame f-tela.
 assign c-historico = " ".

 if avail emitente then do:
    find conta-ap
         where conta-ap.ep-codigo   = emite-ap.ep-codigo
         and   conta-ap.cod-estabel = emite-ap.cod-estabel
         and   conta-ap.cod-esp     = emite-ap.cod-esp
         and   conta-ap.cod-grupo   = emitente.cod-gr-forn no-lock no-error.
    if  available conta-ap then do:
        assign c-conta = string(conta-ap.conta-saldo,
                            param-global.formato-conta-contabil).
        disp c-conta with frame f-tela.
    end.
 end.
 assign emite-ap.emitiu = yes.
down with frame f-tela.
/*ap0509.i*/
