/***************************************************************************
**                                                                        **
**    AQAPI001.I - Apura‡Æo de valores por período                        **
**                                                                        **
**    DEFINIÇÂO DAS TEMP-TABLES                                           **
**                                                                        **  
****************************************************************************/
 
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                    AS INTEGER
    FIELD arquivo                    AS CHARACTER
    FIELD usuario                    AS CHARACTER 
    FIELD data-exec                  AS DATE
    FIELD hora-exec                  AS INTEGER
    FIELD l-habilitaRtf              AS LOGICAL
    FIELD cod-period                 LIKE fechto-produt-period.cod-period
    FIELD da-dat-ini                 LIKE regra-form-preco.dat-inic 
    FIELD da-dat-fim                 LIKE regra-form-preco.dat-fim 
    FIELD it-codigo                  LIKE regra-form-preco.it-codigo
    FIELD cod-estabel-ini            LIKE regra-form-preco.cod-estabel
    FIELD cod-estabel-fim            LIKE regra-form-preco.cod-estabel
    FIELD cod-regiao-ini             LIKE regra-form-preco.cod-regiao 
    FIELD cod-regiao-fim             LIKE regra-form-preco.cod-regiao
    FIELD cod-rota-ini               LIKE regra-form-preco.cod-rota
    FIELD cod-rota-fim               LIKE regra-form-preco.cod-rota
    FIELD cdn-grp-produt-ini         LIKE regra-form-preco.cdn-grp-produt  
    FIELD cdn-grp-produt-fim         LIKE regra-form-preco.cdn-grp-produt  
    FIELD cdn-produt-rural-ini       LIKE regra-form-preco.cdn-produt-rural
    FIELD cdn-produt-rural-fim       LIKE regra-form-preco.cdn-produt-rural
    FIELD cod-propried-ini           LIKE regra-form-preco.cod-propried
    FIELD cod-propried-fim           LIKE regra-form-preco.cod-propried
    FIELD cod-pto-coleta-ini         LIKE regra-form-preco.cod-pto-coleta
    FIELD cod-pto-coleta-fim         LIKE regra-form-preco.cod-pto-coleta
    FIELD cdn-tipo                   LIKE regra-form-preco.cdn-tipo
    FIELD cod-regra-ini              LIKE regra-form-preco.cod-regra
    FIELD cod-regra-fim              LIKE regra-form-preco.cod-regra
    FIELD cod-exame-ini              LIKE regra-form-preco.cod-exame
    FIELD cod-exame-fim              LIKE regra-form-preco.cod-exame
    FIELD cod-comp-ini               LIKE regra-form-preco.cod-comp
    FIELD cod-comp-fim               LIKE regra-form-preco.cod-comp
    FIELD sobrepoe-bon-fix-inf       AS LOGICAL
    FIELD recalcula-sit-conf         AS LOGICAL
    FIELD c-destino                  AS CHARACTER.    

DEFINE TEMP-TABLE tt-regra-form-preco NO-UNDO
    FIELD cod-regra        LIKE regra-form-preco.cod-regra       
    FIELD cdn-seq          LIKE regra-form-preco.cdn-seq         
    FIELD descricao        LIKE regra-form-preco.descricao       
    FIELD cdn-tipo         LIKE regra-form-preco.cdn-tipo        
    FIELD cdn-criter       LIKE regra-form-preco.cdn-criter      
    FIELD it-codigo        LIKE regra-form-preco.it-codigo       
    FIELD cdn-abrangen     LIKE regra-form-preco.cdn-abrangen    
    FIELD cod-estabel      LIKE regra-form-preco.cod-estabel     
    FIELD cod-regiao       LIKE regra-form-preco.cod-regiao      
    FIELD cdn-grp-produt   LIKE regra-form-preco.cdn-grp-produt  
    FIELD cod-rota         LIKE regra-form-preco.cod-rota
    FIELD cod-propried     LIKE regra-form-preco.cod-propried
    FIELD cod-pto-coleta   LIKE regra-form-preco.cod-pto-coleta  
    FIELD cdn-produt-rural LIKE regra-form-preco.cdn-produt-rural
    FIELD dat-inic         LIKE regra-form-preco.dat-inic        
    FIELD dat-fim          LIKE regra-form-preco.dat-fim         
    FIELD val-unit         LIKE regra-form-preco.val-unit        
    FIELD val-faixa-inic   LIKE regra-form-preco.val-faixa-inic  
    FIELD val-faixa-fim    LIKE regra-form-preco.val-faixa-fim   
    FIELD cod-exame        LIKE regra-form-preco.cod-exame       
    FIELD cod-comp         LIKE regra-form-preco.cod-comp        
    FIELD cdn-aplic        LIKE regra-form-preco.cdn-aplic       
    FIELD des-narrat       LIKE regra-form-preco.des-narrat      
    FIELD cod-usuar-criac  LIKE regra-form-preco.cod-usuar-criac 
    FIELD dat-criac        LIKE regra-form-preco.dat-criac       
    FIELD cod-usuar-alter  LIKE regra-form-preco.cod-usuar-alter 
    FIELD dat-alter        LIKE regra-form-preco.dat-alter       
    FIELD da-dia           AS DATE
    FIELD r-Rowid          AS ROWID
    index dia da-dia DESCENDING
    index idx-abrang cdn-abrangen dat-inic.

DEFINE TEMP-TABLE tt-regra-form-preco-qual   NO-UNDO like tt-regra-form-preco. /*filtra regras de qualidade            ***   cdn-tipo = 2*/

DEFINE TEMP-TABLE tt-regra-form-preco-vol    NO-UNDO like tt-regra-form-preco. /*filtra regras de variação de volume   ***   cdn-tipo = 3*/

DEFINE TEMP-TABLE tt-regra-form-preco-bonfix NO-UNDO like tt-regra-form-preco. /*filtra regras de bônus fixo           ***   cdn-tipo = 4*/

DEFINE TEMP-TABLE tt-carg-produt-periodo  NO-UNDO   /* soma e precifica as cargas por propriedade, usada também para salvar bonificações */
                                           /* grava val-produt-period  */
    FIELD it-codigo            LIKE produt-carg.it-codigo
    FIELD cod-estabel          LIKE produt-carg.cod-estabel
    FIELD cod-regiao           LIKE pto-coleta.cod-regiao
    FIELD cod-rota             LIKE carg-rural.cod-rota
    FIELD cdn-grp-produt       LIKE produt-rural.cdn-grp-produt
    FIELD cdn-produt-rural     LIKE produt-carg.cdn-produt-rural
    FIELD cod-pto-coleta       LIKE produt-carg.cod-pto-coleta
    FIELD val-unit             LIKE regra-form-preco.val-unit
    FIELD qtd-coleta           LIKE produt-carg.qtd-coleta
    FIELD propriedade-rural    LIKE propried-rural.cod-propried
    FIELD valor-carga          LIKE regra-form-preco.val-unit
    FIELD qtd-aferid           LIKE produt-carg.qtd-aferid   
    FIELD tot-qtd-aferid       LIKE produt-carg.qtd-aferid   
    FIELD tot-qtd-coleta       LIKE produt-carg.qtd-coleta   
    FIELD tot-valor            LIKE regra-form-preco.val-unit
    FIELD val-med-per          LIKE regra-form-preco.val-unit
    FIELD val-frete            LIKE carg-rural.val-frete
    FIELD cod-transp           LIKE carg-rural.cod-transp
    FIELD cod-placa            LIKE carg-rural.cod-placa.
    
{inbo/boin00999.i tt-fechto-produt-period} /*tabela fechto-produt-period*/

{inbo/boin01011.i tt-fechto-qualid} /*tabela fechto-qualid*/
 
DEFINE TEMP-TABLE tt-fechto-com NO-UNDO
    FIELD cod-period          AS CHARACTER FORMAT "99/9999"
    FIELD cdn-produt-rural    AS INTEGER   FORMAT ">>>,>>>,>>9"
    FIELD cod-propried        AS CHARACTER FORMAT "x(16)"
    FIELD it-codigo           AS CHARACTER FORMAT "x(16)"
    FIELD cod-estabel         AS CHARACTER FORMAT "x(5)"
    FIELD qtd-period          AS DECIMAL   FORMAT "->>>,>>>,>>9.99999"
    FIELD val-preco-base      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.9999"
    FIELD val-var-volum       AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-bonus-fix       AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-bonus-fix-inf   AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-var-qualid      AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-frete           AS DECIMAL   FORMAT ">>>,>>>,>>>,>>9.9999"
    FIELD val-preco-final-inf AS DECIMAL   FORMAT ">>>>>,>>>,>>9.9999"
    FIELD val-impto           AS DECIMAL   FORMAT ">>>,>>>,>>>,>>9.9999" /* Valor Imposto Sanidade Rural */
    INDEX idx-prop-produt cod-propried cdn-produt-rural.

DEFINE TEMP-TABLE tt-regra-form-preco-custom NO-UNDO LIKE tt-regra-form-preco
    FIELD val-reaj LIKE tt-regra-form-preco.val-unit
    FIELD val-ant  LIKE tt-regra-form-preco.val-unit
    FIELD checkSum AS CHARACTER FORMAT 'x(1)'.
   
DEFINE TEMP-TABLE tt-selected-rows NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD l-eliminou AS LOGICAL.
   
define temp-table tt-digita NO-UNDO
    field cod-rota LIKE rota-coleta.cod-rota
    field des-rota LIKE rota-coleta.des-rota.
    
DEFINE TEMP-TABLE tt-carg-produt-propried NO-UNDO
    FIELD cdn-produt-rural LIKE produt-carg.cdn-produt-rural
    FIELD cod-propriedade  LIKE propried-rural.cod-propried
    FIELD cdn-grp-produt   LIKE produt-rural.cdn-grp-produt
    FIELD pre-base-ok      AS LOGICAL.

DEFINE TEMP-TABLE tt-rd-fechto NO-UNDO
    FIELD r-rd-fechto AS ROWID
    INDEX rd r-rd-fechto.

DEFINE TEMP-TABLE tt-negoc-coletiv NO-UNDO
    FIELD cdn-grp-produt   LIKE grp-produt.cdn-grp-produt
    FIELD grp-qtd-coleta   LIKE fechto-produt-period.qtd-period.

DEFINE TEMP-TABLE tt-param-fin NO-UNDO
    FIELD cod-period                 LIKE fechto-produt-period.cod-period
    FIELD it-codigo-ini              LIKE regra-form-preco.it-codigo
    FIELD it-codigo-fin              LIKE regra-form-preco.it-codigo
    FIELD cod-estabel-ini            LIKE regra-form-preco.cod-estabel
    FIELD cod-estabel-fim            LIKE regra-form-preco.cod-estabel
    FIELD cdn-produt-rural-ini       LIKE regra-form-preco.cdn-produt-rural
    FIELD cdn-produt-rural-fim       LIKE regra-form-preco.cdn-produt-rural
    FIELD cod-propried-ini           LIKE regra-form-preco.cod-propried
    FIELD cod-propried-fim           LIKE regra-form-preco.cod-propried.

DEFINE TEMP-TABLE tt-media NO-UNDO
    FIELD cdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural
    FIELD cod-propried     LIKE fechto-produt-period.cod-propried
    FIELD it-codigo        LIKE fechto-produt-period.it-codigo
    FIELD cod-estabel      LIKE fechto-produt-period.cod-estabel
    FIELD cod-period       LIKE fechto-produt-period.cod-period
    FIELD cod-exame        LIKE res-fic-cq.cod-exame
    FIELD cod-comp         LIKE res-fic-cq.cod-comp
    FIELD resultado        LIKE res-fic-cq.resultado
    FIELD num-result       AS   INTEGER.
