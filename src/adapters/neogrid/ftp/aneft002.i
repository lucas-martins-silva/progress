/*************************************************************************
**
** ANEFT002.I - Include Defini‡Æo Tabela Tempor ria Erros
**
**************************************************************************/

DEF TEMP-TABLE tt-erro-neogrid NO-UNDO
    FIELD c-doc-origem  AS CHAR
    FIELD c-cod-estabel LIKE ESTABELEC.COD-ESTABEL
    FIELD i-cod-erro    AS INT
    FIELD c-desc-erro   AS CHAR.

