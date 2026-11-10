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
{include/i-prgvrs.i BOIN745 2.00.00.018 } /*** "010018" 14/12/2023 15:03:25  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin745 MUT}
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
&GLOBAL-DEFINE DBOName BOIN745
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName unid-negoc
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-unid-negoc /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
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
{inbo/boin745.i RowObject}

{java/boRest.i}

{inbo/boin745.i1} /*** tt-item-un-negoc ***/

{cdp/cdcfgmat.i}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-fim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-des-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-des-fim AS CHARACTER  NO-UNDO.

DEF VAR h-cdapi024   AS HANDLE NO-UNDO.
DEF VAR c-unid-negoc AS CHAR   NO-UNDO.

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
         HEIGHT             = 13.54
         WIDTH              = 50.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acertaUnidNegoc DBOProgram 
PROCEDURE acertaUnidNegoc :

    {inbo/boin745.i2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaUnidNegoc DBOProgram 
PROCEDURE atualizaUnidNegoc :

    {inbo/boin745.i3}

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "des-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.des-unid-negoc.
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
  Purpose:     Retorna valores dos campos do °ndice undngc-id
  Parameters:  
               retorna valor do campo cod-unid-negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-unid-negoc LIKE unid-negoc.cod-unid-negoc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-unid-negoc = RowObject.cod-unid-negoc.

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
  Purpose:     Reposiciona registro com base no °ndice undngc-id
  Parameters:  
               recebe valor do campo cod-unid-negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-unid-negoc LIKE unid-negoc.cod-unid-negoc NO-UNDO.

    FIND FIRST bfunid-negoc WHERE 
        bfunid-negoc.cod-unid-negoc = pcod-unid-negoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfunid-negoc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfunid-negoc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
        FOR EACH {&tableName} NO-LOCK
            WHERE {&tableName}.cod-unid-negoc >= c-cod-ini
            AND   {&tableName}.cod-unid-negoc <= c-cod-fim 
            BY    {&tableName}.cod-unid-negoc INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
        FOR EACH  {&tableName} NO-LOCK
            WHERE {&tableName}.des-unid-negoc >= c-des-ini 
            AND   {&tableName}.des-unid-negoc <= c-des-fim 
            BY    {&tableName}.des-unid-negoc INDEXED-REPOSITION.

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

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintCodigo DBOProgram 
PROCEDURE SetConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-fim AS CHARACTER NO-UNDO.
    
    ASSIGN c-cod-ini = pc-cod-ini
           c-cod-fim = pc-cod-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintDescricao DBOProgram 
PROCEDURE SetConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-des-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-des-fim AS CHARACTER NO-UNDO.
    
    ASSIGN c-des-ini = pc-des-ini
           c-des-fim = pc-des-fim.
    
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

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-unidade_negocio AS CHARACTER FORMAT "X(19)" NO-UNDO.
    {utp/ut-liter.i "Unidade de NegÛcio" *}
    ASSIGN c-unidade_negocio = TRIM(RETURN-VALUE).
    
    IF pType = "DELETE":U THEN DO:

        IF  CAN-FIND (FIRST unid-negoc-estab
                      WHERE unid-negoc-estab.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST unid-negoc-grp-usuar
                      WHERE unid-negoc-grp-usuar.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.
        
        IF  CAN-FIND (FIRST unid-negoc-depos
                      WHERE unid-negoc-depos.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST familia-mat
                      WHERE familia-mat.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST fam-uni-estab
                      WHERE fam-uni-estab.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST ITEM
                      WHERE ITEM.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.
                                        
        IF  CAN-FIND (FIRST item-uni-estab
                      WHERE item-uni-estab.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.
                                        
        IF  CAN-FIND (FIRST it-requisicao
                      WHERE it-requisicao.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST movto-estoq
                      WHERE movto-estoq.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

        IF  CAN-FIND (FIRST ordem-compra
                      WHERE ordem-compra.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorParameters="c-unidade_negocio"}
        END.

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-matriz_contrato AS CHARACTER FORMAT "X(18)" NO-UNDO.
            {utp/ut-liter.i "Matriz do Contrato" *}
            ASSIGN c-matriz_contrato = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-matriz_item AS CHARACTER FORMAT "X(14)" NO-UNDO.
            {utp/ut-liter.i "Matriz do Item" *}
            ASSIGN c-matriz_item = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-matriz_medicao AS CHARACTER FORMAT "X(17)" NO-UNDO.
            {utp/ut-liter.i "Matriz da Medicao" *}
            ASSIGN c-matriz_medicao = TRIM(RETURN-VALUE).
        
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
         IF  RowObject.cod-unid-negoc <> "" THEN DO:
             IF  CAN-FIND(FIRST matriz-rat-contr
                          WHERE matriz-rat-contr.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="5"
                                             &ErrorParameters="c-unidade_negocio + '~~~~' + c-matriz_contrato"}
             END.
             IF  CAN-FIND(FIRST matriz-rat-item
                          WHERE matriz-rat-item.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="5"
                                             &ErrorParameters="c-unidade_negocio + '~~~~' + c-matriz_item"}
             END.
             IF  CAN-FIND(FIRST matriz-rat-med
                          WHERE matriz-rat-med.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="5"
                                             &ErrorParameters="c-unidade_negocio + '~~~~' + c-matriz_medicao"}
             END.
         END.
        &ENDIF
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
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
    OPEN QUERY  {&queryName} FOR EACH {&tableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMatrizUnidNegocEqpto DBOProgram 
PROCEDURE getDesUnidNegoc:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-unid-negoc LIKE {&TableName}.cod-unid-negoc NO-UNDO.
    DEFINE OUTPUT PARAMETER c-des-unid-negoc LIKE {&tableName}.des-unid-negoc NO-UNDO.

    FIND FIRST unid-negoc WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.
    IF AVAIL unid-negoc THEN
        c-des-unid-negoc = unid-negoc.des-unid-negoc.

    RETURN "OK":U.
END PROCEDURE.

