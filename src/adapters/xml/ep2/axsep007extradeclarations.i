/* Definicao de Buffers */
DEF BUFFER b-estabelec FOR estabelec.

/* Definicao de Variaveis */
DEFINE VARIABLE h-cdapi704           AS HANDLE          NO-UNDO.
DEFINE VARIABLE c-endereco           AS CHARACTER       NO-UNDO.
DEFINE VARIABLE c-rua                AS CHARACTER       NO-UNDO.
DEFINE VARIABLE c-nro                AS CHARACTER       NO-UNDO.
DEFINE VARIABLE c-comp               AS CHARACTER       NO-UNDO.
DEFINE VARIABLE c-cod-estabel        AS CHARACTER       NO-UNDO.
DEFINE VARIABLE l-conversor-entrada  AS LOGICAL INIT NO NO-UNDO.

/* Functions */
{include/i-freeac.i}

FUNCTION fn-trata-caracteres RETURNS CHAR (INPUT p-string AS CHAR ).
    DEFINE VAR c-trata-caracteres AS CHAR CASE-SENSITIVE NO-UNDO.
    
    ASSIGN c-trata-caracteres = p-string
           c-trata-caracteres = replace(c-trata-caracteres, 'û', '1')
           c-trata-caracteres = replace(c-trata-caracteres, 'ý', '2')
           c-trata-caracteres = replace(c-trata-caracteres, 'ü', '3')
           c-trata-caracteres = replace(c-trata-caracteres, 'Ê', '')
           c-trata-caracteres = replace(c-trata-caracteres, "'~'", '')
           c-trata-caracteres = replace(c-trata-caracteres, '^', '')  
           c-trata-caracteres = replace(c-trata-caracteres, '’', '')
           c-trata-caracteres = replace(c-trata-caracteres, 'ù', '')  
           c-trata-caracteres = replace(c-trata-caracteres, 'á', 'b')
           c-trata-caracteres = replace(c-trata-caracteres, '¸', 'c')   
           c-trata-caracteres = replace(c-trata-caracteres, '½', 'c')
           c-trata-caracteres = replace(c-trata-caracteres, 'ô', 'c')
           c-trata-caracteres = replace(c-trata-caracteres, 'œ', 'e')
           c-trata-caracteres = replace(c-trata-caracteres, '³', 'f')
           c-trata-caracteres = replace(c-trata-caracteres, 'ø', 'o')
           c-trata-caracteres = replace(c-trata-caracteres, 'æ', 'm')
           c-trata-caracteres = replace(c-trata-caracteres, '©', 'r')
           c-trata-caracteres = replace(c-trata-caracteres, 'õ', 's').
        
        
    RETURN c-trata-caracteres.
END FUNCTION.
