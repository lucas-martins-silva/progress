DEF {1} TEMP-TABLE tt-retorno-bordero NO-UNDO
    FIELD ep-codigo    LIKE tit-ap.ep-codigo  
    FIELD cod-estabel  LIKE tit-ap.cod-estabel
    FIELD cod-fornec   LIKE tit-ap.cod-fornec 
    FIELD cod-esp      LIKE tit-ap.cod-esp    
    FIELD serie        LIKE tit-ap.serie      
    FIELD nr-docto     LIKE tit-ap.nr-docto   
    FIELD parcela      LIKE tit-ap.parcela
    FIELD num-erro     AS INTEGER FORMAT ">>>>>>>>9" LABEL "Erro Interno"
    FIELD desc-erro    AS CHARACTER FORMAT "x(60)"        
                       VIEW-AS EDITOR MAX-CHARS 2000      
                       SCROLLBAR-VERTICAL SIZE 50 BY 4 LABEL "Descri‡Æo Erro"
    INDEX codigo ep-codigo 
                 cod-estabel 
                 cod-fornec 
                 cod-esp 
                 serie 
                 nr-docto 
                 parcela.

DEF {1} TEMP-TABLE tt-retorno-bordero1 NO-UNDO LIKE tt-retorno-bordero.

def {1} temp-table tt-bord-titulo no-undo 
    FIELD ep-codigo    LIKE bord-tit.ep-codigo
    FIELD cod-estabel  LIKE bord-tit.cod-estabel
    FIELD cod-fornec   LIKE bord-tit.cod-fornec
    FIELD cod-esp      LIKE bord-tit.cod-esp
    FIELD serie        LIKE bord-tit.serie
    FIELD nr-docto     LIKE bord-tit.nr-docto
    FIELD parcela      LIKE bord-tit.parcela
    FIELD nr-bordero   LIKE bord-tit.nr-bordero
    FIELD vl-saldo     LIKE bord-tit.vl-saldo
    INDEX codigo ep-codigo
                 cod-estabel
                 cod-fornec
                 cod-esp
                 serie
                 nr-docto
                 parcela
    INDEX bordero nr-bordero.

