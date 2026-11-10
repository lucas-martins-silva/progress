&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00990 2.00.00.026 } /*** "010026" 13/11/2023 11:45:45 ***/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00990 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00990
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName produt-pto-coleta
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
{inbo/boin00990.i RowObject}
{inbo/boin00990.i tt-produt-pto-coleta-aux}

/*temp-table usada para mÇtodo que retorna fornecedores por ponto coleta para o EMS 5*/
def temp-table tt_fornecedor_pto_coleta no-undo
    field tta_cod_prop_rural               as character format "x(16)" label "Propriedade Rural" column-label "Prop Rural"
    field tta_cod_pto_coleta               as character format "x(12)" label "Ponto Coleta" column-label "Pto Coleta"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field ttv_log_respons                  as logical format "Sim/N„o" initial no
    field ttv_qtd_coleta                   as decimal format ">>>>,>>>,>>9.9999" decimals 4
    field ttv_qtd_percent_coleta           as decimal format ">>9.99" decimals 2 label "Percentual" column-label "Percentual"
    field ttv_val_valor                    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor" column-label "Valor"
    field ttv_val_quantidade               as decimal format "->>>>,>>>,>>9.9999" decimals 4 label "Quantidade" column-label "Qtdade"
    field tta_num_id_movto_conven          as integer format "999999999" initial 0 label "ID Movto ConvÍnio" column-label "ID Movto"
    .


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER bf{&TableName}-aux FOR {&TableName}.

DEFINE VARIABLE i-cod-pto-coleta LIKE pto-coleta.cod-pto-coleta  NO-UNDO.

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
         HEIGHT             = 15.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindProdutPtoColeta DBOProgram 
PROCEDURE canFindProdutPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cdn-produt-rural AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM pc-cod-pto-coleta AS CHARACTER NO-UNDO.

    IF CAN-FIND(FIRST produt-pto-coleta
                WHERE produt-pto-coleta.cod-pto-coleta   = pc-cod-pto-coleta
                  AND produt-pto-coleta.cdn-produt-rural = pi-cdn-produt-rural) THEN 
        RETURN "OK":U.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaProdutPtoColeta DBOProgram 
PROCEDURE criaProdutPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM TABLE FOR tt-produt-pto-coleta-aux.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE i-cont           AS INT                           NO-UNDO.
    DEFINE VARIABLE c-cod-pto-coleta LIKE {&TableName}.cod-pto-coleta NO-UNDO.
    DEFINE VARIABLE i-cont-resp      AS INT                           NO-UNDO.

    FOR EACH rowErrors:
        DELETE rowErrors.
    END.

    FOR EACH tt-produt-pto-coleta-aux NO-LOCK 
       WHERE tt-produt-pto-coleta-aux.log-respons = YES:
        ASSIGN i-cont-resp = i-cont-resp + 1.
    END.

    IF i-cont-resp = 0 THEN DO:
        {method/svc/errors/inserr.i
                     &ErrorNumber="54632"
                     &ErrorType="EMS"
                     &ErrorParameters=" "}
    END.

    IF i-cont-resp > 1 THEN DO:
        {method/svc/errors/inserr.i
                     &ErrorNumber="54633"
                     &ErrorType="EMS"
                     &ErrorParameters=" "}
    END.

    FOR EACH tt-produt-pto-coleta-aux:

       IF tt-produt-pto-coleta-aux.cod-externo = "" THEN DO:
            
           {utp/ut-liter.i C¢digo_Externo *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="164"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}

       END.

       /*verifica se o campo cod-externo foi alterado e valida se j† existe c¢digo cadastrado*/
       FOR FIRST bf{&TableName}-aux NO-LOCK
           WHERE bf{&TableName}-aux.cdn-produt-rural = tt-produt-pto-coleta-aux.cdn-produt-rural
             AND bf{&TableName}-aux.cod-propried     = tt-produt-pto-coleta-aux.cod-propried  
             AND bf{&TableName}-aux.cod-pto-coleta   = tt-produt-pto-coleta-aux.cod-pto-coleta:

           IF bf{&TableName}-aux.cod-externo <> tt-produt-pto-coleta-aux.cod-externo THEN DO:

               IF CAN-FIND(FIRST bf{&TableName} 
                           WHERE bf{&TableName}.cod-externo = tt-produt-pto-coleta-aux.cod-externo) THEN DO:
        
                   {utp/ut-liter.i C¢digo_Externo *}
                   {method/svc/errors/inserr.i
                            &ErrorNumber="1"
                            &ErrorType="EMS"
                            &ErrorParameters="return-value"} 
        
               END.

           END.
           
       END.
       
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
           RETURN "NOK":U. 

    FOR EACH tt-produt-pto-coleta-aux
       BREAK BY tt-produt-pto-coleta-aux.cod-pto-coleta:

       /*elimina todos antes de fazer a criaá∆o*/
       IF FIRST-OF(tt-produt-pto-coleta-aux.cod-pto-coleta) THEN DO:
           
           FOR EACH bf{&TableName}-aux EXCLUSIVE-LOCK
              WHERE bf{&TableName}-aux.cod-pto-coleta = tt-produt-pto-coleta-aux.cod-pto-coleta:
               DELETE bf{&TableName}-aux.
           END.                

       END.


       ASSIGN i-cont = i-cont + 1
              c-cod-pto-coleta = tt-produt-pto-coleta-aux.cod-pto-coleta.

       IF NOT CAN-FIND(FIRST bf{&TableName} 
                       WHERE bf{&TableName}.cdn-produt-rural = tt-produt-pto-coleta-aux.cdn-produt-rural
                         AND bf{&TableName}.cod-propried     = tt-produt-pto-coleta-aux.cod-propried  
                         AND bf{&TableName}.cod-pto-coleta   = tt-produt-pto-coleta-aux.cod-pto-coleta) THEN DO:
   
           CREATE produt-pto-coleta.
           BUFFER-COPY tt-produt-pto-coleta-aux TO produt-pto-coleta.
           
       END.
       ELSE DO:
            FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                 WHERE bf{&TableName}.cdn-produt-rural = tt-produt-pto-coleta-aux.cdn-produt-rural
                   AND bf{&TableName}.cod-propried     = tt-produt-pto-coleta-aux.cod-propried  
                   AND bf{&TableName}.cod-pto-coleta   = tt-produt-pto-coleta-aux.cod-pto-coleta NO-ERROR.
            IF AVAIL bf{&TableName} THEN DO:
                ASSIGN bf{&TableName}.log-respons = tt-produt-pto-coleta-aux.log-respons 
                       bf{&TableName}.cod-externo = tt-produt-pto-coleta-aux.cod-externo.
            END.
       END.     
    END.

    /*Seta l¢gico do Produtor Coletivo no Ponto de Coleta*/
    FOR FIRST pto-coleta EXCLUSIVE-LOCK
        WHERE pto-coleta.cod-pto-coleta = c-cod-pto-coleta: 
        
        IF i-cont > 1 THEN
            ASSIGN pto-coleta.log-pto-coleta-coletiv = YES.
        ELSE
            ASSIGN pto-coleta.log-pto-coleta-coletiv = NO.
            
    END.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findResponsavel DBOProgram 
PROCEDURE findResponsavel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcCodPtoColeta LIKE {&TableName}.cod-pto-coleta NO-UNDO.
    DEFINE OUTPUT PARAMETER piResponsavel  LIKE {&TableName}.cdn-produt-rural NO-UNDO.
    
    FOR FIRST bfprodut-pto-coleta fields(cdn-produt-rural) NO-LOCK
        WHERE bfprodut-pto-coleta.cod-pto-coleta = pcCodPtoColeta
          AND bfprodut-pto-coleta.log-respons:
    END.
         
    IF NOT AVAIL bfprodut-pto-coleta THEN RETURN 'NOK'.

    ASSIGN piResponsavel = bfprodut-pto-coleta.cdn-produt-rural.
     
    RETURN 'OK':U.    
   
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
        WHEN "cod-externo":U THEN ASSIGN pFieldValue = RowObject.cod-externo.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
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
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
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
  Purpose:     Retorna valores dos campos do °ndice produt-pto-id
  Parameters:  
               retorna valor do campo cdn-produt-rural
               retorna valor do campo cod-pto-coleta
               retorna valor do campo cod-propried
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-produt-rural LIKE produt-pto-coleta.cdn-produt-rural NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pto-coleta LIKE produt-pto-coleta.cod-pto-coleta NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-propried LIKE produt-pto-coleta.cod-propried NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-produt-rural = RowObject.cdn-produt-rural
           pcod-pto-coleta = RowObject.cod-pto-coleta
           pcod-propried = RowObject.cod-propried.

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
        WHEN "log-respons":U THEN ASSIGN pFieldValue = RowObject.log-respons.
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
  Purpose:     Reposiciona registro com base no °ndice produt-pto-id
  Parameters:  
               recebe valor do campo cdn-produt-rural
               recebe valor do campo cod-pto-coleta
               recebe valor do campo cod-propried
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE produt-pto-coleta.cdn-produt-rural NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-coleta LIKE produt-pto-coleta.cod-pto-coleta NO-UNDO.
    DEFINE INPUT PARAMETER pcod-propried LIKE produt-pto-coleta.cod-propried NO-UNDO.

    FIND FIRST bfprodut-pto-coleta WHERE 
        bfprodut-pto-coleta.cdn-produt-rural = pcdn-produt-rural AND 
        bfprodut-pto-coleta.cod-pto-coleta = pcod-pto-coleta AND 
        bfprodut-pto-coleta.cod-propried = pcod-propried NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprodut-pto-coleta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprodut-pto-coleta)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColPropried DBOProgram 
PROCEDURE openQueryPtoColPropried :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF OUTPUT PARAM TABLE FOR tt-produt-pto-coleta-aux.
    EMPTY TEMP-TABLE tt-produt-pto-coleta-aux.

    FOR EACH {&TableName}
       WHERE {&TableName}.cod-pto-coleta   = i-cod-pto-coleta NO-LOCK:

        CREATE tt-produt-pto-coleta-aux.
        BUFFER-COPY {&TableName} TO tt-produt-pto-coleta-aux.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPropried DBOProgram 
PROCEDURE findPropried :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-i-cdn-produt     LIKE RowObject.cdn-produt-rural NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-cod-pto-coleta LIKE RowObject.cod-pto-coleta   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-cod-propried   LIKE RowObject.cod-propried     NO-UNDO.

    
    ASSIGN p-c-cod-propried = "".
    FOR FIRST {&TableName}
       WHERE {&TableName}.cdn-produt-rural = p-i-cdn-produt
         AND {&TableName}.cod-pto-coleta   = p-c-cod-pto-coleta     NO-LOCK:
        ASSIGN p-c-cod-propried = {&TableName}.cod-propried.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPtoColPropried DBOProgram 
PROCEDURE setConstraintPtoColPropried :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-pto-coleta LIKE pto-coleta.cod-pto-coleta     NO-UNDO.
    
    ASSIGN i-cod-pto-coleta = p-cod-pto-coleta.
    
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
    
    DEFINE VARIABLE c-msg1 AS CHAR NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHAR NO-UNDO.


    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    
    
    IF pType = "CREATE" THEN DO:
    
        IF NOT CAN-FIND(FIRST propried-rural
                        WHERE propried-rural.cdn-produt-rural = rowobject.cdn-produt-rural
                          AND propried-rural.cod-propried     = rowobject.cod-propried) THEN DO:
                          
            {utp/ut-liter.i Propriedade_rural * }
            ASSIGN c-msg1 = RETURN-VALUE.
            {utp/ut-liter.i produtor * }
            ASSIGN c-msg2 = c-msg1 + "~~" + RETURN-VALUE.
            
            {method/svc/errors/inserr.i
                        &ErrorNumber="19254" /* propriedade rural nao pertence a produtor informado */
                        &ErrorType="EMS"
                        &ErrorParameters="c-msg2"}
                        
            RETURN "NOK":U.
        END.     
    END.
    
    IF pType = "CREATE" OR pType = "UPDATE" THEN DO:    
        IF CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.cod-externo  = RowObject.cod-externo
                      AND ROWID(bf{&TableName}) <> RowObject.r-rowid) THEN DO:
            {utp/ut-liter.i C¢digo_Externo *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="31717"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}        
        END.  
        
        /*N∆o permitir informar um ponto de coleta */
        IF  RowObject.cod-pto-coleta <> ""
        AND NOT CAN-FIND (FIRST pto-coleta 
                          WHERE pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
            {utp/ut-liter.i Ponto_Coleta *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}        
        END.
       
        /*se a propriedade entrega em ponto de coleta de terceiros, 
         n∆o pode informar um ponto de coleta que seja responsavel*/
        IF  CAN-FIND(FIRST propried-rural
                     WHERE propried-rural.cdn-produt-rural    = rowobject.cdn-produt-rural
                     AND   propried-rural.cod-propried        = rowobject.cod-propried
                     AND   propried-rural.log-entreg-pto-terc = YES)
        AND RowObject.log-respons  THEN DO:
             {method/svc/errors/inserr.i
                     &ErrorNumber="56520"
                     &ErrorType="EMS"
                     &ErrorParameters=RowObject.cod-pto-coleta}  
        END.
    END.    

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFornecedoresPontoColeta DBOProgram 
PROCEDURE retornaFornecedoresPontoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os fornecedores por ponto de coleta.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_fornecedor_pto_coleta.

    FOR EACH tt_fornecedor_pto_coleta EXCLUSIVE-LOCK:
        DELETE tt_fornecedor_pto_coleta.
    END.

    FOR EACH bf{&TableName} FIELDS(cdn-produt-rural cod-pto-coleta cod-propried log-respons) NO-LOCK
        WHERE bf{&TableName}.cod-pto-coleta = p-cod-pto-coleta
          AND bf{&TableName}.cod-propried   = p-cod-propried:
        CREATE tt_fornecedor_pto_coleta.
        ASSIGN tt_fornecedor_pto_coleta.tta_cod_prop_rural = bf{&TableName}.cod-propried
               tt_fornecedor_pto_coleta.tta_cod_pto_coleta = bf{&TableName}.cod-pto-coleta
               tt_fornecedor_pto_coleta.tta_cdn_fornecedor = bf{&TableName}.cdn-produt-rural
               tt_fornecedor_pto_coleta.ttv_log_respons    = bf{&TableName}.log-respons.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN verificaPtoColetivo IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE eliminaProdutPtoColeta :
/*------------------------------------------------------------------------------
  Purpose: Eliminar os pontos de coleta que o produtor entrega para criaÁ„o.   
  Parameters:  <none>
  Notes:  Somente pode entregar em um ponto de terceiros
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-produt-rural AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-propried     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-pto-coleta     AS CHARACTER NO-UNDO.
   
    FOR EACH produt-pto-coleta EXCLUSIVE-LOCK
       WHERE produt-pto-coleta.cdn-produt-rural = pi-cdn-produt-rural
         AND produt-pto-coleta.cod-propried     = pc-cod-propried
         AND produt-pto-coleta.cod-pto-coleta   <> pc-cod-pto-coleta
         AND NOT produt-pto-coleta.log-respons:        
        DELETE produt-pto-coleta.         
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN verificaPtoColetivo IN THIS-PROCEDURE.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN verificaPtoColetivo IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPtoColetivo DBOProgram 
PROCEDURE verificaPtoColetivo :
/*------------------------------------------------------------------------------
  Purpose: Marcar ou desmarcar o ponto de coleta como coletivo.    
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST produt-pto-coleta NO-LOCK
                   WHERE produt-pto-coleta.cod-pto-coleta    = RowObject.cod-pto-coleta
                     AND produt-pto-coleta.cod-propried     <> RowObject.cod-propried) THEN DO:

        FOR FIRST pto-coleta EXCLUSIVE-LOCK
            WHERE pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta:

            ASSIGN pto-coleta.log-pto-coleta-coletiv = YES.

        END.

    END.
    ELSE DO:

        FOR FIRST pto-coleta EXCLUSIVE-LOCK
            WHERE pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta:

            ASSIGN pto-coleta.log-pto-coleta-coletiv = NO.

        END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodExternoByPropriedProdut DBOProgram 
PROCEDURE findCodExternoProdutPtoColetivo:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-produt-rural AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-propried     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cod-externo     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cod-pto-coleta  AS CHARACTER NO-UNDO.

     FOR FIRST propried-rural NO-LOCK
        WHERE propried-rural.cod-propried     =  pc-cod-propried
        AND   propried-rural.cdn-produt-rural = pi-cdn-produt-rural,

        FIRST bfprodut-pto-coleta 
        WHERE bfprodut-pto-coleta.cod-propried    = propried-rural.cod-propried     
         AND bfprodut-pto-coleta.cdn-produt-rural =  propried-rural.cdn-produt-rural
         AND bfprodut-pto-coleta.log-livre-1      = TRUE /*ativo*/ 
         AND ( (    bfprodut-pto-coleta.log-respons = NO 
                 AND propried-rural.log-entreg-pto-terc = YES)
              OR(    bfprodut-pto-coleta.log-respons = YES
                 AND propried-rural.log-entreg-pto-terc = NO) )  NO-LOCK:
        
            ASSIGN pc-cod-externo    = bfprodut-pto-coleta.cod-externo
                   pc-cod-pto-coleta = bfprodut-pto-coleta.cod-pto-coleta.
    END.    
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
