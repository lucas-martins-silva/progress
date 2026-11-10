/*******************************************************************************
**
**  Include.: AP0597.I
**  Objetivo: Complemento EmissÆo de Cheques - Internacional
**
*******************************************************************************/

assign i-cheq-old         = che-emit.nr-cheque.
       che-emit.nr-cheque = talonario.prox-cheque.

if first-of(che-emit.literal) then 
   disp che-emit.cod-fornec 
        che-emit.nr-cheque  
        with frame f-imp-1.

assign de-vl-liq   = mov-ap.valor-mov - mov-ap.vl-desconto
       de-tot-orig = IF l-tot-pgt-pef AND che-emit.transacao = 4 THEN de-tot-orig - de-vl-liq 
                     ELSE de-tot-orig + de-vl-liq.     

/* Cabe‡alho do Documento (Implanta‡Æo do T¡tulo) */
find first b-mov-ap 
     where b-mov-ap.ep-codigo   = mov-ap.ep-codigo   
     and   b-mov-ap.cod-fornec  = mov-ap.cod-fornec  
     and   b-mov-ap.cod-estabel = mov-ap.cod-estabel 
     and   b-mov-ap.cod-esp     = mov-ap.cod-esp     
     and   b-mov-ap.serie       = mov-ap.serie       
     and   b-mov-ap.nr-docto    = mov-ap.nr-docto    
     and   b-mov-ap.parcela     = mov-ap.parcela     
     and   b-mov-ap.transacao   = 1 no-lock no-error.

if avail b-mov-ap then do:

   find first b-espec-ap
        where b-espec-ap.cod-esp = b-mov-ap.cod-esp no-lock no-error.
   if  not avail b-espec-ap then next.    

   assign i-linha = i-linha + 1.

   if tt-param.l-copia = no then do:
      if  b-espec-ap.tipo <> 3 then
          disp b-mov-ap.nr-docto      
               b-mov-ap.dt-trans      
               b-mov-ap.nr-docto @ c-nr-docto-aux 
               b-mov-ap.valor-mov     
               b-mov-ap.vl-desconto   
               de-vl-liq           
               with frame f-imp-2.
      else
          disp b-mov-ap.nr-docto      
               b-mov-ap.dt-trans      
               b-mov-ap.historico @ c-nr-docto-aux 
               b-mov-ap.valor-mov     
               b-mov-ap.vl-desconto   
               de-vl-liq           
               with frame f-imp-2.
      down with frame f-imp-2.
   end.

   else do:
      if  espec-ap.tipo <> 3 then
          disp stream s-copia
               b-mov-ap.nr-docto     
               b-mov-ap.dt-trans     
               b-mov-ap.nr-docto @ c-nr-docto-aux
               b-mov-ap.valor-mov    
               b-mov-ap.vl-desconto  
               de-vl-liq
               with frame f-imp-2.
      else
          disp stream s-copia
               b-mov-ap.nr-docto     
               b-mov-ap.dt-trans     
               b-mov-ap.historico @ c-nr-docto-aux
               b-mov-ap.valor-mov    
               b-mov-ap.vl-desconto  
               de-vl-liq
               with frame f-imp-2.
      down with frame f-imp-2.     
   end.   
   {app/ap0597.i1}
end.

if   tt-param.tipo = 2 
and (avail espec-ap 
and  espec-ap.tipo = 1) then do:

    /* Antecipa‡äes e Notas de Cr‚dito/D‚bito */
    for each b-mov-ap no-lock
       where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
         and b-mov-ap.cod-fornec  = mov-ap.cod-fornec
         and b-mov-ap.cod-estabel = mov-ap.cod-estabel
         and b-mov-ap.cod-esp     = mov-ap.cod-esp
         and b-mov-ap.serie       = mov-ap.serie
         and b-mov-ap.nr-docto    = mov-ap.nr-docto
         and b-mov-ap.parcela     = mov-ap.parcela
         and b-mov-ap.esp-ant     > " ":

        assign c-especie   = ""
               de-original = 0
               i-linha     = i-linha + 1.

        find b-espec-ap where 
             b-espec-ap.cod-esp = b-mov-ap.esp-ant no-lock no-error.
        if avail b-espec-ap then 
           assign c-especie = c-especie + ({adinc/i01ad104.i 04 b-espec-ap.tipo}).

        if b-mov-ap.transacao = 5 then  /* AVA */
           assign de-original = if b-mov-ap.lancamento = 1 then 1 else -1
                  de-original = de-original * b-mov-ap.valor-mov.
        else 
           assign de-original = if b-espec-ap.tipo = 4 then 1 else -1 
                  de-original = de-original * b-mov-ap.valor-mov.

        if de-original <> 0 then do:
           disp b-mov-ap.docto-ant     @ b-mov-ap.nr-docto      
                ""                     @ b-mov-ap.dt-trans      
                c-especie              @ c-nr-docto-aux      
                de-original            @ b-mov-ap.valor-mov
                ""                     @ b-mov-ap.vl-desconto   
                ""                     @ de-vl-liq
                with frame f-imp-2.
           down with frame f-imp-2.                  

           if tt-param.l-copia = yes then do:
              disp stream s-copia
                   b-mov-ap.docto-ant     @ b-mov-ap.nr-docto   
                   ""                     @ b-mov-ap.dt-trans      
                   c-especie              @ c-nr-docto-aux      
                   de-original            @ b-mov-ap.valor-mov
                   ""                     @ b-mov-ap.vl-desconto   
                   ""                     @ de-vl-liq
                   with frame f-imp-2.
              down with frame f-imp-2.                
           end.    

           {app/ap0597.i1}
        end.    
    end.

    /* Os campos de antecipa‡Æo sao usados para ligar
       as notas de Cr‚dito e D‚bito a Invoice */
    for each b-mov-ap no-lock
       where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
         and b-mov-ap.cod-estabel = mov-ap.cod-estabel
         and b-mov-ap.esp-ant     = mov-ap.cod-esp
         and b-mov-ap.serie-ant   = mov-ap.serie
         and b-mov-ap.docto-ant   = mov-ap.nr-docto
         and b-mov-ap.parc-ant    = mov-ap.parcela
         and b-mov-ap.cod-fornec  = mov-ap.cod-fornec
         and b-mov-ap.transacao   = 16:

        find b-espec-ap where 
             b-espec-ap.cod-esp = b-mov-ap.cod-esp no-lock no-error.
        if avail b-espec-ap then do:
           assign de-original = if b-espec-ap.tipo = 5 then - 1 else 1
                  de-original = de-original * b-mov-ap.valor-mov
                  c-especie   = {adinc/i01ad104.i 04 b-espec-ap.tipo}
                  i-linha     = i-linha + 1.

           disp b-mov-ap.nr-docto   
                ""                     @ b-mov-ap.dt-trans      
                c-especie              @ c-nr-docto-aux      
                de-original            @ b-mov-ap.valor-mov
                ""                     @ b-mov-ap.vl-desconto   
                ""                     @ de-vl-liq
                with frame f-imp-2.
           down with frame f-imp-2.                

           if tt-param.l-copia = yes then do:
              disp stream s-copia
                   b-mov-ap.nr-docto   
                   ""                     @ b-mov-ap.dt-trans      
                   c-especie              @ c-nr-docto-aux      
                   de-original            @ b-mov-ap.valor-mov
                   ""                     @ b-mov-ap.vl-desconto   
                   ""                     @ de-vl-liq
                   with frame f-imp-2.
              down with frame f-imp-2.                   
           end.   

           {app/ap0597.i1}
        end.
    end.
end.

{app/ap0597.i1}

if last-of(che-emit.literal) then do:
   do i-cont = 1 to (14 - i-linha):
      disp ""
           with frame f-branco.
      down with frame f-branco.
      if tt-param.l-copia = yes then do:
         disp stream s-copia
              ""
              with frame f-branco.
         down with frame f-branco.
      end.
   end.

   disp c-total 
        de-tot-orig    
        with frame f-imp-3.
   if tt-param.l-copia = yes then
      disp c-total 
           de-tot-orig    
           with frame f-imp-3.
end.

if  tt-param.l-reemissao = yes then do:
    create b-che-emit.
    assign b-che-emit.ep-codigo     = che-emit.ep-codigo
           b-che-emit.portador      = che-emit.portador
           b-che-emit.nr-cheque     = i-cheq-old
           b-che-emit.cod-estabel   = che-emit.cod-estabel
           b-che-emit.cod-fornec    = che-emit.cod-fornec
           b-che-emit.cod-esp       = che-emit.cod-esp
           b-che-emit.serie         = che-emit.serie
           b-che-emit.nr-docto      = che-emit.nr-docto
           b-che-emit.parcela       = che-emit.parcela
           b-che-emit.dt-emissao    = che-emit.dt-emissao
           b-che-emit.dt-vencto     = che-emit.dt-vencto
           b-che-emit.transacao     = che-emit.transacao
           b-che-emit.referencia    = che-emit.referencia
           b-che-emit.nominal       = che-emit.nominal
           b-che-emit.literal       = che-emit.literal
           b-che-emit.valor-docto   = che-emit.valor-docto
           b-che-emit.ct-conta      = che-emit.ct-conta
           b-che-emit.sc-conta      = che-emit.sc-conta
           b-che-emit.conta-debito  = che-emit.conta-debito
           b-che-emit.historico     = che-emit.historico
           b-che-emit.nr-talonario  = che-emit.nr-talonario
           b-che-emit.emitiu        = yes
           b-che-emit.cancelado     = yes.

    if  param-global.modulo-cb = yes then do: /* Caixa e Bancos implantado */
        find first cheque exclusive-lock
            where cheque.cod-banco    = portador.cod-banco
            and   cheque.agencia      = portador.agencia
            and   cheque.conta-corren = portador.conta-corren
            and   cheque.nr-cheque    = che-emit.nr-cheque no-error.
        if  avail cheque then do:
            assign cheque.vl-cheque = cheque.vl-cheque - che-emit.valor-docto.
            if  cheque.vl-cheque <= 0 then
                delete cheque.
        end.
    end.

    /* ------------------------ Atualiza‡Æo Caixa e Bancos ---------------------------
    find param-cb no-lock
        where param-cb.ep-codigo = tt-param.i-ep-codigo no-error.
    if  avail param-cb and param-global.modulo-cb = yes then do:
        run cbp/cb0110a.p.
        run cbp/cb0110a.p.
    end.
    ------------------------------------------------------------------------------- */
end.

/* Tabela Tempor ria criada para alterar o n£mero do cheque
   caso seja gerado mais de uma folha */
create tt-continua.
assign tt-continua.rw-che-emit = rowid(che-emit)
       tt-continua.rw-mov-ap   = rowid(mov-ap).

assign mov-ap.nr-cheque      = talonario.prox-cheque
       mov-ap.nr-docto-emp   = trim(string(talonario.prox-cheque))
       de-valor              = IF l-tot-pgt-pef AND che-emit.transacao = 4 THEN de-valor - che-emit.valor-docto
                               ELSE de-valor + che-emit.valor-docto
       che-emit.nr-cheque    = talonario.prox-cheque
       che-emit.nr-talonario = talonario.nr-talonario
       che-emit.emitiu       = yes.

if  last-of(che-emit.literal) then do:
    IF (l-tot-pgt-pef
    AND de-valor > 0)
    OR l-tot-pgt-pef = NO THEN do:
        if  l-continua-cheque = yes then do:
            for each tt-continua no-lock:
                find b-che-emit where rowid(b-che-emit) = tt-continua.rw-che-emit exclusive-lock.
                find b-mov-ap where rowid(b-mov-ap) = tt-continua.rw-mov-ap exclusive-lock.
                assign b-mov-ap.nr-cheque    = talonario.prox-cheque
                       b-mov-ap.nr-docto-emp = string(talonario.prox-cheque)
                       b-che-emit.nr-cheque  = talonario.prox-cheque.
            end.
        end.
    
        for each tt-continua exclusive-lock:
            delete tt-continua.
        end.
    
        find emitente where 
             emitente.cod-emitente = che-emit.cod-fornec and
             emitente.identific <> 1 no-lock no-error.
    
    
        assign l-continua-cheque = no
               c-nome = if  che-emit.nominal = 2
                        and avail emitente then emitente.nome-emit
                        else if  che-emit.nominal = 1 then portador.nome
                              else che-emit.literal.
    
        assign  de-val9100 = de-valor
                i-num9100  = 1   
                i-tam9100  = 132.
        
        run cdp/cd9100.p.
    
        disp c-data 
             de-valor        
             c-ext9100[1]   
             c-nome @  emitente.nome-emit
             emitente.endereco 
             emitente.cidade   
             emitente.estado   
             emitente.cep 
             with frame f-imp-4.
    
        if tt-param.l-copia = yes then do:
           disp stream s-copia 
                c-data 
                de-valor        
                c-ext9100[1]   
                c-nome @ emitente.nome-emit
                emitente.endereco 
                emitente.cidade   
                emitente.estado   
                emitente.cep 
                with frame f-imp-4.
    
            assign i-nr-copia = integer(talonario.prox-copia) no-error.
            if  error-status:error = no then
                assign talonario.prox-copia = i-nr-copia + 1.
        end.
    
     /*   do i-cont = 1 to 6:
           disp ""
                with frame f-branco.
           down with frame f-branco.
           if tt-param.l-copia = yes then do:
              disp stream s-copia
                   ""
                   with frame f-branco.
              down with frame f-branco.
           end.
        end.         */
    
        if  param-global.modulo-cb = yes then do: /* Caixa e Bancos implantado */
            find first cheque exclusive-lock
                where cheque.cod-banco    = portador.cod-banco
                and   cheque.agencia      = portador.agencia
                and   cheque.conta-corren = portador.conta-corren
                and   cheque.nr-cheque    = talonario.prox-cheque no-error.
            if  not avail cheque then do:
                create cheque.
                assign cheque.cod-banco       = portador.cod-banco
                       cheque.agencia         = portador.agencia
                       cheque.conta-corren    = portador.conta-corren
                       cheque.nr-cheque       = talonario.prox-cheque
                       cheque.vl-cheque       = 0.
            end.
    
            assign cheque.ep-codigo-mvto  = che-emit.ep-codigo
                   cheque.cod-emitente    = che-emit.cod-fornec
                   cheque.cod-portador    = che-emit.portador
                   cheque.dt-vencimento   = che-emit.dt-vencto
                   cheque.dt-emissao      = che-emit.dt-emissao
                   cheque.tp-codigo       = mov-ap.tp-codigo
                   cheque.vl-cheque       = cheque.vl-cheque + de-valor
                   cheque.tipo-cheque     = 1  /* Pr¢prio */
                   cheque.situacao-cheque = 1  /* Pendente */
                   cheque.origem-cheque   = 5. /* AP */
        end.
    
        assign de-valor    = 0
               de-tot-orig = 0
               i-linha     = 0
               talonario.ult-cheque = talonario.prox-cheque.
    
        if  talonario.ult-cheque = talonario.nr-cheque-fin then do:
            assign talonario.situacao = 3. /* Utilizado */
            leave code-block.
        end.
        else 
            assign talonario.prox-cheque = talonario.prox-cheque + 1.
    END.
end.

/* AP0597.I */
