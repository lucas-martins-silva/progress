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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01013
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dest-cust-naocfedade
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
{inbo/boin01013.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER bf-naocfedade-carg FOR naocfedade-carg.

DEFINE VARIABLE cod-naocfedade AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-evento   AS CHARACTER NO-UNDO.    
DEFINE VARIABLE i-penalizado   AS INTEGER   NO-UNDO.

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
         HEIGHT             = 17.33
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/        
   ASSIGN RowObject.cod-event-financ = c-cod-evento.   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    ASSIGN RowObject.cod-event-financ = c-cod-evento.
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
        WHEN "cod-event-financ":U THEN ASSIGN pFieldValue = RowObject.cod-event-financ.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
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
        WHEN "dat-vencto":U THEN ASSIGN pFieldValue = RowObject.dat-vencto.
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
        WHEN "val-dest":U THEN ASSIGN pFieldValue = RowObject.val-dest.
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
        WHEN "cdn-destin":U THEN ASSIGN pFieldValue = RowObject.cdn-destin.
        WHEN "cdn-id-movto-event":U THEN ASSIGN pFieldValue = RowObject.cdn-id-movto-event.
        WHEN "cdn-naocfedade":U THEN ASSIGN pFieldValue = RowObject.cdn-naocfedade.
        WHEN "cdn-seq-dest":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-dest.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
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
  Purpose:     Retorna valores dos campos do °ndice dest-cust-id
  Parameters:  
               retorna valor do campo cdn-naocfedade
               retorna valor do campo cdn-seq-dest
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-naocfedade LIKE dest-cust-naocfedade.cdn-naocfedade NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq-dest LIKE dest-cust-naocfedade.cdn-seq-dest NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-naocfedade = RowObject.cdn-naocfedade
           pcdn-seq-dest = RowObject.cdn-seq-dest.

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
  Purpose:     Reposiciona registro com base no °ndice dest-cust-id
  Parameters:  
               recebe valor do campo cdn-naocfedade
               recebe valor do campo cdn-seq-dest
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-naocfedade LIKE dest-cust-naocfedade.cdn-naocfedade NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq-dest LIKE dest-cust-naocfedade.cdn-seq-dest NO-UNDO.

    FIND FIRST bfdest-cust-naocfedade WHERE 
        bfdest-cust-naocfedade.cdn-naocfedade = pcdn-naocfedade AND 
        bfdest-cust-naocfedade.cdn-seq-dest = pcdn-seq-dest NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdest-cust-naocfedade THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdest-cust-naocfedade)).
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDest DBOProgram 
PROCEDURE openQueryDest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK
            WHERE {&TableName}.cdn-naocfedade = cod-naocfedade INDEXED-REPOSITION.

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

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEvento DBOProgram 
PROCEDURE piBuscaEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM  p-num-carg   LIKE naocfedade-carg.num-carg     NO-UNDO.
    DEF INPUT PARAM  p-cod-tipo   LIKE event-aquis-rural.cdn-tipo   NO-UNDO.
    DEF OUTPUT PARAM c-cod-evento LIKE event-aquis-rural.cod-evento NO-UNDO.    
    DEF VAR i-num-carg   LIKE naocfedade-carg.num-carg.  
    DEF VAR i-cod-tipo   LIKE event-aquis-rural.cdn-tipo.   
    
    ASSIGN i-num-carg = p-num-carg.

    IF p-cod-tipo = 1 THEN
        ASSIGN i-cod-tipo = 6.
    IF p-cod-tipo = 2 THEN 
        ASSIGN i-cod-tipo = 5.

    FOR FIRST carg-rural FIELDS(cod-estabel it-codigo) NO-LOCK
        WHERE carg-rural.num-carg = p-num-carg:        
        FOR FIRST event-aquis-rural FIELDS(cod-evento) NO-LOCK
            WHERE event-aquis-rural.cod-estabel = carg-rural.cod-estabel
              AND event-aquis-rural.it-codigo   = carg-rural.it-codigo
              AND event-aquis-rural.cdn-tipo    = i-cod-tipo:             
            ASSIGN c-cod-evento = event-aquis-rural.cod-evento.            
        END.
    END.
    
    IF c-cod-evento = "" THEN 
        RETURN "NOK":U.
        
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDest DBOProgram 
PROCEDURE setConstraintDest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pCodNaoCfedade LIKE histor-naocfedade.cdn-naocfedade.
    
    ASSIGN cod-naocfedade = pCodNaoCfedade.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPenalizado DBOProgram 
PROCEDURE setConstraintPenalizado :
/*------------------------------------------------------------------------------
  Purpose: Seta o tipo de panalizado para realizar validaá‰es    
  Parameters:  pi-penalizado => 1 - Produtor
                                2 - Transportador
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-penalizado  AS INTEGER NO-UNDO.

    ASSIGN i-penalizado = pi-penalizado.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereEmitenteTransportador DBOProgram 
PROCEDURE sugereEmitenteTransportador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cod-transp AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-emitente AS INTEGER NO-UNDO.

    FOR FIRST transporte NO-LOCK
        WHERE transporte.cod-transp = pi-cod-transp: END.

    IF NOT AVAIL transporte THEN
        RETURN "NOK":U.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cgc = transporte.cgc: END.

    IF NOT AVAIL emitente THEN
        RETURN "NOK":U.

    ASSIGN pi-cod-emitente = emitente.cod-emitente.

    RETURN "OK".
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
    
    DEFINE VARIABLE c-param           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-emitente-transp AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-cgc-tranporte   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-cod-transp      AS INTEGER    NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF RowObject.cdn-destin = 0 THEN DO:
        {utp/ut-liter.i Destinario * }
            {method/svc/errors/inserr.i
            &ErrorNumber="265" /* Destinatario deve ser informado */
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="return-value"}
    END.
    ELSE DO:
        CASE i-penalizado:
            WHEN 1 THEN DO: /* PRODUTOR*/
                FOR FIRST naocfedade-carg FIELDS(num-carg)
                    WHERE naocfedade-carg.cdn-naocfedade = RowObject.cdn-naocfedade NO-LOCK:
                    IF NOT CAN-FIND(FIRST produt-carg
                                    WHERE produt-carg.num-carg = naocfedade-carg.num-carg
                                      AND produt-carg.cdn-produt-rural = RowObject.cdn-destin) THEN DO:
                                      
                        ASSIGN c-param = STRING(RowObject.cdn-destin) + "~~":U + STRING(naocfedade-carg.num-carg).
                        {method/svc/errors/inserr.i
                             &ErrorNumber="54882" /* Emitente &1 n„o È um produtor da carga */
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-param"}
                    END.
                    ELSE DO:
                        IF RowObject.cod-propried = "" THEN DO:
                            {utp/ut-liter.i Propriedade * }
                            {method/svc/errors/inserr.i
                                 &ErrorNumber="56"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="return-value"}
                       END. 
                    END.
                END.
            END.
            WHEN 2 THEN DO: /* TRANSPORTADOR */
              
                IF NOT CAN-FIND(FIRST emitente
                                WHERE emitente.cod-emitente = RowObject.cdn-destin) THEN DO:                                                   
                    {method/svc/errors/inserr.i
                         &ErrorNumber="3486" /* Emitente &1 n„o est· cadastrado */
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="STRING(RowObject.cdn-destin)"}
                END.
                ELSE DO:
                    ASSIGN i-emitente-transp = 0
                           c-param           = "".
                         
                    FOR FIRST naocfedade-carg FIELDS(num-carg)
                        WHERE naocfedade-carg.cdn-naocfedade = RowObject.cdn-naocfedade NO-LOCK:
                        FOR FIRST carg-rural FIELDS(cod-transp) NO-LOCK
                            WHERE carg-rural.num-carg = naocfedade-carg.num-carg:
                            FOR FIRST transporte FIELDS(cgc cod-transp) NO-LOCK
                                WHERE transporte.cod-transp = carg-rural.cod-transp:

                                ASSIGN c-param = STRING(transporte.cod-transp) + "~~" + transporte.cgc.

                                FOR FIRST emitente FIELDS(cod-emitente)NO-LOCK
                                    WHERE emitente.cgc = transporte.cgc:
                                    ASSIGN i-emitente-transp = emitente.cod-emitente.
                                END.
                            END.
                        END.
                    END.
                    
                    IF i-emitente-transp <> RowObject.cdn-destin THEN DO:
                        {method/svc/errors/inserr.i
                             &ErrorNumber="54883" /*Transportador da carga n∆o est† cadastrado como Emitente.*/
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-param"} 
                    END.
                END.
                
            END.    
        END CASE.
    END.
    
    ASSIGN c-cod-evento = "".
    FOR FIRST bf-naocfedade-carg FIELDS(num-carg idi-tip-naocfedade) NO-LOCK
        WHERE bf-naocfedade-carg.cdn-naocfedade = RowObject.cdn-naocfedade:   
        RUN piBuscaEvento IN THIS-PROCEDURE(INPUT bf-naocfedade-carg.num-carg,
                                            INPUT bf-naocfedade-carg.idi-tip-naocfedade,
                                            OUTPUT c-cod-evento).                                            
        IF c-cod-evento = "":U THEN DO:
            {method/svc/errors/inserr.i
                 &ErrorNumber="54880" /**N∆o encontrado relacionamento com evento financeiro.*/
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="return-value"}
        END.                                
    END.
        
    
    IF RowObject.val-dest <= 0 THEN DO:     
        {utp/ut-field.i mgind dest-cust-naocfedade val-dest 1 }
        {method/svc/errors/inserr.i
             &ErrorNumber="36"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="RETURN-VALUE"}
    END.
    
    FOR FIRST naocfedade-carg FIELDS(num-carg)
        WHERE naocfedade-carg.cdn-naocfedade = RowObject.cdn-naocfedade NO-LOCK:
        FOR FIRST carg-rural FIELDS(carg-rural.num-carg carg-rural.dat-trans) NO-LOCK
            WHERE carg-rural.num-carg = naocfedade-carg.num-carg
            AND carg-rural.dat-trans > RowObject.dat-vencto:
            {utp/ut-liter.i Vencimento * }
            ASSIGN c-param = RETURN-VALUE + "~~". 
            {utp/ut-liter.i Transaá∆o_da_carga * }
            ASSIGN c-param = c-param + RETURN-VALUE.
                {method/svc/errors/inserr.i
                &ErrorNumber="89"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-param"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSequence DBOProgram 
PROCEDURE validateSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cdn-naocfedade LIKE dest-cust-naocfedade.cdn-naocfedade.
    DEF OUTPUT PARAM p-seq-histor    LIKE dest-cust-naocfedade.cdn-seq-dest.

    ASSIGN cod-naocfedade = p-cdn-naocfedade.
    
    FOR LAST dest-cust-naocfedade FIELDS(dest-cust-naocfedade.cdn-naocfedade dest-cust-naocfedade.cdn-seq-dest)
        WHERE dest-cust-naocfedade.cdn-naocfedade = p-cdn-naocfedade NO-LOCK:
        IF AVAIL dest-cust-naocfedade THEN
            ASSIGN p-seq-histor = dest-cust-naocfedade.cdn-seq-dest + 1.
        IF NOT AVAIL dest-cust-naocfedade THEN
            ASSIGN p-seq-histor = 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

