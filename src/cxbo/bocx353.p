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
&GLOBAL-DEFINE DBOName BOCX353
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-embal-volum
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
{cxbo/bocx353.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-acond       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-num-volum-acond AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE tt-itens-proc-exp NO-UNDO
    FIELD nr-sequencia LIKE proc-ped-ent.nr-sequencia 
    FIELD it-codigo    LIKE proc-ped-ent.it-codigo    
    FIELD cod-refer    LIKE proc-ped-ent.cod-refer    
    FIELD quantidade   LIKE proc-ped-ent.quantidade[1]
    FIELD qtd-embal    LIKE proc-ped-ent.quantidade[1]              
    FIELD qt-embalar   LIKE proc-ped-ent.quantidade[1]             
    FIELD nome-abrev   LIKE proc-ped-ent.nome-abrev   
    FIELD nr-pedcli    LIKE proc-ped-ent.nr-pedcli    
    FIELD nr-entrega   LIKE proc-ped-ent.nr-entrega.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE embalaMesmoVolume DBOProgram 
PROCEDURE embalaMesmoVolume :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pr-embal-volum     AS ROWID                                NO-UNDO.
 DEFINE INPUT  PARAMETER pcod-estabel       LIKE processo-exp.cod-estabel           NO-UNDO.
 DEFINE INPUT  PARAMETER pnr-proc-exp       LIKE processo-exp.nr-proc-exp           NO-UNDO.
 DEFINE INPUT  PARAMETER pcod-acond         LIKE proces-embal-volum.cod-acond       NO-UNDO.
 DEFINE INPUT  PARAMETER pnum-volum-acond   LIKE proces-embal-volum.num-volum-acond NO-UNDO.
 DEFINE INPUT  PARAMETER psigla-emb         LIKE proces-embal-volum.sigla-emb       NO-UNDO.
 DEFINE INPUT  PARAMETER pnome-abrev        LIKE proces-embal-volum.nome-abrev      NO-UNDO.
 DEFINE INPUT  PARAMETER pnr-pedcli         LIKE proces-embal-volum.nr-pedcli       NO-UNDO.
 DEFINE INPUT  PARAMETER pnr-sequencia      LIKE proces-embal-volum.nr-sequencia    NO-UNDO.
 DEFINE INPUT  PARAMETER pit-codigo         LIKE proces-embal-volum.it-codigo       NO-UNDO.
 DEFINE INPUT  PARAMETER pcod-refer         LIKE proces-embal-volum.cod-refer       NO-UNDO.
 DEFINE INPUT  PARAMETER pnr-entrega        LIKE proces-embal-volum.nr-entrega      NO-UNDO.
 DEFINE INPUT  PARAMETER pde-qtd-embal      LIKE proces-embal-volum.qtd-embal       NO-UNDO.
 DEFINE OUTPUT PARAMETER pi-num-volum-embal LIKE proces-embal-volum.num-volum-embal NO-UNDO.

 DEFINE BUFFER bf1-proces-embal-volum FOR {&TableName}.

 FIND {&TableName} WHERE ROWID({&TableName}) = pr-embal-volum EXCLUSIVE-LOCK NO-ERROR.
 IF AVAIL {&TableName} THEN DO:
     IF {&TableName}.nome-abrev   = pnome-abrev   AND
        {&TableName}.nr-pedcli    = pnr-pedcli    AND
        {&TableName}.nr-sequencia = pnr-sequencia AND
        {&TableName}.it-codigo    = pit-codigo    AND
        {&TableName}.cod-refer    = pcod-refer    AND
        {&TableName}.nr-entrega   = pnr-entrega   THEN
         ASSIGN {&TableName}.qtd-embal = {&TableName}.qtd-embal + pde-qtd-embal.
     ELSE DO:
         IF CAN-FIND(FIRST bf{&TableName}
                     WHERE bf{&TableName}.cod-estabel     = pcod-estabel    
                       AND bf{&TableName}.nr-proc-exp     = pnr-proc-exp    
                       AND bf{&TableName}.cod-acond       = pcod-acond      
                       AND bf{&TableName}.num-volum-acond = pnum-volum-acond
                       AND bf{&TableName}.num-volum-embal = {&TableName}.num-volum-embal
                       AND bf{&TableName}.sigla-emb       = psigla-emb      
                       AND bf{&TableName}.nome-abrev      = pnome-abrev     
                       AND bf{&TableName}.nr-pedcli       = pnr-pedcli      
                       AND bf{&TableName}.nr-sequencia    = pnr-sequencia   
                       AND bf{&TableName}.it-codigo       = pit-codigo      
                       AND bf{&TableName}.cod-refer       = pcod-refer      
                       AND bf{&TableName}.nr-entrega      = pnr-entrega) THEN DO:
             FIND FIRST bf1-proces-embal-volum
                  WHERE bf1-proces-embal-volum.cod-estabel     = pcod-estabel    
                    AND bf1-proces-embal-volum.nr-proc-exp     = pnr-proc-exp    
                    AND bf1-proces-embal-volum.cod-acond       = pcod-acond      
                    AND bf1-proces-embal-volum.num-volum-acond = pnum-volum-acond
                    AND bf1-proces-embal-volum.num-volum-embal = proces-embal-volum.num-volum-embal
                    AND bf1-proces-embal-volum.sigla-emb       = psigla-emb      
                    AND bf1-proces-embal-volum.nome-abrev      = pnome-abrev     
                    AND bf1-proces-embal-volum.nr-pedcli       = pnr-pedcli      
                    AND bf1-proces-embal-volum.nr-sequencia    = pnr-sequencia   
                    AND bf1-proces-embal-volum.it-codigo       = pit-codigo      
                    AND bf1-proces-embal-volum.cod-refer       = pcod-refer      
                    AND bf1-proces-embal-volum.nr-entrega      = pnr-entrega EXCLUSIVE-LOCK NO-ERROR.
             ASSIGN bf1-proces-embal-volum.qtd-embal = bf1-proces-embal-volum.qtd-embal + pde-qtd-embal.
         END.
         ELSE
             ASSIGN pi-num-volum-embal = {&TableName}.num-volum-embal.
     END.
 END.

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
        WHEN "cod-acond":U THEN ASSIGN pFieldValue = RowObject.cod-acond.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "sigla-emb":U THEN ASSIGN pFieldValue = RowObject.sigla-emb.
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
        WHEN "qtd-embal":U THEN ASSIGN pFieldValue = RowObject.qtd-embal.
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
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-volum-acond":U THEN ASSIGN pFieldValue = RowObject.num-volum-acond.
        WHEN "num-volum-embal":U THEN ASSIGN pFieldValue = RowObject.num-volum-embal.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsmblv-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-acond
               retorna valor do campo num-volum-acond
               retorna valor do campo num-volum-embal
               retorna valor do campo sigla-emb
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo nr-entrega
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-embal-volum.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-embal-volum.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acond LIKE proces-embal-volum.cod-acond NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-volum-acond LIKE proces-embal-volum.num-volum-acond NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-volum-embal LIKE proces-embal-volum.num-volum-embal NO-UNDO.
    DEFINE OUTPUT PARAMETER psigla-emb LIKE proces-embal-volum.sigla-emb NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE proces-embal-volum.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE proces-embal-volum.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE proces-embal-volum.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE proces-embal-volum.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE proces-embal-volum.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-entrega LIKE proces-embal-volum.nr-entrega NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-acond = RowObject.cod-acond
           pnum-volum-acond = RowObject.num-volum-acond
           pnum-volum-embal = RowObject.num-volum-embal
           psigla-emb = RowObject.sigla-emb
           pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           pnr-entrega = RowObject.nr-entrega.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextVolum DBOProgram 
PROCEDURE getNextVolum :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor do ultimo volume da embalagem
  Parameters:  
               recebe o estabelecimento do processo de exportaá∆o
               recebe o nr do processo de exportaá∆o
               recebe o acondicionamento do processo de exportaá∆o
               recebe o volume do acondicionamento do processo de exportaá∆o
               retorna o £ltimo nr do volume informado
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pcCodEstabel    like estabelec.cod-estabel              no-undo.
    def input  param pcNrProcExp     like processo-exp.nr-proc-exp           no-undo.
    def input  param pcCodAcond      like proces-acond.cod-acond             no-undo.
    def input  param piNumVolumAcond like proces-embal-volum.num-volum-acond no-undo.
    def output param piNrUltVol      like proces-embal-volum.num-volum-embal no-undo.

    FIND LAST bfproces-embal-volum 
        WHERE bfproces-embal-volum.cod-estabel     = pcCodEstabel 
          AND bfproces-embal-volum.nr-proc-exp     = pcNrProcExp 
          AND bfproces-embal-volum.cod-acond       = pcCodAcond
          AND bfproces-embal-volum.num-volum-acond = piNumVolumAcond NO-LOCK NO-ERROR.

    if  avail bfproces-embal-volum then
        assign piNrUltVol = bfproces-embal-volum.num-volum-embal + 1.
    else
        assign piNrUltVol = 1.

    return "OK":U.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSiglaEmb DBOProgram 
PROCEDURE getSiglaEmb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pit-codigo LIKE proces-embal-volum.it-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER psigla-emb LIKE proces-embal-volum.sigla-emb NO-UNDO.
    
    FOR FIRST item FIELDS(item.it-codigo item.fm-codigo item.fm-cod-com)
        WHERE item.it-codigo = pit-codigo NO-LOCK: END.

    FOR FIRST item-caixa FIELDS(item-caixa.sigla-emb)
        WHERE item-caixa.it-codigo  = item.it-codigo
          AND item-caixa.fm-codigo  = item.fm-codigo
          AND item-caixa.fm-cod-com = item.fm-cod-com NO-LOCK:

        ASSIGN psigla-emb = item-caixa.sigla-emb.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice prcsmblv-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-acond
               recebe valor do campo num-volum-acond
               recebe valor do campo num-volum-embal
               recebe valor do campo sigla-emb
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo nr-entrega
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-embal-volum.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-embal-volum.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond LIKE proces-embal-volum.cod-acond NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-acond LIKE proces-embal-volum.num-volum-acond NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-embal LIKE proces-embal-volum.num-volum-embal NO-UNDO.
    DEFINE INPUT PARAMETER psigla-emb LIKE proces-embal-volum.sigla-emb NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE proces-embal-volum.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE proces-embal-volum.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE proces-embal-volum.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE proces-embal-volum.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE proces-embal-volum.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega LIKE proces-embal-volum.nr-entrega NO-UNDO.

    FIND FIRST bfproces-embal-volum WHERE 
        bfproces-embal-volum.cod-estabel = pcod-estabel AND 
        bfproces-embal-volum.nr-proc-exp = pnr-proc-exp AND 
        bfproces-embal-volum.cod-acond = pcod-acond AND 
        bfproces-embal-volum.num-volum-acond = pnum-volum-acond AND 
        bfproces-embal-volum.num-volum-embal = pnum-volum-embal AND 
        bfproces-embal-volum.sigla-emb = psigla-emb AND 
        bfproces-embal-volum.nome-abrev = pnome-abrev AND 
        bfproces-embal-volum.nr-pedcli = pnr-pedcli AND 
        bfproces-embal-volum.nr-sequencia = pnr-sequencia AND 
        bfproces-embal-volum.it-codigo = pit-codigo AND 
        bfproces-embal-volum.cod-refer = pcod-refer AND 
        bfproces-embal-volum.nr-entrega = pnr-entrega NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-embal-volum THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-embal-volum)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso-exp DBOProgram 
PROCEDURE linkToProcesso-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hp_Parent AS HANDLE NO-UNDO.

ASSIGN c-cod-estabel = ""
       c-nr-proc-exp = "".

if  valid-handle(hp_Parent) then do:
    run getCharField in hp_Parent (input "cod-estabel":U, output c-cod-estabel).
    run getCharField in hp_Parent (input "nr-proc-exp":U, output c-nr-proc-exp).
end.

RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcessoExp DBOProgram 
PROCEDURE openQueryProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel = c-cod-estabel
       AND {&tablename}.nr-proc-exp = c-nr-proc-exp
       INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVolumeAcond DBOProgram 
PROCEDURE openQueryVolumeAcond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel     = c-cod-estabel
       AND {&tablename}.nr-proc-exp     = c-nr-proc-exp
       AND {&tablename}.cod-acond       = c-cod-acond
       AND {&tablename}.num-volum-acond = i-num-volum-acond
       INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaItensProcExp DBOProgram 
PROCEDURE retornaItensProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-embal-volum.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-embal-volum.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-itens-proc-exp.

    DEFINE VARIABLE de-qtd-embal  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-qt-embalar AS DECIMAL    NO-UNDO.

    EMPTY TEMP-TABLE tt-itens-proc-exp.

    FOR EACH proc-ped-ent NO-LOCK
       WHERE proc-ped-ent.cod-estabel   = pcod-estabel
         AND proc-ped-ent.nr-proc-exp   = pnr-proc-exp
         AND proc-ped-ent.ind-componen <= 2:

        ASSIGN de-qtd-embal = 0.

        IF CAN-FIND(FIRST proces-embal-volum
                    WHERE proces-embal-volum.cod-estabel     = proc-ped-ent.cod-estabel
                      AND proces-embal-volum.nr-proc-exp     = proc-ped-ent.nr-proc-exp
                      AND proces-embal-volum.nome-abrev      = proc-ped-ent.nome-abrev  
                      AND proces-embal-volum.nr-pedcli       = proc-ped-ent.nr-pedcli   
                      AND proces-embal-volum.nr-sequencia    = proc-ped-ent.nr-sequencia
                      AND proces-embal-volum.it-codigo       = proc-ped-ent.it-codigo   
                      AND proces-embal-volum.cod-refer       = proc-ped-ent.cod-refer   
                      AND proces-embal-volum.nr-entrega      = proc-ped-ent.nr-entrega) THEN DO:
            FOR EACH proces-embal-volum NO-LOCK
               WHERE proces-embal-volum.cod-estabel     = proc-ped-ent.cod-estabel
                 AND proces-embal-volum.nr-proc-exp     = proc-ped-ent.nr-proc-exp
                 AND proces-embal-volum.nome-abrev      = proc-ped-ent.nome-abrev  
                 AND proces-embal-volum.nr-pedcli       = proc-ped-ent.nr-pedcli   
                 AND proces-embal-volum.nr-sequencia    = proc-ped-ent.nr-sequencia
                 AND proces-embal-volum.it-codigo       = proc-ped-ent.it-codigo   
                 AND proces-embal-volum.cod-refer       = proc-ped-ent.cod-refer   
                 AND proces-embal-volum.nr-entrega      = proc-ped-ent.nr-entrega:
                
                ASSIGN de-qtd-embal = de-qtd-embal + proces-embal-volum.qtd-embal.

            END.

            ASSIGN de-qt-embalar = proc-ped-ent.quantidade[1] - de-qtd-embal.

            IF de-qtd-embal > 0 AND de-qt-embalar > 0 THEN DO: 
                CREATE tt-itens-proc-exp.
                ASSIGN tt-itens-proc-exp.nr-sequencia = proc-ped-ent.nr-sequencia
                       tt-itens-proc-exp.it-codigo    = proc-ped-ent.it-codigo   
                       tt-itens-proc-exp.cod-refer    = proc-ped-ent.cod-refer   
                       tt-itens-proc-exp.quantidade   = proc-ped-ent.quantidade[1]
                       tt-itens-proc-exp.qtd-embal    = de-qtd-embal
                       tt-itens-proc-exp.qt-embalar   = de-qt-embalar
                       tt-itens-proc-exp.nome-abrev   = proc-ped-ent.nome-abrev
                       tt-itens-proc-exp.nr-pedcli    = proc-ped-ent.nr-pedcli 
                       tt-itens-proc-exp.nr-entrega   = proc-ped-ent.nr-entrega.
            END. 
        END.
        ELSE DO:
            CREATE tt-itens-proc-exp.
            ASSIGN tt-itens-proc-exp.nr-sequencia = proc-ped-ent.nr-sequencia
                   tt-itens-proc-exp.it-codigo    = proc-ped-ent.it-codigo   
                   tt-itens-proc-exp.cod-refer    = proc-ped-ent.cod-refer   
                   tt-itens-proc-exp.quantidade   = proc-ped-ent.quantidade[1]
                   tt-itens-proc-exp.qtd-embal    = 0
                   tt-itens-proc-exp.qt-embalar   = proc-ped-ent.quantidade[1]
                   tt-itens-proc-exp.nome-abrev   = proc-ped-ent.nome-abrev
                   tt-itens-proc-exp.nr-pedcli    = proc-ped-ent.nr-pedcli 
                   tt-itens-proc-exp.nr-entrega   = proc-ped-ent.nr-entrega.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcessoExp DBOProgram 
PROCEDURE setConstraintProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel     LIKE proces-embal-resum.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp     LIKE proces-embal-resum.nr-proc-exp     NO-UNDO.

    ASSIGN c-cod-estabel     = pcod-estabel    
           c-nr-proc-exp     = pnr-proc-exp.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVolumeAcond DBOProgram 
PROCEDURE setConstraintVolumeAcond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcod-estabel     LIKE proces-embal-resum.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp     LIKE proces-embal-resum.nr-proc-exp     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond       LIKE proces-embal-resum.cod-acond       NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-acond LIKE proces-embal-resum.num-volum-acond NO-UNDO.

    ASSIGN c-cod-estabel     = pcod-estabel    
           c-nr-proc-exp     = pnr-proc-exp    
           c-cod-acond       = pcod-acond      
           i-num-volum-acond = pnum-volum-acond.

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
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

