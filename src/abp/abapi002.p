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

{include/i-prgvrs.i ABAPI002 2.00.00.010 } /*** 010010 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi002 MAB}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: ABAPI002.p
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
{abp/abapi001.i}  /** Definiá∆o de Temp-Tables da API **/
{abp/abapi001.i1} /** Definiá∆o de Temp-Tables da API **/
{abp/abapi003.i}  /** Definiá∆o da ttDocumento **/
{frbo/bofr059.i ttEvento}  /** Definiá∆o da Temp-Table de Eventos **/
{frbo/bofr060.i ttKM} /** Definiá∆o da Temp-Table de kilometragem **/
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

/** Vari†veis Locais **/
define variable hDBOApont     as handle         no-undo.
define variable hDBOEvento    as handle         no-undo.
define variable VerifRowid    as char           no-undo.
define variable VerifDoctoLib as log initial no no-undo.
DEFINE VARIABLE param25 LIKE mab-param.des-valor     NO-UNDO.
DEFINE VARIABLE param26 LIKE mab-param.des-valor     NO-UNDO.
DEFINE VARIABLE param49 LIKE mab-param.des-valor     NO-UNDO.
define variable iErro as integer no-undo.

DEFINE TEMP-TABLE RowErrorsAux LIKE RowErrors. 

define temp-table tt-param-pnp NO-UNDO LIKE tt-param.


{abp/ab9000.i} /** Convers‰es Hora e Data **/

define new global shared variable c-seg-usuario as character no-undo.

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
         HEIGHT             = 11.88
         WIDTH              = 30.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/abapi001.i2} /** Criaá∆o de Erros **/
{abp/abapi001.i3} /** Atualizaá∆o Kilometragem **/
{abp/abapi001.i4} /** Atualizaá∆o Movimento de Eventos **/

if not(this-procedure:persistent) then do:
    return "NOK":U.
end.

find first tt-param no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-emptyErros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyErros Procedure 
PROCEDURE emptyErros :
/*------------------------------------------------------------------------------
  Purpose:     emptyErros
  Parameters:  <none>
  Notes:       Limpa temp-table de erros
------------------------------------------------------------------------------*/

empty temp-table RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
/** Movimento Evento **/
if valid-handle(hDBOEvento) then
    run destroy in hDBOEvento.

empty temp-table ttDocLib.
empty temp-table ttEvento.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getErros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getErros Procedure 
PROCEDURE getErros :
/*------------------------------------------------------------------------------
  Purpose:     getErros
  Parameters:  RowErrors
  Notes:       Retorna temp-table de erros
------------------------------------------------------------------------------*/
define output parameter table for RowErrors.

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

    /*--- BO Movimento Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo/bofr059.p":U THEN DO:
        RUN frbo/bofr059.p PERSISTENT SET hDBOEvento.
    END.
  
    RUN openQueryMain IN hDBOEvento.

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
  Notes:       Status de como ficar† o documento do apontamento abastecimento.
------------------------------------------------------------------------------*/
define input parameter pStatus as integer no-undo.
define input parameter pKM     as decimal no-undo.
define input parameter pKMSec  as decimal no-undo.
DEFINE VARIABLE cLocalXmlGerado AS CHARACTER FORMAT "x(200)" NO-UNDO.
define buffer bfApont for mab-abastec-lubrific.

/** Busca Apontamento corrente **/
for first bfApont
    where rowid(bfApont) = ttDocLib.r-rowid exclusive-lock:
    /** Atualiza Consistància conforme par∆metro passado **/
    assign bfApont.idi-consist   = pStatus
           bfApont.log-consist   = if pStatus > 20 
                                   then yes
                                   else no
           bfApont.val-km-percur = pKM.
     FOR FIRST mab-eqpto 
         WHERE mab-eqpto.ep-codigo = bfApont.ep-codigo
           AND mab-eqpto.cod-eqpto = bfApont.cod-eqpto NO-LOCK:
            IF mab-eqpto.log-cont-sec THEN
               ASSIGN bfApont.val-livre-1 = /* IF bfApont.uso-real-sec < 0 THEN 0 ELSE */ pKMSec. 
            END.
                    
    /** Criaá∆o da temp-table ttDocumento **/
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

    /** Atualiza data e usu†rio alteraá∆o **/
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
            WHERE mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto 
            AND   mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo NO-LOCK:
            IF  mab-eqpto.log-livre-1 THEN DO:
                IF  bfApont.log-consist THEN DO:
                    /** Chamado do adapter de criaá∆o do XML **/
                    run adapters/xml/mn2/axsmf014.p (input table tt-mab-abastec-lubrific-eai,
                                                     input "ADD":U,
                                                     OUTPUT cLocalXmlGerado).
                END.
            END.
        END.
    END.
end.

/** Atualiza Kilometragem (abapi001.i3) **/
run piKilometragem in this-procedure (input bfApont.num-docto,      /** N£mero documento       **/
                                      input pStatus,                /** Status do Apontamento  **/
                                      input 1,                      /** Origem = Abastecimento **/
                                      input ttDocLib.log-primario). /** Abastecimento Prim†rio **/
return "OK":U.

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
/*Ap¢s ficha OK atualiza a durabilidade do pneu*/
FIND FIRST mab-abastec-lubrific
     WHERE mab-abastec-lubrific.num-docto = ttDocumento.num-docto 
       AND mab-abastec-lubrific.idi-consist > 20 NO-LOCK NO-ERROR.

IF AVAIL mab-abastec-lubrific THEN DO:
    FIND FIRST tt-param-pnp NO-LOCK NO-ERROR.
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

        FOR EACH mpn-pneu FIELDS(cod-eqpto-inicial cod-eqpto-atual ep-codigo-atual cod-pneu)
           WHERE mpn-pneu.ep-codigo-atual   >= tt-param-pnp.iEmpIni
             AND mpn-pneu.ep-codigo-atual   <= tt-param-pnp.iEmpFim
             AND mpn-pneu.cod-eqpto-atual   >= tt-param-pnp.cEqptoIni
             AND mpn-pneu.cod-eqpto-atual   <= tt-param-pnp.cEqptoFim
             AND mpn-pneu.cod-estabel-atual >= tt-param-pnp.cEstabIni
             AND mpn-pneu.cod-estabel-atual <= tt-param-pnp.cEstabFim NO-LOCK:


            EMPTY TEMP-TABLE tt-param-aux.
            /*Criaá∆o da tt-param que ser† enviada para a pnapi002. Esta temp-table ser† criada para cada */    
            /*pneu atual do equipamento                                                                   */
            CREATE tt-param-aux.
            ASSIGN tt-param-aux.destino   = tt-param-pnp.destino
                   tt-param-aux.arquivo   = tt-param-pnp.arquivo 
                   tt-param-aux.usuario   = tt-param-pnp.usuario    
                   tt-param-aux.data-exec = tt-param-pnp.data-exec  
                   tt-param-aux.hora-exec = tt-param-pnp.hora-exec  
                   tt-param-aux.empIni    = tt-param-pnp.iEmpIni  
                   tt-param-aux.empFim    = tt-param-pnp.iEmpFim  
                   tt-param-aux.eqptoIni  = tt-param-pnp.cEqptoIni
                   tt-param-aux.eqptoFim  = tt-param-pnp.cEqptoFim
                   tt-param-aux.estabIni  = tt-param-pnp.cEstabIni
                   tt-param-aux.estabFim  = tt-param-pnp.cEstabFim
                   tt-param-aux.pneuIni   = mpn-pneu.cod-pneu 
                   tt-param-aux.pneuFim   = mpn-pneu.cod-pneu 
                   tt-param-aux.tag-ini   = tt-param-pnp.cTagIni 
                   tt-param-aux.tag-fim   = tt-param-pnp.cTagFim 
                   tt-param-aux.cc-ini    = tt-param-pnp.cCCini 
                   tt-param-aux.cc-fim    = tt-param-pnp.cCCfim 
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaEvento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaEvento Procedure 
PROCEDURE piCriaEvento :
/*------------------------------------------------------------------------------
  Purpose:     piCriaEvento
  Parameters:  <none>
  Notes:       Criaá∆o do evento
------------------------------------------------------------------------------*/
RUN openQueryMain IN hDBOEvento NO-ERROR.
/*--- Transfere temp-table {&ttTarget} para o DBO ---*/
RUN criaEvento IN hDBOEvento (INPUT TABLE ttEvento).
if return-value = "NOK":U then do:
    /** Busca Erros da BO **/
    run getRowErrors in hDBOEvento (output table RowErrors).
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOEvento.
    return "NOK":U.        
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piEvento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEvento Procedure 
PROCEDURE piEvento :
/*------------------------------------------------------------------------------
  Purpose:     piEvento
  Parameters:  entrada pUsuario = Usu†rio corrente 
               sa°da   pDoc     = N£mero documento
  Notes:       Cria evento para avisar manutená∆o.
------------------------------------------------------------------------------*/
define input  parameter pUsuario as   character           no-undo.
define output parameter pDoc     like ttEvento.num-docto  no-undo.

/** Busca fichas com inconsistencias de Contador Parado (Primario (4) e Secundario (7)) **/
for each  ttDocLib
    where ttDocLib.idi-consist = 4 OR
          ttDocLib.idi-consist = 7:
    /** Verifica se existem dois registros iguais na temp-table ttDocLib, para que n∆o seja criado dois eventos iguais **/
    IF verifRowid <> string(ttDocLib.r-rowid) THEN
        ASSIGN verifRowid = string(ttDocLib.r-rowid)
               VerifDoctoLib = NO.
    ELSE 
        ASSIGN VerifDoctoLib = YES.
    IF VerifDoctoLib = NO THEN DO:
        /** Cria registro Temp-Table **/
        create ttEvento.
        /** Polpular campos **/
        for first mab-abastec-lubrific
            where rowid(mab-abastec-lubrific) = ttDocLib.r-rowid no-lock:
            /** Salva campos  **/
            run buscaDocumento in hDBOEvento (output ttEvento.num-docto).
            assign ttEvento.num-docto-orig = mab-abastec-lubrific.num-docto
                   ttEvento.ep-codigo      = mab-abastec-lubrific.ep-codigo
                   ttEvento.cod-eqpto      = mab-abastec-lubrific.cod-eqpto
                   ttEvento.dat-aviso      = today
                   ttEvento.dat-inicial    = today
                   ttEvento.dat-final      = ?
                   ttEvento.hra-final      = "000000":U
                   ttEvento.val-km-aviso   = 0
                   ttEvento.val-evento     = 0
                   ttEvento.cod-ofici      = ""
                   ttEvento.log-disparad   = no
                   ttEvento.cod-usuar      = pUsuario.

            &IF DEFINED(bf_mnt_ems206b) &THEN
                IF l-usa-unid-negoc THEN DO:
                    FOR LAST mab-histor-ativid 
                        WHERE mab-histor-ativid.ep-codigo    =  mab-abastec-lubrific.ep-codigo
                        AND   mab-histor-ativid.cod-eqpto    =  mab-abastec-lubrific.cod-eqpto
                        AND   mab-histor-ativid.dat-cadastro <= TODAY NO-LOCK:
    
                        ASSIGN ttEvento.cod-unid-negoc = mab-histor-ativid.cod-unid-negoc.
        
                    END.
                END.
            &ENDIF
            /** Busca a hora atual **/
            run piFormataSegundoParaHora (input  time,
                                          output ttEvento.hra-inicial).
            for each  mab-param fields(des-valor cdn-param)
                where mab-param.cdn-param = 19 
                or    mab-param.cdn-param = 20
                or    mab-param.cdn-param = 21 no-lock:
                case mab-param.cdn-param:
                    when 19 then assign ttEvento.cod-evento    = mab-param.des-valor.
                    when 20 then assign ttEvento.cod-sub-sist  = mab-param.des-valor.
                    when 21 then assign ttEvento.cd-tipo       = int(mab-param.des-valor).
                end case.
            end.
            /** Contador Prim†rio Parado **/
            IF ttDocLib.idi-consist = 4 THEN DO:
                run utp/ut-msgs.p (input 'msg':U,
                                   input 28492,
                                   input string(mab-abastec-lubrific.val-hodom-horim) + '~~' +
                                   string(mab-abastec-lubrific.dat-movto)).
            END.
            ELSE DO:
                /** Contador Secund†rio Parado **/
                run utp/ut-msgs.p (input 'msg':U,
                                   input 28492,
                                   input string(mab-abastec-lubrific.val-hodom-horim-sec) + '~~' +
                                   string(mab-abastec-lubrific.dat-movto)).
            END.
            assign ttEvento.dsl-obs = return-value.
        end.
    END.
    /** Verifica se j† existe movimento evento para equipamento **/
    run consisteInclusaoDocto in hDBOEvento (input  ttEvento.ep-codigo,
                                             input  ttEvento.cod-eqpto,
                                             input  ttEvento.cod-evento,
                                             input  ttEvento.cod-sub-sist,
                                             output pDoc).
    if return-value = "NOK":U then
        return "DOC":U.

end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piLiberacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLiberacao Procedure 
PROCEDURE piLiberacao :
/*------------------------------------------------------------------------------
  Purpose:     piLiberacao
  Parameters:  pLibera = Tipo de Liebraá∆o
                         -> 2 = Padr∆o
                         -> 3 = Usu†rio
  Notes:       Libera apontamentos por tipo de liberaá∆o
------------------------------------------------------------------------------*/
define input parameter pLibera as integer no-undo.
DEFINE INPUT PARAMETER pUsoReal LIKE ttDocLib.uso-real.
DEFINE INPUT PARAMETER pUsoRealSec LIKE ttDocLib.uso-real-sec.

define variable deKM    as decimal no-undo.
define variable deKMSec as decimal no-undo.

case pLibera:
    /** Padr∆o **/
    when 2 then do:
        for each ttDocLib:
            case ttDocLib.tp-consumo:
                when 2 then assign deKM = ttDocLib.qtd-abast * ttDocLib.consumo-padrao
                                   deKMSec = ttDocLib.qtd-abast * ttDocLib.consumo-padrao-sec.
                when 3 then assign deKM = ttDocLib.qtd-abast / ttDocLib.consumo-padrao
                                   deKMSec = ttDocLib.qtd-abast / ttDocLib.consumo-padrao-sec.
            end case.
            run piAtualizaDocumento in this-procedure (input 22,
                                                       input deKM,
                                                       INPUT deKMSec).
            
        end.
    end.
    /** Usu†rio **/
    when 3 then do:
        for each ttDocLib:
            run piAtualizaDocumento in this-procedure (input 23,
                                                       input pUsoReal,
                                                       INPUT pUsoRealSec).
        end.        
    end.
end case.


/** Atualizaá∆o da Vida do equipamento **/
run abp/abapi003.p (input  1, /** Origem 1 = MAB / 2 = MPN / 3 = MMV **/
                    input  table ttDocumento,
                    output table RowErrors).
IF CAN-FIND(FIRST RowErrors
            WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
    RETURN "WARNING":U.
ELSE DO:
    RUN piAtualizaPneus IN THIS-PROCEDURE.
END.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piQuantidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piQuantidade Procedure 
PROCEDURE piQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     piQuantidade
  Parameters:  entrada pDoc  = N£mero do documento
               entrada pTipo = Tipo de consumo
               entrada pQtd  = Quantidade abastecida
               entrada pCons = Consumo Padr∆o
Notes:       Verifica quantidade abastecida.
------------------------------------------------------------------------------*/
define input parameter pDoc     like mab-abastec-lubrific.num-docto no-undo.
define input parameter pTipo    as   integer                        no-undo.
define input parameter pQtd     as   decimal                        no-undo.
define input parameter pCons    as   decimal                        no-undo.

define variable deKM    as decimal   no-undo.
define variable deKMSec as decimal   no-undo.
define variable cTexto  as character no-undo.
define buffer bfApont   for mab-abastec-lubrific.

/** Quantidade abastecida deve ser maior que 0 **/
if pQtd = 0 then do:
    run piCriaErro (28487, 'EMS':U, string(pDoc)).        
    return "NOK":U.
end.

/*--------------------------------------------------------------------------------*/
/* Caso £ltima ficha anterior ao apontamento em quest∆o n∆o for de abastecimento, */
/* km real (ap¢s £ltimo abastecimento) informado n∆o pode ser menor que km real   */
/* informado nesta £ltima ficha. Caso ficha anterior seja de abastecimento,       */
/* este tipo de consistància n∆o precisa ser realizada.                           */
/*--------------------------------------------------------------------------------*/
for first mab-abastec-lubrific fields(ep-codigo cod-eqpto val-dat-hora-invrtda)
    where mab-abastec-lubrific.num-docto = pDoc no-lock:
    for last  bfApont fields(val-km-percur num-docto val-livre-1)
        where bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
        and   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
        and   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock:
    
        FOR FIRST mab-item-abastec 
                        WHERE mab-item-abastec.num-docto = bfApont.num-docto
                        AND mab-item-abastec.log-abastec-prim NO-LOCK:
        END.
        IF NOT AVAIL mab-item-abastec THEN DO:
            case pTipo:
                when 2 then assign deKM    = pQtd * pCons.
                when 3 then assign deKM    = pQtd / pCons.
                                 
            end case.
            if deKM < bfapont.val-km-percur then do:
                {utp/ut-liter.i "Percurso Real"}
                assign cTexto = return-value.
                {utp/ut-liter.i "Percurso do Èltimo Apontamento"}
                assign cTexto = cTexto + "~~" + return-value + " " + string(bfapont.val-km-percur).
                run piCriaErro (7017, 'EMS':U, cTexto).
                return "NOK":U.
            end.
            IF deKmSec < bfApont.val-livre-1 THEN DO:
                {utp/ut-liter.i "Percurso Real Secund†rio"}
                assign cTexto = return-value.
                {utp/ut-liter.i "Percurso do Èltimo Apontamento"}
                assign cTexto = cTexto + "~~" + return-value + " " + string(bfApont.val-livre-1).
                run piCriaErro (7017, 'EMS':U, cTexto).
                return "NOK":U.
            END.
        END.
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRecebeTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeTT Procedure 
PROCEDURE piRecebeTT :
/*------------------------------------------------------------------------------
  Purpose:     piRecebeTT
  Parameters:  ttDocLib = Temp-Table documentos a serem liberados
  Notes:       Recebe a temp-table ttDocLib
------------------------------------------------------------------------------*/
define input parameter table for ttDocLib.

/** Documento n∆o dispon°vel **/
if not can-find(first ttDocLib) then do:
    run piCriaErro (28490, 'EMS':U, '').        
    return "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRecebeTTParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeTTParam Procedure 
PROCEDURE piRecebeTTParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR tt-param-pnp.

/** Documento n∆o dispon°vel **/
IF NOT CAN-FIND(FIRST tt-param-pnp) OR 
   NOT CAN-FIND (FIRST ttDocLib)THEN DO:
    IF NOT CAN-FIND (FIRST RowErrors
                     WHERE RowErrors.ErrorNumber = 28490) THEN DO:
        RUN piCriaErro (28490, 'EMS':U, '').        
        RETURN "NOK":U.
    END.
    ELSE 
        RETURN "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValida Procedure 
PROCEDURE piValida :
/*------------------------------------------------------------------------------
  Purpose:     piValida
  Parameters:  <none>
  Notes:       Validaá‰es para atualizaá‰es de apontamentos / criaá∆o de eventos
------------------------------------------------------------------------------*/
/** Valida ParÉmetros **/
run piValidaParametroAbastecimento in hDBOApont (input "19,20,21").
if return-value = "NOK":U then do:
    /** Busca Erros da BO **/
    run getRowErrors in hDBOApont (output table RowErrors).
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOApont.
    return "NOK":U.
end.

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
                        /*disparando o adapter, pois a ficha pertence Ö †rea agr°cola*/
                         RUN adapters/xml/mn2/axsmf006.p (INPUT c-action,
                                                          INPUT "abapi002.p":U,
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

