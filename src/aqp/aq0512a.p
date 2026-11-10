/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0512A 2.00.00.013 } /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0512A MAQ}
&ENDIF

/****************** Definiá∆o de Tabelas Tempor†rias do Relat¢rio **********************/

{aqp/aq0512.i} /*tts*/

DEFINE TEMP-TABLE tt-param-planilha NO-UNDO
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER.

/* recebimento de parÉmetros */
DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-dados-ensaio-pagtoV2.

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp    AS   HANDLE                    NO-UNDO.
DEFINE VARIABLE h-utapi033 AS   HANDLE                    NO-UNDO.
DEFINE VARIABLE i-empresa  LIKE param-global.empresa-prin NO-UNDO.


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i  Relat¢rio_Simulaá∆o_Preáo_Final *}
ASSIGN c-sistema      = TRIM(RETURN-VALUE)
       c-titulo-relat = TRIM(RETURN-VALUE).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN utp/utapi033.p PERSISTENT SET h-utapi033.

{utp/ut-liter.i Gerando_Planilha *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FIND FIRST tt-param NO-LOCK NO-ERROR.

/*----------------GERANDO ARQUIVO*/
/*vari·veis impressas na planilha*/
{aqp/aq0512.i1}


/*definiá∆o das colunas,    num coluna,   tipo conteudo,      conteudo coluna,             formato,        tamanho celula*/
RUN piColumn IN h-utapi033 (INPUT 01,     INPUT "INTEGER",    INPUT c-l-cdn-produt-rural,  INPUT "",       INPUT 70        ).  
RUN piColumn IN h-utapi033 (INPUT 02,     INPUT "CHARACTER",  INPUT c-l-nome-emit,         INPUT "",       INPUT 250       ). 
RUN piColumn IN h-utapi033 (INPUT 03,     INPUT "CHARACTER",  INPUT c-l-cnpj,              INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 04,     INPUT "CHARACTER",  INPUT c-l-insc-estadual,     INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 05,     INPUT "CHARACTER",  INPUT c-l-cod-pto-coleta,    INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 06,     INPUT "CHARACTER",  INPUT c-l-des-pto-coleta,    INPUT "",       INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 07,     INPUT "CHARACTER",  INPUT c-l-cod-propried,      INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 08,     INPUT "CHARACTER",  INPUT c-l-des-propried,      INPUT "",       INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 09,     INPUT "INTEGER",    INPUT c-l-cdn-grp-produt,    INPUT "",       INPUT 50        ). 
RUN piColumn IN h-utapi033 (INPUT 10,     INPUT "CHARACTER",  INPUT c-l-des-grp-produt,    INPUT "",       INPUT 200       ). 
RUN piColumn IN h-utapi033 (INPUT 11,     INPUT "CHARACTER",  INPUT c-l-cod-rota,          INPUT "",       INPUT 70        ). 
RUN piColumn IN h-utapi033 (INPUT 12,     INPUT "CHARACTER",  INPUT c-l-des-rota,          INPUT "",       INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 13,     INPUT "CHARACTER",  INPUT c-l-cod-regiao,        INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 14,     INPUT "CHARACTER",  INPUT c-l-des-regiao,        INPUT "",       INPUT 170       ). 
RUN piColumn IN h-utapi033 (INPUT 15,     INPUT "CHARACTER",  INPUT c-l-cidade,            INPUT "",       INPUT 150       ).
RUN piColumn IN h-utapi033 (INPUT 16,     INPUT "CHARACTER",  INPUT c-l-uf,                INPUT "",       INPUT 100       ).
RUN piColumn IN h-utapi033 (INPUT 17,     INPUT "DECIMAL",    INPUT c-l-qtd-period,        INPUT "",       INPUT 70        ). 
RUN piColumn IN h-utapi033 (INPUT 18,     INPUT "DECIMAL",    INPUT c-l-val-preco-base,    INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 19,     INPUT "DECIMAL",    INPUT c-l-val-var-qualid,    INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 20,     INPUT "DECIMAL",    INPUT c-l-val-var-volum,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 21,     INPUT "DECIMAL",    INPUT c-l-val-bonus-fix,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 22,     INPUT "DECIMAL",    INPUT c-l-val-pre-unit,      INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 23,     INPUT "DECIMAL",    INPUT c-l-val-bonus-fix-inf, INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 24,     INPUT "DECIMAL",    INPUT c-l-val-pre-final,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 25,     INPUT "DECIMAL",    INPUT c-l-val-pre-liq-ant,   INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 26,     INPUT "DECIMAL",    INPUT c-l-val-ajuste,        INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 27,     INPUT "DECIMAL",    INPUT c-l-val-incentivo,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 28,     INPUT "DECIMAL",    INPUT c-l-val-pre-bruto,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 29,     INPUT "DECIMAL",    INPUT c-l-val-tot-prov,      INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 30,     INPUT "DECIMAL",    INPUT c-l-val-outr-cred,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 31,     INPUT "DECIMAL",    INPUT c-l-val-adiantamentos, INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 32,     INPUT "DECIMAL",    INPUT c-l-val-emprestimos,   INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 33,     INPUT "DECIMAL",    INPUT c-l-val-convenios,     INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 34,     INPUT "DECIMAL",    INPUT c-l-val-outr-debitos,  INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 35,     INPUT "DECIMAL",    INPUT c-l-val-desconto-tot,  INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 36,     INPUT "DECIMAL",    INPUT c-l-val-imp-retido,    INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 37,     INPUT "DECIMAL",    INPUT c-l-impto-sanid,       INPUT "9.9999", INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 38,     INPUT "DECIMAL",    INPUT c-l-val-liq-receb-tot, INPUT "9.9999", INPUT 90        ). 
RUN piColumn IN h-utapi033 (INPUT 39,     INPUT "CHARACTER",  INPUT c-l-banco,             INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 40,     INPUT "CHARACTER",  INPUT c-l-agencia,           INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 41,     INPUT "CHARACTER",  INPUT c-l-conta,             INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 42,     INPUT "INTEGER",    INPUT c-l-cdn-correntista,   INPUT "",       INPUT 75        ). 
RUN piColumn IN h-utapi033 (INPUT 43,     INPUT "CHARACTER",  INPUT c-l-titular,           INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 44,     INPUT "CHARACTER",  INPUT c-l-id-unico-emit,     INPUT "",       INPUT 130       ).
RUN piColumn IN h-utapi033 (INPUT 45,     INPUT "CHARACTER",  INPUT c-l-periodo,           INPUT "",       INPUT 100       ).
RUN piColumn IN h-utapi033 (INPUT 46,     INPUT "CHARACTER",  INPUT c-l-item,              INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 47,     INPUT "CHARACTER",  INPUT c-l-desc-item,         INPUT "",       INPUT 100       ). 
RUN piColumn IN h-utapi033 (INPUT 48,     INPUT "CHARACTER",  INPUT c-l-cod-estabel,       INPUT "",       INPUT 100       ).
RUN piColumn IN h-utapi033 (INPUT 49,     INPUT "CHARACTER",  INPUT c-l-nro-docto,         INPUT "",       INPUT 100       ).
RUN piColumn IN h-utapi033 (INPUT 50,     INPUT "CHARACTER",  INPUT c-l-serie-docto,       INPUT "",       INPUT 100       ).



/*--------- Impress∆o das linhas */
CASE tt-param.i-classif:
    WHEN 1 THEN /*Descriá∆o Grupo/Nome Produtor*/
        FOR EACH tt-dados-ensaio-pagtoV2 NO-LOCK
           BREAK BY tt-dados-ensaio-pagtoV2.des-grp-produt BY tt-dados-ensaio-pagtoV2.nome-emit:
            {aqp/aq0512.i2}
        END. 
    WHEN 2 THEN /*Descriá∆o Rota/Nome Produtor*/
        FOR EACH tt-dados-ensaio-pagtoV2 NO-LOCK
           BREAK BY tt-dados-ensaio-pagtoV2.des-rota BY tt-dados-ensaio-pagtoV2.nome-emit:
            {aqp/aq0512.i2}
        END. 
    WHEN 3 THEN /*C¢digo Regi∆o/Nome Produtor*/
        FOR EACH tt-dados-ensaio-pagtoV2 NO-LOCK
           BREAK BY tt-dados-ensaio-pagtoV2.cod-regiao BY tt-dados-ensaio-pagtoV2.nome-emit:
            {aqp/aq0512.i2}
        END. 
END CASE.

/**********************************/

IF tt-param.imp-param THEN
    RUN piImprimeParametros IN THIS-PROCEDURE.

ASSIGN c-titulo-relat = c-empresa + FILL(" ", 100) +  c-titulo-relat + " - " + FILL(" ", 100) + 
       STRING(TODAY,"99/99/9999") + " - " + STRING(TIME, "HH:MM:SS").

RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0512", INPUT c-titulo-relat).

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

    {utp/ut-liter.i atÇ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.    
    
   {utp/ut-liter.i SELEÄ«O *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cod-estabel 
           tt-param-planilha.valor     = STRING(tt-param.cod-estabel-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-estabel-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cod-regiao
           tt-param-planilha.valor     = STRING(tt-param.cod-regiao-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-regiao-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cod-rota 
           tt-param-planilha.valor     = STRING(tt-param.cod-rota-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-rota-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cdn-grp-produt
           tt-param-planilha.valor     = STRING(tt-param.cdn-grp-produt-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-grp-produt-fim).
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-l-cdn-produt-rural
           tt-param-planilha.valor     = STRING(tt-param.cdn-produt-rural-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-produt-rural-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".

    {utp/ut-liter.i CLASSIFICAÄ«O *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.

    CASE tt-param.i-classif:
        WHEN 1 THEN {utp/ut-liter.i 1_-_Por_Descriá∆o_Grupo_/_Nome_Produtor *}
        WHEN 2 THEN {utp/ut-liter.i 2_-_Por_Descriá∆o_Rota_/_Nome_Produtor *}
        WHEN 3 THEN {utp/ut-liter.i 3_-_Por_C¢digo_Regi∆o_/_Nome_Produtor *} 
    END CASE.
    
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".
           
    {utp/ut-liter.i PAR∂METROS *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    {utp/ut-liter.i Per°odo *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = tt-param.period.

    {utp/ut-liter.i Item *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = tt-param.it-codigo.

    ASSIGN iParamColumnWidth[1] = 150
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).    

    RETURN "OK":U.

END PROCEDURE.
