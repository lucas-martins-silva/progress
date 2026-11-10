/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE0402RP 2.00.00.016 } /*** "010016" 29/05/2025 09:23:33 ***/

{utp/ut-glob.i}
{ggp/tt-erro.i}
{include/i-epc200.i1} /* definicao da temp-table tt-epc */

def input        param p-ind-event as char no-undo.
def input-output param table       for tt-epc.

DEF VAR r-row-mov-contr-mov AS ROWID NO-UNDO.
DEF VAR cRomaneioErro       AS CHAR  NO-UNDO FORMAT "X(2000)".

DEFINE BUFFER b-gg-contrato-mov FOR gg-contrato-mov.
DEFINE BUFFER b-gg-mov          FOR gg-mov.
DEFINE BUFFER b-item-doc-est    FOR item-doc-est.

FIND FIRST tt-epc NO-LOCK
     WHERE tt-epc.cod-event     = "Antes-lista-erros"
       AND tt-epc.cod-parameter = "lista-erros" NO-ERROR.

IF  AVAIL tt-epc AND p-ind-event = "Antes-lista-erros" THEN DO:

    /* Se j† tiver erro no programa n∆o precisa fazer essa validaá∆o */
    IF  CAN-FIND(FIRST tt-epc
                 WHERE tt-epc.cod-event     = "Antes-lista-erros"
                   AND tt-epc.cod-parameter = "l-erro"
                   AND LOGICAL(tt-epc.val-parameter, "yes/no") ) THEN
        RETURN "OK":U.

    FIND FIRST docum-est NO-LOCK
         WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

    IF  AVAIL docum-est AND docum-est.log-entreg-fut THEN DO: /* Entrega Fatura Futura */
        ASSIGN cRomaneioErro = "".

        /* N∆o permitir desatualizar nota que esteja vinculada a algum romaneio */

        FOR FIRST item-doc-est FIELDS (nat-terc) NO-LOCK
               OF docum-est,
            EACH gg-mov-contr-dev NO-LOCK
            WHERE gg-mov-contr-dev.cod-estabel  = docum-est.cod-estabel
              AND gg-mov-contr-dev.serie        = docum-est.serie-docto
              AND gg-mov-contr-dev.nr-nota-fis  = docum-est.nro-docto
              AND gg-mov-contr-dev.nat-operacao   = item-doc-est.nat-terc:

            ASSIGN cRomaneioErro = cRomaneioErro + STRING(gg-mov-contr-dev.cod-estabel) + "/"
                                                 + STRING(gg-mov-contr-dev.num-romaneio) + CHR(10).
        END.

        IF  TRIM(cRomaneioErro) <> ""  THEN DO:
            /* A desatualizaá∆o da nota n∆o ser† permitida, pois est† vinculada ao romaneio  &1 */

            RUN utp/ut-msgs.p ( INPUT "help", INPUT 54254, INPUT cRomaneioErro ).
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "tt-erro"
                   tt-epc.cod-parameter = "17006"
                   tt-epc.val-parameter = "54254" + " - " + RETURN-VALUE.

        END.
    END.
END.


FIND FIRST tt-epc NO-LOCK 
     WHERE tt-epc.cod-event     = "Apos-lista-erros":U
       AND tt-epc.cod-parameter = "lista-erros":U      NO-ERROR. 
IF  AVAIL tt-epc THEN DO: 
    FIND FIRST docum-est NO-LOCK
         WHERE ROWID(docum-est) = to-rowid(tt-epc.val-parameter) NO-ERROR.
    IF AVAIL docum-est 
    AND docum-est.log-1 = NO THEN DO: 
        
       FOR EACH item-doc-est OF docum-est NO-LOCK
           BREAK BY item-doc-est.sequencia : 
           
           IF FIRST-OF(item-doc-est.sequencia)
           THEN DO:
           
               IF CAN-FIND(FIRST gg-mov-contr-mov NO-LOCK
                           WHERE gg-mov-contr-mov.cod-estabel  = docum-est.cod-estabel
                             AND gg-mov-contr-mov.num-romaneio = INT(SUBSTRING(item-doc-est.char-2,525,9))
                             AND gg-mov-contr-mov.num-seq      = INT(SUBSTRING(item-doc-est.char-2,534,6))
                             AND gg-mov-contr-mov.ind-movimento = 10 /* cancelar pelo gg2000 */
                             AND gg-mov-contr-mov.log-1        = NO) THEN DO:
    
                  FIND FIRST gg-mov-contr-mov NO-LOCK
                       WHERE gg-mov-contr-mov.cod-estabel  = docum-est.cod-estabel
                         AND gg-mov-contr-mov.num-romaneio = INT(SUBSTRING(item-doc-est.char-2,525,9))
                         AND gg-mov-contr-mov.num-seq      = INT(SUBSTRING(item-doc-est.char-2,534,6))
                         AND gg-mov-contr-mov.ind-movimento = 10 /* cancelar pelo gg2000 */
                         AND gg-mov-contr-mov.log-1        = NO NO-ERROR.
                  IF AVAIL gg-mov-contr-mov THEN 
                     ASSIGN r-row-mov-contr-mov = ROWID(gg-mov-contr-mov). 
    
                  /* eliminar o documento */
                  RUN ggp/ggapi108.p (INPUT to-rowid(tt-epc.val-parameter)).
    
                  FIND FIRST docum-est NO-LOCK
                       WHERE ROWID(docum-est) = to-rowid(tt-epc.val-parameter) NO-ERROR.
                  IF NOT AVAIL docum-est THEN DO: 
    
                     /* eliminou o documento */
                     FIND FIRST gg-mov-contr-mov EXCLUSIVE-LOCK
                          WHERE rowid(gg-mov-contr-mov) = r-row-mov-contr-mov NO-ERROR. 
                     IF AVAIL gg-mov-contr-mov THEN DO: 
    
                        ASSIGN gg-mov-contr-mov.log-1 = YES.
    
                     END.
                     RELEASE gg-mov-contr-mov.
                  END.
               END.
           END.

           IF  AVAIL item-doc-est THEN DO:
               IF  TRIM(SUBSTR(item-doc-est.char-2, 540,20)) <> "" /* Contrato */ AND docum-est.ce-atual = NO /*documento desatualizou*/ THEN DO:
                   FOR EACH  gg-contrato-mov EXCLUSIVE-LOCK
                       WHERE gg-contrato-mov.ep-codigo     = i-ep-codigo-usuario
                         AND gg-contrato-mov.cod-contrato  = TRIM(SUBSTR(item-doc-est.char-2, 540,20)):

                       IF (gg-contrato-mov.ind-transacao = 4   /* Pagamento */
                       OR  gg-contrato-mov.ind-transacao = 21) /* Entrega Fatura Futura */

                       AND gg-contrato-mov.cod-estabel  = docum-est.cod-estabel
                       AND gg-contrato-mov.cod-emitente = docum-est.cod-emitente
                       AND gg-contrato-mov.nro-docto    = docum-est.nro-docto
                       AND gg-contrato-mov.serie-docto  = docum-est.serie-docto
                       AND gg-contrato-mov.nat-operacao = docum-est.nat-operacao THEN DO:
                           IF (gg-contrato-mov.ind-transacao = 4) THEN DO:
                               FOR FIRST gg-contrato EXCLUSIVE-LOCK
                                   WHERE gg-contrato.ep-codigo    = i-ep-codigo-usuario                      
                                     AND gg-contrato.cod-contrato = TRIM(SUBSTR(item-doc-est.char-2, 540,20)):
                                   ASSIGN gg-contrato.qtd-pago = gg-contrato.qtd-pago - item-doc-est.qt-do-forn.
                               END.

                               RELEASE gg-contrato.
                           END.
                           DELETE gg-contrato-mov.
                           FOR FIRST b-gg-contrato-mov EXCLUSIVE-LOCK
                                WHERE b-gg-contrato-mov.serie-docto   = item-doc-est.serie-docto  
                                  AND b-gg-contrato-mov.nro-docto     = item-doc-est.nro-docto    
                                  AND b-gg-contrato-mov.cod-emitente  = item-doc-est.cod-emitente 
                                  AND b-gg-contrato-mov.nat-operacao  = item-doc-est.nat-operacao 
                                  AND b-gg-contrato-mov.int-1         = item-doc-est.sequencia
                                  AND b-gg-contrato-mov.ind-transacao = 1:
                               ASSIGN b-gg-contrato-mov.qtd-pago = b-gg-contrato-mov.qtd-pago - item-doc-est.qt-do-forn.
                           END.
                           RELEASE b-gg-contrato-mov.
                       END.
                   END.
               END.

               IF LAST(item-doc-est.sequencia) THEN DO:

                   FIND FIRST gg-mov no-LOCK 
                        WHERE gg-mov.cod-estabel    = docum-est.cod-estabel
                          AND gg-mov.num-romaneio   = int(substr(item-doc-est.char-2,525,9)) 
                          AND gg-mov.idi-orig-roman = 6 /* importaá∆o */ NO-ERROR.
                   IF  AVAIL gg-mov THEN DO:
                       RUN pi-estorno.
                   END.
               END.
           END.
           
       END.
    END.
END.

PROCEDURE pi-estorno:

 DEFINE VARIABLE c-historico AS CHARACTER NO-UNDO.
 DEFINE VARIABLE c-lbl-serie AS CHARACTER NO-UNDO.
 DEFINE VARIABLE c-lbl-nro   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE c-lbl-emit  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE c-lbl-nat   AS CHARACTER NO-UNDO.
 
 EMPTY TEMP-TABLE tt-erro.

    b-estorno:
    DO TRANS
    ON STOP    UNDO b-estorno, LEAVE b-estorno
    ON END-KEY UNDO b-estorno, LEAVE b-estorno
    ON ERROR   UNDO b-estorno, LEAVE b-estorno:
       
        FIND FIRST b-gg-mov EXCLUSIVE-LOCK WHERE
             rowid(b-gg-mov) = rowid(gg-mov) NO-ERROR.
        IF AVAIL b-gg-mov THEN DO:
           ASSIGN b-gg-mov.ind-situacao = 2. /* 2a Pesagem */
        END.

        FOR EACH gg-mov-contr OF gg-mov EXCLUSIVE-LOCK :

            ASSIGN gg-mov-contr.ind-situacao = 2. /* 2a Pesagem */
             
            /***** Api para estornar os movimentos do romaneio , a situaá∆o precisa estar em 2a pesagem **/
            RUN ggp/ggapi005b.p (INPUT ROWID(b-gg-mov),
                                 INPUT ROWID(gg-mov-contr),
                                 INPUT YES,
                                 INPUT-OUTPUT TABLE tt-erro).

            IF CAN-FIND(tt-erro) THEN LEAVE.
        END. /*FOR EACH*/

        IF NOT CAN-FIND(FIRST tt-erro) THEN do:
             
                FIND FIRST b-gg-mov EXCLUSIVE-LOCK WHERE
                     rowid(b-gg-mov) = rowid(gg-mov) NO-ERROR.
                IF AVAIL b-gg-mov THEN DO:
                       ASSIGN b-gg-mov.ind-situacao = 9. /* Cancelado */
                END.

               {utp/ut-liter.i "SÇrie" *}               
               ASSIGN c-lbl-serie = TRIM(RETURN-VALUE).
               {utp/ut-liter.i "Nro" *}                
               ASSIGN c-lbl-nro = TRIM(RETURN-VALUE).  
               {utp/ut-liter.i "Emit" *}               
               ASSIGN c-lbl-emit = TRIM(RETURN-VALUE). 
               {utp/ut-liter.i "Natureza" *}               
               ASSIGN c-lbl-nat = TRIM(RETURN-VALUE).
               
               ASSIGN c-historico = "Cancelado a partir da nota fiscal de Importaá∆o desatualizada : "  +
                                    c-lbl-serie    + " " + docum-est.serie-docto                        +                              
                                    c-lbl-nro      + " " + docum-est.nro-docto                          +                              
                                    c-lbl-emit     + " " + STRING(docum-est.cod-emitente)               + 
                                    c-lbl-nat      + " " + STRING(docum-est.nat-operacao).   

                /**** Cria Historico do Movimento ****/
                       RUN ggp/ggapi001.p(INPUT ROWID(gg-mov),
                       INPUT c-historico ,
                       INPUT YES).

              /* ao cancelar o romaneio desvincular o romaneio do item */
              
              FOR EACH b-item-doc-est OF docum-est EXCLUSIVE-LOCK:

                  IF int(substr(b-item-doc-est.char-2,525,9)) = b-gg-mov.num-romaneio THEN DO:

                      ASSIGN OVERLAY(b-item-doc-est.char-2,525,9) = "".
                  END.
                       
              END.

              RELEASE b-gg-mov.
                
        END. 
          
    END.


RETURN "OK":U.

END PROCEDURE.

RETURN "OK":U.
