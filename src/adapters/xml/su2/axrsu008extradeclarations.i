    
    {utp/ut-glob.i}

    {cdp/cd0666.i}
    define temp-table tt-proj-inv
        field ind-transacao      as integer format "9" /*InclusÆo, Altera‡Æo, Elimina‡Æo*/
    /*Indica se utiliza o projeto modelo*/
        field cons-proj-modelo   as logical 
        field num-proj-modelo    as integer format ">>>>9"
        field sigla-proj-modelo  as char    format "x(15)"
    /*Projeto Investimento*/
        field ep-codigo          like empresa.ep-codigo

        field cod-est-exec       as char    format "x(3)"
        field num-projeto        as integer format ">>>>9"
        field sigla              as char    format "x(15)"
        field cod-est-gestor     as char    format "x(3)"
    /*DivisÆo*/
        field cod-divisao        as integer format ">9"
        field desc-divisao       as char    format "x(40)"
    /*Centro de custo*/
        field cod-ccusto         as char    format "x(8)"
        field desc-ccusto        as char    format "x(40)"
    /*Tipo do projeto*/
        field tp-projeto         as integer format "9"
        field desc-tp-projeto    as char    format "x(40)"

        field num-projeto-ant    as char    format "x(6)"
        field cod-situacao-proj  as integer format ">9"
        field dt-cadastro        as date    format "99/99/9999"
        field dt-atualizacao     as date    format "99/99/9999"
        field dt-prev-ini        as date    format "99/99/9999"
        field dt-prev-fim        as date    format "99/99/9999"
        field dt-trc-real        as date    format "99/99/9999"
        field trc-previsto       as integer format ">>9"
        field trc-real           as integer format ">>9"
        field usuario-atu        as char    format "x(12)"
        FIELD usuario-resp       AS CHAR    FORMAT "X(12)"
        field descricao         as char    format "x(40)"
      /*SubdivisÆo de ordem*/
        field cod-id-solum       as char    format "x(100)".

    define temp-table tt-sub-div-ordem
        field cod-id-solum as char    format "x(100)" 
        field cod-sigla    as char    format "x(15)"
        field num-ordem    as integer format ">>9"
        field descricao    as char    format "x(40)".

    define temp-table tt-retorno-efetiv
        field ep-codigo     like empresa.ep-codigo
        field cod-est-exec  as char    format "x(3)"   
        field num-projeto   as integer format ">>>>9"
        field l-efetivado   as logical init no.

    define variable c-estabel as char format "x(3)".


    {method/dbotterr.i}
    DEFINE TEMP-TABLE tt-variavel
       FIELD cod-var-oper   AS CHAR FORMAT "x(16)"
       FIELD valor-variavel AS CHAR FORMAT "x(60)".

    DEFINE TEMP-TABLE tt-retorno
       FIELD valor-retorno AS CHAR FORMAT "x(60)" 
       FIELD campo-retorno AS CHAR FORMAT "x(60)" 
       FIELD perc-rateio   AS DEC FORMAT ">>9,99".


    
    DEFINE VARIABLE c-regra-utilizada AS INT FORMAT ">>>,>>>,>>9".


