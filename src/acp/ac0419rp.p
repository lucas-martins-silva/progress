/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0419RP 2.00.00.011} /*** "010011" 22/05/2025 16:59:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0419rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
***
*** AC0419 - Demonstrativo de Cotas 
***
*******************************************************************************/
{cdp/cdcfgdis.i}

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{acp/ac0419.i}

/*defini‡Æo da temp table tt-dados*/
{acp/acapi100.i} 

def temp-table tt-raw-digita
        field raw-digita	as raw.

def var h-bodi261 as handle.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEF BUFFER b-it-nota-fisc FOR it-nota-fisc.

DEF TEMP-TABLE tt-dados-nota NO-UNDO LIKE tt-dados 
    FIELD de-qt-fat-canc  LIKE  cotas.qt-fat-canc
    FIELD de-vl-fat-canc  LIKE  cotas.vl-fat-canc
    FIELD de-qt-prevista  LIKE  cotas.qt-prevista
    FIELD de-vl-previsto  LIKE  cotas.vl-previsto
    FIELD de-qt-faturada  LIKE  cotas.qt-faturada
    FIELD de-vl-faturado  LIKE  cotas.vl-faturado.

DEF TEMP-TABLE tt-dados-aux NO-UNDO
    FIELD cod-estabel     LIKE estabelec.cod-estabel
    FIELD tipo-cota       AS   CHAR
    FIELD nome-abrev-rep  LIKE repres.nome-abrev
    FIELD it-codigo       LIKE ITEM.it-codigo
    FIELD cod-rep         LIKE cotas.cod-rep
    FIELD de-qt-vl-aux-fat-canc  LIKE cotas.qt-fat-canc FORMAT "->>>,>>>,>>9.9999"
    FIELD de-qt-vl-aux-faturada  LIKE cotas.qt-faturada FORMAT "->>>,>>>,>>9.9999".

DEF TEMP-TABLE tt-item
    FIELDS it-codigo AS CHAR
    INDEX codigo it-codigo.

DEFINE VARIABLE c-situacao      AS CHARACTER  LABEL "Situa‡Æo"  NO-UNDO.
DEFINE VARIABLE c-tipo-cota     AS CHARACTER  LABEL "Tipo Cota" NO-UNDO.
DEFINE VARIABLE c-it-original   AS CHARACTER  FORMAT "x(40)"    NO-UNDO.
DEFINE VARIABLE c-it-codigo-res AS CHARACTER  FORMAT "x(40)"    NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-classificacao AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-item-faixa    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE de-qt-vl-prevista  AS DECIMAL LABEL "Previstas"  INIT 0 FORMAT "->>>,>>>,>>9.9999"  NO-UNDO.
DEFINE VARIABLE de-qt-vl-faturada  AS DECIMAL LABEL "Realizadas" INIT 0 FORMAT "->>>,>>>,>>9.9999"  NO-UNDO.
DEFINE VARIABLE de-qt-vl-fat-canc  AS DECIMAL LABEL "Canceladas" INIT 0 FORMAT "->>>,>>>,>>9.9999"  NO-UNDO.


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}

def var h-acomp as handle        no-undo.
{include/i-rpout.i}
{include/i-rpcab.i}

FORM nota-fiscal.cod-estabel  LABEL "Estab" SPACE(2)
     nota-fiscal.serie        SPACE(2)
     nota-fiscal.nr-nota-fis  SPACE(2)
     nota-fiscal.dt-emis-nota SPACE(2)
     c-situacao  SKIP(1)
     WITH NO-BOX SIDE-LABELS WIDTH 132 STREAM-IO FRAME f-cab-est. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-est:HANDLE).

    /*WITH NO-BOX STREAM-IO NO-LABEL WIDTH 132 FRAME f-cab-est.*/

FORM tt-dados-nota.nome-abrev   LABEL "Cliente" AT 01
     tt-dados-nota.cod-canal-venda COLON 70 
     tt-dados-nota.nome-ab-reg  COLON 95 SKIP
     repres.nome-abrev          AT 01 LABEL "Repres."
     tt-dados-nota.cod-gr-cli COLON 70 
     tt-dados-nota.nome-mic-reg COLON 95 SKIP
     c-tipo-cota                AT 01 SKIP(1)
     WITH NO-BOX SIDE-LABELS WIDTH 132 STREAM-IO FRAME f-cab-emit. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-emit:HANDLE).

     /*WITH NO-BOX STREAM-IO NO-LABEL WIDTH 132 FRAME f-cab-emit.*/

FORM c-it-original                 COLUMN-LABEL "Item"
     tt-dados-nota.it-codigo       COLUMN-LABEL "Prod Coml"
     de-qt-vl-prevista             COLUMN-LABEL "Prevista"
     de-qt-vl-faturada             COLUMN-LABEL "Realizadas"
     de-qt-vl-fat-canc             COLUMN-LABEL "Canceladas"  
     WITH NO-BOX STREAM-IO 40 DOWN WIDTH 132 FRAME f-item. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item:HANDLE).
 

FORM  tt-dados-aux.cod-estabel LABEL "Estab" SPACE "-" SPACE
      estabelec.nome NO-LABEL SPACE(2)
      tt-dados-aux.tipo-cota LABEL "Tipo Cota" SKIP(1)
      WITH NO-BOX SIDE-LABELS WIDTH 132 STREAM-IO FRAME f-cab-resumo. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumo:HANDLE).

     /*WITH NO-BOX STREAM-IO NO-LABEL WIDTH 132 FRAME f-cab-resumo.*/

FORM tt-dados-aux.nome-abrev-rep  COLUMN-LABEL "Representante" 
     c-it-codigo-res              COLUMN-LABEL "Item/Produto Comercial"
     de-qt-vl-prevista            COLUMN-LABEL "Prevista"
     de-qt-vl-aux-faturada        COLUMN-LABEL "Realizadas" 
     de-qt-vl-aux-fat-canc        COLUMN-LABEL "Canceladas" 
     WITH NO-BOX STREAM-IO 40 DOWN WIDTH 132 FRAME f-rep-resumo. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-rep-resumo:HANDLE).
 

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */
if tt-param.classificacao = 1 then 
    assign c-classificacao = 'Item'. 
else if tt-param.classificacao = 2 then 
    assign c-classificacao = 'Produto'.
else
    assign c-classificacao = 'Ambos'.


FORM SKIP(01)
     "SELE€ÇO"                      COLON 45  SKIP(1)
     tt-param.cod-estabel-ini       COLON 40 SPACE(14) "|< >|"
     tt-param.cod-estabel-fim    NO-LABEL COLON 73 SKIP
     tt-param.serie-ini             COLON 40 SPACE(12) "|< >|"
     tt-param.serie-fim          NO-LABEL COLON 73 SKIP
     tt-param.nr-nota-fis-ini       COLON 40 SPACE(1) "|< >|"
     tt-param.nr-nota-fis-fim    NO-LABEL COLON 73 SKIP
     tt-param.dt-emis-nota-ini      COLON 40 SPACE(7)  "|< >|"
     tt-param.dt-emis-nota-fim   NO-LABEL COLON 73 SKIP     
     tt-param.it-codigo-ini         COLON 40 SPACE(01) "|< >|"
     tt-param.it-codigo-fim      NO-LABEL COLON 73 SKIP
     tt-param.no-ab-reppri-ini      COLON 40 SPACE(05) "|< >|"
     tt-param.no-ab-reppri-fim   NO-LABEL COLON 73 SKIP(1)

     "PAR¶METROS"                   COLON 45 SKIP(1)
     tt-param.imp-resumo            LABEL "Imprime Resumo" FORMAT "Sim/NÆo" COLON 40 
     c-classificacao                LABEL "Forma de Leitura" COLON 40 SKIP(1)
     "IMPRESSÇO"                    COLON 45 SKIP(1)
     c-destino                      LABEL "Destino" COLON 40
     " - ":U
     tt-param.arquivo            NO-LABEL FORMAT "x(60)":U SKIP
     tt-param.usuario               LABEL "Usu rio" COLON 40 SKIP(1)
     with down no-box side-labels width 132 stream-io frame f-parametros.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).



&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                    INPUT "",
                    INPUT "").
ASSIGN c-destino  = RETURN-VALUE.
&else
ASSIGN c-destino  = {varinc/var00002.i 04 tt-param.destino}.
&endif
ASSIGN        c-programa = "AC0419"
       c-versao	= "1.00"
       c-revisao = ".00.000"
       c-empresa = ""
       c-sistema = "Adm. Cotas"
       c-titulo-relat = "Composi‡Æo Cotas Faturadas".

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Listando_Notas_Fiscais *}
run pi-inicializar in h-acomp (input  Return-value ).

run dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

FIND FIRST para-ped NO-LOCK NO-ERROR.

IF tt-param.classificacao = 1 THEN DO: /* item */

FOR EACH nota-fiscal 
       FIELDS(dt-emis-nota cod-estabel serie nr-nota-fis no-ab-reppri ind-tip-nota dt-cancela cod-canal-venda) 
       USE-INDEX ch-sit-nota
        WHERE (nota-fiscal.dt-emis-nota >= tt-param.dt-emis-nota-ini
          AND  nota-fiscal.dt-emis-nota <= tt-param.dt-emis-nota-fim)
          AND (nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
          AND  nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim)
          AND (nota-fiscal.serie        >= tt-param.serie-ini
          AND  nota-fiscal.serie        <= tt-param.serie-fim)
          AND (nota-fiscal.nr-nota-fis  >= tt-param.nr-nota-fis-ini
          AND  nota-fiscal.nr-nota-fis  <= tt-param.nr-nota-fis-fim)
          AND (nota-fiscal.no-ab-reppri >= tt-param.no-ab-reppri-ini
          AND  nota-fiscal.no-ab-reppri <= tt-param.no-ab-reppri-fim) NO-LOCK :

       IF nota-fiscal.ind-tip-nota = 8 THEN NEXT. /*nota gerada pelo recebimento, que nao atualiza cotas - nota espelho */
       IF SUBSTRING(para-ped.char-2,1,3) = "yes" THEN 
          FIND FIRST par-cota WHERE 
                     par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR. 
       ELSE
          FIND FIRST par-cota WHERE  
                     par-cota.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.  

       IF NOT AVAIL par-cota THEN NEXT.

       IF par-cota.cont-canal-venda AND 
          NOT CAN-FIND (FIRST canal-venda WHERE 
                              canal-venda.cod-canal-venda = nota-fiscal.cod-canal-venda  AND
                              canal-venda.dat-inic-ctrl-cotas <= nota-fiscal.dt-emis-nota) THEN NEXT.


       IF  par-cota.tipo-controle <> 2 AND /*quantidade ou pontos*/
           nota-fiscal.ind-tip-nota = 3 THEN  /*diferenca preco*/ 
           NEXT.

       /* Em caso de nota sem pedido, essa rotina verifica se a nota e complementar de imposto ou mercadoria */
       IF nota-fiscal.ind-tip-nota = 4 THEN DO: /*complementar*/ 
          FIND it-nota-fisc WHERE /*nao use find first*/
               it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
               it-nota-fisc.serie       = nota-fiscal.serie AND
               it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
          IF  AVAIL it-nota-fisc              AND
              it-nota-fisc.qt-faturada[1] = 1 AND
              it-nota-fisc.vl-merc-liq    = 0 AND
              it-nota-fisc.tipo-contr     = 4 /*debito direto*/ THEN DO: 
              /*complementar de imposto*/
              IF par-cota.tipo-controle <> 2 THEN /*quantidade ou pontos*/ 
                 NEXT.
              IF par-cota.tipo-controle = 2 /*valor*/ AND 
                 par-cota.tipo-valor = 2   /*liquido*/ THEN  
                 NEXT.
          END.
       END.
{utp/ut-liter.i Nota_Fiscal *}

       RUN pi-acompanhar in h-acomp (input  Return-value  + string(nota-fiscal.nr-nota-fis)).       

       FOR EACH it-nota-fisc FIELDS(it-codigo dt-emis-nota cod-estabel serie nr-nota-fis nat-operacao) OF nota-fiscal WHERE
                it-nota-fisc.it-codigo >= tt-param.it-codigo-ini AND
                it-nota-fisc.it-codigo <= tt-param.it-codigo-fim NO-LOCK BREAK BY it-nota-fisc.it-codigo:

           IF NOT CAN-FIND(FIRST natur-oper WHERE 
                                 natur-oper.nat-operacao = it-nota-fisc.nat-operacao AND 
                                 natur-oper.log-atual-cotas) THEN
              NEXT.


           IF NOT CAN-FIND(FIRST item-cota WHERE item-cota.it-codigo = it-nota-fisc.it-codigo
                                             AND item-cota.log-produto = NO ) THEN NEXT.

           RUN demonstrativoCotasFaturadas IN h-bodi261(INPUT ROWID(it-nota-fisc),
                                                 OUTPUT TABLE tt-dados-nota).



           RUN imprimirDados.

       END.
   END.


END.
ELSE IF tt-param.classificacao = 2 THEN DO: /*produto*/

    FOR EACH est-prod-coml FIELDS(cod-produto-coml it-codigo) WHERE
             est-prod-coml.cod-produto-coml >= tt-param.it-prod-ini AND
             est-prod-coml.cod-produto-coml <= tt-param.it-prod-fim NO-LOCK,
        EACH it-nota-fisc FIELDS(it-codigo dt-emis-nota cod-estabel serie nr-nota-fis nat-operacao) WHERE
             it-nota-fisc.it-codigo = est-prod-coml.it-codigo AND
             it-nota-fisc.dt-emis-nota >= tt-param.dt-emis-nota-ini AND
             it-nota-fisc.dt-emis-nota <= tt-param.dt-emis-nota-fim AND
             it-nota-fisc.cod-estabel  >= tt-param.cod-estabel-ini AND
             it-nota-fisc.cod-estabel  <= tt-param.cod-estabel-fim AND
             it-nota-fisc.serie        >= tt-param.serie-ini AND
             it-nota-fisc.serie        <= tt-param.serie-fim AND
             it-nota-fisc.nr-nota-fis  >= tt-param.nr-nota-fis-ini AND
             it-nota-fisc.nr-nota-fis  <= tt-param.nr-nota-fis-fim  NO-LOCK,
        FIRST nota-fiscal 
        FIELDS(dt-emis-nota cod-estabel serie nr-nota-fis no-ab-reppri ind-tip-nota dt-cancela cod-canal-venda) OF it-nota-fisc WHERE
              nota-fiscal.no-ab-reppri >= tt-param.no-ab-reppri-ini AND
              nota-fiscal.no-ab-reppri <= tt-param.no-ab-reppri-fim NO-LOCK :

        IF NOT AVAIL nota-fiscal THEN NEXT.

        IF nota-fiscal.ind-tip-nota = 8 THEN NEXT. /*nota gerada pelo recebimento, que nao atualiza cotas - nota espelho */
        IF SUBSTRING(para-ped.char-2,1,3) = "yes" THEN 
           FIND FIRST par-cota WHERE 
                      par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR. 
        ELSE
           FIND FIRST par-cota WHERE  
                      par-cota.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.  

        IF NOT AVAIL par-cota THEN NEXT.

        IF par-cota.cont-canal-venda AND 
           NOT CAN-FIND (FIRST canal-venda WHERE 
                               canal-venda.cod-canal-venda = nota-fiscal.cod-canal-venda  AND
                               canal-venda.dat-inic-ctrl-cotas <= nota-fiscal.dt-emis-nota) THEN NEXT.

        IF NOT CAN-FIND(FIRST natur-oper WHERE 
                              natur-oper.nat-operacao = it-nota-fisc.nat-operacao AND 
                              natur-oper.log-atual-cotas) THEN
           NEXT.


        FIND FIRST item-cota WHERE item-cota.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL item-cota THEN NEXT.

        IF  par-cota.tipo-controle <> 2 AND /*quantidade ou pontos*/
            nota-fiscal.ind-tip-nota = 3 THEN  /*diferenca preco*/ 
            NEXT.

        /* Em caso de nota sem pedido, essa rotina verifica se a nota e complementar de imposto ou mercadoria */
        IF nota-fiscal.ind-tip-nota = 4 THEN DO: /*complementar*/ 
           FIND b-it-nota-fisc WHERE /*nao use find first*/
                b-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
                b-it-nota-fisc.serie       = nota-fiscal.serie AND
                b-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
           IF  AVAIL b-it-nota-fisc              AND
               b-it-nota-fisc.qt-faturada[1] = 1 AND
               b-it-nota-fisc.vl-merc-liq    = 0 AND
               b-it-nota-fisc.tipo-contr     = 4 /*debito direto*/ THEN DO: 
               /*complementar de imposto*/
               IF par-cota.tipo-controle <> 2 THEN /*quantidade ou pontos*/ 
                  NEXT.
               IF par-cota.tipo-controle = 2 /*valor*/ AND 
                  par-cota.tipo-valor = 2   /*liquido*/ THEN  
                  NEXT.
           END.
        END.
{utp/ut-liter.i Nota_Fiscal *}

        RUN pi-acompanhar in h-acomp (input  Return-value  + string(nota-fiscal.nr-nota-fis)).

        RUN demonstrativoCotasFaturadas IN h-bodi261(INPUT ROWID(it-nota-fisc),
                                                     OUTPUT TABLE tt-dados-nota).


        RUN imprimirDados.

    END.




END.
ELSE DO: /*ambos*/

    FOR EACH est-prod-coml FIELDS(cod-produto-coml it-codigo) WHERE
             est-prod-coml.cod-produto-coml >= tt-param.it-prod-ini AND
             est-prod-coml.cod-produto-coml <= tt-param.it-prod-fim NO-LOCK :

        IF NOT CAN-FIND ( FIRST tt-item WHERE
                                tt-item.it-codigo = est-prod-coml.it-codigo ) THEN DO:
           CREATE tt-item.
           ASSIGN tt-item.it-codigo = est-prod-coml.it-codigo.
        END.
    END.

    FOR EACH item-cota WHERE
             item-cota.it-codigo >= tt-param.it-codigo-ini AND
             item-cota.it-codigo <= tt-param.it-codigo-fim AND 
             item-cota.log-produto = NO NO-LOCK :
             /* os itens controlados por produtos, devem ser buscados no for each da est-prod-coml*/
        IF NOT CAN-FIND ( FIRST tt-item WHERE
                                tt-item.it-codigo = item-cota.it-codigo ) THEN DO:
           CREATE tt-item.
           ASSIGN tt-item.it-codigo = item-cota.it-codigo.
        END.

    END.

    FOR EACH tt-item ,
        EACH it-nota-fisc FIELDS(it-codigo dt-emis-nota cod-estabel serie nr-nota-fis nat-operacao) WHERE
             it-nota-fisc.it-codigo = tt-item.it-codigo AND
             it-nota-fisc.dt-emis-nota >= tt-param.dt-emis-nota-ini AND
             it-nota-fisc.dt-emis-nota <= tt-param.dt-emis-nota-fim AND
             it-nota-fisc.cod-estabel  >= tt-param.cod-estabel-ini AND
             it-nota-fisc.cod-estabel  <= tt-param.cod-estabel-fim AND
             it-nota-fisc.serie        >= tt-param.serie-ini AND
             it-nota-fisc.serie        <= tt-param.serie-fim AND
             it-nota-fisc.nr-nota-fis  >= tt-param.nr-nota-fis-ini AND
             it-nota-fisc.nr-nota-fis  <= tt-param.nr-nota-fis-fim  NO-LOCK,
        FIRST nota-fiscal 
        FIELDS(dt-emis-nota cod-estabel serie nr-nota-fis no-ab-reppri ind-tip-nota dt-cancela cod-canal-venda) OF it-nota-fisc WHERE
              nota-fiscal.no-ab-reppri >= tt-param.no-ab-reppri-ini AND
              nota-fiscal.no-ab-reppri <= tt-param.no-ab-reppri-fim NO-LOCK :

        IF NOT AVAIL nota-fiscal THEN NEXT.

        IF nota-fiscal.ind-tip-nota = 8 THEN NEXT. /*nota gerada pelo recebimento, que nao atualiza cotas - nota espelho */
        IF SUBSTRING(para-ped.char-2,1,3) = "yes" THEN 
           FIND FIRST par-cota WHERE 
                      par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR. 
        ELSE
           FIND FIRST par-cota WHERE  
                      par-cota.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.  

        IF NOT AVAIL par-cota THEN NEXT.

        IF par-cota.cont-canal-venda AND 
           NOT CAN-FIND (FIRST canal-venda WHERE 
                               canal-venda.cod-canal-venda = nota-fiscal.cod-canal-venda  AND
                               canal-venda.dat-inic-ctrl-cotas <= nota-fiscal.dt-emis-nota) THEN NEXT.

        IF NOT CAN-FIND(FIRST natur-oper WHERE 
                              natur-oper.nat-operacao = it-nota-fisc.nat-operacao AND 
                              natur-oper.log-atual-cotas) THEN
           NEXT.


        FIND FIRST item-cota WHERE item-cota.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL item-cota THEN NEXT.

        IF  par-cota.tipo-controle <> 2 AND /*quantidade ou pontos*/
            nota-fiscal.ind-tip-nota = 3 THEN  /*diferenca preco*/ 
            NEXT.

        /* Em caso de nota sem pedido, essa rotina verifica se a nota e complementar de imposto ou mercadoria */
        IF nota-fiscal.ind-tip-nota = 4 THEN DO: /*complementar*/ 
           FIND b-it-nota-fisc WHERE /*nao use find first*/
                b-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
                b-it-nota-fisc.serie       = nota-fiscal.serie AND
                b-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
           IF  AVAIL b-it-nota-fisc              AND
               b-it-nota-fisc.qt-faturada[1] = 1 AND
               b-it-nota-fisc.vl-merc-liq    = 0 AND
               b-it-nota-fisc.tipo-contr     = 4 /*debito direto*/ THEN DO: 
               /*complementar de imposto*/
               IF par-cota.tipo-controle <> 2 THEN /*quantidade ou pontos*/ 
                  NEXT.
               IF par-cota.tipo-controle = 2 /*valor*/ AND 
                  par-cota.tipo-valor = 2   /*liquido*/ THEN  
                  NEXT.
           END.
        END.
{utp/ut-liter.i Nota_Fiscal *}

        RUN pi-acompanhar in h-acomp (input  Return-value  + string(nota-fiscal.nr-nota-fis)).


        RUN demonstrativoCotasFaturadas IN h-bodi261(INPUT ROWID(it-nota-fisc),
                                                     OUTPUT TABLE tt-dados-nota).

        RUN imprimirDados.

    END.

END.

PROCEDURE ImprimirDados :

    FOR EACH tt-dados-nota NO-LOCK USE-INDEX pedido
        BREAK BY tt-dados-nota.cod-estabel:      

        FIND ITEM 
            WHERE ITEM.it-codigo = tt-dados-nota.it-original NO-LOCK NO-ERROR.

        FIND repres 
            WHERE repres.cod-rep = tt-dados-nota.cod-rep NO-LOCK NO-ERROR.
        IF  NOT AVAIL repres THEN
            NEXT.           

        FIND par-cota 
            WHERE par-cota.cod-estabel = tt-dados-nota.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL par-cota THEN
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao002 = {diinc/i06di307.i 04 1 par-cota.tipo-cota}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-tipo-cota = RETURN-VALUE.
            &else
                ASSIGN c-tipo-cota = {diinc/i06di307.i 04 1 par-cota.tipo-cota}.
            &endif

        ASSIGN c-situacao = IF nota-fiscal.dt-cancela <> ? THEN "Cancelada"
                            ELSE "OK"
               c-it-original = tt-dados-nota.it-original + "  " + ITEM.desc-item.

        IF FIRST-OF (tt-dados-nota.cod-estabel) THEN DO:

             DISP nota-fiscal.cod-estabel
                  nota-fiscal.serie
                  nota-fiscal.nr-nota-fis
                  nota-fiscal.dt-emis-nota
                  c-situacao
                  WITH FRAME f-cab-est.             

             DISP tt-dados-nota.nome-abrev
                  tt-dados-nota.nome-ab-reg   
                  repres.nome-abrev
                  tt-dados-nota.cod-canal-venda
                  tt-dados-nota.cod-gr-cli
                  tt-dados-nota.nome-mic-reg       
                  c-tipo-cota                      
                  WITH FRAME f-cab-emit.
        END.

        IF par-cota.tipo-controle <> 2 THEN
           ASSIGN de-qt-vl-prevista = tt-dados-nota.de-qt-prevista
                  de-qt-vl-faturada = tt-dados-nota.de-qt-faturada
                  de-qt-vl-fat-canc = tt-dados-nota.de-qt-fat-canc.
        ELSE
           ASSIGN de-qt-vl-prevista = tt-dados-nota.de-vl-previsto
                  de-qt-vl-faturada = tt-dados-nota.de-vl-faturado
                  de-qt-vl-fat-canc = tt-dados-nota.de-vl-fat-canc.

        DISP c-it-original 
             tt-dados-nota.it-codigo   
             de-qt-vl-prevista
             de-qt-vl-faturada 
             de-qt-vl-fat-canc
             WITH FRAME f-item. 
             DOWN WITH FRAME f-item.

        FIND tt-dados-aux WHERE
             tt-dados-aux.cod-estabel     = tt-dados-nota.cod-estabel AND
             tt-dados-aux.nome-abrev-rep      = repres.nome-abrev  AND
             tt-dados-aux.it-codigo       = tt-dados-nota.it-codigo NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE tt-dados-aux THEN DO:   
            CREATE tt-dados-aux.
            ASSIGN tt-dados-aux.cod-estabel     = tt-dados-nota.cod-estabel 
                   tt-dados-aux.tipo-cota       = c-tipo-cota
                   tt-dados-aux.nome-abrev-rep      = repres.nome-abrev
                   tt-dados-aux.it-codigo       = tt-dados-nota.it-codigo
                   tt-dados-aux.cod-rep         = tt-dados-nota.cod-rep
                   tt-dados-aux.de-qt-vl-aux-fat-canc  = de-qt-vl-fat-canc
                   tt-dados-aux.de-qt-vl-aux-faturada  = de-qt-vl-faturada.
        END. 
        ELSE
            ASSIGN tt-dados-aux.de-qt-vl-aux-fat-canc  = tt-dados-aux.de-qt-vl-aux-fat-canc + de-qt-vl-fat-canc
                   tt-dados-aux.de-qt-vl-aux-faturada  = tt-dados-aux.de-qt-vl-aux-faturada + de-qt-vl-faturada.

        IF  LAST-OF(tt-dados-nota.cod-estabel) THEN
            PUT SKIP(1).
    END.
END. /* fim procedure imprimir dados */

IF  PAGE-NUMBER > 0 THEN 
    PAGE.

IF tt-param.imp-resumo THEN DO:

    FOR EACH tt-dados-aux NO-LOCK 
        BREAK BY tt-dados-aux.cod-estabel
              BY tt-dados-aux.nome-abrev-rep
              BY tt-dados-aux.it-codigo:

        IF FIRST-OF ( tt-dados-aux.cod-estabel ) OR
           FIRST-OF ( tt-dados-aux.nome-abrev-rep  ) OR
           FIRST-OF ( tt-dados-aux.it-codigo )   THEN DO:

            FIND ITEM 
                WHERE ITEM.it-codigo = tt-dados-aux.it-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE ITEM THEN
                ASSIGN c-it-codigo-res = tt-dados-aux.it-codigo + "  " + ITEM.desc-item.
            ELSE DO:
                FIND produto-coml WHERE
                     produto-coml.cod-produto-coml = tt-dados-aux.it-codigo NO-LOCK NO-ERROR.
                IF  AVAILABLE produto-coml THEN
                    ASSIGN c-it-codigo-res = tt-dados-aux.it-codigo + "  " + produto-coml.des-produto-coml.
                ELSE
                    ASSIGN c-it-codigo-res = tt-dados-aux.it-codigo.
            END.

            IF  FIRST-OF (tt-dados-aux.cod-estabel) THEN DO:

                FOR FIRST estabelec FIELDS(nome)
                    WHERE estabelec.cod-estabel = tt-dados-aux.cod-estabel NO-LOCK.
                END.

                DISP tt-dados-aux.cod-estabel 
                     estabelec.nome
                     tt-dados-aux.tipo-cota
                     WITH FRAME f-cab-resumo.

            END.

            ASSIGN de-qt-vl-prevista = 0.

            FOR EACH cotas WHERE
                     cotas.cod-estabel = tt-dados-aux.cod-estabel AND
                     cotas.cod-rep     = tt-dados-aux.cod-rep AND
                     cotas.cd-produto  = tt-dados-aux.it-codigo NO-LOCK:

                IF par-cota.tipo-controle <> 2 THEN
                   ASSIGN de-qt-vl-prevista = de-qt-vl-prevista + cotas.qt-prevista.
                ELSE
                   ASSIGN de-qt-vl-prevista = de-qt-vl-prevista + cotas.vl-previsto.

            END.

            DISP tt-dados-aux.nome-abrev-rep       
                 c-it-codigo-res
                 de-qt-vl-prevista
                 de-qt-vl-aux-faturada
                 de-qt-vl-aux-fat-canc
                 WITH FRAME f-rep-resumo. 
                 DOWN WITH FRAME f-rep-resumo.

            IF  LAST-OF (tt-dados-aux.cod-estabel) THEN
                PUT SKIP(1).
        END.
    END.   
END.    

IF VALID-HANDLE(h-bodi261) THEN DO:
   DELETE PROCEDURE h-bodi261.
   ASSIGN h-bodi261 = ?.
END.            

IF  PAGE-NUMBER > 0 THEN 
    PAGE.

DISPLAY tt-param.cod-estabel-ini  
        tt-param.cod-estabel-fim  
        tt-param.serie-ini           
        tt-param.serie-fim           
        tt-param.nr-nota-fis-ini  
        tt-param.nr-nota-fis-fim  
        tt-param.dt-emis-nota-ini 
        tt-param.dt-emis-nota-fim 
        tt-param.it-codigo-ini    
        tt-param.it-codigo-fim    
        tt-param.no-ab-reppri-ini   
        tt-param.no-ab-reppri-fim 
        tt-param.imp-resumo 
        c-classificacao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        WITH STREAM-IO FRAME f-parametros.

run pi-finalizar in h-acomp.
{include/i-rpclo.i}         

return "OK":U.













