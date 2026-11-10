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
{include/i-prgvrs.i BOCX00442 2.00.00.007 } /*** "010007" 07/10/2024 16:59:53 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00442
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName adiant-despes
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
{cxbo/bocx00442.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEF VAR c-cod-estab-ini    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF VAR c-cod-estab-fim    LIKE adiant-despes.cod-estab    NO-UNDO.     
DEF VAR d-cdd-adiant-ini   LIKE adiant-despes.cdd-adiant   NO-UNDO.     
DEF VAR d-cdd-adiant-fim   LIKE adiant-despes.cdd-adiant   NO-UNDO.     
DEF VAR i-cdn-emitente-ini LIKE adiant-despes.cdn-emitente NO-UNDO.     
DEF VAR i-cdn-emitente-fim LIKE adiant-despes.cdn-emitente NO-UNDO.
DEF VAR c-nome-abrev-ini   LIKE emitente.nome-abrev        NO-UNDO. 
DEF VAR c-nome-abrev-fim   LIKE emitente.nome-abrev        NO-UNDO.  
DEF VAR d-dat-impl-ini     LIKE adiant-despes.dat-impl     NO-UNDO.     
DEF VAR d-dat-impl-fim     LIKE adiant-despes.dat-impl     NO-UNDO. 

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Temp-Table and Buffer definitions                                    */
{cxbo/bocx00442.i tt-adiant-despes}
{cxbo/bocx00443.i tt-adiant-despes-parc}

DEFINE VARIABLE h-bocx00443   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx250     AS HANDLE      NO-UNDO.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-implant":U THEN ASSIGN pFieldValue = RowObject.dat-implant.
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
        WHEN "cdd-adiant":U THEN ASSIGN pFieldValue = RowObject.cdd-adiant.
        WHEN "val-adiant":U THEN ASSIGN pFieldValue = RowObject.val-adiant.
        WHEN "val-adiant-moed":U THEN ASSIGN pFieldValue = RowObject.val-adiant-moed.
        WHEN "val-adiant-orig":U THEN ASSIGN pFieldValue = RowObject.val-adiant-orig.
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
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "idi-modul":U THEN ASSIGN pFieldValue = RowObject.idi-modul.
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
  Purpose:     Retorna valores dos campos do °ndice adntdsps_id3
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cdd-adiant
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-adiant LIKE adiant-despes.cdd-adiant NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcdd-adiant = RowObject.cdd-adiant.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextSeq DBOProgram 
PROCEDURE piRetornaNrAdiant :
/*------------------------------------------------------------------------------
  Purpose: Retornar o n£mero do proximo adiamento a ser criado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER iCodEstabel  LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER iNrAdiamento LIKE adiant-despes.cdd-adiant  NO-UNDO.

    FOR LAST adiant-despes
        WHERE adiant-despes.cod-estabel = iCodEstabel
        BY adiant-despes.cdd-adiant:
        ASSIGN iNrAdiamento = adiant-despes.cdd-adiant + 1.
    END.

    IF NOT AVAIL adiant-despes THEN
        ASSIGN iNrAdiamento = 1.
                  
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
  Purpose:     Reposiciona registro com base no °ndice adntdsps_id3
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant LIKE adiant-despes.cdd-adiant NO-UNDO.

    FIND FIRST bfadiant-despes WHERE 
        bfadiant-despes.cod-estabel = pcod-estabel AND 
        bfadiant-despes.cdd-adiant = pcdd-adiant NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAdiantamento DBOProgram 
PROCEDURE openQueryByAdiantamento:
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da Query pelos dados do Adiantamento
  Parameters:  <none>
  Notes:       Utilizado no programa de pesquisa z01cx00442.w
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                            WHERE {&TABLENAME}.cod-estabel  >= c-cod-estab-ini       
                            AND   {&TABLENAME}.cod-estabel  <= c-cod-estab-fim 
                            AND   {&TABLENAME}.cdd-adiant   >= d-cdd-adiant-ini      
                            AND   {&TABLENAME}.cdd-adiant   <= d-cdd-adiant-fim
                            AND   {&TABLENAME}.cdn-emitente >= i-cdn-emitente-ini
                            AND   {&TABLENAME}.cdn-emitente <= i-cdn-emitente-fim
                            AND   {&TABLENAME}.dat-implant  >= d-dat-impl-ini          
                            AND   {&TABLENAME}.dat-implant  <= d-dat-impl-fim
                    NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todos os registros da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                       INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaValorAdiantamento DBOProgram 
PROCEDURE piAtualizaValorAdiantamento :
/*:T------------------------------------------------------------------------------
  Purpose:     O valor do adiantamento da tabela adiant-despes deve ser atualizada
               de acordo com as parcelas da tabela adiant-despes-parc
  Parameters:  Entrada: Estabelecimento e N£mero do Adiantamento
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-cod-estabel LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-adiant LIKE adiant-despes.cdd-adiant  NO-UNDO.

    DEFINE VARIABLE de-val-adiant-moed LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    DEFINE VARIABLE de-val-adiant      LIKE adiant-despes-parc.val-adiant      NO-UNDO.

    ASSIGN de-val-adiant-moed = 0
           de-val-adiant      = 0.
    FOR EACH adiant-despes-parc
       WHERE adiant-despes-parc.cod-estabel = pc-cod-estabel
         AND adiant-despes-parc.cdd-adiant  = pde-cdd-adiant NO-LOCK:

        ASSIGN de-val-adiant-moed = de-val-adiant-moed + adiant-despes-parc.val-adiant-moed
               de-val-adiant      = de-val-adiant      + adiant-despes-parc.val-adiant.    
    END.

    FOR FIRST adiant-despes
         WHERE adiant-despes.cod-estabel = pc-cod-estabel
           AND adiant-despes.cdd-adiant  = pde-cdd-adiant EXCLUSIVE-LOCK:
        ASSIGN adiant-despes.val-adiant-moed = de-val-adiant-moed
               adiant-despes.val-adiant      = de-val-adiant.
    END.
    RELEASE adiant-despes.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByAdiantamento DBOProgram 
PROCEDURE setConstraintByAdiantamento :
/*------------------------------------------------------------------------------
  Purpose: Informa chave (inicio e fim) para filtro da query     
  Parameters: p-cod-estab-ini    = C¢digo inicial do estabelecimento
              p-cod-estab-fim    = C¢digo final do estabelecimento
              p-cdd-adiant-ini   = C¢digo inicial do adiantamento
              p-cdd-adiant-fim   = C¢digo final do adiantamento
              p-cdn-emitente-ini = C¢digo inicial do emitente
              p-cdn-emitente-fim = C¢digo final do emitente
              p-dat-impl-ini     = C¢digo inicial da data de implantaá∆o 
              p-dat-impl-fim     = C¢digo final da data de implantaá∆o
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-cod-estab-ini    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF INPUT PARAM p-cod-estab-fim    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF INPUT PARAM p-cdd-adiant-ini   LIKE adiant-despes.cdd-adiant   NO-UNDO.
DEF INPUT PARAM p-cdd-adiant-fim   LIKE adiant-despes.cdd-adiant   NO-UNDO.
DEF INPUT PARAM p-cdn-emitente-ini LIKE adiant-despes.cdn-emitente NO-UNDO.
DEF INPUT PARAM p-cdn-emitente-fim LIKE adiant-despes.cdn-emitente NO-UNDO.
DEF INPUT PARAM p-dat-impl-ini     LIKE adiant-despes.dat-impl     NO-UNDO.  
DEF INPUT PARAM p-dat-impl-fim     LIKE adiant-despes.dat-impl     NO-UNDO.  

ASSIGN c-cod-estab-ini     = p-cod-estab-ini    
       c-cod-estab-fim     = p-cod-estab-fim    
       d-cdd-adiant-ini    = p-cdd-adiant-ini   
       d-cdd-adiant-fim    = p-cdd-adiant-fim   
       i-cdn-emitente-ini  = p-cdn-emitente-ini
       i-cdn-emitente-fim  = p-cdn-emitente-fim
       d-dat-impl-ini      = p-dat-impl-ini     
       d-dat-impl-fim      = p-dat-impl-fim.      

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
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        
        IF pType = "CREATE":U THEN DO:
            IF CAN-FIND(FIRST adiant-despes
                        WHERE adiant-despes.cod-estabel = RowObject.cod-estabel
                          AND adiant-despes.cdd-adiant  = RowObject.cdd-adiant) THEN DO:
                {utp/ut-liter.i "Adiantamento"}
                {method/svc/errors/inserr.i
                        &ErrorNumber="8"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.

        END.

        IF rowObject.cod-estabel = "" THEN DO:
            {utp/ut-liter.i "C¢digo_do_Estabelecimento" *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST estabelec
                            WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
                {utp/ut-liter.i "Estabelecimento"}
                {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RETURN-VALUE} 
            END.
        END.

        IF rowObject.cdn-emitente = ? OR 
           rowObject.cdn-emitente = 0 THEN DO: 
           {utp/ut-liter.i "Emitente"}
           {method/svc/errors/inserr.i
                   &ErrorNumber="265"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR" 
                   &ErrorParameters=RETURN-VALUE}
        END.
        ELSE DO:
           IF NOT CAN-FIND(FIRST emitente
              WHERE emitente.cod-emitente = RowObject.cdn-emitente) THEN DO:
              {utp/ut-liter.i "Emitente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters=RETURN-VALUE} 
           END.
        END.    
        
        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = RowObject.cdn-moeda) THEN DO:
            {utp/ut-liter.i "Moeda"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE} 
        END.

        IF RowObject.val-adiant-moed = 0 THEN DO:
            {utp/ut-liter.i "Valor do Adiantamento"}
            {method/svc/errors/inserr.i
                &ErrorNumber="17394"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="RETURN-VALUE"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose: Executa procedure de criaá∆o da primeira parcela do adiantamento.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL {&TableName} THEN DO:
        RUN piCriaPrimeiraParcela.
    END. 
              
    RETURN "OK":U.
   
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaPrimeiraParcela DBOProgram 
PROCEDURE piCriaPrimeiraParcela :
/*-----------------------------------------*-------------------------------------
  Purpose: Cria a primeira parcela do adiantamento     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-refer     LIKE adiant-despes-parc.cod-refer       NO-UNDO.
    DEFINE VARIABLE c-espec-antecip LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
    DEFINE VARIABLE c-serie-antecip LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
    DEFINE VARIABLE c-return        AS   CHARACTER                          NO-UNDO.

    RUN cxbo/bocx00443.p PERSISTENT SET h-bocx00443.
    RUN cxbo/bocx250.p   PERSISTENT SET h-bocx250.

    RUN picriaReferencia IN h-bocx00443 (INPUT  {&tableName}.cod-estabel, OUTPUT c-cod-refer).
    
    RUN findCodigo IN h-bocx250 (INPUT {&tableName}.cod-estabel,
                                 OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN GetCharField IN h-bocx250 (INPUT "cod-espec-antecip":U, OUTPUT c-espec-antecip).
        RUN GetCharField IN h-bocx250 (INPUT "cod-ser-antecip":U,   OUTPUT c-serie-antecip).
    END.

    IF NOT CAN-FIND(FIRST tt-adiant-despes-parc
                    WHERE tt-adiant-despes-parc.cod-estabel = {&tableName}.cod-estabel
                      AND tt-adiant-despes-parc.cdd-adiant  = {&tableName}.cdd-adiant
                      AND tt-adiant-despes-parc.cod-refer   = c-cod-refer
                      AND tt-adiant-despes-parc.cod-parcela = "01")  THEN DO:

        CREATE tt-adiant-despes-parc.
        ASSIGN tt-adiant-despes-parc.cod-estabel      = {&tableName}.cod-estabel
               tt-adiant-despes-parc.cdd-adiant       = {&tableName}.cdd-adiant
               tt-adiant-despes-parc.cod-refer        = c-cod-refer
               tt-adiant-despes-parc.cod-parcela      = "01":U
               tt-adiant-despes-parc.cod-espec-docto  = c-espec-antecip
               tt-adiant-despes-parc.cod-ser-docto    = c-serie-antecip            
               tt-adiant-despes-parc.cod-tit-ap       = SUBSTRING(STRING({&tableName}.cdd-adiant),1,16)
               tt-adiant-despes-parc.idi-valor        = 2 /*1 - Manual; 2 - Autom†tico*/
               tt-adiant-despes-parc.cdn-emitente     = {&tableName}.cdn-emitente
               tt-adiant-despes-parc.cdn-moeda        = {&tableName}.cdn-moeda
               tt-adiant-despes-parc.val-adiant-moed  = {&tableName}.val-adiant-moed
               tt-adiant-despes-parc.val-adiant-orig  = {&tableName}.val-adiant-moed
               tt-adiant-despes-parc.observacao       = {&tableName}.observacao
               tt-adiant-despes-parc.log-gerou-tit-ap = NO              
               tt-adiant-despes-parc.dat-prev-pagto   = TODAY
               tt-adiant-despes-parc.dat-emissao      = TODAY.                  

        ASSIGN tt-adiant-despes-parc.val-adiant = tt-adiant-despes-parc.val-adiant-moed.
        IF {&tableName}.cdn-moeda <> 0 THEN DO:
            RUN cdp/cd0812.p (INPUT {&tableName}.cdn-moeda,
                              INPUT 0,
                              INPUT tt-adiant-despes-parc.val-adiant-moed,
                              INPUT {&tableName}.dat-implant,
                              OUTPUT tt-adiant-despes-parc.val-adiant).
        
        END.
    END.     

    FOR FIRST tt-adiant-despes-parc:
        RUN openQueryStatic IN h-bocx00443 (INPUT "Main":U) NO-ERROR.       
        RUN emptyRowErrors  IN h-bocx00443.
        RUN emptyRowObject  IN h-bocx00443.
        RUN setRecord       IN h-bocx00443 (INPUT TABLE tt-adiant-despes-parc).
        RUN createRecord    IN h-bocx00443.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00443 (OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.        
    END.
    
    EMPTY TEMP-TABLE tt-adiant-despes-parc.
    
    IF VALID-HANDLE(h-bocx250) THEN DO:
       DELETE PROCEDURE h-bocx250.
       ASSIGN h-bocx250 = ?.
    END.
    IF VALID-HANDLE(h-bocx00443) THEN DO:
        DELETE PROCEDURE h-bocx00443.
        ASSIGN h-bocx00443 = ?.
    END.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

