
DEFINE TEMP-TABLE ttCreditEvaluationEnv NO-UNDO
    FIELD senha                        AS CHARACTER INITIAL ? /*senha acesso Intellector*/  
    FIELD tipo                         AS CHARACTER INITIAL ? /*tipo da politica = AvaliacaoPedido*/                            
    FIELD usuario                      AS CHARACTER INITIAL ? /*usuario de acesso ao Intellector*/ 
    FIELD cgc                          AS CHARACTER INITIAL ? /*CNPJ~\CPF cliente*/ 
    FIELD creditoCliente               AS INTEGER   INITIAL ? /*emitente.ind-cre-cli*/
    FIELD avaliacaoCli                 AS INTEGER   INITIAL ? /*emitente.ind-aval*/
    FIELD avaliacaoEmb                 AS INTEGER   INITIAL ? /*emitente.ind-aval-emb*/
    FIELD reavaliaCred                 AS LOGICAL   INITIAL ? /*tt-param-aval.reavalia-forc*/
    FIELD tipoAvaliacao                AS INTEGER   INITIAL ? /*tt-param-aval.param-aval*/
    FIELD situacaoPedido               AS INTEGER   INITIAL ? /*ped-venda.cod-sit-aval*/
    FIELD motivoLiberCred              AS CHARACTER INITIAL ? /*ped-venda.desc-forc*/
    FIELD especiePedido                AS INTEGER   INITIAL ? /*ped-venda.esp-ped*/
    FIELD vlTotPedido                  AS DECIMAL   INITIAL ? /*tt-param-aval.vl-a-avaliar*/
    FIELD progEms                      AS CHARACTER INITIAL ? /*tt-param-aval.programa*/
    FIELD pedidoMP                     AS LOGICAL   INITIAL ? /*ped-venda.replica-pd*/
    FIELD limiteCred                   AS DECIMAL   INITIAL ? /*de-lim-cred*/
    FIELD limiteCredAd                 AS DECIMAL   INITIAL ? /*de-lim-cred-ad*/
    FIELD dtLimiteCred                 AS DATE      INITIAL ? /*b-emitente.dt-lim-cre*/
    FIELD dtLimiteCredAd               AS DATE      INITIAL ? /*b-emitente.dt-fim-cred*/
    FIELD logInativo                   AS LOGICAL   INITIAL ? /*l-inativo*/
    FIELD logInativoMP                 AS LOGICAL   INITIAL ? /*l-inativo-mp*/
    FIELD dtUltAtraso                  AS DATE      INITIAL ? /*d-cr-ult-atraso*/
    FIELD dtUltAtrasoMP                AS DATE      INITIAL ? /*mp-dt-ult-atr*/
    FIELD valorMaxAtrasoAvisoCli       AS DECIMAL   INITIAL ? /*de-tot-ad*/
    FIELD valorMaxAtrasoAviso          AS DECIMAL   INITIAL ? /*de-lim-admatr*/
    FIELD valorMaxAtrasoAvisoDup       AS DECIMAL   INITIAL ? /*de-tot-tit*/
    FIELD valorMaxBloqCredCli          AS DECIMAL   INITIAL ? /*de-lim-maxatr*/
    FIELD logChequeDevol               AS LOGICAL   INITIAL ? /*l-cheque-devol*/
    FIELD valorContasPagar             AS DECIMAL   INITIAL ? /*de-saldo-ap*/
    FIELD valorContasPagarMP           AS DECIMAL   INITIAL ? /*mp-vl-ap-abe*/
    FIELD valorContasReceber           AS DECIMAL   INITIAL ? /*de-saldo-cr*/
    FIELD valorContasReceberMP         AS DECIMAL   INITIAL ? /*mp-vl-cr-abe*/
    FIELD valorDuplicatas              AS DECIMAL   INITIAL ? /*de-vl-nota*/
    FIELD valorTotalVlAp               AS DECIMAL   INITIAL ? /*de-totvlap*/
    FIELD credito                      AS LOGICAL   INITIAL ? /*l-cm-log-consid-cr-cr*/
    FIELD valorPedReprCred             AS DECIMAL   INITIAL ? /*de-totvlre*/          
    FIELD indiceMoeda                  AS DECIMAL   INITIAL ? /*Indice de convers∆o moeda*/
    FIELD fatEntregaFut                AS LOGICAL   INITIAL ? /*natur-oper.ind-entfut*/
    FIELD itensForaHoriz               AS LOGICAL   INITIAL ? /*Itens fora do horizonte*/
    FIELD logUltAtraso                 AS LOGICAL   INITIAL ? /*Cliente atrasou pagamento nos ultimos meses*/
    FIELD logUltAtrasoMP               AS LOGICAL   INITIAL ? /*Cliente atrasou pagamento nos ultimos mesmes (MP)*/
    .

DEFINE TEMP-TABLE ttCreditEvaluationRet NO-UNDO
    FIELD LPT__iRetorno     AS CHARACTER
    FIELD LPT__sAcao        AS CHARACTER
    FIELD LPT__sMsgErro     AS CHARACTER
    FIELD LPT__sMsgErroCred AS CHARACTER
    .
