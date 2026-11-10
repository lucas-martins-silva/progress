IF tt-estrutura.tipo-dado = 'Date':U THEN DO:
    ASSIGN tt-estrutura.conteudo = REPLACE(tt-estrutura.conteudo,'/':U, '' ). 
    IF tt-estrutura.atributo = "{1}" THEN ASSIGN tt-estrutura.conteudo = string({1},'99/99/9999').
END.
ELSE DO:
    IF tt-estrutura.atributo = "{1}" THEN ASSIGN tt-estrutura.conteudo = string({1}).
END.
IF tt-estrutura.tipo-dado = 'logical':U THEN ASSIGN tt-estrutura.conteudo = REPLACE(tt-estrutura.conteudo,'yes':U, 'Sim'). 
IF tt-estrutura.tipo-dado = 'logical':U THEN ASSIGN tt-estrutura.conteudo = REPLACE(tt-estrutura.conteudo,'No':U, 'Nao'). 

