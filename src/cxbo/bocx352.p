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
{include/i-prgvrs.i BOCX352 2.00.00.003} /*** "010003" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX352 MUT}
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
&GLOBAL-DEFINE DBOName BOCX352
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-embal-resum
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
{cxbo/bocx352.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-acond       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-num-volum-acond AS INTEGER    NO-UNDO.

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
        WHEN "cod-acond":U THEN ASSIGN pFieldValue = RowObject.cod-acond.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-volum":U THEN ASSIGN pFieldValue = RowObject.des-volum.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "sigla-emb":U THEN ASSIGN pFieldValue = RowObject.sigla-emb.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-volum-acond":U THEN ASSIGN pFieldValue = RowObject.num-volum-acond.
        WHEN "qti-volum":U THEN ASSIGN pFieldValue = RowObject.qti-volum.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsmblr-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-acond
               retorna valor do campo num-volum-acond
               retorna valor do campo sigla-emb
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-embal-resum.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-embal-resum.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acond LIKE proces-embal-resum.cod-acond NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-volum-acond LIKE proces-embal-resum.num-volum-acond NO-UNDO.
    DEFINE OUTPUT PARAMETER psigla-emb LIKE proces-embal-resum.sigla-emb NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-acond = RowObject.cod-acond
           pnum-volum-acond = RowObject.num-volum-acond
           psigla-emb = RowObject.sigla-emb.

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
  Purpose:     Reposiciona registro com base no °ndice prcsmblr-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-acond
               recebe valor do campo num-volum-acond
               recebe valor do campo sigla-emb
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-embal-resum.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-embal-resum.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond LIKE proces-embal-resum.cod-acond NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-acond LIKE proces-embal-resum.num-volum-acond NO-UNDO.
    DEFINE INPUT PARAMETER psigla-emb LIKE proces-embal-resum.sigla-emb NO-UNDO.

    FIND FIRST bfproces-embal-resum WHERE 
        bfproces-embal-resum.cod-estabel = pcod-estabel AND 
        bfproces-embal-resum.nr-proc-exp = pnr-proc-exp AND 
        bfproces-embal-resum.cod-acond = pcod-acond AND 
        bfproces-embal-resum.num-volum-acond = pnum-volum-acond AND 
        bfproces-embal-resum.sigla-emb = psigla-emb NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-embal-resum THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-embal-resum)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso-exp DBOProgram 
PROCEDURE linkToProcesso-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hp_Parent AS HANDLE NO-UNDO.

ASSIGN c-cod-estabel = ""
       c-nr-proc-exp = "".

if  valid-handle(hp_Parent) then do:
    run getCharField in hp_Parent (input "cod-estabel":U, output c-cod-estabel).
    run getCharField in hp_Parent (input "nr-proc-exp":U, output c-nr-proc-exp).
end.

RETURN "OK".

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
 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcessoExp DBOProgram 
PROCEDURE openQueryProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel = c-cod-estabel
       AND {&tablename}.nr-proc-exp = c-nr-proc-exp
       INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVolumeAcond DBOProgram 
PROCEDURE openQueryVolumeAcond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel     = c-cod-estabel
       AND {&tablename}.nr-proc-exp     = c-nr-proc-exp
       AND {&tablename}.cod-acond       = c-cod-acond
       AND {&tablename}.num-volum-acond = i-num-volum-acond
       INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcessoExp DBOProgram 
PROCEDURE setConstraintProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel     LIKE proces-embal-resum.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp     LIKE proces-embal-resum.nr-proc-exp     NO-UNDO.

    ASSIGN c-cod-estabel     = pcod-estabel    
           c-nr-proc-exp     = pnr-proc-exp.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVolumeAcond DBOProgram 
PROCEDURE setConstraintVolumeAcond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel     LIKE proces-embal-resum.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp     LIKE proces-embal-resum.nr-proc-exp     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond       LIKE proces-embal-resum.cod-acond       NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-acond LIKE proces-embal-resum.num-volum-acond NO-UNDO.

    ASSIGN c-cod-estabel     = pcod-estabel    
           c-nr-proc-exp     = pnr-proc-exp    
           c-cod-acond       = pcod-acond      
           i-num-volum-acond = pnum-volum-acond.

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

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                    WHERE bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                      AND bf{&TableName}.nr-proc-exp     = RowObject.nr-proc-exp
                      AND bf{&TableName}.cod-acond       = RowObject.cod-acond
                      AND bf{&TableName}.num-volum-acond = RowObject.num-volum-acond
                      AND bf{&TableName}.sigla-emb       = RowObject.sigla-emb) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-embalagem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-embalagem"}
            END. 
                                        
        IF NOT CAN-FIND(FIRST embalag
                        WHERE embalag.sigla-emb = RowObject.sigla-emb) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-embalagem-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-embalagem-2"}
            END. 
    END.

    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE VerificaEmbalResum:

    def input parameter p-cod-estabel    like proces-acond-volum.cod-estabel     no-undo.
    def input parameter p-nr-proc-exp    like proces-acond-volum.nr-proc-exp     no-undo.
    def input parameter p-cod-acond      like proces-acond-volum.cod-acond       no-undo.
    def input parameter p-num-volum      like proces-acond-volum.num-volum-acond no-undo.

    find first proces-embal-resum
       where proces-embal-resum.cod-estabel     = p-cod-estabel
         and proces-embal-resum.nr-proc-exp     = p-nr-proc-exp
         and proces-embal-resum.cod-acond       = p-cod-acond
         and proces-embal-resum.num-volum-acond = p-num-volum
         no-lock no-error.

    IF avail proces-embal-resum THEN
       return "OK":U.
    else
       return "NOK":U.

END procedure.
