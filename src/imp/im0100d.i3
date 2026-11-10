FOR EACH tt-ordens-desemb exclusive-lock
    BREAK BY tt-ordens-desemb.cdn-adicao
          BY tt-ordens-desemb.c-un
          BY tt-ordens-desemb.c-nat-fiscal:
    
    IF  FIRST-OF(tt-ordens-desemb.cdn-adicao) OR
        FIRST-OF(tt-ordens-desemb.c-un)       OR  
        FIRST-OF(tt-ordens-desemb.c-nat-fiscal) THEN DO:
        CREATE tt-ordens-desemb-acum-adicao.
        BUFFER-COPY tt-ordens-desemb TO tt-ordens-desemb-acum-adicao.
        ASSIGN de-qtde-acum        = 0
               de-qt-do-forn-acum  = 0
               de-quantidade-acum  = 0.
    END.
    
    FIND FIRST item
         WHERE item.it-codigo = tt-ordens-desemb.c-it-codigo NO-LOCK NO-ERROR.
    FIND FIRST classif-fisc
         where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.

    IF tt-ordens-desemb.c-un <> classif-fisc.unidade THEN
        ASSIGN de-qtde-acum        = de-qtde-acum        + tt-ordens-desemb.quantidade
               de-qt-do-forn-acum  = de-qt-do-forn-acum  + tt-ordens-desemb.qt-do-forn
               de-quantidade-acum  = de-quantidade-acum  + (tt-ordens-desemb.de-quantidade / item.fator-conver).
               
    ELSE
        ASSIGN de-qtde-acum        = de-qtde-acum        + tt-ordens-desemb.quantidade
               de-qt-do-forn-acum  = de-qt-do-forn-acum  + tt-ordens-desemb.qt-do-forn
               de-quantidade-acum  = de-quantidade-acum  + tt-ordens-desemb.de-quantidade.
   
    
    
    IF LAST-OF(tt-ordens-desemb.cdn-adicao) THEN DO:
        ASSIGN tt-ordens-desemb-acum-adicao.quantidade       = de-qtde-acum
               tt-ordens-desemb-acum-adicao.qt-do-forn       = de-qt-do-forn-acum
               tt-ordens-desemb-acum-adicao.de-quantidade    = de-quantidade-acum.
               
        IF tt-ordens-desemb.c-un <> classif-fisc.unidade THEN 
            ASSIGN tt-ordens-desemb-acum-adicao.c-un             = classif-fisc.unidade.           
               
    END.
               
END.
