&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00975 2.00.00.012 } /*** "010012" 13/11/2023 11:45:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00975 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00975
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rota-coleta
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
{inbo/boin00975.i RowObject}
{inbo/boin00975.i ttRotaZoom}

DEFINE TEMP-TABLE ttEstrutRota NO-UNDO
    FIELD nivel        AS INT FORMAT "9"
    FIELD cdn-seq      AS INT FORMAT ">>>>>9"
    FIELD id           AS CHAR
    FIELD r-rowid      AS ROWID
    FIELD cod-reg      AS CHAR FORMAT "x(50)"
    FIELD cod-reg-pai  AS CHAR FORMAT "x(50)"
    FIELD des-reg      AS CHAR FORMAT "x(100)".

def temp-table tt_rota_coleta no-undo
    field ttv_cod_rota                     as character format "x(12)" label "Rota" column-label "Rota"
    field ttv_des_rota                     as character format "x(50)" label "Descriá∆o" column-label "Descriá∆o"
    index tt_id                           
          ttv_cod_rota                     ascending
    .
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}      FOR {&TableName}.
DEFINE BUFFER BFProdut-rural      FOR produt-rural.
DEFINE BUFFER BFProdut-pto-coleta FOR produt-pto-coleta.

def VARIABLE i-cod-rota-ini like RowObject.cod-rota no-undo.
def VARIABLE i-cod-rota-fim like RowObject.cod-rota no-undo.   
def VARIABLE c-des-rota-ini like RowObject.des-rota no-undo.
def VARIABLE c-des-rota-fim like RowObject.des-rota no-undo.

{utp/utapi036.i} /* tt-coordenadas */

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
         HEIGHT             = 13.58
         WIDTH              = 83.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "des-rota":U THEN ASSIGN pFieldValue = RowObject.des-rota.
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
        WHEN "val-percur":U THEN ASSIGN pFieldValue = RowObject.val-percur.
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
  Purpose:     Retorna valores dos campos do °ndice cd-rota
  Parameters:  
               retorna valor do campo cod-rota
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-rota LIKE rota-coleta.cod-rota NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-rota = RowObject.cod-rota.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTRotaColeta DBOProgram 
PROCEDURE getTTRotaColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAMETER piQuery AS INTEGER NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR  ttRotaZoom.

    FOR EACH ttRotaZoom:
        DELETE ttRotaZoom.
    END.

    /*codigo*/
    IF piQuery = 1 THEN DO:

        FOR EACH bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.cod-rota >= i-cod-rota-ini 
           AND   bf{&TableName}.cod-rota <= i-cod-rota-fim:
            
            CREATE ttRotaZoom.
            BUFFER-COPY bf{&TableName} TO ttRotaZoom.
            ASSIGN ttRotaZoom.r-rowid = ROWID(bf{&TableName}).

        END.

    END.
    ELSE DO: /*descriá∆o*/

        FOR EACH bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.des-rota >= c-des-rota-ini 
           AND   bf{&TableName}.des-rota <= c-des-rota-fim: 
            
            CREATE ttRotaZoom.
            BUFFER-COPY bf{&TableName} TO ttRotaZoom.
            ASSIGN ttRotaZoom.r-rowid = ROWID(bf{&TableName}).

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice cd-rota
  Parameters:  
               recebe valor do campo cod-rota
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-rota LIKE rota-coleta.cod-rota NO-UNDO.

    FIND FIRST bfrota-coleta WHERE 
        bfrota-coleta.cod-rota = pcod-rota NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrota-coleta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrota-coleta)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&TABLENAME}.cod-rota >= i-cod-rota-ini 
           AND {&TABLENAME}.cod-rota <= i-cod-rota-fim
        BY {&TABLENAME}.cod-rota INDEXED-REPOSITION.
                  
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&TABLENAME}.des-rota >= c-des-rota-ini 
           AND {&TABLENAME}.des-rota <= c-des-rota-fim INDEXED-REPOSITION.

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

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEstruturaRota DBOProgram 
PROCEDURE retornaEstruturaRota :
/*------------------------------------------------------------------------------
  Purpose: VERIFICAR PROCEDURE PARA TREEVIEW
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCdRota LIKE {&tableName}.cod-rota NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttEstrutRota.

    FIND FIRST {&tableName} where {&tableName}.cod-rota = pCdRota NO-LOCK NO-ERROR.
    IF AVAIL {&tableName} THEN DO:
    
        FOR EACH pto-rota-coleta FIELDS(cdn-seq cod-pto-coleta)
           WHERE pto-rota-coleta.cod-rota = {&tableName}.cod-rota NO-LOCK:

            FOR FIRST pto-coleta FIELDS(cod-pto-coleta des-pto-coleta)
                WHERE pto-coleta.cod-pto-coleta = pto-rota-coleta.cod-pto-coleta NO-LOCK:
            
                /*Cria registro do nivel 1 - Ponto Coleta*/
                {utp/ut-liter.i Ponto_Coleta *}
                CREATE ttEstrutRota.
                ASSIGN ttEstrutRota.nivel       = 1 /*Ponto Coleta*/
                       ttEstrutRota.cdn-seq     = pto-rota-coleta.cdn-seq
                       ttEstrutRota.r-rowid     = ROWID(pto-coleta)
                       ttEstrutRota.cod-reg     = pto-rota-coleta.cod-pto-coleta
                       ttEstrutRota.cod-reg-pai = ""
                       ttEstrutRota.des-reg     = RETURN-VALUE + ": " + IF AVAIL pto-coleta THEN pto-coleta.cod-pto-coleta + " - " + pto-coleta.des-pto-coleta ELSE "".
    
                IF AVAIL pto-coleta THEN DO:
    
                      FOR FIRST produt-pto-coleta FIELDS(cdn-produt-rural cod-propried) NO-LOCK
                          WHERE produt-pto-coleta.cod-pto-coleta   = pto-coleta.cod-pto-coleta
                            AND produt-pto-coleta.log-livre-1      = YES
                            AND produt-pto-coleta.log-respons      = YES:
                      
                          FOR FIRST produt-rural FIELDS(cdn-produt-rural) 
                              WHERE produt-rural.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural NO-LOCK:

        
                                FOR FIRST emitente FIELDS(nome-abrev)
                                    WHERE emitente.cod-emitente = produt-rural.cdn-produt-rural NO-LOCK: 
                                END.
        
                                /*Cria registro do nivel 2 - Produtor */
                                {utp/ut-liter.i Respons†vel *}
                                CREATE ttEstrutRota.
                                ASSIGN ttEstrutRota.nivel       = 2 /*Produtor*/   
                                       ttEstrutRota.r-rowid     = ROWID(produt-rural)
                                       ttEstrutRota.cod-reg     = pto-rota-coleta.cod-pto-coleta + "@" + string(produt-rural.cdn-produt-rural)
                                       ttEstrutRota.cod-reg-pai = pto-rota-coleta.cod-pto-coleta
                                       ttEstrutRota.des-reg     = RETURN-VALUE + ": " + produt-pto-coleta.cod-propried + " - " + IF AVAIL emitente THEN string(produt-rural.cdn-produt-rural) + " - " + emitente.nome-abrev ELSE "".  
        
                                FOR EACH BFProdut-pto-coleta FIELDS(cdn-produt-rural cod-propried)
                                   WHERE BFProdut-pto-coleta.cod-pto-coleta   = pto-coleta.cod-pto-coleta
                                     AND BFprodut-pto-coleta.log-livre-1      = YES
                                     AND BFProdut-pto-coleta.log-respons      = NO:
                                    
        
                                    FOR FIRST emitente FIELDS(nome-abrev)
                                        WHERE emitente.cod-emitente = BFProdut-pto-coleta.cdn-produt-rural NO-LOCK: 
                                    END.

                                    FOR FIRST BFProdut-rural FIELDS(cdn-produt-rural log-livre-1)
                                        WHERE BFProdut-rural.cdn-produt-rural = BFProdut-pto-coleta.cdn-produt-rural 
                                        AND   BFProdut-rural.log-livre-1      = YES NO-LOCK: /*somente criar registro dos produtores coletivos quando estiverem ativos*/
                                    
                                    
                                    
                                        /*Cria registro do nivel 3 - Produtores Coletivos */
                                        {utp/ut-liter.i Produtor_Coletivo *}
                                        CREATE ttEstrutRota.
                                        ASSIGN ttEstrutRota.nivel       = 3 /*Produtores Coletivos */   
                                               ttEstrutRota.r-rowid     = ROWID(BFProdut-rural)
                                               ttEstrutRota.cod-reg     = string(BFProdut-pto-coleta.cdn-produt-rural)
                                               ttEstrutRota.cod-reg-pai = pto-rota-coleta.cod-pto-coleta + "@" + string(produt-rural.cdn-produt-rural)
                                               ttEstrutRota.des-reg     = BFProdut-pto-coleta.cod-propried + " - " + IF AVAIL emitente THEN string(BFProdut-pto-coleta.cdn-produt-rural) + " - " + emitente.nome-abrev ELSE "".  
                                    END.
                                END.
                            
                          END.

                      END.
    
                END.

            END.

        END.

    end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosTodasRotas DBOProgram 
PROCEDURE retornaDadosTodasRotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os registros da tabela para alimentar
         o zoom do EMS 5.
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt_rota_coleta.

    FOR EACH tt_rota_coleta EXCLUSIVE-LOCK:
        DELETE tt_rota_coleta.
    END.

    FOR EACH bf{&TableName} FIELDS(cod-rota des-rota) NO-LOCK:
        CREATE tt_rota_coleta.
        ASSIGN tt_rota_coleta.ttv_cod_rota = bf{&TableName}.cod-rota
               tt_rota_coleta.ttv_des_rota = bf{&TableName}.des-rota.
    END.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-i-cod-rota-ini like RowObject.cod-rota no-undo.
def input parameter p-i-cod-rota-fim like RowObject.cod-rota no-undo.

    assign i-cod-rota-ini = p-i-cod-rota-ini       
           i-cod-rota-fim = p-i-cod-rota-fim.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-c-des-rota-ini like RowObject.des-rota no-undo.
def input parameter p-c-des-rota-fim like RowObject.des-rota no-undo.

    assign c-des-rota-ini = p-c-des-rota-ini       
           c-des-rota-fim = p-c-des-rota-fim.   

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
    
    DEF VAR c-label-tabela AS CHAR   NO-UNDO.
    DEF VAR c-label-relac  AS CHAR   NO-UNDO.

    {utp/ut-liter.i Rota_de_Coleta * L}
    ASSIGN c-label-tabela = RETURN-VALUE.

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.cod-rota = RowObject.cod-rota) THEN DO:
            {utp/ut-liter.i Rota *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.

        IF RowObject.cod-rota = "" THEN DO:
            {utp/ut-liter.i Rota *}
            {method/svc/errors/inserr.i
                               &ErrorNumber="164"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.

    END.

    IF RowObject.des-rota = "" THEN DO:
        {utp/ut-liter.i Descriá∆o *}
        {method/svc/errors/inserr.i
                           &ErrorNumber="164"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="return-value"} 
    END.

    IF NOT CAN-FIND(first estabelec where estabelec.cod-estabel = RowObject.cod-estabel)  THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
    END.

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST propried-rural WHERE propried-rural.cod-rota-princ = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Propriedade_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST pto-rota-coleta WHERE pto-rota-coleta.cod-rota = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Ponto_de_Coleta_da_Rota * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST regra-form-preco WHERE regra-form-preco.cod-rota = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Regra_de_Formaá∆o_de_Preáo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END. 

        IF CAN-FIND(FIRST fechto-produt-period WHERE fechto-produt-period.cod-rota = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Valores_Fechamento_Produtor_por_Per°odo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST carg-rural WHERE carg-rural.cod-rota = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Carga_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST preco-frete-coleta WHERE preco-frete-coleta.cod-rota = RowObject.cod-rota) THEN DO:

            {utp/ut-liter.i Tabela_de_Preco_Frete_Coleta * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.
        
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraRotaMapa DBOProgram 
PROCEDURE mostraRotaMapa:
/*------------------------------------------------------------------------------
  Purpose: Mostrar 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-cod-rota LIKE pto-rota-coleta.cod-rota NO-UNDO.

    DEFINE VARIABLE h-utapi036 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-ind AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-ret AS CHARACTER   NO-UNDO.

    RUN utp/utapi036.p PERSISTENT SET h-utapi036.

    EMPTY TEMP-TABLE tt-coordenadas NO-ERROR.

    FOR EACH pto-rota-coleta FIELDS(cod-pto-coleta) NO-LOCK
        WHERE pto-rota-coleta.cod-rota = pc-cod-rota
        BREAK BY pto-rota-coleta.cdn-seq:

        FOR FIRST pto-coleta FIELDS(cod-pto-coleta val-latitude val-longitude) NO-LOCK
            WHERE pto-coleta.cod-pto-coleta = pto-rota-coleta.cod-pto-coleta:

            IF pto-coleta.val-latitude  <> 0 AND 
               pto-coleta.val-longitude <> 0 THEN DO:
            
                i-ind = i-ind + 1.
            
                CREATE tt-coordenadas.
                ASSIGN tt-coordenadas.iIndice    = i-ind
                       tt-coordenadas.cLatitude  = REPLACE(STRING(pto-coleta.val-latitude), ",", ".")
                       tt-coordenadas.cLongitude = REPLACE(STRING(pto-coleta.val-longitude), ",", ".").

            END.
            ELSE DO:

                {method/svc/errors/inserr.i
                    &ErrorNumber="55285"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="pto-coleta.cod-pto-coleta"}

            END.

        END.

    END.

    RUN utp/utapi036.p PERSISTENT SET h-utapi036.

    ASSIGN c-ret = "OK":U.

    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RUN pMapaLocalRota IN h-utapi036 (INPUT TABLE tt-coordenadas, OUTPUT c-ret). 

    IF h-utapi036 <> ? THEN DO:
        DELETE PROCEDURE h-utapi036.
        ASSIGN h-utapi036 = ?.
    END.

    IF c-ret <> "OK":U THEN DO:

        {method/svc/errors/inserr.i
            &ErrorNumber="55286"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"}

    END.

    IF h-utapi036 <> ? THEN DO:
        DELETE PROCEDURE h-utapi036.
        ASSIGN h-utapi036 = ?.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

