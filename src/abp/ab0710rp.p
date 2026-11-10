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
{include/i-prgvrs.i AB0710RP 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0710rp MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB710RP.p
**
**       DATA....: 19/07/2007
**
**       AUTOR...: Daniel Marquini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Importa‡Æo XML Integra‡Æo CTVoicer
**
*****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/

{abp/ab0710.i}

DEF TEMP-TABLE tt-log-import NO-UNDO
    FIELD descricao   AS CHAR
    FIELD ajuda   AS CHAR.

/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/ 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
create tt-param.
raw-transfer raw-param to tt-param.
/** Este c¢digo deve existir somente se relat¢rio contiver digita‡Æo **/
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
define variable h-acomp as handle no-undo.
{include/i-rpvar.i}

DEF STREAM s-imp.
DEFINE VARIABLE c-arquivo      AS CHARACTER  NO-UNDO.
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
{abp/ab0710.i1}

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
         HEIGHT             = 11.42
         WIDTH              = 49.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
{include/i-rpcab.i &STREAM="str-rp"}

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i &STREAM="stream str-rp"}

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
HIDE STREAM str-rp FRAME f-cabec-log.
HIDE STREAM str-rp FRAME f-traco-log.
HIDE STREAM str-rp FRAME f-det-log.
/** Cria a p gina dos parƒmetros **/
PAGE STREAM str-rp.

/******************************************************************
  Espa‡o reservado para buscar informa‡äes a serem impressas nos 
  parƒmetros (Opcional)
******************************************************************/

IF tt-param.todos = 1 THEN DO:
    {utp/ut-liter.i Imprime_Todos * R}
END.
ELSE DO:
    {utp/ut-liter.i Imprime_Rejeitados * R}
END.
ASSIGN c-todos = TRIM(RETURN-VALUE).

/******************************************************************
  Final do espa‡o reservado
******************************************************************/

DISPLAY STREAM str-rp /*PAR¶METRO*/
        c-liter-par
        tt-param.InputFolder
        /*IMPRESSÇO*/
        c-liter-imp
        c-todos
        c-destino
        tt-param.arquivo
        tt-param.usuario
    WITH  FRAME f-param-definidos.
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
/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

assign c-programa = "AB0710RP":U
       c-versao   = "2.00":U
       c-revisao  = "000":U
       /** Define o destino do arquivo a ser gerado **/
       c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if avail param-global THEN DO:
    FOR FIRST empresa
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        assign c-empresa = empresa.razao-social.
    END.
END.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Log_de_Importa‡Æo_XML_CTVoicer" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "Abastecimento_e_Lubrifica‡Æo" *}
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
view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/
INPUT STREAM s-imp FROM OS-DIR(tt-param.InputFolder) NO-ATTR-LIST.

DISPLAY STREAM str-rp 
        c-liter-arq
        c-liter-des
        c-liter-hel
    WITH FRAME f-cabec-log.
DISPLAY STREAM str-rp WITH FRAME f-traco-log.


REPEAT:
    IMPORT STREAM s-imp c-arquivo.

    IF INDEX(c-arquivo,'.xml') = 0 THEN NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT c-arquivo).

    EMPTY TEMP-TABLE tt-log-import NO-ERROR.



/** Verifica parametro de integracao do AB0116 **/
{utp/ut-liter.i Sim}
for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
end.
if not avail mab-param-integr then return.

    /** Busca catalogo de Documentos **/
    define variable c-output-dir        as character no-undo.
    for first catal_docto_anexo
        where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
    END.
    if not avail catal_docto_anexo then return.

    /* faz copia para a pasta de bkp*/


    OS-COPY VALUE(tt-param.InputFolder + "~\" + c-arquivo) 
            VALUE(catal_docto_anexo.cod_path_catal + "~\BKP" + "~\" + c-arquivo).
    
        RUN adapters/xml/mn2/axrmf.p(INPUT tt-param.InputFolder + "/" + c-arquivo,
                                 INPUT "adapters/xml/mn2/axrmf011", /** IMPORTANTE: NAO DEVE SER ENVIADA A EXTENSAO DO ARQUIVO **/
                                 INPUT-OUTPUT TABLE tt-log-import).

    IF RETURN-VALUE = "NOK":U THEN DO:
        FOR EACH tt-log-import:
           ASSIGN c-descricao = tt-log-import.descricao
                   c-ajuda     = tt-log-import.ajuda.
            DISPLAY STREAM str-rp 
                    c-arquivo
                    c-descricao
                    c-ajuda
                WITH FRAME f-det-log.
            DELETE tt-log-import.
        END.
    END.
    ELSE DO:
        IF tt-param.todos = 1 THEN DO:
          {utp/ut-liter.i "Arquivo_Importado_com_Sucesso"}
              ASSIGN c-descricao = RETURN-VALUE
                   c-ajuda     = "".
            DISPLAY STREAM str-rp
                    c-arquivo
                    c-descricao
                    c-ajuda
                WITH FRAME f-det-log.
        END.
    END.
    DOWN STREAM str-rp WITH FRAME f-det-log.
END.
INPUT STREAM s-imp CLOSE.

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

