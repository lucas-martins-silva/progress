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
{include/i-prgvrs.i BOIN274Q01 2.00.00.021 } /*** "010021" 27/02/2026 15:26:34 ***/
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ì um programa PROGRESS
                 que contìm a l®gica de neg®cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiîÒo ---*/
&GLOBAL-DEFINE DBOName ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S« a DBO principal (boin274.p) est˜ com as fun¯´es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S¹ nela foram implementadas as triggers do dicion˜rio.
**  Para desabilitar as procedures foram usados os prý-processadores abaixo.
**  A procedure validateRecord dessa DBO nÊo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiîÒo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret®rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idªntico ao nome do DBO mas com
      extensÒo .i ---*/
{inbo/boin274.i RowObject}

/*--- Include com definiîÒo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraîÒo da definiîÒo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiîÒo
      manual da query ---*/
/*{method/dboqry.i}*/



/*
DEFINE QUERY {&QUERYNAME} for {&TABLENAME}, prazo-compra scrolling.*/

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-emitente NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente.

/* Include com prì-processadores que diferenciam releases */
{cdp/cdcfgmat.i}

/*--DefiniîÒo das variaveis das querys--*/
def var c-item         as char no-undo.
def var c-item-ini     as char no-undo. 
def var c-item-fim     as char no-undo.
def var c-estab-ini    as char no-undo. 
def var c-estab-fim    as char no-undo.
&if defined(bf_mat_contratos) &then
def var c-contrato-ini as int no-undo.
&else
def var c-contrato-ini as char no-undo.
&endif
&if defined(bf_mat_contratos) &then
def var c-contrato-fim as int no-undo.
&else
def var c-contrato-fim as char no-undo.
&endif
def var dt-entrega-var as date no-undo.
def var i-pedido-ini   as int  no-undo.
def var i-pedido-fim   as int  no-undo.
def var i-ordem-ini    as int  no-undo.
def var i-ordem-fim    as int  no-undo.
def var iNumOrdemIni     as int  no-undo.
def var iNumOrdemFim     as int  no-undo.
def var iEmitente        as int  no-undo. 
def var iNrProcesso      as int  no-undo.
def var iNumPedido       as int  no-undo.
def var iNatureza        as int  no-undo.
def var iCodCondPag      as int  no-undo.
def var iCodTransp       as int  no-undo.

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
/*&Scoped-define SECOND-TABLE-IN-QUERY-{&QueryName} prazo-compra
&Scoped-define REPOSITION-PROCEDURE-KEY-PHRASE TRUE NO-LOCK, ~
                            FIRST prazo-compra~
                            WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                            AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                            AND (prazo-compra.data-entrega <= dt-entrega-var) NO-LOCK*/

/* Definicao manual da Query */
&GLOBAL-DEFINE DEFINE-QUERY 1

{include/i-estab-security.i} 

DEFINE QUERY {&QUERYNAME} FOR tt-emitente, ordem-compra, tt_estab_ems2, prazo-compra SCROLLING.
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

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
         HEIGHT             = 8.25
         WIDTH              = 58.57.
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

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "dep-almoxar":U THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "requisitante":U THEN ASSIGN pFieldValue = RowObject.requisitante.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        &if defined(bf_mat_contratos) &then
        &else WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. &endif      
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
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

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
        WHEN "dat-ordem":U THEN ASSIGN pFieldValue = RowObject.dat-ordem.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
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

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
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
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
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

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "ordem-servic":U THEN ASSIGN pFieldValue = RowObject.ordem-servic.
        WHEN "cota-ordem":U THEN ASSIGN pFieldValue = RowObject.cota-ordem.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-ordem-contrat":U THEN ASSIGN pFieldValue = RowObject.sit-ordem-contrat.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "linha":U THEN ASSIGN pFieldValue = RowObject.linha.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "pend-aprov":U THEN ASSIGN pFieldValue = RowObject.pend-aprov.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-preco":U THEN ASSIGN pFieldValue = RowObject.nr-alt-preco.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif        
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-ord-orig":U THEN ASSIGN pFieldValue = RowObject.nr-ord-orig.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-seq-contr":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l©gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "impr-ficha":U THEN ASSIGN pFieldValue = RowObject.impr-ficha.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
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

    /*--- Verifica se temptable RowObject estë disponÑvel, caso não esteja serë
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
  Purpose:     Reposiciona registro com base no Ðndice COMPRADOR
  Parameters:
               recebe valor dos campos do Ðndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    for FIRST bfordem-compra fields(cod-comprado numero-ordem) WHERE
        bfordem-compra.cod-comprado = pcod-comprado AND
        bfordem-compra.numero-ordem = pnumero-ordem
        NO-LOCK: end.

    /*--- Verifica se registro foi encontrado, em caso de erro serÙ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordem-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravìs de rowid e verifica a ocorrªncia de erros, caso
          existam erros serÙ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
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
define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then
          RUN openQueryStatic (input "ByNumPedido":U).
        when 2 then
          RUN openQueryStatic (input "ByNumeroOrdem":U).
        when 3 then
          RUN openQueryStatic (input "ByItCodigo":U).
        when 4 then
          RUN openQueryStatic (input "ByNrContrato":U).          
    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItCodigo DBOProgram 
PROCEDURE openQueryByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*open query {&QUERYNAME} for each {&TABLENAME} where
                                      {&TABLENAME}.cod-emitente =   int(c-emite)        and 
                                      {&tablename}.it-codigo    >= c-item-ini           and
                                      {&TABLENAME}.situacao = 2                         and                                               
                                      {&tablename}.it-codigo    <= c-item-fim           and
                                      {&TABLENAME}.cod-estabel  >= c-estab-ini          and 
                                      {&TABLENAME}.cod-estabel  <= c-estab-fim          and
                                      ( ordem-compra.it-codigo = c-item or c-item = " ")no-lock,
                                FIRST prazo-compra WHERE 
                                      prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem and
                                     (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0) and
                                     (prazo-compra.data-entrega <= dt-entrega-var) NO-LOCK 
                                      by {&tablename}.it-codigo
                                      by {&TABLENAME}.numero-ordem 
                                &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                    INDEXED-REPOSITION
                                &endif.   */
    
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&tablename}.it-codigo    >= c-item-ini~
                             AND {&tablename}.it-codigo    <= c-item-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ), ~
                           FIRST tt_estab_ems2 NO-LOCK, ~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&tableName}.it-codigo~
                              BY {&TABLENAME}.numero-ordem~
                              BY {&tableName}.cod-estabel INDEXED-REPOSITION.

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT  ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&tablename}.it-codigo    >= c-item-ini~
                             AND {&tablename}.it-codigo    <= c-item-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ),~
                            EACH tt_estab_ems2 NO-LOCK ~
                           WHERE tt_estab_ems2.tta_cod_estab = {&TABLENAME}.cod-estabel,~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&tableName}.cod-estabel~
                              BY {&tableName}.it-codigo~
                              BY {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT
                              
    {include/i-estab-openquery.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrContrato DBOProgram 
PROCEDURE openQueryByNrContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* open query {&QUERYNAME} for each {&TABLENAME} where  
                                      {&TABLENAME}.cod-emitente =   int(c-emite)        and
                                      {&TABLENAME}.nr-contrato  >= c-contrato-ini       and
                                      ordem-compra.situacao = 2                         and
                                      {&TABLENAME}.nr-contrato  <= c-contrato-fim       and 
                                      {&TABLENAME}.cod-estabel  >= c-estab-ini          and 
                                      {&TABLENAME}.cod-estabel  <= c-estab-fim          and
                                      ( ordem-compra.it-codigo = c-item or c-item = " ") no-lock ,
                                FIRST prazo-compra WHERE 
                                      prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem and
                                      prazo-compra.situacao <> 4 and
                                      prazo-compra.data-entrega <= dt-entrega-var NO-LOCK 
                                      by {&TABLENAME}.nr-contrato
                                      BY {&TABLENAME}.numero-ordem
                                &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                    INDEXED-REPOSITION
                                &endif.    */

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.nr-contrato  >= c-contrato-ini~
                             AND {&TABLENAME}.nr-contrato  <= c-contrato-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ), ~
                           FIRST tt_estab_ems2 NO-LOCK, ~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND prazo-compra.situacao <> 4~
                             AND prazo-compra.data-entrega <= dt-entrega-var ~
                              BY {&tableName}.nr-contrato~
                              BY {&TABLENAME}.numero-ordem~
                              BY {&tableName}.cod-estabel INDEXED-REPOSITION.

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT  ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.nr-contrato  >= c-contrato-ini~
                             AND {&TABLENAME}.nr-contrato  <= c-contrato-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ),~
                            EACH tt_estab_ems2 NO-LOCK ~
                           WHERE tt_estab_ems2.tta_cod_estab = {&TABLENAME}.cod-estabel,~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND prazo-compra.situacao <> 4~
                             AND prazo-compra.data-entrega <= dt-entrega-var ~
                              BY {&tableName}.cod-estabel~
                              BY {&tableName}.nr-contrato~
                              BY {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT

    {include/i-estab-openquery.i}                             

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
   /* open query {&QUERYNAME} for each {&TABLENAME} where 
                                      {&TABLENAME}.cod-emitente =   int(c-emite)         and
                                      {&TABLENAME}.numero-ordem >= i-ordem-ini           and
                                      {&TABLENAME}.situacao = 2                          and                                            
                                      {&TABLENAME}.numero-ordem <= i-ordem-fim           and
                                      {&TABLENAME}.cod-estabel  >= c-estab-ini           and 
                                      {&TABLENAME}.cod-estabel  <= c-estab-fim           and
                                      ( ordem-compra.it-codigo = c-item or c-item = " ") no-lock ,
                                FIRST prazo-compra WHERE 
                                      prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem and
                                     (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0) and
                                     (prazo-compra.data-entrega <= dt-entrega-var) NO-LOCK 
                                      by {&TABLENAME}.numero-ordem 
                                &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                    INDEXED-REPOSITION
                                &endif.    */

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.numero-ordem >= i-ordem-ini~
                             AND {&TABLENAME}.numero-ordem <= i-ordem-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ), ~
                           FIRST tt_estab_ems2 NO-LOCK, ~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&TABLENAME}.numero-ordem~
                              BY {&tableName}.cod-estabel INDEXED-REPOSITION.

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT  ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.numero-ordem >= i-ordem-ini~
                             AND {&TABLENAME}.numero-ordem <= i-ordem-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ),~
                            EACH tt_estab_ems2 NO-LOCK ~
                           WHERE tt_estab_ems2.tta_cod_estab = {&TABLENAME}.cod-estabel,~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&tableName}.cod-estabel~
                              BY {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT

    {include/i-estab-openquery.i}                                
                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumPedido DBOProgram 
PROCEDURE openQueryByNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     /*     &Scoped-define KEY-PHRASE {&TABLENAME}.cod-emitente =   int(c-emite)~
                          AND {&TABLENAME}.num-pedido  >= i-pedido-ini~
                          AND {&TABLENAME}.situacao     = 2~
                          AND {&TABLENAME}.num-pedido  <= i-pedido-fim~
                          AND {&TABLENAME}.cod-estabel >= c-estab-ini~
                          AND {&TABLENAME}.cod-estabel <= c-estab-fim~
                          AND ({&tablename}.it-codigo = c-item or c-item = " " ) NO-LOCK,~
                        FIRST prazo-compra~
                        WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                          AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                          AND (prazo-compra.data-entrega <= dt-entrega-var) NO-LOCK */

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.num-pedido   >= i-pedido-ini~
                             AND {&TABLENAME}.num-pedido   <= i-pedido-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ), ~
                           FIRST tt_estab_ems2 NO-LOCK, ~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&TABLENAME}.num-pedido~
                              BY {&TABLENAME}.numero-ordem~
                              BY {&tableName}.cod-estabel INDEXED-REPOSITION.

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT  ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK, ~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.situacao      = 2~
                             AND {&TABLENAME}.num-pedido >= i-pedido-ini~
                             AND {&TABLENAME}.num-pedido <= i-pedido-fim~
                             AND {&TABLENAME}.cod-estabel  >= c-estab-ini~
                             AND {&TABLENAME}.cod-estabel  <= c-estab-fim~
                             AND ( ordem-compra.it-codigo = c-item or c-item = " " ),~
                            EACH tt_estab_ems2 NO-LOCK ~
                           WHERE tt_estab_ems2.tta_cod_estab = {&TABLENAME}.cod-estabel,~
                           FIRST prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem~
                             AND (prazo-compra.situacao = 2 and (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0)~
                             AND (prazo-compra.data-entrega <= dt-entrega-var)~
                              BY {&tableName}.cod-estabel~
                              BY {&TABLENAME}.num-pedido~
                              BY {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT

    {include/i-estab-openquery.i}
                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRelacionamento DBOProgram 
PROCEDURE openQueryRelacionamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                 {&TABLENAME}.cod-emitente = iEmitente     and
                                 {&TABLENAME}.natureza     = iNatureza     and
                                 {&TABLENAME}.cod-cond-pag = iCodCondPag   and
                                 {&TABLENAME}.nr-processo  = iNrProcesso   and
                                 {&TABLENAME}.cod-transp   = iCodTransp    and
                                 {&TABLENAME}.num-pedido   = 0             and
                                 {&TABLENAME}.situacao     = 3             and
                                 {&TABLENAME}.expectativa  = no            and 
                                 {&TABLENAME}.numero-ordem >= iNumOrdemIni and
                                 {&TABLENAME}.numero-ordem <= iNumOrdemFim
                                 NO-LOCK,
                            EACH prazo-compra WHERE
                                 prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem 
                                 NO-LOCK 
                            &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                                INDEXED-REPOSITION
                            &endif.    */

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK ~
                           WHERE tt-emitente.cod-emitente   = iEmitente,~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.natureza      = iNatureza~
                             AND {&TABLENAME}.cod-cond-pag  = iCodCondPag~
                             AND {&TABLENAME}.nr-processo   = iNrProcesso~
                             AND {&TABLENAME}.cod-transp    = iCodTransp~
                             AND {&TABLENAME}.num-pedido    = 0~
                             AND {&TABLENAME}.situacao      = 3~
                             AND {&TABLENAME}.expectativa   = NO~
                             AND {&TABLENAME}.numero-ordem  >= iNumOrdemIni~
                             AND {&TABLENAME}.numero-ordem  <= iNumOrdemFim,~
                           FIRST tt_estab_ems2 NO-LOCK, ~
                            EACH prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT  ~
                OPEN QUERY {&MY-QUERY}  ~
                        FOR EACH tt-emitente NO-LOCK ~
                           WHERE tt-emitente.cod-emitente   = iEmitente,~
                            EACH {&TABLENAME} NO-LOCK ~
                           WHERE {&TABLENAME}.cod-emitente  = tt-emitente.cod-emitente~
                             AND {&TABLENAME}.natureza      = iNatureza~
                             AND {&TABLENAME}.cod-cond-pag  = iCodCondPag~
                             AND {&TABLENAME}.nr-processo   = iNrProcesso~
                             AND {&TABLENAME}.cod-transp    = iCodTransp~
                             AND {&TABLENAME}.num-pedido    = 0~
                             AND {&TABLENAME}.situacao      = 3~
                             AND {&TABLENAME}.expectativa   = NO~
                             AND {&TABLENAME}.numero-ordem  >= iNumOrdemIni~
                             AND {&TABLENAME}.numero-ordem  <= iNumOrdemFim,~
                            EACH tt_estab_ems2 NO-LOCK ~
                           WHERE tt_estab_ems2.tta_cod_estab = {&TABLENAME}.cod-estabel,~
                            EACH prazo-compra NO-LOCK ~
                           WHERE prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

    &Scoped-define BY-ESTAB-IN
    &Scoped-define BY-ESTAB-AT

    {include/i-estab-openquery.i}                              
                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
def input param p-pedido-ini   as char no-undo.
def input param p-pedido-fim   as char no-undo.
def input param p-ordem-ini    as char no-undo.
def input param p-ordem-fim    as char no-undo.
def input param p-item-ini     as char no-undo. 
def input param p-item-fim     as char no-undo.
&if defined(bf_mat_contratos) &then
def input param p-contrato-ini     as int no-undo.
&else
def input param p-contrato-ini     as char no-undo.
&endif
&if defined(bf_mat_contratos) &then
def input param p-contrato-fim     as int no-undo.
&else
def input param p-contrato-fim     as char no-undo.
&endif

    run setconstraintByNumPedido (input p-seg-usuario,
                                  input p-pedido-ini,
                                  input p-pedido-fim,
                                  input p-ordem-ini,
                                  input p-ordem-fim,
                                  input p-item-ini,
                                  input p-item-fim,
                                  input p-contrato-ini,
                                  input p-contrato-fim).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByContrato DBOProgram 
PROCEDURE setconstraintByContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
&if defined(bf_mat_contratos) &then
def input param p-contrato-ini     as int no-undo.
&else
def input param p-contrato-ini     as char no-undo.
&endif
&if defined(bf_mat_contratos) &then
def input param p-contrato-fim     as int no-undo.
&else
def input param p-contrato-fim     as char no-undo.
&endif
def input param p-estab-ini    as char no-undo.
def input param p-estab-fim    as char no-undo.
def input param p-emitente     as char no-undo.
def input param p-item         as char no-undo.

 for first param-re fields(usuario variacao log-ped-mesma-matriz) where 
     param-re.usuario = p-seg-usuario no-lock: end.     

  assign dt-entrega-var = today + param-re.variacao
         &if defined(bf_mat_contratos) &then
           c-contrato-ini = p-contrato-ini.
         &else
           c-contrato-ini = p-contrato-ini.
         &endif          
         &if defined(bf_mat_contratos) &then
           c-contrato-fim = p-contrato-fim.
         &else
           c-contrato-fim = p-contrato-fim.
         &endif          
   assign c-estab-ini    = p-estab-ini
          c-estab-fim    = p-estab-fim
          c-item         = p-item.

   RUN carregaTTemitente (INPUT param-re.log-ped-mesma-matriz,
                          INPUT INT(p-emitente)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByContrato2 DBOProgram 
PROCEDURE setconstraintByContrato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
&if defined(bf_mat_contratos) &then
def input param p-contrato-ini     as int no-undo.
&else
def input param p-contrato-ini     as char no-undo.
&endif
&if defined(bf_mat_contratos) &then
def input param p-contrato-fim     as int no-undo.
&else
def input param p-contrato-fim     as char no-undo.
&endif
def input param p-estab-ini    as char no-undo.
def input param p-estab-fim    as char no-undo.
def input param p-emitente     as char no-undo.
def input param p-item         as char no-undo.

 for first param-re fields(usuario variacao log-ped-mesma-matriz) where 
     param-re.usuario = p-seg-usuario no-lock: end.     

  assign dt-entrega-var = today + param-re.variacao
         &if defined(bf_mat_contratos) &then
           c-contrato-ini = 1.
         &else
           c-contrato-ini = p-contrato-ini.
         &endif          
         &if defined(bf_mat_contratos) &then
           c-contrato-fim = p-contrato-fim.
         &else
           c-contrato-fim = p-contrato-fim.
         &endif          
   assign c-estab-ini    = p-estab-ini
          c-estab-fim    = p-estab-fim
          c-item         = p-item.

   RUN carregaTTemitente (INPUT param-re.log-ped-mesma-matriz,
                          INPUT INT(p-emitente)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByItem DBOProgram 
PROCEDURE setconstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
def input param p-item-ini     as char no-undo. 
def input param p-item-fim     as char no-undo.
def input param p-estab-ini    as char no-undo.
def input param p-estab-fim    as char no-undo.
def input param p-emitente     as char no-undo.
def input param p-item         as char no-undo.

 for first param-re fields(usuario variacao log-ped-mesma-matriz) where 
     param-re.usuario = p-seg-usuario no-lock: end.     
 assign dt-entrega-var = today + param-re.variacao
        c-item-ini     = p-item-ini
        c-item-fim     = p-item-fim
        c-estab-ini    = p-estab-ini
        c-estab-fim    = p-estab-fim
        c-item         = p-item.  

 RUN carregaTTemitente (INPUT param-re.log-ped-mesma-matriz,
                        INPUT INT(p-emitente)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByOrdem DBOProgram 
PROCEDURE setconstraintByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
def input param p-ordem-ini    as char no-undo.
def input param p-ordem-fim    as char no-undo.
def input param p-estab-ini    as char no-undo.
def input param p-estab-fim    as char no-undo.
def input param p-emitente     as char no-undo.
def input param p-item         as char no-undo.

 for first param-re fields(usuario variacao log-ped-mesma-matriz) where 
     param-re.usuario = p-seg-usuario no-lock: end.     
 assign dt-entrega-var = today + param-re.variacao
        i-ordem-ini    = int(p-ordem-ini)
        i-ordem-fim    = int(p-ordem-fim)
        c-estab-ini    = p-estab-ini
        c-estab-fim    = p-estab-fim
        c-item         = p-item.  

 RUN carregaTTemitente (INPUT param-re.log-ped-mesma-matriz,
                        INPUT INT(p-emitente)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByPedido DBOProgram 
PROCEDURE setconstraintByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-seg-usuario  as char no-undo.
def input param p-pedido-ini   as char no-undo.
def input param p-pedido-fim   as char no-undo.
def input param p-estab-ini    as char no-undo.
def input param p-estab-fim    as char no-undo.
def input param p-emitente     as char no-undo.
def input param p-item         as char no-undo.

for first param-re fields(usuario variacao log-ped-mesma-matriz) where 
    param-re.usuario = p-seg-usuario no-lock: end.     
 assign dt-entrega-var = today + param-re.variacao
        i-pedido-ini   = int(p-pedido-ini)
        i-pedido-fim   = int(p-pedido-fim)
        c-estab-ini    = p-estab-ini
        c-estab-fim    = p-estab-fim
        c-item         = p-item.  

 RUN carregaTTemitente (INPUT param-re.log-ped-mesma-matriz,
                        INPUT INT(p-emitente)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRelacionamento DBOProgram 
PROCEDURE setConstraintRelacionamento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    def input parameter piEmit        as int  no-undo.
    def input parameter piNatureza    as int  no-undo.
    def input parameter piCodCondPag  as int  no-undo.
    def input parameter piNrProcesso  as int  no-undo.
    def input parameter piCodTransp   as int  no-undo.
    def input parameter piNumOrdemIni as int  no-undo.
    def input parameter piNumOrdemFim as int  no-undo.

    assign 
    iEmitente    = piEmit 
    iNatureza    = piNatureza
    iCodCondPag  = piCodCondPag
    iNrProcesso  = piNrProcesso
    iCodTransp   = piCodTransp
    iNumOrdemIni = piNumOrdemIni
    iNumOrdemFim = piNumOrdemFim.

    RUN carregaTTemitente (INPUT NO,
                           INPUT piEmit).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRelacionamento DBOProgram 
PROCEDURE carregaTTemitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    def input parameter l-ped-mesma-matriz as LOG  no-undo.
    def input parameter i-emitente         as int  no-undo.

    def var c-abrev-matriz   as char no-undo.

    EMPTY TEMP-TABLE tt-emitente.
    if l-ped-mesma-matriz then do:
        for first emitente fields (nome-matriz)
            where emitente.cod-emitente = i-emitente no-lock:
            assign c-abrev-matriz = emitente.nome-matriz.
        end.
        for each emitente fields (cod-emitente) no-lock
           where emitente.nome-matriz = c-abrev-matriz: 
            CREATE tt-emitente.
            ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente.
        end. 
    end.
    else do:
        CREATE tt-emitente.
        ASSIGN tt-emitente.cod-emitente = i-emitente.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
