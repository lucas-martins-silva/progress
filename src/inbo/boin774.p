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
{include/i-prgvrs.i BOIN774 2.00.00.021 } /*** "010021" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin774 MUT}
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
&GLOBAL-DEFINE DBOName boin774
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-perm-aprov
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
{inbo/boin774.i RowObject}



{lap/mla0101.i} /*Def.temp table tt-parementros*/
def temp-table ttUserDocumentList NO-UNDO
    field cod-tip-doc as int
    field desc-tip-doc as char format "x(30)"
    field nr-doc-pend-aprov as int
    INDEX pri cod-tip-doc.

DEFINE VARIABLE h_boin767      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-lbl-data-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-data-fim AS CHARACTER   NO-UNDO.

def new global shared var i-ep-codigo-usuario   As Character    no-undo.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Temp-table utilizada na pi-copia-substituicao-permissoes */
{inbo/boin774.i1} /* Definiá∆o das temp-tables utilizadas na pi-copia-substitui-aprovador */

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
         HEIGHT             = 2.17
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
        WHEN "validade-fim":U THEN ASSIGN pFieldValue = RowObject.validade-fim.
        WHEN "validade-ini":U THEN ASSIGN pFieldValue = RowObject.validade-ini.
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
        WHEN "limite-aprov":U THEN ASSIGN pFieldValue = RowObject.limite-aprov.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-usuar
               retorna valor do campo cod-tip-doc
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-perm-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-perm-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-perm-aprov.cod-usuar NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-perm-aprov.cod-tip-doc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-usuar = RowObject.cod-usuar
           pcod-tip-doc = RowObject.cod-tip-doc.

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
        WHEN "aprova-auto-aprov":U THEN ASSIGN pFieldValue = RowObject.aprova-auto-aprov.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPermAprovacao DBOProgram
PROCEDURE getPermAprovacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-valor-doc AS DECIMAL NO-UNDO.

    IF  NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

   IF  RowObject.validade-ini <= TODAY AND
       RowObject.validade-fim >= TODAY AND
       RowObject.limite-aprov >= p-valor-doc THEN
        RETURN "OK":U.

    RETURN "NOK":U.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-usuar
               recebe valor do campo cod-tip-doc
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo   LIKE mla-perm-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-perm-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar   LIKE mla-perm-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-perm-aprov.cod-tip-doc NO-UNDO.

    FIND FIRST bfmla-perm-aprov WHERE
        bfmla-perm-aprov.ep-codigo   = pep-codigo AND
        bfmla-perm-aprov.cod-estabel = pcod-estabel AND
        bfmla-perm-aprov.cod-usuar   = pcod-usuar AND
        bfmla-perm-aprov.cod-tip-doc = pcod-tip-doc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-perm-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-perm-aprov)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-permissoes DBOProgram
PROCEDURE pi-copia-substituicao-permissoes :
/*------------------------------------------------------------------------------
  Purpose:     Leitura e criaá∆o das temp-tables de permiss‰es do usu†rio origem/destino e efetivaá∆o das alteraá‰es na base.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu†rio destino
               pcOrigem          : Usu†rio origem
               piOpcao           : Indica qual opá∆o foi selecionada pelo usu†rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-perm-aprov-origem  : ContÇm os dados dos registros(Permiss‰es do usu†rio) do usu†rio origem
               tt-mla-perm-aprov-destino : ContÇm os dados dos registros(Permiss‰es do usu†rio) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo         NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo         NO-UNDO.
    DEFINE INPUT PARAM pcEstabIni        LIKE estabelec.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAM pcEstabFim        LIKE estabelec.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piopcao           AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-perm-aprov-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-perm-aprov-destino.

    EMPTY TEMP-TABLE tt-mla-perm-aprov-origem.
    EMPTY TEMP-TABLE tt-mla-perm-aprov-destino.

    define variable c-mantido as char no-undo.
    define variable c-substituido as char no-undo.
    define variable c-eliminado as char no-undo.
    define variable c-origem as char no-undo.
    define variable c-novo as char no-undo.

    {utp/ut-liter.i "Mantido" * R}
    assign c-mantido = trim(return-value).

    {utp/ut-liter.i "Substitu°do" * R}
    assign c-substituido = trim(return-value).

    {utp/ut-liter.i "Eliminado" * R}
    assign c-eliminado = trim(return-value).

    {utp/ut-liter.i "Origem" * R}
    assign c-origem = trim(return-value).

    {utp/ut-liter.i "Novo" * R}
    assign c-novo = trim(return-value).

    /* Permiss‰es do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcDestino:

        case piopcao:
            when 1 THEN DO: /* Se for somente inexistentes cria tt com os dados atuais e situaá∆o 'mantido' */
                CREATE tt-mla-perm-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-aprov-destino.
                ASSIGN tt-mla-perm-aprov-destino.situacao = c-mantido
                    tt-mla-perm-aprov-destino.id-sit   = 1
                    tt-mla-perm-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
            END.
            when 2 THEN DO: /* Se a opá∆o for 'Incluir inexistentes e substituir existentes */
                FIND FIRST mla-perm-aprov NO-LOCK
                    WHERE mla-perm-aprov.ep-codigo   = bf{&TableName}.ep-codigo
                    AND mla-perm-aprov.cod-estabel = bf{&TableName}.cod-estabel
                    AND mla-perm-aprov.cod-usuar   = pcOrigem
                    AND mla-perm-aprov.cod-tip-doc = bf{&TableName}.cod-tip-doc NO-ERROR.
                CREATE tt-mla-perm-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-aprov-destino.
                IF AVAIL mla-perm-aprov THEN DO:
                    ASSIGN tt-mla-perm-aprov-destino.situacao     = c-substituido
                           tt-mla-perm-aprov-destino.id-sit       = 3
                           tt-mla-perm-aprov-destino.validade-ini = mla-perm-aprov.validade-ini
                           tt-mla-perm-aprov-destino.validade-fim = mla-perm-aprov.validade-fim
                           tt-mla-perm-aprov-destino.limite-aprov = mla-perm-aprov.limite-aprov
                           tt-mla-perm-aprov-destino.r-rowid      = ROWID(bf{&TableName}).
                END.
                ELSE DO:
                    ASSIGN tt-mla-perm-aprov-destino.situacao = c-mantido
                           tt-mla-perm-aprov-destino.id-sit   = 1
                           tt-mla-perm-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
                END.
            END.
            WHEN 3 THEN DO:
                CREATE tt-mla-perm-aprov-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-aprov-destino.
                ASSIGN tt-mla-perm-aprov-destino.situacao = c-eliminado
                       tt-mla-perm-aprov-destino.id-sit   = 4
                       tt-mla-perm-aprov-destino.r-rowid  = ROWID(bf{&TableName}).
            END.
        END.
    END.

    /* Permiss‰es do usu†rio origem e criaá∆o das inexistentes do usu†rio destino*/
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcOrigem:

        CREATE tt-mla-perm-aprov-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-perm-aprov-origem.
        ASSIGN tt-mla-perm-aprov-origem.situacao  = c-origem
               tt-mla-perm-aprov-origem.id-sit    = 5
               tt-mla-perm-aprov-origem.r-rowid   = ROWID(bf{&TableName}).

        IF NOT CAN-FIND(tt-mla-perm-aprov-destino
                  WHERE tt-mla-perm-aprov-destino.ep-codigo   = bf{&TableName}.ep-codigo
                    AND tt-mla-perm-aprov-destino.cod-estabel = bf{&TableName}.cod-estabel
                    AND tt-mla-perm-aprov-destino.cod-usuar   = pcDestino
                    AND tt-mla-perm-aprov-destino.cod-tip-doc = bf{&TableName}.cod-tip-doc) THEN DO:

            CREATE tt-mla-perm-aprov-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-perm-aprov-destino.
            ASSIGN tt-mla-perm-aprov-destino.situacao  = c-novo
                   tt-mla-perm-aprov-destino.id-sit    = 2
                   tt-mla-perm-aprov-destino.r-rowid   = ROWID(bf{&TableName})
                   tt-mla-perm-aprov-destino.cod-usuar = pcDestino.
        END.
    END.

    /* Label's */
    DEFINE VARIABLE c-lbl-limit      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-doc        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-ini  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-fim  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-log-header     as character   no-undo.

    {utp/ut-liter.i "Limite" * R}
    ASSIGN c-lbl-limit = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Documento" * R}
    ASSIGN c-lbl-doc = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Inicial" * R}
    ASSIGN c-lbl-valid-ini = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Final" * R}
    ASSIGN c-lbl-valid-fim = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    /* Prepara a constante do cabeáalho do log fora dos laáos */
    assign c-log-header = ENTRY(13, {ininc/i03in030.i 03}) + CHR(13) + CHR(13).

    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    IF NOT plSimulaAlteracao THEN
        FOR EACH tt-mla-perm-aprov-destino:
            do transaction:
                /*--- Reposiciona rowid do registro corrente ---*/
                IF tt-mla-perm-aprov-destino.id-sit = 4 OR tt-mla-perm-aprov-destino.id-sit = 3 THEN DO: /* Exclus∆o ou ediá∆o */
                    FIND FIRST mla-perm-aprov EXCLUSIVE-LOCK WHERE
                         ROWID(mla-perm-aprov) = tt-mla-perm-aprov-destino.r-rowid NO-ERROR.
                    if not avail mla-perm-aprov then next.
                END.

                CASE tt-mla-perm-aprov-destino.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 13,
                                                     INPUT rowid(mla-perm-aprov),
                                                     INPUT 3,
                                                     INPUT c-log-header +
                                                        c-lbl-usuar     + "     : " + STRING(tt-mla-perm-aprov-destino.cod-usuar)    + CHR(13) +
                                                        c-lbl-doc       + "     : " + STRING(tt-mla-perm-aprov-destino.cod-tip-doc)  + CHR(13) +
                                                        c-lbl-limit     + "     : " + STRING(tt-mla-perm-aprov-destino.limite-aprov) + CHR(13) +
                                                        c-lbl-valid-ini + "     : " + STRING(tt-mla-perm-aprov-destino.validade-ini) + CHR(13) +
                                                        c-lbl-valid-fim + "     : " + STRING(tt-mla-perm-aprov-destino.validade-fim)).
                        delete mla-perm-aprov.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-perm-aprov.
                        BUFFER-COPY tt-mla-perm-aprov-destino EXCEPT tt-mla-perm-aprov-destino.situacao
                                                                     tt-mla-perm-aprov-destino.r-rowid TO mla-perm-aprov.
                        RUN pi-gera-log IN h-boin769(INPUT 13,
                                                    INPUT rowid(mla-perm-aprov),
                                                    INPUT 1,
                                                    INPUT c-log-header +
                                                        c-lbl-usuar     + "          : " + STRING(tt-mla-perm-aprov-destino.cod-usuar)    + CHR(13) +
                                                        c-lbl-doc       + "          : " + STRING(tt-mla-perm-aprov-destino.cod-tip-doc)  + CHR(13) +
                                                        c-lbl-limit     + "          : " + STRING(tt-mla-perm-aprov-destino.limite-aprov) + CHR(13) +
                                                        c-lbl-valid-ini + "          : " + STRING(tt-mla-perm-aprov-destino.validade-ini) + CHR(13) +
                                                        c-lbl-valid-fim + "          : " + STRING(tt-mla-perm-aprov-destino.validade-fim)).
                        release mla-perm-aprov.
                    END.
                    WHEN 3 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 13,
                                                    INPUT rowid(mla-perm-aprov),
                                                    INPUT 2,
                                                    INPUT c-log-header +
                                                            c-lbl-limit + "       : " + STRING(mla-perm-aprov.limite-aprov) + CHR(13) +
                                                            "                       " + STRING(tt-mla-perm-aprov-destino.limite-aprov) + CHR(13) +
                                                            c-lbl-valid-ini + "   : " + STRING(mla-perm-aprov.validade-ini) + CHR(13) +
                                                            "                       " + STRING(tt-mla-perm-aprov-destino.validade-ini) + CHR(13) +
                                                            c-lbl-valid-fim + "   : " + STRING(mla-perm-aprov.validade-fim) + CHR(13) +
                                                            "                       " + STRING(tt-mla-perm-aprov-destino.validade-fim)).
                        ASSIGN mla-perm-aprov.limite-aprov = tt-mla-perm-aprov-destino.limite-aprov
                               mla-perm-aprov.validade-ini = tt-mla-perm-aprov-destino.validade-ini
                               mla-perm-aprov.validade-fim = tt-mla-perm-aprov-destino.validade-fim.
                        release mla-perm-aprov.
                    END.
                END CASE.
            end.
        END.

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UserDocumentList DBOProgram
PROCEDURE UserDocumentList :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    define input  parameter cCodUsuar   as character  no-undo.
    define input  parameter tipoEntrSai as character  no-undo.
    define output param  table for ttUserDocumentList.

    define variable iNrPendencias as integer     no-undo.
    define variable i-situacao    as integer     no-undo.

    if not valid-handle(h_boin767) then
        run inbo/boin767.p persistent set h_boin767.

    EMPTY TEMP-TABLE ttUserDocumentList.
    for each mla-perm-aprov
            where mla-perm-aprov.ep-codigo  = i-ep-codigo-usuario
        AND  mla-perm-aprov.cod-usuar   = cCodUsuar NO-LOCK :

        assign iNrPendencias = 0.

      find first mla-tipo-doc-aprov
             where mla-tipo-doc-aprov.ep-codigo   = mla-perm-aprov.ep-codigo
             and   mla-tipo-doc-aprov.cod-estabel = mla-perm-aprov.cod-estabel
             and   mla-tipo-doc-aprov.cod-tip-doc = mla-perm-aprov.cod-tip-doc
             and   mla-tipo-doc-aprov.apr-tip-doc = yes no-lock no-error.
        if avail mla-tipo-doc-aprov then do:
            FIND FIRST ttUserDocumentList
                WHERE ttUserDocumentlist.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc NO-ERROR.
            IF NOT AVAIL ttUserDocumentList THEN DO:
                CREATE ttUserDocumentList.
                ASSIGN ttUserDocumentList.cod-tip-doc       = mla-perm-aprov.cod-tip-doc
                       ttUserDocumentList.desc-tip-doc      = mla-tipo-doc-aprov.des-tip-doc.
            END.

            /* Caixa de entrada e alternativo */
            if tipoEntrSai = "yes" or tipoEntrSai = "alt" then do:
                IF tipoEntrSai = "yes" THEN
                    RUN getTotalPendenciasAprovAprov IN h_boin767 (INPUT  mla-perm-aprov.cod-tip-doc,
                                                                   INPUT  cCodUsuar                 ,
                                                                   INPUT  mla-perm-aprov.ep-codigo  ,
                                                                   INPUT  mla-perm-aprov.cod-estabel,
                                                                   INPUT  NO,     /*so-alternativos*/
                                                                   INPUT  yes,    /*pendentes*/
                                                                   OUTPUT iNrPendencias).
                IF tipoEntrSai = "alt" THEN
                    RUN getTotalPendenciasAprovAprov IN h_boin767 (INPUT  mla-perm-aprov.cod-tip-doc,
                                                                   INPUT  cCodUsuar                 ,
                                                                   INPUT  mla-perm-aprov.ep-codigo  ,
                                                                   INPUT  mla-perm-aprov.cod-estabel,
                                                                   INPUT  YES,    /*so-alternativos*/
                                                                   INPUT  YES,    /*pendentes*/
                                                                   OUTPUT iNrPendencias).
                ASSIGN ttUserDocumentList.nr-doc-pend-aprov = ttUserDocumentList.nr-doc-pend-aprov + iNrPendencias.
            end.
            else do:  /*Caixa de sa°da*/
                RUN getTotalPendenciasAprovAprov IN h_boin767 (INPUT  mla-perm-aprov.cod-tip-doc,
                                                               INPUT  cCodUsuar                 ,
                                                               INPUT  mla-perm-aprov.ep-codigo  ,
                                                               INPUT  mla-perm-aprov.cod-estabel,
                                                               INPUT  YES,    /*so-alternativos*/
                                                               INPUT  NO,    /*pendentes*/
                                                               OUTPUT iNrPendencias).
            end.

        END.

    END.
    if valid-handle(h_boin767) THEN
      DELETE PROCEDURE h_boin767.
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
        AND CAN-FIND(FIRST mla-perm-aprov
                     WHERE mla-perm-aprov.ep-codigo = RowObject.ep-codigo
                       AND mla-perm-aprov.cod-estabel = RowObject.cod-estabel
                       AND mla-perm-aprov.cod-usuar = RowObject.cod-usuar
                       AND mla-perm-aprov.cod-tip-doc =  RowObject.cod-tip-doc) THEN DO:
            {utp/ut-liter.i "permiss‰es_de_aprovaá∆o"}
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

        /* Existància do documento */
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                          AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do usu†rio */
        IF NOT CAN-FIND(FIRST mla-usuar-aprov
                        WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu†rio"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Limite de aprovaá∆o */
        IF RowObject.limite-aprov < 0 OR RowObject.limite-aprov > 9999999999999.99 THEN DO:
            {utp/ut-liter.i Valor_de_Limite_de_Aprovaá∆o * }
            {method/svc/errors/inserr.i
                    &ErrorNumber="158"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.

        /* Validade */
        IF RowObject.validade-ini > RowObject.validade-fim THEN DO:
            {utp/ut-liter.i "data_inicial"}
            ASSIGN c-lbl-data-ini = RETURN-VALUE.
            {utp/ut-liter.i "Data_final"}
            ASSIGN c-lbl-data-fim = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1207"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-data-fim + '~~~~' + c-lbl-data-ini"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

