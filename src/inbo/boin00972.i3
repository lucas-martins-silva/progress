CASE {&TABELA}.cdn-abrangen:
    WHEN 1 THEN DO: /* Ponto Coleta */
        ASSIGN l-validar-abrangen = {&TABELA}.cod-pto-coleta = bf{&TableName}.cod-pto-coleta        
                cTxtAbrang = c-abrangencia[1] + ": " + {&TABELA}.cod-pto-coleta.
        
    END.
    WHEN 2 THEN DO: /* Propriedade */
        ASSIGN l-validar-abrangen = {&TABELA}.cod-propried = bf{&TableName}.cod-propried
                cTxtAbrang = c-abrangencia[2] + ": " + {&TABELA}.cod-propried.
       
    END.
    WHEN 3 THEN DO: /* Produtor */
        ASSIGN l-validar-abrangen = {&TABELA}.cdn-produt-rural = bf{&TableName}.cdn-produt-rural
                cTxtAbrang = c-abrangencia[3] + ": " + STRING({&TABELA}.cdn-produt-rural).
       
    END.
    WHEN 4 THEN DO: /* Grupo */
        ASSIGN l-validar-abrangen = {&TABELA}.cdn-grp-produt = bf{&TableName}.cdn-grp-produt
                cTxtAbrang = c-abrangencia[4] + ": " + STRING({&TABELA}.cdn-grp-produt).
      
    END.
    WHEN 5 THEN DO: /* Rota */
        ASSIGN l-validar-abrangen = {&TABELA}.cod-rota = bf{&TableName}.cod-rota
                cTxtAbrang = c-abrangencia[5] + ": " + {&TABELA}.cod-rota.
       
    END.
    WHEN 6 THEN DO: /* Regi∆o */
        ASSIGN l-validar-abrangen = {&TABELA}.cod-regiao = bf{&TableName}.cod-regiao
                cTxtAbrang = c-abrangencia[6] + ": " + {&TABELA}.cod-regiao.
        
    END.
    WHEN 7 THEN DO: /* Estabelecimento */
        ASSIGN l-validar-abrangen = {&TABELA}.cod-estabel = bf{&TableName}.cod-estabel
                cTxtAbrang = c-abrangencia[7] + ": " + {&TABELA}.cod-estabel.
    END.
    OTHERWISE DO:
        ASSIGN l-validar-abrangen = YES /* TODOS */        
                cTxtAbrang = c-abrangencia[8].
    END.    
END CASE.

IF l-validar-abrangen THEN LEAVE.