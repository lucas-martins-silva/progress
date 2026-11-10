/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0640A 2.00.00.014 } /*** "010014" 16/01/2025 11:46:01 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0640a MIM}
&ENDIF

{imp/imapi009.i}
{imp/imapi009.i3}
{imp/im0640.i}     /* tt-param */
{exp/ex9998.i}     /* Procedure trocaCaracterEspecial */
{utp/utapi019.i}   /* Include API CORREIO ELETRâNICO  */
{include/i-epc200.i IM0640A}


/**************************** Parƒmetros ****************************/
DEFINE INPUT  PARAMETER TABLE FOR tt-estabelec-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-exportador-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-consignatario-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-agente-carga-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-transporte-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-embarque.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido.
DEFINE INPUT  PARAMETER TABLE FOR tt-it-inst-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-docto.
DEFINE INPUT  PARAMETER TABLE FOR tt-inst-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE INPUT  PARAMETER phAcomp  AS HANDLE.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-documentos-impressos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-erros.

/********************** Defini‡Æo de vari veis **********************/
DEFINE VARIABLE cDirLayout                      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cArquivoOrigemCabecProc  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemCabecEmb   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemCabecItens AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemItens      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemCondPagto  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemCabecDocto AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemDoctos     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemPedidos    AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoOrigemRodape     AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoAuxiliar         AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoFinal            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ch-app-word              AS office.iface.word.WordWrapper NO-UNDO.
DEFINE VARIABLE ch-Documento             AS office.iface.word.Document NO-UNDO.
DEFINE VARIABLE c-desc-erro              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-param-epc              AS CHARACTER  NO-UNDO.

/********************* Defini‡Æo de temp-tables **********************/
DEFINE TEMP-TABLE tt-matriz-ficha NO-UNDO
     FIELD c-linha       AS CHAR FORMAT 'x(300)'
     FIELD i-formulario  AS INT.

DEFINE TEMP-TABLE tt-ficha NO-UNDO
     FIELD c-linha      AS CHAR FORMAT 'x(300)'
     FIELD i-formulario AS INT.

DEFINE TEMP-TABLE tt-traduz-tt NO-UNDO
   FIELD nome-tt    AS CHAR 
   FIELD campo-tt   AS CHAR 
   FIELD banco      AS CHAR 
   FIELD tabela     AS CHAR 
   FIELD campo      AS CHAR
   FIELD desc-label AS CHAR
   INDEX chPrimary IS UNIQUE PRIMARY
    nome-tt      
    campo-tt
    banco   
    tabela  
    campo
   INDEX campo nome-tt DESC.

DEFINE TEMP-TABLE tt-token NO-UNDO
    FIELD token AS CHAR.

DEFINE TEMP-TABLE tt-fields NO-UNDO
    FIELD FILE-NAME  AS CHAR
    FIELD field-name AS CHAR
    FIELD name-size  AS INT
    INDEX codigo IS PRIMARY UNIQUE
          field-name.
DEFINE BUFFER btt-fields FOR tt-fields.

DEFINE TEMP-TABLE tt-formato NO-UNDO
   FIELD nome-tt    AS CHARACTER 
   FIELD campo-tt   AS CHARACTER 
   FIELD formato    AS character.

{imp/im0640a.i} /* procedure pi-cria-formato */
RUN pi-cria-formato.

RUN pi-seta-titulo IN phAcomp (INPUT "Gerando arquivos do WORD").    

{imp/im0640lit.i}
{imp/im0640lit.i1}
{imp/im0640lit.i2}

/************************** Main Block *****************************/
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-documentos-erros: 
    DELETE tt-documentos-erros. 
END.

RUN piGerarRelatorioInstrucaoEmbarque.

/**************************** Procedure Internas *****************************/
PROCEDURE piOpenExcel:

    /* Carrega o WORD para a  mem¢ria */
    {office/office.i Word ch-app-word}

END PROCEDURE.

PROCEDURE piCloseExcel:

    IF VALID-OBJECT(ch-app-word) THEN DO:    
        ch-app-word:QUIT(). /* Fechar o WORD */        
        DELETE OBJECT ch-app-word.
    END.

END PROCEDURE.

PROCEDURE piGerarRelatorioInstrucaoEmbarque:

    FIND FIRST tt-estabelec-aux      NO-ERROR.
    FIND FIRST tt-exportador-aux     NO-ERROR.
    FIND FIRST tt-consignatario-aux  NO-ERROR.
    FIND FIRST tt-agente-carga-aux   NO-ERROR.
    FIND FIRST tt-transporte-aux     NO-ERROR.
    FIND FIRST tt-processo-aux       NO-ERROR.
    FIND FIRST tt-pedido         NO-ERROR.
    
    
    IF  tt-param.classifica = 1 THEN DO:   /*** processo ***/
        FOR EACH tt-inst-emb:

            RUN piOpenExcel.

            RUN piCarregarArquivos.
            if  return-value = "NOK":U then
                next.

            RUN piIncluirDocumento.
            
            ASSIGN cArquivoFinal = tt-param.c-dir-destino + tt-exportador-aux.nome-abrev + "-" 
                                 + tt-processo-aux.cod-estabel  + "-" + tt-processo-aux.nr-proc-imp + "-"
                                 + SUBSTRING(STRING(tt-inst-emb.dt-embarque),1,2)  
                                 + SUBSTRING(STRING(tt-inst-emb.dt-embarque),4,2)  
                                 + SUBSTRING(STRING(tt-inst-emb.dt-embarque,"99/99/9999"),7,4) + '.doc'.
            RUN geraArquivo.

            RUN piCloseExcel.
        END.
    END.
    ELSE DO:  /*** embarque ***/
        FIND FIRST tt-embarque NO-ERROR.
        FIND FIRST tt-inst-emb NO-ERROR.
        IF  AVAIL tt-inst-emb THEN DO:

            RUN piOpenExcel.

            RUN piCarregarArquivos.
            if  return-value = "NOK":U then
                next.
            RUN piIncluirDocumento.
            ASSIGN cArquivoFinal = tt-param.c-dir-destino + tt-exportador-aux.nome-abrev + "-" 
                               + tt-embarque.cod-estabel  + "-" + tt-embarque.embarque + '.doc'.
            RUN geraArquivo.

            RUN piCloseExcel.
        END.
    END.
    
END PROCEDURE.              

PROCEDURE geraArquivo:
    RUN piValidarArquivoFinal.

    IF RETURN-VALUE = "OK" THEN DO:
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-imp").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-exp").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-instrucao").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-consig").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-agentecarga").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-transp").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-emb").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-proc").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-ped").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-itemb").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-condicao").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-enviar").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-banco").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-documentos-enviados").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-documento").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-docto").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-instemb").
        RUN piTraduzirLiterais    IN THIS-PROCEDURE (INPUT "#lit-informa").
        RUN piImprimirCabecRodape IN THIS-PROCEDURE (INPUT 1). /* Cabecalho */        
        IF tt-param.classifica = 2 THEN
            RUN piImprimirPedidos IN THIS-PROCEDURE.
        RUN piImprimirCabItens    IN THIS-PROCEDURE.
        RUN piImprimirItens       IN THIS-PROCEDURE.
        RUN piImprimirCondPagto   IN THIS-PROCEDURE.
        RUN piImprimirCabDocto    IN THIS-PROCEDURE.
        RUN piImprimirDoctos      IN THIS-PROCEDURE.
        RUN piImprimirCabecRodape IN THIS-PROCEDURE (INPUT 8). /*rodape*/ 
        RUN piSalvarArquivo       IN THIS-PROCEDURE.
    END.

END PROCEDURE.

/* Procedures para geracao dos RTF's */

PROCEDURE piImprimirCabecRodape:
    DEFINE INPUT PARAM piFormulario AS INTEGER.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Cabe‡alho/Rodape" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        IF piFormulario = 1 THEN DO:
            ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                                 tt-processo-aux.nr-proc-imp + ";" +
                                 STRING(tt-inst-emb.dt-embarque, "99/99/9999").
            {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Cab-Proc"'
                                 &CodParameter   = '"ChaveProcesso"'
                                 &ValueParameter = c-param-epc}
            {include/i-epc201.i "Custom-Fields-Cab-Proc"}
            IF RETURN-VALUE <> "OK" THEN
                EMPTY TEMP-TABLE tt-epc.
            
        END.
        ELSE DO:
            ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                                 tt-processo-aux.nr-proc-imp + ";" +
                                 STRING(tt-inst-emb.dt-embarque, "99/99/9999").
            {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Rodape"'
                                 &CodParameter   = '"ChaveProcesso"'
                                 &ValueParameter = c-param-epc}
            {include/i-epc201.i "Custom-Fields-Rodape"}
            IF RETURN-VALUE <> "OK" THEN
                EMPTY TEMP-TABLE tt-epc.
        END.
    END.
    ELSE DO:
        IF piFormulario = 1 THEN DO:
            ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                                 tt-embarque.embarque.
            {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Cab-Emb"'
                                 &CodParameter   = '"ChaveEmbarque"'
                                 &ValueParameter = c-param-epc}
            {include/i-epc201.i "Custom-Fields-Cab-Emb"}
            IF RETURN-VALUE <> "OK" THEN
                EMPTY TEMP-TABLE tt-epc.
        END.
        ELSE DO:
            ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                                 tt-embarque.embarque.
            {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Rodape"'
                                 &CodParameter   = '"ChaveEmbarque"'
                                 &ValueParameter = c-param-epc}
            {include/i-epc201.i "Custom-Fields-Rodape"}
            IF RETURN-VALUE <> "OK" THEN
                EMPTY TEMP-TABLE tt-epc.
        END.
    END.
    
    RUN piGerarFormulario(INPUT piFormulario).
    
    FOR EACH tt-ficha:
        if  avail tt-inst-emb 
        and tt-ficha.c-linha MATCHES('*#instemb-*') THEN
            RUN piSubstituiValores IN THIS-PROCEDURE ("#instemb-", INPUT BUFFER tt-inst-emb:HANDLE).

        if  avail tt-estabelec-aux
        and tt-ficha.c-linha MATCHES('*#imp-*') THEN
            RUN piSubstituiValores IN THIS-PROCEDURE ("#imp-", INPUT BUFFER tt-estabelec-aux:HANDLE).

        if  avail tt-exportador-aux
        and tt-ficha.c-linha MATCHES('*#exp-*') THEN
            RUN piSubstituiValores IN THIS-PROCEDURE ("#exp-", INPUT BUFFER tt-exportador-aux:HANDLE).
        
        if  avail tt-consignatario-aux
        and tt-ficha.c-linha MATCHES('*#consig-*') THEN
            RUN piSubstituiValores IN THIS-PROCEDURE ("#consig-", INPUT BUFFER tt-consignatario-aux:HANDLE).
        
        if  tt-ficha.c-linha MATCHES('*#agentecarga-*') then DO:
            IF NOT AVAIL tt-agente-carga-aux THEN DO:
                {utp/ut-liter.i Favor_utilizar_seu_pr¢prio_Agente_de_Cargas *}
                CREATE tt-agente-carga-aux.
                ASSIGN tt-agente-carga-aux.nome-emit = RETURN-VALUE.
                IF tt-param.l-traducao THEN
                    RUN piTraducao (INPUT-OUTPUT tt-agente-carga-aux.nome-emit).
            END.
            IF tt-agente-carga-aux.cod-emit = 0 THEN DO:
                {utp/ut-liter.i Favor_utilizar_seu_pr¢prio_Agente_de_Cargas *}
                ASSIGN tt-agente-carga-aux.nome-emit = RETURN-VALUE.
                IF tt-param.l-traducao THEN
                    RUN piTraducao (INPUT-OUTPUT tt-agente-carga-aux.nome-emit).
            END.

            RUN piSubstituiValores IN THIS-PROCEDURE ("#agentecarga-", INPUT BUFFER tt-agente-carga-aux:HANDLE).
        END.
        
        if  avail tt-transporte-aux
        and tt-ficha.c-linha MATCHES('*#transp-*') THEN
            RUN piSubstituiValores IN THIS-PROCEDURE ("#transp-", INPUT BUFFER tt-transporte-aux:HANDLE).
        
        IF  piFormulario = 1 THEN DO:
            IF tt-param.classifica = 2 THEN DO:
                IF  tt-ficha.c-linha MATCHES('*#emb-*') 
                and avail tt-embarque THEN
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#emb-", INPUT BUFFER tt-embarque:HANDLE).
            END.
            IF  tt-ficha.c-linha MATCHES('*#proc-*') 
            and avail tt-processo-aux then
                RUN piSubstituiValores IN THIS-PROCEDURE ("#proc-", INPUT BUFFER tt-processo-aux:HANDLE).

            IF  tt-ficha.c-linha MATCHES('*#ped-*')
            and avail tt-pedido then
                RUN piSubstituiValores IN THIS-PROCEDURE ("#ped-", INPUT BUFFER tt-pedido:HANDLE).
        END.

        RUN piLitToken.

        IF  tt-ficha.c-linha MATCHES('*#lit-*') THEN
            ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#lit-',"")
                   tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '-'," ").

        RUN pi-epc.
    END.
    RUN piInserirRtf IN THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE piImprimirPedidos:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Pedidos" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    
    ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                         tt-embarque.embarque.
    {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Ped"'
                         &CodParameter   = '"ChaveEmbarque"'
                         &ValueParameter = c-param-epc}
    {include/i-epc201.i "Custom-Fields-Ped"}
    IF RETURN-VALUE <> "OK" THEN
        EMPTY TEMP-TABLE tt-epc.
    
    RUN piGerarFormulario(INPUT 2).
    
    FOR EACH tt-processo-aux:

        FIND FIRST tt-pedido
            WHERE  tt-pedido.num-pedido = tt-processo-aux.num-pedido NO-LOCK NO-ERROR.
        IF  AVAIL tt-pedido THEN DO:

            OUTPUT TO VALUE(cArquivoAuxiliar).

            FOR EACH tt-ficha:

                if  tt-ficha.c-linha MATCHES('*#ped-*') then
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#ped-", INPUT BUFFER tt-pedido:HANDLE).
            
                if  tt-ficha.c-linha MATCHES('*#proc-*') then
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#proc-", INPUT BUFFER tt-processo-aux:HANDLE).

                RUN piLitToken.
                RUN pi-epc.
            END.

            RUN piImprimirNoArquivo.
            OUTPUT CLOSE.                                                                              
            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                
            FOR EACH tt-matriz-ficha 
                WHERE tt-matriz-ficha.i-formulario = 2:

                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE piImprimirCabItens:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Cabe‡alho_Itens" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                             tt-processo-aux.nr-proc-imp + ";" +
                             STRING(tt-inst-emb.dt-embarque, "99/99/9999").
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Cab-Itens"'
                             &CodParameter   ='"ChaveProcesso"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cab-Itens"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    ELSE DO:
        ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                             tt-embarque.embarque.
        {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Cab-Itens"'
                             &CodParameter   = '"ChaveEmbarque"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cab-Itens"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 3).
    FOR EACH tt-ficha:

        RUN piLitToken.

        IF tt-ficha.c-linha MATCHES('*#lit-*') THEN
            ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#lit-',"")
                   tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '-'," ").

        RUN pi-epc.
    END.
    RUN piInserirRtf IN THIS-PROCEDURE.

END PROCEDURE.

PROCEDURE piImprimirItens:
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Itens" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                             tt-processo-aux.nr-proc-imp + ";" +
                             STRING(tt-inst-emb.dt-embarque, "99/99/9999").
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Itens"'
                             &CodParameter   ='"ChaveProcesso"'
                             &ValueParameter = c-param-epc}
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Itens"'
                             &CodParameter   ='"handle-tt-it-inst-emb"'
                             &ValueParameter = "string(temp-table tt-it-inst-emb:handle)"}
        {include/i-epc201.i "Custom-Fields-Itens"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    ELSE DO:
        ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                             tt-embarque.embarque.
        {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Itens"'
                             &CodParameter   = '"ChaveEmbarque"'
                             &ValueParameter = c-param-epc}
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Itens"'
                             &CodParameter   ='"handle-tt-it-inst-emb"'
                             &ValueParameter = "string(temp-table tt-it-inst-emb:handle)"}
        {include/i-epc201.i "Custom-Fields-Itens"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 4).

    IF  tt-param.classifica = 1 THEN DO:
        FOR EACH  tt-it-inst-emb
            WHERE tt-it-inst-emb.dt-embarque = tt-inst-emb.dt-embarque
            BREAK BY tt-it-inst-emb.it-codigo:
            OUTPUT TO VALUE(cArquivoAuxiliar).
            FOR EACH tt-ficha:
                IF tt-ficha.c-linha MATCHES('*#itemb-*') THEN
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#itemb-", INPUT BUFFER tt-it-inst-emb:HANDLE).
                RUN piLitToken.
                RUN pi-epc.
            END.
            RUN piImprimirNoArquivo. 
            OUTPUT CLOSE.                                                                              
            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            FOR EACH tt-matriz-ficha
                WHERE tt-matriz-ficha.i-formulario = 4:
                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
            END.
        END.    
    END.
    ELSE DO:
        FOR EACH tt-it-inst-emb
            BREAK BY tt-it-inst-emb.it-codigo:
            OUTPUT TO VALUE(cArquivoAuxiliar).
            FOR EACH tt-ficha:
                IF tt-ficha.c-linha MATCHES('*#itemb-*') THEN
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#itemb-", INPUT BUFFER tt-it-inst-emb:HANDLE).
                RUN piLitToken.
                RUN pi-epc.
            END.
            RUN piImprimirNoArquivo. 
            OUTPUT CLOSE.
            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            FOR EACH tt-matriz-ficha
                WHERE tt-matriz-ficha.i-formulario = 4:
                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE piImprimirCondPagto:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Condi‡Æo_de_Pagamento" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                             tt-processo-aux.nr-proc-imp + ";" +
                             STRING(tt-inst-emb.dt-embarque, "99/99/9999").
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Cond-Pagto"'
                             &CodParameter   ='"ChaveProcesso"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cond-Pagto"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    ELSE DO:
        ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                             tt-embarque.embarque.
        {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Cond-Pagto"'
                             &CodParameter   = '"ChaveEmbarque"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cond-Pagto"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 5).

    IF tt-param.classifica = 2 THEN
        FIND FIRST tt-pedido NO-ERROR.

    FOR EACH tt-ficha:
        IF tt-ficha.c-linha MATCHES('*#ped-*') THEN DO:
           RUN piSubstituiValores IN THIS-PROCEDURE ("#ped-", INPUT BUFFER tt-pedido:HANDLE).
        END.

        RUN piLitToken.

        IF tt-ficha.c-linha MATCHES('*#lit-*') THEN
            ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#lit-',"")
                   tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '-'," ").
        RUN pi-epc.
    END.

    RUN piInserirRtf IN THIS-PROCEDURE.

END PROCEDURE.

PROCEDURE piImprimirCabDocto:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Cabe‡alho_Documentos" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                             tt-processo-aux.nr-proc-imp + ";" +
                             STRING(tt-inst-emb.dt-embarque, "99/99/9999").
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Cab-Doctos"'
                             &CodParameter   ='"ChaveProcesso"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cab-Doctos"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    ELSE DO:
        ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                             tt-embarque.embarque.
        {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Cab-Doctos"'
                             &CodParameter   = '"ChaveEmbarque"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Cab-Doctos"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 6).
    FOR EACH tt-ficha:
        IF tt-ficha.c-linha MATCHES('*#instemb-*') THEN
           RUN piSubstituiValores IN THIS-PROCEDURE ("#instemb-", INPUT BUFFER tt-inst-emb:HANDLE).
        
        RUN piLitToken.
        
        IF tt-ficha.c-linha MATCHES('*#lit-*') THEN
            ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#lit-',"")
                   tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '-'," ").
        RUN pi-epc.
    END.
    RUN piInserirRtf IN THIS-PROCEDURE.

END PROCEDURE.

PROCEDURE piImprimirDoctos:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Documentos" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    IF tt-param.classifica = 1 THEN DO:
        ASSIGN c-param-epc = tt-processo-aux.cod-estabel + ";" +
                             tt-processo-aux.nr-proc-imp + ";" +
                             STRING(tt-inst-emb.dt-embarque, "99/99/9999").
        {include/i-epc200.i2 &CodEvent       ='"Custom-Fields-Doctos"'
                             &CodParameter   ='"ChaveProcesso"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Doctos"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    ELSE DO:
        ASSIGN c-param-epc = tt-embarque.cod-estabel + ";" +
                             tt-embarque.embarque.
        {include/i-epc200.i2 &CodEvent       = '"Custom-Fields-Doctos"'
                             &CodParameter   = '"ChaveEmbarque"'
                             &ValueParameter = c-param-epc}
        {include/i-epc201.i "Custom-Fields-Doctos"}
        IF RETURN-VALUE <> "OK" THEN
            EMPTY TEMP-TABLE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 7).

    
    FOR EACH tt-docto:
        OUTPUT TO VALUE(cArquivoAuxiliar).

        FOR EACH tt-ficha:
            IF tt-ficha.c-linha MATCHES('*#docto-*') THEN
                RUN piSubstituiValores IN THIS-PROCEDURE ("#docto-", INPUT BUFFER tt-docto:HANDLE).
            RUN piLitToken.
            RUN pi-epc.
        END.                                                                                       
        RUN piImprimirNoArquivo. 
        OUTPUT CLOSE.                                                                              
        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
        FOR EACH tt-matriz-ficha 
            WHERE tt-matriz-ficha.i-formulario = 7:             
            CREATE tt-ficha.
            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
        END.
    END.
END PROCEDURE.


PROCEDURE piInserirRtf:
    OUTPUT TO VALUE(cArquivoAuxiliar).
    RUN piImprimirNoArquivo.
    OUTPUT CLOSE.
    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
END PROCEDURE.                  

PROCEDURE piCarregarArquivos:

    RUN piVerificarDirArqLayout.

    /* Nomes dos arquivos para gera‡Æo e arquivos auxiliares */
    ASSIGN cArquivoOrigemCabecProc  = cDirLayout + 'im0640-cab-proc.rtf'
           cArquivoOrigemCabecEmb   = cDirLayout + 'im0640-cab-emb.rtf'
           cArquivoOrigemCabecItens = cDirLayout + 'im0640-cab-itens.rtf'
           cArquivoOrigemItens      = cDirLayout + 'im0640-itens.rtf'
           cArquivoOrigemCondPagto  = cDirLayout + 'im0640-cond-pagto.rtf'
           cArquivoOrigemCabecDocto = cDirLayout + 'im0640-cab-docto.rtf'
           cArquivoOrigemDoctos     = cDirLayout + 'im0640-doctos.rtf'
           cArquivoOrigemPedidos    = cDirLayout + 'im0640-pedidos.rtf'
           cArquivoOrigemRodape     = cDirLayout + 'im0640-rodape.rtf'
           cArquivoAuxiliar         = cDirLayout + 'arqaux.rtf'.

    IF tt-param.classifica = 1 THEN
        RUN piValidarArquivoLayout (INPUT cArquivoOrigemCabecProc  ,INPUT 27066).
    ELSE
        RUN piValidarArquivoLayout (INPUT cArquivoOrigemCabecEmb   ,INPUT 27066).

    RUN piValidarArquivoLayout (INPUT cArquivoOrigemPedidos    ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemCabecItens ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemItens      ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemCondPagto  ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemCabecDocto ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemDoctos     ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemRodape     ,INPUT 27066).    

    IF  tt-param.classifica = 1 THEN DO:
    
        IF  CAN-FIND(FIRST tt-documentos-erros
                         where tt-documentos-erros.cod-estabel = tt-processo-aux.cod-estabel
                         and   tt-documentos-erros.nr-proc-imp = tt-processo-aux.nr-proc-imp) THEN           
            RETURN "NOK".
    end.
    else do:
        IF  CAN-FIND(FIRST tt-documentos-erros
                         where tt-documentos-erros.cod-estabel = tt-embarque.cod-estabel
                         and   tt-documentos-erros.embarque    = tt-embarque.embarque) THEN           
            RETURN "NOK".
    end.

    EMPTY TEMP-TABLE tt-matriz-ficha.
    EMPTY TEMP-TABLE tt-ficha.
    
    IF tt-param.classifica = 1 THEN 
        RUN piImportarRTFs (INPUT cArquivoOrigemCabecProc ,INPUT 1).
    ELSE DO:
        RUN piImportarRTFs (INPUT cArquivoOrigemCabecEmb ,INPUT 1).
        RUN piImportarRTFs (INPUT cArquivoOrigemPedidos  ,INPUT 2).    
    END.                                                   
    
    RUN piImportarRTFs (INPUT cArquivoOrigemCabecItens ,INPUT 3).
    RUN piImportarRTFs (INPUT cArquivoOrigemItens      ,INPUT 4).
    RUN piImportarRTFs (INPUT cArquivoOrigemCondPagto  ,INPUT 5).
    RUN piImportarRTFs (INPUT cArquivoOrigemCabecDocto ,INPUT 6).
    RUN piImportarRTFs (INPUT cArquivoOrigemDoctos     ,INPUT 7).
    RUN piImportarRTFs (INPUT cArquivoOrigemRodape     ,INPUT 8).

    return "OK":U.
END PROCEDURE.

PROCEDURE piVerificarDirArqLayout:
    
    IF  tt-param.l-layout-pad-fornec THEN /* Utiliza arquivo PadrÆo do Cliente */
        ASSIGN cDirLayout = tt-exportador-aux.des-layout-origin-instruc-embarq.
    ELSE  /* Layout PadrÆo para todos informado na inteface do relatorio */
        ASSIGN cDirLayout = tt-param.c-layout-pad-fornec.
 
    ASSIGN cDirLayout = IF LENGTH (cDirLayout) > 3 AND SUBSTR(cDirLayout, LENGTH(cDirLayout), 1) <> "~\" THEN (cDirLayout + "~\") 
                        ELSE cDirLayout.
    
    ASSIGN cDirLayout = TRIM(cDirLayout).

    ASSIGN tt-param.c-dir-destino = IF  LENGTH (tt-param.c-dir-destino) > 3 
                                    AND SUBSTR(tt-param.c-dir-destino, LENGTH(tt-param.c-dir-destino), 1) <> "~\" THEN
                                        (tt-param.c-dir-destino + "~\") 
                                    ELSE tt-param.c-dir-destino.
END PROCEDURE.

PROCEDURE piValidarArquivoLayout:
    DEFINE INPUT PARAMETER pcArquivo AS CHARACTER.
    DEFINE INPUT PARAMETER piCodErro AS INTEGER.

    DEFINE VARIABLE iSeq     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDescMsg AS CHARACTER  NO-UNDO.
    
    IF  SEARCH(pcArquivo) = ? THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT piCodErro,
                           INPUT pcArquivo).
        ASSIGN cDescMsg = RETURN-VALUE.

        CREATE tt-documentos-erros.
        ASSIGN tt-documentos-erros.nome-abrev = tt-exportador-aux.nome-abrev
               tt-documentos-erros.cod-erro    = piCodErro
               tt-documentos-erros.mensagem    = cDescMsg.              

        IF  tt-param.classifica = 1  THEN
            ASSIGN tt-documentos-erros.cod-estabel = tt-processo-aux.cod-estabel
                   tt-documentos-erros.nr-proc-imp = tt-processo-aux.nr-proc-imp     
                   tt-documentos-erros.num-pedido  = tt-processo-aux.num-pedido      
                   tt-documentos-erros.dt-embarque = tt-inst-emb.dt-embarque.
        ELSE
            ASSIGN tt-documentos-erros.cod-estabel = tt-embarque.cod-estabel
                   tt-documentos-erros.embarque    = tt-embarque.embarque
                   tt-documentos-erros.dt-embarque = tt-inst-emb.dt-embarque.
    END.

END PROCEDURE.

PROCEDURE piImportarRTFs:
    DEFINE INPUT PARAMETER pcArquivo    AS CHARACTER FORMAT "x(30)" NO-UNDO.
    DEFINE INPUT PARAMETER piFormulario AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iCont               AS INTEGER   NO-UNDO.

    /* Importa para uma temp-table todas as linhas do arquivo de cabe‡alho */
    IF SEARCH(pcArquivo) <> ? THEN DO:
       INPUT FROM VALUE(pcArquivo).
       REPEAT:
           CREATE tt-matriz-ficha.
           ASSIGN tt-matriz-ficha.i-formulario = piFormulario.
           IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
       END.
       INPUT CLOSE.
    END.
END PROCEDURE.

PROCEDURE piValidarArquivoFinal:
   
    IF SEARCH(cArquivoFinal) <> ? AND (NOT tt-param.l-sobrepor) THEN DO:

       RUN utp/ut-msgs.p (INPUT "msg",
                          INPUT 5455,
                          INPUT cArquivoFinal).
       
        CREATE tt-documentos-erros.
        ASSIGN tt-documentos-erros.nome-abrev    = tt-exportador-aux.nome-abrev
               tt-documentos-erros.cod-erro      = 5455
               tt-documentos-erros.mensagem      = RETURN-VALUE.
        IF tt-param.classifica = 1  THEN
            ASSIGN tt-documentos-erros.cod-estabel   = tt-processo-aux.cod-estabel
                   tt-documentos-erros.nr-proc-imp   = tt-processo-aux.nr-proc-imp     
                   tt-documentos-erros.num-pedido    = tt-processo-aux.num-pedido      
                   tt-documentos-erros.dt-embarque   = tt-inst-emb.dt-embarque.
        ELSE
            ASSIGN tt-documentos-erros.cod-estabel   = tt-embarque.cod-estabel
                   tt-documentos-erros.embarque      = tt-embarque.embarque
                   tt-documentos-erros.dt-embarque   = tt-inst-emb.dt-embarque.

       RETURN "NOK".
    END.
    RETURN "OK".

END PROCEDURE.


PROCEDURE piSalvarArquivo:

    ch-Documento:SaveAs(cArquivoFinal).    
    ch-app-word:SELECTION:PageSetup:Orientation = tt-param.i-orientacao. /* Seleciona a Orienta‡Æo de ImpressÆo 0-Retrato / 1-Paisagem*/
    
    IF tt-param.classifica = 1  THEN DO:
        IF NOT AVAIL tt-processo-aux THEN
            FIND FIRST tt-processo-aux NO-ERROR.
        FIND param-imp NO-LOCK  
            WHERE param-imp.cod-estabel = tt-processo-aux.cod-estabel NO-ERROR.
    END.
    ELSE DO:
        IF NOT AVAIL tt-embarque THEN
            FIND FIRST tt-embarque NO-ERROR.
        
        FIND param-imp NO-LOCK  
            WHERE param-imp.cod-estabel = tt-embarque.cod-estabel NO-ERROR.
    END.
                                                     
    IF AVAIL param-imp AND 
             param-imp.des-senha-docto <> "" AND
             param-imp.des-senha-docto <> ? THEN
       ch-Documento:Protect(2 , yes, param-imp.des-senha-docto).    
    ch-Documento:CLOSE(). /* Fecha o arquivo do WORD */
    OS-DELETE VALUE(cArquivoAuxiliar) NO-ERROR.
    RUN piDocumentosImpressos IN THIS-PROCEDURE.
    IF tt-param.l-envia-docto-fornec 
    OR tt-param.c-arquivo-copia <> "" THEN
        RUN piEnviarEmail.

END PROCEDURE.                                       

PROCEDURE piSubstituiValores:
    DEFINE INPUT PARAMETER pcPrefixo AS CHARACTER.
    DEFINE INPUT PARAMETER phTable   AS HANDLE.

    DEFINE VARIABLE iCont        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iCont2       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE searchStr    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cValor       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-prox       AS LOGICAL    NO-UNDO.

    EMPTY TEMP-TABLE tt-fields.

    DO iCont = 1 TO phTable:NUM-FIELDS:
        ASSIGN hField = phTable:BUFFER-FIELD(iCont).
        CREATE tt-fields.
        ASSIGN tt-fields.FILE-NAME  = phTable:NAME
               tt-fields.field-name = pcPrefixo + hField:NAME
               tt-fields.name-size  = LENGTH(pcPrefixo + hField:NAME).
    END.
    
    DO iCont = 1 TO phTable:NUM-FIELDS:

        ASSIGN l-prox = NO.

        ASSIGN hField = phTable:BUFFER-FIELD(iCont).
        
        IF hField:EXTENT > 0 THEN DO:
            DO  iCont2 = 1 TO hField:EXTENT:
                ASSIGN searchStr = pcPrefixo + hField:NAME + STRING(iCont2).

                IF hField:BUFFER-VALUE(iCont2) = ? THEN 
                    ASSIGN cValor = "".
                ELSE IF hField:DATA-TYPE = "logical" THEN
                    ASSIGN cValor = STRING(hField:BUFFER-VALUE(iCont2), "Sim/NÆo").
                ELSE DO:
                    FIND FIRST tt-formato WHERE
                        tt-formato.nome-tt  = phTable:NAME AND
                        tt-formato.campo-tt = hField:NAME NO-ERROR.
                    IF AVAILABLE tt-formato THEN
                        ASSIGN cValor = STRING(hField:BUFFER-VALUE(iCont2), tt-formato.formato).
                    ELSE
                        ASSIGN cValor = hField:BUFFER-VALUE(iCont2).
                END.

                IF tt-param.l-traducao THEN
                    RUN piTraducao (INPUT-OUTPUT cValor).
                FOR EACH tt-fields WHERE
                    tt-fields.FILE-NAME = phTable:NAME AND
                    tt-fields.field-name BEGINS (pcPrefixo + hField:NAME):
                    FOR EACH btt-fields WHERE
                        btt-fields.FILE-NAME = phTable:NAME AND
                        btt-fields.field-name BEGINS (pcPrefixo + hField:NAME) AND
                        btt-fields.name-size > LENGTH(pcPrefixo + hField:NAME):

                        IF tt-ficha.c-linha MATCHES ('*' + btt-fields.field-name + STRING(iCont2) + '*') THEN DO:
                            ASSIGN l-prox = YES.
                        END.
                    END.
                    IF l-prox = YES THEN LEAVE.
                    ELSE DO:
                        IF  tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN 
                            ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cValor).
                    END.
                END.
            END.
        END.
        ELSE DO:
            ASSIGN searchStr = pcPrefixo + hField:NAME.
            
            IF hField:BUFFER-VALUE = ? THEN 
                ASSIGN cValor = "".
            ELSE IF hField:DATA-TYPE = "logical" THEN
                ASSIGN cValor = STRING(hField:BUFFER-VALUE, "Sim/NÆo").
            ELSE DO:
                FIND FIRST tt-formato WHERE
                    tt-formato.nome-tt  = phTable:NAME AND
                    tt-formato.campo-tt = hField:NAME NO-ERROR.
                IF AVAILABLE tt-formato THEN
                    ASSIGN cValor = STRING(hField:BUFFER-VALUE, tt-formato.formato).
                ELSE
                    ASSIGN cValor = hField:BUFFER-VALUE.
            END.

            IF tt-param.l-traducao THEN
                RUN piTraducao (INPUT-OUTPUT cValor).
            FOR EACH tt-fields WHERE
                tt-fields.FILE-NAME = phTable:NAME AND
                tt-fields.field-name BEGINS (pcPrefixo + hField:NAME):

                FOR EACH btt-fields WHERE
                    btt-fields.FILE-NAME = phTable:NAME AND
                    btt-fields.field-name BEGINS (pcPrefixo + hField:NAME) AND
                    btt-fields.name-size > LENGTH(pcPrefixo + hField:NAME):

                    IF tt-ficha.c-linha MATCHES ('*' + btt-fields.field-name + '*') THEN DO:
                        ASSIGN l-prox = YES.
                    END.
                END.
                IF l-prox = YES THEN LEAVE.
                ELSE DO:
                    IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN 
                        ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cValor).
                END.
            END.
        END.
    END.    
                 
END PROCEDURE.

PROCEDURE pi-epc:
    
    FOR EACH tt-epc:
        IF tt-ficha.c-linha MATCHES ('*' + tt-epc.cod-parameter + '*') THEN
           ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
    END.        

END PROCEDURE.


PROCEDURE piLitToken:

    DEFINE VARIABLE cLabel AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-token.
    RUN piCriarTTTokens IN THIS-PROCEDURE (INPUT "#lit-",
                                           INPUT tt-ficha.c-linha,
                                           OUTPUT TABLE tt-token).
    IF CAN-FIND(FIRST tt-token) THEN DO:
        FOR EACH tt-token:
            IF tt-ficha.c-linha MATCHES ('*' + tt-token.token + '*') THEN DO:
                ASSIGN cLabel = REPLACE(tt-token.token,"#lit-","")
                       cLabel = REPLACE(cLabel,"-","_").

                run utp/ut-liter.p (input cLabel,
                                    input "*",
                                    input "") no-error.

                ASSIGN cLabel = RETURN-VALUE.

                IF tt-param.l-traducao THEN
                    RUN piTraducao (INPUT-OUTPUT cLabel).

                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-token.token, cLabel).
            END.
        END.
    END.
END PROCEDURE.

/* Traducao */
PROCEDURE piTraduzirLiterais:
    DEFINE INPUT PARAMETER cPrefixo   AS CHARACTER  NO-UNDO.    
    DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE i-tamanho-ant AS INTEGER NO-UNDO.
    DEFINE VARIABLE c-campo       LIKE tt-traduz-tt.campo-tt.
        
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Traduz_Literais" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + cPrefixo + '*'):

        IF NOT CAN-FIND(FIRST tt-traduz-tt USE-INDEX campo WHERE
                     tt-matriz-ficha.c-linha MATCHES ('*#lit-' + tt-traduz-tt.campo-tt + '*')) THEN DO:

            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-',"").
        END.
        ELSE DO:
            ASSIGN i-tamanho-ant = 0
                   c-campo       = ""
                   clabel        = "".
            FOR EACH tt-traduz-tt USE-INDEX campo
                WHERE tt-matriz-ficha.c-linha MATCHES ('*#lit-' + tt-traduz-tt.campo-tt + '*'):

                IF i-tamanho-ant < LENGTH("#lit-" + tt-traduz-tt.campo-tt) THEN DO:
                    IF tt-traduz-tt.desc-label <> "" THEN
                        ASSIGN cLabel = tt-traduz-tt.desc-label.
                    ELSE DO:    
                        RUN utp/ut-field.p (INPUT tt-traduz-tt.banco,
                                            INPUT tt-traduz-tt.tabela,
                                            INPUT tt-traduz-tt.campo,
                                            INPUT 1).
                        ASSIGN cLabel = IF RETURN-VALUE <> ? THEN RETURN-VALUE ELSE "".
                    END.

                    IF tt-param.l-traducao THEN
                        RUN piTraducao (INPUT-OUTPUT cLabel).
                      
                    ASSIGN c-campo       = tt-traduz-tt.campo-tt
                           i-tamanho-ant = LENGTH("#lit-" + tt-traduz-tt.campo-tt).
                END.
            END.   

            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-' + c-campo, cLabel).
        END.
    END.
END PROCEDURE.

PROCEDURE piCriarTTTokens:
    DEFINE INPUT  PARAMETER pcTokenIni AS CHAR.
    DEFINE INPUT  PARAMETER pcLinha    AS CHAR.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-token.

    DEFINE VARIABLE cCaracter AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cToken    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lLit      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iCont     AS INTEGER    NO-UNDO.

    FOR EACH tt-token:
        DELETE tt-token.
    END.

    DO iCont = 1 TO LENGTH(pcLinha):
       
       ASSIGN cCaracter = SUBSTRING(pcLinha,iCont,1).

       CASE cCaracter:
           WHEN "#" THEN DO:
               ASSIGN lLit = TRUE.
               ASSIGN cToken = cCaracter.
           END.
           WHEN "}" OR WHEN " " OR WHEN "~\" THEN DO:
               ASSIGN lLit = FALSE.
               IF INDEX(cToken,pcTokenIni) > 0 THEN DO:               
                   CREATE tt-token.
                   ASSIGN tt-token.token = cToken
                          cToken            = "".               
               END.
           END.
           OTHERWISE DO:
               IF lLit THEN
                  ASSIGN cToken = cToken + cCaracter.
           END.
       END CASE.

       IF iCont = LENGTH(pcLinha)      AND
          lLit = TRUE                  AND
          INDEX(cToken,pcTokenIni) > 0 AND
          NOT CAN-FIND(FIRST tt-token WHERE tt-token.token = cToken) THEN DO:              
           CREATE tt-token.
           ASSIGN tt-token.token = cToken
                  cToken            = "".               
       END.

    END.

END PROCEDURE.

PROCEDURE piTraducao:
    DEFINE INPUT-OUTPUT PARAMETER p-traducao AS CHARACTER NO-UNDO.
    {imp/im9998.i "p-traducao" "p-traducao" "tt-exportador-aux"}
END PROCEDURE.


/* E-Mail*/
PROCEDURE piEnviarEmail:

    DEFINE VARIABLE c-email-empresa AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-assunto       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-destino-email AS CHARACTER  NO-UNDO.
    
    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    {utp/ut-liter.i Envio_Instru‡Æo_Embarque * L}
    ASSIGN c-assunto = TRIM(RETURN-VALUE).

    IF tt-param.l-traducao THEN
       RUN piTraducao (INPUT-OUTPUT c-assunto).

    IF tt-param.classifica = 1 THEN
        c-assunto = c-assunto + "-" + tt-exportador-aux.nome-abrev + "-" + tt-processo-aux.nr-proc-imp + "-" + STRING(tt-inst-emb.dt-embarque).
    ELSE
        c-assunto = c-assunto + "-" + tt-exportador-aux.nome-abrev + "-" + tt-embarque.embarque.

    FOR FIRST param-global FIELDS(log-1 serv-mail porta-mail) NO-LOCK:
    END.

    FOR FIRST empresa FIELDS(e-mail) WHERE 
              empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
    END.

    IF AVAIL empresa THEN
       ASSIGN c-email-empresa = empresa.e-mail.

    
    IF tt-param.l-envia-docto-fornec THEN 
        ASSIGN c-destino-email = tt-exportador-aux.e-mail.
    ELSE
        ASSIGN c-destino-email = "".
    
    IF c-destino-email = "":U 
    AND tt-param.c-arquivo-copia <> "":U THEN
        ASSIGN c-destino-email          = tt-param.c-arquivo-copia.
        
    
    IF c-destino-email <> "":U THEN DO:
    
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.exchange          = param-global.log-1 
              tt-envio2.servidor          = param-global.serv-mail
              tt-envio2.porta             = param-global.porta-mail
              tt-envio2.destino           = c-destino-email
              tt-envio2.assunto           = c-assunto
              tt-envio2.remetente         = c-email-empresa
              tt-envio2.copia             = IF tt-param.c-arquivo-copia = c-destino-email THEN "" ELSE tt-param.c-arquivo-copia
              tt-envio2.mensagem          = "":U
              tt-envio2.importancia       = 1
              tt-envio2.log-enviada       = YES 
              tt-envio2.log-lida          = NO
              tt-envio2.acomp             = NO
              tt-envio2.arq-anexo         = cArquivoFinal.
    
       /* API de envio eletr“nico */       
       RUN utp/utapi019.p PERSISTENT SET h-utapi019.
       RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                      INPUT  TABLE tt-mensagem,
                                      OUTPUT TABLE tt-erros).
       DELETE PROCEDURE h-utapi019.
    END.

END PROCEDURE.

/* EPC */

PROCEDURE piIncluirDocumento:
    ch-Documento = ch-app-word:Documents:ADD(). /* Cria um novo documento no WORD */
    ch-app-word:WindowState = 2. /* Deixa o aplicativo minimizado */
    ch-app-word:VISIBLE = TRUE.    /* O aplicativo fica em background */
    ch-app-word:ScreenUpdating = FALSE.

END PROCEDURE.

/* Substituir valores no formulario */
PROCEDURE piGerarFormulario:
 
    DEFINE INPUT PARAMETER piFormulario    AS INTEGER NO-UNDO.
    
    FOR EACH tt-ficha:
        DELETE tt-ficha.
    END.
    
    FOR EACH tt-matriz-ficha WHERE
             tt-matriz-ficha.i-formulario = piFormulario:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
    END.                      
    RETURN "OK".              
END PROCEDURE.

PROCEDURE piImprimirNoArquivo:

    /* Para cada registro da temp-table gerada, imprime essa informa‡Æo no arquivo auxiliar que est  aberto */
    FOR EACH tt-ficha:
        RUN trocaCaracterEspecial (INPUT-OUTPUT tt-ficha.c-linha).
        IF  tt-ficha.c-linha = '' THEN
            PUT UNFORMATTED SKIP(1).
        ELSE DO:
            PUT UNFORMATTED tt-ficha.c-linha SKIP.
        END.
        DELETE tt-ficha.
    END.

    /* Isso ‚ obrigado a ter no final de um RTF */
    PUT UNFORMATTED '~\par }}'.
END PROCEDURE.

PROCEDURE piDocumentosImpressos:
    
    CREATE tt-documentos-impressos.
    ASSIGN tt-documentos-impressos.destino    = cArquivoFinal
           tt-documentos-impressos.nome-abrev = tt-exportador-aux.nome-abrev.

    IF tt-param.classifica = 1 THEN
        ASSIGN tt-documentos-impressos.cod-estabel   = tt-processo-aux.cod-estabel
               tt-documentos-impressos.nr-proc-imp   = tt-processo-aux.nr-proc-imp
               tt-documentos-impressos.num-pedido    = tt-processo-aux.num-pedido    
               tt-documentos-impressos.dt-embarque   = tt-inst-emb.dt-embarque.
    ELSE
        ASSIGN tt-documentos-impressos.cod-estabel   = tt-embarque.cod-estabel
               tt-documentos-impressos.embarque      = tt-embarque.embarque.
END PROCEDURE.                                                            
/* EOF */
