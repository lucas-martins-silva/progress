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
{include/i-prgvrs.i BOIN082SD 2.00.00.037 } /*** "010037" 23/11/2023 16:19:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin082sd MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : BOIN082SD.P
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO com procedures que setam defaults.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/

{inbo/boin082.i RowObject}
{include/i-epc200.i boin082sd}
/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER b-ord          FOR ordem-compra.
DEFINE BUFFER b-cot-item     FOR {&TableName}.
DEFINE BUFFER b-cotacao-item for {&TableName}.

/*  Vari veis utilizados nas procedures  */
def var i-cod-servico    as int    no-undo.
def var iCodigoMoedaPedEmerg  as int    no-undo.
def var iCodigoMoedaCotItem   as int    no-undo.
def var cMoCodigo        as char   extent 5 no-undo.    
def var deQtParcela      as dec    no-undo.
def var deConver         as dec    no-undo.
def var deQtdForn        as dec    no-undo.
def var deQtdTot         as dec    no-undo.
def var deIndice         as dec    no-undo.
def var hBoin082ca       as handle no-undo.
def var iNumeroOrdem-ini as int    no-undo.
def var iNumeroOrdem-fim as int    no-undo.
def var iCont            as int    no-undo.
def var i-mo-codigo      as int    no-undo.
def var rwTbPrCc         as rowid  no-undo.
def var rwTabItem        as rowid  no-undo.
def var rOrdemCompra     as rowid  no-undo.
def var rbCotacaoItem    as rowid  no-undo.
def var h-bosc014        as handle no-undo.
DEFINE VARIABLE iMoCodigoEmergencial LIKE moeda.mo-codigo NO-UNDO.
DEFINE VARIABLE lUtilizaMoedaUsuario AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE lExisteTabela        AS LOGICAL INITIAL NO NO-UNDO. /* item-tab; tb-pr-cc */

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
         HEIGHT             = 2.63
         WIDTH              = 39.86.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInformRelacCotacaoItem DBOProgram 
PROCEDURE buscaInformRelacCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Carrega alguns campos com informa‡Æes de outras tabelas
           relecionadas com a cotaca-item apenas p/ consulta em uma tela de
           modifica‡Æo da cota‡Æo do item.     
  Parameters:
            ipar1 : piNumeroOrdem       : numero da ordem na cotacao do item
            ipar2 : piFornec      : c½digo do fornecedor 
            ipar3 : prItem        : rowid do item
            opar4 : pdeQtSolic    : quantidade total solicitada na ordem 
            opar5 : pdaEmissao    : data da emiss’o da ordem
            opar6 : pdaEntrega    : data de entrega da parcela 
            opar7 : pcUn          : unidade de medida relacionada a parcela
            opar8 : pcItem        : item da ordem de compra
            opar9 : pcItemFornec : item relacionado ao fornecedor   
  Notes: 
------------------------------------------------------------------------------*/

    def input  param piNumeroOrdem  as int   no-undo.
    def input  param piFornec       as int   no-undo.
    def input  param prItem         as rowid no-undo.
    def output param pdeQtSolic     as dec   no-undo.
    def output param pdaEmissao     as date  no-undo.
    def output param pdaEntrega     as date  no-undo.
    def output param pcUn           as char  no-undo.
    def output param pcItem         as char  no-undo.
    def output param pcItemFornec  as char  no-undo.


    for first item fields(it-codigo tipo-contr un) where 
        rowid(item) = prItem 
        no-lock: end.

    for first ordem-compra fields(numero-ordem data-emissao qt-solic it-codigo) where
        ordem-compra.numero-ordem = piNumeroOrdem 
        no-lock: end.
    if avail ordem-compra then 
          assign pdaEmissao = ordem-compra.data-emissao
                 pdeQtSolic = ordem-compra.qt-solic
                 pcItem     = ordem-compra.it-codigo.                   

    for first prazo-compra fields(numero-ordem data-entrega un) where
               prazo-compra.numero-ordem = ordem-compra.numero-ordem
               no-lock: end.
    if avail prazo-compra then 
        assign pdaEntrega = prazo-compra.data-entrega
               pcUn       = if item.tipo-contr = 4 then prazo-compra.un else item.un.          

    for first item-fornec fields(it-codigo cod-emitente ativo) where 
        item-fornec.it-codigo    = item.it-codigo and
        item-fornec.cod-emitente = piFornec and
        item-fornec.ativo          no-lock: end.
    if avail item-fornec then
       assign pcItemFornec = item-fornec.it-codigo.     

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
        WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice COTACAO
  Parameters:
               retorna valor dos campos do ­ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pcod-emitente = RowObject.cod-emitente
           pit-codigo = RowObject.it-codigo
           pseq-cotac = RowObject.seq-cotac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "ind-ret-cotacao":U THEN ASSIGN pFieldValue = RowObject.ind-ret-cotacao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice COTACAO
  Parameters:
               recebe valor dos campos do ­ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    FIND FIRST bfcotacao-item WHERE
        bfcotacao-item.numero-ordem = pnumero-ordem AND
        bfcotacao-item.cod-emitente = pcod-emitente AND
        bfcotacao-item.it-codigo = pit-codigo AND
        bfcotacao-item.seq-cotac = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaDadosReajusteCotacao DBOProgram 
PROCEDURE inicializaDadosReajusteCotacao :
/*------------------------------------------------------------------------------
  Purpose:     Mostra os dados do rejuste de cota‡Æo, caso existirem.
  Parameters: ipar1  : prCotacao       : Rowid da Cota‡Æo.
              opar2  : pdtPrecoBase    : Data do Preço Base.
              opar3  : piMoCodigo1     : Moeda1 da Cota‡Æo.
              opar4  : piMoCodigo2     : Moeda2 da Cota‡Æo.
              opar5  : piMoCodigo3     : Moeda3 da Cota‡Æo.
              opar6  : piMoCodigo4     : Moeda4 da Cota‡Æo.
              opar7  : piMoCodigo5     : Moeda5 da Cota‡Æo.
              opar8  : pcMoeda1        : Descri‡Æo da Moeda1 da Cota‡Æo.
              opar9  : pcMoeda2        : Descri‡Æo da Moeda2 da Cota‡Æo.
              opar10 : pcMoeda3        : Descri‡Æo da Moeda3 da Cota‡Æo.
              opar11 : pcMoeda4        : Descri‡Æo da Moeda4 da Cota‡Æo.
              opar12 : pcMoeda5        : Descri‡Æo da Moeda5 da Cota‡Æo.
              opar13 : pdaDataIndice1  : Data ¡ndice1 da Cota‡Æo.
              opar14 : pdaDataIndice2  : Data ¡ndice2 da Cota‡Æo.
              opar15 : pdaDataIndice3  : Data ¡ndice3 da Cota‡Æo.
              opar16 : pdaDataIndice4  : Data ¡ndice4 da Cota‡Æo.
              opar17 : pdaDataIndice5  : Data ¡ndice5 da Cota‡Æo.
              opar18 : ppercReaj1      : Percentual1 do Reajuste de Cota‡Æo.
              opar19 : ppercReaj2      : Percentual2 do Reajuste de Cota‡Æo.
              opar20 : ppercReaj3      : Percentual3 do Reajuste de Cota‡Æo.
              opar21 : ppercReaj4      : Percentual4 do Reajuste de Cota‡Æo.
              opar22 : ppercReaj5      : Percentual5 do Reajuste de Cota‡Æo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param prCotacao       as rowid.
    def output param pdtPrecoBase    as date    no-undo. 
    def output param piMoCodigo1     as integer no-undo.
    def output param piMoCodigo2     as integer no-undo.
    def output param piMoCodigo3     as integer no-undo.
    def output param piMoCodigo4     as integer no-undo.
    def output param piMoCodigo5     as integer no-undo.
    def output param pcMoeda1        as char    no-undo.
    def output param pcMoeda2        as char    no-undo.
    def output param pcMoeda3        as char    no-undo.
    def output param pcMoeda4        as char    no-undo.
    def output param pcMoeda5        as char    no-undo.
    def output param pdaDataIndice1  as date    no-undo.
    def output param pdaDataIndice2  as date    no-undo.
    def output param pdaDataIndice3  as date    no-undo.
    def output param pdaDataIndice4  as date    no-undo.
    def output param pdaDataIndice5  as date    no-undo.
    def output param ppercReaj1      as decimal no-undo.
    def output param ppercReaj2      as decimal no-undo.
    def output param ppercReaj3      as decimal no-undo.
    def output param ppercReaj4      as decimal no-undo.
    def output param ppercReaj5      as decimal no-undo.

    for first cotacao-item fields(numero-ordem it-codigo cod-emitente data-cotacao) where 
        rowid(cotacao-item) = prCotacao 
        no-lock: end.

    if  avail cotacao-item then do:
        if cotacao-item.numero-ordem = ? then
            find first cota-item-reaj where
                       cota-item-reaj.it-codigo    = cotacao-item.it-codigo
                   and cota-item-reaj.numero-ordem = 0
                   and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                   no-lock no-error.
        else
            find first cota-item-reaj where
                       cota-item-reaj.it-codigo    = cotacao-item.it-codigo
                   and cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
                   and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                   no-lock no-error.

        if  avail cota-item-reaj then do:
              assign pdtPrecoBase = cota-item-reaj.dt-preco-base
                     piMoCodigo1    = cota-item-reaj.mo-codigo[1]
                     piMoCodigo2    = cota-item-reaj.mo-codigo[2]
                     piMoCodigo3    = cota-item-reaj.mo-codigo[3]
                     piMoCodigo4    = cota-item-reaj.mo-codigo[4]
                     piMoCodigo5    = cota-item-reaj.mo-codigo[5]
                     pdaDataIndice1  = cota-item-reaj.data-indice[1]
                     pdaDataIndice2  = cota-item-reaj.data-indice[2]
                     pdaDataIndice3  = cota-item-reaj.data-indice[3]
                     pdaDataIndice4  = cota-item-reaj.data-indice[4]
                     pdaDataIndice5  = cota-item-reaj.data-indice[5]
                     ppercReaj1    = cota-item-reaj.perc-reaj[1]
                     ppercReaj2    = cota-item-reaj.perc-reaj[2]
                     ppercReaj3    = cota-item-reaj.perc-reaj[3]
                     ppercReaj4    = cota-item-reaj.perc-reaj[4]
                     ppercReaj5    = cota-item-reaj.perc-reaj[5].

         do  iCont = 1 to 5:
              if  cota-item-reaj.mo-codigo[iCont] <> 0 then do:
                  for first moeda fields(mo-codigo descricao) where 
                      moeda.mo-codigo = cota-item-reaj.mo-codigo[iCont]
                      no-lock: end.
                  assign cMoCodigo[iCont] = if avail moeda then moeda.descricao else "".
              end.
          end. 
          assign pcMoeda1 = cMoCodigo[1]
                 pcMoeda2 = cMoCodigo[2]
                 pcMoeda3 = cMoCodigo[3]
                 pcMoeda4 = cMoCodigo[4]
                 pcMoeda5 = cMoCodigo[5].

        end.
        assign pdtPrecoBase = cotacao-item.data-cotacao.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH cotacao-item NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-existencia-tab-preco-item DBOProgram 
PROCEDURE pi-retorna-existencia-tab-preco-item :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a existˆncia da tabela de pre‡o e da item-tab.  
  Parameters:  pl-ExisteTabela  : OUTPUT : YES = Existe tabela de pre‡os e itens da tabela de pre‡os (tb-pr-cc; item-tab)
  Notes:       O valor da vari vel lExisteTabela ‚ setado na procedure preparaCotacaoOrdemCompraPedEmerg
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-ExisteTabela AS LOGICAL NO-UNDO.

    ASSIGN pl-ExisteTabela  = lExisteTabela.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-moeda DBOProgram 
PROCEDURE pi-seta-moeda :
/*------------------------------------------------------------------------------
  Purpose: Seta a vari vel cMoCodigoEmergencial e uma vari vel l¢gica de controle 
           utilizada na preparaCotacaoOrdemCompraPedEmerg.
  Parameters:  pMoedaEmergencial : INPUT : C¢digo da moeda que ser  utilizado para
               criar a temp-table rowObject na procedure preparaCotacaoOrdemCompraPedEmerg.
  Notes:        
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pMoedaEmergencial LIKE moeda.mo-codigo NO-UNDO.

    ASSIGN iMoCodigoEmergencial = pMoedaEmergencial
           lUtilizaMoedaUsuario = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preparaCotacaoOrdemCompraPedEmerg DBOProgram 
PROCEDURE preparaCotacaoOrdemCompraPedEmerg :
{inbo/boin082sd.i} 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultIncluiCotacaoItem DBOProgram 
PROCEDURE setDefaultIncluiCotacaoItem :
{inbo/boin082sd.i2} 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

