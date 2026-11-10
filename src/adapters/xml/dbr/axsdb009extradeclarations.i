DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/**** oper-pad -> op-pad-dbr ***/
define new shared temp-table tt-op-pad-dbr no-undo
    field nr-oper-pad       as integer
    field descricao         as character
    index codigo            is primary unique nr-oper-pad.
