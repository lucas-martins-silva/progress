find first tt-{1} no-lock
     where tt-{1}.r-rowid = rowid({1}) no-error.

if  not avail tt-{1} then do:

    run pi-acompanhar in h-acomp ("Criando Reg. Temp.: " + caps("{1}")).
    
    create tt-{1}.
    buffer-copy {1} to tt-{1}.
    assign tt-{1}.r-rowid = rowid({1}).
end.

