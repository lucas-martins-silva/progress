&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706RP 2.00.00.002}  /*** "010002" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: ab0706rp.p
**
**       DATA....: Maio/2005
**
**       AUTOR...: SANDRO KELLERMANN DE CARVALHO its0121 
**
**       OBJETIVO: Importa‡Æo Cadastros Basicos Frotas
**
*****************************************************************************/

/****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
 
{abp/ab0706.i4}            /* Temp-table tt-param */
{abp/ab9004.i}            /* Temp-Table RowErrors */
{abp/ab0706.i3}

def temp-table tt-raw-digita
   field raw-digita as raw.
/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
create tt-param.
raw-transfer raw-param to tt-param.
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
define variable h-acomp        as handle     no-undo.
DEFINE VARIABLE c-imprime      AS CHARACTER  FORMAT "x(15)":U NO-UNDO.
DEFINE VARIABLE c-destino      AS CHARACTER  FORMAT "x(20)":U NO-UNDO.
DEFINE VARIABLE c-execucao     AS CHARACTER FORMAT "x(10)" NO-UNDO.

define variable c-linha        as character  no-undo.
define variable i-cont         as integer    no-undo.
DEFINE VARIABLE l-pagparam     AS LOGICAL INITIAL NO NO-UNDO.

define variable iLinha         as integer    no-undo.

DEFINE VARIABLE c-liter1 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter2 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter3 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-arq-destino AS CHARACTER FORMAT "x(70)":U NO-UNDO.
DEFINE VARIABLE i-contador-geral AS INTEGER INITIAL 0       NO-UNDO.

{include/i-rpvar.i}
                                                     /** Cabe‡alho e Forms **/
{abp/ab0706.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11.79
         WIDTH              = 52.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.

/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i &TOFILE=tt-param.arq-destino}  /** Abertura do output do programa **/

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cria-tag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tag Procedure 
PROCEDURE cria-tag :
/*------------------------------------------------------------------------------
  Purpose:     cria-tag
  Parameters:  <none>
  Notes:       Cria a TAG Padr’o
------------------------------------------------------------------------------*/

{utp/ut-liter.i Criando_TAG_PadrÆo *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

/** TAG **/
IF NOT CAN-FIND(FIRST tag
                WHERE tag.cd-tag = "":U NO-LOCK) THEN DO:
    /** Tipo N¡vel TAG **/
    IF NOT CAN-FIND (FIRST tipo-nivel
                     WHERE tipo-nivel.cod-tipo = 999 NO-LOCK) THEN DO:
        CREATE tipo-nivel.
        {utp/ut-liter.i EQUIPAMENTOS *}
        ASSIGN tipo-nivel.cod-tipo   = 999
               tipo-nivel.descricao  = RETURN-VALUE
               tipo-nivel.tipo-filho = 0.
        VALIDATE tipo-nivel.
    END.

    CREATE tag. 

    {utp/ut-liter.i TAG_PADRÇO *}
    ASSIGN tag.cd-tag       = "":U
           tag.descricao    = RETURN-VALUE
           tag.cod-estabel  = tt-param.c-estab-tag   
           tag.cc-codigo    = tt-param.c-cc-tag 
           tag.cd-equipto   = "":U
           tag.cd-planejado = "":U
           tag.cod-imagem   = "":U
           tag.cod-tipo     = 999
           tag.criticidade  = 1
           tag.sequencia    = 0.
    VALIDATE tag.
END.

{utp/ut-liter.i TAG_PadrÆo_cadastrada_com_sucesso *}
ASSIGN c-liter1 = RETURN-VALUE.
{utp/ut-liter.i TAG_PadrÆo *}
ASSIGN c-liter2 = RETURN-VALUE.
{utp/ut-liter.i EMS *}
ASSIGN c-liter3 = RETURN-VALUE.

CREATE tt-dados.
ASSIGN tt-dados.linha     = 0
       tt-dados.erro      = 0
       tt-dados.descricao = c-liter1
       tt-dados.tabela    = c-liter2
       tt-dados.MODULO    = c-liter3
       i-contador-geral   = i-contador-geral + 1
       tt-dados.i-chave   = i-contador-geral.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cria-unidade-medida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-unidade-medida Procedure 
PROCEDURE cria-unidade-medida :
/*------------------------------------------------------------------------------
  Purpose:     cria-unidade-medida
  Parameters:  <none>
  Notes:       Cria‡Æo das unidades de medida padrÆo mais utilizadas no Frotas
------------------------------------------------------------------------------*/
{utp/ut-liter.i Criando_Unidades_de_Medida_PadrÆo *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "L":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i LITROS *}
    ASSIGN tab-unidade.un        = "L":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "ML":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i MILILITROS *}
    ASSIGN tab-unidade.un        = "ML":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "KM":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i QUILOMETRAGEM *}
    ASSIGN tab-unidade.un        = "KM":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "H":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i HORAS *}
    ASSIGN tab-unidade.un        = "H":U
           tab-unidade.descricao = return-value.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "KG":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i QUILOS *}
    ASSIGN tab-unidade.un        = "KG":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "GR":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i GRAMAS *}
    ASSIGN tab-unidade.un        = "GR":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "UN":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i UNIDADE *}
    ASSIGN tab-unidade.un        = "UN":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.
IF NOT CAN-FIND(FIRST tab-unidade
                WHERE tab-unidade.un = "PC":U NO-LOCK) THEN DO:
    CREATE tab-unidade.
    {utp/ut-liter.i PE€A *}
    ASSIGN tab-unidade.un        = "PC":U
           tab-unidade.descricao = RETURN-VALUE.
    VALIDATE tab-unidade.
END.

{utp/ut-liter.i Unidades_de_Medida_padräes_cadastradas_com_sucesso *}
ASSIGN c-liter1 = RETURN-VALUE.
{utp/ut-liter.i Unidades_de_Medida_Padräes *}
ASSIGN c-liter2 = RETURN-VALUE.
{utp/ut-liter.i EMS *}
ASSIGN c-liter3 = RETURN-VALUE.

CREATE tt-dados.
ASSIGN tt-dados.linha     = 0
       tt-dados.erro      = 0
       tt-dados.descricao = c-liter1
       tt-dados.tabela    = c-liter2
       tt-dados.MODULO    = c-liter3
       i-contador-geral   = i-contador-geral + 1
       tt-dados.i-chave   = i-contador-geral.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDados Procedure 
PROCEDURE displayDados :
/*------------------------------------------------------------------------------
  Purpose:     displayDados
  Parameters:  <none>
  Notes:       Mostra os dados da importa‡Æo e seus respectivos erros.
------------------------------------------------------------------------------*/

DEFINE VARIABLE c-tabelaAtual AS CHARACTER FORMAT "x(50)":U NO-UNDO.
DEFINE VARIABLE c-moduloAtual AS CHARACTER FORMAT "x(50)":U NO-UNDO.
DEFINE VARIABLE c-liter-mod AS CHARACTER FORMAT "x(10)":U NO-UNDO.
DEFINE VARIABLE c-liter-cad AS CHARACTER FORMAT "x(10)":U NO-UNDO.
DEFINE VARIABLE l-prim-mod AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE l-prim-cad AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE l-controllinha AS LOGICAL  INITIAL YES NO-UNDO.
DEFINE VARIABLE l-start-display AS LOGICAL INITIAL YES NO-UNDO.

DEFINE VARIABLE c-liter-linha AS CHARACTER FORMAT "x(10)":U NO-UNDO.
DEFINE VARIABLE c-liter-erro  AS CHARACTER FORMAT "x(09)":U NO-UNDO.
DEFINE VARIABLE c-liter-descricao AS CHARACTER FORMAT "x(50)":U NO-UNDO.

define buffer bf-tt-dados for tt-dados.

{utp/ut-liter.i M¢dulo *}
ASSIGN c-liter-mod = trim(RETURN-VALUE).
{utp/ut-liter.i Cadastro *}
ASSIGN c-liter-cad = trim(RETURN-VALUE).

{utp/ut-liter.i Linha *}
ASSIGN c-liter-linha = trim(RETURN-VALUE).
{utp/ut-liter.i Erro *}
ASSIGN c-liter-erro = trim(RETURN-VALUE).
{utp/ut-liter.i Descri‡Æo *}
ASSIGN c-liter-descricao = trim(RETURN-VALUE).

IF tt-param.todos = 2 THEN
    FIND FIRST tt-dados USE-INDEX i-ordena WHERE tt-dados.erro <> 0 NO-LOCK NO-ERROR.
ELSE
    FIND FIRST tt-dados USE-INDEX i-ordena NO-LOCK NO-ERROR.
IF AVAIL tt-dados THEN
    ASSIGN c-tabelaAtual = tt-dados.tabela
           c-moduloAtual = tt-dados.MODULO.

FOR EACH tt-dados USE-INDEX i-ordena NO-LOCK:
    /*Caso seja a impressÆo somente dos rejeitados, e erro seja diferente de 0, ou seja impressÆo de todos*/
    IF (tt-param.todos = 2 AND tt-dados.erro <> 0) OR 
        tt-param.todos = 1 THEN DO:
        ASSIGN l-pagparam = YES.
        /*se for o 1o do modulo, imprime o modulo*/
        IF l-prim-mod THEN DO:
            IF l-start-display THEN
                ASSIGN l-start-display = NO.
            ELSE
                PUT SKIP(2).
            PUT c-liter-mod AT 5.
            PUT ": ":U AT 16.
            PUT tt-dados.MODULO.
            ASSIGN l-prim-mod     = NO
                   l-controllinha = NO.
        END.
        ELSE
            ASSIGN l-controllinha = YES.
        /*se for o 1o do Cadastro, imprime o Cadastro e o cabe‡alho*/
        IF l-prim-cad THEN DO:
            IF l-controllinha THEN
                PUT SKIP(1).
            PUT c-liter-cad AT 5.
            PUT ": ":U AT 16.
            PUT tt-dados.tabela.
            ASSIGN l-prim-cad = NO.
            PUT SKIP(1).
    
            /*cabe‡alho dos dados:*/
            PUT c-liter-linha AT 1.
            PUT c-liter-erro  AT 12.
            PUT c-liter-descricao AT 22.
            PUT "----------":U AT 1.
            PUT "---------":U AT 12.
            PUT "---------------------------------------------------------------------------------------------------------------":U AT 22.
        END.

        DISPLAY tt-dados.linha
                tt-dados.erro
                tt-dados.descricao
            WITH FRAME f-dados.
        DOWN WITH FRAME f-dados.
    
        /*Verifica se pr¢ximo registro ‚ modulo ou tabela diferente, para que possa exibir corretamente
          os cabe‡alhos de M¢dulo / Cadastro */
        FIND FIRST bf-tt-dados WHERE rowid(bf-tt-dados) = ROWID(tt-dados) NO-LOCK.
        FIND NEXT bf-tt-dados USE-INDEX i-ordena NO-LOCK.
        IF AVAIL bf-tt-dados THEN DO:
            IF TRIM(bf-tt-dados.MODULO) <> trim(c-moduloAtual) THEN DO:
                ASSIGN l-prim-mod    = YES
                       c-moduloAtual = trim(bf-tt-dados.MODULO).
            END.
            IF TRIM(bf-tt-dados.tabela) <> trim(c-tabelaAtual) THEN DO:
                ASSIGN l-prim-cad    = YES
                       c-tabelaAtual = trim(bf-tt-dados.tabela).
            END.
        END.
    END. /*if*/
END. /*FOR EACH tt-dados*/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
/** Cria a p gina dos parƒmetros **/
IF l-pagparam THEN
    page.

/******************************************************************
  Final do espa‡o reservado
******************************************************************/

DISPLAY /* "PAR¶METROS"     */
        /* "ABASTECIMENTO E LUBRIFICA€ÇO"  
           "EMS"                             */
        tt-param.l-val-param
        tt-param.l-tab-unidade          
        tt-param.l-tag                  
        tt-param.c-estab-tag            
        tt-param.c-cc-tag               
       /* "Cadastros"                     */
        tt-param.l-mab-ativid           
        tt-param.l-mab-trajeto          
        tt-param.l-mab-caract           
        tt-param.l-mab-comptmento       
        tt-param.l-mab-estrut-mec       
        tt-param.l-mab-sist             
        tt-param.l-mab-sub-sist         
        tt-param.l-mab-sit-eqpto        
        tt-param.l-mab-grp-eqpto        
        tt-param.l-mab-eqpto-sub-sist   
        tt-param.l-mab-posto            
        tt-param.l-mab-bomba            
        tt-param.l-mab-tip-mater        
        tt-param.l-mab-tip-mater-item 
        tt-param.l-mab-integr-cargo
       /* "Modelo"                        */
        tt-param.l-mab-marca            
        tt-param.l-mab-model            
        tt-param.l-mab-consu-model      
        tt-param.l-mmv-tempo-padr       
       /* "Evento"                        */
        tt-param.l-mab-grp-event        
        tt-param.l-mab-event            
       /* "Motorista"                     */
        tt-param.l-mab-motoris          
        tt-param.l-mab-motoris-model                        
        /*"MANUTEN€ÇO MEC¶NICA"           
          "Cadastros"                     */
        tt-param.l-mmv-param            
        tt-param.l-mmv-ofici            
        tt-param.l-mmv-setor-ofici      
        tt-param.l-mmv-func-ofici       
        tt-param.l-mmv-plandor          
        tt-param.l-mmv-plano-prevent    
        tt-param.l-mmv-tar-plano        
        tt-param.l-mmv-tar-plano-item   
        tt-param.l-mmv-tar-plano-epi    
        tt-param.l-mmv-tar-plano-ferram 
        tt-param.l-mmv-tar-plano-ficha
        tt-param.l-mmv-tar-plano-esp      
        tt-param.l-mmv-tar-plano-esp-curso
        tt-param.l-mi-espec               
        tt-param.l-mi-curso-trein         
        tt-param.l-mi-turno               
        tt-param.l-mi-turno-ciclo         
        tt-param.l-mmv-func-turno         
        tt-param.l-mmv-func-curso-trein   
        tt-param.l-mmv-func-especialid    
        /*"PNEUS"                         
          "Cadastros"                     */
        tt-param.l-mpn-param            
        tt-param.l-mpn-tip-borracha     
        tt-param.l-mpn-medid            
        tt-param.l-mpn-pos-pneu         
        tt-param.l-mpn-layout           
        tt-param.l-mpn-layout-eixo-pos  
        tt-param.l-mpn-ambien-trab      
        tt-param.l-mpn-serv             
        tt-param.l-mpn-tip-serv         
        tt-param.l-mpn-desen            
        tt-param.l-mpn-km-esperad       
        tt-param.l-mpn-model            
        /*"Pneu"                          */
        tt-param.l-mpn-pneu             
        tt-param.l-mpn-histor-vida  
        /*"OUTROS"                        
          "Componentes"                   */
        tt-param.l-mco-compon           
        tt-param.l-mco-histor-vida      
        tt-param.l-mco-plano-compon     
        /*"An lise de àleos"              */
        tt-param.l-mab-tab-restdo       
        tt-param.l-mab-restdo-tab       
        tt-param.l-mao-ensaio           
        tt-param.l-mao-ensaio-padr      
        /*"Manuten‡Æo de Documentos"      */
        tt-param.l-mab-usuar-frota      
        tt-param.l-mab-usuar-estab      
        tt-param.l-mnd-proces-administ  
        /*"Gerencial Frotas"              */
        tt-param.l-mgf-param            
        tt-param.l-mgf-event-param      
        tt-param.l-mgf-event-grp-eqpto  
        tt-param.l-mgf-grp-estoq
        /*"EQUIPAMENTO"                    */
        /*"Cadastros"*/
        tt-param.l-mab-eqpto             
        tt-param.l-mab-histor-ativid     
        tt-param.l-mab-histor-combust    
        tt-param.l-mab-eqpto-caract      
        tt-param.l-mab-comptmento-eqpto  
        tt-param.l-mab-period-manut      
        tt-param.l-mab-configur-eixo     
        tt-param.l-mab-programac-event   
        tt-param.l-mmv-eqpto-plano       
        tt-param.l-mgf-eqpto-implto      
        tt-param.l-mpn-histor-layout-eixo
        tt-param.l-mpn-eqpto-serv        
        tt-param.l-mpn-hora-estimad      
        tt-param.l-mab-relac-eqpto-sub-sist
        /*"Grupo Equipamento Manuten‡Æo"   */
        tt-param.l-mmv-grp-eqpto         
        tt-param.l-mmv-eqpto-grp-eqpto 
        
        /*LOG*/                                                 
        c-imprime            
        c-destino     
        substring(tt-param.arq-destino,1,75) @ c-arq-destino
        tt-param.dir-entrada
        tt-param.l-atualiza
        c-execucao
        tt-param.usuario
        WITH FRAME f-param-definidos.
                                     

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piImportaDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportaDados Procedure 
PROCEDURE piImportaDados :
/*------------------------------------------------------------------------------
  Purpose:     Chama as procedures de importa‡Æo de cada tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*Dados fixos (EMS)*/
IF tt-param.l-tab-unidade THEN
    RUN cria-unidade-medida IN THIS-PROCEDURE.

IF tt-param.l-tag THEN
    RUN cria-tag IN THIS-PROCEDURE.

/*P gina 1*/
/*Importa‡Æo p g 1 Abastecimento / Lubrificacao - 1a parte*/
RUN abp/ab0706a.p  (INPUT-OUTPUT i-contador-geral, 
                    INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

/*Importa‡Æo p g 1 Abastecimento / Lubrificacao - 2a parte*/
RUN abp/ab0706b.p  (INPUT-OUTPUT i-contador-geral, 
                    INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

/*Importa‡Æo p g 2 Manuten‡Æo Mecanica*/
RUN cdp/cd9902.p (INPUT 3).
IF RETURN-VALUE = "OK":U THEN
    RUN abp/ab0706c.p  (INPUT-OUTPUT i-contador-geral, 
                        INPUT        TABLE tt-param, 
                        INPUT-OUTPUT TABLE tt-dados,
                        INPUT        h-acomp).

/*Importa‡Æo p g 3 Pneus*/
RUN cdp/cd9902.p (INPUT 2).
IF RETURN-VALUE = "OK":U THEN
    RUN abp/ab0706d.p  (INPUT-OUTPUT i-contador-geral, 
                        INPUT        TABLE tt-param, 
                        INPUT-OUTPUT TABLE tt-dados,
                        INPUT        h-acomp).

/*Importa‡Æo p g 4 Outros*/
RUN abp/ab0706e.p  (INPUT-OUTPUT i-contador-geral, 
                    INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

/*Importa‡Æo p g 5 Equipamentos*/
RUN abp/ab0706f.p  (INPUT-OUTPUT i-contador-geral, 
                    INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
assign c-programa = "AB0706":U
       c-versao   = "2.00":U
       c-revisao  = "000":U.
       /** Define o destino do arquivo a ser gerado **/
RUN utp/ut-liter.p (trim({varinc/var00002.i 04 integer(tt-param.destino)}), "*", "").
/* ASSIGN c-destino  = RETURN-VALUE. */

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param exclusive-lock no-error.

/** Busca empresa padrÆo **/
for first param-global fields(grupo) no-lock:
    assign c-empresa = param-global.grupo.
end.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i Importa‡Æo_Cadastros_B sicos_Frotas *}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Frotas *}
assign c-sistema = trim(return-value).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/

/*verifica dados a importar, e os importa para as temp tables.*/
RUN piImportaDados IN THIS-PROCEDURE.

run valida-parametros in this-procedure.

/** Mostra dados importados e erros **/
run displayDados in this-procedure.

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valida-parametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-parametros Procedure 
PROCEDURE valida-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-cont1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNrEqpto     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNrEqptoReal AS INTEGER    NO-UNDO.

if tt-param.l-val-param then do:
    IF NOT CAN-FIND(FIRST param-global NO-LOCK) THEN DO:
        {utp/ut-liter.i "Parƒmetros Globais nÆo cadastrados" *}
        ASSIGN c-liter1 = RETURN-VALUE.
        {utp/ut-liter.i Parƒmetros *}
        ASSIGN c-liter2 = RETURN-VALUE.
        {utp/ut-liter.i EMS *}
        ASSIGN c-liter3 = RETURN-VALUE.
        CREATE tt-dados.
        ASSIGN tt-dados.linha     = 0
               tt-dados.erro      = 0
               tt-dados.descricao = c-liter1
               tt-dados.tabela    = c-liter2
               tt-dados.MODULO    = c-liter3
               i-contador-geral   = i-contador-geral + 1
               tt-dados.i-chave   = i-contador-geral.
    END.
    else do:
        for first param-global no-lock:
            /**-- M¢dulo de Manuten‡Æo Industrial --**/
            IF NOT CAN-FIND(FIRST param-mi NO-LOCK) THEN DO:
                CREATE param-mi.
                VALIDATE param-mi.
                {utp/ut-liter.i "Parƒmetros MI cadastrados com sucesso" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 1
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
            else do:
                {utp/ut-liter.i "Parƒmetros MI validados com sucesso" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 1
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
    
    
            /**-- M¢dulo de Produ‡Æo --**/
            IF NOT CAN-FIND(FIRST param-cp NO-LOCK) THEN DO:
                CREATE param-cp.
                VALIDATE param-cp.
                {utp/ut-liter.i "Parƒmetros Produ‡Æo cadastrados com sucesso" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 1
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
            else do:
                {utp/ut-liter.i "Parƒmetros Produ‡Æo validados com sucesso" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 1
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
    
    
            /**-- M¢dulo de Custos --**/
            if param-global.modulo-cs = yes then do:
                IF NOT CAN-FIND(FIRST param-cs NO-LOCK) THEN DO:
                    {utp/ut-liter.i "Parƒmetros Custos nÆo cadastrados" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
                else do:
                    {utp/ut-liter.i "Parƒmetros Custos validados com sucesso" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
            end.
            else do:
                {utp/ut-liter.i "M¢dulo Custos nÆo implantado" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 0
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
    
            
            /**-- M¢dulo de Compras --**/
            if param-global.modulo-cc = yes then do:
                IF NOT CAN-FIND(FIRST param-compra NO-LOCK) THEN DO:
                    {utp/ut-liter.i "Parƒmetros Compras nÆo cadastrados" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
                else do:
                    {utp/ut-liter.i "Parƒmetros Compras validados com sucesso" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
            end.
            else do:
                {utp/ut-liter.i "M¢dulo Compras nÆo implantado" *}
                ASSIGN c-liter1 = RETURN-VALUE.
                {utp/ut-liter.i Parƒmetros *}
                ASSIGN c-liter2 = RETURN-VALUE.
                {utp/ut-liter.i EMS *}
                ASSIGN c-liter3 = RETURN-VALUE.
                CREATE tt-dados.
                ASSIGN tt-dados.linha     = 1
                       tt-dados.erro      = 0
                       tt-dados.descricao = c-liter1
                       tt-dados.tabela    = c-liter2
                       tt-dados.MODULO    = c-liter3
                       i-contador-geral   = i-contador-geral + 1
                       tt-dados.i-chave   = i-contador-geral.
            end.
    
            /**-- Parƒmetros de Estoque --**/
            if param-global.modulo-ce = yes then do:
                IF NOT CAN-FIND(FIRST param-estoq NO-LOCK) THEN DO:
                    {utp/ut-liter.i "Parƒmetros Estoque nÆo cadastrados" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
                else do:
                    {utp/ut-liter.i "Parƒmetros Estoque validados com sucesso" *}
                    ASSIGN c-liter1 = RETURN-VALUE.
                    {utp/ut-liter.i Parƒmetros *}
                    ASSIGN c-liter2 = RETURN-VALUE.
                    {utp/ut-liter.i EMS *}
                    ASSIGN c-liter3 = RETURN-VALUE.
                    CREATE tt-dados.
                    ASSIGN tt-dados.linha     = 1
                           tt-dados.erro      = 0
                           tt-dados.descricao = c-liter1
                           tt-dados.tabela    = c-liter2
                           tt-dados.MODULO    = c-liter3
                           i-contador-geral   = i-contador-geral + 1
                           tt-dados.i-chave   = i-contador-geral.
                end.
            end.
    
        end.
        {utp/ut-liter.i "Parƒmetros Globais validados com sucesso" *}
        ASSIGN c-liter1 = RETURN-VALUE.
        {utp/ut-liter.i Parƒmetros *}
        ASSIGN c-liter2 = RETURN-VALUE.
        {utp/ut-liter.i EMS *}
        ASSIGN c-liter3 = RETURN-VALUE.
        CREATE tt-dados.
        ASSIGN tt-dados.linha     = 1
               tt-dados.erro      = 0
               tt-dados.descricao = c-liter1
               tt-dados.tabela    = c-liter2
               tt-dados.MODULO    = c-liter3
               i-contador-geral   = i-contador-geral + 1
               tt-dados.i-chave   = i-contador-geral.
    end.

    DO i-cont1 = 1 TO 7:
        RUN cdp/cd9902.p (INPUT i-cont1).
        IF RETURN-VALUE = "OK":U THEN DO:
            {utp/ut-liter.i "implantado" *}
        END.
        ELSE DO:
            {utp/ut-liter.i "nÆo implantado" *}
        END.
        ASSIGN c-liter1 = RETURN-VALUE.
        CASE i-cont1:
            WHEN 1 THEN DO:
                {utp/ut-liter.i "Abastecimento e Lubrifica‡Æo" *}
            END.
            WHEN 2 THEN DO:
                {utp/ut-liter.i "Pneus" *}
            END.
            WHEN 3 THEN DO:
                {utp/ut-liter.i "Manuten‡Æo Mecƒnica" *}
            END.
            WHEN 4 THEN DO:
                {utp/ut-liter.i "Componentes" *}
            END.
            WHEN 5 THEN DO:
                {utp/ut-liter.i "Gerencial Frotas" *}
            END.
            WHEN 6 THEN DO:
                {utp/ut-liter.i "An lise de àleos Lubrificantes da Frota" *}
            END.
            WHEN 7 THEN DO:
                {utp/ut-liter.i "Manuten‡Æo de Documentos da Frota" *}
            END.
        END CASE.
        ASSIGN c-liter1 = RETURN-VALUE + " " + c-liter1.
        {utp/ut-liter.i M¢dulos *}
        ASSIGN c-liter2 = RETURN-VALUE.
        {utp/ut-liter.i FROTAS *}
        ASSIGN c-liter3 = RETURN-VALUE.
        CREATE tt-dados.
        ASSIGN tt-dados.linha     = 1
               tt-dados.erro      = 0
               tt-dados.descricao = c-liter1
               tt-dados.tabela    = c-liter2
               tt-dados.MODULO    = c-liter3
               i-contador-geral   = i-contador-geral + 1
               tt-dados.i-chave   = i-contador-geral.
    END.

    ASSIGN iNrEqpto     = 0
           iNrEqptoReal = 0.
    FOR FIRST mab-param
        WHERE mab-param.cdn-param = 1 NO-LOCK:
        ASSIGN iNrEqpto = mab-param.num-livre-1.
    END.

    FOR EACH  mab-eqpto
        WHERE mab-eqpto.dat-situacao  = ?
        AND   mab-eqpto.idi-tip-eqpto = 1 NO-LOCK:
        ASSIGN iNrEqptoReal = iNrEqptoReal + 1.
    END.

    {utp/ut-liter.i "N£mero m ximo de equipamentos controlados" *}
    ASSIGN c-liter1 = RETURN-VALUE + ": " + STRING(iNrEqpto).
    {utp/ut-liter.i "N£mero de equipamentos cadastrados no sistema" *}
    ASSIGN c-liter1 = c-liter1 + "     " + RETURN-VALUE + ": " + STRING(iNrEqptoReal).
    {utp/ut-liter.i M¢dulos *}
    ASSIGN c-liter2 = RETURN-VALUE.
    {utp/ut-liter.i FROTAS *}
    ASSIGN c-liter3 = RETURN-VALUE.
    CREATE tt-dados.
    ASSIGN tt-dados.linha     = 1
           tt-dados.erro      = 0
           tt-dados.descricao = c-liter1
           tt-dados.tabela    = c-liter2
           tt-dados.MODULO    = c-liter3
           i-contador-geral   = i-contador-geral + 1
           tt-dados.i-chave   = i-contador-geral.



end.
                    
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

