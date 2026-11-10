/********************************************************************************
** Include   : acp/9003.i
** Data      : 14/10/1998
** Autor     : Datasul S.A.
** Versoes   : 2.00.000.00 
********************************************************************************/

find par-cota no-lock 
     where par-cota.cod-estabel = "{&cod-estabel}" no-error.
if avail par-cota then message string(par-cota.cod-estabel).
