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
{include/i-prgvrs.i BOIN631Q02 2.00.00.006} /*** "010006" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN631Q02 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName tt-doc-pend-aprov
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-doc-pend-aprov
&GLOBAL-DEFINE TableLabel tt-doc-pend-aprov
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin631q02.i tt-doc-pend-aprov}
{inbo/boin631q02.i RowObject}

{cdp/cdcfgren.i} /* Identifica se o programa est† sendo executado na
                    Grendene */
                                  
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/*DEFINE QUERY {&QueryName} for {&TableName}, aprov-altern scrolling.*/

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-tt-doc-pend-aprov FOR tt-doc-pend-aprov.

def temp-table tt-aprov
    field cod-aprov like doc-pend-aprov.cod-aprov.

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
def var cNrContratoIni   as char  no-undo.
def var cNrContratoFim   as char  no-undo.
def var lSomenteAltern   as logi  no-undo.

DEF VAR c-navigation AS CHAR NO-UNDO.
DEF VAR i-seq-create AS INT  NO-UNDO.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa-apr":U THEN ASSIGN pFieldValue = RowObject.narrativa-apr.
        WHEN "narrativa-rej":U THEN ASSIGN pFieldValue = RowObject.narrativa-rej.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Retorna valores dos campos do °ndice DOC-PEND-APROV-6
  Parameters:
               retorna valor dos campos do °ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice DOC-PEND-APROV-6
  Parameters:
               recebe valor dos campos do °ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE INPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    FIND FIRST bftt-doc-pend-aprov WHERE
        bftt-doc-pend-aprov.cod-aprov = pcod-aprov AND
        bftt-doc-pend-aprov.ind-tip-doc = pind-tip-doc
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-doc-pend-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-doc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    /*--- Verifica ocorrància de erros ---*/
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
    def input param pcNrContratoIni   as  char no-undo.
    def input param pcNrContratoFim   as  char no-undo.     
    def input param piTipDoc          as  inte no-undo.
    def input param pSomenteAltern    as  log  no-undo.
    
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
           cNrContratoIni   = pcNrContratoIni
           cNrContratoFim   = pcNrContratoFim
           iTipDoc          = piTipDoc
           lSomenteAltern   = pSomenteAltern.

    RETURN "OK":U.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPrioridade DBOProgram 
PROCEDURE openQueryPrioridade:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH tt-doc-pend-aprov NO-LOCK  
                                  BY tt-doc-pend-aprov.prioridade DESCENDING.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPrioridade1 DBOProgram 
PROCEDURE openQueryPrioridade1:
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF  c-navigation = "Prev":U THEN
        OPEN QUERY {&QueryName} FOR EACH tt-doc-pend-aprov NO-LOCK
                                      BY tt-doc-pend-aprov.int-2 DESCENDING
                                      BY tt-doc-pend-aprov.prioridade DESCENDING.
    ELSE 
        OPEN QUERY {&QueryName} FOR EACH tt-doc-pend-aprov NO-LOCK  
                                      BY tt-doc-pend-aprov.int-2
                                      BY tt-doc-pend-aprov.prioridade DESCENDING.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao DBOProgram 
PROCEDURE carregaTTSolicitacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF QUERY q-doc-pend-aprov FOR doc-pend-aprov SCROLLING.
    
    DEF INPUT PARAM p-navigation AS CHAR NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-rowid  AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-rowid AS ROWID NO-UNDO.
    DEF INPUT PARAM p-num-browse AS INT NO-UNDO.

    DEF VAR r-first-rowid-tt AS ROWID NO-UNDO.
    DEF VAR r-last-rowid-tt  AS ROWID NO-UNDO.

    run carregaTTAprov.

    ASSIGN c-navigation = p-navigation.

    OPEN QUERY q-doc-pend-aprov 
        FOR EACH  doc-pend-aprov &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                     USE-INDEX aprov-prior
                                 &ELSE
                                     USE-INDEX doc-pend-aprov-6
                                 &ENDIF
            WHERE doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    
              AND doc-pend-aprov.ind-tip-doc    = iTipDoc          
              AND doc-pend-aprov.ind-situacao   = (IF  iSituacaoPend < 5 THEN iSituacaoPend 
                                                   ELSE doc-pend-aprov.ind-situacao ) 
              AND doc-pend-aprov.dt-geracao    >= (IF  dtGeracaoIni = ? THEN doc-pend-aprov.dt-geracao 
                                                   ELSE dtGeracaoIni)   
              AND doc-pend-aprov.dt-geracao    <= dtGeracaoFim 
              AND doc-pend-aprov.dt-rejeita    >= (IF  dtRejeitaIni = ? THEN doc-pend-aprov.dt-rejeita 
                                                   ELSE dtRejeitaIni )   
              AND doc-pend-aprov.dt-rejeita    <= (IF doc-pend-aprov.dt-rejeita = ? THEN ? 
                                                   ELSE dtRejeitaFim)
              AND doc-pend-aprov.it-codigo     >= cItCodigoIni     
              AND doc-pend-aprov.it-codigo     <= cItCodigoFim
              AND doc-pend-aprov.nr-requisicao >= iNrRequisicaoIni
              AND doc-pend-aprov.nr-requisicao <= iNrRequisicaoFim
              NO-LOCK
              /* BY doc-pend-aprov.cod-aprov
              BY doc-pend-aprov.ind-tip-doc
              BY doc-pend-aprov.ind-situacao
              BY doc-pend-aprov.prioridade DESCENDING */ INDEXED-REPOSITION.

    IF  p-last-rowid = ? 
    AND p-first-rowid = ? THEN
        GET FIRST q-doc-pend-aprov.
    ELSE DO:
        IF  p-navigation = "Prev":U THEN
            REPOSITION q-doc-pend-aprov TO ROWID p-first-rowid NO-ERROR.
        ELSE 
            REPOSITION q-doc-pend-aprov TO ROWID p-last-rowid NO-ERROR.

        GET NEXT q-doc-pend-aprov.
    END.
        
    IF  AVAIL doc-pend-aprov THEN
    DO  i-seq-create = 1 TO p-num-browse:
        
        ASSIGN r-first-rowid-tt = IF  r-first-rowid-tt = ? THEN 
                                      ROWID(doc-pend-aprov)
                                  ELSE
                                      r-first-rowid-tt
               r-last-rowid-tt  = ROWID(doc-pend-aprov).

        RUN carregaTT.

        IF  p-navigation = "prev":U THEN
            GET PREV q-doc-pend-aprov.
        ELSE
            GET NEXT q-doc-pend-aprov.

        IF  NOT AVAIL doc-pend-aprov THEN
            LEAVE.  
    END.
    

    /* Reorganiza os registros da temp-table pela prioridade 
    IF  p-navigation = "Prev":U THEN
        ASSIGN i-seq-create = 0.
    ELSE
        ASSIGN i-seq-create = 999.
    FOR EACH tt-doc-pend-aprov 
        BY tt-doc-pend-aprov.prioridade
        BY tt-doc-pend-aprov.nr-requisicao:

        IF  p-navigation = "Prev":U THEN
            ASSIGN i-seq-create = i-seq-create - 1.
        ELSE
            ASSIGN i-seq-create = i-seq-create + 1.
        CREATE b-tt-doc-pend-aprov.
        BUFFER-COPY tt-doc-pend-aprov EXCEPT int-2 TO b-tt-doc-pend-aprov
        ASSIGN b-tt-doc-pend-aprov.int-2 = i-seq-create.
        DELETE tt-doc-pend-aprov.

    END.
    -----------------------------------------*/

    IF  CAN-FIND(FIRST tt-doc-pend-aprov) THEN DO:

        /* Verifica se est† no primeiro registro da base */
        GET FIRST q-doc-pend-aprov.
        IF  AVAIL doc-pend-aprov THEN DO:
            IF  p-navigation <> "Prev":U THEN DO:
                IF  r-first-rowid-tt = ROWID(doc-pend-aprov) THEN
                    ASSIGN p-first-rowid = ?.
                ELSE
                    ASSIGN p-first-rowid = r-first-rowid-tt.
            END.
            ELSE DO:
                IF  r-last-rowid-tt = ROWID(doc-pend-aprov) THEN
                    ASSIGN p-first-rowid = ?.
                ELSE
                    ASSIGN p-first-rowid = r-last-rowid-tt.
            END.
        END.
    
        /* Verifica se est† no £ltimo registro da base */
        GET LAST q-doc-pend-aprov.
        IF  AVAIL doc-pend-aprov THEN DO:
            IF  p-navigation <> "Prev":U THEN DO:
                IF  r-last-rowid-tt = ROWID(doc-pend-aprov) THEN
                    ASSIGN p-last-rowid = ?.
                ELSE
                    ASSIGN p-last-rowid = r-last-rowid-tt.
            END.
            ELSE DO:
                IF  r-first-rowid-tt = ROWID(doc-pend-aprov) THEN
                    ASSIGN p-last-rowid = ?.
                ELSE
                    ASSIGN p-last-rowid = r-first-rowid-tt.
            END.
        END.
        
    END.
    ELSE 
        ASSIGN p-last-rowid  = ?
               p-first-rowid = ?.

    RETURN "OK":U.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao03 DBOProgram 
PROCEDURE carregaTTSolicitacao03:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
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
                                            else dtRejeitaFim) and
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK 
                                            USE-INDEX doc-pend-aprov-6:
                run carregaTT.                                                             
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao04 DBOProgram 
PROCEDURE carregaTTSolicitacao04:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
            doc-pend-aprov.num-pedido    >= iPedidoIni       and
            doc-pend-aprov.num-pedido    <= iPedidoFim       and
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
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao05 DBOProgram 
PROCEDURE carregaTTSolicitacao05:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    run carregaTTAprov.
    
    for each tt-aprov no-lock:
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
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
                                            else dtRejeitaFim) and
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK 
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao06 DBOProgram 
PROCEDURE carregaTTSolicitacao06:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
            doc-pend-aprov.num-pedido    >= iPedidoIni       and
            doc-pend-aprov.num-pedido    <= iPedidoFim       and
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
                                            else dtRejeitaFim) and
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao07 DBOProgram 
PROCEDURE carregaTTSolicitacao07:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:          
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
            doc-pend-aprov.num-pedido    >= iPedidoIni       and
            doc-pend-aprov.num-pedido    <= iPedidoFim       and
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
                                            else dtRejeitaFim) and
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK 
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao08 DBOProgram 
PROCEDURE carregaTTSolicitacao08:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:          
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
            doc-pend-aprov.num-pedido    >= iPedidoIni       and
            doc-pend-aprov.num-pedido    <= iPedidoFim       and
            doc-pend-aprov.char-1        >= cNrContratoIni   and
            doc-pend-aprov.char-1        <= cNrContratoFim   and                                        
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
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK 
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSolicitacao09 DBOProgram 
PROCEDURE carregaTTSolicitacao09:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTTAprov.
    
    for each tt-aprov no-lock:          
        for each doc-pend-aprov where  
            doc-pend-aprov.cod-aprov      = tt-aprov.cod-aprov    and 
            doc-pend-aprov.ind-tip-doc    = iTipDoc          and
            doc-pend-aprov.it-codigo     >= cItCodigoIni     and
            doc-pend-aprov.it-codigo     <= cItCodigoFim     and
            doc-pend-aprov.numero-ordem  >= iNumeroOrdemIni  and
            doc-pend-aprov.numero-ordem  <= iNumeroOrdemFim  and
            doc-pend-aprov.cod-emitente  >= iCodEmitenteIni  and
            doc-pend-aprov.cod-emitente  <= iCodEmitenteFim  and
            doc-pend-aprov.num-pedido    >= iPedidoIni       and
            doc-pend-aprov.num-pedido    <= iPedidoFim       and
            doc-pend-aprov.char-1        >= cNrContratoIni   and
            doc-pend-aprov.char-1        <= cNrContratoFim   and                                        
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
            doc-pend-aprov.ind-situacao   = (if iSituacaoPend < 5 then
                                            iSituacaoPend else
                                            doc-pend-aprov.ind-situacao ) NO-LOCK 
                                            USE-INDEX doc-pend-aprov-6:
            run carregaTT.
        end.        
    end.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTT DBOProgram 
PROCEDURE carregaTT:
/*------------------------------------------------------------------------------*/

    find usuar-mater where usuar-mater.cod-usuario = doc-pend-aprov.cod-usuario
        no-lock no-error.
    if avail usuar-mater then
        if substring(usuar-mater.char-1,2,8) < cCentroCustoIni   or
           substring(usuar-mater.char-1,2,8) > cCentroCustoFim   then
        next.

    find requisicao where
        requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock no-error.

    create tt-doc-pend-aprov.
    assign tt-doc-pend-aprov.cod-aprov        = doc-pend-aprov.cod-aprov
           tt-doc-pend-aprov.ind-tip-doc      = doc-pend-aprov.ind-tip-doc
           tt-doc-pend-aprov.cod-aprov-altern = doc-pend-aprov.cod-aprov-altern
           tt-doc-pend-aprov.cod-usuario      = doc-pend-aprov.cod-usuario
           tt-doc-pend-aprov.char-2           = doc-pend-aprov.char-2
           tt-doc-pend-aprov.cod-rej          = doc-pend-aprov.cod-rej
           tt-doc-pend-aprov.dt-aprova        = doc-pend-aprov.dt-aprova
           tt-doc-pend-aprov.dt-geracao       = doc-pend-aprov.dt-geracao
           tt-doc-pend-aprov.dt-reaprova      = doc-pend-aprov.dt-reaprova
           tt-doc-pend-aprov.dt-rejeita       = doc-pend-aprov.dt-rejeita
           tt-doc-pend-aprov.it-codigo        = doc-pend-aprov.it-codigo
           tt-doc-pend-aprov.nr-requisicao    = doc-pend-aprov.nr-requisicao
           tt-doc-pend-aprov.sequencia        = doc-pend-aprov.sequencia
           tt-doc-pend-aprov.aprov-tec        = doc-pend-aprov.aprov-tec
           tt-doc-pend-aprov.ind-situacao     = doc-pend-aprov.ind-situacao
           tt-doc-pend-aprov.sit-aprov        = doc-pend-aprov.sit-aprov
           tt-doc-pend-aprov.cod-tip-aprov    = doc-pend-aprov.cod-tip-aprov
           tt-doc-pend-aprov.aprov-auto       = doc-pend-aprov.aprov-auto
           tt-doc-pend-aprov.ind-situacao     = doc-pend-aprov.ind-situacao
           tt-doc-pend-aprov.r-rowid          = rowid(doc-pend-aprov)
           tt-doc-pend-aprov.int-2            = i-seq-create.

        if doc-pend-aprov.aprov-total then
            assign tt-doc-pend-aprov.prioridade = 0.
        else do:
            find item-mat where
                item-mat.it-codigo = doc-pend-aprov.it-codigo no-lock no-error.
            find it-requisicao where
                 it-requisicao.nr-requisicao = requisicao.nr-requisicao and
                 it-requisicao.it-codigo     = doc-pend-aprov.it-codigo and
                 it-requisicao.sequencia     = doc-pend-aprov.sequencia no-lock no-error.
            if available it-requisicao then
                assign tt-doc-pend-aprov.prioridade = it-requisicao.prioridade-aprov.
            else 
            if available item-mat then
                assign tt-doc-pend-aprov.prioridade = item-mat.prioridade-aprov.
            else
                assign tt-doc-pend-aprov.prioridade = 0.
        end.                                                                                   

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTAprov DBOProgram 
PROCEDURE carregaTTAprov:
/*------------------------------------------------------------------------------*/

    for each tt-aprov:
        delete tt-aprov.
    end.
    for each tt-doc-pend-aprov:
        delete tt-doc-pend-aprov.
    end.    
    find aprovador where 
         aprovador.cod-aprov = cCodAprov no-lock no-error.
    if  aprovador.mestre then do:
        for each aprovador no-lock:
            create tt-aprov.
            assign tt-aprov.cod-aprov = aprovador.cod-aprov.
        end.
    end.
    else do:
        if  lSomenteAltern then do:
            for each aprov-altern no-lock use-index aprov-altern:
                 /**  Melhorias 
                **/
                &if defined(bf_mat_aprova_eletronica) &then
                    if  today > aprov-altern.dt-validade-fim or
                        today < aprov-altern.dt-validade-ini then
                        next.
                &endif
            
                if  aprov-altern.cod-aprov-altern <> cCodAprov then 
                    next.
                create tt-aprov.
                assign tt-aprov.cod-aprov = aprov-altern.cod-aprov.
            end.
        end.    
        else do:
            create tt-aprov.
            assign tt-aprov.cod-aprov = aprovador.cod-aprov.
        end.
    end.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord Method-Library 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    
    assign pRowid = rowid({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- ê necess†rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid:
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    assign rowobject.r-rowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

    

