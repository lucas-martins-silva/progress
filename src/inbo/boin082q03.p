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
{include/i-prgvrs.i BOIN082Q03 2.00.00.008} /*** "010008" 23/11/2023 16:19:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin082q03 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName    cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName  cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName  qr{&TableName}
&GLOBAL-DEFINE JoinTable  ordem-compra

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


/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
/*{inbo/boin082q03.i tt-cotacao-item}
{inbo/boin082q03.i RowObject} */
{inbo/boin082.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
      
/*Include "comentado" pois as queries necessitam tamb‚m da tabela ordem-compra para a abertura da mesma*/
/* Bo Espec¡fica do programa WCC05232.W (Cota‡äes - Pendˆncias Comprador)*/
/* {method/dboqry.i} */


DEFINE QUERY {&QueryName} for {&TableName},{&JoinTable}, emitente, item scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/******   Vari veis setConstraint1  *******/

    def var cCodComprado      as char no-undo.
    def var cItCodigoIni      as char no-undo.
    def var cItCodigoFim      as char no-undo.
    def var daDataCotacaoIni  as date no-undo.
    def var daDataCotacaoFim  as date no-undo.
    def var iPendAprov        as int  no-undo.
    def var iNumeroOrdemIni   as int  no-undo.
    def var iNumeroOrdemFim   as int  no-undo.
    def var lAprovadas        as log  no-undo.
    def var lNaoAprovadas     as log  no-undo.
    def var cCodEstabelIni    as char no-undo.
    def var cCodEstabelFim    as char no-undo.
    def var cNomeAbrevIni     as char no-undo.
    def var cNomeAbrevFim     as char no-undo. 
    def var cFamiliaIni       as char no-undo. 
    def var cFamiliaFim       as char no-undo.
    def var cRequisitanteIni  as char no-undo. 
    def var cRequisitanteFim  as char no-undo.

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
         HEIGHT             = 16.29
         WIDTH              = 60.2.
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
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
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
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
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
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
        WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
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
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS ROWID NO-UNDO.

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

    FIND FIRST bf{&TableName} WHERE
        bf{&TableName}.numero-ordem = pnumero-ordem AND
        bf{&TableName}.cod-emitente = pcod-emitente AND
        bf{&tablename}.it-codigo = pit-codigo AND
        bf{&TableName}.seq-cotac = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDeposito DBOProgram 
PROCEDURE retornaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pdep-almoxar  LIKE ordem-compra.dep-almoxar  NO-UNDO.

    for first ordem-compra fields(numero-ordem dep-almoxar) where 
        ordem-compra.numero-ordem = pnumero-ordem no-lock: end.

    if avail ordem-compra then
       assign pdep-almoxar = ordem-compra.dep-almoxar.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose: Neste m‚todo existem trˆs queries diferentes que sÆo abertas de acordo 
           com o valores parametrizados (indicadores de aprova‡Æo) passados para 
           o setConstraint associado, buscando conjunto de registros da tabela
           cotacao-item dentro de uma faixa de n£mero da ordem, data da cota‡Æo e 
           c¢digo do item de acordo com a situa‡Æo e pendˆncia de aprova‡Æo da 
           ordem-compra relacionada. 
           Os registros sÆo ordenados pelo n£mero da ordem

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    if lAprovadas = lNaoAprovadas then
        OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} WHERE 
                                         {&TableName}.cod-comprado  = cCodComprado               AND
                                         {&TableName}.numero-ordem >= iNumeroOrdemIni            AND
                                         {&TableName}.numero-ordem <= iNumeroOrdemFim            AND
                                         {&TableName}.data-cotacao >= daDataCotacaoIni           AND
                                         {&TableName}.data-cotacao <= daDataCotacaoFim           AND
                                         {&tablename}.it-codigo    >= cItCodigoIni               AND
                                         {&tablename}.it-codigo    <= cItCodigoFim               NO-LOCK,
                                   FIRST {&JoinTable} WHERE
                                         {&JoinTable}.numero-ordem  = {&TableName}.numero-ordem  AND
                                         {&JoinTable}.cod-estabel  >= cCodEstabelIni             AND
                                         {&JoinTable}.cod-estabel  <= cCodEstabelFim             AND 
                                         {&JoinTable}.requisitante >= cRequisitanteIni           AND
                                         {&JoinTable}.requisitante <= cRequisitanteFim           AND                                          
                                       (({&JoinTable}.situacao      = 3                          AND
                                         {&JoinTable}.num-pedido    = 0                          AND
                                         {&JoinTable}.cod-cond-pag <> ?                          AND
                                       (({&JoinTable}.pend-aprov    = 1 and iPendAprov= 2)       OR
                                        (iPendAprov = 1)))                                       OR
                                         {&JoinTable}.situacao = 5 ) NO-LOCK,
                                   FIRST emitente where 
                                         emitente.cod-emitente      = {&TableName}.cod-emitente  AND
                                         emitente.nome-abrev       >= cNomeAbrevIni              AND
                                         emitente.nome-abrev       <= cNomeAbrevFim              NO-LOCK,
                                   FIRST item where 
                                         item.it-codigo             = {&tablename}.it-codigo     AND
                                         item.fm-codigo            >= cFamiliaIni                AND                           
                                         item.fm-codigo            <= cFamiliaFim 
                                         NO-LOCK
                                         BY {&TableName}.cod-comprado
                                         BY {&TableName}.numero-ordem
                                         BY {&TableName}.cod-emitente
                                         BY {&tablename}.it-codigo
                                         BY {&TableName}.seq-cotac
                                   &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                       INDEXED-REPOSITION
                                   &endif.    
    else if lAprovadas = YES then
        OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} WHERE 
                                         {&TableName}.cod-comprado  = cCodComprado               AND
                                         {&TableName}.numero-ordem >= iNumeroOrdemIni            AND
                                         {&TableName}.numero-ordem <= iNumeroOrdemFim            AND
                                         {&TableName}.data-cotacao >= daDataCotacaoIni           AND
                                         {&TableName}.data-cotacao <= daDataCotacaoFim           AND
                                         {&tablename}.it-codigo    >= cItCodigoIni               AND
                                         {&tablename}.it-codigo    <= cItCodigoFim               NO-LOCK,
                                   FIRST {&JoinTable} WHERE
                                         {&JoinTable}.numero-ordem  = {&TableName}.numero-ordem  AND
                                         {&JoinTable}.cod-estabel  >= cCodEstabelIni             AND
                                         {&JoinTable}.cod-estabel  <= cCodEstabelFim             AND                                          
                                         {&JoinTable}.situacao      = 3                          AND
                                         {&JoinTable}.num-pedido    = 0                          AND
                                         {&JoinTable}.cod-cond-pag <> ?                          AND
                                       (({&JoinTable}.pend-aprov = 1 and iPendAprov = 2)         OR
                                        (iPendAprov = 1))   NO-LOCK,
                                   FIRST emitente where 
                                         emitente.cod-emitente      = {&TableName}.cod-emitente  AND
                                         emitente.nome-abrev       >= cNomeAbrevIni              AND
                                         emitente.nome-abrev       <= cNomeAbrevFim              NO-LOCK,
                                   FIRST item where 
                                         item.it-codigo             = {&tablename}.it-codigo     AND
                                         item.fm-codigo            >= cFamiliaIni                AND                           
                                         item.fm-codigo            <= cFamiliaFim 
                                         NO-LOCK
                                         BY {&TableName}.cod-comprado
                                         BY {&TableName}.numero-ordem
                                         BY {&TableName}.cod-emitente
                                         BY {&tablename}.it-codigo
                                         BY {&TableName}.seq-cotac
                                    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                       INDEXED-REPOSITION
                                    &endif.

    else
        OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} WHERE 
                                         {&TableName}.cod-comprado  = cCodComprado               AND
                                         {&TableName}.numero-ordem >= iNumeroOrdemIni            AND
                                         {&TableName}.numero-ordem <= iNumeroOrdemFim            AND
                                         {&TableName}.data-cotacao >= daDataCotacaoIni           AND
                                         {&TableName}.data-cotacao <= daDataCotacaoFim           AND
                                         {&tablename}.it-codigo    >= cItCodigoIni               AND
                                         {&tablename}.it-codigo    <= cItCodigoFim               NO-LOCK,
                                   FIRST {&JoinTable} WHERE
                                         {&JoinTable}.numero-ordem  = {&TableName}.numero-ordem  AND
                                         {&JoinTable}.cod-estabel  >= cCodEstabelIni            AND
                                         {&JoinTable}.cod-estabel  <= cCodEstabelFim            AND                                          
                                         {&JoinTable}.situacao      = 5 NO-LOCK,
                                   FIRST emitente where 
                                         emitente.cod-emitente      = {&TableName}.cod-emitente AND
                                         emitente.nome-abrev       >= cNomeAbrevIni             AND
                                         emitente.nome-abrev       <= cNomeAbrevFim             NO-LOCK,
                                   FIRST item where 
                                         item.it-codigo             = {&tablename}.it-codigo     AND
                                         item.fm-codigo            >= cFamiliaIni                AND                           
                                         item.fm-codigo            <= cFamiliaFim 
                                         NO-LOCK
                                         BY {&TableName}.cod-comprado
                                         BY {&TableName}.numero-ordem
                                         BY {&TableName}.cod-emitente
                                         BY {&tablename}.it-codigo
                                         BY {&TableName}.seq-cotac
                                    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                       INDEXED-REPOSITION
                                    &endif.                                          
   RETURN "OK":U.                                
                                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumeroOrdem DBOProgram 
PROCEDURE setConstraintNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari veis para openQueryBynumeroOrdem 
  Parameters:
              ipar1  : pcCodComprado     : C¢digo do comprador
              ipar2  : piPendAprov       : Ordem pendente de aprova‡Æo
              ipar3  : piNumeroOrdemIni  : N£mero da ordem inicial
              ipar4  : piNumeroOrdemFim  : N£mero da ordem final
              ipar5  : pdaDataCotacaoIni : Data da cota‡ao inicial
              ipar6  : pdaDataCotacaoFim : Data da cota‡Æo final
              ipar7  : pcItCodigoIni     : C¢digo do item inicial
              ipar8  : pcItCodigoFim     : C¢digo do item final
              ipar9  : plAprovadas       : Situa‡Æo da ordem aprovada
              ipar10 : plNaoAprovadas    : Situa‡Æo da ordem nÆo aprovada
              ipar11 : pcCodEstabelIni   : C¢digo inicial do estabelecimento
              ipar12 : pcCodEstabelFim   : C¢digo final do estabelecimento
              ipar13 : pcNomeAbrevIni    : Nome Abreviado do emitente inicial
              ipar14 : pcNomeAbrevFim    : Nome Abreviado do emitente final
              ipar15 : pcFamiliaIni      : C¢digo inicial da fam¡lia 
              ipar16 : pcFamiliaFim      : C¢digo final da fam¡lia
              ipar15 : pcRequisitanteIni : Requisitante inicial 
              ipar16 : pcRequisitanteFim : Requisitante final
  Notes:       
------------------------------------------------------------------------------*/
   
    def input param pcCodComprado     as char no-undo.
    def input param piPendAprov       as int  no-undo.
    def input param piNumeroOrdemIni  as int  no-undo.
    def input param piNumeroOrdemFim  as int  no-undo.
    def input param pdaDataCotacaoIni as date no-undo.
    def input param pdaDataCotacaoFim as date no-undo.
    def input param pcItCodigoIni     as char no-undo.
    def input param pcItCodigoFim     as char no-undo.
    def input param plAprovadas       as log  no-undo.
    def input param plNaoAprovadas    as log  no-undo.
    def input param pcCodEstabelIni   as char no-undo.
    def input param pcCodEstabelFim   as char no-undo.
    def input param pcNomeAbrevIni    as char no-undo.
    def input param pcNomeAbrevFim    as char no-undo.
    def input param pcFamiliaIni      as char no-undo.
    def input param pcFamiliaFim      as char no-undo.
    def input param pcRequisitanteIni as char no-undo.
    def input param pcRequisitanteFim as char no-undo.    
    
    assign cCodComprado     = pcCodComprado     
           iPendAprov       = piPendAprov
           iNumeroOrdemIni  = piNumeroOrdemIni
           iNumeroOrdemFim  = piNumeroOrdemFim
           daDataCotacaoIni = pdaDataCotacaoIni  
           daDataCotacaoFim = pdaDataCotacaoFim
           cItCodigoIni     = pcItCodigoIni   
           cItCodigoFim     = pcItCodigoFim
           lAprovadas       = plAprovadas
           lNaoAprovadas    = plNaoAprovadas
           cCodEstabelIni   = pcCodEstabelIni
           cCodEstabelFim   = pcCodEstabelFim
           cNomeAbrevIni    = pcNomeAbrevIni
           cNomeAbrevFim    = pcNomeAbrevFim
           cFamiliaIni      = pcFamiliaIni
           cFamiliaFim      = pcFamiliaFim
           cRequisitanteIni = pcRequisitanteIni
           cRequisitanteFim = pcRequisitanteFim.
  
    RETURN "OK":U.                               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendCotacaoComprador DBOProgram 
PROCEDURE geraPendCotacaoComprador :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:
------------------------------------------------------------------------------*/
    def input param pcCodComprado     as char no-undo.
    def input param piPendAprov       as int  no-undo.
    def input param piNumeroOrdemIni  as int  no-undo.
    def input param piNumeroOrdemFim  as int  no-undo.
    def input param pdaDataCotacaoIni as date no-undo.
    def input param pdaDataCotacaoFim as date no-undo.
    def input param pcItCodigoIni     as char no-undo.
    def input param pcItCodigoFim     as char no-undo.
    def input param plAprovadas       as log  no-undo.
    def input param plNaoAprovadas    as log  no-undo.
    def input param pcCodEstabelIni   as char no-undo.
    def input param pcCodEstabelFim   as char no-undo.
    def input param pcNomeAbrevIni    as char no-undo.
    def input param pcNomeAbrevFim    as char no-undo.
    def input param pcFamiliaIni      as char no-undo.
    def input param pcFamiliaFim      as char no-undo.
    
    ASSIGN cCodComprado     = pcCodComprado     
           iPendAprov       = piPendAprov
           iNumeroOrdemIni  = piNumeroOrdemIni
           iNumeroOrdemFim  = piNumeroOrdemFim
           daDataCotacaoIni = pdaDataCotacaoIni  
           daDataCotacaoFim = pdaDataCotacaoFim
           cItCodigoIni     = pcItCodigoIni   
           cItCodigoFim     = pcItCodigoFim
           lAprovadas       = plAprovadas
           lNaoAprovadas    = plNaoAprovadas
           cCodEstabelIni   = pcCodEstabelIni
           cCodEstabelFim   = pcCodEstabelFim
           cNomeAbrevIni    = pcNomeAbrevIni
           cNomeAbrevFim    = pcNomeAbrevFim
           cFamiliaIni      = pcFamiliaIni
           cFamiliaFim      = pcFamiliaFim.

    IF lAprovadas = lNaoAprovadas THEN DO:
        FOR EACH ordem-compra WHERE
                 ordem-compra.cod-comprado  = cCodComprado               AND
                 ordem-compra.cod-estabel  >= cCodEstabelIni             AND
                 ordem-compra.cod-estabel  <= cCodEstabelFim             AND 
               ((ordem-compra.situacao      = 3                          AND
                 ordem-compra.num-pedido    = 0                          AND
                 ordem-compra.cod-cond-pag <> ?                          AND
               ((ordem-compra.pend-aprov    = 1 and iPendAprov= 2)       OR
                (iPendAprov = 1)))                                       OR
                 ordem-compra.situacao = 5 ) NO-LOCK,
            EACH cotacao-item WHERE 
                 cotacao-item.numero-ordem  = ordem-compra.numero-ordem  AND
                 cotacao-item.numero-ordem >= iNumeroOrdemIni            AND
                 cotacao-item.numero-ordem <= iNumeroOrdemFim            AND
                 cotacao-item.data-cotacao >= daDataCotacaoIni           AND
                 cotacao-item.data-cotacao <= daDataCotacaoFim           AND
                 cotacao-item.it-codigo    >= cItCodigoIni               AND
                 cotacao-item.it-codigo    <= cItCodigoFim               NO-LOCK,
           FIRST emitente where 
                 emitente.cod-emitente      = cotacao-item.cod-emitente  AND
                 emitente.nome-abrev       >= cNomeAbrevIni              AND
                 emitente.nome-abrev       <= cNomeAbrevFim              NO-LOCK,
           FIRST item where 
                 item.it-codigo             = cotacao-item.it-codigo     AND
                 item.fm-codigo            >= cFamiliaIni                AND                           
                 item.fm-codigo            <= cFamiliaFim 
                 NO-LOCK:

            RUN montaTTPendCotacao.
        END.
    END.
    ELSE IF lAprovadas = YES THEN DO:
        FOR EACH ordem-compra WHERE
                 ordem-compra.cod-comprado  = cCodComprado               AND
                 ordem-compra.cod-estabel  >= cCodEstabelIni             AND
                 ordem-compra.cod-estabel  <= cCodEstabelFim             AND                                          
                 ordem-compra.situacao      = 3                          AND
                 ordem-compra.num-pedido    = 0                          AND
                 ordem-compra.cod-cond-pag <> ?                          AND
               ((ordem-compra.pend-aprov = 1 and iPendAprov = 2)         OR
                (iPendAprov = 1))   NO-LOCK,
            EACH cotacao-item WHERE 
                 cotacao-item.numero-ordem  = ordem-compra.numero-ordem  AND
                 cotacao-item.numero-ordem >= iNumeroOrdemIni            AND
                 cotacao-item.numero-ordem <= iNumeroOrdemFim            AND
                 cotacao-item.data-cotacao >= daDataCotacaoIni           AND
                 cotacao-item.data-cotacao <= daDataCotacaoFim           AND
                 cotacao-item.it-codigo    >= cItCodigoIni               AND
                 cotacao-item.it-codigo    <= cItCodigoFim               NO-LOCK,
           FIRST emitente where 
                 emitente.cod-emitente      = cotacao-item.cod-emitente  AND
                 emitente.nome-abrev       >= cNomeAbrevIni              AND
                 emitente.nome-abrev       <= cNomeAbrevFim              NO-LOCK,
           FIRST item where 
                 item.it-codigo             = cotacao-item.it-codigo     AND
                 item.fm-codigo            >= cFamiliaIni                AND                           
                 item.fm-codigo            <= cFamiliaFim 
                 NO-LOCK:

            RUN montaTTPendCotacao.
        END.
    END.
    ELSE DO:
        FOR EACH ordem-compra WHERE
                 ordem-compra.cod-comprado  = cCodComprado              AND
                 ordem-compra.cod-estabel  >= cCodEstabelIni            AND
                 ordem-compra.cod-estabel  <= cCodEstabelFim            AND                                          
                 ordem-compra.situacao      = 5 NO-LOCK,
            EACH cotacao-item WHERE 
                 cotacao-item.numero-ordem  = ordem-compra.numero-ordem AND
                 cotacao-item.numero-ordem >= iNumeroOrdemIni           AND
                 cotacao-item.numero-ordem <= iNumeroOrdemFim           AND
                 cotacao-item.data-cotacao >= daDataCotacaoIni          AND
                 cotacao-item.data-cotacao <= daDataCotacaoFim          AND
                 cotacao-item.it-codigo    >= cItCodigoIni              AND
                 cotacao-item.it-codigo    <= cItCodigoFim              NO-LOCK,
           FIRST emitente where 
                 emitente.cod-emitente      = cotacao-item.cod-emitente AND
                 emitente.nome-abrev       >= cNomeAbrevIni             AND
                 emitente.nome-abrev       <= cNomeAbrevFim             NO-LOCK,
           FIRST item where 
                 item.it-codigo             = cotacao-item.it-codigo     AND
                 item.fm-codigo            >= cFamiliaIni                AND                           
                 item.fm-codigo            <= cFamiliaFim 
                 NO-LOCK:

            RUN montaTTPendCotacao.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE montaTTPendCotacao DBOProgram 
PROCEDURE montaTTPendCotacao :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:
------------------------------------------------------------------------------*/
    CREATE tt-cotacao-item.
    ASSIGN tt-cotacao-item.numero-ordem = ordem-compra.numero-ordem
           tt-cotacao-item.situacao     = ordem-compra.situacao
           tt-cotacao-item.narr-ordem   = ordem-compra.narrativa
           tt-cotacao-item.narr-item    = item.narrativa
           tt-cotacao-item.data-cotacao = cotacao-item.data-cotacao
           tt-cotacao-item.seq-cotac    = cotacao-item.seq-cotac
           tt-cotacao-item.cod-emitente = cotacao-item.cod-emitente
           tt-cotacao-item.nome-abrev   = emitente.nome-abrev
           tt-cotacao-item.it-codigo    = cotacao-item.it-codigo
           tt-cotacao-item.preco-fornec = cotacao-item.preco-fornec
           tt-cotacao-item.pre-unit-for = cotacao-item.pre-unit-for
           tt-cotacao-item.preco-unit   = cotacao-item.preco-unit
           tt-cotacao-item.valor-descto = cotacao-item.valor-descto
           tt-cotacao-item.valor-frete  = cotacao-item.valor-frete
           tt-cotacao-item.codigo-ipi   = cotacao-item.codigo-ipi
           tt-cotacao-item.aliquota-ipi = cotacao-item.aliquota-ipi
           tt-cotacao-item.r-item       = ROWID(item)
           tt-cotacao-item.r-rowid      = ROWID(cotacao-item)
           tt-cotacao-item.r-ordem      = ROWID(ordem-compra).

    IF item.it-codigo  = "" AND
       item.tipo-contr = 4 THEN  /* debito direto */
        ASSIGN tt-cotacao-item.desc-item = SUBSTRING(ordem-compra.narrativa,1,60).
    ELSE
        ASSIGN tt-cotacao-item.desc-item = item.desc-item.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME  
*/
