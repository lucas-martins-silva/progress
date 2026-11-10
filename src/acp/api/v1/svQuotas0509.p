/*---------------------------------------------------
@api: svQuotas0509
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

{acp/api/v1/svQuotas0509.i} // defini‡äes tt's e vari veis
{acp/ac0509.i} // defini‡Æo da tempt-table tt-param

/*retorna o schema da tabela*/
PROCEDURE pObjects:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.
    DEFINE VARIABLE i         AS INTEGER         NO-UNDO.        
    DEFINE VARIABLE prop      AS jsonObject      NO-UNDO.
        
    DO ON ERROR UNDO, LEAVE:
        /*gera o schema com base nos campos da tabela*/
        RUN generateProperties("Gr ficos Cotas AC0509","Tabela cotas AC0509", "Gr ficos Cotas AC0509", "/api/acp/v1/svQuotas",  OUTPUT prop ). 
                
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
    DEFINE VARIABLE h-ac0509rp  AS HANDLE          NO-UNDO.
    DEFINE VARIABLE raw-param   AS RAW             NO-UNDO.
    
    DO ON ERROR UNDO, LEAVE:
    
        RUN piReadParameters(oJsonInput).
        
        FIND FIRST tt-parameters NO-LOCK NO-ERROR.
        
        CREATE tt-param.
        ASSIGN tt-param.cod-estab-ini       = tt-parameters.estabIni
               tt-param.cod-estab-fim       = tt-parameters.estabFim
               tt-param.cod-canal-venda-ini = tt-parameters.codCanalVendaIni
               tt-param.cod-canal-venda-fim = tt-parameters.codCanalVendaFim
               tt-param.cod-gr-cli-ini      = tt-parameters.codGrCliIni
               tt-param.cod-gr-cli-fim      = tt-parameters.codGrCliFim
               tt-param.nome-abrev-ini      = tt-parameters.nomeAbrevIni
               tt-param.nome-abrev-fim      = tt-parameters.nomeAbrevFim
               tt-param.nome-ab-reg-ini     = tt-parameters.nomeAbRegIni
               tt-param.nome-ab-reg-fim     = tt-parameters.nomeAbRegFim
               tt-param.nome-mic-reg-ini    = tt-parameters.nomeMicRegIni 
               tt-param.nome-mic-reg-fim    = tt-parameters.nomeMicRegFim  
               tt-param.cod-rep-ini         = tt-parameters.repIni
               tt-param.cod-rep-fim         = tt-parameters.repFim
               tt-param.cd-produto-ini      = tt-parameters.itCodigoIni
               tt-param.cd-produto-fim      = tt-parameters.itCodigoFim
               tt-param.dt-inicial          = tt-parameters.dataIni
               tt-param.dt-final            = tt-parameters.dataFim
               tt-param.i-chave             = tt-parameters.cotasPor
               tt-param.i-base-calc         = tt-parameters.tipoCota
               tt-param.i-realizada         = tt-parameters.realizada.
               
        RAW-TRANSFER tt-param TO raw-param.
               
        RUN acp/ac0509rp.p PERSISTENT SET h-ac0509rp (INPUT raw-param).
        RUN returnTtInfo IN h-ac0509rp (OUTPUT TABLE tt-info).
        DELETE PROCEDURE h-ac0509rp.
        
        FOR EACH tt-info:
            CREATE tt-resultados.
            ASSIGN tt-resultados.cotasPor = tt-info.campo-chave
                   tt-resultados.valor    = tt-info.qtde.
        END.

        ASSIGN cURI   = ojsonInput:GetCharacter("uri")
               hTable = BUFFER tt-resultados:HANDLE.

        RUN generateData(hTable, cURI, "", OUTPUT prop ). /*gera o Json de retorno*/ 

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
    RUN addSchemaTable(INPUT BUFFER tt-resultados:HANDLE). 
    
    FINALLY:        
        IF VALID-OBJECT(mySchema) THEN DO:         
            DELETE OBJECT mySchema NO-ERROR.    
            DELETE OBJECT myParam NO-ERROR.
        END.
    END FINALLY.
    
END PROCEDURE.

// Gera os parƒmetros do objeto de neg¢cio de Cotas com base na tabela tt-parameters
PROCEDURE piGenerateParameters:
    DEFINE INPUT-OUTPUT PARAM  mySchema AS schemaItem      NO-UNDO.    
    DEFINE INPUT-OUTPUT PARAM  myParam  AS schemaParameter NO-UNDO.

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    RUN piCreateParamTable.

    DO i = 1 TO h-tt-parameters:NUM-FIELDS:
        ASSIGN 
            myParam = NEW schemaParameter() 
            myParam:svName = h-tt-parameters:BUFFER-FIELD(i):NAME
            myParam:svDisplayName = h-tt-parameters:BUFFER-FIELD(i):COLUMN-LABEL
            myParam:svType = h-tt-parameters:BUFFER-FIELD(i):DATA-TYPE        
            myParam:svLookupUrl = h-tt-parameters:BUFFER-FIELD(i):HELP.            
        RUN addSchemaParameter(myParam).
    END.

    FINALLY:
        IF VALID-HANDLE(h-tt-parameters) THEN DELETE OBJECT h-tt-parameters NO-ERROR.
    END FINALLY.
        
END PROCEDURE.

// Faz a leitura dos parƒmetros enviados na requisi‡Æo e prenche a temp-table tt-parameters com os valores vindos do json.
PROCEDURE piReadParameters: 
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.

    DEFINE VARIABLE cParam              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
    
    DEFINE VARIABLE oJsonParam AS JsonObject NO-UNDO.

    RUN piCreateParamTable.
    
    DO i = 1 TO h-tt-parameters:NUM-FIELDS:
        ASSIGN cFieldName = "&" + STRING(h-tt-parameters:BUFFER-FIELD(i):NAME).

        RUN processParameters(oJsonInput, cFieldName, OUTPUT cParam).

        IF h-tt-parameters:BUFFER-FIELD(i):DATA-TYPE = "DATE" THEN
            ASSIGN h-tt-parameters:BUFFER-FIELD(i):BUFFER-VALUE = DATE(cParam).

        IF h-tt-parameters:BUFFER-FIELD(i):DATA-TYPE = "INTEGER" THEN
            ASSIGN h-tt-parameters:BUFFER-FIELD(i):BUFFER-VALUE = INTEGER(cParam).
        
        IF h-tt-parameters:BUFFER-FIELD(i):DATA-TYPE = "LOGICAL" THEN
            ASSIGN h-tt-parameters:BUFFER-FIELD(i):BUFFER-VALUE = LOGICAL(cParam).

        IF h-tt-parameters:BUFFER-FIELD(i):DATA-TYPE = "CHARACTER" THEN
            ASSIGN h-tt-parameters:BUFFER-FIELD(i):BUFFER-VALUE = replace(TRIM(cParam), '"', '').

        IF TRIM(cParam) = '""' OR TRIM(cParam) = '" "' THEN
            ASSIGN h-tt-parameters:BUFFER-FIELD(i):BUFFER-VALUE = h-tt-parameters:BUFFER-FIELD(i):INITIAL.
    END.

END PROCEDURE.

PROCEDURE  piCreateParamTable:
    EMPTY TEMP-TABLE tt-parameters.

    ASSIGN h-tt-parameters = TEMP-TABLE tt-parameters:DEFAULT-BUFFER-HANDLE.

    CREATE tt-parameters.
END PROCEDURE.

FINALLY:
    IF VALID-HANDLE(h-tt-parameters) THEN 
        DELETE OBJECT h-tt-parameters NO-ERROR.
END FINALLY.
