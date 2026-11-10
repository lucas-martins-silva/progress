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
{include/i-prgvrs.i BOAF013 2.00.00.005 } /*** "010005" 29/05/2025 12:29:13 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF013
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-formula
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
{afbo/boaf013.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE h-cdapi020 AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boaf011  AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boaf023 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE      NO-UNDO.

{utp/ut-glob.i}
{cdp/cdapi020.i}
{cdp/cd0666.i}

DEF VAR c-cod-formula-ini LIKE af-formula.cod-formula NO-UNDO.
DEF VAR c-cod-formula-fim LIKE af-formula.cod-formula NO-UNDO.
DEF VAR i-nr-versao-ini   LIKE af-formula.nr-versao   NO-UNDO.
DEF VAR i-nr-versao-fim   LIKE af-formula.nr-versao   NO-UNDO.
DEF VAR c-descricao-ini    LIKE af-formula.descricao    NO-UNDO.
DEF VAR c-descricao-fim    LIKE af-formula.descricao    NO-UNDO.
DEF VAR de-resultado      AS DECIMAL NO-UNDO.

DEF TEMP-TABLE ttAf-formula NO-UNDO LIKE af-formula
    FIELD r-rowid           AS ROWID
    FIELD ini-valid         AS CHAR FORMAT "x(12)"
    FIELD fim-valid         AS CHAR FORMAT "x(12)"
    FIELD c-padrao          AS CHAR FORMAT "x(12)"
    FIELD c-dt-implantacao  AS CHAR FORMAT "x(12)"
    FIELD c-dt-alter        AS CHAR FORMAT "x(12)"
    FIELD c-hora-alter      AS CHAR FORMAT "x(12)".

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

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
         HEIGHT             = 9.83
         WIDTH              = 48.29.
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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "expressao":U THEN ASSIGN pFieldValue = RowObject.expressao.
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
        WHEN "dt-alter":U THEN ASSIGN pFieldValue = RowObject.dt-alter.
        WHEN "dt-fim-validade":U THEN ASSIGN pFieldValue = RowObject.dt-fim-validade.
        WHEN "dt-implantacao":U THEN ASSIGN pFieldValue = RowObject.dt-implantacao.
        WHEN "dt-ini-validade":U THEN ASSIGN pFieldValue = RowObject.dt-ini-validade.
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
        WHEN "cod-formula":U THEN ASSIGN pFieldValue = RowObject.cod-formula.
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
  Purpose:     Retorna valores dos campos do °ndice ep-formula
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-formula
               retorna valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-formula.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-formula LIKE af-formula.cod-formula NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-versao LIKE af-formula.nr-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-formula = RowObject.cod-formula
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
  Purpose:     Reposiciona registro com base no °ndice ep-formula
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-formula
               recebe valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-formula.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-formula LIKE af-formula.cod-formula NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao LIKE af-formula.nr-versao NO-UNDO.

    FIND FIRST bfaf-formula WHERE 
        bfaf-formula.ep-codigo = pep-codigo AND 
        bfaf-formula.cod-formula = pcod-formula AND
        bfaf-formula.nr-versao = pnr-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-formula THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-formula)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodFormula DBOProgram 
PROCEDURE openQueryCodFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo     = i-ep-codigo-usuario 
                               AND   {&TableName}.cod-formula >= c-cod-formula-ini
                               AND   {&TableName}.cod-formula <= c-cod-formula-fim
                               AND   {&TableName}.nr-versao >= i-nr-versao-ini
                               AND   {&TableName}.nr-versao <= i-nr-versao-fim
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
                               AND   {&TableName}.nr-versao >= i-nr-versao-ini
                               AND   {&TableName}.nr-versao <= i-nr-versao-fim
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-query-formula DBOProgram 
PROCEDURE pi-query-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETE TABLE FOR ttAf-formula.
                                                
EMPTY TEMP-TABLE ttAf-formula.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo     = i-ep-codigo-usuario 
    AND   bf{&TableName}.cod-formula   >= c-cod-formula-ini
    AND   bf{&TableName}.cod-formula   <= c-cod-formula-fim:         

    CREATE ttAf-formula.
    ASSIGN ttAf-formula.nr-versao          = bf{&TableName}.nr-versao           
           ttAf-formula.padrao             = bf{&TableName}.padrao
           ttAf-formula.dt-implantacao     = bf{&TableName}.dt-implantacao
           ttAf-formula.dt-alter           = bf{&TableName}.dt-alter
           ttAf-formula.hora-alter         = bf{&TableName}.hora-alter
           ttAf-formula.usuar-alter        = bf{&TableName}.usuar-alter
           ttAf-formula.expressao          = bf{&TableName}.expressao
           ttAf-formula.narrativa          = bf{&TableName}.narrativa
           ttAf-formula.dt-ini-validade       = bf{&TableName}.dt-ini-validade
           ttAf-formula.dt-fim-validade       = bf{&TableName}.dt-fim-validade.

END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-primeiro-registro DBOProgram 
PROCEDURE pi-retorna-primeiro-registro :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ep-formula e cod-formula
               Faz o mesmo que o goToKey mas sem a vers∆o
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-formula
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-formula.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-formula LIKE af-formula.cod-formula NO-UNDO.    

    FIND FIRST bfaf-formula WHERE 
        bfaf-formula.ep-codigo = pep-codigo AND 
        bfaf-formula.cod-formula = pcod-formula NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-formula THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-formula)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-query-descricao DBOProgram 
PROCEDURE pi-retorna-query-descricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETE TABLE FOR ttAf-formula.

DEFINE VARIABLE c-dt-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dt-fim AS CHARACTER   NO-UNDO.

EMPTY TEMP-TABLE ttAf-formula.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario 
    AND   bf{&TableName}.descricao >= c-descricao-ini  
    AND   bf{&TableName}.descricao <= c-descricao-fim:


    IF CAN-FIND (FIRST ttAf-formula NO-LOCK
        WHERE ttAf-formula.ep-codigo   = i-ep-codigo-usuario 
        AND   ttAf-formula.cod-formula =  bf{&TableName}.cod-formula) THEN
        NEXT.

    CREATE ttAf-formula.
    ASSIGN ttAf-formula.cod-formula        = bf{&TableName}.cod-formula
           ttAf-formula.descricao          = bf{&TableName}.descricao
           ttAf-formula.ep-codigo          = bf{&TableName}.ep-codigo
           ttAf-formula.dt-ini-validade    = bf{&TableName}.dt-ini-validade
           ttAf-formula.dt-fim-validade    = bf{&TableName}.dt-fim-validade.


    IF CAN-FIND (FIRST af-formula NO-LOCK
        WHERE af-formula.ep-codigo     = i-ep-codigo-usuario
        AND   af-formula.cod-formula   = bf{&TableName}.cod-formula
        AND   af-formula.nr-versao     <> bf{&TableName}.nr-versao)  THEN DO:

        ASSIGN  ttAf-formula.ini-valid          = "Conf. Vers∆o"
                ttAf-formula.fim-valid          = "Conf. Vers∆o"
                ttAf-formula.c-padrao           = "Conf. Vers∆o"
                ttAf-formula.c-dt-implantacao   = "Conf. Vers∆o"
                ttAf-formula.c-dt-alter         = "Conf. Vers∆o"
                ttAf-formula.c-hora-alter       = "Conf. Vers∆o"
                ttAf-formula.usuar-alter        = "Conf. Vers∆o"
                ttAf-formula.expressao          = "Conf. Vers∆o"
                ttAf-formula.narrativa          = "Conf. Vers∆o".
    END.
    ELSE
        ASSIGN  ttAf-formula.ini-valid          = STRING(bf{&TableName}.dt-ini-validade)
                ttAf-formula.fim-valid          = STRING(bf{&TableName}.dt-fim-validade)
                ttAf-formula.c-padrao           = IF bf{&TableName}.padrao THEN "Sim" ELSE "N∆o"
                ttAf-formula.c-dt-implantacao   = STRING(bf{&TableName}.dt-implantacao)
                ttAf-formula.c-dt-alter         = STRING(bf{&TableName}.dt-alter)
                ttAf-formula.c-hora-alter       = STRING(bf{&TableName}.hora-alter)
                ttAf-formula.usuar-alter        = STRING(bf{&TableName}.usuar-alter)
                ttAf-formula.expressao          = bf{&TableName}.expressao
                ttAf-formula.narrativa          = bf{&TableName}.narrativa.
END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-query-formula DBOProgram 
PROCEDURE pi-retorna-query-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETE TABLE FOR ttAf-formula.

EMPTY TEMP-TABLE ttAf-formula.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo     = i-ep-codigo-usuario 
    AND   bf{&TableName}.cod-formula   >= c-cod-formula-ini
    AND   bf{&TableName}.cod-formula   <= c-cod-formula-fim:   

    IF CAN-FIND (FIRST ttAf-formula NO-LOCK
        WHERE ttAf-formula.ep-codigo   = i-ep-codigo-usuario 
        AND   ttAf-formula.cod-formula =  bf{&TableName}.cod-formula) THEN
        NEXT.

    CREATE ttAf-formula.
    ASSIGN ttAf-formula.cod-formula        = bf{&TableName}.cod-formula
           ttAf-formula.descricao          = bf{&TableName}.descricao
           ttAf-formula.ep-codigo          = bf{&TableName}.ep-codigo
           ttAf-formula.dt-ini-validade    = bf{&TableName}.dt-ini-validade
           ttAf-formula.dt-fim-validade    = bf{&TableName}.dt-fim-validade.

    IF CAN-FIND (FIRST af-formula NO-LOCK
        WHERE af-formula.ep-codigo     = i-ep-codigo-usuario
        AND   af-formula.cod-formula   = bf{&TableName}.cod-formula
        AND   af-formula.nr-versao     <> bf{&TableName}.nr-versao)  THEN DO:

        ASSIGN  ttAf-formula.ini-valid          = "Conf. Vers∆o"
                ttAf-formula.fim-valid          = "Conf. Vers∆o"
                ttAf-formula.c-padrao           = "Conf. Vers∆o"
                ttAf-formula.c-dt-implantacao   = "Conf. Vers∆o"
                ttAf-formula.c-dt-alter         = "Conf. Vers∆o"
                ttAf-formula.c-hora-alter       = "Conf. Vers∆o"
                ttAf-formula.usuar-alter        = "Conf. Vers∆o"
                ttAf-formula.expressao          = "Conf. Vers∆o"
                ttAf-formula.narrativa          = "Conf. Vers∆o".
                
    END.
    ELSE
        ASSIGN  ttAf-formula.ini-valid          = STRING(bf{&TableName}.dt-ini-validade)
                ttAf-formula.fim-valid          = STRING(bf{&TableName}.dt-fim-validade)
                ttAf-formula.c-padrao           = IF bf{&TableName}.padrao THEN "Sim" ELSE "N∆o"
                ttAf-formula.c-dt-implantacao   = STRING(bf{&TableName}.dt-implantacao)
                ttAf-formula.c-dt-alter         = STRING(bf{&TableName}.dt-alter)
                ttAf-formula.c-hora-alter       = STRING(bf{&TableName}.hora-alter)
                ttAf-formula.usuar-alter        = STRING(bf{&TableName}.usuar-alter)
                ttAf-formula.expressao          = bf{&TableName}.expressao
                ttAf-formula.narrativa          = bf{&TableName}.narrativa.
           

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaFormula DBOProgram 
PROCEDURE piCriaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdescricao    LIKE af-formula.descricao NO-UNDO.
DEFINE INPUT PARAMETER pexpressao    LIKE af-formula.expressao NO-UNDO.
DEFINE INPUT PARAMETER pnarrativa    LIKE af-formula.narrativa NO-UNDO.

DEFINE VAR i-cod-formula             LIKE af-formula.cod-formula NO-UNDO.

IF NOT VALID-HANDLE (h-boaf023) THEN DO:
    RUN afbo/boaf023.p PERSISTENT SET h-boaf023.    
END.

RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.

DEFINE VARIABLE  i-nr-versao  LIKE af-versao-avaliacao.nr-versao   NO-UNDO.

RUN pi-retorna-menor-versao IN h-boaf023 (OUTPUT i-nr-versao).

IF RETURN-VALUE = "NOK":U THEN DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-versoes AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Vers‰es" *}
    ASSIGN c-lbl-liter-versoes = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
                &ErrorNumber="4610"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-versoes"}
    RETURN "NOK":U.                
END.

FIND LAST af-formula 
     WHERE af-formula.ep-codigo = i-ep-codigo-usuario
     NO-LOCK NO-ERROR.
IF AVAIL af-formula THEN ASSIGN i-cod-formula = af-formula.cod-formula + 1.
                    ELSE ASSIGN i-cod-formula = 1.

FIND af-formula
    WHERE af-formula.ep-codigo    = i-ep-codigo-usuario
    AND   af-formula.descricao    = pdescricao 
    AND   af-formula.padrao       = YES EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL af-formula THEN DO:  
    CREATE af-formula.
    ASSIGN af-formula.ep-codigo       = i-ep-codigo-usuario
           af-formula.cod-formula     = i-cod-formula.
END.
ASSIGN af-formula.descricao       = pdescricao
       af-formula.dt-alter        = TODAY
       af-formula.dt-implantacao  = TODAY
       af-formula.hora-alter      = STRING(TIME,"HH:MM:SS")
       af-formula.narrativa       = pnarrativa
       af-formula.padrao          = YES
       af-formula.expressao       = pexpressao
       af-formula.usuar-alter     = c-seg-usuario
       af-formula.dt-fim-validade = 12/31/9999
       af-formula.dt-ini-validade = 02/05/1996
       af-formula.nr-versao       = i-nr-versao.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaFormulaPadrao DBOProgram 
PROCEDURE piCriaFormulaPadrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN piCriaFormula(INPUT "Qualidade",
                  INPUT "( ( PCQ00001 + PCQ00003 - ( PCQ00003 * PCQ00012 / 100 ) ) / ( PCQ00001 + PCQ00002 + PCQ00003 + PCQ00004 ) ) * 100",
                  INPUT "F¢rmula para calcular o °ndice do ponto de controle Qualidade. Detalhe:   (Quantidade Aprovada  + Quantidade Aprovada Condicional) / (Quantidade Aprovada  + Quantidade Aprovada Condicional + Quantidade Perda + Quantidade Rejeitada)  * 100").

RUN piCriaFormula(INPUT "Quantidade",
                  INPUT "( PNRQT001 / PNRQT003 )  * 100",
                  INPUT "F¢rmula para calular o °ndice do ponto de controle Quantidade. Detalhe:   (Nr Recebimento Correto + (Nr Recebimento Inorreto - DemÇrito) /   Total Recebimentos) * 100").


RUN piCriaFormula(INPUT "Preáo",
                  INPUT "( PNRPR001 / PNRPR003 )  * 100",
                  INPUT "F¢rmula para calular o °ndice do ponto de controle Preáo. Detalhe:   (Nr Recebimento Correto + (Nr Recebimento Inorreto - DemÇrito) /   Total Recebimentos) * 100").

RUN piCriaFormula(INPUT "Data Entrega",
                  INPUT "( PNRDT001 / PNRDT003 )  * 100",
                  INPUT "F¢rmula para calular o °ndice do ponto de controle Data Entrega. Detalhe:   (Nr Recebimento Correto + (Nr Recebimento Inorreto - DemÇrito) /   Total Recebimentos) * 100").

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTT-var DBOProgram 
PROCEDURE piCriaTT-var :
/*----------------------------------------------------- -------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM TABLE FOR tt-var.
      
  FOR EACH af-variavel 
      WHERE af-variavel.ep-codigo = i-ep-codigo-usuario NO-LOCK:
      CREATE tt-var.
      ASSIGN tt-var.nome     = af-variavel.cod-variavel
             tt-var.valor    = 0
             tt-var.tipo-res = 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piErro DBOProgram 
PROCEDURE piErro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-erro  as int  no-undo.
def input param p-texto as char no-undo.
def input param p-ajuda as char no-undo.

   def var iErrorSequence as int no-undo.

   if p-ajuda = "" then assign p-ajuda = p-texto.

   find last RowErrors no-error.
   if avail RowErrors then
      assign iErrorSequence = RowErrors.ErrorSequence.
   assign iErrorSequence = iErrorSequence + 1.  

   if p-erro = 0 then
      p-erro = 17006.

   create RowErrors.
   ASSIGN RowErrors.ErrorSequence    = iErrorSequence
          RowErrors.ErrorNumber      = p-erro
          RowErrors.ErrorType        = "EMS":U
          RowErrors.ErrorSubType     = "ERROR":U
          RowErrors.ErrorDescription = p-texto
          RowErrors.ErrorHelp        = p-ajuda
          RowErrors.ErrorParameters  = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutaFormula DBOProgram 
PROCEDURE piExecutaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-formula LIKE af-formula.expressao no-undo.
    DEF INPUT PARAM TABLE FOR tt-var.
    DEF OUTPUT PARAM p-resultado AS DEC NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR RowErrors.
    
    FOR EACH tt-formula:
        DELETE tt-formula.
    END.
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    CREATE tt-formula.
    ASSIGN tt-formula.sequencia = 1
           tt-formula.cod-versao-integracao = 1.
           tt-formula.formula = p-formula. 

    if not valid-handle(h-cdapi020) then
       run cdp/cdapi020.p persistent set h-cdapi020 (input-output table tt-formula,
                                                     input table tt-var,
                                                     input-output table tt-erro,
                                                     no).
    
    run pi-processa-formulas in h-cdapi020 (input-output table tt-formula,
                                            input        table tt-var,
                                            input-output table tt-erro,
                                            input        no).
    
    for each tt-erro:
        run piErro (input tt-erro.cd-erro,
                    input tt-erro.mensagem,
                    input "").
    end.

    if valid-handle(h-cdapi020) then
       delete procedure h-cdapi020.

    
    FIND FIRST tt-formula NO-ERROR.
    ASSIGN p-resultado = tt-formula.result.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaVersoesData DBOProgram 
PROCEDURE piRetornaVersoesData :
/*------------------------------------------------------------------------------
  Purpose: Recebe uma temp-table de vers‰es com as datas iniciais informadas. Retorna a mesma temp-table com as datas finais calculadas.    
  Parameters: pep-codigo - recebe o codigo da empresa
              pcod-formula - recebo o codigo da formula
              tt-versao-data - recebe uma temp-table carregada com as vers‰es e datas iniciais 
              tt-item-data   - retorna a temp-table tt-versao-data com as datas finais preenchidas.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-formula.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-formula LIKE af-formula.cod-formula NO-UNDO.

    DEFINE INPUT  PARAMETER TABLE FOR tt-versao-data.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-data. 
    EMPTY TEMP-TABLE tt-item-data.
    
    FOR EACH bfaf-formula NO-LOCK 
        WHERE bfaf-formula.ep-codigo = pep-codigo
        AND   bfaf-formula.cod-formula = pcod-formula:
    
        CREATE tt-item-data.
        FOR FIRST tt-versao-data NO-LOCK
            WHERE tt-versao-data.nr-versao = bfaf-formula.nr-versao:
            BUFFER-COPY tt-versao-data TO tt-item-data.
        END.
    END.
    
    DEFINE BUFFER bftt-item-data FOR tt-item-data.
    FOR EACH tt-item-data EXCLUSIVE-LOCK:
    
        FIND FIRST bftt-item-data 
            WHERE bftt-item-data.nr-versao = tt-item-data.nr-versao NO-LOCK NO-ERROR.
        /* Buscar o per°odo seguinte, pois a data de in°cio dele determina a data de tÇrmino do per°odo anterior*/
        FIND NEXT bftt-item-data NO-LOCK NO-ERROR.
    
        IF AVAIL bftt-item-data THEN DO:
            ASSIGN tt-item-data.data-fim = bftt-item-data.data-ini - 1.
        END.
        ELSE DO:
            ASSIGN tt-item-data.data-fim = 12/31/9999.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaFormula DBOProgram 
PROCEDURE piValidaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-formula LIKE af-formula.expressao NO-UNDO.
  DEFINE INPUT-OUTPUT PARAM TABLE FOR RowErrors.

  FOR EACH tt-var:
      DELETE tt-var.
  END.

    
  ASSIGN p-formula = REPLACE (p-formula,chr(13), " ")
         p-formula = REPLACE (p-formula,chr(10), " ")
         p-formula = REPLACE (p-formula,"~r", " ").


  RUN piCriaTT-var (OUTPUT TABLE tt-var).
  
  FOR EACH tt-var:
      ASSIGN tt-var.valor = 1.
  END.

  RUN piExecutaFormula (INPUT p-formula,
                        INPUT TABLE tt-var,
                        OUTPUT de-resultado,
                        INPUT-OUTPUT table RowErrors).

  IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodFormula DBOProgram 
PROCEDURE setConstraintCodFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodformulaIni LIKE af-formula.cod-formula NO-UNDO.
    DEFINE INPUT PARAMETER pCodformulaFim LIKE af-formula.cod-formula NO-UNDO.
    DEFINE INPUT PARAMETER pNrVersaoIni LIKE af-formula.nr-versao NO-UNDO.
    DEFINE INPUT PARAMETER pNrVersaoFim LIKE af-formula.nr-versao NO-UNDO.

    ASSIGN c-cod-formula-ini = pCodformulaIni
           c-cod-formula-fim = pCodformulaFim
           i-nr-versao-ini   = pNrVersaoIni
           i-nr-versao-fim   = pNrVersaoFim.

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
    DEFINE INPUT PARAMETER pDescricaoIni LIKE af-formula.Descricao NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoFim LIKE af-formula.Descricao NO-UNDO.
    DEFINE INPUT PARAMETER pNrVersaoIni LIKE af-formula.nr-versao NO-UNDO.
    DEFINE INPUT PARAMETER pNrVersaoFim LIKE af-formula.nr-versao NO-UNDO.

    ASSIGN c-Descricao-ini = pDescricaoIni
           c-Descricao-fim = pDescricaoFim
           i-nr-versao-ini = pNrVersaoIni
           i-nr-versao-fim = pNrVersaoFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-ep-codigo   like af-formula.ep-codigo NO-UNDO.
def output param p-cod-formula like af-formula.cod-formula NO-UNDO.
DEFINE OUTPUT PARAMETER p-nr-versao LIKE af-formula.nr-versao NO-UNDO.


IF NOT VALID-HANDLE(h-boaf022) THEN DO:
    RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.
END.
    
DEFINE VARIABLE l-usa-versao         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-usa-versao-formula AS LOGICAL     NO-UNDO.

RUN getLogField IN h-boaf022 (INPUT "log-usa-versao", OUTPUT l-usa-versao).
RUN getLogField IN h-boaf022 (INPUT "log-versao-formula", OUTPUT l-usa-versao-formula).

IF l-usa-versao = TRUE AND l-usa-versao-formula = TRUE THEN DO:
      ASSIGN p-nr-versao = 0.
END.
ELSE DO:
    IF NOT VALID-HANDLE(h-boaf023) THEN DO:
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
        RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
    END.

    DEFINE VARIABLE  i-nr-versao  LIKE af-versao-avaliacao.nr-versao   NO-UNDO.

    RUN pi-retorna-menor-versao IN h-boaf023 (OUTPUT i-nr-versao).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    ASSIGN p-nr-versao = i-nr-versao.

END.

def buffer bfaf-formula for af-formula.

find last bfaf-formula 
      WHERE bfaf-formula.ep-codigo = i-ep-codigo-usuario no-lock no-error.

if avail bfaf-formula THEN ASSIGN p-cod-formula = bfaf-formula.cod-formula + 1.
                      ELSE ASSIGN p-cod-formula = 1.

assign p-ep-codigo = i-ep-codigo-usuario.
 
IF VALID-HANDLE(h-boaf022) THEN DO:
    DELETE PROCEDURE h-boaf022.
    ASSIGN h-boaf022 = ?.
END.

IF VALID-HANDLE(h-boaf023) THEN DO:
    DELETE PROCEDURE h-boaf023.
    ASSIGN h-boaf023 = ?.
END.

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
    
    if  pType = "create" then do:

        find bfaf-formula 
             WHERE bfaf-formula.ep-codigo       = rowObject.ep-codigo
             AND   bfaf-formula.cod-formula     = RowObject.cod-formula
             AND   bfaf-formula.nr-versao       = RowObject.nr-versao 
             NO-LOCK NO-ERROR.
                                     
        if  avail bfaf-formula then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-formula-e-versao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "F¢rmula_e_Vers∆o" *}
            ASSIGN c-lbl-liter-formula-e-versao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter-formula-e-versao"}
        end.
        IF RowObject.cod-formula = 0 THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-codigo-da-formula AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "C¢digo_da_f¢rmula" *}
           ASSIGN c-lbl-liter-codigo-da-formula = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                   &ErrorNumber="27223"
                   &ErrorType="EMS"
                   &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-codigo-da-formula"}
        END.

        IF NOT VALID-HANDLE (h-boaf023) THEN DO:
            RUN afbo/boaf023.p PERSISTENT SET h-boaf023.    
        END.

        RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
        RUN goToKey IN h-boaf023 (INPUT RowObject.nr-versao, INPUT rowObject.ep-codigo).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-versao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="42806"
                   &ErrorType="EMS"
                   &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-versao"}

        END.            
    end.

    IF pType = "create" OR pType = "Update" THEN DO:
       IF RowObject.descricao = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-descricao-da-formula AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descriá∆o_da_f¢rmula" *}
          ASSIGN c-lbl-liter-descricao-da-formula = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27223"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-descricao-da-formula"}
       END.
       IF RowObject.expressao = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-expressao-matematica AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Express∆o_matem†tica" *}
          ASSIGN c-lbl-liter-expressao-matematica = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27223"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-expressao-matematica"}

       END.
       if  rowObject.dt-fim-validade = ? then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-dt-fim-validade AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Dt_Fim_Validade" *}
           ASSIGN c-lbl-liter-dt-fim-validade = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                                   &ErrorNumber="265"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-dt-fim-validade"}
       end.
       if  rowObject.dt-fim-validade = ? then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-dt-fim-validade-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Dt_Fim_Validade" *}
           ASSIGN c-lbl-liter-dt-fim-validade-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                                   &ErrorNumber="265"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-dt-fim-validade-2"}
       end.
       if  rowObject.dt-ini-validade > rowObject.dt-fim-validade then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-dt-fim-validade-3 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Dt_Fim_Validade" *}
           ASSIGN c-lbl-liter-dt-fim-validade-3 = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-dt-inicio-validade AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Dt_In°cio_Validade" *}
           ASSIGN c-lbl-liter-dt-inicio-validade = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-merge-dt-fim-validadedt-inicio-valid AS CHARACTER NO-UNDO.
           ASSIGN c-lbl-merge-dt-fim-validadedt-inicio-valid = c-lbl-liter-dt-fim-validade-3 + "~~" + c-lbl-liter-dt-inicio-validade.
           {method/svc/errors/inserr.i
                                   &ErrorNumber="416"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-merge-dt-fim-validadedt-inicio-valid"}
       end.
    END.

    IF pType = "Delete" THEN DO:
       IF  rowObject.padrao AND NOT CAN-FIND(FIRST af-formula NO-LOCK
                                     WHERE  af-formula.ep-codigo = rowObject.ep-codigo
                                     AND    af-formula.cod-formula = rowObject.cod-formula 
                                     AND    af-formula.nr-versao <> rowObject.nr-versao)THEN DO:
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-formula AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "F¢rmula" *}
           ASSIGN c-lbl-liter-formula = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
            &ErrorNumber="25561"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-formula"}
           END. 
       END.

       IF CAN-FIND (FIRST af-controle NO-LOCK
                    WHERE af-controle.ep-codigo = rowObject.ep-codigo
                    AND   af-controle.cod-formula = rowObject.cod-formula) THEN DO:
           IF NOT CAN-FIND(FIRST af-formula NO-LOCK
                           WHERE    af-formula.ep-codigo   = RowObject.ep-codigo
                           AND      af-formula.cod-formula = RowObject.cod-formula
                           AND      af-formula.nr-versao  <> RowObject.nr-versao)THEN DO:
               /* Inicio -- Projeto Internacional */
               DO:
               DEFINE VARIABLE c-lbl-liter-formula-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "F¢rmula" *}
               ASSIGN c-lbl-liter-formula-2 = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-ponto-de-controle AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Ponto_de_controle" *}
               ASSIGN c-lbl-liter-ponto-de-controle = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                    &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-formula-2 + '~~~~' + c-lbl-liter-ponto-de-controle + ' '"}
               END. 

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

