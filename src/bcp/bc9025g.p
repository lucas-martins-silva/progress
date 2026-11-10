/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025G 2.00.00.005} /*** "010005" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9025G MBC}
&ENDIF


{include/i_dbinst.i}  /* versao das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025g.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Cria‡Æo do programa                **
**                                                                                         **
**   Objetivo..: Templates DC para transacao da Transferˆncia entre Endere‡os              **
**                                                                                         **
********************************************************************************************/

&SCOPED-DEFINE Versao-Integracao 1
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */

{include/i_dbtype.i}
{include/i_dbvers.i}

DEF VAR i-cont-erro AS INTEGER.
DEF VAR l-erro      AS LOGICAL INITIAL NO.
DEF VAR i-cont      AS INTEGER NO-UNDO.
DEF VAR i-cod-erro  AS INTEGER.
DEF VAR v-seq-erro  AS INTEGER NO-UNDO.

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

/* alteracao do estado da transacao para Nova */
EMPTY TEMP-TABLE tt-erro.
FOR EACH tt-trans:
   ASSIGN l-erro = NO.

   IF tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN DO:
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 3941,
                        INPUT "").
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      ASSIGN tt-erro.i-sequen = i-cont-erro
             tt-erro.cd-erro  = 3941
             tt-erro.mensagem = RETURN-VALUE + "(DC)":U
             l-erro           = YES.
   END.

   FIND FIRST BC-TIPO-TRANS
        WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans NO-LOCK NO-ERROR.
   IF NOT AVAIL(bc-tipo-trans) THEN DO:
      {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 56,
                        INPUT TRIM(RETURN-VALUE)).
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      ASSIGN tt-erro.i-sequen = i-cont-erro
             tt-erro.cd-erro  = 56
             tt-erro.mensagem = RETURN-VALUE + "(DC)":U
             l-erro           = YES.
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
             l-erro           = YES.
   END.
   IF (tt-trans.usuario = ? OR tt-trans.usuario = "") THEN DO:
      {utp/ut-field.i mgcld bc-trans usuario 1}
      RUN utp/ut-msgs.p(INPUT "MSG":u,
                        INPUT 5793,
                        INPUT TRIM(RETURN-VALUE)).
      
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      ASSIGN tt-erro.i-sequen = i-cont-erro
             tt-erro.cd-erro  = 5793
             tt-erro.mensagem = RETURN-VALUE + "(DC)":U
             l-erro           = YES.
   END.

   IF l-erro = YES THEN
      UNDO, NEXT.

   DO TRANSACTION:
      FIND FIRST bc-trans
           WHERE bc-trans.nr-trans = tt-trans.nr-trans EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL bc-trans AND bc-trans.estado-trans = 1 THEN DO:
         EMPTY TEMP-TABLE tt-erro-aux.

         /* Execucao da pre-api */  
         erro:
         DO ON ERROR  UNDO erro, LEAVE erro
            ON QUIT   UNDO erro, LEAVE erro
            ON STOP   UNDO erro, LEAVE erro
            ON ENDKEY UNDO erro, LEAVE erro:
         
            IF NOT tt-trans.etiqueta THEN DO:
               IF bc-tipo-trans.api-atualizacao <> "" THEN DO:
                  RUN VALUE(bc-tipo-trans.api-atualizacao)( INPUT tt-trans.nr-trans,
                                                            INPUT tt-trans.conteudo-trans,
                                                            INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.
                  ASSIGN  bc-trans.estado-trans     = 2
                          bc-trans.data-atualizacao = TODAY
                          bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS").
               END.
               ELSE DO:
                  RUN utp/ut-msgs.p(INPUT "MSG":U,
                                    INPUT 4,
                                    INPUT RETURN-VALUE).
                  
                  CREATE tt-erro.
                  ASSIGN i-cont-erro = i-cont-erro + 1.
                  ASSIGN tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = 4
                         tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
               END.
            END.
            
            IF tt-trans.etiqueta AND bc-tipo-trans.imp-apos-trans THEN DO:
               IF bc-tipo-trans.prog-etiq <> "" THEN DO:
                  RUN VALUE(bc-tipo-trans.prog-etiq) (INPUT tt-trans.nr-trans,
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
                  ASSIGN i-cont-erro             = i-cont-erro + 1.
                  ASSIGN tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = 4
                         tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
               END.
            END.
         END.
      END.

      IF ERROR-STATUS:ERROR OR ( ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
         DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES
            WHILE(ERROR-STATUS:GET-MESSAGE(i-cont) <> ""):

            ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).

            RUN utp/ut-msgs.p(INPUT "MSG":U,
                              INPUT 15837,
                              INPUT (IF bc-trans.log-1 = NO THEN bc-tipo-trans.api-atualizacao ELSE bc-tipo-trans.prog-etiq) ).
            
            CREATE tt-erro.
            ASSIGN i-cont-erro      = i-cont-erro + 1
                   tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 15837
                   tt-erro.mensagem = TRIM(RETURN-VALUE). 
            
            {utp/ut-liter.i Transa‡Æo * L}       
            ASSIGN tt-erro.mensagem     = tt-erro.mensagem      
                                          + " " + TRIM(RETURN-VALUE)       
                                          + " (" 
                                          + bc-trans.cd-trans
                                          + ")".
            {utp/ut-liter.i Erro_Progress * L}                                   
            ASSIGN tt-erro.mensagem =  tt-erro.mensagem      
                                       + " - " + TRIM(RETURN-VALUE)       
                                       + " (" 
                                       + STRING(i-cod-erro)
                                       + ")".
         END.
      END.

      FIND FIRST tt-erro-aux NO-ERROR.
      IF AVAIL(tt-erro-aux) THEN DO:
         FOR EACH tt-erro-aux:
            CREATE tt-erro.
            ASSIGN i-cont-erro      = i-cont-erro + 1.
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = tt-erro-aux.cd-erro
                   tt-erro.mensagem = tt-erro-aux.mensagem.
            
            CREATE bc-trans-erros.
            ASSIGN i-cont-erro             = i-cont-erro + 1
                   bc-trans-erros.nr-trans  = tt-trans.nr-trans
                   bc-trans-erros.cd-msg    = tt-erro-aux.cd-erro
                   bc-trans-erros.texto-msg = tt-erro-aux.mensagem
                   bc-trans-erros.num-sequencial = i-cont-erro.
         END.
         ASSIGN bc-trans.estado-trans     = 3
                bc-trans.data-atualizacao = ?
                bc-trans.hora-atualizacao = "".
      END.
   END.
END.

FIND FIRST tt-erro NO-ERROR.
IF AVAIL tt-erro OR RETURN-VALUE = "NOK":U THEN
   RETURN "NOK":U.
ELSE
   RETURN 'OK':U.
