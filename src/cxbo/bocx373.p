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
{include/i-prgvrs.i BOCX373 2.00.00.001} /*** "010001" 11/12/2023 10:13:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX373 MUT}
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
&GLOBAL-DEFINE DBOName BOCX373
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName acordo
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
{cxbo/bocx373.i RowObject}
{cxbo/bocx374.i tt-acordo-traduz}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o de vari†veis  */
DEFINE VAR i-pais-ini             AS INTEGER    NO-UNDO.
DEFINE VAR i-pais-fim             AS INTEGER    NO-UNDO.
DEFINE VAR c-acordo-ini           AS CHARACTER  NO-UNDO.
DEFINE VAR c-acordo-fim           AS CHARACTER  NO-UNDO.
DEFINE VAR dt-inic-vigenc-ini     AS DATE       NO-UNDO.
DEFINE VAR dt-inic-vigenc-fim     AS DATE       NO-UNDO.

DEFINE VAR c-cdn-pais-aux         AS INTEGER    NO-UNDO.
DEFINE VAR c-cod-acordo-aux       AS CHARACTER  NO-UNDO.
DEFINE VAR c-cod-classif-fisc-aux AS CHARACTER  NO-UNDO.
DEFINE VAR c-dat-inic-vigenc-aux  AS DATE       NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 15.08
         WIDTH              = 34.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  acordo-traduz EXCLUSIVE-LOCK
        WHERE acordo-traduz.cdn-pais         = c-cdn-pais-aux
        AND   acordo-traduz.cod-acordo       = c-cod-acordo-aux
        AND   acordo-traduz.cod-classif-fisc = c-cod-classif-fisc-aux
        AND   acordo-traduz.dat-inic-vigenc  = c-dat-inic-vigenc-aux:
        DELETE acordo-traduz.
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

    ASSIGN c-cdn-pais-aux         = RowObject.cdn-pais        
           c-cod-acordo-aux       = RowObject.cod-acordo      
           c-cod-classif-fisc-aux = RowObject.cod-classif-fisc
           c-dat-inic-vigenc-aux  = RowObject.dat-inic-vigenc.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaSubPosTraduz DBOProgram 
PROCEDURE copiaSubPosTraduz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cdn-pais         LIKE acordo.cdn-pais         NO-UNDO.
    DEFINE INPUT PARAM p-cod-acordo       LIKE acordo.cod-acordo       NO-UNDO.
    DEFINE INPUT PARAM p-cod-classif-fisc LIKE acordo.cod-classif-fisc NO-UNDO.
    DEFINE INPUT PARAM p-dat-inic-vigenc  LIKE acordo.dat-inic-vigenc  NO-UNDO.

    EMPTY TEMP-TABLE tt-acordo-traduz.

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cdn-pais         = RowObject.cdn-pais        
           AND bf{&TableName}.cod-acordo       = RowObject.cod-acordo      
           AND bf{&TableName}.cod-classif-fisc = RowObject.cod-classif-fisc
           AND bf{&TableName}.dat-inic-vigenc  = RowObject.dat-inic-vigenc  NO-ERROR.

    FOR EACH acordo-traduz NO-LOCK
        WHERE acordo-traduz.cdn-pais         = p-cdn-pais        
          AND acordo-traduz.cod-acordo       = p-cod-acordo      
          AND acordo-traduz.cod-classif-fisc = p-cod-classif-fisc
          AND acordo-traduz.dat-inic-vigenc  = p-dat-inic-vigenc :

        CREATE tt-acordo-traduz.
        BUFFER-COPY acordo-traduz TO tt-acordo-traduz.
        ASSIGN tt-acordo-traduz.cdn-pais         = bf{&TableName}.cdn-pais        
               tt-acordo-traduz.cod-acordo       = bf{&TableName}.cod-acordo      
               tt-acordo-traduz.cod-classif-fisc = bf{&TableName}.cod-classif-fisc
               tt-acordo-traduz.dat-inic-vigenc  = bf{&TableName}.dat-inic-vigenc .
    END.

    FOR EACH tt-acordo-traduz NO-LOCK:
        CREATE acordo-traduz.
        BUFFER-COPY tt-acordo-traduz TO acordo-traduz.
        DELETE tt-acordo-traduz.
    END.

    RETURN "OK":U.
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
        WHEN "cod-acordo":U          THEN ASSIGN pFieldValue = RowObject.cod-acordo.
        WHEN "cod-classif-fisc":U    THEN ASSIGN pFieldValue = RowObject.cod-classif-fisc.
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
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice 
  Parameters:  
               retorna valor do campo cdn-pais
               retorna valor do campo cod-acordo
               retorna valor do campo cod-classif-fisc
               retorna valor do campo dat-inic-vigenc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-pais         LIKE acordo.cdn-pais         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acordo       LIKE acordo.cod-acordo       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-classif-fisc LIKE acordo.cod-classif-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-inic-vigenc  LIKE acordo.dat-inic-vigenc  NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-pais         = RowObject.cdn-pais        
           pcod-acordo       = RowObject.cod-acordo      
           pcod-classif-fisc = RowObject.cod-classif-fisc
           pdat-inic-vigenc  = RowObject.dat-inic-vigenc .

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
               recebe valor do campo cdn-pais        
               recebe valor do campo cod-acordo      
               recebe valor do campo cod-classif-fisc
               recebe valor do campo dat-inic-vigenc 
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-pais         LIKE acordo.cdn-pais         NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acordo       LIKE acordo.cod-acordo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-classif-fisc LIKE acordo.cod-classif-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pdat-inic-vigenc  LIKE acordo.dat-inic-vigenc  NO-UNDO.
    
    FIND FIRST bfacordo 
         WHERE bfacordo.cdn-pais         = pcdn-pais         
         AND   bfacordo.cod-acordo       = pcod-acordo      
         AND   bfacordo.cod-classif-fisc = pcod-classif-fisc
         AND   bfacordo.dat-inic-vigenc  = pdat-inic-vigenc  NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfacordo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfacordo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAcordo DBOProgram 
PROCEDURE openQueryAcordo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        OPEN QUERY {&QUERYNAME} FOR EACH  {&tableName} 
                                    where {&tableName}.cdn-pais         >= i-pais-ini
                                    AND   {&tableName}.cdn-pais         <= i-pais-fim
                                    AND   {&tableName}.cod-acordo       >= c-acordo-ini
                                    AND   {&tableName}.cod-acordo       <= c-acordo-fim
                                    AND   {&tableName}.dat-inic-vigenc  >= dt-inic-vigenc-ini
                                    AND   {&tableName}.dat-inic-vigenc  <= dt-inic-vigenc-fim
                                    NO-LOCK BY {&TABLENAME}.cdn-pais INDEXED-REPOSITION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaAcordo DBOProgram 
PROCEDURE retornaAcordo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prAcordo AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-acordo-aux.

    FIND bfAcordo WHERE ROWID(bfAcordo) = prAcordo NO-LOCK NO-ERROR.
    IF AVAIL bfAcordo THEN DO:
        EMPTY TEMP-TABLE tt-acordo-aux.
        CREATE tt-acordo-aux.
        BUFFER-COPY bfAcordo TO tt-acordo-aux.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAcordo DBOProgram 
PROCEDURE setConstraintAcordo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p-pais-ini         AS INT.
  DEF INPUT PARAMETER p-pais-fim         AS INT.
  DEF INPUT PARAMETER p-acordo-ini       AS CHAR.
  DEF INPUT PARAMETER p-acordo-fim       AS CHAR.
  DEF INPUT PARAMETER p-inic-vigenc-ini  AS DATE.
  DEF INPUT PARAMETER p-inic-vigenc-fim  AS DATE.
  
  ASSIGN i-pais-ini         = p-pais-ini        
         i-pais-fim         = p-pais-fim        
         c-acordo-ini       = p-acordo-ini      
         c-acordo-fim       = p-acordo-fim        
         dt-inic-vigenc-ini = p-inic-vigenc-ini
         dt-inic-vigenc-fim = p-inic-vigenc-fim.
       
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

        IF CAN-FIND (FIRST  bf{&TableName} 
                     WHERE  bf{&TableName}.cdn-pais         = RowObject.cdn-pais        
                     AND    bf{&TableName}.cod-acordo       = RowObject.cod-acordo      
                     AND    bf{&TableName}.cod-classif-fisc = RowObject.cod-classif-fisc
                     AND    bf{&TableName}.dat-inic-vigenc  = RowObject.dat-inic-vigenc)
        THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-acordo-internacional AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Acordo_Internacional" *}
            ASSIGN c-lbl-liter-acordo-internacional = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="18715"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-acordo-internacional"}
        END.


        IF  RowObject.cdn-pais = 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-pais AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Pa°s" *}
            ASSIGN c-lbl-liter-codigo-do-pais = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-codigo-do-pais"}
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST pais 
                             WHERE pais.cod-pais = RowObject.cdn-pais) 
            THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-do-pais-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_do_Pa°s" *}
                ASSIGN c-lbl-liter-codigo-do-pais-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-liter-codigo-do-pais-2"}
            END.
        END.
            
        IF  RowObject.cod-acordo = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-acordo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Acordo" *}
            ASSIGN c-lbl-liter-codigo-do-acordo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-codigo-do-acordo"}
        END.
        
        IF  RowObject.cod-classif-fisc = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
            ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-classificacao-fiscal"}
        END.
        ELSE DO:
        
            IF  RowObject.cod-classif-fisc <> ? THEN DO:
                IF NOT CAN-FIND (FIRST classif-fisc
                                 WHERE classif-fisc.class-fiscal = RowObject.cod-classif-fisc) 
                THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-codigo-da-classificacao-fiscal AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "C¢digo_da_Classificaá∆o_Fiscal" *}
                    ASSIGN c-lbl-liter-codigo-da-classificacao-fiscal = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="26387"
                                                &ErrorType="EMS"
                                                &ErrorParameters="c-lbl-liter-codigo-da-classificacao-fiscal"}
                END.
            END.
        END.

        IF  RowObject.dat-inic-vigenc = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-data-inicio-vigencia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Data_In°cio_Vigància" *}
            ASSIGN c-lbl-liter-data-inicio-vigencia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-data-inicio-vigencia"}
        END.

    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:

        IF  RowObject.dsl-acordo = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-do-acordo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_do_acordo" *}
            ASSIGN c-lbl-liter-descricao-do-acordo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-descricao-do-acordo"}
        END.

        IF  RowObject.dsl-norma = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-da-norma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_da_norma" *}
            ASSIGN c-lbl-liter-descricao-da-norma = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-descricao-da-norma"}
        END.

        
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

