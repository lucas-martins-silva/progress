/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0702RP 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0702rp MAB}
&ENDIF


{include/i_fnctrad.i}
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*****************************************************************************
**
**       PROGRAMA: AB0702rp.p
**
**       DATA....: 15/01/2004
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Importa‡Æo Percurso Equipamentos NÆo Motorizados
**
*****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
{cdp/cdcfgmnt.i}
{abp/abapi007.i}          /* Temp-table mab-movto-km-eqpto */
define buffer bfKM for ttKMImport.
{frbo/bofr089.i ttLayout} /* Temp-table mab-layout-import */
{abp/ab9004.i}            /* Temp-Table RowErrors */

define temp-table RowErrorsAux no-undo like RowErrors
    field i-linha as integer.

define shared temp-table tt-digita no-undo like ttLayout.

def temp-table tt-raw-digita
   field raw-digita as raw.
/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
create tt-param.
raw-transfer raw-param to tt-param.
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
define variable h-acomp        as handle     no-undo.
define variable c-linha        as character  no-undo.
define variable i-cont         as integer    no-undo.
define variable iLinha         as integer    no-undo.
define variable i-logical      as integer    no-undo. /** 0 - Falso 1 - Verdadeiro **/
define variable c-lista-campos as character  no-undo.
define variable h-ttKM         as handle     no-undo. /** Handle da temp-table ttKMImport **/
define variable h-field-ttKM   as handle     no-undo. /** Handle dos campos da ttKMImport **/
define variable l-titulo       as logical    no-undo.
define variable h-abapi007     as handle     no-undo.
define stream   s-ab0702.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
{abp/ab0702.i}

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
         HEIGHT             = 7.08
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/abapi001.i2} /** Cria‡Æo de erros **/
{abp/ab9000.i}    /** ConversÆo de horas **/

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.

/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i &TOFILE=tt-param.arq-destino}  /** Abertura do output do programa **/

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDados Procedure 
PROCEDURE displayDados :
/*------------------------------------------------------------------------------
  Purpose:     displayDados
  Parameters:  <none>
  Notes:       Mostra os dados da importa‡Æo e seus respectivos erros.
------------------------------------------------------------------------------*/
/** Imprime os erros gen‚ricos **/
for each  RowErrorsAux
    where RowErrorsAux.i-linha = 0 no-lock
    by    RowErrorsAux.ErrorSequence:
    display RowErrorsAux.ErrorSequence   
            RowErrorsAux.ErrorNumber     
            RowErrorsAux.ErrorDescription 
        with frame f-erro.
    down with frame f-erro.
end.

/** Mostra t¡tulo dos dados **/
if (tt-param.todos = 1 or can-find(first RowErrorsAux no-lock)) and
    can-find(first ttKMImport no-lock) then
    view frame f-titulo.

for each ttKMImport no-lock
    by   ttKMImport.i-linha:
    /** Imprime Todos os registros **/
    if tt-param.todos = 1 then do:
        /** Imprime KM **/
        display ttKMImport.i-linha
                ttKMImport.ep-codigo
                ttKMImport.cod-eqpto
                ttKMImport.dat-movto
                ttKMImport.val-km-real
            with frame f-km.
        if can-find(first RowErrorsAux
                    where RowErrorsAux.i-linha = ttKMImport.i-linha no-lock) then
            /** Imprime Erros **/
            for each  RowErrorsAux
                where RowErrorsAux.i-linha = ttKMImport.i-linha no-lock
                by    RowErrorsAux.ErrorNumber:
                display RowErrorsAux.ErrorNumber     
                        RowErrorsAux.ErrorDescription 
                    with frame f-km.
                down with frame f-km.
            end.
        else down with frame f-km.
    end.
    /** Imprime somente os com erro **/
    else
        /** Verifica se linha cont‚m erros **/
        if can-find(first RowErrorsAux
                    where RowErrorsAux.i-linha = ttKMImport.i-linha no-lock) then do:
            /** Imprime KM **/
            display ttKMImport.i-linha
                    ttKMImport.ep-codigo
                    ttKMImport.cod-eqpto
                    ttKMImport.dat-movto
                    ttKMImport.val-km-real
                with frame f-km.
            /** Imprime Erros **/
            for each  RowErrorsAux
                where RowErrorsAux.i-linha = ttKMImport.i-linha no-lock
                by    RowErrorsAux.ErrorNumber:
                display RowErrorsAux.ErrorNumber     
                        RowErrorsAux.ErrorDescription 
                    with frame f-km.
                down with frame f-km.
            end.
        end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
/** NÆo mostra frame de t¡tulo dos dados **/
hide frame f-titulo.
/** Cria a p gina dos parƒmetros **/
page.

/******************************************************************
  Final do espa‡o reservado
******************************************************************/

DISPLAY /*PAR¶METRO*/
        c-liter-par
        tt-param.dtInicial
        tt-param.arq-entrada
        /*SELE€ÇO*/
        c-liter-sel
        tt-param.empIni
        tt-param.empFim
        tt-param.estabIni
        tt-param.estabFim
        tt-param.grupoIni
        tt-param.grupoFim
        tt-param.modeloIni
        tt-param.modeloFim
        /*LOG*/
        c-liter-log
        c-imprime
        c-destino 
        c-execucao         
        tt-param.arq-destino
        tt-param.usuario     
    WITH FRAME f-param-definidos.

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
               entrada pParam = Parƒmetros para Mensagem
  Notes:       Cria‡Æo dos erros auxiliares (para cada linha do arquivo)
------------------------------------------------------------------------------*/
define input parameter pMens  as integer   no-undo.
define input parameter pLinha as integer   no-undo.
define input parameter pParam as character no-undo.

/** Cria a Mensagem pela procedure padrÆo **/
run piCriaErro in this-procedure (input pMens,
                                  input "PROGRESS":U,
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

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
assign c-programa = "AB/0702"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
       c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param exclusive-lock no-error.
    if avail tt-param then
       assign tt-param.eqptoini = "":U
              tt-param.eqptofim = "ZZZZZZZZZZZZZZZ":U.

/** Busca empresa padrÆo **/
for first param-global fields(grupo) no-lock:
    assign c-empresa = param-global.grupo.
end.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Importa‡Æo Percurso Equipamento NÆo Motorizado" MAB}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "Abastecimento" *}
assign c-sistema = trim(return-value).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/

empty temp-table ttKMImport.

/** Guarda os campos que devem ser importados **/
FOR EACH tt-digita no-lock:
    IF c-lista-campos = "":U THEN 
        ASSIGN c-lista-campos = tt-digita.nom-campo.
    ELSE 
        ASSIGN c-lista-campos = c-lista-campos + ";" + tt-digita.nom-campo.
END.

/** Guarda a temp-table numa vari vel handle  **/
ASSIGN h-ttKM = BUFFER ttKMImport:HANDLE
       iLinha = 1.

/** Define arquivo de entrada informado na p gina parƒmetros **/
input stream s-ab0702 from value(tt-param.arq-entrada).

/** Inicia leitura **/
repeat on stop undo, leave:
    /** Grava linha do arquivo na vari vel caracter **/
    import stream s-ab0702 unformatted c-linha.
    /** Cria registro da ttKMImport **/
    h-ttKM:BUFFER-CREATE.
    /** Percorre as colunas (campos) **/
    DO i-cont = 1 TO NUM-ENTRIES(c-lista-campos, ";"):
        /** Busca o tipo de dado da coluna **/
        for first tt-digita 
            where tt-digita.nom-campo = ENTRY(i-cont,c-lista-campos,";") no-lock:
            /** Guarda em handle o campo que deve ser lido **/
            ASSIGN h-field-ttKM = h-ttKM:BUFFER-FIELD(ENTRY(i-cont,c-lista-campos,";")).
            /** Campo nÆo deve ser informado **/
            IF tt-digita.num-tam-campo = 0 THEN
                case tt-digita.cod-tip-dado:
                    when "integer":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = 0 NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "date":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = 12/31/9999 NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "decimal":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = decimal(0) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "character":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = "" NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "logical":U then do:
                        ASSIGN i-logical = 0 NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        if i-logical <= 0 then
                            assign h-field-ttKM:BUFFER-VALUE = no.
                        else 
                            assign h-field-ttKM:BUFFER-VALUE = yes.
                    end.
                end case.
            /** Campo foi informado **/
            ELSE
                case tt-digita.cod-tip-dado:
                    when "integer":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = integer(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "date":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = date(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "decimal":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = decimal(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "character":U then do:
                        ASSIGN h-field-ttKM:BUFFER-VALUE = SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                    end.
                    when "logical":U then do:
                        ASSIGN i-logical = integer(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                        if  error-status:error then
                            run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        if i-logical <= 0 then
                            assign h-field-ttKM:BUFFER-VALUE = no.
                        else 
                            assign h-field-ttKM:BUFFER-VALUE = yes.
                    end.
                end case.
        END.
    END.
    /** J  existe registro nesta data, entÆo soma KM do anterior 
        com o atual e elimina um dos registros **/
    if can-find(first bfKM
                where bfKM.ep-codigo = ttKMImport.ep-codigo
                and   bfKM.cod-eqpto = ttKMImport.cod-eqpto
                and   bfKM.dat-movto = ttKMImport.dat-movto no-lock) then do:
        /** Busca Registro **/
        for first bfKM
            where bfKM.ep-codigo = ttKMImport.ep-codigo
            and   bfKM.cod-eqpto = ttKMImport.cod-eqpto
            and   bfKM.dat-movto = ttKMImport.dat-movto exclusive-lock:
            /** Acumula percurso **/
            assign ttKMImport.val-km-real = ttKMImport.val-km-real + bfKM.val-km-real.
            /** Elimina registro duplicado **/
            delete bfKM.
        end.
    end.
    /** Este campo ‚ criado nesta parte, por cauda da chave da tabela
        (ep-codigo + cod-eqpto + val-dat-hora-invrtda) **/
    run converteParaHoraInvertida (input  string(ttKMImport.dat-movto,"99/99/9999"),
                                   input  "000000",
                                   output ttKMImport.val-dat-hora-invrtda).
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Importando" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + ': ' + string(ttKMImport.ep-codigo) + "-" + string(ttKMImport.cod-eqpto) + " - " + string(ttKMImport.dat-movto,'99/99/9999')).

    assign ttKMImport.i-linha = iLinha
           iLinha             = iLinha + 1.
END.

input stream s-ab0702 close.

/** Roda API de Manuten‡Æo Quilometragem de Eqptos NÆo Motorizados **/
run abp/abapi007.p persistent set h-abapi007 (input table tt-param). /** tt-param.i-origem 1 = Importa‡Æo (AB0702)
                                                                                           2 = Gera‡Æo    (AB0703)
                                                                                           3 = Viagem     (AB0704) **/
if return-value = "NOK":U then do:
    run getRowErrorsAux in h-abapi007 (output table RowErrorsAux).
    /** Erros gerais cancelam a importa‡Æo **/
    empty temp-table ttKMImport.
end.
else do:
    /** Importa‡Æo de Dados **/
    run iniciaImportacao in h-abapi007 (input table ttKMImport,
                                        input h-acomp).
    if return-value = "NOK":U then
        run getRowErrorsAux in h-abapi007 (output table RowErrorsAux).
end.
if valid-handle(h-abapi007) then do:
   delete procedure h-abapi007.
end.

/** Mostra dados importados e erros **/
run displayDados in this-procedure.

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

