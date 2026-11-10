    /*verifica se a ordem de compra possui acompanhamento do processo*/
    if  not valid-handle (h-bocx150) then
        run cxbo/bocx150.p persistent set h-bocx150.
    
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
        run cxbo/bocx351.p persistent set h-bocx351.
    &endif
    
    run buscaHistorico in h-bocx150 (input processo-imp.num-pedido,
                                     output l-acompan).
    if  not l-acompan then do:

        /*Parcela nao fixada (parcela sera re-planejada)*/
        if  avail prazo-compra then do:

            /* Licenciamento Importacao */
            &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
            
            run piRetornaLi in h-bocx351 (input 3,
                                          input no,
                                          input ?,
                                          input ?,
                                          input ?,
                                          input prazo-compra.parcela,
                                          input yes,
                                          input yes,
                                          input prazo-compra.numero-ordem,
                                          input prazo-compra.numero-ordem,
                                          input "":U,
                                          input "":U,
                                          input "":U,
                                          input "":U,
                                          input "":U,
                                          input "":U,
                                          output table tt-licenciam-import-oc).
            if  not can-find(first tt-licenciam-import-oc) then 
            
            &endif

            assign prazo-compra.int-2 = 0.
        end.
    end.
    
    if  valid-handle (h-bocx150) then do:
        delete procedure h-bocx150.
        assign h-bocx150 = ?.
    end.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    if  valid-handle (h-bocx351) then do:
        delete procedure h-bocx351.
        assign h-bocx351 = ?.
    end.
    &endif
