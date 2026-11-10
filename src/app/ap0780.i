find first funcao
    where funcao.cd-funcao = "spp-acum-matriz" no-lock no-error.
IF  NOT AVAIL funcao
AND NOT CAN-FIND(FIRST acum-imposto-pagto NO-LOCK) THEN DO:
    RUN app/ap0780.p.
    IF  RETURN-VALUE = "OK" THEN DO:
        CREATE funcao.
        ASSIGN funcao.cd-funcao = "spp-acum-matriz"
               funcao.descricao = funcao.cd-funcao
               funcao.log-1     = YES
               funcao.ativo     = YES.
    END.
END.
