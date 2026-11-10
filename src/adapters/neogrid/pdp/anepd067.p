/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD067 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD067 MPD}
&ENDIF


/********************************************************************************
** Programa : aneft065.p
** Fun»’o   : Sender de Item Estabelecimento
** Data     : 12/2007
** Autor    : Marcelo Bittencourt
********************************************************************************/

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                 AS CHAR. 
DEF VAR c-message              AS CHAR.
DEF VAR c-campo                AS CHAR.
DEF VAR c-SiteItem             AS CHAR.
DEF VAR c-SiteItemCollection   AS CHAR.
DEF VAR c-SiteItemInformation  AS CHAR.
DEF VAR c-FromRole             AS CHAR NO-UNDO.
DEF VAR c-ToRole               AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF p-rowid <> ? THEN
    FOR EACH item-estab WHERE ROWID(item-estab) = p-rowid NO-LOCK:
        RUN pi-corpo-msg.
    END.
ELSE
    FOR EACH item-estab NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.

WRITExml().

RETURN "OK":U.

/* PROCEDURES */
PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("SiteItem":U,"1.01.001":U,"1":U)
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message":U)
               c-SiteItem = AddElement(c-message,"SiteItem":U)
                 c-SiteItemCollection = AddElement(c-SiteItem,"SiteItemCollection":U)
                 c-FromRole = AddElement(c-SiteItem,"FromRole":U)
                 c-ToRole = AddElement(c-SiteItem,"ToRole":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-SiteItemInformation = AddElement(c-SiteItemCollection,"SiteItemInformation":U)
           c-campo = AddEleChar(c-SiteItemInformation,"ItemIdentifier",item-estab.it-codigo)
           c-campo = AddEleChar(c-SiteItemInformation,"BranchCode",    item-estab.cod-estab)
           c-campo = AddEleDate(c-SiteItemInformation,"StdDate",       item-estab.padrao-ate,"")
           c-campo = AddEleDeci(c-SiteItemInformation,"CostStd-MP",    item-estab.val-unit-mat-p[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostStd-MOB",   item-estab.val-unit-mob-p[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostStd-GGF",   item-estab.val-unit-ggf-p[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostMed-MP",    item-estab.val-unit-mat-m[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostMed-MOB",   item-estab.val-unit-mob-m[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostMed-GGF",   item-estab.val-unit-ggf-m[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostOnL-MP",    item-estab.val-unit-mat-o[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostOnL-MOB",   item-estab.val-unit-mob-o[1])
           c-campo = AddEleDeci(c-SiteItemInformation,"CostOnL-GGF",   item-estab.val-unit-ggf-o[1]).

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

