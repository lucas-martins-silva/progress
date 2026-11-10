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
{include/i-prgvrs.i BOAD250 2.00.00.010 } /*** "010010" 24/08/2026 14:36:24 ***/
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
&GLOBAL-DEFINE DBOName BOAD250
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tab-ocor
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
{adbo/boad250.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-grupo-ini like estabelec.cod-estabel.
def var c-grupo-fim like estabelec.cod-estabel.
DEF VAR c-estab     LIKE estabelec.cod-estabel.
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
        WHEN "c-campo[1]":U THEN ASSIGN pFieldValue = RowObject.c-campo[1].
        WHEN "c-campo[2]":U THEN ASSIGN pFieldValue = RowObject.c-campo[2].
        WHEN "c-campo[3]":U THEN ASSIGN pFieldValue = RowObject.c-campo[3].
        WHEN "c-campo[4]":U THEN ASSIGN pFieldValue = RowObject.c-campo[4].
        WHEN "c-campo[5]":U THEN ASSIGN pFieldValue = RowObject.c-campo[5].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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
        WHEN "da-campo[1]":U THEN ASSIGN pFieldValue = RowObject.da-campo[1].
        WHEN "da-campo[2]":U THEN ASSIGN pFieldValue = RowObject.da-campo[2].
        WHEN "da-campo[3]":U THEN ASSIGN pFieldValue = RowObject.da-campo[3].
        WHEN "da-campo[4]":U THEN ASSIGN pFieldValue = RowObject.da-campo[4].
        WHEN "da-campo[5]":U THEN ASSIGN pFieldValue = RowObject.da-campo[5].
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
        WHEN "de-campo[1]":U THEN ASSIGN pFieldValue = RowObject.de-campo[1].
        WHEN "de-campo[2]":U THEN ASSIGN pFieldValue = RowObject.de-campo[2].
        WHEN "de-campo[3]":U THEN ASSIGN pFieldValue = RowObject.de-campo[3].
        WHEN "de-campo[4]":U THEN ASSIGN pFieldValue = RowObject.de-campo[4].
        WHEN "de-campo[5]":U THEN ASSIGN pFieldValue = RowObject.de-campo[5].
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
        WHEN "cod-ocor":U THEN ASSIGN pFieldValue = RowObject.cod-ocor.
        WHEN "cod-tab":U THEN ASSIGN pFieldValue = RowObject.cod-tab.
        WHEN "i-campo[1]":U THEN ASSIGN pFieldValue = RowObject.i-campo[1].
        WHEN "i-campo[2]":U THEN ASSIGN pFieldValue = RowObject.i-campo[2].
        WHEN "i-campo[3]":U THEN ASSIGN pFieldValue = RowObject.i-campo[3].
        WHEN "i-campo[4]":U THEN ASSIGN pFieldValue = RowObject.i-campo[4].
        WHEN "i-campo[5]":U THEN ASSIGN pFieldValue = RowObject.i-campo[5].
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-tab
               retorna valor do campo cod-ocor
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-tab LIKE tab-ocor.cod-tab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ocor LIKE tab-ocor.cod-ocor NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-tab = RowObject.cod-tab
           pcod-ocor = RowObject.cod-ocor.

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
        WHEN "l-campo[1]":U THEN ASSIGN pFieldValue = RowObject.l-campo[1].
        WHEN "l-campo[2]":U THEN ASSIGN pFieldValue = RowObject.l-campo[2].
        WHEN "l-campo[3]":U THEN ASSIGN pFieldValue = RowObject.l-campo[3].
        WHEN "l-campo[4]":U THEN ASSIGN pFieldValue = RowObject.l-campo[4].
        WHEN "l-campo[5]":U THEN ASSIGN pFieldValue = RowObject.l-campo[5].
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-tab
               recebe valor do campo cod-ocor
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pGrupo AS CHAR LABEL "Grupo" FORMAT "x(3)" NO-UNDO.
    
    FIND FIRST bftab-ocor WHERE 
        bftab-ocor.cod-ocor = 300 AND 
        bftab-ocor.log-1    = YES AND 
        SUBSTR(bftab-ocor.char-1,1,3) = pGrupo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftab-ocor THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftab-ocor)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryFaixaGrupo DBOProgram 
PROCEDURE openqueryFaixaGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                    {&TableName}.cod-ocor = 300       AND
                                    {&TableName}.log-1 = YES          and
                             substr({&TableName}.char-1,1,3) >= c-grupo-ini and
                             substr({&TableName}.char-1,1,3) <= c-grupo-fim NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openquerymain DBOProgram 
PROCEDURE openquerymain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                    {&TableName}.cod-ocor = 300 AND
                                    {&TableName}.log-1 = YES   NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.
                                                                              
                                                                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaGrupo DBOProgram 
PROCEDURE setConstraintFaixaGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-grupo-ini as char.
   def input param p-grupo-fim as char.

   assign c-grupo-ini = p-grupo-ini
          c-grupo-fim = p-grupo-fim.

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryTaxaSiscomex DBOProgram 
PROCEDURE openqueryTaxaSiscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                    {&TableName}.cod-tab     = 612       AND
                                    {&TableName}.c-campo[1]  = c-estab  NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTaxaSiscomex DBOProgram 
PROCEDURE setConstraintTaxaSiscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-estab like estabelec.cod-estabel NO-UNDO.
   
   assign c-estab = p-estab.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteLinkedEstablishments DBOProgram
PROCEDURE deleteLinkedEstablishments :
/*------------------------------------------------------------------------------
  Purpose: Excluir a lista de estabelecimentos vinculados antes de atualizar a listagem
  Parameters: cGroupCode   -> Codigo do Grupo
              cDeletedList -> Lista de estabelecimentos excluidos
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cGroupCode   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER cDeletedList AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cEstablishmentCode AS CHARACTER NO-UNDO.

    ASSIGN cDeletedList = "":U.

    FOR EACH {&TableName} EXCLUSIVE-LOCK
        WHERE {&TableName}.cod-ocor = 300
          AND {&TableName}.log-1    = NO
          AND TRIM({&TableName}.char-1) = TRIM(cGroupCode):

        ASSIGN cEstablishmentCode = TRIM({&TableName}.char-2)
               cDeletedList       = IF cDeletedList = "":U THEN cEstablishmentCode
                                    ELSE cDeletedList + ",":U + cEstablishmentCode.
        DELETE {&TableName}.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLinkedEstablishment DBOProgram
PROCEDURE createLinkedEstablishment :
/*------------------------------------------------------------------------------
  Purpose: Criar estabelecimento vinculado ao grupo de centralizacao SPED
  Parameters: pcGroupCode         -> Codigo do grupo
              pcEstablishmentCode -> Codigo do estabelecimento
              plIsHeadOffice      -> Indica matriz
              piNextCodTab        -> Proximo codigo da tab-ocor
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcGroupCode         AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER pcEstablishmentCode AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER plIsHeadOffice      AS LOGICAL   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER piNextCodTab        AS INTEGER   NO-UNDO.

    IF piNextCodTab <= 0 THEN DO:
        ASSIGN piNextCodTab = 1.

        FIND LAST {&TableName} USE-INDEX codigo
            WHERE {&TableName}.cod-ocor = 300 NO-LOCK NO-ERROR.
        IF AVAILABLE {&TableName} THEN
            ASSIGN piNextCodTab = {&TableName}.cod-tab + 1.
    END.

    CREATE {&TableName}.
    ASSIGN {&TableName}.cod-tab  = piNextCodTab
           {&TableName}.cod-ocor = 300
           {&TableName}.log-1    = NO
           {&TableName}.log-2    = plIsHeadOffice
           {&TableName}.char-1   = pcGroupCode
           {&TableName}.char-2   = pcEstablishmentCode
           piNextCodTab          = piNextCodTab + 1.

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

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

