/*include que imprime os parametros no final de cada relatorio*/

/*imprime os parametros no final do relatorio*/
IF tt-param.l-habilitaRtf <> NO THEN DO:
    IF tt-param.destino = 1 THEN
        ASSIGN c-dest = "Impressora".
    ELSE DO:
            IF tt-param.destino = 2 THEN
                ASSIGN c-dest = "Arquivo".
            ELSE
                ASSIGN c-dest = "Terminal".
        END.
    IF tt-param.classifica = 1 THEN
        c-classificacao = "Por Nr.DI-EMS/Adi‡Æo/Sequˆncia".
    ELSE
        c-classificacao = "Por Nr.DI-EMS/Embarque/Item".
    ASSIGN c-param-destino = c-dest + " - " + tt-param.arquivo.
    DISP 
        tt-param.c-diems-ini
        tt-param.c-diems-fim
        tt-param.c-siscomex-ini
        tt-param.c-siscomex-fim
        tt-param.d-datadi-ini
        tt-param.d-datadi-fim
        tt-param.c-estab-ini
        tt-param.c-estab-fim
        tt-param.c-via-transp-ini
        tt-param.c-via-transp-fim
        c-classificacao
        tt-param.l-Obervacoes
        tt-param.l-transporte
        tt-param.l-Itinerario
        tt-param.l-Despesas
        tt-param.l-cus-nacio
        tt-param.l-listaradicoes
        tt-param.l-despesas-adicoes
        tt-param.l-LItens
        tt-param.l-cambio
        c-param-destino
        tt-param.usuario
       WITH FRAME f-param.

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        VIEW FRAME f-cabecDigita.
        FOR EACH tt-digita:
            DISP
                tt-digita.num-di-em
                tt-digita.cod-di-siscomex
                tt-digita.data-di
               WITH FRAME f-digita.
               DOWN WITH FRAME f-digita.
        END.
    END.
END.
