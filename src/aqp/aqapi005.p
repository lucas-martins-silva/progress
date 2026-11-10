/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i AQAPI005 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aqapi005 MAQ}
&ENDIF

/*****************************************************************************
**
**       Programa: AQAPI005
**
**       Objetivo: Ativar e desativar cadastros do módulo MAQ, bem como 
**                 retornar o status (ativo, inativo) de determinado cadastro
**
**       Parametros:    /**** ENTRADA ****/
                     Ação     (ativar, desativar, consultar)                                       **       o que fazer       **
                     Cadastro (produtor, propriedade, pontoDeColeta, repositorio, produtPtoColeta) **     com o que fazer     **
                     Chave    ("ROWID do cadastro")                                                ** fazer com qual cadastro **

                        /**** SAÍDA ****/
                     Situacao (Retorna situacao do cadastro 1 - "Ativo" ou 0 - "Inativo")
                     Tabela rowErrors (Tabela com os erros ocorridos durante o processo)   

**
*****************************************************************************/

{utp/ut-glob.i}
{method/dbotterr.i}           /* rowErrors*/

/*Vari veis*/
DEFINE VARIABLE h-boin00962   AS HANDLE NO-UNDO. /* produt-rural      */
DEFINE VARIABLE h-boin00966   AS HANDLE NO-UNDO. /* pto-coleta        */
DEFINE VARIABLE h-boin00976   AS HANDLE NO-UNDO. /* pto-rota-coleta   */
DEFINE VARIABLE h-boin00980   AS HANDLE NO-UNDO. /* propried-rural    */
DEFINE VARIABLE h-boin00984   AS HANDLE NO-UNDO. /* reposit           */
DEFINE VARIABLE h-boin00990   AS HANDLE NO-UNDO. /* produt-pto-coleta */

DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

{inbo/boin00962.i tt-produt-rural}

{inbo/boin00966.i tt-pto-coleta}
{inbo/boin00966.i tt-pto-coleta-aux}

{inbo/boin00976.i tt-pto-rota-coleta}
{inbo/boin00976.i tt-pto-rota-coleta-aux}

{inbo/boin00980.i tt-propried-rural}
{inbo/boin00980.i tt-propried-rural-aux}

{inbo/boin00984.i tt-reposit}
{inbo/boin00984.i tt-reposit-aux}

{inbo/boin00990.i tt-produt-pto-coleta}
{inbo/boin00990.i tt-produt-pto-coleta-aux}


/*#############################################################################################################################*/
/*######################################### P R O C E D U R E     #   E X T E R N A  ##########################################*/
/*#############################################################################################################################*/
PROCEDURE piInicial:

    /*Parametros*/
    DEFINE INPUT        PARAMETER cAcao       AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER cCadastro   AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT       PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN piInitializeDBOs IN THIS-PROCEDURE.

    DO TRANSACTION:
        CASE cAcao:
        
            WHEN "Ativar":U THEN DO:
        
                RUN piAtivar IN THIS-PROCEDURE(INPUT cCadastro,
                                               INPUT rRowid,
                                               INPUT-OUTPUT iSituacao,
                                               INPUT-OUTPUT TABLE rowErrors).
        
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO, RETURN "NOK":U.
                END.
        
            END.
            WHEN "Desativar":U THEN DO:
        
                RUN piDesativar IN THIS-PROCEDURE(INPUT cCadastro,
                                                  INPUT rRowid,
                                                  INPUT-OUTPUT iSituacao,
                                                  INPUT-OUTPUT TABLE rowErrors).
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO, RETURN "NOK":U.
                END.
        
            END.
            WHEN "Consultar":U THEN DO:
        
                RUN piConsultar IN THIS-PROCEDURE (INPUT cCadastro,
                                                   INPUT rRowid,
                                                   INPUT-OUTPUT iSituacao,
                                                   INPUT-OUTPUT TABLE rowErrors).
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO, RETURN "NOK":U.
                END.
        
            END.
            OTHERWISE DO:
        
                /*criar rowErrors*/
                RETURN "NOK":U.
        
            END.
        
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/*##############################################################################################################################*/


/*#############################################################################################################################*/
/*######################################### P R O C E D U R E S   #   I N T E R N A S #########################################*/
/*#############################################################################################################################*/


PROCEDURE piInitializeDBOs PRIVATE:

    /* produt-rural */
    IF NOT VALID-HANDLE(h-boin00962) THEN DO:
        IF NOT VALID-HANDLE( h-boin00962) THEN
        RUN inbo/boin00962.p PERSISTENT SET h-boin00962.
    END.
    RUN openQueryStatic IN h-boin00962 (INPUT "Main":U).

    /* pto-coleta */
    IF NOT VALID-HANDLE(h-boin00966) THEN DO:
        IF NOT VALID-HANDLE( h-boin00966) THEN
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
    END.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

    /* pto-rota-coleta */
    IF NOT VALID-HANDLE(h-boin00976) THEN DO:
        IF NOT VALID-HANDLE( h-boin00976) THEN
        RUN inbo/boin00976.p PERSISTENT SET h-boin00976.
    END.
    RUN openQueryStatic IN h-boin00976 (INPUT "Main":U).

    /* propried-rural */
    IF NOT VALID-HANDLE(h-boin00980) THEN DO:
        IF NOT VALID-HANDLE( h-boin00980) THEN
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
    END.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    /* reposit */
    IF NOT VALID-HANDLE(h-boin00984) THEN DO:
        IF NOT VALID-HANDLE( h-boin00984) THEN
        RUN inbo/boin00984.p PERSISTENT SET h-boin00984.
    END.
    RUN openQueryStatic IN h-boin00984 (INPUT "Main":U).

    /* produt-pto-coleta */
    IF NOT VALID-HANDLE(h-boin00990) THEN DO:
        IF NOT VALID-HANDLE( h-boin00990) THEN
        RUN inbo/boin00990.p PERSISTENT SET h-boin00990.
    END.
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U).

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piFinalizeDBOs PRIVATE:

    /* produt-rural */
    IF  h-boin00962 <> ? THEN DO:
        DELETE PROCEDURE h-boin00962.
        ASSIGN h-boin00962 = ?.
    END.

    /* pto-coleta */
    IF  h-boin00966 <> ? THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    /* pto-rota-coleta */
    IF  h-boin00976 <> ? THEN DO:
        DELETE PROCEDURE h-boin00976.
        ASSIGN h-boin00976 = ?.
    END.

    /* propried-rural */
    IF  h-boin00980 <> ? THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    /* reposit */
    IF  h-boin00984 <> ? THEN DO:
        DELETE PROCEDURE h-boin00984.
        ASSIGN h-boin00984 = ?.
    END.

    /* produt-pto-coleta */
    IF  h-boin00990 <> ? THEN DO:
        DELETE PROCEDURE h-boin00990.
        ASSIGN h-boin00990 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piAtivar PRIVATE:

    DEFINE INPUT        PARAMETER cCadastro   AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR rowErrors.

    CASE cCadastro:

        WHEN "produtor":U THEN DO: 

            RUN piAtivarProdutor IN THIS-PROCEDURE (INPUT  rRowid,
                                                    OUTPUT iSituacao,
                                                    OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "propriedade":U THEN DO: 

            RUN piAtivarPropriedade IN THIS-PROCEDURE (INPUT  rRowid,
                                                       OUTPUT iSituacao,
                                                       OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "pontoDeColeta":U THEN DO:

            RUN piAtivarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                         OUTPUT iSituacao,
                                                         OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "repositorio":U THEN DO:

            RUN piAtivarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                       OUTPUT iSituacao,
                                                       OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END. 

        OTHERWISE DO:

            /*criar rowErrors*/
            RETURN "NOK":U.

        END.

    END.


RETURN "OK":U.

END PROCEDURE.


PROCEDURE piDesativar PRIVATE:

    DEFINE INPUT        PARAMETER cCadastro   AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR rowErrors.

    CASE cCadastro:

        WHEN "produtor":U THEN DO: 

            RUN piDesativarProdutor IN THIS-PROCEDURE (INPUT  rRowid,
                                                       OUTPUT iSituacao,
                                                       OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "propriedade":U THEN DO: 

            RUN piDesativarPropriedade IN THIS-PROCEDURE (INPUT  rRowid,
                                                          OUTPUT iSituacao,
                                                          OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "pontoDeColeta":U THEN DO:

            RUN piDesativarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                            OUTPUT iSituacao,
                                                            OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "produtPtoColeta":U THEN DO:

            RUN piDesativarProdutPtoColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                              OUTPUT iSituacao,
                                                              OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.    

        WHEN "repositorio":U THEN DO:

            RUN piDesativarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                          OUTPUT iSituacao,
                                                          OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END. 

        OTHERWISE DO:

            /*criar rowErrors*/
            RETURN "NOK":U.

        END.

    END.


RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultar PRIVATE:

    DEFINE INPUT        PARAMETER cCadastro   AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR rowErrors.

    CASE cCadastro:

        WHEN "produtor":U THEN DO: 

            RUN piConsultarProdutor IN THIS-PROCEDURE (INPUT  rRowid,
                                                       OUTPUT iSituacao,
                                                       OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "propriedade":U THEN DO: 

            RUN piConsultarPropriedade IN THIS-PROCEDURE (INPUT  rRowid,
                                                          OUTPUT iSituacao,
                                                          OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "pontoDeColeta":U THEN DO:

            RUN piConsultarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                            OUTPUT iSituacao,
                                                            OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "repositorio":U THEN DO:

            RUN piConsultarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                          OUTPUT iSituacao,
                                                          OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        WHEN "produtPtoColeta":U THEN DO:
    
            RUN piConsultarProdutPtoColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                              OUTPUT iSituacao,
                                                              OUTPUT TABLE rowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.

        END.

        OTHERWISE DO:

            /*criar rowErrors*/
            RETURN "NOK":U.

        END.

    END.

RETURN "OK":U.

END PROCEDURE.

/*################################### P R O C E D U R E S  #  P R O D U T O R ##################################################*/
PROCEDURE piAtivarProdutor PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE rRowidProdut AS ROWID NO-UNDO.

    ASSIGN rRowidProdut = rRowid.

    RUN getBatchRecords IN h-boin00962 (INPUT  rRowidProdut,
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-produt-rural).

    RUN emptyRowErrors  IN h-boin00962.

    FOR EACH tt-produt-rural:

        RUN goToKey  IN h-boin00962 (INPUT tt-produt-rural.cdn-produt-rural).
 
        ASSIGN tt-produt-rural.log-livre-1 = TRUE. /* ativar */

        RUN setRecord       IN h-boin00962 (INPUT TABLE tt-produt-rural).
        RUN updateRecord    IN h-boin00962.

    END.

    RUN piConsultarProdutor IN THIS-PROCEDURE (INPUT  rRowidProdut,
                                               OUTPUT iSituacao,
                                               OUTPUT TABLE rowErrors).

    IF iSituacao = 0 OR RETURN-VALUE = "NOK":U THEN /*se não ativou, retorna erro*/
        RETURN "NOK":U.


RETURN "OK":U.

END PROCEDURE.


PROCEDURE piDesativarProdutor PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE rRowidProdut AS ROWID NO-UNDO.

    ASSIGN rRowidProdut = rRowid.

    RUN getBatchRecords IN h-boin00962 (INPUT  rRowid,
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-produt-rural).

    FOR EACH tt-produt-rural:

        RUN goToKey  IN h-boin00962 (INPUT tt-produt-rural.cdn-produt-rural).
 
        ASSIGN tt-produt-rural.log-livre-1 = FALSE. /* desativar */

        RUN setRecord       IN h-boin00962 (INPUT TABLE tt-produt-rural).
        RUN updateRecord    IN h-boin00962.

        /*se desativou o produtor deverá desativar as propriedades deste*/
        IF RETURN-VALUE = "OK":U THEN DO:

            RUN setConstraintProdutor IN h-boin00980 (INPUT tt-produt-rural.cdn-produt-rural).

            RUN openQueryStatic IN h-boin00980 (INPUT "PropriedadeProdutor":U).

            RUN getBatchRecords IN h-boin00980 (INPUT  ?, 
                                                INPUT  NO,
                                                INPUT  0, /* num de resultados a retornar */
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-propried-rural-aux).

            RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).
            
            FOR EACH tt-propried-rural-aux:

                RUN goToKey  IN h-boin00980 (INPUT  tt-propried-rural-aux.cod-propried).
                RUN getRowid IN h-boin00980 (OUTPUT rRowid).
            
                RUN piDesativarPropriedade IN THIS-PROCEDURE (INPUT  rRowid,
                                                              OUTPUT iSituacao,
                                                              OUTPUT TABLE rowErrors).
            
                IF RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
            
            END.

        END.

    END.
    /*********************************************************************/

    RUN piConsultarProdutor IN THIS-PROCEDURE (INPUT  rRowidProdut,
                                               OUTPUT iSituacao,
                                               OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarProdutor PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE produt-rural.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00962 (INPUT rRowid).

    IF RETURN-VALUE = "OK":U THEN DO:

        RUN getLogField IN h-boin00962 (INPUT  "log-livre-1":U,
                                        OUTPUT l-log-livre-1).

    END.

    ASSIGN iSituacao = IF l-log-livre-1 THEN 1 ELSE 0.

RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*############################# P R O C E D U R E S  #  P R O P R I E D A D E ##################################################*/

PROCEDURE piAtivarPropriedade PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN getBatchRecords IN h-boin00980 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-propried-rural).

    FOR EACH tt-propried-rural:

        RUN goToKey IN h-boin00980 (INPUT tt-propried-rural.cod-propried).
 
        ASSIGN tt-propried-rural.log-livre-1 = TRUE. /* ativar */

        RUN emptyRowErrors  IN h-boin00980.
        RUN setRecord       IN h-boin00980 (INPUT TABLE tt-propried-rural).
        RUN updateRecord    IN h-boin00980.

    END.

    RUN piConsultarPropriedade IN THIS-PROCEDURE (INPUT  rRowid,
                                                  OUTPUT iSituacao,
                                                  OUTPUT TABLE rowErrors).

    IF iSituacao = 0 OR RETURN-VALUE = "NOK":U THEN /*se não ativou, retorna erro*/
        RETURN "NOK":U.



RETURN "OK":U.

END PROCEDURE.


PROCEDURE piDesativarPropriedade PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE rRowidPropr AS ROWID NO-UNDO.

    ASSIGN rRowidPropr = rRowid.

    RUN getBatchRecords IN h-boin00980 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-propried-rural).

    RUN emptyRowErrors  IN h-boin00980.

    FOR EACH tt-propried-rural:

        RUN goToKey IN h-boin00980 (INPUT tt-propried-rural.cod-propried).
 
        ASSIGN tt-propried-rural.log-livre-1 = FALSE. /* desativar */

        RUN setRecord       IN h-boin00980 (INPUT TABLE tt-propried-rural).
        RUN updateRecord    IN h-boin00980.

    END.

    /*se desativou a propriedade deverá desativar os pontoDeColeta desta*/
    IF RETURN-VALUE = "OK":U THEN DO:

        FOR FIRST tt-propried-rural:

            RUN setConstraintPtoPropriedade IN h-boin00966 (INPUT tt-propried-rural.cod-propried).
            
            RUN openQueryStatic IN h-boin00966 (INPUT "PtoPropriedade":U).
            
            RUN getBatchRecords IN h-boin00966 (INPUT  ?, 
                                                INPUT  NO,
                                                INPUT  0, /* num de resultados a retornar */
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-pto-coleta-aux).

            RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

            FOR EACH tt-pto-coleta-aux:

                RUN goToKey  IN h-boin00966 (INPUT  tt-pto-coleta-aux.cod-pto-coleta).
                RUN getRowid IN h-boin00966 (OUTPUT rRowid).

                RUN piDesativarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                                OUTPUT iSituacao,
                                                                OUTPUT TABLE rowErrors).

                IF RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.

            END.

        END.

    END.
    /*********************************************************************/

    RUN piConsultarPropriedade IN THIS-PROCEDURE (INPUT  rRowidPropr,
                                                  OUTPUT iSituacao,
                                                  OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarPropriedade PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE propried-rural.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00980 (INPUT rRowid).

    IF RETURN-VALUE = "OK":U THEN DO:

        RUN getLogField IN h-boin00980 (INPUT  "log-livre-1":U,
                                        OUTPUT l-log-livre-1).

    END.

    ASSIGN iSituacao = IF l-log-livre-1 THEN 1 ELSE 0.


RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*############################# P R O C E D U R E S  #  P O N T O  #  D E  #  C O L E T A ######################################*/

PROCEDURE piAtivarPontoDeColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN getBatchRecords IN h-boin00966 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-pto-coleta).

    FOR EACH tt-pto-coleta:
   
        RUN goToKey IN h-boin00966 (INPUT tt-pto-coleta.cod-pto-coleta).
 
        ASSIGN tt-pto-coleta.log-livre-1 = TRUE. /* ativar */

        RUN emptyRowErrors  IN h-boin00966.
        RUN setRecord       IN h-boin00966 (INPUT TABLE tt-pto-coleta).
        RUN updateRecord    IN h-boin00966.

    END.

    RUN piConsultarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                    OUTPUT iSituacao,
                                                    OUTPUT TABLE rowErrors).

    IF iSituacao = 0 OR RETURN-VALUE = "NOK":U THEN /*se não ativou, retorna erro*/
        RETURN "NOK":U.


RETURN "OK":U.

END PROCEDURE.


PROCEDURE piDesativarPontoDeColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE rRowidPtoColeta AS ROWID NO-UNDO.

    ASSIGN rRowidPtoColeta = rRowid.

    RUN getBatchRecords IN h-boin00966 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-pto-coleta).

    RUN emptyRowErrors  IN h-boin00966.

    FOR EACH tt-pto-coleta:

        RUN goToKey IN h-boin00966 (INPUT tt-pto-coleta.cod-pto-coleta).
 
        ASSIGN tt-pto-coleta.log-livre-1 = FALSE. /* desativar */

        RUN setRecord       IN h-boin00966 (INPUT TABLE tt-pto-coleta).
        RUN updateRecord    IN h-boin00966.

    END.

    /*se desativou o pontoDeColeta deverá desativar os relacionamentos produt-pto-coleta e os repositórios do ponto de coleta*/
    IF RETURN-VALUE = "OK":U THEN DO:

        FOR FIRST tt-pto-coleta:

            /*relacionamentos produt-pto-coleta*/
            RUN setConstraintPtoColPropried IN h-boin00990 (INPUT tt-pto-coleta.cod-pto-coleta).

            RUN openQueryPtoColPropried IN h-boin00990 (OUTPUT TABLE tt-produt-pto-coleta-aux).

            FOR EACH tt-produt-pto-coleta-aux:

                RUN goToKey  IN h-boin00990 (INPUT tt-produt-pto-coleta-aux.cdn-produt-rural,
                                             INPUT tt-produt-pto-coleta-aux.cod-pto-coleta,
                                             INPUT tt-produt-pto-coleta-aux.cod-propried).

                RUN getRowid IN h-boin00990 (OUTPUT rRowid).

                RUN piDesativarProdutPtoColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                                  OUTPUT iSituacao,
                                                                  OUTPUT TABLE rowErrors).

                IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.

                 /*retirar o ponto de coleta das rotas que este fazia parte*/
                RUN setConstraintPtoColeta IN h-boin00976 (INPUT tt-produt-pto-coleta-aux.cod-pto-coleta).
        
                RUN openQueryStatic IN h-boin00976 (INPUT "PtoColeta":U).
                
                RUN getBatchRecords IN h-boin00976 (INPUT  ?, 
                                                    INPUT  NO,
                                                    INPUT  0, /* num de resultados a retornar */
                                                    OUTPUT iRowsReturned,
                                                    OUTPUT TABLE tt-pto-rota-coleta-aux).
        
                RUN openQueryStatic IN h-boin00976 (INPUT "Main":U).
        
                FOR EACH tt-pto-rota-coleta-aux:
        
                    RUN goToKey  IN h-boin00976 (INPUT  tt-pto-rota-coleta-aux.cod-rota,
                                                        tt-pto-rota-coleta-aux.cod-pto-coleta,
                                                        tt-pto-rota-coleta-aux.cdn-seq).
        
                    RUN getRowid IN h-boin00976 (OUTPUT rRowid).
        
                    RUN piDesativarPtoRotaColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                                    OUTPUT iSituacao,
                                                                    OUTPUT TABLE rowErrors).
        
                    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN
                        RETURN "NOK":U.
                
                END.

                /**********************************************************/

            END.
            /**********************************/


            /*repositorios do ponto de coleta*/
            RUN setConstraintPtoColCodigo IN h-boin00984 (INPUT tt-pto-coleta.cod-pto-coleta,
                                                          INPUT 0, 
                                                          INPUT 999999).
            
            RUN openQueryStatic IN h-boin00984 (INPUT "ReposPtoCol":U).

            RUN getBatchRecords IN h-boin00984 (INPUT  ?, 
                                                INPUT  NO,
                                                INPUT  0, /* num de resultados a retornar */
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-reposit-aux).

            RUN openQueryStatic IN h-boin00984 (INPUT "Main":U).

            FOR EACH tt-reposit-aux:

                RUN goToKey  IN h-boin00984 (INPUT  tt-reposit-aux.cdn-repos,
                                             INPUT  tt-reposit-aux.cod-pto-coleta).
                RUN getRowid IN h-boin00984 (OUTPUT rRowid).

                RUN piDesativarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                              OUTPUT iSituacao,
                                                              OUTPUT TABLE rowErrors).

                IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
            
            END.
            /********************************/

        END.

    END.
    /*********************************************************************/


    RUN piConsultarPontoDeColeta IN THIS-PROCEDURE (INPUT  rRowidPtoColeta,
                                                    OUTPUT iSituacao,
                                                    OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarPontoDeColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE pto-coleta.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00966 (INPUT rRowid).

    IF RETURN-VALUE = "OK":U THEN DO:

        RUN getLogField IN h-boin00966 (INPUT  "log-livre-1":U,
                                        OUTPUT l-log-livre-1).

    END.

    ASSIGN iSituacao = IF l-log-livre-1 THEN 1 ELSE 0.

RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*################################################# R E P O S I T O R I O  ####################################################*/

PROCEDURE piAtivarRepositorio PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN getBatchRecords IN h-boin00984 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-reposit).

    FOR EACH tt-reposit:
   
        RUN goToKey IN h-boin00984 (INPUT tt-reposit.cdn-repos,
                                    INPUT tt-reposit.cod-pto-coleta).
 
        ASSIGN tt-reposit.log-livre-1 = TRUE. /* ativar */

        RUN emptyRowErrors  IN h-boin00984.
        RUN setRecord       IN h-boin00984 (INPUT TABLE tt-reposit).
        RUN updateRecord    IN h-boin00984.

    END.

    RUN piConsultarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                  OUTPUT iSituacao,
                                                  OUTPUT TABLE rowErrors).

    IF iSituacao = 0 OR RETURN-VALUE = "NOK":U THEN /*se não ativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piDesativarRepositorio PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN getBatchRecords IN h-boin00984 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-reposit).

    FOR EACH tt-reposit:

        RUN goToKey IN h-boin00984 (INPUT tt-reposit.cdn-repos,
                                    INPUT tt-reposit.cod-pto-coleta).
 
        ASSIGN tt-reposit.log-livre-1 = FALSE. /* desativar */

        RUN emptyRowErrors  IN h-boin00984.
        RUN setRecord       IN h-boin00984 (INPUT TABLE tt-reposit).
        RUN updateRecord    IN h-boin00984.

    END.

    RUN piConsultarRepositorio IN THIS-PROCEDURE (INPUT  rRowid,
                                                  OUTPUT iSituacao,
                                                  OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarRepositorio PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE reposit.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00984 (INPUT rRowid).

    IF RETURN-VALUE = "OK":U THEN DO:

        RUN getLogField IN h-boin00984 (INPUT  "log-livre-1":U,
                                        OUTPUT l-log-livre-1).

    END.

    ASSIGN iSituacao = IF l-log-livre-1 THEN 1 ELSE 0.

RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*################################### R E L # P R O D U T O R # P T O C O L E T A  #############################################*/


PROCEDURE piDesativarProdutPtoColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE rRowidProdutPtoColeta AS ROWID NO-UNDO.

    ASSIGN rRowidProdutPtoColeta = rRowid.

    RUN getBatchRecords IN h-boin00990 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-produt-pto-coleta).

    FOR EACH tt-produt-pto-coleta:

        RUN goToKey IN h-boin00990 (INPUT tt-produt-pto-coleta.cdn-produt-rural,
                                    INPUT tt-produt-pto-coleta.cod-pto-coleta,
                                    INPUT tt-produt-pto-coleta.cod-propried).

        ASSIGN tt-produt-pto-coleta.log-livre-1 = FALSE. /* desativar */

        RUN emptyRowErrors  IN h-boin00990.
        RUN setRecord       IN h-boin00990 (INPUT TABLE tt-produt-pto-coleta).
        RUN updateRecord    IN h-boin00990.

       

    END.


    RUN piConsultarProdutPtoColeta IN THIS-PROCEDURE (INPUT  rRowidProdutPtoColeta,
                                                      OUTPUT iSituacao,
                                                      OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarProdutPtoColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE produt-pto-coleta.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00990 (INPUT rRowid).

    IF RETURN-VALUE = "OK":U THEN DO:

        RUN getLogField IN h-boin00990 (INPUT  "log-livre-1":U,
                                        OUTPUT l-log-livre-1).

    END.

    ASSIGN iSituacao = IF l-log-livre-1 THEN 1 ELSE 0.

RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*####################################### R O T A # P O N T O # D E # C O L E T A  #############################################*/


PROCEDURE piDesativarPtoRotaColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    RUN getBatchRecords IN h-boin00976 (INPUT  rRowid, 
                                        INPUT  NO,
                                        INPUT  1, /* num de resultados a retornar */
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-pto-rota-coleta).

    FOR EACH tt-pto-rota-coleta:

        RUN goToKey IN h-boin00976 (INPUT tt-pto-rota-coleta.cod-rota,
                                    INPUT tt-pto-rota-coleta.cod-pto-coleta,
                                    INPUT tt-pto-rota-coleta.cdn-seq).
 
        ASSIGN tt-pto-rota-coleta.log-livre-1 = FALSE. /* desativar */

        RUN emptyRowErrors  IN h-boin00976.
        RUN setRecord       IN h-boin00976 (INPUT TABLE tt-pto-rota-coleta).
        RUN deleteRecord    IN h-boin00976.

    END.

    RUN piConsultarPtoRotaColeta IN THIS-PROCEDURE (INPUT  rRowid,
                                                    OUTPUT iSituacao,
                                                    OUTPUT TABLE rowErrors).

    IF iSituacao = 1 OR RETURN-VALUE = "NOK":U THEN /*se não desativou, retorna erro*/
        RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piConsultarPtoRotaColeta PRIVATE:

    DEFINE INPUT  PARAMETER rRowid      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER iSituacao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-log-livre-1 LIKE produt-pto-coleta.log-livre-1 NO-UNDO.

    RUN repositionRecord IN h-boin00976 (INPUT rRowid).

    ASSIGN iSituacao = IF RETURN-VALUE = "OK":U THEN 1 ELSE 0.

RETURN "OK":U.

END PROCEDURE.

/*##############################################################################################################################*/


/*##############################################################################################################################*/
