/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0303RP 2.00.00.036 } /*** "010036" 14/03/2025 10:36:29  ***/
{include/i_fnctrad.i}
/*****************************************************************************
**       PROGRAMA: af0303
**       DATA....: Mar‡o de 2004    
**       OBJETIVO: C lculo dos ¡ndices 
**       VERSAO..: 2.00.00.000 - Alan Koerbel
**                 2.00.00.001 - Vinicio Silveira
******************************************************************************/
{utp/ut-glob.i}
{cdp/cdcfgmat.i} 
{cdp/cd0666.i}
{afp/af0303.i} 
{afbo/boaf016.i1}
 
DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita      AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DISABLE TRIGGERS FOR LOAD OF af-contr-indice-mov.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{afp/af0303.i2}

{cdp/cdapi020b.i " " "new shared"}

DEF TEMP-TABLE tt-af-var NO-UNDO         
    FIELD cod-variavel          LIKE af-variavel.cod-variavel 
    FIELD descricao             LIKE af-variavel.descricao 
    FIELD padrao                LIKE af-variavel.padrao 
    FIELD log-especifico        LIKE af-variavel.log-especifico 
    FIELD programa              LIKE af-variavel.programa
    FIELD valor                 AS DECIMAL FORMAT ">>>,>>>,>>9.999999999"
    FIELD narrativa             LIKE af-variavel.narrativa
    INDEX padrao padrao
    INDEX variavel cod-variavel.
    
DEF TEMP-TABLE tt-af-var-aux NO-UNDO
    FIELD nr-controle           LIKE af-controle.nr-controle
    FIELD cod-variavel          LIKE af-variavel.cod-variavel 
    FIELD descricao             LIKE af-variavel.descricao 
    FIELD padrao                LIKE af-variavel.padrao 
    FIELD log-especifico        LIKE af-variavel.log-especifico 
    FIELD programa              LIKE af-variavel.programa
    FIELD valor                 AS DECIMAL FORMAT ">>>,>>>,>>9.999999999"
    FIELD narrativa             LIKE af-variavel.narrativa
    FIELD nr-versao             LIKE af-formula.nr-versao
    INDEX controle nr-controle nr-versao
    INDEX variavel cod-variavel nr-controle nr-versao.

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO LIKE tt-versao-data.

{include/i-rpvar.i}

DEF VAR h-acomp          AS HANDLE     NO-UNDO.
DEF VAR i-ano            AS INT        NO-UNDO.
DEF VAR i-mes            AS INT        NO-UNDO.
DEF VAR i-mes-ini        AS INT        NO-UNDO.
DEF VAR da-dt-indice     AS DATE       NO-UNDO.
DEF VAR de-nota          AS DEC        NO-UNDO.
DEF VAR de-valor         AS DEC        NO-UNDO.
DEF VAR l-movto          AS LOG        NO-UNDO.
DEF VAR da-data          AS DATE       NO-UNDO.
DEF VAR da-data-ini      AS DATE       NO-UNDO.
DEF VAR da-data-fim      AS DATE       NO-UNDO.
DEF VAR da-per-ini       AS DATE       NO-UNDO.
DEF VAR da-per-fim       AS DATE       NO-UNDO.
DEF VAR c-narrativa      AS CHAR       NO-UNDO.
DEF VAR i-pedido         LIKE ordem-compra.num-pedido NO-UNDO.
DEF VAR i-ficha          LIKE rat-lote.nr-ficha       NO-UNDO.
DEF VAR i-ind-tipo       AS INT        NO-UNDO.

DEF VAR de-qtd-min       AS DEC        NO-UNDO.
DEF VAR de-qtd-max       AS DEC        NO-UNDO.
DEF VAR de-val-min       AS DEC        NO-UNDO.
DEF VAR de-val-max       AS DEC        NO-UNDO.
DEF VAR de-tot-rec       AS DEC        NO-UNDO.
DEF VAR de-tot-cq-apr    AS DEC        NO-UNDO.
DEF VAR de-tot-cq-con    AS DEC        NO-UNDO.
DEF VAR de-tot-cq-rej    AS DEC        NO-UNDO.
DEF VAR de-tot-cq-per    AS DEC        NO-UNDO.
DEF VAR de-tot-dev-cq    AS DEC        NO-UNDO.
DEF VAR de-tot-dev       AS DEC        NO-UNDO.

DEF VAR de-var-pct-qtd   AS DEC        NO-UNDO.
DEF VAR de-var-lim-qtd   AS DEC        NO-UNDO.
DEF VAR de-var-pct-pre   AS DEC        NO-UNDO.
DEF VAR de-var-lim-pre   AS DEC        NO-UNDO.

DEF VAR p-quant-erro     AS DEC        NO-UNDO.

DEF VAR l-erro           AS LOG               NO-UNDO.
DEF VAR l-devol-cq       AS LOG  INIT NO      NO-UNDO.
DEF VAR l-receb-cq       AS LOG  INIT NO      NO-UNDO.
DEF VAR l-qualid-re      AS LOG  INIT NO      NO-UNDO.
DEF VAR l-qualid-ft      AS LOG  INIT NO      NO-UNDO.
DEF VAR l-fechado        AS LOG  INIT NO      NO-UNDO.
DEF VAR l-var-qualidade  AS LOG  INIT NO      NO-UNDO.
DEF VAR l-var-preco      AS LOG  INIT NO      NO-UNDO.
DEF VAR l-var-data       AS LOG  INIT NO      NO-UNDO.
DEF VAR l-var-quantidade AS LOG  INIT NO      NO-UNDO.


DEF VAR i-nr-ver-atual   AS INTEGER           NO-UNDO.

DEF VAR h-boaf008        AS HANDLE     NO-UNDO.
DEF VAR h-boaf013        AS HANDLE     NO-UNDO.
DEF VAR h-boaf023        AS HANDLE     NO-UNDO.
DEF VAR h-boaf006        AS HANDLE     NO-UNDO.
DEF VAR h-boaf010        AS HANDLE     NO-UNDO.

DEF VAR i-tempo          AS INT EXTENT 20 NO-UNDO.
DEF VAR i-ult-tempo      AS INT EXTENT 20 NO-UNDO.
DEF VAR i-tempo-ini      AS INT NO-UNDO.

DEF VAR c-formula        LIKE af-formula.expressao NO-UNDO.
ASSIGN i-tempo-ini = TIME.

DEF VAR h-cdapi020b      AS HANDLE NO-UNDO.
DEF VAR h-boaf016        AS HANDLE NO-UNDO.
DEF VAR de-preco-unit    LIKE ordem-compra.preco-unit NO-UNDO.

DEF VAR i-nr-versao      AS INT  NO-UNDO.
DEF VAR i-menor-versao   AS INT  NO-UNDO.
DEF VAR i-versao-formula LIKE af-formula.nr-versao NO-UNDO.

DEF VAR c-periodo-aux    AS CHAR NO-UNDO.

DEF VAR c-lb-item         AS CHAR NO-UNDO.
{utp/ut-liter.i Item * r}
ASSIGN c-lb-item = " " + TRIM(RETURN-VALUE) + ": ".
DEF VAR c-lb-estab        AS CHAR NO-UNDO.
{utp/ut-liter.i Estabelecimento * r}
ASSIGN c-lb-estab = " " + TRIM(RETURN-VALUE) + ": ".
DEF VAR c-lb-fornec       AS CHAR NO-UNDO.
{utp/ut-liter.i Fornecedor * r}
ASSIGN c-lb-fornec = " " + TRIM(RETURN-VALUE) + ": ".
DEF VAR c-lb-mes          AS CHAR NO-UNDO.
{utp/ut-liter.i Mˆs * r}
ASSIGN c-lb-mes = TRIM(RETURN-VALUE) + ": ".
DEF VAR c-lb-lista-erros  AS CHAR NO-UNDO.
{utp/ut-liter.i Lista_de_erros * r}
ASSIGN c-lb-lista-erros = TRIM(RETURN-VALUE) + ": ".
DEF VAR c-lb-impressao    AS CHAR NO-UNDO.
{utp/ut-liter.i ImpressÆo * r}
ASSIGN c-lb-impressao = TRIM(RETURN-VALUE).
DEF VAR c-lb-arquivo      AS CHAR NO-UNDO.
{utp/ut-liter.i Arquivo * r}
ASSIGN c-lb-arquivo = TRIM(RETURN-VALUE).
DEF VAR c-lb-usuario      AS CHAR NO-UNDO.
{utp/ut-liter.i Usu rio * r}
ASSIGN c-lb-usuario = TRIM(RETURN-VALUE).

DEF VAR c-lb-elim-indices      AS CHAR NO-UNDO.
{utp/ut-liter.i Elimina‡Æo_¡ndices * r}
ASSIGN c-lb-elim-indices = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-elim-indic-var      AS CHAR NO-UNDO.
{utp/ut-liter.i Elimina‡Æo_¡ndices_vari veis * r}
ASSIGN c-lb-elim-indic-var = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-grav-detalhes      AS CHAR NO-UNDO.
{utp/ut-liter.i Grava‡Æo_de_detalhes * r}
ASSIGN c-lb-grav-detalhes = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-grav-notas      AS CHAR NO-UNDO.
{utp/ut-liter.i Grava‡Æo_de_notas * r}
ASSIGN c-lb-grav-notas = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-calc-qualid      AS CHAR NO-UNDO.
{utp/ut-liter.i Calculando_Qualidade * r}
ASSIGN c-lb-calc-qualid = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-calc-quant      AS CHAR NO-UNDO.
{utp/ut-liter.i Calculando_Quant_Preco_Data * r}
ASSIGN c-lb-calc-quant = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-criac-movim      AS CHAR NO-UNDO.
{utp/ut-liter.i Cria‡Æo_movimentos * r}
ASSIGN c-lb-criac-movim = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-busca-movim      AS CHAR NO-UNDO.
{utp/ut-liter.i Busca_de_movimentos * r}
ASSIGN c-lb-busca-movim = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-variac-quant      AS CHAR NO-UNDO.
{utp/ut-liter.i Varia‡Æo_Quantidade * r}
ASSIGN c-lb-variac-quant = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-variac-preco      AS CHAR NO-UNDO.
{utp/ut-liter.i Varia‡Æo_Pre‡o * r}
ASSIGN c-lb-variac-preco = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-faixa-demer      AS CHAR NO-UNDO.
{utp/ut-liter.i Faixa_Demerito * r}
ASSIGN c-lb-faixa-demer = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-pt-formula      AS CHAR NO-UNDO.
{utp/ut-liter.i Ponto_F¢rmula * r}
ASSIGN c-lb-pt-formula = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-cria-var      AS CHAR NO-UNDO.
{utp/ut-liter.i Cria_Vari vel * r}
ASSIGN c-lb-cria-var = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-calc-formula      AS CHAR NO-UNDO.
{utp/ut-liter.i Calcula_F¢rmula * r}
ASSIGN c-lb-calc-formula = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-calc-espec      AS CHAR NO-UNDO.
{utp/ut-liter.i Calcula_Espec¡fico * r}
ASSIGN c-lb-calc-espec = " " + TRIM(RETURN-VALUE).
DEF VAR c-lb-temp-tot      AS CHAR NO-UNDO.
{utp/ut-liter.i Tempo_Total * r}
ASSIGN c-lb-temp-tot = " " + TRIM(RETURN-VALUE).

/* Pontos de controle padrÆo ------------------------------------------*/
 DEFINE VARIABLE l-quant              AS LOGICAL        NO-UNDO.
 DEFINE VARIABLE l-preco              AS LOGICAL        NO-UNDO.
 DEFINE VARIABLE l-data               AS LOGICAL        NO-UNDO.
 DEFINE VARIABLE l-qualidade          AS LOGICAL        NO-UNDO.
 DEFINE VARIABLE i-nr-qualidade       AS INTEGER        NO-UNDO.
 DEFINE VARIABLE i-nr-quant           AS INTEGER        NO-UNDO.
 DEFINE VARIABLE i-nr-preco           AS INTEGER        NO-UNDO.
 DEFINE VARIABLE i-nr-data            AS INTEGER        NO-UNDO.
 DEFINE VARIABLE i-for-qualidade      LIKE af-formula.cod-formula NO-UNDO.
 DEFINE VARIABLE i-for-quant          LIKE af-formula.cod-formula NO-UNDO.
 DEFINE VARIABLE i-for-preco          LIKE af-formula.cod-formula NO-UNDO.
 DEFINE VARIABLE i-for-data           LIKE af-formula.cod-formula NO-UNDO.
 DEFINE VARIABLE de-perc-quali        AS DECIMAL        NO-UNDO.
 DEFINE VARIABLE de-perc-quant        AS DECIMAL        NO-UNDO.
 DEFINE VARIABLE de-perc-preco        AS DECIMAL        NO-UNDO.
 DEFINE VARIABLE de-perc-data         AS DECIMAL        NO-UNDO.
 DEF VAR l-padrao AS LOG NO-UNDO.
/*-----------------------------------------------------------------------*/

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param-af NO-LOCK
     WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.

IF NOT VALID-HANDLE(h-boaf008) THEN
   RUN afbo/boaf008.p PERSISTENT SET h-boaf008.
IF NOT VALID-HANDLE(h-boaf013) THEN
   RUN afbo/boaf013.p PERSISTENT SET h-boaf013.
IF NOT VALID-HANDLE(h-boaf023) THEN
   RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
IF NOT VALID-HANDLE(h-boaf006) THEN
   RUN afbo/boaf006.p PERSISTENT SET h-boaf006.

IF  NOT VALID-HANDLE(h-cdapi020b) THEN
    RUN cdp/cdapi020b.p PERSISTENT SET h-cdapi020b (INPUT-OUTPUT TABLE tt-formula,
                                                    INPUT-OUTPUT TABLE tt-erro,
                                                    NO).

{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-programa 	  = "AF0303RP":U
       c-versao       = "2.00"
       c-revisao      = ".00.002"
       c-sistema      = "AFP":U
       c-titulo-relat = "C lculo Öndices".

FIND empresa WHERE empresa.ep-codigo   = i-ep-codigo-usuario NO-LOCK NO-ERROR.
IF AVAIL empresa THEN ASSIGN c-empresa = empresa.razao-social.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Iniciando_calculo *}
RUN pi-inicializar IN h-acomp (INPUT  RETURN-VALUE ).

ASSIGN i-nr-ver-atual = 0.


IF AVAIL param-af THEN DO:
    /*busca tt-versao-data*/
  
    IF param-af.log-usa-versao THEN DO:


        RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                              OUTPUT TABLE tt-versao-data).

        
       /*QuANDo o controle for por uma £nica versÆo, ela ser  considerada na busca dos registros do AF0105 para melhorar a performance */

       
        IF param-af.i-tipo-validade-versao = 2 THEN DO:
        
             
             ASSIGN c-periodo-aux = STRING(MONTH(da-data-fim)) + "/" + STRING(YEAR(da-data-fim)).

             RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT c-periodo-aux,
                                                     INPUT i-ep-codigo-usuario,
                                                     OUTPUT i-nr-ver-atual).

        END.

    END.
    
    IF NOT param-af.log-usa-versao OR 
       (param-af.log-usa-versao AND (NOT param-af.log-versao-demerito OR NOT param-af.log-versao-formula)) THEN DO:
    
        RUN pi-retorna-meNOr-versao IN h-boaf023 (OUTPUT i-menor-versao).
    END.
END.

EMPTY TEMP-TABLE tt-erro.

EMPTY TEMP-TABLE tt-dt-periodo-aval.
RUN afbo/boaf016.p PERSISTENT SET h-boaf016.
RUN retornaPeriodosFaixa IN h-boaf016 (INPUT tt-param.i-ano-ini, 
                                       INPUT tt-param.c-des-per-ini,
                                       INPUT tt-param.i-ano-fim,
                                       INPUT tt-param.c-des-per-fim,
                                       OUTPUT TABLE tt-dt-periodo-aval).

FIND FIRST tt-dt-periodo-aval NO-ERROR.
IF AVAIL tt-dt-periodo-aval 
   THEN ASSIGN da-per-ini = tt-dt-periodo-aval.dt-periodo-ini.
   ELSE RETURN.

FIND LAST tt-dt-periodo-aval NO-ERROR.
IF AVAIL tt-dt-periodo-aval 
   THEN ASSIGN da-per-fim = tt-dt-periodo-aval.dt-periodo-fim.
   ELSE RETURN.
  
/* Carrega a tt-var-aux com todos os pontos de controle */
EMPTY TEMP-TABLE tt-var.
EMPTY TEMP-TABLE tt-af-var-aux.

FOR EACH af-controle
    WHERE af-controle.log-formula = YES
      AND af-controle.ep-codigo = i-ep-codigo-usuario NO-LOCK:

    IF af-controle.nr-controle = 1 THEN DO:
       ASSIGN i-nr-qualidade  = af-controle.nr-controle
              i-for-qualidade = af-controle.cod-formula.
    END.
    ELSE IF af-controle.nr-controle = 2 THEN DO:
       ASSIGN i-nr-quant    = af-controle.nr-controle
              i-for-quant   = af-controle.cod-formula.
    END.
    ELSE IF af-controle.nr-controle = 3 THEN DO:
         
       ASSIGN i-nr-preco    = af-controle.nr-controle
              i-for-preco   = af-controle.cod-formula.

    END.
    ELSE IF af-controle.nr-controle = 4 THEN DO:
       ASSIGN i-nr-data    = af-controle.nr-controle
              i-for-data   = af-controle.cod-formula.

    END.

    /* Preenche com todas as vari veis de todas as versäes*/
    RUN pi-carrega-tt-var-aux (INPUT af-controle.nr-controle). 

END.


IF i-nr-ver-atual <> 0 THEN DO:

    FOR EACH af-item-contr-estab
       WHERE af-item-contr-estab.ep-codigo          = i-ep-codigo-usuario
         AND af-item-contr-estab.ativo              = YES
         AND af-item-contr-estab.cod-estabel       >= TRIM(tt-param.c-est-ini) 
         AND af-item-contr-estab.cod-estabel       <= TRIM(tt-param.c-est-fim)
         AND af-item-contr-estab.cod-emitente      >= tt-param.i-emi-ini
         AND af-item-contr-estab.cod-emitente      <= tt-param.i-emi-fim
         AND af-item-contr-estab.nr-versao          = i-nr-ver-atual 
         AND af-item-contr-estab.it-codigo         >= TRIM(c-it-ini)
         AND af-item-contr-estab.it-codigo         <= TRIM(c-it-fim) NO-LOCK
        BREAK BY af-item-contr-estab.ep-codigo
              BY af-item-contr-estab.cod-estabel
              BY af-item-contr-estab.cod-emitente
              BY af-item-contr-estab.it-codigo:
        
            {afp/af0303.i3} 
    END.
END.
ELSE DO:



    FOR EACH af-item-contr-estab
       WHERE af-item-contr-estab.ep-codigo          = i-ep-codigo-usuario
         AND af-item-contr-estab.ativo              = YES
         AND af-item-contr-estab.cod-estabel       >= TRIM(tt-param.c-est-ini) 
         AND af-item-contr-estab.cod-estabel       <= TRIM(tt-param.c-est-fim)
         AND af-item-contr-estab.cod-emitente      >= tt-param.i-emi-ini
         AND af-item-contr-estab.cod-emitente      <= tt-param.i-emi-fim
         AND af-item-contr-estab.it-codigo         >= TRIM(c-it-ini)
         AND af-item-contr-estab.it-codigo         <= TRIM(c-it-fim) NO-LOCK
       BREAK BY af-item-contr-estab.ep-codigo
             BY af-item-contr-estab.cod-estabel
             BY af-item-contr-estab.cod-emitente
             BY af-item-contr-estab.it-codigo:
    
        {afp/af0303.i3} 

    END.
END.

IF CAN-FIND(FIRST tt-erro) THEN
   DISP c-lb-lista-erros SKIP(1)
   WITH STREAM-IO DOWN WIDTH 132 NO-BOX FRAME f-cab-erro.

FOR EACH tt-erro:
    DISP tt-erro.cd-erro  COLUMN-LABEL "C¢digo"
         tt-erro.mensagem COLUMN-LABEL "Mensagem" FORMAT "x(120)" 
         WITH STREAM-IO DOWN WIDTH 132 NO-BOX FRAME f-erro.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).
    
    DOWN WITH FRAME f-erro.
END.

IF CAN-FIND(FIRST tt-erro) THEN
   /* Projeto Internacional -- Traducao de DISPLAY. Validar e verIFicar possibilidade de colocar em FRAME */
   DO:
   DEFINE VARIABLE c-lbl-liter-em-funcao-dos-erros-reportados AS CHARACTER FORMAT "X(103)" NO-UNDO.
   {utp/ut-liter.i "Em_fun‡Æo_dos_erros_reportados_acima_o_calculo_do_¡ndice_dos_pontos_de_controle_pode_estar_incorreto" *}
   ASSIGN c-lbl-liter-em-funcao-dos-erros-reportados = TRIM(RETURN-VALUE).
   DEFINE VARIABLE c-lbl-liter-os-erros-deverao-ser-corrigido AS CHARACTER FORMAT "X(77)" NO-UNDO.
   {utp/ut-liter.i "Os_erros_deverÆo_ser_corrigidos_e_o_calculo_dever _ser_executado_novamente" *}
   ASSIGN c-lbl-liter-os-erros-deverao-ser-corrigido = TRIM(RETURN-VALUE).
   DISP SKIP(2) 
        c-lbl-liter-em-funcao-dos-erros-reportados + "." FORMAT "X(103)"
        SKIP(1)
        c-lbl-liter-os-erros-deverao-ser-corrigido + "." FORMAT "X(77)"
        SKIP(2) 
   WITH STREAM-IO DOWN WIDTH 132 NO-BOX FRAME f-rod-erro.
   END. 
ELSE 
   /* Projeto Internacional -- Traducao de DISPLAY. Validar e verIFicar possibilidade de colocar em FRAME */
   DO:
   DEFINE VARIABLE c-lbl-liter-calculo-executado-com-sucesso AS CHARACTER FORMAT "X(32)" NO-UNDO.
   {utp/ut-liter.i "Calculo_executado_com_sucesso" *}
   ASSIGN c-lbl-liter-calculo-executado-com-sucesso = TRIM(RETURN-VALUE).
   DEFINE VARIABLE c-lbl-liter-o-resultado-do-calculo-podera AS CHARACTER FORMAT "X(113)" NO-UNDO.
   {utp/ut-liter.i "O_resultado_do_c lculo_poder _ser_consultado_atrav‚s_do_programa_AF0601-_Consulta_dos_Öndices_dos_Fornecedores" *}
   ASSIGN c-lbl-liter-o-resultado-do-calculo-podera = TRIM(RETURN-VALUE).
   DISP SKIP(2)
        c-lbl-liter-calculo-executado-com-sucesso + "!" FORMAT "X(32)" SKIP(1)
        c-lbl-liter-o-resultado-do-calculo-podera + "." FORMAT "X(113)"
        SKIP(2)
        WITH STREAM-IO DOWN WIDTH 132 NO-BOX FRAME f-cab-ok.
   END. 

EMPTY TEMP-TABLE tt-erro.

PAGE.
DISPLAY tt-param.c-est-ini    
        tt-param.c-est-fim 
        tt-param.i-emi-ini 
        tt-param.i-emi-fim
        tt-param.c-it-ini    
        tt-param.c-it-fim 
        tt-param.i-ano-ini  
        tt-param.i-ano-fim
        tt-param.c-des-per-ini
        tt-param.c-des-per-fim
        tt-param.i-cod-gr-forn-ini 
        tt-param.i-cod-gr-forn-fim
        tt-param.c-fm-codigo-ini
        tt-param.c-fm-codigo-fim
        tt-param.i-ge-codigo-ini 
        tt-param.i-ge-codigo-fim 

        tt-param.l-qualidade
        tt-param.l-quantidade
        tt-param.l-preco
        tt-param.l-data-entrega
        tt-param.l-especifico
        tt-param.i-nr-controle-ini
        tt-param.i-nr-controle-fim
        WITH  FRAME f-param-sel.

&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                    INPUT "",
                    INPUT "").
ASSIGN c-destino = RETURN-VALUE.
&ELSE
ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.
&endIF
ASSIGN 
       c-arquivo = tt-param.arquivo.

PUT UNFORMATTED SKIP(2)
    c-lb-impressao  AT 3 skip(1)
    c-lb-arquivo    AT 17 ": " c-destino " - " c-arquivo
    c-lb-usuario    AT 17 ": " tt-param.usuario.

PUT SKIP(2)
    c-lb-elim-indices   FORMAT "x(28)" ": " STRING(i-tempo[1],"hh:mm:ss") SKIP
    c-lb-elim-indic-var FORMAT "x(28)" ": " STRING(i-tempo[2],"hh:mm:ss") SKIP 
    c-lb-grav-detalhes  FORMAT "x(28)" ": " STRING(i-tempo[3],"hh:mm:ss") SKIP
    c-lb-grav-notas     FORMAT "x(28)" ": " STRING(i-tempo[4],"hh:mm:ss") SKIP
    c-lb-calc-qualid    FORMAT "x(28)" ": " STRING(i-tempo[5],"hh:mm:ss") SKIP
    c-lb-calc-quant     FORMAT "x(28)" ": " STRING(i-tempo[6] - i-tempo[17] - i-tempo[18],"hh:mm:ss") SKIP
    c-lb-criac-movim    FORMAT "x(28)" ": " STRING(i-tempo[17],"hh:mm:ss") SKIP 
    c-lb-busca-movim    FORMAT "x(28)" ": " STRING(i-tempo[18],"hh:mm:ss") SKIP 
    c-lb-variac-quant   FORMAT "x(28)" ": " STRING(i-tempo[9],"hh:mm:ss") SKIP
    c-lb-variac-preco   FORMAT "x(28)" ": " STRING(i-tempo[10],"hh:mm:ss") SKIP
    c-lb-faixa-demer    FORMAT "x(28)" ": " STRING(i-tempo[11],"hh:mm:ss") SKIP
    c-lb-pt-formula     FORMAT "x(28)" ": " STRING(i-tempo[12],"hh:mm:ss") SKIP
    c-lb-cria-var       FORMAT "x(28)" ": " STRING(i-tempo[13],"hh:mm:ss") SKIP
    c-lb-calc-formula   FORMAT "x(28)" ": " STRING(i-tempo[15],"hh:mm:ss") SKIP
    c-lb-calc-espec     FORMAT "x(28)" ": " STRING(i-tempo[16],"hh:mm:ss") SKIP(1)
    c-lb-temp-tot       FORMAT "x(28)" ": " STRING(TIME - i-tempo-ini, "hh:mm:ss").

{include/i-rpclo.i} /* &STREAM="stream str-rp"*/
RUN pi-finalizar IN h-acomp.


IF VALID-HANDLE(h-boaf008) THEN DO:
   DELETE PROCEDURE h-boaf008.
   ASSIGN h-boaf008 = ?.
END.

IF VALID-HANDLE(h-boaf013) THEN DO:
   DELETE PROCEDURE h-boaf013.
   ASSIGN h-boaf013 = ?.
END.

IF VALID-HANDLE(h-boaf023) THEN DO:
   DELETE PROCEDURE h-boaf023.
   ASSIGN h-boaf023 = ?.
END.

IF VALID-HANDLE(h-boaf006) THEN DO:
   DELETE PROCEDURE h-boaf006.
   ASSIGN h-boaf006 = ?.
END.

IF VALID-HANDLE(h-boaf016) THEN DO:
   DELETE PROCEDURE h-boaf016.
   ASSIGN h-boaf016 = ?.
END.

IF  VALID-HANDLE(h-cdapi020b) THEN DO:
    delete PROCEDURE h-cdapi020b.
    ASSIGN h-cdapi020b = ?.
END.

IF VALID-HANDLE(h-boaf010) THEN DO:
    DELETE PROCEDURE h-boaf010.
    ASSIGN h-boaf010 = ?.
END.

RETURN "OK":U.

/* C lculos de todos os tipos de ponto de controle */
PROCEDURE pi-calcula-pontos:
    RUN validaPeriodoFechado IN h-boaf016 (INPUT  da-data-fim,
                                           INPUT  TABLE tt-dt-periodo-aval,
                                           OUTPUT l-fechado).

    IF l-fechado THEN NEXT.

    RUN pi-cria-variavel.

    RUN pi-acompanhar IN h-acomp (INPUT c-lb-mes + STRING(i-mes,"99") + "/" + STRING(i-ano,"9999")).

    /* Qualidade - Quantidade - Pre‡o - Data de Entrega */
    IF l-padrao THEN
        RUN pi-calcula-ponto-padrao.

    IF tt-param.l-especifico THEN DO:
        FOR EACH af-controle WHERE 
                 af-controle.ep-codigo       = af-item-contr-estab.ep-codigo AND
                 af-controle.log-especifico  = YES                           AND 
                 af-controle.nr-controle    >= i-nr-controle-ini             AND 
                 af-controle.nr-controle    <= i-nr-controle-fim             NO-LOCK:
                 
            IF NOT af-controle.padrao THEN DO:
                FOR EACH af-item-contr-estab-form  WHERE 
                         af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo    AND 
                         af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel  AND 
                         af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente AND 
                         af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo    AND 
                         af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao    AND
                         af-item-contr-estab-form.nr-controle  = af-controle.nr-controle NO-LOCK:
                    RUN pi-programa-especIFico.
                END.
            END.
        END.
    END.
                    
    IF tt-param.l-utiliza-formula THEN DO:

       FOR EACH af-controle WHERE 
                af-controle.ep-codigo      = af-item-contr-estab.ep-codigo AND
                af-controle.cod-formula    > 0 NO-LOCK:
            
            IF af-controle.nr-controle < i-nr-controle-ini OR
               af-controle.nr-controle > i-nr-controle-fim THEN NEXT.
              
            IF NOT af-controle.padrao AND af-controle.log-formula THEN DO:
                FOR EACH af-item-contr-estab-form  WHERE 
                         af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo    AND 
                         af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel  AND 
                         af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente AND 
                         af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo    AND 
                         af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao    AND
                         af-item-contr-estab-form.nr-controle  = af-controle.nr-controle NO-LOCK:

                    RUN pi-ponto-formula.
                END.
            END.
       END.
    END.                         

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-elimina-indices:
    ASSIGN i-ult-tempo[1] = TIME.
    
    FOR EACH af-controle NO-LOCK
        WHERE af-controle.ep-codigo = af-item-contr-estab.ep-codigo:
        IF (tt-param.l-qualidade      AND af-controle.nr-controle = 1)  
            THEN RUN pi-elimina-mov.
        ELSE IF (tt-param.l-quantidade   AND af-controle.nr-controle = 2)
            THEN RUN pi-elimina-mov.
        ELSE IF (tt-param.l-preco        AND af-controle.nr-controle = 3)      
            THEN RUN pi-elimina-mov.
        ELSE IF (tt-param.l-data-entrega AND af-controle.nr-controle = 4) 
            THEN RUN pi-elimina-mov.
        ELSE IF (tt-param.l-especifico AND af-controle.log-especifico) AND 
             (af-controle.nr-controle >= i-nr-controle-ini AND af-controle.nr-controle <= i-nr-controle-fim) 
            THEN RUN pi-elimina-mov.
        ELSE IF (tt-param.l-utiliza-formula AND af-controle.log-formula) AND
             (af-controle.nr-controle >= i-nr-controle-ini AND af-controle.nr-controle <= i-nr-controle-fim) 
            THEN RUN pi-elimina-mov.
    END.

    ASSIGN i-tempo[1] = i-tempo[1] + TIME - i-ult-tempo[1].

END PROCEDURE.

PROCEDURE pi-elimina-mov:
    FOR EACH af-contr-indice
           WHERE af-contr-indice.ep-codigo     = i-ep-codigo-usuario
             AND af-contr-indice.cod-emitente  = af-item-contr-estab.cod-emitente
             AND af-contr-indice.it-codigo     = TRIM(af-item-contr-estab.it-codigo)
             AND af-contr-indice.cod-estabel   = TRIM(af-item-contr-estab.cod-estabel)
             AND af-contr-indice.dt-indice    >= da-per-ini
             AND af-contr-indice.dt-indice    <= da-per-fim
             AND af-contr-indice.nr-controle   = af-controle.nr-controle
             EXCLUSIVE-LOCK:
            DELETE af-contr-indice.
    END.
    FOR EACH af-contr-indice-mov
       WHERE af-contr-indice-mov.ep-codigo     = i-ep-codigo-usuario
         AND af-contr-indice-mov.nr-controle   = af-controle.nr-controle  
         AND af-contr-indice-mov.dt-indice    >= da-per-ini
         AND af-contr-indice-mov.dt-indice    <= da-per-fim
         AND af-contr-indice-mov.it-codigo     = TRIM(af-item-contr-estab.it-codigo)
         AND af-contr-indice-mov.cod-emitente  = af-item-contr-estab.cod-emitente
         AND af-contr-indice-mov.cod-estabel   = TRIM(af-item-contr-estab.cod-estabel)
         EXCLUSIVE-LOCK:
         DELETE af-contr-indice-mov.
    END.
END PROCEDURE.


PROCEDURE pi-grava-nota:
    
    DEF INPUT PARAM p-nr-controle LIKE af-contr-indice.nr-controle NO-UNDO.
    DEF INPUT PARAM p-cod-formula LIKE af-controle.cod-formula NO-UNDO.
    DEF INPUT PARAM p-narrativa   LIKE af-contr-indice.narrativa NO-UNDO.
    DEF INPUT PARAM p-padrao      LIKE af-controle.padrao NO-UNDO.
    DEF INPUT PARAM p-percentual  LIKE af-item-contr-estab-form.percentual NO-UNDO.
    DEF INPUT PARAM p-nr-versao   LIKE af-formula.nr-versao NO-UNDO.

    DEFINE VARIABLE l-possui-valor AS LOGICAL INIT NO NO-UNDO.

    DEFINE BUFFER bf2-tt-af-var FOR tt-af-var.
    
    ASSIGN i-ult-tempo[4] = TIME.

    IF p-padrao THEN
       IF NOT CAN-FIND (FIRST af-contr-indice-mov 
                        WHERE af-contr-indice-mov.ep-codigo    = i-ep-codigo-usuario 
                        AND   af-contr-indice-mov.nr-controle  = p-nr-controle
                        AND   af-contr-indice-mov.dt-indice    = da-dt-indice
                        AND   af-contr-indice-mov.it-codigo    = TRIM(af-item-contr-estab.it-codigo)
                        AND   af-contr-indice-mov.cod-emitente = af-item-contr-estab.cod-emitente
                        AND   af-contr-indice-mov.cod-estabel  = TRIM(af-item-contr-estab.cod-estabel)) THEN RETURN.

    /* Ponto com f¢rmula est  gravANDo registro sem ter nota fiscal */
    IF  p-nr-controle > 4
    AND p-cod-formula > 0
    AND p-padrao      = NO THEN DO:

        FOR EACH tt-af-var:
            IF tt-af-var.valor <> 0 THEN DO:
                ASSIGN l-possui-valor = YES.
                LEAVE.
            END.
        END.

        IF NOT l-possui-valor THEN
            RETURN.
    END.

    FIND af-contr-indice 
         WHERE af-contr-indice.ep-codigo    = i-ep-codigo-usuario 
         AND   af-contr-indice.nr-controle  = p-nr-controle
         AND   af-contr-indice.dt-indice    = da-dt-indice
         AND   af-contr-indice.it-codigo    = TRIM(af-item-contr-estab.it-codigo)
         AND   af-contr-indice.cod-emitente = af-item-contr-estab.cod-emitente   
         AND   af-contr-indice.cod-estabel  = TRIM(af-item-contr-estab.cod-estabel) 
         EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL af-contr-indice THEN DO:
        CREATE af-contr-indice.
        ASSIGN af-contr-indice.ep-codigo      = i-ep-codigo-usuario
               af-contr-indice.cod-emitente   = af-item-contr-estab.cod-emitente
               af-contr-indice.nr-versao      = af-item-contr-estab.nr-versao
               af-contr-indice.cod-estabel    = af-item-contr-estab.cod-estabel
               af-contr-indice.it-codigo      = af-item-contr-estab.it-codigo 
               af-contr-indice.nr-controle    = p-nr-controle
               af-contr-indice.dt-indice      = da-dt-indice
               af-contr-indice.dt-implantacao = TODAY.
    END.

    ASSIGN af-contr-indice.indice                  = de-nota
           af-contr-indice.cod-formula             = p-cod-formula
           af-contr-indice.nr-versao-cod-formula   = i-nr-versao
           af-contr-indice.dt-alter                = TODAY
           af-contr-indice.hora-alter              = STRING(time,"hh:mm:ss")
           af-contr-indice.usuar-alter             = c-seg-usuario
           af-contr-indice.narrativa               = p-narrativa
           af-contr-indice.percentual              = p-percentual
           af-contr-indice.nota                    = ROUND(af-contr-indice.indice * p-percentual / 100,2)
           af-contr-indice.demerito                = af-item-contr-estab.demerito
           af-contr-indice.pct-qtd-min             = af-item-contr-estab.pct-qtd-min
           af-contr-indice.pct-qtd-max             = af-item-contr-estab.pct-qtd-max
           af-contr-indice.log-considera-qtd-receb = af-item-contr-estab.log-considera-qtd-receb
           af-contr-indice.pct-val-min             = af-item-contr-estab.pct-val-min
           af-contr-indice.pct-val-max             = af-item-contr-estab.pct-val-max
           af-contr-indice.log-considera-val-receb = af-item-contr-estab.log-considera-val-receb
           af-contr-indice.nr-dia-min              = af-item-contr-estab.nr-dia-min
           af-contr-indice.nr-dia-max              = af-item-contr-estab.nr-dia-max
           af-contr-indice.nr-versao               = af-item-contr-estab.nr-versao.

    IF p-cod-formula > 0  THEN DO:
       FOR FIRST af-formula FIELDS(expressao cod-formula nr-versao)
           WHERE af-formula.ep-codigo = i-ep-codigo-usuario
           AND   af-formula.cod-formula = p-cod-formula 
           AND   af-formula.nr-versao   = p-nr-versao NO-LOCK: END.
       IF AVAIL af-formula THEN
           ASSIGN af-contr-indice.expressao = af-formula.expressao
                  af-contr-indice.narrativa = af-contr-indice.narrativa + "~r~n" + "~r~n" +
                  "F¢rmula: " + STRING(af-formula.cod-formula) + " - " + STRING(TRIM(af-formula.expressao)).
    END.

    ASSIGN i-tempo[4] = i-tempo[4] + TIME - i-ult-tempo[4].
    
   RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-calcula-qualidade:
    ASSIGN i-ult-tempo[5] = TIME.

    DEF VAR i-nr-ficha-cq   AS INT  INIT 0      NO-UNDO.
    DEF VAR i-nfe           AS INT  INIT 0      NO-UNDO.
    DEF VAR i-nfd-cq        AS INT  INIT 0      NO-UNDO.
    DEF VAR i-nfd           AS INT  INIT 0      NO-UNDO.


    DEF VAR de-qt-cq-apr   AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-cq-con   AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-cq-rej   AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-cq-per   AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-dev-cq   AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-rec      AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-qt-dev      AS DEC   INIT 0      NO-UNDO.
    DEF VAR de-indice-param   LIKE af-contr-indice.indice    NO-UNDO.
    DEF VAR c-narrativa-param LIKE af-contr-indice.narrativa NO-UNDO.

    /* Total Recebido Aprovado e Total Recebido Aprov. Condicional */
    IF l-receb-cq OR l-var-qualidade THEN DO:
        FOR FIRST docum-est FIELDS(ce-atual serie-docto nro-docto cod-emitente nat-operacao dt-trans)
           WHERE docum-est.serie-docto  = recebimento.serie-docto  
             AND docum-est.nro-docto    = recebimento.numero-nota   
             AND docum-est.cod-emitente = recebimento.cod-emitente 
             AND docum-est.nat-operacao = recebimento.nat-operacao NO-LOCK: END.

        IF docum-est.ce-atual THEN DO:

             FOR EACH item-doc-est FIELDS(nr-ficha quantidade serie-docto nro-docto nat-operacao it-codigo
                                          sequencia numero-ordem parcela num-pedido cod-emitente)
                WHERE item-doc-est.serie-docto  = docum-est.serie-docto
                  AND item-doc-est.nro-docto    = docum-est.nro-docto
                  AND item-doc-est.cod-emitente = docum-est.cod-emitente
                  AND item-doc-est.nat-operacao = docum-est.nat-operacao  NO-LOCK:

                 IF item-doc-est.it-codigo <> TRIM(af-item-contr-estab.it-codigo) THEN NEXT.

                  /* Procura exce‡Æo exata */
                  IF CAN-FIND(FIRST af-excecao 
                              WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                              AND   af-excecao.ind-tipo-doc = 2
                              AND   af-excecao.serie-docto  = item-doc-est.serie-docto
                              AND   af-excecao.nro-docto    = item-doc-est.nro-docto
                              AND   af-excecao.cod-emitente = item-doc-est.cod-emitente
                              AND   af-excecao.nat-operacao = item-doc-est.nat-operacao
                              AND   af-excecao.sequencia    = item-doc-est.sequencia) THEN NEXT.

                  /* Procura exce‡Æo gen‚rica, para todo documento */
                  IF CAN-FIND(FIRST af-excecao 
                              WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                              AND   af-excecao.ind-tipo-doc = 2
                              AND   af-excecao.serie-docto  = item-doc-est.serie-docto
                              AND   af-excecao.nro-docto    = item-doc-est.nro-docto
                              AND   af-excecao.cod-emitente = item-doc-est.cod-emitente
                              AND   af-excecao.nat-operacao = item-doc-est.nat-operacao
                              AND   af-excecao.sequencia    = 0) THEN NEXT.

                  /* Procura exce‡Æo pedido/ordem/parcela */
                  IF item-doc-est.num-pedido <> 0 THEN DO:
                      RUN pi-excecao-pedido (INPUT item-doc-est.num-pedido,
                                             INPUT item-doc-est.numero-ordem,
                                             INPUT item-doc-est.parcela).
                      IF RETURN-VALUE = "NOK" THEN NEXT.
                  END.

                  FOR EACH rat-lote FIELDS(nr-ficha quantidade serie-docto nro-docto nat-operacao sequencia lote)
                      WHERE rat-lote.serie-docto   = docum-est.serie-docto
                        AND rat-lote.nro-docto     = docum-est.nro-docto
                        AND rat-lote.cod-emitente  = docum-est.cod-emitente
                        AND rat-lote.nat-operacao  = docum-est.nat-operacao
                        AND rat-lote.sequencia     = item-doc-est.sequencia
                        /*AND rat-lote.it-codigo     = TRIM(af-item-contr-estab.it-codigo)*/ NO-LOCK:

                        ASSIGN  i-ficha       = 0
                                de-qt-rec     = 0
                                de-qt-cq-apr  = 0
                                de-qt-cq-con  = 0
                                de-qt-cq-rej  = 0
                                de-qt-cq-per  = 0.
                        
                        IF rat-lote.nr-ficha = 0 THEN
                           ASSIGN de-tot-rec    = de-tot-rec + rat-lote.quantidade
                                  de-qt-rec     = rat-lote.quantidade.
                        ELSE DO:
                            FOR FIRST ficha-cq FIELDS(nr-ficha inspecionado qt-aprovada qt-apr-cond qt-rejeitada qt-consumida)
                                WHERE ficha-cq.nr-ficha = rat-lote.nr-ficha
                                NO-LOCK: END.
                            IF AVAIL ficha-cq AND ficha-cq.inspecionado THEN DO:   

                               /* Procura exce‡Æo */
                               IF CAN-FIND(FIRST af-excecao 
                                           WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                                           AND   af-excecao.ind-tipo-doc = 3
                                           AND   af-excecao.nr-ficha     = ficha-cq.nr-ficha)THEN NEXT.
                               
                               ASSIGN de-tot-cq-apr = de-tot-cq-apr + ficha-cq.qt-aprovada
                                      de-tot-cq-con = de-tot-cq-con + ficha-cq.qt-apr-cond
                                      de-tot-cq-rej = de-tot-cq-rej + ficha-cq.qt-rejeitada
                                      de-tot-cq-per = de-tot-cq-per + ficha-cq.qt-consumida
                                      de-tot-rec    = de-tot-rec + rat-lote.quantidade
                                      de-qt-rec     = rat-lote.quantidade
                                      de-qt-cq-apr  = ficha-cq.qt-aprovada
                                      de-qt-cq-con  = ficha-cq.qt-apr-cond
                                      de-qt-cq-rej  = ficha-cq.qt-rejeitada
                                      de-qt-cq-per  = ficha-cq.qt-consumida
                                      i-nr-ficha-cq = i-nr-ficha-cq + 1
                                      i-ficha       = rat-lote.nr-ficha.
                            END.
                            ELSE
                               ASSIGN de-tot-rec = de-tot-rec + rat-lote.quantidade
                                      de-qt-rec  = rat-lote.quantidade.
                        END. 

                        RUN pi-grava-detalhe (INPUT i-nr-qualidade,               /* Nr Controle      */
                                              INPUT 1,                            /* Tipo Transa‡Æo   */
                                              INPUT item-doc-est.serie-docto,     /* S‚rie documento  */
                                              INPUT item-doc-est.nro-docto,       /* Nro Documento    */
                                              INPUT item-doc-est.nat-operacao,    /* Nat Opera‡Æo     */
                                              INPUT item-doc-est.sequencia,       /* Sequencia Item   */
                                              INPUT rat-lote.lote,                /* Lote             */
                                              INPUT docum-est.dt-trans,           /* Data Movto       */
                                              INPUT de-qt-cq-apr,                 /* Qtd Aprovada     */
                                              INPUT de-qt-cq-con,                 /* Qtd Aprov. Cond. */
                                              INPUT de-qt-cq-rej,                 /* Qtd Rejeitada    */
                                              INPUT de-qt-cq-per,                 /* Qtd Perda        */
                                              INPUT de-qt-rec,                    /* Qtd Recebida     */
                                              INPUT 0,                            /* Qtd Devolvida    */
                                              INPUT 0,                            /* Qtd Devol sem CQ */
                                              INPUT i-ficha,                      /* Nr Ficha CQ      */
                                              INPUT af-item-contr-estab.demerito, /* Dem‚rito         */
                                              INPUT item-doc-est.num-pedido,      /* Pedido Compra    */
                                              INPUT item-doc-est.numero-ordem,    /* Ordem de Compra  */
                                              INPUT item-doc-est.parcela,         /* Parcela OC       */                   
                                              INPUT 0,                            /* Quantidade Parc. */  
                                              yes,
                                              INPUT 0,   
                                              INPUT 0,                            /* Preco Unit Recebido */
                                              INPUT 0).                           /* Preco Unit Ordem */

                  END.

                   ASSIGN i-nfe = i-nfe + 1.
             END.
        END. /* docum-est */
    END.
       
    /* calcula variaveis de devolucao */
    IF (l-devol-cq AND l-qualid-ft) OR l-var-qualidade THEN DO:
        FOR EACH devol-forn
            WHERE devol-forn.serie-docto  = recebimento.serie-docto 
              AND devol-forn.nro-docto    = recebimento.numero-nota 
              AND devol-forn.cod-emitente = recebimento.cod-emitente
              AND devol-forn.nat-operacao = recebimento.nat-operacao NO-LOCK:

            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel  = devol-forn.cod-estabel 
                  AND nota-fiscal.serie        = devol-forn.serie      
                  AND nota-fiscal.nr-nota-fis  = devol-forn.nr-nota-fis: END.

            IF nota-fiscal.esp-docto   = 20 AND 
               nota-fiscal.cod-estabel = TRIM(af-item-contr-estab.cod-estabel) THEN DO:
             
               FOR EACH it-nota-fisc FIELDS(qt-faturada nat-operacao nr-seq-fat serie-docum nat-docum nr-docum cod-estabel it-codigo
                                          nat-operacao parcela nr-ordem int-1 nr-nota-fis serie ) NO-LOCK
                   WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                     AND it-nota-fisc.serie       = nota-fiscal.serie
                     AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                     AND it-nota-fisc.it-codigo   = TRIM(af-item-contr-estab.it-codigo):                     
                    /* Procura exce‡Æo exata */
                   IF CAN-FIND (FIRST af-excecao
                                WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                                AND   af-excecao.ind-tipo-doc = 4
                                AND   af-excecao.cod-estabel  = it-nota-fisc.cod-estabel
                                AND   af-excecao.serie-docto  = it-nota-fisc.serie
                                AND   af-excecao.nro-docto    = it-nota-fisc.nr-nota-fis
                                AND   af-excecao.nr-seq-fat   = it-nota-fisc.nr-seq-fat) THEN NEXT.
    
                   /* Procura exce‡Æo gen‚rica, para todo documento */
                   IF CAN-FIND (FIRST af-excecao
                                WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                                AND   af-excecao.ind-tipo-doc = 4
                                AND   af-excecao.cod-estabel  = it-nota-fisc.cod-estabel
                                AND   af-excecao.serie-docto  = it-nota-fisc.serie
                                AND   af-excecao.nro-docto    = it-nota-fisc.nr-nota-fis
                                AND   af-excecao.nr-seq-fat   = 0) THEN NEXT.
    
                   ASSIGN i-nfd    = i-nfd + 1
                          i-pedido = 0.
                   IF it-nota-fisc.nr-ordem <> 0 THEN DO:
                       FOR FIRST ordem-compra FIELD(num-pedido)
                           WHERE ordem-compra.numero-ordem = it-nota-fisc.nr-ordem 
                           NO-LOCK: END.
                       IF AVAIL ordem-compra THEN i-pedido = ordem-compra.num-pedido.
                   END.
    
                   /* Procura exce‡Æo pedido/ordem/parcela */
                   IF i-pedido <> 0 THEN DO:
                       RUN pi-excecao-pedido (INPUT i-pedido,
                                              INPUT it-nota-fisc.nr-ordem,
                                              INPUT it-nota-fisc.parcela).
                       IF RETURN-VALUE = "NOK" THEN NEXT.
                   END.
    
                   FOR EACH fat-ser-lote FIELDS(nr-serlote qt-baixada)
                       WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                       AND   fat-ser-lote.serie       = it-nota-fisc.serie
                       AND   fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                       AND   fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                       AND   fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
                       NO-LOCK:
                       ASSIGN de-tot-dev = de-tot-dev + fat-ser-lote.qt-baixada[1]
                              de-qt-dev  = fat-ser-lote.qt-baixada[1]
                              i-ficha    = 0.
                       
                       FOR FIRST item-doc-est
                            FIELDS (cod-emitente nro-docto nat-operacao serie-docto sequencia)
                            WHERE item-doc-est.serie-docto      = it-nota-fisc.serie-docum
                            AND   item-doc-est.nro-docto        = it-nota-fisc.nr-docum
                            AND   item-doc-est.cod-emitente     = af-item-contr-estab.cod-emitente
                            AND   item-doc-est.nat-operacao     = it-nota-fisc.nat-docum
                            AND   item-doc-est.sequencia        = it-nota-fisc.int-1
                          /*AND   item-doc-est.it-codigo        = TRIM(af-item-contr-estab.it-codigo)*/ NO-LOCK:
                       END.
                       IF  AVAIL item-doc-est THEN DO:
                           FOR FIRST rat-lote FIELDS(nr-ficha)
                               WHERE rat-lote.serie-docto     = item-doc-est.serie-docto
                                 AND rat-lote.nro-docto       = item-doc-est.nro-docto
                                 AND rat-lote.cod-emitente    = item-doc-est.cod-emitente
                                 AND rat-lote.nat-operacao    = item-doc-est.nat-operacao
                                 AND rat-lote.sequencia       = item-doc-est.sequencia
                               /*AND rat-lote.it-codigo       = TRIM(af-item-contr-estab.it-codigo)*/ NO-LOCK:
                           END.
                           IF AVAIL rat-lote THEN DO:
                              IF rat-lote.nr-ficha = 0 THEN
                                 ASSIGN de-tot-dev-cq = de-tot-dev-cq + fat-ser-lote.qt-baixada[1]
                                        de-qt-dev-cq  = fat-ser-lote.qt-baixada[1]
                                        i-ficha       = rat-lote.nr-ficha
                                        i-nfd-cq      = i-nfd-cq + 1.
                           END.
                           ELSE  ASSIGN de-tot-dev-cq = de-tot-dev-cq + fat-ser-lote.qt-baixada[1]
                                        de-qt-dev-cq  = fat-ser-lote.qt-baixada[1]
                                        i-nfd-cq      = i-nfd-cq + 1.
                       END.
                       ELSE ASSIGN de-tot-dev-cq = de-tot-dev-cq + fat-ser-lote.qt-baixada[1]
                                   de-qt-dev-cq  = fat-ser-lote.qt-baixada[1]
                                   i-nfd-cq      = i-nfd-cq + 1.
    
                       RUN pi-grava-detalhe (INPUT i-nr-qualidade,
                                             INPUT 2,
                                             INPUT it-nota-fisc.serie,
                                             INPUT it-nota-fisc.nr-nota-fis,
                                             INPUT it-nota-fisc.nat-operacao,
                                             INPUT it-nota-fisc.nr-seq-fat,
                                             INPUT fat-ser-lote.nr-serlote,
                                             INPUT nota-fiscal.dt-emis-nota, /*movto-estoq.dt-trans*/ 
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT de-qt-dev,
                                             INPUT de-qt-dev-cq,
                                             INPUT i-ficha,
                                             INPUT 0,
                                             INPUT i-pedido,
                                             INPUT it-nota-fisc.nr-ordem,
                                             INPUT it-nota-fisc.parcela,                     
                                             INPUT 0,
                                             yes,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0). 
                   END. /* fat-ser-lote*/
               END. /* it-nota-fisc */
            END. /* nota-fiscal */     
        END. /* devol-forn */
    END. /* l-devol */

    /* Acertar o ponto de sa¡da para nÆo gravar a nota, precisa ver se nÆo tem devolu‡Æo */
    IF NOT l-devol-cq AND i-nr-ficha-cq = 0 THEN return.

     FOR EACH tt-af-var
         WHERE tt-af-var.padrao = YES:
         IF tt-af-var.cod-variavel = "PCQ00001" THEN /* Quantidade Aprovada CQ */
            ASSIGN tt-af-var.valor = de-tot-cq-apr.
         ELSE IF tt-af-var.cod-variavel = "PCQ00002" THEN /* Quantidade Perda CQ */
            ASSIGN tt-af-var.valor = de-tot-cq-per.
         ELSE IF tt-af-var.cod-variavel = "PCQ00003" THEN /* Quantidade Aprovada Condicional CQ */
            ASSIGN tt-af-var.valor = de-tot-cq-con.
         ELSE IF tt-af-var.cod-variavel = "PCQ00004" THEN /* Quantidade Rejeitada CQ*/
            ASSIGN tt-af-var.valor = de-tot-cq-rej.
         ELSE IF tt-af-var.cod-variavel = "PCQ00005" THEN /* Quantidade Devolvida sem CQ */
            ASSIGN tt-af-var.valor = de-tot-dev-cq.
         ELSE IF tt-af-var.cod-variavel = "PCQ00006" THEN /* Quantidade Devolvida Total */
            ASSIGN tt-af-var.valor = de-tot-dev.
         ELSE IF tt-af-var.cod-variavel = "PCQ00007" THEN /* Quantidade Recebida Total */
            ASSIGN tt-af-var.valor = de-tot-rec.
         ELSE IF tt-af-var.cod-variavel = "PCQ00008" THEN /* N£mero Total Roteiro Inspe‡Æo */
            ASSIGN tt-af-var.valor = i-nr-ficha-cq.
         ELSE IF tt-af-var.cod-variavel = "PCQ00009" THEN /* N£mero Total Recebimento */
            ASSIGN tt-af-var.valor = i-nfe.
         ELSE IF tt-af-var.cod-variavel = "PCQ00010" THEN /* N£mero Devolu‡Æo sem CQ */
            ASSIGN tt-af-var.valor = i-nfd-cq.
         ELSE IF tt-af-var.cod-variavel = "PCQ00011" THEN /* N£mero Total notas Fiscais Devolu‡Æo */
            ASSIGN tt-af-var.valor = i-nfd.
         ELSE IF tt-af-var.cod-variavel = "PCQ00012" THEN
            ASSIGN tt-af-var.valor = af-item-contr-estab.demerito.
     END.

     RUN pi-calcular-formula (INPUT  i-for-qualidade,
                              INPUT  i-nr-qualidade,
                              INPUT  i-nr-versao,
                              OUTPUT de-indice-param,
                              OUTPUT c-narrativa-param).

     IF RETURN-VALUE <> "NOK":U THEN DO:
         ASSIGN de-nota = de-indice-param.
         IF de-nota < 0 THEN de-nota = 0.
         ELSE IF de-nota > 100 THEN de-nota = 100.

         RUN pi-grava-nota (INPUT i-nr-qualidade,
                            INPUT i-for-qualidade,
                            INPUT c-narrativa-param,
                            INPUT YES,
                            INPUT de-perc-quali,
                            INPUT i-versao-formula).
     END.

    ASSIGN i-tempo[5] = i-tempo[5] + TIME - i-ult-tempo[5].
    RETURN "OK".

END PROCEDURE.


PROCEDURE pi-calcula-ponto-padrao:
    
    ASSIGN i-ult-tempo[6] = TIME.

    DEFINE VARIABLE i-cont               AS INTEGER        NO-UNDO.
    
    DEFINE VARIABLE de-tot-rec-qt        AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-cor-qt    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-err-qt    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-quant-rec-qt      AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-quant-erro-qt     AS DECIMAL        NO-UNDO.
    
    DEFINE VARIABLE de-tot-rec-pr        AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-cor-pr    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-err-pr    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE l-correto-pr         AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE l-entrou-pr          AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE de-quant-erro-pr     AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-quant-erro-aux-pr AS DECIMAL        NO-UNDO.    
    DEFINE VARIABLE de-quant-cor-pr      AS DECIMAL        NO-UNDO.
    
    DEFINE VARIABLE de-tot-rec-dt        AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-cor-dt    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-rec-err-dt    AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE l-correto-dt         AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE l-entrou-dt          AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE i-dias-dt            AS INTEGER        NO-UNDO.
    DEFINE VARIABLE de-quant-erro-dt     AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-quant-erro-aux-dt AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-quant-cor-aux-dt  AS DECIMAL        NO-UNDO.
    DEFINE VARIABLE de-tot-nota-parcela  AS DECIMAL        NO-UNDO.

    DEFINE VARIABLE de-indice-param      LIKE af-contr-indice.indice    NO-UNDO.
    DEFINE VARIABLE c-narrativa-param    LIKE af-contr-indice.narrativa NO-UNDO.
    ASSIGN de-tot-rec-dt     = 0
           de-tot-rec-cor-dt = 0
           de-tot-rec-err-dt = 0
           de-tot-rec        = 0
           de-tot-cq-apr     = 0
           de-tot-cq-con     = 0
           de-tot-cq-rej     = 0
           de-tot-cq-per     = 0
           de-tot-dev-cq     = 0
           de-tot-dev        = 0. 
    
    DO i-cont = 2 TO 6 BY 4: /*Confirmada=2 e Recebida=6*/
    
        FOR EACH prazo-compra FIELDS(parcela quantidade data-entrega numero-ordem) USE-INDEX planejamento
                WHERE prazo-compra.it-codigo     = TRIM(af-item-contr-estab.it-codigo)
                AND   prazo-compra.situacao      = i-cont
                AND   prazo-compra.data-entrega >= da-data-ini
                AND   prazo-compra.data-entrega <= da-data-fim NO-LOCK:

                FIND FIRST ordem-compra NO-LOCK
                     WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-ERROR.
                IF NOT AVAIL ordem-compra 
                    OR ordem-compra.cod-estabel  <> TRIM(af-item-contr-estab.cod-estabel) THEN NEXT.
                
                /* Procura exce‡Æo pedido/ordem/parcela */
                RUN pi-excecao-pedido (INPUT ordem-compra.num-pedido,
                                       INPUT ordem-compra.numero-ordem,
                                       INPUT prazo-compra.parcela).
                IF RETURN-VALUE = "NOK" THEN NEXT.

                ASSIGN de-quant-rec-qt      = 0
                       de-quant-erro-qt     = 1
                       l-correto-pr         = yes
                       l-entrou-pr          = NO
                       l-erro               = NO
                       de-quant-erro-aux-pr = 1
                       l-correto-dt         = yes
                       l-entrou-dt          = NO
                       de-quant-erro-aux-dt = 1 
                       de-quant-cor-aux-dt  = 0
                       de-quant-cor-pr      = 0
                       de-tot-nota-parcela  = 0.

                receb:      
                FOR EACH recebimento FIELDS(quant-receb serie-nota numero-nota nat-operacao int-1 cod-movto num-pedido serie-docto cod-emitente sequencia
                                            numero-ordem parcela data-movto quant-receb preco-unit data-nota data-movto qtd-rec-forn pre-unit-for) 
                   WHERE recebimento.numero-ordem = ordem-compra.numero-ordem
                     AND recebimento.parcela      = prazo-compra.parcela NO-LOCK:

                     IF recebimento.cod-movto <> 1 OR 
                        recebimento.cod-emitente <> af-item-contr-estab.cod-emitente THEN NEXT.


                     /* Qualidade */ 
                     IF l-qualidade OR l-var-qualidade THEN DO:
                        RUN pi-calcula-qualidade.

                     END.

                     /* Procura exce‡Æo exata */
                     IF CAN-FIND(FIRST af-excecao 
                                 WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                                 AND   af-excecao.ind-tipo-doc = 2
                                 AND   af-excecao.serie-docto  = recebimento.serie-docto
                                 AND   af-excecao.nro-docto    = recebimento.numero-nota
                                 AND   af-excecao.cod-emitente = recebimento.cod-emitente
                                 AND   af-excecao.nat-operacao = recebimento.nat-operacao
                                 AND   af-excecao.sequencia    = recebimento.int-1) THEN NEXT.

                     /* Procura exce‡Æo gen‚rica, para todo documento */
                     IF CAN-FIND(FIRST af-excecao 
                                 WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                                 AND   af-excecao.ind-tipo-doc = 2
                                 AND   af-excecao.serie-docto  = recebimento.serie-docto
                                 AND   af-excecao.nro-docto    = recebimento.numero-nota
                                 AND   af-excecao.cod-emitente = recebimento.cod-emitente
                                 AND   af-excecao.nat-operacao = recebimento.nat-operacao
                                 AND   af-excecao.sequencia    = 0) THEN NEXT.

                     RUN pi-converte-preco-ordem (INPUT ordem-compra.preco-unit, 
                                                  INPUT recebimento.data-nota).
                     
                     IF l-quant OR l-var-quantidade THEN DO:
                        ASSIGN de-quant-rec-qt      = de-quant-rec-qt + recebimento.quant-receb
                               de-tot-rec-qt        = de-tot-rec-qt + 1
                               de-tot-nota-parcela  = de-tot-nota-parcela + 1.

                        RUN pi-converte-preco-ordem (INPUT ordem-compra.preco-unit, 
                                                     INPUT recebimento.data-nota).
                          
                         RUN pi-grava-detalhe (INPUT i-nr-quant,  
                                               INPUT 2,                        
                                               INPUT recebimento.serie-nota,   
                                               INPUT recebimento.numero-nota,  
                                               INPUT recebimento.nat-operacao, 
                                               INPUT recebimento.int-1,        
                                               INPUT "",
                                               INPUT recebimento.data-movto,   
                                               INPUT 0,                        
                                               INPUT 0,                        
                                               INPUT 0,                        
                                               INPUT 0,                        
                                               INPUT recebimento.quant-receb,  
                                               INPUT 0,
                                               INPUT 0,
                                               INPUT 0,
                                               INPUT 0,
                                               INPUT ordem-compra.num-pedido,
                                               INPUT ordem-compra.numero-ordem,
                                               INPUT prazo-compra.parcela,     
                                               INPUT prazo-compra.quantidade,  
                                               INPUT yes,
                                               INPUT 0,
                                               INPUT recebimento.preco-unit,
                                               INPUT de-preco-unit).
                        
                     END.
                     

                     IF l-preco OR l-var-preco THEN DO:
                        ASSIGN l-entrou-pr = YES
                               de-tot-rec-pr = de-tot-rec-pr + 1.
                        
                        RUN pi-grava-detalhe (INPUT i-nr-preco,  
                                              INPUT 2,                        
                                              INPUT recebimento.serie-nota,   
                                              INPUT recebimento.numero-nota,  
                                              INPUT recebimento.nat-operacao, 
                                              INPUT recebimento.int-1,        
                                              INPUT "",
                                              INPUT recebimento.data-movto,   
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT recebimento.quant-receb,  
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT ordem-compra.num-pedido,
                                              INPUT ordem-compra.numero-ordem,
                                              INPUT prazo-compra.parcela,     
                                              INPUT prazo-compra.quantidade,  
                                              INPUT yes,
                                              INPUT 0,
                                              INPUT recebimento.preco-unit,
                                              INPUT de-preco-unit).
                        
                        RUN pi-variacao-pre (INPUT ROUND(recebimento.pre-unit-for,4)). 
                        IF l-erro THEN DO:
                           RUN pi-faixa-demerito (INPUT 3,
                                                  INPUT ordem-compra.pre-unit-for,
                                                  INPUT recebimento.pre-unit-for,
                                                  OUTPUT de-quant-erro-pr).
                           ASSIGN l-correto-pr = NO.
                           /* VerIFica qual das notas teve o pior desempenho */
                           IF de-quant-erro-pr < de-quant-erro-aux-pr THEN
                              ASSIGN de-quant-erro-aux-pr = de-quant-erro-pr.

                           ASSIGN de-quant-cor-pr  = IF de-quant-erro-pr <> 0 AND de-quant-erro-pr < 1 THEN 
                                                               (de-quant-cor-pr + de-quant-erro-pr)
                                                            ELSE de-quant-cor-pr. 
                        END.
                        ELSE ASSIGN de-quant-cor-pr = de-quant-cor-pr + 1.
                     END.

                     IF l-data OR l-var-data THEN DO:

                        ASSIGN l-entrou-dt   = yes
                               de-tot-rec-dt = de-tot-rec-dt + 1. 
                        
                        RUN pi-grava-detalhe (INPUT i-nr-data,  
                                              INPUT 2,                        
                                              INPUT recebimento.serie-nota,   
                                              INPUT recebimento.numero-nota,  
                                              INPUT recebimento.nat-operacao, 
                                              INPUT recebimento.int-1,        
                                              INPUT "",
                                              INPUT recebimento.data-movto,   
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT 0,                        
                                              INPUT recebimento.quant-receb,  
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT 0,
                                              INPUT ordem-compra.num-pedido,
                                              INPUT ordem-compra.numero-ordem,
                                              INPUT prazo-compra.parcela,     
                                              INPUT prazo-compra.quantidade,  
                                              INPUT yes,
                                              INPUT 0,
                                              INPUT recebimento.preco-unit,
                                              INPUT de-preco-unit).
                
                        ASSIGN i-dias-dt = recebimento.data-movto - prazo-compra.data-entrega.

                        IF  i-dias-dt  = 0 THEN 
                            ASSIGN de-quant-cor-aux-dt  = de-quant-cor-aux-dt + 1.    
                        IF i-dias-dt > 0 THEN do:
                           IF i-dias-dt > af-item-contr-estab.nr-dia-max THEN do:
                              RUN pi-faixa-demerito (INPUT 4,
                                                     INPUT 0,
                                                     INPUT i-dias-dt,
                                                     OUTPUT de-quant-erro-dt).

                              /* VerIFica qual das notas teve o pior desempenho */
                              IF de-quant-erro-dt < de-quant-erro-aux-dt THEN
                                 ASSIGN de-quant-erro-aux-dt = de-quant-erro-dt. 
                              ASSIGN l-correto-dt = NO
                                     de-quant-cor-aux-dt  = IF de-quant-erro-dt <> 0 AND de-quant-erro-dt <= 1 THEN 
                                                               (de-quant-cor-aux-dt + de-quant-erro-dt)
                                                            ELSE de-quant-cor-aux-dt. 

                           END.
                           ELSE IF i-dias-dt <> 0 THEN 
                               ASSIGN de-quant-cor-aux-dt  = de-quant-cor-aux-dt + 1.    
                        END.
                        ELSE DO: 
                           ASSIGN i-dias-dt = i-dias-dt * -1.
                           IF i-dias-dt > af-item-contr-estab.nr-dia-min THEN do: 
                              RUN pi-faixa-demerito (INPUT 4,
                                                     INPUT i-dias-dt,
                                                     INPUT 0,
                                                     OUTPUT de-quant-erro-dt).
                              /* VerIFica qual das notas teve o pior desempenho */
                              IF de-quant-erro-dt < de-quant-erro-aux-dt THEN
                                 ASSIGN de-quant-erro-aux-dt = de-quant-erro-dt. 
                              ASSIGN l-correto-dt = NO
                                     de-quant-cor-aux-dt  = IF de-quant-erro-dt <> 0 AND de-quant-erro-dt <= 1 THEN 
                                                               (de-quant-cor-aux-dt + de-quant-erro-dt)
                                                            ELSE de-quant-cor-aux-dt.   
                           END.
                           ELSE IF i-dias-dt <> 0 THEN 
                               ASSIGN de-quant-cor-aux-dt  = de-quant-cor-aux-dt + 1.   
                        END.
                     END.
                END.

               RUN pi-converte-preco-ordem (INPUT ordem-compra.preco-unit, 
                                            INPUT ordem-compra.data-cotacao).
                IF l-quant OR l-var-quantidade THEN DO:
                   IF de-quant-rec-qt > 0 THEN DO:
                      RUN pi-variacao-qtd (INPUT de-quant-rec-qt).
                      /*ASSIGN de-tot-rec-qt = de-tot-rec-qt + 1. */
                      IF NOT l-erro THEN ASSIGN de-tot-rec-cor-qt = de-tot-rec-cor-qt + de-tot-nota-parcela.
                      ELSE DO:

                         RUN pi-faixa-demerito (INPUT 2,
                                                INPUT prazo-compra.quantidade,
                                                INPUT de-quant-rec-qt,
                                                OUTPUT de-quant-erro-qt).

                         ASSIGN de-tot-rec-cor-qt = de-tot-rec-cor-qt + de-quant-erro-qt
                                de-tot-rec-err-qt = de-tot-rec-err-qt + (1 - de-quant-erro-qt).

                       END.

                       RUN pi-grava-detalhe (INPUT i-nr-quant,  
                                             INPUT 1,                        
                                             INPUT "",   
                                             INPUT "",  
                                             INPUT "", 
                                             INPUT 0,        
                                             INPUT "",
                                             INPUT prazo-compra.data-entrega,   
                                             INPUT 0,                        
                                             INPUT 0,                        
                                             INPUT 0,                        
                                             INPUT 0,                        
                                             INPUT 0,  
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT ordem-compra.num-pedido,
                                             INPUT ordem-compra.numero-ordem,
                                             INPUT prazo-compra.parcela,     
                                             INPUT prazo-compra.quantidade,  
                                             INPUT NOT l-erro,
                                             INPUT ((1 - de-quant-erro-qt) * 100),
                                             INPUT 0,
                                             INPUT de-preco-unit).
                    END.
                END.

                IF l-preco OR l-var-preco THEN DO:
                   IF l-entrou-pr THEN DO:
                      /*ASSIGN de-tot-rec-pr = de-tot-rec-pr + 1. */
                      
                      RUN pi-grava-detalhe (INPUT i-nr-preco,  
                                            INPUT 1,                        
                                            INPUT "",   
                                            INPUT "",  
                                            INPUT "", 
                                            INPUT 0,        
                                            INPUT "",
                                            INPUT prazo-compra.data-entrega,   
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,  
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT ordem-compra.num-pedido,
                                            INPUT ordem-compra.numero-ordem,
                                            INPUT prazo-compra.parcela,     
                                            INPUT prazo-compra.quantidade,  
                                            INPUT NOT l-erro,
                                            INPUT ((1 - de-quant-erro-aux-pr) * 100),
                                            INPUT 0,
                                            INPUT de-preco-unit).

                      ASSIGN de-tot-rec-cor-pr = de-tot-rec-cor-pr + de-quant-cor-pr
                             de-tot-rec-err-pr = de-tot-rec-err-pr + (1 - de-quant-erro-aux-pr).
                   END.
                END.

                IF l-data OR l-var-data THEN DO:
                   IF l-entrou-dt THEN DO:
                      ASSIGN de-tot-rec-cor-dt = de-tot-rec-cor-dt + de-quant-cor-aux-dt
                             de-tot-rec-err-dt = de-tot-rec-err-dt + (1 - de-quant-erro-aux-dt).
                      RUN pi-grava-detalhe (INPUT i-nr-data,  
                                            INPUT 1,                        
                                            INPUT "",   
                                            INPUT "",  
                                            INPUT "", 
                                            INPUT 0,        
                                            INPUT "",
                                            INPUT prazo-compra.data-entrega,   
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,                        
                                            INPUT 0,  
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT 0,
                                            INPUT ordem-compra.num-pedido,
                                            INPUT ordem-compra.numero-ordem,
                                            INPUT prazo-compra.parcela,     
                                            INPUT prazo-compra.quantidade,  
                                            INPUT l-correto-dt,
                                            INPUT ((1 - de-quant-erro-aux-dt) * 100),
                                            INPUT 0,
                                            INPUT de-preco-unit).

                   END.

                END.
        END. /* FOR EACH prazo-compra */

        IF l-quant OR l-var-quantidade THEN DO:
           FOR EACH tt-af-var
               WHERE tt-af-var.padrao = YES:
               IF tt-af-var.cod-variavel = "PNRQT001" THEN /* N£mero Recebimento Quantidade Correta */
                  ASSIGN tt-af-var.valor = de-tot-rec-cor-qt.
               ELSE IF tt-af-var.cod-variavel = "PNRQT002" THEN /* N£mero Recebimento Quantidade Incorreta */
                  ASSIGN tt-af-var.valor = de-tot-rec-err-qt.
               ELSE IF tt-af-var.cod-variavel = "PNRQT003" THEN /* N£mero Total Recebimento */
                  ASSIGN tt-af-var.valor = de-tot-rec-qt.
           END.

           IF l-quant THEN DO:
               ASSIGN de-indice-param   = 0
                      c-narrativa-param = ""
                      de-nota          = 0.

               RUN pi-calcular-formula (INPUT  i-for-quant,
                                        INPUT  i-nr-quant,
                                        INPUT  i-nr-versao,
                                        OUTPUT de-indice-param,
                                        OUTPUT c-narrativa-param).

               IF RETURN-VALUE <> "NOK":U THEN DO:
                    ASSIGN de-nota = de-indice-param.
                    IF de-nota < 0 THEN de-nota = 0.
                    ELSE IF de-nota > 100 THEN de-nota = 100.

                    IF af-item-contr-estab.log-considera-qtd-receb THEN  
                       ASSIGN c-narrativa-param = c-narrativa-param + "~r~n" +
                                    "Considera varia‡Æo do recebimento" + "~r~n" +     
                                    "Varia‡Æo percentual..............................................: " + STRING(de-var-pct-qtd,">,>>>,>>>,>>9.99") + "~r~n" +
                                    "Varia‡Æo quantidade..............................................: " + STRING(de-var-lim-qtd,">,>>>,>>>,>>9.99") .
                    ELSE
                       ASSIGN c-narrativa-param = c-narrativa-param + "~r~n" +
                                    "NÆo Considera varia‡Æo do recebimento" + "~r~n" +
                                    "% Qtd MeNOr......................................................: " + STRING(af-item-contr-estab.pct-qtd-min,">>>>,>>9.99") + "~r~n" +
                                    "% Qtd Maior......................................................: " + STRING(af-item-contr-estab.pct-qtd-max,">>>>,>>9.99") .

                    RUN pi-grava-nota (INPUT i-nr-quant,
                                       INPUT i-for-quant,
                                       INPUT c-narrativa-param,
                                       INPUT YES,
                                       INPUT de-perc-quant,
                                       INPUT i-versao-formula).
               END.
           END.
        END.

        IF l-preco OR l-var-preco THEN DO:
           FOR EACH tt-af-var
               WHERE tt-af-var.padrao = YES:
               IF tt-af-var.cod-variavel = "PNRPR001" THEN /* N£mero Recebimento Pre‡o Correto */
                  ASSIGN tt-af-var.valor = de-tot-rec-cor-pr.
               ELSE IF tt-af-var.cod-variavel = "PNRPR002" THEN /* N£mero Recebimento Pre‡o Incorreto */
                  ASSIGN tt-af-var.valor = de-tot-rec-err-pr.
               ELSE IF tt-af-var.cod-variavel = "PNRPR003" THEN /* N£mero Total Recebimento */
                  ASSIGN tt-af-var.valor = de-tot-rec-pr.
           END.

           IF l-preco THEN DO:
               ASSIGN de-indice-param   = 0
                      c-narrativa-param = ""
                      de-nota          = 0.

               RUN pi-calcular-formula (INPUT  i-for-preco,
                                        INPUT  i-nr-preco,
                                        INPUT  i-nr-versao,
                                        OUTPUT de-indice-param,
                                        OUTPUT c-narrativa-param).

               IF RETURN-VALUE <> "NOK":U THEN DO:
                   ASSIGN de-nota = de-indice-param.
                   IF de-nota < 0 THEN de-nota = 0.
                   ELSE IF de-nota > 100 THEN de-nota = 100.
                   IF af-item-contr-estab.log-considera-val-receb THEN  
                      ASSIGN c-narrativa-param = c-narrativa-param + "~r~n" +
                             "Considera varia‡Æo do recebimento" + "~r~n" +
                             "Varia‡Æo percentual..............................................: " + STRING(de-var-pct-pre,">,>>>,>>>,>>9.99") + "~r~n" +
                             "Varia‡Æo valor...................................................: " + STRING(de-var-lim-pre,">,>>>,>>>,>>9.99") .
                   ELSE
                      ASSIGN c-narrativa-param = c-narrativa-param + "~r~n" +
                             "NÆo Considera varia‡Æo do recebimento" + "~r~n" +
                             "% Val MeNOr......................................................: " + STRING(af-item-contr-estab.pct-val-min,">>>>,>>9.99") + "~r~n" +
                             "% Val Maior......................................................: " + STRING(af-item-contr-estab.pct-val-max,">>>>,>>9.99") .

                    RUN pi-grava-nota (INPUT i-nr-preco,
                                       INPUT i-for-preco,
                                       INPUT c-narrativa-param,
                                       INPUT YES,
                                       INPUT de-perc-preco,
                                       INPUT i-versao-formula).
               END.
           END.

        END.

        IF l-data OR l-var-data THEN DO:
           FOR EACH tt-af-var
               WHERE tt-af-var.padrao = YES:
               IF tt-af-var.cod-variavel = "PNRDT001" THEN /* Nœmero Recebimento Data Correta */
                  ASSIGN tt-af-var.valor = de-tot-rec-cor-dt.
               ELSE IF tt-af-var.cod-variavel = "PNRDT002" THEN /* Nœmero Recebimento Data Incorreta */
                  ASSIGN tt-af-var.valor = de-tot-rec-err-dt.
               ELSE IF tt-af-var.cod-variavel = "PNRDT003" THEN /* Nœmero Total Recebimento */
                  ASSIGN tt-af-var.valor = de-tot-rec-dt.
           END.

           IF l-data THEN DO:
               ASSIGN de-indice-param   = 0
                      c-narrativa-param = ""
                      de-nota          = 0.

               RUN pi-calcular-formula (INPUT  i-for-data,
                                        INPUT  i-nr-data,
                                        INPUT  i-nr-versao,
                                        OUTPUT de-indice-param,
                                        OUTPUT c-narrativa-param).


               IF RETURN-VALUE <> "NOK":U THEN DO:
                   ASSIGN de-nota = de-indice-param.
                   IF de-nota < 0 THEN de-nota = 0.
                   ELSE IF de-nota > 100 THEN de-nota = 100.
                   ASSIGN c-narrativa-param = c-narrativa-param +  "~r~n" + 
                          "Varia‡Æo M¡nima (dias)...........................................: " + STRING(af-item-contr-estab.nr-dia-min,">>>,>>>,>>9") + "~r~n" + 
                          "Varia‡Æo M xima (dias)...........................................: " + STRING(af-item-contr-estab.nr-dia-max,">>>,>>>,>>9").

                   RUN pi-grava-nota (INPUT i-nr-data,
                                      INPUT i-for-data,
                                      INPUT c-narrativa-param,
                                      INPUT YES,
                                      INPUT de-perc-data,
                                      INPUT i-versao-formula).
               END.
           END.
        END.
    
    END. /* do i-cont = 2 to 6 by 4 */
    
    ASSIGN i-tempo[6] = i-tempo[6] + TIME - i-ult-tempo[6].

END PROCEDURE.


PROCEDURE pi-variacao-qtd:
    DEF INPUT PARAM p-quant-rec AS DEC NO-UNDO.
    ASSIGN i-ult-tempo[9] = TIME.

    ASSIGN l-erro = NO
           de-var-pct-qtd = 0
           de-var-lim-qtd = 0.

    IF af-item-contr-estab.log-considera-qtd-receb THEN DO:
        &IF DEFINED(bf_mat_uni_estab) &THEN
            FOR FIRST item-uni-estab
               FIELDS ( lim-var-valor var-val-re-maior var-qtd-re lim-var-qtd)
                WHERE item-uni-estab.it-codigo   = TRIM(af-item-contr-estab.it-codigo)
                  AND item-uni-estab.cod-estabel = TRIM(af-item-contr-estab.cod-estabel) NO-LOCK: END.
            
            IF  NOT AVAIL item-uni-estab
            OR (    AVAIL item-uni-estab 
                AND (item-uni-estab.var-qtd-re       = 0
                     OR item-uni-estab.lim-var-qtd   = 0 ) ) THEN DO:
                FOR FIRST item-mat
                    FIELDS ( var-qtd-re lim-var-qtd ) 
                    WHERE item-mat.it-codigo = TRIM(af-item-contr-estab.it-codigo) NO-LOCK: END.
            END.
        
            ASSIGN de-var-pct-qtd = IF  AVAIL item-uni-estab AND item-uni-estab.var-qtd-re > 0 THEN item-uni-estab.var-qtd-re
                                    ELSE item-mat.var-qtd-re
                                     
                   de-var-lim-qtd = IF  AVAIL item-uni-estab AND item-uni-estab.lim-var-qtd > 0 THEN item-uni-estab.lim-var-qtd
                                    ELSE item-mat.lim-var-qtd.

            IF  de-var-pct-qtd = 0
            AND de-var-lim-qtd = 0  THEN DO:
                /* VerIFica quantidade a mais*/
                IF  (p-quant-rec  >  (prazo-compra.quantidade * (1 + (de-var-pct-qtd / 100))))
                OR  (p-quant-rec  > prazo-compra.quantidade + de-var-lim-qtd) THEN
                    ASSIGN l-erro = YES.
                 
                /* VerIFica quantidade a meNOs */
                IF  (p-quant-rec  < (prazo-compra.quantidade * (1 - (de-var-pct-qtd / 100))))
                OR  (p-quant-rec  < prazo-compra.quantidade - de-var-lim-qtd) THEN
                    ASSIGN l-erro = YES.

            END.
            ELSE DO:
                /* VerIFica quantidade a mais */
                IF  p-quant-rec <=  (prazo-compra.quantidade * (1 + (de-var-pct-qtd / 100)))
                OR  de-var-pct-qtd = 0 THEN 
                    IF (p-quant-rec  > prazo-compra.quantidade + de-var-lim-qtd)
                    AND de-var-lim-qtd > 0 THEN
                        ASSIGN l-erro = YES.
                    ELSE
                        ASSIGN l-erro = NO.
                
                ELSE
                    ASSIGN l-erro = YES.

                /* VerIFica quantidade a meNOs */
                IF  (p-quant-rec  >=  (prazo-compra.quantidade * (1 - (de-var-pct-qtd / 100))))
                OR  de-var-pct-qtd = 0 THEN
                    IF (p-quant-rec  < prazo-compra.quantidade - de-var-lim-qtd)
                    AND de-var-lim-qtd > 0 THEN
                        ASSIGN l-erro = YES.
                    ELSE
                        ASSIGN l-erro = NO.
                ELSE
                    ASSIGN l-erro = YES.

            END.
           
        &ELSE
        
            find familia WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR. 
            ASSIGN de-var-pct-qtd = familia.var-qtd-perm.

            /* VerIFica quantidade a mais*/
            IF  (p-quant-rec  >  (prazo-compra.quantidade * (1 + (de-var-pct-qtd / 100)))) THEN
                ASSIGN l-erro = YES.
             
            /* VerIFica quantidade a meNOs */
            IF  (p-quant-rec  < (prazo-compra.quantidade * (1 - (de-var-pct-qtd / 100)))) THEN
                ASSIGN l-erro = YES.
        
        &endIF
    END.
    ELSE DO:

        /* VerIFica quantidade a mais*/
        IF  (p-quant-rec  >  (prazo-compra.quantidade * (1 + (af-item-contr-estab.pct-qtd-max / 100)))) THEN
            ASSIGN l-erro = YES.
         
        /* VerIFica quantidade a meNOs */
        IF  (p-quant-rec  < (prazo-compra.quantidade * (1 - (af-item-contr-estab.pct-qtd-min / 100)))) THEN
            ASSIGN l-erro = YES.

    END.

    ASSIGN i-tempo[9] = i-tempo[9] + TIME - i-ult-tempo[9].
END PROCEDURE.


PROCEDURE pi-variacao-pre:
    DEF INPUT PARAM p-preco-rec AS DEC FORMAT ">>>>>,>>>,>>9.9999" NO-UNDO. 
    ASSIGN i-ult-tempo[10] = TIME.

    ASSIGN l-erro = NO
           de-var-pct-pre = 0
           de-var-lim-pre = 0.

    RUN pi-converte-preco-ordem (INPUT ordem-compra.pre-unit-for, recebimento.data-nota).

    IF af-item-contr-estab.log-considera-val-receb THEN do:
        &IF DEFINED(bf_mat_uni_estab) &THEN
            FOR FIRST item-uni-estab
               FIELDS ( lim-var-valor var-val-re-maior)
                WHERE item-uni-estab.it-codigo   = TRIM(af-item-contr-estab.it-codigo)
                  AND item-uni-estab.cod-estabel = TRIM(af-item-contr-estab.cod-estabel) NO-LOCK: END.
            
            IF  NOT AVAIL item-uni-estab
            OR (    AVAIL item-uni-estab
                AND (item-uni-estab.lim-var-valor       = 0
                     OR item-uni-estab.var-val-re-maior = 0 ) ) THEN DO:
                FOR FIRST item-mat
                    FIELDS ( lim-var-valor var-val-re-maior ) 
                    WHERE item-mat.it-codigo = TRIM(af-item-contr-estab.it-codigo) NO-LOCK: END.
            END.
        
            ASSIGN de-var-pct-pre = IF  AVAIL item-uni-estab AND item-uni-estab.var-val-re-maior > 0 THEN item-uni-estab.var-val-re-maior
                                    ELSE item-mat.var-val-re-maior
                                     
                   de-var-lim-pre = IF  AVAIL item-uni-estab AND item-uni-estab.lim-var-valor > 0 THEN item-uni-estab.lim-var-valor
                                    ELSE item-mat.lim-var-valor.
            IF  de-var-pct-pre = 0
            AND de-var-lim-pre = 0  THEN DO:
                /* VerIFica pre‡o maior */
                IF  (p-preco-rec  >  (de-preco-unit * (1 + (de-var-pct-pre / 100))))
                OR  (p-preco-rec  > de-preco-unit + de-var-lim-pre) THEN
                    ASSIGN l-erro = YES.
            END.
            ELSE DO:
                /* VerIFica pre‡o maior */
                IF  p-preco-rec <=  (de-preco-unit * (1 + (de-var-pct-pre / 100)))
                OR  de-var-pct-pre = 0 THEN 
                    IF (p-preco-rec  > de-preco-unit + de-var-lim-pre)
                    AND de-var-lim-pre > 0 THEN
                        ASSIGN l-erro = YES.
                    ELSE
                        ASSIGN l-erro = NO.
                
                ELSE
                    ASSIGN l-erro = YES.
            END.
        &ELSE
            find familia WHERE familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR. 
            ASSIGN de-var-pct-pre = familia.var-val-re-maior.

            /* VerIFica pre‡o maior */
            IF  (p-preco-rec  >  (de-preco-unit * (1 + (de-var-pct-pre / 100)))) THEN
                ASSIGN l-erro = YES.
        &endIF
    END.
    ELSE DO:
        /* VerIFica pre‡o maior */
        IF  (p-preco-rec  >  (de-preco-unit * (1 + (af-item-contr-estab.pct-val-max / 100)))) THEN
            ASSIGN l-erro = YES.
         
        /* VerIFica pre‡o meNOr */
        IF  (p-preco-rec  < (de-preco-unit * (1 - (af-item-contr-estab.pct-val-min / 100)))) THEN
            ASSIGN l-erro = YES.
    END.

    ASSIGN i-tempo[10] = i-tempo[10] + TIME - i-ult-tempo[10].
END PROCEDURE.

PROCEDURE pi-faixa-demerito:
    DEF INPUT PARAM  p-nr-controle LIKE af-controle.nr-controle NO-UNDO.
    DEF INPUT PARAM  p-qtd-correta AS   DEC NO-UNDO.
    DEF INPUT PARAM  p-qtd-real    AS   DEC NO-UNDO.
    DEF OUTPUT PARAM p-resultado   AS   DEC NO-UNDO.
    ASSIGN i-ult-tempo[11] = TIME.

    DEF BUFFER baf-controle FOR af-controle.
    DEF VAR de-demerito-val AS DEC NO-UNDO.
    DEF VAR de-demerito-pct AS DEC NO-UNDO.
    DEF VAR de-var-val      AS DEC NO-UNDO.
    DEF VAR de-var-pct      AS DEC NO-UNDO.

    DEFINE VARIABLE i-versao-percentual AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-versao-valor      AS INTEGER     NO-UNDO.

    ASSIGN de-var-val = ROUND(p-qtd-real - p-qtd-correta,4)
           de-var-pct = ROUND(de-var-val / p-qtd-correta * 100,2).

    ASSIGN de-demerito-val = 100
           de-demerito-pct = 100.

    /* buscar versoes */
    IF AVAIL param-af AND NOT param-af.log-usa-versao OR (param-af.log-usa-versao AND NOT param-af.log-versao-demerito) THEN DO:
        ASSIGN i-versao-valor      = i-menor-versao
               i-versao-percentual = i-menor-versao.
    END.
    ELSE DO: /* utiliza controle de versÆo na faixa de dem‚rito */
        IF NOT VALID-HANDLE(h-boaf010) THEN
             RUN afbo/boaf010.p PERSISTENT SET h-boaf010.
     
        IF AVAIL param-af AND param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
             /* Busca versÆo da faixa por percentual */
             EMPTY TEMP-TABLE tt-item-data.
             RUN piRetornaVersoesData IN h-boaf010(INPUT i-ep-codigo-usuario,
                                                   INPUT p-nr-controle,
                                                   INPUT 1, /* Valor */
                                                   INPUT de-var-val,
                                                   INPUT TABLE tt-versao-data,
                                                   OUTPUT TABLE tt-item-data).
             FOR EACH tt-item-data NO-LOCK:
                IF da-data-ini >= tt-item-data.data-ini AND
                   da-data-fim <= tt-item-data.data-fim THEN DO:
         
                    ASSIGN i-versao-valor = tt-item-data.nr-versao.
                END.
             END.
             IF p-nr-controle <> 4 THEN DO:

                 /* Busca versÆo da faixa por valor */
                 EMPTY TEMP-TABLE tt-item-data.
                 RUN piRetornaVersoesData IN h-boaf010(INPUT i-ep-codigo-usuario,
                                                       INPUT p-nr-controle,
                                                       INPUT 2, /* Percentual */
                                                       INPUT de-var-pct,
                                                       INPUT TABLE tt-versao-data,
                                                       OUTPUT TABLE tt-item-data).
    
                 FOR EACH tt-item-data NO-LOCK:
                    IF da-data-ini >= tt-item-data.data-ini AND
                       da-data-fim <= tt-item-data.data-fim THEN DO:
             
                        ASSIGN i-versao-percentual = tt-item-data.nr-versao.
                    END.
                 END.
            END.
        END.
        ELSE DO: /* controle de validade conforme cadastro de versoes */
            ASSIGN c-periodo-aux = STRING(MONTH(da-data-fim)) + "/" + STRING(YEAR(da-data-fim)).
            RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT c-periodo-aux,
                                                    INPUT i-ep-codigo-usuario,
                                                    OUTPUT i-versao-percentual).

            ASSIGN i-versao-valor = i-versao-percentual.

        END.
    END.
    /* fim - buscar versoes */
    FIND FIRST af-faixa-demerito 
         WHERE af-faixa-demerito.ep-codigo = i-ep-codigo-usuario 
           AND af-faixa-demerito.nr-controle = p-nr-controle
           AND af-faixa-demerito.ind-tipo-valor = 1
           AND af-faixa-demerito.lim-inicial <= de-var-val 
           AND af-faixa-demerito.lim-final   >= de-var-val
           AND af-faixa-demerito.nr-versao = i-versao-valor NO-LOCK NO-ERROR.

    IF AVAIL af-faixa-demerito THEN
       ASSIGN de-demerito-val = af-faixa-demerito.demerito
                   i-ind-tipo = 1.
    IF p-nr-controle <> 4 THEN do:
        FIND FIRST af-faixa-demerito 
             WHERE af-faixa-demerito.ep-codigo = i-ep-codigo-usuario 
               AND af-faixa-demerito.nr-controle = p-nr-controle
               AND af-faixa-demerito.ind-tipo-valor = 2
               AND af-faixa-demerito.lim-inicial <= de-var-pct 
               AND af-faixa-demerito.lim-final   >= de-var-pct 
               AND af-faixa-demerito.nr-versao = i-versao-percentual NO-LOCK NO-ERROR.
        IF AVAIL af-faixa-demerito THEN
           ASSIGN de-demerito-pct = af-faixa-demerito.demerito
                       i-ind-tipo = 2.
    END.
    ELSE
       ASSIGN de-demerito-pct = 0.
    
    ASSIGN p-resultado = 0.
    IF i-ind-tipo = 1 THEN
        ASSIGN p-resultado = 1 - (de-demerito-val / 100).
    ELSE IF i-ind-tipo = 2 THEN
        ASSIGN p-resultado = 1 - (de-demerito-pct / 100).

    ASSIGN i-tempo[11] = i-tempo[11] + TIME - i-ult-tempo[11].
END PROCEDURE.


PROCEDURE pi-programa-especIFico:
    DEF VAR de-indice-param   LIKE af-contr-indice.indice    NO-UNDO.
    DEF VAR c-narrativa-param LIKE af-contr-indice.narrativa NO-UNDO.
    DEF VAR l-gera-nota       AS LOG NO-UNDO.
    ASSIGN i-ult-tempo[16] = TIME.
    
    FIND af-contr-indice WHERE 
         af-contr-indice.ep-codigo    = i-ep-codigo-usuario AND
         af-contr-indice.nr-controle  = af-item-contr-estab-form.nr-controle AND
         af-contr-indice.dt-indice    = da-dt-indice AND
         af-contr-indice.it-codigo    = TRIM(af-item-contr-estab.it-codigo) AND
         af-contr-indice.cod-emitente = af-item-contr-estab.cod-emitente AND
         af-contr-indice.cod-estabel  = TRIM(af-item-contr-estab.cod-estabel) AND
         af-contr-indice.nr-versao    = af-item-contr-estab.nr-versao 
          NO-LOCK NO-ERROR.

    IF AVAIL af-contr-indice THEN
        ASSIGN de-indice-param   = af-contr-indice.indice
               c-narrativa-param = af-contr-indice.narrativa.

    IF af-controle.programa <> "" THEN do:
            RUN VALUE(af-controle.programa) 
                     (INPUT af-item-contr-estab-form.ep-codigo,
                      INPUT af-item-contr-estab-form.cod-estabel,
                      INPUT af-item-contr-estab-form.cod-emitente,
                      INPUT af-item-contr-estab-form.nr-versao,
                      INPUT af-item-contr-estab-form.it-codigo,
                      INPUT af-item-contr-estab-form.nr-controle,
                      INPUT da-dt-indice,
                      INPUT da-data-fim,
                      INPUT-OUTPUT de-indice-param,
                      INPUT-OUTPUT c-narrativa-param,
                      INPUT-OUTPUT TABLE tt-erro,
                      OUTPUT l-gera-nota).
            
        IF l-gera-nota THEN DO:
           IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
              ASSIGN de-nota = de-indice-param.
              IF de-nota < 0 THEN de-nota = 0.
              ELSE IF de-nota > 100 THEN de-nota = 100.
              
              RUN pi-grava-nota (INPUT af-item-contr-estab-form.nr-controle,
                                 INPUT 0,
                                 INPUT c-narrativa-param,
                                 INPUT NO,
                                 INPUT af-item-contr-estab-form.percentual,
                                 INPUT af-item-contr-estab.nr-versao).
           END.
        END.
    END.

    ASSIGN i-tempo[16] = i-tempo[16] + TIME - i-ult-tempo[16].
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-ponto-formula:
    ASSIGN i-ult-tempo[12] = TIME.
    
    DEF VAR de-indice-param   LIKE af-contr-indice.indice    NO-UNDO.
    DEF VAR c-narrativa-param LIKE af-contr-indice.narrativa NO-UNDO.
    DEF VAR p-i-nr-versao     AS INT                         NO-UNDO.
    DEF VAR i-nr-controle-aux LIKE af-item-contr-estab-form.nr-controle NO-UNDO.
    DEF VAR d-percentual-aux  LIKE af-item-contr-estab-form.percentual  NO-UNDO.

    /* buscar versoes */

    IF AVAIL param-af AND NOT param-af.log-usa-versao OR (param-af.log-usa-versao AND NOT param-af.log-versao-formula) THEN DO: 
        ASSIGN i-nr-versao = i-menor-versao.
    END.
    ELSE DO:

        IF NOT VALID-HANDLE(h-boaf013) THEN
             RUN afbo/boaf013.p PERSISTENT SET h-boaf013.
     
        IF AVAIL param-af AND param-af.log-usa-versao THEN DO:
            IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
             
                 RUN piRetornaVersoesData IN h-boaf013(INPUT i-ep-codigo-usuario,
                                                       INPUT af-controle.cod-formula,
                                                       INPUT TABLE tt-versao-data,
                                                       OUTPUT TABLE tt-item-data).

                 FOR EACH tt-item-data NO-LOCK:
                    IF da-data-ini >= tt-item-data.data-ini AND
                       da-data-fim <= tt-item-data.data-fim THEN DO:
             
                        ASSIGN i-nr-versao = tt-item-data.nr-versao.
                    END.
                 END.
            END.
            ELSE DO: /* controle de validade conforme cadastro de versoes */
               ASSIGN c-periodo-aux = STRING(MONTH(da-data-fim)) + "/" + STRING(YEAR(da-data-fim)).
               RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT c-periodo-aux,
                                                       INPUT i-ep-codigo-usuario,
                                                       OUTPUT i-nr-versao).
            END.
        END.
    END.
    /* fim buscar versao*/ 

    ASSIGN i-nr-controle-aux = af-item-contr-estab-form.nr-controle
           d-percentual-aux  = af-item-contr-estab-form.percentual.

    FIND af-contr-indice 
         WHERE af-contr-indice.ep-codigo    = i-ep-codigo-usuario 
         AND   af-contr-indice.nr-controle  = af-item-contr-estab-form.nr-controle
         AND   af-contr-indice.dt-indice    = da-dt-indice 
         AND   af-contr-indice.it-codigo    = TRIM(af-item-contr-estab.it-codigo) 
         AND   af-contr-indice.cod-emitente = af-item-contr-estab.cod-emitente 
         AND   af-contr-indice.cod-estabel  = TRIM(af-item-contr-estab.cod-estabel)
         NO-LOCK NO-ERROR.
    IF AVAIL af-contr-indice THEN
       ASSIGN de-indice-param   = af-contr-indice.indice
              c-narrativa-param = af-contr-indice.narrativa.

    RUN pi-calcular-formula (INPUT  af-controle.cod-formula,
                             INPUT  af-item-contr-estab-form.nr-controle,
                             INPUT  i-nr-versao,
                             OUTPUT de-indice-param,
                             OUTPUT c-narrativa-param).

    IF RETURN-VALUE <> "NOK":U THEN DO:
        ASSIGN de-nota = de-indice-param.
        IF de-nota < 0 THEN de-nota = 0.
        ELSE IF de-nota > 100 THEN de-nota = 100.

        RUN pi-grava-nota (INPUT i-nr-controle-aux, /*af-item-contr-estab-form.nr-controle*/
                           INPUT af-controle.cod-formula,
                           INPUT c-narrativa-param,
                           INPUT NO,
                           INPUT d-percentual-aux, /*af-item-contr-estab-form.percentual*/
                           INPUT i-versao-formula).
    END.

    ASSIGN i-tempo[12] = i-tempo[12] + TIME - i-ult-tempo[12].
   
END PROCEDURE.

PROCEDURE pi-cria-variavel:
    
    ASSIGN i-ult-tempo[13] = TIME.

    EMPTY TEMP-TABLE tt-af-var.

    FOR EACH af-item-contr-estab-form 
       WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
         AND af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
         AND af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
         AND af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel
         AND af-item-contr-estab-form.nr-controle >=  tt-param.i-nr-controle-ini 
         AND af-item-contr-estab-form.nr-controle <=  tt-param.i-nr-controle-fim
         AND af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao NO-LOCK:   

        FOR EACH tt-af-var-aux
            WHERE tt-af-var-aux.nr-controle = af-item-contr-estab-form.nr-controle:
            FIND FIRST tt-af-var
                WHERE tt-af-var.cod-variavel = tt-af-var-aux.cod-variavel NO-ERROR.

            IF NOT AVAIL tt-af-var THEN DO:
               CREATE tt-af-var.
               ASSIGN tt-af-var.cod-variavel = tt-af-var-aux.cod-variavel.
            END.
            ASSIGN tt-af-var.descricao      = tt-af-var-aux.descricao 
                   tt-af-var.padrao         = tt-af-var-aux.padrao 
                   tt-af-var.log-especifico = tt-af-var-aux.log-especifico 
                   tt-af-var.programa       = tt-af-var-aux.programa
                   tt-af-var.valor          = 0.

            IF tt-af-var.log-especifico THEN DO:
               RUN VALUE(tt-af-var.programa) 
                        (INPUT af-item-contr-estab-form.ep-codigo,
                         INPUT af-item-contr-estab-form.cod-estabel,
                         INPUT af-item-contr-estab-form.cod-emitente,
                         INPUT af-item-contr-estab-form.nr-versao,
                         INPUT af-item-contr-estab-form.it-codigo,
                         INPUT af-item-contr-estab-form.nr-controle,
                         INPUT da-data-ini,
                         INPUT da-data-fim,
                         INPUT-OUTPUT de-valor,
                         INPUT-OUTPUT c-narrativa).
               ASSIGN tt-af-var.valor     = de-valor
                      tt-af-var.narrativa = c-narrativa.
            END.
            ELSE DO:
               FOR FIRST af-variavel-valor FIELD(valor narrativa)
                   WHERE af-variavel-valor.ep-codigo        = i-ep-codigo-usuario
                   AND   af-variavel-valor.cod-variavel     = tt-af-var.cod-variavel
                   AND   af-variavel-valor.dt-ini-validade <= da-data-ini
                   AND   af-variavel-valor.dt-fim-validade >= da-data-fim
                   NO-LOCK: END.
               IF AVAIL af-variavel-valor THEN 
                  ASSIGN tt-af-var.valor     = af-variavel-valor.valor
                         tt-af-var.narrativa = af-variavel-valor.narrativa.
               ELSE
                  ASSIGN tt-af-var.valor     = 0
                         tt-af-var.narrativa = "NÆo foi localizado um valor v lido para a vari vel".
            END.
        END.
    END.
    ASSIGN l-devol-cq = NO
           l-receb-cq = NO.
    FOR EACH tt-af-var
        WHERE tt-af-var.padrao = YES:
        IF tt-af-var.cod-variavel = "PCQ00011" OR /* N£mero Total notas Fiscais Devolu‡Æo */
           tt-af-var.cod-variavel = "PCQ00010" OR /* N£mero Devolu‡Æo sem CQ */
           tt-af-var.cod-variavel = "PCQ00005" OR /* Quantidade Devolvida sem CQ */
           tt-af-var.cod-variavel = "PCQ00006"    /* Quantidade Devolvida Total */
           THEN ASSIGN l-devol-cq = YES.

        IF tt-af-var.cod-variavel = "PCQ00001" OR /* Quantidade Aprovada CQ */
           tt-af-var.cod-variavel = "PCQ00002" OR /* Quantidade Perda CQ */
           tt-af-var.cod-variavel = "PCQ00003" OR /* Quantidade Aprovada Condicional CQ */
           tt-af-var.cod-variavel = "PCQ00004" OR /* Quantidade Rejeitada CQ*/
           tt-af-var.cod-variavel = "PCQ00007" OR /* Quantidade Recebida Total */
           tt-af-var.cod-variavel = "PCQ00008" OR /* N£mero Total Roteiro Inspe‡Æo */
           tt-af-var.cod-variavel = "PCQ00009"    /* N£mero Total Recebimento */
           THEN ASSIGN l-receb-cq = YES.

    END.
    ASSIGN i-tempo[13] = i-tempo[13] + TIME - i-ult-tempo[13].
END PROCEDURE.


PROCEDURE pi-calcular-formula:
    DEF INPUT  PARAM p-cod-formula LIKE af-controle.cod-formula NO-UNDO.
    DEF INPUT  PARAM p-nr-controle LIKE af-controle.nr-controle NO-UNDO.
    DEF INPUT  PARAM p-nr-versao   LIKE af-formula.nr-versao    NO-UNDO.
    DEF OUTPUT PARAM p-valor       AS   DECIMAL                 NO-UNDO.
    DEF OUTPUT PARAM p-narrativa   LIKE af-controle.narrativa   NO-UNDO.

    ASSIGN i-ult-tempo[15] = TIME.
    
    DEF VAR c-formula        LIKE af-formula.expressao NO-UNDO.
    DEF VAR c-desc           LIKE af-formula.narrativa NO-UNDO.
    
    EMPTY TEMP-TABLE tt-formula.

    /* Procura versÆo correta da f¢rmula */
    IF AVAIL param-af AND NOT param-af.log-usa-versao OR (param-af.log-usa-versao AND NOT param-af.log-versao-formula) THEN DO:
        ASSIGN i-versao-formula = i-menor-versao.
    END.
    ELSE DO:

        IF NOT VALID-HANDLE(h-boaf013) THEN
             RUN afbo/boaf013.p PERSISTENT SET h-boaf013.
     
        IF AVAIL param-af AND param-af.log-usa-versao THEN DO:
            IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
             
                 RUN piRetornaVersoesData IN h-boaf013(INPUT i-ep-codigo-usuario,
                                                       INPUT p-cod-formula,
                                                       INPUT TABLE tt-versao-data,
                                                       OUTPUT TABLE tt-item-data).
                 FOR EACH tt-item-data NO-LOCK:
                    IF da-data-ini >= tt-item-data.data-ini AND
                       da-data-fim <= tt-item-data.data-fim THEN DO:
             
                        ASSIGN i-versao-formula = tt-item-data.nr-versao.
                    END.
                 END.
            END.
            ELSE DO: /* controle de validade conforme cadastro de versoes */
               ASSIGN c-periodo-aux = STRING(MONTH(da-data-fim)) + "/" + STRING(YEAR(da-data-fim)).
                   
               RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT c-periodo-aux,
                                                       INPUT i-ep-codigo-usuario,
                                                       OUTPUT i-versao-formula).
            END.
        END.
    END.

    FOR FIRST af-formula FIELDS(expressao ep-codigo cod-formula nr-versao)
        WHERE af-formula.ep-codigo = i-ep-codigo-usuario
        AND   af-formula.cod-formula = p-cod-formula 
        AND   af-formula.nr-versao   = i-versao-formula NO-LOCK:
    END.

    IF AVAIL af-formula THEN 
        ASSIGN c-formula = af-formula.expressao.
    ELSE DO: 
        ASSIGN c-formula = "".
        RETURN "NOK":U.
    END.

    ASSIGN c-formula = REPLACE (c-formula,chr(13), " ")
           c-formula = REPLACE (c-formula,chr(10), " ")
           c-formula = REPLACE (c-formula,"~r", " ").

    CASE af-formula.cod-formula:
        WHEN 1 THEN ASSIGN l-var-qualidade  = YES.
        WHEN 2 THEN ASSIGN l-var-quantidade = YES.
        WHEN 3 THEN ASSIGN l-var-preco      = YES.
        WHEN 4 THEN ASSIGN l-var-data       = YES.
    END CASE.

    DEFINE BUFFER bf-tt-af-var-aux FOR tt-af-var-aux.

    FOR EACH bf-tt-af-var-aux
        WHERE bf-tt-af-var-aux.nr-controle = p-nr-controle
          AND bf-tt-af-var-aux.nr-versao   = i-versao-formula:

        FIND FIRST tt-af-var
            WHERE tt-af-var.cod-variavel = bf-tt-af-var-aux.cod-variavel NO-LOCK NO-ERROR.

        IF AVAIL tt-af-var THEN 
            FOR FIRST af-variavel FIELD(cod-variavel descricao padrao)
                WHERE af-variavel.ep-codigo    = i-ep-codigo-usuario
                AND   af-variavel.cod-variavel = tt-af-var.cod-variavel
                NO-LOCK: END.

        /*Calcular variaveis padräes quANDo utilizado em formulas nÆo padräes*/
        IF AVAIL af-formula AND 
           AVAIL af-variavel AND 
           af-formula.cod-formula > 4 AND  /*formula nÆo padrao*/
           af-variavel.padrao THEN DO:     /*variavel padrao*/

            IF (af-variavel.cod-variavel BEGINS "PCQ"   AND NOT l-var-qualidade)  OR  /*variavel de qualidade*/
               (af-variavel.cod-variavel BEGINS "PNRQT" AND NOT l-var-quantidade) OR  /*variavel de quantidade*/
               (af-variavel.cod-variavel BEGINS "PNRPR" AND NOT l-var-preco)      OR  /*variavel de preco*/
               (af-variavel.cod-variavel BEGINS "PNRDT" AND NOT l-var-data)  THEN DO: /*variavel de data*/
                ASSIGN l-var-qualidade  = YES
                       l-var-quantidade = YES
                       l-var-preco      = YES
                       l-var-data       = YES.
                RUN pi-calcula-ponto-padrao.
                ASSIGN l-var-qualidade  = NO
                       l-var-quantidade = NO
                       l-var-preco      = NO
                       l-var-data       = NO.
            END.
        END.

        FIND FIRST tt-af-var
             WHERE tt-af-var.cod-variavel = bf-tt-af-var-aux.cod-variavel NO-LOCK NO-ERROR.

        IF AVAIL tt-af-var THEN
            FIND FIRST tt-var
                 WHERE tt-var.nome = tt-af-var.cod-variavel EXCLUSIVE-LOCK NO-ERROR.
        ELSE
            NEXT.

        IF NOT AVAIL tt-var THEN 
            CREATE tt-var.

        ASSIGN tt-var.nome  = tt-af-var.cod-variavel
               tt-var.valor = tt-af-var.valor
               tt-var.tipo-res = 1.

        IF c-formula MATCHES("*" + bf-tt-af-var-aux.cod-variavel + "*") THEN DO:
            ASSIGN c-desc = af-variavel.cod-variavel + " - " + af-variavel.descricao.

            DO WHILE LENGTH(c-desc) <= 64:
               ASSIGN c-desc = c-desc + ".".
            END.

            ASSIGN p-narrativa = p-narrativa + c-desc + ": " + STRING(tt-af-var.valor,">>>,>>>,>>9.99") + "~r~n".
        END.
    END.

    FIND FIRST tt-formula EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL tt-formula THEN
        ASSIGN tt-formula.formula = c-formula.
    ELSE DO:
        CREATE tt-formula.
        ASSIGN tt-formula.sequencia = 1
               tt-formula.cod-versao-integracao = 1
               tt-formula.formula = c-formula. 
    END.

    /* ComANDo necess rio para que o registro da tt-formula esteja dispon¡vel na cdapi020b */
    RELEASE tt-formula.

    IF NOT VALID-HANDLE(h-cdapi020b) THEN
        RUN cdp/cdapi020b.p PERSISTENT SET h-cdapi020b (INPUT-OUTPUT TABLE tt-formula,
                                                        INPUT-OUTPUT TABLE tt-erro,
                                                        NO).
    /*huberto*/
    RUN pi-processa-formulas in h-cdapi020b (INPUT-OUTPUT TABLE tt-formula,
                                             INPUT-OUTPUT TABLE tt-erro,
                                             INPUT        NO).
   
    /*delete PROCEDURE h-cdapi020b.*/

    FIND FIRST tt-formula NO-ERROR.
    IF AVAIL tt-formula THEN
       ASSIGN p-valor = tt-formula.result.
    ELSE ASSIGN p-valor = 0.

    ASSIGN i-tempo[15] = i-tempo[15] + TIME - i-ult-tempo[15].
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-excecao-pedido:
    DEF INPUT PARAM p-num-pedido   LIKE ordem-compra.num-pedido   NO-UNDO.
    DEF INPUT PARAM p-ordem-compra LIKE ordem-compra.numero-ordem NO-UNDO.
    DEF INPUT PARAM p-parcela      LIKE prazo-compra.parcela      NO-UNDO.

    /* Procura exce‡Æo exata */

    IF CAN-FIND (FIRST af-excecao
                 WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                 AND   af-excecao.ind-tipo-doc = 1
                 AND   af-excecao.num-pedido   = ordem-compra.num-pedido
                 AND   af-excecao.numero-ordem = ordem-compra.numero-ordem
                 AND   af-excecao.parcela      = prazo-compra.parcela) THEN RETURN "NOK".

    /* Procura exce‡Æo gen‚rica, para todo documento */
    IF CAN-FIND (FIRST af-excecao
                 WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                 AND   af-excecao.ind-tipo-doc = 1
                 AND   af-excecao.num-pedido   = ordem-compra.num-pedido
                 AND   af-excecao.numero-ordem = ordem-compra.numero-ordem
                 AND   af-excecao.parcela      = 0) THEN RETURN "NOK".

    /* Procura exce‡Æo gen‚rica, para todo documento */
    IF CAN-FIND (FIRST af-excecao
                 WHERE af-excecao.ep-codigo    = i-ep-codigo-usuario
                 AND   af-excecao.ind-tipo-doc = 1
                 AND   af-excecao.num-pedido   = ordem-compra.num-pedido
                 AND   af-excecao.numero-ordem = 0
                 AND   af-excecao.parcela      = 0) THEN RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-converte-preco-ordem:
    DEF INPUT PARAM p-preco-unit     LIKE ordem-compra.preco-unit NO-UNDO.
    DEF INPUT PARAM p-data-conversao AS DATE                    NO-UNDO.

    ASSIGN de-preco-unit = p-preco-unit.
    
    IF ordem-compra.mo-codigo <> 0 THEN DO:
        RUN cdp/cd0812.p (INPUT  ordem-compra.mo-codigo,
                          INPUT  0,
                          INPUT  de-preco-unit,
                          INPUT  p-data-conversao,
                          OUTPUT de-preco-unit).
    END.
      
    ASSIGN de-preco-unit = ROUND(de-preco-unit,4). 

END PROCEDURE.


PROCEDURE pi-grava-detalhe:
    DEF INPUT PARAM p-nr-controle  LIKE af-contr-indice.nr-controle  NO-UNDO.
    DEF INPUT PARAM p-tipo-trans   AS   INT                          NO-UNDO.
    DEF INPUT PARAM p-serie        LIKE item-doc-est.serie-docto     NO-UNDO.
    DEF INPUT PARAM p-nro-docto    LIKE item-doc-est.nro-docto       NO-UNDO.
    DEF INPUT PARAM p-nat-oper     LIKE item-doc-est.nat-operacao    NO-UNDO.
    DEF INPUT PARAM p-sequencia    LIKE item-doc-est.sequencia       NO-UNDO.
    DEF INPUT PARAM p-lote         LIKE af-contr-indice-mov.lote     NO-UNDO.
    DEF INPUT PARAM p-dt-movto     AS   DATE                         NO-UNDO.
    DEF INPUT PARAM p-qtd-cq-apr   AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-cq-con   AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-cq-rej   AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-cq-per   AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-rec      AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-dev      AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-qtd-dev-cq   AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-nr-ficha     LIKE item-doc-est.nr-ficha        NO-UNDO.
    DEF INPUT PARAM p-demerito     LIKE af-item-contr-estab.demerito NO-UNDO.
    DEF INPUT PARAM p-pedido       LIKE ordem-compra.num-pedido      NO-UNDO.
    DEF INPUT PARAM p-ordem-compra LIKE prazo-compra.numero-ordem    NO-UNDO.
    DEF INPUT PARAM p-parcela      LIKE prazo-compra.parcela         NO-UNDO.
    DEF INPUT PARAM p-qtd-parcela  LIKE prazo-compra.quantidade      NO-UNDO.
    DEF INPUT PARAM p-correto      AS   LOG                          NO-UNDO.
    DEF INPUT PARAM p-pct-erro     AS   DEC                          NO-UNDO.
    DEF INPUT PARAM p-preco-rec    LIKE recebimento.preco-unit       NO-UNDO.
    DEF INPUT PARAM p-preco-ord    LIKE ordem-compra.preco-unit      NO-UNDO.
    
    ASSIGN i-ult-tempo[17] = TIME.

    DEF VAR i-seq AS INT INIT 1 NO-UNDO.

    FOR LAST af-contr-indice-mov FIELDS (nr-trans) USE-INDEX ep-trans
        WHERE af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario NO-LOCK:
        ASSIGN i-seq = af-contr-indice-mov.nr-trans + 1.
    END.
    
    DO TRANSACTION:
        CREATE af-contr-indice-mov.
        ASSIGN af-contr-indice-mov.nr-trans       = i-seq
               af-contr-indice-mov.ep-codigo      = i-ep-codigo-usuario
               af-contr-indice-mov.cod-emitente   = af-item-contr-estab.cod-emitente
               af-contr-indice-mov.cod-estabel    = af-item-contr-estab.cod-estabel
               af-contr-indice-mov.it-codigo      = af-item-contr-estab.it-codigo 
               af-contr-indice-mov.nr-controle    = p-nr-controle
               af-contr-indice-mov.dt-indice      = da-dt-indice
               af-contr-indice-mov.serie-docto    = p-serie
               af-contr-indice-mov.nro-docto      = p-nro-docto
               af-contr-indice-mov.nat-operacao   = p-nat-oper
               af-contr-indice-mov.sequencia      = p-sequencia
               af-contr-indice-mov.lote           = p-lote
               af-contr-indice-mov.dt-movto       = p-dt-movto
               af-contr-indice-mov.qtd-apr        = p-qtd-cq-apr
               af-contr-indice-mov.qtd-con        = p-qtd-cq-con
               af-contr-indice-mov.qtd-rej        = p-qtd-cq-rej
               af-contr-indice-mov.qtd-per        = p-qtd-cq-per
               af-contr-indice-mov.qtd-rec        = p-qtd-rec
               af-contr-indice-mov.qtd-dev        = p-qtd-dev
               af-contr-indice-mov.qtd-dev-cq     = p-qtd-dev-cq
               af-contr-indice-mov.nr-ficha       = p-nr-ficha
               af-contr-indice-mov.demerito       = p-demerito
               af-contr-indice-mov.tipo-trans     = p-tipo-trans
               af-contr-indice-mov.num-pedido     = p-pedido
               af-contr-indice-mov.numero-ordem   = p-ordem-compra
               af-contr-indice-mov.parcela        = p-parcela
               af-contr-indice-mov.qtd-parcela    = p-qtd-parcela
               af-contr-indice-mov.correto        = p-correto
               af-contr-indice-mov.pct-erro       = p-pct-erro
               af-contr-indice-mov.preco-unit-rec = p-preco-rec
               af-contr-indice-mov.preco-unit-ord = p-preco-ord
               af-contr-indice-mov.dt-implantacao = TODAY
               af-contr-indice-mov.dt-alter       = TODAY
               af-contr-indice-mov.usuar-alter    = c-seg-usuario
               af-contr-indice-mov.hora-alter     = STRING(TIME,"HH:MM:SS")
               af-contr-indice-mov.un             = ITEM.un. 
    END.

    ASSIGN i-tempo[17] = i-tempo[17] + TIME - i-ult-tempo[17].

        
END PROCEDURE.

PROCEDURE pi-carrega-tt-var-aux:

    DEFINE INPUT PARAM p-nr-controle AS INTEGER NO-UNDO.

    FOR EACH af-formula FIELDS(expressao nr-versao)
        WHERE af-formula.ep-codigo = i-ep-codigo-usuario
        AND   af-formula.cod-formula = af-controle.cod-formula 
        NO-LOCK:

        ASSIGN c-formula = af-formula.expressao
               c-formula = REPLACE (c-formula,chr(13), " ")
               c-formula = REPLACE (c-formula,chr(10), " ")
               c-formula = REPLACE (c-formula,"~r", " ").

        IF NOT VALID-HANDLE(h-cdapi020b) THEN
            RUN cdp/cdapi020b.p PERSISTENT SET h-cdapi020b (INPUT-OUTPUT TABLE tt-formula,
                                                            INPUT-OUTPUT TABLE tt-erro,
                                                            NO).

        RUN pi-retorna-variaveis in h-cdapi020b (INPUT c-formula,
                                                 OUTPUT TABLE tt-var).
        
        /*delete PROCEDURE h-cdapi020b.*/
        
        FOR EACH tt-var NO-LOCK:
            
            FIND FIRST tt-af-var-aux
                 WHERE tt-af-var-aux.cod-variavel = tt-var.nome 
                   AND tt-af-var-aux.nr-controle  = af-controle.nr-controle
                   AND tt-af-var-aux.nr-versao    = af-formula.nr-versao NO-ERROR.

            IF NOT AVAIL tt-af-var-aux THEN DO:
                FIND af-variavel
                    WHERE af-variavel.ep-codigo    = i-ep-codigo-usuario
                      AND af-variavel.cod-variavel = tt-var.nome NO-LOCK NO-ERROR.

                IF AVAIL af-variavel THEN DO:
                    CREATE tt-af-var-aux.
                    ASSIGN tt-af-var-aux.cod-variavel = tt-var.nome
                         tt-af-var-aux.nr-controle    = af-controle.nr-controle
                         tt-af-var-aux.descricao      = af-variavel.descricao 
                         tt-af-var-aux.padrao         = af-variavel.padrao 
                         tt-af-var-aux.log-especifico = af-variavel.log-especifico 
                         tt-af-var-aux.programa       = af-variavel.programa
                         tt-af-var-aux.valor          = 0
                         tt-af-var-aux.nr-versao      = af-formula.nr-versao.
               END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
