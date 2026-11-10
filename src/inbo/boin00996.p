&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00996 2.00.00.005 } /*** "010005" 13/11/2023 11:45:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00966 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00996
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName preco-frete-coleta
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/******************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************/ 
{include/i-estab-security.i}
/******************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************/


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
{inbo/boin00996.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE dt-dat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.
DEFINE VARIABLE dt-dat-fim-vigenc  LIKE preco-frete-coleta.dat-fim-vigenc  NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-rota-ini     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE VARIABLE c-cod-rota-fim     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE VARIABLE i-cod-transp-ini   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE VARIABLE i-cod-transp-fim   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE VARIABLE i-cdn-tip-veic-ini LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE VARIABLE i-cdn-tip-veic-fim LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini    LIKE preco-frete-coleta.it-codigo       NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim    LIKE preco-frete-coleta.it-codigo       NO-UNDO.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "dat-fim-vigenc":U THEN ASSIGN pFieldValue = RowObject.dat-fim-vigenc.
        WHEN "dat-inic-vigenc":U THEN ASSIGN pFieldValue = RowObject.dat-inic-vigenc.
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
        WHEN "val-unit-bonus-km":U THEN ASSIGN pFieldValue = RowObject.val-unit-bonus-km.
        WHEN "val-unit-bonus-pto-col":U THEN ASSIGN pFieldValue = RowObject.val-unit-bonus-pto-col.        
        WHEN "val-fix-frete":U THEN ASSIGN pFieldValue = RowObject.val-fix-frete.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-unit-frete-km":U THEN ASSIGN pFieldValue = RowObject.val-unit-frete-km.
        WHEN "val-unit-frete-quant":U THEN ASSIGN pFieldValue = RowObject.val-unit-frete-quant.
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
        WHEN "cdn-tip-veic":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-veic.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
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
  Purpose:     Retorna valores dos campos do °ndice prcfrtcl_id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rota
               retorna valor do campo cod-transp
               retorna valor do campo cdn-tip-veic
               retorna valor do campo it-codigo
               retorna valor do campo dat-inic-vigenc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE preco-frete-coleta.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rota LIKE preco-frete-coleta.cod-rota NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-transp LIKE preco-frete-coleta.cod-transp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-tip-veic LIKE preco-frete-coleta.cdn-tip-veic NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE preco-frete-coleta.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rota = RowObject.cod-rota
           pcod-transp = RowObject.cod-transp
           pcdn-tip-veic = RowObject.cdn-tip-veic
           pit-codigo = RowObject.it-codigo
           pdat-inic-vigenc = RowObject.dat-inic-vigenc.

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
  Purpose:     Reposiciona registro com base no °ndice prcfrtcl_id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rota
               recebe valor do campo cod-transp
               recebe valor do campo cdn-tip-veic
               recebe valor do campo it-codigo
               recebe valor do campo dat-inic-vigenc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE preco-frete-coleta.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rota LIKE preco-frete-coleta.cod-rota NO-UNDO.
    DEFINE INPUT PARAMETER pcod-transp LIKE preco-frete-coleta.cod-transp NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-tip-veic LIKE preco-frete-coleta.cdn-tip-veic NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE preco-frete-coleta.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pdat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.

    FIND FIRST bfpreco-frete-coleta WHERE 
        bfpreco-frete-coleta.cod-estabel = pcod-estabel AND 
        bfpreco-frete-coleta.cod-rota = pcod-rota AND 
        bfpreco-frete-coleta.cod-transp = pcod-transp AND 
        bfpreco-frete-coleta.cdn-tip-veic = pcdn-tip-veic AND 
        bfpreco-frete-coleta.it-codigo = pit-codigo AND 
        bfpreco-frete-coleta.dat-inic-vigenc = pdat-inic-vigenc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpreco-frete-coleta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpreco-frete-coleta)).
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
    /* Seguranáa por estabelecimento */
    &scoped-define KEY-PHRASE TRUE NO-LOCK
    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i} 
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySelecao DBOProgram 
PROCEDURE openQuerySelecao :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&TableName}.dat-fim-vigenc  >= dt-dat-inic-vigenc ~
                          AND {&TableName}.dat-inic-vigenc <= dt-dat-fim-vigenc ~
                          AND {&TableName}.cod-estabel     >= c-cod-estabel-ini ~
                          AND {&TableName}.cod-estabel     <= c-cod-estabel-fim ~
                          AND {&TableName}.cod-rota        >= c-cod-rota-ini ~
                          AND {&TableName}.cod-rota        <= c-cod-rota-fim ~
                          AND {&TableName}.cod-transp      >= i-cod-transp-ini ~
                          AND {&TableName}.cod-transp      <= i-cod-transp-fim ~
                          AND {&TableName}.cdn-tip-veic    >= i-cdn-tip-veic-ini ~
                          AND {&TableName}.cdn-tip-veic    <= i-cdn-tip-veic-fim ~
                          AND {&TableName}.it-codigo       >= c-it-codigo-ini ~
                          AND {&TableName}.it-codigo       <= c-it-codigo-fim  NO-LOCK

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i} 
  
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSelecao DBOProgram 
PROCEDURE setConstraintSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-dat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-fim-vigenc  LIKE preco-frete-coleta.dat-fim-vigenc  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-ini  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-rota-ini     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-rota-fim     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-transp-ini   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-transp-fim   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-tip-veic-ini LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-tip-veic-fim LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-ini    LIKE preco-frete-coleta.it-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-fim    LIKE preco-frete-coleta.it-codigo       NO-UNDO.   
    
    ASSIGN dt-dat-inic-vigenc = pdt-dat-inic-vigenc
           dt-dat-fim-vigenc  = pdt-dat-fim-vigenc
           c-cod-estabel-ini  = pc-cod-estabel-ini
           c-cod-estabel-fim  = pc-cod-estabel-fim
           c-cod-rota-ini     = pc-cod-rota-ini
           c-cod-rota-fim     = pc-cod-rota-fim
           i-cod-transp-ini   = pi-cod-transp-ini
           i-cod-transp-fim   = pi-cod-transp-fim
           i-cdn-tip-veic-ini = pi-cdn-tip-veic-ini
           i-cdn-tip-veic-fim = pi-cdn-tip-veic-fim
           c-it-codigo-ini    = pc-it-codigo-ini
           c-it-codigo-fim    = pc-it-codigo-fim.
           
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
    
    DEFINE VARIABLE c-txt             AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE c-todos           AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE l-vigenc-branco   AS LOGICAL INITIAL NO NO-UNDO.

    {utp/ut-liter.i TODOS * }
    ASSIGN c-todos = RETURN-VALUE.   
    
    IF pType = 'Create':U THEN DO:
        IF CAN-FIND(FIRST bfpreco-frete-coleta 
                    WHERE bfpreco-frete-coleta.cod-estabel     = RowObject.cod-estabel
                      AND bfpreco-frete-coleta.cod-rota        = RowObject.cod-rota
                      AND bfpreco-frete-coleta.cod-transp      = RowObject.cod-transp
                      AND bfpreco-frete-coleta.cdn-tip-veic    = RowObject.cdn-tip-veic
                      AND bfpreco-frete-coleta.it-codigo       = RowObject.it-codigo
                      AND bfpreco-frete-coleta.dat-inic-vigenc = RowObject.dat-inic-vigenc) THEN DO:
            {utp/ut-table.i mgind preco-frete-coleta 1}
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType=EMS
                  &ErrorSubType=ERROR
                  &ErrorParameters="return-value"}
            RETURN "NOK":U.                       
        END.
    END.
    
    
    IF pType = 'Create':U OR pType = 'Update':U THEN DO:    
        /* VigÍncia */
        IF  RowObject.dat-inic-vigenc = ? THEN DO:
            {utp/ut-liter.i Data_in°cio_vigància * }
            {method/svc/errors/inserr.i 
                     &ErrorNumber="3145"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RETURN-VALUE"}
            ASSIGN l-vigenc-branco = YES.                     
        END.
        IF  RowObject.dat-fim-vigenc = ? THEN DO:
            {utp/ut-liter.i Data_fim_vigància * }
            {method/svc/errors/inserr.i 
                     &ErrorNumber="3145"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RETURN-VALUE"}
            ASSIGN l-vigenc-branco = YES.
        END.
        
        IF NOT l-vigenc-branco 
           AND RowObject.dat-inic-vigenc > RowObject.dat-fim-vigenc THEN DO:
            {utp/ut-liter.i Data_Final *}
            ASSIGN c-txt = RETURN-VALUE.
            {utp/ut-liter.i Data_inicial *}
            ASSIGN c-txt = c-txt + "~~" + RETURN-VALUE.
            {method/svc/errors/inserr.i 
                         &ErrorNumber="1207"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="c-txt"}
        END.
        /* fim vigencia */
    
        /* Estabelecimento */
        IF RowObject.cod-estabel = "" THEN DO:
            {utp/ut-liter.i Estabelecimento * }
            {method/svc/errors/inserr.i 
                     &ErrorNumber="3145"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST item-estab-rural
                            WHERE item-estab-rural.cod-estabel = RowObject.cod-estabel
                              AND (NOT l-estab-security-active OR 
                                   CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                                            WHERE {&ESTAB-SEC-TT-FIELD} = RowObject.cod-estabel))) THEN DO:
                {utp/ut-liter.i Estabelecimento * }
                ASSIGN c-txt = RETURN-VALUE.
                {utp/ut-liter.i Item * }
                ASSIGN c-txt = c-txt + "~~" + RETURN-VALUE.
                {method/svc/errors/inserr.i 
                        &ErrorNumber="54776" /* &1 n„o cadastrado para nenhum &2. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-txt"}        
            END.
        END.
        
        /* Rota */
        IF RowObject.cod-rota <> "*" THEN DO:
            IF RowObject.cod-rota = "" THEN DO:
                {utp/ut-liter.i Rota * }
                {method/svc/errors/inserr.i 
                         &ErrorNumber="3145"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST rota-coleta
                                WHERE rota-coleta.cod-rota = RowObject.cod-rota) THEN DO:
                    {utp/ut-table.i mgind rota-coleta 1}                   
                    {method/svc/errors/inserr.i 
                            &ErrorNumber="56" /* &1 inexistente. */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}        
                END.
            END. 
         END.
         
        /* tranportador */
        IF RowObject.cod-transp <> 0 THEN DO:
            IF NOT CAN-FIND(FIRST transporte
                            WHERE transporte.cod-transp = RowObject.cod-transp) THEN DO:
                {utp/ut-table.i mgind transporte 1}                   
                {method/svc/errors/inserr.i 
                        &ErrorNumber="56" /* &1 inexistente. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}        
            END.
         END.        
         
        /* Tipo veiculo */
        IF RowObject.cdn-tip-veic <> 0 THEN DO:
            IF NOT CAN-FIND(FIRST tip-veic-transp
                            WHERE tip-veic-transp.cdn-tip-veic= RowObject.cdn-tip-veic) THEN DO:
                {utp/ut-table.i mgind tip-veic-transp 1}                   
                {method/svc/errors/inserr.i 
                        &ErrorNumber="56" /* &1 inexistente. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}        
            END.
         END.

        /* Item */
        IF RowObject.it-codigo <> "*" THEN DO:
            IF NOT CAN-FIND(FIRST item-estab-rural 
                            WHERE item-estab-rural.it-codigo = RowObject.it-codigo
                             AND (NOT l-estab-security-active OR 
                                  CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                                           WHERE {&ESTAB-SEC-TT-FIELD} = RowObject.cod-estabel))) THEN DO:
                {utp/ut-liter.i Item * }
                ASSIGN c-txt = RETURN-VALUE.
                {utp/ut-liter.i Estabelecimento * }
                ASSIGN c-txt = c-txt + "~~" + RETURN-VALUE.
                {method/svc/errors/inserr.i 
                        &ErrorNumber="54776" /* &1 n„o cadastrado para nenhum &2. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-txt"}
            END.
        END.
    
        /* VALIDACAO VIGENCIA */
        IF CAN-FIND(FIRST bfpreco-frete-coleta 
                    WHERE bfpreco-frete-coleta.cod-estabel      = RowObject.cod-estabel
                      AND bfpreco-frete-coleta.cod-rota         = RowObject.cod-rota
                      AND bfpreco-frete-coleta.cod-transp       = RowObject.cod-transp
                      AND bfpreco-frete-coleta.cdn-tip-veic     = RowObject.cdn-tip-veic
                      AND bfpreco-frete-coleta.it-codigo        = RowObject.it-codigo
                      AND bfpreco-frete-coleta.dat-fim-vigenc  >= RowObject.dat-inic-vigenc
                      AND bfpreco-frete-coleta.dat-inic-vigenc <= RowObject.dat-fim-vigenc
                      AND (pType = 'Create':U OR 
                           ROWID(bfpreco-frete-coleta) <> RowObject.r-rowid)) THEN DO:
           
            ASSIGN c-txt = RowObject.cod-estabel + "~~". /* estab */
            
            IF RowObject.cod-rota = "*":U THEN
                ASSIGN c-txt = c-txt + c-todos + "~~". 
            ELSE 
                ASSIGN c-txt = c-txt + RowObject.cod-rota + "~~". /* rota */
 
            IF RowObject.cod-transp = 0 THEN
                ASSIGN c-txt = c-txt + c-todos + "~~".
            ELSE 
                ASSIGN c-txt = c-txt + STRING(RowObject.cod-transp) + "~~". /* transportador */
                    
            IF RowObject.cdn-tip-veic = 0 THEN
                ASSIGN c-txt = c-txt + c-todos + "~~".
            ELSE 
                ASSIGN c-txt = c-txt + STRING(RowObject.cdn-tip-veic) + "~~". /* tipo veiculo */
                
            IF RowObject.it-codigo = "*":U THEN
                ASSIGN c-txt = c-txt + c-todos.
            ELSE 
                ASSIGN c-txt = c-txt + RowObject.it-codigo. /* item*/
            
            {method/svc/errors/inserr.i
                &ErrorNumber="54777"  /*J· existe regra de preÁo para a vigÍncia informada*/
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-txt"}
        END.         
        
        IF ( RowObject.val-unit-frete-km    + 
             RowObject.val-unit-frete-quant + 
             RowObject.val-fix-frete ) = 0 THEN DO:         
             {method/svc/errors/inserr.i
                &ErrorNumber="54778"  /* Valor de preÁo do frete igual a zero. */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-txt"}
        END.   
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

