/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0680RP 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0680rp MIM}
&ENDIF

{imp/im9100.i}
/*{method/dbotterr.i}  /* temp-table RowErrors */                      */
{include/i-rpvar.i}

/* Parametros do relatorio */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

/************************* Defini‡Æo de Frames ******************************/
IF tt-param.iSeleciona = 1 THEN DO:
&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-impressos.cod-estabel format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-impressos.cod-estabel FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-impressos.nome-abrev  FORMAT "x(12)"      COLUMN-LABEL "Exportador"
         tt-documentos-impressos.nr-proc-imp FORMAT "x(12)"      COLUMN-LABEL "Proc Import"
         tt-documentos-impressos.num-pedido  FORMAT ">>>>>,>>9"  COLUMN-LABEL "Pedido"         
         tt-documentos-impressos.destino     FORMAT "x(80)"      COLUMN-LABEL "Destino"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-impressos-proc.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-impressos-proc:HANDLE).
    
    END. 

&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-erros.cod-estabel     format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-erros.cod-estabel     FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-erros.nome-abrev      FORMAT "x(12)"      COLUMN-LABEL "Exportador"
         tt-documentos-erros.nr-proc-imp     FORMAT "x(12)"      COLUMN-LABEL "Proc Import "
         tt-documentos-erros.num-pedido      FORMAT ">>>>>,>>9"  COLUMN-LABEL "Pedido"
         tt-documentos-erros.cod-erro        FORMAT ">>>>9"      COLUMN-LABEL "Nr Mensag"
         tt-documentos-erros.mensagem        FORMAT "x(70)"      COLUMN-LABEL "Mensagem"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-erros-proc.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-erros-proc:HANDLE).
    
    END. 
END.
ELSE DO:
&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-impressos.cod-estabel format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-impressos.cod-estabel FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-impressos.nome-abrev  FORMAT "x(12)"      COLUMN-LABEL "Exportador"
         tt-documentos-impressos.embarque    FORMAT "x(12)"      COLUMN-LABEL "Embarque"
         tt-documentos-impressos.destino     FORMAT "x(80)"      COLUMN-LABEL "Destino"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-impressos-emb.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-impressos-emb:HANDLE).
    
    END. 

&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-erros.cod-estabel     format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-erros.cod-estabel     FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-erros.nome-abrev      FORMAT "x(12)"      COLUMN-LABEL "Exportador"
         tt-documentos-erros.embarque        FORMAT "x(12)"      COLUMN-LABEL "Embarque"
         tt-documentos-erros.cod-erro        FORMAT ">>>>9"      COLUMN-LABEL "Nr Mensag"
         tt-documentos-erros.mensagem        FORMAT "x(70)"      COLUMN-LABEL "Mensagem"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-erros-emb.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-erros-emb:HANDLE).
    
    END. 
END.                                                

/*Include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

/*Include padrÆo para output de relat¢rios */
{include/i-rpout.i}

{utp/ut-liter.i Pr‚-Licen‡a_Importa‡Æo * r}
ASSIGN c-titulo-relat = trim(return-value).
{utp/ut-liter.i Importa‡Æo * r}
ASSIGN c-sistema = trim(return-value).

FIND FIRST param-global NO-LOCK NO-ERROR.
    
ASSIGN c-empresa  = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa = "IM/0680"
       c-versao   = "2.00"
       c-revisao  = "000".
    
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN imp/im9100.p (INPUT  TABLE tt-param,
                  OUTPUT TABLE tt-documentos-impressos,
                  OUTPUT TABLE tt-documentos-erros).

/* Procedure interna utilizada para emitir os documentos criados ou erros enontrados */
RUN piImprimirDoctosGerados IN THIS-PROCEDURE.

/* Imprimir p gina de parƒmetros */
RUN piImprimirParametros IN THIS-PROCEDURE.

/* Fechamento do output do relat¢rio */
{include/i-rpclo.i}
RETURN "OK":U.                                           

PROCEDURE piImprimirDoctosGerados:

    IF CAN-FIND(FIRST tt-documentos-erros) THEN DO:
       {utp/ut-liter.i ERROS * L}
       PUT RETURN-VALUE FORMAT "x(10)".
       PUT UNFORMATTED SKIP(1).
       FOR EACH tt-documentos-erros
            BY tt-documentos-erros.cod-estabel:

            IF tt-param.iSeleciona = 1 THEN DO:
                DISP tt-documentos-erros.cod-estabel     
                     tt-documentos-erros.nome-abrev      
                     tt-documentos-erros.nr-proc-imp     
                     tt-documentos-erros.num-pedido      
                     tt-documentos-erros.cod-erro        
                     tt-documentos-erros.mensagem        
                     WITH FRAME f-doc-erros-proc.      
                DOWN WITH FRAME f-doc-erros-proc.      
            END.
            ELSE DO:
                DISP tt-documentos-erros.cod-estabel
                     tt-documentos-erros.nome-abrev 
                     tt-documentos-erros.embarque   
                     tt-documentos-erros.cod-erro   
                     tt-documentos-erros.mensagem   
                     WITH FRAME f-doc-erros-emb.    
                DOWN WITH FRAME f-doc-erros-emb.    
            END.                                    
        END.
    END.
    
    IF CAN-FIND(FIRST tt-documentos-impressos) THEN DO:
        PUT UNFORMATTED SKIP(1).
        {utp/ut-liter.i DOCUMENTOS_IMPRESSOS * L}
        PUT RETURN-VALUE FORMAT "x(30)".
        PUT UNFORMATTED SKIP(1).

        FOR EACH tt-documentos-impressos:
            IF tt-param.iSeleciona = 1 THEN DO:
                DISP tt-documentos-impressos.cod-estabel 
                     tt-documentos-impressos.nome-abrev  
                     tt-documentos-impressos.nr-proc-imp 
                     tt-documentos-impressos.num-pedido      
                     tt-documentos-impressos.destino     
                    WITH FRAME f-doc-impressos-proc.
                DOWN WITH FRAME f-doc-impressos-proc.
            END.
            ELSE DO:
                DISP tt-documentos-impressos.cod-estabel 
                     tt-documentos-impressos.nome-abrev  
                     tt-documentos-impressos.embarque    
                     tt-documentos-impressos.destino     
                    WITH FRAME f-doc-impressos-emb.
                DOWN WITH FRAME f-doc-impressos-emb.     
            END.
        END.                             
    END.
END PROCEDURE.

PROCEDURE piImprimirParametros:

    DEFINE VARIABLE cSelecao                AS CHARACTER FORMAT "X(07)" NO-UNDO.
    DEFINE VARIABLE cParametro              AS CHARACTER FORMAT "X(10)" NO-UNDO.
    DEFINE VARIABLE cImpressao              AS CHARACTER FORMAT "X(09)" NO-UNDO.
    DEFINE VARIABLE cEstabel                AS CHARACTER FORMAT "X(16)" NO-UNDO.
    DEFINE VARIABLE cProcImp                AS CHARACTER FORMAT "X(20)" NO-UNDO.
    DEFINE VARIABLE cEmbarque               AS CHARACTER FORMAT "X(09)" NO-UNDO.
    DEFINE VARIABLE cItensLi                AS CHARACTER FORMAT "X(60)" NO-UNDO.
    DEFINE VARIABLE cEmbEncerrados          AS CHARACTER FORMAT "X(31)" NO-UNDO.
    DEFINE VARIABLE cSeleciona              AS CHARACTER FORMAT "X(15)" NO-UNDO.
    DEFINE VARIABLE cSeleciona2             AS CHARACTER FORMAT "X(19)" NO-UNDO.
    DEFINE VARIABLE cOrientacao             AS CHARACTER FORMAT "X(11)" NO-UNDO.
    DEFINE VARIABLE cOrientacao2            AS CHARACTER FORMAT "X(11)" NO-UNDO.
    DEFINE VARIABLE cEnviaDoctoDespachante  AS CHARACTER FORMAT "X(31)" NO-UNDO.
    DEFINE VARIABLE cArquivoCopia           AS CHARACTER FORMAT "X(17)" NO-UNDO.
    DEFINE VARIABLE cUtilLayoutPadImp       AS CHARACTER FORMAT "X(51)" NO-UNDO.
    DEFINE VARIABLE cLayoutPadImp           AS CHARACTER FORMAT "X(15)" NO-UNDO.
    DEFINE VARIABLE cSobrepor               AS CHARACTER FORMAT "X(32)" NO-UNDO.
    DEFINE VARIABLE cDirDestino             AS CHARACTER FORMAT "X(10)" NO-UNDO.
    DEFINE VARIABLE cDestino                AS CHARACTER FORMAT "X(08)" NO-UNDO.
    DEFINE VARIABLE cDestino2               AS CHARACTER FORMAT "X(10)" NO-UNDO.
    DEFINE VARIABLE cArquivo                AS CHARACTER FORMAT "X(08)" NO-UNDO.
    
    PAGE.
    
    {utp/ut-liter.i "SELE€ÇO" * r}.
    ASSIGN cSelecao = RETURN-VALUE.
    {utp/ut-liter.i "PAR¶METROS" * r}.
    ASSIGN cParametro = RETURN-VALUE.
    {utp/ut-liter.i "IMPRESSÇO" * r}.
    ASSIGN cImpressao = RETURN-VALUE.
    {utp/ut-liter.i "Estabelecimento:" * r}.
    ASSIGN cEstabel = RETURN-VALUE.
    {utp/ut-liter.i "Processo_Importa‡Æo:" * r}.
    ASSIGN cProcImp = RETURN-VALUE.
    {utp/ut-liter.i "Embarque:" * r}.
    ASSIGN cEmbarque = RETURN-VALUE.
    {utp/ut-liter.i "Somente_itens_que_necessitam_de_Licenciamento_de_Importa‡Æo:" * r}.
    ASSIGN cItensLi = RETURN-VALUE.
    {utp/ut-liter.i "Considera_Embarques_Encerrados:" * r}.
    ASSIGN cEmbEncerrados = RETURN-VALUE.       
    {utp/ut-liter.i "Selecionar_por:" * r}.
    ASSIGN cSeleciona = RETURN-VALUE.           
    {utp/ut-liter.i "Orienta‡Æo:" * r}.
    ASSIGN cOrientacao = RETURN-VALUE.          
    {utp/ut-liter.i "Envia_Docto_para_o_Despachante:" * r}.
    ASSIGN cEnviaDoctoDespachante = RETURN-VALUE.
    {utp/ut-liter.i "Envia_C¢pia_Para:" * r}.
    ASSIGN cArquivoCopia = RETURN-VALUE.        
    {utp/ut-liter.i "Utiliza_Layout_PadrÆo_dos_Parƒmetros_de_Importa‡Æo:" * r}.
    ASSIGN cUtilLayoutPadImp = RETURN-VALUE.    
    {utp/ut-liter.i "Layout_PadrÆo:" * r}.
    ASSIGN cLayoutPadImp = RETURN-VALUE.        
    {utp/ut-liter.i "Sobrepor_arquivos_j _existentes:" * r}.
    ASSIGN cSobrepor = RETURN-VALUE.            
    {utp/ut-liter.i "Diret¢rio:" * r}.
    ASSIGN cDirDestino = RETURN-VALUE.              
    {utp/ut-liter.i "Destino:" * r}
    ASSIGN cDestino = RETURN-VALUE.
    IF tt-param.iSeleciona = 1 THEN DO:
        {utp/ut-liter.i "Processo_Importa‡Æo" * r}.
        ASSIGN cSeleciona2 = RETURN-VALUE.
    END.
    ELSE DO:
        {utp/ut-liter.i "Embarque" * r}.
        ASSIGN cSeleciona2 = RETURN-VALUE.
    END.                         
    IF tt-param.destino = 1 THEN DO:
        {utp/ut-liter.i "Impressora" * r}.
        ASSIGN cDestino2 = RETURN-VALUE.
    END.
    ELSE DO:
        IF tt-param.destino = 2 THEN DO:
            {utp/ut-liter.i "Arquivo" * r}.
            ASSIGN cDestino2 = RETURN-VALUE.
        END.
        ELSE DO:
            {utp/ut-liter.i "Terminal" * r}.
            ASSIGN cDestino2 = RETURN-VALUE.
        END.
    END.
    {utp/ut-liter.i "Arquivo:" * r}
    ASSIGN cArquivo = RETURN-VALUE.

    IF tt-param.iOrientacao  = 0 THEN DO:
        {utp/ut-liter.i "Retrato" * r}.
        ASSIGN cOrientacao2 = RETURN-VALUE.
    END.
    ELSE DO:
        {utp/ut-liter.i "Paisagem" * r}.
        ASSIGN cOrientacao2 = RETURN-VALUE.
    END.
    
    PUT 
        cSelecao                AT 0                                                                        SKIP(1)
        cEstabel                AT 45 tt-param.cCodEstabelIni AT 61 "|<   >|" AT 74 tt-param.cCodEstabelFim 
        cProcImp                AT 41 tt-param.cNrProcImpIni  AT 61 "|<   >|" AT 74 tt-param.cNrProcImpFim
        cEmbarque               AT 52 tt-param.cEmbarqueIni   AT 61 "|<   >|" AT 74 tt-param.cEmbarqueFim   SKIP(1)
        cParametro              AT 0                                                                        SKIP(1)
        cItensLi                AT 0 tt-param.lItensLi                AT 62
        cEmbEncerrados          AT 30 tt-param.lEmbEncerrados         AT 62
        cSeleciona              AT 46 cSeleciona2                     AT 62
        cOrientacao             AT 50 cOrientacao2                    AT 62
        cEnviaDoctoDespachante  AT 30 tt-param.lEnviaDoctoDespachante AT 62
        cArquivoCopia           AT 44 tt-param.cArquivoCopia          AT 62
        cUtilLayoutPadImp       AT 10 tt-param.lLayoutPadImp          AT 62
        cLayoutPadImp           AT 47 tt-param.cLayoutPadImp          AT 62
        cSobrepor               AT 29 tt-param.lSobrepor              AT 62
        cDirDestino             AT 51 tt-param.cDirDestino            AT 62                                  SKIP(1)     
        cImpressao                                                                                           SKIP(1)
        cDestino                AT 53 cDestino2                       AT 62.
    
    IF tt-param.destino = 2 THEN 
        PUT cArquivo            AT 53 tt-param.arquivo                AT 62.

    PUT SKIP(1).
END PROCEDURE.


