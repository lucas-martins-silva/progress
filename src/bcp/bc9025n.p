/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025N 2.00.00.017 } /*** "010017" 01/04/2024 13:31:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025n MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025n.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Outubri/2007 - Flavio Casas                                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
**                                                                                         **
********************************************************************************************/
{bcp/bc9025n.i}
{bcp/bc9102.i} /* Procedure de atualizacao da transacao            */

DEFINE NEW GLOBAL SHARED VAR v_cod_usuar_corren     AS CHARACTER           NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR i-ep-codigo-usuario    LIKE empresa.ep-codigo NO-UNDO.

DEFINE BUFFER bf_ttWm-box-movto-idx FOR ttWm-box-movto-idx.

DEFINE VARIABLE h-bosc047   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bosc030   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bosc096   AS HANDLE  NO-UNDO.

PROCEDURE getTTAgrupadores:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-agrupadores.
END PROCEDURE.


/******************************************************************************
* Objetivo: validar Estabelecimento e Local do WMS                           *
******************************************************************************/
PROCEDURE validaAgrupadores:
   DEFINE INPUT PARAMETER pCod-Usuario      AS CHARACTER  NO-UNDO.
   DEFINE INPUT PARAMETER pCod-Equipamento  AS CHARACTER  NO-UNDO.
   DEFINE INPUT PARAMETER pCod-Tipo-Equip   AS CHARACTER  NO-UNDO.
   DEFINE INPUT PARAMETER pCod-Coletor      AS CHARACTER  NO-UNDO.
   DEFINE INPUT PARAMETER pCod-Estabel      AS CHARACTER  NO-UNDO.
   DEFINE INPUT PARAMETER pCod-Local        AS CHARACTER  NO-UNDO.
   
   IF NOT VALID-HANDLE(h-bosc047) THEN
      RUN scbo/bosc047.p PERSISTENT SET h-bosc047 NO-ERROR.
   RUN openQueryStatic IN h-bosc047 (INPUT "Main":U) NO-ERROR.
   
   RUN Gotokey IN h-bosc047 (INPUT pCod-estabel,
                             INPUT pCod-local).
   
   FIND FIRST tt-agrupadores NO-ERROR.
   IF NOT AVAIL tt-agrupadores THEN DO:
      CREATE tt-agrupadores.
   END.
   ASSIGN tt-agrupadores.cod-usuario       = pCod-Usuario
          tt-agrupadores.Cod-Tipo-Equip    = pCod-Tipo-Equip
          tt-agrupadores.cod-eqpto         = pCod-Equipamento
          tt-agrupadores.cod-coletor       = pCod-Coletor
          tt-agrupadores.cod-estabel       = pCod-Estabel
          tt-agrupadores.cod-local         = pCod-Local.
   
   IF VALID-HANDLE(h-bosc047) THEN
      DELETE OBJECT h-bosc047 NO-ERROR.
      
   RETURN RETURN-VALUE.
END PROCEDURE.

/******************************************************************************
* Objetivo: Busca tarefas
******************************************************************************/
PROCEDURE getTarefas:
   DEFINE INPUT  PARAMETER pcodestab        AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER pcodlocal        AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER pTipo-Tarefa     AS INTEGER    NO-UNDO.
   DEFINE INPUT  PARAMETER pTipo-Movto      AS INTEGER    NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-tarefasES.

   DEFINE VARIABLE iCod-Tarefa          AS INTEGER INIT 3 NO-UNDO.
   DEFINE VARIABLE vNumSeq              AS INTEGER        NO-UNDO.
   DEFINE VARIABLE vNumCont             AS INTEGER        NO-UNDO.
   DEFINE VARIABLE tgTarefaEntrada      AS LOGICAL        NO-UNDO.
   DEFINE VARIABLE r-tarefa-docto-itens AS ROWID          NO-UNDO.
   
   EMPTY TEMP-TABLE tt-tarefasES.
   EMPTY TEMP-TABLE ttWm-box-movto-idx.

   FIND FIRST tt-agrupadores NO-ERROR.
   IF NOT VALID-HANDLE(h-bosc096) THEN
      RUN scbo/bosc096.p PERSISTENT SET h-bosc096 NO-ERROR.
   RUN openQueryStatic IN h-bosc096 (INPUT "Main":U) NO-ERROR.
   

   /* Busca Tarefas*/
   CASE pTipo-Tarefa:
      WHEN 1 THEN DO:
         RUN getMovtosTarefasAbertas IN h-bosc096 (INPUT pcodestab,
                                                   INPUT pcodlocal,
                                                   INPUT 2,  /* FO 1.902.463 */
                                                   INPUT iCod-Tarefa,
                                                   INPUT "", 
                                                   OUTPUT TABLE ttWm-box-movto-idx).
      END.
      WHEN 2 THEN DO:
         RUN getMovtoTarefasUsuario IN h-bosc096 (INPUT tt-agrupadores.cod-usuario,
                                                  INPUT tt-agrupadores.cod-eqpto,
                                                  INPUT tt-agrupadores.Cod-Tipo-Equip,
                                                  INPUT iCod-Tarefa,           
                                                  INPUT NO,
                                                  INPUT YES,
                                                  OUTPUT TABLE ttWm-box-movto-idx).
      END.
      WHEN 3 THEN DO:
         RUN getMovtoTarefasEquip IN h-bosc096 (INPUT "",
                                                INPUT tt-agrupadores.cod-eqpto,
                                                INPUT tt-agrupadores.Cod-Tipo-Equip,
                                                INPUT iCod-Tarefa,           
                                                INPUT NO,
                                                INPUT YES,
                                                OUTPUT TABLE ttWm-box-movto-idx).
      END. 
      WHEN 4 THEN DO:
         RUN getMovtoTarefasIniciadas IN h-bosc096 (INPUT tt-agrupadores.cod-usuario,
                                                    INPUT tt-agrupadores.cod-eqpto,
                                                    INPUT tt-agrupadores.Cod-Tipo-Equip,
                                                    INPUT iCod-Tarefa,           
                                                    INPUT NO,
                                                    INPUT YES,
                                                    OUTPUT TABLE ttWm-box-movto-idx).
      END.  
      WHEN 5 THEN DO:
         RUN getMovtosTarefasProcesso IN h-bosc096 (INPUT tt-agrupadores.Cod-Tipo-Equip,
                                                    INPUT iCod-Tarefa,
                                                    INPUT tt-agrupadores.cod-usuario,
                                                    OUTPUT TABLE ttWm-box-movto-idx).
      END. 
      WHEN 6 THEN DO:
          RUN wmp/wm9042.p (INPUT tt-agrupadores.cod-usuario,
                            INPUT tt-agrupadores.cod-eqpto,
                            INPUT "",
                            INPUT "",
                            INPUT ?,
                            OUTPUT r-tarefa-docto-itens).

          RUN getMovtoTarefasUsuarioConvoc IN h-bosc096 (INPUT r-tarefa-docto-itens,
                                                         INPUT tt-agrupadores.cod-eqpto,
                                                         INPUT NO,
                                                         INPUT YES,
                                                         OUTPUT TABLE ttWm-box-movto-idx).
      END.
   END CASE.
   IF VALID-HANDLE(h-bosc096) THEN
      DELETE OBJECT h-bosc096 NO-ERROR.

   ASSIGN vNumSeq         = 0
          tgTarefaEntrada = YES.
   
   IF NOT VALID-HANDLE(h-bosc030) THEN
      RUN scbo/bosc030.p PERSISTENT SET h-bosc030 NO-ERROR.
   RUN openQueryStatic IN h-bosc030 (INPUT "Main":U) NO-ERROR.
   
   FOR EACH ttWm-box-movto-idx
      WHERE ttWm-box-movto-idx.ind-tipo-movto = pTipo-Movto:
      /* Pegar Informacoes Box */
      RUN setConstraintBoxes IN h-bosc030 (INPUT ttWm-box-movto-idx.cod-estabel,
                                           INPUT ttWm-box-movto-idx.cod-local,
                                           INPUT ttWm-box-movto-idx.id-box,
                                           INPUT ttWm-box-movto-idx.id-box).
      RUN openQueryStatic IN h-bosc030 (INPUT 'Boxes':U).
      RUN getBatchRecords IN h-bosc030 (INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT vNumCont,
                                        OUTPUT TABLE ttWm-box).
      
      IF pTipo-Movto = 1 THEN DO: /* Entrada */      
         /* Somente apresenta as entradas que j† foram concluidas ou est∆o em processo */
         FIND FIRST bf_ttWm-box-movto-idx
              WHERE bf_ttWm-box-movto-idx.cod-estabel    = ttWm-box-movto-idx.cod-estabel
                AND bf_ttWm-box-movto-idx.cod-local      = ttWm-box-movto-idx.cod-local
                AND bf_ttWm-box-movto-idx.id-movto       = ttWm-box-movto-idx.id-movto      
                AND bf_ttWm-box-movto-idx.ind-tipo-movto = 2 NO-LOCK NO-ERROR. /*Saida*/
         IF NOT AVAIL bf_ttWm-box-movto-idx THEN 
            ASSIGN tgTarefaEntrada = NO.
         
         IF bf_ttWm-box-movto-idx.ind-status-movto = 1 THEN /*N∆o Iniciado*/         
            ASSIGN tgTarefaEntrada = NO.
      END.
      ELSE DO:
         ASSIGN tgTarefaEntrada = YES.
      END.
   
      IF tgTarefaEntrada = YES THEN DO:
         FIND FIRST ttwm-box NO-ERROR.
         IF NOT AVAIL ttwm-box THEN
            NEXT.
         
         ASSIGN vNumSeq = vNumSeq + 1.
         CREATE tt-tarefasES.
         ASSIGN tt-tarefasES.num-seq    = vNumSeq
                tt-tarefasES.cod-bloco  = ttwm-box.cod-bloco
                tt-tarefasES.cod-rua    = ttwm-box.cod-rua
                tt-tarefasES.cod-nivel  = ttwm-box.cod-nivel
                tt-tarefasES.cod-coluna = ttwm-box.cod-coluna
                tt-tarefasES.des-local  = ttwm-box.cod-bloco    + '/':U +
                                          ttwm-box.cod-rua      + '/':U +
                                          ttwm-box.cod-nivel    + '/':U +
                                          ttwm-box.cod-coluna   + '/':U +
                                          IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
                                                     .
         /* Verificar BO do WMS que retorne esta informaá∆o */
         FIND FIRST wm-docto
              WHERE wm-docto.id-docto = ttWm-box-movto-idx.id-docto NO-LOCK NO-ERROR.
         
         ASSIGN tt-tarefasES.rowid-box-movto = ROWID(ttWm-box-movto-idx)
                tt-tarefasES.num-docto       = IF AVAIL wm-docto THEN wm-docto.num-docto ELSE ""
                tt-tarefasES.cod-item        = ttWm-box-movto-idx.cod-item
                tt-tarefasES.cod-refer       = ttWm-box-movto-idx.cod-refer
                tt-tarefasES.qtd-item        = ttWm-box-movto-idx.qtd-item
                tt-tarefasES.id-box          = ttWm-box-movto-idx.id-box
                tt-tarefasES.cod-estabel     = ttWm-box-movto-idx.cod-estabel
                tt-tarefasES.cod-local       = ttWm-box-movto-idx.cod-local
                tt-tarefasES.id-movto        = ttWm-box-movto-idx.id-movto
                tt-tarefasES.id-docto        = ttWm-box-movto-idx.id-docto
                tt-tarefasES.ind-tipo-movto  = ttWm-box-movto-idx.ind-tipo-movto   /*{scinc/i01sc032.i 02} 1-ENTRADA, 2-SAIDA*/
                tt-tarefasES.num-seq-item    = ttWm-box-movto-idx.num-seq-item.
         
         IF ttWm-box-movto-idx.log-pend-ressup AND pTipo-Tarefa = 4 THEN
            ASSIGN tt-tarefasES.des-local = tt-tarefasES.des-local + '  R'.
      END.
   END.
   IF VALID-HANDLE(h-bosc030) THEN
      DELETE OBJECT h-bosc030 NO-ERROR.
   
   FIND FIRST tt-tarefasES NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-tarefasES THEN DO:
      CREATE tt-tarefasES.
      ASSIGN tt-tarefasES.num-seq   = 999
             tt-tarefasES.des-local = 'N∆o existem tarefas (WMS)':U.
   END.
   RETURN 'OK':U.
END PROCEDURE.
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro Ö tabela tt-error               *
 ****************************************************************************/
PROCEDURE addError:
   DEFINE INPUT PARAMETER iCod-Erro AS INTEGER    NO-UNDO.
   DEFINE INPUT PARAMETER cMensagem AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

   DEFINE VARIABLE iSequencia AS INTEGER NO-UNDO.

   FIND LAST tt-erro NO-ERROR.
   IF NOT AVAIL tt-erro THEN
      ASSIGN iSequencia = 1.
   ELSE
      ASSIGN iSequencia = tt-erro.i-sequen + 1.

   CREATE tt-erro.
   ASSIGN tt-erro.i-sequen = iSequencia
          tt-erro.cd-erro = iCod-Erro
          tt-erro.mensagem = cMensagem.

   RETURN "OK":U.
END PROCEDURE.
