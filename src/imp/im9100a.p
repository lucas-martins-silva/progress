/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9100A 2.00.00.005 } /*** "010005" 23/09/2024 08:51:53  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9100a MIM}
&ENDIF

{imp/im9100.i}     /* tt-param */
{imp/imapi009.i}
{imp/imapi009.i2}
{imp/imapi009.i4}
{exp/ex9998.i}     /* Procedure trocaCaracterEspecial */
{utp/utapi019.i}   /* Include API CORREIO ELETRâNICO  */
{include/i-epc200.i IM9100A}


/**************************** Parƒmetros ****************************/
DEFINE INPUT  PARAMETER TABLE FOR tt-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-emb-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-emb-aux2.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-emb-aux3.
DEFINE INPUT  PARAMETER TABLE FOR tt-fabr-ped-compr-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-ncm-fabr-ped-compr-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-ncm-fabr-ped-compr-emb.
DEFINE INPUT  PARAMETER TABLE FOR tt-desp-embarque.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo-imp.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo-imp-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo-imp-aux2.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo-imp-aux3.
DEFINE INPUT  PARAMETER TABLE FOR tt-fabr-processo-imp.
DEFINE INPUT  PARAMETER TABLE FOR tt-ncm-fabr-processo-imp.
DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-ncm-fabr-processo-imp.
DEFINE INPUT  PARAMETER TABLE FOR tt-desp-pedido.
DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE INPUT  PARAMETER phAcomp  AS HANDLE.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-documentos-impressos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-erros.

/********************** Defini‡Æo de vari veis **********************/
DEFINE VARIABLE cDirLayout                    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cArquivoOrigemEmbarque   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemPedidos    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemFabric     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemNcm        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemOrdens     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemTotNcm     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemTotFabric  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemTotPedidos AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoOrigemTotEmb     AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoOrigemDespesas   AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoAuxiliar         AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cArquivoFinal            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAssuntoEmail            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ch-app-word              AS office.iface.word.WordWrapper NO-UNDO.
DEFINE VARIABLE ch-Documento             AS office.iface.word.Document NO-UNDO.
DEFINE VARIABLE c-desc-erro              AS CHARACTER  NO-UNDO.
define variable c-destino                as char       no-undo.
define variable c-val-upc                as char       no-undo.
DEFINE VARIABLE searchStr                AS CHARACTER  NO-UNDO.

/********************* Defini‡Æo de temp-tables **********************/
DEFINE TEMP-TABLE tt-matriz-ficha NO-UNDO
     FIELD c-linha       AS CHARACTER FORMAT 'x(300)'
     FIELD i-formulario  AS INTEGER.

DEFINE TEMP-TABLE tt-ficha NO-UNDO
     FIELD c-linha      AS CHARACTER FORMAT 'x(300)'
     FIELD i-formulario AS INTEGER.

DEFINE TEMP-TABLE tt-formato NO-UNDO
   FIELD nome-tt    AS CHARACTER 
   FIELD campo-tt   AS CHARACTER 
   FIELD formato    AS character.

{imp/im9100a.i} /* procedure pi-cria-formato */
RUN pi-cria-formato.

/************************** Main Block *****************************/
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-documentos-erros: 
    DELETE tt-documentos-erros.
END.

/* Carrega o WORD para a  mem¢ria */
{office/office.i Word ch-app-word}

ch-app-word:WindowState = 2. /* Deixa o aplicativo minimizado */
ch-app-word:VISIBLE = FALSE.    /* O aplicativo fica em background */    

RUN pi-seta-titulo IN phAcomp (INPUT "Gerando arquivos do WORD").    

RUN piGerarRelatorio.

IF VALID-OBJECT(ch-app-word) THEN DO:    
    ch-app-word:QUIT(). /* Fechar o WORD */        
    DELETE OBJECT ch-app-word.
END.

/**************************** Procedure Internas *****************************/

PROCEDURE piGerarRelatorio:
    
    find first tt-emb no-error.
    find first tt-processo-imp no-error.
    run piCarregarArquivos.
    
    IF CAN-FIND(FIRST tt-documentos-erros) THEN           
        RETURN "NOK".
    
    RUN piIncluirDocumento.
    RUN geraArquivo.
    
END PROCEDURE.              

PROCEDURE geraArquivo:
    
    IF tt-param.iSeleciona = 1 THEN DO:
        RUN piImprimirProcesso IN THIS-PROCEDURE.
    END.
    ELSE DO:
        RUN piImprimirEmbarque IN this-procedure.
    END.
    find FIRST tt-documentos-erros no-error.
    if not avail tt-documentos-erros then
        RUN piSalvarArquivo IN THIS-PROCEDURE.

END PROCEDURE.


/* Procedures para geracao dos RTF's */

PROCEDURE piImprimirEmbarque:
    
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.
    
    RUN piGerarFormulario(INPUT 1).
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Embarque" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-emb:

        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        assign c-val-upc = tt-emb.cod-estabel + ";" + tt-emb.embarque.

        RUN piCreateTtEpc (INPUT "Custom-Fields-Embarque", "chaveEmbarque", c-val-upc).
        {include/i-epc201.i "Custom-Fields-Embarque"}

       
        FIND FIRST tt-pedido-compr-emb-aux
             WHERE tt-pedido-compr-emb-aux.cod-estabel  = tt-emb.cod-estabel
             AND   tt-pedido-compr-emb-aux.embarque     = tt-emb.embarque NO-ERROR.

        find first emitente where emitente.cod-emitente = tt-emb.cod-despachante no-lock no-error.
        assign c-destino = if avail emitente then emitente.e-mail else "".

        find first emitente where emitente.cod-emitente = tt-pedido-compr-emb-aux.cod-exportador no-lock no-error.
        if avail emitente then do:
            if tt-param.indDocto = 1 then
                assign cArquivoFinal = tt-param.cDirDestino + tt-pedido-compr-emb-aux.cod-estabel + "-" 
                                     + emitente.nome-abrev  + "-" + tt-pedido-compr-emb-aux.embarque + '.doc'
                       cAssuntoEmail = tt-pedido-compr-emb-aux.cod-estabel + "-" 
                                     + emitente.nome-abrev  + "-" + tt-pedido-compr-emb-aux.embarque.
            else
                assign cArquivoFinal = tt-param.cDirDestino + emitente.nome-abrev + "-" 
                                     + tt-pedido-compr-emb-aux.cod-estabel  + "-" + tt-pedido-compr-emb-aux.embarque + '.doc'
                       cAssuntoEmail = emitente.nome-abrev + "-" 
                                     + tt-pedido-compr-emb-aux.cod-estabel  + "-" + tt-pedido-compr-emb-aux.embarque.


        end.
        else
            ASSIGN cArquivoFinal = ""
                   cAssuntoEmail = "".
        
        RUN piValidarArquivoFinal.
        if return-value = "NOK":U then
            next.

        OUTPUT TO VALUE(cArquivoAuxiliar).
        FOR EACH tt-ficha:
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-emb:HANDLE).
        END.
        
        RUN piImprimirNoArquivo.
        OUTPUT CLOSE.             
        
        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).

        FOR EACH tt-matriz-ficha
            WHERE tt-matriz-ficha.i-formulario = 1:
            CREATE tt-ficha.
            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.      
        END.

        for each tt-pedido-compr-emb
           where tt-pedido-compr-emb.cod-estabel = tt-emb.cod-estabel
             and tt-pedido-compr-emb.embarque    = tt-emb.embarque
            break by tt-pedido-compr-emb.num-pedido:
           FIND FIRST tt-pedido-compr-emb-aux
                WHERE tt-pedido-compr-emb-aux.cod-estabel  = tt-pedido-compr-emb.cod-estabel
                AND   tt-pedido-compr-emb-aux.embarque     = tt-pedido-compr-emb.embarque
                AND   tt-pedido-compr-emb-aux.num-pedido   = tt-pedido-compr-emb.num-pedido NO-ERROR.
           FIND FIRST tt-pedido-compr-emb-aux2
                WHERE tt-pedido-compr-emb-aux2.cod-estabel = tt-pedido-compr-emb.cod-estabel
                AND   tt-pedido-compr-emb-aux2.embarque    = tt-pedido-compr-emb.embarque
                AND   tt-pedido-compr-emb-aux2.num-pedido  = tt-pedido-compr-emb.num-pedido NO-ERROR.
           FIND FIRST tt-pedido-compr-emb-aux3
                WHERE tt-pedido-compr-emb-aux3.cod-estabel = tt-pedido-compr-emb.cod-estabel
                AND   tt-pedido-compr-emb-aux3.embarque    = tt-pedido-compr-emb.embarque
                AND   tt-pedido-compr-emb-aux3.num-pedido  = tt-pedido-compr-emb.num-pedido NO-ERROR.

            /*Pedidos*/
            RUN piGerarFormulario(INPUT 2).
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Pedido" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.

            RUN piCreateTtEpc (INPUT "Custom-Fields-Pedido", "chaveEmbarque", tt-pedido-compr-emb.num-pedido).
            {include/i-epc201.i "Custom-Fields-Pedido"}

            OUTPUT TO VALUE(cArquivoAuxiliar).
            FOR EACH tt-ficha:
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-emb:HANDLE).
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-emb-aux:HANDLE).
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-emb-aux2:HANDLE).
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-emb-aux3:HANDLE).
            END.
                
            RUN piImprimirNoArquivo. 
            OUTPUT CLOSE.      

            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
        
            FOR EACH tt-matriz-ficha 
                WHERE tt-matriz-ficha.i-formulario = 2:
                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
            END.

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Fabricante" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
            for each tt-fabr-ped-compr-emb
               where tt-fabr-ped-compr-emb.cod-estabel = tt-pedido-compr-emb.cod-estabel
                 and tt-fabr-ped-compr-emb.embarque    = tt-pedido-compr-emb.embarque   
                 and tt-fabr-ped-compr-emb.num-pedido  = tt-pedido-compr-emb.num-pedido
                break by tt-fabr-ped-compr-emb.cod-fabricante:

                /*Fabricantes*/
                RUN piGerarFormulario(INPUT 3).

                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
                
                RUN piCreateTtEpc (INPUT "Custom-Fields-Fabricante", "chaveEmbarque", tt-fabr-ped-compr-emb.cod-fabricante).
                {include/i-epc201.i "Custom-Fields-Fabricante"}

                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-fabr-ped-compr-emb:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 3:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.

                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Imprime_NCM" *}
                RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
        
                for each tt-ncm-fabr-ped-compr-emb
                   where tt-ncm-fabr-ped-compr-emb.cod-estabel    = tt-fabr-ped-compr-emb.cod-estabel
                     and tt-ncm-fabr-ped-compr-emb.embarque       = tt-fabr-ped-compr-emb.embarque           
                     and tt-ncm-fabr-ped-compr-emb.num-pedido     = tt-fabr-ped-compr-emb.num-pedido 
                     and tt-ncm-fabr-ped-compr-emb.cod-fabricante = tt-fabr-ped-compr-emb.cod-fabricante
                     break by tt-ncm-fabr-ped-compr-emb.cod-fabricante
                           by tt-ncm-fabr-ped-compr-emb.cod-ncm:

                    /*NCM*/
                    RUN piGerarFormulario(INPUT 4).
                    
                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.

                    RUN piCreateTtEpc (INPUT "Custom-Fields-NCM", "chaveEmbarque", tt-ncm-fabr-ped-compr-emb.cod-ncm).
                    {include/i-epc201.i "Custom-Fields-NCM"}

                    OUTPUT TO VALUE(cArquivoAuxiliar).
                    FOR EACH tt-ficha:
                        RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ncm-fabr-ped-compr-emb:HANDLE).
                    END.
                        
                    RUN piImprimirNoArquivo. 
                    OUTPUT CLOSE.             
                
                    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                
                    FOR EACH tt-matriz-ficha 
                        WHERE tt-matriz-ficha.i-formulario = 4:
                        CREATE tt-ficha.
                        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                    END.


                    for each  tt-ordem-ncm-fabr-ped-compr-emb
                        where tt-ordem-ncm-fabr-ped-compr-emb.cod-estabel    = tt-ncm-fabr-ped-compr-emb.cod-estabel
                          and tt-ordem-ncm-fabr-ped-compr-emb.embarque       = tt-ncm-fabr-ped-compr-emb.embarque            
                          and tt-ordem-ncm-fabr-ped-compr-emb.num-pedido     = tt-ncm-fabr-ped-compr-emb.num-pedido 
                          and tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante = tt-ncm-fabr-ped-compr-emb.cod-fabricante
                          and tt-ordem-ncm-fabr-ped-compr-emb.ncm            = tt-ncm-fabr-ped-compr-emb.cod-ncm
                          break by tt-ordem-ncm-fabr-ped-compr-emb.ncm:

                        /*Ordens NCM*/
                        RUN piGerarFormulario(INPUT 5).
                        
                        if tt-param.indDocto = 1 then
                            /* Inicio -- Projeto Internacional */
                            DO:
                            {utp/ut-liter.i "Imprime_Item" *}
                            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
                            END. 
                        else
                            /* Inicio -- Projeto Internacional */
                            DO:
                            {utp/ut-liter.i "Imprime_Ordem_NCM" *}
                            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
                            END. 

                        FOR EACH tt-epc:
                            DELETE tt-epc.
                        END.
                        
                        assign c-val-upc = tt-emb.cod-estabel + ";" + tt-emb.embarque.

                        RUN piCreateTtEpc (INPUT "Custom-Fields-OrdensNCM", "chaveEmbarque", tt-ordem-ncm-fabr-ped-compr-emb.numero-ordem).
                        {include/i-epc201.i "Custom-Fields-OrdensNCM"}
                        
                        OUTPUT TO VALUE(cArquivoAuxiliar).
                        FOR EACH tt-ficha:
                            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ordem-ncm-fabr-ped-compr-emb:HANDLE).
                        END.
                            
                        RUN piImprimirNoArquivo. 
                        OUTPUT CLOSE.             
                    
                        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                    
                        FOR EACH tt-matriz-ficha 
                            WHERE tt-matriz-ficha.i-formulario = 5:
                            CREATE tt-ficha.
                            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                        END.
                        
                    end.

                    if last-of(tt-ncm-fabr-ped-compr-emb.cod-ncm) then do:

                        /*total NCM*/
                        RUN piGerarFormulario(INPUT 6).
        
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-liter.i "Imprime_Total_NCM" *}
                        RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

                        FOR EACH tt-epc:
                            DELETE tt-epc.
                        END.
                
                        RUN piCreateTtEpc (INPUT "Custom-Fields-TotNCM", "chaveEmbarque", tt-ncm-fabr-ped-compr-emb.cod-ncm).
                        {include/i-epc201.i "Custom-Fields-TotNCM"}

                        OUTPUT TO VALUE(cArquivoAuxiliar).
                        FOR EACH tt-ficha:
                            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ncm-fabr-ped-compr-emb:HANDLE).
                        END.
                            
                        RUN piImprimirNoArquivo. 
                        OUTPUT CLOSE.             
                    
                        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                    
                        FOR EACH tt-matriz-ficha 
                            WHERE tt-matriz-ficha.i-formulario = 6:
                            CREATE tt-ficha.
                            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                        END.
                    end.
                end.

                if last-of(tt-fabr-ped-compr-emb.cod-fabricante) then do:

                    /*total fabricante*/
                    RUN piGerarFormulario(INPUT 7).
    
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Imprime_Total_Fabricante" *}
                    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.
            
                    RUN piCreateTtEpc (INPUT "Custom-Fields-TotFabricante", "chaveEmbarque", tt-fabr-ped-compr-emb.cod-fabricante).
                    {include/i-epc201.i "Custom-Fields-TotFabricante"}

                    OUTPUT TO VALUE(cArquivoAuxiliar).
                    FOR EACH tt-ficha:
                        RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-fabr-ped-compr-emb:HANDLE).
                    END.
                        
                    RUN piImprimirNoArquivo. 
                    OUTPUT CLOSE.             
                
                    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                
                    FOR EACH tt-matriz-ficha 
                        WHERE tt-matriz-ficha.i-formulario = 7:
                        CREATE tt-ficha.
                        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                    END.
    
                end.

            end.

            if last-of(tt-pedido-compr-emb.num-pedido) then do:

                /*total pedido*/
                RUN piGerarFormulario(INPUT 8).
    
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Imprime_Total_Pedido" *}
                RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
        
                RUN piCreateTtEpc (INPUT "Custom-Fields-TotPedido", "chaveEmbarque", tt-pedido-compr-emb.num-pedido).
                {include/i-epc201.i "Custom-Fields-TotPedido"}
    
                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-emb-aux3:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 8:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.
    
            end.
            
        end.
        
        /*Despesas*/
        if tt-param.indDocto = 2 then do:
        
            RUN piGerarFormulario(INPUT 10).
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Despesa" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
            for each tt-desp-embarque
               where tt-desp-embarque.cod-estabel = tt-emb.cod-estabel
                 and tt-desp-embarque.embarque =    tt-emb.embarque:
    
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
    
                assign c-val-upc = tt-desp-embarque.cod-estabel + ";" + 
                                   tt-desp-embarque.embarque + ";" +                
                                   string(tt-desp-embarque.cod-cond-pagto) + ";" +
                                   string(tt-desp-embarque.mo-codigo) + ";" +
                                   string(tt-desp-embarque.cod-desp) + ";" +
                                   string(tt-desp-embarque.cod-pto-contr) + ";" +
                                   string(tt-desp-embarque.cod-emitente-desp).
        
                RUN piCreateTtEpc (INPUT "Custom-Fields-Despesa", "chaveEmbarque", c-val-upc).
                {include/i-epc201.i "Custom-Fields-Despesa"}
                
                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-desp-embarque:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 10:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.
            end.

        end.
        /*Total Embarque*/
        RUN piGerarFormulario(INPUT 9).

        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        RUN piCreateTtEpc (INPUT "Custom-Fields-TotEmbarque", "chaveEmbarque", tt-emb.embarque).
        {include/i-epc201.i "Custom-Fields-TotEmbarque"}

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Imprime_Total_Embarque" *}
        RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
        
        OUTPUT TO VALUE(cArquivoAuxiliar).
        FOR EACH tt-ficha:
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-emb:HANDLE).
        END.
            
        RUN piImprimirNoArquivo. 
        OUTPUT CLOSE.             
    
        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
    
        FOR EACH tt-matriz-ficha 
            WHERE tt-matriz-ficha.i-formulario = 9:
            CREATE tt-ficha.
            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
        END.
    end.
END PROCEDURE.

PROCEDURE piImprimirProcesso:
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Imprime_Processo" *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    RUN piGerarFormulario(INPUT 2).

    FOR EACH tt-processo-imp
    break by tt-processo-imp.nr-proc-imp:
       FIND FIRST tt-processo-imp-aux
            WHERE tt-processo-imp-aux.cod-estabel  = tt-processo-imp.cod-estabel
            AND   tt-processo-imp-aux.nr-proc-imp  = tt-processo-imp.nr-proc-imp
            AND   tt-processo-imp-aux.num-pedido   = tt-processo-imp.num-pedido NO-ERROR.
       FIND FIRST tt-processo-imp-aux2
            WHERE tt-processo-imp-aux2.cod-estabel = tt-processo-imp.cod-estabel
            AND   tt-processo-imp-aux2.nr-proc-imp = tt-processo-imp.nr-proc-imp
            AND   tt-processo-imp-aux2.num-pedido  = tt-processo-imp.num-pedido NO-ERROR.
       FIND FIRST tt-processo-imp-aux3
            WHERE tt-processo-imp-aux3.cod-estabel = tt-processo-imp.cod-estabel
            AND   tt-processo-imp-aux3.nr-proc-imp = tt-processo-imp.nr-proc-imp
            AND   tt-processo-imp-aux3.num-pedido  = tt-processo-imp.num-pedido NO-ERROR.

        find first emitente where emitente.cod-emitente = tt-processo-imp-aux.cod-despachante no-lock no-error.
        assign c-destino = if avail emitente then emitente.e-mail else "".
       
        find first emitente where emitente.cod-emitente = tt-processo-imp-aux.cod-exportador no-lock no-error.
        if avail emitente then do:
            if tt-param.indDocto = 1 then
                ASSIGN cArquivoFinal = tt-param.cDirDestino + tt-processo-imp.cod-estabel + "-" 
                                 + emitente.nome-abrev  + "-" + tt-processo-imp.nr-proc-imp + '.doc'
                   cAssuntoEmail = tt-processo-imp.cod-estabel + "-" 
                                   + emitente.nome-abrev  + "-" + tt-processo-imp.nr-proc-imp.
            else
                ASSIGN cArquivoFinal = tt-param.cDirDestino + emitente.nome-abrev + "-" 
                                 + tt-processo-imp.cod-estabel  + "-" + tt-processo-imp.nr-proc-imp + '.doc'
                   cAssuntoEmail = emitente.nome-abrev + "-" 
                                   + tt-processo-imp.cod-estabel  + "-" + tt-processo-imp.nr-proc-imp.
        end.
        else
            assign cArquivoFinal = ""
                   cAssuntoEmail = "".
        
        
        RUN piValidarArquivoFinal.
        if return-value = "NOK":U then
            next.
        
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        RUN piCreateTtEpc (INPUT "Custom-Fields-Pedido", "chaveProcesso", tt-processo-imp.nr-proc-imp).
        {include/i-epc201.i "Custom-Fields-Pedido"}
        
        OUTPUT TO VALUE(cArquivoAuxiliar).

        FOR EACH tt-ficha
            WHERE tt-ficha.c-linha MATCHES('*#*'):
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-processo-imp:HANDLE).
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-processo-imp-aux:HANDLE).
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-processo-imp-aux2:HANDLE).
            RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-processo-imp-aux3:HANDLE).
        END.
        
        RUN piImprimirNoArquivo. 
        OUTPUT CLOSE.             

        ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).

        FOR EACH tt-matriz-ficha 
            WHERE tt-matriz-ficha.i-formulario = 2:
            CREATE tt-ficha.
            ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
        END.

        
        for each  tt-fabr-processo-imp
            where tt-fabr-processo-imp.cod-estabel = tt-processo-imp.cod-estabel
              and tt-fabr-processo-imp.nr-proc-imp = tt-processo-imp.nr-proc-imp            
              and tt-fabr-processo-imp.num-pedido  = tt-processo-imp.num-pedido
              break by tt-fabr-processo-imp.cod-fabricante:

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.

            /*Imprime Fabricante*/
            RUN piGerarFormulario(INPUT 3).
    
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Fabricante" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
            
            RUN piCreateTtEpc (INPUT "Custom-Fields-Fabricante", "chaveProcesso", tt-fabr-processo-imp.cod-fabricante).
            {include/i-epc201.i "Custom-Fields-Fabricante"}

             
            OUTPUT TO VALUE(cArquivoAuxiliar).
            FOR EACH tt-ficha:
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-fabr-processo-imp:HANDLE).
            END.
                
            RUN piImprimirNoArquivo. 
            OUTPUT CLOSE.             
        
            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
        
            FOR EACH tt-matriz-ficha 
                WHERE tt-matriz-ficha.i-formulario = 3:
                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.      
            END.              

            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_NCM" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
            
            for each  tt-ncm-fabr-processo-imp
                where tt-ncm-fabr-processo-imp.cod-estabel    = tt-fabr-processo-imp.cod-estabel
                  and tt-ncm-fabr-processo-imp.nr-proc-imp    = tt-fabr-processo-imp.nr-proc-imp            
                  and tt-ncm-fabr-processo-imp.num-pedido     = tt-fabr-processo-imp.num-pedido 
                  and tt-ncm-fabr-processo-imp.cod-fabricante = tt-fabr-processo-imp.cod-fabricante
                  break by tt-ncm-fabr-processo-imp.cod-ncm:

                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.

                /*Imprime NCM*/
                RUN piGerarFormulario(INPUT 4).
                
                RUN piCreateTtEpc (INPUT "Custom-Fields-NCM", "chaveProcesso", tt-ncm-fabr-processo-imp.cod-ncm).
                {include/i-epc201.i "Custom-Fields-NCM"}
                
                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ncm-fabr-processo-imp:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 4:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.              

                
                if tt-param.indDocto = 1 then
                    /* Inicio -- Projeto Internacional */
                    DO:
                    {utp/ut-liter.i "Imprime_Item" *}
                    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
                    END. 
                else
                    /* Inicio -- Projeto Internacional */
                    DO:
                    {utp/ut-liter.i "Imprime_Ordem_NCM" *}
                    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
                    END. 
                
                for each  tt-ordem-ncm-fabr-processo-imp
                    where tt-ordem-ncm-fabr-processo-imp.cod-estabel    = tt-ncm-fabr-processo-imp.cod-estabel
                      and tt-ordem-ncm-fabr-processo-imp.nr-proc-imp    = tt-ncm-fabr-processo-imp.nr-proc-imp            
                      and tt-ordem-ncm-fabr-processo-imp.num-pedido     = tt-ncm-fabr-processo-imp.num-pedido 
                      and tt-ordem-ncm-fabr-processo-imp.cod-fabricante = tt-ncm-fabr-processo-imp.cod-fabricante
                      and tt-ordem-ncm-fabr-processo-imp.ncm            = tt-ncm-fabr-processo-imp.cod-ncm
                      break by tt-ordem-ncm-fabr-processo-imp.ncm
                            by tt-ordem-ncm-fabr-processo-imp.numero-ordem:

                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.

                    /*Imprime Ordens NCM*/
                    RUN piGerarFormulario(INPUT 5).
            
                    RUN piCreateTtEpc (INPUT "Custom-Fields-OrdensNCM", "chaveProcesso", tt-ordem-ncm-fabr-processo-imp.numero-ordem).
                    {include/i-epc201.i "Custom-Fields-OrdensNCM"}
                    
                    OUTPUT TO VALUE(cArquivoAuxiliar).
                    FOR EACH tt-ficha:
                        RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ordem-ncm-fabr-processo-imp:HANDLE).
                    END.
                    
                    RUN piImprimirNoArquivo. 
                    OUTPUT CLOSE.             
                
                    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                
                    FOR EACH tt-matriz-ficha 
                        WHERE tt-matriz-ficha.i-formulario = 5:
                        CREATE tt-ficha.
                        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                    END.
                end.

                if last-of(tt-ncm-fabr-processo-imp.cod-ncm) then do:

                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.
            
                    RUN piCreateTtEpc (INPUT "Custom-Fields-TotNCM", "chaveProcesso", tt-ncm-fabr-processo-imp.cod-ncm).
                    {include/i-epc201.i "Custom-Fields-TotNCM"}
                    
                    /*total NCM*/
                    RUN piGerarFormulario(INPUT 6).
                    
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Imprime_Total_NCM" *}
                    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

                    OUTPUT TO VALUE(cArquivoAuxiliar).
                    FOR EACH tt-ficha:
                        RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-ncm-fabr-processo-imp:HANDLE).
                    END.
                        
                    RUN piImprimirNoArquivo. 
                    OUTPUT CLOSE.             
                
                    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
                
                    FOR EACH tt-matriz-ficha 
                        WHERE tt-matriz-ficha.i-formulario = 6:
                        CREATE tt-ficha.
                        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                    END.

                end.
            end.

            if last-of(tt-fabr-processo-imp.cod-fabricante) then do:

                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
        
                RUN piCreateTtEpc (INPUT "Custom-Fields-TotFabricante", "chaveProcesso", tt-fabr-processo-imp.cod-fabricante).
                {include/i-epc201.i "Custom-Fields-TotFabricante"}

                /*total fabricante*/
                RUN piGerarFormulario(INPUT 7).

                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Imprime_Total_Fabricante" *}
                RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).

                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-fabr-processo-imp:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 7:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.

            end.

        end.

        /*Despesas*/
        if tt-param.indDocto = 2 then do:

            RUN piGerarFormulario(INPUT 10).
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Despesa" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    
            for each tt-desp-pedido
               where tt-desp-pedido.num-pedido = tt-processo-imp.num-pedido:      
    
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.

                assign c-val-upc = string(tt-desp-pedido.num-pedido) + ";" + 
                                   string(tt-desp-pedido.cod-desp) + ";" +
                                   string(tt-desp-pedido.cod-cond-pagto) + ";" +
                                   string(tt-desp-pedido.cod-emitente-desp) + ";" +
                                   string(tt-desp-pedido.mo-codigo) + ";" +
                                   string(tt-desp-pedido.cod-pto-contr).
        
                RUN piCreateTtEpc (INPUT "Custom-Fields-Despesa", "chaveProcesso", c-val-upc).
                {include/i-epc201.i "Custom-Fields-Despesa"}
    
                
                OUTPUT TO VALUE(cArquivoAuxiliar).
                FOR EACH tt-ficha:
                    RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-desp-pedido:HANDLE).
                END.
                    
                RUN piImprimirNoArquivo. 
                OUTPUT CLOSE.             
            
                ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
            
                FOR EACH tt-matriz-ficha 
                    WHERE tt-matriz-ficha.i-formulario = 10:
                    CREATE tt-ficha.
                    ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
                END.
            end.

        end.

        /*Total Processo*/
        if last-of(tt-processo-imp.nr-proc-imp) then do:

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.

            RUN piCreateTtEpc (INPUT "Custom-Fields-TotPedido", "chaveProcesso", tt-processo-imp.nr-proc-imp).
            {include/i-epc201.i "Custom-Fields-TotPedido"}

            RUN piGerarFormulario(INPUT 8).
        
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Imprime_Total_Processo" *}
            RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
            
            OUTPUT TO VALUE(cArquivoAuxiliar).
            FOR EACH tt-ficha:
                RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-processo-imp-aux3:HANDLE).
            END.
                
            RUN piImprimirNoArquivo. 
            OUTPUT CLOSE.             
        
            ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).
        
            FOR EACH tt-matriz-ficha 
                WHERE tt-matriz-ficha.i-formulario = 8:
                CREATE tt-ficha.
                ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.        
            END.
        end.
    END.
    
END PROCEDURE.

PROCEDURE pi-substitui-val-epc:
    
    FOR EACH tt-epc:
        IF tt-ficha.c-linha MATCHES ('*' + tt-epc.cod-parameter + '*') THEN
           ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
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
    if tt-param.indDocto = 1 then
        ASSIGN cArquivoOrigemEmbarque   = cDirLayout + 'im0690-embarque.rtf'
               cArquivoOrigemPedidos    = cDirLayout + 'im0690-pedidos.rtf'
               cArquivoOrigemFabric     = cDirLayout + 'im0690-fabric.rtf'
               cArquivoOrigemNcm        = cDirLayout + 'im0690-ncm.rtf'
               cArquivoOrigemOrdens     = cDirLayout + 'im0690-itens.rtf'
               cArquivoOrigemTotNcm     = cDirLayout + 'im0690-tot-ncm.rtf'
               cArquivoOrigemTotFabric  = cDirLayout + 'im0690-tot-fabric.rtf'
               cArquivoOrigemTotPedidos = cDirLayout + 'im0690-tot-pedidos.rtf'
               cArquivoOrigemTotEmb     = cDirLayout + 'im0690-tot-emb.rtf'
               cArquivoAuxiliar         = cDirLayout + 'arqaux.rtf'.
    else
        ASSIGN cArquivoOrigemEmbarque   = cDirLayout + 'im0680-embarque.rtf'
               cArquivoOrigemPedidos    = cDirLayout + 'im0680-pedidos.rtf'
               cArquivoOrigemFabric     = cDirLayout + 'im0680-fabric.rtf'
               cArquivoOrigemNcm        = cDirLayout + 'im0680-ncm.rtf'
               cArquivoOrigemOrdens     = cDirLayout + 'im0680-ordens.rtf'
               cArquivoOrigemTotNcm     = cDirLayout + 'im0680-tot-ncm.rtf'
               cArquivoOrigemTotFabric  = cDirLayout + 'im0680-tot-fabric.rtf'
               cArquivoOrigemTotPedidos = cDirLayout + 'im0680-tot-pedidos.rtf'
               cArquivoOrigemTotEmb     = cDirLayout + 'im0680-tot-emb.rtf'
               cArquivoOrigemDespesas   = cDirLayout + 'im0680-despesas.rtf'
               cArquivoAuxiliar         = cDirLayout + 'arqaux.rtf'.
        

    RUN piValidarArquivoLayout (INPUT cArquivoOrigemEmbarque   ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemPedidos    ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemFabric     ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemNcm        ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemOrdens     ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemTotNcm     ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemTotFabric  ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemTotPedidos ,INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemTotEmb     ,INPUT 27066).
    if tt-param.indDocto = 2 then
        RUN piValidarArquivoLayout (INPUT cArquivoOrigemDespesas   ,INPUT 27066).
    

    IF CAN-FIND(FIRST tt-documentos-erros) THEN           
        RETURN "NOK".

    EMPTY TEMP-TABLE tt-matriz-ficha.
    EMPTY TEMP-TABLE tt-ficha.

    IF tt-param.iSeleciona = 2 then
        RUN piImportarRTFs (INPUT cArquivoOrigemEmbarque   ,INPUT 1).

    RUN piImportarRTFs (INPUT cArquivoOrigemPedidos    ,INPUT 2).
    RUN piImportarRTFs (INPUT cArquivoOrigemFabric     ,INPUT 3).
    RUN piImportarRTFs (INPUT cArquivoOrigemNcm        ,INPUT 4).
    RUN piImportarRTFs (INPUT cArquivoOrigemOrdens     ,INPUT 5).
    RUN piImportarRTFs (INPUT cArquivoOrigemTotNcm     ,INPUT 6).
    RUN piImportarRTFs (INPUT cArquivoOrigemTotFabric  ,INPUT 7).
    RUN piImportarRTFs (INPUT cArquivoOrigemTotPedidos ,INPUT 8).
    run piImportarRTFs (INPUT cArquivoOrigemTotEmb     ,INPUT 9).
    RUN piImportarRTFs (INPUT cArquivoOrigemDespesas   ,INPUT 10).
    

END PROCEDURE.

PROCEDURE piVerificarDirArqLayout:
    
    IF tt-param.lLayoutPadImp THEN DO: /* Utiliza arquivo PadrÆo do Cliente */
        IF tt-param.iSeleciona = 1 THEN DO:
            FIND FIRST param-imp
                WHERE  param-imp.cod-estabel = tt-processo-imp.cod-estabel NO-LOCK NO-ERROR.
        END.
        ELSE DO:                                                                   
            FIND FIRST param-imp
                WHERE  param-imp.cod-estabel = tt-emb.cod-estabel NO-LOCK NO-ERROR.
        END.
        if tt-param.indDocto = 1 then
            ASSIGN cDirLayout = if avail param-imp then param-imp.des-layout-autoriz-import else "".
        else
            ASSIGN cDirLayout = if avail param-imp then param-imp.des-layout-origin-licenc-import else "".
    END.
        
    ELSE  /* Layout PadrÆo para todos informado na inteface do relatorio */
        ASSIGN cDirLayout = tt-param.cLayoutPadImp.
 
    ASSIGN cDirLayout = IF LENGTH (cDirLayout) > 3 AND SUBSTR(cDirLayout, LENGTH(cDirLayout), 1) <> "~\" THEN (cDirLayout + "~\") 
                        ELSE cDirLayout.
    
    ASSIGN cDirLayout = TRIM(cDirLayout).

    ASSIGN tt-param.cDirDestino = IF LENGTH (tt-param.cDirDestino) > 3 AND SUBSTR(tt-param.cDirDestino, LENGTH(tt-param.cDirDestino), 1) <> "~\" THEN 
                                        (tt-param.cDirDestino + "~\") ELSE tt-param.cDirDestino.
END PROCEDURE.


PROCEDURE piValidarArquivoLayout:
    DEFINE INPUT PARAMETER pcArquivo AS CHARACTER.
    DEFINE INPUT PARAMETER piCodErro AS INTEGER.

    DEFINE VARIABLE iSeq     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDescMsg AS CHARACTER  NO-UNDO.
    
    IF SEARCH(pcArquivo) = ? THEN DO:
        
          RUN utp/ut-msgs.p (INPUT "msg",
                             INPUT piCodErro,
                             INPUT pcArquivo).
          ASSIGN cDescMsg = RETURN-VALUE.
    
          CREATE tt-documentos-erros.
          ASSIGN tt-documentos-erros.cod-erro = piCodErro
                 tt-documentos-erros.mensagem = cDescMsg.  

          IF tt-param.iSeleciona = 1 THEN DO:
    
              FIND FIRST tt-processo-imp-aux
                   WHERE tt-processo-imp-aux.cod-estabel  = tt-processo-imp.cod-estabel
                   AND   tt-processo-imp-aux.nr-proc-imp  = tt-processo-imp.nr-proc-imp
                   AND   tt-processo-imp-aux.num-pedido   = tt-processo-imp.num-pedido NO-ERROR.
    
              find first emitente where emitente.cod-emitente = tt-processo-imp-aux.cod-exportador no-lock no-error.

              ASSIGN tt-documentos-erros.cod-estabel = tt-processo-imp.cod-estabel
                     tt-documentos-erros.nome-abrev  = if avail emitente then emitente.nome-abrev else ""
                     tt-documentos-erros.nr-proc-imp = tt-processo-imp.nr-proc-imp
                     tt-documentos-erros.num-pedido  = tt-processo-imp.num-pedido.
          END.
          ELSE DO:

                FIND FIRST tt-pedido-compr-emb-aux
                     WHERE tt-pedido-compr-emb-aux.cod-estabel  = tt-emb.cod-estabel
                     AND   tt-pedido-compr-emb-aux.embarque     = tt-emb.embarque NO-ERROR.
    
                find first emitente where emitente.cod-emitente =  tt-pedido-compr-emb-aux.cod-exportador no-lock no-error.
                    
                assign tt-documentos-erros.cod-estabel = tt-emb.cod-estabel
                       tt-documentos-erros.nome-abrev  = if avail emitente then emitente.nome-abrev else ""
                       tt-documentos-erros.embarque    = tt-emb.embarque.
                
          END.
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

    IF SEARCH(cArquivoFinal) <> ? AND (NOT tt-param.lSobrepor) THEN DO:

       RUN utp/ut-msgs.p (INPUT "msg",
                          INPUT 5455,
                          INPUT cArquivoFinal).
       
        CREATE tt-documentos-erros.
        ASSIGN tt-documentos-erros.nome-abrev    = emitente.nome-abrev
               tt-documentos-erros.cod-erro      = 5455
               tt-documentos-erros.mensagem      = RETURN-VALUE.
        IF tt-param.iSeleciona = 1  THEN
            ASSIGN tt-documentos-erros.cod-estabel   = tt-processo-imp.cod-estabel
                   tt-documentos-erros.nr-proc-imp   = tt-processo-imp.nr-proc-imp     
                   tt-documentos-erros.num-pedido    = tt-processo-imp.num-pedido.
        ELSE
            ASSIGN tt-documentos-erros.cod-estabel   = tt-emb.cod-estabel
                   tt-documentos-erros.embarque      = tt-emb.embarque.

       RETURN "NOK".
    END.
    RETURN "OK".

END PROCEDURE.


PROCEDURE piSalvarArquivo:

    ch-app-word:ActiveDocument:SaveAs(cArquivoFinal).    
    ch-app-word:SELECTION:PageSetup:Orientation = tt-param.iOrientacao. /* Seleciona a Orienta‡Æo de ImpressÆo 0-Retrato / 1-Paisagem*/

    IF tt-param.iSeleciona = 1  THEN DO:
        IF NOT AVAIL tt-processo-imp THEN
            FIND FIRST tt-processo-imp NO-ERROR.
        FIND param-imp NO-LOCK  
            WHERE param-imp.cod-estabel = tt-processo-imp.cod-estabel NO-ERROR.
    END.
    ELSE DO:
        IF NOT AVAIL tt-emb THEN
            FIND FIRST tt-emb NO-ERROR.
        
        FIND param-imp NO-LOCK  
            WHERE param-imp.cod-estabel = tt-emb.cod-estabel NO-ERROR.
    END.

    IF AVAIL param-imp AND 
             param-imp.des-senha-docto <> "" AND
             param-imp.des-senha-docto <> ? THEN
       ch-Documento:Protect(2 , yes, param-imp.des-senha-docto).
    ch-app-word:ActiveDocument:CLOSE(). /* Fecha o arquivo do WORD */
    OS-DELETE VALUE(cArquivoAuxiliar) NO-ERROR.
    RUN piDocumentosImpressos IN THIS-PROCEDURE.
    IF tt-param.lEnviaDoctoDespachante 
    OR tt-param.cArquivoCopia <> "" THEN
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
    
    DO iCont = 1 TO phTable:NUM-FIELDS:
        ASSIGN hField = phTable:BUFFER-FIELD(iCont).
        
        IF hField:EXTENT > 0 THEN DO:
            DO iCont2 = 1 TO hField:EXTENT:
                ASSIGN searchStr = pcPrefixo + hField:NAME + "-" + STRING(iCont2).
                if hField:data-type = "decimal" or hField:data-type = "integer" then do:
                    find first tt-formato where tt-formato.nome-tt = phTable:name
                                            and tt-formato.campo-tt = hField:name no-error.
                    if avail tt-formato then do:
                        if hField:buffer-value(iCont2) = ? or hField:buffer-value(iCont2) = "" then
                            assign cValor = "0".
                        else 
                            assign cValor = string(hField:buffer-value(iCont2), tt-formato.formato) no-error.
                    end.
                    else
                        ASSIGN cValor = hField:buffer-value(iCont2).
                end.
                else
                    ASSIGN cValor = hField:buffer-value(iCont2).

                IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cValor).
            END.
        END.
        ELSE DO:
            ASSIGN searchStr = pcPrefixo + hField:NAME.
            
            if hField:data-type = "decimal" or hField:data-type = "integer" then do:
            
                find first tt-formato where tt-formato.nome-tt = phTable:name
                                        and tt-formato.campo-tt = hField:name no-error.
                if avail tt-formato then do:
                    if hField:buffer-value = ? or hField:buffer-value = "" then
                        assign cValor = "0".
                    else
                        assign cValor = STRING(hField:BUFFER-VALUE, tt-formato.formato) no-error.
                        
                end.
                else
                    ASSIGN cValor = STRING(hField:BUFFER-VALUE).

            end.
            else
                ASSIGN cValor = STRING(hField:BUFFER-VALUE).

            if cValor = ? then assign cValor = "".
            IF tt-ficha.c-linha matches ('*' + searchStr + '*') then do:
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cValor).
            end.
        END.
    END.
    
    /* EPC */
    FOR EACH tt-epc:
        ASSIGN searchStr = tt-epc.cod-parameter.
        IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN
           ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, tt-epc.val-parameter).
    END.        

END PROCEDURE.


/* E-Mail*/            
PROCEDURE piEnviarEmail:

    DEFINE VARIABLE c-email-empresa AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-assunto       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-destino-email AS CHARACTER  NO-UNDO.
    
    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    if tt-param.indDocto = 1 then
        {utp/ut-liter.i Solicita‡Æo_Autoriza‡Æo_Importa‡Æo * L}
    else
        {utp/ut-liter.i Envio_Pr‚-Licen‡a_Importa‡Æo * L}

    ASSIGN c-assunto = TRIM(RETURN-VALUE).

    assign c-assunto = c-assunto + " - " + cAssuntoEmail.

    FOR FIRST param-global FIELDS(log-1 serv-mail porta-mail) NO-LOCK:
    END.

    FOR FIRST empresa FIELDS(e-mail) WHERE 
              empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
    END.

    IF AVAIL empresa THEN
       ASSIGN c-email-empresa = empresa.e-mail.

    IF tt-param.lEnviaDoctoDespachante THEN 
        ASSIGN c-destino-email = c-destino.
    ELSE
        ASSIGN c-destino-email = "".

    IF c-destino-email <> "":U or tt-param.cArquivoCopia <> "" THEN DO:
       
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.exchange          = param-global.log-1 
              tt-envio2.servidor          = param-global.serv-mail
              tt-envio2.porta             = param-global.porta-mail
              tt-envio2.destino           = if c-destino-email <> "" then c-destino-email else tt-param.cArquivoCopia
              tt-envio2.assunto           = c-assunto
              tt-envio2.remetente         = c-email-empresa
              tt-envio2.copia             = if c-destino-email <> "" then tt-param.cArquivoCopia else ""
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

PROCEDURE piCreateTtEpc:
    DEFINE INPUT PARAM pcCodEvent     AS CHAR FORMAT "x(12)". 
    DEFINE INPUT PARAM pcCodParameter AS CHAR FORMAT "x(32)". 
    DEFINE INPUT PARAM pcValParameter AS CHAR FORMAT "x(100)". 

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = pcCodEvent    
           tt-epc.cod-parameter = pcCodParameter
           tt-epc.val-parameter = pcValParameter.
        
END PROCEDURE.

PROCEDURE piDocumentosImpressos:
    
    CREATE tt-documentos-impressos.
    ASSIGN tt-documentos-impressos.destino    = cArquivoFinal
           tt-documentos-impressos.nome-abrev = emitente.nome-abrev.

    IF tt-param.iSeleciona = 1 THEN
        ASSIGN tt-documentos-impressos.cod-estabel = tt-processo-imp.cod-estabel
               tt-documentos-impressos.nr-proc-imp = tt-processo-imp.nr-proc-imp
               tt-documentos-impressos.num-pedido  = tt-processo-imp.num-pedido.    
               /*tt-documentos-impressos.dt-embarque = tt-inst-emb.dt-embarque*/
    ELSE
        ASSIGN tt-documentos-impressos.cod-estabel = tt-emb.cod-estabel
               tt-documentos-impressos.embarque    = tt-emb.embarque.
END PROCEDURE.                                                            
/* EOF */
