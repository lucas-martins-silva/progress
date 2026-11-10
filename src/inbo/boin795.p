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
{include/i-prgvrs.i BOIN795 2.00.00.010 } /*** "010010" 24/11/2023 13:25:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin795 MUT}
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
&GLOBAL-DEFINE DBOName boin795
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-lista-aprov-doc
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
{inbo/boin795.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def temp-table tt-lista NO-UNDO
    field seq-aprov       like mla-lista-aprov-doc.seq-aprov
    field cod-usuar-aprov like mla-lista-aprov-doc.cod-usuar
    field limite-aprov    like mla-perm-aprov.limite-aprov
    field rowlista        as rowid
    index chave as primary seq-aprov
    index limite limite-aprov.

DEFINE VARIABLE de-limite-aprov AS DECIMAL    NO-UNDO.

DEFINE VARIABLE hmla-perm-aprov AS HANDLE NO-UNDO.

{inbo/boin795.i1} /* Temp-tables utilizadas na piSubstituiAprovador */

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
         HEIGHT             = 2.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hmla-perm-aprov) THEN
        DELETE PROCEDURE hmla-perm-aprov.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        &IF "{&mguni_version}" < "2.071" &THEN
             WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "seq-aprov":U THEN ASSIGN pFieldValue = RowObject.seq-aprov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tip-doc
               retorna valor do campo seq-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-lista-aprov-doc.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-lista-aprov-doc.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-lista-aprov-doc.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-aprov LIKE mla-lista-aprov-doc.seq-aprov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-tip-doc = RowObject.cod-tip-doc
           pseq-aprov = RowObject.seq-aprov.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getListaAprov DBOProgram 
PROCEDURE getListaAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ep-codigo      LIKE empresa.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel    LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-tip-doc    AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-valor-doc      AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER p-somente-limite AS LOGICAL   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-lista.
                  
    RUN initializeBO IN THIS-PROCEDURE.

    FOR EACH {&TABLENAME} WHERE 
        {&TABLENAME}.ep-codigo   = p-ep-codigo   AND    
        {&TABLENAME}.cod-estabel = p-cod-estabel AND    
        {&TABLENAME}.cod-tip-doc = p-cod-tip-doc NO-LOCK:

        RUN goToKey IN hmla-perm-aprov (INPUT p-ep-codigo,
                                  INPUT p-cod-estabel,
                                  INPUT {&TABLENAME}.cod-usuar,
                                  INPUT p-cod-tip-doc).
        IF  RETURN-VALUE = "OK" THEN DO:
            RUN getDecField IN hmla-perm-aprov (INPUT "limite-aprov",
                                          OUTPUT de-limite-aprov).
            IF  de-limite-aprov < p-valor-doc AND
                p-somente-limite THEN
                NEXT.
            
            CREATE tt-lista.
            ASSIGN tt-lista.seq-aprov       = {&TABLENAME}.seq-aprov
                   tt-lista.cod-usuar-aprov = {&TABLENAME}.cod-usuar
                   tt-lista.limite-aprov    = de-limite-aprov
                   tt-lista.rowlista        = ROWID({&TABLENAME}).
        END.
    END.
                  
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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
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
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-doc
               recebe valor do campo seq-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-lista-aprov-doc.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-lista-aprov-doc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-lista-aprov-doc.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pseq-aprov LIKE mla-lista-aprov-doc.seq-aprov NO-UNDO.

    FIND FIRST bfmla-lista-aprov-doc WHERE 
        bfmla-lista-aprov-doc.ep-codigo = pep-codigo AND 
        bfmla-lista-aprov-doc.cod-estabel = pcod-estabel AND 
        bfmla-lista-aprov-doc.cod-tip-doc = pcod-tip-doc AND 
        bfmla-lista-aprov-doc.seq-aprov = pseq-aprov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-lista-aprov-doc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-lista-aprov-doc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowid DBOProgram 
PROCEDURE goToKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe rowid do registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prowid AS ROWID NO-UNDO.

    FIND FIRST bfmla-lista-aprov-doc WHERE 
        ROWID(bfmla-lista-aprov-doc) = prowid
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-lista-aprov-doc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-lista-aprov-doc)).
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
    IF  NOT VALID-HANDLE(hmla-perm-aprov) THEN DO:
        RUN inbo/boin774.p PERSISTENT SET hmla-perm-aprov.
        run openQueryStatic in hmla-perm-aprov (input "Main").
    END.

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
        for each {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSubstituiAprovador DBOProgram 
PROCEDURE piSubstituiAprovador :
/*------------------------------------------------------------------------------
  Purpose:  Substituir ou eliminar usu†rio da lista de aprovadores do documento
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu†rio origem
               pcOrigem          : Usu†rio destino
               plManterUsuario   : Indica se o usu†rio deve ser mantido ou n∆o na lista caso j† exista o usu†rio detino na lista corrente.
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-lista-aprov-doc-origem  : ContÇm os dados dos registros(Aprovadores do documento) do usu†rio origem
               tt-mla-lista-aprov-doc-destino : ContÇm os dados dos registros(Aprovadores do documento) do usu†rio destino
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEstabIni        LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pcEstabFim        LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM plManterUsuario   AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-lista-aprov-doc-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-lista-aprov-doc-destino.

    EMPTY TEMP-TABLE tt-mla-lista-aprov-doc-origem. 
    EMPTY TEMP-TABLE tt-mla-lista-aprov-doc-destino.

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcOrigem
    BREAK BY bf{&TableName}.ep-codigo  
          BY bf{&TableName}.cod-estabel
          BY bf{&TableName}.cod-tip-doc:

        IF FIRST-OF(bf{&TableName}.cod-tip-doc) OR
           FIRST-OF(bf{&TableName}.cod-estabel) OR
           FIRST-OF(bf{&TableName}.cod-tip-doc) THEN

            FOR EACH mla-lista-aprov-doc NO-LOCK
               WHERE mla-lista-aprov-doc.ep-codigo   = bf{&TableName}.ep-codigo  
                 AND mla-lista-aprov-doc.cod-estabel = bf{&TableName}.cod-estabel
                 AND mla-lista-aprov-doc.cod-tip-doc = bf{&TableName}.cod-tip-doc:
                
                CREATE tt-mla-lista-aprov-doc-origem.
                BUFFER-COPY mla-lista-aprov-doc TO tt-mla-lista-aprov-doc-origem.
                {utp/ut-liter.i "Origem" * R}
                ASSIGN tt-mla-lista-aprov-doc-origem.situacao = TRIM(RETURN-VALUE)
                       tt-mla-lista-aprov-doc-origem.id-sit   = 5
                       tt-mla-lista-aprov-doc-origem.r-rowid  = ROWID(mla-lista-aprov-doc).

                /* In°cio criaá∆o das temp-tables */
                IF pcOrigem <> mla-lista-aprov-doc.cod-usuar THEN DO:
                    CREATE tt-mla-lista-aprov-doc-destino.
                    BUFFER-COPY mla-lista-aprov-doc TO tt-mla-lista-aprov-doc-destino.
                    {utp/ut-liter.i "Mantido" * R}
                    ASSIGN tt-mla-lista-aprov-doc-destino.situacao = TRIM(RETURN-VALUE)
                           tt-mla-lista-aprov-doc-destino.id-sit   = 1
                           tt-mla-lista-aprov-doc-destino.r-rowid  = ROWID(mla-lista-aprov-doc).
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST mla-lista-aprov-doc 
                                WHERE mla-lista-aprov-doc.ep-codigo   = bf{&TableName}.ep-codigo   
                                  AND mla-lista-aprov-doc.cod-estabel = bf{&TableName}.cod-estabel 
                                  AND mla-lista-aprov-doc.cod-tip-doc = bf{&TableName}.cod-tip-doc
                                  AND mla-lista-aprov-doc.cod-usuar   = pcDestino) THEN DO:

                        CREATE tt-mla-lista-aprov-doc-destino.
                        BUFFER-COPY mla-lista-aprov-doc TO tt-mla-lista-aprov-doc-destino.
                        {utp/ut-liter.i "Substitu°do" * R}
                        ASSIGN tt-mla-lista-aprov-doc-destino.situacao  = TRIM(RETURN-VALUE)
                               tt-mla-lista-aprov-doc-destino.id-sit   = 3
                               tt-mla-lista-aprov-doc-destino.r-rowid   = ROWID(mla-lista-aprov-doc)
                               tt-mla-lista-aprov-doc-destino.cod-usuar = pcDestino.
                    END.
                    ELSE DO:
                        CREATE tt-mla-lista-aprov-doc-destino.
                        BUFFER-COPY mla-lista-aprov-doc TO tt-mla-lista-aprov-doc-destino.

                        IF NOT plManterUsuario THEN DO:
                            ASSIGN tt-mla-lista-aprov-doc-destino.id-sit  = 4.
                            {utp/ut-liter.i "Eliminado" * R}
                        END.
                        ELSE DO:
                            ASSIGN tt-mla-lista-aprov-doc-destino.id-sit  = 1.
                            {utp/ut-liter.i "Mantido" * R}
                        END.
                            
                        ASSIGN tt-mla-lista-aprov-doc-destino.situacao  = TRIM(RETURN-VALUE)
                               tt-mla-lista-aprov-doc-destino.r-rowid   = ROWID(mla-lista-aprov-doc).
                    END.
                END.
            END.
    END.

    /* Label's */
    DEFINE VARIABLE c-lbl-doc      AS CHARACTER   NO-UNDO. 
    DEFINE VARIABLE c-lbl-seq      AS CHARACTER   NO-UNDO.  
    DEFINE VARIABLE c-lbl-usuar    AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).   

    {utp/ut-liter.i "Documento" * R}
    ASSIGN c-lbl-doc = TRIM(RETURN-VALUE).    

    {utp/ut-liter.i "Sequància" * R}
    ASSIGN c-lbl-seq = TRIM(RETURN-VALUE). 


    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.

    DEFINE VARIABLE c-empresa-ant     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-estabel-ant     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-tip-doc-ant AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-aprov-ant   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE r-rowid           AS ROWID       NO-UNDO.

    IF NOT plSimulaAlteracao THEN
        FOR EACH tt-mla-lista-aprov-doc-destino:
            /*--- Reposiciona rowid do registro corrente ---*/
            RUN emptyRowObject IN THIS-PROCEDURE.
            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
            RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-mla-lista-aprov-doc-destino.r-rowid).
            IF RETURN-VALUE = "NOK":U THEN NEXT.
            RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
            FIND FIRST rowObject NO-ERROR.
            IF NOT AVAIL rowObject THEN NEXT.

            CASE tt-mla-lista-aprov-doc-destino.id-sit:
                WHEN 4 THEN DO:
    
                    ASSIGN c-empresa-ant     = rowObject.ep-codigo
                           c-estabel-ant     = rowObject.cod-estabel
                           i-cod-tip-doc-ant = rowObject.cod-tip-doc
                           i-seq-aprov-ant   = rowObject.seq-aprov.

                    RUN pi-gera-log IN h-boin769(INPUT 7, 
                                                 INPUT rowObject.r-rowid,
                                                 INPUT 3, 
                                                 INPUT ENTRY(7,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                       c-lbl-doc   + "          : " + STRING(rowObject.cod-tip-doc) + CHR(13) + 
                                                       c-lbl-seq   + "          : " + STRING(rowObject.seq-aprov)   + CHR(13) + 
                                                       c-lbl-usuar + "            : " + STRING(rowObject.cod-usuar)).
                    RUN deleteRecord IN THIS-PROCEDURE.

                    /* Re-ordenaá∆o das sequàncias */
                    FOR EACH mla-lista-aprov-doc NO-LOCK
                       WHERE mla-lista-aprov-doc.ep-codigo   = c-empresa-ant 
                         AND mla-lista-aprov-doc.cod-estabel = c-estabel-ant 
                         AND mla-lista-aprov-doc.cod-tip-doc = i-cod-tip-doc-ant 
                         AND mla-lista-aprov-doc.seq-aprov   > i-seq-aprov-ant:

                        ASSIGN i-seq-aprov-ant = mla-lista-aprov-doc.seq-aprov
                               r-rowid = ROWID(mla-lista-aprov-doc). /* Necess†rio salva rowid nesta var†ivel para que o repositionRecord n∆o se perca  */

                        /*--- Reposiciona rowid do registro corrente ---*/
                        RUN emptyRowObject IN THIS-PROCEDURE.
                        RUN emptyRowErrors IN THIS-PROCEDURE.
                        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid). 
                        IF RETURN-VALUE = "NOK":U THEN NEXT.
                        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
                        FIND FIRST rowObject NO-ERROR.
                        IF NOT AVAIL rowObject THEN NEXT.
                        
                        ASSIGN rowObject.seq-aprov =  (rowObject.seq-aprov - 10).
                        RUN setRecord IN THIS-PROCEDURE(INPUT TABLE rowObject).
                        RUN updateRecord IN THIS-PROCEDURE.
                        RUN pi-gera-log IN h-boin769(INPUT 7, 
                                                     INPUT rowObject.r-rowid, 
                                                     INPUT 2, 
                                                     INPUT ENTRY(7,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                           c-lbl-seq + "          : " + STRING(i-seq-aprov-ant)  + CHR(13) + 
                                                           "                             " + STRING(rowObject.seq-aprov)).
                    END.

                END.
                WHEN 3 THEN DO:
    
                    RUN pi-gera-log IN h-boin769(INPUT 7, 
                                                 INPUT rowObject.r-rowid,
                                                 INPUT 2, 
                                                 INPUT ENTRY(7,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                       c-lbl-usuar + ": " + rowObject.cod-usuar + CHR(13) + 
                                                       "              " + STRING(tt-mla-lista-aprov-doc-destino.cod-usuar)).
                    ASSIGN rowObject.cod-usuar = tt-mla-lista-aprov-doc-destino.cod-usuar.
                    RUN setRecord IN THIS-PROCEDURE(INPUT TABLE rowObject).
                    RUN updateRecord IN THIS-PROCEDURE.
          
                END.
            END CASE.
        END. 

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

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
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-lista-aprov-doc
                     WHERE mla-lista-aprov-doc.ep-codigo = RowObject.ep-codigo
                       AND mla-lista-aprov-doc.cod-estabel = RowObject.cod-estabel
                       AND mla-lista-aprov-doc.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-lista-aprov-doc.seq-aprov = RowObject.seq-aprov) THEN DO:
            {utp/ut-liter.i "lista_de_aprovadores_do_documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.


        /* Existància da empresa */
        IF NOT CAN-FIND (FIRST empresa
                         WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do estabelecimento */
        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do aprovador */
        IF NOT CAN-FIND (FIRST mla-usuar-aprov
                         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu†rio"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do documento */
        IF NOT CAN-FIND (FIRST mla-tipo-doc-aprov
                         WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                           AND mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc) THEN DO:
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.
    END. 

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

