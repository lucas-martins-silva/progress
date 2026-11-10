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
{include/i-prgvrs.i BOIN761 2.00.00.008 } /*** "010008" 17/06/2025 16:40:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin761 MUT}
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
&GLOBAL-DEFINE DBOName BOIN761
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName campo-lote-pregao
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
{inbo/boin761.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf1{&TableName} FOR {&TableName}.

/* Vari†veis da setConstraintcodLotePregao */
DEFINE VARIABLE codtiplote-ini-0001 AS INTEGER NO-UNDO.
DEFINE VARIABLE codtiplote-fim-0002 AS INTEGER NO-UNDO.
DEFINE VARIABLE codCampoLote-ini-0003 AS CHARACTER NO-UNDO.
DEFINE VARIABLE codCampoLote-fim-0004 AS CHARACTER NO-UNDO.
/* Vari†veis da setConstraintdescTipLote */
DEFINE VARIABLE descCampoLote-ini-0001 AS CHARACTER NO-UNDO.
DEFINE VARIABLE desCampoLote-fim-0002 AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-cdn-tip-lote  AS INT NO-UNDO.

/*Include passando boin761.p*/
{include/i-epc200.i boin761}

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
         HEIGHT             = 21.83
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
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-campo":U THEN ASSIGN pFieldValue = RowObject.des-campo.
        WHEN "dsl-conteudo":U THEN ASSIGN pFieldValue = RowObject.dsl-conteudo.
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
        WHEN "cdn-tip-dado":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-dado.
        WHEN "cdn-tip-lote-pregao":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-lote-pregao.
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
  Purpose:     Retorna valores dos campos do °ndice emp-unico
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-tip-lote-pregao LIKE campo-lote-pregao.cdn-tip-lote-pregao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE campo-lote-pregao.cod-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-tip-lote-pregao = RowObject.cdn-tip-lote-pregao
           pcod-campo = RowObject.cod-campo.

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
        WHEN "log-campo-obrig":U THEN ASSIGN pFieldValue = RowObject.log-campo-obrig.
        WHEN "log-envia-pregao":U THEN ASSIGN pFieldValue = RowObject.log-envia-pregao.
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
  Purpose:     Reposiciona registro com base no °ndice emp-unico
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-tip-lote-pregao LIKE campo-lote-pregao.cdn-tip-lote-pregao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo LIKE campo-lote-pregao.cod-campo NO-UNDO.

    FIND FIRST bfcampo-lote-pregao WHERE
        bfcampo-lote-pregao.cdn-tip-lote-pregao = pcdn-tip-lote-pregao AND
        bfcampo-lote-pregao.cod-campo = pcod-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE campo-lote-pregao THEN
        RETURN 'NOK':U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcampo-lote-pregao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linktoCampoLote DBOProgram 
PROCEDURE linktoCampoLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param h-campo-lote as handle no-undo.

    RUN GetKey in h-campo-lote (output i-cdn-tip-lote).

    RUN setConstraintByTipLote IN THIS-PROCEDURE (INPUT i-cdn-tip-lote).
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByTipLote DBOProgram 
PROCEDURE openQueryByTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} 
    FOR EACH {&TableName}
       WHERE {&TableName}.cdn-tip-lote-pregao  = i-cdn-tip-lote NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerycodLotePregao DBOProgram 
PROCEDURE openQuerycodLotePregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK
        WHERE campo-lote-pregao.cdn-tip-lote-pregao >= codtiplote-ini-0001
        AND   campo-lote-pregao.cdn-tip-lote-pregao <= codtiplote-fim-0002
        AND   campo-lote-pregao.cod-campo >= codCampoLote-ini-0003
        AND   campo-lote-pregao.cod-campo <= codCampoLote-fim-0004
        BY campo-lote-pregao.cdn-tip-lote-pregao
        BY campo-lote-pregao.cod-campo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerydescTipLote DBOProgram 
PROCEDURE openQuerydescTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK
        WHERE campo-lote-pregao.des-campo >= descCampoLote-ini-0001
        AND   campo-lote-pregao.des-campo <= desCampoLote-fim-0002
        BY campo-lote-pregao.des-campo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName}.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-campos-variaveis DBOProgram 
PROCEDURE pi-campos-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  parameter i-opcao          as integer format ">9"      no-undo.
DEFINE INPUT  parameter c-campo-variavel as char    format "x(100)"  no-undo.
DEFINE OUTPUT parameter c-conteudo       as char    format "x(2000)" no-undo.
               
    if i-opcao = 1 then do:
        assign c-conteudo = "".
        if c-conteudo = "" then
            assign c-conteudo = "&DATA-ATUAL - Data Atual" + "," + 
                                "&HORA-ATUAL - Hora Atual" + "," + 
                                "&CODIGO-ITEM - C¢digo do item da ordem de compra" + "," + 
                                "&DESCRICAO-ITEM - Descriá∆o do item da ordem de compra" + "," +
                                "&NUMERO-ORDEM - N£mero da ordem de compra" + "," +                                                                                                                    
                                "&NR-PROCESSO-COMPRA - N£mero do processo de compra" + "," +
                                "&NARRAT-ORDEM-COMPRA - Narrativa da ordem de compra" + "," +                             
                                "&PRECO-REPOSICAO - Preáo de reposiá∆o do item" + "," +
                                "&PRTOTAL-REPOSICAO - Preáo de reposiá∆o multiplicado pela quantidade total da ordem de compra".
    END.
        
    /*chamada upc*/
    for each tt-epc
        where tt-epc.cod-event = "pi-campos-variaveis":
        delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "pi-campos-variaveis"
           tt-epc.cod-parameter = "pi-campos-variaveis-opcao"
           tt-epc.val-parameter = string(i-opcao).
    
    create tt-epc.
    assign tt-epc.cod-event     = "pi-campos-variaveis"
           tt-epc.cod-parameter = "pi-campos-variaveis-campo"
           tt-epc.val-parameter = c-campo-variavel.
    
    create tt-epc.
    assign tt-epc.cod-event     = "pi-campos-variaveis"
           tt-epc.cod-parameter = "pi-campos-variaveis-conteudo"
           tt-epc.val-parameter = c-conteudo.
    
    {include/i-epc201.i "pi-campos-variaveis"}
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-campos-bbm DBOProgram 
PROCEDURE pi-gera-campos-bbm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {inbo/boin761.i10}

    IF CAN-FIND(FIRST rowErrors
                WHERE RowErrors.errorSubType = "ERROR":U) THEN DO:
        RETURN NO-APPLY.
    END. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-procura-campos-bbm DBOProgram 
PROCEDURE pi-procura-campos-bbm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-campo LIKE campo-lote-pregao.cod-campo NO-UNDO.
    DEFINE OUTPUT PARAMETER l-campo-bbm AS LOGICAL                       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR c-lista-campos AS CHAR NO-UNDO.

    ASSIGN c-lista-campos = "BBM-REGULAMENTO,BBM-USA-REGRA-10,BBM-TERM-RANDOM,BBM-EXIB-RAZSOC,BBM-DT-AMOS-INI,BBM-HR-AMOS-INI,BBM-DT-AMOS-FIM,BBM-HR-AMOS-FIM,BBM-DT-CAD-INI,BBM-DT-CAD-FIM,BBM-HR-CAD-INI,BBM-HR-CAD-FIM,BBM-DT-ABER-INI,BBM-DT-ABER-FIM,BBM-HR-ABER-INI,BBM-HT-ABER-FIM,BBM-DT-PREG-INI,BBM-DT-PREG-FIM,BBM-HR-PREG-INI,BBM-HR-PREG-FIM,BBM-TP-PREGAO,BBM-RES-ESPEC,BBM-GARANTIA,BBM-TX-OPERAC,BBM-PRAZO-ENTREG,BBM-LOCAL-ENTREG,BBM-COND-ENTREG,BBM-ACOND,BBM-PRAZO-RECEB,BBM-VAL-ESTIMADO,BBM-UTIL-CR-ICMS,BBM-UTIL-CR-IPI,BBM-VAL-REFER,BBM-TP-OFERTA".

    IF LOOKUP(c-cod-campo,c-lista-campos) > 1 THEN
       ASSIGN l-campo-bbm = YES.
    ELSE
       ASSIGN l-campo-bbm = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-bbm DBOProgram 
PROCEDURE pi-valida-campos-bbm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cod-tipo-lote LIKE campo-lote-pregao.cdn-tip-lote-pregao NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-campo     LIKE campo-lote-pregao.cod-campo           NO-UNDO.
    DEFINE INPUT  PARAMETER i-opcao          AS INTEGER                                 NO-UNDO.    
    
    DEFINE VARIABLE dt-amos-ini AS DATE       NO-UNDO.
    DEFINE VARIABLE hr-amos-ini AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dt-cad-ini  AS DATE       NO-UNDO.
    DEFINE VARIABLE hr-cad-ini  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dt-aber-ini AS DATE       NO-UNDO.
    DEFINE VARIABLE hr-aber-ini AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dt-preg-ini AS DATE       NO-UNDO.
    DEFINE VARIABLE hr-preg-ini AS CHARACTER  NO-UNDO.

    /*1 - Campos informados no cadastro do tipo de lote
      2 - Campos informados para a ordem de compra      */
    IF i-opcao = 2 THEN
        LEAVE.
    ELSE IF i-opcao = 1 THEN DO:

        {inbo/boin761.i1 bf1campo-lote-pregao}

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByTipLote DBOProgram 
PROCEDURE setConstraintByTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pc-cdn-tip-campo as INTEGER no-undo.

    assign i-cdn-tip-lote = pc-cdn-tip-campo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintcodLotePregao DBOProgram 
PROCEDURE setConstraintcodLotePregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcodtiplote-ini-0001 AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pcodtiplote-fim-0002 AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pcodCampoLote-ini-0003 AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcodCampoLote-fim-0004 AS CHARACTER NO-UNDO.

ASSIGN codtiplote-ini-0001 = pcodtiplote-ini-0001
       codtiplote-fim-0002 = pcodtiplote-fim-0002
       codCampoLote-ini-0003 = pcodCampoLote-ini-0003
       codCampoLote-fim-0004 = pcodCampoLote-fim-0004.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintdescTipLote DBOProgram 
PROCEDURE setConstraintdescTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdescCampoLote-ini-0001 AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdesCampoLote-fim-0002 AS CHARACTER NO-UNDO.

ASSIGN descCampoLote-ini-0001 = pdescCampoLote-ini-0001
       desCampoLote-fim-0002 = pdesCampoLote-fim-0002.

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

    /*Variavel usada para retorno da procedure pi-procura-campos-bbm*/
    DEFINE VARIABLE l-retorno AS LOGICAL     NO-UNDO.

    /*Declaraá∆o de teste de formatos diferentes de variaveis*/
    DEFINE VARIABLE i-integer AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-decimal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i-date    AS DATE   FORMAT "99/99/9999" NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create" OR
       pType = "Update" THEN DO:
       IF rowObject.cod-campo = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-codigo AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "C¢digo" *}
          ASSIGN c-lbl-liter-codigo = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-codigo"}
       END.
       IF rowObject.des-campo = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descriá∆o" *}
          ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-descricao"}
       END.
       IF NOT RowObject.dsl-conteudo MATCHES "*&*" THEN DO:
           IF rowObject.cdn-tip-dado = 2 THEN DO:          
              ASSIGN i-integer = INT(RowObject.dsl-conteudo) no-error.
              IF ERROR-STATUS:ERROR THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-numerico AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "NumÇrico" *}
                 ASSIGN c-lbl-liter-numerico = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-numeros-inteiros AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "n£meros_inteiros" *}
                 ASSIGN c-lbl-liter-numeros-inteiros = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                            &ErrorNumber="18733"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-numerico + '~~~~' + c-lbl-liter-numeros-inteiros"}
              END.
              ELSE 
                 ASSIGN RowObject.dsl-conteudo = STRING(i-integer).
           END.
           IF rowObject.cdn-tip-dado = 3 THEN DO:
              ASSIGN i-decimal = DEC(RowObject.dsl-conteudo) no-error.
              IF ERROR-STATUS:ERROR THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-numeros-decimais AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "n£meros_decimais" *}
                 ASSIGN c-lbl-liter-numeros-decimais = TRIM(RETURN-VALUE).
                 {utp/ut-liter.i "Decimal" *}
                 {method/svc/errors/inserr.i
                            &ErrorNumber="18733"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + c-lbl-liter-numeros-decimais"}
              END.
           END.
           IF rowObject.cdn-tip-dado = 4 THEN DO:
              IF RowObject.dsl-conteudo <> "Sim" AND
                 RowObject.dsl-conteudo <> "N∆o" AND
                 RowObject.dsl-conteudo <> "Nao" THEN DO:
                 /* Inicio -- Projeto Internacional */   
                 DEFINE VARIABLE c-lbl-liter-logico AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "L¢gico" *}
                 ASSIGN c-lbl-liter-logico = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                            &ErrorNumber="18733"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-logico + '~~~~' + 'Sim/N∆o'"}
              END. 
           END.
           IF RowObject.cod-campo = "BBM-DT-ABER-FIM" OR
              RowObject.cod-campo = "BBM-DT-AMOS-FIM" OR
              RowObject.cod-campo = "BBM-DT-CAD-FIM"  OR
              RowObject.cod-campo = "BBM-DT-PREG-FIM" THEN DO:
               ASSIGN i-integer = INT(RowObject.dsl-conteudo) no-error.               
               IF ERROR-STATUS:ERROR THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-numerico-2 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "NumÇrico" *}
                  ASSIGN c-lbl-liter-numerico-2 = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-numeros-inteiros-2 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "n£meros_inteiros" *}
                  ASSIGN c-lbl-liter-numeros-inteiros-2 = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                             &ErrorNumber="18733"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="c-lbl-liter-numerico-2 + '~~~~' + c-lbl-liter-numeros-inteiros-2"}
               END.
               ELSE 
                  ASSIGN RowObject.dsl-conteudo = STRING(i-integer).
           END.
           ELSE DO:
               IF rowObject.cdn-tip-dado = 5 THEN DO:
                  ASSIGN i-date = DATE(RowObject.dsl-conteudo) NO-ERROR.
                  ASSIGN RowObject.dsl-conteudo = STRING(i-date).
                  IF i-date = ? OR LENGTH(STRING(i-date)) > 8 THEN DO:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-data AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Data" *}
                     ASSIGN c-lbl-liter-data = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-datas-99999999 AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "datas_99/99/9999" *}
                     ASSIGN c-lbl-liter-datas-99999999 = TRIM(RETURN-VALUE).
                     {method/svc/errors/inserr.i
                                &ErrorNumber="18733"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-data + '~~~~' + c-lbl-liter-datas-99999999"}
                  END.
               END.
           END.
       END.
       RUN pi-procura-campos-bbm ( INPUT RowObject.cod-campo,
                                   OUTPUT l-retorno,
                                   OUTPUT TABLE RowErrors).

       IF AVAIL RowErrors THEN
          IF RowErrors.errorSubType = "ERROR":U THEN 
             RETURN "NOK":U.

       RUN pi-valida-campos-bbm ( INPUT RowObject.cdn-tip-lote-pregao,
                                  INPUT RowObject.cod-campo,
                                  INPUT 1) NO-ERROR.

       IF AVAIL RowErrors THEN
          IF RowErrors.errorSubType = "ERROR":U THEN 
             RETURN "NOK":U.

        IF RowObject.log-envia-pregao = FALSE THEN DO:
          run utp/ut-msgs.p (input "msg",
                             input 32832,
                             input return-value).
        END.
    END.

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST campo-lote-pregao
                    WHERE campo-lote-pregao.cod-campo = RowObject.cod-campo AND
                          campo-lote-pregao.cdn-tip-lote-pregao = RowObject.cdn-tip-lote-pregao ) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind campo-lote-pregao 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                              &ErrorNumber="8"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" 
                              &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF pType = "Delete" THEN DO:
        IF CAN-FIND(FIRST campo-lote-pregao-ord 
                    WHERE campo-lote-pregao-ord.cdn-tip-lote-pregao = rowObject.cdn-tip-lote-pregao AND
                          campo-lote-pregao-ord.cod-campo           = rowObject.cod-campo) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-tipo-lote AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_Lote" *}
            ASSIGN c-lbl-liter-tipo-lote = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ordem-de-compra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ordem_de_Compra" *}
            ASSIGN c-lbl-liter-ordem-de-compra = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="5"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-tipo-lote + '~~~~' + c-lbl-liter-ordem-de-compra"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
