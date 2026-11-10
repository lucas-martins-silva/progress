Find Last tt-erro{&Ext} No-lock No-error.
If Available tt-erro{&Ext} Then
    Assign vSequencia = tt-erro{&Ext}.i-sequen + 1.
Else
    Assign vSequencia = 1.

Create tt-erro{&Ext}.
Assign tt-erro{&Ext}.i-sequen = vSequencia
       tt-erro{&Ext}.cd-erro  = {1} {3}
       tt-erro{&Ext}.mensagem = "{2}" {4}.
