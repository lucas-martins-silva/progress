/*******************************************************************************
**
**   BOIN534A.I - Defini‡Æo temp-table.
**
********************************************************************************/

def temp-table tt-carga-ctrab no-undo
    field cod-ctrab  like ctrab.cod-ctrab
    field num-turno  like turno-dia.num-turno
    field data       as date format "99/99/9999"
    field hrs-disp   as dec  format "->>>,>>9.9999"
    field hrs-prog   as dec  format "->>>,>>9.9999"
    field hrs-livres as dec  format "->>>,>>9.9999"
    index id is unique primary cod-ctrab num-turno data.
