DEFINE TEMP-TABLE tt-saldo-embarque NO-UNDO
    FIELD numero-ordem      LIKE ordens-embarque.numero-ordem
    FIELD parcela           LIKE ordens-embarque.parcela
    FIELD it-codigo         LIKE prazo-compra.it-codigo
    FIELD quantidade        LIKE ordens-embarque.quantidade
    FIELD quant-receb       LIKE prazo-compra.quant-receb
    FIELD quant-rejeit      LIKE prazo-compra.quant-rejeit
    FIELD quant-saldo       LIKE prazo-compra.dec-1
    FIELD quant-alocada     LIKE prazo-compra.dec-1
    FIELD situacao          LIKE prazo-compra.situacao
    FIELD r-rowid           AS ROWID
    INDEX parcela IS PRIMARY UNIQUE numero-ordem parcela
    INDEX ordem numero-ordem
    INDEX it it-codigo.
