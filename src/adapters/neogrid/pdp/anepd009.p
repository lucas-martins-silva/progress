/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD009 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD009 MPD}
&ENDIF


/******************************************************************************
**  Programa: anepd009.p 
**  Funcao  : Sender de Representantes
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

DEF VAR c-root                      AS CHAR NO-UNDO.
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-FromRole                  AS CHAR NO-UNDO.
DEF VAR c-ToRole                    AS CHAR NO-UNDO.
DEF VAR c-UpdateRepresentative      AS CHAR NO-UNDO.
DEF VAR c-RepresentativeCollection  AS CHAR NO-UNDO.
DEF VAR c-RepresentativeInformation AS CHAR NO-UNDO.


{include/i-epc200.i anepd009} /*defini‡Æo tt-epc*/

    
&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND repres WHERE ROWID(repres) = p-rowid NO-LOCK NO-ERROR.
    IF   AVAIL repres THEN
         RUN   pi-corpo-msg.
END.
ELSE
    FOR EACH repres NO-LOCK:
        RUN  pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

/*Inicio Chamada de upc*/
FOR EACH tt-epc:
    DELETE tt-epc.
END.
    
CREATE tt-epc.
ASSIGN tt-epc.cod-event     = "EndSenderRepresentativeB2B":U
       tt-epc.cod-parameter = "p-rowid":U
       tt-epc.val-parameter = STRING(p-rowid).
       
 {include/i-epc201.i "EndSenderRepresentativeB2B"}
    

/*Fim Chamada de upc*/

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                              = CreateNeoGridDoc("UpdateRepresentative","1.01.001","1")
             c-message                         = AddElement(c-root,"Message")
               c-UpdateRepresentative          = AddElement(c-message,"UpdateRepresentative")
                 c-RepresentativeCollection    = AddElement(c-UpdateRepresentative,"RepresentativeCollection")
                 c-FromRole                    = AddElement(c-UpdateRepresentative,"FromRole")
                 c-ToRole                      = AddElement(c-UpdateRepresentative,"ToRole").
END PROCEDURE.


PROCEDURE pi-corpo-msg:
    
    ASSIGN c-RepresentativeInformation = AddElement(c-RepresentativeCollection,"RepresentativeInformation")
             c-campo                   = AddEleInt(c-RepresentativeInformation,"RepresentativeCode",repres.cod-rep)
             c-campo                   = AddEleChar(c-RepresentativeInformation,"RepresentativeShortName",repres.nome-abrev)
             c-campo                   = AddEleChar(c-RepresentativeInformation,"RepresentativeName",repres.nome).
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

