/*************************************************************************
***
***  acp/ac9004.i - Atualiza temp-table tt-cotas.
***
**************************************************************************/
IF {&param-cota} = no then do:
    find first para-ped no-lock no-error.
    if substring(para-ped.char-2,1,3) = "yes" then
       find par-cota no-lock 
            where par-cota.cod-estabel = para-ped.estab-padrao no-error.
    else        
       FIND PAR-COTA NO-LOCK 
            where par-cota.cod-estabel = b-cotas.cod-estabel NO-ERROR.
   
    IF AVAIL par-cota then do:
       find tt-cotas 
            where tt-cotas.cod-estabel     = b-cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = b-cotas.cod-canal-venda
            and   tt-cotas.cod-gr-cli      = b-cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = b-cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = b-cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = b-cotas.nome-mic-reg
            and   tt-cotas.cod-rep         = b-cotas.cod-rep
            and   tt-cotas.cd-produto      = b-cotas.cd-produto
            and   tt-cotas.dt-inicial      = b-cotas.dt-inicial no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = b-cotas.cod-estabel
                 tt-cotas.cod-canal-venda = b-cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = b-cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = b-cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = b-cotas.nome-ab-reg
                 tt-cotas.nome-mic-reg    = b-cotas.nome-mic-reg
                 tt-cotas.cod-rep         = b-cotas.cod-rep
                 tt-cotas.cd-produto      = b-cotas.cd-produto
                 tt-cotas.dt-inicial      = b-cotas.dt-inicial
                 tt-cotas.cota-liberada   = b-cotas.cota-liberada
                 tt-cotas.tp-contr        = par-cota.tipo-controle.
       end.
       
       if par-cota.tipo-controle = 2 then do: /*valor*/
          assign tt-cotas.prevista     = b-cotas.vl-previsto
                 tt-cotas.pedida       = b-cotas.vl-pedido
                 tt-cotas.faturada     = b-cotas.vl-faturado
                 tt-cotas.ped-canc     = b-cotas.vl-ped-canc
                 tt-cotas.fat-canc     = b-cotas.vl-fat-canc
                 tt-cotas.ped-susp     = b-cotas.vl-ped-susp
                 tt-cotas.original     = b-cotas.vl-original
                 tt-cotas.solicitado   = b-cotas.vl-solicitado.
          /*****  Uso de pre-processador ******/
          &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
                 assign tt-cotas.reprovada    = b-cotas.vl-ped-reprov.
          &endif
       end. 
       ELSE DO:  /*quantidade ou pontos*/
          assign tt-cotas.prevista     = b-cotas.qt-prevista
                 tt-cotas.pedida       = b-cotas.qt-pedida
                 tt-cotas.faturada     = b-cotas.qt-faturada
                 tt-cotas.ped-canc     = b-cotas.qt-ped-canc
                 tt-cotas.fat-canc     = b-cotas.qt-fat-canc
                 tt-cotas.ped-susp     = b-cotas.qt-ped-susp
                 tt-cotas.original     = b-cotas.qt-original
                 tt-cotas.solicitado   = b-cotas.qt-solicitado.
           /*****  Uso de pre-processador ******/
           &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
               assign tt-cotas.reprovada    = b-cotas.qt-ped-reprov.
           &endif
       end. 
       


    end.    
end.

IF {&param-cota} = yes then do:
    if tt-cotas.tp-contr = 2 then DO:  /*valor*/
    
       assign b-cotas.vl-previsto = tt-cotas.prevista
              b-cotas.vl-pedido   = tt-cotas.pedida
              b-cotas.vl-faturado = tt-cotas.faturada
              b-cotas.vl-ped-canc = tt-cotas.ped-canc
              b-cotas.vl-fat-canc = tt-cotas.fat-canc
              b-cotas.vl-ped-susp = tt-cotas.ped-susp
              b-cotas.vl-original = tt-cotas.original
              b-cotas.vl-solicitado = tt-cotas.solicitado.
              /*****  Uso de pre-processador ******/
              &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
                  assign b-cotas.vl-ped-reprov = tt-cotas.reprovada.
              &endif
    end.  
    ELSE DO: /*quantidade ou pontos*/
       assign b-cotas.qt-prevista = tt-cotas.prevista
              b-cotas.qt-pedida   = tt-cotas.pedida
              b-cotas.qt-faturada = tt-cotas.faturada
              b-cotas.qt-ped-canc = tt-cotas.ped-canc
              b-cotas.qt-fat-canc = tt-cotas.fat-canc
              b-cotas.qt-ped-susp = tt-cotas.ped-susp
              b-cotas.qt-original = tt-cotas.original
              b-cotas.qt-solicitado = tt-cotas.solicitado.
              /*****  Uso de pre-processador ******/
              &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
                  assign b-cotas.qt-ped-reprov = tt-cotas.reprovada.
              &endif
    END.
    delete tt-cotas. 
end.

/* Fim de Include */
