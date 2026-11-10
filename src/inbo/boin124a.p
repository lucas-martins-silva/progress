&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i BOIN124A 2.00.01.059} /*** "010159" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin124a MUT} 
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN124
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ficha-cq
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


&GLOBAL-DEFINE KeyField1 nr-ficha /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin124a.i RowObject}
{inbo/boin124a.i RowObject-aux}
{cqp/cq0240.i} /*tt-resultado*/

{utp/ut-glob.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName}   FOR {&TableName}.
DEFINE BUFFER bf-comp-exame    FOR comp-exame.
DEFINE BUFFER bf-it-comp-exame FOR it-comp-exame.
DEFINE BUFFER bf-tab-result    FOR tab-result.
DEFINE BUFFER b-responsavel    FOR responsavel.
DEFINE BUFFER b-ficha-cq-aux   FOR ficha-cq.

DEFINE TEMP-TABLE tt-ficha-cq NO-UNDO LIKE ficha-cq 
    FIELD r-rowid AS ROWID.   
    
DEFINE VARIABLE i-nr-ficha  LIKE ficha-cq.nr-ficha  NO-UNDO.    
DEFINE VARIABLE NrFichaIni  LIKE ficha-cq.nr-ficha  NO-UNDO.
DEFINE VARIABLE NrFichaFim  LIKE ficha-cq.nr-ficha  NO-UNDO.
DEFINE VARIABLE c-it-codigo LIKE ficha-cq.it-codigo  NO-UNDO.
DEFINE VARIABLE i-orig-restdo AS INT                NO-UNDO.

/*setSampleManual */
DEFINE VARIABLE c-lbl-liter-qtd-am  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter-qtd-fic AS CHARACTER NO-UNDO.

/* SetConstraintFiltro */
DEFINE VARIABLE c-cod-depos-ini    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-depos-fim    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nro-docto-ini    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nro-docto-fim    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-responsavel-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-responsavel-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-data-ini       LIKE ficha-cq.dt-ficha NO-UNDO.
DEFINE VARIABLE dt-data-fim       LIKE ficha-cq.dt-ficha NO-UNDO.
DEFINE VARIABLE i-situacao        LIKE ficha-cq.situacao NO-UNDO.

/*setContraintDatainspecao */
DEFINE VARIABLE c-ItCodigo-ini     AS CHARACTER NO-UNDO.   
DEFINE VARIABLE c-ItCodigo-fim     AS CHARACTER NO-UNDO.   
DEFINE VARIABLE i-cod-emitente-ini LIKE ficha-cq.cod-emitente NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim LIKE ficha-cq.cod-emitente NO-UNDO.

DEFINE VARIABLE c-cod-proces-ini      LIKE ficha-cq.cod-proces      NO-UNDO.
DEFINE VARIABLE c-cod-proces-fim      LIKE ficha-cq.cod-proces      NO-UNDO.
DEFINE VARIABLE c-cod-sub-proces-ini  LIKE ficha-cq.cod-sub-proces  NO-UNDO.
DEFINE VARIABLE c-cod-sub-proces-fim  LIKE ficha-cq.cod-sub-proces  NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini     LIKE ficha-cq.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim     LIKE ficha-cq.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-area-produc-ini LIKE ficha-cq.cod-area-produc NO-UNDO.
DEFINE VARIABLE c-cod-area-produc-fim LIKE ficha-cq.cod-area-produc NO-UNDO.
DEFINE VARIABLE i-nr-ficha-aux        LIKE ficha-cq.nr-ficha        NO-UNDO.

DEFINE TEMP-TABLE tt-digitacao NO-UNDO
    field nr-ficha  AS INTEGER
    field cod-exame AS INTEGER
    field cod-comp  AS INTEGER
    field num-teste  AS INTEGER
    field situacao AS LOGICAL.    
    
DEFINE TEMP-TABLE tt-exame NO-UNDO
    FIELD cod-exame   LIKE exame.cod-exame
    FIELD nr-aceita   LIKE exam-ficha.nr-aceita  
    FIELD nr-rejeita  LIKE exam-ficha.nr-rejeita 
    FIELD tam-amostra LIKE exam-ficha.tam-amostra
    FIELD nr-ficha    LIKE exam-ficha.nr-ficha
    FIELD cdn-versao  LIKE exame.cdn-versao
    FIELD qtd-nao-conforme AS INTEGER.

DEFINE TEMP-TABLE tt-inspecao NO-UNDO 
    FIELD id           AS INTEGER 
    FIELD dt-inspecao  LIKE ficha-cq.dt-inspecao                                                    
    FIELD lote         LIKE ficha-cq.lote                                                           
    FIELD descricao    LIKE comp-exame.descricao  
    FIELD unidade      LIKE comp-exame.unidade                             
    FIELD resultado    AS CHARACTER                                                                      
    FIELD nr-ficha     LIKE ficha-cq.nr-ficha                                                       
    FIELD cod-exame    LIKE res-fic-cq.cod-exame  
    FIELD cdn-vers-exam LIKE ficha-cq.cdn-vers-exam                                                  
    FIELD cod-emitente LIKE ficha-cq.cod-emitente                                                   
    FIELD nome-abrev   LIKE emitente.nome-abrev                              
    FIELD situacao     LIKE exame.situacao                                      
    FIELD cod-resp     LIKE res-fic-cq.cod-resp                                                     
    FIELD log-1        LIKE comp-exame.log-1                               
    FIELD tipo-result  AS CHARACTER                                                  
    FIELD referencia   AS CHARACTER                                                                      
    FIELD narrativa    LIKE res-fic-cq.narrativa  
    FIELD r-rowid      AS ROWID                                                 
    INDEX id IS PRIMARY UNIQUE id.
 
DEFINE BUFFER bf-tt-inspecao FOR tt-inspecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 25.54
         WIDTH              = 46.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH exam-ficha
        WHERE exam-ficha.nr-ficha = RowObject.nr-ficha EXCLUSIVE-LOCK:
        DELETE exam-ficha.
    END.

    FOR EACH res-fic-cq
        WHERE res-fic-cq.nr-ficha = RowObject.nr-ficha EXCLUSIVE-LOCK:
        DELETE res-fic-cq.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     Override do NewRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    FIND LAST b-ficha-cq-aux NO-LOCK NO-ERROR.
    
    IF  AVAIL b-ficha-cq-aux THEN
        ASSIGN i-nr-ficha-aux = b-ficha-cq-aux.nr-ficha + 1.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCampos DBOProgram 
PROCEDURE atualizaCampos :
/*------------------------------------------------------------------------------
 Purpose: Atualiza campos observacao, dsl-narrat-ext
          digitados na tela cq0222.w 
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-nr-ficha       LIKE {&TableName}.nr-ficha       NO-UNDO.
    DEFINE INPUT PARAM pc-observacao     LIKE {&TableName}.observacao     NO-UNDO.
    DEFINE INPUT PARAM pc-dsl-narrat-ext LIKE {&TableName}.dsl-narrat-ext NO-UNDO.   

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.nr-ficha = pi-nr-ficha EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} THEN DO:   
        ASSIGN bf{&TableName}.observacao     = pc-observacao
               bf{&TableName}.dsl-narrat-ext = pc-dsl-narrat-ext.               
    END.         
    
    RETURN "OK":U.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDataLaudo DBOProgram 
PROCEDURE atualizaDataLaudo :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-ficha  LIKE exam-ficha.nr-ficha  NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo LIKE exam-ficha.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-exame LIKE exam-ficha.cod-exame NO-UNDO.
    
    FIND FIRST exam-ficha EXCLUSIVE-LOCK
         WHERE exam-ficha.nr-ficha  =  p-nr-ficha
           AND exam-ficha.it-codigo =  p-it-codigo
           AND exam-ficha.cod-exame =  p-cod-exame NO-ERROR.
    IF AVAIL exam-ficha THEN
        ASSIGN exam-ficha.dt-laudo = TODAY.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaFabricante DBOProgram 
PROCEDURE atualizaFabricante :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-nr-ficha       LIKE {&TableName}.nr-ficha       NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-fabrican   LIKE {&TableName}.cod-fabricante NO-UNDO.
    
    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.nr-ficha = pi-nr-ficha EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} THEN  
        ASSIGN bf{&TableName}.cod-fabricante = pi-cdn-fabrican.        
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaRoteiroAntecipado DBOProgram 
PROCEDURE atualizaRoteiroAntecipado :
/*------------------------------------------------------------------------------
  Purpose: Atualiza Ficha ao confirmar os resultados do roteiro de inspe‡Æo no CQ0240    
  Parameters:  1 - Cria‡Æo da Ficha 2 - Confirma‡Æo da Ficha 3 - Atualiza‡Æo RE1001B2 aba estoque 4 - Eliminacao RE1001B2 aba estoque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-ficha  LIKE ficha-cq.nr-ficha    NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo      AS INTEGER                NO-UNDO.

    FIND bf{&TableName} WHERE bf{&TableName}.nr-ficha = p-nr-ficha EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL bf{&TableName} THEN RETURN "NOK":U.
    
    CASE p-tipo:
        WHEN 1 THEN DO:
            ASSIGN bf{&TableName}.situacao = IF bf{&TableName}.log-dia-sem-fornec THEN 4 ELSE 2
                   bf{&TableName}.origem   = 1.
        
            IF bf{&TableName}.log-dia-sem-fornec THEN
                ASSIGN bf{&TableName}.inspecionado = YES
                       bf{&TableName}.liberada     = YES
                       bf{&TableName}.dt-inspecao  = TODAY 
                       bf{&TableName}.dt-ult-sit   = TODAY.        
        END.
        WHEN 2 THEN DO:
            ASSIGN bf{&TableName}.situacao     = 6
                   bf{&TableName}.inspecionado = YES
                   bf{&TableName}.dt-inspecao  = TODAY 
                   bf{&TableName}.liberada     = YES
                   bf{&TableName}.dt-ult-sit   = TODAY.        
        END.
        OTHERWISE
            RETURN "NOK":U.
    
    END CASE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaRoteiroProcesso DBOProgram 
PROCEDURE atualizaRoteiroProcesso :
/*------------------------------------------------------------------------------
  Purpose: Atualiza Ficha ao confirmar os resultados do roteiro de inspe‡Æo no CQ0230    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-nr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.
    
    FIND bf{&TableName} WHERE bf{&TableName}.nr-ficha = p-nr-ficha EXCLUSIVE-LOCK NO-ERROR.
    
    IF  AVAIL bf{&TableName} THEN DO:
        ASSIGN bf{&TableName}.situacao     = 4 /* Situa‡Æo = "Terminado" */
               bf{&TableName}.inspecionado = YES
               bf{&TableName}.dt-inspecao  = TODAY 
               bf{&TableName}.liberada     = YES
               bf{&TableName}.dt-ult-sit   = TODAY.
        RETURN "OK":U.
    END.
    ELSE 
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSit-rot DBOProgram 
PROCEDURE atualizaSit-rot :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-ficha  LIKE ficha-cq.nr-ficha    NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-exame .
    
    FOR FIRST ficha-cq
        WHERE ficha-cq.nr-ficha = p-nr-ficha EXCLUSIVE-LOCK: END.
        
    IF AVAIL ficha-cq THEN DO:
        ASSIGN ficha-cq.sit-rot = 0.       
        
        FOR EACH  tt-exame:            
            FIND FIRST exame
                 WHERE exame.cod-exame   = tt-exame.cod-exame
                   AND exame.cdn-versao  = tt-exame.cdn-versao NO-LOCK NO-ERROR.
             
            FIND FIRST exam-ficha
                 WHERE exam-ficha.cod-exame = tt-exame.cod-exame 
                   AND exam-ficha.nr-ficha  = ficha-cq.nr-ficha NO-LOCK NO-ERROR.
        
            IF AVAIL exame THEN DO:               
                IF exame.homogeneo = NO THEN DO: 
                    IF AVAIL exam-ficha THEN DO:                
                        IF  exam-ficha.nr-ac-ex > 0
                        AND exam-ficha.nr-ac-ex >= exam-ficha.nr-rejeita THEN DO:
                            IF exame.rejeita-lote = YES THEN 
                                ASSIGN ficha-cq.sit-rot = 2.
                            ELSE 
                                ASSIGN ficha-cq.sit-rot = 1.
                             
                            LEAVE.    
                        END.
                    END.  
                END.
                ELSE DO: /*Homogeneo*/ 
                    IF AVAIL exam-ficha THEN DO:
                        IF  exam-ficha.nr-ac-ex > 0 THEN DO:
                            IF  exame.rejeita-lote = YES THEN                             
                                ASSIGN ficha-cq.sit-rot = 2.                           
                             
                            ELSE 
                                ASSIGN ficha-cq.sit-rot = 1.
                          LEAVE.                          
                        END.
                    END.    
                END.    
            END.  
        END.          
    END. 
    
    RETURN "OK":U.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacao DBOProgram 
PROCEDURE atualizaSituacao :
/*------------------------------------------------------------------------------
 Purpose: Atualiza situação após digitação de resultados no cq0222.
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-ficha  LIKE ficha-cq.nr-ficha    NO-UNDO.
    
    FOR FIRST ficha-cq  FIELDS(situacao dt-ult-sit)
        WHERE ficha-cq.nr-ficha = p-nr-ficha EXCLUSIVE-LOCK: END. 
            
    IF NOT AVAIL ficha-cq THEN    
        RETURN "NOK":U.     
           
    ASSIGN ficha-cq.situacao = 3
           ficha-cq.dt-ult-sit = TODAY.                    
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoRotAntecipado DBOProgram 
PROCEDURE atualizaSituacaoRotAntecipado :
/*------------------------------------------------------------------------------
  Purpose: Atualiza Situacao da Ficha ao atualizar os registros da rat-lote no RE1001B2    
  Parameters:  1 - Cria‡Æo da Ficha 2 - Confirma‡Æo da Ficha 3 - Atualiza‡Æo RE1001B2 aba estoque 4 - Eliminacao RE1001B2 aba estoque
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p-nr-ficha      LIKE ficha-cq.nr-ficha    NO-UNDO.
DEFINE INPUT  PARAMETER p-nr-ficha-ant  LIKE ficha-cq.nr-ficha    NO-UNDO.
DEFINE INPUT  PARAMETER p-acao          AS   CHAR                 NO-UNDO.

find bf{&TableName} where bf{&TableName}.nr-ficha = p-nr-ficha EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL bf{&TableName} THEN DO:

    IF p-acao = "add":U THEN
        ASSIGN bf{&TableName}.situacao = 4.

    IF p-acao = "del":U THEN
        ASSIGN bf{&TableName}.situacao = 6.

    IF p-acao = "upd":U THEN
        ASSIGN bf{&TableName}.situacao = 4.
    
END.

IF p-acao = "upd":U THEN DO:
    find bf{&TableName} where bf{&TableName}.nr-ficha = p-nr-ficha-ant EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} THEN
        ASSIGN bf{&TableName}.situacao = 6.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoRoteiro DBOProgram 
PROCEDURE atualizaSituacaoRoteiro :
/*------------------------------------------------------------------------------
  Purpose:     Atualizar a situa‡Æo do roteiro com base nos parƒmetros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-r-ficha-rowid AS  ROWID              NO-UNDO.
    DEFINE INPUT PARAMETER p-i-situacao    LIKE ficha-cq.situacao NO-UNDO.
    
    FOR FIRST ficha-cq WHERE ROWID(ficha-cq) = p-r-ficha-rowid EXCLUSIVE-LOCK:
        ASSIGN ficha-cq.situacao   = p-i-situacao
               ficha-cq.dt-ult-sit = TODAY.

        IF  p-i-situacao = 4 THEN /* Terminado */
            ASSIGN ficha-cq.inspecionado = YES
                   ficha-cq.dt-inspecao  = TODAY 
                   ficha-cq.liberada     = YES.
    END.

    RETURN "OK":U.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaResultadosDigitados DBOProgram 
PROCEDURE buscaResultadosDigitados :
/*------------------------------------------------------------------------------
  Purpose: Valida se todos os resultados foram digitados.   
  Parameters:  <none>
  Notes: Tem a mesma função da procedure verificaResultados, porém retorna
         um temp-table com informação dos resultados não digitados.       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pc-it-codigo LIKE {&TableName}.it-codigo NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE  FOR tt-digitacao.
  
    /*Verifica se todos os resultados foram digitados*/    
    FOR EACH  tt-digitacao:     
        FIND FIRST res-fic-cq NO-LOCK
             WHERE res-fic-cq.nr-ficha  = tt-digitacao.nr-ficha
               AND res-fic-cq.it-codigo = pc-it-codigo
               AND res-fic-cq.cod-exame = tt-digitacao.cod-exame
               AND res-fic-cq.cod-comp  = tt-digitacao.cod-comp
               AND res-fic-cq.num-test  = tt-digitacao.num-teste NO-ERROR.
        IF AVAIL res-fic-cq THEN DO:
            assign tt-digitacao.situacao = yes. /*digitado*/
        END.       
        ELSE DO:
            assign tt-digitacao.situacao = no. /*não digitado*/
        END.
    END.
  
    RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaSequencia DBOProgram 
PROCEDURE buscaSequencia :
/*------------------------------------------------------------------------------
  Purpose:     Enviar a sequencia que est  sendo criada para a tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-i-nr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.
    
    ASSIGN p-i-nr-ficha = i-nr-ficha-aux.

    RETURN "OK":U.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaExames DBOProgram 
PROCEDURE carregaExames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-resultado.

EMPTY TEMP-TABLE tt-resultado.
DEF VAR num-teste AS INTEGER INITIAL 1 NO-UNDO.

 FOR EACH exam-ficha FIELDS(it-codigo cod-exame cdn-versao)
    WHERE exam-ficha.nr-ficha = rowObject.nr-ficha NO-LOCK:        
    IF CAN-FIND (FIRST it-comp-exame 
                 WHERE it-comp-exame.it-codigo = exam-ficha.it-codigo  
                   AND it-comp-exame.cod-exame = exam-ficha.cod-exame) THEN DO:
        FOR EACH it-comp-exame
           WHERE it-comp-exame.cod-exame = exam-ficha.cod-exame 
             AND it-comp-exame.it-codigo = exam-ficha.it-codigo 
             AND it-comp-exame.situacao = 1 NO-LOCK:      
            IF CAN-FIND (FIRST res-fic-cq 
                         WHERE res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                           AND res-fic-cq.it-codigo = ficha-cq.it-codigo
                           AND res-fic-cq.cod-exame = it-comp-exame.cod-exame 
                           AND res-fic-cq.cod-comp  = it-comp-exame.cod-comp) THEN DO:
                FOR EACH res-fic-cq 
                    WHERE res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                      AND res-fic-cq.it-codigo = ficha-cq.it-codigo
                      AND res-fic-cq.cod-exame = it-comp-exame.cod-exame 
                      AND res-fic-cq.cod-comp  = it-comp-exame.cod-comp NO-LOCK:
                    CREATE tt-resultado.
                    ASSIGN tt-resultado.cod-comp    = res-fic-cq.cod-comp
                           tt-resultado.cod-exame   = res-fic-cq.cod-exame
                           tt-resultado.cdn-versao  = exam-ficha.cdn-versao
                           tt-resultado.it-codigo   = it-comp-exame.it-codigo
                           tt-resultado.it-codigo   = it-comp-exame.it-codigo
                           tt-resultado.laudo       = res-fic-cq.laudo
                           tt-resultado.narrativa   = res-fic-cq.narrativa
                           tt-resultado.nr-tabela   = res-fic-cq.nr-tabela
                           tt-resultado.num-teste   = res-fic-cq.num-test
                           tt-resultado.res-max     = res-fic-cq.res-max
                           tt-resultado.result-min  = it-comp-exame.result-min
                           tt-resultado.result-max  = it-comp-exame.result-max
                           tt-resultado.resultado   = res-fic-cq.resultado
                           tt-resultado.seq-comp    = res-fic-cq.seq-comp
                           tt-resultado.tipo-result = res-fic-cq.tipo-result
                           tt-resultado.descricao   = it-comp-exame.descricao
                           tt-resultado.unidade     = it-comp-exame.unidade
                           tt-resultado.origem      = 1
                           tt-resultado.resultKey       = ROWID(it-comp-exame).
                    VALIDATE tt-resultado.
                END.
            END.            
            ELSE DO:             
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = it-comp-exame.cod-comp
                       tt-resultado.cod-exame   = it-comp-exame.cod-exame
                       tt-resultado.cdn-versao  = exam-ficha.cdn-versao
                       tt-resultado.it-codigo   = it-comp-exame.it-codigo
                       tt-resultado.laudo       = ""
                       tt-resultado.narrativa   = ""
                       tt-resultado.nr-tabela   = it-comp-exame.nr-tabela
                       tt-resultado.res-max     = 0
                       tt-resultado.resultado   = 0
                       tt-resultado.seq-comp    = 0
                       tt-resultado.tipo-result = it-comp-exame.tipo-result
                       tt-resultado.descricao   = it-comp-exame.descricao
                       tt-resultado.unidade     = it-comp-exame.unidade
                       tt-resultado.origem      = 1
                       tt-resultado.num-teste   = 1
                       tt-resultado.result-min  = it-comp-exame.result-min
                       tt-resultado.result-max  = it-comp-exame.result-max
                       tt-resultado.resultKey   = ROWID(it-comp-exame).                       
                VALIDATE tt-resultado.
            END.
        END.
    END.
    ELSE
    FOR EACH comp-exame 
       WHERE comp-exame.cod-exame = exam-ficha.cod-exame 
         AND comp-exame.cdn-versao = exam-ficha.cdn-versao
         AND comp-exame.log-1 NO-LOCK:   
  
        FIND FIRST tt-resultado 
             WHERE tt-resultado.cod-exame  = comp-exame.cod-exame 
               AND tt-resultado.cod-comp   = comp-exame.cod-comp NO-ERROR.
        IF NOT AVAIL tt-resultado THEN DO: 
            IF CAN-FIND(FIRST res-fic-cq 
                        WHERE res-fic-cq.nr-ficha  = rowObject.nr-ficha 
                          AND res-fic-cq.it-codigo = rowObject.it-codigo
                          AND res-fic-cq.cod-exame = comp-exame.cod-exame 
                          AND res-fic-cq.cod-comp  = comp-exame.cod-comp) THEN DO:                  
                FOR EACH res-fic-cq NO-LOCK
                   WHERE res-fic-cq.nr-ficha  = rowObject.nr-ficha 
                     AND res-fic-cq.it-codigo = rowObject.it-codigo
                     AND res-fic-cq.cod-exame = comp-exame.cod-exame 
                     AND res-fic-cq.cod-comp  = comp-exame.cod-comp:
                    CREATE tt-resultado.
                    ASSIGN tt-resultado.cod-comp    = res-fic-cq.cod-comp
                           tt-resultado.cod-exame   = res-fic-cq.cod-exame
                           tt-resultado.cdn-versao  = comp-exame.cdn-versao
                           tt-resultado.it-codigo   = ?
                           tt-resultado.laudo       = res-fic-cq.laudo
                           tt-resultado.narrativa   = res-fic-cq.narrativa
                           tt-resultado.nr-tabela   = res-fic-cq.nr-tabela
                           tt-resultado.res-max     = res-fic-cq.res-max
                           tt-resultado.resultado   = res-fic-cq.resultado
                           tt-resultado.seq-comp    = res-fic-cq.seq-comp
                           tt-resultado.tipo-result = res-fic-cq.tipo-result
                           tt-resultado.descricao   = comp-exame.descricao
                           tt-resultado.unidade     = comp-exame.unidade
                           tt-resultado.origem      = 2
                           tt-resultado.num-teste   = res-fic-cq.num-test
                           tt-resultado.result-min  = comp-exame.result-min
                           tt-resultado.result-max  = comp-exame.result-max
                           tt-resultado.resultKey   = ROWID(comp-exame).                     
                    VALIDATE tt-resultado.
                END.    
            END.
            ELSE DO:           
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = comp-exame.cod-comp
                       tt-resultado.cod-exame   = comp-exame.cod-exame
                       tt-resultado.cdn-versao  = comp-exame.cdn-versao
                       tt-resultado.it-codigo   = ?
                       tt-resultado.laudo       = ""
                       tt-resultado.narrativa   = ""
                       tt-resultado.nr-tabela   = comp-exame.nr-tabela
                       tt-resultado.res-max     = 0
                       tt-resultado.resultado   = 0
                       tt-resultado.seq-comp    = 0
                       tt-resultado.tipo-result = comp-exame.tipo-result
                       tt-resultado.descricao   = comp-exame.descricao
                       tt-resultado.unidade     = comp-exame.unidade
                       tt-resultado.origem      = 2
                       tt-resultado.num-teste   = 1
                       tt-resultado.result-min  = comp-exame.result-min
                       tt-resultado.result-max  = comp-exame.result-max
                       tt-resultado.resultKey   = ROWID(comp-exame).                            
                VALIDATE tt-resultado.                   
            END.
        END.
    END.  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _carregaExamesCq0222_ DBOProgram 
PROCEDURE _carregaExamesCq0222_ :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaExamesCq0222 DBOProgram
PROCEDURE carregaExamesCq0222:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-resultado.
    
    DEFINE VARIABLE i-num-teste        AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-qti-test-realzdo AS INTEGER INITIAL 1 NO-UNDO. 

    EMPTY TEMP-TABLE tt-resultado.
  
    /* Carrega tt-resultado com os valores digitados (res-fic-cq) */
    {inbo/boin124a.i1}
    
    /* 1 - Pendente   2 - Em análise   3 - Pendente Retorno */
    /* 4 - Terminado  5 - Cancelado                         */
    IF rowObject.situacao < 3 THEN DO:
        FOR EACH exam-ficha FIELDS(it-codigo cod-exame cdn-versao)
           WHERE exam-ficha.nr-ficha = rowObject.nr-ficha NO-LOCK:

            IF CAN-FIND (FIRST it-comp-exame 
                         WHERE it-comp-exame.it-codigo = exam-ficha.it-codigo  
                           AND it-comp-exame.cod-exame = exam-ficha.cod-exame) THEN DO:
                /* Carrega tt-resultado com os componentes do exame do item (it-comp-exame) */
                {inbo/boin124a.i5}
            END.
            ELSE DO:
                /* Carrega tt-resultado com os componentes do exame (comp-exame) */
                {inbo/boin124a.i2} 
            END.
        END.
    END.
END PROCEDURE.
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaExamesCq0230 DBOProgram 
PROCEDURE carregaExamesCq0230 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-resultado.
EMPTY TEMP-TABLE tt-resultado.

DEF VAR num-teste AS INTEGER INITIAL 1 NO-UNDO.

 FOR EACH exam-ficha FIELDS(it-codigo cod-exame cdn-versao)
    WHERE exam-ficha.nr-ficha = rowObject.nr-ficha NO-LOCK:

     for each comp-exame 
        where comp-exame.cod-exame = exam-ficha.cod-exame 
          AND comp-exame.cdn-versao = exam-ficha.cdn-versao
          AND comp-exame.log-1 no-lock:
        find first tt-resultado where
             tt-resultado.cod-exame  = comp-exame.cod-exame and
             tt-resultado.cod-comp   = comp-exame.cod-comp no-error.
        if not avail tt-resultado then do:
            find first res-fic-cq 
                 where res-fic-cq.nr-ficha  = rowObject.nr-ficha 
                   and res-fic-cq.it-codigo = rowObject.it-codigo
                   and res-fic-cq.cod-exame = comp-exame.cod-exame 
                   and res-fic-cq.cod-comp  = comp-exame.cod-comp no-lock no-error.
            if  avail res-fic-cq then do:
                create tt-resultado.
                assign tt-resultado.cod-comp    = res-fic-cq.cod-comp
                       tt-resultado.cod-exame   = res-fic-cq.cod-exame
                       tt-resultado.cdn-versao  = comp-exame.cdn-versao
                       /* tt-resultado.it-codigo   = ?*/
                       /* tt-resultado.laudo       = res-fic-cq.laudo */
                       tt-resultado.narrativa   = res-fic-cq.narrativa
                       tt-resultado.nr-tabela   = res-fic-cq.nr-tabela
                       tt-resultado.res-max     = res-fic-cq.res-max
                       tt-resultado.resultado   = res-fic-cq.resultado
                       tt-resultado.seq-comp    = res-fic-cq.seq-comp
                       tt-resultado.tipo-result = res-fic-cq.tipo-result
                       tt-resultado.descricao   = comp-exame.descricao
                       tt-resultado.unidade     = comp-exame.unidade
                       tt-resultado.origem      = 2
                       /* tt-resultado.num-teste   = res-fic-cq.num-test */
                       tt-resultado.result-min  = comp-exame.result-min
                       tt-resultado.result-max  = comp-exame.result-max
                       tt-resultado.resultKey   = rowid(comp-exame).
                validate tt-resultado.
            end.
            else do:
                ASSIGN num-teste = 1.
                DO WHILE num-teste <= comp-exame.qti-test-realzdo:
                    create tt-resultado.
                    assign tt-resultado.cod-comp    = comp-exame.cod-comp
                           tt-resultado.cod-exame   = comp-exame.cod-exame
                           tt-resultado.cdn-versao  = comp-exame.cdn-versao
                           /* tt-resultado.it-codigo   = ? */
                           /* tt-resultado.laudo       = "" */
                           tt-resultado.narrativa   = ""
                           tt-resultado.nr-tabela   = comp-exame.nr-tabela
                           tt-resultado.res-max     = 0
                           tt-resultado.resultado   = 0
                           tt-resultado.seq-comp    = 0
                           tt-resultado.tipo-result = comp-exame.tipo-result
                           tt-resultado.descricao   = comp-exame.descricao
                           tt-resultado.unidade     = comp-exame.unidade
                           tt-resultado.origem      = 2
                           /* tt-resultado.num-teste   = 1 */
                           tt-resultado.result-min  = comp-exame.result-min
                           tt-resultado.result-max  = comp-exame.result-max
                           tt-resultado.resultKey   = rowid(comp-exame).
                    validate tt-resultado.
                    ASSIGN num-teste = num-teste + 1.
                END.
            end.
        end.
    end.  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaInspecao DBOProgram 
PROCEDURE carregaInspecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   DEFINE VARIABLE cLabel AS CHARACTER EXTENT 3 NO-UNDO.
   DEFINE VARIABLE cListaTipoResult AS CHARACTER NO-UNDO.
      
   {utp/ut-liter.i "Min:" *} 
   ASSIGN cLabel[2] = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Max:" *} 
   ASSIGN cLabel[3] = TRIM(RETURN-VALUE).   
   ASSIGN cListaTipoResult = {ininc/i01in050.i 03}.
   
   IF ficha-cq.log-dia-sem-fornec THEN DO:
      
      CASE ficha-cq.idi-orig-restdo:
          WHEN 2 THEN DO:
             {utp/ut-liter.i "DIA_SEM_FORNECIMENTO" *}
             ASSIGN cLabel[1] = TRIM(RETURN-VALUE).
          END.
          WHEN 3 THEN DO:
             {utp/ut-liter.i "DIA_SEM_FABRICA€ÇO" *} 
             ASSIGN cLabel[1] = TRIM(RETURN-VALUE).
          END.    
      END CASE.     
       
      FOR FIRST emitente FIELDS(nome-abrev) NO-LOCK
          WHERE emitente.cod-emitente = ficha-cq.cod-emitente: END.
           
      FIND LAST bf-tt-inspecao NO-LOCK NO-ERROR.
                                          
      CREATE tt-inspecao.          
      ASSIGN tt-inspecao.id           = (IF AVAILABLE bf-tt-inspecao THEN bf-tt-inspecao.id + 1 ELSE 1)  
             tt-inspecao.dt-inspecao  = ficha-cq.dt-inspecao
             tt-inspecao.lote         = ficha-cq.lote
             tt-inspecao.descricao    = cLabel[1] 
             tt-inspecao.nr-ficha     = ficha-cq.nr-ficha
             tt-inspecao.cod-emitente = ficha-cq.cod-emitente
             tt-inspecao.nome-abrev   = emitente.nome-abrev WHEN AVAILABLE emitente 
             tt-inspecao.situacao     = 0
             tt-inspecao.log-1        = ?
             tt-inspecao.r-rowid      = ROWID(ficha-cq) .
             
      RELEASE tt-inspecao.
       
      RETURN "OK":U.          
   END.   
           
   FOR EACH res-fic-cq FIELDS (cod-exame cod-comp cod-resp tipo-result narrativa resultado seq-comp laudo res-max nr-ficha) NO-LOCK
      WHERE res-fic-cq.nr-ficha  = ficha-cq.nr-ficha: 
              
      FOR FIRST emitente FIELDS(nome-abrev) NO-LOCK
          WHERE emitente.cod-emitente = ficha-cq.cod-emitente: END.
         
      FOR FIRST exam-ficha fields(nr-ficha cod-exame cdn-versao) NO-LOCK
          WHERE exam-ficha.nr-ficha  = res-fic-cq.nr-ficha
            AND exam-ficha.cod-exame = res-fic-cq.cod-exame: END.

      FOR FIRST exame FIELDS(situacao cdn-versao) NO-LOCK
          WHERE exame.cod-exame  = res-fic-cq.cod-exame
            AND exame.cdn-versao = exam-ficha.cdn-versao: END.

      FOR FIRST comp-exame FIELDS(descricao unidade log-1 cdn-versao) NO-LOCK 
          WHERE comp-exame.cod-exame  = res-fic-cq.cod-exame 
            AND comp-exame.cod-comp   = res-fic-cq.cod-comp
            AND comp-exame.cdn-versao = exame.cdn-versao: END. 
            
      FOR FIRST it-comp-exame NO-LOCK 
          WHERE it-comp-exame.cod-exame = res-fic-cq.cod-exame 
            AND it-comp-exame.cod-comp  = res-fic-cq.cod-comp
            AND it-comp-exame.it-codigo = ficha-cq.it-codigo: END.      
                                          
      FIND LAST bf-tt-inspecao NO-LOCK NO-ERROR.
                                          
      CREATE tt-inspecao.          
      ASSIGN tt-inspecao.id            = (IF AVAILABLE bf-tt-inspecao THEN bf-tt-inspecao.id + 1 ELSE 1)  
             tt-inspecao.dt-inspecao   = ficha-cq.dt-inspecao
             tt-inspecao.lote          = ficha-cq.lote
             tt-inspecao.nr-ficha      = ficha-cq.nr-ficha
             tt-inspecao.cod-exame     = res-fic-cq.cod-exame
             tt-inspecao.cdn-vers-exam = exam-ficha.cdn-versao
             tt-inspecao.cod-emitente  = ficha-cq.cod-emitente
             tt-inspecao.nome-abrev    = emitente.nome-abrev WHEN AVAILABLE emitente 
             tt-inspecao.situacao      = exame.situacao WHEN AVAILABLE exame
             tt-inspecao.cod-resp      = res-fic-cq.cod-resp
             tt-inspecao.tipo-result   = ENTRY(res-fic-cq.tipo-result,cListaTipoResult)
             tt-inspecao.narrativa     = res-fic-cq.narrativa
             tt-inspecao.r-rowid       = ROWID(ficha-cq). 
             
      IF AVAILABLE it-comp-exame THEN DO:
          ASSIGN tt-inspecao.descricao = it-comp-exame.descricao
                 tt-inspecao.unidade   = it-comp-exame.unidade 
                 tt-inspecao.log-1     = it-comp-exame.situacao = 1.                          
      END.
      ELSE DO:
          ASSIGN tt-inspecao.descricao = (IF AVAILABLE comp-exame THEN comp-exame.descricao ELSE "")
                 tt-inspecao.unidade   = comp-exame.unidade WHEN AVAILABLE comp-exame
                 tt-inspecao.log-1     = comp-exame.log-1 WHEN AVAILABLE comp-exame.
      END.
                        
      CASE res-fic-cq.tipo-result:
          WHEN 1 THEN ASSIGN tt-inspecao.resultado = STRING(res-fic-cq.resultado).             
          WHEN 2 THEN ASSIGN tt-inspecao.resultado = STRING(res-fic-cq.seq-comp).             
          WHEN 3 THEN ASSIGN tt-inspecao.resultado = STRING(res-fic-cq.laudo).             
          WHEN 4 THEN ASSIGN tt-inspecao.resultado = cLabel[2] + STRING(res-fic-cq.resultado) + " - " + cLabel[3] + STRING(res-fic-cq.res-max).             
      END CASE.       
     
      RUN retornaValorReferencia( INPUT ficha-cq.it-codigo,
                                  INPUT res-fic-cq.cod-exame, 
                                  INPUT res-fic-cq.cod-comp, 
                                  INPUT exam-ficha.cdn-versao, 
                                  OUTPUT tt-inspecao.referencia).
      
      RELEASE tt-inspecao.
      
   END.
   
   RETURN "OK":U.  
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FiltraInspecao DBOProgram 
PROCEDURE FiltraInspecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-inspecao.

    EMPTY TEMP-TABLE tt-inspecao NO-ERROR.

    CASE i-orig-restdo:
        WHEN 1 THEN DO:  /* CQ0350 Inspe‡Æo Acabado / Mat‚ria Prima */
           FOR EACH ficha-cq fields (it-codigo dt-inspecao idi-orig-restdo lote log-dia-sem-fornec nr-ficha cod-emitente cdn-vers-exam) NO-LOCK 
              WHERE ficha-cq.cod-estabel     = c-cod-estabel-ini
                AND ficha-cq.it-codigo       = c-ItCodigo-ini                
                AND ficha-cq.dt-inspecao    >= dt-data-ini
                AND ficha-cq.dt-inspecao    <= dt-data-fim  
                AND ficha-cq.idi-orig-restdo = i-orig-restdo:
                                         
              RUN carregaInspecao.
           END.                   
        END.
        WHEN 2 THEN DO:  /* CQ0330 Inspe‡Æo Antecipada */        
           FOR EACH ficha-cq fields (it-codigo dt-inspecao idi-orig-restdo lote log-dia-sem-fornec nr-ficha cod-emitente cdn-vers-exam) NO-LOCK 
              WHERE ficha-cq.it-codigo       = c-ItCodigo-ini                
                AND ficha-cq.dt-inspecao    >= dt-data-ini
                AND ficha-cq.dt-inspecao    <= dt-data-fim  
                AND ficha-cq.idi-orig-restdo = i-orig-restdo:
            
              IF NOT ficha-cq.log-dia-sem-fornec THEN
                 IF NOT (ficha-cq.cod-emitente >= i-cod-emitente-ini AND ficha-cq.cod-emitente <= i-cod-emitente-fim) THEN NEXT.
        
              RUN carregaInspecao.
           END.           
        END.
        WHEN 3 THEN DO: /* CQ0340 Produtos em Processo */ 
           FOR EACH ficha-cq fields (it-codigo dt-inspecao idi-orig-restdo lote log-dia-sem-fornec nr-ficha cod-emitente cdn-vers-exam) NO-LOCK 
              WHERE ficha-cq.cod-proces      = c-cod-proces-ini
                AND ficha-cq.cod-sub-proces  = c-cod-sub-proces-ini
                AND ficha-cq.cod-estabel     = c-cod-estabel-ini
                AND ficha-cq.cod-area-produc = c-cod-area-produc-ini                
                AND ficha-cq.dt-inspecao    >= dt-data-ini
                AND ficha-cq.dt-inspecao    <= dt-data-fim  
                AND ficha-cq.idi-orig-restdo = i-orig-restdo:
                                         
              RUN carregaInspecao.
           END.           
        END.        
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux. 
    EMPTY TEMP-TABLE RowObjectAux.
   
     DO WHILE AVAIL {&tableName}:
        CREATE RowObjectAux.
        BUFFER-COPY {&tableName} TO RowObjectAux.
		
		IF  (RowObjectAux.origem       = 1 
        AND RowObjectAux.baixa-estoq  = NO
        AND RowObjectAux.inspecionado = YES
        AND RowObjectAux.situacao     = 4
        AND RowObjectAux.liberada     = YES) OR RowObjectAux.log-1 THEN
            ASSIGN RowObjectAux.qt-original = 0.
        ELSE 
        IF(RowObjectAux.qt-original  - 
           RowObjectAux.qt-aprovada  - 
           RowObjectAux.qt-consumida - 
           RowObjectAux.qt-rejeitada - 
           RowObjectAux.qt-apr-cond) < 0 THEN
            ASSIGN RowObjectAux.qt-original = 0.
        ELSE 
            ASSIGN RowObjectAux.qt-original = RowObjectAux.qt-original  - 
                                              RowObjectAux.qt-aprovada  - 
                                              RowObjectAux.qt-consumida - 
                                              RowObjectAux.qt-rejeitada - 
                                              RowObjectAux.qt-apr-cond .
        GET NEXT {&queryName} NO-LOCK. 
    END. 
    
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-resp":U THEN ASSIGN pFieldValue = RowObject.cod-resp.
        WHEN "ct-destino":U THEN ASSIGN pFieldValue = RowObject.ct-destino.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "reg-lido":U THEN ASSIGN pFieldValue = RowObject.reg-lido.
        WHEN "sc-destino":U THEN ASSIGN pFieldValue = RowObject.sc-destino.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-analise":U THEN ASSIGN pFieldValue = RowObject.dt-analise.
        WHEN "dt-ficha":U THEN ASSIGN pFieldValue = RowObject.dt-ficha.
        WHEN "dt-inspecao":U THEN ASSIGN pFieldValue = RowObject.dt-inspecao.
        WHEN "dt-ult-sit":U THEN ASSIGN pFieldValue = RowObject.dt-ult-sit.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-a-liberar":U THEN ASSIGN pFieldValue = RowObject.qt-a-liberar.
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-aprovada":U THEN ASSIGN pFieldValue = RowObject.qt-aprovada.
        WHEN "qt-consumida":U THEN ASSIGN pFieldValue = RowObject.qt-consumida.
        WHEN "qt-original":U THEN ASSIGN pFieldValue = RowObject.qt-original.
        WHEN "qt-rejeitada":U THEN ASSIGN pFieldValue = RowObject.qt-rejeitada.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDtValid DBOProgram 
PROCEDURE getDtValid :
/*------------------------------------------------------------------------------
 Purpose: Busca  data de validade do lote pelo lote do roteiro.
 Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM pcItCodigo   LIKE {&TableName}.it-codigo    NO-UNDO.
DEFINE INPUT  PARAM pcCodEstabel LIKE {&TableName}.cod-estabel  NO-UNDO.
DEFINE INPUT  PARAM pcCodDepos   LIKE {&TableName}.cod-depos    NO-UNDO.
DEFINE INPUT  PARAM pcCodLocaliz LIKE {&TableName}.cod-localiz  NO-UNDO.
DEFINE INPUT  PARAM pcLote       LIKE {&TableName}.lote         NO-UNDO.
DEFINE INPUT  PARAM pcCodRefer   LIKE {&TableName}.cod-refer    NO-UNDO.
DEFINE OUTPUT PARAM pdtDtValid   LIKE saldo-estoq.dt-vali-lote NO-UNDO.

    FIND FIRST saldo-estoq
         WHERE saldo-estoq.it-codigo   = pcItCodigo  
           AND saldo-estoq.cod-estabel = pcCodEstabel
           AND saldo-estoq.cod-depos   = pcCodDepos  
           AND saldo-estoq.cod-localiz = pcCodLocaliz
           AND saldo-estoq.lote        = pcLote      
           AND saldo-estoq.cod-refer   = pcCodRefer  NO-LOCK NO-ERROR.
           
    IF AVAIL saldo-estoq THEN DO:    
        ASSIGN pdtDtValid = saldo-estoq.dt-vali-lote.              
        RETURN "OK":U.
    END.    
    ELSE
        RETURN "NOK":U.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-ord-cq":U THEN ASSIGN pFieldValue = RowObject.nr-ord-cq.
        WHEN "nr-ord-dest":U THEN ASSIGN pFieldValue = RowObject.nr-ord-dest.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ordem":U THEN ASSIGN pFieldValue = RowObject.nr-ordem.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sit-rot":U THEN ASSIGN pFieldValue = RowObject.sit-rot.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "idi-orig-restdo":U THEN ASSIGN pFieldValue = RowObject.idi-orig-restdo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-ficha
  Parameters:  
               retorna valor do campo nr-ficha
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ficha = RowObject.nr-ficha.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "inspecionado":U THEN ASSIGN pFieldValue = RowObject.inspecionado.
        WHEN "liberada":U THEN ASSIGN pFieldValue = RowObject.liberada.
        WHEN "log-com-nota":U THEN ASSIGN pFieldValue = RowObject.log-com-nota.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ch-ficha
  Parameters:  
               recebe valor do campo nr-ficha
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.

    FIND FIRST bfficha-cq WHERE 
        bfficha-cq.nr-ficha = pnr-ficha NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfficha-cq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfficha-cq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
  
   RUN getKey IN pHandle (OUTPUT c-it-codigo).
   
   RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyDataInspecao DBOProgram 
PROCEDURE openQuerybyDataInspecao :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.nr-ficha     >= NrFichaIni
           AND {&tableName}.nr-ficha     <= NrFichaFim
           AND {&tableName}.it-codigo    >= c-ItCodigo-ini
           AND {&tableName}.it-codigo    <= c-ItCodigo-fim
           AND {&tableName}.cod-emitente >= i-cod-emitente-ini
           AND {&tableName}.cod-emitente <= i-cod-emitente-fim
           AND {&tableName}.dt-inspecao >= dt-data-ini
           AND {&tableName}.dt-inspecao  <= dt-data-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyDataInspecao2 DBOProgram 
PROCEDURE openQuerybyDataInspecao2 :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.nr-ficha     >= NrFichaIni
           AND {&tableName}.nr-ficha     <= NrFichaFim
           AND {&tableName}.it-codigo    >= c-ItCodigo-ini
           AND {&tableName}.it-codigo    <= c-ItCodigo-fim
           AND {&tableName}.cod-emitente >= i-cod-emitente-ini
           AND {&tableName}.cod-emitente <= i-cod-emitente-fim
           AND ({&tableName}.dt-inspecao >= dt-data-ini
           AND {&tableName}.dt-inspecao  <= dt-data-fim
            OR {&tableName}.dt-inspecao   = ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDataInspecao DBOProgram 
PROCEDURE openQueryDataInspecao :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.idi-orig-restdo = i-orig-restdo
           AND {&tableName}.nr-ficha       >= NrFichaIni
           AND {&tableName}.nr-ficha       <= NrFichaFim 
           AND {&tableName}.it-codigo      >= c-ItCodigo-ini
           AND {&tableName}.it-codigo      <= c-ItCodigo-fim
           AND {&tableName}.cod-emitente   >= i-cod-emitente-ini
           AND {&tableName}.cod-emitente   <= i-cod-emitente-fim
           AND {&tableName}.dt-inspecao    >= dt-data-ini
           AND {&tableName}.dt-inspecao    <= dt-data-fim.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 open query {&QueryName} for each ficha-cq no-lock indexed-reposition.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryFiltro DBOProgram 
PROCEDURE OpenQueryFiltro :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/   
    CASE i-situacao:
                WHEN 0 THEN
                        OPEN QUERY {&queryName} 
                          FOR EACH {&tableName} NO-LOCK
                                 WHERE {&tableName}.it-codigo    = c-it-codigo 
                                   AND {&tableName}.nr-ficha    >= NrFichaIni
                                   AND {&tableName}.nr-ficha    <= NrFichaFim
                                   AND {&tableName}.cod-estabel >= c-cod-estabel-ini
                                   AND {&tableName}.cod-estabel <= c-cod-estabel-fim
                                   AND {&tableName}.cod-depos   >= c-cod-depos-ini
                                   AND {&tableName}.cod-depos   <= c-cod-depos-fim
                                   AND {&tableName}.nro-docto   >= c-nro-docto-ini  
                                   AND {&tableName}.nro-docto   <= c-nro-docto-fim 
                                   AND {&tableName}.cod-resp    >= c-responsavel-ini
                                   AND {&tableName}.cod-resp    <= c-responsavel-fim
                                   AND {&tableName}.dt-ficha    >= dt-data-ini
                                   AND {&tableName}.dt-ficha    <= dt-data-fim                                      
                                   AND {&tableName}.idi-orig-restdo <> 2 
                                   AND {&tableName}.idi-orig-restdo <> 3.
                WHEN 1 THEN
                    OPEN QUERY {&queryName} 
                          FOR EACH {&tableName} NO-LOCK
                                 WHERE {&tableName}.it-codigo    = c-it-codigo 
                                   AND {&tableName}.nr-ficha    >= NrFichaIni
                                   AND {&tableName}.nr-ficha    <= NrFichaFim
                                   AND {&tableName}.cod-estabel >= c-cod-estabel-ini
                                   AND {&tableName}.cod-estabel <= c-cod-estabel-fim
                                   AND {&tableName}.cod-depos   >= c-cod-depos-ini
                                   AND {&tableName}.cod-depos   <= c-cod-depos-fim
                                   AND {&tableName}.nro-docto   >= c-nro-docto-ini  
                                   AND {&tableName}.nro-docto   <= c-nro-docto-fim
                                   AND {&tableName}.cod-resp    >= c-responsavel-ini
                                   AND {&tableName}.cod-resp    <= c-responsavel-fim
                                   AND {&tableName}.dt-ficha    >= dt-data-ini
                                   AND {&tableName}.dt-ficha    <= dt-data-fim
                                   AND {&tableName}.situacao <> 4  /*TERMINADO*/
                                   AND {&tableName}.situacao <> 5  /*cancelado*/  
                                   AND {&tableName}.idi-orig-restdo <> 2 
                                   AND {&tableName}.idi-orig-restdo <> 3.              
        OTHERWISE
                        OPEN QUERY {&queryName} 
                          FOR EACH {&tableName} NO-LOCK
                                 WHERE {&tableName}.it-codigo    = c-it-codigo 
                                   AND {&tableName}.nr-ficha    >= NrFichaIni
                                   AND {&tableName}.nr-ficha    <= NrFichaFim
                                   AND {&tableName}.cod-estabel >= c-cod-estabel-ini
                                   AND {&tableName}.cod-estabel <= c-cod-estabel-fim
                                   AND {&tableName}.cod-depos   >= c-cod-depos-ini
                                   AND {&tableName}.cod-depos   <= c-cod-depos-fim
                                   AND {&tableName}.nro-docto   >= c-nro-docto-ini  
                                   AND {&tableName}.nro-docto   <= c-nro-docto-fim
                                   AND {&tableName}.cod-resp    >= c-responsavel-ini
                                   AND {&tableName}.cod-resp    <= c-responsavel-fim
                                   AND {&tableName}.dt-ficha    >= dt-data-ini
                                   AND {&tableName}.dt-ficha    <= dt-data-fim
                               AND {&tableName}.situacao <> 1  /*pendente*/
                                   AND {&tableName}.situacao <> 5  /*cancelado*/   
                                   AND {&tableName}.situacao =  i-situacao     
                                   AND {&tableName}.idi-orig-restdo <> 2 
                                   AND {&tableName}.idi-orig-restdo <> 3.       
        END CASE.                          
                   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.it-codigo = c-it-codigo
           AND {&tableName}.situacao <> 5  /*cancelado*/  
           AND {&tableName}.situacao <> 4  /*terminado*/     
           AND {&tableName}.idi-orig-restdo <> 2 
           AND {&tableName}.idi-orig-restdo <> 3.   
   
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem2 DBOProgram 
PROCEDURE openQueryItem2 :
/*------------------------------------------------------------------------------
 Purpose: Z06IN124
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.it-codigo       = c-it-codigo                       
           AND {&tableName}.idi-orig-restdo = i-orig-restdo.             
   
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 open query {&QueryName} for each ficha-cq no-lock indexed-reposition.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrFicha DBOProgram 
PROCEDURE openQueryNrFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY {&queryName} 
         FOR EACH  {&tableName} NO-LOCK
            WHERE  {&tableName}.nr-ficha >= NrFichaIni 
              AND  {&tableName}.nr-ficha <= NrFichaFim. 
            
       RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrigResult DBOProgram 
PROCEDURE openQueryOrigResult :
/*------------------------------------------------------------------------------
  Purpose: Abre a query para roteiros do CQ0240 e CQ0230 de acordo com o parametro 
           passado para o setConstraintResult.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName} for each {&tableName} no-lock
        WHERE {&tableName}.idi-orig-restdo = i-orig-restdo.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcSubProc DBOProgram 
PROCEDURE openQueryProcSubProc :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.idi-orig-restdo = i-orig-restdo
           AND {&tableName}.nr-ficha        >= NrFichaIni
           AND {&tableName}.nr-ficha        <= NrFichaFim
           AND {&tableName}.cod-estabel     >= c-cod-estabel-ini
           AND {&tableName}.cod-estabel     <= c-cod-estabel-fim
           AND {&tableName}.cod-area-produc >= c-cod-area-produc-ini
           AND {&tableName}.cod-area-produc <= c-cod-area-produc-fim
           AND {&tableName}.cod-proces      >= c-cod-proces-ini
           AND {&tableName}.cod-proces      <= c-cod-proces-fim
           AND {&tableName}.cod-sub-proces  >= c-cod-sub-proces-ini
           AND {&tableName}.cod-sub-proces  <= c-cod-sub-proces-fim
            BY {&tableName}.nr-ficha.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFormatoDecimais DBOProgram 
PROCEDURE retornaFormatoDecimais :
/*------------------------------------------------------------------------------
  Purpose: Retorna formato de casas decimais    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p-it-codigo LIKE ficha-cq.it-codigo     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-exame LIKE exam-ficha.cod-exame   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-comp  LIKE it-comp-exame.cod-comp NO-UNDO.
DEFINE INPUT  PARAMETER p-cdn-versao LIKE exame.cdn-versao      NO-UNDO.
DEFINE OUTPUT PARAMETER p-formato   AS   CHAR                   NO-UNDO.

   DEFINE VARIABLE c-dec AS CHAR                            NO-UNDO.
   DEFINE VARIABLE c-aux as char format "x(04)" init "9999" NO-UNDO.

   FOR FIRST it-comp-exame FIELDS(nr-decimais)
       WHERE it-comp-exame.it-codigo = p-it-codigo 
         AND it-comp-exame.cod-exame = p-cod-exame 
         AND it-comp-exame.cod-comp  = p-cod-comp no-lock:

      assign c-dec = "." +  substr(c-aux,1,it-comp-exame.nr-decimais).
      if  c-dec = "." then
          assign c-dec = "".
      assign p-formato = "->,>>>,>>9" + c-dec.
       
   END.

   IF NOT AVAIL it-comp-exame THEN DO:   

      FOR FIRST comp-exame FIELDS(nr-decimais) where
                comp-exame.cod-exame = p-cod-exame and
                comp-exame.cdn-versao = p-cdn-versao AND 
                comp-exame.cod-comp  = p-cod-comp NO-LOCK:
         
         assign c-dec = "." + substr(c-aux,1,comp-exame.nr-decimais).
         if  c-dec = "." then
             assign c-dec = "".
         assign p-formato = "->,>>>,>>9" + c-dec.
                
      end.

   end.


END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFormatoTipoResultado DBOProgram 
PROCEDURE retornaFormatoTipoResultado :
/*------------------------------------------------------------------------------
  Purpose: Retorna formato de acordo com tipo de resultado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p-it-codigo LIKE ficha-cq.it-codigo     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-exame LIKE exam-ficha.cod-exame   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-comp  LIKE it-comp-exame.cod-comp NO-UNDO.
DEFINE INPUT  PARAMETER p-cdn-versao LIKE exame.cdn-versao      NO-UNDO.
DEFINE OUTPUT PARAMETER p-result    AS   CHAR                   NO-UNDO.

   def var c-aux         as char   format "x(04)" init "9999" no-undo.
   def var c-decimal     as char   format "x(05)"             no-undo.
   def var c-formato     as char   format "x(14)"             no-undo.
   DEF VAR de-result-min LIKE comp-exame.result-min           NO-UNDO.
   DEF VAR de-result-max LIKE comp-exame.result-max           NO-UNDO.


   FOR FIRST it-comp-exame FIELDS(nr-decimais nr-tabela result-min result-max tipo-result)
       WHERE it-comp-exame.it-codigo = p-it-codigo 
         AND it-comp-exame.cod-exame = p-cod-exame 
         AND it-comp-exame.cod-comp  = p-cod-comp 
         AND it-comp-exame.situacao  = 1 /* ativo */ no-lock: END.

   if avail it-comp-exame then do:
      IF it-comp-exame.tipo-result = 1 OR 
         it-comp-exame.tipo-result = 4 THEN DO:

          assign c-decimal = "." + substr(c-aux,1,int(it-comp-exame.nr-decimais)).
          if  c-decimal = "." then
              assign c-decimal = "".
          assign c-formato = "->,>>>,>>9" + c-decimal.
          
          ASSIGN de-result-min = it-comp-exame.result-min 
                 de-result-max = it-comp-exame.result-max
                 p-result = trim(string(de-result-min,c-formato)) + " - " + trim(string(de-result-max,c-formato)).
      END.
      /*tabela*/
      ELSE IF it-comp-exame.tipo-result = 2 THEN DO:

          FIND FIRST tab-result NO-LOCK
               WHERE tab-result.nr-tabela = it-comp-exame.nr-tabela NO-ERROR.
          IF AVAIL tab-result THEN
              ASSIGN p-result = string(tab-result.nr-tabela) + " - " + tab-result.descricao.
      END.
               
   end.

   else do:
       
      FOR FIRST comp-exame FIELDS(nr-decimais result-min result-max tipo-result nr-tabela) where
                comp-exame.cod-exame = p-cod-exame and
                comp-exame.cod-comp  = p-cod-comp AND 
                comp-exame.cdn-versao = p-cdn-versao NO-LOCK:
         
         IF comp-exame.tipo-result = 1 OR 
            comp-exame.tipo-result = 4 THEN DO:
    
              assign c-decimal = "." + substr(c-aux,1,int(comp-exame.nr-decimais)).
              if  c-decimal = "." then
                  assign c-decimal = "".
              assign c-formato = "->,>>>,>>9" + c-decimal.
              
              ASSIGN de-result-min = comp-exame.result-min 
                     de-result-max = comp-exame.result-max
                     p-result = trim(string(de-result-min,c-formato)) + " - " + trim(string(de-result-max,c-formato)).
          END.
          /*tabela*/
          ELSE IF comp-exame.tipo-result = 2 THEN DO:
    
              FIND FIRST tab-result NO-LOCK
                   WHERE tab-result.nr-tabela = comp-exame.nr-tabela NO-ERROR.
              IF AVAIL tab-result THEN
                  ASSIGN p-result = string(tab-result.nr-tabela) + " - " + tab-result.descricao.
          END.
      end.
   end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValorReferencia DBOProgram 
PROCEDURE retornaValorReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER p-it-codigo  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER p-cod-exame  AS INTEGER   NO-UNDO.        
   DEFINE INPUT  PARAMETER p-cod-comp   AS INTEGER   NO-UNDO.
   DEFINE INPUT  PARAMETER p-cdn-versao AS INTEGER   NO-UNDO.
   DEFINE OUTPUT PARAMETER p-result     AS CHARACTER NO-UNDO.

   DEFINE VARIABLE cAux     AS CHARACTER FORMAT "x(04)" INITIAL "9999" NO-UNDO.
   DEFINE VARIABLE cDecimal AS CHARACTER FORMAT "x(05)"                NO-UNDO.
   DEFINE VARIABLE cFormato AS CHARACTER FORMAT "x(14)"                NO-UNDO.
   DEFINE VARIABLE cLabel   AS CHARACTER EXTENT 2                      NO-UNDO.
   DEFINE VARIABLE deResultMin LIKE comp-exame.result-min NO-UNDO.
   DEFINE VARIABLE deResultMax LIKE comp-exame.result-max NO-UNDO.   
   
   FOR FIRST bf-it-comp-exame  NO-LOCK
       WHERE bf-it-comp-exame.cod-exame  = p-cod-exame
         AND bf-it-comp-exame.cod-comp   = p-cod-comp
         AND bf-it-comp-exame.it-codigo =  p-it-codigo: END.
        
   FOR FIRST bf-comp-exame NO-LOCK
       WHERE bf-comp-exame.cod-exame  = p-cod-exame
         AND bf-comp-exame.cod-comp   = p-cod-comp
         AND bf-comp-exame.cdn-versao = p-cdn-versao: END.
    
   IF AVAILABLE bf-it-comp-exame THEN DO:  
       {inbo/boin124a.i4 "bf-it-comp-exame"}                                                                            
   END.
   ELSE IF AVAILABLE bf-comp-exame THEN DO:
       {inbo/boin124a.i4 "bf-comp-exame"}         
   END.
   
   RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAcabado DBOProgram 
PROCEDURE setConstraintAcabado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-ItCodigo-ini     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-ItCodigo-fim     AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER p-cod-estabel-ini  LIKE ficha-cq.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim  LIKE ficha-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-data-ini         LIKE ficha-cq.dt-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-data-fim         LIKE ficha-cq.dt-ficha NO-UNDO.    
    DEFINE INPUT PARAMETER p-origem           LIKE ficha-cq.idi-orig-restdo NO-UNDO.
    
    ASSIGN  c-cod-estabel-ini   = p-cod-estabel-ini
            c-cod-estabel-fim   = p-cod-estabel-fim
            c-ItCodigo-ini      = p-ItCodigo-ini     
            c-ItCodigo-fim      = p-ItCodigo-fim 
            dt-data-ini         = p-data-ini        
            dt-data-fim         = p-data-fim
            i-orig-restdo       = p-origem.                               
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDataInspecao DBOProgram 
PROCEDURE setConstraintDataInspecao :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-NrFichaIni       LIKE ficha-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-NrFichaFim       LIKE ficha-cq.nr-ficha NO-UNDO.    
    DEFINE INPUT PARAMETER p-ItCodigo-ini     LIKE ITEM.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-ItCodigo-fim     LIKE ITEM.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente-ini LIKE ficha-cq.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente-fim LIKE ficha-cq.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-data-ini         LIKE ficha-cq.dt-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-data-fim         LIKE ficha-cq.dt-ficha NO-UNDO.    
    DEFINE INPUT PARAMETER p-origem           LIKE ficha-cq.idi-orig-restdo NO-UNDO.
    
    ASSIGN  NrFichaIni          = p-NrFichaIni      
            NrFichaFim          = p-NrFichaFim      
            c-ItCodigo-ini      = p-ItCodigo-ini    
            c-ItCodigo-fim      = p-ItCodigo-fim      
            i-cod-emitente-ini  = p-cod-emitente-ini
            i-cod-emitente-fim  = p-cod-emitente-fim
            dt-data-ini         = p-data-ini        
            dt-data-fim         = p-data-fim
            i-orig-restdo       = p-origem.                               
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintFiltro DBOProgram 
PROCEDURE SetConstraintFiltro :
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ItCodigo        AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-NrFichaIni      LIKE ficha-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-NrFichaFim      LIKE ficha-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-depos-ini   AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-depos-fim   AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-data-ini        LIKE ficha-cq.dt-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-data-fim        LIKE ficha-cq.dt-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao        LIKE ficha-cq.situacao NO-UNDO.   
    DEFINE INPUT PARAMETER p-c-nro-docto-ini AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-c-nro-docto-fim AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-responsavel-ini AS CHARACTER           NO-UNDO.
    DEFINE INPUT PARAMETER p-responsavel-fim AS CHARACTER           NO-UNDO.

    
    ASSIGN c-it-codigo       = p-ItCodigo
           NrFichaIni        = p-NrFichaIni
           NrFichaFim        = p-NrFichaFim
           c-cod-estabel-ini = p-cod-estabel-ini  
           c-cod-estabel-fim = p-cod-estabel-fim
           c-cod-depos-ini   = p-cod-depos-ini
           c-cod-depos-fim   = p-cod-depos-fim
           dt-data-ini       = p-data-ini
           dt-data-fim       = p-data-fim
           i-situacao        = p-situacao
           c-nro-docto-ini   = p-c-nro-docto-ini 
           c-nro-docto-fim   = p-c-nro-docto-fim 
           c-responsavel-ini = p-responsavel-ini
           c-responsavel-fim = p-responsavel-fim.
   
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintItem DBOProgram 
PROCEDURE SetConstraintItem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pItCodigo  AS CHAR.
   
   ASSIGN c-it-codigo = pItCodigo.
   
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem2 DBOProgram 
PROCEDURE setConstraintItem2 :
/*------------------------------------------------------------------------------
 Purpose: Z06IN124
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-pOrigRestdo LIKE {&TableName}.idi-orig-restdo NO-UNDO.    
    DEFINE INPUT PARAM pc-it-codigo   LIKE {&TableName}.it-codigo       NO-UNDO.   

    ASSIGN i-orig-restdo = pi-pOrigRestdo
           c-it-codigo   = pc-it-codigo. 
           
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrFicha DBOProgram 
PROCEDURE setConstraintNrFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pNrFichaIni  AS INT.
define input parameter pNrFichaFim AS INT.
   
   assign NrFichaIni = pNrFichaIni 
          NrFichaFim = pNrFichaFim.
   
   RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrigResult DBOProgram 
PROCEDURE setConstraintOrigResult :
/*------------------------------------------------------------------------------
  Purpose: Receber parametro para filtrar roteiros na openQueryOrigResult    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   define input parameter pOrigRestdo  AS INT.
   
   assign i-orig-restdo = pOrigRestdo.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcesso DBOProgram 
PROCEDURE setConstraintProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-proces-ini      LIKE ficha-cq.cod-proces      NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-proces-fim      LIKE ficha-cq.cod-proces      NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-sub-proces-ini  LIKE ficha-cq.cod-sub-proces  NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-sub-proces-fim  LIKE ficha-cq.cod-sub-proces  NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-estabel-ini     LIKE ficha-cq.cod-estabel     NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-estabel-fim     LIKE ficha-cq.cod-estabel     NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-area-produc-ini LIKE ficha-cq.cod-area-produc NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-area-produc-fim LIKE ficha-cq.cod-area-produc NO-UNDO. 
    DEFINE INPUT PARAMETER p-data-ini            LIKE ficha-cq.dt-ficha        NO-UNDO.
    DEFINE INPUT PARAMETER p-data-fim            LIKE ficha-cq.dt-ficha        NO-UNDO.    
    DEFINE INPUT PARAMETER p-origem              LIKE ficha-cq.idi-orig-restdo NO-UNDO.

    ASSIGN  c-cod-proces-ini      = p-cod-proces-ini     
            c-cod-proces-fim      = p-cod-proces-fim     
            c-cod-sub-proces-ini  = p-cod-sub-proces-ini 
            c-cod-sub-proces-fim  = p-cod-sub-proces-fim 
            c-cod-estabel-ini     = p-cod-estabel-ini    
            c-cod-estabel-fim     = p-cod-estabel-fim    
            c-cod-area-produc-ini = p-cod-area-produc-ini
            c-cod-area-produc-fim = p-cod-area-produc-fim
            dt-data-ini           = p-data-ini        
            dt-data-fim           = p-data-fim
            i-orig-restdo         = p-origem.                                
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcSubProc DBOProgram 
PROCEDURE setConstraintProcSubProc :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-NrFichaIni         LIKE ficha-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-NrFichaFim         LIKE ficha-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini    LIKE ficha-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim    LIKE ficha-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-area-ini           LIKE ficha-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-area-fim           LIKE ficha-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces-ini     LIKE ficha-cq.cod-proces NO-UNDO.    
    DEFINE INPUT PARAMETER p-cod-proces-fim     LIKE ficha-cq.cod-proces NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-sub-proces-ini LIKE ficha-cq.cod-proces NO-UNDO.    
    DEFINE INPUT PARAMETER p-cod-sub-proces-fim LIKE ficha-cq.cod-proces NO-UNDO.
    DEFINE INPUT PARAMETER p-origem             LIKE ficha-cq.idi-orig-restdo NO-UNDO.
    
    ASSIGN  NrFichaIni            = p-NrFichaIni      
            NrFichaFim            = p-NrFichaFim    
            c-cod-estabel-ini     = p-cod-estabel-ini
            c-cod-estabel-fim     = p-cod-estabel-fim
            c-cod-area-produc-ini = p-area-ini        
            c-cod-area-produc-fim = p-area-fim
            c-cod-proces-ini      = p-cod-proces-ini    
            c-cod-proces-fim      = p-cod-proces-fim      
            c-cod-sub-proces-ini  = p-cod-proces-ini    
            c-cod-sub-proces-fim  = p-cod-proces-fim
            i-orig-restdo         = p-origem.                               
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDiaSemFornec DBOProgram 
PROCEDURE validaDiaSemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-dt-ficha LIKE ficha-cq.dt-ficha NO-UNDO.

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.idi-orig-restdo = 2 
           AND bf{&TableName}.dt-ficha = p-dt-ficha NO-ERROR.
    IF AVAIL bf{&TableName} THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDigitacaoFaixa DBOProgram 
PROCEDURE validaDigitacaoFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-it-codigo  LIKE {&TableName}.it-codigo NO-UNDO. 
    DEFINE INPUT PARAM pi-cod-exame  AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cod-comp   AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM de-res-min    AS DECIMAL                  NO-UNDO.
    DEFINE INPUT PARAM de-res-max    AS DECIMAL                  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR rowErrors.
         
    DEFINE VARIABLE c-trad-1 AS CHARACTER NO-UNDO.

    FIND FIRST comp-exame
         WHERE comp-exame.cod-exame  = pi-cod-exame
           AND comp-exame.cod-comp   = pi-cod-comp
           AND comp-exame.cdn-versao = pi-cdn-versao NO-LOCK NO-ERROR.
    IF NOT AVAIL comp-exame THEN
        FIND FIRST it-comp-exame 
             WHERE it-comp-exame.cod-exame  = pi-cod-exame
               AND it-comp-exame.cod-comp   = pi-cod-comp              
               AND it-comp-exame.it-codigo  = pc-it-codigo NO-LOCK NO-ERROR.
               
    if  de-res-max < de-res-min then do:
            {utp/ut-field.i mgind comp-exame result-min 1}
            assign c-trad-1 = return-value.
            {utp/ut-field.i mgind comp-exame result-max 1}           
            {method/svc/errors/inserr.i
                       &ErrorNumber="508"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="c-trad-1 + '~~~~' + return-value"}  
                       
                       
    end.  
               
   
    
        /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDigitacaoResultado DBOProgram 
PROCEDURE validaDigitacaoResultado :
/*------------------------------------------------------------------------------
 Purpose: VERIFICA SE O RESULTADO DIGITADO ESTÁ DENTRO DA FAIXA PARA O COMPONENTE.
 Notes: RETORNA "OK" CASO ESTIVER NA DENTRO DA FAIXA E "NOK" CASO NÃO ESTIVER.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  pi-origem     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM  pi-cod-exame  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM  pi-cod-comp   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM  pi-cdn-versao AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM  pc-it-codigo  AS CHARACTER NO-UNDO.   
    DEFINE INPUT PARAM  pd-resultado  AS DECIMAL NO-UNDO.
    
    IF pi-origem = 1 THEN DO:         
        FIND FIRST it-comp-exame 
             WHERE it-comp-exame.cod-exame = pi-cod-exame
               AND it-comp-exame.cod-comp  = pi-cod-comp 
               AND it-comp-exame.it-codigo = pc-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL it-comp-exame THEN DO:
            IF pd-resultado < it-comp-exame.result-min 
            OR pd-resultado > it-comp-exame.result-max THEN 
                RETURN "NOK":U. 
        END.   
    END.        
    ELSE DO:
        FIND FIRST comp-exame 
             WHERE comp-exame.cod-exame = pi-cod-exame 
               AND comp-exame.cdn-versao = pi-cdn-versao
               AND comp-exame.cod-comp  = pi-cod-comp  NO-LOCK NO-ERROR.
        IF AVAIL comp-exame THEN DO:
            IF pd-resultado < comp-exame.result-min 
            OR pd-resultado > comp-exame.result-max THEN               
                RETURN "NOK":U.   
        END.    
    END.   
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaExameRoteiro DBOProgram 
PROCEDURE validaExameRoteiro :
/*------------------------------------------------------------------------------
 Purpose: Verifica se o roteiro Inspeção  possui Exames
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM l-exames AS LOGICAL NO-UNDO.

    ASSIGN l-exames = CAN-FIND(FIRST exam-ficha 
                               WHERE exam-ficha.nr-ficha = Rowobject.nr-ficha).
                               
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaFichaGeral DBOProgram 
PROCEDURE validaFichaGeral :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-mesg1 AS CHARACTER NO-UNDO.
    
    FIND FIRST exam-ficha 
         WHERE exam-ficha.nr-ficha = RowObject.nr-ficha NO-LOCK NO-ERROR.  
                   
   if  not avail exam-ficha then do:
       {utp/ut-liter.i Roteiro MCQ}
        assign c-mesg1 = trim(return-value).
        {utp/ut-table.i mgind exame 1}
  
        {method/svc/errors/inserr.i
                       &ErrorNumber="2734"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="c-mesg1 + '~~~~' +
                                         return-value"} 
        RETURN "NOK":U.
        
    END.               
                   
    IF AVAIL exam-ficha THEN DO:            
        FIND FIRST responsavel 
             WHERE responsavel.cod-resp = c-seg-usuario NO-LOCK NO-ERROR.  
             
        IF AVAIL responsavel 
             AND exam-ficha.responsavel <> responsavel.cod-resp THEN DO:                
            FIND FIRST b-responsavel
                 WHERE b-responsavel.cod-resp = exam-ficha.responsavel NO-LOCK NO-ERROR.          
            IF  AVAIL b-responsavel AND b-responsavel.log-1 = NO THEN DO:  
                
                {method/svc/errors/inserr.i
                       &ErrorNumber="4304"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="STRING(exam-ficha.cod-exame) + '~~~~' +
                                         exam-ficha.responsavel"}  
                                         
                RETURN "NOK":U.                         
            END.                                  
        END.

        FIND FIRST ficha-cq 
             WHERE ficha-cq.nr-ficha = exam-ficha.nr-ficha NO-LOCK NO-ERROR.
        IF  AVAIL ficha-cq THEN DO:
            IF  ficha-cq.inspecionado = YES THEN DO:
                {method/svc/errors/inserr.i
                       &ErrorNumber="827"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="''"}   
                                    
                RETURN "NOK".
            END.
            IF  ficha-cq.situacao <> 2 THEN DO:                
                {method/svc/errors/inserr.i
                       &ErrorNumber="828"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="''"} 
                                      
                RETURN "NOK".
            END.
            IF  ficha-cq.qt-original  - ficha-cq.qt-aprovada
              - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
              - ficha-cq.qt-apr-cond <= 0 THEN DO:                  
                {method/svc/errors/inserr.i
                       &ErrorNumber="829"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="''"}  
                       
                 RETURN "NOK".      
            END.
        END.            
    END.  
    
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaFornecedor DBOProgram 
PROCEDURE validaFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT PARAM pi-cod-fabrican LIKE {&TableName}.cod-fabrican NO-UNDO.
    
    IF NOT CAN-FIND(FIRST fab-medic-item
                    WHERE fab-medic-item.cod-item = pc-it-codigo
                      AND fab-medic-item.cdn-fabrican = pi-cod-fabrican) THEN DO:

        {method/svc/errors/inserr.i
               &ErrorNumber = 54136
               &ErrorType="EMS"
               &ErrorSubType="ERROR" 
               &ErrorParameters= " STRING(pi-cod-fabrican) + '~~~~' + pc-it-codigo"}  
           
                                         
        RETURN "NOK":U.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQuantidadeRetorno DBOProgram 
PROCEDURE validaQuantidadeRetorno :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    FIND FIRST ficha-cq 
         WHERE ficha-cq.nr-ficha = RowObject.nr-ficha NO-LOCK NO-ERROR.  
                   
    IF AVAIL ficha-cq THEN DO:                
        IF  ficha-cq.origem       = 1
        AND ficha-cq.baixa-estoq  = NO
        AND ficha-cq.inspecionado = YES
        AND ficha-cq.situacao     = 4
        AND ficha-cq.liberada     = YES THEN DO:
            /* Quantidade em CQ igual a zero, Roteiro já inspecionado */
            {method/svc/errors/inserr.i  
                  &ErrorNumber="829"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR" 
                  &ErrorParameters="''"}    
                  
            RETURN "NOK":U.                    
        END.

        IF  ficha-cq.qt-original  - ficha-cq.qt-aprovada
          - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
          - ficha-cq.qt-apr-cond <= 0 THEN DO:
            /* Quantidade em CQ igual a zero, Roteiro já inspecionado */
            {method/svc/errors/inserr.i  
                  &ErrorNumber="829"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR" 
                  &ErrorParameters="''"}  
            RETURN "NOK":U.       
        END.
    END. 
    
    RETURN "OK":U.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaResMax DBOProgram 
PROCEDURE validaResMax :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-it-codigo  LIKE {&TableName}.it-codigo NO-UNDO. 
    DEFINE INPUT PARAM pi-cod-exame  AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cod-comp   AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM de-res-max    AS DECIMAL                  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR rowErrors.
    
    DEFINE VARIABLE l-erro-faixa AS LOGICAL NO-UNDO.
    
    FIND FIRST it-comp-exame NO-LOCK 
         WHERE it-comp-exame.cod-exame  = pi-cod-exame
           AND it-comp-exame.cod-comp   = pi-cod-comp
           AND it-comp-exame.it-codigo  = pc-it-codigo NO-ERROR.
           
    /* VERIFICA SE EXISTE ESPECIALIZACAO COMP-EXAME POR ITEM */
    IF AVAILABLE  it-comp-exame THEN DO:
        ASSIGN l-erro-faixa = (de-res-max < it-comp-exame.result-min)OR
                              (de-res-max > it-comp-exame.result-max).
             
        END.
    ELSE DO:
        /* CASO NAO EXISTA ESPECIALIZACAO, BUSCA O COMPONENTE DO EXAME */
        FIND FIRST comp-exame
             WHERE comp-exame.cod-exame  = pi-cod-exame
               AND comp-exame.cod-comp   = pi-cod-comp
               AND comp-exame.cdn-versao = pi-cdn-versao NO-LOCK NO-ERROR.
        IF AVAILABLE comp-exame THEN DO:
            ASSIGN l-erro-faixa = (de-res-max < comp-exame.result-min) OR
                                  (de-res-max > comp-exame.result-max).
        END.
    END.

    IF l-erro-faixa THEN DO:
        {method/svc/errors/inserr.i
               &ErrorNumber="1098"
               &ErrorType="EMS"
               &ErrorSubType="ERROR" 
               &ErrorParameters="''"}
    END.
        /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaResMin DBOProgram 
PROCEDURE validaResMin :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-it-codigo  LIKE {&TableName}.it-codigo NO-UNDO. 
    DEFINE INPUT PARAM pi-cod-exame  AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cod-comp   AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAM de-res-min    AS DECIMAL                  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR rowErrors.
    
    DEFINE VARIABLE l-erro-faixa AS LOGICAL NO-UNDO.
    
    FIND FIRST it-comp-exame NO-LOCK 
         WHERE it-comp-exame.cod-exame  = pi-cod-exame
           AND it-comp-exame.cod-comp   = pi-cod-comp
           AND it-comp-exame.it-codigo  = pc-it-codigo NO-ERROR.
    
    /* VERIFICA SE COMPONENTE DO EXAME DO ITEM (Especializcao comp-exame)*/
    IF AVAILABLE  it-comp-exame THEN DO:
        ASSIGN l-erro-faixa = (de-res-min > it-comp-exame.result-max) OR 
                              (de-res-min < it-comp-exame.result-min).
    END.
    ELSE DO:
        /* CASO NAO EXISTA ESPECIALIZACAO, BUSCA O COMPONENTE DO EXAME */
        FIND FIRST comp-exame
             WHERE comp-exame.cod-exame  = pi-cod-exame
               AND comp-exame.cod-comp   = pi-cod-comp
               AND comp-exame.cdn-versao = pi-cdn-versao NO-LOCK NO-ERROR.
        IF AVAILABLE comp-exame THEN DO:
             ASSIGN l-erro-faixa = (de-res-min > comp-exame.result-max) OR 
                                   (de-res-min < comp-exame.result-min).
        END.
    END.
    
    IF l-erro-faixa THEN DO:
         {method/svc/errors/inserr.i
                       &ErrorNumber="17150"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="''"} 
    END.
        /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaResponsavelFicha DBOProgram 
PROCEDURE validaResponsavelFicha :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    FIND FIRST ficha-cq 
         WHERE ficha-cq.nr-ficha = RowObject.nr-ficha NO-LOCK NO-ERROR. 
       
    IF AVAIL ficha-cq THEN DO:  
        ASSIGN i-nr-ficha = ficha-cq.nr-ficha.          
        find b-responsavel where b-responsavel.cod-resp = c-seg-usuario no-lock no-error.
                    
        if  avail b-responsavel
            and ficha-cq.cod-resp <> "" then do:
                if  ficha-cq.cod-resp <> c-seg-usuario and b-responsavel.log-1 = no then do:
                    /* Este roteiro nÆo ‚ de responsabilidade deste usu rio. */
             
                    {method/svc/errors/inserr.i
                       &ErrorNumber="15636"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="''"}  
                                         
                    RETURN "NOK":U.                  
                end.          
                                              
        END.
    END.    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRoteiroAntecipado DBOProgram 
PROCEDURE validateRoteiroAntecipado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR Rowobject-aux.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    FIND FIRST Rowobject-aux NO-LOCK NO-ERROR.
    IF AVAIL Rowobject-aux THEN DO:

        IF pType = "Create":U THEN DO:
            
            FOR FIRST ITEM FIELDS(tipo-con-est)
                WHERE ITEM.it-codigo = Rowobject-aux.it-codigo NO-LOCK: END.
            IF NOT AVAIL ITEM THEN DO:
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="c-lbl-liter-item"}   
            END.

            for first item-uni-estab no-lock
                where item-uni-estab.it-codigo   = Rowobject-aux.it-codigo
                  and item-uni-estab.cod-estabel = Rowobject-aux.cod-estabel:
                IF item-uni-estab.log-rotei-pend = NO THEN DO:
                    DEFINE VARIABLE c-lbl-liter-item-est AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Item" *}
                    ASSIGN c-lbl-liter-item-est = RETURN-VALUE.
                    DEFINE VARIABLE c-lbl-liter-item-rot-antecip AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i Item_do_Estabelecimento_nÆo_est _paremetrizado_como_Roteiro_de_Inspe‡Æo_Antecipado_no_CQ0124 *}
                    ASSIGN c-lbl-liter-item-rot-antecip = RETURN-VALUE.
                    {method/svc/errors/inserr.i
                             &ErrorNumber="158"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-lbl-liter-item-est + '~~~~' + c-lbl-liter-item-rot-antecip"}
                END.
            end.

        
            IF NOT CAN-FIND(FIRST emitente
                            WHERE emitente.cod-emitente = Rowobject-aux.cod-emitente) THEN DO:
                DEFINE VARIABLE c-lbl-liter-fornec AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fornecedor" *}
                ASSIGN c-lbl-liter-fornec = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="c-lbl-liter-fornec"}   
            END.
    
            IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = Rowobject-aux.cod-estabel) THEN DO:
                DEFINE VARIABLE c-lbl-liter-estab AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Estabelecimento" *}
                ASSIGN c-lbl-liter-estab = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="c-lbl-liter-estab"}   
            END.
    
            FOR FIRST item-uni-estab FIELDS(contr-qualid)
                WHERE item-uni-estab.it-codigo   = Rowobject-aux.it-codigo
                  AND item-uni-estab.cod-estabel = Rowobject-aux.cod-estabel NO-LOCK:  END.
            IF NOT AVAIL item-uni-estab THEN DO:
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="5101"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="''"}   
            END.
            ELSE DO:
                 if item-uni-estab.contr-qualid = NO then do:
                     {method/svc/errors/inserr.i
                                         &ErrorNumber="8843"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR" 
                                         &ErrorParameters="''"}   
                 end.
            END.
             
            IF NOT CAN-FIND(FIRST deposito
                        WHERE deposito.cod-depos = Rowobject-aux.cod-depos) THEN DO:
                DEFINE VARIABLE c-lbl-liter-depos AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Deposito" *}
                ASSIGN c-lbl-liter-depos = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="c-lbl-liter-depos"}   
            END.
    
            IF  AVAIL ITEM             AND
               (ITEM.tipo-con-est = 2  OR
                ITEM.tipo-con-est = 3  OR
                ITEM.tipo-con-est = 4) THEN DO:
    
                IF Rowobject-aux.lote = "" THEN DO:
                    {method/svc/errors/inserr.i
                                         &ErrorNumber="1818"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR" 
                                         &ErrorParameters="''"}   
                END.
            END.
            
            IF Rowobject-aux.log-dia-sem-fornec THEN DO:
                RUN validaDiaSemFornec (INPUT Rowobject-aux.data-1).
                IF RETURN-VALUE = "NOK" THEN DO:
                    DEFINE VARIABLE c-lbl-liter-dia-sem-fornec AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Roteiro assinalado com Dia sem Fornecimento~~data" *}
                    ASSIGN c-lbl-liter-dia-sem-fornec = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="31724" /* MES: J  existe &1 para &2. */
                                       &ErrorType="EMS"     /* HELP: J  existe &1 no(a) &2 informado(a), por favor informe outro(a) &3. */
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="c-lbl-liter-dia-sem-fornec"}   
                END.
            END.

        END.

        IF NOT CAN-FIND(FIRST fab-medic
                    WHERE fab-medic.cdn-fabrican = int(Rowobject-aux.cod-fabricante)) THEN DO:
            DEFINE VARIABLE c-lbl-liter-fabric AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fabricante" *}
            ASSIGN c-lbl-liter-fabric = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="56"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-fabric"}   
        END.

        IF NOT CAN-FIND(FIRST emitente
                        WHERE emitente.cod-emitente = Rowobject-aux.cdn-lab) THEN DO:
            DEFINE VARIABLE c-lbl-liter-lab AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Laboratorio" *}
            ASSIGN c-lbl-liter-lab = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="56"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-lab"}   
        END.
    
    END.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRoteiroProcesso DBOProgram 
PROCEDURE validateRoteiroProcesso :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE c-msg-aux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-tem-exam   AS LOGICAL INITIAL FALSE NO-UNDO.
    DEFINE VARIABLE l-tem-comp   AS LOGICAL INITIAL FALSE NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    IF  pType <> "DELETE":U THEN DO: /* Create e Update */
        
        /* Valida estabelecimento */
        IF  NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-table.i mgadm estabelec 1} /* Busca label da tabela */
            {method/svc/errors/inserr.i
                &ErrorNumber="2" /* NÆo encontrado(a) &1 para chave informada. */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        /* Valida  rea */
        IF  NOT CAN-FIND(FIRST area-produc WHERE area-produc.cod-area-produc = RowObject.cod-area-produc) THEN DO:
            {utp/ut-table.i mgind area-produc 1} /* Busca label da tabela */
            {method/svc/errors/inserr.i
                &ErrorNumber="2" /* NÆo encontrado(a) &1 para chave informada. */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        /* Valida processo */
        IF  NOT CAN-FIND(FIRST proces-cq 
                         WHERE proces-cq.cod-estabel     = RowObject.cod-estabel
                           AND proces-cq.cod-area-produc = RowObject.cod-area-produc
                           AND proces-cq.cod-proces      = RowObject.cod-proces) THEN DO:
            {utp/ut-table.i mgind proces-cq 1} /* Busca label da tabela */
            {method/svc/errors/inserr.i
                &ErrorNumber="2" /* NÆo encontrado(a) &1 para chave informada. */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        /* Valida a data do roteiro */
        IF  RowObject.dt-ficha > TODAY THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="7057" /* Data nÆo pode ser superior a data corrente */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"}
        END.

        /* Valida se tem o relacionamento  rea x processo x subprocesso */
        IF  NOT CAN-FIND(FIRST sub-proces-cq 
                            WHERE sub-proces-cq.cod-estabel     = RowObject.cod-estabel
                              AND sub-proces-cq.cod-area-produc = RowObject.cod-area-produc
                              AND sub-proces-cq.cod-proces      = RowObject.cod-proces
                              AND sub-proces-cq.cod-sub-proces  = RowObject.cod-sub-proces) THEN DO:
            {utp/ut-liter.i NÆo_foi_encontrado_o_relacionamento_ rea_x_processo_x_subprocesso. *}
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        /* Se ‚ um dia sem fornecimento, valida se j  existe um roteiro cadastrado para a data */
        IF  RowObject.log-dia-sem-fornec THEN DO:
            IF  CAN-FIND(FIRST ficha-cq 
                            WHERE ficha-cq.idi-orig-restdo = 3 /* Roteiros originados do cq0230 */
                              AND ficha-cq.log-dia-sem-fornec
                              AND ficha-cq.dt-ficha = RowObject.dt-ficha) THEN DO:
                {utp/ut-liter.i roteiro_assinalado_com_dia_sem_fabrica‡Æo *}
                ASSIGN c-msg-aux = TRIM(RETURN-VALUE).
                {utp/ut-liter.i data *}
                ASSIGN c-msg-aux = c-msg-aux + "~~" + TRIM(RETURN-VALUE) + "~~" + TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="31724" /* J  existe &1 para &2. */
                    &ErrorType="EMS"     /* HELP: J  existe &1 no(a) &2 informado(a), por favor informe outro(a) &3. */
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-msg-aux}
            END.
        END.

        /* Verifica se existem exames com componentes, vinculados ao subprocesso informado */
        FOR EACH exam-sub-proces-cq FIELDS (cod-exame)
            WHERE exam-sub-proces-cq.cod-estabel   = RowObject.cod-estabel
            AND exam-sub-proces-cq.cod-area-produc = RowObject.cod-area-produc
            AND exam-sub-proces-cq.cod-proces      = RowObject.cod-proces
            AND exam-sub-proces-cq.cod-sub-proces  = RowObject.cod-sub-proces NO-LOCK:

            ASSIGN l-tem-exam = TRUE.

            FIND FIRST exame NO-LOCK
                WHERE exame.cod-exame = exam-sub-proces-cq.cod-exame
                AND   exame.cdn-sit-vers = 2 /* Liberado */ NO-ERROR.

            IF  CAN-FIND(FIRST comp-exame 
                         WHERE comp-exame.cod-exame = exam-sub-proces-cq.cod-exame 
                           AND comp-exame.cdn-versao = exame.cdn-versao
                           AND comp-exame.log-1) THEN
                ASSIGN l-tem-comp = TRUE.

        END.
        IF  NOT l-tem-exam THEN DO:
            {utp/ut-liter.i Nenhum_exame_encontrado_para_o_subprocesso_informado. *}
            {method/svc/errors/inserr.i
                &ErrorNumber="33331"
                &ErrorType="EMS"
                &ErrorSubType="INFORMATION"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE IF NOT l-tem-comp THEN DO:
            {utp/ut-liter.i Nenhum_componente_encontrado_para_o(s)_exame(s). *}
            {method/svc/errors/inserr.i
                &ErrorNumber="33331"
                &ErrorType="EMS"
                &ErrorSubType="INFORMATION"
                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

    END.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaAceitosExame DBOProgram 
PROCEDURE verificaAceitosExame :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pl-nr-ac-ex as logical no-undo.
    
    ASSIGN pl-nr-ac-ex= NO.    
    
    FOR EACH exam-ficha USE-INDEX codigo NO-LOCK
       WHERE exam-ficha.nr-ficha = RowObject.nr-ficha:
    
        FIND FIRST exame 
             WHERE exame.cod-exame   = exam-ficha.cod-exame
               AND exame.cdn-versao  = exam-ficha.cdn-versao NO-LOCK NO-ERROR.  
               
        IF AVAIL exame 
             AND exam-ficha.nr-ac-ex > exam-ficha.nr-aceita THEN DO:    
            IF exame.homogeneo = NO THEN DO:
                IF  exam-ficha.nr-ac-ex > 0  
                AND exam-ficha.nr-ac-ex >= exam-ficha.nr-rejeita THEN
                    ASSIGN pl-nr-ac-ex = YES. 
            END.

            IF exame.homogeneo = YES THEN DO:
                IF  exam-ficha.nr-ac-ex > 0 THEN
                    ASSIGN pl-nr-ac-ex = YES.                                       
            END.
        END.
    END.
    
    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaExameAmostragem DBOProgram 
PROCEDURE verificaExameAmostragem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-exame.

    FOR EACH tt-exame:
        FIND FIRST exame NO-LOCK
             WHERE exame.cod-exame = tt-exame.cod-exame
               AND exame.cdn-versao = tt-exame.cdn-versao 
               AND exame.amostragem NO-ERROR.
        IF NOT AVAIL exame THEN DO:
            DELETE tt-exame.
        END.        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaResultados DBOProgram 
PROCEDURE verificaResultados :
/*------------------------------------------------------------------------------
  Purpose: Valida se todos os resultados foram digitados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p-nr-ficha  LIKE ficha-cq.nr-ficha    NO-UNDO.
DEFINE INPUT  PARAMETER p-it-codigo LIKE ficha-cq.it-codigo   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-exame LIKE exam-ficha.cod-exame NO-UNDO.
DEFINE INPUT  PARAMETER p-cdn-versao LIKE exame.cdn-versao    NO-UNDO.
DEFINE OUTPUT PARAMETER p-todos     AS   LOG                  NO-UNDO.

ASSIGN p-todos = YES.

/*Verifica se todos os resultados foram digitados*/
  if can-find (first it-comp-exame where
               it-comp-exame.cod-exame = p-cod-exame) THEN DO:
        for each  it-comp-exame FIELDS(cod-comp) no-lock
            where it-comp-exame.cod-exame = p-cod-exame and 
                  it-comp-exame.it-codigo = p-it-codigo and
                  it-comp-exame.situacao = 1:
            
            IF NOT CAN-FIND(first res-fic-cq
                            where res-fic-cq.nr-ficha  = p-nr-ficha
                              and res-fic-cq.it-codigo = p-it-codigo
                              and res-fic-cq.cod-exame = p-cod-exame
                              and res-fic-cq.cod-comp  = it-comp-exame.cod-comp) THEN DO:
                assign p-todos = no.
            END.
        end.
 END.
 ELSE DO: 

     for each  comp-exame FIELDS(cod-comp) no-lock
         where comp-exame.cod-exame = p-cod-exame 
           AND comp-exame.cdn-versao = p-cdn-versao
           AND comp-exame.log-1 :

        IF NOT CAN-FIND(first res-fic-cq
                        where res-fic-cq.nr-ficha  = p-nr-ficha
                          and res-fic-cq.it-codigo = p-it-codigo
                          and res-fic-cq.cod-exame = p-cod-exame
                          and res-fic-cq.cod-comp  = comp-exame.cod-comp) THEN DO:
            assign p-todos = no.
        END.
     end.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaResultadosCq0222 DBOProgram 
PROCEDURE verificaResultadosCq0222 :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-ficha  LIKE ficha-cq.nr-ficha    NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo LIKE ficha-cq.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-exame LIKE exam-ficha.cod-exame NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdn-versao LIKE exam-ficha.cdn-versao NO-UNDO.
    DEFINE OUTPUT PARAMETER p-todos     AS   LOG                  NO-UNDO.
    
    DEFINE VARIABLE i-qti-test-realzdo AS INTEGER NO-UNDO.
    DEF VAR i AS INT INITIAL 1 NO-UNDO.
    ASSIGN p-todos = YES.    
    /*Verifica se todos os resultados foram digitados*/
     if can-find (first it-comp-exame where
                   it-comp-exame.cod-exame = p-cod-exame and
                   it-comp-exame.it-codigo = p-it-codigo and
                    it-comp-exame.situacao = 1) THEN DO:
         
         for each  it-comp-exame FIELDS(cod-comp cod-exame) no-lock
             where it-comp-exame.cod-exame = p-cod-exame and 
                   it-comp-exame.it-codigo = p-it-codigo and
                   it-comp-exame.situacao = 1:                    
                       
              FOR FIRST comp-exame FIELDS(qti-test-realzdo)
                  WHERE comp-exame.cod-exame  =  it-comp-exame.cod-exame
                    AND comp-exame.cdn-versao =  p-cdn-versao
                    AND comp-exame.cod-comp   =  it-comp-exame.cod-comp NO-LOCK: END. 
                                        
                      ASSIGN i-qti-test-realzdo = IF AVAIL comp-exame THEN comp-exame.qti-test-realzdo ELSE 1.
                                        
              ASSIGN i = 1.         
              DO WHILE i <= i-qti-test-realzdo:                                   
                  IF NOT CAN-FIND(first res-fic-cq
                                  where res-fic-cq.nr-ficha  = p-nr-ficha
                                    and res-fic-cq.it-codigo = p-it-codigo
                                    and res-fic-cq.cod-exame = p-cod-exame
                                    and res-fic-cq.cod-comp  = it-comp-exame.cod-comp
                                    and res-fic-cq.num-test  = i ) THEN DO:                              
                     assign p-todos = no.                    
                 END.                 
                 ASSIGN i = i + 1.              
              END. 
         end.
     END.
     ELSE DO:
         for each  comp-exame FIELDS(cod-comp qti-test-realzdo) no-lock
             where comp-exame.cod-exame = p-cod-exame 
               AND comp-exame.cdn-versao = p-cdn-versao
               AND comp-exame.log-1 :
             ASSIGN i = 1.    
             DO WHILE i <=  comp-exame.qti-test-realzdo:
                 IF NOT CAN-FIND(first res-fic-cq
                                 where res-fic-cq.nr-ficha  = p-nr-ficha
                                   and res-fic-cq.it-codigo = p-it-codigo
                                   and res-fic-cq.cod-exame = p-cod-exame
                                   and res-fic-cq.cod-comp  = comp-exame.cod-comp
                                   and res-fic-cq.num-test  = i ) THEN DO: 
                     assign p-todos = no.
                 END. 
                 ASSIGN i = i + 1.
             END.
         end.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaWMS DBOProgram 
PROCEDURE verificaWMS :
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-nr-ficha  LIKE {&TableName}.nr-ficha   NO-UNDO.
    DEFINE OUTPUT PARAM pl-wms-ativo AS LOGICAL NO-UNDO.    
    
    IF NOT AVAIL param-estoq THEN
        FIND FIRST param-estoq NO-LOCK NO-ERROR.

    FOR FIRST ficha-cq NO-LOCK 
        WHERE ficha-cq.nr-ficha = pi-nr-ficha
          AND CONNECTED('mgscm')
          AND (SUBSTR(param-estoq.char-2,6,1) = "1" 
                   OR param-estoq.int-1 = 1):
        /** acesso as tabelas de wms **/
        RUN wmp/wm9026.p (INPUT ROWID(ficha-cq),
                          OUTPUT pl-wms-ativo).  

    END.   
    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setManualSample DBOProgram
PROCEDURE setManualSample:
/*:T------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/	
    DEF INPUT PARAM routingCode AS integer.
    DEF INPUT PARAM quantity AS decimal.
	DEF OUTPUT PARAM TABLE FOR RowErrors.
	EMPTY TEMP-TABLE RowErrors NO-ERROR.
	
	for first ficha-cq
		where ficha-cq.nr-ficha = routingCode exclusive-lock:		


        IF quantity > ficha-cq.qt-original THEN DO:
            {utp/ut-liter.i "Quantidade_Amostra" *}
            ASSIGN c-lbl-liter-qtd-am = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Quantidade_da_Ficha_CQ" *}
            ASSIGN c-lbl-liter-qtd-fic = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "msg":U,
							   INPUT 508,
                               INPUT c-lbl-liter-qtd-am + "~~" + c-lbl-liter-qtd-fic).
             create RowErrors.
    		 assign RowErrors.ErrorNumber  = 508
    		 	    RowErrors.ErrorType    = "EMS":U
    		 	    RowErrors.ErrorSubType = "ERROR":U
    		 	    RowErrors.ErrorDescription = RETURN-VALUE.
             RETURN "NOK":U.
        END. 
        ELSE IF quantity <= 0 THEN DO:
            {utp/ut-liter.i "Quantidade_Amostra" *}
            ASSIGN c-lbl-liter-qtd-am = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "msg":U,
							   INPUT 6335,	
                               INPUT c-lbl-liter-qtd-am + "~~" + "0").
             create RowErrors.
    		 assign RowErrors.ErrorNumber  = 6335
    		 	    RowErrors.ErrorType    = "EMS":U
    		 	    RowErrors.ErrorSubType = "ERROR":U
    		 	    RowErrors.ErrorDescription = RETURN-VALUE.
             RETURN "NOK":U.
        END.

		assign ficha-cq.qt-original = quantity
		       ficha-cq.log-1 = false.
	end.

	return "OK":U.
	
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

