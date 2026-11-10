/************************************************************************
***
*** app/ap0531rp.i - Defini‡Æo form's e vari veis.
***
************************************************************************/

find first param-global no-lock no-error.

def buffer b-tit-ap   for tit-ap.
def buffer b-dirf-apf for dirf-apf.

def buffer b-mov-ap   for mov-ap.
def buffer b1-mov-ap  for mov-ap.
def buffer b2-mov-ap  for mov-ap.

def var de-valor-ava      as decimal no-undo.
def var de-sub-bruta      as decimal no-undo.
def var de-valor-subtrair as decimal no-undo.

def var de-forn-no        like tit-ap.vl-original     no-undo.
def var de-forn-ir        like tit-ap.vl-original     no-undo.
def var de-forn-deducoes  like tit-ap.vl-original     no-undo.
def var de-tit-deducoes   like tit-ap.vl-original     no-undo.
def var de-tot-no         like tit-ap.vl-original     no-undo.
def var de-tot-ir         like tit-ap.vl-original     no-undo.
def var de-tot-deducoes   like tit-ap.vl-original     no-undo.
def var i-cod-ret         like dirf-apf.cod-retencao  no-undo.
def var i-mes             as integer                  no-undo.
def var i-ano             as integer                  no-undo.
def var da-ini            as date                     no-undo.
def var da-fim            as date                     no-undo.
def var l-primeiro        as logical init no          no-undo.
def var l-gera-zero       as logical format "Sim/NÆo" no-undo.
def var l-possui-ir       as logical                  no-undo.
def var h-acomp           as handle                   no-undo.
def var dt-ano-base       like dirf-apf.ano-base      no-undo.

form
    space(05)
    tit-ap.cod-estabel
    tit-ap.cod-esp    space(2)
    tit-ap.serie
    tit-ap.nr-docto   space(0) "/" space(0)
    tit-ap.parcela
    tit-ap.dt-emissao
    tit-ap.dt-transacao
    tit-ap.dt-vencto-ori
    tit-ap.referencia space(4)
    i-cod-ret
    tit-ap.vl-original
    tit-ap.valor-ir skip
    de-tit-deducoes to 122
    with no-box no-labels no-attr-space width 132 down stream-io frame f-lin-tit.

form
    "Est Esp Ser   Docto           /P  Dt.Emissao Dt.Trans   Dt.Vencto  Referencia " at 05
    "Cod.Ret       Vl. Imposto    Rend.Tributavel" skip
    "                                                                              " at 05
    "                             Outras Deducoes" skip
    "--------------------------------------------------------------------" at 05
    space(0)
    "-------------------------------------------------------" skip
    with page-top no-box no-labels no-attr-space width 132 stream-io frame f-cab-tit.

form
    "Fornecedor:" at 10
                  emitente.cod-emitente
    "-"           emitente.nome-abrev
    "-"           emitente.cgc
    "-"           emitente.nome-emit skip
    with no-box no-labels no-attr-space width 132 stream-io frame f-cab-forn.

assign emitente.cgc:format in frame f-cab-forn = param-global.formato-id-pessoal.

/* Fim de Include */
