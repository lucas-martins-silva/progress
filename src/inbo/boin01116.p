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
{include/i-prgvrs.i BOIN01116 2.00.00.002 } /*** "010002" 17/06/2025 16:40:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN01116 MCE}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01116
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ws-inventario-externo
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
{inbo/BOIN01116.i RowObject}


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

DEFINE VARIABLE  c-it-codigo-ini       LIKE ws-inventario-externo.it-codigo         no-undo.      
DEFINE VARIABLE  c-it-codigo-fim       LIKE ws-inventario-externo.it-codigo         no-undo.      
DEFINE VARIABLE  c-ge-codigo-ini       LIKE ITEM.ge-codigo                          no-undo.                       
DEFINE VARIABLE  c-ge-codigo-fim       LIKE ITEM.ge-codigo                          no-undo.                       
DEFINE VARIABLE  c-fm-codigo-ini       LIKE ITEM.fm-codigo                          no-undo.                       
DEFINE VARIABLE  c-fm-codigo-fim       LIKE ITEM.fm-codigo                          no-undo.                       
DEFINE VARIABLE  c-cod-depos-ini       LIKE ws-inventario-externo.cod-depos         no-undo.      
DEFINE VARIABLE  c-cod-depos-fim       LIKE ws-inventario-externo.cod-depos         no-undo. 
DEFINE VARIABLE  c-lote-ini            LIKE ws-inventario-externo.lote              no-undo. 
DEFINE VARIABLE  c-lote-fim            LIKE ws-inventario-externo.lote              no-undo. 
DEFINE VARIABLE  c-cod-refer-ini       LIKE ws-inventario-externo.cod-refer         no-undo. 
DEFINE VARIABLE  c-cod-refer-fim       LIKE ws-inventario-externo.cod-refer         no-undo. 
DEFINE VARIABLE  c-id-conta-ini        LIKE ws-inventario-externo.id-inventario-ext no-undo. 
DEFINE VARIABLE  c-id-conta-fim        LIKE ws-inventario-externo.id-inventario-ext no-undo. 
DEFINE VARIABLE  c-cod-estabel-ini     LIKE ws-inventario-externo.cod-estabel       no-undo.    
DEFINE VARIABLE  c-cod-estabel-fim     LIKE ws-inventario-externo.cod-estabel       no-undo.    
DEFINE VARIABLE  d-dt-contagem-ini     LIKE ws-inventario-externo.dat-contagem-ext  no-undo.
DEFINE VARIABLE  d-dt-contagem-fim     LIKE ws-inventario-externo.dat-contagem-ext  no-undo.
DEFINE VARIABLE  c-cod-usuar-ini       LIKE ws-inventario-externo.cod-usuar         no-undo.
DEFINE VARIABLE  c-cod-usuar-fim       LIKE ws-inventario-externo.cod-usuar         no-undo.
DEFINE VARIABLE  l-ind-sit             AS LOGICAL EXTENT 4                          NO-UNDO.
DEFINE VARIABLE  l-dif-cont            AS LOGICAL                                   no-undo.               



DEFINE TEMP-TABLE tt-selec-contagem
    FIELD cod-versao         AS CHARACTER
    FIELD cod-estab          AS CHARACTER
    FIELD ident              AS CHARACTER
    FIELD ambiente           AS INTEGER
    FIELD cod-chave-nfe      AS CHARACTER
    FIELD tp-evento          AS CHARACTER 
    FIELD justificativa      AS CHARACTER FORMAT "x(1000)"
    FIELD des-dat-hora-event AS CHARACTER.



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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "id-inventario-ext":U THEN ASSIGN pFieldValue = RowObject.id-inventario-ext.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "justificativa":U THEN ASSIGN pFieldValue = RowObject.justificativa.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-contagem-ext":U THEN ASSIGN pFieldValue = RowObject.dat-contagem-ext.
        WHEN "dat-val-lote":U THEN ASSIGN pFieldValue = RowObject.dat-contagem-ext.
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
        WHEN "qtde-contagem":U THEN ASSIGN pFieldValue = RowObject.qtde-contagem.
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
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        WHEN "num-inventario-ext":U THEN ASSIGN pFieldValue = RowObject.num-inventario-ext.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pk-num-seq
  Parameters:  
               retorna valor do campo id-inventario-ext
               retorna valor do campo num-inventario-ext
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pid-inventario-ext  LIKE ws-inventario-externo.id-inventario-ext  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-inventario-ext LIKE ws-inventario-externo.num-inventario-ext NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeposito-ext       LIKE ws-inventario-externo.cod-depos          NO-UNDO.
    DEFINE OUTPUT PARAMETER pestabel-ext        LIKE ws-inventario-externo.cod-estabel        NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo-ext      LIKE ws-inventario-externo.it-codigo          NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer-ext      LIKE ws-inventario-externo.cod-refer          NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz        LIKE ws-inventario-externo.cod-localiz        NO-UNDO.
    DEFINE OUTPUT PARAMETER plote-ext           LIKE ws-inventario-externo.lote               NO-UNDO.  

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pid-inventario-ext  = RowObject.id-inventario-ext
           pnum-inventario-ext = RowObject.num-inventario-ext
           pdeposito-ext       = RowObject.cod-depos
           pestabel-ext        = RowObject.cod-estabel
           pit-codigo-ext      = RowObject.it-codigo
           pcod-refer-ext      = RowObject.cod-refer
           pcod-localiz        = RowObject.cod-localiz
           plote-ext           = RowObject.lote.

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
        WHEN "log-gerou-dif-contagem":U THEN ASSIGN pFieldValue = RowObject.log-gerou-dif-contagem.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram  
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice pk-num-seq
  Parameters:  
               recebe valor do campo id-inventario-ext
               recebe valor do campo num-inventario-ext
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pid-inventario-ext  LIKE ws-inventario-externo.id-inventario-ext NO-UNDO.
    DEFINE INPUT PARAMETER pnum-inventario-ext LIKE ws-inventario-externo.num-inventario-ext NO-UNDO.
    DEFINE INPUT PARAMETER pdeposito-ext       LIKE ws-inventario-externo.cod-depos          NO-UNDO.
    DEFINE INPUT PARAMETER pestabel-ext        LIKE ws-inventario-externo.cod-estabel        NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo-ext      LIKE ws-inventario-externo.it-codigo          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer-ext      LIKE ws-inventario-externo.cod-refer          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz        LIKE ws-inventario-externo.cod-localiz        NO-UNDO.
    DEFINE INPUT PARAMETER plote-ext           LIKE ws-inventario-externo.lote               NO-UNDO. 

    FIND FIRST bfws-inventario-externo WHERE 
               bfws-inventario-externo.id-inventario-ext  = pid-inventario-ext AND 
               bfws-inventario-externo.num-inventario-ext = pnum-inventario-ext AND 
               bfws-inventario-externo.cod-depos          = pdeposito-ext and
               bfws-inventario-externo.cod-estabel        = pestabel-ext AND 
               bfws-inventario-externo.it-codigo          = pit-codigo-ext AND 
               bfws-inventario-externo.cod-refer          = pcod-refer-ext AND 
               bfws-inventario-externo.cod-localiz        = pcod-localiz AND 
               bfws-inventario-externo.lote               = plote-ext NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfws-inventario-externo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfws-inventario-externo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContagem DBOProgram 
PROCEDURE openQueryContagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 
  OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
     WHERE {&tableName}.it-codigo           >= c-it-codigo-ini                                  
       AND {&tableName}.it-codigo           <= c-it-codigo-fim                            
       AND {&tableName}.cod-estabel           >= c-cod-estabel-ini                            
       AND {&tableName}.cod-estabel           <= c-cod-estabel-fim                            
       AND {&tableName}.cod-depos           >= c-cod-depos-ini
       AND {&tableName}.cod-depos           <= c-cod-depos-fim  
       AND {&tableName}.lote                >= c-lote-ini     
       AND {&tableName}.lote                <= c-lote-fim     
       AND {&tableName}.cod-refer           >= c-cod-refer-ini
       AND {&tableName}.cod-refer           <= c-cod-refer-fim
       AND {&tableName}.id-inventario-ext   >= c-id-conta-ini 
       AND {&tableName}.id-inventario-ext   <= c-id-conta-fim 
       AND {&tableName}.dat-contagem-ext    >= d-dt-contagem-ini
       AND {&tableName}.dat-contagem-ext    <= d-dt-contagem-fim  
       AND {&tableName}.cod-usuar           >= c-cod-usuar-ini                               
       AND {&tableName}.cod-usuar           <= c-cod-usuar-fim  
      
       AND (({&tableName}.ind-situacao = 1 AND l-ind-sit[1] = YES) OR
            ({&tableName}.ind-situacao = 2 AND l-ind-sit[2] = YES) OR
            ({&tableName}.ind-situacao = 3 AND l-ind-sit[3] = YES) OR
            ({&tableName}.ind-situacao = 4 AND l-ind-sit[4] = YES) )
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContagem DBOProgram 
PROCEDURE setConstraintContagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-it-codigo-ini      LIKE ws-inventario-externo.it-codigo.
define input param p-it-codigo-fim      LIKE ws-inventario-externo.it-codigo.
define input param p-ge-codigo-ini      LIKE ITEM.ge-codigo.
define input param p-ge-codigo-fim      LIKE ITEM.ge-codigo.
define input param p-fm-codigo-ini      LIKE ITEM.fm-codigo.
define input param p-fm-codigo-fim      LIKE ITEM.fm-codigo.
define input param p-cod-depos-ini      LIKE ws-inventario-externo.cod-depos.
define input param p-cod-depos-fim      LIKE ws-inventario-externo.cod-depos.
DEFINE INPUT PARAM P-lote-ini           LIKE ws-inventario-externo.lote.          
DEFINE INPUT PARAM P-lote-fim           LIKE ws-inventario-externo.lote.       
DEFINE INPUT PARAM P-cod-refer-ini      LIKE ws-inventario-externo.cod-refer.    
DEFINE INPUT PARAM P-cod-refer-fim      LIKE ws-inventario-externo.cod-refer.    
DEFINE INPUT PARAM P-id-conta-ini       LIKE ws-inventario-externo.id-inventario-ext.     
DEFINE INPUT PARAM P-id-conta-fim       LIKE ws-inventario-externo.id-inventario-ext.
define input param p-cod-estabel-ini    LIKE ws-inventario-externo.cod-estabel.
define input param p-cod-estabel-fim    LIKE ws-inventario-externo.cod-estabel.
define input param p-dt-contagem-ini    LIKE ws-inventario-externo.dat-contagem-ext.
define input param p-dt-contaem-fim     LIKE ws-inventario-externo.dat-contagem-ext.
define input param p-cod-usuar-ini      LIKE ws-inventario-externo.cod-usuar.
define input param p-cod-usuar-fim      LIKE ws-inventario-externo.cod-usuar.
define input param p-ind-sit            AS LOGICAL EXTENT 4 NO-UNDO.
DEFINE INPUT PARAM p-ind-dif-cont       AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN c-it-codigo-ini    = p-it-codigo-ini  
       c-it-codigo-fim    = p-it-codigo-fim  
       c-ge-codigo-ini    = p-ge-codigo-ini   
       c-ge-codigo-fim    = p-ge-codigo-fim   
       c-fm-codigo-ini    = p-fm-codigo-ini     
       c-fm-codigo-fim    = p-fm-codigo-fim     
       c-cod-depos-ini    = p-cod-depos-ini     
       c-cod-depos-fim    = p-cod-depos-fim 
       c-lote-ini         = P-lote-ini       
       c-lote-fim         = P-lote-fim       
       c-cod-refer-ini    = P-cod-refer-ini  
       c-cod-refer-fim    = P-cod-refer-fim  
       c-id-conta-ini     = P-id-conta-ini   
       c-id-conta-fim     = P-id-conta-fim   
       c-cod-estabel-ini  = p-cod-estabel-ini   
       c-cod-estabel-fim  = p-cod-estabel-fim   
       d-dt-contagem-ini  = p-dt-contagem-ini   
       d-dt-contagem-fim  = p-dt-contaem-fim 
       c-cod-usuar-ini    = p-cod-usuar-ini   
       c-cod-usuar-fim    = p-cod-usuar-fim 
       l-dif-cont         = p-ind-dif-cont.  

DO i-cont = 1 TO 4:
    ASSIGN l-ind-sit[i-cont] = p-ind-sit[i-cont].
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


