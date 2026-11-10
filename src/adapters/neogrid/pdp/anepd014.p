/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD014 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD014 MPD}
&ENDIF


/******************************************************************************
**  Programa: anepd014.p  
**  Funcao  : Sender de Canais de Venda
**  Data    : 10/2002
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

DEF VAR c-root                           AS CHAR NO-UNDO. 
DEF VAR c-message                        AS CHAR NO-UNDO.
DEF VAR c-UpdateDistributionChannel      AS CHAR NO-UNDO.
DEF VAR c-DistributionChannelCollection  AS CHAR NO-UNDO.
DEF VAR c-DistributionChannelInformation AS CHAR NO-UNDO.
DEF VAR c-campo                          AS CHAR NO-UNDO.
DEF VAR c-FromRole                       AS CHAR NO-UNDO.
DEF VAR c-ToRole                         AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND canal-venda WHERE ROWID(canal-venda) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL canal-venda THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH canal-venda NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateDistributionChannel","1.01.001","1")
             c-message = AddElement(c-root,"Message")
               c-UpdateDistributionChannel = AddElement(c-message,"UpdateDistributionChannel")
                 c-DistributionChannelCollection = AddElement(c-UpdateDistributionChannel,"DistributionChannelCollection")
                 c-FromRole = AddElement(c-UpdateDistributionChannel,"FromRole")
                 c-ToRole = AddElement(c-UpdateDistributionChannel,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-DistributionChannelInformation = AddElement(c-DistributionChannelCollection,"DistributionChannelInformation")
             c-campo = AddEleInt(c-DistributionChannelInformation,"DistributionChannelCode",canal-venda.cod-canal-venda)
             c-campo = AddEleChar(c-DistributionChannelInformation,"DistributionChannelDescription",canal-venda.descricao).
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


