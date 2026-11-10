/************************************************************************
***
***  app/ap1002x.i3 - Identifica documentos do Magnus.
***
************************************************************************/
        
assign i-fornec-aux   = 0
       c-estabel-aux  = ""
       c-cod-esp-aux  = ""
       c-serie-aux    = ""
       i-numero-aux   = 0
       c-parcela-aux  = "".
                
if  right-trim(substr(c-linha1,08,1)) = "3" 
and right-trim(substr(c-linha1,14,1)) = "A" then  do:
        
    assign i-fornec-aux   =        int(substr(c-linha1,068,06))
           c-estabel-aux  = right-trim(substr(c-linha1,076,03))
           c-cod-esp-aux  = right-trim(substr(c-linha1,079,02))
           c-serie-aux    = right-trim(substr(c-linha1,081,03))
           i-numero-aux   =        int(substr(c-linha1,084,08))
           c-parcela-aux  = right-trim(substr(c-linha1,092,02)) no-error.
           
end.
        
if  right-trim(substr(c-linha1,08,1)) = "3" 
and right-trim(substr(c-linha1,14,1)) = "K" then do:
                
    if  substr(c-linha1,160,1) = "z" then do:
        if  lookup(substr(c-linha1, 153,1),c-numeros) = 0 then
            assign i-fornec-aux  =        int(substr(c-linha1,155,05))
                   c-estabel-aux = right-trim(substr(c-linha1,161,03)) no-error.
        else
            assign i-fornec-aux  =        int(substr(c-linha1,153,06))
                   c-estabel-aux = right-trim(substr(c-linha1,161,03)) no-error.
    end.
    else do:
        assign c-estabel-aux  = right-trim(substr(c-linha1,156,03))
               i-fornec-aux   =        int(substr(c-linha1,159,05)) no-error.
    end.
            
    assign c-cod-esp-aux  = right-trim(substr(c-linha1,164,02))
           c-serie-aux    = right-trim(substr(c-linha1,166,03))
           i-numero-aux   =        int(substr(c-linha1,169,08))
           c-parcela-aux  = right-trim(substr(c-linha1,177,02)) no-error.
           
end.

if  right-trim(substr(c-linha1,08,1)) = "3" 
and right-trim(substr(c-linha1,14,1)) = "J" then  do:
        
    assign i-fornec-aux   =        int(substr(c-linha1,086,06))
           c-estabel-aux  = right-trim(substr(c-linha1,185,03))
           c-cod-esp-aux  = right-trim(substr(c-linha1,188,02))
           c-serie-aux    = right-trim(substr(c-linha1,190,03))
           i-numero-aux   =        int(substr(c-linha1,193,08))
           c-parcela-aux  = right-trim(substr(c-linha2,001,02)) no-error.
           
end.

/* Fim de Include */
