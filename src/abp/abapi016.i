/*************************************************************************************************
**   ABAPI016.I - Defini‡äes Manutencao Tabela Abastecimento/Lubrificacao
*************************************************************************************************/

DEFINE TEMP-TABLE tt-mab-item-abastec-lubrific NO-UNDO
    FIELD dt-movimento    as date      format "99/99/9999":U
    FIELD hr-inicial      as character format "99:99":U
    FIELD hr-final        as character format "99:99":U
    FIELD ep-codigo       AS CHARACTER format "x(03)":U
    FIELD cod-eqpto       as character format "x(16)":U
    FIELD contador        as decimal   format ">>>,>>>,>>9.99":U
    FIELD contador-sec    as decimal   format ">>>,>>>,>>9.99":U
    FIELD posto           as character format "x(8)":U
    FIELD empresa-matr    AS CHARACTER format "x(03)"
    FIELD estabel-matr    AS CHARACTER format "x(05)"
    FIELD cod-matr        as character format "x(10)":U
    FIELD cod-evento      as character format "x(8)":U
    FIELD cod-compart     as character format "x(8)":U 
    FIELD cod-rota        as character format "x(12)":U
    FIELD cod-ativid      as character format "x(8)":U
    FIELD cod-cta-ctbl    AS CHAR FORMAT "x(20)":U
    FIELD cod-ccusto      AS CHAR FORMAT "x(20)":U
    FIELD i-tipo          as integer.
