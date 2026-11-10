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
{include/i-prgvrs.i BOIN637 2.00.00.008 } /*** "010008" 25/10/2023 14:45:48  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN637 MUT}
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
&GLOBAL-DEFINE DBOName BOIN637
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName it-comp-exame
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 it-codigo  /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-exame  /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField3 cod-comp   /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */



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
{inbo/boin637.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cItem AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCodExame AS INTEGER NO-UNDO.

DEFINE VARIABLE iCodCompIni AS INTEGER NO-UNDO.
DEFINE VARIABLE iCodCompFim AS INTEGER NO-UNDO.
DEFINE VARIABLE cDescIni    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDescFim    AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-it-comp-exame-externo-aux NO-UNDO LIKE it-comp-exame /* temp-table utilizada pelo cq0155 que contÈm os componentes relacionados */
       FIELD checkSum AS CHARACTER FORMAT 'x(1)'                           /* ou n„o aos itens, desde que os exames sejam externos (exame.log-exter)  */                          
       FIELD mostra   AS LOGICAL INITIAL YES.  

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "compl-res":U THEN ASSIGN pFieldValue = RowObject.compl-res.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "inst-equip":U THEN ASSIGN pFieldValue = RowObject.inst-equip.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "metodo":U THEN ASSIGN pFieldValue = RowObject.metodo.
        WHEN "narrativa-apr":U THEN ASSIGN pFieldValue = RowObject.narrativa-apr.
        WHEN "refer-tec":U THEN ASSIGN pFieldValue = RowObject.refer-tec.
        WHEN "unidade":U THEN ASSIGN pFieldValue = RowObject.unidade.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "result-max":U THEN ASSIGN pFieldValue = RowObject.result-max.
        WHEN "result-min":U THEN ASSIGN pFieldValue = RowObject.result-min.
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
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "local-cq":U THEN ASSIGN pFieldValue = RowObject.local-cq.
        WHEN "nr-decimais":U THEN ASSIGN pFieldValue = RowObject.nr-decimais.
        WHEN "nr-horas":U THEN ASSIGN pFieldValue = RowObject.nr-horas.
        WHEN "nr-tabela":U THEN ASSIGN pFieldValue = RowObject.nr-tabela.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tipo-result":U THEN ASSIGN pFieldValue = RowObject.tipo-result.
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
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
               retorna valor do campo cod-comp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE it-comp-exame.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE it-comp-exame.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-comp LIKE it-comp-exame.cod-comp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-exame = RowObject.cod-exame
           pcod-comp = RowObject.cod-comp.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE it-comp-exame.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE it-comp-exame.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE it-comp-exame.cod-comp NO-UNDO.

    FIND FIRST bfit-comp-exame WHERE 
        bfit-comp-exame.it-codigo = pit-codigo AND 
        bfit-comp-exame.cod-exame = pcod-exame AND 
        bfit-comp-exame.cod-comp = pcod-comp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-comp-exame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-comp-exame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM hDBoItem AS HANDLE NO-UNDO.

    RUN GetKey IN hDBoItem (OUTPUT cItem).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItCodigo DBOProgram 
PROCEDURE openQueryByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:  Busca todos os it-comp-exame pelo item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} WHERE 
                                     {&TABLENAME}.it-codigo = cItem NO-LOCK
                               BY {&TABLENAME}.cod-exame INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPage1 DBOProgram 
PROCEDURE setConstraintPage1 :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes: constraint  openQueryRange1    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcItem       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piCodExame   AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER piCodCompIni AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER piCodCompFim AS INTEGER    NO-UNDO.
    
    ASSIGN iCodCompIni = piCodCompIni
           iCodCompFim = piCodCompFim
           iCodExame   = piCodExame
           cItem       = pcItem.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPage2 DBOProgram 
PROCEDURE setConstraintPage2 :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes: constraint  openQueryRange2    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcItem     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piCodExame AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pcDescIni  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcDescFim  AS CHARACTER NO-UNDO.
    
    ASSIGN cDescIni  = pcDescIni
           cDescFim  = pcDescFim
           iCodExame = piCodExame
           cItem     = pcItem.           
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRange1 DBOProgram 
PROCEDURE openQueryRange1 :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes: abre query para zoom      
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
      FOR EACH {&TABLENAME} 
         WHERE {&TABLENAME}.it-codigo = cItem 
           AND {&TABLENAME}.cod-exame = iCodExame               
           AND {&TABLENAME}.cod-comp  >= iCodCompIni 
           AND {&TABLENAME}.cod-comp  <= iCodCompFim NO-LOCK
            BY {&TABLENAME}.cod-exame INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRange2 DBOProgram 
PROCEDURE openQueryRange2 :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes: abre query para zoom      
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
      FOR EACH {&TABLENAME} 
         WHERE {&TABLENAME}.it-codigo = cItem 
           AND {&TABLENAME}.cod-exame = iCodExame               
           AND {&TABLENAME}.descricao >= cDescIni
           AND {&TABLENAME}.descricao <= cDescFim NO-LOCK
            BY {&TABLENAME}.descricao INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                  
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:  Busca todos os it-comp-exame pelo item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
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
       
    if pType = "CREATE":U then do:
        find first it-comp-exame no-lock
             where it-comp-exame.cod-exame = RowObject.cod-exame 
               and it-comp-exame.cod-comp  = RowObject.cod-comp  
               and it-comp-exame.it-codigo = RowObject.it-codigo  no-error.
        if avail it-comp-exame then do:
            {utp/ut-table.i mgind it-comp-exame 1}
              {method/svc/errors/inserr.i
                &ErrorNumber="1" /* J· existe ocorrÍncia &1 informada */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=RETURN-VALUE}
        end.
    end.
        
    find first it-exame 
         where it-exame.cod-exame = RowObject.cod-exame 
           and it-exame.it-codigo = RowObject.it-codigo no-lock no-error.
    if not avail it-exame then do:
        {utp/ut-table.i mgind it-exame 1}
        {method/svc/errors/inserr.i
            &ErrorNumber="2" /* N„o encontrado(a) &1 para chave informada. */
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=RETURN-VALUE}
                           
    end.
    
    find first exame no-lock
         where exame.cod-exame    = RowObject.cod-exame
           and exame.cdn-sit-vers = 2 /* Liberada */ no-error.
    if not avail exame then do:
        {utp/ut-table.i mgind exame 1}
        {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=RETURN-VALUE}
        RETURN "NOK":U.
    end.    
    
    find first comp-exame 
         where comp-exame.cod-exame   = RowObject.cod-exame 
           and comp-exame.cod-comp    = RowObject.cod-comp 
           and comp-exame.cdn-versao  = exame.cdn-versao no-lock no-error.
    if not avail comp-exame then do:
        {utp/ut-table.i mgind comp-exame 1}
        {method/svc/errors/inserr.i
            &ErrorNumber="2" /* N„o encontrado(a) &1 para chave informada. */
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=RETURN-VALUE}
        RETURN "NOK":U.
    end.
    
    if RowObject.nr-tabela <> 0 then do:
        find tab-result 
            where tab-result.nr-tabela = RowObject.nr-tabela no-lock no-error.
        if not avail tab-result then do:
            {utp/ut-table.i mgind tab-result 1}
            {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=RETURN-VALUE}
        end.
    end.
    
    assign RowObject.descricao = comp-exame.descricao.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTItExameExterno DBOProgram 
PROCEDURE criaTTItCompExameAux:
/*-----------------------------------------------------------------------------------
  Purpose: Cria temp-table it-exame que sejam externos, filtrados pelo item em tela
  Parameters:  it-codigo
-----------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-it-codigo AS CHARACTER.
    DEFINE INPUT  PARAMETER pc-cod-exame AS INTEGER.
    
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-it-comp-exame-externo-aux.

    IF CAN-FIND(FIRST it-comp-exame 
                WHERE it-comp-exame.it-codigo = pc-it-codigo
                  AND it-comp-exame.cod-exame = pc-cod-exame) THEN DO:

        /* Usa it-comp-exame */
        FOR EACH it-comp-exame FIELDS(cod-exame cod-comp descricao) WHERE it-comp-exame.it-codigo = pc-it-codigo
                                                                      AND it-comp-exame.cod-exame = pc-cod-exame NO-LOCK:

                IF CAN-FIND (FIRST tt-it-comp-exame-externo-aux WHERE tt-it-comp-exame-externo-aux.cod-exame = it-comp-exame.cod-exame
                                                                  AND tt-it-comp-exame-externo-aux.cod-comp  = it-comp-exame.cod-comp) THEN 
                    NEXT.
                    
                    CREATE tt-it-comp-exame-externo-aux.
                    ASSIGN tt-it-comp-exame-externo-aux.checkSum   = "*" 
                           tt-it-comp-exame-externo-aux.cod-exame  = it-comp-exame.cod-exame
                           tt-it-comp-exame-externo-aux.cod-comp   = it-comp-exame.cod-comp
                           tt-it-comp-exame-externo-aux.descricao  = it-comp-exame.descricao.
        END.
    END.
    ELSE DO:
        FIND FIRST exame NO-LOCK
             WHERE exame.cod-exame = pc-cod-exame
               AND exame.cdn-sit-vers = 2 /*liberado*/ NO-ERROR.

        IF NOT AVAILABLE exame THEN
            RETURN "NOK":U.
        /* Usa comp-exame */
        FOR EACH comp-exame FIELDS(cod-exame cod-comp descricao) 
           WHERE comp-exame.cod-exame  = pc-cod-exame 
             AND comp-exame.cdn-versao = exame.cdn-versao NO-LOCK:
            IF CAN-FIND (FIRST tt-it-comp-exame-externo-aux WHERE tt-it-comp-exame-externo-aux.cod-exame = comp-exame.cod-exame
                                                              AND tt-it-comp-exame-externo-aux.cod-comp  = comp-exame.cod-comp) THEN
                NEXT.
                
                CREATE tt-it-comp-exame-externo-aux.
                ASSIGN tt-it-comp-exame-externo-aux.checkSum   = "*" 
                       tt-it-comp-exame-externo-aux.cod-exame  = comp-exame.cod-exame
                       tt-it-comp-exame-externo-aux.cod-comp   = comp-exame.cod-comp
                       tt-it-comp-exame-externo-aux.descricao  = comp-exame.descricao.
        END.
    END.

    RETURN "OK":U.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
/* _UIB-CODE-BLOCK-END */
