/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9005D 2.00.00.006 } /*** "010006" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9005d MBC}
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
**     Programa...: bc9005d.p  
**
**     Finalidade.: Adapter da Nova transacao de transferencia para Datasul EMS 2.00 
**                  Transferencia entre depositos (sem regras de neg¢cio)
**
**     Criado em..: Dezembro 2006
**
**     Versao.....: 2.00.00.000 Amarildo Gambeta
**********************************************************************************/
{bcp/bc9102.i}   
{bcp/bc9107.i}   
{cep/ce9025.i}   
{bcp/bcapi004.i}
{bcp/bcapi011.i}
{cep/ceapi001k.i}
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT        PARAMETER pNumTrans  AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/
{cdp/cdcfgdis.i}

DEFINE VARIABLE vRaw                AS RAW                NO-UNDO.
DEFINE VARIABLE l-erro              AS LOGICAL INIT NO    NO-UNDO.
DEFINE VARIABLE l-pacote-OK         AS LOGICAL INIT YES   NO-UNDO.
DEFINE VARIABLE c-conta-transf      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-ccusto-transf     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE h-ceapi001k         AS HANDLE             NO-UNDO.
/*********************************************************************************/

DO:
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.

   IF NOT AVAIL ttIntegracao THEN DO:
      RUN utp/ut-msgs.p ( INPUT "MSG":U,
                          INPUT 25346,
                          INPUT "bc9005d":U).
      CREATE  tt-erro.
      ASSIGN  tt-erro.cd-erro  = 25346
              tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.

   CREATE tt-transfere.
   ASSIGN tt-transfere.cod-unico              = _RetornaValChar('cod-unico')
          tt-transfere.nro-docto              = _RetornaValChar('num-documento')
          tt-transfere.cod-estabel            = _RetornaValChar('cod-estabel')
          tt-transfere.cod-depos-o            = _RetornaValChar('cod-depos-origem')
          tt-transfere.cod-depos-d            = _RetornaValChar('cod-depos-destino')
          tt-transfere.cod-localiz-o          = _RetornaValChar('cod-local-origem')
          tt-transfere.cod-localiz-d          = _RetornaValChar('cod-local-destino')
          tt-transfere.it-codigo              = _RetornaValChar('cod-item')
          tt-transfere.lote-o                 = _RetornaValChar('cod-lote-origem')
          tt-transfere.lote-d                 = _RetornaValChar('cod-lote-destino')
          tt-transfere.quantidade             = _RetornaValDeci('qtd-movimento')
          tt-transfere.dt-trans               = _RetornaValData('data-transacao')
          tt-transfere.cod-refer-o            = _RetornaValChar('cod-refer-origem')
          tt-transfere.cod-refer-d            = _RetornaValChar('cod-refer-destino')
          tt-transfere.serie-docto            = _RetornaValChar('cod-serie-documento')
          tt-transfere.dat-valid-lote-origem  = _RetornaValData('dat-valid-lote-origem')
          tt-transfere.dat-valid-lote-destino = _RetornaValData('dat-valid-lote-destino')
          tt-transfere.cod-prog-orig          = "bc9001d":U.


   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF AVAIL tt-erro THEN
      RETURN "NOK":U.

   RAW-TRANSFER tt-transfere TO vRaw.

   RUN pi-cria-tt-transfere.
END.

PROCEDURE pi-cria-tt-transfere:
/*------------------------------------------------------------------------------   
  Purpose:         
  Parameters:  <none>
  Notes:           
------------------------------------------------------------------------------*/
   CREATE tt-transfere.
   RAW-TRANSFER vRaw TO tt-transfere.
   
   FIND FIRST param-global NO-LOCK NO-ERROR.
    
   DO TRANSACTION:
      /*Busca conta transferencia*/
      FIND FIRST estab-mat
           WHERE estab-mat.cod-estabel = tt-transfere.cod-estabel NO-LOCK NO-ERROR.
      
      FIND FIRST item
           WHERE item.it-codigo = tt-transfere.it-codigo NO-LOCK NO-ERROR.
      IF NOT AVAIL item THEN DO:
         RUN utp/ut-msgs.p ( INPUT "MSG":U,
                             INPUT 4144,
                             INPUT "").
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = 4144
                tt-erro.mensagem = TRIM(RETURN-VALUE).
         
         RETURN 'NOK':U.
      END.
      /* Quando item controla referencia a mesma dever  ser informada */
      IF item.tipo-con-est = 4 THEN DO:
         IF tt-transfere.cod-refer-o = '' OR tt-transfere.cod-refer-d = '' THEN DO:
            RUN utp/ut-msgs.p ( INPUT "MSG":U,
                                INPUT 53621,
                                INPUT "":U).
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 53621
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            
            RETURN 'NOK':U.
         END.
      END.
      ELSE DO:
         IF tt-transfere.cod-refer-o <> '' OR tt-transfere.cod-refer-d <> '' THEN DO:
            RUN utp/ut-msgs.p ( INPUT "MSG":U,
                                INPUT 17880,
                                INPUT "").
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17880
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            
            RETURN 'NOK':U.
         END.
      END.
      
      /* Quando item controla lote o mesmo dever  ser informado */
      IF item.tipo-con-est = 3 OR item.tipo-con-est = 4 THEN DO:
         IF tt-transfere.lote-o = '' OR tt-transfere.lote-d = '' THEN DO:
            RUN utp/ut-msgs.p ( INPUT "MSG":U,
                                INPUT 56089,
                                INPUT "":U).
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 56089
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            
            RETURN 'NOK':U.
         END.
      END.
      ELSE DO:
         IF tt-transfere.lote-o <> '' OR tt-transfere.lote-d <> '' THEN DO:
            RUN utp/ut-msgs.p ( INPUT "MSG":U,
                                INPUT 17880,
                                INPUT "":U).
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17880
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            
            RETURN 'NOK':U.
         END.
      END.
   
      CREATE tt-movto.
      ASSIGN tt-movto.cod-versao-integracao = 1
             tt-movto.ct-codigo        = estab-mat.cod-cta-transf-unif
             tt-movto.sc-codigo        = estab-mat.cod-ccusto-transf-unif
             tt-movto.nro-docto        = tt-transfere.nro-docto
             tt-movto.dt-trans         = tt-transfere.dt-trans
             tt-movto.cod-depos        = tt-transfere.cod-depos-o
             tt-movto.cod-estabel      = tt-transfere.cod-estabel
             tt-movto.it-codigo        = item.it-codigo
             tt-movto.cod-localiz      = tt-transfere.cod-localiz-o
             tt-movto.lote             = tt-transfere.lote-o
             tt-movto.quantidade       = tt-transfere.quantidade
             tt-movto.un               = item.un
             tt-movto.esp-docto        = 33
             tt-movto.tipo-trans       = 2
             tt-movto.nr-trans         = 1
             tt-movto.cod-refer        = tt-transfere.cod-refer-o
             tt-movto.serie-docto      = tt-transfere.serie-docto
             tt-movto.cod-prog-orig    = tt-transfere.cod-prog-orig
             tt-movto.dt-vali-lote     = tt-transfere.dat-valid-lote-origem.
   
      CREATE tt-movto.
      ASSIGN tt-movto.cod-versao-integracao = 1
             tt-movto.ct-codigo        = estab-mat.cod-cta-transf-unif      
             tt-movto.sc-codigo        = estab-mat.cod-ccusto-transf-unif   
             tt-movto.nro-docto        = tt-transfere.nro-docto
             tt-movto.dt-trans         = tt-transfere.dt-trans
             tt-movto.cod-depos        = tt-transfere.cod-depos-d
             tt-movto.cod-estabel      = tt-transfere.cod-estabel
             tt-movto.it-codigo        = item.it-codigo
             tt-movto.cod-localiz      = tt-transfere.cod-localiz-d
             tt-movto.lote             = tt-transfere.lote-d
             tt-movto.quantidade       = tt-transfere.quantidade
             tt-movto.un               = item.un
             tt-movto.tipo-trans       = 1
             tt-movto.esp-docto        = 33
             tt-movto.nr-trans         = 2
             tt-movto.cod-refer        = tt-transfere.cod-refer-d
             tt-movto.serie-docto      = tt-transfere.serie-docto
             tt-movto.cod-prog-orig    = tt-transfere.cod-prog-orig
             tt-movto.dt-vali-lote     = tt-transfere.dat-valid-lote-destino.
   
      /* Atualiza o estoque */
      RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
      RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                     INPUT-OUTPUT TABLE tt-erro,
                                     INPUT NO).

      IF VALID-HANDLE(h-ceapi001k) THEN DO:
         DELETE PROCEDURE h-ceapi001k.
         ASSIGN h-ceapi001k = ?.
      END.

      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN
         RETURN "NOK":U.

      CREATE tt-prog-bc.
      ASSIGN tt-prog-bc.cod-prog-dtsul        = "ce0206":U
             tt-prog-bc.cod-versao-integracao = 1
             tt-prog-bc.usuario               = c-seg-usuario
             tt-prog-bc.opcao                 = 1.

      RUN bcp/bcapi004.p (INPUT-OUTPUT TABLE tt-prog-bc,
                          INPUT-OUTPUT TABLE tt-erro).

      FIND FIRST tt-prog-bc NO-ERROR.
      IF RETURN-VALUE = "OK":U THEN DO:
         EMPTY TEMP-TABLE tt-etq-item.

         FIND FIRST tt-movto NO-LOCK NO-ERROR.
         CREATE tt-etq-item.
         ASSIGN tt-etq-item.cod-versao-integracao = 1
                tt-etq-item.it-codigo             = tt-movto.it-codigo
                tt-etq-item.qt-item               = tt-movto.quantidade
                tt-etq-item.cd-trans              = tt-prog-bc.cd-trans.

         RUN bcp/bcapi011.p (INPUT-OUTPUT TABLE tt-etq-item).

         FIND FIRST tt-etq-item NO-ERROR.

         erro:
         DO ON STOP UNDO ERRO,LEAVE erro
            ON QUIT UNDO ERRO,LEAVE erro
            ON ERROR UNDO ERRO,LEAVE erro
            ON ENDKEY UNDO ERRO,LEAVE erro:

            RUN VALUE(tt-prog-bc.prog-criacao) (INPUT tt-prog-bc.cd-trans,
                                                INPUT TABLE tt-movto,
                                                INPUT tt-etq-item.qt-etiqueta,
                                                INPUT tt-etq-item.tipo-etiq,
                                                INPUT-OUTPUT TABLE tt-erro) NO-ERROR.

            IF ERROR-STATUS:ERROR OR (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES  <> 0) THEN DO:
               {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 1
                      tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
                      tt-erro.mensagem = TRIM(RETURN-VALUE) + STRING(ERROR-STATUS:GET-NUMBER(1)).
            END.

            IF RETURN-VALUE = "NOK":U THEN DO:
               {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 1
                      tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
                      tt-erro.mensagem = TRIM(RETURN-VALUE) + STRING(ERROR-STATUS:GET-NUMBER(1)).
            END.
         END.
      END.
      ELSE DO:
         /* caso tenha integra‡Æo com o coleta e ocorreu erros */
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO:
            {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
                   tt-erro.mensagem = TRIM(RETURN-VALUE) + STRING(ERROR-STATUS:GET-NUMBER(1)).
         END.
      END.
   END.

   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF AVAIL tt-erro THEN 
      RETURN "NOK":U.

   RETURN "OK":U.    
END PROCEDURE.
