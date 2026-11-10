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
{include/i-prgvrs.i BOIN01101 2.00.00.006 } /*** "010006" 04/09/2026 21:53:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01101 MML}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01101
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-configur-visual-usuar
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
{inbo/boin01101.i RowObject}
{inbo/boin01101.i1}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-lbl-usuar                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-interface              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-ordenacao-padrao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-todas-empresas         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-aprov-sem-info-motivo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-visualiz-ini           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-sim                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-nao                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin769                    AS HANDLE      NO-UNDO.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaults DBOProgram
PROCEDURE getDefaults :
/*------------------------------------------------------------------------------
  Purpose: Retorna a temp-table RowObject com informaá‰es padr‰es de criaá∆o de um
           novo registro
  Parameters: pc-cod-usuar (INPUT - Character): C¢digo do usu†rio
              pi-idi-interfac (INPUT - Integer): Interface
              RowObject (OUTPUT - Temp-table): Registro contendo os valores padr‰es de
                                               criaá∆o de um novo registro.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-usuar    LIKE mla-configur-visual-usuar.cod-usuar    NO-UNDO.
    DEFINE INPUT PARAMETER pi-idi-interfac LIKE mla-configur-visual-usuar.idi-interfac NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    EMPTY TEMP-TABLE RowObject.

    IF NOT CAN-FIND(FIRST bfmla-configur-visual-usuar
                    WHERE bfmla-configur-visual-usuar.cod-usuar    = pc-cod-usuar
                      AND bfmla-configur-visual-usuar.idi-interfac = pi-idi-interfac) THEN DO:

        RUN pi-preenche-labels-log IN THIS-PROCEDURE.

        CREATE RowObject.
        ASSIGN RowObject.cod-usuar                = pc-cod-usuar
               RowObject.idi-interfac             = pi-idi-interfac
               RowObject.idi-ordenacao            = 1
               RowObject.cdn-tempo-desf           = 5
               RowObject.idi-acao-swip-dire       = 1
               RowObject.idi-acao-swip-esq        = 1
               RowObject.idi-visualiz-inicial     = 1
               RowObject.log-aprova-sem-motiv     = NO
               RowObject.log-mostra-todas-empres  = YES
               RowObject.num-registro-paginac     = 50.

        RUN createRecord IN THIS-PROCEDURE.

        IF NOT VALID-HANDLE(h-boin769) THEN
            RUN inbo/boin769.p PERSISTENT SET h-boin769.

        RUN pi-gera-log IN h-boin769(INPUT 27,
                                     INPUT rowObject.r-rowid,
                                     INPUT 1,
                                     INPUT ENTRY(27,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                           c-lbl-usuar + "                     : ":U + string(RowObject.cod-usuar) + CHR(13) +
                                           c-lbl-interface + "                   : ":U + {ininc/i04in01101.i 04 RowObject.idi-interfac} + CHR(13) +
                                           c-lbl-ordenacao-padrao + "      : ":U + {ininc/i01in01101.i 04 RowObject.idi-ordenacao} + CHR(13) +
                                           c-lbl-todas-empresas + "         : ":U + (IF RowObject.log-mostra-todas-empres THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13) +
                                           c-lbl-visualiz-ini + "      : ":U + {ininc/i02in01101.i 04 RowObject.idi-visualiz-inicial} + CHR(13) +
                                           c-lbl-aprov-sem-info-motivo + ": ":U + (IF RowObject.log-aprova-sem-motiv THEN c-lbl-sim ELSE c-lbl-nao)).
        IF VALID-HANDLE(h-boin769) THEN DO:
            DELETE PROCEDURE h-boin769.
            ASSIGN h-boin769 = ?.
        END.
    END.

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
        WHEN "cdn-tempo-desf":U THEN ASSIGN pFieldValue = RowObject.cdn-tempo-desf.
        WHEN "idi-acao-swip-dire":U THEN ASSIGN pFieldValue = RowObject.idi-acao-swip-dire.
        WHEN "idi-acao-swip-esq":U THEN ASSIGN pFieldValue = RowObject.idi-acao-swip-esq.
        WHEN "idi-interfac":U THEN ASSIGN pFieldValue = RowObject.idi-interfac.
        WHEN "idi-ordenacao":U THEN ASSIGN pFieldValue = RowObject.idi-ordenacao.
        WHEN "idi-visualiz-inicial":U THEN ASSIGN pFieldValue = RowObject.idi-visualiz-inicial.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-registro-paginac":U THEN ASSIGN pFieldValue = RowObject.num-registro-paginac.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice mlcnfgrv_id2
  Parameters:
               retorna valor do campo cod-usuar
               retorna valor do campo idi-interfac
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-configur-visual-usuar.cod-usuar NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-interfac LIKE mla-configur-visual-usuar.idi-interfac NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-usuar = RowObject.cod-usuar
           pidi-interfac = RowObject.idi-interfac.

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
        WHEN "log-aprova-sem-motiv":U THEN ASSIGN pFieldValue = RowObject.log-aprova-sem-motiv.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-mostra-todas-empres":U THEN ASSIGN pFieldValue = RowObject.log-mostra-todas-empres.
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
  Purpose:     Reposiciona registro com base no °ndice mlcnfgrv_id2
  Parameters:
               recebe valor do campo cod-usuar
               recebe valor do campo idi-interfac
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-configur-visual-usuar.cod-usuar NO-UNDO.
    DEFINE INPUT PARAMETER pidi-interfac LIKE mla-configur-visual-usuar.idi-interfac NO-UNDO.

    FIND FIRST bfmla-configur-visual-usuar WHERE
        bfmla-configur-visual-usuar.cod-usuar = pcod-usuar AND
        bfmla-configur-visual-usuar.idi-interfac = pidi-interfac NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-configur-visual-usuar THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-configur-visual-usuar)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-substituicao-config-visual DBOProgram
PROCEDURE pi-copia-substituicao-config-visual:
/*------------------------------------------------------------------------------
  Purpose:     Leitura e criaá∆o das temp-tables de configuraá‰es visuais e c¢pia/substituiá∆o dos mesmos.
  Parameters:  /* Input */
               pcDestino         : Usuˇrio origem
               pcOrigem          : Usuˇrio destino
               piOpcao           : Indica qual opá∆o foi selecionada pelo usu†rio --> 'Somente inexistentes'(1), 'Substituir existentes e adicionar inexistentes'(2), 'Substituir tudo'(3)
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-conf-visual-usuar-origem  : ContÇm os dados dos registros (Configuraá‰es visuais) do usu†rio origem
               tt-mla-conf-visual-usuar-dest    : ContÇm os dados dos registros(Configuraá‰es visuais) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcOrigem          LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcDestino         LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM piOpcao           AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-conf-visual-usuar-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-conf-visual-usuar-dest.

    EMPTY TEMP-TABLE tt-mla-conf-visual-usuar-origem.
    EMPTY TEMP-TABLE tt-mla-conf-visual-usuar-dest.

    DEFINE VARIABLE c-log-reg AS CHARACTER   NO-UNDO.


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


    /* Configuraá‰es visuais do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-usuar = pcDestino:

        IF piOpcao = 1 THEN DO: /* Se for somente inexistentes cria tt com os dados atuais e situaá∆o 'mantido' */
            CREATE tt-mla-conf-visual-usuar-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
            ASSIGN tt-mla-conf-visual-usuar-dest.situacao = c-mantido
                   tt-mla-conf-visual-usuar-dest.id-sit   = 1
                   tt-mla-conf-visual-usuar-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
        ELSE IF piOpcao = 2 THEN DO: /* Se for inexistentes e substituir existentes */
            FIND FIRST mla-configur-visual-usuar NO-LOCK
                 WHERE mla-configur-visual-usuar.cod-usuar    = pcOrigem
                   AND mla-configur-visual-usuar.idi-interfac = bf{&TableName}.idi-interfac NO-ERROR.

            IF AVAIL mla-configur-visual-usuar THEN DO:

                CREATE tt-mla-conf-visual-usuar-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
                ASSIGN tt-mla-conf-visual-usuar-dest.situacao                = c-substituido
                       tt-mla-conf-visual-usuar-dest.id-sit                  = 3
                       tt-mla-conf-visual-usuar-dest.idi-interfac            = mla-configur-visual-usuar.idi-interfac
                       tt-mla-conf-visual-usuar-dest.idi-ordenacao           = mla-configur-visual-usuar.idi-ordenacao
                       tt-mla-conf-visual-usuar-dest.num-registro-paginac    = mla-configur-visual-usuar.num-registro-paginac
                       tt-mla-conf-visual-usuar-dest.log-mostra-todas-empres = mla-configur-visual-usuar.log-mostra-todas-empres
                       tt-mla-conf-visual-usuar-dest.idi-visualiz-inicial    = mla-configur-visual-usuar.idi-visualiz-inicial
                       tt-mla-conf-visual-usuar-dest.log-aprova-sem-motiv    = mla-configur-visual-usuar.log-aprova-sem-motiv
                       tt-mla-conf-visual-usuar-dest.idi-acao-swip-dire      = mla-configur-visual-usuar.idi-acao-swip-dire
                       tt-mla-conf-visual-usuar-dest.idi-acao-swip-esq       = mla-configur-visual-usuar.idi-acao-swip-esq
                       tt-mla-conf-visual-usuar-dest.cdn-tempo-desf          = mla-configur-visual-usuar.cdn-tempo-desf
                       tt-mla-conf-visual-usuar-dest.r-rowid                 = ROWID(bf{&TableName}).
            END.
            ELSE DO:
                CREATE tt-mla-conf-visual-usuar-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
                ASSIGN tt-mla-conf-visual-usuar-dest.situacao = c-mantido
                       tt-mla-conf-visual-usuar-dest.id-sit   = 1
                       tt-mla-conf-visual-usuar-dest.r-rowid  = ROWID(bf{&TableName}).
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-conf-visual-usuar-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
            ASSIGN tt-mla-conf-visual-usuar-dest.situacao = c-eliminado
                   tt-mla-conf-visual-usuar-dest.id-sit   = 4
                   tt-mla-conf-visual-usuar-dest.r-rowid  = ROWID(bf{&TableName}).
        END.
    END.

    /* Configuraá‰es visuais do usu†rio origem e criaá∆o dos inexistentes do usu†rio destino */
    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-usuar = pcOrigem:

        CREATE tt-mla-conf-visual-usuar-origem.
        BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-origem.
        ASSIGN tt-mla-conf-visual-usuar-origem.situacao  = c-origem
               tt-mla-conf-visual-usuar-origem.id-sit    = 5
               tt-mla-conf-visual-usuar-origem.r-rowid   = ROWID(bf{&TableName}).

        IF piOpcao = 1 OR piOpcao = 2 THEN DO:
            IF NOT CAN-FIND(mla-configur-visual-usuar
                            WHERE mla-configur-visual-usuar.idi-interfac = bf{&TableName}.idi-interfac
                              AND mla-configur-visual-usuar.cod-usuar    = pcDestino) THEN DO:

                CREATE tt-mla-conf-visual-usuar-dest.
                BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
                ASSIGN tt-mla-conf-visual-usuar-dest.situacao  = c-novo
                       tt-mla-conf-visual-usuar-dest.id-sit    = 2
                       tt-mla-conf-visual-usuar-dest.r-rowid   = ROWID(bf{&TableName})
                       tt-mla-conf-visual-usuar-dest.cod-usuar = pcDestino.
            END.
        END.
        ELSE IF piOpcao = 3 THEN DO:
            CREATE tt-mla-conf-visual-usuar-dest.
            BUFFER-COPY bf{&TableName} TO tt-mla-conf-visual-usuar-dest.
            ASSIGN tt-mla-conf-visual-usuar-dest.situacao  = c-novo
                   tt-mla-conf-visual-usuar-dest.id-sit    = 2
                   tt-mla-conf-visual-usuar-dest.r-rowid   = ROWID(bf{&TableName})
                   tt-mla-conf-visual-usuar-dest.cod-usuar = pcDestino.
        END.
    END.

    RUN pi-preenche-labels-log IN THIS-PROCEDURE.

    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).

    IF NOT plSimulaAlteracao THEN DO:
        FOR EACH tt-mla-conf-visual-usuar-dest:
            do transaction:
                IF tt-mla-conf-visual-usuar-dest.id-sit = 4 OR tt-mla-conf-visual-usuar-dest.id-sit = 3 THEN DO: /* Exclus∆o ou ediá∆o */
                    find first mla-configur-visual-usuar exclusive-lock where
                         rowid(mla-configur-visual-usuar) = tt-mla-conf-visual-usuar-dest.r-rowid no-error.
                    if not avail mla-configur-visual-usuar then next.
                END.
                CASE tt-mla-conf-visual-usuar-dest.id-sit:
                    WHEN 4 THEN DO:
                        RUN pi-gera-log IN h-boin769(INPUT 27,
                                                    INPUT rowid(mla-configur-visual-usuar),
                                                    INPUT 3,
                                                    INPUT ENTRY(27,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar + "                : ":U + string(mla-configur-visual-usuar.cod-usuar) + chr(13) +
                                                        c-lbl-interface + "            : ":U + {ininc/i04in01101.i 04 mla-configur-visual-usuar.idi-interfac} + chr(13) +
                                                        c-lbl-ordenacao-padrao + "     : ":U + {ininc/i01in01101.i 04 mla-configur-visual-usuar.idi-ordenacao} + chr(13) +
                                                        c-lbl-todas-empresas + "       : ":U + (IF mla-configur-visual-usuar.log-mostra-todas-empres THEN c-lbl-sim ELSE c-lbl-nao) + chr(13) +
                                                        c-lbl-visualiz-ini + "         : ":U + {ininc/i02in01101.i 04 mla-configur-visual-usuar.idi-visualiz-inicial} + chr(13) +
                                                        c-lbl-aprov-sem-info-motivo + ": ":U + (IF mla-configur-visual-usuar.log-aprova-sem-motiv THEN c-lbl-sim ELSE c-lbl-nao)).
                        delete mla-configur-visual-usuar.
                    END.
                    WHEN 2 THEN DO:
                        CREATE mla-configur-visual-usuar.
                        BUFFER-COPY tt-mla-conf-visual-usuar-dest EXCEPT tt-mla-conf-visual-usuar-dest.situacao
                                                                         tt-mla-conf-visual-usuar-dest.r-rowid TO mla-configur-visual-usuar.
                        RUN pi-gera-log IN h-boin769(INPUT 27,
                                                    INPUT rowid(mla-configur-visual-usuar),
                                                    INPUT 1,
                                                    INPUT ENTRY(27,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                        c-lbl-usuar + "                     : ":U + string(tt-mla-conf-visual-usuar-dest.cod-usuar) + CHR(13) +
                                                        c-lbl-interface + "                   : ":U + {ininc/i04in01101.i 04 tt-mla-conf-visual-usuar-dest.idi-interfac} + CHR(13) +
                                                        c-lbl-ordenacao-padrao + "      : ":U + {ininc/i01in01101.i 04 tt-mla-conf-visual-usuar-dest.idi-ordenacao} + CHR(13) +
                                                        c-lbl-todas-empresas + "         : ":U + (IF tt-mla-conf-visual-usuar-dest.log-mostra-todas-empres THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13) +
                                                        c-lbl-visualiz-ini + "      : ":U + {ininc/i02in01101.i 04 tt-mla-conf-visual-usuar-dest.idi-visualiz-inicial} + CHR(13) +
                                                        c-lbl-aprov-sem-info-motivo + ": ":U + (IF tt-mla-conf-visual-usuar-dest.log-aprova-sem-motiv THEN c-lbl-sim ELSE c-lbl-nao)).
                        release mla-configur-visual-usuar.
                    END.
                    WHEN 3 THEN DO:
                        IF mla-configur-visual-usuar.idi-ordenacao <> tt-mla-conf-visual-usuar-dest.idi-ordenacao THEN
                            ASSIGN c-log-reg = c-log-reg + c-lbl-ordenacao-padrao + "      : ":U + {ininc/i01in01101.i 04 mla-configur-visual-usuar.idi-ordenacao} + CHR(13) +
                                                        "                                : ":U + {ininc/i01in01101.i 04 tt-mla-conf-visual-usuar-dest.idi-ordenacao}  + CHR(13).

                        IF mla-configur-visual-usuar.log-mostra-todas-empres <> tt-mla-conf-visual-usuar-dest.log-mostra-todas-empres THEN
                            ASSIGN c-log-reg = c-log-reg + c-lbl-todas-empresas + "         : ":U + (IF mla-configur-visual-usuar.log-mostra-todas-empres THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13) +
                                                        "                                : ":U + (IF tt-mla-conf-visual-usuar-dest.log-mostra-todas-empres THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13).

                        IF mla-configur-visual-usuar.idi-visualiz-inicial <> tt-mla-conf-visual-usuar-dest.idi-visualiz-inicial THEN
                            ASSIGN c-log-reg = c-log-reg + c-lbl-visualiz-ini + "      : ":U + {ininc/i02in01101.i 04 mla-configur-visual-usuar.idi-visualiz-inicial} + CHR(13) +
                                                        "                                 : ":U + {ininc/i02in01101.i 04 tt-mla-conf-visual-usuar-dest.idi-visualiz-inicial} + CHR(13).

                        IF mla-configur-visual-usuar.log-aprova-sem-motiv <> tt-mla-conf-visual-usuar-dest.log-aprova-sem-motiv THEN
                            ASSIGN c-log-reg = c-log-reg + c-lbl-aprov-sem-info-motivo + ": ":U + (IF mla-configur-visual-usuar.log-aprova-sem-motiv THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13) +
                                                        "                                               : ":U + (IF tt-mla-conf-visual-usuar-dest.log-aprova-sem-motiv THEN c-lbl-sim ELSE c-lbl-nao) + CHR(13).
                        IF c-log-reg <> "" THEN DO:
                            RUN pi-gera-log IN h-boin769(INPUT 27,
                                                        INPUT rowid(mla-configur-visual-usuar),
                                                        INPUT 2,
                                                        INPUT ENTRY(27,{ininc/i03in030.i 03}) + chr(13) + chr(13) + c-log-reg).
                        END.
                        ASSIGN mla-configur-visual-usuar.idi-ordenacao           = tt-mla-conf-visual-usuar-dest.idi-ordenacao
                               mla-configur-visual-usuar.log-mostra-todas-empres = tt-mla-conf-visual-usuar-dest.log-mostra-todas-empres
                               mla-configur-visual-usuar.idi-visualiz-inicial    = tt-mla-conf-visual-usuar-dest.idi-visualiz-inicial
                               mla-configur-visual-usuar.log-aprova-sem-motiv    = tt-mla-conf-visual-usuar-dest.log-aprova-sem-motiv.
                        release mla-configur-visual-usuar.
                    END.
                END CASE.
            end.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-labels-log DBOProgram
PROCEDURE pi-preenche-labels-log :
/*:T------------------------------------------------------------------------------
  Purpose:     Preenche labels utilizados em logs de alteraá∆o de registro
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Sim" * R}
    ASSIGN c-lbl-sim = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "N∆o" * R}
    ASSIGN c-lbl-nao = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Interface" * R}
    ASSIGN c-lbl-interface = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Ordenaá∆o_padr∆o" * R}
    ASSIGN c-lbl-ordenacao-padrao = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Todas_empresas" * R}
    ASSIGN c-lbl-todas-empresas = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Aprovaá∆o_sem_informar_motivo" * R}
    ASSIGN c-lbl-aprov-sem-info-motivo = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Visualizaá∆o_inicial" * R}
    ASSIGN c-lbl-visualiz-ini = TRIM(RETURN-VALUE).

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

    DEFINE VARIABLE c-aprovador  AS CHARACTER   NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF pType = "Create":U THEN DO:
            FIND FIRST {&TableName} NO-LOCK
                 WHERE {&TableName}.cod-usuar    = RowObject.cod-usuar
                   AND {&TableName}.idi-interfac = RowObject.idi-interfac NO-ERROR.

            IF AVAIL {&TableName} THEN DO:
                {utp/ut-liter.i "Configuraá∆o_Visual" *}

                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
        END.

        /* Validaá∆o de usu†rio */
        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-ERROR.

        IF NOT AVAIL mla-usuar-aprov THEN DO:
            {utp/ut-liter.i "Usu†rio" *}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.
        ELSE DO:
            IF NOT mla-usuar-aprov.perm-aprov THEN DO:
                {utp/ut-liter.i "Aprovador" *}
                ASSIGN c-aprovador = RETURN-VALUE.
                {utp/ut-liter.i "Usu†rio_informado" *}
                {method/svc/errors/inserr.i &ErrorNumber="17195"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value + '~~~~' + c-aprovador"}
            END.
        END.

        /* Validaá∆o de interface */
        IF RowObject.idi-interfac < 1 OR
           RowObject.idi-interfac > 2 THEN DO:
            {utp/ut-liter.i "Tipo_de_Interface" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o de ordenaá∆o padr∆o */
        IF RowObject.idi-ordenacao < 1 OR
           RowObject.idi-ordenacao > 7 THEN DO:
            {utp/ut-liter.i "Ordenaá∆o_Padr∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o de visualizaá∆o inicial */
        IF RowObject.idi-visualiz-inicial < 1 OR
           RowObject.idi-visualiz-inicial > 4 THEN DO:
            {utp/ut-liter.i "Visualizaá∆o_inicial" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o da aá∆o de swipe para direita */
        IF RowObject.idi-acao-swip-dire < 1 OR
           RowObject.idi-acao-swip-dire > 3 THEN DO:
            {utp/ut-liter.i "Aá∆o_swipe_direita" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o da aá∆o de swipe para esquerda */
        IF RowObject.idi-acao-swip-esq < 1 OR
           RowObject.idi-acao-swip-esq > 3 THEN DO:
            {utp/ut-liter.i "Aá∆o_swipe_esquerda" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o tempo desfazer */
        IF RowObject.cdn-tempo-desf < 0 THEN DO:
            {utp/ut-liter.i "Tempo_desfazer" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        /* Validaá∆o de n£mero de registros de paginaá∆o */
        IF RowObject.num-registro-paginac < 0 THEN DO:
            {utp/ut-liter.i "N£mero_registro_paginaá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

