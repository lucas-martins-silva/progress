/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0505RP 2.00.00.002 } /*** 010002 ***/
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
{afp/af0505.i}    

/* Definiá∆o da temp-table tt-param e tt-digita */
/*******Definiá∆o de ParÉmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR h-acomp                 AS HANDLE               NO-UNDO.
DEF VAR h-boaf023               AS HANDLE               NO-UNDO.
DEFINE VARIABLE i-ano-avaliacao AS INTEGER              NO-UNDO.
DEFINE VARIABLE i-nr-periodo    AS INTEGER              NO-UNDO.
DEFINE VARIABLE l-ult-versao    AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-mostra-titulo AS LOGICAL INIT FALSE   NO-UNDO.
DEFINE VARIABLE c-periocidade   AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-af-familia-contr NO-UNDO LIKE af-familia-contr
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

ASSIGN c-programa 	  = "AF0505RP"
       c-versao	      = "1.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = "Listagem de Fam°lia Avaliaá∆o Fornecedores".

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
    tt-param.i-nr-versao-ini        COLON 24 "|<  >|" AT 73 tt-param.i-nr-versao-fim        NO-LABEL SKIP
    tt-param.c-descricao-ini        COLON 24 "|<  >|" AT 73 tt-param.c-descricao-fim        NO-LABEL SKIP
    tt-param.c-familia-ini          COLON 24 "|<  >|" AT 73 tt-param.c-familia-fim          NO-LABEL SKIP
    tt-param.c-desc-fam-ini         COLON 24 "|<  >|" AT 73 tt-param.c-desc-fam-fim         NO-LABEL SKIP
    tt-param.i-fornecedor-ini       COLON 24 "|<  >|" AT 73 tt-param.i-fornecedor-fim       NO-LABEL SKIP
    tt-param.c-nom-abrev-ini        COLON 24 "|<  >|" AT 73 tt-param.c-nom-abrev-fim        NO-LABEL SKIP
    SKIP(2)
    "CLASSIFICAÄ«O"             AT  3  SKIP(1)
    tt-param.desc-classifica       COLON  33 LABEL "Detalhamento"
    SKIP(2)                     
    "PAR∂METROS"                AT  3  SKIP(1)
    tt-param.l-relacionamento       COLON  33 LABEL "Informaá‰es do relacionamento" FORMAT "Sim/N∆o"
    tt-param.l-formula              COLON  33 LABEL "Informaá‰es das f¢rmulas"      FORMAT "Sim/N∆o"
    tt-param.c-versao               COLON  33 LABEL "Vers‰es"
            
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

/****************************************************************************************/
/********************************Frames**************************************************/
/*FORM Fam°lia*/    
FORM     
    tt-af-familia-contr.fm-codigo            COLUMN-LABEL "Fam°lia"      FORMAT 'x(8)'       AT 3
    tt-af-familia-contr.cod-emitente         COLUMN-LABEL "Fornecedor"   FORMAT '>>>>>>>>9'  AT 12
    tt-af-familia-contr.nr-versao            COLUMN-LABEL "Vers∆o"       FORMAT '>>>>9'      AT 23
    tt-af-familia-contr.desc-versao          COLUMN-LABEL "Descriá∆o"    FORMAT 'x(40)'      AT 30
    tt-af-familia-contr.ativo                COLUMN-LABEL "Ativo"        FORMAT 'Sim/N∆o'    AT 71

   WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-familias.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-familias:HANDLE).


/*FORM Relacionamento*/
FORM
    tt-af-familia-contr.qualidade                  COLUMN-LABEL "Qual"      FORMAT 'Sim/N∆o'       AT 3
    tt-af-familia-contr.quantidade                 COLUMN-LABEL "Qtd"       FORMAT 'Sim/N∆o'       AT 9
    tt-af-familia-contr.preco                      COLUMN-LABEL "Pre"       FORMAT 'Sim/N∆o'       AT 14
    tt-af-familia-contr.data-entrega               COLUMN-LABEL "Dt"        FORMAT 'Sim/N∆o'       AT 19
    tt-af-familia-contr.log-considera-qtd-receb    COLUMN-LABEL "Var Qt"    FORMAT 'Sim/N∆o'       AT 24
    tt-af-familia-contr.log-considera-val-receb    COLUMN-LABEL "Val Qt"    FORMAT 'Sim/N∆o'       AT 32
    tt-af-familia-contr.demerito                   COLUMN-LABEL "%DemÇr"    FORMAT '>>9.99'        AT 40
    tt-af-familia-contr.pct-qtd-min                COLUMN-LABEL "%Qt Menor" FORMAT '>>9.99'        AT 48
    tt-af-familia-contr.pct-qtd-max                COLUMN-LABEL "%Qt Maior" FORMAT '>>9.99'        AT 59
    tt-af-familia-contr.pct-val-min                COLUMN-LABEL "%Vl Menor" FORMAT '>>9.99'        AT 70
    tt-af-familia-contr.pct-val-max                COLUMN-LABEL "%Vl Maior" FORMAT '>>9.99'        AT 81
    tt-af-familia-contr.nr-dia-min                 COLUMN-LABEL "Valor M°n" FORMAT '>>>>>9'        AT 92
    tt-af-familia-contr.nr-dia-max                 COLUMN-LABEL "Valor M†x" FORMAT '>>>>>9'        AT 103

    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-relacionamentos.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-relacionamentos:HANDLE).

/*FORM F¢rmulas*/
FORM
    af-familia-contr-form.seq                COLUMN-LABEL "Seq"              FORMAT '>>>>9'       AT 3
    af-familia-contr-form.nr-controle        COLUMN-LABEL "Nr Contr"         FORMAT '>>>>>9'      AT 10
    af-controle.descricao                    COLUMN-LABEL "Descriá∆o"        FORMAT 'x(30)'       AT 20
    af-familia-contr-form.percentual         COLUMN-LABEL "Perc"             FORMAT '>>9.99'      AT 52
    af-familia-contr-form.cod-grp-resp       COLUMN-LABEL "Grupo Resp"       FORMAT 'x(8)'        AT 59
    af-familia-contr-form.log-per-variavel   COLUMN-LABEL "Per Aval Var"     FORMAT 'Sim/N∆o'     AT 71
    c-periocidade                            COLUMN-LABEL "Periodicidade"    FORMAT 'x(20)'       AT 85
    
    WITH STREAM-IO DOWN NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-formulas.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-formulas:HANDLE).



/****************************************************************************************/


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio ...").

/************************************Execuá∆o********************************************/
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Lendo_Fam°lia_X_Fornecedores" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + "...").

FOR EACH af-familia-contr NO-LOCK
    WHERE af-familia-contr.ep-codigo = i-ep-codigo-usuario
    AND   (af-familia-contr.nr-versao >= tt-param.i-nr-versao-ini
    AND     af-familia-contr.nr-versao <= tt-param.i-nr-versao-fim)
    AND   (af-familia-contr.fm-codigo >= tt-param.c-familia-ini
    AND     af-familia-contr.fm-codigo <=  tt-param.c-familia-fim)
    AND   (af-familia-contr.cod-emitente >= tt-param.i-fornecedor-ini
    AND     af-familia-contr.cod-emitente <=  tt-param.i-fornecedor-fim),
        FIRST af-versao-avaliacao NO-LOCK
            WHERE   af-versao-avaliacao.nr-versao = af-familia-contr.nr-versao
            AND     (af-versao-avaliacao.desc-versao >= tt-param.c-descricao-ini
            AND     af-versao-avaliacao.desc-versao <= tt-param.c-descricao-fim)
            AND     af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario,
        FIRST familia NO-LOCK
            WHERE   familia.fm-codigo = af-familia-contr.fm-codigo
            AND     (familia.descricao >= tt-param.c-desc-fam-ini
            AND      familia.descricao <= tt-param.c-desc-fam-fim),            
        FIRST emitente NO-LOCK
            WHERE   emitente.cod-emitente = af-familia-contr.cod-emitente
            AND     (emitente.nome-abrev >= tt-param.c-nom-abrev-ini
            AND     emitente.nome-abrev  <= tt-param.c-nom-abrev-fim):

    FIND FIRST tt-af-familia-contr NO-LOCK
        WHERE  tt-af-familia-contr.fm-codigo = af-familia-contr.fm-codigo
        AND    tt-af-familia-contr.cod-emitente = af-familia-contr.cod-emitente
        AND    tt-af-familia-contr.ep-codigo = i-ep-codigo-usuario
        AND    tt-af-familia-contr.l-ultmia-versao = TRUE NO-ERROR.

    /*Verifica se Existe o registro*/
    ASSIGN l-ult-versao = TRUE.
    IF AVAIL tt-af-familia-contr THEN DO:
        /*Busca o Ano da vers∆o do registro corrente*/
        RUN goToKey IN h-boaf023 (INPUT af-familia-contr.nr-versao, INPUT i-ep-codigo-usuario).
        RUN getIntField IN h-boaf023 (INPUT 'ano-avaliacao':U, OUTPUT i-ano-avaliacao).
		RUN getIntField IN h-boaf023 (INPUT 'nr-periodo':U, OUTPUT i-nr-periodo).

        /*Se o ano do registro corrente for menor que o ano da Temp-Table continua com o mesmo.*/
        IF i-ano-avaliacao < tt-af-familia-contr.i-ano THEN
            ASSIGN l-ult-versao = FALSE.			        
        ELSE IF i-ano-avaliacao > tt-af-familia-contr.i-ano THEN
            /*Se o ano do registro corrente for maior ent∆o ele Ç o mais atual*/
            ASSIGN tt-af-familia-contr.l-ultmia-versao = FALSE
                    l-ult-versao = TRUE.
        ELSE DO:
            /*Se for o mesmo ano do registro corrente e o da Temp-Table ent∆o verifica os per°odos*/
            /*Se o per°odo do registro corrente for maior que o da Temp-Table ent∆o ele Ç o mais atual*/
            IF i-nr-periodo > tt-af-familia-contr.i-nr-periodo THEN
                    ASSIGN tt-af-familia-contr.l-ultmia-versao = FALSE
                            l-ult-versao = TRUE.
            ELSE
                ASSIGN l-ult-versao = FALSE.	                    
        END.
    END.

    CREATE tt-af-familia-contr.
    BUFFER-COPY af-familia-contr TO tt-af-familia-contr.
    ASSIGN  tt-af-familia-contr.l-ultmia-versao = l-ult-versao
            tt-af-familia-contr.i-ano = af-versao-avaliacao.ano-avaliacao
            tt-af-familia-contr.i-nr-periodo = af-versao-avaliacao.nr-periodo
            tt-af-familia-contr.desc-versao = af-versao-avaliacao.desc-versao.
END.

/*Se foi selecionado a Opá∆o 'Fam°lia X Fornecedor' ent∆o mostra todos os registros sen∆o apenas os que 
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
        Ordena por Fam°lia e Fabricante
    */
    FOR EACH tt-af-familia-contr NO-LOCK
    WHERE (tt-af-familia-contr.l-ultmia-versao = TRUE
            OR tt-af-familia-contr.l-ultmia-versao = l-ult-versao)
        BY tt-af-familia-contr.fm-codigo
        BY tt-af-familia-contr.cod-emitente:

        RUN pi-disp-familia (INPUT TABLE tt-af-familia-contr).
    END.    
END.
ELSE DO:
    /*
        Ordena por Vers∆o
    */
    FOR EACH tt-af-familia-contr NO-LOCK
    WHERE (tt-af-familia-contr.l-ultmia-versao = TRUE
            OR tt-af-familia-contr.l-ultmia-versao = l-ult-versao)        
        BY tt-af-familia-contr.nr-versao:

        RUN pi-disp-familia (INPUT TABLE tt-af-familia-contr).
    END.
END.


PROCEDURE pi-disp-familia:
    /*
    Procedure para mostrar os valores das fam°lias
    tt-af-familia-contr = Tamp-Table com os valores para preencher os dados
    */    
    DEFINE INPUT PARAMETER TABLE FOR tt-af-familia-contr.

    DISPLAY tt-af-familia-contr.fm-codigo
            tt-af-familia-contr.cod-emitente
            tt-af-familia-contr.nr-versao
            tt-af-familia-contr.desc-versao
            tt-af-familia-contr.ativo
        WITH DOWN FRAME f-familias.
        DOWN WITH FRAME f-familias.

        IF tt-param.l-relacionamento THEN DO:
            DISPLAY "".
            DISPLAY tt-af-familia-contr.qualidade                 
                    tt-af-familia-contr.quantidade                
                    tt-af-familia-contr.preco                     
                    tt-af-familia-contr.data-entrega              
                    tt-af-familia-contr.log-considera-qtd-receb   
                    tt-af-familia-contr.log-considera-val-receb   
                    tt-af-familia-contr.demerito                  
                    tt-af-familia-contr.pct-qtd-min               
                    tt-af-familia-contr.pct-qtd-max               
                    tt-af-familia-contr.pct-val-min               
                    tt-af-familia-contr.pct-val-max               
                    tt-af-familia-contr.nr-dia-min                
                    tt-af-familia-contr.nr-dia-max
            WITH DOWN FRAME f-relacionamentos.
            DOWN WITH FRAME f-relacionamentos.

            IF NOT tt-param.l-formula THEN
                DISPLAY "" SKIP.
        END.
        
        /*Se Ç para mostrar as formulas ent∆o chama a procedure*/
        IF tt-param.l-formula THEN DO:        
            RUN pi-formulas (INPUT TABLE tt-af-familia-contr).
            DISPLAY "" SKIP.
        END.
    RETURN "OK":U.        
END.

PROCEDURE pi-formulas:
    /*
        Procedure para mostrar as F¢rmulas por Fam°lia X Fornecedor X Vers∆o
        tt-af-familia-contr = Tamp-Table com os valores para preencher os dados
    */
    DEFINE INPUT PARAMETER TABLE FOR tt-af-familia-contr.

        ASSIGN l-mostra-titulo = FALSE.

        FOR EACH af-familia-contr-form NO-LOCK
            WHERE af-familia-contr-form.ep-codigo = tt-af-familia-contr.ep-codigo
            AND   af-familia-contr-form.fm-codigo = tt-af-familia-contr.fm-codigo
            AND   af-familia-contr-form.cod-emitente = tt-af-familia-contr.cod-emitente
            AND   af-familia-contr-form.nr-versao = tt-af-familia-contr.nr-versao,
                FIRST af-controle NO-LOCK
                    WHERE af-controle.ep-codigo = af-familia-contr-form.ep-codigo
                    AND   af-controle.nr-controle = af-familia-contr-form.nr-controle:

            
            IF NOT l-mostra-titulo THEN DO:
                DISPLAY "" SKIP.
                /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
                DEFINE VARIABLE c-lbl-liter-formulas AS CHARACTER FORMAT "X(10)" NO-UNDO.
                {utp/ut-liter.i "F¢rmulas" *}
                ASSIGN c-lbl-liter-formulas = TRIM(RETURN-VALUE).
                DISPLAY c-lbl-liter-formulas AT 3 SKIP(1).
                ASSIGN l-mostra-titulo = TRUE.
            END.

            ASSIGN c-periocidade =  {afinc/i01af017.i 04 af-familia-contr-form.ind-tipo-periodo}. 

            DISPLAY af-familia-contr-form.seq              
                    af-familia-contr-form.nr-controle      
                    af-controle.descricao                  
                    af-familia-contr-form.percentual       
                    af-familia-contr-form.cod-grp-resp     
                    af-familia-contr-form.log-per-variavel 
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
            tt-param.c-familia-ini    
            tt-param.c-familia-fim 
            tt-param.c-desc-fam-ini   
            tt-param.c-desc-fam-fim 
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
