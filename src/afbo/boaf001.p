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
{include/i-prgvrs.i BOAF001 2.00.00.010 } /*** "010010" 23/11/2023 16:19:37  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boaf001
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-controle
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}

/*Pre-processadores para acelerador de implantaá∆o*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver [ {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/

{afbo/boaf001.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-nr-controle     like af-controle.nr-controle no-undo.
def var i-nr-controle-ini like af-controle.nr-controle no-undo.
def var i-nr-controle-fim like af-controle.nr-controle no-undo.

DEFINE VARIABLE hDBOaf011 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOaf013 AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boaf021 AS HANDLE     NO-UNDO.
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
         HEIGHT             = 19.08
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

/* Cria Controles Padr‰es */
if not can-find(first af-controle where
                      af-controle.ep-codigo = i-ep-codigo-usuario) then do:
   run criaControlesPadroes.
end.

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
    IF NOT VALID-HANDLE(h-boaf021) THEN
       RUN afbo/boaf021.p PERSISTENT SET h-boaf021.  

    RUN openQueryStatic IN h-boaf021 (INPUT "Main":U) NO-ERROR.

    FOR EACH af-controle-result NO-LOCK
       WHERE af-controle-result.ep-codigo     = RowObject.ep-codigo
         AND af-controle-result.nr-controle   = RowObject.nr-controle:

        RUN repositionRecord IN h-boaf021 (INPUT ROWID(af-controle-result)).

        RUN deleteRecord IN h-boaf021.
    END.
    DELETE PROCEDURE h-boaf021.
    ASSIGN h-boaf021 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

 
    if rowObject.padrao then
        {method/svc/errors/inserr.i
            &ErrorNumber="52860"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="''"}

 
    FIND FIRST af-familia-contr-form
        WHERE  af-familia-contr-form.ep-codigo = i-ep-codigo-usuario
        AND    af-familia-contr-form.nr-controle = rowObject.nr-controle
        NO-LOCK NO-ERROR.
    IF AVAIL af-familia-contr-form THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ponto-de-controle AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ponto_de_controle" *}
        ASSIGN c-lbl-liter-ponto-de-controle = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-familia AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "fam°lia" *}
        ASSIGN c-lbl-liter-familia = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="8699"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-ponto-de-controle + '~~~~' + c-lbl-liter-familia"}

    END.
    FIND FIRST af-item-contr-form
        WHERE  af-item-contr-form.ep-codigo = i-ep-codigo-usuario
        AND    af-item-contr-form.nr-controle = rowObject.nr-controle
        NO-LOCK NO-ERROR.
    IF AVAIL af-item-contr-form THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ponto-de-controle-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ponto_de_controle" *}
        ASSIGN c-lbl-liter-ponto-de-controle-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="8699"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-ponto-de-controle-2 + '~~~~' + c-lbl-liter-item"}

    END.
    FIND FIRST af-item-contr-estab-form
        WHERE  af-item-contr-estab-form.ep-codigo = i-ep-codigo-usuario
        AND    af-item-contr-estab-form.nr-controle = rowObject.nr-controle
        NO-LOCK NO-ERROR.
    IF AVAIL af-item-contr-estab-form THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ponto-de-controle-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ponto_de_controle" *}
        ASSIGN c-lbl-liter-ponto-de-controle-3 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-item-x-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_X_Estabelecimento" *}
        ASSIGN c-lbl-liter-item-x-estabelecimento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="8699"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-ponto-de-controle-3 + '~~~~' + c-lbl-liter-item-x-estabelecimento"}

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaControlesPadroes DBOProgram 
PROCEDURE criaControlesPadroes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-nr LIKE af-controle.nr-controle NO-UNDO.
DEFINE VARIABLE i-ep LIKE af-controle.ep-codigo   NO-UNDO.

IF NOT VALID-HANDLE(hDBOaf011) THEN
   RUN afbo/boaf011.p persistent set hDBOaf011.
RUN piCriaVariavelPadrao IN hDBOaf011.
IF VALID-HANDLE(hDBOaf011) THEN
   DELETE PROCEDURE hDBOaf011.

IF NOT VALID-HANDLE(hDBOaf013) THEN
   RUN afbo/boaf013.p persistent set hDBOaf013.

RUN piCriaFormulaPadrao IN hDBOaf013.
RUN getRowErrors in hDBOaf013 (OUTPUT TABLE RowErrors).

IF VALID-HANDLE(hDBOaf013) THEN DO:
    DELETE PROCEDURE hDBOaf013.
    ASSIGN hDBOaf013 = ?.
END.  

IF RETURN-VALUE = "NOK":U THEN DO:      
    RETURN "NOK":U.
END.  

RUN setDefaults (OUTPUT i-ep, 
                 OUTPUT i-nr).

create af-controle.
assign af-controle.ep-codigo     = i-ep-codigo-usuario
       af-controle.nr-controle   = i-nr
       af-controle.descricao     = "Qualidade"
       af-controle.padrao        = YES
       af-controle.log-especifico = NO
       af-controle.log-formula   = NO
       af-controle.dt-alter      = TODAY
       af-controle.dt-implantacao = TODAY
       af-controle.usuar-alter     = c-seg-usuario
       af-controle.hora-alter    = STRING(TIME,"HH:MM:SS").    

create af-controle.
assign i-nr = i-nr + 1
       af-controle.ep-codigo     = i-ep-codigo-usuario
       af-controle.nr-controle   = i-nr
       af-controle.descricao     = "Quantidade"
       af-controle.padrao        = YES
       af-controle.log-especifico = NO
       af-controle.log-formula   = NO
       af-controle.dt-alter      = TODAY
       af-controle.dt-implantacao = TODAY
       af-controle.usuar-alter     = c-seg-usuario
       af-controle.hora-alter    = STRING(TIME,"HH:MM:SS").

create af-controle.
assign i-nr = i-nr + 1
       af-controle.ep-codigo     = i-ep-codigo-usuario
       af-controle.nr-controle   = i-nr
       af-controle.descricao     = "Preáo"
       af-controle.padrao        = YES
       af-controle.log-especifico = NO
       af-controle.log-formula   = NO
       af-controle.dt-alter      = TODAY
       af-controle.dt-implantacao = TODAY
       af-controle.usuar-alter     = c-seg-usuario
       af-controle.hora-alter    = STRING(TIME,"HH:MM:SS").


create af-controle.
assign i-nr = i-nr + 1
       af-controle.ep-codigo     = i-ep-codigo-usuario
       af-controle.nr-controle   = i-nr
       af-controle.descricao     = "Data Entrega"
       af-controle.padrao        = YES
       af-controle.log-especifico = NO
       af-controle.log-formula   = NO
       af-controle.dt-alter      = TODAY
       af-controle.dt-implantacao = TODAY
       af-controle.usuar-alter     = c-seg-usuario
       af-controle.hora-alter    = STRING(TIME,"HH:MM:SS").


FOR EACH af-controle
    WHERE af-controle.ep-codigo = i-ep-codigo-usuario EXCLUSIVE-LOCK:
    FIND FIRST af-formula
        WHERE af-formula.ep-codigo = i-ep-codigo-usuario
        AND   af-formula.descricao = af-controle.descricao
        AND   af-formula.padrao    = YES 
        NO-LOCK NO-ERROR.
    IF AVAIL af-formula THEN
       ASSIGN af-controle.log-formula = YES
              af-controle.cod-formula = af-formula.cod-formula.
END.

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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "cod-grp-resp":U THEN ASSIGN pFieldValue = RowObject.cod-grp-resp.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGrupoRespon DBOProgram 
PROCEDURE getGrupoRespon :
/*------------------------------------------------------------------------------
  Purpose:     Retorna Descricao  Grupo responsavel
  Parameters:  
               recebe codigo do Grupo
               retorna descricao do Grupo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNrControle     LIKE af-controle.nr-controle      NO-UNDO.
    DEFINE OUTPUT PARAMETER pGrpRespon      LIKE af-controle.cod-grp-resp     NO-UNDO.
    DEFINE OUTPUT PARAMETER pLogPerVariavel LIKE af-controle.log-per-variavel NO-UNDO.
    DEFINE OUTPUT PARAMETER pIndTipoPeriodo LIKE af-controle.ind-tipo-periodo NO-UNDO.

    FOR FIRST af-controle FIELDS (cod-grp-resp log-per-variavel ind-tipo-periodo)
        WHERE af-controle.nr-controle = pNrControle NO-LOCK: END.
    IF  AVAIL af-controle THEN
        ASSIGN pGrpRespon      = af-controle.cod-grp-resp
               pLogPerVariavel = af-controle.log-per-variavel
               pIndTipoPeriodo = af-controle.ind-tipo-periodo.    
    ELSE DO:
        ASSIGN pGrpRespon = "".

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
        WHEN "i-nr-controle":U THEN ASSIGN pFieldValue = RowObject.nr-controle.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-codigo
  Parameters:  
               retorna valor do campo cod-gr-cli
               retorna valor do campo tp-natur
               retorna valor do campo fm-canal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-controle LIKE af-controle.nr-controle NO-UNDO.


    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-controle = RowObject.nr-controle.

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
        WHEN "padrao":U THEN ASSIGN pFieldValue = RowObject.padrao.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToGrupoResp DBOProgram 
PROCEDURE goToGrupoResp :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ch-codigo
  Parameters:  
               recebe valor do campo cod-gr-cli
               recebe valor do campo tp-natur
               recebe valor do campo fm-canal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodGrpResp LIKE af-controle.cod-grp-resp NO-UNDO.
    
    IF pCodGrpResp = "" THEN
        RETURN "OK":U.
    FIND FIRST af-grp-responsavel
         WHERE af-grp-responsavel.ep-codigo = i-ep-codigo-usuario
           and af-grp-responsavel.cod-grp-resp = pCodGrpResp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE af-grp-responsavel THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-controle)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ch-codigo
  Parameters:  
               recebe valor do campo cod-gr-cli
               recebe valor do campo tp-natur
               recebe valor do campo fm-canal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-controle LIKE af-controle.nr-controle NO-UNDO.

    FIND FIRST bfaf-controle
         WHERE bfaf-controle.ep-codigo = i-ep-codigo-usuario
           and bfaf-controle.nr-controle = pnr-controle NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-controle THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-controle)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrControle DBOProgram 
PROCEDURE openQueryByNrControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario
                                 AND {&TableName}.nr-controle >= i-nr-controle-ini
                                 AND {&TableName}.nr-controle <= i-nr-controle-fim NO-LOCK INDEXED-REPOSITION.


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

   
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario NO-LOCK INDEXED-REPOSITION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaPeriodoAvaliacao DBOProgram 
PROCEDURE piHabilitaPeriodoAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-controle LIKE af-controle.nr-controle NO-UNDO.
    DEFINE OUTPUT PARAMETER pHabilita  AS LOGICAL NO-UNDO.

    FIND FIRST  af-controle 
          WHERE af-controle.nr-controle = pnr-controle NO-LOCK NO-ERROR.
    IF AVAIL af-controle THEN DO:
        IF af-controle.padrao         = YES OR
           af-controle.log-especifico = YES OR
           af-controle.log-formula    = YES THEN
            ASSIGN pHabilita = NO.
        ELSE
            ASSIGN pHabilita = YES.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaGrupoAvaliacao DBOProgram 
PROCEDURE piRetornaGrupoAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:                                  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-controle LIKE af-controle.nr-controle NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-grp-resp LIKE af-controle.cod-grp-resp NO-UNDO.

    FIND FIRST  af-controle 
          WHERE af-controle.nr-controle = pnr-controle NO-LOCK NO-ERROR.
    IF AVAIL af-controle THEN 
        ASSIGN pcod-grp-resp = af-controle.cod-grp-resp.
    ELSE
        ASSIGN pcod-grp-resp = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrControle DBOProgram 
PROCEDURE setConstraintNrControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nr-controle-ini   LIKE af-controle.nr-controle NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-controle-fim   LIKE af-controle.nr-controle NO-UNDO.
   
    ASSIGN i-nr-controle-ini = p-nr-controle-ini
           i-nr-controle-fim = p-nr-controle-fim.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
def output param p-ep-codigo like af-controle.ep-codigo no-undo.
def output param p-nr-controle like af-controle.nr-controle no-undo.

def buffer bfaf-controle for af-controle.
find last bfaf-controle 
    WHERE bfaf-controle.ep-codigo = i-ep-codigo-usuario no-lock no-error.

if avail bfaf-controle and (bfaf-controle.nr-controle < 999999) then
   assign p-nr-controle = bfaf-controle.nr-controle + 1.
ELSE p-nr-controle = 1.

assign p-ep-codigo = i-ep-codigo-usuario.
 
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

    IF pType = "CREATE" THEN DO:
        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.ep-codigo = rowObject.ep-codigo and
                   bf{&TableName}.nr-controle = rowObject.nr-controle NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-ponto-de-controle-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Controle" *}
            ASSIGN c-lbl-liter-ponto-de-controle-4 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="1"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-ponto-de-controle-4"}
            END. 


    END.
    
    IF pType = "create" OR pType = "Update" THEN DO:
        
        IF NOT RowObject.padrao THEN DO:
            IF  NOT CAN-FIND(FIRST af-grp-responsavel
                             WHERE af-grp-responsavel.ep-codigo    = i-ep-codigo-usuario
                             AND   af-grp-responsavel.cod-grp-resp = RowObject.cod-grp-resp) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-grupo-responsavel-informado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Grupo_Respons†vel_informado" *}
                ASSIGN c-lbl-liter-grupo-responsavel-informado = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="Error"
                               &ErrorParameters="c-lbl-liter-grupo-responsavel-informado"} 
            END.
        END.        

       IF RowObject.descricao = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-descricao-do-ponto-de-controle AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descriá∆o_do_Ponto_de_Controle" *}
          ASSIGN c-lbl-liter-descricao-do-ponto-de-controle = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27223"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-descricao-do-ponto-de-controle"}
       END.
       IF RowObject.log-especifico THEN DO:
          IF SEARCH(RowObject.programa) = ? THEN DO:
             {method/svc/errors/inserr.i
                  &ErrorNumber="7712"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="''"}
          END.
       END.
       IF RowObject.log-formula THEN DO:
           IF NOT CAN-FIND(FIRST af-formula NO-LOCK
                    WHERE af-formula.ep-codigo = rowObject.ep-codigo
                    AND   af-formula.cod-formula = rowObject.cod-formula) THEN DO:           
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-formula AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "F¢rmula" *}
             ASSIGN c-lbl-liter-formula = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                  &ErrorNumber="42806"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-formula"}
          END.
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

