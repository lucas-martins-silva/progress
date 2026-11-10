/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD011 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD011 MPD}
&ENDIF


/******************************************************************************
**  Programa: anepd011.p 
**  Funcao  : Sender do Grupo de Clientes
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

DEF VAR c-root                     AS CHAR NO-UNDO.
DEF VAR c-message                  AS CHAR NO-UNDO.
DEF VAR c-campo                    AS CHAR NO-UNDO.
DEF VAR c-FromRole                 AS CHAR NO-UNDO.
DEF VAR c-ToRole                   AS CHAR NO-UNDO.
DEF VAR c-UpdateCustomerGroup      AS CHAR NO-UNDO.
DEF VAR c-CustomerGroupCollection  AS CHAR NO-UNDO.
DEF VAR c-CustomerGroupInformation AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND gr-cli WHERE ROWID(gr-cli) = p-rowid NO-LOCK NO-ERROR.
    IF   AVAIL gr-cli THEN
         RUN   pi-corpo-msg.
END.
ELSE
    FOR EACH gr-cli NO-LOCK:
        RUN  pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                             = CreateNeoGridDoc("UpdateCustomerGroup","1.01.001","1")
             c-message                        = AddElement(c-root,"Message")
               c-UpdateCustomerGroup          = AddElement(c-message,"UpdateCustomerGroup")
                 c-CustomerGroupCollection    = AddElement(c-UpdateCustomerGroup,"CustomerGroupCollection")
                 c-FromRole                   = AddElement(c-UpdateCustomerGroup,"FromRole")
                 c-ToRole                     = AddElement(c-UpdateCustomerGroup,"ToRole").
END PROCEDURE.


PROCEDURE pi-corpo-msg:

    IF  gr-cli.cod-gr-cli <> 0 THEN
        ASSIGN c-CustomerGroupInformation = AddElement(c-CustomerGroupCollection,"CustomerGroupInformation")
                 c-campo                  = AddEleInt(c-CustomerGroupInformation,"GroupCode",gr-cli.cod-gr-cli)
                 c-campo                  = AddEleChar(c-CustomerGroupInformation,"GroupDescription",gr-cli.descricao).
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
