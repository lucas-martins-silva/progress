/*
**
** IMAPI00A.I - Definicoes das temp-tables
**
*/
          
def new global shared temp-table tt-pendentes-001 NO-UNDO
   field cod-desp as integer
   field cod-orig as integer
   index codigo is unique primary
        cod-desp.   
   
/* IMAPI000A.I */
