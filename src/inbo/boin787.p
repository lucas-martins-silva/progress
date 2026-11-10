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
{include/i-prgvrs.i BOIN787 2.00.00.011 } /*** "010011" 24/11/2023 13:25:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin787 MUT}
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
&GLOBAL-DEFINE DBOName BOIN787
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-usuar-padrao
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
{inbo/boin787.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{inbo/boin787.i1} /* Temp-tables utilizadas na piSubstituiAprovador */

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
        WHEN "cod-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-tip-aprov.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice tipo
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tip-aprov
               retorna valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-usuar-padrao.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-usuar-padrao.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-aprov LIKE mla-usuar-padrao.cod-tip-aprov NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-usuar-padrao.cod-usuar NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-tip-aprov = RowObject.cod-tip-aprov
           pcod-usuar = RowObject.cod-usuar.

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
  Purpose:     Reposiciona registro com base no °ndice tipo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-aprov
               recebe valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-usuar-padrao.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-usuar-padrao.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-aprov LIKE mla-usuar-padrao.cod-tip-aprov NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-usuar-padrao.cod-usuar NO-UNDO.

    FIND FIRST bfmla-usuar-padrao WHERE 
        bfmla-usuar-padrao.ep-codigo = pep-codigo AND 
        bfmla-usuar-padrao.cod-estabel = pcod-estabel AND 
        bfmla-usuar-padrao.cod-tip-aprov = pcod-tip-aprov AND 
        bfmla-usuar-padrao.cod-usuar = pcod-usuar NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-usuar-padrao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-usuar-padrao)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyUsuario DBOProgram 
PROCEDURE goToKeyUsuario :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice tipo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-aprov
               recebe valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-usuar-padrao.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-usuar-padrao.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-aprov LIKE mla-usuar-padrao.cod-tip-aprov NO-UNDO.

    FIND FIRST bfmla-usuar-padrao WHERE 
        bfmla-usuar-padrao.ep-codigo = pep-codigo AND 
        bfmla-usuar-padrao.cod-estabel = pcod-estabel AND 
        bfmla-usuar-padrao.cod-tip-aprov = pcod-tip-aprov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-usuar-padrao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-usuar-padrao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
  Purpose:  Substituir os aprovadores padr‰es.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu†rio origem
               pcOrigem          : Usu†rio destino
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-usuar-padrao-origem  : ContÇm os dados dos registros(Aprovadores padr‰es) do usu†rio origem
               tt-mla-usuar-padrao-destino : ContÇm os dados dos registros(Aprovadores padr‰es) do usu†rio destino
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.          
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.          
    DEFINE INPUT PARAM pcEstabIni        LIKE estabelec.cod-estabel NO-UNDO.      
    DEFINE INPUT PARAM pcEstabFim        LIKE estabelec.cod-estabel NO-UNDO.      
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.  
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.  
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.                      
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-usuar-padrao-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-usuar-padrao-destino.

    EMPTY TEMP-TABLE tt-mla-usuar-padrao-origem. 
    EMPTY TEMP-TABLE tt-mla-usuar-padrao-destino.

    /* Label's */
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769. 

    FOR EACH mla-usuar-padrao NO-LOCK
       WHERE mla-usuar-padrao.ep-codigo   >= pcEmpresaIni
         AND mla-usuar-padrao.ep-codigo   <= pcEmpresaFim
         AND mla-usuar-padrao.cod-estabel >= pcEstabIni
         AND mla-usuar-padrao.cod-estabel <= pcEstabFim 
         AND mla-usuar-padrao.cod-usuar    = pcOrigem:

        CREATE tt-mla-usuar-padrao-origem.
        BUFFER-COPY mla-usuar-padrao TO tt-mla-usuar-padrao-origem.
        {utp/ut-liter.i "Origem" * R}
        ASSIGN tt-mla-usuar-padrao-origem.situacao = TRIM(RETURN-VALUE)
               tt-mla-usuar-padrao-origem.id-sit   = 5
               tt-mla-usuar-padrao-origem.r-rowid  = ROWID(mla-usuar-padrao).

        CREATE tt-mla-usuar-padrao-destino.
        BUFFER-COPY mla-usuar-padrao TO tt-mla-usuar-padrao-destino.
        {utp/ut-liter.i "Substitu°do" * R}
        ASSIGN tt-mla-usuar-padrao-destino.situacao  = TRIM(RETURN-VALUE)
               tt-mla-usuar-padrao-destino.id-sit    = 3
               tt-mla-usuar-padrao-destino.cod-usuar = pcDestino
               tt-mla-usuar-padrao-destino.r-rowid   = ROWID(mla-usuar-padrao).

        IF NOT plSimulaAlteracao THEN DO:
            
            /*--- Reposiciona rowid do registro corrente ---*/
            RUN emptyRowObject IN THIS-PROCEDURE.
            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
            RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-mla-usuar-padrao-origem.r-rowid).
            IF RETURN-VALUE = "NOK":U THEN NEXT.
            RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
            FIND FIRST rowObject NO-ERROR.
            IF NOT AVAIL rowObject THEN NEXT.

            RUN pi-gera-log IN h-boin769(INPUT 25, 
                                         INPUT rowObject.r-rowid,
                                         INPUT 2, 
                                         INPUT ENTRY(25,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                               c-lbl-usuar + ": " + pcOrigem  + CHR(13) + 
                                               "             " + pcDestino).
            ASSIGN RowObject.cod-usuar = pcDestino.
            RUN setRecord IN THIS-PROCEDURE(INPUT TABLE rowObject).
            RUN updateRecord IN THIS-PROCEDURE.
        END.
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
        AND CAN-FIND(FIRST mla-usuar-padrao
                     WHERE mla-usuar-padrao.ep-codigo = RowObject.ep-codigo
                       AND mla-usuar-padrao.cod-estabel = RowObject.cod-estabel
                       AND mla-usuar-padrao.cod-tip-aprov = RowObject.cod-tip-aprov
                       AND mla-usuar-padrao.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu†rio_padr∆o"}
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

        /* Existància do codigo da aprovaá∆o */
        IF NOT CAN-FIND (FIRST mla-tipo-aprov
                         WHERE mla-tipo-aprov.cod-tip-aprov = RowObject.cod-tip-aprov) THEN DO:
            {utp/ut-liter.i "c¢digo_da_aprovaá∆o"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do usu†rio */
        IF NOT CAN-FIND (FIRST mla-usuar-aprov
                         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "aprovador"}
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

