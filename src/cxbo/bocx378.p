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
{include/i-prgvrs.i BOCX378 2.00.00.005 } /*** "010005" 07/10/2024 16:59:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx378 MUT}
&ENDIF


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
&GLOBAL-DEFINE DBOName BOCX378
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName embarq-import-docto
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
{cxbo/bocx378.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf-docum-est    FOR docum-est.
DEFINE BUFFER bf-embarque-imp FOR embarque-imp.   
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
         HEIGHT             = 8.58
         WIDTH              = 47.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord-2 DBOProgram 
PROCEDURE deleteRecord-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE embarq-import-docto.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE embarq-import-docto.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE embarq-import-docto.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE embarq-import-docto.cod-natur-operac NO-UNDO.
    
    FIND FIRST bfembarq-import-docto EXCLUSIVE-LOCK
         WHERE bfembarq-import-docto.cod-ser-docto = pcod-ser-docto
           AND bfembarq-import-docto.cod-docto = pcod-docto
           AND bfembarq-import-docto.cdn-emitente = pcdn-emitente
           AND bfembarq-import-docto.cod-natur-operac = pcod-natur-operac NO-ERROR.
    
    IF  AVAILABLE bfembarq-import-docto THEN
        DELETE bfembarq-import-docto.
    
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "idi-nf-simples-remes":U THEN ASSIGN pFieldValue = RowObject.idi-nf-simples-remes.
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
  Purpose:     Retorna valores dos campos do °ndice embrqmpa-id
  Parameters:  
               retorna valor do campo cod-estab
               retorna valor do campo cod-embarq
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE embarq-import-docto.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-embarq LIKE embarq-import-docto.cod-embarq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ser-docto LIKE embarq-import-docto.cod-ser-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE embarq-import-docto.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE embarq-import-docto.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE embarq-import-docto.cod-natur-operac NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab
           pcod-embarq = RowObject.cod-embarq
           pcod-ser-docto = RowObject.cod-ser-docto
           pcod-docto = RowObject.cod-docto
           pcdn-emitente = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac.

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
        WHEN "log-transf-draw":U THEN ASSIGN pFieldValue = RowObject.log-transf-draw.
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
  Purpose:     Reposiciona registro com base no °ndice embrqmpa-id
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo cod-embarq
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE embarq-import-docto.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq LIKE embarq-import-docto.cod-embarq NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE embarq-import-docto.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE embarq-import-docto.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE embarq-import-docto.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE embarq-import-docto.cod-natur-operac NO-UNDO.

    FIND FIRST bfembarq-import-docto WHERE 
        bfembarq-import-docto.cod-estab = pcod-estab AND 
        bfembarq-import-docto.cod-embarq = pcod-embarq AND 
        bfembarq-import-docto.cod-ser-docto = pcod-ser-docto AND 
        bfembarq-import-docto.cod-docto = pcod-docto AND 
        bfembarq-import-docto.cdn-emitente = pcdn-emitente AND 
        bfembarq-import-docto.cod-natur-operac = pcod-natur-operac NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfembarq-import-docto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfembarq-import-docto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se h† Registro na Base de Dados
  Parameters:  
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE embarq-import-docto.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE embarq-import-docto.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE embarq-import-docto.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE embarq-import-docto.cod-natur-operac NO-UNDO.
    
    FIND FIRST bfembarq-import-docto NO-LOCK
         WHERE bfembarq-import-docto.cod-ser-docto = pcod-ser-docto
           AND bfembarq-import-docto.cod-docto = pcod-docto
           AND bfembarq-import-docto.cdn-emitente = pcdn-emitente
           AND bfembarq-import-docto.cod-natur-operac = pcod-natur-operac NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfembarq-import-docto THEN 
        RETURN "NOK":U.
    
    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfembarq-import-docto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY qr{&tableName} FOR EACH {&tableName}
       NO-LOCK
       INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRowObject DBOProgram 
PROCEDURE piCriaRowObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab        LIKE embarq-import-docto.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq       LIKE embarq-import-docto.cod-embarq NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto    LIKE embarq-import-docto.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto        LIKE embarq-import-docto.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE embarq-import-docto.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE embarq-import-docto.cod-natur-operac NO-UNDO.

    CREATE RowObject.
    ASSIGN RowObject.cod-ser-docto    = pcod-ser-docto
           RowObject.cod-docto        = pcod-docto
           RowObject.cdn-emitente     = pcdn-emitente
           RowObject.cod-natur-operac = pcod-natur-operac
           RowObject.cod-estab        = pcod-estab
           RowObject.cod-embarq       = pcod-embarq.

    IF CAN-FIND(FIRST docum-est
                WHERE docum-est.serie-docto  = pcod-ser-docto   
                AND   docum-est.nro-docto    = pcod-docto       
                AND   docum-est.cod-emitente = pcdn-emitente    
                AND   docum-est.nat-operacao = pcod-natur-operac ) THEN
        FOR FIRST bf-docum-est NO-LOCK
            WHERE bf-docum-est.serie-docto  = pcod-ser-docto    
            AND   bf-docum-est.nro-docto    = pcod-docto        
            AND   bf-docum-est.cod-emitente = pcdn-emitente     
            AND   bf-docum-est.nat-operacao = pcod-natur-operac :
            ASSIGN RowObject.idi-nf-simples-remes = bf-docum-est.idi-nf-simples-remes.                   
        END.

    IF CAN-FIND(FIRST embarque-imp
                WHERE embarque-imp.cod-estabel = pcod-estab
                AND   embarque-imp.embarque    = pcod-embarq) THEN
        FOR FIRST bf-embarque-imp NO-LOCK
            WHERE bf-embarque-imp.cod-estabel = pcod-estab
            AND   bf-embarque-imp.embarque    = pcod-embarq:
            ASSIGN RowObject.log-transf-draw  = bf-embarque-imp.log-embarq-transf-draw.
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
    
    IF  pType = "Create":U THEN DO:
        IF  NOT CAN-FIND(FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estab) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="RowObject.cod-estab"}
        END.
        
        IF  NOT CAN-FIND(FIRST embarque-imp
                         WHERE embarque-imp.cod-estabel = RowObject.cod-estab
                           AND embarque-imp.embarque  = RowObject.cod-embarq) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2210"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters=" "}
        END.
        
        IF  NOT CAN-FIND(FIRST docum-est
                         WHERE docum-est.serie-docto      = RowObject.cod-ser-docto
                           AND docum-est.nro-docto        = RowObject.cod-docto
                           AND docum-est.cod-emitente     = RowObject.cdn-emitente
                           AND docum-est.nat-operacao     = RowObject.cod-natur-operac) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="952"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters=" "}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

