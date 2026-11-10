&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00983 2.00.00.010 } /*** "010010" 13/11/2023 11:45:44 ***/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00963 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00983
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-estab-rural
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
/*{include/i-estab-security.i}*/
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
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
{inbo/boin00983.i RowObject}

DEFINE VARIABLE c-it-codigo-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfItem         FOR item.

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
         HEIGHT             = 19.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDescItem DBOProgram 
PROCEDURE findDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-item AS CHARACTER NO-UNDO.
    
    FOR FIRST bfitem-estab-rural FIELDS(it-codigo) NO-LOCK
        WHERE bfitem-estab-rural.it-codigo = p-it-codigo:
        FOR FIRST bfItem FIELDS(desc-item) NO-LOCK
            WHERE bfItem.it-codigo = bfitem-estab-rural.it-codigo:
            ASSIGN  p-desc-item =  bfItem.desc-item.
        END.
    END.
    
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "val-perc-variac-amaior":U THEN ASSIGN pFieldValue = RowObject.val-perc-variac-amaior.
        WHEN "val-perc-variac-amenor":U THEN ASSIGN pFieldValue = RowObject.val-perc-variac-amenor.
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
        WHEN "idi-desc-sem-rot":U THEN ASSIGN pFieldValue = RowObject.idi-desc-sem-rot.
        WHEN "idi-tip-aferic":U THEN ASSIGN pFieldValue = RowObject.idi-tip-aferic.
        WHEN "num-dias-valid":U THEN ASSIGN pFieldValue = RowObject.num-dias-valid.
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
  Purpose:     Retorna valores dos campos do °ndice itmstbrr_id2
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-estab-rural.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-estab-rural.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getListItemEstabPairs DBOProgram 
PROCEDURE getListItemEstabPairs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel-fim AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-list        AS CHARACTER NO-UNDO.

    FOR EACH  item-estab-rural FIELDS(it-codigo)NO-LOCK
        WHERE item-estab-rural.cod-estabel >= p-cod-estabel-ini
        AND   item-estab-rural.cod-estabel <= p-cod-estabel-fim:
    
        IF INDEX(c-list,item-estab-rural.it-codigo) = 0 THEN DO:
           IF c-list <> "" THEN                 
           ASSIGN c-list = c-list + ",".

           ASSIGN c-list = c-list + item-estab-rural.it-codigo + ',' + item-estab-rural.it-codigo.
        END.
    END.

    IF c-list = "" THEN                 
        ASSIGN c-list = ",".

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getListItemPairs DBOProgram 
PROCEDURE getListItemPairs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-list        AS CHARACTER NO-UNDO.

    FOR EACH item-estab-rural FIELDS(it-codigo)NO-LOCK
       WHERE item-estab-rural.cod-estabel = c-cod-estabel:
    
        IF c-list <> "" THEN                 
            ASSIGN c-list = c-list + ",".
 
        ASSIGN c-list = c-list + item-estab-rural.it-codigo + ',' + item-estab-rural.it-codigo.

    END.

    IF c-list = "" THEN                 
        ASSIGN c-list = ",".

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getListItems DBOProgram 
PROCEDURE getListItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-list        AS CHARACTER NO-UNDO.

    FOR EACH item-estab-rural FIELDS(it-codigo)NO-LOCK
       WHERE item-estab-rural.cod-estabel = c-cod-estabel:

        IF c-list = '' THEN
            ASSIGN c-list = item-estab-rural.it-codigo.
        ELSE  
            ASSIGN c-list = c-list + ',' + item-estab-rural.it-codigo.
    END.

    RETURN 'OK':U.

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
  Purpose:     Reposiciona registro com base no °ndice itmstbrr_id2
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-estab-rural.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-estab-rural.cod-estabel NO-UNDO.

    FIND FIRST bfitem-estab-rural WHERE 
        bfitem-estab-rural.it-codigo = pit-codigo AND 
        bfitem-estab-rural.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-estab-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-estab-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemEstab DBOProgram 
PROCEDURE openQueryItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                
    /* Seguranáa por estabelecimento */
    /*&scoped-define KEY-PHRASE {&TABLENAME}.it-codigo >= c-it-codigo-ini ~
                          AND {&TABLENAME}.it-codigo <= c-it-codigo-fim ~
                          AND {&TABLENAME}.cod-estabel >= c-cod-estabel-ini ~
                          AND {&TABLENAME}.cod-estabel <= c-cod-estabel-fim NO-LOCK
    
    {include/i-estab-openquery.i}   */

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                               WHERE {&TableName}.it-codigo >= c-it-codigo-ini ~
                                 AND {&TableName}.it-codigo <= c-it-codigo-fim ~
                                 AND {&TableName}.cod-estabel >= c-cod-estabel-ini ~
                                 AND {&TableName}.cod-estabel <= c-cod-estabel-fim INDEXED-REPOSITION.
    
                                
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

   /* /* Seguranáa por estabelecimento */
    &scoped-define KEY-PHRASE TRUE NO-LOCK
    
    {include/i-estab-openquery.i} */
    
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemEstab DBOProgram 
PROCEDURE setConstraintItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo-ini   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS CHARACTER NO-UNDO.

    ASSIGN c-it-codigo-ini   = p-it-codigo-ini
           c-it-codigo-fim   = p-it-codigo-fim
           c-cod-estabel-ini = p-cod-estabel-ini
           c-cod-estabel-fim = p-cod-estabel-fim.

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

    DEF VAR c-label-tabela AS CHAR   NO-UNDO.
    DEF VAR c-label-relac  AS CHAR   NO-UNDO.

    {utp/ut-liter.i Item_Estabelecimento_Rural * L}
    ASSIGN c-label-tabela = RETURN-VALUE.
    
    IF pType = "CREATE" THEN DO:

        IF CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.it-codigo   = RowObject.it-codigo AND 
                          bf{&TableName}.cod-estabel = RowObject.cod-estabel) THEN DO:
            
            {utp/ut-liter.i Item_Estabelecimento_Rural *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.

        FOR FIRST item FIELDS() no-lock 
            WHERE item.it-codigo = rowobject.it-codigo: 
        END.
        if not avail item then do:     
             /* Inicio -- Projeto Internacional */
             {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
             {method/svc/errors/inserr.i
                       &ErrorNumber      = "2"
                       &ErrorType        = "EMS"
                       &ErrorParameters  = TRIM(RETURN-VALUE)}
        end.

        FOR FIRST item-uni-estab FIELDS() NO-LOCK
            WHERE item-uni-estab.it-codigo = RowObject.it-codigo  
              AND item-uni-estab.cod-estabel = RowObject.cod-estabel :
        END.
        if not avail item-uni-estab then do:     
             /* Inicio -- Projeto Internacional */
             {utp/ut-table.i mgind item-uni-estab 1} /* Busca o label da tabela */
             {method/svc/errors/inserr.i
                       &ErrorNumber      = "2"
                       &ErrorType        = "EMS"
                       &ErrorParameters  = TRIM(RETURN-VALUE)}
        end.


        
        
        /*IF l-estab-security-active THEN DO:
            FOR FIRST estabelec FIELDS()
                WHERE estabelec.cod-estabel = RowObject.cod-estabel
                  AND CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = estabelec.cod-estabel): END.
        END.
        ELSE DO:*/
            FOR FIRST estabelec FIELDS()
                WHERE estabelec.cod-estabel = RowObject.cod-estabel: END.        
       /* END.*/
        IF NOT AVAIL estabelec THEN DO:
            {utp/ut-liter.i "Estabelecimento" *}
            {method/svc/errors/inserr.i
                       &ErrorNumber="2" 
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters= RETURN-VALUE}
        END.

    END.

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST regra-form-preco 
                    WHERE regra-form-preco.it-codigo = RowObject.it-codigo 
                      AND regra-form-preco.cod-estabel = RowObject.cod-estabel) THEN DO:
        
            {utp/ut-liter.i Regra_de_Formaá∆o_de_Preáo * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST carg-rural 
                    WHERE carg-rural.it-codigo = RowObject.it-codigo 
                      AND carg-rural.cod-estabel = RowObject.cod-estabel) THEN DO:
        
            {utp/ut-liter.i Carga_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

