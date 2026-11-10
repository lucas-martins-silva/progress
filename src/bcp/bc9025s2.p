/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025S2 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9025s1 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

&if '{&mgscm_version}' >= '2.04' &then
DEFINE INPUT  PARAMETER pTpMovto    AS INTEGER     NO-UNDO. /*Entrada/Saida*/
DEFINE INPUT  PARAMETER pTpRegistro AS INTEGER     NO-UNDO. /*Manual ou Automatico*/
DEFINE OUTPUT PARAMETER pLogEsc     AS LOGICAL     NO-UNDO.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9025
&global-define TempTable ttWork

/* Definicao da temp-table de integracao ---                */
{bcp/bc9025n.i}
{utp/utapi009.i}

Define New Global Shared Variable hbc9025n As HANDLE              NO-UNDO.

DEFINE VARIABLE iTpRetirada         AS INTEGER   FORMAT '9':U     NO-UNDO.
DEFINE VARIABLE iIdBox              AS INTEGER                    NO-UNDO.
DEFINE VARIABLE dQtdIdBox           AS DECIMAL                    NO-UNDO.
DEFINE VARIABLE iNumSeqSaida        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE cNum-Serial         AS CHARACTER FORMAT "x(16)"   NO-UNDO.
DEFINE VARIABLE tgSerial            AS LOGICAL   INITIAL NO       NO-UNDO.
DEFINE VARIABLE wgbosc074           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc098           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc079           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc092           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE l-esc               AS LOGICAL                    NO-UNDO.

DEFINE VARIABLE cEndereco           AS CHARACTER FORMAT 'x(15)':U NO-UNDO.
DEFINE VARIABLE cCod-Refer          AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE cCod-Item           AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE vCod-Item           AS CHARACTER FORMAT 'x(14)':U NO-UNDO.

DEFINE VARIABLE dQtdSaldoTotal      AS DECIMAL                    NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
            FIELD id-box-dest     LIKE wm-box-saldo.id-box
            FIELD num-serial      AS CHARACTER FORMAT 'x(16)':U      LABEL 'Item'
            FIELD num-lidos       AS INTEGER.
/************************************************************/
/* Variaveis de trabalho ---                                */
DEFINE  QUERY qry-wm-box-movto FOR tt-transfSaida.

DEFINE BROWSE brw-wm-box-movto 
        QUERY qry-wm-box-movto NO-LOCK
      DISPLAY tt-transfSaida.ind-tipo-movto
              tt-transfSaida.des-local 
              tt-transfSaida.num-docto
              tt-transfSaida.id-docto
              WITH NO-BOX No-labels SIZE 20 BY 3.5 NO-SCROLLBAR-VERTICAL.

/* Definicao dos objetos ativos ---                         */
&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc092
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
&global-define Frame01Defs   'Dados de Saida'                                   At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'It:'                                              AT ROW 06 COL 01          ~
                             vCod-item                                          AT ROW 06 COL 04 No-label ~
                             'Box:'                                             AT ROW 07 COL 01          ~
                             iIdBox                                             AT ROW 07 COL 09 No-label ~
                             'Qtd:'                                             AT ROW 08 COL 01          ~
                             dQtdIdBox                                          AT ROW 08 COL 09 No-label
&global-define Frame01Repeat No

&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Retirar Item'                                     AT ROW 01  COL 01           ~
                             cEndereco                                          AT ROW 02  COL 01 NO-LABEL  ~
                             'It:'                                              AT ROW 03  COL 01           ~
                             cCod-item                                          AT ROW 03  COL 05 NO-LABEL  ~
                             'Ref:'                                             AT ROW 04  COL 01           ~
                             cCod-Refer                                         AT ROW 04  COL 05 NO-LABEL  ~
                             'Ser:'                                             AT ROW 05  COL 01           ~
                             cNum-Serial                                        AT ROW 05  COL 05 VIEW-AS FILL-IN SIZE 15 BY .88 NO-LABEL ~
                             'Entrada= 888888'                                  AT ROW 07  COL 01 ~
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
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogFinaliza = YES THEN do:          ~
                                                                Return return-value.  ~
                                                            End.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                         ~
    ON 'value-changed':U OF brw-wm-box-movto DO:                                                    ~
       ASSIGN   iIdBox     :SCREEN-VALUE IN FRAME Frame01 = String(tt-transfSaida.id-box)           ~
                vCod-Item  :SCREEN-VALUE IN FRAME {&Frame01Name} = String(tt-transfSaida.cod-item)  ~
                dQtdIdBox  :SCREEN-VALUE IN FRAME {&Frame01Name} = String(tt-transfSaida.qtd-item)  ~
                iNumSeqSaida                                     = tt-transfSaida.num-seq.          ~
    END.                                                                                            ~
    ON 'F2':U OF brw-wm-box-movto IN FRAME {&Frame01Name} DO:                                       ~
        APPLY 'RETURN':U TO THIS-PROCEDURE.                                                         ~
            Return No-apply.                                                                        ~
    END.                                                                                            ~
    ON 'Return':U OF brw-wm-box-movto IN FRAME {&Frame01Name} DO:                                   ~
        If tt-transfSaida.num-seq <> 999                                                            ~
        Then Do:                                                                                    ~
            Assign iNumSeqSaida = tt-transfSaida.num-seq.                                           ~
            APPLY 'GO':U TO THIS-PROCEDURE.                                                         ~
        End.                                                                                        ~
    END.                                                                                            ~
    ON 'ESC':U OF FRAME {&Frame01Name}                                                              ~
    DO:                                                                                             ~
        ASSIGN pLogEsc = YES.                                                                       ~
    END.                                                                                            ~
    ON 'ESC':U OF FRAME {&Frame02Name}                                                              ~
    DO:                                                                                             ~
        ASSIGN pLogEsc = YES.                                                                       ~
    END.

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                             **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

PROCEDURE InicializaCamposFrame01:

   IF NOT VALID-HANDLE(hbc9025n) THEN DO:
      RUN bcp/bc9025n.p PERSISTENT SET hbc9025n.
   END.

   Run getTTAgrupadores In hbc9025n (  Output Table tt-agrupadores).
   Find First tt-agrupadores No-lock No-error.

   RUN getTarefas IN hbc9025n (INPUT tt-agrupadores.cod-estabel,
                               INPUT tt-agrupadores.cod-local,
                               INPUT  6, /*Tarefas em Processo*/
                               INPUT  pTpMovto,
                               OUTPUT TABLE tt-transfSaida).

   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Problemas ao consultar as tarefas. (DC)"}
      RETURN ERROR.
   END.
   IF vLogerro THEN RETURN ERROR.

   OPEN QUERY qry-wm-box-movto
     FOR EACH tt-transfSaida NO-LOCK
           BY tt-transfSaida.num-seq
           BY tt-transfSaida.des-local.

   APPLY 'value-changed':U TO brw-wm-box-movto IN FRAME {&Frame01Name}.

END PROCEDURE.

PROCEDURE GravaCamposFrame01:
    End Procedure.

    PROCEDURE InicializaCamposFrame02:

    Assign  cCod-Item = tt-transfSaida.cod-item
            cEndereco = tt-transfSaida.des-local.
    DISPLAY cEndereco
            cCod-Item
            cCod-Refer
                WITH FRAME {&Frame02Name}.

END PROCEDURE.

PROCEDURE GravaCamposFrame02:
    DEFINE VARIABLE cTransacao     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v-detalhe      LIKE bc-trans.detalhe NO-UNDO.
    DEFINE VARIABLE iSeq           AS INTEGER    NO-UNDO.

    ASSIGN vLogErro     = NO
           vLogSai      = NO
           vLogFinaliza = No
           cTransacao   = "WMOUT001":U.

    For Each tt-erro:
         Delete tt-erro.
    End.

    ASSIGN dQtdSaldoTotal = tt-transfSaida.qtd-item.

     /* 888888-Foi digitado todas as saidas agora ‚ processado as entradas */
     IF  cNum-Serial = "888888" THEN DO:
         IF tgSerial = YES THEN DO:
             RUN bcp/bc9025e2.p (INPUT  1, /* Entrada */
                                 INPUT  1, /* Autom tico */
                                 OUTPUT l-esc).
             IF  RETURN-VALUE <> "OK":U THEN DO:
                 RUN showError.
                 RETURN ERROR.
             END.
         END.
         ELSE DO:
             {bcp/bc9105.i "101" "Para selecionar 'Entrada' ‚ necess rio informar um serial. (DC)"}
         END.
     END.
     ELSE DO:
         IF  cNum-Serial = "999999" THEN DO:
             ASSIGN vLogFinaliza = YES.
             HIDE ALL.
         END.
         ELSE DO:
             RUN addSerial (INPUT tt-transfSaida.id-box,
                            INPUT cNum-Serial,
                            INPUT tt-transfSaida.cod-item,
                            INPUT tt-transfSaida.id-movto,
                            INPUT tt-transfSaida.ind-tipo-movto,
                            INPUT tt-transfSaida.qtd-item,
                            INPUT-OUTPUT TABLE tt-erro).

            IF  RETURN-VALUE <> "OK" THEN DO:
                RUN showError.
                RETURN ERROR.
            END.

             FOR EACH tt-trans-filho:
                DELETE tt-trans-filho.
             END.
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
     END.

     ASSIGN vLogFinaliza = YES
            vLogSai      = YES.

     RETURN "OK".
END PROCEDURE.


/****************************************************************************
 * Objetivo: acumular serial para retirada                                  *
 ****************************************************************************/
PROCEDURE addSerial:
   Define Input Parameter deNum-Box     AS DECIMAL      NO-UNDO.
   Define Input Parameter deNum-Serial  AS DECIMAL      NO-UNDO.
   Define Input Parameter pCodItem      As Character    NO-UNDO.
   Define Input Parameter pIdMovto      AS Integer      NO-UNDO.
   Define Input Parameter pTpMovto      AS Integer      NO-UNDO.
   Define Input Parameter deQtdLida     AS DECIMAL      NO-UNDO.
   Define Input-output Parameter Table For tt-erro.

    For Each ttWm-info-etiqueta:
        Delete ttWm-info-etiqueta.
    End.

    If Not Valid-handle(wgbosc074) Then Do:
        Run scbo/bosc074.p Persistent Set wgbosc074       No-error.
        Run openQueryStatic IN wgbosc074 (Input "Main":U) No-error.
    End.
    Run getInfoEtiqueta IN wgbosc074 (Input deNum-Serial,
                                      Output Table ttWm-info-etiqueta).

    IF VALID-HANDLE(wgbosc074) THEN RUN destroy IN wgbosc074.

   FIND FIRST ttWm-info-etiqueta NO-ERROR.
   IF AVAIL ttWm-info-etiqueta THEN DO:

          /*1-NÆo Agrupa, 2-Agrupador Etiqueta, 3-Agrupador Proprio*/
          IF ttWm-info-etiqueta.ind-sit-agrupador = 1
          THEN DO:
             RUN addError(Input 303,
                          Input "Etiqueta deve ser do tipo Agrupadora. (WMS)",
                          Input-output Table tt-erro).
             Return "NOK":U.
          End.
          End.
   Else Do:
      Run addError(Input 304, 
                   Input "Etiqueta Inexistente. (WMS)",
                   Input-output Table tt-erro).
      Return "NOK":U.
   End.
   
   IF NOT Valid-handle(wgbosc098)
   Then Do:
       Run scbo/bosc098.p Persistent Set wgbosc098       No-error.
       Run openQueryStatic In wgbosc098 (Input "Main":U) No-error.
   End.

   RUN goToKey IN wgbosc098 (INPUT tt-agrupadores.cod-estabel,
                             INPUT tt-agrupadores.cod-local,
                             INPUT deNum-Box,
                             INPUT deNum-Serial).

   IF VALID-HANDLE(wgbosc098) THEN RUN destroy IN wgbosc098.

   IF RETURN-VALUE <> "OK":U THEN DO:
      RUN addError(INPUT 306, 
                   INPUT "Etiqueta Inexistente no Box informado. (WMS)",
                   INPUT-OUTPUT TABLE tt-erro).
      RETURN "NOK":U.
   END.

       IF  ttwm-info-etiqueta.qtd-item - ttwm-info-etiqueta.qtd-item-retirado > dQtdSaldoTotal THEN DO:
           RUN addError(INPUT 307, 
                        INPUT "Saldo da etiqueta ‚ maior do que o solicitado no movimento de transferˆncia. (WMS)",
                        INPUT-OUTPUT TABLE tt-erro).
           RETURN "NOK":U.
       END.
       
   FIND FIRST ttSerial
        WHERE ttSerial.id-box      = deNum-Box 
          AND ttSerial.num-serial  = deNum-Serial
       No-lock NO-ERROR.
   IF AVAIL ttSerial
   THEN DO:
      RUN addError(INPUT 305, 
                   INPUT "Sa¡da j  realizada para Endere‡o/Serial informados. (DC)",
                   INPUT-OUTPUT TABLE tt-erro).
      RETURN "NOK":U.
   END.
   /* Criar registro de transferencia */
    CREATE  ttSerial.
    ASSIGN  ttSerial.id-box         = deNum-Box
            ttSerial.num-serial     = deNum-Serial
            ttSerial.cod-item       = pCodItem
            ttSerial.cod-estabel    = tt-agrupadores.cod-estabel
            ttSerial.cod-local      = tt-agrupadores.cod-local
            ttSerial.cod-eqpto      = tt-agrupadores.cod-eqpto 
            ttSerial.cod-coletor    = tt-agrupadores.cod-coletor
            ttSerial.cod-local      = tt-agrupadores.cod-local
            ttSerial.id-movto       = pIdMovto
            ttSerial.ind-tipo-movto = pTpMovto
            ttSerial.qtd-item       = dQtdSaldoTotal
            ttSerial.data           = Today
            ttSerial.hora           = String(Time,"HH:MM:SS").
   RETURN "OK":U.
END PROCEDURE.



/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro … tabela tt-error               *
 ****************************************************************************/

/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro … tabela tt-error               *
 ****************************************************************************/
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro … tabela tt-error               *
 ****************************************************************************/
PROCEDURE showError:
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO:
      FOR EACH tt-erro:
         {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
         ASSIGN vLogSai = YES.
      END.
      IF vLogErro = YES THEN RETURN ERROR.
   END.
END PROCEDURE.
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro … tabela tt-error               *
 ****************************************************************************/
PROCEDURE addError:
   DEFINE INPUT PARAMETER iCod-Erro AS INTEGER    NO-UNDO.
   DEFINE INPUT PARAMETER cMensagem AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

   DEFINE VARIABLE iSequencia AS INTEGER NO-UNDO.

   Find LAST tt-erro NO-ERROR.
   IF NOT AVAIL tt-erro THEN iSequencia = 1.
   ELSE ASSIGN iSequencia = tt-erro.i-sequen + 1.

   CREATE tt-erro.
   ASSIGN tt-erro.i-sequen = iSequencia
          tt-erro.cd-erro = iCod-Erro
          tt-erro.mensagem = cMensagem.

   RETURN "OK":U.
END PROCEDURE.
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
