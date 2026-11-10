define temp-table tt-param no-undo
    FIELD ep-codigo        AS INTEGER
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD i-classificacao  AS INT
    FIELD c-estab-ini      AS CHAR
    FIELD c-estab-fim      AS CHAR
    FIELD i-fornec-ini     AS INTEGER FORMAT ">>>>>>>>9"
    FIELD i-fornec-fim     AS INTEGER FORMAT ">>>>>>>>9"
    FIELD i-grupo-ini      AS INTEGER
    FIELD i-grupo-fim      AS INTEGER
    FIELD i-retencao-ini   AS INTEGER
    FIELD i-retencao-fim   AS INTEGER
    FIELD l-normal         AS LOGICAL
    FIELD l-antecipacao    AS LOGICAL
    FIELD l-ir             AS LOGICAL
    FIELD l-pis            AS LOGICAL
    FIELD dt-data-ini      AS DATE
    FIELD dt-data-fim      AS DATE
    FIELD l-planilha       AS LOGICAL
    FIELD c-arq-planilha   AS CHAR
    FIELD c-caracter       AS CHAR
    FIELD l-resumo         AS LOG
    FIELD rs-origem-dados  AS INT
    FIELD origem           AS CHAR FORMAT "x(10)".

DEF temp-table tt-digita NO-UNDO
    FIELD cod-esp          LIKE espec-ap.cod-esp
    FIELD descricao        LIKE espec-ap.descricao
    FIELD tipo             AS CHAR FORMAT "x(25)" LABEL "Tipo Esp‚cie"
    FIELD log-sel          AS LOG
    INDEX espec cod-esp.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

DEF TEMP-TABLE tt-dirf-ap NO-UNDO LIKE dirf-ap
    FIELD nome-abrev LIKE emitente.nome-abrev
    FIELD de-rendto  AS DEC FORMAT ">>>>,>>>,>>9.99" LABEL "Rendto Tribut"
    FIELD id-titulo  AS ROWID
    FIELD id-dirf    AS ROWID
    FIELD dt-dia     AS INT
    FIELD dt-mes     AS INT
    FIELD dt-ano     AS INT
    FIELD origem     AS CHAR FORMAT "x(10)" COLUMN-LABEL "Origem"
    INDEX class1 cod-retensao
                 dt-ano
                 dt-mes
                 dt-dia
    INDEX class2 dt-ano 
                 dt-mes 
                 dt-dia
                 cod-retensao
    INDEX class3 cod-fornec  
                 dt-ano      
                 dt-mes      
                 dt-dia      
                 cod-retensao
    INDEX id id-titulo.

