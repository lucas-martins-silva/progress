/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0513RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0513.i}    

/* Defini‡Æo da temp-table tt-param e tt-digita */
/*******Defini‡Æo de Parƒmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boaf016    AS HANDLE NO-UNDO.
DEFINE VARIABLE d-dt-periodo-ini AS DATE    NO-UNDO.
DEFINE VARIABLE d-dt-periodo-fim AS DATE    NO-UNDO.
DEFINE VARIABLE c-periodo AS CHARACTER FORMAT 'x(7)'  NO-UNDO.
DEFINE VARIABLE i-contador AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-controle AS LOGICAL     NO-UNDO.

DEFINE BUFFER bfaf-contr-indice FOR af-contr-indice.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
{utp/ut-liter.i Elimina‡Æo_de_Öndices * C}
ASSIGN c-programa 	  = "AF0513RP"
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
DEFINE VARIABLE c-estabel       AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-emitente      AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-periodo-lbl   AS CHARACTER FORMAT "x(9)"   NO-UNDO.
DEFINE VARIABLE c-item          AS CHARACTER FORMAT "x(6)"   NO-UNDO.
DEFINE VARIABLE c-nr-controle   AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE c-parametros    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-per-fechado   AS CHARACTER FORMAT "x(27)"  NO-UNDO.
DEFINE VARIABLE c-elim-versao   AS CHARACTER FORMAT "x(19)"  NO-UNDO.
DEFINE VARIABLE c-estab    		AS CHARACTER FORMAT "x(5)"   NO-UNDO.
DEFINE VARIABLE c-fornec        AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-item-lbl      AS CHARACTER FORMAT "x(4)"   NO-UNDO.
DEFINE VARIABLE c-nr-control    AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-per-lbl       AS CHARACTER FORMAT "x(7)"   NO-UNDO.


{utp/ut-liter.i SELE€ÇO * L}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento_: * R}
ASSIGN c-estabel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor_: * R}
ASSIGN c-emitente = TRIM(RETURN-VALUE).
{utp/ut-liter.i Per¡odo_: * R}
ASSIGN c-periodo-lbl = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item_: * R}
ASSIGN c-item = TRIM(RETURN-VALUE).
{utp/ut-liter.i N£mero_Controle_: * R}
ASSIGN c-nr-controle = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR¶METROS * L}
ASSIGN c-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Somente_Per¡odos_Fechados_: * R}
ASSIGN c-per-fechado = TRIM(RETURN-VALUE).
{utp/ut-liter.i Simula_Elimina‡Æo_: * R}
ASSIGN c-elim-versao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estab * L}
ASSIGN c-estab = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor * L}
ASSIGN c-fornec = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * L}
ASSIGN c-item-lbl = RETURN-VALUE.
{utp/ut-liter.i N§_Controle * L}
ASSIGN c-nr-control = RETURN-VALUE.
{utp/ut-liter.i Per¡odo * L}
ASSIGN c-per-lbl = RETURN-VALUE.

/***********************************Sele‡Æo**********************************************/

FORM SKIP (2)
    c-selecao     AT  3 NO-LABEL SKIP(1)
    c-estabel     TO 25 NO-LABEL tt-param.c-estabelecimento-ini COLON 25 NO-LABEL "|<  >|" AT 65 tt-param.c-estabelecimento-fim  NO-LABEL SKIP
    c-emitente    TO 25 NO-LABEL tt-param.i-fornecedor-ini      COLON 25 NO-LABEL "|<  >|" AT 65 tt-param.i-fornecedor-fim       NO-LABEL SKIP
    c-periodo-lbl TO 25 NO-LABEL tt-param.i-ano-ini             COLON 25 NO-LABEL tt-param.c-periodo-ini NO-LABEL "|<  >|" AT 65 
                                 tt-param.i-ano-fim             NO-LABEL tt-param.c-periodo-fim  NO-LABEL SKIP
    c-item        TO 25 NO-LABEL tt-param.c-item-ini            COLON 25 NO-LABEL "|<  >|" AT 65 tt-param.c-item-fim             NO-LABEL SKIP    
    c-nr-controle TO 25 NO-LABEL tt-param.i-nr-controle-ini     COLON 25 NO-LABEL "|<  >|" AT 65 tt-param.i-nr-controle-fim      NO-LABEL SKIP    
    SKIP(2)
    c-parametros  AT  3 NO-LABEL SKIP(1)
    c-per-fechado TO 49 NO-LABEL tt-param.l-somente-fechado     COLON 49 NO-LABEL FORMAT "Sim/NÆo"
    c-elim-versao TO 49 NO-LABEL tt-param.l-simula-eliminacao   COLON 49 NO-LABEL FORMAT "Sim/NÆo"
        
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/

/********************************Frames**************************************************/
/*FORM Fam¡lia Avalia‡Æo Fornecedores*/
FORM 
    c-estab        NO-LABEL FORMAT 'x(5)'       AT 3
    c-fornec       NO-LABEL FORMAT 'x(10)'      AT 10
    c-item-lbl     NO-LABEL FORMAT 'x(4)'       AT 22
    c-nr-control   NO-LABEL FORMAT 'x(11)'      AT 41
    c-per-lbl      NO-LABEL FORMAT 'x(7)'       AT 54 SKIP
    "-----"             AT 3
    "----------"        AT 10
    "----------------"  AT 22
    "---------"         AT 41
    "-------"           AT 54
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-indice-cab.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-indice-cab:HANDLE).


FORM 
    af-contr-indice.cod-estabel     NO-LABEL FORMAT 'x(5)'       AT 3
    af-contr-indice.cod-emitente    NO-LABEL FORMAT '>>>>>>>>9'  AT 10
    af-contr-indice.it-codigo       NO-LABEL FORMAT 'x(16)'      AT 22
    af-contr-indice.nr-controle     NO-LABEL FORMAT '>>>>>9'     AT 41
    c-periodo                       NO-LABEL FORMAT '99/9999'    AT 54
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-indice.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-indice:HANDLE).


RUN afbo/boaf016.p PERSISTENT SET h-boaf016.
RUN setConstraintAno IN h-boaf016 (INPUT tt-param.i-ano-ini, INPUT tt-param.i-ano-ini).
RUN openQueryStatic IN h-boaf016 (INPUT "byAno":U) NO-ERROR. 
RUN getDateField IN h-boaf016 (INPUT "dt-periodo-ini[" + STRING(tt-param.i-periodo-ini) + "]", OUTPUT d-dt-periodo-ini).                                      

RUN setConstraintAno IN h-boaf016 (INPUT tt-param.i-ano-fim, INPUT tt-param.i-ano-fim).
RUN openQueryStatic IN h-boaf016 (INPUT "byAno":U) NO-ERROR.
RUN getDateField IN h-boaf016 (INPUT "dt-periodo-fim[" + STRING(tt-param.i-periodo-fim) + "]", OUTPUT d-dt-periodo-fim).

IF VALID-HANDLE(h-boaf016) THEN DO:
    DELETE PROCEDURE h-boaf016.
    ASSIGN h-boaf016 = ?.
END.
             

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Excluindo_Öndices_... * L}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).


ASSIGN l-controle = TRUE.

FOR EACH af-contr-indice NO-LOCK
    WHERE   af-contr-indice.cod-estabel >= tt-param.c-estabelecimento-ini 
    AND     af-contr-indice.cod-estabel <= tt-param.c-estabelecimento-fim 
    AND     af-contr-indice.cod-emitente >= tt-param.i-fornecedor-ini 
    AND     af-contr-indice.cod-emitente <= tt-param.i-fornecedor-fim
    AND     af-contr-indice.it-codigo >= tt-param.c-item-ini
    AND     af-contr-indice.it-codigo <= tt-param.c-item-fim
    AND     af-contr-indice.nr-controle >= tt-param.i-nr-controle-ini
    AND     af-contr-indice.nr-controle <= tt-param.i-nr-controle-fim
    AND     af-contr-indice.dt-indice >= d-dt-periodo-ini
    AND     af-contr-indice.dt-indice <= d-dt-periodo-fim
    AND     af-contr-indice.ep-codigo = i-ep-codigo-usuario:

    IF tt-param.l-somente-fechado THEN DO:
        ASSIGN  l-controle = TRUE.                

        FOR EACH af-periodo-aval NO-LOCK
            WHERE af-periodo-aval.ano-avaliacao = YEAR(af-contr-indice.dt-indice)
            AND   af-periodo-aval.ep-codigo = i-ep-codigo-usuario :

            DO i-contador = 1 TO af-periodo-aval.nr-periodos:
                IF af-periodo-aval.dt-periodo-ini [i-contador] <= af-contr-indice.dt-indice AND 
                    af-periodo-aval.dt-periodo-fim [i-contador] >= af-contr-indice.dt-indice THEN DO:                
                    IF af-periodo-aval.log-fechado [i-contador] = FALSE THEN DO:
                        ASSIGN l-controle = FALSE.
                        LEAVE.
                    END.
                END.
            END.
        END.        
    END.

    IF l-controle = TRUE THEN DO:
         ASSIGN c-periodo = TRIM(STRING(MONTH(af-contr-indice.dt-indice),"99") +  STRING(YEAR(af-contr-indice.dt-indice),"9999")).
         IF l-mostra THEN DO:
            DISPLAY c-estab        
                    c-fornec       
                    c-item-lbl     
                    c-nr-control  
                    c-per-lbl      
                WITH DOWN FRAME f-indice-cab.
                DOWN WITH FRAME f-indice-cab.
                ASSIGN l-mostra = FALSE.
         END.
         DISPLAY af-contr-indice.cod-estabel
                 af-contr-indice.cod-emitente
                 af-contr-indice.it-codigo
                 af-contr-indice.nr-controle
                 c-periodo
                WITH DOWN FRAME f-indice.
                DOWN WITH FRAME f-indice.

        IF NOT tt-param.l-simula-eliminacao THEN DO:
            FIND FIRST bfaf-contr-indice EXCLUSIVE-LOCK
                WHERE   bfaf-contr-indice.ep-codigo     = i-ep-codigo-usuario
                AND     bfaf-contr-indice.cod-estabel   = af-contr-indice.cod-estabel
                AND     bfaf-contr-indice.cod-emitente  = af-contr-indice.cod-emitente
                AND     bfaf-contr-indice.it-codigo     = af-contr-indice.it-codigo
                AND     bfaf-contr-indice.nr-controle   = af-contr-indice.nr-controle
                AND     bfaf-contr-indice.dt-indice     = af-contr-indice.dt-indice NO-ERROR.
            IF AVAIL bfaf-contr-indice THEN
                DELETE bfaf-contr-indice.
        END.
    END.
END.
  
/****************************************************************************************/
{utp/ut-liter.i Gerando_Relat¢rio_... * L}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY c-selecao
            c-estabel
            tt-param.c-estabelecimento-ini
            tt-param.c-estabelecimento-fim
            c-emitente
            tt-param.i-fornecedor-ini
            tt-param.i-fornecedor-fim
            c-periodo-lbl
            tt-param.i-ano-ini
            tt-param.c-periodo-ini
            tt-param.i-ano-fim
            tt-param.c-periodo-fim
            c-item
            tt-param.c-item-ini   
            tt-param.c-item-fim 
            c-nr-controle            
            tt-param.i-nr-controle-ini
            tt-param.i-nr-controle-fim
            c-parametros
            c-per-fechado
            tt-param.l-somente-fechado
            c-elim-versao
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
