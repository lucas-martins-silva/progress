/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025E1 2.00.00.020 } /*** "010020" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025e1 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2007 - Luciano Leonhardt                           **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                 **
**                                                                                         **
********************************************************************************************/
DEFINE INPUT PARAMETER pcodestab          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcodlocal          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pTpTarefa          AS INTEGER              NO-UNDO. 
DEFINE INPUT PARAMETER pTpMovto           AS INTEGER              NO-UNDO. /* Entrada/Saida */
DEFINE INPUT PARAMETER pTpRegistro        AS INTEGER              NO-UNDO. /* Manual ou Automatico */
DEFINE INPUT PARAMETER hbc9025n           AS HANDLE               NO-UNDO.
DEFINE OUTPUT PARAMETER pRetorno-bc9025e1 AS LOGICAL   INITIAL NO NO-UNDO. 

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9025
&global-define TempTable ttWork
/* Definicao da temp-table de integracao ---                */
{bcp/bc9025n.i}
{utp/utapi009.i}

DEFINE VARIABLE iIdBox              AS INTEGER                    NO-UNDO.
DEFINE VARIABLE dQtdIdBox           AS DECIMAL                    NO-UNDO.
DEFINE VARIABLE iNumSeqSaida        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE cNum-Serial         AS CHARACTER FORMAT "x(14)"   NO-UNDO.
DEFINE VARIABLE tgSerial            AS LOGICAL   INITIAL NO       NO-UNDO.
DEFINE VARIABLE wgbosc074           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE cEndereco           AS CHARACTER FORMAT 'x(15)':U NO-UNDO.
DEFINE VARIABLE cCod-Refer          AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE cCod-Item           AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE vCod-Item           AS CHARACTER FORMAT 'x(14)':U NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
            FIELD id-box-dest     LIKE wm-box-saldo.id-box
            FIELD num-serial      AS CHARACTER FORMAT 'x(14)':U      LABEL 'Item'
            FIELD num-lidos       AS INTEGER.

/* Variaveis de trabalho ---                                */
DEFINE  QUERY qry-wm-box-movto FOR tt-transfEntrada.

DEFINE BROWSE brw-wm-box-movto 
        QUERY qry-wm-box-movto NO-LOCK
      DISPLAY tt-transfEntrada.ind-tipo-movto
              tt-transfEntrada.des-local 
              tt-transfEntrada.num-docto
              tt-transfEntrada.id-docto
         WITH NO-BOX No-labels SIZE 20 BY 3.5 NO-SCROLLBAR-VERTICAL.

/* Definicao dos objetos ativos ---                         */
&global-define ActiveObject1 wgbosc074
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
{bcp/bc9015.i3}  /* def variaveis padroes */

/* Propriedades globais para frames ---                     */
&global-define FrameSize            20 By 8
&GLOBAL-DEFINE FrameSizeError       20 BY 8
&GLOBAL-DEFINE ErrorDisplaySeconds  1000
&GLOBAL-DEFINE UsingBcTransfilho    YES

/************************************************************/


/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame04 ---                             */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Dados de Entrada'                                 At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'It:'                                              AT ROW 06 COL 01          ~
                             vCod-item                                          AT ROW 06 COL 04 No-label ~
                             'Box:'                                             AT ROW 07 COL 01          ~
                             iIdBox                                             AT ROW 07 COL 09 No-label ~
                             'Qtd:'                                             AT ROW 08 COL 01          ~
                             dQtdIdBox                                          AT ROW 08 COL 09 No-label
&global-define Frame01Repeat No
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Armazendo Item'                                   AT ROW 01  COL 01           ~
                             cEndereco                                          AT ROW 02  COL 01 NO-LABEL  ~
                             'It:'                                              AT ROW 03  COL 01           ~
                             cCod-item                                          AT ROW 03  COL 05 NO-LABEL  ~
                             'Ref:'                                             AT ROW 04  COL 01           ~
                             cCod-Refer                                         AT ROW 04  COL 05 NO-LABEL  ~
                             'Ser:'                                             AT ROW 05  COL 01           ~
                             cNum-Serial                                        AT ROW 05  COL 05 VIEW-AS FILL-IN SIZE 15 BY .88 NO-LABEL ~
                             'Sair   = 999999'                                  AT ROW 08  COL 01
&global-define Frame02Repeat No

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-wm-box-movto
&global-define Update02Fields cNum-Serial
/************************************************************/
/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogFinaliza = YES THEN do:  LEAVE _frame01. END.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                         ~
    ON 'value-changed':U OF brw-wm-box-movto DO:                                    ~
       ASSIGN   iIdBox     :SCREEN-VALUE IN FRAME {&frame01name} = String(tt-transfEntrada.id-box)    ~
                vCod-Item  :SCREEN-VALUE IN FRAME {&Frame01Name} = String(tt-transfEntrada.cod-item)    ~
                dQtdIdBox  :SCREEN-VALUE IN FRAME {&Frame01Name} = String(tt-transfEntrada.qtd-item)        ~
                iNumSeqSaida                                     = tt-transfEntrada.num-seq.                ~
    END.                                                                            ~
    ON 'F2':U OF brw-wm-box-movto IN FRAME {&Frame01Name} DO:                       ~
        APPLY 'RETURN':U TO THIS-PROCEDURE.                                         ~
            Return No-apply.                                                        ~
    END.                                                                            ~
    On 'Return':U OF brw-wm-box-movto IN FRAME {&Frame01Name} DO:                   ~
        If tt-transfEntrada.num-seq <> 999                                          ~
        Then Do:                                                                    ~
            Assign iNumSeqSaida = tt-transfEntrada.num-seq.                         ~
            APPLY 'GO':U TO THIS-PROCEDURE.                                         ~
        End.                                                                        ~
    End.

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                             **
***************************************************************************************************/
RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   ASSIGN pRetorno-bc9025e1 = NO.
   RUN getTarefas IN hbc9025n (INPUT pcodestab,
                               INPUT pcodlocal,
                               INPUT 5, /*Tarefas em Processo*/
                               INPUT pTpMovto,
                               OUTPUT TABLE tt-transfEntrada).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Problemas ao consultar as tarefas. (DC)"}
      RETURN ERROR.
   END.
   IF vLogerro THEN
      RETURN ERROR.

   RUN getTTAgrupadores IN hbc9025n (OUTPUT TABLE tt-agrupadores).
   FIND FIRST tt-agrupadores NO-LOCK NO-ERROR.

   OPEN QUERY qry-wm-box-movto
     FOR EACH tt-transfEntrada NO-LOCK
           BY tt-transfEntrada.num-seq
           BY tt-transfEntrada.des-local.

   APPLY 'VALUE-CHANGED':U TO brw-wm-box-movto IN FRAME {&Frame01Name}.

   EMPTY TEMP-TABLE ttSerial.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:

   ASSIGN cCod-Item = tt-transfEntrada.cod-item
          cEndereco = tt-transfEntrada.des-local.
   
   DISPLAY cEndereco
           cCod-Item
           cCod-Refer
      WITH FRAME {&Frame02Name}.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   DEFINE VARIABLE cTransacao     AS CHARACTER          NO-UNDO.
   DEFINE VARIABLE v-detalhe      LIKE bc-trans.detalhe NO-UNDO.
   DEFINE VARIABLE iSeq           AS INTEGER            NO-UNDO.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO
          cTransacao   = "WMOUT001":U.

   EMPTY TEMP-TABLE tt-erro.

   IF cNum-Serial = "999999":U THEN DO:
      ASSIGN vLogFinaliza      = YES
             pRetorno-bc9025e1 = YES.      
      HIDE ALL.
   END.
   ELSE DO:
      RUN addSerial (INPUT tt-transfEntrada.id-box,
                     INPUT cNum-Serial,
                     INPUT tt-transfEntrada.cod-item,
                     INPUT tt-transfEntrada.id-movto,
                     INPUT tt-transfEntrada.ind-tipo-movto,
                     INPUT tt-transfEntrada.qtd-item,
                     INPUT-OUTPUT TABLE tt-erro).
   
      IF RETURN-VALUE <> "OK":U THEN DO:
         RUN showError.
         RETURN ERROR.
      END.
      
      EMPTY TEMP-TABLE tt-trans-filho.
      ASSIGN v-detalhe = 'NewTra-':U +
                         'Eqp:':U + TRIM(tt-agrupadores.cod-eqpto)   + ';':U +
                         'Col:':U + TRIM(tt-agrupadores.cod-coletor) + ';':U +
                         'Est:':U + TRIM(tt-agrupadores.cod-estabel) + ';':U +
                         'Loc:':U + TRIM(tt-agrupadores.cod-local).
      
      ASSIGN iSeq = 0.
      FOR EACH ttSerial:
         ASSIGN iSeq = iSeq + 1.
         CREATE tt-trans-filho.
         ASSIGN tt-trans-filho.i-sequen-pai = 1
                tt-trans-filho.i-sequen     = iSeq
                tt-trans-filho.num-versao   = 1
                tt-trans-filho.cod-versao-integracao = 1
                tt-trans-filho.conteudo-xml = 'TpMv:':U + TRIM(STRING(ttSerial.ind-tipo-movto))   + ';':U +
                                              'IdBx:':U + TRIM(STRING(ttSerial.id-box))           + ';':U +
                                              'IdMv:':U + TRIM(STRING(ttSerial.id-movto))         + ';':U +
                                              'CdIt:':U + TRIM(STRING(ttSerial.cod-item))         + ';':U +
                                              'CEst:':U + TRIM(STRING(ttSerial.cod-estabel))      + ';':U +
                                              'CLoc:':U + TRIM(STRING(ttSerial.cod-local))        + ';':U +
                                              'CEqt:':U + TRIM(STRING(ttSerial.cod-eqpto))        + ';':U +
                                              'CCol:':U + TRIM(STRING(ttSerial.cod-coletor))      + ';':U +
                                              'QtIt:':U + TRIM(STRING(ttSerial.qtd-item))         + ';':U +
                                              'DtTr:':U + TRIM(STRING(ttSerial.data))             + ';':U +
                                              'HrTr:':U + TRIM(STRING(ttSerial.hora))             + ';':U +
                                              'NmSr:':U + TRIM(STRING(ttSerial.num-serial))       + ';':U.
      END.
      RUN _GenerateDCTransaction (INPUT cTransacao,                   /* Codigo da Transacao                   */
                                  INPUT vConteudoRaw,                 /* Conteudo da temp-table {&TempTable}   */
                                  INPUT v-detalhe,                    /* Cabecalho de detalhes da transacao    */
                                  INPUT tt-agrupadores.cod-usuario).  /* Usuario responsavel pela transacao    */
      
      ASSIGN tgSerial = YES.
   END.
   RETURN "OK":U.
END PROCEDURE.


/****************************************************************************
 * Objetivo: acumular serial para retirada                                  *
 ****************************************************************************/
PROCEDURE addSerial:
   DEFINE INPUT PARAMETER deNum-Box     AS DECIMAL      NO-UNDO.
   DEFINE INPUT PARAMETER deNum-Serial  AS DECIMAL      NO-UNDO.
   DEFINE INPUT PARAMETER pCodItem      AS CHARACTER    NO-UNDO.
   DEFINE INPUT PARAMETER pIdMovto      AS INTEGER      NO-UNDO.
   DEFINE INPUT PARAMETER pTpMovto      AS INTEGER      NO-UNDO.
   DEFINE INPUT PARAMETER deQtdLida     AS DECIMAL      NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

   EMPTY TEMP-TABLE ttWm-info-etiqueta.

   RUN getInfoEtiqueta IN wgbosc074(INPUT deNum-Serial,
                                    OUTPUT TABLE ttWm-info-etiqueta).

   FIND FIRST ttWm-info-etiqueta NO-ERROR.
   IF AVAIL ttWm-info-etiqueta THEN DO:
      /* 1-N∆o Agrupa, 2-Agrupador Etiqueta, 3-Agrupador Proprio */
      IF ttWm-info-etiqueta.ind-sit-agrupador = 1 THEN DO:
         RUN addError(INPUT 303,
                      INPUT "Etiqueta deve ser do tipo Agrupadora. (WMS)",
                      INPUT-OUTPUT TABLE tt-erro).
         RETURN "NOK":U.
      END.
   END.
   ELSE DO:
      RUN addError(INPUT 304, 
                   INPUT "Etiqueta Inexistente. (WMS)",
                   INPUT-OUTPUT TABLE tt-erro).
      RETURN "NOK":U.
   END.

   FOR FIRST wm-box-movto
       WHERE wm-box-movto.cod-estabel = tt-agrupadores.cod-estabel
         AND wm-box-movto.cod-local   = tt-agrupadores.cod-local  
         AND wm-box-movto.id-movto    = pIdMovto NO-LOCK:
   END.
   
   IF wm-box-movto.log-junta-embal = YES THEN DO:
      FIND FIRST wm-box-saldo-etiqueta
           WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-movto.cod-estabel
             AND wm-box-saldo-etiqueta.cod-local   = wm-box-movto.cod-local 
             AND wm-box-saldo-etiqueta.id-etiqueta = deNum-Serial
             AND wm-box-saldo-etiqueta.id-box      = deNum-Box NO-LOCK NO-ERROR.
      IF NOT AVAIL wm-box-saldo-etiqueta THEN DO:
         RUN addError(INPUT 305, 
                      INPUT "Etiqueta: " + STRING(deNum-Serial) + " n∆o pertence ao endereáo  " + STRING(deNum-Box) + "(DC)",
                      INPUT-OUTPUT TABLE tt-erro).
         RETURN "NOK":U.
      END.
   END.
   
   /* se n∆o junta embalagem, a etiqueta deve ter sido lida na retirada */
   IF NOT wm-box-movto.log-junta-embal THEN DO:
      FOR FIRST wms-docto-item-etiq
          WHERE wms-docto-item-etiq.cod-estabel  = wm-box-movto.cod-estabel  
            AND wms-docto-item-etiq.cod-local    = wm-box-movto.cod-local    
            AND wms-docto-item-etiq.id-docto     = wm-box-movto.id-docto      
            AND wms-docto-item-etiq.num-seq-item = wm-box-movto.num-seq-item
            AND wms-docto-item-etiq.id-movto     = wm-box-movto.id-movto  
            AND wms-docto-item-etiq.id-etiqueta  = deNum-Serial NO-LOCK:
      END.
      IF NOT AVAIL wms-docto-item-etiq THEN DO:
         RUN addError(INPUT 306, 
                      INPUT "Etiqueta: " + STRING(deNum-Serial) + " n∆o foi lida na retirada do documento: " + STRING(wm-box-movto.cod-estabel) + "/" +
                                           STRING(wm-box-movto.cod-local) + "/" + STRING(wm-box-movto.id-docto) + "/Seq: " + STRING(wm-box-movto.num-seq-item) + "(DC)",
                      INPUT-OUTPUT TABLE tt-erro).
         RETURN "NOK":U.
      END.
   END.
   ELSE DO: /* junta embalagem */
      /* Se a etiqueta lida na entrada for a mesma da sa°da, significa que o movimento n∆o ser† juntado.
         Se n∆o for a mesma etiqueta, ent∆o consiste que a etiqueta destino encontra-se no endereáo destino. Caso contr†rio, gerar erro ao usu†rio. */
      FOR FIRST wms-docto-item-etiq
          WHERE wms-docto-item-etiq.cod-estabel  = wm-box-movto.cod-estabel  
            AND wms-docto-item-etiq.cod-local    = wm-box-movto.cod-local    
            AND wms-docto-item-etiq.id-docto     = wm-box-movto.id-docto      
            AND wms-docto-item-etiq.num-seq-item = wm-box-movto.num-seq-item
            AND wms-docto-item-etiq.id-movto     = wm-box-movto.id-movto  
            AND wms-docto-item-etiq.id-etiqueta  = deNum-Serial NO-LOCK:
      END.
      IF NOT AVAIL wms-docto-item-etiq THEN DO:
         IF NOT CAN-FIND(FIRST wm-box-saldo-etiqueta 
                         WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-movto.cod-estabel 
                           AND wm-box-saldo-etiqueta.cod-local   = wm-box-movto.cod-local   
                           AND wm-box-saldo-etiqueta.id-box      = deNum-Box      
                           AND wm-box-saldo-etiqueta.id-etiqueta = deNum-Serial) THEN DO:
            RUN addError (INPUT 307,
                          INPUT "Etiqueta: " + STRING(deNum-Serial) + " n∆o se encontra no endereáo destino: " + STRING(deNum-Box),
                          INPUT-OUTPUT TABLE tt-erro).
            RETURN "NOK":U.
         END.
      END.
   END.

   FIND FIRST ttSerial
        WHERE ttSerial.id-box      = deNum-Box 
          AND ttSerial.num-serial  = deNum-Serial NO-LOCK NO-ERROR.
   IF AVAIL ttSerial THEN DO:
      RUN addError(INPUT 308, 
                   INPUT "Entrada j† realizada para Endereáo/Serial informados. (DC)",
                   INPUT-OUTPUT TABLE tt-erro).
      RETURN "NOK":U.
   END.
   /* Criar registro de transferencia */
    CREATE ttSerial.
    ASSIGN ttSerial.id-box         = deNum-Box
           ttSerial.num-serial     = deNum-Serial
           ttSerial.cod-item       = pCodItem
           ttSerial.cod-estabel    = tt-agrupadores.cod-estabel
           ttSerial.cod-local      = tt-agrupadores.cod-local
           ttSerial.cod-eqpto      = tt-agrupadores.cod-eqpto 
           ttSerial.cod-coletor    = tt-agrupadores.cod-coletor
           ttSerial.cod-local      = tt-agrupadores.cod-local
           ttSerial.id-movto       = pIdMovto
           ttSerial.ind-tipo-movto = pTpMovto
           ttSerial.qtd-item       = deQtdLida
           ttSerial.data           = TODAY
           ttSerial.hora           = STRING(TIME,"HH:MM:SS").

   RETURN "OK":U.
END PROCEDURE.


/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro π tabela tt-error               *
 ****************************************************************************/

/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro π tabela tt-error               *
 ****************************************************************************/
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro π tabela tt-error               *
 ****************************************************************************/
PROCEDURE showError:
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO:
      FOR EACH tt-erro:
         {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
         ASSIGN vLogSai = YES.
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.
END PROCEDURE.
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro π tabela tt-error               *
 ****************************************************************************/
PROCEDURE addError:
   DEFINE INPUT PARAMETER iCod-Erro AS INTEGER    NO-UNDO.
   DEFINE INPUT PARAMETER cMensagem AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

   DEFINE VARIABLE iSequencia AS INTEGER NO-UNDO.

   FIND LAST tt-erro NO-ERROR.
   IF NOT AVAIL tt-erro THEN iSequencia = 1.
   ELSE ASSIGN iSequencia = tt-erro.i-sequen + 1.

   CREATE tt-erro.
   ASSIGN tt-erro.i-sequen = iSequencia
          tt-erro.cd-erro = iCod-Erro
          tt-erro.mensagem = cMensagem.

   RETURN "OK":U.
END PROCEDURE.
