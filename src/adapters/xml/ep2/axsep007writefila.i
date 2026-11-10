/* Gravaá∆o das mensagens XML de envio e retorno (s°ncronas) na fila EAI */

/* FUNCTIONS **/
FUNCTION dataHora RETURNS CHARACTER
   (INPUT d-data AS DATE, INPUT c-hora AS CHAR):
RETURN STRING(YEAR(d-data),"9999") 
       + "/" 
       + STRING(MONTH(d-data),"99") 
       + "/" 
       + STRING(DAY(d-data),"99") + " " + c-hora.

END FUNCTION.

/* PROCEDURES */
PROCEDURE piFilaEAI:

    DEF INPUT PARAM pType      AS INT NO-UNDO. /* 1- Envio (SendXML.xml)  2- Retorno (ReturnXML.xml) */
    DEF INPUT PARAM pKeyFields AS CHAR NO-UNDO.

    DEFINE VAR h-axsut001      AS HANDLE NO-UNDO.
    DEFINE VAR hInputXML       AS HANDLE NO-UNDO.
    DEFINE VAR hOutputXML      AS HANDLE NO-UNDO.

    DEFINE VAR cXmlSchemaName  AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdName     AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdVersion  AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdAction   AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdEvent    AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdLocale   AS CHAR   NO-UNDO.
    DEFINE VAR cTranIdComment  AS CHAR   NO-UNDO.
    DEFINE VAR cCompIdDomain   AS CHAR   NO-UNDO.
    DEFINE VAR cCompIdBusIden  AS CHAR   NO-UNDO.
    DEFINE VAR cCompIdCode     AS CHAR   NO-UNDO.
    DEFINE VAR cCompIdBranch   AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdSite   AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdMod    AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdHost   AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdUser   AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdLoc    AS CHAR   NO-UNDO.
    DEFINE VAR cSystemIdComm   AS CHAR   NO-UNDO.
    DEFINE VAR cISTR           AS CHAR   NO-UNDO.
    DEFINE VAR cForTestPurpose AS CHAR   NO-UNDO.
    DEFINE VAR cDataGeracao    AS CHAR   NO-UNDO.
    DEFINE VAR cProductName    AS CHAR   NO-UNDO.
    DEFINE VAR cProductVersion AS CHAR   NO-UNDO.
    DEFINE VAR cProgramName    AS CHAR   NO-UNDO.
    DEFINE VAR cProgramVersion AS CHAR   NO-UNDO.
    DEFINE VAR iTrackingId     AS INT    NO-UNDO.

    /* Busca XML no diret¢rio tempor†rio */
    ASSIGN file-info:file-name = IF pType = 1 THEN 
                                    SESSION:TEMP-DIR + "xmllog~\SendXml.xml":U
                                 ELSE 
                                    SESSION:TEMP-DIR + "xmllog~\ReturnXml.xml":U.  
    IF  FILE-INFO:PATHNAME <> ? THEN DO:
    
        CREATE X-DOCUMENT hInputXML.
        hInputXML:LOAD("file":U,FILE-INFO:PATHNAME,FALSE) NO-ERROR.
        
        RUN adapters/xml/utp/axsut001.p PERSISTENT SET h-axsut001.
    
        RUN parseMessage IN h-axsut001 (INPUT  hInputXML,
                                        OUTPUT cXmlSchemaName,
                                        OUTPUT cTranIdName,
                                        OUTPUT cTranIdVersion,
                                        OUTPUT cTranIdAction,
                                        OUTPUT cTranIdEvent,
                                        OUTPUT cTranIdLocale,
                                        OUTPUT cTranIdComment,
                                        OUTPUT cCompIdDomain,
                                        OUTPUT cCompIdBusIden,
                                        OUTPUT cCompIdCode,
                                        OUTPUT cCompIdBranch,
                                        OUTPUT cSystemIdSite,
                                        OUTPUT cSystemIdMod,
                                        OUTPUT cSystemIdHost,
                                        OUTPUT cSystemIdUser,
                                        OUTPUT cSystemIdLoc,
                                        OUTPUT cSystemIdComm,
                                        OUTPUT cISTR,
                                        OUTPUT cForTestPurpose,
                                        OUTPUT iTrackingId, 
                                        OUTPUT cDataGeracao,
                                        OUTPUT cProductName,
                                        OUTPUT cProductVersion,
                                        OUTPUT cProgramName,
                                        OUTPUT cProgramVersion).
    
        RUN writeFila (INPUT hInputXML,
                       INPUT cTranIdName,
                       INPUT cTranIdVersion,
                       INPUT iTrackingId,
                       INPUT cDataGeracao,
                       INPUT cProductName,
                       INPUT cProductVersion,
                       INPUT cProgramName,
                       INPUT cProgramVersion,
                       INPUT cSystemIdUser,
                       INPUT cCompIdBranch, 
                       INPUT pKeyFields,
                       OUTPUT hOutputXML).

        DELETE PROCEDURE h-axsut001.
        ASSIGN h-axsut001 = ?.
    END.

END PROCEDURE.

PROCEDURE writeFila:

    /* PARAMETROS DE ENTRADA E SAIDA */
    DEF INPUT  PARAM hInputXML       AS HANDLE NO-UNDO.
    DEF INPUT  PARAM cTranName       AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cTranVersion    AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM iTrackingId     AS INT    NO-UNDO. 
    DEF INPUT  PARAM cDataGeracao    AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cProductName    AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cProductVersion AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cProgramName    AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cProgramVersion AS CHAR   NO-UNDO.    
    DEF INPUT  PARAM cSystemIdUser   AS CHAR   NO-UNDO. 
    DEF INPUT  PARAM cCompIdBranch   AS CHAR   NO-UNDO. 
    DEF INPUT  PARAM pKeyFields      AS CHAR   NO-UNDO.
    DEF OUTPUT PARAM hOutputXML      AS HANDLE NO-UNDO.
    
    /* VARIAVEL LOCAL */
    DEF VAR mMsg                AS MEMPTR NO-UNDO.
    DEF VAR iTamTotalMsg        AS INT    NO-UNDO.
    DEF VAR iNumPartesMsg       AS INT    NO-UNDO.
    DEF VAR cData               AS CHAR   NO-UNDO.
    DEF VAR dData               AS DATE   NO-UNDO.    
    DEF VAR i                   AS INT    NO-UNDO.
    DEF VAR iHoraFuso           AS INT    NO-UNDO.
    DEF VAR iNumSequenciaFila   AS INT    NO-UNDO.
    DEF VAR iNumParte           AS INT    NO-UNDO.
    DEF VAR iCdnTipoFila        AS INT    NO-UNDO.

    DEF BUFFER bf-fila-1 FOR fila-eai.

    /* BLOCO PRINCIPAL - TRANSACAO */
    TRAN-FILA:
    DO TRANSACTION:
        /* OBTEM A DATA/HORA DE GERACAO NO GMT 00:00 DA MENSAGEM RECEBIDA */
        RUN getDataGeracao (INPUT-OUTPUT cDataGeracao,
                            INPUT-OUTPUT iHoraFuso).

        /* ZERA VARIAVEL */
        SET-SIZE(mMsg) = 0.
        
        /* ADICIONA O HANDLE DA MENSAGEM A UM MEMPTR */
        hInputXML:SAVE("MEMPTR", mMsg).
        
        /* OBTEM O TAMANHO DA MENSAGEM E O TOTAL DE PARTES QUE SERÊ DIVIDIDA */
        ASSIGN iTamTotalMsg  = GET-SIZE(mMsg).
               iNumPartesMsg = TRUNCATE(iTamTotalMsg / 30000,0).
        
        IF iTamTotalMsg MOD 30000 > 0 
        THEN ASSIGN iNumPartesMsg = iNumPartesMsg + 1.

        /* VERIFICA SE JÊ FOI GRAVADA UMA MSG NA MESMA HORA */
        FIND LAST bf-fila-1 WHERE
                  bf-fila-1.cdn-tipo-fila  = 1            AND 
                  bf-fila-1.dta-geracao    = cDataGeracao NO-LOCK NO-ERROR.

        /* DEFINE O NÇMERO DE SEQU„NCIA DA MENSAGEM. */
        IF AVAIL bf-fila-1 THEN  
            iNumSequenciaFila  = bf-fila-1.num-sequencia-fila + 1.
        ELSE 
            iNumSequenciaFila  = 0.

        /* PARA CADA FRAGMENTO */
        DO i = 1 TO iTamTotalMsg BY 30000:

            /* DEFINE O NUMERO DA PARTE DA MENSAGEM A SER GRAVADA */
            IF iNumPartesMsg = 1  
            THEN iNumParte = 1.
            ELSE 
                IF INT(i / 30000) + 1 = iNumPartesMsg 
                THEN ASSIGN iNumParte = 9999.
                ELSE ASSIGN iNumParte = INT(i / 30000) + 1.
            
            /* DEFINE DESTINO DO REGISTRO A SER ADICIONADO NA FILA */
            IF cProductName <> "EMS2" AND cProductName <> "EMS5" AND cProductName <> "HR" THEN
                ASSIGN iCdnTipoFila = 2. /* DESTINADA AO CONTROL-BROKER */
            ELSE
                ASSIGN iCdnTipoFila = 1. /* DESTINADA AO SISTEMA EXTERNO */
            
            /* CRIA REGISTRO NA FILA */
            CREATE fila-eai.
            
            REPEAT ON ERROR UNDO:
                ASSIGN fila-eai.cdn-tipo-fila         = iCdnTipoFila
                       fila-eai.dta-geracao           = cDataGeracao /* DATA DE GERACAO */
                       fila-eai.num-sequencia-fila    = iNumSequenciaFila /* NÇMERO P/ DISTINGUIR MSGs GERADAS NO MESMO SEGUNDO */
                       fila-eai.num-parte             = iNumParte /* NÇMERO DA PARTE DA MSG GRAVADA NO REGISTRO */
                       fila-eai.tracking-id           = iTrackingId /* ID da transaªío: LENZ 31/08/04 */
                       NO-ERROR.
                VALIDATE fila-eai NO-ERROR.
                /*se conseguiu inserir a chave e nío deu erro ou se tentou mais de 100 vezes e nío conseguiu, considera-se que ocorreu algum erro e retorna nok*/
                IF NOT ERROR-STATUS:ERROR OR iNumSequenciaFila > 100 THEN LEAVE.
                iNumSequenciaFila = iNumSequenciaFila + 1.
            END.
  
            /* IF ERROR-STATUS:ERROR THEN UNDO, RETURN "NOK". */
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN "Erro na inserá∆o da mensagem na tabela FILA-EAI.".
           
            /* INSERE OUTROS VALORES NO REGISTRO */
             ASSIGN
                 fila-eai.num-estado              = 99 /* PROCESSADA */
                 fila-eai.num-prioridade          = 500 /* PRIORIDADE PADRAO */
                 fila-eai.num-total-partes        = iNumPartesMsg /* TOTAL DE PARTES */
                 fila-eai.cdn-tipo-mensagem       = "0" /* MENSAGEM DE NEGOCIO */
                 fila-eai.cod-tipo-transacao      = cTranName /* TIPO DA TRANSACAO */
                 fila-eai.des-versao-transacao    = cTranVersion /* VERSAO DA TRANSACAO */
                 fila-eai.num-variacao-hora       = iHoraFuso /* DIFERENCA DE FUSO */
                 fila-eai.cod-programa            = cProgramName /* NOME DO PROGRAMA */
                 fila-eai.des-versao-prog         = cProgramVersion /* VERSAO DO PROGRAMA */
                 fila-eai.cod-usuario             = cSystemIdUser /* USUARIO GERADOR */
                 fila-eai.cod-estabelecimento     = cCompIdBranch. /*Codigo Estabelecimento*/   
                  
            /* ADICIONA OS KEYFIELDS NO ATRIBUTO REFERENCIA - SEPARADOS POR VIRGULA */
            ASSIGN fila-eai.des-referencia-conteudo = pKeyFields.
            
            /* ADICIONA O CONTEUDO EM PARTES */
            IF  i + 30000 <= iTamTotalMsg  
            THEN ASSIGN fila-eai.des-conteudo  = GET-STRING(mMsg, i, 30000).
            ELSE ASSIGN fila-eai.des-conteudo  = GET-STRING(mMsg, i, iTamTotalMsg - i + 1).

            /* LIBERA REGISTRO DA FILA */
            RELEASE fila-eai      NO-ERROR.
        END.
        
        /* ELIMINA OBJETO POIS NÄO SERÊ MAIS UTILIZADO */
        DELETE OBJECT hInputXML NO-ERROR.
        
        /* ZERA VARIAVEL */
        SET-SIZE(mMsg) = 0.
    END.
    
    RETURN "OK".


END PROCEDURE.


PROCEDURE getDataGeracao:

    /* PARAMETROS DE ENTRADA E SAIDA */
    DEF INPUT-OUTPUT PARAM cDataGeracao AS CHAR NO-UNDO.
    DEF INPUT-OUTPUT PARAM iHoraFuso    AS INT  NO-UNDO.

    /* VARIAVEL LOCAL */
    DEF VAR iAno         AS INT  NO-UNDO.
    DEF VAR iMes         AS INT  NO-UNDO.
    DEF VAR iDia         AS INT  NO-UNDO.
    DEF VAR iHora        AS INT  NO-UNDO.
    DEF VAR iMinuto      AS INT  NO-UNDO.
    DEF VAR iSegundo     AS INT  NO-UNDO.
    DEF VAR iHoraIniSeg  AS INT  NO-UNDO.
    DEF VAR iHoraFusoInt AS INT  NO-UNDO.
    DEF VAR iMinutoFuso  AS INT  NO-UNDO.
    DEF VAR iFusoIniSeg  AS INT  NO-UNDO.
    DEF VAR iHoraFinSeg  AS INT  NO-UNDO.
    DEF VAR cSinal       AS CHAR NO-UNDO.
    DEF VAR dDataFinal   AS DATE NO-UNDO.

    ASSIGN 
            /* DATA INICIAL */
            iAno         = INT(SUBSTRING(cDataGeracao, 1, 4))
            iMes         = INT(SUBSTRING(cDataGeracao, 6, 2))
            iDia         = INT(SUBSTRING(cDataGeracao, 9, 2))
            dDataFinal   = DATE(iMes, iDia, iAno)
    
            /* HORA INICIAL */
            iHora        = INT(SUBSTRING(cDataGeracao, 12, 2))
            iMinuto      = INT(SUBSTRING(cDataGeracao, 15, 2))
            iSegundo     = INT(SUBSTRING(cDataGeracao, 18, 2))
    
            /* HORA DO FUSO - INICIAL */
            iHoraFusoInt = INT(SUBSTRING(cDataGeracao, 21, 2))
            iMinutoFuso  = INT(SUBSTRING(cDataGeracao, 24, 2)) 
    
            /* SINAL -/+ */
            cSinal       = SUBSTRING(cDataGeracao, 20, 1)
    
            /* CALCULA A HORA INICIAL EM SEGUNDOS */
            iHoraIniSeg  = (iHora * 60 * 60) + (iMinuto * 60) + iSegundo
    
            /* CALCULA O FUSO EM SEGUNDOS */
            iFusoIniSeg  = (iHoraFusoInt * 60 * 60) + (iMinutoFuso * 60).
    
     /* ADICIONA OU SUBTRAI O FUSO HORARIO */
     IF cSinal = "-" 
     THEN DO:
         /* SUBTRAI O FUSO DA HORA INICIAL */
         ASSIGN iHoraFinSeg = iHoraIniSeg - iFusoIniSeg
                iHoraFuso   = - INT(iHoraFusoInt).
    
         /* SE HORA FINAL ê MENOR QUE 00:00 */
         IF iHoraFinSeg < 0 
         THEN ASSIGN dDataFinal = dDataFinal - 1. 
     END.
     ELSE DO:
         /* SE O SINAL FOR + */ 
         IF cSinal = "+" 
         THEN DO: 
             /* ADICIONA O FUSO HORARIO DA HORA INICIAL */
             ASSIGN iHoraFinSeg = iHoraIniSeg + iFusoIniSeg
                    iHoraFuso   = INT(iHoraFusoInt).
    
             /* SE HORA FOR MAIOR DE 24 HORAS */
             IF iHoraFinSeg > 86400 
             THEN ASSIGN dDataFinal = dDataFinal + 1. 
         END.
     END.
    
     /* GERA NOVA DATA DE GERACAO NO FUSO GMT 00:00 */
     ASSIGN cDataGeracao = dataHora(dDataFinal, STRING(iHoraFinSeg,"HH:MM:SS")).
    
     RETURN "OK".

END PROCEDURE.


