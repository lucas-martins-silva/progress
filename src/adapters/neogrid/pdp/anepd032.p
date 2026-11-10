/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD032 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD032 MPD}
&ENDIF

/******************************************************************************
**  Programa: anepd030.p
**  Funcao  : Sender do Item Cliente
**  Data    : 03/2008
**  Autor   : Otaner Marcelo Demarchi
******************************************************************************/
{cdp/cdcfgdis.i}

DEF INPUT PARAMETER c-item-cli-row  AS ROWID NO-UNDO.
DEF INPUT PARAMETER change-code     AS CHAR  NO-UNDO.

DEF VAR c-root                 AS CHAR NO-UNDO. 
DEF VAR c-message              AS CHAR NO-UNDO.
DEF VAR c-item-cli             AS CHAR NO-UNDO.
DEF VAR c-item-cli-collection  AS CHAR NO-UNDO.
DEF VAR c-campo                AS CHAR NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF c-item-cli-row <> ? THEN DO:
    FIND FIRST item-cli WHERE ROWID(item-cli) = c-item-cli-row NO-LOCK NO-ERROR.
        RUN pi-corpo-item-cli.
END.
ELSE DO:
    FOR EACH item-cli NO-LOCK:
        RUN pi-corpo-item-cli.
    END.
 END.

WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN  c-root = CreateNeoGridDoc("CustomerCatalogueItem","1.01.001","1")
            c-message = AddElement(c-root,"CRM")
            c-message = AddElement(c-root,"Message")
            c-campo   = AddEleChar(c-message,"TransactionType",change-code) 
            c-item-cli-collection = AddElement(c-message,"CustomerCatalogueItemCollection").
END PROCEDURE.

PROCEDURE pi-corpo-item-cli:
    ASSIGN  c-item-cli = AddElement(c-item-cli-collection,"CustomerCatalogueItemInformation")
            c-campo = AddEleInt (c-item-cli, "CustomerCode", item-cli.cod-emitente)
            c-campo = AddEleChar(c-item-cli, "LegacyProductIdentifier", item-cli.it-codigo)
            c-campo = AddEleChar(c-item-cli, "CustomerProductCode", item-cli.item-do-cli)
            c-campo = AddEleChar(c-item-cli, "UnitOfMeasureCode", item-cli.unid-med-cli)
            c-campo = AddEleDeci(c-item-cli, "ConversionFactor", item-cli.fator-conversao)
            c-campo = AddEleInt (c-item-cli, "DecimalsNumber", item-cli.num-casa-dec)
            c-campo = AddEleDeci(c-item-cli, "CustomerPriceAmount", item-cli.vl-precon)
            c-campo = AddEleDeci(c-item-cli, "ICMSSubsPercent", item-cli.dec-1)
            c-campo = AddEleChar(c-item-cli, "Description", item-cli.narrativa).

END PROCEDURE.
