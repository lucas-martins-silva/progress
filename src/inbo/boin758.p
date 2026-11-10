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
{include/i-prgvrs.i BOIN758 2.00.00.006 } /*** "010006" 20/08/2024 14:51:17 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin758 MUT}
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
&GLOBAL-DEFINE DBOName BOIN758
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName impto-remito-fatur-det
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
{inbo/boin758.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-cod-estabel  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nat-operacao AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-pais    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estado   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nom-cidade   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-codigo    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo    AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-iva-normal   AS LOGICAL   NO-UNDO.

{utp/ut-glob.i}

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
         HEIGHT             = 12.17
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
        WHEN "cod-estado":U THEN ASSIGN pFieldValue = RowObject.cod-estado.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nom-cidade":U THEN ASSIGN pFieldValue = RowObject.nom-cidade.
        WHEN "nome-pais":U THEN ASSIGN pFieldValue = RowObject.nome-pais.
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
        WHEN "cdn-imposto":U THEN ASSIGN pFieldValue = RowObject.cdn-imposto.
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
  Purpose:     Retorna valores dos campos do °ndice imptrmta-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nat-operacao
               retorna valor do campo nome-pais
               retorna valor do campo cod-estado
               retorna valor do campo nom-cidade
               retorna valor do campo fm-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cdn-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE impto-remito-fatur-det.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE impto-remito-fatur-det.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-pais LIKE impto-remito-fatur-det.nome-pais NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estado LIKE impto-remito-fatur-det.cod-estado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnom-cidade LIKE impto-remito-fatur-det.nom-cidade NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE impto-remito-fatur-det.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE impto-remito-fatur-det.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-imposto LIKE impto-remito-fatur-det.cdn-imposto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnat-operacao = RowObject.nat-operacao
           pnome-pais = RowObject.nome-pais
           pcod-estado = RowObject.cod-estado
           pnom-cidade = RowObject.nom-cidade
           pfm-codigo = RowObject.fm-codigo
           pit-codigo = RowObject.it-codigo
           pcdn-imposto = RowObject.cdn-imposto.

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
  Purpose:     Reposiciona registro com base no °ndice imptrmta-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nat-operacao
               recebe valor do campo nome-pais
               recebe valor do campo cod-estado
               recebe valor do campo nom-cidade
               recebe valor do campo fm-codigo
               recebe valor do campo it-codigo
               recebe valor do campo cdn-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE impto-remito-fatur-det.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE impto-remito-fatur-det.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnome-pais LIKE impto-remito-fatur-det.nome-pais NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estado LIKE impto-remito-fatur-det.cod-estado NO-UNDO.
    DEFINE INPUT PARAMETER pnom-cidade LIKE impto-remito-fatur-det.nom-cidade NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo LIKE impto-remito-fatur-det.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE impto-remito-fatur-det.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-imposto LIKE impto-remito-fatur-det.cdn-imposto NO-UNDO.

    FIND FIRST bfimpto-remito-fatur-det WHERE 
        bfimpto-remito-fatur-det.cod-estabel = pcod-estabel AND 
        bfimpto-remito-fatur-det.nat-operacao = pnat-operacao AND 
        bfimpto-remito-fatur-det.nome-pais = pnome-pais AND 
        bfimpto-remito-fatur-det.cod-estado = pcod-estado AND 
        bfimpto-remito-fatur-det.nom-cidade = pnom-cidade AND 
        bfimpto-remito-fatur-det.fm-codigo = pfm-codigo AND 
        bfimpto-remito-fatur-det.it-codigo = pit-codigo AND 
        bfimpto-remito-fatur-det.cdn-imposto = pcdn-imposto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfimpto-remito-fatur-det THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfimpto-remito-fatur-det)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryImptoRemitoFatur DBOProgram 
PROCEDURE openQueryImptoRemitoFatur :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                     {&TableName}.cod-estabel  = c-cod-estabel  AND 
                                     {&TableName}.nat-operacao = c-nat-operacao AND 
                                     {&TableName}.nome-pais    = c-nome-pais    AND 
                                     {&TableName}.cod-estado   = c-cod-estado   AND 
                                     {&TableName}.nom-cidade   = c-nom-cidade   AND 
                                     {&TableName}.fm-codigo    = c-fm-codigo    AND 
                                     {&tablename}.it-codigo    = c-it-codigo    INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintImptoRemitoFatur DBOProgram 
PROCEDURE setConstraintImptoRemitoFatur :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel  LIKE impto-remito-fatur.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE impto-remito-fatur.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-pais    LIKE impto-remito-fatur.nome-pais    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estado   LIKE impto-remito-fatur.cod-estado   NO-UNDO.
    DEFINE INPUT PARAMETER p-nom-cidade   LIKE impto-remito-fatur.nom-cidade   NO-UNDO.
    DEFINE INPUT PARAMETER p-fm-codigo    LIKE impto-remito-fatur.fm-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo    LIKE impto-remito-fatur.it-codigo    NO-UNDO.

    ASSIGN c-cod-estabel  = p-cod-estabel 
           c-nat-operacao = p-nat-operacao
           c-nome-pais    = p-nome-pais   
           c-cod-estado   = p-cod-estado  
           c-nom-cidade   = p-nom-cidade  
           c-fm-codigo    = p-fm-codigo   
           c-it-codigo    = p-it-codigo.  

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

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF NOT CAN-FIND(first tipo-tax WHERE tipo-tax.cod-tax  = RowObject.cdn-imposto) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgdis tipo-tax 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}  WHERE
                          bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                          bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                          bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                          bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                          bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                          bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                          bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                          bf{&TableName}.cdn-imposto  = RowObject.cdn-imposto) THEN DO:
            /* J† existe ocorrància do registro */
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind impto-remito-fatur-det 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.    

        IF  i-pais-impto-usuario = 33 /* Peru */ THEN DO:
                    
            /* Se j† tiver um IVA normal, n∆o permite cadastrar outro */
            IF  CAN-FIND(FIRST tipo-tax 
                         WHERE tipo-tax.cod-tax  = RowObject.cdn-imposto 
                           AND tipo-tax.tipo     = 2) /* IVA */
            AND CAN-FIND(FIRST tipo-tax-internac
                         WHERE tipo-tax-internac.cod-tax     = RowObject.cdn-imposto
                           AND tipo-tax-internac.log-livre-1 = NO) /* iva normal */ THEN DO:
                              
                FOR EACH bf{&TableName}  WHERE
                         bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                         bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                         bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                         bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                         bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                         bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                         bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                         bf{&TableName}.cdn-imposto  <> RowObject.cdn-imposto  NO-LOCK:

                    IF  CAN-FIND(FIRST tipo-tax 
                                 WHERE tipo-tax.cod-tax  = bf{&TableName}.cdn-imposto 
                                   AND tipo-tax.tipo     = 2)
                    AND CAN-FIND(FIRST tipo-tax-internac
                                 WHERE tipo-tax-internac.cod-tax     =  bf{&TableName}.cdn-imposto
                                   AND tipo-tax-internac.log-livre-1 = NO) /* iva normal */ THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="31881"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U}
                        LEAVE.
                    END.
                END.
            END.
            
            
            /* Se j† tiver um imposto de percepáao, n∆o permite cadastrar outro */
            IF  CAN-FIND(FIRST tipo-tax 
                         WHERE tipo-tax.cod-tax  = RowObject.cdn-imposto 
                           AND tipo-tax.tipo     = 2) /* IVA */
            AND CAN-FIND(FIRST tipo-tax-internac
                         WHERE tipo-tax-internac.cod-tax     = RowObject.cdn-imposto
                           AND tipo-tax-internac.log-livre-1 = YES) /* percepá∆o */ THEN DO:
                              
                FOR EACH bf{&TableName}  WHERE
                         bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                         bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                         bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                         bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                         bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                         bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                         bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                         bf{&TableName}.cdn-imposto  <> RowObject.cdn-imposto  NO-LOCK:

                    IF  CAN-FIND(FIRST tipo-tax 
                                 WHERE tipo-tax.cod-tax  = bf{&TableName}.cdn-imposto 
                                   AND tipo-tax.tipo     = 2) /* IVA */
                    AND CAN-FIND(FIRST tipo-tax-internac
                                 WHERE tipo-tax-internac.cod-tax     =  bf{&TableName}.cdn-imposto
                                   AND tipo-tax-internac.log-livre-1 = YES) /* percepá∆o */ THEN DO:
                                   
                        {utp/ut-liter.i "Percepá∆o" *}
                        {method/svc/errors/inserr.i &ErrorNumber="57884"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="return-value"}
                        LEAVE.
                    END.
                END.
            END.            
        END.
        ELSE DO:        
            /* Demais pa°ses */
            
            IF  i-pais-impto-usuario <> 6 /* Uruguai */
            AND CAN-FIND(first tipo-tax WHERE 
                              tipo-tax.cod-tax  = RowObject.cdn-imposto AND 
                              tipo-tax.tipo     = 2 ) THEN

                FOR EACH bf{&TableName}  WHERE
                         bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                         bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                         bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                         bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                         bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                         bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                         bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                         bf{&TableName}.cdn-imposto  <> RowObject.cdn-imposto  NO-LOCK:

                    IF CAN-FIND(first tipo-tax WHERE 
                                      tipo-tax.cod-tax  = bf{&TableName}.cdn-imposto AND 
                                      tipo-tax.tipo     = 2 ) THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="31881"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U}
                        LEAVE.
                    END.
                END.
        END.
        
        IF CAN-FIND(FIRST tipo-tax WHERE 
                          tipo-tax.cod-tax  = RowObject.cdn-imposto AND 
                          tipo-tax.tipo     = 1 AND /* 1- Retená∆o */
                          tipo-tax.idi-val-base-retenc = 2) THEN DO: /* 2- Base IVA Normal */
           
           ASSIGN l-iva-normal = NO.
           FOR EACH bf{&TableName}  WHERE
                   bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                   bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                   bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                   bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                   bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                   bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                   bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                   bf{&TableName}.cdn-imposto  <> RowObject.cdn-imposto  NO-LOCK:
              IF CAN-FIND(FIRST tipo-tax WHERE 
                                tipo-tax.cod-tax  = bf{&TableName}.cdn-imposto AND 
                                tipo-tax.tipo     = 2 ) THEN DO:
                  ASSIGN l-iva-normal = YES.
                  LEAVE.
              END.
           END.
           IF NOT l-iva-normal THEN DO:
              {method/svc/errors/inserr.i &ErrorNumber="31919"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U}
           END.
        END.
    END.

    IF pType = "Delete":U THEN DO:

        IF CAN-FIND(FIRST tipo-tax WHERE 
                          tipo-tax.cod-tax  = RowObject.cdn-imposto AND 
                          tipo-tax.tipo     = 2 ) THEN DO: 
           FOR EACH bf{&TableName}  WHERE
                    bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                    bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                    bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                    bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                    bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                    bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                    bf{&tablename}.it-codigo    = RowObject.it-codigo    AND 
                    bf{&TableName}.cdn-imposto  <> RowObject.cdn-imposto  NO-LOCK:
              IF CAN-FIND(FIRST tipo-tax WHERE 
                                tipo-tax.cod-tax             = bf{&TableName}.cdn-imposto AND 
                                tipo-tax.tipo                = 1 AND
                                tipo-tax.idi-val-base-retenc = 2 ) THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-este-imposto-de-valor-agregado AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Este_Imposto_de_VALOR_AGREGADO" *}
                  ASSIGN c-lbl-liter-este-imposto-de-valor-agregado = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-um-imposto-de-retencao AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "um_Imposto_de_RETENÄ«O" *}
                  ASSIGN c-lbl-liter-um-imposto-de-retencao = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i &ErrorNumber="17453"
                                              &ErrorType="EMS":U
                                              &ErrorSubType="ERROR":U
                                              &ErrorParameters="c-lbl-liter-este-imposto-de-valor-agregado + '~~~~' + c-lbl-liter-um-imposto-de-retencao"} 
                  LEAVE.
              END.
           END.
        END.

    END.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
