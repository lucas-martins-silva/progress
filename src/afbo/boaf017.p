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
{include/i-prgvrs.i BOAF017 2.00.00.003 } /*** "010003" 23/11/2023 16:19:39  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF017
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-grp-avaliacao
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
{afbo/boaf017.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE iPerc        LIKE af-grp-avaliacao-form.percentual NO-UNDO.
DEFINE VARIABLE h-boaf018    AS HANDLE     NO-UNDO.

{afbo/boaf018.i ttaf-grp-avaliacao-form}
{afbo/boaf018.i bttaf-grp-avaliacao-form}

DEF VAR i-cod-grp-avaliacao-ini   LIKE af-grp-avaliacao.cod-grp-avaliacao  NO-UNDO.
DEF VAR i-cod-grp-avaliacao-fim   LIKE af-grp-avaliacao.cod-grp-avaliacao  NO-UNDO.
DEF VAR i-nr-versao-ini LIKE af-grp-avaliacao.nr-versao  NO-UNDO.
DEF VAR i-nr-versao-fim LIKE af-grp-avaliacao.nr-versao  NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 9.88
         WIDTH              = 44.57.
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
    IF NOT VALID-HANDLE(h-boaf018) THEN
       RUN afbo/boaf018.p PERSISTENT SET h-boaf018.  
    RUN openQueryStatic IN h-boaf018 (INPUT "Main":U) NO-ERROR.
    FOR EACH af-grp-avaliacao-form NO-LOCK
        WHERE af-grp-avaliacao-form.ep-codigo         = RowObject.ep-codigo
        AND   af-grp-avaliacao-form.cod-grp-avaliacao = RowObject.cod-grp-avaliacao
        AND   af-grp-avaliacao-form.nr-versao         = RowObject.nr-versao:
        RUN repositionRecord IN h-boaf018 (INPUT ROWID(af-grp-avaliacao-form)).
        RUN deleteRecord IN h-boaf018.
    END.
    DELETE PROCEDURE h-boaf018.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-grp-avaliacao":U THEN ASSIGN pFieldValue = RowObject.cod-grp-avaliacao.
        WHEN "des-grp-avaliacao":U THEN ASSIGN pFieldValue = RowObject.des-grp-avaliacao.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "demerito":U THEN ASSIGN pFieldValue = RowObject.demerito.
        WHEN "pct-qtd-max":U THEN ASSIGN pFieldValue = RowObject.pct-qtd-max.
        WHEN "pct-qtd-min":U THEN ASSIGN pFieldValue = RowObject.pct-qtd-min.
        WHEN "pct-val-max":U THEN ASSIGN pFieldValue = RowObject.pct-val-max.
        WHEN "pct-val-min":U THEN ASSIGN pFieldValue = RowObject.pct-val-min.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesGrupoAval DBOProgram 
PROCEDURE getDesGrupoAval :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-grp-aval like Af-Grp-Avaliacao.cod-grp-avaliacao.
def input param p-nr-versao like af-grp-Avaliacao.nr-versao.
def output param p-des-grp-aval like Af-Grp-Avaliacao.des-grp-avaliacao.

assign p-des-grp-aval = "".

for first Af-Grp-Avaliacao fields(des-grp-avaliacao)
    where Af-Grp-Avaliacao.cod-grp-avaliacao = p-cod-grp-aval 
    AND af-grp-avaliacao.nr-versao = p-nr-versao no-lock. end.
if avail Af-Grp-Avaliacao then
   assign p-des-grp-aval = Af-Grp-Avaliacao.des-grp-avaliacao.

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
        WHEN "nr-dia-max":U THEN ASSIGN pFieldValue = RowObject.nr-dia-max.
        WHEN "nr-dia-min":U THEN ASSIGN pFieldValue = RowObject.nr-dia-min.
        WHEN "nr-versao":U THEN ASSIGN pFieldValue = RowObject.nr-versao.
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
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pep-codigo LIKE af-grp-avaliacao.ep-codigo NO-UNDO.
   DEFINE OUTPUT PARAMETER pcod-grp-avaliacao LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
   DEFINE OUTPUT PARAMETER pnr-versao LIKE af-grp-avaliacao.nr-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-grp-avaliacao = RowObject.cod-grp-avaliacao
           pnr-versao = RowObject.nr-versao.

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
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-considera-qtd-receb":U THEN ASSIGN pFieldValue = RowObject.log-considera-qtd-receb.
        WHEN "log-considera-val-receb":U THEN ASSIGN pFieldValue = RowObject.log-considera-val-receb.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeEstabel DBOProgram 
PROCEDURE getNomeEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pc-estabelec   LIKE estabelec.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM pc-nome-estab  LIKE estabelec.nome        NO-UNDO.

    FOR FIRST estabelec FIELDS (nome)
        WHERE estabelec.cod-estabel = pc-estabelec NO-LOCK: END.
    IF AVAIL estabelec THEN
        ASSIGN pc-nome-estab = estabelec.nome.    
    ELSE DO:
        ASSIGN pc-nome-estab = "".
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
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-grp-avaliacao.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-grp-avaliacao LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao LIKE af-grp-avaliacao.nr-versao NO-UNDO.

    FIND FIRST bfaf-grp-avaliacao WHERE 
        bfaf-grp-avaliacao.ep-codigo = pep-codigo AND 
        bfaf-grp-avaliacao.cod-grp-avaliacao = pcod-grp-avaliacao AND
        bfaf-grp-avaliacao.nr-versao = pnr-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-grp-avaliacao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-grp-avaliacao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstItemContr DBOProgram 
PROCEDURE openQueryEstItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH af-grp-avaliacao NO-LOCK WHERE 
                                     af-grp-avaliacao.ep-codigo           = i-ep-codigo-usuario       AND 
                                     af-grp-avaliacao.cod-grp-avaliacao  >= i-cod-grp-avaliacao-ini   AND
                                     af-grp-avaliacao.cod-grp-avaliacao  <= i-cod-grp-avaliacao-fim   AND 
                                     af-grp-avaliacao.nr-versao          >= i-nr-versao-ini       AND 
                                     af-grp-avaliacao.nr-versao          <= i-nr-versao-fim INDEXED-REPOSITION.

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
OPEN QUERY {&QueryName} FOR EACH af-grp-avaliacao NO-LOCK  
    WHERE af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario INDEXED-REPOSITION.

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
        IF NOT VALID-HANDLE(h-boaf018) THEN
           RUN afbo/boaf018.p PERSISTENT SET h-boaf018.  
        
        RUN openQueryStatic IN h-boaf018 (INPUT "Main":U) NO-ERROR.

        FOR EACH bttaf-grp-avaliacao-form:
            DELETE bttaf-grp-avaliacao-form.
        END.
        RUN emptyRowerrors IN h-boaf018.
        ASSIGN iPerc = 0.
        FOR EACH ttaf-grp-avaliacao-form NO-LOCK:
            ASSIGN iPerc = iPerc + ttaf-grp-avaliacao-form.percentual.
        END.
        IF iPerc <> 100 THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="52880"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="''"}
            return "NOK":U.
        END.

        FOR EACH ttaf-grp-avaliacao-form:
            CREATE bttaf-grp-avaliacao-form.
            BUFFER-COPY ttaf-grp-avaliacao-form TO bttaf-grp-avaliacao-form.

            RUN gotokey IN h-boaf018  (INPUT ttaf-grp-avaliacao-form.ep-codigo,
                                       INPUT ttaf-grp-avaliacao-form.cod-grp-avaliacao,
                                       INPUT ttaf-grp-avaliacao-form.seq,
                                       INPUT ttaf-grp-avaliacao-form.nr-versao).
            
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN EMPTYRowObject IN h-boaf018.
                RUN setRecord IN h-boaf018 (INPUT TABLE bttaf-grp-avaliacao-form).
                RUN updateRecord IN h-boaf018.
            END.
            ELSE DO:
                RUN EMPTYRowObject IN h-boaf018.
                RUN newRecord  IN h-boaf018.
                RUN setRecord IN h-boaf018 (INPUT TABLE bttaf-grp-avaliacao-form).
                RUN createRecord IN h-boaf018.
            END.
            DELETE bttaf-grp-avaliacao-form.
        END.
        FOR EACH af-grp-avaliacao-form NO-LOCK
            WHERE af-grp-avaliacao-form.ep-codigo         = RowObject.ep-codigo
            AND   af-grp-avaliacao-form.cod-grp-avaliacao = RowObject.cod-grp-avaliacao
            AND   af-grp-avaliacao-form.nr-versao         = RowObject.nr-versao:
            FIND ttaf-grp-avaliacao-form OF af-grp-avaliacao-form NO-LOCK NO-ERROR.
            IF NOT AVAIL ttaf-grp-avaliacao-form THEN DO:
               RUN repositionRecord IN h-boaf018 (INPUT ROWID(af-grp-avaliacao-form)).
               RUN deleteRecord IN h-boaf018.
            END.
        END.
        IF VALID-HANDLE(h-boaf018) THEN DO:
            DELETE PROCEDURE h-boaf018.
            ASSIGN h-boaf018 = ?.
        END.
        
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
DEF INPUT PARAM TABLE FOR ttaf-grp-avaliacao-form.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstItemContr DBOProgram 
PROCEDURE setConstraintEstItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pi-cod-grp-avaliacao-ini  LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
DEF INPUT PARAM pi-cod-grp-avaliacao-fim  LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
DEF INPUT PARAM pi-nr-grp-versao-ini  LIKE af-grp-avaliacao.nr-versao NO-UNDO.
DEF INPUT PARAM pi-nr-grp-versao-fim  LIKE af-grp-avaliacao.nr-versao NO-UNDO.

ASSIGN i-cod-grp-avaliacao-ini = pi-cod-grp-avaliacao-ini
       i-cod-grp-avaliacao-fim = pi-cod-grp-avaliacao-fim
       i-nr-versao-ini = pi-nr-grp-versao-ini
       i-nr-versao-fim = pi-nr-grp-versao-fim.

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
    
    IF pType = "create" THEN DO:
       FIND bf{&TableName}
           WHERE bf{&TableName}.ep-codigo = RowObject.ep-codigo
           AND   bf{&TableName}.cod-grp-avaliacao = RowObject.cod-grp-avaliacao
           AND   bf{&TableName}.nr-versao = RowObject.nr-versao
           NO-LOCK NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-de-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_de_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-grupo-de-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="7"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-grupo-de-avaliacao"}
            return "NOK":U.
       END.
       IF NOT CAN-FIND(af-versao-avaliacao 
                WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo
                AND   af-versao-avaliacao.nr-versao = RowObject.nr-versao) THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-versao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Vers∆o" *}
                ASSIGN c-lbl-liter-versao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="34659"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-versao"}
                END. 
    END.

    IF pType = "Delete" THEN DO:
        IF CAN-FIND(FIRST af-item-contr-estab WHERE af-item-contr-estab.ep-codigo = RowObject.ep-codigo
                      AND af-item-contr-estab.cod-grp-avaliacao = RowObject.cod-grp-avaliacao
                      AND af-item-contr-estab.nr-versao = RowObject.nr-versao) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-de-avaliacao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_de_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-grupo-de-avaliacao-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-x-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_x_Estabelecimento" *}
            ASSIGN c-lbl-liter-item-x-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                       &ErrorNumber="5"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                       &ErrorParameters="c-lbl-liter-grupo-de-avaliacao-2 + '~~~~' + c-lbl-liter-item-x-estabelecimento"}  
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

