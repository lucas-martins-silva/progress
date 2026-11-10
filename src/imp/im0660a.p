/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0660A 2.00.00.018 } /*** 010018 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0660a MIM}
&ENDIF

{imp/im0660.i}     /* tt-param                        */
{imp/imapi009.i}   /* temp-table                      */
{imp/imapi009.i1}   /* temp-table                     */
{method/dbotterr.i}/* temp-table RowErrors            */
{utp/utapi019.i}   /* Include API CORREIO ELETR‚NICO  */
{exp/ex9998.i}     /* Procedure trocaCaracterEspecial */
{include/i-epc200.i "im0660a"} /*** Definiá∆o de elementos referentes a EPC ***/

DEFINE TEMP-TABLE tt-traduz-tt NO-UNDO
    FIELD nome-tt    AS CHARACTER
    FIELD campo-tt   AS CHARACTER 
    FIELD banco      AS CHARACTER 
    FIELD tabela     AS CHARACTER 
    FIELD campo      AS CHARACTER       
    FIELD formato    AS CHARACTER       
    FIELD desc-label AS CHARACTER.

DEFINE TEMP-TABLE tt-token NO-UNDO
    FIELD token AS CHAR.

{imp/im0660lit.i}
{imp/im0660lit.i1}


DEFINE TEMP-TABLE tt-bco-exp           NO-UNDO LIKE banco.

DEFINE TEMP-TABLE tt-corretor          NO-UNDO LIKE tt-emitente.
    
DEFINE TEMP-TABLE tt-erro NO-UNDO 
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel AS CHARACTER format "x(05)":U
&ELSE
    FIELD cod-estabel AS CHARACTER FORMAT "x(03)":U
&ENDIF
    FIELD nome-abrev  AS CHARACTER FORMAT "x(12)":U 
    FIELD embarque    AS CHARACTER FORMAT "x(12)":U 
    FIELD nr-invoice  AS CHARACTER FORMAT "x(12)":U 
    FIELD parcela     AS CHARACTER FORMAT "x(02)":U 
    FIELD cd-erro     LIKE RowErrors.errorNumber 
    FIELD mensagem    LIKE RowErrors.ErrorDescription.


DEFINE TEMP-TABLE tt-matriz-ficha NO-UNDO
    FIELD c-linha       AS CHAR FORMAT 'x(300)'
    FIELD i-formulario  AS INT.

/* Variaá‰es i-formulario                             */
/* 1 - Cabeáalho                                      */
/* 2 - Pedido                                         */
/* 3 - Valores (por invoice ou por embarque)          */
/* 4 - Dados para Dep¢sito                            */
/* 5 - Documentos (por invoice ou por embarque)       */
/* 6 - Invoices (somente quando agrupado por embarque)*/
/* 7 - Cotaá‰es                                       */ 

DEFINE TEMP-TABLE tt-ficha NO-UNDO
    FIELD c-linha AS CHAR FORMAT 'x(300)'.

DEFINE INPUT  PARAMETER TABLE FOR tt-embarque.
DEFINE INPUT  PARAMETER TABLE FOR tt-processo.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido.
DEFINE INPUT  PARAMETER TABLE FOR tt-banco.
DEFINE INPUT  PARAMETER TABLE FOR tt-estabelec.
DEFINE INPUT  PARAMETER TABLE FOR tt-emitente. /* exportador */
DEFINE INPUT  PARAMETER TABLE FOR tt-corretor.
DEFINE INPUT  PARAMETER TABLE FOR tt-bco-exp.
DEFINE INPUT  PARAMETER TABLE FOR tt-agencia.
DEFINE INPUT  PARAMETER TABLE FOR tt-comprador.
DEFINE INPUT  PARAMETER TABLE FOR tt-invoice.
DEFINE INPUT  PARAMETER TABLE FOR tt-pd-fecha-camb.
DEFINE INPUT  PARAMETER TABLE FOR tt-cond-pagto.
DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE OUTPUT PARAMETER c-arquivo-final-aux AS CHARACTER.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE h-im0660b                    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-dir-layout                 AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-cabec       AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-cotacao     AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-depos       AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-doctos-emb  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-doctos-inv  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-invoice     AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-pedidos     AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-valores-emb AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-arquivo-origem-valores-inv AS CHARACTER        NO-UNDO.
DEFINE VARIABLE ch-app-word                  AS office.iface.word.WordWrapper       NO-UNDO.
DEFINE VARIABLE c-arquivo-auxiliar           AS CHARACTER        NO-UNDO.
DEFINE VARIABLE i-cont                       AS INTEGER          NO-UNDO.
DEFINE VARIABLE i-cont-2                     AS INTEGER          NO-UNDO.
DEFINE VARIABLE c-literal                    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE hTable                       AS HANDLE           NO-UNDO.
DEFINE VARIABLE hField                       AS HANDLE           NO-UNDO.
DEFINE VARIABLE prefixo                      AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-label                      AS CHARACTER        NO-UNDO.
DEFINE VARIABLE searchStr                    AS CHARACTER        NO-UNDO.   
DEFINE VARIABLE c-valor                      AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-senha-modelo               AS CHARACTER        NO-UNDO.
DEFINE VARIABLE ch-Documento                 AS office.iface.word.Document NO-UNDO.
DEFINE VARIABLE h-acomp                      AS HANDLE           NO-UNDO. 
DEFINE VARIABLE c-arquivo-final              AS CHARACTER        NO-UNDO.

&GLOBAL-DEFINE wdNoProtection           -1 /* 4 - Nenhum */



/* Vari†veis e Literais */

{imp/im0660.i2} /* Define Literais tt-pd-fecha-camb */ 
{imp/im0660.i3} /* Gera literais formul†rio         */ 
{imp/im0660.i4} /* Gera Valores  formul†rio         */ 



RUN imp/im0660b.p  PERSISTENT SET h-im0660b.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Emiss∆o de Instruá‰es para Embarque").


MAIN_BLOCK:
DO ON ENDKEY UNDO MAIN_BLOCK, 
    LEAVE MAIN_BLOCK ON ERROR UNDO MAIN_BLOCK, 
    LEAVE MAIN_BLOCK:

    FIND FIRST tt-embarque   NO-ERROR.
    find first tt-processo   no-error.
    FIND FIRST tt-cond-pagto NO-ERROR.
    FIND FIRST tt-estabelec  NO-ERROR.
    FIND FIRST tt-emitente   NO-ERROR. /* tt-exportador */
    FIND FIRST tt-corretor   NO-ERROR.
    FIND FIRST tt-comprador  NO-ERROR.
    FIND FIRST tt-param      NO-ERROR.

    ASSIGN tt-param.c-dir-destino = IF LENGTH (tt-param.c-dir-destino) > 3 AND SUBSTR(tt-param.c-dir-destino, LENGTH(tt-param.c-dir-destino), 1) <> "~\"
                                    THEN (tt-param.c-dir-destino + "~\") 
                                    ELSE tt-param.c-dir-destino.
            
    IF tt-param.i-agrupar = 1 THEN DO: /*** Agrupa por invoice ***/
        FOR EACH tt-invoice:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Agrupa_por_Invoice" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).

            FOR FIRST tt-pd-fecha-camb
                WHERE tt-pd-fecha-camb.cod-estabel = tt-invoice.cod-estabel
                AND   tt-pd-fecha-camb.embarque    = tt-invoice.embarque   
                AND   tt-pd-fecha-camb.nr-invoice  = tt-invoice.nr-invoice 
                AND   tt-pd-fecha-camb.parcela     = tt-invoice.parcela:    

                ASSIGN c-arquivo-final     = tt-param.c-dir-destino   + 
                                             tt-emitente.nome-abrev   + "-" +  /*exportador*/
                                             tt-embarque.cod-estabel  + "-" +
                                             tt-embarque.embarque     + "-" +
                                             tt-invoice.nr-invoice    + "-" +
                                             tt-invoice.parcela       + ".doc"
                       c-arquivo-final-aux = IF c-arquivo-final-aux = "" THEN c-arquivo-final
                                             ELSE c-arquivo-final-aux + "," + c-arquivo-final.
                
                RUN gera-arquivo.
            END.
        END.
    END.
    ELSE DO:
        
        FIND FIRST tt-pd-fecha-camb NO-ERROR.
        ASSIGN c-arquivo-final     = tt-param.c-dir-destino   + 
                                     tt-emitente.nome-abrev + "-" + /*exportador*/
                                     tt-embarque.cod-estabel  + "-" +
                                     tt-embarque.embarque     + ".doc"
               c-arquivo-final-aux = c-arquivo-final.

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Agrupa_por_Embarque" *}
        RUN pi-acompanhar in h-acomp (RETURN-VALUE).

        FIND FIRST tt-invoice NO-ERROR.

        RUN gera-arquivo.    
    END.
END. /* fim main_block */
    
    
        
PROCEDURE gera-arquivo.
    
    /*** Utiliza Padr∆o do Fornecedor ***/
    IF  tt-param.l-layout-pad-fornec THEN DO:
        FIND FIRST tt-corretor NO-ERROR.
        IF AVAIL tt-corretor THEN
            ASSIGN c-dir-layout = trim(tt-corretor.des-layout-origin-ped-cambio).
        ELSE
            ASSIGN c-dir-layout = trim(tt-param.c-layout-pad-fornec).
                                      
    END.
    ELSE  
        ASSIGN c-dir-layout = trim(tt-param.c-layout-pad-fornec).
        

    ASSIGN c-dir-layout = IF LENGTH (c-dir-layout) > 3 
                          AND substr(c-dir-layout, LENGTH(c-dir-layout), 1) <> "~\" 
                          THEN (c-dir-layout + "~\") ELSE c-dir-layout.

        
    /* Nomes dos arquivos para geraá∆o e arquivos auxiliares */
    ASSIGN c-arquivo-origem-cabec       = c-dir-layout + 'im0660-cabec.rtf'
           c-arquivo-origem-cotacao     = c-dir-layout + 'im0660-cotacao.rtf'
           c-arquivo-origem-depos       = c-dir-layout + 'im0660-depos.rtf'
           c-arquivo-origem-doctos-emb  = c-dir-layout + 'im0660-doctos-emb.rtf'
           c-arquivo-origem-doctos-inv  = c-dir-layout + 'im0660-doctos-inv.rtf'
           c-arquivo-origem-invoice     = c-dir-layout + 'im0660-invoice.rtf'
           c-arquivo-origem-pedidos     = c-dir-layout + 'im0660-pedidos.rtf'
           c-arquivo-origem-valores-emb = c-dir-layout + 'im0660-valores-emb.rtf'
           c-arquivo-origem-valores-inv = c-dir-layout + 'im0660-valores-inv.rtf'
           c-arquivo-auxiliar           = c-dir-layout + 'arqaux.rtf'.

    RUN pi-valida-formularios.

    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN
        RETURN "NOK".

    FOR EACH tt-matriz-ficha:
        DELETE tt-matriz-ficha.
    END.

    RUN cria-matriz-ficha.
    RUN pi-traduz-literais.
        
    IF NOT VALID-OBJECT(ch-app-word) THEN DO:
        
        /* Cria uma aplicaá∆o WORD */
        {office/office.i Word ch-app-word}

        /* O estado dois para o Word Ç minimizado */
        ch-app-word:WindowState = 2.

        /* Apenas para n∆o mostrar que o word est† sendo utilizado em tela */
        ch-app-word:VISIBLE = NO.
    END.

    /* Abre um novo arquivo no WORD */
    ch-app-word:Documents:ADD().
    
    FIND FIRST param-imp
        WHERE param-imp.cod-estabel = tt-embarque.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL param-imp THEN
        ASSIGN c-senha-modelo = param-imp.des-senha-docto.
    ELSE
        ASSIGN c-senha-modelo = "".

    RUN pi-traduz-campos.
                
        
    /* Salva o arquivo aberto no WORD com o nome final do arquivo */
    ch-app-word:ActiveDocument:SaveAs(c-arquivo-final).
    
    /* Seleciona a Orientaá∆o de Impress∆o 0-Retrato / 1-Paisagem*/
    ch-app-word:SELECTION:PageSetup:Orientation = tt-param.i-orientacao.

    
    /* Fecha o arquivo do WORD */
    ch-app-word:ActiveDocument:CLOSE().
    ch-Documento = ch-app-Word:Documents:Add(c-arquivo-final).
    
    
    /* Elimina o arquivo auxiliar */
    OS-DELETE VALUE(c-arquivo-auxiliar) NO-ERROR.
    
    

    IF ch-Documento:ProtectionType <> {&wdNoProtection}
    AND c-senha-modelo <> "" 
    AND c-senha-modelo <> ? THEN 
        ch-Documento:UnProtect(c-senha-modelo).

    IF (c-senha-modelo <> "" AND c-senha-modelo <> ?)THEN 
        ch-Documento:Protect(2 , yes, c-senha-modelo).
        
    ch-Documento:SaveAs(c-arquivo-final).
    ch-Documento:Close().

    IF tt-param.l-envia-docto-exportador 
    OR tt-param.l-envia-docto-corretor   
    OR c-arquivo-copia <> "" THEN
        RUN pi-EnviaEmail.

    IF VALID-OBJECT(ch-app-word) THEN DO:
        /* Fechar o WORD */
        ch-app-word:QUIT().

        /* Elimina o endereáo utilizado para o WORD na m†quina */
        DELETE OBJECT ch-app-word.        
        DELETE object ch-Documento.
    END.
END. /* fim main_block */

DELETE PROCEDURE h-im0660b.
RUN pi-finalizar IN h-acomp.


PROCEDURE pi-traduz-literais:
    RUN pi-inicializar in h-acomp ("Traduz-Literais").
    
    RUN geraLiterais_Embarque.
    RUN geraLiterais_Processo.
    RUN geraLiterais_Pedido.
    RUN geraLiterais_CondPagto.
    RUN geraLiterais_Banco.
    RUN geraLiterais_Bco-exp.
    RUN geraLiterais_Ag-exp.
    RUN geraLiterais_Importador.
    RUN geraLiterais_Exportador.
    RUN geraLiterais_Corretor.
    RUN geraLiterais_Comprador.
    RUN geraLiterais_Invoice.
    RUN geraLiterais_pd-fecha-camb.

    FOR EACH tt-matriz-ficha 
        WHERE tt-matriz-ficha.c-linha MATCHES "*#lit*" NO-LOCK:
        RUN geraLiterais_Espec.
    END.

    
END PROCEDURE.

PROCEDURE pi-traduz-campos:                          
    RUN pi-inicializar in h-acomp ("Traduz-Campos").

    /* Joga os dados para um arquivo auxiliar, j† substituindo as vari†veis do 
       cabeáalho pelos valores corretos na procedure*/
    OUTPUT TO value(c-arquivo-auxiliar).
    RUN GeraCabec (INPUT 1). 
    RUN imprimeNoArquivo. 
    OUTPUT CLOSE.
    /* Insere esse arquivo gerado no documento do WORD aberto */
    ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
    
    FOR EACH tt-pedido: 
        find FIRST tt-processo WHERE tt-processo.num-pedido = tt-pedido.num-pedido no-lock no-error.
        if avail tt-processo then do:
            OUTPUT TO value(c-arquivo-auxiliar).
            RUN GeraPedidos (INPUT 2). 
            RUN imprimeNoArquivo. 
            OUTPUT CLOSE.
            /* Insere esse arquivo gerado no documento do WORD aberto */
            ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
        end.
    END.
    
    OUTPUT TO value(c-arquivo-auxiliar).
    RUN GeraValores (INPUT 3). 
    RUN imprimeNoArquivo. 
    OUTPUT CLOSE.
    /* Insere esse arquivo gerado no documento do WORD aberto */
    ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
    
    OUTPUT TO value(c-arquivo-auxiliar).
    RUN GeraDepos (INPUT 4). 
    RUN imprimeNoArquivo. 
    OUTPUT CLOSE.
    /* Insere esse arquivo gerado no documento do WORD aberto */
    ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
    
    OUTPUT TO value(c-arquivo-auxiliar).
    RUN GeraDoctos (INPUT 5). 
    RUN imprimeNoArquivo. 
    OUTPUT CLOSE.
    /* Insere esse arquivo gerado no documento do WORD aberto */
    ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
    
    IF tt-param.i-agrupar = 2 THEN DO:
        FOR EACH tt-invoice:
            OUTPUT TO value(c-arquivo-auxiliar).
            RUN GeraInvoice (INPUT 6). 
            RUN imprimeNoArquivo. 
            OUTPUT CLOSE.
            /* Insere esse arquivo gerado no documento do WORD aberto */
            ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
        END.
    END.

    OUTPUT TO value(c-arquivo-auxiliar).
    RUN GeraCotacao (INPUT 7). 
    RUN imprimeNoArquivo. 
    OUTPUT CLOSE.
    /* Insere esse arquivo gerado no documento do WORD aberto */
    ch-app-word:SELECTION:Insertfile(c-arquivo-auxiliar).
    
END PROCEDURE.

PROCEDURE pi-Traducao:
    DEFINE INPUT-OUTPUT PARAMETER p-traducao AS CHARACTER  NO-UNDO.
    
    if tt-param.i-traducao = 2 then 
        {imp/im9998.i "p-traducao" "p-traducao" "tt-corretor"}

    if tt-param.i-traducao = 3 then 
        {imp/im9998.i "p-traducao" "p-traducao" "tt-emitente"} /* exportador */
    
END PROCEDURE.

PROCEDURE imprimeNoArquivo:
    
    /* Para cada registro da temp-table gerada, imprime essa informaá∆o no arquivo auxiliar que est† aberto */

    FOR EACH tt-ficha:
        RUN trocaCaracterEspecial (INPUT-OUTPUT tt-ficha.c-linha).
        IF  tt-ficha.c-linha = '' THEN
            PUT UNFORMATTED SKIP(1).
        ELSE DO:
            PUT UNFORMATTED tt-ficha.c-linha SKIP.
        END.
        DELETE tt-ficha.
    END.

    /* Isso Ç obrigado a ter no final de um RTF */
    PUT UNFORMATTED '~\par }}'.

END PROCEDURE.

PROCEDURE cria-matriz-ficha:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "cria-matriz-ficha" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).
    /* Importa para uma temp-table todas as linhas do arquivo de cabeáalho */
    INPUT FROM VALUE(c-arquivo-origem-cabec).
    REPEAT:
        CREATE tt-matriz-ficha.
        ASSIGN tt-matriz-ficha.i-formulario = 1.
        IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
    END.
    INPUT CLOSE.

    /* Importa para uma temp-table todas as linhas do formulario pedidos */
    INPUT FROM VALUE(c-arquivo-origem-pedidos).
    REPEAT:
        CREATE tt-matriz-ficha.
        ASSIGN tt-matriz-ficha.i-formulario = 2.
        IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
    END.
    INPUT CLOSE.

    
    IF tt-param.i-agrupar = 1 THEN DO:
        /* Importa para uma temp-table todas as linhas do formulario valores-inv */
        INPUT FROM VALUE(c-arquivo-origem-valores-inv).
        REPEAT:
            CREATE tt-matriz-ficha.
            ASSIGN tt-matriz-ficha.i-formulario = 3.
            IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
        END.
        INPUT CLOSE.

        /* Importa para uma temp-table todas as linhas do formulario doctos-inv */
        INPUT FROM VALUE(c-arquivo-origem-doctos-inv).
        REPEAT:
            CREATE tt-matriz-ficha.
            ASSIGN tt-matriz-ficha.i-formulario = 5.
            IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
        END.
        INPUT CLOSE.
    END.
    ELSE DO:
        /* Importa para uma temp-table todas as linhas do formulario valores-emb */
        INPUT FROM VALUE(c-arquivo-origem-valores-emb).
        REPEAT:
            CREATE tt-matriz-ficha.
            ASSIGN tt-matriz-ficha.i-formulario = 3.
            IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
        END.
        INPUT CLOSE.

        /* Importa para uma temp-table todas as linhas do formul†rio doctos-emb */
        INPUT FROM VALUE(c-arquivo-origem-doctos-emb).
        REPEAT:
            CREATE tt-matriz-ficha.
            ASSIGN tt-matriz-ficha.i-formulario = 5.
            IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
        END.
        INPUT CLOSE.
    END.            

    /* Importa para uma temp-table todas as linhas do formul†rio depos */
    INPUT FROM VALUE(c-arquivo-origem-depos).
    REPEAT:
        CREATE tt-matriz-ficha.
        ASSIGN tt-matriz-ficha.i-formulario = 4.
        IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
    END.
    INPUT CLOSE.

    
    IF tt-param.i-agrupar = 2 THEN DO:
        /* Importa para uma temp-table todas as linhas do formulario invoice */
        INPUT FROM VALUE(c-arquivo-origem-invoice).
        REPEAT:
            CREATE tt-matriz-ficha.
            ASSIGN tt-matriz-ficha.i-formulario = 6.
            IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
        END.
        INPUT CLOSE.
    END.

    /* Importa para uma temp-table todas as linhas do formul†rio cotaá∆o */
    INPUT FROM VALUE(c-arquivo-origem-cotacao).
    REPEAT:
        CREATE tt-matriz-ficha.
        ASSIGN tt-matriz-ficha.i-formulario = 7.
        IMPORT UNFORMATTED tt-matriz-ficha.c-linha.
    END.
    INPUT CLOSE.

END PROCEDURE.

PROCEDURE GeraCabec:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Cabecalho":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Cabecalho"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Cabecalho"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Cabecalho"}
                         
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraCabec" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            RUN geraCampos.

            DO  i-cont = 1 TO 20:
                IF  tt-ficha.c-linha MATCHES('*#var-espec-cabec-' + trim(string(i-cont)) + '*') THEN DO:
                    RUN CabecEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                 INPUT "#var-espec-cabec-" + trim(string(i-cont)),
                                                 OUTPUT c-valor).
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-cabec-' + trim(string(i-cont)), c-valor).
                END.
            END.
        END.

        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.    

END PROCEDURE.

PROCEDURE GeraPedidos:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Pedidos":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Pedidos"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Pedidos"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Pedidos"'
                         &CodParameter='"num-pedido"'
                         &ValueParameter="string(tt-pedido.num-pedido)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Pedidos"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraPedido" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            RUN geraCampos.
            
            DO  i-cont = 1 TO 20:
                IF  tt-ficha.c-linha MATCHES('*#var-espec-pedidos-' + trim(string(i-cont)) + '*') THEN DO:
                    RUN PedidosEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                   INPUT "#var-espec-pedidos-" + trim(string(i-cont)),
                                                   OUTPUT c-valor).
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-pedidos-' + trim(string(i-cont)), c-valor).
                END.
            END.
        END.
        
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.

PROCEDURE GeraValores:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Valores":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Valores"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Valores"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Valores"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraValores" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            FIND FIRST tt-pedido NO-ERROR.
            RUN geraCampos.
            
            DO  i-cont = 1 TO 20:
                IF tt-param.i-agrupar = 1 THEN 
                    IF  tt-ficha.c-linha MATCHES('*#var-espec-valores-inv-' + trim(string(i-cont)) + '*') THEN DO:
                        RUN ValoresInvEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                          INPUT "#var-espec-valores-inv-" + trim(string(i-cont)),
                                                          OUTPUT c-valor).
                        ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-valores-inv-' + trim(string(i-cont)), c-valor).
                    END.
                IF tt-param.i-agrupar = 2 THEN 
                    IF  tt-ficha.c-linha MATCHES('*#var-espec-valores-emb-' + trim(string(i-cont)) + '*') THEN DO:
                        RUN ValoresEmbEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                          INPUT "#var-espec-valores-emb-" + trim(string(i-cont)),
                                                          OUTPUT c-valor).
                        ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-valores-emb-' + trim(string(i-cont)), c-valor).
                    END.
            END.
        END.
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.

PROCEDURE GeraDepos:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-DadosDeposito":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-DadosDeposito"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-DadosDeposito"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-DadosDeposito"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraDepos" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            RUN geraCampos.

            DO  i-cont = 1 TO 20:
                IF  tt-ficha.c-linha MATCHES('*#var-espec-depos-' + trim(string(i-cont)) + '*') THEN DO:
                    RUN DeposEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                 INPUT "#var-espec-depos-" + trim(string(i-cont)),
                                                 OUTPUT c-valor).
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-depos-' + trim(string(i-cont)), c-valor).
                END.
            END.
        END.
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.

PROCEDURE GeraDoctos:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Documentos":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Documentos"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Documentos"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Documentos"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraDoctos" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            RUN geraCampos.

            DO  i-cont = 1 TO 20:
                IF tt-param.i-agrupar = 1 THEN 
                    IF  tt-ficha.c-linha MATCHES('*#var-espec-doctos-inv-' + trim(string(i-cont)) + '*') THEN DO:
                        RUN DoctosInvEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                         INPUT "#var-espec-doctos-inv-" + trim(string(i-cont)),
                                                         OUTPUT c-valor).
                        ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-doctos-inv-' + trim(string(i-cont)), c-valor).
                    END.
                IF tt-param.i-agrupar = 2 THEN 
                    IF  tt-ficha.c-linha MATCHES('*#var-espec-valores-emb-' + trim(string(i-cont)) + '*') THEN DO:
                        RUN DoctosEmbEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                         INPUT "#var-espec-doctos-emb-" + trim(string(i-cont)),
                                                         OUTPUT c-valor).
                        ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-doctos-emb-' + trim(string(i-cont)), c-valor).
                    END.
            END.
        END.
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.

PROCEDURE GeraInvoice:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Invoices":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Invoices"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Invoices"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Invoices"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "GeraInvoice" *}
            RUN pi-acompanhar in h-acomp (RETURN-VALUE).
            RUN geraCampos.
            
            DO  i-cont = 1 TO 20:
                IF  tt-ficha.c-linha MATCHES('*#var-espec-invoice-' + trim(string(i-cont)) + '*') THEN DO:
                    RUN InvoiceEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                   INPUT "#var-espec-invoice-" + trim(string(i-cont)),
                                                   OUTPUT c-valor).
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-invoice-' + trim(string(i-cont)), c-valor).
                END.
            END.

        END.
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.

PROCEDURE GeraCotacao:
    DEFINE INPUT  PARAMETER pi-formulario AS INTEGER    NO-UNDO.

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "Custom-Fields-Cotacoes":
        DELETE tt-epc.
    END.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Cotacoes"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="string(tt-embarque.cod-estabel)"}
    
    {include/i-epc200.i2 &CodEvent='"Custom-Fields-Cotacoes"'
                         &CodParameter='"embarque"'
                         &ValueParameter="string(tt-embarque.embarque)"}                         
                         
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "Custom-Fields-Cotacoes"}
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.i-formulario = pi-formulario NO-LOCK:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.
        IF  tt-ficha.c-linha MATCHES('*#*') THEN DO:
            RUN geraCampos.
            DO  i-cont = 1 TO 20:
                IF  tt-ficha.c-linha MATCHES('*#var-espec-cotacao-' + trim(string(i-cont)) + '*') THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "GeraCotacao" *}
                    RUN pi-acompanhar in h-acomp (RETURN-VALUE).
                    RUN CotacaoEspec IN h-im0660b (INPUT tt-embarque.r-rowid,
                                                   INPUT "#var-espec-cotacao-" + trim(string(i-cont)),
                                                   OUTPUT c-valor).
                    ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, '#var-espec-cotacao-' + trim(string(i-cont)), c-valor).
                END.
            END.
        END.
        FOR EACH tt-epc:
            IF  tt-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, tt-epc.cod-parameter, tt-epc.val-parameter).
        END.
    END.
END PROCEDURE.                

PROCEDURE pi-valida-formularios:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "ValidaFormulario" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).

    IF SEARCH(c-arquivo-final) <> ? AND (NOT tt-param.l-sobrepor) THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 5455,
                           INPUT c-arquivo-final).

        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 5455
               tt-erro.mensagem    = RETURN-VALUE.
    END.
    
    IF SEARCH(c-arquivo-origem-cabec) = ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-cabec).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /* exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.
    IF SEARCH(c-arquivo-origem-cotacao) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-cotacao).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /* exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.
    IF SEARCH(c-arquivo-origem-depos) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-depos).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.       

    IF SEARCH(c-arquivo-origem-doctos-emb) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-doctos-emb).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /* exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.       
               
    IF SEARCH(c-arquivo-origem-doctos-inv) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-doctos-inv).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /* exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.

    IF SEARCH(c-arquivo-origem-invoice) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-invoice).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.

    IF SEARCH(c-arquivo-origem-pedidos) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-pedidos).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador*/
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.

    IF SEARCH(c-arquivo-origem-valores-emb) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-valores-emb).
    
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador*/
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.

    IF SEARCH(c-arquivo-origem-valores-inv) = ? THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 27066,
                           INPUT c-arquivo-origem-valores-inv).

        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-embarque.cod-estabel 
               tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador*/
               tt-erro.embarque    = tt-embarque.embarque 
               tt-erro.nr-invoice  = tt-invoice.nr-invoice
               tt-erro.parcela     = tt-invoice.parcela
               tt-erro.cd-erro     = 27066
               tt-erro.mensagem    = RETURN-VALUE.
    END.
END PROCEDURE.

PROCEDURE pi-EnviaEmail:
    DEFINE VARIABLE c-email-empresa AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-assunto       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-destino-email AS CHARACTER  NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Envia_E-mail" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    
    {utp/ut-liter.i Envio_Pedido_Fechamento_de_CÉmbio * L}
    ASSIGN c-assunto = TRIM(RETURN-VALUE).

    IF tt-param.i-traducao <> 1 THEN
        RUN pi-Traducao (INPUT-OUTPUT c-assunto).

    
    
    FOR FIRST param-global FIELDS(log-1 serv-mail porta-mail empresa-prin) NO-LOCK:
    END.
    
    FOR FIRST empresa FIELDS(e-mail) 
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        ASSIGN c-email-empresa = empresa.e-mail.
    END.

    IF tt-param.i-agrupar = 1 THEN
        ASSIGN c-assunto =  c-assunto                + " - " + 
                            tt-emitente.nome-abrev + "/"   +  /*exportador*/
                            tt-embarque.embarque     + "/"   + 
                            tt-pd-fecha-camb.nr-invoice  + "/"   + 
                            tt-pd-fecha-camb.parcela.
     

    ELSE
        ASSIGN c-assunto =  c-assunto                + " - " + 
                            tt-emitente.nome-abrev + "/"   +  /*exportador*/
                            tt-embarque.embarque.
    
    IF tt-param.l-envia-docto-exportador THEN 
        ASSIGN c-destino-email = tt-emitente.e-mail. /*exportador*/

    IF tt-param.l-envia-docto-corretor THEN 
        ASSIGN c-destino-email = c-destino-email + ";" + tt-corretor.e-mail.
    
    IF  c-destino-email <> "":U 
    OR  tt-param.c-arquivo-copia <> "":U THEN DO:

        IF c-destino-email = "":U  
        AND tt-param.c-arquivo-copia <> "":U THEN
            ASSIGN c-destino-email          = tt-param.c-arquivo-copia.
    
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.exchange          = param-global.log-1
               tt-envio2.servidor          = param-global.serv-mail
               tt-envio2.porta             = param-global.porta-mail
               tt-envio2.destino           = c-destino-email
               tt-envio2.copia             = tt-param.c-arquivo-copia
               tt-envio2.assunto           = c-assunto 
               tt-envio2.remetente         = c-email-empresa
               tt-envio2.mensagem          = "":U
               tt-envio2.importancia       = 1
               tt-envio2.log-enviada       = YES 
               tt-envio2.log-lida          = NO
               tt-envio2.acomp             = NO
               tt-envio2.arq-anexo         = c-arquivo-final.

        /* API de envio eletrìnico */       
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        DELETE PROCEDURE h-utapi019.
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

       IF iCont = LENGTH(pcLinha) THEN DO:
          IF lLit = TRUE AND INDEX(cToken,pcTokenIni) > 0 THEN DO:               
             IF NOT CAN-FIND(FIRST tt-token WHERE tt-token.token = cToken) THEN DO:              
                CREATE tt-token.
                ASSIGN tt-token.token = cToken
                        cToken            = "".               
             END.
          END.            
       END.

    END.

END PROCEDURE.
