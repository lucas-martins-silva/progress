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
{include/i-prgvrs.i ABAPI006 2.00.00.007 } /*** "010007" 16/05/2025 17:37:32 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi006 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI006.p
**
**       DATA....: Outubro de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Gera‡Æo / Elimina‡Æo de Eventos Programados
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */
/*Temp table tt-epc*/
{include/i-epc200.i ABAPI006}

/** Temp-Tables **/
{abp/abapi006.i1} /** tt-param **/
{abp/abapi006.i}  /** Defini‡Æo das temp-tables **/
{frbo/bofr059.i ttEvento}
def buffer bfttEvento for ttEvento.
define temp-table RowErrorsAux no-undo like RowErrors.

/**Associar os Erros aos equipamentos**/
define temp-table RowErrorsEqpto NO-UNDO LIKE rowerrors 
    FIELD ep-codigo LIKE mab-eqpto.ep-codigo 
    FIELD cod-eqpto LIKE mab-eqpto.cod-eqpto.

/** Parƒmetros **/
define input  parameter table for tt-param.
define output parameter table for RowErrorsEqpto.
define output parameter table for ttCriados.


/** Vari veis **/
DEFINE VARIABLE hDBOEvento   AS HANDLE                   NO-UNDO.
define variable dtVencimento as date format "99/99/9999" no-undo.
{utp/ut-glob.i} /** Defini‡Æo do usu rio corrente no EMS **/


define variable iGera as integer no-undo.
DEFINE VARIABLE l-int-ap AS LOGICAL   NO-UNDO.
DEFINE VARIABLE icont AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotMes AS INTEGER    NO-UNDO.
DEFINE VARIABLE iDocto like mab-movto-event.num-docto   NO-UNDO.
DEFINE VARIABLE i-ano     AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-parcela AS INTEGER    NO-UNDO.

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
         HEIGHT             = 11.04
         WIDTH              = 31.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/ab9000.i}    /** ConversÆo de horas **/
{abp/abapi001.i2} /** Cria‡Æo de Erros **/

run piInicializacao in this-procedure.

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
/** Movimento Evento **/
if valid-handle(hDBOEvento) then
    run destroy in hDBOEvento.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inicializaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaHandle Procedure 
PROCEDURE inicializaHandle :
/*------------------------------------------------------------------------------
  Purpose:     initializeHandle
  Parameters:  <none>
  Notes:       Inicializa os handles no programa
------------------------------------------------------------------------------*/

/*--- BO Movimento Evento ---*/
IF NOT VALID-HANDLE(hDBOEvento) OR
   hDBOEvento:TYPE <> "PROCEDURE":U OR
   hDBOEvento:FILE-NAME <> "frbo/bofr059.p":U THEN DO:
    RUN frbo/bofr059.p PERSISTENT SET hDBOEvento.
END.

RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-epc-movto-evento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-epc-movto-evento Procedure 
PROCEDURE pi-epc-movto-evento :
/*------------------------------------------------------------------------------
  Purpose:     pi-epc-movto-evento
  Parameters:  <none>
  Notes:       EPC para Movimento de Evento
------------------------------------------------------------------------------*/
/*************************************************
** EPC - Conta Cont bil
*************************************************/
def buffer b-tt-movto-event for ttEvento.

for each tt-epc
   where tt-epc.cod-event = "CRIA-MOVTO-EVENT":
   delete tt-epc.
end.

create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "num-docto"
       tt-epc.val-parameter = string(ttEvento.num-docto).
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "dat-inicial"
       tt-epc.val-parameter = string(ttEvento.dat-inicial).
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "ep-codigo"
       tt-epc.val-parameter = string(ttEvento.ep-codigo).
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "cod-eqpto"
       tt-epc.val-parameter = string(ttEvento.cod-eqpto).
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "cod-evento"
       tt-epc.val-parameter = string(ttEvento.cod-evento).


/** Mantemos os nomes do "cod-parameter" e colocamos o campo espec¡fico - Unifica‡Æo de Conceito **/
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "ct-codigo"
       tt-epc.val-parameter = ttEvento.ct-despesa .
create tt-epc.
assign tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
       tt-epc.cod-parameter = "cc-codigo"
       tt-epc.val-parameter = ttEvento.cc-despesa.

{include/i-epc201.i "CRIA-MOVTO-EVENT"}

if return-value <> "NOK" then do:
   find first tt-epc 
        where tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
        and   tt-epc.cod-parameter = "ct-codigo" no-error.
   if avail tt-epc then assign ttEvento.ct-despesa = tt-epc.val-parameter no-error.
   find first tt-epc 
        where tt-epc.cod-event     = "CRIA-MOVTO-EVENT"
        and   tt-epc.cod-parameter = "cc-codigo" no-error.
   if avail tt-epc then assign ttEvento.cc-despesa = tt-epc.val-parameter no-error.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriacao Procedure 
PROCEDURE piCriacao :
/*------------------------------------------------------------------------------
  Purpose:     piCriacao
  Parameters:  <none>
  Notes:       Cria os eventos
------------------------------------------------------------------------------*/
define variable iCont as integer no-undo.
define variable iDia  as integer no-undo.
DEFINE VARIABLE i-mes AS int    NO-UNDO.
DEFINE VARIABLE l-mes AS LOGICAL    NO-UNDO.
/** Inicializa os handle **/
run inicializaHandle in this-procedure.

/** Busca Equipamentos **/
for each  mab-eqpto
    where mab-eqpto.ep-codigo >= tt-param.empIni
    and   mab-eqpto.ep-codigo <= tt-param.empFim
    and   mab-eqpto.cod-eqpto >= tt-param.eqptoIni
    and   mab-eqpto.cod-eqpto <= tt-param.eqptoFim no-lock:

    /** Valida Unidade de Negocio, caso impladada. **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            IF NOT(mab-eqpto.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                   mab-eqpto.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        END.
    &ENDIF

    /** Verifica se equipamento est  ativo **/
    if mab-eqpto.dat-situacao <> ? then next.
    if can-find(first mab-programac-event
                where mab-programac-event.ep-codigo    = mab-eqpto.ep-codigo
                and   mab-programac-event.cod-eqpto    = mab-eqpto.cod-eqpto no-lock) then do:
        /** Busca todas as programa‡äes de eventos que estejam ativas hoje **/
        for each  mab-programac-event
            where mab-programac-event.ep-codigo    = mab-eqpto.ep-codigo
            and   mab-programac-event.cod-eqpto    = mab-eqpto.cod-eqpto no-lock:
            /*************************************************************************
            **                         Parcelas cont¡nuas
            *************************************************************************/
            ASSIGN i-parcela = 1.
            if mab-programac-event.log-livre-1 = no then do:
                /** Cria data de vencimento e subtrai os dias de antecipa‡Æo **/
                assign dtVencimento = date(integer(substring(mab-programac-event.cod-dia-mes-vencto,3,2)),
                                           integer(substring(mab-programac-event.cod-dia-mes-vencto,1,2)),
                                           year(today)) - mab-programac-event.num-dia.
                /** Verifica se vencimento est  dentro da faixa **/
                if dtVencimento >= tt-param.dataIni and
                   dtVencimento <= tt-param.dataFim and 
                   (dtVencimento + mab-programac-event.num-dia) >= mab-programac-event.dat-inicial and
                   (dtVencimento + mab-programac-event.num-dia) <= mab-programac-event.dat-final   then do:
                    /** Cria os eventos para primeira parcela **/
                    run piEvento in this-procedure.
                end.
                ELSE DO:
                    /** Somente verifica se a primeira parcela ‚ do pr¢ximo ano se nÆo est  
                        sendo solicitado para criar eventos no passado **/
                    IF tt-param.lInferior = NO THEN DO:
                        /** Guarda o dia **/
                        assign i-ano = YEAR(TODAY) + 1
                               iDia  = integer(substring(mab-programac-event.cod-dia-mes-vencto,1,2)).
                        repeat:
                            /** Busca data do pr¢ximo ano **/
                            assign dtVencimento = date(integer(substring(mab-programac-event.cod-dia-mes-vencto,3,2)), 
                                                       iDia, 
                                                       i-ano) no-error.
                            /** Se ocorrer erro, tenta dia anterior **/
                            if error-status:error then iDia = iDia - 1.
                            else leave.
                        END.
                        /** Verifica se vencimento est  dentro da faixa **/
                        if dtVencimento >= tt-param.dataIni and
                           dtVencimento <= tt-param.dataFim and 
                           (dtVencimento + mab-programac-event.num-dia) >= mab-programac-event.dat-inicial and
                           (dtVencimento + mab-programac-event.num-dia) <= mab-programac-event.dat-final   then do:
                            /** Cria os eventos para primeira parcela **/
                            run piEvento in this-procedure.
                        end.
                    END.
                END.
                /** N£mero de parcelas maior que 1 **/
                if mab-programac-event.num-parcela > 1 then do:
                    /***********************************************************
                    ** Percorre  parcelas cont¡nuas seguintes 
                    ***********************************************************/
                    do iCont = 2 to mab-programac-event.num-parcela:
                        ASSIGN i-parcela = i-parcela + 1.
                        /** Guarda o dia **/
                        assign iDia = day(dtVencimento).
                        repeat:
                            /** Busca data do pr¢ximo mˆs **/
                            assign dtVencimento = date(month(date(month(dtVencimento), 1, year(dtVencimento)) + 31), 
                                                       iDia, 
                                                       year(date(month(dtVencimento), 1, year(dtVencimento)) + 31)) no-error.
                            /** Se ocorrer erro, tenta dia anterior **/
                            if error-status:error then iDia = iDia - 1.
                            else leave.
                        end.
                        /** Verifica se vencimento est  dentro da faixa **/
                        if dtVencimento >= tt-param.dataIni and
                           dtVencimento <= tt-param.dataFim and 
                           (dtVencimento + mab-programac-event.num-dia) >= mab-programac-event.dat-inicial and
                           (dtVencimento + mab-programac-event.num-dia) <= mab-programac-event.dat-final   then do:
                            /** Cria os eventos para as outras parcelas **/
                            run piEvento in this-procedure.
                        end.
                    end.
                end.
            end.
            /*************************************************************************
            **                         Parcelas alternadas
            *************************************************************************/
            else do:
               assign icont      = 0
                      i-parcela  = 1.
               IF mab-programac-event.cod-livre-1 <> "":U then do:
                   do icont = 1 to 12:
                       IF substring(mab-programac-event.cod-livre-1,icont,1) = "s":U THEN do:
                           /** Guarda o dia **/
                           assign iDia = mab-programac-event.num-livre-1.
                           repeat:
                               /** Busca data do pr½ximo m¼s **/
                               assign dtVencimento = date(icont, iDia, YEAR(TODAY)) - mab-programac-event.num-dia no-error.
                               /** Se ocorrer erro, tenta dia anterior **/
                               if error-status:error then iDia = iDia - 1.
                               else leave.
                           end.
                           /** Verifica se vencimento est  dentro da faixa **/
                           if dtVencimento >= tt-param.dataIni and
                              dtVencimento <= tt-param.dataFim and 
                              (dtVencimento + mab-programac-event.num-dia) >= mab-programac-event.dat-inicial and
                              (dtVencimento + mab-programac-event.num-dia) <= mab-programac-event.dat-final   then do:
                               /** Cria os eventos para primeira parcela **/
                               run piEvento in this-procedure.
                           end.
                           ELSE DO:
                               /** Guarda o dia **/
                               assign i-ano = YEAR(TODAY) + 1
                                      iDia  = mab-programac-event.num-livre-1.
                               repeat:
                                   /** Busca data do pr½ximo m¼s **/
                                   assign dtVencimento = date(icont, iDia, i-ano) - mab-programac-event.num-dia no-error.
                                   /** Se ocorrer erro, tenta dia anterior **/
                                   if error-status:error then iDia = iDia - 1.
                                   else leave.
                               END.
                               /** Verifica se vencimento est  dentro da faixa **/
                               if dtVencimento >= tt-param.dataIni and
                                  dtVencimento <= tt-param.dataFim and 
                                  (dtVencimento + mab-programac-event.num-dia) >= mab-programac-event.dat-inicial and
                                  (dtVencimento + mab-programac-event.num-dia) <= mab-programac-event.dat-final   then do:
                                   /** Cria os eventos para primeira parcela **/
                                   run piEvento in this-procedure.
                               end.
                           END.
                           ASSIGN i-parcela = i-parcela + 1.
                       END.
                   END.
               END.
            END.
        END.
    end.
end.

/** Finaliza os handles na API **/
run finalizaHandle in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piDescEvento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescEvento Procedure 
PROCEDURE piDescEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Gera a descri‡Æo do evento
------------------------------------------------------------------------------*/
DEFINE VARIABLE cGerado      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEquipamento AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEvento      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVencimento  AS CHARACTER  NO-UNDO.

/** Busca Descri‡Æo do Modelo **/
FOR FIRST mab-eqpto 
    WHERE mab-eqpto.cod-eqpto = mab-programac-event.cod-eqpto NO-LOCK:
    FOR FIRST mab-model
        WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
    END.
END.
/** Busca a Descri‡Æo do Evento **/
FOR FIRST mab-event
    WHERE mab-event.cod-evento = ttEvento.cod-evento NO-LOCK:
END.

{utp/ut-liter.i "Apontamento gerado automaticamente:"}
ASSIGN cGerado = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Equipamento"}
ASSIGN cEquipamento = TRIM(RETURN-VALUE) + ": " + string(mab-programac-event.ep-codigo) + " - " + mab-programac-event.cod-eqpto + " - " + mab-model.des-model.

{utp/ut-liter.i "Evento"}
ASSIGN cEvento = TRIM(RETURN-VALUE) + ": " + STRING(ttEvento.cod-evento) + " - " + mab-event.des-evento.

{utp/ut-liter.i "Vencimento"}
assign cVencimento = trim(return-value) + ": " + string(dtVencimento + mab-programac-event.num-dia).

ASSIGN ttEvento.dsl-obs = cGerado + chr(10) + cEquipamento + CHR(10) + cEvento + CHR(10) + cVencimento.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piElimina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piElimina Procedure 
PROCEDURE piElimina :
/*------------------------------------------------------------------------------
  Purpose:     piElimina
  Parameters:  <none>
  Notes:       Elimina os eventos
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE i-emp   LIKE mab-movto-event.ep-codigo NO-UNDO.
&ELSE
DEFINE VARIABLE i-emp AS INTEGER    NO-UNDO.
&ENDIF
DEFINE VARIABLE c-eqpto AS CHARACTER  NO-UNDO.

/** Inicializa os handle **/
run inicializaHandle in this-procedure.

/**Verifica se elimina algum tipo de evento **/
if tt-param.lVencido or tt-param.lVencer then do:
    /** Busca Movimento de eventos conforme sele‡Æo **/
    for each  mab-movto-event
        where mab-movto-event.ep-codigo    >= tt-param.empIni
        and   mab-movto-event.ep-codigo    <= tt-param.empFim
        and   mab-movto-event.cod-eqpto    >= tt-param.eqptoIni
        and   mab-movto-event.cod-eqpto    <= tt-param.eqptoFim
        and   mab-movto-event.cod-evento   >= tt-param.eventIni
        and   mab-movto-event.cod-evento   <= tt-param.eventFim
        and   mab-movto-event.cod-sub-sist >= tt-param.subIni
        and   mab-movto-event.cod-sub-sist <= tt-param.subFim
        and   mab-movto-event.num-docto    >= tt-param.docIni
        and   mab-movto-event.num-docto    <= tt-param.docFim
        and   mab-movto-event.dat-inicial  >= tt-param.dataIni
        and   mab-movto-event.dat-inicial  <= tt-param.dataFim 
        and   mab-movto-event.dat-final     = ?   /** Eventos terminados **/
        and   not(mab-movto-event.log-disparad)   /** Eventos nÆo iniciados **/
        NO-LOCK:

        /** Valida Unidade de Negocio, caso impladada. **/
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT(mab-movto-event.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                       mab-movto-event.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
            END.
        &ENDIF

        /** Eventos vencidos **/
        if mab-movto-event.dat-aviso <= today then do:
            /** NÆo eliminar Vencidos **/
            if not(tt-param.lVencido) then next.
        end.
        /** Eventos a vencer **/
        else
            /** NÆo eliminar a Vencer **/
            if not(tt-param.lVencer) then next.

            ASSIGN i-emp = mab-movto-event.ep-codigo
                   c-eqpto = mab-movto-event.cod-eqpto.

        /** Posiciona a BO no registro a ser eliminado **/
        RUN repositionRecord IN hDBOEvento (INPUT ROWID(mab-movto-event)).
        IF RETURN-VALUE = "OK":U THEN DO:
            
            /** Limpa temp-tables de erros **/
            run emptyRowErrors in hDBOEvento.

            /** Executa valida‡äes e elimina o registro **/
            RUN deleteRecord IN hDBOEvento.
            IF RETURN-VALUE = "NOK":U THEN DO:

                /** Busca Erros da BO **/
                run getRowErrors in hDBOEvento (output table RowErrorsAux).
                for each RowErrorsAux 
                    where RowErrorsAux.ErrorType <> "INTERNAL":U no-lock:
                    /** Cria erros na BO **/
                    create RowErrorsEqpto.
                    buffer-copy RowErrorsAux to RowErrorsEqpto.
                    ASSIGN RowErrorsEqpto.ep-codigo = i-emp
                           RowErrorsEqpto.cod-eqpto = c-eqpto.
                end.
            END.
        END.
    end.
end.

/** Finaliza os handles na API **/
run finalizaHandle in this-procedure.

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
  Parameters:  entrada pUsuario = Usu rio corrente 
  Notes:       Cria evento para avisar manuten‡Æo.
------------------------------------------------------------------------------*/
/** Limpa ttEvento **/
empty temp-table ttEvento.

/** Cria registro Temp-Table **/
create ttEvento.
/** Salva campos  **/
run buscaDocumento in hDBOEvento (output ttEvento.num-docto).
assign ttEvento.num-docto-orig = 0
       ttEvento.ep-codigo      = mab-programac-event.ep-codigo
       ttEvento.cod-eqpto      = mab-programac-event.cod-eqpto
       ttEvento.cod-evento     = mab-programac-event.cod-evento
       ttEvento.dat-aviso      = dtVencimento
       ttEvento.hra-inicial    = "000000":U
       ttEvento.dat-final      = ?
       ttEvento.hra-final      = "000000":U
       ttEvento.val-km-aviso   = 999999
       ttEvento.val-evento     = 0
       ttEvento.cod-ofici      = ""
       ttEvento.log-disparad   = no
       ttEvento.num-parc-event = IF mab-programac-event.log-livre-1 THEN i-parcela ELSE mab-programac-event.num-parcela
       ttEvento.cod-usuar      = c-seg-usuario.

/** Valida Unidade de Negocio, caso impladada. **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        FOR LAST mab-histor-ativid
            WHERE mab-histor-ativid.ep-codigo     = mab-eqpto.ep-codigo
            AND   mab-histor-ativid.cod-eqpto     = mab-eqpto.cod-eqpto
            AND   mab-histor-ativid.dat-cadastro <= dtVencimento NO-LOCK:
            ASSIGN ttEvento.cod-unid-negoc = mab-histor-ativid.cod-unid-negoc.
        END.
        IF  NOT AVAIL mab-histor-ativid THEN
            ASSIGN ttEvento.cod-unid-negoc = mab-eqpto.cod-unid-negoc.
    END.
&ENDIF

/** Busca indicador de evento **/
if not avail mab-event or mab-event.cod-evento <> mab-programac-event.cod-evento then do:
    for first mab-event fields(cod-evento idi-valor log-integr-ap cod-livre-1 ct-despesa)
        where mab-event.cod-evento = mab-programac-event.cod-evento no-lock:
    end.
end.
if avail mab-event then do:
    assign iGera    = mab-event.idi-valor.
    if mab-event.log-integr-ap then do:
       assign ttEvento.ct-despesa = mab-event.ct-despesa  
              ttEvento.cc-despesa = mab-eqpto.cc-codigo.                        
    end.                                                                        
end.                                                                            
case iGera:                                                                     
    /** NÆo gera valor **/
    when 1 then do:
        for each  mab-param fields(des-valor cdn-param)
            where mab-param.cdn-param = 27 
            or    mab-param.cdn-param = 29 no-lock:
            case mab-param.cdn-param:
                when 27 then assign ttEvento.cd-tipo      = integer(mab-param.des-valor).
                when 29 then assign ttEvento.cod-sub-sist = mab-param.des-valor.
            end case.
        end.        
        ASSIGN ttEvento.dat-inicial = TODAY. 
    end.
    /** Gera receita ou despesa **/
    when 2 or when 3 then do:
        assign ttEvento.cd-tipo      = 0
               ttEvento.cod-sub-sist = ""
               ttEvento.dat-inicial  = dtVencimento.
    end.
end case.
/* Gera Descri‡Æo do Evento */
RUN piDescEvento IN THIS-PROCEDURE.

/****************************************
** EPC para Movimento de Evento
***************************************/
RUN pi-epc-movto-evento IN THIS-PROCEDURE.

/** Verifica se j  existe movimento evento para equipamento **/
if not can-find(first mab-movto-event
                where mab-movto-event.ep-codigo  = ttEvento.ep-codigo
                and   mab-movto-event.cod-eqpto  = ttEvento.cod-eqpto
                and   mab-movto-event.cod-evento = ttEvento.cod-evento
                and   mab-movto-event.dat-aviso  = ttEvento.dat-aviso) then do:
    /*--- Cria Evento em tabela passando pelas valida‡äes ---*/
    RUN criaEvento IN hDBOEvento (INPUT TABLE ttEvento).
    if return-value = "NOK":U then do:
        /** Busca Erros da BO **/
        run getRowErrors in hDBOEvento (output table RowErrorsAux).
        FOR EACH RowErrorsAux
           WHERE RowErrorsAux.errorNumber = 3  /*erro de navega‡Æo na query*/
              OR RowErrorsAux.errorNumber = 8  /*erro de navega‡Æo na query*/
              OR RowErrorsAux.errorNumber = 10 /*erro de navega‡Æo na query*/ NO-LOCK:
           DELETE RowErrorsAux.
        END.

        for each RowErrorsAux no-lock:
            create RowErrorsEqpto.
            buffer-copy RowErrorsAux to RowErrorsEqpto.
            ASSIGN RowErrorsEqpto.ep-codigo = ttEvento.ep-codigo  
                   RowErrorsEqpto.cod-eqpto = ttEvento.cod-eqpto. 
        end.
        /** Limpa temp-tables de erros **/
        run emptyRowErrors in hDBOEvento.
        return "NOK":U.
    end.
    else 
        /** Guarda eventos criados **/
        if tt-param.lResumo then do:
            create ttCriados.
            buffer-copy ttEvento to ttCriados.
        end.
end.

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
  Notes:       Inicializa‡Æo da API
------------------------------------------------------------------------------*/
for first tt-param no-lock: end.
if not avail tt-param then do:
    run piCriaErro (1454, 'EMS':U, '').
    return "NOK":U.
end.

case tt-param.iAcao:
    /** Cria‡Æo de eventos **/
    when 1 then do:
        run piCriacao in this-procedure.
    end.
    /** Elimina‡Æo de eventos **/
    when 2 then do:
        run piElimina in this-procedure.
    end.
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

