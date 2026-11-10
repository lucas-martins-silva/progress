/*********************************************************************************
**
**  apapi012a.i
**
**  Defini‡Æo das temp-tablesïs.
**
**********************************************************************************/

{app/apapi227.i}

def temp-table tt-erro-prepara no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

def temp-table tt-antecip NO-UNDO
    FIELD estabelec     AS CHAR  
    field cod-esp       AS CHAR
    FIELD serie         AS CHAR 
    FIELD nr-docto      AS CHAR
    FIELD parcela       AS CHAR
    FIELD fornec        AS INT 
    FIELD estabelec-ant AS CHAR 
    FIELD cod-esp-ant   AS CHAR 
    FIELD serie-ant     AS CHAR 
    FIELD nr-docto-ant  AS CHAR  
    FIELD parcela-ant   AS CHAR 
    FIELD fornec-ant    AS INT 
    FIELD bordero       AS INT 
    FIELD dt-antecip    AS DATE 
    FIELD vl-antecip    AS DEC 
    field confirma      AS LOG  
    field rw-antecip    AS ROWID 
    FIELD estado        AS INT 
    FIELD gravado       AS LOG    
    FIELD antecip-IR    AS LOG.
