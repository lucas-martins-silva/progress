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
{include/i-prgvrs.i BOIN786 2.00.00.026 } /*** "010026" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin786 MUT}
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
&GLOBAL-DEFINE DBOName boin786
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-usuar-aprov-altern
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar

&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin786.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt-usuar-aprov-altern NO-UNDO
    LIKE mla-usuar-aprov-altern.

DEFINE VARIABLE c-retorno       AS   CHARACTER                     NO-UNDO.
DEFINE VARIABLE c-empresa-mla   LIKE empresa.ep-codigo             NO-UNDO.
DEFINE VARIABLE c-cod-estab-mla LIKE estabelec.cod-estabel         NO-UNDO.
DEFINE VARIABLE da-data-geracao LIKE mla-doc-pend-aprov.dt-geracao NO-UNDO.
DEFINE VARIABLE c-lbl-data-inicial AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-data-final AS CHARACTER   NO-UNDO.

def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
{inbo/boin786.i1} /* Defini‡Æo das temp-tables utilizadas na pi-copia-substituicao-permissoes */

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
         HEIGHT             = 2.38
         WIDTH              = 40.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAlternativos DBOProgram
PROCEDURE getAlternativos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-usuar LIKE {&TABLENAME}.cod-usuar.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mla-alternativos-def.

    FOR EACH bf{&TABLENAME} WHERE
             bf{&TABLENAME}.cod-usuar = p-cod-usuar  NO-LOCK:
        CREATE tt-mla-alternativos-def.
        assign tt-mla-alternativos-def.cod-usuar-altern  = bf{&TABLENAME}.cod-usuar-altern
               tt-mla-alternativos-def.da-inicial        = bf{&TABLENAME}.validade-ini
               tt-mla-alternativos-def.da-final          = bf{&TABLENAME}.validade-fim.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAltervativeUsers DBOProgram
PROCEDURE getAltervativeUsers :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER QP_cod-usuar LIKE {&TableName}.cod-usuar NO-UNDO.

    RUN setConstraintUsuario IN THIS-PROCEDURE (INPUT QP_cod-usuar).
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "byCodUsuar":U).

    DEFINE VARIABLE i-nro-rows AS INTEGER     NO-UNDO.

   RUN getBatchRecords       IN THIS-PROCEDURE
    (?, no, ?, output i-nro-rows, output table RowoBJECT).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAprovadorAlternativo DBOProgram
PROCEDURE getAprovadorAlternativo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  NOT AVAILABLE bfmla-usuar-aprov-altern THEN
        RETURN "NOK":U.

    IF  c-empresa-mla   <> ""
    AND c-cod-estab-mla <> ""
    AND da-data-geracao <> ? THEN DO:
        FOR FIRST mla-param-aprov FIELDS(log-aprovac-altern-dat)
            WHERE mla-param-aprov.ep-codigo   = c-empresa-mla
              AND mla-param-aprov.cod-estabel = c-cod-estab-mla NO-LOCK:
        END.

        IF mla-param-aprov.log-aprovac-altern-dat THEN DO:
            IF  bfmla-usuar-aprov-altern.validade-ini <= da-data-geracao AND
                bfmla-usuar-aprov-altern.validade-fim >= da-data-geracao THEN
            RETURN "OK":U.
        END.
        ELSE DO:
            IF  bfmla-usuar-aprov-altern.validade-ini <= TODAY AND
                bfmla-usuar-aprov-altern.validade-fim >= TODAY THEN
            RETURN "OK":U.
        END.
    END.
    ELSE DO:
        IF  bfmla-usuar-aprov-altern.validade-ini <= TODAY AND
            bfmla-usuar-aprov-altern.validade-fim >= TODAY THEN
            RETURN "OK":U.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAprovAlternativos DBOProgram
PROCEDURE getAprovAlternativos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-usuar-altern LIKE {&TABLENAME}.cod-usuar.
    /*DEFINE INPUT  PARAMETER p-data      LIKE {&TABLENAME}.validade-ini.*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mla-alternativos-def.

    FOR EACH bf{&TABLENAME} WHERE
        bf{&TABLENAME}.cod-usuar-altern = p-cod-usuar-altern /*AND
        bf{&TABLENAME}.validade-ini <= p-data AND
        bf{&TABLENAME}.validade-fim >= p-data*/ NO-LOCK:
        CREATE tt-mla-alternativos-def.
        assign tt-mla-alternativos-def.cod-usuar  = bf{&TABLENAME}.cod-usuar
               tt-mla-alternativos-def.da-inicial = bf{&TABLENAME}.validade-ini
               tt-mla-alternativos-def.da-final   = bf{&TABLENAME}.validade-fim.
    end.

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
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "cod-usuar-altern":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-altern.
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
  Purpose:     Retorna valores dos campos do ¡ndice alternativo
  Parameters:
               retorna valor do campo cod-usuar
               retorna valor do campo cod-usuar-altern
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-usuar-aprov-altern.cod-usuar NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuar-altern LIKE mla-usuar-aprov-altern.cod-usuar-altern NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-usuar = RowObject.cod-usuar
           pcod-usuar-altern = RowObject.cod-usuar-altern.

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
  Purpose:     Reposiciona registro com base no ¡ndice alternativo
  Parameters:
               recebe valor do campo cod-usuar
               recebe valor do campo cod-usuar-altern
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-usuar-aprov-altern.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar-altern LIKE mla-usuar-aprov-altern.cod-usuar-altern NO-UNDO.


    FIND FIRST bfmla-usuar-aprov-altern WHERE
        bfmla-usuar-aprov-altern.cod-usuar = pcod-usuar AND
        bfmla-usuar-aprov-altern.cod-usuar-altern = pcod-usuar-altern NO-LOCK NO-ERROR.


        for each RowErrors: /*cristiano*/
            put rowerrors.ErrorNumber skip.
        end.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-usuar-aprov-altern THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-usuar-aprov-altern)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyValidade DBOProgram
PROCEDURE goToKeyValidade :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice alternativo
  Parameters:
               recebe valor do campo cod-usuar
               recebe valor do campo cod-usuar-altern
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-usuar-aprov-altern.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-usuar-aprov-altern.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuar-altern LIKE mla-usuar-aprov-altern.cod-usuar-altern NO-UNDO.
    DEFINE INPUT PARAMETER pda-validade LIKE mla-usuar-aprov-altern.validade-ini NO-UNDO.

    FIND FIRST bfmla-usuar-aprov-altern WHERE
        bfmla-usuar-aprov-altern.ep-codigo = pep-codigo AND
        bfmla-usuar-aprov-altern.cod-usuar = pcod-usuar AND
        bfmla-usuar-aprov-altern.cod-usuar-altern = pcod-usuar-altern AND
        bfmla-usuar-aprov-altern.validade-ini <= TODAY AND
        bfmla-usuar-aprov-altern.validade-fim >= TODAY NO-LOCK NO-ERROR.


    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-usuar-aprov-altern THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-usuar-aprov-altern)).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-alternativos DBOProgram
PROCEDURE pi-copia-substituicao-alternativos :
/*------------------------------------------------------------------------------
  Purpose:     Leitura e cria‡Æo das temp-tables de aprovadores alternativos e c¢pia/substitui‡Æo dos mesmos.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcDestino         : Usu rio origem
               pcOrigem          : Usu rio destino
               piOpcao           : Indica qual op‡Æo foi selecionada pelo usu rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se ‚ apenas um simula‡Æo(cria as temp-tables por‚m nÆo efetiva as altera‡äes na base).
               /* Output */
               tt-mla-usuar-aprov-altern-origem  : Cont‚m os dados dos registros(Aprovadores do documento) do usu rio origem
               tt-mla-usuar-aprov-altern-dest    : Cont‚m os dados dos registros(Aprovadores do documento) do usu rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim      LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao           AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-usuar-aprov-altern-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-usuar-aprov-altern-dest.

    EMPTY TEMP-TABLE tt-mla-usuar-aprov-altern-origem.
    EMPTY TEMP-TABLE tt-mla-usuar-aprov-altern-dest.

    define variable c-novo as char no-undo.
    define variable c-mantido as char no-undo.
    define variable c-substituido as char no-undo.
    define variable c-eliminado as char no-undo.
    define variable c-origem as char no-undo.

    {utp/ut-liter.i "Novo" * R}
    assign c-novo = trim(return-value).

    {utp/ut-liter.i "Mantido" * R}
    assign c-mantido = trim(return-value).

    {utp/ut-liter.i "Substitu¡do" * R}
    assign c-substituido = trim(return-value).

    {utp/ut-liter.i "Eliminado" * R}
    assign c-eliminado = trim(return-value).

    {utp/ut-liter.i "Origem" * R}
    assign c-origem = trim(return-value).

    /* Usu rio alternativo do usu rio destino */
    FOR EACH bf{&TableName} use-index empresa NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-usuar    = pcDestino:

        IF piOpcao = 1 THEN DO: /* Se for somente inexistentes cria tt com os dados atuais e situa‡Æo 'mantido' */
            CREATE tt-mla-usuar-aprov-altern-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-dest.
            ASSIGN tt-mla-usuar-aprov-altern-dest.situacao = c-mantido
                   tt-mla-usuar-aprov-altern-dest.id-sit   = 1
                   tt-mla-usuar-aprov-altern-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
        ELSE IF piOpcao = 2 THEN DO: /* Se for inexistentes e substituir existentes */
            FIND FIRST mla-usuar-aprov-altern use-index empresa NO-LOCK
                 WHERE mla-usuar-aprov-altern.ep-codigo = bf{&TableName}.ep-codigo
                   AND mla-usuar-aprov-altern.cod-usuar = pcOrigem
                   AND mla-usuar-aprov-altern.cod-usuar-altern = bf{&TableName}.cod-usuar-altern
                   NO-ERROR.

            IF AVAIL mla-usuar-aprov-altern THEN DO:

                CREATE tt-mla-usuar-aprov-altern-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-dest.
                ASSIGN tt-mla-usuar-aprov-altern-dest.situacao     = c-substituido
                       tt-mla-usuar-aprov-altern-dest.id-sit       = 3
                       tt-mla-usuar-aprov-altern-dest.validade-ini = mla-usuar-aprov-altern.validade-ini
                       tt-mla-usuar-aprov-altern-dest.validade-fim = mla-usuar-aprov-altern.validade-fim
                       tt-mla-usuar-aprov-altern-dest.r-rowid      = ROWID(bf{&TableName}).
            END.
            ELSE DO:
                CREATE tt-mla-usuar-aprov-altern-dest.
                ASSIGN tt-mla-usuar-aprov-altern-dest.situacao = c-mantido
                       tt-mla-usuar-aprov-altern-dest.id-sit   = 1
                       tt-mla-usuar-aprov-altern-dest.r-rowid  = ROWID(bf{&TableName}).
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-usuar-aprov-altern-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-dest.
            ASSIGN tt-mla-usuar-aprov-altern-dest.situacao = c-eliminado
                   tt-mla-usuar-aprov-altern-dest.id-sit   = 4
                   tt-mla-usuar-aprov-altern-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
    END.

    /* Usu rio alternativos do usu rio origem e cria‡Æo dos inexistentes do usu rio destino */
    FOR EACH bf{&TableName} use-index empresa NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-usuar    = pcOrigem:

        CREATE tt-mla-usuar-aprov-altern-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-origem.
        ASSIGN tt-mla-usuar-aprov-altern-origem.situacao  = c-origem
               tt-mla-usuar-aprov-altern-origem.id-sit    = 5
               tt-mla-usuar-aprov-altern-origem.r-rowid   = ROWID(bf{&TableName}).
        IF piOpcao = 1 OR piOpcao = 2 THEN DO:
            IF NOT CAN-FIND(FIRST mla-usuar-aprov-altern use-index empresa
                            WHERE mla-usuar-aprov-altern.ep-codigo        = bf{&TableName}.ep-codigo
                              AND mla-usuar-aprov-altern.cod-usuar        = pcDestino
                              AND mla-usuar-aprov-altern.cod-usuar-altern = bf{&TableName}.cod-usuar-altern) THEN DO:

                CREATE tt-mla-usuar-aprov-altern-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-dest.
                ASSIGN tt-mla-usuar-aprov-altern-dest.situacao  = c-novo
                       tt-mla-usuar-aprov-altern-dest.id-sit    = 2
                       tt-mla-usuar-aprov-altern-dest.r-rowid   = ROWID(bf{&TableName})
                       tt-mla-usuar-aprov-altern-dest.cod-usuar = pcDestino.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-usuar-aprov-altern-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-usuar-aprov-altern-dest.
            ASSIGN tt-mla-usuar-aprov-altern-dest.situacao  = c-novo
                   tt-mla-usuar-aprov-altern-dest.id-sit    = 2
                   tt-mla-usuar-aprov-altern-dest.r-rowid   = ROWID(bf{&TableName})
                   tt-mla-usuar-aprov-altern-dest.cod-usuar = pcDestino.
        END.
    END.

    /* Label's */
    DEFINE VARIABLE c-lbl-altern     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-ini  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-valid-fim  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Alternativo" * R}
    ASSIGN c-lbl-altern = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Inicial" * R}
    ASSIGN c-lbl-valid-ini = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Validade_Final" * R}
    ASSIGN c-lbl-valid-fim = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Usu rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    DEFINE VARIABLE h-boin769 AS HANDLE NO-UNDO.
    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    IF NOT plSimulaAlteracao THEN
        FOR EACH tt-mla-usuar-aprov-altern-dest:
            do transaction:
                IF tt-mla-usuar-aprov-altern-dest.id-sit = 4 OR tt-mla-usuar-aprov-altern-dest.id-sit = 3 THEN DO: /* ExclusÆo ou edi‡Æo */
                    find first mla-usuar-aprov-altern exclusive-lock where
                         rowid(mla-usuar-aprov-altern) = tt-mla-usuar-aprov-altern-dest.r-rowid no-error.
                    if not avail (mla-usuar-aprov-altern) then next.
                END.
                CASE tt-mla-usuar-aprov-altern-dest.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 24,
                                                     INPUT rowid(mla-usuar-aprov-altern),
                                                     INPUT 3,
                                                     INPUT ENTRY(24,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar     + "   : " + string(tt-mla-usuar-aprov-altern-dest.cod-usuar)        + chr(13) +
                                                        c-lbl-altern    + "   : " + string(tt-mla-usuar-aprov-altern-dest.cod-usuar-altern) + chr(13) +
                                                        c-lbl-valid-ini + "   : " + string(tt-mla-usuar-aprov-altern-dest.validade-ini)     + chr(13) +
                                                        c-lbl-valid-fim + "   : " + string(tt-mla-usuar-aprov-altern-dest.validade-fim)).

                        delete mla-usuar-aprov-altern.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-usuar-aprov-altern.
                        BUFFER-COPY tt-mla-usuar-aprov-altern-dest EXCEPT tt-mla-usuar-aprov-altern-dest.situacao
                                                                          tt-mla-usuar-aprov-altern-dest.r-rowid TO mla-usuar-aprov-altern.
                        RUN pi-gera-log IN h-boin769(INPUT 24,
                                                    INPUT rowid(mla-usuar-aprov-altern),
                                                    INPUT 1,
                                                    INPUT ENTRY(24,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar     + "        : " + string(tt-mla-usuar-aprov-altern-dest.cod-usuar)        + chr(13) +
                                                        c-lbl-altern    + "        : " + string(tt-mla-usuar-aprov-altern-dest.cod-usuar-altern) + chr(13) +
                                                        c-lbl-valid-ini + "        : " + string(tt-mla-usuar-aprov-altern-dest.validade-ini)     + chr(13) +
                                                        c-lbl-valid-fim + "        : " + string(tt-mla-usuar-aprov-altern-dest.validade-fim)).
                        release mla-usuar-aprov-altern.
                    END.
                    WHEN 3 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 24,
                                                     INPUT rowid(mla-usuar-aprov-altern),
                                                     INPUT 2,
                                                     INPUT ENTRY(24,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                             c-lbl-valid-ini + "   : " + string(mla-usuar-aprov-altern.validade-ini) + chr(13) +
                                                             "                       " + string(tt-mla-usuar-aprov-altern-dest.validade-ini)     + chr(13) +
                                                             c-lbl-valid-fim + "Validade Final     : " + string(mla-usuar-aprov-altern.validade-fim) + chr(13) +
                                                             "                                       " + string(tt-mla-usuar-aprov-altern-dest.validade-fim)).
                        ASSIGN mla-usuar-aprov-altern.validade-ini = tt-mla-usuar-aprov-altern-dest.validade-ini
                               mla-usuar-aprov-altern.validade-fim = tt-mla-usuar-aprov-altern-dest.validade-fim.
                        release mla-usuar-aprov-altern.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMlaParamAprovDtGeracao DBOProgram
PROCEDURE setMlaParamAprovDtGeracao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-empresa-mla   LIKE empresa.ep-codigo             NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-mla LIKE estabelec.cod-estabel         NO-UNDO.
    DEFINE INPUT PARAMETER pd-data-geracao  LIKE mla-doc-pend-aprov.dt-geracao NO-UNDO.

    ASSIGN c-empresa-mla   = pc-empresa-mla
           c-cod-estab-mla = pc-cod-estab-mla
           da-data-geracao = pd-data-geracao.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValidateAlternativos DBOProgram
PROCEDURE setValidateAlternativos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-usuar AS CHAR FORMAT "x(12)".
    DEFINE INPUT PARAMETER TABLE FOR tt-mla-alternativos-def.

    ASSIGN c-retorno = "NOK".
    FOR EACH tt-mla-alternativos-def:
        FIND FIRST bf{&TABLENAME} WHERE
                   bf{&TABLENAME}.cod-usuar = p-cod-usuar AND
                   bf{&TABLENAME}.cod-usuar-altern = tt-mla-alternativos-def.cod-usuar-altern
            EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAILABLE bf{&TABLENAME} THEN DO:
            ASSIGN c-retorno = "OK".
            ASSIGN bf{&TABLENAME}.validade-ini = tt-mla-alternativos-def.da-inicial
                   bf{&TABLENAME}.validade-fim = tt-mla-alternativos-def.da-final.
        END.
    END.

    RETURN c-retorno.
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
        AND CAN-FIND(FIRST mla-usuar-aprov-altern
                     WHERE mla-usuar-aprov-altern.cod-usuar = RowObject.cod-usuar
                       AND mla-usuar-aprov-altern.cod-usuar-altern = RowObject.cod-usuar-altern) THEN DO:
            {utp/ut-liter.i "aprovadores_alternativos"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        ASSIGN RowObject.ep-codigo = i-ep-codigo-usuario.

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

        /* Existˆncia do usu rio alternativo */
        IF NOT CAN-FIND (FIRST mla-usuar-aprov
                         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar-altern) THEN DO:
            {utp/ut-liter.i "usu rio_alternativo"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        IF TRIM(STRING(RowObject.validade-ini)) = "" OR TRIM(STRING(RowObject.validade-fim)) = "" THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="173"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.

        IF RowObject.validade-ini > RowObject.validade-fim THEN DO:
            {utp/ut-liter.i "data_inicial"}
            ASSIGN c-lbl-data-inicial = RETURN-VALUE.
            {utp/ut-liter.i "Data_final"}
            ASSIGN c-lbl-data-final = RETURN-VALUE.
            {method/svc/errors/inserr.i
                    &ErrorNumber="1207"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-data-final + '~~~~' + c-lbl-data-inicial"}
        END.

        IF CAN-FIND (FIRST mla-usuar-aprov
                     WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar-altern
                       AND NOT mla-usuar-aprov.perm-aprov) THEN DO:

            {method/svc/errors/inserr.i
                    &ErrorNumber="54988"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RowObject.cod-usuar-altern}

        END.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
       DEFINE VARIABLE iTipoOperacao AS INTEGER NO-UNDO.
       ASSIGN iTipoOperacao = IF pType = "CREATE":U THEN 1 ELSE 2.

       RUN afterCreateRecord IN THIS-PROCEDURE  (INPUT iTipoOperacao) . /* Executa s¢ se foi OK */
   END.
   ELSE
       RUN afterDeletRecord IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord:
    DEFINE INPUT PARAMETER piTipoOperacao AS INTEGER NO-UNDO.

    create mla-log-reg.
    assign mla-log-reg.ep-codigo   = RowObject.ep-codigo
           mla-log-reg.cod-estabel = ""
           mla-log-reg.cod-usuar   = RowObject.cod-usuar
           mla-log-reg.cod-tabela  = 24
           mla-log-reg.chave-reg   = string(RowObject.cod-usuar) + " | " +
                                     string(RowObject.cod-usuar-altern)
           mla-log-reg.data-reg    = today
           mla-log-reg.hora-reg    = string(time,"hh:mm")
           mla-log-reg.tipo-reg    = piTipoOperacao
           mla-log-reg.log-reg     = entry(24,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                     "Usuÿrio            : " + string(RowObject.cod-usuar)        + chr(13) +
                                     "Alternativo        : " + string(RowObject.cod-usuar-altern) + chr(13) +
                                     "Validade Inicial   : " + string(RowObject.validade-ini)     + chr(13) +
                                     "Validade Final     : " + string(RowObject.validade-fim).

    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterDeletRecord:
    create mla-log-reg.
    assign mla-log-reg.ep-codigo   = RowObject.ep-codigo
           mla-log-reg.cod-estabel = ""
           mla-log-reg.cod-usuar   = RowObject.cod-usuar
           mla-log-reg.cod-tabela  = 24
           mla-log-reg.chave-reg   = string(RowObject.cod-usuar) + " | " +
                                     string(RowObject.cod-usuar-altern)
           mla-log-reg.data-reg    = today
           mla-log-reg.hora-reg    = string(time,"hh:mm")
           mla-log-reg.tipo-reg    = 3
           mla-log-reg.log-reg     = entry(24,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                     "Usuÿrio            : " + string(RowObject.cod-usuar)        + chr(13) +
                                     "Alternativo        : " + string(RowObject.cod-usuar-altern) + chr(13) +
                                     "Validade Inicial   : " + string(RowObject.validade-ini)     + chr(13) +
                                     "Validade Final     : " + string(RowObject.validade-fim).

    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


