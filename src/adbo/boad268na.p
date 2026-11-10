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
{include/i-prgvrs.i BOAD268NA 2.00.00.012 } /*** "010012" 07/10/2024 10:10:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD268NA MUT}
&ENDIF


/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD268
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName transporte
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES  
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 cod-transp /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad268na.i RowObject}

{java/boRest.i}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-transp-ini LIKE transporte.cod-transp NO-UNDO.
DEFINE VARIABLE c-cod-transp-fim LIKE transporte.cod-transp NO-UNDO.
DEFINE VARIABLE c-cgc-ini        LIKE transporte.cgc        NO-UNDO.
DEFINE VARIABLE c-cgc-fim        LIKE transporte.cgc        NO-UNDO.
DEFINE VARIABLE c-nome-abrev-ini LIKE transporte.nome-abrev NO-UNDO.
DEFINE VARIABLE c-nome-abrev-fim LIKE transporte.nome-abrev NO-UNDO.
DEFINE VARIABLE c-nome-ini       LIKE transporte.nome       NO-UNDO.
DEFINE VARIABLE c-nome-fim       LIKE transporte.nome       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "cx-postal":U THEN ASSIGN pFieldValue = RowObject.cx-postal.
      /*WHEN "des-ident-transp":U THEN ASSIGN pFieldValue = RowObject.des-ident-transp.*/
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "ramal":U THEN ASSIGN pFieldValue = RowObject.ramal.
        WHEN "ramal-fax":U THEN ASSIGN pFieldValue = RowObject.ramal-fax.
        WHEN "ramal-modem":U THEN ASSIGN pFieldValue = RowObject.ramal-modem.
        WHEN "telef-modem":U THEN ASSIGN pFieldValue = RowObject.telef-modem.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone":U THEN ASSIGN pFieldValue = RowObject.telefone.
        WHEN "telex":U THEN ASSIGN pFieldValue = RowObject.telex.
        WHEN "zip-code":U THEN ASSIGN pFieldValue = RowObject.zip-code.
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
      /*WHEN "dat-ult-alter":U THEN ASSIGN pFieldValue = RowObject.dat-ult-alter.*/ 
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
     /* WHEN "cdn-parcei-EDI":U THEN ASSIGN pFieldValue = RowObject.cdn-parcei-EDI.*/
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
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
               retorna valor do campo cod-transp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-transp LIKE transporte.cod-transp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-transp = RowObject.cod-transp.

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
     /* WHEN "log-EDI":U THEN ASSIGN pFieldValue = RowObject.log-EDI.*/
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeAbrev DBOProgram 
PROCEDURE getNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE transporte.nome-abrev NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeEmail DBOProgram 
PROCEDURE getNomeEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cod-transp LIKE transporte.cod-transp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome         LIKE transporte.nome       NO-UNDO.
    DEFINE OUTPUT PARAMETER pemail        LIKE cont-tran.e-mail      NO-UNDO.
    
    FOR FIRST bftransporte FIELDS(cod-transp nome) NO-LOCK
        WHERE bftransporte.cod-transp = pi-cod-transp: END.
        
    IF NOT AVAIL bftransporte THEN 
        RETURN "NOK":U.
        
    ASSIGN pnome = bftransporte.nome.
    
    FOR FIRST cont-tran FIELDS(e-mail) NO-LOCK 
        WHERE cont-tran.cod-transp = bftransporte.cod-transp:
         ASSIGN pemail = cont-tran.e-mail.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPessoaID DBOProgram 
PROCEDURE getPessoaID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cod-transp LIKE transporte.cod-transp   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcgc          LIKE transporte.cgc          NO-UNDO.
    DEFINE OUTPUT PARAMETER pins-estadual LIKE transporte.ins-estadual NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev   LIKE transporte.nome-abrev   NO-UNDO.
    DEFINE OUTPUT PARAMETER ptip-cadastro AS   int                     NO-UNDO.
    
    FOR FIRST bftransporte FIELDS(cod-transp cgc ins-estadual nome-abrev) NO-LOCK
        WHERE bftransporte.cod-transp = pi-cod-transp: END.
        
    IF AVAIL bftransporte THEN DO:
       ASSIGN pcgc          = bftransporte.cgc
              pins-estadual = bftransporte.ins-estadual
              pnome-abrev   = bftransporte.nome-abrev
              ptip-cadastro = 1. /* Transportador */
       RETURN "OK":U.
    END.

    FOR FIRST emitente FIELDS(cod-emitente cgc ins-estadual nome-abrev) NO-LOCK
        WHERE emitente.cod-emitente = pi-cod-transp: END.
        
    IF AVAIL emitente THEN DO:
       ASSIGN pcgc          = emitente.cgc
              pins-estadual = emitente.ins-estadual
              pnome-abrev   = emitente.nome-abrev
              ptip-cadastro = 2. /* Emitente */
       RETURN "OK":U.
    END.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCodByPessoa DBOProgram 
PROCEDURE getCodByPessoa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcgc          LIKE transporte.cgc          NO-UNDO.
    DEFINE INPUT  PARAMETER pins-estadual LIKE transporte.ins-estadual NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-transp LIKE transporte.cod-transp   NO-UNDO.
    DEFINE OUTPUT PARAMETER ptip-cadastro AS   int                     NO-UNDO.
    
    FOR FIRST bftransporte FIELDS(cod-transp cgc ins-estadual) NO-LOCK
        WHERE bftransporte.cgc          = pcgc
          AND bftransporte.ins-estadual = pins-estadual: END.
        
    IF AVAIL bftransporte THEN DO:
       ASSIGN pi-cod-transp = bftransporte.cod-transp
              ptip-cadastro = 1. /* Transportador */
       RETURN "OK":U.
    END.   
    
    FOR FIRST emitente FIELDS(cod-emitente cgc ins-estadual) NO-LOCK
        WHERE emitente.cgc          = pcgc
          AND emitente.ins-estadual = pins-estadual: END.
        
    IF AVAIL emitente THEN DO:
       ASSIGN pi-cod-transp = emitente.cod-emitente
              ptip-cadastro = 2. /* Emitente */
       RETURN "OK":U.
    END.   

    RETURN "NOK":U.

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCGC DBOProgram 
PROCEDURE goToCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pdes_cgc_transp LIKE transporte.cgc NO-UNDO.

    FIND FIRST bftransporte WHERE 
        bftransporte.cgc = pdes_cgc_transp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftransporte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftransporte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-transp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-transp LIKE transporte.cod-transp NO-UNDO.

    FIND FIRST bftransporte WHERE 
        bftransporte.cod-transp = pcod-transp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftransporte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftransporte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNomeAbrev DBOProgram 
PROCEDURE goToNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pnome-abrev LIKE transporte.nome-abrev NO-UNDO.

    FIND FIRST bftransporte WHERE 
        bftransporte.nome-abrev = pnome-abrev NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftransporte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftransporte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaCGC DBOProgram 
PROCEDURE openQueryFaixaCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cgc >= c-cgc-ini and
               {&TableName}.cgc <= c-cgc-fim
            by {&TableName}.cgc INDEXED-REPOSITION.
               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNome DBOProgram 
PROCEDURE openQueryFaixaNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.nome >= c-nome-ini and
               {&TableName}.nome <= c-nome-fim
               USE-INDEX nome BY nome BY nome-abrev.
               
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNomeAbrev DBOProgram 
PROCEDURE openQueryFaixaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.nome-abrev >= c-nome-abrev-ini and
               {&TableName}.nome-abrev <= c-nome-abrev-fim
            by {&TableName}.nome-abrev INDEXED-REPOSITION.
               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaTransporte DBOProgram 
PROCEDURE openQueryFaixaTransporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-transp >= c-cod-transp-ini and
               {&TableName}.cod-transp <= c-cod-transp-fim
            by {&TableName}.cod-transp INDEXED-REPOSITION.
               
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaCGC DBOProgram 
PROCEDURE setConstraintFaixaCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cgc-ini LIKE transporte.cgc NO-UNDO.
    DEFINE INPUT PARAM p-cgc-fim LIKE transporte.cgc NO-UNDO.
    
    ASSIGN c-cgc-ini = p-cgc-ini
           c-cgc-fim = p-cgc-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNome DBOProgram 
PROCEDURE setConstraintFaixaNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-nome-ini LIKE transporte.nome NO-UNDO.
    DEFINE INPUT PARAM p-nome-fim LIKE transporte.nome NO-UNDO.
    
    ASSIGN c-nome-ini = p-nome-ini
           c-nome-fim = p-nome-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNomeAbrev DBOProgram 
PROCEDURE setConstraintFaixaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-nome-abrev-ini LIKE transporte.nome-abrev NO-UNDO.
    DEFINE INPUT PARAM p-nome-abrev-fim LIKE transporte.nome-abrev NO-UNDO.
    
    ASSIGN c-nome-abrev-ini = p-nome-abrev-ini
           c-nome-abrev-fim = p-nome-abrev-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaTransporte DBOProgram 
PROCEDURE setConstraintFaixaTransporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-transp-ini LIKE transporte.cod-transp NO-UNDO.
    DEFINE INPUT PARAM p-cod-transp-fim LIKE transporte.cod-transp NO-UNDO.
    
    ASSIGN c-cod-transp-ini = p-cod-transp-ini
           c-cod-transp-fim = p-cod-transp-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE c-lbl-liter-mensagem AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST transporte WHERE 
            transporte.cod-transp = RowObject.cod-transp) THEN DO:
            
        {utp/ut-liter.i "Transportador" *}
        ASSIGN c-lbl-liter-mensagem = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i &ErrorNumber="7" 
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-mensagem"}  
    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindRecord DBOProgram 
PROCEDURE canFindRecord :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o Registro Existe com a Chave
  Parameters:  
               recebe valor do campo cod-transp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-transp   LIKE transporte.cod-transp NO-UNDO.
    DEFINE OUTPUT PARAMETER ptip-cadastro AS   int                   NO-UNDO.

    IF CAN-FIND(FIRST bftransporte WHERE 
                      bftransporte.cod-transp = pcod-transp NO-LOCK) THEN DO:
        ASSIGN ptip-cadastro = 1. /* Transportador */
        RETURN "NOK":U.
    END.

    IF CAN-FIND(FIRST emitente WHERE 
                      emitente.cod-emitente = pcod-transp NO-LOCK) THEN DO:
        ASSIGN ptip-cadastro = 2. /* Emitente */
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


