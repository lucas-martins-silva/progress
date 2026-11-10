/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0514A 2.00.00.000 } /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0514A MAQ}
&ENDIF

/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio **********************/

{aqp/aq0514.i} /*tts*/

DEFINE TEMP-TABLE tt-param-planilha NO-UNDO
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER.

/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-dados-cargas-rurais.

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp    AS   HANDLE                    NO-UNDO.
DEFINE VARIABLE h-utapi033 AS   HANDLE                    NO-UNDO.
DEFINE VARIABLE i-empresa  LIKE param-global.empresa-prin NO-UNDO.

/* ***************************  Main Block  *************************** */

{utp/ut-liter.i  Relat¢rio_de_Cargas_Rurais *}
ASSIGN c-sistema      = TRIM(RETURN-VALUE)
       c-titulo-relat = TRIM(RETURN-VALUE).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN utp/utapi033.p PERSISTENT SET h-utapi033.

{utp/ut-liter.i Gerando_Planilha *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FIND FIRST tt-param NO-LOCK NO-ERROR.

/*----------------GERANDO ARQUIVO*/
/*variáveis impressas na planilha*/
{aqp/aq0514.i1}


/*defini‡Æo das colunas,    num coluna,   tipo conteudo,      conteudo coluna,             formato,             tamanho celula*/
RUN piColumn IN h-utapi033 (INPUT 01,     INPUT "INTEGER",    INPUT c-l-num-carg,           INPUT "",           INPUT 70        ).  
RUN piColumn IN h-utapi033 (INPUT 02,     INPUT "INTEGER",    INPUT c-l-cdn-produt-rural,   INPUT "",           INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 03,     INPUT "CHARACTER",  INPUT c-l-nome-emitente,      INPUT "",           INPUT 250       ). 
RUN piColumn IN h-utapi033 (INPUT 04,     INPUT "CHARACTER",  INPUT c-l-cod-propried,       INPUT "",           INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 05,     INPUT "CHARACTER",  INPUT c-l-des-propried,       INPUT "",           INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 06,     INPUT "CHARACTER",  INPUT c-l-cod-pto-coleta,     INPUT "",           INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 07,     INPUT "CHARACTER",  INPUT c-l-des-pto-coleta,     INPUT "",           INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 08,     INPUT "DATE",       INPUT c-l-dat-trans,          INPUT "99/99/9999", INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 09,     INPUT "CHARACTER",  INPUT c-l-cod-estabel,        INPUT "",           INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 10,     INPUT "INTEGER",    INPUT c-l-cdn-produt-respons, INPUT "",           INPUT 120       ). 
RUN piColumn IN h-utapi033 (INPUT 11,     INPUT "DECIMAL",    INPUT c-l-qtd-coleta,         INPUT "",           INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 12,     INPUT "INTEGER",    INPUT c-l-cdn-compart,        INPUT "",           INPUT 80        ). 
RUN piColumn IN h-utapi033 (INPUT 13,     INPUT "DECIMAL",    INPUT c-l-val-temperat,       INPUT "",           INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 14,     INPUT "CHARACTER",  INPUT c-l-cod-amostra,        INPUT "",           INPUT 60        ). 
RUN piColumn IN h-utapi033 (INPUT 15,     INPUT "CHARACTER",  INPUT c-l-cod-lacre,          INPUT "",           INPUT 50        ). 
RUN piColumn IN h-utapi033 (INPUT 16,     INPUT "INTEGER",    INPUT c-l-cdn-repos,          INPUT "",           INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 17,     INPUT "DATE",       INPUT c-l-dat-coleta,         INPUT "99/99/9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 18,     INPUT "CHARACTER",  INPUT c-l-hra-coleta,         INPUT "99:99:99",   INPUT 60        ). 
RUN piColumn IN h-utapi033 (INPUT 19,     INPUT "CHARACTER",  INPUT c-l-des-motivo,         INPUT "",           INPUT 170       ). 

/*--------- ImpressÆo das linhas */
CASE tt-param.i-classif:
    WHEN 1 THEN /*Descri‡Æo Por Produtor*/
        FOR EACH tt-dados-cargas-rurais NO-LOCK
           BREAK BY tt-dados-cargas-rurais.cdn-produt-rural:
            {aqp/aq0514.i2}
        END. 
    WHEN 2 THEN /*Descri‡Æo Por Propriedade*/
        FOR EACH tt-dados-cargas-rurais NO-LOCK
           BREAK BY tt-dados-cargas-rurais.des-propried:
            {aqp/aq0514.i2}
        END. 
    WHEN 3 THEN /*Por Data de Transa‡Æo */
        FOR EACH tt-dados-cargas-rurais NO-LOCK
           BREAK BY tt-dados-cargas-rurais.dat-trans:
            {aqp/aq0514.i2}
        END. 
END CASE.

/**********************************/

IF tt-param.imp-param THEN
    RUN piImprimeParametros IN THIS-PROCEDURE.

ASSIGN c-titulo-relat = c-empresa + FILL(" ", 100) +  c-titulo-relat + " - " + FILL(" ", 100) + 
       STRING(TODAY,"99/99/9999") + " - " + STRING(TIME, "HH:MM:SS").

RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0514", INPUT c-titulo-relat).

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-utapi033) THEN 
  DELETE OBJECT h-utapi033.


RETURN "OK":U.

PROCEDURE piImprimeParametros:
/*------------------------------------------------------------------------------
  Purpose: imprimir parametros utilizados para geracao do relatorio.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE c-lbl-ate         AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2   NO-UNDO.
    DEFINE VARIABLE c-label-params    AS CHARACTER EXTENT 2 NO-UNDO.

    {utp/ut-liter.i at‚ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.    
    
   {utp/ut-liter.i SELE€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-dat-trans
           tt-param-planilha.valor     = STRING(tt-param.d-data-ini) + " " + c-lbl-ate + " " + STRING(tt-param.d-data-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cdn-produt-rural 
           tt-param-planilha.valor     = STRING(tt-param.cdn-produt-rural-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-produt-rural-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cdn-grp-produt
           tt-param-planilha.valor     = STRING(tt-param.cdn-grp-produt-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-grp-produt-fim).
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cod-estabel
           tt-param-planilha.valor     = STRING(tt-param.cod-estabel-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-estabel-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".

    {utp/ut-liter.i CLASSIFICA€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.

    CASE tt-param.i-classif:
        WHEN 1 THEN {utp/ut-liter.i 1_-_Por_Nome_Produtor *}
        WHEN 2 THEN {utp/ut-liter.i 2_-_Por_Propriedade *}
        WHEN 3 THEN {utp/ut-liter.i 3_-_Por_Data_de_Transa‡Æo *} 
    END CASE.
    
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".
           
    ASSIGN iParamColumnWidth[1] = 150
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).    

    RETURN "OK":U.

END PROCEDURE.
