/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033F 2.00.00.007 } /*** "010007" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033f MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9033f.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho/2006 - Bravo                                          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking / Packing WMS - Fun‡äes  **
**                                                                                         **
********************************************************************************************/
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{include/i_dbtype.i}
{include/i_dbvers.i}

&global-define TempTable tt-picking-wms

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

{bcp/bc9033.i   " "}
{bcp/bc9033.i1 "New"}

PROCEDURE pi-inicializa-tt-picking-wms-table:            
   DEFINE INPUT PARAMETER pcod-estabel     LIKE tt-picking-wms.cod-estabel    NO-UNDO.
   DEFINE INPUT PARAMETER pcod-local       LIKE tt-picking-wms.cod-local      NO-UNDO.
   DEFINE INPUT PARAMETER pid-movto        LIKE Wm-box-movto.id-movto         NO-UNDO.
   DEFINE INPUT PARAMETER pind-tipo-movto  LIKE wm-box-movto.ind-tipo-movto   NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-picking-wms-table.
   
   DEFINE VARIABLE v-detalhe LIKE bc-trans.detalhe NO-UNDO.
   
   EMPTY TEMP-TABLE tt-picking-wms-table.
   
   ASSIGN v-detalhe = 'Est:':U  + TRIM(pcod-estabel) + ';':U +
                      'Loc:':U  + TRIM(pcod-local)   + ';':U +
                      'IMo:':U  + TRIM(STRING(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                      'ITM:':U  + TRIM(STRING(pind-tipo-movto, '>9':U)).
   
   FIND FIRST bc-trans USE-INDEX bctrans-06
        WHERE bc-trans.detalhe      = v-detalhe  
          AND bc-trans.estado-trans = 4 
          AND (bc-trans.cd-trans    = 'WMSai009':U) NO-LOCK NO-ERROR.
   IF AVAIL bc-trans THEN DO:
      FOR EACH bc-trans-filho
         WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
         CREATE tt-picking-wms-table.
         ASSIGN tt-picking-wms-table.num-serial        = DECIMAL(ENTRY(2, ENTRY(6,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.id-docto          = DECIMAL(ENTRY(2, ENTRY(5,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.id-movto          = DECIMAL(ENTRY(2, ENTRY(3,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.num-seq-item      = INTEGER(ENTRY(2, ENTRY(7,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.ind-tipo-movto    = INTEGER(ENTRY(2, ENTRY(4,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.qtd-item          = DECIMAL(ENTRY(2, ENTRY(8,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.qtd-item-digit    = DECIMAL(ENTRY(2, ENTRY(9,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.cod-item          = TRIM(ENTRY(2, ENTRY(10,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.num-box-lido      = DECIMAL(ENTRY(2, ENTRY(11,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.cod-embalagem     = TRIM(ENTRY(2, ENTRY(12,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.qtd-embalagem     = INTEGER(ENTRY(2, ENTRY(13,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.dat-atualizacao   = DATE(ENTRY(2, ENTRY(14,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.dat-transacao     = DATE(ENTRY(2, ENTRY(15,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.num-tempo-inicio  = DECIMAL(ENTRY(2, ENTRY(16,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.cod-coletor       = TRIM(ENTRY(2, ENTRY(17,bc-trans-filho.conteudo-trans,';'),':':U))
                tt-picking-wms-table.cod-equipamento   = TRIM(ENTRY(2, ENTRY(18,bc-trans-filho.conteudo-trans,';'),':':U)).
      END.
   END.
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE pi-cria-tt-picking-ems-table:
   DEFINE INPUT PARAMETER pcod-estabel      LIKE tt-picking-wms.cod-estabel        NO-UNDO.
   DEFINE INPUT PARAMETER pcod-local        LIKE tt-picking-wms.cod-local          NO-UNDO.
   DEFINE INPUT PARAMETER pid-movto         LIKE Wm-box-movto.id-movto             NO-UNDO.
   DEFINE INPUT PARAMETER pind-tipo-movto   LIKE wm-box-movto.ind-tipo-movto       NO-UNDO.
   DEFINE INPUT PARAMETER pid-docto         LIKE wm-box-movto.id-docto             NO-UNDO.
   DEFINE INPUT PARAMETER pnum-serial       LIKE tt-picking-wms.num-serial         NO-UNDO.
   DEFINE INPUT PARAMETER pnum-seq-item     LIKE tt-picking-wms.num-seq-item       NO-UNDO.
   DEFINE INPUT PARAMETER pnum-itens-serial LIKE tt-picking-wms.qtd-item           NO-UNDO.
   DEFINE INPUT PARAMETER pnum-itens-digit  LIKE tt-picking-wms.qtd-item-digit     NO-UNDO.
   DEFINE INPUT PARAMETER pcod-item         LIKE tt-picking-wms.cod-item           NO-UNDO.
   DEFINE INPUT PARAMETER pnum-box-lido     LIKE tt-picking-wms.num-box-lido       NO-UNDO.
   DEFINE INPUT PARAMETER pcod-embalagem    LIKE tt-picking-wms.cod-embalagem      NO-UNDO.
   DEFINE INPUT PARAMETER pqti-embalagem    LIKE tt-picking-wms.qtd-embalagem      NO-UNDO.
   DEFINE INPUT PARAMETER pdat-atualizacao  LIKE tt-picking-wms.dat-atualizacao    NO-UNDO.
   DEFINE INPUT PARAMETER pdat-transacao    LIKE tt-picking-wms.dat-transacao      NO-UNDO.
   DEFINE INPUT PARAMETER pnum-tempo-inicio AS DECIMAL   FORMAT '>>>>>>>>>>>>>9':U NO-UNDO.
   DEFINE INPUT PARAMETER pcod-coletor      AS CHARACTER FORMAT 'x(14)':U          NO-UNDO.
   DEFINE INPUT PARAMETER pcod-equipamento  AS CHARACTER FORMAT 'x(14)':U          NO-UNDO.
   DEFINE INPUT PARAMETER pcod-lote         LIKE tt-picking-wms.cod-lote           NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table                          .
   DEFINE OUTPUT PARAM TABLE FOR tt-erro                                                 .
       
   DEFINE VARIABLE v-detalhe  LIKE bc-trans.detalhe NO-UNDO.
   DEFINE VARIABLE wgbcapi001 AS HANDLE             NO-UNDO.
   
   ASSIGN v-detalhe = 'Est:':U  + TRIM(pcod-estabel) + ';':U +
                      'Loc:':U  + TRIM(pcod-local)   + ';':U +
                      'IMo:':U  + TRIM(STRING(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                      'ITM:':U  + TRIM(STRING(pind-tipo-movto, '>9':U)).
   
   /* cria‡ao da bc-trans */
   EMPTY TEMP-TABLE tt-trans.
   EMPTY TEMP-TABLE tt-trans-filho.
   EMPTY TEMP-TABLE tt-erro.

   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMSai009':U
          tt-trans.detalhe = v-detalhe.
          tt-trans.usuario = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.
   
   CREATE tt-trans-filho.
   ASSIGN tt-trans-filho.i-sequen-pai = 1
          tt-trans-filho.i-sequen     = 1    
          tt-trans-filho.num-versao   = 1
          tt-trans-filho.conteudo-xml = 'Est:':U  + TRIM(pcod-estabel)                                 + ';':U +
                                        'Loc:':U  + TRIM(pcod-local)                                   + ';':U +
                                        'IMo:':U  + TRIM(STRING(pid-movto,'>>>>>>>>>9':U))             + ';':U + 
                                        'ITM:':U  + TRIM(STRING(pind-tipo-movto, '>9':U))              + ';':U +
                                        'IDo:':U  + TRIM(STRING(pid-docto, '>>>>>>>>>9':U))            + ';':U + 
                                        'Ser:':U  + TRIM(STRING(pnum-serial, '>>>>>>>>>>>>>>':U))      + ';':U + 
                                        'SIt:':U  + TRIM(STRING(pnum-seq-item, '>>>>9':U))             + ';':U + 
                                        'Qtd:':U  + TRIM(STRING(pnum-itens-serial,'>>>>>>>>9.9999':U)) + ';':U +
                                        'QtI:':U  + TRIM(STRING(pnum-itens-digit,'>>>>>>>>9.9999':U))  + ';':U +
                                        'Ite:':U  + TRIM(pcod-item)                                    + ';':U +
                                        'Box:':U  + TRIM(STRING(pnum-box-lido,'>>>>>>>>>9':U))         + ';':U +     
                                        'Emb:':U  + TRIM(pcod-embalagem)                               + ';':U +     
                                        'QEm:':U  + TRIM(STRING(pqti-embalagem, '>>>>>>>>9':U))        + ';':U .
    
   /* caso tenha o conteudo nulo... ira passar nulo p todo atributo conteudo-xml */
   IF pdat-atualizacao =  ? THEN
      ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +  'DtA:':U  + '?':U + ';':U.
   
   IF pdat-atualizacao <> ? THEN
      ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +  'DtA:':U  + TRIM(STRING(pdat-atualizacao)) + ';':U.
   
   ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +
                                        'DtT:':U  + TRIM(STRING(pdat-transacao))                      + ';':U +
                                        'Tem:':U  + TRIM(STRING(pnum-tempo-inicio, '>>>>>>>>>>>>>9')) + ';':U +
                                        'Col:':U  + TRIM(pcod-coletor)                                + ';':U +
                                        'Eqp:':U  + TRIM(pcod-equipamento)                            + ';':U +
                                        'Lot:':U  + TRIM(pcod-lote).
   
   IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
      RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001(INPUT-OUTPUT TABLE tt-trans,
                                                   INPUT-OUTPUT TABLE tt-erro).
   END.
   RUN cria_reg_wms IN wgbcapi001 ( INPUT 4, /* 4 = Estado da Transacao = Em Processo */
                                    INPUT-OUTPUT TABLE tt-trans,
                                    INPUT-OUTPUT TABLE tt-trans-filho,
                                    INPUT-OUTPUT TABLE tt-erro).
   
   DELETE PROCEDURE wgbcapi001.

   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO: 
      RETURN 'NOK':U.
   END.
   
   CREATE tt-picking-wms-table.
   ASSIGN tt-picking-wms-table.num-serial       = pnum-serial
          tt-picking-wms-table.id-docto         = pid-docto
          tt-picking-wms-table.id-movto         = pid-movto
          tt-picking-wms-table.num-seq-item     = pnum-seq-item
          tt-picking-wms-table.ind-tipo-movto   = pind-tipo-movto
          tt-picking-wms-table.qtd-item         = pnum-itens-serial
          tt-picking-wms-table.qtd-item-digit   = pnum-itens-digit 
          tt-picking-wms-table.cod-item         = pcod-item
          tt-picking-wms-table.num-box-lido     = pnum-box-lido
          tt-picking-wms-table.cod-embalagem    = pcod-embalagem
          tt-picking-wms-table.qtd-embalagem    = pqti-embalagem
          tt-picking-wms-table.dat-atualizacao  = pdat-atualizacao
          tt-picking-wms-table.dat-transacao    = pdat-transacao
          tt-picking-wms-table.num-tempo-inicio = pnum-tempo-inicio
          tt-picking-wms-table.cod-coletor      = pcod-coletor
          tt-picking-wms-table.cod-equipamento  = pcod-equipamento
          tt-picking-wms-table.cod-lote         = pcod-lote.
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE pi-atualiza-qtd-digitada:
   DEFINE INPUT PARAMETER pcod-estabel      LIKE tt-picking-wms.cod-estabel    NO-UNDO.
   DEFINE INPUT PARAMETER pcod-local        LIKE tt-picking-wms.cod-local      NO-UNDO.
   DEFINE INPUT PARAMETER pid-movto         LIKE Wm-box-movto.id-movto         NO-UNDO.
   DEFINE INPUT PARAMETER pind-tipo-movto   LIKE wm-box-movto.ind-tipo-movto   NO-UNDO.
   DEFINE INPUT PARAMETER pid-docto         LIKE wm-box-movto.id-docto         NO-UNDO.
   DEFINE INPUT PARAMETER pnum-serial       LIKE tt-picking-wms.num-serial     NO-UNDO.
   DEFINE INPUT PARAMETER pnum-seq-item     LIKE tt-picking-wms.num-seq-item   NO-UNDO.
   DEFINE INPUT PARAMETER pnum-itens-serial LIKE tt-picking-wms.qtd-item       NO-UNDO.
   DEFINE INPUT PARAMETER pnum-itens-digit  LIKE tt-picking-wms.qtd-item-digit NO-UNDO.
   DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-erro                                         .
   
   DEFINE VARIABLE v-detalhe         LIKE bc-trans.detalhe              NO-UNDO.
   DEFINE VARIABLE v-conteudo-trans  AS CHARACTER                       NO-UNDO.
   DEFINE VARIABLE v-num-itens-digit LIKE tt-picking-wms.qtd-item-digit NO-UNDO.
   
   ASSIGN v-detalhe = 'Est:':U  + TRIM(pcod-estabel) + ';':U +
                      'Loc:':U  + TRIM(pcod-local)   + ';':U +
                      'IMo:':U  + TRIM(STRING(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                      'ITM:':U  + TRIM(STRING(pind-tipo-movto, '>9':U)).
   
   FIND FIRST bc-trans USE-INDEX bctrans-06
        WHERE bc-trans.detalhe  = v-detalhe    
          AND bc-trans.estado-trans = 4        
          AND bc-trans.cd-trans = 'WMSai009':U NO-LOCK NO-ERROR.   
   IF AVAIL bc-trans THEN DO:
      ASSIGN v-conteudo-trans = 
                              'Est:':U  + TRIM(pcod-estabel)                              + ';':U +
                              'Loc:':U  + TRIM(pcod-local)                                + ';':U +
                              'IMo:':U  + TRIM(STRING(pid-movto,'>>>>>>>>>9':U))          + ';':U + 
                              'ITM:':U  + TRIM(STRING(pind-tipo-movto, '>9':U))           + ';':U +
                              'IDo:':U  + TRIM(STRING(pid-docto, '>>>>>>>>>9':U))         + ';':U + 
                              'Ser:':U  + TRIM(STRING(pnum-serial, '>>>>>>>>>>>>>>':U))   + ';':U + 
                              'SIt:':U  + TRIM(STRING(pnum-seq-item, '>>>>9':U)).
      
      DO TRANSACTION:
         FIND FIRST bc-trans-filho
              WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans
                AND bc-trans-filho.conteudo-trans BEGINS v-conteudo-trans EXCLUSIVE-LOCK NO-ERROR.         
         IF AVAIL bc-trans-filho THEN DO:
            ASSIGN v-num-itens-digit = DECIMAL(ENTRY(2,ENTRY(9,bc-trans-filho.conteudo-trans,';':U),':':U)) + pnum-itens-digit.
            ASSIGN ENTRY(9,bc-trans-filho.conteudo-trans,';':U) = 'Qtd:':U  + TRIM(STRING(v-num-itens-digit, '>>>>>9.9999':U)).
         END.
         RELEASE bc-trans-filho.
      END.
   END.
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE finaliza-picking:
   DEF INPUT PARAM TABLE FOR tt-trans.
   DEF OUTPUT PARAM TABLE FOR tt-erro.
   
   DEF VAR vcontreg    AS INTEGER NO-UNDO.
   DEF VAR vcont       AS INTEGER NO-UNDO.
   DEF VAR i-cont-erro AS INTEGER NO-UNDO.
   DEF VAR l-erro      AS LOGICAL NO-UNDO.
   
   EMPTY TEMP-TABLE tt-erro.
   
   FOR EACH tt-trans:
      IF tt-trans.cod-versao-integracao <> 1 THEN DO:
         RUN utp/ut-msgs.p (INPUT "MSG":U,
                            INPUT 3941,
                            INPUT "").
         CREATE tt-erro.
         ASSIGN i-cont-erro = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 3941
                tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                l-erro = YES.
      END.
      
      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
         RUN utp/ut-msgs.p (INPUT "MSG":U,
                            INPUT 56,
                            INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN i-cont-erro = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 56
                tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                l-erro = YES.
      END.
      IF (tt-trans.detalhe = ? OR tt-trans.detalhe = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans detalhe 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN i-cont-erro = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                l-erro = YES.
      END.
      IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans usuario 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         CREATE tt-erro.
         ASSIGN i-cont-erro = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                l-erro = YES.
      END.
      
      IF l-erro = YES THEN
         UNDO, NEXT.
      
      DO TRANSACTION:
         FIND FIRST bc-trans USE-INDEX bctrans-06
              WHERE bc-trans.detalhe = tt-trans.detalhe
                AND bc-trans.estado-trans = 4         
                AND (bc-trans.cd-trans = 'WMSai009':U) NO-LOCK NO-ERROR . 
         IF NOT AVAIL bc-trans THEN DO:
            CREATE tt-erro.
            ASSIGN i-cont-erro = i-cont-erro + 1.
            
            DEFINE VARIABLE c-lbl-liter-detalhe AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Detalhe" *}
            ASSIGN c-lbl-liter-detalhe = TRIM(RETURN-VALUE).
            
            DEFINE VARIABLE c-lbl-liter-inexistente-dc AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Inexistente_(DC)" *}
            ASSIGN c-lbl-liter-inexistente-dc = TRIM(RETURN-VALUE).
            
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = c-lbl-liter-detalhe + ": " +  tt-trans.detalhe + " " + c-lbl-liter-inexistente-dc.
         END.
         ELSE DO:             
            ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
            
            IF bc-trans.estado-trans = 4 THEN DO:
               FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
               ASSIGN bc-trans.estado-trans = 1. /* 1-Nova, 2-Atualizada, 3-Com Erro */ 
               RELEASE bc-trans.
            END.
            ELSE DO:
               RUN utp/ut-msgs.p(INPUT "MSG":U,
                                 INPUT 27845,
                                 INPUT TRIM(RETURN-VALUE)).
               CREATE tt-erro.
               ASSIGN i-cont-erro = i-cont-erro + 1.
               ASSIGN tt-erro.i-sequen = i-cont-erro
                      tt-erro.cd-erro  = 27845
                      tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
               ASSIGN l-erro = YES.
            END.
         END.
      END.
      IF l-erro = YES THEN
         UNDO, NEXT.
   END.
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE picking-pre-api-wms:
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.
   
   DEF VARIABLE i-cont-erro AS INTEGER NO-UNDO.
   DEF VARIABLE i-cont      AS INTEGER NO-UNDO.
   DEF VARIABLE i-cod-erro  AS INTEGER NO-UNDO.

   FOR EACH tt-trans:
      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.                                
      
      DO TRANSACTION:
         FIND FIRST bc-trans USE-INDEX bctrans-06
              WHERE bc-trans.detalhe = tt-trans.detalhe 
                AND bc-trans.estado-trans = 1  
                AND (bc-trans.cd-trans = 'WMSai009':U) NO-LOCK NO-ERROR. 
      
         IF AVAIL bc-trans THEN DO:
            ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
         END.
         
         /* estado da transa‡Æo = 1-Nova  log-1 = yes (atualiza-on-line) */
         IF bc-trans.estado-trans = 1 AND (bc-tipo-trans.atualiza-on-line = YES OR bc-tipo-trans.imp-apos-trans = YES) THEN DO:
            EMPTY TEMP-TABLE tt-erro-aux.
         
            /* Execucao da pre-api */  
            erro:
            DO ON ERROR  UNDO erro, LEAVE erro
               ON QUIT   UNDO erro, LEAVE erro
               ON STOP   UNDO erro, LEAVE erro
               ON ENDKEY UNDO erro, LEAVE erro:
               
               /* tt-trans.etiqueta = <NO> - Gera Transa‡Æo Movimento */
               IF NOT tt-trans.etiqueta AND bc-tipo-trans.atualiza-on-line THEN DO:
                  IF bc-tipo-trans.api-atualizacao <> "" THEN DO:
                     RUN VALUE(bc-tipo-trans.api-atualizacao)( INPUT tt-trans.nr-trans,                 
                                                               INPUT tt-trans.conteudo-trans,           
                                                               INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.

                     FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
                     ASSIGN bc-trans.estado-trans     = 2
                            bc-trans.data-atualizacao = TODAY
                            bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS":U).
                     
                     RELEASE bc-trans.                      
                  END.
                  ELSE DO:
                     RUN utp/ut-msgs.p(INPUT "MSG":U,
                                       INPUT 4,
                                       INPUT RETURN-VALUE).
                     
                     CREATE tt-erro.
                     ASSIGN i-cont-erro = i-cont-erro + 1.
                     ASSIGN tt-erro.i-sequen = i-cont-erro
                            tt-erro.cd-erro  = 4
                            tt-erro.mensagem = RETURN-VALUE + "(DC)".
                  END.
               END.
               
               /* tt-trans.etiqueta = <YES> - Gera Transa‡Æo Etiqueta */
               IF tt-trans.etiqueta AND bc-tipo-trans.imp-apos-trans THEN DO:
                  IF bc-tipo-trans.prog-etiq <> "" THEN DO:
                     RUN VALUE(bc-tipo-trans.prog-etiq)( INPUT tt-trans.nr-trans,                 
                                                         INPUT tt-trans.conteudo-trans,           
                                                         INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
                              
                     
                     FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
                     ASSIGN bc-trans.estado-trans     = 2
                            bc-trans.data-atualizacao = TODAY
                            bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS":U).
                     
                     RELEASE bc-trans.
                  END.
                  ELSE DO:
                     RUN utp/ut-msgs.p(INPUT "MSG":U,
                                       INPUT 4,
                                       INPUT RETURN-VALUE).
                     CREATE tt-erro.
                     ASSIGN i-cont-erro             = i-cont-erro + 1.
                     ASSIGN tt-erro.i-sequen = i-cont-erro
                            tt-erro.cd-erro  = 4
                            tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                  END.
               END.
            END.
            
            IF ERROR-STATUS:ERROR OR (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
               DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES 
                  WHILE(ERROR-STATUS:GET-MESSAGE(i-cont) <> ""):
                   
                  ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).
                  
                  RUN utp/ut-msgs.p(INPUT "MSG":U,
                                    INPUT 15837,
                                    INPUT (IF bc-trans.log-1 = NO THEN bc-tipo-trans.api-atualizacao ELSE bc-tipo-trans.prog-etiq)).
                  
                  CREATE tt-erro.
                  ASSIGN i-cont-erro      = i-cont-erro + 1
                         tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = 15837
                         tt-erro.mensagem = TRIM(RETURN-VALUE) + "(DC)":U. 
                     
                  {utp/ut-liter.i Transa‡Æo * L}       
                  DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                  ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).

                  DEFINE VARIABLE c-lbl-liter-dc AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "DC" *}
                  ASSIGN c-lbl-liter-dc = TRIM(RETURN-VALUE).

                  ASSIGN tt-erro.mensagem  = tt-erro.mensagem  + " " + TRIM(c-lbl-liter) + " (" + bc-trans.cd-trans + ") (" + c-lbl-liter-dc + ")".

                  {utp/ut-liter.i Erro_Progress * L}                                   
                  DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
                  ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).

                  DEFINE VARIABLE c-lbl-liter-dc-2 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "DC" *}
                  ASSIGN c-lbl-liter-dc-2 = TRIM(RETURN-VALUE).

                  ASSIGN tt-erro.mensagem =  tt-erro.mensagem + " - " + TRIM(c-lbl-liter-2) + " (" + STRING(i-cod-erro) + ") (" + c-lbl-liter-dc-2 + ")".
               END.
            END.
            
            FIND FIRST tt-erro-aux NO-ERROR.
            IF AVAIL tt-erro-aux THEN DO:
               FOR EACH tt-erro-aux:
                  CREATE tt-erro.
                  ASSIGN i-cont-erro      = i-cont-erro + 1.
                  ASSIGN tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = tt-erro-aux.cd-erro
                         tt-erro.mensagem = tt-erro-aux.mensagem.
                  
                  CREATE bc-trans-erros.
                  ASSIGN i-cont-erro                 = i-cont-erro + 1
                         bc-trans-erros.nr-trans      = tt-trans.nr-trans
                         bc-trans-erros.cd-msg        = tt-erro-aux.cd-erro
                         bc-trans-erros.texto-msg     = tt-erro-aux.mensagem
                         bc-trans-erros.num-sequencial = i-cont-erro.
               END.
               
               /* Feito novamente o FIND pois, se entrar aqui, j  ter  dado o Release no registr da BC-TRANS e ele nao estara disponivel. */
               FIND FIRST bc-trans USE-INDEX bctrans-06
                    WHERE bc-trans.detalhe = tt-trans.detalhe 
                      AND bc-trans.estado-trans = 1  
                      AND (bc-trans.cd-trans = 'WMSai009':U) EXCLUSIVE-LOCK NO-ERROR.               
               IF AVAIL bc-trans THEN
                  ASSIGN bc-trans.estado-trans     = 3
                         bc-trans.data-atualizacao = ?
                         bc-trans.hora-atualizacao = "".
               
               RELEASE bc-trans.
            END.
         END.
         RELEASE bc-trans-erros.
      END.
   END.
   RETURN 'OK':U.
END PROCEDURE.
