disp c-div-hist 
     with frame f-div-hist.

disp tit-ap.observacao
     with frame f-hist-obs.

for each his-d-ap OF tit-ap
    where his-d-ap.sequencia <> 999999 NO-LOCK:
    disp his-d-ap.dt-his-doc
         his-d-ap.sequencia
         his-d-ap.historico
         with frame f-hist-det.
    down with frame f-hist-det.
end.
