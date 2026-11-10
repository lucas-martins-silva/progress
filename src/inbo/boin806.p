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
{include/i-prgvrs.i BOIN806 2.00.00.005 } /*** "010005" 13/11/2023 11:45:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin806 MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definição ---*/
&GLOBAL-DEFINE DBOName BOIN806
&GLOBAL-DEFINE DBOVersion 2.04.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName config-operac
&GLOBAL-DEFINE TableLabel config-operac
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-tip-operac
&GLOBAL-DEFINE KeyField2 cod-estab 
&GLOBAL-DEFINE KeyField3 cdn-empresa

/*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */


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

*/
/* DBO-XML-END */

/*:T--- Include com definição da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diretório do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idêntico ao nome do DBO mas com 
      extensão .i ---*/
{inbo/boin806.i RowObject}
{cdp/cdcfgmat.i}

/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE oc-rowid AS ROWID NO-UNDO.

DEFINE variable i-ep-codigo-ini     LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable i-ep-codigo-fim     LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel-ini   LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-estabel-fim   LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper-ini LIKE config-operac.cod-tip-operac NO-UNDO.
DEFINE variable c-cod-tipo-oper-fim LIKE config-operac.cod-tip-operac NO-UNDO.
DEFINE VARIABLE c-desc-tudo AS CHARACTER   NO-UNDO.

DEFINE BUFFER bfconfig-var-operac FOR config-var-operac.
DEFINE BUFFER bfconfig-var-operac-regra FOR config-var-operac-regra.
DEFINE BUFFER bfconfig-var-operac-regra-cond FOR config-var-operac-regra-cond.
DEFINE BUFFER bfconfig-var-operac-regra-ret FOR config-var-operac-regra-ret.

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
         HEIGHT             = 10.08
         WIDTH              = 46.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-tip-operac":U THEN ASSIGN pFieldValue = RowObject.cod-tip-operac.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do índice ch-operacao
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tipo-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE config-operac.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-operac.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.cdn-empresa
           pcod-estabel = RowObject.cod-estab
           pcod-tipo-oper = RowObject.cod-tip-operac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lógico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTipoOperUtilizar DBOProgram 
PROCEDURE getTipoOperUtilizar :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o tipo de opera‡Æo que deve ser usado no CDAPI034
  Parameters:  
               recebe empresa, estabelecimento, tipo de operacao antigo e tipo de opera‡Æo novo
               retorna o tipo de operacÆo que deve ser utilizado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pEmpresa       LIKE empresa.ep-codigo        NO-UNDO.
    DEFINE INPUT  PARAMETER pEstab         LIKE doc-orig-nfe.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pTpOperNovo    AS CHAR                       NO-UNDO.
    DEFINE INPUT  PARAMETER pTpOperAntigo  AS CHAR                       NO-UNDO.
    DEFINE OUTPUT PARAMETER pTpOperRetorno AS CHAR                       NO-UNDO.


    IF CAN-FIND(FIRST config-operac
                WHERE config-operac.cdn-empresa = pEmpresa
                  AND config-operac.cod-estab   = pEstab
                  AND config-operac.cod-tip-operac = pTpOperNovo) THEN
        ASSIGN pTpOperRetorno = pTpOperNovo.
    ELSE
        ASSIGN pTpOperRetorno = pTpOperAntigo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no índice ch-operacao
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tipo-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE config-operac.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-operac.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.

    FIND FIRST bfconfig-operac WHERE 
        bfconfig-operac.cdn-empresa = pep-codigo AND 
        bfconfig-operac.cod-estab = pcod-estabel AND 
        bfconfig-operac.cod-tip-operac = pcod-tipo-oper NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-operac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-operac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
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
    
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRowid DBOProgram 
PROCEDURE openQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} WHERE ROWID({&TableName}) = oc-rowid NO-LOCK.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cdn-empresa   >= i-ep-codigo-ini
           AND {&TableName}.cdn-empresa   <= i-ep-codigo-fim
           AND {&TableName}.cod-estab >= c-cod-estabel-ini 
           AND {&TableName}.cod-estab <= c-cod-estabel-fim
           AND {&TableName}.cod-tip-operac >= c-cod-tipo-oper-ini 
           AND {&TableName}.cod-tip-operac <= c-cod-tipo-oper-fim INDEXED-REPOSITION.
    
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRowid DBOProgram 
PROCEDURE setConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.

    ASSIGN oc-rowid = pRowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pep-codigo-ini     LIKE config-operac.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pep-codigo-fim     LIKE config-operac.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE config-operac.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE config-operac.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper-ini LIKE config-operac.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper-fim LIKE config-operac.cod-tip-operac NO-UNDO.

    ASSIGN i-ep-codigo-ini     = pep-codigo-ini    
           i-ep-codigo-fim     = pep-codigo-fim    
           c-cod-estabel-ini   = pcod-estabel-ini  
           c-cod-estabel-fim   = pcod-estabel-fim  
           c-cod-tipo-oper-ini = pcod-tipo-oper-ini
           c-cod-tipo-oper-fim = pcod-tipo-oper-fim.
                                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCopyMethod DBOProgram 
PROCEDURE setCopyMethod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-rowid AS ROWID NO-UNDO.
    DEF INPUT PARAMETER p-current AS ROWID NO-UNDO.
    DEF INPUT PARAMETER p-copy AS INT NO-UNDO.

    DEF VAR i-ep-codigo-copy LIKE config-operac.cdn-empresa NO-UNDO.
    DEF VAR c-cod-estabel-copy LIKE config-operac.cod-estab NO-UNDO.
    DEF VAR c-cod-tipo-oper-copy LIKE config-operac.cod-tip-operac NO-UNDO.

    FIND FIRST config-operac NO-LOCK
         WHERE rowid(config-operac) = p-current NO-ERROR.
    IF AVAIL config-operac THEN DO:
        
        ASSIGN i-ep-codigo-copy = config-operac.cdn-empresa
               c-cod-estabel-copy = config-operac.cod-estab
               c-cod-tipo-oper-copy = config-operac.cod-tip-operac.

    END.

    FIND FIRST config-operac NO-LOCK
         WHERE rowid(config-operac) = p-rowid NO-ERROR.
    
    IF p-copy > 1 THEN DO:

        FOR EACH bfconfig-var-operac NO-LOCK
           WHERE bfconfig-var-operac.cdn-empresa = config-operac.cdn-empresa
             AND bfconfig-var-operac.cod-estab = config-operac.cod-estab
             AND bfconfig-var-operac.cod-tip-operac = config-operac.cod-tip-operac:

            CREATE config-var-operac.
            BUFFER-COPY bfconfig-var-operac TO config-var-operac
            ASSIGN config-var-operac.cdn-empresa     = i-ep-codigo-copy
                   config-var-operac.cod-estab   = c-cod-estabel-copy
                   config-var-operac.cod-tip-operac = c-cod-tipo-oper-copy.
            

        END.

    END.

    IF p-copy > 2 THEN DO:

        FOR EACH bfconfig-var-operac-regra NO-LOCK 
           WHERE bfconfig-var-operac-regra.cdn-empresa = config-operac.cdn-empresa        
             AND bfconfig-var-operac-regra.cod-estab = config-operac.cod-estab    
             AND bfconfig-var-operac-regra.cod-tip-operac = config-operac.cod-tip-operac:

            CREATE config-var-operac-regra.
            BUFFER-COPY bfconfig-var-operac-regra TO config-var-operac-regra
            ASSIGN config-var-operac-regra.cdn-empresa     = i-ep-codigo-copy
                   config-var-operac-regra.cod-estab   = c-cod-estabel-copy
                   config-var-operac-regra.cod-tip-operac = c-cod-tipo-oper-copy.

        END.

    END.

    IF p-copy > 3 THEN DO:

        FOR EACH bfconfig-var-operac-regra-cond NO-LOCK 
           WHERE bfconfig-var-operac-regra-cond.cdn-empresa = config-operac.cdn-empresa        
             AND bfconfig-var-operac-regra-cond.cod-estab = config-operac.cod-estab    
             AND bfconfig-var-operac-regra-cond.cod-tip-operac = config-operac.cod-tip-operac:

            CREATE config-var-operac-regra-cond.
            BUFFER-COPY bfconfig-var-operac-regra-cond TO config-var-operac-regra-cond
            ASSIGN config-var-operac-regra-cond.cdn-empresa     = i-ep-codigo-copy
                   config-var-operac-regra-cond.cod-estab   = c-cod-estabel-copy
                   config-var-operac-regra-cond.cod-tip-operac = c-cod-tipo-oper-copy.

        END.

    END.

    IF p-copy > 4 THEN DO:

        FOR EACH bfconfig-var-operac-regra-ret NO-LOCK 
           WHERE bfconfig-var-operac-regra-ret.cdn-empresa = config-operac.cdn-empresa
             AND bfconfig-var-operac-regra-ret.cod-estab = config-operac.cod-estab
             AND bfconfig-var-operac-regra-ret.cod-tip-operac = config-operac.cod-tip-operac:
            
            CREATE config-var-operac-regra-ret.
            BUFFER-COPY bfconfig-var-operac-regra-ret TO config-var-operac-regra-ret
            ASSIGN config-var-operac-regra-ret.cdn-empresa     = i-ep-codigo-copy
                   config-var-operac-regra-ret.cod-estab   = c-cod-estabel-copy
                   config-var-operac-regra-ret.cod-tip-operac = c-cod-tipo-oper-copy.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parâmetro pType para identificar quais as validações a serem
          executadas ---*/
    /*:T--- Os valores possíveis para o parâmetro são: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, através do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validações ---*/

    IF pType = "Create" THEN DO:

        FIND FIRST bfconfig-operac NO-LOCK 
             WHERE bfconfig-operac.cdn-empresa = RowObject.cdn-empresa
               AND bfconfig-operac.cod-estab = RowObject.cod-estab
               AND bfconfig-operac.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF  AVAIL bfconfig-operac THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind config-operac 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="1"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        FIND FIRST empresa no-lock
             WHERE empresa.ep-codigo =&IF "{&mguni_version}" >= "2.071" &THEN STRING(RowObject.cdn-empresa) &ELSE RowObject.cdn-empresa &ENDIF NO-ERROR.
        IF  NOT AVAIL empresa THEN DO:         
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mguni empresa 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        FIND FIRST estabelec no-lock
             WHERE estabelec.cod-estabel = &IF "{&mguni_version}" >= "2.071" &THEN string(RowObject.cod-estab) &ELSE RowObject.cod-estab &ENDIF NO-ERROR.
        IF  NOT AVAIL estabelec THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        FIND FIRST config-tip-operac NO-LOCK WHERE config-tip-operac.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF  NOT AVAIL config-tip-operac THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind config-tip-operac 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF pType = "Delete" THEN DO:

        FIND FIRST config-var-operac NO-LOCK 
             WHERE config-var-operac.cdn-empresa = RowObject.cdn-empresa
               AND config-var-operac.cod-estab = RowObject.cod-estab
               AND config-var-operac.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF AVAIL config-var-operac THEN DO:
    
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-operacao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Opera‡Æo" *}
            ASSIGN c-lbl-liter-operacao-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-variavel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vari vel" *}
            ASSIGN c-lbl-liter-variavel = TRIM(RETURN-VALUE).
            ASSIGN c-desc-tudo = c-lbl-liter-operacao-2 + '~~' + c-lbl-liter-variavel.
            {method/svc/errors/inserr.i &ErrorNumber="5"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-desc-tudo"}
    
        END.

        FIND FIRST config-var-operac-regra NO-LOCK 
             WHERE config-var-operac-regra.cdn-empresa = RowObject.cdn-empresa
               AND config-var-operac-regra.cod-estab = RowObject.cod-estab
               AND config-var-operac-regra.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF AVAIL config-var-operac-regra THEN DO:

              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-operacao-3 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Opera‡Æo" *}
              ASSIGN c-lbl-liter-operacao-3 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-regra AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Regra" *}
              ASSIGN c-lbl-liter-regra = TRIM(RETURN-VALUE).
              ASSIGN c-desc-tudo = c-lbl-liter-operacao-3 + '~~' + c-lbl-liter-regra.
              {method/svc/errors/inserr.i &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-desc-tudo"}
                    
        END.
        
        FIND FIRST config-var-operac-regra-cond NO-LOCK 
             WHERE config-var-operac-regra-cond.cdn-empresa = RowObject.cdn-empresa
               AND config-var-operac-regra-cond.cod-estab = RowObject.cod-estab
               AND config-var-operac-regra-cond.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF  AVAIL config-var-operac-regra-cond THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-regra-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Regra" *}
            ASSIGN c-lbl-liter-regra-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-condicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Condi‡Æo" *}
            ASSIGN c-lbl-liter-condicao = TRIM(RETURN-VALUE).
            ASSIGN c-desc-tudo = c-lbl-liter-regra-2 + '~~' + c-lbl-liter-condicao.
            {method/svc/errors/inserr.i &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-desc-tudo"}

        END.

        FIND FIRST config-var-operac-regra-ret NO-LOCK 
             WHERE config-var-operac-regra-ret.cdn-empresa = RowObject.cdn-empresa
               AND config-var-operac-regra-ret.cod-estab = RowObject.cod-estab
               AND config-var-operac-regra-ret.cod-tip-operac = RowObject.cod-tip-operac NO-ERROR.
        IF  AVAIL config-var-operac-regra-ret THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-regra-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Regra" *}
            ASSIGN c-lbl-liter-regra-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-retorno AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Retorno" *}
            ASSIGN c-lbl-liter-retorno = TRIM(RETURN-VALUE).
            ASSIGN c-desc-tudo = c-lbl-liter-regra-3 + '~~' + c-lbl-liter-retorno.
            {method/svc/errors/inserr.i &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-desc-tudo"}
        END.
        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            IF CAN-FIND(FIRST funcao 
                        WHERE funcao.cd-funcao = "LOTE-AVANCADO":U
                          AND funcao.ativo     = YES) THEN DO:
                IF CAN-FIND(FIRST fda-lote-param-espcif 
                            WHERE fda-lote-param-espcif.cdn-empresa      = RowObject.cdn-empresa
                              AND fda-lote-param-espcif.cod-estab-operac = RowObject.cod-estab
                              AND fda-lote-param-espcif.cod-tip-operac   = RowObject.cod-tip-operac) OR 
                   CAN-FIND(FIRST fda-lote-param 
                            WHERE fda-lote-param.cdn-empresa      = RowObject.cdn-empresa
                              AND fda-lote-param.cod-estab-operac = RowObject.cod-estab
                              AND fda-lote-param.cod-tip-operac   = RowObject.cod-tip-operac) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-regra-4 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Regra" *}
                    ASSIGN c-lbl-liter-regra-4 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-parametros-lote-avancado AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Parƒmetros_Lote_Avan‡ado" *}
                    ASSIGN c-lbl-liter-parametros-lote-avancado = TRIM(RETURN-VALUE).
                    ASSIGN c-desc-tudo = c-lbl-liter-regra-4 + '~~' + c-lbl-liter-parametros-lote-avancado.
                    {method/svc/errors/inserr.i &ErrorNumber="5"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-desc-tudo"}
                END.
            END.
        &ENDIF

    END.
    
    /*:T--- Verifica ocorrência de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
