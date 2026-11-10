/******************************************************************************
**
**  Programa : ap0501h2.i
**  Objetivo.: Verifica se o Fornecedor Possui Provis∆o.
**
******************************************************************************/
def var de-valor-provisao   as decimal no-undo.
def var l-zera-saldo        as logical no-undo initial no.
def var i-origem-diferente  as integer no-undo.

if  lin-i-ap.origem = 1 then
    assign i-origem-diferente = 5.
else
    assign i-origem-diferente = 0.


/*--- Verifica se o Fornecedor possui Provis∆o ---*/
find first tit-ap use-index codigo no-lock
     where tit-ap.ep-codigo    = lin-i-ap.ep-codigo
     and   tit-ap.cod-estabel  = lin-i-ap.cod-estabel
     and   tit-ap.cod-fornec   = lin-i-ap.cod-fornec
     and   tit-ap.tipo         = 10
     and   tit-ap.origem       <> i-origem-diferente
     and   tit-ap.vl-saldo     > 0
     {1}
     no-error.   

if  not avail tit-ap then do:
          
    /*--- Verifica se a matriz possui provis∆o ---*/
    find first emitente
         where emitente.cod-emitente = lin-i-ap.cod-fornec
         and   emitente.identific   <> 1 no-lock no-error.
              
    if  avail emitente then do:   
        find first b-emitente
             where b-emitente.nome-abrev   = emitente.nome-matriz
             and   b-emitente.identific   <> 1 no-lock no-error.
                      
        if  avail b-emitente then do:
            {utp/ut-liter.i Matriz map C}
            assign c-fornecedor = trim(return-value).
                    
            find first tit-ap use-index matriz no-lock
                 where tit-ap.ep-codigo    = lin-i-ap.ep-codigo
                 and   tit-ap.cod-estabel  = lin-i-ap.cod-estabel
                 and   tit-ap.matriz       = b-emitente.cod-emitente
                 and   tit-ap.tipo         = 10
                 and   tit-ap.origem      <> i-origem-diferente
                 and   tit-ap.vl-saldo     > 0
                 {1}
                 no-error.   
                        
            if  avail tit-ap then 
                assign l-usa-provisao = yes.
        end.
    end.
end.
else do:
    {utp/ut-liter.i Fornecedor map C}
    
    assign c-fornecedor  = trim(return-value)
            l-usa-provisao = yes.
end.


if  l-usa-provisao = yes then do:
    /* Verifica se h† alguma provis∆o com saldo para vincular a este documento */
    for-tit-ap:
    for each tit-ap use-index codigo no-lock
       where tit-ap.ep-codigo    = lin-i-ap.ep-codigo
         and tit-ap.cod-estabel  = lin-i-ap.cod-estabel
         and tit-ap.cod-fornec   = lin-i-ap.cod-fornec
         and tit-ap.tipo         = 10
         and tit-ap.origem      <> i-origem-diferente
         and tit-ap.vl-saldo     > 0:


        assign de-valor-provisao = 0.
    
        /* Verifica o valor da provis∆o que est† vinculado a outro documento.
           Se o valor da provis∆o atual estiver totalmente vinculado, pula para a 
           pr¢xima provis∆o */
        for each l-ant-ap no-lock where l-ant-ap.ep-cod-ant   = tit-ap.ep-codigo 
                                    and l-ant-ap.cod-est-ant  = tit-ap.cod-estabel 
                                    and l-ant-ap.cod-esp-ant  = tit-ap.cod-esp 
                                    and l-ant-ap.nr-docto-ant = tit-ap.nr-docto
                                    and l-ant-ap.parcela-ant  = tit-ap.parcela:
                                    
            /* Se alguma provis∆o estiver zerando o saldo, n∆o permite vincular outras provis‰es */
            &if defined(bf_fin_provisao) &then
                if  l-ant-ap.zera-saldo then next for-tit-ap.
            &else
                &if defined(bf_fin_provisao203) &then
                    if  can-find(first funcao where
                                       funcao.cd-funcao = "spp-provisao" and
                                       funcao.ativo     = yes ) then
                        if  l-ant-ap.zera-saldo then next for-tit-ap.
                &endif.
            &endif.
 
            if  tit-ap.moeda = 0 then
                assign de-valor-provisao = de-valor-provisao + decimal(l-ant-ap.vl-antecip).
            else 
                assign de-valor-provisao = de-valor-provisao + decimal(l-ant-ap.vl-antecip-me).
        end.
    
        if de-valor-provisao >= tit-ap.vl-original then next.
        
        assign de-valor-provisao = tit-ap.vl-original - de-valor-provisao.
        
        run utp/ut-msgs.p (input "show", input {2}, input tit-ap.cod-fornec).
        if  return-value = 'yes' then do:
            if  l-provisao then
                run app/ap0555.w (input yes, input rowid(lin-i-ap),10).
            return.
        end.
        else
            leave.
   end.
end.

/* Fim de Include */
