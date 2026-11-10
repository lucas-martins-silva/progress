FIND FIRST funcao WHERE funcao.cd-funcao = "spp-integra-totvs-rfid" NO-LOCK NO-ERROR.
IF AVAIL funcao THEN DO:    
    IF NUM-ENTRIES(funcao.char-1) > 0 THEN DO:
        RUN setHost IN {1} (INPUT ENTRY(1, funcao.char-1)).
        RUN setPort IN {1} (INPUT INT(ENTRY(2, funcao.char-1))).
        
        IF NUM-ENTRIES(funcao.char-1) > 2 THEN DO:
            RUN setUrl IN {1}  (INPUT ENTRY(3, funcao.char-1)).
        END.        
    END.
END.