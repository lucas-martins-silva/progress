 /*faixa inicial*/
  IF tt-parametros.c-it-codigo-ini      = ? THEN ASSIGN tt-parametros.c-it-codigo-ini   = "".
  IF tt-parametros.c-cod-estab-ini      = ? THEN ASSIGN tt-parametros.c-cod-estab-ini   = "".
  IF tt-parametros.c-cod-refer-ini      = ? THEN ASSIGN tt-parametros.c-cod-refer-ini   = "".
  IF tt-parametros.c-cod-depos-ini      = ? THEN ASSIGN tt-parametros.c-cod-depos-ini   = "".
  IF tt-parametros.c-cod-lote-ini       = ? THEN ASSIGN tt-parametros.c-cod-lote-ini    = "".
  IF tt-parametros.c-cod-localiz-ini    = ? THEN ASSIGN tt-parametros.c-cod-localiz-ini = "".
  IF tt-parametros.c-cod-esp-ini        = ? THEN ASSIGN tt-parametros.c-cod-esp-ini     = "".
  IF tt-parametros.c-serie-ini          = ? THEN ASSIGN tt-parametros.c-serie-ini       = "".
  IF tt-parametros.c-nro-docto-ini      = ? THEN ASSIGN tt-parametros.c-nro-docto-ini   = "".
  if tt-parametros.i-nr-trans-ini       = ? then assign tt-parametros.i-nr-trans-ini    = 0.
  if tt-parametros.i-nr-trans-fim       = ? then assign tt-parametros.i-nr-trans-fim    = 0.
 
 
 /*Faixa final*/
 ASSIGN tt-parametros.c-it-codigo-fim   = IF   tt-parametros.c-it-codigo-fim  = ? 
                                          OR   tt-parametros.c-it-codigo-fim  = "" THEN  
                                               if tt-parametros.c-it-codigo-ini = "" then 
                                                   "ZZZZZZZZZZZZZZZZ":u
                                               else
                                                   tt-parametros.c-it-codigo-ini
                                          ELSE 
                                               tt-parametros.c-it-codigo-fim

        tt-parametros.c-cod-estab-fim   = IF   tt-parametros.c-cod-estab-fim  = ?
                                          OR   tt-parametros.c-cod-estab-fim  = "" THEN 
                                               if tt-parametros.c-cod-estab-ini = "" then
                                                  &IF "{&mguni_version}":u >= "2.071":u &THEN "ZZZZZ":u &else "ZZZ":u &endif
                                               else
                                                   tt-parametros.c-cod-estab-ini
                                          ELSE
                                               tt-parametros.c-cod-estab-fim
                                      
        tt-parametros.c-cod-refer-fim   = IF   tt-parametros.c-cod-refer-fim = ?
                                          OR   tt-parametros.c-cod-refer-fim = ""  THEN
                                               if tt-parametros.c-cod-refer-ini = "" then
                                                   "ZZZZZZZZ":u
                                               else
                                                   tt-parametros.c-cod-refer-ini
                                          ELSE
                                               tt-parametros.c-cod-refer-fim

        tt-parametros.c-cod-depos-fim   = IF   tt-parametros.c-cod-depos-fim = ?
                                          OR   tt-parametros.c-cod-depos-fim = ""  THEN
                                               if tt-parametros.c-cod-depos-ini = "" then
                                                   "ZZZ":u
                                               else
                                                   tt-parametros.c-cod-depos-ini
                                          ELSE 
                                                tt-parametros.c-cod-depos-fim

        tt-parametros.c-cod-lote-fim    = IF   tt-parametros.c-cod-lote-fim  = ?
                                          OR   tt-parametros.c-cod-lote-fim  = ""  THEN
                                               if tt-parametros.c-cod-lote-ini = "" then
                                                   "ZZZZZZZZZZ":u
                                               else
                                                   tt-parametros.c-cod-lote-ini
                                          ELSE
                                               tt-parametros.c-cod-lote-fim

        tt-parametros.c-cod-localiz-fim = IF   tt-parametros.c-cod-localiz-fim = ?
                                          OR   tt-parametros.c-cod-localiz-fim = ""  THEN
                                               if tt-parametros.c-cod-localiz-ini = "" then
                                                   "ZZZZZZZZZZ":u
                                               else
                                                   tt-parametros.c-cod-localiz-ini
                                          ELSE 
                                               tt-parametros.c-cod-localiz-fim

        tt-parametros.c-cod-esp-fim     = IF   tt-parametros.c-cod-esp-fim     = ? 
                                          OR   tt-parametros.c-cod-esp-fim     = "" THEN 
                                               if tt-parametros.c-cod-esp-ini = "" then
                                                   "99":u
                                               else
                                                   tt-parametros.c-cod-esp-ini
                                          ELSE
                                               tt-parametros.c-cod-esp-fim

        tt-parametros.c-serie-fim       = IF   tt-parametros.c-serie-fim       = ?
                                          OR   tt-parametros.c-serie-fim       = "" THEN
                                               if tt-parametros.c-serie-ini = "" then
                                                   "ZZZZZ":u
                                               else
                                                   tt-parametros.c-serie-ini
                                          ELSE
                                               tt-parametros.c-serie-fim

        tt-parametros.c-nro-docto-fim   = IF   tt-parametros.c-nro-docto-fim   = ? 
                                          OR   tt-parametros.c-nro-docto-fim   = "" THEN 
                                               if tt-parametros.c-nro-docto-ini = "" then
                                                   "ZZZZZZZZZZZZZZZZ":u
                                               else
                                                   tt-parametros.c-nro-docto-ini
                                          ELSE
                                               tt-parametros.c-nro-docto-fim

        /* Data Transaá∆o. Quando n∆o informada considera data atual */
        tt-parametros.dt-trans-ini      = IF   tt-parametros.dt-trans-ini      = ? THEN
                                               TODAY
                                          ELSE 
                                               tt-parametros.dt-trans-ini

        tt-parametros.dt-trans-fim      = IF   tt-parametros.dt-trans-fim      = ? THEN
                                               TODAY
                                          ELSE 
                                              tt-parametros.dt-trans-fim.

RUN cep/ceapi020.p (INPUT  TABLE  tt-parametros,
                    OUTPUT TABLE  ttInventoryTransaction).
