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
{include/i-prgvrs.i BOIN788 2.00.00.013 } /*** "010013" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin788 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin788
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-verba-aprov
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin788.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-lbl-periodo-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-periodo-fim AS CHARACTER   NO-UNDO.


{inbo/boin788.i1} /* Defini‡Æo das Temp-tables utilizadas na pi-copia-substituicao-permissoes */
{utp/ut-glob.i}  /* Inform‡äes do usu rio corrente*/

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
         HEIGHT             = 2.46
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
        WHEN "cod-usuar-lib":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-lib.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
        WHEN "data-lib":U THEN ASSIGN pFieldValue = RowObject.data-lib.
        WHEN "periodo-fim":U THEN ASSIGN pFieldValue = RowObject.periodo-fim.
        WHEN "periodo-ini":U THEN ASSIGN pFieldValue = RowObject.periodo-ini.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
        WHEN "valor-verba":U THEN ASSIGN pFieldValue = RowObject.valor-verba.
        WHEN "verba-utilizada":U THEN ASSIGN pFieldValue = RowObject.verba-utilizada.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-usuar
               retorna valor do campo cod-tip-doc
               retorna valor do campo periodo-ini
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-verba-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-verba-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-verba-aprov.cod-usuar NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-verba-aprov.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pperiodo-ini LIKE mla-verba-aprov.periodo-ini NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-usuar = RowObject.cod-usuar
           pcod-tip-doc = RowObject.cod-tip-doc
           pperiodo-ini = RowObject.periodo-ini.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-usuar
               recebe valor do campo cod-tip-doc
               recebe valor do campo periodo-ini
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-verba-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-verba-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-verba-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-verba-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo-ini LIKE mla-verba-aprov.periodo-ini NO-UNDO.

    FIND FIRST bfmla-verba-aprov WHERE
        bfmla-verba-aprov.ep-codigo = pep-codigo AND
        bfmla-verba-aprov.cod-estabel = pcod-estabel AND
        bfmla-verba-aprov.cod-usuar = pcod-usuar AND
        bfmla-verba-aprov.cod-tip-doc = pcod-tip-doc AND
        bfmla-verba-aprov.periodo-ini = pperiodo-ini NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-verba-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-verba-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyData DBOProgram
PROCEDURE goToKeyData :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-usuar
               recebe valor do campo cod-tip-doc
               recebe valor do campo periodo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo   LIKE mla-verba-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-verba-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar   LIKE mla-verba-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-verba-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo     LIKE mla-verba-aprov.periodo-ini NO-UNDO.

    FIND FIRST bfmla-verba-aprov WHERE
        bfmla-verba-aprov.ep-codigo = pep-codigo AND
        bfmla-verba-aprov.cod-estabel = pcod-estabel AND
        bfmla-verba-aprov.cod-usuar = pcod-usuar AND
        bfmla-verba-aprov.cod-tip-doc = pcod-tip-doc AND
        bfmla-verba-aprov.periodo-ini <= pperiodo AND
        bfmla-verba-aprov.periodo-fim >= pperiodo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-verba-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-verba-aprov)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-verbas DBOProgram
PROCEDURE pi-copia-substituicao-verbas :
/*------------------------------------------------------------------------------
  Purpose:     Leitura e cria‡Æo das temp-tables de verbas do usu rio origem/destino e efetiva‡Æo das altera‡äes na base.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu rio destino
               pcOrigem          : Usu rio origem
               piOpcao           : Indica qual op‡Æo foi selecionada pelo usu rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se ‚ apenas um simula‡Æo(cria as temp-tables por‚m nÆo efetiva as altera‡äes na base).
               /* Output */
               tt-mla-verba-aprov-origem  : Cont‚m os dados dos registros(Verbas do usu rio) do usu rio origem
               tt-mla-verba-aprov-destino : Cont‚m os dados dos registros(Verbas do usu rio) do usu rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni       LIKE empresa.ep-codigo         NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim       LIKE empresa.ep-codigo         NO-UNDO.
    DEFINE INPUT PARAM pcEstabIni         LIKE estabelec.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAM pcEstabFim         LIKE estabelec.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAM pcOrigem           LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao            AS INTEGER                     NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracoes AS LOGICAL                     NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-verba-aprov-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-verba-aprov-destino.

    EMPTY TEMP-TABLE tt-mla-verba-aprov-origem.
    EMPTY TEMP-TABLE tt-mla-verba-aprov-destino.

    define variable c-mantido as char no-undo.
    define variable c-substituido as char no-undo.
    define variable c-eliminado as char no-undo.
    define variable c-origem as char no-undo.
    define variable c-novo as char no-undo.

    {utp/ut-liter.i "Mantido" * R}
    assign c-mantido = trim(return-value).

    {utp/ut-liter.i "Substitu¡do" * R}
    assign c-substituido = trim(return-value).

    {utp/ut-liter.i "Eliminado" * R}
    assign c-eliminado = trim(return-value).

    {utp/ut-liter.i "Origem" * R}
    assign c-origem = trim(return-value).

    {utp/ut-liter.i "Novo" * R}
    assign c-novo = trim(return-value).

    /* Verbas do usu rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcDestino:

        IF piOpcao = 1 THEN DO: /* Se for somente inexistentes cria tt com os dados atuais e situa‡Æo 'mantido' */
            CREATE tt-mla-verba-aprov-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
            ASSIGN tt-mla-verba-aprov-destino.situacao = c-mantido
                   tt-mla-verba-aprov-destino.id-sit   = 1
                   tt-mla-verba-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
        END.
        ELSE IF piOpcao = 2 THEN DO: /* Se for inexistentes e substituir existentes */
            FIND FIRST mla-verba-aprov NO-LOCK
                 WHERE mla-verba-aprov.ep-codigo   = bf{&TableName}.ep-codigo
                   AND mla-verba-aprov.cod-estabel = bf{&TableName}.cod-estabel
                   AND mla-verba-aprov.cod-usuar   = pcOrigem
                   AND mla-verba-aprov.cod-tip-doc = bf{&TableName}.cod-tip-doc
                   NO-ERROR.

            IF AVAIL mla-verba-aprov THEN DO:

                CREATE tt-mla-verba-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
                ASSIGN tt-mla-verba-aprov-destino.situacao    = c-substituido
                       tt-mla-verba-aprov-destino.id-sit      = 3
                       tt-mla-verba-aprov-destino.periodo-ini = mla-verba-aprov.periodo-ini
                       tt-mla-verba-aprov-destino.periodo-fim = mla-verba-aprov.periodo-fim
                       tt-mla-verba-aprov-destino.valor-verba = mla-verba-aprov.valor-verba
                       tt-mla-verba-aprov-destino.cod-usuar-lib = c-seg-usuario.
                       tt-mla-verba-aprov-destino.r-rowid     = ROWID(bf{&TableName}).
            END.
            ELSE DO:
                CREATE tt-mla-verba-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
                ASSIGN tt-mla-verba-aprov-destino.situacao = c-mantido
                       tt-mla-verba-aprov-destino.id-sit   = 1
                       tt-mla-verba-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-verba-aprov-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
            ASSIGN tt-mla-verba-aprov-destino.situacao = c-eliminado
                   tt-mla-verba-aprov-destino.id-sit   = 4
                   tt-mla-verba-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
        END.
    END.

    /* Verbas do usu rio origem e cria‡Æo das inexistentes do usu rio destino*/
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcOrigem:

        CREATE tt-mla-verba-aprov-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-origem.
        ASSIGN tt-mla-verba-aprov-origem.situacao  = c-origem
               tt-mla-verba-aprov-origem.id-sit    = 5
               tt-mla-verba-aprov-origem.r-rowid   = ROWID(bf{&TableName}).

        /* Cria‡Æo das lota‡äes do usu rio destino se a op‡Æo for 'Somente inexistentes(2)' ou 'Incluir inexistentes e substituir existentes(3)' */
        IF piOpcao = 1 OR piOpcao = 2 THEN DO:
            IF NOT CAN-FIND(mla-verba-aprov
                            WHERE mla-verba-aprov.ep-codigo   = bf{&TableName}.ep-codigo
                              AND mla-verba-aprov.cod-estabel = bf{&TableName}.cod-estabel
                              AND mla-verba-aprov.cod-usuar   = pcDestino
                              AND mla-verba-aprov.cod-tip-doc = bf{&TableName}.cod-tip-doc) THEN DO:

                CREATE tt-mla-verba-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
                ASSIGN tt-mla-verba-aprov-destino.situacao  = c-novo
                       tt-mla-verba-aprov-destino.id-sit    = 2
                       tt-mla-verba-aprov-destino.r-rowid   = ROWID(bf{&TableName})
                       tt-mla-verba-aprov-destino.cod-usuar-lib = c-seg-usuario
                       tt-mla-verba-aprov-destino.cod-usuar = pcDestino.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-verba-aprov-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-verba-aprov-destino.
            ASSIGN tt-mla-verba-aprov-destino.situacao  = c-novo
                   tt-mla-verba-aprov-destino.id-sit    = 2
                   tt-mla-verba-aprov-destino.cod-usuar-lib = c-seg-usuario
                   tt-mla-verba-aprov-destino.r-rowid   = ROWID(bf{&TableName})
                   tt-mla-verba-aprov-destino.cod-usuar = pcDestino.
        END.
    END.

    /*================================
    * Efetiva as altera‡äes na base
    ===================*/

    /* Label's */
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-doc        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liber      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-dat-liber  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liberado   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-period-ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-period-fim AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Usu rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Documento" * R}
    ASSIGN c-lbl-doc = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Libera‡Æo" * R}
    ASSIGN c-lbl-liber = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Data_Libera‡Æo" * R}
    ASSIGN c-lbl-dat-liber = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Liberado" * R}
    ASSIGN c-lbl-liberado = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Per¡odo_Inicial" * R}
    ASSIGN c-lbl-period-ini = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Per¡odo_Final" * R}
    ASSIGN c-lbl-period-fim = TRIM(RETURN-VALUE).

    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    IF NOT plSimulaAlteracoes THEN
        FOR EACH tt-mla-verba-aprov-destino:
            do transaction:
                IF tt-mla-verba-aprov-destino.id-sit = 4 OR tt-mla-verba-aprov-destino.id-sit = 3 THEN DO: /* ExclusÆo ou edi‡Æo */
                    find first mla-verba-aprov exclusive-lock where
                         rowid(mla-verba-aprov) = tt-mla-verba-aprov-destino.r-rowid no-error.
                    if not avail mla-verba-aprov then next.
                END.

                CASE tt-mla-verba-aprov-destino.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 26,
                                                    INPUT rowid(mla-verba-aprov),
                                                    INPUT 3,
                                                    INPUT ENTRY(26,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar      + "     : " + string(tt-mla-verba-aprov-destino.cod-usuar)     + chr(13) +
                                                        c-lbl-doc        + "     : " + string(tt-mla-verba-aprov-destino.cod-tip-doc)   + chr(13) +
                                                        c-lbl-liber      + "     : " + string(tt-mla-verba-aprov-destino.cod-usuar-lib) + chr(13) +
                                                        c-lbl-dat-liber  + "     : " + string(tt-mla-verba-aprov-destino.data-lib)      + chr(13) +
                                                        c-lbl-liberado   + "     : " + string(tt-mla-verba-aprov-destino.valor-verba, "->,>>>,>>>,>>>,>>9.99")   + chr(13) +
                                                        c-lbl-period-ini + "     : " + string(tt-mla-verba-aprov-destino.periodo-ini)   + chr(13) +
                                                        c-lbl-period-fim + "     : " + string(tt-mla-verba-aprov-destino.periodo-fim)).
                        delete mla-verba-aprov.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-verba-aprov.
                        BUFFER-COPY tt-mla-verba-aprov-destino EXCEPT tt-mla-verba-aprov-destino.situacao
                                                                      tt-mla-verba-aprov-destino.r-rowid TO mla-verba-aprov.
                        RUN pi-gera-log IN h-boin769(INPUT 26,
                                                    INPUT rowid(mla-verba-aprov),
                                                    INPUT 1,
                                                    INPUT ENTRY(26,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar      + "          : " + string(tt-mla-verba-aprov-destino.cod-usuar)     + chr(13) +
                                                        c-lbl-doc        + "          : " + string(tt-mla-verba-aprov-destino.cod-tip-doc)   + chr(13) +
                                                        c-lbl-liber      + "          : " + string(tt-mla-verba-aprov-destino.cod-usuar-lib) + chr(13) +
                                                        c-lbl-dat-liber  + "          : " + string(tt-mla-verba-aprov-destino.data-lib)      + chr(13) +
                                                        c-lbl-liberado   + "          : " + string(tt-mla-verba-aprov-destino.valor-verba, "->,>>>,>>>,>>>,>>9.99")   + chr(13) +
                                                        c-lbl-period-ini + "          : " + string(tt-mla-verba-aprov-destino.periodo-ini)   + chr(13) +
                                                        c-lbl-period-fim + "          : " + string(tt-mla-verba-aprov-destino.periodo-fim)).
                        release mla-verba-aprov.
                    END.
                    WHEN 3 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 26,
                                                    INPUT rowid(mla-verba-aprov),
                                                    INPUT 2,
                                                    INPUT ENTRY(26,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                            c-lbl-liber + "         : " + string(mla-verba-aprov.cod-usuar-lib) + chr(13) +
                                                            "                         " + string(tt-mla-verba-aprov-destino.cod-usuar-lib) + chr(13) +
                                                            c-lbl-dat-liber + "     : " + string(mla-verba-aprov.data-lib)      + chr(13) +
                                                            "                         " + string(tt-mla-verba-aprov-destino.data-lib)   + chr(13) +
                                                            c-lbl-liberado + "      : " + string(mla-verba-aprov.valor-verba)   + chr(13) +
                                                            "                         " + string(tt-mla-verba-aprov-destino.valor-verba, "->,>>>,>>>,>>>,>>9.99")    + chr(13) +
                                                            c-lbl-period-ini + "    : " + string(mla-verba-aprov.periodo-ini)   + chr(13) +
                                                            "                         " + string(tt-mla-verba-aprov-destino.periodo-ini)  + chr(13) +
                                                            c-lbl-period-fim + "    : " + string(mla-verba-aprov.periodo-fim)   + chr(13) +
                                                            "                         " + string(tt-mla-verba-aprov-destino.periodo-fim)).

                        ASSIGN mla-verba-aprov.valor-verba = tt-mla-verba-aprov-destino.valor-verba
                               mla-verba-aprov.periodo-ini = tt-mla-verba-aprov-destino.periodo-ini
                               mla-verba-aprov.periodo-fim = tt-mla-verba-aprov-destino.periodo-fim.
                        release mla-verba-aprov.
                    END.
                END CASE.
            END.
        end.
    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDebitaVerba DBOProgram
PROCEDURE setDebitaVerba :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-verba AS DECIMAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN RowObject.verba-utilizada = RowObject.verba-utilizada - p-verba.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-verba-aprov
                     WHERE mla-verba-aprov.ep-codigo = RowObject.ep-codigo
                       AND mla-verba-aprov.cod-estabel = RowObject.cod-estabel
                       AND mla-verba-aprov.cod-usuar = RowObject.cod-usuar
                       AND mla-verba-aprov.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-verba-aprov.periodo-ini = RowObject.periodo-ini) THEN DO:
            {utp/ut-liter.i "verbas_liberadas"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.


        /* Existˆncia da empresa */
        IF NOT CAN-FIND (FIRST empresa
                         WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existˆncia do estabelecimenti */
        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existˆncia do documento */
        IF NOT CAN-FIND (FIRST mla-tipo-doc-aprov
                         WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                           AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existˆncia do usu rio */
        IF NOT CAN-FIND (FIRST mla-usuar-aprov
                         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu rio"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valor liberado */
        IF RowObject.valor-verba < 0 OR RowObject.valor-verba > 999999999.99 THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="16198"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Per¡dos */
        IF RowObject.periodo-ini > RowObject.periodo-fim THEN DO:
            {utp/ut-liter.i "Data_inicial"}
            ASSIGN c-lbl-periodo-ini = RETURN-VALUE.
            {utp/ut-liter.i "Data_final"}
            ASSIGN c-lbl-periodo-fim = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1207"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-periodo-ini + '~~~~' + c-lbl-periodo-fim"}
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

