{include/i_dbvers.i}
/*******************************************************************************
**
**     IM0640.I - Definicao de variaveis.
**
*******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                  AS INTEGER
    FIELD arquivo                  AS CHARACTE  FORMAT "x(35)":U
    FIELD usuario                  AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec                AS DATE
    FIELD hora-exec                AS INTEGER
    FIELD classifica               AS INTEGER
    FIELD desc-classifica          AS CHARACTER FORMAT "X(40)":U
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD c-cod-estabel-ini        AS CHARACTER format "x(05)"
&ELSE
    FIELD c-cod-estabel-ini        AS CHARACTER FORMAT "X(03)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD c-cod-estabel-fim        AS CHARACTER format "x(05)"
&ELSE
    FIELD c-cod-estabel-fim        AS CHARACTER FORMAT "X(03)"
&ENDIF
    FIELD c-nr-proc-imp-ini        AS CHARACTER FORMAT "X(12)"
    FIELD c-nr-proc-imp-fim        AS CHARACTER FORMAT "X(12)"
    FIELD c-embarque-ini           LIKE embarque-imp.embarque
    FIELD c-embarque-fim           LIKE embarque-imp.embarque
    FIELD i-fornecedor-ini         AS INTEGER   FORMAT ">>,>>>,>>9"
    FIELD i-fornecedor-fim         AS INTEGER   FORMAT ">>,>>>,>>9"
    FIELD dt-prevista-ini          AS DATE      FORMAT "99/99/9999"
    FIELD dt-prevista-fim          AS DATE      FORMAT "99/99/9999"
    FIELD l-envia-docto-fornecedor AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD c-arquivo-copia          AS CHARACTER FORMAT "X(100)"
    FIELD l-layout-pad-fornec      AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD c-layout-pad-fornec      AS CHARACTER FORMAT "X(60)"
    FIELD l-sobrepor               AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD c-dir-destino            AS CHARACTER FORMAT "X(80)"
    FIELD i-orientacao             AS INTEGER   FORMAT "9"
    FIELD l-traducao               AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-imprime-param          AS LOGICAL   FORMAT "Sim/NÆo".

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem                    AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo                  AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita               AS RAW.

DEFINE TEMP-TABLE tt-documentos-erros NO-UNDO
    FIELD cod-erro      AS INT
    FIELD mensagem      AS CHAR     
    FIELD erro-ajuda    AS CHARACTER
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido    LIKE pedido-compr.num-pedido
    FIELD dt-embarque   LIKE embarque.dt-embarque.

DEFINE TEMP-TABLE tt-documentos-impressos NO-UNDO
    FIELD destino       AS char
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD nr-proc-imp   LIKE processo-imp.nr-proc-imp
    FIELD num-pedido    LIKE pedido-compr.num-pedido
    FIELD dt-embarque   LIKE embarque.dt-embarque
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nome-abrev    LIKE emitente.nome-abrev.

DEFINE TEMP-TABLE tt-estabelec-aux NO-UNDO LIKE estabelec
    FIELD cod-exportador                    LIKE processo-imp.cod-exportador             
    FIELD cdn-corretor-cambio-import        LIKE processo-imp.cdn-corretor-cambio-import 
    FIELD cdn-despa-exter-import            LIKE processo-imp.cdn-despa-exter-import     
    FIELD cdn-segurad-import                LIKE processo-imp.cdn-segurad-import         
    FIELD cdn-corretor-import               LIKE processo-imp.cdn-corretor-import
    FIELD nome-import                       LIKE estabelec.nome         
    FIELD endereco-import                   LIKE estabelec.endereco     
    FIELD bairro-import                     LIKE estabelec.bairro       
    FIELD cidade-import                     LIKE estabelec.cidade       
    FIELD pais-import                       LIKE estabelec.pais         
    FIELD cep-import                        LIKE estabelec.cep          
    FIELD cgc-import                        LIKE estabelec.cgc          
    FIELD estado-import                     LIKE estabelec.estado       
    FIELD ins-estadual-import               LIKE estabelec.ins-estadual 
    FIELD ins-municipal-import              LIKE estabelec.ins-municipal
    FIELD cod-suframa-import                LIKE estabelec.cod-suframa  
    field cod-emit-import                   like estabelec.cod-emitente
    FIELD nome-emit-import                  LIKE emitente.nome-emit    
    FIELD endereco-emit-import              LIKE emitente.endereco     
    FIELD bairro-emit-import                LIKE emitente.bairro       
    FIELD cidade-emit-import                LIKE emitente.cidade       
    FIELD pais-emit-import                  LIKE emitente.pais         
    FIELD cep-emit-import                   LIKE emitente.cep          
    FIELD cgc-emit-import                   LIKE emitente.cgc          
    FIELD estado-emit-import                LIKE emitente.estado       
    FIELD ins-estadual-emit-import          LIKE emitente.ins-estadual 
    FIELD ins-municipal-emit-import         LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-import          LIKE emitente.caixa-postal 
    FIELD e-mail-emit-import                LIKE emitente.e-mail       
    FIELD cod-aba-emit-import               LIKE emitente-cex.cod-aba  
    FIELD telefone-emit-import              LIKE emitente.telefone[1]  
    FIELD telefone2-emit-import             LIKE emitente.telefone[2]  
    FIELD ramal-emit-import                 LIKE emitente.ramal[1]     
    FIELD ramal2-emit-import                LIKE emitente.ramal[2]     
    FIELD home-page-emit-import             LIKE emitente.home-page    
    FIELD telefax-emit-import               LIKE emitente.telefax      
    FIELD ramal-fax-emit-import             LIKE emitente.ramal-fax    
    FIELD telef-fac-emit-import             LIKE emitente.telef-fac    
    FIELD ramal-fac-emit-import             LIKE emitente.ramal-fac    
    FIELD telef-modem-emit-import           LIKE emitente.telef-modem  
    FIELD ramal-modem-emit-import           LIKE emitente.ramal-modem.

DEFINE TEMP-TABLE tt-exportador-aux  NO-UNDO   LIKE tt-exportador
    FIELD cod-exportador                       LIKE emitente-cex.cod-emitente
    FIELD nome-emit-export                     LIKE emitente.nome-emit    
    FIELD endereco-emit-export                 LIKE emitente.endereco     
    FIELD bairro-emit-export                   LIKE emitente.bairro       
    FIELD cidade-emit-export                   LIKE emitente.cidade       
    FIELD pais-emit-export                     LIKE emitente.pais         
    FIELD cep-emit-export                      LIKE emitente.cep          
    FIELD cgc-emit-export                      LIKE emitente.cgc          
    FIELD estado-emit-export                   LIKE emitente.estado       
    FIELD ins-estadual-emit-export             LIKE emitente.ins-estadual 
    FIELD ins-municipal-emit-export            LIKE emitente.ins-municipal
    FIELD caixa-postal-emit-export             LIKE emitente.caixa-postal 
    FIELD e-mail-emit-export                   LIKE emitente.e-mail       
    FIELD cod-aba-emit-export                  LIKE emitente-cex.cod-aba  
    FIELD telefone-emit-export                 LIKE emitente.telefone[1]  
    FIELD telefone2-emit-export                LIKE emitente.telefone[2]  
    FIELD ramal-emit-export                    LIKE emitente.ramal[1]     
    FIELD ramal2-emit-export                   LIKE emitente.ramal[2]     
    FIELD home-page-emit-export                LIKE emitente.home-page    
    FIELD telefax-emit-export                  LIKE emitente.telefax      
    FIELD ramal-fax-emit-export                LIKE emitente.ramal-fax    
    FIELD telef-fac-emit-export                LIKE emitente.telef-fac    
    FIELD ramal-fac-emit-export                LIKE emitente.ramal-fac    
    FIELD telef-modem-emit-export              LIKE emitente.telef-modem  
    FIELD ramal-modem-emit-export              LIKE emitente.ramal-modem. 

DEFINE TEMP-TABLE tt-consignatario-aux NO-UNDO LIKE emitente
    FIELD cod-consignatario                    LIKE emitente.cod-emitente
    FIELD nome-consig                          LIKE emitente.nome-emit    
    FIELD endereco-consig                      LIKE emitente.endereco     
    FIELD bairro-consig                        LIKE emitente.bairro       
    FIELD cidade-consig                        LIKE emitente.cidade       
    FIELD pais-consig                          LIKE emitente.pais         
    FIELD cep-consig                           LIKE emitente.cep          
    FIELD cgc-consig                           LIKE emitente.cgc          
    FIELD estado-consig                        LIKE emitente.estado       
    FIELD ins-estadual-consig                  LIKE emitente.ins-estadual 
    FIELD ins-municipal-consig                 LIKE emitente.ins-municipal
    FIELD caixa-postal-consig                  LIKE emitente.caixa-postal 
    FIELD e-mail-consig                        LIKE emitente.e-mail       
    FIELD cod-aba-consig                       LIKE emitente-cex.cod-aba  
    FIELD telefone-consig                      LIKE emitente.telefone[1]  
    FIELD telefone2-consig                     LIKE emitente.telefone[2]  
    FIELD ramal-consig                         LIKE emitente.ramal[1]     
    FIELD ramal2-consig                        LIKE emitente.ramal[2]     
    FIELD home-page-consig                     LIKE emitente.home-page    
    FIELD telefax-consig                       LIKE emitente.telefax      
    FIELD ramal-fax-consig                     LIKE emitente.ramal-fax    
    FIELD telef-fac-consig                     LIKE emitente.telef-fac    
    FIELD ramal-fac-consig                     LIKE emitente.ramal-fac    
    FIELD telef-modem-consig                   LIKE emitente.telef-modem  
    FIELD ramal-modem-consig                   LIKE emitente.ramal-modem . 

DEFINE TEMP-TABLE tt-agente-carga-aux NO-UNDO  LIKE emitente
    FIELD cod-agente                           LIKE emitente.cod-emitente
    FIELD nome-agente                          LIKE emitente.nome-emit     
    FIELD endereco-agente                      LIKE emitente.endereco      
    FIELD bairro-agente                        LIKE emitente.bairro        
    FIELD cidade-agente                        LIKE emitente.cidade        
    FIELD pais-agente                          LIKE emitente.pais          
    FIELD cep-agente                           LIKE emitente.cep           
    FIELD cgc-agente                           LIKE emitente.cgc           
    FIELD estado-agente                        LIKE emitente.estado        
    FIELD ins-estadual-agente                  LIKE emitente.ins-estadual  
    FIELD ins-municipal-agente                 LIKE emitente.ins-municipal 
    FIELD caixa-postal-agente                  LIKE emitente.caixa-postal  
    FIELD e-mail-agente                        LIKE emitente.e-mail        
    FIELD cod-aba-agente                       LIKE emitente-cex.cod-aba   
    FIELD telefone-agente                      LIKE emitente.telefone[1]   
    FIELD telefone2-agente                     LIKE emitente.telefone[2]   
    FIELD ramal-agente                         LIKE emitente.ramal[1]      
    FIELD ramal2-agente                        LIKE emitente.ramal[2]      
    FIELD home-page-agente                     LIKE emitente.home-page     
    FIELD telefax-agente                       LIKE emitente.telefax       
    FIELD ramal-fax-agente                     LIKE emitente.ramal-fax     
    FIELD telef-fac-agente                     LIKE emitente.telef-fac     
    FIELD ramal-fac-agente                     LIKE emitente.ramal-fac     
    FIELD telef-modem-agente                   LIKE emitente.telef-modem   
    FIELD ramal-modem-agente                   LIKE emitente.ramal-modem.

DEFINE TEMP-TABLE tt-transporte-aux NO-UNDO LIKE transporte
    FIELD cod-transportador                 LIKE processo-imp.cod-transportador          
    FIELD nome-transp                       LIKE transporte.nome           
    FIELD nome-abrev-transp                 LIKE transporte.nome-abrev
    FIELD endereco-transp                   LIKE transporte.endereco
    FIELD bairro-transp                     LIKE transporte.bairro
    FIELD cidade-transp                     LIKE transporte.cidade
    FIELD pais-transp                       LIKE transporte.pais
    FIELD cep-transp                        LIKE transporte.cep            
    FIELD cgc-transp                        LIKE transporte.cgc            
    FIELD estado-transp                     LIKE transporte.estado
    FIELD ins-estadual-transp               LIKE transporte.ins-estadual
    FIELD caixa-postal-transp               LIKE transporte.cx-postal
    FIELD contato-transp                    LIKE transporte.contato
    FIELD telefone-transp                   LIKE transporte.telefone
    FIELD ramal-transp                      LIKE transporte.ramal
    FIELD telefax-transp                    LIKE transporte.telefax
    FIELD telex-transp                      LIKE transporte.telex
    FIELD ins-municipal-transp              LIKE transporte.ins-municipal
    FIELD zip-code-transp                   LIKE transporte.zip-code
    FIELD e-mail-transp                     LIKE transporte.e-mail
    FIELD telef-modem-transp                LIKE transporte.telef-modem
    FIELD home-page-transp                  LIKE transporte.home-page             
    FIELD ramal-modem-transp                LIKE transporte.ramal-modem
    FIELD ramal-fax-transp                  LIKE transporte.ramal-fax.

DEFINE TEMP-TABLE tt-processo-aux NO-UNDO      LIKE processo-imp
    FIELD id-meio-transp                       LIKE processo-imp.via-transp
    field desc-via-transp                      as char format "X(40)"
    field desc-situacao                        as char format "X(40)"
    FIELD desc-banco                           AS CHAR FORMAT "X(40)"
    FIELD ag-banco                             LIKE banco.ag-padrao
    FIELD desc-agencia                         LIKE pto-contr.descricao
    FIELD desc-itner                           LIKE pto-contr.descricao
    FIELD desc-pto-despacho                    LIKE pto-contr.descricao
    FIELD desc-pto-embarque                    LIKE pto-contr.descricao
    FIELD desc-pto-nacionaliz                  LIKE pto-contr.descricao
    FIELD desc-pto-chegada                     LIKE pto-contr.descricao
    FIELD data-efet-despacho                   LIKE historico-proc-imp.dt-efetiva
    FIELD data-efet-embarque                   LIKE historico-proc-imp.dt-efetiva
    FIELD data-efet-nacionaliz                 LIKE historico-proc-imp.dt-efetiva
    FIELD data-efet-chegada                    LIKE historico-proc-imp.dt-efetiva
    FIELD data-ult-prev-despacho               LIKE historico-proc-imp.dt-ult-previsao
    FIELD data-ult-prev-embarque               LIKE historico-proc-imp.dt-ult-previsao
    FIELD data-ult-prev-nacionaliz             LIKE historico-proc-imp.dt-ult-previsao
    FIELD data-ult-prev-chegada                LIKE historico-proc-imp.dt-ult-previsao.

DEFINE VARIABLE c-classif AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER  NO-UNDO.

/* IM0640.I  */
