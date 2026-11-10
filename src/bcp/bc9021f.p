/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9021F 2.00.00.014 } /*** "010014" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9021f MBC}
&ENDIF


{include/i_dbinst.i}  /* versao das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9021f.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - janeiro/2003 - karla Klemke - Cria‡Æo do programa           **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Devolu‡Æo Picking WMS            **
**                                                                                         **
********************************************************************************************/
&SCOPED-DEFINE Versao-Integracao 1
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc9021.i} 
{include/i_dbtype.i}
{include/i_dbvers.i}

DEF VAR i-cont-erro AS INTEGER.
DEF VAR l-erro      AS LOGICAL INIT NO.
DEF VAR i-cont      AS INTEGER NO-UNDO.
DEF VAR i-cod-erro  AS INTEGER.
DEF VAR v-seq-erro  AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt-etiq-resumo NO-UNDO
            FIELD nr-resumo        LIKE wm-docto-itens-ped-etiqueta.nr-resumo
            FIELD nr-pedcli        LIKE wm-docto-itens-ped.nr-pedcli         
            FIELD nome-abrev       LIKE wm-docto-itens-ped.nome-abrev        
            FIELD num-seq-item     LIKE wm-docto-itens-ped.num-seq-item
            FIELD num-seq-item-ped LIKE wm-docto-itens-ped.num-seq-item-ped
            FIELD id-etiqueta      LIKE wm-docto-itens-ped-etiqueta.qtd-item
            FIELD cod-item         LIKE wm-docto-itens-ped-etiqueta.cod-item
            FIELD qtd-item         LIKE wm-docto-itens-ped-etiqueta.qtd-item
            INDEX id IS PRIMARY UNIQUE nr-resumo
                                       nr-pedcli
                                       nome-abrev
                                       num-seq-item
                                       id-etiqueta.

DEFINE TEMP-TABLE tt-etiq NO-UNDO
            FIELD id-etiqueta      LIKE wm-etiqueta.id-etiqueta
            FIELD cod-item         LIKE wm-etiqueta.cod-item
            FIELD cod-refer        LIKE wm-etiqueta.cod-refer
            FIELD qtd-item         LIKE wm-etiqueta.qtd-item
            FIELD cdd-embarq       LIKE wm-pedidos.cdd-embarq
            FIELD nr-resumo        LIKE wm-pedidos.nr-resumo
            FIELD nome-abrev       LIKE wm-pedidos.nome-abrev
            FIELD nr-pedcli        LIKE wm-pedidos.nr-pedcli
            FIELD num-seq-item     LIKE wm-docto-itens-ped.num-seq-item
            FIELD num-seq-item-ped LIKE wm-docto-itens-ped.num-seq-item-ped
            FIELD item-pai         LIKE wm-item.cod-item
            INDEX id id-etiqueta.
            
DEFINE TEMP-TABLE tt-erro-aux       NO-UNDO LIKE tt-erro.
DEFINE TEMP-TABLE ttWm-Etiqueta     NO-UNDO LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttWm-Etiqueta-aux NO-UNDO LIKE wm-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

PROCEDURE pi-popula-temp-table-devolucao:
/*------------------------------------------------------------------------------
  Purpose: gera tt contendo todos os registros j  lidos que estejam em processo     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcod-estabel      LIKE tt-devolve-picking-bkp.cod-estabel.    
   DEFINE INPUT PARAMETER pcod-local        LIKE tt-devolve-picking-bkp.cod-local.
   DEFINE INPUT PARAMETER pnum-documento    LIKE tt-devolve-picking-bkp.num-documento.
   DEFINE INPUT PARAMETER pnum-docto-origem LIKE tt-devolve-picking-bkp.num-docto-origem.
   DEFINE INPUT PARAMETER pcdd-embarq       LIKE tt-devolve-picking-bkp.cdd-embarq.
   DEFINE INPUT PARAMETER pcod-usuario      LIKE tt-devolve-picking-bkp.cod-usuario.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-devolve-picking-bkp.
                                                                                            
   DEFINE VARIABLE vdetalhe       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vnum-sequencia AS INTEGER NO-UNDO.
       
   EMPTY TEMP-TABLE tt-devolve-picking-bkp.
   
   ASSIGN vdetalhe = 'Est:':U + TRIM(STRING(pcod-estabel))                            + ';':U +
                     'Loc:':U + TRIM(STRING(pcod-local))                              + ';':U + 
                     'Doc:':U + STRING(pnum-documento)                                + ';':U + 
                     'DcO:':U + TRIM(STRING(pnum-docto-origem,'>>>>>>>>>>>>>>>9':U))  + ';':U + 
                     'Emb:':U + TRIM(STRING(pcdd-embarq,'>>>>>>>>>>>>>>>9':U))        + ';':U + 
                     'Usr:':U + TRIM(pcod-usuario).
   
   ASSIGN vnum-sequencia = 0.
   
   FOR FIRST bc-trans FIELDS(bc-trans.nr-trans) USE-INDEX bctrans-06
       WHERE bc-trans.detalhe      = vdetalhe    
         AND bc-trans.estado-trans = 4 /* em processo */ 
         AND bc-trans.cd-trans     = 'WMSai004':U NO-LOCK:
            
      FOR EACH bc-trans-filho
         WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
         CREATE tt-devolve-picking-bkp.
         ASSIGN tt-devolve-picking-bkp.id-docto     =  DECIMAL(ENTRY(2,ENTRY(1, bc-trans-filho.conteudo-trans,';':U),':':U))
                tt-devolve-picking-bkp.num-seq-item =  INTEGER(ENTRY(2,ENTRY(2, bc-trans-filho.conteudo-trans,';':U),':':U))
                tt-devolve-picking-bkp.num-serial   =  DECIMAL(ENTRY(2,ENTRY(3, bc-trans-filho.conteudo-trans,';':U),':':U))
                tt-devolve-picking-bkp.cod-item     =          ENTRY(2,ENTRY(4, bc-trans-filho.conteudo-trans,';':U),':':U)
                tt-devolve-picking-bkp.cod-refer    =          ENTRY(2,ENTRY(5, bc-trans-filho.conteudo-trans,';':U),':':U) 
                tt-devolve-picking-bkp.cod-lote     =          ENTRY(2,ENTRY(6, bc-trans-filho.conteudo-trans,';':U),':':U) 
                tt-devolve-picking-bkp.qtd-item     =  DECIMAL(ENTRY(2,ENTRY(7, bc-trans-filho.conteudo-trans,';':U),':':U)) 
                tt-devolve-picking-bkp.nr-trans     =  bc-trans.nr-trans.
      END.
   END.     
   
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE pi-valida-serial:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pnum-serial   LIKE tt-devolve-picking-bkp.num-serial.
   DEFINE INPUT PARAMETER TABLE FOR tt-devolve-picking-bkp.
   
   DEFINE VARIABLE h-bosc074             AS HANDLE           NO-UNDO.
   DEFINE VARIABLE l-devolve-picking-bkp AS LOGICAL INIT YES NO-UNDO.
   
   FIND FIRST tt-devolve-picking-bkp
        WHERE tt-devolve-picking-bkp.num-serial = pnum-serial NO-LOCK NO-ERROR.
   IF AVAIL tt-devolve-picking-bkp THEN
      ASSIGN l-devolve-picking-bkp = NO.

   IF NOT VALID-HANDLE(h-bosc074)  THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET h-bosc074.
      RUN openQueryStatic IN h-bosc074 (INPUT "Main":U) NO-ERROR.
   END.
   RUN emptyRowErrors IN h-bosc074.
  
   IF l-devolve-picking-bkp THEN DO: 
      /* valida se o tipo serial, neste ponto o serial jÿ foi validado pela BOSC120 */
      RUN getInfoEtiqueta IN h-bosc074 (INPUT pnum-serial,
                                        OUTPUT TABLE ttwm-etiqueta).
      FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
      RUN emptyRowErrors IN h-bosc074.
      IF AVAIL ttwm-etiqueta THEN DO:
         RUN getInfoAgrupador IN h-bosc074 (INPUT pnum-serial,
                                            OUTPUT TABLE  ttwm-etiqueta-aux).
         FOR EACH ttwm-etiqueta-aux:
            FIND FIRST tt-devolve-picking-bkp
                 WHERE tt-devolve-picking-bkp.num-serial = ttwm-etiqueta-aux.id-etiqueta NO-LOCK NO-ERROR.
            /* indica que algum serial do agrupador ja foi lido */
            IF AVAIL tt-devolve-picking-bkp THEN DO:
               ASSIGN l-devolve-picking-bkp = NO.
               LEAVE.
            END.
         END. 
      END.
   END.
   IF VALID-HANDLE (h-bosc074) THEN
      DELETE OBJECT h-bosc074.
         
   IF NOT l-devolve-picking-bkp THEN
      RETURN 'NOK':U.
      
   RETURN 'OK':U.  
END PROCEDURE.

PROCEDURE pi-valida-item:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pnum-serial   LIKE tt-devolve-picking-bkp.num-serial.
   DEFINE INPUT PARAMETER pcod-item     LIKE tt-devolve-picking-bkp.cod-item.
   DEFINE INPUT PARAMETER pcod-refer    LIKE tt-devolve-picking-bkp.cod-refer.
   DEFINE INPUT PARAMETER pcod-lote     LIKE tt-devolve-picking-bkp.cod-lote.
   DEFINE INPUT PARAMETER TABLE FOR tt-devolve-picking-bkp.
   
   FIND FIRST tt-devolve-picking-bkp
        WHERE tt-devolve-picking-bkp.num-serial = pnum-serial
          AND tt-devolve-picking-bkp.cod-item   = pcod-item
          AND tt-devolve-picking-bkp.cod-refer  = pcod-refer
          AND tt-devolve-picking-bkp.cod-lote   = pcod-lote NO-LOCK NO-ERROR.
   
   IF AVAIL tt-devolve-picking-bkp THEN
      RETURN 'NOK':U.
   
   RETURN 'OK':U.    
END PROCEDURE.


PROCEDURE devolucao-picking-pre-api:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.
   
   /* altera‡Æo do estado da transa‡Æo para  Nova */
   EMPTY TEMP-TABLE tt-erro.

   FOR EACH tt-trans:
      IF tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN DO:
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 3941,
                           INPUT "").
         
         CREATE tt-erro.
         ASSIGN i-cont-erro      = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 3941
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.

      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN i-cont-erro      = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 56
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF (tt-trans.detalhe = ? OR tt-trans.detalhe = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans detalhe 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
        
         CREATE tt-erro.
         ASSIGN i-cont-erro      = i-cont-erro + 1.
         ASSIGN tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans usuario 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN i-cont-erro      = i-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = i-cont-erro
               tt-erro.cd-erro  = 5793
               tt-erro.mensagem = RETURN-VALUE
               l-erro           = YES.
      END.
    
      IF l-erro THEN
         UNDO, NEXT.
    
      DO TRANSACTION:
         FIND FIRST bc-trans USE-INDEX bctrans-06
              WHERE bc-trans.estado-trans = 4 
                AND bc-trans.cd-trans     = 'WMSai004':U         
                AND bc-trans.detalhe      = tt-trans.detalhe NO-LOCK NO-ERROR. 

         IF NOT AVAILABLE bc-trans  THEN DO:
            FIND FIRST bc-trans USE-INDEX bctrans-06
                 WHERE bc-trans.estado-trans <> 4 
                   AND bc-trans.cd-trans = 'WMSai004':U          
                   AND bc-trans.detalhe = tt-trans.detalhe NO-LOCK NO-ERROR.
         END.
         IF NOT AVAILABLE bc-trans THEN DO:
            CREATE tt-erro.
            ASSIGN i-cont-erro = i-cont-erro + 1.
            
            {utp/ut-liter.i "Inexistente" *}
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = tt-trans.detalhe + " " + RETURN-VALUE.
         END.
         ELSE DO:
            ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
            
            IF bc-trans.estado-trans  = 4 THEN DO:
               FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
               ASSIGN bc-trans.estado-trans = 1. 
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 28198,
                                   INPUT TRIM(RETURN-VALUE)).
                
                CREATE tt-erro.
                ASSIGN i-cont-erro      = i-cont-erro + 1.
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 27812
                       tt-erro.mensagem = RETURN-VALUE
                       l-erro           = YES.
            END.
         END.
      END.
      IF l-erro THEN
         UNDO, NEXT.
      
      DO TRANSACTION:
         FIND FIRST bc-trans
              WHERE bc-trans.nr-trans = tt-trans.nr-trans EXCLUSIVE-LOCK NO-ERROR. /* klemke */
         IF AVAIL bc-trans
            AND bc-trans.estado-trans   = 1             /* estado da transa‡Æo = 1-Nova  log-1 = yes (atualiza-on-line) */
            AND (bc-tipo-trans.atualiza-on-line = YES
             OR bc-tipo-trans.imp-apos-trans    = YES) THEN DO:
            
            EMPTY TEMP-TABLE tt-erro-aux.

            /* execucao da pre-api */  
            erro:
            DO ON ERROR  UNDO erro, LEAVE erro
               ON QUIT   UNDO erro, LEAVE erro
               ON STOP   UNDO erro, LEAVE erro
               ON ENDKEY UNDO erro, LEAVE erro:
               
               IF NOT tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transa‡Æo Movimento */
                  AND bc-tipo-trans.atualiza-on-line THEN DO:
                  IF bc-tipo-trans.api-atualizacao <> "" THEN DO:
                     RUN VALUE(bc-tipo-trans.api-atualizacao) (INPUT tt-trans.nr-trans,
                                                               INPUT tt-trans.conteudo-trans,
                                                               INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
                     ASSIGN bc-trans.estado-trans     = 2
                            bc-trans.data-atualizacao = TODAY
                            bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS").
                       
                  END.
                  ELSE DO:
                     RUN utp/ut-msgs.p(INPUT "MSG":U,
                                       INPUT 4,
                                       INPUT RETURN-VALUE).
   
                      CREATE tt-erro.
                      ASSIGN i-cont-erro      = i-cont-erro + 1.
                      ASSIGN tt-erro.i-sequen = i-cont-erro
                             tt-erro.cd-erro  = 4
                             tt-erro.mensagem = RETURN-VALUE.
                  END.
               END.
           
               IF tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transa‡Æo Etiqueta */
                  AND bc-tipo-trans.imp-apos-trans THEN DO:
                  IF bc-tipo-trans.prog-etiq <> "" THEN DO:
                     RUN VALUE(bc-tipo-trans.prog-etiq) (INPUT tt-trans.nr-trans,
                                                         INPUT tt-trans.conteudo-trans,
                                                         INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
   
                       
                     ASSIGN bc-trans.estado-trans     = 2
                            bc-trans.data-atualizacao = TODAY
                            bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS").
                       
                  END.
                  ELSE DO:
                     RUN utp/ut-msgs.p(INPUT "MSG":u,
                                       INPUT 4,
                                       INPUT RETURN-VALUE).
                     CREATE tt-erro.
                     ASSIGN i-cont-erro      = i-cont-erro + 1.
                     ASSIGN tt-erro.i-sequen = i-cont-erro
                            tt-erro.cd-erro  = 4
                            tt-erro.mensagem = RETURN-VALUE.
                  END.
               END.
            END.
       
            IF ERROR-STATUS:ERROR OR ( ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
               DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES 
                  WHILE(ERROR-STATUS:GET-MESSAGE(i-cont) <> ""):
                   
                  ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).
               
                  RUN utp/ut-msgs.p(INPUT "MSG":U,
                                    INPUT 15837,
                                    INPUT (IF NOT bc-trans.log-1 THEN bc-tipo-trans.api-atualizacao ELSE bc-tipo-trans.prog-etiq)).
   
                  CREATE tt-erro.
                  ASSIGN i-cont-erro      = i-cont-erro + 1
                         tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = 15837
                         tt-erro.mensagem = TRIM(RETURN-VALUE). 
                     
                  {utp/ut-liter.i Transa‡Æo * L}       
                  ASSIGN tt-erro.mensagem = tt-erro.mensagem      
                                            + " " + TRIM(RETURN-VALUE)       
                                            + " (" 
                                            + bc-trans.cd-trans
                                            + ")".
                  {utp/ut-liter.i Erro_Progress * L}                                   
                  ASSIGN tt-erro.mensagem = tt-erro.mensagem      
                                            + " - " + TRIM(RETURN-VALUE)       
                                            + " (" 
                                            + STRING(i-cod-erro)
                                            + ")".
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
       
               ASSIGN bc-trans.estado-trans     = 3
                      bc-trans.data-atualizacao = ?
                      bc-trans.hora-atualizacao = "".
            END.
         END.
      END.
   END.

   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE pi-atualiza-etiqueta:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcod-estabel LIKE tt-devolve-picking-bkp.cod-estabel.    
   DEFINE INPUT PARAMETER pcod-local   LIKE tt-devolve-picking-bkp.cod-local.
   DEFINE INPUT PARAMETER pcdd-embarq  LIKE tt-devolve-picking-bkp.cdd-embarq.
   DEFINE INPUT PARAMETER pnum-serial  LIKE tt-etiq.id-etiqueta.
   DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-etiq.

   DEFINE BUFFER b-tt-etiq FOR tt-etiq.

   DEFINE VARIABLE h-bosc074 AS HANDLE NO-UNDO.
   DEFINE VARIABLE h-bosc099 AS HANDLE NO-UNDO.
   
   IF NOT VALID-HANDLE(h-bosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET h-bosc074.
      RUN openQueryStatic IN h-bosc074 (INPUT "Main":U) NO-ERROR.
   END.
   IF NOT VALID-HANDLE(h-bosc099) THEN DO:
      RUN scbo/bosc099.p PERSISTENT SET h-bosc099.
      RUN openQueryStatic IN h-bosc099 (INPUT "Main":U) NO-ERROR.
   END.     
   RUN emptyRowErrors IN h-bosc074.
   /* valida se o tipo serial, neste ponto o serial jÿ foi validado pela BOSC120 */
   RUN getInfoEtiqueta IN h-bosc074 (INPUT pnum-serial,
                                     OUTPUT TABLE ttwm-etiqueta).
   
   RUN emptyRowErrors IN h-bosc074.
   
   FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
   IF AVAIL ttwm-etiqueta THEN DO:
      IF ttwm-etiqueta.ind-sit-agrupador <> 3 THEN DO:
         IF ttwm-etiqueta.ind-sit-agrupador = 2 THEN DO:
            FIND FIRST tt-etiq
                 WHERE tt-etiq.id-etiqueta = pnum-serial NO-ERROR.
            IF AVAIL tt-etiq THEN DO:
               RUN getInfoAgrupador IN h-bosc074 (INPUT pnum-serial,
                                                  OUTPUT TABLE ttwm-etiqueta-aux).
               FOR EACH ttwm-etiqueta-aux:                  
                  RUN getEtiquetaResumo IN h-bosc099 (INPUT pcod-estabel,
                                                      INPUT pcod-local,
                                                      INPUT pcdd-embarq,
                                                      INPUT ttwm-etiqueta-aux.id-etiqueta,
                                                      OUTPUT TABLE tt-etiq-resumo).         
      
                  FIND FIRST tt-etiq-resumo
                       WHERE tt-etiq-resumo.id-etiqueta = ttwm-etiqueta-aux.id-etiqueta NO-LOCK NO-ERROR.                       
                  IF AVAIL tt-etiq-resumo THEN DO:
                     FIND FIRST b-tt-etiq
                          WHERE b-tt-etiq.nr-resumo        = tt-etiq-resumo.nr-resumo   
                            AND b-tt-etiq.nome-abrev       = tt-etiq-resumo.nome-abrev  
                            AND b-tt-etiq.nr-pedcli        = tt-etiq-resumo.nr-pedcli
                            AND b-tt-etiq.num-seq-item     = tt-etiq-resumo.num-seq-item   
                            AND b-tt-etiq.num-seq-item-ped = tt-etiq-resumo.num-seq-item-ped
                            AND b-tt-etiq.id-etiqueta      = tt-etiq-resumo.id-etiqueta 
                            AND b-tt-etiq.cod-item         = tt-etiq-resumo.cod-item NO-ERROR.                    
                     IF NOT AVAIL b-tt-etiq THEN DO:
                        CREATE tt-etiq.
                        ASSIGN tt-etiq.id-etiqueta      = ttwm-etiqueta-aux.id-etiqueta
                               tt-etiq.nr-resumo        = tt-etiq-resumo.nr-resumo
                               tt-etiq.nr-pedcli        = tt-etiq-resumo.nr-pedcli
                               tt-etiq.nome-abrev       = tt-etiq-resumo.nome-abrev
                               tt-etiq.num-seq-item     = tt-etiq-resumo.num-seq-item
                               tt-etiq.num-seq-item-ped = tt-etiq-resumo.num-seq-item-ped
                               tt-etiq.qtd-item = tt-etiq-resumo.qtd-item.
                               
                        RUN getCharField IN h-bosc074(INPUT 'cod-refer':U,
                                                      OUTPUT tt-etiq.cod-refer).
                        
                        RUN getCharField IN h-bosc074(INPUT 'cod-item':U,
                                                      OUTPUT tt-etiq.cod-item).                            
                     END.
                  END.                       
               END.
            END.
         END.
         ELSE DO:
            RUN getEtiquetaResumo IN h-bosc099 (INPUT pcod-estabel,
                                                INPUT pcod-local,
                                                INPUT pcdd-embarq,
                                                INPUT ttwm-etiqueta.id-agrupador,
                                                OUTPUT TABLE tt-etiq-resumo).         
            FIND FIRST tt-etiq-resumo NO-ERROR.
            IF AVAIL tt-etiq-resumo THEN DO:
               RUN getInfoAgrupador IN h-bosc074 (INPUT ttwm-etiqueta.id-agrupador,
                                                  OUTPUT TABLE ttwm-etiqueta-aux).

               FIND FIRST tt-etiq
                    WHERE tt-etiq.id-etiqueta = ttwm-etiqueta.id-agrupador NO-ERROR.
               IF AVAIL tt-etiq THEN DO:
                  ASSIGN tt-etiq.qtd-item = 0.
                  FOR EACH ttwm-etiqueta-aux,
                     FIRST b-tt-etiq
                     WHERE b-tt-etiq.id-etiqueta = ttwm-etiqueta-aux.id-etiqueta:
                        
                     ASSIGN tt-etiq.qtd-item = tt-etiq.qtd-item + b-tt-etiq.qtd-item.
                  END.
               END.    
            END.                
         END.
      END.   
   END.
   IF VALID-HANDLE (h-bosc074) THEN
      DELETE OBJECT h-bosc074.

   IF VALID-HANDLE (h-bosc099) THEN
      DELETE OBJECT h-bosc099.
   
   RETURN 'OK':U.
END PROCEDURE.
