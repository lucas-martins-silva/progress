/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0509RP 2.00.00.007 } /*** 010007 ***/
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
{afp/af0509.i}    

/* Defini‡Æo da temp-table tt-param e tt-digita */
/*******Defini‡Æo de Parƒmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.
DEFINE BUFFER bfaf-formula FOR af-formula.
DEFINE VARIABLE l-mostra-titulo AS LOGICAL INIT FALSE    NO-UNDO.


DEFINE TEMP-TABLE tt-af-formula NO-UNDO LIKE af-formula 
    FIELDS ano-avaliacao LIKE af-versao-avaliacao.ano-avaliacao 
    FIELDS nr-periodo LIKE af-versao-avaliacao.nr-periodo
    FIELDS desc-versao LIKE af-versao-avaliacao.desc-versao
    FIELDS l-pode-excluir AS LOGICAL.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
{utp/ut-liter.i Elimina‡Æo_de_Versäes * C}
ASSIGN c-programa 	  = "AF0509RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = RETURN-VALUE.

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

DEFINE VARIABLE l-mostra          AS LOGICAL  INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE c-selecao         AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-versao-lbl      AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-descricao       AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-familia         AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-item            AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-estabel         AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-fornecedor      AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-grp-aval        AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-controle        AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-formula         AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-descr-form      AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-parametros      AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-fam-aval-for    AS CHARACTER FORMAT "x(32)"  NO-UNDO.
DEFINE VARIABLE c-item-ava-for    AS CHARACTER FORMAT "x(29)"  NO-UNDO.
DEFINE VARIABLE c-item-est-for    AS CHARACTER FORMAT "x(47)"  NO-UNDO.
DEFINE VARIABLE c-grupo-aval      AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE c-fx-demerito     AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-form-calc       AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE c-sim-elimin      AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-lbl-fm-cod      AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-lbl-fornec      AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-lbl-versao      AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-lbl-descr       AS CHARACTER FORMAT "x(40)"  NO-UNDO.
DEFINE VARIABLE c-lbl-it          AS CHARACTER FORMAT "x(16)"  NO-UNDO.
DEFINE VARIABLE c-lbl-estab       AS CHARACTER FORMAT "x(5)"   NO-UNDO.
DEFINE VARIABLE c-lbl-grp-aval    AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-lbl-grp-desc    AS CHARACTER FORMAT "x(40)"  NO-UNDO.
DEFINE VARIABLE c-lbl-nr-contr    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-lbl-ctr-desc    AS CHARACTER FORMAT "x(30)"  NO-UNDO.
DEFINE VARIABLE c-lbl-seq         AS CHARACTER FORMAT "x(4)"   NO-UNDO.
DEFINE VARIABLE c-lbl-tipo        AS CHARACTER FORMAT "x(4)"   NO-UNDO.
DEFINE VARIABLE c-lbl-formula     AS CHARACTER FORMAT "x(14)"  NO-UNDO.
DEFINE VARIABLE c-lbl-form-desc   AS CHARACTER FORMAT "x(50)"  NO-UNDO.
DEFINE VARIABLE c-titulo          AS CHARACTER FORMAT "x(75)"  NO-UNDO.
DEFINE VARIABLE c-desc-tipo-faixa AS CHARACTER FORMAT "x(10)"  NO-UNDO.

{utp/ut-liter.i SELE€ÇO * L}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i VersÆo_: * R}
ASSIGN c-versao-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descri‡Æo_: * R}
ASSIGN c-descricao  = TRIM(RETURN-VALUE)
       c-descr-form = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam¡lia_: * R}
ASSIGN c-familia = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_: * R}
ASSIGN c-item = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento_: * R}
ASSIGN c-estabel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor_: * R}
ASSIGN c-fornecedor = TRIM(RETURN-VALUE).
{utp/ut-liter.i Grupo_Avalia‡Æo_: * R}
ASSIGN c-grp-aval = TRIM(RETURN-VALUE).
{utp/ut-liter.i N£mero_Controle_: * R}
ASSIGN c-controle = TRIM(RETURN-VALUE).
{utp/ut-liter.i F¢rmula_: * R}
ASSIGN c-formula = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR¶METROS * R}
ASSIGN c-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam¡lia_Avalia‡Æo_Fornecedores_: * R}
ASSIGN c-fam-aval-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_Avalia‡Æo_Fornecedores_: * R}
ASSIGN c-item-ava-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_x_Estabelecimento_Avalia‡Æo_Fornecedores_: * R}
ASSIGN c-item-est-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Grupo_de_Avalia‡Æo_: * R}
ASSIGN c-grupo-aval = TRIM(RETURN-VALUE).
{utp/ut-liter.i Faixa_de_Dem‚rito_: * R}
ASSIGN c-fx-demerito = TRIM(RETURN-VALUE).
{utp/ut-liter.i F¢rmula_de_C lculo_: * R}
ASSIGN c-form-calc = TRIM(RETURN-VALUE).
{utp/ut-liter.i Simula_Elimina‡Æo_: * R}
ASSIGN c-sim-elimin = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam¡lia * L}
ASSIGN c-lbl-fm-cod = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor * L}
ASSIGN c-lbl-fornec = TRIM(RETURN-VALUE).
{utp/ut-liter.i VersÆo * L}
ASSIGN c-lbl-versao = TRIM(RETURN-VALUE).    
{utp/ut-liter.i Descri‡Æo * L}
ASSIGN c-lbl-descr     = TRIM(RETURN-VALUE)
       c-lbl-ctr-desc  = TRIM(RETURN-VALUE)
       c-lbl-form-desc = TRIM(RETURN-VALUE)
       c-lbl-grp-desc  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * L}
ASSIGN c-lbl-it = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estab * L}
ASSIGN c-lbl-estab = TRIM(RETURN-VALUE).
{utp/ut-liter.i Grupo * L}
ASSIGN c-lbl-grp-aval = TRIM(RETURN-VALUE).
{utp/ut-liter.i Nr_Controle * R}
ASSIGN c-lbl-nr-contr = TRIM(RETURN-VALUE).
{utp/ut-liter.i Seq * R}
ASSIGN c-lbl-seq = TRIM(RETURN-VALUE).
{utp/ut-liter.i C¢digo_F¢rmula * R}
ASSIGN c-lbl-formula = TRIM(RETURN-VALUE).
{utp/ut-liter.i Tipo * R}
ASSIGN c-lbl-tipo = TRIM(RETURN-VALUE).

/***********************************Sele‡Æo**********************************************/
FORM SKIP (2)
    c-selecao     AT  3 NO-LABEL SKIP(1)
    c-versao-lbl  TO 17 NO-LABEL tt-param.i-nr-versao-ini       COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.i-nr-versao-fim        NO-LABEL SKIP
    c-descricao   TO 17 NO-LABEL tt-param.c-descricao-ini       COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-descricao-fim        NO-LABEL SKIP
    c-familia     TO 17 NO-LABEL tt-param.c-familia-ini         COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-familia-fim          NO-LABEL SKIP
    c-item        TO 17 NO-LABEL tt-param.c-item-ini            COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-item-fim             NO-LABEL SKIP
    c-estabel     TO 17 NO-LABEL tt-param.c-estabelecimento-ini COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-estabelecimento-fim  NO-LABEL SKIP
    c-fornecedor  TO 17 NO-LABEL tt-param.i-fornecedor-ini      COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.i-fornecedor-fim       NO-LABEL SKIP
    c-grp-aval    TO 17 NO-LABEL tt-param.c-grp-avaliacao-ini   COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-grp-avaliacao-fim    NO-LABEL SKIP
    c-controle    TO 17 NO-LABEL tt-param.i-nr-controle-ini     COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.i-nr-controle-fim      NO-LABEL SKIP
    c-formula     TO 17 NO-LABEL tt-param.i-cod-formula-ini     COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.i-cod-formula-fim      NO-LABEL SKIP
    c-descr-form  TO 17 NO-LABEL tt-param.c-desc-form-ini       COLON 17 NO-LABEL  "|<  >|" AT 74 tt-param.c-desc-form-fim        NO-LABEL SKIP
    SKIP(2)
    c-parametros    AT  3 NO-LABEL SKIP(1)
    c-fam-aval-for  TO 48 NO-LABEL tt-param.l-familia-fornecedor    COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-item-ava-for  TO 48 NO-LABEL tt-param.l-item-fornecedor       COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-item-est-for  TO 48 NO-LABEL tt-param.l-item-estabelecimento  COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-grupo-aval    TO 48 NO-LABEL tt-param.l-grupo                 COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-fx-demerito   TO 48 NO-LABEL tt-param.l-faixa-demerito        COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-form-calc     TO 48 NO-LABEL tt-param.l-faixa-calculo         COLON 48 NO-LABEL FORMAT "Sim/NÆo" 
    c-sim-elimin    TO 48 NO-LABEL tt-param.l-simula-eliminacao     COLON 48 NO-LABEL FORMAT "Sim/NÆo" 

    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/

/********************************Frames**************************************************/
/*FORM Fam¡lia Avalia‡Æo Fornecedores*/
FORM
    SKIP
    c-titulo     NO-LABEL FORMAT 'x(75)'  AT 3 SKIP(1)
    c-lbl-fm-cod NO-LABEL FORMAT 'x(8)'   AT 3
    c-lbl-fornec NO-LABEL FORMAT 'x(10)'  AT 12
    c-lbl-versao NO-LABEL FORMAT 'x(6)'   AT 24
    c-lbl-descr  NO-LABEL FORMAT 'x(40)'  AT 32 SKIP
    "--------"                                  AT 3
    "----------"                                AT 12
    "------"                                    AT 24
    "----------------------------------------"  AT 32

   WITH STREAM-IO DOWN WIDTH 132 FRAME f-familia-fornecedor-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familia-fornecedor-cab:HANDLE).


FORM     
    af-familia-contr.fm-codigo            NO-LABEL FORMAT 'x(8)'       AT 3
    af-familia-contr.cod-emitente         NO-LABEL FORMAT '>>>>>>>>9'  AT 13
    af-familia-contr.nr-versao            NO-LABEL FORMAT '>>>>9'      AT 25
    af-versao-avaliacao.desc-versao       NO-LABEL FORMAT 'x(40)'      AT 32

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-familia-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familia-fornecedor:HANDLE).


/*FORM Item Avalia‡Æo Fornecedores*/
FORM
    SKIP
    c-titulo     NO-LABEL FORMAT 'x(75)'   AT 3 SKIP(1)
    c-lbl-it     NO-LABEL FORMAT 'x(16)'   AT 3
    c-lbl-fornec NO-LABEL FORMAT 'x(10)'   AT 21
    c-lbl-versao NO-LABEL FORMAT 'x(6)'    AT 33
    c-lbl-descr  NO-LABEL FORMAT 'x(40)'   AT 41 SKIP
    "----------------"                         AT 3 
    "----------"                               AT 21
    "------"                                   AT 33
    "----------------------------------------" AT 41

   WITH STREAM-IO DOWN WIDTH 132 FRAME f-item-fornecedor-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-fornecedor-cab:HANDLE).


FORM     
    af-item-contr.it-codigo            NO-LABEL FORMAT 'x(16)'       AT 3
    af-item-contr.cod-emitente         NO-LABEL FORMAT '>>>>>>>>9'  AT 22
    af-item-contr.nr-versao            NO-LABEL FORMAT '>>>>9'      AT 34
    af-versao-avaliacao.desc-versao    NO-LABEL FORMAT 'x(40)'      AT 41

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-fornecedor:HANDLE).


/*FORM Itens x Estabelecimento Avalia‡Æo Fornecedores*/
FORM
    SKIP
    c-titulo     NO-LABEL FORMAT 'x(75)'   AT 3 SKIP(1)
    c-lbl-it     NO-LABEL FORMAT 'x(16)'   AT 3
    c-lbl-estab  NO-LABEL FORMAT 'x(5)'    AT 21
    c-lbl-fornec NO-LABEL FORMAT 'x(10)'   AT 28
    c-lbl-versao NO-LABEL FORMAT 'x(6)'    AT 40
    c-lbl-descr  NO-LABEL FORMAT 'x(40)'   AT 48 SKIP
    "----------------"                         AT 3 
    "-----"                                    AT 21 
    "----------"                               AT 28
    "------"                                   AT 40
    "----------------------------------------" AT 48

   WITH STREAM-IO DOWN WIDTH 132 FRAME f-item-estab-fornecedor-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-estab-fornecedor-cab:HANDLE).



FORM     
    af-item-contr-estab.it-codigo     NO-LABEL FORMAT 'x(16)'      AT 3
    af-item-contr-estab.cod-estabel   NO-LABEL FORMAT 'x(5)'       AT 21
    af-item-contr-estab.cod-emitente  NO-LABEL FORMAT '>>>>>>>>9'  AT 29
    af-item-contr-estab.nr-versao     NO-LABEL FORMAT '>>>>9'      AT 41
    af-versao-avaliacao.desc-versao   NO-LABEL FORMAT 'x(40)'      AT 48

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-estab-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-estab-fornecedor:HANDLE).


/*FORM Grupo de Avalia‡Æo*/
FORM
    SKIP
    c-titulo        NO-LABEL FORMAT 'x(75)'   AT 3 SKIP(1)
    c-lbl-grp-aval  NO-LABEL FORMAT 'x(8)'    AT 3
    c-lbl-grp-desc  NO-LABEL FORMAT 'x(40)'   AT 13
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'    AT 40
    c-lbl-descr     NO-LABEL FORMAT 'x(40)'   AT 48 SKIP
    "--------"                                  AT 3 
    "----------------------------------------"  AT 13
    "------"                                    AT 41
    "----------------------------------------"  AT 48

   WITH STREAM-IO DOWN WIDTH 132 FRAME f-grupo-avaliacao-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo-avaliacao-cab:HANDLE).


FORM     
    af-grp-avaliacao.cod-grp-avaliacao  NO-LABEL FORMAT 'x(8)'       AT 3
    af-grp-avaliacao.des-grp-avaliacao  NO-LABEL FORMAT 'x(40)'      AT 13
    af-grp-avaliacao.nr-versao          NO-LABEL FORMAT '>>>>9'      AT 55    
    af-versao-avaliacao.desc-versao     NO-LABEL FORMAT 'x(40)'      AT 63

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-grupo-avaliacao.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo-avaliacao:HANDLE).


/*FORM Faixa de dem‚rito*/
FORM
    SKIP
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-nr-contr  NO-LABEL FORMAT "x(11)" AT 3
    c-lbl-ctr-desc  NO-LABEL FORMAT "x(30)" AT 15
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'  AT 47
    c-lbl-descr     NO-LABEL FORMAT 'x(40)' AT 55 
    c-lbl-seq       NO-LABEL FORMAT 'x(4)'  AT 97 
    c-lbl-tipo      NO-LABEL FORMAT 'x(4)'  AT 102 SKIP
    "-----------"                              AT 3 
    "------------------------------"           AT 15
    "------"                                   AT 47
    "----------------------------------------" AT 55
    "----"                                     AT 97
    "----------"                               AT 102

    WITH STREAM-IO DOWN WIDTH 132 FRAME f-faixa-demerito-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-demerito-cab:HANDLE).

FORM 
    af-faixa-demerito.nr-controle      NO-LABEL FORMAT '>>>>>9'      AT 8
    af-controle.descricao              NO-LABEL FORMAT 'x(30)'       AT 15
    af-faixa-demerito.nr-versao        NO-LABEL FORMAT '>>>>9'       AT 48
    af-versao-avaliacao.desc-versao    NO-LABEL FORMAT 'x(40)'       AT 55
    af-faixa-demerito.seq-faixa        NO-LABEL FORMAT '>>>9'        AT 97
    c-desc-tipo-faixa                  NO-LABEL FORMAT "x(10)"       AT 102

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-faixa-demerito.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-demerito:HANDLE).


/*FORM F¢rmula de C lculo*/
FORM
    SKIP
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-formula   NO-LABEL FORMAT 'x(14)' AT 3 
    c-lbl-form-desc NO-LABEL FORMAT 'x(50)' AT 19 
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'  AT 71 
    c-lbl-descr     NO-LABEL FORMAT 'x(40)' AT 79 SKIP
    "--------------"                                     AT 3 
    "--------------------------------------------------" AT 19
    "------"                                             AT 71
    "----------------------------------------"           AT 79

    WITH STREAM-IO DOWN WIDTH 132 FRAME f-faixa-calculo-cab.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-calculo-cab:HANDLE).


FORM
    tt-af-formula.cod-formula  NO-LABEL FORMAT '>>>>>9'     AT 11
    tt-af-formula.descricao    NO-LABEL FORMAT 'x(50)'      AT 19
    tt-af-formula.nr-versao    NO-LABEL FORMAT '>>>>9'      AT 72
    tt-af-formula.desc-versao  NO-LABEL FORMAT 'x(40)'      AT 79

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-faixa-calculo.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-calculo:HANDLE).


/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF tt-param.l-simula-eliminacao THEN
    {utp/ut-liter.i Simulando_Elimina‡Æo_de_Registros_... * L}
ELSE
    {utp/ut-liter.i Elimina‡Æo_de_Registros_... * L}

RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/************************************Execu‡Æo********************************************/


IF tt-param.l-familia-fornecedor THEN DO:

    DEFINE BUFFER bfaf-familia-contr FOR af-familia-contr.

    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_da_Fam¡lia_Avalia‡Æo_Fornecedores_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_Fam¡lia_Avalia‡Æo_Fornecedores_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    
    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-familia-contr NO-LOCK
        WHERE   (af-familia-contr.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-familia-contr.nr-versao <= tt-param.i-nr-versao-fim)
        AND     (af-familia-contr.fm-codigo >= tt-param.c-familia-ini
        AND     af-familia-contr.fm-codigo <= tt-param.c-familia-fim)
        AND     (af-familia-contr.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-familia-contr.cod-emitente <= tt-param.i-fornecedor-fim)
        AND     af-familia-contr.ep-codigo = i-ep-codigo-usuario,
            FIRST af-versao-avaliacao NO-LOCK
            WHERE   af-familia-contr.nr-versao = af-versao-avaliacao.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-familia-contr.ep-codigo = i-ep-codigo-usuario:

        IF NOT l-mostra-titulo THEN DO:
            {utp/ut-liter.i Fam¡lia_Avalia‡Æo_Fornecedores * L}
            ASSIGN c-titulo = RETURN-VALUE.

            DISPLAY c-titulo
                    c-lbl-fm-cod
                    c-lbl-fornec
                    c-lbl-versao
                    c-lbl-descr
            WITH DOWN FRAME f-familia-fornecedor-cab.
            DOWN WITH FRAME f-familia-fornecedor-cab.

            ASSIGN l-mostra-titulo = TRUE.
        END.
        DISPLAY af-familia-contr.fm-codigo
                af-familia-contr.cod-emitente
                af-familia-contr.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-familia-fornecedor.
            DOWN WITH FRAME f-familia-fornecedor.

            IF NOT tt-param.l-simula-eliminacao THEN DO:
                FIND FIRST bfaf-familia-contr EXCLUSIVE-LOCK
                    WHERE   bfaf-familia-contr.ep-codigo    = i-ep-codigo-usuario
                    AND     bfaf-familia-contr.nr-versao    = af-familia-contr.nr-versao
                    AND     bfaf-familia-contr.fm-codigo    = af-familia-contr.fm-codigo
                    AND     bfaf-familia-contr.cod-emitente = af-familia-contr.cod-emitente NO-ERROR.
                IF AVAIL bfaf-familia-contr THEN DO:
                    /*
                        Antes de Excluir a fam¡lia, excluir as f¢rmulas das fam¡lias.
                    */
                    FOR EACH af-familia-contr-form EXCLUSIVE-LOCK
                        WHERE   af-familia-contr-form.ep-codigo    = i-ep-codigo-usuario            
                        AND     af-familia-contr-form.nr-versao    = af-familia-contr.nr-versao     
                        AND     af-familia-contr-form.fm-codigo    = af-familia-contr.fm-codigo     
                        AND     af-familia-contr-form.cod-emitente = af-familia-contr.cod-emitente:
                        DELETE af-familia-contr-form.
                    END.
                    DELETE bfaf-familia-contr.
                END.
                    
            END.
    END.
END.

IF tt-param.l-item-fornecedor THEN DO:

   DEFINE BUFFER bfaf-item-contr FOR af-item-contr.
    
    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_dos_Itens_Avalia‡Æo_Fornecedores_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_Itens_Avalia‡Æo_Fornecedores_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
  
   ASSIGN l-mostra-titulo = FALSE.

   FOR EACH af-item-contr NO-LOCK
       WHERE   (af-item-contr.nr-versao >= tt-param.i-nr-versao-ini
       AND     af-item-contr.nr-versao <= tt-param.i-nr-versao-fim)
       AND     (af-item-contr.it-codigo >= tt-param.c-item-ini
       AND     af-item-contr.it-codigo <= tt-param.c-item-fim)
       AND     (af-item-contr.cod-emitente >= tt-param.i-fornecedor-ini
       AND     af-item-contr.cod-emitente <= tt-param.i-fornecedor-fim)
       AND     af-item-contr.ep-codigo = i-ep-codigo-usuario,
           FIRST af-versao-avaliacao NO-LOCK
           WHERE   af-item-contr.nr-versao = af-versao-avaliacao.nr-versao
           AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
           AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
           AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:

       IF NOT l-mostra-titulo THEN DO:
           {utp/ut-liter.i Itens_Avalia‡Æo_Fornecedores * L}
           ASSIGN c-titulo = RETURN-VALUE.
           DISPLAY c-titulo
                   c-lbl-it     
                   c-lbl-fornec 
                   c-lbl-versao 
                   c-lbl-descr  
            WITH DOWN FRAME f-item-fornecedor-cab.
            DOWN WITH FRAME f-item-fornecedor-cab.

           ASSIGN l-mostra-titulo = TRUE.
       END.

       DISPLAY af-item-contr.it-codigo
               af-item-contr.cod-emitente
               af-item-contr.nr-versao
               af-versao-avaliacao.desc-versao
           WITH DOWN FRAME f-item-fornecedor.
           DOWN WITH FRAME f-item-fornecedor.

           IF NOT tt-param.l-simula-eliminacao THEN DO:
               FIND FIRST bfaf-item-contr EXCLUSIVE-LOCK
                   WHERE    bfaf-item-contr.ep-codigo   = i-ep-codigo-usuario
                    AND     bfaf-item-contr.nr-versao   = af-item-contr.nr-versao
                    AND     bfaf-item-contr.it-codigo   = af-item-contr.it-codigo
                    AND     bfaf-item-contr.cod-emitente= af-item-contr.cod-emitente NO-ERROR.
               IF AVAIL bfaf-item-contr THEN DO:
                   /*
                    Antes de excluir os itens, excluir as f¢rmulas dos itens
                   */
                   FOR EACH af-item-contr-form EXCLUSIVE-LOCK
                        WHERE af-item-contr-form.ep-codigo   = i-ep-codigo-usuario       
                         AND  af-item-contr-form.nr-versao   = af-item-contr.nr-versao   
                         AND  af-item-contr-form.it-codigo   = af-item-contr.it-codigo   
                         AND  af-item-contr-form.cod-emitente= af-item-contr.cod-emitente:
                       DELETE af-item-contr-form.
                   END.
                   DELETE bfaf-item-contr.
               END.
           END.
   END.
END.

IF tt-param.l-item-estabelecimento THEN DO:

    DEFINE BUFFER bfaf-item-contr-estab FOR af-item-contr-estab.

    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_dos_Itens_x_Estabelecimento_Avalia‡Æo_Fornecedores_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_Itens_x_Estabelecimento_Avalia‡Æo_Fornecedores_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
    
    ASSIGN l-mostra-titulo = FALSE.

    DEFINE VARIABLE l-log-elimina-relac AS LOGICAL     NO-UNDO.

    IF CAN-FIND (FIRST param-af NO-LOCK
                 WHERE param-af.ep-codigo           = i-ep-codigo-usuario 
                 AND   param-af.log-elimina-relac   = YES) THEN
        ASSIGN l-log-elimina-relac = TRUE.
    ELSE
        ASSIGN l-log-elimina-relac = FALSE.        

    FOR EACH af-item-contr-estab NO-LOCK
        WHERE   (af-item-contr-estab.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-item-contr-estab.nr-versao <= tt-param.i-nr-versao-fim)
        AND     (af-item-contr-estab.it-codigo >= tt-param.c-item-ini
        AND     af-item-contr-estab.it-codigo <= tt-param.c-item-fim)
        AND     (af-item-contr-estab.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-item-contr-estab.cod-emitente <= tt-param.i-fornecedor-fim)
        AND     (af-item-contr-estab.cod-estabel >= tt-param.c-estabelecimento-ini
        AND     af-item-contr-estab.cod-estabel <= tt-param.c-estabelecimento-fim)
        AND     af-item-contr-estab.ep-codigo = i-ep-codigo-usuario,
            FIRST af-versao-avaliacao NO-LOCK
            WHERE    af-item-contr-estab.nr-versao   = af-versao-avaliacao.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:

        IF NOT l-log-elimina-relac THEN DO:            
            IF CAN-FIND (FIRST af-contr-indice NO-LOCK
                 WHERE  af-contr-indice.ep-codigo   = i-ep-codigo-usuario
                 AND    af-contr-indice.it-codigo   = af-item-contr-estab.it-codigo
                 AND    af-contr-indice.cod-emitente= af-item-contr-estab.cod-emitente
                 AND    af-contr-indice.cod-estabel = af-item-contr-estab.cod-estabel
                 AND    af-contr-indice.nr-versao   = af-item-contr-estab.nr-versao) THEN
                NEXT.
        END.

        IF NOT l-mostra-titulo THEN DO:
            {utp/ut-liter.i Itens_x_Estabelecimento_Avalia‡Æo_Fornecedores * L}
            ASSIGN c-titulo = RETURN-VALUE.
            DISPLAY c-titulo
                    c-lbl-it     
                    c-lbl-estab  
                    c-lbl-fornec 
                    c-lbl-versao 
                    c-lbl-descr  
            WITH DOWN FRAME f-item-estab-fornecedor-cab.
            DOWN WITH FRAME f-item-estab-fornecedor-cab.

            ASSIGN l-mostra-titulo = TRUE.
        END.

        DISPLAY af-item-contr-estab.it-codigo
                af-item-contr-estab.cod-estabel
                af-item-contr-estab.cod-emitente
                af-item-contr-estab.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-item-estab-fornecedor.
            DOWN WITH FRAME f-item-estab-fornecedor.

            IF NOT tt-param.l-simula-eliminacao THEN DO:
                FIND FIRST bfaf-item-contr-estab EXCLUSIVE-LOCK
                    WHERE   bfaf-item-contr-estab.ep-codigo     = i-ep-codigo-usuario
                    AND     bfaf-item-contr-estab.nr-versao     = af-item-contr-estab.nr-versao
                    AND     bfaf-item-contr-estab.it-codigo     = af-item-contr-estab.it-codigo
                    AND     bfaf-item-contr-estab.cod-emitente  = af-item-contr-estab.cod-emitente
                    AND     bfaf-item-contr-estab.cod-estabel   = af-item-contr-estab.cod-estabel NO-ERROR.
                IF AVAIL bfaf-item-contr-estab THEN DO:
                    /*
                     Antes de excluir o item X Estabelecimento, excluir as f¢rmulas                    
                    */
                    FOR EACH af-item-contr-estab-form EXCLUSIVE-LOCK
                        WHERE   af-item-contr-estab-form.ep-codigo     = i-ep-codigo-usuario             
                        AND     af-item-contr-estab-form.nr-versao     = af-item-contr-estab.nr-versao   
                        AND     af-item-contr-estab-form.it-codigo     = af-item-contr-estab.it-codigo   
                        AND     af-item-contr-estab-form.cod-emitente  = af-item-contr-estab.cod-emitente
                        AND     af-item-contr-estab-form.cod-estabel   = af-item-contr-estab.cod-estabel:
                        DELETE  af-item-contr-estab-form.
                    END.
                    DELETE bfaf-item-contr-estab.
                END.
            END.
    END.
END.

IF tt-param.l-grupo THEN DO:

    DEFINE BUFFER bfaf-grp-avaliacao FOR af-grp-avaliacao.

    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_dos_Grupos_de_Avalia‡Æo_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_dos_Grupos_de_Avalia‡Æo_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-grp-avaliacao NO-LOCK
        WHERE   (af-grp-avaliacao.cod-grp-avaliacao >= tt-param.c-grp-avaliacao-ini
        AND     af-grp-avaliacao.cod-grp-avaliacao <=tt-param.c-grp-avaliacao-fim)
        AND     (af-grp-avaliacao.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-grp-avaliacao.nr-versao <= tt-param.i-nr-versao-fim)
        AND     af-grp-avaliacao.ep-codigo  = i-ep-codigo-usuario,
        FIRST   af-versao-avaliacao NO-LOCK
            WHERE   af-versao-avaliacao.nr-versao = af-grp-avaliacao.nr-versao        
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:



        IF CAN-FIND (FIRST af-familia-contr NO-LOCK
                     WHERE  af-familia-contr.cod-grp-avaliacao = af-grp-avaliacao.cod-grp-avaliacao
                     AND    af-familia-contr.nr-versao = af-grp-avaliacao.nr-versao
                     AND    af-familia-contr.ep-codigo = i-ep-codigo-usuario) THEN
            NEXT.

        IF CAN-FIND (FIRST af-item-contr NO-LOCK
                     WHERE  af-item-contr.cod-grp-avaliacao = af-grp-avaliacao.cod-grp-avaliacao
                     AND    af-item-contr.nr-versao = af-grp-avaliacao.nr-versao 
                     AND    af-item-contr.ep-codigo = i-ep-codigo-usuario) THEN
            NEXT.

        IF CAN-FIND (FIRST af-item-contr-estab NO-LOCK
                     WHERE  af-item-contr-estab.cod-grp-avaliacao = af-grp-avaliacao.cod-grp-avaliacao
                     AND    af-item-contr-estab.nr-versao = af-grp-avaliacao.nr-versao 
                     AND    af-item-contr-estab.ep-codigo = i-ep-codigo-usuario) THEN
            NEXT.

        IF NOT l-mostra-titulo THEN DO:
            {utp/ut-liter.i Grupos_de_Avalia‡Æo * L}
            ASSIGN c-titulo = RETURN-VALUE.
            DISPLAY c-titulo
                    c-lbl-grp-aval
                    c-lbl-grp-desc
                    c-lbl-versao  
                    c-lbl-descr   
                WITH DOWN FRAME f-grupo-avaliacao-cab.
                DOWN WITH FRAME f-grupo-avaliacao-cab.

            ASSIGN l-mostra-titulo = TRUE.
        END.
        DISPLAY af-grp-avaliacao.cod-grp-avaliacao
                af-grp-avaliacao.des-grp-avaliacao
                af-grp-avaliacao.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-grupo-avaliacao.
            DOWN WITH FRAME f-grupo-avaliacao.

            IF NOT tt-param.l-simula-eliminacao THEN DO:
                FIND FIRST bfaf-grp-avaliacao EXCLUSIVE-LOCK
                    WHERE   bfaf-grp-avaliacao.ep-codigo            = i-ep-codigo-usuario
                    AND     bfaf-grp-avaliacao.cod-grp-avaliacao    = af-grp-avaliacao.cod-grp-avaliacao
                    AND     bfaf-grp-avaliacao.nr-versao            = af-grp-avaliacao.nr-versao NO-ERROR.
                IF AVAIL bfaf-grp-avaliacao THEN DO:
                    /*
                        Antes de Excluir o Grupo excluir as f¢rmulas do grupo.
                    */
                    FOR EACH af-grp-avaliacao-form EXCLUSIVE-LOCK
                        WHERE af-grp-avaliacao-form.ep-codigo           = i-ep-codigo-usuario
                        AND   af-grp-avaliacao-form.cod-grp-avaliacao   = bfaf-grp-avaliacao.cod-grp-avaliacao
                        AND   af-grp-avaliacao-form.nr-versao           = bfaf-grp-avaliacao.nr-versao:
                        DELETE af-grp-avaliacao-form.
                    END.
                    DELETE bfaf-grp-avaliacao.
                END.
            END.
    END.
END.

IF tt-param.l-faixa-demerito THEN DO:

    DEFINE BUFFER bfaf-faixa-demerito FOR af-faixa-demerito.


    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_das_Faixas_de_Dem‚rito_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_das_Faixas_de_Dem‚rito_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-faixa-demerito NO-LOCK
        WHERE   af-faixa-demerito.ep-codigo   =  i-ep-codigo-usuario
        AND     (af-faixa-demerito.nr-controle >= tt-param.i-nr-controle-ini
        AND     af-faixa-demerito.nr-controle <= tt-param.i-nr-controle-fim)
        AND     (af-faixa-demerito.nr-versao   >= tt-param.i-nr-versao-ini
        AND     af-faixa-demerito.nr-versao   <= tt-param.i-nr-versao-fim),
            FIRST af-controle NO-LOCK
                WHERE   af-controle.ep-codigo = i-ep-codigo-usuario
                AND     af-controle.nr-controle = af-faixa-demerito.nr-controle,
            FIRST af-versao-avaliacao NO-LOCK
                WHERE   af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario
                AND     af-versao-avaliacao.nr-versao = af-faixa-demerito.nr-versao
                AND    (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
                AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim):

        IF NOT l-mostra-titulo THEN DO:
            {utp/ut-liter.i Faixa_de_Dem‚rito * L}
            ASSIGN c-titulo = RETURN-VALUE.
            DISPLAY c-titulo
                    c-lbl-nr-contr
                    c-lbl-ctr-desc
                    c-lbl-versao
                    c-lbl-descr
                    c-lbl-seq
                    c-lbl-tipo
                WITH DOWN FRAME f-faixa-demerito-cab.
                DOWN WITH FRAME f-faixa-demerito-cab.

            ASSIGN l-mostra-titulo = TRUE.
        END.

        ASSIGN c-desc-tipo-faixa = {afinc/i01af010.i 04 af-faixa-demerito.ind-tipo-valor}.
        DISPLAY af-faixa-demerito.nr-controle
                af-controle.descricao
                af-faixa-demerito.nr-versao
                af-versao-avaliacao.desc-versao
                af-faixa-demerito.seq-faixa
                c-desc-tipo-faixa
            WITH DOWN FRAME f-faixa-demerito.
            DOWN WITH FRAME f-faixa-demerito.

            IF NOT tt-param.l-simula-eliminacao THEN DO:
                FIND FIRST  bfaf-faixa-demerito EXCLUSIVE-LOCK
                    WHERE   bfaf-faixa-demerito.ep-codigo   = i-ep-codigo-usuario
                    AND     bfaf-faixa-demerito.nr-controle = af-faixa-demerito.nr-controle
                    AND     bfaf-faixa-demerito.nr-versao   = af-faixa-demerito.nr-versao 
                    AND     bfaf-faixa-demerito.ind-tipo-valor = af-faixa-demerito.ind-tipo-valor
                    AND     bfaf-faixa-demerito.seq-faixa   = af-faixa-demerito.seq-faixa NO-ERROR.
                IF AVAIL bfaf-faixa-demerito THEN
                    DELETE bfaf-faixa-demerito.
            END.
    END.
END.

IF tt-param.l-faixa-calculo THEN DO:

    DEFINE BUFFER bfaf-formula-excluir FOR af-formula.

    IF tt-param.l-simula-eliminacao THEN
        {utp/ut-liter.i Simulando_Elimina‡Æo_das_F¢rmulas_de_C lculo_... * L}
    ELSE
        {utp/ut-liter.i Elimina‡Æo_das_F¢rmulas_de_C lculo_... * L}

    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-formula NO-LOCK
        WHERE   af-formula.ep-codigo    = i-ep-codigo-usuario
        AND     (af-formula.cod-formula >= tt-param.i-cod-formula-ini
        AND     af-formula.cod-formula  <= tt-param.i-cod-formula-fim)
        AND     (af-formula.descricao   >= tt-param.c-desc-form-ini
        AND     af-formula.descricao    <= tt-param.c-desc-form-fim)
        AND     (af-formula.nr-versao   >= tt-param.i-nr-versao-ini
        AND     af-formula.nr-versao    <= tt-param.i-nr-versao-fim),
            FIRST af-versao-avaliacao NO-LOCK
                WHERE   af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario
                AND     af-versao-avaliacao.nr-versao = af-formula.nr-versao
                AND    (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
                AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
        BREAK BY af-formula.cod-formula:
        

        IF FIRST-OF(af-formula.cod-formula) THEN DO:
              RUN pi-valida-exclusao-formula (INPUT af-formula.cod-formula, INPUT af-formula.padrao).
        END.

        FIND FIRST tt-af-formula NO-LOCK
                     WHERE tt-af-formula.ep-codigo = af-formula.ep-codigo
                     AND tt-af-formula.cod-formula = af-formula.cod-formula
                     AND tt-af-formula.nr-versao   = af-formula.nr-versao
                     AND tt-af-formula.l-pode-excluir = TRUE NO-ERROR.

        IF AVAIL tt-af-formula THEN DO:
            IF NOT l-mostra-titulo THEN DO:
                {utp/ut-liter.i F¢rmulas_de_C lculo * L}
                ASSIGN c-titulo = RETURN-VALUE.
                DISPLAY c-titulo
                        c-lbl-formula
                        c-lbl-form-desc
                        c-lbl-versao
                        c-lbl-descr
                    WITH DOWN FRAME f-faixa-calculo-cab.
                    DOWN WITH FRAME f-faixa-calculo-cab.

                ASSIGN l-mostra-titulo = TRUE.
            END.

            DISPLAY tt-af-formula.cod-formula
                    tt-af-formula.descricao
                    tt-af-formula.nr-versao
                    tt-af-formula.desc-versao
            WITH DOWN FRAME f-faixa-calculo.
            DOWN WITH FRAME f-faixa-calculo.

            IF NOT tt-param.l-simula-eliminacao THEN DO:
                FIND FIRST  bfaf-formula-excluir EXCLUSIVE-LOCK
                    WHERE   bfaf-formula-excluir.ep-codigo  = i-ep-codigo-usuario
                    AND     bfaf-formula-excluir.cod-formula= af-formula.cod-formula
                    AND     bfaf-formula-excluir.nr-versao  = af-formula.nr-versao NO-ERROR.
                IF AVAIL bfaf-formula-excluir THEN 
                    DELETE bfaf-formula-excluir.
            END.
        END.        
    END.
END.

PROCEDURE pi-valida-exclusao-formula:
    DEFINE INPUT PARAMETER pcod-formula LIKE af-formula.cod-formula NO-UNDO.
    DEFINE INPUT PARAMETER ppadrao      LIKE af-formula.padrao      NO-UNDO.

    FOR EACH bfaf-formula NO-LOCK
        WHERE bfaf-formula.ep-codigo = i-ep-codigo-usuario
        AND bfaf-formula.cod-formula = pcod-formula,
            FIRST af-versao-avaliacao NO-LOCK
                WHERE   af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario
                AND     af-versao-avaliacao.nr-versao = bfaf-formula.nr-versao:

        CREATE tt-af-formula.
        ASSIGN  tt-af-formula.ep-codigo     = i-ep-codigo-usuario
                tt-af-formula.cod-formula   = bfaf-formula.cod-formula
                tt-af-formula.descricao     = bfaf-formula.descricao
                tt-af-formula.nr-versao     = bfaf-formula.nr-versao
                tt-af-formula.ano-avaliacao = af-versao-avaliacao.ano-avaliacao
                tt-af-formula.nr-periodo    = af-versao-avaliacao.nr-periodo
                tt-af-formula.desc-versao   = af-versao-avaliacao.desc-versao
                tt-af-formula.l-pode-excluir = FALSE.
                
    END.

    FIND FIRST af-controle NO-LOCK
        WHERE af-controle.ep-codigo = i-ep-codigo-usuario
        AND   af-controle.cod-formula = pcod-formula NO-ERROR.

    IF NOT AVAIL af-controle AND ppadrao = FALSE THEN DO:        
        FOR EACH tt-af-formula NO-LOCK
            WHERE tt-af-formula.cod-formula = pcod-formula:
            ASSIGN tt-af-formula.l-pode-excluir = TRUE.
        END.
    END.
    ELSE DO:
        DEFINE VARIABLE l-primeiro AS LOGICAL  INITIAL TRUE NO-UNDO.
        FOR EACH tt-af-formula NO-LOCK
            WHERE tt-af-formula.cod-formula = pcod-formula
            BY tt-af-formula.ano-avaliacao
            BY tt-af-formula.nr-periodo:

            IF l-primeiro = TRUE THEN DO:
                ASSIGN tt-af-formula.l-pode-excluir = FALSE
                       l-primeiro = FALSE.                    
               NEXT.
            END.            
            ASSIGN tt-af-formula.l-pode-excluir = TRUE.
      END.
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
            c-familia
            tt-param.c-familia-ini
            tt-param.c-familia-fim
            c-item
            tt-param.c-item-ini
            tt-param.c-item-fim
            c-estabel
            tt-param.c-estabelecimento-ini
            tt-param.c-estabelecimento-fim
            c-fornecedor
            tt-param.i-fornecedor-ini
            tt-param.i-fornecedor-fim
            c-grp-aval
            tt-param.c-grp-avaliacao-ini
            tt-param.c-grp-avaliacao-fim
            c-controle
            tt-param.i-nr-controle-ini
            tt-param.i-nr-controle-fim
            c-formula
            tt-param.i-cod-formula-ini
            tt-param.i-cod-formula-fim
            c-descr-form
            tt-param.c-desc-form-ini
            tt-param.c-desc-form-fim
            c-parametros
            c-fam-aval-for
            tt-param.l-familia-fornecedor
            c-item-ava-for
            tt-param.l-item-fornecedor
            c-item-est-for
            tt-param.l-item-estabelecimento 
            c-grupo-aval
            tt-param.l-grupo
            c-fx-demerito
            tt-param.l-faixa-demerito 
            c-form-calc
            tt-param.l-faixa-calculo
            c-sim-elimin
            tt-param.l-simula-eliminacao
            WITH  FRAME f-param-sel.

/***********************************Finalizando******************************************/

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN DO:
    DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
END.

{include/i-rpclo.i}

RETURN "OK":U.

