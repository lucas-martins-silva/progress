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

{include/i-prgvrs.i BOIN01066 2.00.00.009 } /*** "010009" 29/09/2026 10:07:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01066 MUT}
&ENDIF
                                                     
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01066
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-estoq-internac
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
{inbo/boin01066.i RowObject}
{rep/re0994c.i}
{cdp/cd1234.i}  


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 5.79
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST internac-decla-aduana
                    WHERE internac-decla-aduana.declaracao-import = RowObject.declaracao-import) THEN DO:

        CREATE internac-decla-aduana.
        BUFFER-COPY RowObject TO internac-decla-aduana.
    END.
          

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Verifico se a declaraá∆o de aduana anterior est† vinculada a outro documento ou se tem saldo movimentado */
    FIND FIRST internac-decla-aduana EXCLUSIVE-LOCK
         WHERE internac-decla-aduana.declaracao-import = RowObject.declaracao-import NO-ERROR.
    IF AVAIL internac-decla-aduana AND 
       NOT CAN-FIND(FIRST bf{&TableName} 
                    WHERE NOT (bf{&TableName}.serie-docto  = RowObject.serie-docto 
                           AND bf{&TableName}.nro-docto    = RowObject.nro-docto   
                           AND bf{&TableName}.cod-emitente = RowObject.cod-emitente
                           AND bf{&TableName}.nat-operacao = RowObject.nat-operacao)
                      AND bf{&TableName}.declaracao-import = internac-decla-aduana.declaracao-import) AND 
       NOT CAN-FIND (FIRST sdo-estoq-internac 
                     WHERE sdo-estoq-internac.declaracao-import = internac-decla-aduana.declaracao-import) THEN
           DELETE internac-decla-aduana.
                  
                  
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
    IF NOT CAN-FIND(FIRST internac-decla-aduana
                    WHERE internac-decla-aduana.declaracao-import = RowObject.declaracao-import) THEN DO:

        CREATE internac-decla-aduana.
        BUFFER-COPY RowObject TO internac-decla-aduana.        
             
    END.

    /* Verifico se a declaraá∆o de aduana anterior est† vinculada a outro documento ou se tem saldo movimentado */
    FIND FIRST bf{&TableName} OF RowObject NO-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} AND (RowObject.declaracao-import <> bf{&TableName}.declaracao-import) THEN DO:

        FIND FIRST internac-decla-aduana EXCLUSIVE-LOCK
             WHERE internac-decla-aduana.declaracao-import = bf{&TableName}.declaracao-import NO-ERROR.

        IF AVAIL internac-decla-aduana AND 
           NOT CAN-FIND(FIRST bf{&TableName} 
                        WHERE NOT (bf{&TableName}.serie-docto  = RowObject.serie-docto 
                               AND bf{&TableName}.nro-docto    = RowObject.nro-docto   
                               AND bf{&TableName}.cod-emitente = RowObject.cod-emitente
                               AND bf{&TableName}.nat-operacao = RowObject.nat-operacao)
                          AND bf{&TableName}.declaracao-import = internac-decla-aduana.declaracao-import) AND 
           NOT CAN-FIND (FIRST sdo-estoq-internac 
                         WHERE sdo-estoq-internac.declaracao-import = internac-decla-aduana.declaracao-import) THEN
           DELETE internac-decla-aduana.            
    END.
                  
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excluirImptoItemDocto DBOProgram
PROCEDURE excluirImptoItemDocto:
    IF NOT AVAILABLE(RowObject) THEN
        RETURN "NOK".
    
    FOR EACH impto-item-docto 
        WHERE impto-item-docto.serie-docto = RowObject.serie-docto
        AND   impto-item-docto.nro-docto = RowObject.nro-docto 
        AND   impto-item-docto.cod-emitente = RowObject.cod-emitente
        AND   impto-item-docto.nat-operacao = RowObject.nat-operacao
        AND   impto-item-docto.cdn-imposto = RowObject.num-livre-1
        EXCLUSIVE-LOCK:
        DELETE impto-item-docto.                               
    END.
    
    RETURN "OK".
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
        WHEN "cod-despch":U THEN ASSIGN pFieldValue = RowObject.cod-despch.
        WHEN "cod-destinac":U THEN ASSIGN pFieldValue = RowObject.cod-destinac.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-verfdor":U THEN ASSIGN pFieldValue = RowObject.cod-verfdor.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
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
        WHEN "data-di":U THEN ASSIGN pFieldValue = RowObject.data-di.
        WHEN "dat-cotacao-ce":U THEN ASSIGN pFieldValue = RowObject.dat-cotacao-ce.
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
        WHEN "cotacao-ce":U THEN ASSIGN pFieldValue = RowObject.cotacao-ce.
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
        WHEN "cdn-aduana":U THEN ASSIGN pFieldValue = RowObject.cdn-aduana.
        WHEN "cdn-agent":U THEN ASSIGN pFieldValue = RowObject.cdn-agent.
        WHEN "cdn-ano-import":U THEN ASSIGN pFieldValue = RowObject.cdn-ano-import.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-operac-import":U THEN ASSIGN pFieldValue = RowObject.idi-operac-import.
        WHEN "idi-tip-comprov":U THEN ASSIGN pFieldValue = RowObject.idi-tip-comprov.
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
  Purpose:     Retorna valores dos campos do °ndice dctstqnt_id2
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE docto-estoq-internac.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE docto-estoq-internac.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE docto-estoq-internac.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE docto-estoq-internac.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao.

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
        WHEN "log-inclui-control-aduana":U THEN ASSIGN pFieldValue = RowObject.log-inclui-control-aduana.
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
  Purpose:     Reposiciona registro com base no °ndice dctstqnt_id2
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docto-estoq-internac.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docto-estoq-internac.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docto-estoq-internac.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docto-estoq-internac.nat-operacao NO-UNDO.

    FIND FIRST bfdocto-estoq-internac WHERE 
        bfdocto-estoq-internac.serie-docto = pserie-docto AND 
        bfdocto-estoq-internac.nro-docto = pnro-docto AND 
        bfdocto-estoq-internac.cod-emitente = pcod-emitente AND 
        bfdocto-estoq-internac.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-estoq-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-estoq-internac)).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE podeCalcularImpostoDetracao DBOProgram
PROCEDURE podeCalcularImpostoDetracao:
    DEFINE OUTPUT PARAMETER p-calcula AS LOGICAL INITIAL FALSE NO-UNDO. 

    DEFINE VARIABLE de-total-documento AS DECIMAL NO-UNDO.       

    IF NOT AVAILABLE(RowObject) THEN
        RETURN.    

    FIND FIRST param-estoq-internac NO-LOCK NO-ERROR.

    IF NOT AVAILABLE(param-estoq-internac) THEN
        RETURN.    

    FIND FIRST docum-est WHERE docum-est.serie-docto = RowObject.serie-docto
                         AND   docum-est.nro-docto = RowObject.nro-docto
                         AND   docum-est.cod-emitente = RowObject.cod-emitente
                         AND   docum-est.nat-operacao = RowObject.nat-operacao
                         NO-LOCK NO-ERROR.
                         
    IF NOT AVAILABLE(docum-est) THEN
        RETURN.                            

    FIND FIRST tipo-tax 
        WHERE tipo-tax.cod-tax = RowObject.num-livre-1
        AND   tipo-tax.tipo = 1 /*Retencao*/
        NO-LOCK NO-ERROR.

    IF NOT AVAILABLE(tipo-tax) THEN
        RETURN.
        
    EMPTY TEMP-TABLE tt-total.
    EMPTY TEMP-TABLE tt-dupli-imp.
    
    RUN rep/re0994e.p(INPUT ROWID(docum-est),
                      OUTPUT TABLE tt-total,
                      OUTPUT TABLE tt-dupli-imp).        
    
    FOR FIRST tt-total:        
        ASSIGN de-total-documento = tt-total.tot-valor-fat - tt-total.tot-taxa-fat. 
    END.                      
    
    IF docum-est.mo-codigo <> 0 THEN
        ASSIGN de-total-documento = fn_ajust_dec(de-total-documento * docum-est.cotacao-dia, docum-est.mo-codigo).
    
    FOR EACH tt-dupli-imp,
        FIRST tipo-tax 
            WHERE tipo-tax.cod-tax = tt-dupli-imp.cod-imposto
            AND   tipo-tax.tipo = 2 /*IVA*/
            NO-LOCK:
        ASSIGN de-total-documento = de-total-documento + tt-dupli-imp.vl-imposto.
    END.        
    
    IF de-total-documento >= param-estoq-internac.dec-1 THEN
        ASSIGN p-calcula = TRUE.
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

        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-controle-aduana-internac"
                      AND funcao.ativo     = YES) THEN DO:        

            IF  RowObject.declaracao-import = ? OR
                RowObject.declaracao-import = "" OR 
                RowObject.declaracao-import = "0" THEN DO:
                IF i-pais-impto-usuario = 4 /* MÇxico */ THEN
                    {utp/ut-liter.i "Decl_Imp_Pedimentos" *}
                ELSE
                    {utp/ut-liter.i "Decl_Imp_Aduana" *}
    
                {method/svc/errors/inserr.i
                             &ErrorNumber="265"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="trim(return-value)"}
            END.
    
            IF RowObject.data-di = ? THEN DO:
                {utp/ut-liter.i "Data_Declaraá∆o" *}
                {method/svc/errors/inserr.i
                             &ErrorNumber="265"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="trim(return-value)"}
            END.
    
            IF RowObject.cdn-aduana = 0 THEN DO:
                {utp/ut-liter.i "C¢d_Aduana" *}
                {method/svc/errors/inserr.i
                             &ErrorNumber="7965"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="trim(return-value)"} 
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST recinto-aduana
                                WHERE recinto-aduana.cdn-aduana = RowObject.cdn-aduana) THEN DO:
                    {utp/ut-liter.i "C¢d_Aduana" *}
                    {method/svc/errors/inserr.i
                                 &ErrorNumber="3657"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="trim(return-value)"}
        
                END.
            END.
    
            IF i-pais-impto-usuario = 4 /* MÇxico */ THEN DO:
                IF RowObject.cdn-agent = 0 THEN DO:
                    {utp/ut-liter.i "Agente" *}
                    {method/svc/errors/inserr.i
                                 &ErrorNumber="7965"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="trim(return-value)"} 
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST agent-internac
                                    WHERE agent-internac.cdn-agent = RowObject.cdn-agent) THEN DO:
                        {utp/ut-liter.i "Agente" *}
                        {method/svc/errors/inserr.i
                                     &ErrorNumber="3657"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="trim(return-value)"}
            
                    END.
                END.
                
                IF RowObject.cod-chave-operacao = "" OR 
                   RowObject.cod-chave-operacao = ? THEN DO:
                    {utp/ut-liter.i "Chave_de_Operaá∆o" *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber="265"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="trim(return-value)"} 
                END.                
            END.
        END.
    END.
    
    IF i-pais-impto-usuario = 33 /* Peru */ THEN DO:
        IF RowObject.num-livre-1 <> 0 THEN DO:
            FIND FIRST tipo-tax NO-LOCK
                WHERE tipo-tax.cod-tax = RowObject.num-livre-1 NO-ERROR.
            IF NOT AVAIL tipo-tax THEN DO:
                {utp/ut-liter.i "Imposto_Detraá∆o" *}
                {method/svc/errors/inserr.i
                    &ErrorNumber="47"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="trim(return-value)"}
                    
                RETURN "NOK":U.
            END.
            
            IF tipo-tax.tipo <> 1 THEN DO:                
                {method/svc/errors/inserr.i
                    &ErrorNumber="7267"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE calculaDetracao :
/*:T-------------------------------------------------------------------------------------
  Purpose:    Realizar calculo do imposto de detraá∆o
  Parameters: cod-impto-detracao = C¢digo informado no docto-estoq-internac.num-livre-1
              Rowid Docum-est    = Rowid do registro do documento )docum-est) a ser calculado.  
----------------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pCodImpto        AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pRowidDocto      AS ROWID  NO-UNDO.
    
    DEFINE BUFFER bf-impto-item-docto FOR impto-item-docto.
    DEFINE BUFFER bf-tipo-tax         FOR tipo-tax.
    
    DEFINE VAR i-seq-impto               AS INTEGER NO-UNDO.
    DEFINE VAR de-impto-calc-tot-nota-me AS DECIMAL NO-UNDO.
    DEFINE VAR de-impto-calc-tot-nota    AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-impto-me           AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-impto              AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-impto-item-me      AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-impto-item         AS DECIMAL NO-UNDO.
    DEFINE VAR de-base-calc-me           AS DECIMAL NO-UNDO.
    DEFINE VAR de-base-calc              AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-calc-impto-me      AS DECIMAL NO-UNDO.
    DEFINE VAR de-tot-calc-impto         AS DECIMAL NO-UNDO.
    DEFINE VAR de-dif-calc-me            AS DECIMAL NO-UNDO.
    DEFINE VAR de-dif-calc               AS DECIMAL NO-UNDO.

    // Caso n~ao tenha informado o c'odigo do imposto detracao
    IF pCodImpto = 0 THEN 
        RETURN "NOK":U.    
    
    // Posicionar no documento recebido por parÉmetro
    FIND docum-est WHERE ROWID(docum-est) = pRowidDocto NO-LOCK NO-ERROR.
    IF NOT AVAIL docum-est THEN 
        RETURN "NOK":U.
         
    // Eliminar o registro do imposto Detraá∆o caso exista.
    FOR EACH impto-item-docto EXCLUSIVE-LOCK 
        WHERE impto-item-docto.cod-emitente = docum-est.cod-emitente 
        AND   impto-item-docto.serie-docto  = docum-est.serie-docto  
        AND   impto-item-docto.nat-operacao = docum-est.nat-operacao 
        AND   impto-item-docto.nro-docto    = docum-est.nro-docto
        AND   impto-item-docto.cdn-imposto  = pCodImpto:

        delete impto-item-docto.
    END.

    // Calcular o total de imposto tipo IVA dos itens do documento.
    ASSIGN de-tot-impto    = 0
           de-tot-impto-me = 0.
    FOR EACH impto-item-docto of docum-est NO-LOCK:

        find first tipo-tax where
                   tipo-tax.cod-tax = impto-item-docto.cdn-imposto NO-LOCK no-error.
        if not avail tipo-tax then next.
        
        IF tipo-tax.tipo = 2 THEN
            ASSIGN de-tot-impto    = de-tot-impto    + impto-item-docto.val-impto
                   de-tot-impto-me = de-tot-impto-me + impto-item-docto.val-impto-merc-ext.
    END.

    // Obter o total da nota + total dos impostos IVA dos itens.
    ASSIGN de-impto-calc-tot-nota    = 0
           de-impto-calc-tot-nota-me = 0. 
    find first tipo-tax where
               tipo-tax.cod-tax = pCodImpto no-lock no-error.
    IF avail tipo-tax THEN 
        ASSIGN de-impto-calc-tot-nota    = ROUND((docum-est.valor-mercad    + de-tot-impto)    * (tipo-tax.tax-perc / 100),0)
               de-impto-calc-tot-nota-me = ROUND((docum-est.valor-mercad-me + de-tot-impto-me) * (tipo-tax.tax-perc / 100),0).

    // Realizar o c†lculo do imposto de Detraá∆o para os itens
    ASSIGN de-tot-calc-impto    = 0
           de-tot-calc-impto-me = 0.
    for each item-doc-est of docum-est no-lock:
        
        find first tipo-tax where
                   tipo-tax.cod-tax = pCodImpto no-lock no-error.
        if not avail tipo-tax then next.

        // Calcular o total de imposto tipo IVA dos itens do documento.
        ASSIGN de-tot-impto-item    = 0
               de-tot-impto-item-me = 0.
        FOR EACH impto-item-docto NO-LOCK WHERE 
                 impto-item-docto.serie-docto  = item-doc-est.serie-docto
             AND impto-item-docto.nro-docto    = item-doc-est.nro-docto
             AND impto-item-docto.cod-emitente = item-doc-est.cod-emitente
             AND impto-item-docto.nat-operacao = item-doc-est.nat-operacao
             AND impto-item-docto.num-seq      = item-doc-est.sequencia:        
      
            find first bf-tipo-tax where
                       bf-tipo-tax.cod-tax = impto-item-docto.cdn-imposto no-lock no-error.
            if not avail bf-tipo-tax then next.
            
            IF bf-tipo-tax.tipo = 2 THEN
                ASSIGN de-tot-impto-item-me = de-tot-impto-item-me + impto-item-docto.val-impto-merc-ext
                       de-tot-impto-item    = de-tot-impto-item    + impto-item-docto.val-impto.
        END. 
        
        ASSIGN de-base-calc-me = ROUND((item-doc-est.preco-total-me + de-tot-impto-item-me),0)
               de-base-calc    = ROUND((item-doc-est.preco-total[1] + de-tot-impto-item),0).
        
        CREATE impto-item-docto.
        ASSIGN impto-item-docto.serie-docto        = item-doc-est.serie-docto        
               impto-item-docto.nro-docto          = item-doc-est.nro-docto          
               impto-item-docto.cod-emitente       = item-doc-est.cod-emitente       
               impto-item-docto.nat-operacao       = item-doc-est.nat-operacao       
               impto-item-docto.num-seq            = item-doc-est.sequencia
               impto-item-docto.cdn-imposto        = pCodImpto
               impto-item-docto.perc-imposto       = tipo-tax.tax-per    
               impto-item-docto.val-impto-merc-ext = ROUND((de-base-calc-me * (tipo-tax.tax-perc / 100)),0)
               impto-item-docto.val-impto          = ROUND((de-base-calc    * (tipo-tax.tax-perc / 100)),0)
               impto-item-docto.val-base-me        = de-base-calc-me
               impto-item-docto.val-base           = de-base-calc.
               
        ASSIGN de-tot-calc-impto-me = de-tot-calc-impto-me + impto-item-docto.val-impto-merc-ext
               de-tot-calc-impto    = de-tot-calc-impto    + impto-item-docto.val-impto.
    END.

    // Calcular o total de imposto tipo IVA dos itens do documento.
    IF de-tot-calc-impto-me <> de-impto-calc-tot-nota-me OR 
       de-tot-calc-impto    <> de-impto-calc-tot-nota    THEN DO:
       
       ASSIGN de-dif-calc-me = de-impto-calc-tot-nota-me - de-tot-calc-impto-me
              de-dif-calc    = de-impto-calc-tot-nota    - de-tot-calc-impto.
              
       FOR EACH  impto-item-docto EXCLUSIVE-LOCK
           WHERE impto-item-docto.serie-docto        = docum-est.serie-docto   
             AND impto-item-docto.nro-docto          = docum-est.nro-docto    
             AND impto-item-docto.nat-operacao       = docum-est.nat-operacao 
             AND impto-item-docto.cod-emitente       = docum-est.cod-emitente
             AND impto-item-docto.cdn-imposto        = pCodImpto
             BREAK BY impto-item-docto.val-impto DESC:

             ASSIGN impto-item-docto.val-impto-merc-ext = impto-item-docto.val-impto-merc-ext + de-dif-calc-me
                    impto-item-docto.val-impto          = impto-item-docto.val-impto          + de-dif-calc.
             LEAVE.       
       END.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

