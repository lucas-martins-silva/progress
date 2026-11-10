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
/* include de controle de vers∆o */
{include/i-prgvrs.i AQ0301RP 2.00.00.002 } /*** "010002" 03/03/2025 09:11:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i aq0301rp MAQ}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AQ0301RP
**
**       DATA....: maio de 2015
**
**       AUTOR...: 
**
**       OBJETIVO: Impressío erros encerramento carga rural
**
*****************************************************************************/

/* prÇ-processador para ativar ou n∆o a sa°da para RTF */
&GLOBAL-DEFINE RTF NO
/* prÇ-processador para setar o tamanho da p·gina */
&SCOPED-DEFINE pagesize 43   
/* definiá∆o das temp-tables para recebimento de parÉmetros */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)"
    FIELD usuario          AS CHARACTER FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHARACTER FORMAT "x(40)"
    FIELD modelo-rtf       AS CHARACTER FORMAT "x(35)". 

DEFINE TEMP-TABLE tt-carga-rural NO-UNDO LIKE carg-rural
    FIELD r-rowid AS ROWID. 
{method/dbotterr.i}

/* Recebimento de parÉmetros */
DEFINE INPUT PARAMETER i-action   AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER i-num-carg AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-carga-rural.
DEFINE INPUT PARAMETER TABLE FOR RowErrors.

CREATE tt-param.
ASSIGN tt-param.destino = 3 /*terminal */
       tt-param.arquivo = SESSION:TEMP-DIRECTORY + "aq0301.txt".

/* include padr∆o para vari·veis de relatÛrio  */
{include/i-rpvar.i}

/* definiá∆o de vari†veis  */
DEFINE VARIABLE h-acomp   AS HANDLE     NO-UNDO.

/* definiá∆o de frames do relat¢rio */
FORM tt-carga-rural.cod-estabel LABEL "Estab" AT 5
     tt-carga-rural.num-carg    LABEL "Carga"
     tt-carga-rural.cod-carga    LABEL "C¢digo"
     tt-carga-rural.dat-trans   LABEL "Data Transaá∆o" SKIP(2)
     WITH WIDTH 132 NO-BOX NO-LABEL PAGE-TOP TOP-ONLY FRAME f-carga STREAM-IO.


DEFINE VARIABLE c-codigo     AS CHARACTER FORMAT "x(07)":U  NO-UNDO.
DEFINE VARIABLE c-descricao  AS CHARACTER FORMAT "x(110)":U NO-UNDO.
DEFINE VARIABLE c-observacao AS CHARACTER FORMAT "x(120)":U NO-UNDO.
DEFINE VARIABLE c-traco     AS CHARACTER  FORMAT "x(110)":U NO-UNDO.

ASSIGN c-traco = FILL("-":U, 110). 

FORM c-codigo    FORMAT "x(07)"   AT 10
     c-descricao FORMAT "x(110)"  SKIP
     c-traco     FORMAT "x(110)"  AT 10
     WITH WIDTH 132 NO-BOX NO-LABEL FRAME f-cab-erros STREAM-IO.

FORM RowErrors.ErrorNumber      FORMAT ">>>>>>9":U   AT 10
     RowErrors.ErrorDescription FORMAT "x(110)":U  
     WITH WIDTH 132 NO-BOX NO-LABEL FRAME f-erros STREAM-IO.
 
 
FORM SKIP(2)
     c-observacao FORMAT "x(120)":U  AT 10 
 WITH WIDTH 132 NO-BOX NO-LABEL FRAME f-observacao STREAM-IO.

/* include padr∆o para output de relat¢rios */
{include/i-rpout.i }

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}

FIND FIRST param-global NO-LOCK NO-ERROR.

IF AVAILABLE param-global THEN DO:
    FOR FIRST empresa
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        ASSIGN c-empresa = empresa.nome.
    END.
    IF NOT AVAIL empresa THEN DO:
        ASSIGN c-empresa = param-global.grupo.
    END.
END.
IF i-action = 1 THEN DO:
    {utp/ut-liter.i "A_carga_n∆o_pode_ser_encerrada!" }
    ASSIGN c-observacao = RETURN-VALUE.
    {utp/ut-liter.i "Encerramento_Carga" }
END.    
ELSE DO:  
    {utp/ut-liter.i "A_carga_n∆o_pode_ser_reaberta!" }
    ASSIGN c-observacao = RETURN-VALUE.   
    {utp/ut-liter.i "Reabertura_Carga" }
END.
/* bloco principal do programa */
ASSIGN  c-programa 	    = "AQ0301RP":U
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-titulo-relat  = RETURN-VALUE.
        
 {utp/ut-liter.i "Descriá∆o" }       
 ASSIGN c-descricao = RETURN-VALUE.
 {utp/ut-liter.i "C¢digo" }   
 ASSIGN c-codigo = RETURN-VALUE.       

VIEW  FRAME f-cabec.
VIEW  FRAME f-rodape.

FOR FIRST tt-carga-rural
    WHERE tt-carga-rural.num-carg = i-num-carg:
    DISPLAY tt-carga-rural.cod-estabel
            tt-carga-rural.num-carg   
            tt-carga-rural.cod-carga   
            tt-carga-rural.dat-trans  
            WITH FRAME f-carga.
            DOWN WITH FRAME f-carga.

    DISPLAY c-codigo
            c-descricao 
            c-traco
            WITH FRAME f-cab-erros.
            DOWN WITH FRAME f-cab-erros.


    FOR EACH RowErrors:
        DISPLAY RowErrors.ErrorNumber
                RowErrors.ErrorDescription
                WITH FRAME f-erros.
                DOWN  WITH FRAME f-erros.

    END.    
    
    DISPLAY c-observacao  
            WITH FRAME f-observacao.
            DOWN  WITH FRAME f-observacao. 
    
END.

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i }
{report/rptrm.i}

RETURN "OK":U.

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEFINE INPUT  PARAMETER prg_name                          AS CHARACTER.
    DEFINE INPUT  PARAMETER prg_style                         AS SHORT.
END PROCEDURE.
