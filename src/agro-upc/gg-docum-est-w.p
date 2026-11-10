/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-DOCUM-EST-W 2.00.00.020 } /*** "010020" 29/05/2025 09:23:32  ***/

/***********************************************************************
**  Programa...: agro-upc/gg-docum-est-w.p
**  Descricao..: Upc utilizada na atualizar a tabela gg-mov-contr
**  data.......: Agosto/2003
************************************************************************/

DEFINE PARAM BUFFER b-docum-est     FOR docum-est.
DEFINE PARAM BUFFER b-old-docum-est FOR docum-est.

{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{ggp/tt-erro.i}

DEF BUFFER b-gg-mov-contr FOR gg-mov-contr.
DEF BUFFER b-gg-pendencia FOR gg-pendencia.
DEF VAR l-erro AS LOGICAL.

def temp-table tt-erro-retorno no-undo       
    field i-sequen  as int                   
    field cd-erro   as int                   
    field desc-erro as char format "x(255)". 

DEF VAR de-desconto AS DEC. 
DEF VAR p-erro      AS LOG.

/* Alteraá∆o do nro do Documento*/
IF (b-old-docum-est.nro-docto <> b-docum-est.nro-docto AND b-old-docum-est.nro-docto <> "")
 OR (b-old-docum-est.dt-trans <> b-docum-est.dt-trans  AND b-old-docum-est.dt-trans  <> ? AND b-old-docum-est.nro-docto <> "") THEN DO: 
   /******************************************************************************/
   FOR EACH item-doc-est OF b-docum-est NO-LOCK:
       For FIRST gg-mov-contr EXCLUSIVE-LOCK
           WHERE gg-mov-contr.cod-estabel  = b-docum-est.cod-estabel
           AND   gg-mov-contr.num-romaneio = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN item-doc-est.num-romaneio-rel
                                             &ELSE int(SUBSTRING(item-doc-est.char-2,525,9)) &ENDIF
           AND   gg-mov-contr.num-seq      = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN item-doc-est.num-seq-roman
                                             &ELSE int(SUBSTRING(item-doc-est.char-2,534,6)) &ENDIF:
           
           ASSIGN gg-mov-contr.nro-docto         = b-docum-est.nro-docto
                  gg-mov-contr.dt-trans          = b-docum-est.dt-trans.

           FOR FIRST gg-mov NO-LOCK 
               WHERE gg-mov.cod-estabel  = gg-mov-contr.cod-estabel 
               AND gg-mov.num-romaneio = gg-mov-contr.num-romaneio:
               /**** cria historico do movimento ****/

               {utp/ut-liter.i "Alteraá∆o do N£mero do Documento de Entrada na Efetivaá∆o do Documento para o Contrato: " * R}

               RUN ggp/ggapi001.p(INPUT rowid(gg-mov),
                                  INPUT RETURN-VALUE + gg-mov-contr.cod-contrato + " de " + b-old-docum-est.nro-docto + " para " + b-docum-est.nro-docto, 
                                  INPUT YES).
           END.
       END.
       IF AVAIL gg-mov-contr THEN
           FIND CURRENT gg-mov-contr NO-LOCK NO-ERROR.
   END.

   FOR EACH gg-classifica EXCLUSIVE-LOCK 
      WHERE gg-classifica.des-tipo-docto = "docum-est"
        AND gg-classifica.cod-estabel    = b-old-docum-est.cod-estabel 
        AND gg-classifica.num-docto      = b-old-docum-est.nro-docto
        AND gg-classifica.serie          = b-old-docum-est.serie-docto
        AND gg-classifica.nat-operacao   = b-old-docum-est.nat-operacao
        AND gg-classifica.cod-emitente   = b-old-docum-est.cod-emitente:

       ASSIGN gg-classifica.num-docto = b-docum-est.nro-docto.

   END.

   IF b-docum-est.nro-docto <> b-old-docum-est.nro-docto
   AND NOT CAN-FIND (FIRST gg-ext-docum-glob 
                     WHERE gg-ext-docum-glob.serie-docto-glob  = b-old-docum-est.serie-docto
                       AND gg-ext-docum-glob.nro-docto-glob    = b-docum-est.nro-docto
                       AND gg-ext-docum-glob.cod-emitente-glob = b-old-docum-est.cod-emitente
                       AND gg-ext-docum-glob.nat-operacao-glob = b-old-docum-est.nat-operacao) THEN DO:
       FOR EACH gg-ext-docum-glob EXCLUSIVE-LOCK 
          WHERE gg-ext-docum-glob.serie-docto-glob  = b-old-docum-est.serie-docto
            AND gg-ext-docum-glob.nro-docto-glob    = b-old-docum-est.nro-docto
            AND gg-ext-docum-glob.cod-emitente-glob = b-old-docum-est.cod-emitente
            AND gg-ext-docum-glob.nat-operacao-glob = b-old-docum-est.nat-operacao:
          ASSIGN gg-ext-docum-glob.nro-docto-glob   = b-docum-est.nro-docto.
       END.
   END.

   FOR EACH gg-pendencia EXCLUSIVE-LOCK
      WHERE gg-pendencia.serie-docto-rec  = b-old-docum-est.serie-docto 
        AND gg-pendencia.nr-docto-rec     = b-old-docum-est.nro-docto   
        AND gg-pendencia.cod-emitente-rec = b-old-docum-est.cod-emitente
        AND gg-pendencia.nat-operacao-rec = b-old-docum-est.nat-operacao:

       ASSIGN gg-pendencia.nr-docto-rec = b-docum-est.nro-docto.
   END.
END.

IF NOT AVAIL gg-ext-docum-est THEN
   For FIRST gg-ext-docum-est EXCLUSIVE-LOCK 
        WHERE gg-ext-docum-est.serie-docto  = b-docum-est.serie-docto
          AND gg-ext-docum-est.nro-docto    = b-docum-est.nro-docto
          AND gg-ext-docum-est.cod-emitente = b-docum-est.cod-emitente
          AND gg-ext-docum-est.nat-operacao = b-docum-est.nat-operacao 
          AND gg-ext-docum-est.cod-estabel  = b-docum-est.cod-estabel:
    
END.

IF NOT AVAIL gg-ext-docum-est THEN DO:
   CREATE gg-ext-docum-est.
   ASSIGN gg-ext-docum-est.serie-docto  = b-docum-est.serie-docto
          gg-ext-docum-est.nro-docto    = b-docum-est.nro-docto
          gg-ext-docum-est.cod-emitente = b-docum-est.cod-emitente
          gg-ext-docum-est.nat-operacao = b-docum-est.nat-operacao
          gg-ext-docum-est.cod-estabel  = b-docum-est.cod-estabel.
       
   FOR FIRST estabelec NO-LOCK 
       WHERE estabelec.cod-estabel = b-docum-est.cod-estabel: 
       
       ASSIGN gg-ext-docum-est.cod-estabel = b-docum-est.cod-estabel 
              gg-ext-docum-est.ep-codigo   = estabelec.ep-codigo.
   END.
END.
RELEASE gg-ext-docum-est. 

/*    ISSUE - MAGRO-419 (208514)
    Parte do BLOCO transferido para GGRE0402A, devido a determinada situaá∆o n∆o estar 
    rodando trigger de write da docum-est e consequentemente a APPC
    Explo: Cancelar pelo GG2000 Romaneio de Entrada/Devoluá∆o
*/

IF b-old-docum-est.ce-atual = no AND b-docum-est.ce-atual = yes THEN DO: 
    /*** verificar se se trata de uma atualizacao de nota de devolucao de vendas MI ***/
    IF b-docum-est.esp-docto = 20 THEN DO: /* nfd */
       RUN ggp/ggapi096.p (INPUT "docum-est",
                           INPUT ROWID(b-docum-est),
                           INPUT 6, /* atualzia nota fiscal de devolucao de vendas MI */
                           INPUT YES, 
                           OUTPUT TABLE tt-erro).
    END.
    ELSE DO:
        FOR EACH b-gg-pendencia NO-LOCK
           WHERE b-gg-pendencia.serie-docto-rec  = b-docum-est.serie-docto
             AND b-gg-pendencia.nr-docto-rec     = b-docum-est.nro-docto   
             AND b-gg-pendencia.cod-emitente-rec = b-docum-est.cod-emitente
             AND b-gg-pendencia.nat-operacao-rec = b-docum-est.nat-operacao:

            /*** verificar os impactos, caso for nota de complemento de um processo de fixaá∆o, seja gg1020 ou gg8000 */
            RUN ggp/ggapi817.p (INPUT ROWID(b-gg-pendencia),
                                INPUT 1, /*atualizar*/
                                INPUT "",
                                OUTPUT TABLE tt-erro).
       END.
    END.
END.


IF AVAIL gg-ext-docum-est THEN
   FIND CURRENT gg-ext-docum-est NO-LOCK NO-ERROR.
ASSIGN ERROR-STATUS:ERROR = NO.  

RETURN "OK":U.

/* fim appc */

