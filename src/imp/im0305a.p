/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0305A 2.00.00.023 } /*** "010023" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0305a MIM}
&ENDIF

{imp/im0305.i}     /* tt-param */
{imp/im0305.i1}    /* tt-pedido-compr e tt-pedido-compr-aux */
{exp/ex9998.i}     /* Procedure trocaCaracterEspecial */
{utp/utapi019.i}   /* Include API CORREIO ELETR‚NICO  */
{include/i-epc200.i IM0305A}
{utp/ut-glob.i}

/********************* Definiá∆o de temp-tables **********************/

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
          campo.

DEFINE TEMP-TABLE tt-token NO-UNDO
    FIELD token AS CHAR.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
    FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
    FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?.

DEFINE TEMP-TABLE tt_log_erro_aux NO-UNDO LIKE tt_log_erro.

/**************************** ParÉmetros ****************************/
DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-aux.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compr-aux2.
DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-compra.
DEFINE INPUT  PARAMETER TABLE FOR tt-prazo-compra.
DEFINE INPUT  PARAMETER TABLE FOR tt-despesa.
DEFINE INPUT  PARAMETER TABLE FOR tt-texto-follow-up.
DEFINE INPUT  PARAMETER phAcomp  AS HANDLE.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-impressos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-erros.
DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro_aux.

/********************** Definiá∆o de vari†veis **********************/
DEFINE VARIABLE cDirLayout                      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cArquivoOrigemCabec             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemOrdens            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemParcelas          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemTotaisDasOrdens   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemDespesas          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemAlteracoes        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoOrigemRodape            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoAuxiliar                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cArquivoFinal                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ch-app-word                     AS office.iface.word.WordWrapper NO-UNDO.
DEFINE VARIABLE ch-Documento                    AS office.iface.word.Document NO-UNDO.
DEFINE VARIABLE h-axssu004                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boar0168                      AS HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_habilit AS LOGICAL NO-UNDO.

/************************** Main Block *****************************/
    FIND FIRST tt-param NO-ERROR.

    FOR EACH tt-documentos-erros: DELETE tt-documentos-erros. END.
    FOR EACH tt-documentos-impressos: DELETE tt-documentos-impressos. END.
    
    IF NOT CAN-FIND(FIRST tt-pedido-compr) THEN 
       RETURN "OK".

    {utp/ut-liter.i "Gerando_arquivos_do_WORD" *}
    RUN pi-seta-titulo IN phAcomp (INPUT RETURN-VALUE).    
    {utp/ut-liter.i "Carregando_arquivos_de_traduá∆o." *}
    RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE).
    RUN piCarregarTtTraducao1 IN THIS-PROCEDURE.
    RUN piCarregarTtTraducao2 IN THIS-PROCEDURE.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE(h-boar0168) THEN
            RUN local/arg/boar0168.p PERSISTENT SET h-boar0168.
    END.

    /* Carrega o WORD para a  mem¢ria */
    {office/office.i Word ch-app-word}

     /*alteraá∆o feita pois estava impactando na impressao pelo Libreoffice, onde n∆o eram carregadas as informacoes */

   /* ch-app-word:WindowState = 2.  Deixa o aplicativo minimizado 
    ch-app-word:VISIBLE = FALSE.     O aplicativo fica em background */    

    RUN piGerarRelatorioPurchaseOrder.
    
    IF VALID-OBJECT(ch-app-word) THEN DO:    
        ch-app-word:QUIT(). /* Fechar o WORD */        
        DELETE OBJECT ch-app-word.
    END.

/**************************** Procedure Internas *****************************/

PROCEDURE piGerarRelatorioPurchaseOrder:

    FOR EACH tt-pedido-compr,
        FIRST tt-pedido-compr-aux WHERE
              tt-pedido-compr-aux.num-pedido = tt-pedido-compr.num-pedido,
        FIRST tt-pedido-compr-aux2 WHERE
              tt-pedido-compr-aux2.num-pedido = tt-pedido-compr-aux.num-pedido:

        FOR FIRST emitente FIELDS (nome-abrev)
            WHERE emitente.cod-emitente = tt-pedido-compr.cod-emitente NO-LOCK: END.
               
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Pedido" *}
        RUN pi-acompanhar  IN phAcomp (INPUT RETURN-VALUE + ": " + STRING(tt-pedido-compr-aux.num-pedido)).

        RUN piCarregarArquivos.
        if  return-value = "NOK":U then
            next.

        RUN piIncluirDocumento.

        ASSIGN cArquivoFinal = tt-param.c-dir-destino + emitente.nome-abrev
                             + STRING(tt-pedido-compr.num-pedido)  + " - " + replace(replace(tt-pedido-compr.nr-proc-imp,"~\","-"),"~/","-") + '.doc'.
        

        RUN piValidarArquivoFinal.
        IF RETURN-VALUE = "OK" THEN DO:
            RUN piTraduzirLiterais    IN THIS-PROCEDURE. 
            RUN piImprimirCabecRodape IN THIS-PROCEDURE (INPUT 1). /* Cabecalho */        
            RUN piImprimirOrdens      IN THIS-PROCEDURE.
            RUN piImprimirDespesas    IN THIS-PROCEDURE.
            RUN piImprimirFollowUp    IN THIS-PROCEDURE.
            RUN piImprimirCabecRodape IN THIS-PROCEDURE (INPUT 7). /* Rodape */       
            RUN piSalvarArquivo       IN THIS-PROCEDURE.

            IF NOT tt-param.l-minuta THEN DO:
               /* Atualiza situacao do pedido de compra */
               RUN imp/im0305b.p(INPUT tt-documentos-impressos.num-pedido).
               IF v_log_eai_habilit THEN 
                   RUN piExecutaAdapter(INPUT tt-pedido-compr.num-pedido).
               /* Atualiza situacao das ordens do pedido de compra */
               FOR EACH ordem-compra WHERE
                        ordem-compra.num-pedido = tt-pedido-compr.num-pedido NO-LOCK:
                   RUN imp/im0305c.p(INPUT ROWID(ordem-compra)).
               END.
            END.
        END.

    END.

END PROCEDURE.

/* Procedures para geracao dos RTF's */

PROCEDURE piImprimirCabecRodape:
    DEFINE INPUT PARAM piFormulario AS INTEGER.

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    /* Cabeáalho */
    IF piFormulario = 1 THEN DO:
       RUN piCreateTtEpc (INPUT "custom-fields-im0305-cabec", "tt-pedido-compr.num-pedido", tt-pedido-compr.num-pedido).
       {include/i-epc201.i "custom-fields-im0305-cabec"}
       IF  VALID-HANDLE(h-boar0168) THEN DO:
           RUN criaCabecalho IN h-boar0168 (INPUT-OUTPUT TABLE tt-epc).
       END.
    END.
    ELSE DO:
       RUN piCreateTtEpc (INPUT "custom-fields-im0305-rodape", "tt-pedido-compr.num-pedido", tt-pedido-compr.num-pedido).
       {include/i-epc201.i "custom-fields-im0305-rodape"}
    END.
    
    RUN piGerarFormulario(INPUT piFormulario, INPUT BUFFER tt-pedido-compr:HANDLE).
    FOR EACH tt-ficha:
        IF tt-ficha.c-linha MATCHES('*#*') THEN DO:
           RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-aux:HANDLE).
           RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT BUFFER tt-pedido-compr-aux2:HANDLE).
        END.
    END.
    
    RUN piInserirRtf IN THIS-PROCEDURE.

END PROCEDURE.

PROCEDURE piImprimirOrdens:

    FOR EACH tt-ordem-compra WHERE
             tt-ordem-compra.num-pedido = tt-pedido-compr.num-pedido:

        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        RUN piCreateTtEpc (INPUT "custom-fields-im0305-ordens", "tt-ordem-compra.numero-ordem", tt-ordem-compra.numero-ordem).
        
        {include/i-epc201.i "custom-fields-im0305-ordens"}

        /* Imprime RTF da Ordem de Compra */        
        RUN piGerarFormulario(INPUT 2, INPUT BUFFER tt-ordem-compra:HANDLE).
        RUN piInserirRtf IN THIS-PROCEDURE.

        FOR EACH tt-prazo-compra WHERE
                 tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.

            RUN piCreateTtEpc (INPUT "custom-fields-im0305-parcelas", "tt-prazo-compra.numero-ordem", tt-prazo-compra.numero-ordem).
            RUN piCreateTtEpc (INPUT "custom-fields-im0305-parcelas", "tt-prazo-compra.parcela", tt-prazo-compra.parcela).
            {include/i-epc201.i "custom-fields-im0305-parcelas"}

            IF  VALID-HANDLE(h-boar0168) THEN DO:
                RUN imprimiDados IN h-boar0168 (INPUT-OUTPUT TABLE tt-epc).
            END.

               
            /* Imprime RTF das Parcelas  */            
            RUN piGerarFormulario(INPUT 3, INPUT BUFFER tt-prazo-compra:HANDLE).
            RUN piInserirRtf IN THIS-PROCEDURE.
        END.

        /* Imprime RTF do Total da Ordem de Compra */        
        RUN piGerarFormulario(INPUT 4, INPUT BUFFER tt-ordem-compra:HANDLE).
        RUN piInserirRtf IN THIS-PROCEDURE.
    END.
        
    RETURN "OK".

END PROCEDURE.

PROCEDURE piImprimirDespesas:

    FOR EACH tt-despesa WHERE
             tt-despesa.num-pedido = tt-pedido-compr.num-pedido:
        
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        RUN piCreateTtEpc (INPUT "custom-fields-im0305-despesas", "tt-despesa.cod-despesa", tt-despesa.cod-desp).
        {include/i-epc201.i "custom-fields-im0305-parcelas"}
        IF  VALID-HANDLE(h-boar0168) THEN DO:
            RUN imprimiDados IN h-boar0168 (INPUT-OUTPUT TABLE tt-epc).
        END.

        RUN piGerarFormulario(INPUT 5, INPUT BUFFER tt-despesa:HANDLE).
        RUN piInserirRtf IN THIS-PROCEDURE.
    END.
     

END PROCEDURE.

PROCEDURE piImprimirFollowUp:

    FOR EACH tt-texto-follow-up WHERE
             tt-texto-follow-up.num-pedido = tt-pedido-compr.num-pedido:
        
        RUN piGerarFormulario(INPUT 6, INPUT BUFFER tt-texto-follow-up:HANDLE).
        RUN piInserirRtf IN THIS-PROCEDURE.
    END.   

END PROCEDURE.

PROCEDURE piCarregarArquivos:

    RUN piVerificarDirArqLayout.

    /* Nomes dos arquivos para geraá∆o e arquivos auxiliares */
    ASSIGN cArquivoOrigemCabec           = cDirLayout + 'im0305-cabec.rtf'
           cArquivoOrigemOrdens          = cDirLayout + 'im0305-ordens.rtf'
           cArquivoOrigemParcelas        = cDirLayout + 'im0305-parcelas.rtf'
           cArquivoOrigemTotaisDasOrdens = cDirLayout + 'im0305-tot-ordens.rtf'
           cArquivoOrigemDespesas        = cDirLayout + 'im0305-despesas.rtf'
           cArquivoOrigemAlteracoes      = cDirLayout + 'im0305-alteracoes.rtf'           
           cArquivoOrigemRodape          = cDirLayout + 'im0305-rodape.rtf'
           cArquivoAuxiliar              = tt-param.c-dir-destino + 'arqaux.rtf'.    

    RUN piValidarArquivoLayout (INPUT cArquivoOrigemCabec          ,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemOrdens         ,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemParcelas       ,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemTotaisDasOrdens,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemDespesas       ,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemAlteracoes     ,  INPUT 27066).
    RUN piValidarArquivoLayout (INPUT cArquivoOrigemRodape         ,  INPUT 27066).    

    IF CAN-FIND(FIRST tt-documentos-erros WHERE
                         tt-documentos-erros.num-pedido = tt-pedido-compr.num-pedido) THEN       
          RETURN "NOK".

    EMPTY TEMP-TABLE tt-matriz-ficha.
    EMPTY TEMP-TABLE tt-ficha.

    RUN piImportarRTFs (INPUT cArquivoOrigemCabec          , INPUT 1).    
    RUN piImportarRTFs (INPUT cArquivoOrigemOrdens         , INPUT 2).    
    RUN piImportarRTFs (INPUT cArquivoOrigemParcelas       , INPUT 3).
    RUN piImportarRTFs (INPUT cArquivoOrigemTotaisDasOrdens, INPUT 4).
    RUN piImportarRTFs (INPUT cArquivoOrigemDespesas       , INPUT 5).
    RUN piImportarRTFs (INPUT cArquivoOrigemAlteracoes     , INPUT 6).
    RUN piImportarRTFs (INPUT cArquivoOrigemRodape         , INPUT 7).    

    return "OK":U.
END PROCEDURE.

PROCEDURE piVerificarDirArqLayout:
    
    IF tt-param.l-layout-pad-fornec THEN DO: /* Utiliza arquivo Padr∆o do Cliente */
        FOR FIRST emitente-cex FIELDS(des-layout-origin-pch-order)
            WHERE emitente-cex.cod-emitente = tt-pedido-compr.cod-emitente NO-LOCK:
        END.
        IF AVAIL emitente-cex THEN
           ASSIGN cDirLayout = emitente-cex.des-layout-origin-pch-order.                               
    END.
    ELSE  /* Layout Padr∆o para todos informado na inteface do relatorio */
        ASSIGN cDirLayout = tt-param.c-layout-pad-fornec.
 
    ASSIGN cDirLayout = IF LENGTH (cDirLayout) > 3 AND SUBSTR(cDirLayout, LENGTH(cDirLayout), 1) <> "~\" THEN (cDirLayout + "~\") 
                        ELSE cDirLayout.
    
    ASSIGN cDirLayout = TRIM(cDirLayout).

    ASSIGN tt-param.c-dir-destino = IF LENGTH (tt-param.c-dir-destino) > 3 AND SUBSTR(tt-param.c-dir-destino, LENGTH(tt-param.c-dir-destino), 1) <> "~\"
                                            THEN (tt-param.c-dir-destino + "~\") 
                                         ELSE tt-param.c-dir-destino.
END PROCEDURE.


PROCEDURE piIncluirDocumento:
    ch-Documento = ch-app-word:Documents:ADD(). /* Cria um novo documento no WORD */ 
    ch-app-word:WindowState = 2. /* Deixa o aplicativo minimizado */
    ch-app-word:VISIBLE = TRUE.    /* O aplicativo fica em background */
    ch-app-word:ScreenUpdating = FALSE.
END PROCEDURE.

PROCEDURE piInserirRtf:
    OUTPUT TO VALUE(cArquivoAuxiliar).    
    RUN piImprimirNoArquivo.
    OUTPUT CLOSE.    
    ch-app-word:SELECTION:Insertfile(cArquivoAuxiliar).    
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

       FIND LAST tt-documentos-erros WHERE
                 tt-documentos-erros.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.
       IF AVAIL tt-documentos-erros THEN
          ASSIGN iSeq = tt-documentos-erros.seq + 1.

       CREATE tt-documentos-erros.
       ASSIGN tt-documentos-erros.seq           = iSeq                
              tt-documentos-erros.cod-estabel   = tt-pedido-compr.cod-estabel
              tt-documentos-erros.nome-emit-exp = emitente.nome-abrev
              tt-documentos-erros.nr-proc-imp   = tt-pedido-compr.nr-proc-imp
              tt-documentos-erros.num-pedido    = tt-pedido-compr.num-pedido
              tt-documentos-erros.cod-erro      = piCodErro
              tt-documentos-erros.mensagem      = cDescMsg.
    END.

END PROCEDURE.

PROCEDURE piImportarRTFs:
    DEFINE INPUT PARAMETER pcArquivo    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piFormulario AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iCont               AS INTEGER   NO-UNDO.

    /* Importa para uma temp-table todas as linhas do arquivo de cabeáalho */
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
       ASSIGN tt-documentos-erros.cod-estabel   = tt-pedido-compr.cod-estabel
              tt-documentos-erros.nome-emit-exp = emitente.nome-abrev
              tt-documentos-erros.nr-proc-imp   = tt-pedido-compr.nr-proc-imp     
              tt-documentos-erros.num-pedido    = tt-pedido-compr.num-pedido      
              tt-documentos-erros.cod-erro      = 5455
              tt-documentos-erros.mensagem      = RETURN-VALUE.
       RETURN "NOK".
    END.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE piImprimirNoArquivo:

    /* Para cada registro da temp-table gerada, imprime essa informaá∆o no arquivo auxiliar que est† aberto */
    FOR EACH tt-ficha:
        RUN trocaCaracterEspecial (INPUT-OUTPUT tt-ficha.c-linha).
        IF  tt-ficha.c-linha = '' THEN
            PUT UNFORMATTED SKIP(1).
        ELSE DO:
            IF tt-ficha.c-linha BEGINS("~\par ~}~{~\*~\themedata") THEN
                ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha,"~\par ~}~{","~\par ~}~}~\*~\themedata").

            PUT UNFORMATTED tt-ficha.c-linha SKIP.
        END.
        DELETE tt-ficha.
    END.

    /* Isso Ç obrigado a ter no final de um RTF */
    PUT UNFORMATTED '~\par }}'.

END PROCEDURE.

PROCEDURE piSalvarArquivo:

    ch-app-word:ActiveDocument:SaveAs(cArquivoFinal).    
    ch-app-word:SELECTION:PageSetup:Orientation = tt-param.i-orientacao. /* Seleciona a Orientaá∆o de Impress∆o 0-Retrato / 1-Paisagem*/
    FIND param-imp NO-LOCK  WHERE
         param-imp.cod-estabel = tt-pedido-compr.cod-estabel NO-ERROR.
    IF AVAIL param-imp AND 
             param-imp.des-senha-pch-order <> "" AND
             param-imp.des-senha-pch-order <> ? THEN
       ch-Documento:Protect(2 , yes, param-imp.des-senha-pch-order).    
    ch-app-word:ActiveDocument:CLOSE(). /* Fecha o arquivo do WORD */
    OS-DELETE VALUE(cArquivoAuxiliar) NO-ERROR.
    RUN piDocumentosImpressos IN THIS-PROCEDURE.
    IF tt-param.l-envia-docto-fornec THEN
       RUN piEnviarEmail.

END PROCEDURE.

PROCEDURE piDocumentosImpressos:

    CREATE tt-documentos-impressos.
    ASSIGN tt-documentos-impressos.cod-estabel   = tt-pedido-compr.cod-estabel
           tt-documentos-impressos.nome-emit-exp = emitente.nome-abrev
           tt-documentos-impressos.nr-proc-imp   = tt-pedido-compr.nr-proc-imp
           tt-documentos-impressos.num-pedido    = tt-pedido-compr.num-pedido    
           tt-documentos-impressos.destino       = cArquivoFinal.

END PROCEDURE.

/* Substituir valores no formulario */
PROCEDURE piGerarFormulario:
/**************************************************************************
 * Objetivo: Atribuir para cada variavel do RTF o valor do campo da respectiva
 *           tabela.
 * Parametros: piFormulario
 *           Arquivo          C¢digo  
 *           Cabecalho        =  1    
 *           Ordens           =  2    
 *           Parcelas         =  3    
 *           Total das Ordens =  4    
 *           Despesas         =  5    
 *           Alteracoes       =  6
 *           RodapÇ           =  7    
 *           phHandle: Handle da temp-table correspondente ao RTF
 **************************************************************************/
 DEFINE INPUT PARAMETER piFormulario    AS INTEGER NO-UNDO.
 DEFINE INPUT PARAMETER phHandle        AS HANDLE  NO-UNDO.
    
    FOR EACH tt-ficha:
        DELETE tt-ficha.
    END.
    
    FOR EACH tt-matriz-ficha WHERE
             tt-matriz-ficha.i-formulario = piFormulario:
        
        CREATE tt-ficha.
        ASSIGN tt-ficha.c-linha = tt-matriz-ficha.c-linha.                
        IF tt-ficha.c-linha MATCHES('*#*') THEN DO:           
           RUN piSubstituiValores IN THIS-PROCEDURE ("#", INPUT phHandle).        
        END.
        
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE piSubstituiValores:   
    DEFINE INPUT PARAMETER pcPrefixo AS CHARACTER.
    DEFINE INPUT PARAMETER phTable   AS HANDLE.

    DEFINE VARIABLE iCont        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iCont2       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE searchStr    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cDateFormat  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDecFormat   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBufferValue AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNomeCampo   AS CHARACTER  NO-UNDO.
  
    RUN piCriarTTTokens IN THIS-PROCEDURE (INPUT "#",
                                           INPUT tt-ficha.c-linha,
                                           OUTPUT TABLE tt-token).

    /* + tt-param.i-formato-data 
         1 - DD/MM/AAAA
         2 - MM/DD/AAAA
       + tt-param.decimais 2 a 5 decimais
    */

    FOR EACH tt-token
        BREAK BY tt-token.token DESC:

        ASSIGN cNomeCampo = TRIM(REPLACE(tt-token.token,"#","")).

        DO iCont = 1 TO phTable:NUM-FIELDS:
           ASSIGN hField = phTable:BUFFER-FIELD(iCont).
           IF hField:NAME = TRIM(cNomeCampo) THEN DO:

               IF hField:EXTENT > 0 THEN DO:
                  DO iCont2 = 1 TO hField:EXTENT:
                      ASSIGN searchStr = pcPrefixo + hField:NAME + "-" + STRING(iCont2).
                      IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN DO:
                         ASSIGN cBufferValue = IF hField:BUFFER-VALUE(iCont2) = ? THEN "" ELSE hField:BUFFER-VALUE(iCont2).
                         RUN piFormatarValor (INPUT-OUTPUT cBufferValue,
                                              INPUT hField:DATA-TYPE,
                                              INPUT hField:FORMAT). 
					                            
                         IF cNomeCampo = "narrativa" OR cNomeCampo = "texto-mensag-ped" THEN
                            ASSIGN cBufferValue = REPLACE(cBufferValue, CHR(10), "\par").
                         ELSE
                            ASSIGN cBufferValue = REPLACE(cBufferValue, CHR(10), " ").
			   
                         ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cBufferValue).
                      END.
                  END.
               END.
               ELSE DO:
                    ASSIGN searchStr = pcPrefixo + hField:NAME.
                    IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN DO:

                       ASSIGN cBufferValue = IF hField:BUFFER-VALUE = ? THEN "" ELSE hField:BUFFER-VALUE.
                       RUN piFormatarValor (INPUT-OUTPUT cBufferValue,
                                            INPUT hField:DATA-TYPE,
                                            INPUT hField:FORMAT).
                       
                       IF cNomeCampo = "narrativa" OR cNomeCampo = "texto-mensag-ped" THEN
                          ASSIGN cBufferValue = REPLACE(cBufferValue, CHR(10), "\par").
                       ELSE
                          ASSIGN cBufferValue = REPLACE(cBufferValue, CHR(10), " ").

                       ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, cBufferValue).
                    END.
               END.      

           END.
        END.
    END.    
                 
    /* EPC */
    FOR EACH tt-epc:
        ASSIGN searchStr = tt-epc.cod-parameter.
        IF tt-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN
           ASSIGN tt-ficha.c-linha = REPLACE(tt-ficha.c-linha, searchStr, tt-epc.val-parameter).
    END.

END PROCEDURE.

PROCEDURE piFormatarValor:
    DEFINE INPUT-OUTPUT PARAMETER pcString      AS CHAR.
    DEFINE INPUT        PARAMETER pcTipoDoCampo AS CHAR.
    DEFINE INPUT        PARAMETER pcFormato     AS CHAR.

    DEFINE VARIABLE cDecFormat   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDateFormat  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dtTemp       AS DATE       NO-UNDO.
    DEFINE VARIABLE deTemp       AS DECIMAL    NO-UNDO.

    IF pcTipoDoCampo = "Decimal" THEN DO:                             
       ASSIGN cDecFormat = SUBSTR(pcFormato,1,INDEX(pcFormato,".")) + FILL("9",tt-param.decimais)
              deTemp     = DECIMAL(pcString)
              pcString = STRING(deTemp,cDecFormat).       
    END.
    ELSE DO:
       IF pcTipoDoCampo = "Date" THEN DO:

          IF pcString <> "" THEN DO:          
              ASSIGN cDateFormat = SESSION:DATE-FORMAT
                     dtTemp = DATE(pcString).
              IF tt-param.i-formato-data = 1 /* DD/MM/AAAA */ THEN
                 SESSION:DATE-FORMAT = "dmy".
              ELSE
                 SESSION:DATE-FORMAT = "mdy".            
              ASSIGN pcString = STRING(dtTemp,"99/99/9999").              
              SESSION:DATE-FORMAT = cDateFormat.
          END.
       END.
    END.   

END PROCEDURE.

/* EPC */
PROCEDURE piCreateTtEpc:
    DEFINE INPUT PARAM pcCodEvent     AS CHAR FORMAT "x(12)". 
    DEFINE INPUT PARAM pcCodParameter AS CHAR FORMAT "x(32)". 
    DEFINE INPUT PARAM pcValParameter AS CHAR FORMAT "x(54)". 

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = pcCodEvent    
           tt-epc.cod-parameter = pcCodParameter
           tt-epc.val-parameter = pcValParameter.
        
END PROCEDURE.

/* E-Mail*/
PROCEDURE piEnviarEmail:

    DEFINE VARIABLE c-email-empresa AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-assunto       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-destino-email AS CHARACTER  NO-UNDO.

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    {utp/ut-liter.i Envio_Purchase_Order * L}
    ASSIGN c-assunto = TRIM(RETURN-VALUE).

    IF tt-param.l-traducao THEN
       RUN piTraducao (INPUT-OUTPUT c-assunto).

    FOR FIRST param-global FIELDS(log-1 serv-mail porta-mail) NO-LOCK:
    END.

    FOR FIRST empresa FIELDS(e-mail) WHERE 
              empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
    END.

    IF AVAIL empresa THEN
       ASSIGN c-email-empresa = empresa.e-mail.

    FOR FIRST emitente FIELDS(e-mail nome-abrev) WHERE 
              emitente.cod-emitente = tt-pedido-compr.cod-emitente NO-LOCK:
    END.

    IF AVAIL emitente THEN
       ASSIGN c-destino-email = emitente.e-mail.
    ELSE 
       ASSIGN c-destino-email = "":U.

    IF c-destino-email <> "":U THEN DO:
    
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.exchange          = param-global.log-1 
              tt-envio2.servidor          = param-global.serv-mail
              tt-envio2.porta             = param-global.porta-mail
              tt-envio2.destino           = c-destino-email
              tt-envio2.assunto           = c-assunto + " - ":U + emitente.nome-abrev + STRING(tt-pedido-compr.num-pedido)  + " - " + tt-pedido-compr.nr-proc-imp
              /*tt-envio2.assunto           = c-assunto + " ":U + tt-pedido-compr.nome-emit-export + STRING(tt-pedido-compr.num-pedido)  + " - " + tt-pedido-compr.nr-proc-imp */           
              tt-envio2.remetente         = c-email-empresa
              tt-envio2.copia             = tt-param.c-arquivo-copia
              tt-envio2.mensagem          = "":U
              tt-envio2.importancia       = 1
              tt-envio2.log-enviada       = YES 
              tt-envio2.log-lida          = NO
              tt-envio2.acomp             = NO
              tt-envio2.arq-anexo         = cArquivoFinal.
    
       /* API de envio eletrìnico */       
       RUN utp/utapi019.p PERSISTENT SET h-utapi019.
       RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                      INPUT  TABLE tt-mensagem,
                                      OUTPUT TABLE tt-erros).
       DELETE PROCEDURE h-utapi019.
    END.

END PROCEDURE.

/* Traducao */
PROCEDURE piTraduzirLiterais:
    DEFINE VARIABLE cPrefixo   AS CHARACTER  NO-UNDO INITIAL "#lit-".    
    DEFINE VARIABLE cNomeCampo AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.
        
    FIND FIRST tt-pedido-compr-aux  EXCLUSIVE-LOCK NO-ERROR.
    FIND FIRST tt-pedido-compr-aux2 EXCLUSIVE-LOCK NO-ERROR.

    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + cPrefixo + '*'):

        RUN piCriarTTTokens IN THIS-PROCEDURE (INPUT "#lit-",
                                               INPUT tt-matriz-ficha.c-linha,
                                               OUTPUT TABLE tt-token).
        FOR EACH tt-token:
            
            IF tt-matriz-ficha.c-linha MATCHES ('*' + tt-token.token + '*') THEN DO:
               ASSIGN cNomeCampo = TRIM(REPLACE(tt-token.token,cPrefixo," ")) .
               FIND FIRST tt-traduz-tt WHERE
                          tt-traduz-tt.campo-tt = cNomeCampo NO-ERROR.
               IF AVAIL tt-traduz-tt THEN DO:

                  IF tt-traduz-tt.desc-label <> "" THEN
                     ASSIGN cLabel = tt-traduz-tt.desc-label.
                  ELSE DO:

                                            
                     RUN utp/ut-field.p (INPUT tt-traduz-tt.banco,
                                         INPUT tt-traduz-tt.tabela,
                                         INPUT tt-traduz-tt.campo,
                                         INPUT 1).
                     ASSIGN cLabel = RETURN-VALUE.
                     
                  END.
                  
                  IF tt-param.l-traducao THEN
                     RUN piTraducao (INPUT-OUTPUT cLabel).
                  
                  ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, tt-token.token, cLabel).
               END.
           END.
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

       IF iCont = LENGTH(pcLinha) THEN DO:
          IF lLit = TRUE AND INDEX(cToken,pcTokenIni) > 0 THEN DO:               
             IF NOT CAN-FIND(FIRST tt-token WHERE tt-token.token = cToken) THEN DO:              
                CREATE tt-token.
                ASSIGN tt-token.token = cToken
                        cToken        = "".               
             END.
          END.            
       END.

    END.

END PROCEDURE.

PROCEDURE piCarregarTtTraducao1:
    {imp/im0305lit.i}
END PROCEDURE.

PROCEDURE piCarregarTtTraducao2:
    {imp/im0305lit.i1}
END PROCEDURE.

PROCEDURE piTraducao:
    DEFINE INPUT-OUTPUT PARAMETER p-traducao AS CHARACTER  NO-UNDO.
    {imp/im9998.i "p-traducao" "p-traducao" "tt-pedido-compr-aux"}
END PROCEDURE.

PROCEDURE piExecutaAdapter:
    DEF INPUT PARAM pi-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = pi-num-pedido NO-ERROR.
    IF NOT AVAIL pedido-compr THEN
        RETURN "NOK":U.

    IF tt-param.l-bus-to-bus THEN DO:    
        RUN adapters/xml/su2/axssu004.p PERSISTENT SET h-axssu004 (OUTPUT TABLE tt_log_erro).
        RUN PITransUpsert IN h-axssu004 (INPUT ROWID(pedido-compr), OUTPUT TABLE tt_log_erro).
        FOR EACH tt_log_erro NO-LOCK:
            CREATE tt_log_erro_aux.
            BUFFER-COPY tt_log_erro TO tt_log_erro_aux.
        END.
        DELETE PROCEDURE h-axssu004.
        ASSIGN h-axssu004 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* EOF */
