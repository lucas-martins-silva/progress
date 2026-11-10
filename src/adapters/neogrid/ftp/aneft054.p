/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT054 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT054 MFT}
&ENDIF


/******************************************************************************
**  Programa: aneft054.p
**  Funcao  : Sender de Series
**  Data    : 09/2002
**  Autor   : Jean Renato
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                    AS CHAR NO-UNDO. 
DEF VAR c-message                 AS CHAR NO-UNDO.
DEF VAR c-UpdateSerialNumber      AS CHAR NO-UNDO.
DEF VAR c-SerialNumberCollection  AS CHAR NO-UNDO.
DEF VAR c-SerialNumberInformation AS CHAR NO-UNDO.
DEF VAR c-campo                   AS CHAR NO-UNDO.
DEF VAR c-FromRole                AS CHAR NO-UNDO.
DEF VAR c-ToRole                  AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND serie WHERE ROWID(serie) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL serie THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH serie NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateSerialNumber","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdateSerialNumber = AddElement(c-message,"UpdateSerialNumber")
                 c-SerialNumberCollection = AddElement(c-UpdateSerialNumber,"SerialNumberCollection")
                 c-FromRole = AddElement(c-UpdateSerialNumber,"FromRole")
                 c-ToRole = AddElement(c-UpdateSerialNumber,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-SerialNumberInformation = AddElement(c-SerialNumberCollection,"SerialNumberInformation")
             c-campo = AddEleChar(c-SerialNumberInformation,"SerialNumberID",serie.serie)
             c-campo = AddEleChar(c-SerialNumberInformation,"SerialNumberDescription","").
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


