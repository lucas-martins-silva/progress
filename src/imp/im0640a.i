PROCEDURE pi-cria-formato:
    DEFINE VARIABLE c-formato-cod-gr-cli AS CHARACTER   NO-UNDO.

    RUN utp/ut-field.p (INPUT "mgadm":U,
                        INPUT "emitente":U,
                        INPUT "cod-gr-cli":U,
                        INPUT 4).
    ASSIGN c-formato-cod-gr-cli = RETURN-VALUE.

    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "cep"
           tt-formato.formato    = "99999,999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "ep-codigo"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "cod-isencao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "custo-contab"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "tax-cidade"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "tax-condado"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "tax-estado"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "cod-sit-aval"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "val-unit-up"
           tt-formato.formato    = ">>>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "qtd-up-prod"
           tt-formato.formato    = ">>>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "val-desp-total"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "integr-ncr-app"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "integr-ncr-crp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "num-livre-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "num-livre-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "val-livre-1"
           tt-formato.formato    = "->>>>>>>>>>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "val-livre-2"
           tt-formato.formato    = "->>>>>>>>>>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "cd-tipo"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-estabelec-aux"
           tt-formato.campo-tt   = "idi-tributac-cofins"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cod-despachante"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cod-transportador"
           tt-formato.formato    = ">>>,>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cod-via-transp"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cod-banco"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "situacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "val-perc-ir"
           tt-formato.formato    = ">>9,99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "val-perc-juros"
           tt-formato.formato    = ">>9,99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cdn-corretor-cambio-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cdn-despa-exter-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cdn-segurad-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-embarque"
           tt-formato.campo-tt   = "cdn-corretor-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-itiner"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-despachante"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-fabricante"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-exportador"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-consignatario"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-transportador"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-banco"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "regime-import"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "via-transp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "num-pedido"
           tt-formato.formato    = ">>>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "situacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-agente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cod-mensagem"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cdn-corretor-cambio-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cdn-despa-exter-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cdn-segurad-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-processo-aux"
           tt-formato.campo-tt   = "cdn-corretor-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "num-pedido"
           tt-formato.formato    = ">>>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "num-ped-benef"
           tt-formato.formato    = ">>>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "natureza"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "situacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "frete"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-transp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "via-transp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-cond-pag"
           tt-formato.formato    = ">>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-mensagem"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nr-prox-ped"
           tt-formato.formato    = ">>>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nr-processo"
           tt-formato.formato    = "999,999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "l-tipo-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "l-classificacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-importador"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-situacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-moeda"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-cod-forma"
           tt-formato.formato    = "999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-cod-via"
           tt-formato.formato    = "9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-cod-porto"
           tt-formato.formato    = "999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "de-vl-fob"
           tt-formato.formato    = ">>>>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "i-exportador"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "de-vl-frete-i"
           tt-formato.formato    = ">>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "ind-orig-entrada"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "ind-via-envio"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nro-proc-entrada"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nro-proc-saida"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nro-proc-alteracao"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-maq-origem"
           tt-formato.formato    = "999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "num-processo-mp"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "num-id-documento"
           tt-formato.formato    = "999999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nr-contrato"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "cod-emit-terc"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "nr-ped-venda"
           tt-formato.formato    = ">>>,>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-pedido"
           tt-formato.campo-tt   = "local-entrega"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "cod-transp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "natureza"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "via-transp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "cdn-parcei-EDI"
           tt-formato.formato    = ">>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-transporte-aux"
           tt-formato.campo-tt   = "ind-situacao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "identific"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "natureza"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-cond-pag"
           tt-formato.formato    = ">>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "taxa-financ"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-transp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-gr-forn"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "compr-period"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "end-cobranca"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-rep"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "bonificacao"
           tt-formato.formato    = ">>9.999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "istr"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-gr-cli"
           tt-formato.formato    = c-formato-cod-gr-cli.
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "lim-credito"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "perc-fat-ped"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "portador"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "modalidade"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-cre-cli"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "per-minfat"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "emissao-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-titulo"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-dias"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "per-max-canc"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tr-ar-valor"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "port-prefer"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "mod-prefer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "bx-acatada"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-copias-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "gera-difer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-aval"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ins-banc"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ven-feriado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ven-domingo"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ven-sabado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tip-cob-desp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-banco"
           tt-formato.formato    = "999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "prox-ad"
           tt-formato.formato    = ">>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "lim-adicional"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-tip-ent"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-peratr"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-mesina"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-mensagem"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-dias-taxa"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tp-desp-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tp-rec-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tp-inspecao"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tp-qt-prg"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-div-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-1"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-2"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "esp-pd-venda"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-moeda-tit"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "tp-pagto"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "vl-min-ad"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "hora-ini"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "hora-fim"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "resumo-mp"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-aval-embarque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-abrange-aval"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-tax"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-isencao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "dias-comp"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "estoque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "flag-pag"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "moeda-libcre"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-dias-atraso"
           tt-formato.formato    = "9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "valor-minimo"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-parceiro-edi"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-canal-venda"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-sit-emitente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "ind-emit-retencao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-tab-progr"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-classif-fornec"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-classif-cliente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "nr-cheque-devol"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "periodo-devol"
           tt-formato.formato    = ">,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "vl-max-devol"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "val-quota-media"
           tt-formato.formato    = ">>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-repres-imp"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "rend-tribut"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "percent-verba"
           tt-formato.formato    = ">>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "idi-tributac-cofins"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "idi-tributac-pis"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "portador-ap"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "modalidade-ap"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-itiner-exp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-repres"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-itiner-imp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cod-pto-contr"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cdn-despa-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cdn-despa-exter-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cdn-segurad-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-exportador-aux"
           tt-formato.campo-tt   = "cdn-corretor-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "identific"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "natureza"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-cond-pag"
           tt-formato.formato    = ">>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "taxa-financ"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-transp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-gr-forn"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "compr-period"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "end-cobranca"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-rep"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "bonificacao"
           tt-formato.formato    = ">>9.999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "istr"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-gr-cli"
           tt-formato.formato    = c-formato-cod-gr-cli.
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "lim-credito"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "perc-fat-ped"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "portador"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "modalidade"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-cre-cli"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "per-minfat"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "emissao-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-titulo"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-dias"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "per-max-canc"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tr-ar-valor"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "port-prefer"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "mod-prefer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "bx-acatada"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-copias-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "gera-difer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-aval"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ins-banc"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ven-feriado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ven-domingo"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ven-sabado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tip-cob-desp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-banco"
           tt-formato.formato    = "999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "prox-ad"
           tt-formato.formato    = ">>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "lim-adicional"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-tip-ent"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-peratr"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-mesina"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-mensagem"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-dias-taxa"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tp-desp-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tp-rec-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tp-inspecao"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tp-qt-prg"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-div-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-1"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-2"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "esp-pd-venda"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-moeda-tit"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "tp-pagto"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "vl-min-ad"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "hora-ini"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "hora-fim"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "resumo-mp"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-aval-embarque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-abrange-aval"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-tax"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-isencao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "dias-comp"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "estoque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "flag-pag"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "moeda-libcre"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-dias-atraso"
           tt-formato.formato    = "9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "valor-minimo"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-parceiro-edi"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-canal-venda"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-sit-emitente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "ind-emit-retencao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-tab-progr"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-classif-fornec"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-classif-cliente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "nr-cheque-devol"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "periodo-devol"
           tt-formato.formato    = ">,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "vl-max-devol"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "val-quota-media"
           tt-formato.formato    = ">>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-repres-imp"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "rend-tribut"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "percent-verba"
           tt-formato.formato    = ">>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "idi-tributac-cofins"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "idi-tributac-pis"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "portador-ap"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "modalidade-ap"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-itiner-exp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-repres"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-itiner-imp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cod-pto-contr"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cdn-despa-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cdn-despa-exter-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cdn-segurad-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-consignatario-aux"
           tt-formato.campo-tt   = "cdn-corretor-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "identific"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "natureza"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-cond-pag"
           tt-formato.formato    = ">>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "taxa-financ"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-transp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-gr-forn"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "compr-period"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "end-cobranca"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-rep"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "bonificacao"
           tt-formato.formato    = ">>9.999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "istr"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-gr-cli"
           tt-formato.formato    = c-formato-cod-gr-cli.
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "lim-credito"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "perc-fat-ped"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "portador"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "modalidade"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-cre-cli"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "per-minfat"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "emissao-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-titulo"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-dias"
           tt-formato.formato    = ">>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "per-max-canc"
           tt-formato.formato    = ">9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tr-ar-valor"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "port-prefer"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "mod-prefer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "bx-acatada"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-copias-ped"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "gera-difer"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-aval"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ins-banc"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ven-feriado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ven-domingo"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ven-sabado"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tip-cob-desp"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-banco"
           tt-formato.formato    = "999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "prox-ad"
           tt-formato.formato    = ">>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "lim-adicional"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-tip-ent"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-peratr"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-mesina"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-mensagem"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-dias-taxa"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tp-desp-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tp-rec-padrao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tp-inspecao"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tp-qt-prg"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-div-atraso"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-1"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-dif-atrs-2"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "esp-pd-venda"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-moeda-tit"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "tp-pagto"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "vl-min-ad"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "hora-ini"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "hora-fim"
           tt-formato.formato    = "99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "resumo-mp"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-aval-embarque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-abrange-aval"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-tax"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-isencao"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "dias-comp"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "estoque"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "flag-pag"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "moeda-libcre"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-dias-atraso"
           tt-formato.formato    = "9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "valor-minimo"
           tt-formato.formato    = ">>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-parceiro-edi"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "dec-1"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "dec-2"
           tt-formato.formato    = "->>>>>>>>>>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "int-1"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "int-2"
           tt-formato.formato    = "->>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-canal-venda"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-sit-emitente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "ind-emit-retencao"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-tab-progr"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-classif-fornec"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-classif-cliente"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "nr-cheque-devol"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "periodo-devol"
           tt-formato.formato    = ">,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "vl-max-devol"
           tt-formato.formato    = ">>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "val-quota-media"
           tt-formato.formato    = ">>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-repres-imp"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "rend-tribut"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "percent-verba"
           tt-formato.formato    = ">>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "idi-tributac-cofins"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "idi-tributac-pis"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "portador-ap"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "modalidade-ap"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-itiner-exp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-repres"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-itiner-imp"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cod-pto-contr"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cdn-despa-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cdn-despa-exter-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cdn-segurad-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-agente-carga-aux"
           tt-formato.campo-tt   = "cdn-corretor-import"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-docto"
           tt-formato.campo-tt   = "qti-docto-origin"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-docto"
           tt-formato.campo-tt   = "qti-docto-cop-bco"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-docto"
           tt-formato.campo-tt   = "qti-docto-cop-imptdor"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-docto"
           tt-formato.campo-tt   = "cod-itens-docto"
           tt-formato.formato    = "X(2000)".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-docto"
           tt-formato.campo-tt   = "tr-cod-itens-docto"
           tt-formato.formato    = "X(2000)".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "numero-ordem"
           tt-formato.formato    = "zzzzz9,99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "parcela"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "quantidade"
           tt-formato.formato    = ">>>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "qt-do-forn"
           tt-formato.formato    = ">>>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "peso-liquido-uni"
           tt-formato.formato    = ">>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "peso-liquido-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "peso-bruto-uni"
           tt-formato.formato    = ">>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "peso-bruto-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-cub-uni"
           tt-formato.formato    = ">>>>>,>>>,>>9.999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-cub-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "preco-orig"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "preco-unit"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "pre-unit-for"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "preco-fornec"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "mo-codigo"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "aliquota-ipi"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "aliquota-icm"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "aliquota-iss"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "valor-taxa"
           tt-formato.formato    = ">>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "perc-descto"
           tt-formato.formato    = ">9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "prazo-entreg"
           tt-formato.formato    = ">,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "valor-descto"
           tt-formato.formato    = ">>>,>>>,>>9.9999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "nr-dias-taxa"
           tt-formato.formato    = ">>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "cod-emitente"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-liq-uni"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-bruto-uni"
           tt-formato.formato    = ">>>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-liq-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "vl-bruto-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "cod-pto-contro-b"
           tt-formato.formato    = ">>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "aliquota-ii"
           tt-formato.formato    = ">>9.99".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "regime-import"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "cdn-pais-orig"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "cod-fabric"
           tt-formato.formato    = ">>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "altura"
           tt-formato.formato    = ">>>,>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "comprim"
           tt-formato.formato    = ">>>,>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "largura"
           tt-formato.formato    = ">>>,>>9.99999999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "ge-codigo"
           tt-formato.formato    = ">9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "fator-conver"
           tt-formato.formato    = ">>>>>>>>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "num-casa-dec"
           tt-formato.formato    = "9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-it-inst-emb"
           tt-formato.campo-tt   = "peso-liquido"
           tt-formato.formato    = ">>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "num-pedido"
           tt-formato.formato    = ">>>>>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "peso-liquido-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "peso-bruto-tot"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "valor-total-merc"
           tt-formato.formato    = ">>>>,>>>,>>>,>>9.99999".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "pto-despacho"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "pto-embarque"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "pto-nacionaliz"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "pto-eadi"
           tt-formato.formato    = ">>,>>9".
    
    CREATE tt-formato. 
    ASSIGN tt-formato.nome-tt    = "tt-inst-emb"
           tt-formato.campo-tt   = "pto-chegada"
           tt-formato.formato    = ">>,>>9".
END PROCEDURE.
