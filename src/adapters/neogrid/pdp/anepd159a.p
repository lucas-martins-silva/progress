/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD159A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd159a MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd159.p 
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
DEF INPUT PARAM c-nome-abrev   LIKE emitente.nome-abrev   NO-UNDO.

DEF VAR c-root                      AS CHAR NO-UNDO.
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-FromRole                  AS CHAR NO-UNDO.
DEF VAR c-ToRole                    AS CHAR NO-UNDO.

DEF VAR c-PriceTable                AS CHAR NO-UNDO.
DEF VAR c-PriceTableCollection      AS CHAR NO-UNDO.
DEF VAR c-PriceTableInformation     AS CHAR NO-UNDO.
DEF VAR c-PriceTableState           AS CHAR NO-UNDO.
DEF VAR c-ProductLineItemCollection AS CHAR NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

FIND tb-preco 
    WHERE ROWID(tb-preco) = p-rowid NO-LOCK NO-ERROR.

/* FIND emitente WHERE emitente.nome-abrev  = c-nome-abrev NO-LOCK NO-ERROR. */

IF AVAIL tb-preco THEN DO:
    RUN pi-cabecalho-msg.
    RUN pi-corpo-msg.
    RUN pi-rodape-msg.
    WRITExml().
END.
ELSE RETURN "NOK".

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root       = CreateNeoGridDoc("PriceTable","1.01.001","1")
           c-message    = AddElement(c-root,"Message")
           c-PriceTable = AddElement(c-message,"PriceTable")
           c-campo      = AddEleChar(c-PriceTable,"GlobalChangeCode","CHANGE")
           c-PriceTableCollection  = AddElement(c-PriceTable,"PriceTableCollection")
           c-PriceTableInformation = AddElement(c-PriceTableCollection,"PriceTableInformation") 
           c-campo = AddEleChar(c-PriceTableInformation,"PriceTableCode",tb-preco.nr-tabpre)
           c-campo = AddEleChar(c-PriceTableInformation,"Name",trim(tb-preco.descricao)) 
           c-campo = AddEleDeci(c-PriceTableInformation,"Discount",tb-preco.Desconto)
           c-campo = AddEleChar(c-PriceTableInformation,"LegacyCurrencyCode",STRING(tb-preco.mo-codigo)).

    /*
    for first moeda fields(mo-codigo sigla) no-lock
        where moeda.mo-codigo = tb-preco.mo-codigo:
        assign c-campo = AddEleChar(c-PriceTableInformation,"LegacyCurrencyCode",moeda.sigla).
    end.
    */
    ASSIGN c-PriceTableState = AddElement(c-PriceTableInformation,"PriceTableState").

    CASE tb-preco.situacao:
        WHEN 1 THEN ASSIGN c-campo = AddEleChar(c-PriceTableState,"State","Active").
        WHEN 2 THEN ASSIGN c-campo = AddEleChar(c-PriceTableState,"State","Inactive").
        /*when 1 then assign c-campo = AddEleChar(c-PriceTableState,"State","Active"). - Simulação*/
    END CASE.
           
    ASSIGN c-campo = AddEleDate(c-PriceTableState,"InitialDate",tb-preco.dt-inival,"")
           c-campo = AddEleDate(c-PriceTableState,"FinalDate",tb-preco.dt-fimval,"")
           c-ProductLineItemCollection = AddElement(c-PriceTableInformation,"ProductLineItemCollection").
    ASSIGN c-FromRole = AddElement(c-PriceTable,"FromRole")
           c-ToRole   = AddElement(c-PriceTable,"ToRole").
            
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    DEF VAR c-ProductLineItem AS CHAR NO-UNDO.
    DEF VAR c-PriceView       AS CHAR NO-UNDO.
    DEF VAR c-PriceViewState  AS CHAR NO-UNDO.

    FOR EACH preco-item NO-LOCK
        WHERE preco-item.nr-tabpre  = tb-preco.nr-tabpre
          AND preco-item.dt-inival <= TODAY,
        FIRST ITEM FIELDS(it-codigo codigo-refer) NO-LOCK
        WHERE ITEM.it-codigo = preco-item.it-codigo  
        BREAK BY preco-item.it-codigo
              BY preco-item.dt-inival:

        IF LAST-OF(preco-item.it-codigo) THEN DO:
            ASSIGN c-ProductLineItem = AddElement(c-ProductLineItemCollection,"ProductLineItem").

            ASSIGN c-campo = AddEleChar(c-ProductLineItem,"LegacyProductIdentifier",preco-item.it-codigo).

            IF preco-item.cod-refer <> "" THEN
                ASSIGN c-campo = AddEleChar(c-ProductLineItem,"LegacyProductReference",preco-item.cod-refer).

            ASSIGN c-PriceView = AddElement(c-ProductLineItem,"PriceView")
                   c-campo     = AddEleDeci(c-PriceView,"Price",preco-item.preco-venda)
                   c-campo     = AddEleDeci(c-PriceView,"QuantityDesc",preco-item.desco-quant)
                   c-campo     = AddEleDeci(c-PriceView,"MinimumQuantity",preco-item.quant-min)
                   c-PriceViewState = AddElement(c-PriceView,"PriceViewState").

            CASE preco-item.situacao:
                WHEN 1 THEN ASSIGN c-campo = AddEleChar(c-PriceViewState,"State","Active").
                WHEN 2 THEN ASSIGN c-campo = AddEleChar(c-PriceViewState,"State","Inactive").
                /*when 1 then assign c-campo = AddEleChar(c-PriceTableState,"State","Active"). - Simulação*/
            END CASE.

            ASSIGN c-campo = AddEleDate(c-PriceViewState,"InitialDate",preco-item.dt-inival,"")
                   c-campo = AddEleDate(c-PriceViewState,"FinalDate",tb-preco.dt-fimval,"").
        END. /** if last-of **/
    END. /** for each preco-item **/ 
    
END PROCEDURE.
                                                                                            
PROCEDURE pi-rodape-msg:
    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").

END PROCEDURE.
