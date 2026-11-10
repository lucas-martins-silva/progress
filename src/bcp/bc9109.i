Define Variable vTransaction    As Character No-undo.
Define Variable vNomeUsuario    As Character No-undo.
Define Variable vSequencia      As Integer   No-undo.
Define Variable wgapi010        As Handle    No-undo.
Define Variable vLogErro        As Logical   No-undo.
Define Variable cDelimitador    As Character No-undo.
Define Variable vLogEtiqueta    As Logical Init No  No-undo.

Find First Param-Bc No-Lock No-Error.
If  Avail Param-Bc
Then    Assign  cDelimitador = Trim(Param-Bc.Char-1).

Assign vTransaction = Entry(1,pTransacao,cDelimitador).

Do  On Error  Undo, Return "NOK"
    On Stop   Undo, Return "NOK"
    On EndKey Undo, Retry:

    {&TriggerBeforeTransfer}

    Create {&TempTable}.

    Run TransfereDados.

    Find First Param-Bc No-lock No-error.

    If  {&TempTable}.cod-usuario = ""
    Then Do:
        Find First bc-coletor No-lock Where Rowid(bc-coletor) = pColetor No-error.
        If Available bc-coletor Then
            Assign  vNomeUsuario = bc-coletor.usuario.
        Else
            Assign  vNomeUsuario = 'super'.
    End.
    Else    Assign  vNomeUsuario = {&TempTable}.cod-usuario.

        
    Assign  {&TempTable}.cod-usuario    = vNomeUsuario.
    if {&TempTable}.data-transacao = ? then
      assign {&TempTable}.data-transacao = today.
    {&TriggerAfterTransfer}

End.

Return "OK".
