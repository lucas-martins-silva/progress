&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

{include/i-prgvrs.i BOIN01016 2.00.00.009 } /*** "010009" 30/06/2026 11:42:47 ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01016
&GLOBAL-DEFINE DBOVersion         
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ext-docum-est
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01016.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/*************************  Function Prototypes ********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValidaFormatoVersao DBOProgram 
function fnLimpaChaveAcesso returns character 
    ( input pcValor as character ) :
/*------------------------------------------------------------------------------
    Purpose:     Remove espa‡os e caracteres especiais (., -, / etc.), mantendo apenas letras e n£meros
------------------------------------------------------------------------------*/
    define variable iIndice    as integer   no-undo.
    define variable iCodigoAsc as integer   no-undo.
    define variable cCaractere as character no-undo.
    define variable cRetorno   as character no-undo.

    if pcValor = ? then 
        return "":U.

    do iIndice = 1 to length(pcValor):
        assign cCaractere = substring(pcValor, iIndice, 1)
               iCodigoAsc = asc(caps(cCaractere)).

        if (iCodigoAsc >= 48 and iCodigoAsc <= 57) or   //n£mero
           (iCodigoAsc >= 65 AND iCodigoAsc <= 90) then //letra do alfabeto
            cRetorno = cRetorno + cCaractere.
    end.

    return cRetorno.
end function.

/* _UIB-CODE-BLOCK-END */
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-livre-1":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-livre-5":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-5.
        WHEN "cod-livre-6":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-6.
        WHEN "cod-param":U    THEN ASSIGN pFieldValue = RowObject.cod-param.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U    THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U  THEN ASSIGN pFieldValue = RowObject.serie-docto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-livre-5":U THEN ASSIGN pFieldValue = RowObject.dat-livre-5.
        WHEN "dat-livre-6":U THEN ASSIGN pFieldValue = RowObject.dat-livre-6.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
        WHEN "val-livre-6":U THEN ASSIGN pFieldValue = RowObject.val-livre-6.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-livre-1":U  THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U  THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U  THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U  THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-livre-5":U  THEN ASSIGN pFieldValue = RowObject.num-livre-5.
        WHEN "num-livre-6":U  THEN ASSIGN pFieldValue = RowObject.num-livre-6.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ext_documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo cod-param
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto  LIKE ext-docum-est.serie-docto  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto    LIKE ext-docum-est.nro-docto    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE ext-docum-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE ext-docum-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-param    LIKE ext-docum-est.cod-param    NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto  = RowObject.serie-docto
           pnro-docto    = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pcod-param    = RowObject.cod-param.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U  THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-10":U THEN ASSIGN pFieldValue = RowObject.log-livre-10.
        WHEN "log-livre-2":U  THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U  THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U  THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U  THEN ASSIGN pFieldValue = RowObject.log-livre-5.
        WHEN "log-livre-6":U  THEN ASSIGN pFieldValue = RowObject.log-livre-6.
        WHEN "log-livre-7":U  THEN ASSIGN pFieldValue = RowObject.log-livre-7.
        WHEN "log-livre-8":U  THEN ASSIGN pFieldValue = RowObject.log-livre-8.
        WHEN "log-livre-9":U  THEN ASSIGN pFieldValue = RowObject.log-livre-9.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice ext_documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo cod-param
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto  LIKE ext-docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto    LIKE ext-docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE ext-docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE ext-docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-param    LIKE ext-docum-est.cod-param    NO-UNDO.

    FIND FIRST bfext-docum-est NO-LOCK 
         WHERE bfext-docum-est.serie-docto  = pserie-docto 
           AND bfext-docum-est.nro-docto    = pnro-docto 
           AND bfext-docum-est.cod-emitente = pcod-emitente 
           AND bfext-docum-est.nat-operacao = pnat-operacao 
           AND bfext-docum-est.cod-param    = pcod-param  NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfext-docum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfext-docum-est)).
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

  OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK 
      INDEXED-REPOSITION.
       
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEF VAR c-texto-1 AS CHAR NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF  pType = "Create" 
    AND (   rowObject.cod-param = "inf-compl-dfe-nfag":U 
         OR rowObject.cod-param = "inf-compl-dfe-nfsevia":U
         OR rowObject.cod-param = "inf-compl-dfe-nfgas":U
         or rowObject.cod-param = "inf-compl-dfe-nfsenac":U) THEN DO:
        IF CAN-FIND(FIRST bfext-docum-est
                    WHERE bfext-docum-est.serie-docto  = rowObject.serie-docto
                      AND bfext-docum-est.nro-docto    = rowObject.nro-docto
                      AND bfext-docum-est.nat-operacao = rowObject.nat-operacao
                      AND bfext-docum-est.cod-emitente = rowObject.cod-emitente
                      AND bfext-docum-est.cod-param    = rowObject.cod-param) THEN DO:
              
            {utp/ut-liter.i "Inf_Complementares_DFe" * r}  
            {method/svc/errors/inserr.i
                        &ErrorNumber="1" /*Ja existe ocorrencia informada*/
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        
        
        END.
    END.
    
    case rowObject.cod-param:
        //Validacoes especificas do tipo-dfe-docto = NFAg
        when "inf-compl-dfe-nfag":U then do:
            
            IF  pType = "Create" 
            OR  pType = "Update" THEN DO:
            
                IF  TRIM(SUBSTR(rowObject.cod-livre-1,1,2)) = "3" //Finalidade Emissao 3 = NFAg substituicao
                THEN DO:
                
                    IF  TRIM(rowObject.cod-livre-3) = "" //Motivo Substituicao
                    THEN DO:
                    
                        {utp/ut-liter.i "Motivo_da_Substitui‡Æo" * r}
                        ASSIGN c-texto-1 = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Informado" *r}
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="17167" 
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-texto-1 + '~~~~' + TRIM(RETURN-VALUE)"}        
                    
                    END.
                
                    IF  LENGTH(TRIM(rowObject.cod-livre-2)) <> 44 //chave de acesso substituida
                    THEN DO:
                    
                        {utp/ut-liter.i "Substitu¡da_deve_ter_44_d¡gitos" * r}  
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="58230" 
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}        
                    
                    END.
                
                END.
            
                IF  TRIM(SUBSTR(rowObject.cod-livre-4,1,2)) = "3" //Tipo Faturamento 3 = Faturamento conjunto
                AND LENGTH(TRIM(rowObject.cod-livre-5)) <> 44 //chave de acesso Faturamento Conjunto
                THEN DO:
                
                    {utp/ut-liter.i "Faturada_Conjunto_deve_ter_44_d¡gitos" * r}  
                    {method/svc/errors/inserr.i
                                &ErrorNumber="58230" 
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="TRIM(RETURN-VALUE)"}        
                
                END.
                
            END.
        END. //when "inf-compl-dfe-nfag":U
        
        when "inf-compl-dfe-nfsevia":U then do:
            
            IF  pType = "Create" 
            OR  pType = "Update" THEN DO:
            
                IF  SUBSTR(rowObject.cod-livre-1,1,3) = "101" //nfse via de substituicao gerada
                THEN DO:
                    IF   TRIM(SUBSTR(rowObject.cod-livre-2,1,60)) = "" THEN DO:
                    
                            {utp/ut-liter.i "Chave_Acesso_substitu¡da" * r}
                            ASSIGN c-texto-1 = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i "Informada" * r}
                            {method/svc/errors/inserr.i
                                        &ErrorNumber="17167" 
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-texto-1 + '~~~~' + TRIM(RETURN-VALUE)"}             
                   
                   
                    END.
                    ELSE IF  length(fnLimpaChaveAcesso(trim(rowObject.cod-livre-2))) <> 50 THEN DO:
                      
                           {utp/ut-liter.i "Substitu¡da_deve_ter_50_d¡gitos_desconsiderando_caracteres_especiais" * r}  
                           {method/svc/errors/inserr.i
                                       &ErrorNumber="58230" 
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters="TRIM(RETURN-VALUE)"}             
                      
                         END.
                 
                     //Se motivo substituicao = Outros e descri‡Æo Motivo = branco
                    IF  SUBSTR(rowObject.cod-livre-3,1,2)   = "99"
                    AND SUBSTR(rowObject.cod-livre-4,1,255) = "" THEN DO:
                        {utp/ut-liter.i "Descri‡Æo_Motivo" * r}
                        ASSIGN c-texto-1 = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Informado" * r}
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="17167" 
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-texto-1 + '~~~~' + TRIM(RETURN-VALUE)"}               
                    END.
                END.
            END.    
        END. //when "inf-compl-dfe-nfsevia":U
        
        //Validacoes especificas do tipo-dfe-docto = NFGas
        when "inf-compl-dfe-nfgas":U then do:
            
            IF  pType = "Create" 
            OR  pType = "Update" THEN DO:
            
                IF  TRIM(SUBSTR(rowObject.cod-livre-1,1,2)) = "3" //Finalidade Emissao 3 = NFGas substituicao
                THEN DO:
                
                    /* Valida se a chave foi preenchida e se tem exatamente 44 posi‡äes */
                    if trim(rowObject.cod-livre-2) <> ''                             and
                       length(fnLimpaChaveAcesso(trim(rowObject.cod-livre-2))) <> 44 then do:
                    
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="57878" 
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="''"}                            
                    END.

                    /* Valida obrigatoriedade do Motivo de Devolu‡Æo/Substitui‡Æo */
                    IF  TRIM(SUBSTR(rowObject.cod-livre-3,1,2)) = "" 
                    OR  SUBSTR(rowObject.cod-livre-3,1,2) = ? 
                    THEN DO:
                    
                        {utp/ut-liter.i "Motivo_de_Devolu‡Æo" * r}
                        ASSIGN c-texto-1 = TRIM(RETURN-VALUE).
                        
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="265" 
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-texto-1"}        
                    
                    END. 
                END.
            END.
        END. //when "inf-compl-dfe-nfgas":U
        
        //Validacoes especificas do tipo-dfe-docto = NFSe Nacional
        when "inf-compl-dfe-nfsenac":U then do:
            
            if pType = "Create" or 
               pType = "Update" then do:
               
                //valida‡Æo tamanho da Chave Acesso Substitu¡da 
                if trim(substring(rowObject.cod-livre-2,1,60)) <> ''                              and
                   length(fnLimpaChaveAcesso(trim(substring(rowObject.cod-livre-2,1,60))))  <> 50 then do:
                  
                    {utp/ut-liter.i "Substitu¡da_est _incorreta" * r}
                    assign c-texto-1 = trim(return-value).
                    {utp/ut-liter.i "Chave_Acesso_Substitu¡da_deve_ter_50_d¡gitos_desconsiderando_caracteres_especiais" * r}
                    {method/svc/errors/inserr.i
                                &ErrorNumber="58230" 
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-texto-1 + '~~~~' + trim(return-value)"}                                                        
                end.
               
                //validar Chave X Motivo (se um deles estiver informado, o outro ‚ obrigat¢rio
                if (trim(substring(rowObject.cod-livre-2,1,60)) <> '' and
                    trim(substring(rowObject.cod-livre-3,1,2))  = '')
                    or
                   (trim(substring(rowObject.cod-livre-2,1,60)) = '' and
                    trim(substring(rowObject.cod-livre-3,1,2))  <> '') then do:
                   
                   
                    if trim(substring(rowObject.cod-livre-2,1,60)) <> '' and
                       trim(substring(rowObject.cod-livre-3,1,2))  = '' then do:
                       {utp/ut-liter.i "Quando_Chave_Acesso_Substitu¡da_informada_Motivo_da_Substitui‡Æo" * r}
                       assign c-texto-1 = trim(return-value).
                    end.   
                    else do:
                       {utp/ut-liter.i "Quando_Motivo_da_Substitui‡Æo_informado_Chave_Acesso_Substitu¡da" * r}
                       assign c-texto-1 = trim(return-value).
                    end.
                    
                    {method/svc/errors/inserr.i
                              &ErrorNumber="265" 
                              &ErrorType="EMS":U
                              &ErrorSubType="ERROR":U
                              &ErrorParameters="c-texto-1"}                                  
                end.
               
                //Se motivo substituicao = Outros e descri‡Æo Motivo = branco
                if substr(rowObject.cod-livre-3,1,2)   = "99" and 
                   substr(rowObject.cod-livre-4,1,255) = ""   then do:
                  
                    {utp/ut-liter.i "Quando_Motivo_da_Substitui‡Æo_=_Outros_a_Descri‡Æo_do_Motivo" * r}
                    {method/svc/errors/inserr.i
                              &ErrorNumber="265" 
                              &ErrorType="EMS":U
                              &ErrorSubType="ERROR":U
                              &ErrorParameters="trim(return-value)"}                                  
                end.                   
            end.
        end. //when "inf-compl-dfe-nfsenac":U
    end case.    
    
    
    
    /*:T--- Verifica ocorrˆncia de erros ---*/    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.      
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

