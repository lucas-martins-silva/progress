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
{include/i-prgvrs.i BOCX00463 2.00.00.015} /*** "010015" 07/10/2024 16:59:54 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00463
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-item-draw
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
{cxbo/bocx00463.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.


/* Definiá∆o de vari†veis */
DEFINE VARIABLE de-cdd-due-ems     AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-num-versao-due   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-num-seq-it-due   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-idi-sit-siscomex AS INTEGER NO-UNDO.
DEFINE VARIABLE h-bocx00464        AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx00460        AS HANDLE  NO-UNDO.

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
         HEIGHT             = 2
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
        WHEN "cod-ato-concessor":U THEN ASSIGN pFieldValue = RowObject.cod-ato-concessor.
        WHEN "cod-cnpj":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-ncm":U THEN ASSIGN pFieldValue = RowObject.cod-ncm.
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
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "qtd-utlzad":U THEN ASSIGN pFieldValue = RowObject.qtd-utlzad.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-vmle-com-cobert":U THEN ASSIGN pFieldValue = RowObject.val-vmle-com-cobert.
        WHEN "val-vmle-sem-cobert":U THEN ASSIGN pFieldValue = RowObject.val-vmle-sem-cobert.
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
        WHEN "idi-tip-ato-concessor":U THEN ASSIGN pFieldValue = RowObject.idi-tip-ato-concessor.
        WHEN "num-item-ato-concessor":U THEN ASSIGN pFieldValue = RowObject.num-item-ato-concessor.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-it-draw":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-draw.
        WHEN "num-seq-it-due":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-due.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dtmdrw_id1
  Parameters:  
               retorna valor do campo cdd-due-ems
               retorna valor do campo num-versao-due
               retorna valor do campo num-seq-it-due
               retorna valor do campo num-seq-it-draw
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-item-draw.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-versao-due LIKE due-item-draw.num-versao-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-due LIKE due-item-draw.num-seq-it-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-draw LIKE due-item-draw.num-seq-it-draw NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems
           pnum-versao-due = RowObject.num-versao-due
           pnum-seq-it-due = RowObject.num-seq-it-due
           pnum-seq-it-draw = RowObject.num-seq-it-draw.

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
        WHEN "log-expdor-beneficiario":U THEN ASSIGN pFieldValue = RowObject.log-expdor-beneficiario.
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
  Purpose:     Reposiciona registro com base no °ndice dtmdrw_id1
  Parameters:  
               recebe valor do campo cdd-due-ems
               recebe valor do campo num-versao-due
               recebe valor do campo num-seq-it-due
               recebe valor do campo num-seq-it-draw
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems     LIKE due-item-draw.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER pnum-versao-due  LIKE due-item-draw.num-versao-due  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due  LIKE due-item-draw.num-seq-it-due  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-draw LIKE due-item-draw.num-seq-it-draw NO-UNDO.

    FIND FIRST bfdue-item-draw WHERE 
        bfdue-item-draw.cdd-due-ems = pcdd-due-ems AND 
        bfdue-item-draw.num-versao-due = pnum-versao-due AND 
        bfdue-item-draw.num-seq-it-due = pnum-seq-it-due AND 
        bfdue-item-draw.num-seq-it-draw = pnum-seq-it-draw NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-item-draw THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-item-draw)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDU-E DBOProgram 
PROCEDURE openQueryOfDU-E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                                WHERE {&TABLENAME}.cdd-due-ems    = de-cdd-due-ems  
                                  AND {&TABLENAME}.num-versao-due = i-num-versao-due 
                                   BY {&TABLENAME}.num-seq-it-due INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySeqItDrawNF DBOProgram 
PROCEDURE openQuerySeqItDraw:
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todas os itens de Drawback, utilizado 
               no browser "Ato Concess¢rio" do folder "Drawback" do EX7000b
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE {&tablename}.cdd-due-ems     = de-cdd-due-ems    
         AND   {&tablename}.num-versao-due  = i-num-versao-due 
         AND   {&tablename}.num-seq-it-due  = i-num-seq-it-due 
         INDEXED-REPOSITION .
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeleteOfDUE DBOProgram 
PROCEDURE piDeleteOfDUE:
/*------------------------------------------------------------------------------
Purpose:     Elimina os registros da tabela pela chave da due-siscomex
             Utilizado no programa EX7000C quando usu†rio confirma eliminaá∆o
               dos dados de Drawback
  Parameters:  pde-cdd-due-ems (decimal): N£mero Interno da DU-E   (entrada)
               pnum-versao-due (integer): N£mero da Vers∆o da DU-E (entrada)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems     LIKE due-item-draw-nf.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due LIKE due-item-draw-nf.num-versao-due NO-UNDO.

    FOR EACH {&TableName}
        WHERE {&TableName}.cdd-due-ems    = pcdd-due-ems    
          AND {&TableName}.num-versao-due = p-num-versao-due EXCLUSIVE-LOCK:
        DELETE {&TableName}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesvinculaItemDrawDUE DBOProgram 
PROCEDURE piDesvinculaItemDrawDUE :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina os registros referente a item de drawback quando desvincula a NF da DU-E 
  Parameters:  p-cdd-due-ems    : N£mero interno da DU-E - (input)(integer)
               p-num-versao-due : N£mero da vers∆o da DU-E - (input)(integer)
               p-num-seq-it-due: Sequància do Item da DU-e - (input integer)
       
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item-draw.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item-draw.num-versao-due NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-due  LIKE due-item-draw.num-seq-it-due NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx00464) THEN DO:
        RUN cxbo/bocx00464.p PERSISTENT SET h-bocx00464.
    END.

    RUN openQueryStatic IN h-bocx00464 (INPUT "main":U) NO-ERROR.

    FOR EACH bfdue-item-draw
       WHERE bfdue-item-draw.cdd-due-ems    = p-cdd-due-ems 
         AND bfdue-item-draw.num-versao-due = p-num-versao-due
         AND bfdue-item-draw.num-seq-it-due = p-num-seq-it-due EXCLUSIVE-LOCK:

        RUN piDesvinculaItemDrawNF IN h-bocx00464 (INPUT bfdue-item-draw.cdd-due-ems,
                                                   INPUT bfdue-item-draw.num-versao-due,
                                                   INPUT bfdue-item-draw.num-seq-it-due,
                                                   INPUT bfdue-item-draw.num-seq-it-draw).

        DELETE bfdue-item-draw.
    END.

    IF VALID-HANDLE(h-bocx00464) THEN DO:
        DELETE PROCEDURE h-bocx00464.
        ASSIGN h-bocx00464 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaItemRelacionamento DBOProgram 
PROCEDURE piValidaItemRelacionamento  :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se ao menos um item da DU-E possui informaá‰es de Drawback
               Procedure utilizada no ValidateRecord dos itens da DU-E (bocx00460)
  Parameters:  pde-cdd-due-ems (decimal): N£mero Interno da DU-E   (entrada)
               pnum-versao-due (integer): N£mero da Vers∆o da DU-E (entrada)
               pi-cod-enquad1-due (integer): Primeiro enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad2-due (integer): Segundo enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad3-due (integer): Terceiro enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad4-due (integer): Quarto enquadramento da operaá∆o do item da DU-E (entrada)
               pl-dados-draw (logical): Identifica se existem dados de Drawback para algum item da DU-E (sa°da)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-rowid-due-item   AS   ROWID                        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad1-due  LIKE due-item.cod-enquad-1        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad2-due  LIKE due-item.cod-enquad-2        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad3-due  LIKE due-item.cod-enquad-3        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad4-due  LIKE due-item.cod-enquad-4        NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-dados-draw       AS   LOGICAL                      NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-tipo-dado        AS   CHARACTER                    NO-UNDO.

    /*Caso o usu†rio tenha informado Enquadramento de Drawback porÇm no item j† exista a mesma informaá∆o, 
        n∆o deve emitir mensagem para eliminar os dados dos itens*/
    FOR FIRST due-item
        WHERE ROWID(due-item) = pr-rowid-due-item NO-LOCK:
        
        IF (   pi-cod-enquad1-due = 81101 
            OR pi-cod-enquad2-due = 81101 
            OR pi-cod-enquad3-due = 81101 
            OR pi-cod-enquad4-due = 81101 
           ) THEN DO:
    
            IF ((due-item.cod-enquad-1 = pi-cod-enquad1-due)
            OR  (due-item.cod-enquad-2 = pi-cod-enquad2-due)
            OR  (due-item.cod-enquad-3 = pi-cod-enquad3-due)
            OR  (due-item.cod-enquad-4 = pi-cod-enquad4-due))
            AND CAN-FIND(FIRST due-item-draw
                         WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems
                           AND due-item-draw.num-versao-due = due-item.num-versao-due
                           AND due-item-draw.num-seq-it-due = due-item.num-seq-it-due
                           AND due-item-draw.idi-tip-ato-concessor >= 1 AND due-item-draw.idi-tip-ato-concessor <= 8) THEN DO:
                ASSIGN pl-dados-draw = NO
                       pc-tipo-dado  = "":U.
            END.
            ELSE DO:
                /*Se foi informado Enquadramento de Drawback Suspens∆o, porÇm existem informaá‰es referentes ao Drawback Isená∆o*/
                IF CAN-FIND(FIRST due-item-draw
                            WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems
                              AND due-item-draw.num-versao-due = due-item.num-versao-due
                              AND due-item-draw.num-seq-it-due = due-item.num-seq-it-due
                              AND due-item-draw.idi-tip-ato-concessor >= 9 AND due-item-draw.idi-tip-ato-concessor <= 10) THEN DO:
                    {utp/ut-liter.i Isená∆o *}
                    ASSIGN pl-dados-draw = YES
                           pc-tipo-dado  = RETURN-VALUE.
                END.
            END.
        END.
        ELSE DO:
            IF (   pi-cod-enquad1-due = 81105 
                OR pi-cod-enquad2-due = 81105 
                OR pi-cod-enquad3-due = 81105 
                OR pi-cod-enquad4-due = 81105 
               ) THEN DO:
    
                IF ((due-item.cod-enquad-1 = pi-cod-enquad1-due)
                OR  (due-item.cod-enquad-2 = pi-cod-enquad2-due)
                OR  (due-item.cod-enquad-3 = pi-cod-enquad3-due)
                OR  (due-item.cod-enquad-4 = pi-cod-enquad4-due))
                AND CAN-FIND(FIRST due-item-draw
                             WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems
                               AND due-item-draw.num-versao-due = due-item.num-versao-due
                               AND due-item-draw.num-seq-it-due = due-item.num-seq-it-due
                               AND due-item-draw.idi-tip-ato-concessor >= 9 AND due-item-draw.idi-tip-ato-concessor <= 10) THEN DO:
                    ASSIGN pl-dados-draw = NO
                           pc-tipo-dado  = "":U.
                END.
                ELSE DO:
                    /*Se foi informado Enquadramento de Drawback Isená∆o, porÇm existem informaá‰es referentes ao Drawback Suspens∆o*/
                    IF CAN-FIND(FIRST due-item-draw
                                WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems
                                  AND due-item-draw.num-versao-due = due-item.num-versao-due
                                  AND due-item-draw.num-seq-it-due = due-item.num-seq-it-due
                                  AND due-item-draw.idi-tip-ato-concessor >= 1 AND due-item-draw.idi-tip-ato-concessor <= 8) THEN DO:
                        {utp/ut-liter.i Suspens∆o *}
                        ASSIGN pl-dados-draw = YES
                               pc-tipo-dado  = RETURN-VALUE.
                    END.
                END.
            END.
            ELSE DO:
                IF NOT ((pi-cod-enquad1-due = 81101 OR pi-cod-enquad1-due = 81105)
                OR (pi-cod-enquad2-due = 81101 OR pi-cod-enquad2-due = 81105)
                OR (pi-cod-enquad3-due = 81101 OR pi-cod-enquad3-due = 81105)
                OR (pi-cod-enquad4-due = 81101 OR pi-cod-enquad4-due = 81105))
                AND NOT CAN-FIND(FIRST due-item-draw
                                 WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems    
                                   AND due-item-draw.num-versao-due = due-item.num-versao-due 
                                   AND due-item-draw.num-seq-it-due = due-item.num-seq-it-due) THEN
                    ASSIGN pl-dados-draw = NO
                           pc-tipo-dado  = "".

                ELSE
                    ASSIGN pl-dados-draw = CAN-FIND(FIRST due-item-draw
                                                    WHERE due-item-draw.cdd-due-ems    = due-item.cdd-due-ems    
                                                      AND due-item-draw.num-versao-due = due-item.num-versao-due )
                          pc-tipo-dado   = "":U.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaItemDraw DBOProgram 
PROCEDURE piVerificaItemDraw :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se ao menos um item da DU-E possui informaá‰es de Drawback
               Procedure utilizada no facilitador de preenchimento de dados da DU-E (EX7000c)
  Parameters:  pde-cdd-due-ems (decimal): N£mero Interno da DU-E   (entrada)
               pnum-versao-due (integer): N£mero da Vers∆o da DU-E (entrada)
               pi-cod-enquad1-due (integer): Primeiro enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad2-due (integer): Segundo enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad3-due (integer): Terceiro enquadramento da operaá∆o do item da DU-E (entrada)
               pi-cod-enquad4-due (integer): Quarto enquadramento da operaá∆o do item da DU-E (entrada)
               pl-dados-draw (logical): Identifica se existem dados de Drawback para algum item da DU-E (sa°da)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems        LIKE due-item-draw.cdd-due-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-versao-due     LIKE due-item-draw.num-versao-due NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad1-due  LIKE due-item.cod-enquad-1        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad2-due  LIKE due-item.cod-enquad-2        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad3-due  LIKE due-item.cod-enquad-3        NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-enquad4-due  LIKE due-item.cod-enquad-4        NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-dados-draw       AS   LOGICAL                      NO-UNDO.

    DEFINE VARIABLE c-tipo-dado AS CHARACTER   NO-UNDO.

    FOR EACH due-item
       WHERE due-item.cdd-due-ems    = pcdd-due-ems
         AND due-item.num-versao-due = pnum-versao-due NO-LOCK:

        RUN piValidaItemRelacionamento IN THIS-PROCEDURE (INPUT ROWID(due-item),
                                                          INPUT pi-cod-enquad1-due,
                                                          INPUT pi-cod-enquad2-due,
                                                          INPUT pi-cod-enquad3-due,
                                                          INPUT pi-cod-enquad4-due,
                                                          OUTPUT pl-dados-draw,
                                                          OUTPUT c-tipo-dado).
        IF pl-dados-draw THEN
            LEAVE.

    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaTpAtoConcessor DBOProgram  
PROCEDURE piVerificaTpAtoConcessor :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se existe informaá‰es de Drawback na DU-E que sejam do 
               tipo Isená∆o e/ou Isená∆o Intermedi†rio
  Parameters:  pcdd-due-ems   : recebe valor do campo cdd-due-ems
               pnum-versao-due: recebe valor do campo num-versao-due
               pl-tp-ato-isencao: retorna se existe item de drawback do tipo Isená∆o/Isená∆o Intermedi†rio para a DU-E
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems      LIKE due-item-draw.cdd-due-ems     NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-versao-due   LIKE due-item-draw.num-versao-due  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-tp-ato-isencao AS   LOGICAL    INITIAL NO         NO-UNDO.

    ASSIGN pl-tp-ato-isencao = CAN-FIND(FIRST due-item-draw
                                        WHERE due-item-draw.cdd-due-ems    = pcdd-due-ems   
                                          AND due-item-draw.num-versao-due = pnum-versao-due
                                          AND (due-item-draw.idi-tip-ato-concessor <> 9 AND due-item-draw.idi-tip-ato-concessor <> 10)).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDU-E DBOProgram 
PROCEDURE setConstraintOfDU-E :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari†veis para utilizaªío na query "openQueryOfDU-E"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pd-cdd-due-ems    AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao-due AS INTEGER NO-UNDO.

    ASSIGN de-cdd-due-ems   = pd-cdd-due-ems   
           i-num-versao-due = pi-num-versao-due.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintBySeqItDraw DBOProgram 
PROCEDURE setConstraintBySeqItDraw:
/*------------------------------------------------------------------------------
  Purpose:     Seta vari†veis para utilizaá∆o no openQuerySeqItDraw
  Parameters:  Entrada: p-cdd-due-ems    : C¢digo interno da DU-E (decimal) 
                        p-num-versao-due : Vers∆o da DU-E         (integer) 
                        p-num-seq-it-due : Seq Item da DU-E       (integer)  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item-draw.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item-draw.num-versao-due  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-due  LIKE due-item-draw.num-seq-it-due  NO-UNDO.

    ASSIGN de-cdd-due-ems    = p-cdd-due-ems
           i-num-versao-due  = p-num-versao-due
           i-num-seq-it-due  = p-num-seq-it-due.

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
    
    DEFINE VARIABLE c-lb-trad  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lb-trad2 AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    FOR FIRST due-siscomex
        WHERE due-siscomex.cdd-due-ems    = RowObject.cdd-due-ems
          AND due-siscomex.num-versao-due = RowObject.num-versao-due:
        ASSIGN i-idi-sit-siscomex = due-siscomex.idi-sit-siscomex.
    END.

    IF pType = "Create"
    OR pType = "Update" THEN DO:
    
        IF rowObject.idi-tip-ato-concessor = 0 THEN DO:
            {utp/ut-liter.i Tipo_do_Ato_Concess¢rio *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
        END.
    
        IF NOT rowObject.log-expdor-beneficiario THEN DO:
            /*Necess†rio informar as notas fiscas de venda
              Realizar validaá∆o quando realizar as alteraá‰es no browse  
            */ 
        END.
        
        IF rowObject.cod-ato-concessor = "" THEN DO:
            {utp/ut-liter.i Nr_Ato_Concess¢rio *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
        
        IF rowObject.cod-cnpj = "" THEN DO:
            {utp/ut-liter.i CNPJ_Benefici†rio *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
    
        IF rowObject.cod-ncm = "" THEN DO:
            {utp/ut-liter.i NCM_do_Item *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
        IF NOT CAN-FIND(FIRST classif-fisc
                        WHERE classif-fisc.class-fiscal = rowObject.cod-ncm) THEN DO:
            {utp/ut-liter.i NCM_informada_n∆o_est†_cadastrada_(CD0603_-_Manutená∆o_Classificaá∆o_Fiscal) *}
            ASSIGN c-lb-trad = TRIM(RETURN-VALUE).
            {utp/ut-table.i mgind classif-fisc 1}
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="trim(return-value) + '~~~~' + c-lb-trad"}
        END.
    
        IF rowObject.qtd-utlzad = 0 THEN DO:
            {utp/ut-liter.i Quantidade_Utilizada *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
    
        IF rowObject.val-vmle-com-cobert = 0 THEN DO:
            {utp/ut-liter.i VMLE_Com_Cobertura_Cambial *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
    
        /*Validaá‰es Drawback Isená∆o */
        RUN piValidaDrawbackIsencao IN THIS-PROCEDURE.

        IF i-idi-sit-siscomex <> 12 THEN DO: /*12 = Averbada*/
            IF rowObject.num-item-ato-concessor = 0 THEN DO:
                {utp/ut-liter.i Nr_Item_do_Ato_Concess¢rio *}
                ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
                ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
        
                {method/svc/errors/inserr.i
                                    &ErrorNumber="55962"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
        
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDrawbackDueEnvio DBOProgram 
PROCEDURE piValidaDrawbackDueEnvio :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es executadas no envio da DU-E.
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
               pi-num-seq-it-due (Entrada): N£mero da sequencia do item da DU-E (Inteiro).
               RowErrors (Sa°da): Temp-table de erros - (Temp-Table) 
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcdd-due-ems       LIKE due-item-draw.cdd-due-ems    NO-UNDO.
 DEFINE INPUT  PARAMETER pi-num-versao      LIKE due-item-draw.num-versao-due NO-UNDO.
 DEFINE INPUT  PARAMETER pi-num-seq-it-due  LIKE due-item-draw.num-seq-it-due NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

 DEFINE VARIABLE c-lb-trad  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE c-lb-trad2 AS CHARACTER NO-UNDO.
 
 RUN setConstraintOfDU-E IN THIS-PROCEDURE (INPUT pcdd-due-ems,
                                            INPUT pi-num-versao).

 RUN openQueryStatic IN THIS-PROCEDURE (INPUT "OfDU-E":U) NO-ERROR.
 
 IF CAN-FIND (FIRST bf2due-item-draw 
              WHERE bf2due-item-draw.cdd-due-ems    = pcdd-due-ems 
                AND bf2due-item-draw.num-versao-due = pi-num-versao 
                AND bf2due-item-draw.num-seq-it-due = pi-num-seq-it-due) THEN DO:
                    
     RUN emptyRowErrors IN THIS-PROCEDURE.
     FOR EACH bf2due-item-draw
        WHERE bf2due-item-draw.cdd-due-ems    = pcdd-due-ems     
          AND bf2due-item-draw.num-versao-due = pi-num-versao    
          AND bf2due-item-draw.num-seq-it-due = pi-num-seq-it-due NO-LOCK:
                             
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf2due-item-draw)).
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN validateRecord IN THIS-PROCEDURE (INPUT "CREATE":U).
        END.
     END.
 END. 
 ELSE DO:
    {utp/ut-liter.i Tipo_do_Ato_Concess¢rio *}
    ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
    ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ato_Concess¢rio_(AC)*}

    {method/svc/errors/inserr.i
                        &ErrorNumber="55962"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(pi-num-seq-it-due)"}
 END.

 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaSeq DBOProgram 
PROCEDURE piProximaSeq :
/*------------------------------------------------------------------------------
  Purpose:     Sugere pr¢xima sequencia do item de drawback da DU-E
  Parameters:   Entrada:    p-cdd-due-ems    : CΩdigo interno da DU-E (decimal)
                            p-num-versao-due : Vers∆o da DU-E         (integer)
                            p-num-seq-it-due : Seq Item da DU-E       (integer)
                Sa°da p-next-seq: pr¢xima numeraá∆o sugerida pelo sistema (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdd-due-ems     LIKE bf{&TableName}.cdd-due-ems        NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-versao-due  LIKE bf{&TableName}.num-versao-due     NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq-it-due  LIKE bf{&TableName}.num-seq-it-due     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-next-seq        LIKE bf{&TableName}.num-seq-it-draw    NO-UNDO.

    FIND LAST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdd-due-ems     = p-cdd-due-ems    
          AND bf{&TableName}.num-versao-due  = p-num-versao-due 
          AND bf{&TableName}.num-seq-it-due  = p-num-seq-it-due NO-ERROR.
    IF NOT AVAIL bf{&TableName} THEN
        ASSIGN p-next-seq = 1.
    ELSE 
        ASSIGN p-next-seq = bf{&TableName}.num-seq-it-draw + 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDrawbackIsencao DBOProgram 
PROCEDURE piValidaDrawbackIsencao :
/*:T------------------------------------------------------------------------------
  Purpose:     Validar num-item-ato-concessor Drawback Isencao
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
               pi-idi-sit-siscomex (Saida): situaá∆o da DU-E (Inteiro).
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-lb-trad  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lb-trad2 AS CHARACTER NO-UNDO.

    IF i-idi-sit-siscomex                = 12 AND /*Averbada*/
      (rowObject.log-expdor-beneficiario = NO AND 
       rowObject.idi-tip-ato-concessor   = 9) OR 
      (rowObject.idi-tip-ato-concessor   = 10) THEN DO:
   
        IF rowObject.num-item-ato-concessor = 0 THEN DO:
            {utp/ut-liter.i Nr_Item_do_Ato_Concess¢rio *}
            ASSIGN c-lb-trad  = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_for_informado_c¢digo_de_enquadramento_de_Drawback *}
            ASSIGN c-lb-trad2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Ato_Concess¢rio_(AC)*}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="55962"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lb-trad + '~~~~' + c-lb-trad2 + '~~~~' + trim(return-value) + '~~~~' + string(rowObject.num-seq-it-due)"}
    
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
