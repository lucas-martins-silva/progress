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
{include/i-prgvrs.i BOIN789 2.00.00.016 } /*** "010016" 07/02/2024 11:19:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin789 MUT}
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
&GLOBAL-DEFINE DBOName boin789
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-chave-doc-aprov
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
{inbo/boin789.i RowObject}
{inbo/boin789.i tt-mla-chave-doc-aprov}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{lap/mlaapi001.i99}
DEFINE VARIABLE i-chave AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-chave-para-validacao AS LOGICAL     NO-UNDO.

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
         HEIGHT             = 5.5
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
        WHEN "char-3":U THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "desc-campo":U THEN ASSIGN pFieldValue = RowObject.desc-campo.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getChave DBOProgram 
PROCEDURE getChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
    DEFINE OUTPUT PARAMETER p-chave       AS CHARACTER NO-UNDO.

    ASSIGN p-chave = "".
    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.

    ASSIGN i-chave = 0.
    FOR EACH {&TABLENAME} WHERE
        {&TABLENAME}.cod-tip-doc = p-cod-tip-doc NO-LOCK:
        ASSIGN i-chave = i-chave + 1
               p-chave = p-chave + tt-mla-chave.valor[i-chave] + substring("                    ",1,  
                                   ((({&TABLENAME}.posicao-fim - {&TABLENAME}.posicao-ini) + 1) - length(tt-mla-chave.valor[i-chave]))). 
    END.

    ASSIGN p-chave = RIGHT-TRIM(p-chave).

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
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "posicao-fim":U THEN ASSIGN pFieldValue = RowObject.posicao-fim.
        WHEN "posicao-ini":U THEN ASSIGN pFieldValue = RowObject.posicao-ini.
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
               retorna valor do campo cod-tip-doc
               retorna valor do campo posicao-ini
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-chave-doc-aprov.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pposicao-ini LIKE mla-chave-doc-aprov.posicao-ini NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-tip-doc = RowObject.cod-tip-doc
           pposicao-ini = RowObject.posicao-ini.

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
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
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
               recebe valor do campo cod-tip-doc
               recebe valor do campo posicao-ini
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-chave-doc-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pposicao-ini LIKE mla-chave-doc-aprov.posicao-ini NO-UNDO.

    FIND FIRST bfmla-chave-doc-aprov WHERE 
        bfmla-chave-doc-aprov.cod-tip-doc = pcod-tip-doc AND 
        bfmla-chave-doc-aprov.posicao-ini = pposicao-ini NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-chave-doc-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-chave-doc-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

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
    open query {&QUERYNAME} 
        for each {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaChaveDoc DBOProgram 
PROCEDURE piCriaChaveDoc :
/*------------------------------------------------------------------------------
  Purpose:     Criar as chaves dos documentos padroes no MLA0102 de acordo com 
               os documentos selecionados para criacao no MLA0122
  Parameters:  (Entrada) Empresa do estabelecimento selecionado na tela do MLA0122
               (Entrada) Codigo do Tipo do documento passado como parametro via MLA0122RP
               (Entrada) Posicao inicial da chave do documento tambem passado como 
               parametro via MLA0122RP
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-ep-codigo   LIKE mla-chave-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-tip-doc LIKE mla-chave-doc-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-posicao-ini LIKE mla-chave-doc-aprov.posicao-ini NO-UNDO.

    IF  CAN-FIND(FIRST mla-chave-doc-aprov
                 WHERE mla-chave-doc-aprov.ep-codigo   = p-ep-codigo
                   AND mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc
                   AND mla-chave-doc-aprov.posicao-ini = p-posicao-ini ) AND
        NOT l-chave-para-validacao THEN DO:
        RETURN "OK":U.
    END.

    CREATE tt-mla-chave-doc-aprov.
    ASSIGN tt-mla-chave-doc-aprov.ep-codigo   = p-ep-codigo
           tt-mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc.
    
    CASE p-cod-tip-doc:
        WHEN 1  OR 
        WHEN 3  OR 
        WHEN 18 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 9.
                IF p-cod-tip-doc = 1 
                OR p-cod-tip-doc = 18 THEN DO:
                    {utp/ut-liter.i "Nr_Solic" *}
                    ASSIGN tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
                ELSE DO:
                    {utp/ut-liter.i "Nr_Requis" *}
                    ASSIGN tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
            END.

            IF p-posicao-ini = 10 THEN DO:
                {utp/ut-liter.i "Seq_Item" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 12.
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 13 THEN DO:
                {utp/ut-liter.i "Cod_Item" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 28
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
        END.
        
        WHEN 2  OR
        WHEN 4  OR 
        WHEN 20 THEN DO:
            IF p-cod-tip-doc = 2 
            OR p-cod-tip-doc = 20 THEN
                {utp/ut-liter.i "Nr_Solic" *}
            ELSE
                {utp/ut-liter.i "Nr_Requis" *}
            ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                   tt-mla-chave-doc-aprov.posicao-fim = 9
                   tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.

        END.
        
        WHEN 5 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Nr_Ordem" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 8
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
            IF p-posicao-ini = 9 THEN DO:
                {utp/ut-liter.i "Fornecedor" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 17
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.
            IF p-posicao-ini = 18 THEN DO:
                {utp/ut-liter.i "Cod_Item" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 33
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.

            IF p-posicao-ini = 34 THEN DO:
                {utp/ut-liter.i "Sequància" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 36
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.
        END.
        
        WHEN 6 OR
        WHEN 7 OR
        WHEN 8 OR
        WHEN 19 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Nr_Pedido" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 8
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
            IF p-cod-tip-doc = 6
            OR p-cod-tip-doc = 19 THEN DO:
                IF p-posicao-ini = 9 THEN DO:
                    {utp/ut-liter.i "Nr_Ordem" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 16
                           tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
            END.
        END.
        
        WHEN 9 OR 
        WHEN 10 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Nr_Processo" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 6
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
            
            IF p-cod-tip-doc = 9 THEN DO:
                IF p-posicao-ini = 7 THEN DO:
                    {utp/ut-liter.i "Nr_Ordem" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 14
                           tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
            END.
        END.
        
        WHEN 13 OR
        WHEN 14 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Nr_Contrato" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 9
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-cod-tip-doc = 14 THEN DO:
                IF p-posicao-ini = 10 THEN DO:
                    {utp/ut-liter.i "Seq_Item" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 14
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.

                IF p-posicao-ini = 15 THEN DO:
                    {utp/ut-liter.i "Nr_Ordem" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 22
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.

                IF p-posicao-ini = 23 THEN DO:
                    {utp/ut-liter.i "Seq_Evento" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 26
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.

                IF p-posicao-ini = 27 THEN DO:
                    {utp/ut-liter.i "Seq_Mediá∆o" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 30
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.
            END.
        END.
        
        WHEN 16 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Nr_Ordem" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 8
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 9 THEN DO:
                {utp/ut-liter.i "Dt_Evento" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 18
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
            
            IF p-posicao-ini = 19 THEN DO:
                {utp/ut-liter.i "Seq_Evento" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 22
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.
        END.
        
        WHEN 21 THEN DO:
            {utp/ut-liter.i "Nr_Pedido" *}
            ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                   tt-mla-chave-doc-aprov.posicao-fim = 11
                   tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
        END.
        
        WHEN 24 OR 
        WHEN 25 OR
        WHEN 26 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Est" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 3
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 4 THEN DO:
                {utp/ut-liter.i "Referància" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 13
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-cod-tip-doc = 24 THEN DO:
                IF p-posicao-ini = 14 THEN DO:
                    {utp/ut-liter.i "Seq" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 17
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.

                IF p-posicao-ini = 18 THEN DO:
                    {utp/ut-liter.i "Conta" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 25
                           tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
                END.

                IF p-posicao-ini = 26 THEN DO:
                    {utp/ut-liter.i "Centro_de_Custo" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 33
                           tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
            END.

            IF p-cod-tip-doc = 26 THEN DO:
                IF p-posicao-ini = 14 THEN DO:
                    {utp/ut-liter.i "Conta" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 21
                           tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.

                IF p-posicao-ini = 22 THEN DO:
                    {utp/ut-liter.i "Centro_de_Custo" *}
                    ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                           tt-mla-chave-doc-aprov.posicao-fim = 29
                           tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
                END.
            END.
        END.
        
        WHEN 28 THEN DO:
            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Est" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 3
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 4 THEN DO:
                {utp/ut-liter.i "Num_Id_Titulo_AP" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 13
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.
            
            IF p-posicao-ini = 14 THEN DO:
                {utp/ut-liter.i "Seq" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 17
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.

            IF p-posicao-ini = 18 THEN DO:
                {utp/ut-liter.i "Conta" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 25
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.

            IF p-posicao-ini = 26 THEN DO:
                {utp/ut-liter.i "Centro_de_Custo" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 33
                       tt-mla-chave-doc-aprov.desc-campo   = RETURN-VALUE.
            END.
        END.

        WHEN 29 THEN DO:

            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Est" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 5
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 6 THEN DO:
                {utp/ut-liter.i "Fornecedor" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 20
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 21 THEN DO:
                {utp/ut-liter.i "Tabela" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 27
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 28 THEN DO:
                {utp/ut-liter.i "Negociaá∆o" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 33
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

        END.

        WHEN 30 /* Documento de Fretes */ THEN DO:

            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Cod_Estabel" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 5
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 6 THEN DO:
                {utp/ut-liter.i "EspÇcie_Docto" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 10
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 11 THEN DO:
                {utp/ut-liter.i "Transportador" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 20
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 21 THEN DO:
                {utp/ut-liter.i "SÇrie" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 24
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 25 THEN DO:
                {utp/ut-liter.i "Nr_Doc_Frete" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 32
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 33 THEN DO:
                {utp/ut-liter.i "Dt_Emiss∆o" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 40
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

        END.

        WHEN 31 /* Fatura de Fretes */ THEN DO:

            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Cod_Estabel" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 5
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 6 THEN DO:
                {utp/ut-liter.i "Transportador" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 14
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 15 THEN DO:
                {utp/ut-liter.i "SÇrie" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 19
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 20 THEN DO:
                {utp/ut-liter.i "Nr_Fatura" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 30
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 31 THEN DO:
                {utp/ut-liter.i "Dt_Emiss∆o" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 39
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

        END.

        WHEN 32 /* Originaá∆o - Adiamento Valor */ THEN DO:

            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Empresa" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 3
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 4 THEN DO:
                {utp/ut-liter.i "Cod_Contrato" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 23
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 24 THEN DO:
                {utp/ut-liter.i "Num_Seq" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 29
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

        END.

        WHEN 33 /* Originaá∆o - Fechamento Financeiro */ THEN DO:

            IF p-posicao-ini = 1 THEN DO:
                {utp/ut-liter.i "Empresa" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 3
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 4 THEN DO:
                {utp/ut-liter.i "Num_Fechto" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 12
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

            IF p-posicao-ini = 13 THEN DO:
                {utp/ut-liter.i "Revisao" *}
                ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                       tt-mla-chave-doc-aprov.posicao-fim = 16
                       tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
            END.

        END.

        OTHERWISE DO: /*cria com 0 para depois eliminar o registro da tabela no mla0122rp*/
            {utp/ut-liter.i "Documento_espec°fico"}
            ASSIGN tt-mla-chave-doc-aprov.posicao-ini = p-posicao-ini
                   tt-mla-chave-doc-aprov.desc-campo  = RETURN-VALUE.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaMlaChaveDocAprov DBOProgram 
PROCEDURE piRetornaMlaChaveDocAprov :
/*------------------------------------------------------------------------------
  Purpose:     Retornar para o programa MLA0122RP a temp-table com as chaves dos 
               documentos selecionados no folder "Documentos" do programa MLA0122 
               para criaá∆o dos registros dos documentos padroes no MLA0102
  Parameters:  (Saida) temp-table com informacoes padroes das chaves dos documentos
                carregadas na procedure "piCriaChaveDoc" desta boin789.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mla-chave-doc-aprov.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaChaveParaValidacao DBOProgram 
PROCEDURE piSetaChaveParaValidacao :
/*------------------------------------------------------------------------------
  Purpose: Seta a variavÇl l¢gica para indicar que a procedure piCriaChaveDoc
           ser† utilizada apenas para retornar a chave padr∆o do documento, 
           independente se j† existir ou n∆o    
  Parameters:  pl-chave-para-validacao (INPUT - logical): Indica que o processo ser†
                                                          apenas validaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-chave-para-validacao AS LOGICAL NO-UNDO.

    ASSIGN l-chave-para-validacao = pl-chave-para-validacao.

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
    IF pType = "Create":U OR
       pType = "Update":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-chave-doc-aprov
                     WHERE mla-chave-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-chave-doc-aprov.posicao-ini = RowObject.posicao-ini) THEN DO:
            {utp/ut-liter.i "chave_dos_documentos"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.


        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Posiá∆o inicial maior ou igual a final */
        IF rowObject.posicao-ini >= rowObject.posicao-fim THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-posicao-ini AS CHARACTER NO-UNDO.
            {utp/ut-liter.i Posiá∆o_inicial * r}
            assign c-posicao-ini = return-value.    
            DEFINE VARIABLE c-posicao-fim AS CHARACTER NO-UNDO.
            {utp/ut-liter.i Posiá∆o_final * r}
            assign c-posicao-fim = return-value.    
            {method/svc/errors/inserr.i
                    &ErrorNumber="1207"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-posicao-fim + '~~~~' + c-posicao-ini"}
        END.

        /* Posiá∆o inicial v†lida */
        FOR LAST {&TableName} NO-LOCK
           WHERE {&TableName}.cod-tip-doc = RowObject.cod-tip-doc
              BY {&TableName}.posicao-ini:
            IF ({&TableName}.posicao-fim + 1) <> RowObject.posicao-ini THEN DO:
                {utp/ut-liter.i "Chave do documento"}
                {method/svc/errors/inserr.i
                        &ErrorNumber="16359"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=RETURN-VALUE}
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

