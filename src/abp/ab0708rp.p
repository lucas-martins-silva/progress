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
{include/i-prgvrs.i AB0708RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0708rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: ab0708rp.p
**
**       DATA....: Dezembro/2005
**
**       AUTOR...: Lauro Augusto G. Oliveira - KSM39058
**
**       OBJETIVO: Importa‡Æo Cadastros Frota
**
*****************************************************************************/

/****************************************************************************/

/** Defini‡Æo das temp-tables **/

/** Temp-Table de Parƒmetros **/
{abp/ab0708.i1}

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    field ErrorDump        as character
    index seq ErrorSequence.

DEFINE TEMP-TABLE tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

/*include*/

{abp/ab9004.i}            /* Temp-Table RowErrors */
{abp/ab0708.i3}

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.
/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.
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

{include/i-rpvar.i}  
{abp/ab0708.i}  /** Cabe‡alho e Forms **/

define new global shared variable v_log_eai_habilit as log no-undo.
DEFINE VARIABLE l-altera-eai AS LOGICAL    NO-UNDO.

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
         HEIGHT             = 8.75
         WIDTH              = 32.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
if v_log_eai_habilit then
    assign v_log_eai_habilit = no
           l-altera-eai      = yes.
else
    assign l-altera-eai = no.

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.

/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i }

if l-altera-eai then
    assign v_log_eai_habilit = yes.

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDados Procedure 
PROCEDURE displayDados :
/*------------------------------------------------------------------------------
  Purpose:     displayDados
  Parameters:  <none>
  Notes:       Mostra os dados da importa‡Æo e seus respectivos erros.
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-tabelaAtual   AS CHARACTER FORMAT "x(50)":U  NO-UNDO.
DEFINE VARIABLE c-moduloAtual   AS CHARACTER FORMAT "x(50)":U  NO-UNDO.
DEFINE VARIABLE c-liter-mod     AS CHARACTER FORMAT "x(10)":U  NO-UNDO.
DEFINE VARIABLE l-prim-cad      AS LOGICAL   INITIAL YES       NO-UNDO.
DEFINE VARIABLE l-controllinha  AS LOGICAL   INITIAL YES       NO-UNDO.
DEFINE VARIABLE l-start-display AS LOGICAL   INITIAL YES       NO-UNDO.
DEFINE VARIABLE l-primeiro      AS LOGICAL   INITIAL YES       NO-UNDO.
DEFINE VARIABLE c-liter-erro    AS CHARACTER FORMAT "x(10)":U  NO-UNDO.
DEFINE VARIABLE c-aux           AS CHARACTER INITIAL "" FORMAT "x(30)":U NO-UNDO.

{utp/ut-liter.i M¢dulo *}
assign c-liter-mod = trim(RETURN-VALUE).
{utp/ut-liter.i Erro *}
ASSIGN c-liter-erro = trim(RETURN-VALUE).

/* IF tt-param.todos = 2 THEN /* rejeitados */                                     */
/*     FIND FIRST tt-dados USE-INDEX id WHERE tt-dados.erro <> 0 NO-LOCK NO-ERROR. */
/* ELSE                                                                            */
/*     FIND FIRST tt-dados USE-INDEX id NO-LOCK NO-ERROR.                          */
/*     IF AVAIL tt-dados THEN                                                      */
/*         ASSIGN c-tabelaAtual = tt-dados.tabela.                                 */
    
    FOR EACH tt-dados USE-INDEX id NO-LOCK:
        IF c-aux <> tt-dados.tabela  THEN DO:
            ASSIGN c-aux      = tt-dados.tabela
                   l-primeiro = YES.
            PUT SKIP(2).
        end.
        IF l-primeiro AND c-aux = tt-dados.tabela THEN DO:
            ASSIGN l-primeiro = NO.
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-tabela AS CHARACTER FORMAT "X(8)" NO-UNDO.
            {utp/ut-liter.i "Tabela" *}
            ASSIGN c-lbl-liter-tabela = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-tabela AT 9.
            PUT ": ":U AT 16.
            PUT tt-dados.des-tab AT 18.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-cadastro AS CHARACTER FORMAT "X(10)" NO-UNDO.
            {utp/ut-liter.i "Cadastro" *}
            ASSIGN c-lbl-liter-cadastro = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-cadastro AT 5.
            PUT ": ":U AT 16.
            PUT tt-dados.tabela AT 18.
            PUT SKIP(1).

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo AS CHARACTER FORMAT "X(8)" NO-UNDO.
            {utp/ut-liter.i "C¢digo" *}
            ASSIGN c-lbl-liter-codigo = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-codigo AT 1.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER FORMAT "X(11)" NO-UNDO.
            {utp/ut-liter.i "Descri‡Æo" *}
            ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-descricao  AT 10.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-erro AS CHARACTER FORMAT "X(6)" NO-UNDO.
            {utp/ut-liter.i "Erro" *}
            ASSIGN c-lbl-liter-erro = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-erro  AT 54.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-do-erro AS CHARACTER FORMAT "X(19)" NO-UNDO.
            {utp/ut-liter.i "Descri‡Æo_do_erro" *}
            ASSIGN c-lbl-liter-descricao-do-erro = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-descricao-do-erro AT 63.
            PUT SKIP.

            PUT "--------":U AT 1.
            PUT "-------------------------------------------":U AT 10.
            PUT "--------":U AT 54.
            PUT "-------------------------------------------------":U AT 63.
            PUT SKIP(1).

        end.
        
        DISP tt-dados.cod-tabela
             tt-dados.des-tabela
             tt-dados.erro
             tt-dados.descricao
            WITH FRAME f-dados1.
        DOWN WITH FRAME f-dados1.

        put SKIP.
    end.

    RETURN "OK":U.
 
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
        /* "ABASTECIMENTO E LUBRIFICA€ÇO"*/ 
        /* "Cadastros"*/
        tt-param.l-mab-ativid           
        tt-param.l-mab-trajeto          
        tt-param.l-mab-caract           
        tt-param.l-mab-comptmento       
        tt-param.l-mab-estrut-mec       
        tt-param.l-mab-sist             
        tt-param.l-mab-sub-sist         
        tt-param.l-mab-sit-eqpto        
        tt-param.l-mab-grp-eqpto        
        tt-param.l-mab-posto            
        tt-param.l-mab-bomba            
        tt-param.l-mab-tip-mater        
        tt-param.l-mab-tip-mater-item 
        tt-param.l-mab-integr-cargo
        /* "Modelo"*/
        tt-param.l-mab-marca            
        tt-param.l-mab-model            
        tt-param.l-mab-consu-model      
        tt-param.l-mmv-tempo-padr     
         /* "Evento"*/
        tt-param.l-mab-grp-event        
        tt-param.l-mab-event            
        /* "Motorista"*/
        tt-param.l-mab-motoris          
        tt-param.l-mab-motoris-model 
       /*"MANUTEN€ÇO MEC¶NICA"           
          "Cadastros"*/
        tt-param.l-mmv-ofici            
        tt-param.l-mmv-setor-ofici      
        tt-param.l-mmv-func-ofici       
        tt-param.l-mmv-plano-prevent    
        tt-param.l-mmv-tar-plano        
        tt-param.l-mmv-tar-plano-item   
        /*"PNEUS"                         
          "Cadastros"*/
        tt-param.l-mpn-tip-borracha     
        tt-param.l-mpn-medid            
        tt-param.l-mpn-pos-pneu         
        tt-param.l-mpn-layout           
        tt-param.l-mpn-layout-eixo-pos  
        tt-param.l-mpn-ambien-trab      
        tt-param.l-mpn-serv             
        tt-param.l-mpn-desen            
        tt-param.l-mpn-km-esperad       
        tt-param.l-mpn-model            
        /*"Pneu"*/
        tt-param.l-mpn-pneu             
        tt-param.l-mpn-histor-vida  
        /*"OUTROS"                        
          "Componentes"*/
        tt-param.l-mco-compon           
        tt-param.l-mco-histor-vida      
        /*"EQUIPAMENTO"*/
        /*"Cadastros"*/
        tt-param.l-mab-eqpto             
        tt-param.l-mab-histor-ativid     
        tt-param.l-mab-histor-combust    
        tt-param.l-mab-comptmento-eqpto  
        tt-param.l-mab-period-manut      
        tt-param.l-mab-configur-eixo     
        tt-param.l-mmv-eqpto-plano       
        tt-param.l-mpn-histor-layout-eixo
        tt-param.l-mab-eqpto-sub-sist   
        /*LOG*/                                                 
        c-imprime            
        c-destino     
        SUBSTRING(tt-param.arq-destino,1,75) @ c-arq-destino
        tt-param.dir-entrada
        c-execucao
        tt-param.usuario
    WITH FRAME f-param-definidos.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piEstabelXNOP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEstabelXNOP Procedure 
PROCEDURE piEstabelXNOP :
/*------------------------------------------------------------------------------
  Purpose:     piEstabelXNOP
  Parameters:  <none>
  Notes:       Realiza a importa‡Æo do de-para de estabelecimento x NOP
------------------------------------------------------------------------------*/
for each tt-estabelec exclusive-lock:
    delete tt-estabelec.
end.

/** De-para **/
if tt-param.l-de-para then do:
    INPUT FROM VALUE(tt-param.arq-estabel) CONVERT SOURCE "ISO8859-1".
    REPEAT:  
        CREATE tt-estabelec.
        IMPORT DELIMITER ";" tt-estabelec no-error.  
    END. /*repeat*/
    input close.
end.

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
/** P gina 1 **/
/** Abastecimento / Lubrifica‡Æo - 1a parte **/
RUN abp/ab0708a.p  (INPUT        TABLE tt-param,
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).


/** Abastecimento / Lubrifica‡Æo - 2a parte **/
RUN abp/ab0708b.p  (INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

/** P gina 2 **/
/** Manuten‡Æo Mecƒnica **/
RUN cdp/cd9902.p (INPUT 3). /* verifica se m¢dulo est  implantado */
IF RETURN-VALUE = "OK":U then do:
    RUN abp/ab0708c.p  (INPUT        TABLE tt-param, 
                        INPUT-OUTPUT TABLE tt-dados,
                        INPUT        h-acomp).
end.

/** P gina 3 **/
/** Pneus **/
RUN cdp/cd9902.p (INPUT 2).
IF RETURN-VALUE = "OK":U then do:
    RUN abp/ab0708d.p  (INPUT        TABLE tt-param, 
                        INPUT-OUTPUT TABLE tt-dados,
                        INPUT        h-acomp).
end.

/** P gina 4 **/
/** Outros **/
RUN abp/ab0708e.p  (INPUT        TABLE tt-param, 
                    INPUT-OUTPUT TABLE tt-dados,
                    INPUT        h-acomp).

/** P gina 5 **/
/** Equipamentos **/
RUN abp/ab0708f.p  (INPUT        TABLE tt-param, 
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
assign c-programa = "AB/0708"
       c-versao   = "2.00"
       c-revisao  = "000".

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Importa‡Æo Cadastros" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "FROTAS" *}
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
  Notes:       Corpo principal da aplica‡Æo
------------------------------------------------------------------------------*/
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/** Inicializa programa de acompanhamento padrÆo Datasul **/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT c-titulo-relat).
/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/
run piEstabelXNOP in this-procedure.

RUN piImportaDados IN THIS-PROCEDURE.
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

