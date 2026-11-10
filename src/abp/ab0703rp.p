/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0703RP 2.00.00.001}  /*** 010001 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0703rp MAB}
&ENDIF


{include/i_fnctrad.i}
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*****************************************************************************
**
**       PROGRAMA: AB0703RP.p
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Gera‡Æo de Percurso para Equipamentos nÆo Motorizados
**
*****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
{abp/ab9004.i}   /** RowErrors **/
{abp/abapi007.i} /** tt-param  **/

define temp-table tt-digita no-undo
       field i-ordem as integer.

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
/** Este c¢digo deve existir somente se relat¢rio contiver digita‡Æo **/
for each tt-raw-digita no-lock:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
define variable h-acomp    as handle no-undo.
define variable h-abapi007 as handle no-undo.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
{abp/ab0703.i}

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
         HEIGHT             = 6.63
         WIDTH              = 32.43.
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

&IF DEFINED(EXCLUDE-displayErros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayErros Procedure 
PROCEDURE displayErros :
/*------------------------------------------------------------------------------
  Purpose:     displayErros
  Parameters:  <none>
  Notes:       Lista os erros ocorridos na gera‡Æo do percurso
------------------------------------------------------------------------------*/
if can-find(first RowErrors) then do:
    FOR EACH RowErrors no-lock:
        display RowErrors.ErrorSequence   
                RowErrors.ErrorNumber     
                RowErrors.ErrorDescription 
            with frame f-erro.
        down with frame f-erro.
    END.  
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
/** Cria a p gina dos parƒmetros **/
page.

/******************************************************************
  Espa‡o reservado para buscar informa‡äes a serem impressas nos 
  parƒmetros (Opcional)
******************************************************************/

if tt-param.iTpPercurso = 1 then do:
    {utp/ut-liter.i "Por Dia"}
end.
else do:
    {utp/ut-liter.i "Total Per¡odo"}
end.
assign cDescTpPercurso = trim(return-value).

/******************************************************************
  Final do espa‡o reservado
******************************************************************/
&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN cUnidNegocIni = tt-param.unidNegocIni
           cUnidNegocFim = tt-param.unidNegocFim.

    IF NOT l-usa-unid-negoc THEN
        ASSIGN cFaixa     = "":U
               c-liter-un = "":U.
&ENDIF

DISPLAY /*SELE€ÇO*/ 
        c-liter-sel
        tt-param.dtInicial   
        tt-param.dtFinal     
        tt-param.empIni      
        tt-param.empFim      
        tt-param.eqptoIni    
        tt-param.eqptoFim    
        tt-param.estabIni    
        tt-param.estabFim    
        tt-param.grupoIni    
        tt-param.grupoFim    
        tt-param.modeloIni   
        tt-param.modeloFim 
        &IF DEFINED(bf_mnt_ems206b) &THEN
        c-liter-un
        cUnidNegocIni 
        cUnidNegocFim
        cFaixa
        &ENDIF
        /*PAR¶METROS*/ 
        c-liter-par
        tt-param.dePercurso  
        tt-param.un          
        tt-param.iTpPercurso
        cDescTpPercurso
        /*IMPRESSÇO*/
        c-liter-imp          
        c-destino            
        tt-param.arquivo
        tt-param.usuario     
    WITH FRAME f-param-definidos.

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
assign c-programa = "AB/0703"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
.
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

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Gera‡Æo Percurso Equipamento NÆo Motorizado" MAB}
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
/** Roda API de Manuten‡Æo Quilometragem de Eqptos NÆo Motorizados **/
run abp/abapi007.p persistent set h-abapi007 (input table tt-param). /** tt-param.i-origem 1 = Importa‡Æo (AB0702)
                                                                                           2 = Gera‡Æo    (AB0703)
                                                                                           3 = Viagem     (AB0704) **/
if return-value = "NOK":U then
    run getRowErrors in h-abapi007 (output table RowErrors).
else do:
    /** Gera‡Æo de Dados **/
    run iniciaGeracao in h-abapi007 (input h-acomp).
    if return-value = "NOK":U then
        run getRowErrors in h-abapi007 (output table RowErrors).
end.
/** Elimina API da mem¢ria **/
delete procedure h-abapi007.

/** Mostra os erros se ocorreram **/
run displayErros in this-procedure.

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

