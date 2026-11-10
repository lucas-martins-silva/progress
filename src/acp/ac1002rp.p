/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1002RP 2.00.00.034}  /*** 010034 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1002rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac01002RP.P : Atualiza‡Æo Bath de Cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

{include/i-rpvar.i}

DEF VAR c-selecao         AS CHAR FORMAT "x(11)"      NO-UNDO.
DEF VAR c-parametro       AS CHAR FORMAT "x(14)"      NO-UNDO.
DEF VAR c-impressao       AS CHAR FORMAT "x(12)"      NO-UNDO.
DEF VAR c-destino         AS CHAR FORMAT "x(10)"      NO-UNDO.
DEF VAR c-origem          AS CHAR FORMAT "x(6)"       NO-UNDO.
DEF VAR c-dest            AS CHAR FORMAT "x(7)"       NO-UNDO.
DEF VAR c-repres          AS CHAR FORMAT "x(13)"      NO-UNDO.
DEF VAR c-codigo          AS CHAR FORMAT "x(06)"      NO-UNDO.
DEF VAR c-descricao       AS CHAR FORMAT "x(09)"      NO-UNDO.

DEF VAR i-tipo-oper       AS INT                      NO-UNDO.

DEF VAR l-atualizou       AS LOG                      NO-UNDO.

DEF VAR h-bodi261         AS HANDLE                   NO-UNDO.
DEF VAR h-acomp           AS HANDLE                   NO-UNDO.

/* Integra‡Æo EAI */
define new global shared variable v_log_eai_habilit as log  no-undo.
define new global shared variable v-prog-version    as char no-undo.
define new global shared variable v-prog-obj        as char no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

/* Include i-epc200.i: Defini‡Æo Temp-Table tt-epc */
{include/i-epc200.i ac1002rp}

{acp/ac1002.i}

/* temp table rowErrors */
{method/dbotterr.i}

DEF TEMP-TABLE RowErrorsAux LIKE RowErrors.

DEF TEMP-TABLE tt-ped-item 
    FIELD nr-sequencia AS INT 
    FIELD it-codigo    AS CHAR
    FIELD cod-refer    AS CHAR.


DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

/* ************************ Defini‡Æo de parametros ************************** */

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

FORM c-codigo               AT 01
     c-descricao            AT 12 SKIP 
     "----------"           AT 01
     "------------------------------------------------------------------------------------------" at 12 skip
     WITH WIDTH 132 NO-LABEL ATTR-SPACE PAGE-TOP FRAME f-cabec-1.

FORM SKIP(01)
     c-selecao                 NO-LABEL SKIP(1)
     &IF "{&mguni_version}" >= "2.071" &THEN
     tt-param.cod-estabel-ini  COLON 40 SPACE(18) "|< >|"
     &ELSE
     tt-param.cod-estabel-ini  COLON 40 SPACE(20) "|< >|"
     &ENDIF
     tt-param.cod-estabel-fim  NO-LABEL COLON 73 SKIP(1)
     tt-param.nr-pedido-ini    COLON 40 SPACE(11) "|< >|"
     tt-param.nr-pedido-fim    NO-LABEL COLON 73 SKIP(1)
     tt-param.nome-abrev-ini   COLON 40 SPACE(11) "|< >|"
     tt-param.nome-abrev-fim   NO-LABEL COLON 73 SKIP(1)
     tt-param.dt-implant-ini   COLON 40 SPACE(13) "|< >|"
     tt-param.dt-implant-fim   NO-LABEL COLON 73 SKIP(1)     
     tt-param.dt-ini           COLON 40 SPACE(13) "|< >|"
     tt-param.dt-fim           NO-LABEL COLON 73 SKIP(1)
     c-parametro               NO-LABEL SKIP(1)
     tt-param.cotas-nao-aval   COLON 40 SKIP(1)
     c-impressao NO-LABEL      SKIP(1)
     c-destino                 COLON 40
     " - ":U
     tt-param.arquivo NO-LABEL FORMAT "x(60)":U SKIP 
     tt-param.usuario          COLON 40 SKIP(4)     
     WITH DOWN NO-BOX SIDE-LABELS WIDTH 132 STREAM-IO FRAME f-parametros.


/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR¶METROS * R}
ASSIGN c-parametro = TRIM(RETURN-VALUE).
{utp/ut-liter.i IMPRESSÇO * R}
ASSIGN c-impressao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * L}
ASSIGN c-destino:LABEL IN FRAME f-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu rio * L}
ASSIGN tt-param.usuario:LABEL IN FRAME f-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i ORIGEM * L}
ASSIGN c-origem = TRIM(RETURN-VALUE).
{utp/ut-liter.i DESTINO * L}
ASSIGN c-dest = TRIM(RETURN-VALUE).
{utp/ut-liter.i C¢digo * L}
ASSIGN c-codigo = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descri‡Æo * L}
ASSIGN c-descricao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Somente_Cotas_nÆo_Avaliadas * L}
ASSIGN tt-param.cotas-nao-aval:LABEL IN FRAME  f-parametros = TRIM(RETURN-VALUE).
{utp/ut-liter.i Sim/NÆo MAC C}
ASSIGN tt-param.cotas-nao-aval:FORMAT IN FRAME f-parametros = TRIM(RETURN-VALUE).


/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-cabec-1:handle).
{include/i-rpcab.i}

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param NO-ERROR.

FIND empresa WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK NO-ERROR.
IF AVAIL empresa THEN
   ASSIGN c-empresa = empresa.razao-social.

FIND FIRST para-ped NO-LOCK NO-ERROR.

{utp/ut-liter.i M¢dulo_de_Cotas MAC C}
ASSIGN c-programa  = 'AC1002'
       c-sistema   = RETURN-VALUE 
       c-destino   = {varinc/var00002.i 04 tt-param.destino}.

{utp/ut-liter.i Log_da_Atualiza‡Æo_de_Cotas MAC C}
ASSIGN c-titulo-relat = RETURN-VALUE.

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar in h-acomp (INPUT "Aguarde...").


FOR EACH ped-venda FIELDS(nome-abrev
                          nr-pedcli
                          dt-emissao
                          cod-estabel
                          cod-sit-ped ) USE-INDEX ch-implant WHERE 
         ped-venda.completo     = YES AND                     
         ped-venda.nr-pedcli   >= tt-param.nr-pedido-ini AND 
         ped-venda.nr-pedcli   <= tt-param.nr-pedido-fim AND 
         ped-venda.nome-abrev  >= tt-param.nome-abrev-ini AND 
         ped-venda.nome-abrev  <= tt-param.nome-abrev-fim AND 
         ped-venda.dt-implant  >= tt-param.dt-implant-ini AND 
         ped-venda.dt-implant  <= tt-param.dt-implant-fim NO-LOCK:

    RUN pi-acompanhar IN h-acomp (INPUT ped-venda.nr-pedcli).

    IF SUBSTRING(para-ped.char-2, 1, 3) = "yes" THEN  
       FIND FIRST par-cota WHERE 
                  par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.
    ELSE          
       FIND FIRST par-cota WHERE 
                  par-cota.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    IF NOT AVAIL par-cota THEN NEXT. 

    /* quando data de emissao */
    IF par-cota.tipo-data = 1 THEN 
       IF ped-venda.dt-emissao < tt-param.dt-ini AND 
          ped-venda.dt-emissao > tt-param.dt-fim THEN  
          NEXT.        

    /************** Que tipo de atualiza‡Æo ser  feita em Cotas ************/

    /* Pedido ‚ aberto ,at parcial ou total. Ser  inclu¡do em Cotas */
    IF ped-venda.cod-sit-ped <= 3 THEN  
       ASSIGN i-tipo-oper = 1. /*inclui*/

    /* Pedido ‚ suspenso. Ser  atualizado Suspenso em Cotas */
    IF ped-venda.cod-sit-ped  = 5 THEN DO:
       IF par-cota.aval-ped-susp = YES THEN 
          ASSIGN i-tipo-oper = 2. /*suspenso*/ 
       ELSE 
          NEXT.     
    END.

    /* Pedido ‚ cancelado. Ser  atualizado Cancelado em Cotas */
    IF ped-venda.cod-sit-ped = 6 THEN 
       ASSIGN i-tipo-oper = 4. /*cancela*/            

    FOR EACH ped-item FIELDS(dt-entrega it-codigo nr-sequencia it-codigo cod-refer) WHERE 
             ped-item.nome-abrev    = ped-venda.nome-abrev AND 
             ped-item.nr-pedcli     = ped-venda.nr-pedcli  AND 
             ped-item.cod-sit-com  >= (IF tt-param.cotas-nao-aval = YES THEN 1 ELSE 1) AND   
             ped-item.cod-sit-com  <= (IF tt-param.cotas-nao-aval = YES THEN 1 ELSE 4) NO-LOCK :

        /*quando data de entrega*/
        IF par-cota.tipo-data = 2 THEN 
           IF ped-item.dt-entrega < tt-param.dt-ini  AND 
              ped-item.dt-entrega > tt-param.dt-fim  THEN 
              NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT ped-item.it-codigo).

        CREATE tt-ped-item.
        ASSIGN tt-ped-item.nr-sequencia = ped-item.nr-sequencia
               tt-ped-item.it-codigo    = ped-item.it-codigo
               tt-ped-item.cod-refer    = ped-item.cod-refer.

    END.

    IF  NOT VALID-HANDLE (h-bodi261) OR 
        h-bodi261:TYPE      <> "PROCEDURE":U OR 
        h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
        run dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

    RUN emptyRowErrors       IN h-bodi261.

    &IF DEFINED (bf_dis_adm_cotas) &then /* 2.04 */         
        RUN setarLogAtualizacao  IN h-bodi261.
    &ENDIF

    DO TRANS:

        RUN atualizarCotasPedido IN h-bodi261 (INPUT ROWID(ped-venda),
                                               INPUT i-tipo-oper,
                                               INPUT TABLE tt-ped-item).
        RUN getRowErrors         IN h-bodi261 (OUTPUT TABLE RowErrors). 

        FOR EACH rowErrors:
            RUN utp/ut-msgs.p (INPUT "help",
                               INPUT rowErrors.ErrorNumber,  
                               INPUT rowErrors.ErrorParameters).
            DISPLAY c-codigo
                    c-descricao WITH FRAME f-cabec-1.

            PUT rowErrors.ErrorNumber AT 01
                RETURN-VALUE FORMAT "x(200)" AT 12 .                   
        END. 

        /* Integra‡Æo EAI */
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           IF v_log_eai_habilit AND 
              NOT CAN-FIND(FIRST RowErrors
                           WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:
              RUN adapters/xml/vd2/axsvd003.p (INPUT  "upd":U,
                                               INPUT  v-prog-obj,
                                               INPUT  v-prog-version,
                                               INPUT  ROWID(ped-venda),
                                               OUTPUT TABLE RowErrorsAux).
              IF CAN-FIND(FIRST RowErrorsAux) THEN DO:
                  FOR EACH rowErrorsAux:
                      PUT RowErrorsAux.ErrorNumber AT 01
                          RowErrorsAux.ErrorHelp FORMAT "x(200)" AT 12 .                   
                  END. 
                  UNDO,LEAVE.
              END.
           END.
        &endif

    END.

    ASSIGN l-atualizou = YES.

    FOR EACH tt-ped-item :
        DELETE tt-ped-item.
    END.

END. /*for each ped-venda*/

IF VALID-HANDLE(h-bodi261) THEN DO:
   DELETE PROCEDURE h-bodi261.
   ASSIGN h-bodi261 = ?.
END.        

IF l-atualizou = YES THEN DO:
   {utp/ut-liter.i Pedidos_processados_em_Cotas_com_sucesso mac c}
   PUT SKIP(3) SPACE(6) RETURN-VALUE FORMAT "x(50)" SKIP(2).
END.
ELSE DO:
   {utp/ut-liter.i NÆo_atualizou_nenhuma_informa‡Æo_em_Cotas mac c}
   PUT SKIP(3) SPACE(6) RETURN-VALUE FORMAT "x(50)" SKIP(2).       
END.

RUN pi-finalizar IN h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */
PAGE.
DISPLAY c-selecao 
        tt-param.cod-estabel-ini 
        tt-param.cod-estabel-fim 
        tt-param.nr-pedido-ini   
        tt-param.nr-pedido-fim   
        tt-param.nome-abrev-ini  
        tt-param.nome-abrev-fim 
        tt-param.dt-implant-ini
        tt-param.dt-implant-fim 
        tt-param.dt-ini          
        tt-param.dt-fim
        c-parametro
        tt-param.cotas-nao-aval
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        WITH FRAME f-parametros.
DOWN WITH FRAME f-parametros.

{include/i-rpclo.i}

RETURN "OK".




