/***************************************************************************
***
*** app/ap6001.i - TempTableïs utilizadas pelo Bloqueio.
***
***************************************************************************/

DEF TEMP-TABLE tt-retorno-bloqueio-ap NO-UNDO
    FIELD ep-codigo    LIKE tit-ap.ep-codigo  
    FIELD cod-estabel  LIKE tit-ap.cod-estabel
    FIELD cod-fornec   LIKE tit-ap.cod-fornec 
    FIELD cod-esp      LIKE tit-ap.cod-esp    
    FIELD serie        LIKE tit-ap.serie      
    FIELD nr-docto     LIKE tit-ap.nr-docto   
    FIELD parcela      LIKE tit-ap.parcela    
    FIELD referencia   LIKE tit-ap.referencia
    FIELD transacao    AS CHAR FORMAT "x(03)" LABEL "TRA"
    FIELD dt-transacao LIKE tit-ap.dt-transacao
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

DEF TEMP-TABLE tt-consiste-bloqueio-ap NO-UNDO
    FIELD ep-codigo     LIKE tit-ap.ep-codigo  
    FIELD cod-estabel   LIKE tit-ap.cod-estabel
    FIELD cod-fornec    LIKE tit-ap.cod-fornec 
    FIELD cod-esp       LIKE tit-ap.cod-esp    
    FIELD serie         LIKE tit-ap.serie      
    FIELD nr-docto      LIKE tit-ap.nr-docto   
    FIELD parcela       LIKE tit-ap.parcela    
    FIELD referencia    LIKE tit-ap.referencia
    FIELD dt-transacao  LIKE tit-ap.dt-transacao
    FIELD num-id-mov-ap LIKE mov-ap.num-id-mov-ap
    INDEX codigo ep-codigo 
                 cod-estabel 
                 cod-fornec 
                 cod-esp 
                 serie 
                 nr-docto 
                 parcela.
