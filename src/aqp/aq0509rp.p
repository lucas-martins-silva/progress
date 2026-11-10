/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0509RP 2.00.00.012 } /*** 010012 ***/

/*&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0509RP MAQ}
&ENDIF
*/
/******************************************************************************
**
**  Programa: AQ0509RP
**
**  Data....: MAIO de 2016
**
**  Objetivo: Relatório Informações para Ministério Agricultura
**
**  Versao..: 
**         
******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD execucao             AS INTEGER
    FIELD arquivo              AS CHAR format "x(35)":U
    FIELD usuario              AS CHAR format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD cod-estabel          AS CHARACTER
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER.
    
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id         AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.    
    
DEFINE VARIABLE cFileBirt   AS CHARACTER FORMAT "x(50)":U NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-arq-gerado       AS CHARACTER FORMAT "x(19)":U NO-UNDO.
DEFINE VARIABLE c-erro             AS CHARACTER FORMAT "x(38)":U NO-UNDO.
DEFINE VARIABLE c-erro-birt        AS CHARACTER FORMAT "x(100)":U NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.    
   
   
DEFINE VARIABLE i_response_code   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c_response_status AS CHARACTER FORMAT "x(70)":U NO-UNDO.   
DEFINE VARIABLE c_response_code AS CHARACTER FORMAT "x(3)":U NO-UNDO.   
   
def new global shared var c-dir-spool-servid-exec as char no-undo.  

{utp/ut-liter.i "Arquivo gerado em: " * }
ASSIGN c-arq-gerado = RETURN-VALUE.

{utp/ut-liter.i "Ocorreu erro na geracao do relatorio: " * }
ASSIGN c-erro = RETURN-VALUE.

form c-arq-gerado no-label cFileBirt  NO-LABEL
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-digita.
     
form c-erro FORMAT "X(38)" no-label c_response_code no-label "-" c_response_status no-label
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-erro.     


{utp/ut-glob.i}
{utp/ut-report-api.i}

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

/* executando de forma persistente o utilit rio de acompanhamento */
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
{include/i-rpvar.i}
{include/i-rpcab.i}

{include/i-rpout.i}

DEFINE VARIABLE c_report       AS CHARACTER NO-UNDO INITIAL 'aqp/aq0509':U.
DEFINE VARIABLE c_program      AS CHARACTER NO-UNDO INITIAL 'program=/aqp/aq0509a'. 
DEFINE VARIABLE c_format       AS CHARACTER NO-UNDO INITIAL 'pdf':U.
DEFINE VARIABLE c_dialect      AS CHARACTER NO-UNDO INITIAL 'en':U.
DEFINE VARIABLE l_publish      AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE VARIABLE l_download     AS LOGICAL   NO-UNDO INITIAL TRUE.

DEFINE VARIABLE h_api          AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_report       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c_query_params AS CHARACTER NO-UNDO.

DEFINE VARIABLE mptr_response  AS MEMPTR    NO-UNDO.
DEFINE VARIABLE h-aq0509a      AS HANDLE    NO-UNDO.
DEFINE VARIABLE lc_content     AS LONGCHAR  NO-UNDO.

IF NOT VALID-HANDLE(h-aq0509a) THEN
    RUN aqp/aq0509a.p PERSISTENT SET h-aq0509a.
    
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).   
 
{utp/ut-liter.i Preparando_dados.. *}
RUN pi-acompanhar IN h-acomp(INPUT RETURN-VALUE).    

RUN getReportDataRPW IN h-aq0509a(INPUT TABLE ttReport, INPUT TABLE tt-param, OUTPUT lc_content, OUTPUT TABLE RowErrors).

ASSIGN cFile = tt-param.arquivo .

/* ************************************************** */
/* *** Realiza a chamada para o Datasul Report    *** */
/* ************************************************** */

/* Para fins de testes gera um arquivo de dump com os dados a serem enviados para o Datasul Report Service */
COPY-LOB FROM lc_content TO FILE SESSION:TEMP-DIRECTORY + "AQ0509.json":U  NO-CONVERT.
 
/* Instância a API Progress do Datasul Report Service */
IF NOT VALID-HANDLE(h_report) THEN DO:
    RUN utp/ut-report-api.p PERSISTENT SET h_report.
END.
  
RUN pi-desabilita-cancela IN h-acomp. 
 {utp/ut-liter.i Imprimindo *}
RUN pi-acompanhar IN h-acomp(INPUT RETURN-VALUE).
 
/* Realiza a chamada do serviço de impressão do relatório. */
RUN print IN h_report (INPUT c_report, 
                       INPUT c_program,
                       INPUT c_format, 
                       INPUT c_dialect,
                       INPUT l_publish,
                       INPUT l_download,
                       INPUT lc_content,
                       INPUT c_query_params,  
                       OUTPUT mptr_response,  
                       OUTPUT i_response_code,
                       OUTPUT c_response_status).  
 
IF VALID-HANDLE(h_report) THEN DO:
    DELETE PROCEDURE h_report.
    ASSIGN h_report = ?.
END.

RUN pi-finalizar IN h-acomp.

/* RESPONSE "OK" */
IF i_response_code = 200 THEN DO:

    IF mptr_response NE ? THEN DO:
    
        DEFINE VARIABLE ms      AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE endTime AS DATETIME-TZ NO-UNDO INIT NOW.
        
        ASSIGN ms = INTERVAL(endTime, DATETIME-TZ (1, 1, 1970,0, 0, 0, 0, 0), "milliseconds":U).
        
        IF tt-param.execucao = 1 THEN /* online */   
            ASSIGN cFileBirt =  ENTRY(1, tt-param.arquivo, ".") + "_" + STRING(ms) + "." + c_format.
        ELSE    
            ASSIGN cFileBirt =  c-dir-spool-servid-exec + "/":U + ENTRY(1, tt-param.arquivo, ".") + "_" + STRING(ms) + "." + c_format.
            
       COPY-LOB FROM mptr_response TO FILE cFileBirt NO-CONVERT.  

       SET-SIZE(mptr_response) = 0. /* Limpa endereço de memória */

    END.

    DISPLAY c-arq-gerado cFileBirt WITH FRAME f-digita.
    DOWN WITH FRAME f-digita.
END. 
ELSE DO:
    ASSIGN c_response_code = STRING(i_response_code).
    
    DISPLAY c-erro
            c_response_code
            c_response_status
            WITH FRAME f-erro. 
END.

IF VALID-HANDLE(h-aq0509a) THEN DO:
    DELETE PROCEDURE h-aq0509a.
    ASSIGN h-aq0509a = ?.
END.

{include/i-rpclo.i}

RETURN "OK".
