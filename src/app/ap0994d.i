/*******************************************************************************
**
**  AP0994D.I - INTEGRACAO COM CONTAS A PAGAR
**
*******************************************************************************/
do with stream-io frame f-cab:
    assign i-aux = 0
           i-parcela = 0
           de-variacao = 0
           de-tot-dif  = 0 
           l-pendente  = no.
    if tt-dados.cotacao = 0 then              
       assign tt-dados.cotacao = 1.

    find emitente use-index codigo 
         where  emitente.cod-emitente = tt-dados.cod-emit no-lock no-error.

    for each w-dupli break by w-dupli.dt-vencim:

        assign de-vl-original = de-vl-original
                              + w-dupli.vl-it-cr
                              + w-dupli.vl-fre-cr
                              + w-dupli.vl-div-cr              
                              + w-dupli.tot-camb
                            /*+ w-dupli.vl-difer-it
                              + w-dupli.vl-taxa 
                              + w-dupli.vl-taxa-div*/
                              + w-dupli.vl-frete
                              + w-dupli.vl-outros
                              + w-dupli.vl-dif-fr
                              + w-dupli.vl-dif-ou
               de-variacao = de-variacao  
                           + w-dupli.vl-difer-it
               de-vl-frete = de-vl-frete
                           + w-dupli.vl-frete   
               de-vl-outros = de-vl-outros
                            + w-dupli.vl-outros
               de-vl-taxa   = de-vl-taxa
                            + w-dupli.vl-taxa
                            + w-dupli.vl-taxa-div
               de-tot-pre   = de-tot-pre 
                            + w-dupli.tot-pre-mo 
               de-tot-cam   = de-tot-cam
                            + w-dupli.tot-camb
               de-vl-isr-tot = de-vl-isr-tot
                             + w-dupli.vl-isr    .    
       if last-of(w-dupli.dt-vencim) then do:
            i-aux = i-aux + 1.
            find lin-i-ap use-index documento
                 where lin-i-ap.ep-codigo     = tt-dados.ep-codigo 
                 and   lin-i-ap.cod-estabel   = tt-dados.cod-est  
                 and   lin-i-ap.cod-esp       = tt-dados.cod-esp    
                 and   lin-i-ap.serie         = tt-dados.serie     
                 and   lin-i-ap.nr-docto      = tt-dados.nr-docto 
                 and   lin-i-ap.parcela       = string(i-parcela + 1) 
                 and   lin-i-ap.cod-fornec    = tt-dados.cod-emit EXCLUSIVE-LOCK no-error.
            if not avail lin-i-ap then do:
                find last  lin-i-ap use-index codigo
                     where lin-i-ap.ep-codigo   = tt-dados.ep-codigo
                      and  lin-i-ap.referencia  = '' no-lock no-error.
                i-cont = if avail lin-i-ap then lin-i-ap.sequencia + 10 else 10.
                create lin-i-ap.
                assign lin-i-ap.cod-esp       = tt-dados.cod-esp
                       lin-i-ap.cod-estabel   = tt-dados.cod-est
                       lin-i-ap.cod-fornec    = tt-dados.cod-emit
                       lin-i-ap.ct-debito     = string(w-dupli.ct-debito)
                       lin-i-ap.sc-debito     = string(w-dupli.sc-debito)
                       lin-i-ap.tp-codigo     = tt-dados.tp-despesa
                       lin-i-ap.conta-debito  = string(w-dupli.ct-debito, "99999999")
                                               + string(w-dupli.sc-debito, "99999")
                       lin-i-ap.ct-debito     = string(w-dupli.ct-debito, "99999999")
                       lin-i-ap.sc-debito     = string(w-dupli.sc-debito, "99999")
                       lin-i-ap.dt-desconto   = if cond-pagto.prazos[1] = cond-pagto.nr-dias-ante
                                                   then w-dupli.dt-vencim
                                                else tt-dados.dt-emissao
                                                     + cond-pagto.nr-dias-ante
                       lin-i-ap.dt-emissao    = tt-dados.dt-emissao
                       lin-i-ap.dt-vencimen   = w-dupli.dt-vencim
                       lin-i-ap.dt-transacao  = tt-dados.dt-transacao
                       lin-i-ap.ep-codigo     = tt-dados.ep-codigo
                       lin-i-ap.nr-docto      = tt-dados.nr-docto
                       lin-i-ap.origem = 1
                       lin-i-ap.parcela = string(i-parcela + 1)
                       lin-i-ap.sit-receb = if tt-dados.item-ap = yes then 2
                                            else 1  /* pode ser atualizado */
                       lin-i-ap.tem-credito = yes /* Valor Provisorio */
                       lin-i-ap.referencia =
                                  /*if not param-estoq.gera-ap then '' else*/
                                       string(day(today),'99') +
                                     if month(today) < 10 then
                                        string(month(today),'9') +
                                        substring(string(time,'hh:mm'),1,2) +
                                        substring(string(time,'hh:mm'),4,2) +
                                        substring(string(time,'hh:mm:ss'),7,2) +
                                        string(i-aux,'9')
                                     else
                                        entry(month(today) - 9,'A,B,C') +
                                        substring(string(time,'hh:mm'),1,2) +
                                        substring(string(time,'hh:mm'),4,2) +
                                        substring(string(time,'hh:mm:ss'),7,2) +
                                           string(i-aux,'9')
                       lin-i-ap.sequencia = i-cont
                       lin-i-ap.serie = tt-dados.serie
                       i-parcela = i-parcela + 1.
                IF l-funcao-portador-ap = NO THEN
                    ASSIGN lin-i-ap.cod-portador  = emitente.portador.
                ELSE DO:
                    &if "{&mgadm_version}" >= "2.06b" &then
                        ASSIGN lin-i-ap.cod-portador  = emitente.portador-ap.
                    &else
                        ASSIGN lin-i-ap.cod-portador  = int(SUBSTR(emitente.char-1,31,5)).
                    &endif
                END.
             end.   

             if  tt-dados.moeda <> 0 then
                 assign lin-i-ap.mo-codigo     = tt-dados.moeda
                        lin-i-ap.vl-orig-me    = de-vl-original / tt-dados.cotacao
                        lin-i-ap.vl-original    = de-vl-original 
                        lin-i-ap.cotacao = tt-dados.cotacao.

             else assign lin-i-ap.vl-original = de-vl-original
                         lin-i-ap.vl-orig-me  = de-vl-original.

             assign lin-i-ap.frete-me      = de-vl-frete
                    lin-i-ap.frete         = de-vl-frete * tt-dados.cotacao
                    lin-i-ap.diversos-me   = de-vl-outros
                    lin-i-ap.diversos      = de-vl-outros * tt-dados.cotacao
                    lin-i-ap.vl-liquido    = lin-i-ap.vl-original
                                           - de-vl-frete
                                           - de-vl-outros
                    lin-i-ap.vl-liquido-me = lin-i-ap.vl-orig-me
                                           - de-vl-frete
                                           - de-vl-outros
                    lin-i-ap.vl-desconto = (cond-pagto.per-des-pgan
                                         * de-vl-original) / 100
                    lin-i-ap.vl-desconto-me  = (cond-pagto.per-des-pgan
                                         * lin-i-ap.vl-orig-me) / 100

                    lin-i-ap.vl-isr      = de-vl-isr-tot
                    lin-i-ap.vl-tax      = de-vl-taxa.

             if tt-dados.situacao = 1 then
                assign lin-i-ap.estado = 1.

             if lin-i-ap.dt-vencimen < lin-i-ap.dt-emissao then
                if lin-i-ap.estado = 1 then
                    lin-i-ap.estado = 5.
                else
                    lin-i-ap.estado = 4.

             create doc-i-ap.
             assign doc-i-ap.cod-esp      = lin-i-ap.cod-esp
                    doc-i-ap.cod-estabel  = lin-i-ap.cod-estabel
                    doc-i-ap.data-movto   = tt-dados.dt-transacao
                    doc-i-ap.ep-codigo    = tt-dados.ep-codigo
                    doc-i-ap.referencia   = lin-i-ap.referencia
                    doc-i-ap.total-movto  = if tt-dados.moeda <> 0 then
                                               lin-i-ap.vl-orig-me
                                            else 
                                               lin-i-ap.vl-original                                  
                    doc-i-ap.mo-codigo    = tt-dados.moeda
                    r-registro = rowid(doc-i-ap).


             find doc-i-ap where rowid(doc-i-ap) = r-registro
                  no-lock no-error.
             for each lin-i-ap where
                 lin-i-ap.ep-codigo = doc-i-ap.ep-codigo and
                 lin-i-ap.referencia = doc-i-ap.referencia no-lock:
                 /* Esta leitura serve para evitar problemas ocorridos na
                    versao 6 do progress multibanco */
             end.   
             {utp/ut-liter.i ce}
             assign i-empresa = tt-dados.ep-codigo
                    c-integra-ce-ap = trim(return-value)
                    v-row-doc-i-ap  = rowid(doc-i-ap).

             run app/ap0501.w.

             assign de-vl-original = 0
                    de-vl-frete    = 0
                    de-vl-outros   = 0
                    de-vl-isr-tot  = 0
                    de-vl-taxa     = 0 
                    de-tot-pre     = 0.
        end.
    end.
end.
assign de-variacao = de-variacao + tt-dados.tot-dif-ou + tt-dados.tot-dif-fr.
/*****************************************************************************
             Grava a diferenca entre preco-total e preco confirmado
             da fatura e distribui de acordo com a condicao de
             pagamento nas parcelas do mov-ap.
 *****************************************************************************/
find cond-pagto where cond-pagto.cod-cond-pag = tt-dados.cond-pagto no-lock no-error.
find first mov-ap 
     where mov-ap.ep-codigo   = tt-dados.ep-codigo
       and mov-ap.cod-fornec  = tt-dados.cod-emit
       and mov-ap.cod-estabel = tt-dados.cod-estabel
       and mov-ap.cod-esp     = tt-dados.cod-esp
       and mov-ap.serie       = tt-dados.serie
       and mov-ap.nr-docto    = tt-dados.nr-docto
       and mov-ap.parcela    <> "" no-lock no-error.
if avail mov-ap then do:
    for each mov-ap 
        where mov-ap.ep-codigo   = tt-dados.ep-codigo 
          and mov-ap.cod-fornec  = tt-dados.cod-emit
          and mov-ap.cod-estabel = tt-dados.cod-est
          and mov-ap.cod-esp     = tt-dados.cod-esp
          and mov-ap.serie       = tt-dados.serie
          and mov-ap.nr-docto    = tt-dados.nr-docto EXCLUSIVE-LOCK:
          assign i-parcela           = int(mov-ap.parcela)
                 mov-ap.vl-diferenca = de-variacao
                                     * cond-pagto.per-pg-dup[i-parcela] / 100
                 de-tot-dif          = de-tot-dif + mov-ap.vl-diferenca.
                 r-ultimo               = rowid(mov-ap).
          if  de-tot-cam <> 0 then do:
              assign mov-ap.vl-var-monet = de-tot-cam
                                         * cond-pagto.per-pg-dup[i-parcela] / 100
                     mov-ap.moeda        = tt-dados.moeda
                     mov-ap.cotacao-dia  = tt-dados.cotacao.
        end.
    end.
    assign de-tot-cam = 0.
    /*** Atribui na ultima parcela o residual da diferenca caso houver ***********/
    if de-tot-dif <> de-variacao then do:
        find mov-ap where rowid(mov-ap) = r-ultimo EXCLUSIVE-LOCK.
        assign mov-ap.vl-diferenca = mov-ap.vl-diferenca
                                   - de-tot-dif
                                   + de-variacao.
    end. 
end.   
else do:
   assign l-pendente = yes.
end.
/* Fim do Include - ap0994d.i */
