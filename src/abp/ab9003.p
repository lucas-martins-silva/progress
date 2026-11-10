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
{include/i-prgvrs.i AB9003 2.00.00.002} /*** "010002" 16/05/2025 17:37:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab9003 MAB}
&ENDIF


/*******************************************************************************                           
**  
**    Programa: AB9003.p
**
**    Data....: Outubro de 2003.
**
**    Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**    Objetivo: Programa de exporta‡Æo de dados para o excel (Sistema de Frotas).
**
*********************************************************************************/
                                                                /** Defini‡äes **/
{utp/utapi013.i}  /** Include de cria‡Æo arquivo excel **/
{cdp/cd0666.i}    /** Temp tables                      **/
{abp/ab9004.i}    /** Defini‡Æo da Temp-table RowErrors **/

define temp-table tt-dados-ex no-undo like tt-dados.

define input parameter p-arq as character no-undo.
define input parameter table for tt-dados-ex.

define variable h-api013   as handle    no-undo.
define variable i-seq      as integer   no-undo.
define variable c-planilha as character no-undo.  /** Nome da planilha   **/
define variable c-destino  as character no-undo.  /** Destino do arquivo **/
define variable l-cancela  as logical   no-undo.  /** Cancelar           **/
define variable c-novo     as character no-undo.
define variable hShowMsg   as handle    no-undo.

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
         HEIGHT             = 5.46
         WIDTH              = 30.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/abapi001.i2} /** Procedure piCriaErro **/

run piPrincipal in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Cria‡Æo da caixa de di logo e das temp-tables
------------------------------------------------------------------------------*/
/******************************************************************************/
                                    /** Caixa de Di logo para salvar arquivo **/
assign c-planilha = trim(return-value).
{utp/ut-liter.i "Novo" *}
assign c-novo = trim(return-value).

   SYSTEM-DIALOG GET-FILE p-arq
       FILTERS "*.xls" "*.xls",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "dat"
       INITIAL-DIR session:temp-directory
       RETURN-TO-START-DIR
       SAVE-AS
       title c-novo
       USE-FILENAME 
       UPDATE l-cancela.

if not l-cancela then return.
/********************************************************************************/
                               /** Cria‡Æo das temp-tables do Excel e exceu‡Æo **/
else do:
    if can-find (first tt-dados-ex) then do:
        /** Deleta arquivo se existir **/
        os-delete value(p-arq ).
        /** Limpa erros **/
        empty temp-table tt-erros.
        empty temp-table RowErrors.
        /** Configura‡äes no Excel **/
        CREATE tt-configuracao2.
        ASSIGN tt-configuracao2.versao-integracao   = 1
               tt-configuracao2.arquivo-num         = 1
               tt-configuracao2.arquivo             = p-arq
               tt-configuracao2.total-planilhas      = 1
               tt-configuracao2.exibir-construcao   = no
               tt-configuracao2.abrir-excel-termino = yes
               tt-configuracao2.imprimir = no
               tt-configuracao2.orientacao = 2.
        /** Configura‡äes da Planilha **/
        CREATE tt-planilha.
        ASSIGN tt-planilha.arquivo-num       = 1
               tt-planilha.planilha-num      = 1
               tt-planilha.planilha-nome     = c-planilha
               tt-planilha.linhas-grade      = no
               tt-planilha.linhas-grade      = YES
               tt-planilha.formatar-planilha = yes
               tt-planilha.largura-coluna    = 38.00.
        /** Cria‡Æo dos dados da planilha **/
        for each tt-dados-ex no-lock:
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num          = 1
                   tt-dados.planilha-num         = 1
                   tt-dados.celula-coluna        = tt-dados-ex.celula-coluna
                   tt-dados.celula-linha         = tt-dados-ex.celula-linha
                   tt-dados.celula-valor         = tt-dados-ex.celula-valor
                   tt-dados.celula-cor-interior  = tt-dados-ex.celula-cor-interior
                   tt-dados.celula-fonte-cor     = tt-dados-ex.celula-fonte-cor
                   tt-dados.celula-formato       = tt-dados-ex.celula-formato
                   tt-dados.celula-fonte-negrito = tt-dados-ex.celula-fonte-negrito.
        end.
    
        /** Roda API persistente **/
        run utp/utapi013.p persistent set h-api013.
        /** Executa cria‡Æo da planilha **/
        RUN pi-execute in h-api013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                    INPUT-OUTPUT TABLE tt-planilha,
                                    INPUT-OUTPUT TABLE tt-dados,
                                    INPUT-OUTPUT TABLE tt-grafico2,
                                    INPUT-OUTPUT TABLE tt-erros).
        /** Elimina handle da mem¢ria **/
        delete procedure h-api013.
        /** Verifica se ocorreram erros na cria‡Æo da planilha **/
        if return-value = "NOK":U then do:
            /** Cria‡Æo de Erros **/
            for each tt-erros no-lock:
                run piCriaErro (input tt-erros.cod-erro,
                                 input "EMS":U,
                                 input "").
            end.
            /** Mostra Erros **/
            if can-find(first RowErrors) then do:
                /** Instancia aplicativo **/
                {method/showmessage.i1}
                /** Mostra caixa com erros **/
                {method/showmessage.i2 &Modal="YES"}
                /** Limpa temp-tables de erros **/
                empty temp-table RowErrors.
                {method/showmessage.i3}
            end.
        end. 
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

