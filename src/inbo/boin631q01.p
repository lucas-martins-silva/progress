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
{include/i-prgvrs.i BOIN631Q01 2.00.00.009} /*** "010009" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN631Q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName doc-pend-aprov
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName doc-pend-aprov
&GLOBAL-DEFINE TableLabel doc-pend-aprov
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin631q01.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} for {&TableName}, usuar-mater scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var cCodAprov        as char  no-undo.
def var cItCodigoIni     as char  no-undo.
def var cItCodigoFim     as char  no-undo.
def var iNrRequisicaoIni as inte  no-undo.
def var iNrRequisicaoFim as inte  no-undo.
def var dtGeracaoIni     as date  no-undo.
def var dtGeracaoFim     as date  no-undo.
def var dtRejeitaIni     as date  no-undo.
def var dtRejeitaFim     as date  no-undo.
def var iSituacaoPend    as inte  no-undo.
def var iTpRequis        as inte  no-undo.
def var cFamiliaIni      as char  no-undo.
def var cFamiliaFim      as char  no-undo.
def var cCentroCustoIni  as char  no-undo.
def var cCentroCustoFim  as char  no-undo.
def var iTipDoc          as inte  no-undo.
def var iCodEmitenteIni  as inte  no-undo.
def var iCodEmitenteFim  as inte  no-undo.
def var iNumeroOrdemIni  as inte  no-undo.
def var iNumeroOrdemFim  as inte  no-undo.
def var iPedidoIni       as inte  no-undo. 
def var iPedidoFim       as inte  no-undo.
def var iNrProcessoIni   as inte  no-undo.
def var iNrProcessoFim   as inte  no-undo.
def var iNrContratoIni   as inte  no-undo.
def var iNrContratoFim   as inte  no-undo.
def var iSeqItemIni      as inte  no-undo.
def var iSeqItemFim      as inte  no-undo.
def var iSeqEventoIni    as inte  no-undo.
def var iSeqEventoFim    as inte  no-undo.
def var iSeqMedicaoIni   as inte  no-undo.
def var iSeqMedicaoFim   as inte  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram

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
         HEIGHT             = 2.01
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa-apr":U THEN ASSIGN pFieldValue = RowObject.narrativa-apr.
        WHEN "narrativa-rej":U THEN ASSIGN pFieldValue = RowObject.narrativa-rej.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-aprov.
        WHEN "cod-aprov-altern":U THEN ASSIGN pFieldValue = RowObject.cod-aprov-altern.
        WHEN "cod-rej":U THEN ASSIGN pFieldValue = RowObject.cod-rej.
        WHEN "cod-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-tip-aprov.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-aprova":U THEN ASSIGN pFieldValue = RowObject.dt-aprova.
        WHEN "dt-geracao":U THEN ASSIGN pFieldValue = RowObject.dt-geracao.
        WHEN "dt-reaprova":U THEN ASSIGN pFieldValue = RowObject.dt-reaprova.
        WHEN "dt-rejeita":U THEN ASSIGN pFieldValue = RowObject.dt-rejeita.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ind-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.ind-tip-aprov.
        WHEN "ind-tip-doc":U THEN ASSIGN pFieldValue = RowObject.ind-tip-doc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-faixa":U THEN ASSIGN pFieldValue = RowObject.num-faixa.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "seq-aprov":U THEN ASSIGN pFieldValue = RowObject.seq-aprov.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        WHEN "seq-medicao":U THEN ASSIGN pFieldValue = RowObject.seq-medicao.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice DOC-PEND-APROV-6
  Parameters:
               retorna valor dos campos do ¡ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-aprov = RowObject.cod-aprov.
    ASSIGN pind-tip-doc = RowObject.ind-tip-doc.

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
               retorna status do processo
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
        WHEN "sit-aprov":U THEN ASSIGN pFieldValue = RowObject.sit-aprov.
        WHEN "aprov-auto":U THEN ASSIGN pFieldValue = RowObject.aprov-auto.
        WHEN "aprov-tec":U THEN ASSIGN pFieldValue = RowObject.aprov-tec.
        WHEN "aprov-total":U THEN ASSIGN pFieldValue = RowObject.aprov-total.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
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
  Purpose:     Reposiciona registro com base no ¡ndice DOC-PEND-APROV-6
  Parameters:
               recebe valor dos campos do ¡ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE INPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    FIND FIRST bfdoc-pend-aprov WHERE
        bfdoc-pend-aprov.cod-aprov = pcod-aprov AND
        bfdoc-pend-aprov.ind-tip-doc = pind-tip-doc
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-pend-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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
    OPEN QUERY {&QueryName} FOR EACH doc-pend-aprov,
                               FIRST    usuar-mater WHERE 
                                        usuar-mater.cod-usuario    = doc-pend-aprov.cod-usuario
                                        NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAprovador DBOProgram 
PROCEDURE setConstraintAprovador:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcCodAprov        as  char no-undo.
    def input param pcItCodigoIni     as  char no-undo.
    def input param pcItCodigoFim     as  char no-undo.
    def input param piNrRequisicaoIni as  inte no-undo.
    def input param piNrRequisicaoFim as  inte no-undo.    
    def input param piNumeroOrdemIni  as  inte no-undo.
    def input param piNumeroOrdemFim  as  inte no-undo.
    def input param piCodEmitenteIni  as  inte no-undo.
    def input param piCodEmitenteFim  as  inte no-undo.
    def input param piPedidoIni       as  inte no-undo.
    def input param piPedidoFim       as  inte no-undo.    
    def input param pdtGeracaoIni     as  date no-undo.
    def input param pdtGeracaoFim     as  date no-undo.
    def input param pdtRejeitaIni     as  date no-undo.
    def input param pdtRejeitaFim     as  date no-undo.
    def input param piSituacaoPend    as  inte no-undo.
    def input param pcCentroCustoIni  as  char no-undo.
    def input param pcCentroCustoFim  as  char no-undo.
    def input param piNrProcessoIni   as  inte no-undo.
    def input param piNrProcessoFim   as  inte no-undo. 
    def input param piNrContratoIni   as  inte no-undo.
    def input param piNrContratoFim   as  inte no-undo.     
    def input param piTipDoc          as  inte no-undo.
    def input param piSeqItemIni      as  inte no-undo.
    def input param piSeqItemFim      as  inte no-undo.
    def input param piSeqEventoIni    as  inte no-undo.
    def input param piSeqEventoFim    as  inte no-undo.
    def input param piSeqMedicaoIni   as  inte no-undo.
    def input param piSeqMedicaoFim   as  inte no-undo.    
    
    assign cCodAprov        = pcCodAprov       
           cItCodigoIni     = pcItCodigoIni    
           cItCodigoFim     = pcItCodigoFim    
           iNrRequisicaoIni = piNrRequisicaoIni
           iNrRequisicaoFim = piNrRequisicaoFim           
           iNumeroOrdemIni  = piNumeroOrdemIni
           iNumeroOrdemFim  = piNumeroOrdemFim
           iCodEmitenteIni  = piCodEmitenteIni
           iCodEmitenteFim  = piCodEmitenteFim
           iPedidoIni       = piPedidoIni
           iPedidoFim       = piPedidoFim 
           dtGeracaoIni     = pdtGeracaoIni    
           dtGeracaoFim     = pdtGeracaoFim    
           dtRejeitaIni     = pdtRejeitaIni    
           dtRejeitaFim     = pdtRejeitaFim    
           iSituacaoPend    = piSituacaoPend
           cCentroCustoIni  = pcCentroCustoIni 
           cCentroCustoFim  = pcCentroCustoFim
           iNrProcessoIni   = piNrProcessoIni
           iNrProcessoFim   = piNrProcessoFim
           iNrContratoIni   = piNrContratoIni
           iNrContratoFim   = piNrContratoFim
           iTipDoc          = piTipDoc
           iSeqItemIni      = piSeqItemIni   
           iSeqItemFim      = piSeqItemFim   
           iSeqEventoIni    = piSeqEventoIni 
           iSeqEventoFim    = piSeqEventoFim 
           iSeqMedicaoIni   = piSeqMedicaoIni
           iSeqMedicaoFim   = piSeqMedicaoFim.   

    RETURN "OK":U.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador1 DBOProgram 
PROCEDURE openQueryAprovador1:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.nr-requisicao
                                            by doc-pend-aprov.sequencia.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov where
                                            doc-pend-aprov.cod-aprov      = cCodAprov     and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc       and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.nr-requisicao
                                            by doc-pend-aprov.sequencia.
    END.
    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador1_01 DBOProgram 
PROCEDURE openQueryAprovador1_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador1_02 DBOProgram 
PROCEDURE openQueryAprovador1_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.dt-geracao.
    END.


    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador1_03 DBOProgram 
PROCEDURE openQueryAprovador1_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.prioridade DESCENDING.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov    and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc      and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.prioridade DESCENDING.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador3 DBOProgram 
PROCEDURE openQueryAprovador3:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.numero-ordem.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.numero-ordem.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador3_01 DBOProgram 
PROCEDURE openQueryAprovador3_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador3_02 DBOProgram 
PROCEDURE openQueryAprovador3_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador3_03 DBOProgram 
PROCEDURE openQueryAprovador3_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador4 DBOProgram 
PROCEDURE openQueryAprovador4:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.num-pedido
                                            BY doc-pend-aprov.numero-ordem.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.num-pedido
                                            BY doc-pend-aprov.numero-ordem.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador4_01 DBOProgram 
PROCEDURE openQueryAprovador4_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador4_02 DBOProgram 
PROCEDURE openQueryAprovador4_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            by doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador4_03 DBOProgram 
PROCEDURE openQueryAprovador4_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.num-pedido    >= iPedidoIni       and
                                            doc-pend-aprov.num-pedido    <= iPedidoFim       and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador5 DBOProgram 
PROCEDURE openQueryAprovador5:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador5_01 DBOProgram 
PROCEDURE openQueryAprovador5_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador5_03 DBOProgram 
PROCEDURE openQueryAprovador5_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador7 DBOProgram 
PROCEDURE openQueryAprovador7:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.int-1.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.int-1.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador7_01 DBOProgram 
PROCEDURE openQueryAprovador7_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador7_02 DBOProgram 
PROCEDURE openQueryAprovador7_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador7_03 DBOProgram 
PROCEDURE openQueryAprovador7_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.int-1         >= iNrProcessoIni   and
                                            doc-pend-aprov.int-1         <= iNrProcessoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador8 DBOProgram 
PROCEDURE openQueryAprovador8:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and                                        
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.char-1
                                            by doc-pend-aprov.sequencia.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and                                        
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.char-1
                                            by doc-pend-aprov.sequencia.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador8_01 DBOProgram 
PROCEDURE openQueryAprovador8_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador8_02 DBOProgram 
PROCEDURE openQueryAprovador8_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador8_03 DBOProgram 
PROCEDURE openQueryAprovador8_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and                                        
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and                                        
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9 DBOProgram 
PROCEDURE openQueryAprovador9:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.nr-requisicao
                                            by doc-pend-aprov.sequencia.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.nr-requisicao
                                            by doc-pend-aprov.sequencia.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_01 DBOProgram 
PROCEDURE openQueryAprovador9_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_02 DBOProgram 
PROCEDURE openQueryAprovador9_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_03 DBOProgram 
PROCEDURE openQueryAprovador9_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador10 DBOProgram 
PROCEDURE openQueryAprovador10:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-item.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-item.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_01 DBOProgram 
PROCEDURE openQueryAprovador10_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_02 DBOProgram 
PROCEDURE openQueryAprovador10_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_03 DBOProgram 
PROCEDURE openQueryAprovador10_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9 DBOProgram 
PROCEDURE openQueryAprovador11:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-evento.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-evento.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_01 DBOProgram 
PROCEDURE openQueryAprovador11_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)   and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)   and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_02 DBOProgram 
PROCEDURE openQueryAprovador11_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_03 DBOProgram 
PROCEDURE openQueryAprovador11_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and
                                            doc-pend-aprov.seq-evento    >= iSeqEventoIni and
                                            doc-pend-aprov.seq-evento    <= iSeqEventoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9 DBOProgram 
PROCEDURE openQueryAprovador12:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-medicao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim)  and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.seq-medicao.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_01 DBOProgram 
PROCEDURE openQueryAprovador12_01:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.it-codigo.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_02 DBOProgram 
PROCEDURE openQueryAprovador12_02:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim    and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni no-lock
                                            BY doc-pend-aprov.dt-geracao.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAprovador9_03 DBOProgram 
PROCEDURE openQueryAprovador12_03:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF iSituacaoPend = 5 THEN DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH    doc-pend-aprov  where
                                            doc-pend-aprov.cod-aprov      = cCodAprov        and
                                            doc-pend-aprov.ind-situacao   = iSituacaoPend AND
                                            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
                                            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
                                            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
                                            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
                                            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
                                            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
                                            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
                                            doc-pend-aprov.nr-contrato   >= iNrContratoIni   and
                                            doc-pend-aprov.nr-contrato   <= iNrContratoFim   and 
                                            doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni and
                                            doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim and                                         
                                            doc-pend-aprov.dt-geracao    >= (if dtGeracaoIni = ? then
                                                                            doc-pend-aprov.dt-geracao else
                                                                            dtGeracaoIni)   and
                                            doc-pend-aprov.dt-geracao    <= dtGeracaoFim and
                                            doc-pend-aprov.dt-rejeita    >= ( if dtRejeitaIni = ? then
                                                                            doc-pend-aprov.dt-rejeita else
                                                                            dtRejeitaIni )   and
                                            doc-pend-aprov.dt-rejeita    <= ( if doc-pend-aprov.dt-rejeita = ?
                                                                            then ? 
                                                                            else dtRejeitaFim) and 
                                            doc-pend-aprov.seq-evento  >= iSeqEventoIni  and
                                            doc-pend-aprov.seq-evento  <= iSeqEventoFim  and
                                            doc-pend-aprov.seq-item    >= iSeqItemIni    and
                                            doc-pend-aprov.seq-item    <= iSeqItemFim    and
                                            doc-pend-aprov.seq-medicao >= iSeqMedicaoIni and
                                            doc-pend-aprov.seq-medicao <= iSeqMedicaoFim NO-LOCK,
                                   FIRST    usuar-mater WHERE 
                                            usuar-mater.cod-usuario           = doc-pend-aprov.cod-usuario AND
                                            substring(usuar-mater.char-1,2,8) <= cCentroCustoFim           and
                                            substring(usuar-mater.char-1,2,8) >= cCentroCustoIni           no-lock
                                            BY doc-pend-aprov.prioridade descending.
    END.

    RETURN "OK":U.
END PROCEDURE.                                                                   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

