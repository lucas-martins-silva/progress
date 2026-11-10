/*---------------------------------------------------
@api: svQuotas
@visibility: internal
@summary: <RESUMO-OBJETIVO>
@description: <DESCRIÇÃO-OBJETIVO>
---------------------------------------------------*/

{utp/ut-api.i}
{utp/ut-globalsession.i}
{utp/ut-api-utils.i}
 
//tamanho da pagina default 999
&GLOBAL-DEFINE SV-PAGE-SIZE 1000
// modos possiveis DBTBATR TBATR ATR Default TBATR
&GLOBAL-DEFINE SV-MODO TBATR
//Separador de nome de atributo default _ e ? para sem separador 
&GLOBAL-DEFINE SV-SEP _
//Inicial do nome da procedure de campo calculado Default calc
&GLOBAL-DEFINE SV-PRNAME calc 
{utp/ut-sv-utils.i}

{utp/ut-api-action.i pObjects GET /objectschema/~* } 
{utp/ut-api-action.i pData POST /data/~* } 

{utp/ut-api-notfound.i}

{acp/api/v1/svQuotas.i} // defini‡äes tt's e vari veis

/*retorna o schema da tabela*/
PROCEDURE pObjects:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.
    DEFINE VARIABLE i         AS INTEGER         NO-UNDO.        
    DEFINE VARIABLE prop      AS jsonObject      NO-UNDO.
        
    DO ON ERROR UNDO, LEAVE:
        /*gera o schema com base nos campos da tabela*/
        RUN generateProperties("Objeto de neg¢cio da tabela Cotas","Tabela cotas", "Objeto de neg¢cio da tabela Cotas", "/api/acp/v1/svQuotas",  OUTPUT prop ). 
                
        CATCH eSysError AS Progress.Lang.sysError:    
            DO i = 1 TO eSysError:NumMessages:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber = eSysError:GetMessageNum(i)
                       RowErrors.ErrorSubType = 'error'
                       RowErrors.ErrorDescription = eSysError:GetMessage(i).   
            END.               
        END CATCH.                   
        FINALLY:
            RUN createJsonResponse(INPUT prop, INPUT TABLE RowErrors, INPUT FALSE, OUTPUT oJsonOutput).        
        END.         
    END.        
        
END PROCEDURE.

/*retorna os dados*/
PROCEDURE pData:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.
    DEFINE VARIABLE oResponse AS JsonAPIResponse NO-UNDO.  
    
    DEFINE VARIABLE hTable      AS HANDLE          NO-UNDO.
    DEFINE VARIABLE prop        AS jsonObject      NO-UNDO.
    DEFINE VARIABLE i           AS INTEGER         NO-UNDO.
    DEFINE VARIABLE cUri        AS CHARACTER       NO-UNDO. 
    DEFINE VARIABLE cFilter     AS CHARACTER       NO-UNDO.    
    DEFINE VARIABLE cParam      AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE cParameters AS CHARACTER       NO-UNDO.
    
    DO ON ERROR UNDO, LEAVE:
        ASSIGN cURI        = ojsonInput:GetCharacter("uri")
               hTable      = BUFFER cotas:HANDLE.
               cParameters = 'cotas.dt-inicial >= &dataIni AND cotas.dt-inicial <= &dataFim '                                   /* data */
                           + 'AND cotas.cod-estabel >= &estabIni AND cotas.cod-estabel <= &estabFim '                           /* estabelecimento */
                           + 'AND ((cotas.cod-canal-venda >= &codCanalVendaIni AND cotas.cod-canal-venda <= &codCanalVendaFim) ' /* canal de venda */
                           + 'OR cotas.cod-canal-venda = ?) '
                           + 'AND ((cotas.cod-gr-cli >= &codGrCliIni AND cotas.cod-gr-cli <= &codGrCliFim) '                    /* grupo do cliente */
                           + 'OR cotas.cod-gr-cli = ?) '
                           + 'AND ((cotas.nome-abrev >= &nomeAbrevIni AND cotas.nome-abrev <= &nomeAbrevFim) '                  /* nome abreviado */
                           + 'OR cotas.nome-abrev = ?) '
                           + 'AND ((cotas.nome-ab-reg >= &nomeAbRegIni AND cotas.nome-ab-reg <= &nomeAbRegFim) '                /* regiao */
                           + 'OR cotas.nome-ab-reg = ?) '
                           + 'AND ((cotas.nome-mic-reg >= &nomeMicRegIni AND cotas.nome-mic-reg <= &nomeMicRegFim) '            /* nome micro regiao */
                           + 'OR cotas.nome-mic-reg = ?) '
                           + 'AND cotas.cod-rep >= &repIni AND cotas.cod-rep <= &repFim '                                       /* c¢digo representante */
                           + 'AND cotas.cd-produto >= &itCodigoIni AND cotas.cd-produto <= &itCodigoFim'.                       /* item */

        RUN piReadParameters(oJsonInput).
        
        RUN processParameters(oJsonInput, cParameters, OUTPUT cParam).

        RUN generateFilter(oJsonInput, OUTPUT cFilter).  /*processa o filtro se existir*/

        RUN generateData(hTable, cURI, cParam, OUTPUT prop ). /*gera o Json de retorno*/ 

        CATCH eSysError AS Progress.Lang.sysError:    
            DO i = 1 TO eSysError:NumMessages:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber = eSysError:GetMessageNum(i)
                       RowErrors.ErrorSubType = 'error'
                       RowErrors.ErrorDescription = eSysError:GetMessage(i)
                       RowErrors.ErrorHelp  = eSysError:GetMessage(i).
            END.               
        END CATCH.  
        FINALLY:
            RUN createJsonResponse(INPUT prop, INPUT TABLE RowErrors, INPUT FALSE, OUTPUT oJsonOutput).        
        END.      
    END.
END PROCEDURE.

PROCEDURE generateSchema: //nome fixo a procedure que gera o schema   
    
    DEFINE    VARIABLE      mySchema AS schemaItem      NO-UNDO.    
    DEFINE    VARIABLE      myParam  AS schemaParameter NO-UNDO.
    
    /*limpa schema*/
    RUN clearSchema. 

    /*filtros*/
    RUN piGenerateParameters (INPUT-OUTPUT mySchema,
                              INPUT-OUTPUT myParam).

    /*adiciona todos os atributos de uma tabela com excecao dos listados*/
    RUN addSchemaTableWithExceptions(INPUT BUFFER cotas:HANDLE,"char-1,char-2,dec-1,dec-2,int-1,int-2,log-1,log-2,data-1,data-2").
    
    FINALLY:        
        IF VALID-OBJECT(mySchema) THEN DO:         
            DELETE OBJECT mySchema NO-ERROR.    
            DELETE OBJECT myParam NO-ERROR.
        END.
    END FINALLY.
    
END PROCEDURE.

// Gera os parƒmetros do objeto de neg¢cio de Cotas com base na tabela tt-param
PROCEDURE piGenerateParameters:
    DEFINE INPUT-OUTPUT PARAM  mySchema AS schemaItem      NO-UNDO.    
    DEFINE INPUT-OUTPUT PARAM  myParam  AS schemaParameter NO-UNDO.

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    RUN piCreateParamTable.

    DO i = 1 TO h-tt-param:NUM-FIELDS:
        ASSIGN 
            myParam = NEW schemaParameter() 
            myParam:svName = h-tt-param:BUFFER-FIELD(i):NAME
            myParam:svDisplayName = h-tt-param:BUFFER-FIELD(i):COLUMN-LABEL
            myParam:svType = h-tt-param:BUFFER-FIELD(i):DATA-TYPE        
            myParam:svLookupUrl = h-tt-param:BUFFER-FIELD(i):HELP.            
        RUN addSchemaParameter(myParam).
    END.

    FINALLY:
        IF VALID-HANDLE(h-tt-param) THEN DELETE OBJECT h-tt-param NO-ERROR.
    END FINALLY.
        
END PROCEDURE.

// Faz a leitura dos parƒmetros enviados na requisi‡Æo e prenche a temp-table tt-param com os valores vindos do json.
PROCEDURE piReadParameters: 
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.

    DEFINE VARIABLE cParam              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
    
    DEFINE VARIABLE oJsonParam AS JsonObject NO-UNDO.

    RUN piCreateParamTable.
    
    DO i = 1 TO h-tt-param:NUM-FIELDS:
        ASSIGN cFieldName = "&" + STRING(h-tt-param:BUFFER-FIELD(i):NAME).

        RUN processParameters(oJsonInput, cFieldName, OUTPUT cParam).

        IF h-tt-param:BUFFER-FIELD(i):DATA-TYPE = "DATE" THEN
            ASSIGN h-tt-param:BUFFER-FIELD(i):BUFFER-VALUE = DATE(cParam).

        IF h-tt-param:BUFFER-FIELD(i):DATA-TYPE = "INTEGER" THEN
            ASSIGN h-tt-param:BUFFER-FIELD(i):BUFFER-VALUE = INTEGER(cParam).
        
        IF h-tt-param:BUFFER-FIELD(i):DATA-TYPE = "LOGICAL" THEN
            ASSIGN h-tt-param:BUFFER-FIELD(i):BUFFER-VALUE = LOGICAL(cParam).

        IF h-tt-param:BUFFER-FIELD(i):DATA-TYPE = "CHARACTER" THEN
            ASSIGN h-tt-param:BUFFER-FIELD(i):BUFFER-VALUE = replace(TRIM(cParam), '"', '').

        IF TRIM(cParam) = '""' OR TRIM(cParam) = '" "' THEN
            ASSIGN h-tt-param:BUFFER-FIELD(i):BUFFER-VALUE = h-tt-param:BUFFER-FIELD(i):INITIAL.
    END.

END PROCEDURE.

PROCEDURE  piCreateParamTable:
    EMPTY TEMP-TABLE tt-param.

    ASSIGN h-tt-param = TEMP-TABLE tt-param:DEFAULT-BUFFER-HANDLE.

    CREATE tt-param.
END PROCEDURE.

FINALLY:
    IF VALID-HANDLE(h-tt-param) THEN 
        DELETE OBJECT h-tt-param NO-ERROR.
END FINALLY.
