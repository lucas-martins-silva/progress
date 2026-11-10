/********************************************************************************
***
*** app/apapi018.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-param NO-UNDO
    field cod-versao-integracao as integer format "999"
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo 
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field estabel          like tit-ap.cod-estabel
    field espec            like tit-ap.cod-esp
    field serie-ini        like tit-ap.serie
    field serie-fim        like tit-ap.serie
    field docto-ini        like tit-ap.nr-docto
    field docto-fim        like tit-ap.nr-docto
    field parc-ini         like tit-ap.parcela
    field parc-fim         like tit-ap.parcela
    field forn-ini         like tit-ap.cod-fornec
    field forn-fim         like tit-ap.cod-fornec
    field emis-ini         like tit-ap.dt-emissao
    field emis-fim         like tit-ap.dt-emissao
    field ref-ini          like tit-ap.referencia
    field ref-fim          like tit-ap.referencia
    field elimina-ir       as log
    field elimina-iss      as log
    field elimina-estoque  as log
    field elimina-movto    as log
    field l-multiplanta    as log
    field cod-maq-origem   as int format "9999"
    field num-processo     as int format ">>>>>>>>9" initial 0
    field num-sequencia    as int format ">>>>>9"    initial 0
    field ind-tipo-movto   as int format "99"        initial 1.
 
def temp-table tt-tit-ap NO-UNDO
    field ep-codigo     like tit-ap.ep-codigo
    field cod-fornec    like tit-ap.cod-fornec
    field cod-estabel   like tit-ap.cod-estabel
    field cod-esp       like tit-ap.cod-esp
    field serie         like tit-ap.serie
    field nr-docto      like tit-ap.nr-docto
    field parcela       like tit-ap.parcela
    field vl-original   like tit-ap.vl-original
    field valor-saldo   like tit-ap.valor-saldo
    field cod-maq-origem as  int format "9999"
    field num-processo   as  int format ">>>>>>>>9" initial 0
    field num-sequencia  as  int format ">>>>>9"    initial 0
    field ind-tipo-movto as  int format "99"        initial 1     
    INDEX codigo IS PRIMARY ep-codigo
                            cod-fornec
                            cod-estabel
                            cod-esp
                            serie
                            nr-docto
                            parcela.

def temp-table tt-retorno-erro NO-UNDO
    field ep-codigo         like tit-ap.ep-codigo
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field cod-fornec        like tit-ap.cod-fornec
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-erro          as integer     format ">>>>>>>>9"
    field desc-erro         as character   format "x(80)"
    INDEX codigo IS PRIMARY ep-codigo
                            cod-estabel
                            cod-esp
                            serie
                            cod-fornec
                            nr-docto
                            parcela.
            
/* Fim de Include */
