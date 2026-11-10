/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0512RP 2.00.00.002 } /*** 010002 ***/
/******************************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************************/
{utp/ut-glob.i}
{include/i-rpvar.i}
{afp/af0512.i}    

/* Defini‡Æo da temp-table tt-param e tt-digita */
/*******Defini‡Æo de Parƒmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.

DEFINE VARIABLE i-faixa-valor       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-faixa-percentual  AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-af-faixa-demerito NO-UNDO LIKE af-faixa-demerito
    FIELD desc-versao LIKE af-versao-avaliacao.desc-versao
    FIELD descricao LIKE af-controle.descricao
    FIELD ano-avaliacao LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo LIKE af-versao-avaliacao.nr-periodo
    FIELD tipo  AS CHARACTER
    FIELD percentual-ini AS LOGICAL
    FIELD percentual-fim AS LOGICAL.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
{utp/ut-liter.i Listagem_de_Faixa_de_Dem‚rito * C}
ASSIGN c-programa 	  = "AF0512RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = RETURN-VALUE.

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

DEFINE VARIABLE l-mostra        AS LOGICAL  INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE c-selecao       AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-versao-lbl    AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-descricao     AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-descr-form    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-controle      AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-classific     AS CHARACTER FORMAT "x(13)"  NO-UNDO.
DEFINE VARIABLE c-class-lbl     AS CHARACTER FORMAT "x(15)"  NO-UNDO.
DEFINE VARIABLE c-parametros    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-mostra-valor  AS CHARACTER FORMAT "x(25)"  NO-UNDO.
DEFINE VARIABLE c-mostra-perce  AS CHARACTER FORMAT "x(31)"  NO-UNDO.
DEFINE VARIABLE c-demerito      AS CHARACTER FORMAT "x(28)"  NO-UNDO.
DEFINE VARIABLE c-versoes       AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-nr-controle   AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-desc-controle AS CHARACTER FORMAT "x(30)"  NO-UNDO.
DEFINE VARIABLE c-cab-versao    AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-desc-vers     AS CHARACTER FORMAT "x(40)"  NO-UNDO.
DEFINE VARIABLE c-seq           AS CHARACTER FORMAT "x(3)"   NO-UNDO.
DEFINE VARIABLE c-tipo          AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-lim-inicial   AS CHARACTER FORMAT "x(14)"  NO-UNDO.
DEFINE VARIABLE c-lim-final     AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-demerito-form AS CHARACTER FORMAT "x(10)"  NO-UNDO.

{utp/ut-liter.i SELE€ÇO * L}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i VersÆo_: * R}
ASSIGN c-versao-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descri‡Æo_: * R}
ASSIGN c-descricao  = TRIM(RETURN-VALUE)
       c-descr-form = TRIM(RETURN-VALUE).
{utp/ut-liter.i N£mero_Controle_: * R}
ASSIGN c-controle = TRIM(RETURN-VALUE).
{utp/ut-liter.i CLASSIFICA€ÇO * R}
ASSIGN c-classific = TRIM(RETURN-VALUE).
{utp/ut-liter.i Classifica‡Æo_: * R}
ASSIGN c-class-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR¶METROS * R}
ASSIGN c-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_faixas_de_valor_: * R}
ASSIGN c-mostra-valor = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_faixas_por_percentual_: * R}
ASSIGN c-mostra-perce = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_limites_e_dem‚rito_: * R}
ASSIGN c-demerito = TRIM(RETURN-VALUE).
{utp/ut-liter.i Versäes_: * R}
ASSIGN c-versoes = TRIM(RETURN-VALUE).
{utp/ut-liter.i Nr_Controle * L}
ASSIGN c-nr-controle = RETURN-VALUE.
{utp/ut-liter.i Descri‡Æo * L}
ASSIGN c-desc-controle  = RETURN-VALUE
       c-desc-vers      = RETURN-VALUE.
{utp/ut-liter.i VersÆo * L}
ASSIGN c-cab-versao = RETURN-VALUE.
{utp/ut-liter.i Seq * R}
ASSIGN c-seq = RETURN-VALUE.
{utp/ut-liter.i Tipo * L}
ASSIGN c-tipo = RETURN-VALUE.
{utp/ut-liter.i Limite_inicial * R}
ASSIGN c-lim-inicial = RETURN-VALUE.
{utp/ut-liter.i Limite_final * R}
ASSIGN c-lim-final = RETURN-VALUE.
{utp/ut-liter.i %_Dem‚rito * R}
ASSIGN c-demerito-form = RETURN-VALUE.

/***********************************Sele‡Æo**********************************************/
/*Est  utilizando duas vari veis para descri‡Æo, nÆo remover porque se utilizar apenas uma nÆo funciona,
    o mesmo vale para outras vari veis*/
FORM SKIP (2)
    c-selecao     AT  3 NO-LABEL SKIP(1)
    c-versao-lbl  TO 17 NO-LABEL tt-param.i-nr-versao-ini     COLON 17 NO-LABEL "|<  >|" AT 75 tt-param.i-nr-versao-fim     NO-LABEL SKIP
    c-descricao   TO 17 NO-LABEL tt-param.c-descricao-ini     COLON 17 NO-LABEL "|<  >|" AT 75 tt-param.c-descricao-fim     NO-LABEL SKIP
    c-controle    TO 17 NO-LABEL tt-param.i-nr-controle-ini   COLON 17 NO-LABEL "|<  >|" AT 75 tt-param.i-nr-controle-fim   NO-LABEL SKIP
    c-descr-form  TO 17 NO-LABEL tt-param.c-desc-controle-ini COLON 17 NO-LABEL "|<  >|" AT 75 tt-param.c-desc-controle-fim NO-LABEL SKIP
    
    SKIP(2)
    c-classific   AT  3 NO-LABEL SKIP(1)
    c-class-lbl   TO 20 NO-LABEL tt-param.desc-classifica    COLON  20 NO-LABEL

    SKIP(2)                     
    c-parametros   AT  3 NO-LABEL SKIP(1)
    c-mostra-valor TO 32 NO-LABEL tt-param.l-faixa-valor         COLON 32 NO-LABEL FORMAT "Sim/NÆo" 
    c-mostra-perce TO 32 NO-LABEL tt-param.l-faixa-percentual    COLON 32 NO-LABEL FORMAT "Sim/NÆo"     
    c-demerito     TO 32 NO-LABEL tt-param.l-limite-demerito     COLON 32 NO-LABEL FORMAT "Sim/NÆo" 
    c-versoes      TO 32 NO-LABEL tt-param.rs-desc-versao        COLON 32 NO-LABEL

    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM Controle*/
FORM 
    c-nr-controle   NO-LABEL FORMAT 'x(11)'  AT 3
    c-desc-controle NO-LABEL FORMAT 'x(30)'  AT 15
    c-cab-versao    NO-LABEL FORMAT 'x(6)'   AT 46
    c-desc-vers     NO-LABEL FORMAT 'x(40)'  AT 53
    c-seq           NO-LABEL FORMAT 'x(3)'   TO 97
    c-tipo          NO-LABEL FORMAT 'x(10)'  AT 99 SKIP
    "-----------"                               AT 3 
    "------------------------------"            AT 15
    "------"                                    AT 46
    "----------------------------------------"  AT 53
    "----"                                      AT 94
    "----------"                                AT 99

    WITH STREAM-IO DOWN WIDTH 132 FRAME f-faixa-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-cab:HANDLE).


FORM 
    tt-af-faixa-demerito.nr-controle NO-LABEL FORMAT '>>>>>>>>>>9' AT 3 
    tt-af-faixa-demerito.descricao   NO-LABEL FORMAT 'x(30)'       AT 15
    tt-af-faixa-demerito.nr-versao   NO-LABEL FORMAT '>>>>>9'      AT 46
    tt-af-faixa-demerito.desc-versao NO-LABEL FORMAT 'x(40)'       AT 53
    tt-af-faixa-demerito.seq-faixa   NO-LABEL FORMAT '>>>9'        AT 94
    tt-af-faixa-demerito.tipo        NO-LABEL FORMAT 'x(10)'       AT 99

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-faixa.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa:HANDLE).


/* FORM Faixa por valor*/
FORM 
    c-lim-inicial   NO-LABEL FORMAT "x(14)" TO 23
    c-lim-final     NO-LABEL FORMAT "x(12)" TO 46
    c-demerito-form NO-LABEL FORMAT "x(10)" AT 49 SKIP
    "----------------------" AT 3
    "----------------------" AT 26
    "----------"             AT 49

    WITH STREAM-IO DOWN WIDTH 132 FRAME f-limite-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-limite-cab:HANDLE).


FORM 
    tt-af-faixa-demerito.lim-inicial    NO-LABEL FORMAT '->>>,>>>,>>>,>>9.9999' AT 3
    tt-af-faixa-demerito.percentual-ini NO-LABEL FORMAT '%/ '                   AT 24
    tt-af-faixa-demerito.lim-final      NO-LABEL FORMAT '->>>,>>>,>>>,>>9.9999' AT 26
    tt-af-faixa-demerito.percentual-fim NO-LABEL FORMAT '%/ '                   AT 47
    tt-af-faixa-demerito.demerito       NO-LABEL FORMAT '>>9.99'                AT 53

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-limite.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-limite:HANDLE).


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Gerando_Relat¢rio_... * L}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/************************************Execu‡Æo********************************************/
{utp/ut-liter.i Lendo_de_Faixas_de_dem‚ritos_... * L}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF tt-param.l-faixa-valor THEN
    ASSIGN i-faixa-valor = 1.
ELSE
    ASSIGN i-faixa-valor = 0.

IF tt-param.l-faixa-percentual THEN
    ASSIGN i-faixa-percentual = 2.
ELSE
    ASSIGN i-faixa-percentual = 0.

DEFINE BUFFER bfaf-faixa-demerito FOR af-faixa-demerito.
DEFINE BUFFER bfaf-versao-avaliacao FOR af-versao-avaliacao.
DEFINE BUFFER bfaf-controle FOR af-controle.
 
FOR EACH af-faixa-demerito NO-LOCK
    WHERE   af-faixa-demerito.ep-codigo = i-ep-codigo-usuario
    AND     af-faixa-demerito.nr-versao >= tt-param.i-nr-versao-ini
    AND     af-faixa-demerito.nr-versao <= tt-param.i-nr-versao-fim
    AND     af-faixa-demerito.nr-controle >= tt-param.i-nr-controle-ini
    AND     af-faixa-demerito.nr-controle <= tt-param.i-nr-controle-fim
    AND     (af-faixa-demerito.ind-tipo-valor = i-faixa-valor 
             OR af-faixa-demerito.ind-tipo-valor = i-faixa-percentual),
        FIRST af-versao-avaliacao FIELDS (desc-versao ano-avaliacao nr-periodo) NO-LOCK
            WHERE   af-versao-avaliacao.ep-codigo   = i-ep-codigo-usuario
            AND     af-versao-avaliacao.nr-versao   = af-faixa-demerito.nr-versao
            AND     af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim,
        FIRST af-controle FIELDS (descricao) NO-LOCK
            WHERE   af-controle.ep-codigo = i-ep-codigo-usuario
            AND     af-controle.nr-controle = af-faixa-demerito.nr-controle
            AND     af-controle.descricao >= tt-param.c-desc-controle-ini
            AND     af-controle.descricao <= tt-param.c-desc-controle-fim
    BREAK BY af-faixa-demerito.nr-controle
          BY af-versao-avaliacao.ano-avaliacao DESC
          BY af-versao-avaliacao.nr-periodo DESC
          BY af-faixa-demerito.ind-tipo-valor:

    IF tt-param.rsVersoes = 2 THEN DO:
        IF NOT (FIRST-OF (af-faixa-demerito.nr-controle) 
            AND FIRST-OF (af-versao-avaliacao.ano-avaliacao)
            AND FIRST-OF (af-versao-avaliacao.nr-periodo)
            AND FIRST-OF (af-faixa-demerito.ind-tipo-valor)) THEN
            NEXT.
    END.

    CREATE tt-af-faixa-demerito.
    BUFFER-COPY af-faixa-demerito TO tt-af-faixa-demerito. 
    ASSIGN tt-af-faixa-demerito.desc-versao     = af-versao-avaliacao.desc-versao
           tt-af-faixa-demerito.ano-avaliacao   = af-versao-avaliacao.ano-avaliacao
           tt-af-faixa-demerito.nr-periodo      = af-versao-avaliacao.nr-periodo
           tt-af-faixa-demerito.tipo            = {afinc/i01af010.i 04 af-faixa-demerito.ind-tipo-valor}
           tt-af-faixa-demerito.descricao       = af-controle.descricao.

    IF af-faixa-demerito.ind-tipo-valor = 2 THEN DO:    
        ASSIGN tt-af-faixa-demerito.percentual-ini = TRUE
               tt-af-faixa-demerito.percentual-fim = TRUE.
    END.
    ELSE DO:
        ASSIGN tt-af-faixa-demerito.percentual-ini = FALSE
               tt-af-faixa-demerito.percentual-fim = FALSE.
    END.

    /*Se for buscar apenas pela ultima versÆo trazer todas as faixas de dem‚rito Valor/Percentual*/
    IF tt-param.rsVersoes = 2 THEN DO:
        FOR EACH bfaf-faixa-demerito NO-LOCK
            WHERE bfaf-faixa-demerito.ep-codigo     = i-ep-codigo-usuario
            AND   bfaf-faixa-demerito.nr-versao     = af-faixa-demerito.nr-versao
            AND   bfaf-faixa-demerito.nr-controle   = af-faixa-demerito.nr-controle
            AND   (bfaf-faixa-demerito.ind-tipo-valor     = i-faixa-valor 
                    OR bfaf-faixa-demerito.ind-tipo-valor = i-faixa-percentual),
                FIRST bfaf-versao-avaliacao FIELDS (desc-versao ano-avaliacao nr-periodo) NO-LOCK
                    WHERE   bfaf-versao-avaliacao.ep-codigo   = i-ep-codigo-usuario
                    AND     bfaf-versao-avaliacao.nr-versao   = af-faixa-demerito.nr-versao,
                FIRST bfaf-controle FIELDS (descricao) NO-LOCK
                    WHERE   bfaf-controle.ep-codigo = i-ep-codigo-usuario
                    AND     bfaf-controle.nr-controle = af-faixa-demerito.nr-controle
                BREAK BY bfaf-faixa-demerito.nr-controle
                      BY bfaf-versao-avaliacao.ano-avaliacao DESC
                      BY bfaf-versao-avaliacao.nr-periodo DESC
                      BY bfaf-faixa-demerito.ind-tipo-valor:

            FIND FIRST tt-af-faixa-demerito NO-LOCK
                WHERE tt-af-faixa-demerito.nr-versao        = bfaf-faixa-demerito.nr-versao     
                AND   tt-af-faixa-demerito.nr-controle      = bfaf-faixa-demerito.nr-controle   
                AND   tt-af-faixa-demerito.seq-faixa        = bfaf-faixa-demerito.seq-faixa     
                AND   tt-af-faixa-demerito.ind-tipo-valor   = bfaf-faixa-demerito.ind-tipo-valor NO-ERROR.

            IF AVAIL tt-af-faixa-demerito THEN
                NEXT.

            CREATE tt-af-faixa-demerito.
            BUFFER-COPY bfaf-faixa-demerito TO tt-af-faixa-demerito. 
            ASSIGN tt-af-faixa-demerito.desc-versao     = bfaf-versao-avaliacao.desc-versao
                   tt-af-faixa-demerito.ano-avaliacao   = bfaf-versao-avaliacao.ano-avaliacao
                   tt-af-faixa-demerito.nr-periodo      = bfaf-versao-avaliacao.nr-periodo
                   tt-af-faixa-demerito.tipo            = {afinc/i01af010.i 04 bfaf-faixa-demerito.ind-tipo-valor}
                   tt-af-faixa-demerito.descricao       = bfaf-controle.descricao.

            IF bfaf-faixa-demerito.ind-tipo-valor = 2 THEN DO:    
                ASSIGN tt-af-faixa-demerito.percentual-ini = TRUE
                       tt-af-faixa-demerito.percentual-fim = TRUE.
            END.
            ELSE DO:
                ASSIGN tt-af-faixa-demerito.percentual-ini = FALSE
                       tt-af-faixa-demerito.percentual-fim = FALSE.
            END.
        END.
    END.        

END.
{utp/ut-liter.i Gerando_Relat¢rios * L}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF tt-param.classifica = 1 THEN DO:
    /*
        Ordena Por pornto de controle.
    */    
    FOR EACH tt-af-faixa-demerito NO-LOCK
        BY tt-af-faixa-demerito.nr-controle
        BY tt-af-faixa-demerito.nr-versao:
        /*Chama a Procedure para mostrar os registros*/
        RUN pi-controles (INPUT TABLE tt-af-faixa-demerito).
    END.
END.
ELSE DO:
    /*Ordena por VersÆo*/
    FOR EACH tt-af-faixa-demerito NO-LOCK
        BY tt-af-faixa-demerito.nr-versao:
        /*Chama a Procedure para mostrar os registros*/
        RUN pi-controles (INPUT TABLE tt-af-faixa-demerito).
    END.
END.

PROCEDURE pi-controles:
    DEFINE INPUT PARAMETER TABLE FOR tt-af-faixa-demerito.

        IF l-mostra OR tt-param.l-limite-demerito THEN DO:
            ASSIGN l-mostra = FALSE.
            DISPLAY c-nr-controle   
                    c-desc-controle 
                    c-cab-versao    
                    c-desc-vers     
                    c-seq           
                    c-tipo          
                WITH DOWN FRAME f-faixa-cab.
                DOWN WITH FRAME f-faixa-cab.
        END.

        DISPLAY tt-af-faixa-demerito.nr-controle
                tt-af-faixa-demerito.descricao
                tt-af-faixa-demerito.nr-versao
                tt-af-faixa-demerito.desc-versao
                tt-af-faixa-demerito.seq-faixa
                tt-af-faixa-demerito.tipo
            WITH DOWN FRAME f-faixa.
            DOWN WITH FRAME f-faixa.

    IF tt-param.l-limite-demerito THEN DO:

        DISPLAY c-lim-inicial   
                c-lim-final     
                c-demerito-form 
            WITH DOWN FRAME f-limite-cab.
            DOWN WITH FRAME f-limite-cab.

        DISPLAY tt-af-faixa-demerito.lim-inicial  
                tt-af-faixa-demerito.percentual-ini
                tt-af-faixa-demerito.lim-final
                tt-af-faixa-demerito.percentual-fim
                tt-af-faixa-demerito.demerito
            WITH DOWN FRAME f-limite.
            DOWN WITH FRAME f-limite.
    END.
END.

/****************************************************************************************/

/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY c-selecao
            c-versao-lbl
            tt-param.i-nr-versao-ini    
            tt-param.i-nr-versao-fim 
            c-descricao
            tt-param.c-descricao-ini 
            tt-param.c-descricao-fim
            c-controle
            tt-param.i-nr-controle-ini
            tt-param.i-nr-controle-fim
            c-descr-form
            tt-param.c-desc-controle-ini   
            tt-param.c-desc-controle-fim 
            c-classific
            c-class-lbl
            tt-param.desc-classifica
            c-parametros
            c-mostra-valor
            tt-param.l-faixa-valor
            c-mostra-perce
            tt-param.l-faixa-percentual
            c-demerito
            tt-param.l-limite-demerito
            c-versoes
            tt-param.rs-desc-versao
            WITH  FRAME f-param-sel.

/***********************************Finalizando******************************************/

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN DO:
    DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
END.

{include/i-rpclo.i}

RETURN "OK":U.
