/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0101A 2.00.00.011 } /*** "010011" 16/05/2025 17:37:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0101a MAB}
&ENDIF

    /*versao  2.00.00.002*/

/*****************************************************************************************
         
         FOP/FO0101.p - Carrega a TEMP-TABLE DE PAR¶METROS
         
******************************************************************************************/
{include/i_fnctrad.i} /** Multi Idioma **/

{abp/ab0101.i} /* defini‡Æo da temp-table ttParam */
DEF OUTPUT PARAM TABLE FOR   ttParam. 
DEF OUTPUT PARAM TABLE FOR   ttModulos. 
Def var i-cont  as integer no-undo.
DEF var c-lista as char no-undo.
def var c-aux1  as CHAR extent 58 NO-UNDO.
def var c-aux2  as CHAR extent 58 NO-UNDO.
def var c-aux3  as CHAR extent 58 NO-UNDO.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao AS CHARACTER NO-UNDO.
&endif

Def var c-item as char FORMAT "x(200)" extent 58 NO-UNDO INITIAL ["% Tempo Troca àleo/Filtro antes do prazo para considerar desperd¡cio",                                     
                                                                  "% Remonta em Fun‡Æo da Capacidade Compartimento (cuja remonta ‚ normal) para considerar desperd¡cio." ,                                                      
                                                                  "% Aceita‡Æo de diferen‡a entre maior sulco e menor no mesmo pneu",                                         
                                                                  "% Aceita‡Æo de diferen‡a entre sulco m‚dio entre pneus no mesmo eixo.",                                     
                                                                  "% Desvio m ximo entre consumo real de pneu e padrÆo para nÆo considerar desperd¡cio na utiliza‡Æo.",        
                                                                  "% Desvio m ximo entre consumo real de pneu e padrÆo para nÆo considerar ganho na utiliza‡Æo.",              
                                                                  "Habilitar motorista no apontamento dos abastecimentos",                                                   
                                                                  "Buscar atividade padrÆo do equipamento no apontamento dos abastecimentos/lubrifica‡äes",                 
                                                                  "Habilitar trajeto no apontamento dos abastecimentos/lubrifica‡äes",                                       
                                                                  "Tipo de c lculo dos valores de combust¡vel/trocas de ¢leo" ,                                   
                                                                  "Consiste Fichas Abastecimento e Lubrifica‡Æo",                                
                                                                  "Tipo de Chamada da manuten‡Æo preventiva",                                                             
                                                                  "Tipo da unidade de transporte dos ve¡culos (Ex. Tonelada, Caixas, M3 Madeira, etc)." ,                                                            
                                                                  "% Aceita‡Æo de diferen‡a entre consumo padrÆo e consumo real para c lculo de quilometragem.",                                             
                                                                  "% Desvio m ximo entre consumo real de combust¡vel e padrÆo para nÆo considerar desperd¡cio.", 
                                                                  "% Desvio m ximo entre consumo real de combust¡vel e padrÆo para nÆo considerar ganho.",       
                                                                  "C¢digo do evento para troca de ¢leo.",
                                                                  "C¢digo do evento para remonta de ¢leo.",
                                                                  "C¢digo do evento para Aviso Problemas.",
                                                                  "C¢digo do Sub-Sistema Contador.",
                                                                  "C¢digo Tipo Manuten‡Æo Corretiva PadrÆo", 
                                                                  "% Tolerƒncia para Gera‡Æo Eventos quando Remonta Motor for Maior que PadrÆo",
                                                                  "C¢digo SubSistema Para Tanque Combust¡vel.",
                                                                  "Habilitar localiza‡Æo Origem(Empresa,Equipamento,Posi‡Æo e Estab) no apontamento de servi‡os de Pneus",
                                                                  "Atualizar Apontamento de Pneu OnLine.",
                                                                  "Atualizar durabilidade do Pneu OnLine.",
                                                                  "Tipo Manuten‡Æo Preventiva PadrÆo.",
                                                                  "Habilitar c¢digo do funcion rio da manuten‡Æo no apontamento de movimento de pneus" ,
                                                                  "Subsistema padrÆo para programa‡Æo de Eventos",
                                                                  "C¢digo Empresa padrÆo para sugestÆo em equipamentos e funcion rios",
                                                                  "% Diferen‡a entre durabilidade componente real e estimada (para considerar desperd¡cio)",
                                                                  "% Diferen‡a entre durabilidade componente real e estimada (para considerar economia)",
                                                                  "% Diferen‡a entre tempo reportado e tempo padrÆo (para considerar desperd¡cio)",
                                                                  "% Diferen‡a entre tempo reportado e tempo padrÆo (para considerar economia)",
                                                                  "Indica qual cat logo Documento Anexo ser  utilizado para as Caracter¡sticas dos Componentes",
                                                                  "Gerar Percurso Implemento Conforme Equipamento Relacionado",
                                                                  "C¢digo motorista padrÆo para gera‡Æo autom tica de apontamento lubrifica‡Æo",
                                                                  "C¢digo trajeto padrÆo para gera‡Æo autom tica de apontamento lubrifica‡Æo",
                                                                  "Criar tarefa autom tica na ordem de manuten‡Æo",
                                                                  "Evento utilizado na gera‡Æo autom tica da ficha de amostra de ¢leo",
                                                                  "Evento utilizado na Transferˆncia de Estabelecimento dos Componentes",
                                                                  "Seqˆncia num‚rica das tarefas de Planos e Ordem de Manuten‡Æo",
                                                                  "Indica se centro custo do componente ser  atualizado com centro custo do eqpto ap¢s uma manuten‡Æo",
                                                                  "Quando selecionado, permite alterar 'Atividade', 'Motorista' e 'Trajeto' nas fichas de abastecimento.",
                                                                  "Define qual a data de controle da garantia dos componentes. Utilizado nas tarefas da OM.",
                                                                  "Ao gerar ficha autom tica com situa‡Æo inativa, coloca a causa da desativa‡Æo no movto.",
                                                                  "Quando selecionado, inativa automaticamente as partes do equipamento, caso este for inativado.",
                                                                  "Permitir que o m‚dio de Frotas seja calculado ap¢s o c lculo do m‚dio da produ‡Æo",
                                                                  "Indica qual o tipo de contador ser  utilizado para calcular a durabilidade dos pneus.",
                                                                  "Indica qual o tipo de contador ser  utilizado para calcular os per¡odos de manuten‡Æo das lubrifica‡äes.",
                                                                  "Cria OM autom tica para os implementos dos equipamentos.",
                                                                  "Busca Empresa e Estabel. do Funcion rio.",
                                                                  "Consiste todas as fichas do equipamento a partir da ficha anterior a que est  sendo inclu¡da.",
                                                                  "Definir se o Sistema permite movimentar pneus para uma posi‡Æo que j  cont‚m outro pneu.",
                                                                  "Permite diferenciar as contas dos combust¡veis e lubrificantes da ficha de abastecimento, Facilitando assim a visualiza‡äes e divisäes desses gastos.",
                                                                  "Exibe Mensagem de Advertˆncia sobre a importƒncia de preencher o Campo Causa (AB0302)",
                                                                  "Caso o estado da requisi‡Æo seja igual a Aprovada nÆo ser  gerado uma sequencia e sim uma nova requisi‡Æo.",
                                                                  "Quando selecionado, nÆo permite inclusÆo ou atualiza‡Æo de fichas com data inferior a data do £ltimo m‚dio fechado."].
                                                                  
Def var c-Label as CHAR FORMAT "x(80)" extent 58 NO-UNDO INITIAL ["% Tempo Troca àleo/Filtro Antes Prazo",
                                                                  "% Remonta M xima (desperd¡cio)" ,                                                      
                                                                  "% Aceita‡Æo Entre Sulcos",                                         
                                                                  "% Aceita‡Æo Sulco Pneus Mesmo Eixo",                                     
                                                                  "% Desvio Consumo Pneu (Desperd¡cio)",        
                                                                  "% Desvio Consumo Pneu (Ganho)",              
                                                                  "Habilitar Motorista Apontamento Abas",                                                   
                                                                  "Buscar Atividade Equipamento em Abastecimento",                 
                                                                  "Habilitar Trajeto Apontamento Abastecimento",                                       
                                                                  "Tipo Valoriza‡Æo Combust¡vel/trocas de ¢leo" ,                                   
                                                                  "Consistir Fichas Abastecimento e Lubrifica‡Æo",
                                                                  "Tipo Chamada Manuten‡Æo Preventiva "  ,                                                             
                                                                  "Unidade Transporte" ,                                                            
                                                                  "% Aceita‡Æo Consumo Combust¡vel",                                             
                                                                  "% Desvio Consumo Combust¡vel (Desperd¡cio)", 
                                                                  "% Desvio Consumo Combust¡vel (Ganho)",       
                                                                  "Evento Troca àleo", 
                                                                  "Evento Remonta àleo",
                                                                  "Evento Aviso Problemas",
                                                                  "C¢digo Sub-Sistema Contador",
                                                                  "Tipo Manuten‡Æo Corretiva",
                                                                  "% Tolerƒncia Remonta Motor",
                                                                  "SubSistema Tanque Combust¡vel",
                                                                  "Habilitar Localiza‡Æo Origem Pneus",
                                                                  "Atualizar Apontamento Pneu OnLine",
                                                                  "Atualizar Durabilidade Pneu OnLine",
                                                                  "Tipo Manuten‡Æo Preventiva PadrÆo",
                                                                  "Habilita Funcion rio Ficha Pneus",
                                                                  "Subsistema PadrÆo",
                                                                  "Empresa PadrÆo",
                                                                  "% Desvio Durabilidade Componente Desperd¡cio",
                                                                  "% Desvio Durabilidade Componente Economia",
                                                                  "% Desvio Reporte Horas Desperd¡cio",
                                                                  "% Desvio Reporte Horas Economia",
                                                                  "Cat logo Documento Caracter¡sticas Componentes", 
                                                                  "Gerar Percurso Implemento = Equipamento",
                                                                  "Motorista PadrÆo", 
                                                                  "Trajeto PadrÆo",
                                                                  "Criar Tarefa Autom tica na OM",
                                                                  "Evento de Amostra de àleo",
                                                                  "Evento PadrÆo de Transferˆncia",
                                                                  "Seqˆncia das Tarefas de Plano e OM",
                                                                  "Centro Custo Componente = Centro Custo Equipamento",
                                                                  "Habilitar altera‡Æo ficha integrada",
                                                                  "Data Controle Garantia Componentes",
                                                                  "Causa de Desativa‡Æo",
                                                                  "Inativar automaticamente partes do equipamento",
                                                                  "Valorizar Frotas ap¢s Produ‡Æo",
                                                                  "C lcular Durabilidade Pneus",
                                                                  "C lcular Manuten‡äes Lubrifica‡Æo",
                                                                  "Criar OM autom tica para os implementos",
                                                                  "Buscar Empresa e Estabelecimento do Funcion rio",
                                                                  "Atualizar Fichas Posteriores ao Abastecimento",
                                                                  "Permitir Movimentar Pneus na Mesma Posi‡Æo",
                                                                  "Diferencia contas para Lubrifica‡Æo e Abastecimento.",
                                                                  "Exibe Mensagem de Advertˆncia Campo Causa (AB0302)",
                                                                  "Criar Nova Requisi‡Æo para Ordem",
                                                                  "Data Seguran‡a Ficha Abastecimento/Lubrifica‡Æo"].




Def var c-Modulo as CHAR FORMAT "x(3)" extent 58 NO-UNDO INITIAL [ "MGF",
                                                                   "MAB",
                                                                   "MPN",
                                                                   "MPN",
                                                                   "MPN",
                                                                   "MPN",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MGF",
                                                                   "MAB",
                                                                   "MGF",
                                                                   "MGF",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MPN",
                                                                   "MPN",
                                                                   "MPN",
                                                                   "MMV",
                                                                   "MPN",
                                                                   "MMV",
                                                                   "MAB",
                                                                   "MGF",
                                                                   "MGF",
                                                                   "MGF",
                                                                   "MGF",
                                                                   "MAB",
                                                                   "MGF",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MAO",
                                                                   "MCO",
                                                                   "MMV",
                                                                   "MCO",
                                                                   "MAB",
                                                                   "MCO",
                                                                   "MPN",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MPN",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MPN",
                                                                   "MAB",
                                                                   "MAB",
                                                                   "MMV",
                                                                   "MAB"].

EMPTY TEMP-TABLE  ttParam.
EMPTY TEMP-TABLE  ttModulos.

/* /*************************************                          */
/* ** Acerto de Base para parametriza‡Æo de Integra‡Æo com Estoque */
/* **************************************/                         */
/* RUN pi-acerto-base IN THIS-PROCEDURE.                           */

/**Acerto parametro 35 Datasul 11**/
RUN pi-acerto-param-35 IN THIS-PROCEDURE.
/**fim do acerto**/

Do i-cont = 1 to EXTENT(c-item):

    run utp/ut-liter.p (input c-item[i-cont],
                        input "*",
                        input "R").

    ASSIGN c-aux1[i-cont] = RETURN-VALUE.

    run utp/ut-liter.p (input c-label[i-cont],
                        input "*",
                        input "R").

    assign c-aux2[i-cont] = RETURN-VALUE.

    run utp/ut-liter.p (input c-Modulo[i-cont],
                        input "*",
                        input "R").

    assign c-aux3[i-cont] = RETURN-VALUE.

    /*posiciona para pegar a empresa cadastrada no sistema*/
    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT CAN-FIND(mab-param WHERE mab-param.cdn-param = i-cont)  THEN DO:

        CREATE mab-param.
        assign mab-param.cdn-param        = i-cont
               mab-param.des-label-param  = substring(c-aux2[i-cont], 1, 50)
               mab-param.des-param        = substring(c-aux1[i-cont], 1, 200)
               mab-param.des-valor        = IF i-cont = 42 THEN "10":U ELSE
                                            IF i-cont = 43 THEN "1":U  else
                                            IF i-cont = 44 THEN "2":U  ELSE
                                            IF i-cont = 48 THEN "2":U  ELSE
                                            IF i-cont = 51 THEN "2":U  ELSE
                                            IF i-cont = 52 THEN "2":U  ELSE
                                            IF i-cont = 53 THEN "2":U  ELSE
                                            IF i-cont = 54 THEN "1":U  ELSE
                                            IF i-cont = 55 THEN "2":U  ELSE
                                            IF i-cont = 56 THEN "1":U  ELSE
                                            IF i-cont = 57 THEN "1":U  ELSE
                                            IF i-cont = 58 THEN "1":U  ELSE
                                            IF i-cont = 47 THEN "2":U  ELSE "":U
               mab-param.ep-codigo        = param-global.empresa-prin
               mab-param.cod-modulo       = substring(c-aux3[i-cont], 1, 3).

    end.
    ELSE DO:
        /** Realiza a Tradu‡Æo MultiIdioma para Labels e Descri‡äes **/
        FOR FIRST mab-param
            WHERE mab-param.cdn-param = i-cont EXCLUSIVE-LOCK:
            run utp/ut-liter.p (input mab-param.des-label-param,
                                input "*",
                                input "R").
        
            ASSIGN mab-param.des-label-param = RETURN-VALUE.
        
            run utp/ut-liter.p (input mab-param.des-param,
                                input "*",
                                input "R").
        
            assign mab-param.des-param = RETURN-VALUE
                   mab-param.cod-modulo = substring(c-aux3[i-cont], 1, 3).
        END.
    END.
end.

/*************************************
** Acerto de Base para parametriza‡Æo de Integra‡Æo com Estoque
**************************************/
RUN pi-acerto-base IN THIS-PROCEDURE.

FOR EACH mab-param EXCLUSIVE-LOCK:
    
    CREATE ttParam.

    CASE mab-param.cdn-param :
        WHEN 7 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i00fr019.i 03}.
            &endif
                assign ttParam.cdn-param        =  mab-param.cdn-param
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.      
        end.
        WHEN 8 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i00fr019.i 03}.
            &endif
                assign   ttParam.cdn-param        =  mab-param.cdn-param       
                         ttParam.des-label-param  =  mab-param.des-label-param 
                         ttParam.des-param        =  mab-param.des-param       
                         ttParam.des-valor        =  mab-param.des-valor
                         ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                         ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 9 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN   ttParam.cdn-param        =  mab-param.cdn-param       
                         ttParam.des-label-param  =  mab-param.des-label-param 
                         ttParam.des-param        =  mab-param.des-param       
                         ttParam.des-valor        =  mab-param.des-valor
                         ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                         ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 10 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i01fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i01fr019.i 03}.
            &endif
                ASSIGN  ttParam.cdn-param       =  mab-param.cdn-param       
                        ttParam.des-label-param  =  mab-param.des-label-param 
                        ttParam.des-param        =  mab-param.des-param       
                        ttParam.des-valor        =  mab-param.des-valor
                        ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0.
                        ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 11 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i02fr019a.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i02fr019a.i 03}.
            &endif
                ASSIGN  ttParam.cdn-param        =  mab-param.cdn-param       
                        ttParam.des-label-param  =  mab-param.des-label-param 
                        ttParam.des-param        =  mab-param.des-param       
                        ttParam.des-valor        =  mab-param.des-valor
                        ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                        ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 12 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i03fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i03fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 24 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 25 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 26 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                 = cAuxTraducao.
            &else
                ASSIGN c-lista                 = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 28 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                  = cAuxTraducao.
            &else
                ASSIGN c-lista                  = {frinc/i00fr019.i 03}.
            &endif
                assign   ttParam.cdn-param        =  mab-param.cdn-param       
                         ttParam.des-label-param  =  mab-param.des-label-param 
                         ttParam.des-param        =  mab-param.des-param       
                         ttParam.des-valor        =  mab-param.des-valor
                         ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                         ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
       /* WHEN 35 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i04fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                  = cAuxTraducao.
            &else
                ASSIGN c-lista                  = {frinc/i04fr019.i 03}.
            &endif
                assign   ttParam.cdn-param        =  mab-param.cdn-param       
                         ttParam.des-label-param  =  mab-param.des-label-param 
                         ttParam.des-param        =  mab-param.des-param
                         ttParam.des-valor        =  mab-param.des-valor
                         ttParam.des-valor        =  ""
                         ttParam.cod-modulo       =  mab-param.cod-modulo.
        END.*/
        WHEN 36 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 39 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 39 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i00fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
        WHEN 45 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i05fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN    c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i05fr019.i 03}.
            &endif
                ASSIGN ttParam.cdn-param        =  mab-param.cdn-param       
                       ttParam.des-label-param  =  mab-param.des-label-param 
                       ttParam.des-param        =  mab-param.des-param       
                       ttParam.des-valor        =  mab-param.des-valor
                       ttParam.des-valor        =  STRING(ENTRY(INT(mab-param.des-valor),c-lista)) WHEN INT(mab-param.des-valor) > 0
                       ttParam.cod-modulo       =  mab-param.cod-modulo.
        END.
        WHEN 49 OR WHEN 50 THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao = {frinc/i06fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao).
                ASSIGN c-lista                = cAuxTraducao.
            &else
                ASSIGN c-lista                = {frinc/i06fr019.i 03}.
            &endif
            ASSIGN  ttParam.cdn-param        =  mab-param.cdn-param       
                    ttParam.des-label-param  =  mab-param.des-label-param 
                    ttParam.des-param        =  mab-param.des-param       
                    ttParam.des-valor        =  IF INT(mab-param.des-valor) <> 0 THEN mab-param.des-valor ELSE "1".
            ASSIGN  ttParam.des-valor        =  STRING(ENTRY(INT(ttParam.des-valor),c-lista)) WHEN INT(ttParam.des-valor) > 0
                    ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.

        OTHERWISE DO:
            assign ttParam.cdn-param        =  mab-param.cdn-param       
                   ttParam.des-label-param  =  mab-param.des-label-param 
                   ttParam.des-param        =  mab-param.des-param       
                   ttParam.des-valor        =  mab-param.des-valor
                   ttParam.cod-modulo       =  mab-param.cod-modulo.
        end.
    END CASE.
    
end.

/*   INICIO DA CRIA€ÇO DA TEMP-TABLE TTMODULOS */
/*
C¢digo da Tabela Fun‡Æo	Descri‡Æo
1 = "spp-mab-impl":U.   Abastecimento e Lubrifica‡Æo
2 = "spp-mpn-impl":U. 	Pneus
3 = "spp-mmv-impl":U. 	Manuten‡Æo Mecƒnica
4 = "spp-mco-impl":U. 	Componentes
5 = "spp-mgf-impl":U. 	Gerencial Frotas
6 = "spp-mao-impl":U. 	An lise de àleos Lubrificantes da Frota
7 = "spp-mnd-impl":U. 	Manuten‡Æo de Documentos da Frota
*/

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 1).
ASSIGN ttModulos.cdn-modulo = 1
       ttModulos.cd-funcao  = "spp-mab-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Abastecimento_e_Lubrifica‡Æo *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 2).
ASSIGN ttModulos.cdn-modulo = 2
       ttModulos.cd-funcao  = "spp-mpn-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Pneus *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 3).
ASSIGN ttModulos.cdn-modulo = 3
       ttModulos.cd-funcao  = "spp-mmv-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Manuten‡Æo_Mecƒnica *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 4).
ASSIGN ttModulos.cdn-modulo = 4
       ttModulos.cd-funcao  = "spp-mco-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Componentes *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 5).
ASSIGN ttModulos.cdn-modulo = 5
       ttModulos.cd-funcao  = "spp-mgf-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Gerencial_Frotas *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 6).
ASSIGN ttModulos.cdn-modulo = 6
       ttModulos.cd-funcao  = "spp-mao-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i An lise_de_àleos_Lubrificantes_da_Frota *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

CREATE ttModulos.
RUN cdp/cd9902.p (INPUT 7).
ASSIGN ttModulos.cdn-modulo = 7
       ttModulos.cd-funcao  = "spp-mnd-impl":U
       ttModulos.log-ativo  = IF  RETURN-VALUE = "OK":U THEN YES ELSE NO.
{utp/ut-liter.i Manuten‡Æo_de_Documentos_da_Frota *}
ASSIGN ttModulos.des-modulo = RETURN-VALUE.

/*   FINAL DA CRIA€ÇO DA TEMP-TABLE TTMODULOS */

/*----------------------------------------------------------------------------------*/
/* Se tabela parƒmetros do sistema de manuten‡Æo industrial nÆo estiver sido criada */
/* deve-se cri -la e deixar os campos em branco para que se possa cadastrar os      */
/* n¡veis de TAG                                                                    */
/*----------------------------------------------------------------------------------*/
if not can-find(first param-mi) then do:
    create param-mi.
end.

/*************************************************************
** Nome: pi-acerto-base
** Defini‡Æo: realiza o acerto dos parametros de integra‡Æo com estoque
*************************************************************/
PROCEDURE pi-acerto-base:
    FOR FIRST mab-param
        WHERE mab-param.cdn-param = 11
        AND   mab-param.log-livre-1 = NO EXCLUSIVE-LOCK:
        /** Valida se o parƒmetro de integra‡Æo j  existe no AB0116 **/
        IF NOT CAN-FIND(FIRST mab-param-integr
                        WHERE mab-param-integr.cdn-param = 8) THEN DO:
            /** Cria‡Æo do Registro **/
            CREATE mab-param-integr.
            ASSIGN mab-param-integr.cdn-param = 8
                   /** Na primeira vez, utiliza o mesmo valor do parametro do AB0101 para o AB0116 **/
                   mab-param-integr.des-valor = mab-param.des-valor.
            /** Tradu‡äes de Label e descri‡Æo **/
            run utp/ut-liter.p (input "Tipo Integra‡Æo EMS",
                                input "*",
                                input "R").
            ASSIGN mab-param-integr.des-label-param = RETURN-VALUE.
            run utp/ut-liter.p (input "Tipo de Integra‡Æo dos combust¡veis e lubrificantes com EMS (Gera‡Æo de Requisi‡Æo)",
                                input "*",
                                input "R").
            ASSIGN mab-param-integr.des-param = RETURN-VALUE.
                   
            /*RUN abp/ab0101aa.p. /*create na tabela mab-param-integr*/*/
        END.
        /** Atualiza campo livre para definir que a altera‡Æo dos parametros j  ocorreu **/
        ASSIGN mab-param.log-livre-1 = YES
               mab-param.des-valor   = IF mab-param.des-valor = "1" OR mab-param.des-valor = "2" THEN "1" ELSE "2".
        /** Define os novos labels e descri‡äes do parametro 11 **/
        run utp/ut-liter.p (input substring(c-Label[11],1,50),
                            input "*",
                            input "R").
        ASSIGN mab-param.des-label-param  = RETURN-VALUE.
        run utp/ut-liter.p (input substring(c-item[11],1,200),
                            input "*",
                            input "R").
        ASSIGN mab-param.des-param = RETURN-VALUE.
    
    END.

    FOR FIRST mab-param
        WHERE mab-param.cdn-param   = 35
        AND   mab-param.log-livre-1 = NO EXCLUSIVE-LOCK:
/** Valida se o parƒmetro de integra‡Æo j  existe no AB0116 **/
        IF NOT CAN-FIND(FIRST mab-param-integr
                        WHERE mab-param-integr.cdn-param = 12) THEN DO:
/** Cria‡Æo do Registro **/
            CREATE mab-param-integr.
            ASSIGN mab-param-integr.cdn-param = 12.
/** Tradu‡äes de Label e descri‡Æo **/
            run utp/ut-liter.p (input "Tipo de Integra‡Æo Patrim“nio",
                                input "*",
                                input "R").
            ASSIGN mab-param-integr.des-label-param = RETURN-VALUE.
            run utp/ut-liter.p (input "Indica o Tipo de Integra‡Æo com o M¢dulo de Patrim“nio",
                                input "*",
                                input "R").
            ASSIGN mab-param-integr.des-param = RETURN-VALUE.            
/** Transfere o valor do parametro do AB0101 para o AB0116, conforme regra (1=NÆo / 2=Sim) **/
            IF mab-param.des-valor = "1" THEN DO:
                {utp/ut-liter.i NÆo}
            END. 
            ELSE DO:
                {utp/ut-liter.i Sim}
            END.
            ASSIGN mab-param-integr.des-valor = RETURN-VALUE. 
            {utp/ut-liter.i NÆo}
            ASSIGN mab-param-integr.des-valor = mab-param-integr.des-valor + ",":U + RETURN-VALUE + ",1,":U. 
        END.
/** Atualiza campo livre para definir que a altera‡Æo dos parƒmetros j  ocorreu **/
        ASSIGN mab-param.log-livre-1 = YES.
/** Define novo label e descri‡Æo do parƒmetro 35 **/
        run utp/ut-liter.p (input substring(c-Label[35],1,50),
                            input "*",
                            input "R").
        ASSIGN mab-param.des-label-param = RETURN-VALUE.
        run utp/ut-liter.p (input substring(c-item[35],1,200),
                            input "*",
                            input "R").
        ASSIGN mab-param.des-param = return-value
               mab-param.des-valor = "".
    END.


    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-acerto-param-35:

    IF CAN-FIND(FIRST mab-param WHERE mab-param.cdn-param = 35 
                                  AND mab-param.des-label-param = "Integra‡Æo Patrim“nio (ver AB0116)" ) THEN DO:
        FOR FIRST mab-param WHERE mab-param.cdn-param = 35 EXCLUSIVE-LOCK:
            ASSIGN mab-param.des-label-param = "Cat logo Documento Caracter¡sticas Componentes"
                   mab-param.des-param       = "Indica qual cat logo Documento Anexo ser  utilizado para as Caracter¡sticas dos Componentes".
        END.
        RELEASE mab-param.
    END.

    RETURN "OK":U.
END PROCEDURE.
