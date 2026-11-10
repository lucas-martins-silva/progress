if "{1}" = "aprova" then
    assign i-sequencia-substring = 3.
else
    assign i-sequencia-substring = 7.
    
ASSIGN tt-html.html-doc = tt-html.html-doc +      
   '      <td>' +
   '      <table border=0>'.

IF SUBSTRING(mla-tipo-doc-aprov.char-1,i-sequencia-substring + 3,1) = "Y" THEN  /*se informado = yes ent’o habilita checkboxes para usuÿrio selecionar quem vai receber notifica?’o */
    ASSIGN c-informado = "".  
ELSE 
    ASSIGN c-informado = "disabled".                                        
                                
IF SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y" OR  
   SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y" THEN DO:

    IF SUBSTRING(mla-tipo-doc-aprov.char-1,i-sequencia-substring,1) = "Y" THEN /* Envia notifica?’o para usuÿrio da transa?’o*/
        ASSIGN c-checked = "checked".
    ELSE 
        ASSIGN c-checked = "".

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '   <tr >' +
           '      <td align="center" class="linhaBrowseImpar"><input type=checkbox name=notifica_usuar_trans_' + '{1}' +  '  class=linhaform ' + c-informado + ' ' + c-checked + '></td>' +
           '      <td align="center" class="linhaBrowseImpar">Transa‡Æo</td>' +
           '      <td align="center" class="linhaBrowseImpar">' + mla-doc-pend-aprov.cod-usuar-trans + ' - '.


    find first usuar_mestre no-lock 
        where usuar_mestre.cod_usuario = mla-doc-pend-aprov.cod-usuar-trans no-error.

    if avail usuar_mestre then
            tt-html.html-doc = tt-html.html-doc + usuar_mestre.nom_usuario + '</td></tr>'.
    else
            tt-html.html-doc = tt-html.html-doc +  '</td></tr>'. 

    IF SUBSTRING(mla-tipo-doc-aprov.char-1,i-sequencia-substring + 1,1) = "Y" THEN  /* Envia notifica?’o para uruÿrio do documento*/
        ASSIGN c-checked = "checked".
    ELSE 
        ASSIGN c-checked = "".
    

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '   <tr >' +
           '      <td align="center" class="linhaBrowsePar"><input type=checkbox name=notifica_usuar_doc_' + '{1}' +  ' class=linhaform '  + c-informado + ' ' + c-checked + '></td>' +
           '      <td align="center" class="linhaBrowsePar">Documento</td>' +
           '      <td align="center" class="linhaBrowsePar">' + mla-doc-pend-aprov.cod-usuar-doc + ' - '.
    

    find first usuar_mestre no-lock 
        where usuar_mestre.cod_usuario = mla-doc-pend-aprov.cod-usuar-doc no-error.

    if avail usuar_mestre then
            tt-html.html-doc = tt-html.html-doc + usuar_mestre.nom_usuario + '</td></tr>'.
    else
            tt-html.html-doc = tt-html.html-doc +  '</td></tr>'. 
    
    IF SUBSTRING(mla-tipo-doc-aprov.char-1,i-sequencia-substring + 2,1) = "Y" THEN DO: /* Envia notifica?’o para todos aprovadores envolvidos */
        FOR EACH  mla-doc-pend-aprov 
               WHERE &IF "{&mguni_version}" < "2.07A" &THEN
                     mla-doc-pend-aprov.ep-codigo    = int(tt-aed-chave.valor[10])
                     &ELSE
                     mla-doc-pend-aprov.ep-codigo    = tt-aed-chave.valor[10]
                     &ENDIF
                 AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
                 AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
                 AND mla-doc-pend-aprov.chave-doc    = c-chave  
                 AND mla-doc-pend-aprov.ind-situacao = 2
                 AND mla-doc-pend-aprov.historico    = NO NO-LOCK USE-INDEX pend-18 BY mla-doc-pend-aprov.nr-trans: 
        
            ASSIGN i-cont-aprov = i-cont-aprov + 1.
        
            IF i-cont-aprov MOD 2 > 0 THEN DO:
        
                ASSIGN c-class-notif = 'class="linhaBrowseImpar"'.
        
            END.
            ELSE 
                ASSIGN c-class-notif = 'class="linhaBrowsePar"'.
        
        
            IF mla-doc-pend-aprov.cod-usuar-altern = "" THEN 
                ASSIGN c-usuar-mestre = mla-doc-pend-aprov.cod-usuar.
            ELSE
                ASSIGN c-usuar-mestre = mla-doc-pend-aprov.cod-usuar-altern.

            ASSIGN tt-html.html-doc = tt-html.html-doc +           
                   '   <tr >' +
                   '      <td align="center" ' + c-class-notif + '><input type=checkbox name=notifica_aprovador_' + '{1}' +  ' class=linhaform '  + c-informado + ' checked></td>' +
                   '      <td align="center" ' + c-class-notif + '>Aprovador</td>' +
                   '      <td align="center" ' + c-class-notif + '>' + c-usuar-mestre + ' - '.

            find first usuar_mestre no-lock 
                where usuar_mestre.cod_usuario = c-usuar-mestre no-error.
        
            if avail usuar_mestre then
                    tt-html.html-doc = tt-html.html-doc + usuar_mestre.nom_usuario + '</td></tr>'.
            else
                    tt-html.html-doc = tt-html.html-doc +  '</td></tr>'. 
        
        END.
    END.
    if i-cont-aprov = 0 then
        ASSIGN tt-html.html-doc = tt-html.html-doc + '<input type=hidden name=notifica_aprovador_' + '{1}' +  ' value="nulo">'. 
    
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +           
                           '</table>' + 
                           '</td>'.
