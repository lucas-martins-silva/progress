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
{include/i-prgvrs.i BOCX00465 2.00.00.003 } /*** "010003" 07/10/2024 16:59:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX00465 MUT}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00465
&GLOBAL-DEFINE DBOVersion 1.0.0.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName despes-embarq-internac
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
{cxbo/bocx00465.i RowObject}
{cxbo/bocx00465.i tt{&TableName}}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 10.88
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
        WHEN "embarque":U THEN ASSIGN pFieldValue = RowObject.embarque.
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
        WHEN "val-preco-unit":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit.
        WHEN "val-preco-unit-com-iva":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-com-iva.
        WHEN "val-preco-unit-isento":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-isento.
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
        WHEN "cdn-imposto":U THEN ASSIGN pFieldValue = RowObject.cdn-imposto.
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
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
  Purpose:     Retorna valores dos campos do °ndice dspsmbrq_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo embarque
               retorna valor do campo cod-itiner
               retorna valor do campo cod-pto-contr
               retorna valor do campo cod-desp
               retorna valor do campo cod-emitente-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE despes-embarq-internac.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE despes-embarq-internac.embarque NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-itiner LIKE despes-embarq-internac.cod-itiner NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pto-contr LIKE despes-embarq-internac.cod-pto-contr NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE despes-embarq-internac.cod-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE despes-embarq-internac.cod-emitente-desp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pembarque = RowObject.embarque
           pcod-itiner = RowObject.cod-itiner
           pcod-pto-contr = RowObject.cod-pto-contr
           pcod-desp = RowObject.cod-desp
           pcod-emitente-desp = RowObject.cod-emitente-desp.

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
  Purpose:     Reposiciona registro com base no °ndice dspsmbrq_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo embarque
               recebe valor do campo cod-itiner
               recebe valor do campo cod-pto-contr
               recebe valor do campo cod-desp
               recebe valor do campo cod-emitente-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel       LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAMETER pembarque          LIKE {&TableName}.embarque          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-itiner        LIKE {&TableName}.cod-itiner        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-contr     LIKE {&TableName}.cod-pto-contr     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp          LIKE {&TableName}.cod-desp          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE {&TableName}.cod-emitente-desp NO-UNDO.

    find first bf{&TableName}
         where bf{&TableName}.cod-estabel       = pcod-estabel       
           and bf{&TableName}.embarque          = pembarque          
           and bf{&TableName}.cod-itiner        = pcod-itiner        
           and bf{&TableName}.cod-pto-contr     = pcod-pto-contr     
           and bf{&TableName}.cod-desp          = pcod-desp          
           and bf{&TableName}.cod-emitente-desp = pcod-emitente-desp no-lock no-error.   

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-campos DBOProgram 
PROCEDURE pi-atualiza-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel            LIKE {&TableName}.cod-estabel            NO-UNDO.
    DEFINE INPUT PARAMETER pembarque               LIKE {&TableName}.embarque               NO-UNDO.
    DEFINE INPUT PARAMETER pcod-itiner             LIKE {&TableName}.cod-itiner             NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-contr          LIKE {&TableName}.cod-pto-contr          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp               LIKE {&TableName}.cod-desp               NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp      LIKE {&TableName}.cod-emitente-desp      NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-imposto            LIKE {&TableName}.cdn-imposto            NO-UNDO.
    DEFINE INPUT PARAMETER pval-preco-unit-isento  LIKE {&TableName}.val-preco-unit-isento  NO-UNDO.
    DEFINE INPUT PARAMETER pval-preco-unit-com-iva LIKE {&TableName}.val-preco-unit-com-iva NO-UNDO.
    DEFINE INPUT PARAMETER pval-preco-unit         LIKE {&TableName}.val-preco-unit         NO-UNDO.

    DEFINE VAR l-erro AS LOG NO-UNDO.
    DEFINE VAR l-alteracao AS LOG NO-UNDO.

    FOR EACH tt{&TableName}:
        DELETE tt{&TableName}.    
    END.

    assign l-erro = no.

    BLOCK:
    do transaction on error undo BLOCK, leave BLOCK:
        run openQueryStatic in this-procedure (input "Main":U).
        run emptyRowErrors in this-procedure.

        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.cod-estabel        = pcod-estabel       
               AND bf{&TableName}.embarque           = pembarque          
               AND bf{&TableName}.cod-itiner         = pcod-itiner        
               AND bf{&TableName}.cod-pto-contr      = pcod-pto-contr     
               AND bf{&TableName}.cod-desp           = pcod-desp          
               AND bf{&TableName}.cod-emitente-desp  = pcod-emitente-desp no-lock no-error.   

        if avail bf{&TableName} then do:
            assign l-alteracao = yes.
            run repositionRecord in this-procedure (input rowid(bf{&TableName})).
            if return-value = "OK":U then do:
                run getRecord in this-procedure (output table tt{&TableName}).
                find first tt{&TableName} exclusive-lock no-error.                   
            end.
            else do:
                create tt{&TableName}.
                assign tt{&TableName}.cod-estabel       = pcod-estabel      
                       tt{&TableName}.embarque          = pembarque         
                       tt{&TableName}.cod-itiner        = pcod-itiner       
                       tt{&TableName}.cod-pto-contr     = pcod-pto-contr    
                       tt{&TableName}.cod-desp          = pcod-desp         
                       tt{&TableName}.cod-emitente-desp = pcod-emitente-desp.
            end.
        end.
        else do:
            create tt{&TableName}.    
            assign tt{&TableName}.cod-estabel       = pcod-estabel      
                   tt{&TableName}.embarque          = pembarque         
                   tt{&TableName}.cod-itiner        = pcod-itiner       
                   tt{&TableName}.cod-pto-contr     = pcod-pto-contr    
                   tt{&TableName}.cod-desp          = pcod-desp         
                   tt{&TableName}.cod-emitente-desp = pcod-emitente-desp.
        end.
    
        assign tt{&TableName}.cdn-imposto            = pcdn-imposto           
               tt{&TableName}.val-preco-unit-isento  = pval-preco-unit-isento 
               tt{&TableName}.val-preco-unit-com-iva = pval-preco-unit-com-iva
               tt{&TableName}.val-preco-unit         = pval-preco-unit.


        run setRecord in this-procedure (input table tt{&TableName}).
        if l-alteracao = no then 
            run createRecord in this-procedure.
        else 
            run updateRecord in this-procedure.
    
        if return-value <> "OK":U then do:
            assign l-erro = yes.
            undo BLOCK, leave BLOCK.
        end.
    end.

    release bf{&TableName} no-error.

 
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-complementar DBOProgram 
PROCEDURE pi-complementar :

    /*
      Devuelve "YES" en el output si el punto de control es "complementar". Para saber si es complementar, se busca 
      con el itinerario cual es la secuencia del punto de control de "Nacionalizaá∆o", cual es la de "Chegada",
      y cualquier otro punto que estuviese entre medio de esas secuencias, se asume que es "Complementar".
    */
    
    DEFINE INPUT PARAMETER pcod-estabel   LIKE {&TableName}.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pembarque      LIKE {&TableName}.embarque      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-contr LIKE {&TableName}.cod-pto-contr NO-UNDO.
    DEFINE OUTPUT PARAMETER pcomplementar AS LOG NO-UNDO.
    
    def var i-seq-nacionalizacao as int no-undo.            
    def var i-seq-despesa        as int no-undo.            
    def var i-seq-chegada        as int no-undo.            

    for first historico-embarque no-lock
        where historico-embarque.cod-estabel = pcod-estabel
          and historico-embarque.embarque    = pembarque,
        first itinerario
            where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock,
        first embarque-imp fields(cdn-pto-desembar cdn-pto-chegad)
        where embarque-imp.cod-estabel = historico-embarque.cod-estabel
          and embarque-imp.embarque    =  historico-embarque.embarque no-lock:
    end.
    if avail embarque-imp then do:
        for first historico-embarque
             where historico-embarque.cod-estabel   = pcod-estabel
               and historico-embarque.embarque      = pembarque
               and historico-embarque.cod-itiner    = itinerario.cod-itiner
               and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
            assign i-seq-nacionalizacao = historico-embarque.sequencia. /*Guardo la secuencia de nacionalizacion*/
        end.
        for first historico-embarque
             where historico-embarque.cod-estabel   = pcod-estabel
               and historico-embarque.embarque      = pembarque
               and historico-embarque.cod-itiner    = itinerario.cod-itiner
               and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad no-lock:
            assign i-seq-chegada = historico-embarque.sequencia. /*Guardo la secuencia de chegada*/
        end.
        for first historico-embarque
             where historico-embarque.cod-estabel   = pcod-estabel
               and historico-embarque.embarque      = pembarque
               and historico-embarque.cod-itiner    = itinerario.cod-itiner
               and historico-embarque.cod-pto-contr = pcod-pto-contr no-lock:
            assign i-seq-despesa = historico-embarque.sequencia. /*Guardo la secuencia de la despesa actual*/
        end.
    end.
        
    if i-seq-nacionalizacao < i-seq-despesa and i-seq-despesa < i-seq-chegada then
        assign pcomplementar = yes. /*esto significa que la secuencia es de un punto de control complementar*/
    else
        assign pcomplementar = no. /*No es "complementar"*/

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-despesa-inc-iva DBOProgram 
PROCEDURE pi-despesa-inc-iva :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    define input parameter  pCod-desp     like desp-imp.cod-desp     no-undo.
    define output parameter pInc-base-ipi as log initial no          no-undo.
    
    if can-find(first desp-imp 
                where desp-imp.cod-desp = pCod-desp 
                  and desp-imp.inc-base-ipi) then
        assign pInc-base-ipi = yes.

    return "OK":U.

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

