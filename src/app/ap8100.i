/*************************************************************************
**
** Include: ap8100.i - Vari veis comuns ao programa ap8100.p e aos
**                     programas que chamam este.
**
*************************************************************************/

def {1} shared var c-programa-ap8100     as char                    no-undo.
def {1} shared var c-prog-hist-ap8100    as char                    no-undo.
def {1} shared var c-include-ap8100      as char format "x(03)"     no-undo.
def {1} shared var c-esp-ini-ap8100      like espec-ap.cod-esp      no-undo.
def {1} shared var c-esp-fim-ap8100      like espec-ap.cod-esp      no-undo.
def {1} shared var c-est-ini-ap8100      like estabelec.cod-estabel no-undo.
def {1} shared var c-est-fim-ap8100      like estabelec.cod-estabel no-undo.
def {1} shared var i-port-ini-ap8100     like portador.cod-portador no-undo.
def {1} shared var i-port-fim-ap8100     like portador.cod-portador no-undo.
def {1} shared var c-refer-ini-ap8100    like mov-ap.referencia     no-undo.
def {1} shared var c-refer-fim-ap8100    like mov-ap.referencia     no-undo.
def {1} shared var da-ini-per-ap8100     like mov-ap.dt-transacao   no-undo.
def {1} shared var da-fim-per-ap8100     like mov-ap.dt-transacao   no-undo.
def {1} shared var de-diferenca          as decimal format "->>>,>>>,>>>,>>9.9999" no-undo.
def {1} shared var de-diferenca-fasb     like de-diferenca          no-undo.
def {1} shared var de-diferenca-cmi      like de-diferenca          no-undo.
def {1} shared var de-diferenca-presente like de-diferenca          no-undo.
def {1} shared var l-contabiliza-ap8100  as logical                 no-undo.
def {1} shared var l-ignora-gpf-ap8100   as logical                 no-undo.
def {1} shared var l-ignora-cmi-ap8100   as logical                 no-undo.
def {1} shared var l-quebra-ap8100       as logical                 no-undo.
def {1} shared var h-acomp               as handle                  no-undo.
def {1} shared var de-valor              like mov-ap.valor-mov      no-undo.
def {1} shared var c-controle            as char format "x(16)"     no-undo.
def {1} shared var i-lista               as integer                 no-undo.

/* ap8100.i */
