/********************************************************************************
** Copyright DATASUL S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0320RP 2.00.00.033 } /*** "010033" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ320RP MAQ}
&ENDIF

{utp/ut-glob.i}
{aqp/aq0320.i} /* Definicao temp-table*/
{method/dbotterr.i} /* rowErrors*/

DEFINE VARIABLE h-acomp               AS HANDLE NO-UNDO.
DEFINE VARIABLE h-aqapi001            AS HANDLE NO-UNDO.
DEFINE VARIABLE h-movto-event-financ  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-fechto-event-financ AS HANDLE NO-UNDO.

def var c-lb-impr      as char no-undo.
def var c-lb-dest      as char no-undo.
def var c-lb-usuar     as char no-undo.
def var c-lb-par       as char no-undo.
def var c-lb-estabel   as char no-undo.
def var c-nomeest as char no-undo.
def var c-lb-period    as char no-undo.
def var c-lb-acao      as char no-undo.
def var c-des-acao     as char no-undo.
def var c-lb-dig       as char no-undo.

def var l-digita       as log  init yes no-undo.

{include/i-rpvar.i}
{include/tt-edit.i}
   
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.


RUN aqp/aqapi001.p        PERSISTENT SET h-aqapi001. 
RUN prgfin/apb/apb061za.p PERSISTENT SET h-movto-event-financ.


find first param-global no-lock no-error.

find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

EMPTY TEMP-TABLE tt-digita.    

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.


{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.


IF NOT CAN-FIND(FIRST tt-digita) THEN DO:
    
    ASSIGN l-digita = no. /*usada na impress„o do relatÛrio*/
    FOR FIRST tt-param:

        CREATE tt-digita.
        ASSIGN tt-digita.cod-estabel = tt-param.cod-estabel
               tt-digita.cod-period  = tt-param.cod-period.

    END.

END.


EMPTY TEMP-TABLE tt-erros  NO-ERROR.

FOR EACH tt-digita:
    RUN piExecutaAcao IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NEXT":U THEN 
        NEXT.
END.

RUN pi-relatorio-saida IN THIS-PROCEDURE.

{include/i-rpclo.i}

{include/pi-edit.i}


IF  h-movto-event-financ <> ? THEN DO:
    DELETE PROCEDURE h-movto-event-financ.
    ASSIGN h-movto-event-financ = ?.    
END.
IF  h-aqapi001 <> ? THEN DO:
    DELETE PROCEDURE h-aqapi001.
    ASSIGN h-aqapi001 = ?.  
END.  

IF  h-fechto-event-financ <> ? THEN DO:
    DELETE PROCEDURE h-fechto-event-financ.
    ASSIGN h-fechto-event-financ = ?.  
END.  

IF  h-acomp <> ? THEN DO:
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    
END.


RETURN "OK":U.

/*=======================================================================================*/
PROCEDURE piExecutaAcao:

    CASE tt-param.acao:
    
        WHEN 1 THEN DO:

            IF  h-acomp = ? THEN 
                RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
            {utp/ut-liter.i Fechamento_per°odo * r}            
            RUN pi-inicializar IN h-acomp (RETURN-VALUE).

            RUN piFecharPeriodo  IN THIS-PROCEDURE.  /*fechamento de periodo*/
            IF RETURN-VALUE = "NEXT":U THEN 
                NEXT.

        END.    
        WHEN 2 THEN DO:

            IF  h-acomp = ? THEN 
                RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
            {utp/ut-liter.i Reabertura_per°odo * r}
            RUN pi-inicializar IN h-acomp (RETURN-VALUE).

            RUN piReabrirPeriodo IN THIS-PROCEDURE.  /*reabertura de periodo*/
            IF RETURN-VALUE = "NEXT":U THEN 
                NEXT.
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.
/*=======================================================================================*/


/*=======================================================================================*/
PROCEDURE piFecharPeriodo:

    DEFINE VARIABLE l-fechto-ok       AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-erro-pre-base   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-erro-sit-fechto AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE da-ini-period     AS DATE      NO-UNDO.
    DEFINE VARIABLE da-fim-period     AS DATE      NO-UNDO.
    DEFINE VARIABLE c-texto           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-period-anterior LIKE fechto-produt-period.cod-period NO-UNDO.
    DEFINE VARIABLE i                 AS INTEGER   NO-UNDO.

    ASSIGN da-ini-period = DATE("01/" + SUBSTRING(tt-digita.cod-period,1,2) + "/" + SUBSTRING(tt-digita.cod-period,3,4)).
           da-fim-period = IF INT(SUBSTRING(tt-digita.cod-period,1,2)) < 12 
                                                THEN DATE("01/" + STRING(MONTH(da-ini-period) + 1) + "/" + STRING(YEAR(da-ini-period))) - 1  /* £ltimo dia do màs */
                                                ELSE DATE("31/" +         "12"                     + "/" + STRING(YEAR(da-ini-period))).     /* digitado em tela  */

    /*busca produtores sem nota gerada perÌodos anteriores*/
    ASSIGN c-period-anterior = IF INT(SUBSTRING(tt-digita.cod-period,1,2)) = 1  /*janeiro*/
            THEN "12" + STRING(INT(SUBSTRING(tt-digita.cod-period,3,4)) - 1)
        ELSE IF INT(SUBSTRING(tt-digita.cod-period,1,2)) <= 10
            THEN "0" + STRING(INT(SUBSTRING(tt-digita.cod-period,1,2)) - 1) + SUBSTRING(tt-digita.cod-period,3,4)
        ELSE     
            STRING(INT(SUBSTRING(tt-digita.cod-period,1,2)) - 1) + SUBSTRING(tt-digita.cod-period,3,4).

    DO i = 1 TO 3: /*verifica 3 perÌodos anteriores se tem fechto sem nf*/

        FOR EACH fechto-produt-period FIELDS(cdn-produt-rural) NO-LOCK
           WHERE fechto-produt-period.cod-period   = c-period-anterior
             AND fechto-produt-period.cod-estabel  = tt-digita.cod-estabel
             AND fechto-produt-period.idi-situacao <> 3: /*nota gerada*/

            FOR FIRST emitente FIELDS(natureza) NO-LOCK
                WHERE emitente.cod-emitente = fechto-produt-period.cdn-produt-rural: END.
        
            /*ignora os PJ pois estes nunca ter„o NF gerada pelo MAQ*/
            IF AVAIL emitente AND
               emitente.natureza = 2 THEN /* PESSOA JURIDICA */ 
                NEXT.
        
            /*"Existem produtores sem notas geradas no perÌodo mm/yyyy".*/
            {utp/ut-liter.i Existem_produtores_sem_notas_geradas_no_per°odo * r}
            ASSIGN c-texto = RETURN-VALUE + " " + SUBSTRING(c-period-anterior,1,2) + "/" + SUBSTRING(c-period-anterior,3,4).
            
            CREATE tt-erros.
            ASSIGN tt-erros.error-number      = 6
                   tt-erros.error-description = c-texto.
            
            ASSIGN l-erro-sit-fechto = YES.

            LEAVE.

        END.

        ASSIGN c-period-anterior = IF INT(SUBSTRING(c-period-anterior,1,2)) = 1  /*janeiro*/
            THEN "12" + STRING(INT(SUBSTRING(c-period-anterior,3,4)) - 1)
        ELSE IF INT(SUBSTRING(c-period-anterior,1,2)) <= 10
            THEN "0" + STRING(INT(SUBSTRING(c-period-anterior,1,2)) - 1) + SUBSTRING(c-period-anterior,3,4)
        ELSE     
            STRING(INT(SUBSTRING(c-period-anterior,1,2)) - 1) + SUBSTRING(c-period-anterior,3,4).

    END.
    /******************************************************/

    IF CAN-FIND (FIRST carg-rural WHERE carg-rural.cod-estabel = tt-digita.cod-estabel
                                    AND carg-rural.dat-trans  >= da-ini-period
                                    AND carg-rural.dat-trans  <= da-fim-period
                                    AND carg-rural.cdn-sit    <> 5) THEN DO: /*carga encerrada*/ 

        FOR EACH carg-rural FIELDS(num-carg) NO-LOCK WHERE carg-rural.cod-estabel = tt-digita.cod-estabel
                                                       AND carg-rural.dat-trans >= da-ini-period
                                                       AND carg-rural.dat-trans <= da-fim-period
                                                       AND carg-rural.cdn-sit   <> 5
            BY carg-rural.num-carg:
           
            {utp/ut-liter.i Carga * r}
            ASSIGN c-texto = RETURN-VALUE.
            
            ASSIGN c-texto = c-texto + " " + STRING(carg-rural.num-carg).

            {utp/ut-liter.i deve_estar_encerrada_para_fechar_o_per°odo * r}
            ASSIGN c-texto = c-texto + " " + RETURN-VALUE.

            CREATE tt-erros.
            ASSIGN tt-erros.error-number      = 1
                   tt-erros.error-description = c-texto.  
    
        END.
    END.
    ELSE
        ASSIGN l-fechto-ok = YES.
       
    RUN pi-verif-nc-nao-resolvida IN THIS-PROCEDURE(INPUT da-ini-period,
                                                    INPUT da-fim-period,
                                                    INPUT tt-digita.cod-estabel).    

    FOR EACH produt-carg FIELDS(cdn-produt-rural cod-pto-coleta num-carg log-livre-1 qtd-coleta cod-propried) NO-LOCK
        WHERE produt-carg.cod-estabel = tt-digita.cod-estabel
          AND produt-carg.dat-trans  >= da-ini-period
          AND produt-carg.dat-trans  <= da-fim-period:

        IF produt-carg.log-livre-1 = FALSE THEN DO: /*indica que a carga foi reaberta e n„o foi executado novamente a apuraÁ„o de valores*/

            IF NOT CAN-FIND (FIRST tt-erros WHERE tt-erros.cdn-produt-rural = produt-carg.cdn-produt-rural) THEN DO:

                {utp/ut-liter.i Houve_alteraá∆o_em_carga_que_impacta_na_apuraá∆o_de_valores._Execute_novamente_o_programa_AQ0501_para_o_produtor * r}
                ASSIGN c-texto = RETURN-VALUE.

                ASSIGN c-texto = c-texto + " " + STRING(produt-carg.cdn-produt-rural) + ".".

                CREATE tt-erros.
                ASSIGN tt-erros.error-number      = 3
                       tt-erros.error-description = c-texto 
                       tt-erros.cdn-produt-rural  = produt-carg.cdn-produt-rural.

            END.

            ASSIGN l-erro-pre-base = YES.

            NEXT.

        END.

        FOR FIRST fechto-produt-period FIELDS (cdn-produt-rural cod-propried idi-situacao) NO-LOCK WHERE fechto-produt-period.cdn-produt-rural = produt-carg.cdn-produt-rural
                                                                                                     AND fechto-produt-period.cod-propried     = produt-carg.cod-propried
                                                                                                     AND fechto-produt-period.cod-period       = tt-digita.cod-period
                                                                                                     AND fechto-produt-period.cod-estabel      = tt-digita.cod-estabel:

            IF fechto-produt-period.idi-situacao = 1 THEN DO:
                
                IF NOT CAN-FIND (FIRST tt-erros WHERE tt-erros.cdn-produt-rural = fechto-produt-period.cdn-produt-rural
                                                  AND tt-erros.cod-propried     = fechto-produt-period.cod-propried) THEN DO:

                    /*Produtor/Propriedade <c¢digo do produtor / c¢digo da propriedade> n∆o possui simulaá∆o confirmada*/
                    {utp/ut-liter.i Produtor/Propriedade * r}
                    ASSIGN c-texto = RETURN-VALUE.
                    
                    ASSIGN c-texto = c-texto + " " + STRING(fechto-produt-period.cdn-produt-rural) + "/" + STRING(fechto-produt-period.cod-propried).
                    
                    {utp/ut-liter.i n∆o_possui_simulaá∆o_confirmada. * r}
                    ASSIGN c-texto = c-texto + " " + RETURN-VALUE.
                    
                    CREATE tt-erros.
                    ASSIGN tt-erros.error-number      = 2
                           tt-erros.error-description = c-texto
                           tt-erros.cdn-produt-rural  = fechto-produt-period.cdn-produt-rural
                           tt-erros.cod-propried      = fechto-produt-period.cod-propried.  

                END.

                ASSIGN l-erro-sit-fechto = YES.

            END.

        END.

        IF NOT AVAIL fechto-produt-period AND produt-carg.qtd-coleta <> 0 THEN DO:

            IF NOT CAN-FIND (FIRST tt-erros WHERE tt-erros.cdn-produt-rural = produt-carg.cdn-produt-rural) THEN DO:

                /*Produtor <cod_produtor> n∆o possui preáo base. Estabel: <cod-estabel>*/
                {utp/ut-liter.i Produtor/Propriedade * r}
                ASSIGN c-texto = RETURN-VALUE.

                ASSIGN c-texto = c-texto + " " + STRING(produt-carg.cdn-produt-rural) + "/" + STRING(produt-carg.cod-propried).

                {utp/ut-liter.i n∆o_possui_preáo_base. * r}
                ASSIGN c-texto = c-texto + " " + RETURN-VALUE.

                {utp/ut-liter.i Estabel: * r}
                ASSIGN c-texto = c-texto + " " + RETURN-VALUE.

                ASSIGN c-texto = c-texto + " " + STRING(tt-digita.cod-estabel).

                CREATE tt-erros.
                ASSIGN tt-erros.error-number      = 3
                       tt-erros.error-description = c-texto 
                       tt-erros.cdn-produt-rural  = produt-carg.cdn-produt-rural.

            END.

            ASSIGN l-erro-pre-base = YES.

        END.

    END.

    IF l-fechto-ok AND (NOT l-erro-sit-fechto) AND (NOT l-erro-pre-base) THEN DO:
    
        FOR FIRST param-aquis-rural EXCLUSIVE-LOCK WHERE param-aquis-rural.cod-estabel = tt-digita.cod-estabel:
            ASSIGN param-aquis-rural.cod-periodo = tt-digita.cod-period.

            /*Fechamento realizado com sucesso para o estabelecimento <c¢digo do estabelecimento> e per°odo <c¢digo_periodo>. */
            {utp/ut-liter.i Fechamento_realizado_com_sucesso_para_o_estabelecimento * r}
            ASSIGN c-texto = RETURN-VALUE.
            
            ASSIGN c-texto = c-texto + " " + STRING(tt-digita.cod-estabel).
            
            {utp/ut-liter.i e_per°odo * r}
            ASSIGN c-texto = c-texto + " " + RETURN-VALUE.

            ASSIGN c-texto = c-texto + " " + SUBSTRING(tt-digita.cod-period,1,2) + "/" + SUBSTRING(tt-digita.cod-period,3,4).
            
            CREATE tt-fechto.
            ASSIGN tt-fechto.fechto-description = c-texto.

        END.

    END.
    ELSE
        RETURN "NEXT":U.


    RETURN "OK":U.

END PROCEDURE.
/*=======================================================================================*/


/*=======================================================================================*/
PROCEDURE piReabrirPeriodo:

    DEFINE VARIABLE l-reabre-ok AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE c-texto     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-texto-aux AS CHARACTER NO-UNDO.


    ASSIGN l-reabre-ok = YES.

    /*verifica se algum produtor/propriedade possui nota fiscal gerada, e n„o permite reabir o perÌodo atÈ que se elimine todas as notas*/
    FOR FIRST param-aquis-rural FIELDS(cod-periodo cod-estabel) NO-LOCK WHERE param-aquis-rural.cod-estabel = tt-digita.cod-estabel:

        IF CAN-FIND(FIRST fechto-produt-period
                    WHERE fechto-produt-period.cod-period   = param-aquis-rural.cod-periodo
                      AND fechto-produt-period.cod-estabel  = param-aquis-rural.cod-estabel  
                      AND fechto-produt-period.idi-situacao = 3) THEN DO:

            ASSIGN l-reabre-ok = NO.

            {utp/ut-liter.i O_per°odo_&1_possui_nota_fiscal_gerada_com_o_item_&2_para_o_produtor_&3 * r}
            ASSIGN c-texto = RETURN-VALUE.

            FOR EACH fechto-produt-period FIELDS(cdn-produt-rural it-codigo) NO-LOCK 
                    WHERE fechto-produt-period.cod-period   = param-aquis-rural.cod-period
                      AND fechto-produt-period.cod-estabel  = param-aquis-rural.cod-estabel
                      AND fechto-produt-period.idi-situacao = 3
                    BY fechto-produt-period.cdn-produt-rural:

                ASSIGN c-texto-aux = REPLACE(c-texto,  '&1', STRING(tt-param.cod-period, "99/9999"))
                       c-texto-aux = REPLACE(c-texto-aux,  '&2', fechto-produt-period.it-codigo)
                       c-texto-aux = REPLACE(c-texto-aux,  '&3', STRING(fechto-produt-period.cdn-produt-rural)).

                CREATE tt-erros.
                ASSIGN tt-erros.error-number      = 7
                       tt-erros.error-description = c-texto-aux.

            END.

        END.

    END.

    /*verifica se o estabelecimento est† com o per°odo fechado no financeiro*/
    /*caso positivo, n∆o ser† poss°vel reabrir o per°odo*/
    RUN prgfin/apb/apb526zb.p PERSISTENT SET h-fechto-event-financ.
    IF VALID-HANDLE(h-fechto-event-financ) THEN DO:

        EMPTY TEMP-TABLE tt_estab_fechto.
    
        CREATE tt_estab_fechto.
        ASSIGN tt_estab_fechto.tta_cod_estab  = tt-digita.cod-estabel
               tt_estab_fechto.ttv_log_fechto = NO.

        RUN pi_verifica_fechto_estabelecimento IN h-fechto-event-financ (INPUT tt-param.cod-period,
                                                                         INPUT-OUTPUT TABLE tt_estab_fechto).

        FOR FIRST tt_estab_fechto:

            IF tt_estab_fechto.ttv_log_fechto = YES /*per°odo no financeiro est† fechado*/ THEN DO:

                {utp/ut-liter.i O_per°odo_&1_est†_fechado_no_m¢dulo_contas_a_pagar. * r}
                CREATE tt-erros.
                ASSIGN tt-erros.error-number      = 8
                       tt-erros.error-description = REPLACE(RETURN-VALUE,  '&1', STRING(tt-param.cod-period, "99/9999")).

                ASSIGN l-reabre-ok = NO.

            END.

        END.

    END.
    /************************************************************************/
    /****************************************************/

    IF l-reabre-ok THEN DO:

        FOR FIRST param-aquis-rural EXCLUSIVE-LOCK WHERE param-aquis-rural.cod-estabel = tt-digita.cod-estabel:
            ASSIGN param-aquis-rural.cod-periodo = IF INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) = 1  /*janeiro*/
                                                       THEN "12" + STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,3,4)) - 1)
                                                   ELSE IF INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) <= 10
                                                       THEN "0" + STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) - 1) + SUBSTRING(param-aquis-rural.cod-periodo,3,4)
                                                   ELSE     
                                                       STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) - 1) + SUBSTRING(param-aquis-rural.cod-periodo,3,4).

            ASSIGN c-texto = "".

            /*Reabertura realizada com sucesso para o estabelecimento <c¢digo do estabelecimento> e per°odo <c¢digo_periodo>. */
            {utp/ut-liter.i Reabertura_realizada_com_sucesso_para_o_estabelecimento * r}
            ASSIGN c-texto = RETURN-VALUE.

            ASSIGN c-texto = c-texto + " " + STRING(tt-digita.cod-estabel).

            {utp/ut-liter.i e_per°odo * r}
            ASSIGN c-texto = c-texto + " " + RETURN-VALUE.

            ASSIGN c-texto = c-texto + " " + SUBSTRING(tt-digita.cod-period,1,2) + "/" + SUBSTRING(tt-digita.cod-period,3,4).

            CREATE tt-fechto.
            ASSIGN tt-fechto.fechto-description = c-texto.

        END.

    END.
    ELSE DO:

        /*N∆o foi poss°vel reabrir o per°odo para o estabelecimento <c¢digo do estabelecimento> */
        {utp/ut-liter.i N∆o_foi_poss°vel_reabrir_o_per°odo_para_o_estabelecimento * r}
        ASSIGN c-texto = RETURN-VALUE.

        ASSIGN c-texto = c-texto + " " + STRING(tt-digita.cod-estabel).

        CREATE tt-fechto.
        ASSIGN tt-fechto.fechto-description = c-texto.

    END.


    RETURN "OK":U.

END PROCEDURE.
/*=======================================================================================*/

/*=======================================================================================*/
PROCEDURE pi-verif-nc-nao-resolvida:
/*----------------------------------------------------------------------------------------
  Purpose: Verificar existencia de nao conformidades com status diferente de 
           resolvida para o periodo.  
  Parameters: 
  Notes:   naocfedade-carg.cdn-sit => 1 - Pendente
                                      2 - Em analise
                                      3 - Resolvida                             
----------------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pda-ini-period AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER pda-fim-period AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE tt-digita.cod-estabel.

    IF CAN-FIND(FIRST naocfedade-carg
                WHERE naocfedade-carg.cod-estabel  = pc-cod-estabel
                  AND naocfedade-carg.dat-trans   >= pda-ini-period
                  AND naocfedade-carg.dat-trans   <= pda-fim-period 
                  AND naocfedade-carg.cdn-sit     < 3 ) THEN DO:
                  
        FOR EACH naocfedade-carg NO-LOCK
           WHERE naocfedade-carg.cod-estabel  = pc-cod-estabel
             AND naocfedade-carg.dat-trans   >= pda-ini-period
             AND naocfedade-carg.dat-trans   <= pda-fim-period 
             AND naocfedade-carg.cdn-sit     < 3:
             
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 54859,  /*NC &1 n„o resolvida para a carga &2!*/             
                               INPUT STRING(naocfedade-carg.cdn-naocfedade) + "~~":U + STRING(naocfedade-carg.num-carg)).
                               
           CREATE tt-erros.
           ASSIGN tt-erros.error-number      = 5
                  tt-erros.error-description = RETURN-VALUE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


/*=======================================================================================*/
PROCEDURE pi-relatorio-saida:

    form tt-fechto.fechto-description FORMAT "X(132)"
         WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-fechto.

    form tt-erros.error-description FORMAT "X(132)"
         WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-erro. 

    form tt-digita.cod-estabel  
         tt-digita.nomeest 
         tt-digita.cod-period   FORMAT "99/9999"
             WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-digita.
   
    /* Inicio -- Projeto Internacional */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).

    /* Inicio -- Projeto Internacional */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-fechto:HANDLE).
    
    assign tt-fechto.fechto-description:label in frame f-fechto = "". 
    assign tt-erros.error-description:label in frame f-erro = "".
    
    assign c-empresa   = (if avail param-global then param-global.grupo else "")
           c-programa  = "AQ0320".
    
    view frame f-cabec.
    view frame f-rodape.
    
    /*Estabelecimentos_fechados/reabertos_com_sucesso*/
    FOR FIRST tt-fechto:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Estabelecimentos_fechados/reabertos_com_sucesso"}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****" SKIP(1).    
    END.

    FOR EACH tt-fechto:
        DISP tt-fechto.fechto-description        
                 WITH FRAME f-fechto.
            DOWN WITH FRAME f-fechto.
    
    END.
    /*************************************************/

    /*cargas n∆o encerradas*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 1:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Cargas_n∆o_encerradas"}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****".    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 1:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/

    /*n∆o possui simulaá∆o confirmada*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 2:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Produtores_sem_simulaá∆o_confirmada"}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****" SKIP(1).    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 2:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /*********************************/

    /*n∆o possui preáo base*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 3:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Produtores_sem_preáo_base "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****" SKIP(1).    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 3:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/


    /* erro per°odo anterior aberto */
    FOR FIRST tt-erros WHERE tt-erros.error-number = 6:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Per°odo_anterior_aberto "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****" SKIP(1).    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 6:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /********************************/
    

    /*erro gera evento financeiro*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 4:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Advertància_evento_financeiro "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****".    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 4:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/

    /*erro nota gerada*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 7:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Erro_documento_gerado "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****".    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 7:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/

    /*erro per°odo financeiro fechado*/
    FOR FIRST tt-erros WHERE tt-erros.error-number = 8:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Erro_per°odo_financeiro_fechado "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****".    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 8:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/

    /* Advertencia NC nao resolvida */
    FOR FIRST tt-erros WHERE tt-erros.error-number = 5:
        PUT UNFORMATTED SKIP(2).
        {utp/ut-liter.i "Advertància_NCs_n∆o_resolvidas "}
        PUT UNFORMATTED " ***** " + RETURN-VALUE + " *****" SKIP(1).    
    END.

    FOR EACH tt-erros WHERE tt-erros.error-number = 5:
        DISP tt-erros.error-description        
                 WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
    
    END.
    /***********************/    


    {utp/ut-liter.i PAR∂METRO * r}
    assign c-lb-par = trim(return-value).
    {utp/ut-liter.i Estabelecimento * r}
    assign c-lb-estabel = trim(return-value).
    {utp/ut-liter.i Per°odo * r}
    assign c-lb-period = trim(return-value).
    {utp/ut-liter.i Aá∆o * r}
    assign c-lb-acao = trim(return-value).
    
    {utp/ut-liter.i DIGITAÄ«O * r}
    assign c-lb-dig = trim(return-value).

    {utp/ut-liter.i IMPRESS«O * r}
    assign c-lb-impr = trim(return-value).
    {utp/ut-liter.i Destino * r}
    assign c-lb-dest = trim(return-value).
    {utp/ut-liter.i Usu†rio * r}
    assign c-lb-usuar = trim(return-value).

    FOR FIRST estabelec FIELDS(nome) NO-LOCK WHERE estabelec.cod-estabel = tt-param.cod-estabel:
        ASSIGN c-nomeest = estabelec.nome.
    END.

    IF tt-param.acao = 1 THEN DO:
        {utp/ut-liter.i Fechar * r}
        ASSIGN c-des-acao = RETURN-VALUE. 
    END.
    ELSE DO:
        {utp/ut-liter.i Reabrir * r}
        ASSIGN c-des-acao = RETURN-VALUE. 
    END.

    PUT UNFORMATTED SKIP(3)
        c-lb-par               SKIP(1)
        c-lb-estabel            AT 5  ": " tt-param.cod-estabel                 AT 22 " " c-nomeest
        c-lb-period             AT 5  ": " tt-param.cod-period FORMAT "99/9999" AT 22
        c-lb-acao               AT 5  ": " c-des-acao                           AT 22.

    IF l-digita THEN DO:
        PUT UNFORMATTED SKIP(1)
            c-lb-dig               SKIP(1).
        /*digitaÁ„o*/
        FOR EACH tt-digita:
            DISP tt-digita.cod-estabel
                 tt-digita.nomeest
                 tt-digita.cod-period   
                     WITH FRAME f-digita.
                DOWN WITH FRAME f-digita.
        
        END.
        /***********/
    END.

    PUT UNFORMATTED SKIP(1)
        c-lb-impr               SKIP(1)
        c-lb-dest               AT 5  ": "  AT 28  tt-param.destino " - " tt-param.arquivo
        c-lb-usuar              AT 5  ": "  AT 28  tt-param.usuario 
    SKIP(1).

    RETURN "OK":U.
END PROCEDURE.
/*=======================================================================================*/
