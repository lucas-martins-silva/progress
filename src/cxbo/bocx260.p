/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX260 2.00.00.025} /*** "010025" 08/05/2025 14:42:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx260 MUT}
&ENDIF

/*
**  BOCX260.P
**
**  proc-nota-fiscal - 
**
*/

{cdp/cdcfgdis.i} /* Definicao de pre-processadores */
{include/boini.i}
{cdp/cdcfgmat.i}
{cxbo/bocx260.i RowObject}
{cxbo/bocx260.i tt-proc-nota-fiscal}
{include/i-epc200.i "bocx260"}
{utp/ut-glob.i}

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY proc-nota-fiscal
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME proc-nota-fiscal
 
DEFINE VARIABLE c-cod-estabel    LIKE proc-nota-fiscal.cod-estabel NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp    LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO. 

DEFINE VARIABLE c-nr-proc-exp-ini LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp-fim LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.

DEFINE VARIABLE c-rowid          AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE h-bocx195        AS   HANDLE                       NO-UNDO.
DEFINE VARIABLE c-cod-est-proc   LIKE nota-fiscal.cod-estabel      NO-UNDO.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

PROCEDURE setConstraint1:
END PROCEDURE.

PROCEDURE setConstraint2:
    DEFINE INPUT PARAMETER p-cod-estab LIKE proc-nota-fiscal.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-proc-exp  LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.

    ASSIGN c-cod-estabel    = p-cod-estab 
           c-nr-proc-exp    = p-proc-exp.
               
END PROCEDURE.

PROCEDURE setConstraint3:
    DEFINE INPUT PARAMETER r-chave AS ROWID NO-UNDO.

    FIND FIRST processo-exp NO-LOCK
         WHERE ROWID(processo-exp) = r-chave NO-ERROR.

END PROCEDURE.

PROCEDURE setConstraint4:
    DEFINE INPUT PARAMETER p-proc-exp  LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.
    
    ASSIGN c-nr-proc-exp = p-proc-exp.

END PROCEDURE.

PROCEDURE setConstraint5:
    DEFINE INPUT PARAMETER p-proc-exp-ini LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER p-proc-exp-fim LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.
    
    ASSIGN c-nr-proc-exp-ini = p-proc-exp-ini
           c-nr-proc-exp-fim = p-proc-exp-fim.

END PROCEDURE.

PROCEDURE openQuery:
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.
    
    ASSIGN i-bo-query = i-abertura.
           l-query    = YES.

    CASE i-abertura:
        WHEN 1 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} NO-LOCK. 
        WHEN 2 THEN DO:
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                        WHERE proc-nota-fiscal.cod-estabel = c-cod-estabel 
                                          AND proc-nota-fiscal.nr-proc-exp = c-nr-proc-exp NO-LOCK.
        END.                                                          
        WHEN 3 THEN
            IF c-nr-proc-exp = "" THEN DO:
               OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} OF processo-exp NO-LOCK
                                             BY proc-nota-fiscal.nr-nota-fis 
                                             BY proc-nota-fiscal.serie
                                             BY proc-nota-fiscal.cod-estab-faturam.
            END.
            ELSE DO:
               OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                            WHERE proc-nota-fiscal.nr-proc-exp = c-nr-proc-exp NO-LOCK
                                             BY proc-nota-fiscal.nr-nota-fis 
                                             BY proc-nota-fiscal.serie
                                             BY proc-nota-fiscal.cod-estab-faturam.
            end.   
        WHEN 4 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                        WHERE proc-nota-fiscal.nr-proc-exp = c-nr-proc-exp NO-LOCK.
        WHEN 5 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                        WHERE {&TABLE-NAME}.nr-proc-exp >= c-nr-proc-exp-ini 
                                          AND {&TABLE-NAME}.nr-proc-exp <= c-nr-proc-exp-fim NO-LOCK.

    END CASE.
   
END PROCEDURE.

 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}


PROCEDURE validateFields:
    /*
    **  Valida Fields
    */
    FIND FIRST rowObject NO-LOCK NO-ERROR.
    
    RUN startMethod ("validateFields").
    RUN exp/exapi005.p (INPUT  TABLE rowObject, 
                        OUTPUT TABLE tt-bo-erro).
 
    IF  rowObject.cod-estabel = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.
 
    IF  rowObject.nr-nota-fis = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.
 
    IF  rowObject.nr-proc-exp = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.
 
    RUN endMethod ("validateFields").

END PROCEDURE.

PROCEDURE initializeFields:

   /** Inicializa campos da tela **/
      
END PROCEDURE.

PROCEDURE initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    RUN startMethod ("initializeValidade").
 
    RUN endMethod   ("initializeValidade").
END PROCEDURE.

PROCEDURE getCharField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS CHARACTER NO-UNDO.
 
    CASE c-field:
        WHEN "char-1"       THEN c-value = RowObject.char-1.
        WHEN "char-2"       THEN c-value = RowObject.char-2.
        WHEN "check-sum"    THEN c-value = RowObject.check-sum.
        WHEN "cod-estabel"  THEN c-value = RowObject.cod-estabel.
        WHEN "nr-nota-fis"  THEN c-value = RowObject.nr-nota-fis.
        WHEN "nr-proc-exp"  THEN c-value = RowObject.nr-proc-exp.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getDecField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DECIMAL   NO-UNDO.
 
    CASE c-field:
        WHEN "dec-1" THEN c-value = RowObject.dec-1.
        WHEN "dec-2" THEN c-value = RowObject.dec-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getIntField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS INTEGER   NO-UNDO.
 
    CASE c-field:
        WHEN "int-1" THEN c-value = RowObject.int-1.
        WHEN "int-2" THEN c-value = RowObject.int-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getDateField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DATE      NO-UNDO.
 
    CASE c-field:
        WHEN "data-1" THEN c-value = RowObject.data-1.
        WHEN "data-2" THEN c-value = RowObject.data-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getLogField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS LOGICAL   NO-UNDO.
 
    CASE c-field:
        WHEN "log-1" THEN c-value = RowObject.log-1.
        WHEN "log-2" THEN c-value = RowObject.log-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE cancelaNota:
/*Atualiza a situaá∆o do processo de exportaá∆o no momento do cancelamento de uma NF no Faturamento*/

  DEFINE INPUT PARAMETER c-cod-estabel       LIKE nota-fiscal.cod-estabel    NO-UNDO.
  DEFINE INPUT PARAMETER i-nr-proc-exp       LIKE nota-fiscal.nr-proc-exp    NO-UNDO.
  DEFINE INPUT PARAMETER c-cod-estab-faturam LIKE nota-fiscal.cod-estabel    NO-UNDO.
  DEFINE INPUT PARAMETER c-serie             LIKE nota-fiscal.serie          NO-UNDO.
  DEFINE INPUT PARAMETER i-nr-nota-fis       LIKE nota-fiscal.nr-nota-fis    NO-UNDO.
   
  DEFINE VARIABLE l-encontrou AS LOGICAL NO-UNDO. /* identifica se existe mais notas para o processo */
  DEFINE VARIABLE de-volume   AS DECIMAL INIT 0 NO-UNDO.

  FIND FIRST processo-exp EXCLUSIVE-LOCK
       WHERE processo-exp.cod-estabel = c-cod-estabel 
         AND processo-exp.nr-proc-exp = i-nr-proc-exp NO-ERROR.
  
  IF  AVAIL processo-exp THEN DO:
      ASSIGN l-encontrou = no.
     
      FIND FIRST nota-fiscal NO-LOCK 
           WHERE nota-fiscal.cod-estabel = c-cod-estab-faturam 
             AND nota-fiscal.serie       = c-serie       
             AND nota-fiscal.nr-nota-fis = i-nr-nota-fis NO-ERROR.      
     
      IF  AVAIL nota-fiscal 
      AND nota-fiscal.ind-tip-nota = 3 THEN LEAVE.
     
      nota:
      FOR EACH proc-nota-fiscal 
         WHERE proc-nota-fiscal.cod-estabel =  processo-exp.cod-estabel 
           AND proc-nota-fiscal.nr-proc-exp =  processo-exp.nr-proc-exp 
           AND proc-nota-fiscal.serie       =  c-serie NO-LOCK:

          IF proc-nota-fiscal.nr-nota-fis = i-nr-nota-fis THEN NEXT.
         
          /**************************************************
          *     Engenharia Devolucao Nota de Exportacao     *
          **************************************************/
          &IF "{&bf_dis_versao_ems}":U >= "2.06":U &THEN
              IF  proc-nota-fiscal.log-nf-devolvid THEN NEXT.
          &ELSE 
              &IF "{&bf_dis_versao_ems}":U >= "2.04":U &THEN
                  IF  proc-nota-fiscal.log-1 THEN NEXT.
              &ENDIF
          &ENDIF
        
          FIND FIRST nota-fiscal NO-LOCK
               WHERE nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                 AND nota-fiscal.serie       = proc-nota-fiscal.serie       
                 AND nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis NO-ERROR.

          IF AVAIL nota-fiscal THEN
             IF nota-fiscal.dt-cancela = ? THEN DO:
                 ASSIGN l-encontrou = YES.
                 LEAVE nota.           
             END.
      END. /* bloco nota */

      IF l-encontrou THEN
          ASSIGN processo-exp.cod-sit-proc = 7. /* Faturado Parcial */
      ELSE
          ASSIGN processo-exp.cod-sit-proc = 1. /* Aberto */
      
      FOR EACH  proc-it-nota-fisc NO-LOCK
          WHERE proc-it-nota-fisc.cod-estab-faturam = nota-fiscal.cod-estabel
          AND   proc-it-nota-fisc.serie             = nota-fiscal.serie
          AND   proc-it-nota-fisc.nr-nota-fis       = nota-fiscal.nr-nota-fis:
          FIND FIRST it-nota-fisc NO-LOCK  
               WHERE it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
               AND   it-nota-fisc.serie       = proc-it-nota-fisc.serie
               AND   it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
               AND   it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat NO-ERROR.
          FOR EACH  item-embal of it-nota-fisc NO-LOCK:
              FIND FIRST embalag NO-LOCK 
                   WHERE embalag.sigla-emb = item-embal.sigla-emb NO-ERROR.
            ASSIGN de-volume = de-volume + embalag.volume.
          END.
      END.   

      /* Integrado com GFE */
      IF  CAN-FIND(FIRST funcao NO-LOCK 
                   WHERE funcao.cd-funcao = "SPP_TOTVSGFE":U 
                     AND funcao.ativo = YES) 
                      AND de-volume > 0 THEN
                     
      /* Posiciona tab-generica */
      FOR  FIRST tab-generica NO-LOCK
           WHERE tab-generica.utilizacao = "SETUP" :
            
           IF SUBSTRING(tab-generica.char-2,231,1) = "Y":U THEN       /* CD0089 - Notas Fiscais de Sa≠da */
              ASSIGN de-volume = de-volume / 1000000. // converte cm¸ para m¸ - volume informado na embalagem quando tem GFE deve ser em cms c£bicos, mas deve ser gravado em m¸ no processo
                                                         //Levamos em consideraá∆o o documento: https://centraldeatendimento.totvs.com/hc/pt-br/articles/360026471693-Log%C3%ADstica-Linha-Protheus-GFE-C%C3%A1lculo-do-volume-no-Item-do-Documento-de-Carga-GW8-VOLUME#:~:text=%C3%89%20considerada%20a%20Unidade%20de,*%20Comprimento%29%20*%20Quantidade%20Item
      END.    

      FIND FIRST processo-exp EXCLUSIVE-LOCK
           WHERE processo-exp.cod-estabel = &if '{&bf_mat_versao_ems}' >= '2.071' &then
                                            nota-fiscal.cod-estab-proces-export
                                            &else
                                            trim(substring(nota-fiscal.char-1,124,3))
                                            &endif
           AND   processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp         NO-ERROR.
         
           IF AVAIL processo-exp THEN DO:
             ASSIGN processo-exp.volume = processo-exp.volume - de-volume
                    de-volume           = 0.
           END.
  END. /* if avail processo-exp ... */
                
END PROCEDURE.


PROCEDURE criaProcNota:
    /*
    ** Cria relacionamento entre nota fiscal
    */ 
    DEFINE INPUT PARAMETER r-nota-fiscal AS ROWID NO-UNDO.
  
    DEFINE VARIABLE h-bocx265           AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boar2113          AS HANDLE  NO-UNDO.
    DEFINE VARIABLE l-funcao-implantada AS LOGICAL NO-UNDO.

    /*
    ** Tratamento da funá∆o desenvolvida para o cliente UBV - EMS 2.01 para permitir a vinculaá∆o parcial de pedidos ao processo
    */
    &IF DEFINED(bf_dis_versao_ems) &THEN
    &ELSE
    
        IF CAN-FIND(FIRST funcao 
                    WHERE funcao.cd-funcao = "spp-ubv-pedido-parcial":U
                      AND funcao.ativo) THEN DO:
                          
            ASSIGN l-funcao-implantada = YES.

            FIND FIRST nota-fiscal NO-LOCK  
                WHERE ROWID(nota-fiscal) = r-nota-fiscal NO-ERROR.

            FOR EACH it-nota-fisc NO-LOCK OF nota-fiscal:

                FIND FIRST proc-ped-ent
                    &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN
                     WHERE proc-ped-ent.cod-estabel  = nota-fiscal.cod-estab-proces-export
                    &else
                     WHERE proc-ped-ent.cod-estabel  = substring(nota-fiscal.char-1,124,3)
                    &endif
                       AND proc-ped-ent.nr-proc-exp  = nota-fiscal.nr-proc-exp
                       AND proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli
                       AND proc-ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli
                       AND proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped
                       AND proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer
                       AND proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega                           
                       AND proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL proc-ped-ent THEN DO:

                    FIND FIRST proc-nota-fiscal NO-LOCK
                       &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN
                        WHERE proc-nota-fiscal.cod-estabel       = nota-fiscal.cod-estab-proces-export
                       &else
                        WHERE proc-nota-fiscal.cod-estabel       = substring(nota-fiscal.char-1,124,3)
                       &endif
                          AND proc-nota-fiscal.nr-proc-exp       = proc-ped-ent.nr-proc-exp         
                          and proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                          AND proc-nota-fiscal.serie             = nota-fiscal.serie               
                          AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis NO-ERROR.
                    IF NOT AVAIL proc-nota-fiscal THEN DO:
        
                        CREATE proc-nota-fiscal.
                        ASSIGN proc-nota-fiscal.cod-estabel       = &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN 
                                                                     nota-fiscal.cod-estab-proces-export
                                                                    &else
                                                                     substring(nota-fiscal.char-1,124,3)
                                                                    &endif
                               proc-nota-fiscal.nr-proc-exp       = proc-ped-ent.nr-proc-exp
                               proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                               proc-nota-fiscal.serie             = nota-fiscal.serie       
                               proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis.
                            
                    END.

                    FIND proc-it-nota-fisc NO-LOCK 
                        &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN
                        WHERE proc-it-nota-fisc.cod-estabel = nota-fiscal.cod-estab-proces-export
                       &else
                        WHERE proc-it-nota-fisc.cod-estabel = substring(nota-fiscal.char-1,124,3)
                       &endif
                          AND proc-it-nota-fisc.nr-proc-exp = proc-ped-ent.nr-proc-exp        
                          AND proc-it-nota-fisc.serie       = nota-fiscal.serie               
                          AND proc-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis         
                          AND proc-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat         
                          AND proc-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo NO-ERROR.
                    IF NOT AVAIL proc-it-nota-fisc THEN DO:

                       CREATE proc-it-nota-fisc.
                       ASSIGN proc-it-nota-fisc.cod-estab-faturam = it-nota-fisc.cod-estabel 
                              proc-it-nota-fisc.serie             = it-nota-fisc.serie        
                              proc-it-nota-fisc.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                              proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat
                              proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo
                              proc-it-nota-fisc.nr-sequencia      = it-nota-fisc.nr-seq-ped 
                              proc-it-nota-fisc.nome-abrev        = it-nota-fisc.nome-ab-cli
                              proc-it-nota-fisc.nr-pedcli         = it-nota-fisc.nr-pedcli
                              proc-it-nota-fisc.cod-refer         = it-nota-fisc.cod-refer
                              proc-it-nota-fisc.nr-entrega        = it-nota-fisc.nr-entrega
                              proc-it-nota-fisc.cod-estabel       = &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN 
                                                                     nota-fiscal.cod-estab-proces-export
                                                                    &else
                                                                     substring(nota-fiscal.char-1,124,3)
                                                                    &endif
                              proc-it-nota-fisc.nr-proc-exp       = proc-ped-ent.nr-proc-exp
                              proc-it-nota-fisc.nr-pedido         = proc-ped-ent.nr-pedido
                              proc-it-nota-fisc.cod-fabric        = proc-ped-ent.cod-fabric.
                
                    END.
                END.
            END.
        END.
    &ENDIF
    
    IF l-funcao-implantada THEN
        LEAVE.

    FIND FIRST nota-fiscal NO-LOCK  
         WHERE ROWID(nota-fiscal) = r-nota-fiscal NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        /************************************************************************************
        ** EPC - Implementado para poder atualizar a nota antes de relacionar com o processo
        ************************************************************************************/
        FOR EACH tt-epc 
            WHERE tt-epc.cod-event = "BEFORE-CREATEPROCNOTA": 
            DELETE tt-epc. 
        END.
        /*** Criacao do registro para temp-table tt-epc ***/
        {include/i-epc200.i2 &CodEvent='"BEFORE-CREATEPROCNOTA"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter=string(ROWID(nota-fiscal))}
             
        /*** Chamada do programa EPC ***/
        {include/i-epc201.i "BEFORE-CREATEPROCNOTA"}
      
        FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

        &IF DEFINED(bf_dis_proc_ent) &then /* EMS 2.04 */   
        &ELSE /* Magnus, EMS 2.00, EMS 2.02 */
            
            FIND FIRST proc-nota-fiscal NO-LOCK
                &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN 
                 WHERE proc-nota-fiscal.cod-estabel       = nota-fiscal.cod-estab-proces-export
                &else
                 WHERE proc-nota-fiscal.cod-estabel       = substring(nota-fiscal.char-1,124,3)
                &endif
                   AND proc-nota-fiscal.nr-proc-exp       = nota-fiscal.nr-proc-exp         
                   and proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel         
                   AND proc-nota-fiscal.serie             = nota-fiscal.serie               
                   AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis NO-ERROR.
                       
            IF NOT AVAIL proc-nota-fiscal THEN DO:
                CREATE proc-nota-fiscal.
                ASSIGN proc-nota-fiscal.cod-estabel       = &IF "{&bf_mat_versao_ems}":U >= "2.071":U &THEN 
                                                             nota-fiscal.cod-estab-proces-export
                                                            &else
                                                             substring(nota-fiscal.char-1,124,3)
                                                            &endif
                       proc-nota-fiscal.nr-proc-exp       = nota-fiscal.nr-proc-exp 
                       proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel 
                       proc-nota-fiscal.serie             = nota-fiscal.serie       
                       proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis.
            END.
        &ENDIF
    
        FOR EACH it-nota-fisc NO-LOCK OF nota-fiscal:

            &if defined(bf_dis_proc_ent) &then /* EMS 2.04 */
                &IF "{&bf_mat_versao_ems}":U <= "2.07":U &THEN
                     ASSIGN c-cod-est-proc = SUBSTRING(nota-fiscal.char-1,124,3).
                &ELSE
                     ASSIGN c-cod-est-proc = nota-fiscal.cod-estab-proces-export.
                &ENDIF

                FIND FIRST proc-nota-fiscal NO-LOCK 
                     WHERE proc-nota-fiscal.cod-estabel       = c-cod-est-proc
                       AND proc-nota-fiscal.nr-proc-exp       = nota-fiscal.nr-proc-exp 
                       and proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                       AND proc-nota-fiscal.serie             = nota-fiscal.serie        
                       AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis NO-ERROR.
                IF  NOT AVAIL proc-nota-fiscal THEN DO:
                    
                    CREATE proc-nota-fiscal.
                    ASSIGN proc-nota-fiscal.cod-estabel       = c-cod-est-proc
                           proc-nota-fiscal.nr-proc-exp       = nota-fiscal.nr-proc-exp 
                           proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel 
                           proc-nota-fiscal.serie             = nota-fiscal.serie       
                           proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis.
                END.
            &ENDIF

            RUN cxbo/bocx265.p PERSISTENT SET h-bocx265.
            RUN criaProcItNota IN h-bocx265 (INPUT ROWID(it-nota-fisc)).
            DELETE PROCEDURE h-bocx265.

        END. /* FOR EACH it-nota-fisc ... */       

    END. /* if avail nota-fiscal ... */

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:

        IF  NOT VALID-HANDLE(h-boar2113) THEN
            RUN local/arg/boar2113.p PERSISTENT SET h-boar2113.

        RUN gera-procexp IN h-boar2113 (INPUT c-cod-est-proc,
                                        INPUT nota-fiscal.nr-proc-exp).

        IF  VALID-HANDLE(h-boar2113) THEN DO:
            RUN destroy IN h-boar2113.
            ASSIGN h-boar2113 = ?.
        END.
    END.

    /************************************************************************************
    ** EPC - Implementado para poder atualizar o ralacionamento nota e processo
    ************************************************************************************/
    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "AFTER-CREATEPROCNOTA": 
        delete tt-epc. 
    end.
    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"AFTER-CREATEPROCNOTA"'
                         &CodParameter='"TABLE-ROWID"'
                         &ValueParameter=string(ROWID(nota-fiscal))}
      
    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "AFTER-CREATEPROCNOTA"}
  
END PROCEDURE.


PROCEDURE deleteProcessobyNotafiscal:
    /*
    ** Elimina relacionamento Nota Fiscal x Processo de Exportaá∆o
    */
    DEFINE INPUT PARAMETER r-nota-fiscal AS ROWID NO-UNDO.
    
    FIND FIRST nota-fiscal
         WHERE ROWID(nota-fiscal) = r-nota-fiscal NO-LOCK NO-ERROR.

    FOR EACH proc-nota-fiscal
       WHERE proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
         AND proc-nota-fiscal.serie             = nota-fiscal.serie
         AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK:
        DELETE proc-nota-fiscal.
    END.

    FOR EACH proc-it-nota-fisc
       WHERE proc-it-nota-fisc.cod-estab-faturam = nota-fiscal.cod-estabel
         AND proc-it-nota-fisc.serie             = nota-fiscal.serie
         AND proc-it-nota-fisc.nr-nota-fis       = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK:
       DELETE proc-it-nota-fisc.
    END.

    RETURN "OK":U.
END PROCEDURE.


procedure pi-nf-dif-preco-embarcada:
    /*
    ** Identifica e seta na proc-nota-fiscal as NFs de diferenáa de preáo emitida ap¢s embarque da mercadoria
    ** quando contabiliza receita de exportaá∆o pela data do embarque
    */

    define input  parameter prw-nota-fiscal          as rowid   no-undo.
    define output parameter pl-nf-dif-preco-pos-emb  as logical no-undo.
    
    DEFINE VARIABLE h-bocx362               AS HANDLE      NO-UNDO.
    DEFINE VARIABLE idi-tip-operac-log      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE idi-situacao-log        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-geracao-log          AS DATE        NO-UNDO.

    run cxbo/bocx362.p persistent set h-bocx362.

    assign pl-nf-dif-preco-pos-emb = no.
    
    for first nota-fiscal
        where rowid(nota-fiscal) = prw-nota-fiscal no-lock:

        for first param-exp 
            where param-exp.cod-estabel = nota-fiscal.cod-estab-proces-export no-lock:

            if param-exp.log-ctblz-recta-embarq then do:

                   IF  nota-fiscal.ind-tip-nota = 3 
                   and not nota-fiscal.log-var-cambial then do:
                       run piverificaLogProcessadoEfetivacao in h-bocx362 (INPUT nota-fiscal.cod-estab-proces-export,
                                                                           INPUT nota-fiscal.nr-proc-exp,
                                                                           INPUT 1,    /*Log de contabilizaá∆o da Receita*/
                                                                           OUTPUT idi-situacao-log,
                                                                           OUTPUT dt-geracao-log).

                       if  nota-fiscal.dt-emis-nota > dt-geracao-log then  /*Verifica se a emiss∆o da nota foi ap¢s a geraá∆o do Log de contabilizaá∆o da Receita*/
                            assign pl-nf-dif-preco-pos-emb = yes.
                       else /*nota n∆o foi emitida ap¢s geraá∆o do log*/
                           assign pl-nf-dif-preco-pos-emb = no.

                   end.
            end.
        end.
    end.	
                        
    if valid-handle(h-bocx362) then do:
        delete procedure h-bocx362.
        assign h-bocx362 = ?.
    end.

    return "ok":U.
end procedure. 
    
