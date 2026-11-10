/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0017RP 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0017RP MIM}
&ENDIF

/*******************************************************************************
* Copyright DATASUL S.A. (1997)
* Todos os Direitos Reservados.
*
* Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
* parcial ou total por qualquer meio, so podera ser feita mediante
* autorizacao expressa.
******************************************************************************/
/*******************************************************************************
* Programa: imp~\im0017rp.p
* Objetivo:
* Data....: 19.04.2005
*******************************************************************************/

{method/dbotterr.i} /*definicao da temp-table rowErrors*/
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHARACTER FORMAT "x(40)":U
    FIELD modelo           AS CHARACTER FORMAT "x(35)":U
    FIELD l-habilitaRtf    AS LOGICAL.

DEFINE TEMP-TABLE tt-pedido NO-UNDO
    FIELD marca           AS LOGICAL
    FIELD num-pedido      LIKE pedido-compr.num-pedido
    FIELD cod-emitente    LIKE pedido-compr.cod-emitente
    FIELD nome-abrev      LIKE emitente.nome-abrev
    FIELD data-pedido     LIKE pedido-compr.data-pedido
    FIELD nr-proc-imp     LIKE processo-imp.nr-proc-imp
    FIELD incoterm        AS CHARACTER
    FIELD cod-itiner      LIKE itinerario.cod-itiner
    FIELD desc-itiner     LIKE itinerario.descricao
    FIELD val-desp        LIKE despes-ped-compra.val-desp
    FIELD log-execucao-OK AS LOGICAL
    FIELD r-rowid         AS ROWID.

DEFINE TEMP-TABLE tt-despesa NO-UNDO
    FIELD cod-desp          AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-desp         AS CHARACTER FORMAT "x(30)"
    FIELD cod-emitente-desp AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD desc-emitente     AS CHARACTER FORMAT "x(12)"
    FIELD mo-codigo         AS INTEGER   FORMAT ">9"
    FIELD desc-moeda        AS CHARACTER FORMAT "x(12)"
    FIELD cod-cond-pag      AS INTEGER   FORMAT ">>>9"
    FIELD desc-cond-pag     AS CHARACTER FORMAT "x(30)"
    FIELD cod-pto-contr     AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-pto-contr    AS CHARACTER FORMAT "x(30)"
    FIELD tp-despesa        AS INTEGER   FORMAT ">>9"
    FIELD desc-tipo-despesa AS CHARACTER FORMAT "x(30)"
    FIELD cod-incoterm-rat  AS CHARACTER FORMAT "x(03)"
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD opcao             AS INTEGER.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo    AS INTEGER   FORMAT "ZZ,ZZ9":U
    FIELD tipo      AS CHARACTER FORMAT "X(011)":U
    FIELD descricao AS CHARACTER FORMAT "X(113)":U.

DEFINE INPUT PARAMETER TABLE FOR tt-pedido.
DEFINE INPUT PARAMETER TABLE FOR tt-despesa.
DEFINE INPUT PARAMETER TABLE FOR tt-erro.
DEFINE INPUT PARAMETER l-imposto AS LOGICAL NO-UNDO.

DEFINE VARIABLE h-bocx341   AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-transacao AS CHARACTER FORMAT "x(08)" LABEL "Transa‡Æo".

DEFINE VARIABLE lb-cod-desp          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-cod-emitente-desp AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-mo-codigo         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-cod-cond-pag      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-cod-pto-contr     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-cod-incoterm-rat  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-tp-despesa        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lb-val-desp          AS CHARACTER FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE lb-transacao         AS CHARACTER FORMAT "X(09)" NO-UNDO.
DEFINE VARIABLE c-despesa            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pedido             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-mensagem           AS CHARACTER NO-UNDO.

IF  NOT VALID-HANDLE(h-bocx341) THEN
    RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.

RUN validateProcessoImp IN h-bocx341 (INPUT YES).

IF  VALID-HANDLE (h-bocx341) THEN DO:
    DELETE PROCEDURE h-bocx341.
    ASSIGN h-bocx341 = ?.
END.

CREATE tt-param.                                              
ASSIGN tt-param.usuario   = c-seg-usuario           
       tt-param.destino   = 3 
       tt-param.data-exec = TODAY                   
       tt-param.hora-exec = TIME                    
       tt-param.arquivo   = SESSION:TEMP-DIRECTORY + "im0017.lst".                   

{include/i-rpvar.i}

{utp/ut-liter.i Listagem_Manuten‡Æo_Despesas_por_Pedidos * r}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
{utp/ut-liter.i Importa‡Æo * r}
ASSIGN c-sistema = TRIM(RETURN-VALUE).

{utp/ut-liter.i C¢digo_da_Despesa * r}
ASSIGN lb-cod-desp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor_da_Despesa * r}
ASSIGN lb-cod-emitente-desp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Moeda * r}
ASSIGN lb-mo-codigo = TRIM(RETURN-VALUE).
{utp/ut-liter.i Condi‡Æo_de_Pagamento * r}
ASSIGN lb-cod-cond-pag = TRIM(RETURN-VALUE).
{utp/ut-liter.i Ponto_de_Controle * r}
ASSIGN lb-cod-pto-contr = TRIM(RETURN-VALUE).
{utp/ut-liter.i Incoterm_de_Rateio * r}
ASSIGN lb-cod-incoterm-rat = TRIM(RETURN-VALUE).
{utp/ut-liter.i Tipo_da_Despesa * r}
ASSIGN lb-tp-despesa = TRIM(RETURN-VALUE).
{utp/ut-liter.i Valor_da_Despesa * r}
ASSIGN lb-val-desp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Transa‡Æo * r}
ASSIGN lb-transacao = TRIM(RETURN-VALUE).
{utp/ut-liter.i DESPESA_SELECIONADA * r}
ASSIGN c-despesa = TRIM(RETURN-VALUE).
{utp/ut-liter.i PEDIDOS_SELECIONADOS * r}
ASSIGN c-pedido = TRIM(RETURN-VALUE).

{utp/ut-liter.i MENSAGENS * r}
ASSIGN c-mensagem = UPPER(TRIM(RETURN-VALUE)).

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-empresa  = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa = "IM/0017"
       c-versao   = "1.00"
       c-revisao  = "000".

{include/i-rpcab.i}

{include/i-rpout.i} 

VIEW FRAME f-cabec.

FIND FIRST tt-despesa NO-LOCK NO-ERROR.

IF tt-despesa.opcao = 1 THEN
    ASSIGN c-transacao = "Incluir".
ELSE
    ASSIGN c-transacao = "Eliminar".

PUT UNFORMATTED
    "--------------------------------------------------------- "
    c-despesa 
    " ------------------------------------------------------"
    SKIP(1)
    lb-cod-desp AT 01 
    ": "
    tt-despesa.cod-desp       
    " - "  
    tt-despesa.desc-desp
    lb-cod-emitente-desp AT 01 
    ": "
    tt-despesa.cod-emitente-desp
    " - " 
    tt-despesa.desc-emitente 
    lb-mo-codigo AT 01 
    ": "
    tt-despesa.mo-codigo
    " - " 
    tt-despesa.desc-moeda
    lb-cod-cond-pag AT 01
    ": "
    tt-despesa.cod-cond-pag
    " - "
    tt-despesa.desc-cond-pag
    lb-cod-pto-contr AT 01
    ": "
    tt-despesa.cod-pto-contr
    " - "
    tt-despesa.desc-pto-contr
    lb-cod-incoterm-rat AT 01 
    ": "
    tt-despesa.cod-incoterm-rat
    lb-tp-despesa AT 01 
    ": "
    tt-despesa.tp-despesa
    " - "
    tt-despesa.desc-tipo-despesa.
    
    IF NOT l-imposto THEN DO:
        PUT lb-val-desp AT 01 
            ": "
            tt-despesa.val-desp.
    END.
    PUT SKIP(01)
    lb-transacao AT 01 
    ": "
    c-transacao.

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Pedido____Fornecedor_Nome_Abrev___Data_Pedido_Processo_Imp_Incoterm_Itiner rio_Descri‡Æo" *}
PUT UNFORMATTED
    SKIP(2)
    "---------------------------------------------------------- "
    c-pedido
    " ----------------------------------------------------"
    SKIP(1)
    RETURN-VALUE + "                     " AT 01.

IF l-imposto THEN
    /* Inicio -- Projeto Internacional */
    DO:
    DEFINE VARIABLE c-lbl-liter-valor-despesa AS CHARACTER FORMAT "X(16)" NO-UNDO.
    {utp/ut-liter.i "Valor_Despesa" *}
    ASSIGN c-lbl-liter-valor-despesa = TRIM(RETURN-VALUE).
    PUT " " + c-lbl-liter-valor-despesa AT 110.
    END. 

PUT "--------- ---------- ------------ ----------- ------------ -------- ---------- ------------------------------" AT 01.

IF l-imposto THEN
    PUT " ------------------" AT 110.

FOR EACH  tt-pedido
    WHERE tt-pedido.marca = YES:
    PUT tt-pedido.num-pedido    AT 01
        tt-pedido.cod-emitente  AT 12
        tt-pedido.nome-abrev    AT 22
        tt-pedido.data-pedido   AT 36
        tt-pedido.nr-proc-imp   AT 47
        tt-pedido.incoterm      AT 65
        tt-pedido.cod-itiner    AT 73
        tt-pedido.desc-itiner   AT 80.
    IF l-imposto THEN
        PUT tt-pedido.val-desp  AT 110.
END.

/* Imprimir Erros e Advertencias */

IF  CAN-FIND (FIRST tt-erro) THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "C¢digo_Tipo________Mensagem" *}
    PUT UNFORMATTED
        SKIP (2)
        FILL("-":U, 060)              AT 01
        c-mensagem                    AT 62
        FILL("-":U, 061)              AT 72
        SKIP (1)
        RETURN-VALUE AT 01
        FILL("-":U, 006)              AT 01
        FILL("-":U, 011)              AT 08
        FILL("-":U, 113)              AT 20.

    FOR EACH tt-erro
        BREAK BY tt-erro.codigo
              BY tt-erro.tipo:
        PUT tt-erro.codigo    AT 01
            tt-erro.tipo      AT 08
            tt-erro.descricao AT 20.
    END.
END.

VIEW FRAME f-rodape.

{include/i-rpclo.i}

RETURN "OK":U.

