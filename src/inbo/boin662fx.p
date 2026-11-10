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
{include/i-prgvrs.i boin662fx 2.00.00.005} /* 17/06/2025 16:40:51 */
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN662
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName necessidade-oc
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
{inbo/boin662fx.i RowObject}

{fch/fchmat/fchmatkeeptrackofstocklevels.i1 ttStockLevelsWhs}
{fch/fchmat/fchmatkeeptrackofstocklevels.i2 ttStockLevelsParam}
{fch/fchmat/fchmatkeeptrackofstocklevels.i ttStockLevels}
{fch/fchmat/fchmatkeeptrackofstocklevels.i ttPurchaseRequirements}
{fch/fchmat/fchmatkeeptrackofstocklevels.i3 ttRowid}
{cep/api/v1/purchaserequirements.i ttStockLevelsHTML}

{cep/ce0340.i}  /* tt-param */

define temp-table tt-digita no-undo
    field cod-estabel like estabelec.cod-estabel
    field cod-depos   like deposito.cod-depos
    field descricao   like deposito.nome 
    field cons-saldo  like deposito.cons-saldo
    field lista         as logical FORMAT "*/ " LABEL "X"
    index id is primary cod-estabel.

def temp-table tt-entrega no-undo
    field cd-freq        like frequencia.cd-freq /*cod. da frequencia de */
    field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
    field dat-entrega    as date.

def temp-table tt-item-estab-prin no-undo
    field it-codigo   like item.it-codigo
    field cod-estabel like estabelec.cod-estabel
    index codigo is primary unique
    it-codigo cod-estabel.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{include/i-epc200.i "CE0340RP"} /* Definiá∆o TT-EPC */


{include/i-rpvar.i}
def var c-it-codigo-aux     like item.it-codigo            no-undo.
def var c-cod-estabel-aux   like estabelec.cod-estabel     no-undo.
def var de-consumo-prev-aux like item.consumo-prev         no-undo.
def var i-tipo-est-seg-aux  like item.tipo-est-seg         no-undo.
def var de-quant-segur-aux  like item.quant-segur          no-undo.
def var i-tempo-segur-aux   like item.tempo-segur          no-undo.
def var i-res-int-comp-aux  like item.res-int-comp         no-undo.
def var i-res-for-comp-aux  like item.res-for-comp         no-undo.
def var i-res-cq-comp-aux   like item.res-cq-comp          no-undo.
def var de-pto-enc-aux      like item-mat.ponto-encomenda  no-undo.
def var de-fator-refugo-aux like item.fator-refugo         no-undo.
def var de-quant-perda-aux  like item.quant-perda          no-undo.
def var de-lote-economi-aux like item.lote-economi         no-undo.
def var de-lote-minimo-aux  like item.lote-minimo          no-undo.
def var de-lote-multipl-aux like item.lote-multipl         no-undo.
def var i-cd-freq-aux       like item-mat.cd-freq          no-undo.
def var da-ult-ressup-aux   like item-mat.data-ult-ressup  no-undo.
def var de-lote-max-aux     like item-mat.lote-per-max     no-undo.
def var i-ind               as integer                     no-undo.
def var i-situacao          as integer extent 3            no-undo.
def var i-per-corrente      as integer no-undo.
def var i-ano-corrente      as integer no-undo.
def var da-iniper-fech      like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech      like param-estoq.ult-fech-dia no-undo.
def var i-mes-aux           as integer no-undo format "99".
def var h-acomp             as handle  no-undo.
def var c-acompanha         as char    no-undo.
def var de-cons-proj        like item-uni-estab.consumo-prev no-undo. /* Consumo previsto projetado */
def var de-qt-nec           as decimal   no-undo.
def var de-qt-estoque       as decimal   no-undo.
def var de-qt-cc            as decimal   no-undo.
def var de-qt-req           as decimal   no-undo.
def var de-qt-sol           as decimal   no-undo.
def var de-nr-lotes         as decimal   no-undo.
def var de-pto-enc          as decimal   no-undo.
def var da-data             as date      format "99/99/9999" no-undo.
def var l-gerou-necessidade as logical   no-undo.
def var i-cont              as integer   no-undo.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
define buffer bf{&TableName} for {&TableName}.
define buffer b-item-uni-estab for item-uni-estab.
define buffer b-estab-mat for estab-mat.
define buffer b-item-mat for item-mat.

{cep/ce0340.i1} /* procedure pi-pto-encomenda */
{cep/ce0340.i2} /* procedure pi-periodico */

DEFINE VARIABLE c-purchaser AS CHARACTER NO-UNDO.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-geracao":U THEN ASSIGN pFieldValue = RowObject.data-geracao.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "estoque-dispo":U THEN ASSIGN pFieldValue = RowObject.estoque-dispo.
        WHEN "qt-compras":U THEN ASSIGN pFieldValue = RowObject.qt-compras.
        WHEN "qt-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-ordem.
        WHEN "qt-orig":U THEN ASSIGN pFieldValue = RowObject.qt-orig.
        WHEN "qt-pendente":U THEN ASSIGN pFieldValue = RowObject.qt-pendente.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "tp-geracao":U THEN ASSIGN pFieldValue = RowObject.tp-geracao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice estabel
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE necessidade-oc.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE necessidade-oc.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pit-codigo = RowObject.it-codigo.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchaseRequirements DBOProgram 
PROCEDURE getPurchaseRequirements :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttRowid.
    DEFINE OUTPUT PARAMETER TABLE FOR ttStockLevels.

    def var de-qt-saldo as decimal no-undo.
    def var de-qtd-ord  as decimal no-undo.
    def var c-estoq-segur as char extent 2 no-undo.

    {utp/ut-liter.i Quantidade * r}
    assign c-estoq-segur[1] = trim(return-value).
    
    {utp/ut-liter.i Tempo * r}
    assign c-estoq-segur[2] = trim(return-value).

    EMPTY TEMP-TABLE ttStockLevels NO-ERROR.
    
    find first ttStockLevelsParam no-error.
    
    if  can-find(first ttRowid) then

        for each ttRowid,
            first necessidade-oc
            where rowid(necessidade-oc) = to-rowid(ttRowid.rRowid) no-lock: 

            find item 
                where item.it-codigo = necessidade-oc.it-codigo no-lock no-error.

            create ttStockLevels.
            assign ttStockLevels.site                   = necessidade-oc.cod-estabel
                   ttStockLevels.item                   = necessidade-oc.it-codigo
                   ttStockLevels.needDate               = necessidade-oc.data-geracao
                   ttStockLevels.deliveryDate           = necessidade-oc.data-entrega
                   ttStockLevels.description            = ITEM.desc-item
                   ttStockLevels.unitOfMeasure          = ITEM.un
                   ttStockLevels.qtyToBuy               = necessidade-oc.qt-ordem
                   ttStockLevels.purchaseRequisitionQty = necessidade-oc.qt-compras
                   ttStockLevels.onHandBalanceQty       = necessidade-oc.estoque-dispo
                   ttStockLevels.grouping               = ttStockLevels.item + " - " + ttStockLevels.description
                                                        + " - " + ttStockLevels.unitOfMeasure.
            
            find first item-uni-estab where
                 item-uni-estab.it-codigo   = necessidade-oc.it-codigo and
                 item-uni-estab.cod-estabel = necessidade-oc.cod-estabel no-lock no-error.
            if  not avail item-uni-estab then do:

                find item-mat where
                     item-mat.it-codigo = item.it-codigo no-lock no-error.

                assign ttStockLevels.safetyStockType        = item.tipo-est-seg
                       ttStockLevels.safetyQty              = item.quant-segur
                       ttStockLevels.safetyTime             = item.tempo-segur
                       ttStockLevels.safetyStockDescription = if  item.tipo-est-seg = 1 then 
                                                                  c-estoq-segur[1] /*quantidade*/
                                                              else
                                                                  c-estoq-segur[2] /*tempo*/
                       ttStockLevels.reorderPoint           = item-mat.ponto-encomenda
                       ttStockLevels.totalTime              = item.res-int-comp + item.res-for-comp + item.res-cq-comp 
                       ttStockLevels.economic               = item.lote-economi
                       ttStockLevels.minimum                = item.lote-minimo
                       ttStockLevels.multiple               = item.lote-multipl
                       ttStockLevels.lostQty                = item.quant-perda
                       ttStockLevels.scrapFactor            = item.fator-refugo
                       ttStockLevels.forecastedUsage        = item.consumo-prev
                       ttStockLevels.controlQualityTime     = item.res-cq-comp  
                       ttStockLevels.supplierTime           = item.res-for-comp
                       ttStockLevels.purchaseTime           = item.res-int-comp
                       ttStockLevels.safetyStock            = (if  item.tipo-est-seg = 1 then 
                                                                   item.quant-segur
                                                               else 
                                                                   item.tempo-segur * item.consumo-prev / 30).
            end.
            else
                assign ttStockLevels.safetyStockType        = item-uni-estab.tipo-est-seg
                       ttStockLevels.safetyQty              = item-uni-estab.quant-segur
                       ttStockLevels.safetyTime             = item-uni-estab.tempo-segur 
                       ttStockLevels.safetyStockDescription = if  item-uni-estab.tipo-est-seg = 1 then 
                                                                  c-estoq-segur[1] /*quantidade*/
                                                              else
                                                                  c-estoq-segur[2] /*tempo*/
                       ttStockLevels.reorderPoint           = item-uni-estab.ponto-encomenda
                       ttStockLevels.totalTime              = item-uni-estab.res-int-comp + item-uni-estab.res-for-comp + item-uni-estab.res-cq-comp
                       ttStockLevels.economic               = item-uni-estab.lote-economi   
                       ttStockLevels.minimum                = item-uni-estab.lote-multipl   
                       ttStockLevels.multiple               = item-uni-estab.lote-minimo
                       ttStockLevels.lostQty                = item-uni-estab.quant-perda
                       ttStockLevels.scrapFactor            = item-uni-estab.fator-refugo
                       ttStockLevels.forecastedUsage        = item-uni-estab.consumo-prev
                       ttStockLevels.controlQualityTime     = item-uni-estab.res-cq-comp
                       ttStockLevels.supplierTime           = item-uni-estab.res-for-comp
                       ttStockLevels.purchaseTime           = item-uni-estab.res-int-comp
                       ttStockLevels.safetyStock            = (if  item-uni-estab.tipo-est-seg = 1 then 
                                                                   item-uni-estab.quant-segur
                                                               else 
                                                                   item-uni-estab.tempo-segur * item-uni-estab.consumo-prev / 30).
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchaseRequirementsHTML DBOProgram 
PROCEDURE getPurchaseRequirementsHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttRowid.
    DEFINE OUTPUT PARAMETER TABLE FOR ttStockLevelsHTML.

    def var de-qt-saldo as decimal no-undo.
    def var de-qtd-ord  as decimal no-undo.
    def var c-estoq-segur as char extent 2 no-undo.

    {utp/ut-liter.i Quantidade * r}
    assign c-estoq-segur[1] = trim(return-value).
    
    {utp/ut-liter.i Tempo * r}
    assign c-estoq-segur[2] = trim(return-value).

    EMPTY TEMP-TABLE ttStockLevelsHTML NO-ERROR.
    
    find first ttStockLevelsParam no-error.
    
    if  can-find(first ttRowid) THEN DO:
    
        for each ttRowid,
            first necessidade-oc
            where rowid(necessidade-oc) = to-rowid(ttRowid.rRowid) no-lock: 

            find item 
                where item.it-codigo = necessidade-oc.it-codigo no-lock no-error.

            create ttStockLevelsHTML.
            assign ttStockLevelsHTML.site                   = necessidade-oc.cod-estabel
                   ttStockLevelsHTML.item                   = necessidade-oc.it-codigo
                   ttStockLevelsHTML.needDate               = necessidade-oc.data-geracao
                   ttStockLevelsHTML.deliveryDate           = necessidade-oc.data-entrega
                   ttStockLevelsHTML.description            = ITEM.desc-item
                   ttStockLevelsHTML.unitOfMeasure          = ITEM.un
                   ttStockLevelsHTML.qtyToBuy               = necessidade-oc.qt-ordem
                   ttStockLevelsHTML.typeGeneration         = necessidade-oc.tp-geracao.
            
            find first item-uni-estab where
                 item-uni-estab.it-codigo   = necessidade-oc.it-codigo and
                 item-uni-estab.cod-estabel = necessidade-oc.cod-estabel no-lock no-error.
            if  not avail item-uni-estab then do:

                find item-mat where
                     item-mat.it-codigo = item.it-codigo no-lock no-error.

                assign ttStockLevelsHTML.safetyQty              = item.quant-segur
                       ttStockLevelsHTML.reorderPoint           = item-mat.ponto-encomenda
                       ttStockLevelsHTML.totalTime              = item.res-int-comp + item.res-for-comp + item.res-cq-comp 
                       ttStockLevelsHTML.forecastedUsage        = item.consumo-prev.
            end.
            else
                assign ttStockLevelsHTML.safetyQty              = item-uni-estab.quant-segur
                       ttStockLevelsHTML.reorderPoint           = item-uni-estab.ponto-encomenda
                       ttStockLevelsHTML.totalTime              = item-uni-estab.res-int-comp + item-uni-estab.res-for-comp + item-uni-estab.res-cq-comp
                       ttStockLevelsHTML.forecastedUsage        = item-uni-estab.consumo-prev.
        end.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidPurchaseRequirements DBOProgram 
PROCEDURE getRowidPurchaseRequirements :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM initialDate as date no-undo.
    DEF INPUT PARAM finalDate as date no-undo.   
    DEFINE INPUT  PARAMETER TABLE FOR ttStockLevelsParam.
    DEFINE INPUT  PARAMETER TABLE FOR ttStockLevelsWhs.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRowid.

    find first ttStockLevelsParam no-error.
    
    find first param-compra no-lock no-error.

    if  can-find(first necessidade-oc) then

        for each estabelec fields (cod-estabel) where
            estabelec.cod-estabel >= ttStockLevelsParam.siteInitial and
            estabelec.cod-estabel <= ttStockLevelsParam.siteFinal no-lock:

            blk:
            for each necessidade-oc fields (tp-geracao it-codigo) where
                necessidade-oc.cod-estabel   = estabelec.cod-estabel          and
                necessidade-oc.it-codigo    >= ttStockLevelsParam.itemInitial and
                necessidade-oc.it-codigo    <= ttStockLevelsParam.itemFinal   and
                necessidade-oc.data-geracao >= InitialDate and
                necessidade-oc.data-geracao <= FinalDate   and 
                necessidade-oc.qt-pendente   > 0 no-lock: 

                for first item fields (it-codigo fm-codigo ge-codigo) where
                     item.it-codigo = necessidade-oc.it-codigo no-lock: end.

                if  item.ge-codigo > ttStockLevelsParam.inventoryGroupFinal  
                or  item.ge-codigo < ttStockLevelsParam.inventoryGroupInitial then
                    next.

                if  item.fm-codigo > ttStockLevelsParam.familyFinal
                or  item.fm-codigo < ttStockLevelsParam.familyInitial then
                    next.

                for first item-uni-estab fields (tp-ressup cod-grp-compra cod-comprado)
                    where item-uni-estab.it-codigo = necessidade-oc.it-codigo
                    and   item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.

                if  item-uni-estab.tp-ressup > 1
                and ttStockLevelsParam.typeControl = 2 then
                    next.

                if  item-uni-estab.tp-ressup < 3
                and ttStockLevelsParam.typeControl = 1 then
                    next.
                 
                IF c-purchaser <> "" THEN DO:
                    IF param-compra.int-2 = 1 THEN DO: // GRUPO DE COMPRAS
                        // POSICIONA NO GRUPO COMPRAS DO ITEM ESTABELECIMENTO
                        FIND FIRST grupo-compra NO-LOCK
                             WHERE grupo-compra.cod-grp-compra = item-uni-estab.cod-grp-compra  NO-ERROR.
                        IF AVAIL grupo-compra THEN DO:
                            // VERIFICA O USUARUIO PASSADO COMO PARAMETRO … COMPRADOR                          
                            FOR FIRST comprador NO-LOCK
                                WHERE comprador.cod-comprado =  c-purchaser:                             
                                 // SE O GRUPO DE COMPRAS DO COMPRADOR FOR DIFERENTE DO GRUPO DE COMPRAS DO ITEM
                                IF NOT CAN-FIND(FIRST gr-cmp-comprad 
                                                WHERE gr-cmp-comprad.cod-comprado   = comprador.cod-comprado 
                                                  AND gr-cmp-comprad.cod-grp-compra = grupo-compra.cod-grp-compra ) THEN DO:
                                    NEXT blk.
                                END.
                            END.
                        END.
                    END.
                    ELSE IF param-compra.int-2 = 2 THEN DO: // COMPRADOR
                        IF item-uni-estab.cod-comprado <> c-purchaser THEN
                            NEXT blk.
                    END.
                END.
                
                /* necessidade-oc.tp-geracao 
                    val1 Atingimento Ponto Encomenda
                    val2 Per°odo de Compras
                    val3 Rompimento de Estoque
                */
                if  (necessidade-oc.tp-geracao = 1 and ttStockLevelsParam.typeControl = 2) 
                or  (necessidade-oc.tp-geracao = 2 and ttStockLevelsParam.typeControl = 1) 
                or  (necessidade-oc.tp-geracao = 3 and ttStockLevelsParam.typeControl = 1) then do:

                    create ttRowid.
                    assign ttRowid.rRowid = string(rowid(necessidade-oc)).
                end.
            end.
        end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getStockLevelsWhs DBOProgram 
PROCEDURE getStockLevelsWhs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def output param table for ttStockLevelsWhs.

    empty temp-table ttStockLevelsWhs.

    for each localizacao fields (cod-depos cod-estabel) no-lock:

        for first ttStockLevelsWhs
            where ttStockLevelsWhs.warehouse = localizacao.cod-depos 
            and   ttStockLevelsWhs.site      = localizacao.cod-estabel: end.
        if  not avail ttStockLevelsWhs then do:

            create ttStockLevelsWhs.
            assign ttStockLevelsWhs.warehouse = localizacao.cod-depos
                   ttStockLevelsWhs.site      = localizacao.cod-estabel.

            for first deposito fields (nome cons-saldo)
                where deposito.cod-depos = localizacao.cod-depos no-lock: end.
            if  avail deposito then 
                assign ttStockLevelsWhs.warehouseDescription = deposito.nome
                       ttStockLevelsWhs.onHandBalanceQty     = deposito.cons-saldo.
        end.
    end.

end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice estabel
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE necessidade-oc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE necessidade-oc.it-codigo NO-UNDO.

    FIND FIRST bfnecessidade-oc WHERE 
        bfnecessidade-oc.cod-estabel = pcod-estabel AND 
        bfnecessidade-oc.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnecessidade-oc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnecessidade-oc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE keepStockLevels DBOProgram 
PROCEDURE keepStockLevels :
/*:T------------------------------------------------------------------------------
  Purpose:     geracao das necessidades
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param initialDate as date no-undo.
    define input param finalDate   as date no-undo.
    define input  parameter table for tt-param.
    define input  parameter table for tt-digita.
    define input  parameter table for ttStockLevels.
    define output parameter table for ttRowid.

    empty temp-table tt-item-estab-prin.
    empty temp-table ttRowid.

    find first tt-param no-error.

    find first ttStockLevels no-error.

    if  not avail ttStockLevels then 

        for each grup-estoque fields (ge-codigo) 
            where grup-estoque.ge-codigo >= tt-param.ge-ini 
              and grup-estoque.ge-codigo <= tt-param.ge-fim no-lock:
        
            for each item fields (it-codigo ge-codigo fm-codigo) 
                where item.ge-codigo = grup-estoque.ge-codigo 
                  and item.it-codigo >= tt-param.item-ini     
                  and item.it-codigo <= tt-param.item-fim     
                  and item.fm-codigo >= tt-param.familia-ini  
                  and item.fm-codigo <= tt-param.familia-fim no-lock:
        
                for each item-uni-estab fields(it-codigo cod-estabel deposito-pad)
                    where item-uni-estab.it-codigo     = item.it-codigo         
                      and item-uni-estab.cod-estabel  >= tt-param.estabelec-ini 
                      and item-uni-estab.cod-estabel  <= tt-param.estabelec-fim 
                      and item-uni-estab.deposito-pad >= tt-param.depos-ini     
                      and item-uni-estab.deposito-pad <= tt-param.depos-fim  no-lock:

                    create ttStockLevels.
                    assign ttStockLevels.item = item.it-codigo 
                           ttStockLevels.site = item-uni-estab.cod-estabel.
                end.
            end.
        end.

    find first param-estoq  no-lock no-error.
    find first param-global no-lock no-error.
    find first empresa
        where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

    run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                        output da-iniper-x,
                        output da-fimper-x,
                        output i-per-corrente,
                        output i-ano-corrente,
                        output da-iniper-fech,
                        output da-fimper-fech).

    /*Elimina necessidades */
    run cep/ceapi306.p (input tt-param.elimina,
                        input tt-param.periodico,
                        input tt-param.pto-enc,
                        input table ttStockLevels).

    bloco:
    for each ttStockLevels:
             
        assign l-gerou-necessidade = no.

        find item-mat
            where item-mat.it-codigo = item.it-codigo no-lock no-error.

        for first item  fields (it-codigo    fm-codigo    ge-codigo       demanda 
                          cod-obsoleto compr-fabric emissao-ord     consumo-prev
                          tipo-est-seg quant-segur  tempo-segur     res-int-comp
                          res-for-comp res-cq-comp  fator-refugo    quant-perda  
                          lote-economi lote-minimo  lote-multipl    tipo-contr deposito-pad) 
            where item.it-codigo = ttStockLevels.item no-lock: end.
        if  not avail item then
            next bloco.

        for first estab-mat fields (cod-estabel cod-estabel-prin) 
            where estab-mat.cod-estabel = ttStockLevels.site no-lock: end.
        if  not avail estab-mat then
            next bloco.

        find first tt-item-estab-prin
            where tt-item-estab-prin.it-codigo   = item.it-codigo
            and   tt-item-estab-prin.cod-estabel = estab-mat.cod-estabel-prin no-error.
        if  avail tt-item-estab-prin then
            next bloco.

        assign de-qt-nec     = 0
               de-qt-estoque = 0
               de-qt-cc      = 0
               de-qt-req     = 0
               de-qt-sol     = 0.
        
        find item-uni-estab
            where item-uni-estab.it-codigo   = item.it-codigo
            and   item-uni-estab.cod-estabel = estab-mat.cod-estabel-prin no-lock no-error.
        if  avail item-uni-estab then do:

            if  item-uni-estab.tp-ressup < 3 
            and tt-param.periodico then 
                next bloco.

            if  item-uni-estab.tp-ressup > 1 
            and tt-param.pto-enc then 
                next bloco.
            
            if  item-uni-estab.consumo-prev <= 0 
            and tt-param.i-consprev = 1        /* Nao Gerar com Consumo Previsto Zero */
            and item-uni-estab.tp-ressup = 1 then   /* Ressup por Ponto de Encomenda   */
                next bloco.
            
            for each b-estab-mat fields (cod-estabel-prin cod-estabel) 
                where b-estab-mat.cod-estabel-prin = estab-mat.cod-estabel-prin no-lock:

                find first tt-item-estab-prin
                    where  tt-item-estab-prin.it-codigo   = item.it-codigo
                    and    tt-item-estab-prin.cod-estabel = estab-mat.cod-estabel-prin no-error.
                if  not avail tt-item-estab-prin then do:

                    create tt-item-estab-prin.
                    assign tt-item-estab-prin.cod-estabel = estab-mat.cod-estabel-prin
                           tt-item-estab-prin.it-codigo   = item.it-codigo.
                end.

                {cep/ce0340.i3 item-uni-estab b-estab-mat.cod-estabel} /* Verifica saldo dispon≠vel p/ o item */
            end.

            assign de-qt-nec = de-qt-estoque + de-qt-cc. 
    
            if  item-uni-estab.tp-ressup = 1 then do transaction on stop undo, leave: 
    
                {cep/ce0340.i4}
                run pi-pto-encomenda (rowid(item-uni-estab), 1).
            
                if  l-gerou-necessidade then do:
                    create ttRowid.
                    assign ttRowid.rRowid = string(rowid(necessidade-oc)).
                end.
            end.
            else if item-uni-estab.tp-ressup = 3 then do transaction on stop undo, leave: 
    
                if  item-uni-estab.data-ult-ressup = ? 
                or  string(item-uni-estab.data-ult-ressup) = " " then
                    next bloco.
    
                {cep/ce0340.i4}
                assign da-data = ?.
    
                run pi-periodico (output da-data).
    
                if  l-gerou-necessidade then do:
                    create ttRowid.
                    assign ttRowid.rRowid = string(rowid(necessidade-oc)).
                end.

                if  da-data = ? then
                    next bloco.

                find b-item-uni-estab 
                    where rowid(b-item-uni-estab) = rowid(item-uni-estab) exclusive-lock.
                assign b-item-uni-estab.data-ult-ressup = da-data.
                release b-item-uni-estab.
            end.
        end.
        else do:

            if  item-mat.tp-ressup < 3 
            and tt-param.periodico then 
                next bloco.

            if  item-mat.tp-ressup > 1 
            and tt-param.pto-enc then 
                next bloco.

            if  item.consumo-prev  <= 0  
            and tt-param.i-consprev = 1        /* Nao Gerar com Consumo Previsto Zero */
            and item-mat.tp-ressup  = 1  then  /* Ressup por Ponto de Encomenda   */
                next bloco.

            for each b-estab-mat fields (cod-estabel-prin cod-estabel) 
                where b-estab-mat.cod-estabel-prin = estab-mat.cod-estabel-prin no-lock:

                find first tt-item-estab-prin
                    where  tt-item-estab-prin.it-codigo   = item.it-codigo
                    and    tt-item-estab-prin.cod-estabel = estab-mat.cod-estabel-prin no-error.
                if  not avail tt-item-estab-prin then do:

                    create tt-item-estab-prin.
                    assign tt-item-estab-prin.cod-estabel = estab-mat.cod-estabel-prin
                           tt-item-estab-prin.it-codigo   = item.it-codigo.
                end.                

                {cep/ce0340.i3 item-mat b-estab-mat.cod-estabel-prin} /* Verifica saldo dispon≠vel p/ o item */
            end.

            assign de-qt-nec = de-qt-estoque + de-qt-cc. 

            if item-mat.tp-ressup  = 1 then do transaction on stop undo, leave: 

                {cep/ce0340.i5}
                run pi-pto-encomenda (rowid(item-mat), 0).

                if  l-gerou-necessidade then do:
                    create ttRowid.
                    assign ttRowid.rRowid = string(rowid(necessidade-oc)).
                end.
            end.
            else if item-mat.tp-ressup = 3 then do transaction on stop undo, leave: 

                if  item-mat.data-ult-ressup = ? 
                or  string(item-mat.data-ult-ressup) = " " then
                    next bloco.

                {cep/ce0340.i5}
                run pi-periodico (output da-data).

                if  l-gerou-necessidade then do:
                    create ttRowid.
                    assign ttRowid.rRowid = string(rowid(necessidade-oc)).
                end.

                if  da-data = ? then 
                    next bloco.

                find b-item-mat
                    where rowid(b-item-mat) = rowid(item-mat) exclusive-lock.
                assign b-item-mat.data-ult-ressup = da-data.
                release b-item-mat.
            end.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPurchaser DBOProgram
PROCEDURE setPurchaser:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-purchaser AS CHARACTER NO-UNDO.
    
    ASSIGN c-purchaser = pc-purchaser.

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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

