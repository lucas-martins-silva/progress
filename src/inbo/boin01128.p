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
{include/i-prgvrs.i BOIN01128 2.00.00.007 } /* 02/12/2025 11:05:56 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01128 MUT}
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
&GLOBAL-DEFINE DBOName BOIN01128
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName relac-class-trib
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
{inbo/boin01128.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE lImportCsv AS LOGICAL INITIAL NO NO-UNDO.

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
        WHEN "cod-cclass-trib":U THEN ASSIGN pFieldValue = RowObject.cod-cclass-trib.
        WHEN "cod-cclass-trib-reg":U THEN ASSIGN pFieldValue = RowObject.cod-cclass-trib-reg.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = RowObject.cod-cfop.
        WHEN "cod-class-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-class-fisc.
        WHEN "cod-nbs":U THEN ASSIGN pFieldValue = RowObject.cod-nbs.
        WHEN "cod-cst":U THEN ASSIGN pFieldValue = RowObject.cod-cst.
        WHEN "cod-cst-reg":U THEN ASSIGN pFieldValue = RowObject.cod-cst-reg.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "cod-cred-pres":U THEN ASSIGN pFieldValue = RowObject.cod-cred-pres.
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
        WHEN "dt-ini-validade":U THEN ASSIGN pFieldValue = RowObject.dt-ini-validade.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-grupo-emit":U THEN ASSIGN pFieldValue = RowObject.cod-grupo-emit.
        WHEN "ind-tributo":U THEN ASSIGN pFieldValue = RowObject.ind-tributo.
        WHEN "tipo-docto":U THEN ASSIGN pFieldValue = RowObject.tipo-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice relac-class
  Parameters:  
               retorna valor do campo cod-cclass-trib
               retorna valor do campo cod-cst
               retorna valor do campo dt-ini-validade
               retorna valor do campo tipo-docto
               retorna valor do campo cod-estabel
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-class-fisc
               retorna valor do campo cod-nbs
               retorna valor do campo cod-grupo-emit
               retorna valor do campo cod-emitente
               retorna valor do campo cod-cfop
               retorna valor do campo ind-tributo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-cclass-trib LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cst LIKE relac-class-trib.cod-cst NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-ini-validade LIKE relac-class-trib.dt-ini-validade NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo-docto LIKE relac-class-trib.tipo-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE relac-class-trib.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE relac-class-trib.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE relac-class-trib.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-class-fisc LIKE relac-class-trib.cod-class-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-nbs LIKE relac-class-trib.cod-nbs NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-grupo-emit LIKE relac-class-trib.cod-grupo-emit NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE relac-class-trib.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cfop LIKE relac-class-trib.cod-cfop NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tributo LIKE relac-class-trib.ind-tributo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cclass-trib = RowObject.cod-cclass-trib
           pcod-cst = RowObject.cod-cst
           pdt-ini-validade = RowObject.dt-ini-validade
           ptipo-docto = RowObject.tipo-docto
           pcod-estabel = RowObject.cod-estabel
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-class-fisc = RowObject.cod-class-fisc
           pcod-nbs = RowObject.cod-nbs
           pcod-grupo-emit = RowObject.cod-grupo-emit
           pcod-emitente = RowObject.cod-emitente
           pcod-cfop = RowObject.cod-cfop
           pind-tributo = RowObject.ind-tributo.

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
  Purpose:     Reposiciona registro com base no °ndice relac-class
  Parameters:  
               recebe valor do campo cod-cclass-trib
               recebe valor do campo cod-cst
               recebe valor do campo dt-ini-validade
               recebe valor do campo tipo-docto
               recebe valor do campo cod-estabel
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-class-fisc
               receber valor do campo cod-nbs
               recebe valor do campo cod-grupo-emit
               recebe valor do campo cod-emitente
               recebe valor do campo cod-cfop
               recebe valor do campo ind-tributo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-cclass-trib LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cst         LIKE relac-class-trib.cod-cst NO-UNDO.
    DEFINE INPUT PARAMETER pdt-ini-validade LIKE relac-class-trib.dt-ini-validade NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-docto      LIKE relac-class-trib.tipo-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE relac-class-trib.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao    LIKE relac-class-trib.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo       LIKE relac-class-trib.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-class-fisc  LIKE relac-class-trib.cod-class-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-nbs         LIKE relac-class-trib.cod-nbs NO-UNDO.
    DEFINE INPUT PARAMETER pcod-grupo-emit  LIKE relac-class-trib.cod-grupo-emit NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente    LIKE relac-class-trib.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cfop        LIKE relac-class-trib.cod-cfop NO-UNDO.
    DEFINE INPUT PARAMETER pind-tributo     LIKE relac-class-trib.ind-tributo NO-UNDO.
       
    FIND FIRST bfrelac-class-trib WHERE 
        bfrelac-class-trib.cod-cclass-trib = pcod-cclass-trib AND 
        bfrelac-class-trib.cod-cst = pcod-cst AND 
        bfrelac-class-trib.dt-ini-validade = pdt-ini-validade AND 
        bfrelac-class-trib.tipo-docto = ptipo-docto AND 
        bfrelac-class-trib.cod-estabel = pcod-estabel  AND 
        bfrelac-class-trib.nat-operacao = pnat-operacao AND 
        bfrelac-class-trib.it-codigo = pit-codigo AND 
        bfrelac-class-trib.cod-class-fisc = pcod-class-fisc AND 
        bfrelac-class-trib.cod-nbs = pcod-nbs AND         
        bfrelac-class-trib.cod-grupo-emit = pcod-grupo-emit AND 
        bfrelac-class-trib.cod-emitente = pcod-emitente AND 
        bfrelac-class-trib.cod-cfop = pcod-cfop AND 
        bfrelac-class-trib.ind-tributo = pind-tributo NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrelac-class-trib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrelac-class-trib)).
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
     DEFINE VARIABLE c-literal AS CHARACTER   NO-UNDO.
    
    IF pType = 'create':U THEN DO:
        FIND FIRST bfrelac-class-trib NO-LOCK
             WHERE bfrelac-class-trib.cod-cclass-trib = RowObject.cod-cclass-trib 
               AND bfrelac-class-trib.cod-cst           = RowObject.cod-cst         
               AND bfrelac-class-trib.dt-ini-validade   = RowObject.dt-ini-validade 
               AND bfrelac-class-trib.tipo-docto        = RowObject.tipo-docto      
               AND bfrelac-class-trib.cod-estabel       = RowObject.cod-estabel     
               AND bfrelac-class-trib.nat-operacao      = RowObject.nat-operacao    
               AND bfrelac-class-trib.it-codigo         = RowObject.it-codigo       
               AND bfrelac-class-trib.cod-class-fisc    = RowObject.cod-class-fisc  
               AND bfrelac-class-trib.cod-nbs           = RowObject.cod-nbs  
               AND bfrelac-class-trib.cod-grupo-emit    = RowObject.cod-grupo-emit  
               AND bfrelac-class-trib.cod-emitente      = RowObject.cod-emitente    
               AND bfrelac-class-trib.cod-cfop          = RowObject.cod-cfop        
               AND bfrelac-class-trib.ind-tributo       = RowObject.ind-tributo  NO-ERROR.
        IF AVAIL bfrelac-class-trib  THEN DO:
            {utp/ut-liter.i "Relacionamento do cClassTrib" *}        
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}           
                        
        END.
    END.
    IF pType = 'create':U
    OR pType = 'update':U THEN DO:
            IF  RowObject.cod-cclass-trib-reg = ''
            AND CAN-FIND (FIRST class-trib NO-LOCK 
                         WHERE class-trib.cod-cclass-trib = RowObject.cod-cclass-trib 
                           AND class-trib.trib-regular    = 1)  THEN DO:
                {utp/ut-liter.i "tributaá∆o_regular" *}
                ASSIGN c-literal = TRIM(RETURN-VALUE).      
                {utp/ut-liter.i "C¢digo_cClassTrib_regular" *}
                {method/svc/errors/inserr.i &ErrorNumber="58084" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + RowObject.cod-cclass-trib + '~~~~' + trim(c-literal)"}
            END.
            IF  RowObject.cod-cclass-trib-reg <> ''
            AND CAN-FIND (FIRST class-trib NO-LOCK 
                          WHERE class-trib.cod-cclass-trib = RowObject.cod-cclass-trib-reg 
                           AND class-trib.trib-regular    = 1)  THEN DO:
               
                {utp/ut-liter.i "tributaá∆o_regular" *}
                ASSIGN c-literal = TRIM(RETURN-VALUE).      
                {utp/ut-liter.i "cClassTrib_regular" *}
                {method/svc/errors/inserr.i &ErrorNumber="58085" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + trim(c-literal)"}
            END.
            
            IF  RowObject.cod-cred-pres = ''
            AND CAN-FIND (FIRST class-trib NO-LOCK 
                         WHERE class-trib.cod-cclass-trib = RowObject.cod-cclass-trib 
                           AND class-trib.credito-pres    = 1)  THEN DO:
                {utp/ut-liter.i "crÇdito_presumido" *}
                ASSIGN c-literal = TRIM(RETURN-VALUE).      
                {utp/ut-liter.i "cCredPres" *}
                {method/svc/errors/inserr.i &ErrorNumber="58084" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + RowObject.cod-cclass-trib + '~~~~' + trim(c-literal)"}
            END.

            IF NOT CAN-FIND (class-trib NO-LOCK WHERE class-trib.cod-cclass-trib = RowObject.cod-cclass-trib) THEN DO:

                {utp/ut-liter.i "C¢digo_cClassTrib" *}
                {method/svc/errors/inserr.i &ErrorNumber="158"  /*&1 inv†lido*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}  
            END.
            
            IF RowObject.ind-tributo <> 1 THEN DO:
                {utp/ut-liter.i "Tipo_de_tributo" *}
                {method/svc/errors/inserr.i &ErrorNumber="158"  /*&1 inv†lido*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}  
            END.
            
            /*Valida tipo de documento 1 - entrada ou 2 - saida */
            IF  RowObject.tipo-docto <> 1
            AND RowObject.tipo-docto <> 2 THEN DO: 
                {utp/ut-liter.i "Tipo_de_documento_inv†lido" *}
                {method/svc/errors/inserr.i &ErrorNumber="158"  /*&1 inv†lido*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"} 
            END.
            
            /* valida se estab existe */
            IF RowObject.cod-estabel <> "*" THEN DO: 
                FIND FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
                IF NOT AVAIL estabelec THEN DO:
                    {utp/ut-liter.i "Estabelecimento_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
            /* valida se natureza existe */
            IF RowObject.nat-operacao <> "*" THEN DO:
                FIND FIRST natur-oper WHERE natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK NO-ERROR.
                IF NOT AVAIL natur-oper THEN DO:
                    {utp/ut-liter.i "Natureza_de_operaá∆o" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
            /* valida se o item existe */
            IF RowObject.it-codigo <> "*" THEN DO:
                FIND FIRST ITEM WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
                IF NOT AVAIL item THEN DO:
                    {utp/ut-liter.i "Item_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
            /* valida se a ncm existe */
            IF RowObject.cod-class-fisc  <> "*" THEN DO:
                FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal = RowObject.cod-class-fisc   NO-LOCK NO-ERROR.
                IF NOT AVAIL classif-fisc THEN DO:
                    {utp/ut-liter.i "Classificaá∆o_fiscal_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
             /* valida se o c¢digo nbs existe */
            IF RowObject.cod-nbs  <> "*" THEN DO:
                FIND FIRST cad-nbs WHERE cad-nbs.cod-nbs = RowObject.cod-nbs   NO-LOCK NO-ERROR.
                IF NOT AVAIL cad-nbs THEN DO:
                    {utp/ut-liter.i "C¢digo_NBS_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
            /* valida se o grupo de emitente existe */
            IF RowObject.cod-grupo-emit <> 0 THEN DO:  
                /*Se o tipo de documento for entrada olhar o grupo de fornecedor , se for sa°da deveremos olhar o grupo de cliente*/
                IF  RowObject.tipo-docto = 1 THEN DO: /*Entrada*/
                    FIND FIRST grupo-fornec WHERE grupo-fornec.cod-gr-forn   = RowObject.cod-grupo-emit NO-LOCK NO-ERROR.
                    IF NOT AVAIL grupo-fornec THEN DO:
                        {utp/ut-liter.i "Grupo de emitente_inexistente" *}
                        {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="TRIM(RETURN-VALUE)"} 
                        
                    END.
                END.
                ELSE DO: /*Sa°da*/
                    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = INTEGER(RowObject.cod-grupo-emit) NO-LOCK NO-ERROR.
                    IF NOT AVAIL gr-cli THEN DO:
                        {utp/ut-liter.i "Grupo de emitente_inexistente" *}
                        {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="TRIM(RETURN-VALUE)"} 
                    END.
                END.
            END.

            /* valida se o cliente/fornecedor existe */
            IF RowObject.cod-emitente <> 0 THEN DO:
                FIND FIRST emitente WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK NO-ERROR.
                IF NOT AVAIL emitente THEN DO:
                    {utp/ut-liter.i "Emitente_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"} 
                END.
            END.
            
            /* valida se o cfop existe */
            IF RowObject.cod-cfop <> "*" THEN DO:
                FIND FIRST cfop-natur WHERE cfop-natur.cod-cfop = RowObject.cod-cfop NO-LOCK NO-ERROR.
                IF NOT AVAIL cfop-natur THEN DO:
                    {utp/ut-liter.i "CFOP_inexistente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="56" /*&1 inexistente*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"} 
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


