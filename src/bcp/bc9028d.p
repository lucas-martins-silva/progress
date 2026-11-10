/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028D 2.00.00.024 } /*** "010024" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9028d MBC}
&ENDIF

/***********************************************************************************
** Copyright DATASUL S.A. (2000)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
**********************************************************************************/
/**********************************************************************************
**     Programa...: bc9028d.p  
**
**     Finalidade.: Adapter da transacao de Reporte Por Ordem
**                                          Reporte Por Opera??o
**                                          Reporte Por Ponto de Controle
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02                 */
{cdp/cdcfgmat.i} /* Include com preprocessador para release 2.02                 */
{cpp/cpapi001.i} /* Definicao das temp-tables da API de reporte BATCH            */
{bcp/bcapi004.i} /* Definicao da temp-table tt-prog-bc                           */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{method/dbotterr.i}
{include/i_dbvers.i}
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/
DEFINE VARIABLE c-conteudo          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-cod-estabel       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i-conteudo          AS INTEGER              NO-UNDO.
DEFINE VARIABLE i-tipo-reporte      AS INTEGER              NO-UNDO.
DEFINE VARIABLE i-num-serial        AS DECIMAL              NO-UNDO.
DEFINE VARIABLE h-cpapi001          AS HANDLE               NO-UNDO.
DEFINE VARIABLE h_bosc075           AS HANDLE               NO-UNDO.

DEFINE VARIABLE h_api_cta_ctbl      AS HANDLE               NO-UNDO.
DEFINE VARIABLE c-ct-refugo         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-sc-refugo         AS CHARACTER            NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
            FIELD ttv_num_cod_erro    AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
            FIELD ttv_des_msg_ajuda   AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
            FIELD ttv_des_msg_erro    AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistˆncia".

/*********************************************************************************/
{include/i-epc200.i "cpapi007"} /* Definicao de elementos referentes a UPC       */
{cpp/cpapi001.i1}
/*********************************************************************************/

/*********************************************************************************/
DO:
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
   IF NOT AVAIL ttIntegracao THEN DO:
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 25346,
                        INPUT "BC9003D":U).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 25346
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   FIND FIRST param-global NO-LOCK NO-ERROR.
   IF NOT AVAIL param-global THEN DO:
      {utp/ut-table.i mguni param-global 1}
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 56,
                        INPUT TRIM(RETURN-VALUE)).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 56
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   FIND FIRST param-cp NO-LOCK NO-ERROR.
   IF NOT AVAIL param-cp THEN DO:
      {utp/ut-table.i mgind param-cp 1}
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 56,
                        INPUT TRIM(RETURN-VALUE)).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 56
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   
   ASSIGN i-tipo-reporte = _RetornaValInte('num-livre-1').
   
   IF i-tipo-reporte = 1          /* ordem             */
      OR i-tipo-reporte = 2       /* operacao          */
      OR i-tipo-reporte = 3  THEN /* ponto de controle */
      RUN piProcessaReporte.
   ELSE /* item */
      RUN bcp/bc9028e.p (INPUT pNumTrans,
                         INPUT TABLE ttIntegracao,
                         INPUT-OUTPUT TABLE tt-erro).
END.

PROCEDURE piProcessaReporte: /* ponto de controle e operacao */
   DEF VAR c-retorno   AS CHARACTER NO-UNDO.
   DEF VAR l-finaliza  AS LOGICAL   NO-UNDO.

   RUN pi-initializeDBO IN THIS-PROCEDURE.
   DO TRANSACTION ON ERROR UNDO, LEAVE:
      ASSIGN c-conteudo = _RetornaValChar('cod-item').
       
      FIND FIRST item
           WHERE item.it-codigo = c-conteudo NO-LOCK NO-ERROR.   
      IF NOT AVAIL item THEN DO:
         {utp/ut-table.i mgind item 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = 56
                tt-erro.mensagem = TRIM(RETURN-VALUE).
         RETURN 'NOK':U.
      END.
      
      ASSIGN i-conteudo = _RetornaValInte('nr-ord-produ').
      
      FIND FIRST ord-prod
           WHERE ord-prod.nr-ord-produ = i-conteudo NO-LOCK NO-ERROR.      
      IF NOT AVAIL ord-prod THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         {utp/ut-table.i mgind ord-prod 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = 56
                tt-erro.mensagem = TRIM(RETURN-VALUE).
         RETURN 'NOK':U.
      END.
      
      FIND FIRST estabelec
           WHERE estabelec.cod-estabel = ord-prod.cod-estabel NO-LOCK NO-ERROR.
      IF NOT AVAIL estabelec THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         {utp/ut-table.i mgind estabelec 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = 56
                tt-erro.mensagem = TRIM(RETURN-VALUE).
         RETURN 'NOK':U.
      END.
      
      CREATE tt-prog-bc.
      ASSIGN tt-prog-bc.cod-versao-integracao    = 1
             tt-prog-bc.nr-trans                 = pNumTrans
             tt-prog-bc.opcao                    = 2.
      
      IF AVAIL param-global AND param-global.modulo-cl THEN DO:
         RUN bcp/bcapi004.p (INPUT-OUTPUT TABLE tt-prog-bc,
                             INPUT-OUTPUT TABLE tt-erro).
      END.
      
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         RETURN 'NOK':U.
      END.
      FIND FIRST tt-prog-bc NO-LOCK NO-ERROR.
      
      CREATE tt-rep-prod.
      
      ASSIGN tt-rep-prod.tipo                    = _RetornaValInte('tipo')
             tt-rep-prod.cod-versao-integracao   = 1
             tt-rep-prod.nr-ord-produ            = Ord-Prod.nr-ord-produ
             tt-rep-prod.it-codigo               = Item.It-codigo.
      
      ASSIGN tt-rep-prod.cod-depos-sai           = _RetornaValChar('cod-depos-sai')
             tt-rep-prod.cod-local-sai           = _RetornaValChar('cod-local-sai')
             tt-rep-prod.data                    = _RetornaValData('data')
             tt-rep-prod.un                      = ( IF _RetornaValChar('un') = '' THEN Item.un ELSE _RetornaValChar('un'))
             tt-rep-prod.ct-codigo               = ( IF _RetornaValChar('ct-codigo') = '' THEN Ord-Prod.ct-codigo ELSE _RetornaValChar('ct-codigo'))
             tt-rep-prod.sc-codigo               = ( IF _RetornaValChar('sc-codigo') = '' THEN Ord-Prod.sc-codigo ELSE _RetornaValChar('sc-codigo'))
             tt-rep-prod.cod-cta-unif            = _RetornaValChar('cod-cta-unif')
             tt-rep-prod.cod-ccusto-unif         = _RetornaValChar('cod-ccusto-unif')
             tt-rep-prod.nro-docto               = ( IF _RetornaValChar('nro-docto') = "" THEN STRING(Ord-Prod.nr-ord-produ) ELSE _RetornaValChar('nro-docto'))
             tt-rep-prod.serie-docto             = _RetornaValChar('serie-docto')
             tt-rep-prod.cod-depos               = _RetornaValChar('cod-depos')
             tt-rep-prod.cod-localiz             = _RetornaValChar('cod-localiz')
             tt-rep-prod.lote-serie              = _RetornaValChar('lote-serie')
             tt-rep-prod.cod-refer               = _RetornaValChar('cod-refer')
             tt-rep-prod.dt-vali-lote            = _RetornaValData('dt-vali-lote').
      
      ASSIGN tt-rep-prod.op-codigo               = _RetornaValInte('op-codigo')
             tt-rep-prod.cod-roteiro             = _RetornaValChar('cod-roteiro')
             tt-rep-prod.it-oper                 = ( IF _RetornaValChar('it-oper') = "" THEN Item.It-codigo ELSE _RetornaValChar('it-oper'))
             tt-rep-prod.pto-controle            = _RetornaValInte('pto-controle')
             tt-rep-prod.baixa-reservas          = _RetornaValInte('baixa-reservas')
             tt-rep-prod.requis-automatica       = _RetornaValLogi('requis-automatica')
             tt-rep-prod.finaliza-oper           = _RetornaValLogi('finaliza-oper').
      
      ASSIGN tt-rep-prod.sequencia               = _RetornaValInte('sequencia')
             tt-rep-prod.time-out                = _RetornaValInte('time-out')
             tt-rep-prod.tentativas              = _RetornaValInte('tentativas')
             tt-rep-prod.carrega-reservas        = _RetornaValLogi('carrega-reservas')
             tt-rep-prod.prog-seg                = _RetornaValChar('prog-seg')  
             tt-rep-prod.requis-automatica       = _RetornaValLogi('requis-automatica')
             tt-rep-prod.procura-saldos          = _RetornaValLogi('procura-saldos')   
             tt-rep-prod.reserva                 = _RetornaValLogi('reserva').
      
      ASSIGN tt-rep-prod.nro-ord-seq             = _RetornaValInte('nro-ord-seq').    
      
      IF _RetornaValLogi('Finaliza-Ordem') THEN 
         ASSIGN l-finaliza = _RetornaValLogi('Finaliza-Ordem').
      ELSE IF tt-prog-bc.muda-status = NO          /* n?o muda estado */
         OR tt-prog-bc.motivo-backflush <> 1 THEN  /* reporte diferene de normal */
         ASSIGN l-finaliza = NO. /* n?o fecha a ordem */
      ELSE If (ord-prod.qt-produzida + _RetornaValDeci('qt-reporte')) >= ord-prod.qt-ordem THEN
         ASSIGN l-finaliza = YES.
      ELSE 
         ASSIGN l-finaliza = NO.      
      
      ASSIGN tt-rep-prod.linha                   = _RetornaValInte('linha')
             &IF DEFINED (bf_man_sfc_lc) &THEN  
               tt-rep-prod.dep-refugo            = _RetornaValChar('dep-refugo')
               tt-rep-prod.loc-refugo            = _RetornaValChar('loc-refugo')
             &ENDIF
             tt-rep-prod.finaliza-ordem          = l-finaliza. 
            
      FIND FIRST tt-erro NO-LOCK NO-ERROR.
      IF AVAIL tt-erro THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         RETURN "NOK":U.
      END.
      
      CASE tt-prog-bc.motivo-backflush:
         WHEN 1 THEN
             ASSIGN tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
         WHEN 2 THEN DO:         
            ASSIGN tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                   tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                   tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
            
            IF tt-rep-prod.qt-refugo > 0 THEN DO:
               ASSIGN c-ct-refugo = IF _RetornaValChar('ct-refugo') = '' THEN tt-prog-bc.cod-cta-refugo-unif ELSE _RetornaValChar('ct-refugo')
                      c-sc-refugo = IF _RetornaValChar('sc-refugo') = '' THEN tt-prog-bc.cod-ccusto-refugo-unif ELSE _RetornaValChar('sc-refugo').
               
               /*Valida conta contabil*/            
               RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT estabelec.ep-codigo,     /* EMPRESA EMS2 */
                                                               INPUT ord-prod.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                               INPUT "",                      /* UNIDADE NEGàCIO */
                                                               INPUT "",                      /* PLANO CONTAS */ 
                                                               INPUT c-ct-refugo,             /* CONTA */
                                                               INPUT "",                      /* PLANO CCUSTO */ 
                                                               INPUT c-sc-refugo,             /* CCUSTO */
                                                               INPUT TODAY,                   /* DATA TRANSACAO */
                                                               OUTPUT TABLE tt_log_erro).      /* ERROS */
               IF RETURN-VALUE = "NOK":U THEN DO:
                  RUN pi-destroyDBO IN THIS-PROCEDURE.
                  FOR FIRST tt_log_erro:
                     CREATE tt-erro.
                     ASSIGN tt-erro.mensagem = tt_log_erro.ttv_des_msg_erro
                            tt-erro.cd-erro  = tt_log_erro.ttv_num_cod_erro.
                  END.
                  RETURN 'NOK':U.
               END.
               ASSIGN tt-rep-prod.qt-reporte      = _RetornaValDeci('qt-reporte')
                      tt-rep-prod.qt-refugo       = _RetornaValDeci('qt-refugo')
                      tt-rep-prod.qt-apr-cond     = _RetornaValDeci('qt-apr-cond')
                      tt-rep-prod.ct-refugo       = c-ct-refugo
                      tt-rep-prod.sc-refugo       = c-sc-refugo.
               
               CREATE tt-refugo.
               ASSIGN tt-refugo.nr-ord-produ  = Ord-Prod.nr-ord-produ
                      tt-refugo.codigo-rejei  = tt-prog-bc.codigo-rejei.
               ASSIGN tt-refugo.qt-refugo     = _RetornaValDeci('qt-refugo')
                      tt-refugo.observacao    = "".
            END.
         END.
         WHEN 3 THEN DO:
            ASSIGN tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                   tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                   tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
            
            IF tt-rep-prod.qt-apr-cond > 0 THEN DO:
               CREATE tt-refugo.
               ASSIGN tt-refugo.nr-ord-produ = Ord-Prod.nr-ord-produ
                      tt-refugo.codigo-rejei = tt-prog-bc.codigo-rejei.
               ASSIGN tt-refugo.qt-refugo    = _RetornaValDeci('qt-refugo')
                      tt-refugo.observacao   = "".
            END.            
         END.
      END.
      
      /* procedimentos WMS */
      ASSIGN i-num-serial  = _RetornaValDeci('num-serial')
             c-cod-estabel = _RetornaValChar('cod-estabel').
      
      IF i-tipo-reporte = 1 /* ordem          */ THEN DO:
         RUN geraCargaProducao IN h_bosc075 (INPUT c-cod-estabel,
                                             INPUT tt-rep-prod.cod-depos,
                                             INPUT i-num-serial).
         IF RETURN-VALUE <> "OK":U THEN DO:
            RUN getRowErrors IN h_bosc075 (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
               RUN pi-destroyDBO IN THIS-PROCEDURE.
               FOR EACH RowErrors NO-LOCK:         
                  CREATE tt-erro.
                  ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                         tt-erro.mensagem = RowErrors.ErrorDescription.
               END.
               RETURN 'NOK':U.
            END.
         END.
      END.
   
      IF i-tipo-reporte = 2 THEN DO: /* operacao */
         FIND FIRST oper-ord
              WHERE oper-ord.nr-ord-produ = tt-rep-prod.nr-ord-produ
                AND oper-ord.log-operac-final = YES NO-LOCK NO-ERROR.
         IF oper-ord.op-codigo = tt-rep-prod.op-codigo THEN DO:
            RUN geraCargaProducao IN h_bosc075 (INPUT c-cod-estabel,
                                                INPUT tt-rep-prod.cod-depos,
                                                INPUT i-num-serial).
            IF RETURN-VALUE <> "OK":U THEN DO:
               RUN getRowErrors IN h_bosc075 (OUTPUT TABLE RowErrors).
               IF CAN-FIND(FIRST RowErrors) THEN DO:
                  RUN pi-destroyDBO IN THIS-PROCEDURE.
                  FOR EACH RowErrors NO-LOCK:
                     CREATE tt-erro.
                     ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                            tt-erro.mensagem = RowErrors.ErrorDescription.
                  END.
                  RETURN 'NOK':U.
               END.
            END.
         END.
      END.
      
      IF i-tipo-reporte = 3 /* ponto de controle */ THEN DO:
         FIND FIRST oper-ord
              WHERE oper-ord.nr-ord-produ = tt-rep-prod.nr-ord-produ
                AND oper-ord.log-operac-final = YES NO-LOCK NO-ERROR.
         
         IF oper-ord.pto-controle = tt-rep-prod.pto-controle THEN DO:
            RUN geraCargaProducao IN h_bosc075 (INPUT c-cod-estabel,
                                                INPUT tt-rep-prod.cod-depos,
                                                INPUT i-num-serial).
            IF RETURN-VALUE <> "OK":U THEN DO:
               RUN getRowErrors IN h_bosc075 (OUTPUT TABLE RowErrors).
               IF CAN-FIND(FIRST RowErrors) THEN DO:
                  RUN pi-destroyDBO IN THIS-PROCEDURE.
                  FOR EACH RowErrors NO-LOCK:               
                     CREATE tt-erro.
                     ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                            tt-erro.mensagem = RowErrors.ErrorDescription.
                  END.
                  RETURN 'NOK':U.
               END.
            END.
         END.
      END.

      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "Before-load":U:
         DELETE tt-epc.
      END.
      
      FOR EACH reservas FIELDS ( nr-ord-produ
                                 quant-orig)
         WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ
           AND reservas.quant-orig <> 0 NO-LOCK:
      
         CREATE tt-epc.
         ASSIGN tt-epc.cod-event     = "Before-load":U
                tt-epc.cod-parameter = "reservas-rowid":U
                tt-epc.val-parameter = STRING(ROWID(reservas)).
      END.
      
      {include/i-epc201.i "Before-load"}
      IF NOT VALID-HANDLE(h-cpapi001) THEN DO:
         RUN cpp/cpapi001.p PERSISTENT SET h-cpapi001  ( INPUT-OUTPUT TABLE tt-rep-prod,
                                                         INPUT TABLE tt-refugo,
                                                         INPUT TABLE tt-res-neg,
                                                         INPUT TABLE tt-apont-mob,
                                                         INPUT-OUTPUT TABLE tt-erro,
                                                         INPUT YES).
      END.      
      
      /* Permite baixar saldo do componente a menor que a reserva */      
      FIND FIRST tt-rep-prod NO-LOCK NO-ERROR.
      
      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "Before-Report":U
            OR tt-epc.cod-event = "After-Report":U:
         DELETE tt-epc.
      END.
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Handle-Cpapi001":U
             tt-epc.val-parameter = STRING(h-cpapi001).  /* Na UPC usar Widget-Handle(h-cpapi001) */
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Num-Ordem-Prod":U
             tt-epc.val-parameter = STRING(tt-rep-prod.nr-ord-produ).
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Tipo-Ordem":U
             tt-epc.val-parameter = STRING(tt-rep-prod.tipo).
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Item-Ordem":U
             tt-epc.val-parameter = STRING(tt-rep-prod.it-codigo).
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Quantidade-Ordem":U
             tt-epc.val-parameter = STRING(tt-rep-prod.qt-reporte).
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Reserva":U
             tt-epc.val-parameter = STRING(tt-rep-prod.reserva).
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Handle-Bc9003d":U
             tt-epc.val-parameter = STRING(THIS-PROCEDURE).  /* Na UPC usar Widget-Handle(h-cpapi001) */
      
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Before-Report":U
             tt-epc.cod-parameter = "Nr-Trans":U
             tt-epc.val-parameter = STRING(pNumTrans).
      
      {include/i-epc201.i "Before-Report"}
      
      /* Como a CPAPI001 esta sendo executa persistent somente ser? necess?rio executar a procedure que dar? inicio ao reporte
         Esta procedure esta dentro do programa CPAPI001.p */
      
      /* Caso seja feita alguma altera??o nos valores das TTs abaixo, as procedures abaixo ir?o atualizar */
      RUN pi-retorna-tt-rep-prod  IN h-cpapi001 (OUTPUT TABLE tt-rep-prod).
      RUN pi-retorna-tt-refugo  IN h-cpapi001 (OUTPUT TABLE tt-refugo).
      IF NOT AVAIL tt-rep-prod THEN
         FIND FIRST tt-rep-prod NO-LOCK NO-ERROR.
      
      IF NOT AVAIL oper-ord THEN
         FIND FIRST oper-ord
              WHERE oper-ord.nr-ord-produ = tt-rep-prod.nr-ord-produ NO-LOCK NO-ERROR.
      
      FIND FIRST ficha-cq 
           WHERE ficha-cq.it-codigo   = tt-rep-prod.it-codigo 
             AND ficha-cq.cod-estabel = c-cod-estabel
             AND ficha-cq.cod-depos   = tt-rep-prod.cod-depos 
             AND ficha-cq.cod-localiz = tt-rep-prod.cod-localiz
             AND ficha-cq.lote        = tt-rep-prod.lote-serie 
             AND ficha-cq.situacao    < 4 
             AND ficha-cq.op-seq      = IF AVAIL oper-ord AND ord-prod.rep-prod <> 1 AND ord-prod.rep-prod <> 4 THEN oper-ord.sequencia ELSE 0 NO-LOCK NO-ERROR.      
      IF AVAIL ficha-cq THEN DO:
         FIND FIRST param-cp NO-LOCK NO-ERROR.
         IF param-cp.log-ficha-ord = YES THEN
            RUN pi-valida-ficha-cq IN h-cpapi001 (INPUT NO).
      END.      
      ELSE DO:
         RUN pi-valida-ficha-cq IN h-cpapi001 (INPUT YES).
      END.
      
      RUN pi-processa-reportes IN h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                              INPUT TABLE tt-refugo,
                                              INPUT TABLE tt-res-neg,
                                              INPUT-OUTPUT TABLE tt-erro,
                                              INPUT YES,   /* Delete Erros */
                                              INPUT YES).
      ASSIGN c-retorno = RETURN-VALUE.
      
      IF RETURN-VALUE = "NOK":U THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         
         RUN utp/ut-msgs.p (INPUT "MSG":U,
                            INPUT 27611,
                            INPUT "").
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = 27611
                tt-erro.mensagem = TRIM(RETURN-VALUE).
         
         FIND FIRST tt-erro NO-LOCK NO-ERROR.
         IF AVAIL tt-erro THEN
            RETURN ERROR.
      END.
      ELSE DO :
         EMPTY TEMP-TABLE tt-erro.
      END.
      
      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "Before-Report":U:
         ASSIGN tt-epc.cod-event = "After-Report":U.
      END.
      
      {include/i-epc201.i "After-Report"}
      
      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "Before-Report":U:
         DELETE tt-epc.
      END.
      
      /* Chamada EPC para Itatiaia */
      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "After-load":U:
         DELETE tt-epc.
      END.
      
      FOR EACH tt-epc
         WHERE tt-epc.cod-event = "Before-load":U:
         DELETE tt-epc.
      END.
      
      FIND FIRST tt-rep-prod NO-LOCK NO-ERROR.      
      IF tt-rep-prod.finaliza-oper THEN DO:
         FOR EACH reservas FIELDS ( nr-ord-produ
                                    quant-orig)
            WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ
              AND reservas.quant-orig  <> 0 NO-LOCK:
         
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "After-load":U
                   tt-epc.cod-parameter = "reservas-rowid":U
                   tt-epc.val-parameter = STRING(ROWID(reservas)). 
         END.
         {include/i-epc201.i "After-load"}
      END.
      
      IF c-retorno = "NOK":U THEN DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         RETURN ERROR.   
      END.
      RUN pi-destroyDBO IN THIS-PROCEDURE.
   END.   
END PROCEDURE.

/* possibilitar que epc retorne a tt-res-neg para o bc9003d */
PROCEDURE pi-retorna-tt-rep-prod: 
   DEFINE OUTPUT PARAMETER TABLE FOR tt-rep-prod.
END.

PROCEDURE pi-recebe-tt-rep-prod: 
   DEFINE INPUT PARAMETER TABLE FOR tt-rep-prod.
END.

PROCEDURE pi-retorna-tt-refugo: 
   DEFINE OUTPUT PARAMETER TABLE FOR tt-refugo.
END.

PROCEDURE pi-recebe-tt-refugo: 
   DEFINE INPUT PARAMETER TABLE FOR tt-refugo.
END.

PROCEDURE pi-retorna-tt-res-neg: 
   DEFINE OUTPUT PARAMETER TABLE FOR tt-res-neg.
END.

PROCEDURE pi-recebe-tt-res-neg: 
   DEFINE INPUT PARAMETER TABLE FOR tt-res-neg.
END.

PROCEDURE pi-initializeDBO:
   IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
      RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

   IF NOT VALID-HANDLE(h_bosc075) THEN DO:
      RUN scbo/bosc075.p PERSISTENT SET h_bosc075.
   END.      
END PROCEDURE.

PROCEDURE pi-destroyDBO:
   IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
      DELETE OBJECT h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
   END.
   
   IF VALID-HANDLE(h_bosc075) THEN
      RUN destroy IN h_bosc075.   
      
   IF VALID-HANDLE(h-cpapi001) THEN DO:
      RUN pi-finalizar IN h-cpapi001.
      ASSIGN h-cpapi001 = ?.
   END.
END PROCEDURE.
