/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT014 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft014 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneft014.p
**  Funcao  : Sender de conta-contabil
**  Data    : 06/2002
**  Autor   : Anderson Silvano
**  Versao  :
**  I.00.000 - Anderson Silvano
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */


/************************************************************************
** Este programa foi comentado porque deixar  de ser utilizado 
** no Datasul 11.5.0.
** A Unifica‡Æo de conceitos conta contabil unificou as tabelas de conta
** e centro de custo para que fossem utilizadas as informa‡äes do EMS 5.
** Deste modo as tabelas conta-contab, conta e sub-conta foram eliminadas
*************************************************************************
DEF TEMP-TABLE tt-conta-contab LIKE conta-contab.

DEF INPUT PARAM TABLE FOR tt-conta-contab.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM c-cod-estabel2 LIKE estabelec.cod-estabel NO-UNDO.

{adapters/neogrid/include/anein004.i} /* sender */

DEF VAR c-root                      AS CHAR NO-UNDO. 
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-AccountCollection         AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-Account                   AS CHAR NO-UNDO.
DEF VAR c-AccountInformation        AS CHAR NO-UNDO.
DEF VAR c-FromRole                  AS CHAR NO-UNDO.
DEF VAR c-ToRole                    AS CHAR NO-UNDO.

FIND FIRST tt-conta-contab NO-ERROR.
IF AVAIL tt-conta-contab THEN DO:

    RUN pi-cabecalho-msg.
    RUN pi-corpo-msg.
    RUN pi-rodape-msg.
    WRITExml().
END.

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("updateAccount","1.01.001","1")
             c-message = AddElement(c-root,"Message")
               c-Account = AddElement(c-message,"Account")
                 c-AccountCollection = AddElement(c-Account,"AccountCollection").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-AccountInformation = AddElement(c-AccountCollection,"AccountInformation")
           c-campo = AddEleChar(c-AccountInformation,"AccountCode",tt-conta-contab.conta-contabil)
           c-campo = AddEleChar(c-AccountInformation,"AccountDescription",tt-conta-contab.titulo)
           c-campo = AddEleInt(c-AccountInformation,"DebitCredit",3)
           c-campo = AddEleInt(c-AccountInformation,"Type",tt-conta-contab.tipo)
           c-campo = AddEleInt(c-AccountInformation,"Status",7)
           c-campo = AddEleChar(c-AccountInformation,"CostCenter",tt-conta-contab.sc-codigo).  

    FOR FIRST sub-conta NO-LOCK 
        WHERE sub-conta.sc-codigo = tt-conta-contab.sc-codigo:
        ASSIGN c-campo = AddEleChar(c-AccountInformation,"CostCenterDescription",sub-conta.descricao).
    END.
        
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-FromRole = AddElement(c-Account,"FromRole")
           c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","BUYER")
           c-ToRole = AddElement(c-Account,"ToRole")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

**************************************/
