&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN872 2.00.00.003 } /*** "010003" 13/11/2023 11:45:52 ***/
{include/i-license-manager.i boin872 MRE}

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
&GLOBAL-DEFINE DBOName BOIN872
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-docto-orig-cte
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

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
{inbo/boin872.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-chave-acesso LIKE rat-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
DEF VAR i-idi-origem   LIKE rat-docto-orig-cte.idi-orig-trad     NO-UNDO.
DEF VAR c-cod-emitente LIKE rat-docto-orig-cte.cod-emitente      NO-UNDO.
DEF VAR c-serie-docto  LIKE rat-docto-orig-cte.serie-docto       NO-UNDO.
DEF VAR c-nro-docto    LIKE rat-docto-orig-cte.nro-docto         NO-UNDO.
DEF VAR c-nat-operacao LIKE rat-docto-orig-cte.nat-operacao      NO-UNDO.

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
         HEIGHT             = 14.5
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
        WHEN "cod-aces-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-aces-comp-nfe.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = RowObject.cod-cfop.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nf-nat-oper":U THEN ASSIGN pFieldValue = RowObject.nf-nat-oper.
        WHEN "nf-nro":U THEN ASSIGN pFieldValue = RowObject.nf-nro.
        WHEN "nf-serie":U THEN ASSIGN pFieldValue = RowObject.nf-serie.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "cod-estab-relac":U THEN ASSIGN pFieldValue = RowObject.cod-estab-relac.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
        WHEN "ind-origem-nf":U THEN ASSIGN pFieldValue = RowObject.ind-origem-nf.
        WHEN "nf-emitente":U THEN ASSIGN pFieldValue = RowObject.nf-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice chave-id
  Parameters:  
               retorna valor do campo cod-aces-comp-nfe
               retorna valor do campo idi-orig-trad
               retorna valor do campo nf-serie
               retorna valor do campo nf-nro
               retorna valor do campo nf-emitente
               retorna valor do campo nf-nat-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aces-comp-nfe LIKE rat-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE rat-docto-orig-cte.idi-orig-trad NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-serie LIKE rat-docto-orig-cte.nf-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-nro LIKE rat-docto-orig-cte.nf-nro NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-emitente LIKE rat-docto-orig-cte.nf-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-nat-oper LIKE rat-docto-orig-cte.nf-nat-oper NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad
           pnf-serie = RowObject.nf-serie
           pnf-nro = RowObject.nf-nro
           pnf-emitente = RowObject.nf-emitente
           pnf-nat-oper = RowObject.nf-nat-oper.

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
  Purpose:     Reposiciona registro com base no °ndice chave-id
  Parameters:  
               recebe valor do campo cod-aces-comp-nfe
               recebe valor do campo idi-orig-trad
               recebe valor do campo nf-serie
               recebe valor do campo nf-nro
               recebe valor do campo nf-emitente
               recebe valor do campo nf-nat-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aces-comp-nfe LIKE rat-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE rat-docto-orig-cte.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAMETER pnf-serie LIKE rat-docto-orig-cte.nf-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnf-nro LIKE rat-docto-orig-cte.nf-nro NO-UNDO.
    DEFINE INPUT PARAMETER pnf-emitente LIKE rat-docto-orig-cte.nf-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnf-nat-oper LIKE rat-docto-orig-cte.nf-nat-oper NO-UNDO.

    FIND FIRST bfrat-docto-orig-cte WHERE 
        bfrat-docto-orig-cte.cod-aces-comp-nfe = pcod-aces-comp-nfe AND 
        bfrat-docto-orig-cte.idi-orig-trad = pidi-orig-trad AND 
        bfrat-docto-orig-cte.nf-serie = pnf-serie AND 
        bfrat-docto-orig-cte.nf-nro = pnf-nro AND 
        bfrat-docto-orig-cte.nf-emitente = pnf-emitente AND 
        bfrat-docto-orig-cte.nf-nat-oper = pnf-nat-oper NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-docto-orig-cte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-docto-orig-cte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAcessoChave DBOProgram 
PROCEDURE openQueryAcessoChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-aces-comp-nfe = c-chave-acesso
           AND {&TableName}.idi-orig-trad     = i-idi-origem INDEXED-REPOSITION.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAcessoChave DBOProgram 
PROCEDURE setConstraintAcessoChave :
/*------------------------------------------------------------------------------
  Purpose:     Setar parametros da chave de acesso
  Parameters:  p-chave-acesso - Chave de acesso do documento
               p-idi-origem   - C¢digo de destino do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-chave-acesso LIKE rat-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEF INPUT PARAM p-idi-origem   LIKE rat-docto-orig-cte.idi-orig-trad     NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem.

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

    IF pType = "CREATE":U THEN DO:
        FIND FIRST bf{&TableName} NO-LOCK
             WHERE bf{&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
               AND bf{&TableName}.idi-orig-trad     = RowObject.idi-orig-trad
               AND bf{&TableName}.nf-serie          = RowObject.nf-serie
               AND bf{&TableName}.nf-nro            = RowObject.nf-nro
               AND bf{&TableName}.nf-emitente       = RowObject.nf-emitente
               AND bf{&TableName}.nf-nat-oper       = RowObject.nf-nat-oper NO-ERROR.

        /*-- J† existe Registro com Chave Informada --*/
        IF  AVAIL bf{&TableName} THEN DO:
            {utp/ut-table.i mgind rat-docto-orig-cte 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                               &ErrorNumber="8"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}
        END. 
    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:

        IF RowObject.cod-estab-relac <> "" AND
           RowObject.cod-estab-relac <> ? AND
           NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estab-relac) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                                &ErrorNumber="47" // Estabelecimento nao encontrado
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF RowObject.idi-orig-trad = 3 THEN DO: // nota de saida transportada - Frete NF Saida
            IF NOT CAN-FIND(FIRST nota-fiscal
                            WHERE nota-fiscal.cod-estabel   = RowObject.cod-estab-relac
                              AND nota-fiscal.serie         = RowObject.nf-serie
                              AND nota-fiscal.nr-nota-fis   = RowObject.nf-nro) THEN DO:

                {utp/ut-liter.i Nota_Fiscal *}
                {method/svc/errors/inserr.i
                                    &ErrorNumber="47" // Nota fiscal de saida nao encontrada
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
            ELSE DO:
                IF CAN-FIND(FIRST nota-fiscal
                            WHERE nota-fiscal.cod-estabel   = RowObject.cod-estab-relac
                              AND nota-fiscal.serie         = RowObject.nf-serie
                              AND nota-fiscal.nr-nota-fis   = RowObject.nf-nro
                              AND nota-fiscal.ind-tip-nota  = 8) THEN DO:
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="57246" // Nota de entrada que gerou faturamento nao pode ser vinculada
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
                END.
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


