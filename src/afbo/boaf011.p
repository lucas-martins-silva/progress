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
{include/i-prgvrs.i BOAF011 2.00.00.003 } /*** "010003" 23/11/2023 16:19:38  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAF011
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-variavel
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{afbo/boaf011.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{utp/ut-glob.i}

DEF VAR c-cod-variavel-ini LIKE af-variavel.cod-variavel NO-UNDO.
DEF VAR c-cod-variavel-fim LIKE af-variavel.cod-variavel NO-UNDO.
DEF VAR c-descricao-ini    LIKE af-variavel.descricao    NO-UNDO.
DEF VAR c-descricao-fim    LIKE af-variavel.descricao    NO-UNDO.
DEF VAR l-padrao           LIKE af-variavel.padrao       NO-UNDO.
DEF VAR l-especifica       LIKE af-variavel.log-especifico NO-UNDO.

DEFINE VARIABLE h-boaf012    AS HANDLE     NO-UNDO.

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
         HEIGHT             = 17.92
         WIDTH              = 40.29.
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
    IF NOT VALID-HANDLE(h-boaf012) THEN
       RUN afbo/boaf012.p PERSISTENT SET h-boaf012.  
    RUN openQueryStatic IN h-boaf012 (INPUT "Main":U) NO-ERROR.
    FOR EACH af-variavel-valor NO-LOCK
        WHERE af-variavel-valor.ep-codigo    = RowObject.ep-codigo
        AND   af-variavel-valor.cod-variavel = RowObject.cod-variavel:
        RUN repositionRecord IN h-boaf012 (INPUT ROWID(af-variavel-valor)).
        RUN deleteRecord IN h-boaf012.
    END.
    DELETE PROCEDURE h-boaf012.
    ASSIGN h-boaf012 = ?.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-variavel":U THEN ASSIGN pFieldValue = RowObject.cod-variavel.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "programa":U THEN ASSIGN pFieldValue = RowObject.programa.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ep-var
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-variavel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-variavel.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-variavel LIKE af-variavel.cod-variavel NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-variavel = RowObject.cod-variavel.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-especifico":U THEN ASSIGN pFieldValue = RowObject.log-especifico.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice ep-var
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-variavel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-variavel.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-variavel LIKE af-variavel.cod-variavel NO-UNDO.

    FIND FIRST bfaf-variavel WHERE 
        bfaf-variavel.ep-codigo = pep-codigo AND 
        bfaf-variavel.cod-variavel = pcod-variavel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-variavel THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-variavel)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodVar DBOProgram 
PROCEDURE openQueryCodVar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo     = i-ep-codigo-usuario 
                               AND   {&TableName}.cod-variavel >= c-cod-variavel-ini
                               AND   {&TableName}.cod-variavel <= c-cod-variavel-fim
                               NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDesc DBOProgram 
PROCEDURE openQueryDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo     = i-ep-codigo-usuario 
                               AND   {&TableName}.descricao >= c-descricao-ini
                               AND   {&TableName}.descricao <= c-descricao-fim
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySel DBOProgram 
PROCEDURE openQuerySel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF l-padrao THEN DO:
       OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo      = i-ep-codigo-usuario 
                               AND   {&TableName}.cod-variavel  >= c-cod-variavel-ini
                               AND   {&TableName}.cod-variavel  <= c-cod-variavel-fim
                               AND   {&TableName}.descricao     >= c-descricao-ini
                               AND   {&TableName}.descricao     <= c-descricao-fim
                               AND   {&TableName}.padrao         = YES
                               NO-LOCK INDEXED-REPOSITION.
    END.
    IF NOT l-padrao AND l-especifica THEN DO:
       OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo      = i-ep-codigo-usuario 
                               AND   {&TableName}.cod-variavel  >= c-cod-variavel-ini
                               AND   {&TableName}.cod-variavel  <= c-cod-variavel-fim
                               AND   {&TableName}.descricao     >= c-descricao-ini
                               AND   {&TableName}.descricao     <= c-descricao-fim
                               AND   {&TableName}.log-especifico = YES
                               NO-LOCK INDEXED-REPOSITION.
    END.
    IF NOT l-padrao AND NOT l-especifica THEN DO:
       OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo      = i-ep-codigo-usuario 
                               AND   {&TableName}.cod-variavel  >= c-cod-variavel-ini
                               AND   {&TableName}.cod-variavel  <= c-cod-variavel-fim
                               AND   {&TableName}.descricao     >= c-descricao-ini
                               AND   {&TableName}.descricao     <= c-descricao-fim
                               NO-LOCK INDEXED-REPOSITION.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaVar DBOProgram 
PROCEDURE piCriaVar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-variavel LIKE af-variavel.cod-variavel NO-UNDO.
DEFINE INPUT PARAMETER pdescricao    LIKE af-variavel.descricao NO-UNDO.
DEFINE INPUT PARAMETER pnarrativa    LIKE af-variavel.narrativa NO-UNDO.

FIND af-variavel
    WHERE af-variavel.ep-codigo    = i-ep-codigo-usuario
    AND   af-variavel.cod-variavel = pcod-variavel EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL af-variavel THEN DO:  
    CREATE af-variavel.
    ASSIGN af-variavel.ep-codigo       = i-ep-codigo-usuario
           af-variavel.cod-variavel    = pcod-variavel.
END.
ASSIGN af-variavel.descricao       = pdescricao
       af-variavel.dt-alter        = TODAY
       af-variavel.dt-implantacao  = TODAY
       af-variavel.hora-alter      = STRING(TIME,"HH:MM:SS")
       af-variavel.log-especifico  = NO
       af-variavel.narrativa       = pnarrativa
       af-variavel.padrao          = YES
       af-variavel.programa        = ""
       af-variavel.usuar-alter     = c-seg-usuario.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaVariavelPadrao DBOProgram 
PROCEDURE piCriaVariavelPadrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN piCriaVar (INPUT "PCQ00001",
               INPUT "Quantidade Aprovada CQ",
               INPUT "Quantidade aprovada no per¡odo registrada no m¢dulo de Controle da Qualidade. Considera todas as fichas de inspe‡Æo gerada atrav‚s do recebimento.").


RUN piCriaVar (INPUT "PCQ00002",
               INPUT "Quantidade Perda CQ",
               INPUT "Quantidade de perda no per¡odo registrada no m¢dulo de Controle da Qualidade. Considera todas as fichas de inspe‡Æo gerada atrav‚s do recebimento.").


RUN piCriaVar (INPUT "PCQ00003",
               INPUT "Quantidade Aprovada Condicional CQ",
               INPUT "Quantidade aprovada condicionalmente no per¡odo registrada no m¢dulo de Controle da Qualidade. Considera todas as fichas de inspe‡Æo gerada atrav‚s do recebimento.").

RUN piCriaVar (INPUT "PCQ00004",
               INPUT "Quantidade Rejeitada CQ",
               INPUT "Quantidade rejeitada no per¡odo registrada no m¢dulo de Controle da Qualidade. Considera todas as fichas de inspe‡Æo gerada atrav‚s do recebimento.").

RUN piCriaVar (INPUT "PCQ00005",
               INPUT "Quantidade Devolvida sem CQ",
               INPUT "Quantidade devolvida atrav‚s do m¢dulo de Faturamento. Considera apenas as notas fiscais de devolu‡Æo que nÆo est  relacionada a uma nota fiscal de entrada que foi inspecionada pelo Controle da Qualidade.").

RUN piCriaVar (INPUT "PCQ00006",
               INPUT "Quantidade Devolvida Total",
               INPUT "Quantidade devolvida atrav‚s do m¢dulo de Faturamento. Considera todas as notas fiscais de devolu‡Æo do per¡odo.").

RUN piCriaVar (INPUT "PCQ00007",
               INPUT "Quantidade Recebida Total",
               INPUT "Quantidade total recebida. Considera todas as notas fiscais de entrada do per¡odo.").

RUN piCriaVar (INPUT "PCQ00008",
               INPUT "N£mero Total Roteiro Inspe‡Æo",
               INPUT "N£mero total de roteiro de inspe‡Æo no per¡odo.").

RUN piCriaVar (INPUT "PCQ00009",
               INPUT "N£mero Total Recebimento",
               INPUT "N£mero total recebimento no per¡odo com notas fiscais de entrada.").

RUN piCriaVar (INPUT "PCQ00010",
               INPUT "N£mero Devolu‡Æo sem CQ",
               INPUT "N£mero de devolu‡äes no per¡odo com notas fiscais de devolu‡Æo. Considera apenas as notas fiscais de devolu‡Æo que nÆo est  relacionada a uma nota fiscal de entrada que foi inspecionada pelo Controle da Qualidade.").

RUN piCriaVar (INPUT "PCQ00011",
               INPUT "N£mero Total Devolu‡Æo",
               INPUT "N£mero total de devolu‡äes no per¡odo com notas fiscais de devolu‡Æo.").

RUN piCriaVar (INPUT "PCQ00012",
               INPUT "Dem‚rito",
               INPUT "Percentual de dem‚rito informado no relacionamento Item x Estabelecimento x Fornecedor.").

RUN piCriaVar (INPUT "PNRQT001",
               INPUT "N£mero Recebimento Quantidade Correta",
               INPUT "N£mero de recebimento com quantidade correta no per¡odo. Considerando a varia‡Æo parametrizada no relacionamento item/fornecedor/estabelecimento (AF0105 - Itens X Estab Avalia‡Æo fornecedores).").

RUN piCriaVar (INPUT "PNRQT002",
               INPUT "N£mero Recebimento Quantidade Incorreta",
               INPUT "N£mero de recebimento com quantidade incorreta no per¡odo.").

RUN piCriaVar (INPUT "PNRQT003",
               INPUT "N£mero Total Recebimento",
               INPUT "N£mero total de  recebimento no per¡odo.").

RUN piCriaVar (INPUT "PNRPR001",
               INPUT "N£mero Recebimento Pre‡o Correto",
               INPUT "N£mero de recebimento com pre‡o correto no per¡odo. Considerando a varia‡Æo parametrizada no relacionamento item/fornecedor/estabelecimento (AF0105 - Itens X Estab Avalia‡Æo fornecedores).").

RUN piCriaVar (INPUT "PNRPR002",
               INPUT "N£mero Recebimento Pre‡o Incorreto",
               INPUT "N£mero de recebimento com pre‡o incorreto no per¡odo.").

RUN piCriaVar (INPUT "PNRPR003",
               INPUT "N£mero Total Recebimento",
               INPUT "N£mero total de  recebimento no per¡odo.").

RUN piCriaVar (INPUT "PNRDT001",
               INPUT "N£mero Recebimento Data Correta",
               INPUT "N£mero de recebimento na data correta no per¡odo. Considerando a varia‡Æo parametrizada no relacionamento item/fornecedor/estabelecimento (AF0105 - Itens X Estab Avalia‡Æo fornecedores).").

RUN piCriaVar (INPUT "PNRDT002",
               INPUT "N£mero Recebimento Data Incorreta",
               INPUT "N£mero de recebimento na data incorreto no per¡odo.").

RUN piCriaVar (INPUT "PNRDT003",
               INPUT "N£mero Total Recebimento",
               INPUT "N£mero total de  recebimento no per¡odo.").

RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodVariavel DBOProgram 
PROCEDURE setConstraintCodVariavel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodVariavelIni LIKE af-variavel.cod-variavel NO-UNDO.
    DEFINE INPUT PARAMETER pCodVariavelFim LIKE af-variavel.cod-variavel NO-UNDO.

    ASSIGN c-cod-variavel-ini = pCodVariavelIni
           c-cod-variavel-fim = pCodVariavelFim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDescricaoIni LIKE af-variavel.Descricao NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoFim LIKE af-variavel.Descricao NO-UNDO.

    ASSIGN c-Descricao-ini = pDescricaoIni
           c-Descricao-fim = pDescricaoFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSel DBOProgram 
PROCEDURE setConstraintSel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodvariavelIni LIKE af-variavel.cod-variavel NO-UNDO.
    DEFINE INPUT PARAMETER pCodvariavelFim LIKE af-variavel.cod-variavel NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoIni  LIKE af-variavel.Descricao NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoFim  LIKE af-variavel.Descricao NO-UNDO.
    DEFINE INPUT PARAMETER pPadrao        LIKE af-variavel.padrao NO-UNDO.
    DEFINE INPUT PARAMETER pespecifica    LIKE af-variavel.log-especifico NO-UNDO.


    ASSIGN c-cod-variavel-ini = pCodvariavelIni
           c-cod-variavel-fim = pCodvariavelFim
           c-Descricao-ini    = pDescricaoIni
           c-Descricao-fim    = pDescricaoFim
           l-padrao           = pPadrao
           l-especifica       = pEspecifica.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-var AS INTEGER    NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "create" THEN DO:
       FIND bf{&TableName}
           WHERE bf{&TableName}.ep-codigo = RowObject.ep-codigo
           AND   bf{&TableName}.cod-variavel = RowObject.cod-variavel
           NO-LOCK NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-variavel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vari vel" *}
            ASSIGN c-lbl-liter-variavel = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="7"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-variavel"}
            return "NOK":U.
       END. 
       IF RowObject.cod-variavel = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-codigo-da-variavel AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "C¢digo_da_vari vel" *}
          ASSIGN c-lbl-liter-codigo-da-variavel = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27223"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-codigo-da-variavel"}
       END.
       IF RowObject.cod-variavel = "0" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-codigo-da-variavel-2 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "C¢digo_da_vari vel" *}
          ASSIGN c-lbl-liter-codigo-da-variavel-2 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-caso-contrario-pode-causar-pro AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Caso_contr rio,_pode_causar_problemas_na_valida‡Æo_da_f¢rmula" *}
          ASSIGN c-lbl-liter-caso-contrario-pode-causar-pro = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="52867"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-codigo-da-variavel-2 + '~~~~' +  c-lbl-liter-caso-contrario-pode-causar-pro"}
       END.
       ELSE DO:
           ASSIGN i-var = int(RowObject.cod-variavel) NO-ERROR.
           IF i-var <> 0 THEN DO:
               {method/svc/errors/inserr.i
                       &ErrorNumber="52868"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                        &ErrorParameters="''"}
           END.
       END.
    END.
    IF pType = "create" OR pType = "Update" THEN DO:
       IF RowObject.descricao = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-descricao-da-variavel AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descri‡Æo_da_vari vel" *}
          ASSIGN c-lbl-liter-descricao-da-variavel = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27223"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-descricao-da-variavel"}
       END.
       IF RowObject.log-especifico = TRUE THEN DO:
          IF SEARCH(RowObject.programa) = ? OR TRIM(SEARCH(RowObject.programa)) = "" THEN DO:
             {method/svc/errors/inserr.i
                  &ErrorNumber="7712"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="''"}
          END.
       END.
    END.

    IF pType = "Delete" THEN DO:
       IF  rowObject.padrao THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-variavel-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Vari vel" *}
           ASSIGN c-lbl-liter-variavel-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
            &ErrorNumber="25561"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-variavel-2"}
       END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
        
    IF pType <> "Delete" THEN RUN piAtualizaAlteracao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

