/*************************************************************************
***
***  acp/ac9001.i - Atualiza temp-table tt-cotas.
***
**************************************************************************/
if {&param-cota} = no then do:
    IF NOT AVAIL para-ped THEN
       FIND FIRST para-ped NO-LOCK NO-ERROR.
    IF SUBSTRING(para-ped.char-2,1,3)  = "yes" THEN DO:
       IF NOT AVAIL par-cota THEN
          FIND FIRST par-cota NO-LOCK 
               WHERE par-cota.cod-estabel = para-ped.estab-padrao NO-ERROR.
    END.
    ELSE DO: 
        IF NOT AVAIL par-cota THEN
           FIND FIRST par-cota NO-LOCK 
                WHERE par-cota.cod-estabel = cotas.cod-estabel NO-ERROR.

    END.
    if avail par-cota then do:
       find tt-cotas 
            where tt-cotas.cod-estabel     = par-cota.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
            and   tt-cotas.cod-rep         = cotas.cod-rep
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial      = cotas.dt-inicial no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = par-cota.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                 tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
                 tt-cotas.cod-rep         = cotas.cod-rep
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.cota-liberada   = cotas.cota-liberada
                 tt-cotas.tp-contr        = par-cota.tipo-controle.
       end.
       if par-cota.tipo-controle = 2 then 
          assign tt-cotas.prevista     = cotas.vl-previsto
                 tt-cotas.pedida       = cotas.vl-pedido
                 tt-cotas.faturada     = cotas.vl-faturado
                 tt-cotas.ped-canc     = cotas.vl-ped-canc
                 tt-cotas.fat-canc     = cotas.vl-fat-canc
                 tt-cotas.ped-susp     = cotas.vl-ped-susp
                 tt-cotas.original     = cotas.vl-original
                 tt-cotas.solicitado   = cotas.vl-solicitado
          /*****  Uso de pre-processador ******/
          &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
                 tt-cotas.reprovada    = cotas.vl-ped-reprov
          &endif            
                 .
       else 
          assign tt-cotas.prevista     = cotas.qt-prevista
                 tt-cotas.pedida       = cotas.qt-pedida
                 tt-cotas.faturada     = cotas.qt-faturada
                 tt-cotas.ped-canc     = cotas.qt-ped-canc
                 tt-cotas.fat-canc     = cotas.qt-fat-canc
                 tt-cotas.ped-susp     = cotas.qt-ped-susp
                 tt-cotas.original     = cotas.qt-original
                 tt-cotas.solicitado   = cotas.qt-solicitado
          /*****  Uso de pre-processador ******/
          &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
                 tt-cotas.reprovada    = cotas.qt-ped-reprov
          &endif            
                 .
    end.    
end.

IF {&param-cota} = yes then do:
    if tt-cotas.tp-contr = 2 then 
       assign cotas.vl-previsto = tt-cotas.prevista
              cotas.vl-pedido   = tt-cotas.pedida
              cotas.vl-faturado = tt-cotas.faturada
              cotas.vl-ped-canc = tt-cotas.ped-canc
              cotas.vl-fat-canc = tt-cotas.fat-canc
              cotas.vl-ped-susp = tt-cotas.ped-susp
              cotas.vl-original = tt-cotas.original
              cotas.vl-solicitado = tt-cotas.solicitado
       /*****  Uso de pre-processador ******/
       &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
              cotas.vl-ped-reprov = tt-cotas.reprovada
       &endif            
              .
    else
       assign cotas.qt-prevista = tt-cotas.prevista
              cotas.qt-pedida   = tt-cotas.pedida
              cotas.qt-faturada = tt-cotas.faturada
              cotas.qt-ped-canc = tt-cotas.ped-canc
              cotas.qt-fat-canc = tt-cotas.fat-canc
              cotas.qt-ped-susp = tt-cotas.ped-susp
              cotas.qt-original = tt-cotas.original
              cotas.qt-solicitado = tt-cotas.solicitado
       /*****  Uso de pre-processador ******/
       &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
              cotas.qt-ped-reprov = tt-cotas.reprovada
       &endif           
              . 

    delete tt-cotas. 

end.

/* Fim de Include */
