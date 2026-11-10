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
{include/i-prgvrs.i BOIN753 2.00.00.002 } /*** "010002" 11/12/2023 10:13:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN753 MUT}
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
&GLOBAL-DEFINE DBOName BOIN753
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ncm-item
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
{inbo/boin753.i RowObject}
{cxbo/bocx372.i tt-ncm-item-traduz}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/* Definiá∆o de vari†veis  */
DEFINE VAR c-cod-cap-ini     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-cap-fim     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-pos-ini     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-pos-fim     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-subpos-ini  AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-subpos-fim  AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-item-ini    AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-item-fim    AS CHARACTER NO-UNDO.

DEFINE VAR c-cod-cap-aux     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-pos-aux     AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-subpos-aux  AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-item-aux    AS CHARACTER NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  ncm-item-traduz EXCLUSIVE-LOCK
        WHERE ncm-item-traduz.cod-cap    = c-cod-cap-aux   
        AND   ncm-item-traduz.cod-pos    = c-cod-pos-aux   
        AND   ncm-item-traduz.cod-subpos = c-cod-subpos-aux
        AND   ncm-item-traduz.cod-item   = c-cod-item-aux:
        DELETE ncm-item-traduz.
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

    ASSIGN c-cod-cap-aux    = RowObject.cod-cap   
           c-cod-pos-aux    = RowObject.cod-pos   
           c-cod-subpos-aux = RowObject.cod-subpos
           c-cod-item-aux   = RowObject.cod-item.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaItemTraduz DBOProgram 
PROCEDURE copiaItemTraduz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-cap    LIKE ncm-item.cod-cap    NO-UNDO.
    DEFINE INPUT PARAM p-cod-pos    LIKE ncm-item.cod-pos    NO-UNDO.
    DEFINE INPUT PARAM p-cod-subpos LIKE ncm-item.cod-subpos NO-UNDO.
    DEFINE INPUT PARAM p-cod-item   LIKE ncm-item.cod-item   NO-UNDO.

    EMPTY TEMP-TABLE tt-ncm-item-traduz.

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cod-cap    = RowObject.cod-cap   
           AND bf{&TableName}.cod-pos    = RowObject.cod-pos   
           AND bf{&TableName}.cod-subpos = RowObject.cod-subpos
           AND bf{&TableName}.cod-item   = RowObject.cod-item   NO-ERROR.

    FOR EACH ncm-item-traduz NO-LOCK
        WHERE ncm-item-traduz.cod-cap    = p-cod-cap   
          AND ncm-item-traduz.cod-pos    = p-cod-pos   
          AND ncm-item-traduz.cod-subpos = p-cod-subpos
          AND ncm-item-traduz.cod-item   = p-cod-item  :

        CREATE tt-ncm-item-traduz.
        BUFFER-COPY ncm-item-traduz TO tt-ncm-item-traduz.
        ASSIGN tt-ncm-item-traduz.cod-cap    = bf{&TableName}.cod-cap   
               tt-ncm-item-traduz.cod-pos    = bf{&TableName}.cod-pos   
               tt-ncm-item-traduz.cod-subpos = bf{&TableName}.cod-subpos
               tt-ncm-item-traduz.cod-item   = bf{&TableName}.cod-item  .
    END.

    FOR EACH tt-ncm-item-traduz NO-LOCK:
        CREATE ncm-item-traduz.
        BUFFER-COPY tt-ncm-item-traduz TO ncm-item-traduz.
        DELETE tt-ncm-item-traduz.
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
        WHEN "cod-cap":U             THEN ASSIGN pFieldValue = RowObject.cod-cap.
        WHEN "cod-pos":U             THEN ASSIGN pFieldValue = RowObject.cod-pos.
        WHEN "cod-subpos":U          THEN ASSIGN pFieldValue = RowObject.cod-subpos.
        WHEN "cod-item":U            THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "dsl-item":U            THEN ASSIGN pFieldValue = RowObject.dsl-item.
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
        WHEN "dat-ult-alter":U THEN ASSIGN pFieldValue = RowObject.dat-ult-alter.
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
    DEFINE OUTPUT PARAMETER pcod-cap    LIKE ncm-item.cod-cap    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pos    LIKE ncm-item.cod-pos    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-subpos LIKE ncm-item.cod-subpos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item   LIKE ncm-item.cod-item   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cap    = RowObject.cod-cap   
           pcod-pos    = RowObject.cod-pos   
           pcod-subpos = RowObject.cod-subpos
           pcod-item   = RowObject.cod-item.

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
    DEFINE INPUT PARAMETER pcod-cap    LIKE ncm-item.cod-cap    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pos    LIKE ncm-item.cod-pos    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-subpos LIKE ncm-item.cod-subpos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item   LIKE ncm-item.cod-item   NO-UNDO.
    
    FIND FIRST bfncm-item 
         WHERE bfncm-item.cod-cap    = pcod-cap    
         AND   bfncm-item.cod-pos    = pcod-pos   
         AND   bfncm-item.cod-subpos = pcod-subpos
         AND   bfncm-item.cod-item   = pcod-item   NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfncm-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfncm-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each  {&tableName} 
                                    where {&tableName}.cod-cap    >= c-cod-cap-ini
                                    AND   {&tableName}.cod-cap    <= c-cod-cap-fim
                                    AND   {&tableName}.cod-pos    >= c-cod-pos-ini
                                    AND   {&tableName}.cod-pos    <= c-cod-pos-fim
                                    AND   {&tableName}.cod-subpos >= c-cod-subpos-ini
                                    AND   {&tableName}.cod-subpos <= c-cod-subpos-fim
                                    AND   {&tableName}.cod-item   >= c-cod-item-ini
                                    AND   {&tableName}.cod-item   <= c-cod-item-fim 
                                    NO-LOCK by {&TABLENAME}.cod-cap indexed-reposition.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p-cod-cap-ini    AS CHAR.
  DEF INPUT PARAMETER p-cod-cap-fim    AS CHAR.
  DEF INPUT PARAMETER p-cod-pos-ini    AS CHAR.
  DEF INPUT PARAMETER p-cod-pos-fim    AS CHAR.
  DEF INPUT PARAMETER p-cod-subpos-ini AS CHAR.
  DEF INPUT PARAMETER p-cod-subpos-fim AS CHAR.
  DEF INPUT PARAMETER p-cod-item-ini   AS CHAR.
  DEF INPUT PARAMETER p-cod-item-fim   AS CHAR.
  

  ASSIGN c-cod-cap-ini    = p-cod-cap-ini   
         c-cod-cap-fim    = p-cod-cap-fim   
         c-cod-pos-ini    = p-cod-pos-ini   
         c-cod-pos-fim    = p-cod-pos-fim     
         c-cod-subpos-ini = p-cod-subpos-ini
         c-cod-subpos-fim = p-cod-subpos-fim
         c-cod-item-ini   = p-cod-item-ini  
         c-cod-item-fim   = p-cod-item-fim.
       
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
                     WHERE bf{&TableName}.cod-cap    = RowObject.cod-cap   
                     AND   bf{&TableName}.cod-pos    = RowObject.cod-pos   
                     AND   bf{&TableName}.cod-subpos = RowObject.cod-subpos
                     AND   bf{&TableName}.cod-item   = RowObject.cod-item)
        THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-capitulo-posicao-e-subposicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "cap°tulo,_posiá∆o_e_subposiá∆o_informados" *}
            ASSIGN c-lbl-liter-capitulo-posicao-e-subposicao = TRIM(RETURN-VALUE).
            {utp/ut-table.i mgind ncm-item 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="428"
                                        &ErrorType="EMS"
                                        &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + c-lbl-liter-capitulo-posicao-e-subposicao"}
        END.

        IF  RowObject.cod-cap = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind ncm-cap 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST ncm-cap WHERE ncm-cap.cod-cap = RowObject.cod-cap) THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind ncm-cap 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
        END.
            
        IF  RowObject.cod-pos = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind ncm-pos 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST ncm-pos 
                             WHERE ncm-pos.cod-cap = RowObject.cod-cap
                             AND   ncm-pos.cod-pos = RowObject.cod-pos) 
            THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-capitulo-informado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "cap°tulo_informado" *}
                ASSIGN c-lbl-liter-capitulo-informado = TRIM(RETURN-VALUE).
                {utp/ut-table.i mgind ncm-pos 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i &ErrorNumber="26007"
                                            &ErrorType="EMS"
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + c-lbl-liter-capitulo-informado"}
            END.
        END.

        IF  RowObject.cod-subpos = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind ncm-subpos 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST ncm-subpos 
                             WHERE ncm-subpos.cod-cap    = RowObject.cod-cap
                             AND   ncm-subpos.cod-pos    = RowObject.cod-pos
                             AND   ncm-subpos.cod-subpos = RowObject.cod-subpos) 
            THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-capitulo-posicao-informados AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "cap°tulo,_posiá∆o_informados" *}
                ASSIGN c-lbl-liter-capitulo-posicao-informados = TRIM(RETURN-VALUE).
                {utp/ut-table.i mgind ncm-subpos 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i &ErrorNumber="26007"
                                            &ErrorType="EMS"
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + c-lbl-liter-capitulo-posicao-informados"}
            END.
        END.

        IF  RowObject.cod-item = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-item-da-ncm-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Item_da_NCM" *}
            ASSIGN c-lbl-liter-codigo-do-item-da-ncm-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-codigo-do-item-da-ncm-2"}
        END.
    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:

        IF  RowObject.dsl-item = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-do-item-da-ncm AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_do_Item_da_NCM" *}
            ASSIGN c-lbl-liter-descricao-do-item-da-ncm = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-descricao-do-item-da-ncm"}
        END.
        
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
