FIND FIRST tt-retorno-bordero
     WHERE tt-retorno-bordero.ep-codigo    = v-ep-codigo  
     AND   tt-retorno-bordero.cod-estabel  = v-cod-estabel
     AND   tt-retorno-bordero.cod-fornec   = v-cod-fornec 
     AND   tt-retorno-bordero.cod-esp      = v-cod-esp    
     AND   tt-retorno-bordero.serie        = v-serie      
     AND   tt-retorno-bordero.nr-docto     = v-nr-docto   
     AND   tt-retorno-bordero.parcela      = v-parcela
     AND   tt-retorno-bordero.num-erro     = {1}
     NO-ERROR.

IF  NOT AVAIL tt-retorno-bordero THEN DO:
    CREATE tt-retorno-bordero.
    ASSIGN tt-retorno-bordero.ep-codigo    = v-ep-codigo  
           tt-retorno-bordero.cod-estabel  = v-cod-estabel
           tt-retorno-bordero.cod-fornec   = v-cod-fornec 
           tt-retorno-bordero.cod-esp      = v-cod-esp    
           tt-retorno-bordero.serie        = v-serie      
           tt-retorno-bordero.nr-docto     = v-nr-docto   
           tt-retorno-bordero.parcela      = v-parcela
           tt-retorno-bordero.num-erro     = {1}
           tt-retorno-bordero.desc-erro    = {2}.
END.
