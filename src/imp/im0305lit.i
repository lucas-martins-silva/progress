 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "num-pedido":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "num-pedido":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-estabel":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-estabel":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "num-ped-benef":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "num-ped-benef":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "data-pedido":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "data-pedido":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-emitente":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-emitente":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "end-entrega":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "end-entrega":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "end-cobranca":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "end-cobranca":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-cond-pag":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-cond-pag":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-emit-terc":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-emit-terc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "responsavel":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "responsavel":U.

 {utp/ut-liter.i "Situa‡Æo"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-situacao":U
        tt-traduz-tt.banco      = ""
        tt-traduz-tt.tabela     = ""
        tt-traduz-tt.campo      = ""
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-mens-ped":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-mensagem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-estabel-gestor":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "pedido-compr":U
        tt-traduz-tt.campo      = "cod-estab-gestor":U.

 {utp/ut-liter.i "Natureza"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-natureza":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Frete"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-frete":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Emitente_Entrega"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-entr":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-entr":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Estab_Entrega"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-estab-entr":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-suframa-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-suframa":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-emitente":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "nome-emit":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-estab-entr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Estab_Cobran‡a"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-estab-cobr":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-suframa-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-suframa":U.

 {utp/ut-liter.i "Emitente_Estab_Cobran‡a"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-estab-cobr":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ramal-modem-emit-estab-cobr":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Estab_Gestor"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-estab-gest":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-suframa-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-suframa":U.

 {utp/ut-liter.i "Emitente_Estab_Gestor"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-estab-gest":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-estab-gest":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Condicao_de_Pagamento"}
 CREATE tt-traduz-tt.
 ASSIGN tt-traduz-tt.campo-tt   = "desc-cond-pagto":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "cond-pagto":U
        tt-traduz-tt.campo      = "descricao":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-mensagem-ped":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "mensagem":U
        tt-traduz-tt.campo      = "descricao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "texto-mensag-ped":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "mensagem":U
        tt-traduz-tt.campo      = "texto-mensag":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nr-proc-imp":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "nr-proc-imp":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-itiner":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-itiner":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "dt-emissao":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "dt-emissao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "dt-implantacao":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "dt-implantacao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "dt-autorizacao":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "dt-autorizacao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-despachante":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-despachante":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-exportador":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-exportador":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-consignatario":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-consignatario":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-transportador":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-transportador":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "carta-credito":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "carta-credito":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "narrativa":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "narrativa":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-banco":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-banco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nr-rof":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "nr-rof":U.
 {utp/ut-liter.i "Transp"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-via-transp":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estab-fisc":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "estab-fisc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "contrato-cambio":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "contrato-cambio":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-idioma":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-idioma":U.
 {utp/ut-liter.i "Situa‡Æo"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "situacao-proc-imp":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-agente":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-agente":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-mens-proc-imp":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cod-mensagem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "texto-mens-proc-imp":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "texto-mensag":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "destino-documentacao":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "destino-documentacao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cdn-corretor-cambio-import":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cdn-corretor-cambio-import":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cdn-despa-exter-import":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cdn-despa-exter-import":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cdn-segurad-import":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cdn-segurad-import":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cdn-corretor-import":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "processo-imp":U
        tt-traduz-tt.campo      = "cdn-corretor-import":U.

 {utp/ut-liter.i "Estab_Importador"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-import":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-suframa-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-suframa":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-emitente":U.

 {utp/ut-liter.i "Importador"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-import":U
        tt-traduz-tt.desc-label = RETURN-VALUE.
 
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-import":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-import":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Exportador"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-export":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-export":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-export":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-incoterm":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "inco-cx":U
        tt-traduz-tt.campo      = "descricao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-incoterm":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "inco-cx":U
        tt-traduz-tt.campo      = "cod-incoterm":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-itiner":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "itinerario":U
        tt-traduz-tt.campo      = "descricao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "distancia":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "itinerario":U
        tt-traduz-tt.campo      = "distancia":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nr-dias":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "itinerario":U
        tt-traduz-tt.campo      = "nr-dias":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-mensagem-proc":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "mensagem":U
        tt-traduz-tt.campo      = "descricao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "texto-mensag-proc":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "mensagem":U
        tt-traduz-tt.campo      = "texto-mensag":U.

 {utp/ut-liter.i "Peso_L¡quido_Total"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "peso-liquido-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Peso_Bruto_Total"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "peso-bruto-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Pre‡o_Total_Fornecedor_L¡quido"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "preco-fornec-liq-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Pre‡o_Total_Interno_L¡quido"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "preco-interno-liq-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Pre‡o_Total_Fornecedor_Bruto"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "preco-fornec-bru-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Pre‡o_Total_Interno_Bruto"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "preco-interno-bru-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Ocupa‡Æo"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ocupacao-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Tot_Despesa_Pedido"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "tot-desp-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Tot_Ped_Pre‡o_Forn_Liq_c/_Desp"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "tot-desp-fornec-liq-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Tot_Ped_Pre‡o_Liq_c/_Desp"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "tot-desp-interno-liq-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Tot_Ped_Pre‡o_Forn_Bruto_c/_Desp"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "tot-desp-fornec-bru-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Tot_Ped_Pre‡o_Interno_Bruto_c/_Desp"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "tot-desp-interno-bru-total-ped":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 {utp/ut-liter.i "Despachante"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-despach":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-estadual-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-municipal-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-despach":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-despach":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 {utp/ut-liter.i "Agente_Cargas"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-agente":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-agente":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-agente":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Corretor_Cƒmbio"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-corretor-cam":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-corretor-cam":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-corretor-cam":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Despachante_Externo"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-despach-ext":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-despach-ext":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-despach-ext":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Seguradora"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-segurad":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-segurad":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-segurad":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Corretor_Import"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-corretor-imp":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-corretor-imp":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-corretor-imp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-banco":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "banco":U
        tt-traduz-tt.campo      = "nome-banco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ag-banco":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "agencia":U
        tt-traduz-tt.campo      = "agencia":U.

 {utp/ut-liter.i "Agencia"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-agencia":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Consignat rio"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-consig":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-estadual-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-municipal-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-consig":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-consig":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 {utp/ut-liter.i "Estab_Fiscal"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-estab-fis":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-suframa-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-suframa":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "estabelec":U
        tt-traduz-tt.campo      = "cod-emitente":U.

 {utp/ut-liter.i "Emitente_Estab_Fisc"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-emit-estab-fis":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-estadual-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "Ins-municipal-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "caixa-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cod-aba-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "emitente-cex":U
        tt-traduz-tt.campo      = "cod-aba":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone1-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone2-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefone[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal1-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal2-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fax-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-fac-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-fac-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-fac":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-emit-estab-fis":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "emitente":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-assinat1":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "nome-ass[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-assinat2":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "nome-ass[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-assinat3":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "nome-ass[3]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cargo-assinat1":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "cargo-ass[1]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cargo-assinat2":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "cargo-ass[2]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cargo-assinat3":U
        tt-traduz-tt.banco      = "mgind":U
        tt-traduz-tt.tabela     = "param-compra":U
        tt-traduz-tt.campo      = "cargo-ass[3]":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pto-embarque":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "itinerario":U
        tt-traduz-tt.campo      = "pto-embarque":U.

 {utp/ut-liter.i "Embarque"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-pto-embarque":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pto-desembarque":U
        tt-traduz-tt.banco      = "mgcex":U
        tt-traduz-tt.tabela     = "itinerario":U
        tt-traduz-tt.campo      = "pto-desembarque":U.

 {utp/ut-liter.i "Nacionaliza‡Æo"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-pto-desembarque":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Data_Prevista_Embarque"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "data-prev-embarque":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "desc-moeda-inf":U
        tt-traduz-tt.banco      = "mguni":U
        tt-traduz-tt.tabela     = "moeda":U
        tt-traduz-tt.campo      = "descricao":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "sigla-moeda-inf":U
        tt-traduz-tt.banco      = "mguni":U
        tt-traduz-tt.tabela     = "moeda":U
        tt-traduz-tt.campo      = "sigla":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "mo-codigo-inf":U
        tt-traduz-tt.banco      = "mguni":U
        tt-traduz-tt.tabela     = "moeda":U
        tt-traduz-tt.campo      = "mo-codigo":U.

 {utp/ut-liter.i "Transportadora"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-transp":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "nome-abrev-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "nome-abrev":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "endereco-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "endereco":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "bairro-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "bairro":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cidade-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "cidade":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "pais-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "pais":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cep-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "cep":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "cgc-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "cgc":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "estado-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "estado":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-estadual-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "ins-estadual":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "caixa-postal-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "cx-postal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "contato-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "contato":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefone-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "telefone":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "ramal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telefax-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "telefax":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telex-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "telex":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ins-municipal-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "ins-municipal":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "zip-code-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "zip-code":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "e-mail-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "e-mail":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "telef-modem-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "telef-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "home-page-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "home-page":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "ramal-modem-transp":U
        tt-traduz-tt.banco      = "mgadm":U
        tt-traduz-tt.tabela     = "transporte":U
        tt-traduz-tt.campo      = "ramal-modem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "numero-ordem":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "ordem-compra":U
        tt-traduz-tt.campo      = "numero-ordem":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "r-rowid-ordem-compra":U
        tt-traduz-tt.banco      = "":U
        tt-traduz-tt.tabela     = "":U
        tt-traduz-tt.campo      = "":U
        tt-traduz-tt.desc-label = "":U.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "it-codigo":U
        tt-traduz-tt.banco      = "movind":U
        tt-traduz-tt.tabela     = "ordem-compra":U
        tt-traduz-tt.campo      = "it-codigo":U.

 {utp/ut-liter.i "Exportador"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "exportador":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 {utp/ut-liter.i "Importador"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "importador":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "titulo-relat":U
        tt-traduz-tt.desc-label = "PURCHASE ORDER":U.

 {utp/ut-liter.i "Agente_Cargas"}
 CREATE tt-traduz-tt. 
 ASSIGN tt-traduz-tt.campo-tt   = "agente-cargas":U
        tt-traduz-tt.desc-label = RETURN-VALUE.

