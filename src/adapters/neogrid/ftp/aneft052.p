/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT052 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT052 MFT}
&ENDIF


/********************************************************************************
** Programa : aneft002.p
** Fun‡Æo   : Sender de Mensagens de Erro e Advertencia
** Data     : 11/2000
** Autor    : Jean Renato Kormann
********************************************************************************/

{adapters/neogrid/include/anein004.i}

/**** Defini‡Æo da tt-erro-neogrid ****/
 {adapters/neogrid/ftp/aneft002.i}
/******************************/

DEF INPUT PARAM TABLE FOR tt-erro-neogrid.

DEF VAR c-root                AS CHAR. 
DEF VAR c-message             AS CHAR.
DEF VAR c-campo               AS CHAR.
DEF VAR c-returnerror         AS CHAR.
DEF VAR c-origindocidentifier AS CHAR.
DEF VAR c-errormsgcollection  AS CHAR.
DEF VAR c-errormsg            AS CHAR.

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
    ASSIGN
    c-root = CreateNeoGridDoc("Exception","1.01.001",tt-erro-neogrid.c-cod-estabel)
      c-message = AddElement(c-root,"CRM")
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

