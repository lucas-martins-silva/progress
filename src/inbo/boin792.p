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
{include/i-prgvrs.i BOIN792 2.00.00.012 } /*** "010012" 24/11/2023 13:25:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin792 MUT}
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
&GLOBAL-DEFINE DBOName boin792
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-hierarquia-aprov
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
{inbo/boin792.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{inbo/boin792.i1} /* Temp-tables utilizadas na piSubstituiAprovador */

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
         HEIGHT             = 6.42
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
        WHEN "cod-lotacao":U THEN ASSIGN pFieldValue = RowObject.cod-lotacao.
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
  Purpose:     Retorna valores dos campos do °ndice lotacao
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-lotacao
               retorna valor do campo cod-tip-doc
               retorna valor do campo seq-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-hierarquia-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-hierarquia-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-lotacao LIKE mla-hierarquia-aprov.cod-lotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-hierarquia-aprov.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-aprov LIKE mla-hierarquia-aprov.seq-aprov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-lotacao = RowObject.cod-lotacao
           pcod-tip-doc = RowObject.cod-tip-doc
           pseq-aprov = RowObject.seq-aprov.

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
        WHEN "log-depend":U THEN ASSIGN pFieldValue = RowObject.log-depend.
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
  Purpose:     Reposiciona registro com base no °ndice lotacao
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-lotacao
               recebe valor do campo cod-tip-doc
               recebe valor do campo seq-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-hierarquia-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-hierarquia-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-hierarquia-aprov.cod-lotacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-hierarquia-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pseq-aprov LIKE mla-hierarquia-aprov.seq-aprov NO-UNDO.

    FIND FIRST bfmla-hierarquia-aprov WHERE 
        bfmla-hierarquia-aprov.ep-codigo = pep-codigo AND 
        bfmla-hierarquia-aprov.cod-estabel = pcod-estabel AND 
        bfmla-hierarquia-aprov.cod-lotacao = pcod-lotacao AND 
        bfmla-hierarquia-aprov.cod-tip-doc = pcod-tip-doc AND 
        bfmla-hierarquia-aprov.seq-aprov = pseq-aprov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-hierarquia-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-hierarquia-aprov)).
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
  Purpose:  Substituir o aprovador no hierarquia de aprovadores.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu†rio origem
               pcOrigem          : Usu†rio destino
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-hierarquia-aprov-origem  : ContÇm os dados dos registros(hierarquia de aprovadores) do usu†rio origem
               tt-mla-hierarquia-aprov-destino : ContÇm os dados dos registros(hierarquia de aprovadores) do usu†rio destino
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.        
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.        
    DEFINE INPUT PARAM pcEstabIni        LIKE estabelec.cod-estabel NO-UNDO.    
    DEFINE INPUT PARAM pcEstabFim        LIKE estabelec.cod-estabel NO-UNDO.    
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.                 
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-hierarquia-aprov-origem.            
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-hierarquia-aprov-destino.  

    EMPTY TEMP-TABLE tt-mla-hierarquia-aprov-origem.  
    EMPTY TEMP-TABLE tt-mla-hierarquia-aprov-destino. 

    /* Label's */
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).   


    DEFINE VARIABLE h-boin769 AS HANDLE      NO-UNDO.
    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcOrigem
    BREAK BY bf{&TableName}.ep-codigo  
          BY bf{&TableName}.cod-estabel
          BY bf{&TableName}.cod-lotacao
          BY bf{&TableName}.cod-tip-doc
          BY bf{&TableName}.cod-usuar:  

        IF FIRST-OF(bf{&TableName}.ep-codigo)   OR
           FIRST-OF(bf{&TableName}.cod-estabel) OR
           FIRST-OF(bf{&TableName}.cod-lotacao) OR
           FIRST-OF(bf{&TableName}.cod-tip-doc) THEN

            FOR EACH mla-hierarquia-aprov NO-LOCK
               WHERE mla-hierarquia-aprov.ep-codigo   = bf{&TableName}.ep-codigo
                 AND mla-hierarquia-aprov.cod-estabel = bf{&TableName}.cod-estabel
                 AND mla-hierarquia-aprov.cod-lotacao = bf{&TableName}.cod-lotacao 
                 AND mla-hierarquia-aprov.cod-tip-doc = bf{&TableName}.cod-tip-doc: 

                CREATE tt-mla-hierarquia-aprov-origem.
                BUFFER-COPY mla-hierarquia-aprov TO tt-mla-hierarquia-aprov-origem.
                {utp/ut-liter.i "Origem"}
                ASSIGN tt-mla-hierarquia-aprov-origem.situacao = TRIM(RETURN-VALUE)
                       tt-mla-hierarquia-aprov-origem.id-sit   = 5
                       tt-mla-hierarquia-aprov-origem.r-rowid  = ROWID(mla-hierarquia-aprov).

                CREATE tt-mla-hierarquia-aprov-destino.
                BUFFER-COPY mla-hierarquia-aprov  TO tt-mla-hierarquia-aprov-destino.
                IF mla-hierarquia-aprov.cod-usuar = pcOrigem THEN 
                    {utp/ut-liter.i "Substitu°do" * R} 
                ELSE 
                    {utp/ut-liter.i "Mantido" * R}

                ASSIGN tt-mla-hierarquia-aprov-destino.situacao  = TRIM(RETURN-VALUE)
                       tt-mla-hierarquia-aprov-destino.id-sit    = IF mla-hierarquia-aprov.cod-usuar = pcOrigem THEN 3 ELSE 1
                       tt-mla-hierarquia-aprov-destino.cod-usuar = IF mla-hierarquia-aprov.cod-usuar = pcOrigem THEN pcDestino ELSE mla-hierarquia-aprov.cod-usuar
                       tt-mla-hierarquia-aprov-destino.r-rowid   = ROWID(mla-hierarquia-aprov).

                IF NOT plSimulaAlteracao AND mla-hierarquia-aprov.cod-usuar = pcOrigem THEN DO:

                    /*--- Reposiciona rowid do registro corrente ---*/
                    RUN emptyRowObject IN THIS-PROCEDURE.
                    RUN emptyRowErrors IN THIS-PROCEDURE.
                    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-mla-hierarquia-aprov-origem.r-rowid).
                    IF RETURN-VALUE = "NOK":U THEN NEXT.
                    RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
                    FIND FIRST rowObject NO-ERROR.
                    IF NOT AVAIL rowObject THEN NEXT.

                    RUN pi-gera-log IN h-boin769(INPUT 4, 
                                                 INPUT rowObject.r-rowid,
                                                 INPUT 2, 
                                                 INPUT ENTRY(4,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                       c-lbl-usuar + ": " + pcOrigem   + chr(13) + 
                                                       "              " + pcDestino).

                    ASSIGN rowObject.cod-usuar = pcDestino.
                    RUN setRecord IN THIS-PROCEDURE(INPUT TABLE rowObject).
                    RUN updateRecord IN THIS-PROCEDURE.
                END.
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
        AND CAN-FIND(FIRST mla-hierarquia-aprov
                     WHERE mla-hierarquia-aprov.ep-codigo = RowObject.ep-codigo
                       AND mla-hierarquia-aprov.cod-estabel = RowObject.cod-estabel
                       AND mla-hierarquia-aprov.cod-lotacao = RowObject.cod-lotacao
                       AND mla-hierarquia-aprov.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-hierarquia-aprov.seq-aprov = RowObject.seq-aprov) THEN DO:
            {utp/ut-liter.i hierarquia_de_aprovadores"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida empresa */
        IF NOT CAN-FIND(FIRST empresa
                        WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida estabelecimento */
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Lotaá∆o */
        IF NOT CAN-FIND(FIRST mla-lotacao
                        WHERE mla-lotacao.cod-lotacao = RowObject.cod-lotacao
                          AND mla-lotacao.ep-codigo   = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "lotaá∆o"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Documento */
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                          AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Usu†rio */
        IF NOT CAN-FIND(FIRST mla-usuar-aprov
                        WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            /* Inicio -- Projeto Internacional */ 
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

