/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0514RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0514.i}
{afbo/boaf016.i1}

/* Definiá∆o da temp-table tt-param e tt-digita */
/*******Definiá∆o de ParÉmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.

DEFINE TEMP-TABLE tt-af-versao-avaliacao NO-UNDO LIKE af-versao-avaliacao
    FIELD dt-periodo-ini LIKE af-periodo-aval.dt-periodo-ini[1]
    FIELD dt-periodo-fim LIKE af-periodo-aval.dt-periodo-ini[1]
    FIELD c-data-ini    AS CHARACTER
    FIELD c-data-fim    AS CHARACTER.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
{utp/ut-liter.i Listagem_de_inconsistàncias_de_vers‰es * C}
ASSIGN c-programa 	  = "AF0514RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = RETURN-VALUE.

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

DEFINE VARIABLE h-boaf016 AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-tipo-faixa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-Titulo AS LOGICAL     NO-UNDO.

DEFINE VARIABLE c-selecao       AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-item          AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-descricao     AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-familia       AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-formula       AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-descr-form    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-esteblec      AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-emitente      AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-nom-abrev     AS CHARACTER FORMAT "x(16)"  NO-UNDO.
DEFINE VARIABLE c-grp-aval      AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-des-grp-aval  AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-nr-control    AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-des-control   AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-considera     AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-fam-forn      AS CHARACTER FORMAT "x(32)"  NO-UNDO.
DEFINE VARIABLE c-item-aval-for AS CHARACTER FORMAT "x(29)"  NO-UNDO.
DEFINE VARIABLE c-it-est-av-for AS CHARACTER FORMAT "x(47)"  NO-UNDO.
DEFINE VARIABLE c-grup-aval     AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE c-faixa-dem     AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-form-calc     AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE c-lbl-familia   AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-lbl-fornec    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-lbl-versao    AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-lbl-descr     AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-lbl-dt-ini    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-lbl-dt-fim    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-lbl-item      AS CHARACTER FORMAT "x(4)"   NO-UNDO.
DEFINE VARIABLE c-lbl-estab     AS CHARACTER FORMAT "x(5)"   NO-UNDO.
DEFINE VARIABLE c-lbl-grp       AS CHARACTER FORMAT "x(5)"   NO-UNDO.
DEFINE VARIABLE c-lbl-des-grp   AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-lbl-nr-ctr    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-lbl-des-ctr   AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-lbl-seq       AS CHARACTER FORMAT "x(3)"   NO-UNDO.
DEFINE VARIABLE c-lbl-tipo      AS CHARACTER FORMAT "x(4)"   NO-UNDO.
DEFINE VARIABLE c-lbl-formula   AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-lbl-des-for   AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-titulo        AS CHARACTER FORMAT "x(75)"  NO-UNDO.

{utp/ut-liter.i SELEÄ«O * L}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_: * R}
ASSIGN c-item = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descriá∆o_: * R}
ASSIGN c-descricao    = TRIM(RETURN-VALUE)
       c-descr-form   = TRIM(RETURN-VALUE)
       c-des-grp-aval = TRIM(RETURN-VALUE)
       c-des-control  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam°lia_: * R}
ASSIGN c-familia = TRIM(RETURN-VALUE).
{utp/ut-liter.i F¢rmula_: * R}
ASSIGN c-formula = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento_: * R}
ASSIGN c-esteblec = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor_: * R}
ASSIGN c-emitente = RETURN-VALUE.
{utp/ut-liter.i Nome_Abreviado_: * R}
ASSIGN c-nom-abrev = RETURN-VALUE.
{utp/ut-liter.i Grupo_Avaliaá∆o_: * R}
ASSIGN c-grp-aval = RETURN-VALUE.
{utp/ut-liter.i N£mero_Controle_: * R}
ASSIGN c-nr-control = RETURN-VALUE.
{utp/ut-liter.i CONSIDERA * L}
ASSIGN c-considera = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam°lia_Avaliaá∆o_Fornecedores_: * R}
ASSIGN c-fam-forn = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_Avaliaá∆o_Fornecedores_: * R}
ASSIGN c-item-aval-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_x_Estabelecimento_Avaliaá∆o_Fornecedores_: * R}
ASSIGN c-it-est-av-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Grupo_de_Avaliaá∆o_: * R}
ASSIGN c-grup-aval = TRIM(RETURN-VALUE).
{utp/ut-liter.i Faixa_de_DemÇrito_: * R}
ASSIGN c-faixa-dem = TRIM(RETURN-VALUE).
{utp/ut-liter.i F¢rmula_de_C†lculo_: * R}
ASSIGN c-form-calc = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fam°lia * L}
ASSIGN c-lbl-familia = RETURN-VALUE.
{utp/ut-liter.i Fornecedor * L}
ASSIGN c-lbl-fornec = RETURN-VALUE.
{utp/ut-liter.i Vers∆o * L}
ASSIGN c-lbl-versao = RETURN-VALUE.
{utp/ut-liter.i Descriá∆o * L}
ASSIGN c-lbl-descr   = RETURN-VALUE
       c-lbl-des-ctr = RETURN-VALUE
       c-lbl-des-grp = RETURN-VALUE
       c-lbl-des-for = RETURN-VALUE.
{utp/ut-liter.i Per°odo_Ini * L}
ASSIGN c-lbl-dt-ini = RETURN-VALUE.
{utp/ut-liter.i Per°odo_Fim * L}
ASSIGN c-lbl-dt-fim = RETURN-VALUE.
{utp/ut-liter.i Item * L}
ASSIGN c-lbl-item = RETURN-VALUE.
{utp/ut-liter.i Estab * L}
ASSIGN c-lbl-estab = RETURN-VALUE.
{utp/ut-liter.i Grupo * L}
ASSIGN c-lbl-grp = RETURN-VALUE.
{utp/ut-liter.i Nr_Controle * L}
ASSIGN c-lbl-nr-ctr = RETURN-VALUE.
{utp/ut-liter.i Seq * L}
ASSIGN c-lbl-seq = RETURN-VALUE.
{utp/ut-liter.i Tipo * L}
ASSIGN c-lbl-tipo = RETURN-VALUE.
{utp/ut-liter.i F¢rmula * L}
ASSIGN c-lbl-formula = RETURN-VALUE.


/***********************************Seleá∆o**********************************************/
/*Existe mais de uma vari†vel para o label de descriá∆o, n∆o remover porque sen∆o 
    n∆o aparece o valor. O mesmo Ç v†lido para outros label*/
FORM SKIP (2)
    c-selecao        AT  3 NO-LABEL SKIP(1)
    c-item           TO 17 NO-LABEL tt-param.c-item-ini              COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-item-fim                       NO-LABEL SKIP
    c-descricao      TO 17 NO-LABEL tt-param.c-descricao-ini         COLON 17 NO-LABEL FORMAT "x(50)" "|<  >|" AT 71 tt-param.c-descricao-fim  FORMAT "x(50)"  NO-LABEL SKIP
    c-familia        TO 17 NO-LABEL tt-param.c-familia-ini           COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-familia-fim                    NO-LABEL SKIP
    c-esteblec       TO 17 NO-LABEL tt-param.c-estabelecimento-ini   COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-estabelecimento-fim            NO-LABEL SKIP
    c-emitente       TO 17 NO-LABEL tt-param.i-fornecedor-ini        COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.i-fornecedor-fim                 NO-LABEL SKIP
    c-nom-abrev      TO 17 NO-LABEL tt-param.c-nom-abrev-ini         COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-nom-abrev-fim                  NO-LABEL SKIP
    c-grp-aval       TO 17 NO-LABEL tt-param.c-grp-avaliacao-ini     COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-grp-avaliacao-fim              NO-LABEL SKIP
    c-des-grp-aval   TO 17 NO-LABEL tt-param.c-des-grp-aval-ini      COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-des-grp-aval-fim               NO-LABEL SKIP
    c-nr-control     TO 17 NO-LABEL tt-param.i-nr-controle-ini       COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.i-nr-controle-fim                NO-LABEL SKIP
    c-des-control    TO 17 NO-LABEL tt-param.c-nr-contr-desc-ini     COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-nr-contr-desc-fim              NO-LABEL SKIP
    c-formula        TO 17 NO-LABEL tt-param.i-cod-formula-ini       COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.i-cod-formula-fim                NO-LABEL SKIP
    c-descr-form     TO 17 NO-LABEL tt-param.c-desc-form-ini         COLON 17 NO-LABEL                "|<  >|" AT 71 tt-param.c-desc-form-fim                  NO-LABEL SKIP
    SKIP(2)
    c-considera      AT  3 NO-LABEL SKIP(1)
    c-fam-forn       TO 49 NO-LABEL tt-param.l-familia-fornecedor   COLON  49 NO-LABEL FORMAT "Sim/N∆o"
    c-item-aval-for  TO 49 NO-LABEL tt-param.l-item-fornecedor      COLON  49 NO-LABEL FORMAT "Sim/N∆o"
    c-it-est-av-for  TO 49 NO-LABEL tt-param.l-item-estabelecimento COLON  49 NO-LABEL FORMAT "Sim/N∆o"
    c-grup-aval      TO 49 NO-LABEL tt-param.l-grupo                COLON  49 NO-LABEL FORMAT "Sim/N∆o"    
    c-faixa-dem      TO 49 NO-LABEL tt-param.l-faixa-demerito       COLON  49 NO-LABEL FORMAT "Sim/N∆o"
    c-form-calc      TO 49 NO-LABEL tt-param.l-faixa-calculo        COLON  49 NO-LABEL FORMAT "Sim/N∆o"
        
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/

/********************************Frames**************************************************/
/*FORM Fam°lia X Fornecedor*/
FORM 
    SKIP
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-familia   NO-LABEL FORMAT 'x(7)'  AT 3
    c-lbl-fornec    NO-LABEL FORMAT 'x(10)' AT 13
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'  AT 24
    c-lbl-descr     NO-LABEL FORMAT 'x(9)'  AT 31
    c-lbl-dt-ini    NO-LABEL FORMAT 'x(11)' AT 72
    c-lbl-dt-fim    NO-LABEL FORMAT 'x(11)' AT 84 SKIP
    "--------"                                  AT 3
    "----------"                                AT 13
    "------"                                    AT 24
    "----------------------------------------"  AT 31
    "-----------"                               AT 72
    "-----------"                               AT 84 

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-familia-fornecedor-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familia-fornecedor-cab:HANDLE).


FORM     
    af-familia-contr.fm-codigo          NO-LABEL FORMAT 'x(8)'       AT 3
    af-familia-contr.cod-emitente       NO-LABEL FORMAT '>>>>>>>9'   AT 15
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'      AT 25
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'      AT 31
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'       AT 72 
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'       AT 84 

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-familia-fornecedor.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familia-fornecedor:HANDLE).


/*FORM Item X Fornecedor*/
FORM 
    SKIP(1)
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-item      NO-LABEL FORMAT 'x(7)'     AT 3
    c-lbl-fornec    NO-LABEL FORMAT 'x(10)'    AT 20
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'     AT 31
    c-lbl-descr     NO-LABEL FORMAT 'x(9)'     AT 38
    c-lbl-dt-ini    NO-LABEL FORMAT 'x(11)'    AT 79
    c-lbl-dt-fim    NO-LABEL FORMAT 'x(11)'    AT 91 SKIP
    "----------------"                         AT 3
    "----------"                               AT 20
    "------"                                   AT 31
    "----------------------------------------" AT 38
    "-----------"                              AT 79
    "-----------"                              AT 91

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-fornecedor-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-fornecedor-cab:HANDLE).


FORM 
    af-item-contr.it-codigo             NO-LABEL FORMAT 'x(16)'          AT 3
    af-item-contr.cod-emitente          NO-LABEL FORMAT '>>>>>>>9'       AT 22
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'          AT 32
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'          AT 38
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'           AT 79
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'           AT 91

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-fornecedor.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-fornecedor:HANDLE).


/*FORM Item X Estabelecimento X Fornecedor*/
FORM 
    SKIP(1)
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-item      NO-LABEL FORMAT 'x(7)'     AT 3 
    c-lbl-estab     NO-LABEL FORMAT 'x(5)'     AT 20
    c-lbl-fornec    NO-LABEL FORMAT 'x(10)'    AT 26
    c-lbl-versao    NO-LABEL FORMAT 'x(6)'     AT 37
    c-lbl-descr     NO-LABEL FORMAT 'x(9)'     AT 44
    c-lbl-dt-ini    NO-LABEL FORMAT 'x(11)'    AT 85
    c-lbl-dt-fim    NO-LABEL FORMAT 'x(11)'    AT 97 SKIP
    "----------------"                         AT 3 
    "-----"                                    AT 20
    "----------"                               AT 26
    "------"                                   AT 37
    "----------------------------------------" AT 44
    "-----------"                              AT 85
    "-----------"                              AT 97

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-estab-fornecedor-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-estab-fornecedor-cab:HANDLE).


FORM 
    af-item-contr-estab.it-codigo       NO-LABEL FORMAT 'x(16)'      AT 3
    af-item-contr-estab.cod-estabel     NO-LABEL FORMAT 'x(5)'       AT 20
    af-item-contr-estab.cod-emitente    NO-LABEL FORMAT '>>>>>>>9'   AT 26
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'      AT 37
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'      AT 44
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'       AT 85
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'       AT 97

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-estab-fornecedor.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-estab-fornecedor:HANDLE).


/*FORM Grupo*/
FORM
    SKIP(1)
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-grp       NO-LABEL FORMAT "x(5)"  AT 3  
    c-lbl-des-grp   NO-LABEL FORMAT "x(9)"  AT 12 
    c-lbl-versao    NO-LABEL FORMAT "x(6)"  AT 53 
    c-lbl-descr     NO-LABEL FORMAT "x(9)"  AT 60 
    c-lbl-dt-ini    NO-LABEL FORMAT "x(11)" AT 101
    c-lbl-dt-fim    NO-LABEL FORMAT "x(11)" AT 114 SKIP
    "--------"                                 AT 3  
    "----------------------------------------" AT 12 
    "------"                                   AT 53 
    "----------------------------------------" AT 60 
    "-----------"                              AT 101
    "-----------"                              AT 114

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-grupo-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo-cab:HANDLE).


FORM 
    af-grp-avaliacao.cod-grp-avaliacao  NO-LABEL FORMAT 'x(8)'       AT 3
    af-grp-avaliacao.des-grp-avaliacao  NO-LABEL FORMAT 'x(40)'      AT 12
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'      AT 54
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'      AT 60
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'       AT 101
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'       AT 114

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-grupo.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo:HANDLE).


/*FORM Faixa DemÇrito*/
FORM 
    SKIP(1)
    c-titulo        NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-nr-ctr    NO-LABEL FORMAT "x(11)" AT 3 
    c-lbl-des-ctr   NO-LABEL FORMAT "x(9)"  AT 15
    c-lbl-versao    NO-LABEL FORMAT "x(6)"  AT 46
    c-lbl-descr     NO-LABEL FORMAT "x(9)"  AT 53
    c-lbl-seq       NO-LABEL FORMAT "x(3)"  AT 94
    c-lbl-tipo      NO-LABEL FORMAT "x(4)"  AT 99
    c-lbl-dt-ini    NO-LABEL FORMAT "x(11)" AT 110
    c-lbl-dt-fim    NO-LABEL FORMAT "x(11)" AT 122 SKIP
    "-----------"                              AT 3  
    "------------------------------"           AT 15 
    "------"                                   AT 46 
    "----------------------------------------" AT 53 
    "----"                                     AT 94 
    "----------"                               AT 99 
    "-----------"                              AT 110
    "-----------"                              AT 122
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-faixa-demerito-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-demerito-cab:HANDLE).


FORM 
    af-faixa-demerito.nr-controle       NO-LABEL FORMAT '>>>>>9' AT 8
    af-controle.descricao               NO-LABEL FORMAT 'x(30)'  AT 15
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'  AT 47
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'  AT 53
    af-faixa-demerito.seq-faixa         NO-LABEL FORMAT '>>>9'   AT 94
    c-tipo-faixa                        NO-LABEL FORMAT 'x(10)'  AT 99
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'   AT 110
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'   AT 122
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-faixa-demerito.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-faixa-demerito:HANDLE).


/*FORM C†lculo*/
FORM
    SKIP(1)
    c-titulo      NO-LABEL FORMAT 'x(75)' AT 3 SKIP(1)
    c-lbl-formula NO-LABEL FORMAT "x(7)"  AT 3  
    c-lbl-des-for NO-LABEL FORMAT "x(9)"  AT 11 
    c-lbl-versao  NO-LABEL FORMAT "x(6)"  AT 42 
    c-lbl-descr   NO-LABEL FORMAT "x(9)"  AT 49 
    c-lbl-dt-ini  NO-LABEL FORMAT "x(11)" AT 90 
    c-lbl-dt-fim  NO-LABEL FORMAT "x(11)" AT 102 SKIP
    "-------"                                  AT 3  
    "------------------------------"           AT 11 
    "------"                                   AT 42 
    "----------------------------------------" AT 49 
    "-----------"                              AT 90 
    "-----------"                              AT 102

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-calculo-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-calculo-cab:HANDLE).


FORM
    af-formula.cod-formula              NO-LABEL FORMAT '>>>>>9'     AT 4
    af-formula.descricao                NO-LABEL FORMAT 'x(30)'      AT 11
    tt-af-versao-avaliacao.nr-versao    NO-LABEL FORMAT '>>>>9'      AT 43
    tt-af-versao-avaliacao.desc-versao  NO-LABEL FORMAT 'x(40)'      AT 49
    tt-af-versao-avaliacao.c-data-ini   NO-LABEL FORMAT 'x(7)'       AT 90
    tt-af-versao-avaliacao.c-data-fim   NO-LABEL FORMAT 'x(7)'       AT 102

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-calculo.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-calculo:HANDLE).


/****************************************************************************************/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Carregando_vers‰es_e_per°odos_... * L}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/************************************Execuá∆o********************************************/
IF NOT VALID-HANDLE (h-boaf016) THEN DO:
    RUN afbo/boaf016.p PERSISTEN SET h-boaf016.
END.

RUN openQueryStatic IN h-boaf016 (INPUT "Main":U) NO-ERROR.

DEFINE VARIABLE i-ano-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-contador AS INTEGER     NO-UNDO.

RUN pi-primeiro-ultimo-ano IN h-boaf016 (OUTPUT i-ano-ini, OUTPUT i-ano-fim).

EMPTY TEMP-TABLE tt-dt-periodo-aval.
RUN retornaTodosPeriodosFaixa IN h-boaf016 (INPUT i-ano-ini, INPUT i-ano-fim, OUTPUT TABLE tt-dt-periodo-aval).

FOR EACH af-versao-avaliacao  NO-LOCK
    WHERE af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:
    
    CREATE tt-af-versao-avaliacao.
    BUFFER-COPY af-versao-avaliacao TO tt-af-versao-avaliacao.

    ASSIGN i-contador = 1.

    FOR EACH tt-dt-periodo-aval NO-LOCK
        WHERE tt-dt-periodo-aval.ano-avaliacao = af-versao-avaliacao.ano-avaliacao
            BY tt-dt-periodo-aval.dt-periodo-ini: 
   
        IF i-contador = af-versao-avaliacao.nr-periodo THEN DO:     
            ASSIGN  tt-af-versao-avaliacao.dt-periodo-ini = tt-dt-periodo-aval.dt-periodo-ini
                    tt-af-versao-avaliacao.dt-periodo-fim = tt-dt-periodo-aval.dt-periodo-fim
                    tt-af-versao-avaliacao.c-data-ini = STRING(MONTH(tt-dt-periodo-aval.dt-periodo-ini),"99") + "/" + STRING(YEAR(tt-dt-periodo-aval.dt-periodo-ini),"9999")
                    tt-af-versao-avaliacao.c-data-fim = STRING(MONTH(tt-dt-periodo-aval.dt-periodo-fim),"99") + "/" + STRING(YEAR(tt-dt-periodo-aval.dt-periodo-fim),"9999").
            LEAVE.
        END.
        ELSE
            ASSIGN i-contador = i-contador + 1.
    END.
END.

IF tt-param.l-familia-fornecedor  THEN DO:
    {utp/ut-liter.i Gerando_Fam°lia_Avaliaá∆o_X_Fornecedor_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-familia-contr FOR af-familia-contr.
    
    ASSIGN l-Titulo = FALSE.
    FOR EACH af-familia-contr FIELDS(ep-codigo fm-codigo cod-emitente nr-versao) NO-LOCK
        WHERE   af-familia-contr.ep-codigo = i-ep-codigo-usuario
        AND     af-familia-contr.fm-codigo >= tt-param.c-familia-ini
        AND     af-familia-contr.fm-codigo <= tt-param.c-familia-fim
        AND     af-familia-contr.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-familia-contr.cod-emitente <= tt-param.i-fornecedor-fim,
            FIRST emitente FIELD(cod-emitente nome-abrev)NO-LOCK
                WHERE   emitente.cod-emitente = af-familia-contr.cod-emitente
                AND     emitente.nome-abrev >= tt-param.c-nom-abrev-ini
                AND     emitente.nome-abrev <= tt-param.c-nom-abrev-fim
        BREAK BY af-familia-contr.fm-codigo
              BY af-familia-contr.cod-emitente:

         IF FIRST-OF(af-familia-contr.fm-codigo)
            OR FIRST-OF (af-familia-contr.cod-emitente) THEN DO:
                FOR EACH tt-af-versao-avaliacao NO-LOCK
                    WHERE tt-af-versao-avaliacao.nr-versao <> af-familia-contr.nr-versao:
    
                    IF CAN-FIND(bfaf-familia-contr NO-LOCK
                                WHERE bfaf-familia-contr.ep-codigo    = i-ep-codigo-usuario
                                AND   bfaf-familia-contr.fm-codigo    = af-familia-contr.fm-codigo
                                AND   bfaf-familia-contr.cod-emitente = af-familia-contr.cod-emitente
                                AND   bfaf-familia-contr.nr-versao    = tt-af-versao-avaliacao.nr-versao) THEN
                        NEXT.
    
                    IF NOT l-Titulo THEN DO:                    
                        {utp/ut-liter.i Fam°lia_Avaliaá∆o_Fornecedor * L}
                        ASSIGN c-titulo = RETURN-VALUE.
                        
                        DISPLAY c-titulo
                                c-lbl-familia
                                c-lbl-fornec
                                c-lbl-versao
                                c-lbl-descr
                                c-lbl-dt-ini
                                c-lbl-dt-fim
                        WITH DOWN FRAME f-familia-fornecedor-cab.
                        DOWN WITH FRAME f-familia-fornecedor-cab.
    
                        ASSIGN l-Titulo = TRUE.
    
                    END.
                    DISPLAY af-familia-contr.fm-codigo
                            af-familia-contr.cod-emitente
                            tt-af-versao-avaliacao.nr-versao
                            tt-af-versao-avaliacao.desc-versao
                            tt-af-versao-avaliacao.c-data-ini
                            tt-af-versao-avaliacao.c-data-fim
                        WITH DOWN FRAME f-familia-fornecedor.
                        DOWN WITH FRAME f-familia-fornecedor.       
                END.
         END.
    END.
END.

IF tt-param.l-item-fornecedor THEN DO:
    {utp/ut-liter.i Gerando_Item_Avaliaá∆o_X_Fornecedor_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-item-contr FOR af-item-contr.

    ASSIGN l-titulo = FALSE.

    FOR EACH af-item-contr FIELDS(ep-codigo it-codigo cod-emitente nr-versao)NO-LOCK
        WHERE af-item-contr.ep-codigo = i-ep-codigo-usuario
        AND   af-item-contr.it-codigo   >= tt-param.c-item-ini
        AND   af-item-contr.it-codigo   <= tt-param.c-item-fim
        AND   af-item-contr.cod-emitente >= tt-param.i-fornecedor-ini
        AND   af-item-contr.cod-emitente <= tt-param.i-fornecedor-fim,
            FIRST item FIELD(it-codigo desc-item fm-codigo) NO-LOCK
                WHERE   item.it-codigo = af-item-contr.it-codigo
                AND     item.desc-item >= tt-param.c-descricao-ini
                AND     item.desc-item <= tt-param.c-descricao-fim
                AND     item.fm-codigo >= tt-param.c-familia-ini
                AND     item.fm-codigo <= tt-param.c-familia-fim,
            FIRST emitente FIELD(cod-emitente nome-abrev)NO-LOCK
                WHERE   emitente.cod-emitente = af-item-contr.cod-emitente
                AND     emitente.nome-abrev >= tt-param.c-nom-abrev-ini
                AND     emitente.nome-abrev <= tt-param.c-nom-abrev-fim
        BREAK BY af-item-contr.it-codigo
              BY af-item-contr.cod-emitente:

        IF FIRST-OF (af-item-contr.it-codigo)
            OR FIRST-OF(af-item-contr.cod-emitente) THEN DO:
                FOR EACH tt-af-versao-avaliacao NO-LOCK
                    WHERE tt-af-versao-avaliacao.nr-versao <> af-item-contr.nr-versao:
    
                    IF CAN-FIND(bfaf-item-contr NO-LOCK
                                WHERE bfaf-item-contr.ep-codigo = i-ep-codigo-usuario
                                AND   bfaf-item-contr.it-codigo = af-item-contr.it-codigo
                                AND   bfaf-item-contr.cod-emitente = af-item-contr.cod-emitente
                                AND   bfaf-item-contr.nr-versao = tt-af-versao-avaliacao.nr-versao) THEN
                        NEXT.
    
                    IF NOT l-Titulo THEN DO:
                        {utp/ut-liter.i Item_Avaliaá∆o_Fornecedor * L}
                        ASSIGN c-titulo = RETURN-VALUE.
                        
                        DISPLAY c-titulo
                                c-lbl-item
                                c-lbl-fornec
                                c-lbl-versao
                                c-lbl-descr
                                c-lbl-dt-ini
                                c-lbl-dt-fim
                            WITH DOWN FRAME f-item-fornecedor-cab.
                            DOWN WITH FRAME f-item-fornecedor-cab.
                        ASSIGN l-Titulo = TRUE.
                    END.
    
                    DISPLAY af-item-contr.it-codigo
                            af-item-contr.cod-emitente
                            tt-af-versao-avaliacao.nr-versao
                            tt-af-versao-avaliacao.desc-versao
                            tt-af-versao-avaliacao.c-data-ini
                            tt-af-versao-avaliacao.c-data-fim
                        WITH DOWN FRAME f-item-fornecedor.
                        DOWN WITH FRAME f-item-fornecedor.                
                END.
        END.
    END.
END.

IF tt-param.l-item-estabelecimento THEN DO:
    {utp/ut-liter.i Gerando_Item_Estabelecimento_Avaliaá∆o_X_Fornecedor_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-item-contr-estab FOR af-item-contr-estab.

    ASSIGN l-Titulo = FALSE.

    FOR EACH af-item-contr-estab FIELDS(ep-codigo it-codigo cod-emitente cod-estabel nr-versao) NO-LOCK
        WHERE   af-item-contr-estab.ep-codigo = i-ep-codigo-usuario
        AND     af-item-contr-estab.it-codigo >= tt-param.c-item-ini 
        AND     af-item-contr-estab.it-codigo <= tt-param.c-item-fim 
        AND     af-item-contr-estab.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-item-contr-estab.cod-emitente <= tt-param.i-fornecedor-fim
        AND     af-item-contr-estab.cod-estabel >= tt-param.c-estabelecimento-ini
        AND     af-item-contr-estab.cod-estabel <= tt-param.c-estabelecimento-fim,
            FIRST item FIELDS(it-codigo desc-item fm-codigo)NO-LOCK
                WHERE   item.it-codigo = af-item-contr-estab.it-codigo
                AND     item.desc-item >= tt-param.c-descricao-ini
                AND     item.desc-item <= tt-param.c-descricao-fim
                AND     item.fm-codigo >= tt-param.c-familia-ini
                AND     item.fm-codigo <= tt-param.c-familia-fim,
            FIRST emitente FIELDS(cod-emitente nome-abrev)NO-LOCK
                WHERE   emitente.cod-emitente = af-item-contr-estab.cod-emitente
                AND     emitente.nome-abrev >= tt-param.c-nom-abrev-ini
                AND     emitente.nome-abrev <= tt-param.c-nom-abrev-fim
        BREAK BY af-item-contr-estab.it-codigo
              BY af-item-contr-estab.cod-estabel
              BY af-item-contr-estab.cod-emitente:

        IF FIRST-OF(af-item-contr-estab.it-codigo)
             OR  FIRST-OF(af-item-contr-estab.cod-estabel)
             OR  FIRST-OF(af-item-contr-estab.cod-emitente) THEN DO:

                FOR EACH tt-af-versao-avaliacao NO-LOCK
                    WHERE tt-af-versao-avaliacao.nr-versao <> af-item-contr-estab.nr-versao:
    
                    IF CAN-FIND(bfaf-item-contr-estab
                                WHERE   bfaf-item-contr-estab.ep-codigo     = i-ep-codigo-usuario
                                AND     bfaf-item-contr-estab.it-codigo     = af-item-contr-estab.it-codigo
                                AND     bfaf-item-contr-estab.cod-estabel   = af-item-contr-estab.cod-estabel
                                AND     bfaf-item-contr-estab.cod-emitente  = af-item-contr-estab.cod-emitente
                                AND     bfaf-item-contr-estab.nr-versao     = tt-af-versao-avaliacao.nr-versao)  THEN
                        NEXT.
    
                    IF NOT l-Titulo THEN DO:
                        {utp/ut-liter.i Item_X_Estabelecimento_Avaliaá∆o_Fornecedor * L}
                        ASSIGN c-titulo = RETURN-VALUE.
                        
                        DISPLAY c-titulo
                                c-lbl-item  
                                c-lbl-estab 
                                c-lbl-fornec
                                c-lbl-versao
                                c-lbl-descr 
                                c-lbl-dt-ini
                                c-lbl-dt-fim
                            WITH DOWN FRAME f-item-estab-fornecedor-cab.
                            DOWN WITH FRAME f-item-estab-fornecedor-cab.
                        ASSIGN l-Titulo = TRUE.
                    END.
    
                    DISPLAY af-item-contr-estab.it-codigo       
                            af-item-contr-estab.cod-estabel     
                            af-item-contr-estab.cod-emitente    
                            tt-af-versao-avaliacao.nr-versao       
                            tt-af-versao-avaliacao.desc-versao  
                            tt-af-versao-avaliacao.c-data-ini   
                            tt-af-versao-avaliacao.c-data-fim
                        WITH DOWN FRAME f-item-estab-fornecedor.
                        DOWN WITH FRAME f-item-estab-fornecedor.
                END.
        END.
    END.
END.

IF tt-param.l-grupo THEN DO:
    {utp/ut-liter.i Gerando_Grupo_de_Avaliaá∆o_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-grp-avaliacao FOR af-grp-avaliacao.

    ASSIGN l-Titulo = FALSE.

    FOR EACH af-grp-avaliacao FIELDS (cod-grp-avaliacao des-grp-avaliacao nr-versao) NO-LOCK
        WHERE   af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario
        AND     af-grp-avaliacao.cod-grp-avaliacao >= tt-param.c-grp-avaliacao-ini
        AND     af-grp-avaliacao.cod-grp-avaliacao <= tt-param.c-grp-avaliacao-fim
        AND     af-grp-avaliacao.des-grp-avaliacao >= tt-param.c-des-grp-aval-ini
        AND     af-grp-avaliacao.des-grp-avaliacao <= tt-param.c-des-grp-aval-fim
        BREAK BY af-grp-avaliacao.cod-grp-avaliacao:

        IF FIRST-OF(af-grp-avaliacao.cod-grp-avaliacao) THEN DO:

            FOR EACH tt-af-versao-avaliacao NO-LOCK
                 WHERE tt-af-versao-avaliacao.nr-versao <> af-grp-avaliacao.nr-versao:

                IF CAN-FIND(bfaf-grp-avaliacao
                            WHERE   bfaf-grp-avaliacao.ep-codigo = i-ep-codigo-usuario
                            AND     bfaf-grp-avaliacao.cod-grp-avaliacao = af-grp-avaliacao.cod-grp-avaliacao
                            AND     bfaf-grp-avaliacao.nr-versao = tt-af-versao-avaliacao.nr-versao) THEN
                    NEXT.

                IF NOT l-Titulo THEN DO:
                    {utp/ut-liter.i Grupo_de_Avaliaá∆o * L}
                    ASSIGN c-titulo = RETURN-VALUE.
                    
                    DISPLAY c-titulo
                            c-lbl-grp    
                            c-lbl-des-grp
                            c-lbl-versao 
                            c-lbl-descr  
                            c-lbl-dt-ini 
                            c-lbl-dt-fim
                        WITH DOWN FRAME f-grupo-cab.
                        DOWN WITH FRAME f-grupo-cab.
                    ASSIGN l-Titulo = TRUE.
                END.

                DISPLAY af-grp-avaliacao.cod-grp-avaliacao  
                        af-grp-avaliacao.des-grp-avaliacao  
                        tt-af-versao-avaliacao.nr-versao          
                        tt-af-versao-avaliacao.desc-versao  
                        tt-af-versao-avaliacao.c-data-ini   
                        tt-af-versao-avaliacao.c-data-fim
                    WITH DOWN FRAME f-grupo.
                    DOWN WITH FRAME f-grupo.
            END.
        END.
    END.

END.

IF tt-param.l-faixa-demerito THEN DO:
    {utp/ut-liter.i Gerando_Faixa_de_DemÇrito_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-faixa-demerito FOR af-faixa-demerito.

    ASSIGN l-Titulo = FALSE.

    FOR EACH af-faixa-demerito FIELDS(ep-codigo nr-controle nr-versao seq-faixa ind-tipo-valor) NO-LOCK
        WHERE   af-faixa-demerito.ep-codigo    = i-ep-codigo-usuario
        AND     af-faixa-demerito.nr-controle >= tt-param.i-nr-controle-ini
        AND     af-faixa-demerito.nr-controle <= tt-param.i-nr-controle-fim,
            FIRST af-controle FIELDS(ep-codigo nr-controle descricao) NO-LOCK
                WHERE   af-controle.ep-codigo = i-ep-codigo-usuario
                AND     af-controle.nr-controle = af-faixa-demerito.nr-controle
                AND     af-controle.descricao >= tt-param.c-nr-contr-desc-ini
                AND     af-controle.descricao <= tt-param.c-nr-contr-desc-fim
        BREAK BY af-faixa-demerito.nr-controle:

        IF FIRST-OF(af-faixa-demerito.nr-controle) THEN DO:

            FOR EACH tt-af-versao-avaliacao NO-LOCK
                WHERE tt-af-versao-avaliacao.nr-versao <> af-faixa-demerito.nr-versao:

                IF CAN-FIND(bfaf-faixa-demerito
                            WHERE   bfaf-faixa-demerito.ep-codigo = i-ep-codigo-usuario
                            AND     bfaf-faixa-demerito.nr-controle = af-faixa-demerito.nr-controle
                            AND     bfaf-faixa-demerito.nr-versao = tt-af-versao-avaliacao.nr-versao) THEN
                    NEXT.

                IF NOT l-Titulo THEN DO:
                    {utp/ut-liter.i Faixa_de_DemÇrito * L}
                    ASSIGN c-titulo = RETURN-VALUE.
                    
                    DISPLAY c-titulo
                            c-lbl-nr-ctr 
                            c-lbl-des-ctr
                            c-lbl-versao 
                            c-lbl-descr  
                            c-lbl-seq    
                            c-lbl-tipo   
                            c-lbl-dt-ini 
                            c-lbl-dt-fim 
                        WITH DOWN FRAME f-faixa-demerito-cab.
                        DOWN WITH FRAME f-faixa-demerito-cab.

                    ASSIGN l-Titulo = TRUE.
                END.

                ASSIGN c-tipo-faixa = {afinc/i01af010.i 04 af-faixa-demerito.ind-tipo-valor}.
                DISPLAY af-faixa-demerito.nr-controle      
                        af-controle.descricao              
                        tt-af-versao-avaliacao.nr-versao        
                        tt-af-versao-avaliacao.desc-versao 
                        af-faixa-demerito.seq-faixa        
                        c-tipo-faixa
                        tt-af-versao-avaliacao.c-data-ini
                        tt-af-versao-avaliacao.c-data-fim
                    WITH DOWN FRAME f-faixa-demerito.
                    DOWN WITH FRAME f-faixa-demerito.
            END.
        END.
    END.
END.
       
IF tt-param.l-faixa-calculo THEN DO:
    {utp/ut-liter.i Gerando_F¢rmula_de_C†lculo_... * L}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    DEFINE BUFFER bfaf-formula FOR af-formula.

    ASSIGN l-Titulo = FALSE.

    FOR EACH af-formula FIELDS(ep-codigo cod-formula descricao nr-versao) NO-LOCK
        WHERE   af-formula.ep-codigo    = i-ep-codigo-usuario
        AND     af-formula.cod-formula  >= tt-param.i-cod-formula-ini
        AND     af-formula.cod-formula  <= tt-param.i-cod-formula-fim
        AND     af-formula.descricao    >= tt-param.c-desc-form-ini
        AND     af-formula.descricao    <= tt-param.c-desc-form-fim
        BREAK BY af-formula.cod-formula:

        IF FIRST-OF(af-formula.cod-formula) THEN DO:

            FOR EACH tt-af-versao-avaliacao NO-LOCK
                WHERE tt-af-versao-avaliacao.nr-versao <> af-formula.nr-versao:
                
                IF CAN-FIND(bfaf-formula
                            WHERE bfaf-formula.ep-codigo = i-ep-codigo-usuario
                            AND   bfaf-formula.cod-formula = af-formula.cod-formula
                            AND   bfaf-formula.nr-versao = tt-af-versao-avaliacao.nr-versao)  THEN
                    NEXT.

                IF NOT l-Titulo THEN DO:
                    {utp/ut-liter.i F¢rmula_de_C†lculo * L}
                    ASSIGN c-titulo = RETURN-VALUE.
                    
                    DISPLAY c-titulo
                            c-lbl-formula
                            c-lbl-des-for  
                            c-lbl-versao 
                            c-lbl-descr  
                            c-lbl-dt-ini 
                            c-lbl-dt-fim 
                        WITH DOWN FRAME f-calculo-cab.
                        DOWN WITH FRAME f-calculo-cab.
                    ASSIGN l-Titulo = TRUE.
                END.
                    
                DISPLAY af-formula.cod-formula              
                        af-formula.descricao                
                        tt-af-versao-avaliacao.nr-versao                
                        tt-af-versao-avaliacao.desc-versao  
                        tt-af-versao-avaliacao.c-data-ini   
                        tt-af-versao-avaliacao.c-data-fim 
                    WITH DOWN FRAME f-calculo.
                    DOWN WITH FRAME f-calculo.
            END.
        END.    
    END.
END.

/****************************************************************************************/

/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY c-selecao
            c-item
            tt-param.c-item-ini   
            tt-param.c-item-fim
            c-descricao
            tt-param.c-descricao-ini 
            tt-param.c-descricao-fim
            c-familia
            tt-param.c-familia-ini    
            tt-param.c-familia-fim 
            c-esteblec
            tt-param.c-estabelecimento-ini
            tt-param.c-estabelecimento-fim
            c-emitente
            tt-param.i-fornecedor-ini
            tt-param.i-fornecedor-fim
            c-nom-abrev
            tt-param.c-nom-abrev-ini
            tt-param.c-nom-abrev-fim
            c-grp-aval
            tt-param.c-grp-avaliacao-ini
            tt-param.c-grp-avaliacao-fim
            c-des-grp-aval
            tt-param.c-des-grp-aval-ini
            tt-param.c-des-grp-aval-fim
            c-nr-control
            tt-param.i-nr-controle-ini
            tt-param.i-nr-controle-fim
            c-des-control
            tt-param.c-nr-contr-desc-ini
            tt-param.c-nr-contr-desc-fim
            c-formula
            tt-param.i-cod-formula-ini
            tt-param.i-cod-formula-fim
            c-descr-form
            tt-param.c-desc-form-ini
            tt-param.c-desc-form-fim
            c-considera
            c-fam-forn
            tt-param.l-familia-fornecedor
            c-item-aval-for
            tt-param.l-item-fornecedor
            c-it-est-av-for
            tt-param.l-item-estabelecimento
            c-grup-aval
            tt-param.l-grupo            
            c-faixa-dem    
            tt-param.l-faixa-demerito
            c-form-calc
            tt-param.l-faixa-calculo  
            WITH  FRAME f-param-sel.

/***********************************Finalizando******************************************/

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN DO:
    DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
END.

IF VALID-HANDLE(h-boaf016) THEN DO:
    DELETE PROCEDURE h-boaf016.
    ASSIGN h-boaf016 = ?.
END.

{include/i-rpclo.i}

RETURN "OK":U.
