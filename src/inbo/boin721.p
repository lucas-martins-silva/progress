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
{include/i-prgvrs.i BOIN721 2.00.00.006 } /*** "010006" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN721 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN721
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName Extra-fornec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin721.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


def var i-num-pedido   like pedido-compr.num-pedido no-undo.

def var c-serie-docto  like docum-est.serie-docto   no-undo.
def var c-nat-operacao like docum-est.nat-operacao  no-undo.
def var i-cod-emitente like emitente.cod-emitente   no-undo.
def var c-nro-docto    like docum-est.nro-docto     no-undo.

def var c-program-validate as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteDocum-est DBOProgram 
PROCEDURE deleteDocum-est :
/*------------------------------------------------------------------------------
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    def input param r-docum-est as rowid no-undo.
    
    find docum-est where
         rowid(docum-est) = r-docum-est exclusive-lock no-error.
    if  avail docum-est then
        delete docum-est no-error.
     
    return "OK":U.
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
        WHEN "Cep":U THEN ASSIGN pFieldValue = RowObject.Cep.
        WHEN "Cgc":U THEN ASSIGN pFieldValue = RowObject.Cgc.
        WHEN "Cidade":U THEN ASSIGN pFieldValue = RowObject.Cidade.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "Endereco":U THEN ASSIGN pFieldValue = RowObject.Endereco.
        WHEN "Endereco2":U THEN ASSIGN pFieldValue = RowObject.Endereco2.
        WHEN "Endereco_text":U THEN ASSIGN pFieldValue = RowObject.Endereco_text.
        WHEN "Estado":U THEN ASSIGN pFieldValue = RowObject.Estado.
        WHEN "Nat-operacao":U THEN ASSIGN pFieldValue = RowObject.Nat-operacao.
        WHEN "Nome-emit":U THEN ASSIGN pFieldValue = RowObject.Nome-emit.
        WHEN "Nro-docto":U THEN ASSIGN pFieldValue = RowObject.Nro-docto.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "Pais":U THEN ASSIGN pFieldValue = RowObject.Pais.
        WHEN "Serie-docto":U THEN ASSIGN pFieldValue = RowObject.Serie-docto.
        WHEN "telefone":U THEN ASSIGN pFieldValue = RowObject.telefone.
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
        WHEN "Cod-emitente":U THEN ASSIGN pFieldValue = RowObject.Cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "Num-pedido":U THEN ASSIGN pFieldValue = RowObject.Num-pedido.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo Cod-emitente
               retorna valor do campo Nro-docto
               retorna valor do campo Serie-docto
               retorna valor do campo Nat-operacao
               retorna valor do campo Num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pCod-emitente LIKE Extra-fornec.Cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pNro-docto LIKE Extra-fornec.Nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pSerie-docto LIKE Extra-fornec.Serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pNat-operacao LIKE Extra-fornec.Nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-pedido LIKE Extra-fornec.Num-pedido NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pCod-emitente = RowObject.Cod-emitente
           pNro-docto = RowObject.Nro-docto
           pSerie-docto = RowObject.Serie-docto
           pNat-operacao = RowObject.Nat-operacao
           pNum-pedido = RowObject.Num-pedido.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo Cod-emitente
               recebe valor do campo Nro-docto
               recebe valor do campo Serie-docto
               recebe valor do campo Nat-operacao
               recebe valor do campo Num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCod-emitente LIKE Extra-fornec.Cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pNro-docto LIKE Extra-fornec.Nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pSerie-docto LIKE Extra-fornec.Serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pNat-operacao LIKE Extra-fornec.Nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pNum-pedido LIKE Extra-fornec.Num-pedido NO-UNDO.

    FIND FIRST bfExtra-fornec WHERE 
        bfExtra-fornec.Cod-emitente = pCod-emitente AND 
        bfExtra-fornec.Nro-docto = pNro-docto AND 
        bfExtra-fornec.Serie-docto = pSerie-docto AND 
        bfExtra-fornec.Nat-operacao = pNat-operacao AND 
        bfExtra-fornec.Num-pedido = pNum-pedido NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfExtra-fornec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfExtra-fornec)).
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

    open query {&queryName} for each {&tableName} no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumento DBOProgram 
PROCEDURE openQueryOfDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName}
         where {&tableName}.serie-docto = c-serie-docto
           and {&tableName}.nat-operacao = c-nat-operacao
           and {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.nro-docto    = c-nro-docto no-lock
           indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfPedido DBOProgram 
PROCEDURE openQueryOfPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         where {&tableName}.num-pedido   = i-num-pedido no-lock
           indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAvailExtraFornDocto DBOProgram 
PROCEDURE returnAvailExtraFornDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pSerie-docto  LIKE Extra-fornec.Serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pNat-operacao LIKE Extra-fornec.Nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-emitente LIKE Extra-fornec.Cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pNro-docto    LIKE Extra-fornec.Nro-docto    NO-UNDO.
    DEFINE OUTPUT PARAMETER pExisteExtra  AS LOG NO-UNDO.

    ASSIGN pExisteExtra = CAN-FIND(FIRST bfExtra-fornec 
                                   WHERE bfExtra-fornec.Cod-emitente = pCod-emitente 
                                     AND bfExtra-fornec.Nro-docto    = pNro-docto 
                                     AND bfExtra-fornec.Serie-docto  = pSerie-docto 
                                     AND bfExtra-fornec.Nat-operacao = pNat-operacao).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAvailExtraFornPedido DBOProgram 
PROCEDURE returnAvailExtraFornPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-num-pedido   like extra-fornec.num-pedido   no-undo.
    def output param p-existe-extra-forn as log no-undo.
    
    assign p-existe-extra-forn = can-find(first extra-fornec 
                                          where extra-fornec.num-pedido = p-num-pedido).
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumento DBOProgram 
PROCEDURE setConstraintOfDocumento :
/*------------------------------------------------------------------------------
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-serie-docto  like docum-est.serie-docto   no-undo.
    def input param p-nat-operacao like docum-est.nat-operacao  no-undo.
    def input param p-cod-emitente like emitente.cod-emitente   no-undo.
    def input param p-nro-docto    like docum-est.nro-docto     no-undo.
    
    assign c-serie-docto  = p-serie-docto
           c-nat-operacao = p-nat-operacao
           i-cod-emitente = p-cod-emitente
           c-nro-docto    = p-nro-docto.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfPedido DBOProgram 
PROCEDURE setConstraintOfPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-num-pedido   like extra-fornec.num-pedido   no-undo.
    
    assign i-num-pedido   = p-num-pedido.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNffDocumEst DBOProgram 
PROCEDURE setNffDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pExisteFornec AS LOG NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie-docto  LIKE Extra-fornec.Serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pNat-operacao LIKE Extra-fornec.Nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-emitente LIKE Extra-fornec.Cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pNro-docto    LIKE Extra-fornec.Nro-docto    NO-UNDO.
    
    FIND docum-est WHERE 
         docum-est.Cod-emitente = pCod-emitente AND 
         docum-est.Nro-docto    = pNro-docto    AND 
         docum-est.Serie-docto  = pSerie-docto  AND 
         docum-est.Nat-operacao = pNat-operacao exclusive-lock no-error.
    
    if  avail docum-est then do:
        assign docum-est.nff = yes.
        release docum-est.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProgramValidate DBOProgram 
PROCEDURE setProgramValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-program-validate as char no-undo.

    assign c-program-validate = p-program-validate.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUrgentOrder DBOProgram 
PROCEDURE setUrgentOrder :
/*------------------------------------------------------------------------------
  Notes: Marca o pedido como "emergencial" quando o fornecedor do pedido for 
         tempor†rio.
------------------------------------------------------------------------------*/

    def input param l-urgent     as log no-undo.
    def input param i-num-pedido as int no-undo.
    
    find pedido-compr where
         pedido-compr.num-pedido = i-num-pedido exclusive-lock no-error.
    if  avail pedido-compr then do:
        assign pedido-compr.emergencial = l-urgent.
        release pedido-compr.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    
    if  c-program-validate = "cc0300a":U then do: 
        
    end.
    else if c-program-validate = "re3001a":U then do:
         
         if  rowObject.num-pedido = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pedido" *}
            ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="688" /*Pedido deve ser informado*/
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-pedido"}  
         end.
         else
         /*--- Consiste se o emitente do pedido Ç o mesmo da nota-fiscal ---*/
         for first pedido-compr fields(cod-emitente)
             where pedido-compr.num-pedido = rowObject.num-pedido no-lock:
             
             if  rowObject.cod-emitente <> pedido-compr.cod-emitente then do:
                 def var c-pedido as char no-undo.
                 def var c-docto  as char no-undo.
                 
                 assign c-pedido = "Pedido"
                        c-docto  = "Documento".
                 {method/svc/errors/inserr.i &ErrorNumber="17599" /*Pedido n∆o Ç v†lido para documento*/
                                             &ErrorType="EMS":U
                                             &ErrorSubType="ERROR":U
                                             &ErrorParameters=" c-pedido + '~~~~' + c-docto  "}  
             end.
             else do:
                 /*--- Verifica se o fornecedor do pedido Ç tempor†rio ---*/
                 for first dist-emitente fields(extra-fornec)
                     where dist-emitente.cod-emitente = pedido-compr.cod-emitente no-lock: end.
                 if  avail dist-emitente 
                 and not dist-emitente.extra-fornec then do:
                    {method/svc/errors/inserr.i &ErrorNumber="17599" /*Pedido n∆o Ç v†lido para documento*/
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=" c-pedido + '~~~~' + c-docto  "}  
                 end.
             end. 
         end.
    end.
    
    /*--- Validaá‰es comum aos dois programas(cc0300a,re3001a) ---*/
    if  rowObject.nome-emit = "" then do:
        {utp/ut-field.i mgind extra-fornec nome-emit 1}
        {method/svc/errors/inserr.i &ErrorNumber="17386" /* Raz∆o Social deve ser preenchida */
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="string(return-value)"}  
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


