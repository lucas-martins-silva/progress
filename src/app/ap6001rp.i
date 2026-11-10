FORM tt-retorno-bloqueio-ap.ep-codigo
     tt-retorno-bloqueio-ap.cod-est
     tt-retorno-bloqueio-ap.cod-esp
     tt-retorno-bloqueio-ap.serie
     tt-retorno-bloqueio-ap.cod-forn
     tt-retorno-bloqueio-ap.nr-docto
     tt-retorno-bloqueio-ap.parcela
     tt-retorno-bloqueio-ap.num-erro  LABEL "Erro"
     tt-retorno-bloqueio-ap.desc-erro AS CHARACTER FORMAT "x(70)"                           
                                      VIEW-AS EDITOR MAX-CHARS 2000                         
                                      SCROLLBAR-VERTICAL SIZE 70 BY 2 LABEL "Descri‡Æo Erro"
     with width 200 no-box down stream-io frame f-detalhe.
