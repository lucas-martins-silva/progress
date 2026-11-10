/* Cidade */
CREATE tt-cidade.
ASSIGN tt-cidade.pais            = Country
       tt-cidade.estado          = State
       tt-cidade.cidade          = City
       tt-cidade.sigla           = Abbreviation
       tt-cidade.nome-mic-reg    = MicroTerritory
       tt-cidade.cdn-domic-fisc  = DomicileTaxCode
       tt-cidade.cdn-munpio-ibge = IBGECode
       tt-cidade.nome-ab-reg     = Territory.
                                                                            
IF tt-cidade.cdn-domic-fisc  = ? THEN ASSIGN tt-cidade.cdn-domic-fisc  = 0.
IF tt-cidade.cdn-munpio-ibge = ? THEN ASSIGN tt-cidade.cdn-munpio-ibge = 0. 

if  not valid-handle(h-bodi341)
    or  h-bodi341:type      <> "PROCEDURE":U 
    or  h-bodi341:file-name <> "dibo/bodi341.p":U then run dibo/bodi341.p persistent set h-bodi341.

run openQueryStatic in h-bodi341 (input "Default":U) no-error.
if return-value = 'NOK' then run emptyRowErrors  in h-bodi341.

run goToKey         in h-bodi341 (input tt-cidade.cidade,
                                  input tt-cidade.estado,
                                  input tt-cidade.pais).
run setRecord       in h-bodi341 (input table tt-cidade).

IF NOT CAN-FIND (FIRST cidade 
                 WHERE cidade.cidade = tt-cidade.cidade
                 AND   cidade.estado = tt-cidade.estado
                 AND   cidade.pais   = tt-cidade.pais) THEN
ASSIGN cTranAction = "add".

CASE cTranAction:
    WHEN "add" THEN DO:                                        
        RUN validaCidade IN h-bodi341 (INPUT tt-cidade.cidade,
                                       INPUT tt-cidade.estado).
        RUN createRecord IN h-bodi341.                         
        RUN getRowErrors IN h-bodi341 (OUTPUT TABLE RowErrors).
        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
    END.

    WHEN "upd" THEN DO:
        RUN validaCidade IN h-bodi341 (INPUT tt-cidade.cidade,
                                       INPUT tt-cidade.estado).
        RUN updateRecord IN h-bodi341.
        RUN getRowErrors IN h-bodi341 (OUTPUT TABLE RowErrors).
        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
    END.
END.                                                           

/*--- Para apresentar o problema no extrato de versÆo ------------------------------*/
/*IF  c-arquivo-log <> "" THEN DO:
    IF  ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu¯Êo do programa */
        DO  iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
    END.
    OUTPUT TO value(c-arquivo-log) APPEND.
    PUT SKIP(1) "Adapter Cidade: " cErrorText FORMAT "x(200)".
    OUTPUT CLOSE.
END.*/
/*----------------------------------------------------------------------------------*/



