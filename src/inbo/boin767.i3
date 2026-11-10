/***********************************************************************************
* Temp-tables utilizadas na boin767.p e mla0170rp.p                                *
*                                                                                  *
* situacao: 'Mantido', 'Novo', 'Substitu¡do', 'Eliminado', 'Origem', 'Transferido' * 
* id-sit  :     1    ,    2  ,       3      ,       4    ,     5   ,       6       * 
* r-rowid : rowid do registro alterado,exclu¡do ou inserido.                       * 
***********************************************************************************/ 
DEFINE TEMP-TABLE tt-mla-doc-pend-aprov NO-UNDO LIKE mla-doc-pend-aprov
    FIELD situacao      AS CHAR FORMAT "x(20)"
    FIELD id-sit        AS INT
    FIELD observacao    AS CHAR FORMAT "x(150)"
    FIELD usuar-destino AS CHAR
    FIELD r-rowid       AS ROWID
    INDEX codigo        ep-codigo
                        cod-estabel
                        cod-tip-doc
                        chave-doc
                        situacao.

DEFINE TEMP-TABLE tt-mla-doc-sit NO-UNDO LIKE tt-mla-doc-pend-aprov.
