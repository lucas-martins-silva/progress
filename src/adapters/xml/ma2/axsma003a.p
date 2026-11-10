/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA003A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AXSMA003A MMA}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

def temp-table tt-item-eai no-undo like item.

def var iIdTargetList as int no-undo.

def input param table for tt-item-eai.
def input-output param hGenXml     as handle no-undo.
def input param iIdManufacture     as int    no-undo.
def input param iIdTechInformation as int    no-undo.

find first tt-item-eai no-lock no-error.

run addNode in hGenXml (iIdManufacture, "TargetList":U, "", output iIdTechInformation).
run addNode in hGenXml (iIdTechInformation, "TargetListCode":U, tt-item-eai.cod-lista-destino, output iIdTargetList).
find first lista-destino where lista-destino.cd-lista-destino = tt-item-eai.cod-lista-destino no-lock no-error. 
if avail lista-destino then 
    run addNode IN hGenXml (iIdTechInformation, "TargetListDescription":U, substring(lista-destino.desc-lista-dest,1,30), output iIdTargetList). 
