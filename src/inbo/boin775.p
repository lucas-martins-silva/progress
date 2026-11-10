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
{include/i-prgvrs.i BOIN775 2.00.00.011 } /*** "010011" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin775 MUT}
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
&GLOBAL-DEFINE DBOName boin775
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-perm-lotacao
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
{inbo/boin775.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/* Temp-table utilizada na pi-copia-substituicao-lotacoes */
{inbo/boin775.i1} /* Definiá∆o das temp-tables utilizadas pela pi-copia-substituicao-lotacoes. */

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
         HEIGHT             = 2.13
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
               retorna valor do campo cod-usuar
               retorna valor do campo cod-lotacao
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-perm-lotacao.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-perm-lotacao.cod-usuar NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-lotacao LIKE mla-perm-lotacao.cod-lotacao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-usuar = RowObject.cod-usuar
           pcod-lotacao = RowObject.cod-lotacao.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPermLotacao DBOProgram
PROCEDURE getPermLotacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    IF  RowObject.validade-ini >= TODAY AND
        RowObject.validade-fim <= TODAY THEN
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
               recebe valor do campo cod-usuar
               recebe valor do campo cod-lotacao
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-perm-lotacao.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-perm-lotacao.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-perm-lotacao.cod-lotacao NO-UNDO.

    FIND FIRST bfmla-perm-lotacao WHERE
        bfmla-perm-lotacao.ep-codigo = pep-codigo AND
        bfmla-perm-lotacao.cod-usuar = pcod-usuar AND
        bfmla-perm-lotacao.cod-lotacao = pcod-lotacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-perm-lotacao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-perm-lotacao)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-lotacoes DBOProgram
PROCEDURE pi-copia-substituicao-lotacoes :
/*------------------------------------------------------------------------------
  Purpose:     Leitura e criaá∆o das temp-tables de lotaá‰es do usu†rio origem/destino e efetivaá∆o das alteraá‰es na base.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcCodUsuarDestino : Usu†rio destino
               pcCodUsuarOrigem  : Usu†rio origem
               piOpcao           : Indica qual opá∆o foi selecionada pelo usu†rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-perm-lotacao-origem  : ContÇm os dados dos registros(Lotaá‰es do usu†rio) do usu†rio origem
               tt-mla-perm-lotacao-destino : ContÇm os dados dos registros(Lotaá‰es do usu†rio) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcCodUsuarOrigem  LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcCodUsuarDestino LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao           AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM plSimulacao       AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-perm-lotacao-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-perm-lotacao-destino.

    EMPTY TEMP-TABLE tt-mla-perm-lotacao-origem.
    EMPTY TEMP-TABLE tt-mla-perm-lotacao-destino.

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

    /* Lotaá‰es do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-usuar    = pcCodUsuarDestino:

        IF piOpcao = 1 THEN DO: /* Cria tt com as permiss‰es e situaá∆o mantido (Permiss‰es antigas do usu†rio) */
            CREATE tt-mla-perm-lotacao-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
            ASSIGN tt-mla-perm-lotacao-destino.situacao = c-mantido
                   tt-mla-perm-lotacao-destino.id-sit   = 1
                   tt-mla-perm-lotacao-destino.r-rowid  = ROWID(bf{&TableName}).
        END.
        ELSE IF piOpcao = 2 THEN DO: /* Caso par∆metro for para substituir existentes e incluir inexistentes */
            FIND FIRST mla-perm-lotacao NO-LOCK      /* Procura usu†rio origem com o documento da leitura atual */
                 WHERE mla-perm-lotacao.ep-codigo   = bf{&TableName}.ep-codigo
                   AND mla-perm-lotacao.cod-usuar   = pcCodUsuarOrigem
                   AND mla-perm-lotacao.cod-lotacao = bf{&TableName}.cod-lotacao
                   NO-ERROR.

            IF AVAIL mla-perm-lotacao THEN DO: /* Se existir usu†rio origem do documento, cria tt com os dados do usu†rio destino e atualiza as datas de validade */
                CREATE tt-mla-perm-lotacao-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
                ASSIGN tt-mla-perm-lotacao-destino.situacao     = c-substituido
                       tt-mla-perm-lotacao-destino.id-sit       = 3
                       tt-mla-perm-lotacao-destino.validade-ini = mla-perm-lotacao.validade-ini
                       tt-mla-perm-lotacao-destino.validade-fim = mla-perm-lotacao.validade-fim
                       tt-mla-perm-lotacao-destino.r-rowid      = ROWID(bf{&TableName}).
            END.
            ELSE DO: /* Se n∆o existir usu†rio origem, cria a tt baseada no usu†rio/empresa/estabelec da leitura atual */
                CREATE tt-mla-perm-lotacao-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
                ASSIGN tt-mla-perm-lotacao-destino.situacao = c-mantido
                       tt-mla-perm-lotacao-destino.id-sit   = 1
                       tt-mla-perm-lotacao-destino.r-rowid  = ROWID(bf{&TableName}).
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO: /* Se for substituir tudo, cria a tt de acordo com a leitura atual e com situaá∆o 'eliminado' (permiss‰es antigas)*/
            CREATE tt-mla-perm-lotacao-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
            ASSIGN tt-mla-perm-lotacao-destino.situacao = c-eliminado
                   tt-mla-perm-lotacao-destino.id-sit   = 4
                   tt-mla-perm-lotacao-destino.r-rowid  = ROWID(bf{&TableName}).
        END.
    END.

    /* Lotaá‰es do usu†rio origem e criaá∆o das inexistentes do usu†rio destino*/
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-usuar    = pcCodUsuarOrigem:

        /************ Criaá∆o dos registros do usu†rio origem *************/
        CREATE tt-mla-perm-lotacao-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-origem.
        ASSIGN tt-mla-perm-lotacao-origem.situacao  = c-origem
               tt-mla-perm-lotacao-origem.id-sit    = 5
               tt-mla-perm-lotacao-origem.r-rowid   = ROWID(bf{&TableName}).
        /******************************************************************/

        /* Criaá∆o das lotaá‰es do usu†rio destino se a opá∆o for 'Somente inexistentes(2)' ou 'Incluir inexistentes e substituir existentes(3)' */
        IF piOpcao = 1 OR piOpcao = 2 THEN DO:
            IF NOT CAN-FIND(FIRST mla-perm-lotacao
                            WHERE mla-perm-lotacao.ep-codigo   = bf{&TableName}.ep-codigo
                              AND mla-perm-lotacao.cod-lotacao = bf{&TableName}.cod-lotacao
                              AND mla-perm-lotacao.cod-usuar   = pcCodUsuarDestino) THEN DO:

                CREATE tt-mla-perm-lotacao-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
                ASSIGN tt-mla-perm-lotacao-destino.situacao  = c-novo
                       tt-mla-perm-lotacao-destino.id-sit    = 2
                       tt-mla-perm-lotacao-destino.r-rowid   = ROWID(bf{&TableName})
                       tt-mla-perm-lotacao-destino.cod-usuar = pcCodUsuarDestino.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-perm-lotacao-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-perm-lotacao-destino.
            ASSIGN tt-mla-perm-lotacao-destino.situacao  = c-novo
                   tt-mla-perm-lotacao-destino.id-sit    = 2
                   tt-mla-perm-lotacao-destino.r-rowid   = ROWID(bf{&TableName})
                   tt-mla-perm-lotacao-destino.cod-usuar = pcCodUsuarDestino.
        END.
    END.

    /* Label's */
    DEFINE VARIABLE c-lbl-lotacao    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-ini  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-fim  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Lotaá∆o" * R}
    ASSIGN c-lbl-lotacao = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Inicial" * R}
    ASSIGN c-lbl-valid-ini = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Final" * R}
    ASSIGN c-lbl-valid-fim = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).


    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    IF NOT plSimulacao THEN
        FOR EACH tt-mla-perm-lotacao-destino:
            do transaction:
                IF tt-mla-perm-lotacao-destino.id-sit = 4 OR tt-mla-perm-lotacao-destino.id-sit = 3 THEN DO: /* Exclus∆o ou ediá∆o */
                    FIND FIRST mla-perm-lotacao EXCLUSIVE-LOCK WHERE
                         ROWID(mla-perm-lotacao) = tt-mla-perm-lotacao-destino.r-rowid NO-ERROR.
                    if not avail mla-perm-lotacao then next.
                END.
                CASE tt-mla-perm-lotacao-destino.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 14,
                                                    INPUT rowid(mla-perm-lotacao),
                                                    INPUT 3,
                                                    INPUT ENTRY(14,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                        c-lbl-usuar     + "   : " + STRING(tt-mla-perm-lotacao-destino.cod-usuar)     + CHR(13) +
                                                        c-lbl-lotacao   + "   : " + STRING(tt-mla-perm-lotacao-destino.cod-lotacao)   + CHR(13) +
                                                        c-lbl-valid-ini + "   : " + STRING(tt-mla-perm-lotacao-destino.validade-ini)  + CHR(13) +
                                                        c-lbl-valid-fim + "   : " + STRING(tt-mla-perm-lotacao-destino.validade-fim)).
                        delete mla-perm-lotacao.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-perm-lotacao.
                        BUFFER-COPY tt-mla-perm-lotacao-destino EXCEPT tt-mla-perm-lotacao-destino.situacao
                                                                       tt-mla-perm-lotacao-destino.r-rowid TO mla-perm-lotacao.
                        RUN pi-gera-log IN h-boin769(INPUT 14,
                                                    INPUT rowid(mla-perm-lotacao),
                                                    INPUT 1,
                                                    INPUT ENTRY(14,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                        c-lbl-usuar     + "     : " + STRING(tt-mla-perm-lotacao-destino.cod-usuar)    + CHR(13) +
                                                        c-lbl-lotacao   + "     : " + STRING(tt-mla-perm-lotacao-destino.cod-lotacao)  + CHR(13) +
                                                        c-lbl-valid-ini + "     : " + STRING(tt-mla-perm-lotacao-destino.validade-ini) + CHR(13) +
                                                        c-lbl-valid-fim + "     : " + STRING(tt-mla-perm-lotacao-destino.validade-fim)).
                        release mla-perm-lotacao.
                    END.
                    WHEN 3 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 14,
                                                    INPUT rowid(mla-perm-lotacao),
                                                    INPUT 2,
                                                    INPUT ENTRY(14,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                                                            c-lbl-valid-ini + "   : " + STRING(mla-perm-lotacao.validade-ini)      + CHR(13) +
                                                            "                       " + STRING(tt-mla-perm-lotacao-destino.validade-ini) + CHR(13) +
                                                            c-lbl-valid-fim + "   : " + STRING(mla-perm-lotacao.validade-fim)             + CHR(13) +
                                                            "                       " + STRING(tt-mla-perm-lotacao-destino.validade-fim)).
                        ASSIGN mla-perm-lotacao.validade-ini = tt-mla-perm-lotacao-destino.validade-ini
                               mla-perm-lotacao.validade-fim = tt-mla-perm-lotacao-destino.validade-fim.
                        release mla-perm-lotacao.
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
        AND CAN-FIND(FIRST mla-perm-lotacao
                     WHERE mla-perm-lotacao.ep-codigo = RowObject.ep-codigo
                       AND mla-perm-lotacao.cod-usuar = RowObject.cod-usuar
                       AND mla-perm-lotacao.cod-lotacao = RowObject.cod-lotacao) THEN DO:
            {utp/ut-liter.i "permiss‰es_do_aprovador_em_outra_lotaá∆o"}
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

        /* Existància do usu†rio */
        IF NOT CAN-FIND (FIRST mla-usuar-aprov
                         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu†rio"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Validaá∆o de lotaá‰es */
        IF NOT CAN-FIND(FIRST mla-lotacao
                        WHERE mla-lotacao.ep-codigo   = rowObject.ep-codigo
                          AND mla-lotacao.cod-lotacao = rowObject.cod-lotacao) THEN DO:
            {utp/ut-table.i mgind mla-lotacao 1}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Validaá∆o de datas */
        IF rowObject.validade-ini > rowObject.validade-fim THEN DO:
            /* in°cio projeto internacional */
            DEFINE VARIABLE c-validade-ini AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i Validade_inicial * r}
            assign c-validade-ini = return-value.
            DEFINE VARIABLE c-validade-fim AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i Validade_final * r}
            assign c-validade-fim = return-value.
            {method/svc/errors/inserr.i
                    &ErrorNumber="1207"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-validade-fim + '~~~~' + c-validade-ini"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

