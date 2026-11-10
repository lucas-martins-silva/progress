
    /**  setGeraLog
    **/
    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY   +
                    "AEDLOG_Gera_Pend"       + "_" +
                    TRIM(c-usuario-aed)      + "_" +
                    STRING(i-cod-tip-doc)    + "_" +
                    REPLACE(REPLACE(c-chave," ",""),"/","-")  + "_" +
                    STRING(TODAY,"99-99-99") + ".txt") APPEND.

    CASE c-log:
        WHEN "setGeraPendencia" THEN DO:            
            PUT UNFORMATTED "___________________________________________________________" AT 1 SKIP
                            c-lbl-liter-aedlog-gera-pend-inc-3 + "                        " + STRING(TODAY) + " - " + string(time,"hh:mm:ss") AT 1 SKIP
                            "___________________________________________________________" AT 1 SKIP    
                            c-lbl-liter-tipo-trans + " : " + STRING(i-tipo-trans) AT 1 SKIP
                            c-lbl-liter-empresa + "    : " + STRING(i-ep-codigo) AT 1 SKIP
                            c-lbl-liter-estabelec + "  : " + c-cod-estabel AT 1 SKIP
                            c-lbl-liter-tipo-docto + " : " + STRING(i-cod-tip-doc) AT 1 SKIP
                            c-lbl-liter-chave + "      : " + c-chave AT 1 SKIP
                            c-lbl-liter-valor + "      : " + TRIM(STRING(de-valor-aprov,">>>,>>>,>>>,>>9.99")) AT 1 SKIP
                            c-lbl-liter-usuario + "    : " + c-usuario-aed  AT 1 SKIP
                            c-lbl-liter-transacao + "  : " + c-cod-usuar-trans AT 1 SKIP
                            c-lbl-liter-documento + "  : " + c-cod-usuar-doc AT 1 SKIP
                            c-lbl-liter-lotacao + "    : " + c-cod-lotacao-doc AT 1 SKIP
                            c-lbl-liter-referencia + " : " + c-cod-referencia AT 1 SKIP
                            c-lbl-liter-item + "       : " + c-it-codigo AT 1 SKIP.
            OUTPUT CLOSE.
        END.
        WHEN "getNextTipoAprov" THEN DO:
            PUT UNFORMATTED "____________________" AT 1 SKIP
                            ">>>_getNextTipoAprov" AT 1 SKIP(1)
                            "      " + c-lbl-liter-proximo-tipo-de-aprovacao AT 1 SKIP.
        END.
        WHEN "setEnviaEmail" THEN DO:
            PUT UNFORMATTED "_________________" AT 1 SKIP
                            ">>>_setEnviaEmail" AT 1 SKIP(1)
                            "      " + c-lbl-liter-envia-e-mail AT 1 SKIP.
        END.
        WHEN "setEnviaEmailAltern" THEN DO:
            PUT UNFORMATTED "_______________________" AT 1 SKIP
                            ">>>_setEnviaEmailAltern" AT 1 SKIP(1)
                            "      " + c-lbl-liter-envia-e-mails-alternativos AT 1 SKIP.
        END.
        WHEN "setExecutaProg" THEN DO:
            PUT UNFORMATTED "__________________" AT 1 SKIP
                            ">>>_setExecutaProg" AT 1 SKIP(1)
                            "      " + c-lbl-liter-executa-programa-aprovacaoreje AT 1 SKIP.
        END.
        WHEN "setGeraFaixa" THEN DO:
            PUT UNFORMATTED "________________" AT 1 SKIP
                            ">>>_setGeraFaixa" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-para-faixa AT 1 SKIP.
            OUTPUT CLOSE.
        END.
        WHEN "setGeraHierarquia" THEN DO:
            PUT UNFORMATTED "_____________________" AT 1 SKIP
                            ">>>_setGeraHierarquia" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-para-hierarquia AT 1 SKIP.
            OUTPUT CLOSE.
        END.
        WHEN "setGeraHistorico" THEN DO:
            PUT UNFORMATTED "____________________" AT 1 SKIP
                            ">>>_setGeraHistorico" AT 1 SKIP(1)
                            "      " + c-lbl-liter-passa-pendencia-para-historico AT 1 SKIP.
        END.
        WHEN "setGeraLista" THEN DO:
            PUT UNFORMATTED "________________" AT 1 SKIP
                            ">>>_setGeraLista" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-para-lista AT 1 SKIP.
            OUTPUT CLOSE.
        END.
        WHEN "setGeraPadrao" THEN DO:
            PUT UNFORMATTED "_________________" AT 1 SKIP
                            ">>>_setGeraPadrao" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-para-padrao AT 1 SKIP.
            OUTPUT CLOSE.
        END.
        WHEN "setGeraPendAprov" THEN DO:
            PUT UNFORMATTED "____________________" AT 1 SKIP
                            ">>>_setGeraPendAprov" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-de-aprovacao AT 1 SKIP.
        END.
        WHEN "setGeraPendFaixa" THEN DO:
            PUT UNFORMATTED "____________________" AT 1 SKIP
                            ">>>_setGeraPendFaixa" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-proximo-faixa AT 1 SKIP.
        END.
        WHEN "setGeraPendHierarquia" THEN DO:
            PUT UNFORMATTED "_________________________" AT 1 SKIP
                            ">>>_setGeraPendHierarquia" AT 1 SKIP(1)
                            "      " + c-lbl-liter-gera-pendencia-proximo-hierarq AT 1 SKIP.
        END.
        WHEN "setLimiteAprov" THEN DO:
            PUT UNFORMATTED "__________________" AT 1 SKIP
                            ">>>_setLimiteAprov" AT 1 SKIP(1)
                            "      " + c-lbl-liter-verifica-limite-aprovacao AT 1 SKIP.
        END.
        WHEN "setLotacao" THEN DO:
            PUT UNFORMATTED "______________" AT 1 SKIP
                            ">>>_setLotacao" AT 1 SKIP(1)
                            "      " + c-lbl-liter-seta-a-lotacao-da-pendencia AT 1 SKIP.
        END.
        WHEN "setTipoAprov" THEN DO:
            PUT UNFORMATTED "________________" AT 1 SKIP
                            ">>>_setTipoAprov" AT 1 SKIP(1)
                            "      " + c-lbl-liter-verifica-tipo-aprovacao AT 1 SKIP.
        END.
    END CASE.
