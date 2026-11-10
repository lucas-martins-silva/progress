FOR EACH tt-ordens-desemb
    BREAK {1}
          BY tt-ordens-desemb.c-class-fiscal
          BY tt-ordens-desemb.c-un
          BY tt-ordens-desemb.c-nat-fiscal:
    
    IF  {2}
        FIRST-OF(tt-ordens-desemb.c-class-fiscal) OR
        FIRST-OF(tt-ordens-desemb.c-un)           OR  
        FIRST-OF(tt-ordens-desemb.c-nat-fiscal)   THEN DO:
        CREATE tt-ordens-desemb-acum.
        BUFFER-COPY tt-ordens-desemb TO tt-ordens-desemb-acum.
        ASSIGN de-qtde-acum        = 0
               de-qt-do-forn-acum  = 0
               de-quantidade-acum  = 0.
    END.
    ASSIGN de-qtde-acum        = de-qtde-acum        + tt-ordens-desemb.quantidade
           de-qt-do-forn-acum  = de-qt-do-forn-acum  + tt-ordens-desemb.qt-do-forn
           de-quantidade-acum  = de-quantidade-acum  + tt-ordens-desemb.de-quantidade.
    
    IF {3}
       LAST-OF(tt-ordens-desemb.c-class-fiscal) OR
       LAST-OF(tt-ordens-desemb.c-un) THEN
        ASSIGN tt-ordens-desemb-acum.quantidade       = de-qtde-acum
               tt-ordens-desemb-acum.qt-do-forn       = de-qt-do-forn-acum
               tt-ordens-desemb-acum.de-quantidade    = de-quantidade-acum.
END.
