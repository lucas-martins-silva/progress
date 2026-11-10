/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0508RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0508.i}    

/* Definiá∆o da temp-table tt-param e tt-digita */
/*******Definiá∆o de ParÉmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp              AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-ano-avaliacao AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-periodo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-mostra-titulo AS LOGICAL INIT FALSE    NO-UNDO.
DEFINE VARIABLE l-ult-versao    AS LOGICAL              NO-UNDO.
DEFINE VARIABLE h-boaf023       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-periocidade   AS CHARACTER   NO-UNDO.


DEFINE TEMP-TABLE tt-af-grp-avaliacao NO-UNDO LIKE af-grp-avaliacao
    FIELD desc-versao LIKE af-versao-avaliacao.desc-versao
    FIELD i-ano LIKE af-versao-avaliacao.ano-avaliacao
    FIELD i-nr-periodo LIKE af-versao-avaliacao.nr-periodo
    FIELD  l-ultmia-versao AS LOGICAL.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-programa 	  = "AF0508RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = "Listagem de Grupo de Avaliaá∆o Fornecedores".

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.
IF NOT VALID-HANDLE(h-boaf023) THEN DO:
    RUN afbo/boaf023.p persistent set h-boaf023.
END.
RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.

/***********************************Seleá∆o**********************************************/
FORM SKIP (2)
    "SELEÄ«O"                       AT  3 SKIP(1)
    tt-param.i-nr-versao-ini        COLON 24 "|<  >|" AT 73 tt-param.i-nr-versao-fim        NO-LABEL SKIP
    tt-param.c-descricao-ini        COLON 24 "|<  >|" AT 73 tt-param.c-descricao-fim        NO-LABEL SKIP    
    tt-param.c-cod-grp-ini          COLON 24 "|<  >|" AT 73 tt-param.c-cod-grp-fim          NO-LABEL SKIP
    tt-param.c-desc-grp-ini         COLON 24 "|<  >|" AT 73 tt-param.c-desc-grp-fim         NO-LABEL SKIP
    
    SKIP(2)
    "CLASSIFICAÄ«O"             AT  3  SKIP(1)
    tt-param.desc-classifica       COLON  24 LABEL "Classificaá∆o"
    SKIP(2)                     
    "PAR∂METROS"                AT  3  SKIP(1)
    tt-param.l-relacionamento       COLON  24 LABEL "Relacionamentos" FORMAT "Sim/N∆o" 
    tt-param.l-formula              COLON  24 LABEL "F¢rmulas" FORMAT "Sim/N∆o"
    tt-param.crsVersao              COLON  24 LABEL "Vers∆o"
            
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM Fam°lia*/    
FORM     
    tt-af-grp-avaliacao.cod-grp-avaliacao    COLUMN-LABEL "Grupo"        FORMAT 'x(8)'      AT 3
    tt-af-grp-avaliacao.des-grp-avaliacao    COLUMN-LABEL "Descriá∆o"    FORMAT 'x(40)'     AT 13
    tt-af-grp-avaliacao.nr-versao            COLUMN-LABEL "Vers∆o"       FORMAT '>>>>9'     AT 54
    tt-af-grp-avaliacao.desc-versao          COLUMN-LABEL "Descriá∆o"    FORMAT 'x(40)'     AT 63
    tt-af-grp-avaliacao.ativo                COLUMN-LABEL "Ativo"        FORMAT 'Sim/N∆o'   AT 104

   WITH STREAM-IO DOWN NO-ATTR-SPACE WIDTH 132 FRAME f-grupo.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo:HANDLE).


/*FORM Relacionamento*/
FORM
    tt-af-grp-avaliacao.qualidade                  COLUMN-LABEL "Qual"      FORMAT 'Sim/N∆o'       AT 3
    tt-af-grp-avaliacao.quantidade                 COLUMN-LABEL "Qtd"       FORMAT 'Sim/N∆o'       AT 9
    tt-af-grp-avaliacao.preco                      COLUMN-LABEL "Pre"       FORMAT 'Sim/N∆o'       AT 14
    tt-af-grp-avaliacao.data-entrega               COLUMN-LABEL "Dt"        FORMAT 'Sim/N∆o'       AT 19
    tt-af-grp-avaliacao.log-considera-qtd-receb    COLUMN-LABEL "Var Qt"    FORMAT 'Sim/N∆o'       AT 24
    tt-af-grp-avaliacao.log-considera-val-receb    COLUMN-LABEL "Val Qt"    FORMAT 'Sim/N∆o'       AT 32
    tt-af-grp-avaliacao.demerito                   COLUMN-LABEL "%DemÇr"    FORMAT '>>9.99'        AT 40
    tt-af-grp-avaliacao.pct-qtd-min                COLUMN-LABEL "%Qt Menor" FORMAT '>>9.99'        AT 48
    tt-af-grp-avaliacao.pct-qtd-max                COLUMN-LABEL "%Qt Maior" FORMAT '>>9.99'        AT 59
    tt-af-grp-avaliacao.pct-val-min                COLUMN-LABEL "%Vl Menor" FORMAT '>>9.99'        AT 70
    tt-af-grp-avaliacao.pct-val-max                COLUMN-LABEL "%Vl Maior" FORMAT '>>9.99'        AT 81
    tt-af-grp-avaliacao.nr-dia-min                 COLUMN-LABEL "Valor M°n" FORMAT '>>>>>9'        AT 92
    tt-af-grp-avaliacao.nr-dia-max                 COLUMN-LABEL "Valor M†x" FORMAT '>>>>>9'        AT 103

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-relacionamentos.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relacionamentos:HANDLE).

/*FORM F¢rmulas*/
FORM
    af-grp-avaliacao-form.seq                COLUMN-LABEL "Seq"              FORMAT '>>>>9'       AT 3
    af-grp-avaliacao-form.nr-controle        COLUMN-LABEL "Nr Contr"         FORMAT '>>>>>9'      AT 10
    af-controle.descricao                    COLUMN-LABEL "Descriá∆o"        FORMAT 'x(30)'       AT 20
    af-grp-avaliacao-form.percentual         COLUMN-LABEL "Perc"             FORMAT '>>9.99'      AT 52
    af-grp-avaliacao-form.cod-grp-resp       COLUMN-LABEL "Grupo Resp"       FORMAT 'x(8)'        AT 59
    af-grp-avaliacao-form.log-per-variavel   COLUMN-LABEL "Per Aval Var"     FORMAT 'Sim/N∆o'     AT 71
    c-periocidade                            COLUMN-LABEL "Periodicidade"    FORMAT 'x(20)'       AT 85
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-formulas.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-formulas:HANDLE).



/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio ...").

/************************************Execuá∆o********************************************/
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Lendo_Listagem_de_Grupo_de_Avaliaá∆o_de_Fornecedores" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + "...").

FOR EACH af-grp-avaliacao NO-LOCK
    WHERE af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario
    AND   (af-grp-avaliacao.nr-versao >= tt-param.i-nr-versao-ini
    AND     af-grp-avaliacao.nr-versao <= tt-param.i-nr-versao-fim)
    AND   (af-grp-avaliacao.cod-grp-avaliacao >= tt-param.c-cod-grp-ini
    AND     af-grp-avaliacao.cod-grp-avaliacao <=  tt-param.c-cod-grp-fim)
    AND   (af-grp-avaliacao.des-grp-avaliacao >= tt-param.c-desc-grp-ini
    AND    af-grp-avaliacao.des-grp-avaliacao <= tt-param.c-desc-grp-fim),
        FIRST af-versao-avaliacao NO-LOCK
            WHERE   af-versao-avaliacao.nr-versao = af-grp-avaliacao.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario:

    /*Verifica se Existe o registro*/
    ASSIGN l-ult-versao = TRUE.
    FIND FIRST tt-af-grp-avaliacao NO-LOCK
        WHERE  tt-af-grp-avaliacao.cod-grp-avaliacao = af-grp-avaliacao.cod-grp-avaliacao
        AND    tt-af-grp-avaliacao.ep-codigo         = i-ep-codigo-usuario
        AND    tt-af-grp-avaliacao.l-ultmia-versao   = TRUE NO-ERROR.

    IF AVAIL tt-af-grp-avaliacao THEN DO:    
        /*Busca o Ano da vers∆o do registro corrente*/
        RUN goToKey IN h-boaf023 (INPUT af-versao-avaliacao.nr-versao, INPUT i-ep-codigo-usuario).
        RUN getIntField IN h-boaf023 (INPUT 'ano-avaliacao':U, OUTPUT i-ano-avaliacao).
    	RUN getIntField IN h-boaf023 (INPUT 'nr-periodo':U, OUTPUT i-nr-periodo).
    
        /*Se o ano do registro corrente for menor que o ano da Temp-Table continua com o mesmo.*/
        IF i-ano-avaliacao < tt-af-grp-avaliacao.i-ano THEN
            ASSIGN l-ult-versao = FALSE.			        
        ELSE IF i-ano-avaliacao > tt-af-grp-avaliacao.i-ano THEN
            /*Se o ano do registro corrente for maior ent∆o ele Ç o mais atual*/
            ASSIGN tt-af-grp-avaliacao.l-ultmia-versao = FALSE
                    l-ult-versao = TRUE.
        ELSE DO:
            /*Se for o mesmo ano do registro corrente e o da Temp-Table ent∆o verifica os per°odos*/
            /*Se o per°odo do registro corrente for maior que o da Temp-Table ent∆o ele Ç o mais atual*/
            IF i-nr-periodo > tt-af-grp-avaliacao.i-nr-periodo THEN
                    ASSIGN tt-af-grp-avaliacao.l-ultmia-versao = FALSE
                            l-ult-versao = TRUE.
            ELSE
                ASSIGN l-ult-versao = FALSE.	                    
        END.
    END.

    CREATE tt-af-grp-avaliacao.
    BUFFER-COPY af-grp-avaliacao TO tt-af-grp-avaliacao.
    ASSIGN  tt-af-grp-avaliacao.desc-versao     = af-versao-avaliacao.desc-versao
            tt-af-grp-avaliacao.i-ano           = af-versao-avaliacao.ano-avaliacao
            tt-af-grp-avaliacao.i-nr-periodo    = af-versao-avaliacao.nr-periodo
            tt-af-grp-avaliacao.l-ultmia-versao = l-ult-versao.   
END.

IF tt-param.rsVersao = 1 THEN
   ASSIGN l-ult-versao = FALSE.
ELSE
   ASSIGN l-ult-versao = TRUE.

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Gerando_Relat¢rios" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF tt-param.classifica = 1 THEN DO:
    /*
        Ordena por Fam°lia e Fabricante
    */
    FOR EACH tt-af-grp-avaliacao NO-LOCK
        WHERE (tt-af-grp-avaliacao.l-ultmia-versao  = TRUE
               OR tt-af-grp-avaliacao.l-ultmia-versao = l-ult-versao)
        BY tt-af-grp-avaliacao.cod-grp-avaliacao:        
       
        RUN pi-disp-grupo (INPUT TABLE tt-af-grp-avaliacao).
    END.    
END.
ELSE DO:
    /*
        Ordena por Vers∆o
    */
    FOR EACH tt-af-grp-avaliacao NO-LOCK
        WHERE (tt-af-grp-avaliacao.l-ultmia-versao  = TRUE
               OR tt-af-grp-avaliacao.l-ultmia-versao = l-ult-versao)
        BY tt-af-grp-avaliacao.nr-versao:

        RUN pi-disp-grupo (INPUT TABLE tt-af-grp-avaliacao).
    END.
END.


PROCEDURE pi-disp-grupo:
    /*
    Procedure para mostrar os valores dos Grupos
    tt-af-grp-avaliacao = Tamp-Table com os valores para preencher os dados
    */    
    DEFINE INPUT PARAMETER TABLE FOR tt-af-grp-avaliacao.

    DISPLAY tt-af-grp-avaliacao.cod-grp-avaliacao
            tt-af-grp-avaliacao.des-grp-avaliacao
            tt-af-grp-avaliacao.nr-versao
            tt-af-grp-avaliacao.desc-versao
            tt-af-grp-avaliacao.ativo
        WITH DOWN FRAME f-grupo.
        DOWN WITH FRAME f-grupo.

        IF tt-param.l-relacionamento THEN DO:           
            DISPLAY SKIP.
            DISPLAY tt-af-grp-avaliacao.qualidade                 
                    tt-af-grp-avaliacao.quantidade                
                    tt-af-grp-avaliacao.preco                     
                    tt-af-grp-avaliacao.data-entrega              
                    tt-af-grp-avaliacao.log-considera-qtd-receb   
                    tt-af-grp-avaliacao.log-considera-val-receb   
                    tt-af-grp-avaliacao.demerito                  
                    tt-af-grp-avaliacao.pct-qtd-min               
                    tt-af-grp-avaliacao.pct-qtd-max               
                    tt-af-grp-avaliacao.pct-val-min               
                    tt-af-grp-avaliacao.pct-val-max               
                    tt-af-grp-avaliacao.nr-dia-min                
                    tt-af-grp-avaliacao.nr-dia-max
            WITH DOWN FRAME f-relacionamentos.
            DOWN WITH FRAME f-relacionamentos.

            IF NOT tt-param.l-formula THEN
                DISPLAY SKIP.
        END.
        
        /*Se Ç para mostrar as formulas ent∆o chama a procedure*/
        IF tt-param.l-formula THEN DO:            
            RUN pi-formulas (INPUT TABLE tt-af-grp-avaliacao).            
        END.

    RETURN "OK":U.        
END.

PROCEDURE pi-formulas:
    /*
        Procedure para mostrar as F¢rmulas por Grupo Avaliaá∆o X Fornecedor
        tt-af-grp-avaliacao = Tamp-Table com os valores para preencher os dados
    */
    DEFINE INPUT PARAMETER TABLE FOR tt-af-grp-avaliacao.       

        ASSIGN l-mostra-titulo = FALSE.

        FOR EACH af-grp-avaliacao-form NO-LOCK
            WHERE af-grp-avaliacao-form.ep-codigo            = tt-af-grp-avaliacao.ep-codigo
            AND   af-grp-avaliacao-form.cod-grp-avaliacao    = tt-af-grp-avaliacao.cod-grp-avaliacao
            AND   af-grp-avaliacao-form.nr-versao            = tt-af-grp-avaliacao.nr-versao,
                FIRST af-controle NO-LOCK
                    WHERE af-controle.ep-codigo     = af-grp-avaliacao-form.ep-codigo
                    AND   af-controle.nr-controle   = af-grp-avaliacao-form.nr-controle:

            IF NOT l-mostra-titulo THEN DO:
                ASSIGN l-mostra-titulo = TRUE.
                /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
                DEFINE VARIABLE c-lbl-liter-formulas AS CHARACTER FORMAT "X(10)" NO-UNDO.
                {utp/ut-liter.i "F¢rmulas" *}
                ASSIGN c-lbl-liter-formulas = TRIM(RETURN-VALUE).
                DISPLAY c-lbl-liter-formulas AT 3 SKIP(1).
            END.            
            
            ASSIGN c-periocidade = {afinc/i01af017.i 04 af-grp-avaliacao-form.ind-tipo-periodo}.

            DISPLAY af-grp-avaliacao-form.seq              
                    af-grp-avaliacao-form.nr-controle      
                    af-controle.descricao                  
                    af-grp-avaliacao-form.percentual       
                    af-grp-avaliacao-form.cod-grp-resp     
                    af-grp-avaliacao-form.log-per-variavel 
                    c-periocidade
            WITH DOWN FRAME f-formulas.
            DOWN WITH FRAME f-formulas.
        END.

        IF l-mostra-titulo THEN
            DISPLAY "".

    RETURN "OK":U.
END.

/****************************************************************************************/

/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY tt-param.i-nr-versao-ini    
            tt-param.i-nr-versao-fim 
            tt-param.c-descricao-ini 
            tt-param.c-descricao-fim
            tt-param.c-cod-grp-ini
            tt-param.c-cod-grp-fim
            tt-param.c-desc-grp-ini   
            tt-param.c-desc-grp-fim 
            tt-param.desc-classifica
            tt-param.l-relacionamento
            tt-param.l-formula
            tt-param.crsVersao
            WITH  FRAME f-param-sel.


/***********************************Finalizando******************************************/

RUN pi-finalizar IN h-acomp.

IF (VALID-HANDLE(h-boaf023)
    AND h-boaf023:type = "PROCEDURE":U 
    AND h-boaf023:file-name = "afbo/boaf023.p":U ) THEN DO:
    DELETE PROCEDURE h-boaf023.
    ASSIGN h-boaf023 = ?.
END.

IF VALID-HANDLE(h-acomp) THEN DO:
    DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
END.

{include/i-rpclo.i}

RETURN "OK":U.
