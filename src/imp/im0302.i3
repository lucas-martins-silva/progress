/*******************************************************************************
**
** im0302.i3 - Cria‡Æo temp-table tt-ficha (ficha de cota‡Æo internacional). 
**
*******************************************************************************/
 ordem:
 for each  ordem-compra no-lock 
     where ordem-compra.numero-ordem >= tt-param.i-ordem-i   
     and   ordem-compra.numero-ordem <= tt-param.i-ordem-f   
     and   ordem-compra.it-codigo    >= tt-param.c-item-i    
     and   ordem-compra.it-codigo    <= tt-param.c-item-f :
        
    &if defined(bf-mat-comex) &then
        if ordem-compra.situacao = "E" or
           ordem-compra.situacao = "C" or
           ordem-compra.situacao = "R" then
           next ordem.
    &else    
        if ordem-compra.situacao = 4 or
           ordem-compra.situacao = 2 or
           ordem-compra.situacao = 6 then
           next ordem.
    &endif
    
    if can-find(first cotacao-item 
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cot-aprovada no-lock) then
        next ordem.
                          
    if not ordem-compra.impr-ficha                    or                        
       ordem-compra.cod-estabel  < tt-param.c-estab-i or   
       ordem-compra.cod-estabel  > tt-param.c-estab-f or                        
       ordem-compra.data-emissao < tt-param.d-data-i  or   
       ordem-compra.data-emissao > tt-param.d-data-f  or   
       ordem-compra.cod-comprado < tt-param.c-compr-i or   
       ordem-compra.cod-comprado > tt-param.c-compr-f then
       next ordem.
    
    assign l-ok = no.                            
    
    for each item-fornec no-lock where 
             item-fornec.it-codigo    = ordem-compra.it-codigo:
        if item-fornec.ativo then do:
           assign l-ok = yes.
           leave.
        end.           
        else     
           assign l-ok = no.
    end.         
    
    if l-ok = no
    then do:
        create tt-inconsist.
        assign tt-inconsist.num-ordem       = ordem-compra.numero-ordem
               tt-inconsist.requisitante    = ordem-compra.requisitante.
        &if defined(bf-mat-comex) &then 
            find first requisitante where
                 requisitante.nome-abrev = ordem-compra.requisitante no-lock no-error.
            If avail requisitante then
            do:
               assign tt-inconsist.nome-abrev = substring(requisitante.nome,1,32).
            end.
              else do:
                  assign tt-inconsist.nome-abrev = "".
              end.
        &else
            find first usuar_mestre no-lock where               
                 usuar_mestre.cod_usuario = ordem-compra.requisitante no-error.
            if avail usuar_mestre then do:
               assign tt-inconsist.nome-abrev   = usuar_mestre.nom_usuario.
            end.          
            else do:
               assign tt-inconsist.nome-abrev   = "".
            end.
        &endif            
        assign tt-inconsist.it-codigo       = ordem-compra.it-codigo.
    end.              
    
    item:
    for each item-fornec no-lock where 
        item-fornec.it-codigo    = ordem-compra.it-codigo and
        item-fornec.cod-emitente >= tt-param.i-forn-i and
        item-fornec.cod-emitente <= tt-param.i-forn-f
        break by item-fornec.cod-emitente 
              by item-fornec.it-codigo:   
        
       find emitente where
            emitente.cod-emitente = item-fornec.cod-emitente
            no-lock no-error.
       if avail emitente then do:
          &if defined(bf-mat-comex) &then
            if emitente.natureza = "F" or
               emitente.natureza = "J" then
               next item.
          &else    
            if emitente.natureza = 1 or
               emitente.natureza = 2 then
               next item.
          &endif
       end.
        
        if not item-fornec.ativo then
           next item.
           
        find first cotacao-item no-lock 
             where cotacao-item.numero-ordem = ordem-compra.numero-ordem
             and   cotacao-item.cod-emitente = item-fornec.cod-emitente
             and   cotacao-item.it-codigo    = ordem-compra.it-codigo no-error.
        if avail cotacao-item then
        do:
        
           &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
               if v_log_eai_habilit then do:               
                   if tt-param.l-bus-to-bus then do:    
                       create ttQuotation.
                       assign ttQuotation.rw-cotacao-item = rowid(cotacao-item).
                   end.
               end.
           &ENDIF               

           &if defined(bf-mat-comex) &then
               if ordem-compra.situacao = "E" or
                  ordem-compra.situacao = "C" or
                  ordem-compra.situacao = "R" then
                  next item.
           &else    
               if ordem-compra.situacao = 4 or
                  ordem-compra.situacao = 2 or
                  ordem-compra.situacao = 6 then
                  next item.
           &endif
        end.
           
        find item where 
             item.it-codigo  = item-fornec.it-codigo and   
             item.fm-codigo >= tt-param.c-fami-i     and   
             item.fm-codigo <= tt-param.c-fami-f
             no-lock no-error.   
        if avail item then do:     
           assign de-quant = 0.
           for each prazo-compra no-lock where 
               prazo-compra.numero-ordem = ordem-compra.numero-ordem:
               assign de-quant = de-quant + prazo-compra.quantidade
                      da-data = prazo-compra.data-entrega.
           end.
           
           create tt-ficha.
           assign tt-ficha.numero-ordem = ordem-compra.numero-ordem
                  tt-ficha.item         = item-fornec.item-do-forn
                  &if defined(bf-mat-comex) &then 
                      tt-ficha.descricao    = trim(item.descricao-1) + ' ' + item.descricao-2
                  &else
                      tt-ficha.descricao    = item.desc-item
                  &endif
                  de-indice        = item-fornec.fator-conver / 
                                     if item-fornec.num-casa-dec = 0
                                     then 1 else exp(10,item-fornec.num-casa-dec)
                  tt-ficha.quant   = de-quant * de-indice
                  tt-ficha.chegada = da-data.
           
            assign tt-ficha.un = item-fornec.unid-med-for.
           
            if tt-param.l-traduz then do:            
                if avail emitente then 
                    find emitente-cex 
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock no-error.
                if avail emitente-cex then                 
                    find traduc-item 
                        where traduc-item.it-codigo  = item.it-codigo 
                          and traduc-item.cod-idioma = emitente-cex.cod-idioma no-lock no-error.  
            end.
        
            /* Narrativa */
            find narrativa where narrativa.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if avail traduc-item and traduc-item.tr-narrativa <> "" and tt-param.l-traduz then
               assign tt-ficha.narrativa = traduc-item.tr-narrativa.
            else
               &if defined(bf-mat-comex) &then
                   if ordem-compra.narrativa[1] <> "" then
                      assign tt-ficha.narrativa[1] = ordem-compra.narrativa[1] 
                             tt-ficha.narrativa[2] = ordem-compra.narrativa[2] 
                             tt-ficha.narrativa[3] = ordem-compra.narrativa[3] 
                             tt-ficha.narrativa[4] = ordem-compra.narrativa[4] 
                             tt-ficha.narrativa[5] = ordem-compra.narrativa[5].
               &else
                   if ordem-compra.narrativa <> "" then
                      assign tt-ficha.narrativa = ordem-compra.narrativa.
               &endif       
            else
            if  avail item-fornec 
            and item.it-codigo <> "" 
            and 
               &if defined(bf-mat-comex) &then
                   item-fornec.narrativa[1] <> "" then
                   assign tt-ficha.narrativa[1] = item-fornec.narrativa[1]
                          tt-ficha.narrativa[2] = item-fornec.narrativa[2]
                          tt-ficha.narrativa[3] = item-fornec.narrativa[3]
                          tt-ficha.narrativa[4] = item-fornec.narrativa[4]
                          tt-ficha.narrativa[5] = item-fornec.narrativa[5].
               &else    
                   item-fornec.narrativa <> "" then
                   assign tt-ficha.narrativa = item-fornec.narrativa.
               &endif    
            else
            if  avail narrativa 
            and 
               &if defined(bf-mat-comex) &then
                  narrativa.descricao[1] <> "" then
                  assign tt-ficha.narrativa = narrativa.descricao[1] 
                         tt-ficha.narrativa = narrativa.descricao[2] 
                         tt-ficha.narrativa = narrativa.descricao[3] 
                         tt-ficha.narrativa = narrativa.descricao[4] 
                         tt-ficha.narrativa = narrativa.descricao[5].
               &else
                  narrativa.descricao <> "" then
                  assign tt-ficha.narrativa = narrativa.descricao.
               &endif
               
            find emitente 
                where emitente.cod-emitente = item-fornec.cod-emitente no-lock no-error.
            if avail emitente then do:     
              assign tt-ficha.fornecedor   = emitente.nome-emit
                     tt-ficha.tel1         = emitente.telefone[1]
                     tt-ficha.fax1         = emitente.telefax
                     tt-ficha.cod-forn     = emitente.cod-emitente
                     &if defined(bf-mat-comex) &then 
                     &else
                         tt-ficha.e-mail   = emitente.e-mail
                     &endif
                     tt-ficha.cod-forn     = emitente.cod-emitente.
              find emitente-cex where
                 emitente-cex.cod-emitente = emitente.cod-emitente
                 no-lock no-error.
              if avail emitente-cex then
                 assign tt-ficha.cod-idioma = emitente-cex.cod-idioma.              
           end.            
                      
           find comprador where
              comprador.cod-comprado = ordem-compra.cod-comprado
              no-lock no-error.
           if avail comprador then
              assign tt-ficha.comprador = comprador.nome
              &if defined(bf-mat-comex) &then 
              &else 
                 tt-ficha.tel2      = comprador.telefone[1]
                 tt-ficha.fax2      = comprador.telefax                               
              &endif .
        end.           
    end.   
end.
/* imp/im0302.i3 */    
