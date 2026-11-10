/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD058 2.00.01.003}  /*** 010103 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd058 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd058.p
**  Funcao  : Sender de Estabelecimentos
**  Data    : 09/2002
**  Autor   : Jean Renato
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

{cdp/cdcfgdis.i} /* Pre-processadores Distribuicao */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root            AS CHAR NO-UNDO. 
DEF VAR c-message         AS CHAR NO-UNDO.
DEF VAR c-UpdateSite      AS CHAR NO-UNDO.
DEF VAR c-SiteCollection  AS CHAR NO-UNDO.
DEF VAR c-SiteInformation AS CHAR NO-UNDO.
DEF VAR c-AdminSalePrice  AS CHAR NO-UNDO.
DEF VAR c-campo           AS CHAR NO-UNDO.
DEF VAR c-FromRole        AS CHAR NO-UNDO.
DEF VAR c-ToRole          AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

FIND FIRST param-global NO-LOCK NO-ERROR.

IF  p-rowid <> ? THEN DO:
    FIND estabelec WHERE ROWID(estabelec) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL estabelec THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH estabelec NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateSite","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdateSite = AddElement(c-message,"UpdateSite")
                 c-SiteCollection = AddElement(c-UpdateSite,"SiteCollection")
                 c-FromRole = AddElement(c-UpdateSite,"FromRole")
                 c-ToRole = AddElement(c-UpdateSite,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-SiteInformation = AddElement(c-SiteCollection,"SiteInformation")
           c-campo = AddEleChar(c-SiteInformation,"SiteCode",estabelec.cod-estabel)
           c-campo = AddEleChar(c-SiteInformation,"SiteName",estabelec.nome)
           c-campo = &IF '{&bf_dis_versao_ems}':U >= '2.071':U &THEN 
                        AddEleChar(c-SiteInformation,"CompanyCode",estabelec.ep-codigo) 
                    &ELSE 
                        AddEleInt(c-SiteInformation,"CompanyCode",estabelec.ep-codigo) 
                    &ENDIF.

    FIND par-preco WHERE par-preco.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.
    IF  AVAIL par-preco THEN DO:
        RUN pi-corpo-price-msg.
    END.

END PROCEDURE.

PROCEDURE pi-corpo-price-msg:
    ASSIGN c-AdminSalePrice = AddElement(c-SiteInformation,"AdminSalePrice")
            c-campo = AddEleInt(c-AdminSalePrice,"RejectMinimumPrice", Par-preco.rejeita-pre-min)
            c-campo = AddEleChar(c-AdminSalePrice,"RejectYield", IF Par-preco.rejeita-rentab THEN 'True' ELSE 'False')
            c-campo = AddEleDeci(c-AdminSalePrice,"MinPercentYield",Par-preco.pct-min-renta)
            c-campo = AddEleDeci(c-AdminSalePrice,"PercentDeductExpend",Par-preco.dec-1)
            c-campo = AddEleInt(c-AdminSalePrice,"AccountCostType",estabelec.custo-contab)
            c-campo = AddEleChar(c-AdminSalePrice,"UseCostModule",IF param-global.modulo-cs THEN 'True' ELSE 'False')
            c-campo = AddEleInt(c-AdminSalePrice,"WeightChannelSales",Par-preco.peso-canal)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightGroupCustomer",Par-preco.peso-gr-cli)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightCustomer",Par-preco.peso-cliente)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightRegion",Par-preco.peso-regiao)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightCountry",Par-preco.peso-pais)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightState",Par-preco.peso-estado)
            c-campo = AddEleInt(c-AdminSalePrice,"WeightPaymentCondition",Par-preco.peso-cond-pag).

END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                    THEN STRING(i-cod-emitente)
                                                                    ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF


