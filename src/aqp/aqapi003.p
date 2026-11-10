/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQAPI003 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQAPI003 MAQ}
&ENDIF

def var h-boin00961     as handle                    no-undo.
def var h-boin00965     as handle                    no-undo.
DEF VAR h-boad00503     AS HANDLE                    NO-UNDO.
DEF VAR h-boin172na     AS HANDLE                    NO-UNDO.
DEF VAR i-seq-produtor  AS INT                       NO-UNDO.
DEF VAR i-seq-carga     AS INT                       NO-UNDO.
def var l-erro          as logical                   no-undo.
def var l-erro-prod     as logical                   no-undo.
def var c-erro          as char                      no-undo.
def var c-erro-desc     as char                      no-undo.
def var c-erro-produt   as char                      no-undo.
def var c-sit           as char                      no-undo.
def var c-sit-prod      as char                      no-undo.

{inbo/boin00961.i tt-carg-rural}
{inbo/boin00961.i tt-carg-rural-aux}
{inbo/boin00965.i tt-produt-carg}
{inbo/boin00965.i tt-produt-carg-aux}
{method/dbotterr.i}  /*--- Include com definiá∆o da temp-table RowErrors ---*/

DEFINE TEMP-TABLE tt-result-carg NO-UNDO 
    FIELD num-carg          like carg-rural.num-carg  
    FIELD cod-carga         like carg-rural.cod-carga 
    FIELD cod-placa         like carg-rural.cod-placa 
    FIELD cod-rota          like carg-rural.cod-rota  
    FIELD situacao          AS   CHAR
    FIELD erro-desc         AS   CHAR.

DEFINE TEMP-TABLE tt-result-produt NO-UNDO 
    FIELD num-carg                like carg-rural.num-carg
    FIELD cdn-produt-rural        AS CHAR FORMAT "x(12)"
    FIELD cod-pto-coleta          like produt-carg.cod-pto-coleta  
    FIELD cdn-repos               AS CHAR FORMAT "x(8)"  
    FIELD dat-trans               AS CHAR FORMAT "X(10)"        
    FIELD qtd-coleta              AS CHAR FORMAT "x(17)"  
    FIELD situacao                AS   CHAR
    FIELD erro-desc               AS   CHAR.

DEFINE TEMP-TABLE tt-produt-carg-automat NO-UNDO
    FIELD cdn-identif       LIKE produt-carg.cdn-identif      
    FIELD cod-estabel       LIKE produt-carg.cod-estabel      
    FIELD num-carg          LIKE produt-carg.num-carg         
    FIELD cdn-produt-rural  LIKE produt-carg.cdn-produt-rural 
    FIELD cod-pto-coleta    LIKE produt-carg.cod-pto-coleta.

PROCEDURE createCarga:

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-carg-rural. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-produt-carg.
    DEFINE INPUT PARAMETER TABLE FOR tt-produt-carg-automat.

    DEFINE VARIABLE c-cod-inter-veic AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-transp     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-cod-uf         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iTipoConEst      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lFraciona        AS LOG       NO-UNDO.
    DEFINE VARIABLE deQtdPtoColeta   AS DECIMAL   NO-UNDO.

    /*controle que permite que o produtor responsavel
      entregue quantidade 0 caso outros produtores
      tenham efetuado alguma entrega no mesmo pto*/
    FOR EACH tt-produt-carg NO-LOCK:
        ASSIGN deQtdPtoColeta = deQtdPtoColeta + tt-produt-carg.qtd-coleta.
    END.

    DEFINE VAR l-carga-existe AS LOG NO-UNDO.

    run inbo/boin00961.p persistent set h-boin00961.
    run openQueryStatic in h-boin00961 (input "Main":U).
    
    run inbo/boin00965.p persistent set h-boin00965.
    run openQueryStatic in h-boin00965 (input "Main":U).

    run adbo/boad00503.p persistent set h-boad00503.

    run inbo/boin172na.p persistent set h-boin172na.
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U).
    
    RUN setCreateProdutAut IN h-boin00961 (input NO).
    
    FOR EACH tt-carg-rural:

        DO TRANS:

            run emptyRowErrors in h-boin00961.
            ASSIGN l-erro = NO.

            for each tt-carg-rural-aux:
                delete tt-carg-rural-aux.
            end.

            /*Se tipo de aferiá∆o do item for por valor informado zera o peso bruto*/
            FOR FIRST item-estab-rural FIELDS(idi-tip-aferic) NO-LOCK
                WHERE item-estab-rural.it-codigo   = tt-carg-rural.it-codigo 
                  AND item-estab-rural.cod-estabel = tt-carg-rural.cod-estabel:
                  
                  IF item-estab-rural.idi-tip-aferic <> 1 THEN /* PESAGEM */
                      ASSIGN tt-carg-rural.qtd-peso-brut = 0
                             tt-carg-rural.val-densidade = 0.

            END.

            /*atualiza os campos relacionados a placa automaticamente*/
            ASSIGN c-cod-inter-veic = ""
                   c-cod-uf = ""
                   c-cod-transp = 0.

            RUN setConstraintByCodPlaca IN h-boad00503(INPUT tt-carg-rural.cod-placa).
            RUN openQueryStatic IN h-boad00503 (INPUT "ByCodPlaca":U) NO-ERROR.
            
            RUN getCharField IN h-boad00503 (INPUT "cod-inter-veic":U, OUTPUT c-cod-inter-veic) NO-ERROR. 
            RUN getCharField IN h-boad00503 (INPUT "cod-uf":U,         OUTPUT c-cod-uf) NO-ERROR. 
            RUN getIntField  IN h-boad00503 (INPUT "cod-transp":U,     OUTPUT c-cod-transp) NO-ERROR.
        
            ASSIGN tt-carg-rural.cod-uf         = c-cod-uf
                   tt-carg-rural.cod-transp     = c-cod-transp
                   tt-carg-rural.cod-inter-veic = c-cod-inter-veic.

            /*se item n∆o for controlado por referencia n∆o considera informaá∆o armazenada no campo cod-refer*/
            RUN goToKey IN h-boin172na (INPUT tt-carg-rural.it-codigo) NO-ERROR.    
            IF RETURN-VALUE = "OK":U THEN DO:
                
                RUN getIntField IN h-boin172na (INPUT "tipo-con-est":U, OUTPUT iTipoConEst) NO-ERROR.
                RUN getLogField IN h-boin172na (INPUT "fraciona ":U, OUTPUT lFraciona) NO-ERROR.

                IF iTipoConEst <> 4 THEN
                    ASSIGN tt-carg-rural.cod-refer = "".

            END.
            
            ASSIGN c-sit = "OK"
                   i-seq-carga = tt-carg-rural.num-carg.
            CREATE tt-carg-rural-aux.
            BUFFER-COPY tt-carg-rural TO tt-carg-rural-aux.
        
            run setRecord in h-boin00961 (input table tt-carg-rural-aux).
            run createRecord in h-boin00961.
           
            if  return-value = "NOK":U then do:
                assign l-erro = yes
                       c-sit  = "NOK".
                run getRowErrors in h-boin00961 (output table RowErrors).
            end.
            
            ASSIGN c-erro-desc = "".
            for each RowErrors:
                ASSIGN c-erro-desc = c-erro-desc + RowErrors.ErrorDescription + CHR(13).
                DELETE rowErrors.
            end.

            CREATE tt-result-carg.
            ASSIGN tt-result-carg.num-carg  = tt-carg-rural-aux.num-carg   
                   tt-result-carg.cod-carga = tt-carg-rural-aux.cod-carga  
                   tt-result-carg.cod-placa = tt-carg-rural-aux.cod-placa  
                   tt-result-carg.cod-rota  = tt-carg-rural-aux.cod-rota   
                   tt-result-carg.situacao  = c-sit
                   tt-result-carg.erro-desc = c-erro-desc.


            /* Altera motivo de n∆o coleta para os coletivos */
            
            IF CAN-FIND(FIRST tt-produt-carg 
                        WHERE tt-produt-carg.num-carg = i-seq-carga
                          AND tt-produt-carg.cdn-motiv-nao-coleta > 0) THEN DO: 
                FOR EACH tt-produt-carg 
                   WHERE tt-produt-carg.num-carg = i-seq-carga
                     AND tt-produt-carg.cdn-motiv-nao-coleta > 0: 
                    FOR FIRST produt-pto-coleta FIELDS(cdn-produt-rural) NO-LOCK
                        WHERE produt-pto-coleta.cod-pto-coleta = tt-produt-carg.cod-pto-coleta
                          AND produt-pto-coleta.log-respons:                          
                            ASSIGN tt-produt-carg.idi-nao-coleta = 1.
                    END.
                END.
            END.   
        
            ASSIGN l-erro-prod = NO.
            FOR EACH tt-produt-carg 
               WHERE tt-produt-carg.num-carg = i-seq-carga:
               
                /*Cria produt-carga*/
                ASSIGN c-sit-prod = "OK".
                run emptyRowErrors in h-boin00965.
            
                for each tt-produt-carg-aux:
                    delete tt-produt-carg-aux.
                end.

                /*se n∆o foi informado procura o produtor responsavel*/
                IF tt-produt-carg.cdn-produt-respons = 0 THEN DO:
                    FOR FIRST produt-pto-coleta FIELDS(cdn-produt-rural) NO-LOCK
                        WHERE produt-pto-coleta.cod-pto-coleta = tt-produt-carg.cod-pto-coleta
                          AND produt-pto-coleta.log-respons: END.
                          
                    ASSIGN tt-produt-carg.cdn-produt-respons = IF AVAIL produt-pto-coleta THEN produt-pto-coleta.cdn-produt-rural ELSE 0.  
                        
                END.

                /*Faz ajuste se item n∆o aceita quantidade fracionada*/
                IF NOT lFraciona THEN
                    ASSIGN tt-produt-carg.qtd-coleta = TRUNC(tt-produt-carg.qtd-coleta,0).

                CREATE tt-produt-carg-aux.
                BUFFER-COPY tt-produt-carg TO tt-produt-carg-aux.
    
                run setRecord in h-boin00965 (input table tt-produt-carg-aux).

                /*Se produtor for gerado automaticamente n∆o valida motivo de n∆o coleta*/
                FOR FIRST tt-produt-carg-automat FIELDS() 
                    WHERE tt-produt-carg-automat.num-carg    = tt-produt-carg.num-carg
                      AND tt-produt-carg-automat.cdn-identif = tt-produt-carg.cdn-identif NO-LOCK:
                END.

                IF NOT AVAIL tt-produt-carg-automat AND
                   deQtdPtoColeta = 0 THEN
                    RUN validateMotivoNaoColeta in h-boin00965.

                if  return-value = "NOK":U then do:
                    assign l-erro-prod = yes
                           c-sit-prod  = "NOK".
                    run getRowErrors in h-boin00965 (output table RowErrors).
                end.
                ELSE DO:
                    run createRecord in h-boin00965.                    
                    if  return-value = "NOK":U then do:
                        assign l-erro-prod = yes
                               c-sit-prod  = "NOK".
                        run getRowErrors in h-boin00965 (output table RowErrors).
                    end.
                END.
        
                ASSIGN c-erro-produt = "".
                for each RowErrors:
                    ASSIGN c-erro-produt = c-erro-produt + RowErrors.ErrorDescription + CHR(13).
                    DELETE RowErrors.
                end.

                CREATE tt-result-produt.
                ASSIGN tt-result-produt.num-carg         = tt-carg-rural.num-carg
                       tt-result-produt.cdn-produt-rural = string(tt-produt-carg-aux.cdn-produt-rural, "->>>,>>>,>>9") 
                       tt-result-produt.cod-pto-coleta   = tt-produt-carg-aux.cod-pto-coleta   
                       tt-result-produt.cdn-repos        = string(tt-produt-carg-aux.cdn-repos, "->>>,>>9")
                       tt-result-produt.dat-trans        = string(date(SUBSTR(STRING(tt-produt-carg-aux.dat-trans),1,2) + "/" + SUBSTR(STRING(tt-produt-carg-aux.dat-trans),4,2) + "/" + SUBSTR(STRING(tt-produt-carg-aux.dat-trans),7,4)),"99/99/9999")
                       tt-result-produt.qtd-coleta       = string(tt-produt-carg-aux.qtd-coleta, ">>>>,>>>,>>9.9999")       
                       tt-result-produt.situacao         = c-sit-prod                          
                       tt-result-produt.erro-desc        = c-erro-produt NO-ERROR.
                
            END.

            IF l-erro OR l-erro-prod THEN
                UNDO, NEXT.

        END.
    
    END.
    
    DELETE PROCEDURE h-boin00961.
    DELETE PROCEDURE h-boin00965.
    DELETE PROCEDURE h-boad00503.
    DELETE PROCEDURE h-boin172na.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE getResult:

    DEFINE OUTPUT PARAMETER TABLE FOR tt-result-carg.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-result-produt.

    RETURN "OK":U.

END PROCEDURE.
