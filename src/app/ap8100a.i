/*************************************************************************
**  
**  Include: app/ap8100a.i - Contabiliza‡Æo.
**  
************************************************************************/
if  p-c-campo-9 = "i2" then do transaction:
    create lin-doc-pend.
    assign i-seq-acum                  = i-seq-acum + 1
           lin-doc-pend.ep-codigo      = {1}.ep-codigo
           lin-doc-pend.cod-estabel    = {1}.cod-estabel
           lin-doc-pend.referencia     = "AP" + string(p-da-campo-10)
           lin-doc-pend.sequencia      = i-seq-acum
           lin-doc-pend.ct-codigo      = p-c-campo-1
           lin-doc-pend.sc-codigo      = p-c-campo-2
           lin-doc-pend.conta-contabil = conta-contab.conta-contabil
           lin-doc-pend.reduzida       = 0
           lin-doc-pend.transacao      = p-i-campo-3
           lin-doc-pend.hp-codigo      = 0
           lin-doc-pend.complemento    = ""
           lin-doc-pend.historico      = (if  {1}.historico = ""
                                          then c-historico
                                          else {1}.historico)
           lin-doc-pend.valor          = p-de-campo-4
           lin-doc-pend.valor-fasb     = p-de-campo-5
           lin-doc-pend.valor-cmi      = p-de-campo-7
           lin-doc-pend.valor-presente = p-de-campo-8
           lin-doc-pend.ct-contr-par   = ct-initial
           lin-doc-pend.sc-contr-par   = sc-initial
           lin-doc-pend.contra-partida = ct-initial.

    ASSIGN lin-doc-pend.historico = REPLACE(lin-doc-pend.historico, CHR(10), " ")
           lin-doc-pend.historico = REPLACE(lin-doc-pend.historico, CHR(13), " ").

    assign de-dif          = if  lin-doc-pend.transacao = 1
                             then de-dif - lin-doc-pend.valor
                             else de-dif + lin-doc-pend.valor
           de-dif-fasb     = if  lin-doc-pend.transacao = 1
                             then de-dif-fasb - lin-doc-pend.valor-fasb
                             else de-dif-fasb + lin-doc-pend.valor-fasb
           de-dif-cmi      = if  lin-doc-pend.transacao = 1
                             then de-dif-cmi - lin-doc-pend.valor-cmi
                             else de-dif-cmi + lin-doc-pend.valor-cmi
           de-dif-presente = if  lin-doc-pend.transacao = 1
                             then de-dif-presente - lin-doc-pend.valor-presente
                             else de-dif-presente + lin-doc-pend.valor-presente.
end.
    
if  p-c-campo-9 = "i3" or 
    p-c-campo-9 = "i1" then do:
    if  c-programa-ap8100 = "AP/0708" then do transaction:
        create diario-ap.
        assign diario-ap.ep-codigo      = i-ep-codigo-usuario
               diario-ap.ct-conta       = p-c-campo-1
               diario-ap.sc-conta       = p-c-campo-2
               diario-ap.conta-contabil = conta-contab.conta-contabil
               diario-ap.dt-transacao   = {1}.dt-transacao
               diario-ap.transacao      = mov-ap.transacao
               diario-ap.referencia     = mov-ap.referencia
               diario-ap.cod-fornec     = {1}.cod-fornec
               diario-ap.cod-estabel    = {1}.cod-estabel
               diario-ap.cod-esp        = {1}.cod-esp
               diario-ap.serie          = {1}.serie
               diario-ap.nr-docto       = {1}.nr-docto
               diario-ap.parcela        = {1}.parcela
               diario-ap.nr-cheque      = string(mov-ap.nr-cheque)
               diario-ap.portador       = mov-ap.portador
               diario-ap.historico      = (if  {1}.historico = ""
                                           then c-historico
                                           else {1}.historico).

        ASSIGN diario-ap.historico = REPLACE(diario-ap.historico, CHR(10), " ")
               diario-ap.historico = REPLACE(diario-ap.historico, CHR(13), " ").

        &IF  "{&mgadm_dbtype}" = "PROGRESS" &THEN
            assign diario-ap.titulo     = string(rowid({1})).
        &ELSE    
            assign diario-ap.char-1     = string(rowid({1})).
        &ENDIF

        if  p-i-campo-3 = 1 then
            assign diario-ap.lancamento      = 1
                   diario-ap.vl-debito       = p-de-campo-4
                   diario-ap.vl-deb-fasb     = p-de-campo-5
                   diario-ap.vl-deb-cmi      = p-de-campo-7
                   diario-ap.vl-deb-presente = p-de-campo-8.
        else
            assign diario-ap.lancamento       = 2
                   diario-ap.vl-credito       = p-de-campo-4
                   diario-ap.vl-cred-fasb     = p-de-campo-5
                   diario-ap.vl-cred-cmi      = p-de-campo-7
                   diario-ap.vl-cred-presente = p-de-campo-8.

          IF  c-nom-prog-upc-mg97  <> "" OR
              c-nom-prog-dpc-mg97  <> "" OR
              c-nom-prog-appc-mg97 <> "" THEN DO:

              for each tt-epc where tt-epc.cod-event = "gera-contab":
                  delete tt-epc.
              end.
    
              create tt-epc.
              assign tt-epc.cod-event     = "gera-contab" 
                     tt-epc.cod-parameter = "rowid(diario-ap)"
                     tt-epc.val-parameter = string(rowid(diario-ap)).
    
              {include/i-epc201.i "gera-contab"}

              for each tt-epc where tt-epc.cod-event = "gera-lancto":
                  delete tt-epc.
              end.
    
              create tt-epc.
              assign tt-epc.cod-event     = "gera-lancto" 
                     tt-epc.cod-parameter = "diario-ap" + ";" + "{1}"
                     tt-epc.val-parameter = string(rowid(diario-ap)) + ";" + string(rowid({1})).
    
              {include/i-epc201.i "gera-lancto"}

          END.

    end.
    else do:
        assign c-campo-1   = p-c-campo-1
               c-campo-2   = p-c-campo-2
               de-campo-4  = p-de-campo-4
               de-campo-5  = p-de-campo-5
               de-campo-7  = p-de-campo-7
               de-campo-8  = p-de-campo-8.

        {app/ap8100a.i1 "{1}" "conta-contab.conta-contabil"}
    end.
end.

/* Fim de Include */
