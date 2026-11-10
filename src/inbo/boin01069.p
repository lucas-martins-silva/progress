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
{include/i-prgvrs.i BOIN01069 2.00.00.006 } /*** "010006" 29/11/2023 09:07:14  ***/
    

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01069 MFT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01069
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-lote-internac
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
{inbo/boin01069.i RowObject}
{inbo/boin01069.i tt-rat-lote-internac-2}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define temp-table tt-rat-lote-internac NO-UNDO LIKE rat-lote-internac
    FIELD qtd-orig AS INTEGER.

{cdp/cd3403.i}

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
         HEIGHT             = 15.92
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice rtltntrn_id2
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo lote
               retorna valor do campo cod-depos
               retorna valor do campo cod-localiz
               retorna valor do campo declaracao-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-lote-internac.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-lote-internac.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-lote-internac.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-lote-internac.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-lote-internac.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE rat-lote-internac.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rat-lote-internac.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE rat-lote-internac.lote NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE rat-lote-internac.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz LIKE rat-lote-internac.cod-localiz NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeclaracao-import LIKE rat-lote-internac.declaracao-import NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           plote = RowObject.lote
           pcod-depos = RowObject.cod-depos
           pcod-localiz = RowObject.cod-localiz
           pdeclaracao-import = RowObject.declaracao-import.

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
  Purpose:     Reposiciona registro com base no °ndice rtltntrn_id2
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo lote
               recebe valor do campo cod-depos
               recebe valor do campo cod-localiz
               recebe valor do campo declaracao-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-lote-internac.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-lote-internac.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-lote-internac.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-lote-internac.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-lote-internac.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE rat-lote-internac.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rat-lote-internac.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE rat-lote-internac.lote NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE rat-lote-internac.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz LIKE rat-lote-internac.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pdeclaracao-import LIKE rat-lote-internac.declaracao-import NO-UNDO.

    FIND FIRST bfrat-lote-internac WHERE 
        bfrat-lote-internac.serie-docto = pserie-docto AND 
        bfrat-lote-internac.nro-docto = pnro-docto AND 
        bfrat-lote-internac.cod-emitente = pcod-emitente AND 
        bfrat-lote-internac.nat-operacao = pnat-operacao AND 
        bfrat-lote-internac.sequencia = psequencia AND 
        bfrat-lote-internac.it-codigo = pit-codigo AND 
        bfrat-lote-internac.cod-refer = pcod-refer AND 
        bfrat-lote-internac.lote = plote AND 
        bfrat-lote-internac.cod-depos = pcod-depos AND 
        bfrat-lote-internac.cod-localiz = pcod-localiz AND 
        bfrat-lote-internac.declaracao-import = pdeclaracao-import NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-lote-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-lote-internac)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-registros-rat-lote-internac DBOProgram 
PROCEDURE pi-carrega-registros-rat-lote-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM r-item-doc-est AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-rat-lote-internac-2.
                  
    EMPTY TEMP-TABLE tt-rat-lote-internac-2.

    FIND FIRST item-doc-est NO-LOCK WHERE ROWID(item-doc-est) = r-item-doc-est NO-ERROR.
    IF AVAIL item-doc-est THEN DO:
       FOR EACH bf{&TableName} NO-LOCK
          WHERE bf{&TableName}.cod-emitente  = item-doc-est.cod-emitente
            AND bf{&TableName}.serie-docto   = item-doc-est.serie-docto
            AND bf{&TableName}.nro-docto     = item-doc-est.nro-docto
            AND bf{&TableName}.nat-operacao  = item-doc-est.nat-operacao
            AND bf{&TableName}.sequencia     = item-doc-est.sequencia:
         
           IF NOT CAN-FIND(FIRST tt-rat-lote-internac-2 OF bf{&TableName}) THEN DO:           
               CREATE tt-rat-lote-internac-2.
               BUFFER-COPY bf{&TableName} TO tt-rat-lote-internac-2.
           END.
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-rat-lote-internac DBOProgram 
PROCEDURE pi-cria-rat-lote-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-rat-lote-internac-2.

    FOR EACH tt-rat-lote-internac-2 NO-LOCK:
        FIND FIRST bf{&TableName} OF tt-rat-lote-internac-2 EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL bf{&TableName} THEN
            CREATE bf{&TableName}.

        BUFFER-COPY tt-rat-lote-internac-2 TO bf{&TableName}.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro-origem-remito DBOProgram 
PROCEDURE pi-cria-registro-origem-remito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-rw-remito AS ROWID.
    DEFINE INPUT PARAM p-rw-rat-lote AS ROWID.
    DEFINE INPUT PARAM p-rw-it-dep-remito AS ROWID.
    
    FIND FIRST remito WHERE ROWID(remito) = p-rw-remito NO-LOCK NO-ERROR.
    FIND FIRST rat-lote WHERE ROWID(rat-lote) = p-rw-rat-lote NO-LOCK NO-ERROR.
    FIND FIRST it-dep-remito WHERE ROWID(it-dep-remito) = p-rw-it-dep-remito NO-LOCK NO-ERROR.   

    FOR EACH item-depos-fatur-internac 
       WHERE item-depos-fatur-internac.cdd-embarq   = remito.cdd-embarq
         AND item-depos-fatur-internac.nr-resumo    = remito.nr-resumo        
         AND item-depos-fatur-internac.nome-abrev   = it-dep-remito.nome-abrev  
         AND item-depos-fatur-internac.nr-pedcli    = it-dep-remito.nr-pedcli   
         AND item-depos-fatur-internac.cod-estabel  = it-dep-remito.cod-estabel  
         AND item-depos-fatur-internac.nr-sequencia = it-dep-remito.nr-seq-ped   
         AND item-depos-fatur-internac.it-codigo    = it-dep-remito.it-codigo   
         AND item-depos-fatur-internac.cod-refer    = it-dep-remito.cod-refer 
         AND item-depos-fatur-internac.nr-entrega   = it-dep-remito.nr-entrega 
         AND item-depos-fatur-internac.cod-depos    = it-dep-remito.cod-depos   
         AND item-depos-fatur-internac.cod-localiz  = it-dep-remito.cod-localiz    
         AND item-depos-fatur-internac.nr-serlote   = it-dep-remito.nr-serlote NO-LOCK:

         IF NOT CAN-FIND (FIRST rat-lote-internac
                          WHERE rat-lote-internac.serie-docto       = rat-lote.serie-docto                   
                            and rat-lote-internac.nro-docto         = rat-lote.nro-docto  
                            and rat-lote-internac.cod-emitente      = rat-lote.cod-emitente
                            and rat-lote-internac.nat-operacao      = rat-lote.nat-operacao                                                        
                            and rat-lote-internac.sequencia         = rat-lote.sequencia                     
                            and rat-lote-internac.it-codigo         = rat-lote.it-codigo                     
                            and rat-lote-internac.cod-refer         = rat-lote.cod-refer                    
                            and rat-lote-internac.lote              = rat-lote.lote                          
                            and rat-lote-internac.cod-depos         = rat-lote.cod-depos                     
                            and rat-lote-internac.cod-localiz       = rat-lote.cod-localiz                   
                            AND rat-lote-internac.declaracao-import = item-depos-fatur-internac.declaracao-import) THEN DO:

               CREATE rat-lote-internac.
               ASSIGN rat-lote-internac.serie-docto       = rat-lote.serie-docto                       
                      rat-lote-internac.nro-docto         = rat-lote.nro-docto                         
                      rat-lote-internac.cod-emitente      = rat-lote.cod-emitente                      
                      rat-lote-internac.nat-operacao      = rat-lote.nat-operacao                      
                      rat-lote-internac.sequencia         = rat-lote.sequencia                         
                      rat-lote-internac.it-codigo         = rat-lote.it-codigo                         
                      rat-lote-internac.cod-refer         = rat-lote.cod-refer                         
                      rat-lote-internac.lote              = rat-lote.lote                              
                      rat-lote-internac.cod-depos         = rat-lote.cod-depos                         
                      rat-lote-internac.cod-localiz       = rat-lote.cod-localiz                       
                      rat-lote-internac.declaracao-import = item-depos-fatur-internac.declaracao-import
                      rat-lote-internac.quantidade        = item-depos-fatur-internac.qt-alocada.
         END.
    END.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-devol-cli DBOProgram 
PROCEDURE pi-dados-devol-cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rw-item-doc-est AS ROWID NO-UNDO.
    DEF OUTPUT PARAM p-seq AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-item AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-rat-lote-internac.

    FIND FIRST item-doc-est WHERE ROWID(item-doc-est) = p-rw-item-doc-est NO-LOCK NO-ERROR.
    IF  NOT AVAIL item-doc-est THEN
        RETURN "NOK":U.

    ASSIGN p-seq  = string(item-doc-est.sequencia)
           p-item = item-doc-est.it-codigo.

    EMPTY TEMP-TABLE tt-rat-lote-internac.
    
    FOR EACH bf{&TableName}
       WHERE bf{&TableName}.cod-emitente  = item-doc-est.cod-emitente
         AND bf{&TableName}.serie-docto   = item-doc-est.serie-docto
         AND bf{&TableName}.nro-docto     = item-doc-est.nro-docto
         AND bf{&TableName}.nat-operacao  = item-doc-est.nat-operacao
         AND bf{&TableName}.sequencia     = item-doc-est.sequencia NO-LOCK:
    
        CREATE tt-rat-lote-internac.
        BUFFER-COPY bf{&TableName} TO tt-rat-lote-internac
            ASSIGN tt-rat-lote-internac.qtd-orig  = bf{&TableName}.quantidade.
    END.

    IF  NOT CAN-FIND(FIRST tt-rat-lote-internac) THEN DO:

        FIND FIRST docum-est
            WHERE docum-est.serie-docto       = item-doc-est.serie-docto 
              AND docum-est.nro-docto         = item-doc-est.nro-docto   
              AND docum-est.cod-emitente      = item-doc-est.cod-emitente
              AND docum-est.nat-operacao      = item-doc-est.nat-operacao NO-LOCK NO-ERROR.

        FOR EACH sdo-estoq-internac NO-LOCK
           WHERE sdo-estoq-internac.cod-estabel = docum-est.cod-estabel 
             AND sdo-estoq-internac.it-codigo   = item-doc-est.it-codigo
             AND sdo-estoq-internac.cod-refer   = item-doc-est.cod-refer:

             FIND FIRST tt-rat-lote-internac
                 WHERE tt-rat-lote-internac.serie-docto       = item-doc-est.serie-docto 
                   AND tt-rat-lote-internac.nro-docto         = item-doc-est.nro-docto   
                   AND tt-rat-lote-internac.cod-emitente      = item-doc-est.cod-emitente
                   AND tt-rat-lote-internac.nat-operacao      = item-doc-est.nat-operacao
                   AND tt-rat-lote-internac.sequencia         = item-doc-est.sequencia   
                   AND tt-rat-lote-internac.it-codigo         = item-doc-est.it-codigo   
                   AND tt-rat-lote-internac.cod-refer         = item-doc-est.cod-refer
                   AND tt-rat-lote-internac.lote              = sdo-estoq-internac.lote
                   AND tt-rat-lote-internac.cod-depos         = sdo-estoq-internac.cod-depos
                   AND tt-rat-lote-internac.cod-localiz       = sdo-estoq-internac.cod-localiz
                   AND tt-rat-lote-internac.declaracao-import = sdo-estoq-internac.declaracao-import NO-LOCK NO-ERROR.
             IF  NOT AVAIL tt-rat-lote-internac THEN DO:
                 CREATE tt-rat-lote-internac.
                 ASSIGN tt-rat-lote-internac.serie-docto       = item-doc-est.serie-docto            
                        tt-rat-lote-internac.nro-docto         = item-doc-est.nro-docto              
                        tt-rat-lote-internac.cod-emitente      = item-doc-est.cod-emitente           
                        tt-rat-lote-internac.nat-operacao      = item-doc-est.nat-operacao           
                        tt-rat-lote-internac.sequencia         = item-doc-est.sequencia              
                        tt-rat-lote-internac.it-codigo         = item-doc-est.it-codigo              
                        tt-rat-lote-internac.cod-refer         = item-doc-est.cod-refer              
                        tt-rat-lote-internac.lote              = sdo-estoq-internac.lote             
                        tt-rat-lote-internac.cod-depos         = sdo-estoq-internac.cod-depos        
                        tt-rat-lote-internac.cod-localiz       = sdo-estoq-internac.cod-localiz      
                        tt-rat-lote-internac.declaracao-import = sdo-estoq-internac.declaracao-import
                        tt-rat-lote-internac.quantidade        = 0. /* o usu†rio ir† indicar quanto de cada pedimento ir† ser retornado. 
                                                                       os que ficarem com saldo zerado ser∆o desconsiderados */
             END.
        END.
    END.
      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-devol-cli-atualiza DBOProgram 
PROCEDURE pi-dados-devol-cli-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAM p-rw-item-doc-est AS ROWID NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-rat-lote-internac.
    DEF OUTPUT PARAM TABLE FOR rowErrors.

    DEF VAR de-qt AS DEC NO-UNDO.

    EMPTY TEMP-TABLE rowErrors.

    FIND FIRST item-doc-est WHERE ROWID(item-doc-est) = p-rw-item-doc-est NO-LOCK NO-ERROR.
    IF  NOT AVAIL item-doc-est THEN
        RETURN "NOK":U.

    FOR EACH tt-rat-lote-internac:
        ASSIGN de-qt = de-qt + tt-rat-lote-internac.quantidade.
    END.

    IF  de-qt > item-doc-est.quantidade THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber     = "33941"
                                    &ErrorType       = "EMS"
                                    &ErrorSubType    = "ERROR"
                                    &ErrorParameters = "''"}
        RETURN "NOK":U.
    END.
    
    /* Elimina todos os registros que n∆o tiver valor para entrada */
    FOR EACH tt-rat-lote-internac
        WHERE tt-rat-lote-internac.quantidade <= 0:

        FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.serie-docto       = tt-rat-lote-internac.serie-docto       
              AND bf{&TableName}.nro-docto         = tt-rat-lote-internac.nro-docto         
              AND bf{&TableName}.cod-emitente      = tt-rat-lote-internac.cod-emitente      
              AND bf{&TableName}.nat-operacao      = tt-rat-lote-internac.nat-operacao      
              AND bf{&TableName}.sequencia         = tt-rat-lote-internac.sequencia         
              AND bf{&TableName}.it-codigo         = tt-rat-lote-internac.it-codigo         
              AND bf{&TableName}.cod-refer         = tt-rat-lote-internac.cod-refer         
              AND bf{&TableName}.lote              = tt-rat-lote-internac.lote              
              AND bf{&TableName}.cod-depos         = tt-rat-lote-internac.cod-depos         
              AND bf{&TableName}.cod-localiz       = tt-rat-lote-internac.cod-localiz       
              AND bf{&TableName}.declaracao-import = tt-rat-lote-internac.declaracao-import EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL bf{&TableName} THEN
            DELETE bf{&TableName}.

        DELETE tt-rat-lote-internac.
    END.

    /* Os valores com quantidade s∆o gerados na tabela de extens∆o */
    FOR EACH tt-rat-lote-internac:

        FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.serie-docto       = tt-rat-lote-internac.serie-docto       
              AND bf{&TableName}.nro-docto         = tt-rat-lote-internac.nro-docto         
              AND bf{&TableName}.cod-emitente      = tt-rat-lote-internac.cod-emitente      
              AND bf{&TableName}.nat-operacao      = tt-rat-lote-internac.nat-operacao      
              AND bf{&TableName}.sequencia         = tt-rat-lote-internac.sequencia         
              AND bf{&TableName}.it-codigo         = tt-rat-lote-internac.it-codigo         
              AND bf{&TableName}.cod-refer         = tt-rat-lote-internac.cod-refer         
              AND bf{&TableName}.lote              = tt-rat-lote-internac.lote              
              AND bf{&TableName}.cod-depos         = tt-rat-lote-internac.cod-depos         
              AND bf{&TableName}.cod-localiz       = tt-rat-lote-internac.cod-localiz       
              AND bf{&TableName}.declaracao-import = tt-rat-lote-internac.declaracao-import EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL bf{&TableName} THEN DO:
            CREATE bf{&TableName}.
            ASSIGN bf{&TableName}.serie-docto       = tt-rat-lote-internac.serie-docto      
                   bf{&TableName}.nro-docto         = tt-rat-lote-internac.nro-docto        
                   bf{&TableName}.cod-emitente      = tt-rat-lote-internac.cod-emitente     
                   bf{&TableName}.nat-operacao      = tt-rat-lote-internac.nat-operacao     
                   bf{&TableName}.sequencia         = tt-rat-lote-internac.sequencia        
                   bf{&TableName}.it-codigo         = tt-rat-lote-internac.it-codigo        
                   bf{&TableName}.cod-refer         = tt-rat-lote-internac.cod-refer        
                   bf{&TableName}.lote              = tt-rat-lote-internac.lote             
                   bf{&TableName}.cod-depos         = tt-rat-lote-internac.cod-depos        
                   bf{&TableName}.cod-localiz       = tt-rat-lote-internac.cod-localiz      
                   bf{&TableName}.declaracao-import = tt-rat-lote-internac.declaracao-import.
        END.

        ASSIGN bf{&TableName}.quantidade = tt-rat-lote-internac.quantidade.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-devol-forn DBOProgram 
PROCEDURE pi-dados-devol-forn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM c-tabela         AS CHAR  NO-UNDO.
    DEF INPUT  PARAM p-r-rowid        AS ROWID NO-UNDO.
    DEF OUTPUT PARAM p-seq            AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM p-item           AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM p-desc-item      AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-rat-lote.
    DEF OUTPUT PARAM TABLE FOR tt-saldo-aloc.

    EMPTY TEMP-TABLE tt-rat-lote.
    EMPTY TEMP-TABLE tt-saldo-aloc.

     IF c-tabela = "item-doc-est":U THEN DO: /* Origem RE4001C */
        FIND FIRST item-doc-est WHERE ROWID(item-doc-est) = p-r-rowid NO-LOCK NO-ERROR.
        IF  NOT AVAIL item-doc-est THEN
            RETURN "NOK":U.

        FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.
        IF NOT AVAIL docum-est THEN RETURN "NOK":U.

        FOR EACH rat-lote OF item-doc-est NO-LOCK:
            CREATE tt-rat-lote.
            BUFFER-COPY rat-lote TO tt-rat-lote
                ASSIGN tt-rat-lote.cod-estabel = docum-est.cod-estabel.
        END.

        FIND FIRST item WHERE item.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
        ASSIGN p-seq       = string(item-doc-est.sequencia)
               p-item      = item-doc-est.it-codigo
               p-desc-item = item.desc-item.
    END.
    ELSE DO: /* Origem RE4001B */
        FIND FIRST rat-lote WHERE ROWID(rat-lote) = p-r-rowid NO-LOCK NO-ERROR.
        IF  NOT AVAIL rat-lote THEN
            RETURN "NOK":U.

        FIND FIRST docum-est OF rat-lote NO-LOCK NO-ERROR.
        IF NOT AVAIL docum-est THEN RETURN "NOK":U.

        CREATE tt-rat-lote.
        BUFFER-COPY rat-lote TO tt-rat-lote
            ASSIGN tt-rat-lote.cod-estabel = docum-est.cod-estabel.

        FIND FIRST item WHERE item.it-codigo = rat-lote.it-codigo NO-LOCK NO-ERROR.
        ASSIGN p-seq       = string(rat-lote.sequencia)
               p-item      = rat-lote.it-codigo
               p-desc-item = item.desc-item.
    END. 

    FOR EACH tt-rat-lote NO-LOCK:

        /* Cria saldos */
        FOR EACH sdo-estoq-internac NO-LOCK
            WHERE sdo-estoq-internac.cod-estabel = tt-rat-lote.cod-estabel
              AND sdo-estoq-internac.cod-depos   = tt-rat-lote.cod-depos  
              AND sdo-estoq-internac.cod-localiz = tt-rat-lote.cod-localiz
              AND sdo-estoq-internac.it-codigo   = tt-rat-lote.it-codigo  
              AND sdo-estoq-internac.cod-refer   = tt-rat-lote.cod-refer  
              AND sdo-estoq-internac.lote        = tt-rat-lote.lote:    

            FIND FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.serie-docto       = tt-rat-lote.serie-docto
                   AND bf{&TableName}.nro-docto         = tt-rat-lote.nro-docto
                   AND bf{&TableName}.cod-emitente      = tt-rat-lote.cod-emitente
                   AND bf{&TableName}.nat-operacao      = tt-rat-lote.nat-operacao
                   AND bf{&TableName}.sequencia         = tt-rat-lote.sequencia
                   AND bf{&TableName}.it-codigo         = tt-rat-lote.it-codigo
                   AND bf{&TableName}.cod-depos         = tt-rat-lote.cod-depos
                   AND bf{&TableName}.cod-localiz       = tt-rat-lote.cod-localiz
                   AND bf{&TableName}.lote              = tt-rat-lote.lote 
                   AND bf{&TableName}.cod-refer         = tt-rat-lote.cod-refer 
                   AND bf{&TableName}.declaracao-import = sdo-estoq-internac.declaracao-import NO-ERROR.

            CREATE tt-saldo-aloc.
            ASSIGN tt-saldo-aloc.serie-docto       = tt-rat-lote.serie-docto    
                   tt-saldo-aloc.nro-docto         = tt-rat-lote.nro-docto   
                   tt-saldo-aloc.cod-emitente      = tt-rat-lote.cod-emitente
                   tt-saldo-aloc.nat-operacao      = tt-rat-lote.nat-operacao
                   tt-saldo-aloc.sequencia         = tt-rat-lote.sequencia   
                   tt-saldo-aloc.cod-estabel       = tt-rat-lote.cod-estabel
                   tt-saldo-aloc.it-codigo         = tt-rat-lote.it-codigo           
                   tt-saldo-aloc.cod-depos         = tt-rat-lote.cod-depos           
                   tt-saldo-aloc.cod-localiz       = tt-rat-lote.cod-localiz         
                   tt-saldo-aloc.lote              = tt-rat-lote.lote                
                   tt-saldo-aloc.cod-refer         = tt-rat-lote.cod-refer           
                   tt-saldo-aloc.declaracao-import = sdo-estoq-internac.declaracao-import
                   tt-saldo-aloc.qt-alocada        = IF  AVAIL bf{&TableName} THEN bf{&TableName}.quantidade ELSE 0
                   tt-saldo-aloc.qt-aloc-orig      = tt-saldo-aloc.qt-alocada /* necess rio para atualizaá∆o da alocaá∆o do saldo ao final */
                   tt-saldo-aloc.qt-dispon         = sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada.

            /* Desconsidera saldos zerados */
            IF  tt-saldo-aloc.qt-dispon = 0 AND tt-saldo-aloc.qt-alocada = 0 THEN
                DELETE tt-saldo-aloc.
        END.

        /* Se n∆o existir saldo dispon°vel em aduana, n∆o cria o registro para apresentaá∆o na tela */
        IF  NOT CAN-FIND(FIRST tt-saldo-aloc 
                         WHERE tt-saldo-aloc.serie-docto   = tt-rat-lote.serie-docto  
                           AND tt-saldo-aloc.nro-docto     = tt-rat-lote.nro-docto    
                           AND tt-saldo-aloc.cod-emitente  = tt-rat-lote.cod-emitente 
                           AND tt-saldo-aloc.nat-operacao  = tt-rat-lote.nat-operacao 
                           AND tt-saldo-aloc.sequencia     = tt-rat-lote.sequencia    
                           AND tt-saldo-aloc.it-codigo     = tt-rat-lote.it-codigo        
                           AND tt-saldo-aloc.cod-depos     = tt-rat-lote.cod-depos    
                           AND tt-saldo-aloc.cod-localiz   = tt-rat-lote.cod-localiz      
                           AND tt-saldo-aloc.lote          = tt-rat-lote.lote          
                           AND tt-saldo-aloc.cod-refer     = tt-rat-lote.cod-refer) THEN DELETE tt-rat-lote.
    END.

      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-devol-forn-atualiza DBOProgram 
PROCEDURE pi-dados-devol-forn-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEF  INPUT PARAM TABLE FOR tt-rat-lote.
    DEF  INPUT PARAM TABLE FOR tt-saldo-aloc.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE rowErrors.

    DEF VAR de-alocado AS DEC NO-UNDO.
    DEF VAR de-saldo   AS DEC NO-UNDO.
    DEF VAR de-dispon  AS DEC NO-UNDO.
    DEF VAR de-saldo-sem-dp LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEF VAR de-alocar-no-dp LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEF VAR c-return AS CHAR NO-UNDO.    

    /* Verifica se todos foram digitados corretamente */
    FOR EACH tt-rat-lote NO-LOCK:

        ASSIGN de-saldo   = 0
               de-alocado = 0
               de-dispon  = 0.

        FOR EACH saldo-estoq NO-LOCK
            WHERE saldo-estoq.cod-estabel = tt-rat-lote.cod-estabel       
              AND saldo-estoq.cod-depos   = tt-rat-lote.cod-depos  
              AND saldo-estoq.cod-localiz = tt-rat-lote.cod-localiz
              AND saldo-estoq.it-codigo   = tt-rat-lote.it-codigo  
              AND saldo-estoq.cod-refer   = tt-rat-lote.cod-refer  
              AND saldo-estoq.lote        = tt-rat-lote.lote:      
            /* Verifica quanto existe de saldo dispon°vel. */
            ASSIGN de-saldo = saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped.
        END.

        /* Como ao incluir um item no FT4060 n∆o aloca a qtds na saldo-estoq, 
          necess†rio dimimuir as qtd alocados dos documentos digitados */
        FOR EACH wt-fat-ser-lote NO-LOCK
           WHERE wt-fat-ser-lote.cod-depos   = tt-rat-lote.cod-depos  
             AND wt-fat-ser-lote.cod-localiz = tt-rat-lote.cod-localiz
             AND wt-fat-ser-lote.it-codigo   = tt-rat-lote.it-codigo  
             AND wt-fat-ser-lote.cod-refer   = tt-rat-lote.cod-refer  
             AND wt-fat-ser-lote.lote        = tt-rat-lote.lote:   
            ASSIGN de-saldo = de-saldo - wt-fat-ser-lote.quantidade[1].
        END.     

        FOR EACH tt-saldo-aloc
            WHERE tt-saldo-aloc.serie-docto  = tt-rat-lote.serie-docto   
              AND tt-saldo-aloc.nro-docto    = tt-rat-lote.nro-docto    
              AND tt-saldo-aloc.cod-emitente = tt-rat-lote.cod-emitente
              AND tt-saldo-aloc.nat-operacao = tt-rat-lote.nat-operacao
              AND tt-saldo-aloc.sequencia    = tt-rat-lote.sequencia   
              AND tt-saldo-aloc.cod-estabel  = tt-rat-lote.cod-estabel  
              AND tt-saldo-aloc.cod-depos    = tt-rat-lote.cod-depos    
              AND tt-saldo-aloc.cod-localiz  = tt-rat-lote.cod-localiz  
              AND tt-saldo-aloc.it-codigo    = tt-rat-lote.it-codigo    
              AND tt-saldo-aloc.cod-refer    = tt-rat-lote.cod-refer    
              AND tt-saldo-aloc.lote         = tt-rat-lote.lote:       
    
            ASSIGN de-alocado = de-alocado + tt-saldo-aloc.qt-alocada
                   de-dispon  = de-dispon  + tt-saldo-aloc.qt-dispon. 
        END.
        
        /* Calcula a quantidade de saldo que nío tem controle aduana associado, diminuindo o saldo total do dispon°vel em aduanas */
        IF  de-saldo >= de-dispon THEN
            ASSIGN de-saldo-sem-dp = de-saldo - de-dispon.
        ELSE
            ASSIGN de-saldo-sem-dp = de-saldo.         
    
        /* Calcula a quantidade que obrigatoriamente deve ser alocada na aduana */
        ASSIGN de-alocar-no-dp = tt-rat-lote.quantidade - de-saldo-sem-dp.
    
        IF de-alocar-no-dp > de-dispon THEN
            ASSIGN de-alocar-no-dp = de-dispon.

        /* Se a quantidade a alocar ficou negativa, 
           significa que existe saldo sem controle de aduana suficiente para atender toda a alocaá∆o e n†o Ç necess†rio informar nenhum controle. */
        IF  de-alocar-no-dp < 0 THEN
            ASSIGN de-alocar-no-dp = 0.


        /* Verifica se foi informado o valor correto de alocaá‰es nas aduanas */
        IF  de-alocado < de-alocar-no-dp THEN DO:        
            {utp/ut-liter.i "Quantidade informada para o item do dep¢sito"}
            ASSIGN c-return = TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-depos.
            {utp/ut-liter.i "localizaá∆o"}
            ASSIGN c-return = c-return + ", " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-localiz.
            {utp/ut-liter.i "referància"}
            ASSIGN c-return = c-return + ", " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-refer.
            {utp/ut-liter.i "e lote"}
            ASSIGN c-return = c-return + " " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.lote.
            {method/svc/errors/inserr.i &ErrorNumber="416"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-return + '~~~~' + STRING(de-alocar-no-dp)"}
             RETURN "NOK":U.
        END.

        /* Verifica se n∆o foi alocado um valor maior que o dispon°vel no item */
        IF de-alocado > tt-rat-lote.quantidade THEN DO:
            {utp/ut-liter.i "Quantidade informada para o item do dep¢sito"}
            ASSIGN c-return = TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-depos.
            {utp/ut-liter.i "localizaá∆o"}
            ASSIGN c-return = c-return + ", " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-localiz.
            {utp/ut-liter.i "referància"}
            ASSIGN c-return = c-return + ", " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.cod-refer.
            {utp/ut-liter.i "e lote"}
            ASSIGN c-return = c-return + " " + TRIM(RETURN-VALUE) + " " + tt-rat-lote.lote.
            {method/svc/errors/inserr.i &ErrorNumber="508"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-return + '~~~~' + STRING(tt-rat-lote.quantidade)"}
             RETURN "NOK":U.
        END.
    END.
    
    /* Cria registro de extens∆o com as quantidades digitadas */
    FOR EACH tt-rat-lote NO-LOCK:

        FOR EACH tt-saldo-aloc NO-LOCK
            WHERE tt-saldo-aloc.cod-estabel = tt-rat-lote.cod-estabel
              AND tt-saldo-aloc.cod-depos   = tt-rat-lote.cod-depos  
              AND tt-saldo-aloc.cod-localiz = tt-rat-lote.cod-localiz
              AND tt-saldo-aloc.it-codigo   = tt-rat-lote.it-codigo  
              AND tt-saldo-aloc.cod-refer   = tt-rat-lote.cod-refer  
              AND tt-saldo-aloc.lote        = tt-rat-lote.lote:      

            /* considera somente os registros que possuem alguma aloca†ío */
            IF  tt-saldo-aloc.qt-alocada   = 0
            AND tt-saldo-aloc.qt-aloc-orig = 0 THEN
                NEXT.

            FIND FIRST sdo-estoq-internac 
                 WHERE sdo-estoq-internac.cod-estabel       = tt-rat-lote.cod-estabel
                   AND sdo-estoq-internac.cod-depos         = tt-rat-lote.cod-depos  
                   AND sdo-estoq-internac.cod-localiz       = tt-rat-lote.cod-localiz
                   AND sdo-estoq-internac.it-codigo         = tt-rat-lote.it-codigo  
                   AND sdo-estoq-internac.cod-refer         = tt-rat-lote.cod-refer  
                   AND sdo-estoq-internac.lote              = tt-rat-lote.lote
                   AND sdo-estoq-internac.declaracao-import = tt-saldo-aloc.declaracao-import EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL sdo-estoq-internac THEN DO:

                FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                     WHERE bf{&TableName}.serie-docto       = tt-rat-lote.serie-docto             
                       AND bf{&TableName}.nro-docto         = tt-rat-lote.nro-docto               
                       AND bf{&TableName}.cod-emitente      = tt-rat-lote.cod-emitente            
                       AND bf{&TableName}.nat-operacao      = tt-rat-lote.nat-operacao            
                       AND bf{&TableName}.sequencia         = tt-rat-lote.sequencia               
                       AND bf{&TableName}.it-codigo         = tt-rat-lote.it-codigo               
                       AND bf{&TableName}.cod-depos         = tt-rat-lote.cod-depos               
                       AND bf{&TableName}.cod-localiz       = tt-rat-lote.cod-localiz             
                       AND bf{&TableName}.lote              = tt-rat-lote.lote                    
                       AND bf{&TableName}.cod-refer         = tt-rat-lote.cod-refer               
                       AND bf{&TableName}.declaracao-import = sdo-estoq-internac.declaracao-import NO-ERROR.
                IF  NOT AVAIL bf{&TableName} THEN DO:
                    CREATE bf{&TableName}.
                    ASSIGN bf{&TableName}.serie-docto       = tt-rat-lote.serie-docto               
                           bf{&TableName}.nro-docto         = tt-rat-lote.nro-docto                    
                           bf{&TableName}.cod-emitente      = tt-rat-lote.cod-emitente             
                           bf{&TableName}.nat-operacao      = tt-rat-lote.nat-operacao             
                           bf{&TableName}.sequencia         = tt-rat-lote.sequencia                
                           bf{&TableName}.it-codigo         = tt-rat-lote.it-codigo                
                           bf{&TableName}.cod-depos         = tt-rat-lote.cod-depos                
                           bf{&TableName}.cod-localiz       = tt-rat-lote.cod-localiz              
                           bf{&TableName}.lote              = tt-rat-lote.lote                     
                           bf{&TableName}.cod-refer         = tt-rat-lote.cod-refer                
                           bf{&TableName}.declaracao-import = sdo-estoq-internac.declaracao-import.
                END.
    
                ASSIGN bf{&TableName}.quantidade  = bf{&TableName}.quantidade  + tt-saldo-aloc.qt-alocada - tt-saldo-aloc.qt-aloc-orig.
    
                /* elimina da tabela os registros com alocaá∆o zerada */
                IF  bf{&TableName}.quantidade <= 0 THEN
                    DELETE bf{&TableName}.
            END. /*if avail sdo-estoq-internac*/
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-ext DBOProgram 
PROCEDURE pi-elimina-ext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE PARAMETER BUFFER b-item-doc-est FOR item-doc-est.

    FOR EACH bf{&TableName} 
        WHERE bf{&TableName}.serie-docto  = b-item-doc-est.serie-docto    
          AND bf{&TableName}.nro-docto    = b-item-doc-est.nro-docto      
          AND bf{&TableName}.cod-emitente = b-item-doc-est.cod-emitente   
          AND bf{&TableName}.nat-operacao = b-item-doc-est.nat-operacao   
          AND bf{&TableName}.sequencia    = b-item-doc-est.sequencia EXCLUSIVE-LOCK:
        DELETE bf{&TableName}.
    END.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-rat-lote-ext DBOProgram 
PROCEDURE pi-elimina-rat-lote-ext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE PARAMETER BUFFER b-rat-lote FOR rat-lote.

    FOR EACH bf{&TableName} 
        WHERE bf{&TableName}.serie-docto  = b-rat-lote.serie-docto    
          AND bf{&TableName}.nro-docto    = b-rat-lote.nro-docto      
          AND bf{&TableName}.cod-emitente = b-rat-lote.cod-emitente   
          AND bf{&TableName}.nat-operacao = b-rat-lote.nat-operacao   
          AND bf{&TableName}.sequencia    = b-rat-lote.sequencia 
          AND bf{&TableName}.cod-depos    = b-rat-lote.cod-depos 
          AND bf{&TableName}.cod-localiz  = b-rat-lote.cod-localiz
          AND bf{&TableName}.cod-refer    = b-rat-lote.cod-refer 
          AND bf{&TableName}.it-codigo    = b-rat-lote.it-codigo
          AND bf{&TableName}.lote         = b-rat-lote.lote EXCLUSIVE-LOCK:
        DELETE bf{&TableName}.
    END.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-existe-sdo-disp-item-ctrl-aduana DBOProgram 
PROCEDURE pi-verifica-existe-sdo-disp-item-ctrl-aduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM r-rat-lote AS ROWID NO-UNDO.

    FIND FIRST rat-lote WHERE ROWID(rat-lote) = r-rat-lote NO-LOCK NO-ERROR.
    IF  NOT AVAIL rat-lote THEN
        RETURN "NOK":U. 
       
    FIND FIRST docum-est
         WHERE docum-est.serie-docto   = rat-lote.serie-docto 
           AND docum-est.nro-docto     = rat-lote.nro-docto   
           AND docum-est.cod-emitente  = rat-lote.cod-emitente
           AND docum-est.nat-operacao  = rat-lote.nat-operacao NO-LOCK NO-ERROR.
    IF  NOT AVAIL docum-est THEN
        RETURN "NOK":U. 

     IF NOT CAN-FIND (FIRST sdo-estoq-internac NO-LOCK
                      WHERE sdo-estoq-internac.cod-estabel = docum-est.cod-estabel
                        AND sdo-estoq-internac.cod-depos   = rat-lote.cod-depos  
                        AND sdo-estoq-internac.cod-localiz = rat-lote.cod-localiz
                        AND sdo-estoq-internac.it-codigo   = rat-lote.it-codigo  
                        AND sdo-estoq-internac.cod-refer   = rat-lote.cod-refer  
                        AND sdo-estoq-internac.lote        = rat-lote.lote
                       AND (sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada) > 0) THEN RETURN "NOK:U".


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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

