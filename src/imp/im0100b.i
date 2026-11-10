FOR EACH tt-ordens-desemb
    BREAK {1}
          BY tt-ordens-desemb.c-class-fiscal
          BY tt-ordens-desemb.c-un:

    IF {2}
       FIRST-OF(tt-ordens-desemb.c-class-fiscal) OR
       FIRST-OF(tt-ordens-desemb.c-un) THEN DO:
        CREATE tt-ordens-desemb-acum.
        BUFFER-COPY tt-ordens-desemb TO tt-ordens-desemb-acum.
        ASSIGN de-qtde-acum              = 0
               de-qt-do-forn-acum        = 0
               de-quantidade-acum        = 0
               de-peso-bruto-unit-acum   = 0
               de-peso-bruto-acum        = 0
               de-peso-liquido-unit-acum = 0
               de-peso-liquido-acum      = 0.
    END.

    ASSIGN de-qtde-acum              = de-qtde-acum              + tt-ordens-desemb.quantidade
           de-qt-do-forn-acum        = de-qt-do-forn-acum        + tt-ordens-desemb.qt-do-forn
           de-quantidade-acum        = de-quantidade-acum        + tt-ordens-desemb.de-quantidade
           de-peso-bruto-unit-acum   = de-peso-bruto-unit-acum   + tt-ordens-desemb.de-peso-bruto-unit
           de-peso-bruto-acum        = de-peso-bruto-acum        + tt-ordens-desemb.de-peso-bruto
           de-peso-liquido-unit-acum = de-peso-liquido-unit-acum + tt-ordens-desemb.de-peso-liquido-unit
           de-peso-liquido-acum      = de-peso-liquido-acum      + tt-ordens-desemb.de-peso-liquido.
    
    IF {3}
       LAST-OF(tt-ordens-desemb.c-class-fiscal) OR
       LAST-OF(tt-ordens-desemb.c-un) THEN
        ASSIGN tt-ordens-desemb-acum.quantidade           = de-qtde-acum
               tt-ordens-desemb-acum.qt-do-forn           = de-qt-do-forn-acum
               tt-ordens-desemb-acum.de-quantidade        = de-quantidade-acum  
               tt-ordens-desemb-acum.de-peso-bruto-unit   = de-peso-bruto-unit-acum
               tt-ordens-desemb-acum.de-peso-bruto        = de-peso-bruto-acum  
               tt-ordens-desemb-acum.de-peso-liquido-unit = de-peso-liquido-unit-acum
               tt-ordens-desemb-acum.de-peso-liquido      = de-peso-liquido-acum.
END.
