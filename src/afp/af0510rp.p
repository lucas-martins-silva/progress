/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0510RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0510.i}    

/* Defini‡Æo da temp-table tt-param e tt-digita */
/*******Defini‡Æo de Parƒmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-mostra-titulo AS LOGICAL  INIT FALSE   NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-programa 	  = "AF0510RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = "Ativa/Desativa Relacionamento".

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.


/***********************************Sele‡Æo**********************************************/
FORM SKIP (2)
    "SELE€ÇO"                       AT  3 SKIP(1)
    tt-param.i-nr-versao-ini        COLON 24 "|<  >|" AT 73 tt-param.i-nr-versao-fim        NO-LABEL SKIP
    tt-param.c-descricao-ini        COLON 24 "|<  >|" AT 73 tt-param.c-descricao-fim        NO-LABEL SKIP
    tt-param.c-familia-ini          COLON 24 "|<  >|" AT 73 tt-param.c-familia-fim          NO-LABEL SKIP
    tt-param.c-item-ini             COLON 24 "|<  >|" AT 73 tt-param.c-item-fim             NO-LABEL SKIP    
    tt-param.c-estabelecimento-ini  COLON 24 "|<  >|" AT 73 tt-param.c-estabelecimento-fim  NO-LABEL SKIP
    tt-param.i-fornecedor-ini       COLON 24 "|<  >|" AT 73 tt-param.i-fornecedor-fim       NO-LABEL SKIP
    tt-param.c-grp-avaliacao-ini    COLON 24 "|<  >|" AT 73 tt-param.c-grp-avaliacao-fim    NO-LABEL SKIP    
    SKIP(2)
    "PAR¶METROS"               AT  3  SKIP(1)
    tt-param.r-ativa-desativa       COLON  48 LABEL "Ativa/Desativa"                                 FORMAT "Ativa/Desativa"
    tt-param.l-familia-fornecedor   COLON  48 LABEL "Fam¡lia Avalia‡Æo Fornecedores"                 FORMAT "Sim/NÆo"
    tt-param.l-item-fornecedor      COLON  48 LABEL "Item Avalia‡Æo Fornecedores"                    FORMAT "Sim/NÆo"
    tt-param.l-item-estabelecimento COLON  48 LABEL "Item X Estabelecimento Avalia‡Æo Fornecedores"  FORMAT "Sim/NÆo"
    tt-param.l-grupo                COLON  48 LABEL "Grupo Avalia‡Æo"                                FORMAT "Sim/NÆo"
    tt-param.l-ativa-desativa       COLON  48 LABEL "Simula ativa‡Æo/desativa‡Æo"                    FORMAT "Sim/NÆo"
        
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM Fam¡lia Avalia‡Æo Fornecedores*/
FORM     
    af-familia-contr.fm-codigo            COLUMN-LABEL "Fam¡lia"      FORMAT 'x(8)'       AT 3
    af-familia-contr.cod-emitente         COLUMN-LABEL "Fornecedor"   FORMAT '>>>>>>>>9'  AT 12
    af-familia-contr.nr-versao            COLUMN-LABEL "VersÆo"       FORMAT '>>>>9'      AT 24
    af-versao-avaliacao.desc-versao       COLUMN-LABEL "Descri‡Æo"    FORMAT 'x(40)'      AT 32

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-familia-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familia-fornecedor:HANDLE).


/*FORM Item Avalia‡Æo Fornecedores*/
FORM     
    af-item-contr.it-codigo            COLUMN-LABEL "Item"         FORMAT 'x(16)'       AT 3
    af-item-contr.cod-emitente         COLUMN-LABEL "Fornecedor"   FORMAT '>>>>>>>>9'  AT 21
    af-item-contr.nr-versao            COLUMN-LABEL "VersÆo"       FORMAT '>>>>9'      AT 33
    af-versao-avaliacao.desc-versao    COLUMN-LABEL "Descri‡Æo"    FORMAT 'x(40)'      AT 41

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-fornecedor:HANDLE).


/*FORM Itens x Estabelecimento Avalia‡Æo Fornecedores*/
FORM     
    af-item-contr-estab.it-codigo            COLUMN-LABEL "Item"         FORMAT 'x(16)'      AT 3
    af-item-contr-estab.cod-estabel          COLUMN-LABEL "Estab"        FORMAT 'x(5)'       AT 21
    af-item-contr-estab.cod-emitente         COLUMN-LABEL "Fornecedor"   FORMAT '>>>>>>>>9'  AT 28
    af-item-contr-estab.nr-versao            COLUMN-LABEL "VersÆo"       FORMAT '>>>>9'      AT 40
    af-versao-avaliacao.desc-versao          COLUMN-LABEL "Descri‡Æo"    FORMAT 'x(40)'      AT 48

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-item-estab-fornecedor.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-estab-fornecedor:HANDLE).


/*FORM Grupo de Avalia‡Æo*/
FORM     
    af-grp-avaliacao.cod-grp-avaliacao      COLUMN-LABEL "Grupo"        FORMAT 'x(8)'       AT 3
    af-grp-avaliacao.des-grp-avaliacao      COLUMN-LABEL "Descri‡Æo"    FORMAT 'x(40)'      AT 13
    af-grp-avaliacao.nr-versao              COLUMN-LABEL "VersÆo"       FORMAT '>>>>9'      AT 55    
    af-versao-avaliacao.desc-versao         COLUMN-LABEL "Descri‡Æo"    FORMAT 'x(40)'      AT 63

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-grupo-avaliacao.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo-avaliacao:HANDLE).


/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF tt-param.l-ativa-desativa THEN
    RUN pi-inicializar IN h-acomp (INPUT "Simulando Ativa‡Æo/Desativa‡Æo Registros...").
ELSE
    RUN pi-inicializar IN h-acomp (INPUT "Ativa‡Æo/Desativa‡Æo Registros...").

/************************************Execu‡Æo********************************************/


IF tt-param.l-familia-fornecedor THEN DO:

    IF tt-param.l-ativa-desativa THEN
        RUN pi-inicializar IN h-acomp (INPUT "Simulando Ativa‡Æo/Desativa‡Æo da Fam¡lia Avalia‡Æo Fornecedores...").
    ELSE
        RUN pi-inicializar IN h-acomp (INPUT "Ativa‡Æo/Desativa‡Æo da Fam¡lia Avalia‡Æo Fornecedores...").
    
    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-familia-contr EXCLUSIVE-LOCK
        WHERE   (af-familia-contr.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-familia-contr.nr-versao <= tt-param.i-nr-versao-fim)
        AND     (af-familia-contr.fm-codigo >= tt-param.c-familia-ini
        AND     af-familia-contr.fm-codigo <= tt-param.c-familia-fim)
        AND     (af-familia-contr.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-familia-contr.cod-emitente <= tt-param.i-fornecedor-fim)
        AND     af-familia-contr.ep-codigo = i-ep-codigo-usuario
        AND     af-familia-contr.ativo = (NOT tt-param.r-ativa-desativa),
            FIRST af-versao-avaliacao NO-LOCK
            WHERE   af-familia-contr.nr-versao = af-versao-avaliacao.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:

        IF NOT l-mostra-titulo THEN DO:
            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-familia-avaliacao-fornecedores AS CHARACTER FORMAT "X(32)" NO-UNDO.
            {utp/ut-liter.i "Fam¡lia_Avalia‡Æo_Fornecedores" *}
            ASSIGN c-lbl-liter-familia-avaliacao-fornecedores = TRIM(RETURN-VALUE).
            DISPLAY c-lbl-liter-familia-avaliacao-fornecedores      AT 3 SKIP(1).
            ASSIGN l-mostra-titulo = TRUE.
        END.
        DISPLAY af-familia-contr.fm-codigo
                af-familia-contr.cod-emitente
                af-familia-contr.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-familia-fornecedor.
            DOWN WITH FRAME f-familia-fornecedor.

            IF NOT tt-param.l-ativa-desativa THEN
                ASSIGN af-familia-contr.ativo = tt-param.r-ativa-desativa.
    END.
END.

IF tt-param.l-item-fornecedor THEN DO:

    IF tt-param.l-ativa-desativa THEN
        RUN pi-inicializar IN h-acomp (INPUT "Simulando Ativa‡Æo/Desativa‡Æo dos Itens Avalia‡Æo Fornecedores...").
    ELSE
        RUN pi-inicializar IN h-acomp (INPUT "Ativa‡Æo/Desativa‡Æo dos Itens Avalia‡Æo Fornecedores...").
   
   ASSIGN l-mostra-titulo = FALSE.

   FOR EACH af-item-contr EXCLUSIVE-LOCK
       WHERE   (af-item-contr.nr-versao >= tt-param.i-nr-versao-ini
       AND     af-item-contr.nr-versao <= tt-param.i-nr-versao-fim)
       AND     (af-item-contr.it-codigo >= tt-param.c-item-ini
       AND     af-item-contr.it-codigo <= tt-param.c-item-fim)
       AND     (af-item-contr.cod-emitente >= tt-param.i-fornecedor-ini
       AND     af-item-contr.cod-emitente <= tt-param.i-fornecedor-fim)
       AND     af-item-contr.ep-codigo = i-ep-codigo-usuario
       AND     af-item-contr.ativo = (NOT tt-param.r-ativa-desativa),
           FIRST af-versao-avaliacao NO-LOCK
           WHERE   af-item-contr.nr-versao = af-versao-avaliacao.nr-versao
           AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
           AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
           AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:

       IF NOT l-mostra-titulo THEN DO:
           /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
           DEFINE VARIABLE c-lbl-liter-itens-avaliacao-fornecedores AS CHARACTER FORMAT "X(30)" NO-UNDO.
           {utp/ut-liter.i "Itens_Avalia‡Æo_Fornecedores" *}
           ASSIGN c-lbl-liter-itens-avaliacao-fornecedores = TRIM(RETURN-VALUE).
           DISPLAY c-lbl-liter-itens-avaliacao-fornecedores      AT 3 SKIP(1).
           ASSIGN l-mostra-titulo = TRUE.
       END.

       DISPLAY af-item-contr.it-codigo
               af-item-contr.cod-emitente
               af-item-contr.nr-versao
               af-versao-avaliacao.desc-versao
           WITH DOWN FRAME f-item-fornecedor.
           DOWN WITH FRAME f-item-fornecedor.

           IF NOT tt-param.l-ativa-desativa THEN
                ASSIGN af-item-contr.ativo = tt-param.r-ativa-desativa.
   END.
END.

IF tt-param.l-item-estabelecimento THEN DO:

    IF tt-param.l-ativa-desativa THEN
        RUN pi-inicializar IN h-acomp (INPUT "Simulando Ativa‡Æo/Desativa‡Æo dos Itens x Estabelecimento Avalia‡Æo Fornecedores...").
    ELSE
        RUN pi-inicializar IN h-acomp (INPUT "Ativa‡Æo/Desativa‡Æo dos Itens x Estabelecimento Avalia‡Æo Fornecedores...").
    
    ASSIGN l-mostra-titulo = FALSE.
    
    FOR EACH af-item-contr-estab EXCLUSIVE-LOCK
        WHERE   (af-item-contr-estab.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-item-contr-estab.nr-versao <= tt-param.i-nr-versao-fim)
        AND     (af-item-contr-estab.it-codigo >= tt-param.c-item-ini
        AND     af-item-contr-estab.it-codigo <= tt-param.c-item-fim)
        AND     (af-item-contr-estab.cod-emitente >= tt-param.i-fornecedor-ini
        AND     af-item-contr-estab.cod-emitente <= tt-param.i-fornecedor-fim)
        AND     (af-item-contr-estab.cod-estabel >= tt-param.c-estabelecimento-ini
        AND     af-item-contr-estab.cod-estabel <= tt-param.c-estabelecimento-fim)
        AND     af-item-contr-estab.ep-codigo = i-ep-codigo-usuario
        AND     af-item-contr-estab.ativo = (NOT tt-param.r-ativa-desativa),
            FIRST af-versao-avaliacao NO-LOCK
            WHERE    af-item-contr-estab.nr-versao   = af-versao-avaliacao.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:        

        IF NOT l-mostra-titulo THEN DO:
            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-itens-x-estabelecimento-avalia AS CHARACTER FORMAT "X(48)" NO-UNDO.
            {utp/ut-liter.i "Itens_x_Estabelecimento_Avalia‡Æo_Fornecedores" *}
            ASSIGN c-lbl-liter-itens-x-estabelecimento-avalia = TRIM(RETURN-VALUE).
            DISPLAY c-lbl-liter-itens-x-estabelecimento-avalia      AT 3 SKIP(1).
            ASSIGN l-mostra-titulo = TRUE.
        END.
        DISPLAY af-item-contr-estab.it-codigo
                af-item-contr-estab.cod-estabel
                af-item-contr-estab.cod-emitente
                af-item-contr-estab.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-item-estab-fornecedor.
            DOWN WITH FRAME f-item-estab-fornecedor.

            IF NOT tt-param.l-ativa-desativa THEN
                ASSIGN af-item-contr-estab.ativo = tt-param.r-ativa-desativa.
    END.
END.

IF tt-param.l-grupo THEN DO:

     IF tt-param.l-ativa-desativa THEN
        RUN pi-inicializar IN h-acomp (INPUT "Simulando Ativa‡Æo/Desativa‡Æo dos Grupos de Avalia‡Æo...").
    ELSE
        RUN pi-inicializar IN h-acomp (INPUT "Ativa‡Æo/Desativa‡Æo dos Grupos de Avalia‡Æo...").
    
    ASSIGN l-mostra-titulo = FALSE.

    FOR EACH af-grp-avaliacao EXCLUSIVE-LOCK
        WHERE   (af-grp-avaliacao.cod-grp-avaliacao >= tt-param.c-grp-avaliacao-ini
        AND     af-grp-avaliacao.cod-grp-avaliacao <=tt-param.c-grp-avaliacao-fim)
        AND     (af-grp-avaliacao.nr-versao >= tt-param.i-nr-versao-ini
        AND     af-grp-avaliacao.nr-versao <= tt-param.i-nr-versao-fim)
        AND     af-grp-avaliacao.ativo = (NOT tt-param.r-ativa-desativa)
        AND     af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario,
        FIRST   af-versao-avaliacao NO-LOCK
            WHERE   af-grp-avaliacao.nr-versao = af-grp-avaliacao.nr-versao        
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:
        
        IF NOT l-mostra-titulo THEN DO:
            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-grupos-de-avaliacao AS CHARACTER FORMAT "X(21)" NO-UNDO.
            {utp/ut-liter.i "Grupos_de_Avalia‡Æo" *}
            ASSIGN c-lbl-liter-grupos-de-avaliacao = TRIM(RETURN-VALUE).
            DISPLAY c-lbl-liter-grupos-de-avaliacao      AT 3 SKIP(1).
            ASSIGN l-mostra-titulo = TRUE.
        END.
        DISPLAY af-grp-avaliacao.cod-grp-avaliacao
                af-grp-avaliacao.des-grp-avaliacao
                af-grp-avaliacao.nr-versao
                af-versao-avaliacao.desc-versao
            WITH DOWN FRAME f-grupo-avaliacao.
            DOWN WITH FRAME f-grupo-avaliacao.

            IF NOT tt-param.l-ativa-desativa THEN
                ASSIGN af-grp-avaliacao.ativo = tt-param.r-ativa-desativa.
    END.
END.

/****************************************************************************************/

/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY tt-param.i-nr-versao-ini    
            tt-param.i-nr-versao-fim 
            tt-param.c-descricao-ini 
            tt-param.c-descricao-fim
            tt-param.c-familia-ini    
            tt-param.c-familia-fim 
            tt-param.c-item-ini   
            tt-param.c-item-fim 
            tt-param.c-estabelecimento-ini
            tt-param.c-estabelecimento-fim
            tt-param.i-fornecedor-ini
            tt-param.i-fornecedor-fim
            tt-param.c-grp-avaliacao-ini
            tt-param.c-grp-avaliacao-fim 
            tt-param.r-ativa-desativa
            tt-param.l-familia-fornecedor
            tt-param.l-item-fornecedor
            tt-param.l-item-estabelecimento 
            tt-param.l-grupo
            tt-param.l-ativa-desativa
            WITH  FRAME f-param-sel.

/***********************************Finalizando******************************************/

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN DO:
    DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
END.

{include/i-rpclo.i}

RETURN "OK":U.
