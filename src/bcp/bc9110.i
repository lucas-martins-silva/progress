Procedure _GenerateDCTransaction:
    Define Input Param pCd-trans              As Character   Format "x(8)":U     No-undo.
    Define Input Param pConteudo-trans        As Raw                             No-undo.
    Define Input Param pDetalhe               As Character   Format "x(60)":U    No-undo.
    Define Input Param pUsuario               As Character   Format "x(12)":U    No-undo.

    for each tt-erro-after-GenerateDC:
        delete tt-erro-after-GenerateDC.
    end.

    Run 'bcp/bcapi010.p':U Persistent Set wgapi010.

    Create tt-bc-tipo-trans.
    Assign tt-bc-tipo-trans.cd-trans              = pCd-trans
           tt-bc-tipo-trans.cod-versao-integracao = 001.

    Run Pi-bc-tipo-trans in wgapi010 (Input-Output  table tt-bc-tipo-trans,
                                      Input-Output  table tt-erro{&Ext}).

    For each tt-erro{&Ext}:
       
        create tt-erro-after-GenerateDC.
        buffer-copy tt-erro{&Ext} to tt-erro-after-GenerateDC.
    
    End.
   
    if  Valid-Handle(wgapi010) Then
        Delete Object wgapi010.

    If  Can-Find(First tt-erro{&Ext}) Then
        Return Error.

    Create  tt-trans.
    Assign  tt-trans.cod-versao-integracao  = 001
            tt-trans.i-sequen               = 1
            tt-trans.cd-trans               = pCd-trans
            tt-trans.detalhe                = pDetalhe
            tt-trans.usuario                = pUsuario
            tt-trans.conteudo-trans         = pConteudo-trans
            tt-trans.atualizada             = No
            tt-trans.etiqueta               = vLogEtiqueta.

    Run bcp/bcapi001.p (input-output table tt-trans,
                        input-output table tt-erro{&Ext}).

    For Each tt-trans:
        Delete tt-trans.
    End.

    For each tt-erro{&Ext}:
       
        create tt-erro-after-GenerateDC.
        buffer-copy tt-erro{&Ext} to tt-erro-after-GenerateDC.
    
    End.

    If  Can-Find(First tt-erro{&Ext})
    And Available tt-bc-tipo-trans
    And tt-bc-tipo-trans.erros-on-line
    Then
        Return Error.

    For each tt-erro{&Ext}:
    
        Delete tt-erro{&Ext}.
    
    End.
    
End Procedure.
