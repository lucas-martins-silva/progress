&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOCX384 2.00.00.032 } /*** "010032" 14/11/2025 16:15:32 ***/
/* ***************************  Definitions  **************************** */
{utp/ut-glob.i}
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX384
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName histor-decla-import
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx384.i RowObject}
{cxbo/bocx384.i RowObjectAcomp}
{cxbo/bocx384.i RowObjectAcompAux}
{cxbo/bocx230.i tt-historico-embarque}
{cxbo/bocx230.i tt-historico-embarque-aux}
{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx110.i tt-pto-contr}
{cxbo/bocx384.i tt-histor-decla-import}
{include/boerrtab.i}
DEFINE TEMP-TABLE tt-hist-di no-undo
    field i-sequencia as integer
    field r-hist  as rowid
    index codigo is unique primary
       i-sequencia.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}    FOR {&TableName}.
DEFINE BUFFER bf{&TableName}2   FOR {&TableName}.
DEFINE BUFFER bf-usuar-import   FOR usuar-import.
DEF VAR i-num-di-ems LIKE {&TABLENAME}.num-di-ems                       NO-UNDO.
DEF VAR de-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz  AS INTEGER                            NO-UNDO.
DEFINE VARIABLE h-bocx230a        AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx115         AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx230         AS HANDLE                             NO-UNDO.
DEFINE VARIABLE c-return          AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE i-cod-itiner      LIKE historico-embarque.cod-itiner    NO-UNDO.
DEFINE VARIABLE i-seq             AS INTEGER                            NO-UNDO.
DEFINE VARIABLE l-add-all         AS LOGICAL  INITIAL NO                NO-UNDO.
DEFINE VARIABLE h-bocx351         AS HANDLE                             NO-UNDO.
DEFINE VARIABLE cOrdensSemLI      AS CHARACTER                          NO-UNDO.
def var dt-previsao-old           as date                               no-undo.
def var dt-ult-prev-old           as date                               no-undo.
def var dt-efetiva-old            as date                               no-undo.
DEF VAR dt-efetiva-old-orig       AS DATE                               NO-UNDO.
def var dt-pto-ant                as date                               no-undo.
def var i-intervalo-adic          as INTEGER                            no-undo.
DEF VAR c-acao                    AS CHARACTER                          NO-UNDO.
DEF VAR i-cod-pto-contr-old       LIKE historico-embarque.cod-pto-contr NO-UNDO.
DEFINE VARIABLE l-pto-nacionaliz  AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-recalcula       AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-cria-pto        AS LOGICAL                            NO-UNDO.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

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
         HEIGHT             = 3.63
         WIDTH              = 42.29.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-update-historico-embarque.
    RUN pi-atualiza-dat-ult-previsao.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN setRecalcula IN THIS-PROCEDURE (INPUT YES).
    RUN pi-atualiza-dat-ult-previsao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-update-historico-embarque.
    RUN pi-atualiza-dat-ult-previsao.
    RUN pi-atualiza-desp-di.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraSequencia DBOProgram 
PROCEDURE alteraSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var l-seq as logical init yes no-undo.
def var i-seq as integer no-undo.

assign i-seq = RowObject.num-seq.

for each tt-hist-di:
    delete tt-hist-di.
end.

do while l-seq:
  if avail RowObject then do:
      find histor-decla-import where
           histor-decla-import.num-di-ems = RowObject.num-di-ems and
           histor-decla-import.num-seq    = i-seq AND
           histor-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts
           
           no-lock no-error. /*dranka*/
      if avail histor-decla-import then do:
         create tt-hist-di.
         assign tt-hist-di.i-sequencia = histor-decla-import.num-seq
                tt-hist-di.r-hist    = rowid(histor-decla-import)
                i-seq = i-seq + 1.
      end.
      else assign l-seq = no.
  end.
end.

for each tt-hist-di by tt-hist-di.i-sequencia desc:
   find histor-decla-import where rowid(histor-decla-import) = tt-hist-di.r-hist exclusive-lock no-error.
   if avail histor-decla-import then
     assign histor-decla-import.num-seq = tt-hist-di.i-sequencia + 1.
end.

RELEASE histor-decla-import.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems      = RowObject.num-di-ems
        AND   bf{&TABLENAME}.cdn-pto-control = RowObject.cdn-pto-control
        AND   bf{&TABLENAME}.num-seq         = RowObject.num-seq 
        AND   bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        assign dt-previsao-old     = bf{&TABLENAME}.dat-prev-origin
               dt-ult-prev-old     = bf{&TABLENAME}.dat-ult-prev
               dt-efetiva-old      = bf{&TABLENAME}.dat-efetiva
               dt-efetiva-old-orig = bf{&TABLENAME}.dat-efetiva.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-cria-pto THEN DO:
        FOR FIRST RowObject:
            RUN pi-verifica-pto-contr IN THIS-PROCEDURE (INPUT RowObject.cdn-pto-control,
                                                         INPUT RowObject.descricao).
        END.
    END.
        
    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems      = RowObject.num-di-ems
        AND   bf{&TABLENAME}.num-seq         = RowObject.num-seq
        AND   bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    
        assign dt-previsao-old     = bf{&TABLENAME}.dat-prev-origin
               dt-ult-prev-old     = bf{&TABLENAME}.dat-ult-prev
               dt-efetiva-old      = bf{&TABLENAME}.dat-efetiva
               dt-efetiva-old-orig = bf{&TABLENAME}.dat-efetiva
               i-cod-pto-contr-old = bf{&TABLENAME}.cdn-pto-control.
        /* Se o ponto de controle alterado for o de nacionalizaá∆o, repassa a informaá∆o para o campo na tabela */
        IF bf{&TABLENAME}.cdn-pto-nacionaliz = bf{&TABLENAME}.cdn-pto-control THEN
            ASSIGN RowObject.cdn-pto-nacionaliz = RowObject.cdn-pto-control.    
        
        /* Se o ponto de controle alterado for o de chegada, repassa a informaá∆o para o campo na tabela */
        IF bf{&TABLENAME}.cdn-pto-chegad = bf{&TABLENAME}.cdn-pto-control THEN
            ASSIGN RowObject.cdn-pto-chegad = RowObject.cdn-pto-control.
    END.
    
    /* N∆o estar† avail se a sequància do registro for alterada, nesse caso utiliza o ponto de controle para posicionar */
    IF NOT AVAIL bf{&TABLENAME} THEN DO:
        FOR FIRST bf{&TABLENAME} NO-LOCK
            WHERE bf{&TABLENAME}.num-di-ems      = RowObject.num-di-ems
            AND   bf{&TABLENAME}.cdn-pto-control = RowObject.cdn-pto-control
            AND   bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            assign dt-previsao-old     = bf{&TABLENAME}.dat-prev-origin
                   dt-ult-prev-old     = bf{&TABLENAME}.dat-ult-prev
                   dt-efetiva-old      = bf{&TABLENAME}.dat-efetiva
                   dt-efetiva-old-orig = bf{&TABLENAME}.dat-efetiva
                   i-cod-pto-contr-old = bf{&TABLENAME}.cdn-pto-control.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaHistoricoEmbarques DBOProgram 
PROCEDURE criaHistoricoEmbarques :
/*------------------------------------------------------------------------------
  Purpose:    Cria a tabela de historico de embarques, para todos os embarques 
              relacionados a DI 
  Parameters: p-num-di-ems - N˙mero da Declaracao de Importacao
              p-num-seq - N˙mero da sequencia que o novo ponto esta sendo inserido
              p-cdn-pto-control - N˙mero do ponto de controle que esta sendo inserido
              p-descricao - Descriá∆o do ponto de controle que est† sendo inserido
              p-dat-prev-origin - Data de previsao para efetivacao do ponto
              p-dat-efetiva - Data da efetivacao do ponto de controle
              p-cod-meio-transp - Meio de transporte do ponto de controle
              p-dsl-obs - Observacao do ponto de controle 
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-num-di-ems        as integer   no-undo.
    define input parameter p-num-seq           as integer   no-undo.
    define input parameter p-cdn-pto-control   as integer   no-undo.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts  AS DECIMAL   NO-UNDO.
    define input parameter p-descricao         as character no-undo.
    define input parameter p-nr-dias           as integer   no-undo.
    define input parameter p-dat-prev-origin   as date      no-undo.
    define input parameter p-dat-efetiva       as date      no-undo.
    define input parameter p-cod-meio-transp   as character no-undo.
    define input parameter p-dsl-obs           as character no-undo.
    define input parameter p-uf                as character no-undo.

    DEFINE VAR i-cod-itiner      AS INTEGER   NO-UNDO.
    DEFINE VAR c-lit-trad-emb    AS CHARACTER NO-UNDO.
    DEFINE VAR i-seq-anterior    AS INTEGER   NO-UNDO.
    DEFINE VAR i-ponto-anterior  AS INTEGER   NO-UNDO.
    DEFINE VAR i-seq-posterior   AS INTEGER   NO-UNDO.
    DEFINE VAR i-ponto-posterior AS INTEGER   NO-UNDO.
    DEFINE VAR i-sequencia-pto   AS INTEGER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx230a) THEN
        RUN cxbo/bocx230a.p persistent set h-bocx230a.
    
    RUN getAfterAndBeforePontosDI(INPUT p-num-di-ems,
                                  INPUT p-num-seq,
                                  INPUT p-cdd-siscomex-dts,
                                  OUTPUT i-seq-anterior,
                                  OUTPUT i-ponto-anterior,
                                  OUTPUT i-seq-posterior,
                                  OUTPUT i-ponto-posterior).

    /* Cira ponto para todos os embarques da DI */
    create_hist_emb_by_DI:
    DO TRANSACTION ON ERROR UNDO create_hist_emb_by_DI, LEAVE create_hist_emb_by_DI:
    
        FOR EACH decla-import-embarq 
            WHERE decla-import-embarq.num-di-ems = p-num-di-ems 
              AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts NO-LOCK:
            RUN pi-verifica-pto-contr IN THIS-PROCEDURE (INPUT p-cdn-pto-control,
                                                         INPUT p-descricao).

            RUN verificaPontosDisponiveis IN h-bocx230a (input decla-import-embarq.cod-estab,
                                                         input decla-import-embarq.cod-embarq,
                                                         input p-num-seq,
                                                         input p-cdn-pto-control,
                                                         input i-seq-anterior,    
                                                         input i-ponto-anterior,  
                                                         input i-seq-posterior,   
                                                         input i-ponto-posterior,
                                                         output i-sequencia-pto,
                                                         output table tt-bo-erro).
            IF RETURN-VALUE = "NOK" THEN DO:
                FOR EACH tt-bo-erro EXCLUSIVE-LOCK:
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                           RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                           RowErrors.ErrorDescription = tt-bo-erro.mensagem     
                           RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                           RowErrors.ErrorType        = tt-bo-erro.errortype    
                           RowErrors.ErrorHelp        = tt-bo-erro.errorhelp   
                           RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
    
                    DELETE tt-bo-erro.
                END.
                UNDO create_hist_emb_by_DI, RETURN "NOK":U.
            END.

            RUN pi-RetornaItinerario(INPUT decla-import-embarq.cod-estab,
                                      INPUT decla-import-embarq.cod-embarq,
                                      OUTPUT i-cod-itiner).
             
    
            EMPTY TEMP-TABLE tt-historico-embarque.
            CREATE tt-historico-embarque.
            ASSIGN tt-historico-embarque.cod-estabel    = decla-import-embarq.cod-estab
                   tt-historico-embarque.embarque       = decla-import-embarq.cod-embarq
                   tt-historico-embarque.cod-itiner     = i-cod-itiner
                   tt-historico-embarque.sequencia      = i-sequencia-pto
                   tt-historico-embarque.cod-pto-contr  = p-cdn-pto-control
                   tt-historico-embarque.id-meio-transp = p-cod-meio-transp
                   tt-historico-embarque.nr-dias        = p-nr-dias
                   tt-historico-embarque.dt-previsao    = p-dat-prev-origin
                   tt-historico-embarque.dt-efetiva     = p-dat-efetiva
                   tt-historico-embarque.observacao     = p-dsl-obs
                   tt-historico-embarque.descricao      = p-descricao
                   substring(tt-historico-embarque.char-2,1,2) = "DI".
            IF substring(tt-historico-embarque.char-1,1,2) <> "" THEN
                ASSIGN substring(tt-historico-embarque.char-1,1,2) = p-uf.
            
    
            RUN validateCreate IN h-bocx230a(INPUT TABLE tt-historico-embarque,
                                             OUTPUT TABLE tt-bo-erro,
                                             OUTPUT tt-historico-embarque.r-rowid).
    
            IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                FOR EACH tt-bo-erro EXCLUSIVE-LOCK:
    
                    {utp/ut-liter.i "Embarque"}
                    assign c-lit-trad-emb = return-value.
                    {utp/ut-liter.i "As_informaá‰es_podem_estar_sendo_validadas_referente_aos_embarques_relacionados_a_DI_Lembre-se_de_verifica-los."}
                    
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                           RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                           RowErrors.ErrorDescription = tt-bo-erro.mensagem     
                           RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                           RowErrors.ErrorType        = tt-bo-erro.errortype    
                           RowErrors.ErrorHelp        = tt-bo-erro.errorhelp + CHR(10) + RETURN-VALUE + CHR(10) + c-lit-trad-emb + ": " + decla-import-embarq.cod-embarq  
                           RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
    
                    DELETE tt-bo-erro.
                END.
        
                UNDO create_hist_emb_by_DI, RETURN "NOK":U.
            END.
    
            /*Mesma l¢gica utilizada na bocx220a.i1 procedure alterasitembar(chamada pelo im0055a) para quando se inclui um novo ponto de controle no embarque*/ 
            find first embarque-imp 
                 where embarque-imp.cod-estabel = decla-import-embarq.cod-estab 
                   and embarque-imp.embarque    = decla-import-embarq.cod-embarq exclusive-lock no-error.
    
            if avail embarque-imp and embarque-imp.situacao = 2 then
               assign embarque-imp.situacao = 1.   
        END.
    END.

    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaHistoricoEmbarques DBOProgram 
PROCEDURE atualizaHistoricoEmbarques :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza historico de embarques, para todos os embarques 
              relacionados a DI 
  Parameters: tt-histor-decla-import
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-histor-decla-import.

    DEFINE VAR i-cod-itiner      AS INTEGER   NO-UNDO.
    DEFINE VAR c-lit-trad-emb    AS CHARACTER NO-UNDO.
    DEFINE VAR iRowsReturned     AS INTEGER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx230a) THEN
        RUN cxbo/bocx230a.p persistent set h-bocx230a.
    
    update_hist_emb_by_DI:
    DO TRANSACTION ON ERROR UNDO update_hist_emb_by_DI, LEAVE update_hist_emb_by_DI:
    
        FOR EACH tt-histor-decla-import:
        
            FOR EACH decla-import-embarq 
               WHERE decla-import-embarq.num-di-ems = tt-histor-decla-import.num-di-ems 
                 AND decla-import-embarq.cdd-siscomex-dts = tt-histor-decla-import.cdd-siscomex-dts NO-LOCK:
                    
                FOR FIRST embarque-imp FIELDS (embarque-imp.cdn-pto-desembar) NO-LOCK
                    WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
                      AND embarque-imp.embarque    = decla-import-embarq.cod-embarq:
                END.
                
                RUN pi-RetornaItinerario(INPUT decla-import-embarq.cod-estab,
                                         INPUT decla-import-embarq.cod-embarq,
                                         OUTPUT i-cod-itiner).
                
                FIND FIRST historico-embarque 
                     WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                       AND historico-embarque.embarque      = decla-import-embarq.cod-embarq
                       AND historico-embarque.cod-itiner    = i-cod-itiner 
                       AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar.
                 
                CREATE tt-historico-embarque.
                BUFFER-COPY historico-embarque TO tt-historico-embarque.
                ASSIGN tt-historico-embarque.r-rowid    = ROWID(historico-embarque)
                       tt-historico-embarque.dt-efetiva = tt-histor-decla-import.dat-efetiva
                       tt-historico-embarque.descricao  = tt-histor-decla-import.descricao.
                
                RUN validateUpdate IN h-bocx230a(INPUT TABLE tt-historico-embarque,
                                                 INPUT tt-historico-embarque.r-rowid,
                                                 OUTPUT TABLE tt-bo-erro). 
                                                     
                IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                    FOR EACH tt-bo-erro EXCLUSIVE-LOCK:
        
                        {utp/ut-liter.i "Embarque"}
                        assign c-lit-trad-emb = return-value.
                        {utp/ut-liter.i "As_informaá‰es_podem_estar_sendo_validadas_referente_aos_embarques_relacionados_a_DI_Lembre-se_de_verifica-los."}
                        
                        CREATE RowErrors.
                        ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                               RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                               RowErrors.ErrorDescription = tt-bo-erro.mensagem     
                               RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                               RowErrors.ErrorType        = tt-bo-erro.errortype    
                               RowErrors.ErrorHelp        = tt-bo-erro.errorhelp + CHR(10) + RETURN-VALUE + CHR(10) + c-lit-trad-emb + ": " + decla-import-embarq.cod-embarq  
                               RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
        
                        DELETE tt-bo-erro.
                    END.
            
                    UNDO update_hist_emb_by_DI, RETURN "NOK":U.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAfterAndBeforePontosDI DBOProgram 
PROCEDURE getAfterAndBeforePontosDI :
    DEFINE INPUT PARAMETER pi-num-di-ems      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-seq         AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pd-cdd-siscomex-dts AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER i-seq-anterior    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER i-ponto-anterior  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER i-seq-posterior   AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER i-ponto-posterior AS INTEGER NO-UNDO.

    FIND LAST histor-decla-import 
         WHERE histor-decla-import.num-di-ems = pi-num-di-ems
           AND histor-decla-import.num-seq    < pi-num-seq 
           AND histor-decla-import.cdd-siscomex-dts = pd-cdd-siscomex-dts NO-LOCK NO-ERROR.

    IF AVAIL histor-decla-import THEN
        ASSIGN i-seq-anterior   = histor-decla-import.num-seq
               i-ponto-anterior = histor-decla-import.cdn-pto-control.
    ELSE
        ASSIGN i-seq-anterior   = 0
               i-ponto-anterior = 0. /* indica que esta sendo incluso na primeira sequencia */
    

    FIND FIRST histor-decla-import 
         WHERE histor-decla-import.num-di-ems = pi-num-di-ems
           AND histor-decla-import.num-seq    > pi-num-seq 
           AND histor-decla-import.cdd-siscomex-dts = pd-cdd-siscomex-dts NO-LOCK NO-ERROR.

    IF AVAIL histor-decla-import THEN
        ASSIGN i-seq-posterior   = histor-decla-import.num-seq
               i-ponto-posterior = histor-decla-import.cdn-pto-control.
    ELSE
        ASSIGN i-seq-posterior   = 0
               i-ponto-posterior = 0. /* indica que esta sendo incluso na ultima sequencia */

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-meio-transp":U THEN ASSIGN pFieldValue = RowObject.cod-meio-transp.
        WHEN "dsl-obs":U THEN ASSIGN pFieldValue = RowObject.dsl-obs.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-efetiva":U THEN ASSIGN pFieldValue = RowObject.dat-efetiva.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-prev-origin":U THEN ASSIGN pFieldValue = RowObject.dat-prev-origin.
        WHEN "dat-ult-prev":U THEN ASSIGN pFieldValue = RowObject.dat-ult-prev.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-pto-chegad":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-chegad.
        WHEN "cdn-pto-control":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-control.
        WHEN "cdn-pto-nacionaliz":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-nacionaliz.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice histordi-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE histor-decla-import.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-cdd-siscomex-dts LIKE histor-decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE histor-decla-import.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-seq = RowObject.num-seq
           pd-cdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice histordi-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE histor-decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE histor-decla-import.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE histor-decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfhistor-decla-import WHERE 
        bfhistor-decla-import.num-di-ems = pnum-di-ems AND 
        bfhistor-decla-import.num-seq = pnum-seq AND 
        bfhistor-decla-import.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfhistor-decla-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfhistor-decla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyByPto DBOProgram 
PROCEDURE goToKeyByPto :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice histordi-seq
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo cdn-pto-control
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE histor-decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-pto-control LIKE histor-decla-import.cdn-pto-control NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE histor-decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfhistor-decla-import WHERE 
        bfhistor-decla-import.num-di-ems = pnum-di-ems AND 
        bfhistor-decla-import.cdn-pto-control = pcdn-pto-control AND
        bfhistor-decla-import.cdd-siscomex-dts = pcdd-siscomex-dts
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfhistor-decla-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfhistor-decla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDeclaImport DBOProgram 
PROCEDURE openQueryByDeclaImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems 
                              AND {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts INDEXED-REPOSITION.
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dat-ult-previsao DBOProgram 
PROCEDURE pi-atualiza-dat-ult-previsao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if dt-efetiva-old = ? then
        assign dt-efetiva-old = dt-ult-prev-old.

    /*
    ** Se estiver parametrizado para recalcular dt ultima previs∆o (no cadastro de pontos)
    */       
    FOR FIRST pto-contr FIELDS(log-1)
        WHERE pto-contr.cod-pto-contr = RowObject.cdn-pto-control NO-LOCK: 
        IF NOT pto-contr.log-1 OR l-recalcula THEN DO:
            /* Atualiza dt de previs∆o de acordo com o nr-dias informado pelo usu†rio.  */
            for each bf{&TableName} exclusive-lock
               where bf{&TableName}.num-di-ems = rowObject.num-di-ems
                 AND bf{&TableName}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                IF bf{&TableName}.dat-efetiva <> ? THEN NEXT.
                 
                 /* posiciona na sequància anterior */
                for last bf{&TableName}2  no-lock
                   where bf{&TableName}2.num-di-ems = rowObject.num-di-ems 
                     and bf{&TableName}2.num-seq  < bf{&TableName}.num-seq
                     AND bf{&TableName}2.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                    IF bf{&TableName}2.dat-efetiva <> ? THEN
                        assign bf{&TableName}.dat-ult-prev = bf{&TableName}2.dat-efetiva + bf{&TableName}.nr-dias.
                    ELSE
                        assign bf{&TableName}.dat-ult-prev = bf{&TableName}2.dat-ult-prev + bf{&TableName}.nr-dias.
                end.
            end.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-desp-di DBOProgram 
PROCEDURE pi-atualiza-desp-di :
/*------------------------------------------------------------------------------
  Purpose:  Transferir as despesas da DI de um ponto de controle para outro caso o mesmo tenho sido alterado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF RowObject.cdn-pto-control <> i-cod-pto-contr-old THEN DO:
        /* Move as despesas do ponto de controle antigo para o novo */
        FOR EACH despes-decla-import FIELDS(cdn-pto-control) EXCLUSIVE-LOCK
           WHERE despes-decla-import.num-di-ems      = RowObject.num-di-ems
             AND despes-decla-import.cdn-pto-control = i-cod-pto-contr-old
             AND despes-decla-import.cdd-siscomex-dts = rowObject.cdd-siscomex-dts:
            ASSIGN despes-decla-import.cdn-pto-control = RowObject.cdn-pto-control.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-regera-pontos-controle DBOProgram 
PROCEDURE pi-regera-pontos-controle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodEmbarq LIKE historico-embarque.embarque    NO-UNDO.
DEF INPUT PARAM pCodEstab  LIKE historico-embarque.cod-estabel NO-UNDO.
DEF INPUT PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems        NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx230a) THEN
        RUN cxbo/bocx230a.p persistent set h-bocx230a.

    EMPTY TEMP-TABLE tt-historico-embarque.

    ASSIGN i-cod-itiner = 0.
    
    RUN retornaCodItinerario (INPUT pCodEmbarq, 
                              INPUT pCodEstab,  
                              OUTPUT i-cod-itiner).
    
    FOR EACH historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel   = pCodEstab   
        AND   historico-embarque.embarque      = pCodEmbarq  
        AND   historico-embarque.cod-itiner    = i-cod-itiner :
    
        CREATE tt-historico-embarque.
        BUFFER-COPY historico-embarque TO tt-historico-embarque.
        ASSIGN tt-historico-embarque.r-Rowid = ROWID(historico-embarque).
    
    END.

    FOR EACH tt-historico-embarque:
    
        EMPTY TEMP-TABLE tt-historico-embarque-aux.
        CREATE tt-historico-embarque-aux.
        BUFFER-COPY tt-historico-embarque TO tt-historico-embarque-aux.
    
        RUN validateDelete IN h-bocx230a (INPUT-OUTPUT tt-historico-embarque-aux.r-Rowid,
                                          OUTPUT TABLE tt-bo-erro).

        IF CAN-FIND(tt-bo-erro) THEN DO:
            
            FOR EACH tt-bo-erro:
                CREATE RowErrors.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Embarque_Vinculado" *}
                ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                       RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                       RowErrors.ErrorDescription = RETURN-VALUE + ": " + tt-historico-embarque-aux.embarque + " - " + tt-bo-erro.mensagem     
                       RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                       RowErrors.ErrorType        = tt-bo-erro.errortype    
                       RowErrors.ErrorHelp        = tt-bo-erro.errorhelp    
                       RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
            END.
    
            RETURN "NOK":U.
        END.
    END.

    EMPTY TEMP-TABLE tt-historico-embarque.

    ASSIGN i-cod-itiner = 0
           i-seq        = 0.

    RUN retornaCodItinerario (INPUT pCodEmbarq, 
                              INPUT pCodEstab,  
                              OUTPUT i-cod-itiner).
    
    FOR EACH {&TABLENAME} NO-LOCK
        WHERE {&TABLENAME}.num-di-ems   = pNumDiEms
          AND {&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts:

        IF NOT CAN-FIND(FIRST tt-historico-embarque
                        WHERE tt-historico-embarque.cod-estabel = pCodEstab
                        AND   tt-historico-embarque.embarque    = pCodEmbarq
                        AND   tt-historico-embarque.sequencia   = {&TABLENAME}.num-seq        
                        AND   tt-historico-embarque.cod-itiner  = i-cod-itiner     ) THEN DO:

            CREATE tt-historico-embarque.
            ASSIGN tt-historico-embarque.cod-estabel       = pCodEstab       
                   tt-historico-embarque.embarque          = pCodEmbarq      
                   tt-historico-embarque.sequencia         = {&TABLENAME}.num-seq
                   tt-historico-embarque.cod-itiner        = i-cod-itiner
                   tt-historico-embarque.cod-pto-contr     = {&TABLENAME}.cdn-pto-control
                   tt-historico-embarque.dt-efetiva        = {&TABLENAME}.dat-efetiva
                   tt-historico-embarque.dt-previsao       = {&TABLENAME}.dat-prev-origin
                   tt-historico-embarque.dt-ult-previsao   = {&TABLENAME}.dat-ult-prev
                   tt-historico-embarque.id-meio-transp    = {&TABLENAME}.cod-meio-transp
                   tt-historico-embarque.observacao        = {&TABLENAME}.dsl-obs.

        END.
    END.

    FOR EACH tt-historico-embarque:
        
        EMPTY TEMP-TABLE tt-historico-embarque-aux.
        CREATE tt-historico-embarque-aux.
        BUFFER-COPY tt-historico-embarque TO tt-historico-embarque-aux.
    
        RUN validateCreate IN h-bocx230a (INPUT TABLE tt-historico-embarque-aux,
                                          OUTPUT TABLE tt-bo-erro,
                                          OUTPUT rCurrentAux).
        IF CAN-FIND(tt-bo-erro) THEN DO:
            
            FOR EACH tt-bo-erro:
                CREATE RowErrors.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Embarque_Vinculado" *}
                ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                       RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                       RowErrors.ErrorDescription = RETURN-VALUE + ": " + tt-historico-embarque-aux.embarque + " - " + tt-bo-erro.mensagem     
                       RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                       RowErrors.ErrorType        = tt-bo-erro.errortype    
                       RowErrors.ErrorHelp        = tt-bo-erro.errorhelp    
                       RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
            END.
    
            RETURN "NOK":U.
        END.
    
    END.

    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retornaitinerario DBOProgram 
PROCEDURE pi-retornaitinerario :
DEFINE INPUT PARAMETER c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-embarque AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER i-cod-itiner AS INTEGER NO-UNDO.

    FOR FIRST ordens-embarque 
        WHERE ordens-embarque.cod-estabel = c-cod-estabel
          AND ordens-embarque.embarque    = c-cod-embarque NO-LOCK,
        FIRST ordem-compra 
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK,
        FIRST processo-imp  
        WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK:

        ASSIGN i-cod-itiner = processo-imp.cod-itiner.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-historico-embarque DBOProgram 
PROCEDURE pi-update-historico-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx230a) THEN
        RUN cxbo/bocx230a.p persistent set h-bocx230a.
    
    FOR EACH decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        IF CAN-FIND(FIRST historico-embarque
                    WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                    AND   historico-embarque.embarque      = decla-import-embarq.cod-embarq 
                    AND   historico-embarque.cod-pto-contr = i-cod-pto-contr-old ) THEN DO:
            FOR FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                AND   historico-embarque.embarque      = decla-import-embarq.cod-embarq 
                AND   historico-embarque.cod-pto-contr = i-cod-pto-contr-old:

                EMPTY TEMP-TABLE tt-historico-embarque.
                CREATE tt-historico-embarque.
                BUFFER-COPY historico-embarque TO tt-historico-embarque.
                ASSIGN tt-historico-embarque.dt-efetiva = RowObject.dat-efetiva
                       tt-historico-embarque.cod-pto-contr = RowObject.cdn-pto-control
                       tt-historico-embarque.descricao = RowObject.descricao
                       tt-historico-embarque.nr-dias   = RowObject.nr-dias
                       tt-historico-embarque.r-Rowid   = ROWID(historico-embarque).
                RUN validateUpdate IN h-bocx230a (INPUT TABLE tt-historico-embarque,
                                                  INPUT tt-historico-embarque.r-Rowid,
                                                  OUTPUT TABLE tt-bo-erro APPEND).
            END.
        END.
    END. 
    
    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-efetivacao DBOProgram 
PROCEDURE pi-valida-efetivacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-historico-embarque FOR historico-embarque.
    DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE l-manter-ordem-itinerario AS LOGICAL     NO-UNDO.
    
    FOR FIRST bf-usuar-import
        WHERE bf-usuar-import.cod-usuar = c-seg-usuario NO-LOCK:
        /*Se marcado, valida Data Efetiva Ponto de Controle N∆o Obrigat¢rio*/
        ASSIGN l-manter-ordem-itinerario = bf-usuar-import.log-livre-1. 
    END.
    
    FOR EACH decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    
        IF CAN-FIND(FIRST historico-embarque
                    WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                    AND   historico-embarque.embarque      = decla-import-embarq.cod-embarq 
                    AND   historico-embarque.cod-pto-contr = RowObject.cdn-pto-control ) THEN DO:
            FOR FIRST embarque-imp FIELDS(cdn-pto-despch cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad)
                WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab 
                  AND embarque-imp.embarque = decla-import-embarq.cod-embarq:
            END.
    
            /* Somente valida a data de efetivaá∆o se o ponto efetivado for um dos obrigat¢rios */
            IF l-manter-ordem-itinerario
            OR (NOT l-manter-ordem-itinerario 
                AND RowObject.cdn-pto-control = embarque-imp.cdn-pto-despch
                 OR RowObject.cdn-pto-control = embarque-imp.cdn-pto-embarq
                 OR RowObject.cdn-pto-control = embarque-imp.cdn-pto-desembar
                 OR RowObject.cdn-pto-control = embarque-imp.cdn-pto-chegad)  THEN DO:
    
                IF l-manter-ordem-itinerario THEN
                    FOR FIRST historico-embarque
                        WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                        AND   historico-embarque.embarque      = decla-import-embarq.cod-embarq 
                        AND   historico-embarque.cod-pto-contr = RowObject.cdn-pto-control,
                        LAST bf-historico-embarque NO-LOCK
                        WHERE bf-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
                        AND   bf-historico-embarque.embarque      = historico-embarque.embarque 
                        AND   bf-historico-embarque.cod-itiner    = historico-embarque.cod-itiner
                        AND   bf-historico-embarque.sequencia     < historico-embarque.sequencia:

                        IF bf-historico-embarque.dt-efetiva = ? THEN DO:
                            ASSIGN c-erro = 'Ponto de Controle n∆o pode ser efetivado.' + '~~' + 'Ponto de Controle n∆o pode ser efetivado pois no embarque ' + STRING(bf-historico-embarque.embarque) + ' , o ponto de controle ' + STRING(bf-historico-embarque.cod-pto-contr) + ' n∆o foi efetivado!'.
                            {method/svc/errors/inserr.i
                                  &ErrorNumber="17006"
                                  &ErrorType="EMS"
                                  &ErrorParameters=c-erro}
                        END.
                    END.
                ELSE 
                    FOR FIRST historico-embarque
                    WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                    AND   historico-embarque.embarque      = decla-import-embarq.cod-embarq 
                    AND   historico-embarque.cod-pto-contr = RowObject.cdn-pto-control,
                    LAST bf-historico-embarque NO-LOCK
                    WHERE bf-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
                    AND   bf-historico-embarque.embarque      = historico-embarque.embarque 
                    AND   bf-historico-embarque.cod-itiner    = historico-embarque.cod-itiner
                    AND   bf-historico-embarque.sequencia     < historico-embarque.sequencia
                    AND  (l-manter-ordem-itinerario 
                          OR (NOT l-manter-ordem-itinerario AND 
                              bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch   OR
                              bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq   OR
                              bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                              bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad)) :
                    IF bf-historico-embarque.dt-efetiva = ? THEN DO:
                        ASSIGN c-erro = 'Ponto de Controle n∆o pode ser efetivado.' + '~~' + 'Ponto de Controle n∆o pode ser efetivado pois no embarque ' + STRING(bf-historico-embarque.embarque) + ' , o ponto de controle ' + STRING(bf-historico-embarque.cod-pto-contr) + ' n∆o foi efetivado!'.
                        {method/svc/errors/inserr.i
                              &ErrorNumber="17006"
                              &ErrorType="EMS"
                              &ErrorParameters=c-erro}
                    END.
                END.
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pto-contr DBOProgram 
PROCEDURE pi-verifica-pto-contr :
/*------------------------------------------------------------------------------------------
Purpose:    Verifica se o ponto de controle existe. Se n∆o existir cria um novo.
Parameters: p-cod-pto-contr: C¢digo do ponto de controle verificado
            p-descricao: Descriá∆o do ponto, caso seja necess†rio cria-lo
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-pto-contr LIKE pto-contr.cod-pto-contr NO-UNDO.
    DEFINE INPUT PARAMETER p-descricao     LIKE pto-contr.descricao     NO-UNDO.
    
    DEFINE VARIABLE h-bocx110 AS HANDLE NO-UNDO.
    DEFINE VARIABLE r-rowid   AS ROWID  NO-UNDO.
    
    if not valid-handle(h-bocx110) then
        run cxbo/bocx110.p persistent set h-bocx110.
        
    run findCodigo in h-bocx110 (input p-cod-pto-contr,
                                 output c-return).
    if c-return <> "":U then do:
        empty temp-table tt-pto-contr.
        create tt-pto-contr.
        assign tt-pto-contr.cod-pto-contr = p-cod-pto-contr
               tt-pto-contr.descricao     = p-descricao.
        run validateCreate in h-bocx110 (input table tt-pto-contr,
                                         output table tt-bo-erro append,
                                         output r-rowid).
    end.

    IF VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEfetivacaoEmbarque DBOProgram 
PROCEDURE piValidaEfetivacaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pNumDiEms   LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAM pPtoEfetiva LIKE {&TABLENAME}.cdn-pto-control NO-UNDO.
    DEFINE INPUT  PARAM pCddSiscomexDTS LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAM pRetorno  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM c-arquivo AS CHARACTER FORMAT "X(30)" NO-UNDO.

    ASSIGN pRetorno = NO.

    /* Licenciamento Importacao */
    if  not valid-handle (h-bocx351) then 
        run cxbo/bocx351.p persistent set h-bocx351.

    run openQueryStatic in h-bocx351 (input "Main":U).

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms
          AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts: END.

    if  (pPtoEfetiva = bf{&TABLENAME}.cdn-pto-nacionaliz) then do:

        FOR EACH decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.num-di-ems = pNumDiEms
              AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts:
        
            if  valid-handle (h-bocx351) then do:
        
                assign cOrdensSemLI = "":U.
                
                run piRetornaLI in h-bocx351 (input 2,
                                              input yes,
                                              input ?,
                                              input decla-import-embarq.cod-estab,
                                              input decla-import-embarq.cod-embarq,
                                              input ?,
                                              input no,
                                              input yes,
                                              input 0,
                                              input 99999999,
                                              input " ":U,
                                              input "ZZZZZZZZZZZZZZZZ":U,
                                              input " ":U,
                                              input "ZZZZZZZZ":U,
                                              input " ":U,
                                              input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                              output table tt-licenciam-import-oc). 
            end.
        
            bloco_LI:
            for each  tt-licenciam-import-oc
                where tt-licenciam-import-oc.licenca-import = "":U
                break by tt-licenciam-import-oc.numero-ordem
                      by tt-licenciam-import-oc.parcela:
        
                if  first-of (tt-licenciam-import-oc.numero-ordem) then do:
                    if  cOrdensSemLI = "":U then
                        assign cOrdensSemLI = string(tt-licenciam-import-oc.numero-ordem).
                    else
                        assign cOrdensSemLI = cOrdensSemLI + ", ":U + string(tt-licenciam-import-oc.numero-ordem).
                    IF cOrdensSemLI <> "" THEN
                        LEAVE bloco_LI.
                end.
            end.
        
            if  cOrdensSemLi <> "":U then do:
                ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "IM9056RP":U + ".tmp":U.
    
                RUN imp/im9056rp.p (INPUT decla-import-embarq.cod-estab,
                                    INPUT decla-import-embarq.cod-embarq,
                                    INPUT TABLE tt-licenciam-import-oc).
            
                ASSIGN pRetorno = YES.
            end.
        END.
    end.

    IF VALID-HANDLE(h-bocx351) THEN DO:
        DELETE PROCEDURE h-bocx351.
        ASSIGN h-bocx351 = ?.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCodItinerario DBOProgram 
PROCEDURE retornaCodItinerario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pEmbarque  LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab     LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF OUTPUT PARAM pCodItiner LIKE historico-embarque.cod-itiner    NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    ASSIGN pCodItiner = 0
           c-return   = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT pCodItiner).
    ELSE
        ASSIGN pCodItiner = 0.

    IF VALID-HANDLE(h-bocx230) THEN DO:
        DELETE PROCEDURE h-bocx230.
        ASSIGN h-bocx230 = ?.
    END.
    IF VALID-HANDLE(h-bocx115) THEN DO:
        DELETE PROCEDURE h-bocx115.
        ASSIGN h-bocx115 = ?.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaProxSeqDI DBOProgram 
PROCEDURE retornaProxSeqDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pnumDI  LIKE histor-decla-import.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDTS LIKE histor-decla-import.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pSeq LIKE histor-decla-import.num-seq    NO-UNDO.

    FIND LAST bf{&TABLENAME} NO-LOCK 
        WHERE bf{&TABLENAME}.num-di-ems = pnumDI 
          AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDTS NO-ERROR.
    IF AVAIL bf{&TABLENAME} THEN
       ASSIGN pSeq = bf{&TABLENAME}.num-seq + 10. 

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAddAll DBOProgram 
PROCEDURE setAddAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pAddAll AS LOGICAL NO-UNDO.

ASSIGN l-add-all = pAddAll.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDeclaImport DBOProgram 
PROCEDURE setConstraintByDeclaImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDTS LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN i-num-di-ems        = pNumDiEms
       de-cdd-siscomex-dts = pCddSiscomexDTS.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCriacaoPto DBOProgram 
PROCEDURE setCriacaoPto :
/*------------------------------------------------------------------------------
  Purpose:  Seta a vari†vel respons†vel por controlar se deve ou n∆o criar ponto caso n∆o exista
  Parameters:  (INPUT) pl-cria-pto: Indica se deve criar ponto de controle caso n∆o exista.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pl-cria-pto AS LOGICAL     NO-UNDO.

    ASSIGN l-cria-pto = pl-cria-pto.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecalcula DBOProgram 
PROCEDURE setRecalcula :
/*------------------------------------------------------------------------------
  Purpose:  Setar o vari†vel que indica se deve recalcular as datas de £ltima previs∆o.
  Parameters:  (INPUT) pl-recalcula: Se deve recalcular as datas de £ltima previs∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-recalcula AS LOGICAL NO-UNDO.

    ASSIGN l-recalcula = pl-recalcula.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateSeqHistoricoEmbarques DBOProgram 
PROCEDURE updateSeqHistoricoEmbarques :
/*------------------------------------------------------------------------------
  Purpose:    Altera a tabela de historico de embarques, para todos os embarques relacionados a DI.
  Parameters: (INPUT) (Temp-table) RowObjectAcomp: Pontos da DI com as sequàncias alteradas.
  Notes:      Reorganiza a ordem dos pontos de controle no embarque de acordo com a DI.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObjectAcomp.
    
    DEFINE VARIABLE i-num-di-ems     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-itiner     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-next-seq       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-cdd-siscomex-dts AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i-pto-nacionaliz LIKE histor-decla-import.cdn-pto-nacionaliz NO-UNDO.
    DEFINE VARIABLE i-seq-nacionaliz LIKE histor-decla-import.num-seq            NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx230a) THEN
        RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.

    FOR FIRST RowObjectAcomp:
        ASSIGN i-num-di-ems = RowObjectAcomp.num-di-ems
               i-pto-nacionaliz = RowObjectAcomp.cdn-pto-nacionaliz
               de-cdd-siscomex-dts = RowObjectAcomp.cdd-siscomex-dts.
    END.

    update_hist_emb_by_DI:
    DO TRANSACTION ON ERROR UNDO update_hist_emb_by_DI, LEAVE update_hist_emb_by_DI:
    
        FOR EACH decla-import-embarq
           WHERE decla-import-embarq.num-di-ems = i-num-di-ems 
             AND decla-import-embarq.cdd-siscomex-dts = de-cdd-siscomex-dts NO-LOCK:
            
            EMPTY TEMP-TABLE tt-historico-embarque.
            RUN pi-RetornaItinerario(INPUT decla-import-embarq.cod-estab,
                                     INPUT decla-import-embarq.cod-embarq,
                                     OUTPUT i-cod-itiner).

            FOR FIRST historico-embarque FIELDS(sequencia) NO-LOCK
                WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab
                  AND historico-embarque.embarque      = decla-import-embarq.cod-embarq
                  AND historico-embarque.cod-itiner    = i-cod-itiner
                  AND historico-embarque.cod-pto-contr = i-pto-nacionaliz:
                ASSIGN i-seq-nacionaliz = historico-embarque.sequencia.
            END.

            /* Deleta todos os pontos ap¢s o ponto de nacionalizaá∆o (ser∆o recriados posteriormente) */
            FOR EACH historico-embarque EXCLUSIVE-LOCK
               WHERE historico-embarque.cod-estabel = decla-import-embarq.cod-estab
                 AND historico-embarque.embarque    = decla-import-embarq.cod-embarq
                 AND historico-embarque.cod-itiner  = i-cod-itiner
                 AND historico-embarque.sequencia   > i-seq-nacionaliz:
                CREATE tt-historico-embarque.
                BUFFER-COPY historico-embarque TO tt-historico-embarque.
                DELETE historico-embarque.
            END.

            ASSIGN i-next-seq = i-seq-nacionaliz.
            FOR EACH RowObjectAcomp,
               FIRST tt-historico-embarque
               WHERE tt-historico-embarque.cod-estabel   = decla-import-embarq.cod-estab 
                 AND tt-historico-embarque.embarque      = decla-import-embarq.cod-embarq
                 AND tt-historico-embarque.cod-itiner    = i-cod-itiner
                 AND tt-historico-embarque.cod-pto-contr = RowObjectAcomp.cdn-pto-control BY RowObjectAcomp.num-seq:
                ASSIGN i-next-seq = i-next-seq + 10.

                /* Verificaá∆o de duplicata */
                IF NOT CAN-FIND(FIRST historico-embarque
                                WHERE historico-embarque.cod-estabel   = decla-import-embarq.cod-estab 
                                  AND historico-embarque.embarque      = decla-import-embarq.cod-embarq
                                  AND historico-embarque.cod-itiner    = i-cod-itiner
                                  AND historico-embarque.sequencia     = i-next-seq) THEN DO:
                    EMPTY TEMP-TABLE tt-historico-embarque-aux.
                    CREATE tt-historico-embarque-aux.
                    BUFFER-COPY tt-historico-embarque TO tt-historico-embarque-aux.
                    ASSIGN tt-historico-embarque-aux.sequencia = i-next-seq.
                    RUN setRecord IN h-bocx230a(INPUT TABLE tt-historico-embarque-aux).
                    RUN executeCreate IN h-bocx230a.
                END.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaIntegraPtoDi DBOProgram 
PROCEDURE validaIntegraPtoDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pEmbarque LIKE decla-import-embarq.cod-embarq NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE decla-import-embarq.cod-estab  NO-UNDO.
DEF INPUT  PARAM pPtoContr LIKE histor-decla-import.cdn-pto-control      NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                          NO-UNDO.

IF NOT CAN-FIND(FIRST decla-import-embarq
                WHERE decla-import-embarq.cod-estab  = pEstab
                AND   decla-import-embarq.cod-embarq = pEmbarque) THEN
    ASSIGN pRetorno = NO.        
ELSE DO:
    FOR FIRST decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.cod-estab  = pEstab
        AND   decla-import-embarq.cod-embarq = pEmbarque :

        IF CAN-FIND(FIRST histor-decla-import
                    WHERE histor-decla-import.num-di-ems      = decla-import-embarq.num-di-ems
                    AND   histor-decla-import.cdn-pto-control = pPtoContr
                    AND   histor-decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts) THEN DO:
            FOR FIRST histor-decla-import NO-LOCK
                WHERE histor-decla-import.num-di-ems      = decla-import-embarq.num-di-ems
                AND   histor-decla-import.cdn-pto-control = pPtoContr
                AND   histor-decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts:
    
                ASSIGN pRetorno = YES.
        
            END.
        END.
        ELSE DO:
            ASSIGN pRetorno = NO.
        END.
    END.
END.    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields DBOProgram 
PROCEDURE validateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-lbl-liter-data-efetiva  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-descricao     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-manter-ordem-itinerario AS LOGICAL     NO-UNDO.

    ASSIGN c-acao = pType.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST bf-usuar-import
        WHERE bf-usuar-import.cod-usuar = c-seg-usuario NO-LOCK:
        /*Se marcado, valida Data Efetiva Ponto de Controle N∆o Obrigat¢rio*/
        ASSIGN l-manter-ordem-itinerario = bf-usuar-import.log-livre-1. 
    END.
    
    /*
    ** Validaá∆o dos campos
    */
    FOR FIRST decla-import-embarq FIELDS(cod-embarq cod-estab) NO-LOCK
        WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
        FIRST embarque-imp FIELDS(cdn-pto-despch cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad) NO-LOCK
        WHERE embarque-imp.embarque = decla-import-embarq.cod-embarq
          AND embarque-imp.cod-estabel = decla-import-embarq.cod-estab:
    END.
    
    /* Valida datas somente para pontos obrigat¢rios */
    IF l-manter-ordem-itinerario
    OR (NOT l-manter-ordem-itinerario AND 
            RowObject.cdn-pto-control = embarque-imp.cdn-pto-despch OR 
            RowObject.cdn-pto-control = embarque-imp.cdn-pto-embarq OR 
            RowObject.cdn-pto-control = embarque-imp.cdn-pto-desembar OR 
            RowObject.cdn-pto-control = embarque-imp.cdn-pto-chegad) THEN DO:

        IF l-manter-ordem-itinerario THEN DO:
            FOR LAST bf{&TABLENAME}  NO-LOCK
               WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                 AND bf{&TABLENAME}.num-seq    < RowObject.num-seq
                 AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            END.
        END.
        ELSE DO:
            FOR LAST bf{&TABLENAME}  NO-LOCK
               WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                 AND bf{&TABLENAME}.num-seq    < RowObject.num-seq 
                 AND (bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-despch   OR
                      bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-embarq   OR
                      bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-desembar OR
                      bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-chegad)
                 AND {&TABLENAME}.cdd-siscomex-dts   = RowObject.cdd-siscomex-dts:
            end.
        END.
        IF AVAIL bf{&TABLENAME} THEN DO:
            if RowObject.dat-efetiva <> ? then do:
                if bf{&TABLENAME}.dat-efetiva = ? then do:
                    {method/svc/errors/inserr.i
                          &ErrorNumber="17335"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
                end.
        
                if bf{&TABLENAME}.dat-efetiva > RowObject.dat-efetiva then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Data_Efetiva" *}
                    ASSIGN c-lbl-liter-data-efetiva = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="17337"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-data-efetiva"}
                end.
            end.
            else do:
                if bf{&TABLENAME}.dat-prev-origin = ? then do:
                    {method/svc/errors/inserr.i
                          &ErrorNumber="17335"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
                end.                                
                if pType = "CREATE":U then do:
                    if bf{&TABLENAME}.dat-efetiva = ? then do:
                        if bf{&TABLENAME}.dat-ult-prev > RowObject.dat-ult-prev 
                            /*AND NOT l-add-all*/ then do:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-data-previsao AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Data_Previs∆o" *}
                            ASSIGN c-lbl-liter-data-previsao = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                  &ErrorNumber="17337"
                                  &ErrorType="EMS"
                                  &ErrorParameters="c-lbl-liter-data-previsao"}
                        end.
                    end.                
                    else
                    if bf{&TABLENAME}.dat-efetiva > RowObject.dat-prev-origin then do:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-data-previsao-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Data_Previs∆o" *}
                        ASSIGN c-lbl-liter-data-previsao-2 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                              &ErrorNumber="17337"
                              &ErrorType="EMS"
                              &ErrorParameters="c-lbl-liter-data-previsao-2"}
                    end.
                end.
            end.
        END.
    END.

    IF l-manter-ordem-itinerario THEN DO:
        for first bf{&TABLENAME}
            where bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
              and bf{&TABLENAME}.num-seq    > RowObject.num-seq 
              AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-LOCK:
        END.
    END.
    ELSE DO:
        for first bf{&TABLENAME}
            where bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
              and bf{&TABLENAME}.num-seq    > RowObject.num-seq 
              AND (bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-despch   OR
                   bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-embarq   OR
                   bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-desembar OR
                   bf{&TABLENAME}.cdn-pto-control = embarque-imp.cdn-pto-chegad)
              AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts no-lock:
        end.
    END.
        
    if avail bf{&TABLENAME} then do:
        if rowObject.dat-efetiva <> ? then do:
            if rowObject.dat-efetiva > bf{&TABLENAME}.dat-efetiva then do:

                /* Data Efetiva Ç maior que a do Pto Contr seguinte */
                {utp/ut-liter.i "Data_Efetiva" *}
                ASSIGN c-lbl-liter-data-efetiva = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                          &ErrorNumber="17316"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-data-efetiva"}

                
            end.        
        end.
        else do:
            IF l-manter-ordem-itinerario THEN DO:
                if bf{&TABLENAME}.dat-efetiva <> ? THEN DO:
                    {utp/ut-liter.i "Data_Efetiva" *}
                    ASSIGN c-lbl-liter-data-efetiva = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                              &ErrorNumber="265"
                              &ErrorType="EMS"
                              &ErrorParameters="c-lbl-liter-data-efetiva"}
                END.
            END.
            ELSE DO:
                if bf{&TABLENAME}.dat-efetiva <> ? 
                AND (RowObject.cdn-pto-control = embarque-imp.cdn-pto-despch   OR
                    RowObject.cdn-pto-control = embarque-imp.cdn-pto-embarq   OR
                    RowObject.cdn-pto-control = embarque-imp.cdn-pto-desembar OR
                    RowObject.cdn-pto-control = embarque-imp.cdn-pto-chegad) then do:
                    {utp/ut-liter.i "Data_Efetiva" *}
                    ASSIGN c-lbl-liter-data-efetiva = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                              &ErrorNumber="265"
                              &ErrorType="EMS"
                              &ErrorParameters="c-lbl-liter-data-efetiva"}
                end.
            END.
        end.            
    end.

    IF RowObject.descricao = ? OR TRIM(RowObject.descricao) = "":U THEN DO:
        {utp/ut-liter.i "Descriá∆o" *}
        ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="265"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-descricao"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = 'CREATE' OR pType = 'COPY' THEN DO:

        IF CAN-FIND(FIRST {&TABLENAME}
                    WHERE {&TABLENAME}.num-di-ems = RowObject.num-di-ems
                      AND {&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

            FOR FIRST {&TABLENAME}
                WHERE {&TABLENAME}.num-di-ems         = RowObject.num-di-ems
                  AND {&TABLENAME}.cdd-siscomex-dts   = RowObject.cdd-siscomex-dts,
                FIRST bf{&TABLENAME}
                WHERE bf{&TABLENAME}.num-di-ems       = {&TABLENAME}.num-di-ems
                AND   bf{&TABLENAME}.cdn-pto-control  = {&TABLENAME}.cdn-pto-nacionaliz 
                AND   bf{&TABLENAME}.cdd-siscomex-dts = {&TABLENAME}.cdd-siscomex-dts NO-LOCK:

                IF RowObject.num-seq <= bf{&TABLENAME}.num-seq THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-nao-e-permitido-inserir-ponto AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "N∆o_Ç_permitido_inserir_ponto_de_controle_anterior_ao_ponto_de_Nacionalizaá∆o" *}
                    ASSIGN c-lbl-liter-nao-e-permitido-inserir-ponto = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="17006"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-nao-e-permitido-inserir-ponto + '.' + '~~~~' + c-lbl-liter-nao-e-permitido-inserir-ponto + '.'"}
                    END. 
            END.
        END.

        if rowObject.cdn-pto-control = 0 then do:
            {utp/ut-field.i mgcex histor-decla-import cdn-pto-control 1}
            {method/svc/errors/inserr.i
                  &ErrorNumber="265"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
        else 
            if not can-find(pto-contr where pto-contr.cod-pto-contr = RowObject.cdn-pto-control) then do:
                {utp/ut-table.i mgcex pto-contr 1}
                {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
    
        if rowObject.num-seq = 0 then do:
            {utp/ut-field.i mgcex histor-decla-import num-seq 1}
            {method/svc/errors/inserr.i
                  &ErrorNumber="265"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
        
        if rowObject.dat-prev-origin = ? then do:
            {utp/ut-field.i mgcex {&TABLENAME} dat-prev-origin 1}
            {method/svc/errors/inserr.i
                  &ErrorNumber="265"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
        else
            assign rowobject.dat-ult-prev = RowObject.dat-prev-origin when rowobject.dat-ult-prev = ?.
            
        /* 
        ** Teste de duplicidade
        */        
         IF CAN-FIND(FIRST {&TABLENAME} 
                     WHERE {&TABLENAME}.num-seq    = RowObject.num-seq
                     AND   {&TABLENAME}.num-di-ems = RowObject.num-di-ems
                     AND   {&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-historico-di AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Hist¢rico_DI" *}
            ASSIGN c-lbl-liter-historico-di = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-historico-di"}
        END.           
    END. /*FIM VALIDAÄÂES CREATE E COPY*/


    IF pType <> "DELETE" THEN DO:
        RUN validateFields (INPUT pType).
        IF RowObject.dat-efetiva <> ? THEN
            RUN pi-valida-efetivacao.
    END.                                 

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateAcomp DBOProgram 
PROCEDURE validateUpdateAcomp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObjectAcomp.
    DEFINE VARIABLE l-erro  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-seq-nacionaliz  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-chegada     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-recebimento AS INTEGER     NO-UNDO.

    DEFINE BUFFER bfRowObjectAcomp FOR RowObjectAcomp.

    RUN emptyRowErrors IN THIS-PROCEDURE.
    EMPTY TEMP-TABLE RowErrorsAux.
    
    FOR FIRST bfRowObjectAcomp:
        FOR FIRST RowObjectAcomp
            WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
              AND RowObjectAcomp.cdn-pto-control = bfRowObjectAcomp.cdn-pto-nacionaliz
              AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts:            
            ASSIGN i-seq-nacionaliz = RowObjectAcomp.num-seq.
        END.

        FOR FIRST RowObjectAcomp
            WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
              AND RowObjectAcomp.cdn-pto-control = bfRowObjectAcomp.cdn-pto-chegad
              AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts:
            ASSIGN i-seq-chegada = RowObjectAcomp.num-seq.
        END.
        
        FOR FIRST RowObjectAcomp
            WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
              AND RowObjectAcomp.cdn-pto-control = INT(TRIM(SUBSTRING(bfRowObjectAcomp.cod-livre-1,1,5))) 
              AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts NO-LOCK:
            ASSIGN i-seq-recebimento = RowObjectAcomp.num-seq.
        END.
        
        /* Se os campos n∆o estiverem preenchidos na tabela histor-decl-import, busca do embarque-imp */
        IF i-seq-nacionaliz = 0 OR i-seq-chegada = 0 OR i-seq-recebimento = 0 THEN DO:
            FOR FIRST decla-import-embarq NO-LOCK
                WHERE decla-import-embarq.num-di-ems = bfRowObjectAcomp.num-di-ems
                  AND decla-import-embarq.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts,
                FIRST embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
                  AND embarque-imp.embarque = decla-import-embarq.cod-embarq:
                
                IF i-seq-nacionaliz = 0 THEN DO:
                    FOR FIRST RowObjectAcomp
                        WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
                          AND RowObjectAcomp.cdn-pto-control = embarque-imp.cdn-pto-desembar
                          AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts:
                        ASSIGN i-seq-nacionaliz = RowObjectAcomp.num-seq.
                    END.
                END.

                IF i-seq-chegada = 0 THEN DO:
                    FOR FIRST RowObjectAcomp
                        WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
                          AND RowObjectAcomp.cdn-pto-control = embarque-imp.cdn-pto-chegad
                          AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts:
                        ASSIGN i-seq-chegada = RowObjectAcomp.num-seq.
                    END.
                END.

                IF i-seq-recebimento = 0 THEN DO:
                    FOR FIRST RowObjectAcomp
                        WHERE RowObjectAcomp.num-di-ems      = bfRowObjectAcomp.num-di-ems
                          AND RowObjectAcomp.cdn-pto-control = INT(TRIM(SUBSTRING(embarque-imp.char-1,86,5)))
                          AND RowObjectAcomp.cdd-siscomex-dts = bfRowObjectAcomp.cdd-siscomex-dts:
                        ASSIGN i-seq-recebimento = RowObjectAcomp.num-seq.
                    END.
                END.
            END.
        END.
    END.

    /* Ordem obrigat¢ria dos pontos */
    IF i-seq-nacionaliz >= i-seq-chegada AND i-seq-chegada > 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="54796"
                                    &ErrorType="EMS"} 
    END.
    IF i-seq-recebimento >= i-seq-chegada AND i-seq-chegada > 0 THEN DO:
        {utp/ut-liter.i Ponto_Recebimento * r}
         assign c-return = return-value.
        {utp/ut-liter.i Ponto_Chegada * r}
        {method/svc/errors/inserr.i &ErrorNumber="55793"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-return + '~~~~' + return-value"} 
    END.

    /* Verifica se foi inserido algum ponto antes do ponto de nacionalizaá∆o */
    IF  CAN-FIND(FIRST RowObjectAcomp
                 WHERE RowObjectAcomp.num-seq <= i-seq-nacionaliz
                   AND RowObjectAcomp.cdn-pto-control <> RowObjectAcomp.cdn-pto-nacionaliz) THEN DO:
        FOR FIRST RowObjectAcomp
             WHERE RowObjectAcomp.num-seq <= i-seq-nacionaliz
               AND RowObjectAcomp.cdn-pto-control <> RowObjectAcomp.cdn-pto-nacionaliz:
            {method/svc/errors/inserr.i &ErrorNumber="54798"
                                        &ErrorType="EMS"
                                        &ErrorParameters=RowObjectAcomp.num-seq}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    UPDATE_block:
    DO TRANS:
        /* Elimina todos os pontos da DI pois ser∆o recriados */
        FOR FIRST RowObjectAcomp, 
            EACH {&tableName} EXCLUSIVE-LOCK
           WHERE {&tableName}.num-di-ems = RowObjectAcomp.num-di-ems
             AND {&tableName}.cdd-siscomex-dts = RowObjectAcomp.cdd-siscomex-dts:
            /* Verifica se o registro n∆o existe */
            IF NOT CAN-FIND(FIRST RowObject
                            WHERE RowObject.num-di-ems = {&tableName}.num-di-ems
                              AND RowObject.num-seq = {&tableName}.num-seq
                              AND RowObject.cdd-siscomex-dts = {&tablename}.cdd-siscomex-dts) AND
               NOT CAN-FIND(FIRST RowObject
                            WHERE RowObject.num-di-ems = {&tableName}.num-di-ems
                              AND RowObject.cdn-pto-control = {&tableName}.cdn-pto-control
                              AND RowObject.cdd-siscomex-dts = {&tablename}.cdd-siscomex-dts) THEN DO:
                CREATE RowObject.
                BUFFER-COPY {&tableName} TO RowObject.
                DELETE {&tableName}.
            END.
        END.
        
        FOR EACH RowObjectAcomp BY RowObjectAcomp.num-seq:
            RUN emptyRowErrors IN THIS-PROCEDURE.

            /* Posiciona no registro */
            FOR FIRST RowObject EXCLUSIVE-LOCK
                WHERE RowObject.num-di-ems      = RowObjectAcomp.num-di-ems
                  AND RowObject.cdn-pto-control = RowObjectAcomp.cdn-pto-control
                  AND RowObject.cdd-siscomex-dts = RowObjectAcomp.cdd-siscomex-dts:

                /* Se o ponto estiver efetivado a sequància n∆o pode ser alterada */
                IF RowObject.num-seq <> RowObjectAcomp.num-seq AND RowObject.dat-efetiva <> ? THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="54797"
                                                &ErrorType="EMS"}
                    ASSIGN l-erro = YES.                
                    RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE RowErrorsAux APPEND).
                    UNDO UPDATE_block, LEAVE UPDATE_block.
                END.

                /* Verifica se o registro n∆o existe para ent∆o criar */
                IF NOT CAN-FIND(FIRST {&tableName}
                                WHERE {&tableName}.num-di-ems = RowObject.num-di-ems
                                  AND {&tableName}.num-seq    = RowObjectAcomp.num-seq
                                  AND {&tablename}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) AND
                   NOT CAN-FIND(FIRST {&tableName}
                                WHERE {&tableName}.num-di-ems = RowObject.num-di-ems
                                  AND {&tableName}.cdn-pto-control = RowObject.cdn-pto-control
                                  AND {&tablename}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
                    EMPTY TEMP-TABLE RowObjectAcompAux.
                    CREATE RowObjectAcompAux.
                    BUFFER-COPY RowObject TO RowObjectAcompAux.
                    ASSIGN RowObjectAcompAux.num-seq = RowObjectAcomp.num-seq. /* Altera a sequància */

                    CREATE {&tableName}.
                    BUFFER-COPY RowObjectAcompAux TO {&tableName}.
                END.
            END.
        END.

        /* Se n∆o ocorreu nenhum erro na atualiaá∆o das sequàncias da DI, atualiza o historico de embarques (im0055) */
        IF NOT l-erro AND NOT CAN-FIND(FIRST RowErrors
                                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RUN setRecalcula IN THIS-PROCEDURE (INPUT YES).
            RUN pi-atualiza-dat-ult-previsao.
            RUN updateSeqHistoricoEmbarques IN THIS-PROCEDURE (INPUT TABLE RowObjectAcomp).
        END.
    END.

    RUN emptyRowErrors IN THIS-PROCEDURE.
    FOR EACH RowErrorsAux:
        CREATE RowErrors.
        BUFFER-COPY RowErrorsAux TO RowErrors.
    END.

    RETURN IF l-erro THEN "NOK":U ELSE "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

