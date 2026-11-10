/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD065 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD065 MPD}
&ENDIF


/********************************************************************************
** Programa : aneft065.p
** Fun»’o   : Sender de Pre‡o PadrÆo
** Data     : 12/2007
** Autor    : Marcelo Bittencourt
********************************************************************************/

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                       AS CHAR. 
DEF VAR c-message                    AS CHAR.
DEF VAR c-campo                      AS CHAR.
DEF VAR c-AttributeSale              AS CHAR.
DEF VAR c-AttributeSaleCollection    AS CHAR.
DEF VAR c-AttributeSaleInformation   AS CHAR.
DEF VAR c-FromRole                   AS CHAR NO-UNDO.
DEF VAR c-ToRole                     AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

FOR EACH preco-pad NO-LOCK:
    IF preco-pad.nome-abrev <> ? THEN
        FIND FIRST emitente WHERE emitente.nome-abrev = preco-pad.nome-abrev NO-LOCK NO-ERROR.

    RUN pi-corpo-msg.
END.


WRITExml().

RETURN "OK":U.

/* PROCEDURES */
PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("AttributeSale":U,"1.01.001":U,"1":U)
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message":U)
               c-AttributeSale = AddElement(c-message,"AttributeSale":U)
                 c-AttributeSaleCollection = AddElement(c-AttributeSale,"AttributeSaleCollection":U)
                 c-FromRole = AddElement(c-AttributeSale,"FromRole":U)
                 c-ToRole = AddElement(c-AttributeSale,"ToRole":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-AttributeSaleInformation = AddElement(c-AttributeSaleCollection,"AttributeSaleInformation":U)
             c-campo = AddEleInt (c-AttributeSaleInformation,"ChannelSales":U,     IF preco-pad.cod-canal-venda <> ? THEN preco-pad.cod-canal-venda ELSE 0)
             c-campo = AddEleInt (c-AttributeSaleInformation,"GroupCustomer":U,    IF preco-pad.cod-gr-cli <> ? THEN preco-pad.cod-gr-cli ELSE 0)
             c-campo = AddEleInt (c-AttributeSaleInformation,"Customer":U,         IF avail(emitente) AND emitente.cod-emitente <> ? THEN emitente.cod-emitente ELSE 0)
             c-campo = AddEleChar(c-AttributeSaleInformation,"Region":U,           IF preco-pad.nome-ab-reg <> ? THEN preco-pad.nome-ab-reg ELSE "0")
             c-campo = AddEleInt (c-AttributeSaleInformation,"PaymentCondition":U, IF preco-pad.cod-cond-pag <> ? THEN preco-pad.cod-cond-pag ELSE 0)
             c-campo = AddEleChar(c-AttributeSaleInformation,"State":U,            IF preco-pad.estado <> ? THEN preco-pad.estado ELSE "0")
             c-campo = AddEleInt (c-AttributeSaleInformation,"Country":U,          IF preco-pad.cod-pais <> ? THEN preco-pad.cod-pais ELSE 0)
             c-campo = AddEleChar(c-AttributeSaleInformation,"CommercialFamily":U, IF preco-pad.fm-cod-com <> ? THEN preco-pad.fm-cod-com ELSE "0")
             c-campo = AddEleChar(c-AttributeSaleInformation,"CommercialProduct":U,IF preco-pad.cod-produto-coml <> ? THEN preco-pad.cod-produto-coml ELSE "0")
             c-campo = AddEleChar(c-AttributeSaleInformation,"ItemIdentifier":U,   IF preco-pad.it-codigo <> ? THEN preco-pad.it-codigo ELSE "0")
             c-campo = AddEleDate(c-AttributeSaleInformation,"InitialDate":U,      preco-pad.dat-inic-validade,"")
             c-campo = AddEleDate(c-AttributeSaleInformation,"FinalDate":U,        preco-pad.dat-fim-validade,"")
             c-campo = AddEleChar(c-AttributeSaleInformation,"PriceTable":U,       preco-pad.nr-tabpre)
             c-campo = AddEleDeci(c-AttributeSaleInformation,"PercentYield":U,     preco-pad.pct-min-rentab).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
             c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                        THEN STRING(i-cod-emitente)
                                                                        ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF

