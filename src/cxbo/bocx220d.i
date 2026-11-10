/**********************************************************************************
**
**  BOCX220D.I - Ordens Embarque
**
**********************************************************************************/
define temp-table {1} no-undo
     field embarque like ordens-embarque.embarque
     field cod-estabel like ordens-embarque.cod-estabel
     field identific-container like ordens-embarque.identific-container
     field tipo-container as char format "x(20)"
     field r-rowid        as rowid
     FIELD dDtPrevDev     AS DATE FORMAT "99/99/9999"
     FIELD dDtDevol       AS DATE FORMAT "99/99/9999"
     index codigo is PRIMARY  embarque cod-estabel identific-container.
 
    
/* BOCX220D.I */
