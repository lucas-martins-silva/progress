/****************************************************************
 * Valida‡Æo executada no in¡cio de cada adapter para verificar *
 * se o Neogrid eCS est  implantado.                            *
 ****************************************************************/
 
run utp/ut-neogrid.p.
if return-value = "NOK" then return. 
