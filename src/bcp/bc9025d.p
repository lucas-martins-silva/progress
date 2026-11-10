/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025D 2.00.00.023 } /*** "010023" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025d MBC}
&ENDIF

/**********************************************************************************
**  Programa...: bc9025d.p   
**  
**  Finalidade.: Adapter da transacao de Transferˆncia
**
**  Criado em..: fevereiro/2003
**
**********************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados        */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter          */
{bcp/bc9025n.i}
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE vsequencia                      AS INTEGER                            NO-UNDO.
DEFINE VARIABLE i-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE i-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE h-bosc032                       AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bosc096                       AS HANDLE                             NO-UNDO.             
DEFINE VARIABLE h-bosc112                       AS HANDLE                             NO-UNDO. 
DEFINE VARIABLE r-box-movto                     AS ROWID                              NO-UNDO.

DEF BUFFER b-wm-etiqueta FOR wm-etiqueta.
DEF BUFFER b-tt-etiqueta FOR tt-etiqueta.

DEFINE TEMP-TABLE ttMovto-Etiqueta LIKE wm-movto-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-wm-box-movto NO-UNDO LIKE wm-box-movto
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.
DO:
   RUN pi-inicializaDBO IN THIS-PROCEDURE.
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
   
   IF NOT AVAIL ttIntegracao THEN DO:
      RUN pi-destroyDBO IN THIS-PROCEDURE.
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 25346,
                        INPUT "bc9003d":U).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 25346
             tt-erro.mensagem = TRIM(RETURN-VALUE) + "(DC)":U.
      RETURN 'NOK':U.
   END.
   
   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF AVAIL tt-erro THEN DO:
      RUN pi-destroyDBO IN THIS-PROCEDURE.
      RETURN "NOK":U.
   END.
   
   bc9025:
   DO ON ERROR  UNDO bc9025, LEAVE bc9025
      ON QUIT   UNDO bc9025, LEAVE bc9025
      ON STOP   UNDO bc9025, LEAVE bc9025
      ON ENDKEY UNDO bc9025, LEAVE bc9025:
   
      FIND FIRST bc-trans
           WHERE bc-trans.nr-trans = pNumTrans NO-LOCK NO-ERROR.
   
      IF INDEX(bc-trans.detalhe,"NewTra-") > 0 THEN DO: /* Transferência automática */
         FOR EACH bc-trans-filho
            WHERE bc-trans-filho.nr-trans = pNumTrans NO-LOCK:
         
            CREATE ttSerial.
            ASSIGN ttSerial.ind-tipo-movto = INTEGER(  TRIM(ENTRY(2, ENTRY(01, bc-trans-filho.conteudo-trans,';'),':':U)))
                   ttSerial.id-box         = INTEGER(  TRIM(ENTRY(2, ENTRY(02, bc-trans-filho.conteudo-trans,';'),':':U)))
                   ttSerial.id-movto       = INTEGER(  TRIM(ENTRY(2, ENTRY(03, bc-trans-filho.conteudo-trans,';'),':':U)))
                   ttSerial.cod-item       = TRIM(ENTRY(2, ENTRY(04, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.cod-estabel    = TRIM(ENTRY(2, ENTRY(05, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.cod-local      = TRIM(ENTRY(2, ENTRY(06, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.cod-eqpto      = TRIM(ENTRY(2, ENTRY(07, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.cod-coletor    = TRIM(ENTRY(2, ENTRY(08, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.qtd-item       = DECIMAL(  TRIM(ENTRY(2, ENTRY(09, bc-trans-filho.conteudo-trans,';'),':':U)))
                   ttSerial.data           = DATE(  TRIM(ENTRY(2, ENTRY(10, bc-trans-filho.conteudo-trans,';'),':':U)))
                   ttSerial.hora           = TRIM(ENTRY(2, ENTRY(11, bc-trans-filho.conteudo-trans,';'),':':U))
                   ttSerial.num-serial     = DECIMAL(  TRIM(ENTRY(2, ENTRY(12, bc-trans-filho.conteudo-trans,';'),':':U))).
            
            IF ttSerial.num-serial <> 0 THEN DO:
               CREATE tt-etiqueta.
               ASSIGN tt-etiqueta.id-etiqueta   = ttSerial.num-serial
                      tt-etiqueta.qtd-item      = ttSerial.qtd-item.
            END.
         END.
         RUN goToKey2 IN h-bosc032 ( INPUT ttSerial.cod-estabel,
                                     INPUT ttSerial.cod-local,
                                     INPUT ttSerial.id-movto,
                                     INPUT ttSerial.ind-tipo-movto).
         
         RUN getRowid IN h-bosc032 (OUTPUT r-box-movto).
         /* buscar etiquetas dos agrupadores */
         IF ttSerial.ind-tipo-movto = 2 THEN DO:
            RUN getEtiquetasMovtoManual IN h-bosc032 (INPUT r-box-movto,
                                                      INPUT-OUTPUT TABLE tt-etiqueta).
         END.
         ELSE DO:
            FIND FIRST wm-equipamento
                 WHERE wm-equipamento.cod-equipamento = ttSerial.cod-eqpto NO-LOCK NO-ERROR.
            
            EMPTY TEMP-TABLE ttWm-box-movto-idx.
            
            RUN getMovtoTransfIniciado IN h-bosc096(INPUT ttSerial.cod-estabel,
                                                    INPUT ttSerial.cod-local,
                                                    INPUT 3, /*Transferencia*/
                                                    INPUT wm-equipamento.cdn-tipo-equipamento,
                                                    INPUT ttSerial.num-serial,
                                                    OUTPUT TABLE ttWm-box-movto-idx).
            
            FIND FIRST ttWm-box-movto-idx NO-LOCK NO-ERROR.
            IF AVAIL ttWm-box-movto-idx THEN DO:
               IF ttWm-box-movto-idx.char-1 <> "" THEN /*status e id-movto origem para Destinado e Cq-Armazenado*/
                  ASSIGN i-ind-status-saldo-origem = INTEGER(SUBSTRING(ttWm-box-movto-idx.char-1,1,2))
                         i-id-movto-box-saldo      = DECIMAL(SUBSTRING(ttWm-box-movto-idx.char-1,3,10)).
               
               EMPTY TEMP-TABLE RowErrors.
               EMPTY TEMP-TABLE tt-etiqueta.
               EMPTY TEMP-TABLE ttMovto-Etiqueta. 
               
               CREATE tt-etiqueta.
               ASSIGN tt-etiqueta.id-etiqueta = ttSerial.num-serial
                      tt-etiqueta.qtd-item    = ttWm-box-movto-idx.qtd-item * ttWm-box-movto-idx.qti-embalagem.
               
               RUN getMovtoEtiqueta IN h-bosc112(INPUT ttSerial.cod-estabel, 
                                                 INPUT ttSerial.cod-local,   
                                                 INPUT ttWm-box-movto-idx.id-movto,
                                                 OUTPUT TABLE ttMovto-Etiqueta).
               
               IF RETURN-VALUE = 'OK':U THEN DO:
                  FOR EACH ttMovto-Etiqueta NO-LOCK
                     WHERE ttMovto-Etiqueta.id-etiqueta <> ttSerial.num-serial:
                     CREATE tt-etiqueta.
                     ASSIGN tt-etiqueta.id-etiqueta = ttMovto-Etiqueta.id-etiqueta
                            tt-etiqueta.qtd-item    = ttMovto-Etiqueta.qtd-item.
                  END.
               END.
            END.
         END.
         
         RUN wmp/wm9091.p (INPUT r-box-movto,
                           INPUT (IF ttSerial.ind-tipo-movto = 1 THEN ttSerial.id-box ELSE 0), /* box destino */
                           INPUT bc-trans.usuario,
                           INPUT ttSerial.cod-eqpto,                                           /* equipto */
                           INPUT ttSerial.cod-coletor,                                         /* coletor */
                           INPUT TIME,                                                         /* hora inicio */
                           INPUT NO,
                           INPUT 0,
                           INPUT i-ind-status-saldo-origem,
                           OUTPUT o-ind-status-saldo-origem,
                           INPUT i-id-movto-box-saldo, 
                           OUTPUT o-id-movto-box-saldo,
                           INPUT TABLE tt-etiqueta,
                           OUTPUT TABLE RowErrors).
         
         IF ttSerial.ind-tipo-movto = 2 THEN DO: /* sa¡da */
            IF o-ind-status-saldo-origem = 4           /*destinado*/    
               OR o-ind-status-saldo-origem = 7  THEN DO: /*cq-armazenado*/
         
               EMPTY TEMP-TABLE tt-wm-box-movto NO-ERROR.
               RUN goToKey2 IN h-bosc032 ( INPUT ttSerial.cod-estabel,
                                           INPUT ttSerial.cod-local,
                                           INPUT ttSerial.id-movto,
                                           INPUT 1).   /*entrada*/
               
               RUN getRecord IN h-bosc032 (OUTPUT TABLE tt-wm-box-movto).
               
               FIND FIRST tt-wm-box-movto NO-LOCK NO-ERROR.
               
               ASSIGN OVERLAY(tt-wm-box-movto.char-1,1,2)  = STRING(o-ind-status-saldo-origem, ">>")     
                      OVERLAY(tt-wm-box-movto.char-1,3,10) = STRING(o-id-movto-box-saldo, ">>>>>>>>>>").
               
               RUN setRecord IN h-bosc032 (INPUT TABLE tt-wm-box-movto).
               RUN updateRecord IN h-bosc032.
            END.
         END.
         
         IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
            RUN pi-destroyDBO IN THIS-PROCEDURE.
            ASSIGN vsequencia = 1.
            FOR EACH RowErrors:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                       tt-erro.mensagem = RowErrors.ErrorDescription.
            END.
            RETURN "NOK":U.
         END.
      END.
      ELSE DO:
         RUN pi-destroyDBO IN THIS-PROCEDURE.
         RETURN "OK":U.
      END.
   END.
   
   IF ERROR-STATUS:ERROR = YES AND ERROR-STATUS:GET-NUMBER(1) <> 565 THEN DO:
      RUN pi-destroyDBO IN THIS-PROCEDURE.
      ASSIGN vsequencia = 1.
      FIND LAST tt-erro NO-LOCK NO-ERROR.
      IF AVAILABLE tt-erro THEN
         ASSIGN vsequencia = tt-erro.i-sequen + 1.
      
      CREATE tt-erro.
      {utp/ut-liter.i "Problemas_no_processo_PRE-API" *}
      ASSIGN tt-erro.i-sequen = vsequencia
             tt-erro.cd-erro  = 999
             tt-erro.mensagem = RETURN-VALUE + " " + ERROR-STATUS:GET-MESSAGE(1) + "(DC)":U.
      RETURN "NOK":U.
   END.
   RUN pi-destroyDBO IN THIS-PROCEDURE.   
   RETURN RETURN-VALUE.
END.

PROCEDURE pi-inicializaDBO:
   IF NOT VALID-HANDLE(h-bosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET h-bosc032.
      RUN openQueryStatic IN h-bosc032 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(h-bosc096)  THEN DO:   
      RUN scbo/bosc096.p PERSISTENT SET h-bosc096.
      RUN openQueryStatic IN h-bosc096 (INPUT "Main":U) NO-ERROR. 
   END.      
   
   IF NOT VALID-HANDLE(h-bosc112)  THEN DO:
      RUN scbo/bosc112.p PERSISTENT SET h-bosc112.
      RUN openQueryStatic IN h-bosc112 (INPUT "Main":U) NO-ERROR. 
   END.        
END PROCEDURE.

PROCEDURE pi-destroyDBO:
   IF VALID-HANDLE(h-bosc032) THEN   
      DELETE OBJECT h-bosc032 NO-ERROR. 
 
   IF VALID-HANDLE(h-bosc096) THEN   
      DELETE OBJECT h-bosc096 NO-ERROR. 
   
   IF VALID-HANDLE(h-bosc112) THEN
      DELETE OBJECT h-bosc112 NO-ERROR. 
END PROCEDURE.
