&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOCX00475 2.00.00.001 } /*** "010001" 11/12/2023 10:13:21 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00475
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-export-ctbz-ifrs
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
{cxbo/bocx00475.i RowObject}


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
        WHEN "cod-cc-movto":U THEN ASSIGN pFieldValue = RowObject.cod-cc-movto.
        WHEN "cod-ct-movto":U THEN ASSIGN pFieldValue = RowObject.cod-ct-movto.
        WHEN "cod-cta-movto":U THEN ASSIGN pFieldValue = RowObject.cod-cta-movto.
        WHEN "cod-estab-faturam":U THEN ASSIGN pFieldValue = RowObject.cod-estab-faturam.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc.
        WHEN "cod-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-proces-export.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "hra-movto":U THEN ASSIGN pFieldValue = RowObject.hra-movto.
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
        WHEN "dat-movto":U THEN ASSIGN pFieldValue = RowObject.dat-movto.
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
        WHEN "val-movto":U THEN ASSIGN pFieldValue = RowObject.val-movto.
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
        WHEN "idi-modul-orig":U THEN ASSIGN pFieldValue = RowObject.idi-modul-orig.
        WHEN "idi-tip-impto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-impto.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-lote-ctbl":U THEN ASSIGN pFieldValue = RowObject.num-lote-ctbl.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcxprtc_id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-proces-export
               retorna valor do campo dat-movto
               retorna valor do campo cod-ct-movto
               retorna valor do campo cod-cc-movto
               retorna valor do campo cod-estab-faturam
               retorna valor do campo cod-serie
               retorna valor do campo cod-nota-fisc
               retorna valor do campo idi-tip-impto
               retorna valor do campo cod-unid-negoc
               retorna valor do campo idi-modul-orig
               retorna valor do campo num-lote-ctbl
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-export-ctbz-ifrs.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-proces-export LIKE proc-export-ctbz-ifrs.cod-proces-export NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-movto LIKE proc-export-ctbz-ifrs.dat-movto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ct-movto LIKE proc-export-ctbz-ifrs.cod-ct-movto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cc-movto LIKE proc-export-ctbz-ifrs.cod-cc-movto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab-faturam LIKE proc-export-ctbz-ifrs.cod-estab-faturam NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serie LIKE proc-export-ctbz-ifrs.cod-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-nota-fisc LIKE proc-export-ctbz-ifrs.cod-nota-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-impto LIKE proc-export-ctbz-ifrs.idi-tip-impto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-unid-negoc LIKE proc-export-ctbz-ifrs.cod-unid-negoc NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-modul-orig LIKE proc-export-ctbz-ifrs.idi-modul-orig NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-lote-ctbl LIKE proc-export-ctbz-ifrs.num-lote-ctbl NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-proces-export = RowObject.cod-proces-export
           pdat-movto = RowObject.dat-movto
           pcod-ct-movto = RowObject.cod-ct-movto
           pcod-cc-movto = RowObject.cod-cc-movto
           pcod-estab-faturam = RowObject.cod-estab-faturam
           pcod-serie = RowObject.cod-serie
           pcod-nota-fisc = RowObject.cod-nota-fisc
           pidi-tip-impto = RowObject.idi-tip-impto
           pcod-unid-negoc = RowObject.cod-unid-negoc
           pidi-modul-orig = RowObject.idi-modul-orig
           pnum-lote-ctbl = RowObject.num-lote-ctbl.

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
  Purpose:     Reposiciona registro com base no °ndice prcxprtc_id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-proces-export
               recebe valor do campo dat-movto
               recebe valor do campo cod-ct-movto
               recebe valor do campo cod-cc-movto
               recebe valor do campo cod-estab-faturam
               recebe valor do campo cod-serie
               recebe valor do campo cod-nota-fisc
               recebe valor do campo idi-tip-impto
               recebe valor do campo cod-unid-negoc
               recebe valor do campo idi-modul-orig
               recebe valor do campo num-lote-ctbl
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-export-ctbz-ifrs.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-proces-export LIKE proc-export-ctbz-ifrs.cod-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER pdat-movto LIKE proc-export-ctbz-ifrs.dat-movto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ct-movto LIKE proc-export-ctbz-ifrs.cod-ct-movto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cc-movto LIKE proc-export-ctbz-ifrs.cod-cc-movto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-faturam LIKE proc-export-ctbz-ifrs.cod-estab-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie LIKE proc-export-ctbz-ifrs.cod-serie NO-UNDO.
    DEFINE INPUT PARAMETER pcod-nota-fisc LIKE proc-export-ctbz-ifrs.cod-nota-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-impto LIKE proc-export-ctbz-ifrs.idi-tip-impto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-unid-negoc LIKE proc-export-ctbz-ifrs.cod-unid-negoc NO-UNDO.
    DEFINE INPUT PARAMETER pidi-modul-orig LIKE proc-export-ctbz-ifrs.idi-modul-orig NO-UNDO.
    DEFINE INPUT PARAMETER pnum-lote-ctbl LIKE proc-export-ctbz-ifrs.num-lote-ctbl NO-UNDO.

    FIND FIRST bfproc-export-ctbz-ifrs WHERE 
        bfproc-export-ctbz-ifrs.cod-estabel = pcod-estabel AND 
        bfproc-export-ctbz-ifrs.cod-proces-export = pcod-proces-export AND 
        bfproc-export-ctbz-ifrs.dat-movto = pdat-movto AND 
        bfproc-export-ctbz-ifrs.cod-ct-movto = pcod-ct-movto AND 
        bfproc-export-ctbz-ifrs.cod-cc-movto = pcod-cc-movto AND 
        bfproc-export-ctbz-ifrs.cod-estab-faturam = pcod-estab-faturam AND 
        bfproc-export-ctbz-ifrs.cod-serie = pcod-serie AND 
        bfproc-export-ctbz-ifrs.cod-nota-fisc = pcod-nota-fisc AND 
        bfproc-export-ctbz-ifrs.idi-tip-impto = pidi-tip-impto AND 
        bfproc-export-ctbz-ifrs.cod-unid-negoc = pcod-unid-negoc AND 
        bfproc-export-ctbz-ifrs.idi-modul-orig = pidi-modul-orig AND 
        bfproc-export-ctbz-ifrs.num-lote-ctbl = pnum-lote-ctbl NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-export-ctbz-ifrs THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-export-ctbz-ifrs)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

