/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028E 2.00.00.007 } /*** "010007" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9028e MBC}
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
**     Programa...: bc9028e.p  
**
**     Finalidade.: Adapter da reporte de repetitivo do EMS 2.
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{bcp/bcapi004.i} /* Definicao da temp-table tt-prog-bc */
{cdp/cdcfgmat.i} /* Definiªío do preprocessador bf_mat_conta_estab */
{cpp/cpapi009.i} /* Definiªío das temp-tables da API de reporte repetitivo */
{cpp/cpapi009.i6}

{cpp/cpapi029.i}
/*********************************************************************************/
DEFINE VARIABLE vNroDocto           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-conteudo          AS CHARACTER            NO-UNDO.
/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE i-nr-linha          AS INTEGER              NO-UNDO.
DEFINE VARIABLE c-cod-estabel       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i-num-serial        AS DECIMAL              NO-UNDO.
DEFINE VARIABLE h_bosc075           AS HANDLE               NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl      AS HANDLE               NO-UNDO.
DEFINE VARIABLE c-ct-refugo         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-sc-refugo         AS CHARACTER            NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
            FIELD ttv_num_cod_erro   AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
            FIELD ttv_des_msg_ajuda  AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
            FIELD ttv_des_msg_erro   AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistància".

{method/dbotterr.i}
/*********************************************************************************/
{include/i-epc200.i bc9006e} /** Upc **/
DO ON ERROR UNDO, LEAVE:
   IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
      RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
   
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
   IF NOT AVAIL ttIntegracao THEN DO:
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 25346,
                        INPUT "bc9006d":U).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 25346
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   FIND FIRST param-global NO-LOCK NO-ERROR.
   IF NOT AVAIL param-global THEN DO:
      {utp/ut-table.i mguni param-global 1}
      RUN utp/ut-msgs.p ( INPUT "MSG":U,
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
   
   EMPTY TEMP-TABLE tt-prog-bc.

   ASSIGN c-conteudo = _RetornaValChar('cod-estabel').
   FIND FIRST estabelec
        WHERE estabelec.cod-estabel = c-conteudo NO-LOCK NO-ERROR.
   IF NOT AVAIL estabelec THEN DO:
      {utp/ut-table.i mgadm estabelec 1}
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 56,
                        INPUT TRIM(RETURN-VALUE)).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 56
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = item.it-codigo
          AND item-uni-estab.cod-estabel = c-conteudo NO-LOCK NO-ERROR.   
   IF AVAIL item-uni-estab THEN
      ASSIGN i-nr-linha = item-uni-estab.nr-linha.
   
   CREATE tt-prog-bc.
   ASSIGN tt-prog-bc.cod-versao-integracao    = 1
          tt-prog-bc.nr-trans                 = pNumTrans
          tt-prog-bc.opcao                    = 2.
   
   IF AVAIL param-global AND param-global.modulo-cl THEN DO:
      RUN bcp/bcapi004.p (INPUT-OUTPUT TABLE tt-prog-bc,
                          INPUT-OUTPUT TABLE tt-erro).
   END.
   
   FIND FIRST tt-prog-bc NO-LOCK NO-ERROR.
   
   IF item.tipo-con-est = 2 THEN DO:
      CREATE tt-serie.
      ASSIGN tt-serie.nr-serie   = _RetornaValChar('lote-serie')
             tt-serie.sequencia  = 1
             tt-serie.refugo     = (tt-prog-bc.motivo-backflush > 1).
   END.
   
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN
      RETURN 'NOK':U.
   
   CREATE tt-rep-prod.
   
   
   ASSIGN tt-rep-prod.nr-reporte             = 0.
   
   ASSIGN tt-rep-prod.data                   = TODAY
          tt-rep-prod.usuario                = _RetornaValChar('cod-usuario')
          tt-rep-prod.hora                   = STRING(TIME,"HH:MM:SS")
          tt-rep-prod.it-codigo              = item.it-codigo.
   
   ASSIGN tt-rep-prod.ct-refugo              = _RetornaValChar('ct-refugo')
          tt-rep-prod.sc-refugo              = _RetornaValChar('sc-refugo')
          tt-rep-prod.nro-docto              = _RetornaValChar('nro-docto') /* vNroDocto */
          tt-rep-prod.serie-docto            = _RetornaValChar('serie-docto')
          tt-rep-prod.cod-depos              = _RetornaValChar('cod-depos')
          tt-rep-prod.lote-serie             = _RetornaValChar('lote-serie')
          tt-rep-prod.cod-refer              = _RetornaValChar('cod-refer')
          tt-rep-prod.dt-vali-lote           = _RetornaValData('dt-vali-lote')
          tt-rep-prod.cod-localiz            = _RetornaValChar('cod-localiz')
          tt-rep-prod.cod-estabel            = _RetornaValChar('cod-estabel')
          tt-rep-prod.cod-cta-unif           = _RetornaValChar('cod-cta-unif')
          tt-rep-prod.cod-ccusto-unif        = _RetornaValChar('cod-ccusto-unif')
          tt-rep-prod.cod-depos-sai          = _RetornaValChar('cod-depos-sai')
          tt-rep-prod.cod-local-sai          = _RetornaValChar('cod-local-sai')
          tt-rep-prod.cod-versao-integracao  = 003.
   
   IF tt-rep-prod.cod-depos-sai = ? THEN
      ASSIGN tt-rep-prod.cod-depos-sai = "".
   
   IF tt-rep-prod.cod-local-sai = ? THEN
      ASSIGN tt-rep-prod.cod-local-sai = "".
   
   ASSIGN i-num-serial  = _RetornaValDeci('num-serial')
          c-cod-estabel = _RetornaValChar('cod-estabel').
   
   IF tt-rep-prod.cod-depos-sai = "" THEN DO:
      /* Retornar dep¢sito de f†brica */
      IF NOT VALID-HANDLE(h-cpapi029) THEN
         RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.
   
      RUN pi-execute IN h-cpapi029 (INPUT 1,
                                    INPUT c-cod-estabel,
                                    INPUT i-nr-linha,
                                    OUTPUT c-dep-fabrica,
                                    OUTPUT d-var-rep       ,
                                    OUTPUT d-var-req-menor ,
                                    OUTPUT d-var-requis    ,
                                    OUTPUT d-var-transf   ,
                                    OUTPUT TABLE tt-erro APPEND). 
      
      ASSIGN tt-rep-prod.cod-depos-sai = c-dep-fabrica.
   END.

   ASSIGN tt-rep-prod.loc-sai-unica = _RetornaValLogi('loc-sai-unica')
          tt-rep-prod.char-1        = _RetornaValChar('Cod-Livre-1')
          tt-rep-prod.char-2        = _RetornaValChar('Cod-Livre-2')
          tt-rep-prod.dec-1         = _RetornaValDeci('Dec-Livre-1')
          tt-rep-prod.dec-2         = _RetornaValDeci('Dec-Livre-2')
          tt-rep-prod.int-1         = _RetornaValInte('Num-Livre-1')
          tt-rep-prod.int-2         = _RetornaValInte('Num-Livre-2')
          tt-rep-prod.log-1         = _RetornaValLogi('Log-Livre-1')
          tt-rep-prod.log-2         = _RetornaValLogi('Log-Livre-2')
          tt-rep-prod.data-1        = _RetornaValData('Dat-Livre-1')
          tt-rep-prod.data-2        = _RetornaValData('Dat-Livre-2')
          tt-rep-prod.l-emite-rel   = _RetornaValLogi('Log-Livre-3')
          tt-rep-prod.prog-seg      = _RetornaValChar('prog-seg')
          tt-rep-prod.time-out      = _RetornaValInte('time-out').
   
   ASSIGN tt-rep-prod.tentativas    = _RetornaValInte('tentativas')
          tt-rep-prod.qt-reporte    = _RetornaValDeci('qt-reporte')
          tt-rep-prod.qt-refugo     = _RetornaValDeci('qt-refugo')
          tt-rep-prod.qt-estorno    = _RetornaValDeci('qt-estorno')
          tt-rep-prod.qt-apr-cond   = _RetornaValDeci('qt-apr-cond')
          tt-rep-prod.qt-est-aprov  = _RetornaValDeci('qt-est-aprov')
          tt-rep-prod.qt-est-refugo = _RetornaValDeci('qt-est-refugo').
   
   IF VALID-HANDLE(h-cpapi029) THEN
      DELETE OBJECT h-cpapi029.  
   
   IF NOT VALID-HANDLE(h_bosc075) THEN
      RUN scbo/bosc075.p PERSISTENT SET h_bosc075.

   RUN geraCargaProducao IN h_bosc075 (INPUT c-cod-estabel,
                                       INPUT tt-rep-prod.cod-depos,
                                       INPUT i-num-serial).
   IF RETURN-VALUE <> "OK":U THEN DO:
      RUN getRowErrors IN h_bosc075 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors NO-LOCK:
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                tt-erro.mensagem = RowErrors.ErrorDescription.
         RETURN 'NOK':U.
      END.
   END.
   
   IF VALID-HANDLE(h_bosc075) THEN
      RUN destroy IN h_bosc075.
   
   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF AVAIL tt-erro THEN
      RETURN "NOK":U.
   
   CASE tt-prog-bc.motivo-backflush:
      WHEN 1 THEN
         ASSIGN tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
      WHEN 2 THEN DO:
         ASSIGN c-ct-refugo = IF _RetornaValChar('ct-refugo') = '' THEN tt-prog-bc.cod-cta-refugo-unif ELSE _RetornaValChar('ct-refugo')
                c-sc-refugo = IF _RetornaValChar('sc-refugo') = '' THEN tt-prog-bc.cod-ccusto-refugo-unif ELSE _RetornaValChar('sc-refugo').
         
         /*Valida conta contabil*/            
         RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT estabelec.ep-codigo,             /* EMPRESA EMS2 */
                                                         INPUT _RetornaValChar('cod-estabel'),  /* ESTABELECIMENTO EMS2 */
                                                         INPUT "",                              /* UNIDADE NEG‡CIO */
                                                         INPUT "",                              /* PLANO CONTAS */ 
                                                         INPUT c-ct-refugo,                     /* CONTA */
                                                         INPUT "",                              /* PLANO CCUSTO */ 
                                                         INPUT c-sc-refugo,                     /* CCUSTO */
                                                         INPUT TODAY,                           /* DATA TRANSACAO */
                                                         OUTPUT TABLE tt_log_erro).             /* ERROS */
         IF RETURN-VALUE = "NOK" THEN DO:
            FOR FIRST tt_log_erro:
               CREATE tt-erro.
               ASSIGN tt-erro.mensagem = tt_log_erro.ttv_des_msg_erro
                      tt-erro.cd-erro  = tt_log_erro.ttv_num_cod_erro.
            END.
            IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
               DELETE OBJECT h_api_cta_ctbl.
               ASSIGN h_api_cta_ctbl = ?.
            END.
            RETURN 'NOK':U.
         END.
         IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
            DELETE OBJECT h_api_cta_ctbl.
            ASSIGN h_api_cta_ctbl = ?.
         END.
         
         ASSIGN tt-rep-prod.qt-reporte      = _RetornaValDeci('qt-reporte')
                tt-rep-prod.qt-refugo       = _RetornaValDeci('qt-refugo')
                tt-rep-prod.qt-apr-cond     = _RetornaValDeci('qt-apr-cond')
                tt-rep-prod.ct-refugo       = c-ct-refugo
                tt-rep-prod.sc-refugo       = c-sc-refugo.
         
         CREATE tt-ref-ordem.
         ASSIGN tt-ref-ordem.tipo-rejeicao = 1
                tt-ref-ordem.codigo-rejei  = tt-prog-bc.codigo-rejei
                tt-ref-ordem.qt-refugo     = _RetornaValDeci('qt-refugo')
                tt-ref-ordem.observacao    = "".
      END.
      WHEN 3 THEN DO:
         ASSIGN tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
         
         CREATE tt-ref-ordem.
         ASSIGN tt-ref-ordem.tipo-rejeicao = 1
                tt-ref-ordem.codigo-rejei  = tt-prog-bc.codigo-rejei
                tt-ref-ordem.qt-refugo     = _RetornaValDeci('qt-refugo')
                tt-ref-ordem.observacao    = "".
      END.
   END.

   RUN cpp/cpapi009.p (INPUT-OUTPUT TABLE tt-rep-prod,
                       INPUT TABLE tt-serie,
                       INPUT TABLE tt-ref-ordem,
                       INPUT-OUTPUT TABLE tt-erro,
                       OUTPUT TABLE tt-relatorio,
                       INPUT YES).
   
   IF RETURN-VALUE = "NOK":U THEN DO:
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 27611,
                        INPUT "").
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 27611
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      UNDO, RETURN "NOK":U.
   END.
   ELSE DO:
      FOR EACH tt-epc
          WHERE tt-epc.cod-event = "Apos-cdapi009-OK":U:
         DELETE tt-epc.
      END.
      FIND FIRST tt-rep-prod NO-LOCK NO-ERROR.
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Apos-cdapi009-OK":U
             tt-epc.cod-parameter = "Nr-Reporte":U
             tt-epc.val-parameter = STRING(tt-rep-prod.nr-reporte).
      
      {include/i-epc201.i "Apos-cdapi009-OK"}.
      
      FOR EACH tt-epc
          WHERE tt-epc.cod-event = "Apos-cdapi009-OK":U:
         DELETE tt-epc.
      END.   
   END.
END.
