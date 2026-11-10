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
{include/i-prgvrs.i BOIN00972 2.00.00.026 } /*** "010026" 17/06/2025 16:40:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00972 MAQ}
&ENDIF




/* ***************************  Definitions  **********************************/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00972
&GLOBAL-DEFINE DBOVersion 2.00.00.021
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName regra-form-preco
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
{inbo/boin00972.i RowObject}

{aqp/aqapi001.i} /* temp-tables */

DEFINE BUFFER bf-tt-regra-form-preco-custom FOR tt-regra-form-preco-custom .
DEFINE VARIABLE cAcao                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dtUltimoDiaPeriodoFechado   AS DATE         NO-UNDO.
DEFINE VARIABLE lDesabilitaValUnit          AS LOGICAL      NO-UNDO.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{utp/ut-glob.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 7.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aplicarReajuste DBOProgram 
PROCEDURE aplicarReajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-regra-form-preco-custom.

    DO TRANS:
        ASSIGN cAcao = "UPDATE":U.
        FOR EACH tt-regra-form-preco-custom
           WHERE tt-regra-form-preco-custom.checkSum = "*":

            /*verificar se regra encontra-se em perÌodo fechado*/
            {inbo/boin00972.i4 &TABELA="tt-regra-form-preco-custom"}
            /***************************************************/
    
            IF tt-regra-form-preco-custom.cdn-tipo = 1 THEN DO: /* PREÄO BASE */
                IF tt-regra-form-preco-custom.val-reaj <= 0 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="36527" /* Valor n„o pode ser menor ou igual a zero. */
                                                &ErrorType="EMS" 
                                                &ErrorSubType="ERROR"}
                RETURN 'NOK'. 
                END.
            END.
            FOR FIRST regra-form-preco EXCLUSIVE-LOCK
                WHERE ROWID(regra-form-preco) = tt-regra-form-preco-custom.r-Rowid: END.
    
            IF AVAIL regra-form-preco THEN DO:
                ASSIGN regra-form-preco.val-unit                  = IF tt-regra-form-preco-custom.val-reaj = 0 THEN 
                                                                       tt-regra-form-preco-custom.val-unit 
                                                                    ELSE tt-regra-form-preco-custom.val-reaj
                       regra-form-preco.cod-usuar-alter           = v_cod_usuar_corren
                       regra-form-preco.dat-alter                 = TODAY
                       tt-regra-form-preco-custom.val-ant         = tt-regra-form-preco-custom.val-unit
                       tt-regra-form-preco-custom.val-unit        = tt-regra-form-preco-custom.val-reaj 
                       tt-regra-form-preco-custom.cod-usuar-alter = v_cod_usuar_corren
                       tt-regra-form-preco-custom.dat-alter       = TODAY. 
            END.
            ELSE DO:
                 {utp/ut-table.i mgdis regra-form-preco 1}
                 {method/svc/errors/inserr.i &ErrorNumber="2" 
                                             &ErrorParameters=TRIM(RETURN-VALUE)}
                                             
                 UNDO, RETURN 'NOK'.                          
    
            END.
        END.
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiarRegras DBOProgram 
PROCEDURE copiarRegras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-regra-form-preco-custom.

    DEFINE VARIABLE lErro AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE cTxt AS CHARACTER NO-UNDO.

    RUN validateCopiarRegras IN THIS-PROCEDURE(INPUT TABLE tt-regra-form-preco-custom, OUTPUT lErro).    

    IF lErro THEN
        RETURN 'NOK'.

    DO TRANS:
        FOR EACH tt-regra-form-preco-custom
           WHERE tt-regra-form-preco-custom.checkSum = "*":
            
            CREATE rowObject.
            BUFFER-COPY tt-regra-form-preco-custom 
                 EXCEPT cdn-seq cod-usuar-alter dat-alter 
                     TO rowObject.

            RUN getSequenceByCodRegra IN THIS-PROCEDURE(INPUT rowObject.cod-regra, OUTPUT rowObject.cdn-seq).

            ASSIGN rowObject.val-unit                         = tt-regra-form-preco-custom.val-reaj
                   rowObject.cod-usuar-alter                  = v_cod_usuar_corren
                   rowObject.dat-alter                        = TODAY
                   tt-regra-form-preco-custom.cdn-seq         = rowObject.cdn-seq
                   tt-regra-form-preco-custom.val-ant         = tt-regra-form-preco-custom.val-unit
                   tt-regra-form-preco-custom.val-unit        = tt-regra-form-preco-custom.val-reaj 
                   tt-regra-form-preco-custom.cod-usuar-alter = v_cod_usuar_corren
                   tt-regra-form-preco-custom.dat-alter       = TODAY.

            RUN createRecord IN THIS-PROCEDURE.
            IF RETURN-VALUE = "NOK":U THEN DO:
                ASSIGN lErro = YES.
                RUN emptyRowObject IN THIS-PROCEDURE.
                UNDO, LEAVE.
            END.

        END.
    END.

    RETURN IF lErro THEN "NOK" ELSE "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordCustom DBOProgram 
PROCEDURE deleteRecordCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-selected-rows.

    ASSIGN cAcao = "DELETE":U.
    FOR EACH tt-selected-rows:
        FIND FIRST regra-form-preco 
             WHERE ROWID(regra-form-preco) = tt-selected-rows.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL regra-form-preco THEN DO:
        
            /*verificar se regra encontra-se em perÌodo fechado*/
            {inbo/boin00972.i4 &TABELA="regra-form-preco"}
            /***************************************************/ 
            
            DELETE regra-form-preco.
            ASSIGN tt-selected-rows.l-eliminou = YES.
        END.
    END.

    RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DesabilitaValUnit DBOProgram 
PROCEDURE DesabilitaValUnit :
/*------------------------------------------------------------------------------
  Purpose: Essa procedure Ç utilizada para desabilitar o campo valor unit†rio e Ç chamada 
  no aq0201b somente quando alteraá∆o    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDesabilitaValUnit AS LOGICAL NO-UNDO.
    ASSIGN cAcao = "INIT":U .
    /*verificar se regra encontra-se em per°odo fechado*/
    {inbo/boin00972.i4 &TABELA="RowObject"}
    /***************************************************/ 
        
    ASSIGN pDesabilitaValUnit = lDesabilitaValUnit.
    
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.       
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "cod-regiao":U THEN ASSIGN pFieldValue = RowObject.cod-regiao.
        WHEN "cod-regra":U THEN ASSIGN pFieldValue = RowObject.cod-regra.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "cod-usuar-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-alter.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "des-narrat":U THEN ASSIGN pFieldValue = RowObject.des-narrat.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "dat-alter":U THEN ASSIGN pFieldValue = RowObject.dat-alter.
        WHEN "dat-criac":U THEN ASSIGN pFieldValue = RowObject.dat-criac.
        WHEN "dat-fim":U THEN ASSIGN pFieldValue = RowObject.dat-fim.
        WHEN "dat-inic":U THEN ASSIGN pFieldValue = RowObject.dat-inic.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "val-faixa-fim":U THEN ASSIGN pFieldValue = RowObject.val-faixa-fim.
        WHEN "val-faixa-inic":U THEN ASSIGN pFieldValue = RowObject.val-faixa-inic.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-unit":U THEN ASSIGN pFieldValue = RowObject.val-unit.
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
        WHEN "cdn-abrangen":U THEN ASSIGN pFieldValue = RowObject.cdn-abrangen.
        WHEN "cdn-aplic":U THEN ASSIGN pFieldValue = RowObject.cdn-aplic.
        WHEN "cdn-criter":U THEN ASSIGN pFieldValue = RowObject.cdn-criter.
        WHEN "cdn-grp-produt":U THEN ASSIGN pFieldValue = RowObject.cdn-grp-produt.
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
        WHEN "cdn-seq":U THEN ASSIGN pFieldValue = RowObject.cdn-seq.
        WHEN "cdn-tipo":U THEN ASSIGN pFieldValue = RowObject.cdn-tipo.
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice regra-seq
  Parameters:  
               retorna valor do campo cod-regra
               retorna valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-regra LIKE regra-form-preco.cod-regra NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq LIKE regra-form-preco.cdn-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-regra = RowObject.cod-regra
           pcdn-seq = RowObject.cdn-seq.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequenceByCodRegra DBOProgram 
PROCEDURE getSequenceByCodRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----------------- -------------------------------------------------------------*/
    DEFINE INPUT  PARAM pcCodRegra LIKE {&TableName}.cod-regra NO-UNDO.
    DEFINE OUTPUT PARAM piCdnSeq   LIKE {&TableName}.cdn-seq   NO-UNDO.

    FOR LAST bf{&TableName} FIELDS (cdn-seq) NO-LOCK
        WHERE bf{&TableName}.cod-regra = pcCodRegra: 
    END.

    ASSIGN piCdnSeq = IF AVAIL bf{&TableName} THEN bf{&TableName}.cdn-seq + 1 ELSE 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice regra-seq
  Parameters:  
               recebe valor do campo cod-regra
               recebe valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-regra LIKE regra-form-preco.cod-regra NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq LIKE regra-form-preco.cdn-seq NO-UNDO.

    FIND FIRST bfregra-form-preco WHERE 
        bfregra-form-preco.cod-regra = pcod-regra AND 
        bfregra-form-preco.cdn-seq = pcdn-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfregra-form-preco THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfregra-form-preco)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaExameExterno DBOProgram 
PROCEDURE validaExameExterno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAM iCodExame AS INTEGER NO-UNDO.
  DEFINE INPUT PARAM iCdnTipo  AS INTEGER NO-UNDO.

  /* Variaá∆o Qualidade */
  IF iCdnTipo = 2 THEN DO:

    /* Exame interno n∆o permitido */
    FOR FIRST exame FIELDS (cod-exame log-exter) NO-LOCK 
        WHERE exame.cod-exame = iCodExame:
      IF NOT exame.log-exter THEN DO:
        {method/svc/errors/inserr.i 
                 &ErrorNumber     = 54998
                 &ErrorType       = "EMS"
                 &ErrorSubType    = "ERROR"
                 &ErrorParameters = " "}
        RETURN "NOK".
      END.
    END.

  END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCopiarRegras DBOProgram 
PROCEDURE validateCopiarRegras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-regra-form-preco-custom.
    DEFINE OUTPUT PARAMETER lErro AS LOGICAL NO-UNDO.

    DEFINE VARIABLE cTxt  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTxt2 AS CHARACTER NO-UNDO.


    FOR EACH tt-regra-form-preco-custom
       WHERE tt-regra-form-preco-custom.checkSum = "*":
        
        IF tt-regra-form-preco-custom.dat-inic = ? THEN DO:
            {utp/ut-field.i mgind regra-form-preco dat-inic 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* Data inicio deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
            ASSIGN lErro = YES.
        END.

        IF  tt-regra-form-preco-custom.dat-fim = ? THEN DO:
            {utp/ut-field.i mgind regra-form-preco dat-fim 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* Data fim deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
            ASSIGN lErro = YES.
        END.
        
        IF tt-regra-form-preco-custom.cdn-tipo = 1 THEN DO: /* PREÄO BASE */
            IF tt-regra-form-preco-custom.val-reaj <= 0 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="36527" /* Valor n„o pode ser menor ou igual a zero. */
                                                &ErrorType="EMS" 
                                                &ErrorSubType="ERROR"} 
            ASSIGN lErro = YES.
            LEAVE.
            END.
        END.


        IF tt-regra-form-preco-custom.cdn-tipo = 1 OR tt-regra-form-preco-custom.cdn-tipo = 4 THEN DO: /* PREÄO BASE e B‚NUS FIXO */
            IF CAN-FIND(FIRST bf-tt-regra-form-preco-custom 
                        WHERE bf-tt-regra-form-preco-custom.cdn-tipo     = tt-regra-form-preco-custom.cdn-tipo
                          AND bf-tt-regra-form-preco-custom.cdn-abrangen = tt-regra-form-preco-custom.cdn-abrangen 
                          AND bf-tt-regra-form-preco-custom.cod-regra    = tt-regra-form-preco-custom.cod-regra 
                          AND bf-tt-regra-form-preco-custom.cdn-seq     <> tt-regra-form-preco-custom.cdn-seq
                          AND bf-tt-regra-form-preco-custom.checkSum     = "*") THEN DO:
    
                {utp/ut-liter.i contenham_o_mesmo_tipo_e_abrangància *}
                {method/svc/errors/inserr.i
                         &ErrorNumber="54698" /* N∆o Ç poss°vel realizar a c¢pia das regras. */
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters=RETURN-VALUE}
                ASSIGN lErro = YES.
                LEAVE.
            END. 
        END.
        ELSE DO:
             IF CAN-FIND(FIRST bf-tt-regra-form-preco-custom 
                         WHERE bf-tt-regra-form-preco-custom.cdn-tipo     = tt-regra-form-preco-custom.cdn-tipo
                           AND bf-tt-regra-form-preco-custom.cdn-abrangen = tt-regra-form-preco-custom.cdn-abrangen 
                           AND bf-tt-regra-form-preco-custom.cod-regra    = tt-regra-form-preco-custom.cod-regra 
                           AND bf-tt-regra-form-preco-custom.cdn-seq     <> tt-regra-form-preco-custom.cdn-seq
                           AND bf-tt-regra-form-preco-custom.checkSum     = "*"
                           AND ( bf-tt-regra-form-preco-custom.dat-inic      = tt-regra-form-preco-custom.dat-inic AND
                                 bf-tt-regra-form-preco-custom.dat-fim       = tt-regra-form-preco-custom.dat-fim AND
                                 bf-tt-regra-form-preco-custom.val-faixa-inic = tt-regra-form-preco-custom.val-faixa-inic AND 
                                 bf-tt-regra-form-preco-custom.val-faixa-fim = tt-regra-form-preco-custom.val-faixa-fim )) THEN DO:

                {utp/ut-liter.i contenham_o_mesmo_tipo,_abrangància,_faixa_e_vigància *}
                {method/svc/errors/inserr.i
                         &ErrorNumber="54698" /* N∆o Ç poss°vel realizar a c¢pia das regras. */
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters=RETURN-VALUE}
                ASSIGN lErro = YES.
                LEAVE.
             END.
        END.

        {inbo/boin00972.i2 &TABELA="tt-regra-form-preco-custom" &TIPO="'Create'"}

    END.

    RETURN IF lErro THEN "NOK":U ELSE "OK".

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

    DEFINE VARIABLE cTxt     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTxt2    AS CHARACTER NO-UNDO.    
    DEFINE VARIABLE lValidar AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lErro    AS LOGICAL   NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ----*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF  pType = "Create":U OR pType = "Update":U THEN DO:
        
        IF RowObject.cod-regra = "" THEN DO:
            {utp/ut-field.i mgind regra-form-preco cod-regra 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* C¢digo da Regra deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF pType = "Create":U THEN 
                ASSIGN lValidar = CAN-FIND(FIRST bf{&TableName} 
                                           WHERE bf{&TableName}.cod-regra = RowObject.cod-regra
                                             AND bf{&TableName}.cdn-seq   = RowObject.cdn-seq).
            ELSE 
                ASSIGN lValidar = CAN-FIND(FIRST bf{&TableName} 
                                           WHERE bf{&TableName}.cod-regra = RowObject.cod-regra
                                             AND bf{&TableName}.cdn-seq   = RowObject.cdn-seq
                                             AND ROWID(bf{&TableName})   <> RowObject.r-Rowid).

            IF lValidar THEN DO:
                {utp/ut-liter.i outra_regra_com_o_c¢digo_e_sequància_informados *} 
                {method/svc/errors/inserr.i
                             &ErrorNumber="15560" /* j† existe outra regra com o c¢digo e sequància informados */
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters=RETURN-VALUE} 
            END.
        END.

        IF RowObject.descricao = "" THEN DO:
            {utp/ut-field.i mgind regra-form-preco descricao 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* Descricao deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.


        IF RowObject.it-codigo = "" THEN DO:
            {utp/ut-field.i mgind item it-codigo 1}
            ASSIGN cTxt = RETURN-VALUE.
            {utp/ut-liter.i Item_n∆o_pode_ser_igual_a_Branco}
            ASSIGN cTxt = ctxt + "~~" + RETURN-VALUE.
            {method/svc/errors/inserr.i 
                       &ErrorNumber="158" /* Item inv†lido */
                       &ErrorType="EMS" 
                       &ErrorSubType="ERROR"
                       &ErrorParameters=cTxt}

        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST item-estab-rural
                            WHERE item-estab-rural.it-codigo = RowObject.it-codigo) THEN DO:
    
                {utp/ut-liter.i Item_Estab_Rural}
                {method/svc/errors/inserr.i 
                           &ErrorNumber="558" /* Item n∆o cadastrado */
                           &ErrorType="EMS" 
                           &ErrorSubType="ERROR"
                           &ErrorParameters=RETURN-VALUE}
            END.
        END.
       
        CASE RowObject.cdn-abrangen:
            WHEN 1 THEN DO: /* Ponto Coleta */
                IF NOT CAN-FIND(FIRST pto-coleta
                                WHERE pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
                      /* Ponto Coleta n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cod-pto-coleta"}
                END.
            END.
            WHEN 2 THEN DO: /* Propriedade */
                IF NOT CAN-FIND(FIRST propried-rural
                                WHERE propried-rural.cod-propried = RowObject.cod-propried) THEN DO:
                      /* Ponto Coleta n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cod-propried"}
                END.
            END.            
            WHEN 3 THEN DO: /* Produtor */
                IF NOT CAN-FIND(FIRST produt-rural 
                                WHERE produt-rural.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:
                      /* Produtor Rural n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cdn-produt-rural"}
                END.
            END.
            WHEN 4 THEN DO: /* Grupo */
                IF NOT CAN-FIND(FIRST grp-produt
                                WHERE grp-produt.cdn-grp-produt = int(RowObject.cdn-grp-produt)) THEN DO:
                      /* Grupo n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cdn-grp-produt"}
                END.
            END.
            WHEN 5 THEN DO: /* Rota */
                IF NOT CAN-FIND(FIRST rota-coleta
                                WHERE rota-coleta.cod-rota = RowObject.cod-rota) THEN DO:
                      /* Grupo n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cod-rota"} 
                END.
            END.            
            WHEN 6 THEN DO: /* Regi∆o */
                IF NOT CAN-FIND(FIRST regiao-abrangen
                                WHERE regiao-abrangen.cod-regiao = RowObject.cod-regiao) THEN DO:
                      /* Regi∆o n∆o cadastrado */
                     {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                        &CAMPO="cod-regiao"}
                END.       
            END.
            WHEN 7 THEN DO: /* Estabelecimento */
                IF NOT CAN-FIND(FIRST item-estab-rural
                                WHERE item-estab-rural.cod-estabel = RowObject.cod-estabel
                                  AND item-estab-rural.it-codigo   = RowObject.it-codigo) THEN DO:
                                  
                       {utp/ut-liter.i "item estabelecimento rural" *}   
                        ASSIGN cTxt = RETURN-VALUE + "~~" + "AQ0211":U.
                        {method/svc/errors/inserr.i 
                                        &ErrorNumber     = 30657 
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters = cTxt}     
                END.
            END.
        END CASE.

        IF RowObject.dat-inic = ? THEN DO:
            {utp/ut-field.i mgind regra-form-preco dat-inic 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* Data inicio deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE IF  RowObject.dat-fim = ? THEN DO:
            {utp/ut-field.i mgind regra-form-preco dat-fim 1}
            {method/svc/errors/inserr.i &ErrorNumber="688 " /* Data fim deve ser Informado */
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            /* Data Vigància */
            IF RowObject.dat-fim < RowObject.dat-inic THEN DO:
                {utp/ut-field.i mgind regra-form-preco dat-fim 1}
                ASSIGN cTxt = RETURN-VALUE.
                {utp/ut-liter.i da_vigància * }
                ASSIGN cTxt = cTxt + ' ' + RETURN-VALUE.
                {utp/ut-field.i mgind regra-form-preco dat-inic 1}
                ASSIGN cTxt = cTxt + "~~" + RETURN-VALUE.
                {method/svc/errors/inserr.i
                                        &ErrorNumber="416" /*Data Final da vigància n∆o pode ser menor que Data Inicial*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=cTxt}
            END.
        END.

        /* Faixa de valores */
        IF RowObject.cdn-tipo = 2 OR RowObject.cdn-tipo = 3 THEN DO:

            IF RowObject.val-faixa-fim < RowObject.val-faixa-inic THEN DO:
                {utp/ut-field.i mgind regra-form-preco val-faixa-fim 1}
                ASSIGN cTxt = RETURN-VALUE.
                {utp/ut-liter.i de_valores * }
                ASSIGN cTxt = cTxt + ' ' + RETURN-VALUE.
                {utp/ut-field.i mgind regra-form-preco val-faixa-inic 1}
                ASSIGN cTxt = cTxt + "~~" + RETURN-VALUE.

                {method/svc/errors/inserr.i
                                &ErrorNumber="416" /*Faixa final de valores n∆o pode ser menor que FaixaInicial*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=cTxt}
            END.

        END.


       /* Variacao qualidade*/
       IF RowObject.cdn-tipo = 2 THEN DO:
           IF NOT CAN-FIND(FIRST it-exame 
                           WHERE it-exame.it-codigo = RowObject.it-codigo
                             AND it-exame.cod-exame = RowObject.cod-exame) THEN DO:

               /* Exame n∆o cadastrado */
               {inbo/boin00972.i1 &TABELA="regra-form-preco"
                                  &CAMPO="cod-exame"}

           END.

           FOR FIRST it-comp-exame NO-LOCK
               WHERE it-comp-exame.it-codigo = RowObject.it-codigo
                 AND it-comp-exame.cod-comp  = RowObject.cod-comp
                 AND it-comp-exame.cod-exame = RowObject.cod-exame: END.
                 
                 
           IF NOT AVAIL it-comp-exame THEN DO:     
                {utp/ut-field.i mgind regra-form-preco cod-comp 1}
                ASSIGN cTxt = RETURN-VALUE.
                {utp/ut-liter.i para_o_exame_cadastrado}

                {method/svc/errors/inserr.i 
                            &ErrorNumber     = 31768 
                            &ErrorType       = "EMS"
                            &ErrorSubType    = "ERROR"
                            &ErrorParameters = cTxt + ' ' + RETURN-VALUE}
           END.
           ELSE DO:               
               IF it-comp-exame.tipo-result <> 1 THEN DO: /* numerico */
                      
                   /* Tipo de Resultado do componente do exame deve ser numerico. */
                   {method/svc/errors/inserr.i 
                            &ErrorNumber     = 54644 
                            &ErrorType       = "EMS"
                            &ErrorSubType    = "ERROR"
                            &ErrorParameters = " "}
               END.               
           END.
           
       END.

       IF RowObject.cdn-tipo = 1 THEN DO: /* PREÄO BASE */
           IF RowObject.val-unit <= 0 THEN DO:
                   {method/svc/errors/inserr.i &ErrorNumber="36527" /* Valor n„o pode ser menor ou igual a zero. */
                                               &ErrorType="EMS" 
                                               &ErrorSubType="ERROR"}    
           END.
       END.

       /* Validacao sobreposicao perido vigencia e abrangencia */ 
       {inbo/boin00972.i2 &TABELA="RowObject" 
                          &TIPO=pType}

    END.

    ASSIGN cAcao = pType.
    /*verificar se regra encontra-se em perÌodo fechado*/
    {inbo/boin00972.i4 &TABELA="RowObject"}
    /***************************************************/    

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

