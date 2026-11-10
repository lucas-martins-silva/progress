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
{include/i-prgvrs.i BOIN877 2.00.00.003 } /*** "010003" 13/11/2023 11:45:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin877 MRE}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN877
&GLOBAL-DEFINE DBOVersion 2
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-manif-destin
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
{inbo/boin877.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro  AS character INITIAL ?.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEFINE VARIABLE i-num-emit-ini                LIKE docto-manif-destin.num-emit.
DEFINE VARIABLE i-num-emit-fim                LIKE docto-manif-destin.num-emit.
DEFINE VARIABLE c-cod-estab-ini               LIKE docto-manif-destin.cod-estab.
DEFINE VARIABLE c-cod-estab-fim               LIKE docto-manif-destin.cod-estab.
DEFINE VARIABLE c-serie-ini                   LIKE docto-manif-destin.cod-ser-docto.
DEFINE VARIABLE c-serie-fim                   LIKE docto-manif-destin.cod-ser-docto.
DEFINE VARIABLE c-cod-docto-ini               LIKE docto-manif-destin.cod-docto.
DEFINE VARIABLE c-cod-docto-fim               LIKE docto-manif-destin.cod-docto.
DEFINE VARIABLE d-dt-emissao-ini              LIKE docto-manif-destin.dat-emis-nf-eletro.
DEFINE VARIABLE d-dt-emissao-fim              LIKE docto-manif-destin.dat-emis-nf-eletro.
DEFINE VARIABLE c-cod-ult-seqcial-unico       LIKE docto-manif-destin.cod-ult-seqcial-unico.
DEFINE VARIABLE c-cod-chave-nfe               LIKE docto-manif-destin.cod-chave-nfe.

DEFINE VARIABLE i-log-sit-manif      AS LOGICAL EXTENT 6 NO-UNDO.

DEFINE TEMP-TABLE tt-selec-docto
    FIELD cod-versao         AS CHARACTER
    FIELD cod-estab          AS CHARACTER
    FIELD ident              AS CHARACTER
    FIELD ambiente           AS INTEGER
    FIELD cod-chave-nfe      AS CHARACTER
    FIELD tp-evento          AS CHARACTER 
    FIELD justificativa      AS CHARACTER FORMAT "x(1000)"
    FIELD des-dat-hora-event AS CHARACTER.


DEFINE VARIABLE h-axsep020 AS HANDLE NO-UNDO.

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
         HEIGHT             = 19.17
         WIDTH              = 63.86.
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
        WHEN "cod-cancel-ult-seqcial-unico":U THEN ASSIGN pFieldValue = RowObject.cod-cancel-ult-seqcial-unico.
        WHEN "cod-cgc-emit-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-cgc-emit-nf-eletro.
        WHEN "cod-chave-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-chave-nfe.
        WHEN "cod-cpf-emit-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-cpf-emit-nf-eletro.
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-ident-empres":U THEN ASSIGN pFieldValue = RowObject.cod-ident-empres.
        WHEN "cod-inscr-estad-emit-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-inscr-estad-emit-nf-eletro.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nat-operac":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operac.
        WHEN "cod-padr-horar-carta-correc":U THEN ASSIGN pFieldValue = RowObject.cod-padr-horar-carta-correc.
        WHEN "cod-respos-status":U THEN ASSIGN pFieldValue = RowObject.cod-respos-status.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-ult-seqcial-carta-correc":U THEN ASSIGN pFieldValue = RowObject.cod-ult-seqcial-carta-correc.
        WHEN "cod-ult-seqcial-unico":U THEN ASSIGN pFieldValue = RowObject.cod-ult-seqcial-unico.
        WHEN "des-respos-desc":U THEN ASSIGN pFieldValue = RowObject.des-respos-desc.
        WHEN "dsl-correc":U THEN ASSIGN pFieldValue = RowObject.dsl-correc.
        WHEN "dsl-xml-sefaz":U THEN ASSIGN pFieldValue = RowObject.dsl-xml-sefaz.
        WHEN "hra-emis-carta-correc-eletro":U THEN ASSIGN pFieldValue = RowObject.hra-emis-carta-correc-eletro.
        WHEN "ind-sit-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.ind-sit-nf-eletro.
        WHEN "nom-emitente":U THEN ASSIGN pFieldValue = RowObject.nom-emitente.
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
        WHEN "dat-autoriz-cancel":U THEN ASSIGN pFieldValue = RowObject.dat-autoriz-cancel.
        WHEN "dat-autoriz-carta-correc-eletro":U THEN ASSIGN pFieldValue = RowObject.dat-autoriz-carta-correc-eletro.
        WHEN "dat-autoriz-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.dat-autoriz-nf-eletro.
        WHEN "dat-emis-cancel":U THEN ASSIGN pFieldValue = RowObject.dat-emis-cancel.
        WHEN "dat-emis-carta-correc-eletro":U THEN ASSIGN pFieldValue = RowObject.dat-emis-carta-correc-eletro.
        WHEN "dat-emis-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.dat-emis-nf-eletro.
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
        WHEN "val-tot":U THEN ASSIGN pFieldValue = RowObject.val-tot.
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
        WHEN "idi-ambien-manif":U THEN ASSIGN pFieldValue = RowObject.idi-ambien-manif.
        WHEN "idi-sit-manif-destin":U THEN ASSIGN pFieldValue = RowObject.idi-sit-manif-destin.
        WHEN "idi-tip-operac":U THEN ASSIGN pFieldValue = RowObject.idi-tip-operac.
        WHEN "num-emit":U THEN ASSIGN pFieldValue = RowObject.num-emit.
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
  Purpose:     Retorna valores dos campos do °ndice ix-ch-nfe
  Parameters:  
               retorna valor do campo cod-chave-nfe
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-chave-nfe LIKE docto-manif-destin.cod-chave-nfe NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-chave-nfe = RowObject.cod-chave-nfe.

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
  Purpose:     Reposiciona registro com base no °ndice ix-ch-nfe
  Parameters:  
               recebe valor do campo cod-chave-nfe
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-chave-nfe LIKE docto-manif-destin.cod-chave-nfe NO-UNDO.

    FIND FIRST bfdocto-manif-destin WHERE 
        bfdocto-manif-destin.cod-chave-nfe = pcod-chave-nfe NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-manif-destin THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-manif-destin)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocto DBOProgram 
PROCEDURE openQueryDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
     WHERE {&tableName}.num-emit           >= i-num-emit-ini 
       AND {&tableName}.num-emit           <= i-num-emit-fim  
       AND {&tableName}.cod-estab          >= c-cod-estab-ini   
       AND {&tableName}.cod-estab          <= c-cod-estab-fim   
       AND {&tableName}.cod-ser-docto      >= c-serie-ini         
       AND {&tableName}.cod-ser-docto      <= c-serie-fim         
       AND {&tableName}.cod-docto          >= c-cod-docto-ini     
       AND {&tableName}.cod-docto          <= c-cod-docto-fim     
       AND {&tableName}.dat-emis-nf-eletro >= d-dt-emissao-ini    
       AND {&tableName}.dat-emis-nf-eletro <= d-dt-emissao-fim    
       AND ({&tableName}.cod-ult-seqcial-unico = c-cod-ult-seqcial-unico OR
            c-cod-ult-seqcial-unico = "")
       AND ({&tableName}.cod-chave-nfe    = c-cod-chave-nfe OR
            c-cod-chave-nfe = "")
       AND (({&tableName}.idi-sit-manif-destin = 1 AND i-log-sit-manif[1] = YES) OR
            ({&tableName}.idi-sit-manif-destin = 2 AND i-log-sit-manif[2] = YES) OR
            ({&tableName}.idi-sit-manif-destin = 3 AND i-log-sit-manif[3] = YES) OR
            ({&tableName}.idi-sit-manif-destin = 4 AND i-log-sit-manif[4] = YES) OR
            ({&tableName}.idi-sit-manif-destin = 5 AND i-log-sit-manif[5] = YES) OR
            ({&tableName}.idi-sit-manif-destin = 6 AND i-log-sit-manif[6] = YES))
       INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryMain DBOProgram 
PROCEDURE openqueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RealizaManifesto DBOProgram 
PROCEDURE RealizaManifesto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-selec-docto.

IF NOT VALID-HANDLE(h-axsep020) THEN
    RUN adapters\xml\ep2\axsep020.p PERSISTENT SET h-axsep020.

RUN PITransUpsert IN h-axsep020 (INPUT "upd", 
                                 INPUT "RemessaEvento", 
                                 INPUT TABLE tt-selec-docto,
                                 OUTPUT TABLE tt_log_erro).

IF VALID-HANDLE(h-axsep020) THEN
    DELETE OBJECT h-axsep020.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocto DBOProgram 
PROCEDURE setConstraintDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-num-emit-ini       LIKE docto-manif-destin.num-emit.
define input param p-num-emit-fim       LIKE docto-manif-destin.num-emit.
define input param p-cod-estab-ini      LIKE docto-manif-destin.cod-estab.
define input param p-cod-estab-fim      LIKE docto-manif-destin.cod-estab.
define input param p-serie-ini          LIKE docto-manif-destin.cod-ser-docto.
define input param p-serie-fim          LIKE docto-manif-destin.cod-ser-docto.
define input param p-cod-docto-ini      LIKE docto-manif-destin.cod-docto.
define input param p-cod-docto-fim      LIKE docto-manif-destin.cod-docto.
define input param p-dt-emissao-ini     LIKE docto-manif-destin.dat-emis-nf-eletro.
define input param p-dt-emissao-fim     LIKE docto-manif-destin.dat-emis-nf-eletro.
define input param p-nr-nsu             LIKE docto-manif-destin.cod-ult-seqcial-unico.
define input param p-cod-chave-nfe      LIKE docto-manif-destin.cod-chave-nfe.
DEFINE INPUT PARAM p-log-sit-manif      AS LOGICAL EXTENT 6 NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN i-num-emit-ini          = p-num-emit-ini  
       i-num-emit-fim          = p-num-emit-fim  
       c-cod-estab-ini         = p-cod-estab-ini   
       c-cod-estab-fim         = p-cod-estab-fim   
       c-serie-ini             = p-serie-ini         
       c-serie-fim             = p-serie-fim         
       c-cod-docto-ini         = p-cod-docto-ini     
       c-cod-docto-fim         = p-cod-docto-fim     
       d-dt-emissao-ini        = p-dt-emissao-ini    
       d-dt-emissao-fim        = p-dt-emissao-fim    
       c-cod-ult-seqcial-unico = p-nr-nsu            
       c-cod-chave-nfe         = p-cod-chave-nfe.


DO i-cont = 1 TO 6:
    ASSIGN i-log-sit-manif[i-cont] = p-log-sit-manif[i-cont].
END.


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

