def temp-table tt-ant-ir-aux no-undo
    field c-cod-estab      as char format "x(03)"      /* Cod do Estabelimento do IR          */     
    field c-cod-estab-acum as char format "x(03)"      /* Cod do Estab para o acumulado do IR */
    field i-cod-fornec     as int  format ">>>>>>>>9"  /* Cod do Fornecedor                   */
    field i-cod-imposto    as integer                  /* Cod do imposto ou taxa              */
    field c-cod-esp        as character                /* Cod da Especie do Ir                */
    field c-serie          as character                /* Serie da Especie                    */
    field c-nr-docto       as character                /* Numero do Documento do IR           */
    field c-parcela        as character                /* Parcela do IR                       */
    field i-cod-retencao   as integer                  /* Cod de Retencao                     */
    field da-vencimento    as date                     /* Data de Vencimento do IR            */
    field i-tp-codigo      as integer                  /* Tipo de Despesa                     */
    field c-conta-debito   as character                /* Conta para debito                   */
    field de-original      as decimal                  /* Valor do Ir Gerado                  */
    field de-tributavel    as decimal                  /* Rendimento Tributavel(Valor da AN)  */
    field de-inss          as decimal                  /* Deducao INSS                        */
    field de-depend        as decimal                  /* Deducao de Dependente               */
    field de-pensao        as decimal                  /* Deducao de Pensao                   */
    field de-outras        as decimal                  /* Outras Deducoes                     */
    field de-aliquota      as decimal                  /* Aliquota do Imposto                 */
    field de-ded-faixa     as decimal                  /* Dedudcao Conforme a faixa de tributacao */
    field de-vl-impto      as decimal                  /* Valor do Imposto Calculado conforme a Faixa */
    field l-cancela        as logical init no          /* Cancela a atualizacao               */
    field i-hp-codigo-ir   as integer                  /* Codigo do Historico                 */
    field c-historico-ir   as character                /* Complemento  do Historico           */
    field de-vl-antecip    as decimal                  /* VAlor original da antecipacao       */
    field da-emis-antec    as date                     /* Data de emissao da Antecipacao      */
    field i-moeda          as integer                  /* Codigo da Moeda                     */
    field i-ep-codigo      as int  format ">>9" init 0 /* Empresa                             */
    field c-cod-estab-an   as char format "x(03)"      /* Cod do Estabelecimento da AN        */
    field c-cod-esp-an     as character                /* Cod da Especie da AN                */
    field c-serie-an       as character                /* Serie da Especie da AN              */
    field c-nr-docto-an    as character                /* Numero do Documento da AN           */
    field c-parcela-an     as character                /* Parcela da AN                       */
    field i-cod-fornec-an  as int  format ">>>>>>>>9". /* Cod do forncecedor da AN            */
