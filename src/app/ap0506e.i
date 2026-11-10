/********************************************************************************
***
*** app/ap0506e.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field portador         like mov-ap.portador
    field nr-bordero       like tit-ap.nr-bordero
    field dt-transacao     like mov-ap.dt-transacao
    field l-zera           as logical
    field l-retorna        as logical.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

def temp-table tt-raw-digita
    field raw-digita as raw.

def temp-table tt-estabel
    field cod-estabel as char.

def temp-table tt-docto
    field cod-estabel as char
    field row-docto   as rowid
    field row-movto   as rowid
    field l-ok        as logical initial yes.

def temp-table tt-erros no-undo
    field i-sequen as int              
    field cd-erro  as int
    field mensagem as char format "x(255)".
/* Fim de Include */

