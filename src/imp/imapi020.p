USING PROGRESS.json.*.
USING PROGRESS.json.ObjectModel.*.
USING com.totvs.framework.api.*.

/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.    
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI020 2.00.00.010} /*** "010010" 01/10/2026 09:25:03 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IMAPI020 MIM}                               
&ENDIF

/****************************************************************************
**
**  Programa: IMAPI020.P - API de integraá∆o de DUIMP com o Siscomex
**  Objetivo: Gerar o XML de integraá∆o e enviar para o webservice do Siscomex
**
*******************************************************************************/

{method/dbotterr.i}                           /* RowErrors               */
{cxbo/bocx00482.i tt-item-atrib-siscomex}     /* tt-item-atrib-siscomex  */
{cxbo/bocx00487.i tt-duimp-siscomex}          /* tt-duimp-siscomex       */
{cxbo/bocx00488.i tt-duimp-item}              /* tt-duimp-item           */
{cxbo/bocx00489.i tt-duimp-docto}             /* tt-duimp-docto          */
{cxbo/bocx00492.i tt-duimp-acres-deduc-it}    /* tt-duimp-acres-deduc-it */
{cxbo/bocx00493.i tt-duimp-certific-it}       /* tt-duimp-certific-it    */
{imp/imapi020.i}
{imp/impTributosTTCE.i}

/* Controle dos itens enviados em cada lote, para gravar duimp-item.versao apos retorno */
DEFINE TEMP-TABLE tt-ctrl-item-post NO-UNDO
    FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-ctrl-item-put NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE VARIABLE h-bocx00482           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00487           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00488           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00489           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00492           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00493           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin01092           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005             AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-imapi019            AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-utapi033            AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-resultado   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lHistEnvio            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lcbody                AS longchar    NO-UNDO.
DEFINE VARIABLE cDirFileJson          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-return              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSiglaMoeda           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-tipo-importador     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-tp-identific-carga  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-mot-esp-despacho    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-cpf              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-cnpj             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-integrado        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-return-integrado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-arq-gerado       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-erro-export-info AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-com-erro         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-situacao         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-cod-erro         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-desc-erro        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-ret-sisco        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-desc-integr     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-arquivo-json   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-planilha       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-arquivo        AS CHARACTER   NO-UNDO.    
DEFINE VARIABLE c-titulo              AS character   NO-UNDO.
define variable c-lb-administ         as character   no-undo.
DEFINE VARIABLE c-url-end-point       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUnidadeDeclarada     AS CHARACTER   NO-UNDO.
define variable cValorTratado         as character   no-undo.
define var posPonto as integer no-undo.
DEFINE VARIABLE pCnpjCPF              AS CHARACTER   NO-UNDO.
define variable cMetodo               as character   no-undo.
define variable i-cont                as integer     no-undo.
DEFINE VARIABLE oJsonDuimp            AS JsonObject  NO-UNDO.
DEFINE variable d-cod-duimp-dts       LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
DEFINE VARIABLE lcResponse            AS LONGCHAR    NO-UNDO.

FUNCTION fnMultivalorado RETURNS LOGICAL
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER )  FORWARD.

FUNCTION fnValorAtrib RETURNS CHARACTER
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER,
    pTipoValor   AS CHARACTER)  FORWARD.

FUNCTION fnFormaPreench RETURNS CHARACTER
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER )  FORWARD.

{utp/ut-liter.i "exportar_as_informaá‰es_da_DUIMP" *}
ASSIGN c-lb-erro-export-info = TRIM(RETURN-VALUE).
{utp/ut-liter.i "CPF" *}
ASSIGN c-lb-cpf = TRIM(RETURN-VALUE).
{utp/ut-liter.i "CNPJ" *}
ASSIGN c-lb-cnpj = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Retorno_Siscomex" *}
ASSIGN c-lb-ret-sisco = TRIM(RETURN-VALUE).
{utp/ut-liter.i "ADMINISTRATIVO" *}
assign c-lb-administ = trim(return-value).
{utp/ut-liter.i Com_Erro *}
ASSIGN c-lb-com-erro = RETURN-VALUE.
{utp/ut-liter.i "Situaá∆o" *}
ASSIGN c-lb-situacao = TRIM(RETURN-VALUE).
{utp/ut-liter.i "C¢digo_Erro" *}
ASSIGN c-lb-cod-erro = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Descriá∆o_Erro" *}
ASSIGN c-lb-desc-erro = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Descriá∆o_Integraá∆o" *}
ASSIGN c-lb-desc-integr = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Relat¢rio_de_Status_de_Integraá∆o_de_DUIMP" *}
ASSIGN c-titulo            = RETURN-VALUE.
{utp/ut-liter.i "Integrado" *}
ASSIGN c-lb-return-integrado = RETURN-VALUE.
{utp/ut-liter.i "Retorno_da_Integraá∆o" *}
ASSIGN c-lb-integrado = RETURN-VALUE.
{utp/ut-liter.i "Arquivo_gerado" *}
ASSIGN c-lb-arq-gerado = RETURN-VALUE.


PROCEDURE executaEnvioSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Envio de DUIMP para o Siscomex  
  Parameters: pcod-duimp-dts     (INPUT - integer): C¢digo da DUIMP Interno
              pcDiretorioGeracao (INPUT - character): Indica o diret¢rio onde o arquivo ser† 
                                                      gerado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts      LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER lSomenteJsonLocal   AS LOGICAL                        NO-UNDO.    
    DEFINE INPUT PARAMETER pcDiretorioGeracao  AS CHARACTER                      NO-UNDO.
        
    DEFINE VARIABLE c-diretorio                AS CHARACTER               NO-UNDO.    
    DEFINE VARIABLE c-tit-erro                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE c-lbl-erro                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE l-geracao-valida           AS LOGICAL INIT YES        NO-UNDO.
    DEFINE VARIABLE i-num-versao               AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE iRowsReturned              AS INTEGER                 NO-UNDO.    
    DEFINE VARIABLE oJsonDuimpAux              AS JsonObject              NO-UNDO.    
    DEFINE VARIABLE oJsonIndentific            AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonImport                AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonCarga                 AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonUnidDecl              AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonSeguro                AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonFrete                 AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonPaisProced            AS JsonObject              NO-UNDO.
    
    DEFINE VARIABLE oJsonDocto                 AS JsonObject              NO-UNDO.
    DEFINE VARIABLE aJsonDocto                 AS JsonArray              NO-UNDO.
    DEFINE VARIABLE aJsonDoctoInstr            AS JsonArray               NO-UNDO.
    DEFINE VARIABLE oJsonDoctoInstr            AS JsonObject               NO-UNDO.
    DEFINE VARIABLE oJsonDoctoTipo             AS JsonObject              NO-UNDO.
    DEFINE VARIABLE oJsonDoctoTipoObj          AS JsonObject              NO-UNDO.    
    DEFINE VARIABLE oJsonDoctoChave            AS JsonArray               NO-UNDO.
    DEFINE VARIABLE aJsonDoctoChave            AS JsonArray               NO-UNDO.
    
    DEFINE VARIABLE oJsonDoctoChaveObj         AS JsonObject              NO-UNDO.
    
    DEFINE VARIABLE oJsonProcesso              AS JsonArray               NO-UNDO.
    DEFINE VARIABLE oJsonProcessoObj           AS JsonObject              NO-UNDO.    

    DEFINE VARIABLE oJsonDuimpDEE              AS JsonArray               NO-UNDO.
    DEFINE VARIABLE oJsonDuimpDEEObj           AS JsonObject              NO-UNDO.    
    
    assign c-nome-planilha     = "IM7000f":U
           c-nome-arquivo      = "IM7000_Relat_Integr_Itens_DUIMP":U
           c-nome-arquivo-json = "Integracao_DUIMP":U
                               + REPLACE(STRING(TODAY,"99/99/99"), "/","-") 
                               + "_":U
                               + REPLACE(STRING(TIME,"hh:mm:ss"), ":","-") 
                               + ".json":U
           c-diretorio         = pcDiretorioGeracao
           d-cod-duimp-dts     = pcod-duimp-dts.

    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE ttDuimpInstr.
    EMPTY TEMP-TABLE ttDuimpPalavrasChave.
    EMPTY TEMP-TABLE ttDuimpProcessos.
    EMPTY TEMP-TABLE ttDuimpDEE.
    
    IF  c-diretorio = "":U THEN DO:
        {utp/ut-liter.i Diret¢rio_para_geraá∆o * }
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 265,
                                              INPUT RETURN-VALUE).
        ASSIGN l-geracao-valida = NO. 
    END.

    IF c-diretorio <> "":U THEN DO:
        ASSIGN FILE-INFO:FILE-NAME = c-diretorio.
        /* Diret¢rio de geraá∆o n∆o existe */
        IF FILE-INFO:FILE-TYPE <> "DRW":U THEN DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 4715,
                                                  INPUT c-diretorio).
            ASSIGN l-geracao-valida = NO.                
        END.
        ELSE DO:
            IF  SUBSTRING(c-diretorio, LENGTH(c-diretorio), 1) <> "/":U 
            AND SUBSTRING(c-diretorio, LENGTH(c-diretorio), 1) <> "\":U THEN DO:
                IF OPSYS = "WIN32":U THEN 
                    ASSIGN c-diretorio = c-diretorio + "\":U.
                ELSE
                    ASSIGN c-diretorio = c-diretorio + "/":U.
            END.
        END.
    END.

    IF l-geracao-valida THEN DO:
        IF  NOT VALID-HANDLE(h-boun005) THEN DO:
            run unbo/boun005.p persistent set h-boun005.
            RUN openquery IN h-boun005 (INPUT 1).            
        END.
    
        IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
            RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
            RUN openQueryStatic IN h-bocx00487 (INPUT "Main":U) NO-ERROR.
        END.

        IF NOT VALID-HANDLE(h-bocx00489) THEN DO:
            RUN cxbo/bocx00489.p PERSISTENT SET h-bocx00489.
            RUN openQueryStatic IN h-bocx00489 (INPUT "Main":U) NO-ERROR.
        END.        
        
        RUN goToKey   IN h-bocx00487 (INPUT pcod-duimp-dts).
        RUN getRecord IN h-bocx00487 (OUTPUT TABLE tt-duimp-siscomex).

        /* Geraá∆o do Json */
        FIND FIRST tt-duimp-siscomex NO-LOCK NO-ERROR.        
        IF AVAIL tt-duimp-siscomex THEN DO:
        
            if tt-duimp-siscomex.cod-duimp-siscomex = "" then
                assign cMetodo = "POST":U.
            else
                assign cMetodo = "PUT":U.
        
            FIND FIRST param-imp NO-LOCK
                 WHERE param-imp.cod-estabel = tt-duimp-siscomex.cod-estabel NO-ERROR.
        
            ASSIGN v-tipo-importador    = if tt-duimp-siscomex.tipo-importador = 1 then TRIM(c-lb-cpf) ELSE TRIM(c-lb-cnpj)
                   v-tp-identific-carga = {cxinc/i03cx00487.i 04 tt-duimp-siscomex.tp-identific-carga}
                   v-mot-esp-despacho   = IF tt-duimp-siscomex.sit-esp-despacho THEN {cxinc/i04cx00487.i 04 tt-duimp-siscomex.mot-esp-despacho} ELSE "".
            
            /* Identificaá∆o */
            ASSIGN oJsonIndentific = NEW JsonObject().

            /* Importador */
            ASSIGN oJsonImport = NEW JsonObject().
            oJsonImport:ADD("tipoImportador",v-tipo-importador).        
            oJsonImport:ADD("ni",string(tt-duimp-siscomex.ni-importador)).        

            oJsonIndentific:ADD("importador",oJsonImport).
            oJsonIndentific:ADD("informacaoComplementar",tt-duimp-siscomex.des-inform-compl).            
            
            /* Carga */
            ASSIGN oJsonCarga = NEW JsonObject().
            IF tt-duimp-siscomex.cod-identific-carga <> "" THEN DO:    
                oJsonCarga:ADD("tipoIdentificacaoCarga",v-tp-identific-carga).        
                oJsonCarga:ADD("identificacao",tt-duimp-siscomex.cod-identific-carga).
            END.

            /* Unidade Declarada */
            ASSIGN oJsonUnidDecl = NEW JsonObject().
            IF LENGTH(tt-duimp-siscomex.cdn-urf-despch) < 7 THEN
                cUnidadeDeclarada = FILL("0", 7 - LENGTH(tt-duimp-siscomex.cdn-urf-despch)) + string(tt-duimp-siscomex.cdn-urf-despch).
            oJsonUnidDecl:ADD("codigo", cUnidadeDeclarada).
            
            oJsonCarga:ADD("unidadeDeclarada",oJsonUnidDecl).
            oJsonCarga:ADD("motivoSituacaoEspecial",v-mot-esp-despacho).                                    

            FOR FIRST decla-import NO-LOCK
                WHERE decla-import.num-di-ems = int(tt-duimp-siscomex.cod-duimp-dts)
                AND   decla-import.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts,
                FIRST decla-import-adic NO-LOCK
                WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
            END.
            IF AVAIL decla-import-adic THEN DO:
            
            
                /* Seguro */
                RUN pi-retornaMoeda (INPUT decla-import-adic.cdn-moed-seguro,
                                     OUTPUT cSiglaMoeda).        
                                     
                ASSIGN oJsonSeguro = NEW JsonObject().
                oJsonSeguro:ADD("codigoMoedaNegociada",cSiglaMoeda).        
                
                IF decla-import-adic.cdn-moed-seguro <> param-imp.int-2  THEN
                    oJsonSeguro:ADD("valorMoedaNegociada",decla-import.val-seguro-me[1]).
                ELSE
                    oJsonSeguro:ADD("valorMoedaNegociada",decla-import.val-seguro-me[2]).

                oJsonCarga:ADD("seguro",oJsonSeguro).
                
                /* Frete */
                RUN pi-retornaMoeda (INPUT decla-import-adic.cdn-moed-frete,
                                     OUTPUT cSiglaMoeda).                           

                IF v-tp-identific-carga <> "CE" THEN DO:
                    
                    ASSIGN oJsonFrete = NEW JsonObject().        
                    oJsonFrete:ADD("codigoMoedaNegociada",cSiglaMoeda).        
                
                    IF decla-import-adic.cdn-moed-frete <> param-imp.int-2  THEN
                        oJsonFrete:ADD("valorMoedaNegociada",decla-import.val-frete-me[1]).
                    ELSE
                        oJsonFrete:ADD("valorMoedaNegociada",decla-import.val-frete-me[2]).

                    oJsonCarga:ADD("frete",oJsonFrete).
                
                END.
            END.
            
            /* Pais Procedància */
            ASSIGN oJsonPaisProced = NEW JsonObject().        
            oJsonPaisProced:ADD("codigo",tt-duimp-siscomex.cod-pais-iso).        
            
            oJsonCarga:ADD("paisProcedencia",oJsonPaisProced).

            ASSIGN oJsonDuimpAux = NEW JsonObject().
            ASSIGN oJsonDuimp = NEW JsonObject().
            oJsonDuimp:ADD("identificacao",oJsonIndentific).
            oJsonDuimp:ADD("carga",oJsonCarga).            
            
            /* Documentos */ 
            RUN setConstraintbyDuimp IN h-bocx00489 (INPUT pcod-duimp-dts).
            RUN openQueryStatic      IN h-bocx00489 (INPUT "byDuimp":U) NO-ERROR.
            RUN getBatchRecords      IN h-bocx00489 (INPUT  ?,
                                                     INPUT  NO,
                                                     INPUT  ?,
                                                     OUTPUT iRowsReturned,
                                                     OUTPUT TABLE tt-duimp-docto).

            
            FOR each tt-duimp-docto NO-LOCK
                where tt-duimp-docto.documento = 1 /* Documento */
                BREAK BY tt-duimp-docto.cod-duimp-dts
                      BY tt-duimp-docto.documento
                      by tt-duimp-docto.cod-tipo-docto:

                IF FIRST-OF(tt-duimp-docto.cod-tipo-docto) THEN DO:
                    CREATE ttDuimpInstr.
                    ASSIGN ttDuimpInstr.cod-duimp-dts = tt-duimp-docto.cod-duimp-dts
                           ttDuimpInstr.cod-tipo-docto = tt-duimp-docto.cod-tipo-docto.
                END. 
                
                ASSIGN cValorTratado = tt-duimp-docto.valor.
                IF tt-duimp-docto.cod-chave = 12 or tt-duimp-docto.cod-chave = 6 THEN DO:
                
                    ASSIGN cValorTratado = STRING(DECIMAL(tt-duimp-docto.valor) / 100).
                    /* troca v°rgula por ponto */
                    cValorTratado = REPLACE(cValorTratado, ",", ".").

                    posPonto = INDEX(cValorTratado, ".").

                    /* garante zero antes do ponto */
                    IF posPonto = 1 THEN
                        cValorTratado = "0" + cValorTratado.

                    /* garante duas casas decimais */
                    posPonto = INDEX(cValorTratado, ".").

                    IF posPonto = 0 THEN
                        cValorTratado = cValorTratado + ".00".
                    ELSE IF LENGTH(cValorTratado) - posPonto = 1 THEN
                        cValorTratado = cValorTratado + "0".
                END.
                
                CREATE ttDuimpPalavrasChave.
                ASSIGN ttDuimpPalavrasChave.cod-duimp-dts  = tt-duimp-docto.cod-duimp-dts
                       ttDuimpPalavrasChave.cod-tipo-docto = tt-duimp-docto.cod-tipo-docto
                       ttDuimpPalavrasChave.tipoCodigo     = tt-duimp-docto.documento
                       ttDuimpPalavrasChave.codigo         = tt-duimp-docto.cod-chave
                       ttDuimpPalavrasChave.valor          = cValorTratado.
                       
            END.

            ASSIGN oJsonDocto = NEW JsonObject().            
            ASSIGN aJsonDoctoInstr = NEW JsonArray().            

            FOR EACH ttDuimpInstr NO-LOCK:
                ASSIGN oJsonDoctoTipo    = NEW JsonObject().
                ASSIGN oJsonDoctoTipoObj = NEW JsonObject().
                oJsonDoctoTipoObj:ADD("codigo":U,ttDuimpInstr.cod-tipo-docto).
                oJsonDoctoTipo:ADD("tipo":U,oJsonDoctoTipoObj).
                
                aJsonDoctoInstr:ADD(oJsonDoctoTipo).
                
                ASSIGN aJsonDoctoChave = NEW JsonArray().
                FOR EACH ttDuimpPalavrasChave NO-LOCK
                    WHERE ttDuimpPalavrasChave.cod-duimp-dts  = ttDuimpInstr.cod-duimp-dts
                    AND   ttDuimpPalavrasChave.cod-tipo-docto = ttDuimpInstr.cod-tipo-docto:
                    ASSIGN oJsonDoctoChaveObj = NEW JsonObject().
                    oJsonDoctoChaveObj:ADD("codigo":U,ttDuimpPalavrasChave.codigo).
                    oJsonDoctoChaveObj:ADD("valor":U,ttDuimpPalavrasChave.valor).
                    
                    aJsonDoctoChave:ADD(oJsonDoctoChaveObj).
                
                END.
                oJsonDoctoTipo:ADD("palavrasChave":U,aJsonDoctoChave).
            
            END.
            
            oJsonDuimpAux:add("documentosInstrucao":U,aJsonDoctoInstr).

            ASSIGN oJsonProcesso = NEW JsonArray().
            
            FOR each tt-duimp-docto NO-LOCK
                where tt-duimp-docto.documento = 2 /* Processo/Dossià */
                BREAK BY tt-duimp-docto.cod-duimp-dts
                      BY tt-duimp-docto.documento:

                ASSIGN oJsonProcessoObj = NEW JsonObject().
                oJsonProcessoObj:ADD("identificacao":U,tt-duimp-docto.valor).
                oJsonProcessoObj:ADD("tipo":U,caps(c-lb-administ)).
                oJsonProcesso:ADD(oJsonProcessoObj).
            END.
        
            oJsonDuimpAux:add("processos":U,oJsonProcesso).

            ASSIGN oJsonDuimpDEE = NEW JsonArray().
            
            FOR each tt-duimp-docto NO-LOCK
                where tt-duimp-docto.documento = 3 /* Declaraá∆o */
                BREAK BY tt-duimp-docto.cod-duimp-dts
                      BY tt-duimp-docto.documento
                      by tt-duimp-docto.seq-docto:

                IF  tt-duimp-docto.cod-chave = 1 THEN DO:
                    ASSIGN oJsonDuimpDEEObj = NEW JsonObject().
                    oJsonDuimpDEEObj:ADD("numero":U,tt-duimp-docto.valor).
                END.
                ELSE
                IF  tt-duimp-docto.cod-chave = 2 THEN
                    oJsonDuimpDEEObj:ADD("faixaInicio":U,tt-duimp-docto.valor).
                ELSE DO:
                    oJsonDuimpDEEObj:ADD("faixaFim":U,tt-duimp-docto.valor).
                    oJsonDuimpDEE:ADD(oJsonDuimpDEEObj).
                END.
            END.

            oJsonDuimpAux:add("declaracoesExportacaoEstrangeira":U,oJsonDuimpDEE).
            
            oJsonDuimp:add("documentos":U,oJsonDuimpAux).            
            
            oJsonDuimp:writefile(c-diretorio + c-nome-arquivo-json, YES).
                        
            RUN createResult IN THIS-PROCEDURE (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                INPUT lSomenteJsonLocal).
            
            if not lSomenteJsonLocal then do:
            
                if cMetodo = "PUT" then
                    ASSIGN c-url-end-point = "/duimp-api/api/ext/duimp/" + string(tt-duimp-siscomex.cod-duimp-siscomex) + "/" + string(tt-duimp-siscomex.num-versao-duimp).
                else
                    ASSIGN c-url-end-point = "/duimp-api/api/ext/duimp":U.
                    
                fix-codepage(lcbody) = 'UTF-8'.
                oJsonDuimp:Write(lcbody,TRUE).
                
                run piIntegraDUIMP(input lcbody,
                                   INPUT c-url-end-point,
                                   input cMetodo).                
                log-manager:WRITE-MESSAGE(">>> apos integrar duimp") no-error.
                
                FIND FIRST ttReturnHttpRequest NO-ERROR.
                IF AVAIL ttReturnHttpRequest
                     and ttReturnHttpRequest.numero <> "" THEN DO:                         
                    ASSIGN i-num-versao = INT(ttReturnHttpRequest.versao) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN
                        ASSIGN i-num-versao = 0.
                    
                    log-manager:write-message(">>> atribui retorno da capa duimp") no-error.
                    log-manager:write-message(">>> versao: " + string(ttReturnHttpRequest.versao)) no-error.
                    log-manager:write-message(">>> numero duimp: " + string(ttReturnHttpRequest.numero)) no-error.
                    
                    ASSIGN tt-duimp-siscomex.num-versao-duimp   = IF tt-duimp-siscomex.num-versao-duimp < i-num-versao THEN i-num-versao ELSE tt-duimp-siscomex.num-versao-duimp
                           tt-duimp-siscomex.cod-duimp-siscomex = TRIM(STRING(ttReturnHttpRequest.numero))
                           tt-duimp-siscomex.dtz-reg-siscomex = today
                           tt-duimp-siscomex.idi-sit-siscomex = 12.
                           
                    RUN setRecord    IN h-bocx00487 (INPUT TABLE tt-duimp-siscomex).
                    RUN updateRecord IN h-bocx00487.
                END.
                ELSE DO:
                    /* Cria registro do cmapo message para exibir na planilha */
                    FOR EACH ttReturnHttpRequest WHERE ttReturnHttpRequest.mensagem <> "" :
                        CREATE tt-result.
                        ASSIGN tt-result.des-msg     = ttReturnHttpRequest.mensagem
                               tt-result.desc-status = c-lb-desc-integr.
                    END.
                END.
            end.
        END.
        else
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 30639,
                                                  INPUT c-lb-erro-export-info).
        RUN geraArquivoResultado (INPUT c-titulo,
                                          INPUT c-nome-planilha,
                                          INPUT c-nome-arquivo,
                                          INPUT IF l-geracao-valida AND c-diretorio <> "":U THEN c-diretorio ELSE SESSION:TEMP-DIRECTORY,
                                          OUTPUT c-arquivo-resultado).
    
    END.

    IF VALID-HANDLE(h-bocx00487) THEN DO:
        DELETE PROCEDURE h-bocx00487.
        ASSIGN h-bocx00487 = ?.
    END.

    IF VALID-HANDLE(h-bocx00489) THEN DO:
        DELETE PROCEDURE h-bocx00489.
        ASSIGN h-bocx00489 = ?.
    END.    
    
    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE executaEnvioSiscomexItens:
/*:T-----------------------------------------------------------------------------------------------
  Purpose...: Envio de Itens da DUIMP para o Siscomex  
  Parameters: pcod-duimp-dts     (INPUT - integer): C¢digo da DUIMP Interno
              pcDiretorioGeracao (INPUT - character): Indica o diret¢rio onde o arquivo ser† gerado  
---------------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-duimp-dts      LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
    DEFINE INPUT  PARAMETER lSomenteJsonLocal   AS LOGICAL                        NO-UNDO.
    DEFINE INPUT  PARAMETER pcDiretorioGeracao  AS CHARACTER                      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE c-diretorio                AS CHARACTER                  NO-UNDO.    
    DEFINE VARIABLE c-lbl-erro                 AS CHARACTER   EXTENT 5       NO-UNDO.
    DEFINE VARIABLE vc-forma-preench           AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-ni-importador            AS CHARACTER   FORMAT 'x(14)' NO-UNDO.
    DEFINE VARIABLE c-cdn-fabrican             AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-cdn-export               AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE vl-multivalorado           AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-geracao-valida           AS LOGICAL     INIT YES       NO-UNDO.
    DEFINE VARIABLE iRowsReturned              AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-linhas-return            AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-num-versao               AS INTEGER                    NO-UNDO.
    
    
    DEFINE VARIABLE oJsonItemDuimp             AS JsonObject                 NO-UNDO.    
    DEFINE VARIABLE oJsonDuimpAux              AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonIndentific            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonProduto               AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCaracImp              AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonIndExpFab             AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonFabric                AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonFrete                 AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonSeguro                AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonPaisFabric            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonExport                AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonPaisExport            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonIndExpVend            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonMercadoria            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonTipoAplic             AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonMoedaNeg              AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCondicVda             AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonLpcos                 AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCertifMerco           AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonDecVinc               AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonDadoCamb              AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonLocalConsumo          AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonAtribDuimp            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonAtribFund             AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonMetVal                AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonIncoterm              AS JsonObject                 NO-UNDO.                    
    DEFINE VARIABLE oJsonAcresDeduc            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsontipoAcresDeduc        AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonAcresDeducAux         AS JsonObject                 NO-UNDO.    
    DEFINE VARIABLE oJsonMoedaAD               AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCodigoAD              AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonVlrAD                 AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonDenominacao           AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCodigoDen             AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonMotSCob               AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonInstFinanc            AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonCoberturaCamb         AS JsonObject                 NO-UNDO.
    DEFINE VARIABLE oJsonAtributoAux           AS JsonObject                 NO-UNDO.
        
    DEFINE VARIABLE oJsonDuimpArray            AS JsonArray                  NO-UNDO.
    DEFINE VARIABLE oJsonAcresDeducArray       AS JsonArray                  NO-UNDO.
    DEFINE VARIABLE oJsonAtributoArray         AS JsonArray                  NO-UNDO. 
    DEFINE VARIABLE oJsonTribAplicArr          AS JsonArray                  NO-UNDO.
    /* Arrays separados por metodo: POST (versao = 0) e PUT (versao > 0) */
    DEFINE VARIABLE oJsonArrayPost             AS JsonArray                  NO-UNDO.
    DEFINE VARIABLE oJsonArrayPut              AS JsonArray                  NO-UNDO.
    DEFINE VARIABLE c-nome-arquivo-json-put    AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE i-versao-item              AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE c-ttce-ncm                 AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-ttce-pais-num            AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE l-ttce-montou              AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE c-ttce-msg                 AS CHARACTER                  NO-UNDO.
    
    DEFINE BUFFER bfemitente-siscomex FOR emitente-siscomex.
    DEFINE BUFFER tt-bfemitente-siscomex FOR emitente-siscomex.
    
    assign c-nome-planilha     = "IM7000f":U
           c-nome-arquivo      = "IM7000_Relat_Integr_Itens_DUIMP":U
           c-nome-arquivo-json = "Integracao_DUIMP_Itens":U
                               + REPLACE(STRING(TODAY,"99/99/99"), "/","-") 
                               + "_":U
                               + REPLACE(STRING(TIME,"hh:mm:ss"), ":","-") 
                               + ".json":U
           c-diretorio         = pcDiretorioGeracao
           d-cod-duimp-dts     = pcod-duimp-dts.

    /* Nome do arquivo JSON do lote PUT (o POST usa c-nome-arquivo-json com sufixo _POST) */
    ASSIGN c-nome-arquivo-json-put = REPLACE(c-nome-arquivo-json, ".json":U, "_PUT.json":U).

    EMPTY TEMP-TABLE RowErrors.
    
    IF NOT VALID-HANDLE(h-bocx00492) then
        RUN cxbo/bocx00492.p PERSISTENT SET h-bocx00492.

    IF NOT VALID-HANDLE(h-bocx00482) THEN
        run cxbo/bocx00482.p persistent set h-bocx00482.

    IF not valid-handle(h-boin01092) then
        run inbo/boin01092.p persistent set h-boin01092.
    
    IF  c-diretorio = "":U THEN DO:
        {utp/ut-liter.i Diret¢rio_para_geraá∆o * }
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 265,
                                              INPUT RETURN-VALUE).
        ASSIGN l-geracao-valida = NO. 
    END.

    IF c-diretorio <> "":U THEN DO:
        ASSIGN FILE-INFO:FILE-NAME = c-diretorio.
        /* Diret¢rio de geraá∆o n∆o existe */
        IF FILE-INFO:FILE-TYPE <> "DRW":U THEN DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 4715,
                                                  INPUT c-diretorio).
            ASSIGN l-geracao-valida = NO.                
        END.
        ELSE DO:
            IF  SUBSTRING(c-diretorio, LENGTH(c-diretorio), 1) <> "/":U 
            AND SUBSTRING(c-diretorio, LENGTH(c-diretorio), 1) <> "\":U THEN DO:
                IF OPSYS = "WIN32":U THEN 
                    ASSIGN c-diretorio = c-diretorio + "\":U.
                else
                    ASSIGN c-diretorio = c-diretorio + "/":U.
            END.
        END.
    END.

    IF l-geracao-valida THEN DO:        
    
        IF  NOT VALID-HANDLE(h-boun005) THEN DO:
            run unbo/boun005.p persistent set h-boun005.
            RUN openquery IN h-boun005 (INPUT 1).            
        END.
        
        IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
            RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
            RUN openQueryStatic IN h-bocx00487 (INPUT "Main":U) NO-ERROR.
        END.

        IF NOT VALID-HANDLE(h-bocx00489) THEN DO:
            RUN cxbo/bocx00489.p PERSISTENT SET h-bocx00489.
            RUN openQueryStatic IN h-bocx00489 (INPUT "Main":U) NO-ERROR.
        END.        

        IF NOT VALID-HANDLE(h-bocx00493) THEN
            RUN cxbo/bocx00493.p PERSISTENT SET h-bocx00493.
        
        RUN goToKey   IN h-bocx00487 (INPUT pcod-duimp-dts).
        RUN getRecord IN h-bocx00487 (OUTPUT TABLE tt-duimp-siscomex).

        /* Geraá∆o do Json */
        FIND FIRST tt-duimp-siscomex NO-LOCK NO-ERROR.        
        IF  AVAIL tt-duimp-siscomex THEN DO:

            IF NOT VALID-HANDLE(h-bocx00488) THEN DO:
                RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.                
                RUN setConstraintbyDuimp IN h-bocx00488 (INPUT pcod-duimp-dts) NO-ERROR.                
                RUN openQueryStatic IN h-bocx00488 (INPUT "ByDuimp":U) NO-ERROR.
            END.                      
            
            RUN getBatchRecords IN h-bocx00488 (INPUT  ?,
                                                INPUT  NO,
                                                INPUT  ?,
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-duimp-item).            
            IF CAN-FIND(FIRST tt-duimp-item) THEN DO:

                FIND FIRST param-imp NO-LOCK
                    WHERE param-imp.cod-estabel = tt-duimp-siscomex.cod-estabel NO-ERROR.

                FOR FIRST decla-import NO-LOCK
                    WHERE decla-import.num-di-ems = int(tt-duimp-siscomex.cod-duimp-dts)
                    AND   decla-import.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts,
                    FIRST decla-import-adic NO-LOCK
                    WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                    AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                END.
            
                ASSIGN oJsonDuimp       = NEW JsonObject().
                ASSIGN oJsonDuimpAux    = NEW JsonObject().                
                ASSIGN oJsonDuimpArray  = NEW JsonArray().                
                ASSIGN oJsonArrayPost   = NEW JsonArray().
                ASSIGN oJsonArrayPut    = NEW JsonArray().
                ASSIGN oJsonItemDuimp   = NEW JsonObject().
                EMPTY TEMP-TABLE tt-ctrl-item-post.
                EMPTY TEMP-TABLE tt-ctrl-item-put.

                /* TTCE: cache de tratamentos por NCM+pais (uma vez por envio) */
                EMPTY TEMP-TABLE tt-ttce-cache.

                FOR EACH tt-duimp-item by tt-duimp-item.seq-item:

                    FOR FIRST decla-import-adic NO-LOCK
                        WHERE decla-import-adic.num-di-ems = int(tt-duimp-item.cod-duimp-dts)
                        AND   decla-import-adic.num-adic   = tt-duimp-item.seq-item
                        AND   decla-import-adic.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts:
                    END.
                    IF NOT AVAIL decla-import-adic THEN NEXT.
                    
                    FOR FIRST item-siscomex NO-LOCK 
                        WHERE item-siscomex.cod-item = tt-duimp-item.cod-item:
                    END.
                    IF NOT AVAIL item-siscomex THEN NEXT.
                    
                    FOR FIRST bfemitente-siscomex NO-LOCK   //Fabricante
                        WHERE bfemitente-siscomex.cdn-emitente = integer(tt-duimp-item.cdn-fabrican):
                    END.
                    IF NOT AVAIL bfemitente-siscomex THEN NEXT.
                    
                    IF tt-duimp-item.ind-export-fabric <> 2 THEN DO: /* Exportador Diferente do Fabricante */
                    
                        FOR FIRST tt-bfemitente-siscomex NO-LOCK  //Exportador
                            WHERE tt-bfemitente-siscomex.cdn-emitente = integer(tt-duimp-item.cdn-exporta):
                        END.
                        IF NOT AVAIL tt-bfemitente-siscomex THEN NEXT.
                    END.
                    ASSIGN c-cdn-fabrican = SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35)
                           c-cdn-export = SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35).
                    
                    assign oJsonItemDuimp = new JsonObject().

                    /* Identificaá∆o */
                    ASSIGN oJsonIndentific = NEW JsonObject().
                    oJsonIndentific:ADD("numeroItem",tt-duimp-item.seq-item).
                    oJsonItemDuimp:ADD("identificacao",oJsonIndentific).
                    
                    /* produto */                    
                    ASSIGN oJsonProduto = NEW JsonObject().

                    IF tt-duimp-item.cod-item <> "" THEN DO:  //item-siscomex.cdd-produt
                        oJsonProduto:ADD("codigo",integer(item-siscomex.cdd-produt)).                    
                        oJsonProduto:ADD("versao",string(item-siscomex.cod-versao)).
                    END.
                    IF tt-duimp-item.ni-responsavel <> "" THEN
                        oJsonProduto:ADD("niResponsavel",tt-duimp-item.ni-responsavel).

                    oJsonItemDuimp:ADD("produto",oJsonProduto).

                    /* caracterizacaoImportacao */
                    ASSIGN oJsonCaracImp = NEW JsonObject().
                    oJsonCaracImp:ADD("indicador",{cxinc/i01cx00488.i 04 tt-duimp-item.caract-import}).

                    /* O atributo 'ni' Ç informado apenas quando o atributo 'indicador' possui um dos
                       seguintes valores: 'IMPORTACAO_POR_CONTA_E_ORDEM', 'IMPORTACAO_POR_ENCOMENDA' */
                    IF tt-duimp-item.caract-import = 2 OR           /* IMPORTACAO_POR_CONTA_E_ORDEM */ 
                       tt-duimp-item.caract-import = 3 THEN DO:     /* IMPORTACAO_POR_ENCOMENDA     */

                        IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
                            RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
                            RUN openQueryStatic IN h-bocx00487 (INPUT "Main":U) NO-ERROR.
                        END.

                        RUN goToKey IN h-bocx00487 (INPUT pcod-duimp-dts).
                        RUN getCharField IN h-bocx00487 (INPUT "ni-importador",
                                                         OUTPUT c-ni-importador).

                        IF c-ni-importador <> '' THEN
                            oJsonCaracImp:ADD("ni",c-ni-importador).
                    END.                    
                    oJsonItemDuimp:ADD("caracterizacaoImportacao",oJsonCaracImp).

                    /* indicadorExportadorFabricante */
                    ASSIGN oJsonIndExpFab = NEW JsonObject().
                    oJsonIndExpFab:ADD("codigo",{cxinc/i02cx00488.i 04 tt-duimp-item.ind-export-fabric}).
                    
                    oJsonItemDuimp:ADD("indicadorExportadorFabricante",oJsonIndExpFab).

                    /* fabricante */
                    ASSIGN oJsonFabric = NEW JsonObject().
                    /* Quando o pa°s de origem for "BR", este atributo dever† ser preenchido com o CNPJ ou CPF do Fabricante.
                       Quando o pa°s de origem for diferente de "BR", dever† ser utilizado o c¢digo do exportador estrangeiro. */
                    
                    IF tt-duimp-item.cod-pais-iso-fabric <> "BR" THEN DO:
                        IF tt-duimp-item.cdn-fabrican <> "" THEN
                            oJsonFabric:ADD("codigo", SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35)). 
                    END.                        
                    ELSE
                        IF tt-duimp-item.ni-oper-fabric <> '' THEN
                            oJsonFabric:ADD("codigo", SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35)). 
                    
                    IF tt-duimp-item.versao-fabric <> '' THEN
                        oJsonFabric:ADD("versao",tt-duimp-item.versao-fabric).

                    IF tt-duimp-item.ni-oper-fabric <> '' THEN DO:
                        ASSIGN pCnpjCPF = string(tt-duimp-item.ni-oper-fabric).
                        IF LENGTH(tt-duimp-item.ni-oper-fabric) = 14 THEN
                            ASSIGN pCnpjCPF = SUBSTRING(tt-duimp-item.ni-oper-fabric,1,8).
                        FIND FIRST item-fabrican-siscomex WHERE item-fabrican-siscomex.cod-item = tt-duimp-item.cod-item NO-LOCK NO-ERROR.
                        IF AVAIL item-fabrican-siscomex THEN
                            IF item-fabrican-siscomex.log-fabrican-conhecid THEN
                                oJsonFabric:ADD("niOperador",pCnpjCPF).
                    END.
                        

                    ASSIGN oJsonPaisFabric = NEW JsonObject().
                    oJsonPaisFabric:ADD("codigo",tt-duimp-item.cod-pais-iso-fabric).

                    oJsonFabric:ADD("pais",oJsonPaisFabric).
                    
                    oJsonItemDuimp:ADD("fabricante",oJsonFabric).

                    /* exportador */                    
                    ASSIGN oJsonExport = NEW JsonObject().                    
                    /* Quando o atributo "exportadorIndicadorFabricante" for preenchido com o valor "EXPORTADOR_IGUAL_FABRICANTE",
                       os valores informados neste grupo devem ser idànticos aos valores informados no grupo "Fabricante". */
                    IF tt-duimp-item.ind-export-fabric = 2 THEN DO: /* Exportador Igual ao Fabricante */
                        IF tt-duimp-item.cod-pais-iso-fabric <> "BR" THEN DO:
                            IF tt-duimp-item.cdn-fabrican <> "" THEN
                                oJsonExport:ADD("codigo",SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35)). 
                        END.                        
                        ELSE
                            IF tt-duimp-item.ni-oper-fabric <> '' THEN
                                oJsonExport:ADD("codigo",SUBSTRING(bfemitente-siscomex.cod-livre-1,1,35)).
                            
                        ASSIGN pCnpjCPF = string(tt-duimp-item.ni-oper-fabric).
                        IF LENGTH(tt-duimp-item.ni-oper-fabric) = 14 THEN
                            ASSIGN pCnpjCPF = SUBSTRING(tt-duimp-item.ni-oper-fabric,1,8).    
                        
                        oJsonExport:ADD("niOperador",pCnpjCPF).
                        oJsonExport:ADD("versao",tt-duimp-item.versao-fabric). 
                        
                        ASSIGN oJsonPaisExport = NEW JsonObject().
                        oJsonPaisExport:ADD("codigo",tt-duimp-item.cod-pais-iso-fabric).

                        oJsonExport:ADD("pais",oJsonPaisExport).
                        
                    END.
                    ELSE DO:                    
                        oJsonExport:ADD("codigo",SUBSTRING(tt-bfemitente-siscomex.cod-livre-1,1,35)). 
                        oJsonExport:ADD("versao",tt-duimp-item.versao-exporta).
                        
                        ASSIGN pCnpjCPF = STRING(tt-duimp-item.ni-oper-exporta).
                        IF LENGTH(tt-duimp-item.ni-oper-exporta) = 14 THEN
                            ASSIGN pCnpjCPF = SUBSTRING(tt-duimp-item.ni-oper-exporta,1,8).
                            
                        oJsonExport:ADD("niOperador",pCnpjCPF).

                        ASSIGN oJsonPaisExport = NEW JsonObject().
                        oJsonPaisExport:ADD("codigo",tt-duimp-item.cod-pais-iso-exporta).

                        oJsonExport:ADD("pais",oJsonPaisExport).
                    END.
                    
                    oJsonItemDuimp:ADD("exportador",oJsonExport).

                    /* indicadorCompradorVendedor */                    
                    ASSIGN oJsonIndExpVend = NEW JsonObject().
                    oJsonIndExpVend:ADD("codigo",{cxinc/i03cx00488.i 04 tt-duimp-item.idi-ind-vincul}).
                    
                    oJsonItemDuimp:ADD("indicadorCompradorVendedor",oJsonIndExpVend).

                    /* Mercadoria */                    
                    ASSIGN oJsonMercadoria = NEW JsonObject().

                    ASSIGN oJsonTipoAplic = NEW JsonObject().
                    oJsonTipoAplic:ADD("codigo",{cxinc/i04cx00488.i 04 tt-duimp-item.aplicacao}).

                    oJsonMercadoria:ADD("tipoAplicacao",oJsonTipoAplic).


                    oJsonMercadoria:ADD("condicao",{cxinc/i05cx00488.i 04 tt-duimp-item.condicao}).
                    oJsonMercadoria:ADD("unidadeComercial",tt-duimp-item.unid-com).
                    oJsonMercadoria:ADD("quantidadeComercial",tt-duimp-item.qtd-com).
                    oJsonMercadoria:ADD("quantidadeMedidaEstatistica",tt-duimp-item.qtd-med).
                    oJsonMercadoria:ADD("pesoLiquido",tt-duimp-item.peso-liq ).

                    ASSIGN oJsonMoedaNeg = NEW JsonObject().
                    
                    RUN pi-retornaMoeda (INPUT tt-duimp-item.mo-codigo,
                                         OUTPUT cSiglaMoeda).
                    
                    
                    oJsonMoedaNeg:ADD("codigo",cSiglaMoeda). /* Moeda negociada */  

                    oJsonMercadoria:ADD("moedaNegociada",oJsonMoedaNeg).

                    oJsonMercadoria:ADD("valorUnitarioMoedaNegociada",tt-duimp-item.vlr-unit-mo).
                    oJsonMercadoria:ADD("descricao",tt-duimp-item.desc-comp).

                    oJsonItemDuimp:ADD("mercadoria",oJsonMercadoria).
                    
                    /* condicaoVenda */                    
                    ASSIGN oJsonCondicVda = NEW JsonObject().

                    ASSIGN oJsonMetVal = NEW JsonObject().
                    oJsonMetVal:ADD("codigo",tt-duimp-item.cod-met-valora ).
                    oJsonCondicVda:ADD("metodoValoracao",oJsonMetVal).

                    ASSIGN oJsonIncoterm = NEW JsonObject().
                    oJsonIncoterm:ADD("codigo",tt-duimp-item.incoterm). //i06cx00488ajustar codigos
                    oJsonIncoterm:ADD("complemento",tt-duimp-item.compl-incoterm).
                    oJsonCondicVda:ADD("incoterm",oJsonIncoterm).

                    IF tt-duimp-siscomex.cod-identific-carga = "" THEN DO:
                    
                        ASSIGN oJsonFrete = NEW JsonObject().         
                        IF decla-import-adic.cdn-moed-seguro <> param-imp.int-2  THEN
                            oJsonFrete:ADD("valor",decla-import-adic.val-frete-me[1]).
                        ELSE 
                            oJsonFrete:ADD("valor",decla-import-adic.val-frete-me[2]).
                        oJsonCondicVda:ADD("frete",oJsonFrete).

                        ASSIGN oJsonSeguro = NEW JsonObject().       
                        IF decla-import-adic.cdn-moed-seguro <> param-imp.int-2  THEN
                            oJsonSeguro:ADD("valor",decla-import-adic.val-seguro-me[1]).
                        ELSE
                            oJsonSeguro:ADD("valor",decla-import-adic.val-seguro-me[2]).
                        oJsonCondicVda:ADD("seguro",oJsonSeguro).
                    
                    END.

                    oJsonItemDuimp:ADD("condicaoVenda",oJsonCondicVda).


                    /* acrescimosDeducoes */ 
                    empty temp-table tt-duimp-acres-deduc-it.

                    RUN setConstraintByDuimpItem IN h-bocx00492 (INPUT tt-duimp-item.cod-duimp-dts,
                                                                 INPUT tt-duimp-item.cod-item,
                                                                 INPUT tt-duimp-item.seq-item).
                    
                    RUN openQueryStatic        IN h-bocx00492 (INPUT "ByDuimpItem":U).
                    RUN getBatchRecords        IN h-bocx00492 (INPUT  ?,
                                                               INPUT  ?,
                                                               INPUT  99999,
                                                               OUTPUT i-linhas-return,
                                                               OUTPUT TABLE tt-duimp-acres-deduc-it).
                    IF CAN-FIND(FIRST tt-duimp-acres-deduc-it) THEN DO:                    
                        ASSIGN oJsonAcresDeduc = NEW JsonObject().                    
                        ASSIGN oJsonAcresDeducArray = NEW JsonArray().
                        FOR each tt-duimp-acres-deduc-it:                        
                            ASSIGN oJsonAcresDeducAux = NEW JsonObject().
                            oJsonAcresDeducAux:add("tipo",{cxinc/i01cx00492.i 04 tt-duimp-acres-deduc-it.idi-tipo}).
                            

                            ASSIGN oJsonMoedaAD = NEW JsonObject().

                            oJsonMoedaAD:add("codigo",tt-duimp-acres-deduc-it.cdn-moeda).
                            oJsonMoedaAD:add("valor",tt-duimp-acres-deduc-it.valor).
                            
                            oJsonAcresDeducAux:add("moeda",oJsonMoedaAD).

                            ASSIGN oJsonDenominacao = NEW JsonObject().

                            oJsonDenominacao:add("codigo",tt-duimp-acres-deduc-it.cdn-acres-deduc).
                            oJsonAcresDeducAux:add("denominacao",oJsonDenominacao).
                                                                            
                            oJsonAcresDeducArray:add(oJsonAcresDeducAux).                        
                        END.
                        oJsonItemDuimp:add("acrescimosDeducoes",oJsonAcresDeducArray).
                    END.
                    
                    /* lpcos */
                    /*ASSIGN oJsonLpcos = NEW JsonObject().                    
                    oJsonItemDuimp:ADD("lpcos",oJsonLpcos).*/
                    

                    /* certificadoMercosul */
                    /*ASSIGN oJsonCertifMerco = NEW JsonObject().                    
                    oJsonItemDuimp:add("certificadoMercosul",oJsonAcresDeducArray).*/
                    
                    /* declaracoesVinculadas */                    
                    /*ASSIGN oJsonDecVinc = NEW JsonObject().                    
                    oJsonItemDuimp:ADD("declaracoesVinculadas",oJsonDecVinc).*/

                    
                    /* dadosCambiais */                    
                    ASSIGN oJsonDadoCamb = NEW JsonObject().

                    ASSIGN oJsonCoberturaCamb = NEW JsonObject().
                    oJsonCoberturaCamb:ADD("codigo",{cxinc/i07cx00488.i 04 tt-duimp-item.cobertura-camb}). 
                    oJsonDadoCamb:ADD("coberturaCambial",oJsonCoberturaCamb).

                    IF tt-duimp-item.numero-rof <> "" THEN
                        oJsonDadoCamb:ADD("numeroROF",tt-duimp-item.numero-rof).                    

                    IF tt-duimp-item.cod-institut-finan <> 0 THEN DO:
                        ASSIGN oJsonInstFinanc = NEW JsonObject().
                        oJsonInstFinanc:ADD("codigo",tt-duimp-item.cod-institut-finan).
                        oJsonDadoCamb:ADD("instituicaoFinanciadora",oJsonInstFinanc).
                    END.

                    IF tt-duimp-item.val-cob-camb <> 0 THEN
                        oJsonDadoCamb:ADD("valorCoberturaCambial",tt-duimp-item.val-cob-camb).

                    IF tt-duimp-item.cod-mot-sem-cob <> 0 THEN DO:
                        ASSIGN oJsonMotSCob = NEW JsonObject().
                        oJsonMotSCob:ADD("codigo",tt-duimp-item.cod-mot-sem-cob ).
                        oJsonDadoCamb:ADD("motivoSemCobertura",oJsonMotSCob).
                    END.

                    oJsonItemDuimp:ADD("dadosCambiais",oJsonDadoCamb).    

                    /* atributosDuimp */                    
                    RUN setConstraintItem IN h-bocx00482 (INPUT tt-duimp-item.cod-item) NO-ERROR.
                    RUN openQueryStatic IN h-bocx00482 (INPUT "Item":U) NO-ERROR.

                    EMPTY TEMP-TABLE tt-item-atrib-siscomex.

                    RUN getBatchRecords IN h-bocx00482 (INPUT ?,
                                                        INPUT NO,
                                                        INPUT 0,
                                                        OUTPUT iRowsReturned,
                                                        OUTPUT TABLE tt-item-atrib-siscomex).

                    IF CAN-FIND(FIRST tt-item-atrib-siscomex) THEN DO:
                        
                        ASSIGN oJsonAtribDuimp = NEW JsonObject().                        
                        ASSIGN oJsonAtributoArray = NEW JsonArray().
                    
                        FOR EACH tt-item-atrib-siscomex:
                            ASSIGN vl-multivalorado = fnMultivalorado(tt-item-atrib-siscomex.cod-class-fisc,
                                                                      tt-item-atrib-siscomex.cod-atrib,
                                                                      tt-item-atrib-siscomex.cod-domin,
                                                                      tt-item-atrib-siscomex.ind-modal).
                                                                  
                            ASSIGN vc-forma-preench = fnFormaPreench(tt-item-atrib-siscomex.cod-class-fisc,
                                                                     tt-item-atrib-siscomex.cod-atrib,
                                                                     tt-item-atrib-siscomex.cod-domin,
                                                                     tt-item-atrib-siscomex.ind-modal).

                            IF vl-multivalorado THEN DO:
                                IF vc-forma-preench = "Inteiro" THEN
                                    ASSIGN tt-item-atrib-siscomex.cod-livre-1 = STRING(tt-item-atrib-siscomex.num-livre-1).
                                ELSE
                                    IF vc-forma-preench = "Decimal" THEN
                                        ASSIGN tt-item-atrib-siscomex.cod-livre-1 = tt-item-atrib-siscomex.cod-livre-2.
                                    ELSE
                                        IF vc-forma-preench = "LΩgico" THEN
                                            ASSIGN tt-item-atrib-siscomex.cod-livre-1 = IF tt-item-atrib-siscomex.log-livre-1 THEN "Sim" ELSE "Nío".
                            END.
                            ELSE
                                ASSIGN tt-item-atrib-siscomex.cod-livre-1 = fnValorAtrib(tt-item-atrib-siscomex.cod-class-fisc,
                                                                                         tt-item-atrib-siscomex.cod-atrib,
                                                                                         tt-item-atrib-siscomex.cod-domin,
                                                                                         tt-item-atrib-siscomex.ind-modal,
                                                                                         vc-forma-preench).

                            ASSIGN oJsonAtributoAux = NEW JsonObject().
                            oJsonAtributoAux:add("codigo",tt-item-atrib-siscomex.cod-atrib).
                            oJsonAtributoAux:add("valor",tt-item-atrib-siscomex.cod-livre-1).

                            oJsonAtributoArray:ADD(oJsonAtributoAux).
                        END.
                        oJsonItemDuimp:ADD("atributosDuimp",oJsonAtributoArray).
                    END.

                    /* atributosFundamentoLegalDuimp */
                    //ASSIGN oJsonAtribFund = NEW JsonObject().                    
                    //oJsonItemDuimp:ADD("atributosFundamentoLegalDuimp",oJsonAtribFund).

                    /* tributos (CBS/IBS via TTCE - recolhimento integral) */
                    ASSIGN c-ttce-ncm      = ""
                           c-ttce-pais-num = ""
                           c-ttce-msg      = "".

                    RUN pi-ttce-obtem-ncm-pais (INPUT  tt-duimp-item.cod-item,
                                                INPUT  tt-duimp-item.cod-pais-iso-exporta,
                                                OUTPUT c-ttce-ncm,
                                                OUTPUT c-ttce-pais-num).

                    IF c-ttce-ncm <> "" THEN DO:
                        ASSIGN oJsonTribAplicArr = NEW JsonArray()
                               l-ttce-montou     = NO.

                        RUN pi-ttce-monta-tributos (INPUT  tt-duimp-item.cod-item,
                                                    INPUT  c-ttce-ncm,
                                                    INPUT  c-ttce-pais-num,
                                                    INPUT  oJsonTribAplicArr,
                                                    OUTPUT l-ttce-montou,
                                                    OUTPUT c-ttce-msg).

                        IF l-ttce-montou THEN
                            oJsonItemDuimp:ADD("tributos", oJsonTribAplicArr).
                        ELSE DO:
                            log-manager:WRITE-MESSAGE(">>> " + c-ttce-msg + " (item " + STRING(tt-duimp-item.seq-item) + ")") NO-ERROR.
                            CREATE tt-result.
                            ASSIGN tt-result.cod-registro = STRING(tt-duimp-siscomex.cod-duimp-dts)
                                   tt-result.des-msg      = c-ttce-msg
                                   tt-result.desc-status  = c-lb-com-erro.
                        END.
                    END.
                    ELSE DO:
                        ASSIGN c-ttce-msg = "TTCE: item " + STRING(tt-duimp-item.seq-item) + " sem NCM; bloco de tributos nao gerado.".
                        log-manager:WRITE-MESSAGE(">>> " + c-ttce-msg) NO-ERROR.
                        CREATE tt-result.
                        ASSIGN tt-result.cod-registro = STRING(tt-duimp-siscomex.cod-duimp-dts)
                               tt-result.des-msg      = c-ttce-msg
                               tt-result.desc-status  = c-lb-com-erro.
                    END.
                    /* localConsumo (UF pos 1-2 + IBGE pos 3-9 de cod-livre-1) */
                    IF tt-duimp-item.cod-livre-1 <> "":U THEN DO:
                        ASSIGN oJsonLocalConsumo = NEW JsonObject().
                        oJsonLocalConsumo:ADD("uf", SUBSTRING(tt-duimp-item.cod-livre-1,1,2)).
                        oJsonLocalConsumo:ADD("municipio", SUBSTRING(tt-duimp-item.cod-livre-1,3,7)).
                        oJsonItemDuimp:ADD("localConsumo", oJsonLocalConsumo).
                    END.

                    /* Separa o item por versao: 0 -> POST (cria); > 0 -> PUT (altera) */
                    ASSIGN i-versao-item = INT(tt-duimp-item.versao) NO-ERROR.
                    IF i-versao-item > 0 THEN DO:
                        oJsonArrayPut:ADD(oJsonItemDuimp).
                        CREATE tt-ctrl-item-put.
                        ASSIGN tt-ctrl-item-put.r-rowid = ROWID(tt-duimp-item).
                    END.
                    ELSE DO:
                        oJsonArrayPost:ADD(oJsonItemDuimp).
                        CREATE tt-ctrl-item-post.
                        ASSIGN tt-ctrl-item-post.r-rowid = ROWID(tt-duimp-item).
                    END.
                END.
                
                oJsonArrayPost:writefile(c-diretorio + REPLACE(c-nome-arquivo-json, ".json":U, "_POST.json":U), YES).
                oJsonArrayPut:writefile(c-diretorio + c-nome-arquivo-json-put, YES).
                
                RUN createResult IN THIS-PROCEDURE (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                    INPUT lSomenteJsonLocal).
            
                if not lSomenteJsonLocal then do:
                
                    IF tt-duimp-siscomex.cod-duimp-siscomex = "" THEN DO:
                        {utp/ut-liter.i "DUIMP_Siscomex" *}
                        ASSIGN c-lbl-erro[1] = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Para_ser_poss°vel_o_envio_dos_itens_da_DUIMP,_deve_ser_preenchido_o_campo_DUIMP_Siscomex" *}
                        RUN createRowErrors IN THIS-PROCEDURE(INPUT 57214,
                                                              INPUT c-lbl-erro[1] + "~~":U + RETURN-VALUE).
                    END.
                    ELSE DO:
                        /* endpoint itens DUIMP: /ext/duimp/{numero-duimp}/{versao-duimp}/itens
                           (usa sempre a versao da capa, nao do item) */
                        ASSIGN c-url-end-point = "/duimp-api/api/ext/duimp/" + tt-duimp-siscomex.cod-duimp-siscomex + "/" + STRING(tt-duimp-siscomex.num-versao-duimp) + "/itens".

                        /* ------- Lote POST: itens novos (duimp-item.versao = 0) ------- */
                        IF CAN-FIND(FIRST tt-ctrl-item-post) THEN DO:
                            ASSIGN cMetodo = "POST":U
                                   lcbody  = "".
                            fix-codepage(lcbody) = 'UTF-8'.
                            oJsonArrayPost:Write(lcbody,TRUE).
                            run piIntegraDUIMP(input lcbody,
                                               INPUT c-url-end-point,
                                               input cMetodo).

                            log-manager:WRITE-MESSAGE(">>> apos integrar itens (POST)") no-error.

                            FIND FIRST ttReturnHttpRequest NO-ERROR.
                            IF AVAIL ttReturnHttpRequest
                                 and ttReturnHttpRequest.numero <> "" THEN DO:
                                /* POST: so grava versao = 1 nos itens confirmados sem erro no multiStatus */
                                FOR EACH tt-ctrl-item-post:
                                    FIND FIRST tt-duimp-item
                                        WHERE ROWID(tt-duimp-item) = tt-ctrl-item-post.r-rowid NO-ERROR.
                                    IF NOT AVAIL tt-duimp-item THEN NEXT.

                                    /* Status individual retornado pelo portal para este item */
                                    FIND FIRST ttReturnItemStatus
                                        WHERE ttReturnItemStatus.numeroItem = tt-duimp-item.seq-item NO-ERROR.

                                    /* Item com erro no multiStatus -> NAO grava versao, registra na planilha */
                                    IF AVAIL ttReturnItemStatus AND ttReturnItemStatus.comErro THEN DO:
                                        CREATE tt-result.
                                        ASSIGN tt-result.cod-registro = STRING(tt-duimp-item.seq-item)
                                               tt-result.des-msg      = ttReturnItemStatus.mensagem
                                               tt-result.desc-status  = c-lb-com-erro.
                                        NEXT.
                                    END.

                                    /* Sem confirmacao de sucesso (item ausente no multiStatus) -> NAO grava versao */
                                    IF NOT AVAIL ttReturnItemStatus THEN NEXT.

                                    ASSIGN tt-duimp-item.versao = 1.
                                    /* Posiciona a query do BO no item antes de atualizar */
                                    RUN goToKey IN h-bocx00488 (INPUT tt-duimp-item.cod-duimp-dts,
                                                                INPUT tt-duimp-item.cod-item,
                                                                INPUT tt-duimp-item.seq-item).
                                    IF RETURN-VALUE = "OK":U THEN DO:
                                        RUN setRecord    IN h-bocx00488 (INPUT TABLE tt-duimp-item).
                                        RUN updateRecord IN h-bocx00488.
                                    END.
                                END.
                            END.
                            ELSE DO:
                                /* Cria registro do campo message para exibir na planilha */
                                FOR EACH ttReturnHttpRequest WHERE ttReturnHttpRequest.mensagem <> "" :
                                    CREATE tt-result.
                                    ASSIGN tt-result.des-msg     = ttReturnHttpRequest.mensagem
                                           tt-result.desc-status = c-lb-desc-integr.
                                END.
                            END.
                        END.

                        /* ------- Lote PUT: itens ja enviados (duimp-item.versao > 0) ------- */
                        IF CAN-FIND(FIRST tt-ctrl-item-put) THEN DO:
                            ASSIGN cMetodo = "PUT":U
                                   lcbody  = "".
                            fix-codepage(lcbody) = 'UTF-8'.
                            oJsonArrayPut:Write(lcbody,TRUE).
                            run piIntegraDUIMP(input lcbody,
                                               INPUT c-url-end-point,
                                               input cMetodo).

                            log-manager:WRITE-MESSAGE(">>> apos integrar itens (PUT)") no-error.

                            FIND FIRST ttReturnHttpRequest NO-ERROR.
                            IF AVAIL ttReturnHttpRequest
                                 and ttReturnHttpRequest.numero <> "" THEN DO:
                                /* PUT: versao do response; se 0, mantem 1 */
                                ASSIGN i-num-versao = INT(ttReturnHttpRequest.versao) NO-ERROR.
                                IF ERROR-STATUS:ERROR OR i-num-versao = 0 THEN
                                    ASSIGN i-num-versao = 1.

                                log-manager:write-message(">>> versao item (PUT): " + string(i-num-versao)) no-error.

                                /* PUT: so grava versao nos itens confirmados sem erro no multiStatus */
                                FOR EACH tt-ctrl-item-put:
                                    FIND FIRST tt-duimp-item
                                        WHERE ROWID(tt-duimp-item) = tt-ctrl-item-put.r-rowid NO-ERROR.
                                    IF NOT AVAIL tt-duimp-item THEN NEXT.

                                    /* Status individual retornado pelo portal para este item */
                                    FIND FIRST ttReturnItemStatus
                                        WHERE ttReturnItemStatus.numeroItem = tt-duimp-item.seq-item NO-ERROR.

                                    /* Item com erro no multiStatus -> NAO grava versao, registra na planilha */
                                    IF AVAIL ttReturnItemStatus AND ttReturnItemStatus.comErro THEN DO:
                                        CREATE tt-result.
                                        ASSIGN tt-result.cod-registro = STRING(tt-duimp-item.seq-item)
                                               tt-result.des-msg      = ttReturnItemStatus.mensagem
                                               tt-result.desc-status  = c-lb-com-erro.
                                        NEXT.
                                    END.

                                    /* Sem confirmacao de sucesso (item ausente no multiStatus) -> NAO grava versao */
                                    IF NOT AVAIL ttReturnItemStatus THEN NEXT.

                                    ASSIGN tt-duimp-item.versao = i-num-versao.
                                    /* Posiciona a query do BO no item antes de atualizar */
                                    RUN goToKey IN h-bocx00488 (INPUT tt-duimp-item.cod-duimp-dts,
                                                                INPUT tt-duimp-item.cod-item,
                                                                INPUT tt-duimp-item.seq-item).
                                    IF RETURN-VALUE = "OK":U THEN DO:
                                        RUN setRecord    IN h-bocx00488 (INPUT TABLE tt-duimp-item).
                                        RUN updateRecord IN h-bocx00488.
                                    END.
                                END.
                            END.
                            ELSE DO:
                                /* Cria registro do campo message para exibir na planilha */
                                FOR EACH ttReturnHttpRequest WHERE ttReturnHttpRequest.mensagem <> "" :
                                    CREATE tt-result.
                                    ASSIGN tt-result.des-msg     = ttReturnHttpRequest.mensagem
                                           tt-result.desc-status = c-lb-desc-integr.
                                END.
                            END.
                        END.                   
                        
                    END.
                end.
            END.
            ELSE DO:
                {utp/ut-liter.i "exportar_as_informaá‰es_dos_itens_da_DUIMP" *}
                ASSIGN c-lbl-erro[1] = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "gerar_o_arquivo_de_Json_dos_itens,_declaraá∆o_n∆o_possui_itens_vinculado" *}
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 30639,
                                                      INPUT c-lbl-erro[1] + "~~":U + RETURN-VALUE).
            END.
        END.
        ELSE DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 30639,
                                                  INPUT c-lb-erro-export-info).
        END.
        RUN geraArquivoResultado (INPUT c-titulo,
                                  INPUT c-nome-planilha,
                                  INPUT c-nome-arquivo,
                                  INPUT IF l-geracao-valida AND c-diretorio <> "":U THEN c-diretorio ELSE SESSION:TEMP-DIRECTORY,
                                  OUTPUT c-arquivo-resultado).
    END.
                              

    IF VALID-HANDLE(h-bocx00487) THEN DO:
        DELETE PROCEDURE h-bocx00487.
        ASSIGN h-bocx00487 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.

    IF VALID-HANDLE(h-bocx00489) THEN DO:
        DELETE PROCEDURE h-bocx00489.
        ASSIGN h-bocx00489 = ?.
    END.

    IF  VALID-HANDLE(h-bocx00482) then do:
        DELETE PROCEDURE h-bocx00482.
        ASSIGN h-bocx00482 = ?.
    END.

    IF  VALID-HANDLE(h-boin01092) then do:
        DELETE PROCEDURE h-boin01092.
        ASSIGN h-boin01092 = ?.
    END.
    
    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

procedure piIntegraDUIMP:
    DEFINE INPUT PARAMETER pc-lcbody             AS longchar             NO-UNDO.
    DEFINE INPUT PARAMETER pc-end-point          AS CHARACTER            NO-UNDO.
    define input parameter pc-method             as character            no-undo.
    
    DEFINE variable oResponseJson              AS JsonObject              NO-UNDO.
    
    EMPTY TEMP-TABLE RowErrorsAux NO-ERROR.
    ASSIGN lcResponse = "".
    FIX-CODEPAGE (lcResponse) = 'UTF-8'. 
    
    IF NOT VALID-HANDLE(h-imapi019) THEN 
        RUN imp/imapi019.p PERSISTENT SET h-imapi019.
        
    RUN executeSending IN h-imapi019 (INPUT pc-lcbody,
                                      INPUT pc-end-point,
                                      INPUT pc-method,
                                      OUTPUT lHistEnvio,
                                      OUTPUT cDirFileJson,
                                      OUTPUT TABLE RowErrorsAux,
                                      OUTPUT lcResponse).
                                                                            
    RUN getReturnHttpRequest IN h-imapi019(OUTPUT TABLE ttReturnHttpRequest).
    RUN getReturnItemStatus  IN h-imapi019(OUTPUT TABLE ttReturnItemStatus).
    find first ttReturnHttpRequest no-lock no-error.
    if avail ttReturnHttpRequest THEN DO:
        oResponseJson = JsonAPIUtils:convertTempTableToJsonObject(TEMP-TABLE ttReturnHttpRequest:HANDLE, NO).                                                               
    END.
    FOR EACH RowErrorsAux:
        CREATE tt-result.
        ASSIGN tt-result.cod-registro = string(d-cod-duimp-dts)
               tt-result.cod-msg      = STRING(RowErrorsAux.ErrorNumber)    
               tt-result.des-msg      = RowErrorsAux.ErrorDescription       
               tt-result.desc-status  = c-lb-com-erro.                    
    END.
                        
    IF VALID-HANDLE(h-imapi019) THEN DO:
        DELETE PROCEDURE h-imapi019.
        ASSIGN h-imapi019 = ?.
    END.
    
end procedure.

PROCEDURE piIntegraTTCE:
/*:T------------------------------------------------------------------------------
  Purpose:     Executa GET na API TTCE (mesma autenticacao/certificado do Siscomex)
  Parameters:  INPUT pc-end-point : path do endpoint TTCE
               INPUT pc-method    : metodo HTTP (GET)
               OUTPUT plcResult   : corpo da resposta (JSON)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-body      AS LONGCHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-end-point AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-method    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER plcResult    AS LONGCHAR  NO-UNDO.

    EMPTY TEMP-TABLE RowErrorsAux NO-ERROR.
    ASSIGN plcResult = "".
    FIX-CODEPAGE (plcResult) = 'UTF-8'.

    IF NOT VALID-HANDLE(h-imapi019) THEN
        RUN imp/imapi019.p PERSISTENT SET h-imapi019.

    RUN executeSending IN h-imapi019 (INPUT  pc-body,
                                      INPUT  pc-end-point,
                                      INPUT  pc-method,
                                      OUTPUT lHistEnvio,
                                      OUTPUT cDirFileJson,
                                      OUTPUT TABLE RowErrorsAux,
                                      OUTPUT plcResult).
END PROCEDURE.

PROCEDURE geraArquivoResultado:
/*:T------------------------------------------------------------------------------
  Purpose:     Gera o arquivo com o resultado da integraªío
  Parameters:  INPUT pc-titulo: T≠tulo do cabeªalho 
               INPUT pc-nome-planilha: Nome da planilha
               INPUT pc-nome-arquivo: Nome do arquivo
               INPUT pc-diretorio: DiretΩrio onde deverò ser criado o arquivo;
               OUTPUT pc-caminho-arquivo: Caminho completo do arquivo gerado.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-titulo          AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-planilha   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-arquivo    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-diretorio       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-caminho-arquivo AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-arquivo-xml  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-cod-emit AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Cod_DUIMP_DTS" *}
    ASSIGN c-lbl-cod-emit = RETURN-VALUE.
    
    if  substring(pc-diretorio, length(pc-diretorio), 1) <> "/":U 
    and substring(pc-diretorio, length(pc-diretorio), 1) <> "\":U THEN DO:
        if opsys = "WIN32":U then 
            ASSIGN pc-diretorio = pc-diretorio + "\":U.
        else
            ASSIGN pc-diretorio = pc-diretorio + "/":U.
    END.

    ASSIGN c-arquivo-xml = pc-diretorio 
                         + pc-nome-arquivo 
                         + replace(string(today,"99/99/99"), "/","-") 
                         + "_":U
                         + replace(string(time,"hh:mm:ss"), ":","-") 
                         + ".xml":U.

    IF CAN-FIND(FIRST tt-result) THEN DO:       
        IF NOT VALID-HANDLE(h-utapi033) THEN 
            RUN utp/utapi033.p PERSISTENT SET h-utapi033.

        RUN piColumn IN h-utapi033 (INPUT 1, INPUT "CHAR":U, INPUT c-lbl-cod-emit, INPUT ">>>>>>>>":U, 90).
        RUN piColumn IN h-utapi033 (INPUT 2, INPUT "CHAR":U, INPUT c-lb-situacao,  INPUT "":U,         110).
        RUN piColumn IN h-utapi033 (INPUT 3, INPUT "CHAR":U, INPUT c-lb-cod-erro,  INPUT ">>>>>>9":U,  60).
        RUN piColumn IN h-utapi033 (INPUT 4, INPUT "CHAR":U, INPUT c-lb-desc-erro, INPUT "":U,         900).
        RUN piColumn IN h-utapi033 (INPUT 5, INPUT "CHAR":U, INPUT c-lb-ret-sisco, INPUT "":U,         600).
        
        FOR EACH tt-result:
            /*Impressío de erros/situaªío da geraªío/integraªío para o XML */
            RUN piNewLine IN h-utapi033.
            RUN piLine IN h-utapi033 (1, tt-result.cod-registro).
            RUN piLine IN h-utapi033 (2, tt-result.desc-status).
            RUN piLine IN h-utapi033 (3, tt-result.cod-msg).
            RUN piLine IN h-utapi033 (4, tt-result.des-msg).
            RUN piLine IN h-utapi033 (5, lcResponse).
        END.

        RUN ConvertToXls IN h-utapi033 (INPUT NO).
            
        {utp/ut-liter.i "Relat¢rio_de_Status_de_Integraá∆o_da_DUIMP" *}
        RUN piProcessa IN  h-utapi033 (INPUT-OUTPUT c-arquivo-xml,
                                       INPUT pc-nome-planilha,
                                       INPUT pc-titulo).
    
        DELETE PROCEDURE h-utapi033.
        ASSIGN h-utapi033 = ?.
    END.
    ELSE DO:
        {utp/ut-liter.i "informaá‰es_na_tabela_de_resultados"}
        RUN createRowErrors IN THIS-PROCEDURE( INPUT 30594,
                                               INPUT RETURN-VALUE).

        
        RETURN "NOK":U.
    END.

    ASSIGN pc-caminho-arquivo = c-arquivo-xml.
    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE createResult:
/*:T------------------------------------------------------------------------------
  Purpose:     Cria registro na TT de resultados.
  Parameters:  INPUT c-cod-registro (characer): C¢digo do fornecedor ou em branco
                                                para erros gerais
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-cod-duimp-dts AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-lSomenteJsonLocal AS LOGICAL NO-UNDO.
    
    DEFINE BUFFER bfRowErrors FOR RowErrors.
    /* Retorna NOK caso exista algum erro na RowErrors com o tipo "Error" */
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK:
            CREATE tt-result.
            ASSIGN tt-result.cod-registro = c-cod-duimp-dts
                   tt-result.cod-msg      = STRING(RowErrors.ErrorNumber)
                   tt-result.des-msg      = RowErrors.ErrorDescription.

            IF CAN-FIND(FIRST bfRowErrors WHERE bfRowErrors.ErrorSubType = "ERROR":U) THEN DO:
                ASSIGN tt-result.desc-status = c-lb-com-erro.
            END.
            ELSE DO:
                ASSIGN tt-result.desc-status = IF p-lSomenteJsonLocal THEN c-lb-arq-gerado ELSE c-lb-return-integrado.
            END.
        END.
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        CREATE tt-result.
        ASSIGN tt-result.cod-registro = c-cod-duimp-dts
               tt-result.desc-status  = IF p-lSomenteJsonLocal THEN c-lb-arq-gerado ELSE c-lb-integrado.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createRowErrors:
/*:T------------------------------------------------------------------------------
  Purpose:     Criar registro de erro na temp-table RowErrors
  Parameters:  INPUT pErrorNumber (integer): c¢digo do erro
               INPUT pParameters (character): parÉmetros da mensagem de erro.
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pParameters  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE vErrorSequence AS INTEGER NO-UNDO.

    ASSIGN vErrorSequence = 1.
    FIND LAST RowErrors NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        ASSIGN vErrorSequence = RowErrors.ErrorSequence + 1.
    END.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = vErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorParameters  = pParameters
           RowErrors.ErrorType        = "EMS":U.
     
    RUN utp/ut-msgs.p (INPUT "CodType":U, INPUT pErrorNumber, INPUT "":U).
    CASE INT(RETURN-VALUE):
        WHEN 1 THEN ASSIGN  RowErrors.ErrorSubType = "ERROR":U.
        WHEN 2 THEN ASSIGN  RowErrors.ErrorSubType = "WARNING":U.
        WHEN 3 THEN ASSIGN  RowErrors.ErrorSubType = "QUESTION":U.
        WHEN 4 THEN ASSIGN  RowErrors.ErrorSubType = "INFORMATION":U.
    END CASE.

    RUN utp/ut-msgs.p (INPUT "Msg":U, INPUT pErrorNumber, INPUT pParameters).
    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "Help":U, INPUT pErrorNumber,INPUT pParameters).
    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    IF TRIM(RowErrors.ErrorDescription) <> TRIM(RowErrors.ErrorHelp) THEN DO:
        ASSIGN RowErrors.ErrorDescription = RowErrors.ErrorDescription. 
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-retornaMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    DEFINE INPUT PARAMETER p-cdn-moeda LIKE moeda.mo-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER p-sigla-moeda LIKE moeda.sigla NO-UNDO.

    RUN findCodigo IN h-boun005 (p-cdn-moeda, OUTPUT c-return).
    FIND FIRST moeda WHERE moeda.mo-codigo = p-cdn-moeda NO-LOCK NO-ERROR.
    IF AVAIL moeda THEN ASSIGN c-return = substr(moeda.char-2,43,3).
    IF  c-return = "" THEN DO:
        RUN getCharField in h-boun005 (input "sigla":U, output p-sigla-moeda).
    END.
    ELSE
        ASSIGN p-sigla-moeda = c-return.

END PROCEDURE.


FUNCTION fnMultivalorado RETURNS LOGICAL
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-multivalorado LIKE classif-atrib.log-multivalorado NO-UNDO.
    
    IF  AVAIL tt-item-atrib-siscomex THEN DO:
        RUN setConstraintClassFisc IN h-boin01092 (INPUT tt-item-atrib-siscomex.cod-class-fisc).
        RUN openQueryStatic        IN h-boin01092 (INPUT 'ClassFisc':U).
        
        RUN goToKey IN h-boin01092 (INPUT pClassFisc,
                                    INPUT pCodAtrib,
                                    INPUT pCodDomin,
                                    INPUT pIndModal).
        IF RETURN-VALUE = "OK":U THEN
            RUN getLogField IN h-boin01092 (INPUT 'log-multivalorado',
                                             OUTPUT p-multivalorado).
        ELSE
            ASSIGN p-multivalorado = NO.
    END.
    
    RETURN p-multivalorado.   /* Function return value. */

END FUNCTION.

FUNCTION fnValorAtrib RETURNS CHARACTER
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER,
    pTipoValor   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE p-valor-atrib AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE v-int         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-dec         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-log         AS LOGICAL     NO-UNDO.
           
    IF  AVAIL tt-item-atrib-siscomex THEN DO:    
        RUN setConstraintClassFisc IN h-boin01092 (INPUT tt-item-atrib-siscomex.cod-class-fisc).
        RUN openQueryStatic        IN h-boin01092 (INPUT 'ClassFisc':U).
        
        RUN goToKey IN h-boin01092 (INPUT pClassFisc,
                                    INPUT pCodAtrib,
                                    INPUT pCodDomin,
                                    INPUT pIndModal).
        IF RETURN-VALUE = "OK":U THEN DO:
            IF pTipoValor = "Inteiro" THEN DO:
                    RUN getIntField IN h-boin01092 (INPUT 'num-valor',
                                                    OUTPUT v-int).
                    ASSIGN p-valor-atrib = STRING(v-int).
            END.
            ELSE
                IF pTipoValor = "Decimal" THEN DO:
                    RUN getDecField IN h-boin01092 (INPUT 'val-valor',
                                                    OUTPUT v-dec).
                    ASSIGN p-valor-atrib = STRING(v-dec).
                END.
                ELSE
                    IF pTipoValor = "LΩgico" THEN DO:
                        RUN getLogField IN h-boin01092 (INPUT 'log-valor',
                                                        OUTPUT v-log).
                        ASSIGN p-valor-atrib = STRING(v-log).
                    END.
                    ELSE
                        IF pTipoValor = "Texto" THEN
                            RUN getCharField IN h-boin01092 (INPUT 'cod-valor',
                                                             OUTPUT p-valor-atrib).
                            
        END.       
    END.    

    RETURN p-valor-atrib.   /* Function return value. */

END FUNCTION.

FUNCTION fnFormaPreench RETURNS CHARACTER
  ( pClassFisc   AS CHARACTER,
    pCodAtrib    AS CHARACTER,
    pCodDomin    AS CHARACTER,
    pIndModal    AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-forma-preench AS INTEGER     NO-UNDO.
    DEFINE VARIABLE p-descricao     AS CHARACTER   NO-UNDO EXTENT 6
        INITIAL ["Lista Estˇtica","Inteiro","Decimal","Texto","LΩgico", "Nío Especificado"].    

    IF  AVAIL tt-item-atrib-siscomex THEN DO:
        RUN setConstraintClassFisc IN h-boin01092 (INPUT tt-item-atrib-siscomex.cod-class-fisc).
        RUN openQueryStatic        IN h-boin01092 (INPUT 'ClassFisc':U).
        
        RUN goToKey IN h-boin01092 (INPUT pClassFisc,
                                    INPUT pCodAtrib,
                                    INPUT pCodDomin,
                                    INPUT pIndModal).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getIntField IN h-boin01092 (INPUT 'idi-forma-preench',
                                            OUTPUT p-forma-preench).
        END.
        ELSE
            ASSIGN p-forma-preench = 0.
            
        IF p-forma-preench > 5 OR
           p-forma-preench < 1 THEN
           ASSIGN p-forma-preench = 6.
    END.
         
    RETURN p-descricao[p-forma-preench].   /* Function return value. */

END FUNCTION.





