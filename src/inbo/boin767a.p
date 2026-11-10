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
{include/i-prgvrs.i BOIN767A 2.00.00.022 } /*** "010022" 17/06/2025 16:40:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin767a MUT}
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
&GLOBAL-DEFINE DBOName boin767a
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-doc-pend-aprov
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
{inbo/boin767.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/**  Variaveis necessarias aos setConstraints 
**/
DEFINE VARIABLE i-cod-tip-doc       AS INTEGER                 NO-UNDO.
DEFINE VARIABLE i-tipo-trans        AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-motivo-aprov      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE de-valor-aprov      AS DECIMAL                 NO-UNDO.
DEFINE VARIABLE i-moeda             AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-cod-usuar-trans   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-usuar-doc     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-doc   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-it-codigo         AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-referencia    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i-ep-codigo         AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-cod-estabel       LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE i-empresa           LIKE empresa.ep-codigo     NO-UNDO.
DEFINE VARIABLE l-apr-tip-doc       AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE p-cod-tip-doc       AS INTEGER                 NO-UNDO.
DEFINE VARIABLE i-chave             AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-chave             AS CHARACTER               NO-UNDO.
DEFINE VARIABLE hmla-param-aprov    AS HANDLE                  NO-UNDO.
DEFINE VARIABLE hmla-tipo-doc-aprov AS HANDLE                  NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov    AS HANDLE                  NO-UNDO.
DEFINE VARIABLE hmla-chave-doc      AS HANDLE                  NO-UNDO.
DEFINE VARIABLE c-cod-estabelec     LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE i-documento-aed     AS INTEGER                 NO-UNDO.
DEFINE VARIABLE l-doc-aprova        AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE i-erro              AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-retorno-chave     AS CHARACTER               NO-UNDO.

/**  Outras Vari†veis
**/
{inbo/boin767.i2}
{inbo/boin767.i4}
{cdp/cd0666.i}
{utp/utapi019.i}
{utp/ut-glob.i}
{cdp/cd0020.i} 


DEF NEW GLOBAL SHARED VAR gc-estabelec-aed LIKE estabelec.cod-estabel NO-UNDO.

RUN pi-gerar-dados-extrato (INPUT "boin767a: Entrou " ).

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
         HEIGHT             = 18.42
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPend DBOProgram 
PROCEDURE checkPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-tipo-docto  AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    RUN getEstab (INPUT  p-tipo-docto,
                  INPUT  p-chave-doc,
                  OUTPUT c-cod-estabelec).
    
    IF RETURN-VALUE = "OK" THEN do:
        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = c-cod-estabelec NO-LOCK NO-ERROR.

            IF  AVAIL estabelec THEN
                RUN cdp/cd9970.p (INPUT  ROWID(estabelec),
                                  OUTPUT i-empresa).
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-erro.
        ASSIGN i-erro = 0.                                       
        FOR EACH RowErrors:                                      
            ASSIGN i-erro = i-erro + 1.                          
            CREATE tt-erro.                                      
            ASSIGN tt-erro.i-sequen = i-erro                     
                   tt-erro.cd-erro  = 13.
        END.                                                     
        RETURN "NOK":U.
    END.    

    CASE p-tipo-docto:
        WHEN 1  THEN RUN checkPendSolic      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 2  THEN RUN checkPendSolic      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 3  THEN RUN checkPendRequis     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 4  THEN RUN checkPendRequis     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 5  THEN RUN checkPendCotac      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 6  THEN RUN checkPendPedido     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 7  THEN RUN checkPendPedido     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 8  THEN RUN checkPendEmerg      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 9  THEN RUN checkPendProces     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 10 THEN RUN checkPendProces     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 13 THEN RUN checkPendContr      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 14 THEN RUN checkPendMedic      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 16 THEN RUN checkPendEvent      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 18 THEN RUN checkPendSolCot     IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 19 THEN RUN checkPendEmerg      IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 21 THEN RUN checkPendRepCredito IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 29 THEN RUN checkPendNegFrete   IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabelec, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 30 THEN RUN checkPendDocFrete   IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabelec, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 31 THEN RUN checkPendFatFrete   IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabelec, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 32 THEN RUN checkPendOrigAdto   IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
        WHEN 33 THEN RUN checkPendOrigFechto IN THIS-PROCEDURE (INPUT p-chave-doc, INPUT c-cod-estabel, INPUT i-empresa, OUTPUT TABLE RowErrors).
    END CASE.

    IF  RETURN-VALUE = "NOK":U THEN DO:
        EMPTY TEMP-TABLE tt-erro.
        ASSIGN i-erro = 0.
        FOR EACH RowErrors:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-erro
                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                   tt-erro.mensagem = RowErrors.ErrorDescription.
        END.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendNegFrete DBOProgram 
PROCEDURE checkPendNegFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validacao Integracao Negociacao de Frete enviado pelo GFE para MLA
         Este metodo valida e dispara o  proxima Pendencia dentro do MLA conforme 
         Parametrizacoes feitas.      
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 29 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 29, OUTPUT c-retorno-chave).

        RUN pi-gerar-dados-extrato (INPUT "boin767a: ReturnKeyDoc " + c-retorno-chave ).

        FOR FIRST tab-generica FIELDS(tab-generica.char-1)
            WHERE tab-generica.utilizacao  = "GFE_MLA_TF_GV9"
              AND tab-generica.char-1      = c-retorno-chave     NO-LOCK: END.
        IF AVAIL tab-generica THEN DO:
            {lap/mlaapi001.i01}
            CREATE tt-mla-chave.
            /* Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* Transportador */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* Tabela Frete */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* sequencia Frete */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767a: checkPendDoc 29 " + c-retorno-chave ).

            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  29,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendDocFrete DBOProgram 
PROCEDURE checkPendDocFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validacao Integracao Documento de Frete enviado pelo GFE para MLA
         Este metodo valida e dispara o  proxima Pendencia dentro do MLA conforme 
         Parametrizacoes feitas.      
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 30 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 30, OUTPUT c-retorno-chave).

        FOR FIRST tab-generica FIELDS(tab-generica.char-1)
            WHERE tab-generica.utilizacao  = "GFE_MLA_GW3"
              AND tab-generica.char-1      = c-retorno-chave     NO-LOCK: END.
        IF AVAIL tab-generica THEN DO:
            {lap/mlaapi001.i01}
            CREATE tt-mla-chave.
            /* Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* Especie */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* Transportadora */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* Serie */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).
            /* Nr Documento */
            ASSIGN tt-mla-chave.valor[5] = TRIM(ENTRY(05,tab-generica.char-1,"|")).
            /* Data Emissao */
            ASSIGN tt-mla-chave.valor[6] = TRIM(ENTRY(06,tab-generica.char-1,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767a: checkPendDoc 30 " + c-retorno-chave ).

            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  30,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendFatFrete DBOProgram 
PROCEDURE checkPendFatFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validacao Integracao Fatura de Frete enviado pelo GFE para MLA
         Este metodo valida e dispara o  proxima Pendencia dentro do MLA conforme 
         Parametrizacoes feitas.      
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 31 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        
        RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 31, OUTPUT c-retorno-chave).

        FOR FIRST tab-generica FIELDS(tab-generica.char-1)
            WHERE tab-generica.utilizacao  = "GFE_MLA_GW6"
              AND tab-generica.char-1      = c-retorno-chave     NO-LOCK: END.
        IF AVAIL tab-generica THEN DO:
            {lap/mlaapi001.i01}
            CREATE tt-mla-chave.
            /* GW6_FILIAL -> Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* GW6_EMIFAT -> Transportador */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* GW6_SERFAT -> Serie */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* GW6_NRFAT  -> Nr Fatura */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).
            /* GW6_DTEMIS -> Dt Emissao */
            ASSIGN tt-mla-chave.valor[5] = TRIM(ENTRY(05,tab-generica.char-1,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767a: checkPendDoc 31 " + c-retorno-chave ).

            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  31,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendContf DBOProgram 
PROCEDURE checkPendContf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /** Documentos 11 e 12 n∆o s∆o mais utilizados **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendContr DBOProgram 
PROCEDURE checkPendContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 13 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST contrato-for FIELD(nr-contrato)
            WHERE contrato-for.nr-contrato = INT(SUBSTRING(p-chave-doc,1,9)) NO-LOCK: END.
        
        IF AVAIL contrato-for THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(contrato-for.nr-contrato).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  13,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.
    

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendCotac DBOProgram 
PROCEDURE checkPendCotac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 5 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF l-doc-aprova THEN DO:
        /**  Cotaá∆o de Compras - Item
        **/
        FOR FIRST cotacao-item FIELDS (numero-ordem cod-emitente it-codigo)
            WHERE cotacao-item.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8))
              AND cotacao-item.cod-emitente = INT(SUBSTRING(p-chave-doc,9,9))
              AND cotacao-item.it-codigo    =     SUBSTRING(p-chave-doc,17,16)
              AND cotacao-item.seq-cotac    = INT(SUBSTRING(p-chave-doc,34,3)) NO-LOCK: END.
            
        IF AVAIL cotacao-item THEN DO:    
            {lap/mlaapi001.i01}
            CREATE tt-mla-chave.
            ASSIGN tt-mla-chave.valor[1] = STRING(cotacao-item.numero-ordem)
                   tt-mla-chave.valor[2] = STRING(cotacao-item.cod-emitente)
                   tt-mla-chave.valor[3] = cotacao-item.it-codigo
                   tt-mla-chave.valor[4] = STRING(cotacao-item.seq-cotac).
            
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  5,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.                      
    END.
                  
    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendDoc DBOProgram 
PROCEDURE checkPendDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER                 NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.  
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR i-chave AS INTEGER NO-UNDO.

    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.

    ASSIGN c-chave = "".
    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.

    ASSIGN i-chave = 0.

    RUN pi-gerar-dados-extrato (INPUT "boin767a: checkPendDoc " + String(p-cod-tip-doc)).

    FOR EACH mla-chave-doc-aprov WHERE
        mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-LOCK:
        ASSIGN i-chave = i-chave + 1
               c-chave = c-chave + tt-mla-chave.valor[i-chave] + substring("                    ",1,  
                                   (((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1) - length(tt-mla-chave.valor[i-chave]))). 
    END.
    ASSIGN c-chave = RIGHT-TRIM(c-chave).

    RUN pi-gerar-dados-extrato (INPUT "boin767a: checkPendDoc c-chave = " + c-chave ).

    FIND FIRST {&TABLENAME} 
         WHERE {&TABLENAME}.ep-codigo    = p-empresa             
           AND {&TABLENAME}.cod-estabel  = p-cod-estabel
           AND {&TABLENAME}.cod-tip-doc  = p-cod-tip-doc         
           AND {&TABLENAME}.chave-doc    = c-chave               
           AND ({&tablename}.ind-situacao = 1 
            OR {&tablename}.ind-situacao = 3)                    
           AND {&TABLENAME}.historico    = NO NO-LOCK NO-ERROR.

    IF  AVAILABLE {&TABLENAME} THEN
        RUN errorValidate IN THIS-PROCEDURE (26596,"").

    IF  p-cod-tip-doc = 13 OR
        p-cod-tip-doc = 14 OR
        p-cod-tip-doc = 16 THEN DO:
        FIND FIRST mla-doc-sit WHERE
            mla-doc-sit.ep-codigo   = i-empresa AND
            mla-doc-sit.cod-estabel = estabelec.cod-estabel AND
            mla-doc-sit.cod-tip-doc = 13 AND
            mla-doc-sit.chave-doc   = STRING(contrato-for.nr-contrato) AND
            mla-doc-sit.ind-situacao <> 3
            NO-LOCK NO-ERROR.
        IF  AVAILABLE mla-doc-sit THEN
            RUN errorValidate IN THIS-PROCEDURE (26596,"").
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendEmerg DBOProgram 
PROCEDURE checkPendEmerg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  Total
    **/
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 8 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:

        FOR FIRST pedido-compr FIELD(num-pedido)
            WHERE pedido-compr.num-pedido = INT(SUBSTRING(p-chave-doc,1,8)) NO-LOCK: END.      

        IF AVAIL pedido-compr THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(pedido-compr.num-pedido).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  8,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.
    ELSE DO:
        /**  Item
        **/
		FIND FIRST mla-tipo-doc-aprov NO-LOCK 
			 WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
			   AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
			   AND mla-tipo-doc-aprov.cod-tip-doc = 19 NO-ERROR.
		IF AVAIL mla-tipo-doc-aprov THEN
			ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

        IF  l-doc-aprova THEN DO:

            FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
                WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8))
                  AND ordem-compra.num-pedido   = INT(SUBSTRING(p-chave-doc,9,8)) NO-LOCK: END.

            IF AVAIL ordem-compra THEN DO:
                {lap/mlaapi001.i01}
                create tt-mla-chave.
                assign tt-mla-chave.valor[1] = string(ordem-compra.num-pedido)
                       tt-mla-chave.valor[2] = STRING(ordem-compra.numero-ordem).
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT  19,
                                                    INPUT  p-cod-estabel,
                                                    INPUT  p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendEvent DBOProgram 
PROCEDURE checkPendEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 16 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST evento-ped FIELDS(numero-ordem dt-evento seq-evento)
            WHERE evento-ped.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8)) 
              AND evento-ped.dt-evento    = DATE(SUBSTRING(p-chave-doc,9,10)) 
              AND evento-ped.seq-evento   = INT(SUBSTRING(p-chave-doc,19,2))  NO-LOCK: END.

        IF AVAIL evento-ped THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(evento-ped.numero-ordem)
                   tt-mla-chave.valor[2] = string(evento-ped.dat-prev-event)
                   tt-mla-chave.valor[3] = string(evento-ped.seq-evento).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  16,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    end.    
    
    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendManut DBOProgram 
PROCEDURE checkPendManut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi020I
    **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendMedic DBOProgram 
PROCEDURE checkPendMedic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  Item
    **/
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 14 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST medicao-contrat FIELDS(nr-contrato num-seq-item numero-ordem num-seq-event num-seq-medicao)
            WHERE medicao-contrat.nr-contrato      = INT(SUBSTRING(p-chave-doc,1,9))
              AND medicao-contrat.num-seq-item    = INT(SUBSTRING(p-chave-doc,10,5))
              AND medicao-contrat.numero-ordem    = INT(SUBSTRING(p-chave-doc,15,8))
              AND medicao-contrat.num-seq-event   = INT(SUBSTRING(p-chave-doc,23,4))
              AND medicao-contrat.num-seq-medicao = INT(SUBSTRING(p-chave-doc,27,4)) NO-LOCK: END.
        
        IF AVAIL medicao-contrat THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(medicao-contrat.nr-contrato)
                   tt-mla-chave.valor[2] = string(medicao-contrat.num-seq-item)
                   tt-mla-chave.valor[3] = string(medicao-contrat.numero-ordem)
                   tt-mla-chave.valor[4] = string(medicao-contrat.num-seq-event)
                   tt-mla-chave.valor[5] = string(medicao-contrat.num-seq-medicao).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  14,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    end.    
    
    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendOrigAdto DBOProgram 
PROCEDURE checkPendOrigAdto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE lOrigGraosAtivo AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE p-estabel       LIKE mla-tipo-doc-aprov.cod-estabel      NO-UNDO.
    DEFINE VARIABLE p-val           AS DECIMAL NO-UNDO.
    

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
        WHERE  mla-tipo-doc-aprov.ep-codigo   = p-empresa
        AND    mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
        AND    mla-tipo-doc-aprov.cod-tip-doc = 32 NO-ERROR.
    IF  AVAIL  mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        

        RUN cdp/cd0032.p (OUTPUT lOrigGraosAtivo).
        IF  lOrigGraosAtivo THEN DO:

            {lap/mlaapi001.i01} 

            RUN ggp/ggapi905 (INPUT p-chave-doc,
                              INPUT 1, /* tipo adto */
                              OUTPUT p-estabel,
                              OUTPUT p-val,
                              OUTPUT TABLE tt-mla-chave).

            FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
            IF AVAIL tt-mla-chave THEN DO:                                                             
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT  32,
                                                    INPUT  p-cod-estabel,
                                                    INPUT  p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.

        END.

    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendOrigFechto DBOProgram 
PROCEDURE checkPendOrigFechto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE lOrigGraosAtivo AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE p-estabel       LIKE mla-tipo-doc-aprov.cod-estabel      NO-UNDO.
    DEFINE VARIABLE p-val           AS DECIMAL NO-UNDO.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
        WHERE  mla-tipo-doc-aprov.ep-codigo   = p-empresa
        AND    mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
        AND    mla-tipo-doc-aprov.cod-tip-doc = 33 NO-ERROR.
    IF  AVAIL  mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        

        RUN cdp/cd0032.p (OUTPUT lOrigGraosAtivo).
        IF  lOrigGraosAtivo THEN DO:

            {lap/mlaapi001.i01} 

            RUN ggp/ggapi905 (INPUT p-chave-doc,
                              INPUT 2, /* tipo fechto */
                              OUTPUT p-estabel,
                              OUTPUT p-val,
                              OUTPUT TABLE tt-mla-chave).
            FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
            IF AVAIL tt-mla-chave THEN DO:                                                             
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT  33,
                                                    INPUT  p-cod-estabel,
                                                    INPUT  p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.

        END.

    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendPedido DBOProgram 
PROCEDURE checkPendPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  Item
    **/
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 6 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST ordem-compra FIELDS (numero-ordem num-pedido)
            WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8))
              AND ordem-compra.num-pedido   = INT(SUBSTRING(p-chave-doc,9,8)) NO-LOCK: END.
                             
        IF AVAIL ordem-compra THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(ordem-compra.num-pedido)
                   tt-mla-chave.valor[2] = string(ordem-compra.numero-ordem).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  6,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    end.    
    ELSE DO:
        /**  Total
        **/
		FIND FIRST mla-tipo-doc-aprov NO-LOCK 
			 WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
			   AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
			   AND mla-tipo-doc-aprov.cod-tip-doc = 7 NO-ERROR.
		IF AVAIL mla-tipo-doc-aprov THEN
			ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.
        
        IF  l-doc-aprova THEN DO:
    
            FOR FIRST pedido-compr FIELD(num-pedido)
                WHERE pedido-compr.num-pedido = INT(SUBSTRING(p-chave-doc,1,8)) NO-LOCK: END. 
    
            IF AVAIL pedido-compr THEN DO:
                {lap/mlaapi001.i01}
                create tt-mla-chave.
                assign tt-mla-chave.valor[1] = string(pedido-compr.num-pedido).
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT  7,
                                                    INPUT  p-cod-estabel,
                                                    INPUT  p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendProces DBOProgram 
PROCEDURE checkPendProces :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi020G
    **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendRequis DBOProgram 
PROCEDURE checkPendRequis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE empresa.ep-codigo            NO-UNDO. 
    DEFINE INPUT  PARAMETER p-empresa     LIKE estabelec.cod-estabel        NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  Item
    **/  
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 3 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        
        FOR FIRST it-requisicao FIELDS (nr-requisicao sequencia it-codigo)
            WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc,1,9)) 
              AND it-requisicao.sequencia     = INT(SUBSTRING(p-chave-doc,10,3))
              AND it-requisicao.it-codigo     = SUBSTRING(p-chave-doc,13,16)    NO-LOCK: END.
        IF AVAIL it-requisicao THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(it-requisicao.nr-requisicao)
                   tt-mla-chave.valor[2] = string(it-requisicao.sequencia)
                   tt-mla-chave.valor[3] = string(it-requisicao.it-codigo).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  3,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    end.
    ELSE DO:
        /**  Total
        **/
		FIND FIRST mla-tipo-doc-aprov NO-LOCK 
			 WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
			   AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
			   AND mla-tipo-doc-aprov.cod-tip-doc = 4 NO-ERROR.
		IF AVAIL mla-tipo-doc-aprov THEN
			ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

        IF  l-doc-aprova THEN DO:

            FOR FIRST requisicao FIELDS(nr-requisicao)
                WHERE requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc, 1, 9)) NO-LOCK: END.
    
            IF AVAIL requisicao THEN DO:
                {lap/mlaapi001.i01}
                create tt-mla-chave.
                assign tt-mla-chave.valor[1] = string(requisicao.nr-requisicao).
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT  4,
                                                    INPUT  p-cod-estabel,
                                                    INPUT  p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.
        end.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendSolCot DBOProgram 
PROCEDURE checkPendSolCot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 18 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST it-requisicao FIELDS(nr-requisicao sequencia it-codigo)
            WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc,1,9))
              AND it-requisicao.sequencia     = INT(SUBSTRING(p-chave-doc,10,3))
              AND it-requisicao.it-codigo     = SUBSTRING(p-chave-doc,13,16)     NO-LOCK: END.
        IF AVAIL it-requisicao THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(it-requisicao.nr-requisicao)
                   tt-mla-chave.valor[2] = string(it-requisicao.sequencia)
                   tt-mla-chave.valor[3] = string(it-requisicao.it-codigo).
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  18,
                                                INPUT  p-cod-estabel,
                                                INPUT  p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendSolic DBOProgram 
PROCEDURE checkPendSolic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE empresa.ep-codigo            NO-UNDO. 
    DEFINE INPUT PARAMETER p-empresa     LIKE estabelec.cod-estabel        NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  Item 
    **/  
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 1 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    IF  l-doc-aprova THEN DO:
        FOR FIRST it-requisicao FIELDS (nr-requisicao sequencia it-codigo)
             WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc,1,9)) 
               AND it-requisicao.sequencia     = INT(SUBSTRING(p-chave-doc,10,3))
               AND it-requisicao.it-codigo     = SUBSTRING(p-chave-doc,13,16)    NO-LOCK: END.

        IF AVAIL it-requisicao THEN DO:
            {lap/mlaapi001.i01} 
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(it-requisicao.nr-requisicao)
                   tt-mla-chave.valor[2] = string(it-requisicao.sequencia)
                   tt-mla-chave.valor[3] = string(it-requisicao.it-codigo).
            
            RUN checkPendDoc IN THIS-PROCEDURE (INPUT  1,
                                                INPUT p-cod-estabel,
                                                INPUT p-empresa,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).

        END.
    end.
    ELSE DO:
        /**  Total
        **/
        FIND FIRST mla-tipo-doc-aprov NO-LOCK 
             WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
               AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 2 NO-ERROR.
        IF AVAIL mla-tipo-doc-aprov THEN
            ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

        IF  l-doc-aprova THEN DO:
            FOR FIRST requisicao FIELDS(nr-requisicao)
                WHERE requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc, 1, 9)) NO-LOCK: END.
    
            IF AVAIL requisicao THEN DO:
                {lap/mlaapi001.i01}
                create tt-mla-chave.
                assign tt-mla-chave.valor[1] = string(requisicao.nr-requisicao).
                RUN checkPendDoc IN THIS-PROCEDURE (INPUT 2,
                                                    INPUT p-cod-estabel,
                                                    INPUT p-empresa,
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).
            END.
        end.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendRepCredito DBOProgram 
PROCEDURE checkPendRepCredito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter p-chave-doc   like mla-doc-pend-aprov.chave-doc no-undo.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER p-empresa     LIKE empresa.ep-codigo            NO-UNDO.
    define output parameter table for RowErrors.                                      
                                                                                      
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-empresa  
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 21 NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-doc-aprova = mla-tipo-doc-aprov.apr-tip-doc.

    if l-doc-aprova then do:
       for first ped-venda fields(nr-pedido)
           where ped-venda.nr-pedido = int(substring(p-chave-doc, 1, 11)) no-lock:
       end.
       IF AVAIL ped-venda THEN DO:
           {lap/mlaapi001.i01}
           create tt-mla-chave.
           assign tt-mla-chave.valor[1] = string(ped-venda.nr-pedido).
           run checkPendDoc in this-procedure (input  21,                                
                                               INPUT  p-cod-estabel,
                                               INPUT  p-empresa,
                                               input  table tt-mla-chave,                
                                               output table RowErrors).
       END.
    end.
    find first RowErrors no-error.
    if avail RowErrors then 
       return "NOK":U.                                                               
                                                                                      
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hmla-param-aprov) THEN
        DELETE PROCEDURE hmla-param-aprov.
    IF VALID-HANDLE(hmla-tipo-doc-aprov) THEN
        DELETE PROCEDURE hmla-tipo-doc-aprov.
    IF VALID-HANDLE(hmla-usuar-aprov) THEN
        DELETE PROCEDURE hmla-usuar-aprov.
    IF VALID-HANDLE(hmla-chave-doc) THEN
        DELETE PROCEDURE hmla-chave-doc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorValidate DBOProgram 
PROCEDURE errorValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cd-erro  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem AS CHARACTER NO-UNDO.

    {utp/ut-liter.i p-mensagem}

    {method/svc/errors/inserr.i &ErrorNumber=STRING(p-cd-erro)
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=RETURN-VALUE}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice transacao
  Parameters:  
               retorna valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-trans = RowObject.nr-trans.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  
               recebe valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    FIND FIRST bfmla-doc-pend-aprov WHERE 
        bfmla-doc-pend-aprov.nr-trans = pnr-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-doc-pend-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-doc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBO DBOProgram 
PROCEDURE initializeBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(hmla-param-aprov) THEN DO:
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.
        run openQueryStatic in hmla-param-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-doc-aprov) THEN DO:
        RUN inbo/boin784.p PERSISTENT SET hmla-tipo-doc-aprov.
        run openQueryStatic in hmla-tipo-doc-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-chave-doc) THEN DO:
        RUN inbo/boin789.p PERSISTENT SET hmla-chave-doc.
        run openQueryStatic in hmla-chave-doc (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov) THEN DO:
        RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
        run openQueryStatic in hmla-usuar-aprov (input "Main").
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeHandles DBOProgram 
PROCEDURE initializeHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-hmla-usuar-aprov        AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-tipo-doc-aprov     AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-param-aprov        AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-chave-doc          AS HANDLE      NO-UNDO.  

    ASSIGN  hmla-usuar-aprov     = p-hmla-usuar-aprov    
            hmla-tipo-doc-aprov  = p-hmla-tipo-doc-aprov 
            hmla-param-aprov     = p-hmla-param-aprov    
            hmla-chave-doc       = p-hmla-chave-doc.
   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

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
    open query {&QUERYNAME} 
        for each {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint DBOProgram 
PROCEDURE setConstraint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstab DBOProgram 
PROCEDURE getEstab:
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-tip-doc     AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc       LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-cod-estabelec LIKE estabelec.cod-estabel        NO-UNDO.

    /**  Solicitaá∆o/Requisiá∆o por Item
    **/
    IF  p-cod-tip-doc = 1 OR 
        p-cod-tip-doc = 3 THEN DO:
         FOR FIRST it-requisicao FIELDS(nr-requisicao sequencia it-codigo cod-estabel)
             WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc,1,9))  
               AND it-requisicao.sequencia     = INT(SUBSTRING(p-chave-doc,10,3)) 
               AND it-requisicao.it-codigo     = SUBSTRING(p-chave-doc,13,16)     NO-LOCK: END.
        
        IF AVAIL it-requisicao THEN DO:
            ASSIGN p-c-cod-estabelec = it-requisicao.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    /**  Solicitaá∆o/Requisiá∆o por Total
    **/
    IF  p-cod-tip-doc = 2 OR 
        p-cod-tip-doc = 4 THEN DO:
        FOR FIRST requisicao FIELDS(nr-requisicao cod-estabel)
            WHERE requisicao.nr-requisicao = INT(SUBSTRING(p-chave-doc, 1, 9)) NO-LOCK: END.
        IF AVAIL requisicao THEN DO:
            ASSIGN p-c-cod-estabelec = requisicao.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    /**  Cotaá∆o de Materiais
    **/
    IF  p-cod-tip-doc = 5 THEN DO:
        FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente it-codigo seq-cotac)
            WHERE cotacao-item.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8))  
              AND cotacao-item.cod-emitente = INT(SUBSTRING(p-chave-doc,9,9))  
              AND cotacao-item.it-codigo    =     SUBSTRING(p-chave-doc,17,16) 
              AND cotacao-item.seq-cotac    = INT(SUBSTRING(p-chave-doc,34,3)) NO-LOCK: END.
        
        FOR FIRST ordem-compra FIELDS (numero-ordem cod-estabel)
             WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

        IF AVAIL ordem-compra THEN DO:
            ASSIGN p-c-cod-estabelec = ordem-compra.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.
     
    /**  Pedido de Compra por Item
    **/
    IF  p-cod-tip-doc = 6 OR 
        p-cod-tip-doc = 19 THEN DO:
        FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem cod-estabel)
            WHERE ordem-compra.num-pedido   = INT(SUBSTRING(p-chave-doc,1,8)) 
              AND ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,9,8)) NO-LOCK: END.
        IF AVAIL ordem-compra THEN DO:
            ASSIGN p-c-cod-estabelec = ordem-compra.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    /**  Pedido de Compra por Total / Emergencial
    **/
    IF  p-cod-tip-doc = 7 OR 
        p-cod-tip-doc = 8 THEN DO:
        FOR FIRST pedido-compr FIELDS(num-pedido cod-estab-gestor end-entrega)
            WHERE pedido-compr.num-pedido = INT(SUBSTRING(p-chave-doc,1,8)) NO-LOCK: END. 
        IF AVAIL pedido-compr THEN DO:
            ASSIGN p-c-cod-estabelec = pedido-compr.cod-estab-gestor.
            IF  p-c-cod-estabelec = "" THEN 
                ASSIGN p-c-cod-estabelec = pedido-compr.end-entrega.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    /**  Contrato de Fornecimento
    **/
    IF  p-cod-tip-doc = 13 THEN DO:
        FOR FIRST contrato-for FIELDS(nr-contrato cod-estabel)
            WHERE contrato-for.nr-contrato = INT(SUBSTRING(p-chave-doc,1,9)) NO-LOCK: END.

        IF AVAIL contrato-for THEN DO:
            ASSIGN p-c-cod-estabelec = contrato-for.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE 
            RETURN "NOK":U.
   END.

   /**  Mediá∆o de Contrato
   **/
   IF  p-cod-tip-doc = 14 THEN DO:
       FOR FIRST medicao-contrat FIELDS(nr-contrato num-seq-item numero-ordem num-seq-event num-seq-medicao cod-estabel)
           WHERE medicao-contrat.nr-contrato     = INT(SUBSTRING(p-chave-doc,1,9))  
             AND medicao-contrat.num-seq-item    = INT(SUBSTRING(p-chave-doc,10,5)) 
             AND medicao-contrat.numero-ordem    = INT(SUBSTRING(p-chave-doc,15,8)) 
             AND medicao-contrat.num-seq-event   = INT(SUBSTRING(p-chave-doc,23,4)) 
             AND medicao-contrat.num-seq-medicao = INT(SUBSTRING(p-chave-doc,27,4)) NO-LOCK: END.

       &if "{&bf_mat_versao_ems}" >= "2.04" &then
           if  avail medicao-contrat THEN DO:
               assign p-c-cod-estabelec = medicao-contrat.cod-estabel.
               RETURN "OK":U.
           END.
           ELSE
               RETURN "NOK":U.
       &else
           IF AVAIL medicao-contrat THEN DO:
               FOR FIRST contrato-for FIELDS(nr-contrato cod-estabel)
                    where contrato-for.nr-contrato = medicao-contrat.nr-contrato NO-LOCK: END.
               if  avail contrato-for THEN DO:
                   assign p-c-cod-estabelec = contrato-for.cod-estabel.
                   RETURN "OK":U.
               END.
               ELSE
                   RETURN "NOK":U.
           END.
           ELSE
               RETURN "NOK":U.
       &endif
   END.

   /**  Evento de Contrato
   **/
   IF  p-cod-tip-doc = 16 THEN DO:
        FOR FIRST evento-ped FIELDS(numero-ordem dat-prev-event seq-evento cod-estabel nr-contrato)
            WHERE evento-ped.numero-ordem   = INT(SUBSTRING(p-chave-doc,1,8))   
              AND evento-ped.dat-prev-event = DATE(SUBSTRING(p-chave-doc,9,10))
              AND evento-ped.seq-evento     = INT(SUBSTRING(p-chave-doc,19,2))  NO-LOCK: END.
        
        IF AVAIL evento-ped THEN DO:
            FOR FIRST contrato-for FIELDS(nr-contrato cod-estabel)
                WHERE contrato-for.nr-contrato = evento-ped.nr-contrato NO-LOCK: END.
            ASSIGN p-c-cod-estabelec = evento-ped.cod-estabel.
            IF  p-c-cod-estabelec = "" THEN 
                ASSIGN p-c-cod-estabelec = contrato-for.cod-estabel.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    /**  Solicitaá∆o de Cotaá∆o
    **/
    IF  p-cod-tip-doc = 18 THEN DO:
        FOR FIRST ordem-compra FIELDS(numero-ordem)
             WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8)) NO-LOCK: END.
        
        IF AVAIL ordem-compra THEN DO:
            FOR FIRST it-requisicao FIELDS(nr-requisicao sequencia it-codigo cod-estabel)
                 WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao 
                   AND it-requisicao.sequencia     = ordem-compra.sequencia 
                   AND it-requisicao.it-codigo     = ordem-compra.it-codigo NO-LOCK: END.
            IF  AVAIL it-requisicao THEN DO:
                ASSIGN p-c-cod-estabelec = it-requisicao.cod-estabel.
                RETURN "OK":U.
            END.
            ELSE
                RETURN "NOK":U.
        END.
        ELSE
            RETURN "NOK":U.
    END.

    if p-cod-tip-doc = 21 then do:
       for first ped-venda fields(cod-estabel)
           where ped-venda.nr-pedido = int(substring(p-chave-doc, 1, 11)) no-lock:
       end.
       if avail ped-venda THEN DO:
          assign p-c-cod-estabelec = ped-venda.cod-estabel.
          RETURN "OK":U.
       END.
       ELSE RETURN "NOK":U.
    end.    

    IF p-cod-tip-doc = 29 OR p-cod-tip-doc = 30 OR p-cod-tip-doc = 31 THEN DO:
       ASSIGN p-c-cod-estabelec = TRIM(substring(p-chave-doc, 1, 3)).
          RETURN "OK":U.
    END. 
    ELSE RETURN "NOK":U.   

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



