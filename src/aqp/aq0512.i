/******************************************************************************
** Include:   AQ0512.i -  Defini‡Æo da tt-param                              **
** Programas: AQ0512.w                                                       **
**            AQ0512rp.p                                                     **
**            AQ0512a.p                                                      **
******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD execucao             AS INTEGER
    FIELD arquivo              AS CHARACTER format "x(35)":U
    FIELD usuario              AS CHARACTER format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-estabel-ini    AS CHARACTER
    FIELD cod-estabel-fim    AS CHARACTER
    FIELD cod-regiao-ini       AS CHARACTER
    FIELD cod-regiao-fim       AS CHARACTER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER
    FIELD imp-param            AS LOGICAL
    FIELD list-qtd-zerada      AS LOGICAL
    FIELD desc-item            AS CHARACTER
    FIELD i-classif            AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id AS INTEGER. 

DEFINE TEMP-TABLE tt-dados-ensaio-pagto NO-UNDO
    FIELD cod-period          AS CHARACTER FORMAT "99/9999":U  /* C¢digo do per¡odo                                                                                                      */
    FIELD cdn-produt-rural    AS INTEGER   /* C¢digo do produtor                                                                                                       */
    FIELD cod-estab           AS CHARACTER /* C¢digo do estabelecimento                                                                                                */
    FIELD nome-emit           AS CHARACTER /* Nome do produtor                                                                                                         */
    FIELD cod-pto-coleta      AS CHARACTER /* C¢digo do ponto de coleta                                                                                                */
    FIELD des-pto-coleta      AS CHARACTER /* Descri‡Æo do ponto de coleta                                                                                             */
    FIELD cod-propried        AS CHARACTER /* C¢digo da propriedade                                                                                                    */
    FIELD des-propried        AS CHARACTER /* Propriedade	Descri‡Æo da propriedade                                                                                   */
    FIELD cdn-grp-produt      AS INTEGER   /* C¢digo do Grupo de produtores                                                                                            */
    FIELD des-grp-produt      AS CHARACTER /* Descri‡Æo do grupo                                                                                                       */
    FIELD cod-rota            AS CHARACTER /* C¢digo da rota                                                                                                           */
    FIELD des-rota            AS CHARACTER /* Descri‡Æo Rota                                                                                                           */
    FIELD cod-regiao          AS CHARACTER /* C¢digo da regiÆo                                                                                                         */
    FIELD des-regiao          AS CHARACTER /* Descri‡Æo regiÆo                                                                                                         */
    FIELD cidade              AS CHARACTER /* Cidade do endere‡o da propriedade                                                                                        */
    FIELD qtd-period          AS DECIMAL   /* Quantidade coletada no per¡odo                                                                                           */
    FIELD val-preco-final-inf AS DECIMAL   /* Preço final                                                                                                              */
    FIELD val-preco-base      AS DECIMAL   /* Pre‡o base conforme regras de preço                                                                                      */
    FIELD val-var-qualid      AS DECIMAL   /* Soma das variações no preço por indicadores de qualidade                                                                 */
    FIELD val-var-volum       AS DECIMAL   /* Variação no preço por volume conforme regras de preço                                                                    */
    FIELD val-bonus-fix       AS DECIMAL   /* B“nus fixo conforme regras de preço                                                                                      */
    FIELD val-pre-unit        AS DECIMAL   /* Preço Unit	Soma de preço base + var. qualidade + var. volume + bônus fixo                                             */
    FIELD val-bonus-fix-inf   AS DECIMAL   /* B“nus Fixo Inf	Diferença entre o preço final e o preço unitário                                                       */
    FIELD val-pre-liq         AS DECIMAL   /* Preço Líquido	(Quantidade * Preço Final + Incentivo + Imp. Retido) / Quantidade                                          */
    FIELD val-pre-liq-ant     AS DECIMAL   /* Preço Líquido mês anterior	Idem Preço Líquido com dados do mês anterior                                               */    
    FIELD val-ajuste          AS DECIMAL   /* Ajuste	Valor aplicado sobre o unitário para desembutir incentivo e imposto retido. Será retornado do Engine de Regras */
    FIELD val-incentivo       AS DECIMAL   /* Incentivo	Valor projetado para o incentivo à produção leiteira. Será retornado do Engine de Regras                       */
    FIELD val-pre-bruto       AS DECIMAL   /* Preço Bruto	((Quantidade * preço unit) + incentivo) / quantidade                                                       */
    FIELD val-tot-prov        AS DECIMAL   /* Total Proventos	Quantidade * Preço Bruto                                                                               */
    FIELD val-outr-cred       AS DECIMAL   /* Outros créditos	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                             */
    FIELD val-adiantamentos   AS DECIMAL   /* Adiantamentos	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                 */
    FIELD val-emprestimos     AS DECIMAL   /* Empréstimos	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                 */
    FIELD val-convenios       AS DECIMAL   /* Convênios	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                     */
    FIELD val-outr-debitos    AS DECIMAL   /* Outros débitos	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                             */
    FIELD val-desconto-tot    AS DECIMAL   /* Desconto Total	Outros créditos + Adiantamentos + Empréstimos + Convênios + Outros Débitos                             */
    FIELD val-imp-retido      AS DECIMAL   /* Imp. Retido	Valor projetado para o imposto retido. Será retornado do Engine de Regras                                  */
    FIELD val-liq-receb-tot   AS DECIMAL   /* Líquido a receber Total	Total Proventos + Desconto Total + Imp. Retido                                                 */
    FIELD banco               AS CHARACTER /* Banco	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                         */
    FIELD agencia             AS CHARACTER /* Agência	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                     */
    FIELD conta               AS CHARACTER /* Conta	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                         */
    FIELD cod-correntista     AS INTEGER   /* codigo do correntista retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                         */
    FIELD titular             AS CHARACTER /* Titular	Retornado pela pi_retornar_dados_produtor_ensaio_pagamento                                                     */
    FIELD id-unico-emit       AS CHARACTER /* CPF/CNPJ                                                                                                                 */
    FIELD nro-docto           AS CHARACTER /* Nota                                                                                                                     */
    FIELD serie-docto         AS CHARACTER /* Serie da nota                                                                                                            */
    .

DEFINE TEMP-TABLE tt-dados-ensaio-pagtoV2 NO-UNDO LIKE tt-dados-ensaio-pagto
    FIELD cnpj                AS CHARACTER /*CPF ou CNPJ do produtor                                                                                                   */
    FIELD ins-estadual        AS CHARACTER /*Inscri‡Æo estadual                                                                                                        */
    FIELD uf                  AS CHARACTER /* Estado da propriedade                                                                                                    */
    FIELD val-impto LIKE fechto-produt-period.val-impto.

DEF TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper   AS CHAR FORMAT "x(16)"
    FIELD valor-variavel AS CHAR FORMAT "x(60)".

DEF TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno AS CHAR FORMAT "x(60)"
    FIELD campo-retorno AS CHAR FORMAT "x(60)"
    FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99".
