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
{include/i-prgvrs.i ABAPI004 2.00.00.005 } /*** "010005" 16/05/2025 17:37:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi004 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI004.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Remonta Motor
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/** Temp-Tables **/
{abp/ab9004.i} /** Defini‡Æo da Temp-table RowErrors **/

define temp-table ttEvento no-undo like mab-movto-event
    field r-rowid as rowid.

define temp-table tt-digita no-undo
    field ep-codigo        like mab-eqpto.ep-codigo
    field cod-eqpto        like mab-eqpto.cod-eqpto
    index id ep-codigo cod-eqpto.

/** Parƒmetros **/
define input  parameter pData as date format "99/99/9999" no-undo.
DEFINE INPUT  PARAMETER pAvisos AS LOGICAL NO-UNDO.
define input  parameter table for tt-digita.
define output parameter table for RowErrors.

/** Vari veis Locais **/
define variable hDBOApont      as   handle                                    no-undo.
define variable hDBOEvento     as   handle                                    no-undo. 
define variable cEventoOleo    like mab-event.cod-evento                      no-undo.
define variable cEventoRemonta like mab-event.cod-evento                      no-undo.
define variable deTolerancia   as   decimal                                   no-undo.
define variable deRemonta      as   decimal                                   no-undo.
define variable deAbastec      as   decimal                                   no-undo.
define variable deInvertida    like mab-abastec-lubrific.val-dat-hora-invrtda NO-UNDO.
define variable deInicial      like mab-abastec-lubrific.val-dat-hora-invrtda NO-UNDO.
define variable cHora          as   character format "99:99:99"               NO-UNDO.

define buffer bfLubrific for mab-item-lubrific.

{utp/ut-glob.i} /** Defini‡Æo do usu rio corrente no EMS **/

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
         HEIGHT             = 11.29
         WIDTH              = 31.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/ab9000.i}    /** ConversÆo de horas **/
{abp/abapi001.i2} /** Cria‡Æo de Erros   **/

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
/** Apontamento **/
if valid-handle(hDBOApont) then
    run destroy in hDBOApont.

/** Movimento Evento **/
if valid-handle(hDBOEvento) then
    run destroy in hDBOEvento.

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
       hDBOApont:FILE-NAME <> "frbo~\bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOApont.
    END.
    RUN openQueryMain IN hDBOApont NO-ERROR.

    /*--- BO Movimento Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr059.p":U THEN DO:
        RUN frbo/bofr059.p PERSISTENT SET hDBOEvento.
    END.
  
    RUN openQueryMain IN hDBOEvento.

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
define variable pDoc as integer no-undo.

/** Limpa ttEvento **/
empty temp-table ttEvento.

/** Verifica percentual **/
if mab-movto-remon.val-perc-remon > mab-comptmento-eqpto.val-perc-remon then do:
    /** Verifica Tolerƒncia dos parƒmetros **/
    if ((mab-movto-remon.val-perc-remon - mab-comptmento-eqpto.val-perc-remon) 
        / mab-comptmento-eqpto.val-perc-remon * 100) > deTolerancia then do:
        /** Cria registro Temp-Table **/
        create ttEvento.
        /** Salva campos  **/
        run buscaDocumento in hDBOEvento (output ttEvento.num-docto).
        assign ttEvento.num-docto-orig = mab-abastec-lubrific.num-docto
               ttEvento.ep-codigo      = mab-abastec-lubrific.ep-codigo
               ttEvento.cod-eqpto      = mab-abastec-lubrific.cod-eqpto
               ttEvento.cod-sub-sist   = mab-comptmento-eqpto.cod-sub-sist
               ttEvento.dat-aviso      = today
               ttEvento.dat-inicial    = today
               ttEvento.dat-final      = ?
               ttEvento.hra-final      = "000000":U
               ttEvento.val-km-aviso   = 0
               ttEvento.val-evento     = 0
               ttEvento.cod-ofici      = ""
               ttEvento.log-disparad   = no
               ttEvento.cod-usuar      = c-seg-usuario.
        /** Busca a hora atual **/
        run piFormataSegundoParaHora (input  time,
                                      output ttEvento.hra-inicial).
        for each  mab-param fields(des-valor cdn-param)
            where mab-param.cdn-param = 19 
            or    mab-param.cdn-param = 21 no-lock:
            case mab-param.cdn-param:
                when 19 then assign ttEvento.cod-evento = mab-param.des-valor.
                when 21 then assign ttEvento.cd-tipo    = integer(mab-param.des-valor).
            end case.
        end.
        run utp/ut-msgs.p (input 'msg':U,
                           input 28506,
                           input string(mab-movto-remon.val-perc-remon) + '~~' +
                                 string(mab-comptmento-eqpto.val-perc-remon)).
        assign ttEvento.dsl-obs = return-value.
        /** Verifica se j  existe movimento evento para equipamento **/
        run consisteInclusaoDocto in hDBOEvento (input  ttEvento.ep-codigo,
                                                 input  ttEvento.cod-eqpto,
                                                 input  ttEvento.cod-evento,
                                                 input  ttEvento.cod-sub-sist,
                                                 output pDoc).
        if return-value = "NOK":U then
            return "NOK":U.
        /*--- Cria Evento em tabela passando pelas valida‡äes ---*/
        RUN criaEvento IN hDBOEvento (INPUT TABLE ttEvento).
        if return-value = "NOK":U then do:
            /** Busca Erros da BO **/
            run getRowErrors in hDBOEvento (output table RowErrors).
            /** Limpa temp-tables de erros **/
            run emptyRowErrors in hDBOEvento.
            return "NOK":U.
        end.
    end. /** Tolerƒncia **/
end.  /** Percentual **/

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
/** Inicializa‡Æo de BOs **/
run initializeHandle in this-procedure.
/** Valida‡äes Iniciais **/
run piValidaInicial in this-procedure.
if return-value <> "NOK":U then do:
    /** Processa Atualiza‡äes **/
    run piProcessaRemonta in this-procedure.
end.
/** Elimina Handles da mem¢ria **/
run finalizaHandle in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessaRemonta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessaRemonta Procedure 
PROCEDURE piProcessaRemonta :
/*------------------------------------------------------------------------------
  Purpose:     piProcessaRemonta
  Parameters:  <none>
  Notes:       Processa a remonta do motor
  
  
Regra para gerar Evento de Remonta isso somente ocorre quando o parametro "Gerar Eventos de Aviso" que esta esta no ab0404 for selecionado

Exemplo do calculo realizado:
Equipamento	Data          Quantidade Combustivel	Oleo	Quantidade Oleo
2.000	    01/01/2004	  	                        Troca	    3,00 litros
2.000	    02/01/2004   	    40,00               Remonta     0,50 litros
2.000	    03/01/2004  		50,00     
2.000	    04/01/2004  	    55,00               Remonta	    0,50 litros
2.000	    05/01/2004  		50,00     
2.000	    06/01/2004  		40,00     
2.000	    07/01/2004  	    50,00             	Remonta 	0,50 litros
2.000	    08/01/2004  		50,00     
2.000	    09/01/2004	        40,00               Troca       3,00 litros

Com o historico acima, pode-se notar que entre uma troca de oleo e outra, o equipamento consumiu 375 litros de combustivel e 1,50 litros de oleo foram remontados (completados).
Dessa forma, dividindo-se a quantidade de oleo sobre a quantidade de combustivel temos: % Remonta oleo Motor = 0,40%.

Se no momento do calculo, o sistema verificar que houve uma % de remonta de oleo acima do valor informado como padrao, serÿ criado um Apontamento de Evento (AB0303)
para verificar o compartimento.

Importante: Uma vez calculado o percentual de remonta entre uma troca de oleo e outras ² realizada as seguintes validacoes para poder gerar os eventos:
1 - Verifica se o percentual entre as trocas de oleo ² maior que o percentual parametrizado para o compartimento no AB0138 (Folder Comp/Filtro botao modificar),
    ira abrir o AB0138C, no cadastro do pai (Componente) tem a opcao " % Remonta";
2 - Depois realiza o seguinte calculo:
((<Percentual de remonta entre trocas> - <Percentual cadastrado para o Componente 'AB0138C'>) 
        / <Percentual cadastrado para o Componente 'AB0138C'> * 100) > deTolerancia)

Obs.: deTolerancia: e o percentual paramentrizado no ab0101 parametro 22
  
------------------------------------------------------------------------------*/
/** Busca Parƒmetros **/
for each  mab-param fields(cdn-param des-valor)
    where mab-param.cdn-param = 17
    or    mab-param.cdn-param = 18
    or    mab-param.cdn-param = 19
    or    mab-param.cdn-param = 21
    or    mab-param.cdn-param = 22 no-lock:
    case mab-param.cdn-param:
        /** Evento Troca àleo **/
        when 17 then assign cEventoOleo    = mab-param.des-valor.
        /** Evento Remonta àleo **/
        when 18 then assign cEventoRemonta = mab-param.des-valor.
        /** Tolerƒncia m xima no desvio de remonta motor x padrÆo **/
        when 22 then assign deTolerancia   = decimal(mab-param.des-valor).
    end case.
end.

/** Atualiza o campo hora invertida. Ser  gravado no 
    formato "AAAAMMDDHHMM" (Ano+Mˆs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida (input  string(pData,"99/99/9999"),
                               input  "235959":U,
                               output deInvertida).

/** Percorre equipamentos **/
for each tt-digita no-lock:
    for each  mab-comptmento-eqpto
        where mab-comptmento-eqpto.ep-codigo      = tt-digita.ep-codigo
        and   mab-comptmento-eqpto.cod-eqpto      = tt-digita.cod-eqpto 
        and   mab-comptmento-eqpto.val-perc-remon > 0 no-lock:
        /** Compartimento nÆo cadastrado, vai para pr¢ximo registro  **/
        if not can-find(first mab-comptmento
                        where mab-comptmento.cod-comptmento = mab-comptmento-eqpto.cod-comptmento no-lock) then next.
        /** Compartimento nÆo motor, vai para pr¢ximo registro  **/
        if can-find(first mab-comptmento
                    where mab-comptmento.cod-comptmento = mab-comptmento-eqpto.cod-comptmento 
                    and   not(mab-comptmento.log-motor) no-lock) then next.
        /** Busca éltima Lubrifica‡Æo para equipamento **/
        FOR first mab-item-lubrific
            where mab-item-lubrific.ep-codigo             = mab-comptmento-eqpto.ep-codigo
            and   mab-item-lubrific.cod-eqpto             = mab-comptmento-eqpto.cod-eqpto
            and   mab-item-lubrific.cod-comptmento        = mab-comptmento-eqpto.cod-comptmento
            and   mab-item-lubrific.cod-evento            = cEventoOleo 
            and   mab-item-lubrific.val-dat-hora-invrtda <= deInvertida NO-LOCK:
        END.
        IF AVAIL mab-item-lubrific THEN DO:
            for EACH  mab-item-lubrific
                where mab-item-lubrific.ep-codigo             = mab-comptmento-eqpto.ep-codigo
                and   mab-item-lubrific.cod-eqpto             = mab-comptmento-eqpto.cod-eqpto
                and   mab-item-lubrific.cod-comptmento        = mab-comptmento-eqpto.cod-comptmento
                and   mab-item-lubrific.cod-evento            = cEventoOleo 
                and   mab-item-lubrific.val-dat-hora-invrtda <= deInvertida no-lock
                BY    mab-item-lubrific.val-dat-hora-invrtda DESC:
                /** Busca Apontamento anterior de lubrifica‡Æo **/
                FOR first bfLubrific
                    where bfLubrific.ep-codigo             = mab-item-lubrific.ep-codigo
                    and   bfLubrific.cod-eqpto             = mab-item-lubrific.cod-eqpto
                    and   bfLubrific.cod-comptmento        = mab-item-lubrific.cod-comptmento
                    and   bfLubrific.cod-evento            = mab-item-lubrific.cod-evento 
                    and   bfLubrific.val-dat-hora-invrtda  < mab-item-lubrific.val-dat-hora-invrtda NO-LOCK:
                END.
                IF AVAIL bfLubrific THEN DO:
                    for last  bfLubrific
                        where bfLubrific.ep-codigo             = mab-item-lubrific.ep-codigo
                        and   bfLubrific.cod-eqpto             = mab-item-lubrific.cod-eqpto
                        and   bfLubrific.cod-comptmento        = mab-item-lubrific.cod-comptmento
                        and   bfLubrific.cod-evento            = mab-item-lubrific.cod-evento 
                        and   bfLubrific.val-dat-hora-invrtda  < mab-item-lubrific.val-dat-hora-invrtda no-lock:
                        assign deInicial = bfLubrific.val-dat-hora-invrtda.
                    end.
                end.
                /** Utiliza data de in¡cio do equipamento **/
                else do:
                    for first mab-eqpto
                        where mab-eqpto.ep-codigo = tt-digita.ep-codigo
                        and   mab-eqpto.cod-eqpto = tt-digita.cod-eqpto no-lock:
                        /** ConversÆo data invertida **/
                        run converteParaHoraInvertida (input  string(mab-eqpto.dat-inicial,"99/99/9999"),
                                                       input  "000000":U,
                                                       output deInicial).
                    end.
                end.
                assign deRemonta = 0
                       deAbastec = 0.
                /** Busca Remontas de ¢leo no per¡odo **/
                for each  bfLubrific
                    where bfLubrific.ep-codigo             = mab-item-lubrific.ep-codigo
                    and   bfLubrific.cod-eqpto             = mab-item-lubrific.cod-eqpto
                    and   bfLubrific.cod-comptmento        = mab-item-lubrific.cod-comptmento
                    and   bfLubrific.cod-evento            = cEventoRemonta 
                    and   bfLubrific.val-dat-hora-invrtda  > deInicial
                    and   bfLubrific.val-dat-hora-invrtda  < mab-item-lubrific.val-dat-hora-invrtda no-lock:
                    assign deRemonta = deRemonta + bfLubrific.val-quant.
                end.
                /** Busca Quantidade Abastecida no per¡odo **/
                for each  mab-item-abastec
                    where mab-item-abastec.ep-codigo             = tt-digita.ep-codigo
                    and   mab-item-abastec.cod-eqpto             = tt-digita.cod-eqpto
                    and   mab-item-abastec.log-abastec-prim
                    and   mab-item-abastec.val-dat-hora-invrtda >= deInicial
                    and   mab-item-abastec.val-dat-hora-invrtda <= mab-item-lubrific.val-dat-hora-invrtda no-lock:
                    assign deAbastec = deAbastec + mab-item-abastec.val-quant.
                end.
                /** NÆo grava remonta se ¢leo ou abastecimento = 0 **/
                /** Willwock - Necessita mostrar os per¡odos zerados, para controlar melhor os per¡odos com remonta **/
                /*if (deAbastec = 0) or (deRemonta = 0) then leave.*/

                for first mab-abastec-lubrific
                    where mab-abastec-lubrific.num-docto = mab-item-lubrific.num-docto no-lock:
                    /** Verifica existˆncia de hist¢rico de remonta **/
                    if not can-find(first mab-movto-remon
                                    where mab-movto-remon.ep-codigo      = tt-digita.ep-codigo
                                    and   mab-movto-remon.cod-eqpto      = tt-digita.cod-eqpto
                                    and   mab-movto-remon.cod-comptmento = mab-item-lubrific.cod-comptmento
                                    and   mab-movto-remon.num-docto      = mab-abastec-lubrific.num-docto no-lock) then do:
                        /** Cria‡Æo do hist¢rico de remonta **/
                        create mab-movto-remon.
                        assign mab-movto-remon.num-docto      = mab-abastec-lubrific.num-docto
                               mab-movto-remon.ep-codigo      = tt-digita.ep-codigo
                               mab-movto-remon.cod-eqpto      = tt-digita.cod-eqpto
                               mab-movto-remon.dat-movto      = mab-abastec-lubrific.dat-movto
                               mab-movto-remon.hra-inicial    = mab-abastec-lubrific.hra-inicial
                               mab-movto-remon.cod-comptmento = mab-item-lubrific.cod-comptmento.
                    end.
                    /** Busca Registro **/
                    else
                        find first mab-movto-remon
                             where mab-movto-remon.ep-codigo      = tt-digita.ep-codigo
                             and   mab-movto-remon.cod-eqpto      = tt-digita.cod-eqpto
                             and   mab-movto-remon.cod-comptmento = mab-item-lubrific.cod-comptmento
                             and   mab-movto-remon.num-docto      = mab-abastec-lubrific.num-docto exclusive-lock no-error.
                    /** Atualiza‡Æo das quantidades **/
                    assign mab-movto-remon.qtd-combust          = deAbastec
                           mab-movto-remon.qtd-oleo             = deRemonta
                           mab-movto-remon.val-dat-hora-invrtda = mab-item-lubrific.val-dat-hora-invrtda
                           mab-movto-remon.val-perc-remon       = if   (deAbastec > 0) 
                                                                  then (deRemonta / deAbastec) * 100
                                                                  else 0.
                    /** Confirma cria‡Æo/altera‡Æo registro **/
                    validate mab-movto-remon.
                    /* Somente criar eventos de avisos se estiver selecionado no programa AB0404 para tal */
                    IF pAvisos THEN DO:
                        /** Cria‡Æo de eventos **/
                        run piEvento in this-procedure.
                    END.
                end.
            end.
        end.
        /** NÆo encontrada lubrifica‡Æo, vai para pr¢ximo registro **/
        else next.
    end.
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
  Notes:       Valida‡äes Iniciais para atualiza‡äes de apontamentos
------------------------------------------------------------------------------*/
/** Valida Parƒmetros **/
run piValidaParametroAbastecimento in hDBOApont (input "17,18,19,21,22").
if return-value = "NOK":U then do:
    /** Busca Erros da BO **/
    run getRowErrors in hDBOApont (output table RowErrors).
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOApont.
    return "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

