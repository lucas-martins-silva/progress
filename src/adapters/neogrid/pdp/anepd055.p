/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD055 2.00.00.002}  /*** 010002 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd055 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd055.p
**  Funcao  : Sender de Motivo de Cancelamento/Reprova‡Æo
**  Data    : 12/2008
**  Autor   : Jean Vieira
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root            AS CHAR NO-UNDO. 
DEF VAR c-message         AS CHAR NO-UNDO.
DEF VAR c-UpdateMotivo    AS CHAR NO-UNDO.
DEF VAR c-MotivoCollection  AS CHAR NO-UNDO.
DEF VAR c-MotivoInformation AS CHAR NO-UNDO.
DEF VAR c-campo           AS CHAR NO-UNDO.
DEF VAR c-FromRole        AS CHAR NO-UNDO.
DEF VAR c-ToRole          AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND motivo WHERE ROWID(motivo) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL motivo THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH motivo NO-LOCK:
        RUN pi-corpo-msg.
    END.

WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("ReasonsForDisapprovalCancellation","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdateMotivo = AddElement(c-message,"ReasonsForDisapprovalCancellation")
                 c-MotivoCollection = AddElement(c-UpdateMotivo,"ReasonsCollection")
                 c-FromRole = AddElement(c-UpdateMotivo,"FromRole")
                 c-ToRole = AddElement(c-UpdateMotivo,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-MotivoInformation = AddElement(c-MotivoCollection,"ReasonsInformation")
             c-campo = AddEleInt(c-MotivoInformation,"ReasonsCode",motivo.cod-motivo)
             c-campo = AddEleChar(c-MotivoInformation,"ReasonsDescription",motivo.descricao)
             c-campo = AddEleInt(c-MotivoInformation,"ReasonsType",motivo.ind-tp-trans)
             c-campo = AddEleChar(c-MotivoInformation,"ReasonsNarrative",motivo.narrativa).
END PROCEDURE.

&ENDIF


