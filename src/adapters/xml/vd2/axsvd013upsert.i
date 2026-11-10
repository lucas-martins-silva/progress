PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cEvent       AS CHARACTER INITIAL ?    NO-UNDO.
DEFINE INPUT  PARAM cTranAction  AS CHARACTER INITIAL ?    NO-UNDO.
DEFINE INPUT  PARAM rw-emitente  AS ROWID                  NO-UNDO.
DEFINE INPUT  PARAM p-nr-pedcli  LIKE ped-venda.nr-pedcli  NO-UNDO.
DEFINE INPUT  PARAM p-nome-abrev LIKE ped-venda.nome-abrev NO-UNDO.
DEFINE OUTPUT PARAM p-saldo      AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR tt-param-aval.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro. 
/*PARAMETERS - END*/

FIND FIRST para-ped      NO-LOCK NO-ERROR.
FIND FIRST tt-param-aval NO-LOCK NO-ERROR.
FIND FIRST param-global  NO-LOCK NO-ERROR.

/*LOCAL VARIABLES - BEGIN*/
DEF VAR i-nro-dias-atraso  AS DECIMAL NO-UNDO. /*Nro Dias Atraso*/ 
DEF VAR de-vl-tot-ped-cre  AS DECIMAL NO-UNDO. /*Valor Total de Pedidos em Aberto e Reprovados por Cr‚dito*/  
DEF VAR de-vl-tot-ped-cot  AS DECIMAL NO-UNDO. /*Valor Total de Pedidos em Aberto e Reprovados por Cotas*/
DEF VAR de-vl-tot-ped-des  AS DECIMAL NO-UNDO. /*Valor Total de Pedidos em Aberto e Reprovados por Descontos e Bonifica‡äes*/ 
DEF VAR de-vl-tot-ped-pre  AS DECIMAL NO-UNDO. /*Valor Total de Pedidos em Aberto e Reprovados por Adm Pre‡os de Vendas*/
DEF VAR de-valor-item      AS DECIMAL NO-UNDO.
DEF VAR i-cod-sit-aval     AS INTEGER NO-UNDO.
DEF VAR i-cont             AS INTEGER NO-UNDO.
DEF VAR i-dias-maxatr      AS INTEGER NO-UNDO.
DEF VAR i-dias-admatr      AS INTEGER NO-UNDO.
DEF VAR de-lim-cred        AS DECIMAL NO-UNDO.
DEF VAR de-lim-cred-ad     AS DECIMAL NO-UNDO.
def var de-perc-max-dup    as decimal no-undo.

DEF VAR i-nr-pedido        LIKE ped-venda.nr-pedido NO-UNDO.
DEF VAR de-vl-contas-pagar LIKE est-ap.vl-maior-doc NO-UNDO. /*Valor do Contas … Pagar*/
/*LOCAL VARIABLES - END*/

DEFINE BUFFER bf-natur-oper FOR natur-oper.

&IF DEFINED (bf_dis_adm_preco) &THEN
    ASSIGN l-cm-log-consid-cotas-credito  = para-ped.log-consid-cotas-credito  
           l-cm-log-consid-desco-credito  = para-ped.log-consid-desco-credito  
           l-cm-log-consid-precos-credito = para-ped.log-consid-precos-credito
           l-cm-log-consid-cr-cr          = para-ped.log-consid-credito-credito.
&ENDIF

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE ttCreditEvaluationEnv.
EMPTY TEMP-TABLE tt_log_erro.

CREATE ttCreditEvaluationEnv.

FOR FIRST emitente 
    WHERE ROWID(emitente) = rw-emitente NO-LOCK: 

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = p-nr-pedcli
        AND   ped-venda.nome-abrev = p-nome-abrev NO-ERROR.

    IF  tt-param-aval.programa = "ft4050":U THEN DO: /* Avalia»’o de cr²dito para faturamento de balc’o */
        FIND wt-docto WHERE
             wt-docto.seq-wt-docto = tt-param-aval.nr-pedido NO-LOCK NO-ERROR.

        IF  NOT AVAIL wt-docto THEN   
            RETURN "OK".

        FIND natur-oper WHERE 
             natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND natur-oper WHERE 
             natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.
    END.

    ASSIGN ttCreditEvaluationEnv.creditoCliente  = emitente.ind-cre-cli
           ttCreditEvaluationEnv.avaliacaoCli    = emitente.ind-aval
           ttCreditEvaluationEnv.avaliacaoEmb    = emitente.ind-aval-emb
           ttCreditEvaluationEnv.reavaliaCred    = tt-param-aval.reavalia-forc
           ttCreditEvaluationEnv.tipoAvaliacao   = tt-param-aval.param-aval
           ttCreditEvaluationEnv.situacaoPedido  = ped-venda.cod-sit-aval
           ttCreditEvaluationEnv.motivoLiberCred = ped-venda.desc-forc
           ttCreditEvaluationEnv.especiePedido   = ped-venda.esp-ped
           ttCreditEvaluationEnv.vlTotPedido     = tt-param-aval.vl-a-avaliar
           ttCreditEvaluationEnv.progEms         = tt-param-aval.programa
           ttCreditEvaluationEnv.pedidoMP        = ped-venda.replica-pd.

    RUN pi-cria-tt-emitente.

    ASSIGN de-lim-cred    = 0
           de-lim-cred-ad = 0.

    FOR EACH tt-emitente NO-LOCK:
        FOR FIRST b-emitente 
            FIELDS (b-emitente.dt-lim-cre 
                    b-emitente.lim-credito
                    b-emitente.dt-fim-cred
                    b-emitente.lim-adicional 
                    b-emitente.moeda-libcre
                    &IF DEFINED (bf_dis_usu_moeda_cred)
                    &THEN b-emitente.moeda-libcre
                    &ENDIF)
            WHERE b-emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK:
            ASSIGN de-lim-cred    = de-lim-cred 
                                    + (IF b-emitente.dt-lim-cre >= TODAY   
                                       THEN (b-emitente.lim-credito * fn-indice(&IF DEFINED (bf_dis_usu_moeda_cred)
                                                                                &THEN b-emitente.moeda-libcre
                                                                                &ELSE para-ped.moeda-libcre
                                                                                &ENDIF)) ELSE 0 )
                   de-lim-cred-ad = de-lim-cred-ad             
                                    + (IF b-emitente.dt-fim-cred >= TODAY  
                                       THEN (b-emitente.lim-adicional * fn-indice(&IF DEFINED (bf_dis_usu_moeda_cred)
                                                                                  &THEN b-emitente.moeda-libcre
                                                                                  &ELSE para-ped.moeda-libcre
                                                                                  &ENDIF)) ELSE 0 ) .
        END.
    END.

    ASSIGN ttCreditEvaluationEnv.limiteCred   = de-lim-cred
           ttCreditEvaluationEnv.limiteCredAd = de-lim-cred-ad.

    IF  emitente.ind-abrange-aval = 1 THEN 
        FIND b-emitente WHERE ROWID(b-emitente) = ROWID(emitente) NO-LOCK NO-ERROR.
    ELSE 
        FIND b-emitente WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.

    ASSIGN ttCreditEvaluationEnv.dtLimiteCred   = b-emitente.dt-lim-cre
           ttCreditEvaluationEnv.dtLimiteCredAd = b-emitente.dt-fim-cred.
    
    IF param-global.modulo-mp THEN /* Dados Cliente nas outras plantas */  
       RUN pi-verifica-mp.

    IF param-global.modulo-cr THEN  /* titulos/AD em aberto e em atraso */ 
       RUN pi-saldo-cr (INPUT tt-param-aval.param-aval).

    IF tt-param-aval.param-aval = 1                                                                              
    OR tt-param-aval.param-aval = 3 THEN DO: /* Verificacao de Meses Inativo */                                  
                                                                                                                 
       RUN pi-verifica-mesina.        

       ASSIGN ttCreditEvaluationEnv.logInativo   = l-inativo
              ttCreditEvaluationEnv.logInativoMP = l-inativo-mp.

       RUN pi-verifica-atraso. /* VerIFicacao de atrasos no pagamento */

       &IF "{&bf_dis_versao_ems}":U >= "2.062":U &THEN
           ASSIGN de-lim-admatr = d-cm-val-aviso-db
                  de-lim-maxatr = d-cm-val-atraso-max.
       &else
           ASSIGN de-lim-admatr = para-ped.lim-admatr
                  de-lim-maxatr = para-ped.lim-maxatr.
       &endif
	   
	   assign de-perc-max-dup = dec(trim(substring(emitente.char-1,141,6))) no-error.
	   
	   if de-perc-max-dup > 0 then
		assign de-lim-maxatr = (de-perc-max-dup * emitente.lim-credito) / 100.
		
	   ASSIGN ttCreditEvaluationEnv.dtUltAtraso            = d-cr-ult-atraso
              ttCreditEvaluationEnv.dtUltAtrasoMP          = mp-dt-ult-atr
              ttCreditEvaluationEnv.logUltAtraso           = (d-cr-ult-atraso <> ?)
              ttCreditEvaluationEnv.logUltAtrasoMP         = (mp-dt-ult-atr <> ?)
              ttCreditEvaluationEnv.valorMaxAtrasoAvisoCli = de-tot-ad
              ttCreditEvaluationEnv.valorMaxAtrasoAviso    = de-lim-admatr
              ttCreditEvaluationEnv.valorMaxAtrasoAvisoDup = de-tot-tit
              ttCreditEvaluationEnv.valorMaxBloqCredCli    = de-lim-maxatr
              ttCreditEvaluationEnv.logChequeDevol         = l-cheque-devol.
    END.
    
    IF tt-param-aval.param-aval = 2
    OR tt-param-aval.param-aval = 3 THEN DO:
        IF  param-global.modulo-ap THEN 
            RUN pi-saldo-ap.

        RUN pi-verifica-pd.
        RUN pi-verifica-ft.
        
        ASSIGN ttCreditEvaluationEnv.valorContasPagar     = de-saldo-ap
               ttCreditEvaluationEnv.valorContasPagarMP   = mp-vl-ap-abe
               ttCreditEvaluationEnv.valorContasReceber   = de-saldo-cr
               ttCreditEvaluationEnv.valorContasReceberMP = mp-vl-cr-abe
               ttCreditEvaluationEnv.valorDuplicatas      = de-vl-nota
               ttCreditEvaluationEnv.valorTotalVlAp       = de-totvlap.

        &IF DEFINED(BF_DIS_ADM_PRECO) &THEN
            ASSIGN ttCreditEvaluationEnv.credito          = l-cm-log-consid-cr-cr
                   ttCreditEvaluationEnv.valorPedReprCred = de-totvlre.           
        &ENDIF
        
        IF  tt-param-aval.programa  = "ft4050":U /* Avalia»’o de cr²dito para faturamento de balc’o */  THEN 
            ASSIGN ttCreditEvaluationEnv.indiceMoeda = fn-indice(wt-docto.mo-codigo).
        ELSE DO:
            ASSIGN ttCreditEvaluationEnv.pedidoMP    = ped-venda.replica-pd
                   ttCreditEvaluationEnv.indiceMoeda = fn-indice(ped-venda.mo-codigo).
            
            IF NOT AVAIL natur-oper 
            OR natur-oper.nat-operacao <> ped-venda.nat-operacao THEN 
               FIND FIRST natur-oper WHERE 
                          natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.
            
            ASSIGN ttCreditEvaluationEnv.fatEntregaFut  = natur-oper.ind-entfut.     
                   ttCreditEvaluationEnv.itensForaHoriz = IF NOT CAN-FIND (FIRST ped-item OF ped-venda 
                                                                           WHERE ped-item.dt-entrega <= (TODAY + para-ped.horiz-fixo) NO-LOCK) THEN YES ELSE NO. 
        END.
    END.
END.

RUN PIUpsert(INPUT  cEvent,
             INPUT  cTranAction,
             INPUT  p-nr-pedcli,  
             INPUT  p-nome-abrev, 
             OUTPUT p-saldo,
             INPUT  TABLE ttCreditEvaluationEnv,
             OUTPUT TABLE tt_log_erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


procedure pi-executa-upc.

        /**** EPC para determinar o n£mero m ximo de dias em atraso ****/

        for each tt-epc
            where tt-epc.cod-event = "replicaPD":
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "replicaPD"
               tt-epc.cod-parameter = "setaReplicaPD"
               tt-epc.val-parameter = "nao".

        {include/i-epc201.i "replicapd"}

        if can-find (first tt-epc where
                           tt-epc.cod-event     = "replicaPD" and
                           tt-epc.cod-parameter = "setaReplicaPD" and
                           tt-epc.val-parameter = "sim") then
           assign l-considera-replica-pd = yes.

end procedure.

