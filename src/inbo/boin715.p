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
{include/i-prgvrs.i BOIN715 2.00.00.002 } /*** "010002" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN715 MUT}
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
&GLOBAL-DEFINE DBOName BOIN715
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-desp
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
{inbo/boin715.i RowObject}

/*--- Definiá∆o das temp-tables ---*/
{inbo/boin714.i2 rowPermissions}.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Vari†veis utilizadas no setConstraint1 */
DEF VAR cCodEstabel LIKE rma.cod-estabel NO-UNDO.
DEF VAR cCodRMA     LIKE rma.cod-rma     NO-UNDO.

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
         HEIGHT             = 2.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearRowPermissions DBOProgram 
PROCEDURE clearRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Limpa a tabela de permiss‰es (rowPermissions).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH rowPermissions:
    DELETE rowPermissions.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowPermissions DBOProgram 
PROCEDURE createRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Criar registros na tabela rowPermissions   
  Parameters: pcTabela : Nome da tabela
              pcCampo  : Nome do campo
  Notes: "OK" : Registro criado!
         'NOK : Registro j† existe.
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcTabela AS CHAR NO-UNDO.
DEF INPUT PARAM pcCampo  AS CHAR NO-UNDO.

  IF NOT CAN-FIND (FIRST rowPermissions WHERE
                         rowPermissions.tabela = pcTabela AND
                         rowPermissions.campo  = pcCampo) THEN DO: 
     CREATE rowPermissions.
     ASSIGN rowPermissions.tabela = pcTabela
            rowPermissions.campo  = pcCampo.
     RETURN "OK":U.
  END.
  ELSE 
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRMA DBOProgram 
PROCEDURE findRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma.cod-estabel    NO-UNDO.
DEF INPUT PARAM pcCodRMA       LIKE rma.cod-rma        NO-UNDO.

  FOR FIRST rma WHERE
            rma.cod-estabel   = pcCodEstabel   AND
            rma.cod-rma       = pcCodRMA 
            NO-LOCK: END.
            
  IF AVAIL rma THEN
    RETURN "OK":U.    
  ELSE
    RETURN "NOK":U.
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
        WHEN "cod-despesa":U THEN ASSIGN pFieldValue = RowObject.cod-despesa.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
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
        WHEN "val-despesa":U THEN ASSIGN pFieldValue = RowObject.val-despesa.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-per-desp":U THEN ASSIGN pFieldValue = RowObject.val-per-desp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getExpense DBOProgram 
PROCEDURE getExpense :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pcCodDespesa LIKE despesa.cod-despesa NO-UNDO.
DEF OUTPUT PARAM pcDesDespesa LIKE despesa.des-despesa NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
 
  FOR FIRST despesa WHERE
            despesa.cod-despesa = pcCodDespesa NO-LOCK: 
     ASSIGN pcDesDespesa = despesa.des-despesa.
  END.
  
  IF NOT AVAIL despesa THEN
    RETURN "NOK":U.
  ELSE    
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-despesa
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rma
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-despesa LIKE rma-desp.cod-despesa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-desp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma-desp.cod-rma NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-despesa = RowObject.cod-despesa
           pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowPermissions DBOProgram 
PROCEDURE getRowPermissions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR rowPermissions.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-despesa
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rma
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-despesa LIKE rma-desp.cod-despesa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-desp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma-desp.cod-rma NO-UNDO.

    FIND FIRST bfrma-desp WHERE 
        bfrma-desp.cod-despesa = pcod-despesa AND 
        bfrma-desp.cod-estabel = pcod-estabel AND 
        bfrma-desp.cod-rma = pcod-rma NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-desp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-desp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRma DBOProgram 
PROCEDURE linkToRma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   DEF VAR cCodEstabel AS CHAR NO-UNDO.
   DEF VAR cCodRMA     AS CHAR NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT cCodEstabel,
                          OUTPUT cCodRma).
   
   RUN setConstraintRma IN THIS-PROCEDURE (INPUT cCodEstabel,
                                           INPUT cCodRma).
   
   
   RUN findRMA (INPUT cCodEstabel,
                INPUT cCodRMA).
                
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

  OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRMA DBOProgram 
PROCEDURE openQueryRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&tableName} WHERE
                                     {&tableName}.cod-estabel = cCodEstabel AND
                                     {&tableName}.cod-rma     = cCodRMA 
                                     NO-LOCK INDEXED-REPOSITION.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRMA DBOProgram 
PROCEDURE setConstraintRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel LIKE rma.cod-estabel NO-UNDO.
DEF INPUT PARAM pcCodRMA     LIKE rma.cod-rma     NO-UNDO.

ASSIGN cCodEstabel = pcCodEstabel
       cCodRMA     = pcCodRMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsExpense DBOProgram 
PROCEDURE setDefaultsExpense :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
 
  FOR FIRST emitente WHERE
            emitente.cod-emitente = rma.cdn-emitente NO-LOCK: END.
  IF NOT AVAIL emitente THEN
    RETURN "NOK":U.
    
  FOR FIRST despesa WHERE
            despesa.cod-despesa = rowObject.cod-despesa NO-LOCK:    
     
    FOR FIRST despesa-cli WHERE 
              despesa-cli.cod-despesa      = rowObject.cod-despesa AND
              despesa-cli.nome-abrev       = emitente.nome-abrev   AND
              despesa-cli.dat-termino-val >= TODAY NO-LOCK:
       ASSIGN rowObject.val-despesa = if despesa.cdn-tp-calculo = 2 
                                         then despesa-cli.val-despesa
                                      else 0
              rowObject.val-per-desp = if despesa.cdn-tp-calculo = 1 
                                         then despesa-cli.val-per-desp
                                      else 0.
    END.
  END.
  

  IF NOT AVAIL despesa-cli THEN 
    RETURN "NOK":U.
  ELSE     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDisabledFields DBOProgram 
PROCEDURE setDisabledFields :
/*------------------------------------------------------------------------------
  Purpose: De acordo com o evento informado, indica quais campos devem ser
           desbilitados em tela
  Parameters: pTYpe  : Aá∆o (ADD, UPDATE, COPY, DELETE)
              pEvent : Evento que dispara a verificaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pType  AS CHAR NO-UNDO.
DEF INPUT PARAM pEvent AS CHAR NO-UNDO.

  RUN clearRowPermissions.  /* Limpa tabela de permiss‰es */

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
   CASE pEvent:   
   
     /*---- LEAVE-COD-DESPESA ----*/
     WHEN "leave-cod-despesa":U THEN DO:
       /*FOR FIRST despesa WHERE
                 despesa.cod-despesa = rowObject.cod-despesa NO-LOCK: END.*/
       IF NOT AVAIL despesa OR
          despesa.cdn-tp-calculo = 1 THEN
          RUN createRowPermissions (INPUT "rma-desp":U, INPUT "val-despesa":U).
       IF NOT AVAIL despesa OR
          despesa.cdn-tp-calculo = 2 THEN
          RUN createRowPermissions (INPUT "rma-desp":U, INPUT "val-per-desp":U).          
     END.     
     
   END CASE.
  
  RETURN "OK":U.

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
    
    IF  NOT CAN-FIND (FIRST despesa WHERE despesa.cod-despesa = rowObject.cod-despesa) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgdis despesa 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
               &ErrorNumber="2"
               &ErrorType="EMS"
               &ErrorSubType="Error"
               &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.
    ELSE
        FOR FIRST despesa WHERE
                despesa.cod-despesa = rowObject.cod-despesa NO-LOCK: END.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U THEN DO:       
            IF CAN-FIND (FIRST rma-desp WHERE
                               rma-desp.cod-estabel = rowObject.cod-estabel AND
                               rma-desp.cod-rma     = rowObject.cod-rma     AND
                               rma-desp.cod-despesa = rowObject.cod-despesa) THEN DO:                           
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-table.i movind rma-desp 1} /* Busca o label da tabela */
                        {method/svc/errors/inserr.i
                                &ErrorNumber="1"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
                        RETURN "NOK":U.         
            END.
            
            /* Tipo de despesa inv†lida para RMAs sem itens 
               Somente depesas do tipo valor podem ser cadastradas */
            IF despesa.cdn-tp-calculo <> 2 /*AND

******************  Temporariamente, apenas despesas do tipo valor poder∆o ser implantadas ******************                                   

               NOT CAN-FIND (FIRST rma-item WHERE
                                   rma-item.cod-estabel = rma.cod-estabel AND
                                   rma-item.cod-rma     = rma.cod-rma ) 
******************  Temporariamente, apenas despesas do tipo valor poder∆o ser implantadas ******************                                   
*/                                   
                                  
                                               THEN DO:
                  {method/svc/errors/inserr.i
                                &ErrorNumber="27656"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"}
                      RETURN "NOK":U.
            END.
        END.        
      /*            
        IF despesa.cdn-tp-calculo = 1 AND
           rowObject.val-per-desp > 100 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="5638"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="'de despesa'"}
        END.*/
        IF despesa.cdn-tp-calculo = 2 AND
           rowObject.val-despesa <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-valor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "valor" *}
            ASSIGN c-lbl-liter-valor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="27241"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="c-lbl-liter-valor"}        
        END.
       /* IF despesa.cdn-tp-calculo = 1 AND
           rowObject.val-per-desp <= 0 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="5638"
            &ErrorType="EMS"
            &ErrorSubType="Error"
            &ErrorParameters="'percentual'"}        
        END.*/
    END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


