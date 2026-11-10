/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI100 2.00.00.024 } /*** "010024" 22/05/2025 16:59:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i acapi100 MAC}
&ENDIF

/********************************************************************************
** Programa   : acp/acapi100.p
**
** Data       : 15/02/2002
**
** Autor      : Datasul S.A.
**
** Objetivo   : API DE ATUALIZAÄ«O DE COTAS
**
** Release    : 2.04
**
** ParÉmetros :
**               input-output - temp table tt-dados ( informaá‰es que ser∆o atualizadas em cotas )
**               output       - temp table tt-erros ( tramento de errros )                
**
********************************************************************************/

/*definiá∆o de vari†veis*/
DEF VAR i-versao-integ     AS INT FORMAT "999" NO-UNDO.
DEF VAR i-nr-trans         AS INT              NO-UNDO.

DEF VAR de-qt-aux          AS DEC              NO-UNDO. 
DEF VAR de-vl-aux          AS DEC              NO-UNDO.

DEF VAR c-produto-aux      AS CHAR             NO-UNDO.
DEF VAR c-texto            AS CHAR  EXTENT 2   NO-UNDO.

DEF VAR raw-param          AS RAW              NO-UNDO.

DEF VAR l-erro             AS LOG              NO-UNDO.
DEF VAR l-reprov           AS LOG              NO-UNDO.
DEF VAR l-atu-reprov       AS LOG              NO-UNDO.

DEF VAR r-cotas            AS ROWID            NO-UNDO.
DEF VAR qt-canceladas      AS DECIMAL          NO-UNDO.
DEF VAR qt-pedida          AS DECIMAL          NO-UNDO.
DEF VAR qt-susp            AS DECIMAL          NO-UNDO. 

/*definiá∆o de temp tables*/
{acp/acapi100.i} 

DEF TEMP-TABLE tt-reprov NO-UNDO
    FIELD nome-abrev LIKE ped-venda.nome-abrev
    FIELD nr-pedcli  LIKE ped-venda.nr-pedcli
    FIELD cd-produto LIKE cotas.cd-produto.    


/*definiá∆o buffers*/
DEF BUFFER b-cotas    FOR cotas.
DEF BUFFER b-tt-dados FOR tt-dados.
DEF BUFFER bf-tt-dados FOR tt-dados.


DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEFINE OUTPUT       PARAM TABLE FOR tt-erros.

/*verifica vers∆o da api*/
ASSIGN  i-versao-integ = 001.
FIND FIRST tt-dados NO-LOCK NO-ERROR.
IF AVAIL tt-dados THEN DO:
   IF tt-dados.cod-versao-integracao <> i-versao-integ THEN DO:
	  RUN utp/ut-msgs.p (INPUT "msg", INPUT 3941, INPUT "").
 	  CREATE tt-erros.
      ASSIGN tt-erros.cod-erro  = 3941
 		     tt-erros.desc-erro = RETURN-VALUE.
 	  RETURN "NOK".
   END.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "msg", INPUT 8646, INPUT "").
    CREATE tt-erros.
    ASSIGN tt-erros.cod-erro = 8646
           tt-erros.desc-erro = RETURN-VALUE.
    RETURN "NOK".
END.

/*testa para ver se tem quantidades canceladas para atualizar tabela atu-cotas*/
FOR EACH bf-tt-dados WHERE bf-tt-dados.quantidade-can <> 0  NO-LOCK.
    ASSIGN qt-canceladas = qt-canceladas + bf-tt-dados.quantidade-can.
END.
/*****************  Main block ****************/

IF tt-dados.tp-docto = 1 THEN DO: /*PEDIDOS*/
   RUN validarAtualizacaoCotasPedido.
   RUN desatualizarCotasPedido.
   RUN atualizarCotasPedido.
   RUN tratarCotasReprovadasPedido.
END.

/* Notas fiscais est∆o sendo atualizadas direto na bodi261, 
   para melhorar a performance */

RETURN "OK".

/**********************************************/

PROCEDURE validarAtualizacaoCotasPedido.

    DEF VAR num-sit-com   AS INT  NO-UNDO.

    FOR EACH tt-dados:

        /* em caso de aprovaá∆o/reprovaá∆o foráada, n∆o faz validaá∆o */
        IF tt-dados.log-tipo-oper = 7 OR    /*aprova foráado*/
           tt-dados.log-tipo-oper = 8 THEN  /*reprova foráado*/
           NEXT.

        ASSIGN l-erro = NO
               num-sit-com = 1.

        FIND FIRST par-cota WHERE
                   par-cota.cod-estabel = tt-dados.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL par-cota THEN DO:

           FIND LAST base-cota WHERE 
                     base-cota.cod-estabel = par-cota.cod-estabel AND
                     base-cota.cd-produto  = tt-dados.it-codigo AND
                     base-cota.dt-inicial <= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega )  AND
                     base-cota.dt-final   >= ( if par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega )  NO-LOCK NO-ERROR.

           IF AVAIL base-cota AND
              base-cota.cd-produto <> base-cota.cd-produto-dest THEN DO:

              ASSIGN c-produto-aux = base-cota.cd-produto-dest.
              FIND LAST base-cota WHERE
                        base-cota.cod-estabel = par-cota.cod-estabel AND
                        base-cota.cd-produto  = c-produto-aux AND
                        base-cota.dt-inicial <= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) AND
                        base-cota.dt-final   >= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) NO-LOCK NO-ERROR.

           END.

           ASSIGN de-vl-aux = IF par-cota.tipo-valor = 1 THEN tt-dados.valor-unit-bru ELSE tt-dados.valor-unit-liq
                  de-qt-aux = tt-dados.quantidade. 


           RUN acp/acapi004.p (INPUT tt-dados.cod-estabel,
                               INPUT tt-dados.cod-rep,
                               INPUT tt-dados.it-codigo,
                               INPUT (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega),  
                               INPUT tt-dados.cod-canal-venda,
                               INPUT tt-dados.cod-gr-cli,
                               INPUT tt-dados.nome-abrev-cotas,
                               INPUT tt-dados.nome-ab-reg,
                               INPUT tt-dados.nome-mic-reg,
                               OUTPUT r-cotas).

           IF par-cota.cont-cliente THEN DO:

               FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.
               IF NOT AVAIL cotas THEN DO:

                   FIND emitente WHERE emitente.nome-abrev = tt-dados.nome-abrev-cotas NO-LOCK NO-ERROR.
                   IF AVAIL emitente AND emitente.nome-abrev <> emitente.nome-matriz THEN DO:

                       RUN acp/acapi004.p (INPUT tt-dados.cod-estabel,
                                           INPUT tt-dados.cod-rep,
                                           INPUT tt-dados.it-codigo,
                                           INPUT (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega),  
                                           INPUT tt-dados.cod-canal-venda,
                                           INPUT tt-dados.cod-gr-cli,
                                           INPUT emitente.nome-matriz,
                                           INPUT tt-dados.nome-ab-reg,
                                           INPUT tt-dados.nome-mic-reg,
                                           OUTPUT r-cotas).

                   END.

               END.

           END.

           FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.

           IF NOT AVAIL cotas THEN DO:

              /** Nivel Canal Venda **/ 
              IF  tt-dados.nivel = "Canal":U THEN DO:
                  IF par-cota.cota-impl-canal-venda = 1 AND
                     tt-dados.log-tipo-oper        <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper        <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper        <> 5 THEN /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  
              END. /*canal*/ 

              /** Nivel Grupo Cliente **/ 
              IF  tt-dados.nivel = "Grupo":U THEN DO:
                  IF par-cota.cota-impl-gr-cli = 1 AND
                     tt-dados.log-tipo-oper   <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper   <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper   <> 5 THEN /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  
              END. /*grupo cliente*/

              /** Nivel Cliente **/ 
              IF  tt-dados.nivel = "Cliente":U THEN DO:
                  IF par-cota.cota-impl-cliente = 1  AND
                     tt-dados.log-tipo-oper    <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper    <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper    <> 5  THEN /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  
              END. /*cliente*/


              /** Nivel Regiao **/ 
              IF  tt-dados.nivel = "Regiao":U THEN DO:
                  IF par-cota.cota-impl-ab-reg = 1  AND
                     tt-dados.log-tipo-oper   <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper   <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper   <> 5  THEN  /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  

              END. /*regiao*/                                 

              /** Nivel Microrregiao **/ 
              IF  tt-dados.nivel = "Microrregiao":U THEN DO:
                  IF par-cota.cota-impl-mic-reg = 1  AND
                     tt-dados.log-tipo-oper    <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper    <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper    <> 5  THEN  /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  

              END.                                   

              /** Nivel Representante **/ 
              IF  tt-dados.nivel = "Representante":U THEN DO:
                  IF par-cota.cota-impl-repres = 1  AND
                     tt-dados.log-tipo-oper   <> 7 AND /*aprova*/
                     tt-dados.log-tipo-oper   <> 8 AND  /* reprova */ 
                     tt-dados.log-tipo-oper   <> 5  THEN /* diminui */
                     ASSIGN num-sit-com = 3
                            l-erro      = YES.  
              END.    

           END. 

        END. /* if avail par-cota */

        IF l-erro = YES THEN DO:
           FOR EACH b-tt-dados WHERE
                    b-tt-dados.nome-abrev = tt-dados.nome-abrev AND
                    b-tt-dados.nr-docto = tt-dados.nr-docto AND
                    b-tt-dados.it-codigo = tt-dados.it-codigo AND
                    b-tt-dados.nr-sequencia = tt-dados.nr-sequencia :
                    ASSIGN b-tt-dados.cod-sit-com = num-sit-com
                           b-tt-dados.log-erro = YES.
           END.
        END.  
        ELSE DO:  
           FIND FIRST b-tt-dados NO-LOCK WHERE
                      b-tt-dados.nome-abrev = tt-dados.nome-abrev AND
                      b-tt-dados.nr-docto = tt-dados.nr-docto AND
                      b-tt-dados.it-codigo = tt-dados.it-codigo AND
                      b-tt-dados.nr-sequencia = tt-dados.nr-sequencia AND
                      b-tt-dados.log-erro = YES NO-ERROR.
           IF AVAIL b-tt-dados THEN 
              ASSIGN tt-dados.cod-sit-com = b-tt-dados.cod-sit-com
                     tt-dados.log-erro = YES.
        END.                      

    END. /* for each tt-dados*/

END PROCEDURE.


PROCEDURE desatualizarCotasPedido.

    DEFINE VARIABLE l-ac1002 AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-cont   AS INTEGER NO-UNDO.

     DO i-cont = 2 TO 20:
        IF PROGRAM-NAME(i-cont) MATCHES("*ac1002*") THEN DO:
             ASSIGN l-ac1002 =YES.
             LEAVE.
         END.
     END. 
    FOR EACH tt-dados WHERE 
             tt-dados.log-erro = NO
        BREAK BY tt-dados.nome-abrev 
              BY tt-dados.nr-docto: /* usado break by, porque o pedido pode estar repetido na tt-dados,
                                       para varios itens */

        /*IF  LAST-OF(tt-dados.nome-abrev) OR
            LAST-OF(tt-dados.nr-docto)   THEN DO:*/

            FOR EACH atu-cota WHERE
                     atu-cota.nome-abrev = tt-dados.nome-abrev AND
                     atu-cota.nr-pedcli  = tt-dados.nr-docto AND
                     atu-cota.cd-produto = tt-dados.it-codigo EXCLUSIVE-LOCK: 

               /*ponto para acertar as quantidades dos itens  para suspens∆o e reativaá∆o do pedido em cotas*/ 
               IF tt-dados.log-tipo-oper = 2 OR tt-dados.log-tipo-oper = 3 THEN DO:
                    ASSIGN qt-canceladas = 0
                            qt-pedida    = 0
                            qt-susp      = 0.
                     FOR EACH bf-tt-dados WHERE (bf-tt-dados.quantidade-can <> 0 or bf-tt-dados.quantidade-sus <> 0 )  
                          AND bf-tt-dados.nome-abrev = atu-cota.nome-abrev 
                          AND bf-tt-dados.nr-docto   = atu-cota.nr-pedcli 
                          AND bf-tt-dados.it-codigo  = atu-cota.cd-produto NO-LOCK.
                          ASSIGN qt-canceladas = qt-canceladas + bf-tt-dados.quantidade-can
                                 qt-pedida     = qt-pedida     + bf-tt-dados.quantidade
                                 qt-susp       = qt-susp       + bf-tt-dados.quantidade-sus.
                      END.
               END.
                FIND FIRST par-cota where
                           par-cota.cod-estabel = atu-cota.cod-estabel NO-LOCK NO-ERROR.
                IF NOT AVAIL par-cota THEN NEXT.

               FIND LAST base-cota WHERE 
                          base-cota.cod-estabel = atu-cota.cod-estabel AND
                          base-cota.cd-produto  = atu-cota.cd-produto AND
                          base-cota.dt-inicial <= atu-cota.dt-inicial AND 
                          base-cota.dt-final   >= atu-cota.dt-final no-LOCK NO-ERROR.




                FIND LAST cotas WHERE
                          cotas.cod-estabel     = atu-cota.cod-estabel AND
                          cotas.cod-canal-venda = atu-cota.cod-canal-venda AND
                          cotas.cod-gr-cli      = atu-cota.cod-gr-cli AND 
                          cotas.nome-abrev      = atu-cota.nome-abrev-cotas AND
                          cotas.nome-ab-reg     = atu-cota.nome-ab-reg AND
                          cotas.nome-mic-reg    = atu-cota.nome-mic-reg AND
                          cotas.cod-rep         = atu-cota.cod-rep AND
                          cotas.cd-produto      = atu-cota.cd-produto AND
                          cotas.dt-inicial     <= atu-cota.dt-inicial AND
                          cotas.dt-final       >= atu-cota.dt-final  no-LOCK NO-ERROR.

                IF  AVAIL cotas AND
                    AVAIL base-cota THEN DO:



                    find current cotas exclusive-lock.

                    find current base-cota exclusive-lock.
                    IF tt-dados.log-tipo-oper = 4 THEN
                        ASSIGN atu-cota.qt-pedida = qt-canceladas.
                    ELSE 
                    IF tt-dados.log-tipo-oper = 2 THEN
                        ASSIGN atu-cota.qt-pedida   = qt-susp.
                            IF l-ac1002 THEN
                              ASSIGN atu-cota.qt-ped-susp = qt-susp.
                    IF  atu-cota.qt-pedida > 0 THEN DO:           
                        ASSIGN cotas.qt-pedida = cotas.qt-pedida - atu-cota.qt-pedida
                               cotas.vl-pedido = cotas.vl-pedido - atu-cota.vl-pedido.
                        IF cotas.cod-rep <> ? THEN DO: 
                           IF  par-cota.tipo-controle = 2 THEN /* valor */
                               ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.vl-pedido.
                           ELSE     /* quantidade, pontos */   
                               ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.qt-pedida.
                        END. 
                    END.
                    find current base-cota no-lock.
                    IF  atu-cota.qt-ped-susp > 0 AND cotas.qt-ped-susp <> 0 THEN
                        IF tt-dados.log-tipo-oper = 3 THEN  
                           ASSIGN cotas.qt-ped-susp = cotas.qt-ped-susp - qt-susp  
                                  cotas.vl-ped-susp = cotas.vl-ped-susp - atu-cota.vl-ped-susp.

                        ELSE IF  atu-cota.qt-ped-susp > 0 THEN
                           ASSIGN cotas.qt-ped-susp = cotas.qt-ped-susp - atu-cota.qt-ped-susp
                                  cotas.vl-ped-susp = cotas.vl-ped-susp - atu-cota.vl-ped-susp.

                    IF  atu-cota.qt-ped-canc > 0 THEN
                        ASSIGN cotas.qt-ped-canc = cotas.qt-ped-canc - atu-cota.qt-ped-canc
                               cotas.vl-ped-canc = cotas.vl-ped-canc - atu-cota.vl-ped-canc.               

                    IF  atu-cota.qt-ped-reprov > 0 THEN
                        ASSIGN cotas.qt-ped-reprov = cotas.qt-ped-reprov - atu-cota.qt-ped-reprov
                               cotas.vl-ped-reprov = cotas.vl-ped-reprov - atu-cota.vl-ped-reprov.

                    release cotas.
                    DELETE atu-cota.

                END. /*if avail cotas e base-cota*/
            END. /*for each atu-cota*/            
        /*END. /*if last-of*/    */

    END. /*for each tt-dados*/

END PROCEDURE.



PROCEDURE atualizarCotasPedido.

    DEF VAR de-cotacao         AS DEC NO-UNDO.
    DEF VAR l-reprov-base-cota AS LOG NO-UNDO.
    DEFINE VARIABLE l-ac1002 AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-cont   AS INTEGER NO-UNDO.

     DO i-cont = 2 TO 20:
        IF PROGRAM-NAME(i-cont) MATCHES("*ac1002*") THEN DO:
             ASSIGN l-ac1002 =YES.
             LEAVE.
         END.
     END. 
  
        
    FOR EACH tt-dados WHERE 
             tt-dados.log-erro = NO
          BY tt-dados.nr-sequencia
          BY tt-dados.nivel: 

        FIND FIRST par-cota WHERE 
                   par-cota.cod-estabel = tt-dados.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN de-vl-aux    = IF par-cota.tipo-valor = 1 THEN tt-dados.valor-unit-bru ELSE tt-dados.valor-unit-liq
               de-qt-aux    = tt-dados.quantidade 
               l-atu-reprov = NO.

        /*Verifica cotacao da Moeda*/
        IF  par-cota.cod-moeda <> 0 THEN DO:
            {pdp/pd9100.i "par-cota.cod-moeda" "tt-dados.dt-emissao" "de-cotacao"}
            IF NOT AVAIL cotacao THEN DO:
               FIND FIRST moeda WHERE
                          moeda.mo-codigo = par-cota.cod-moeda NO-LOCK NO-ERROR.

               if index(proversion,"webspeed") = 0 THEN DO:

                   RUN utp/ut-msgs.p (INPUT "show",
                                  INPUT 316,
                                  INPUT moeda.descricao + "~~" + STRING(tt-dados.dt-emissao)).

               END.
               ELSE DO:

                   RUN utp/ut-msgs.p (INPUT "msg",
                                      INPUT 316,
                                      INPUT moeda.descricao + "~~" + STRING(tt-dados.dt-emissao)).
                   CREATE tt-erros.
                   ASSIGN tt-erros.cod-erro = 316
                          tt-erros.parametros = (moeda.descricao + "~~" + STRING(tt-dados.dt-emissao))
                          tt-erros.desc-erro = RETURN-VALUE.

               END.

               ASSIGN de-cotacao = 1.
            END.
            ASSIGN de-vl-aux = de-vl-aux * de-cotacao.              
        END.

        FIND LAST base-cota WHERE 
                  base-cota.cod-estabel = par-cota.cod-estabel AND
                  base-cota.cd-produto  = tt-dados.it-codigo AND
                  base-cota.dt-inicial <= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) AND
                  base-cota.dt-final   >= ( if par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) no-LOCK NO-ERROR.
        IF AVAIL base-cota AND
           base-cota.cd-produto <> base-cota.cd-produto-dest THEN DO:
           ASSIGN c-produto-aux = base-cota.cd-produto-dest.
           FIND LAST base-cota WHERE
                     base-cota.cod-estabel = par-cota.cod-estabel AND
                     base-cota.cd-produto  = c-produto-aux AND
                     base-cota.dt-inicial <= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) AND
                     base-cota.dt-final   >= ( IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega ) no-LOCK NO-ERROR. 
        END.

        FOR FIRST item-cota FIELDS (log-cota-limite it-codigo) NO-LOCK WHERE 
                  item-cota.it-codigo = tt-dados.it-original :
        END.                                                   

        /* Verifica se existe cotas para este pedido, afim de efetuar a atualizaáao*/
        RUN acp/acapi004.p (INPUT tt-dados.cod-estabel,
                            INPUT tt-dados.cod-rep,
                            INPUT tt-dados.it-codigo,
                            INPUT (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega),  
                            INPUT tt-dados.cod-canal-venda,
                            INPUT tt-dados.cod-gr-cli,
                            INPUT tt-dados.nome-abrev-cotas,
                            INPUT tt-dados.nome-ab-reg,
                            INPUT tt-dados.nome-mic-reg,
                            OUTPUT r-cotas).

        IF par-cota.cont-cliente THEN DO:

            FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.
            IF NOT AVAIL cotas THEN DO:

                FIND emitente WHERE emitente.nome-abrev = tt-dados.nome-abrev-cotas NO-LOCK NO-ERROR.
                IF AVAIL emitente AND emitente.nome-abrev <> emitente.nome-matriz THEN DO:

                    RUN acp/acapi004.p (INPUT tt-dados.cod-estabel,
                                        INPUT tt-dados.cod-rep,
                                        INPUT tt-dados.it-codigo,
                                        INPUT (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega),  
                                        INPUT tt-dados.cod-canal-venda,
                                        INPUT tt-dados.cod-gr-cli,
                                        INPUT emitente.nome-matriz,
                                        INPUT tt-dados.nome-ab-reg,
                                        INPUT tt-dados.nome-mic-reg,
                                        OUTPUT r-cotas).

                END.

            END.

        END.

        FIND cotas EXCLUSIVE-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR. 

        /*********************************************************************************************** 
           Para aprovaá∆o e reprovaá∆o foráada de pedidos, est† chamando essa rotina separadamente e n∆o
           passa pelas rotinas seguintes.
         ***********************************************************************************************/   
        IF tt-dados.log-tipo-oper = 7 /*aprova*/ OR 
           tt-dados.log-tipo-oper = 8 /*reprova*/ THEN DO: 
            RUN pi-trata-aprova-reprovacao-forcada.
            NEXT.
        END.     
        /***********************************************************************************************/

        ASSIGN l-reprov-base-cota = NO. 
        IF NOT AVAIL cotas THEN   
           RUN pi-nao-encontrou-cotas.

        IF AVAIL cotas THEN DO:

           /*Cotas Maxima*/
           IF par-cota.tipo-cota /*maxima*/ = 2   AND 
            ( tt-dados.log-tipo-oper        = 1   OR  
              tt-dados.log-tipo-oper        = 3   OR 
              tt-dados.log-tipo-oper        = 7   OR 
              tt-dados.log-tipo-oper        = 8   OR 
            ( tt-dados.log-tipo-oper        = 2   AND  
              par-cota.aval-ped-susp = YES ) )    THEN DO:

              /*Valida se base de cotas Pedida eh maior que base cota Prevista*/
              IF  tt-dados.nivel = "Representante":U  AND 
                  ( item-cota.log-cota-limite = YES   AND 
                    base-cota.log-cota-limite = YES ) OR   
                  ( item-cota.log-cota-limite = NO    AND 
                    base-cota.log-cota-limite = YES ) THEN DO:
                 
                  IF (base-cota.qt-pedida + de-qt-aux) > base-cota.qt-prevista AND 
                      par-cota.cota-geral = 1  THEN   /*bloqueia*/
                      ASSIGN l-reprov-base-cota = YES 
                             tt-dados.cod-sit-com = 3.
              END.             

              /*Valida se cotas Pedidas eh maior que Cotas prevista*/
              IF ((par-cota.tipo-controle   = 2 AND (cotas.vl-pedido + de-vl-aux > cotas.vl-previsto))  OR 
                  (par-cota.tipo-controle  <> 2 AND (cotas.qt-pedida + de-qt-aux > cotas.qt-prevista))) AND 
                 ( item-cota.log-cota-limite = YES   AND 
                   base-cota.log-cota-limite = YES ) OR 
                 ( item-cota.log-cota-limite = NO    AND 
                   base-cota.log-cota-limite = YES ) THEN DO:

                 /** Nivel Canal de Venda **/
                 IF tt-dados.nivel = "Canal":U THEN DO:
                    IF par-cota.aval-cota-canal-venda = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.

                 /** Nivel Grupo Cliente **/
                 IF tt-dados.nivel = "Grupo":U THEN DO:
                    IF par-cota.aval-cota-gr-cli = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.              

                 /** Nivel Cliente **/
                 IF tt-dados.nivel = "Cliente":U THEN DO: 
                    IF par-cota.aval-cota-cliente = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.

                 /** Nivel Regiao **/
                 IF tt-dados.nivel = "Regiao":U THEN DO: 
                    IF par-cota.aval-cota-ab-reg = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.              

                 /** Nivel Microrregiao **/
                 IF tt-dados.nivel = "Microrregiao":U THEN DO:
                    IF par-cota.aval-cota-mic-reg = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.

                 /** Nivel Represente **/
                 IF tt-dados.nivel = "Representante":U THEN DO:
                    IF par-cota.aval-cota-repres = 2 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "msg", INPUT 16208, INPUT base-cota.cd-produto-dest + "~~~~" +
                                                                          tt-dados.nr-docto + "~~~~" +
                                                                          tt-dados.nome-abrev + "~~~~" +
                                                                          string(tt-dados.cod-rep) ).
                       CREATE tt-erros.
                       ASSIGN tt-erros.cod-erro = 16208
                              tt-erros.parametros = (base-cota.cd-produto-dest + "~~~~" +
                                                     tt-dados.nr-docto + "~~~~" +
                                                     tt-dados.nome-abrev + "~~~~" +
                                                     string(tt-dados.cod-rep))
                              tt-erros.desc-erro = RETURN-VALUE.
                    END.
                 END.              

              END.

           END. /*if */

           /* inclusao e reativacao de pedidos */
           IF  tt-dados.log-tipo-oper = 1 OR 
               tt-dados.log-tipo-oper = 3 OR 
               tt-dados.log-tipo-oper = 7 OR
               tt-dados.log-tipo-oper = 8 /* aprovacao/reprovacao ac1004 */ THEN DO:


               /*Cotas Maxima*/
               IF par-cota.tipo-cota = 2  THEN DO:

                  IF l-reprov-base-cota = NO THEN DO:

                      /*Valida se cotas Pedidas e maior que Cotas prevista*/
                      IF ( par-cota.tipo-controle  = 2 AND (cotas.vl-pedido + de-vl-aux > cotas.vl-previsto )) OR 
                         ( par-cota.tipo-controle <> 2 AND (cotas.qt-pedida + de-qt-aux > cotas.qt-prevista )) AND 
                         ( item-cota.log-cota-limite = YES   AND 
                           base-cota.log-cota-limite = YES ) OR 
                         ( item-cota.log-cota-limite = NO    AND 
                           base-cota.log-cota-limite = YES ) THEN DO:

                          /** Nivel Canal Venda **/
                          IF  tt-dados.nivel = "Canal":U THEN DO:
                              IF par-cota.aval-cota-canal-venda = 1 AND 
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN  /* diminui */
                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = YES 
                                        l-reprov             = YES                
                                        tt-dados.cod-sit-com = 3.
                          END.

                          /** Nivel Grupo Cliente **/                                             
                          IF  tt-dados.nivel = "Grupo":U THEN DO:
                              IF par-cota.aval-cota-gr-cli    = 1  AND 
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN /* diminui */
                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = YES   
                                        l-reprov             = YES              
                                        tt-dados.cod-sit-com = 3.
                          END.

                          /** Nivel Cliente **/                                             
                          IF  tt-dados.nivel = "Cliente":U THEN DO:
                              IF par-cota.aval-cota-cliente   = 1  AND 
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN /* diminui */

                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = YES                
                                        l-reprov             = YES 
                                        tt-dados.cod-sit-com = 3.
                          END. 

                          /** Nivel Regiao **/                                             
                          IF  tt-dados.nivel = "Regiao":U THEN DO:
                              IF par-cota.aval-cota-ab-reg    = 1  AND
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN /* diminui */
                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = YES     
                                        l-reprov             = YES            
                                        tt-dados.cod-sit-com = 3.
                          END.                                                 

                          /** Nivel Microrregiao **/                                             
                          IF  tt-dados.nivel = "Microrregiao":U THEN DO:
                              if par-cota.aval-cota-mic-reg  = 1  AND 
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN /* diminui */
                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = YES                
                                        l-reprov             = YES 
                                        tt-dados.cod-sit-com = 3.
                          END.                                                 

                          /** Nivel Representante **/                                             
                          IF  tt-dados.nivel = "Representante":U THEN DO:
                              IF par-cota.aval-cota-repres    = 1 AND 
                                 tt-dados.log-tipo-oper      <> 7  AND
                                 tt-dados.log-tipo-oper      <> 8  AND  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  THEN DO: /* diminui */
                                 ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes  
                                        l-reprov             = yes             
                                        tt-dados.cod-sit-com = 3.
                              END.          
                          END.

                      END. /*if */

                  END. /*l-reprov-base-cota*/

                  ELSE DO:  /*reprovou por base de cota*/

                      IF tt-dados.log-tipo-oper      <> 7  AND   /* aprova/desaprova */ 
                         tt-dados.log-tipo-oper      <> 8  AND
                         tt-dados.log-tipo-oper      <> 5  THEN /* diminui */
                         ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                l-atu-reprov         = YES   
                                l-reprov             = YES              
                                tt-dados.cod-sit-com = 3.

                  END.
               END. /*tipo-contole*/

               /* se n∆o for reprovacao */
               IF l-atu-reprov = NO THEN DO:      
                IF tt-dados.log-tipo-oper = 3 THEN
                    ASSIGN cotas.qt-pedida = cotas.qt-pedida + tt-dados.quantidade-sus
                           cotas.vl-pedido = cotas.vl-pedido + de-vl-aux
                           tt-dados.cod-sit-com = 2. /*aprovado*/
                ELSE
                   IF l-ac1002 THEN DO:

                        ASSIGN cotas.qt-pedida = cotas.qt-pedida + tt-dados.quantidade - tt-dados.quantidade-can 
                               cotas.vl-pedido = cotas.vl-pedido + de-vl-aux
                               tt-dados.cod-sit-com = 2. /*aprovado*/  


                   END.

                   ELSE
                   ASSIGN cotas.qt-pedida = cotas.qt-pedida + tt-dados.quantidade - tt-dados.quantidade-can 
                          cotas.vl-pedido = cotas.vl-pedido + de-vl-aux
                          tt-dados.cod-sit-com = 2. /*aprovado*/  


                  IF tt-dados.nivel = "Representante":U THEN DO:

                     IF l-reprov = NO THEN DO: 
                        find current base-cota exclusive-lock. 
                        IF par-cota.tipo-controle = 2 THEN /*valor*/
                           ASSIGN base-cota.qt-pedida = base-cota.qt-pedida + de-vl-aux.
                        ELSE /*quantidade, pontos*/ 
                           ASSIGN base-cota.qt-pedida = base-cota.qt-pedida + de-qt-aux.   
                        find current base-cota no-lock.
                     END. 
                  END.         
               END.

           END.
           ELSE DO:
               /* suspensao de pedidos */
               IF ( tt-dados.log-tipo-oper = 2 AND par-cota.aval-ped-susp = YES ) OR 
                    tt-dados.log-tipo-oper = 9 THEN DO:  /*implantacao pedido sem credito*/
                   IF l-ac1002 THEN
                        ASSIGN cotas.qt-ped-susp    = cotas.qt-ped-susp + de-qt-aux -  (  tt-dados.quantidade - tt-dados.quantidade-sus )
                               cotas.vl-ped-susp    = cotas.vl-ped-susp + de-vl-aux
                               tt-dados.cod-sit-com = 4 /*suspenso*/
                               cotas.qt-pedida = cotas.qt-pedida  + (  tt-dados.quantidade - tt-dados.quantidade-sus ).
                   ELSE 
                       ASSIGN  cotas.qt-ped-susp    = cotas.qt-ped-susp + de-qt-aux 
                               cotas.vl-ped-susp    = cotas.vl-ped-susp + de-vl-aux                                                                    
                               tt-dados.cod-sit-com = 4. /*suspenso*/  
               END.
           END.

           /* se n∆o for reprovacao */
           IF l-atu-reprov = NO THEN DO:
                /* cancelamento de pedidos */
                IF tt-dados.log-tipo-oper = 4 THEN DO:
                   
                    IF l-ac1002 THEN 
                        ASSIGN cotas.qt-ped-canc    = cotas.qt-ped-canc + de-qt-aux - tt-dados.quantidade-can
                               cotas.vl-ped-canc    = cotas.vl-ped-canc + de-vl-aux
                               tt-dados.cod-sit-com = 2. /*cancelado a situacao fica aprovado*/ 
                    ELSE 
                        ASSIGN cotas.qt-ped-canc    = cotas.qt-ped-canc + tt-dados.quantidade-can
                               cotas.vl-ped-canc    = cotas.vl-ped-canc + de-vl-aux
                               tt-dados.cod-sit-com = 2. /*cancelado a situacao fica aprovado*/
      
                    /*Ajusta a cota geral no cancelamento*/
                    IF tt-dados.nivel = "Representante":U THEN DO:               
                       
                        find current base-cota exclusive-lock. 
                        IF par-cota.tipo-controle = 2 THEN /*valor*/
                           ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - de-vl-aux.
                        ELSE DO: /*quantidade, pontos*/ /*Realizado parcialmente na bodi261*/
                            IF l-ac1002 THEN 
                                ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - de-qt-aux.   
                            ELSE 
                                ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - tt-dados.quantidade-can.  
                        END.
                          
                        find current base-cota no-lock.
                    
                    END.  

                END.
                ELSE
                      ASSIGN   cotas.qt-ped-canc    = cotas.qt-ped-canc + tt-dados.quantidade-can.
           END.             

           FIND LAST  atu-cota WHERE
                      atu-cota.cod-estabel      =  cotas.cod-estabel AND
                      atu-cota.cod-canal-venda  =  cotas.cod-canal-venda AND
                      atu-cota.cod-gr-cli       =  cotas.cod-gr-cli AND
                      atu-cota.nome-abrev-cotas =  cotas.nome-abrev AND
                      atu-cota.nome-abrev       =  tt-dados.nome-abrev AND
                      atu-cota.nome-ab-reg      =  cotas.nome-ab-reg AND
                      atu-cota.nome-mic-reg     =  cotas.nome-mic-reg AND
                      atu-cota.cod-rep          =  cotas.cod-rep AND
                      atu-cota.cd-produto       =  cotas.cd-produto AND       
                      atu-cota.dt-inicial      <= (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega) AND
                      atu-cota.dt-final        >= cotas.dt-final AND 
                      atu-cota.nr-pedcli        =  tt-dados.nr-docto EXCLUSIVE-LOCK NO-ERROR.

           IF NOT AVAIL atu-cota           AND 
              tt-dados.log-tipo-oper <> 5  THEN DO:  /*em caso de eliminacao nao cria atu-cota*/

              CREATE  atu-cota.
              ASSIGN  atu-cota.nome-abrev       =  tt-dados.nome-abrev
                      atu-cota.nr-pedcli        =  tt-dados.nr-docto
                      atu-cota.cod-estabel      =  cotas.cod-estabel
                      atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
                      atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
                      atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
                      atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
                      atu-cota.cod-rep          =  cotas.cod-rep
                      atu-cota.cd-produto       =  cotas.cd-produto   
                      atu-cota.nome-abrev-cotas =  cotas.nome-abrev    
                      atu-cota.dt-inicial       = (IF par-cota.tipo-data = 1 THEN 
                                                      tt-dados.dt-emissao    ELSE 
                                                      tt-dados.dt-entrega)
                      atu-cota.dt-final         =  cotas.dt-final NO-ERROR .

              /* inclui pedido / reativa / suspende com liberacao */
              IF  tt-dados.log-tipo-oper = 1 OR 
                  tt-dados.log-tipo-oper = 3 OR 
                  tt-dados.log-tipo-oper = 7 OR
                  tt-dados.log-tipo-oper = 8 THEN DO:

                  /* atualiza reprovado */       
                  IF l-atu-reprov THEN        
                     ASSIGN atu-cota.qt-ped-reprov = de-qt-aux 
                            atu-cota.vl-ped-reprov = de-vl-aux.
                  ELSE  
                     ASSIGN atu-cota.qt-pedida = de-qt-aux 
                            atu-cota.vl-pedido = de-vl-aux.                        

              END.
              ELSE DO: /* suspende pedido*/
                   IF tt-dados.log-tipo-oper = 2 AND not(l-ac1002) THEN
                     ASSIGN cotas.qt-ped-susp = cotas.qt-ped-susp + atu-cota.qt-ped-susp -  IF tt-dados.quantidade-sus = tt-dados.quantidade THEN 0 ELSE tt-dados.quantidade-sus
                            cotas.vl-ped-susp = cotas.vl-ped-susp + atu-cota.vl-ped-susp.
                     ELSE IF tt-dados.log-tipo-oper = 2 THEN
                        ASSIGN cotas.qt-ped-susp = cotas.qt-ped-susp + atu-cota.qt-ped-susp
                               cotas.vl-ped-susp = cotas.vl-ped-susp + atu-cota.vl-ped-susp.
                     ELSE 
                        ASSIGN cotas.qt-ped-susp = cotas.qt-ped-susp + atu-cota.qt-ped-susp
                               cotas.vl-ped-susp = cotas.vl-ped-susp + atu-cota.vl-ped-susp.

                  IF  (tt-dados.log-tipo-oper = 2 AND par-cota.aval-ped-susp = YES) OR 
                       tt-dados.log-tipo-oper = 9 THEN /*implantacao pedido sem credito*/
                       ASSIGN atu-cota.qt-ped-susp =  de-qt-aux
                              atu-cota.vl-ped-susp =  de-vl-aux.
              
              END.
              /*cancela pedido*/ 
              IF tt-dados.log-tipo-oper = 4 THEN 
              ASSIGN atu-cota.qt-ped-canc = de-qt-aux 
                     atu-cota.vl-ped-canc = de-vl-aux.

           END.
           ELSE DO:
              IF AVAIL atu-cota                AND /* if avail atu-cota */
                 tt-dados.log-tipo-oper <> 5   THEN DO: /*em caso de eliminacao nao cria atu-cota*/

                /* inclui pedido / reativa / suspende com liberacao */
                IF  tt-dados.log-tipo-oper = 1 OR
                    tt-dados.log-tipo-oper = 3 OR
                    tt-dados.log-tipo-oper = 7 OR
                    tt-dados.log-tipo-oper = 8 THEN DO:

                    /* atualiza reprovado */       
                    IF l-atu-reprov THEN       
                       ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + de-qt-aux 
                              atu-cota.vl-ped-reprov = de-vl-aux + atu-cota.vl-ped-reprov.
                    ELSE 
                       ASSIGN atu-cota.qt-pedida = atu-cota.qt-pedida + de-qt-aux
                              atu-cota.vl-pedido = atu-cota.vl-pedido + de-vl-aux.

                END.
                ELSE /* suspende pedido*/

                    IF (tt-dados.log-tipo-oper = 2 AND par-cota.aval-ped-susp = YES) OR 
                        tt-dados.log-tipo-oper = 9 THEN  
                        ASSIGN atu-cota.qt-ped-susp = atu-cota.qt-ped-susp + de-qt-aux
                               atu-cota.vl-ped-susp = atu-cota.vl-ped-susp + de-vl-aux.

                /*cancela pedido*/ 
                IF tt-dados.log-tipo-oper = 4 THEN
                   ASSIGN atu-cota.qt-ped-canc = atu-cota.qt-ped-canc + de-qt-aux 
                          atu-cota.vl-ped-canc = atu-cota.vl-ped-canc + de-vl-aux.

              END. /* avail atu-cota */
           END. /***else do***/
        END.  /* if avail cotas */
    END. /* for each tt-dados */

END PROCEDURE.



PROCEDURE tratarCotasReprovadasPedido.

    /********************************************************************* 
          Tratamento para cotas Reprovadas, quando controla por n°veis.
          Se pelo menos um n°vel foi reprovado, todos os niveis devem
          ser reprovados juntamente 
     *********************************************************************/
    
    DEF VAR l-produto AS LOG NO-UNDO.

    FOR EACH tt-reprov :
        DELETE tt-reprov.
    END.

    FOR EACH tt-dados WHERE  
             tt-dados.log-erro = NO: 


        /* cria temp table , pois tlz num pedido, apenas em um item foi reprovado 
           algum n°vel. sem isso , reprova todos os itens do pedido */
        FOR EACH atu-cota FIELDS ( nome-abrev nr-pedcli qt-ped-reprov cd-produto) WHERE
                 atu-cota.nome-abrev = tt-dados.nome-abrev AND
                 atu-cota.nr-pedcli  = tt-dados.nr-docto NO-LOCK:
            IF atu-cota.qt-ped-reprov > 0 THEN DO:
               FIND FIRST tt-reprov WHERE 
                          tt-reprov.nome-abrev = atu-cota.nome-abrev AND 
                          tt-reprov.nr-pedcli  = atu-cota.nr-pedcli AND 
                          tt-reprov.cd-produto = atu-cota.cd-produto NO-ERROR . 
               IF NOT AVAIL tt-reprov THEN DO:
                  CREATE tt-reprov.
                  ASSIGN tt-reprov.nome-abrev = atu-cota.nome-abrev
                         tt-reprov.nr-pedcli  = atu-cota.nr-pedcli              
                         tt-reprov.cd-produto = atu-cota.cd-produto.
               END.
            END.
        END.        
    END.    

    FOR EACH tt-dados WHERE  
             tt-dados.log-erro = NO 
        BREAK BY tt-dados.nome-abrev 
              BY tt-dados.nr-docto : /* usado break by, porque o pedido pode estar repetido na tt-dados, para 
                                         varios itens */


        ASSIGN l-produto = NO.

        /* Quando Ç produto, a atu-cota grava um registro s¢, com aprovados e 
           reprovados juntos, diferente do que acontece quando Ç usado item.
           Por isso, Ç necess†rio fazer um tratamento diferente em relaá∆o a
           base cota e cotas. */
        FOR FIRST produto-coml FIELDS (cod-produto-coml) WHERE  
                   produto-coml.cod-produto-coml = tt-dados.it-codigo NO-LOCK :
            ASSIGN l-produto = YES. 
        END. 

        FIND FIRST par-cota WHERE 
                   par-cota.cod-estabel = tt-dados.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN l-atu-reprov = NO.

        IF  LAST-OF(tt-dados.nome-abrev) OR 
            LAST-OF(tt-dados.nr-docto)   THEN DO:


            /* libera pedido parcial */
            IF par-cota.ped-parcial THEN DO:


                IF par-cota.log-impl-niveis THEN DO:

                    
                    FIND FIRST tt-reprov NO-ERROR. 
                    IF AVAIL tt-reprov THEN 
                       ASSIGN l-atu-reprov = YES.

                    IF l-atu-reprov = YES THEN DO:

                        FOR EACH atu-cota WHERE 
                                 atu-cota.nome-abrev = tt-dados.nome-abrev AND 
                                 atu-cota.nr-pedcli  = tt-dados.nr-docto EXCLUSIVE-LOCK:

                           IF l-produto = NO THEN DO: /*n∆o for produto mas item*/
                              FIND LAST base-cota WHERE 
                                        base-cota.cod-estabel = atu-cota.cod-estabel AND 
                                        base-cota.cd-produto  = atu-cota.cd-produto AND 
                                        base-cota.dt-inicial <= atu-cota.dt-inicial AND 
                                        base-cota.dt-final   >= atu-cota.dt-final EXCLUSIVE-LOCK NO-ERROR.

                              IF AVAIL base-cota AND 
                                 atu-cota.cod-rep <> ? THEN  do:
                                 find current base-cota exclusive-lock.
                                 ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - 
                                                              (IF par-cota.tipo-controle = 2 THEN  
                                                                  atu-cota.vl-pedido ELSE 
                                                                  atu-cota.qt-pedida).
                                 find current base-cota no-lock.
                              end.
                           END.
                           
                          FIND FIRST tt-reprov WHERE 
                                     tt-reprov.nome-abrev = atu-cota.nome-abrev AND 
                                     tt-reprov.nr-pedcli  = atu-cota.nr-pedcli  AND 
                                     tt-reprov.cd-produto = atu-cota.cd-produto NO-ERROR. 
                          IF NOT AVAIL tt-reprov THEN NEXT.

                          FOR EACH b-tt-dados WHERE  
                                   b-tt-dados.nome-abrev = tt-dados.nome-abrev AND 
                                   b-tt-dados.nr-docto   = tt-dados.nr-docto AND 
                                   b-tt-dados.it-codigo  = tt-reprov.cd-produto :
                              ASSIGN b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                          END.                       

                          FIND LAST cotas WHERE 
                                    cotas.cod-estabel      = atu-cota.cod-estabel AND 
                                    cotas.cod-canal-venda  = atu-cota.cod-canal-venda AND 
                                    cotas.cod-gr-cli       = atu-cota.cod-gr-cli AND 
                                    cotas.nome-abrev       = atu-cota.nome-abrev-cotas AND 
                                    cotas.nome-ab-reg      = atu-cota.nome-ab-reg AND 
                                    cotas.nome-mic-reg     = atu-cota.nome-mic-reg AND 
                                    cotas.cod-rep          = atu-cota.cod-rep AND 
                                    cotas.cd-produto       = atu-cota.cd-produto AND 
                                    cotas.dt-inicial      <= atu-cota.dt-inicial AND 
                                    cotas.dt-final        >= atu-cota.dt-final  EXCLUSIVE-LOCK NO-ERROR.

                          IF  AVAIL cotas THEN DO:
                              IF  atu-cota.qt-ped-reprov = 0  THEN
                                  ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-pedida
                                         atu-cota.vl-ped-reprov = atu-cota.vl-pedido
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.  
                               ELSE IF  atu-cota.qt-pedida <> 0 THEN
                                        ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida
                                               atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido
                                               cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-pedida
                                               cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-pedido
                                               cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                               cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                               atu-cota.qt-pedida     = 0
                                               atu-cota.vl-pedido     = 0.  
                         END.
                        END.
                    END. /*l-atu-reprov*/
                END.
            END.    

            /* n∆o libera pedido parcial */

            ELSE DO:

                ASSIGN c-produto-aux = "".

                

                FOR EACH atu-cota FIELDS ( nome-abrev nr-pedcli qt-ped-reprov cd-produto) WHERE 
                         atu-cota.nome-abrev = tt-dados.nome-abrev AND 
                         atu-cota.nr-pedcli  = tt-dados.nr-docto NO-LOCK:
                    IF atu-cota.qt-ped-reprov > 0 THEN  
                       ASSIGN l-atu-reprov = YES.
                END.

                IF l-atu-reprov = YES THEN DO:

                    FOR EACH atu-cota WHERE 
                             atu-cota.nome-abrev = tt-dados.nome-abrev AND 
                             atu-cota.nr-pedcli  = tt-dados.nr-docto EXCLUSIVE-LOCK:

                       FIND LAST base-cota no-LOCK WHERE 
                                 base-cota.cod-estabel = atu-cota.cod-estabel AND 
                                 base-cota.cd-produto  = atu-cota.cd-produto AND 
                                 base-cota.dt-inicial <= atu-cota.dt-inicial AND 
                                 base-cota.dt-final   >= atu-cota.dt-final NO-ERROR.
                       IF AVAIL base-cota           AND 
                          atu-cota.cod-rep    <> ?  THEN do: 
                          find current base-cota exclusive-lock.
                          ASSIGN base-cota.qt-pedida = base-cota.qt-pedida - 
                                                       (IF par-cota.tipo-controle = 2 THEN  
                                                           atu-cota.vl-pedido ELSE 
                                                           atu-cota.qt-pedida).
                          find current base-cota no-lock.
                       end.
                       IF l-produto = NO THEN DO: /*quando n∆o for produto mas item*/
                           FOR EACH b-tt-dados WHERE  
                                    b-tt-dados.nome-abrev = tt-dados.nome-abrev AND 
                                    b-tt-dados.nr-docto   = tt-dados.nr-docto :
                               ASSIGN b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                           END.

                           FIND LAST cotas WHERE 
                                     cotas.cod-estabel      = atu-cota.cod-estabel AND 
                                     cotas.cod-canal-venda  = atu-cota.cod-canal-venda AND 
                                     cotas.cod-gr-cli       = atu-cota.cod-gr-cli AND 
                                     cotas.nome-abrev       = atu-cota.nome-abrev-cotas AND 
                                     cotas.nome-ab-reg      = atu-cota.nome-ab-reg AND 
                                     cotas.nome-mic-reg     = atu-cota.nome-mic-reg AND 
                                     cotas.cod-rep          = atu-cota.cod-rep AND 
                                     cotas.cd-produto       = atu-cota.cd-produto AND 
                                     cotas.dt-inicial      <= atu-cota.dt-inicial AND 
                                     cotas.dt-final        >= atu-cota.dt-final  EXCLUSIVE-LOCK NO-ERROR .

                           IF AVAIL cotas THEN DO:
                              IF atu-cota.qt-ped-reprov = 0  THEN
                                 ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-pedida
                                        atu-cota.vl-ped-reprov = atu-cota.vl-pedido
                                        cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov
                                        cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                        cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                        cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                        atu-cota.qt-pedida     = 0
                                        atu-cota.vl-pedido     = 0.  
                              ELSE IF atu-cota.qt-pedida <> 0 THEN
                                      ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida
                                             atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido
                                             cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-pedida
                                             cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-pedido
                                             cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                             cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                             atu-cota.qt-pedida     = 0
                                             atu-cota.vl-pedido     = 0.  

                           END.
                       END. /*l-produto*/
                       ELSE DO: /*quando for produto*/

                           IF  atu-cota.qt-ped-reprov = 0 OR 
                              (atu-cota.qt-ped-reprov <> 0 AND 
                               atu-cota.qt-pedida     <> 0) THEN DO:
                            FOR EACH b-tt-dados WHERE 
                                     b-tt-dados.nome-abrev = tt-dados.nome-abrev AND 
                                     b-tt-dados.nr-docto   = tt-dados.nr-docto :
                                ASSIGN b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                            END.                         

                            FIND LAST cotas WHERE 
                                      cotas.cod-estabel      = atu-cota.cod-estabel AND 
                                      cotas.cod-canal-venda  = atu-cota.cod-canal-venda AND 
                                      cotas.cod-gr-cli       = atu-cota.cod-gr-cli AND 
                                      cotas.nome-abrev       = atu-cota.nome-abrev-cotas AND 
                                      cotas.nome-ab-reg      = atu-cota.nome-ab-reg AND 
                                      cotas.nome-mic-reg     = atu-cota.nome-mic-reg AND 
                                      cotas.cod-rep          = atu-cota.cod-rep AND 
                                      cotas.cd-produto       = atu-cota.cd-produto AND 
                                      cotas.dt-inicial      <= atu-cota.dt-inicial AND 
                                      cotas.dt-final        >= atu-cota.dt-final  EXCLUSIVE-LOCK NO-ERROR.

                            IF AVAIL cotas THEN DO:
                               IF atu-cota.qt-ped-reprov = 0 THEN  
                                  ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida 
                                         atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov 
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.
                               ELSE IF atu-cota.qt-pedida <> 0 THEN
                                  ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida 
                                         atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-pedida 
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.
                            END.          
                          END.
                       END.
                    END.         

                END. /*l-atu-aprov*/    
            END. /*ped-parcial*/     
        END.  /*last-of*/       
    END.

END PROCEDURE.


PROCEDURE pi-nao-encontrou-cotas.

    /** Nivel Canal Venda **/ 
    IF tt-dados.nivel = "Canal":U THEN DO:
       IF par-cota.cota-impl-canal-venda = 2 THEN DO:
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 THEN DO:  

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Canal_Venda MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).
             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.

          ELSE      
              ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-canal-venda = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-canal-venda = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.


    END. 

    /** Nivel Grupo Cliente **/ 
    IF tt-dados.nivel = "Grupo":U THEN DO:
       IF par-cota.cota-impl-gr-cli = 2 THEN DO:
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 THEN DO:

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Grupo_Cliente MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).
             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-gr-cli = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-gr-cli = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

    END. /*grupo cliente*/

    /** Nivel Cliente **/ 
    IF tt-dados.nivel = "Cliente":U THEN DO:
       IF par-cota.cota-impl-cliente = 2 THEN DO:
          IF tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 THEN DO:

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Cliente MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).
             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-cliente = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-cliente = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

    END. /*cliente*/


    /** Nivel Regiao **/ 
    IF tt-dados.nivel = "Regiao":U THEN DO:
       IF par-cota.cota-impl-ab-reg = 2 THEN DO: 
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 THEN DO:

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Regi∆o MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).
             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-ab-reg = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-ab-reg = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.       

    END. /*regiao*/                                 

    /** Nivel Microrregiao **/ 
    IF tt-dados.nivel = "Microrregiao":U THEN DO:
       IF par-cota.cota-impl-mic-reg = 2 THEN DO:
          IF tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 THEN DO:

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Microrregi∆o MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).
             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.  
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.  

       IF par-cota.cota-impl-mic-reg = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.

       IF par-cota.cota-impl-mic-reg = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.       

    END.                                   

    /** Nivel Representante **/ 
    IF tt-dados.nivel = "Representante":U THEN DO:
       IF par-cota.cota-impl-repres = 2 THEN DO:
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 THEN DO:

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = TRIM(RETURN-VALUE).
             {utp/ut-liter.i n°vel_Representante MAC c} c-texto[2] = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "msg",
                                INPUT 16381,
                                INPUT c-texto[1] + "~~" + c-texto[2] ).

             CREATE tt-erros.
             ASSIGN tt-erros.cod-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.desc-erro   = RETURN-VALUE
                    tt-dados.cod-sit-com = 2.
          END.  
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.
       IF par-cota.cota-impl-repres = 3 THEN DO: /*prossegue normal*/
          IF tt-dados.log-tipo-oper = 1 OR 
             tt-dados.log-tipo-oper = 3 OR 
             tt-dados.log-tipo-oper = 9 THEN  
             ASSIGN tt-dados.cod-sit-com = 2.
          ELSE     
             ASSIGN tt-dados.cod-sit-com = 3.
       END.
       IF par-cota.cota-impl-repres = 4 THEN DO: /*criar cotas*/
          IF tt-dados.log-tipo-oper = 1 OR tt-dados.log-tipo-oper = 3 OR tt-dados.log-tipo-oper = 9 THEN  
             RUN pi-cria-cotas.
          ELSE      
             ASSIGN tt-dados.cod-sit-com = 3.
       END.       
    END.    

END PROCEDURE.


PROCEDURE pi-trata-aprova-reprovacao-forcada.

    /* atualiza cotas e base-cota para aprovacao e reprovacao forcada */ 
    IF NOT AVAIL cotas THEN DO:
       /* nr da transacao */ 
       FOR LAST b-cotas FIELDS(nr-trans) NO-LOCK USE-INDEX ch-cot :
           ASSIGN i-nr-trans =  ( b-cotas.nr-trans + 1 ) .    
       END.
       IF NOT AVAIL b-cotas THEN 
          ASSIGN i-nr-trans = 1.    

       CREATE cotas.
       ASSIGN cotas.cod-estabel      = tt-dados.cod-estabel
              cotas.cod-canal-venda  = tt-dados.cod-canal-venda
              cotas.cod-gr-cli       = tt-dados.cod-gr-cli
              cotas.nome-abrev       = tt-dados.nome-abrev-cotas
              cotas.nome-ab-reg      = tt-dados.nome-ab-reg
              cotas.nome-mic-reg     = tt-dados.nome-mic-reg
              cotas.cod-rep          = tt-dados.cod-rep
              cotas.cd-produto       = base-cota.cd-produto-dest
              cotas.dt-inicial       = base-cota.dt-inicial
              cotas.dt-final         = base-cota.dt-final
              cotas.nr-trans         = i-nr-trans
              cotas.vl-previsto      = 0
              cotas.qt-prevista      = 0.
    END.

    IF tt-dados.log-tipo-oper = 7 THEN DO: /*aprovacao forcada*/ 
       ASSIGN cotas.qt-pedida      = cotas.qt-pedida + de-qt-aux
              cotas.vl-pedido      = cotas.vl-pedido + de-vl-aux
              tt-dados.cod-sit-com = 2. /*aprov*/
              tt-dados.log-erro    = YES /*para que nao entre rotinas posteriores*/ . 

       IF tt-dados.cod-rep <> ? THEN DO:
          find current base-cota exclusive-lock.
          IF par-cota.tipo-controle = 2 THEN  
             ASSIGN base-cota.qt-pedida = base-cota.qt-pedida + de-vl-aux.
          ELSE   
             ASSIGN base-cota.qt-pedida = base-cota.qt-pedida + de-qt-aux.
          find current base-cota no-lock.

       END.      
    END.          
    IF tt-dados.log-tipo-oper = 8 THEN  /*reprovacao forcada*/
       ASSIGN cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
              cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
              tt-dados.cod-sit-com = 3 /*reprov*/
              tt-dados.log-erro    = YES /*para que nao entre rotinas posteriores*/ . 

    /* atualiza atu-cota */       
    FIND LAST atu-cota WHERE 
              atu-cota.cod-estabel      =  cotas.cod-estabel AND 
              atu-cota.cod-canal-venda  =  cotas.cod-canal-venda AND
              atu-cota.cod-gr-cli       =  cotas.cod-gr-cli AND
              atu-cota.nome-abrev-cotas =  cotas.nome-abrev AND
              atu-cota.nome-abrev       =  tt-dados.nome-abrev AND
              atu-cota.nome-ab-reg      =  cotas.nome-ab-reg AND
              atu-cota.nome-mic-reg     =  cotas.nome-mic-reg AND
              atu-cota.cod-rep          =  cotas.cod-rep AND
              atu-cota.cd-produto       =  cotas.cd-produto AND       
              atu-cota.dt-inicial      <= (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega) AND
              atu-cota.dt-final        >= cotas.dt-final AND 
              atu-cota.nr-pedcli        =  tt-dados.nr-docto EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL atu-cota THEN DO:
       CREATE atu-cota.
       ASSIGN atu-cota.nome-abrev       =  tt-dados.nome-abrev
              atu-cota.nr-pedcli        =  tt-dados.nr-docto
              atu-cota.cod-estabel      =  cotas.cod-estabel
              atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
              atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
              atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
              atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
              atu-cota.cod-rep          =  cotas.cod-rep
              atu-cota.cd-produto       =  cotas.cd-produto   
              atu-cota.nome-abrev-cotas =  cotas.nome-abrev    
              atu-cota.dt-inicial       = (IF par-cota.tipo-data = 1 THEN tt-dados.dt-emissao ELSE tt-dados.dt-entrega)
              atu-cota.dt-final         =  cotas.dt-final NO-ERROR.
       IF tt-dados.log-tipo-oper = 7 THEN /*aprovacao forcada*/
          ASSIGN atu-cota.qt-pedida = de-qt-aux 
                 atu-cota.vl-pedido = de-vl-aux. 
       IF tt-dados.log-tipo-oper = 8 THEN /*reprovacao forcada*/            
          ASSIGN atu-cota.qt-ped-reprov = de-qt-aux 
                 atu-cota.vl-ped-reprov = de-vl-aux.
    END.
    ELSE DO:
       IF tt-dados.log-tipo-oper = 7 THEN /*aprovacao forcada*/
          ASSIGN atu-cota.qt-pedida = atu-cota.qt-pedida + de-qt-aux
                 atu-cota.vl-pedido = atu-cota.vl-pedido + de-vl-aux.
       IF tt-dados.log-tipo-oper = 8 THEN /*reprovacao forcada*/
          ASSIGN atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + de-qt-aux 
                 atu-cota.vl-ped-reprov = de-vl-aux + atu-cota.vl-ped-reprov.
    END. 

END PROCEDURE .



PROCEDURE pi-cria-cotas.

    /* nr da transacao */ 
    FOR LAST b-cotas FIELDS(nr-trans) NO-LOCK USE-INDEX ch-cot :
        ASSIGN i-nr-trans =  ( b-cotas.nr-trans + 1 ) .    
    END.
    IF NOT AVAIL b-cotas THEN 
       ASSIGN i-nr-trans = 1.    

    IF NOT AVAIL cotas THEN DO: 
       CREATE cotas.
       ASSIGN cotas.cod-estabel      = tt-dados.cod-estabel
              cotas.cod-canal-venda  = tt-dados.cod-canal-venda
              cotas.cod-gr-cli       = tt-dados.cod-gr-cli
              cotas.nome-abrev       = tt-dados.nome-abrev-cotas
              cotas.nome-ab-reg      = tt-dados.nome-ab-reg
              cotas.nome-mic-reg     = tt-dados.nome-mic-reg
              cotas.cod-rep          = tt-dados.cod-rep
              cotas.cd-produto       = base-cota.cd-produto-dest
              cotas.dt-inicial       = base-cota.dt-inicial
              cotas.dt-final         = base-cota.dt-final
              cotas.nr-trans         = i-nr-trans
              cotas.vl-previsto      = 0
              cotas.qt-prevista      = 0.
    END.          

END PROCEDURE.


