&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2025)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN01126 2.00.00.007 } /* 13/05/2026 21:06:38 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01126 MUT}
&ENDIF
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : Tabela de c¢digo da classificaá∆o tribut†ria cClassTrib
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01126
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est-tribut
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
{inbo/boin01126.i RowObject}
{inbo/boin01126.i tt-docum-est-tribut}
{inbo/boin01126.i2} /*tt-deduzIbsItem*/ 

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-serie-docto  LIKE docum-est-tribut.cod-serie-docto  NO-UNDO.
DEFINE VARIABLE c-cod-num-docto    LIKE docum-est-tribut.cod-num-docto    NO-UNDO.
DEFINE VARIABLE i-cdn-emitente     LIKE docum-est-tribut.cdn-emitente     NO-UNDO.
DEFINE VARIABLE c-cod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
     
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
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "cod-conteudo":U THEN ASSIGN pFieldValue = RowObject.cod-conteudo.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-num-docto":U THEN ASSIGN pFieldValue = RowObject.cod-num-docto.
        WHEN "cod-serie-docto":U THEN ASSIGN pFieldValue = RowObject.cod-serie-docto.
        WHEN "nom-trib":U THEN ASSIGN pFieldValue = RowObject.nom-trib.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice docto-trib
  Parameters:  
               retorna valor do campo cod-serie-docto
               retorna valor do campo cod-num-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo nom-trib
               retorna valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-serie-docto LIKE docum-est-tribut.cod-serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-num-docto LIKE docum-est-tribut.cod-num-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE docum-est-tribut.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnom-trib LIKE docum-est-tribut.nom-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE docum-est-tribut.cod-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-serie-docto = RowObject.cod-serie-docto
           pcod-num-docto = RowObject.cod-num-docto
           pcdn-emitente = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac
           pnom-trib = RowObject.nom-trib
           pcod-campo = RowObject.cod-campo.

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
  Purpose:     Reposiciona registro com base no °ndice docto-trib
  Parameters:  
               recebe valor do campo cod-serie-docto
               recebe valor do campo cod-num-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo nom-trib
               recebe valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto LIKE docum-est-tribut.cod-serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto LIKE docum-est-tribut.cod-num-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE docum-est-tribut.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnom-trib LIKE docum-est-tribut.nom-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo LIKE docum-est-tribut.cod-campo NO-UNDO.

    FIND FIRST bfdocum-est-tribut WHERE 
        bfdocum-est-tribut.cod-serie-docto = pcod-serie-docto AND 
        bfdocum-est-tribut.cod-num-docto = pcod-num-docto AND 
        bfdocum-est-tribut.cdn-emitente = pcdn-emitente AND 
        bfdocum-est-tribut.cod-natur-operac = pcod-natur-operac AND 
        bfdocum-est-tribut.nom-trib = pnom-trib AND 
        bfdocum-est-tribut.cod-campo = pcod-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est-tribut THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est-tribut)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE docum-est-tribut.cod-serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE docum-est-tribut.cod-num-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE docum-est-tribut.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
    

    ASSIGN c-cod-serie-docto  = pcod-serie-docto 
           c-cod-num-docto    = pcod-num-docto   
           i-cdn-emitente     = pcdn-emitente    
           c-cod-natur-operac = pcod-natur-operac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK 
                                WHERE {&TableName}.cod-serie-docto    = c-cod-serie-docto 
                                AND   {&TableName}.cod-num-docto      = c-cod-num-docto   
                                AND   {&TableName}.cdn-emitente       = i-cdn-emitente    
                                AND   {&TableName}.cod-natur-operac   = c-cod-natur-operac
                                INDEXED-REPOSITION.

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
    
    
    IF pType = "Create":U  THEN DO:
            
        FIND FIRST bfdocum-est-tribut 
             WHERE bfdocum-est-tribut.cod-serie-docto  = RowObject.cod-serie-docto 
               AND bfdocum-est-tribut.cod-num-docto    = RowObject.cod-num-docto 
               AND bfdocum-est-tribut.cdn-emitente     = RowObject.cdn-emitente 
               AND bfdocum-est-tribut.cod-natur-operac = RowObject.cod-natur-operac 
               AND bfdocum-est-tribut.nom-trib         = RowObject.nom-trib 
               AND bfdocum-est-tribut.cod-campo        = RowObject.cod-campo NO-LOCK NO-ERROR.
        IF AVAIL bfdocum-est-tribut THEN DO:
            {utp/ut-liter.i "Tributos_do_documento" *}        
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}           

        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTotaisDocumEstTribut DBOProgram  
PROCEDURE createTotaisDocumEstTribut :
/*------------------------------------------------------------------------------
  Purpose:     Gravar os totais base e valor dos novos tributos
  Parameters:  recebe valor do campo cod-serie-docto
               recebe valor do campo cod-num-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               retorna a tt-docum-est-tribut 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE docum-est-tribut.cod-serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE docum-est-tribut.cod-num-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE docum-est-tribut.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est-tribut.
    
    EMPTY TEMP-TABLE tt-deduzIbsItem. 
    RUN createTtDeduzValorIbs( INPUT pcod-serie-docto,   
                               INPUT pcod-num-docto,    
                               INPUT pcdn-emitente,     
                               INPUT pcod-natur-operac,
                               OUTPUT TABLE tt-deduzIbsItem).
                               
    EMPTY TEMP-TABLE tt-docum-est-tribut.
    FOR EACH item-doc-est-tribut NO-LOCK
       WHERE item-doc-est-tribut.cod-serie-docto  = pcod-serie-docto
         AND item-doc-est-tribut.cod-num-docto    = pcod-num-docto
         AND item-doc-est-tribut.cdn-emitente     = pcdn-emitente
         AND item-doc-est-tribut.cod-natur-operac = pcod-natur-operac
          BY item-doc-est-tribut.num-seq:
         
        IF item-doc-est-tribut.nom-trib <> rep.imp.Imposto:CBS
        AND item-doc-est-tribut.nom-trib <> rep.imp.Imposto:IBS-UF
        AND item-doc-est-tribut.nom-trib <> rep.imp.Imposto:IBS-MUN  
        AND item-doc-est-tribut.nom-trib <> rep.imp.Imposto:IS THEN NEXT.

        IF  item-doc-est-tribut.cod-campo <> rep.imp.AtributoImposto:BASE
        AND item-doc-est-tribut.cod-campo <> rep.imp.AtributoImposto:VALOR
        AND item-doc-est-tribut.cod-campo <> rep.imp.AtributoImposto:VALOR-CP THEN NEXT.
         
        FIND FIRST tt-docum-est-tribut exclusive-lock
             WHERE tt-docum-est-tribut.cod-serie-docto  = item-doc-est-tribut.cod-serie-docto 
               AND tt-docum-est-tribut.cod-num-docto    = item-doc-est-tribut.cod-num-docto  
               AND tt-docum-est-tribut.cdn-emitente     = item-doc-est-tribut.cdn-emitente 
               AND tt-docum-est-tribut.cod-natur-operac = item-doc-est-tribut.cod-natur-operac 
               AND tt-docum-est-tribut.nom-trib         = item-doc-est-tribut.nom-trib 
               AND tt-docum-est-tribut.cod-campo        = item-doc-est-tribut.cod-campo NO-ERROR. 
        IF NOT AVAIL tt-docum-est-tribut THEN DO:
            CREATE tt-docum-est-tribut.
            ASSIGN tt-docum-est-tribut.cod-serie-docto  = item-doc-est-tribut.cod-serie-docto 
                   tt-docum-est-tribut.cod-num-docto    = item-doc-est-tribut.cod-num-docto  
                   tt-docum-est-tribut.cdn-emitente     = item-doc-est-tribut.cdn-emitente 
                   tt-docum-est-tribut.cod-natur-operac = item-doc-est-tribut.cod-natur-operac 
                   tt-docum-est-tribut.nom-trib         = item-doc-est-tribut.nom-trib 
                   tt-docum-est-tribut.cod-campo        = item-doc-est-tribut.cod-campo.
        END.
        
        IF item-doc-est-tribut.cod-campo = rep.imp.AtributoImposto:VALOR THEN DO:  
           FIND FIRST tt-deduzIbsItem NO-LOCK 
                WHERE tt-deduzIbsItem.cod-serie-docto   = item-doc-est-tribut.cod-serie-docto 
                  AND tt-deduzIbsItem.cod-num-docto     = item-doc-est-tribut.cod-num-docto   
                  AND tt-deduzIbsItem.cdn-emitente      = item-doc-est-tribut.cdn-emitente    
                  AND tt-deduzIbsItem.cod-natur-operac  = item-doc-est-tribut.cod-natur-operac
                  AND tt-deduzIbsItem.nom-trib          = item-doc-est-tribut.nom-trib        
                  AND tt-deduzIbsItem.num-seq           = item-doc-est-tribut.num-seq NO-ERROR.
           IF AVAIL tt-deduzIbsItem  THEN DO:
               
               IF tt-deduzIbsItem.deduz-ibs THEN
                  ASSIGN tt-docum-est-tribut.cod-conteudo = string(Dec(tt-docum-est-tribut.cod-conteudo) + (dec(item-doc-est-tribut.cod-conteudo) - DEC(tt-deduzIbsItem.valor-ibs))). 
               ELSE 
                  ASSIGN tt-docum-est-tribut.cod-conteudo = string(Dec(tt-docum-est-tribut.cod-conteudo) + dec(item-doc-est-tribut.cod-conteudo)). 
           
           END.
           ELSE 
               ASSIGN tt-docum-est-tribut.cod-conteudo = string(Dec(tt-docum-est-tribut.cod-conteudo) + dec(item-doc-est-tribut.cod-conteudo)).      
        END.
        ELSE ASSIGN tt-docum-est-tribut.cod-conteudo = string(Dec(tt-docum-est-tribut.cod-conteudo) + dec(item-doc-est-tribut.cod-conteudo)).      
       
    END. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTtDeduzValorIbs DBOProgram  
PROCEDURE createTtDeduzValorIbs:
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE docum-est-tribut.cod-serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE docum-est-tribut.cod-num-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE docum-est-tribut.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE docum-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-deduzIbsItem.
   

    FOR FIRST docum-est NO-LOCK 
        WHERE docum-est.serie-docto  = pcod-serie-docto
          AND docum-est.nro-docto    = pcod-num-docto
          AND docum-est.cod-emitente = pcdn-emitente
          AND docum-est.nat-operacao = pcod-natur-operac:
    END.
    FOR EACH item-doc-est-tribut NO-LOCK
       WHERE item-doc-est-tribut.cod-serie-docto  = pcod-serie-docto
         AND item-doc-est-tribut.cod-num-docto    = pcod-num-docto
         AND item-doc-est-tribut.cdn-emitente     = pcdn-emitente
         AND item-doc-est-tribut.cod-natur-operac = pcod-natur-operac
         AND item-doc-est-tribut.nom-trib         = rep.imp.Imposto:IBS-UF
          BY item-doc-est-tribut.num-seq:
              
        IF  item-doc-est-tribut.cod-campo  <> rep.imp.AtributoImposto:C-CLASS-CP            
        AND item-doc-est-tribut.cod-campo  <>  rep.imp.AtributoImposto:VALOR-CP THEN NEXT.
                IF NOT CAN-FIND (FIRST tt-deduzIbsItem  
                         WHERE tt-deduzIbsItem.cod-serie-docto   = item-doc-est-tribut.cod-serie-docto 
                           AND tt-deduzIbsItem.cod-num-docto     = item-doc-est-tribut.cod-num-docto   
                           AND tt-deduzIbsItem.cdn-emitente      = item-doc-est-tribut.cdn-emitente    
                           AND tt-deduzIbsItem.cod-natur-operac  = item-doc-est-tribut.cod-natur-operac
                           AND tt-deduzIbsItem.nom-trib          = item-doc-est-tribut.nom-trib        
                           AND tt-deduzIbsItem.num-seq           = item-doc-est-tribut.num-seq) THEN DO:
            CREATE tt-deduzIbsItem.
            ASSIGN tt-deduzIbsItem.cod-serie-docto   = item-doc-est-tribut.cod-serie-docto 
                   tt-deduzIbsItem.cod-num-docto     = item-doc-est-tribut.cod-num-docto   
                   tt-deduzIbsItem.cdn-emitente      = item-doc-est-tribut.cdn-emitente    
                   tt-deduzIbsItem.cod-natur-operac  = item-doc-est-tribut.cod-natur-operac
                   tt-deduzIbsItem.nom-trib          = item-doc-est-tribut.nom-trib        
                   tt-deduzIbsItem.num-seq           = item-doc-est-tribut.num-seq.
        END.
        IF item-doc-est-tribut.cod-campo = rep.imp.AtributoImposto:C-CLASS-CP  THEN DO:
           ASSIGN tt-deduzIbsItem.c-cred-pres = item-doc-est-tribut.cod-conteudo.
          
            FOR LAST cred-pres NO-LOCK             
               WHERE cred-pres.cod-cred-pres      = tt-deduzIbsItem.c-cred-pres
                 AND cred-pres.data-ini-cadastro <= docum-est.dt-emissao:
            END.
            IF AVAIL cred-pres THEN
               ASSIGN tt-deduzIbsItem.deduz-ibs  = (cred-pres.deduz-cred-pres    = 1).
            
        END.
        
        IF item-doc-est-tribut.cod-campo  =  rep.imp.AtributoImposto:VALOR-CP  THEN
           ASSIGN tt-deduzIbsItem.valor-ibs  = decimal(item-doc-est-tribut.cod-conteudo).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


