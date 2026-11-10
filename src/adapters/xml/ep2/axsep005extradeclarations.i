DEF TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD dt-cancela   LIKE nota-fiscal.dt-cancela
    FIELD desc-cancela LIKE nota-fiscal.desc-cancela
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD serie        LIKE nota-fiscal.serie
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel
    INDEX ch-id IS PRIMARY UNIQUE cod-estabel serie nr-nota-fis.
