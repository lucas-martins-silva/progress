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
{include/i-prgvrs.i BOCX393 2.00.00.004 } /*** "010004" 07/11/2025 11:15:49 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX393
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-adic-nve
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
{cxbo/bocx393.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE inum-di-ems       LIKE {&TableName}.num-di-ems       NO-UNDO.
DEFINE VARIABLE dcdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.
DEFINE VARIABLE inum-adic         LIKE {&TableName}.num-adic         NO-UNDO.
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
         HEIGHT             = 16.88
         WIDTH              = 51.72.
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
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
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
  Purpose:     Retorna valores dos campos do °ndice dclrmpda-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo cdd-siscomex-dts
               retorna valor do campo num-adic
               retorna valor do campo idi-niv
               retorna valor do campo cod-ident
               retorna valor do campo cod-atributo
               retorna valor do campo cdn-especif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems       LIKE decla-import-adic-nve.num-di-ems       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-adic-nve.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-adic         LIKE decla-import-adic-nve.num-adic         NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-niv          LIKE decla-import-adic-nve.idi-niv          NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ident        LIKE decla-import-adic-nve.cod-ident        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atributo     LIKE decla-import-adic-nve.cod-atributo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-especif      LIKE decla-import-adic-nve.cdn-especif      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems       = RowObject.num-di-ems
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts
           pnum-adic         = RowObject.num-adic
           pidi-niv          = RowObject.idi-niv
           pcod-ident        = RowObject.cod-ident
           pcod-atributo     = RowObject.cod-atributo
           pcdn-especif      = RowObject.cdn-especif.

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
  Purpose:     Reposiciona registro com base no °ndice dclrmpda-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo cdd-siscomex-dts
               recebe valor do campo num-adic
               recebe valor do campo idi-niv
               recebe valor do campo cod-ident
               recebe valor do campo cod-atributo
               recebe valor do campo cdn-especif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-adic-nve.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-adic-nve.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT PARAMETER pnum-adic LIKE decla-import-adic-nve.num-adic NO-UNDO.
    DEFINE INPUT PARAMETER pidi-niv LIKE decla-import-adic-nve.idi-niv NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ident LIKE decla-import-adic-nve.cod-ident NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atributo LIKE decla-import-adic-nve.cod-atributo NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-especif LIKE decla-import-adic-nve.cdn-especif NO-UNDO.

    FIND FIRST bfdecla-import-adic-nve WHERE bfdecla-import-adic-nve.num-di-ems       = pnum-di-ems
                                       AND   bfdecla-import-adic-nve.cdd-siscomex-dts = pcdd-siscomex-dts
                                       AND   bfdecla-import-adic-nve.num-adic         = pnum-adic
                                       AND   bfdecla-import-adic-nve.idi-niv          = pidi-niv
                                       AND   bfdecla-import-adic-nve.cod-ident        = pcod-ident
                                       AND   bfdecla-import-adic-nve.cod-atributo     = pcod-atributo
                                       AND   bfdecla-import-adic-nve.cdn-especif      = pcdn-especif 
                                       NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-adic-nve THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-adic-nve)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumDIEms DBOProgram 
PROCEDURE openQueryByNumDIEms :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                            WHERE {&TABLENAME}.num-di-ems       = inum-di-ems 
                            AND   {&TABLENAME}.cdd-siscomex-dts = dcdd-siscomex-dts
                            AND   {&TABLENAME}.num-adic         = inum-adic NO-LOCK INDEXED-REPOSITION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumDIEms DBOProgram 
PROCEDURE setConstraintByNumDIEms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms         LIKE {&tablename}.num-di-ems       NO-UNDO.
DEF INPUT PARAM pcdd-siscomex-dts LIKE {&tablename}.cdd-siscomex-dts NO-UNDO.
DEF INPUT PARAM pNumAdic          LIKE {&tablename}.num-adic         NO-UNDO.

ASSIGN inum-di-ems       = pNumDiEms
       dcdd-siscomex-dts = pcdd-siscomex-dts
       inum-adic         = pNumAdic.

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
    
    IF  pType = "Create" THEN DO:
        IF  CAN-FIND (FIRST bf{&TableName}
                      WHERE bf{&TableName}.num-di-ems       = RowObject.num-di-ems  
                      AND   bf{&TableName}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts  
                      AND   bf{&TableName}.num-adic         = RowObject.num-adic    
                      AND   bf{&TableName}.idi-niv          = RowObject.idi-niv     
                      AND   bf{&TableName}.cod-ident        = RowObject.cod-ident        
                      AND   bf{&TableName}.cod-atributo     = RowObject.cod-atributo
                      AND   bf{&TableName}.cdn-especif      = RowObject.cdn-especif) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-declarante-importes-adicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Declarante_Importes_Adiá∆o" *}
            ASSIGN c-lbl-liter-declarante-importes-adicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-declarante-importes-adicao"}
            END. 
    END. /* IF  pType = "Create" THEN DO: */
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

