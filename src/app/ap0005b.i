/********************************************************************************
**
** app/ap0005b.i - Include de Definicao das tabelas temporarias.
**
********************************************************************************/
def temp-table tt-cod-barras no-undo   
    field cod-barras            like tit-ap.cod-barras
    field log-leitora           as logical
    field log-informacoes       as logical
    field log-gerar-digito-age  as logical
    field log-gerar-digito-cta  as logical
    field log-gerar-nosso-num   as logical
    field cod-barras-01         as char format "99999.99999"  initial "0000000000"
    field cod-barras-02         as char format "99999.999999" initial "00000000000"
    field cod-barras-03         as char format "99999.999999" initial "00000000000"
    field cod-barras-05         as char format "x(14)"
    field cod-barras-dv         as integer format "9" 
    field cod-banco             like cta-corrente.cod-banco
    field cod-agencia           like cta-corrente.agencia 
    field conta-corren          like cta-corrente.conta-corren
    field titulo-banco          like tit-ap.titulo-banco /* Nosso Numero */
    field valor-docto           like tit-ap.vl-orig-me
    field r-rowid               as rowid
    field l-vid-rel             as logical.

/* Fim app/ap0005b.i */
