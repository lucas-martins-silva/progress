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
{include/i-prgvrs.i AB0401RP 2.00.00.003 } /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0401rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0401RP.p
**
**       DATA....: Julho de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Atualiza‡Æo de Apontamentos de Abastecimento / Lubrifica‡Æo
**
*****************************************************************************/
                                              /** Defini‡Æo dos Parƒmetros **/
{abp/abapi001.i} /** Defini‡Æo das Temp-Tables da API **/
{abp/abapi001.i1} /** Defini‡Æo das Temp-Tables da API **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    index id ordem.

/* Defini‡Æo e prepara‡Æo dos parƒmetros */
def temp-table tt-raw-digita
   field raw-digita as raw.
   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

    /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.

    /** Cabe‡alho e Forms **/
{abp/ab0401.i} /*--- Defini‡Æo dos frames ---*/

{include/i-rpvar.i}

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
         HEIGHT             = 15.25
         WIDTH              = 33.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
/** Cria a p gina dos parƒmetros **/
PAGE.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN cUnidNegocIni = tt-param.cUnidNegocIni
           cUnidNegocFim = tt-param.cUnidNegocFim.

    IF NOT l-usa-unid-negoc THEN
        ASSIGN cFaixa     = "":U
               c-liter-un = "":U.
&ENDIF

DISPLAY /*SELE€ÇO*/ 
        c-liter-sel       
        tt-param.dataIni     
        tt-param.dataFim     
        tt-param.iEmpIni     
        tt-param.iEmpFim     
        tt-param.cEstabIni    
        tt-param.cEstabFim    
        tt-param.cEqptoIni   
        tt-param.cEqptoFim   
        tt-param.cTagIni     
        tt-param.cTagFim
        tt-param.cCCini
        tt-param.cCCfim
        tt-param.cPostoIni
        tt-param.cPostoFim
        &IF DEFINED(bf_mnt_ems206b) &THEN
        c-liter-un
        cUnidNegocIni 
        cUnidNegocFim
        cFaixa
        &ENDIF
        /*PAR¶METRO*/
        c-liter-par          
        tt-param.iConsiste   
        tt-param.descConsiste
        tt-param.lFicha      
        /*IMPRESSÇO*/
        c-liter-imp
        c-destino            
        tt-param.arquivo
        tt-param.usuario
    WITH FRAME f-param-definidos.

RETURN "OK":U.
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
/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

assign c-programa = "AB/0401"
       c-versao   = "2.00"
       c-revisao  = "000".

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

find first param-global no-lock no-error.

if available param-global THEN DO:
    FOR FIRST empresa
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        ASSIGN c-empresa = empresa.nome.
    END.
    IF NOT AVAIL empresa THEN DO:
        assign c-empresa = param-global.grupo.
    END.
END.

{utp/ut-liter.i "Atualiza‡Æo Apontamentos" *}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i ABASTECIMENTO *}
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

/** In¡cio do Programa **/
run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp(input c-titulo-relat).

RUN abp/abapi001.p (INPUT  TABLE tt-param,
                    OUTPUT TABLE RowErrors,
                    OUTPUT TABLE ttDocLib).

RUN displayParametros IN THIS-PROCEDURE.

/***********************************************************************/
                                                  /** P gina de Erros **/
if can-find(first RowErrors) then do:
    FOR EACH RowErrors no-lock:
        display ErrorSequence   
                ErrorNumber     
                ErrorDescription 
            with frame f-erro.
        down with frame f-erro.
    END.  
end.

run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

