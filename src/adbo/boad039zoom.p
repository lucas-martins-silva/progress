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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD039
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cond-pagto
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-cond-pag /*:T Informar os campos da chave quando o Progress n o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m˝todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

{cdp/cdcfgdis.i}

{adbo/boad039zoom.i RowObject}


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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
        WHEN "dat-vencto-fix":U THEN ASSIGN pFieldValue = RowObject.dat-vencto-fix.
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
        WHEN "per-des-pgan":U THEN ASSIGN pFieldValue = RowObject.per-des-pgan.
        WHEN "per-pg-dup[1]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[1].
        WHEN "per-pg-dup[2]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[2].
        WHEN "per-pg-dup[3]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[3].
        WHEN "per-pg-dup[4]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[4].
        WHEN "per-pg-dup[5]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[5].
        WHEN "per-pg-dup[6]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[6].
        WHEN "per-pg-dup[7]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[7].
        WHEN "per-pg-dup[8]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[8].
        WHEN "per-pg-dup[9]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[9].
        WHEN "per-pg-dup[10]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[10].
        WHEN "per-pg-dup[11]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[11].
        WHEN "per-pg-dup[12]":U THEN ASSIGN pFieldValue = RowObject.per-pg-dup[12].
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
        WHEN "ano-base":U THEN ASSIGN pFieldValue = RowObject.ano-base.
        WHEN "cdn-motiv-reprovac-cr":U THEN ASSIGN pFieldValue = RowObject.cdn-motiv-reprovac-cr.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-ven-par[1]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[1].
        WHEN "cod-ven-par[2]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[2].
        WHEN "cod-ven-par[3]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[3].
        WHEN "cod-ven-par[4]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[4].
        WHEN "cod-ven-par[5]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[5].
        WHEN "cod-ven-par[6]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[6].
        WHEN "cod-ven-par[7]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[7].
        WHEN "cod-ven-par[8]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[8].
        WHEN "cod-ven-par[9]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[9].
        WHEN "cod-ven-par[10]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[10].
        WHEN "cod-ven-par[11]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[11].
        WHEN "cod-ven-par[12]":U THEN ASSIGN pFieldValue = RowObject.cod-ven-par[12].
        WHEN "cod-vencto":U THEN ASSIGN pFieldValue = RowObject.cod-vencto.
        WHEN "dia-mes-base":U THEN ASSIGN pFieldValue = RowObject.dia-mes-base.
        WHEN "dia-mes-venc":U THEN ASSIGN pFieldValue = RowObject.dia-mes-venc.
        WHEN "dia-sem-base":U THEN ASSIGN pFieldValue = RowObject.dia-sem-base.
        WHEN "dia-sem-venc":U THEN ASSIGN pFieldValue = RowObject.dia-sem-venc.
        WHEN "idi-forma-avaliac-cr":U THEN ASSIGN pFieldValue = RowObject.idi-forma-avaliac-cr.
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mes-base":U THEN ASSIGN pFieldValue = RowObject.mes-base.
        WHEN "nr-dias-ante":U THEN ASSIGN pFieldValue = RowObject.nr-dias-ante.
        WHEN "nr-dupdes":U THEN ASSIGN pFieldValue = RowObject.nr-dupdes.
        WHEN "nr-ind-finan":U THEN ASSIGN pFieldValue = RowObject.nr-ind-finan.
        WHEN "nr-tab-finan":U THEN ASSIGN pFieldValue = RowObject.nr-tab-finan.
        WHEN "num-parcelas":U THEN ASSIGN pFieldValue = RowObject.num-parcelas.
        WHEN "prazos[1]":U THEN ASSIGN pFieldValue = RowObject.prazos[1].
        WHEN "prazos[2]":U THEN ASSIGN pFieldValue = RowObject.prazos[2].
        WHEN "prazos[3]":U THEN ASSIGN pFieldValue = RowObject.prazos[3].
        WHEN "prazos[4]":U THEN ASSIGN pFieldValue = RowObject.prazos[4].
        WHEN "prazos[5]":U THEN ASSIGN pFieldValue = RowObject.prazos[5].
        WHEN "prazos[6]":U THEN ASSIGN pFieldValue = RowObject.prazos[6].
        WHEN "prazos[7]":U THEN ASSIGN pFieldValue = RowObject.prazos[7].
        WHEN "prazos[8]":U THEN ASSIGN pFieldValue = RowObject.prazos[8].
        WHEN "prazos[9]":U THEN ASSIGN pFieldValue = RowObject.prazos[9].
        WHEN "prazos[10]":U THEN ASSIGN pFieldValue = RowObject.prazos[10].
        WHEN "prazos[11]":U THEN ASSIGN pFieldValue = RowObject.prazos[11].
        WHEN "prazos[12]":U THEN ASSIGN pFieldValue = RowObject.prazos[12].
        WHEN "qtd-dias-prazo-medio":U THEN ASSIGN pFieldValue = RowObject.qtd-dias-prazo-medio.
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
               retorna valor do campo cod-cond-pag
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-cond-pag LIKE cond-pagto.cod-cond-pag NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cond-pag = RowObject.cod-cond-pag.

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
        WHEN "log-atual-idx":U THEN ASSIGN pFieldValue = RowObject.log-atual-idx.
        WHEN "log-dat-fix":U THEN ASSIGN pFieldValue = RowObject.log-dat-fix.
        WHEN "log-reprovac-autom":U THEN ASSIGN pFieldValue = RowObject.log-reprovac-autom.
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
               recebe valor do campo cod-cond-pag
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-cond-pag LIKE cond-pagto.cod-cond-pag NO-UNDO.

    FIND FIRST bfcond-pagto WHERE 
        bfcond-pagto.cod-cond-pag = pcod-cond-pag NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcond-pagto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcond-pagto)).
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

