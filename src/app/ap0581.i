/********************************************************************************
**   AP0585.i - Defini‡Æo da Temp-table TT-PARAM 
********************************************************************************/
&if '{&movadm_version}' >= '2.04' &then
    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field l-parametros     as logical 
        field ep-codigo        like tit-ap.ep-codigo
        field i-cod-fornec-ini like tit-ap.cod-fornec
        field i-cod-fornec-fim like tit-ap.cod-fornec
        field l-refaz-acum     like tit-ap.l-acum-ir
        field c-estab-ini      like tit-ap.cod-estab
        field c-estab-fim      like tit-ap.cod-estab
        field da-periodo-ini     as date
        field da-periodo-fim     as date  
        field i-retencao-ini   like tit-ap.cod-retencao
        field i-retencao-fimn  like tit-ap.cod-retencao.
&endif
