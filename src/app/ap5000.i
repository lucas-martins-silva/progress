def temp-table tt-param no-undo
    field ep-codigo          as integer
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    FIELD i-exportacao       AS INTEGER
    field da-emissao-ini     as date    format "99/99/9999"
    field da-emissao-fim     as date    format "99/99/9999"
    field da-vencimento-ini  as date    format "99/99/9999"
    field da-vencimento-fim  as date    format "99/99/9999"
    field i-opcao            as integer
    field diretorio-saida    as char    format "x(80)"
    field diretorio-entrada  as char    format "x(80)"
    field c-cod-est-ini      as character
    field c-cod-est-fim      as character
    field c-cod-esp-ini      as character
    field c-cod-esp-fim      as character
    field c-serie-ini        as character
    field c-serie-fim        as character
    field c-emitente-ini     as INTEGER FORMAT ">>>>>>>>9"
    field c-emitente-fim     as INTEGER FORMAT ">>>>>>>>9"
    FIELD i-bordero-ini      AS INTEGER FORMAT ">>>>>>>>9"
    FIELD i-bordero-fim      AS INTEGER FORMAT ">>>>>>>>9"
    field c-nr-docto-ini     as character
    field c-nr-docto-fim     as character
    field c-parcela-ini      as character
    field c-parcela-fim      as CHARACTER
    FIELD i-portador         AS INTEGER
    FIELD c-escritural       AS CHAR
    FIELD c-cod-estabel      AS CHAR
    FIELD c-cod-refer        AS CHAR
    FIELD i-nr-bordero       AS INTEGER.

def temp-table tt-digita no-undo
    field codigo  as integer   format ">>>>9".

def temp-table tt-raw-digita NO-UNDO
    field raw-digita      as raw.
 
