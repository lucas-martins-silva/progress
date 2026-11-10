/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0511RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0511.i}    

/* Definiá∆o da temp-table tt-param e tt-digita */
/*******Definiá∆o de ParÉmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.

DEFINE TEMP-TABLE tt-af-formula NO-UNDO LIKE af-formula
    FIELD desc-versao LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo    LIKE af-versao-avaliacao.nr-periodo.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
{utp/ut-liter.i Listagem_de_F¢rmulas_de_C†lculo * C}
ASSIGN c-programa 	  = "AF0511RP"
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
DEFINE VARIABLE c-formula       AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-classific     AS CHARACTER FORMAT "x(13)"  NO-UNDO.
DEFINE VARIABLE c-class-lbl     AS CHARACTER FORMAT "x(15)"  NO-UNDO.
DEFINE VARIABLE c-parametros    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-det-for       AS CHARACTER FORMAT "x(29)"  NO-UNDO.
DEFINE VARIABLE c-expressao     AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-narrativa     AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-versoes       AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-codigo        AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-desc-form     AS CHARACTER FORMAT "x(50)"  NO-UNDO.
DEFINE VARIABLE c-cab-versao    AS CHARACTER FORMAT "x(7)"   NO-UNDO.
DEFINE VARIABLE c-desc-vers     AS CHARACTER FORMAT "x(40)"  NO-UNDO.
DEFINE VARIABLE c-padrao        AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-dt-ini-val    AS CHARACTER FORMAT "x(15)"  NO-UNDO.
DEFINE VARIABLE c-dt-fim-val    AS CHARACTER FORMAT "x(15)"  NO-UNDO.
DEFINE VARIABLE c-dt-implant    AS CHARACTER FORMAT "x(14)"  NO-UNDO.
DEFINE VARIABLE c-dt-alteracao  AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-hr-alteraco   AS CHARACTER FORMAT "x(14)"  NO-UNDO.
DEFINE VARIABLE c-usuario       AS CHARACTER FORMAT "x(17)"  NO-UNDO.

{utp/ut-liter.i SELEÄ«O * L}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Vers∆o_: * R}
ASSIGN c-versao-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descriá∆o_: * R}
ASSIGN c-descricao  = TRIM(RETURN-VALUE)
       c-descr-form = TRIM(RETURN-VALUE).
{utp/ut-liter.i F¢rmula_: * R}
ASSIGN c-formula = TRIM(RETURN-VALUE).
{utp/ut-liter.i CLASSIFICAÄ«O * R}
ASSIGN c-classific = TRIM(RETURN-VALUE).
{utp/ut-liter.i Classificaá∆o_: * R}
ASSIGN c-class-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR∂METROS * R}
ASSIGN c-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_detalhes_da_F¢rmula_: * R}
ASSIGN c-det-for = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_Express∆o_: * R}
ASSIGN c-expressao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Mostrar_Narrativa_: * R}
ASSIGN c-narrativa = TRIM(RETURN-VALUE).
{utp/ut-liter.i Vers‰es_: * R}
ASSIGN c-versoes = TRIM(RETURN-VALUE).
{utp/ut-liter.i C¢digo * L}
ASSIGN c-codigo = RETURN-VALUE.
{utp/ut-liter.i Descriá∆o * L}
ASSIGN c-desc-form = RETURN-VALUE
       c-desc-vers = RETURN-VALUE.
{utp/ut-liter.i Vers∆o * L}
ASSIGN c-cab-versao = RETURN-VALUE.
{utp/ut-liter.i Padr∆o * L}
ASSIGN c-padrao = RETURN-VALUE.
{utp/ut-liter.i Dt_Ini_Validade * L}
ASSIGN c-dt-ini-val = RETURN-VALUE.
{utp/ut-liter.i Dt_Fim_Validade * L}
ASSIGN c-dt-fim-val = RETURN-VALUE.
{utp/ut-liter.i Dt_Implantaá∆o * L}
ASSIGN c-dt-implant = RETURN-VALUE.
{utp/ut-liter.i Dt_Alteraá∆o * L}
ASSIGN c-dt-alteracao = RETURN-VALUE.
{utp/ut-liter.i Hora_Alteraá∆o * L}
ASSIGN c-hr-alteraco = RETURN-VALUE.
{utp/ut-liter.i Usu†rio_Alteraá∆o * L}
ASSIGN c-usuario = RETURN-VALUE.


/***********************************Seleá∆o**********************************************/
/*Est† utilizando duas vari†veis para descriá∆o, n∆o remover porque se utilizar apenas uma n∆o funciona,
    o mesmo vale para outras vari†veis*/
FORM SKIP (2)
    c-selecao     AT  3 NO-LABEL SKIP(1)
    c-versao-lbl  TO 16 NO-LABEL tt-param.i-nr-versao-ini    COLON 16 NO-LABEL "|<  >|" AT 74 tt-param.i-nr-versao-fim    NO-LABEL SKIP
    c-descricao   TO 16 NO-LABEL tt-param.c-descricao-ini    COLON 16 NO-LABEL "|<  >|" AT 74 tt-param.c-descricao-fim    NO-LABEL SKIP
    c-formula     TO 16 NO-LABEL tt-param.i-cod-formula-ini  COLON 16 NO-LABEL "|<  >|" AT 74 tt-param.i-cod-formula-fim  NO-LABEL SKIP
    c-descr-form  TO 16 NO-LABEL tt-param.c-desc-formula-ini COLON 16 NO-LABEL "|<  >|" AT 74 tt-param.c-desc-formula-fim NO-LABEL SKIP
    
    SKIP(2)
    c-classific   AT  3 NO-LABEL SKIP(1)
    c-class-lbl   TO 20 NO-LABEL tt-param.desc-classifica    COLON  20 NO-LABEL
    SKIP(2)                     
    c-parametros  AT  3 NO-LABEL SKIP(1)
    c-det-for     TO 30 NO-LABEL tt-param.l-detalhar-formula COLON  30 NO-LABEL FORMAT "Sim/N∆o" 
    c-expressao   TO 30 NO-LABEL tt-param.l-expressao        COLON  30 NO-LABEL FORMAT "Sim/N∆o"     
    c-narrativa   TO 30 NO-LABEL tt-param.l-narrativa        COLON  30 NO-LABEL FORMAT "Sim/N∆o" 
    c-versoes     TO 30 NO-LABEL tt-param.rs-desc-versao     COLON  30 NO-LABEL
            
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).
   
/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM F¢rmulas*/
FORM     
    c-codigo        NO-LABEL FORMAT 'x(6)'    AT 3
    c-desc-form     NO-LABEL FORMAT 'x(50)'   AT 10
    c-cab-versao    NO-LABEL FORMAT 'x(7)'    AT 61
    c-desc-vers     NO-LABEL FORMAT 'x(40)'   AT 68 SKIP
    "------"                                                 AT 3
    "--------------------------------------------------"     AT 10
    "------"                                                 AT 61
    "----------------------------------------"               AT 68
   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-formula-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-formula-cab:HANDLE).


FORM     
    tt-af-formula.cod-formula          NO-LABEL FORMAT '>>>>>9'    AT 3
    tt-af-formula.descricao            NO-LABEL FORMAT 'x(50)'     AT 10
    tt-af-formula.nr-versao            NO-LABEL FORMAT '>>>>9'     AT 61
    tt-af-formula.desc-versao          NO-LABEL FORMAT 'x(40)'     AT 68

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-formula. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-formula:HANDLE).
 

FORM
    c-padrao        NO-LABEL FORMAT "x(6)"     AT 3
    c-dt-ini-val    NO-LABEL FORMAT "x(15)"    AT 10
    c-dt-fim-val    NO-LABEL FORMAT "x(15)"    AT 26
    c-dt-implant    NO-LABEL FORMAT "x(14)"    AT 42
    c-dt-alteracao  NO-LABEL FORMAT "x(12)"    AT 57
    c-hr-alteraco   NO-LABEL FORMAT "x(14)"    AT 70
    c-usuario       NO-LABEL FORMAT "x(17)"    AT 85 SKIP
    "------"            AT 3
    "---------------"   AT 10
    "---------------"   AT 26
    "--------------"    AT 42
    "------------"      AT 57
    "--------------"    AT 70
    "-----------------" AT 85

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-detalhes-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-detalhes-cab:HANDLE).


/*FORM Detalhes das F¢rmulas*/
FORM
    tt-af-formula.padrao          NO-LABEL FORMAT 'Sim/N∆o'       AT 3
    tt-af-formula.dt-ini-validade NO-LABEL FORMAT '99/99/9999'    AT 10
    tt-af-formula.dt-fim-validade NO-LABEL FORMAT '99/99/9999'    AT 26
    tt-af-formula.dt-implantacao  NO-LABEL FORMAT '99/99/9999'    AT 42
    tt-af-formula.dt-alter        NO-LABEL FORMAT '99/99/9999'    AT 57
    tt-af-formula.hora-alter      NO-LABEL FORMAT 'x(8)'          AT 70
    tt-af-formula.usuar-alter     NO-LABEL FORMAT 'x(12)'         AT 85

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-detalhes.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-detalhes:HANDLE).


/*FORM Express∆o da F¢rmula*/
FORM
    tt-af-formula.expressao FORMAT 'x(2000)'     AT 3    
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-expressao. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-expressao:HANDLE).
   
   
/*FORM Narrativa da F¢rmula*/
FORM
    tt-af-formula.narrativa FORMAT 'x(2000)'     AT 3    
   
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-narrativa.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-narrativa:HANDLE).


FORM    
    WITH STREAM-IO DOWN NO-BOX WIDTH 132 FRAME f-skip. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-skip:HANDLE).
   

/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Gerando_Relat¢rio_... * L}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/************************************Execuá∆o********************************************/
{utp/ut-liter.i Lendo_Listagem_de_F¢rmulas... * L}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

FOR EACH af-formula NO-LOCK
    WHERE   af-formula.ep-codigo    =  i-ep-codigo-usuario
    AND     af-formula.cod-formula  >= tt-param.i-cod-formula-ini
    AND     af-formula.cod-formula  <= tt-param.i-cod-formula-fim
    AND     af-formula.descricao    >= tt-param.c-desc-formula-ini
    AND     af-formula.descricao    <= tt-param.c-desc-formula-fim
    AND     af-formula.nr-versao    >= tt-param.i-nr-versao-ini
    AND     af-formula.nr-versao    <= tt-param.i-nr-versao-fim,
        FIRST af-versao-avaliacao FIELDS(desc-versao ano-avaliacao nr-periodo) NO-LOCK
            WHERE   af-versao-avaliacao.nr-versao = af-formula.nr-versao
            AND     af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario
    BREAK BY af-formula.cod-formula 
          BY af-versao-avaliacao.ano-avaliacao DESC
          BY af-versao-avaliacao.nr-periodo DESC:    

    IF tt-param.rsVersoes = 2 THEN DO:
        IF NOT (FIRST-OF (af-formula.cod-formula) 
            AND FIRST-OF (af-versao-avaliacao.ano-avaliacao)
            AND FIRST-OF (af-versao-avaliacao.nr-periodo)) THEN
            NEXT.
    END.

    CREATE tt-af-formula.
    BUFFER-COPY af-formula TO tt-af-formula.    
    ASSIGN  tt-af-formula.desc-versao   = af-versao-avaliacao.desc-versao
            tt-af-formula.ano-avaliacao = af-versao-avaliacao.ano-avaliacao
            tt-af-formula.nr-periodo    = af-versao-avaliacao.nr-periodo.
END.



{utp/ut-liter.i Gerando_Realt¢rios * L}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF tt-param.classifica = 1 THEN DO:
    /*
        Ordena Por F¢rmula.
    */    
    FOR EACH tt-af-formula NO-LOCK
        BY tt-af-formula.cod-formula
        BY tt-af-formula.nr-versao:
        /*Chama a Procedure para mostrar os registros*/
        RUN pi-formulas (INPUT TABLE tt-af-formula).
    END.
END.
ELSE DO:
    /*Ordena por Vers∆o*/
    FOR EACH tt-af-formula NO-LOCK
        BY tt-af-formula.nr-versao:
        /*Chama a Procedure para mostrar os registros*/
        RUN pi-formulas (INPUT TABLE tt-af-formula).
    END.
END.

PROCEDURE pi-formulas:
   /*
    Procedure para Mostar os valores das F¢rmulas.
    paf-formula Ç o Registro corrente da tt.
  */
    DEFINE INPUT PARAMETER TABLE FOR tt-af-formula.

        /*
            Mostra as f¢rmulas       
        */
        IF l-mostra OR tt-param.l-detalhar-formula 
            OR tt-param.l-expressao OR (tt-param.l-narrativa AND tt-af-formula.narrativa <> "") THEN DO:
            DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.

            DISPLAY     c-codigo        
                        c-desc-form     
                        c-cab-versao    
                        c-desc-vers     
                WITH DOWN FRAME f-formula-cab.
                DOWN WITH FRAME f-formula-cab.
                ASSIGN l-mostra = FALSE.
        END.

        DISPLAY tt-af-formula.cod-formula
                tt-af-formula.descricao
                tt-af-formula.nr-versao
                tt-af-formula.desc-versao
            WITH DOWN FRAME f-formula.
            DOWN WITH FRAME f-formula.

        IF tt-param.l-detalhar-formula THEN DO:

            /*
                Mostra os detalhes da f¢rmula
            */
            DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.

            DISPLAY c-padrao
                    c-dt-ini-val
                    c-dt-fim-val
                    c-dt-implant
                    c-dt-alteracao
                    c-hr-alteraco
                    c-usuario
            WITH DOWN FRAME f-detalhes-cab.
            DOWN WITH FRAME f-detalhes-cab.
            
            DISPLAY tt-af-formula.padrao
                    tt-af-formula.dt-ini-validade
                    tt-af-formula.dt-fim-validade
                    tt-af-formula.dt-implantacao
                    tt-af-formula.dt-alter
                    tt-af-formula.hora-alter
                    tt-af-formula.usuar-alter
            WITH DOWN FRAME f-detalhes.
            DOWN WITH FRAME f-detalhes.                       
        END.

        IF tt-param.l-expressao THEN DO:
            /*
                Mostra a express∆o da f¢rmula
            */
            DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.

            DISPLAY tt-af-formula.expressao
                WITH DOWN FRAME f-expressao.
                DOWN WITH FRAME f-expressao.                
        END.

        IF tt-param.l-narrativa THEN DO:
            IF tt-af-formula.narrativa <> "" THEN DO:
                /*
                    Quando informado mostra a Narrativa da F¢rmula
                */                 

                DISPLAY tt-af-formula.narrativa
                    WITH DOWN FRAME f-narrativa.
                    DOWN WITH FRAME f-narrativa.                

                DISPLAY
                    WITH DOWN FRAME f-skip.
                    DOWN WITH FRAME f-skip.
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
            c-formula
            tt-param.i-cod-formula-ini
            tt-param.i-cod-formula-fim
            c-descr-form
            tt-param.c-desc-formula-ini   
            tt-param.c-desc-formula-fim 
            c-classific
            c-class-lbl 
            tt-param.desc-classifica            
            c-parametros
            c-det-for
            tt-param.l-detalhar-formula
            c-expressao
            tt-param.l-expressao
            c-narrativa
            tt-param.l-narrativa
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
