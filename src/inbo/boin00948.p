&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00948
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-unid-compra
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin00948.i RowObject}
{inbo/boin00948.i tt-item-unid-compra}
{inbo/boin178.i tt-item-fornec}
{inbo/boin178.i tt-item-fornec-aux}
{inbo/boin841.i tt-item-fornec-umd}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cItem     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUn       AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-boin841 AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin178 AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH item-fornec-umd EXCLUSIVE-LOCK
        WHERE item-fornec-umd.it-codigo    = RowObject.it-codigo
        AND   item-fornec-umd.unid-med-for = RowObject.un:
        DELETE item-fornec-umd.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaUnidMedItemFornecUmd DBOProgram 
PROCEDURE atualizaUnidMedItemFornecUmd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-item-unid-compra.
    DEFINE INPUT PARAMETER TABLE FOR tt-item-fornec.
    DEFINE INPUT PARAMETER l-automatico AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-pendencia   AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-atualizar   AS LOGICAL INITIAL NO NO-UNDO.

    DEFINE VARIABLE de-indice     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE l-preco-bruto AS LOGICAL NO-UNDO. /* utilizada na include cc0105.i1  e na procedure InicializaPrecoIpiQtde*/
    DEFINE VARIABLE de-prazo      AS DECIMAL NO-UNDO. /* utilizada na include cc0105.i1 */
    DEFINE VARIABLE i-x           AS INTEGER NO-UNDO. /* contador utilizada na include cc0105.i1 */
    DEFINE VARIABLE de-taxa-per   AS DECIMAL NO-UNDO. /* utilizada na include cc0105.i1 */

    EMPTY TEMP-TABLE RowErrorsAux.

    FIND FIRST tt-item-unid-compra NO-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-item-unid-compra THEN
        RETURN "NOK":U.

    /* se for atualizaá∆o autom†tica, marca todos os fornecedores */
    IF l-automatico THEN DO:
        EMPTY TEMP-TABLE tt-item-fornec.
        FOR EACH item-fornec NO-LOCK
            WHERE item-fornec.it-codigo = tt-item-unid-compra.it-codigo:
            CREATE tt-item-fornec.
            BUFFER-COPY item-fornec TO tt-item-fornec.
            ASSIGN tt-item-fornec.log-2 = YES.
        END.
    END.


    /* fornecedores selecionados */
    FOR EACH tt-item-fornec
        WHERE tt-item-fornec.log-2 NO-LOCK:

        IF  NOT VALID-HANDLE(h-boin841) THEN
            RUN inbo/boin841.p PERSISTENT SET h-boin841.
        RUN openQueryStatic IN h-boin841("main":U).
        RUN emptyRowErrors  IN h-boin841.

        IF  NOT VALID-HANDLE(h-boin178) THEN
            RUN inbo/boin178.p PERSISTENT SET h-boin178.
        RUN openQueryStatic IN h-boin178("main":U).
        RUN emptyRowErrors  IN h-boin178.


        IF CAN-FIND(FIRST item-fornec
                        WHERE item-fornec.it-codigo    = tt-item-unid-compra.it-codigo
                        AND   item-fornec.cod-emitente = tt-item-fornec.cod-emitente
                        AND   item-fornec.unid-med-for = tt-item-unid-compra.un) THEN DO:

            /* atualizar item-fornec */
            EMPTY TEMP-TABLE tt-item-fornec-aux.
            RUN goToKey IN h-boin178 (INPUT tt-item-unid-compra.it-codigo,
                                      INPUT tt-item-fornec.cod-emitente).
            RUN getRecord IN h-boin178(OUTPUT TABLE tt-item-fornec-aux).
            FOR FIRST tt-item-fornec-aux:
                ASSIGN tt-item-fornec-aux.unid-med-for = tt-item-unid-compra.un              
                       tt-item-fornec-aux.fator-conver = tt-item-unid-compra.cdd-fator-conver
                       tt-item-fornec-aux.num-casa-dec = tt-item-unid-compra.nr-casa-dec.    
            END.
            RUN setExecCC0106 IN h-boin178.
            RUN setRecord IN h-boin178(INPUT TABLE tt-item-fornec-aux).
            RUN updateRecord IN h-boin178.
            RUN getRowErrors IN h-boin178(OUTPUT TABLE RowErrorsAux APPEND).
            
            /* criar item-fornec-umd -> usada na include {inbo/boin00948.i2} (atualizaá∆o dos documentos)*/
            EMPTY TEMP-TABLE tt-item-fornec-umd.
            CREATE tt-item-fornec-umd.
            ASSIGN tt-item-fornec-umd.it-codigo    = tt-item-unid-compra.it-codigo
                   tt-item-fornec-umd.cod-emitente = tt-item-fornec-aux.cod-emitente
                   tt-item-fornec-umd.unid-med-for = tt-item-unid-compra.un
                   tt-item-fornec-umd.fator-conver = tt-item-unid-compra.cdd-fator-conver
                   tt-item-fornec-umd.num-casa-dec = tt-item-unid-compra.nr-casa-dec
                   tt-item-fornec-umd.lote-mul-for = tt-item-fornec-aux.lote-mul-for
                   tt-item-fornec-umd.lote-minimo  = tt-item-fornec-aux.lote-minimo
                   tt-item-fornec-umd.log-ativo    = tt-item-fornec-aux.ativo.
        END.
        ELSE DO:
            IF CAN-FIND(FIRST item-fornec-umd
                            WHERE item-fornec-umd.it-codigo = tt-item-unid-compra.it-codigo
                            AND   item-fornec-umd.cod-emitente = tt-item-fornec.cod-emitente
                            AND   item-fornec-umd.unid-med-for = tt-item-unid-compra.un) THEN DO:
                /* atualiza a tabela item-fornec-umd ('Mais unidades' cc0105) */
                EMPTY TEMP-TABLE tt-item-fornec-umd.
                RUN gotoKey IN h-boin841 (INPUT tt-item-unid-compra.it-codigo,   
                                          INPUT tt-item-fornec.cod-emitente,
                                          INPUT tt-item-unid-compra.un).
                RUN getRecord IN h-boin841(OUTPUT TABLE tt-item-fornec-umd).
                FOR FIRST tt-item-fornec-umd:
                    ASSIGN tt-item-fornec-umd.unid-med-for = tt-item-unid-compra.un
                           tt-item-fornec-umd.fator-conver = tt-item-unid-compra.cdd-fator-conver
                           tt-item-fornec-umd.num-casa-dec = tt-item-unid-compra.nr-casa-dec.
                END.
                RUN setExecCC0106 IN h-boin841.
                RUN setRecord IN h-boin841(INPUT TABLE tt-item-fornec-umd).
                RUN updateRecord IN h-boin841.
                RUN getRowErrors IN h-boin841 (OUTPUT TABLE RowErrorsAux APPEND).
            END.
            ELSE DO:
                /* criar item-fornec-umd -> usada na include {inbo/boin00948.i2} (atualizaá∆o dos documentos)*/
                EMPTY TEMP-TABLE tt-item-fornec-umd.
                CREATE tt-item-fornec-umd.
                ASSIGN tt-item-fornec-umd.it-codigo    = tt-item-unid-compra.it-codigo
                       tt-item-fornec-umd.cod-emitente = tt-item-fornec.cod-emitente
                       tt-item-fornec-umd.unid-med-for = tt-item-unid-compra.un
                       tt-item-fornec-umd.fator-conver = tt-item-unid-compra.cdd-fator-conver
                       tt-item-fornec-umd.num-casa-dec = tt-item-unid-compra.nr-casa-dec
                       tt-item-fornec-umd.lote-mul-for = tt-item-fornec.lote-mul-for
                       tt-item-fornec-umd.lote-minimo  = tt-item-fornec.lote-minimo
                       tt-item-fornec-umd.log-ativo    = tt-item-fornec.ativo.
                RUN setExecCC0106 IN h-boin841.
                RUN setRecord IN h-boin841(INPUT TABLE tt-item-fornec-umd).
                RUN createRecord IN h-boin841.
                RUN getRowErrors IN h-boin841 (OUTPUT TABLE RowErrorsAux APPEND).
            END.
        END.


        
        ASSIGN l-pendencia = NO.
        /* validar se h† documentos pendentes */
        IF CAN-FIND(FIRST cotacao-item 
                        WHERE cotacao-item.cod-emitente = tt-item-fornec.cod-emitente
                        AND   cotacao-item.it-codigo    = tt-item-unid-compra.it-codigo
                        AND   cotacao-item.un           = tt-item-unid-compra.un) THEN DO:
            ASSIGN l-pendencia = YES.
        END.

        IF CAN-FIND(FIRST item-contrat 
                        WHERE item-contrat.it-codigo    = tt-item-unid-compra.it-codigo
                        AND   item-contrat.cod-emitente = tt-item-fornec.cod-emitente
                        AND   item-contrat.un           = tt-item-unid-compra.un) THEN DO:
            ASSIGN l-pendencia = YES.
        END.

        FOR EACH componente 
            WHERE componente.cod-emitente = tt-item-fornec.cod-emitente
            AND   componente.it-codigo    = tt-item-unid-compra.it-codigo NO-LOCK:
            
            FOR FIRST item-doc-est FIELDS (numero-ordem)
                WHERE item-doc-est.serie-docto  = componente.serie-docto 
                    AND item-doc-est.nro-docto    = componente.nro-docto   
                    AND item-doc-est.cod-emitente = componente.cod-emitente
                    AND item-doc-est.nat-operacao = componente.nat-operacao
                    AND item-doc-est.sequencia    = componente.sequencia NO-LOCK:
                                                                        
                    IF CAN-FIND(FIRST cotacao-item
                                    WHERE cotacao-item.numero-ordem = item-doc-est.numero-ordem
                                    AND   cotacao-item.cot-aprovada = YES
                                    AND   cotacao-item.un = tt-item-unid-compra.un) THEN
                        ASSIGN l-pendencia = YES.
            END.
        END.    

        FOR EACH recebimento 
            WHERE recebimento.cod-emitente = tt-item-fornec.cod-emitente
            AND   recebimento.it-codigo    = tt-item-unid-compra.it-codigo NO-LOCK:
            
            IF CAN-FIND(FIRST cotacao-item
                            WHERE cotacao-item.numero-ordem = recebimento.numero-ordem
                            AND   cotacao-item.cot-aprovada = YES
                            AND   cotacao-item.un = tt-item-unid-compra.un) THEN
                ASSIGN l-pendencia = YES.
        END.

        FOR EACH item-doc-est 
            WHERE item-doc-est.cod-emitente = tt-item-fornec.cod-emitente
            AND   item-doc-est.it-codigo    = tt-item-fornec.it-codigo NO-LOCK:
            
            IF CAN-FIND(FIRST cotacao-item
                            WHERE cotacao-item.numero-ordem = item-doc-est.numero-ordem
                            AND cotacao-item.cot-aprovada = YES
                            AND cotacao-item.un = tt-item-unid-compra.un) THEN DO:
                ASSIGN l-pendencia = YES.
            END.
        END.

        /* se houver pendància, pergunta se Ç para atualizar os documentos pendentes. */
        IF l-pendencia THEN DO:
            if can-find (first funcao
                         where funcao.cd-funcao = "spp-ValidaConvItem":U
                         and funcao.ativo) then do:
                RUN utp/ut-msgs(INPUT 'show',
                                INPUT 54490,
                                INPUT tt-item-unid-compra.it-codigo + "~~" + tt-item-unid-compra.un).
                ASSIGN l-atualizar = NO.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 54477,
                                    INPUT tt-item-unid-compra.un + "~~" + string(tt-item-fornec.cod-emitente)).
                ASSIGN l-atualizar = LOGICAL(RETURN-VALUE).
            END.
        END.

        /* 
         * atualiza os documentos pendentes 
         * l-pendencia = existe documentos digitados pendentes
         * l-atualizar = indica se deve ou n∆o atualizar os documentos pendentes
         */
        IF l-atualizar AND l-pendencia THEN DO:
            {inbo/boin00948.i2}
        END.
    END.

    FOR EACH RowErrorsAux:
        CREATE RowErrors.
        BUFFER-COPY ROwErrorsAux TO RowErrors.
    END.

    IF VALID-HANDLE(h-boin841) THEN DO:
        DELETE PROCEDURE h-boin841.
        ASSIGN h-boin841 = ?.
    END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdd-fator-conver":U THEN ASSIGN pFieldValue = RowObject.cdd-fator-conver.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-casa-dec":U THEN ASSIGN pFieldValue = RowObject.nr-casa-dec.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmndcmp_pk
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo un
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-unid-compra.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pun LIKE item-unid-compra.un NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pun = RowObject.un.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-bloqueia":U THEN ASSIGN pFieldValue = RowObject.log-bloqueia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice itmndcmp_pk
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo un
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-unid-compra.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pun LIKE item-unid-compra.un NO-UNDO.

    FIND FIRST bfitem-unid-compra 
        WHERE bfitem-unid-compra.it-codigo = pit-codigo 
        AND   bfitem-unid-compra.un = pun NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-unid-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-unid-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Handle do DBO pai.
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER ph-item AS HANDLE NO-UNDO.
    
    RUN GetKey IN ph-item (OUTPUT cItem).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                                WHERE {&tablename}.it-codigo = cItem
                                         NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-bloqueio DBOProgram 
PROCEDURE pi-atualiza-bloqueio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo    LIKE {&TableName}.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER plog-bloqueia LIKE {&TableName}.log-bloqueia NO-UNDO.

    FOR EACH bf{&TableName}
        WHERE bf{&TableName}.it-codigo = pit-codigo EXCLUSIVE-LOCK:
        ASSIGN bf{&TableName}.log-bloqueia = plog-bloqueia.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-bloqueio DBOProgram 
PROCEDURE pi-busca-bloqueio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE {&TableName}.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER plog-bloqueia LIKE {&TableName}.log-bloqueia NO-UNDO.

    FOR FIRST {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = pit-codigo:
        ASSIGN plog-bloqueia = {&TableName}.log-bloqueia.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-relacionamento DBOProgram 
PROCEDURE pi-busca-relacionamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pit-codigo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER lachou     AS LOGICAL NO-UNDO.

    ASSIGN lachou = CAN-FIND(FIRST {&TableName}
                                WHERE {&TableName}.it-codigo = pit-codigo).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-fornecedores DBOProgram 
PROCEDURE pi-valida-fornecedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-unid-compra.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER plog-existe-fornec AS LOGICAL NO-UNDO.

    ASSIGN plog-existe-fornec = CAN-FIND(FIRST item-fornec
                                            WHERE item-fornec.it-codigo = pit-codigo).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-item LIKE {&TableName}.it-codigo NO-UNDO.

    ASSIGN cItem = pc-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
   
    FIND FIRST rowObject NO-ERROR. 
    if avail rowObject then do:
   
        if  pType = "Create":U or pType = "Update":U then do:
            IF rowObject.cdd-fator-conver = 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-fator-de-conversao AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Fator_de_Convers∆o" *}
               ASSIGN c-lbl-liter-fator-de-conversao = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="17340"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-fator-de-conversao"}
                                                
            END.
            if not can-find(first tab-unidade 
                            where tab-unidade.un = rowObject.un) then do:
                {method/svc/errors/inserr.i &ErrorNumber="846"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}        
            end.
            else do:
                if pType = "Create":U then do:
                  
                    if can-find (first item-unid-compra 
                                 where item-unid-compra.it-codigo = rowObject.it-codigo
                                   and item-unid-compra.un        = rowObject.un) then do:
                        
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-item-x-un AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Item_X_UN" *}
                        ASSIGN c-lbl-liter-item-x-un = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Unidade_de_Medida" *}
                        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="32682"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-item-x-un + '~~~~' + c-lbl-liter-unidade-de-medida"} 
                    end.
                end.
            end.
        end.
    
        IF pType = "Delete":U THEN DO:
            /** *************    Validaªío da Trigger   ************** **/
            IF  CAN-FIND(FIRST item-contrat
                         WHERE item-contrat.it-codigo    = RowObject.it-codigo
                           and item-contrat.un           = RowObject.un) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="6801"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
            END.    
    
            FOR FIRST ITEM FIELDS(tipo-contr)
                WHERE ITEM.it-codigo = {&tablename}.it-codigo NO-LOCK: END.
            IF CAN-FIND(FIRST cotacao-item 
                        WHERE cotacao-item.it-codigo    = RowObject.it-codigo 
                          and cotacao-item.un           = RowObject.un
                          AND cotacao-item.cot-aprovada ) 
            AND (AVAIL ITEM AND item.tipo-contr <> 4) THEN do:
                    {method/svc/errors/inserr.i &ErrorNumber="6802"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}     
            END.    
            /** Fim das validaªÑes de eliminaªío **/
        END.
       
    end.





    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

