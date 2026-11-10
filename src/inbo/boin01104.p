{include/i-prgvrs.i BOIN01104 2.00.00.006 } /*** "010006" 13/11/2023 11:45:46 ***/
{include/i-license-manager.i boin01104 MRE}

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
&GLOBAL-DEFINE DBOName BOIN01104
&GLOBAL-DEFINE DBOVersion 2.00.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est-transp
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
{inbo/boin01104.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}    FOR {&TableName}.
DEFINE BUFFER bfBuscaSeq        FOR {&TableName}.

/* Local Variable Definitions */
def var i-cod-emitente  as int   no-undo.
def var c-serie-docto   as char  no-undo.
def var c-nro-docto     as char  no-undo.
def var c-nat-operacao  as char  no-undo.

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
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-estab-relac":U THEN ASSIGN pFieldValue = RowObject.cod-estab-relac.
        WHEN "cod-natur-operac-relac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac-relac.
        WHEN "cod-num-docto-relac":U THEN ASSIGN pFieldValue = RowObject.cod-num-docto-relac.
        WHEN "cod-ser-docto-relac":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto-relac.
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
        WHEN "cdn-emit-relac":U THEN ASSIGN pFieldValue = RowObject.cdn-emit-relac.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-tip-nf":U THEN ASSIGN pFieldValue = RowObject.idi-tip-nf.
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
  Purpose:     Retorna valores dos campos do °ndice id_unico
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE docum-est-transp.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE docum-est-transp.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE docum-est-transp.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE docum-est-transp.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE docum-est-transp.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pnum-seq = RowObject.num-seq.

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
  Purpose:     Reposiciona registro com base no °ndice id_unico
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docum-est-transp.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docum-est-transp.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docum-est-transp.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docum-est-transp.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE docum-est-transp.num-seq NO-UNDO.

    FIND FIRST bfdocum-est-transp WHERE 
        bfdocum-est-transp.serie-docto = pserie-docto AND 
        bfdocum-est-transp.nro-docto = pnro-docto AND 
        bfdocum-est-transp.cod-emitente = pcod-emitente AND 
        bfdocum-est-transp.nat-operacao = pnat-operacao AND 
        bfdocum-est-transp.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est-transp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est-transp)).
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

    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock indexed-reposition.
       
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  like docum-est.cod-emitente no-undo.
    def input param c-ser-docto like docum-est.serie-docto  no-undo.
    def input param c-nr-docto  like docum-est.nro-docto    no-undo.
    def input param c-nat-oper  like docum-est.nat-operacao no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper.

    return "OK":U.

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

    IF pType = "CREATE" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}
                    WHERE bf{&TableName}.cod-emitente              = RowObject.cod-emitente             
                    AND   bf{&TableName}.serie-docto               = RowObject.serie-docto             
                    AND   bf{&TableName}.nro-docto                 = RowObject.nro-docto               
                    AND   bf{&TableName}.nat-operacao              = RowObject.nat-operacao            
                    AND   bf{&TableName}.cod-ser-docto-relac       = RowObject.cod-ser-docto-relac     
                    AND   bf{&TableName}.cod-num-docto-relac       = RowObject.cod-num-docto-relac     
                    AND   bf{&TableName}.cdn-emit-relac            = RowObject.cdn-emit-relac          
                    AND   bf{&TableName}.cod-natur-operac-relac    = RowObject.cod-natur-operac-relac  
                    AND   bf{&TableName}.cod-estab-relac           = RowObject.cod-estab-relac) THEN DO:
            DEFINE VARIABLE c-nota-fiscal AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_transportado" *}
            ASSIGN c-nota-fiscal = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-nota-fiscal"}
        END.
    END.

    IF pType <> "DELETE" THEN DO:
        /*VALIDACOES DO DOCUMENTO*/
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estab-relac) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                                &ErrorNumber="47"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST nota-fiscal 
                        WHERE nota-fiscal.cod-estabel   = RowObject.cod-estab-relac
                        AND   nota-fiscal.serie         = RowObject.cod-ser-docto-relac
                        AND   nota-fiscal.nr-nota-fis   = RowObject.cod-num-docto-relac) THEN DO:

            {utp/ut-liter.i Nota_Fiscal *}
            {method/svc/errors/inserr.i
                                &ErrorNumber="47"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
        ELSE DO:
            IF CAN-FIND(FIRST nota-fiscal 
                        WHERE nota-fiscal.cod-estabel   = RowObject.cod-estab-relac
                        AND   nota-fiscal.serie         = RowObject.cod-ser-docto-relac
                        AND   nota-fiscal.nr-nota-fis   = RowObject.cod-num-docto-relac
                        AND   nota-fiscal.ind-tip-nota  = 8) THEN DO:
                {method/svc/errors/inserr.i
                                &ErrorNumber="57246"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
            END.

        END.
    END.

    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaUltimaSeq DBOProgram 
PROCEDURE retornaNumSeqDisponivel :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param i-cod-emit  like docum-est.cod-emitente no-undo.
    def input param c-ser-docto like docum-est.serie-docto  no-undo.
    def input param c-nr-docto  like docum-est.nro-docto    no-undo.
    def input param c-nat-oper  like docum-est.nat-operacao no-undo.
    DEF OUTPUT PARAM i-num-seq  AS INTEGER INITIAL 1 NO-UNDO.

    FOR EACH bfBuscaSeq NO-LOCK
        WHERE bfBuscaSeq.cod-emitente = i-cod-emit 
        AND   bfBuscaSeq.serie-docto  = c-ser-docto
        AND   bfBuscaSeq.nro-docto    = c-nr-docto 
        AND   bfBuscaSeq.nat-operacao = c-nat-oper:

        IF NOT CAN-FIND(FIRST docum-est-transp 
                        WHERE docum-est-transp.cod-emitente = i-cod-emit 
                        AND   docum-est-transp.serie-docto  = c-ser-docto
                        AND   docum-est-transp.nro-docto    = c-nr-docto 
                        AND   docum-est-transp.nat-operacao = c-nat-oper
                        AND   docum-est-transp.num-seq = bfBuscaSeq.num-seq + 1) THEN DO:
            ASSIGN i-num-seq = bfBuscaSeq.num-seq + 1.
            LEAVE.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInfoDoctoRowErrors DBOProgram 
PROCEDURE setInfoDoctoRowErrors :
/*:T------------------------------------------------------------------------------
  Purpose:     Setar a chave do documento na RowErros, isso ajuda a identificar o documento com problema.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR lb-docto AS CHAR NO-UNDO.
    {utp/ut-liter.i "Docto"}
    ASSIGN lb-docto = " " + TRIM(RETURN-VALUE) + ": ".

    FIND FIRST RowObject NO-LOCK NO-ERROR.
    IF AVAIL RowObject THEN
        FOR EACH RowErrors:
            ASSIGN RowErrors.ErrorDescription = RowErrors.ErrorDescription + lb-docto + RowObject.cod-estab-relac + "|" + RowObject.cod-num-docto-relac + "|" + RowObject.cod-ser-docto-relac.
                   RowErrors.ErrorHelp = RowErrors.ErrorHelp + lb-docto + RowObject.cod-estab-relac + "|" + RowObject.cod-num-docto-relac + "|" + RowObject.cod-ser-docto-relac.
        END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
