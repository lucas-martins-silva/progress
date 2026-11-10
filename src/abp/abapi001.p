&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

USING com.totvs.datasul.eai.*.
USING com.totvs.datasul.manufacture.mab.*.

{include/i-prgvrs.i ABAPI001 2.00.00.037 } /*** "010037" 16/05/2025 17:37:32 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi001 MAB}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: ABAPI001.p
**
**       DATA....: Julho de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Atualizaá∆o de Apontamentos de Abastecimento / Lubrificaá∆o
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/** Temp Tables **/
{abp/abapi001.i}  /** Definiá∆o de Temp-Tables tt-param ttDocLib **/
{abp/abapi001.i1} /** Definiá∆o de temp-Tables ttEqpto ttDoc **/
{abp/abapi003.i}  /** Definiá∆o da ttDocumento **/
{frbo/bofr060.i ttKM} /** Definiá∆o da Temp-Table de kilometragem **/
{include/i-epc200.i "abapi001"} /** Definiá∆o da temp-table padr∆o usada para EPCs **/
{pnp/pnapi002.i tt-param-aux} /**Definiá∆o da Temp-Table tt-param-aux para integrar com a pnapi002**/


/****************  EAI 2.00  ************************************/
DEFINE VARIABLE oRefuelingAdapter   AS com.totvs.datasul.manufacture.mab.RefuelingAdapter NO-UNDO.
DEFINE VARIABLE oResponseMessage    AS ResponseMessage                                    NO-UNDO.
DEFINE VARIABLE cMode               AS CHARACTER INITIAL "Sync"                           NO-UNDO.
DEFINE VARIABLE iIntegrationEnabled AS INTEGER                                            NO-UNDO.
DEFINE VARIABLE cIntegrationRoutes  AS CHARACTER                                          NO-UNDO.
DEFINE VARIABLE lEnabledAndRouted   AS LOGICAL                                            NO-UNDO.
DEFINE VARIABLE i-err-nav           AS INTEGER                                            NO-UNDO.
DEFINE VARIABLE hShowMsg            AS HANDLE                                             NO-UNDO.
DEFINE VARIABLE c-num-docto         AS CHARACTER                                          NO-UNDO.
/****************  EAI 2.00  *** FIM   **************************/

/*variavel global e temp-table usados para a integraá∆o EAI*/
DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.

/* Carrega a vari·vel global v_log_eai2_ativado */
RUN cdp/cd0101i.p.

{frbo/bofr055.i tt-mab-abastec-lubrific-eai}

/** Par≥metros **/
define input  parameter table for tt-param.
define output parameter table for RowErrors.
define output parameter table for ttDocLib.

DEFINE VARIABLE param25 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
DEFINE VARIABLE param26 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
DEFINE VARIABLE param49 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
define variable iErro as integer no-undo.

/** Variˇveis Locais **/
define variable hDBOApont           as handle    no-undo.
define variable deAceitacao         as decimal   no-undo.
define variable cTexto              as character no-undo.
define variable lPrimario           as logical   no-undo.

/** Indica que passou pela procedure piAtualizaDocumento,
    necess†rio para as validaá‰es do Contador Secund†rio **/
DEFINE VARIABLE lAtualizaDocumento  AS LOGICAL INITIAL NO NO-UNDO. 

/*variavel global e temp-table usados para a integraá∆o EAI*/
DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

define temp-table RowErrorsAux no-undo like RowErrors.

define new global shared variable c-seg-usuario as character no-undo.
/*DEFINE VARIABLE c-nom-prog-upc  AS CHARACTER NO-UNDO.*/

DEFINE VARIABLE iContOrig   AS INTEGER NO-UNDO.
DEFINE VARIABLE cProgOrigem AS CHARACTER NO-UNDO.
ASSIGN cProgOrigem = "".
DO  iContOrig = 1 TO 15:
    IF  PROGRAM-NAME(iContOrig) MATCHES "*ab0401*":U THEN
        ASSIGN cProgOrigem = "AB0401":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.67
         WIDTH              = 35.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Inicia a API **/
run piInicializacao in this-procedure.

{abp/abapi001.i2} /** Criaá∆o de Erros **/
{abp/abapi001.i3} /** Atualizaá∆o Kilometragem **/
{abp/abapi001.i4} /** Atualizaá∆o Movimento de Eventos **/
{abp/ab9000.i}    /** Convers∆o de horas **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-finalizaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalizaHandle Procedure 
PROCEDURE finalizaHandle :
/*------------------------------------------------------------------------------
  Purpose:     finalizaHandle
  Parameters:  <none>
  Notes:       Elimina Handles da mem¢ria
------------------------------------------------------------------------------*/
/** Apontamento **/
if valid-handle(hDBOApont) then
    run destroy in hDBOApont.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeHandle Procedure 
PROCEDURE initializeHandle :
/*------------------------------------------------------------------------------
  Purpose:     initializeHandle
  Parameters:  <none>
  Notes:       Inicializa os handles no programa
------------------------------------------------------------------------------*/
    /*--- BO Apontamento ---*/
    IF NOT VALID-HANDLE(hDBOApont) OR
       hDBOApont:TYPE <> "PROCEDURE":U OR
       hDBOApont:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOApont.
    END.
    RUN openQueryMain IN hDBOApont NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaDocumento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDocumento Procedure 
PROCEDURE piAtualizaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaDocumento
  Parameters:  entrada pStatus = N£mero do Status da ficha
  Notes:       Status de como ficarˇ o documento do apontamento abastecimento.
------------------------------------------------------------------------------*/
define input parameter pStatus as integer no-undo.
DEFINE VARIABLE cLocalXmlGerado AS CHARACTER FORMAT "x(200)" NO-UNDO.
define buffer bfApont for mab-abastec-lubrific.

/** Busca Apontamento corrente **/
for first bfApont
    where rowid(bfApont) = rowid(mab-abastec-lubrific) exclusive-lock:
     empty temp-table tt-mab-abastec-lubrific-eai no-error.
    /** Atualiza consistància conforme par∆metro passado **/
    assign bfApont.idi-consist   = pStatus
           bfApont.log-consist   = if pStatus > 20 
                                   then yes
                                   else no
           bfApont.val-km-percur = ttEqpto.uso-real.
    IF ttEqpto.log-cont-sec THEN
        ASSIGN bfApont.val-livre-1 = IF ttEqpto.uso-real-sec < 0 THEN 0 ELSE ttEqpto.uso-real-sec.
    /** Cria temp-table ttDocumento **/
    if bfApont.log-consist then do:
        if not can-find(first ttDocumento
                        where ttDocumento.r-rowid = rowid(bfApont) no-lock) then do:
            create ttDocumento.
            buffer-copy bfApont to ttDocumento
            assign ttDocumento.r-rowid  = rowid(bfApont)
                   ttDocumento.i-origem = 1.
        end.
        ELSE DO:
            FOR first ttDocumento
                        where ttDocumento.r-rowid = rowid(bfApont) EXCLUSIVE-LOCK:
                 buffer-copy bfApont to ttDocumento
                 assign ttDocumento.r-rowid  = rowid(bfApont)
                        ttDocumento.i-origem = 1.
            END.
        END.
    end.
    /** Baixas dos movimentos de eventos **/
    run piBaixaMovtoEvento in this-procedure (input bfApont.num-docto,
                                              input bfApont.dat-movto,
                                              input bfApont.hra-inicial,
                                              input bfApont.hra-final,
                                              input bfApont.log-consist). /** Conclus∆o do Movimento **/

    /** Atualiza data e usu†rio de alteraá∆o **/
    assign bfApont.dat-livre-2 = today.
    assign overlay (bfApont.cod-livre-1,1,12) = c-seg-usuario.

    /* Chama adapter de integraá∆o EAI */
    FOR EACH tt-mab-abastec-lubrific-eai EXCLUSIVE-LOCK:
        DELETE tt-mab-abastec-lubrific-eai NO-ERROR. 
    END.
    BUFFER-COPY bfApont TO tt-mab-abastec-lubrific-eai.

    RUN piCallUpsertAdapter IN THIS-PROCEDURE (INPUT bfApont.num-docto).

    RUN sendMessageEAI (INPUT TABLE tt-mab-abastec-lubrific-eai).
    
    {utp/ut-liter.i Sim}
    for first mab-param-integr
        where mab-param-integr.cdn-param = 10
          and trim(entry(4,mab-param-integr.des-valor)) = trim(return-value) no-lock:
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.cod-eqpto = tt-mab-abastec-lubrific-eai.cod-eqpto 
            AND   mab-eqpto.ep-codigo = tt-mab-abastec-lubrific-eai.ep-codigo NO-LOCK:
            IF  mab-eqpto.log-livre-1 THEN DO:
                IF  tt-mab-abastec-lubrific-eai.log-consist  THEN DO:
                    run adapters/xml/mn2/axsmf014.p (input table tt-mab-abastec-lubrific-eai,
                                                     input "UPD":U,
                                                     OUTPUT cLocalXmlGerado).
                END.
            END.
        END.
    END.
end. /*for first bfApont*/


/************************************************************************************
** S¢ atualiza ficha se todos os itens estiverem integrados
************************************************************************************/
/********************************************************************************************/
    /** Busca Posto de Abastecimento **/
    DEFINE VARIABLE l-atualiza   AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-n-atualiza AS LOGICAL INITIAL NO NO-UNDO.

    for first mab-posto
        where mab-posto.cod-posto = mab-abastec-lubrific.cod-posto no-lock:
    END.
    IF AVAIL mab-posto then do:
        /** Se Posto for pr¢prio, baixa estoque **/
        if mab-posto.idi-posto    = 1 then do:
            /** Busca Apontamentos de Lubrificaªío **/
            for each  mab-item-lubrific
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
                /** Tipo de Material deve estar integrando com o estoque conforme a data do documento **/
                for first mab-tip-mater
                    where mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater no-lock:
                    /****************************************
                    ** Caso n∆o tenha sido integrado, n∆o integra a ficha
                    *****************************************/						
                    IF  mab-tip-mater.log-integr THEN DO:
                        IF mab-tip-mater.dat-livre-1 <= mab-abastec-lubrific.dat-movto THEN DO:
                            IF mab-item-lubrific.nr-trans = 0 THEN DO:
                                ASSIGN l-n-atualiza = YES.
                            END.								
                            ELSE DO:
                                ASSIGN l-atualiza = YES.
                            END.								
                        END.
                    END.														
                end.
            end.
        end.
        /** Busca Apontamentos de Abastecimento **/
        for each mab-item-abastec
            where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
            /** Busca Posto do Abastecimento **/
            if mab-posto.cod-posto <> mab-item-abastec.cod-posto then do:
                for first mab-posto
                    where mab-posto.cod-posto = mab-item-abastec.cod-posto no-lock:
                END.
            END.
            /** Verifica se posto Ç pr¢prio **/
            if avail mab-posto and mab-posto.idi-posto = 1 then do:
                /** Tipo de Material deve estar integrando com o estoque conforme a data do documento **/
                for first mab-tip-mater
                    where mab-tip-mater.cod-tip-mater = mab-item-abastec.cod-tip-mater no-lock:
                    /****************************************
                    ** Caso n∆o tenha sido integrado, n∆o integra a ficha
                    *****************************************/
                    IF  mab-tip-mater.log-integr THEN DO:
                        IF mab-tip-mater.dat-livre-1 <= mab-abastec-lubrific.dat-movto THEN DO:
                            IF mab-item-abastec.nr-trans = 0 THEN DO:
                                ASSIGN l-n-atualiza = YES.
                            END.
                            ELSE DO:
                                ASSIGN l-atualiza = YES.
                            END.
                        END.
                    END.								
                end.
            end.
        end.
    end.
    /** Verifica se est† tudo integrado para integrar a ficha **/
    IF NOT l-n-atualiza AND l-atualiza = YES THEN DO:
        /* 1  N∆o integrada
           2  Integrada */
        FIND CURRENT mab-abastec-lubrific EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL mab-abastec-lubrific
        THEN DO:
            ASSIGN mab-abastec-lubrific.idi-integr = 2.
        END.
        FIND CURRENT mab-abastec-lubrific NO-LOCK NO-ERROR.
    end.
/********************************************************************************************/

/** Atualiza Kilometragem (abapi001.i3) **/
run piKilometragem in this-procedure (input mab-abastec-lubrific.num-docto,
                                      input pStatus,               /** Status do Apontamento **/
                                      input 1,                     /** Origem = Abastecimento **/
                                      input ttEqpto.log-primario). /** Abastecimento Primˇrio **/

/** Indica que passou pela procedure piAtualizaDocumento,
    necess†rio para as validaá‰es do Contador Secund†rio **/
ASSIGN lAtualizaDocumento = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaPneus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaPneus Procedure 
PROCEDURE piAtualizaPneus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Ap¢s ficha OK, atualiza a durabilidade do pneu*/
FIND FIRST mab-abastec-lubrific
     WHERE mab-abastec-lubrific.num-docto = ttDocumento.num-docto 
       AND mab-abastec-lubrific.idi-consist > 20 NO-LOCK NO-ERROR.

IF AVAIL mab-abastec-lubrific THEN DO:
    /*cdn-param = 25: Atualiza Apontamento de Pneu OnLine. */
    /*cdn-param = 26: Atualiza durabilidade do Pneu OnLine.*/
    /*cdn-param = 49: C†lcula Durabilidade Pneus.          */
    FOR EACH mab-param FIELDS (des-valor cdn-param)
       WHERE mab-param.cdn-param = 25 
          OR mab-param.cdn-param = 26  
          OR mab-param.cdn-param = 49  NO-LOCK:

        CASE mab-param.cdn-param:
            WHEN 25 THEN
                ASSIGN param25 = mab-param.des-valor. 
            WHEN 26 THEN
                ASSIGN param26 = mab-param.des-valor. 
            WHEN 49 THEN
                ASSIGN param49 = mab-param.des-valor. 
        END CASE.
    END.
         
    IF param25 = "1" AND param26 = "1" AND param49 = "1" THEN DO:
        
        FOR EACH  mgf-eqpto-implto FIELDS (ep-codigo-implto cod-implto)
            WHERE mgf-eqpto-implto.ep-codigo-eqpto >= tt-param.iEmpIni  
              AND mgf-eqpto-implto.ep-codigo-eqpto <= tt-param.iEmpFim  
              AND mgf-eqpto-implto.cod-eqpto       >= tt-param.cEqptoIni
              AND mgf-eqpto-implto.cod-eqpto       <= tt-param.cEqptoFim
              AND mgf-eqpto-implto.dat-inicial     >= tt-param.dataIni
              AND mgf-eqpto-implto.dat-inicial     <= tt-param.dataFim
              AND mgf-eqpto-implto.dat-final       >= tt-param.dataIni
              AND mgf-eqpto-implto.dat-final       <= tt-param.dataFim NO-LOCK:

            EMPTY TEMP-TABLE tt-param-aux.
            /*Criaá∆o da tt-param que ser† enviada para a pnapi002. Esta temp-table ser† criada para cada */    
            /*pneu atual do equipamento                                                                   */

            CREATE tt-param-aux.
            ASSIGN tt-param-aux.destino   = tt-param.destino
                   tt-param-aux.arquivo   = tt-param.arquivo 
                   tt-param-aux.usuario   = tt-param.usuario    
                   tt-param-aux.data-exec = tt-param.data-exec  
                   tt-param-aux.hora-exec = tt-param.hora-exec  
                   tt-param-aux.empIni    = mgf-eqpto-implto.ep-codigo-implto
                   tt-param-aux.empFim    = mgf-eqpto-implto.ep-codigo-implto
                   tt-param-aux.eqptoIni  = mgf-eqpto-implto.cod-implto
                   tt-param-aux.eqptoFim  = mgf-eqpto-implto.cod-implto
                   tt-param-aux.estabIni  = tt-param.cEstabIni
                   tt-param-aux.estabFim  = tt-param.cEstabFim
                   tt-param-aux.pneuIni   = "":U
                   tt-param-aux.pneuFim   = "ZZZZZZZZZZZZ":U
                   tt-param-aux.tag-ini   = tt-param.cTagIni 
                   tt-param-aux.tag-fim   = tt-param.cTagFim 
                   tt-param-aux.cc-ini    = tt-param.cCCini 
                   tt-param-aux.cc-fim    = tt-param.cCCfim 
                   tt-param-aux.dataIni   = (TODAY - 30)
                   tt-param-aux.numDias   = 30 
                   tt-param-aux.rRowid    = ?.
            
            /** Roda API geraá∆o KM **/
            RUN pnp/pnapi002.p (INPUT  TABLE tt-param-aux,
                                OUTPUT TABLE RowErrorsAux).

            /** Verifica se ocorreram erros **/
            IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                FOR LAST RowErrors NO-LOCK:
                    ASSIGN iErro = RowErrors.ErrorSequence.
                END.
            END.
            ELSE 
                ASSIGN iErro = 0.
            FOR EACH RowErrorsAux NO-LOCK:
                ASSIGN iErro = iErro + 1.
                CREATE RowErrors.
                BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
                    ASSIGN RowErrors.ErrorSequence = iErro.
            END.
        END.
        
        IF NOT CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
        
            FOR EACH mpn-pneu FIELDS(cod-eqpto-inicial cod-eqpto-atual ep-codigo-atual cod-pneu)
               WHERE mpn-pneu.ep-codigo-atual   >= tt-param.iEmpIni
                 AND mpn-pneu.ep-codigo-atual   <= tt-param.iEmpFim
                 AND mpn-pneu.cod-eqpto-atual   >= tt-param.cEqptoIni
                 AND mpn-pneu.cod-eqpto-atual   <= tt-param.cEqptoFim
                 AND mpn-pneu.cod-estabel-atual >= tt-param.cEstabIni
                 AND mpn-pneu.cod-estabel-atual <= tt-param.cEstabFim NO-LOCK:
    
                EMPTY TEMP-TABLE tt-param-aux.
                /*Criaá∆o da tt-param que ser† enviada para a pnapi002. Esta temp-table ser† criada para cada */    
                /*pneu atual do equipamento                                                                   */
                CREATE tt-param-aux.
                ASSIGN tt-param-aux.destino   = tt-param.destino
                       tt-param-aux.arquivo   = tt-param.arquivo 
                       tt-param-aux.usuario   = tt-param.usuario    
                       tt-param-aux.data-exec = tt-param.data-exec  
                       tt-param-aux.hora-exec = tt-param.hora-exec  
                       tt-param-aux.empIni    = tt-param.iEmpIni  
                       tt-param-aux.empFim    = tt-param.iEmpFim  
                       tt-param-aux.eqptoIni  = tt-param.cEqptoIni
                       tt-param-aux.eqptoFim  = tt-param.cEqptoFim
                       tt-param-aux.estabIni  = tt-param.cEstabIni
                       tt-param-aux.estabFim  = tt-param.cEstabFim
                       tt-param-aux.pneuIni   = mpn-pneu.cod-pneu 
                       tt-param-aux.pneuFim   = mpn-pneu.cod-pneu 
                       tt-param-aux.tag-ini   = tt-param.cTagIni 
                       tt-param-aux.tag-fim   = tt-param.cTagFim 
                       tt-param-aux.cc-ini    = tt-param.cCCini 
                       tt-param-aux.cc-fim    = tt-param.cCCfim 
                       tt-param-aux.dataIni   = (TODAY - 30)
                       tt-param-aux.numDias   = 30 
                       tt-param-aux.rRowid    = ?.
                
                /** Roda API geraá∆o KM **/
                RUN pnp/pnapi002.p (INPUT  TABLE tt-param-aux,
                                    OUTPUT TABLE RowErrorsAux).
    
                /** Verifica se ocorreram erros **/
                IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                    FOR LAST RowErrors NO-LOCK:
                        ASSIGN iErro = RowErrors.ErrorSequence.
                    END.
                END.
                ELSE 
                    ASSIGN iErro = 0.
                FOR EACH RowErrorsAux NO-LOCK:
                    ASSIGN iErro = iErro + 1.
                    CREATE RowErrors.
                    BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
                        ASSIGN RowErrors.ErrorSequence = iErro.
                END.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piComConsumo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piComConsumo Procedure 
PROCEDURE piComConsumo :
/*------------------------------------------------------------------------------
  Purpose:     piComConsumo
  Parameters:  <none>
  Notes:       Atualiza Apontamento para equipamentos que s∆o controlados seu 
               consumo.
------------------------------------------------------------------------------*/
DEFINE BUFFER bfApont FOR mab-abastec-lubrific.

DEFINE VARIABLE deDistorcao AS DECIMAL NO-UNDO.

CASE tt-param.tipo-liberacao:

    /** Liberaá∆o Normal - utilizada pelo ab0401 e ab0302 e ab0306 e ab0705 **/
    WHEN 1 THEN DO:

        /** Busca ficha anterior por data para avaliar se a mesma esta consistida  **/
        FOR LAST  bfApont USE-INDEX mbbstclb-04
            WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo 
            AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            AND   bfapont.log-consist          = NO
            AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
        END.
        /** Se encontrou a ficha atualiza o estatus da ficha como n∆o consistida **/
        IF AVAIL bfapont THEN DO:
            /** 9 = ficha anterior n∆o consistida **/
            RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 9).
            RETURN "OK":U.
        END.

        /** Hodìmetro Maior que Èltimo Apontamento **/
        IF ttEqpto.uso-real > 0 THEN DO:
            /** 2 - Km-Hora/Qtd **/
            IF ttEqpto.tp-consumo = 2 THEN DO:
                ASSIGN ttEqpto.consumo-real = ttEqpto.uso-real / ttEqpto.qtd-abast.
            END.
            /** 3 - Qtd/Km-Hora **/
            ELSE DO:
                ASSIGN ttEqpto.consumo-real = ttEqpto.qtd-abast / ttEqpto.uso-real.
            END.

            /** Compara Distorá∆o Maior **/
            IF ttEqpto.consumo-real > ttEqpto.consumo-padrao THEN DO:
                ASSIGN deDistorcao = (ttEqpto.consumo-real - ttEqpto.consumo-padrao) / ttEqpto.consumo-padrao * 100.
                /** Consumo Real Maior que m†ximo permitido **/
                IF deDistorcao > deAceitacao THEN
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 2).
                /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                ELSE IF ttEqpto.log-cont-sec = NO THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                END.
            END.
            ELSE DO:
                /** Compara Distorá∆o Menor **/
                IF ttEqpto.consumo-real < ttEqpto.consumo-padrao THEN DO:
                    ASSIGN deDistorcao = (ttEqpto.consumo-padrao - ttEqpto.consumo-real) / ttEqpto.consumo-padrao * 100.
                    /** Consumo Real Menor que m†ximo permitido **/
                    IF deDistorcao > deAceitacao THEN DO:
                        RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 3).
                    END.
                    /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                    "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                    ELSE IF ttEqpto.log-cont-sec = NO THEN DO:
                        RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                    END.

                END.
                /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                    "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                ELSE IF ttEqpto.log-cont-sec = NO THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                END.
            END.
        END.
        ELSE DO:
            /** Hodìmetro Parado **/
            IF ttEqpto.uso-real = 0 THEN DO:                
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 4).
            END.
            /** Hodìmetro Menor que Anterior (5) **/
            ELSE DO:
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 5).
            END.
        END.
    END.
    /** Liberaá∆o Padr∆o (2) ou Usuˇrio (3) - utilizada pelo ab0402 **/
    OTHERWISE DO:
        RUN piDocLib IN THIS-PROCEDURE.
    END.
END CASE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piComConsumoSec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piComConsumoSec Procedure 
PROCEDURE piComConsumoSec :
/*------------------------------------------------------------------------------
  Purpose:     piComConsumoSec
  Parameters:  <none>
  Notes:       Atualiza Apontamento para equipamentos que s∆o controlados seu 
               Consumo Secund†rio.
------------------------------------------------------------------------------*/
DEFINE VARIABLE deDistorcao AS DECIMAL NO-UNDO.

CASE tt-param.tipo-liberacao:
    /** Liberaá∆o Normal - utilizada pelo ab0401 e ab0302 e ab0306 e ab0705 **/
    WHEN 1 THEN DO:

        /** Se o uso secund†rio estiver maior que zero, calcula o Consumo Secund†rio **/
        IF  ttEqpto.uso-real-sec > 0 THEN DO:
            /** 2 - Km-Hora/Qtd **/
            IF ttEqpto.tp-consumo-sec = 2 THEN DO:
                ASSIGN ttEqpto.consumo-real-sec = ttEqpto.uso-real-sec / ttEqpto.qtd-abast.
            END.
            /** 3 - Qtd/Km-Hora **/
            ELSE DO:
                ASSIGN ttEqpto.consumo-real-sec = ttEqpto.qtd-abast / ttEqpto.uso-real-sec.
            END.
            
            /** Compara Distorá∆o Maior **/
            IF ttEqpto.consumo-real-sec > ttEqpto.consumo-padrao-sec THEN DO:
                ASSIGN deDistorcao = (ttEqpto.consumo-real-sec - ttEqpto.consumo-padrao-sec) / ttEqpto.consumo-padrao-sec * 100.
                /** Consumo Secund†rio Real maior que m†ximo permitido (10) **/
                IF deDistorcao > deAceitacao THEN
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 10).
                /** Apontamento Correto **/
                ELSE
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
            END.
            ELSE DO:
                /** Compara Distorá∆o Menor **/
                IF ttEqpto.consumo-real-sec < ttEqpto.consumo-padrao-sec THEN DO:
                    ASSIGN deDistorcao = (ttEqpto.consumo-padrao-sec - ttEqpto.consumo-real-sec) / ttEqpto.consumo-padrao-sec * 100.
                    /* Consumo Secund†rio Real menor que m°nimo permitido (11) */
                    IF deDistorcao > deAceitacao THEN DO:
                        RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 11).
                    END.
                    /** Apontamento Correto **/
                    ELSE DO:
                        RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                    END.
                END.
                /** Apontamento Correto **/
                ELSE DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                END.
            END.
        END.
        ELSE DO:
            /** Contador Secund†rio Parado (7) **/
            IF ttEqpto.uso-real-sec = 0 THEN DO:
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 7).
            END.
            /** Hodìmetro Menor que Anterior (8) **/
            ELSE DO:
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 8).
            END.
        END.
    END.
    /** Liberaá∆o Padr∆o (2) ou Usuˇrio (3) - utilizada pelo ab0402 **/
    OTHERWISE DO:
        RUN piDocLib IN THIS-PROCEDURE.
    END.
END CASE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piDocLib) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDocLib Procedure 
PROCEDURE piDocLib :
/*------------------------------------------------------------------------------
  Purpose:     piDocLib
  Parameters:  <none>
  Notes:       Cria a Temp-table para ABAPI002
------------------------------------------------------------------------------*/
DEFINE BUFFER bfApont FOR mab-abastec-lubrific.
create ttDocLib.
assign ttDocLib.num-docto          = mab-abastec-lubrific.num-docto
       ttDocLib.consumo-padrao     = ttEqpto.consumo-padrao
       ttDocLib.consumo-padrao-sec = ttEqpto.consumo-padrao-sec
       ttDocLib.consumo-real       = ttEqpto.consumo-real  
       ttDocLib.consumo-real-sec   = ttEqpto.consumo-real-sec /* (Validaá∆o Contador Secundario) */
       ttDocLib.uso-real           = ttEqpto.uso-real
       ttDocLib.uso-real-sec       = ttEqpto.uso-real-sec     /* (Validaá∆o Contador Secundario) */
       ttDocLib.tp-consumo         = ttEqpto.tp-consumo
       ttDocLib.tp-consumo-sec     = ttEqpto.tp-consumo-sec   /* (Validaá∆o Contador Secundario) */
       ttDocLib.qtd-abast          = ttEqpto.qtd-abast
       ttDocLib.r-rowid            = rowid(mab-abastec-lubrific)
       ttDocLib.idi-consist        = mab-abastec-lubrific.idi-consist
       ttDocLib.log-primario       = ttEqpto.log-primario.
FOR first mab-item-abastec 
    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
    and   mab-item-abastec.log-abastec-prim NO-LOCK:
END.
IF  AVAIL mab-item-abastec THEN
    assign ttDocLib.log-abast = yes.
else 
    assign ttDocLib.log-abast = no.

IF tt-param.tipo-liberacao = 3 THEN DO:
    FOR FIRST bfApont
        WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
        AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
        AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
    END.
    IF  AVAIL bfApont THEN DO:
        FOR LAST  bfApont USE-INDEX mbbstclb-04
            WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
            AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:

            /** Uso real foi do apontamento anterior **/
            ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - bfApont.val-hodom-horim.
            
            /** Uso Real Secund†rio foi do apontamento anterior **/
            IF ttEqpto.log-cont-sec THEN
                ASSIGN ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - bfApont.val-hodom-horim-sec.

            /************************************************************************************************************** 
             Quando for equipamento motorizado e ficha atual n∆o for de abastecimento verifica se ficha anterior
             tambÇm n∆o Ç de abastecimento. Se isto ocorrer, o percurso da ficha atual deve receber o precurso da ficha
             anterior mais a diferenáa entre contadores
             Ex:
             Data              Abastecimento (S/N)     Contador    val-km-percur
             01/01/2004              SIM                15.000         15.000 
             02/01/2004              N«O                15.300            300
             03/01/2004              N«O                15.500            500
             04/01/2004              SIM                15.650            650 
            **************************************************************************************************************/
            
            IF ttEqpto.idi-tip-eqpto = 1 THEN DO:
                FOR FIRST mab-item-abastec 
                    WHERE mab-item-abastec.num-docto = bfApont.num-docto
                    AND mab-item-abastec.log-abastec-prim NO-LOCK:
                END.
                IF NOT AVAIL mab-item-abastec THEN DO:
                    ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - bfApont.val-hodom-horim + bfApont.val-km-percur.
                    IF ttEqpto.log-cont-sec THEN
                        ASSIGN ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - bfApont.val-hodom-horim-sec + bfApont.val-livre-1.
                END.
            END.    
        END.
    END.
    ELSE DO:
        /** Compara com hodìmetro inicial do equipamento **/
        ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - ttEqpto.val-hodom-horim-inicial.
    END.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicializacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializacao Procedure 
PROCEDURE piInicializacao :
/*------------------------------------------------------------------------------
  Purpose:     piInicializacao
  Parameters:  <none>
  Notes:       Inicializa a API
------------------------------------------------------------------------------*/

DISABLE TRIGGERS FOR DUMP OF mab-abastec-lubrific.
DISABLE TRIGGERS FOR DUMP OF mab-item-abastec.
DISABLE TRIGGERS FOR DUMP OF mab-histor-ativid.
DISABLE TRIGGERS FOR DUMP OF mab-posto.
DISABLE TRIGGERS FOR DUMP OF estabelec.

/** Inicializaá∆o de BOs **/
run initializeHandle in this-procedure.
find first tt-param no-error.

/** Validaá‰es Iniciais **/
run piValidaInicial in this-procedure.
if return-value <> "NOK":U then do:
    /** Processa AtualizaáÑes **/
    run piProcessaAtualizacao in this-procedure.
end.
/** Elimina Handles da mem¢ria **/
run finalizaHandle in this-procedure.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincial
  Parameters:  <none>
  Notes:       roda o c†lculo principal para chamar as procedures.
------------------------------------------------------------------------------*/
DEFINE BUFFER bfApont FOR mab-abastec-lubrific.

/* Patricia - Esta validaá∆o foi inclu°da, conforme FO 1766.785 da Usina Colombo
o qual era poss°vel consistir fichas, mesmo existindo fichas com datas anteriores
n∆o consistida */
/** Busca ficha anterior por data para avaliar se a mesma esta consistida  **/
FOR LAST  bfApont USE-INDEX mbbstclb-04
    WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo 
    AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
    AND   bfapont.log-consist          = NO
    AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock:
END.
/** Se encontrou a ficha atualiza o estatus da ficha como n∆o consistida **/
IF AVAIL bfapont THEN DO:
    /** 9 = ficha anterior n∆o consistida **/
    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 9).
    RETURN "OK":U.
END.

/** Limpa Equipamento para pr¢ximo c†lculo **/
ASSIGN ttEqpto.consumo-padrao     = 0
       ttEqpto.consumo-padrao-sec = 0
       ttEqpto.consumo-real       = 0
       ttEqpto.consumo-real-sec   = 0  /* (Validaá∆o Contador Secundario) */
       ttEqpto.uso-real           = 0
       ttEqpto.uso-real-sec       = 0  /* (Validaá∆o Contador Secundario) */
       ttEqpto.tp-consumo         = 0 
       ttEqpto.tp-consumo-sec     = 0  /* (Validaá∆o Contador Secundario) */
       ttEqpto.qtd-abast          = 0
       ttEqpto.log-primario       = NO.
IF tt-param.iConsiste = 1 THEN  /** Somente com Problemas **/
    /** Aprovadas s∆o ignoradas (acima de 20) **/
    IF mab-abastec-lubrific.idi-consist > 20 THEN LEAVE.

/** Verifica se Ficha contÇm apontamentos de Abastecimento **/
FOR FIRST mab-item-abastec 
    WHERE mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
    AND   mab-item-abastec.log-abastec-prim NO-LOCK:
END.
IF  AVAIL mab-item-abastec THEN DO:
    /** Somat¢ria dos Abastecimentos **/
    RUN piSomatoria IN THIS-PROCEDURE.
    /** Verifica tipo Controle Consumo Equipamento para
        atualizar o status da consistància das fichas
        de abastecimento **/

    /** Contador Prim†rio **/
    IF ttEqpto.tp-consumo > 1 THEN DO:
        RUN piComConsumo IN THIS-PROCEDURE. /** 2 - Km-Hora/Qtd  e  3 - Qtd/Km-Hora **/
    END.
    ELSE DO:
        RUN piSemConsumo IN THIS-PROCEDURE. /** 1 - Sem Consumo **/
    END.

    /* Faz as validaá‰es do Contador Secund†rio, apenas caso n∆o tenha entrado
       na procedure piAtualizaDocumento, chamado pelas validaá‰es do Contador Prim†rio */
    IF NOT lAtualizaDocumento THEN DO:
        /** Contador Secund†rio **/
        IF ttEqpto.tp-consumo-sec > 1 THEN DO:
            RUN piComConsumoSec IN THIS-PROCEDURE. /** 2 - Km-Hora/Qtd  e  3 - Qtd/Km-Hora **/
        END.
        ELSE DO:
            RUN piSemConsumoSec IN THIS-PROCEDURE. /** 1 - Sem Consumo **/
        END.
    END.

    /** "Zera" variavel, pois o controle Ç por ficha de abastecimento. 
        Ex: Existem casos onde a ficha anterior da atual esta correta, entao 
        'lAtualizaDocumento' ja esta como YES, sendo assim n∆o valida Contador Sec. **/
    ASSIGN lAtualizaDocumento = NO.
END.
/** Sem Apontamentos de Abastecimento **/
ELSE DO:
    RUN piSemConsumo IN THIS-PROCEDURE.

    /* Faz as validaá‰es do Contador Secund†rio, apenas caso n∆o tenha entrado
       na procedure piAtualizaDocumento, chamado pelas validaá‰es do Contador Prim†rio */
    IF NOT lAtualizaDocumento THEN DO:
        RUN piSemConsumoSec IN THIS-PROCEDURE.
    END.

    /** "Zera" variavel, pois o controle Ç por ficha de abastecimento. 
        Ex: Existem casos onde a ficha anterior da atual esta correta, entao 
        'lAtualizaDocumento' ja esta como YES, sendo assim n∆o valida Contador Sec. **/
    ASSIGN lAtualizaDocumento = NO.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessaAtualizacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessaAtualizacao Procedure 
PROCEDURE piProcessaAtualizacao :
/*------------------------------------------------------------------------------
  Purpose:     piProcessaAtualizacao
  Parameters:  <none>
  Notes:       Processa as atualizaá‰es dos apontamentos de abastecimento e 
               lubrificaá∆o
------------------------------------------------------------------------------*/
define variable dataAux  as date    no-undo.
define variable dataIni  as date    no-undo.
define variable deAuxIni as decimal no-undo.
define variable deAuxFim as decimal no-undo.

/** Busca os equipamentos que dever∆o ser atualizados **/
for each  mab-eqpto
    where mab-eqpto.ep-codigo >= tt-param.iEmpIni
    and   mab-eqpto.ep-codigo <= tt-param.iEmpFim
    and   mab-eqpto.cod-eqpto >= tt-param.cEqptoIni
    and   mab-eqpto.cod-eqpto <= tt-param.cEqptoFim no-lock:

    /** Somente Equipamentos Motorizados **/
    /** Busca os Èltimos Estabelecimento e TAG do equipamento no per°odo informado **/
    for last  mab-histor-ativid
        where mab-histor-ativid.ep-codigo     = mab-eqpto.ep-codigo
        and   mab-histor-ativid.cod-eqpto     = mab-eqpto.cod-eqpto 
        and   mab-histor-ativid.dat-cadastro <= tt-param.dataFim NO-LOCK:

        /* Esses campos ser∆o filtrados na tabela 'mab-abastec-lubrific'
        IF mab-histor-ativid.cod-estabel < tt-param.cEstabIni OR mab-histor-ativid.cod-estabel > tt-param.cEstabFim THEN NEXT.        
        IF mab-histor-ativid.cc-codigo < tt-param.cCCini    OR mab-histor-ativid.cc-codigo > tt-param.cCCfim    THEN NEXT.
        */
        IF mab-histor-ativid.cd-tag    < tt-param.cTagIni   OR mab-histor-ativid.cd-tag    > tt-param.cTagFim   THEN NEXT.        

        /* Correá∆o - Transformando Ponto UPC em EPC */
        for each  tt-epc where tt-epc.cod-event = "READ-EQPTO":U exclusive-lock:
            delete tt-epc.
        end.
        create tt-epc.
        assign tt-epc.cod-event     = "READ-EQPTO":U
               tt-epc.cod-parameter = "p-ind-object":U
               tt-epc.val-parameter = "ABAPI001":U.
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "READ-EQPTO":U
               tt-epc.cod-parameter = "p-wgh-object":U
               tt-epc.val-parameter = STRING(THIS-PROCEDURE:HANDLE).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "READ-EQPTO":U
               tt-epc.cod-parameter = "p-wgh-frame":U
               tt-epc.val-parameter = "?":U.
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "READ-EQPTO":U
               tt-epc.cod-parameter = "p-cod-table":U
               tt-epc.val-parameter = "mab-eqpto":U.
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "READ-EQPTO":U
               tt-epc.cod-parameter = "p-row-table":U
               tt-epc.val-parameter = STRING(ROWID(mab-eqpto)).

        {include/i-epc201.i "READ-EQPTO"}

        IF RETURN-VALUE <> "NOK" THEN DO:
            create ttEqpto.
            buffer-copy mab-eqpto to ttEqpto
            assign  ttEqpto.cod-estabel = mab-histor-ativid.cod-estabel
                    ttEqpto.cd-tag    = mab-histor-ativid.cd-tag
                    ttEqpto.r-rowid   = rowid(mab-eqpto).
        END.
    end.
end.

/** Busca % de Aceitaá∆o na diferenáa de Consumo de combust°vel **/
for first mab-param
    where mab-param.cdn-param = 14 no-lock:
    assign deAceitacao = decimal(mab-param.des-valor).
end.

/** Percorre Datas informadas **/
for each ttEqpto:
    if tt-param.num-docto <> ? THEN DO:
        for first mab-abastec-lubrific
            where mab-abastec-lubrific.num-docto = tt-param.num-docto no-lock:
            
            /** Procedure principal **/
            run piPrincipal in this-procedure.
        end.
    END.
    else do:
        assign dataIni = tt-param.dataIni.
        /** Verifica se existem fichas anteriores a data parametrizada que n∆o foram consistidas **/
        if tt-param.lFicha then do:
            /** Busca a primeiro ficha n∆o consistida do equipamento **/
            for first mab-abastec-lubrific use-index mbbstclb-02
                where mab-abastec-lubrific.ep-codigo   = ttEqpto.ep-codigo 
                and   mab-abastec-lubrific.cod-eqpto   = ttEqpto.cod-eqpto 
                and   mab-abastec-lubrific.log-consist = false no-lock:

                if (mab-abastec-lubrific.cod-posto < tt-param.cPostoIni  and
                    mab-abastec-lubrific.cod-posto > tt-param.cPostoFim) then next.

                /* Busca o Posto para validar a faixa de Estabelecimento */
                FOR FIRST mab-posto
                    WHERE mab-posto.cod-posto = mab-abastec-lubrific.cod-posto NO-LOCK:

                    IF mab-posto.cod-estabel < tt-param.cEstabIni OR
                       mab-posto.cod-estabel > tt-param.cEstabFim THEN NEXT.
                END.
                
                IF  mab-abastec-lubrific.cc-codigo < tt-param.cCCini OR 
                    mab-abastec-lubrific.cc-codigo > tt-param.cCCfim THEN NEXT.

                /** Valida Unidade de Negocio, caso impladada. **/
                &IF DEFINED(bf_mnt_ems206b) &THEN
                    IF l-usa-unid-negoc THEN DO:
                        IF NOT(mab-abastec-lubrific.cod-unid-negoc >= tt-param.cUnidNegocIni  AND 
                               mab-abastec-lubrific.cod-unid-negoc <= tt-param.cUnidNegocFim) THEN NEXT.
                    END.
                &ENDIF

                /** Se a data do movimento for inferior ao inicial de tela, 
                    utiliza a data do movimento como inicial **/
                if mab-abastec-lubrific.dat-movto < tt-param.dataIni then
                    assign dataIni = mab-abastec-lubrific.dat-movto.
            end.
        end.
        /** Percorre o per°odo **/
        repeat dataAux = dataIni to tt-param.dataFim:

        /***************************************************************************/
        /* Convers‰es efetuadas para utilizaá∆o de °ndice j† existente, resolvendo */
        /* o problema de performance reportado na FO 1389.626.                    **/

        run converteParaHoraInvertida (input  string(dataAux,"99/99/9999"),
                                       input  "000000",
                                       output deAuxIni).

        run converteParaHoraInvertida (input  string(dataAux,"99/99/9999"),
                                       input  "235959",
                                       output deAuxFim).
        /*************************************************************************/

            /** Procura apontamentos dos equipamentos **/
            for each  mab-abastec-lubrific use-index mbbstclb-04
                where mab-abastec-lubrific.ep-codigo             = ttEqpto.ep-codigo
                and   mab-abastec-lubrific.cod-eqpto             = ttEqpto.cod-eqpto 
                and   mab-abastec-lubrific.val-dat-hora-invrtda >= deAuxIni
                and   mab-abastec-lubrific.val-dat-hora-invrtda <= deAuxFim no-lock:

                if (mab-abastec-lubrific.cod-posto < tt-param.cPostoIni  and
                    mab-abastec-lubrific.cod-posto > tt-param.cPostoFim) then next.

                FOR FIRST mab-posto                                                    
                    WHERE mab-posto.cod-posto = mab-abastec-lubrific.cod-posto NO-LOCK:
                                                                                       
                    IF mab-posto.cod-estabel < tt-param.cEstabIni OR                   
                       mab-posto.cod-estabel > tt-param.cEstabFim THEN NEXT.           
                END.    

                IF  mab-abastec-lubrific.cc-codigo < tt-param.cCCini OR 
                    mab-abastec-lubrific.cc-codigo > tt-param.cCCfim THEN NEXT.

                /** Valida Unidade de Negocio, caso impladada. **/
                &IF DEFINED(bf_mnt_ems206b) &THEN
                    IF l-usa-unid-negoc THEN DO:
                        IF NOT(mab-abastec-lubrific.cod-unid-negoc >= tt-param.cUnidNegocIni  AND 
                               mab-abastec-lubrific.cod-unid-negoc <= tt-param.cUnidNegocFim) THEN NEXT.
                    END.
                &ENDIF

                /** Ponto de UPC para atender a FO 1564.543 
                    Empresa GAB **/
                for each  tt-epc where tt-epc.cod-event = "piProcessaAtualizacao":U exclusive-lock:
                    delete tt-epc.
                end.
                create tt-epc.
                assign tt-epc.cod-event     = "piProcessaAtualizacao":U
                       tt-epc.cod-parameter = "cod-posto":U
                       tt-epc.val-parameter = mab-abastec-lubrific.cod-posto.

                {include/i-epc201.i "piProcessaAtualizacao"}
                if return-value = "NOK":U then next.
                /** Fim do Ponto UPC **/

                /** Procedure principal **/
                run piPrincipal in this-procedure.
            end.
        end.
    end.
end.

/** Atualizaá∆o da Vida do equipamento **/
run abp/abapi003.p (input  1, /** Origem 1 = MAB / 2 = MPN / 3 = MMV **/
                    input  table ttDocumento,
                    output table RowErrors). 

IF NOT CAN-FIND (FIRST RowErrors) THEN DO:
    RUN piAtualizaPneus IN THIS-PROCEDURE.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piSemConsumo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSemConsumo Procedure 
PROCEDURE piSemConsumo :
/*------------------------------------------------------------------------------
  Purpose:     piSemConsumo
  Parameters:  <none>
  Notes:       Atualiza Apontamento para equipamentos que n∆o s∆o controlados 
               seu consumo.
------------------------------------------------------------------------------*/
DEFINE VARIABLE deMaximo AS DECIMAL NO-UNDO.

DEFINE BUFFER bfApont FOR mab-abastec-lubrific.

CASE tt-param.tipo-liberacao:
    /** Liberaá∆o Normal - utilizada pelo ab0401 e ab0302 **/
    WHEN 1 THEN DO:

        /** Verifica se existem apontamentos anteriores para equipamento por data **/
        FOR FIRST bfApont
            WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
            AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
        END.
        IF  AVAIL bfApont THEN DO:
            FOR LAST  bfApont USE-INDEX mbbstclb-04
                WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:

                /** Uso real foi do apontamento anterior **/
                ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - bfApont.val-hodom-horim.
                
                /************************************************************************************************************** 
                 Quando for equipamento motorizado e ficha atual n∆o for de abastecimento verifica se ficha anterior
                 tambÇm n∆o Ç de abastecimento. Se isto ocorrer, o percurso da ficha atual deve receber o precurso da ficha
                 anterior mais a diferenáa entre contadores
                 Ex:
                 Data              Abastecimento (S/N)     Contador    val-km-percur
                 01/01/2004              SIM                15.000         15.000 
                 02/01/2004              N«O                15.300            300
                 03/01/2004              N«O                15.500            500
                 04/01/2004              SIM                15.650            650 
                **************************************************************************************************************/
                
                IF ttEqpto.idi-tip-eqpto = 1 THEN DO:
                    FOR FIRST mab-item-abastec 
                        WHERE mab-item-abastec.num-docto = bfApont.num-docto
                        AND mab-item-abastec.log-abastec-prim NO-LOCK:
                    END.
                    IF  NOT AVAIL mab-item-abastec AND mab-abastec-lubrific.val-hodom-horim >= bfApont.val-hodom-horim THEN DO:
                            ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - bfApont.val-hodom-horim + bfApont.val-km-percur.
                    END.
                END.
            END.
        END.
        ELSE DO:
            /** Compara com hodìmetro inicial do equipamento **/
            ASSIGN ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - ttEqpto.val-hodom-horim-inicial.
        END.

        /** Busca ficha anterior por data para avaliar se a mesma esta consistida  **/
        FOR LAST  bfApont USE-INDEX mbbstclb-04
            WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo 
            AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            AND   bfapont.log-consist          = NO
            AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
        END.
        /** Se encontrou a ficha atualiza o estatus da ficha como n∆o consistida **/
        IF AVAIL bfapont THEN DO:
            /** 9 = ficha anterior n∆o consistida **/
            RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 9).
            RETURN "OK":U.
        END.

        /** Hodìmetro Maior que Èltimo Apontamento **/
        IF ttEqpto.uso-real > 0 THEN DO:
            FOR LAST  mab-histor-combust 
               WHERE mab-histor-combust.ep-codigo      = mab-abastec-lubrific.ep-codigo
                 AND mab-histor-combust.cod-eqpto      = mab-abastec-lubrific.cod-eqpto
                 AND mab-histor-combust.dat-inicial   <= mab-abastec-lubrific.dat-movto
                 AND mab-histor-combust.idi-tip-consu  > 1 NO-LOCK:
                
                IF mab-histor-combust.idi-tip-consu = 2 THEN
                    ASSIGN deMaximo = mab-histor-combust.val-consu-padr * mab-histor-combust.val-capac-tanque.

                IF mab-histor-combust.idi-tip-consu = 3 THEN
                    ASSIGN deMaximo = mab-histor-combust.val-capac-tanque / mab-histor-combust.val-consu-padr.
                
                /** Dif. Hodìmetro maior que reservat¢rio (6) **/
                IF ttEqpto.uso-real > deMaximo THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 6).
                END.
                /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                ELSE IF ttEqpto.log-cont-sec = NO THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                END.

            END.
            IF NOT AVAIL mab-histor-combust THEN DO:
                /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                IF ttEqpto.log-cont-sec = NO THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21). /* Rodado quando for implementos Xavier */
                END.
            END.
        END.
        ELSE DO:
            IF ttEqpto.uso-real = 0 THEN DO:
                /** Caso o equipamento possua Contador Secund†rio, ir† concluir como 
                "Apontamento Correto", apenas quando efetuar as devidas validaá‰es **/
                IF ttEqpto.log-cont-sec = NO THEN DO:
                    RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
                    
                END.
            END.
            /** Hodìmetro Menor que Anterior (5) **/
            ELSE
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 5).
        END.

        IF  cProgOrigem <> "AB0401":U THEN DO:
            FOR EACH  bfApont 
                WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo 
                AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                AND   bfapont.log-consist          = NO
                AND   bfApont.val-dat-hora-invrtda > mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
    
                ASSIGN tt-param.dataIni   = bfApont.dat-movto 
                       tt-param.dataFim   = bfApont.dat-movto
                       tt-param.num-docto = bfApont.num-docto . 
                
                run abp/abapi001.p (input  table tt-param,
                                    output table RowErrors,
                                    output table ttDocLib).
            END.
        END.
    END.
    /** Libera«∆o Padr∆o (2) ou Usuˇrio (3) - utilizada pelo ab0402 **/
    OTHERWISE DO:
        RUN piDocLib IN THIS-PROCEDURE.
    END.
END CASE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piSemConsumoSec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSemConsumoSec Procedure 
PROCEDURE piSemConsumoSec :
/*------------------------------------------------------------------------------
  Purpose:     piSemConsumo
  Parameters:  <none>
  Notes:       Atualiza Apontamento para equipamentos que n∆o s∆o controlados 
               seu Consumo Secund†rio.
------------------------------------------------------------------------------*/
DEFINE VARIABLE deMaximo AS DECIMAL NO-UNDO.

DEFINE BUFFER bfApont FOR mab-abastec-lubrific.

CASE tt-param.tipo-liberacao:
    /** Liberaá∆o Normal - utilizada pelo ab0401 e ab0302 **/
    WHEN 1 THEN DO:

        /** Verifica se existem apontamentos anteriores para equipamento por data **/
        FOR FIRST bfApont
            WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
            AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
        END.
        IF  AVAIL bfApont THEN DO:
            FOR LAST  bfApont 
                WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                AND   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:

                /** Uso Real Secund†rio foi do apontamento anterior **/
                ASSIGN ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - bfApont.val-hodom-horim-sec.

                /************************************************************************************************************** 
                 Quando for equipamento motorizado e ficha atual n∆o for de abastecimento verifica se ficha anterior
                 tambÇm n∆o Ç de abastecimento. Se isto ocorrer, o percurso da ficha atual deve receber o precurso da ficha
                 anterior mais a diferenáa entre contadores
                 Ex:
                 Data              Abastecimento (S/N)     Contador    val-km-percur
                 01/01/2004              SIM                15.000         15.000 
                 02/01/2004              N«O                15.300            300
                 03/01/2004              N«O                15.500            500
                 04/01/2004              SIM                15.650            650 
                **************************************************************************************************************/

                IF ttEqpto.idi-tip-eqpto = 1 THEN DO:
                    FOR FIRST mab-item-abastec 
                        WHERE mab-item-abastec.num-docto = bfApont.num-docto
                        AND mab-item-abastec.log-abastec-prim NO-LOCK:
                    END.
                    IF NOT AVAIL mab-item-abastec THEN DO:
                        ASSIGN ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - bfApont.val-hodom-horim-sec + bfApont.val-livre-1.
                    END.
                END.
            END.
        END.
        ELSE DO:
            /** Compara com hodìmetro inicial do equipamento **/
            ASSIGN ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - ttEqpto.val-hodom-horim-sec.
        END.
        
        /* mab-histor-combust.num-livre-1 --> idi-tip-consu-sec  */
        /* mab-histor-combust.val-livre-1 --> val-consu-padr-sec */

        IF ttEqpto.uso-real-sec > 0 THEN DO:
            
            FOR LAST mab-histor-combust
               WHERE mab-histor-combust.ep-codigo      = mab-abastec-lubrific.ep-codigo
                 AND mab-histor-combust.cod-eqpto      = mab-abastec-lubrific.cod-eqpto
                 AND mab-histor-combust.dat-inicial   <= mab-abastec-lubrific.dat-movto
                 AND mab-histor-combust.num-livre-1  > 1 NO-LOCK:
                
                IF mab-histor-combust.num-livre-1 = 2 THEN
                    ASSIGN deMaximo = mab-histor-combust.val-livre-1 * mab-histor-combust.val-capac-tanque. /* alterado p/ val-livre-1 */

                IF mab-histor-combust.num-livre-1 = 3 THEN
                    ASSIGN deMaximo = mab-histor-combust.val-capac-tanque / mab-histor-combust.val-livre-1.
                
            END.

            IF AVAIL mab-histor-combust AND ttEqpto.uso-real-sec > deMaximo THEN
                /* Diferenáa Contador Secund†rio maior desempenho tanque */
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 12).
            ELSE 
                /** Apontamento Correto **/
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
        END.
        ELSE DO:
            /** Apontamento Correto (21) **/
            IF ttEqpto.uso-real-sec = 0 THEN DO:
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 21).
            END.
            /** Contador Secund†rio Menor que Anterior (8) **/
            ELSE DO:
                RUN piAtualizaDocumento IN THIS-PROCEDURE (INPUT 8).
            END.
        END.

        IF  cProgOrigem <> "AB0401":U THEN DO:
            FOR EACH  bfApont 
                WHERE bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo 
                AND   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                AND   bfapont.log-consist          = NO
                AND   bfApont.val-dat-hora-invrtda > mab-abastec-lubrific.val-dat-hora-invrtda NO-LOCK:
    
                ASSIGN tt-param.dataIni   = bfApont.dat-movto 
                       tt-param.dataFim   = bfApont.dat-movto
                       tt-param.num-docto = bfApont.num-docto . 
                
                run abp/abapi001.p (input  table tt-param,
                                    output table RowErrors,
                                    output table ttDocLib).
            END.
        END.
    END.
    
    /** Liberaá∆o Padr∆o (2) ou Usuˇrio (3) - utilizada pelo ab0402 **/
    OTHERWISE DO:
        RUN piDocLib IN THIS-PROCEDURE.
    END.
END CASE.
        
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piSomatoria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSomatoria Procedure 
PROCEDURE piSomatoria :
/*------------------------------------------------------------------------------
  Purpose:     piSomatoria
  Parameters:  <none>
  Notes:       Faz a somat¢ria dos abastecimentos relacionados ao documento
               informado, pegando apenas abastecimentos primˇrios 
               (indicador = true).
------------------------------------------------------------------------------*/
define variable lHistorico as logical initial yes no-undo.

define buffer bfAbastec for mab-item-abastec.
define buffer bfApont   for mab-abastec-lubrific.

/** Busca Apontamentos de Abastecimento **/
for each  mab-item-abastec fields(cod-tip-mater ep-codigo cod-eqpto 
                                  val-dat-hora-invrtda val-quant log-abastec-prim)
    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
    and   mab-item-abastec.log-abastec-prim no-lock:
    if lHistorico then do:
        assign lHistorico = no.
        /** Busca Hist¢rico de combust°vel para apontamento **/
        for last  mab-histor-combust 
            where mab-histor-combust.ep-codigo      = mab-abastec-lubrific.ep-codigo
            and   mab-histor-combust.cod-eqpto      = mab-abastec-lubrific.cod-eqpto
            and   mab-histor-combust.cod-tip-mater  = mab-item-abastec.cod-tip-mater
            and   mab-histor-combust.dat-inicial   <= mab-abastec-lubrific.dat-movto no-lock:
            /** Guarda tipo de Consumo e Consumo Secund†rio do equipamento
                (1 - Sem Consumo
                 2 - Km-Hora/Qtd
                 3 - Qtd/Km-Hora) **/
            ASSIGN ttEqpto.tp-consumo     = mab-histor-combust.idi-tip-consu
                   ttEqpto.tp-consumo-sec = mab-histor-combust.num-livre-1. /** Validaá∆o Contador Secund†rio **/

            /** Verifica se consumo padr∆o estˇ no modelo **/
            if can-find(first mab-consu-model
                        where mab-consu-model.cod-model     = ttEqpto.cod-model
                        and   mab-consu-model.cod-ativid    = mab-abastec-lubrific.cod-ativid
                        and   mab-consu-model.cod-tip-mater = mab-item-abastec.cod-tip-mater  no-lock) then do:
                for first mab-consu-model
                    where mab-consu-model.cod-model     = ttEqpto.cod-model
                    and   mab-consu-model.cod-ativid    = mab-abastec-lubrific.cod-ativid
                    and   mab-consu-model.cod-tip-mater = mab-item-abastec.cod-tip-mater  no-lock:
                    /** Padr∆o Modelo **/
                    assign ttEqpto.consumo-padrao     = mab-consu-model.val-consu-padr
                           ttEqpto.consumo-padrao-sec = mab-consu-model.val-consu-sec.
                end.            
            end.
            ELSE DO:
                /**Padr∆o Equipamento **/
                assign ttEqpto.consumo-padrao     = mab-histor-combust.val-consu-padr
                       ttEqpto.consumo-padrao-sec = mab-histor-combust.val-livre-1.
            END.


        end.
        /** Calcula Uso Rel Rodado pelo equipamento (HodÀmetro / Hor°metro) **/
        FOR first bfAbastec
            where bfAbastec.ep-codigo = mab-item-abastec.ep-codigo
            and   bfAbastec.cod-eqpto = mab-item-abastec.cod-eqpto
            and   bfAbastec.log-abastec-prim
            and   bfAbastec.val-dat-hora-invrtda < mab-item-abastec.val-dat-hora-invrtda NO-LOCK:
        END.
        IF  AVAIL bfAbastec THEN DO:
            /** Busca Apontamento anterior para comparaá∆o **/
            for last  bfAbastec fields(num-docto) USE-INDEX mbtmbstc-02
                where bfAbastec.ep-codigo = mab-item-abastec.ep-codigo
                and   bfAbastec.cod-eqpto = mab-item-abastec.cod-eqpto
                and   bfAbastec.log-abastec-prim
                and   bfAbastec.val-dat-hora-invrtda < mab-item-abastec.val-dat-hora-invrtda no-lock:
                for first bfApont fields(val-hodom-horim val-hodom-horim-sec idi-consist )
                    where bfApont.num-docto = bfAbastec.num-docto no-lock:
                    /** Compara com hodÀmetro do Èltimo abastecimento **/
                    assign ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - bfApont.val-hodom-horim.
                    IF  ttEqpto.log-cont-sec THEN  /* (Validaá∆o Contador Secundario) */
                        assign ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - bfApont.val-hodom-horim-sec.
                end.
            end.
        end.
        ELSE DO:
            /** Compara com hodÀmetro inicial do equipamento **/
            assign ttEqpto.uso-real = mab-abastec-lubrific.val-hodom-horim - ttEqpto.val-hodom-horim-inicial.
            IF  ttEqpto.log-cont-sec THEN  /* (Validaá∆o Contador Secundario) */
                assign ttEqpto.uso-real-sec = mab-abastec-lubrific.val-hodom-horim-sec - ttEqpto.val-hodom-horim-sec.
        END.
    end.
    /** Guarda a quantidade total abastecida no apontamento **/
    assign ttEqpto.qtd-abast    = ttEqpto.qtd-abast + mab-item-abastec.val-quant
           ttEqpto.log-primario = mab-item-abastec.log-abastec-prim.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidaInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInicial Procedure 
PROCEDURE piValidaInicial :
/*------------------------------------------------------------------------------
  Purpose:     piValidaInicial
  Parameters:  <none>
  Notes:       ValidaáÑes Iniciais para atualizaáÑes de apontamentos
------------------------------------------------------------------------------*/
/** Valida ParÉmetros **/
run piValidaParametroAbastecimento in hDBOApont (input "14").
if return-value = "NOK":U then do:
    /** Busca Erros da BO **/
    run getRowErrors in hDBOApont (output table RowErrors).
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOApont.
    return "NOK":U.
end.
/** ParÉmetros n∆o informados **/
if not avail tt-param then do:
    run piCriaErro (1454, 'EMS':U, '').
    return "NOK":U.
end.
/** Data Inicial maior que final **/
if tt-param.dataIni > tt-param.dataFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Final" *}
    ASSIGN c-lbl-liter-final = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Inicial" *}
    ASSIGN c-lbl-liter-inicial = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-final + '~~' + string(tt-param.dataFim,'99/99/9999') + '~~' + 
                    c-lbl-liter-inicial + '~~' + string(tt-param.dataIni,'99/99/9999').
    run piCriaErro (28411, 'EMS':U, cTexto).
end.
/** Data Final maior que atual **/
if tt-param.dataFim > today then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-final-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Final" *}
    ASSIGN c-lbl-liter-final-2 = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-atual AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Atual" *}
    ASSIGN c-lbl-liter-atual = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-final-2 + '~~' + string(tt-param.dataFim,'99/99/9999') + '~~' +
                    c-lbl-liter-atual + '~~' + string(tt-param.dataIni,'99/99/9999').
    run piCriaErro (28411, 'EMS':U, cTexto).
end.
/** Empresa Inicial menor que final **/
if tt-param.iEmpIni > tt-param.iEmpFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-empresa-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Empresa_Inicial" *}
    ASSIGN c-lbl-liter-empresa-inicial = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-empresa-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Empresa_Final" *}
    ASSIGN c-lbl-liter-empresa-final = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-empresa-inicial + '~~' + c-lbl-liter-empresa-final.
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Estabelecimento Inicial menor que final **/
if tt-param.cEstabIni > tt-param.cEstabFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-estabelecimento-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Estabelecimento_Inicial" *}
    ASSIGN c-lbl-liter-estabelecimento-inicial = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-estabelecimento-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Estabelecimento_Final" *}
    ASSIGN c-lbl-liter-estabelecimento-final = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-estabelecimento-inicial + '~~' + c-lbl-liter-estabelecimento-final.
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Equipamento Inicial menor que final **/
if tt-param.cEqptoIni > tt-param.cEqptoFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-equipamento-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Equipamento_Inicial" *}
    ASSIGN c-lbl-liter-equipamento-inicial = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-equipamento-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Equipamento_Final" *}
    ASSIGN c-lbl-liter-equipamento-final = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-equipamento-inicial + '~~' + c-lbl-liter-equipamento-final.
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** TAG Inicial menor que final **/
if tt-param.cTagIni > tt-param.cTagFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-tag-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "TAG_Inicial" *}
    ASSIGN c-lbl-liter-tag-inicial = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-tag-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "TAG_Final" *}
    ASSIGN c-lbl-liter-tag-final = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-tag-inicial + '~~' + c-lbl-liter-tag-final.
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Centro de custo Inicial menor que final **/
if tt-param.cCCini > tt-param.cCCFim then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-centro-de-custo-inicial AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Centro_de_Custo_Inicial" *}
    ASSIGN c-lbl-liter-centro-de-custo-inicial = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-centro-de-custo-final AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Centro_de_Custo_Final" *}
    ASSIGN c-lbl-liter-centro-de-custo-final = TRIM(RETURN-VALUE).
    assign cTexto = c-lbl-liter-centro-de-custo-inicial + '~~' + c-lbl-liter-centro-de-custo-final.
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Unidade Negocio Inicial menor que final **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        if tt-param.cUnidNegocIni > tt-param.cUnidNegocFim then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-unidade-de-negocio-inicial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Unidade_de_Neg¢cio_Inicial" *}
            ASSIGN c-lbl-liter-unidade-de-negocio-inicial = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-unidade-de-negocio-final AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Unidade_de_Neg¢cio_Final" *}
            ASSIGN c-lbl-liter-unidade-de-negocio-final = TRIM(RETURN-VALUE).
            assign cTexto = c-lbl-liter-unidade-de-negocio-inicial + '~~' + c-lbl-liter-unidade-de-negocio-final.
            run piCriaErro (1208, 'EMS':U, cTexto).
        END.
    END.
&ENDIF

if can-find(first RowErrors) then
    return "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendMessageEAI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessageEAI Procedure 
PROCEDURE sendMessageEAI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-mab-abastec-lubrific-eai.
    
    DEFINE VARIABLE c-action AS CHARACTER  NO-UNDO.

    FIND FIRST tt-mab-abastec-lubrific-eai NO-LOCK NO-ERROR.
    
    IF tt-mab-abastec-lubrific-eai.log-consist THEN
        ASSIGN c-action = "upd":U.
    ELSE
        ASSIGN c-action = "del":U.

    IF v_log_eai_habilit THEN DO:

       for last mab-histor-ativid fields (ep-codigo cod-eqpto dat-cadastro cod-ativid)
           where mab-histor-ativid.ep-codigo      =  tt-mab-abastec-lubrific-eai.ep-codigo
           and   mab-histor-ativid.cod-eqpto      =  tt-mab-abastec-lubrific-eai.cod-eqpto
           and   mab-histor-ativid.dat-cadastro  <=  tt-mab-abastec-lubrific-eai.dat-movto no-lock:

            /**** Verifica se atividade localizada pertence a area agricola *********/
           for first mab-ativid fields (cod-ativid log-area-agro )
               where mab-ativid.cod-ativid  = mab-histor-ativid.cod-ativid no-lock:
               if mab-ativid.log-area-agro then do:
                       /*disparando o adapter, pois a ficha pertence π ˇrea agr°cola*/
                        RUN adapters/xml/mn2/axsmf006.p (INPUT c-action,
                                                         INPUT "abapi001.p":U,
                                                         INPUT c-prg-vrs,
                                                         INPUT TABLE tt-mab-abastec-lubrific-eai,
                                                     OUTPUT TABLE RowErrors).
                        DELETE tt-mab-abastec-lubrific-eai NO-ERROR. 
                        IF CAN-FIND (FIRST RowErrors WHERE 
                                           RowErrors.ErrorSubType = "ERROR":U) 
                           OR RETURN-VALUE = "NOK":U THEN DO:
                            UNDO, RETURN "NOK":U.
                        END.
                        ELSE
                            RETURN "OK":U.
               END. 
           END. /*for first mab-ativid*/
       END. /*for last mab-histor-ativid*/  
    END. /*v_log_eai_habilit*/
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCallUpsertAdapter DBOProgram 
PROCEDURE piCallUpsertAdapter :
/*------------------------------------------------------------------------------
  Purpose: Chamada de inclus∆o e alteraá∆o para o EAI 2.00     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM iNumDocto AS INTEGER.

    IF v_log_eai2_ativado THEN DO:

        {com/totvs/datasul/eai/include/transactionstatus.i "Refueling"}

        IF lEnabledAndRouted THEN DO:    

            oRefuelingAdapter = NEW com.totvs.datasul.manufacture.mab.RefuelingAdapter().           
            oResponseMessage  = CAST(oRefuelingAdapter:sendUpsert(cMode, iNumDocto), "com.totvs.datasul.eai.ResponseMessage").
            {com/totvs/datasul/eai/include/responsemessage.i 'adm-error'}
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

