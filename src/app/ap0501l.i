/******************************************************************************************************
**
** AP0501L.I - Antecipa‡äes de IR   
**
******************************************************************************************************/
   
  if  tit-ap.esp-ant <> ""
  and tit-ap.vl-ir-antec > 0 then do:

      assign de-saldo    = tit-ap.valor-saldo
             de-saldo-ir = tit-ap.vl-ir-antec.

      find first impto-tit-pend-ap
         where impto-tit-pend-ap.ep-codigo   = lin-i-ap.ep-codigo
           and impto-tit-pend-ap.cod-estabel = lin-i-ap.cod-estabel
           and impto-tit-pend-ap.cod-esp     = lin-i-ap.cod-esp
           and impto-tit-pend-ap.serie       = lin-i-ap.serie
           and impto-tit-pend-ap.nr-docto    = lin-i-ap.nr-docto
           and impto-tit-pend-ap.parcela     = lin-i-ap.parcela
           and impto-tit-pend-ap.cod-fornec  = lin-i-ap.cod-fornec
           and impto-tit-pend-ap.tipo        = 1
      no-lock no-error.
      if  not avail impto-tit-pend-ap then do:
          run utp/ut-msgs.p (input "show",
                             input 6633,
                             input " ").
      end.
      else do:
               
          assign de-saldo-ir = tit-ap.vl-ir-antec.
          for each b-l-ant-ap
             where b-l-ant-ap.ep-cod-ant   = tit-ap.ep-codigo
               and b-l-ant-ap.cod-est-ant  = tit-ap.cod-estabel
               and b-l-ant-ap.cod-esp-ant  = tit-ap.cod-esp
               and b-l-ant-ap.serie-ant    = tit-ap.serie    
               and b-l-ant-ap.fornec-ant   = tit-ap.cod-fornec
               and b-l-ant-ap.nr-docto-ant = tit-ap.nr-docto 
               and b-l-ant-ap.parcela-ant  = tit-ap.parcela 
               and b-l-ant-ap.antec-ir     = yes
             no-lock:

              assign de-saldo-ir = de-saldo-ir -
                                   b-l-ant-ap.vl-antecip.
          end.

          if  de-saldo-ir <= 0 then do:                           
              /*IR do documento normal j  foi totalmente antecipado*/
              run utp/ut-msgs.p (input "show",
                                 input 6634,
                                 input " ").
              
              assign l-ok-ir = no.                                   
          end.

          assign de-ir-antec = round( fn_ajust_dec(((de-antec * 
                                      de-saldo-ir) / de-saldo,2)),0 ).
                                           
          if  l-ok-ir = yes then do:
             /*Antecipacao possui IR no valor de*/
             run utp/ut-msgs.p (input "show",
                                input 6635,
                                input string(de-ir-antec)).
             if  return-value = "yes" then do:                                                                                                   
                 find first b-tit-ap use-index codigo
                    where b-tit-ap.ep-codigo  = tit-ap.ep-codigo
                      and b-tit-ap.cod-estab  = tit-ap.cod-estab
                      and b-tit-ap.cod-esp    = tit-ap.esp-ant
                      and b-tit-ap.serie      = tit-ap.serie-ant
                      and b-tit-ap.nr-docto   = tit-ap.docto-ant
                      and b-tit-ap.parcela    = tit-ap.parc-ant
                      and b-tit-ap.cod-fornec = tit-ap.cod-fornec
                    no-lock no-error.                    

                 if  b-tit-ap.cod-retencao <> impto-tit-pend-ap.cod-retencao then do:
                     /*C¢digo de Reten‡Æo deve ser igual ao c¢digo do IR antecipado*/
                     run utp/ut-msgs.p (input "show",
                                        input 6636,
                                        input " ").
                     assign l-ok-ir-aux = no.                                             
                 end.
                 else do:                
                     if  l-ok-ir-aux = yes then do:
                         create b-l-ant-ap-aux.
                         assign b-l-ant-ap-aux.ep-codigo    = lin-i-ap.ep-codigo
                                b-l-ant-ap-aux.cod-estabel  = lin-i-ap.cod-estab
                                b-l-ant-ap-aux.cod-esp      = lin-i-ap.cod-esp
                                b-l-ant-ap-aux.serie        = lin-i-ap.serie
                                b-l-ant-ap-aux.cod-for-doc  = lin-i-ap.cod-fornec       
                                b-l-ant-ap-aux.cod-fornec   = lin-i-ap.cod-fornec
                                b-l-ant-ap-aux.nr-docto     = lin-i-ap.nr-docto
                                b-l-ant-ap-aux.parcela      = lin-i-ap.parcela
                                b-l-ant-ap-aux.ep-cod-ant   = tit-ap.ep-codigo
                                b-l-ant-ap-aux.cod-est-ant  = tit-ap.cod-estabel
                                b-l-ant-ap-aux.cod-esp-ant  = tit-ap.cod-esp
                                b-l-ant-ap-aux.serie-ant    = tit-ap.serie    
                                b-l-ant-ap-aux.fornec-ant   = tit-ap.cod-fornec
                                b-l-ant-ap-aux.nr-docto-ant = tit-ap.nr-docto 
                                b-l-ant-ap-aux.parcela-ant  = tit-ap.parcela 
                                b-l-ant-ap-aux.antec-ir     = yes.

                         if  de-ir-antec >= lin-i-ap.vl-original then do:                            
                             assign b-l-ant-ap-aux.vl-antecip = lin-i-ap.vl-original. 
                         end.
                         else do:
                             assign  b-l-ant-ap-aux.vl-antecip =  de-ir-antec.
                         end.
                         assign lin-i-ap.vl-ir-antec = b-l-ant-ap-aux.vl-antecip.

                     end.
                 end. 
             end.
          end.
      end. 
  end.

/* fim da include */
