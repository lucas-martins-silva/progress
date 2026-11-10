DEFINE TEMP-TABLE tt-exportador      NO-UNDO   LIKE emitente
    FIELD cod-itiner-exp                       LIKE emitente-cex.cod-itiner-exp
    FIELD cod-idioma                           LIKE emitente-cex.cod-idioma
    FIELD cod-aba                              LIKE emitente-cex.cod-aba
    FIELD cod-repres                           LIKE emitente-cex.cod-repres
    FIELD cod-incoterm-exp                     LIKE emitente-cex.cod-incoterm-exp
    FIELD cod-itiner-imp                       LIKE emitente-cex.cod-itiner-imp
    FIELD cod-incoterm-imp                     LIKE emitente-cex.cod-incoterm-imp
    FIELD log-desp-inclusas                    LIKE emitente-cex.log-desp-inclusas
    FIELD nr-tab                               LIKE emitente-cex.nr-tab
    FIELD cod-pto-contr                        LIKE emitente-cex.cod-pto-contr
    FIELD des-layout-origin-comerc-invoi       LIKE emitente-cex.des-layout-origin-comerc-invoi
    FIELD des-layout-origin-packing-list       LIKE emitente-cex.des-layout-origin-packing-list
    FIELD des-layout-origin-proform-invoi      LIKE emitente-cex.des-layout-origin-proform-invoi
    FIELD cdn-despa-import                     LIKE emitente-cex.cdn-despa-import
    FIELD cdn-despa-exter-import               LIKE emitente-cex.cdn-despa-exter-import
    FIELD cdn-segurad-import                   LIKE emitente-cex.cdn-segurad-import
    FIELD cdn-corretor-cambio-import           LIKE emitente-cex.cdn-corretor-cambio-import
    FIELD cdn-corretor-import                  LIKE emitente-cex.cdn-corretor-import
    FIELD marca-1                              LIKE emitente-cex.marca-1
    FIELD marca-2                              LIKE emitente-cex.marca-2
    FIELD marca-3                              LIKE emitente-cex.marca-3
    FIELD marca-4                              LIKE emitente-cex.marca-4
    FIELD marca-5                              LIKE emitente-cex.marca-5
    FIELD des-layout-origin-ped-cambio         LIKE emitente-cex.des-layout-origin-ped-cambio
    FIELD des-layout-origin-instruc-embarq     LIKE emitente-cex.des-layout-origin-instruc-embarq.

DEFINE TEMP-TABLE tt-consignatario   NO-UNDO   LIKE emitente
    FIELD cod-itiner-exp                       LIKE emitente-cex.cod-itiner-exp
    FIELD cod-idioma                           LIKE emitente-cex.cod-idioma
    FIELD cod-aba                              LIKE emitente-cex.cod-aba
    FIELD cod-repres                           LIKE emitente-cex.cod-repres
    FIELD cod-incoterm-exp                     LIKE emitente-cex.cod-incoterm-exp
    FIELD cod-itiner-imp                       LIKE emitente-cex.cod-itiner-imp
    FIELD cod-incoterm-imp                     LIKE emitente-cex.cod-incoterm-imp
    FIELD log-desp-inclusas                    LIKE emitente-cex.log-desp-inclusas
    FIELD nr-tab                               LIKE emitente-cex.nr-tab
    FIELD cod-pto-contr                        LIKE emitente-cex.cod-pto-contr
    FIELD des-layout-origin-comerc-invoi       LIKE emitente-cex.des-layout-origin-comerc-invoi
    FIELD des-layout-origin-packing-list       LIKE emitente-cex.des-layout-origin-packing-list
    FIELD des-layout-origin-proform-invoi      LIKE emitente-cex.des-layout-origin-proform-invoi
    FIELD cdn-despa-import                     LIKE emitente-cex.cdn-despa-import
    FIELD cdn-despa-exter-import               LIKE emitente-cex.cdn-despa-exter-import
    FIELD cdn-segurad-import                   LIKE emitente-cex.cdn-segurad-import
    FIELD cdn-corretor-cambio-import           LIKE emitente-cex.cdn-corretor-cambio-import
    FIELD cdn-corretor-import                  LIKE emitente-cex.cdn-corretor-import
    FIELD marca-1                              LIKE emitente-cex.marca-1
    FIELD marca-2                              LIKE emitente-cex.marca-2
    FIELD marca-3                              LIKE emitente-cex.marca-3
    FIELD marca-4                              LIKE emitente-cex.marca-4
    FIELD marca-5                              LIKE emitente-cex.marca-5
    FIELD des-layout-origin-ped-cambio         LIKE emitente-cex.des-layout-origin-ped-cambio
    FIELD des-layout-origin-instruc-embarq     LIKE emitente-cex.des-layout-origin-instruc-embarq.

DEFINE TEMP-TABLE tt-agente-carga    NO-UNDO   LIKE emitente
    FIELD cod-itiner-exp                       LIKE emitente-cex.cod-itiner-exp
    FIELD cod-idioma                           LIKE emitente-cex.cod-idioma
    FIELD cod-aba                              LIKE emitente-cex.cod-aba
    FIELD cod-repres                           LIKE emitente-cex.cod-repres
    FIELD cod-incoterm-exp                     LIKE emitente-cex.cod-incoterm-exp
    FIELD cod-itiner-imp                       LIKE emitente-cex.cod-itiner-imp
    FIELD cod-incoterm-imp                     LIKE emitente-cex.cod-incoterm-imp
    FIELD log-desp-inclusas                    LIKE emitente-cex.log-desp-inclusas
    FIELD nr-tab                               LIKE emitente-cex.nr-tab
    FIELD cod-pto-contr                        LIKE emitente-cex.cod-pto-contr
    FIELD des-layout-origin-comerc-invoi       LIKE emitente-cex.des-layout-origin-comerc-invoi
    FIELD des-layout-origin-packing-list       LIKE emitente-cex.des-layout-origin-packing-list
    FIELD des-layout-origin-proform-invoi      LIKE emitente-cex.des-layout-origin-proform-invoi
    FIELD cdn-despa-import                     LIKE emitente-cex.cdn-despa-import
    FIELD cdn-despa-exter-import               LIKE emitente-cex.cdn-despa-exter-import
    FIELD cdn-segurad-import                   LIKE emitente-cex.cdn-segurad-import
    FIELD cdn-corretor-cambio-import           LIKE emitente-cex.cdn-corretor-cambio-import
    FIELD cdn-corretor-import                  LIKE emitente-cex.cdn-corretor-import
    FIELD marca-1                              LIKE emitente-cex.marca-1
    FIELD marca-2                              LIKE emitente-cex.marca-2
    FIELD marca-3                              LIKE emitente-cex.marca-3
    FIELD marca-4                              LIKE emitente-cex.marca-4
    FIELD marca-5                              LIKE emitente-cex.marca-5
    FIELD des-layout-origin-ped-cambio         LIKE emitente-cex.des-layout-origin-ped-cambio
    FIELD des-layout-origin-instruc-embarq     LIKE emitente-cex.des-layout-origin-instruc-embarq.


DEFINE TEMP-TABLE tt-docto           NO-UNDO
    FIELD cod-docto                  LIKE docto-import.cod-docto
    FIELD des-docto                  LIKE docto-import.des-docto
    FIELD qti-docto-origin           LIKE docto-import.qti-docto-origin
    FIELD qti-docto-cop-bco          LIKE docto-import.qti-docto-cop-bco
    FIELD qti-docto-cop-imptdor      LIKE docto-import.qti-docto-cop-imptdor
    FIELD cod-itens-docto            AS CHARACTER FORMAT "X(2000)"
    FIELD tr-cod-itens-docto         AS CHARACTER FORMAT "X(2000)".


DEFINE TEMP-TABLE tt-it-inst-emb     NO-UNDO
    FIELD it-codigo                  LIKE ordem-compra.it-codigo
    FIELD embarque                   LIKE ordens-embarque.embarque
    FIELD nr-proc-imp                LIKE ordens-embarque.nr-proc-imp
    FIELD cod-estabel                LIKE ordens-embarque.cod-estabel
    FIELD numero-ordem               LIKE ordens-embarque.numero-ordem
    FIELD parcela                    LIKE ordens-embarque.parcela
    FIELD quantidade                 LIKE ordens-embarque.quantidade
    FIELD qt-do-forn                 LIKE ordens-embarque.qt-do-forn
    FIELD peso-liquido-uni           LIKE ordens-embarque.peso-liquido
    FIELD peso-liquido-tot           LIKE ordens-embarque.peso-liquido
    FIELD peso-bruto-uni             LIKE ordens-embarque.peso-bruto
    FIELD peso-bruto-tot             LIKE ordens-embarque.peso-bruto
    FIELD vl-cub-uni                 LIKE ordens-embarque.val-cub-uni
    FIELD vl-cub-tot                 LIKE ordens-embarque.val-cub-uni
    FIELD data-emissao               LIKE ordem-compra.data-emissao
    FIELD narrativa                  LIKE ordem-compra.narrativa
    FIELD data-cotacao               LIKE ordem-compra.data-cotacao
    FIELD preco-orig                 LIKE ordem-compra.preco-orig
    FIELD preco-unit                 LIKE ordem-compra.preco-unit
    FIELD pre-unit-for               LIKE ordem-compra.pre-unit-for
    FIELD preco-fornec               LIKE ordem-compra.preco-fornec
    FIELD mo-codigo                  LIKE ordem-compra.mo-codigo
    FIELD aliquota-ipi               LIKE ordem-compra.aliquota-ipi
    FIELD aliquota-icm               LIKE ordem-compra.aliquota-icm
    FIELD aliquota-iss               LIKE ordem-compra.aliquota-iss
    FIELD taxa-financ                LIKE ordem-compra.taxa-financ
    FIELD valor-taxa                 LIKE ordem-compra.valor-taxa
    FIELD perc-descto                LIKE ordem-compra.perc-descto
    FIELD prazo-entreg               LIKE ordem-compra.prazo-entreg
    FIELD contato                    LIKE ordem-compra.contato
    FIELD comentarios                LIKE ordem-compra.comentarios
    FIELD data-atualiz               LIKE ordem-compra.data-atualiz
    FIELD hora-atualiz               LIKE ordem-compra.hora-atualiz
    FIELD cod-refer                  LIKE ordem-compra.cod-refer
    FIELD valor-descto               LIKE ordem-compra.valor-descto
    FIELD nr-dias-taxa               LIKE ordem-compra.nr-dias-taxa
    FIELD licenca-import             LIKE ordem-compra.licenca-import
    FIELD loc-entrega                LIKE ordem-compra.loc-entrega
    FIELD cod-emitente               LIKE ordem-compra.cod-emitente
    FIELD vl-liq-uni                 LIKE cotacao-item.pre-unit-for    
    FIELD vl-bruto-uni               LIKE cotacao-item.pre-unit-for
    FIELD vl-liq-tot                 LIKE cotacao-item.pre-unit-for
    FIELD vl-bruto-tot               LIKE cotacao-item.pre-unit-for
    FIELD cod-pto-contro-base        AS   INTEGER   FORMAT ">>>>9"
    FIELD aliquota-ii                LIKE item.aliquota-ipi
    FIELD regime-import              AS   INTEGER   FORMAT ">9"
    FIELD cdn-pais-orig              LIKE cotacao-item.cdn-pais-orig
    FIELD cod-fabric                 LIKE emitente.cod-emitente
    FIELD desc-pto-contro-base       LIKE pto-contr.descricao
    FIELD desc-moeda                 LIKE moeda.descricao
    FIELD sigla-moeda                LIKE moeda.sigla
    FIELD desc-item                  LIKE item.desc-item
    FIELD tr-it-codigo               LIKE item.it-codigo
    FIELD tr-it-narrativa            LIKE traduc-item.tr-narrativa
    FIELD altura                     LIKE item.altura
    FIELD comprim                    LIKE item.comprim   
    FIELD largura                    LIKE item.largura   
    FIELD ge-codigo                  LIKE item.ge-codigo 
    FIELD fm-codigo                  LIKE item.fm-codigo 
    FIELD fm-cod-com                 LIKE item.fm-cod-com
    FIELD unid-for                   LIKE item-fornec.unid-med-for        
    FIELD tr-unid-for                LIKE item-fornec.unid-med-for        
    FIELD un                         LIKE item.un        
    FIELD tr-un                      LIKE item.un        
    FIELD desc-grup-estoq            LIKE grup-estoq.descricao
    FIELD desc-familia               LIKE familia.descricao       
    FIELD desc-fam-comerc            LIKE fam-comerc.descricao    
    FIELD item-fornec                LIKE item-fornec.item-do-forn
    FIELD cod-embal                  LIKE item-fornec.cod-embal   
    FIELD fator-conver               LIKE item-fornec.fator-conver
    FIELD num-casa-dec               LIKE item-fornec.num-casa-dec 
    FIELD dt-embarque	             LIKE prazo-compra.data-entrega
    FIELD peso-liquido	             LIKE item.peso-liquido.

DEFINE TEMP-TABLE tt-inst-emb NO-UNDO
    FIELD embarque                   LIKE  embarque-imp.embarque                    
    FIELD nr-proc-imp                LIKE  processo-imp.nr-proc-imp                
    FIELD num-pedido                 LIKE  processo-imp.num-pedido              
    FIELD peso-liquido-tot           LIKE  ordens-embarque.peso-liquido
    FIELD peso-bruto-tot             LIKE  ordens-embarque.peso-bruto            
    FIELD valor-total-merc           LIKE  cotacao-item.pre-unit-for                
    FIELD dt-atual                   AS DATE                              
    FIELD pto-despacho               LIKE  pto-contr.cod-pto-contr                  
    FIELD pto-embarque               LIKE  pto-contr.cod-pto-contr                  
    FIELD pto-nacionaliz             LIKE  pto-contr.cod-pto-contr
    FIELD pto-eadi                   LIKE  pto-contr.cod-pto-contr
    FIELD pto-chegada                LIKE  pto-contr.cod-pto-contr
    FIELD desc-pto-despacho          LIKE  pto-contr.descricao
    FIELD desc-pto-embarque          LIKE  pto-contr.descricao
    FIELD desc-pto-nacionaliz        LIKE  pto-contr.descricao
    FIELD desc-pto-eadi              LIKE  pto-contr.descricao
    FIELD desc-pto-chegada           LIKE  pto-contr.descricao
    FIELD data-prev-despacho         LIKE  historico-embarque.dt-previsao
    FIELD data-prev-embarque         LIKE  historico-embarque.dt-previsao
    FIELD data-prev-nacionaliz       LIKE  historico-embarque.dt-previsao
    FIELD data-prev-eadi             LIKE  historico-embarque.dt-previsao
    FIELD data-prev-chegada          LIKE  historico-embarque.dt-previsao
    FIELD data-efet-despacho         LIKE  historico-embarque.dt-efetiva
    FIELD data-efet-embarque         LIKE  historico-embarque.dt-efetiva
    FIELD data-efet-nacionaliz       LIKE  historico-embarque.dt-efetiva
    FIELD data-efet-eadi             LIKE  historico-embarque.dt-efetiva
    FIELD data-efet-chegada          LIKE  historico-embarque.dt-efetiva
    FIELD data-ult-prev-despacho     LIKE  historico-embarque.dt-ult-previsao 
    FIELD data-ult-prev-embarque     LIKE  historico-embarque.dt-ult-previsao 
    FIELD data-ult-prev-nacionaliz   LIKE  historico-embarque.dt-ult-previsao 
    FIELD data-ult-prev-eadi         LIKE  historico-embarque.dt-ult-previsao 
    FIELD data-ult-prev-chegada      LIKE  historico-embarque.dt-ult-previsao 
    FIELD dt-nacionaliz              LIKE  historico-embarque.dt-efetiva
    FIELD dt-embarque                LIKE  historico-embarque.dt-efetiva
    FIELD desc-banco                 LIKE  banco.nome-banco
    FIELD ag-banco                   LIKE  banco.ag-padrao
    FIELD desc-agencia               LIKE  agencia.nome
    FIELD loc-destino                like  pto-contr.descricao.
    









































