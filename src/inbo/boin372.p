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
{include/i-prgvrs.i BOIN372 2.00.00.015} /*** "010015" 24/11/2023 13:25:23  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin372 MUT}
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
&GLOBAL-DEFINE DBOName recebimento
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName recebimento
&GLOBAL-DEFINE TableLabel recebimento
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin372.i RowObject}
{cdp/cdcfgmat.i}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
define buffer b_recebimento for recebimento.

/*============PROCEDURE CALCULAVALOR==========*/ 

 define var de-val-unit1     like ordem-compra.preco-unit no-undo.
 define var de-val-unit2     like ordem-compra.preco-unit no-undo.
 define var l-flag           as logical  no-undo.

/*=========UTILIZADO NAS SETCONSTRAINTS E OPENQUERYS===========*/
DEF VAR iNumPedido        AS INTEGER NO-UNDO.
DEF VAR iNumeroOrdem      AS INTEGER NO-UNDO.
DEF VAR iParcela          AS INTEGER NO-UNDO.
DEF VAR  iCodEmitente     AS INTEGER NO-UNDO.
DEF VAR  cItCodigo        AS CHAR    NO-UNDO.
DEF VAR  iNumeroOrdemIni  AS INT     NO-UNDO.
DEF VAR  iNumeroOrdemFim  AS INT     NO-UNDO.
DEF VAR  iNumPedidoIni    AS INT     NO-UNDO.
DEF VAR  iNumPedidoFim    AS INT     NO-UNDO.
DEF VAR  dtDataMovtoIni   AS DATE    NO-UNDO.
DEF VAR  dtDataMovtoFim   AS DATE    NO-UNDO.
DEF VAR  cNumeroNotaIni   AS CHAR    NO-UNDO.
DEF VAR  cNumeroNotaFim   AS CHAR    NO-UNDO.
DEF VAR  cSerieNotaIni    AS CHAR    NO-UNDO.
DEF VAR  cSerieNotaFim    AS CHAR    NO-UNDO.
DEF VAR  dtDataNotaIni    AS DATE    NO-UNDO.
DEF VAR  dtDataNotaFim    AS DATE    NO-UNDO.
DEF VAR  iParcelaIni      AS INTEGER NO-UNDO.
DEF VAR  iParcelaFim      AS INTEGER NO-UNDO.
DEF VAR  dDataMovto       AS DATE    NO-UNDO.
DEF VAR  c-value          AS CHAR    NO-UNDO.
/*========================================================*/

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.29
         WIDTH              = 63.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetNext DBOProgram 
PROCEDURE afterGetNext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*   find first b_recebimento where
 *          b_recebimento.num-pedido = RowObject.num-pedido and
 *          b_recebimento.numero-ordem = RowObject.numero-ordem and
 *          b_recebimento.parcela = RowObject.parcela no-lock no-error.
 * 
 *    find next b_recebimento no-lock no-error.
 *  
 *    find first recebimento where
 *         recebimento.num-pedido = b_recebimento.num-pedido and
 *         recebimento.numero-ordem = b_recebimento.numero-ordem and
 *         recebimento.parcela = b_recebimento.parcela no-lock no-error.
 * 
 *     if  avail recebimento then do:
 *         RUN setCurrent.
 *         leave.
 *     end.
 *     else do:
 *         {method/svc/errors/inserr.i &ErrorNumber="7998"
 *                                     &ErrorType="EMS":U
 *                                     &ErrorSubType="ERROR":U}        
 *     end.*/
    if can-find(first RowErrors Where RowErrors.ErrorSubType = "ERROR":U) then
       RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftergetPrev DBOProgram 
PROCEDURE aftergetPrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*        find first b_recebimento where
 *          b_recebimento.num-pedido = RowObject.num-pedido and
 *          b_recebimento.numero-ordem = RowObject.numero-ordem and
 *          b_recebimento.parcela = RowObject.parcela no-lock no-error.
 *          
 *     find prev b_recebimento no-lock no-error. 
 *     
 *     find first recebimento where
 *          recebimento.num-pedido = b_recebimento.num-pedido and
 *          recebimento.numero-ordem = b_recebimento.numero-ordem and
 *          recebimento.parcela = b_recebimento.parcela no-lock no-error.
 *     
 *     if  avail recebimento then do:
 *         RUN setCurrent.
 *         leave.
 *     end.
 *     else do:
 *         {method/svc/errors/inserr.i &ErrorNumber="7998"
 *                                     &ErrorType="EMS":U
 *                                     &ErrorSubType="ERROR":U}        
 *     end.*/
    if can-find(first RowErrors Where RowErrors.ErrorSubType = "ERROR":U) then
       RETURN "NOK":U.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValoresRecebimento DBOProgram 
PROCEDURE calculaValoresRecebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:   
    ipar1:  p-i-nume-pedido    : n£mero do pedido
    ipar2:  p-i-numero-ordem   :n£mero de ordem do pedido
    ipar3:  p-i-parcela        :n£mero de parcela
    ipar4:  p-da-ini           :
    ipar5:  p-da-fim           :
    ipar6:  p-c-serie          :s‚rie da nota
    ipar7:  p-c-num-docto      :n£mero do documento
    ipar8:  p-de-quant-receb   :quantidade recebida
    ipar9:  p-i-moeda          :tipo da moeda
    opar10: p-de-var-preco     :
    opar11: p-de-valor-tot-ord :valor total da ordem
    opar12: p-de-valor-tot-rec :valor total do recebimento
    opar13: p-de-val-unit      :
    opar14: p-de-valor-unit    :
    opar15: RowErrors          :
Notes:       
------------------------------------------------------------------------------*/

     define input  parameter p-i-nume-pedido    as integer  no-undo.
     define input  parameter p-i-numero-ordem   as integer  no-undo.
     define input  parameter p-i-parcela        as integer  no-undo.
     define input  parameter p-da-ini           as date     no-undo.
     define input  parameter p-da-fim           as date     no-undo.
     define input  parameter p-c-serie          as char     no-undo.
     define input  parameter p-c-num-docto      as char     no-undo.
     define input  parameter p-de-quant-receb   as decimal  no-undo.
     define input  parameter p-i-moeda          as integer  no-undo.
     define output parameter p-de-var-preco     as decimal  no-undo.
     define output parameter p-de-valor-tot-ord as decimal  no-undo.
     define output parameter p-de-valor-tot-rec as decimal  no-undo.
     define output parameter p-de-val-unit      as decimal  no-undo.
     define output parameter p-de-valor-unit    as decimal  no-undo.
     define output parameter table for RowErrors.
     
     find first param-compra no-lock no-error.
      
     find first recebimento where 
             recebimento.num-pedido   = p-i-nume-pedido   and
             recebimento.numero-ordem = p-i-numero-ordem  and
             recebimento.parcela      = p-i-parcela       and
             recebimento.cod-movto    = 1                 and
             recebimento.data-movto   >= p-da-ini         and
             recebimento.data-movto   <= p-da-fim         and
             recebimento.serie-nota   = p-c-serie         and
             recebimento.numero-nota  = p-c-num-docto     and
             recebimento.quant-receb  = p-de-quant-receb  no-lock no-error.
     
    if avail recebimento then do:
        run retornaValorUnitarioConvertido(input rowid(recebimento), 
                                 input p-i-moeda, 
                                 output de-val-unit2). 
        run cdp/cd0812.p (input 0, 
                          input p-i-moeda,
                          input recebimento.preco-unit,
                          input recebimento.data-nota,
                          output de-val-unit1).
          
        if de-val-unit2 = de-val-unit1 then do:
            find first ordem-compra use-index ordem where
                       ordem-compra.numero-ordem  = recebimento.numero-ordem no-lock no-error.
            if not avail ordem-compra then do:
               {method/svc/errors/inserr.i &ErrorNumber="6349"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U}             
            end.                     
          
            if avail ordem-compra then do:       
                find prazo-compra where
                     prazo-compra.numero-ordem = recebimento.numero-ordem and
                     prazo-compra.parcela      = recebimento.parcela 
                     no-lock no-error.
                if  avail prazo-compra then 
                  find first emitente where emitente.cod-emitente = recebimento.cod-emitente no-lock no-error.
                find item where
                     item.it-codigo = recebimento.it-codigo no-lock no-error.
                run cdp/cd0812.p (input ordem-compra.mo-codigo, input p-i-moeda,
                                  input ordem-compra.preco-unit,
                                  input recebimento.data-nota,
                                  output p-de-valor-unit).
                run cdp/cd0812.p (input 0, input p-i-moeda,
                                  input recebimento.preco-unit,
                                  input recebimento.data-nota,
                                  output p-de-val-unit).
                
                if  p-de-valor-unit = ? then p-de-valor-unit = 0.
                if  p-de-val-unit   = ? then p-de-val-unit   = 0.
                if avail prazo-compra then
                   assign p-de-valor-tot-ord = prazo-compra.quantidade * p-de-valor-unit.
                if avail recebimento then
                       p-de-valor-tot-rec = recebimento.quant-receb * p-de-val-unit.
                if  p-de-valor-unit <> 0 then do:
                    p-de-var-preco = (100 * p-de-val-unit / p-de-valor-unit) - 100.
                    if  (p-de-var-preco <= param-compra.var-preco) and p-de-var-preco > 0 then
                        assign p-de-var-preco = 0.
                end.
                else assign p-de-var-preco = 0.
                if  p-de-var-preco >  999999.99 then p-de-var-preco =  999999.99.
                if  p-de-var-preco < -999999.99 then p-de-var-preco = -999999.99. 
            end.        
        end.
    end.    
    if can-find(first RowErrors Where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteMoedaPrecoUnit DBOProgram 
PROCEDURE converteMoedaPrecoUnit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar1:  pcMovto        :
              ipar2:  pdtDataMovto   :
              ipar3:  piMoedaOrigem  :
              ipar4:  piMoeda        :
              ipar5:  pdePrecoUnit   :
              ipar6:  pdtConv        :
              ipar7:  pdePrecoCalc   :
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pcMovto        as char    no-undo.
    define input  parameter pdtDataMovto   as date    no-undo.
    define input  parameter piMoedaOrigem  as integer no-undo.
    define input  parameter piMoeda        as integer no-undo.
    define input  parameter pdePrecoUnit   as decimal no-undo.
    define input  parameter pdtConv        as date    no-undo.
    define output parameter pdePrecoCalc   as decimal no-undo.
    
    if pcMovto = "1" then pdtConv = pdtDataMovto.
                    else pdtConv = today.
    assign pdePrecoCalc = pdePrecoUnit.
   
    run cdp/cd0812.p (input  piMoedaOrigem,
                   input  piMoeda,
                   input  pdePrecoUnit,
                   input  pdtConv,
                   output pdePrecoCalc).
                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findChave DBOProgram 
PROCEDURE findChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter pcNumPedido   as char no-undo.
    def input  parameter pcNumeroOrdem as char no-undo.
    def input  parameter pcParcela     as char no-undo.
    def output parameter cReturn       as char no-undo.
    run openQueryStatic (INPUT "Main").
    run goToParcela (pcNumPedido, pcNumeroOrdem, pcParcela).
    if return-value = "NOK":U then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign cReturn =  return-value.  
        
    end.
    else   
       cReturn = "".
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPedido DBOProgram 
PROCEDURE findPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter iNumPedido   as inte no-undo.
    def input  parameter iNumeroOrdem as inte no-undo.
    def output parameter cReturn      as char no-undo.

    run goToPedido (iNumPedido, iNumeroOrdem).
    
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'":U}    
    end.
    else   
      cReturn = "".    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRecebimento DBOProgram 
PROCEDURE findRecebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter pRowid   as rowid no-undo.
    def output parameter cReturn  as char  no-undo.
 
    run goToRecebimento (pRowid).
    
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'":U}
    end.
    else   
      cReturn = "".    

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
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        &ENDIF
        WHEN "numero-nota":U THEN ASSIGN pFieldValue = RowObject.numero-nota.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "recebedor":U THEN ASSIGN pFieldValue = RowObject.recebedor.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "serie-nota":U THEN ASSIGN pFieldValue = RowObject.serie-nota.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
/*        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.*/
        &if defined(bf_mat_contratos) &then
        &else WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
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
        WHEN "dat-nota":U THEN ASSIGN pFieldValue = RowObject.dat-nota.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-movto":U THEN ASSIGN pFieldValue = RowObject.data-movto.
        WHEN "data-nota":U THEN ASSIGN pFieldValue = RowObject.data-nota.
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
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "valor-iss":U THEN ASSIGN pFieldValue = RowObject.valor-iss.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qtd-dev":U THEN ASSIGN pFieldValue = RowObject.qtd-dev.
        WHEN "qtd-rec":U THEN ASSIGN pFieldValue = RowObject.qtd-rec.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "valor-total":U THEN ASSIGN pFieldValue = RowObject.valor-total.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "val-dev":U THEN ASSIGN pFieldValue = RowObject.val-dev.
        WHEN "val-rec":U THEN ASSIGN pFieldValue = RowObject.val-rec.
        WHEN "valor-icm":U THEN ASSIGN pFieldValue = RowObject.valor-icm.
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
        WHEN "num-seq-event":U THEN ASSIGN pFieldValue = RowObject.num-seq-event.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        &ENDIF
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-movto":U THEN ASSIGN pFieldValue = RowObject.cod-movto.
        WHEN "cod-rejei":U THEN ASSIGN pFieldValue = RowObject.cod-rejei.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        &ENDIF
        WHEN "ind-movto":U THEN ASSIGN pFieldValue = RowObject.ind-movto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "num-nota":U THEN ASSIGN pFieldValue = RowObject.num-nota.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then assign pFieldValue = RowObject.nr-contrato.
        &endif                
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice PEDIDO
  Parameters:
               retorna valor dos campos do ­ndice PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE recebimento.num-pedido NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-movto LIKE recebimento.data-movto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE recebimento.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE recebimento.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido.
    ASSIGN pdata-movto = RowObject.data-movto.
    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pparcela = RowObject.parcela.

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
  Purpose:     Reposiciona registro com base no ­ndice PEDIDO
  Parameters:
               recebe valor dos campos do ­ndice PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE recebimento.num-pedido NO-UNDO.
    DEFINE INPUT PARAMETER pdata-movto LIKE recebimento.data-movto NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE recebimento.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE recebimento.parcela NO-UNDO.

    FIND FIRST bfrecebimento WHERE
        bfrecebimento.num-pedido = pnum-pedido AND
        bfrecebimento.data-movto = pdata-movto AND
        bfrecebimento.numero-ordem = pnumero-ordem AND
        bfrecebimento.parcela = pparcela
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrecebimento THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrecebimento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToParcela DBOProgram 
PROCEDURE goToParcela :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro
  Parameters:  recebe valor dos campos do ­ndice PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    def input  parameter piNumPedido    as int no-undo.
    def input  parameter piNumeroOrdem   as int no-undo.
    def input  parameter piParcela      as int no-undo.

    FIND FIRST bfrecebimento WHERE
               bfrecebimento.num-pedido = piNumPedido     AND
               bfrecebimento.numero-ordem = piNumeroOrdem AND
               bfrecebimento.parcela = piParcela          NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrecebimento THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrecebimento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPedido DBOProgram 
PROCEDURE goToPedido :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice PEDIDO
  Parameters:
               recebe valor dos campos do ­ndice PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE recebimento.num-pedido NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE recebimento.numero-ordem NO-UNDO.

    FIND FIRST bfrecebimento WHERE
        bfrecebimento.num-pedido = pnum-pedido      AND
        bfrecebimento.numero-ordem = pnumero-ordem  NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrecebimento THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrecebimento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecebimento DBOProgram 
PROCEDURE goToRecebimento :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro
  Parameters:
               recebe valor do rowid prazo compra
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    def input param prPrazoCompra as rowid no-undo.
    
    find prazo-compra where rowid(prazo-compra) = prPrazoCompra no-lock no-error.
    if avail prazo-compra then do:
        find ordem-compra where ordem-compra.numero-ordem        = prazo-compra.numero-ordem no-lock no-error.
        find item         where ordem-compra.it-codigo           = item.it-codigo no-lock no-error.
        find emitente     where emitente.cod-emitente            = ordem-compra.cod-emitente no-lock no-error.
        find last bfrecebimento where bfrecebimento.num-pedido   = ordem-compra.num-pedido and
                                      bfrecebimento.numero-ordem = ordem-compra.numero-ordem and
                                      bfrecebimento.parcela      = prazo-compra.parcela and
                                      bfrecebimento.cod-movto    = 1 no-lock no-error.
        /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfrecebimento THEN
            RETURN "NOK":U.
       
    end.    
    else 
        return "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrecebimento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem-Fornec DBOProgram 
PROCEDURE linkToItem-Fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM ph-item-fornec AS HANDLE NO-UNDO.
    
    RUN getKey IN ph-item-fornec (OUTPUT citCodigo,
                                  OUTPUT iCodEmitente).
    RETURN "OK":U.                                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRecebimento DBOProgram 
PROCEDURE linkToRecebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM ph-recebimento AS HANDLE NO-UNDO.
    
    RUN getKey IN ph-recebimento (OUTPUT iNumPedido,
                                  OUTPUT dDataMovto,
                                  OUTPUT iNumeroOrdem,
                                  OUTPUT iParcela).
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
    define input parameter iAbertura as integer no-undo.
    case iAbertura:
        when 1 then
            run openQueryStatic ("Main").
        when 2 then
            run openQueryStatic ("ByItem").
        when 3 then
            run openQueryStatic ("ByPedido").
        when 4 then
            run openQueryStatic ("ByPedido1").
        when 5 then
            run openQueryStatic ("ByOrdem").
        when 6 then
            run openQueryStatic ("ByPedido2").
        when 7 then
            run openQueryStatic ("ByDataMovto").
        when 8 then
            run openQueryStatic ("ByItem2").  
   end case.                  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDataMovto DBOProgram 
PROCEDURE openQueryByDataMovto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each  {&TableName} NO-LOCK WHERE 
                                      {&TableName}.num-pedido   >= iNumPedidoIni
                                  AND {&TableName}.num-pedido   <= iNumPedidoFim
                                  AND {&TableName}.data-movto   >= dtDataMovtoIni
                                  AND {&TableName}.data-movto   <= dtDataMovtoFim
                                  AND {&TableName}.numero-ordem >= iNumeroOrdemIni
                                  AND {&TableName}.numero-ordem <= iNumeroOrdemFim
                                  AND {&TableName}.parcela      >= iParcelaIni
                                  AND {&TableName}.parcela      <= iParcelaFim 
                                  AND {&TableName}.num-pedido   > 0  
                                  by  {&TableName}.data-movto INDEXED-REPOSITION.
    return "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                     {&tablename}.it-codigo     = cItCodigo
                                 AND {&TableName}.cod-emitente  = iCodEmitente 
                                 AND {&TableName}.numero-ordem >= iNumeroOrdemIni
                                 AND {&TableName}.numero-ordem <= iNumeroOrdemFim
                                 AND {&TableName}.num-pedido   >= iNumPedidoIni
                                 AND {&TableName}.num-pedido   <= iNumPedidoFim
                                 AND {&TableName}.data-movto   >= dtDataMovtoIni
                                 AND {&TableName}.data-movto   <= dtDataMovtoFim NO-LOCK INDEXED-REPOSITION.
    return "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem2 DBOProgram 
PROCEDURE openQueryByItem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     open query {&QueryName} for each {&TableName} where
                                      {&tablename}.it-codigo  =  citCodigo 
                                  AND {&TableName}.data-movto >= dtDataMovtoIni 
                                  AND {&TableName}.data-movto <= dtDataMovtoFim NO-LOCK INDEXED-REPOSITION. 

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem DBOProgram 
PROCEDURE openQueryByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} WHERE
                                     {&TableName}.num-pedido   = iNumPedido   and
                                     {&TableName}.numero-ordem = iNumeroOrdem and
                                     {&TableName}.parcela      = iParcela     NO-LOCK INDEXED-REPOSITION.
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido DBOProgram 
PROCEDURE openQueryByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each  {&TableName} where
                                      {&TableName}.cod-emitente =  iCodEmitente    and 
                                      {&TableName}.data-movto   >= dtDataMovtoIni  and
                                      {&TableName}.data-movto   <= dtDataMovtoFim  and
                                      {&TableName}.data-nota    >= dtDataNotaIni   and
                                      {&TableName}.data-nota    <= dtDataNotaFIm   and
                                      {&TableName}.serie-nota   >= cSerieNotaIni   and
                                      {&TableName}.serie-nota   <= cSerieNotaFim   and
                                      {&TableName}.numero-nota  >= cNumeroNotaIni  and
                                      {&TableName}.numero-nota  <= cNumeroNotaFim  and
                                      {&TableName}.num-pedido   >= iNumPedidoIni   and
                                      {&TableName}.num-pedido   <= iNumPedidoFim   and
                                      {&TableName}.numero-ordem >= iNumeroOrdemIni and
                                      {&TableName}.numero-ordem <= iNumeroOrdemFim and
                                      {&TableName}.parcela      >= iParcelaIni     and
                                      {&TableName}.parcela      <= iParcelaFim     NO-LOCK     
                                   BY {&TableName}.num-pedido   INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido1 DBOProgram 
PROCEDURE openQueryByPedido1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName} for each {&TableName} WHERE recebimento.num-pedido > 0 NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido2 DBOProgram 
PROCEDURE openQueryByPedido2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each  {&TableName} WHERE 
                                      {&TableName}.num-pedido   >= iNumPedidoIni
                                  AND {&TableName}.num-pedido   <= iNumPedidoFim
                                  AND {&TableName}.num-pedido   > 0 NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido3 DBOProgram
PROCEDURE openQueryByPedido3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName} for each {&TableName} WHERE {&TableName}.num-pedido = iNumPedido NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH recebimento NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValorUnitarioConvertido DBOProgram 
PROCEDURE retornaValorUnitarioConvertido :
/*------------------------------------------------------------------------------
  Purpose:    Valida valor Unit rio a ser retornado.
  Parameters: ipar1 : pRowid     : Rowid Recebimento.
              ipar2 : piMoeda    : Medio do Movto-estoq.
              opar3 : pdeValUnit : Valor Unit rio a ser retornado.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pRowid       as rowid.
    def input  param piMoeda      as integer no-undo.
    def output param pdeValUnit   as decimal no-undo.
    
    find first recebimento where rowid(recebimento) = pRowid no-lock no-error. 
    
    run cdp/cd0812.p (input 0, input piMoeda,
                      input recebimento.preco-unit,
                      input recebimento.data-nota,
                      output pdeValUnit).
   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piEmitente         as int   no-undo.
    def input param pcItCodigo         as char  no-undo.
    def input param piNumeroOrdemIni   as int   no-undo.
    def input param piNumeroOrdemFim   as int   no-undo.
    def input param piNumPedidoIni     as int   no-undo.
    def input param piNumPedidoFim     as int   no-undo.
    def input param pdtDataMovtoIni    as date  no-undo.
    def input param pdtDataMovtoFim    as date  no-undo. 
    
    run setConstraintByItem (piEmitente, pcItCodigo, piNumeroOrdemIni, piNumeroOrdemFim,
                             piNumPedidoIni, piNumPedidoFim, pdtDataMovtoIni, pdtDataMovtoFim).
                        
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcDataMovtoIni     as char  no-undo.  
    def input param pcDataNotaIni      as char  no-undo.
    def input param pcSerieNotaIni     as char  no-undo.
    def input param pcNumeroNotaIni    as char  no-undo.    
    def input param pcNumeroNotaFim    as char  no-undo.    
    def input param pcNumPedidoIni     as char  no-undo.
    def input param pcNumeroOrdemIni   as char  no-undo.
    def input param pcParcelaIni       as char  no-undo.    
    def input param pcDataMovtoFim     as char  no-undo.  
    def input param pcDataNotaFim      as char  no-undo.
    def input param pcSerieNotaFim     as char  no-undo.
    def input param pcNumPedidoFim     as char  no-undo.
    def input param pcNumeroOrdemFim   as char  no-undo.
    def input param pcParcelaFim       as char  no-undo.    
    def input param pcEmitente         as char  no-undo.
    
    run setConstraintByPedido (int(pcEmitente), 
                               int(pcNumeroOrdemIni), 
                               int(pcNumeroOrdemFim),
                               int(pcNumPedidoIni),
                               int(pcNumPedidoFim), 
                               date(pcDataMovtoIni), 
                               date(pcDataMovtoFim), 
                               date(pcDataNotaIni),
                               date(pcDataNotaFim), 
                               pcSerieNotaIni, 
                               pcSerieNotaFim, 
                               pcNumeroNotaIni, 
                               pcNumeroNotaFim,
                               int(pcParcelaIni), 
                               int(pcParcelaFim)).
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prChave as rowid no-undo.
  
    run setConstraintByOrdem (prChave).
      
    return "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint5 DBOProgram 
PROCEDURE setConstraint5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcNumPedidoIni     as char  no-undo.
    def input param pcNumPedidoFim     as char  no-undo.

    run setConstraintByPedido1 (int(pcNumPedidoIni),
                                int(pcNumPedidoFim)).
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prItem        as rowid no-undo.
    def input param pcDataMovIni as char  no-undo.
    def input param pcDataMovFim as char  no-undo.

    run setConstraintByItem1 (prItem, 
                              date(pcDataMovIni),
                              date(pcDataMovFim)).
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piEmitente         as int   no-undo.
    def input param pcItCodigo         as char  no-undo.
    def input param piNumeroOrdemIni   as int   no-undo.
    def input param piNumeroOrdemFim   as int   no-undo.
    def input param piNumPedidoIni     as int   no-undo.
    def input param piNumPedidoFim     as int   no-undo.
    def input param pdtDataMovtoIni    as date  no-undo.
    def input param pdtDataMovtoFim    as date  no-undo. 

    assign   iCodEmitente        = piEmitente 
             cItCodigo           = pcItCodigo
             iNumeroOrdemIni     = piNumeroOrdemIni
             iNumeroOrdemFim     = piNumeroOrdemFim
             iNumPedidoIni       = piNumPedidoIni
             iNumPedidoFim       = piNumPedidoFim
             dtDataMovtoIni      = pdtDataMovtoIni
             dtDataMovtoFim      = pdtDataMovtoFim.
    
    return "OK":U.             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem1 DBOProgram 
PROCEDURE setConstraintByItem1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prItem        as rowid no-undo.
    def input param pdtDataMovIni as date  no-undo.
    def input param pdtDataMovFim as date  no-undo.

    find first item where rowid(item) = prItem no-lock no-error.   
    assign cItCodigo = item.it-codigo.  
    if avail item then 
       assign dtDataMovtoIni = pdtDataMovIni
              dtDataMovtoFim = pdtDataMovFim. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByOrdem DBOProgram 
PROCEDURE setConstraintByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prChave as rowid no-undo.

    find recebimento where rowid(recebimento) = prChave no-lock no-error.     
    if avail recebimento then 
        assign iNumPedido   = recebimento.num-pedido
               iNumeroOrdem = recebimento.numero-ordem
               iParcela     = recebimento.parcela.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByOrdem2 DBOProgram 
PROCEDURE setConstraintByOrdem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piNumeroOrdemIni   as int   no-undo.
    def input param piNumeroOrdemFim   as int   no-undo.
    def input param piNumPedidoIni     as int   no-undo.
    def input param piNumPedidoFim     as int   no-undo.
    def input param pdtDataMovtoIni    as date  no-undo.
    def input param pdtDataMovtoFim    as date  no-undo. 

    assign   iNumeroOrdemIni     = piNumeroOrdemIni
             iNumeroOrdemFim     = piNumeroOrdemFim
             iNumPedidoIni       = piNumPedidoIni
             iNumPedidoFim       = piNumPedidoFim
             dtDataMovtoIni      = pdtDataMovtoIni
             dtDataMovtoFim      = pdtDataMovtoFim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPedido DBOProgram 
PROCEDURE setConstraintByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piEmitente          as inte  no-undo.
    def input param piNumeroOrdemIni    as inte  no-undo.
    def input param piNumeroOrdemFim    as inte  no-undo.    
    def input param piNumPedidoIni      as inte  no-undo.
    def input param piNumPedidoFim      as inte  no-undo.    
    def input param pdtDataMovtoIni     as date  no-undo.  
    def input param pdtDataMovtoFim     as date  no-undo.  
    def input param pdtDataNotaIni      as date  no-undo.
    def input param pdtDataNotaFim      as date  no-undo.
    def input param pcSerieNotaIni      as char  no-undo.
    def input param pcSerieNotaFim      as char  no-undo.
    def input param pcNumeroNotaIni     as char  no-undo.
    def input param pcNumeroNotaFim     as char  no-undo.
    def input param piParcelaIni        as inte  no-undo.    
    def input param piParcelaFim        as inte  no-undo.    

    assign  iCodEmitente      = piEmitente
            iNumeroOrdemIni   = piNumeroOrdemIni
            iNumeroOrdemFim   = piNumeroOrdemFim
            iNumPedidoIni     = piNumPedidoIni
            iNumPedidoFim     = piNumPedidoFim
            dtDataMovtoIni    = pdtDataMovtoIni
            dtDataMovtoFim    = pdtDataMovtoFim
            dtDataNotaIni     = pdtDataNotaIni
            dtDataNotaFim     = pdtDataNotaFim
            cSerieNotaIni     = pcSerieNotaIni
            cSerieNotaFim     = pcSerieNotaFim
            cNumeroNotaIni    = pcNumeroNotaIni
            cNumeroNotaFim    = pcNumeroNotaFim
            iParcelaIni       = piParcelaIni
            iParcelaFim       = piParcelaFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPedido1 DBOProgram 
PROCEDURE setConstraintByPedido1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
    def input param piNumPedidoIni   as inte  no-undo.
    def input param piNumPedidoFim   as inte  no-undo.

     assign  iNumPedidoIni     = int(piNumPedidoIni)
             iNumPedidoFim     = int(piNumPedidoFim).
    
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPedido3 DBOProgram
PROCEDURE setConstraintByPedido3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
    def input param piNumPedido as integer no-undo.

    assign  iNumPedido = piNumPedido.
    
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


