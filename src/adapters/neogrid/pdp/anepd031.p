/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD031 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD031 MPD}
&ENDIF

/******************************************************************************
**  Programa: anepd030.p
**  Funcao  : Sender de Par³metros
**  Data    : 03/2008
**  Autor   : Otaner Marcelo Demarchi
******************************************************************************/
{cdp/cdcfgdis.i}

DEF INPUT PARAMETER c-parametros-row    AS ROWID    NO-UNDO.
DEF INPUT PARAMETER changecode          AS CHAR     NO-UNDO.

DEF VAR c-root                  AS CHAR NO-UNDO. 
DEF VAR c-message               AS CHAR NO-UNDO.
DEF VAR c-parametros            AS CHAR NO-UNDO.
DEF VAR c-parametros-collection AS CHAR NO-UNDO.
DEF VAR c-campo                 AS CHAR NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF c-parametros-row <> ? THEN DO:
    FIND FIRST param-global WHERE ROWID(param-global) = c-parametros-row NO-LOCK NO-ERROR.
        RUN pi-corpo-parametros.
END.
ELSE DO:
    FOR EACH portador NO-LOCK:
        RUN pi-corpo-parametros.
    END.
 END.

WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("GlobalParameter","1.01.001","1")
           c-message = AddElement(c-root,"CRM")
           c-message = AddElement(c-root,"Message")
           c-parametros-collection = AddElement(c-message,"GlobalParameterCollection").
END PROCEDURE.

PROCEDURE pi-corpo-parametros:
    ASSIGN c-parametros = AddElement(c-parametros-collection,"GlobalParameterInformation")
        c-campo = AddEleChar(c-parametros, "ModuleVendor",  IF param-global.modulo-05
                                                            THEN "True" ELSE "False").
END PROCEDURE.
