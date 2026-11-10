/*tt-dados*/

define temp-table tt-dados no-undo
            FIELD i-chave        AS INT
            field linha          as int
            field erro           as int
            field descricao      as char format "x(70)":U
            field tabela         as char format "x(30)":U
            field modulo         as char format "x(50)":U
            field cod-tabela     as char format "x(5)":U
            field des-tabela     as char format "x(40)":U
            field des-tab        as char format "x(30)":U
    index id is primary unique tabela i-chave.
