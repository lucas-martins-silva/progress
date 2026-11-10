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
{include/i-prgvrs.i BOIN060 2.00.00.008 } /*** "010008" 06/12/2024 10:39:03 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN060 MUT}
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
&GLOBAL-DEFINE DBOName      BOIN060
&GLOBAL-DEFINE DBOVersion   1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName    consist-nota
&GLOBAL-DEFINE TableLabel   Consistàncias da Nota
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin060.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--Definiá∆o variavÇis usadas nas procedures--*/
def var c-nro-docto    as char no-undo.
def var c-serie-docto  as char no-undo.
def var c-nat-operacao as char no-undo.
def var i-cod-emitente as int  no-undo.
def var c-complemento  as char no-undo.

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
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumEst DBOProgram 
PROCEDURE findDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.
    def input param piSerieDocto    like docum-est.serie-docto  no-undo.
    def input param piNroDocto      like docum-est.nro-docto    no-undo.
    def input param piNatOperacao   like docum-est.nat-operacao no-undo.
    
    if  not avail docum-est
    or  docum-est.cod-emitente <> piCodEmitente
    or  docum-est.serie-docto  <> piSerieDocto
    or  docum-est.nro-docto    <> piNroDocto
    or  docum-est.nat-operacao <> piNatOperacao then 
    
        for first docum-est
            where docum-est.cod-emitente = piCodEmitente
              and docum-est.serie-docto  = piSerieDocto
              and docum-est.nro-docto    = piNroDocto
              and docum-est.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind docum-est 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemDocEst DBOProgram 
PROCEDURE findItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like item-doc-est.cod-emitente no-undo.
    def input param piSerieDocto    like item-doc-est.serie-docto  no-undo.
    def input param piNroDocto      like item-doc-est.nro-docto    no-undo.
    def input param piNatOperacao   like item-doc-est.nat-operacao no-undo.
    def input param piSequencia     like item-doc-est.sequencia    no-undo.
    
    if  not avail item-doc-est
    or  item-doc-est.cod-emitente <> piCodEmitente
    or  item-doc-est.serie-docto  <> piSerieDocto
    or  item-doc-est.nro-docto    <> piNroDocto
    or  item-doc-est.nat-operacao <> piNatOperacao 
    or  item-doc-est.sequencia    <> piSequencia then 
    
        for first item-doc-est
            fields ( )
            where item-doc-est.cod-emitente = piCodEmitente
              and item-doc-est.serie-docto  = piSerieDocto
              and item-doc-est.nro-docto    = piNroDocto
              and item-doc-est.nat-operacao = piNatOperacao
              and item-doc-est.sequencia    = piSequencia  no-lock.
        end.
        
    if  not avail item-doc-est then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind item-doc-est 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "calculado":U THEN ASSIGN pFieldValue = RowObject.calculado.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "informado":U THEN ASSIGN pFieldValue = RowObject.informado.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mensagem":U THEN ASSIGN pFieldValue = RowObject.mensagem.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
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
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE consist-nota.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE consist-nota.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE consist-nota.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE consist-nota.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo LIKE consist-nota.tipo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           ptipo = RowObject.tipo.

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
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE consist-nota.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE consist-nota.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE consist-nota.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE consist-nota.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER ptipo LIKE consist-nota.tipo NO-UNDO.

    FIND FIRST bfconsist-nota WHERE 
        bfconsist-nota.serie-docto = pserie-docto AND 
        bfconsist-nota.nro-docto = pnro-docto AND 
        bfconsist-nota.cod-emitente = pcod-emitente AND 
        bfconsist-nota.nat-operacao = pnat-operacao AND 
        bfconsist-nota.tipo = ptipo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconsist-nota THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconsist-nota)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateConsistNota DBOProgram 
PROCEDURE updateConsistNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.
    def input param piSerieDocto    like docum-est.serie-docto  no-undo.
    def input param piNroDocto      like docum-est.nro-docto    no-undo.
    def input param piNatOperacao   like docum-est.nat-operacao no-undo.
    def input param piSequencia     like item-doc-est.sequencia no-undo.
    def input param piElimina       as   logical                no-undo.
    def input param piCalculado     like consist-nota.calculado no-undo.
    def input param piInformado     like consist-nota.informado no-undo.
    def input param piMensagem      like consist-nota.mensagem  no-undo.
    def input param piErroAdv       like consist-nota.tipo      no-undo.
    
    def var r-rowid as rowid no-undo.

    run findDocumEst ( input piCodEmitente,
                       input piSerieDocto,
                       input piNroDocto,
                       input piNatOperacao ).

    if  return-value <> "OK":U then 
        return "NOK":U.
        
    find first bfConsist-nota
        where bfConsist-nota.cod-emitente = piCodEmitente
          and bfConsist-nota.serie-docto  = piSerieDocto
          and bfConsist-nota.nro-docto    = piNroDocto
          and bfConsist-nota.nat-operacao = piNatOperacao 
          and bfConsist-nota.mensagem     = piMensagem
          and bfConsist-nota.int-1        = piSequencia 
        NO-LOCK no-error.
    
    if  avail bfConsist-nota then
        ASSIGN r-rowid = ROWID(bfConsist-nota). 

    IF  r-rowid <> ? THEN
        FIND FIRST bfConsist-nota
             where rowid(bfConsist-nota) = r-rowid EXCLUSIVE-LOCK NO-ERROR.

    if  piElimina = yes then do:
        
        if  avail bfConsist-nota then 
            delete bfConsist-nota.
    end.
    else do:
    
        if  not avail bfConsist-nota then do:
            create bfConsist-nota.
            assign bfConsist-nota.cod-emitente  = piCodEmitente
                   bfConsist-nota.serie-docto   = piSerieDocto
                   bfConsist-nota.nro-docto     = piNroDocto
                   bfConsist-nota.nat-operacao  = piNatOperacao
                   bfConsist-nota.mensagem      = piMensagem
                   bfConsist-nota.int-1         = piSequencia. 
        end.                   

        assign bfConsist-nota.tipo          = piErroAdv
               bfConsist-nota.calculado     = piCalculado
               bfConsist-nota.informado     = piInformado
               bfConsist-nota.log-1         = no.

        RELEASE bfConsist-nota.

    end.
    
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
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryToDocumEst DBOProgram 
PROCEDURE openQueryToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                     {&TableName}.nro-docto    = c-nro-docto    AND
                                     {&TableName}.serie-docto  = c-serie-docto  AND
                                     {&TableName}.nat-operacao = c-nat-operacao AND 
                                     {&TableName}.cod-emitente = i-cod-emitente 
                                     NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintToDocumEst DBOProgram 
PROCEDURE setConstraintToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

def input param pc-nro-docto    as char no-undo.
def input param pc-serie-docto  as char no-undo.
def input param pc-nat-operacao as char no-undo.
def input param pi-cod-emitente as int  no-undo.

    assign c-nro-docto    = pc-nro-docto
           c-serie-docto  = pc-serie-docto 
           c-nat-operacao = pc-nat-operacao
           i-cod-emitente = pi-cod-emitente.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaComplMensagem DBOProgram 
PROCEDURE retornaComplMensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

def input  param pr-consist-nota as rowid no-undo.
def output param pc-complemento  as char  no-undo.

  IF  NOT AVAIL consist-nota 
  OR  AVAIL consist-nota AND ROWID(consist-nota) <> pr-consist-nota THEN 
      FIND consist-nota WHERE 
           ROWID(consist-nota) = pr-consist-nota NO-LOCK NO-ERROR.

  IF AVAIL consist-nota THEN DO:
    
    CASE consist-nota.mensagem:
        WHEN 5526 THEN do:
            FOR FIRST item-doc-est FIELDS(sequencia it-codigo)
                      {cdp/cd8900.i consist-nota item-doc-est}
                  AND item-doc-est.sequencia = consist-nota.int-1 NO-LOCK: END.
            if avail item-doc-est then 
                assign c-complemento = string(item-doc-est.sequencia) + " ~~ " +
                                       string(item-doc-est.it-codigo).
            else 
                assign c-complemento = "".                                                      
        end.
        WHEN 5527 THEN do:
            FOR FIRST item-doc-est FIELDS(sequencia it-codigo)
                      {cdp/cd8900.i consist-nota item-doc-est}
                  AND item-doc-est.sequencia = consist-nota.int-1 NO-LOCK: END.
            if avail item-doc-est then 
                assign c-complemento = string(item-doc-est.sequencia) + " ~~ " +
                                       string(item-doc-est.it-codigo).
            else 
                assign c-complemento = "".                                                      
        end.
        WHEN 5528 THEN do:
            FOR FIRST item-doc-est FIELDS(sequencia it-codigo)
                      {cdp/cd8900.i consist-nota item-doc-est}
                  AND item-doc-est.sequencia = consist-nota.int-1 NO-LOCK: END.
            if avail item-doc-est then 
                assign c-complemento = string(item-doc-est.sequencia) + " ~~ " +
                                       string(item-doc-est.it-codigo).
            else 
                assign c-complemento = "".                                                      
        end.
        WHEN 5529 THEN do:
            FOR FIRST item-doc-est FIELDS(sequencia it-codigo)
                      {cdp/cd8900.i consist-nota item-doc-est}
                  AND item-doc-est.sequencia = consist-nota.int-1 NO-LOCK: END.
            if avail item-doc-est then 
                assign c-complemento = string(item-doc-est.sequencia) + " ~~ " +
                                       string(item-doc-est.it-codigo).
            else 
                assign c-complemento = "".                                                      
        end.
        OTHERWISE 
            assign c-complemento = "".
    END CASE.
  
    run utp/ut-msgs.p (input "msg",
                       input consist-nota.mensagem,
                       input c-complemento).
 
    assign pc-complemento = return-value.
  
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

