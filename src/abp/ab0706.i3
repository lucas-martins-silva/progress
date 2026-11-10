/*tt-dados*/

define temp-table tt-dados no-undo
            FIELD i-chave        AS INT
            field linha          as int
            field erro           as int
            field descricao      as char format "x(110)":U
            field tabela         as char format "x(50)":U
            field modulo         as char format "x(50)":U
    index id is primary unique i-chave ASCENDING
    INDEX i-ordena MODULO tabela linha i-chave ASCENDING.
