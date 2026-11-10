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
{include/i-prgvrs.i BOIN873 2.00.00.006 } /*** "010006" 02/09/2026 17:16:29 ***/
{include/i-epc200.i BOIN873}
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN873
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-docto-orig-cte
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
{inbo/boin873.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEF BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-chave-acesso LIKE docto-orig-cte.cod-aces-comp-nfe    NO-UNDO.
DEF VAR i-idi-origem   LIKE docto-orig-cte.idi-orig-trad        NO-UNDO.
DEF NEW GLOBAL SHARED  VAR c-seg-usuario AS CHAR FORMAT "X(12)" NO-UNDO.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "X(255)".

DEFINE VARIABLE h-boin172desc AS HANDLE      NO-UNDO.

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
         HEIGHT             = 13.54
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
        WHEN "cod-aces-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-aces-comp-nfe.
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "qtd-inter":U THEN ASSIGN pFieldValue = RowObject.qtd-inter.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-preco-tot":U THEN ASSIGN pFieldValue = RowObject.val-preco-tot.
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
        WHEN "cdn-seq":U THEN ASSIGN pFieldValue = RowObject.cdn-seq.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
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
  Purpose:     Retorna valores dos campos do °ndice chave-id
  Parameters:  
               retorna valor do campo cod-aces-comp-nfe
               retorna valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aces-comp-nfe LIKE item-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE item-docto-orig-cte.idi-orig-trad NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad.

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
  Purpose:     Reposiciona registro com base no °ndice chave-id
  Parameters:  
               recebe valor do campo cod-aces-comp-nfe
               recebe valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aces-comp-nfe   LIKE item-docto-orig-cte.cod-aces-comp-nfe  NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad       LIKE item-docto-orig-cte.idi-orig-trad      NO-UNDO.

    FIND FIRST bf{&TableName} WHERE 
        bf{&TableName}.cod-aces-comp-nfe = pcod-aces-comp-nfe AND 
        bf{&TableName}.idi-orig-trad = pidi-orig-trad NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN DO:
        RETURN "NOK":U.
    END.
        

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
    DEF VAR h-boin356 AS HANDLE NO-UNDO.

    IF RowObject.idi-orig-trad = 2 AND RowObject.numero-ordem > 0 THEN DO:
        IF NOT VALID-HANDLE(h-boin356) THEN /* prazo-compra */
            RUN inbo/boin356.p PERSISTENT SET h-boin356.

        ASSIGN RowObject.num-parcela = 0.
        RUN aloca-ordem-cc IN h-boin356 (INPUT RowObject.numero-ordem, //ALOCA
                                         INPUT-OUTPUT RowObject.num-parcela,
                                         INPUT RowObject.qtd-inter).

        IF VALID-HANDLE(h-boin356) THEN DO:
           DELETE PROCEDURE h-boin356.
           ASSIGN h-boin356 = ?.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
    DEF VAR h-boin356 AS HANDLE NO-UNDO.

    IF RowObject.idi-orig-trad = 2 THEN DO:
        FOR FIRST {&TableName} NO-LOCK
            WHERE {&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
              AND {&TableName}.idi-orig-trad     = 2:

            IF ({&TableName}.numero-ordem > 0 OR RowObject.numero-ordem > 0) AND
               NOT VALID-HANDLE(h-boin356) THEN     /* prazo-compra */
               RUN inbo/boin356.p PERSISTENT SET h-boin356.

            IF {&TableName}.numero-ordem > 0 THEN DO: //DESALOCA
                RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT {&TableName}.numero-ordem,
                                                       INPUT {&TableName}.num-parcela,
                                                       INPUT {&TableName}.qtd-inter).
            END.

            IF RowObject.numero-ordem > 0 THEN DO: //ALOCA
                ASSIGN RowObject.num-parcela = 0.
                RUN aloca-ordem-cc IN h-boin356 (INPUT RowObject.numero-ordem,
                                                 INPUT-OUTPUT RowObject.num-parcela,
                                                 INPUT RowObject.qtd-inter).
            END.
            IF VALID-HANDLE(h-boin356) THEN DO:
               DELETE PROCEDURE h-boin356.
               ASSIGN h-boin356 = ?.
            END.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
    DEF VAR h-boin356 AS HANDLE NO-UNDO.

    IF RowObject.idi-orig-trad = 2 THEN DO:
        FOR FIRST {&TableName} NO-LOCK
            WHERE {&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
              AND {&TableName}.idi-orig-trad     = 2:

            IF {&TableName}.numero-ordem > 0 AND
               NOT VALID-HANDLE(h-boin356) THEN     /* prazo-compra */
                RUN inbo/boin356.p PERSISTENT SET h-boin356.

            IF {&TableName}.numero-ordem > 0 THEN //DESALOCA
                RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT {&TableName}.numero-ordem,
                                                       INPUT {&TableName}.num-parcela,
                                                       INPUT {&TableName}.qtd-inter).

            IF VALID-HANDLE(h-boin356) THEN DO:
                DELETE PROCEDURE h-boin356.
                ASSIGN h-boin356 = ?.
            END.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryChaveItemDoc DBOProgram 
PROCEDURE openQueryChaveItemDoc :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query com base na chave do documento   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-aces-comp-nfe = c-chave-acesso
           AND {&TableName}.idi-orig-trad     = i-idi-origem.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintChaveItemDoc DBOProgram 
PROCEDURE setConstraintChaveItemDoc :
/*------------------------------------------------------------------------------
  Purpose:    Setar a chave do documento    
  Parameters: p-chave-acesso: Chave de acesso do documento
              p-idi-origem:   Origem do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-chave-acesso LIKE rat-docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEF INPUT PARAM p-idi-origem   LIKE rat-docto-orig-cte.idi-orig-trad     NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaParcela DBOProgram 
PROCEDURE atualizaParcela :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza a parcela baseado na ordem de compra informada no RowObject 
  Notes:       
------------------------------------------------------------------------------*/

    IF RowObject.numero-ordem = 0 THEN
        ASSIGN RowObject.num-parcela = 0.
    ELSE DO:
        IF RowObject.num-parcela = 0 THEN
            /* Busca parcela da ordem de compra informada */
            for first prazo-compra fields (quant-saldo dec-1 parcela data-entrega numero-ordem situacao) 
                where prazo-compra.numero-ordem = RowObject.numero-ordem
                and   prazo-compra.situacao     = 2 
                and   (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0 no-lock
                by prazo-compra.data-entrega
                by prazo-compra.numero-ordem
                BY prazo-compra.parcela:

                assign RowObject.num-parcela = prazo-compra.parcela.
            end.
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
    
    DEFINE INPUT PARAMETER pType    AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE l-pendente      AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE de-val-aux      AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE l-erro-co-aux   AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE l-contrato-aux  AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE l-valida-saldo  AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE i-total-aux     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE i-tipo-contr    AS INTEGER      NO-UNDO.
    
    DEFINE BUFFER b-pedido-compr   FOR pedido-compr.
    DEFINE BUFFER b-docto-orig-cte FOR docto-orig-cte.
    DEFINE BUFFER b-ordem-compra   FOR ordem-compra.
    DEFINE BUFFER b-prazo-compra   FOR prazo-compra.

	DEFINE VARIABLE h-re1008         AS HANDLE    NO-UNDO.
	
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF  NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF  NOT AVAIL param-contrat THEN
        FIND FIRST param-contrat NO-LOCK NO-ERROR.

    IF  NOT AVAIL param-re THEN
        FIND FIRST param-re
            WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.

    IF pType = "CREATE" THEN DO:

        FIND FIRST bf{&TableName} NO-LOCK
             WHERE bf{&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
               AND bf{&TableName}.idi-orig-trad     = RowObject.idi-orig-trad     NO-ERROR.

        /*-- J† existe Registro com Chave Informada --*/
        IF  AVAIL bf{&TableName} THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind item-docto-orig-cte 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                               &ErrorNumber="8"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF  pType <> "DELETE" THEN DO:
        IF NOT VALID-HANDLE(h-boin172desc) THEN
            RUN inbo/boin172desc.p PERSISTENT SET h-boin172desc.

        RUN openQueryStatic IN h-boin172desc (INPUT "Main":U) NO-ERROR.

        RUN goToKey IN h-boin172desc (INPUT RowObject.it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
            RETURN "NOK":U.
        END.

        RUN getIntField IN h-boin172desc (INPUT "tipo-contr", OUTPUT i-tipo-contr).
        IF  i-tipo-contr <> 4 /* DD */ THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="28784"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
            RETURN "NOK":U.
        END.

    END.

    IF  pType = "UPDATE" THEN DO: /* Se est† alterando */

        FOR FIRST b-docto-orig-cte FIELDS (cod-estabel cod-emitente dt-emissao)
            WHERE b-docto-orig-cte.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe 
              AND b-docto-orig-cte.idi-orig-trad     = 2 NO-LOCK:
        END.
        
        IF  RowObject.num-pedido > 0 THEN DO:
            
            /**** Validaá‰es do Pedido de Compra ****/

            FOR FIRST b-pedido-compr FIELDS(situacao end-entrega cod-emitente)
                WHERE b-pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK:
            END.

            IF  NOT AVAIL b-pedido-compr THEN DO:
                {utp/ut-table.i movind pedido-compr 1}
                {method/svc/errors/inserr.i
                                   &ErrorNumber="2"  /* Pedido de compra n∆o cadastrado */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
            ELSE DO:
                IF  b-pedido-compr.situacao = 3 THEN DO: /* Eliminado */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="7169"  /* Pedido de compra eliminado */
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
                END.
                
				/*
				Valida bloqueio quando estabelecimento de entrega do pedido for diferente do estabelecimento do CT-e
				Nao havera sequencia na mensagem pois na importacao do ct-e ha apenas um item
				*/
				run rep/re1008.p persistent set h-re1008.
				run pi-execute in h-re1008 (input RowObject.num-pedido,
											input b-docto-orig-cte.cod-estabel,
											input "",
											OUTPUT TABLE RowErrors APPEND).
				delete procedure h-re1008.
				h-re1008 = ?.				
				if not can-find(first RowErrors where RowErrors.ErrorNumber = 57853) then
					/* Estabelecimento de entrega do pedido deve ser igual ao estabelecimento do CT-e */
					IF  b-pedido-compr.end-entrega <> b-docto-orig-cte.cod-estabel THEN DO:
						{method/svc/errors/inserr.i
									&ErrorNumber="18800"  /*Estabelecimento de entrega do pedido Ç diferente do estabelecimento do documento.*/
									&ErrorType="EMS"
									&ErrorSubType="WARNING"}
					END.

                /* Verifica se o fornecedor do pedido n∆o Ç o mesmo do CT-e */
                RUN rep/re1007.p (INPUT b-pedido-compr.cod-emitente,
                                  INPUT b-docto-orig-cte.cod-emitente,
                                  INPUT-OUTPUT TABLE RowErrors).
            END.

        END.

        IF  RowObject.numero-ordem > 0 THEN DO:
        
            /**** Validaá‰es da Ordem de Compra ****/

            FIND FIRST b-ordem-compra
                WHERE b-ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK NO-ERROR.

            IF  NOT AVAIL b-ordem-compra THEN DO:
                {utp/ut-table.i movind ordem-compra 1}
                {method/svc/errors/inserr.i
                                   &ErrorNumber="2"  /* Ordem de compra n∆o cadastrada. */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
            ELSE DO:
                
                IF  RowObject.num-pedido <> b-ordem-compra.num-pedido THEN DO:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="7342"  /* Ordem de compra n∆o pertence ao pedido */
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
                END.

                IF  RowObject.it-codigo <> b-ordem-compra.it-codigo THEN DO:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="15187"  /* Item da ordem n∆o confere com item da nota fiscal */
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}                                       
                END.

                IF  b-ordem-compra.situacao <> 2 THEN DO: /* Situaá∆o da Ordem n∆o Ç "Confirmada". */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="15188"  /* Situaá∆o da ordem n∆o permite movimentaá∆o */
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}     
                    RETURN "NOK":U.
                END.

                IF  param-compra.log-1 THEN DO: /* Aprovaá∆o eletrìnica implantada */
                    RUN cdp/cdapi172.p (INPUT 4, INPUT ROWID(b-ordem-compra), OUTPUT l-pendente).
                    IF  NOT l-pendente THEN
                        RUN cdp/cdapi172.p (INPUT 6, INPUT ROWID(b-ordem-compra), OUTPUT l-pendente).

                    IF  l-pendente THEN DO:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="17022"  /* Documento esta pendente de aprovaá∆o */
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"}
                    END.
                END.
                
                /* Verifica se a ordem est† vinculada a algum contrato... */
                IF  b-ordem-compra.nr-contrato <> 0
                    AND param-global.modulo-cn THEN DO:
                    
                    RUN cnp/cn9174.p (b-ordem-compra.numero-ordem,
                                      2,  
                                      RowObject.num-seq-event,
                                      0,
                                      b-docto-orig-cte.dt-emissao,
                                      OUTPUT de-val-aux,
                                      OUTPUT l-erro-co-aux,
                                      OUTPUT l-contrato-aux,
                                      OUTPUT i-total-aux,
                                      INPUT-OUTPUT TABLE tt-erro).  
                                                
                    IF  l-erro-co-aux THEN DO:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="15212"  /* N∆o h† saldo liberado para o contrato */
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"}
                    END.
                    
                    /* Verifica se contrato est† pendente de aprovaá∆o */
                    IF  param-compra.log-1  = YES
                        AND param-contrat.log-1 = YES THEN DO:

                        ASSIGN l-pendente = NO.
                        
                        IF  b-ordem-compra.num-seq-item <> 0 THEN DO:
                            
                            FOR FIRST contrato-for FIELDS (dec-2)
                                WHERE contrato-for.nr-contrato = b-ordem-compra.nr-contrato NO-LOCK: END.
                                
                            IF  NOT AVAIL contrato-for THEN DO:
                                {utp/ut-liter.i "'Contrato'" *}
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="2"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
                                RETURN "NOK":U.
                            END.
                            
                            FOR FIRST item-contrat FIELDS (val-total)
                                WHERE item-contrat.nr-contrato  = b-ordem-compra.nr-contrato AND
                                item-contrat.num-seq-item = b-ordem-compra.num-seq-item NO-LOCK: END.
                                
                            IF  NOT AVAIL item-contrat THEN DO:
                                {utp/ut-liter.i "'Item do Contrato'" *}
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="2"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR" 
                                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
                                RETURN "NOK":U.
                            END.

                            
                            IF  contrato-for.dec-2 = 0 AND item-contrat.val-total = 0 THEN
                                RUN cdp/cdapi172.p (8, ROWID(b-ordem-compra), OUTPUT l-pendente).
                            ELSE
                                RUN cdp/cdapi172.p (8, ROWID(item-contrat), OUTPUT l-pendente).
                        END.
                        ELSE FOR EACH item-contrat NO-LOCK
                            WHERE item-contrat.nr-contrato = b-ordem-compra.nr-contrato:
                            
                            RUN cdp/cdapi172.p (8, ROWID(item-contrat), OUTPUT l-pendente).
                            IF l-pendente = YES THEN LEAVE.

                        END.
                            
                        IF  l-pendente = YES THEN DO:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="16326"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="STRING(b-ordem-compra.numero-ordem) + '~~~~' + 
                                                                 STRING(b-ordem-compra.it-codigo)    + '~~~~' + 
                                                                 TRIM(STRING(b-ordem-compra.qt-solic,'>>>,>>>,>>>,>>>,>>9.9999')) + '~~~~' + 
                                                                 STRING(b-ordem-compra.nr-contrato)  + '~~~~' + 
                                                                 STRING(b-ordem-compra.cod-estabel) "} 
                        END.

                    END.
                    
                    FIND FIRST b-prazo-compra
                        WHERE b-prazo-compra.numero-ordem = RowObject.numero-ordem
                        AND   b-prazo-compra.parcela      = RowObject.num-parcela NO-LOCK NO-ERROR.
                    
                    IF  NOT l-contrato-aux THEN DO:
                        IF  AVAIL b-prazo-compra
                            AND (b-prazo-compra.data-entrega    > b-docto-orig-cte.dt-emissao + param-re.variacao
                                 OR b-prazo-compra.data-entrega < b-docto-orig-cte.dt-emissao - param-re.variacao) THEN DO:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="18802"  /* Data de entrega da parcela esta fora da variaá∆o. */
                                               &ErrorType="EMS"
                                               &ErrorSubType="WARNING"}
                        END.

                    END.
                    
                END.
                ASSIGN l-valida-saldo = YES.
                IF  c-nom-prog-upc-mg97 <> ""
                AND c-nom-prog-upc-mg97 <> ? THEN DO:
                    FOR EACH tt-epc
                        WHERE tt-epc.cod-event = "TrataTipoContratoTotal":
                        DELETE tt-epc.
                    END.

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "TrataTipoContratoTotal":U
                           tt-epc.cod-parameter = "nr-contrato":U
                           tt-epc.val-parameter = IF AVAIL b-ordem-compra THEN STRING(b-ordem-compra.nr-contrato) ELSE "0".

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "TrataTipoContratoTotal":U
                           tt-epc.cod-parameter = "numero-ordem":U
                           tt-epc.val-parameter = STRING(RowObject.numero-ordem).
                               
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "TrataTipoContratoTotal":U
                           tt-epc.cod-parameter = "cod-aces-comp-nfe":U
                           tt-epc.val-parameter = STRING(RowObject.cod-aces-comp-nfe).

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "TrataTipoContratoTotal":U
                           tt-epc.cod-parameter = "RowErrors":U
                           tt-epc.val-parameter = STRING(TEMP-TABLE RowErrors:HANDLE).
                    
                    {include/i-epc201.i "TrataTipoContratoTotal"}

                    IF RETURN-VALUE = "CONTRATO-TOTAL":U THEN DO:
                        ASSIGN l-valida-saldo = NO.
                    END.
                END.

                IF l-valida-saldo THEN DO:
                    /* Verifica se existe saldo em alguma parcela para a ordem */
                    IF  NOT CAN-FIND(FIRST prazo-compra 
                                 WHERE prazo-compra.numero-ordem = RowObject.numero-ordem
                                 AND   prazo-compra.situacao     = 2 
                                 AND   (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0) THEN DO:
                        {method/svc/errors/inserr.i
                                       &ErrorNumber="34466"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters=" '' + '~~~~' +
                                                        STRING(RowObject.numero-ordem) + '~~~~' +
                                                        'BO Item CT-e' "}
                    END.
                END.

            END. /* ELSE -> NOT AVAIL b-ordem-compra */
            
        END. /* END IF RowObject.ordem-compra > 0 */

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereCampos DBOProgram 
PROCEDURE sugereCampos:
    DEFINE INPUT        PARAM pCodAcesCompNfe LIKE {&TableName}.cod-aces-comp-nfe NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pItCodigo             AS CHAR     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pNumPedido            AS INT      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pNumeroOrdem          AS INT      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pLHabilitaNumSeqEvent AS LOG      NO-UNDO.
    
    ASSIGN pLHabilitaNumSeqEvent = NO.

    FOR FIRST  bf{&TableName} 
        FIELDS (numero-ordem)
        WHERE  bf{&TableName}.cod-aces-comp-nfe = pCodAcesCompNfe
        AND  bf{&TableName}.idi-orig-trad = 2 NO-LOCK:
    END.
    IF NOT AVAIL  bf{&TableName}  THEN
        RETURN "NOK":U.

    IF  pNumeroOrdem  > 0 
    AND pNumeroOrdem <>  bf{&TableName}.numero-ordem THEN DO:

        FOR FIRST param-global NO-LOCK: END.
        
        FOR FIRST ordem-compra fields(it-codigo numero-ordem num-pedido nr-contrato) 
            WHERE ordem-compra.numero-ordem = pNumeroOrdem NO-LOCK: END.
        IF NOT AVAIL ordem-compra THEN
            RETURN "NOK":U.

        ASSIGN pItCodigo                = ordem-compra.it-codigo
               pNumPedido               = ordem-compra.num-pedido
               pNumeroOrdem             = ordem-compra.numero-ordem
               pLHabilitaNumSeqEvent    = ordem-compra.nr-contrato <> 0 AND AVAIL(param-global) AND param-global.modulo-cn.
    END.
   
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
