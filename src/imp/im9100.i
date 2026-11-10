DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTE  FORMAT "x(35)":U
    FIELD usuario                AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD classifica             AS INTEGER
    FIELD desc-classifica        AS CHARACTER FORMAT "X(40)":U
    FIELD cCodEstabelIni         AS CHARACTER FORMAT "X(03)"
    FIELD cCodEstabelFim         AS CHARACTER FORMAT "X(03)"
    FIELD cNrProcImpIni          AS CHARACTER FORMAT "X(12)"
    FIELD cNrProcImpFim          AS CHARACTER FORMAT "X(12)"
    FIELD cEmbarqueIni           AS CHARACTER FORMAT "X(12)"
    FIELD cEmbarqueFim           AS CHARACTER FORMAT "X(12)"
    FIELD lItensLi               AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD lEmbEncerrados         AS LOGICAL   FORMAT "Sim/NÆo" 
    FIELD iSeleciona             AS INTEGER   
    FIELD lEnviaDoctoDespachante AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD cArquivoCopia          AS CHARACTER FORMAT "X(100)"
    FIELD lLayoutPadImp          AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD cLayoutPadImp          AS CHARACTER FORMAT "X(60)"
    FIELD lSobrepor              AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD cDirDestino            AS CHARACTER FORMAT "X(80)"
    FIELD iOrientacao            AS INTEGER   FORMAT "9"
    FIELD lImprimeParam          AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD indDocto               AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita               AS RAW.

DEFINE TEMP-TABLE tt-documentos-impressos NO-UNDO
    FIELD destino       AS char
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido    LIKE pedido-compr.num-pedido
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nome-abrev    LIKE emitente.nome-abrev.

DEFINE TEMP-TABLE tt-documentos-erros NO-UNDO
    FIELD cod-erro      AS INT
    FIELD mensagem      AS CHAR     
    FIELD erro-ajuda    AS CHARACTER
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido    LIKE pedido-compr.num-pedido.
    
DEFINE TEMP-TABLE tt-doc-erros-tmp NO-UNDO
    FIELD cod-erro      AS INT
    FIELD mensagem      AS CHAR     
    FIELD erro-ajuda    AS CHARACTER
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido    LIKE pedido-compr.num-pedido.    


DEFINE TEMP-TABLE tt-fabr-ped-compr-emb NO-UNDO
    FIELD cod-estabel           LIKE embarque-imp.cod-estabel
    FIELD embarque              LIKE embarque-imp.embarque   
    FIELD num-pedido            LIKE ordem-compra.num-pedido 
    FIELD cod-fabricante        AS INTEGER
    field cod-emitente          like emitente.cod-emitente
    FIELD nome-fabric	        LIKE emitente.nome-emit
    FIELD endereco-fabric	    LIKE emitente.endereco
    FIELD bairro-fabric	        LIKE emitente.bairro
    FIELD cidade-fabric         LIKE emitente.cidade
    FIELD pais-fabric	        LIKE emitente.pais
    FIELD cep-fabric	        LIKE emitente.cep
    FIELD cgc-fabric            LIKE emitente.cgc
    FIELD estado-fabric	        LIKE emitente.estado
    FIELD ins-estadual-fabric	LIKE emitente.ins-estadual
    FIELD ins-municipal-fabric	LIKE emitente.ins-municipal
    FIELD caixa-postal-fabric	LIKE emitente.caixa-postal
    FIELD e-mail-fabric	        LIKE emitente.e-mail
    FIELD telefone1-fabric	    LIKE emitente.telefone[1]
    FIELD telefone2-fabric	    LIKE emitente.telefone[2]
    FIELD ramal1-fabric	        LIKE emitente.ramal[1]
    FIELD ramal2-fabric	        LIKE emitente.ramal[2]
    FIELD home-page-fabric	    LIKE emitente.home-page
    FIELD telefax-fabric        LIKE emitente.telefax
    FIELD ramal-fax-fabric	    LIKE emitente.ramal-fax
    FIELD telef-fac-fabric	    LIKE emitente.telef-fac
    FIELD ramal-fac-fabric	    LIKE emitente.ramal-fac
    FIELD telef-modem-fabric	LIKE emitente.telef-modem
    FIELD ramal-modem-fabric	LIKE emitente.ramal-modem
    field prc-fornec-liq-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-liq-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-bru-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field peso-liquido-total-fabr             as decimal format ">>>>>,>>>,>>9.99999"
    field peso-bruto-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field ocupacao-total-fabr                 as decimal format ">>>>>,>>>,>>9.99999"
    field quantidade-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field qt-do-forn-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field qt-estatistica-total-fabr           as decimal format ">>>>>,>>>,>>9.99999"
    index fabr-ped-compr-emb is unique primary
          cod-estabel    
          embarque       
          num-pedido     
          cod-fabricante.

DEFINE TEMP-TABLE tt-ncm-fabr-ped-compr-emb NO-UNDO
    FIELD cod-estabel                         LIKE embarque-imp.cod-estabel
    FIELD embarque                            LIKE embarque-imp.embarque   
    FIELD num-pedido                          LIKE ordem-compra.num-pedido 
    FIELD cod-fabricante                      AS INTEGER
    FIELD cod-naladi-sh                       LIKE  classif-fisc.cod-naladi-sh
    field cod-emitente                        like emitente.cod-emitente
    FIELD cod-ncm                             AS CHARACTER FORMAT "X(20)"
    FIELD desc-ncm	                          LIKE  classif-fisc.descricao
    FIELD aliquota-ipi                        LIKE  classif-fisc.aliquota-ipi
    FIELD unidade                             LIKE  classif-fisc.unidade
    FIELD cod-unidade                         LIKE  classif-fisc.cod-unidade
    FIELD suspens-ipi                         LIKE  classif-fisc.log-1
    FIELD cod-un-ibge                         LIKE  classif-fisc.cod-un-ibge
    FIELD un-abr-ibge                         LIKE  classif-fisc.un-abr-ibge
    FIELD cod-mercosul                        LIKE  classif-fisc.cod-mercosul
    FIELD ncm-codigo                          LIKE  classif-fisc.cod-ncm
    FIELD pis-import                          AS CHARACTER FORMAT "X(6)"
    FIELD cofins-import                       AS CHARACTER FORMAT "X(6)"
    FIELD aliquota-ii                         AS CHARACTER FORMAT "X(6)"
    FIELD peso-liquido-total-ncm              as decimal format ">>>>>,>>>,>>9.99999"
    FIELD peso-bruto-total-ncm                as decimal format ">>>>>,>>>,>>9.99999"
    FIELD prc-fornec-liq-total-ncm-mo-cor     as decimal format ">>>>>,>>>,>>9.99999"
    FIELD prc-intern-liq-total-ncm-mo-cor     as decimal format ">>>>>,>>>,>>9.99999"
    FIELD prc-fornec-bru-total-ncm-mo-cor     as decimal format ">>>>>,>>>,>>9.99999"
    FIELD prc-intern-bru-total-ncm-mo-cor     as decimal format ">>>>>,>>>,>>9.99999"
    FIELD ocupacao-total-ncm                  as decimal format ">>>>>,>>>,>>9.99999"
    FIELD quantidade-total-ncm                as decimal format ">>>>>,>>>,>>9.99999"
    FIELD qt-do-forn-total-ncm                as decimal format ">>>>>,>>>,>>9.99999"  
    field qt-estatistica-total-ncm            as decimal format ">>>>>,>>>,>>9.99999"
    FIELD cod-naladi                          LIKE  classif-fisc.cod-naladi
    index ncm-fabr-ped-compr-emb is unique primary
          cod-estabel     
          embarque        
          num-pedido      
          cod-fabricante     
          cod-ncm.

DEFINE TEMP-TABLE tt-ordem-ncm-fabr-ped-compr-emb NO-UNDO
    FIELD cod-estabel            LIKE embarque-imp.cod-estabel              
    FIELD embarque               LIKE embarque-imp.embarque                 
    FIELD num-pedido             LIKE ordem-compra.num-pedido               
    FIELD cod-fabricante         AS INTEGER
    FIELD ncm                    AS CHARACTER FORMAT "X(20)"
    FIELD numero-ordem           LIKE ordem-compra.numero-ordem
    field cod-emitente           like emitente.cod-emitente
    FIELD r-rowid-ordens-emb     AS ROWID
    FIELD r-rowid-ordem-compra   AS ROWID
    FIELD it-codigo              LIKE ordem-compra.it-codigo
    FIELD data-emissao  	     LIKE ordem-compra.data-emissao
    FIELD narrat-ordem	         LIKE ordem-compra.narrativa
    FIELD data-cotacao           LIKE ordem-compra.data-cotacao
    FIELD mo-codigo	             LIKE ordem-compra.mo-codigo
    FIELD aliquota-ipi-ordem     LIKE ordem-compra.aliquota-ipi
    FIELD taxa-financ	         as char
    FIELD valor-taxa	         LIKE ordem-compra.valor-taxa
    FIELD perc-descto	         LIKE ordem-compra.perc-descto
    FIELD prazo-entreg	         LIKE ordem-compra.prazo-entreg
    FIELD contato	             LIKE ordem-compra.contato
    FIELD comentarios	         LIKE ordem-compra.comentarios
    FIELD data-atualiz	         LIKE ordem-compra.data-atualiz
    FIELD hora-atualiz	         LIKE ordem-compra.hora-atualiz
    FIELD cod-refer              LIKE ordem-compra.cod-refer   
    FIELD nr-dias-taxa	         LIKE ordem-compra.nr-dias-taxa
    FIELD loc-entrega	         LIKE ordem-compra.loc-entrega
    FIELD valor-descto-mo-corren LIKE cotacao-item-cex.val-desp
    FIELD valor-descto	         LIKE ordem-compra.valor-descto
    FIELD cod-pto-contr-base     AS CHARACTER FORMAT "X(20)"
    field peso-liquido-total     LIKE ordens-embarque.peso-liquido 
    FIELD regime-import	         AS CHARACTER FORMAT "X(20)"
    FIELD un-fornec	             LIKE cotacao-item.un
    FIELD cdn-pais-orig	         LIKE cotacao-item.cdn-pais-orig
    FIELD desc-pto-contr-base    LIKE pto-contr.descricao
    FIELD nome-pais-orig         LIKE pais.nome-pais
    FIELD trib-ipi               as char
    FIELD aliquota-icms          LIKE ordens-embarque.aliquota-icms       
    FIELD aliquota-ipi           LIKE ordens-embarque.aliquota-ipi        
    FIELD aliquota-ii            like ordens-embarque.aliquota-ii
    FIELD trib-ii                as char         
    FIELD trib-pis               as char   
    FIELD trib-cofins            as char 
    FIELD trib-icms              as char
    FIELD aliquota-pis-ext       like ordens-embarque.val-aliq-ext-pis    
    field aliquota-cofins-ext    like ordens-embarque.val-aliq-ext-cofins 
    FIELD desc-moeda	         LIKE moeda.descricao
    FIELD sigla-moeda	         LIKE moeda.sigla
    FIELD desc-item-fornec       AS CHARACTER
    FIELD peso-liquido	         LIKE item.peso-liquido
    FIELD peso-bruto-total       LIKE item.peso-bruto
    FIELD peso-bruto             LIKE item.peso-bruto
    field prc-fornec-liq-mo-cor        as decimal        
    field prc-interno-liq-mo-cor       as decimal      
    field prc-fornec-bru-mo-cor        as decimal      
    field prc-interno-bru-mo-cor       as decimal      
    field prc-fornec-liq-total-mo-cor  as decimal 
    field prc-interno-liq-total-mo-cor as decimal
    field prc-fornec-bru-total-mo-cor  as decimal 
    field prc-interno-bru-total-mo-cor as decimal
    field prc-fornec-liq-total    as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-liq-total   as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-fornec-bru-total    as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-bru-total   as decimal format ">>>>>,>>>,>>9.99999" 
    field ocupacao-total          as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-fornec-liq          as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-liq         as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-fornec-bru          as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-bru         as decimal format ">>>>>,>>>,>>9.99999" 
    FIELD altura	             LIKE item.altura
    FIELD comprim	             LIKE item.comprim
    FIELD largura	             LIKE item.largura
    FIELD ge-codigo	             LIKE item.ge-codigo
    FIELD fm-codigo	             LIKE item.fm-codigo
    FIELD fm-cod-com          	 LIKE item.fm-cod-com
    FIELD un	                 LIKE item.un
    FIELD narrativa              LIKE narrativa.descricao
    FIELD desc-grup-estoq        LIKE grup-estoque.descricao
    FIELD desc-familia	         LIKE familia.descricao
    FIELD desc-fam-comerc        LIKE fam-comerc.descricao
    FIELD item-fornec	         LIKE item-fornec.item-do-forn
    FIELD cod-embal	             LIKE item-fornec.cod-embal
    FIELD fator-conver	         LIKE item-fornec.fator-conver
    FIELD num-casa-dec	         LIKE item-fornec.num-casa-dec
    FIELD narrat-item-fornec     LIKE item-fornec.narrativa
    FIELD desc-un-interno        as char format "X(15)"
    FIELD desc-un-fornec         as char format "X(15)"
    FIELD sigla-embalag          LIKE embalag.sigla-emb
    FIELD desc-embalag	         LIKE embalag.descricao
    FIELD peso-embalag	         LIKE embalag.peso-embal
    field quantidade             like ordens-embarque.quantidade
    field qt-do-forn             like ordens-embarque.qt-do-forn     
    field qt-estatistica         like ordens-embarque.quantidade
    FIELD cd-trib-icms           LIKE ordens-embarque.cd-trib-icms
    FIELD desc-item              LIKE item.desc-item
    index ordem-ncm-fabr-ped-compr-emb is unique primary
          cod-estabel
          embarque      
          num-pedido    
          cod-fabricante
          ncm           
          numero-ordem.
    
DEFINE TEMP-TABLE tt-fabr-processo-imp NO-UNDO
    FIELD cod-estabel           LIKE processo-imp.cod-estabel            
    FIELD nr-proc-imp           LIKE processo-imp.nr-proc-imp            
    FIELD num-pedido            LIKE pedido-compr.num-pedido             
    FIELD cod-fabricante        AS INTEGER
    field cod-emitente          like emitente.cod-emitente
    FIELD nome-fabric	        LIKE emitente.nome-emit
    FIELD endereco-fabric	    LIKE emitente.endereco
    FIELD bairro-fabric	        LIKE emitente.bairro
    FIELD cidade-fabric         LIKE emitente.cidade
    FIELD pais-fabric	        LIKE emitente.pais
    FIELD cep-fabric	        LIKE emitente.cep
    FIELD cgc-fabric            LIKE emitente.cgc
    FIELD estado-fabric	        LIKE emitente.estado
    FIELD ins-estadual-fabric	LIKE emitente.ins-estadual
    FIELD ins-municipal-fabric	LIKE emitente.ins-municipal
    FIELD caixa-postal-fabric	LIKE emitente.caixa-postal
    FIELD e-mail-fabric	        LIKE emitente.e-mail
    FIELD telefone1-fabric	    LIKE emitente.telefone[1]
    FIELD telefone2-fabric	    LIKE emitente.telefone[2]
    FIELD ramal1-fabric	        LIKE emitente.ramal[1]
    FIELD ramal2-fabric	        LIKE emitente.ramal[2]
    FIELD home-page-fabric	    LIKE emitente.home-page
    FIELD telefax-fabric        LIKE emitente.telefax
    FIELD ramal-fax-fabric	    LIKE emitente.ramal-fax
    FIELD telef-fac-fabric	    LIKE emitente.telef-fac
    FIELD ramal-fac-fabric	    LIKE emitente.ramal-fac
    FIELD telef-modem-fabric	LIKE emitente.telef-modem
    FIELD ramal-modem-fabric	LIKE emitente.ramal-modem
    field peso-liquido-total-fabr             as decimal format ">>>>>,>>>,>>9.99999"
    field peso-bruto-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-liq-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-liq-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-bru-total-fabr-mo-cor    as decimal format ">>>>>,>>>,>>9.99999"
    field ocupacao-total-fabr                 as decimal format ">>>>>,>>>,>>9.99999"
    field quantidade-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field qt-do-forn-total-fabr               as decimal format ">>>>>,>>>,>>9.99999"
    field qt-estatistica-total-fabr           as decimal format ">>>>>,>>>,>>9.99999"
    index fabr-processo-imp is unique primary
          cod-estabel   
          nr-proc-imp      
          num-pedido    
          cod-fabricante.

DEFINE TEMP-TABLE tt-ord-compr-fabr-proc-imp NO-UNDO
    FIELD cod-estabel    LIKE processo-imp.cod-estabel            
    FIELD nr-proc-imp    LIKE processo-imp.nr-proc-imp            
    FIELD num-pedido     LIKE pedido-compr.num-pedido             
    FIELD cod-fabricante AS INTEGER
    FIELD numero-ordem   LIKE ordem-compra.numero-ordem
    index ord-compr-fabr-proc-imp is unique primary
          cod-estabel   
          nr-proc-imp   
          num-pedido    
          cod-fabricante
          numero-ordem.

DEFINE TEMP-TABLE tt-ncm-fabr-processo-imp NO-UNDO
    FIELD cod-estabel                     LIKE processo-imp.cod-estabel
    FIELD nr-proc-imp                     LIKE processo-imp.nr-proc-imp
    FIELD num-pedido                      LIKE ordem-compra.num-pedido 
    FIELD cod-fabricante                  AS INTEGER
    field cod-emitente                    like emitente.cod-emitente
    FIELD cod-ncm                         AS CHARACTER FORMAT "X(20)"
    FIELD desc-ncm	                      LIKE  classif-fisc.descricao
    field qt-estatistica-total-ncm        like prazo-compra.quantidade
    FIELD aliquota-ipi                    LIKE  classif-fisc.aliquota-ipi
    FIELD unidade                         LIKE  classif-fisc.unidade
    FIELD cod-unidade                     LIKE  classif-fisc.cod-unidade
    FIELD suspens-ipi                     LIKE  classif-fisc.log-1
    FIELD cod-un-ibge                     LIKE  classif-fisc.cod-un-ibge
    FIELD un-abr-ibge                     LIKE  classif-fisc.un-abr-ibge
    FIELD cod-naladi-sh                   LIKE  classif-fisc.cod-naladi-sh
    FIELD cod-naladi                      LIKE  classif-fisc.cod-naladi
    FIELD cod-mercosul                    LIKE  classif-fisc.cod-mercosul
    FIELD ncm-codigo                      LIKE  classif-fisc.cod-ncm
    FIELD pis-import                      AS CHARACTER FORMAT "X(6)"
    FIELD cofins-import                   AS CHARACTER FORMAT "X(6)"
    FIELD aliquota-ii                     AS CHARACTER FORMAT "X(6)"        
    field peso-liquido-total-ncm          like item.peso-liquido
    field peso-bruto-total-ncm            like item.peso-bruto 
    field prc-fornec-liq-total-ncm-mo-cor like item.preco-base
    field prc-intern-liq-total-ncm-mo-cor like item.preco-base
    field prc-fornec-bru-total-ncm-mo-cor like item.preco-base
    field prc-intern-bru-total-ncm-mo-cor like item.preco-base
    field ocupacao-total-ncm              like item.volume  
    field quantidade-total-ncm            like prazo-compra.quantidade
    field qt-do-forn-total-ncm            like prazo-compra.quantidade
    index ncm-fabr-processo-imp is unique primary
          cod-estabel   
          nr-proc-imp   
          num-pedido    
          cod-fabricante
          cod-ncm.       

DEFINE TEMP-TABLE tt-ordem-ncm-fabr-processo-imp NO-UNDO
    FIELD cod-estabel            LIKE embarque-imp.cod-estabel              
    FIELD nr-proc-imp            LIKE processo-imp.nr-proc-imp
    FIELD num-pedido             LIKE ordem-compra.num-pedido               
    FIELD cod-fabricante         AS INTEGER
    FIELD ncm                    AS CHARACTER FORMAT "X(20)"
    FIELD numero-ordem           LIKE ordem-compra.numero-ordem
    field cod-emitente           like emitente.cod-emitente
    FIELD valor-descto-mo-corren like cotacao-item-cex.val-desp
    FIELD r-rowid-ordem-compra   AS rowid
    FIELD it-codigo                LIKE ordem-compra.it-codigo   
    FIELD un-fornec	               LIKE cotacao-item.un
    FIELD data-emissao             LIKE ordem-compra.data-emissao
    FIELD narrat-ordem             LIKE ordem-compra.narrativa   
    FIELD data-cotacao             LIKE ordem-compra.data-cotacao
    FIELD mo-codigo                LIKE ordem-compra.mo-codigo   
    FIELD aliquota-ipi-ordem       LIKE ordem-compra.aliquota-ipi
    FIELD taxa-financ              as char
    FIELD valor-taxa               LIKE ordem-compra.valor-taxa  
    FIELD perc-descto              LIKE ordem-compra.perc-descto 
    FIELD prazo-entreg             LIKE ordem-compra.prazo-entreg
    FIELD contato                  LIKE ordem-compra.contato     
    FIELD comentarios              LIKE ordem-compra.comentarios 
    FIELD data-atualiz             LIKE ordem-compra.data-atualiz
    FIELD hora-atualiz             LIKE ordem-compra.hora-atualiz
    FIELD cod-refer                LIKE ordem-compra.cod-refer   
    FIELD valor-descto             LIKE ordem-compra.valor-descto
    FIELD nr-dias-taxa             LIKE ordem-compra.nr-dias-taxa
    FIELD loc-entrega              LIKE ordem-compra.loc-entrega
    field quantidade             like ordens-embarque.quantidade
    field qt-do-forn             like ordens-embarque.qt-do-forn     
    field qt-estatistica         like ordens-embarque.quantidade
    FIELD cd-trib-icms           LIKE ordens-embarque.cd-trib-icms        
    FIELD trib-ipi               as char        
    FIELD aliquota-icms          LIKE ordens-embarque.aliquota-icms       
    FIELD aliquota-ipi           LIKE ordens-embarque.aliquota-ipi        
    FIELD aliquota-ii            like ordens-embarque.aliquota-ii
    FIELD trib-ii                as char
    FIELD trib-pis               as char   
    FIELD trib-cofins            as char 
    FIELD trib-icms              as char
    FIELD aliquota-pis-ext       like ordens-embarque.val-aliq-ext-pis    
    field aliquota-cofins-ext    like ordens-embarque.val-aliq-ext-cofins 
    field peso-liquido-total     LIKE ordens-embarque.peso-liquido
    field peso-liquido           LIKE ordens-embarque.peso-liquido        
    field peso-bruto-total       LIKE ordens-embarque.peso-bruto
    field peso-bruto             LIKE ordens-embarque.peso-bruto
    field prc-fornec-liq-mo-cor        as decimal        
    field prc-interno-liq-mo-cor       as decimal      
    field prc-fornec-bru-mo-cor        as decimal      
    field prc-interno-bru-mo-cor       as decimal      
    field prc-fornec-liq-total-mo-cor  as decimal 
    field prc-interno-liq-total-mo-cor as decimal
    field prc-fornec-bru-total-mo-cor  as decimal 
    field prc-interno-bru-total-mo-cor as decimal
    field prc-fornec-liq-total    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-liq-total   as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru-total    as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-bru-total   as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-liq          as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-liq         as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru          as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-bru         as decimal format ">>>>>,>>>,>>9.99999"
    field ocupacao-total          as decimal format ">>>>>,>>>,>>9.99999"
    FIELD cod-pto-contr-base     AS CHARACTER FORMAT "X(20)"
    FIELD regime-import	         AS CHARACTER FORMAT "X(20)"
    FIELD cdn-pais-orig	         LIKE cotacao-item.cdn-pais-orig
    field nome-pais-orig         like pais.nome-pais
    field desc-moeda             like moeda.descricao
    field sigla-moeda            like moeda.sigla
    field desc-item-fornec       like item.desc-item
    field desc-item              like item.desc-item   
    FIELD altura                 like item.altura      
    FIELD comprim                like item.comprim     
    field largura                like item.largura     
    field ge-codigo              like item.ge-codigo   
    field fm-codigo              like item.fm-codigo   
    field fm-cod-com             like item.fm-cod-com  
    field narrativa              like narrativa.descricao
    field desc-grup-estoq        like grup-estoque.descricao
    field desc-familia	         like familia.descricao
    field desc-fam-comerc        like fam-comerc.descricao
    field item-fornec            like item-fornec.item-do-forn 
    field cod-embal              like item-fornec.cod-embal    
    field fator-conver           like item-fornec.fator-conver 
    field num-casa-dec           like item-fornec.num-casa-dec 
    field narrat-item-fornec     like item-fornec.narrativa
    field desc-un-interno        as char
    field desc-un-fornec         as char
    field sigla-embalag          like embalag.sigla-emb   
    field desc-embalag           like embalag.descricao   
    field peso-embalag           like embalag.peso-embal
    field un                     like item.un
    field desc-pto-contr-base    like pto-contr.descricao
    index ordem-ncm-fabr-processo-imp is unique primary
          cod-estabel   
          nr-proc-imp   
          num-pedido    
          cod-fabricante
          ncm           
          numero-ordem.
                    
DEFINE TEMP-TABLE tt-desp-pedido NO-UNDO
    FIELD num-pedido                LIKE pedido-compr.num-pedido
    field numero-ordem              like cotacao-item-cex.numero-ordem
    FIELD cod-desp                  LIKE cotacao-item-cex.cod-desp
    FIELD cod-cond-pagto            LIKE cotacao-item-cex.cod-cond-pag
    field val-desp-mo-corren        as decimal format ">>>>>,>>>,>>9.99999"
    field val-desp-mo-ordem         as decimal format ">>>>>,>>>,>>9.99999"
    field r-cotacao-it-cex          as rowid
    field desc-despesa              like desp-imp.descricao
    FIELD cod-emitente-desp         LIKE cotacao-item-cex.cod-emitente
    FIELD mo-codigo                 LIKE cotacao-item-cex.mo-codigo        
    FIELD cod-pto-contr             LIKE cotacao-item-cex.cod-pto-contr    
    FIELD val-desp                  LIKE cotacao-item-cex.val-desp
    FIELD nome-emit-desp            LIKE emitente.nome-emit    
    field endereco-emit-desp        like emitente.endereco     
    FIELD bairro-emit-desp          LIKE emitente.bairro       
    FIELD cidade-emit-desp          LIKE emitente.cidade       
    field pais-emit-desp            like emitente.pais         
    FIELD cep-emit-desp             LIKE emitente.cep          
    FIELD cgc-emit-desp             LIKE emitente.cgc          
    FIELD estado-emit-desp          LIKE emitente.estado       
    FIELD ins-estadual-emit-desp    LIKE emitente.ins-estadual 
    field ins-municipal-emit-desp   LIKE emitente.ins-municipal
    field caixa-postal-emit-desp    like emitente.caixa-postal 
    FIELD e-mail-emit-desp          LIKE emitente.e-mail       
    field cod-aba-emit-desp         LIKE emitente-cex.cod-aba      
    FIELD telefone1-emit-desp       like emitente.telefone[1]  
    FIELD telefone2-emit-desp       LIKE emitente.telefone[2]  
    field ramal1-emit-desp          LIKE emitente.ramal[1]     
    FIELD ramal2-emit-desp          LIKE emitente.ramal[2]     
    FIELD home-page-emit-desp       LIKE emitente.home-page    
    FIELD telefax-emit-desp         LIKE emitente.telefax      
    FIELD ramal-fax-emit-desp       LIKE emitente.ramal-fax    
    field telef-fac-emit-desp       like emitente.telef-fac    
    field ramal-fac-emit-desp       LIKE emitente.ramal-fac    
    field telef-modem-emit-desp     LIKE emitente.telef-modem  
    field ramal-modem-emit-desp     LIKE emitente.ramal-modem
    field desc-moeda                like moeda.descricao
    field sigla-moeda               like moeda.sigla
    field desc-pto-contr            like pto-contr.descricao
    field desc-cond-pagto           like cond-pagto.descricao
    index desp-pedido is unique primary
          num-pedido             
          cod-desp         
          cod-cond-pagto   
          cod-emitente-desp
          mo-codigo        
          cod-pto-contr.

DEFINE TEMP-TABLE tt-emb NO-UNDO
    FIELD cod-estabel                LIKE embarque-imp.cod-estabel
    FIELD embarque                   LIKE embarque-imp.embarque
    FIELD r-rowid                    AS   ROWID
    FIELD cod-despachante            LIKE embarque-imp.cod-despachante
    FIELD cod-transportador          LIKE embarque-imp.cod-transportador         
    FIELD desc-via-transp            AS CHARACTER FORMAT "X(16)"
    FIELD cod-incoterm               LIKE embarque-imp.cod-incoterm              
    FIELD declaracao-import          LIKE embarque-imp.declaracao-import         
    FIELD nr-rof                     LIKE embarque-imp.nr-rof                    
    FIELD cod-banco                  LIKE embarque-imp.cod-banco                 
    FIELD carta-credito              LIKE embarque-imp.carta-credito             
    FIELD narrativa                  LIKE embarque-imp.narrativa                 
    FIELD desc-situacao              AS CHARACTER FORMAT "X(16)"
    FIELD contabilizado              as char             
    FIELD id-meio-transp             LIKE embarque-imp.id-meio-transp            
    FIELD val-perc-ir                LIKE embarque-imp.val-perc-ir               
    FIELD val-perc-juros             LIKE embarque-imp.val-perc-juros            
    FIELD cod-conhecto-master        LIKE embarque-imp.cod-conhecto-master        
    FIELD cod-conhecto-house         LIKE embarque-imp.cod-conhecto-house        
    FIELD cdn-corretor-cambio-import LIKE embarque-imp.cdn-corretor-cambio-import
    FIELD cdn-despa-exter-import     LIKE embarque-imp.cdn-despa-exter-import    
    FIELD cdn-segurad-import         LIKE embarque-imp.cdn-segurad-import        
    FIELD cdn-corretor-import        LIKE embarque-imp.cdn-corretor-import
    FIELD nome-import                LIKE estabelec.nome
    FIELD endereco-import            LIKE estabelec.endereco             
    FIELD bairro-import              LIKE estabelec.bairro               
    FIELD cidade-import              LIKE estabelec.cidade               
    FIELD pais-import                LIKE estabelec.pais                     
    FIELD cep-import                 LIKE estabelec.cep                      
    FIELD cgc-import                 LIKE estabelec.cgc                      
    FIELD estado-import              LIKE estabelec.estado               
    FIELD ins-estadual-import        LIKE estabelec.ins-estadual     
    FIELD ins-municipal-import       LIKE estabelec.ins-municipal    
    FIELD cod-suframa-import         LIKE estabelec.cod-suframa      
    FIELD cod-emit-import            LIKE estabelec.cod-emitente
    FIELD nome-emit-import	         LIKE emitente.nome-emit
    FIELD endereco-emit-import	     LIKE emitente.endereco
    FIELD bairro-emit-import	     LIKE emitente.bairro
    FIELD cidade-emit-import	     LIKE emitente.cidade
    FIELD pais-emit-import	         LIKE emitente.pais
    FIELD cep-emit-import	         LIKE emitente.cep
    FIELD cgc-emit-import	         LIKE emitente.cgc
    FIELD estado-emit-import	     LIKE emitente.estado
    FIELD ins-estadual-emit-import	 LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-import	 LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-import	 LIKE emitente.caixa-postal
    FIELD e-mail-emit-import	     LIKE emitente.e-mail
    FIELD cod-aba-emit-import        LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-import	     LIKE emitente.telefone[1]
    FIELD telefone2-emit-import	     LIKE emitente.telefone[2]
    FIELD ramal1-emit-import	     LIKE emitente.ramal[1]
    FIELD ramal2-emit-import         LIKE emitente.ramal[2]
    FIELD home-page-emit-import   	 LIKE emitente.home-page
    FIELD telefax-emit-import        LIKE emitente.telefax
    FIELD ramal-fax-emit-import    	 LIKE emitente.ramal-fax
    FIELD telef-fac-emit-import    	 LIKE emitente.telef-fac
    FIELD ramal-fac-emit-import    	 LIKE emitente.ramal-fac
    FIELD telef-modem-emit-import 	 LIKE emitente.telef-modem
    FIELD ramal-modem-emit-import 	 LIKE emitente.ramal-modem
    FIELD nome-despach-ext	         LIKE emitente.nome-emit
    FIELD endereco-despach-ext       LIKE emitente.endereco
    FIELD bairro-despach-ext         LIKE emitente.bairro
    FIELD cidade-despach-ext         LIKE emitente.cidade
    FIELD pais-despach-ext	         LIKE emitente.pais
    FIELD cep-despach-ext	         LIKE emitente.cep
    FIELD cgc-despach-ext	         LIKE emitente.cgc
    FIELD estado-despach-ext	     LIKE emitente.estado
    FIELD ins-estadual-despach-ext   LIKE emitente.ins-estadual
    FIELD ins-municipal-despach-ext  LIKE emitente.ins-municipal
    FIELD caixa-postal-despach-ext   LIKE emitente.caixa-postal
    FIELD e-mail-despach-ext         LIKE emitente.e-mail
    FIELD cod-aba-despach-ext        LIKE emitente-cex.cod-aba
    FIELD telefone1-despach-ext      LIKE emitente.telefone[1]
    FIELD telefone2-despach-ext      LIKE emitente.telefone[2]
    FIELD ramal1-despach-ext         LIKE emitente.ramal[1]
    FIELD ramal2-despach-ext         LIKE emitente.ramal[2]
    FIELD home-page-despach-ext      LIKE emitente.home-page
    FIELD telefax-despach-ext        LIKE emitente.telefax
    FIELD ramal-fax-despach-ext      LIKE emitente.ramal-fax
    FIELD telef-fac-despach-ext      LIKE emitente.telef-fac
    FIELD ramal-fac-despach-ext      LIKE emitente.ramal-fac
    FIELD telef-modem-despach-ext    LIKE emitente.telef-modem
    FIELD ramal-modem-despach-ext    LIKE emitente.ramal-modem
    FIELD nome-despach	             LIKE emitente.nome-emit
    FIELD endereco-despach           LIKE emitente.endereco
    FIELD bairro-despach             LIKE emitente.bairro
    FIELD cidade-despach             LIKE emitente.cidade
    FIELD pais-despach	             LIKE emitente.pais
    FIELD cep-despach	             LIKE emitente.cep
    FIELD cgc-despach	             LIKE emitente.cgc
    FIELD estado-despach	         LIKE emitente.estado
    FIELD ins-estadual-despach       LIKE emitente.ins-estadual
    FIELD ins-municipal-despach      LIKE emitente.ins-municipal
    FIELD caixa-postal-despach       LIKE emitente.caixa-postal
    FIELD e-mail-despach             LIKE emitente.e-mail
    FIELD cod-aba-despach	         LIKE emitente-cex.cod-aba
    FIELD telefone1-despach	         LIKE emitente.telefone[1]
    FIELD telefone2-despach	         LIKE emitente.telefone[2]
    FIELD ramal1-despach	         LIKE emitente.ramal[1]
    FIELD ramal2-despach	         LIKE emitente.ramal[2]
    FIELD home-page-despach	         LIKE emitente.home-page
    FIELD telefax-despach	         LIKE emitente.telefax
    FIELD ramal-fax-despach	         LIKE emitente.ramal-fax
    FIELD telef-fac-despach	         LIKE emitente.telef-fac
    FIELD ramal-fac-despach	         LIKE emitente.ramal-fac
    FIELD telef-modem-despach        LIKE emitente.telef-modem
    FIELD ramal-modem-despach        LIKE emitente.ramal-modem
    FIELD nome-corretor-cam	         LIKE emitente.nome-emit
    FIELD endereco-corretor-cam      LIKE emitente.endereco
    FIELD bairro-corretor-cam        LIKE emitente.bairro
    FIELD cidade-corretor-cam        LIKE emitente.cidade
    FIELD pais-corretor-cam	         LIKE emitente.pais
    FIELD cep-corretor-cam	         LIKE emitente.cep
    FIELD cgc-corretor-cam	         LIKE emitente.cgc
    FIELD estado-corretor-cam        LIKE emitente.estado
    FIELD ins-estadual-corretor-cam	 LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-cam LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-cam	 LIKE emitente.caixa-postal
    FIELD e-mail-corretor-cam	     LIKE emitente.e-mail
    FIELD cod-aba-corretor-cam	     LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-cam     LIKE emitente.telefone[1]
    FIELD telefone2-corretor-cam     LIKE emitente.telefone[2]
    FIELD ramal1-corretor-cam	     LIKE emitente.ramal[1]
    FIELD ramal2-corretor-cam	     LIKE emitente.ramal[2]
    FIELD home-page-corretor-cam     LIKE emitente.home-page
    FIELD telefax-corretor-cam	     LIKE emitente.telefax
    FIELD ramal-fax-corretor-cam     LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-cam     LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-cam     LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-cam   LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-cam   LIKE emitente.ramal-modem
    FIELD nome-segurad	             LIKE emitente.nome-emit
    FIELD endereco-segurad	         LIKE emitente.endereco
    FIELD bairro-segurad	         LIKE emitente.bairro
    FIELD cidade-segurad	         LIKE emitente.cidade
    FIELD pais-segurad	             LIKE emitente.pais
    FIELD cep-segurad	             LIKE emitente.cep
    FIELD cgc-segurad	             LIKE emitente.cgc
    FIELD estado-segurad	         LIKE emitente.estado
    FIELD ins-estadual-segurad       LIKE emitente.ins-estadual
    FIELD ins-municipal-segurad      LIKE emitente.ins-municipal
    FIELD caixa-postal-segurad       LIKE emitente.caixa-postal
    FIELD e-mail-segurad	         LIKE emitente.e-mail
    FIELD cod-aba-segurad	         LIKE emitente-cex.cod-aba
    FIELD telefone1-segurad	         LIKE emitente.telefone[1]
    FIELD telefone2-segurad	         LIKE emitente.telefone[2]
    FIELD ramal1-segurad	         LIKE emitente.ramal[1]
    FIELD ramal2-segurad	         LIKE emitente.ramal[2]
    FIELD home-page-segurad	         LIKE emitente.home-page
    FIELD telefax-segurad	         LIKE emitente.telefax
    FIELD ramal-fax-segurad	         LIKE emitente.ramal-fax
    FIELD telef-fac-segurad	         LIKE emitente.telef-fac
    FIELD ramal-fac-segurad	         LIKE emitente.ramal-fac
    FIELD telef-modem-segurad        LIKE emitente.telef-modem
    FIELD ramal-modem-segurad        LIKE emitente.ramal-modem
    FIELD nome-corretor-imp	         LIKE emitente.nome-emit
    FIELD endereco-corretor-imp	     LIKE emitente.endereco
    FIELD bairro-corretor-imp	     LIKE emitente.bairro
    FIELD cidade-corretor-imp	     LIKE emitente.cidade
    FIELD pais-corretor-imp	         LIKE emitente.pais
    FIELD cep-corretor-imp	         LIKE emitente.cep
    FIELD cgc-corretor-imp	         LIKE emitente.cgc
    FIELD estado-corretor-imp	     LIKE emitente.estado
    FIELD ins-estadual-corretor-imp	 LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-imp LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-imp	 LIKE emitente.caixa-postal
    FIELD e-mail-corretor-imp	     LIKE emitente.e-mail
    FIELD cod-aba-corretor-imp	     LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-imp	 LIKE emitente.telefone[1]
    FIELD telefone2-corretor-imp	 LIKE emitente.telefone[2]
    FIELD ramal1-corretor-imp	     LIKE emitente.ramal[1]
    FIELD ramal2-corretor-imp	     LIKE emitente.ramal[2]
    FIELD home-page-corretor-imp	 LIKE emitente.home-page
    FIELD telefax-corretor-imp	     LIKE emitente.telefax
    FIELD ramal-fax-corretor-imp	 LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-imp	 LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-imp	 LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-imp	 LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-imp	 LIKE emitente.ramal-modem
    FIELD nome-transp	             LIKE transporte.nome
    FIELD nome-abrev-transp	         LIKE transporte.nome-abrev
    FIELD endereco-transp	         LIKE transporte.endereco
    FIELD bairro-transp	             LIKE transporte.bairro
    FIELD cidade-transp	             LIKE transporte.cidade
    FIELD pais-transp	             LIKE transporte.pais
    FIELD cep-transp	             LIKE transporte.cep
    FIELD cgc-transp	             LIKE transporte.cgc
    FIELD estado-transp	             LIKE transporte.estado
    FIELD ins-estadual-transp        LIKE transporte.ins-estadual
    FIELD caixa-postal-transp        LIKE transporte.cx-postal
    FIELD contato-transp	         LIKE transporte.contato
    FIELD telefone-transp	         LIKE transporte.telefone
    FIELD ramal-transp	             LIKE transporte.ramal
    FIELD telefax-transp	         LIKE transporte.telefax
    FIELD telex-transp	             LIKE transporte.telex
    FIELD ins-municipal-transp       LIKE transporte.ins-municipal
    FIELD zip-code-transp	         LIKE transporte.zip-code
    FIELD e-mail-transp	             LIKE transporte.e-mail
    FIELD telef-modem-transp         LIKE transporte.telef-modem
    FIELD home-page-transp	         LIKE transporte.home-page
    FIELD ramal-modem-transp         LIKE transporte.ramal-modem
    FIELD ramal-fax-transp	         LIKE transporte.ramal-fax
    FIELD desc-incoterm	             LIKE inco-cx.descricao
    FIELD desc-banco                 LIKE banco.nome-banco
    FIELD ag-banco	                 LIKE banco.ag-padrao
    FIELD desc-agencia               LIKE agencia.nome
    FIELD desc-itner                 LIKE itinerario.descricao
    FIELD distancia	                 LIKE itinerario.distancia
    FIELD nr-dias	                 LIKE itinerario.nr-dias
    FIELD narrat-itiner              LIKE itinerario.narrativa
    FIELD pto-despacho	             LIKE historico-embarque.cod-pto-contr               
    FIELD desc-pto-despacho	         LIKE pto-contr.descricao          
    FIELD data-prev-despacho         LIKE historico-embarque.dt-previsao
    FIELD data-efet-despacho         LIKE historico-embarque.dt-efetiva
    FIELD data-ult-prev-despacho     LIKE historico-embarque.dt-ult-previsao
    FIELD ufr-despacho	             LIKE pto-contr.unid-referencial
    FIELD pto-embarque	             LIKE historico-embarque.cod-pto-contr               
    FIELD desc-pto-embarque	         LIKE pto-contr.descricao
    FIELD data-prev-embarque         LIKE historico-embarque.dt-previsao
    FIELD data-efet-embarque         LIKE historico-embarque.dt-efetiva
    FIELD data-ult-prev-embarque     LIKE historico-embarque.dt-ult-previsao
    FIELD ufr-embarque	             LIKE pto-contr.unid-referencial
    FIELD pto-nacionaliz	         LIKE historico-embarque.cod-pto-contr                
    FIELD desc-pto-nacionaliz        LIKE pto-contr.descricao
    FIELD data-prev-nacionaliz       LIKE historico-embarque.dt-previsao
    FIELD data-efet-nacionaliz       LIKE historico-embarque.dt-efetiva
    FIELD data-ult-prev-nacionaliz   LIKE historico-embarque.dt-ult-previsao
    FIELD ufr-nacionaliz	         LIKE pto-contr.unid-referencial
    FIELD pto-chegada	             LIKE historico-embarque.cod-pto-contr               
    FIELD desc-pto-chegada	         LIKE pto-contr.descricao
    FIELD data-prev-chegada	         LIKE historico-embarque.dt-previsao
    FIELD data-efet-chegada	         LIKE historico-embarque.dt-efetiva
    FIELD data-ult-prev-chegada      LIKE historico-embarque.dt-ult-previsao
    FIELD ufr-chegada	             LIKE pto-contr.unid-referencial
    field peso-liquido-total-emb           as decimal format ">>>>>,>>>,>>9.99999"
    field peso-bruto-total-emb             as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-liq-total-emb-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-liq-total-emb-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru-total-emb-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field prc-intern-bru-total-emb-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field ocupacao-total-emb               as decimal format ">>>>>,>>>,>>9.99999"
    field quantidade-total-emb             as decimal format ">>>>>,>>>,>>9.99999"
    field qt-do-forn-total-emb             as decimal format ">>>>>,>>>,>>9.99999"
    field qt-estatistica-total-emb         as decimal format ">>>>>,>>>,>>9.99999"
    index emb is unique primary
          cod-estabel
          embarque.

DEFINE TEMP-TABLE tt-pedido-compr-emb NO-UNDO
    FIELD cod-estabel-gestor            LIKE pedido-compr.cod-estabel
    FIELD cod-estabel                   LIKE embarque-imp.cod-estabel
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid                       AS ROWID
    FIELD num-ped-benef	                LIKE pedido-compr.num-pedido
    FIELD data-pedido	                LIKE pedido-compr.data-pedido
    FIELD desc-situacao	                AS CHARACTER FORMAT "X(12)"
    FIELD cod-emitente                  LIKE pedido-compr.cod-emitente
    FIELD end-entrega                   LIKE pedido-compr.end-entrega
    FIELD end-cobranca                  LIKE pedido-compr.end-cobranca
    FIELD cod-cond-pag                  LIKE pedido-compr.cod-cond-pag
    FIELD cod-mens-ped                  LIKE pedido-compr.cod-mensagem
    FIELD comentarios	                LIKE pedido-compr.comentarios
    FIELD compl-entrega	                LIKE pedido-compr.compl-entrega
    FIELD cod-emit-terc	                LIKE pedido-compr.cod-emit-terc
    FIELD nome-emit-entr	            LIKE emitente.nome-emit
    FIELD endereco-emit-entr            LIKE emitente.endereco
    FIELD bairro-emit-entr	            LIKE emitente.bairro
    FIELD cidade-emit-entr	            LIKE emitente.cidade
    FIELD pais-emit-entr	            LIKE emitente.pais
    FIELD cep-emit-entr	                LIKE emitente.cep
    FIELD cgc-emit-entr	                LIKE emitente.cgc
    FIELD estado-emit-entr	            LIKE emitente.estado
    FIELD ins-estadual-emit-entr        LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-entr       LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-entr        LIKE emitente.caixa-postal
    FIELD e-mail-emit-entr	            LIKE emitente.e-mail
    FIELD cod-aba-emit-entr	            LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-entr	        LIKE emitente.telefone[1]
    FIELD telefone2-emit-entr	        LIKE emitente.telefone[2]
    FIELD ramal1-emit-entr	            LIKE emitente.ramal[1]
    FIELD ramal2-emit-entr	            LIKE emitente.ramal[2]
    FIELD home-page-emit-entr	        LIKE emitente.home-page
    FIELD telefax-emit-entr	            LIKE emitente.telefax
    FIELD ramal-fax-emit-entr	        LIKE emitente.ramal-fax
    FIELD telef-fac-emit-entr	        LIKE emitente.telef-fac
    FIELD ramal-fac-emit-entr	        LIKE emitente.ramal-fac
    FIELD telef-modem-emit-entr         LIKE emitente.telef-modem
    FIELD ramal-modem-emit-entr         LIKE emitente.ramal-modem
    FIELD nome-estab-entr	            LIKE estabelec.nome
    FIELD endereco-estab-entr	        LIKE estabelec.endereco
    FIELD bairro-estab-entr	            LIKE estabelec.bairro
    FIELD cidade-estab-entr	            LIKE estabelec.cidade
    FIELD pais-estab-entr	            LIKE estabelec.pais
    FIELD cep-estab-entr	            LIKE estabelec.cep
    FIELD cgc-estab-entr	            LIKE estabelec.cgc
    FIELD estado-estab-entr	            LIKE estabelec.estado
    FIELD ins-estadual-estab-entr       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-entr      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-entr        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-entr	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-entr	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-entr      LIKE emitente.endereco
    FIELD bairro-emit-estab-entr        LIKE emitente.bairro
    FIELD cidade-emit-estab-entr        LIKE emitente.cidade
    FIELD pais-emit-estab-entr          LIKE emitente.pais
    FIELD cep-emit-estab-entr	        LIKE emitente.cep
    FIELD cgc-emit-estab-entr	        LIKE emitente.cgc
    FIELD estado-emit-estab-entr        LIKE emitente.estado
    FIELD ins-estadual-emit-estab-entr	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-entr LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-entr  LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-entr	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-entr	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-entr     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-entr     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-entr	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-entr        LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-entr     LIKE emitente.home-page
    FIELD telefax-emit-estab-entr	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-entr     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-entr     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-entr     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-entr   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-entr   LIKE emitente.ramal-modem
    FIELD nome-estab-cobr	            LIKE estabelec.nome
    FIELD endereco-estab-cobr           LIKE estabelec.endereco
    FIELD bairro-estab-cobr             LIKE estabelec.bairro
    FIELD cidade-estab-cobr             LIKE estabelec.cidade
    index pedido-compr-emb is unique primary
          cod-estabel
          embarque   
          num-pedido.
    
DEFINE TEMP-TABLE tt-pedido-compr-emb-aux NO-UNDO
    FIELD cod-estabel                   LIKE embarque-imp.cod-estabel
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid                       AS ROWID
    FIELD pais-estab-cobr	            LIKE estabelec.pais
    FIELD cep-estab-cobr	            LIKE estabelec.cep
    FIELD cgc-estab-cobr	            LIKE estabelec.cgc
    FIELD estado-estab-cobr             LIKE estabelec.estado
    FIELD ins-estadual-estab-cobr       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-cobr      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-cobr        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-cobr	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-cobr	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-cobr	    LIKE emitente.endereco
    FIELD bairro-emit-estab-cobr	    LIKE emitente.bairro
    FIELD cidade-emit-estab-cobr	    LIKE emitente.cidade
    FIELD pais-emit-estab-cobr	        LIKE emitente.pais
    FIELD cep-emit-estab-cobr	        LIKE emitente.cep
    FIELD cgc-emit-estab-cobr	        LIKE emitente.cgc
    FIELD estado-emit-estab-cobr	    LIKE emitente.estado
    FIELD ins-estadual-emit-estab-cobr	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-cobr	LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-cobr  LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-cobr	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-cobr	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-cobr     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-cobr     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-cobr	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-cobr	    LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-cobr     LIKE emitente.home-page
    FIELD telefax-emit-estab-cobr	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-cobr     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-cobr     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-cobr     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-cobr   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-cobr   LIKE emitente.ramal-modem
    FIELD nome-estab-gest	            LIKE estabelec.nome
    FIELD endereco-estab-gest	        LIKE estabelec.endereco
    FIELD bairro-estab-gest	            LIKE estabelec.bairro
    FIELD cidade-estab-gest	            LIKE estabelec.cidade
    FIELD pais-estab-gest	            LIKE estabelec.pais
    FIELD cep-estab-gest	            LIKE estabelec.cep
    FIELD cgc-estab-gest	            LIKE estabelec.cgc
    FIELD estado-estab-gest	            LIKE estabelec.estado
    FIELD ins-estadual-estab-gest       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-gest      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-gest        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-gest	        LIKE estabelec.cod-emitente 
    FIELD nome-emit-estab-gest	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-gest	    LIKE emitente.endereco
    FIELD bairro-emit-estab-gest	    LIKE emitente.bairro
    FIELD cidade-emit-estab-gest	    LIKE emitente.cidade
    FIELD pais-emit-estab-gest	        LIKE emitente.pais
    FIELD cep-emit-estab-gest	        LIKE emitente.cep
    FIELD cgc-emit-estab-gest	        LIKE emitente.cgc
    FIELD estado-emit-estab-gest	    LIKE emitente.estado
    FIELD ins-estadual-emit-estab-gest	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-gest LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-gest	LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-gest	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-gest	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-gest     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-gest     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-gest	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-gest	    LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-gest     LIKE emitente.home-page
    FIELD telefax-emit-estab-gest	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-gest     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-gest     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-gest     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-gest   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-gest   LIKE emitente.ramal-modem
    FIELD desc-cond-pagto               LIKE cond-pagto.descricao
    FIELD desc-mensagem-ped             LIKE mensagem.descricao
    FIELD texto-mensag-ped	            LIKE mensagem.texto-mensag
    FIELD nr-proc-imp	                LIKE processo-imp.nr-proc-imp
    FIELD cod-itiner	                LIKE processo-imp.cod-itiner
    FIELD dt-emissao	                LIKE processo-imp.dt-emissao
    FIELD dt-implantacao	            LIKE processo-imp.dt-implantacao
    FIELD dt-autorizacao	            LIKE processo-imp.dt-autorizacao
    FIELD cod-despachante	            LIKE processo-imp.cod-despachante
    FIELD cod-exportador	            LIKE processo-imp.cod-exportador
    FIELD cod-consignatario	            LIKE processo-imp.cod-consignatario
    FIELD cod-transportador	            LIKE processo-imp.cod-transportador
    FIELD cod-estabel-proc              LIKE processo-imp.cod-estabel
    FIELD carta-credito	                LIKE processo-imp.carta-credito
    FIELD narrativa                     LIKE processo-imp.narrativa
    FIELD cod-banco	                    LIKE processo-imp.cod-banco
    FIELD nr-rof	                    LIKE processo-imp.nr-rof
    FIELD desc-via-transp	            AS CHARACTER FORMAT "X(16)"
    FIELD estab-fisc	                LIKE processo-imp.estab-fisc
    FIELD contrato-cambio	            LIKE processo-imp.contrato-cambio
    FIELD cod-idioma	                LIKE processo-imp.cod-idioma
    FIELD situacao-proc-imp	            AS CHARACTER FORMAT "X(16)"
    FIELD cod-agente	                LIKE processo-imp.cod-agente
    FIELD cod-mens-proc-imp	            LIKE processo-imp.cod-mensagem
    FIELD texto-mens-proc-imp	        LIKE processo-imp.texto-mensag
    FIELD destino-documentacao	        LIKE processo-imp.destino-documentacao
    FIELD cdn-corretor-cambio-import    LIKE processo-imp.cdn-corretor-cambio-import
    FIELD cdn-despa-exter-import	    LIKE processo-imp.cdn-despa-exter-import
    FIELD cdn-segurad-import	        LIKE processo-imp.cdn-segurad-import
    FIELD cdn-corretor-import	        LIKE processo-imp.cdn-corretor-import
    FIELD nome-import	                LIKE estabelec.nome
    FIELD endereco-import               LIKE estabelec.endereco
    FIELD bairro-import	                LIKE estabelec.bairro
    FIELD cidade-import	                LIKE estabelec.cidade
    FIELD pais-import	                LIKE estabelec.pais
    FIELD cep-import	                LIKE estabelec.cep
    FIELD cgc-import	                LIKE estabelec.cgc
    FIELD estado-import	                LIKE estabelec.estado
    FIELD ins-estadual-import           LIKE estabelec.ins-estadual
    FIELD ins-municipal-import          LIKE estabelec.ins-municipal
    FIELD cod-suframa-import            LIKE estabelec.cod-suframa
    FIELD cod-emit-import	            LIKE estabelec.cod-emitente
    index pedido-compr-emb-aux is unique primary
          cod-estabel
          embarque   
          num-pedido.

DEFINE TEMP-TABLE tt-pedido-compr-emb-aux2 NO-UNDO
    FIELD cod-estabel                   LIKE embarque-imp.cod-estabel
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid                       AS ROWID
    FIELD nome-emit-import	            LIKE emitente.nome-emit
    FIELD endereco-emit-import          LIKE emitente.endereco
    FIELD bairro-emit-import            LIKE emitente.bairro
    FIELD cidade-emit-import            LIKE emitente.cidade
    FIELD pais-emit-import              LIKE emitente.pais
    FIELD cep-emit-import               LIKE emitente.cep
    FIELD cgc-emit-import               LIKE emitente.cgc
    FIELD estado-emit-import            LIKE emitente.estado
    FIELD ins-estadual-emit-import      LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-import     LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-import      LIKE emitente.caixa-postal
    FIELD e-mail-emit-import	        LIKE emitente.e-mail
    FIELD cod-aba-emit-import	        LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-import         LIKE emitente.telefone[1]
    FIELD telefone2-emit-import         LIKE emitente.telefone[2]
    FIELD ramal1-emit-import	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-import	        LIKE emitente.ramal[2]
    FIELD home-page-emit-import         LIKE emitente.home-page
    FIELD telefax-emit-import	        LIKE emitente.telefax
    FIELD ramal-fax-emit-import         LIKE emitente.ramal-fax
    FIELD telef-fac-emit-import         LIKE emitente.telef-fac
    FIELD ramal-fac-emit-import         LIKE emitente.ramal-fac
    FIELD telef-modem-emit-import       LIKE emitente.telef-modem
    FIELD ramal-modem-emit-import       LIKE emitente.ramal-modem
    FIELD nome-emit-export	            LIKE emitente.nome-emit
    FIELD endereco-emit-export          LIKE emitente.endereco
    FIELD bairro-emit-export            LIKE emitente.bairro
    FIELD cidade-emit-export            LIKE emitente.cidade
    FIELD pais-emit-export              LIKE emitente.pais
    FIELD cep-emit-export               LIKE emitente.cep
    FIELD cgc-emit-export               LIKE emitente.cgc
    FIELD estado-emit-export	        LIKE emitente.estado
    FIELD ins-estadual-emit-export      LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-export     LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-export      LIKE emitente.caixa-postal
    FIELD e-mail-emit-export	        LIKE emitente.e-mail
    FIELD cod-aba-emit-export	        LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-export         LIKE emitente.telefone[1]
    FIELD telefone2-emit-export         LIKE emitente.telefone[2]
    FIELD ramal1-emit-export	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-export	        LIKE emitente.ramal[2]
    FIELD home-page-emit-export         LIKE emitente.home-page
    FIELD telefax-emit-export	        LIKE emitente.telefax
    FIELD ramal-fax-emit-export         LIKE emitente.ramal-fax
    FIELD telef-fac-emit-export         LIKE emitente.telef-fac
    FIELD ramal-fac-emit-export         LIKE emitente.ramal-fac
    FIELD telef-modem-emit-export       LIKE emitente.telef-modem
    FIELD ramal-modem-emit-export       LIKE emitente.ramal-modem
    FIELD desc-incoterm                 LIKE inco-cx.descricao
    FIELD cod-incoterm                  LIKE inco-cx.cod-incoterm
    FIELD desc-itner                    LIKE itinerario.descricao
    FIELD distancia	                    LIKE itinerario.distancia
    FIELD nr-dias	                    LIKE itinerario.nr-dias
    FIELD narrat-itiner                 LIKE itinerario.narrativa
    FIELD desc-mensagem-proc            LIKE mensagem.descricao
    FIELD texto-mensag-proc             LIKE mensagem.texto-mensag
    FIELD nome-transp	                LIKE transporte.nome
    FIELD nome-abrev-transp	            LIKE transporte.nome-abrev
    FIELD endereco-transp	            LIKE transporte.endereco
    FIELD bairro-transp	                LIKE transporte.bairro
    FIELD cidade-transp	                LIKE transporte.cidade
    FIELD pais-transp	                LIKE transporte.pais
    FIELD cep-transp	                LIKE transporte.cep
    FIELD cgc-transp	                LIKE transporte.cgc
    FIELD estado-transp	                LIKE transporte.estado
    FIELD ins-estadual-transp           LIKE transporte.ins-estadual
    FIELD caixa-postal-transp           LIKE transporte.cx-postal
    FIELD contato-transp	            LIKE transporte.contato
    FIELD telefone-transp	            LIKE transporte.telefone
    FIELD ramal-transp	                LIKE transporte.ramal
    FIELD telefax-transp	            LIKE transporte.telefax
    FIELD telex-transp	                LIKE transporte.telex
    FIELD ins-municipal-transp          LIKE transporte.ins-municipal
    FIELD zip-code-transp	            LIKE transporte.zip-code
    FIELD e-mail-transp	                LIKE transporte.e-mail
    FIELD telef-modem-transp            LIKE transporte.telef-modem
    FIELD home-page-transp	            LIKE transporte.home-page
    FIELD ramal-modem-transp            LIKE transporte.ramal-modem
    FIELD ramal-fax-transp	            LIKE transporte.ramal-fax
    FIELD nome-despach-ext	            LIKE emitente.nome-emit
    FIELD endereco-despach-ext	        LIKE emitente.endereco
    FIELD bairro-despach-ext	        LIKE emitente.bairro
    FIELD cidade-despach-ext	        LIKE emitente.cidade
    FIELD pais-despach-ext	            LIKE emitente.pais
    FIELD cep-despach-ext	            LIKE emitente.cep
    FIELD cgc-despach-ext	            LIKE emitente.cgc
    FIELD estado-despach-ext	        LIKE emitente.estado
    FIELD ins-estadual-despach-ext	    LIKE emitente.ins-estadual
    FIELD ins-municipal-despach-ext     LIKE emitente.ins-municipal
    FIELD caixa-postal-despach-ext      LIKE emitente.caixa-postal
    FIELD e-mail-despach-ext	        LIKE emitente.e-mail
    FIELD cod-aba-despach-ext	        LIKE emitente-cex.cod-aba
    FIELD telefone1-despach-ext         LIKE emitente.telefone[1]
    FIELD telefone2-despach-ext         LIKE emitente.telefone[2]
    FIELD ramal1-despach-ext	        LIKE emitente.ramal[1]
    FIELD ramal2-despach-ext	        LIKE emitente.ramal[2]
    FIELD home-page-despach-ext         LIKE emitente.home-page
    FIELD telefax-despach-ext	        LIKE emitente.telefax
    FIELD ramal-fax-despach-ext         LIKE emitente.ramal-fax
    FIELD telef-fac-despach-ext         LIKE emitente.telef-fac
    FIELD ramal-fac-despach-ext         LIKE emitente.ramal-fac
    FIELD telef-modem-despach-ext       LIKE emitente.telef-modem
    FIELD ramal-modem-despach-ext       LIKE emitente.ramal-modem
    FIELD nome-despach	                LIKE emitente.nome-emit
    FIELD endereco-despach	            LIKE emitente.endereco
    FIELD bairro-despach	            LIKE emitente.bairro
    FIELD cidade-despach	            LIKE emitente.cidade
    FIELD pais-despach                  LIKE emitente.pais
    FIELD cep-despach                   LIKE emitente.cep
    FIELD cgc-despach                   LIKE emitente.cgc
    FIELD estado-despach	            LIKE emitente.estado
    FIELD ins-estadual-despach	        LIKE emitente.ins-estadual
    FIELD ins-municipal-despach         LIKE emitente.ins-municipal
    FIELD caixa-postal-despach          LIKE emitente.caixa-postal
    FIELD e-mail-despach	            LIKE emitente.e-mail
    FIELD cod-aba-despach	            LIKE emitente-cex.cod-aba
    FIELD telefone1-despach             LIKE emitente.telefone[1]
    FIELD telefone2-despach             LIKE emitente.telefone[2]
    FIELD ramal1-despach	            LIKE emitente.ramal[1]
    FIELD ramal2-despach	            LIKE emitente.ramal[2]
    FIELD home-page-despach             LIKE emitente.home-page
    FIELD telefax-despach	            LIKE emitente.telefax
    FIELD ramal-fax-despach             LIKE emitente.ramal-fax
    FIELD telef-fac-despach             LIKE emitente.telef-fac
    FIELD ramal-fac-despach             LIKE emitente.ramal-fac
    FIELD telef-modem-despach           LIKE emitente.telef-modem
    FIELD ramal-modem-despach           LIKE emitente.ramal-modem
    FIELD nome-agente	                LIKE emitente.nome-emit
    FIELD endereco-agente	            LIKE emitente.endereco
    FIELD bairro-agente	                LIKE emitente.bairro
    FIELD cidade-agente	                LIKE emitente.cidade
    FIELD pais-agente	                LIKE emitente.pais
    FIELD cep-agente	                LIKE emitente.cep
    FIELD cgc-agente	                LIKE emitente.cgc
    FIELD estado-agente	                LIKE emitente.estado
    FIELD ins-estadual-agente           LIKE emitente.ins-estadual
    FIELD ins-municipal-agente          LIKE emitente.ins-municipal
    FIELD caixa-postal-agente           LIKE emitente.caixa-postal
    FIELD e-mail-agente	                LIKE emitente.e-mail
    FIELD cod-aba-agente	            LIKE emitente-cex.cod-aba
    FIELD telefone1-agente	            LIKE emitente.telefone[1]
    FIELD telefone2-agente	            LIKE emitente.telefone[2]
    FIELD ramal1-agente	                LIKE emitente.ramal[1]
    FIELD ramal2-agente	                LIKE emitente.ramal[2]
    FIELD home-page-agente	            LIKE emitente.home-page
    FIELD telefax-agente	            LIKE emitente.telefax
    FIELD ramal-fax-agente	            LIKE emitente.ramal-fax
    FIELD telef-fac-agente	            LIKE emitente.telef-fac
    FIELD ramal-fac-agente	            LIKE emitente.ramal-fac
    FIELD telef-modem-agente	        LIKE emitente.telef-modem
    FIELD ramal-modem-agente	        LIKE emitente.ramal-modem
    FIELD nome-corretor-cam	            LIKE emitente.nome-emit
    FIELD endereco-corretor-cam	        LIKE emitente.endereco
    FIELD bairro-corretor-cam	        LIKE emitente.bairro
    FIELD cidade-corretor-cam	        LIKE emitente.cidade
    FIELD pais-corretor-cam	            LIKE emitente.pais
    FIELD cep-corretor-cam	            LIKE emitente.cep
    FIELD cgc-corretor-cam	            LIKE emitente.cgc
    FIELD estado-corretor-cam	        LIKE emitente.estado
    FIELD ins-estadual-corretor-cam     LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-cam    LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-cam     LIKE emitente.caixa-postal
    FIELD e-mail-corretor-cam	        LIKE emitente.e-mail
    FIELD cod-aba-corretor-cam	        LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-cam        LIKE emitente.telefone[1]
    FIELD telefone2-corretor-cam        LIKE emitente.telefone[2]
    FIELD ramal1-corretor-cam	        LIKE emitente.ramal[1]
    FIELD ramal2-corretor-cam           LIKE emitente.ramal[2]
    FIELD home-page-corretor-cam        LIKE emitente.home-page
    FIELD telefax-corretor-cam	        LIKE emitente.telefax
    FIELD ramal-fax-corretor-cam        LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-cam        LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-cam        LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-cam      LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-cam      LIKE emitente.ramal-modem
    FIELD nome-segurad	                LIKE emitente.nome-emit
    FIELD endereco-segurad	            LIKE emitente.endereco
    FIELD bairro-segurad	            LIKE emitente.bairro
    FIELD cidade-segurad	            LIKE emitente.cidade
    FIELD pais-segurad	                LIKE emitente.pais
    FIELD cep-segurad	                LIKE emitente.cep
    FIELD cgc-segurad	                LIKE emitente.cgc
    FIELD estado-segurad	            LIKE emitente.estado
    FIELD ins-estadual-segurad	        LIKE emitente.ins-estadual
    FIELD ins-municipal-segurad         LIKE emitente.ins-municipal
    FIELD caixa-postal-segurad          LIKE emitente.caixa-postal
    FIELD e-mail-segurad	            LIKE emitente.e-mail
    FIELD cod-aba-segurad	            LIKE emitente-cex.cod-aba
    FIELD telefone1-segurad             LIKE emitente.telefone[1]
    FIELD telefone2-segurad             LIKE emitente.telefone[2]
    FIELD ramal1-segurad	            LIKE emitente.ramal[1]
    FIELD ramal2-segurad	            LIKE emitente.ramal[2]
    FIELD home-page-segurad             LIKE emitente.home-page
    FIELD telefax-segurad	            LIKE emitente.telefax
    FIELD ramal-fax-segurad             LIKE emitente.ramal-fax
    FIELD telef-fac-segurad             LIKE emitente.telef-fac
    FIELD ramal-fac-segurad             LIKE emitente.ramal-fac
    FIELD telef-modem-segurad           LIKE emitente.telef-modem
    FIELD ramal-modem-segurad           LIKE emitente.ramal-modem
    index pedido-compr-emb-aux2 is unique primary
          cod-estabel
          embarque   
          num-pedido.

DEFINE TEMP-TABLE tt-pedido-compr-emb-aux3 NO-UNDO
    FIELD cod-estabel                   LIKE processo-imp.cod-estabel
    FIELD nr-proc-imp                   LIKE processo-imp.nr-proc-imp
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD r-rowid                       AS ROWID
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD nome-corretor-imp	            LIKE emitente.nome-emit
    FIELD endereco-corretor-imp	        LIKE emitente.endereco
    FIELD bairro-corretor-imp	        LIKE emitente.bairro
    FIELD cidade-corretor-imp	        LIKE emitente.cidade
    FIELD pais-corretor-imp	            LIKE emitente.pais
    FIELD cep-corretor-imp	            LIKE emitente.cep
    FIELD cgc-corretor-imp	            LIKE emitente.cgc
    FIELD estado-corretor-imp	        LIKE emitente.estado
    FIELD ins-estadual-corretor-imp     LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-imp    LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-imp     LIKE emitente.caixa-postal
    FIELD e-mail-corretor-imp	        LIKE emitente.e-mail
    FIELD cod-aba-corretor-imp	        LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-imp	    LIKE emitente.telefone[1]
    FIELD telefone2-corretor-imp	    LIKE emitente.telefone[2]
    FIELD ramal1-corretor-imp	        LIKE emitente.ramal[1]
    FIELD ramal2-corretor-imp	        LIKE emitente.ramal[2]
    FIELD home-page-corretor-imp	    LIKE emitente.home-page
    FIELD telefax-corretor-imp	        LIKE emitente.telefax
    FIELD ramal-fax-corretor-imp	    LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-imp	    LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-imp	    LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-imp	    LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-imp	    LIKE emitente.ramal-modem
    FIELD desc-banco                    LIKE banco.nome-banco
    FIELD ag-banco                      LIKE banco.ag-padrao
    FIELD desc-agencia	                LIKE agencia.nome
    FIELD nome-consig	                LIKE emitente.nome-emit
    FIELD endereco-consig	            LIKE emitente.endereco
    FIELD bairro-consig	                LIKE emitente.bairro
    FIELD cidade-consig	                LIKE emitente.cidade
    FIELD pais-consig	                LIKE emitente.pais
    FIELD cep-consig	                LIKE emitente.cep
    FIELD cgc-consig	                LIKE emitente.cgc
    FIELD estado-consig	                LIKE emitente.estado
    FIELD ins-estadual-consig           LIKE emitente.ins-estadual
    FIELD ins-municipal-consig          LIKE emitente.ins-municipal
    FIELD caixa-postal-consig           LIKE emitente.caixa-postal
    FIELD e-mail-consig	                LIKE emitente.e-mail
    FIELD cod-aba-consig	            LIKE emitente-cex.cod-aba
    FIELD telefone1-consig	            LIKE emitente.telefone[1]
    FIELD telefone2-consig	            LIKE emitente.telefone[2]
    FIELD ramal1-consig	                LIKE emitente.ramal[1]
    FIELD ramal2-consig	                LIKE emitente.ramal[2]
    FIELD home-page-consig	            LIKE emitente.home-page
    FIELD telefax-consig	            LIKE emitente.telefax
    FIELD ramal-fax-consig	            LIKE emitente.ramal-fax
    FIELD telef-fac-consig              LIKE emitente.telef-fac
    FIELD ramal-fac-consig              LIKE emitente.ramal-fac
    FIELD telef-modem-consig            LIKE emitente.telef-modem
    FIELD ramal-modem-consig            LIKE emitente.ramal-modem
    FIELD nome-estab-fis	            LIKE estabelec.nome
    FIELD endereco-estab-fis	        LIKE estabelec.endereco
    FIELD bairro-estab-fis	            LIKE estabelec.bairro
    FIELD cidade-estab-fis	            LIKE estabelec.cidade
    FIELD pais-estab-fis	            LIKE estabelec.pais
    FIELD cep-estab-fis	                LIKE estabelec.cep
    FIELD cgc-estab-fis	                LIKE estabelec.cgc
    FIELD estado-estab-fis	            LIKE estabelec.estado
    FIELD ins-estadual-estab-fis        LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-fis       LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-fis         LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-fis	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-fis	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-fis	    LIKE emitente.endereco
    FIELD bairro-emit-estab-fis	        LIKE emitente.bairro
    FIELD cidade-emit-estab-fis	        LIKE emitente.cidade
    FIELD pais-emit-estab-fis	        LIKE emitente.pais
    FIELD cep-emit-estab-fis	        LIKE emitente.cep
    FIELD cgc-emit-estab-fis	        LIKE emitente.cgc
    FIELD estado-emit-estab-fis	        LIKE emitente.estado
    FIELD ins-estadual-emit-estab-fis   LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-fis  LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-fis   LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-fis	        LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-fis	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-fis	    LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-fis	    LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-fis	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-fis	        LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-fis	    LIKE emitente.home-page
    FIELD telefax-emit-estab-fis	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-fis	    LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-fis	    LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-fis	    LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-fis    LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-fis    LIKE emitente.ramal-modem
    FIELD pto-despacho	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-despacho	            LIKE pto-contr.descricao                
    FIELD data-prev-despacho            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-despacho            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-despacho        LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-despacho	                LIKE pto-contr.unid-referencial        
    FIELD pto-embarque	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-embarque	            LIKE pto-contr.descricao                
    FIELD data-prev-embarque            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-embarque            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-embarque        LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-embarque	                LIKE pto-contr.unid-referencial        
    FIELD pto-nacionaliz	            LIKE historico-embarque.cod-pto-contr    
    FIELD desc-pto-nacionaliz           LIKE pto-contr.descricao                 
    FIELD data-prev-nacionaliz          LIKE historico-embarque.dt-previsao      
    FIELD data-efet-nacionaliz          LIKE historico-embarque.dt-efetiva       
    FIELD data-ult-prev-nacionaliz      LIKE historico-embarque.dt-ult-previsao  
    FIELD ufr-nacionaliz	            LIKE pto-contr.unid-referencial        
    FIELD pto-chegada	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-chegada	            LIKE pto-contr.descricao                
    FIELD data-prev-chegada	            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-chegada	            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-chegada         LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-chegada	                LIKE pto-contr.unid-referencial
    field peso-liquido-total-ped            as decimal format ">>>>>,>>>,>>9.99999"
    field peso-bruto-total-ped              as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-liq-total-ped-mo-cor   as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-liq-total-ped-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field prc-fornec-bru-total-ped-mo-cor   as decimal format ">>>>>,>>>,>>9.99999"
    field prc-interno-bru-total-ped-mo-cor  as decimal format ">>>>>,>>>,>>9.99999"
    field ocupacao-total-ped                as decimal format ">>>>>,>>>,>>9.99999"
    field quantidade-total-ped              as decimal format ">>>>>,>>>,>>9.99999"
    field qt-do-forn-total-ped              as decimal format ">>>>>,>>>,>>9.99999"
    field qt-estatistica-total-ped          as decimal format ">>>>>,>>>,>>9.99999"
    index pedido-compr-emb-aux3 is unique primary
          cod-estabel
          embarque   
          num-pedido.

DEFINE TEMP-TABLE tt-processo-imp NO-UNDO
    FIELD nr-proc-imp                   LIKE processo-imp.nr-proc-imp
    FIELD r-rowid                       AS ROWID
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid-pedido                AS ROWID
    FIELD num-ped-benef	                LIKE pedido-compr.num-pedido
    FIELD data-pedido	                LIKE pedido-compr.data-pedido
    FIELD desc-situacao	                AS CHARACTER FORMAT "X(12)"
    FIELD cod-emitente                  LIKE pedido-compr.cod-emitente
    FIELD end-entrega                   LIKE pedido-compr.end-entrega
    FIELD end-cobranca                  LIKE pedido-compr.end-cobranca
    FIELD cod-cond-pag                  LIKE pedido-compr.cod-cond-pag
    FIELD cod-mens-ped                  LIKE pedido-compr.cod-mensagem
    FIELD comentarios	                LIKE pedido-compr.comentarios
    FIELD compl-entrega	                LIKE pedido-compr.compl-entrega
    FIELD cod-estabel-gestor            LIKE pedido-compr.cod-estabel
    FIELD cod-emit-terc	                LIKE pedido-compr.cod-emit-terc
    FIELD nome-emit-entr	            LIKE emitente.nome-emit
    FIELD endereco-emit-entr            LIKE emitente.endereco
    FIELD bairro-emit-entr	            LIKE emitente.bairro
    FIELD cidade-emit-entr	            LIKE emitente.cidade
    FIELD pais-emit-entr	            LIKE emitente.pais
    FIELD cep-emit-entr	                LIKE emitente.cep
    FIELD cgc-emit-entr	                LIKE emitente.cgc
    FIELD estado-emit-entr	            LIKE emitente.estado
    FIELD ins-estadual-emit-entr        LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-entr       LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-entr        LIKE emitente.caixa-postal
    FIELD e-mail-emit-entr	            LIKE emitente.e-mail
    FIELD cod-aba-emit-entr	            LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-entr	        LIKE emitente.telefone[1]
    FIELD telefone2-emit-entr	        LIKE emitente.telefone[2]
    FIELD ramal1-emit-entr	            LIKE emitente.ramal[1]
    FIELD ramal2-emit-entr	            LIKE emitente.ramal[2]
    FIELD home-page-emit-entr	        LIKE emitente.home-page
    FIELD telefax-emit-entr	            LIKE emitente.telefax
    FIELD ramal-fax-emit-entr	        LIKE emitente.ramal-fax
    FIELD telef-fac-emit-entr	        LIKE emitente.telef-fac
    FIELD ramal-fac-emit-entr	        LIKE emitente.ramal-fac
    FIELD telef-modem-emit-entr         LIKE emitente.telef-modem
    FIELD ramal-modem-emit-entr         LIKE emitente.ramal-modem
    FIELD nome-estab-entr	            LIKE estabelec.nome
    FIELD endereco-estab-entr	        LIKE estabelec.endereco
    FIELD bairro-estab-entr	            LIKE estabelec.bairro
    FIELD cidade-estab-entr	            LIKE estabelec.cidade
    FIELD pais-estab-entr	            LIKE estabelec.pais
    FIELD cep-estab-entr	            LIKE estabelec.cep
    FIELD cgc-estab-entr	            LIKE estabelec.cgc
    FIELD estado-estab-entr	            LIKE estabelec.estado
    FIELD ins-estadual-estab-entr       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-entr      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-entr        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-entr	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-entr	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-entr      LIKE emitente.endereco
    FIELD bairro-emit-estab-entr        LIKE emitente.bairro
    FIELD cidade-emit-estab-entr        LIKE emitente.cidade
    FIELD pais-emit-estab-entr          LIKE emitente.pais
    FIELD cep-emit-estab-entr	        LIKE emitente.cep
    FIELD cgc-emit-estab-entr	        LIKE emitente.cgc
    FIELD estado-emit-estab-entr        LIKE emitente.estado
    FIELD ins-estadual-emit-estab-entr	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-entr LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-entr  LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-entr	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-entr	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-entr     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-entr     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-entr	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-entr        LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-entr     LIKE emitente.home-page
    FIELD telefax-emit-estab-entr	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-entr     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-entr     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-entr     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-entr   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-entr   LIKE emitente.ramal-modem
    FIELD nome-estab-cobr	            LIKE estabelec.nome
    FIELD endereco-estab-cobr           LIKE estabelec.endereco
    FIELD bairro-estab-cobr             LIKE estabelec.bairro
    FIELD cidade-estab-cobr             LIKE estabelec.cidade
    FIELD cod-estabel                   LIKE processo-imp.cod-estabel
    index processo-imp is unique primary
          cod-estabel
          nr-proc-imp.

DEFINE TEMP-TABLE tt-processo-imp-aux NO-UNDO
    FIELD cod-estabel                   LIKE processo-imp.cod-estabel
    FIELD nr-proc-imp                   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid                       AS ROWID
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD pais-estab-cobr	            LIKE estabelec.pais
    FIELD cep-estab-cobr	            LIKE estabelec.cep
    FIELD cgc-estab-cobr	            LIKE estabelec.cgc
    FIELD estado-estab-cobr             LIKE estabelec.estado
    FIELD ins-estadual-estab-cobr       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-cobr      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-cobr        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-cobr	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-cobr	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-cobr	    LIKE emitente.endereco
    FIELD bairro-emit-estab-cobr	    LIKE emitente.bairro
    FIELD cidade-emit-estab-cobr	    LIKE emitente.cidade
    FIELD pais-emit-estab-cobr	        LIKE emitente.pais
    FIELD cep-emit-estab-cobr	        LIKE emitente.cep
    FIELD cgc-emit-estab-cobr	        LIKE emitente.cgc
    FIELD estado-emit-estab-cobr	    LIKE emitente.estado
    FIELD ins-estadual-emit-estab-cobr	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-cobr	LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-cobr  LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-cobr	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-cobr	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-cobr     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-cobr     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-cobr	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-cobr	    LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-cobr     LIKE emitente.home-page
    FIELD telefax-emit-estab-cobr	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-cobr     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-cobr     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-cobr     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-cobr   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-cobr   LIKE emitente.ramal-modem
    FIELD nome-estab-gest	            LIKE estabelec.nome
    FIELD endereco-estab-gest	        LIKE estabelec.endereco
    FIELD bairro-estab-gest	            LIKE estabelec.bairro
    FIELD cidade-estab-gest	            LIKE estabelec.cidade
    FIELD pais-estab-gest	            LIKE estabelec.pais
    FIELD cep-estab-gest	            LIKE estabelec.cep
    FIELD cgc-estab-gest	            LIKE estabelec.cgc
    FIELD estado-estab-gest	            LIKE estabelec.estado
    FIELD ins-estadual-estab-gest       LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-gest      LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-gest        LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-gest	        LIKE estabelec.cod-emitente 
    FIELD nome-emit-estab-gest	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-gest	    LIKE emitente.endereco
    FIELD bairro-emit-estab-gest	    LIKE emitente.bairro
    FIELD cidade-emit-estab-gest	    LIKE emitente.cidade
    FIELD pais-emit-estab-gest	        LIKE emitente.pais
    FIELD cep-emit-estab-gest	        LIKE emitente.cep
    FIELD cgc-emit-estab-gest	        LIKE emitente.cgc
    FIELD estado-emit-estab-gest	    LIKE emitente.estado
    FIELD ins-estadual-emit-estab-gest	LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-gest LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-gest	LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-gest	    LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-gest	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-gest     LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-gest     LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-gest	    LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-gest	    LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-gest     LIKE emitente.home-page
    FIELD telefax-emit-estab-gest	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-gest     LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-gest     LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-gest     LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-gest   LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-gest   LIKE emitente.ramal-modem
    FIELD desc-cond-pagto               LIKE cond-pagto.descricao
    FIELD desc-mensagem-ped             LIKE mensagem.descricao
    FIELD texto-mensag-ped	            LIKE mensagem.texto-mensag 
    FIELD cod-itiner	                LIKE processo-imp.cod-itiner
    FIELD dt-emissao	                LIKE processo-imp.dt-emissao
    FIELD dt-implantacao                LIKE processo-imp.dt-implantacao
    FIELD dt-autorizacao	            LIKE processo-imp.dt-autorizacao
    FIELD cod-despachante	            LIKE processo-imp.cod-despachante
    FIELD cod-exportador	            LIKE processo-imp.cod-exportador
    FIELD cod-consignatario	            LIKE processo-imp.cod-consignatario
    FIELD cod-transportador	            LIKE processo-imp.cod-transportador
    FIELD cod-estabel-proc              LIKE processo-imp.cod-estabel
    FIELD carta-credito	                LIKE processo-imp.carta-credito
    FIELD narrativa                     LIKE processo-imp.narrativa
    FIELD cod-banco	                    LIKE processo-imp.cod-banco
    FIELD nr-rof	                    LIKE processo-imp.nr-rof
    FIELD desc-via-transp	            AS CHARACTER FORMAT "X(16)"
    FIELD estab-fisc	                LIKE processo-imp.estab-fisc
    FIELD contrato-cambio	            LIKE processo-imp.contrato-cambio
    FIELD cod-idioma	                LIKE processo-imp.cod-idioma
    FIELD situacao-proc-imp	            AS CHARACTER FORMAT "X(16)"
    FIELD cod-agente	                LIKE processo-imp.cod-agente
    FIELD cod-mens-proc-imp	            LIKE processo-imp.cod-mensagem
    FIELD texto-mens-proc-imp	        LIKE processo-imp.texto-mensag
    FIELD destino-documentacao	        LIKE processo-imp.destino-documentacao
    FIELD cdn-corretor-cambio-import    LIKE processo-imp.cdn-corretor-cambio-import
    FIELD cdn-despa-exter-import	    LIKE processo-imp.cdn-despa-exter-import
    FIELD cdn-segurad-import	        LIKE processo-imp.cdn-segurad-import
    FIELD cdn-corretor-import	        LIKE processo-imp.cdn-corretor-import
    FIELD nome-import	                LIKE estabelec.nome
    FIELD endereco-import               LIKE estabelec.endereco
    FIELD bairro-import	                LIKE estabelec.bairro
    FIELD cidade-import	                LIKE estabelec.cidade
    FIELD pais-import	                LIKE estabelec.pais
    FIELD cep-import	                LIKE estabelec.cep
    FIELD cgc-import	                LIKE estabelec.cgc
    FIELD estado-import	                LIKE estabelec.estado
    FIELD ins-estadual-import           LIKE estabelec.ins-estadual
    FIELD ins-municipal-import          LIKE estabelec.ins-municipal
    FIELD cod-suframa-import            LIKE estabelec.cod-suframa
    FIELD cod-emit-import	            LIKE estabelec.cod-emitente
    index processo-imp-aux is unique primary
          cod-estabel
          nr-proc-imp.
    

DEFINE TEMP-TABLE tt-processo-imp-aux2 NO-UNDO
    FIELD cod-estabel                   LIKE processo-imp.cod-estabel
    FIELD nr-proc-imp                   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD r-rowid                       AS ROWID
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD nome-emit-import	            LIKE emitente.nome-emit
    FIELD endereco-emit-import          LIKE emitente.endereco
    FIELD bairro-emit-import            LIKE emitente.bairro
    FIELD cidade-emit-import            LIKE emitente.cidade
    FIELD pais-emit-import              LIKE emitente.pais
    FIELD cep-emit-import               LIKE emitente.cep
    FIELD cgc-emit-import               LIKE emitente.cgc
    FIELD estado-emit-import            LIKE emitente.estado
    FIELD ins-estadual-emit-import      LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-import     LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-import      LIKE emitente.caixa-postal
    FIELD e-mail-emit-import	        LIKE emitente.e-mail
    FIELD cod-aba-emit-import	        LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-import         LIKE emitente.telefone[1]
    FIELD telefone2-emit-import         LIKE emitente.telefone[2]
    FIELD ramal1-emit-import	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-import	        LIKE emitente.ramal[2]
    FIELD home-page-emit-import         LIKE emitente.home-page
    FIELD telefax-emit-import	        LIKE emitente.telefax
    FIELD ramal-fax-emit-import         LIKE emitente.ramal-fax
    FIELD telef-fac-emit-import         LIKE emitente.telef-fac
    FIELD ramal-fac-emit-import         LIKE emitente.ramal-fac
    FIELD telef-modem-emit-import       LIKE emitente.telef-modem
    FIELD ramal-modem-emit-import       LIKE emitente.ramal-modem
    FIELD nome-emit-export	            LIKE emitente.nome-emit
    FIELD endereco-emit-export          LIKE emitente.endereco
    FIELD bairro-emit-export            LIKE emitente.bairro
    FIELD cidade-emit-export            LIKE emitente.cidade
    FIELD pais-emit-export              LIKE emitente.pais
    FIELD cep-emit-export               LIKE emitente.cep
    FIELD cgc-emit-export               LIKE emitente.cgc
    FIELD estado-emit-export	        LIKE emitente.estado
    FIELD ins-estadual-emit-export      LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-export     LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-export      LIKE emitente.caixa-postal
    FIELD e-mail-emit-export	        LIKE emitente.e-mail
    FIELD cod-aba-emit-export	        LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-export         LIKE emitente.telefone[1]
    FIELD telefone2-emit-export         LIKE emitente.telefone[2]
    FIELD ramal1-emit-export	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-export	        LIKE emitente.ramal[2]
    FIELD home-page-emit-export         LIKE emitente.home-page
    FIELD telefax-emit-export	        LIKE emitente.telefax
    FIELD ramal-fax-emit-export         LIKE emitente.ramal-fax
    FIELD telef-fac-emit-export         LIKE emitente.telef-fac
    FIELD ramal-fac-emit-export         LIKE emitente.ramal-fac
    FIELD telef-modem-emit-export       LIKE emitente.telef-modem
    FIELD ramal-modem-emit-export       LIKE emitente.ramal-modem
    FIELD desc-incoterm                 LIKE inco-cx.descricao
    FIELD cod-incoterm                  LIKE inco-cx.cod-incoterm
    FIELD desc-itner                    LIKE itinerario.descricao
    FIELD distancia	                    LIKE itinerario.distancia
    FIELD nr-dias	                    LIKE itinerario.nr-dias
    FIELD narrat-itiner                 LIKE itinerario.narrativa
    FIELD desc-mensagem-proc            LIKE mensagem.descricao
    FIELD texto-mensag-proc             LIKE mensagem.texto-mensag
    FIELD nome-transp	                LIKE transporte.nome
    FIELD nome-abrev-transp	            LIKE transporte.nome-abrev
    FIELD endereco-transp	            LIKE transporte.endereco
    FIELD bairro-transp	                LIKE transporte.bairro
    FIELD cidade-transp	                LIKE transporte.cidade
    FIELD pais-transp	                LIKE transporte.pais
    FIELD cep-transp	                LIKE transporte.cep
    FIELD cgc-transp	                LIKE transporte.cgc
    FIELD estado-transp	                LIKE transporte.estado
    FIELD ins-estadual-transp           LIKE transporte.ins-estadual
    FIELD caixa-postal-transp           LIKE transporte.cx-postal
    FIELD contato-transp	            LIKE transporte.contato
    FIELD telefone-transp	            LIKE transporte.telefone
    FIELD ramal-transp	                LIKE transporte.ramal
    FIELD telefax-transp	            LIKE transporte.telefax
    FIELD telex-transp	                LIKE transporte.telex
    FIELD ins-municipal-transp          LIKE transporte.ins-municipal
    FIELD zip-code-transp	            LIKE transporte.zip-code
    FIELD e-mail-transp	                LIKE transporte.e-mail
    FIELD telef-modem-transp            LIKE transporte.telef-modem
    FIELD home-page-transp	            LIKE transporte.home-page
    FIELD ramal-modem-transp            LIKE transporte.ramal-modem
    FIELD ramal-fax-transp	            LIKE transporte.ramal-fax
    FIELD nome-despach-ext	            LIKE emitente.nome-emit
    FIELD endereco-despach-ext	        LIKE emitente.endereco
    FIELD bairro-despach-ext	        LIKE emitente.bairro
    FIELD cidade-despach-ext	        LIKE emitente.cidade
    FIELD pais-despach-ext	            LIKE emitente.pais
    FIELD cep-despach-ext	            LIKE emitente.cep
    FIELD cgc-despach-ext	            LIKE emitente.cgc
    FIELD estado-despach-ext	        LIKE emitente.estado
    FIELD ins-estadual-despach-ext	    LIKE emitente.ins-estadual
    FIELD ins-municipal-despach-ext     LIKE emitente.ins-municipal
    FIELD caixa-postal-despach-ext      LIKE emitente.caixa-postal
    FIELD e-mail-despach-ext	        LIKE emitente.e-mail
    FIELD cod-aba-despach-ext	        LIKE emitente-cex.cod-aba
    FIELD telefone1-despach-ext         LIKE emitente.telefone[1]
    FIELD telefone2-despach-ext         LIKE emitente.telefone[2]
    FIELD ramal1-despach-ext	        LIKE emitente.ramal[1]
    FIELD ramal2-despach-ext	        LIKE emitente.ramal[2]
    FIELD home-page-despach-ext         LIKE emitente.home-page
    FIELD telefax-despach-ext	        LIKE emitente.telefax
    FIELD ramal-fax-despach-ext         LIKE emitente.ramal-fax
    FIELD telef-fac-despach-ext         LIKE emitente.telef-fac
    FIELD ramal-fac-despach-ext         LIKE emitente.ramal-fac
    FIELD telef-modem-despach-ext       LIKE emitente.telef-modem
    FIELD ramal-modem-despach-ext       LIKE emitente.ramal-modem
    FIELD nome-despach	                LIKE emitente.nome-emit
    FIELD endereco-despach	            LIKE emitente.endereco
    FIELD bairro-despach	            LIKE emitente.bairro
    FIELD cidade-despach	            LIKE emitente.cidade
    FIELD pais-despach                  LIKE emitente.pais
    FIELD cep-despach                   LIKE emitente.cep
    FIELD cgc-despach                   LIKE emitente.cgc
    FIELD estado-despach	            LIKE emitente.estado
    FIELD ins-estadual-despach	        LIKE emitente.ins-estadual
    FIELD ins-municipal-despach         LIKE emitente.ins-municipal
    FIELD caixa-postal-despach          LIKE emitente.caixa-postal
    FIELD e-mail-despach	            LIKE emitente.e-mail
    FIELD cod-aba-despach	            LIKE emitente-cex.cod-aba
    FIELD telefone1-despach             LIKE emitente.telefone[1]
    FIELD telefone2-despach             LIKE emitente.telefone[2]
    FIELD ramal1-despach	            LIKE emitente.ramal[1]
    FIELD ramal2-despach	            LIKE emitente.ramal[2]
    FIELD home-page-despach             LIKE emitente.home-page
    FIELD telefax-despach	            LIKE emitente.telefax
    FIELD ramal-fax-despach             LIKE emitente.ramal-fax
    FIELD telef-fac-despach             LIKE emitente.telef-fac
    FIELD ramal-fac-despach             LIKE emitente.ramal-fac
    FIELD telef-modem-despach           LIKE emitente.telef-modem
    FIELD ramal-modem-despach           LIKE emitente.ramal-modem
    FIELD nome-agente	                LIKE emitente.nome-emit
    FIELD endereco-agente	            LIKE emitente.endereco
    FIELD bairro-agente	                LIKE emitente.bairro
    FIELD cidade-agente	                LIKE emitente.cidade
    FIELD pais-agente	                LIKE emitente.pais
    FIELD cep-agente	                LIKE emitente.cep
    FIELD cgc-agente	                LIKE emitente.cgc
    FIELD estado-agente	                LIKE emitente.estado
    FIELD ins-estadual-agente           LIKE emitente.ins-estadual
    FIELD ins-municipal-agente          LIKE emitente.ins-municipal
    FIELD caixa-postal-agente           LIKE emitente.caixa-postal
    FIELD e-mail-agente	                LIKE emitente.e-mail
    FIELD cod-aba-agente	            LIKE emitente-cex.cod-aba
    FIELD telefone1-agente	            LIKE emitente.telefone[1]
    FIELD telefone2-agente	            LIKE emitente.telefone[2]
    FIELD ramal1-agente	                LIKE emitente.ramal[1]
    FIELD ramal2-agente	                LIKE emitente.ramal[2]
    FIELD home-page-agente	            LIKE emitente.home-page
    FIELD telefax-agente	            LIKE emitente.telefax
    FIELD ramal-fax-agente	            LIKE emitente.ramal-fax
    FIELD telef-fac-agente	            LIKE emitente.telef-fac
    FIELD ramal-fac-agente	            LIKE emitente.ramal-fac
    FIELD telef-modem-agente	        LIKE emitente.telef-modem
    FIELD ramal-modem-agente	        LIKE emitente.ramal-modem
    FIELD nome-corretor-cam	            LIKE emitente.nome-emit
    FIELD endereco-corretor-cam	        LIKE emitente.endereco
    FIELD bairro-corretor-cam	        LIKE emitente.bairro
    FIELD cidade-corretor-cam	        LIKE emitente.cidade
    FIELD pais-corretor-cam	            LIKE emitente.pais
    FIELD cep-corretor-cam	            LIKE emitente.cep
    FIELD cgc-corretor-cam	            LIKE emitente.cgc
    FIELD estado-corretor-cam	        LIKE emitente.estado
    FIELD ins-estadual-corretor-cam     LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-cam    LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-cam     LIKE emitente.caixa-postal
    FIELD e-mail-corretor-cam	        LIKE emitente.e-mail
    FIELD cod-aba-corretor-cam	        LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-cam        LIKE emitente.telefone[1]
    FIELD telefone2-corretor-cam        LIKE emitente.telefone[2]
    FIELD ramal1-corretor-cam	        LIKE emitente.ramal[1]
    FIELD ramal2-corretor-cam           LIKE emitente.ramal[2]
    FIELD home-page-corretor-cam        LIKE emitente.home-page
    FIELD telefax-corretor-cam	        LIKE emitente.telefax
    FIELD ramal-fax-corretor-cam        LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-cam        LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-cam        LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-cam      LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-cam      LIKE emitente.ramal-modem
    FIELD nome-segurad	                LIKE emitente.nome-emit
    FIELD endereco-segurad	            LIKE emitente.endereco
    FIELD bairro-segurad	            LIKE emitente.bairro
    FIELD cidade-segurad	            LIKE emitente.cidade
    FIELD pais-segurad	                LIKE emitente.pais
    FIELD cep-segurad	                LIKE emitente.cep
    FIELD cgc-segurad	                LIKE emitente.cgc
    FIELD estado-segurad	            LIKE emitente.estado
    FIELD ins-estadual-segurad	        LIKE emitente.ins-estadual
    FIELD ins-municipal-segurad         LIKE emitente.ins-municipal
    FIELD caixa-postal-segurad          LIKE emitente.caixa-postal
    FIELD e-mail-segurad	            LIKE emitente.e-mail
    FIELD cod-aba-segurad	            LIKE emitente-cex.cod-aba
    FIELD telefone1-segurad             LIKE emitente.telefone[1]
    FIELD telefone2-segurad             LIKE emitente.telefone[2]
    FIELD ramal1-segurad	            LIKE emitente.ramal[1]
    FIELD ramal2-segurad	            LIKE emitente.ramal[2]
    FIELD home-page-segurad             LIKE emitente.home-page
    FIELD telefax-segurad	            LIKE emitente.telefax
    FIELD ramal-fax-segurad             LIKE emitente.ramal-fax
    FIELD telef-fac-segurad             LIKE emitente.telef-fac
    FIELD ramal-fac-segurad             LIKE emitente.ramal-fac
    FIELD telef-modem-segurad           LIKE emitente.telef-modem
    FIELD ramal-modem-segurad           LIKE emitente.ramal-modem
    index processo-imp-aux2 is unique primary
          cod-estabel
          nr-proc-imp.
    
DEFINE TEMP-TABLE tt-processo-imp-aux3 NO-UNDO
    FIELD cod-estabel                   LIKE processo-imp.cod-estabel
    FIELD nr-proc-imp                   LIKE processo-imp.nr-proc-imp
    FIELD embarque                      LIKE embarque-imp.embarque
    FIELD r-rowid                       AS ROWID
    FIELD num-pedido                    LIKE pedido-compr.num-pedido
    FIELD nome-corretor-imp	            LIKE emitente.nome-emit
    FIELD endereco-corretor-imp	        LIKE emitente.endereco
    FIELD bairro-corretor-imp	        LIKE emitente.bairro
    FIELD cidade-corretor-imp	        LIKE emitente.cidade
    FIELD pais-corretor-imp	            LIKE emitente.pais
    FIELD cep-corretor-imp	            LIKE emitente.cep
    FIELD cgc-corretor-imp	            LIKE emitente.cgc
    FIELD estado-corretor-imp	        LIKE emitente.estado
    FIELD ins-estadual-corretor-imp     LIKE emitente.ins-estadual
    FIELD ins-municipal-corretor-imp    LIKE emitente.ins-municipal
    FIELD caixa-postal-corretor-imp     LIKE emitente.caixa-postal
    FIELD e-mail-corretor-imp	        LIKE emitente.e-mail
    FIELD cod-aba-corretor-imp	        LIKE emitente-cex.cod-aba
    FIELD telefone1-corretor-imp	    LIKE emitente.telefone[1]
    FIELD telefone2-corretor-imp	    LIKE emitente.telefone[2]
    FIELD ramal1-corretor-imp	        LIKE emitente.ramal[1]
    FIELD ramal2-corretor-imp	        LIKE emitente.ramal[2]
    FIELD home-page-corretor-imp	    LIKE emitente.home-page
    FIELD telefax-corretor-imp	        LIKE emitente.telefax
    FIELD ramal-fax-corretor-imp	    LIKE emitente.ramal-fax
    FIELD telef-fac-corretor-imp	    LIKE emitente.telef-fac
    FIELD ramal-fac-corretor-imp	    LIKE emitente.ramal-fac
    FIELD telef-modem-corretor-imp	    LIKE emitente.telef-modem
    FIELD ramal-modem-corretor-imp	    LIKE emitente.ramal-modem
    FIELD desc-banco                    LIKE banco.nome-banco
    FIELD ag-banco                      LIKE banco.ag-padrao
    FIELD desc-agencia	                LIKE agencia.nome
    FIELD nome-consig	                LIKE emitente.nome-emit
    FIELD endereco-consig	            LIKE emitente.endereco
    FIELD bairro-consig	                LIKE emitente.bairro
    FIELD cidade-consig	                LIKE emitente.cidade
    FIELD pais-consig	                LIKE emitente.pais
    FIELD cep-consig	                LIKE emitente.cep
    FIELD cgc-consig	                LIKE emitente.cgc
    FIELD estado-consig	                LIKE emitente.estado
    FIELD ins-estadual-consig           LIKE emitente.ins-estadual
    FIELD ins-municipal-consig          LIKE emitente.ins-municipal
    FIELD caixa-postal-consig           LIKE emitente.caixa-postal
    FIELD e-mail-consig	                LIKE emitente.e-mail
    FIELD cod-aba-consig	            LIKE emitente-cex.cod-aba
    FIELD telefone1-consig	            LIKE emitente.telefone[1]
    FIELD telefone2-consig	            LIKE emitente.telefone[2]
    FIELD ramal1-consig	                LIKE emitente.ramal[1]
    FIELD ramal2-consig	                LIKE emitente.ramal[2]
    FIELD home-page-consig	            LIKE emitente.home-page
    FIELD telefax-consig	            LIKE emitente.telefax
    FIELD ramal-fax-consig	            LIKE emitente.ramal-fax
    FIELD telef-fac-consig              LIKE emitente.telef-fac
    FIELD ramal-fac-consig              LIKE emitente.ramal-fac
    FIELD telef-modem-consig            LIKE emitente.telef-modem
    FIELD ramal-modem-consig            LIKE emitente.ramal-modem
    FIELD nome-estab-fis	            LIKE estabelec.nome
    FIELD endereco-estab-fis	        LIKE estabelec.endereco
    FIELD bairro-estab-fis	            LIKE estabelec.bairro
    FIELD cidade-estab-fis	            LIKE estabelec.cidade
    FIELD pais-estab-fis	            LIKE estabelec.pais
    FIELD cep-estab-fis	                LIKE estabelec.cep
    FIELD cgc-estab-fis	                LIKE estabelec.cgc
    FIELD estado-estab-fis	            LIKE estabelec.estado
    FIELD ins-estadual-estab-fis        LIKE estabelec.ins-estadual
    FIELD ins-municipal-estab-fis       LIKE estabelec.ins-municipal
    FIELD cod-suframa-estab-fis         LIKE estabelec.cod-suframa
    FIELD cod-emit-estab-fis	        LIKE estabelec.cod-emitente
    FIELD nome-emit-estab-fis	        LIKE emitente.nome-emit
    FIELD endereco-emit-estab-fis	    LIKE emitente.endereco
    FIELD bairro-emit-estab-fis	        LIKE emitente.bairro
    FIELD cidade-emit-estab-fis	        LIKE emitente.cidade
    FIELD pais-emit-estab-fis	        LIKE emitente.pais
    FIELD cep-emit-estab-fis	        LIKE emitente.cep
    FIELD cgc-emit-estab-fis	        LIKE emitente.cgc
    FIELD estado-emit-estab-fis	        LIKE emitente.estado
    FIELD ins-estadual-emit-estab-fis   LIKE emitente.ins-estadual
    FIELD ins-municipal-emit-estab-fis  LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-estab-fis   LIKE emitente.caixa-postal
    FIELD e-mail-emit-estab-fis	        LIKE emitente.e-mail
    FIELD cod-aba-emit-estab-fis	    LIKE emitente-cex.cod-aba
    FIELD telefone1-emit-estab-fis	    LIKE emitente.telefone[1]
    FIELD telefone2-emit-estab-fis	    LIKE emitente.telefone[2]
    FIELD ramal1-emit-estab-fis	        LIKE emitente.ramal[1]
    FIELD ramal2-emit-estab-fis	        LIKE emitente.ramal[2]
    FIELD home-page-emit-estab-fis	    LIKE emitente.home-page
    FIELD telefax-emit-estab-fis	    LIKE emitente.telefax
    FIELD ramal-fax-emit-estab-fis	    LIKE emitente.ramal-fax
    FIELD telef-fac-emit-estab-fis	    LIKE emitente.telef-fac
    FIELD ramal-fac-emit-estab-fis	    LIKE emitente.ramal-fac
    FIELD telef-modem-emit-estab-fis    LIKE emitente.telef-modem
    FIELD ramal-modem-emit-estab-fis    LIKE emitente.ramal-modem
    FIELD pto-despacho	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-despacho	            LIKE pto-contr.descricao                
    FIELD data-prev-despacho            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-despacho            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-despacho        LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-despacho	                LIKE pto-contr.unid-referencial        
    FIELD pto-embarque	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-embarque	            LIKE pto-contr.descricao                
    FIELD data-prev-embarque            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-embarque            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-embarque        LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-embarque	                LIKE pto-contr.unid-referencial        
    FIELD pto-nacionaliz	            LIKE historico-embarque.cod-pto-contr    
    FIELD desc-pto-nacionaliz           LIKE pto-contr.descricao                 
    FIELD data-prev-nacionaliz          LIKE historico-embarque.dt-previsao      
    FIELD data-efet-nacionaliz          LIKE historico-embarque.dt-efetiva       
    FIELD data-ult-prev-nacionaliz      LIKE historico-embarque.dt-ult-previsao  
    FIELD ufr-nacionaliz	            LIKE pto-contr.unid-referencial        
    FIELD pto-chegada	                LIKE historico-embarque.cod-pto-contr   
    FIELD desc-pto-chegada	            LIKE pto-contr.descricao                
    FIELD data-prev-chegada	            LIKE historico-embarque.dt-previsao     
    FIELD data-efet-chegada	            LIKE historico-embarque.dt-efetiva      
    FIELD data-ult-prev-chegada         LIKE historico-embarque.dt-ult-previsao 
    FIELD ufr-chegada	                LIKE pto-contr.unid-referencial
    field peso-liquido-total-ped            as decimal format ">>>>>,>>>,>>9.99999"
    field peso-bruto-total-ped              as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-fornec-liq-total-ped-mo-cor   as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-liq-total-ped-mo-cor  as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-fornec-bru-total-ped-mo-cor   as decimal format ">>>>>,>>>,>>9.99999" 
    field prc-interno-bru-total-ped-mo-cor  as decimal format ">>>>>,>>>,>>9.99999" 
    field ocupacao-total-ped                as decimal format ">>>>>,>>>,>>9.99999" 
    field quantidade-total-ped              as decimal format ">>>>>,>>>,>>9.99999" 
    field qt-do-forn-total-ped              as decimal format ">>>>>,>>>,>>9.99999" 
    field qt-estatistica-total-ped          as decimal format ">>>>>,>>>,>>9.99999"
    index processo-imp-aux3 is unique primary
          cod-estabel
          nr-proc-imp.
