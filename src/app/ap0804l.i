/****************************************************************************
**
**  Programa: AP0807l.i
**  Objetivo: Consulta de Contas por movimento
**
*****************************************************************************/

/* Miniflexibilizacao EMS203 */
{cdp/cdcfgfin.i}

find mov-ap where rowid(mov-ap) = gr-mov-ap no-lock no-error.
find tit-ap where rowid(tit-ap) = gr-tit-ap no-lock no-error.

if  avail mov-ap then do:   
    find first emitente
         where emitente.cod-emitente = mov-ap.cod-fornec
         and   emitente.identific   <> 1 no-lock no-error.
            
    find portador
         where portador.ep-codigo  = mov-ap.ep-codigo
         and   portador.cod-port   = mov-ap.portador
         and   portador.modalidade = mov-ap.modalidade no-lock no-error.
                
    if  avail portador then do:
        if  portador.bancario then do:
            find first cta-corrente
                 where cta-corrente.cod-banco    = portador.cod-banco
                 and   cta-corrente.agencia      = portador.agencia
                 and   cta-corrente.conta-corren = portador.conta-corren
                 no-lock no-error.
         end.
    end.
                    
    if  mov-ap.transacao = 1 then do: /*IMD*/
        find first conta-ap
             where conta-ap.ep-codigo   = mov-ap.ep-codigo
             and   conta-ap.cod-estabel = mov-ap.cod-estabel
             and   conta-ap.cod-esp     = mov-ap.cod-esp
             and   conta-ap.cod-grupo   = emitente.cod-gr-forn
             no-lock no-error.
        
        if  tit-ap.tipo = 2 then do: /*AN*/
            {utp/ut-liter.i CR}
            find conta-contab
                 where conta-contab.ep-codigo      = mov-ap.ep-codigo
                 and   conta-contab.conta-contabil = mov-ap.conta-contabil
                 no-lock no-error.
            create tt-mov-ap.
            assign tt-mov-ap.cod-conta =  mov-ap.conta-contabil
                   tt-mov-ap.valor     =  mov-ap.valor-mov
                   tt-mov-ap.titulo    =  if avail conta-contab then conta-contab.titulo else "***"
                   tt-mov-ap.lancto    =  trim(return-value).
                            
            if  avail conta-ap then do:   
                {utp/ut-liter.i DB}
                find conta-contab
                     where conta-contab.ep-codigo      = mov-ap.ep-codigo
                     and   conta-contab.conta-contabil = conta-ap.conta-saldo
                     no-lock no-error.                
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta  =  conta-ap.conta-saldo
                       tt-mov-ap.valor      =  mov-ap.valor-mov
                       tt-mov-ap.titulo     =  if avail conta-contab then conta-contab.titulo else "***"
                       tt-mov-ap.lancto     =  trim(return-value) .
            end.
        end.
        else do:
            find first tit-conta-ap
                 where  tit-conta-ap.ep-codigo   = mov-ap.ep-codigo
                 and    tit-conta-ap.cod-estabel = mov-ap.cod-estabel
                 and    tit-conta-ap.cod-esp     = mov-ap.cod-esp
                 and    tit-conta-ap.serie       = mov-ap.serie
                 and    tit-conta-ap.nr-docto    = mov-ap.nr-docto
                 and    tit-conta-ap.parcela     = mov-ap.parcela
                 and    tit-conta-ap.cod-fornec  = mov-ap.cod-fornec
                 no-lock no-error.
            if  avail tit-conta-ap then do:
                for each  tit-conta-ap
                    where tit-conta-ap.ep-codigo   = mov-ap.ep-codigo
                    and   tit-conta-ap.cod-estabel = mov-ap.cod-estabel
                    and   tit-conta-ap.cod-esp     = mov-ap.cod-esp
                    and   tit-conta-ap.serie       = mov-ap.serie
                    and   tit-conta-ap.nr-docto    = mov-ap.nr-docto
                    and   tit-conta-ap.parcela     = mov-ap.parcela
                    and   tit-conta-ap.cod-fornec  = mov-ap.cod-fornec
                    no-lock:
                    {utp/ut-liter.i DB}                                                
                    find conta-contab
                       where conta-contab.ep-codigo    = tit-conta-ap.ep-codigo
                       and   conta-contab.conta-contab = tit-conta-ap.conta-debito
                       no-lock no-error.
                    create tt-mov-ap.                        
                    assign tt-mov-ap.cod-conta =  tit-conta-ap.conta-debito
                           tt-mov-ap.valor     =  tit-conta-ap.vl-movto 
                           tt-mov-ap.titulo    =  if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto    =  trim(return-value) .
                 end.
            end.
            else do:   
                {utp/ut-liter.i DB}                                                                    
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = mov-ap.conta-contabil
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta =  mov-ap.conta-contabil
                       tt-mov-ap.valor     =  mov-ap.valor-mov
                       tt-mov-ap.titulo    =  if avail conta-contab then conta-contab.titulo else "***"              
                       tt-mov-ap.lancto    = trim(return-value).
            end.
            if  avail conta-ap then do:    
               {utp/ut-liter.i CR}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = conta-ap.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = conta-ap.conta-saldo
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                       tt-mov-ap.lancto    =  trim(return-value).
            end.
        end.
    end.
            
    find first conta-ap
         where conta-ap.ep-codigo   = mov-ap.ep-codigo
         and   conta-ap.cod-estabel = mov-ap.cod-estabel
         and   conta-ap.cod-esp     = mov-ap.cod-esp
         and   conta-ap.cod-grupo   = emitente.cod-gr-forn 
         no-lock no-error.
            
    if  mov-ap.transacao = 3 then do: /*PEF*/
        {utp/ut-liter.i DB}                                                
        find conta-contab
           where conta-contab.ep-codigo    = mov-ap.ep-codigo
           and   conta-contab.conta-contab = mov-ap.conta-contabil
           no-lock no-error.
        create tt-mov-ap.
        assign tt-mov-ap.cod-conta    = mov-ap.conta-contabil 
               tt-mov-ap.valor    = mov-ap.valor-mov
               tt-mov-ap.titulo   =  if avail conta-contab then conta-contab.titulo else "***" 
               tt-mov-ap.lancto    = trim(return-value).
        if  tit-ap.tipo = 2 then do : /*AN*/
            if  avail conta-ap then do:   
               {utp/ut-liter.i CR}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = conta-ap.ep-codigo
                   and   conta-contab.conta-contab = conta-ap.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = conta-ap.conta-saldo 
                       tt-mov-ap.valor     = mov-ap.valor-mov   
                       tt-mov-ap.titulo    =  if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.lancto    = trim(return-value).
            end.
        end.
        else do:
            if  avail portador and portador.bancario and avail cta-corrente then do:
                {utp/ut-liter.i CR}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = cta-corrente.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta =  cta-corrente.conta-saldo
                       tt-mov-ap.valor     =  mov-ap.valor-mov
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.lancto    =  trim(return-value).
            end.
            else 
            if  avail portador and not portador.bancario then do:
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = portador.conta-contabil
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta =  portador.conta-contabil
                       tt-mov-ap.valor     =  mov-ap.valor-mov
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.lancto    =  trim(return-value).
            end.
        end.
    end.

    if  mov-ap.transacao = 4 then do: /*PEC*/
        {utp/ut-liter.i CR}                                                
        find conta-contab
           where conta-contab.ep-codigo    = mov-ap.ep-codigo
           and   conta-contab.conta-contab = mov-ap.conta-contabil
           no-lock no-error.
        create tt-mov-ap.
        assign tt-mov-ap.cod-conta = mov-ap.conta-contabil 
               tt-mov-ap.valor     = mov-ap.valor-mov
               tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
               tt-mov-ap.lancto    = trim(return-value).
     
        if  tit-ap.tipo = 2 then do : /*AN*/           
            if  avail conta-ap then do:
                {utp/ut-liter.i DB}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = conta-ap.ep-codigo
                   and   conta-contab.conta-contab = conta-ap.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = conta-ap.conta-saldo 
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.lancto    = trim(return-value).
            end.
        end.
        else do:
            if  avail portador and portador.bancario and avail cta-corrente then do:
                {utp/ut-liter.i DB}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = cta-corrente.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = cta-corrente.conta-saldo
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.lancto    = trim(return-value).
            end.
            else
            if  avail portador and not portador.bancario then do:
                {utp/ut-liter.i DB}                                                
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = portador.conta-contabil
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = portador.conta-contabil
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.lancto    = trim(return-value).
            end.
        end.
    end.

    if  mov-ap.transacao = 2 then do: /*BND*/
        if  mov-ap.vl-antecip > 0 then do:
            if  mov-ap.vl-antecip = mov-ap.valor-mov then  do:
                {utp/ut-liter.i DB}                                                
            end.     
            else do:
                {utp/ut-liter.i CR}      
            end.                 
            assign c-deb =  trim(return-value).
            if  avail conta-ap then do:
                {utp/ut-liter.i DB} 
                find conta-contab
                   where conta-contab.ep-codigo    = conta-ap.ep-codigo
                   and   conta-contab.conta-contab = conta-ap.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = conta-ap.conta-saldo 
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.lancto    = trim(return-value).
            end.
            find first b-emitente
                where b-emitente.cod-emitente = mov-ap.fornec-ant
                and   b-emitente.identific <> 1 no-lock no-error.
            find b-conta-ap
                where b-conta-ap.ep-codigo   = mov-ap.ep-codigo
                and  b-conta-ap.cod-estabel  = mov-ap.cod-estabel
                and  b-conta-ap.cod-esp      = mov-ap.esp-ant
                and  b-conta-ap.cod-grupo    = b-emitente.cod-gr-forn
                no-lock no-error.
            if  avail b-conta-ap then do:
                find conta-contab
                    where conta-contab.ep-codigo      = mov-ap.ep-codigo
                    and   conta-contab.conta-contabil = b-conta-ap.conta-saldo
                    no-lock no-error.
                {utp/ut-liter.i CR} 
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta =  b-conta-ap.conta-saldo
                       tt-mov-ap.titulo    =  if avail conta-contab then conta-contab.titulo else "***"
                       tt-mov-ap.valor     =  mov-ap.valor-mov
                       tt-mov-ap.lancto    =  trim(return-value) .
            end.

            if  (mov-ap.vl-desconto > 0
            and  mov-ap.vl-antecip = mov-ap.valor-mov)
            or  (mov-ap.vl-antecip <> mov-ap.valor-mov) then do:
                if  avail portador and portador.bancario and avail cta-corrente then do:
                    find conta-contab
                       where conta-contab.ep-codigo    = mov-ap.ep-codigo
                       and   conta-contab.conta-contab = cta-corrente.conta-saldo
                       no-lock no-error.
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta  = cta-corrente.conta-saldo
                           tt-mov-ap.valor      = mov-ap.valor-mov
                           tt-mov-ap.titulo     = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto     = c-deb.
                end.
                else
                if  avail portador and not portador.bancario then do:
                    find conta-contab
                       where conta-contab.ep-codigo    = mov-ap.ep-codigo
                       and   conta-contab.conta-contab = portador.conta-contabil
                       no-lock no-error.
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta  = portador.conta-contabil
                           tt-mov-ap.valor      = mov-ap.valor-mov
                           tt-mov-ap.titulo     = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto     = c-deb.
                end.
            end.

            if  mov-ap.vl-desconto > 0 then do:
                find conta-contab
                    where conta-contab.ep-codigo      = mov-ap.ep-codigo
                    and   conta-contab.conta-contabil = conta-ap.conta-desconto
                    no-lock no-error.
                {utp/ut-liter.i CR} 
                 create tt-mov-ap.
                 assign tt-mov-ap.cod-conta = conta-ap.conta-desconto
                        tt-mov-ap.valor     = mov-ap.vl-desconto 
                        tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                        tt-mov-ap.lancto    = trim(return-value).
            end.
            
            if  mov-ap.valor-juros > 0 then do:
                find conta-contab
                    where conta-contab.ep-codigo      = mov-ap.ep-codigo
                    and   conta-contab.conta-contabil = conta-ap.conta-juros
                    no-lock no-error.
                {utp/ut-liter.i DB} 
                 create tt-mov-ap.
                 assign tt-mov-ap.cod-conta = conta-ap.conta-juros
                        tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                        tt-mov-ap.lancto    = trim(return-value)
                        tt-mov-ap.valor     = mov-ap.valor-juros.
            end.
            
            if  mov-ap.valor-juros > 0 then do:
                if  avail portador and portador.bancario and avail cta-corrente then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = cta-corrente.conta-juros-pagos
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta =  cta-corrente.conta-juros-pagos
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.valor-juros.
                end.
                else
                if  avail portador and not portador.bancario then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = portador.conta-contabil
                        no-lock no-error.
                    {utp/ut-liter.i CR}
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = portador.conta-contabil
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.valor-juros.
                end.
            end.
            
            &if defined(BF_FIN_MULTA_ABATIMENTO) &then
            /* MULTA */
            if  mov-ap.vl-multa > 0 then do:
                find conta-contab
                    where conta-contab.ep-codigo      = mov-ap.ep-codigo
                    and   conta-contab.conta-contabil = conta-ap.conta-multa
                    no-lock no-error.
                {utp/ut-liter.i DB} 
                 create tt-mov-ap.
                 assign tt-mov-ap.cod-conta = conta-ap.conta-multa
                        tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                        tt-mov-ap.lancto    = trim(return-value)
                        tt-mov-ap.valor     = mov-ap.vl-multa.
            end.
            
            if  mov-ap.vl-multa > 0 then do:
                if  avail portador and portador.bancario and avail cta-corrente then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = cta-corrente.conta-juros-pagos /* aqui */
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-juros-pagos /* aqui */
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.vl-multa.
                end.
                else
                if  avail portador and not portador.bancario then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = portador.conta-contabil
                        no-lock no-error.
                    {utp/ut-liter.i CR}
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = portador.conta-contabil
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.vl-multa.
                end.
            end.
            
            /* ABATIMENTO */
            if  (mov-ap.vl-abatimento > 0
            and  mov-ap.vl-antecip    = mov-ap.valor-mov)
            or  (mov-ap.vl-antecip   <> mov-ap.valor-mov) then do:
                if  avail portador and portador.bancario and avail cta-corrente then do:
                    find conta-contab
                       where conta-contab.ep-codigo    = mov-ap.ep-codigo
                       and   conta-contab.conta-contab = cta-corrente.conta-saldo
                       no-lock no-error.
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta  = cta-corrente.conta-saldo
                           tt-mov-ap.valor      = mov-ap.valor-mov
                           tt-mov-ap.titulo     = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto     = c-deb.
                end.
                else
                if  avail portador and not portador.bancario then do:
                    find conta-contab
                       where conta-contab.ep-codigo    = mov-ap.ep-codigo
                       and   conta-contab.conta-contab = portador.conta-contabil
                       no-lock no-error.
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta  = portador.conta-contabil
                           tt-mov-ap.valor      = mov-ap.valor-mov
                           tt-mov-ap.titulo     = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.lancto     = c-deb.
                end.
            end.

            if  mov-ap.vl-abatimento > 0 then do:
                find conta-contab
                    where conta-contab.ep-codigo      = mov-ap.ep-codigo
                    and   conta-contab.conta-contabil = conta-ap.conta-abatimento
                    no-lock no-error.
                {utp/ut-liter.i CR} 
                 create tt-mov-ap.
                 assign tt-mov-ap.cod-conta = conta-ap.conta-abatimento
                        tt-mov-ap.valor     = mov-ap.vl-abatimento
                        tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                        tt-mov-ap.lancto    = trim(return-value).
            end.
            &endif
            
        end.
        else do:
            if  avail conta-ap then do:     
                {utp/ut-liter.i DB}
                find conta-contab
                   where conta-contab.ep-codigo    = conta-ap.ep-codigo
                   and   conta-contab.conta-contab = conta-ap.conta-saldo
                   no-lock no-error.
                create tt-mov-ap.
                assign tt-mov-ap.cod-conta = conta-ap.conta-saldo 
                       tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                       tt-mov-ap.valor     = mov-ap.valor-mov
                       tt-mov-ap.lancto    = trim(return-value).
               
                if  mov-ap.vl-desconto > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = conta-ap.conta-desconto
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = conta-ap.conta-desconto
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     =  mov-ap.vl-desconto.
                end.
                
                if  mov-ap.valor-juros > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = conta-ap.conta-juros
                        no-lock no-error.
                    {utp/ut-liter.i DB} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = conta-ap.conta-juros
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.valor-juros.
                end.
                
                &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                if  mov-ap.vl-abatimento > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = conta-ap.conta-abatimento
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = conta-ap.conta-abatimento
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     =  mov-ap.vl-abatimento.
                end.
                
                if  mov-ap.vl-multa > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = conta-ap.conta-multa
                        no-lock no-error.
                    {utp/ut-liter.i DB} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = conta-ap.conta-multa
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value)
                           tt-mov-ap.valor     = mov-ap.vl-multa.
                end.
                &endif
                
                if  mov-ap.vl-var-monet > 0 then do:
                    find conta-contab
                       where conta-contab.ep-codigo      = mov-ap.ep-codigo
                       and   conta-contab.conta-contabil = conta-ap.conta-var-monetaria
                       no-lock no-error.
                    {utp/ut-liter.i DB} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = conta-ap.conta-var-monetaria
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
                           tt-mov-ap.valor     = mov-ap.vl-var-monet 
                           tt-mov-ap.lancto    = trim(return-value).
                end.
            end.
            
            if  avail portador and portador.bancario and avail cta-corrente then do:
                {utp/ut-liter.i CR}
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = cta-corrente.conta-saldo
                   no-lock no-error.

                if  mov-ap.vl-var-monet > 0 then do:
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-saldo
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.valor     = mov-ap.valor-mov
                                               + mov-ap.vl-var-monet
                                               - mov-ap.vl-desconto
                                               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                                               - mov-ap.vl-abatimento
                                               &endif
                           tt-mov-ap.lancto    = trim(return-value).

                end.
                else do:
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-saldo
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.valor     = mov-ap.valor-mov
                                               - mov-ap.vl-desconto
                                               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                                               - mov-ap.vl-abatimento
                                               &endif
                           tt-mov-ap.lancto    = trim(return-value).
                end.
                
                       
                if  mov-ap.valor-juros > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = cta-corrente.conta-juros-pagos
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-juros-pagos
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value) 
                           tt-mov-ap.valor     = mov-ap.valor-juros.
                end.
                
                &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                if  mov-ap.vl-multa > 0 then do:
                    find conta-contab
                        where conta-contab.ep-codigo      = mov-ap.ep-codigo
                        and   conta-contab.conta-contabil = cta-corrente.conta-juros-pagos /* aqui */
                        no-lock no-error.
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-juros-pagos /* aqui */
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value) 
                           tt-mov-ap.valor     = mov-ap.vl-multa.
                end.
                &endif
                
            end.
            else 
            if  avail portador and not portador.bancario then do:
                {utp/ut-liter.i CR}
                find conta-contab
                   where conta-contab.ep-codigo    = mov-ap.ep-codigo
                   and   conta-contab.conta-contab = portador.conta-contabil
                   no-lock no-error.
                if  mov-ap.vl-var-monet > 0 then do:
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = cta-corrente.conta-saldo
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.valor     = mov-ap.valor-mov
                                               + mov-ap.vl-var-monet
                                               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                                               - mov-ap.vl-abatimento
                                               &endif
                                               - mov-ap.vl-desconto
                           tt-mov-ap.lancto    = trim(return-value).

                end.
                else do:
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = portador.conta-contabil
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.valor     = mov-ap.valor-mov
                                               - mov-ap.vl-desconto
                                               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                                               - mov-ap.vl-abatimento
                                               &endif
                           tt-mov-ap.lancto    = trim(return-value).
                end.
                
                if  mov-ap.valor-juros > 0 then do:
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = portador.conta-contabil
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value) 
                           tt-mov-ap.valor     = mov-ap.valor-juros.
                end.
                
                &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                if  mov-ap.vl-multa > 0 then do:
                    {utp/ut-liter.i CR} 
                    create tt-mov-ap.
                    assign tt-mov-ap.cod-conta = portador.conta-contabil
                           tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***" 
                           tt-mov-ap.lancto    = trim(return-value) 
                           tt-mov-ap.valor     = mov-ap.vl-multa.
                end.
                &endif
            end.
        end.
    end.
    
    if  mov-ap.transacao = 5 then do : /*AVA*/
        if  mov-ap.lancamento = 1 then  do:
             {utp/ut-liter.i DB}
             assign c-deb = trim(return-value).
             {utp/ut-liter.i CR}  
             assign c-cre = trim(return-value).
        end.                                   
        else do:
             {utp/ut-liter.i DB}
             assign c-cre= trim(return-value).
             {utp/ut-liter.i CR}  
             assign c-deb = trim(return-value).  
        end.            
        
        find conta-contab
           where conta-contab.ep-codigo    = mov-ap.ep-codigo
           and   conta-contab.conta-contab = mov-ap.conta-contabil
           no-lock no-error.
        create tt-mov-ap.
        assign tt-mov-ap.cod-conta = mov-ap.conta-contabil
               tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"
               tt-mov-ap.valor     = mov-ap.valor-mov
               tt-mov-ap.lancto    = c-deb .
      
        if  avail conta-ap then do:
            find conta-contab
               where conta-contab.ep-codigo    = conta-ap.ep-codigo
               and   conta-contab.conta-contab = conta-ap.conta-saldo
               no-lock no-error.
            create tt-mov-ap.
            assign tt-mov-ap.cod-conta = conta-ap.conta-saldo
                   tt-mov-ap.titulo    = if avail conta-contab then conta-contab.titulo else "***"  
                   tt-mov-ap.valor     = mov-ap.valor-mov 
                   tt-mov-ap.lancto    = c-cre.
        end.
    end.

    if  mov-ap.transacao = 6 then do: /*SND*/
                        
        {utp/ut-liter.i DB}
        assign c-deb = trim(return-value). 
                    
        {utp/ut-liter.i CR}
        assign c-cre = trim(return-value). 
                    
        if  avail conta-ap then do:
            find first param-ap no-lock where param-ap.ep-codigo = mov-ap.ep-codigo no-error.
            if  avail param-ap then do:
                            
                find first conta-contab
                     where conta-contab.ep-codigo    = conta-ap.ep-codigo
                     and   conta-contab.conta-contab = conta-ap.conta-saldo
                     no-lock no-error.
                        
                find first b-conta-contab
                     where b-conta-contab.ep-codigo    = mov-ap.ep-codigo
                     and   b-conta-contab.conta-contab = param-ap.conta-trans-pag
                     no-lock no-error.
                            
                if  mov-ap.lancamento = 1 then do:     
                    if  avail conta-contab then do:
                        create tt-mov-ap.
                        assign tt-mov-ap.cod-conta = conta-contab.conta-contabil
                               tt-mov-ap.titulo    = conta-contab.titulo
                               tt-mov-ap.valor     = mov-ap.valor-mov
                               tt-mov-ap.lancto    = c-deb.
                    end.
                    if  avail b-conta-contab then do:
                        create tt-mov-ap.
                        assign tt-mov-ap.cod-conta = b-conta-contab.conta-contabil
                               tt-mov-ap.titulo    = b-conta-contab.titulo
                               tt-mov-ap.valor     = mov-ap.valor-mov
                               tt-mov-ap.lancto    = c-cre.
                    end.
                end.                                    
                else do:
                    if  avail conta-contab then do:
                        create tt-mov-ap.
                        assign tt-mov-ap.cod-conta = conta-contab.conta-contabil
                               tt-mov-ap.titulo    = conta-contab.titulo
                               tt-mov-ap.valor     = mov-ap.valor-mov
                               tt-mov-ap.lancto    = c-cre.
                    end.
                    if  avail b-conta-contab then do:
                        create tt-mov-ap.
                        assign tt-mov-ap.cod-conta = b-conta-contab.conta-contabil
                               tt-mov-ap.titulo    = b-conta-contab.titulo
                               tt-mov-ap.valor     = mov-ap.valor-mov
                               tt-mov-ap.lancto    = c-deb.
                    end.
                end.
            end.
        end.
    end.
end.

/* AP0804L */
