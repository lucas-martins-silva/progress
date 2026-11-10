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
{include/i-prgvrs.i ABAPI007 2.00.00.006 } /*** "010006" ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi007 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI007.p
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Eliminaá∆o / Geraá∆o / Atualizaá∆o Percurso Rodado por
**                 equipamentos n∆o Motorizados
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */
/***************** Temp-Tables ******************/
{abp/abapi007.i}           /** Temp-Table ttKM da mab-movto-km-eqpto (auxiliar) **/
{abp/ab9004.i}             /** Temp-table RowErrors **/
/** Erros da BO de KM **/
define temp-table RowErrorsKM  no-undo like RowErrors.
/** Erros de Importaá∆o **/
define temp-table RowErrorsAux no-undo like RowErrors
    field i-linha as integer.
/** Percurso Viagens **/
define temp-table ttPercurso no-undo
    field ep-codigo   like mab-eqpto.ep-codigo
    field cod-eqpto   like mab-eqpto.cod-eqpto
    field dat-movto   like mab-movto-km-eqpto.dat-movto
    field de-percurso like mab-movto-km-eqpto.val-km-real
    field de-km-ini   like mab-movto-km-eqpto.val-km-real
    index id is unique primary ep-codigo
                               cod-eqpto
                               dat-movto.

/***************** ParÉmetros *******************/
define input parameter table for tt-param.

/***************** Vari†veis ********************/
define variable deKM as decimal no-undo.

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
         HEIGHT             = 11.54
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/abapi001.i2} /** Criaá∆o de Erros **/
{abp/ab9000.i}    /** Convers∆o de Horas **/

/** Busca os ParÉmetros recebidos **/
for first tt-param no-lock:
end.
/** Validaá‰es nos par∆metros passados **/
run validaInicial in this-procedure.
if return-value = "NOK":U then
    return "NOK":U.

if this-procedure:persistent then
    return "OK":U.

case tt-param.i-origem:
    /** Importaá∆o de Percurso **/
    when 1 then
        /** A API sempre deve estar rodando persistente **/
        if not(this-procedure:persistent) then
            return "NOK":U.
    /** Geraá∆o de Percurso **/
    when 2 then
        run iniciaGeracao in this-procedure (input ?).
    /** Geraá∆o de Percurso por Viagens **/
    when 3 then
        run iniciaGeracaoViagem in this-procedure (input ?).
end case.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-chamaBO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chamaBO Procedure 
PROCEDURE chamaBO :
/*------------------------------------------------------------------------------
  Purpose:     chamaBO
  Parameters:  entrada pAcao = Aá∆o a ser feita (1 = Criaá∆o  /  2 = Eliminaá∆o)
  Notes:       Chama a BO de KM para manutená∆o na tabela
------------------------------------------------------------------------------*/
define input parameter pAcao as integer no-undo.

define variable hDBOKM as handle  no-undo.
define variable iErro  as integer no-undo.

if can-find(first ttKMEqpto no-lock) then do:

    /*--- BO Quilometragem ---*/
    IF NOT VALID-HANDLE(hDBOKM) OR
       hDBOKM:TYPE <> "PROCEDURE":U OR
       hDBOKM:FILE-NAME <> "frbo/bofr060.p":U THEN DO:
        run frbo/bofr060.p persistent set hDBOKM.
    END.
    
    if pAcao = 1 then
        /** Criaá∆o da Quilometragem **/
        run criaKM in hDBOKM (input table ttKMEqpto).
    else
        /** Eliminaá∆o da Quilometragem **/
        run deleteKM in hDBOKM (input table ttKMEqpto).
    
    if return-value = "NOK":U then do:
        /** Busca Erros da BO **/
        run getRowErrors in hDBOKM (output table RowErrorsKM).
        /** Limpa temp-tables de erros **/
        run emptyRowErrors in hDBOKM.
    end.
    
    /** Quilometragem **/
    if valid-handle(hDBOKM) then
        run destroy in hDBOKM.
end.

assign iErro = 0.
/** Erros de importaá∆o **/
if tt-param.i-origem = 1 then do:
    /** Busca £ltimo erro criado na BO **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    end.
    /** Percorre os erros da API **/
    for each RowErrorsKM no-lock:
        /** Cria eros na BO **/
        create RowErrorsAux.
        buffer-copy RowErrorsKM except ErrorSequence to RowErrorsAux
            /** Coloca sequància **/
            assign RowErrorsAux.ErrorSequence = iErro + 1.
        assign iErro = RowErrorsAux.ErrorSequence.
    end.
end.
else do:

    /** Busca £ltimo erro criado na BO **/
    for last RowErrors no-lock:
        assign iErro = RowErrors.ErrorSequence.
    end.
    /** Percorre os erros da API **/
    for each RowErrorsKM no-lock:
        /** Cria eros na BO **/
        create RowErrors.
        buffer-copy RowErrorsKM except ErrorSequence to RowErrors
            /** Coloca sequància **/
            assign RowErrors.ErrorSequence = iErro + 1.
        assign iErro = RowErrors.ErrorSequence.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excluiKM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excluiKM Procedure 
PROCEDURE excluiKM :
/*------------------------------------------------------------------------------
  Purpose:     excluiKM
  Parameters:  entrada pEqptoIni = C¢digo Equipamento Inicial
               entrada pEqptoFim = C¢digo Equipamento Final
  Notes:       Exclui os movimentos de quilometragem dos equipamentos n∆o 
               motorizados conforme faixa passada.
------------------------------------------------------------------------------*/
/** Somente Ç passado este parÉmetro, por causa da importaá∆o de KM, 
    que n∆o utiliza esta faixa **/
define input parameter pEqptoIni as character no-undo.
define input parameter pEqptoFim as character no-undo.

empty temp-table ttKMEqpto.

&IF DEFINED(bf_mnt_ems206b) &THEN
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto cod-unid-negoc)
&ELSE
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto)
&ENDIF
    where mab-eqpto.ep-codigo     >= tt-param.empIni
    and   mab-eqpto.ep-codigo     <= tt-param.empFim
    and   mab-eqpto.cod-eqpto     >= pEqptoIni
    and   mab-eqpto.cod-eqpto     <= pEqptoFim
    and   mab-eqpto.idi-tip-eqpto  = 2  /** N∆o Motorizados **/
    and   mab-eqpto.cod-estabel   >= tt-param.estabIni
    and   mab-eqpto.cod-estabel   <= tt-param.estabFim
    and   mab-eqpto.cod-grp-eqpto >= tt-param.grupoIni
    and   mab-eqpto.cod-grp-eqpto <= tt-param.grupoFim
    and   mab-eqpto.cod-model     >= tt-param.modeloIni
    and   mab-eqpto.cod-model     <= tt-param.modeloFim no-lock:

    /** Valida Unidade de Negocio, caso impladada. **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            IF NOT(mab-eqpto.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                   mab-eqpto.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        END.
    &ENDIF
    
    /** Somente verifica a Unidade para a geraá∆o do percurso **/
    if tt-param.i-origem = 2 then do:
        if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then
            for first mab-model fields(cod-model un)
                where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            end.
        /** Se a unidade do modelo for diferente do parametrizado em tela, 
            busca o pr¢ximo equipamento **/
        if avail mab-model and mab-model.un <> tt-param.un then
            next.
    end.
    /** Elimina todo o hist¢rico de Quilometragem do Equipamento com 
        data Posterior a Parametrizada **/
    for each  mab-movto-km-eqpto
        where mab-movto-km-eqpto.ep-codigo  = mab-eqpto.ep-codigo
        and   mab-movto-km-eqpto.cod-eqpto  = mab-eqpto.cod-eqpto
        and   mab-movto-km-eqpto.dat-movto >= tt-param.dtInicial 
        AND   mab-movto-km-eqpto.num-docto   = 0 no-lock:
        create ttKMEqpto.
        buffer-copy mab-movto-km-eqpto to ttKMEqpto
            assign ttKMEqpto.r-rowid = rowid(mab-movto-km-eqpto).
    end.
end.

/** Chama BO para eliminaá∆o **/
run chamaBO in this-procedure (input 2). /** 1 = Criaá∆o / 2 = Eliminaá∆o **/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrors Procedure 
PROCEDURE getRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     getRowErrors
  Parameters:  sa°da RowErrors = Erros de Geraá∆o de Percurso
  Notes:       Retorna os erros de geraá∆o de percurso ocorridos na API
------------------------------------------------------------------------------*/
define output parameter table for RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrorsAux) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrorsAux Procedure 
PROCEDURE getRowErrorsAux :
/*------------------------------------------------------------------------------
  Purpose:     getRowErrorsAux
  Parameters:  sa°da RowErrorsAux = Erros de Importaá∆o
  Notes:       Retorna os erros de importaá∆o ocorridos na API
------------------------------------------------------------------------------*/
define output parameter table for RowErrorsAux.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-iniciaGeracao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniciaGeracao Procedure 
PROCEDURE iniciaGeracao :
/*------------------------------------------------------------------------------
  Purpose:     iniciaGeracao
  Parameters:  entrada pAcomp = Acompanhamento do programa
  Notes:       Geraá∆o de percurso de equipamentos n∆o motorizados conforme 
               per°odo e percurso informados em tela
------------------------------------------------------------------------------*/
define input parameter pAcomp as handle no-undo.

define variable dePercurso  as decimal                       no-undo.
define variable dtAux       as date    format "99/99/9999"   no-undo.
define variable deInvertida as decimal format "999999999999" no-undo.

if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Excluindo Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Eliminaá∆o dos Movimentos **/
run excluiKM in this-procedure (input tt-param.eqptoIni,
                                input tt-param.eqptoFim).

/** Percurso Por dia **/
if tt-param.iTpPercurso = 1 then
    assign dePercurso = tt-param.dePercurso.
/** Percurso Total do Per°odo **/
else
    /** Valor Percurso informado dividido pelo n£mero de dias do per°odo **/
    /** Diminuir 1 da data inicial, para contar a mesma junto com o total de dias do per°odo **/
    assign dePercurso = tt-param.dePercurso / (tt-param.dtFinal - (tt-param.dtInicial - 1)).

empty temp-table ttKMEqpto.

&IF DEFINED(bf_mnt_ems206b) &THEN
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto val-km-inicial dat-situacao cod-unid-negoc)
&ELSE
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto val-km-inicial dat-situacao)
&ENDIF
    where mab-eqpto.ep-codigo     >= tt-param.empIni
    and   mab-eqpto.ep-codigo     <= tt-param.empFim
    and   mab-eqpto.cod-eqpto     >= tt-param.eqptoIni
    and   mab-eqpto.cod-eqpto     <= tt-param.eqptoFim
    and   mab-eqpto.idi-tip-eqpto  = 2  /** N∆o Motorizados **/
    and   mab-eqpto.cod-estabel   >= tt-param.estabIni
    and   mab-eqpto.cod-estabel   <= tt-param.estabFim
    and   mab-eqpto.cod-grp-eqpto >= tt-param.grupoIni
    and   mab-eqpto.cod-grp-eqpto <= tt-param.grupoFim
    and   mab-eqpto.cod-model     >= tt-param.modeloIni
    and   mab-eqpto.cod-model     <= tt-param.modeloFim no-lock:

    /** Valida Unidade de Negocio, caso impladada. **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            IF NOT(mab-eqpto.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                   mab-eqpto.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        END.
    &ENDIF

    /** O equipamento est† desativado, ent∆o n∆o gera quilometragem para equipamento **/
    if mab-eqpto.dat-situacao <> ? and mab-eqpto.dat-situacao < tt-param.dtInicial then
        next.

    /** Busca a Unidade do Modelo **/
    if not avail mab-model or mab-model.cod-model <> mab-eqpto.cod-model then
        for first mab-model fields(cod-model un)
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
        end.
    /** Se a unidade do modelo for diferente do parametrizado em tela, 
        busca o pr¢ximo equipamento **/
    if avail mab-model and mab-model.un <> tt-param.un then
        next.

    /** Busca Quilometragem anterior **/
    if can-find(first mab-movto-km-eqpto
                where mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
                and   mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto
                and   mab-movto-km-eqpto.dat-movto < tt-param.dtInicial no-lock) then
        for last  mab-movto-km-eqpto fields(val-km-real)
            where mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
            and   mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto
            and   mab-movto-km-eqpto.dat-movto < tt-param.dtInicial no-lock:
            /** KM do movimento anterior **/
            assign deKM = mab-movto-km-eqpto.val-km-real.
        end.
    else
        /** Se n∆o existir, busca KM inicial do equipamento **/
        assign deKM = mab-eqpto.val-km-inicial.
    if valid-handle(pAcomp) then do:
        {utp/ut-liter.i "Gerando Quilometragem"}
        run pi-acompanhar in pAcomp (input trim(return-value) + ': ' + string(mab-eqpto.ep-codigo) + '-' + mab-eqpto.cod-eqpto).
    end.
    /** Percorre o per°odo **/
    do dtAux = tt-param.dtInicial to tt-param.dtFinal:
        /** O equipamento est† desativado, ent∆o n∆o gera quilometragem a partir desta data **/
        if mab-eqpto.dat-situacao <> ? and mab-eqpto.dat-situacao < dtAux then
            leave.
        run converteParaHoraInvertida (input  string(dtAux,"99/99/9999"),
                                       input  "000000",
                                       output deInvertida).
        /** Criaá∆o do registro da Temp-Table de Quilometragem **/
        create ttKMEqpto.
        assign ttKMEqpto.ep-codigo            = mab-eqpto.ep-codigo
               ttKMEqpto.cod-eqpto            = mab-eqpto.cod-eqpto
               ttKMEqpto.val-dat-hora-invrtda = deInvertida
               ttKMEqpto.dat-movto            = dtAux
               ttKMEqpto.hra-inicial          = "000000"
               ttKMEqpto.idi-origem           = 1  /** Abastecimento **/
               ttKMEqpto.num-docto            = 0
               ttKMEqpto.log-abastec-prim     = no
               ttKMEqpto.val-hodom-horim      = deKM + dePercurso
               ttKMEqpto.val-km-real          = deKM + dePercurso
               ttKMEqpto.cod-livre-1          = "KM:" + STRING(dePercurso) /*Inserido o valor o percurso para facilitar um possivel acerto de base*/
               deKM                           = ttKMEqpto.val-km-real.
    end.
end.
if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Gerando Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Chama BO para criaá∆o **/
run chamaBO in this-procedure (input 1). /** 1 = Criaá∆o / 2 = Eliminaá∆o **/

if can-find(first RowErrors) then
    return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-iniciaGeracaoViagem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniciaGeracaoViagem Procedure 
PROCEDURE iniciaGeracaoViagem :
/*------------------------------------------------------------------------------
  Purpose:     iniciaGeracaoViagem
  Parameters:  entrada pAcomp = Acompanhamento do programa
  Notes:       Inicia a geraá∆o do percurso dos equipamentos n∆o motorizados
               atravÇs dos registros de viagens do eqptos.
------------------------------------------------------------------------------*/
define input parameter pAcomp as handle no-undo.

define variable deInvertIni as decimal format "999999999999" no-undo.
define variable deInvertFim as decimal format "999999999999" no-undo.
define variable deInvertida as decimal format "999999999999" no-undo.
define variable dePercurso  as decimal                       no-undo.

if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Excluindo Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Eliminaá∆o dos Movimentos **/
run excluiKM in this-procedure (input tt-param.eqptoIni,
                                input tt-param.eqptoFim).

/** Cria Data/Hora Invertida para per°odo da tela **/
run converteParaHoraInvertida (input  string(tt-param.dtInicial,"99/99/9999"),
                               input  "000000",
                               output deInvertIni).
run converteParaHoraInvertida (input  string(tt-param.dtFinal,"99/99/9999"),
                               input  "235959",
                               output deInvertFim).

empty temp-table ttKMEqpto.

if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Gerando Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
&IF DEFINED(bf_mnt_ems206b) &THEN
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto val-km-inicial dat-situacao cod-unid-negoc)
&ELSE
for each  mab-eqpto fields(cod-model ep-codigo cod-eqpto val-km-inicial dat-situacao)
&ENDIF
    where mab-eqpto.ep-codigo     >= tt-param.empIni
    and   mab-eqpto.ep-codigo     <= tt-param.empFim
    and   mab-eqpto.cod-eqpto     >= tt-param.eqptoIni
    and   mab-eqpto.cod-eqpto     <= tt-param.eqptoFim
    and   mab-eqpto.idi-tip-eqpto  = 2  /** N∆o Motorizados **/
    and   mab-eqpto.cod-estabel   >= tt-param.estabIni
    and   mab-eqpto.cod-estabel   <= tt-param.estabFim
    and   mab-eqpto.cod-grp-eqpto >= tt-param.grupoIni
    and   mab-eqpto.cod-grp-eqpto <= tt-param.grupoFim
    and   mab-eqpto.cod-model     >= tt-param.modeloIni
    and   mab-eqpto.cod-model     <= tt-param.modeloFim no-lock:

    /** Valida Unidade de Negocio, caso impladada. **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            IF NOT(mab-eqpto.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                   mab-eqpto.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        END.
    &ENDIF

    /** O equipamento est† desativado, ent∆o n∆o gera quilometragem para equipamento **/
    if mab-eqpto.dat-situacao <> ? and mab-eqpto.dat-situacao < tt-param.dtInicial then
        next.
    /** Percorre todos os implementos de viagem no per°odo de tela, verificando a data de retirada **/
    implemento:
    for each  mab-viagem-implto fields(num-viagem)
        where mab-viagem-implto.ep-codigo                   = mab-eqpto.ep-codigo
        and   mab-viagem-implto.cod-eqpto                   = mab-eqpto.cod-eqpto
        and   mab-viagem-implto.val-dat-hora-invrtda-final >= deInvertIni
        and   mab-viagem-implto.val-dat-hora-invrtda-final <= deInvertFim no-lock:
        /** Busca registro da viagem **/
        if not avail mab-viagem or mab-viagem.num-viagem <> mab-viagem-implto.num-viagem then
            for first mab-viagem fields(num-viagem dat-ret val-hodom-horim-final val-hodom-horim-inicial)
                where mab-viagem.num-viagem = mab-viagem-implto.num-viagem no-lock:
            end.
        if avail mab-viagem then do:
            /** O equipamento est† desativado, ent∆o n∆o gera quilometragem para equipamento a partir desta data **/
            if mab-eqpto.dat-situacao <> ? and mab-eqpto.dat-situacao < mab-viagem.dat-ret then
                leave implemento.
            /** Cria apenas um registro por dia **/
            if not can-find(first ttPercurso
                            where ttPercurso.ep-codigo  = mab-eqpto.ep-codigo
                            and   ttPercurso.cod-eqpto  = mab-eqpto.cod-eqpto
                            and   ttPercurso.dat-movto  = mab-viagem.dat-ret no-lock) then do:
                create ttPercurso.
                assign ttPercurso.ep-codigo  = mab-eqpto.ep-codigo
                       ttPercurso.cod-eqpto  = mab-eqpto.cod-eqpto
                       ttPercurso.dat-movto  = mab-viagem.dat-ret
                       ttPercurso.de-km-ini  = mab-eqpto.val-km-inicial.
            end.
            else 
                for first ttPercurso fields(dePercurso)
                    where ttPercurso.ep-codigo  = mab-eqpto.ep-codigo
                    and   ttPercurso.cod-eqpto  = mab-eqpto.cod-eqpto
                    and   ttPercurso.dat-movto  = mab-viagem.dat-ret exclusive-lock:
                end.
            /** Acumula todos os percursos do dia atravÇs da diferenáa entre final e inicial do contador **/
            assign ttPercurso.de-percurso = ttPercurso.de-percurso + (mab-viagem.val-hodom-horim-final - 
                                                                      mab-viagem.val-hodom-horim-inicial).
        end.
    end.
end.

for each ttPercurso no-lock
    break by ttPercurso.ep-codigo
          by ttPercurso.cod-eqpto
          by ttPercurso.dat-movto:

    /** Se for o primeiro registro do equipamento **/
    if first-of(ttPercurso.cod-eqpto) then do:

        /** Busca Quilometragem anterior **/
        if can-find(first mab-movto-km-eqpto
                    where mab-movto-km-eqpto.ep-codigo = ttPercurso.ep-codigo
                    and   mab-movto-km-eqpto.cod-eqpto = ttPercurso.cod-eqpto
                    and   mab-movto-km-eqpto.dat-movto < ttPercurso.dat-movto no-lock) THEN DO:
       
                for last  mab-movto-km-eqpto
                    where mab-movto-km-eqpto.ep-codigo = ttPercurso.ep-codigo
                    and   mab-movto-km-eqpto.cod-eqpto = ttPercurso.cod-eqpto
                    and   mab-movto-km-eqpto.dat-movto < ttPercurso.dat-movto no-lock:
                    /** KM do movimento anterior **/
                    assign deKM = mab-movto-km-eqpto.val-km-real.
                end.            
        END.
        ELSE DO:        
            /** Se n∆o existir, busca KM inicial do equipamento **/
            assign deKM = ttPercurso.de-km-ini.
        END.
    end.
    if valid-handle(pAcomp) then do:
        {utp/ut-liter.i "Gerando Quilometragem"}
        run pi-acompanhar in pAcomp (input trim(return-value) + ': ' + string(ttPercurso.ep-codigo) + '-' + ttPercurso.cod-eqpto).
    end.
    run converteParaHoraInvertida (input  string(ttPercurso.dat-movto,"99/99/9999"),
                                   input  "000000",
                                   output deInvertida).
    /** Criaá∆o do registro da Temp-Table de Quilometragem **/
    create ttKMEqpto.
    assign ttKMEqpto.ep-codigo            = ttPercurso.ep-codigo
           ttKMEqpto.cod-eqpto            = ttPercurso.cod-eqpto
           ttKMEqpto.val-dat-hora-invrtda = deInvertida
           ttKMEqpto.dat-movto            = ttPercurso.dat-movto
           ttKMEqpto.hra-inicial          = "000000"
           ttKMEqpto.idi-origem           = 1  /** Abastecimento **/
           ttKMEqpto.num-docto            = 0
           ttKMEqpto.log-abastec-prim     = no
           ttKMEqpto.val-hodom-horim      = deKM + ttPercurso.de-percurso
           ttKMEqpto.val-km-real          = deKM + ttPercurso.de-percurso
           ttKMEqpto.cod-livre-1          = "KM:" + STRING(dePercurso) /*Inserido o valor o percurso para facilitar um possivel acerto de base*/
           deKM                           = ttKMEqpto.val-km-real.

end.

if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Gerando Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Chama BO para criaá∆o **/
run chamaBO in this-procedure (input 1). /** 1 = Criaá∆o / 2 = Eliminaá∆o **/

if can-find(first RowErrors) then
    return "NOK":U.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-iniciaImportacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniciaImportacao Procedure 
PROCEDURE iniciaImportacao :
/*------------------------------------------------------------------------------
  Purpose:     iniciaImportacao
  Parameters:  entrada ttKMImport = Temp-Table de Importaá∆o do KM
               entrada pAcomp     = Acompanhamento do programa
  Notes:       Inicia as validaá‰es e criaá∆o dos registros da importaá∆o
------------------------------------------------------------------------------*/
define input parameter table for ttKMImport.
define input parameter pAcomp as handle no-undo.

if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Excluindo Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Eliminaá∆o dos Movimentos **/
run excluiKM in this-procedure (input tt-param.eqptoIni,
                                input tt-param.eqptoFim).

empty temp-table ttKMEqpto.

/** Percorre todos os registros de Quilometragem importados **/
for each ttKMImport no-lock
    break by ttKMImport.ep-codigo
          by ttKMImport.cod-eqpto
          by ttKMImport.dat-movto:
    if valid-handle(pAcomp) then do:
        {utp/ut-liter.i "Validando"}
        run pi-acompanhar in pAcomp (input trim(return-value) + ': ' + string(ttKMImport.ep-codigo) + '-' + ttKMImport.cod-eqpto).
    end.
    /** Valida os registros importados **/
    run validaImportacao in this-procedure.
    /** N∆o foram encontrado erros no registro, gera a quilometragem  **/
    if return-value = "OK":U then do:
        if valid-handle(pAcomp) then do:
            {utp/ut-liter.i "Gerando Quilometragem"}
            run pi-acompanhar in pAcomp (input trim(return-value) + ': ' + string(ttKMImport.ep-codigo) + '-' + ttKMImport.cod-eqpto).
        end.
        /** Busca Registro do Equipamento **/
        if not avail mab-eqpto or mab-eqpto.ep-codigo <> ttKMImport.ep-codigo
                               or mab-eqpto.cod-eqpto <> ttKMImport.cod-eqpto then
            for first mab-eqpto
                where mab-eqpto.ep-codigo     = ttKMImport.ep-codigo 
                and   mab-eqpto.cod-eqpto     = ttKMImport.cod-eqpto no-lock:
            end.
        if avail mab-eqpto then do:
            /** Se for o primeiro registro importado do equipamento **/
            if first-of(ttKMImport.cod-eqpto) then do:
                /** Busca Quilometragem anterior **/
                if can-find(first mab-movto-km-eqpto
                            where mab-movto-km-eqpto.ep-codigo = ttKMImport.ep-codigo
                            and   mab-movto-km-eqpto.cod-eqpto = ttKMImport.cod-eqpto
                            and   mab-movto-km-eqpto.dat-movto < ttKMImport.dat-movto no-lock) then
                    for last  mab-movto-km-eqpto
                        where mab-movto-km-eqpto.ep-codigo = ttKMImport.ep-codigo
                        and   mab-movto-km-eqpto.cod-eqpto = ttKMImport.cod-eqpto
                        and   mab-movto-km-eqpto.dat-movto < ttKMImport.dat-movto no-lock:
                        /** KM do movimento anterior **/
                        assign deKM = mab-movto-km-eqpto.val-km-real.
                    end.
                else
                    /** Se n∆o existir, busca KM inicial do equipamento **/
                    assign deKM = mab-eqpto.val-km-inicial.

            end.

            /** Criaá∆o do registro da Temp-Table de Quilometragem **/
            create ttKMEqpto.
            assign ttKMEqpto.ep-codigo            = ttKMImport.ep-codigo
                   ttKMEqpto.cod-eqpto            = ttKMImport.cod-eqpto
                   ttKMEqpto.val-dat-hora-invrtda = ttKMImport.val-dat-hora-invrtda
                   ttKMEqpto.dat-movto            = ttKMImport.dat-movto
                   ttKMEqpto.hra-inicial          = "000000"
                   ttKMEqpto.idi-origem           = IF ttKMImport.idi-origem <> 0 THEN ttKMImport.idi-origem ELSE 1  /** Abastecimento **/
                   ttKMEqpto.num-docto            = 0
                   ttKMEqpto.log-abastec-prim     = no
                   ttKMEqpto.val-hodom-horim      = deKM + ttKMImport.val-km-real
                   ttKMEqpto.val-km-real          = deKM + ttKMImport.val-km-real
                   ttKMEqpto.cod-livre-1          = "KM:" + STRING(dePercurso) /*Inserido o valor o percurso para facilitar um possivel acerto de base*/
                   deKM                           = ttKMEqpto.val-km-real.
        end.
    end.
end.
if valid-handle(pAcomp) then do:
    {utp/ut-liter.i "Gerando Quilometragem"}
    run pi-acompanhar in pAcomp (input trim(return-value)).
end.
/** Chama BO para criaá∆o **/
run chamaBO in this-procedure (input 1). /** 1 = Criaá∆o / 2 = Eliminaá∆o **/

if can-find(first RowErrorsAux
            WHERE RowErrorsAux.ErrorType <> "INTERNAL":U) THEN return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaErroAux) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErroAux Procedure 
PROCEDURE piCriaErroAux :
/*------------------------------------------------------------------------------
  Purpose:     piCriaErroAux
  Parameters:  entrada pMens  = N£mero da Mensagem
               entrada pLinha = N£mero da linha do registro
               entrada pParam = ParÉmetros para Mensagem
  Notes:       Criaá∆o dos erros auxiliares (para cada linha do arquivo)
------------------------------------------------------------------------------*/
define input parameter pMens  as integer   no-undo.
define input parameter pLinha as integer   no-undo.
define input parameter pParam as character no-undo.

/** Cria a Mensagem pela procedure padr∆o **/
run piCriaErro in this-procedure (input pMens,
                                  input "EMS":U,
                                  input pParam).
/** Cria a auxiliar informando a linha que ocorreu o erro **/
create RowErrorsAux.
buffer-copy RowErrors to RowErrorsAux
    assign RowErrorsAux.i-linha = pLinha.

/** Limpa a temp-table normal **/
empty temp-table RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaImportacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaImportacao Procedure 
PROCEDURE validaImportacao :
/*------------------------------------------------------------------------------
  Purpose:     validaImportacao
  Parameters:  <none>
  Notes:       Valida os registros importados
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

/** Empresa fora da faixa parametrizada **/
if ttKMImport.ep-codigo < tt-param.empIni or 
   ttKMImport.ep-codigo > tt-param.empFim then do:
    {utp/ut-liter.i "Empresa"}
    run piCriaErroAux in this-procedure (input 29472,
                                         input ttKMImport.i-linha,
                                         input trim(return-value)           + '~~' +
                                               string(ttKMImport.ep-codigo) + '~~' +
                                               string(tt-param.empIni)      + '~~' +
                                               string(tt-param.empFim)).
end.
/** Empresa n∆o cadastrada **/
if not can-find(first empresa
                where empresa.ep-codigo = ttKMImport.ep-codigo no-lock) then do:
    {utp/ut-liter.i "Empresa"}
    run piCriaErroAux in this-procedure (input 56,
                                         input ttKMImport.i-linha,
                                         input trim(return-value) + '~~' +
                                               trim(return-value)).
end.
/** Equipamento n∆o cadastrado **/
FOR first mab-eqpto
    where mab-eqpto.ep-codigo = ttKMImport.ep-codigo 
    and   mab-eqpto.cod-eqpto = ttKMImport.cod-eqpto no-lock:
END.
IF  NOT AVAIL mab-eqpto THEN DO:
    {utp/ut-liter.i "Equipamento"}
    run piCriaErroAux in this-procedure (input 56,
                                         input ttKMImport.i-linha,
                                         input trim(return-value) + '~~' +
                                               trim(return-value)).
end.
else do:
    /** Busca Registro do Equipamento **/
    if not avail mab-eqpto or mab-eqpto.ep-codigo <> ttKMImport.ep-codigo
                           or mab-eqpto.cod-eqpto <> ttKMImport.cod-eqpto then
        for first mab-eqpto
            where mab-eqpto.ep-codigo     = ttKMImport.ep-codigo 
            and   mab-eqpto.cod-eqpto     = ttKMImport.cod-eqpto no-lock:
        end.
    if avail mab-eqpto then do:
        /** Equipamento n∆o pode ser motorizado **/
        if mab-eqpto.idi-tip-eqpto = 1 then
            run piCriaErroAux in this-procedure (input 29470,
                                                 input ttKMImport.i-linha,
                                                 input trim(ttKMImport.cod-eqpto) + '~~' +
                                                       string(ttKMImport.ep-codigo)).
        /** Equipamento desativado na data informada **/
        if mab-eqpto.idi-tip-eqpto = 2 and mab-eqpto.dat-situacao <> ? 
                                       and mab-eqpto.dat-situacao  < ttKMImport.dat-movto then
            run piCriaErroAux in this-procedure (input 29471,
                                                 input ttKMImport.i-linha,
                                                 input string(ttKMImport.ep-codigo) + '~~' +
                                                       trim(ttKMImport.cod-eqpto)   + '~~' +
                                                       string(mab-eqpto.dat-situacao)).
        /** Grupo do Equipamento fora da faixa parametrizada **/
        if mab-eqpto.cod-grp-eqpto < tt-param.grupoIni or 
           mab-eqpto.cod-grp-eqpto > tt-param.grupoFim then do:
            {utp/ut-liter.i "Grupo Equipamento"}
            run piCriaErroAux in this-procedure (input 29472,
                                                 input ttKMImport.i-linha,
                                                 input trim(return-value)      + '~~' +
                                                       mab-eqpto.cod-grp-eqpto + '~~' +
                                                       tt-param.grupoIni       + '~~' +
                                                       tt-param.grupoFim).
        end.
        /** Modelo do Equipamento fora da faixa parametrizada **/
        if mab-eqpto.cod-model < tt-param.modeloIni or 
           mab-eqpto.cod-model > tt-param.modeloFim then do:
            {utp/ut-liter.i "Modelo Equipamento"}
            run piCriaErroAux in this-procedure (input 29472,
                                                 input ttKMImport.i-linha,
                                                 input trim(return-value)  + '~~' +
                                                       mab-eqpto.cod-model + '~~' +
                                                       tt-param.modeloIni  + '~~' +
                                                       tt-param.modeloFim).
        end.
        /** Estabelecimento fora da faixa parametrizada **/
        if mab-eqpto.cod-estabel < tt-param.estabIni or 
           mab-eqpto.cod-estabel > tt-param.estabFim then do:
            {utp/ut-liter.i "Estabelecimento"}
            run piCriaErroAux in this-procedure (input 29472,
                                                 input ttKMImport.i-linha,
                                                 input trim(return-value)    + '~~' +
                                                       mab-eqpto.cod-estabel + '~~' +
                                                       tt-param.estabIni     + '~~' +
                                                       tt-param.estabFim).
        end.
    end.
end.

/** Data do Movimento menor que data inicial parametrizada **/
if ttKMImport.dat-movto < tt-param.dtInicial then do:
    {utp/ut-liter.i "Movimento"}
    assign cTexto = trim(return-value).
    {utp/ut-liter.i "Inicial"}
    run piCriaErroAux in this-procedure (input 28012,
                                         input ttKMImport.i-linha,
                                         input cTexto + '~~' + trim(return-value)).
end.


if can-find(first RowErrorsAux
            where RowErrorsAux.i-linha = ttKMImport.i-linha no-lock) then
    return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaInicial Procedure 
PROCEDURE validaInicial :
/*------------------------------------------------------------------------------
  Purpose:     validaInicial
  Parameters:  <none>
  Notes:       Validaá‰es iniciais para a temp-table de ParÉmetros da API
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTexto  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto1 AS CHARACTER  NO-UNDO.

/** ParÉmetros n∆o informados **/
if not avail tt-param then do:
    run piCriaErro (1454, 'EMS':U, '').
    create RowErrorsAux.
    buffer-copy RowErrors to RowErrorsAux.
    return "NOK":U.
end.
{utp/ut-liter.i "Final"}
assign cTexto1 = trim(return-value).
/** Data Inicial maior que final **/
if tt-param.dtInicial > tt-param.dtFinal and tt-param.i-origem <> 1 then do:
    {utp/ut-liter.i "Inicial"}
    assign cTexto = cTexto1 + '~~' + string(tt-param.dtFinal,'99/99/9999') + '~~' + 
                    trim(return-value) + '~~' + string(tt-param.dtInicial,'99/99/9999').
    run piCriaErro (28411, 'EMS':U, cTexto).
end.
/** Data Final maior que atual **/
if tt-param.dtFinal > today and tt-param.i-origem <> 1 then do:
    {utp/ut-liter.i "Atual"}
    assign cTexto = cTexto1 + '~~' + string(tt-param.dtFinal,'99/99/9999') + '~~' +
                    trim(return-value) + '~~' + string(tt-param.dtInicial,'99/99/9999').
    run piCriaErro (28411, 'EMS':U, cTexto).
end.
/** Empresa Inicial menor que final **/
if tt-param.empIni > tt-param.empFim then do:
    {utp/ut-liter.i "Empresa Inicial"}
    assign cTexto1 = trim(return-value).
    {utp/ut-liter.i "Empresa Final"}
    assign cTexto = cTexto1 + '~~' + trim(return-value).
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Estabelecimento Inicial menor que final **/
if tt-param.estabIni > tt-param.estabFim then do:
    {utp/ut-liter.i "Estabelecimento Inicial"}
    assign cTexto1 = trim(return-value).
    {utp/ut-liter.i "Estabelecimento Final"}
    assign cTexto = cTexto1 + '~~' + trim(return-value).
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Equipamento Inicial menor que final **/
if tt-param.eqptoIni > tt-param.eqptoFim and tt-param.i-origem <> 1 then do:
    {utp/ut-liter.i "Equipamento Inicial"}
    assign cTexto1 = trim(return-value).
    {utp/ut-liter.i "Equipamento Final"}
    assign cTexto = cTexto1 + '~~' + trim(return-value).
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Grupo Inicial menor que final **/
if tt-param.grupoIni > tt-param.grupoFim then do:
    {utp/ut-liter.i "Grupo Inicial"}
    assign cTexto1 = trim(return-value).
    {utp/ut-liter.i "Grupo Final"}
    assign cTexto = cTexto1 + '~~' + trim(return-value).
    run piCriaErro (1208, 'EMS':U, cTexto).
end.
/** Grupo Inicial menor que final **/
if tt-param.modeloini > tt-param.modeloFim then do:
    {utp/ut-liter.i "Modelo Inicial"}
    assign cTexto1 = trim(return-value).
    {utp/ut-liter.i "Modelo Final"}
    assign cTexto = cTexto1 + '~~' + trim(return-value).
    run piCriaErro (1208, 'EMS':U, cTexto).
end.

/** Par∆metros de geraá∆o de percurso **/
if tt-param.i-origem = 2 then do:
    if tt-param.dePercurso = 0 then do:
        {utp/ut-liter.i "Percurso Rodado"}
        run piCriaErro (5360, 'EMS':U, trim(return-value)).
    end.
    if not can-find(first tab-unidade 
                    where tab-unidade.un = tt-param.un no-lock) then do:
        {utp/ut-liter.i "Unidade"}
        run piCriaErro (56, 'EMS':U, trim(return-value) + '~~' +
                                     trim(return-value)).
    end.
end.

/** Unidade Neg¢cio Inicial menor que final **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        IF tt-param.unidNegocIni > tt-param.unidNegocFim THEN DO:
            {utp/ut-liter.i "Unidade_Negocio_Inicial"}
            ASSIGN cTexto1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Unidade_Negocio_Final"}
            ASSIGN cTexto = cTexto1 + '~~' + TRIM(RETURN-VALUE).
            RUN piCriaErro (1208, 'EMS':U, cTexto).
        END.
    END.
&ENDIF

/** Se for importaá∆o, passa os erros para a temp-table de erros auxiliar **/
if tt-param.i-origem = 1 then do:
    for each RowErrors no-lock:
        buffer-copy RowErrors to RowErrorsAux.
    end.
    empty temp-table RowErrors.
end.

if can-find(first RowErrors) or 
   can-find(first RowErrorsAux) then
    return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

