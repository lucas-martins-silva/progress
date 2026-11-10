/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0507RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0507.i}    

/* Definiá∆o da temp-table tt-param e tt-digita */
/*******Definiá∆o de ParÉmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp                 AS HANDLE  NO-UNDO.
DEF VAR h-boaf023               AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-ano-avaliacao AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-periodo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-ult-versao    AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-periocidade   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-titulo        AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt-af-item-contr-estab NO-UNDO LIKE af-item-contr-estab
    FIELD i-ano LIKE af-versao-avaliacao.ano-avaliacao
    FIELD i-nr-periodo LIKE af-versao-avaliacao.nr-periodo
    FIELD desc-versao LIKE af-versao-avaliacao.desc-versao
    FIELD l-ultmia-versao AS LOGICAL.

create tt-param.
raw-transfer raw-param to tt-param no-error.
create tt-digita.
/*raw-transfer raw-digita to tt-digita no-error.*/

{include~/i-rpcab.i}
{include~/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-programa 	  = "AF0507RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = "Listagem de Item X Estabelecimento Avaliaá∆o Fornecedores".

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

/***********************************Criando Objetos**************************************/
 IF NOT VALID-HANDLE(h-boaf023) THEN DO:
     RUN afbo/boaf023.p persistent set h-boaf023.
 END.
 RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
/***********************************Seleá∆o**********************************************/
FORM SKIP (2)
    "SELEÄ«O"                       AT  3 SKIP(1)
    tt-param.i-nr-versao-ini        COLON 16 "|<  >|" AT 69 tt-param.i-nr-versao-fim        NO-LABEL SKIP
    tt-param.c-descricao-ini        COLON 16 "|<  >|" AT 69 tt-param.c-descricao-fim        NO-LABEL SKIP    
    tt-param.c-item-ini             COLON 16 "|<  >|" AT 69 tt-param.c-item-fim             NO-LABEL SKIP
    tt-param.c-desc-item-ini        COLON 16 FORMAT "x(50)" "|<  >|" AT 69 tt-param.c-desc-item-fim  FORMAT "x(50)"  NO-LABEL SKIP
    tt-param.c-familia-ini          COLON 16 "|<  >|" AT 69 tt-param.c-familia-fim          NO-LABEL SKIP
    tt-param.c-cod-estab-ini        COLON 16 "|<  >|" AT 69 tt-param.c-cod-estab-fim        NO-LABEL SKIP
    tt-param.i-fornecedor-ini       COLON 16 "|<  >|" AT 69 tt-param.i-fornecedor-fim       NO-LABEL SKIP
    tt-param.c-nom-abrev-ini        COLON 16 "|<  >|" AT 69 tt-param.c-nom-abrev-fim        NO-LABEL SKIP
    SKIP(2)
    "CLASSIFICAÄ«O"             AT  3  SKIP(1)
    tt-param.desc-classifica       COLON  24 LABEL "Classificaá∆o"
    SKIP(2)                     
    "PAR∂METROS"                AT  3  SKIP(1)
    tt-param.l-relacionamento       COLON  24 LABEL "Relacionamentos" FORMAT "Sim/N∆o" 
    tt-param.l-formula              COLON  24 LABEL "F¢rmulas" FORMAT "Sim/N∆o" 
    tt-param.c-versao               COLON  24 LABEL "Vers‰es"  
            
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM Itens*/    
FORM
    tt-af-item-contr-estab.it-codigo            COLUMN-LABEL "Item"         FORMAT 'x(16)'      AT 3
    tt-af-item-contr-estab.cod-estabel          COLUMN-LABEL "Estab"        FORMAT 'x(5)'       AT 21
    tt-af-item-contr-estab.cod-emitente         COLUMN-LABEL "Fornecedor"   FORMAT '>>>>>>>>9'  AT 28
    tt-af-item-contr-estab.nr-versao            COLUMN-LABEL "Vers∆o"       FORMAT '>>>>9'      AT 40
    tt-af-item-contr-estab.desc-versao          COLUMN-LABEL "Descriá∆o"    FORMAT 'x(40)'      AT 48
    tt-af-item-contr-estab.ativo                COLUMN-LABEL "Ativo"        FORMAT 'Sim/N∆o'    AT 89

   WITH STREAM-IO DOWN NO-ATTR-SPACE WIDTH 132 FRAME f-itens.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-itens:HANDLE).


/*FORM Relacionamento*/
FORM
    tt-af-item-contr-estab.qualidade                  COLUMN-LABEL "Qual"      FORMAT 'Sim/N∆o'       AT 3
    tt-af-item-contr-estab.quantidade                 COLUMN-LABEL "Qtd"       FORMAT 'Sim/N∆o'       AT 9
    tt-af-item-contr-estab.preco                      COLUMN-LABEL "Pre"       FORMAT 'Sim/N∆o'       AT 14
    tt-af-item-contr-estab.data-entrega               COLUMN-LABEL "Dt"        FORMAT 'Sim/N∆o'       AT 19
    tt-af-item-contr-estab.log-considera-qtd-receb    COLUMN-LABEL "Var Qt"    FORMAT 'Sim/N∆o'       AT 24
    tt-af-item-contr-estab.log-considera-val-receb    COLUMN-LABEL "Val Qt"    FORMAT 'Sim/N∆o'       AT 32
    tt-af-item-contr-estab.demerito                   COLUMN-LABEL "%DemÇr"    FORMAT '>>9.99'        AT 40
    tt-af-item-contr-estab.pct-qtd-min                COLUMN-LABEL "%Qt Menor" FORMAT '>>9.99'        AT 48
    tt-af-item-contr-estab.pct-qtd-max                COLUMN-LABEL "%Qt Maior" FORMAT '>>9.99'        AT 59
    tt-af-item-contr-estab.pct-val-min                COLUMN-LABEL "%Vl Menor" FORMAT '>>9.99'        AT 70
    tt-af-item-contr-estab.pct-val-max                COLUMN-LABEL "%Vl Maior" FORMAT '>>9.99'        AT 81
    tt-af-item-contr-estab.nr-dia-min                 COLUMN-LABEL "Valor M°n" FORMAT '>>>>>9'        AT 92
    tt-af-item-contr-estab.nr-dia-max                 COLUMN-LABEL "Valor M†x" FORMAT '>>>>>9'        AT 103

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-relacionamentos.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relacionamentos:HANDLE).

/*FORM F¢rmulas*/
FORM
    af-item-contr-estab-form.seq                COLUMN-LABEL "Seq"              FORMAT '>>>>9'       AT 3
    af-item-contr-estab-form.nr-controle        COLUMN-LABEL "Nr Contr"         FORMAT '>>>>>9'      AT 10
    af-controle.descricao                       COLUMN-LABEL "Descriá∆o"        FORMAT 'x(30)'       AT 20
    af-item-contr-estab-form.percentual         COLUMN-LABEL "Perc"             FORMAT '>>9.99'      AT 52
    af-item-contr-estab-form.cod-grp-resp       COLUMN-LABEL "Grupo Resp"       FORMAT 'x(8)'        AT 59
    af-item-contr-estab-form.log-per-variavel   COLUMN-LABEL "Per Aval Var"     FORMAT 'Sim/N∆o'     AT 71
    c-periocidade                               COLUMN-LABEL "Periodicidade"    FORMAT 'x(20)'       AT 85
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-formulas.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-formulas:HANDLE).



FORM SKIP    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-skip.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-skip:HANDLE).


/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio ...").

/************************************Execuá∆o********************************************/
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Lendo_Itens_X_Estabelecimento_Fornecedores" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + "...").
FOR EACH af-item-contr-estab NO-LOCK
    WHERE af-item-contr-estab.ep-codigo = i-ep-codigo-usuario
    AND   (af-item-contr-estab.nr-versao >= tt-param.i-nr-versao-ini
    AND     af-item-contr-estab.nr-versao <= tt-param.i-nr-versao-fim)
    AND   (af-item-contr-estab.it-codigo >= tt-param.c-item-ini
    AND     af-item-contr-estab.it-codigo <=  tt-param.c-item-fim)
    AND   (af-item-contr-estab.cod-estabel >= tt-param.c-cod-estab-ini
    AND    af-item-contr-estab.cod-estabel <= tt-param.c-cod-estab-fim)
    AND   (af-item-contr-estab.cod-emitente >= tt-param.i-fornecedor-ini
    AND     af-item-contr-estab.cod-emitente <=  tt-param.i-fornecedor-fim),
        FIRST af-versao-avaliacao NO-LOCK
            WHERE   af-versao-avaliacao.nr-versao = af-item-contr-estab.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario,
        FIRST item NO-LOCK
            WHERE   item.it-codigo = af-item-contr-estab.it-codigo            
            AND     (item.desc-item >= tt-param.c-desc-item-ini
            AND      item.desc-item <= tt-param.c-desc-item-fim)
			AND		(item.fm-codigo >= tt-param.c-familia-ini
			AND		item.fm-codigo <= tt-param.c-familia-fim),
        FIRST emitente NO-LOCK
            WHERE   emitente.cod-emitente = af-item-contr-estab.cod-emitente
            AND     (emitente.nome-abrev >= tt-param.c-nom-abrev-ini
            AND     emitente.nome-abrev  <= tt-param.c-nom-abrev-fim):

    FIND FIRST tt-af-item-contr-estab NO-LOCK
        WHERE  tt-af-item-contr-estab.it-codigo = af-item-contr-estab.it-codigo
        AND    tt-af-item-contr-estab.cod-emitente = af-item-contr-estab.cod-emitente
        AND    tt-af-item-contr-estab.ep-codigo = i-ep-codigo-usuario
        AND    tt-af-item-contr-estab.l-ultmia-versao = TRUE NO-ERROR.

    /*Verifica se Existe o registro*/
    ASSIGN l-ult-versao = TRUE. 
    IF AVAIL tt-af-item-contr-estab THEN DO:
        /*Busca o Ano da vers∆o do registro corrente*/
        RUN goToKey IN h-boaf023 (INPUT af-item-contr-estab.nr-versao, INPUT i-ep-codigo-usuario).
        RUN getIntField IN h-boaf023 (INPUT 'ano-avaliacao':U, OUTPUT i-ano-avaliacao).
		RUN getIntField IN h-boaf023 (INPUT 'nr-periodo':U, OUTPUT i-nr-periodo).

        /*Se o ano do registro corrente for menor que o ano da Temp-Table continua com o mesmo.*/
        IF i-ano-avaliacao < tt-af-item-contr-estab.i-ano THEN
            ASSIGN l-ult-versao = FALSE.			        
        ELSE IF i-ano-avaliacao > tt-af-item-contr-estab.i-ano THEN
            /*Se o ano do registro corrente for maior ent∆o ele Ç o mais atual*/
            ASSIGN tt-af-item-contr-estab.l-ultmia-versao = FALSE
                    l-ult-versao = TRUE.
        ELSE DO:
            /*Se for o mesmo ano do registro corrente e o da Temp-Table ent∆o verifica os per°odos*/
            /*Se o per°odo do registro corrente for maior que o da Temp-Table ent∆o ele Ç o mais atual*/
            IF i-nr-periodo > tt-af-item-contr-estab.i-nr-periodo THEN
                    ASSIGN tt-af-item-contr-estab.l-ultmia-versao = FALSE
                            l-ult-versao = TRUE.
            ELSE
                ASSIGN l-ult-versao = FALSE.	                    
        END.		
    END.
    CREATE tt-af-item-contr-estab.
    BUFFER-COPY af-item-contr-estab TO tt-af-item-contr-estab.
    ASSIGN  tt-af-item-contr-estab.l-ultmia-versao = l-ult-versao
            tt-af-item-contr-estab.i-ano = af-versao-avaliacao.ano-avaliacao
            tt-af-item-contr-estab.i-nr-periodo = af-versao-avaliacao.nr-periodo
            tt-af-item-contr-estab.desc-versao = af-versao-avaliacao.desc-versao.
END.

/*Se foi selecionado a Opá∆o Itens X Estabelecimentos X Fornecedor' ent∆o mostra todos os registros sen∆o apenas os que 
    est∆o marcados como TRUE na Temp-Table*/
IF tt-param.i-versao = 1 THEN
   ASSIGN l-ult-versao = FALSE.
ELSE
   ASSIGN l-ult-versao = TRUE.


/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Gerando_Relat¢rios" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF tt-param.classifica = 1 THEN DO:
    /*
        Ordena por Itens, Estabelecimento e Fabricante
    */
    FOR EACH tt-af-item-contr-estab NO-LOCK
        WHERE (tt-af-item-contr-estab.l-ultmia-versao = TRUE
            OR tt-af-item-contr-estab.l-ultmia-versao = l-ult-versao)
        BY tt-af-item-contr-estab.it-codigo
        BY tt-af-item-contr-estab.cod-emitente
        BY tt-af-item-contr-estab.cod-estabel:
       
        RUN pi-disp-item (INPUT TABLE tt-af-item-contr-estab).
    END.    
END.
ELSE DO:
    /*
        Ordena por Vers∆o
    */
    FOR EACH tt-af-item-contr-estab NO-LOCK
        WHERE (tt-af-item-contr-estab.l-ultmia-versao = TRUE
            OR tt-af-item-contr-estab.l-ultmia-versao = l-ult-versao)        
        BY tt-af-item-contr-estab.nr-versao:

        RUN pi-disp-item (INPUT TABLE tt-af-item-contr-estab).
    END.
END.


PROCEDURE pi-disp-item:
    /*
    Procedure para mostrar os valores das Itens X Estabelecimento
    tt-af-item-contr-estab = Tamp-Table com os valores para preencher os dados
    */    
    DEFINE INPUT PARAMETER TABLE FOR tt-af-item-contr-estab.

    DISPLAY tt-af-item-contr-estab.it-codigo
            tt-af-item-contr-estab.cod-estabel
            tt-af-item-contr-estab.cod-emitente
            tt-af-item-contr-estab.nr-versao
            tt-af-item-contr-estab.desc-versao
            tt-af-item-contr-estab.ativo
        WITH DOWN FRAME f-itens.
        DOWN WITH FRAME f-itens.

        IF tt-param.l-relacionamento THEN DO:
            DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.
            DISPLAY tt-af-item-contr-estab.qualidade                 
                    tt-af-item-contr-estab.quantidade                
                    tt-af-item-contr-estab.preco                     
                    tt-af-item-contr-estab.data-entrega              
                    tt-af-item-contr-estab.log-considera-qtd-receb   
                    tt-af-item-contr-estab.log-considera-val-receb   
                    tt-af-item-contr-estab.demerito                  
                    tt-af-item-contr-estab.pct-qtd-min               
                    tt-af-item-contr-estab.pct-qtd-max               
                    tt-af-item-contr-estab.pct-val-min               
                    tt-af-item-contr-estab.pct-val-max               
                    tt-af-item-contr-estab.nr-dia-min                
                    tt-af-item-contr-estab.nr-dia-max
            WITH DOWN FRAME f-relacionamentos.
            DOWN WITH FRAME f-relacionamentos.
            IF NOT tt-param.l-formula THEN
               DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.
        END.
        
        /*Se Ç para mostrar as formulas ent∆o chama a procedure*/
        IF tt-param.l-formula THEN DO:            
            RUN pi-formulas (INPUT TABLE tt-af-item-contr-estab).
            DISPLAY
                WITH DOWN FRAME f-skip.
                DOWN WITH FRAME f-skip.
        END.

    RETURN "OK":U.        
END.

PROCEDURE pi-formulas:
    /*
        Procedure para mostrar as F¢rmulas por Itens X Estabelecimento X Fornecedor X Vers∆o
        tt-af-item-contr-estab = Tamp-Table com os valores para preencher os dados
    */
    DEFINE INPUT PARAMETER TABLE FOR tt-af-item-contr-estab.

        ASSIGN l-titulo = FALSE.

        FOR EACH af-item-contr-estab-form NO-LOCK            
            WHERE af-item-contr-estab-form.ep-codigo = tt-af-item-contr-estab.ep-codigo
            AND   af-item-contr-estab-form.it-codigo = tt-af-item-contr-estab.it-codigo
            AND   af-item-contr-estab-form.cod-emitente = tt-af-item-contr-estab.cod-emitente
            AND   af-item-contr-estab-form.cod-estabel  = tt-af-item-contr-estab.cod-estabel
            AND   af-item-contr-estab-form.nr-versao = tt-af-item-contr-estab.nr-versao,
                FIRST af-controle NO-LOCK
                    WHERE af-controle.ep-codigo = af-item-contr-estab-form.ep-codigo
                    AND   af-controle.nr-controle = af-item-contr-estab-form.nr-controle:

            ASSIGN c-periocidade =  {afinc/i01af017.i 04 af-item-contr-estab-form.ind-tipo-periodo}.

            IF NOT l-titulo THEN DO:
                ASSIGN l-titulo = TRUE.
                /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
                DEFINE VARIABLE c-lbl-liter-formulas AS CHARACTER FORMAT "X(10)" NO-UNDO.
                {utp/ut-liter.i "F¢rmulas" *}
                ASSIGN c-lbl-liter-formulas = TRIM(RETURN-VALUE).
                DISPLAY c-lbl-liter-formulas AT 3 SKIP(1).
            END.

            DISPLAY af-item-contr-estab-form.seq
                    af-item-contr-estab-form.nr-controle
                    af-controle.descricao
                    af-item-contr-estab-form.percentual
                    af-item-contr-estab-form.cod-grp-resp
                    af-item-contr-estab-form.log-per-variavel
                    c-periocidade
            WITH DOWN FRAME f-formulas.
            DOWN WITH FRAME f-formulas.
        END.

    RETURN "OK":U.
END.

/****************************************************************************************/

/***********************************Mostra Frames****************************************/

PAGE.
    DISPLAY tt-param.i-nr-versao-ini    
            tt-param.i-nr-versao-fim 
            tt-param.c-descricao-ini 
            tt-param.c-descricao-fim
            tt-param.c-item-ini    
            tt-param.c-item-fim 
            tt-param.c-desc-item-ini   
            tt-param.c-desc-item-fim 
            tt-param.c-familia-ini    
            tt-param.c-familia-fim
            tt-param.c-cod-estab-ini    
            tt-param.c-cod-estab-fim
            tt-param.i-fornecedor-ini
            tt-param.i-fornecedor-fim
            tt-param.c-nom-abrev-ini
            tt-param.c-nom-abrev-fim  
            tt-param.desc-classifica
            tt-param.l-relacionamento
            tt-param.l-formula
            tt-param.c-versao
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
