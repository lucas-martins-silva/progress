  run pi-consistir-bordero-ap IN h-ap5510ga (input rowid(bordero-ap),
                                             input table tt-param,
                                             input-output table tt-retorno-bordero).
                                              
  find first tt-retorno-bordero
       where tt-retorno-bordero.ep-codigo    = i-ep-codigo-usuario  
       and   tt-retorno-bordero.cod-estabel  = bordero-ap.cod-estabel
       and   tt-retorno-bordero.cod-fornec   = bordero-ap.cod-fornec 
       and   tt-retorno-bordero.cod-esp      = bordero-ap.cod-esp    
       and   tt-retorno-bordero.serie        = bordero-ap.serie      
       and   tt-retorno-bordero.nr-docto     = bordero-ap.nr-docto   
       and   tt-retorno-bordero.parcela      = bordero-ap.parcela
       no-error.
       
  if  avail tt-retorno-bordero then
      {1}.

  find first emitente no-lock
       where emitente.cod-emitente = bordero-ap.cod-fornec no-error.
       
  if  not avail emitente then
      {1}.

  create tt-digita.
  assign tt-digita.portador    = tt-param.portador
         tt-digita.bordero     = tt-param.bordero 
         tt-digita.estabelec   = bordero-ap.cod-estabel
         tt-digita.cod-esp     = bordero-ap.cod-esp
         tt-digita.serie       = bordero-ap.serie
         tt-digita.nr-docto    = bordero-ap.nr-docto
         tt-digita.parcela     = bordero-ap.parcela
         tt-digita.fornec      = bordero-ap.cod-fornec
         tt-digita.vl-saldo    = bordero-ap.vl-docto
         tt-digita.dt-vencto   = bordero-ap.dt-vencto
         tt-digita.vl-desconto = bordero-ap.vl-desconto
         tt-digita.rw-digita   = rowid(bordero-ap)
         tt-digita.tabela      = "bordero-ap"
         tt-digita.nome-abrev  = emitente.nome-abrev
         tt-digita.autorizacao = 0.

  IF  AVAIL param-ap AND param-ap.considera-niveis = YES THEN DO:

      RUN pi-verificar-autorizacao-pagamento IN h-ap5510m (INPUT tt-digita.estabelec,
                                                           INPUT tt-digita.fornec,
                                                           INPUT tt-digita.cod-esp,
                                                           INPUT tt-digita.serie,
                                                           INPUT tt-digita.nr-docto,
                                                           INPUT tt-digita.parcela,
                                                           INPUT tt-digita.tp-pagto,
                                                           INPUT tt-digita.vl-saldo,
                                                           INPUT tt-digita.tipo,
                                                           OUTPUT tt-digita.autorizacao).

  END.

