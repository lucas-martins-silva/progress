/*******************************************************************************
***
*** app/ap0777x.i3 - 
***
*******************************************************************************/

    PUT "*********************************************************************************" SKIP
        "***                                                                           ***" SKIP
        "***             Extrato de poss°veis problemas relacionados a DIRF            ***" SKIP
        "***                                                                           ***" SKIP.

    PUT "***                Data Execuá∆o: " STRING(TODAY, "99/99/9999") FORMAT "x(20)" "***" AT 79 SKIP
        "***                      Per°odo: " string({1}, "99/99/9999") format "x(10)" " Ö " STRING(TODAY, "99/99/9999") FORMAT "x(20)" "***" AT 79 SKIP
        "***                F¢rmula Multa: (Qtde Reg / 10) * R$ 20,00" "***" AT 79 SKIP
        "***                                                                           ***" SKIP
        "*********************************************************************************" SKIP.

    FIND FIRST tt-dirf NO-ERROR.
    IF  NOT AVAIL tt-dirf THEN DO:
        PUT SKIP(2)
            "*** Sem Erros !!!"
            SKIP(1).
    END.

    FOR EACH tt-dirf
        BREAK BY tt-dirf.ep-codigo:
        
        IF  FIRST-OF (tt-dirf.ep-codigo) THEN DO:
            PUT SKIP(2) 
                "Empresa: " TO 24 trim(string(tt-dirf.ep-codigo)) " - " tt-dirf.razao-social FORMAT "x(80)" SKIP
                "CNPJ: "    AT 19 STRING(tt-dirf.cgc, param-global.formato-id-federal) FORMAT "x(40)" SKIP(1).
                    
            PUT "            Qtde Registros Indicador Situaá∆o           Valor Multa" SKIP
                "            -------------- -------------------- -------------------" SKIP.
        END.

        ASSIGN tt-dirf.valor-multa = (tt-dirf.qtde-registros / 10) * 20.

        PUT tt-dirf.qtde-registros TO 26
            tt-dirf.ind-situacao   AT 28
            tt-dirf.valor-multa    TO 67
            SKIP.
    END.
    
    PUT SKIP(2).

    PUT "----------------------------------- LEGISLAÄ«O ----------------------------------" SKIP
        "|                                                                               |" SKIP
        "| Instruá∆o Normativa SRF nß 197, de 10 de setembro de 2002                     |" SKIP
        "|                                                                               |" SKIP
        "| Art. 1ß A falta de apresentaá∆o da Declaraá∆o do Imposto de Renda Retido na   |" SKIP
        "| Fonte (Dirf) no prazo fixado, ou a sua apresentaá∆o ap¢s o prazo, sujeita o   |" SKIP
        "| declarante Ö multa de dois por cento ao màs-calend†rio ou fraá∆o, incidente   |" SKIP
        "| sobre o montante do imposto de renda informado na declaraá∆o, ainda que       |" SKIP
        "| integralmente pago, limitada a vinte por cento, observado o disposto no ı 3ß. |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "| Art. 2ß O declarante est† sujeito a multa quando forem constatadas na Dirf    |" SKIP
        "| as seguintes irregularidades, n∆o sanadas no prazo fixado em intimaá∆o:       |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "| ß 2ß A n∆o correá∆oo das irregularidades, ou a sua correá∆o ap¢s o prazo      |" SKIP
        "| previsto no ı 1ß, sujeita o declarante Ö multa de R$ 20,00 (vinte reais)      |" SKIP
        "| para cada grupo de dez ocorràncias.                                           |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "| .                                                                             |" SKIP
        "---------------------------------------------------------------------------------" SKIP(1).

/* Fim Include */

