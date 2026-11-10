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
{include/i-prgvrs.i BOIN794 2.00.00.016 } /*** "010016" 04/09/2026 21:53:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin794 MUT}
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
&GLOBAL-DEFINE DBOName boin794
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-lim-aprov-fam
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
{inbo/boin794.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Temp-table utilizada na pi-copia-substuicao-permissoes */
{inbo/boin794.i1} /* Definiá∆o das temp-tables utilizadas na pi-copia-substituicao-limites */

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
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
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
  Purpose:     Retorna valores dos campos do °ndice familia
  Parameters:
               retorna valor do campo ep-codigo
               retorna valor do campo fm-codigo
               retorna valor do campo cod-tip-doc
               retorna valor do campo cod-usuar
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-lim-aprov-fam.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE mla-lim-aprov-fam.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-lim-aprov-fam.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-lim-aprov-fam.cod-usuar NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pfm-codigo = RowObject.fm-codigo
           pcod-tip-doc = RowObject.cod-tip-doc
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
  Purpose:     Reposiciona registro com base no °ndice familia
  Parameters:
               recebe valor do campo ep-codigo
               recebe valor do campo fm-codigo
               recebe valor do campo cod-tip-doc
               recebe valor do campo cod-usuar
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-lim-aprov-fam.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo LIKE mla-lim-aprov-fam.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-lim-aprov-fam.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-lim-aprov-fam.cod-usuar NO-UNDO.

    FIND FIRST bfmla-lim-aprov-fam WHERE
        bfmla-lim-aprov-fam.ep-codigo = pep-codigo AND
        bfmla-lim-aprov-fam.fm-codigo = pfm-codigo AND
        bfmla-lim-aprov-fam.cod-tip-doc = pcod-tip-doc AND
        bfmla-lim-aprov-fam.cod-usuar = pcod-usuar NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-lim-aprov-fam THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-lim-aprov-fam)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-limites DBOProgram
PROCEDURE pi-copia-substituicao-limites :
/*------------------------------------------------------------------------------
  Purpose:     Leitura e criaá∆o das temp-tables de limites de aprovaá∆o do usu†rio origem/destino e efetivaá∆o das alteraá‰es na base.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcDestino         : Usu†rio destino
               pcOrigem          : Usu†rio origem
               piOpcao           : Indica qual opá∆o foi selecionada pelo usu†rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-lim-aprov-fam-origem  : ContÇm os dados dos registros(Limites de aprovaá∆o do usu†rio) do usu†rio origem
               tt-mla-lim-aprov-fam-destino : ContÇm os dados dos registros(Limites de aprovaá∆o) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao           AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-lim-aprov-fam-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-lim-aprov-fam-destino.

    EMPTY TEMP-TABLE tt-mla-lim-aprov-fam-origem.
    EMPTY TEMP-TABLE tt-mla-lim-aprov-fam-destino.

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


    FOR EACH bf{&TableName} use-index familia NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-usuar    = pcOrigem
    BREAK BY bf{&TableName}.ep-codigo
          BY bf{&TableName}.fm-codigo
          BY bf{&TableName}.cod-tip-doc
          BY bf{&TableName}.cod-usuar:

        CREATE tt-mla-lim-aprov-fam-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-lim-aprov-fam-origem.
        ASSIGN tt-mla-lim-aprov-fam-origem.situacao = c-origem /* Usu†rios listados como usu†rios origem */
               tt-mla-lim-aprov-fam-origem.id-sit   = 5
               tt-mla-lim-aprov-fam-origem.r-rowid  = ROWID(bf{&TableName}).

        /* Incluir Somente inexistentes */
        IF piOpcao = 1 THEN
            IF NOT CAN-FIND(mla-lim-aprov-fam
                            WHERE mla-lim-aprov-fam.ep-codigo   = bf{&TableName}.ep-codigo
                              AND mla-lim-aprov-fam.fm-codigo   = bf{&TableName}.fm-codigo
                              AND mla-lim-aprov-fam.cod-tip-doc = bf{&TableName}.cod-tip-doc
                              AND mla-lim-aprov-fam.cod-usuar   = pcDestino) THEN DO:
                CREATE tt-mla-lim-aprov-fam-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-lim-aprov-fam-destino.
                ASSIGN tt-mla-lim-aprov-fam-destino.situacao   = c-novo
                       tt-mla-lim-aprov-fam-destino.id-sit     = 2
                       tt-mla-lim-aprov-fam-destino.r-rowid    = ROWID(bf{&TableName})
                       tt-mla-lim-aprov-fam-destino.cod-usuar = pcDestino.
            END.
            ELSE
                FOR FIRST mla-lim-aprov-fam NO-LOCK
                    WHERE mla-lim-aprov-fam.ep-codigo   = bf{&TableName}.ep-codigo
                      AND mla-lim-aprov-fam.fm-codigo   = bf{&TableName}.fm-codigo
                      AND mla-lim-aprov-fam.cod-tip-doc = bf{&TableName}.cod-tip-doc
                      AND mla-lim-aprov-fam.cod-usuar   = pcDestino:

                    CREATE tt-mla-lim-aprov-fam-destino.
                    BUFFER-COPY mla-lim-aprov-fam TO tt-mla-lim-aprov-fam-destino.
                    ASSIGN tt-mla-lim-aprov-fam-destino.situacao   = c-mantido
                           tt-mla-lim-aprov-fam-destino.id-sit     = 1
                           tt-mla-lim-aprov-fam-destino.r-rowid    = ROWID(mla-lim-aprov-fam)
                           tt-mla-lim-aprov-fam-destino.cod-usuar = pcDestino.
                END.


        /* Substituir existentes e incluir inexistentes */
        IF piOpcao = 2 THEN DO:
            FIND FIRST mla-lim-aprov-fam NO-LOCK
                 WHERE mla-lim-aprov-fam.ep-codigo   = bf{&TableName}.ep-codigo
                   AND mla-lim-aprov-fam.fm-codigo   = bf{&TableName}.fm-codigo
                   AND mla-lim-aprov-fam.cod-tip-doc = bf{&TableName}.cod-tip-doc
                   AND mla-lim-aprov-fam.cod-usuar   = pcDestino NO-ERROR.

            IF AVAIL mla-lim-aprov-fam THEN DO:

                CREATE tt-mla-lim-aprov-fam-destino.
                BUFFER-COPY mla-lim-aprov-fam TO tt-mla-lim-aprov-fam-destino.
                ASSIGN tt-mla-lim-aprov-fam-destino.situacao     = c-substituido
                       tt-mla-lim-aprov-fam-destino.id-sit       = 3
                       tt-mla-lim-aprov-fam-destino.r-rowid      = ROWID(mla-lim-aprov-fam)
                       tt-mla-lim-aprov-fam-destino.limite-aprov = bf{&TableName}.limite-aprov.
            END.
            ELSE DO:
                CREATE tt-mla-lim-aprov-fam-destino.
                BUFFER-COPY bf{&TableName} TO tt-mla-lim-aprov-fam-destino.
                {utp/ut-liter.i "Novo" * R}
                ASSIGN tt-mla-lim-aprov-fam-destino.situacao   = TRIM(RETURN-VALUE)
                       tt-mla-lim-aprov-fam-destino.id-sit     = 2
                       tt-mla-lim-aprov-fam-destino.r-rowid    = ROWID(bf{&TableName})
                       tt-mla-lim-aprov-fam-destino.cod-usuar = pcDestino.
            END.
        END.

        /* Substituir tudo */
        IF piOpcao = 3 THEN DO:
            IF LAST-OF(bf{&TableName}.fm-codigo) OR LAST-OF(bf{&TableName}.ep-codigo) THEN
                FOR EACH mla-lim-aprov-fam use-index familia NO-LOCK
                   WHERE mla-lim-aprov-fam.ep-codigo   = bf{&TableName}.ep-codigo
                     AND mla-lim-aprov-fam.fm-codigo   = bf{&TableName}.fm-codigo
                     AND mla-lim-aprov-fam.cod-usuar   = pcDestino:

                    CREATE tt-mla-lim-aprov-fam-destino.
                    BUFFER-COPY mla-lim-aprov-fam TO tt-mla-lim-aprov-fam-destino.
                    ASSIGN tt-mla-lim-aprov-fam-destino.situacao     = c-eliminado
                           tt-mla-lim-aprov-fam-destino.id-sit       = 4
                           tt-mla-lim-aprov-fam-destino.r-rowid      = ROWID(mla-lim-aprov-fam).

                END.

            CREATE tt-mla-lim-aprov-fam-destino.
            BUFFER-COPY bf{&TableName} TO tt-mla-lim-aprov-fam-destino.
            ASSIGN tt-mla-lim-aprov-fam-destino.situacao    = c-novo
                   tt-mla-lim-aprov-fam-destino.id-sit      = 2
                   tt-mla-lim-aprov-fam-destino.r-rowid     = ROWID(bf{&TableName})
                   tt-mla-lim-aprov-fam-destino.cod-usuar   = pcDestino.
        END.

    END.


    /* Label's */

    DEFINE VARIABLE c-lbl-fam        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-doc        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-limit      AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Documento" * R}
    ASSIGN c-lbl-doc = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Fam°lia" * R}
    ASSIGN c-lbl-fam = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Limite" * R}
    ASSIGN c-lbl-limit = TRIM(RETURN-VALUE).

    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    IF NOT plSimulaAlteracao THEN
        FOR EACH tt-mla-lim-aprov-fam-destino:
            do transaction:
                IF tt-mla-lim-aprov-fam-destino.id-sit = 4 OR tt-mla-lim-aprov-fam-destino.id-sit = 3 THEN DO: /* Exclus∆o ou ediá∆o */
                    FIND FIRST mla-lim-aprov-fam exclusive-lock where
                         rowid(mla-lim-aprov-fam) = tt-mla-lim-aprov-fam-destino.r-rowid no-error.
                    if not avail mla-lim-aprov-fam then next.
                END.
                CASE tt-mla-lim-aprov-fam-destino.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 6,
                                                    INPUT rowid(mla-lim-aprov-fam),
                                                    INPUT 3,
                                                    INPUT ENTRY(6,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-fam   + "          : " + string(tt-mla-lim-aprov-fam-destino.fm-codigo)   + chr(13) +
                                                        c-lbl-doc   + "          : " + string(tt-mla-lim-aprov-fam-destino.cod-tip-doc) + chr(13) +
                                                        c-lbl-usuar + "          : " + string(tt-mla-lim-aprov-fam-destino.cod-usuar)   + chr(13) +
                                                        c-lbl-limit + "          : " + string(tt-mla-lim-aprov-fam-destino.limite-aprov)).
                        delete mla-lim-aprov-fam.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-lim-aprov-fam.
                        BUFFER-COPY tt-mla-lim-aprov-fam-destino EXCEPT tt-mla-lim-aprov-fam-destino.situacao
                                                                        tt-mla-lim-aprov-fam-destino.r-rowid TO mla-lim-aprov-fam.
                        RUN pi-gera-log IN h-boin769(INPUT 6,
                                                     INPUT rowid(mla-lim-aprov-fam),
                                                     INPUT 1,
                                                     INPUT ENTRY(6,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                         c-lbl-fam   + "            : " + string(tt-mla-lim-aprov-fam-destino.fm-codigo)   + chr(13) +
                                                         c-lbl-doc   + "            : " + string(tt-mla-lim-aprov-fam-destino.cod-tip-doc) + chr(13) +
                                                         c-lbl-usuar + "            : " + string(tt-mla-lim-aprov-fam-destino.cod-usuar)   + chr(13) +
                                                         c-lbl-limit + "            : " + string(tt-mla-lim-aprov-fam-destino.limite-aprov)).
                        release mla-lim-aprov-fam.
                    END.
                    WHEN 3 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 6,
                                                    INPUT rowid(mla-lim-aprov-fam),
                                                    INPUT 2,
                                                    INPUT ENTRY(6,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                            c-lbl-limit + "             : " + string(mla-lim-aprov-fam.limite-aprov) + chr(13) +
                                                            "                         "  + string(tt-mla-lim-aprov-fam-destino.limite-aprov)).
                        ASSIGN mla-lim-aprov-fam.limite-aprov = tt-mla-lim-aprov-fam-destino.limite-aprov.
                        release mla-lim-aprov-fam.
                    END.
                END CASE.
            END.
        END.
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
        AND CAN-FIND(FIRST mla-lim-aprov-fam
                     WHERE mla-lim-aprov-fam.ep-codigo = RowObject.ep-codigo
                       AND mla-lim-aprov-fam.fm-codigo = RowObject.fm-codigo
                       AND mla-lim-aprov-fam.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-lim-aprov-fam.cod-usuar = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "limite_de_aprovaá∆o_da_fam°lia"}
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

        /* Existància da fam°lia */
        IF NOT CAN-FIND (FIRST familia
                         WHERE familia.fm-codigo = RowObject.fm-codigo) THEN DO:
            {utp/ut-liter.i "fam°lia"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valor de aprovaá∆o */
        IF CAN-FIND (FIRST RowObject
                     WHERE RowObject.limite-aprov < 0
                        OR RowObject.limite-aprov > 9999999999999.99) THEN DO:
            {utp/ut-liter.i "fam°lia"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="16198"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

