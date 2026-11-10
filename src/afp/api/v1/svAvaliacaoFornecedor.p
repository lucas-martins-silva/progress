/*---------------------------------------------------
@api: svAvaliacaoFornecedor
@visibility: internal
@summary: <RESUMO-OBJETIVO>
@description: <DESCRIÇÃO-OBJETIVO>
---------------------------------------------------*/

{utp/ut-api.i}
{utp/ut-api-utils.i}
{include/i-prgvrs.i svAvaliacaoFornecedor 1.00.00.002 } /*** "010002" 24/08/2026 14:25:45  ***/

/*******************************************************************************
** Copyright TOTVS S.A. (2024)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so" podera ser feita mediante
** autorizacao expressa.
**                                           
** API...............: svAvaliacaoFornecedor.p
** Objetivo..........: Objeto de negocio baseado na tela AF0601
** API de Comunicacao: 
** Data de Criacao...: 10/12/2024
** Autor.............: Joao Arthur Manso
** Metodos...........: GET | POST 
**
*******************************************************************************/



//tamanho da pagina default 5000
&GLOBAL-DEFINE SV-PAGE-SIZE 1000
//conversao de referencia de campo de tabela para envio para o Smart View, modos possiveis DBTBATR TBATR ATR Default TBATR
// &GLOBAL-DEFINE SV-MODO ATR
//Separador de nome de atributo default _ e ? para sem separador 
//&GLOBAL-DEFINE SV-SEP _
//Inicial do nome da procedure de campo calculado Default calc
//&GLOBAL-DEFINE SV-PRNAME calc 

{utp/ut-sv-utils.i}

{utp/ut-api-action.i pLookUpPeriodoIni GET /lookupperiodoini/~* } 
{utp/ut-api-action.i pLookUpPeriodoFim GET /lookupperiodofim/~* } 


{utp/ut-api-action.i pObjects GET /objectschema/~*} //responsavel por retornar o schema
{utp/ut-api-action.i pData POST /data/~*} //responsavel por retornar os dados           

{utp/ut-api-notfound.i}

//cria tt-notas
{afp/api/v1/svAvaliacaoFornecedor.i1}


//variaveis de parametro
DEFINE VARIABLE periodoInicial           LIKE af-periodo-aval.dt-periodo-ini[1] NO-UNDO.
DEFINE VARIABLE periodoFinal             LIKE af-periodo-aval.dt-periodo-fim[1] NO-UNDO.
DEFINE VARIABLE codigoEstabelecimentoIni AS INT INIT 1 NO-UNDO.
DEFINE VARIABLE codigoEstabelecimentoFim AS INT INIT 1 NO-UNDO.
DEFINE VARIABLE codigoFornecedorIni      LIKE af-contr-indice.cod-emitente INIT 0 NO-UNDO.
DEFINE VARIABLE codigoFornecedorFim      LIKE af-contr-indice.cod-emitente INIT 999999999 NO-UNDO.
DEFINE VARIABLE itemInicial              LIKE af-contr-indice.it-codigo INIT "" NO-UNDO.
DEFINE VARIABLE itemFinal                LIKE af-contr-indice.it-codigo INIT "ZZZZZZZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE numeroControleIni        LIKE af-contr-indice.nr-controle INIT 0 NO-UNDO.
DEFINE VARIABLE numeroControleFim        LIKE af-contr-indice.nr-controle INIT 999999 NO-UNDO.
DEFINE VARIABLE grupoAvaliacaoIni        LIKE af-grp-avaliacao-form.cod-grp-avaliacao INIT "" NO-UNDO.
DEFINE VARIABLE grupoAvaliacaoFim        LIKE af-grp-avaliacao-form.cod-grp-avaliacao INIT "ZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE grupoResponsavelIni      LIKE af-item-contr-estab-form.cod-grp-resp INIT "" NO-UNDO.
DEFINE VARIABLE grupoResponsavelFim      LIKE af-item-contr-estab-form.cod-grp-resp INIT "ZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE grupoFornecedorIni       LIKE emitente.cod-gr-forn INIT 0  NO-UNDO.
DEFINE VARIABLE grupoFornecedorFim       LIKE emitente.cod-gr-forn INIT 99 NO-UNDO.
DEFINE VARIABLE codigoFamilia            LIKE item.fm-codigo INIT "" NO-UNDO.    //inicial
DEFINE VARIABLE grupoEstoque             LIKE item.ge-codigo INIT 0 NO-UNDO.     //inicial

//auxiliar
DEFINE VARIABLE ano-ini AS INT NO-UNDO.  
DEFINE VARIABLE ano-fim AS INT NO-UNDO.
DEFINE VARIABLE mes-ini AS CHAR NO-UNDO.  
DEFINE VARIABLE mes-fim AS CHAR NO-UNDO.                                     



//retorna o schema
PROCEDURE pObjects:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.
    DEFINE VARIABLE oResponse           AS JsonAPIResponse NO-UNDO.  
    DEFINE VARIABLE hTable              AS HANDLE          NO-UNDO.  
    DEFINE VARIABLE prop                AS jsonObject      NO-UNDO.
    DEFINE VARIABLE i                   AS INTEGER         NO-UNDO.
     
     DO ON ERROR UNDO, LEAVE:        
      
        RUN generateProperties("svAvaliacaoFornecedor",
                               "Avalia‡Æo Fornecedor", 
                               "Objeto de negocio", 
                               "api/afp/v1/svAvaliacaoFornecedor",  
                               OUTPUT prop ). 
        
        CATCH eSysError AS Progress.Lang.sysError:    
            DO i = 1 TO eSysError:NumMessages:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber = eSysError:GetMessageNum(i)
                       RowErrors.ErrorSubType = "error"
                       RowErrors.ErrorDescription = eSysError:GetMessage(i)
                       RowErrors.ErrorHelp  = eSysError:GetMessage(i).
            END.               
        END CATCH.                  
        FINALLY:
            RUN createJsonResponse(INPUT prop, INPUT TABLE RowErrors, INPUT FALSE, OUTPUT oJsonOutput).        
        END.         
    END.
         
         
END PROCEDURE. 

// restorna os dados
PROCEDURE pData:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.
    DEFINE VARIABLE oResponse           AS JsonAPIResponse NO-UNDO.  
    
    DEFINE VARIABLE hTable     AS HANDLE          NO-UNDO.
    DEFINE VARIABLE prop       AS jsonObject      NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER         NO-UNDO.
    DEFINE VARIABLE cUri       AS CHARACTER       NO-UNDO. 
    DEFINE VARIABLE cFilter    AS CHARACTER       NO-UNDO.    
    DEFINE VARIABLE cParam     AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE oJsonParam AS jsonObject      NO-UNDO.

    DEFINE VARIABLE h-boaf008  AS HANDLE          NO-UNDO.

    IF NOT VALID-HANDLE(h-boaf008) THEN DO:
        run afbo/boaf008.p persistent set h-boaf008.
    END.
    
    RUN readParameters(oJsonInput, OUTPUT cParam).
    
    DO ON ERROR UNDO, LEAVE:
        
        run getNotas in h-boaf008 (INPUT codigoEstabelecimentoIni,     //c-cod-estabel-ini
                                   INPUT codigoEstabelecimentoFim,     //c-cod-estabel-fim
                                   INPUT codigoFornecedorIni, //i-cod-emitente-ini, 
                                   INPUT codigoFornecedorFim, //i-cod-emitente-fim,
                                   INPUT itemInicial, //c-it-codigo-ini,  
                                   INPUT itemFinal, //c-it-codigo-fim,
                                   INPUT numeroControleIni, //i-nr-controle-ini,
                                   INPUT numeroControleFim, //i-nr-controle-fim, 
                                   INPUT ano-ini, //cb-ano-ini apenas o ano,  
                                   INPUT mes-ini, //cb-periodo-ini,
                                   INPUT ano-fim, //cb-ano-fim apenas o ano,  
                                   INPUT mes-fim, //cb-periodo-fim, 
                                   INPUT grupoAvaliacaoIni, //c-cod-grp-aval-ini,
                                   INPUT grupoAvaliacaoFim, //c-cod-grp-aval-fim,
                                   INPUT grupoResponsavelIni, //c-cod-grp-resp-ini,
                                   INPUT grupoResponsavelFim, //c-cod-grp-resp-fim,
                                   INPUT grupoFornecedorIni, //i-cod-gr-forn-ini, 
                                   INPUT grupoFornecedorFim, //i-cod-gr-forn-fim,
                                   INPUT codigoFamilia, //c-fm-codigo-ini,
                                   INPUT "ZZZZZZ", //c-fm-codigo-fim,
                                   INPUT grupoEstoque, //i-ge-codigo-ini, 
                                   INPUT 99, //i-ge-codigo-fim,
                                   INPUT 1, //i-filtro,
                                   INPUT 999999, //i-melhor-pior,
                                   INPUT 1, //i-media,
                                   OUTPUT table tt-notas).
                                   
        
        ASSIGN cURI   = ojsonInput:GetCharacter("uri").
               hTable =  BUFFER tt-notas:HANDLE.
        RUN generateData(hTable, cURI, "", OUTPUT prop ).

        CATCH eSysError AS Progress.Lang.sysError:    
            DO i = 1 TO eSysError:NumMessages:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber = eSysError:GetMessageNum(i)
                       RowErrors.ErrorSubType = 'error'
                       RowErrors.ErrorDescription = eSysError:GetMessage(i).   
                       RowErrors.ErrorHelp  = eSysError:GetMessage(i).
            END.               
        END CATCH.                   
        FINALLY:
            RUN createJsonResponse(INPUT prop, INPUT TABLE RowErrors, INPUT FALSE, OUTPUT oJsonOutput).       
        END.
        
        
    END.
    IF VALID-HANDLE(h-boaf008) THEN RUN destroy IN h-boaf008.
END PROCEDURE.

PROCEDURE generateSchema:

    DEF VAR hTable   AS HANDLE NO-UNDO.
    DEF VAR mySchema AS schemaItem NO-UNDO.
    DEF VAR myParam  AS schemaParameter NO-UNDO.
    
    RUN clearSchema.
    
    {afp/api/v1/svAvaliacaoFornecedor.i}
    RUN addSchemaTable(INPUT BUFFER tt-notas:HANDLE).
    
    FINALLY:
        IF VALID-OBJECT(mySchema) THEN
        DO:
           DELETE OBJECT mySchema NO-ERROR.
        END.
    END FINALLY.
    
END PROCEDURE.

PROCEDURE readParameters: 
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER cParam      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilter             AS CHARACTER  NO-UNDO.  

    DEFINE VARIABLE oJsonParam          AS JsonArray  NO-UNDO.
    DEFINE VARIABLE mesAuxIni           AS INT        NO-UNDO.
    DEFINE VARIABLE mesAuxFim           AS INT        NO-UNDO.    
       
    
    RUN processParameters(oJsonInput, "&periodoInicial",           OUTPUT periodoInicial) .
    RUN processParameters(oJsonInput, "&periodoFinal",             OUTPUT periodoFinal) .
    RUN processParameters(oJsonInput, "&codigoEstabelecimentoIni", OUTPUT codigoEstabelecimentoIni) .
    RUN processParameters(oJsonInput, "&codigoEstabelecimentoFim", OUTPUT codigoEstabelecimentoFim) .
    RUN processParameters(oJsonInput, "&codigoFornecedorIni",      OUTPUT codigoFornecedorIni) .
    RUN processParameters(oJsonInput, "&codigoFornecedorFim",      OUTPUT codigoFornecedorFim) .
    RUN processParameters(oJsonInput, "&itemInicial",              OUTPUT itemInicial) .
    RUN processParameters(oJsonInput, "&itemFinal",                OUTPUT itemFinal) .
    RUN processParameters(oJsonInput, "&numeroControleIni",        OUTPUT numeroControleIni) .
    RUN processParameters(oJsonInput, "&numeroControleFim",        OUTPUT numeroControleFim) .
    RUN processParameters(oJsonInput, "&grupoAvaliacaoIni",        OUTPUT grupoAvaliacaoIni) .
    RUN processParameters(oJsonInput, "&grupoAvaliacaoFim",        OUTPUT grupoAvaliacaoFim) .
    RUN processParameters(oJsonInput, "&grupoResponsavelIni",      OUTPUT grupoResponsavelIni) .
    RUN processParameters(oJsonInput, "&grupoResponsavelFim",      OUTPUT grupoResponsavelFim) .
    RUN processParameters(oJsonInput, "&grupoFornecedorIni",       OUTPUT grupoFornecedorIni) .
    RUN processParameters(oJsonInput, "&grupoFornecedorFim",       OUTPUT grupoFornecedorFim) .
    RUN processParameters(oJsonInput, "&codigoFamilia",            OUTPUT codigoFamilia) .
    RUN processParameters(oJsonInput, "&grupoEstoque",             OUTPUT grupoEstoque) .
    
    IF codigoEstabelecimentoIni = 0    THEN ASSIGN codigoEstabelecimentoIni = 1.
    IF codigoEstabelecimentoFim = 0    THEN ASSIGN codigoEstabelecimentoFim = 1.
    IF codigoFornecedorIni      = 0    THEN ASSIGN codigoFornecedorIni = 0.
    IF codigoFornecedorFim      = 0    THEN ASSIGN codigoFornecedorFim = 999999.
    IF itemInicial              = '""' THEN ASSIGN itemInicial = "".
    IF itemFinal                = '""' THEN ASSIGN itemFinal = "ZZZZZZZZZZZZZZZZ".
    IF numeroControleIni        = 0    THEN ASSIGN numeroControleIni = 0.
    IF numeroControleFim        = 0    THEN ASSIGN numeroControleFim = 999999.
    IF grupoAvaliacaoIni        = '""' THEN ASSIGN grupoAvaliacaoIni = "".
    IF grupoAvaliacaoFim        = '""' THEN ASSIGN grupoAvaliacaoFim = "ZZZZZZZZ".
    IF grupoResponsavelIni      = '""' THEN ASSIGN grupoResponsavelIni = "".
    IF grupoResponsavelFim      = '""' THEN ASSIGN grupoResponsavelFim = "ZZZZZZZZ".
    IF grupoFornecedorIni       = 0    THEN ASSIGN grupoFornecedorIni = 0.
    IF grupoFornecedorFim       = 0    THEN ASSIGN grupoFornecedorFim = 99.
    IF codigoFamilia            = '""' THEN ASSIGN codigoFamilia = "".
    IF grupoEstoque             = 0    THEN ASSIGN grupoEstoque = 0.

    
    ASSIGN ano-ini = INT(YEAR(TODAY))
           ano-fim = INT(YEAR(TODAY))
           mes-ini = "Janeiro"
           mes-fim = "Dezembro"
           mesAuxIni = MONTH(periodoInicial)
           mesAuxFim = MONTH(periodoFinal).
    
    IF periodoInicial <> ? THEN
    DO:
        ASSIGN ano-ini = INT(YEAR(periodoInicial)).
        CASE mesAuxIni:
            WHEN 1  THEN 
            DO:
                {utp/ut-liter.i "Janeiro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 2  THEN 
            DO:
                {utp/ut-liter.i "Fevereiro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 3  THEN 
            DO:
                {utp/ut-liter.i "Marco" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 4  THEN 
            DO:
                {utp/ut-liter.i "Abril" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 5  THEN 
            DO:
                {utp/ut-liter.i "Maio" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 6  THEN 
            DO:
                {utp/ut-liter.i "Junho" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 7  THEN 
            DO:
                {utp/ut-liter.i "Julho" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 8  THEN 
            DO:
                {utp/ut-liter.i "Agosto" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 9  THEN 
            DO:
                {utp/ut-liter.i "Setembro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 10  THEN 
            DO:
                {utp/ut-liter.i "Outubro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 11  THEN 
            DO:
                {utp/ut-liter.i "Novembro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
            WHEN 12  THEN 
            DO:
                {utp/ut-liter.i "Dezembro" *}
                ASSIGN mes-ini = RETURN-VALUE.
            END.
        END CASE.
    END.
    
    IF periodoFinal <> ? THEN
    DO:
        ASSIGN ano-fim = INT(YEAR(periodoFinal)).
        CASE mesAuxFim:
            WHEN 1  THEN 
            DO:
                {utp/ut-liter.i "Janeiro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 2  THEN 
            DO:
                {utp/ut-liter.i "Fevereiro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 3  THEN 
            DO:
                {utp/ut-liter.i "Marco" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 4  THEN 
            DO:
                {utp/ut-liter.i "Abril" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 5  THEN 
            DO:
                {utp/ut-liter.i "Maio" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 6  THEN 
            DO:
                {utp/ut-liter.i "Junho" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 7  THEN 
            DO:
                {utp/ut-liter.i "Julho" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 8  THEN 
            DO:
                {utp/ut-liter.i "Agosto" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 9  THEN 
            DO:
                {utp/ut-liter.i "Setembro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 10  THEN 
            DO:
                {utp/ut-liter.i "Outubro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 11  THEN 
            DO:
                {utp/ut-liter.i "Novembro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
            WHEN 12  THEN 
            DO:
                {utp/ut-liter.i "Dezembro" *}
                ASSIGN mes-fim = RETURN-VALUE.
            END.
        END CASE.    
    END.
            


END PROCEDURE.
