/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBOIN090 2.00.00.038 } /*** "010038" 29/05/2025 09:23:33 ***/

/**********************************************************************************/
/* UPC-BOIN090                                                                    */
/*          2.04.00.000 - valida natureza X serie                                 */
/**********************************************************************************/

{utp/ut-glob.i}
{include/i-epc200.i boin090} 
{inbo/boin090.i tt-docum-est}
{cdp/cdcfgmat.i}
{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

{ggp/ggapi808.i6}

DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.


DEF VAR hDBOin090        AS HANDLE  NO-UNDO.
DEF VAR l-tem            AS LOG.
DEF VAR de-saldo-disp    AS DECI    NO-UNDO.
DEF VAR hGgapi701        AS HANDLE  NO-UNDO.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-nota-fiscal-nao-pode-ser-elimi AS CHARACTER NO-UNDO.
{utp/ut-liter.i "Nota_Fiscal_nÆo_pode_ser_eliminada" *}
ASSIGN c-lbl-liter-nota-fiscal-nao-pode-ser-elimi = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-nota-relacionada-a-uma-pendenc AS CHARACTER NO-UNDO.
{utp/ut-liter.i "Nota_relacionada_a_uma_pendˆncia_de_origina‡Æo_e_que_gerou_uma_diferen‡a_j _solucionada_na_nota_fiscal" *}
ASSIGN c-lbl-liter-nota-relacionada-a-uma-pendenc = TRIM(RETURN-VALUE).


DEFINE BUFFER bf-gg-mov-contr FOR gg-mov-contr.
DEFINE BUFFER bf-gg-pendencia FOR gg-pendencia.

{include/boerrtab.i}
{method/dbotterr.i} /** Definicao temp-table rowErrors **/

IF p-ind-event = "beforeDeleteRecord" THEN DO:

    ASSIGN hDBOin090 = ?.
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
        AND   tt-epc.cod-parameter = "object-handle":U:
        /** Handle da boin090 **/
        ASSIGN hDBOin090 = WIDGET-HANDLE(tt-epc.val-parameter).
    END.

    IF VALID-HANDLE(hDBOin090) THEN DO:
        RUN getRecord IN hDBOin090 (OUTPUT TABLE tt-docum-est).

        FIND FIRST tt-docum-est NO-ERROR.
   
        FOR EACH item-doc-est NO-LOCK
            WHERE  item-doc-est.serie-docto       = tt-docum-est.serie-docto                 
              AND  item-doc-est.nro-docto         = tt-docum-est.nro-docto
              AND  item-doc-est.cod-emitente      = tt-docum-est.cod-emitente               
              AND  item-doc-est.nat-operacao      = tt-docum-est.nat-operacao :
            
          IF &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN item-doc-est.cod-contrato-comerc
             &ELSE TRIM(SUBSTR(item-doc-est.char-2, 540,20)) &ENDIF <> "" THEN DO:
             
             /*Cria Handle*/
             IF NOT VALID-HANDLE(hGgapi701) THEN
                RUN prgagro/ggp/ggp701za.py PERSISTENT SET hGgapi701.
   
             FOR EACH dupli-apagar NO-LOCK 
                WHERE dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                  AND dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                  AND dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                  AND dupli-apagar.nat-operacao = tt-docum-est.nat-operacao:

                 FOR FIRST gg-ext-tit-ap NO-LOCK
                     WHERE gg-ext-tit-ap.cod-estab       = dupli-apagar.cod-estabel
                       AND gg-ext-tit-ap.cod-emitente    = dupli-apagar.cod-emitente
                       AND gg-ext-tit-ap.cod-espec-docto = dupli-apagar.cod-esp
                       AND gg-ext-tit-ap.cod-ser-docto   = dupli-apagar.serie-docto
                       AND gg-ext-tit-ap.cod-tit-ap      = dupli-apagar.nr-duplic
                       AND gg-ext-tit-ap.cod-parcela     = dupli-apagar.parcela
                       AND gg-ext-tit-ap.cod-contrato    <> "":  /* somente se possuir contrato */

                     FOR FIRST gg-contrato-relacto-movto NO-LOCK
                         WHERE gg-contrato-relacto-movto.cod-estabel      = gg-ext-tit-ap.cod-estab
                           AND gg-contrato-relacto-movto.num-id-tit       = gg-ext-tit-ap.num-id-tit-ap
                           AND gg-contrato-relacto-movto.cod-modul-dtsul  = "APB":U:
                         
                         RUN pi_ggp_retornar_movto_tit_apb IN hGgapi701 (INPUT "",
                                                                         INPUT gg-contrato-relacto-movto.cod-estabel,
                                                                         INPUT 0,
                                                                         INPUT gg-contrato-relacto-movto.num-id-movto-tit,
                                                                         INPUT "",
                                                                         OUTPUT TABLE ttMovtoTitApb).

                         FIND FIRST ttMovtoTitApb NO-ERROR.

                         IF AVAIL ttMovtoTitApb AND (ttMovtoTitApb.log_movto_estordo = NO) THEN DO:
                            

                             RUN utp/ut-msgs.p (INPUT "MSG":U,
                                                INPUT 36321,
                                                INPUT "").
    
                             RUN _insertErrorManual IN hDBOin090 (INPUT 36321,
                                                                  INPUT "EMS":U,
                                                                  INPUT "ERROR":U,
                                                                  INPUT RETURN-VALUE,
                                                                  INPUT RETURN-VALUE,
                                                                  INPUT "":U).
                             CREATE tt-epc.
                             ASSIGN tt-epc.cod-event     = "ERROR":U
                                    tt-epc.cod-parameter = "EPC-ERROR":U 
                                    tt-epc.val-parameter = "Processo Abortado".
                             
                             /*destroy handle*/
                             IF VALID-HANDLE(hGgapi701) THEN
                                DELETE PROCEDURE hGgapi701.

                             RETURN "NOK".
                         END.
                     END.
                 END.
             END.
             
             /*destroy handle*/
             IF VALID-HANDLE(hGgapi701) THEN
                DELETE PROCEDURE hGgapi701.

          END.
    
          ASSIGN l-tem = NO.

          /*Volta a pendencia de complemento simbolico para pendente*/
          FOR EACH gg-pendencia EXCLUSIVE-LOCK
             WHERE gg-pendencia.serie-docto-rec  = tt-docum-est.serie-docto 
               AND gg-pendencia.nr-docto-rec     = tt-docum-est.nro-docto   
               AND gg-pendencia.cod-emitente-rec = tt-docum-est.cod-emitente
               AND gg-pendencia.nat-operacao-rec = tt-docum-est.nat-operacao :
              
              /* Verificar se h  pendencia relacionada e elimin -la caso nÆo esteja pendende */
              IF  gg-pendencia.num-livre-3 <> 0
              AND gg-pendencia.num-livre-3 <> gg-pendencia.num-seq THEN DO: 
                  FIND FIRST bf-gg-pendencia EXCLUSIVE-LOCK
                       WHERE bf-gg-pendencia.ep-codigo    = gg-pendencia.ep-codigo
                         AND bf-gg-pendencia.cod-contrato = gg-pendencia.cod-contrato
                         AND bf-gg-pendencia.num-seq-fix  = gg-pendencia.num-seq-fix
                         AND bf-gg-pendencia.num-seq      = gg-pendencia.num-livre-3 NO-ERROR.
                  IF  AVAIL bf-gg-pendencia THEN DO:
                      IF  bf-gg-pendencia.log-pendente = NO THEN DO:
                          RUN _insertErrorManual IN hDBOin090 (INPUT 0,
                                                               INPUT "EMS":U,
                                                               INPUT "ERROR":U,
                                                               INPUT c-lbl-liter-nota-fiscal-nao-pode-ser-elimi,
                                                               INPUT c-lbl-liter-nota-relacionada-a-uma-pendenc + " "
                                                                   + bf-gg-pendencia.serie-docto-rec  + "/":U
                                                                   + bf-gg-pendencia.nr-docto-rec     + "/":U
                                                                   + STRING(bf-gg-pendencia.cod-emitente-rec) + "/":U
                                                                   + bf-gg-pendencia.nat-operacao-rec,
                                                               INPUT "":U).

                          CREATE tt-epc.
                          ASSIGN tt-epc.cod-event     = "ERROR":U
                                 tt-epc.cod-parameter = "EPC-ERROR":U 
                                 tt-epc.val-parameter = "Processo Abortado".

                          RETURN "NOK":U.
                      END.
                      ELSE DO:
                          IF gg-pendencia.int-1           = 1 /* Processo de Fixa‡Æo*/ THEN DO:
                              /* aten‡Æo: complemento de quantidade ‚ ajustado no ggapi6004 */
                              FOR EACH  gg-fecha-contrat-compl EXCLUSIVE-LOCK
                                  WHERE gg-fecha-contrat-compl.num-id-fechto-contrat-compl = bf-gg-pendencia.num-id-fechto-contrat-compl:
                                  DELETE gg-fecha-contrat-compl.
                              END.
    
                              DELETE bf-gg-pendencia.
                          END.
                      END.
                  END.

                  ASSIGN gg-pendencia.num-livre-3 = 0.
              END.

              ASSIGN gg-pendencia.nr-docto-rec     = ""
                     gg-pendencia.log-pendente     = YES.

              FIND CURRENT gg-pendencia NO-LOCK NO-ERROR.
          END.

          /*Volta a pendencia de complemento simbolico para pendente*/
          FOR FIRST gg-mov-contr EXCLUSIVE-LOCK
              WHERE gg-mov-contr.cod-estabel  = tt-docum-est.cod-estabel
              AND   gg-mov-contr.num-romaneio = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN item-doc-est.num-romaneio-rel
                                                &ELSE int(SUBSTRING(item-doc-est.char-2,525,9)) &ENDIF
              AND   gg-mov-contr.num-seq      = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN item-doc-est.num-seq-roman
                                                &ELSE int(SUBSTRING(item-doc-est.char-2,534,6)) &ENDIF:
              find first gg-contrato no-lock
                where gg-contrato.ep-codigo    = gg-mov-contr.ep-codigo
                  and gg-contrato.cod-contrato = gg-mov-contr.cod-contrato no-error.
              if avail gg-contrato        and
                 gg-contrato.ind-tipo = 5 then do: /* arm gerais */
                  if gg-contrato.dat-ult-quebra-tec >= tt-docum-est.dt-trans and
                     gg-contrato.dat-ult-quebra-tec <> ?                     then do: 

                      /* Inicio -- Projeto Internacional */
                      DEFINE VARIABLE c-lbl-liter-quebra-tecnica-ja-calculada-at AS CHARACTER NO-UNDO.
                      {utp/ut-liter.i "Quebra_T‚cnica_j _c lculada_at‚" *}
                      ASSIGN c-lbl-liter-quebra-tecnica-ja-calculada-at = TRIM(RETURN-VALUE).
                      RUN _insertErrorManual IN hDBOin090 (INPUT 0,
                                                           INPUT "EMS":U,
                                                           INPUT "ERROR":U,
                                                           INPUT c-lbl-liter-quebra-tecnica-ja-calculada-at + "  " + string(gg-contrato.dat-ult-quebra-tec),
                                                           INPUT c-lbl-liter-quebra-tecnica-ja-calculada-at + "  " + string(gg-contrato.dat-ult-quebra-tec),
                                                           INPUT "":U).
                      CREATE tt-epc.
                      ASSIGN tt-epc.cod-event     = "ERROR":U
                             tt-epc.cod-parameter = "EPC-ERROR":U 
                             tt-epc.val-parameter = "Processo Abortado".

                      RETURN "NOK".
                  end.
              end.

              FIND FIRST gg-mov NO-LOCK 
                   WHERE gg-mov.cod-estabel         = gg-mov-contr.cod-estabel 
                     AND gg-mov.num-romaneio        = gg-mov-contr.num-romaneio NO-ERROR.

              IF gg-mov.ind-tip-mov = 1 THEN DO: /** Compra **/

                  ASSIGN de-saldo-disp = 0.
                  FOR EACH  gg-contrato-mov FIELDS (qtd-alocada-fechto qtd-peso qtd-pago dec-1) NO-LOCK  /*qtd-entreg-fisc*/
                      WHERE gg-contrato-mov.ep-codigo    = gg-mov-contr.ep-codigo 
                        AND gg-contrato-mov.cod-contrato = gg-mov-contr.cod-contrato
                        AND gg-contrato-mov.cod-estabel  = gg-mov-contr.cod-estabel
                        AND gg-contrato-mov.num-romaneio = gg-mov-contr.num-romaneio
                        AND gg-contrato-mov.referencia   = STRING(gg-mov-contr.num-seq):

                      ASSIGN de-saldo-disp = de-saldo-disp + gg-contrato-mov.dec-1 - (gg-contrato-mov.qtd-alocada-fechto + gg-contrato-mov.qtd-pago).  /*qtd-entreg-fisc*/
                  END.

                  IF gg-mov-contr.qtd-fiscal <> de-saldo-disp THEN DO: /* se a quantidade dispon¡vel da entrega for diferente, significa que tem pagto */

                      IF NOT CAN-FIND (FIRST gg-contrato-mov 
                                     WHERE gg-contrato-mov.cod-estabel   = tt-docum-est.cod-estabel
                                       AND gg-contrato-mov.cod-emitente  = tt-docum-est.cod-emitente
                                       AND gg-contrato-mov.nro-docto     = tt-docum-est.nro-docto
                                       AND gg-contrato-mov.serie-docto   = tt-docum-est.serie-docto
                                       AND gg-contrato-mov.nat-operacao  = tt-docum-est.nat-operacao
                                       AND gg-contrato-mov.ind-transacao = 4   /* Pagamento */ ) THEN DO:

                          RUN utp/ut-msgs.p (INPUT "HELP",
                                             INPUT 35614,
                                             INPUT "").
                          
                          CREATE tt-epc.
                          ASSIGN tt-epc.cod-event     = "ERROR":U
                                 tt-epc.cod-parameter = "EPC-ERROR":U 
                                 tt-epc.val-parameter = RETURN-VALUE. 
                          RETURN "NOK".
                      END.
                  END.
              END.

              IF  NOT CAN-FIND(FIRST gg-mov-contr-sal OF gg-mov-contr) THEN DO:
                  RUN piValidaPendenciaSolucionada( 0 ).

                  IF  RETURN-VALUE <> "OK":U THEN
                      RETURN "NOK":U.
              END.
              ELSE DO:
                  FOR EACH gg-mov-contr-sal OF gg-mov-contr NO-LOCK:
                      RUN piValidaPendenciaSolucionada( gg-mov-contr-sal.num-seq-pre ).

                      IF  RETURN-VALUE <> "OK":U THEN
                          RETURN "NOK":U.
                  END.
              END.

              IF  gg-mov.ind-tip-mov = 1  /** Compra  **/
              OR  gg-mov.ind-tip-mov = 7  /** Armazem **/ THEN DO:
                  RUN ggp/ggapi6004.p (INPUT IF gg-mov.ind-tip-mov = 1 THEN 2 ELSE 4,
                                       INPUT ROWID(gg-mov-contr)).  
              END.

              FOR FIRST natur-oper FIELDS (imp-nota) NO-LOCK 
                  WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao: 

                  /* somente retirar o n£mero e s‚rie do documento quando gerar nota no faturamento */
                  IF  natur-oper.imp-nota THEN DO:
                      ASSIGN gg-mov-contr.nro-docto    = "".
                  END.
              END.
                
              /* retorna status do movimento do romaneio para 2¦ pesagem */

              ASSIGN gg-mov-contr.ind-situacao = 2.
              FOR EACH bf-gg-mov-contr OF gg-mov EXCLUSIVE-LOCK
                  WHERE bf-gg-mov-contr.serie-docto  = tt-docum-est.serie-docto
                    AND bf-gg-mov-contr.nro-docto    = tt-docum-est.nro-docto
                    AND bf-gg-mov-contr.cod-emitente = tt-docum-est.cod-emitente
                    AND bf-gg-mov-contr.nat-operacao   = tt-docum-est.nat-operacao:
                  IF bf-gg-mov-contr.ind-situacao <> 2 THEN DO:
                      ASSIGN bf-gg-mov-contr.ind-situacao = 2.
                  END.         
              END.
              

              FOR EACH dupli-apagar NO-LOCK 
                  WHERE dupli-apagar.serie-docto  = item-doc-est.serie-docto 
                    AND dupli-apagar.nro-docto    = item-doc-est.nro-docto   
                    AND dupli-apagar.cod-emitente = item-doc-est.cod-emitente
                    AND dupli-apagar.nat-operacao = item-doc-est.nat-operacao:

                  FOR EACH dupli-imp NO-LOCK
                      WHERE dupli-imp.serie-docto  = dupli-apagar.serie-docto
                        AND dupli-imp.nro-docto    = dupli-apagar.nro-docto
                        AND dupli-imp.cod-emitente = dupli-apagar.cod-emitente
                        AND dupli-imp.nat-operacao = dupli-apagar.nat-operacao
                        AND dupli-imp.parcela      = dupli-apagar.parcela
                        AND dupli-imp.parcela-imp  = dupli-apagar.parcela:

                      IF NOT CAN-FIND(FIRST gg-mov-contrat-imposto
                                      WHERE gg-mov-contrat-imposto.cod-estab    = gg-mov-contr.cod-estabel
                                        AND gg-mov-contrat-imposto.num-romaneio = gg-mov-contr.num-romaneio  
                                        AND gg-mov-contrat-imposto.num-seq      = gg-mov-contr.num-seq       
                                        AND gg-mov-contrat-imposto.num-impto    = dupli-imp.cod-tax) THEN DO:

                          CREATE gg-mov-contrat-imposto.
                          ASSIGN gg-mov-contrat-imposto.cod-estab         = gg-mov-contr.cod-estabel
                                 gg-mov-contrat-imposto.num-romaneio      = gg-mov-contr.num-romaneio
                                 gg-mov-contrat-imposto.num-seq           = gg-mov-contr.num-seq
                                 gg-mov-contrat-imposto.num-impto         = dupli-imp.cod-tax         /*Cod Imposto      */
                                 gg-mov-contrat-imposto.dat-vencto        = dupli-imp.dt-venc-imp     /*Data Vencimento  */
                                 gg-mov-contrat-imposto.cdn-retenc-impto  = dupli-imp.cod-retencao    /*Cod Retencao     */
                                 gg-mov-contrat-imposto.num-despes        = gg-contrato.tp-receita    /*Tp Desp/Recta    */
                                 gg-mov-contrat-imposto.val-rendto-tribut = dupli-apagar.vl-a-pagar   /*Val Rendto Tribut*/
                                 gg-mov-contrat-imposto.cod-espec-docto   = dupli-imp.cod-esp         /*Especie          */
                                 gg-mov-contrat-imposto.cod-ser-docto     = dupli-imp.serie-docto     /*Serie            */
                                 gg-mov-contrat-imposto.cod-tit-ap        = dupli-imp.nro-docto       /*Docto            */
                                 gg-mov-contrat-imposto.cod-parcela       = dupli-imp.parcela.        /*Parcela*/

                          FIND FIRST tipo-tax NO-LOCK
                               WHERE tipo-tax.cod-tax = dupli-imp.cod-tax NO-ERROR.
                          IF  AVAIL tipo-tax THEN DO:

                              FIND FIRST gg-tipo-tax NO-LOCK
                                   WHERE gg-tipo-tax.cod-tax      = dupli-imp.cod-tax
                                     AND gg-tipo-tax.dat-ini-val <= gg-mov-contr.dt-trans
                                     AND gg-tipo-tax.dat-fim-val >= gg-mov-contr.dt-trans
                                     AND gg-tipo-tax.it-codigo    = item-doc-est.it-codigo NO-ERROR.
                              IF  AVAIL gg-tipo-tax THEN DO:
                                  ASSIGN gg-mov-contrat-imposto.idi-tip-calc  = 2 /*Peso*/
                                         gg-mov-contrat-imposto.val-perc-aliq = gg-tipo-tax.val-imposto                                       /* Aliquota    */
                                         gg-mov-contrat-imposto.val-imposto   = ((gg-mov-contr.qtd-fiscal / 1000) * gg-tipo-tax.val-imposto). /* Val Imposto */
                              END.
                              ELSE DO:
                                  ASSIGN gg-mov-contrat-imposto.idi-tip-calc  = 1 /*Percentual*/
                                         gg-mov-contrat-imposto.val-perc-aliq = tipo-tax.tax-perc                                      /* Aliquota    */
                                         gg-mov-contrat-imposto.val-imposto   = ((gg-mov-contr.val-mercad / 100) * tipo-tax.tax-perc). /* Val Imposto */
                              END.
                          END.
                      END.
                  END.
              END.
              
              /**** cria historico do movimento ****/
              {utp/ut-liter.i "Elimina‡Æo Nota Recebimento: " * R}
              RUN ggp/ggapi001.p(INPUT rowid(gg-mov),
                                 INPUT RETURN-VALUE + tt-docum-est.cod-estabel + " " + tt-docum-est.serie-docto          + " " 
                                                                              + tt-docum-est.nro-docto            + " " + tt-docum-est.nat-operacao + " " 
                                                                              + string(tt-docum-est.cod-emitente) + " " + gg-mov-contr.cod-contrato, 
                                 INPUT YES).
        
             FOR EACH bf-gg-mov-contr NO-LOCK 
                WHERE bf-gg-mov-contr.cod-estabel  = gg-mov-contr.cod-estabel
                  AND bf-gg-mov-contr.num-romaneio = gg-mov-contr.num-romaneio:
                 IF bf-gg-mov-contr.ind-situacao <> 2 THEN
                    ASSIGN l-tem = YES.
              END.
        
              FIND FIRST gg-mov EXCLUSIVE-LOCK 
                   WHERE gg-mov.cod-estabel         = gg-mov-contr.cod-estabel 
                     AND gg-mov.num-romaneio        = gg-mov-contr.num-romaneio NO-ERROR.
        
              IF l-tem = NO THEN DO:
                 IF AVAIL gg-mov THEN DO:
                    ASSIGN gg-mov.ind-situacao = 2.  /* 2¦ Pesagem */

                    /*Totvs colabora‡Æo - Atualizar status da nota de origem */
                    FIND FIRST tab-livre-graos EXCLUSIVE-LOCK
                         WHERE tab-livre-graos.cod-tabela           = 'gg-mov':U
                           AND tab-livre-graos.cod-modul-dtsul      = 'ggp':U
                           AND tab-livre-graos.cod-compon-1-idx-tab = gg-mov.cod-estabel
                           AND tab-livre-graos.cod-compon-2-idx-tab = STRING(gg-mov.num-romaneio) NO-ERROR.
                    IF  AVAIL tab-livre-graos THEN DO:
                        FIND FIRST doc-orig-nfe EXCLUSIVE-LOCK
                             WHERE doc-orig-nfe.ch-acesso-comp-nfe = tab-livre-graos.cod-livre-1 
                               AND doc-orig-nfe.idi-orig-trad      = 2 /* Traduzido */ NO-ERROR.
                        IF  AVAIL doc-orig-nfe THEN DO:
                            ASSIGN doc-orig-nfe.idi-situacao = 10. /* Gerado via Origina‡Æo */
                        END.
                    END.

                 END.
              END.
              FIND CURRENT gg-mov NO-LOCK NO-ERROR.
          END.
        
           IF AVAIL gg-mov-contr THEN
               FIND CURRENT gg-mov-contr NO-LOCK NO-ERROR.
    
        END.
    END.

    FOR EACH gg-classifica EXCLUSIVE-LOCK
       WHERE gg-classifica.des-tipo-docto = "docum-est"
         AND gg-classifica.cod-estabel    = tt-docum-est.cod-estabel
         AND gg-classifica.num-docto      = tt-docum-est.nro-docto   
         AND gg-classifica.serie          = tt-docum-est.serie-docto 
         AND gg-classifica.nat-operacao   = tt-docum-est.nat-operacao
         AND gg-classifica.cod-emitente   = tt-docum-est.cod-emitente:
        
        DELETE gg-classifica.
    END.
        
    FOR EACH gg-classifica EXCLUSIVE-LOCK
       WHERE gg-classifica.des-tipo-docto = "item-doc-est"
         AND gg-classifica.cod-estabel    = tt-docum-est.cod-estabel
         AND gg-classifica.num-docto      = tt-docum-est.nro-docto   
         AND gg-classifica.serie          = tt-docum-est.serie-docto 
         AND gg-classifica.nat-operacao   = tt-docum-est.nat-operacao
         AND gg-classifica.cod-emitente   = tt-docum-est.cod-emitente:
        DELETE gg-classifica.
    END.

    FOR FIRST gg-ext-docum-est EXCLUSIVE-LOCK
     where gg-ext-docum-est.serie-docto  = tt-docum-est.serie-docto 
      AND  gg-ext-docum-est.nro-docto    = tt-docum-est.nro-docto   
      AND  gg-ext-docum-est.cod-emitente = tt-docum-est.cod-emitente
      AND  gg-ext-docum-est.nat-operacao = tt-docum-est.nat-operacao 
      AND  gg-ext-docum-est.cod-estabel  = tt-docum-est.cod-estabel:
       delete gg-ext-docum-est. 
    END.


END.

PROCEDURE piValidaPendenciaSolucionada:
    DEF INPUT PARAM pSeqFix AS INTEGER NO-UNDO.

    /* **** Pendencias Fiscais - Se o Romaneio fizer parte de uma pendencia fiscal j  solucionada, nÆo poder  ser cancelada
            Primeiro necess rio cancelar a solu‡Æo da pendencia fiscal  **** */
    FOR EACH gg-pendencia-mov-contr FIELDS (qtd-peso ep-codigo cod-contrato num-seq num-seq-fix) NO-LOCK
       WHERE gg-pendencia-mov-contr.ep-codigo      = gg-mov-contr.ep-codigo
         AND gg-pendencia-mov-contr.cod-contrato   = gg-mov-contr.cod-contrato
         AND gg-pendencia-mov-contr.num-seq-fix    = pSeqFix
         AND gg-pendencia-mov-contr.cod-estabel    = gg-mov-contr.cod-estabel
         AND gg-pendencia-mov-contr.num-romaneio   = gg-mov-contr.num-romaneio
         AND gg-pendencia-mov-contr.num-seq-roman  = gg-mov-contr.num-seq:
       IF CAN-FIND (FIRST gg-pendencia NO-LOCK
                    WHERE gg-pendencia.ep-codigo    = gg-pendencia-mov-contr.ep-codigo
                      AND gg-pendencia.cod-contrato = gg-pendencia-mov-contr.cod-contrato
                      AND gg-pendencia.num-seq      = gg-pendencia-mov-contr.num-seq
                      AND gg-pendencia.num-seq-fix  = gg-pendencia-mov-contr.num-seq-fix
                      AND gg-pendencia.log-pendente = NO) THEN DO: 
           FIND FIRST gg-pendencia NO-LOCK
                WHERE gg-pendencia.ep-codigo    = gg-pendencia-mov-contr.ep-codigo
                  AND gg-pendencia.cod-contrato = gg-pendencia-mov-contr.cod-contrato
                  AND gg-pendencia.num-seq      = gg-pendencia-mov-contr.num-seq
                  AND gg-pendencia.num-seq-fix  = gg-pendencia-mov-contr.num-seq-fix NO-ERROR. 
    
           DEFINE VARIABLE c-lbl-liter-nota-pend-fiscal AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Nota_relacionada_a_uma_pendˆncia_fiscal_j _solucionada_na_nota_fiscal" *}
           ASSIGN c-lbl-liter-nota-pend-fiscal = TRIM(RETURN-VALUE).

           RUN _insertErrorManual IN hDBOin090 (INPUT 0,
                                                INPUT "EMS":U,
                                                INPUT "ERROR":U,
                                                INPUT c-lbl-liter-nota-fiscal-nao-pode-ser-elimi,
                                                INPUT c-lbl-liter-nota-pend-fiscal + " "
                                                    + gg-pendencia.serie-docto-rec  + "/":U
                                                    + gg-pendencia.nr-docto-rec     + "/":U
                                                    + STRING(gg-pendencia.cod-emitente-rec) + "/":U
                                                    + gg-pendencia.nat-operacao-rec,
                                                INPUT "":U).
    
           CREATE tt-epc.
           ASSIGN tt-epc.cod-event     = "ERROR":U
                  tt-epc.cod-parameter = "EPC-ERROR":U 
                  tt-epc.val-parameter = "Processo Abortado".
    
           RETURN "NOK":U.
    
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.
