IF  l-primeira-linha THEN DO:
    ASSIGN l-primeira-linha = NO.
    PUT STREAM s-planilha UNFORMATTED
        "CNPJ/CPF Benefici rio;"
        "Nome do Benefici rio;"
        "C¢digo de reten‡Æo;".
    DO i-mes = 1 TO 12:
       PUT STREAM s-planilha UNFORMATTED
           'Rend-Trib ' + STRING({1}) + '/' + string(i-mes,'99') ';'.
    END.
    DO i-mes = 1 TO 12:
       PUT STREAM s-planilha UNFORMATTED
           'Dedu‡Æo ' + STRING({1}) + '/' + string(i-mes,'99') ';'.
    END.
    DO i-mes = 1 TO 12:
       PUT STREAM s-planilha UNFORMATTED
           'Imp-Ret ' + STRING({1}) + '/' + string(i-mes,'99') ';'.
    END.
    
    PUT STREAM s-planilha UNFORMATTED
        SKIP.
END.

PUT STREAM s-planilha UNFORMATTED
    t-dirf.cgc-cpf-ben ';'
    t-dirf.nome-ben ';'
    t-dirf.cod-ret ';'.
DO  i-mes = 1 TO 12:
    PUT STREAM s-planilha UNFORMATTED
        {2}[i-mes] ';'.
END.
DO  i-mes = 1 TO 12:
    PUT STREAM s-planilha UNFORMATTED
        {3}[i-mes] ';'.
END.
DO  i-mes = 1 TO 12:
    PUT STREAM s-planilha UNFORMATTED
        {4}[i-mes] ';'.
END.

PUT STREAM s-planilha UNFORMATTED
    SKIP.
