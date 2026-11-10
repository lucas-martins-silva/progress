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
{include/i-prgvrs.i BOCX397 2.00.00.003 } /*** "010003" 11/12/2023 10:13:29 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX397
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName nve-especif
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
{cxbo/bocx397.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE i-idi-niv      LIKE nve-especif.idi-niv NO-UNDO.
DEFINE VARIABLE c-cod-ident    LIKE nve-especif.cod-ident NO-UNDO.
DEFINE VARIABLE c-cod-atributo LIKE nve-especif.cod-atributo NO-UNDO.
DEF VAR c-cod-classif-fisc-ini LIKE classif-fisc.class-fiscal NO-UNDO.
DEF VAR c-cod-classif-fisc-fim LIKE classif-fisc.class-fiscal NO-UNDO.

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
        WHEN "cod-atributo":U THEN ASSIGN pFieldValue = RowObject.cod-atributo.
        WHEN "cod-ident":U THEN ASSIGN pFieldValue = RowObject.cod-ident.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-especif":U THEN ASSIGN pFieldValue = RowObject.des-especif.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "cdn-especif":U THEN ASSIGN pFieldValue = RowObject.cdn-especif.
        WHEN "idi-niv":U THEN ASSIGN pFieldValue = RowObject.idi-niv.
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
  Purpose:     Retorna valores dos campos do °ndice nvspcf-id
  Parameters:  
               retorna valor do campo idi-niv
               retorna valor do campo cod-ident
               retorna valor do campo cod-atributo
               retorna valor do campo cdn-especif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-niv LIKE nve-especif.idi-niv NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ident LIKE nve-especif.cod-ident NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atributo LIKE nve-especif.cod-atributo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-especif LIKE nve-especif.cdn-especif NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pidi-niv = RowObject.idi-niv
           pcod-ident = RowObject.cod-ident
           pcod-atributo = RowObject.cod-atributo
           pcdn-especif = RowObject.cdn-especif.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice nvspcf-id
  Parameters:  
               recebe valor do campo idi-niv
               recebe valor do campo cod-ident
               recebe valor do campo cod-atributo
               recebe valor do campo cdn-especif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-niv LIKE nve-especif.idi-niv NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ident LIKE nve-especif.cod-ident NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atributo LIKE nve-especif.cod-atributo NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-especif LIKE nve-especif.cdn-especif NO-UNDO.

    FIND FIRST bfnve-especif WHERE 
        bfnve-especif.idi-niv = pidi-niv AND 
        bfnve-especif.cod-ident = pcod-ident AND 
        bfnve-especif.cod-atributo = pcod-atributo AND 
        bfnve-especif.cdn-especif = pcdn-especif NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnve-especif THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnve-especif)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAllEspecifByNivel DBOProgram 
PROCEDURE openQueryAllEspecifByNivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                            WHERE {&TABLENAME}.idi-niv      = i-idi-niv   
                            AND   {&TABLENAME}.cod-ident    = c-cod-ident INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAtributo DBOProgram 
PROCEDURE openQueryByAtributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                            WHERE {&TABLENAME}.idi-niv      = i-idi-niv   
                            AND   {&TABLENAME}.cod-ident    = c-cod-ident 
                            AND   {&TABLENAME}.cod-atributo = c-cod-atributo INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByClassifFisc DBOProgram 
PROCEDURE openQueryByClassifFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                            WHERE {&TABLENAME}.cod-ident BEGINS SUBSTRING(c-cod-classif-fisc-ini,1,2)
                            OR    {&TABLENAME}.cod-ident BEGINS SUBSTRING(c-cod-classif-fisc-fim,1,2) NO-LOCK INDEXED-REPOSITION.

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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAllEspecifByNivel DBOProgram 
PROCEDURE setConstraintAllEspecifByNivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-niv      LIKE nve-especif.idi-niv NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ident    LIKE nve-especif.cod-ident NO-UNDO.

    ASSIGN i-idi-niv      = pidi-niv      
           c-cod-ident    = pcod-ident.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByAtributo DBOProgram 
PROCEDURE setConstraintByAtributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-niv      LIKE nve-especif.idi-niv NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ident    LIKE nve-especif.cod-ident NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atributo LIKE nve-especif.cod-atributo NO-UNDO.

    ASSIGN i-idi-niv      = pidi-niv      
           c-cod-ident    = pcod-ident    
           c-cod-atributo = pcod-atributo.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByClassifFisc DBOProgram 
PROCEDURE setConstraintByClassifFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodClassifFiscIni LIKE classif-fisc.class-fiscal NO-UNDO.
DEF INPUT PARAM pCodClassifFiscFim LIKE classif-fisc.class-fiscal NO-UNDO.

ASSIGN c-cod-classif-fisc-ini = REPLACE(pCodClassifFiscIni,".",'')
       c-cod-classif-fisc-fim = REPLACE(pCodClassifFiscFim,".",'').

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
    
    IF pType = "CREATE" OR 
        pType = "COPY"  THEN DO:
        IF CAN-FIND (FIRST nve-especif
                     WHERE nve-especif.idi-niv      = RowObject.idi-niv      
                     AND   nve-especif.cod-ident    = RowObject.cod-ident    
                     AND   nve-especif.cod-atributo = RowObject.cod-atributo
                     AND   nve-especif.cdn-especif = RowObject.cdn-especif) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-nve-especificacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "NVE_Especificaá∆o" *}
            ASSIGN c-lbl-liter-nve-especificacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-nve-especificacao"}
            END. 

    END.   

    IF RowObject.cdn-especif = 0 THEN
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-codigo-especificacao-deve-ser AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Especificaá∆o_deve_ser_informado" *}
        ASSIGN c-lbl-liter-codigo-especificacao-deve-ser = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorParameters="c-lbl-liter-codigo-especificacao-deve-ser + '!'"}
        END. 
              
    IF RowObject.des-especif = "" THEN
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-descricao-especificacao-deve-s AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Descriá∆o_Especificaá∆o_deve_ser_informado" *}
        ASSIGN c-lbl-liter-descricao-especificacao-deve-s = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorParameters="c-lbl-liter-descricao-especificacao-deve-s + '!'"}
        END. 

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

