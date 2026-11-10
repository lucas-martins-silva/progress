/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT001 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT001 MUT}
&ENDIF


/********************************************************************************
** Programa : aneut001.p
** Fun‡Æo   : Execu‡Æo de Programas
** Data     : 05/2000
** Autor    : Neogrid
********************************************************************************/

{adapters/neogrid/include/anein005.i}

DEF VAR p-program AS CHAR.
DEF VAR p-token   AS CHAR.
DEF VAR p-root    AS CHAR.
DEF VAR p-doc     AS CHAR.

ASSIGN p-root = GetRoot().

IF  GetName(p-root) <> "NeoGridDoc" THEN
    RETURN.

ASSIGN p-token = Get(p-root,"GlobalDocumentFunctionCode")
         p-doc = GetValue(p-token).

FIND FIRST NGProcessMapping WHERE DocType = p-doc NO-LOCK NO-ERROR.

IF  AVAILABLE NGProcessMapping THEN
    ASSIGN p-program = NGProcessMapping.Program.
ELSE
    RETURN.
    
IF  Trim(p-program) = "" THEN
    RETURN.

ASSIGN p-program = Trim(p-program) + ".p".

RUN VALUE(p-program) (INPUT TABLE tt-element-in, INPUT TABLE tt-attribute-in).
