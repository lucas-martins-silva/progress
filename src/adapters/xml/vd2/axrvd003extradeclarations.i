
{method/dbotterr.i} 
{cdp/cd9043.i1} 
{cdp/cdcfgdis.i}

/*  Defini‡Æo de vari veis */
def new global shared var iId  as integer   no-undo.
def var hQueryReturnContent as handle       no-undo. 
def var hNotify             as handle       no-undo. 
def var pTranAction         as character    no-undo.
def var cReturnValue        as character    no-undo.
def var iCount              as integer      no-undo.
def var cDiscount           as character    no-undo.
def var pSendSuccess        as log init yes no-undo.
def var pTotalErrors        as integer      no-undo.
def var c-nr-pedcli         as character    no-undo.
def var c-nome-abrev        as character    no-undo.
def var c-nome-ab-rep       as character    no-undo.
def var c-it-codigo         as character    no-undo.
def var c-cod-refer         as character    no-undo.
def var c-cod-classif       as character    no-undo.
def var i-nr-sequencia      as integer      no-undo.
def var i-nr-entrega        as integer      no-undo. 
def var i_cod_unid_negoc    as character    no-undo. 
def var i-nr-pedido         as integer      no-undo.
def var i-nr-pedido-crm     as integer      no-undo.
def var i-ind-fat-qtfam     as integer      no-undo.
def var i-cod-transp        as integer      no-undo.
def var c-hr-entrega        as character    no-undo.
def var c-conta-contabil    as character    no-undo.
def var c-custo-contabil    as character    no-undo.
def var c-class-fiscal      as character    no-undo.
def var c-val-desconto      as character    no-undo.
def var d-dt-entrega        as date         no-undo.
def var i-num-desconto      as integer      no-undo.
def var i-cod-transp-red    as integer      no-undo.
def var c-eanCode           as character    no-undo.
def var c-customerItemCode  as character    no-undo.
def var c-cgc               as character    no-undo.

{include/i-epc200.i axrvd003}

def temp-table tt-inform-adicional no-undo
    field seq as integer format '>>9'
    field inform as character format 'x(100)'.
