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
{include/i-prgvrs.i BOIN00915 2.00.00.006 } /*** "010006" 27/10/2023 17:03:40  ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00915
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName sub-proces-cq
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
{inbo/boin00915.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-copy{&TableName} FOR {&TableName}.
/*:T--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE c-ep-codigo           LIKE sub-proces-cq.ep-codigo       NO-UNDO.
DEFINE VARIABLE c-cod-estabel         LIKE sub-proces-cq.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-area-produc     LIKE sub-proces-cq.cod-area-produc NO-UNDO.
DEFINE VARIABLE c-cod-proces          LIKE sub-proces-cq.cod-proces      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-des     LIKE sub-proces-cq.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-area-produc-des LIKE sub-proces-cq.cod-area-produc NO-UNDO.
DEFINE VARIABLE c-cod-proces-des      LIKE sub-proces-cq.cod-proces      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini     LIKE {&TableName}.cod-estabel      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim     LIKE {&TableName}.cod-estabel      NO-UNDO.
DEFINE VARIABLE c-cod-area-ini        LIKE {&TableName}.cod-area-produc  NO-UNDO.
DEFINE VARIABLE c-cod-area-fim        LIKE {&TableName}.cod-area-produc  NO-UNDO.
DEFINE VARIABLE c-cod-proces-ini      LIKE {&TableName}.cod-proces       NO-UNDO.
DEFINE VARIABLE c-cod-proces-fim      LIKE {&TableName}.cod-proces       NO-UNDO.
DEFINE VARIABLE c-cod-sub-proces-ini  LIKE {&TableName}.cod-sub-proces   NO-UNDO.
DEFINE VARIABLE c-cod-sub-proces-fim  LIKE {&TableName}.cod-sub-proces   NO-UNDO.

DEFINE VARIABLE hShowMsg              AS HANDLE                          NO-UNDO.
DEFINE VARIABLE h-boin916             AS HANDLE                          NO-UNDO.
{inbo/boin00915.i tt-sub-proces-cq}
{inbo/boin00915.i tt-copy-sub-proces-cq}
{inbo/boin00915.i tt-query-sub-proces}
DEFINE TEMP-TABLE tt-erro-subProces NO-UNDO
    FIELD c-subproces LIKE sub-proces-cq.cod-sub-proces.

DEFINE TEMP-TABLE tt-copy-proces NO-UNDO
    FIELD c-ep-codigo-ori LIKE sub-proces-cq.ep-codigo 
    FIELD c-ep-codigo-des LIKE sub-proces-cq.ep-codigo
    FIELD c-cod-estab-ori LIKE sub-proces-cq.cod-estabel
    FIELD c-cod-estab-des LIKE sub-proces-cq.cod-estabel
    FIELD c-cod-area-ori  LIKE sub-proces-cq.cod-area-produc
    FIELD c-cod-area-des  LIKE sub-proces-cq.cod-area-produc
    FIELD c-cod-proc-ori  LIKE sub-proces-cq.cod-proces
    FIELD c-cod-proc-des  LIKE sub-proces-cq.cod-proces
    FIELD c-cod-sub-proc  LIKE sub-proces-cq.cod-sub-proces.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.79
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyAllSubProcessos DBOProgram 
PROCEDURE copyAllSubProcessos :
/*------------------------------------------------------------------------------
  Purpose:     Busca todos os registros da Processo pai para o processo filho
  Parameters:  p-ep-codigo-ori         = Empresa
               p-cod-estabel-ori       = Estabelecimento
               p-cod-area-produc-ori   = µrea de Produá∆o
               p-cod-proces-ori        = Processo
               p-ep-codigo-des         = Empresa Destino
               p-cod-estabel-des       = Estabelecimento Destino
               p-cod-area-produc-des   = µrea de Produá∆o Destino
               p-cod-proces-des        = Processo Destino
               p-copy-exames           = Copia Exames
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ep-codigo-ori       LIKE sub-proces-cq.ep-codigo       NO-UNDO.        
    DEFINE INPUT PARAMETER p-cod-estabel-ori     LIKE sub-proces-cq.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-produc-ori LIKE sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces-ori      LIKE sub-proces-cq.cod-proces      NO-UNDO.
    DEFINE INPUT PARAMETER p-ep-codigo-des       LIKE sub-proces-cq.ep-codigo       NO-UNDO.        
    DEFINE INPUT PARAMETER p-cod-estabel-des     LIKE sub-proces-cq.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-produc-des LIKE sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces-des      LIKE sub-proces-cq.cod-proces      NO-UNDO.
    DEFINE INPUT PARAMETER p-copy-exames         AS LOGICAL                         NO-UNDO.

    EMPTY TEMP-TABLE tt-sub-proces-cq.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ep-codigo        = p-ep-codigo-ori
        AND   bf{&TableName}.cod-estabel      = p-cod-estabel-ori
        AND   bf{&TableName}.cod-area-produc  = p-cod-area-produc-ori
        AND   bf{&TableName}.cod-proces       = p-cod-proces-ori:

        /*Copia todos os registros para inserir na nova tabela*/

        CREATE tt-sub-proces-cq.
        BUFFER-COPY bf{&TableName} EXCEPT bf{&TableName}.ep-codigo
                                          bf{&TableName}.cod-estabel
                                          bf{&TableName}.cod-area-produc
                                          bf{&TableName}.cod-proces TO tt-sub-proces-cq.

        ASSIGN tt-sub-proces-cq.ep-codigo       = p-ep-codigo-des      
               tt-sub-proces-cq.cod-estabel     = p-cod-estabel-des    
               tt-sub-proces-cq.cod-area-produc = p-cod-area-produc-des
               tt-sub-proces-cq.cod-proces      = p-cod-proces-des.
    END.

    /*Cria os registros na tabela filho*/

    RUN copySubProcessos IN THIS-PROCEDURE (INPUT TABLE tt-sub-proces-cq,
                                            OUTPUT TABLE tt-erro-subProces).

    /*Se vier marcado para copiar os exames, ent∆o chamar a bo para copiar*/
    IF p-copy-exames = TRUE THEN DO:        
        FOR EACH tt-sub-proces-cq:
             FIND FIRST tt-erro-subProces NO-LOCK
                 WHERE tt-erro-subProces.c-subproces = tt-sub-proces-cq.cod-sub-proces NO-ERROR.
             IF NOT AVAIL tt-erro-subProces THEN DO:                 
                 CREATE tt-copy-proces.
                 ASSIGN tt-copy-proces.c-ep-codigo-ori = p-ep-codigo-ori
                        tt-copy-proces.c-ep-codigo-des = p-ep-codigo-des           
                        tt-copy-proces.c-cod-estab-ori = p-cod-estabel-ori
                        tt-copy-proces.c-cod-estab-des = p-cod-estabel-des         
                        tt-copy-proces.c-cod-area-ori  = p-cod-area-produc-ori
                        tt-copy-proces.c-cod-area-des  = p-cod-area-produc-des     
                        tt-copy-proces.c-cod-proc-ori  = p-cod-proces-ori
                        tt-copy-proces.c-cod-proc-des  = p-cod-proces-des          
                        tt-copy-proces.c-cod-sub-proc  = tt-sub-proces-cq.cod-sub-proces. 
             END.
        END.

        /* Cria a tt para copiar os exames*/
        IF CAN-FIND (FIRST tt-copy-proces) THEN DO:
            IF NOT VALID-HANDLE(h-boin916) THEN DO:
                RUN inbo/boin00916.p PERSISTENT SET h-boin916.
            END.
            RUN openQueryStatic IN h-boin916 (INPUT "Main":U).
            RUN copyExames IN h-boin916 (INPUT TABLE tt-copy-proces).
            IF VALID-HANDLE(h-boin916) THEN DO:
                DELETE PROCEDURE h-boin916.
                ASSIGN h-boin916 = ?.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copySubProcessos DBOProgram 
PROCEDURE copySubProcessos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para copiar os subprocessos de origem para o destino
  Parameters:  tt-sub-proces-cq - Temp-table com os subProcessos a serem copiados
               tt-erro-subProces - Temp-table que retorna os subprocessos que j† existem.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-sub-proces-cq.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro-subProces.

    EMPTY TEMP-TABLE tt-erro-subProces.
    FOR EACH tt-sub-proces-cq NO-LOCK:
        /*Se n∆o existir o subprocesso ent∆o cria*/
        FIND FIRST bf-copy{&TableName} NO-LOCK
            WHERE bf-copy{&TableName}.ep-codigo       = tt-sub-proces-cq.ep-codigo      
            AND   bf-copy{&TableName}.cod-estabel     = tt-sub-proces-cq.cod-estabel    
            AND   bf-copy{&TableName}.cod-area-produc = tt-sub-proces-cq.cod-area-produc
            AND   bf-copy{&TableName}.cod-proces      = tt-sub-proces-cq.cod-proces     
            AND   bf-copy{&TableName}.cod-sub-proces  = tt-sub-proces-cq.cod-sub-proces NO-ERROR.
        IF NOT AVAIL bf-copy{&TableName} THEN DO:
            EMPTY TEMP-TABLE tt-copy-sub-proces-cq.
            CREATE tt-copy-sub-proces-cq.
            BUFFER-COPY tt-sub-proces-cq TO tt-copy-sub-proces-cq.
            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN setRecord IN THIS-PROCEDURE (INPUT TABLE tt-copy-sub-proces-cq). 
            RUN createRecord IN THIS-PROCEDURE.
        END.
        ELSE DO:
            CREATE tt-erro-subProces.
            ASSIGN tt-erro-subProces.c-subProces = bf-copy{&TableName}.cod-sub-proces.
        END.
    END.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    FOR EACH tt-erro-subProces NO-LOCK:
        /*Cria a tt-error*/
         {method/svc/errors/inserr.i
                   &ErrorNumber="54134" 
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="tt-erro-subProces.c-subProces"}
    END.

    run getRowErrors in THIS-PROCEDURE (OUTPUT TABLE RowErrors ).

     /*Se algum Subprocesso j† est† no processo destino deve mostrar ao final do processamento ao usu†rio*/
     IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:

         /*run getRowErrors in THIS-PROCEDURE (OUTPUT TABLE RowErrors ).*/

         session:set-wait-state("":U).

         if  can-find(first RowErrors) then  do:
    
            {method/showmessage.i1}
    
            /*--- Seta cursor do mouse para normal ---*/
            SESSION:SET-WAIT-STATE("":U).
    
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
    
            wait-for close of hShowMsg.
    
         end.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-area-produc":U THEN ASSIGN pFieldValue = RowObject.cod-area-produc.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-grp-mapa":U THEN ASSIGN pFieldValue = RowObject.cod-grp-mapa.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-proces":U THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "cod-sub-proces":U THEN ASSIGN pFieldValue = RowObject.cod-sub-proces.
        WHEN "des-sub-proces":U THEN ASSIGN pFieldValue = RowObject.des-sub-proces.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice sbprcscq_id2
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-area-produc
               retorna valor do campo cod-proces
               retorna valor do campo cod-sub-proces
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE sub-proces-cq.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE sub-proces-cq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-area-produc LIKE sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-proces LIKE sub-proces-cq.cod-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-sub-proces LIKE sub-proces-cq.cod-sub-proces NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-area-produc = RowObject.cod-area-produc
           pcod-proces = RowObject.cod-proces
           pcod-sub-proces = RowObject.cod-sub-proces.

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
  Purpose:     Reposiciona registro com base no °ndice sbprcscq_id2
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-area-produc
               recebe valor do campo cod-proces
               recebe valor do campo cod-sub-proces
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE sub-proces-cq.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE sub-proces-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-area-produc LIKE sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-proces LIKE sub-proces-cq.cod-proces NO-UNDO.
    DEFINE INPUT PARAMETER pcod-sub-proces LIKE sub-proces-cq.cod-sub-proces NO-UNDO.

    FIND FIRST bfsub-proces-cq WHERE 
        bfsub-proces-cq.ep-codigo = pep-codigo AND 
        bfsub-proces-cq.cod-estabel = pcod-estabel AND 
        bfsub-proces-cq.cod-area-produc = pcod-area-produc AND 
        bfsub-proces-cq.cod-proces = pcod-proces AND 
        bfsub-proces-cq.cod-sub-proces = pcod-sub-proces NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsub-proces-cq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsub-proces-cq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToproces-cq DBOProgram 
PROCEDURE linkToproces-cq :
/*------------------------------------------------------------------------------
  Purpose:     Faz o link entre a tabela pai e o browser
  Parameters:  pHandle - Handle que est† sendo utilizado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    DEFINE VARIABLE c-codigo      LIKE proces-cq.ep-codigo       NO-UNDO.             
    DEFINE VARIABLE c-estabel     LIKE proces-cq.cod-estabel     NO-UNDO.         
    DEFINE VARIABLE c-area-produc LIKE proces-cq.cod-area-produc NO-UNDO. 
    DEFINE VARIABLE c-proces      LIKE proces-cq.cod-proces      NO-UNDO.           

    RUN getKey IN pHandle (OUTPUT c-codigo,
                           OUTPUT c-estabel,
                           OUTPUT c-area-produc,
                           OUTPUT c-proces).

    RUN setConstraintSubProcessos IN THIS-PROCEDURE (INPUT c-codigo,
                                                     INPUT c-estabel,
                                                     INPUT c-area-produc,
                                                     INPUT c-proces).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuerySubProcessos DBOProgram 
PROCEDURE OpenQuerySubProcessos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.ep-codigo        = c-ep-codigo      
        AND   {&TableName}.cod-estabel      = c-cod-estabel    
        AND   {&TableName}.cod-area-produc  = c-cod-area-produc
        AND   {&TableName}.cod-proces       = c-cod-proces          NO-LOCK.

  


    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryZoom DBOProgram 
PROCEDURE OpenQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.cod-estabel      >=  c-cod-estabel-ini     
        AND   {&TableName}.cod-estabel      <=  c-cod-estabel-fim     
        AND   {&TableName}.cod-area-produc  >=  c-cod-area-ini        
        AND   {&TableName}.cod-area-produc  <=  c-cod-area-fim        
        AND   {&TableName}.cod-proces       >=  c-cod-proces-ini      
        AND   {&TableName}.cod-proces       <=  c-cod-proces-fim     
        AND   {&TableName}.cod-sub-proces   >=  c-cod-sub-proces-ini  
        AND   {&TableName}.cod-sub-proces   <=  c-cod-sub-proces-fim NO-LOCK.
    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParamZoom DBOProgram 
PROCEDURE setConstraintParamZoom :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para abertura do Zoom
  Parameters:  p-cod-estabel-ini    - Estabelecimento Inicial
               p-cod-estabel-fim    - Estabelecimento Final
               p-cod-area-ini       - Area de Produá∆o Inicial
               p-cod-area-ini       - Area de Produá∆o Final
               p-cod-proces-ini     - Processo Inicial
               p-cod-proces-ini     - Processo Final
               p-cod-sub-proces-ini - SubProcesso Inicial
               p-cod-sub-proces-ini - SubProcesso Final
  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel-ini    LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim    LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-ini       LIKE {&TableName}.cod-area-produc   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-fim       LIKE {&TableName}.cod-area-produc   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces-ini     LIKE {&TableName}.cod-proces        NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces-fim     LIKE {&TableName}.cod-proces        NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-sub-proces-ini LIKE {&TableName}.cod-sub-proces    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-sub-proces-fim LIKE {&TableName}.cod-sub-proces    NO-UNDO.

    ASSIGN c-cod-estabel-ini    = p-cod-estabel-ini   
           c-cod-estabel-fim    = p-cod-estabel-fim   
           c-cod-area-ini       = p-cod-area-ini      
           c-cod-area-fim       = p-cod-area-fim
           c-cod-proces-ini     = p-cod-proces-ini    
           c-cod-proces-fim     = p-cod-proces-fim
           c-cod-sub-proces-ini = p-cod-sub-proces-ini
           c-cod-sub-proces-fim = p-cod-sub-proces-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSubProcessos DBOProgram 
PROCEDURE setConstraintSubProcessos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para passar os parÉmetros de filtro para filtrar todos
               os subprocessos do processo.
  Parameters:  p-ep-codigo           - Empresa
               p-cod-estabel         - Estabelecimento
               p-cod-area-produc     - µrea de Produá∆o
               p-cod-proces          - Processo               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ep-codigo           LIKE sub-proces-cq.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel         LIKE sub-proces-cq.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-produc     LIKE sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces          LIKE sub-proces-cq.cod-proces      NO-UNDO.
    
    ASSIGN c-ep-codigo           = p-ep-codigo
           c-cod-estabel         = p-cod-estabel
           c-cod-area-produc     = p-cod-area-produc
           c-cod-proces          = p-cod-proces.

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
    
    /*:T--- Verifica ocorrància de erros ---*/       

    IF pType = "Create":U THEN DO:           
        IF RowObject.cod-sub-proces = "" THEN DO:
            {utp/ut-liter.i "Subprocesso" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="688" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.                

        IF CAN-FIND (FIRST sub-proces-cq 
                     WHERE  sub-proces-cq.ep-codigo       = RowObject.ep-codigo      
                     AND    sub-proces-cq.cod-estabel     = RowObject.cod-estabel    
                     AND    sub-proces-cq.cod-area-produc = RowObject.cod-area-produc
                     AND    sub-proces-cq.cod-proces      = RowObject.cod-proces     
                     AND    sub-proces-cq.cod-sub-proces  = RowObject.cod-sub-proces) THEN DO:
    
            DEFINE VARIABLE c-subProces AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i "SubProcesso" *}
            ASSIGN c-subProces = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Processo" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="31724" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-subProces + '~~~~' + 
                                         TRIM(RETURN-VALUE) + '~~~~' +
                                         c-subProces"}
        END.
    END.
    
    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF RowObject.des-sub-proces = "" THEN DO:
            {utp/ut-liter.i "Descriá∆o_do_subprocesso" *}
            {method/svc/errors/inserr.i
                                           &ErrorNumber="688" 
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.    
    END.
    ELSE DO:
        IF CAN-FIND (FIRST exam-sub-proces-cq
                 WHERE exam-sub-proces-cq.ep-codigo                 = RowObject.ep-codigo      
                 AND   exam-sub-proces-cq.cod-estabel           = RowObject.cod-estabel    
                 AND   exam-sub-proces-cq.cod-area-produc       = RowObject.cod-area-produc
                 AND   exam-sub-proces-cq.cod-proces            = RowObject.cod-proces     
                 AND   exam-sub-proces-cq.cod-sub-proces        = RowObject.cod-sub-proces) THEN DO:
            DEFINE VARIABLE c-subproces-delete AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i Subprocesso *}
            ASSIGN c-subproces-delete = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Possui_exames_vinculados *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="25129" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-subproces-delete + '~~~~' + 
                                         TRIM(RETURN-VALUE) + '.'"}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

