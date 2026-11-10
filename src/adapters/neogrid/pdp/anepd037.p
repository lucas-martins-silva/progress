/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD037 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd037 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd037.p
**  Funcao  : Sender de Empresas
**  Data    : 11/2008
**  Autor   : Marcelo Bittencourt
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

IF  p-rowid <> ? THEN DO:
    FIND empresa WHERE ROWID(empresa) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL empresa THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH empresa NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateCompany","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdateSite = AddElement(c-message,"UpdateCompany")
                 c-SiteCollection = AddElement(c-UpdateSite,"CompanyCollection")
                 c-FromRole = AddElement(c-UpdateSite,"FromRole")
                 c-ToRole = AddElement(c-UpdateSite,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-SiteInformation = AddElement(c-SiteCollection,"CompanyInformation")
             c-campo = &IF '{&bf_dis_versao_ems}':U >= '2.071':U &THEN 
                           AddEleChar(c-SiteInformation,"CompanyCode",empresa.ep-codigo) 
                       &ELSE 
                           AddEleInt(c-SiteInformation,"CompanyCode",empresa.ep-codigo) 
                       &ENDIF
             c-campo = AddEleChar(c-SiteInformation,"CompanyName",empresa.nome)
             c-campo = AddEleChar(c-SiteInformation,"CompanyDescription",empresa.razao-social).
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


