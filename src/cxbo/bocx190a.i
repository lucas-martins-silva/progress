/*
**  BOcx190a.i
**
**  
**
**  Ultima altera»’o : 06/06/2000 - log110
*/
 
DEFINE TEMP-TABLE {1} 
    field class-fiscal like classif-fisc.class-fiscal 
    field nr-re like proc-ped-ent.nr-re 
    field proc-exp  like processo-exp.nr-proc-exp
    field cod-estab like processo-exp.cod-estabel
    field ncm       like processo-exp.int-2
    field c-rowid as char
    field r-rowid as rowid
    INDEX class-fiscal aS PRIMARY unique class-fiscal ASCENDING. 
