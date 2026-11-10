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
{include/i-prgvrs.i BOIN274NA 2.00.00.024 } /*** "010024" 23/11/2023 16:19:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274na MUT}
&ENDIF
/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOIN274
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin274.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-ordem-compra FOR {&TableName}.
DEFINE BUFFER b-parcela      FOR prazo-compra.
/* local variable definitions */

def var iIniNumeroOrdem as int  no-undo.
def var iEndNumeroOrdem as int  no-undo.
def var iIniNumPedido   as int  no-undo.
def var iEndNumPedido   as int  no-undo.
def var cIniItCodigo    as char no-undo.
def var cEndItCodigo    as char no-undo.
def var iIniNrContrato  as int  no-undo.
def var iEndNrContrato  as int  no-undo.
def var cIniCodEstabel  as char no-undo.
def var cEndCodEstabel  as char no-undo.

def var c-it-codigo     as char no-undo. 
def var i-cod-emitente  as int  no-undo.

/* Vari†veis necess†rias ao setConstraintRelacionamento */
def var iNumOrdemIni     as int  no-undo.
def var iNumOrdemFim     as int  no-undo.
def var iEmitente        as int  no-undo. 
def var iNrProcesso      as int  no-undo.
def var iNumPedido       as int  no-undo.
def var iNatureza        as int  no-undo.
def var iCodCondPag      as int  no-undo.
def var iCodTransp       as int  no-undo.

/* Variaveis setConstraintSemCotacao */
DEFINE VARIABLE l-nao-confirmada AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-em-cotacao     AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-cotada         AS LOGICAL NO-UNDO.

/* Variaveis setConstraintVincularOrdens */
DEFINE VARIABLE l-considera-estab AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-estab           AS CHARACTER   NO-UNDO.


/* Para uso das procedures iniciaTransfOC, cancelaTransfOC desta BO */
{inbo/boin274.i tt-oc-destino}

/* Procedure pi-sugerirCotacao */
{inbo/boin274.i tt-ordem-compra}
{inbo/boin082.i tt-cotacao-item}

DEFINE VARIABLE i-numero-ordem-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-numero-ordem-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim    AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 3.46
         WIDTH              = 37.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alterarOrdemCompra DBOProgram 
PROCEDURE alterarOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */
    DEFINE INPUT PARAMETER p-nr-ordem   LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-pedido  LIKE ordem-compra.num-pedido   NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao   LIKE ordem-compra.situacao     NO-UNDO.
    DEFINE INPUT PARAMETER p-atualiza   AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAMETER p-emitente   LIKE ordem-compra.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-cond-pag   LIKE ordem-compra.cod-cond-pag NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-transp LIKE ordem-compra.cod-transp   NO-UNDO.

    FOR FIRST b-ordem-compra
        WHERE b-ordem-compra.numero-ordem = p-nr-ordem EXCLUSIVE-LOCK:
        ASSIGN b-ordem-compra.num-pedido = p-nr-pedido
               b-ordem-compra.situacao   = p-situacao.

        IF  p-atualiza THEN DO:
            ASSIGN b-ordem-compra.cod-emitente = p-emitente
                   b-ordem-compra.cod-cond-pag = p-cond-pag
                   b-ordem-compra.cod-transp   = p-cod-transp.
        END.
    END.

    IF  AVAIL b-ordem-compra THEN DO:
        RELEASE b-ordem-compra.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param i-cod-emitente as int  no-undo.
    def output param c-nome-abrev   as char no-undo.
    def output param c-cgc          as char no-undo.
    
    
    for first emitente fields(nome-abrev cgc)
        where emitente.cod-emitente = i-cod-emitente no-lock:
      
        assign c-nome-abrev = emitente.nome-abrev
               c-cgc        = emitente.cgc.
        
    end.
    
    return "OK":U.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
        &IF "{&mguni_version}" < "2.071" &THEN
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
  Purpose:     Retorna valores dos campos do °ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    for FIRST bfordem-compra fields(numero-ordem it-codigo) WHERE 
        bfordem-compra.numero-ordem = pnumero-ordem NO-LOCK: end.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordem-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniciaTransfOC DBOProgram 
PROCEDURE iniciaTransfOC :
/*------------------------------------------------------------------------------
  Purpose: Adicionar ordem na temp-table tt-oc-destino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER i-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-oc-destino.

FIND ordem-compra WHERE 
     ordem-compra.numero-ordem = i-ordem NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:
    CREATE tt-oc-destino.
    BUFFER-COPY ordem-compra TO tt-oc-destino.
    ASSIGN tt-oc-destino.r-rowid = ROWID(ordem-compra).
END.
ELSE
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido DBOProgram 
PROCEDURE linkToPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        DEFINE INPUT PARAM ph-pedido-compr AS HANDLE NO-UNDO.

        RUN getKey IN ph-pedido-compr (OUTPUT inumpedido).

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName} NO-LOCK 
            WHERE {&TableName}.it-codigo >= c-it-codigo-ini
            AND   {&TableName}.it-codigo <= c-it-codigo-fim
            BY    {&TableName}.it-codigo INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrProcesso DBOProgram 
PROCEDURE openQueryNrProcesso :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o n£mero 
           do processo igual ao do parÉmetro recebido pelo setConstraint.
           Os registros s∆o ordenados pela N£mero da Ordem.
    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} no-lock where
                                         {&TABLENAME}.nr-processo  = iNrProcesso 
                                         INDEXED-REPOSITION.
                                                 
        RETURN "OK":U.
    &endif
                                                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumeroOrdem DBOProgram 
PROCEDURE openQueryNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName} NO-LOCK 
            WHERE {&TableName}.numero-ordem >= i-numero-ordem-ini
            AND   {&TableName}.numero-ordem <= i-numero-ordem-fim
            BY    {&TableName}.numero-ordem INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumPedido2 DBOProgram 
PROCEDURE openQueryNumPedido2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                                WHERE    {&TABLENAME}.num-pedido = iNumPedido       
                                          BY {&TABLENAME}.numero-ordem
                                         INDEXED-REPOSITION.

        RETURN "OK":U.                                   
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumPedidoR DBOProgram 
PROCEDURE openQueryNumPedidoR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tableName} WHERE
    {&tableName}.num-pedido = iNumPedido AND
   ({&tableName}.situacao = 2 OR
    {&tableName}.situacao = 6) NO-LOCK by {&tableName}.numero-ordem.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente =  i-cod-emitente
           and ( {&tablename}.it-codigo  =  c-it-codigo or c-it-codigo = "" )
           and {&tableName}.num-pedido   >= iIniNumPedido
           and {&tableName}.num-pedido   <= iEndNumPedido
           and {&tableName}.situacao     =  2
         no-lock
         by {&tableName}.num-pedido
         by {&tableName}.numero-ordem
         indexed-reposition. 

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente =  i-cod-emitente
           and ({&tablename}.it-codigo   =  c-it-codigo or c-it-codigo = " ") 
           and {&tableName}.numero-ordem >= iIniNumeroOrdem
           and {&tableName}.numero-ordem <= iEndNumeroOrdem
           and {&tableName}.situacao     =  2
         no-lock
         by {&tableName}.numero-ordem
         by {&tableName}.num-pedido
         indexed-reposition.
             
    return "OK":U.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage3 DBOProgram 
PROCEDURE openQueryRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente =  i-cod-emitente
           and ({&tablename}.it-codigo   =  c-it-codigo or c-it-codigo = " ")
           and {&tablename}.it-codigo    >= cIniItCodigo
           and {&tablename}.it-codigo    <= cEndItCodigo
           and {&tableName}.situacao     = 2
         no-lock
         by {&tablename}.it-codigo
         by {&tableName}.num-pedido
         by {&tableName}.numero-ordem
         indexed-reposition.             
       
    return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage4 DBOProgram 
PROCEDURE openQueryRangePage4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente =  i-cod-emitente
           and ({&tablename}.it-codigo   = c-it-codigo or c-it-codigo = " ")
           and {&tableName}.nr-contrato  >= iIniNrContrato
           and {&tableName}.nr-contrato  <= iEndNrContrato
           and {&tableName}.situacao     = 2
         no-lock
         by {&tableName}.nr-contrato
         by {&tablename}.it-codigo
         by {&tableName}.num-pedido
         by {&tableName}.numero-ordem
         indexed-reposition. 
           
    return "OK":U.
      
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

/*====================================================================
  Funá∆o:   Diferentes Processos de Compra num mesmo Pedido de Compra
  
  Objetivo: Permitir que ordens de compra de diferentes processos de
            compra sejam relacionados a um mesmo pedido. Ser†
            permitido relacionar v†rias ordens de diferentes processos
            apenas se o n£mero informado no processo for igual a zero.
            Para qualquer outro processo informado, ser∆o listadas no
            CC9019 apenas as ordens do respecitovo processo.
            Esta implementaá∆o foi realizada, pois no cadastro de 
            Pedidos (CC0304) do Magnus (include CC0304.i9) quando n∆o
            Ç informado Processo de Compra Ç poss°vel relacionar ao
            Pedido todas as ordens cotadas do fornecedor, mesmo que
            tenham um n£mero qualquer de Processo de Compra.            
  
  Coment†rio TÇcnico: O Open-Query n∆o considera o n£mero do processo
                      na igualdade para abertura da query, permitindo
                      diferentes processos no mesmo pedido.
                      Para qualquer outro processo informado no pedido
                      o programa listar† apenas as ordens daquele
                      processo.
  ====================================================================*/

find first funcao
    where funcao.cd-funcao = "Dif_Proc_Pedido_CC" 
    and   funcao.ativo     = yes no-lock no-error.
if  avail funcao
and iNrProcesso = 0 then
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} WHERE
            {&TABLENAME}.numero-ordem >= iNumOrdemIni         and
            {&TABLENAME}.numero-ordem <= iNumOrdemFim         and
            {&TABLENAME}.cod-emitente = iEmitente             and
            {&TABLENAME}.natureza     = iNatureza             and
            {&TABLENAME}.cod-cond-pag = iCodCondPag           and
            {&TABLENAME}.cod-transp   = iCodTransp            and
            {&TABLENAME}.num-pedido   = 0                     and
            {&TABLENAME}.situacao     = 3                     and
            {&TABLENAME}.expectativa  = no
            NO-LOCK INDEXED-REPOSITION.    
else
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} WHERE
            {&TABLENAME}.numero-ordem >= iNumOrdemIni         and
            {&TABLENAME}.numero-ordem <= iNumOrdemFim         and
            {&TABLENAME}.cod-emitente = iEmitente             and
            {&TABLENAME}.natureza     = iNatureza             and
            {&TABLENAME}.cod-cond-pag = iCodCondPag           and
            {&TABLENAME}.nr-processo  = iNrProcesso           and
            {&TABLENAME}.cod-transp   = iCodTransp            and
            {&TABLENAME}.num-pedido   = 0                     and
            {&TABLENAME}.situacao     = 3                     and
            {&TABLENAME}.expectativa  = no
            NO-LOCK INDEXED-REPOSITION.    

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySemCotacao DBOProgram 
PROCEDURE openQuerySemCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY    {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.numero-ordem >= iNumOrdemIni         AND
                  {&TableName}.numero-ordem <= iNumOrdemFim         AND
                  {&TableName}.natureza      = iNatureza            AND
                  {&TableName}.nr-processo   = iNrProcesso          AND
                 ((l-cotada         AND {&TableName}.situacao = 3   AND
                  {&TableName}.cod-emitente  = iEmitente            AND
                  {&TableName}.cod-cond-pag  = iCodCondPag          AND
                  {&TableName}.cod-transp    = iCodTransp)          OR
                  (l-nao-confirmada AND {&TableName}.situacao = 1)  OR
                  (l-em-cotacao     AND {&TableName}.situacao = 5)) AND
                  {&TableName}.num-pedido    = 0                    AND
                  {&TableName}.expectativa   = NO                   NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVincularOrdens DBOProgram 
PROCEDURE openQueryVincularOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  l-considera-estab THEN 
        OPEN QUERY    {&QueryName}
            FOR EACH  {&TableName}
                WHERE {&TableName}.cod-emitente  = iEmitente          
                AND   {&TableName}.situacao      = 3  /*-- Cotadas --*/
                AND   {&TableName}.natureza      = iNatureza            
                AND   {&TableName}.nr-processo   = iNrProcesso          
                AND   {&TableName}.num-pedido    = 0                    
                AND   {&TableName}.expectativa   = NO
                AND   {&TableName}.cod-cond-pag  = iCodCondPag        
                AND   {&TableName}.cod-transp    = iCodTransp NO-LOCK INDEXED-REPOSITION.
    ELSE 
        OPEN QUERY    {&QueryName}
            FOR EACH  {&TableName}
                WHERE {&TableName}.cod-emitente  = iEmitente          
                AND   {&TableName}.situacao      = 3  /*-- Cotadas --*/    
                AND   {&TableName}.cod-estabel   = c-estab
                AND   {&TableName}.natureza      = iNatureza            
                AND   {&TableName}.nr-processo   = iNrProcesso          
                AND   {&TableName}.num-pedido    = 0                    
                AND   {&TableName}.expectativa   = NO
                AND   {&TableName}.cod-cond-pag  = iCodCondPag        
                AND   {&TableName}.cod-transp    = iCodTransp NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugerirCotacao DBOProgram 
PROCEDURE pi-sugerirCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */
    DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-compra.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-cotacao-item.

    FOR EACH  tt-ordem-compra
        WHERE tt-ordem-compra.situacao = 5 /* Em Cotacao */ NO-LOCK
        BREAK BY tt-ordem-compra.numero-ordem:

        FOR FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem AND
                  cotacao-item.it-codigo    = tt-ordem-compra.it-codigo    NO-LOCK:
            CREATE tt-cotacao-item.
            BUFFER-COPY cotacao-item TO tt-cotacao-item.
            ASSIGN tt-cotacao-item.r-rowid = ROWID(cotacao-item).
            LEAVE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoItem DBOProgram 
PROCEDURE retornaDescricaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       usada por wcc9019, wcc0512 e wcc0320
------------------------------------------------------------------------------*/

    define input  parameter pc-it-codigo as char  no-undo.
    define input  parameter prRowidOrdem as rowid no-undo.
    define output parameter pc-descricao as char  no-undo.

    for first item fields(it-codigo desc-item tipo-contr) where 
        item.it-codigo = pc-it-codigo no-lock: end.
    if avail item then do:
        for first item-mat fields(it-codigo log-1) where 
             item-mat.it-codigo = item.it-codigo no-lock: end. 
        if avail item-mat and item-mat.log-1 = yes /*item GenÇrico*/ and item.tipo-contr = 4 /* dÇbito direto */ then do:
            /* busca descriá∆o da ordem-compra */
            for first ordem-compra fields(narrativa it-codigo) where 
                rowid(ordem-compra) = prRowidOrdem no-lock: end.
            if avail ordem-compra then
                assign pc-descricao = substring(ordem-compra.narrativa,1,60).
            else
                assign pc-descricao = item.desc-item.
        end.
        else
          assign pc-descricao = item.desc-item.
    end.
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDescItem DBOProgram 
PROCEDURE returnDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT  PARAMETER cReturn AS CHAR    NO-UNDO.

    FOR FIRST item-mat WHERE
              item-mat.it-codigo = RowObject.it-codigo NO-LOCK: END.
    IF AVAIL item-mat AND
             item-mat.log-1 THEN DO:
        ASSIGN cReturn = SUBSTRING(RowObject.narrativa,1,60).
    END.
    ELSE DO:
        FOR FIRST ITEM FIELDS(it-codigo desc-item) WHERE
                  ITEM.it-codigo = RowObject.it-codigo NO-LOCK:
            ASSIGN cReturn = ITEM.desc-item.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo-fim AS CHARACTER   NO-UNDO.

    ASSIGN c-it-codigo-ini = p-it-codigo-ini
           c-it-codigo-fim = p-it-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-cod-emitente as int  no-undo.
    def input param pc-it-codigo    as char no-undo.

    assign i-cod-emitente = pi-cod-emitente
           c-it-codigo    = pc-it-codigo.
           
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrProcesso DBOProgram 
PROCEDURE setConstraintNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis para openQueryNrProcesso .
  Parameters: 
             ipar1 : piNrProcesso : N£mero do processo 
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pNrProcesso as int no-undo.
        
        assign iNrProcesso = pNrProcesso.
    
        RETURN "OK":U.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumeroOrdem DBOProgram 
PROCEDURE setConstraintNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem-ini AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem-fim AS INTEGER     NO-UNDO.

    ASSIGN i-numero-ordem-ini = p-numero-ordem-ini
           i-numero-ordem-fim = p-numero-ordem-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumPedidoR DBOProgram 
PROCEDURE setConstraintNumPedidoR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piNumPedido LIKE pedido-compr.num-pedido NO-UNDO.

ASSIGN iNumPedido = piNumPedido.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piIniNumPedido as int no-undo.
    def input param piEndNumPedido as int no-undo.
    
    assign iIniNumPedido = piIniNumPedido
           iEndNumPedido = piEndNumPedido.

   return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piIniNumeroOrdem as int no-undo.
    def input param piEndNumeroOrdem as int no-undo.

    assign iIniNumeroOrdem = piIniNumeroOrdem
           iEndNumeroOrdem = piEndNumeroOrdem.
           
   return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage3 DBOProgram 
PROCEDURE setConstraintRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcIniItCodigo as char no-undo.
    def input param pcEndItCodigo as char no-undo.

    assign cIniItCodigo = pcIniItCodigo
           cEndItCodigo = pcEndItCodigo.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage4 DBOProgram 
PROCEDURE setConstraintRangePage4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piIniNrContrato as int no-undo.
    def input param piEndNrContrato as int no-undo.

    assign iIniNrContrato = piIniNrContrato
           iEndNrContrato = piEndNrContrato.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRelacionamento DBOProgram 
PROCEDURE setConstraintRelacionamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter piEmit        as int  no-undo.
def input parameter piNatureza    as int  no-undo.
def input parameter piCodCondPag  as int  no-undo.
def input parameter piNrProcesso  as int  no-undo.
def input parameter piCodTransp   as int  no-undo.
def input parameter piNumOrdemIni as int  no-undo.
def input parameter piNumOrdemFim as int  no-undo.

assign iEmitente    = piEmit 
       iNatureza    = piNatureza
       iCodCondPag  = piCodCondPag
       iNrProcesso  = piNrProcesso
       iCodTransp   = piCodTransp
       iNumOrdemIni = piNumOrdemIni
       iNumOrdemFim = piNumOrdemFim.
 
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSemCotacao DBOProgram 
PROCEDURE setConstraintSemCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */
    DEFINE INPUT PARAMETER p-emitente       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-natureza       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cond-pag       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-processo    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-transp     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-ordem-ini      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-ordem-fim      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-nao-confirmada AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-em-cotacao     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-cotada         AS LOGICAL NO-UNDO.

    ASSIGN iEmitente        = p-emitente
           iNatureza        = p-natureza
           iCodCondPag      = p-cond-pag
           iNrProcesso      = p-nr-processo
           iCodTransp       = p-cod-transp
           iNumOrdemIni     = p-ordem-ini
           iNumOrdemFim     = p-ordem-fim
           l-nao-confirmada = p-nao-confirmada
           l-em-cotacao     = p-em-cotacao
           l-cotada         = p-cotada.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVincularOrdens DBOProgram 
PROCEDURE setConstraintVincularOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */
    DEFINE INPUT PARAMETER p-emitente        AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-natureza        AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cond-pag        AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-processo     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-transp      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-considera-estab AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-estab           AS CHAR    NO-UNDO.

    ASSIGN iEmitente         = p-emitente
           iNatureza         = p-natureza
           iCodCondPag       = p-cond-pag
           iNrProcesso       = p-nr-processo
           iCodTransp        = p-cod-transp
           l-considera-estab = p-considera-estab
           c-estab           = p-estab.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valAtivBotoesManutOrdCompra DBOProgram 
PROCEDURE valAtivBotoesManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:    Valida a ativaá∆o dos bot‰es de Inclus∆o/Modificaá∆o/Exclus∆o
              na manutená∆o de ordens de compra  
  Parameters: ipar1 : piNumeroOrdem  : Numero da Ordem
              opar2 : plModificar    : Habilitar o bot∆o de modificar?
              opar3 : plIncluir      : Habilitar o bot∆o de incluir?
              opar4 : plEliminar     : Habilitar o bot∆o de eliminar?
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input  param piNumeroOrdem as int no-undo.
        def output param plModificar   as log no-undo.
        def output param plInclui      as log no-undo.
        def output param plEliminar    as log no-undo.
        
        for first ordem-compra fields(numero-ordem situacao it-codigo) where 
            ordem-compra.numero-ordem = piNumeroOrdem 
            no-lock: end.
        if  avail ordem-compra then do:
            FOR FIRST b-parcela FIELD (numero-ordem)
                WHERE b-parcela.numero-ordem = piNumeroOrdem NO-LOCK: END.
            /* Verifica Existencia de + de uma parcela */
            assign plEliminar = CAN-FIND (FIRST prazo-compra WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND
                                          ROWID(prazo-compra) <> ROWID(b-parcela)).
            IF  ordem-compra.situacao <> 1
            AND ordem-compra.situacao <> 5 THEN 
                assign plInclui    = NO
                       plModificar = NO
                       plEliminar  = NO.
            ELSE
                assign plInclui    = YES
                       plModificar = YES.
        end. 
        
        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valAtivBotoesPedEmerg DBOProgram 
PROCEDURE valAtivBotoesPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:     
    Valida a ativaá∆o dos bot‰es de Inclus∆o/Modificaá∆o/Exclus∆o
    no programa de pedidos emergenciais
  Parameters:  
    ipar1 : p-i-numero-ordem : Numero da Ordem
    opar2 : p-l-modificar: Habilitar o bot∆o de modificar?
    opar3 : p-l-incluir  : Habilitar o bot∆o de incluir?
    opar4 : p-l-eliminar : Habilitar o bot∆o de eliminar?
  Notes:       
------------------------------------------------------------------------------*/
&if defined(bf-mat-comex) &then             
&else    
    def input  param p-i-numero-ordem as int no-undo.
    def output param p-l-modificar    as log no-undo.
    def output param p-l-eliminar     as log no-undo.
     
      assign p-l-eliminar  = (num-results("{&QUERYNAME}") > 1)
             p-l-modificar = (num-results("{&QUERYNAME}") > 1).
&endif  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
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

