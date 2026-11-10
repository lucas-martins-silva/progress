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
{include/i-prgvrs.i BOCX374 2.00.00.001} /*** "010001" 11/12/2023 10:13:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX374 MUT}
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
&GLOBAL-DEFINE DBOName BOCX374
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName acordo-traduz
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
{cxbo/bocx374.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-pais   AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-acordo AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-clas   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dt-inic  AS DATE       NO-UNDO.


/* Definiá∆o de vari†veis  */

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
         HEIGHT             = 15
         WIDTH              = 41.72.
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
        WHEN "cod-acordo":U          THEN ASSIGN pFieldValue = RowObject.cod-acordo.
        WHEN "cod-classif-fisc":U    THEN ASSIGN pFieldValue = RowObject.cod-classif-fisc.
        WHEN "cod-idioma":U          THEN ASSIGN pFieldValue = RowObject.cod-idioma.
        WHEN "dsl-acordo":U          THEN ASSIGN pFieldValue = RowObject.dsl-acordo.
        WHEN "dsl-norma":U           THEN ASSIGN pFieldValue = RowObject.dsl-norma.
        WHEN "cod-usuar-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-alter.
        WHEN "hra-ult-alter":U       THEN ASSIGN pFieldValue = RowObject.hra-ult-alter.
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
        WHEN "dat-inic-vigenc":U THEN ASSIGN pFieldValue = RowObject.dat-inic-vigenc.
        WHEN "dat-ult-alter":U   THEN ASSIGN pFieldValue = RowObject.dat-ult-alter.
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
        WHEN "cdn-pais":U     THEN ASSIGN pFieldValue = RowObject.cdn-pais.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice esd-requisicao
  Parameters:  
               retorna valor do campo nr-requisicao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-pais         LIKE acordo-traduz.cdn-pais         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acordo       LIKE acordo-traduz.cod-acordo       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-classif-fisc LIKE acordo-traduz.cod-classif-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-inic-vigenc  LIKE acordo-traduz.dat-inic-vigenc  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-idioma       LIKE acordo-traduz.cod-idioma NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-pais         = RowObject.cdn-pais        
           pcod-acordo       = RowObject.cod-acordo      
           pcod-classif-fisc = RowObject.cod-classif-fisc
           pdat-inic-vigenc  = RowObject.dat-inic-vigenc 
           pcod-idioma       = RowObject.cod-idioma.

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
  Purpose:     Reposiciona registro com base no °ndice esd-requisicao
  Parameters:  
               recebe valor do campo nr-requisicao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-pais         LIKE acordo-traduz.cdn-pais         NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acordo       LIKE acordo-traduz.cod-acordo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-classif-fisc LIKE acordo-traduz.cod-classif-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pdat-inic-vigenc  LIKE acordo-traduz.dat-inic-vigenc  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-idioma       LIKE acordo-traduz.cod-idioma       NO-UNDO.
    
    FIND FIRST bfacordo-traduz 
         WHERE bfacordo-traduz.cdn-pais         = pcdn-pais        
         AND   bfacordo-traduz.cod-acordo       = pcod-acordo      
         AND   bfacordo-traduz.cod-classif-fisc = pcod-classif-fisc
         AND   bfacordo-traduz.dat-inic-vigenc  = pdat-inic-vigenc 
         AND   bfacordo-traduz.cod-idioma       = pcod-idioma NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfacordo-traduz THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfacordo-traduz)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToByAcordo DBOProgram 
PROCEDURE linkToByAcordo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.
    
    IF VALID-HANDLE(p-handle) THEN
        RUN getKey IN p-handle (OUTPUT i-pais,
                                OUTPUT c-acordo,
                                OUTPUT c-clas,
                                OUTPUT dt-inic).
    ELSE
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAcordo DBOProgram 
PROCEDURE openQueryByAcordo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH  {&TableName} 
                              WHERE {&TableName}.cdn-pais         = i-pais
                              AND   {&TableName}.cod-acordo       = c-acordo
                              AND   {&TableName}.cod-classif-fisc = c-clas
                              AND   {&TableName}.dat-inic-vigenc  = dt-inic  NO-LOCK INDEXED-REPOSITION.
   
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


    IF  pType = "Create":U THEN DO:

        IF CAN-FIND (FIRST bf{&TableName} 
                     WHERE bf{&TableName}.cdn-pais         = RowObject.cdn-pais        
                     AND   bf{&TableName}.cod-acordo       = RowObject.cod-acordo      
                     AND   bf{&TableName}.cod-classif-fisc = RowObject.cod-classif-fisc
                     AND   bf{&TableName}.dat-inic-vigenc  = RowObject.dat-inic-vigenc 
                     AND   bf{&TableName}.cod-idioma       = RowObject.cod-idioma)
        THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-idioma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Idioma" *}
            ASSIGN c-lbl-liter-codigo-do-idioma = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-codigo-do-idioma"}
        END.


        IF  RowObject.cod-idioma = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-idioma-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Idioma" *}
            ASSIGN c-lbl-liter-codigo-do-idioma-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-codigo-do-idioma-2"}
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST idioma 
                             WHERE idioma.cod_idioma = RowObject.cod-idioma) 
            THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-do-idioma-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_do_Idioma" *}
                ASSIGN c-lbl-liter-codigo-do-idioma-3 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-liter-codigo-do-idioma-3"}
            END.
        END.
                    
    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:

        IF  RowObject.dsl-acordo = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-traduzida-do-acordo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_Traduzida_do_acordo" *}
            ASSIGN c-lbl-liter-descricao-traduzida-do-acordo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-descricao-traduzida-do-acordo"}
        END.

        IF  RowObject.dsl-norma = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-traduzida-da-norma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_Traduzida_da_norma" *}
            ASSIGN c-lbl-liter-descricao-traduzida-da-norma = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-descricao-traduzida-da-norma"}
        END.

        
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

