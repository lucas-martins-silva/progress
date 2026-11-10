/*
**
** BOCX225E.I3 - Busca-grava atributos livres da tabela {2}*
*/

/*
** {1} - yes - grava    no - busca
*/

IF  {1} THEN DO:
    ASSIGN {2}.peso-bruto     = de-peso-bruto-i1
           {2}.peso-liquido   = de-peso-liquido-i1
           {2}.val-cub-unit   = de-cub-unit-i1
           {2}.val-cub-tot    = de-cub-tot-i1
           {2}.val-peso-embal = de-peso-embal-i1.
                  
    /******************************************************
    * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
    ******************************************************/
    IF  c-suspensao-II  = "1":U THEN
        ASSIGN {2}.log-suspens-impto-import = YES.
    ELSE
        ASSIGN {2}.log-suspens-impto-import = NO.

    IF  c-suspensao-IPI = "1":U THEN
        ASSIGN {2}.log-suspens-ipi-import   = YES.
    ELSE
        ASSIGN {2}.log-suspens-ipi-import   = NO.

END.
ELSE DO:
    ASSIGN de-peso-bruto-i1    = {2}.peso-bruto
           de-peso-liquido-i1  = {2}.peso-liquido
           de-cub-unit-i1      = {2}.val-cub-unit
           de-cub-tot-i1       = {2}.val-cub-tot
           de-peso-embal-i1    = {2}.val-peso-embal.
    
    /******************************************************
    * Engenharia IPI Suspensao Incorporar Base PIS COFINS *
    ******************************************************/
    IF  {2}.log-suspens-impto-import THEN
        ASSIGN c-suspensao-II = "1":U.
    ELSE
        ASSIGN c-suspensao-II = "":U.

    IF  {2}.log-suspens-ipi-import   THEN
        ASSIGN c-suspensao-IPI = "1":U.
    ELSE
        ASSIGN c-suspensao-IPI = "":U.

END.
