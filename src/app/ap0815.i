/*********************************************************************************
***
*** app/ap0815.i - Cria‡Æo da temp-table tn-nota-dup
***
*********************************************************************************/

find tt-espec-ap where tt-espec-ap.cod-esp = nota-dup.cod-esp-d no-lock no-error.
if  not avail tt-espec-ap then do:
    find espec-ap where espec-ap.cod-esp = nota-dup.cod-esp-d no-lock no-error.
    if avail espec-ap then do:
       create tt-espec-ap.
       buffer-copy espec-ap to tt-espec-ap.
    end.   
end.
 
if avail tt-espec-ap then do:
   if i-tipo-dup = 1 and tt-espec-ap.tipo <> 9 then 
          next. 
   if i-tipo-dup = 2 and tt-espec-ap.tipo <> 7 then 
          next.
   if i-tipo-dup = 3 and (tt-espec-ap.tipo = 9 or tt-espec-ap.tipo = 7) then 
          next.
 
    run pi-acompanhar in h-acomp (input nota-dup.nr-docto-n + "/" + nota-dup.parcela-n).
 
    /*guarda las notas*/
    find first  tn-nota-dup NO-LOCK
          where tn-nota-dup.ep-codigo-n   = nota-dup.ep-codigo-n
          and   tn-nota-dup.cod-estabel-n = nota-dup.cod-estabel-n
          and   tn-nota-dup.cod-esp-n     = nota-dup.cod-esp-n
          and   tn-nota-dup.serie-n       = nota-dup.serie-n
          and   tn-nota-dup.nr-docto-n    = nota-dup.nr-docto-n
          and   tn-nota-dup.parcela-n     = nota-dup.parcela-n
          and   tn-nota-dup.cod-fornec    = nota-dup.cod-fornec
          no-error.
 
    if  not avail tn-nota-dup then do:
        create tn-nota-dup.
        assign tn-nota-dup.cod-esp-d     = nota-dup.cod-esp-d 
               tn-nota-dup.cod-esp-n     = nota-dup.cod-esp-n 
               tn-nota-dup.cod-estabel-d = nota-dup.cod-estabel-d 
               tn-nota-dup.cod-estabel-n = nota-dup.cod-estabel-n 
               tn-nota-dup.cod-fornec    = nota-dup.cod-fornec 
               tn-nota-dup.dt-transacao  = nota-dup.dt-transacao 
               tn-nota-dup.ep-codigo-n   = nota-dup.ep-codigo-n 
               tn-nota-dup.fornec-dup    = nota-dup.fornec-dup 
               tn-nota-dup.nr-docto-d    = nota-dup.nr-docto-d 
               tn-nota-dup.nr-docto-n    = nota-dup.nr-docto-n 
               tn-nota-dup.parcela-d     = nota-dup.parcela-d 
               tn-nota-dup.parcela-n     = nota-dup.parcela-n 
               tn-nota-dup.referencia    = nota-dup.referencia 
               tn-nota-dup.serie-d       = nota-dup.serie-d 
               tn-nota-dup.serie-n       = nota-dup.serie-n.
    end.
 
    /*guarda los dup*/
    find first td-nota-dup NO-LOCK
         where td-nota-dup.ep-codigo-n   = nota-dup.ep-codigo-n
         and   td-nota-dup.cod-estabel-d = nota-dup.cod-estabel-d
         and   td-nota-dup.cod-esp-d     = nota-dup.cod-esp-d
         and   td-nota-dup.serie-d       = nota-dup.serie-d
         and   td-nota-dup.nr-docto-d    = nota-dup.nr-docto-d
         and   td-nota-dup.parcela-d     = nota-dup.parcela-d
         and   td-nota-dup.fornec-dup    = nota-dup.fornec-dup 
         no-error.
 
    if  not avail td-nota-dup then do:
        create td-nota-dup.
        assign td-nota-dup.cod-esp-d     = nota-dup.cod-esp-d 
               td-nota-dup.cod-esp-n     = nota-dup.cod-esp-n 
               td-nota-dup.cod-estabel-d = nota-dup.cod-estabel-d 
               td-nota-dup.cod-estabel-n = nota-dup.cod-estabel-n 
               td-nota-dup.cod-fornec    = nota-dup.cod-fornec 
               td-nota-dup.dt-transacao  = nota-dup.dt-transacao 
               td-nota-dup.ep-codigo-n   = nota-dup.ep-codigo-n 
               td-nota-dup.fornec-dup    = nota-dup.fornec-dup 
               td-nota-dup.nr-docto-d    = nota-dup.nr-docto-d 
               td-nota-dup.nr-docto-n    = nota-dup.nr-docto-n 
               td-nota-dup.parcela-d     = nota-dup.parcela-d 
               td-nota-dup.parcela-n     = nota-dup.parcela-n 
               td-nota-dup.referencia    = nota-dup.referencia 
               td-nota-dup.serie-d       = nota-dup.serie-d 
               td-nota-dup.serie-n       = nota-dup.serie-n.
    end.
end.
