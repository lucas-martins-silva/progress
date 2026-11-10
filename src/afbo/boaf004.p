&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAF004 2.00.00.003 } /*** "010003" 23/11/2023 16:19:37  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF004
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-item-contr
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
{afbo/boaf004.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE iPerc        LIKE af-item-contr-form.percentual NO-UNDO.
DEFINE VARIABLE h-boaf005    AS HANDLE     NO-UNDO.

{afbo/boaf005.i ttAf-item-contr-form}
{afbo/boaf005.i bttAf-item-contr-form}

DEF VAR c-it-codigo-ini     LIKE af-item-contr.it-codigo    NO-UNDO.
DEF VAR c-it-codigo-fim     LIKE af-item-contr.it-codigo    NO-UNDO.
DEF VAR i-cod-emitente-ini  LIKE af-item-contr.cod-emitente NO-UNDO.
DEF VAR i-cod-emitente-fim  LIKE af-item-contr.cod-emitente NO-UNDO.
DEF VAR i-nr-versao-ini     LIKE af-item-contr.nr-versao    NO-UNDO.
DEF VAR i-nr-versao-fim     LIKE af-item-contr.nr-versao    NO-UNDO.

{utp/ut-glob.i}

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
         HEIGHT             = 18.75
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN piCriaFormula.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-boaf005) THEN
       RUN afbo/boaf005.p PERSISTENT SET h-boaf005.  
    RUN openQueryStatic IN h-boaf005 (INPUT "Main":U) NO-ERROR.
    FOR EACH af-item-contr-form
        WHERE af-item-contr-form.ep-codigo    = RowObject.ep-codigo
        AND   af-item-contr-form.it-codigo    = RowObject.it-codigo
        AND   af-item-contr-form.cod-emitente = RowObject.cod-emitente
        AND   af-item-contr-form.nr-versao    = RowObject.nr-versao:
        RUN repositionRecord IN h-boaf005 (INPUT ROWID(af-item-contr-form)).
        RUN deleteRecord IN h-boaf005.
    END.
    DELETE PROCEDURE h-boaf005.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN piCriaFormula.

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
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "usuar-alter":U THEN ASSIGN pFieldValue = RowObject.usuar-alter.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "dt-alter":U THEN ASSIGN pFieldValue = RowObject.dt-alter.
        WHEN "dt-implantacao":U THEN ASSIGN pFieldValue = RowObject.dt-implantacao.
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
        WHEN "demerito":U THEN ASSIGN pFieldValue = RowObject.demerito.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescItem DBOProgram 
PROCEDURE getDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-item      LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-desc-item LIKE item.desc-item NO-UNDO.

    FOR FIRST item FIELDS (desc-item)
        WHERE item.it-codigo = pc-item NO-LOCK: END.
    IF  AVAIL item THEN
        ASSIGN pc-desc-item = item.desc-item.    
    ELSE DO:
        ASSIGN pc-desc-item = "".
        RETURN "NOK":U.
    END.

    RETURN "OK".

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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "nr-dia-max":U THEN ASSIGN pFieldValue = RowObject.nr-dia-max.
        WHEN "nr-dia-min":U THEN ASSIGN pFieldValue = RowObject.nr-dia-min.
        WHEN "nr-versao":U  THEN ASSIGN pFieldValue = RowObject.nr-versao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-item
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-item-contr.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE af-item-contr.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE af-item-contr.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-versao    LIKE af-item-contr.nr-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pit-codigo = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente
           pnr-versao    = RowObject.nr-versao.

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
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "preco":U THEN ASSIGN pFieldValue = RowObject.preco.
        WHEN "qualidade":U THEN ASSIGN pFieldValue = RowObject.qualidade.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeEmitente DBOProgram 
PROCEDURE getNomeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pi-emitente   LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAM pc-nome-emit  LIKE emitente.nome-emit    NO-UNDO.

    FOR FIRST emitente FIELDS (nome-emit)
        WHERE emitente.cod-emitente = pi-emitente NO-LOCK: END.
    IF AVAIL emitente THEN
        ASSIGN pc-nome-emit = emitente.nome-emit.    
    ELSE DO:
        ASSIGN pc-nome-emit = "".
        RETURN "NOK":U.
    END.

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
  Purpose:     Reposiciona registro com base no °ndice ep-item
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-item-contr.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE af-item-contr.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE af-item-contr.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao    LIKE af-item-contr.nr-versao    NO-UNDO.

    FIND FIRST bfaf-item-contr WHERE 
        bfaf-item-contr.ep-codigo = pep-codigo AND 
        bfaf-item-contr.it-codigo = pit-codigo AND 
        bfaf-item-contr.cod-emitente = pcod-emitente AND
        bfaf-item-contr.nr-versao    = pnr-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-item-contr THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-item-contr)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemContr DBOProgram 
PROCEDURE openQueryItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH af-item-contr NO-LOCK USE-INDEX ep-item  WHERE 
                                     af-item-contr.ep-codigo     = i-ep-codigo-usuario AND 
                                     af-item-contr.it-codigo    >= c-it-codigo-ini     AND
                                     af-item-contr.it-codigo    <= c-it-codigo-fim     AND
                                     af-item-contr.cod-emitente >= i-cod-emitente-ini  AND 
                                     af-item-contr.cod-emitente <= i-cod-emitente-fim  AND 
                                     af-item-contr.nr-versao    >= i-nr-versao-ini     AND 
                                     af-item-contr.nr-versao    <= i-nr-versao-fim INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH af-item-contr NO-LOCK 
        WHERE af-item-contr.ep-codigo = i-ep-codigo-usuario INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaAlteracao DBOProgram 
PROCEDURE piAtualizaAlteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN RowObject.usuar-alter = c-seg-usuario
           RowObject.hora-alter  = STRING(TIME,"HH:MM:SS")
           RowObject.dt-alter    = TODAY.
     
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaFormula DBOProgram 
PROCEDURE piCriaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        IF NOT VALID-HANDLE(h-boaf005) THEN
           RUN afbo/boaf005.p PERSISTENT SET h-boaf005.  
        RUN openQueryStatic IN h-boaf005 (INPUT "Main":U) NO-ERROR.

        FOR EACH bttAf-item-contr-form:
            DELETE bttAf-item-contr-form.
        END.
        RUN emptyRowerrors IN h-boaf005.
        ASSIGN iPerc = 0.
        FOR EACH ttAf-item-contr-form NO-LOCK:
            ASSIGN iPerc = iPerc + ttAf-item-contr-form.percentual.
        END.
        IF iPerc <> 100 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-percentual-da-formula-devera-s AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Percentual_da_f¢rmula_dever†_ser_100%" *}
            ASSIGN c-lbl-liter-percentual-da-formula-devera-s = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-a-somatoria-do-ponto-de-contro AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "A_somat¢ria_do_ponto_de_controle_dever†_ser_igual_a_100%" *}
            ASSIGN c-lbl-liter-a-somatoria-do-ponto-de-contro = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="17567"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-percentual-da-formula-devera-s"
                    &ErrorHelp="c-lbl-liter-a-somatoria-do-ponto-de-contro"}
            return "NOK":U.
        END.

        FOR EACH ttAf-item-contr-form:
            CREATE bttAf-item-contr-form.
            BUFFER-COPY ttAf-item-contr-form TO bttAf-item-contr-form.
            RUN gotokey IN h-boaf005  (INPUT ttAf-item-contr-form.ep-codigo,
                                       INPUT ttAf-item-contr-form.it-codigo,
                                       INPUT ttaf-item-contr-form.cod-emitente,
                                       INPUT ttaf-item-contr-form.nr-versao,
                                       INPUT ttaf-item-contr-form.seq).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN EMPTYRowObject IN h-boaf005.
                RUN setRecord IN h-boaf005 (INPUT TABLE bttAf-item-contr-form).
                RUN updateRecord IN h-boaf005.
            END.
            ELSE DO:
                RUN EMPTYRowObject IN h-boaf005.
                RUN newRecord  IN h-boaf005.
                RUN setRecord IN h-boaf005 (INPUT TABLE bttAf-item-contr-form).
                RUN createRecord IN h-boaf005.
            END.
            DELETE bttAf-item-contr-form.
        END.

        FOR EACH af-item-contr-form
            WHERE af-item-contr-form.ep-codigo    = RowObject.ep-codigo
            AND   af-item-contr-form.it-codigo    = RowObject.it-codigo
            AND   af-item-contr-form.cod-emitente = RowObject.cod-emitente
            AND   af-item-contr-form.nr-versao    = RowObject.nr-versao:
            FIND ttAf-item-contr-form OF af-item-contr-form NO-LOCK NO-ERROR.
            IF NOT AVAIL ttAf-item-contr-form THEN DO:
               RUN repositionRecord IN h-boaf005 (INPUT ROWID(af-item-contr-form)).
               RUN deleteRecord IN h-boaf005.
            END.
        END.

        DELETE PROCEDURE h-boaf005.
        RETURN "OK":U .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeFormula DBOProgram 
PROCEDURE piRecebeFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR ttAf-item-contr-form.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemContr DBOProgram 
PROCEDURE setConstraintItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pc-it-codigo-ini     LIKE af-item-contr.it-codigo    NO-UNDO.
DEF INPUT PARAM pc-it-codigo-fim     LIKE af-item-contr.it-codigo    NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-ini  LIKE af-item-contr.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-fim  LIKE af-item-contr.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-nr-versao-ini     LIKE af-item-contr.nr-versao    NO-UNDO.
DEF INPUT PARAM pi-nr-versao-fim     LIKE af-item-contr.nr-versao    NO-UNDO.

ASSIGN c-it-codigo-ini    = pc-it-codigo-ini   
       c-it-codigo-fim    = pc-it-codigo-fim   
       i-cod-emitente-ini = pi-cod-emitente-ini
       i-cod-emitente-fim = pi-cod-emitente-fim
       i-nr-versao-ini    = pi-nr-versao-ini
       i-nr-versao-fim    = pi-nr-versao-fim.

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
    

    IF pType = "CREATE":U THEN DO:
       FIND bf{&TableName}
           WHERE bf{&TableName}.ep-codigo = RowObject.ep-codigo
           AND   bf{&TableName}.it-codigo = RowObject.it-codigo
           AND   bf{&TableName}.cod-emitente = RowObject.cod-emitente
           AND   bf{&TableName}.nr-versao    = RowObject.nr-versao
           NO-LOCK NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-de-controle-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Controle_Item" *}
            ASSIGN c-lbl-liter-ponto-de-controle-item = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="7"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-ponto-de-controle-item"}
            return "NOK":U.
       END.       
       FIND ITEM 
           WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
       IF NOT AVAIL item THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-material AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Material" *}
            ASSIGN c-lbl-liter-item-material = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-item-material"}
            return "NOK":U.
       END.
       FIND emitente
           WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor" *}
            ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-fornecedor"}
                    return "NOK":U.
       END.
       FIND FIRST af-versao-avaliacao
           WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo
           AND   af-versao-avaliacao.nr-versao = RowObject.nr-versao NO-LOCK NO-ERROR.
       IF NOT AVAIL af-versao-avaliacao THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-versao-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-versao-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-versao-avaliacao"}
            return "NOK":U.
       END.
    END.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    IF pType <> "Delete" THEN RUN piAtualizaAlteracao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

