/***************************************************************************
**
** AP1001G.i3
** Objetivo: Trailler Banco Banrisul
**
***************************************************************************/

/* Considera Header de Lote e Trailler de Lote */
assign i-num-reg = i-num-reg + 2.

/*--------------------- TRAILLER DE LOTE - TIPO "5" ----------------------*/
put stream relat
    "041"                                                             at 001
    "0001"                                                            at 004    
    "5"                                                               at 008
    i-num-reg                                         format "999999" at 018
    de-vl-acum-pago                       format "999999999999999999" at 024
    "000000000000000000"                                              at 042
    c-branco                                  format "x(181)"         at 060
    skip.

/* Considera Header de Arquivo e Trailler de Arquivo */
assign i-num-reg = i-num-reg + 2.

/*--------------------- TRAILLER DE ARQUIVO - TIPO "9" -------------------*/
put stream relat
    "041"                                                             at 001
    "9999"                                                            at 004
    "9"                                                               at 008
    "000001"                                                          at 018
    i-num-reg                                         format "999999" at 024
    "000000"                                                          at 030
    c-branco                                    format "x(205)"       at 036
    skip.

/* ap1001g.i3 */
