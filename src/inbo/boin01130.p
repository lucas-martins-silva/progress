&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2025)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN01130 2.00.00.000 } 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN01130 MUT}
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
&GLOBAL-DEFINE DBOName BOIN01130
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ct-trib-despesa-aces
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
{inbo/boin01130.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
        WHEN "cod-chave-cenar":U THEN ASSIGN pFieldValue = RowObject.cod-chave-cenar.
        WHEN "cod-configur-trib":U THEN ASSIGN pFieldValue = RowObject.cod-configur-trib.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-formul-base-calc":U THEN ASSIGN pFieldValue = RowObject.cod-formul-base-calc.
        WHEN "cod-formul-trib":U THEN ASSIGN pFieldValue = RowObject.cod-formul-trib.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-memo-calc-base":U THEN ASSIGN pFieldValue = RowObject.cod-memo-calc-base.
        WHEN "cod-memo-calc-trib":U THEN ASSIGN pFieldValue = RowObject.cod-memo-calc-trib.
        WHEN "cod-sit-tributar":U THEN ASSIGN pFieldValue = RowObject.cod-sit-tributar.
        WHEN "cod-tip-trib":U THEN ASSIGN pFieldValue = RowObject.cod-tip-trib.
        WHEN "cod-usuar-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-atualiz.
        WHEN "hra-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.hra-ult-atualiz.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nat-operacao-ac":U THEN ASSIGN pFieldValue = RowObject.nat-operacao-ac.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "nro-docto-ac":U THEN ASSIGN pFieldValue = RowObject.nro-docto-ac.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "serie-docto-ac":U THEN ASSIGN pFieldValue = RowObject.serie-docto-ac.
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
        WHEN "dat-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.dat-ult-atualiz.
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
        WHEN "val-aliq":U THEN ASSIGN pFieldValue = RowObject.val-aliq.
        WHEN "val-base":U THEN ASSIGN pFieldValue = RowObject.val-base.
        WHEN "val-fix-trib":U THEN ASSIGN pFieldValue = RowObject.val-fix-trib.
        WHEN "val-perc-reduc":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc.
        WHEN "val-quant-fix":U THEN ASSIGN pFieldValue = RowObject.val-quant-fix.
        WHEN "val-trib":U THEN ASSIGN pFieldValue = RowObject.val-trib.
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
        WHEN "cdn-msg-faturam":U THEN ASSIGN pFieldValue = RowObject.cdn-msg-faturam.
        WHEN "cdn-msg-of":U THEN ASSIGN pFieldValue = RowObject.cdn-msg-of.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-emitente-ac":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-ac.
        WHEN "idi-cod-tributac":U THEN ASSIGN pFieldValue = RowObject.idi-cod-tributac.
        WHEN "num-ct-trib":U THEN ASSIGN pFieldValue = RowObject.num-ct-trib.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-cenario
  Parameters:  
               retorna valor do campo cod-emitente
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo nat-operacao
               retorna valor do campo cod-emitente-ac
               retorna valor do campo serie-docto-ac
               retorna valor do campo nro-docto-ac
               retorna valor do campo nat-operacao-ac
               retorna valor do campo num-seq
               retorna valor do campo num-ct-trib
               retorna valor do campo cod-tip-trib
               retorna valor do campo cod-configur-trib
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE ct-trib-despesa-aces.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie-docto LIKE ct-trib-despesa-aces.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE ct-trib-despesa-aces.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE ct-trib-despesa-aces.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-ac LIKE ct-trib-despesa-aces.cod-emitente-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie-docto-ac LIKE ct-trib-despesa-aces.serie-docto-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto-ac LIKE ct-trib-despesa-aces.nro-docto-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao-ac LIKE ct-trib-despesa-aces.nat-operacao-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE ct-trib-despesa-aces.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-ct-trib LIKE ct-trib-despesa-aces.num-ct-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-trib LIKE ct-trib-despesa-aces.cod-tip-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-configur-trib LIKE ct-trib-despesa-aces.cod-configur-trib NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente
           pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pnat-operacao = RowObject.nat-operacao
           pcod-emitente-ac = RowObject.cod-emitente-ac
           pserie-docto-ac = RowObject.serie-docto-ac
           pnro-docto-ac = RowObject.nro-docto-ac
           pnat-operacao-ac = RowObject.nat-operacao-ac
           pnum-seq = RowObject.num-seq
           pnum-ct-trib = RowObject.num-ct-trib
           pcod-tip-trib = RowObject.cod-tip-trib
           pcod-configur-trib = RowObject.cod-configur-trib.

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
  Purpose:     Reposiciona registro com base no °ndice ch-cenario
  Parameters:  
               recebe valor do campo cod-emitente
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo nat-operacao
               recebe valor do campo cod-emitente-ac
               recebe valor do campo serie-docto-ac
               recebe valor do campo nro-docto-ac
               recebe valor do campo nat-operacao-ac
               recebe valor do campo num-seq
               recebe valor do campo num-ct-trib
               recebe valor do campo cod-tip-trib
               recebe valor do campo cod-configur-trib
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE ct-trib-despesa-aces.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pserie-docto LIKE ct-trib-despesa-aces.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE ct-trib-despesa-aces.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE ct-trib-despesa-aces.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-ac LIKE ct-trib-despesa-aces.cod-emitente-ac NO-UNDO.
    DEFINE INPUT PARAMETER pserie-docto-ac LIKE ct-trib-despesa-aces.serie-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto-ac LIKE ct-trib-despesa-aces.nro-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao-ac LIKE ct-trib-despesa-aces.nat-operacao-ac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE ct-trib-despesa-aces.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pnum-ct-trib LIKE ct-trib-despesa-aces.num-ct-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-trib LIKE ct-trib-despesa-aces.cod-tip-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-configur-trib LIKE ct-trib-despesa-aces.cod-configur-trib NO-UNDO.

    FIND FIRST bfct-trib-despesa-aces WHERE 
        bfct-trib-despesa-aces.cod-emitente = pcod-emitente AND 
        bfct-trib-despesa-aces.serie-docto = pserie-docto AND 
        bfct-trib-despesa-aces.nro-docto = pnro-docto AND 
        bfct-trib-despesa-aces.nat-operacao = pnat-operacao AND 
        bfct-trib-despesa-aces.cod-emitente-ac = pcod-emitente-ac AND 
        bfct-trib-despesa-aces.serie-docto-ac = pserie-docto-ac AND 
        bfct-trib-despesa-aces.nro-docto-ac = pnro-docto-ac AND 
        bfct-trib-despesa-aces.nat-operacao-ac = pnat-operacao-ac AND 
        bfct-trib-despesa-aces.num-seq = pnum-seq AND 
        bfct-trib-despesa-aces.num-ct-trib = pnum-ct-trib AND 
        bfct-trib-despesa-aces.cod-tip-trib = pcod-tip-trib AND 
        bfct-trib-despesa-aces.cod-configur-trib = pcod-configur-trib NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfct-trib-despesa-aces THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfct-trib-despesa-aces)).
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

