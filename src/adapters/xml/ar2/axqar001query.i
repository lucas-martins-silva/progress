     /*Faixa  Inicial*/

     IF tt-parametros.it-codigo-ini      = ? THEN ASSIGN   tt-parametros.it-codigo-ini     = "".
     IF tt-parametros.fm-codigo-ini      = ? THEN ASSIGN   tt-parametros.fm-codigo-ini     = "".
     IF tt-parametros.gr-estoque-ini     = ? THEN ASSIGN   tt-parametros.gr-estoque-ini    = 0 .
     IF tt-parametros.c-estabel-ini      = ? THEN ASSIGN   tt-parametros.c-estabel-ini     = "".
     IF tt-parametros.l-mediobatch       = ? THEN ASSIGN   tt-parametros.l-mediobatch      = NO.
     IF tt-parametros.l-medioOnline      = ? THEN ASSIGN   tt-parametros.l-medioOnline     = NO.
     IF tt-parametros.l-padrao           = ? THEN ASSIGN   tt-parametros.l-padrao          = NO.
     IF tt-parametros.l-base             = ? THEN ASSIGN   tt-parametros.l-base            = NO. 
     IF tt-parametros.l-fiscal           = ? THEN ASSIGN   tt-parametros.l-fiscal          = NO.
     IF tt-parametros.l-reposicao        = ? THEN ASSIGN   tt-parametros.l-reposicao       = NO.
     IF tt-parametros.l-ultEntrada       = ? THEN ASSIGN   tt-parametros.l-ultEntrada      = NO.
     IF tt-parametros.l-consignado       = ? THEN ASSIGN   tt-parametros.l-consignado      = NO.
     IF tt-parametros.l-debito-direto    = ? THEN ASSIGN   tt-parametros.l-debito-direto   = NO.
     IF tt-parametros.l-fisico           = ? THEN ASSIGN   tt-parametros.l-fisico          = NO.
     IF tt-parametros.l-total            = ? THEN ASSIGN   tt-parametros.l-total           = NO.
     IF tt-parametros.i-tipo-obsoleto    = ? THEN ASSIGN   tt-parametros.i-tipo-obsoleto   = 1.
     
     
     /*Faixa Final*/
     ASSIGN  tt-parametros.it-codigo-fim        = IF tt-parametros.it-codigo-fim     = ? 
                                                  OR tt-parametros.it-codigo-fim     = "" THEN  
                                                     "ZZZZZZZZZZZZZZZZ"
                                                  ELSE  
                                                      tt-parametros.it-codigo-fim  
    
             tt-parametros.fm-codigo-fim        = IF tt-parametros.fm-codigo-fim     = ? 
                                                  OR tt-parametros.fm-codigo-fim     = "" THEN 
                                                     "ZZZZZZZZ"
                                                  ELSE
                                                      tt-parametros.fm-codigo-fim
    
             tt-parametros.gr-estoque-fim       = IF tt-parametros.gr-estoque-fim    = ? 
                                                  OR tt-parametros.gr-estoque-fim    = 0 THEN
                                                      99
                                                   ELSE
                                                       tt-parametros.gr-estoque-fim
    
             tt-parametros.c-estabel-fim           = IF tt-parametros.c-estabel-fim  = ? 
                                                   OR tt-parametros.c-estabel-fim    = "" THEN
                                                      "ZZZ"
                                                   ELSE
                                                       tt-parametros.c-estabel-fim.
    

     IF tt-parametros.dt-trans-ini = ? AND (tt-parametros.it-codigo-ini = tt-parametros.it-codigo-fim) THEN
        ASSIGN tt-parametros.dt-trans-ini = DATE("01/01/1900":U).
     ELSE IF tt-parametros.dt-trans-ini = ? THEN
        ASSIGN tt-parametros.dt-trans-ini = DATE("01/":U + STRING( MONTH(TODAY),"99":U) + "/" + STRING(YEAR(TODAY),"9999":U)).

     IF tt-parametros.dt-trans-fim = ? THEN
        ASSIGN tt-parametros.dt-trans-fim = TODAY. 
    
     RUN cep/ceapi023.p (INPUT TABLE  tt-parametros,
                         OUTPUT TABLE tt-item,
                         OUTPUT TABLE tt-item-estab,  
                         OUTPUT TABLE tt-saldo-custo).

        
