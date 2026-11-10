&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram

{include/i-prgvrs.i BOIN00962 2.00.00.033 } /*** "010033" 13/11/2023 11:45:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00962 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00962
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName produt-rural
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
{inbo/boin00962.i RowObject}
{inbo/boin00962.i tt-produt-rural-aux}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def VARIABLE i-cdn-produt-ini like RowObject.cdn-produt-rural no-undo.
def VARIABLE i-cdn-produt-fim like RowObject.cdn-produt-rural no-undo.

DEFINE VARIABLE i-cod-produt-rural-ini LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE VARIABLE i-cod-produt-rural-fim LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE VARIABLE i-cod-grp-produt-ini   LIKE grp-produt.cdn-grp-produt     NO-UNDO.
DEFINE VARIABLE i-cod-grp-produt-fim   LIKE grp-produt.cdn-grp-produt     NO-UNDO.

DEFINE TEMP-TABLE tt_tit_ap_duplic
    FIELD cod_estab AS CHAR FORMAT "X(05)"
    FIELD cdn_fornecedor AS INTEGER FORMAT ">>>>>>>>9"
    FIELD cod_espec_docto AS CHAR FORMAT "X(02)"
    FIELD cod_ser_docto AS CHAR FORMAT "X(05)"
    FIELD cod_tit_ap AS CHAR FORMAT "X(16)"
    FIELD cod_parcela AS CHAR FORMAT "X(02)".

DEFINE TEMP-TABLE tt_docum_est_ems5
    FIELD serie_docto  AS CHAR 
    FIELD nro_docto    AS CHAR 
    FIELD cod_emitente AS INT
    FIELD nat_operacao AS CHAR. 

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
         WIDTH              = 58.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter i-cod-produt   LIKE {&TableName}.cdn-produt-rural NO-UNDO.
    def output parameter c-return       as char                            NO-UNDO.

    FOR FIRST bf{&TableName} FIELDS(cdn-produt-rural)
        WHERE bf{&TableName}.cdn-produt-rural = i-cod-produt:
    END.

    if not avail bf{&TableName} then do:
        {utp/ut-table.i mgind produt-rural 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.

        RETURN "NOK":U.

    end.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAllTableProdutorRural DBOProgram 
PROCEDURE getAllTableProdutorRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR tt-produt-rural-aux.
      
    EMPTY TEMP-TABLE tt-produt-rural-aux.

    FOR EACH {&TableName} NO-LOCK.

        CREATE tt-produt-rural-aux.
        BUFFER-COPY {&TableName} TO tt-produt-rural-aux.

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
        WHEN "cod-cart-produt":U THEN ASSIGN pFieldValue = RowObject.cod-cart-produt.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-obs":U THEN ASSIGN pFieldValue = RowObject.cod-obs.
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
        WHEN "cdn-grp-produt":U THEN ASSIGN pFieldValue = RowObject.cdn-grp-produt.
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
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
  Purpose:     Retorna valores dos campos do °ndice cod-produt
  Parameters:  
               retorna valor do campo cdn-produt-rural
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-produt-rural LIKE produt-rural.cdn-produt-rural NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-produt-rural = RowObject.cdn-produt-rural.

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
        WHEN "log-optan-incent":U THEN ASSIGN pFieldValue = RowObject.log-optan-incent.
        WHEN "log-livre-1":U      THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U      THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableProdutorRural DBOProgram 
PROCEDURE getTableProdutorRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input  parameter p-i-cdn-produt like RowObject.cdn-produt-rural no-undo.
DEF OUTPUT PARAMETER TABLE FOR tt-produt-rural-aux.
      
    EMPTY TEMP-TABLE tt-produt-rural-aux.

    FOR EACH {&TableName}
       WHERE {&TableName}.cdn-produt-rural = p-i-cdn-produt NO-LOCK.

        CREATE tt-produt-rural-aux.
        BUFFER-COPY {&TableName} TO tt-produt-rural-aux.

    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidEmitente DBOProgram 
PROCEDURE getRowidEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input  parameter p-rowid-produt AS ROWID no-undo.
def OUTPUT parameter p-rowid-emit   AS ROWID no-undo.

    FOR FIRST produt-rural FIELDS(cdn-produt-rural) 
        WHERE rowid(produt-rural) = p-rowid-produt NO-LOCK: 
      
        FOR FIRST emitente FIELDS(cod-emitente)
            WHERE emitente.cod-emitente = produt-rural.cdn-produt-rural NO-LOCK:

            ASSIGN p-rowid-emit = ROWID(emitente).

        END.
      
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice cod-produt
  Parameters:  
               recebe valor do campo cdn-produt-rural
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE produt-rural.cdn-produt-rural NO-UNDO.

    FIND FIRST bfprodut-rural WHERE 
        bfprodut-rural.cdn-produt-rural = pcdn-produt-rural NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprodut-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprodut-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM TABLE FOR tt-produt-rural-aux.
    EMPTY TEMP-TABLE tt-produt-rural-aux.

    FOR EACH {&TableName}
       WHERE {&TableName}.cdn-produt-rural >= i-cod-produt-rural-ini 
         AND {&TableName}.cdn-produt-rural <= i-cod-produt-rural-fim
         AND {&TableName}.cdn-grp-produt   >= i-cod-grp-produt-ini  
         AND {&TableName}.cdn-grp-produt   <= i-cod-grp-produt-fim NO-LOCK:

        CREATE tt-produt-rural-aux.
        BUFFER-COPY {&TableName} TO tt-produt-rural-aux.

    END.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProdutor DBOProgram 
PROCEDURE openQueryProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} 
     FOR EACH {&TableName}
         WHERE cdn-produt-rural >= i-cdn-produt-ini
           AND cdn-produt-rural <= i-cdn-produt-fim NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarDuplicNf DBOProgram 
PROCEDURE retornarDuplicNf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retonar duplicatas do fornecedor no perÌodo
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-period LIKE nf-produt-propried.cod-period NO-UNDO.
    DEF INPUT PARAM p-cdn-produt-rural LIKE nf-produt-propried.cdn-produt-rural NO-UNDO.
    DEF INPUT PARAM p-cod-propried LIKE nf-produt-propried.cod-propried NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt_tit_ap_duplic.
	
    FOR EACH nf-produt-propried FIELDS (cod-period cdn-produt-rural cod-propried nat-operacao serie-docto nro-docto) NO-LOCK WHERE
	         nf-produt-propried.cod-period 	 = p-cod-period 
         AND nf-produt-propried.cdn-produt-rural = p-cdn-produt-rural 
         AND nf-produt-propried.cod-propried     = p-cod-propried
         AND nf-produt-propried.num-livre-1      <> 1: /*ignora nota complementar*/

        FOR EACH docum-est FIELDS (serie-docto nro-docto cod-emitente nat-operacao) NO-LOCK WHERE
                 docum-est.serie-docto 		 = nf-produt-propried.serie-docto 
             AND docum-est.nro-docto 		 = nf-produt-propried.nro-docto 
             AND docum-est.cod-emitente 	 = nf-produt-propried.cdn-produt-rural 
             AND docum-est.nat-operacao 	 = nf-produt-propried.nat-operacao:

            FOR EACH dupli-apagar FIELDS (serie-docto nro-docto cod-emitente nat-operacao cod-esp parcela cod-estabel) NO-LOCK WHERE
		             dupli-apagar.serie-docto 	 = docum-est.serie-docto  
                 AND dupli-apagar.nro-docto 	 = docum-est.nro-docto  
                 AND dupli-apagar.cod-emitente 	 = docum-est.cod-emitente  
                 AND dupli-apagar.nat-operacao 	 = docum-est.nat-operacao:

                CREATE tt_tit_ap_duplic.
		ASSIGN tt_tit_ap_duplic.cod_estab	= dupli-apagar.cod-estabel
		       tt_tit_ap_duplic.cdn_fornecedor  = dupli-apagar.cod-emitente
                       tt_tit_ap_duplic.cod_espec_docto = dupli-apagar.cod-esp
                       tt_tit_ap_duplic.cod_ser_docto   = dupli-apagar.serie-docto
                       tt_tit_ap_duplic.cod_tit_ap      = dupli-apagar.nro-docto
                       tt_tit_ap_duplic.cod_parcela     = dupli-apagar.parcela.

            END.

        END.
		
    END. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAM p-cod-produt-rural-ini LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE INPUT PARAM p-cod-produt-rural-fim LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE INPUT PARAM p-cod-grp-produt-ini   LIKE grp-produt.cdn-grp-produt     NO-UNDO.
DEFINE INPUT PARAM p-cod-grp-produt-fim   LIKE grp-produt.cdn-grp-produt     NO-UNDO.

ASSIGN i-cod-produt-rural-ini = p-cod-produt-rural-ini
       i-cod-produt-rural-fim = p-cod-produt-rural-fim
       i-cod-grp-produt-ini   = p-cod-grp-produt-ini  
       i-cod-grp-produt-fim   = p-cod-grp-produt-fim.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProdutor DBOProgram 
PROCEDURE setConstraintProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-i-cdn-produt-ini like RowObject.cdn-produt-rural no-undo.
def input parameter p-i-cdn-produt-fim like RowObject.cdn-produt-rural no-undo.

    assign i-cdn-produt-ini = p-i-cdn-produt-ini        
           i-cdn-produt-fim = p-i-cdn-produt-fim.   

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

    {utp/ut-liter.i Produtor_Rural * L}
    ASSIGN c-label-tabela = RETURN-VALUE.

    IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = RowObject.cdn-produt-rural
                                     AND (emitente.identific = 2                    /*fornecedor*/
                                      OR emitente.identific = 3)) THEN DO:          /*fornecedor e cliente*/
        {method/svc/errors/inserr.i
                 &ErrorNumber="54574"
                 &ErrorType="EMS"
                 &ErrorParameters=" "} 
    END.

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:
            {utp/ut-liter.i Produtor_Rural *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.
    END.

    IF NOT CAN-FIND(FIRST grp-produt WHERE grp-produt.cdn-grp-produt = RowObject.cdn-grp-produt) THEN DO:
        {method/svc/errors/inserr.i
                 &ErrorNumber="54576"
                 &ErrorType="EMS"
                 &ErrorParameters=" "} 
    END.

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST nota-promis-rural WHERE nota-promis-rural.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Nota_Promiss¢ria_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST propried-rural WHERE propried-rural.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Propriedade_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST produt-pto-coleta WHERE produt-pto-coleta.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Ponto_Coleta_Coletivo * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.
        
        IF CAN-FIND(FIRST produt-carg WHERE produt-carg.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Produtor_Carga * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.        

        IF CAN-FIND(FIRST regra-form-preco WHERE regra-form-preco.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Regra_de_Formaá∆o_de_Preáo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END. 

        IF CAN-FIND(FIRST nf-produt-propried WHERE nf-produt-propried.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Notas_Produtor_Propriedade * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST analis-lab-period WHERE analis-lab-period.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Analise_Laborat¢rio_Periodo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST fechto-qualid WHERE fechto-qualid.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Fechamento_Valores_Qualidade * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST produt-carg WHERE produt-carg.cdn-produt-respons = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Produtores_da_Carga * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST fechto-produt-period WHERE fechto-produt-period.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Valores_Fechamento_Produtor_por_Per°odo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST quant-fornec-produt WHERE quant-fornec-produt.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:

            {utp/ut-liter.i Quantidade_Fornecida_Produtor * L}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarDadosProdutor DBOProgram 
PROCEDURE retornarDadosProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retonar dados do produtor rural e tabelas filhas
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-produt     AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-period     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cdn-grp-produt AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-grp-produt AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-rota       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-rota       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-estab      AS CHARACTER NO-UNDO.

    ASSIGN p-cdn-grp-produt = 0
           p-des-grp-produt = ""
           p-cod-rota       = ""
           p-des-rota       = ""
           p-cod-estab      = "".

    FOR FIRST bf{&TableName} FIELDS(cdn-produt-rural cdn-grp-produt) NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cdn-produt:
            ASSIGN p-cdn-grp-produt = bf{&TableName}.cdn-grp-produt.

        /*busca grupo do produtor*/
        FOR FIRST grp-produt FIELDS(des-grp-produt) NO-LOCK
            WHERE grp-produt.cdn-grp-produt = bf{&TableName}.cdn-grp-produt:
            ASSIGN p-des-grp-produt = grp-produt.des-grp-produt.
        END.

    END.

    /*busca tabela de fechamento do produtor/propriedade 
      para retornar rota e estabelecimento*/
    FOR FIRST fechto-produt-period FIELDS(cod-estabel cod-rota) NO-LOCK
        WHERE fechto-produt-period.cod-period       = p-cod-period
          AND fechto-produt-period.cdn-produt-rural = p-cdn-produt
          AND fechto-produt-period.cod-propried     = p-cod-propried:

        ASSIGN p-cod-rota  = fechto-produt-period.cod-rota
               p-cod-estab = fechto-produt-period.cod-estabel.

    END.

    /*se n„o foi rodado apuraÁ„o de valores, busca na carga*/
    IF NOT AVAIL fechto-produt-period THEN DO:

        FOR FIRST produt-carg FIELDS(cod-estabel num-carg) NO-LOCK
            WHERE produt-carg.cdn-produt-rural = p-cdn-produt
              AND produt-carg.cod-propried     = p-cod-propried:

            ASSIGN p-cod-estab = produt-carg.cod-estabel.

            FOR FIRST carg-rural FIELDS(cod-rota) NO-LOCK
                WHERE carg-rural.num-carg = produt-carg.num-carg:

                ASSIGN p-cod-rota = carg-rural.cod-rota.

            END.

        END.

        /*caso ainda n„o tenha carga para o produtor, busca do cadastro*/
        FOR FIRST produt-pto-coleta FIELDS(cod-pto-coleta) NO-LOCK
            WHERE produt-pto-coleta.cdn-produt-rural = p-cdn-produt:
            FOR FIRST pto-rota-coleta FIELDS(cod-rota) NO-LOCK
                WHERE pto-rota-coleta.cod-pto-coleta = produt-pto-coleta.cod-pto-coleta:
                FOR FIRST rota-coleta FIELDS(cod-rota des-rota cod-estabel) NO-LOCK
                    WHERE rota-coleta.cod-rota = pto-rota-coleta.cod-rota:
                    ASSIGN p-cod-rota  = rota-coleta.cod-rota
                           p-des-rota  = rota-coleta.des-rota
                           p-cod-estab = rota-coleta.cod-estabel.
                END.
            END.
        END.


    END.

    /*busca descricao da rota*/
    IF p-des-rota = "":U THEN
        FOR FIRST rota-coleta FIELDS(des-rota) NO-LOCK
            WHERE rota-coleta.cod-rota = p-cod-rota:
            ASSIGN p-des-rota  = rota-coleta.des-rota.
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaFornecProdutRural DBOProgram 
PROCEDURE validaFornecProdutRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validar se o fornecedor informado no EMS5 Ç um Produtor Rural
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-produt AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-produt-rural AS LOGICAL NO-UNDO.

    ASSIGN p-log-produt-rural = NO.

    FOR FIRST bf{&TableName} FIELDS(cdn-produt-rural) NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cdn-produt:
        ASSIGN p-log-produt-rural = YES.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificarDuplicNfAp DBOProgram 
PROCEDURE verificarDuplicNfAp:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Conferir se todas as Notas est„o atualizadas no Contas a Pagar
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-period LIKE nf-produt-propried.cod-period NO-UNDO.
    DEF INPUT PARAM p-cod-estabel LIKE nf-produt-propried.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM p-log-erro AS LOGICAL NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt_docum_est_ems5.

    ASSIGN p-log-erro = NO.

    FOR EACH nf-produt-propried FIELDS (cod-period cdn-produt-rural cod-propried nat-operacao serie-docto nro-docto) NO-LOCK WHERE
             nf-produt-propried.cod-period    = p-cod-period 
         AND nf-produt-propried.cod-estabel   = p-cod-estabel:

        IF  CAN-FIND (docum-est WHERE
                      docum-est.serie-docto   = nf-produt-propried.serie-docto 
                  AND docum-est.nro-docto     = nf-produt-propried.nro-docto 
                  AND docum-est.cod-emitente  = nf-produt-propried.cdn-produt-rural 
                  AND docum-est.nat-operacao  = nf-produt-propried.nat-operacao
                  AND docum-est.ap-atual      = NO) THEN DO:

            CREATE tt_docum_est_ems5.
            ASSIGN tt_docum_est_ems5.serie_docto  = nf-produt-propried.serie-docto 
                   tt_docum_est_ems5.nro_docto    = nf-produt-propried.nro-docto 
                   tt_docum_est_ems5.cod_emitente = nf-produt-propried.cdn-produt-rural
                   tt_docum_est_ems5.nat_operacao = nf-produt-propried.nat-operacao.

            ASSIGN p-log-erro = YES.

        END.

    END. 

    IF p-log-erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

