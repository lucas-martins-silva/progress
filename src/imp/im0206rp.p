/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0206RP 2.00.00.005 } /*** "010005" 06/05/2026 14:14:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0206RP MIM}
&ENDIF

{include/i_fnctrad.i}
/******************************************************************************
**
**  Programa: IM0206.P
**
**  Data....: Dezembro DE 2004
**
**  Objetivo: Listagem do Cadastro de Itens - Importa‡Æo
**
**
******************************************************************************/

/* Definicao de temp-tables */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD c-it-ini         AS CHAR FORMAT "x(18)" COLUMN-LABEL "Item"
    FIELD c-it-fim         AS CHAR FORMAT "x(18)"
    FIELD l-impr-destaq    AS LOGICAL.

DEFINE TEMP-TABLE tt-digita
    FIELD ordem            AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo          AS CHARACTER FORMAT "x(30)"
    INDEX id IS PRIMARY UNIQUE
        ordem.

DEF TEMP-TABLE tt-raw-digita                   
    FIELD raw-digita AS RAW.

/* Definicao de variaveis */
DEF NEW SHARED VAR h-acomp       AS HANDLE NO-UNDO.

DEFINE VARIABLE c-traco               AS CHARACTER NO-UNDO INITIAL "-" EXTENT 3.
DEFINE VARIABLE c-impostos            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-traco-impostos      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pis                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cofins              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ipi                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-icms                AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-traco-destaque      AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-imposto-importacao  AS CHARACTER FORMAT "X(25)":U NO-UNDO.

DEFINE VARIABLE c-trib-ii             AS CHARACTER NO-UNDO FORMAT "x(9)".
DEFINE VARIABLE i-trib-ii             AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-trib-ipi            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-trib-icms           AS CHAR      NO-UNDO.
DEFINE VARIABLE de-aliq-ii            AS DECIMAL   NO-UNDO FORMAT ">>9.99".
DEFINE VARIABLE c-susp-ii             AS CHAR              FORMAT "x(3)".
DEFINE VARIABLE c-susp-ipi-imp        AS CHARACTER NO-UNDO.

/* Pis e Cofins */
DEFINE VARIABLE c-trib-cofins-imp     AS CHARACTER NO-UNDO FORMAT "X(10)".
DEFINE VARIABLE c-trib-pis-imp        AS CHARACTER NO-UNDO FORMAT "X(10)".
DEFINE VARIABLE c-orig-aliq-pis       AS CHARACTER NO-UNDO FORMAT "X(8)".
DEFINE VARIABLE c-orig-aliq-cofins    AS CHARACTER NO-UNDO FORMAT "X(8)".
DEFINE VARIABLE d-aliq-red-cofins-imp AS DECIMAL   NO-UNDO FORMAT "99.99".
DEFINE VARIABLE d-aliq-red-pis-imp    AS DECIMAL   NO-UNDO FORMAT "99.99".
DEFINE VARIABLE de-aliq-ext-pis       AS DECIMAL   NO-UNDO FORMAT ">>9.9999".
DEFINE VARIABLE de-aliq-ext-cofins    AS DECIMAL   NO-UNDO FORMAT ">>9.9999".

/* Seguro */
DEFINE VARIABLE c-seguro                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-traco-seguro          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-val-tax-basic-seguro AS DECIMAL    NO-UNDO FORMAT ">>9.99999".
DEFINE VARIABLE de-val-tax-impto-seguro AS DECIMAL    NO-UNDO FORMAT ">>9.99999".

DEFINE VARIABLE c-impr-destaq         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-destino             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-tit-sel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-usuario          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-tit-par          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-destaq           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-destino          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-tit-imp          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-item             AS CHARACTER  NO-UNDO.

/* Definicao de Parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

ASSIGN c-traco = "-".

/* Includes*/
{include/i-rpvar.i}
{include/tt-edit.i} /* para impressÆo da descricao do destaque */

/* Definicao das forms */
FORM 
    item.it-codigo               AT 01  LABEL "Item"          SKIP 
    item.desc-item               AT 01  LABEL "Descri‡Æo"     SKIP(1)
    item.un                      AT 01  LABEL "Un"        
    item.peso-liquido            AT 55  LABEL "Peso L¡quido"  FORMAT ">>>,>>9.99999"
    item.peso-bruto              AT 106 LABEL "Peso Bruto"    FORMAT ">>>,>>9.99999" SKIP 
    item-mat.cdn-fabrican        AT 01  LABEL "Fabricante do Regime" SPACE(1)
    c-traco[1]                          NO-LABEL SPACE(1)
    emitente.nome-abrev                 NO-LABEL
    item-mat.cdn-pais-orig       AT 55  LABEL "Pa¡s do Regime" SPACE(1)
    c-traco[2]                          NO-LABEL SPACE(1)
    pais.nome-pais                      NO-LABEL
    item.log-necessita-li        AT 106 LABEL "Nesessita LI" SKIP
    ITEM.class-fiscal            AT 01  LABEL "Classifica‡Æo Fiscal"
    c-traco[3]                          NO-LABEL 
    classif-fisc.descricao              NO-LABEL
    WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-cabec-item.

FORM
    c-pis                                            NO-LABEL                          AT 01    
    c-cofins                                         NO-LABEL                          AT 45 SKIP
    c-traco[1]                                       NO-LABEL                          AT 01  
    c-traco[2]                                       NO-LABEL                          AT 45 SKIP
    c-trib-pis-imp                                   LABEL "Tributa‡Æo"                AT 01
    c-trib-cofins-imp                                LABEL "Tributa‡Æo"                AT 45 SKIP
    c-orig-aliq-pis                                  LABEL "Origem"                    AT 01
    c-orig-aliq-cofins                               LABEL "Origem"                    AT 45 SKIP
    d-aliq-red-pis-imp                               LABEL "% Redu‡Æo"                 AT 01     
    d-aliq-red-cofins-imp                            LABEL "% Redu‡Æo"                 AT 45 SKIP
    de-aliq-ext-pis                                  LABEL "% Externo"                 AT 01       
    de-aliq-ext-cofins                               LABEL "% Externo"                 AT 45 SKIP  
    item-mat.val-unit-pis        FORMAT ">>>9.99999" LABEL "Valor Unit rio"            AT 01       
    item-mat.val-unit-cofins     FORMAT ">>>9.99999" LABEL "Valor Unit rio"            AT 45 SKIP  
    item-mat.val-unit-vol-pis    FORMAT ">>>9.99999" LABEL "Valor Unit rio por Volume" AT 01       
    item-mat.val-unit-vol-cofins FORMAT ">>>9.99999" LABEL "Valor Unit rio por Volume" AT 45 SKIP  
    WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-pis-cofins.

FORM
    c-imposto-importacao                                          NO-LABEL                          AT 01
    c-ipi                                                         NO-LABEL                          AT 45 
    c-icms                                                        NO-LABEL                          AT 81 SKIP
    c-traco[1]                                                    NO-LABEL                          AT 01  
    c-traco[2]                                                    NO-LABEL                          AT 45 
    c-traco[3]                                                    NO-LABEL                          AT 81 SKIP
    c-trib-ii                    FORMAT "x(10)"                   LABEL "Tributa‡Æo"                AT 01 
    c-trib-ipi                   FORMAT "x(10)"                   LABEL "Tributa‡Æo"                AT 45 
    c-trib-icms                  FORMAT "x(10)"                   LABEL "Tributa‡Æo"                AT 81 SKIP 
    de-aliq-ii                   FORMAT ">>9.99"                  LABEL "Al¡quota"                  AT 01
    item.aliquota-ipi            FORMAT ">>9.99"                  LABEL "Al¡quota"                  AT 45
    item.fator-reaj-icms         FORMAT ">>>>>>,>>>,>>9.99999999" LABEL "Fator de Reajuste"         AT 81 SKIP
    c-susp-ii                    FORMAT "x(03)"                   LABEL "SuspensÆo"                 AT 01
    c-susp-ipi-imp               FORMAT "x(03)"                   LABEL "SuspensÆo"                 AT 45 SKIP
    item.valor-ipi-beb                                            LABEL "Valor IPI Bebida"          AT 45 SKIP
    item.fm-codigo                                                LABEL "Fam¡lia"                   AT 45 SKIP
    WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-ii-ipi-icms.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-ii-ipi-icms:HANDLE).

FORM 
    item-mat.val-tax-basic-seguro    FORMAT ">>9.99999"         LABEL "% Taxa B sica"             AT 01 SKIP
    item-mat.val-tax-impto-seguro    FORMAT ">>9.99999"         LABEL "% Taxa Impostos"           AT 01 SKIP
    WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-seguro.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-seguro:HANDLE).

FORM
    item.cod-destaq              LABEL "Destaque"                 AT 01 SKIP(1)
    WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-dest-cod.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dest-cod:HANDLE).

FORM 
    tt-editor.conteudo NO-LABEL AT 1
    WITH DOWN WIDTH 132 FRAME f-dest-desc.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dest-desc:HANDLE).


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i  Listagem_Itens_para_Importa‡Æo}
ASSIGN c-titulo-relat = RETURN-VALUE.

{utp/ut-liter.i IMPORTA€ÇO}
ASSIGN c-programa = "IM/0206"
       c-versao   = "I.00"
       c-revisao  = "001"
       c-sistema  = RETURN-VALUE.

FIND FIRST param-global NO-LOCK NO-ERROR.

IF  AVAIL param-global THEN
    ASSIGN c-empresa  = param-global.grupo.

RUN utp/ut-trfrrp.p (INPUT FRAME f-cabec-item:HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-pis-cofins:HANDLE).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-inicializar IN h-acomp (INPUT c-titulo-relat).

{utp/ut-liter.i IMPOSTOS * r}     
ASSIGN c-impostos = RETURN-VALUE.
ASSIGN c-traco-impostos = FILL("-", 62) + c-impostos + FILL("-", 62).

{utp/ut-liter.i IMPOSTO_DE_IMPORTA€ÇO * r}
ASSIGN c-imposto-importacao = RETURN-VALUE.

{utp/ut-liter.i IPI * r}     
ASSIGN c-ipi = RETURN-VALUE.

{utp/ut-liter.i ICMS * r}
ASSIGN c-icms = RETURN-VALUE.

{utp/ut-liter.i PIS * r}
ASSIGN c-pis = RETURN-VALUE.

{utp/ut-liter.i COFINS * r}
ASSIGN c-cofins = RETURN-VALUE.

{utp/ut-liter.i SEGURO * r}     
ASSIGN c-seguro = RETURN-VALUE.
ASSIGN c-traco-seguro = FILL("-", 63) + c-seguro + FILL("-", 63).

FOR EACH item FIELDS(it-codigo    class-fiscal it-codigo       desc-item 
                     un           peso-liquido peso-bruto      log-necessita-li
                     char-2       cd-trib-ipi  cd-trib-icm     valor-ipi-beb 
                     aliquota-ipi fm-codigo    fator-reaj-icms dsl-destaq cod-destaq) NO-LOCK 
    WHERE item.it-codigo >= tt-param.c-it-ini 
    AND   item.it-codigo <= tt-param.c-it-fim,
    FIRST item-mat FIELDS( it-codigo              cdn-pais-orig        cdn-fabrican     log-suspens-impto-import  
                           log-suspens-ipi-import idi-tributac-cofins  idi-tributac-pis val-aliq-ext-pis          
                           val-aliq-ext-cofins    val-unit-pis         val-unit-cofins  val-unit-vol-pis          
                           val-unit-vol-cofins    val-tax-basic-seguro val-tax-impto-seguro char-1)
        WHERE item-mat.it-codigo = ITEM.it-codigo NO-LOCK:

    RUN pi-acompanhar IN h-acomp (INPUT STRING(item.it-codigo)).

    /* Inicio impressÆo do cabecalho do relatorio */
    FOR FIRST emitente FIELDS(nome-abrev) 
        WHERE emitente.cod-emitente = item-mat.cdn-fabrican NO-LOCK. 
    END.

    FOR FIRST pais FIELDS(nome-pais) 
        WHERE pais.cod-pais = item-mat.cdn-pais-orig NO-LOCK. 
    END.

    FOR FIRST classif-fisc FIELDS(descricao) 
        WHERE classif-fisc.class-fiscal = ITEM.class-fiscal NO-LOCK. 
    END.

    DISP 
        item.it-codigo         
        item.desc-item         
        item.un                
        item.peso-liquido      
        item.peso-bruto        
        item-mat.cdn-fabrican  
        c-traco[1]             FORMAT "x(1)"
        emitente.nome-abrev    WHEN AVAIL emitente
        item-mat.cdn-pais-orig 
        c-traco[2]             FORMAT "x(1)"
        pais.nome-pais         WHEN AVAIL pais
        item.log-necessita-li  
        ITEM.class-fiscal      
        c-traco[3]             FORMAT "x(1)"
        classif-fisc.descricao WHEN AVAIL classif-fisc
        WITH FRAME f-cabec-item.

    /* Fim impressÆo do cabecalho do relatorio */

    /* Inicio atribui‡Æo e impressÆo II, IPI e ICMS */
    PUT UNFORMATTED SKIP(1) c-traco-impostos SKIP.

    ASSIGN i-trib-ii        = INT(SUBSTRING(item.char-2,20,2))           
           c-susp-ii        = IF item-mat.log-suspens-impto-import THEN "Sim" ELSE "NÆo"
           de-aliq-ii       = DEC(SUBSTRING(item.char-2,22,6))
           c-susp-ipi-imp   = IF item-mat.log-suspens-ipi-import   THEN "Sim" ELSE "NÆo".

    IF i-trib-ii <> 0 THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao001 = {ininc/i10in172.i 04 i-trib-ii}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN  c-trib-ii  = RETURN-VALUE.
       &else
           ASSIGN c-trib-ii  = {ininc/i10in172.i 04 i-trib-ii}.
       &endif
    END.
    ELSE 
        c-trib-ii = "".

    IF item.cd-trib-ipi >= 1 AND item.cd-trib-ipi <= 4 THEN DO:
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao002 = {ininc/i10in172.i 04 item.cd-trib-ipi}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN  c-trib-ipi = RETURN-VALUE.
       &else
           ASSIGN c-trib-ipi = {ininc/i10in172.i 04 item.cd-trib-ipi}.
       &endif
    END.

    IF item.cd-trib-icm >= 1 AND item.cd-trib-icm <= 5 THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {ininc/i01in245.i 04 item.cd-trib-icm}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-trib-icms = RETURN-VALUE.
        &else
            ASSIGN c-trib-icms = {ininc/i01in245.i 04 item.cd-trib-icm}.
        &endif
    END.

    DISP 
        c-imposto-importacao
        c-ipi               
        c-icms              
        fill('-',34) @ c-traco[1] FORMAT "x(34)" 
        fill('-',34) @ c-traco[2] FORMAT "x(34)" 
        fill('-',41) @ c-traco[3] FORMAT "x(41)"
        c-trib-ii
        c-trib-ipi
        c-trib-icms
        de-aliq-ii
        item.aliquota-ipi
        item.fator-reaj-icms
        c-susp-ii
        c-susp-ipi-imp
        item.valor-ipi-beb
        item.fm-codigo
        WITH FRAME f-ii-ipi-icms.

    PUT SKIP.

    /* Inicio atribui‡Æo e impressao de Pis e Cofins */
    IF  item-mat.idi-tributac-cofins >= 1 
    AND item-mat.idi-tributac-cofins <= 3 THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao004 = {ininc/i04in176.i 04  item-mat.idi-tributac-cofins}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-trib-cofins-imp = RETURN-VALUE.
        &else
            ASSIGN c-trib-cofins-imp = {ininc/i04in176.i 04  item-mat.idi-tributac-cofins}.
        &endif
    END.

    IF  item-mat.idi-tributac-pis >= 1 
    AND item-mat.idi-tributac-pis <= 3 THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao005 = {ininc/i04in176.i 04  item-mat.idi-tributac-pis}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-trib-pis-imp = RETURN-VALUE.
        &else
            ASSIGN c-trib-pis-imp = {ininc/i04in176.i 04  item-mat.idi-tributac-pis}.
        &endif
    END.

    IF SUBSTR(item.char-2,52,1) = '1' THEN
        ASSIGN c-orig-aliq-pis = "Item".
    ELSE 
        IF SUBSTR(item.char-2,52,1) = '2' THEN
            ASSIGN c-orig-aliq-pis = "Natureza".    

    IF SUBSTR(item.char-2,53,1) = '1' THEN
        ASSIGN c-orig-aliq-cofins = "Item".
    ELSE    
        ASSIGN c-orig-aliq-cofins = "Natureza".

    ASSIGN d-aliq-red-cofins-imp  = DEC(SUBSTR(ITEM.CHAR-2,46,5))                   
           d-aliq-red-pis-imp     = DEC(SUBSTR(item.CHAR-2,41,5)).

    IF DEC(SUBSTR(item-mat.char-1,247,9)) <> 0 THEN
        ASSIGN de-aliq-ext-pis = DEC(SUBSTR(item-mat.char-1,247,9)).
    ELSE 
        ASSIGN de-aliq-ext-pis = item-mat.val-aliq-ext-pis.
    
    IF DEC(SUBSTR(item-mat.char-1,256,9)) <> 0 THEN
        ASSIGN de-aliq-ext-cofins = DEC(SUBSTR(item-mat.char-1,256,9)).
    ELSE 
        ASSIGN de-aliq-ext-cofins = item-mat.val-aliq-ext-cofins.
    
    DISP 
        c-pis                        
        c-cofins                     
        fill('-',34) @ c-traco[1] FORMAT "x(34)" 
        fill('-',34) @ c-traco[2] FORMAT "x(34)"
        c-trib-pis-imp               
        c-trib-cofins-imp            
        c-orig-aliq-pis              
        c-orig-aliq-cofins           
        d-aliq-red-pis-imp           
        d-aliq-red-cofins-imp        
        de-aliq-ext-pis         
        de-aliq-ext-cofins   
        item-mat.val-unit-pis        
        item-mat.val-unit-cofins     
        item-mat.val-unit-vol-pis    
        item-mat.val-unit-vol-cofins 
        WITH FRAME f-pis-cofins.

    PUT SKIP(1).

    PUT UNFORMATTED c-traco-seguro.
    DISP
        item-mat.val-tax-basic-seguro      
        item-mat.val-tax-impto-seguro
        WITH FRAME f-seguro.

    PUT SKIP(1).


    /* Fim atribui‡Æo e impressao de Pis e Cofins */
    IF tt-param.l-impr-destaq THEN DO:

        {utp/ut-liter.i DESTAQUE * r}                   
        ASSIGN c-traco-destaque = FILL("-", 62) + RETURN-VALUE + FILL("-", 62).

        PUT c-traco-destaque FORMAT "X(132)" SKIP.

        disp item.cod-destaq
            with frame f-dest-cod.
        DOWN with frame f-dest-cod.

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "Descri‡Æo" *}
        ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
        put fill("-",25) format "x(25)" at 1 
                c-lbl-liter-descricao + " " at 27
                fill("-",25) format "x(25)".

        IF  item.dsl-destaq <> "" THEN DO:
            RUN pi-print-editor (item.dsl-destaq, 60).
            FOR EACH tt-editor:
                disp tt-editor.conteudo 
         		    with frame f-dest-desc.
         	    down with frame f-dest-desc.
            END.
        END.
    END.            

PAGE.           
END.

/*  ++++++++++++++++ Imprime Parametros  +++++++++++++++++++++++++++  */

{utp/ut-liter.i SELE€ÇO * r}                                      
ASSIGN c-lb-tit-sel = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR¶METROS * r}                                      
ASSIGN c-lb-tit-par = TRIM(RETURN-VALUE).
{utp/ut-liter.i IMPRESSÇO * r}                                      
ASSIGN c-lb-tit-imp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * r}                                      
ASSIGN c-lb-destino = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu rio * r}                                      
ASSIGN c-lb-usuario = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Imprimir_Destaques" * r}                                      
ASSIGN c-lb-destaq = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Item" * r}                                      
ASSIGN c-lb-item = TRIM(RETURN-VALUE).

IF tt-param.destino = 1 THEN DO:
   {utp/ut-liter.i Impressora *}
   ASSIGN c-destino = RETURN-VALUE.
END.

IF tt-param.destino = 2 THEN DO:
   {utp/ut-liter.i Arquivo *}
   ASSIGN c-destino = RETURN-VALUE.
END.

IF tt-param.destino = 3 THEN DO:
   {utp/ut-liter.i Terminal *}
   ASSIGN c-destino = RETURN-VALUE.
END.

IF tt-param.l-impr-destaq = YES THEN
    ASSIGN c-impr-destaq = 'Sim'.
ELSE
    ASSIGN c-impr-destaq = 'NÆo'.

PUT UNFORMATTED
   FILL("-",132)         SKIP(1)
   c-lb-tit-sel          SKIP(1)
   c-lb-item             AT 5  ':'
   tt-param.c-it-ini     AT 17 '|< >| ' at 34 tt-param.c-it-fim skip(2)
   c-lb-tit-par          SKIP(1)
   c-lb-destaq           AT 5  ':'
   c-impr-destaq         AT 25  SKIP(1)
   c-lb-tit-imp          SKIP(1)
   c-lb-destino          AT 5  ': ' c-destino " - " tt-param.arquivo
   c-lb-usuario          AT 5  ': ' tt-param.usuario.

   {include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.



   RETURN "OK".

/** procedure de impressao da descricao do destaque **/
    {include/pi-edit.i}



/* EOF */
