/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA004A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AXSMA004A MMA}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

def temp-table tt-familia no-undo like familia.

def var iIdTargetList as int no-undo.

def input param table for tt-familia.
def input-output param hGenXml          as handle no-undo.
def input param iId                     as int    no-undo.
def input param iIdFamilyMaint          as int    no-undo.

find first tt-familia no-lock no-error.

RUN addNode IN hGenXml (iId, "TargetList", "", OUTPUT iIdFamilyMaint).
RUN addNode IN hGenXml (iIdFamilyMaint, "TargetListCode", tt-familia.cod-lista-destino, OUTPUT iIdTargetList).
FIND FIRST lista-destino WHERE lista-destino.cd-lista-destino = tt-familia.cod-lista-destino NO-LOCK NO-ERROR. 
IF AVAIL lista-destino THEN
    RUN addNode IN hGenXml (iIdFamilyMaint, "TargetListDescription", SUBSTRING(lista-destino.desc-lista-dest,1,30), OUTPUT iIdTargetList). 
