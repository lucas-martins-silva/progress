/*********************************************************************************
**
**  apapi016.i
**
**  Defini‡Æo de temp-tableïs.
**
**********************************************************************************/
{cdp/cd0006.i1}
{app/ap9100.i}
{app/ap9100.i1}
{cdp/cd0666.i}

/*--- Defini‡Æo de Caba‡alho ---*/
{include/i-rpvar.i}
{include/i-rpcab.i}

/*************Multiplanta********************/
{cdp/cd7300.i1}
{app/apapi226.i}
assign c-transacao = "ADM085".
{cdp/cd7300.i5 "001" c-transacao}
/************Fim*****************************/

def temp-table tt-param-alt no-undo 
    field ep-codigo        like mov-ap.ep-codigo
    field r-mov-ap         as rowid
    field referencia       like mov-ap.referencia
    field dt-transacao     like mov-ap.dt-transacao
    field portador         like mov-ap.portador
    field cheque           like mov-ap.nr-cheque
    field var-monet        like mov-ap.vl-var-monet
    field valor-mov        like mov-ap.valor-mov-me
    field ped-rpw          as integer 
    field usuario          as char format "x(12)"
    field l-vid-rel        as logical
    field cod-versao-integ as int.

def temp-table tt-erro-alt no-undo
    field i-cod-erro        as int  format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".
