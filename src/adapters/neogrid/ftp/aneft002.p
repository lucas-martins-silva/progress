/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT002 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft002 MAN}
&ENDIF

/********************************************************************************
** Programa : aneft002.p
** Fun»’o   : Sender de Mensagens de Erro e Advertencia
** Data     : 11/2000
** Autor    : Jean Renato Kormann
********************************************************************************/

{adapters/neogrid/include/anein004.i}

/**** Defini»’o da tt-erro-neogrid ****/
 {adapters/neogrid/ftp/aneft002.i}
/******************************/

DEF INPUT PARAM TABLE FOR tt-erro-neogrid.

DEF VAR c-root                AS CHAR NO-UNDO. 
DEF VAR c-message             AS CHAR NO-UNDO.
DEF VAR c-campo               AS CHAR NO-UNDO.
DEF VAR c-returnerror         AS CHAR NO-UNDO.
DEF VAR c-origindocidentifier AS CHAR NO-UNDO.
DEF VAR c-errormsgcollection  AS CHAR NO-UNDO.
DEF VAR c-errormsg            AS CHAR NO-UNDO.

RUN senderrormessage.

PROCEDURE senderrormessage:
    FIND FIRST tt-erro-neogrid NO-LOCK.
    RUN BuildErrorHeader.
    FOR EACH tt-erro-neogrid NO-LOCK:
        RUN BuildErrorBody.
    END.
    WriteXML().
END.

PROCEDURE BuildErrorHeader:
    ASSIGN c-root = CreateNeoGridDoc("Exception","1.01.001",tt-erro-neogrid.c-cod-estabel)
           c-message = AddElement(c-root,"Message")
           c-returnerror = AddElement(c-message,"ReturnError")
           c-origindocidentifier = AddEleChar(c-returnerror,"OriginDocIdentifier",tt-erro-neogrid.c-doc-origem)
           c-errormsgcollection = AddElement(c-returnerror,"ErrorMsgCollection").
END.

PROCEDURE BuildErrorBody:
    ASSIGN c-errormsg = AddElement(c-errormsgcollection,"ErrorMsg")
           c-campo = AddEleInt(c-errormsg,"MessageType",tt-erro-neogrid.i-cod-erro)
           c-campo = AddEleChar(c-errormsg,"ErrorDescription",tt-erro-neogrid.c-desc-erro).
END.

