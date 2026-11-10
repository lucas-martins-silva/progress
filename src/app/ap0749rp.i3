/******************************************************************************
***
*** app/ap0749rp.i3 - Form's
***
******************************************************************************/

form 
     tt-mov-ap.dt-transacao        format "99/99/9999"             column-label "Dt-Trans"                 
     tt-mov-ap.cod-estabel         format "x(3)"                  
     tt-mov-ap.cod-fornec          format ">>>>>>>>9"                   
     tt-mov-ap.nome-abrev          format "X(12)"                  column-label "Nom-Abrev"            
     tt-mov-ap.cod-esp             format "!!"                    
     tt-mov-ap.serie               format "x(5)"                   column-label "Ser"           
     tt-mov-ap.nr-docto            format "x(16)"                  column-label "Docto"           
     tt-mov-ap.parcela             format "x(02)"      
     tt-mov-ap.dt-vencimen         format "99/99/9999"             column-label "Dt-Venc"           
     tt-mov-ap.referencia          format "x(10)"                  column-label "Refer"           
     tt-mov-ap.transacao           format ">9"                     column-label "Tr"          
     tt-mov-ap.origem              format ">9"                     column-label "Or"           
     tt-mov-ap.valor-mov           format "->>>>>>,>>>,>>9.99"     column-label "Vl-Movto"
        with width 132 no-box page-top stream-io frame f-cabec-1.

form 
     tt-mov-ap.dt-transacao        format "99/99/9999"             column-label "Dt-Trans"                 
     tt-mov-ap.cod-estabel         format "x(3)"                  
     tt-mov-ap.cod-fornec          format ">>>>>>>>9"                   
     tt-mov-ap.nome-abrev          format "X(12)"                  column-label "Nom-Abrev"            
     tt-mov-ap.cod-esp             format "!!"                    
     tt-mov-ap.serie               format "x(5)"                   column-label "Ser"           
     tt-mov-ap.nr-docto            format "x(16)"                  column-label "Docto"           
     tt-mov-ap.parcela             format "x(02)"      
     tt-mov-ap.dt-vencimen         format "99/99/9999"             column-label "Dt-Venc"           
     tt-mov-ap.referencia          format "x(10)"                  column-label "Refer"           
     tt-mov-ap.transacao           format ">9"                     column-label "Tr"          
     tt-mov-ap.origem              format ">9"                     column-label "Or"           
     tt-mov-ap.valor-mov           format "->>>>>>,>>>,>>9.99"     column-label "Vl-Movto"
     de-vl-liquido                 format "->>>>>>>>,>>9.99"       column-label "Vl Liquido" to 132
        with width 132 no-box page-top stream-io frame f-cabec-2.

form 
     tt-mov-ap.dt-transacao        format "99/99/9999"             /*at 003*/
     tt-mov-ap.cod-estabel         format "x(3)"                   /*at 016*/
     tt-mov-ap.cod-fornec          format ">>>>>>>>9"              /*at 020*/
     tt-mov-ap.nome-abrev          format "X(12)"                  /*at 030*/
     tt-mov-ap.cod-esp             format "!!"                     /*at 045*/
     tt-mov-ap.serie               format "x(5)"                     at 043 
     tt-mov-ap.nr-docto            format "x(16)"                    at 049 
     tt-mov-ap.parcela             format "x(02)"                    at 066 
     tt-mov-ap.dt-vencimen         format "99/99/9999"               at 069 
     tt-mov-ap.referencia          format "x(10)"                    at 080 
     tt-mov-ap.transacao           format ">9"                       at 091 
     tt-mov-ap.origem              format ">9"                       at 094  
     tt-mov-ap.valor-mov           format "->>>>>>,>>>,>>9.99"       at 097 
        with down width 132 no-box no-label stream-io frame f-det-1.   

form 
     tt-mov-ap.dt-transacao        format "99/99/9999"             /*at 003*/
     tt-mov-ap.cod-estabel         format "x(3)"                   /*at 016*/
     tt-mov-ap.cod-fornec          format ">>>>>>>>9"              /*at 020*/
     tt-mov-ap.nome-abrev          format "X(12)"                  /*at 030*/
     tt-mov-ap.cod-esp             format "!!"                     /*at 045*/
     tt-mov-ap.serie               format "x(5)"                     at 043
     tt-mov-ap.nr-docto            format "x(16)"                    at 049 
     tt-mov-ap.parcela             format "x(02)"                    at 066 
     tt-mov-ap.dt-vencimen         format "99/99/9999"               at 069 
     tt-mov-ap.referencia          format "x(10)"                    at 080 
     tt-mov-ap.transacao           format ">9"                       at 091 
     tt-mov-ap.origem              format ">9"                       at 094  
     tt-mov-ap.valor-mov           format "->>>>>>,>>>,>>9.99"       at 097 
     de-vl-liquido                 format "->>>>>>>>>,>>9.99"        at 116
        with down width 132 no-box no-label stream-io frame f-det-2.   

form    
     c-par                     no-label
     skip
     tt-param.l-tit-subs   format "Sim/NÆo" colon 20
     skip
     tt-param.l-nota-db-cr format "Sim/NÆo" colon 20
     skip
     tt-param.c-origem     format "x(30)"   colon 20
     skip(2)
     c-sel                      no-label
     tt-param.cod-estabel-ini               colon 20 
     "|< >|"                                at 44 
     tt-param.cod-estabel-fin   no-label
     tt-param.cod-esp-ini                   colon 20 
     "|< >|"                                at 44 
     tt-param.cod-esp-fin       no-label
     tt-param.cod-emitente-ini              colon 20 
     "|< >|"                                at 44 
     tt-param.cod-emitente-fin  no-label
     tt-param.dt-trans-ini                  colon 20 
     "|< >|"                                at 44 
     tt-param.dt-trans-fin      no-label
     tt-param.dt-venci-ini                  colon 20 
     "|< >|"                                at 44 
     tt-param.dt-venci-fin      no-label
     skip(2)
     c-cla                      no-label
     skip
     c-cla-2                    no-label 
     skip(2)
     c-imp                      no-label
     c-destino                              colon 20  
     tt-param.arquivo                       colon 20   
     tt-param.usuario                       colon 20                                            
        with stream-io no-box width 132 side-labels frame f-imp-par.
                
&if "{&mgadm_version}" < "2.06b" &then
  IF l-selec-ref THEN do:
    form    
         c-par                     no-label
         skip
         tt-param.l-tit-subs   format "Sim/NÆo" colon 20
         skip
         tt-param.l-nota-db-cr format "Sim/NÆo" colon 20
         skip
         tt-param.c-origem     format "x(30)"   colon 20
         skip(2)
         c-sel                      no-label
         tt-param.cod-estabel-ini               colon 20 
         "|< >|"                                at 44 
         tt-param.cod-estabel-fin   no-label
         tt-param.cod-esp-ini                   colon 20 
         "|< >|"                                at 44 
         tt-param.cod-esp-fin       no-label
         tt-param.cod-emitente-ini              colon 20 
         "|< >|"                                at 44 
         tt-param.cod-emitente-fin  no-label
         tt-param.dt-trans-ini                  colon 20 
         "|< >|"                                at 44 
         tt-param.dt-trans-fin      no-label
         tt-param.dt-venci-ini                  colon 20 
         "|< >|"                                at 44 
         tt-param.dt-venci-fin      no-label
         tt-param.referencia-ini                colon 20
         "|< >|"                                at 44 
         tt-param.referencia-fim    no-label
         skip(2)
         c-cla                      no-label
         skip
         c-cla-2                    no-label 
         skip(2)
         c-imp                      no-label
         c-destino                              colon 20  
         tt-param.arquivo                       colon 20   
         tt-param.usuario                       colon 20                                            
            with stream-io no-box width 132 side-labels frame f-imp-par-2.  
  end.
&else 
  form    
       c-par                     no-label
       skip
       tt-param.l-tit-subs   format "Sim/NÆo" colon 20
       skip
       tt-param.l-nota-db-cr format "Sim/NÆo" colon 20
       skip
       tt-param.c-origem     format "x(30)"   colon 20
       skip(2)
       c-sel                      no-label
       tt-param.cod-estabel-ini               colon 20 
       "|< >|"                                at 44 
       tt-param.cod-estabel-fin   no-label
       tt-param.cod-esp-ini                   colon 20 
       "|< >|"                                at 44 
       tt-param.cod-esp-fin       no-label
       tt-param.cod-emitente-ini              colon 20 
       "|< >|"                                at 44 
       tt-param.cod-emitente-fin  no-label
       tt-param.dt-trans-ini                  colon 20 
       "|< >|"                                at 44 
       tt-param.dt-trans-fin      no-label
       tt-param.dt-venci-ini                  colon 20 
       "|< >|"                                at 44 
       tt-param.dt-venci-fin      no-label
       tt-param.referencia-ini                colon 20
       "|< >|"                                at 44 
       tt-param.referencia-fim    no-label
       skip(2)
       c-cla                      no-label
       skip
       c-cla-2                    no-label 
       skip(2)
       c-imp                      no-label
       c-destino                              colon 20  
       tt-param.arquivo                       colon 20   
       tt-param.usuario                       colon 20                                            
          with stream-io no-box width 132 side-labels frame f-imp-par-2.  
&endif 
         
run utp/ut-trfrrp.p (input frame f-cabec-1:handle).
run utp/ut-trfrrp.p (input frame f-cabec-2:handle).
run utp/ut-trfrrp.p (input frame f-det-1:handle).
run utp/ut-trfrrp.p (input frame f-det-2:handle).
run utp/ut-trfrrp.p (input frame f-imp-par:handle).
