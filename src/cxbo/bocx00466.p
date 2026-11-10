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
{include/i-prgvrs.i BOCX00466 2.00.00.030 } /*** "010030" 07/10/2024 16:59:54 ***/
/* ***************************  Definitions  ***************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00466
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-item-nf-refer
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
{cxbo/bocx00466.i RowObject}
{cxbo/bocx00466.i tt-due-item-nf-refer}
{cdp/cdcfgdis.i}  /*PrÇ-processadores distribuiá∆o*/

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE de-cdd-due-ems      LIKE {&TableName}.cdd-due-ems    NO-UNDO.
DEFINE VARIABLE i-num-versao-due    LIKE {&TableName}.num-versao-due NO-UNDO.
DEFINE VARIABLE i-next-seq          AS INTEGER                       NO-UNDO.
DEFINE VARIABLE i-next-seq-siscomex AS INTEGER                       NO-UNDO.

{cdp/cdapi1004.i1} /* Variaveis usadas na API de Log */

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
         HEIGHT             = 2.96
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
        WHEN "cod-chave-aces-nf-due":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-due.
        WHEN "cod-chave-aces-nf-refer":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-refer.
        WHEN "cod-estab-nf-due":U THEN ASSIGN pFieldValue = RowObject.cod-estab-nf-due.
        WHEN "cod-estab-nf-refer":U THEN ASSIGN pFieldValue = RowObject.cod-estab-nf-refer.
        WHEN "cod-estab-proces-exp-due":U THEN ASSIGN pFieldValue = RowObject.cod-estab-proces-exp-due.
        WHEN "cod-estab-proces-exp-refer":U THEN ASSIGN pFieldValue = RowObject.cod-estab-proces-exp-refer.
        WHEN "cod-item-due":U THEN ASSIGN pFieldValue = RowObject.cod-item-due.
        WHEN "cod-item-refer":U THEN ASSIGN pFieldValue = RowObject.cod-item-refer.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc-due":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc-due.
        WHEN "cod-nota-fisc-refer":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc-refer.
        WHEN "cod-proces-exp-due":U THEN ASSIGN pFieldValue = RowObject.cod-proces-exp-due.
        WHEN "cod-proces-exp-refer":U THEN ASSIGN pFieldValue = RowObject.cod-proces-exp-refer.
        WHEN "cod-serie-nf-due":U THEN ASSIGN pFieldValue = RowObject.cod-serie-nf-due.
        WHEN "cod-serie-nf-refer":U THEN ASSIGN pFieldValue = RowObject.cod-serie-nf-refer.
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
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "qtd-assoc":U THEN ASSIGN pFieldValue = RowObject.qtd-assoc.
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
        WHEN "idi-tip-nf":U THEN ASSIGN pFieldValue = RowObject.idi-tip-nf.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-faturam-due":U THEN ASSIGN pFieldValue = RowObject.num-seq-faturam-due.
        WHEN "num-seq-faturam-refer":U THEN ASSIGN pFieldValue = RowObject.num-seq-faturam-refer.
        WHEN "num-seq-it-due":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-due.
        WHEN "num-seq-nf-refer":U THEN ASSIGN pFieldValue = RowObject.num-seq-nf-refer.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dtmnfrfr_id2
  Parameters:  
               retorna valor do campo cdd-due-ems
               retorna valor do campo num-versao-due
               retorna valor do campo num-seq-it-due
               retorna valor do campo num-seq-nf-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-item-nf-refer.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-versao-due LIKE due-item-nf-refer.num-versao-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-due LIKE due-item-nf-refer.num-seq-it-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-nf-refer LIKE due-item-nf-refer.num-seq-nf-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems
           pnum-versao-due = RowObject.num-versao-due
           pnum-seq-it-due = RowObject.num-seq-it-due
           pnum-seq-nf-refer = RowObject.num-seq-nf-refer.

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
  Purpose:     Reposiciona registro com base no °ndice dtmnfrfr_id2
  Parameters:  
               recebe valor do campo cdd-due-ems
               recebe valor do campo num-versao-due
               recebe valor do campo num-seq-it-due
               recebe valor do campo num-seq-nf-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems LIKE due-item-nf-refer.cdd-due-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-versao-due LIKE due-item-nf-refer.num-versao-due NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due LIKE due-item-nf-refer.num-seq-it-due NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-nf-refer LIKE due-item-nf-refer.num-seq-nf-refer NO-UNDO.

    FIND FIRST bfdue-item-nf-refer WHERE 
        bfdue-item-nf-refer.cdd-due-ems = pcdd-due-ems AND 
        bfdue-item-nf-refer.num-versao-due = pnum-versao-due AND 
        bfdue-item-nf-refer.num-seq-it-due = pnum-seq-it-due AND 
        bfdue-item-nf-refer.num-seq-nf-refer = pnum-seq-nf-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-item-nf-refer THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-item-nf-refer)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNF DBOProgram 
PROCEDURE openQueryByNF :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todas as Notas Fiscais Referenciadas
               relacionadas Ö DU-E ordenado por Nota Fiscal
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems    = de-cdd-due-ems  
                                 AND {&TABLENAME}.num-versao-due = i-num-versao-due
                            NO-LOCK BY {&TABLENAME}.num-seq-it-due
                                    BY {&TABLENAME}.num-seq-nf-refer
                                    BY {&TABLENAME}.cod-estab-nf-refer
                                    BY {&TABLENAME}.cod-serie-nf-refer
                                    BY {&TABLENAME}.cod-nota-fisc-refer INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNFProcExp DBOProgram 
PROCEDURE openQueryByNFProcExp :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todas as Notas Fiscais Referenciadas
               relacionadas Ö DU-E ordenado por Estabelecimento e Processo de Exportaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems    = de-cdd-due-ems  
                                 AND {&TABLENAME}.num-versao-due = i-num-versao-due
                            NO-LOCK BY {&TABLENAME}.num-seq-it-due 
                                    BY {&TABLENAME}.num-seq-nf-refer 
                                    BY {&TABLENAME}.cod-estab-proces-exp-refer 
                                    BY {&TABLENAME}.cod-proces-exp-refer INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConverteQtdeEstatistica DBOProgram 
PROCEDURE piConverteQtdeEstatistica :
/*------------------------------------------------------------------------------
  Purpose:     Converte a quantidade comercializada na Unidade de Medida Estat°stica
               Procedure adaptada conforme bodi317pr.m77 - pi-unid-tributavel
  Parameters:  Entrada: pc-cod-estabel-nf-refer: Estabelecimento da NF Referenciada (character)
               Entrada: pc-serie-nf-refer      : SÇrie da NF Referenciada (character)
               Entrada: pc-cod-nota-fisc-refer : N£mero da NF Referenciada (character)
               Entrada: pc-nat-operacao-refer  : Natureza de Operaá∆o da NF Referenciada (character)
               Entrada: pi-emitente-nf-refer   : Emitente da NF Referenciada (integer)
               Entrada: pi-num-seq-faturam-refer: Sequencia do item da NF Referenciada (integer)
               Entrada/Sa°da:   p-de-qtd-trib  : Quantidade informada na NF (decimal)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel-nf-refer  LIKE due-item-nf-refer.cod-estab-nf-refer      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-nf-refer        LIKE due-item-nf-refer.cod-serie-nf-refer      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-nota-fisc-refer   LIKE due-item-nf-refer.cod-nota-fisc-refer     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao-refer    LIKE natur-oper.nat-operacao                   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-emitente-nf-refer     LIKE emitente.cod-emitente                     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-seq-faturam-refer LIKE due-item-nf-refer.num-seq-faturam-refer   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-de-qtd-trib      LIKE due-item-nf-refer.qtd-assoc               NO-UNDO.

    DEFINE VARIABLE c-arq-log       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-log-negocio   AS LOGICAL     NO-UNDO.

    ASSIGN l-log-negocio = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-log-negocio":U AND funcao.ativo).

    IF AVAIL due-item THEN
        ASSIGN c-arq-log = "LOG_NEGOCIO_due_":U + STRING(due-item.cdd-due-ems) + ".txt":U.
    ELSE DO:
        IF AVAIL RowObject THEN
            ASSIGN c-arq-log = "LOG_NEGOCIO_due_":U + STRING(RowObject.cdd-due-ems) + ".txt":U.
        ELSE DO:
            ASSIGN c-arq-log     = "":U
                   l-log-negocio = NO. //caso nío consiga encontrar o cΩdigo da due, n∆o deve gerar o log, por isso atribui "no" na vari†vel l-log-negocio
        END.
    END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="2" &iType="1" &cMessage="'CONVERTER QUANTIDADE ESTAT÷STICA':U"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-cod-estabel-nf-refer = ':U + STRING(pc-cod-estabel-nf-refer)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-serie-nf-refer = ':U + STRING(pc-serie-nf-refer)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-cod-nota-fisc-refer = ':U + STRING(pc-cod-nota-fisc-refer)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-nat-operacao-refer = ':U + STRING(pc-nat-operacao-refer)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pi-emitente-nf-refer = ':U + STRING(pi-emitente-nf-refer)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pi-num-seq-faturam-refer = ':U + STRING(pi-num-seq-faturam-refer)"}
    END.

    DEFINE VARIABLE p-c-unid-trib      AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-nome-abrev       AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-it-codigo        AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-tabela           AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-class-fiscal     AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-unid-item-nota   AS CHARACTER     NO-UNDO EXTENT 2.
    DEFINE VARIABLE de-qtd-item-nota   AS DECIMAL       NO-UNDO EXTENT 2.
    DEFINE VARIABLE de-peso-liq        AS DECIMAL       NO-UNDO.
    DEFINE VARIABLE de-peso-bru        AS DECIMAL       NO-UNDO.
    DEFINE VARIABLE de-fator-conv      AS DECIMAL       NO-UNDO.
    DEFINE VARIABLE i-nro-decimais-nfe AS INTEGER       NO-UNDO. 
    DEFINE VARIABLE i-orig-unid-trib   AS INTEGER       NO-UNDO.

    FOR FIRST it-doc-fisc FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao nr-seq-doc) 
        WHERE it-doc-fisc.cod-estabel  = pc-cod-estabel-nf-refer
          AND it-doc-fisc.serie        = pc-serie-nf-refer      
          AND it-doc-fisc.nr-doc-fis   = pc-cod-nota-fisc-refer 
          AND it-doc-fisc.nat-operacao = pc-nat-operacao-refer  
          AND it-doc-fisc.cod-emitente = pi-emitente-nf-refer
          AND it-doc-fisc.nr-seq-doc   = pi-num-seq-faturam-refer   NO-LOCK:

        FOR FIRST natur-oper FIELDS(tipo cod-cfop)
            WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao NO-LOCK:
        END.

        IF l-log-negocio THEN DO:
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Tipo da natureza de operaá∆o (natur-oper.tipo) = ':U + STRING(natur-oper.tipo)"}
        END.

        IF natur-oper.tipo = 1 THEN DO:
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Natureza de operaá∆o tipo 1. Utiliza as informaá‰es da item-doc-est':U"}
            END.
            FOR FIRST item-doc-est FIELDS(cod-emitente it-codigo un quantidade class-fiscal peso-liquido peso-bruto-item serie-docto nro-docto nat-of sequencia)
                WHERE item-doc-est.serie-docto  = it-doc-fisc.serie
                AND   item-doc-est.nro-docto    = it-doc-fisc.nr-doc-fis
                AND   item-doc-est.cod-emitente = it-doc-fisc.cod-emitente
                AND   item-doc-est.nat-of       = it-doc-fisc.nat-operacao /* Tenta buscar com a natureza fiscal */
                AND   item-doc-est.sequencia    = it-doc-fisc.nr-seq-doc NO-LOCK: 
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Encontrou item-doc-est a partir da natureza fiscal':U"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. fiscal - item-doc-est.serie-docto = ':U + STRING(item-doc-est.serie-docto)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. fiscal - item-doc-est.nro-docto = ':U + STRING(item-doc-est.nro-docto)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. fiscal - item-doc-est.cod-emitente = ':U + STRING(item-doc-est.cod-emitente)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. fiscal - item-doc-est.nat-of = ':U + STRING(item-doc-est.nat-of)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. fiscal - item-doc-est.sequencia = ':U + STRING(item-doc-est.sequencia)"}
                END.
            END.

            /* Se nío achou tenta buscar com a natureza do documento */
            IF  NOT AVAIL item-doc-est THEN
                FOR FIRST item-doc-est FIELDS(cod-emitente it-codigo un quantidade class-fiscal peso-liquido peso-bruto-item serie-docto nro-docto nat-operacao sequencia)
                    WHERE item-doc-est.serie-docto  = it-doc-fisc.serie
                    AND   item-doc-est.nro-docto    = it-doc-fisc.nr-doc-fis
                    AND   item-doc-est.cod-emitente = it-doc-fisc.cod-emitente
                    AND   item-doc-est.nat-operacao = it-doc-fisc.nat-operacao /* Busca item a partit da natureza da nota */
                    AND   item-doc-est.sequencia    = it-doc-fisc.nr-seq-doc NO-LOCK: 
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Encontrou item-doc-est a partir da natureza da nota':U"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. Nota - item-doc-est.serie-docto = ':U + STRING(item-doc-est.serie-docto)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. Nota - item-doc-est.nro-docto = ':U + STRING(item-doc-est.nro-docto)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. Nota - item-doc-est.cod-emitente = ':U + STRING(item-doc-est.cod-emitente)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. Nota - item-doc-est.nat-operacao = ':U + STRING(item-doc-est.nat-operacao)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat. Nota - item-doc-est.sequencia = ':U + STRING(item-doc-est.sequencia)"}
                END.
            END.

            IF AVAIL item-doc-est THEN DO:
                FOR FIRST emitente FIELDS (nome-abrev)
                    WHERE emitente.cod-emitente = item-doc-est.cod-emitente NO-LOCK:
                END.

                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.it-codigo = ':U + STRING(item-doc-est.it-codigo)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.un = ':U + STRING(item-doc-est.un)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.quantidade = ':U + STRING(item-doc-est.quantidade)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.class-fiscal = ':U + STRING(item-doc-est.class-fiscal)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.peso-liquido = ':U + STRING(item-doc-est.peso-liquido)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'item-doc-est.peso-bruto-item = ':U + STRING(item-doc-est.peso-bruto-item)"}
                END.

                ASSIGN c-tabela         = "item-doc-est":U
                       c-nome-abrev     = emitente.nome-abrev
                       c-it-codigo      = item-doc-est.it-codigo
                       c-unid-item-nota = item-doc-est.un
                       de-qtd-item-nota = item-doc-est.quantidade
                       c-class-fiscal   = item-doc-est.class-fiscal
                       de-peso-liq      = item-doc-est.peso-liquido
                       de-peso-bru      = item-doc-est.peso-bruto-item.
            END.
            ELSE DO:
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'N∆o encontrado registro item-doc-est.':U"}
                END.
            END.
        END.
        ELSE DO:
            FOR FIRST it-nota-fisc FIELDS(nome-ab-cli it-codigo un-fatur qt-faturada class-fiscal peso-liq-fat peso-bruto) 
                WHERE it-nota-fisc.cod-estabel  = it-doc-fisc.cod-estabel
                  AND it-nota-fisc.serie        = it-doc-fisc.serie
                  AND it-nota-fisc.nr-nota-fis  = it-doc-fisc.nr-doc-fis
                  AND it-nota-fisc.nat-operacao = it-doc-fisc.nat-operacao
                  AND it-nota-fisc.cd-emitente  = it-doc-fisc.cod-emitente
                  AND it-nota-fisc.nr-seq-fat   = it-doc-fisc.nr-seq-doc:

            END.
            IF  AVAIL it-nota-fisc THEN DO:
                ASSIGN c-tabela         = "it-nota-fisc":U
                       c-nome-abrev     = it-nota-fisc.nome-ab-cli
                       c-it-codigo      = it-nota-fisc.it-codigo
                       c-unid-item-nota = it-nota-fisc.un-fatur
                       de-qtd-item-nota = it-nota-fisc.qt-faturada
                       c-class-fiscal   = it-nota-fisc.class-fiscal
                       de-peso-liq      = it-nota-fisc.peso-liq-fat
                       de-peso-bru      = it-nota-fisc.peso-bruto.
            END.
            ELSE DO:
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'N∆o encontrado registro it-nota-fisc':U"}
                END.
            END.
        END.

        /* inicia os valores na unidade de estoque, para caso na CFOP n∆o estiver marcado o parÉmetro 
           "Envia Unidade rTribut†vel do NCM - CD0602", ou seja, 
           se n∆o tiver unidade tribut†vel ou se n∆o tiver fator de convers∆o */
      
        ASSIGN p-c-unid-trib      = c-unid-item-nota[1].
        IF l-log-negocio THEN DO:
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Unidade default = ':U + STRING(p-c-unid-trib)"}
        END.
        
        FOR FIRST cfop-natur FIELDS(cod-cfop log-livre-2) NO-LOCK
            WHERE cfop-natur.cod-cfop = natur-oper.cod-cfop:
        END.

        IF (NOT AVAIL cfop-natur) OR (AVAIL cfop-natur AND NOT cfop-natur.log-livre-2) THEN DO:
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="2" &cMessage="'N∆o encontrado registo cfop-natur OU parÉmetro cfop-natur.log-livre-2 n∆o est† marcado.':U"}
            END.
            RETURN "OK":U.
        END.
        
        FOR FIRST item FIELDS(class-fiscal char-1) NO-LOCK
            WHERE item.it-codigo = c-it-codigo: 
        END.

        IF l-log-negocio THEN DO:
        	{cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Classificaá∆o Fiscal = ':U + STRING(c-class-fiscal)"}
        END.
    
        IF  c-class-fiscal = "":U THEN DO:
            ASSIGN c-class-fiscal = item.class-fiscal.
            IF l-log-negocio THEN DO:
            	{cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Assumiu classificaá∆o fiscal do item = ':U + STRING(c-class-fiscal)"}
            END.
        END.
    
        FOR FIRST classif-fisc FIELDS(char-2 unidade) NO-LOCK 
            WHERE classif-fisc.class-fiscal = c-class-fiscal:
        END.
    
        /* unidade tribut†vel do NCM */      
        IF TRIM(SUBSTRING(classif-fisc.char-2,2,3)) <> "":U THEN DO: /* unid medida tribut†vel */
            ASSIGN p-c-unid-trib = TRIM(SUBSTRING(classif-fisc.char-2,2,3)).
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Encontrou unidade de medida tribut†vel (classif-fisc.char-2,2,3) = ':U + STRING(TRIM(SUBSTRING(classif-fisc.char-2,2,3)))"}
            END.
        END.

        FOR FIRST emitente FIELDS(natureza) NO-LOCK
            WHERE emitente.nome-abrev = c-nome-abrev:
        END.
    
        IF (AVAIL emitente AND (emitente.natureza = 1 OR emitente.natureza = 2)) /* pessoa fisica / pessoa juridica */
        AND TRIM(classif-fisc.unidade) <> "":U
        AND NOT (cfop-natur.cod-cfop = "1501":U OR  /* N«O entrar quando for uma operaá∆o equiparada Ö Exportaá∆o, conforme NT 2016.001 [Operaá‰es vinculadas a exportaá∆o CFOP=1501, 2501, 5501, 5502, 5504, 5505, 6501, 6502, 6504 ou 6505] */
                 cfop-natur.cod-cfop = "2501":U OR
                 cfop-natur.cod-cfop = "5501":U OR
                 cfop-natur.cod-cfop = "5502":U OR 
                 cfop-natur.cod-cfop = "5504":U OR
                 cfop-natur.cod-cfop = "5505":U OR
                 cfop-natur.cod-cfop = "6501":U OR
                 cfop-natur.cod-cfop = "6502":U OR 
                 cfop-natur.cod-cfop = "6504":U OR
                 cfop-natur.cod-cfop = "6505":U) THEN DO:

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Encontrado emitente (pessoa f°sica ou jur°dica), unidade inforamada (classif-fisc.unidade) e CFOP N«O equiparada a exportaá∆o (Diferente de 1501, 2501, 5501, 5502, 5504, 5505, 6501, 6502, 6504 ou 6505).':U"}
            END.
    
            /* Verificar se Cod Barras foi informado para mercado interno */
            IF  CAN-FIND (FIRST item-mat NO-LOCK
                          WHERE item-mat.it-codigo = item.it-codigo
                            AND item-mat.cod-ean  <> "":U) THEN DO: /* C¢d GTIN (Trib) - CD0903 */
                ASSIGN p-c-unid-trib = TRIM(classif-fisc.unidade).
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'C¢digo de barras informado para mercado interno (item-mat.cod-ean)':U"}
                END.
            END.
            ELSE DO:
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="2" &cMessage="'C¢digo de barras n∆o foi informado para mercado interno.':U"}
                END.
                RETURN "OK":U.
            END.
        END.
        
        IF  NOT AVAIL para-fat THEN 
            FOR FIRST para-fat FIELDS(&IF "{&bf_dis_versao_ems}" >= "2.09" &THEN para-fat.num-dec-val-unit-nfe &ELSE char-2 &ENDIF) NO-LOCK:
            END.
        
        ASSIGN i-nro-decimais-nfe = &IF "{&bf_dis_versao_ems}" >= "2.09" /* FT0301 - Pasta C†lculos - Campo "Nro Decimais Val Unit NF-e" */
                                    &THEN para-fat.num-dec-val-unit-nfe.
                                    &ELSE INT(TRIM(SUBSTRING(para-fat.char-2,94,2)))
                                    &ENDIF.
        
        IF i-nro-decimais-nfe = 0 THEN
            ASSIGN i-nro-decimais-nfe = 10.


        IF l-log-negocio THEN DO:
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Validaá∆o unidades de medida - p-c-unid-trib = ':U + STRING(p-c-unid-trib)"}
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Validaá∆o unidades de medida - c-unid-item-nota[1] = ':U + STRING(c-unid-item-nota[1])"}
        END.
        
        IF p-c-unid-trib <> c-unid-item-nota[1] THEN DO: /* mesma unidade de medida */
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Unidades de medida diferentes, inicia c†lculos de convers∆o.':U"}
            END.
            
            /* processamento */
            
            ASSIGN i-orig-unid-trib = INT(SUBSTRING(item.char-1,341,1)).

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Origem unidade tribut†vel (2 - Unid Familia; 3 - Unid Faturamento; 4 - Peso Liq; 5 - Peso bruto; diferente 2,3,4,5 - Unidade de medida DO NCM (usar fator de convers∆o)) = ':U + STRING(i-orig-unid-trib)"}
            END.
            
            IF  i-orig-unid-trib = 2          /* unid familia */
            OR  i-orig-unid-trib = 3 THEN DO: /* unid faturamento */
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Origem unidade tribut†vel: Fam°lia ou faturamento':U"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'p-de-qtd-trib (antes c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-qtd-item-nota[2] = ':U + STRING(de-qtd-item-nota[2])"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-qtd-item-nota[1] = ':U + STRING(de-qtd-item-nota[1])"}
                END.
                ASSIGN p-de-qtd-trib = (de-qtd-item-nota[2] * p-de-qtd-trib) / de-qtd-item-nota[1].
                
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'p-de-qtd-trib (ap¢s c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                END.
            END.
            ELSE DO:
                IF  i-orig-unid-trib = 4          /* peso liquido */
                OR  i-orig-unid-trib = 5 THEN DO: /* peso bruto */ 
                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'p-de-qtd-trib (antes c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                    END.
                    IF  i-orig-unid-trib = 4 THEN DO:
                        IF l-log-negocio THEN DO:
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Origem unidade tribut†vel: Peso Liquido':U"}
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-peso-liq = ':U + STRING(de-peso-liq)"}
                        END.
                        ASSIGN p-de-qtd-trib = (de-peso-liq * p-de-qtd-trib) / de-qtd-item-nota[1].
                    END.
                    ELSE DO:
                        IF l-log-negocio THEN DO:
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Origem unidade tribut†vel: Peso Bruto':U"}
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-peso-bru = ':U + STRING(de-peso-bru)"}
                        END.
                        ASSIGN p-de-qtd-trib = (de-peso-bru * p-de-qtd-trib) / de-qtd-item-nota[1].
                    END.
                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-qtd-item-nota[1] = ':U + STRING(de-qtd-item-nota[1])"}
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'p-de-qtd-trib (ap¢s c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                    END.                       
                END.
                ELSE DO: /* unidade de medida do ncm - usar fator de convers∆o */
                
                    ASSIGN de-fator-conv = DECIMAL(TRIM(SUBSTRING(item.char-1,321,20))). /* fator conv p/ unid tribut - tabela item */

                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Origem unidade tribut†vel: NCM':U"}
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'p-de-qtd-trib (antes c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Fator de convers∆o p/ unid tributavel (TRIM(SUBSTRING(item.char-1,321,20))) = ':U + STRING(de-fator-conv)"}
                    END.
                
                    IF  de-fator-conv = 0 THEN DO:
                        /* fator de convers∆o do relac item x cliente */
                        FOR FIRST item-cli FIELDS(fator-conversao num-casa-dec) NO-LOCK
                            WHERE item-cli.nome-abrev      = c-nome-abrev
                            AND   item-cli.it-codigo       = c-it-codigo
                            and   item-cli.unid-med-cli    = p-c-unid-trib
                            AND   item-cli.fator-conversao <> 0:
                            ASSIGN de-fator-conv = item-cli.fator-conversao / exp(10, item-cli.num-casa-dec).
                            IF l-log-negocio THEN DO:
                                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Fator de convers∆o do relacionamento item X cliente = ':U + STRING(de-fator-conv)"}
                            END.
                        END.
                    END.
                
                    IF  de-fator-conv = 0 THEN DO:
                        /* fator de convers∆o do item para unid de medida  */
                        FOR FIRST item-unid-venda FIELDS(fator-conversao num-casa-dec) NO-LOCK
                            WHERE item-unid-venda.it-codigo = c-it-codigo
                            AND   item-unid-venda.un        = p-c-unid-trib:
                            ASSIGN de-fator-conv = item-unid-venda.fator-conversao / exp(10, item-unid-venda.num-casa-dec).
                            IF l-log-negocio THEN DO:
                                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Fator de convers∆o do item para unidade de medida = ':U + STRING(de-fator-conv)"}
                            END.
                        END.
                    END.
                
                    IF  de-fator-conv = 0 THEN DO:
                        /* tabela de fator de conv */
                        FOR FIRST tab-conv-un FIELDS(num-casa-dec fator-conver) NO-LOCK
                            WHERE tab-conv-un.un           = c-unid-item-nota[1]
                            AND   tab-conv-un.unid-med-for = p-c-unid-trib:
                            /* este fator Ç da unidade do fornecedor p/ a unid do item */
                            ASSIGN de-fator-conv = EXP(10, tab-conv-un.num-casa-dec) / tab-conv-un.fator-conver.
                            IF l-log-negocio THEN DO:
                                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Fator de convers∆o da unidade do fornecedor para a unidade do item = ':U + STRING(de-fator-conv)"}
                            END.
                        END.
                    END.
                
                    IF  de-fator-conv <> 0 THEN 
                        ASSIGN p-de-qtd-trib = ROUND(p-de-qtd-trib * de-fator-conv, 4).
                    ELSE
                        ASSIGN p-de-qtd-trib      = 0.

                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Final convers∆o de-fator-conv = ':U + STRING(de-fator-conv)"}
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Final convers∆o p-de-qtd-trib (ap¢s c†lculo) = ':U + STRING(p-de-qtd-trib)"}
                    END.
                END.
            END.
        END.
        ELSE DO:
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'N∆o efetuou a convers∆o pois as unidades de medidas s∆o iguais.':U"}
            END.
        END.
    END.
    IF NOT AVAIL it-doc-fisc THEN DO:
        IF l-log-negocio THEN DO:
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'N∆o encontrado registro it-doc-fisc':U"}
        END.
    END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="1" &cMessage="'FIM piConverteQtdeEstatistica':U"}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaDueItemNFRefer DBOProgram 
PROCEDURE piCriaDueItemNFRefer :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel pela criaá∆o dos registros na tabela due-item-nf-refer
  Parameters:  pr-rowid-it-nota: Rowid do Item da Nota Fiscal (entrada) rowid
  Notes:       Criaá∆o dos registros das Notas Fiscais Referenciadas de forma autom†tica quando
               s∆o gerados os itens da DU-E atravÇs da tabela "it-nota-fisc".
               Estas notas s∆o informadas no programa CD4035 - Controle de Exportaá∆o por Item
               (exportaá∆o indireta);
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-rowid-it-nota AS ROWID NO-UNDO.

    DEFINE VARIABLE c-arq-log       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-log-negocio   AS LOGICAL     NO-UNDO.

    FOR FIRST it-nota-fisc
        WHERE ROWID(it-nota-fisc) = pr-rowid-it-nota NO-LOCK:

        ASSIGN l-log-negocio = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-log-negocio":U AND funcao.ativo).
                
        FOR FIRST due-nf FIELDS(cdd-due-ems cod-chave-aces-nf-eletro) 
            WHERE due-nf.cod-estabel-nf = it-nota-fisc.cod-estabel 
              AND due-nf.cod-serie-nf   = it-nota-fisc.serie       
              AND due-nf.cod-nota-fisc  = it-nota-fisc.nr-nota-fis NO-LOCK:

            ASSIGN c-arq-log = "LOG_NEGOCIO_due_":U + STRING(due-nf.cdd-due-ems) + ".txt":U.
        END.

        IF AVAIL due-nf THEN DO:
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="2" &iType="1" &cMessage="'CRIAR REGISTROS DAS NOTAS FISCAIS REFERENCIADAS (EXPORTAÄ«O INDIRETA)':U"}
            END.
        END.

        FOR FIRST due-item
            WHERE due-item.cod-estabel-nf  = it-nota-fisc.cod-estabel
              AND due-item.cod-serie-nf    = it-nota-fisc.serie
              AND due-item.cod-nota-fisc   = it-nota-fisc.nr-nota-fis
              AND due-item.num-seq-faturam = it-nota-fisc.nr-seq-fat
              AND due-item.cod-item        = it-nota-fisc.it-codigo NO-LOCK:

            /*Controle de Exportaá∆o por Item - Exportaá∆o Indireta*/
            IF CAN-FIND(FIRST nota-fisc-adc
                        WHERE nota-fisc-adc.cod-estab        = it-nota-fisc.cod-estabel
                          AND nota-fisc-adc.cod-serie        = it-nota-fisc.serie
                          AND nota-fisc-adc.cod-nota-fisc    = it-nota-fisc.nr-nota-fis
                          AND nota-fisc-adc.cod-natur-operac = it-nota-fisc.nat-operacao
                          AND nota-fisc-adc.idi-tip-dado     = 21 
                          AND nota-fisc-adc.num-seq          = it-nota-fisc.nr-seq-fat
                          AND nota-fisc-adc.cod-item         = it-nota-fisc.it-codigo) THEN DO:
                RUN piCriaRegistros (INPUT 21).
            END.
            ELSE DO:
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'N∆o encontrado registro nota-fisc-adc.':U"}
                END.
            END.
        END.
    END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="1" &iType="1" &cMessage="'FIM piCriaDueItemNFRefer':U"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRegistros DBOProgram 
PROCEDURE piCriaRegistros :
/*:T------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel pela criaá∆o dos registros na due-nf-refer
               de acordo com a nota fiscal referenciada (CD4035)
  Parameters:  pi-tip-dado    : Tipo do dado inserido no CD4035 (integer)
                                21 - Controle de Exportaá∆o por Item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-tip-dado LIKE nota-fisc-adc.idi-tip-dado NO-UNDO.
    
    DEFINE VARIABLE de-qtd-assoc  LIKE due-item-nf-refer.qtd-assoc NO-UNDO.
    DEFINE VARIABLE c-arq-log     AS   CHARACTER                   NO-UNDO.
    DEFINE VARIABLE l-log-negocio AS   LOGICAL                     NO-UNDO.

    ASSIGN c-arq-log     = "LOG_NEGOCIO_due_":U + STRING(due-item.cdd-due-ems) + ".txt":U
           l-log-negocio = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-log-negocio":U AND funcao.ativo).

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="2" &iType="1" &cMessage="'CRIAR REGISTRO due-item-nf-refer':U"}
    END.

    FOR EACH nota-fisc-adc
       WHERE nota-fisc-adc.cod-estab        = it-nota-fisc.cod-estabel
         AND nota-fisc-adc.cod-serie        = it-nota-fisc.serie
         AND nota-fisc-adc.cod-nota-fisc    = it-nota-fisc.nr-nota-fis
         AND nota-fisc-adc.cod-natur-operac = it-nota-fisc.nat-operacao
         AND nota-fisc-adc.idi-tip-dado     = pi-tip-dado 
         AND nota-fisc-adc.num-seq          = it-nota-fisc.nr-seq-fat 
         AND nota-fisc-adc.cod-item         = it-nota-fisc.it-codigo  NO-LOCK:

        IF l-log-negocio THEN DO:
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Validar se foi informado n£mero do RE/DU-e, chave de acesso NF-E e quantidade exportada (Exportaá∆o indireta)':U"}
            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nota Fiscal localizada: = ':U + nota-fisc-adc.cod-estab + ', ' + nota-fisc-adc.cod-serie + ', ' + nota-fisc-adc.cod-nota-fisc + ', ' + nota-fisc-adc.cod-natur-operac + ', ' + string(nota-fisc-adc.idi-tip-dado) + ', ' + string(nota-fisc-adc.num-seq) + ', ' + nota-fisc-adc.cod-item "}
        END.

        /*Os dados de exportaá∆o indireta n∆o s∆o obrigat¢rios, mas caso o usu†rio informe N£mero do RE,  Chave de Acesso 
          e Quantidade Exportada, a informaá∆o Ç obrigat¢ria. Mesma regra do adapter do XML da NF-e 4.0 (axsep027imprimexml.p)*/
        IF  nota-fisc-adc.cod-livre-2 <> "":U AND nota-fisc-adc.cod-livre-2 <> ? /*N£mero do RE/DU-E*/
        AND nota-fisc-adc.cod-livre-3 <> "":U AND nota-fisc-adc.cod-livre-3 <> ? /*Chave de Acesso da NF-e*/
        AND nota-fisc-adc.val-livre-1 <> 0    AND nota-fisc-adc.val-livre-1 <> ? /*Quantidade exportada*/ THEN DO:

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'N£mero do RE/DU-e, chave de acesso NF-e e quantidade exportada foram informados':U"}
            END.
        
            RUN piProximaSeq IN THIS-PROCEDURE (INPUT  due-item.cdd-due-ems,
                                                INPUT  due-item.num-versao-due,
                                                INPUT  due-item.num-seq-it-due,
                                                OUTPUT i-next-seq).

            FOR FIRST it-doc-fisc NO-LOCK
                WHERE it-doc-fisc.cod-estabel  = nota-fisc-adc.cod-estab
                  AND it-doc-fisc.serie        = nota-fisc-adc.cod-ser-docto-referado
                  AND it-doc-fisc.nr-doc-fis   = nota-fisc-adc.cod-docto-referado
                  AND it-doc-fisc.cod-emitente = nota-fisc-adc.cdn-emit-docto-referado
                  AND it-doc-fisc.nat-operacao = nota-fisc-adc.cod-livre-4
                  AND it-doc-fisc.nr-seq-doc   = nota-fisc-adc.num-livre-1:
                ASSIGN i-next-seq-siscomex = INT(it-doc-fisc.nr-seq-doc / 10).
            END.
            IF NOT AVAIL it-doc-fisc THEN
                RUN piProximaSeqSiscomex IN THIS-PROCEDURE (INPUT due-item.cdd-due-ems,
                                                            INPUT due-item.num-versao-due,
                                                            OUTPUT i-next-seq-siscomex).
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Sequencia Siscomex = ':U + string(i-next-seq-siscomex)"}
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Item do documento fiscal localizado = ':U + if avail it-doc-fisc then 'sim' else 'n∆o' "}
            END.

            FOR FIRST due-item-nf-refer
                WHERE due-item-nf-refer.cdd-due-ems           = due-item.cdd-due-ems
                  AND due-item-nf-refer.num-versao-due        = due-item.num-versao-due
                  AND due-item-nf-refer.num-seq-it-due        = due-item.num-seq-it-due
                  AND due-item-nf-refer.num-seq-nf-refer      = i-next-seq NO-LOCK:
            END.
        
            IF NOT AVAIL due-item-nf-refer THEN DO:
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Criar temp-table tt-due-item-nf-refer':U"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Emitente = ':U + STRING(nota-fisc-adc.cdn-emit-docto-referado)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Nat.Oper. = ':U + STRING(nota-fisc-adc.cod-livre-4)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Seq.It.Nota = ':U + STRING(nota-fisc-adc.num-livre-1)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Item = ':U + STRING(nota-fisc-adc.cod-item)"}
                END.
                CREATE tt-due-item-nf-refer.
                ASSIGN tt-due-item-nf-refer.cdd-due-ems                = due-item.cdd-due-ems    
                       tt-due-item-nf-refer.num-versao-due             = due-item.num-versao-due 
                       tt-due-item-nf-refer.num-seq-it-due             = due-item.num-seq-it-due 
                       tt-due-item-nf-refer.num-seq-nf-refer           = i-next-seq                  
                       tt-due-item-nf-refer.num-livre-2                = i-next-seq-siscomex /*Sequencia do Siscomex - sequencia do item da nota do documento*/
                       tt-due-item-nf-refer.cod-estab-nf-refer         = nota-fisc-adc.cod-estab
                       tt-due-item-nf-refer.cod-serie-nf-refer         = nota-fisc-adc.cod-ser-docto-referado
                       tt-due-item-nf-refer.cod-nota-fisc-refer        = nota-fisc-adc.cod-docto-referado
                       tt-due-item-nf-refer.num-livre-1                = nota-fisc-adc.cdn-emit-docto-referado  /*Emitente*/
                       OVERLAY(tt-due-item-nf-refer.cod-livre-1,1,6)   = nota-fisc-adc.cod-livre-4  /*Natureza de operaá∆o*/
                       tt-due-item-nf-refer.num-seq-faturam-refer      = nota-fisc-adc.num-livre-1 /*sequencia do item da nota*/
                       tt-due-item-nf-refer.cod-item-refer             = nota-fisc-adc.cod-item 
                       tt-due-item-nf-refer.idi-tip-nf                 = 2 /*Complementar*/
                       tt-due-item-nf-refer.cod-chave-aces-nf-refer    = nota-fisc-adc.cod-livre-3 /*Chave de acesso da nota*/
                       tt-due-item-nf-refer.cod-estab-proces-exp-refer = IF (pi-tip-dado = 3 OR pi-tip-dado = 21) THEN "":U ELSE due-item.cod-estab-proces-export
                       tt-due-item-nf-refer.cod-proces-exp-refer       = IF (pi-tip-dado = 3 OR pi-tip-dado = 21) THEN "":U ELSE due-item.cod-proces-export
                       tt-due-item-nf-refer.cod-chave-aces-nf-due      = IF AVAIL due-nf THEN due-nf.cod-chave-aces-nf-eletro ELSE "":U
                       tt-due-item-nf-refer.cod-estab-nf-due           = due-item.cod-estabel-nf
                       tt-due-item-nf-refer.cod-serie-nf-due           = due-item.cod-serie-nf
                       tt-due-item-nf-refer.cod-nota-fisc-due          = due-item.cod-nota-fisc
                       tt-due-item-nf-refer.cod-estab-proces-exp-due   = due-item.cod-estab-proces-export
                       tt-due-item-nf-refer.cod-proces-exp-due         = due-item.cod-proces-export
                       tt-due-item-nf-refer.num-seq-faturam-due        = due-item.num-seq-faturam
                       tt-due-item-nf-refer.num-seq-it-due             = due-item.num-seq-it-due
                       tt-due-item-nf-refer.cod-item-due               = due-item.cod-item.

                FOR FIRST natur-oper FIELDS(cod-cfop tipo)
                    WHERE natur-oper.nat-operacao = TRIM(SUBSTRING(tt-due-item-nf-refer.cod-livre-1,1,6)) NO-LOCK:
                    /*Se a nota referenciada tiver natureza cuja CFOP for de entrada de mercadoria com 
                      fim espec°fico de exportaá∆o ou for de sa°dacria como Remessa*/
                        IF  (natur-oper.cod-cfop = "1501":U OR
                             natur-oper.cod-cfop = "2501":U OR
                             natur-oper.cod-cfop = "5501":U OR
                             natur-oper.cod-cfop = "5502":U OR 
                             natur-oper.cod-cfop = "5504":U OR
                             natur-oper.cod-cfop = "5505":U OR
                             natur-oper.cod-cfop = "6501":U OR
                             natur-oper.cod-cfop = "6502":U OR 
                             natur-oper.cod-cfop = "6504":U OR
                             natur-oper.cod-cfop = "6505":U) THEN
                        ASSIGN tt-due-item-nf-refer.idi-tip-nf = 1. /*REMESSA*/
                        IF l-log-negocio THEN DO:
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Natureza de operaá∆o encontrada = ':U + STRING(TRIM(SUBSTRING(tt-due-item-nf-refer.cod-livre-1,1,6)))"}
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'CFOP (natur-oper.cod-cfop) = ':U + STRING(natur-oper.cod-cfop)"}
                        END.
                END.
                IF NOT AVAIL natur-oper THEN DO:
                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Natureza de operaá∆o n∆o encontrada = ':U + STRING(TRIM(SUBSTRING(tt-due-item-nf-refer.cod-livre-1,1,6)))"}
                    END.
                END.

                IF l-log-negocio THEN DO:
                    IF tt-due-item-nf-refer.idi-tip-nf = 1 THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Tipo de Nota: Remessa.':U"}
                    END.
                    IF tt-due-item-nf-refer.idi-tip-nf = 2 THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Tipo de Nota: Complementar.':U"}
                    END.

                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Quantidade associada = ':U + STRING(nota-fisc-adc.val-livre-1)"}
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'Iniciar convers∆o da quantidade estat°stica.':U"}
                END.

                /*
                    it-nota-fisc.un-fatur[2] -> unidade de medida faturamento
                    SUBSTRING(it-nota-fisc.char-1,419,2) -> unidade de medida tribut†vel
                 */
                IF it-nota-fisc.un-fatur[2] <> TRIM(SUBSTRING(it-nota-fisc.char-1,419,2)) THEN DO:
                    ASSIGN de-qtd-assoc = nota-fisc-adc.val-livre-1. /*quantidade associada: mesma informaªío enviada na tag "qExport" do XML da NF-e*/
                    RUN piConverteQtdeEstatistica IN THIS-PROCEDURE (INPUT tt-due-item-nf-refer.cod-estab-nf-refer,
                                                                     INPUT tt-due-item-nf-refer.cod-serie-nf-refer,
                                                                     INPUT tt-due-item-nf-refer.cod-nota-fisc-refer,
                                                                     INPUT TRIM(SUBSTRING(tt-due-item-nf-refer.cod-livre-1,1,6)), /*Natureza de operacao*/
                                                                     INPUT tt-due-item-nf-refer.num-livre-1,                      /*Emitente*/
                                                                     INPUT tt-due-item-nf-refer.num-seq-faturam-refer,            /* Sequencia do item da nota */
                                                                     INPUT-OUTPUT de-qtd-assoc).
    
                    ASSIGN tt-due-item-nf-refer.qtd-assoc = de-qtd-assoc. /*quantidade associada: convertida contra a 
                                                                            unidade de medida Estat°stica*/
                END.
                ELSE DO:
                    ASSIGN tt-due-item-nf-refer.qtd-assoc = nota-fisc-adc.val-livre-1.
                END.
                

                RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE tt-due-item-nf-refer).
                RUN createRecord IN THIS-PROCEDURE.
                DELETE tt-due-item-nf-refer.
            END.
        END.
    END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="1" &cMessage="'FIM piCriaRegistros':U"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesvinculaItemNfRefer DBOProgram 
PROCEDURE piDesvinculaItemNfRefer :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina os registros referente notas referenciadas quando desvincula a NF da DU-E 
  Parameters:  p-cdd-due-ems    : N£mero interno da DU-E - (input)(integer)
               p-num-versao-due : N£mero da vers∆o da DU-E - (input)(integer)
               p-num-seq-it-due: Sequància do Item da DU-e - (input integer)
       
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item-nf-refer.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item-nf-refer.num-versao-due NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-due  LIKE due-item-nf-refer.num-seq-it-due NO-UNDO.
 
    FOR EACH bfdue-item-nf-refer
       WHERE bfdue-item-nf-refer.cdd-due-ems    = p-cdd-due-ems 
         AND bfdue-item-nf-refer.num-versao-due = p-num-versao-due
         AND bfdue-item-nf-refer.num-seq-it-due = p-num-seq-it-due EXCLUSIVE-LOCK:

        DELETE bfdue-item-nf-refer.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaSeq DBOProgram 
PROCEDURE piProximaSeq :
/*------------------------------------------------------------------------------
  Purpose:     Sugere pr¢xima sequencia da nota Referenciada no item da DU-E
  Parameters:   Entrada:    p-cdd-due-ems     : C¢digo interno da DU-E (decimal)
                            p-num-versao-due  : Vers∆o da DU-E         (integer)
                            p-num-seq-it-due  : Seq Item da DU-E       (integer)
                            p-num-seq-nf-refer: Seq Item da NF Refer   (integer)
                Sa°da p-next-seq: pr¢xima numeraá∆o sugerida pelo sistema (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdd-due-ems      LIKE bf{&TableName}.cdd-due-ems       NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-versao-due   LIKE bf{&TableName}.num-versao-due    NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq-it-due   LIKE bf{&TableName}.num-seq-it-due    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-next-seq         LIKE bf{&TableName}.num-seq-nf-refer  NO-UNDO.

    FIND LAST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdd-due-ems      = p-cdd-due-ems    
          AND bf{&TableName}.num-versao-due   = p-num-versao-due 
          AND bf{&TableName}.num-seq-it-due   = p-num-seq-it-due NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-next-seq = 1.
    ELSE 
        ASSIGN p-next-seq = bf{&TableName}.num-seq-nf-refer + 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaSeqSiscomex DBOProgram 
PROCEDURE piProximaSeqSiscomex :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o proximo sequencial do siscomex para os itens das notas referenciadas
  Parameters:   Entrada:    p-cdd-due-ems     : C¢digo interno da DU-E (decimal)
                            p-num-versao-due  : Vers∆o da DU-E         (integer)
                Sa°da p-next-seq: pr¢xima sequencia da DU-E Siscomex (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdd-due-ems      LIKE bf{&TableName}.cdd-due-ems       NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-versao-due   LIKE bf{&TableName}.num-versao-due    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-next-seq         LIKE bf{&TableName}.num-seq-nf-refer  NO-UNDO.

    FIND LAST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdd-due-ems      = p-cdd-due-ems    
          AND bf{&TableName}.num-versao-due   = p-num-versao-due NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-next-seq = 1.
    ELSE 
        ASSIGN p-next-seq = bf{&TableName}.num-livre-2 + 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resequenciaItensReferDue DBOProgram 
PROCEDURE resequenciaItensReferDue :
/*:T------------------------------------------------------------------------------
  Purpose:     Resequenciar os itens das notas referenciadas no campo Sequància do Siscomex
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems  LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao LIKE due-item.num-versao-due NO-UNDO.

    DEFINE VARIABLE i-num-seq-siscomex AS INTEGER NO-UNDO.

    FOR EACH bf{&TableName} FIELDS(num-livre-2)
       WHERE bf{&TableName}.cdd-due-ems = pcdd-due-ems
         AND bf{&TableName}.num-versao-due  = pi-num-versao EXCLUSIVE-LOCK
         BREAK BY bf{&TableName}.num-seq-it-due:

        FOR FIRST it-doc-fisc NO-LOCK
            WHERE it-doc-fisc.cod-estabel  = bf{&TableName}.cod-estab-nf-refer
              AND it-doc-fisc.serie        = bf{&TableName}.cod-serie-nf-refer
              AND it-doc-fisc.nr-doc-fis   = bf{&TableName}.cod-nota-fisc-refer
              AND it-doc-fisc.cod-emitente = bf{&TableName}.num-livre-1
              AND it-doc-fisc.nat-operacao = SUBSTRING(bf{&TableName}.cod-livre-1,1,6)
              AND it-doc-fisc.nr-seq-doc   = bf{&TableName}.num-seq-faturam-refer:
            ASSIGN i-num-seq-siscomex            = INT(it-doc-fisc.nr-seq-doc / 10)
                   due-item-nf-refer.num-livre-2 = i-num-seq-siscomex.
        END.

        IF NOT AVAIL it-doc-fisc THEN
           ASSIGN i-num-seq-siscomex         = i-num-seq-siscomex + 1
                  bf{&TableName}.num-livre-2 = i-num-seq-siscomex.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDUE DBOProgram 
PROCEDURE setConstraintOfDUE :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "byNF" e "ByNFProcExp"
  Parameters:  Entrada: pde-cdd-due-ems (decimal) C¢digo Interno da DU-E no sistema
               Entrada: pi-num-versao-due (decimal) Vers∆o da DU-E no sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-due-ems   LIKE {&TableName}.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao-due LIKE {&TableName}.num-versao-due NO-UNDO.

    ASSIGN de-cdd-due-ems   = pde-cdd-due-ems
           i-num-versao-due = pi-num-versao-due.

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

    DEFINE VARIABLE de-total        LIKE due-item-nf-refer.qtd-assoc NO-UNDO.
    DEFINE VARIABLE de-qtd-assoc    LIKE due-item-nf-refer.qtd-assoc NO-UNDO.
    DEFINE VARIABLE de-saldo        LIKE due-item-nf-refer.qtd-assoc NO-UNDO.
    DEFINE VARIABLE de-quantidade   LIKE it-doc-fisc.quantidade      NO-UNDO.
    DEFINE VARIABLE de-qtd-due-item LIKE due-item-nf-refer.qtd-assoc NO-UNDO.
    DEFINE VARIABLE iCont           AS INTEGER                       NO-UNDO.
    DEFINE VARIABLE lCriaViaImport  AS LOGICAL                       NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    /*Realiza as validaá‰es de quantidade na criaá∆o das notas referenciadas apenas 
    quando for importado via planilha, caso buscada automaticamente do CD4035 pressup‰e-se que as quantidades 
    estejam corretas e caso haja problemas o Siscomex validar†*/

    ASSIGN iCont = 1.
    REPEAT WHILE PROGRAM-NAME(iCont) <> ?.
        IF INDEX(PROGRAM-NAME(iCont), "exapi027") > 0 THEN DO:
            ASSIGN lCriaViaImport = YES.
            LEAVE.
        END.
        ELSE DO:
            iCont = iCont + 1.
        END.
    END.

    IF lCriaViaImport THEN DO:
	    /* busca a quantidade da nota */
	    FOR FIRST doc-fiscal NO-LOCK
	        WHERE doc-fiscal.cod-estabel  = RowObject.cod-estab-nf-refer
	        AND   doc-fiscal.serie        = RowObject.cod-serie-nf-refer
	        AND   doc-fiscal.nr-doc-fis   = RowObject.cod-nota-fisc-refer
	        AND   doc-fiscal.cod-emitente = INTEGER(RowObject.num-livre-1)
	        AND   doc-fiscal.nat-operacao = TRIM(SUBSTRING(RowObject.cod-livre-1,1,6)):
	
	        FOR EACH it-doc-fisc NO-LOCK 
	            WHERE it-doc-fisc.cod-estabel  = doc-fiscal.cod-estabel 
	            AND   it-doc-fisc.serie        = doc-fiscal.serie       
	            AND   it-doc-fisc.nr-doc-fis   = doc-fiscal.nr-doc-fis  
	            AND   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
	            AND   it-doc-fisc.nat-operacao = doc-fiscal.nat-operacao
	            AND   it-doc-fisc.nr-seq-doc   = INTEGER(RowObject.num-seq-faturam-refer)
	            AND   it-doc-fisc.it-codigo    = RowObject.cod-item-refer:
	
	            ASSIGN de-quantidade = it-doc-fisc.quantidade.
	            /* Converte a quantidade para quantidade estat°stica */
	            RUN piConverteQtdeEstatistica IN THIS-PROCEDURE (INPUT it-doc-fisc.cod-estabel,
	                                                             INPUT it-doc-fisc.serie,
	                                                             INPUT it-doc-fisc.nr-doc-fis,
	                                                             INPUT it-doc-fisc.nat-operacao,
	                                                             INPUT it-doc-fisc.cod-emitente,
                                                                 INPUT it-doc-fisc.nr-seq-doc,
	                                                             INPUT-OUTPUT de-quantidade).
	            ASSIGN de-total = de-total + de-quantidade. //acumula a quantidade total da nota
	        END.
	    END.
	
	    /* Verifica se h† alguma nota referenciada com a mesma chave para validar se h† quantidade parcial alocada */
	    ASSIGN de-qtd-assoc = 0.
	    FOR EACH bf{&TableName} NO-LOCK
	        WHERE bf{&TableName}.cod-estab-nf-refer                 =  RowObject.cod-estab-nf-refer
	        AND   bf{&TableName}.cod-serie-nf-refer                 =  RowObject.cod-serie-nf-refer
	        AND   bf{&TableName}.cod-nota-fisc-refer                =  RowObject.cod-nota-fisc-refer
	        AND   bf{&TableName}.num-livre-1                        =  RowObject.num-livre-1
	        AND   bf{&TableName}.cod-item-due                       =  RowObject.cod-item-due
	        AND   TRIM(SUBSTRING(bf{&TableName}.cod-livre-1,1,6))   =  TRIM(SUBSTRING(RowObject.cod-livre-1,1,6)):
	        
	        ASSIGN de-qtd-assoc = de-qtd-assoc + bf{&TableName}.qtd-assoc.
	    END.
	
	    /* Verifica se o total da nota - quantidades parciais vinculadas Ç menor que a quantidade que est† tentando alocar */
	    ASSIGN de-saldo  = de-total - de-qtd-assoc.
	    IF de-saldo < RowObject.qtd-assoc THEN DO:
	        //1303 - Quantidade maior que saldo
	        {method/svc/errors/inserr.i
	              &ErrorNumber="1303"
	              &ErrorType="EMS"
	              &ErrorParameters="''"}
	        RETURN "NOK":U.
	    END.
	
	    /* valida se a quantidade Ç menor que a quantidade do item da fatura (due-item.qtd-estatis) */
	    ASSIGN de-qtd-due-item = 0.
	    FOR EACH bf{&TableName} NO-LOCK
	        WHERE bf{&TableName}.cod-estab-nf-due    = RowObject.cod-estab-nf-due   
	        AND   bf{&TableName}.cod-serie-nf-due    = RowObject.cod-serie-nf-due   
	        AND   bf{&TableName}.cod-nota-fisc-due   = RowObject.cod-nota-fisc-due  
	        AND   bf{&TableName}.num-seq-faturam-due = RowObject.num-seq-faturam-due
	        AND   bf{&TableName}.cod-item-due        = RowObject.cod-item-due:
	        ASSIGN de-qtd-due-item = de-qtd-due-item + bf{&TableName}.qtd-assoc.
	    END.
	    FOR FIRST due-item FIELDS(cdd-due-ems cod-estabel-nf cod-serie-nf cod-nota-fisc num-seq-faturam cod-item qtd-estatis) NO-LOCK
	        WHERE due-item.cdd-due-ems     = RowObject.cdd-due-ems
	        AND   due-item.cod-estabel-nf  = RowObject.cod-estab-nf-due
	        AND   due-item.cod-serie-nf    = RowObject.cod-serie-nf-due
	        AND   due-item.cod-nota-fisc   = RowObject.cod-nota-fisc-due
	        AND   due-item.num-seq-faturam = RowObject.num-seq-faturam-due
	        AND   due-item.cod-item        = RowObject.cod-item-due:
	
	        IF (de-qtd-due-item + RowObject.qtd-assoc) > due-item.qtd-estatis THEN DO:
	            //18816 - Quantidade informado ultrapassa o permitido.
	            {method/svc/errors/inserr.i
	                  &ErrorNumber="18816"
	                  &ErrorType="EMS"
	                  &ErrorParameters="''"}
	            RETURN "NOK":U.
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

