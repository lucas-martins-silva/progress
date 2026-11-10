/*******************************************************************************
**
**  Include.: AP0795.I
**  Objetivo: Complemento EmissÆo de Cartas de Pagamentos
**
*******************************************************************************/

for each tit-ap no-lock
    where tit-ap.ep-codigo   = tt-param.i-ep-codigo
     and tit-ap.cod-fornec  >= tt-param.fornec-ini
     and tit-ap.cod-fornec  <= tt-param.fornec-fim
     and tit-ap.cod-esp     >= tt-param.espec-ini
     and tit-ap.cod-esp     <= tt-param.espec-fim
     and tit-ap.nr-docto    >= tt-param.docto-ini
     and tit-ap.nr-docto    <= tt-param.docto-fim
     and tit-ap.tipo        <= 2
     and tit-ap.dt-vencimen {1} today
     and tit-ap.valor-saldo <> 0
    break by tit-ap.cod-fornec:

    if  line-counter = 58
    and not last-of(tit-ap.cod-fornec) then do:
        page.
    end.

    if  first-of(tit-ap.cod-fornec) or line-counter > 64 then do:
        run pi-acompanhar in h-acomp (input (c-des-objeto + string(tit-ap.cod-fornec))).

	page.
	disp empresa.razao-social
	     empresa.endereco
	     empresa.cidade
	     empresa.cep with frame f-empresa.
        down with frame f-empresa.

	find emitente
	    where emitente.cod-emitente = tit-ap.cod-fornec
	    and   emitente.identific <> 1 no-lock no-error.

        {utp/ut-liter.i Caro MAP L}
	put skip(1)
	    c-data       at 36 skip(02)
	    emitente.nome-emit skip
	    emitente.endereco  skip
	    emitente.cidade    skip
	    emitente.cep       space(1)
	    emitente.estado    skip(2)
	    (trim(return-value) + ": ") format "x(08)"
	    emitente.contato[1] skip(1).

        run pi-print-editor (mensagem.texto-mensag, 100).
        for each tt-editor:
            disp tt-editor.conteudo with frame f-editor.
            down with frame f-editor.
        end.
	put skip(1).
    end.

    assign c-tipo = {adinc/i01ad104.i 04 tit-ap.tipo}.
    disp tit-ap.cod-estabel
         tit-ap.cod-esp
	 tit-ap.serie
	 tit-ap.nr-docto
	 tit-ap.parcela
         c-tipo
	 tit-ap.dt-emissao
	 tit-ap.dt-vencimen
	 tit-ap.vl-original
	 tit-ap.valor-saldo with frame f-titulo.
    down with frame f-titulo.

    find first his-d-ap
         where his-d-ap.ep-codigo   = tit-ap.ep-codigo
           and his-d-ap.cod-estabel = tit-ap.cod-estab
           and his-d-ap.cod-esp     = tit-ap.cod-esp
           and his-d-ap.serie       = tit-ap.serie
           and his-d-ap.nr-docto    = tit-ap.nr-docto
           and his-d-ap.parcela     = tit-ap.parcela
           and his-d-ap.dt-his-doc  = tit-ap.dt-emissao
           no-lock no-error.
    if  not avail his-d-ap then do:
        {utp/ut-liter.i Enviada_mensagem_n£mero MAP R}
        create his-d-ap.
        assign his-d-ap.ep-codigo   = tit-ap.ep-codigo
	       his-d-ap.cod-estabel = tit-ap.cod-estab
	       his-d-ap.cod-esp     = tit-ap.cod-esp
	       his-d-ap.serie       = tit-ap.serie
	       his-d-ap.nr-docto    = tit-ap.nr-docto
	       his-d-ap.parcela     = tit-ap.parcela
	       his-d-ap.dt-his-doc  = tit-ap.dt-emissao
	       his-d-ap.historico   = return-value + string(tt-param.mensagem).
    end.

    if  last-of(tit-ap.cod-fornec) then do:
        put skip(3).
        run pi-print-editor (tt-param.observacao, 100).
        for each tt-editor:
            disp tt-editor.conteudo with frame f-editor.
            down with frame f-editor.
        end.
    end.
end.

/* AP0795.I */
