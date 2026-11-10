/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0708.i
**       DATA....: Janeiro de 2006
**       AUTOR...: DATASUL S.A.
*****************************************************************************/

/* Frame Parƒmetros **/

form /*PAR¶METRO*/
     skip(1)
     "PAR¶METROS"     AT 09       
     skip(1)
     /*pag 1*/           
     "ABASTECIMENTO E LUBRIFICA€ÇO"  AT 15 SKIP
     "MODELO"                        AT 26 SKIP
     tt-param.l-mab-marca            LABEL "Marcas"                        COLON 30   
     tt-param.l-mab-model            LABEL "Modelo - Eqpto/Componente"     COLON 30                                            
     tt-param.l-mab-consu-model      LABEL "Consumo PadrÆo por Modelo"     COLON 30                                            
     tt-param.l-mmv-tempo-padr       LABEL "Tempo PadrÆo Exec Servi‡os"    COLON 30 
     "CADASTROS"                     AT 26  SKIP
     tt-param.l-mab-ativid           LABEL "Atividades"                    COLON 30                                            
     tt-param.l-mab-trajeto          LABEL "Trajeto"                       COLON 30                                                                                             
     tt-param.l-mab-caract           LABEL "Caracter¡sticas"               COLON 30                                            
     tt-param.l-mab-comptmento       LABEL "Compartimentos àleo/Filtros"   COLON 30                               
     tt-param.l-mab-estrut-mec       LABEL "Estrutura Mecƒnica"            COLON 30                               
     tt-param.l-mab-sist             LABEL "Sistema Mecƒnico"              COLON 30                               
     tt-param.l-mab-sub-sist         LABEL "Sub-Sistema"                   COLON 30                                         
     tt-param.l-mab-sit-eqpto        LABEL "Situa‡Æo"                      COLON 30                                                                                          
     tt-param.l-mab-grp-eqpto        LABEL "Grupo Equipamento"             COLON 30                                         
     tt-param.l-mab-posto            LABEL "Posto Abastecimento"           COLON 30                                 
     tt-param.l-mab-bomba            LABEL "Bomba"                         COLON 30                                              
     tt-param.l-mab-tip-mater        LABEL "Tipo Material"                 COLON 30                                              
     tt-param.l-mab-tip-mater-item   LABEL "Tipo Material X Item Estoque"  COLON 30      
     "EVENTO"                        AT 26  SKIP
     tt-param.l-mab-grp-event        LABEL "Grupo Evento"                  COLON 30                                              
     tt-param.l-mab-event            LABEL "Evento"                        COLON 30 
     "MOTORISTA"                     AT 26  SKIP
     tt-param.l-mab-motoris          LABEL "Motorista"                     COLON 30                                            
     tt-param.l-mab-motoris-model    LABEL "Motorista X Modelo"            COLON 30    
     "INFORMA€åES ADICIONAIS"        AT 26  SKIP
     tt-param.c-depos                LABEL "Deposito"               COLON 30
     tt-param.c-grp-event            LABEL "Grupo Evento"           COLON 30
     tt-param.c-tip-mater            LABEL "Tipo Material"            COLON 30
     SKIP (01)
     /*pag 2*/
     "MANUTEN€ÇO MEC¶NICA"           AT 15    SKIP
     "CADASTROS"                     AT 26    SKIP
     tt-param.l-mmv-ofici            LABEL "Oficinas"                      COLON 30                                                      
     tt-param.l-mmv-setor-ofici      LABEL "Setor Oficina"                 COLON 30                                                      
     tt-param.l-mmv-func-ofici       LABEL "Funcion rio Oficina"           COLON 30     
     tt-param.l-mmv-plano-prevent    LABEL "Plano Manuten‡Æo"              COLON 30     
     tt-param.l-mmv-tar-plano        LABEL "Item Plano Preventiva"         COLON 30                             
     tt-param.l-mmv-tar-plano-item   LABEL "Materiais Necess rios Tarefa"  COLON 30  
     "INFORMA€åES ADICIONAIS"
     tt-param.c-cod-calend             LABEL "Calend rio"                COLON 30
     tt-param.c-cod-posto               LABEL "Posto"        COLON 30 
     tt-param.c-cod-ofic            LABEL "Oficina"                  COLON 30
     tt-param.c-cod-event            LABEL "Evento"                 COLON 30
     tt-param.c-sub-sist2        LABEL "Sub-Sistema"            COLON 30
     tt-param.c-cod-cc            LABEL "Centro Custo"                COLON 30
     tt-param.i-cd-tipo            LABEL "Tipo Manuten‡Æo"                COLON 30
     tt-param.c-cod-empr2            LABEL "Empresa"                COLON 30
     SKIP (01)
     /*pag 3*/
     "PNEUS"                         AT 15    SKIP
     "CADASTROS"                     AT 26    SKIP
     tt-param.l-mpn-tip-borracha     LABEL "Tipo Borracha"                 COLON 30   
     tt-param.l-mpn-medid            LABEL "Medidas"                       COLON 30   
     tt-param.l-mpn-pos-pneu         LABEL "Posi‡äes"                      COLON 30   
     tt-param.l-mpn-layout           LABEL "Layout dos Eixos"              COLON 30   
     tt-param.l-mpn-layout-eixo-pos  LABEL "Layout Eixo Posi‡Æo"           COLON 30   
     tt-param.l-mpn-ambien-trab      LABEL "Ambiente Trabalho"             COLON 30   
     tt-param.l-mpn-desen            LABEL "Desenho"                       COLON 30   
     tt-param.l-mpn-km-esperad       LABEL "Durabilidade Esperada Pneu"    COLON 30   
     tt-param.l-mpn-model            LABEL "Modelo Pneu"                   COLON 30   
     "PNEU"                          AT 26 
     tt-param.l-mpn-pneu             LABEL "Pneu"                          COLON 30   
     tt-param.l-mpn-histor-vida      LABEL "Hist¢rico Vida Pneu"           COLON 30   
     "INFORMA€åES ADICIONAIS"         
     tt-param.c-cod-serv                LABEL "Tipo Servi‡o"                 COLON 30
     tt-param.c-sub-sist3            LABEL "Sub-Sistema"   COLON 30
     tt-param.c-cod-medida2                LABEL "Medida"                  COLON 30
     tt-param.c-causa           LABEL "Causa"                   COLON 30
     tt-param.c-evento            LABEL "Evento"            COLON 30
     tt-param.c-sit-eqpto             LABEL "Situa‡Æo do Servi‡o"           COLON 30
     tt-param.c-it-codigo             LABEL "Item"           COLON 30
     SKIP (01)
     /*pag 4*/
     "OUTROS"                        AT 15    SKIP
     "COMPONENTES"                   AT 26    SKIP
     tt-param.l-mco-compon           LABEL "Componentes"                   COLON 30                                            
     tt-param.l-mco-histor-vida      LABEL "Hist¢rico Vida Componente"     COLON 30                                            
     "INFORMA€åES ADICIONAIS"
     tt-param.c-cod-emitente         LABEL "C¢digo Emitente"               COLON 30
     tt-param.c-cc-codigo-compon     label "Centro Custo"                  COLON 30
     /*pag 5*/          
     SKIP (01)
     "EQUIPAMENTO"                     AT 15   SKIP
     "CADASTROS"                       AT 26   SKIP
     tt-param.l-mab-eqpto              LABEL "Equipamentos"                  COLON 30                                      
     tt-param.l-mab-histor-ativid      LABEL "Hist¢rico Set Grp Ativ Eqpto"  COLON 30                                      
     tt-param.l-mab-histor-combust     LABEL "Hist¢rico Combust Eqpto"       COLON 30                                      
     tt-param.l-mab-comptmento-eqpto   LABEL "Compartimento Equipamentos"    COLON 30                                      
     tt-param.l-mab-period-manut       LABEL "Per¡odo Manut Compartimento"   COLON 30                                      
     tt-param.l-mab-configur-eixo      LABEL "Configura‡Æo Eixo"             COLON 30                                      
     tt-param.l-mmv-eqpto-plano        LABEL "Equipamento Plano Manuten‡Æo"  COLON 30                                      
     tt-param.l-mpn-histor-layout-eixo LABEL "Hist¢rico Layout Eixo Eqpto"   COLON 30                                      
     tt-param.l-mab-eqpto-sub-sist     LABEL "Equipamento x Sub-Sistema"   COLON 30                                      
     tt-param.l-mab-grp-eqpto-sub-sist     LABEL "Grupo Eqpto x Sub-Sistema"   COLON 30
     "INFORMA€åES ADICIONAIS"
     tt-param.c-cod-pais             LABEL "Pa¡s"                 COLON 30
     tt-param.c-sub-sist-oleo             LABEL "Sub-Sistema àleo"                 COLON 30
     tt-param.c-sub-sist-filtro               LABEL "Sub-Sistema Filtro"                   COLON 30
     /*LOG*/
     skip(1)   
     "LOG"     AT 09       
     skip(1)
     c-imprime             colon 30  
     c-destino             colon 30 " - ":U c-arq-destino /* tt-param.arq-destino*/ FORMAT "x(70)":U NO-LABEL
     tt-param.dir-entrada  COLON 30
     c-execucao            colon 30
     tt-param.usuario      colon 30
     skip(1)        
     with width 132 side-labels frame f-param-definidos stream-io.

run utp/ut-trfrrp.p (input frame f-param-definidos:handle).

/****************************************************************************/
                /** Literais Parƒmetros **/

{utp/ut-liter.i "Usu rio" * l}
ASSIGN tt-param.usuario:label in frame f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i "Destino" * l}
ASSIGN c-destino:label in frame f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i "Impressora,Arquivo,Terminal" *}                                                  
ASSIGN c-destino = ENTRY (tt-param.destino,RETURN-VALUE).
{utp/ut-liter.i "Imprime" * }
ASSIGN c-imprime:label in frame f-param-definidos = trim(RETURN-VALUE).
{utp/ut-liter.i "Todos,Rejeitados" *}
ASSIGN c-imprime = ENTRY (tt-param.todos,RETURN-VALUE).
{utp/ut-liter.i "Diret¢rio_Importa‡Æo" *}
ASSIGN tt-param.dir-entrada:LABEL IN FRAME f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i "Execu‡Æo" * l}
ASSIGN c-execucao:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "On-Line,Batch" *}
ASSIGN c-execucao = entry(tt-param.execucao,return-value).
{utp/ut-liter.i Sim/NÆo *}
assign tt-param.l-mab-marca:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-consu-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-tempo-padr:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-ativid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-trajeto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-caract:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-comptmento:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-estrut-mec:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-sit-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-grp-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-posto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-bomba:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-tip-mater:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-tip-mater-item:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-grp-event:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-event:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-motoris:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-motoris-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-setor-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-func-ofici:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-plano-prevent:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-tar-plano:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-tar-plano-item:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-tip-borracha:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-medid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-pos-pneu:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-layout:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-layout-eixo-pos:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-ambien-trab:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-desen:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-km-esperad:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-model:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-pneu:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-histor-vida:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mco-compon:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mco-histor-vida:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-histor-ativid:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-histor-combust:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-comptmento-eqpto:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-period-manut:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-configur-eixo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mmv-eqpto-plano:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mpn-histor-layout-eixo:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-eqpto-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE
       tt-param.l-mab-grp-eqpto-sub-sist:FORMAT IN FRAME f-param-definidos = RETURN-VALUE.

/****************************************************************************/     
                                                       /** Frame Impress’o **/
form tt-dados.tabela                            AT 1
     tt-dados.erro       /*LABEL "Erro"*/       AT 12
     tt-dados.descricao  /*LABEL "Descri»’o"*/  AT 22
    with width 132 NO-LABEL no-attr-space NO-BOX down frame f-dados stream-io.

form tt-dados.cod-tabela                        AT 1
     tt-dados.des-tabela                        AT 10
     tt-dados.erro                              AT 50
     tt-dados.descricao                         AT 63
    
    with width 132 NO-LABEL no-attr-space NO-BOX down frame f-dados1 stream-io.

run utp/ut-trfrrp.p (input frame f-dados:HANDLE).

/****************************************************************************/
                                            /** Final da include de frames **/
