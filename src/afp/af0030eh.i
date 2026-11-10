/******************************************************************
**               Temp-Table para passar o html                   **
******************************************************************/ 

DEFINE TEMP-TABLE tt-html NO-UNDO
    FIELD seq-html     AS INT
    FIELD html-doc     AS CHAR 
    INDEX i-seq-mensagem
          seq-html        ASCENDING.
