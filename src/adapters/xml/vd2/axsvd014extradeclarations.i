DEFINE TEMP-TABLE ttCustomerEvaluationEnv NO-UNDO
    FIELD cgc           AS CHARACTER INITIAL ? /*CGC*/                              
    FIELD cgcCob        AS CHARACTER INITIAL ? /*CGC Cobranáa*/                  
    FIELD codigo        AS INTEGER   INITIAL ? /*C¢digo do cliente*/               
    FIELD dtImplantacao AS DATE      INITIAL ? /*Data de Implantaá∆o*/                                                                                                                                               
    FIELD grupoCli      AS INTEGER   INITIAL ? /*Grupo do Cliente*/                                                                            
    FIELD IE            AS CHARACTER INITIAL ? /*Inscriá∆o Estadual*/                                                                              
    FIELD IECob         AS CHARACTER INITIAL ? /*Inscsriá∆o Estadual Cobranáa*/                                                                 
    FIELD IM            AS CHARACTER INITIAL ? /*Inscriá∆o Municipal*/                                                                             
    FIELD INSS          AS CHARACTER INITIAL ? /*Inscriá∆o INSS~\CEI*/                                                                            
    FIELD matriz        AS CHARACTER INITIAL ? /*Matriz*/                                                                                      
    FIELD nomeAbrev     AS CHARACTER INITIAL ? /*Nome abreviado*/                                                                           
    FIELD ramoAtividade AS CHARACTER INITIAL ? /*Ramo da Atividade*/
    FIELD razaoSocial   AS CHARACTER INITIAL ? /*Raz∆o Social*/
    FIELD endereco      AS CHARACTER INITIAL ? /*Endereáo*/
    FIELD natureza      AS INTEGER   INITIAL ? /*Natureza*/
    .
                                                                                                                                                   
DEFINE TEMP-TABLE ttCustomerEvaluationRet NO-UNDO
    FIELD LPT__iRetorno         AS CHARACTER
    FIELD LPT__sAcao            AS CHARACTER
    FIELD LPT__sMsgErro         AS CHARACTER
    FIELD LPT__sMsgErroCred     AS CHARACTER
    FIELD limiteCredito         AS DECIMAL
    FIELD dataLimiteCredito     AS DATE
    FIELD limiteCreditoAdic     AS DECIMAL
    FIELD dataLimiteCreditoAdic AS DATE
    FIELD moedaLimiteCredito    AS CHARACTER
    .






