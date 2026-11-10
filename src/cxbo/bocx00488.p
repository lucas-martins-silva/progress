&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*:T---------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOCX00488 1.00.00.009} /*** "010009" 16/09/2026 15:58:58 ***/
/* ***************************  Definitions  **************************** */


/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00488
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName duimp-item
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}

{utp/ut-glob.i} /*Definiá∆o de vari†veis globais do sistema*/

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
{cxbo/bocx00488.i RowObject}
{cxbo/bocx00488.i tt-duimp-item-faixa}
{cxbo/bocx00488.i tt-duimp-item-aux}
{cxbo/bocx00488.i tt-duimp-item-create}
{cxbo/bocx220.i tt-embarque-imp}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}
{cxbo/bocx00488.i1} /* tt-param-exec */
/*TT com as ordens a serem vinculadas a DUIMP*/
{imp/im0091.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER bf-ordem-compra FOR ordem-compra.
DEFINE BUFFER bf-historico-embarque FOR historico-embarque.

DEFINE variable de-cod-duimp-dts          LIKE duimp-docto.cod-duimp-dts NO-UNDO.
DEFINE variable c-cod-estabel-ini         LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE variable c-cod-estabel-fim         LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE variable i-numero-ordem-ini        LIKE duimp-item.numero-ordem NO-UNDO.
DEFINE variable i-numero-ordem-fim        LIKE duimp-item.numero-ordem NO-UNDO.
DEFINE variable i-cod-emitente-ini        LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE variable i-cod-emitente-fim        LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE variable c-nome-abrev-ini          LIKE emitente.nome-abrev NO-UNDO.
DEFINE variable c-nome-abrev-fim          LIKE emitente.nome-abrev NO-UNDO.
DEFINE variable c-embarque-ini            LIKE duimp-item.embarque NO-UNDO.
DEFINE variable c-embarque-fim            LIKE duimp-item.embarque NO-UNDO.
DEFINE VARIABLE iRowsReturned             AS INTEGER NO-UNDO.
DEFINE VARIABLE c-return                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-return2                 AS CHARACTER NO-UNDO.


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
        WHEN "cdn-exporta":U THEN ASSIGN pFieldValue = RowObject.cdn-exporta.
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "cod-di-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-di-siscomex.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-pais-iso-exporta":U THEN ASSIGN pFieldValue = RowObject.cod-pais-iso-exporta.
        WHEN "cod-pais-iso-fabric":U THEN ASSIGN pFieldValue = RowObject.cod-pais-iso-fabric.
        WHEN "compl-incoterm":U THEN ASSIGN pFieldValue = RowObject.compl-incoterm.
        WHEN "desc-comp":U THEN ASSIGN pFieldValue = RowObject.desc-comp.
        WHEN "embarque":U THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "incoterm":U THEN ASSIGN pFieldValue = RowObject.incoterm.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "ni-oper-exporta":U THEN ASSIGN pFieldValue = RowObject.ni-oper-exporta.
        WHEN "ni-oper-fabric":U THEN ASSIGN pFieldValue = RowObject.ni-oper-fabric.
        WHEN "ni-responsavel":U THEN ASSIGN pFieldValue = RowObject.ni-responsavel.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "num-identific":U THEN ASSIGN pFieldValue = RowObject.num-identific.
        WHEN "numero-rof":U THEN ASSIGN pFieldValue = RowObject.numero-rof.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "unid-com":U THEN ASSIGN pFieldValue = RowObject.unid-com.
        WHEN "versao-exporta":U THEN ASSIGN pFieldValue = RowObject.versao-exporta.
        WHEN "versao-fabric":U THEN ASSIGN pFieldValue = RowObject.versao-fabric.
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
        WHEN "cod-duimp-dts":U THEN ASSIGN pFieldValue = RowObject.cod-duimp-dts.
        WHEN "peso-liq":U THEN ASSIGN pFieldValue = RowObject.peso-liq.
        WHEN "qtd-com":U THEN ASSIGN pFieldValue = RowObject.qtd-com.
        WHEN "qtd-med":U THEN ASSIGN pFieldValue = RowObject.qtd-med.
        WHEN "val-cob-camb":U THEN ASSIGN pFieldValue = RowObject.val-cob-camb.
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-seguro":U THEN ASSIGN pFieldValue = RowObject.val-seguro.
        WHEN "vlr-frete-moeda":U THEN ASSIGN pFieldValue = RowObject.vlr-frete-moeda.
        WHEN "vlr-seguro-moeda":U THEN ASSIGN pFieldValue = RowObject.vlr-seguro-moeda.
        WHEN "vlr-unit-mo":U THEN ASSIGN pFieldValue = RowObject.vlr-unit-mo.
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
        WHEN "aplicacao":U THEN ASSIGN pFieldValue = RowObject.aplicacao.
        WHEN "caract-import":U THEN ASSIGN pFieldValue = RowObject.caract-import.
        WHEN "cobertura-camb":U THEN ASSIGN pFieldValue = RowObject.cobertura-camb.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-institut-finan":U THEN ASSIGN pFieldValue = RowObject.cod-institut-finan.
        WHEN "cod-met-valora":U THEN ASSIGN pFieldValue = RowObject.cod-met-valora.
        WHEN "cod-mot-sem-cob":U THEN ASSIGN pFieldValue = RowObject.cod-mot-sem-cob.
        WHEN "condicao":U THEN ASSIGN pFieldValue = RowObject.condicao.
        WHEN "idi-ind-vincul":U THEN ASSIGN pFieldValue = RowObject.idi-ind-vincul.
        WHEN "ind-export-fabric":U THEN ASSIGN pFieldValue = RowObject.ind-export-fabric.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "versao":U THEN ASSIGN pFieldValue = RowObject.versao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id1-chave
  Parameters:
               retorna valor do campo cod-duimp-dts
               retorna valor do campo cod-item
               retorna valor do campo seq-item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-duimp-dts LIKE duimp-item.cod-duimp-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item LIKE duimp-item.cod-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE duimp-item.seq-item NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-duimp-dts = RowObject.cod-duimp-dts
           pcod-item = RowObject.cod-item
           pseq-item = RowObject.seq-item.

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
  Purpose:     Reposiciona registro com base no °ndice id1-chave
  Parameters:
               recebe valor do campo cod-duimp-dts
               recebe valor do campo cod-item
               recebe valor do campo seq-item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts LIKE duimp-item.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item LIKE duimp-item.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE duimp-item.seq-item NO-UNDO.

    FIND FIRST bfduimp-item WHERE
        bfduimp-item.cod-duimp-dts = pcod-duimp-dts AND
        bfduimp-item.cod-item = pcod-item AND
        bfduimp-item.seq-item = pseq-item NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfduimp-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfduimp-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEmbarqueDuimp DBOProgram
PROCEDURE piValidaEmbarqueDuimp :
/*------------------------------------------------------------------------------
  Purpose: Verfica se o embarque esta vinculado com a DUIMP.
  Parameters:  INPUT - pc-cod-estabel     (character) - codigo do estabelecimento
               INPUT - pc-embarque        (character) - codigo do embarque
               OUTPUT - pde-cod-duimp-dts (decimal)   - duimp-item.cod-duimp-dts
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel    LIKE duimp-item.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque       LIKE duimp-item.embarque      NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-cod-duimp-dts LIKE duimp-item.cod-duimp-dts NO-UNDO.

    FOR FIRST duimp-item WHERE duimp-item.cod-estabel = pc-cod-estabel
                         AND   duimp-item.embarque    = pc-embarque
                         NO-LOCK:
        ASSIGN pde-cod-duimp-dts = duimp-item.cod-duimp-dts.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaNFDuimp DBOProgram
PROCEDURE piRetornaNFDuimp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-numero-ordem   LIKE decla-import-ord.num-ordem   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-parcela        LIKE decla-import-ord.num-parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-serie-docto    LIKE duimp-item.serie-docto       NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-nro-docto      LIKE duimp-item.nro-docto         NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-nat-operacao   LIKE duimp-item.nat-operacao      NO-UNDO.

    for first ordem-compra no-lock
        where ordem-compra.numero-ordem = int(pc-numero-ordem):
    end.

    FOR FIRST item-doc-est
        WHERE item-doc-est.num-pedido   = ordem-compra.num-pedido
          AND item-doc-est.numero-ordem = int(pc-numero-ordem)
          AND item-doc-est.parcela      = int(pc-parcela) NO-LOCK:
        ASSIGN pc-serie-docto  = item-doc-est.serie-docto
               pc-nro-docto    = item-doc-est.nro-docto
               pc-nat-operacao = item-doc-est.nat-operacao.
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

    /* Adquirente */
    IF  pType = "CREATE":U THEN DO:

        /* Validar se o estabelecimento da DUIMP Ç o mesmo do embarque que est† sendo vinculado */
        FIND FIRST duimp-siscomex
            WHERE duimp-siscomex.cod-duimp-dts = rowobject.cod-duimp-dts NO-LOCK NO-ERROR.
        IF  AVAIL duimp-siscomex
        AND duimp-siscomex.cod-estabel <> rowobject.cod-estabel THEN DO:
            {utp/ut-liter.i Estabelecimento_do_embarque_selecionado *}
            ASSIGN c-return = RETURN-VALUE.
            {utp/ut-liter.i igual_ao_estabelecimento_da_DUIMP *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="17167"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-return + '~~~~' + return-value"}
        END.

        /*Verificar se o embarques est† vincualdo a uma DUIMP*/
        FIND FIRST bf{&TableName} NO-LOCK
             WHERE bf{&TableName}.embarque = ordens-embarque.embarque
             AND   bf{&TableName}.cod-duimp-dts <> rowobject.cod-duimp-dts NO-ERROR.
        IF AVAIL bf{&TableName} THEN DO:
            {utp/ut-liter.i Vinculaá∆o_do_embarque *}
            ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque) + " ":U.
            {utp/ut-liter.i Embarque_est†_vincuado_Ö_DUIMP *}
            ASSIGN c-return2 = RETURN-VALUE + " ":U + STRING(bf{&TableName}.cod-duimp-dts).
            {method/svc/errors/inserr.i
                    &ErrorNumber="57175"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-return + '~~~~' + c-return2"}
        END.

        /* Verificar se a moeda Ç igual ao dos embarques vinculados Ö DUIMP */
        FIND FIRST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.cod-duimp-dts = rowobject.cod-duimp-dts NO-ERROR.
        IF  AVAIL bf{&TableName} THEN DO:

            IF  bf{&TableName}.mo-codigo <> rowObject.mo-codigo THEN DO:

                {utp/ut-liter.i Vinculaá∆o_do_embarque *}
                ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque) + " ":U.
                {utp/ut-liter.i Moeda_difere_dos_embarques_j†_vinculados. *}
                ASSIGN c-return2 = RETURN-VALUE.
                {utp/ut-liter.i Ordem_de_compra: *}
                ASSIGN c-return2 = c-return2 + " (":U + RETURN-VALUE + " ":U + string(rowobject.numero-ordem,"zzzzz9,99":U) + ")":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="57175"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-return + '~~~~' + c-return2"}
            END.

            /* Verificar se a Incoterm Ç igual ao dos embarques vinculados Ö DUIMP */
            IF  bf{&TableName}.incoterm <> rowObject.incoterm THEN DO:
                {utp/ut-liter.i Vinculaá∆o_do_embarque *}
                ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque) + " ":U.
                {utp/ut-liter.i Incoterm_difere_dos_embarques_j†_vinculados. *}
                ASSIGN c-return2 = RETURN-VALUE.
                {utp/ut-liter.i Ordem_de_compra: *}
                ASSIGN c-return2 = c-return2 + " (":U + RETURN-VALUE + " ":U + string(rowobject.numero-ordem,"zzzzz9,99":U) + ")":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="57175"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-return + '~~~~' + c-return2"}
            END.
        END.

        FOR FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.embarque = rowobject.embarque:

            /* Verificar se o Embarque est† encerrado */
            IF embarque-imp.situacao = 2 then do:
            {utp/ut-liter.i Embarque *}
            ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque).
            {utp/ut-liter.i que_seja_vinculado_Ö_DUIMP. *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="57936"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-return + '~~~~' + return-value"}
            end.

            FOR FIRST ordens-embarque NO-LOCK
                where ordens-embarque.embarque     = rowobject.embarque
                and   ordens-embarque.cod-estabel  = rowobject.cod-estabel
                and   ordens-embarque.numero-ordem = rowobject.numero-ordem:
                /* Verificar se o Processo de importaá∆o est† encerrado */
                IF CAN-FIND(FIRST processo-imp NO-LOCK
                            WHERE processo-imp.cod-estabel = ordens-embarque.cod-estabel
                            AND   processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp
                            AND   processo-imp.situacao    = 4) THEN do:
                    {utp/ut-liter.i Processo_de_importaá∆o_do_embarque *}
                    ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque).
                    {utp/ut-liter.i vincular_o_embarque_Ö_DUIMP. *}
                    ASSIGN c-return2 = RETURN-VALUE.
                    {utp/ut-liter.i Ordem_de_compra: *}
                    ASSIGN c-return2 = c-return2 + "(":U + RETURN-VALUE + " ":U + string(rowobject.numero-ordem,"zzzzz9,99":U) + ")":U.
                    {method/svc/errors/inserr.i
                            &ErrorNumber="57936"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-return + '~~~~' + c-return2"}
                end.
            end.

            /* Verificar se o embarque possui nota emitida */
            IF CAN-FIND(FIRST embarq-import-docto NO-LOCK
                        WHERE embarq-import-docto.cod-estab  = rowobject.cod-estabel
                        AND   embarq-import-docto.cod-embarq = rowobject.embarque) then do:
                {utp/ut-liter.i Vinculaá∆o_do_embarque *}
                ASSIGN c-return = RETURN-VALUE + " ":U + STRING(rowobject.embarque) + " ":U.
                {utp/ut-liter.i Embarque_est†_associado_a_uma_Nota_Fiscal *}
                ASSIGN c-return2 = RETURN-VALUE.
                {utp/ut-liter.i Ordem_de_compra: *}
                ASSIGN c-return2 = c-return2 + "(":U + RETURN-VALUE + " ":U + string(rowobject.numero-ordem,"zzzzz9,99":U) + ")":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="57175"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-return + '~~~~' + c-return2"}
            end.
        end.
    END.

    /* Adquirente */
    IF RowObject.caract-import <> 1 THEN DO:
        IF RowObject.num-identific = ""
        OR RowObject.num-identific = "0" THEN DO:
            {utp/ut-liter.i Adquirente *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE
            IF NOT CAN-FIND(FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = INT(RowObject.num-identific)
                            AND   emitente.identific   <> 1 /* Cliente */) THEN DO:
                {utp/ut-liter.i Adquirente *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
    END.

    /* Metodo Valoraá∆o */
    IF RowObject.cod-met-valora <> 0 THEN DO:
        IF NOT CAN-FIND(FIRST siscomex-metodo-val NO-LOCK
                        WHERE siscomex-metodo-val.cod-met-val = RowObject.cod-met-valora) THEN DO:
            {utp/ut-liter.i MÇtodo_Valoraá∆o *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /* Motivo Ausància Cobertura Cambial */
    IF RowObject.cod-mot-sem-cob <> 0 THEN DO:
        IF NOT CAN-FIND(FIRST siscomex-motivo-sem-cob NO-LOCK
                        WHERE siscomex-motivo-sem-cob.codigo = RowObject.cod-mot-sem-cob) THEN DO:
            {utp/ut-liter.i Motivo_Ausància_Cobertura_Cambial *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /* Instituiá∆o Financiadora*/
    IF RowObject.cod-institut-finan <> 0 THEN DO:
        IF NOT CAN-FIND(FIRST siscomex-inst-financ NO-LOCK
                        WHERE siscomex-inst-financ.codigo = RowObject.cod-institut-finan) THEN DO:
            {utp/ut-liter.i Instituiá∆o_Financiadora *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FOR FIRST duimp-siscomex EXCLUSIVE-LOCK
        WHERE duimp-siscomex.cod-duimp-dts = rowObject.cod-duimp-dts:
        ASSIGN duimp-siscomex.vlr-tot-frete  = duimp-siscomex.vlr-tot-frete  + rowObject.val-frete
               duimp-siscomex.vlr-tot-seguro = duimp-siscomex.vlr-tot-seguro + rowObject.val-seguro.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  AVAIL RowObject THEN DO:
        FOR FIRST duimp-siscomex EXCLUSIVE-LOCK
            WHERE duimp-siscomex.cod-duimp-dts = rowObject.cod-duimp-dts:
            ASSIGN duimp-siscomex.vlr-tot-frete  = duimp-siscomex.vlr-tot-frete  - rowObject.val-frete
                   duimp-siscomex.vlr-tot-seguro = duimp-siscomex.vlr-tot-seguro - rowObject.val-seguro.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDuimp DBOProgram
PROCEDURE openQueryByDuimp :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.cod-duimp-dts = de-cod-duimp-dts NO-LOCK
                                  BY {&TABLENAME}.cod-duimp-dts
                                  BY {&TABLENAME}.seq-item INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyDuimp DBOProgram
PROCEDURE setConstraintbyDuimp :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "Duimp"
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts NO-UNDO.

    ASSIGN de-cod-duimp-dts = p-cod-duimp-dts.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaOrdensVincular DBOProgram
PROCEDURE piBuscaOrdensVincular :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-param-exec.
    DEFINE INPUT PARAMETER p-cod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embarque-imp.

    EMPTY TEMP-TABLE tt-embarque-imp NO-ERROR.

    FIND FIRST duimp-siscomex
        WHERE duimp-siscomex.cod-duimp-dts = p-cod-duimp-dts NO-LOCK NO-ERROR.

    FIND FIRST tt-param-exec NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-param-exec THEN RETURN "NOK":U.

    FOR EACH estabelec NO-LOCK
        WHERE estabelec.cod-estabel >= tt-param-exec.cod-estabel-ini
          AND estabelec.cod-estabel <= tt-param-exec.cod-estabel-fim:

        blk_embarque:
        FOR each embarque-imp no-lock
            where embarque-imp.cod-estabel  = estabelec.cod-estabel
            and   embarque-imp.embarque     >= tt-param-exec.embarque-ini
            and   embarque-imp.embarque     <= tt-param-exec.embarque-fim
            AND   embarque-imp.int-2         = 0
            AND   embarque-imp.data-DI       = ?
            AND   embarque-imp.situacao      = 1:


            /* Desconsiderar embarques que possuem nota */
            IF CAN-FIND(FIRST embarq-import-docto NO-LOCK
                        WHERE embarq-import-docto.cod-estab  = embarque-imp.cod-estabel
                        AND   embarq-import-docto.cod-embarq = embarque-imp.embarque) THEN DO:
                            NEXT.
                        END.

            IF CAN-FIND(FIRST tt-embarque-imp
                            WHERE tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                            AND   tt-embarque-imp.embarque    = embarque-imp.embarque) THEN
                    NEXT blk_embarque.

            FOR each ordens-embarque no-lock
                where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                and   ordens-embarque.embarque    = embarque-imp.embarque,
                first ordem-compra no-lock
                where ordem-compra.numero-ordem   = ordens-embarque.numero-ordem:


                 if ordem-compra.num-pedido < tt-param-exec.num-pedido-ini
                 or ordem-compra.num-pedido > tt-param-exec.num-pedido-fim then next.

                /*Desconsidera ordens de compra com fornecedor diferente de um item j† vinculado a DUIMP*/
                 IF  CAN-FIND(FIRST bf{&TableName} NO-LOCK
                              WHERE bf{&TableName}.cod-duimp-dts = p-cod-duimp-dts
                              AND   bf{&TableName}.cod-emitente <> ordem-compra.cod-emitente) THEN DO:
                                    NEXT.
                              END.


                /*Desconsidera ordens de compra vinculadas a uma DUIMP*/
                IF  CAN-FIND(FIRST bf{&TableName}
                             WHERE bf{&TableName}.numero-ordem = ordens-embarque.numero-ordem
                             AND   bf{&TableName}.embarque     = ordens-embarque.embarque) THEN DO:
                                    NEXT.
                             END.


                /* Processo de importaá∆o n∆o pode estar encerrado */
                IF CAN-FIND(FIRST processo-imp NO-LOCK
                            WHERE processo-imp.cod-estabel = ordens-embarque.cod-estabel
                            AND   processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp
                            AND   processo-imp.situacao    = 4) THEN DO:
                                NEXT.
                            END.

                find first emitente no-lock
                    where emitente.cod-emitente = ordem-compra.cod-emitente no-error.
                IF NOT AVAIL emitente THEN DO:
                    NEXT.
                END.

    /*             if ordem-compra.cod-emitente < tt-param-exec.cod-emitente-ini            */
    /*             or ordem-compra.cod-emitente > tt-param-exec.cod-emitente-fim then next. */

    /*             if emitente.nome-abrev < tt-param-exec.nome-abrev-ini          */
    /*             or emitente.nome-abrev > tt-param-exec.nome-abrev-fim then DO: */
    /*                 next.                                                      */
    /*             END.                                                           */

                IF NOT CAN-FIND(FIRST tt-embarque-imp NO-LOCK
                                WHERE tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                                AND   tt-embarque-imp.embarque    = embarque-imp.embarque)then do:

                    CREATE tt-embarque-imp.
                    BUFFER-COPY embarque-imp TO tt-embarque-imp.
                END.
            end.
        end.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaOrdensVinculadas DBOProgram
PROCEDURE piBuscaOrdensVinculadas :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-param-exec.
    DEFINE INPUT PARAMETER pl-filtro-vincul AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-duimp-item-aux.

    EMPTY TEMP-TABLE tt-duimp-item-aux NO-ERROR.

    RUN setConstraintByDuimp (INPUT p-cod-duimp-dts).
    RUN openQueryStatic (INPUT "ByDuimp":U) NO-ERROR.
    RUN getBatchRecords (INPUT ?,
                         INPUT ?,
                         INPUT 99999,
                         OUTPUT iRowsReturned,
                         OUTPUT TABLE tt-duimp-item-faixa).

    FIND FIRST tt-param-exec NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-param-exec THEN RETURN "NOK":U.

    IF pl-filtro-vincul THEN DO:
        FOR EACH tt-duimp-item-faixa NO-LOCK
            WHERE tt-duimp-item-faixa.cod-estabel  >= tt-param-exec.cod-estabel-ini
            AND   tt-duimp-item-faixa.cod-estabel  <= tt-param-exec.cod-estabel-fim
            AND   tt-duimp-item-faixa.embarque     >= tt-param-exec.embarque-ini
            AND   tt-duimp-item-faixa.embarque     <= tt-param-exec.embarque-fim
            /*AND   tt-duimp-item-faixa.cod-emitente >= tt-param-exec.cod-emitente-ini
            AND   tt-duimp-item-faixa.cod-emitente <= tt-param-exec.cod-emitente-fim*/:

            find first emitente no-lock
                where emitente.cod-emitente = tt-duimp-item-faixa.cod-emitente no-error.
            IF NOT AVAIL emitente THEN NEXT.

/*             if emitente.nome-abrev < tt-param-exec.nome-abrev-ini            */
/*             or emitente.nome-abrev > tt-param-exec.nome-abrev-fim then next. */

            CREATE tt-duimp-item-aux.
            BUFFER-COPY tt-duimp-item-faixa TO tt-duimp-item-aux.
        END.
    END.
    ELSE DO:
        FOR EACH tt-duimp-item-faixa NO-LOCK:
            CREATE tt-duimp-item-aux.
            BUFFER-COPY tt-duimp-item-faixa TO tt-duimp-item-aux.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecDespEmbarque DBOProgram
PROCEDURE piSelecDespEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Busca as despesas do embarque
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts  LIKE duimp-item.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE duimp-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque     LIKE duimp-item.embarque NO-UNDO.

    DEFINE VARIABLE h-im0091 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-im0091) THEN
        run imp/im0091.p persistent set h-im0091.

    EMPTY TEMP-TABLE tt-desp-rateio NO-ERROR.

    FIND FIRST duimp-siscomex NO-LOCK
        WHERE duimp-siscomex.cod-duimp-dts = pcod-duimp-dts NO-ERROR.

    FOR FIRST ordens-embarque NO-LOCK
        where ordens-embarque.cod-estabel = pc-cod-estabel
        AND   ordens-embarque.embarque    = pc-embarque:

        run setaValorinicial in h-im0091 (INPUT date(duimp-siscomex.data-cotacao),
                                          input ordens-embarque.cod-estabel).
        run rateioEmbarque in h-im0091 (input ordens-embarque.cod-estabel,
                                        input ordens-embarque.embarque,
                                        input ordens-embarque.cod-natur-of,
                                        output table tt-desp-rateio).

        /* Excluir as despesas de pontos de controle posteriores ao embarque: Nacionalizaá∆o e Chegada/Encerramento */
        FOR EACH tt-desp-rateio
            WHERE tt-desp-rateio.numero-ordem = ordens-embarque.numero-ordem
            AND   tt-desp-rateio.parcela      = ordens-embarque.parcela:

            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                   AND historico-embarque.embarque    = ordens-embarque.embarque NO-ERROR.

            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

            IF tt-desp-rateio.val-desp = ? THEN
                ASSIGN tt-desp-rateio.val-desp = 0.

            if  can-find(FIRST desp-embarque NO-LOCK
                         WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel
                         AND   desp-embarque.embarque      = historico-embarque.embarque
                         AND   desp-embarque.cod-itiner    = historico-embarque.cod-itiner
                         and  (desp-embarque.cod-pto-contr = itinerario.pto-desembarque
                         or    desp-embarque.cod-pto-contr = INTEGER(SUBSTR(itinerario.char-1,1,5)))
                         and   desp-embarque.cod-desp      = tt-desp-rateio.cod-desp) THEN
                DELETE tt-desp-rateio.
        end.
    END.

    IF VALID-HANDLE(h-im0091) THEN DO:
        DELETE PROCEDURE h-im0091.
        ASSIGN h-im0091 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTTDuimpItem DBOProgram
PROCEDURE piCriaTTDuimpItem :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts  LIKE duimp-item.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE duimp-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque     LIKE duimp-item.embarque NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem LIKE duimp-item.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE h-boin082     AS HANDLE NO-UNDO. /* cotacao-item */
    DEFINE VARIABLE h-bocx025     AS HANDLE NO-UNDO. /* inco-cx */
    DEFINE VARIABLE h-boin245     AS HANDLE NO-UNDO. /* natur-oper */
    DEFINE VARIABLE c-return      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-consumo     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-seq-item    AS INTEGER NO-UNDO.
    DEFINE VARIABLE de-fator-conv AS DECIMAL NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx025) THEN
        RUN cxbo/bocx025.p PERSISTENT SET h-bocx025.
    IF NOT VALID-HANDLE(h-boin082) THEN
        RUN inbo/boin082.p PERSISTENT SET h-boin082.
    IF NOT VALID-HANDLE(h-boin245) THEN
        RUN inbo/boin245.p PERSISTENT SET h-boin245.

    EMPTY TEMP-TABLE tt-duimp-item-create NO-ERROR.

    FOR FIRST ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel  = pc-cod-estabel
        AND   ordens-embarque.embarque     = pc-embarque
        AND   ordens-embarque.numero-ordem = pi-numero-ordem,
        FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        FIND FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
        IF NOT AVAIL ordem-compra THEN NEXT.

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.

        /*Desconsidera ordens de compra j† vinculadas a uma DUIMP*/
        IF  CAN-FIND(FIRST bf{&TableName}
                     WHERE bf{&TableName}.numero-ordem = ordens-embarque.numero-ordem
                     AND   bf{&TableName}.embarque     = ordens-embarque.embarque) THEN
            NEXT.

        FIND FIRST duimp-siscomex NO-LOCK
            WHERE duimp-siscomex.cod-duimp-dts = pcod-duimp-dts NO-ERROR.

        ASSIGN i-seq-item = 1.
        FOR LAST  bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.cod-duimp-dts = pcod-duimp-dts
            BY    bf{&TableName}.cod-duimp-dts
            BY    bf{&TableName}.seq-item:
            ASSIGN i-seq-item = bf{&TableName}.seq-item + 1.
        END.

        CREATE tt-duimp-item-create.
        ASSIGN tt-duimp-item-create.cod-duimp-dts            = pcod-duimp-dts
               tt-duimp-item-create.embarque                 = ordens-embarque.embarque
               tt-duimp-item-create.cod-emitente             = ordem-compra.cod-emitente
               tt-duimp-item-create.cod-estabel              = ordens-embarque.cod-estabel
               tt-duimp-item-create.numero-ordem             = ordens-embarque.numero-ordem
               tt-duimp-item-create.cod-item                 = ordem-compra.it-codigo
               tt-duimp-item-create.seq-item                 = i-seq-item
               tt-duimp-item-create.mo-codigo                = ordem-compra.mo-codigo
               tt-duimp-item-create.incoterm                 = embarque-imp.cod-incoterm
               tt-duimp-item-create.cod-pais-iso-exporta     = duimp-siscomex.cod-pais-iso
               tt-duimp-item-create.num-di-ems               = 0
               tt-duimp-item-create.num-identific            = if tt-duimp-item-create.caract-import = 2 or tt-duimp-item-create.caract-import = 3
                                                               then duimp-siscomex.ni-importador /*CNPJ do adquirente ou encomendante*/
                                                               ELSE ""
               tt-duimp-item-create.numero-rof               = embarque-imp.nr-rof
               tt-duimp-item-create.peso-liq                 = ordens-embarque.peso-liquido
               tt-duimp-item-create.qtd-com                  = ordens-embarque.qt-do-forn
               tt-duimp-item-create.qtd-med                  = ordens-embarque.quantidade
               tt-duimp-item-create.versao                   = duimp-siscomex.num-versao-duimp
               .

        /* Local de Consumo: grava UF + codigo IBGE no cod-livre-1 */
        RUN pi-monta-local-consumo (INPUT  ordens-embarque.cod-estabel,
                                    INPUT  ordens-embarque.numero-ordem,
                                    OUTPUT tt-duimp-item-create.cod-livre-1).

        /* Tratamento quantidade Unidade Estat°stica NCM **/
        ASSIGN de-fator-conv = 0.
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-duimp-item-create.cod-item:

            ASSIGN de-fator-conv = DECIMAL(TRIM(SUBSTRING(item.char-1,321,20))). /* fator conv p/ unid tribut - tabela item */

            IF de-fator-conv <> 0 THEN
                ASSIGN tt-duimp-item-create.qtd-med = ROUND(ordens-embarque.quantidade * de-fator-conv, 4).
        END.

        RUN findCotacaoAprovada IN h-boin082 (INPUT ordens-embarque.numero-ordem, OUTPUT c-return).
        IF  c-return = "" THEN
            RUN getCharfield IN h-boin082 (INPUT "un":U, OUTPUT  tt-duimp-item-create.unid-com).

        run findPk_incoterm in h-bocx025(input embarque-imp.cod-incoterm, output c-return).
        if  c-return = "" THEN
            run getCharfield in h-bocx025(input "descricao":U, output tt-duimp-item-create.compl-incoterm).

        FIND FIRST processo-imp NO-LOCK
            WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-ERROR.
        IF AVAIL processo-imp THEN DO:
            ASSIGN tt-duimp-item-create.cdn-exporta = string(processo-imp.cod-exportador).
        END.

        /* Cotacao do item */
        FIND FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
            AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
            AND   cotacao-item.cot-aprovada NO-ERROR.
        IF  AVAIL cotacao-item THEN DO:
            ASSIGN tt-duimp-item-create.vlr-unit-mo = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).
        END.

        /* Valor Frete - armazena a primeira despesa de frete encontrada*/
        FOR EACH tt-desp-rateio NO-LOCK
            WHERE tt-desp-rateio.numero-ordem = ordens-embarque.numero-ordem
            AND   tt-desp-rateio.parcela      = ordens-embarque.parcela:

            IF can-find(FIRST desp-imp NO-LOCK
                        WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp
                        AND   desp-imp.inc-val-frete) THEN
                assign tt-duimp-item-create.val-frete = tt-desp-rateio.val-desp.
        end.

        /* Valor Seguro - armazena a primeira despesa de seguro encontrada */
        FOR EACH tt-desp-rateio NO-LOCK
            WHERE tt-desp-rateio.numero-ordem = ordens-embarque.numero-ordem
            AND   tt-desp-rateio.parcela      = ordens-embarque.parcela:

            IF can-find(FIRST desp-imp NO-LOCK
                        WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp
                        AND   desp-imp.inc-val-seguro) THEN
                assign tt-duimp-item-create.val-seguro = tt-desp-rateio.val-desp.
        end.

        /* Busca a comercializacao */
        RUN goToKey IN h-boin245 (INPUT tt-duimp-item-create.nat-operacao).
        IF  RETURN-VALUE = "OK":U THEN
            RUN getLogField IN h-boin245 (INPUT "consum-final", OUTPUT l-consumo).
        ASSIGN tt-duimp-item-create.aplicacao = if l-consumo then 2 else 1.

        RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE tt-duimp-item-create).
        RUN createRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.

        DELETE tt-duimp-item-create.

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
           RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-bocx025) THEN DO:
        DELETE PROCEDURE h-bocx025.
        ASSIGN h-bocx025 = ?.
    END.
    IF VALID-HANDLE(h-boin082) THEN DO:
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.
    IF VALID-HANDLE(h-boin245) THEN DO:
        RUN destroy IN h-boin245.
        ASSIGN h-boin245 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDuimpItemNF DBOProgram
PROCEDURE piAtualizaDuimpItemNF :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza DUIMP com informaá‰es do documento gerado no IM0100
  Parameters:  pc-cod-estabel  - Estabelecimento
               pc-embarque     - Numero do Embarque
               pi-numero-ordem - Numero da Ordem de Compra
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-rw-item-doc-est AS ROWID                     NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE duimp-item.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque        LIKE duimp-item.embarque     NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem    LIKE duimp-item.numero-ordem NO-UNDO.

    FIND FIRST duimp-item WHERE duimp-item.cod-estabel = pc-cod-estabel
           AND duimp-item.embarque = pc-embarque
           AND duimp-item.numero-ordem = pi-numero-ordem EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL duimp-item THEN DO:
        IF pc-rw-item-doc-est <> ? THEN
            FIND FIRST item-doc-est WHERE rowid(item-doc-est) = pc-rw-item-doc-est NO-LOCK NO-ERROR.
        else do:
            for first ordem-compra no-lock
                where ordem-compra.numero-ordem = duimp-item.numero-ordem:
            end.

            FIND FIRST item-doc-est
                WHERE item-doc-est.num-pedido   = ordem-compra.num-pedido
                and   item-doc-est.numero-ordem = duimp-item.numero-ordem NO-LOCK NO-ERROR.
        end.

        IF AVAIL item-doc-est THEN DO:

            ASSIGN duimp-item.serie-docto  = item-doc-est.serie-docto
                   duimp-item.nro-docto    = item-doc-est.nro-docto
                   duimp-item.cod-emitente = item-doc-est.cod-emitente
                   duimp-item.nat-operacao = item-doc-est.nat-operacao
                   duimp-item.sequencia    = item-doc-est.sequencia.

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRemoveDuimpNF DBOProgram
PROCEDURE piRemoveDuimpNF :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza DUIMP retirando informaá‰es do documento excluido no RE1001
  Parameters:  p-serie-docto  - Serie do Documento
               p-nro-docto    - Numero do Documento
               p-cod-emitente - Codigo do Emitente
               p-nat-operacao - Natureza de Operacao
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER p-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.

    FOR EACH duimp-item WHERE duimp-item.serie-docto  = p-serie-docto
                          AND duimp-item.nro-docto    = p-nro-docto
                          AND duimp-item.cod-emitente = p-cod-emitente
                          AND duimp-item.nat-operacao = p-nat-operacao EXCLUSIVE-LOCK:

        ASSIGN duimp-item.serie-docto  = ""
               duimp-item.nro-docto    = ""
               duimp-item.nat-operacao = ""
               duimp-item.sequencia    = 0.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRemoveDuimpItemNF DBOProgram
PROCEDURE piRemoveDuimpItemNF :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza DUIMP retirando informaá‰es do item do documento excluido no RE1001
  Parameters:  p-serie-docto  - Serie do Documento
               p-nro-docto    - Numero do Documento
               p-cod-emitente - Codigo do Emitente
               p-nat-operacao - Natureza de Operacao
               p-sequencia    - Sequencia do item
  Notes:
-------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER p-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia    LIKE item-doc-est.sequencia    NO-UNDO.

    FIND FIRST duimp-item WHERE duimp-item.serie-docto  = p-serie-docto
                            AND duimp-item.nro-docto    = p-nro-docto
                            AND duimp-item.cod-emitente = p-cod-emitente
                            AND duimp-item.nat-operacao = p-nat-operacao
                            AND duimp-item.sequencia    = p-sequencia EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL duimp-item THEN DO:
        ASSIGN duimp-item.serie-docto  = ""
               duimp-item.nro-docto    = ""
               duimp-item.nat-operacao = ""
               duimp-item.sequencia    = 0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-local-consumo DBOProgram
/* Local de Consumo (UF + IBGE) reutilizavel */
{imp/impLocalConsumo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
