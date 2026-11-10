/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0706.I
**
**       DATA....: MAIO de 2005
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Importa‡Æo Cadastros B sicos Frotas
**       Versao..: 
**
*****************************************************************************/
                                                      /** Frame Parƒmetros **/

form /*PAR¶METRO*/
     skip(1)
     "PAR¶METROS"     AT 09       
     skip(1)
    /*pag 1*/           
    "ABASTECIMENTO E LUBRIFICA€ÇO"      AT 15 SKIP
    "EMS"                               AT 26 
    tt-param.l-val-param                label "Valida Parƒmetros"             colon 30
    tt-param.l-tab-unidade              LABEL "Cria Unid. Medida PadrÆo"      COLON 30                                        
    tt-param.l-tag                      LABEL "Cria TAG PadrÆo"               COLON 30                                               
    tt-param.c-estab-tag                LABEL "Estabelec. TAG"                COLON 30                              
    tt-param.c-cc-tag                   LABEL "Centro Custo TAG"              COLON 30      
    "CADASTROS"                         AT 26  
    tt-param.l-mab-ativid               LABEL "Atividades"                    COLON 30                                            
    tt-param.l-mab-trajeto              LABEL "Trajeto"                       COLON 30                                                                                             
    tt-param.l-mab-caract               LABEL "Caracter¡sticas"               COLON 30                                            
    tt-param.l-mab-comptmento           LABEL "Compartimentos àleo/Filtros"   COLON 30                               
    tt-param.l-mab-estrut-mec           LABEL "Estrutura Mecƒnica"            COLON 30                               
    tt-param.l-mab-sist                 LABEL "Sistema Mecƒnico"              COLON 30                               
    tt-param.l-mab-sub-sist             LABEL "Sub-Sistema"                   COLON 30                                         
    tt-param.l-mab-sit-eqpto            LABEL "Situa‡Æo"                      COLON 30                                                                                          
    tt-param.l-mab-grp-eqpto            LABEL "Grupo Equipamento"             COLON 30                                         
    tt-param.l-mab-eqpto-sub-sist       LABEL "Grp Equipamento X Sub-Sistema" COLON 30                                 
    tt-param.l-mab-posto                LABEL "Posto Abastecimento"           COLON 30                                 
    tt-param.l-mab-bomba                LABEL "Bomba"                         COLON 30                                              
    tt-param.l-mab-tip-mater            LABEL "Tipo Material"                 COLON 30                                              
    tt-param.l-mab-tip-mater-item       LABEL "Tipo Material X Item Estoque"  COLON 30      
    tt-param.l-mab-integr-cargo         LABEL "Integra‡Æo Cargos"             COLON 30
    "MODELO"                            AT 26
    tt-param.l-mab-marca                LABEL "Marcas"                        COLON 30   
    tt-param.l-mab-model                LABEL "Modelo - Eqpto/Componente"     COLON 30                                            
    tt-param.l-mab-consu-model          LABEL "Consumo PadrÆo por Modelo"     COLON 30                                            
    tt-param.l-mmv-tempo-padr           LABEL "Tempo PadrÆo Exec Servi‡os"    COLON 30 
    "EVENTO"                            AT 26 
    tt-param.l-mab-grp-event            LABEL "Grupo Evento"                  COLON 30                                              
    tt-param.l-mab-event                LABEL "Evento"                        COLON 30                                              
    "MOTORISTA"                         AT 26 
    tt-param.l-mab-motoris              LABEL "Motorista"                     COLON 30                                            
    tt-param.l-mab-motoris-model        LABEL "Motorista X Modelo"            COLON 30
    SKIP (01)
    /*pag 2*/
    "MANUTEN€ÇO MEC¶NICA"               AT 15    SKIP
    "CADASTROS"                         AT 26 
    tt-param.l-mmv-param                LABEL "Parƒmetros Manut. Mecƒnica"    COLON 30                                               
    tt-param.l-mmv-ofici                LABEL "Oficinas"                      COLON 30                                                      
    tt-param.l-mmv-setor-ofici          LABEL "Setor Oficina"                 COLON 30                                                      
    tt-param.l-mmv-func-ofici           LABEL "Funcion rio Oficina"           COLON 30     
    tt-param.l-mmv-plandor              LABEL "Planejador das Ordens Manut."  COLON 30     
    tt-param.l-mmv-plano-prevent        LABEL "Plano Manuten‡Æo"              COLON 30     
    tt-param.l-mmv-tar-plano            LABEL "Item Plano Preventiva"         COLON 30                             
    tt-param.l-mmv-tar-plano-item       LABEL "Materiais Necess rios Tarefa"  COLON 30                             
    tt-param.l-mmv-tar-plano-epi        LABEL "Eqptos Prote‡Æo Necess rios"   COLON 30                             
    tt-param.l-mmv-tar-plano-ferram     LABEL "Ferramentas Necess rias"       COLON 30                                        
    tt-param.l-mmv-tar-plano-ficha      LABEL "Ficha M‚todo Associada Tarefa" COLON 30
    tt-param.l-mmv-tar-plano-esp        LABEL "Especialidade Assoc. Tarefa"   COLON 30
    tt-param.l-mmv-tar-plano-esp-curso  LABEL "Treinamento da Espec. Tarefa"  COLON 30
    tt-param.l-mi-espec                 LABEL "Especialidade"                 COLON 30
    tt-param.l-mi-curso-trein           LABEL "Treinamentos"                  COLON 30
    tt-param.l-mi-turno                 LABEL "Turnos"                        COLON 30
    tt-param.l-mi-turno-ciclo           LABEL "Horas turno"                   COLON 30
    tt-param.l-mmv-func-turno           LABEL "Turnos funcionÿrio"            COLON 30
    tt-param.l-mmv-func-curso-trein     LABEL "Treinamentos funcionÿrio"      COLON 30
    tt-param.l-mmv-func-especialid      LABEL "Especialidade funcionÿrio"     COLON 30 
    SKIP (01)
    /*pag 3*/
    "PNEUS"                             AT 15    SKIP
    "CADASTROS"                         AT 26 
    tt-param.l-mpn-param                LABEL "Parƒmetros Pneu"               COLON 30   
    tt-param.l-mpn-tip-borracha         LABEL "Tipo Borracha"                 COLON 30   
    tt-param.l-mpn-medid                LABEL "Medidas"                       COLON 30   
    tt-param.l-mpn-pos-pneu             LABEL "Posi‡äes"                      COLON 30   
    tt-param.l-mpn-layout               LABEL "Layout dos Eixos"              COLON 30   
    tt-param.l-mpn-layout-eixo-pos      LABEL "Layout Eixo Posi‡Æo"           COLON 30   
    tt-param.l-mpn-ambien-trab          LABEL "Ambiente Trabalho"             COLON 30   
    tt-param.l-mpn-serv                 LABEL "Servi‡os"                      COLON 30   
    tt-param.l-mpn-tip-serv             LABEL "Tipo Servi‡o"                  COLON 30   
    tt-param.l-mpn-desen                LABEL "Desenho"                       COLON 30   
    tt-param.l-mpn-km-esperad           LABEL "Durabilidade Esperada Pneu"    COLON 30   
    tt-param.l-mpn-model                LABEL "Modelo Pneu"                   COLON 30   
    "PNEU"                              AT 26 
    tt-param.l-mpn-pneu                 LABEL "Pneu"                          COLON 30   
    tt-param.l-mpn-histor-vida          LABEL "Hist¢rico Vida Pneu"           COLON 30   
    SKIP (01)                           
    /*pag 4*/
    "OUTROS"                            AT 15    SKIP
    "COMPONENTES"                       AT 26 
    tt-param.l-mco-compon               LABEL "Componentes"                   COLON 30                                            
    tt-param.l-mco-histor-vida          LABEL "Hist¢rico Vida Componente"     COLON 30                                            
    tt-param.l-mco-plano-compon         LABEL "Plano X Componente"            COLON 30   
    "ANµLISE DE àLEOS"                  AT 26 
    tt-param.l-mab-tab-restdo           LABEL "Tabela de Resultados"          COLON 30                                         
    tt-param.l-mab-restdo-tab           LABEL "Resultados da Tabela"          COLON 30                                             
    tt-param.l-mao-ensaio               LABEL "Ensaios"                       COLON 30                                                
    tt-param.l-mao-ensaio-padr          LABEL "Padräes Ensaios"               COLON 30  
    "MANUTEN€ÇO DE DOCUMENTOS"          AT 26 
    tt-param.l-mab-usuar-frota          LABEL "Usu rio Frotas"                COLON 30                                             
    tt-param.l-mab-usuar-estab          LABEL "Usu rio X Estabelecimento"     COLON 30                                             
    tt-param.l-mnd-proces-administ      LABEL "Processo Administrativo"       COLON 30                                               
    "GERENCIAL FROTAS"                  AT 26 
    tt-param.l-mgf-param                LABEL "Parƒmetro Gerencial Frotas"    COLON 30                                               
    tt-param.l-mgf-event-param          LABEL "Parametriza‡Æo Evento"         COLON 30                                              
    tt-param.l-mgf-event-grp-eqpto      LABEL "Evento X Grupo Equipamento"    COLON 30                                              
    tt-param.l-mgf-grp-estoq            LABEL "Grupo Estoque - Pneus"         COLON 30                                                
    /*pag 5*/          
    SKIP (01)
    "EQUIPAMENTO"                       AT 15   SKIP
    "CADASTROS"                         AT 26 
    tt-param.l-mab-eqpto                LABEL "Equipamentos"                  COLON 30                                      
    tt-param.l-mab-histor-ativid        LABEL "Hist¢rico Set Grp Ativ Eqpto"  COLON 30                                      
    tt-param.l-mab-histor-combust       LABEL "Hist¢rico Combust Eqpto"       COLON 30                                      
    tt-param.l-mab-eqpto-caract         LABEL "Caracter¡sticas Equipamentos"  COLON 30                                      
    tt-param.l-mab-comptmento-eqpto     LABEL "Compartimento Equipamentos"    COLON 30                                      
    tt-param.l-mab-period-manut         LABEL "Per¡odo Manut Compartimento"   COLON 30                                      
    tt-param.l-mab-configur-eixo        LABEL "Configura‡Æo Eixo"             COLON 30                                      
    tt-param.l-mab-programac-event      LABEL "Programa‡Æo de Eventos"        COLON 30                                      
    tt-param.l-mmv-eqpto-plano          LABEL "Equipamento Plano Manuten‡Æo"  COLON 30                                      
    tt-param.l-mgf-eqpto-implto         LABEL "Equipamento X Implementos"     COLON 30                                      
    tt-param.l-mpn-histor-layout-eixo   LABEL "Hist¢rico Layout Eixo Eqpto"   COLON 30                                      
    tt-param.l-mpn-eqpto-serv           LABEL "Servi‡os Pneus em Eqptos"      COLON 30                                               
    tt-param.l-mpn-hora-estimad         LABEL "Percurso Estimado Mensal"      COLON 30                                               
    tt-param.l-mab-relac-eqpto-sub-sis  t LABEL "Relac. Eqpto X Sub. Sist"    COLON 30
    "GRUPO EQUIPAMENTO MANUTEN€ÇO"      AT 26 
    tt-param.l-mmv-grp-eqpto            LABEL "Grupo Equipamento Manuten‡Æo"  COLON 30                                               
    tt-param.l-mmv-eqpto-grp-eqpto      LABEL "Equipamento X Grp Equipamento" COLON 30 
    
    /*LOG*/
     skip(1)   
     "LOG"     AT 09       
     skip(1)
     c-imprime             colon 30  
     c-destino             colon 30 " - ":U c-arq-destino /* tt-param.arq-destino*/ FORMAT "x(70)":U NO-LABEL
     tt-param.dir-entrada  COLON 30
     tt-param.l-atualiza  LABEL "Atualiza Cadastros Existentes" COLON 30
     c-execucao            colon 30
     tt-param.usuario      colon 30
     skip(1)        
     with width 132 side-labels frame f-param-definidos stream-io.

     run utp/ut-trfrrp.p (input frame f-param-definidos:handle).
/****************************************************************************/
                                                   /** Literais Parƒmetros **/
{utp/ut-liter.i "Usu rio" * l}
assign tt-param.usuario:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Destino" * l}
assign c-destino:label in frame f-param-definidos = return-value.
{utp/ut-liter.i Impressora,Arquivo,Terminal *}
ASSIGN c-destino = ENTRY(tt-param.destino,RETURN-VALUE).
{utp/ut-liter.i Imprime * }
assign c-imprime:label in frame f-param-definidos = trim(RETURN-VALUE).
{utp/ut-liter.i Todos,Rejeitados *}
assign c-imprime = entry(tt-param.todos,return-value).
{utp/ut-liter.i Diret¢rio_Importa‡Æo *}
ASSIGN tt-param.dir-entrada:LABEL IN FRAME f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i "Execu‡Æo" * l}
assign c-execucao:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "On-Line,Batch" *}
assign c-execucao = entry(tt-param.execucao,return-value).
{utp/ut-liter.i Sim/NÆo *}
ASSIGN    tt-param.l-val-param:format in frame f-param-definidos = return-value
          tt-param.l-tab-unidade:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-tag:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                
          tt-param.l-mab-ativid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mab-trajeto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE          
          tt-param.l-mab-caract:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mab-comptmento:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mab-estrut-mec:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mab-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE             
          tt-param.l-mab-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE         
          tt-param.l-mab-sit-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mab-grp-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mab-eqpto-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE   
          tt-param.l-mab-posto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mab-bomba:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mab-tip-mater:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mab-tip-mater-item:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                       
          tt-param.l-mab-marca:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mab-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mab-consu-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mmv-tempo-padr:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                            
          tt-param.l-mab-grp-event:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mab-event:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                           
          tt-param.l-mab-motoris:FORMAT IN FRAME f-param-definidos = RETURN-VALUE          
          tt-param.l-mab-motoris-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-mab-integr-cargo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-mmv-param:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mmv-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mmv-setor-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mmv-func-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mmv-plandor:FORMAT IN FRAME f-param-definidos = RETURN-VALUE          
          tt-param.l-mmv-plano-prevent:FORMAT IN FRAME f-param-definidos = RETURN-VALUE    
          tt-param.l-mmv-tar-plano:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mmv-tar-plano-item:FORMAT IN FRAME f-param-definidos = RETURN-VALUE   
          tt-param.l-mmv-tar-plano-epi:FORMAT IN FRAME f-param-definidos = RETURN-VALUE    
          tt-param.l-mmv-tar-plano-ferram:FORMAT IN FRAME f-param-definidos = RETURN-VALUE 
          tt-param.l-mmv-tar-plano-ficha:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                      
          tt-param.l-mmv-tar-plano-esp:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                             
          tt-param.l-mmv-tar-plano-esp-curso:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                       
          tt-param.l-mi-espec:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                      
          tt-param.l-mi-curso-trein:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                
          tt-param.l-mi-turno:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                      
          tt-param.l-mi-turno-ciclo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                
          tt-param.l-mmv-func-turno:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                                
          tt-param.l-mmv-func-curso-trein:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                          
          tt-param.l-mmv-func-especialid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                           
          tt-param.l-mpn-param:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mpn-tip-borracha:FORMAT IN FRAME f-param-definidos = RETURN-VALUE     
          tt-param.l-mpn-medid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mpn-pos-pneu:FORMAT IN FRAME f-param-definidos = RETURN-VALUE         
          tt-param.l-mpn-layout:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mpn-layout-eixo-pos:FORMAT IN FRAME f-param-definidos = RETURN-VALUE  
          tt-param.l-mpn-ambien-trab:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mpn-serv:FORMAT IN FRAME f-param-definidos = RETURN-VALUE             
          tt-param.l-mpn-tip-serv:FORMAT IN FRAME f-param-definidos = RETURN-VALUE         
          tt-param.l-mpn-desen:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mpn-km-esperad:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mpn-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                           
          tt-param.l-mpn-pneu:FORMAT IN FRAME f-param-definidos = RETURN-VALUE             
          tt-param.l-mpn-histor-vida:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                        
          tt-param.l-mco-compon:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mco-histor-vida:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mco-plano-compon:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mab-tab-restdo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mab-restdo-tab:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mao-ensaio:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mao-ensaio-padr:FORMAT IN FRAME f-param-definidos = RETURN-VALUE           
          tt-param.l-mab-usuar-frota:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mab-usuar-estab:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mnd-proces-administ:FORMAT IN FRAME f-param-definidos = RETURN-VALUE              
          tt-param.l-mgf-param:FORMAT IN FRAME f-param-definidos = RETURN-VALUE            
          tt-param.l-mgf-event-param:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mgf-event-grp-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE  
          tt-param.l-mgf-grp-estoq:FORMAT IN FRAME f-param-definidos = RETURN-VALUE                           
          tt-param.l-mab-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE             
          tt-param.l-mab-histor-ativid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE     
          tt-param.l-mab-histor-combust:FORMAT IN FRAME f-param-definidos = RETURN-VALUE    
          tt-param.l-mab-eqpto-caract:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mab-comptmento-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE  
          tt-param.l-mab-period-manut:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mab-configur-eixo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE     
          tt-param.l-mab-programac-event:FORMAT IN FRAME f-param-definidos = RETURN-VALUE   
          tt-param.l-mmv-eqpto-plano:FORMAT IN FRAME f-param-definidos = RETURN-VALUE       
          tt-param.l-mgf-eqpto-implto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE      
          tt-param.l-mpn-histor-layout-eixo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-mpn-eqpto-serv:FORMAT IN FRAME f-param-definidos = RETURN-VALUE        
          tt-param.l-mpn-hora-estimad:FORMAT IN FRAME f-param-definidos = RETURN-VALUE  
          tt-param.l-mmv-grp-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE         
          tt-param.l-mmv-eqpto-grp-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-mab-relac-eqpto-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
          tt-param.l-atualiza:FORMAT IN FRAME f-param-definidos = RETURN-VALUE.


/****************************************************************************/     
                                                       /** Frame ImpressÆo **/
form tt-dados.linha      /*LABEL "Linha"*/      AT 1
     tt-dados.erro       /*LABEL "Erro"*/       AT 11
     tt-dados.descricao  /*LABEL "Descri‡Æo"*/  AT 22
    with width 132 NO-LABEL no-attr-space NO-BOX down frame f-dados stream-io.

run utp/ut-trfrrp.p (input frame f-dados:HANDLE).

/****************************************************************************/
                                            /** Final da include de frames **/
