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
{include/i-prgvrs.i BOIN274Q06 2.00.00.002} /*** "010002" 23/11/2023 16:19:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274q06 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN274
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin274.i RowObject}
/*{inbo/boin274.i tt-ordem-compra}*/

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{cdp/cdcfgmat.i}
DEF QUERY {&QueryName} FOR {&TableName}, proc-compra SCROLLING.

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* local variable definitions */
DEFINE VARIABLE i-nr-processo-ini  LIKE ordem-compra.nr-processo NO-UNDO.
DEFINE VARIABLE i-nr-processo-fim  LIKE ordem-compra.nr-processo NO-UNDO.
DEFINE VARIABLE i-numero-ordem-ini LIKE ordem-compra.nr-processo NO-UNDO.
DEFINE VARIABLE i-numero-ordem-fim LIKE ordem-compra.nr-processo NO-UNDO.

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
         HEIGHT             = 22.42
         WIDTH              = 35.72.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existeCotacaoEnviada DBOProgram 
PROCEDURE existeCotacaoEnviada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER l-existe AS LOGICAL NO-UNDO.

    IF CAN-FIND(FIRST cotacao-item NO-LOCK 
                WHERE cotacao-item.numero-ordem  = pi-numero-ordem 
                  AND cotacao-item.ind-via-envio = 17) THEN 
        ASSIGN l-existe = YES.
    ELSE 
        ASSIGN l-existe = NO.                  
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existeCotacaoRetornada DBOProgram 
PROCEDURE existeCotacaoRetornada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                 
    DEFINE INPUT  PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER l-existe AS LOGICAL NO-UNDO.

    IF CAN-FIND(FIRST cotacao-item NO-LOCK 
                WHERE cotacao-item.numero-ordem  = pi-numero-ordem 
                  AND cotacao-item.ind-orig-entrada = 17) THEN 
        ASSIGN l-existe = YES.
    ELSE 
        ASSIGN l-existe = NO.                  

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
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "dep-almoxar":U THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "requisitante":U THEN ASSIGN pFieldValue = RowObject.requisitante.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "dat-ordem":U THEN ASSIGN pFieldValue = RowObject.dat-ordem.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
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
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-orig":U THEN ASSIGN pFieldValue = RowObject.preco-orig.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-acum-dev":U THEN ASSIGN pFieldValue = RowObject.qt-acum-dev.
        WHEN "qt-acum-nec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
        WHEN "qt-acum-rec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-rec.
        WHEN "qt-solic":U THEN ASSIGN pFieldValue = RowObject.qt-solic.
        WHEN "saldo-emb":U THEN ASSIGN pFieldValue = RowObject.saldo-emb.
        WHEN "saldo-gi":U THEN ASSIGN pFieldValue = RowObject.saldo-gi.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "cota-ordem":U THEN ASSIGN pFieldValue = RowObject.cota-ordem.
    &IF "{&mguni_version}" >= "2.071" &THEN
    &ELSE
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
    &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "linha":U THEN ASSIGN pFieldValue = RowObject.linha.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-preco":U THEN ASSIGN pFieldValue = RowObject.nr-alt-preco.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-ord-orig":U THEN ASSIGN pFieldValue = RowObject.nr-ord-orig.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-seq-contr":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "ordem-servic":U THEN ASSIGN pFieldValue = RowObject.ordem-servic.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "origem-aprov":U THEN ASSIGN pFieldValue = RowObject.origem-aprov.
        WHEN "pend-aprov":U THEN ASSIGN pFieldValue = RowObject.pend-aprov.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-ordem-contrat":U THEN ASSIGN pFieldValue = RowObject.sit-ordem-contrat.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.

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
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "gera-edi":U THEN ASSIGN pFieldValue = RowObject.gera-edi.
        WHEN "impr-ficha":U THEN ASSIGN pFieldValue = RowObject.impr-ficha.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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
  Purpose:     Reposiciona registro com base no ¡ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    for FIRST bfordem-compra fields(numero-ordem it-codigo) WHERE 
        bfordem-compra.numero-ordem = pnumero-ordem NO-LOCK: end.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordem-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrProcesso DBOProgram 
PROCEDURE openQueryByNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
                                       WHERE {&tableName}.nr-processo >= i-nr-processo-ini
                                         AND {&tableName}.nr-processo <= i-nr-processo-fim,
                                       FIRST proc-compra NO-LOCK
                                       WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                         AND proc-compra.log-proces-pregao INDEXED-REPOSITION.
        &ELSE        
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
                                       WHERE {&tableName}.nr-processo >= i-nr-processo-ini
                                         AND {&tableName}.nr-processo <= i-nr-processo-fim,
                                       FIRST proc-compra NO-LOCK
                                       WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                         AND SUBSTRING(proc-compra.char-1,4,1) = "1" INDEXED-REPOSITION.
        &ENDIF
    &ENDIF
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
                                       WHERE {&tableName}.numero-ordem >= i-numero-ordem-ini
                                         AND {&tableName}.numero-ordem <= i-numero-ordem-fim,
                                       FIRST proc-compra NO-LOCK
                                       WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                         AND proc-compra.log-proces-pregao INDEXED-REPOSITION.
        &ELSE        
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK
                                       WHERE {&tableName}.numero-ordem >= i-numero-ordem-ini
                                         AND {&tableName}.numero-ordem <= i-numero-ordem-fim,
                                       FIRST proc-compra NO-LOCK
                                       WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                         AND SUBSTRING(proc-compra.char-1,4,1) = "1" INDEXED-REPOSITION.
        &ENDIF
    &ENDIF
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemPregao DBOProgram 
PROCEDURE openQueryOrdemPregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK,
                                        FIRST proc-compra NO-LOCK
                                        WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                          AND proc-compra.log-proces-pregao INDEXED-REPOSITION.
        &ELSE        
            OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK ,
                                        FIRST proc-compra NO-LOCK
                                        WHERE proc-compra.nr-processo = {&tableName}.nr-processo 
                                          AND SUBSTRING(proc-compra.char-1,4,1) = "1" INDEXED-REPOSITION.
        &ENDIF
    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNrProcesso DBOProgram 
PROCEDURE setConstraintByNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-nr-processo-ini LIKE ordem-compra.nr-processo NO-UNDO.
    DEFINE INPUT PARAMETER pi-nr-processo-fim LIKE ordem-compra.nr-processo NO-UNDO.

    ASSIGN i-nr-processo-ini = pi-nr-processo-ini 
           i-nr-processo-fim = pi-nr-processo-fim.                  
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumeroOrdem DBOProgram 
PROCEDURE setConstraintByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-numero-ordem-ini LIKE ordem-compra.nr-processo NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem-fim LIKE ordem-compra.nr-processo NO-UNDO.

    ASSIGN i-numero-ordem-ini = pi-numero-ordem-ini  
           i-numero-ordem-fim = pi-numero-ordem-fim.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

