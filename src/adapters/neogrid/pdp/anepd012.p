/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD012 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd012 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd012.p 
**  Funcao  : Sender da Tabela de Precos
**  Data    : 09/2002
**  Autor   : 
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF BUFFER b-preco-item FOR preco-item.

DEF VAR c-root                      AS CHAR NO-UNDO.
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-FromRole                  AS CHAR NO-UNDO.
DEF VAR c-ToRole                    AS CHAR NO-UNDO.
DEF VAR c-CataloguePrice            AS CHAR NO-UNDO.
DEF VAR c-ProductLineItemCollection AS CHAR NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

FIND tb-preco 
    WHERE ROWID(tb-preco) = p-rowid NO-LOCK NO-ERROR.

IF AVAIL tb-preco THEN DO:
    RUN pi-cabecalho-msg.
    RUN pi-corpo-msg.
    RUN pi-rodape-msg.
    WRITExml().
END.
ELSE RETURN "NOK".
  
PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("CataloguePrice","1.01.001","1")
           c-message = AddElement(c-root,"Message")
           c-CataloguePrice = AddElement(c-message,"CataloguePrice")
           c-ProductLineItemCollection = AddElement(c-CataloguePrice,"ProductLineItemCollection").
    IF tb-preco.observacoes > "" THEN
        ASSIGN c-campo = AddEleChar(c-CataloguePrice,"Comment",TRIM(tb-preco.observacoes)).
    ASSIGN c-FromRole = AddElement(c-CataloguePrice,"FromRole")
           c-ToRole = AddElement(c-CataloguePrice,"ToRole").
            
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    DEF VAR c-CataloguePriceInformation     AS CHAR NO-UNDO.    
    DEF VAR c-CataloguePriceValueCollection AS CHAR NO-UNDO.
    DEF VAR c-CataloguePriceValue           AS CHAR NO-UNDO.    
    DEF VAR c-CataloguePriceState           AS CHAR NO-UNDO.
    DEF VAR c-ProductLineItem               AS CHAR NO-UNDO.
    DEF VAR c-PriceViewCollection           AS CHAR NO-UNDO.
    DEF VAR c-PriceView                     AS CHAR NO-UNDO.
    DEF VAR c-PriceViewState                AS CHAR NO-UNDO.
    DEF VAR c-PriceValueCollection          AS CHAR NO-UNDO.
    DEF VAR c-PriceValue                    AS CHAR NO-UNDO.
    DEF VAR c-DaysCorrectToForeignCurrency  AS CHAR NO-UNDO.
    DEF VAR c-AverageTime                   AS CHAR NO-UNDO.
    DEF VAR c-MonetaryAmount                AS CHAR NO-UNDO.
    DEF VAR c-Amount                        AS CHAR NO-UNDO.
    DEF VAR c-LegacyCurrencyCode            AS CHAR NO-UNDO.
    
    /*IF  tb-preco.desconto > 0 THEN 
        ASSIGN c-campo = AddEleChar(c-CataloguePriceValue,"ValueIdentifier","2")
               c-campo = AddEleDeci(c-CataloguePriceValue,"Percent",tb-preco.desconto).
             
    ASSIGN c-CataloguePriceState = AddElement(c-CataloguePriceInformation,"CataloguePriceState")
             c-campo = AddEleInt(c-CataloguePriceState,"State",tb-preco.situacao)
             c-campo = AddEleDate(c-CataloguePriceState,"InitialDate",tb-preco.dt-inival,"")
             c-campo = AddEleDate(c-CataloguePriceState,"FinalDate",tb-preco.dt-fimval,"")
           c-ProductLineItemCollection = AddElement(c-CataloguePriceInformation,"ProductLineItemCollection").*/

    FOR EACH preco-item NO-LOCK
        WHERE preco-item.nr-tabpre = tb-preco.nr-tabpre:
        
        FIND FIRST b-preco-item
             WHERE b-preco-item.nr-tabpre = preco-item.nr-tabpre
               AND b-preco-item.it-codigo = preco-item.it-codigo
               AND b-preco-item.cod-refer = preco-item.cod-refer
               AND b-preco-item.quant-min = preco-item.quant-min
               AND b-preco-item.dt-inival > preco-item.dt-inival NO-LOCK NO-ERROR.
        
        ASSIGN c-ProductLineItem = AddElement(c-ProductLineItemCollection,"ProductLineItem")
               c-campo = AddEleChar(c-ProductLineItem,"LegacyProductIdentifier",preco-item.it-codigo).
                 
        IF preco-item.cod-refer <> "" THEN
            ASSIGN c-campo = AddEleChar(c-ProductLineItem,"LegacyProductReference",preco-item.cod-refer).
            
        /*ASSIGN c-campo = AddEleDeci(c-ProductLineItem,"MinimumQuantity",preco-item.quant-min).*/
        
        FIND ITEM 
            WHERE ITEM.it-codigo = preco-item.it-codigo NO-LOCK NO-ERROR.
                                                       
        IF AVAIL ITEM THEN
            ASSIGN c-campo = AddEleChar(c-ProductLineItem,"ProductDescription",ITEM.desc-item)
                   c-campo = AddEleChar(c-ProductLineItem,"ProductDetailing",ITEM.narrativa)
                   c-campo = AddEleChar(c-ProductLineItem,"Comment",ITEM.narrativa).
                   
        ASSIGN c-PriceViewCollection = AddElement(c-ProductLineItem,"PriceViewCollection")
               c-PriceView = AddElement(c-PriceViewCollection,"PriceView")
               c-PriceViewState = AddElement(c-PriceView,"PriceViewState")
               c-campo = AddEleInt(c-PriceViewState,"State",preco-item.situacao)
               c-campo = AddEleDate(c-PriceViewState,"InitialDate",preco-item.dt-inival,"")
               c-campo = AddEleDate(c-PriceViewState,"FinalDate",IF AVAIL b-preco-item THEN b-preco-item.dt-inival - 1
                                                                 ELSE tb-preco.dt-fimval,"")
               c-PriceValueCollection = AddElement(c-PriceView,"PriceValueCollection").
                       
        IF preco-item.desco-quant > 0 THEN
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                   c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","2")  /* Perc. Descto */
                   c-campo = AddEleDeci(c-PriceValue,"Percent",preco-item.desco-quant).
                         
        IF preco-item.preco-venda > 0 THEN                                                             
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                   c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","28")  /* Preco de Tabela - CIF (com frete incluso) */
                   c-MonetaryAmount = AddElement(c-PriceValue,"MonetaryAmount")                     
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",preco-item.preco-venda)   
                   c-campo = AddEleint(c-MonetaryAmount,"LegacyCurrencyCode",tb-preco.mo-codigo).

        IF preco-item.preco-fob > 0 THEN
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                   c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","46")  /* Preco Tabela - FOB (sem frete incluso) */
                   c-MonetaryAmount = AddElement(c-PriceValue,"MonetaryAmount")                     
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",preco-item.preco-fob)   
                   c-campo = AddEleint(c-MonetaryAmount,"LegacyCurrencyCode",tb-preco.mo-codigo).

        IF preco-item.preco-min-cif > 0 THEN
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                   c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","47")  /* Preco M¡nimo Tabela - CIF (com frete incluso) */
                   c-MonetaryAmount = AddElement(c-PriceValue,"MonetaryAmount")                     
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",preco-item.preco-min-cif)   
                   c-campo = AddEleint(c-MonetaryAmount,"LegacyCurrencyCode",tb-preco.mo-codigo).

        /* Preco Min FOB */
        IF preco-item.preco-min-fob > 0 THEN
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                   c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","48")  /* Preco M¡nimo Tabela - FOB (sem frete incluso) */
                   c-MonetaryAmount = AddElement(c-PriceValue,"MonetaryAmount")                     
                   c-campo = AddEleDeci(c-MonetaryAmount,"Amount",preco-item.preco-min-fob)   
                   c-campo = AddEleint(c-MonetaryAmount,"LegacyCurrencyCode",tb-preco.mo-codigo).

       /* IF  preco-item.val-pct-lucro > 0 THEN
            ASSIGN c-PriceValue = AddElement(c-PriceValueCollection,"PriceValue")
                     c-campo = AddEleChar(c-PriceValue,"ValuesIdentifier","49")
                     c-campo = AddEleDeci(c-PriceValue,"Percent",preco-item.val-pct-lucro).*/
    END.
END PROCEDURE.
                                                                                            
PROCEDURE pi-rodape-msg:
    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF i-cod-emitente <> 0 THEN STRING(i-cod-emitente)
                                                                    ELSE "")
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").

END PROCEDURE.
