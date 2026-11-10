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
{include/i-prgvrs.i BOIN01100 2.00.00.011 } /*** "010011" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01100 MML}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01100
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-layout-usuar-doc
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
{inbo/boin01100.i RowObject}
{inbo/boin01100.i1}
{lap/mlaapi021.i1}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEFINE VARIABLE c-lbl-detalhe           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-id-campo          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-componente        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-desc-campo        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-visivel           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-tamanho           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-lista             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-entidade-pai      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-usuar             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-documento         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-aprovacao         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-tipo-interface    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-aprov-nao-config  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-campo             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-interface         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-ordem             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-rotulo            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-sim               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-nao               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin769               AS HANDLE      NO-UNDO.

{utp/ut-liter.i Detalhe *}
ASSIGN c-lbl-detalhe = RETURN-VALUE.
{utp/ut-liter.i Lista *}
ASSIGN c-lbl-lista = RETURN-VALUE.
{utp/ut-liter.i Id_do_campo *}
ASSIGN c-lbl-id-campo = RETURN-VALUE.
{utp/ut-liter.i Componente *}
ASSIGN c-lbl-componente = RETURN-VALUE.
{utp/ut-liter.i Descriá∆o_do_campo *}
ASSIGN c-lbl-desc-campo = RETURN-VALUE.
{utp/ut-liter.i Visibilidade_do_componente *}
ASSIGN c-lbl-visivel = RETURN-VALUE.
{utp/ut-liter.i Tamanho_do_componente *}
ASSIGN c-lbl-tamanho = RETURN-VALUE.
{utp/ut-liter.i Entidade_pai *}
ASSIGN c-lbl-entidade-pai = RETURN-VALUE.
{utp/ut-liter.i Usu†rio *}
ASSIGN c-lbl-usuar = RETURN-VALUE.
{utp/ut-liter.i Documento *}
ASSIGN c-lbl-documento = RETURN-VALUE.
{utp/ut-liter.i "Aprovaá∆o" *}
ASSIGN c-lbl-aprovacao = RETURN-VALUE.
{utp/ut-liter.i "Tipo_de_Interface" *}
ASSIGN c-lbl-tipo-interface = RETURN-VALUE.
{utp/ut-liter.i "Aprovador_e_n∆o_Ç_Configurador" *}
ASSIGN c-lbl-aprov-nao-config = RETURN-VALUE.
{utp/ut-liter.i "Campo" *}
ASSIGN c-lbl-campo = RETURN-VALUE.
{utp/ut-liter.i "Interface" *}
ASSIGN c-lbl-interface = RETURN-VALUE.
{utp/ut-liter.i "Ordem" *}
ASSIGN c-lbl-ordem = RETURN-VALUE.
{utp/ut-liter.i "R¢tulo" *}
ASSIGN c-lbl-rotulo = RETURN-VALUE.
{utp/ut-liter.i "Sim" *}
ASSIGN c-lbl-sim = RETURN-VALUE.
{utp/ut-liter.i "N∆o" *}
ASSIGN c-lbl-nao = RETURN-VALUE.

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
         HEIGHT             = 5.88
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE userHasAnyLayout DBOProgram
PROCEDURE userHasAnyLayout :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor l¢gico informando se usu†rio possui layouts
  Parameters:
               recebe c¢digo do usu†rio
               retorna valor l¢gico se encontrar layout
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pUserCode AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pHasAny AS LOGICAL NO-UNDO.

    ASSIGN pHasAny = NO.
    IF  CAN-FIND(FIRST bfmla-layout-usuar-doc
                 WHERE bfmla-layout-usuar-doc.cod-usuar = pUserCode) THEN DO:
        ASSIGN pHasAny = YES.
    END.

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
        WHEN "cod-entid-pai":U THEN ASSIGN pFieldValue = RowObject.cod-entid-pai.
        WHEN "cod-id-campo":U THEN ASSIGN pFieldValue = RowObject.cod-id-campo.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "des-campo":U THEN ASSIGN pFieldValue = RowObject.des-campo.
        WHEN "nom-rotu-campo":U THEN ASSIGN pFieldValue = RowObject.nom-rotu-campo.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "cdn-docto":U THEN ASSIGN pFieldValue = RowObject.cdn-docto.
        WHEN "cdn-ord":U THEN ASSIGN pFieldValue = RowObject.cdn-ord.
        WHEN "cdn-tam":U THEN ASSIGN pFieldValue = RowObject.cdn-tam.
        WHEN "idi-compon":U THEN ASSIGN pFieldValue = RowObject.idi-compon.
        WHEN "idi-interfac":U THEN ASSIGN pFieldValue = RowObject.idi-interfac.
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
  Purpose:     Retorna valores dos campos do °ndice mllytsrd_id2
  Parameters:
               retorna valor do campo cod-usuar
               retorna valor do campo idi-interfac
               retorna valor do campo cdn-docto
			   retorna valor do campo cod-id-campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar    LIKE mla-layout-usuar-doc.cod-usuar    NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-interfac LIKE mla-layout-usuar-doc.idi-interfac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-docto    LIKE mla-layout-usuar-doc.cdn-docto    NO-UNDO.
	DEFINE OUTPUT PARAMETER pcod-id-campo LIKE mla-layout-usuar-doc.cod-id-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-usuar    = RowObject.cod-usuar
           pidi-interfac = RowObject.idi-interfac
           pcdn-docto    = RowObject.cdn-docto
		   pcod-id-campo = RowObject.cod-id-campo.

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
        WHEN "log-visivel":U THEN ASSIGN pFieldValue = RowObject.log-visivel.
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
  Purpose:     Reposiciona registro com base no °ndice mllytsrd_id2
  Parameters:
               recebe valor do campo cod-usuar
               recebe valor do campo idi-interfac
               recebe valor do campo cdn-docto
			   recebe valor do campo cod-id-campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar    LIKE mla-layout-usuar-doc.cod-usuar    NO-UNDO.
    DEFINE INPUT PARAMETER pidi-interfac LIKE mla-layout-usuar-doc.idi-interfac NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-docto    LIKE mla-layout-usuar-doc.cdn-docto    NO-UNDO.
	DEFINE INPUT PARAMETER pcod-id-campo LIKE mla-layout-usuar-doc.cod-id-campo NO-UNDO.

    FIND FIRST bfmla-layout-usuar-doc WHERE
        bfmla-layout-usuar-doc.cod-usuar = pcod-usuar AND
        bfmla-layout-usuar-doc.idi-interfac = pidi-interfac AND
        bfmla-layout-usuar-doc.cdn-docto = pcdn-docto AND
		bfmla-layout-usuar-doc.cod-id-campo = pcod-id-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-layout-usuar-doc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-layout-usuar-doc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Query Principal do programa
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-layouts DBOProgram
PROCEDURE pi-copia-substituicao-layouts:
/*------------------------------------------------------------------------------
  Purpose:     Leitura e criaá∆o das temp-tables de layouts e c¢pia/substituiá∆o dos mesmos.
  Parameters:  /* Input */
               pcDestino         : Usu†rio origem
               pcOrigem          : Usu†rio destino
               piOpcao           : Indica qual opá∆o foi selecionada pelo usu†rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-layout-usuar-doc-origem  : ContÇm os dados dos registros (Layouts) do usu†rio origem
               tt-mla-layout-usuar-doc-dest    : ContÇm os dados dos registros(Layouts) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao           AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-layout-usuar-doc-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-layout-usuar-doc-dest.

    EMPTY TEMP-TABLE tt-mla-layout-usuar-doc-origem.
    EMPTY TEMP-TABLE tt-mla-layout-usuar-doc-dest.

    DEFINE VARIABLE h-mlaapi021 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-log-reg   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-origem    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-novo      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-mantido   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-erro      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-eliminado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-todos     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg-erro  AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Origem" * R}
    ASSIGN c-origem = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Novo" * R}
    ASSIGN c-novo = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Erro" * R}
    ASSIGN c-erro = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Mantido" * R}
    ASSIGN c-mantido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Eliminado" * R}
    ASSIGN c-eliminado = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Todos" * R}
    ASSIGN c-todos = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Usu†rio_sem_permiss∆o_no_documento" * R}
    ASSIGN c-msg-erro = TRIM(RETURN-VALUE).

    RUN lap/mlaapi021.p PERSISTENT SET h-mlaapi021.
    RUN pi-preenche-permissoes-usuario IN h-mlaapi021 (INPUT pcDestino,
                                                       INPUT 1,
                                                       OUTPUT TABLE tt-document).

    /* Layouts do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-usuar = pcDestino
        BREAK BY bf{&TableName}.idi-interfac
              BY bf{&TableName}.cdn-docto:

        IF piOpcao = 1 THEN DO: /* Se for somente inexistentes cria tt com os dados atuais e situaá∆o 'mantido' */

            CREATE tt-mla-layout-usuar-doc-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-dest.
            ASSIGN tt-mla-layout-usuar-doc-dest.situacao = c-mantido
                   tt-mla-layout-usuar-doc-dest.id-sit   = 1
                   tt-mla-layout-usuar-doc-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
        ELSE IF piOpcao = 2 THEN DO: /* Se for inexistentes e substituir existentes */
            IF FIRST-OF(bf{&TableName}.cdn-docto) THEN DO:
                IF CAN-FIND( mla-layout-usuar-doc NO-LOCK
                            WHERE mla-layout-usuar-doc.cod-usuar    = pcOrigem
                              AND mla-layout-usuar-doc.idi-interfac = bf{&TableName}.idi-interfac
                              AND mla-layout-usuar-doc.cdn-docto    = bf{&TableName}.cdn-docto) THEN DO:

                    FOR EACH mla-layout-usuar-doc NO-LOCK
                       WHERE mla-layout-usuar-doc.cod-usuar    = pcDestino
                         AND mla-layout-usuar-doc.idi-interfac = bf{&TableName}.idi-interfac
                         AND mla-layout-usuar-doc.cdn-docto    = bf{&TableName}.cdn-docto:

                        CREATE tt-mla-layout-usuar-doc-dest.
                        BUFFER-COPY mla-layout-usuar-doc TO tt-mla-layout-usuar-doc-dest.
                        ASSIGN tt-mla-layout-usuar-doc-dest.situacao  = c-eliminado
                               tt-mla-layout-usuar-doc-dest.id-sit    = 4
                               tt-mla-layout-usuar-doc-dest.r-rowid   = ROWID(mla-layout-usuar-doc).
                    END.
                END.
                ELSE DO:
                    FOR EACH mla-layout-usuar-doc NO-LOCK
                       WHERE mla-layout-usuar-doc.cod-usuar    = pcDestino
                         AND mla-layout-usuar-doc.idi-interfac = bf{&TableName}.idi-interfac
                         AND mla-layout-usuar-doc.cdn-docto    = bf{&TableName}.cdn-docto:

                        CREATE tt-mla-layout-usuar-doc-dest.
                        BUFFER-COPY mla-layout-usuar-doc TO tt-mla-layout-usuar-doc-dest.
                        ASSIGN tt-mla-layout-usuar-doc-dest.situacao = c-mantido
                               tt-mla-layout-usuar-doc-dest.id-sit   = 1
                               tt-mla-layout-usuar-doc-dest.r-rowid  = ROWID(mla-layout-usuar-doc).
                    END.
                END.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-layout-usuar-doc-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-dest.
            ASSIGN tt-mla-layout-usuar-doc-dest.situacao = c-eliminado
                   tt-mla-layout-usuar-doc-dest.id-sit   = 4
                   tt-mla-layout-usuar-doc-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
    END.

    /* Layouts do usu†rio origem e criaá∆o dos inexistentes do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-usuar = pcOrigem
       BREAK BY bf{&TableName}.idi-interfac
             BY bf{&TableName}.cdn-docto:

        CREATE tt-mla-layout-usuar-doc-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-origem.
        ASSIGN tt-mla-layout-usuar-doc-origem.situacao  = c-origem
               tt-mla-layout-usuar-doc-origem.id-sit    = 5
               tt-mla-layout-usuar-doc-origem.r-rowid   = ROWID(bf{&TableName}).

        IF piOpcao = 1 OR piOpcao = 2 THEN DO:
            IF FIRST-OF(bf{&TableName}.cdn-docto) THEN DO:
                FIND FIRST tt-document WHERE tt-document.cod-tip-doc = bf{&TableName}.cdn-docto NO-LOCK NO-ERROR.

                IF AVAIL tt-document THEN DO:
                    IF piOpcao = 2 OR
                       (piOpcao = 1 AND
                        NOT CAN-FIND( mla-layout-usuar-doc NO-LOCK
                                     WHERE mla-layout-usuar-doc.cod-usuar    = pcDestino
                                       AND mla-layout-usuar-doc.idi-interfac = bf{&TableName}.idi-interfac
                                       AND mla-layout-usuar-doc.cdn-docto    = bf{&TableName}.cdn-docto)) THEN DO:

                        FOR EACH mla-layout-usuar-doc NO-LOCK
                           WHERE mla-layout-usuar-doc.cod-usuar    = pcOrigem
                             AND mla-layout-usuar-doc.idi-interfac = bf{&TableName}.idi-interfac
                             AND mla-layout-usuar-doc.cdn-docto    = bf{&TableName}.cdn-docto:

                            CREATE tt-mla-layout-usuar-doc-dest.
                            BUFFER-COPY mla-layout-usuar-doc TO tt-mla-layout-usuar-doc-dest.
                            ASSIGN tt-mla-layout-usuar-doc-dest.situacao  = c-novo
                                   tt-mla-layout-usuar-doc-dest.id-sit    = 2
                                   tt-mla-layout-usuar-doc-dest.r-rowid   = ROWID(mla-layout-usuar-doc)
                                   tt-mla-layout-usuar-doc-dest.cod-usuar = pcDestino.
                        END.
                    END.
                END.
                ELSE DO:
                    CREATE tt-mla-layout-usuar-doc-dest.
                    BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-dest.
                    ASSIGN tt-mla-layout-usuar-doc-dest.situacao     = c-erro
                           tt-mla-layout-usuar-doc-dest.id-sit       = 7
                           tt-mla-layout-usuar-doc-dest.r-rowid      = ROWID(bf{&TableName})
                           tt-mla-layout-usuar-doc-dest.cod-id-campo = c-todos
                           tt-mla-layout-usuar-doc-dest.cod-usuar    = pcDestino
                           tt-mla-layout-usuar-doc-dest.erros        = c-msg-erro.
                END.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            FIND FIRST tt-document WHERE tt-document.cod-tip-doc = bf{&TableName}.cdn-docto NO-LOCK NO-ERROR.

            IF AVAIL tt-document THEN DO:
                CREATE tt-mla-layout-usuar-doc-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-dest.
                ASSIGN tt-mla-layout-usuar-doc-dest.situacao  = c-novo
                       tt-mla-layout-usuar-doc-dest.id-sit    = 2
                       tt-mla-layout-usuar-doc-dest.r-rowid   = ROWID(bf{&TableName})
                       tt-mla-layout-usuar-doc-dest.cod-usuar = pcDestino.
            END.
            ELSE DO:
                IF FIRST-OF(bf{&TableName}.cdn-docto) THEN DO:
                    CREATE tt-mla-layout-usuar-doc-dest.
                    BUFFER-COPY bf{&TableName} TO tt-mla-layout-usuar-doc-dest.
                    ASSIGN tt-mla-layout-usuar-doc-dest.situacao     = c-erro
                           tt-mla-layout-usuar-doc-dest.id-sit       = 7
                           tt-mla-layout-usuar-doc-dest.r-rowid      = ROWID(bf{&TableName})
                           tt-mla-layout-usuar-doc-dest.cod-id-campo = c-todos
                           tt-mla-layout-usuar-doc-dest.cod-usuar    = pcDestino
                           tt-mla-layout-usuar-doc-dest.erros        = c-msg-erro.
                END.
            END.
        END.
    END.

    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).

    IF NOT plSimulaAlteracao THEN DO:
        FOR EACH tt-mla-layout-usuar-doc-dest:
            do transaction:
                IF tt-mla-layout-usuar-doc-dest.id-sit = 4 OR tt-mla-layout-usuar-doc-dest.id-sit = 3 THEN DO: /* Exclus∆o ou ediá∆o */
                    FIND FIRST mla-layout-usuar-doc EXCLUSIVE-LOCK WHERE
                         ROWID(mla-layout-usuar-doc) = tt-mla-layout-usuar-doc-dest.r-rowid no-error.
                    if not avail mla-layout-usuar-doc then next.
                END.
                CASE tt-mla-layout-usuar-doc-dest.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 28,
                                                    INPUT rowid(mla-layout-usuar-doc),
                                                    INPUT 3,
                                                    INPUT ENTRY(28,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        trim(c-lbl-usuar) + "       : ":U + tt-mla-layout-usuar-doc-dest.cod-usuar + chr(13) +
                                                        trim(c-lbl-documento) + "  : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-docto) + chr(13) +
                                                        trim(c-lbl-interface) + "     : ":U + {ininc/i01in01100.i 04 tt-mla-layout-usuar-doc-dest.idi-interfac} + chr(13) +
                                                        trim(c-lbl-ordem) + "        : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-ord) + chr(13) +
                                                        trim(c-lbl-id-campo) + ": ":U + tt-mla-layout-usuar-doc-dest.cod-id-campo + chr(13) +
                                                        trim(c-lbl-rotulo) + "         : ":U + tt-mla-layout-usuar-doc-dest.nom-rotu-campo + chr(13) +
                                                        trim(c-lbl-desc-campo) + "          : ":U + tt-mla-layout-usuar-doc-dest.des-campo + chr(13) +
                                                        trim(c-lbl-componente) + "                     : ":U + {ininc/i02in01100.i 04 tt-mla-layout-usuar-doc-dest.idi-compon} + chr(13) +
                                                        trim(c-lbl-tamanho) + "   : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-tam) + chr(13) +
                                                        trim(c-lbl-visivel) + ": ":U + (IF tt-mla-layout-usuar-doc-dest.log-visivel THEN c-lbl-sim ELSE c-lbl-nao) + chr(13) +
                                                        trim(c-lbl-entidade-pai) + "                      : ":U + tt-mla-layout-usuar-doc-dest.cod-entid-pai + chr(13)).
                        delete mla-layout-usuar-doc.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-layout-usuar-doc.
                        BUFFER-COPY tt-mla-layout-usuar-doc-dest EXCEPT tt-mla-layout-usuar-doc-dest.situacao
                                                                        tt-mla-layout-usuar-doc-dest.r-rowid TO mla-layout-usuar-doc.
                        RUN pi-gera-log IN h-boin769(INPUT 28,
                                                    INPUT rowid(mla-layout-usuar-doc),
                                                    INPUT 1,
                                                    INPUT ENTRY(28,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        trim(c-lbl-usuar) + "       : ":U + tt-mla-layout-usuar-doc-dest.cod-usuar + chr(13) +
                                                        trim(c-lbl-documento) + "  : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-docto) + chr(13) +
                                                        trim(c-lbl-interface) + "     : ":U + {ininc/i01in01100.i 04 tt-mla-layout-usuar-doc-dest.idi-interfac} + chr(13) +
                                                        trim(c-lbl-ordem) + "        : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-ord) + chr(13) +
                                                        trim(c-lbl-id-campo) + ": ":U + tt-mla-layout-usuar-doc-dest.cod-id-campo + chr(13) +
                                                        trim(c-lbl-rotulo) + "         : ":U + tt-mla-layout-usuar-doc-dest.nom-rotu-campo + chr(13) +
                                                        trim(c-lbl-desc-campo) + "          : ":U + tt-mla-layout-usuar-doc-dest.des-campo + chr(13) +
                                                        trim(c-lbl-componente) + "                     : ":U + {ininc/i02in01100.i 04 tt-mla-layout-usuar-doc-dest.idi-compon} + chr(13) +
                                                        trim(c-lbl-tamanho) + "   : ":U + string(tt-mla-layout-usuar-doc-dest.cdn-tam) + chr(13) +
                                                        trim(c-lbl-visivel) + ": ":U + (IF tt-mla-layout-usuar-doc-dest.log-visivel THEN c-lbl-sim ELSE c-lbl-nao) + chr(13) +
                                                        trim(c-lbl-entidade-pai) + "                      : ":U + tt-mla-layout-usuar-doc-dest.cod-entid-pai + chr(13)).
                        release mla-layout-usuar-doc.
                    END.
                END CASE.
            END.
        END.
    END.

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    IF VALID-HANDLE(h-mlaapi021) THEN DO:
        DELETE PROCEDURE h-mlaapi021.
        ASSIGN h-mlaapi021 = ?.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaCamposLayout DBOProgram
PROCEDURE piEliminaCamposLayout :
/*------------------------------------------------------------------------------
  Purpose: Elimina os campos de layout de um Usu†rio, Interface e Documento
  Parameters:  cUser: Usu†rio
               iInterface: Interface
               iDocument: Documento
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cUser       AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER iInterface  AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER iDocument   AS INTEGER    NO-UNDO.

    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    FOR EACH mla-layout-usuar-doc EXCLUSIVE-LOCK
       WHERE mla-layout-usuar-doc.cod-usuar    = cUser
         AND mla-layout-usuar-doc.idi-interfac = iInterface
         AND mla-layout-usuar-doc.cdn-docto    = iDocument:

        RUN pi-gera-log IN h-boin769(INPUT 28,
                                     INPUT ROWID(mla-layout-usuar-doc),
                                     INPUT 3,
                                     INPUT ENTRY(28,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                           trim(c-lbl-usuar) + "       : ":U + mla-layout-usuar-doc.cod-usuar + chr(13) +
                                           trim(c-lbl-documento) + "  : ":U + string(mla-layout-usuar-doc.cdn-docto) + chr(13) +
                                           trim(c-lbl-interface) + "     : ":U + {ininc/i01in01100.i 04 mla-layout-usuar-doc.idi-interfac} + chr(13) +
                                           trim(c-lbl-ordem) + "        : ":U + string(mla-layout-usuar-doc.cdn-ord) + chr(13) +
                                           trim(c-lbl-id-campo) + ": ":U + mla-layout-usuar-doc.cod-id-campo + chr(13) +
                                           trim(c-lbl-rotulo) + "         : ":U + mla-layout-usuar-doc.nom-rotu-campo + chr(13) +
                                           trim(c-lbl-desc-campo) + "          : ":U + mla-layout-usuar-doc.des-campo + chr(13) +
                                           trim(c-lbl-componente) + "                     : ":U + {ininc/i02in01100.i 04 mla-layout-usuar-doc.idi-compon} + chr(13) +
                                           trim(c-lbl-tamanho) + "   : ":U + string(mla-layout-usuar-doc.cdn-tam) + chr(13) +
                                           trim(c-lbl-visivel) + ": ":U + (IF mla-layout-usuar-doc.log-visivel THEN c-lbl-sim ELSE c-lbl-nao) + chr(13) +
                                           trim(c-lbl-entidade-pai) + "                      : ":U + mla-layout-usuar-doc.cod-entid-pai + chr(13)).

        DELETE mla-layout-usuar-doc.
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

    DEFINE VARIABLE c-lbl-campo-erro AS CHARACTER   NO-UNDO.

    ASSIGN c-lbl-campo-erro = " (":U + c-lbl-campo + ": " + RowObject.cod-id-campo + ")":U.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U THEN DO:
        FIND FIRST {&TableName} NO-LOCK
             WHERE {&TableName}.cod-usuar    = RowObject.cod-usuar
               AND {&TableName}.idi-interfac = RowObject.idi-interfac
               AND {&TableName}.cdn-docto    = RowObject.cdn-docto
               AND {&TableName}.cod-id-campo = RowObject.cod-id-campo NO-ERROR.

        IF AVAIL {&TableName} THEN DO:
            {utp/ut-liter.i "Campo_de_Layout" *}

            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    /* Validaá∆o de usu†rio */
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-ERROR.

    IF NOT AVAIL mla-usuar-aprov THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-usuar"}
    END.
    ELSE DO:
        IF NOT mla-usuar-aprov.perm-aprov AND NOT mla-usuar-aprov.log-usuar-config THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17195"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-usuar +  '~~~~':U + c-lbl-aprov-nao-config"}
        END.
    END.

    /* Validaá∆o de interface */
    IF RowObject.idi-interfac < 1 OR
       RowObject.idi-interfac > 2 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-tipo-interface"}
    END.

    /* Validaá∆o de Documento */
    IF RowObject.cdn-docto <= 500 THEN DO:
        IF  SEARCH("lap/mla-doc-":U + STRING(RowObject.cdn-docto) + ".r":U) = ?
        AND SEARCH("lap/mla-doc-":U + STRING(RowObject.cdn-docto) + ".p":U) = ?
        AND NOT CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-aprova-generico-":U + STRING(RowObject.cdn-docto) AND funcao.ativo = YES) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="27843"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-documento +  '~~~~':U + c-lbl-aprovacao"}
        END.
    END.

    FOR FIRST mla-tipo-doc-aprov FIELDS (cod-tip-doc des-tip-doc)
        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cdn-docto NO-LOCK:
    END.

    IF NOT AVAIL mla-tipo-doc-aprov THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="27843"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-documento +  '~~~~':U + c-lbl-aprovacao"}
    END.

    /* Id do campo de ser informado */
    IF RowObject.cod-id-campo = "" THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="265"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-id-campo"}
    END.

    /* Componente de ser do tipo 1 - Campo / 2 - Lista / 3 - Separador */
    IF RowObject.idi-compon <> 1 AND RowObject.idi-compon <> 2 AND RowObject.idi-compon <> 3 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-componente + c-lbl-campo-erro"}
    END.
    ELSE DO:
        /* Para a lista, apenas Ç aceito componente do tipo "Campo" */
        IF RowObject.idi-interfac = 1 AND RowObject.idi-compon <> 1 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56976"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}
        END.
    END.

    /* Descriá∆o do campo deve ser informada */
    IF RowObject.des-campo = "" THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="265"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-desc-campo + c-lbl-campo-erro"}
    END.

    /* Visibilidade do campo deve ser informada */
    IF RowObject.log-visivel = ? THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="265"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-visivel + c-lbl-campo-erro"}
    END.

    /* Tamanho do campo precisa ser um valor v†lido */
    IF RowObject.cdn-tam = 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-tamanho + c-lbl-campo-erro"}
    END.
    ELSE DO:
        /* Para a lista s∆o aceitos apenas os tamanhos 50 e 100 */
        IF RowObject.idi-interfac = 1 AND RowObject.cdn-tam <> 50 AND RowObject.cdn-tam <> 100 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56977"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-campo-erro"}
        END.
        ELSE DO:
            /* Para o detalhe os tamanhos aceitos s∆o: 25, 50, 75 e 100 */
            IF RowObject.idi-interfac = 2 AND
               RowObject.cdn-tam <> 25 AND RowObject.cdn-tam <> 50 AND
               RowObject.cdn-tam <> 75 AND RowObject.cdn-tam <> 100 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-tamanho + c-lbl-campo-erro"}
            END.
            ELSE DO:
                /* Lista e Serapador devem ter tamanho de 100 */
                IF RowObject.idi-interfac = 2 AND
                   (RowObject.idi-compon = 2 OR RowObject.idi-compon = 3) AND
                   RowObject.cdn-tam <> 100 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="56982"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-campo-erro"}
                END.
            END.
        END.
    END.

    /* Lista n∆o pode ter componente com entidade pai definidido, pois n∆o Ç permitido
       estrutura de pai e filho. */
    IF RowObject.cod-entid-pai <> "" AND RowObject.idi-interfac = 1 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="56980"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-campo-erro"}
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

