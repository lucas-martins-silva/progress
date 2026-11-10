/*------------------------------------------------------------------------------
  Purpose:     Retorna valor do c¢digo de servi‡o
  Parameters:  
               recebe n£mero da ordem
               retorna c¢digo de servi‡o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem AS INTEGER NO-UNDO.
    define input parameter pi-it-codigo    as char    no-undo.
    define input parameter pi-cod-emitente as integer no-undo.
    DEFINE OUTPUT PARAMETER pi-cod-servico AS INTEGER NO-UNDO.

    DEFINE VARIABLE h-bosc014   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE l-log-frete AS LOGICAL    NO-UNDO.
    
    &IF DEFINED(Bf_dis_tf_compras_receb) &THEN
        &IF '{&Bf_dis_tf_compras_receb}' = 'YES' AND '{&mguni_version}' < '2.07' &THEN

            ASSIGN pi-cod-servico = 0.
            FIND FIRST param-global NO-LOCK NO-ERROR.
            IF param-global.modulo-tf AND param-global.modulo-cc AND CONNECTED('mgscm') THEN
            DO:
                 if not valid-handle(h-bosc014) or
                     h-bosc014:type      <> "PROCEDURE":U or
                     h-bosc014:file-name <> "scbo/bosc014.p":U then
                     run scbo/bosc014.p persistent set h-bosc014.
        
                 RUN openQueryStatic IN h-bosc014(INPUT "default":U).
                 RUN goToKey IN h-bosc014(INPUT pc-cod-estabel).
                 IF RETURN-VALUE = 'OK' THEN
                 DO:
                     RUN getLogField IN h-bosc014(INPUT 'log-frete-vda',
                                                  OUTPUT l-log-frete).
                     IF l-log-frete THEN
                     DO:
                         FOR FIRST ordem-compra FIELDS(numero-ordem) NO-LOCK
                             WHERE ordem-compra.numero-ordem = pi-numero-ordem,
                             first cotacao-item  &if '{&bf_dis_versao_ems}' >= '2.05' 
                                                 &then fields(cod-servico) 
                                                 &else fields(int-2) 
                                                 &endif no-lock
                             where cotacao-item.numero-ordem = pi-numero-ordem and
                                   cotacao-item.cod-emitente = pi-cod-emitente and
                                   cotacao-item.it-codigo    = pi-it-codigo:
                             ASSIGN pi-cod-servico = &if '{&bf_dis_versao_ems}' >= '2.05' 
                                                     &then cotacao-item.cod-servico
                                                     &else cotacao-item.int-2
                                                     &endif .
                         END.
                     END.
                 END.
            END.
            
        &ENDIF
    &ENDIF 
