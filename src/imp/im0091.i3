/**                                                             **
**  Programa: im0091.i3                                         **
**  Objetivo: Calcula valor das despesas do embarque. Criada p/ **
**            nao duplicar codigo                               **
**                                                              **/

    &IF "{&bf_mat_versao_ems}" < "2.062" &THEN
    
         ASSIGN l-existe-incoterm = CAN-FIND(FIRST desp-embarque 
                                             WHERE desp-embarque.cod-estabel = embarque-imp.cod-estabel
                                               AND desp-embarque.embarque    = embarque-imp.embarque
                                               AND SUBSTR(desp-embarque.char-1,1,3) <> "").
         
    &ELSE
    
         ASSIGN l-existe-incoterm = CAN-FIND(FIRST desp-embarque 
                                             WHERE desp-embarque.cod-estabel = embarque-imp.cod-estabel
                                               AND desp-embarque.embarque    = embarque-imp.embarque
                                               AND desp-embarque.cod-incoterm-rat <> "").


    &ENDIF

    FOR EACH tt-desp-totais-incoterm:
        DELETE tt-desp-totais-incoterm.
    END.                               

    IF  l-existe-incoterm THEN
        FOR EACH inco-cx NO-LOCK:
            CREATE tt-desp-totais-incoterm.
            ASSIGN tt-desp-totais-incoterm.cod-incoterm = inco-cx.cod-incoterm.
        END.

    for each  desp-embarque 
        where desp-embarque.cod-estabel = embarque-imp.cod-estabel
        and   desp-embarque.embarque    = embarque-imp.embarque no-lock:
    
        /** Validacoes das despesas **/
        {imp/im0091.i2}
    
        assign de-val-desp    = desp-embarque.val-desp.
               
        if  desp-embarque.mo-codigo <> 0 then
            run cdp/cd0812.p (input desp-embarque.mo-codigo,
                              input 0,
                              input desp-embarque.val-desp,
                              input da-data-cotacao,
                              output de-val-desp).
        
            if  program-name(5) = "pi-executar imp/im0101.w" then do:
            
                /*Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
                {include/i-epc200.i2 &CodEvent='"ConverteDespesaComplementar"'
                                     &CodParameter='"cod-estabel"'
                                     &ValueParameter="string(desp-embarque.cod-estabel)"}
                {include/i-epc200.i2 &CodEvent='"ConverteDespesaComplementar"'
                                     &CodParameter='"embarque"'
                                     &ValueParameter="string(desp-embarque.embarque)"}
                {include/i-epc200.i2 &CodEvent='"ConverteDespesaComplementar"'
                                     &CodParameter='"cod-desp"'
                                     &ValueParameter="string(desp-embarque.cod-desp)"}
                {include/i-epc200.i2 &CodEvent='"ConverteDespesaComplementar"'
                                     &CodParameter='"moeda"'
                                     &ValueParameter="string(desp-embarque.mo-codigo)"}
                {include/i-epc200.i2 &CodEvent='"ConverteDespesaComplementar"'
                                     &CodParameter='"val-desp"'
                                     &ValueParameter="string(desp-embarque.val-desp)"}
                
                /*Include i-epc201.i: Chamada do programa de EPC */
                {include/i-epc201.i "ConverteDespesaComplementar"}
            end.
            
            if  c-nom-prog-dpc-mg97  <> "" 
            or  c-nom-prog-appc-mg97 <> ""
            or  c-nom-prog-upc-mg97  <> "" then do:
            
                find first tt-epc
                    where tt-epc.cod-event = "ConverteDespesaComplementar"
                    and   tt-epc.cod-parameter = "val-desp-conv" no-error.
                if  avail tt-epc then
                    assign de-val-desp = dec(tt-epc.val-parameter).
            
                for each tt-epc:
                    delete tt-epc.
                end.
            end.
        
        run geraOrdensdespesa (input desp-embarque.cod-desp,
                               input i-cod-itiner,
                               input de-val-desp,
                               input desp-embarque.val-desp,
                               input 0,
                               input 0,
                               input yes,
                               input desp-embarque.cod-emitente-desp,
                               input desp-embarque.cod-cond-pag,
                               input desp-embarque.mo-codigo,
                               input desp-embarque.cod-pto-contr,
                               INPUT desp-embarque.cod-incoterm,
                               INPUT l-existe-incoterm).
    end.
/** im0091.i3 **/
