/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI001 2.00.00.068 } /*** "010068" 09/10/2025 11:26:34 ***/
/*************************************************************************
**
**   Programa: BCAPI001 - API de criaá∆o de transacoes de coleta de dados
**
**   Parametros: tt-trans - Contem os registros que ser∆o convertidos  em
**                          transacoes de coleta de dados
**               tt-erro  - Apos a execucao da API contera  os  possiveis
**                          erros de criacao de transacoes
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (07/98)
**
***************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{bcp/bc1003.i}      /* funá∆o formataCodLayout */
{include/i_dbtype.i}
{cdp/cdcfgint.i}    /* include de definicao de versao de banco  */
{include/i-epc200.i bcapi001} /** Include UPCs **/
{btb/btbcons.i}     /* License Server */

DEF VAR lEfetivaComErro                      AS LOGICAL  INITIAL NO NO-UNDO.
DEF VAR i-cont-erro                          AS INT                 NO-UNDO.
DEF VAR c-antes-execucao-upc                 AS CHAR                NO-UNDO.
DEF VAR c-depois-execucao-upc                AS CHAR                NO-UNDO.
DEF VAR c-registros-tt-epc                   AS CHAR                NO-UNDO.

DEF NEW GLOBAL SHARED VAR gcod-programa      AS CHAR                NO-UNDO.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

/* Esta procedure pode ser executada persistente para incluir
   transaá‰es 2D. Quando o programa Ç executado persistente
   retorna sem executar nada e devem ser usadas as procedures 
   internas recebeMovimento e recebeMovimentoFilho.
   No caso das transaá‰es antigas o processo n∆o muda, ou seja,
   a api continua a ser chamada diretamente (sem persistente)
   com os dados em tt-trans */

/*DLOGWMSDTS-2509 - Caso o cliente reclame do consumo de licenÁa, o suporte ir· disponibilizar
   um "BACA" para alterar o campo livre data-2 da wm-param. ApÛs esta data, o sistema
   comeÁar· a consumir a licenÁa*/

FOR FIRST param-bc NO-LOCK:
    IF param-bc.data-1 = ? OR 
       param-bc.data-1 < TODAY THEN
        RUN lsConsumeEspec("BCAPI001", "bcp/bcapi001.p"). /*Procedure Consumo de LicenÁa*/
END.
/* FIM DLOGWMSDTS-2509 */

DEF VAR l-erro             AS LOGICAL INITIAL NO  NO-UNDO.
DEF VAR i-cont             AS INTEGER             NO-UNDO.
DEF VAR i-cod-erro         AS INTEGER             NO-UNDO.
DEF VAR v-seq-erro         AS INTEGER             NO-UNDO.
DEF VAR l-impressao-direta AS LOGICAL             NO-UNDO.
DEF VAR vLogEfetivNOK      AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR i-estado-trans     AS INTEGER INITIAL 0   NO-UNDO .
DEF VAR tgAtualiza         AS LOGICAL             NO-UNDO.
DEF VAR tgImprime          AS LOGICAL             NO-UNDO.


DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

DEF NEW GLOBAL SHARED VAR c_seg_usuario         AS CHARACTER FORMAT "x(12)"    NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren    LIKE usuar_mestre.cod_usuario  NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario   LIKE empresa.ep-codigo   NO-UNDO.

FIND FIRST param-bc NO-LOCK NO-ERROR.
IF AVAIL param-bc THEN DO:
   IF param-bc.ind-sistema = 2 THEN DO:  /* Magnus */
      ASSIGN c_seg_usuario       = (IF c_seg_usuario= "" THEN USERID("mgadm") ELSE c_seg_usuario)
             v_cod_usuar_corren  = (IF v_cod_usuar_corren = "" THEN USERID("mgadm") ELSE v_cod_usuar_corren).
   END.
END.

{utp/ut-liter.i "Antes_da_execuá∆o_do_ponto_de_UPC:" * L}
ASSIGN c-antes-execucao-upc = RETURN-VALUE.
{utp/ut-liter.i "Depois_da_execuá∆o_do_Ponto_de_UPC:" * L}
ASSIGN c-depois-execucao-upc = RETURN-VALUE.
{utp/ut-liter.i "Registros temp-table tt-epc:" * L}
ASSIGN c-registros-tt-epc = RETURN-VALUE.

IF THIS-PROCEDURE:PERSISTENT THEN
   RETURN.

RUN piCriaTransacao IN THIS-PROCEDURE( INPUT-OUTPUT TABLE tt-trans,
                                       INPUT-OUTPUT TABLE tt-erro).

RUN piFinalizaAPI IN THIS-PROCEDURE.

FIND FIRST tt-erro NO-ERROR.
IF AVAIL tt-erro THEN
   RETURN "NOK":U.
ELSE
   RETURN "OK":U.

/********************************************************************************************************************************************
*********************************************************************************************************************************************
********************************************************************************************************************************************/
PROCEDURE piCriaTransacao:
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

   ASSIGN l-impressao-direta = IF gcod-programa <> "wm9300" THEN NO ELSE YES.
   FOR EACH tt-trans:
      ASSIGN lEfetivaComErro = NO.
    
      /*** Teste da versao de integracao ***/
      IF tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN DO:
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 3941,
                           INPUT "").
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 3941
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
    
      /*** Teste do tipo de transacao ***/
      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 56
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
    
      /*** Teste do conteudo da transacao ***/
      IF tt-trans.conteudo-trans = ? THEN DO:
         {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
    
      /*** Teste do detalhe da transacao ***/
      IF (tt-trans.detalhe = ? OR tt-trans.detalhe = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans detalhe 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
    
      /*** Teste do usuario ***/
      IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans usuario 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF l-erro = YES THEN
         UNDO, NEXT.
    
      DO TRANS:
         CREATE bc-trans.
         ASSIGN bc-trans.estado-trans         = IF tt-trans.atualizada = YES THEN 2 ELSE 1
                bc-trans.cd-trans             = tt-trans.cd-trans
                bc-trans.data                 = TODAY
                bc-trans.data-atualizacao     = IF tt-trans.atualizada = YES THEN TODAY ELSE ?
                bc-trans.detalhe              = &IF "{&mgcld_dbtype}":U = "PROGRESS":U &THEN
                                                   tt-trans.detalhe
                                                &ELSE
                                                   SUBSTRING(tt-trans.detalhe,1,256)
                                                &ENDIF
                bc-trans.ep-codigo            = i-ep-codigo-usuario
                bc-trans.horario              = STRING(TIME,"HH:MM:SS")
                bc-trans.hora-atualizacao     = IF tt-trans.atualizada = YES THEN STRING(TIME,"HH:MM:SS") ELSE ""
                bc-trans.usuario              = tt-trans.usuario
                bc-trans.ind-tipo-trans       = IF tt-trans.etiqueta THEN 1 ELSE 2
                bc-trans.ind-processo         = 1. /* processo antigo */
    
    
         &IF "{&mgcld_dbtype}":U = "PROGRESS":U &THEN
            ASSIGN bc-trans.conteudo-trans = tt-trans.conteudo-trans.
         &ELSE
            ASSIGN bc-trans.conteudo-trans = STRING(tt-trans.conteudo-trans).
            IF ROWID(bc-trans) = ? THEN.
         &ENDIF
      END.
    
      ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
    
      RUN pi-zera-return-value.
      IF tt-trans.etiqueta AND bc-tipo-trans.imp-apos-trans THEN DO:
         EMPTY TEMP-TABLE tt-epc.
         
         IF c-nom-prog-upc-mg97     <> ""
            AND c-nom-prog-upc-mg97 <> ?  THEN DO:
            IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
               OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "User-Print" *}
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 TRIM(c-antes-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 "Return-value:":U RETURN-VALUE.
               IF ERROR-STATUS:ERROR THEN DO:
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Error-Status" *}
                  PUT UNFORMATTED "        (BCAPI001) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
               END.
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
               FOR EACH tt-epc:
                  PUT UNFORMATTED "        (BCAPI001) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001)_:cod-parameter" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001)_:val-parameter" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
               END.
               OUTPUT CLOSE.   
            END.
         END.
    
         {include/i-epc201.i "User-Print"}.
    
         IF c-nom-prog-upc-mg97     <> ""
            AND c-nom-prog-upc-mg97 <> ? THEN DO:
            IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
               OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "User-Print" *}
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 TRIM(c-depois-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 "Return-value:":U RETURN-VALUE.
               IF ERROR-STATUS:ERROR THEN DO:
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Error-Status" *}
                   PUT UNFORMATTED "        (BCAPI001) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
               END.
               PUT UNFORMATTED "        (BCAPI001) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
               FOR EACH tt-epc:
                  PUT UNFORMATTED "        (BCAPI001) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001)_:cod-parameter" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001)_:val-parameter" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "BCAPI001" *}
                  PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
               END.
               OUTPUT CLOSE.   
            END.
         END.
      END.
      IF l-impressao-direta
          OR (bc-trans.estado-trans = 1
         AND (bc-tipo-trans.atualiza-on-line
         OR bc-tipo-trans.imp-apos-trans)) THEN DO:
    
         EMPTY TEMP-TABLE tt-erro-aux.
         ASSIGN  vLogEfetivNOK = YES.
         
         RUN PI-ZERA-RETURN-VALUE.
         /***** execucao da pre-api ***/  
         erro:
         DO ON ERROR UNDO erro, LEAVE erro
            ON QUIT UNDO erro, LEAVE erro
            ON STOP UNDO erro, LEAVE erro
            ON ENDKEY UNDO erro, LEAVE erro:
            
            IF NOT l-impressao-direta THEN DO:
               IF NOT tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transaá∆o Movimento */
                  AND bc-tipo-trans.atualiza-on-line THEN DO:
                  
                  ASSIGN tgAtualiza = YES.
                  IF bc-tipo-trans.api-atualizacao <> "" THEN
                     RUN VALUE(bc-tipo-trans.api-atualizacao) (INPUT tt-trans.nr-trans,
                                                               INPUT tt-trans.conteudo-trans,
                                                               INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
                  ELSE DO:
                     RUN utp/ut-msgs.p(INPUT "msg":U,
                                       INPUT 4,
                                       INPUT RETURN-VALUE).
       
                     CREATE tt-erro.
                     ASSIGN tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 4
                            tt-erro.mensagem = RETURN-VALUE.
                  END.
               END.
       
               IF tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transaá∆o Etiqueta */
                  AND bc-tipo-trans.imp-apos-trans THEN DO:
                  
                  ASSIGN tgImprime = YES.
                  IF bc-tipo-trans.prog-etiq <> "" THEN DO:
                     RUN VALUE(bc-tipo-trans.prog-etiq) (INPUT tt-trans.nr-trans,
                                                         INPUT tt-trans.conteudo-trans,
                                                         INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
               END.
               ELSE DO:
                  RUN utp/ut-msgs.p(INPUT "msg":U,
                                    INPUT 4,
                                    INPUT RETURN-VALUE).
                  
                  CREATE tt-erro.
                  ASSIGN tt-erro.i-sequen = 1
                         tt-erro.cd-erro  = 4
                         tt-erro.mensagem = RETURN-VALUE.
               END.
            END.
         END.
         ELSE DO:
            ASSIGN tgImprime = YES.
            IF bc-tipo-trans.prog-etiq <> "" THEN DO:
               RUN VALUE(bc-tipo-trans.prog-etiq) (INPUT tt-trans.nr-trans,
                                                   INPUT tt-trans.conteudo-trans,
                                                   INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
            END.
            ELSE DO:
               RUN utp/ut-msgs.p(INPUT "msg":U,
                                 INPUT 4,
                                 INPUT RETURN-VALUE).
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 1
                      tt-erro.cd-erro  = 4
                      tt-erro.mensagem = RETURN-VALUE.
            END.
         END.
                   
         ASSIGN  vLogEfetivNOK = NO.
      END.
            
      IF vLogEfetivNOK /* Erro Travamento de Registro */
         OR  RETURN-VALUE = "NOK" THEN DO:
         
         FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.
         IF NOT AVAIL tt-erro-aux OR vLogEfetivNOK THEN DO:
            RUN utp/ut-msgs.p(INPUT "msg":U,
                              INPUT 27611,
                              INPUT "").
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-bcapi001 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "bcapi001" *}
            ASSIGN c-lbl-liter-bcapi001 = TRIM(RETURN-VALUE).
            
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 27611
                   tt-erro.mensagem = "*** " + c-lbl-liter-bcapi001 + ": " + TRIM(c-lbl-liter). 
         END.
      END.
    
      IF ERROR-STATUS:ERROR
          OR (ERROR-STATUS:GET-NUMBER(1) <> 138
         AND ERROR-STATUS:NUM-MESSAGES   <> 0) THEN DO:
         DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES
            WHILE(ERROR-STATUS:GET-MESSAGE(i-cont) <> ""):
               IF ERROR-STATUS:GET-NUMBER(i-cont) = 138 THEN
                  NEXT.
    
               ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).
    
               RUN utp/ut-msgs.p(INPUT "msg":U,
                                 INPUT 15837,
                                 INPUT IF bc-trans.ind-tipo-trans = 2 THEN bc-tipo-trans.api-atualizacao ELSE bc-tipo-trans.prog-etiq).
    
               CREATE tt-erro.
               ASSIGN tt-erro.cd-erro  = 15837
                      tt-erro.mensagem = TRIM(RETURN-VALUE). 
    
               {utp/ut-liter.i Transaá∆o * L}       
               ASSIGN tt-erro.mensagem  = tt-erro.mensagem      
                                          + " " + TRIM(RETURN-VALUE)       
                                          + " (" 
                                          + bc-trans.cd-trans
                                          + ")".
               
               {utp/ut-liter.i Erro_Progress * L}                                   
               ASSIGN tt-erro.mensagem  = tt-erro.mensagem      
                                          + " - " + TRIM(RETURN-VALUE)       
                                          + " (" 
                                          + STRING(i-cod-erro)
                                          + ")".
            END.
         END.
         
         FOR EACH tt-erro-aux.
            CREATE tt-erro.
            BUFFER-COPY tt-erro-aux TO tt-erro NO-ERROR.
            DELETE tt-erro-aux.
         END.
    
         ASSIGN i-cont-erro = 0.
         FOR EACH tt-erro:
            CREATE bc-trans-erros.
            ASSIGN i-cont-erro                 = i-cont-erro + 1
                   bc-trans-erros.nr-trans      = bc-trans.nr-trans
                   bc-trans-erros.cd-msg        = tt-erro.cd-erro
                   bc-trans-erros.texto-msg     = tt-erro.mensagem
                   bc-trans-erros.num-sequencial = i-cont-erro.
 
            FIND FIRST cadast_msg
                 WHERE cadast_msg.cdn_msg = tt-erro.cd-erro NO-LOCK NO-ERROR.
            IF AVAIL cadast_msg AND cadast_msg.idi_tip_msg = 1 THEN
               ASSIGN  lEfetivaComErro = YES.
         END.
         IF lEfetivaComErro THEN
            DO TRANSACTION:
               ASSIGN bc-trans.estado-trans       = 3
                      bc-trans.hora-atualizacao   = ""
                      bc-trans.data-atualizacao   = ?.
            END.
         ELSE
            IF (tt-trans.etiqueta AND tgImprime) OR (NOT tt-trans.etiqueta AND tgAtualiza) THEN DO:
               DO TRANSACTION:
                  ASSIGN bc-trans.estado-trans       = 2
                         bc-trans.hora-atualizacao   = STRING(TIME,"HH:MM:SS")
                         bc-trans.data-atualizacao   = TODAY.
               END.
            END.
    
         EMPTY TEMP-TABLE tt-epc.
    
         CREATE tt-epc.
         ASSIGN tt-epc.cod-event        = "End_Process":U
                tt-epc.cod-parameter    = "nr-trans":U
                tt-epc.val-parameter    = STRING(bc-trans.nr-trans).
         
         CREATE tt-epc.
         ASSIGN tt-epc.cod-event        = "End_Process":U
                tt-epc.cod-parameter    = "cd-trans":U
                tt-epc.val-parameter    = STRING(bc-trans.cd-trans).
    
         {include/i-epc201.i "End_Process"}.
      END.
   END.
    
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN
      RETURN "NOK":U.
   ELSE
      RETURN "OK":U.
END PROCEDURE.

/********************************************************************************************************************************************
*********************************************************************************************************************************************
********************************************************************************************************************************************/
PROCEDURE piFinalizaAPI:
   /*Faz a liberaÁ„o do consumo de licenÁa*/
   RUN FinalizaConsumoLicenca.
   RETURN "OK":U.
END PROCEDURE.

/********************************************************************************************************************************************
*********************************************************************************************************************************************
********************************************************************************************************************************************/

    /*25-inicio*/
/*
**  Atualiza transaá∆o pai: bc-trans
**  Atauliza transaá∆o filho: bc-trans-filho
**  Retorna erros em tt-erro. Valida todos os registros.
*/
PROCEDURE atualizaTransacao:
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-ext.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-filho.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

   DEF VAR v-complemento  AS CHARACTER NO-UNDO.
   DEF VAR v-programa     AS CHARACTER NO-UNDO.
   DEF VAR i-nr-trans     AS INTEGER   NO-UNDO.

   FOR EACH tt-trans TRANSACTION:
      /* controla os erros para cada transaá∆o */
      l-erro = NO.

      /*** Teste da versao de integracao ***/
      IF tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN
         RUN geraErro ( 3941,
                        "":U,
                        "":U).

      /*** Teste do tipo de transacao ***/
      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-table.i mgcld bc-tipo-trans 1}
         RUN geraErro ( 2,
                        TRIM(RETURN-VALUE) + ": ":U + tt-trans.cd-trans,
                        "":U).
      END.

      /*** Teste do detalhe da transacao ***/
      IF (tt-trans.detalhe = ? OR tt-trans.detalhe = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans detalhe 1}
         RUN geraErro ( 5793,
                        TRIM(RETURN-VALUE),
                        "":U).
      END.

      /*** Teste do usuario ***/
      IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans usuario 1}
         RUN geraErro ( 5793,
                        TRIM(RETURN-VALUE),
                        "":U).
      END.

      /* verifica se tem registros filhos */
      FIND FIRST tt-trans-filho
           WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen NO-ERROR.
      IF NOT AVAIL tt-trans-filho THEN
         RUN geraErro ( 25996,
                        tt-trans.cd-trans,
                        "":U).

      /* Criaá∆o do Movimento, somente se n∆o ocorrer erros */            
      IF l-erro = NO THEN DO:
         CREATE bc-trans.
            
         IF i-estado-trans <> 0 THEN
            ASSIGN bc-trans.estado-trans = i-estado-trans.
         ELSE
            ASSIGN bc-trans.estado-trans = IF tt-trans.atualizada = YES THEN 2 ELSE 1.
         
         ASSIGN bc-trans.cd-trans           = tt-trans.cd-trans
                bc-trans.data               = TODAY
                bc-trans.data-atualizacao   = IF tt-trans.atualizada = YES THEN TODAY ELSE ?
                bc-trans.detalhe            = tt-trans.detalhe
                bc-trans.ep-codigo          = i-ep-codigo-usuario
                bc-trans.horario            = STRING(TIME,"HH:MM:SS")
                bc-trans.hora-atualizacao   = IF tt-trans.atualizada = YES THEN STRING(TIME,"HH:MM:SS") ELSE ""
                bc-trans.usuario            = tt-trans.usuario
                bc-trans.ind-tipo-trans     = IF tt-trans.etiqueta THEN 1 ELSE 2
                bc-trans.ind-processo       = 2 /* processo novo */.

         /* Atualiza quantidade de etiquetas */
         FIND FIRST tt-trans-ext
              WHERE tt-trans-ext.i-sequen = tt-trans.i-sequen
                AND tt-trans-ext.campo    = {&EXT-Quantidade} NO-ERROR.

         ASSIGN bc-trans.qtd_etiqueta = (IF AVAIL tt-trans-ext THEN INTEGER(tt-trans-ext.valor) ELSE 1).
      END.

      FOR EACH tt-trans-filho 
         WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen:
         /* verifica vers∆o de integraá∆o */
         IF tt-trans-filho.cod-versao-integracao <> {&Versao-Integracao} THEN
            RUN geraErro ( 3941,
                           "":U,
                           "":U).

         /* verifica tipo-etiqueta */
         IF tt-trans-filho.tipo-etiq <> 0 THEN DO:
            FIND FIRST tipo-etiqueta
                 WHERE tipo-etiqueta.tipo-etiq = tt-trans-filho.tipo-etiq NO-LOCK NO-ERROR.
            IF NOT AVAIL tipo-etiqueta THEN DO:
               {utp/ut-field.i mgcld tipo-etiqueta tipo-etiq 1}
               RUN geraErro ( 56,
                              TRIM(RETURN-VALUE),
                              "":U).
            END.

            /* verifica layout/versao */
            FIND FIRST bc-layout
                 WHERE bc-layout.cod-layout  = tipo-etiqueta.cod-layout
                   AND bc-layout.log-datasul = tipo-etiqueta.log-datasul
                   AND bc-layout.num-versao  = tt-trans-filho.num-versao NO-LOCK NO-ERROR.
            IF NOT AVAIL bc-layout THEN
               RUN geraErro ( 25971,
                              formataCodLayout(tipo-etiqueta.cod-layout, tipo-etiqueta.log-datasul, tt-trans-filho.num-versao),
                              "":U).

            /* verifica num-layout-registro */
            FIND FIRST bc-layout-registro
                 WHERE bc-layout-registro.num-layout-registro = tt-trans-filho.segmento NO-LOCK NO-ERROR.
            IF NOT AVAIL bc-layout-registro THEN DO:
               {utp/ut-table.i mgcld bc-layout-registro 1}
               RUN geraErro ( 2,
                              TRIM(RETURN-VALUE),
                              ": ":U + STRING(tt-trans-filho.segmento)).
            END.
         END.

         /* verifica conteudo-xml */
         IF tt-trans-filho.conteudo-xml = ? 
            OR tt-trans-filho.conteudo-xml = "":U THEN
            RUN geraErro ( 25972,
                           STRING(tt-trans.nr-trans) + "~~":U + STRING(tt-trans-filho.i-sequen),
                           "":U).

         /* cria movimento se n∆o houve erro */
         IF l-erro = NO THEN DO:
            CREATE bc-trans-filho.
            ASSIGN bc-trans-filho.nr-trans            = bc-trans.nr-trans
                   bc-trans-filho.sequencia           = tt-trans-filho.i-sequen
                   bc-trans-filho.tipo-etiq           = tt-trans-filho.tipo-etiq
                   bc-trans-filho.num-versao          = tt-trans-filho.num-versao
                   bc-trans-filho.num-layout-registro = tt-trans-filho.segmento
                   bc-trans-filho.cod-aux[1]          = STRING(tt-trans-filho.registro)
                   bc-trans-filho.conteudo-trans      = tt-trans-filho.conteudo-xml.
         END.
      END.

      /* em caso de erro (na transaá∆o-pai ou algum dos filhos) cancela */
      IF l-erro = YES THEN
         UNDO, NEXT.

      /* Atualiza nr-trans na tt para indicar que atualizou */
      ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.

      /* Guarda nr-trans para realizar a atualizacao do estado para nova apos cadastro de variaveis */
      ASSIGN i-nr-trans = bc-trans.nr-trans.
   END.

   /* verifica se executa programas de atualizacao/impressao */
   FOR EACH tt-trans
      WHERE tt-trans.nr-trans <> 0:
      FIND FIRST bc-trans
           WHERE bc-trans.nr-trans = tt-trans.nr-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-trans THEN DO:
         {utp/ut-table.i mgcld bc-trans 1}
         RUN geraErro ( 2,
                        TRIM(RETURN-VALUE) + ": ":U + STRING(tt-trans.nr-trans),
                        "":U).
         NEXT.
      END.
      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = bc-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-table.i mgcld bc-tipo-trans 1}
         RUN geraErro ( 2,
                        TRIM(RETURN-VALUE) + ": ":U + tt-trans.cd-trans,
                        "":U).
         NEXT.
      END.

      /* n∆o precisa executar programa de atualizaá∆o/impress∆o */    
      IF bc-trans.estado-trans <> 1 THEN /* estado da transaá∆o = 1-Nova */
         NEXT.   

      /* n∆o atualiza online */
      IF bc-tipo-trans.atualiza-on-line = NO AND bc-tipo-trans.imp-apos-trans = NO THEN
         NEXT.

      ASSIGN v-programa = "":U.

      /* define programa de atualizaá∆o */            
      IF tt-trans.etiqueta = NO  /* tt-trans.etiqueta = <NO> - Gera Transaá∆o Movimento */
         AND bc-tipo-trans.atualiza-on-line = YES THEN
         IF bc-tipo-trans.api-atualizacao <> "" THEN
            ASSIGN v-programa = bc-tipo-trans.api-atualizacao.
         ELSE DO:
            {utp/ut-liter.i "API-Efetivaá∆o"}
            RUN geraErro ( 25975,
                           TRIM(RETURN-VALUE) + "~~" + bc-tipo-trans.cd-trans,
                           "":U).
         END.

      /* define programa de etiqueta */
      IF tt-trans.etiqueta = YES   /* tt-trans.etiqueta = <YES> - Gera Transaá∆o Etiqueta */
         AND bc-tipo-trans.imp-apos-trans = YES THEN
         IF bc-tipo-trans.prog-etiq <> "" THEN
            ASSIGN v-programa = bc-tipo-trans.prog-etiq.
         ELSE DO:
            {utp/ut-liter.i "Impress∆o Etiqueta"}
            RUN geraErro ( 25975,
                           TRIM(RETURN-VALUE) + "~~" + bc-tipo-trans.cd-trans,
                           "":U).
         END.

      /* n∆o tem programa ou n∆o precisa executar */
      IF v-programa = "":U THEN
         NEXT.

      /* preparaá∆o para verificaá∆o de poss°veis erros */
      EMPTY TEMP-TABLE tt-erro-aux.

      /***** execucao do programa ***/  
      erro:
      DO ON ERROR UNDO erro, LEAVE erro
         ON QUIT UNDO erro, LEAVE erro
         ON STOP UNDO erro, LEAVE erro
         ON ENDKEY UNDO erro, LEAVE erro:

         /* Executa programa de atualizacao ou etiqueta */
         RUN VALUE(v-programa) ( tt-trans.nr-trans,
                                 tt-trans.conteudo-trans,
                                 INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.

         /* transaá∆o atualizada */
         DO TRANS:
            FIND CURRENT bc-trans EXCLUSIVE-LOCK.
            ASSIGN  bc-trans.estado-trans     = 2
                    bc-trans.data-atualizacao = TODAY
                    bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS").
         END.
      END.

      /* verificaá∆o dos erros ap¢s execuá∆o do programa */
      IF ERROR-STATUS:ERROR
         OR (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
         DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).
               {utp/ut-liter.i Transaá∆o * L}       
               ASSIGN v-complemento  = " ":U + TRIM(RETURN-VALUE)
                                       + " (":U
                                       + bc-trans.cd-trans
                                       + ")":U.
               {utp/ut-liter.i Erro_Progress * L}
               ASSIGN v-complemento  = v-complemento + " - ":U
                                       + TRIM(RETURN-VALUE)
                                       + " (":U
                                       + STRING(i-cod-erro)
                                       + ")":U.
               
               RUN geraErro ( 15837,
                              (IF bc-trans.log-1 = NO THEN bc-tipo-trans.api-atualizacao ELSE bc-tipo-trans.prog-etiq),
                              v-complemento).
         END.
      END.

      /* verificaá∆o dos erros gerados no programa de atualiza/etiqueta */
      FIND FIRST tt-erro-aux NO-ERROR.
      IF AVAIL tt-erro-aux THEN DO:
         ASSIGN i-cont-erro = 0.
         
         FOR EACH tt-erro-aux:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = tt-erro-aux.i-sequen
                   tt-erro.cd-erro  = tt-erro-aux.cd-erro
                   tt-erro.mensagem = tt-erro-aux.mensagem.

            CREATE bc-trans-erros.
            ASSIGN i-cont-erro             = i-cont-erro + 1
                   bc-trans-erros.nr-trans  = tt-trans.nr-trans
                   bc-trans-erros.cd-msg    = tt-erro-aux.cd-erro
                   bc-trans-erros.texto-msg = tt-erro-aux.mensagem
                   bc-trans-erros.num-sequencial = i-cont-erro.
         END.
         DO TRANS:
            FIND CURRENT bc-trans EXCLUSIVE-LOCK.
            ASSIGN bc-trans.estado-trans     = 3
                   bc-trans.data-atualizacao = ?
                   bc-trans.hora-atualizacao = "".
         END.
      END.
   END.
   RUN FinalizaTransacaoEquipamento (INPUT i-nr-trans).
   FIND FIRST tt-erro NO-ERROR.
   RETURN (IF AVAIL tt-erro THEN "NOK":U ELSE "OK":U).
END PROCEDURE.

/* AlÇm de criar tt-erro Ç necess†rio setar l-erro com YES */
PROCEDURE geraErro:
   DEF INPUT PARAM p-numero        AS INTEGER   NO-UNDO.
   DEF INPUT PARAM p-parametros    AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-complemento   AS CHARACTER NO-UNDO.

   ASSIGN l-erro = YES.
   RUN geraTTErro(p-numero,
                  p-parametros,
                  p-complemento).
END PROCEDURE.


PROCEDURE cria_reg_wms:
   DEF INPUT PARAM p-estado-trans AS INTEGER NO-UNDO.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-filho.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

   DEFINE VARIABLE vcont AS INTEGER.

   EMPTY TEMP-TABLE tt-erro.
   FOR EACH tt-trans:
      ASSIGN vcont = 0.
      IF tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN DO:
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 3941,
                           INPUT "").
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 3941
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.

      FIND FIRST bc-tipo-trans
           WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-tipo-trans THEN DO:
         {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 56
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF (tt-trans.detalhe = ? OR tt-trans.detalhe = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans detalhe 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
         {utp/ut-field.i mgcld bc-trans usuario 1}
         RUN utp/ut-msgs.p(INPUT "msg":U,
                           INPUT 5793,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                tt-erro.cd-erro  = 5793
                tt-erro.mensagem = RETURN-VALUE
                l-erro           = YES.
      END.
      IF l-erro = YES THEN
         UNDO, NEXT.
      
      DO TRANSACTION:
         FIND FIRST bc-trans USE-INDEX bctrans-06
              WHERE bc-trans.detalhe      = tt-trans.detalhe 
                AND bc-trans.estado-trans = 4 
                AND bc-trans.cd-trans     = tt-trans.cd-trans NO-LOCK NO-ERROR.
         IF NOT AVAIL bc-trans THEN DO:
            CREATE bc-trans.
            ASSIGN bc-trans.cd-trans       = tt-trans.cd-trans
                   bc-trans.data           = TODAY
                   bc-trans.detalhe        = tt-trans.detalhe
                   bc-trans.ep-codigo      = i-ep-codigo-usuario
                   bc-trans.estado-trans   = p-estado-trans   /* Conforme Foi Definido o codigo 4 corresponde aos Movimentos das Cargas em processso */
                   bc-trans.horario        = STRING(TIME,"HH:MM:SS":U)
                   bc-trans.usuario        = tt-trans.usuario
                   bc-trans.ind-tipo-trans = 2     /*1-Etiqueta, 2-Coleta*/
                   bc-trans.des-observacao = 'Transaá∆o DC x WMS' + ';0':U.       
            
            ASSIGN tt-trans.nr-trans       = bc-trans.nr-trans
                   vcont                   = 0.
         END.
         ELSE DO:
            ASSIGN tt-trans.nr-trans = bc-trans.nr-trans
                   vcont = INTEGER(ENTRY(2,bc-trans.des-observacao,';':U)).
         END.                 

         FOR EACH tt-trans-filho 
            WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen:
            
            ASSIGN vcont = vcont + 1.
            
            CREATE bc-trans-filho.
            ASSIGN bc-trans-filho.nr-trans             = tt-trans.nr-trans
                   bc-trans-filho.sequencia            = vcont 
                   bc-trans-filho.cod-aux[1]           = ""
                   bc-trans-filho.cod-aux[2]           = ""
                   bc-trans-filho.cod-aux[3]           = ""
                   bc-trans-filho.cod-aux[4]           = ""
                   bc-trans-filho.cod-aux[5]           = ""
                   bc-trans-filho.num-layout-registro  = 0
                   bc-trans-filho.num-versao           = TT-trans.cod-versao-integracao
                   bc-trans-filho.tipo-etiq            = 0
                   bc-trans-filho.conteudo-trans       = TT-trans-filho.conteudo-xml.
            
            ASSIGN tt-trans-filho.cod-versao-integracao = vcont.
         END.
         FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
         ASSIGN ENTRY(2,bc-trans.des-observacao,';':U) = STRING(vcont).
         RELEASE bc-trans.
         RELEASE bc-trans-filho.
      END.
   END.
   RETURN 'OK':U.
END PROCEDURE.

/************************************************************************************************************************************/
PROCEDURE pi-zera-return-value:
   RETURN "":U.
END PROCEDURE.

PROCEDURE SetEstadoTrans :
   DEFINE INPUT PARAM p-i-estado-trans AS INTEGER NO-UNDO.

   ASSIGN i-estado-trans = p-i-estado-trans.
END.

PROCEDURE FinalizaTransacaoEquipamento :
   DEFINE INPUT PARAM p-i-nr-trans AS INTEGER NO-UNDO.

   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = p-i-nr-trans EXCLUSIVE-LOCK NO-ERROR.
   IF AVAIL bc-trans THEN
      ASSIGN bc-trans.estado-trans = 1.
     
   ASSIGN i-estado-trans = 0.
END PROCEDURE.

PROCEDURE FinalizaConsumoLicenca.
   /* Faz a liberaÁ„o do consumo de LicenÁa*/
   RUN lsRelease. 
END PROCEDURE.
