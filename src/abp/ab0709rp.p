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
{include/i-prgvrs.i AB0709RP 2.00.00.007}  /*** "010007" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0709rp MAB}
&ENDIF


{include/i_fnctrad.i}
{include/i_dbtype.i}  /** Define o tipo de banco de dados **/
/*****************************************************************************
**
**       PROGRAMA: AB0709RP.p
**
**       DATA....: Dezembro/2005
**
**       AUTOR...: DIOGO EVANGELISTA MAIA ksm39059 
**
**       OBJETIVO: Exporta‡Æo Cadastros Basicos Frotas
**
*****************************************************************************/

/****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
/** CHAMA TEMP TABLE PARAMETROS**/
{abp/ab0709.i1}

{abp/ab9004.i}            /* Temp-Table RowErrors */

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
define variable h-acomp              as handle     no-undo.
DEFINE VARIABLE c-imprime            AS CHARACTER  FORMAT "x(15)":U NO-UNDO.
DEFINE VARIABLE c-destino            AS CHARACTER  FORMAT "x(20)":U NO-UNDO.
DEFINE VARIABLE c-execucao           AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-campos             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tam                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-caminho            AS CHARACTER  NO-UNDO.

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
{abp/ab0709.i}

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

&IF DEFINED(EXCLUDE-displayDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDados Procedure 
PROCEDURE displayDados :
/*------------------------------------------------------------------------------
  Purpose:     displayDados
  Parameters:  <none>
  Notes:       Mostra os dados da Exporta‡Æo e seus respectivos erros.
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

/* define buffer bf-tt-dados for tt-dados. */

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

 DISPLAY 
/*  "PAR¶METROS"                   */
/*  "ABASTECIMENTO E LUBRIFICA€ÇO" */
/*  "EMS"                          */
/*  "Cadastros"                    */
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

&IF DEFINED(EXCLUDE-piBuscaDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaDados Procedure 
PROCEDURE piBuscaDados :
/*------------------------------------------------------------------------------
  Purpose:     piBuscaDados  
  Parameters:  <none>
  Notes:       Gerar cabe‡alho (contento os campos da tabela) no arquivo exportado.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER c-dump AS CHARACTER  NO-UNDO.
ASSIGN c-campos = "".
    
IF tt-param.l-tg-gerar-cabecalho = NO THEN RETURN "OK":U.

&IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN 
    FOR FIRST shmgfro._file
        WHERE shmgfro._file._dump-name = c-dump 
        AND   shmgfro._file._hidden    = NO NO-LOCK:
        FOR EACH  shmgfro._field 
            WHERE shmgfro._field._file-recid = recid(shmgfro._file) NO-LOCK 
            BY   shmgfro._field._order:
            IF shmgfro._field._label = 'Livre 1':U OR 
               shmgfro._field._label = 'Livre 2':U THEN DO:
                ASSIGN c-campos = c-campos + ";" + trim(shmgfro._field._field-name).
            END.
            ELSE 
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(shmgfro._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(shmgfro._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ELSE 
    FOR FIRST mgfro._file
        WHERE mgfro._file._dump-name = c-dump 
        AND   mgfro._file._hidden    = NO NO-LOCK:
        FOR EACH  mgfro._field 
            WHERE mgfro._field._file-recid = recid(mgfro._file) NO-LOCK 
            BY   mgfro._field._order:
            IF mgfro._field._label = 'Livre 1':U OR 
               mgfro._field._label = 'Livre 2':U THEN DO:
                ASSIGN c-campos = c-campos + ";" + trim(mgfro._field._field-name).
            END.
            ELSE 
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(mgfro._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(mgfro._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ENDIF

PUT c-campos FORMAT c-tam.
PUT SKIP.

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

PROCEDURE piBuscaDadosMnt :
/*------------------------------------------------------------------------------
  Purpose:     piBuscaDados  
  Parameters:  <none>
  Notes:       Gerar cabe‡alho (contento os campos da tabela) no arquivo exportado.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER c-dump AS CHARACTER  NO-UNDO.
ASSIGN c-campos = "".
    
IF tt-param.l-tg-gerar-cabecalho = NO THEN RETURN "OK":U.

&IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN 
    FOR FIRST shmgmnt._file
        WHERE shmgmnt._file._dump-name = c-dump 
        AND   shmgmnt._file._hidden    = NO NO-LOCK:
        FOR EACH  shmgmnt._field 
            WHERE shmgmnt._field._file-recid = recid(shmgmnt._file) NO-LOCK 
            BY   shmgmnt._field._order:

            IF shmgmnt._field._label = 'Livre 1':U OR 
               shmgmnt._field._label = 'Livre 2':U THEN DO:
            ASSIGN c-campos = c-campos + ";" + trim(shmgmnt._field._field-name).
            END.
            ELSE
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(shmgmnt._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(shmgmnt._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ELSE 
    FOR FIRST mgmnt._file
        WHERE mgmnt._file._dump-name = c-dump 
        AND   mgmnt._file._hidden    = NO NO-LOCK:
        FOR EACH  mgmnt._field 
            WHERE mgmnt._field._file-recid = recid(mgmnt._file) NO-LOCK 
            BY   mgmnt._field._order:

            IF mgmnt._field._label = 'Livre 1':U OR 
               mgmnt._field._label = 'Livre 2':U THEN DO:
            ASSIGN c-campos = c-campos + ";" + trim(mgmnt._field._field-name).
            END.
            ELSE
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(mgmnt._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(mgmnt._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ENDIF

PUT c-campos FORMAT c-tam.
PUT SKIP.

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&IF DEFINED(EXCLUDE-piExportaDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExportaDados Procedure 
PROCEDURE piExportaDados :
/*------------------------------------------------------------------------------
  Purpose:     piExportaDados
  Parameters:  <none>
  Notes:       Exporta dados das tabelas para arquivos .txt (p ginas 1, 2 e 3)
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-mpn-pneu_dsl-obs                   AS CHARACTER  NO-UNDO.

/* Exporta‡Æo p g 1 Abastecimento / Lubrificacao */
IF tt-param.l-mab-marca = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr015.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
    RUN piBuscaDados (INPUT "fr015").
        FOR EACH mab-marca NO-LOCK:
            EXPORT DELIMITER ";" mab-marca.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mab-model = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr016.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
    RUN piBuscaDados (INPUT "fr016").
        FOR EACH mab-model NO-LOCK:
            EXPORT DELIMITER ";" mab-model.
        END.
    OUTPUT CLOSE.
END.  
IF tt-param.l-mab-consu-model = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr006.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr006").
        FOR EACH mab-consu-model NO-LOCK:
            EXPORT DELIMITER ";" mab-consu-model.
        END.
    OUTPUT CLOSE.
END.  
IF tt-param.l-mmv-tempo-padr = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr078.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr078").
        FOR EACH mmv-tempo-padr  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tempo-padr.

        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mab-ativid = YES THEN DO:      
    ASSIGN c-caminho = tt-param.dir-entrada + "fr001.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr001").
        FOR EACH mab-ativid NO-LOCK:
            EXPORT DELIMITER ";" mab-ativid.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-trajeto = YES THEN DO:     
    ASSIGN c-caminho = tt-param.dir-entrada + "fr028.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr028").
        FOR EACH mab-trajeto  NO-LOCK:
            EXPORT DELIMITER ";" mab-trajeto.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-caract = YES THEN DO:              
    ASSIGN c-caminho = tt-param.dir-entrada + "fr098.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr098").
        FOR EACH mab-caract NO-LOCK:
            EXPORT DELIMITER ";" mab-caract.
        END.
    OUTPUT CLOSE.
END.  
IF tt-param.l-mab-comptmento = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr003.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr003").
        FOR EACH mab-comptmento NO-LOCK:
            EXPORT DELIMITER ";" mab-comptmento.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-estrut-mec = YES THEN DO:         
    ASSIGN c-caminho = tt-param.dir-entrada + "fr009.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr009").
        FOR EACH mab-estrut-mec NO-LOCK:
            EXPORT DELIMITER ";" mab-estrut-mec.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-sist = YES THEN DO:                
    ASSIGN c-caminho = tt-param.dir-entrada + "fr023.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr023").
        FOR EACH mab-sist NO-LOCK:
            EXPORT DELIMITER ";" mab-sist.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-sub-sist = YES THEN DO:           
    ASSIGN c-caminho = tt-param.dir-entrada + "fr025.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr025").
        FOR EACH mab-sub-sist  NO-LOCK:
            EXPORT DELIMITER ";" mab-sub-sist.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-sit-eqpto = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr024.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr024").
        FOR EACH mab-sit-eqpto  NO-LOCK:
            EXPORT DELIMITER ";" mab-sit-eqpto.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-grp-eqpto = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr011.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr011").
        FOR EACH mab-grp-eqpto NO-LOCK:
            EXPORT DELIMITER ";" mab-grp-eqpto.
        END.
    OUTPUT CLOSE. 
END.   
IF tt-param.l-mab-eqpto-sub-sist = YES THEN DO:     
    ASSIGN c-caminho = tt-param.dir-entrada + "fr008.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr008").
        FOR EACH mab-eqpto-sub-sist NO-LOCK:
            EXPORT DELIMITER ";" mab-eqpto-sub-sist.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-posto = YES THEN DO:              
    ASSIGN c-caminho = tt-param.dir-entrada + "fr021.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr021").
        FOR EACH mab-posto NO-LOCK:
            EXPORT DELIMITER ";" mab-posto.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-bomba = YES THEN DO:              
    ASSIGN c-caminho = tt-param.dir-entrada + "fr002.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr002").
        FOR EACH mab-bomba NO-LOCK:
            EXPORT DELIMITER ";" mab-bomba.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-tip-mater = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr026.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr026").
        FOR EACH mab-tip-mater  NO-LOCK:
            EXPORT DELIMITER ";" mab-tip-mater.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-tip-mater-item = YES THEN DO:     
    ASSIGN c-caminho = tt-param.dir-entrada + "fr027.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr027").
        FOR EACH mab-tip-mater-item  NO-LOCK:
            EXPORT DELIMITER ";" mab-tip-mater-item.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-grp-event = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr012.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr012").
        FOR EACH mab-grp-event NO-LOCK:
            EXPORT DELIMITER ";" mab-grp-event.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-event = YES THEN DO:              
    ASSIGN c-caminho = tt-param.dir-entrada + "fr010.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr010").
        FOR EACH mab-event NO-LOCK:
            EXPORT DELIMITER ";" mab-event.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-motoris = YES THEN DO:            
    ASSIGN c-caminho = tt-param.dir-entrada + "fr017.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr017").
        FOR EACH mab-motoris NO-LOCK:
            EXPORT DELIMITER ";" mab-motoris.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-motoris-model = YES THEN DO:      
    ASSIGN c-caminho = tt-param.dir-entrada + "fr018.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr018").
        FOR EACH mab-motoris-model NO-LOCK:
            EXPORT DELIMITER ";" mab-motoris-model.
        END.
    OUTPUT CLOSE.
END.   
IF tt-param.l-mab-integr-cargo = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr107.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr107").
        FOR EACH mab-integr-cargo NO-LOCK:
            EXPORT DELIMITER ";" mab-integr-cargo.
        END.
    OUTPUT CLOSE.
END.

/*Exporta‡Æo p g 2 Manuten‡Æo Mecanica*/
IF tt-param.l-mmv-param = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr034.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr034").
        FOR EACH mmv-param  NO-LOCK:
            EXPORT DELIMITER ";" mmv-param.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-ofici = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr033.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr033").
        FOR EACH mmv-ofici  NO-LOCK:
            EXPORT DELIMITER ";" mmv-ofici.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-setor-ofici = YES THEN DO:         
    ASSIGN c-caminho = tt-param.dir-entrada + "fr036.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr036").
        FOR EACH mmv-setor-ofici  NO-LOCK:
            EXPORT DELIMITER ";" mmv-setor-ofici.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-func-ofici = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr032.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr032").
        FOR EACH mmv-func-ofici  NO-LOCK:
            EXPORT DELIMITER ";" mmv-func-ofici.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-plandor = YES THEN DO:             
    ASSIGN c-caminho = tt-param.dir-entrada + "fr077.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr077").
        FOR EACH mmv-plandor  NO-LOCK:
            EXPORT DELIMITER ";" mmv-plandor.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-plano-prevent = YES THEN DO:       
    ASSIGN c-caminho = tt-param.dir-entrada + "fr035.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr035").
        FOR EACH mmv-plano-prevent  NO-LOCK:
            EXPORT DELIMITER ";" mmv-plano-prevent.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-tar-plano = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr037.txt".
        OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr037").
            FOR EACH mmv-tar-plano NO-LOCK:
                EXPORT DELIMITER ";" mmv-tar-plano.cod-model 
                    mmv-tar-plano.cod-plano 
                    mmv-tar-plano.num-seq 
                    mmv-tar-plano.cod-sub-sist 
                    mmv-tar-plano.cod-evento 
                    REPLACE(mmv-tar-plano.des-tarefa,CHR(10)," ~~~~ ")
                    mmv-tar-plano.val-tempo-padr
                    mmv-tar-plano.cod-setor-ofici 
                    mmv-tar-plano.cod-livre-1 
                    mmv-tar-plano.cod-livre-2 
                    mmv-tar-plano.log-livre-1 
                    mmv-tar-plano.log-livre-2 
                    mmv-tar-plano.num-livre-1 
                    mmv-tar-plano.num-livre-2 
                    mmv-tar-plano.val-livre-1 
                    mmv-tar-plano.val-livre-2 
                    mmv-tar-plano.dat-livre-1 
                    mmv-tar-plano.dat-livre-2.
                END.
            OUTPUT CLOSE.
END.
    IF tt-param.l-mmv-tar-plano-item = YES THEN DO:      
    ASSIGN c-caminho = tt-param.dir-entrada + "fr041.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr041").
        FOR EACH mmv-tar-plano-item  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-item.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-tar-plano-epi = YES THEN DO:       
    ASSIGN c-caminho = tt-param.dir-entrada + "fr038.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr038").
        FOR EACH mmv-tar-plano-epi  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-epi.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-tar-plano-ferram = YES THEN DO:    
    ASSIGN c-caminho = tt-param.dir-entrada + "fr039.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr039").
        FOR EACH mmv-tar-plano-ferram  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-ferram.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mmv-tar-plano-ficha = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr040.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr040").
        FOR EACH mmv-tar-plano-ficha  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-ficha.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-tar-plano-esp = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr00145.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr00145").
        FOR EACH mmv-tar-plano-especialid  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-especialid.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-tar-plano-esp-curso = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr00146.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr00146").
        FOR EACH mmv-tar-plano-esp-curso  NO-LOCK:
            EXPORT DELIMITER ";" mmv-tar-plano-esp-curso.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mi-espec = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "mn112.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDadosMnt (INPUT "mn112").
        FOR EACH mi-espec  NO-LOCK:
            EXPORT DELIMITER ";" mi-espec.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mi-curso-trein = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "mn267.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDadosMnt (INPUT "mn267").
        FOR EACH mi-curso-trein  NO-LOCK:
            EXPORT DELIMITER ";" mi-curso-trein.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mi-turno = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "mn015.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDadosMnt (INPUT "mn015").
        FOR EACH mi-turno  NO-LOCK:
            EXPORT DELIMITER ";" mi-turno.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mi-turno-ciclo = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "mn016.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDadosMnt (INPUT "mn016").
        FOR EACH mi-turno-ciclo  NO-LOCK:
            EXPORT DELIMITER ";" mi-turno-ciclo.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-func-turno = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr00142.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr00142").
        FOR EACH mmv-func-turno  NO-LOCK:
            EXPORT DELIMITER ";" mmv-func-turno.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-func-curso-trein = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr144.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr00144").
        FOR EACH mmv-func-curso-trein  NO-LOCK:
            EXPORT DELIMITER ";" mmv-func-curso-trein.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-func-especialid = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr00143.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr00143").
        FOR EACH mmv-func-especialid  NO-LOCK:
            EXPORT DELIMITER ";" mmv-func-especialid.
        END.
    OUTPUT CLOSE.
END.

/*Exporta‡Æo p g 3 Pneus*/
IF tt-param.l-mpn-param  = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr094.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr094").
        FOR EACH mpn-param  NO-LOCK:
            EXPORT DELIMITER ";" mpn-param.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-tip-borracha  = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr054.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr054").
        FOR EACH mpn-tip-borracha NO-LOCK:
            EXPORT DELIMITER ";" mpn-tip-borracha.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-medid = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr049.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr049").
        FOR EACH mpn-medid NO-LOCK:
            EXPORT DELIMITER ";" mpn-medid.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-pos-pneu = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr052.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr052").
        FOR EACH mpn-pos-pneu NO-LOCK:
            EXPORT DELIMITER ";" mpn-pos-pneu.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-layout = YES THEN DO:              
    ASSIGN c-caminho = tt-param.dir-entrada + "fr047.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr047").
        FOR EACH mpn-layout NO-LOCK:
            EXPORT DELIMITER ";" mpn-layout.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-layout-eixo-pos = YES THEN DO:     
    ASSIGN c-caminho = tt-param.dir-entrada + "fr048.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr048").
        FOR EACH mpn-layout-eixo-pos NO-LOCK:
            EXPORT DELIMITER ";" mpn-layout-eixo-pos.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-ambien-trab = YES THEN DO:         
    ASSIGN c-caminho = tt-param.dir-entrada + "fr042.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr042").
        FOR EACH mpn-ambien-trab  NO-LOCK:
            EXPORT DELIMITER ";" mpn-ambien-trab.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-serv = YES THEN DO:                
    ASSIGN c-caminho = tt-param.dir-entrada + "fr053.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr053").
        FOR EACH mpn-serv NO-LOCK:
            EXPORT DELIMITER ";" mpn-serv.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-tip-serv = YES THEN DO:            
    ASSIGN c-caminho = tt-param.dir-entrada + "fr124.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr124").
        FOR EACH mpn-tip-serv  NO-LOCK:
            EXPORT DELIMITER ";" mpn-tip-serv.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-desen = YES THEN DO:               
    ASSIGN c-caminho = tt-param.dir-entrada + "fr043.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr043").
        FOR EACH mpn-desen  NO-LOCK:
            EXPORT DELIMITER ";" mpn-desen.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-km-esperad = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr046.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr046").
        FOR EACH mpn-km-esperad NO-LOCK:
            EXPORT DELIMITER ";" mpn-km-esperad.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-model = YES THEN DO:               
    ASSIGN c-caminho = tt-param.dir-entrada + "fr050.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr050").
        FOR EACH mpn-model NO-LOCK:
            EXPORT DELIMITER ";" mpn-model.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mpn-pneu = YES THEN DO:                
    ASSIGN c-caminho = tt-param.dir-entrada + "fr051.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr051").
        FOR EACH mpn-pneu NO-LOCK:
            ASSIGN c-mpn-pneu_dsl-obs = replace (mpn-pneu.dsl-obs,chr(10)," ").
            EXPORT DELIMITER ";" mpn-pneu.cod-pneu
                                 mpn-pneu.des-serie
                                 mpn-pneu.cod-model-pneu
                                 mpn-pneu.cod-medid
                                 mpn-pneu.dat-inicial
                                 mpn-pneu.num-vida-inicial
                                 mpn-pneu.num-vida-histor
                                 mpn-pneu.ep-codigo-inicial
                                 mpn-pneu.cod-eqpto-inicial
                                 mpn-pneu.cod-pos-inicial
                                 mpn-pneu.cod-estabel-inicial
                                 mpn-pneu.ep-codigo-atual
                                 mpn-pneu.cod-eqpto-atual
                                 mpn-pneu.cod-pos-atual
                                 mpn-pneu.cod-estabel-atual
                                 mpn-pneu.num-vida-atual
                                 mpn-pneu.val-uso-atual
                                 mpn-pneu.cod-sit-pneu-inicial
                                 mpn-pneu.cod-sit-pneu-atual
                                 mpn-pneu.dat-situacao
                                 mpn-pneu.hra-situacao
                                 mpn-pneu.val-sulco-inicial
                                 mpn-pneu.val-sulco-1
                                 mpn-pneu.val-sulco-2
                                 mpn-pneu.val-sulco-3
                                 mpn-pneu.val-sulco-4
                                 mpn-pneu.val-sulco-5
                                 mpn-pneu.val-sulco-6
                                 mpn-pneu.val-sulco-7
                                 mpn-pneu.val-sulco-8
                                 mpn-pneu.val-sulco-9
                                 mpn-pneu.val-sulco-10
                                 c-mpn-pneu_dsl-obs
                                 mpn-pneu.dat-atualiz
                                 mpn-pneu.cd-causa-padr
                                 mpn-pneu.cod-usuar
                                 mpn-pneu.ep-codigo-pneu
                                 mpn-pneu.cod-livre-1
                                 mpn-pneu.cod-livre-2
                                 mpn-pneu.log-livre-1
                                 mpn-pneu.log-livre-2
                                 mpn-pneu.num-livre-1
                                 mpn-pneu.num-livre-2
                                 mpn-pneu.val-livre-1
                                 mpn-pneu.val-livre-2
                                 mpn-pneu.dat-livre-1
                                 mpn-pneu.dat-livre-2
                                 mpn-pneu.it-codigo
                                 mpn-pneu.cod-tip-serv.
        END.
    OUTPUT CLOSE.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piExportaDados2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExportaDados2 Procedure 
PROCEDURE piExportaDados2 :
/*------------------------------------------------------------------------------
  Purpose:     piExportadados2
  Parameters:  <none>
  Notes:       Exporta dados das tabelas para arquivos .txt (p ginas 4 e 5)
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-mco-compon_dsl-obs                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-ens-padr_dsl-obs-troca             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-maoenspadr_dslobs-n-troc           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-mao-ensaio-padr_dsl-obs            AS CHARACTER  NO-UNDO.

IF tt-param.l-mpn-histor-vida = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr045.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr045").
        FOR EACH mpn-histor-vida  NO-LOCK:
            EXPORT DELIMITER ";" mpn-histor-vida.
        END.
    OUTPUT CLOSE.
END.

/*Exporta‡Æo p g 4 Outros*/
IF tt-param.l-mco-compon = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr029.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr029").
        FOR EACH mco-compon  NO-LOCK:
            ASSIGN c-mco-compon_dsl-obs = replace (mco-compon.dsl-obs,chr(10)," ").
            EXPORT DELIMITER ";" mco-compon.num-seqcial
                                 mco-compon.cod-sub-sist
                                 mco-compon.des-serie
                                 mco-compon.cod-compon
                                 mco-compon.cod-model
                                 mco-compon.des-model
                                 mco-compon.cod-localiz-compon
                                 mco-compon.dat-inicial
                                 mco-compon.ep-codigo-inicial
                                 mco-compon.cod-eqpto-inicial
                                 mco-compon.cod-estabel-inicial
                                 mco-compon.ep-codigo-atual
                                 mco-compon.cod-eqpto-atual
                                 mco-compon.cod-estabel-atual
                                 mco-compon.val-uso-atual
                                 mco-compon.num-vida-inicial
                                 mco-compon.num-vida-atual
                                 mco-compon.num-vida-histor
                                 mco-compon.cod-sit-compon-inicial
                                 mco-compon.cod-sit-compon-atual
                                 mco-compon.dat-situacao
                                 mco-compon.dat-atualiz
                                 mco-compon.it-codigo
                                 mco-compon.ct-codigo
                                 mco-compon.cc-codigo
                                 c-mco-compon_dsl-obs
                                 mco-compon.cod-item-reformad
                                 mco-compon.bm-codigo
                                 mco-compon.bm-indice
                                 mco-compon.cod-livre-1
                                 mco-compon.cod-livre-2
                                 mco-compon.log-livre-1
                                 mco-compon.log-livre-2
                            &IF "{&mguni_version}" >= "2.071" &THEN
                                 mco-compon.ep-codigo
                            &ELSE
                                 mco-compon.num-livre-1
                            &ENDIF
                                 mco-compon.num-livre-2
                                 mco-compon.val-livre-1
                                 mco-compon.val-livre-2
                                 mco-compon.dat-livre-1
                                 mco-compon.dat-livre-2
                                 mco-compon.cod-cta-pat
                                 mco-compon.cc-codigo-atual
                                 mco-compon.ep-codigo.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mco-histor-vida = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr030.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr030").
        FOR EACH mco-histor-vida  NO-LOCK:
            EXPORT DELIMITER ";" mco-histor-vida.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mco-plano-compon = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr100.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr100").
        FOR EACH mco-plano-compon  NO-LOCK:
            EXPORT DELIMITER ";" mco-plano-compon.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mab-tab-restdo = YES THEN DO:    
    ASSIGN c-caminho = tt-param.dir-entrada + "fr102.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr102").
        FOR EACH mab-tab-restdo  NO-LOCK:
            EXPORT DELIMITER ";" mab-tab-restdo.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mab-restdo-tab = YES THEN DO:    
    ASSIGN c-caminho = tt-param.dir-entrada + "fr101.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr101").
        FOR EACH mab-restdo-tab NO-LOCK:
            EXPORT DELIMITER ";" mab-restdo-tab.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mao-ensaio = YES THEN DO:        
    ASSIGN c-caminho = tt-param.dir-entrada + "fr103.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr103").
        FOR EACH mao-ensaio  NO-LOCK:
            EXPORT DELIMITER ";" mao-ensaio.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mao-ensaio-padr = YES THEN DO:   
    ASSIGN c-caminho = tt-param.dir-entrada + "fr104.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr104").
        FOR EACH mao-ensaio-padr  NO-LOCK:
            ASSIGN c-ens-padr_dsl-obs-troca   = replace (mao-ensaio-padr.dsl-obs-troca,chr(10)," ").
            ASSIGN c-maoenspadr_dslobs-n-troc = replace (mao-ensaio-padr.dsl-obs-nao-troca,chr(10)," ").
            ASSIGN c-mao-ensaio-padr_dsl-obs  = replace (mao-ensaio-padr.dsl-obs,chr(10)," ").
            EXPORT DELIMITER ";" mao-ensaio-padr.cod-tip-mater
                                 mao-ensaio-padr.cod-model
                                 mao-ensaio-padr.cod-ensaio
                                 mao-ensaio-padr.log-padrao
                                 mao-ensaio-padr.des-formato
                                 mao-ensaio-padr.des-val-min
                                 mao-ensaio-padr.des-val-max
                                 mao-ensaio-padr.num-tabela
                                 mao-ensaio-padr.cod-event-troca
                                 c-ens-padr_dsl-obs-troca
                                 c-maoenspadr_dslobs-n-troc
                                 mao-ensaio-padr.dsl-obs-nao-troca
                                 c-mao-ensaio-padr_dsl-obs
                                 mao-ensaio-padr.cod-livre-1
                                 mao-ensaio-padr.cod-livre-2
                                 mao-ensaio-padr.log-livre-1
                                 mao-ensaio-padr.log-livre-2
                                 mao-ensaio-padr.num-livre-1
                                 mao-ensaio-padr.num-livre-2
                                 mao-ensaio-padr.val-livre-1
                                 mao-ensaio-padr.val-livre-2
                                 mao-ensaio-padr.dat-livre-1
                                 mao-ensaio-padr.dat-livre-2.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mab-usuar-frota = YES THEN DO:   
    ASSIGN c-caminho = tt-param.dir-entrada + "fr114.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr114").
        FOR EACH mab-usuar-frota  NO-LOCK:
            EXPORT DELIMITER ";" mab-usuar-frota.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-usuar-estab = YES THEN DO:     
    ASSIGN c-caminho = tt-param.dir-entrada + "fr123.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr123").
        FOR EACH mab-usuar-estab  NO-LOCK:
            EXPORT DELIMITER ";" mab-usuar-estab.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mnd-proces-administ = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr109.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr109").
        FOR EACH mnd-proces-administ  NO-LOCK:
            EXPORT DELIMITER ";" mnd-proces-administ.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mgf-param = YES THEN DO:    
    ASSIGN c-caminho = tt-param.dir-entrada + "fr092.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr092").
        FOR EACH mgf-param  NO-LOCK:
            EXPORT DELIMITER ";" mgf-param.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mgf-event-param = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr079.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr079").
        FOR EACH mgf-event-param  NO-LOCK:
            EXPORT DELIMITER ";" mgf-event-param.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mgf-event-grp-eqpto = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr080.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr080").
        FOR EACH mgf-event-grp-eqpto  NO-LOCK:
            EXPORT DELIMITER ";" mgf-event-grp-eqpto.
        END.
    OUTPUT CLOSE.
END.
IF tt-param.l-mgf-grp-estoq = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr091.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr091").
        FOR EACH mgf-grp-estoq  NO-LOCK:
            EXPORT DELIMITER ";" mgf-grp-estoq.
        END.
    OUTPUT CLOSE.
END.

/*Exporta‡Æo p g 5 Equipamentos*/
IF tt-param.l-mab-eqpto = YES THEN DO:               
    ASSIGN c-caminho = tt-param.dir-entrada + "fr007.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr007").
        FOR EACH mab-eqpto NO-LOCK:
            EXPORT DELIMITER ";" mab-eqpto.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-histor-ativid = YES THEN DO:         
    ASSIGN c-caminho = tt-param.dir-entrada + "fr013.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr013").
        FOR EACH mab-histor-ativid NO-LOCK:
            EXPORT DELIMITER ";" mab-histor-ativid.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-histor-combust = YES THEN DO:        
    ASSIGN c-caminho = tt-param.dir-entrada + "fr014.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr014").
        FOR EACH mab-histor-combust NO-LOCK:
            EXPORT DELIMITER ";" mab-histor-combust.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-eqpto-caract = YES THEN DO:          
    ASSIGN c-caminho = tt-param.dir-entrada + "fr097.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr097").
        FOR EACH mab-eqpto-caract
        WHERE &if "{&mguni_version}" >= "2.08" &then 
                  mab-eqpto-caract.num-param-int = 0 
              &else
                  mab-eqpto-caract.num-livre-1 = 0 
              &endif NO-LOCK:
            EXPORT DELIMITER ";" mab-eqpto-caract.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-comptmento-eqpto = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr004.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr004").
        FOR EACH mab-comptmento-eqpto NO-LOCK:
            EXPORT DELIMITER ";" mab-comptmento-eqpto.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-period-manut = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr020.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr020").
        FOR EACH mab-period-manut NO-LOCK:
            EXPORT DELIMITER ";" mab-period-manut.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-configur-eixo = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr005.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr005").
        FOR EACH mab-configur-eixo NO-LOCK:
            EXPORT DELIMITER ";" mab-configur-eixo.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-programac-event = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr022.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr022").
        FOR EACH mab-programac-event NO-LOCK:
            EXPORT DELIMITER ";" mab-programac-event.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-eqpto-plano = YES THEN DO:   
    ASSIGN c-caminho = tt-param.dir-entrada + "fr031.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr031").
        FOR EACH mmv-eqpto-plano  NO-LOCK:
            EXPORT DELIMITER ";" mmv-eqpto-plano.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mgf-eqpto-implto = YES THEN DO: 
    ASSIGN c-caminho = tt-param.dir-entrada + "fr093.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr093").
        FOR EACH mgf-eqpto-implto  NO-LOCK:
            EXPORT DELIMITER ";" mgf-eqpto-implto.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mpn-histor-layout-eixo = YES THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr044.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr044").
        FOR EACH mpn-histor-layout-eixo  NO-LOCK:
            EXPORT DELIMITER ";" mpn-histor-layout-eixo.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mpn-eqpto-serv = YES THEN DO:    
    ASSIGN c-caminho = tt-param.dir-entrada + "fr099.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr099").
        FOR EACH mpn-eqpto-serv  NO-LOCK:
            EXPORT DELIMITER ";" mpn-eqpto-serv.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mpn-hora-estimad = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr125.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr125").
        FOR EACH mpn-hora-estimad NO-LOCK:
            EXPORT DELIMITER ";" mpn-hora-estimad.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-grp-eqpto = YES THEN DO:   
    ASSIGN c-caminho = tt-param.dir-entrada + "fr126.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr126").
        FOR EACH mmv-grp-eqpto  NO-LOCK:
            EXPORT DELIMITER ";" mmv-grp-eqpto.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mmv-eqpto-grp-eqpto = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr127.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr127").
        FOR EACH mmv-eqpto-grp-eqpto  NO-LOCK:
            EXPORT DELIMITER ";" mmv-eqpto-grp-eqpto.
        END.
    OUTPUT CLOSE.
END.

IF tt-param.l-mab-relac-eqpto-sub-sist = YES THEN DO:  
    ASSIGN c-caminho = tt-param.dir-entrada + "fr128.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        RUN piBuscaDados (INPUT "fr128").
        FOR EACH mab-relac-eqpto-sub-sist NO-LOCK:
            EXPORT DELIMITER ";" mab-relac-eqpto-sub-sist.
        END.
    OUTPUT CLOSE.
END.

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
assign c-programa = "AB0709":U
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
{utp/ut-liter.i Exporta‡Æo_Cadastros_B sicos_Frotas *}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Frotas *}
assign c-sistema = trim(return-value).

RETURN "OK":U.

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

/*verifica dados a Exportar, e os Exporta para as temp tables.*/
RUN piExportaDados IN THIS-PROCEDURE.
RUN piExportaDados2 IN THIS-PROCEDURE.
/* RUN piExportaDados IN THIS-PROCEDURE. */


/** Mostra dados Exportados e erros **/
run displayDados in this-procedure.

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

